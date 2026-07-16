using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Position;
using Toybox.Lang;

//! The running-metronome screen. Two pages, switched with UP/DOWN:
//!   Page 0 (beat)  — beat indicator on the left, cue + count on the right.
//!   Page 1 (info)  — start time, GPS lat/lon (label left / value right), MGRS.
//! On the Instinct the layout spreads across the width and uses the top-right
//! sub-display for the elapsed timer; other watches get a centered layout.
//! The rhythm runs on Metronome's own timer, so it keeps beeping/vibrating no
//! matter which page is shown.
class MetronomeView extends Ui.View {

    public const PAGE_COUNT = 2;

    hidden var _metro;
    hidden var _layout;
    hidden var _page;
    hidden var _posInfo;

    function initialize(metro) {
        View.initialize();
        _metro = metro;
        _layout = new Layout();
        _page = 0;
        _posInfo = null;
    }

    function onShow() {
        if (Position has :enableLocationEvents) {
            Position.enableLocationEvents(Position.LOCATION_CONTINUOUS, method(:onPosition));
        }
    }

    function onHide() {
        _metro.stop();
        if (Position has :enableLocationEvents) {
            Position.enableLocationEvents(Position.LOCATION_DISABLE, method(:onPosition));
        }
    }

    function onPosition(loc as Position.Info) as Void {
        _posInfo = loc;
        Ui.requestUpdate();
    }

    function nextPage() { _page = (_page + 1) % PAGE_COUNT; Ui.requestUpdate(); }
    function prevPage() { _page = (_page + PAGE_COUNT - 1) % PAGE_COUNT; Ui.requestUpdate(); }

    function onUpdate(dc) {
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
        dc.clear();
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);

