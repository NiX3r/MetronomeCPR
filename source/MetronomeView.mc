using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;

//! The running-metronome screen. High-contrast, monochrome-friendly layout
//! for the Instinct 2X Solar (176x176, 1bpp): a big beat indicator plus the
//! current cue, compression count, and elapsed time.
class MetronomeView extends Ui.View {

    hidden var _metro;

    function initialize(metro) {
        View.initialize();
        _metro = metro;
    }

    //! Stop the rhythm if the screen goes away (e.g. app suspend).
    function onHide() {
        _metro.stop();
    }

    function onUpdate(dc) {
        var w = dc.getWidth();
        var h = dc.getHeight();
        var cx = w / 2;

        // Clear to black.
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
        dc.clear();
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);

        var mode = _metro.getMode();

        // Mode name (top).
        dc.drawText(cx, h * 0.04, Gfx.FONT_SMALL, mode.label, Gfx.TEXT_JUSTIFY_CENTER);

        if (!_metro.isRunning()) {
            dc.drawText(cx, h * 0.40, Gfx.FONT_MEDIUM, "Press START", Gfx.TEXT_JUSTIFY_CENTER);
            dc.drawText(cx, h * 0.58, Gfx.FONT_TINY,
                        mode.ratePerMin.toString() + "/min", Gfx.TEXT_JUSTIFY_CENTER);
            return;
        }

        // Wall-clock time CPR was started (for handover / records).
        var startStr = _metro.startTimeStr();
        if (startStr != null) {
            dc.drawText(cx, h * 0.19, Gfx.FONT_XTINY, "Start " + startStr, Gfx.TEXT_JUSTIFY_CENTER);
        }

        var isComp = (_metro.getLastEvent() == CprMode.EVENT_COMPRESSION);

        // Beat indicator: filled circle on compression, ring on ventilation.
        var r = w * 0.14;
        var beatY = h * 0.42;
        if (isComp) {
            dc.fillCircle(cx, beatY, r);
        } else {
            dc.setPenWidth(4);
            dc.drawCircle(cx, beatY, r);
        }

        // Cue word.
        dc.drawText(cx, h * 0.62, Gfx.FONT_SMALL,
                    isComp ? "PUSH" : "BREATHE", Gfx.TEXT_JUSTIFY_CENTER);

        // Compression count within the current cycle.
        dc.drawText(cx, h * 0.77, Gfx.FONT_TINY,
                    _metro.compressionsThisCycle().toString() + " / " + mode.compressions.toString(),
                    Gfx.TEXT_JUSTIFY_CENTER);

        // Elapsed time (bottom).
        dc.drawText(cx, h * 0.89, Gfx.FONT_XTINY, formatElapsed(), Gfx.TEXT_JUSTIFY_CENTER);
    }

    hidden function formatElapsed() {
        var secs = _metro.elapsedMs() / 1000;
        var mm = secs / 60;
        var ss = secs % 60;
        return mm.format("%d") + ":" + ss.format("%02d");
    }
}
