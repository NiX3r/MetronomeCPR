using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Position;
using Toybox.Lang;

//! The running-metronome screen. Two pages, switched with UP/DOWN:
//!   Page 0 (beat)  — big beat indicator, PUSH/BREATHE cue, count, elapsed.
//!   Page 1 (info)  — time CPR started, GPS lat/lon, and MGRS coordinates.
//! Element positions come from a per-device Layout so the UI fits each watch;
//! on the Instinct the small top-right sub-display shows the elapsed timer.
//! The rhythm is driven by Metronome's own timer, so it keeps running (and
//! beeping/vibrating) no matter which page is shown or how often you switch.
class MetronomeView extends Ui.View {

    public const PAGE_COUNT = 2;

    hidden var _metro;
    hidden var _layout;
    hidden var _page;
    hidden var _posInfo;   // latest Position.Info, or null until a fix arrives

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
        var L = _layout;
        var mode = _metro.getMode();

        dc.drawText(L.titleCx, L.titleY, Gfx.FONT_SMALL, mode.label, Gfx.TEXT_JUSTIFY_CENTER);

        if (!_metro.isRunning()) {
            dc.drawText(L.mainCx, L.beatCy - 12, Gfx.FONT_MEDIUM, "Press START", Gfx.TEXT_JUSTIFY_CENTER);
            dc.drawText(L.mainCx, L.cueY, Gfx.FONT_TINY,
                        mode.ratePerMin.toString() + "/min", Gfx.TEXT_JUSTIFY_CENTER);
            return;
        }

        var isComp = (_metro.getLastEvent() == CprMode.EVENT_COMPRESSION);

        if (isComp) {
            dc.fillCircle(L.beatCx, L.beatCy, L.beatR);
        } else {
            dc.setPenWidth(4);
            dc.drawCircle(L.beatCx, L.beatCy, L.beatR);
        }

        dc.drawText(L.mainCx, L.cueY, Gfx.FONT_SMALL,
                    isComp ? "PUSH" : "BREATHE", Gfx.TEXT_JUSTIFY_CENTER);

        dc.drawText(L.mainCx, L.countY, Gfx.FONT_TINY,
                    _metro.compressionsThisCycle().toString() + " / " + mode.compressions.toString(),
                    Gfx.TEXT_JUSTIFY_CENTER);

        drawElapsed(dc);
    }

    // ── Page 1: start time + location ────────────────────────────────────
    hidden function drawInfoPage(dc) {
        var L = _layout;

        var startStr = _metro.startTimeStr();
        dc.drawText(L.mainCx, L.infoStartY, Gfx.FONT_SMALL,
                    "Start " + (startStr == null ? "--:--" : startStr), Gfx.TEXT_JUSTIFY_CENTER);

        if (hasFix()) {
            var deg = _posInfo.position.toDegrees() as Lang.Array<Lang.Double>;   // [lat, lon]
            dc.drawText(L.mainCx, L.infoLatY, Gfx.FONT_XTINY,
                        "Lat " + deg[0].format("%.5f"), Gfx.TEXT_JUSTIFY_CENTER);
            dc.drawText(L.mainCx, L.infoLonY, Gfx.FONT_XTINY,
                        "Lon " + deg[1].format("%.5f"), Gfx.TEXT_JUSTIFY_CENTER);
            dc.drawText(L.mainCx, L.mgrsLabelY, Gfx.FONT_XTINY, "MGRS", Gfx.TEXT_JUSTIFY_CENTER);
            dc.drawText(L.mainCx, L.mgrsValueY, Gfx.FONT_XTINY,
                        _posInfo.position.toGeoString(Position.GEO_MGRS), Gfx.TEXT_JUSTIFY_CENTER);
        } else {
            dc.drawText(L.mainCx, L.infoAcqY, Gfx.FONT_TINY, "Acquiring GPS…", Gfx.TEXT_JUSTIFY_CENTER);
        }

        // How to stop (single presses are blocked to avoid accidental stops).
        var stopHint = L.isTouch ? "Stop: hold screen" : "Stop: hold 2 buttons";
        dc.drawText(L.mainCx, L.hintY, Gfx.FONT_XTINY, stopHint, Gfx.TEXT_JUSTIFY_CENTER);

        drawElapsed(dc);
    }

    //! Elapsed time — in the sub-display on Instinct, otherwise a bottom line.
    hidden function drawElapsed(dc) {
        var L = _layout;
        if (!_metro.isRunning()) { return; }
        var t = formatElapsed();
        if (L.hasSub) {
            dc.setPenWidth(1);
            dc.drawCircle(L.subCx, L.subCy, L.subR);
            dc.drawText(L.subCx, L.subCy, Gfx.FONT_XTINY, t,
                        Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);
        } else {
            dc.drawText(L.mainCx, L.elapsedY, Gfx.FONT_XTINY, t, Gfx.TEXT_JUSTIFY_CENTER);
        }
    }

    //! Two dots at the bottom: filled = current page.
    hidden function drawPageDots(dc) {
        var L = _layout;
        for (var i = 0; i < PAGE_COUNT; i++) {
            var x = L.mainCx + (i * 2 - 1) * 8;   // -8, +8 for two pages
            if (i == _page) {
                dc.fillCircle(x, L.dotsY, 3);
            } else {
                dc.setPenWidth(1);
                dc.drawCircle(x, L.dotsY, 3);
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