        if (_page == 1) {
            if (_layout.hasSub) { drawInfoInstinct(dc); } else { drawInfoGeneric(dc); }
        } else {
            if (_layout.hasSub) { drawBeatInstinct(dc); } else { drawBeatGeneric(dc); }
        }
        drawPageDots(dc);
    }

    // ── Instinct: beat page (horizontal — circle left, cue/count right) ──
    hidden function drawBeatInstinct(dc) {
        var mode = _metro.getMode();
        var CENTER = Gfx.TEXT_JUSTIFY_CENTER;
        var LEFT = Gfx.TEXT_JUSTIFY_LEFT;

        dc.drawText(10, 8, Gfx.FONT_SMALL, mode.label, LEFT);   // top-left, beside sub-display

        if (!_metro.isRunning()) {
            dc.drawText(88, 84, Gfx.FONT_MEDIUM, "Press START", CENTER);
            dc.drawText(88, 116, Gfx.FONT_TINY, mode.ratePerMin.toString() + "/min", CENTER);
            return;
        }

        var isComp = (_metro.getLastEvent() == CprMode.EVENT_COMPRESSION);

        // Beat indicator on the left.
        var bx = 52; var by = 100; var r = 32;
        if (isComp) {
            dc.fillCircle(bx, by, r);
        } else {
            dc.setPenWidth(4);
            dc.drawCircle(bx, by, r);
        }

        // Cue + count in the right column.
        dc.drawText(126, 78, Gfx.FONT_SMALL, isComp ? "PUSH" : "BREATHE", CENTER);
        dc.drawText(126, 110, Gfx.FONT_TINY,
                    _metro.compressionsThisCycle().toString() + " / " + mode.compressions.toString(),
                    CENTER);

        drawSubElapsed(dc);
    }

    // ── Instinct: info page (label left / value right across the width) ──
    hidden function drawInfoInstinct(dc) {
        var CENTER = Gfx.TEXT_JUSTIFY_CENTER;
        var LEFT = Gfx.TEXT_JUSTIFY_LEFT;
        var RIGHT = Gfx.TEXT_JUSTIFY_RIGHT;

        // Start time fills the top-left space beside the sub-display.
        var startStr = _metro.startTimeStr();
        dc.drawText(10, 10, Gfx.FONT_XTINY, "Start", LEFT);
        dc.drawText(10, 28, Gfx.FONT_SMALL, startStr == null ? "--:--" : startStr, LEFT);

        if (hasFix()) {
            var deg = _posInfo.position.toDegrees() as Lang.Array<Lang.Double>;
            dc.drawText(10, 66, Gfx.FONT_XTINY, "Lat", LEFT);
            dc.drawText(168, 66, Gfx.FONT_XTINY, deg[0].format("%.5f"), RIGHT);
            dc.drawText(10, 88, Gfx.FONT_XTINY, "Lon", LEFT);
            dc.drawText(168, 88, Gfx.FONT_XTINY, deg[1].format("%.5f"), RIGHT);
            dc.drawText(10, 114, Gfx.FONT_XTINY,
                        "MGRS " + _posInfo.position.toGeoString(Position.GEO_MGRS), LEFT);
        } else {
            dc.drawText(88, 88, Gfx.FONT_TINY, "Acquiring GPS…", CENTER);
        }

        dc.drawText(88, 148, Gfx.FONT_XTINY, "Stop: hold GPS+ABC", CENTER);
        drawSubElapsed(dc);
    }

    // ── Generic centered fallback (round / rectangular watches) ──────────
    hidden function drawBeatGeneric(dc) {
        var w = dc.getWidth(); var h = dc.getHeight(); var cx = w / 2;
        var mode = _metro.getMode();
        var CENTER = Gfx.TEXT_JUSTIFY_CENTER;

        dc.drawText(cx, h * 0.06, Gfx.FONT_SMALL, mode.label, CENTER);
        if (!_metro.isRunning()) {
            dc.drawText(cx, h * 0.40, Gfx.FONT_MEDIUM, "Press START", CENTER);
            dc.drawText(cx, h * 0.58, Gfx.FONT_TINY, mode.ratePerMin.toString() + "/min", CENTER);
            return;
        }
        var isComp = (_metro.getLastEvent() == CprMode.EVENT_COMPRESSION);
        var r = w * 0.15;
        if (isComp) { dc.fillCircle(cx, h * 0.37, r); }
        else { dc.setPenWidth(4); dc.drawCircle(cx, h * 0.37, r); }
        dc.drawText(cx, h * 0.58, Gfx.FONT_SMALL, isComp ? "PUSH" : "BREATHE", CENTER);
        dc.drawText(cx, h * 0.73, Gfx.FONT_TINY,
                    _metro.compressionsThisCycle().toString() + " / " + mode.compressions.toString(), CENTER);
        dc.drawText(cx, h * 0.85, Gfx.FONT_XTINY, formatElapsed(), CENTER);
    }

    hidden function drawInfoGeneric(dc) {
        var w = dc.getWidth(); var h = dc.getHeight(); var cx = w / 2;
        var CENTER = Gfx.TEXT_JUSTIFY_CENTER;
        var startStr = _metro.startTimeStr();
        dc.drawText(cx, h * 0.05, Gfx.FONT_SMALL, "Start " + (startStr == null ? "--:--" : startStr), CENTER);
        if (hasFix()) {
            var deg = _posInfo.position.toDegrees() as Lang.Array<Lang.Double>;
            dc.drawText(cx, h * 0.28, Gfx.FONT_XTINY, "Lat " + deg[0].format("%.5f"), CENTER);
            dc.drawText(cx, h * 0.40, Gfx.FONT_XTINY, "Lon " + deg[1].format("%.5f"), CENTER);
            dc.drawText(cx, h * 0.57, Gfx.FONT_XTINY, "MGRS", CENTER);
            dc.drawText(cx, h * 0.67, Gfx.FONT_XTINY, _posInfo.position.toGeoString(Position.GEO_MGRS), CENTER);
        } else {
            dc.drawText(cx, h * 0.42, Gfx.FONT_TINY, "Acquiring GPS…", CENTER);
        }
        dc.drawText(cx, h * 0.83, Gfx.FONT_XTINY, "Stop: hold GPS+ABC", CENTER);
    }

    //! Elapsed time inside the Instinct sub-display.
    hidden function drawSubElapsed(dc) {
        if (!_metro.isRunning()) { return; }
        var L = _layout;
        dc.setPenWidth(1);
        dc.drawCircle(L.subCx, L.subCy, L.subR);
        dc.drawText(L.subCx, L.subCy, Gfx.FONT_XTINY, formatElapsed(),
                    Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);
    }

    hidden function drawPageDots(dc) {
        var w = dc.getWidth();
        var cx = w / 2;
        var y = _layout.hasSub ? 168 : (dc.getHeight() * 0.95);
        for (var i = 0; i < PAGE_COUNT; i++) {
            var x = cx + (i * 2 - 1) * 8;
            if (i == _page) { dc.fillCircle(x, y, 3); }
            else { dc.setPenWidth(1); dc.drawCircle(x, y, 3); }
        }
    }

    hidden function hasFix() {
        return (_posInfo != null)
            && (_posInfo.position != null)
            && (_posInfo.accuracy != Position.QUALITY_NOT_AVAILABLE);
    }

    hidden function formatElapsed() {
        var secs = _metro.elapsedMs() / 1000;
        return (secs / 60).format("%d") + ":" + (secs % 60).format("%02d");
    }
}
