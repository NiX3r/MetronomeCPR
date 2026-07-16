using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Position;
using Toybox.Lang;

//! The running-metronome screen. Two pages, switched with UP/DOWN:
//!   Page 0 (beat)  — big beat indicator, PUSH/BREATHE cue, count, elapsed.
//!   Page 1 (info)  — time CPR started, GPS lat/lon, and MGRS coordinates.
//! The rhythm is driven by Metronome's own timer, so it keeps running (and
//! beeping/vibrating) no matter which page is shown or how often you switch.
class MetronomeView extends Ui.View {

    public const PAGE_COUNT = 2;

    hidden var _metro;
    hidden var _page;
    hidden var _posInfo;   // latest Position.Info, or null until a fix arrives

    function initialize(metro) {
        View.initialize();
        _metro = metro;
        _page = 0;
        _posInfo = null;
    }

    //! Start receiving location updates while the running screen is visible.
    function onShow() {
        if (Position has :enableLocationEvents) {
            Position.enableLocationEvents(Position.LOCATION_CONTINUOUS, method(:onPosition));
        }
    }

    //! Leaving the screen: stop the rhythm and location updates.
    function onHide() {
        _metro.stop();
        if (Position has :enableLocationEvents) {
            Position.enableLocationEvents(Position.LOCATION_DISABLE, method(:onPosition));
        }
    }

    //! Position callback.
    function onPosition(loc as Position.Info) as Void {
        _posInfo = loc;
        Ui.requestUpdate();
    }

    // ── Paging (called from the delegate) ────────────────────────────────
    function nextPage() {
        _page = (_page + 1) % PAGE_COUNT;
        Ui.requestUpdate();
    }
    function prevPage() {
        _page = (_page + PAGE_COUNT - 1) % PAGE_COUNT;
        Ui.requestUpdate();
    }

    function onUpdate(dc) {
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
        dc.clear();
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);

        if (_page == 1) {
            drawInfoPage(dc);
        } else {
            drawBeatPage(dc);
        }
        drawPageDots(dc);
    }

    // ── Page 0: the metronome ────────────────────────────────────────────
    hidden function drawBeatPage(dc) {
        var w = dc.getWidth();
        var h = dc.getHeight();
        var cx = w / 2;
        var mode = _metro.getMode();

        dc.drawText(cx, h * 0.06, Gfx.FONT_SMALL, mode.label, Gfx.TEXT_JUSTIFY_CENTER);

        if (!_metro.isRunning()) {
            dc.drawText(cx, h * 0.40, Gfx.FONT_MEDIUM, "Press START", Gfx.TEXT_JUSTIFY_CENTER);
            dc.drawText(cx, h * 0.58, Gfx.FONT_TINY,
                        mode.ratePerMin.toString() + "/min", Gfx.TEXT_JUSTIFY_CENTER);
            return;
        }

        var isComp = (_metro.getLastEvent() == CprMode.EVENT_COMPRESSION);

        var r = w * 0.15;
        var beatY = h * 0.37;
        if (isComp) {
            dc.fillCircle(cx, beatY, r);
        } else {
            dc.setPenWidth(4);
            dc.drawCircle(cx, beatY, r);
        }

        dc.drawText(cx, h * 0.58, Gfx.FONT_SMALL,
                    isComp ? "PUSH" : "BREATHE", Gfx.TEXT_JUSTIFY_CENTER);

        dc.drawText(cx, h * 0.73, Gfx.FONT_TINY,
                    _metro.compressionsThisCycle().toString() + " / " + mode.compressions.toString(),
                    Gfx.TEXT_JUSTIFY_CENTER);

        dc.drawText(cx, h * 0.85, Gfx.FONT_XTINY, formatElapsed(), Gfx.TEXT_JUSTIFY_CENTER);
    }

    // ── Page 1: start time + location ────────────────────────────────────
    hidden function drawInfoPage(dc) {
        var w = dc.getWidth();
        var h = dc.getHeight();
        var cx = w / 2;

        var startStr = _metro.startTimeStr();
        dc.drawText(cx, h * 0.05, Gfx.FONT_SMALL,
                    "Start " + (startStr == null ? "--:--" : startStr), Gfx.TEXT_JUSTIFY_CENTER);

        if (hasFix()) {
            var deg = _posInfo.position.toDegrees() as Lang.Array<Lang.Double>;   // [lat, lon]
            dc.drawText(cx, h * 0.28, Gfx.FONT_XTINY,
                        "Lat " + deg[0].format("%.5f"), Gfx.TEXT_JUSTIFY_CENTER);
            dc.drawText(cx, h * 0.40, Gfx.FONT_XTINY,
                        "Lon " + deg[1].format("%.5f"), Gfx.TEXT_JUSTIFY_CENTER);

            dc.drawText(cx, h * 0.57, Gfx.FONT_XTINY, "MGRS", Gfx.TEXT_JUSTIFY_CENTER);
            dc.drawText(cx, h * 0.67, Gfx.FONT_XTINY,
                        _posInfo.position.toGeoString(Position.GEO_MGRS), Gfx.TEXT_JUSTIFY_CENTER);
        } else {
            dc.drawText(cx, h * 0.42, Gfx.FONT_TINY, "Acquiring GPS…", Gfx.TEXT_JUSTIFY_CENTER);
        }
    }

    //! Two dots at the bottom: filled = current page.
    hidden function drawPageDots(dc) {
        var w = dc.getWidth();
        var h = dc.getHeight();
        var cx = w / 2;
        var y = h * 0.95;
        for (var i = 0; i < PAGE_COUNT; i++) {
            var x = cx + (i * 2 - 1) * 8;   // -8, +8 for two pages
            if (i == _page) {
                dc.fillCircle(x, y, 3);
            } else {
                dc.setPenWidth(1);
                dc.drawCircle(x, y, 3);
            }
        }
    }

    hidden function hasFix() {
        return (_posInfo != null)
            && (_posInfo.position != null)
            && (_posInfo.accuracy != Position.QUALITY_NOT_AVAILABLE);
    }

    hidden function formatElapsed() {
        var secs = _metro.elapsedMs() / 1000;
        var mm = secs / 60;
        var ss = secs % 60;
        return mm.format("%d") + ":" + ss.format("%02d");
    }
}
