using Toybox.Timer;
using Toybox.Attention;
using Toybox.WatchUi as Ui;
using Toybox.System;

//! Drives the CPR rhythm: a repeating timer that fires beats and produces
//! tone / vibration / light feedback, while tracking position within the
//! compression:ventilation cycle for the UI to display.
class Metronome {

    //! How long the light stays on for each blink (ms). Short enough to be a
    //! crisp strobe against the ~545 ms beat interval, long enough to see.
    const FLASH_MS = 120;

    hidden var _mode;
    hidden var _timer;
    hidden var _flashTimer;    // one-shot: turns the light back off after a blink
    hidden var _running;
    hidden var _beatInCycle;   // 0-based beat index within the current cycle
    hidden var _cycleCount;    // number of completed cycles
    hidden var _lastEvent;     // most recent event type
    hidden var _startMs;       // session start (ms), 0 when never started
    hidden var _startHour;     // wall-clock hour at start, -1 when never started
    hidden var _startMin;      // wall-clock minute at start
    hidden var _useTone;
    hidden var _useVibe;
    hidden var _useFlash;

    function initialize(mode, useTone, useVibe, useFlash) {
        _mode = mode;
        _useTone = useTone;
        _useVibe = useVibe;
        _useFlash = useFlash;
        _timer = new Timer.Timer();
        _flashTimer = new Timer.Timer();
        resetState();
    }

    hidden function resetState() {
        _running = false;
        _beatInCycle = 0;
        _cycleCount = 0;
        _lastEvent = CprMode.EVENT_COMPRESSION;
        _startMs = 0;
        _startHour = -1;
        _startMin = -1;
    }

    // ── Queries used by the view ─────────────────────────────────────────
    function isRunning()   { return _running; }
    function getMode()     { return _mode; }
    function getLastEvent(){ return _lastEvent; }
    function getCycleCount(){ return _cycleCount; }

    //! Compressions completed so far in the current cycle (for "n / 30").
    function compressionsThisCycle() {
        return (_beatInCycle > _mode.compressions) ? _mode.compressions : _beatInCycle;
    }

    //! Elapsed session time in milliseconds.
    function elapsedMs() {
        return (_startMs == 0) ? 0 : (System.getTimer() - _startMs);
    }

    //! Wall-clock time CPR was started, as "HH:MM" (24h); null if never started.
    function startTimeStr() {
        if (_startHour < 0) { return null; }
        return _startHour.format("%02d") + ":" + _startMin.format("%02d");
    }

    // ── Control ──────────────────────────────────────────────────────────
    function start() {
        if (_running) { return; }
        resetState();
        _running = true;
        _startMs = System.getTimer();
        var c = System.getClockTime();               // snapshot wall-clock start time
        _startHour = c.hour;
        _startMin = c.min;
        onBeat();                                    // instant first beat
        _timer.start(method(:onBeat), _mode.intervalMs, true);
    }

    function stop() {
        if (!_running) { return; }
        _timer.stop();
        _flashTimer.stop();
        lightOff();               // never leave the light stuck on
        _running = false;
    }

    function toggle() {
        if (_running) { stop(); } else { start(); }
    }

    //! Timer callback: emit the current beat, advance the cycle position.
    function onBeat() {
        var evt = _mode.eventTypeAt(_beatInCycle);
        _lastEvent = evt;
        fireFeedback(evt);

        _beatInCycle++;
        if (_beatInCycle >= _mode.cycleLength()) {
            _beatInCycle = 0;
            _cycleCount++;
        }
        Ui.requestUpdate();
    }

    //! Produce tone, vibration and/or a light blink for this beat, each guarded
    //! by its setting and device capability so the same build runs on watches
    //! lacking a speaker, vibration motor or flashlight.
    hidden function fireFeedback(evt) {
        var isComp = (evt == CprMode.EVENT_COMPRESSION);

        if (_useTone && (Attention has :playTone)) {
            var tone = isComp ? Attention.TONE_LOUD_BEEP : Attention.TONE_ALERT_HI;
            Attention.playTone(tone);
        }
        if (_useVibe && (Attention has :vibrate)) {
            var dur = isComp ? 80 : 200;
            Attention.vibrate([new Attention.VibeProfile(75, dur)]);
        }
        if (_useFlash) {
            lightOn();
        }
    }

    //! Blink the light for one beat: turn it on now, schedule it off. Prefers
    //! the physical flashlight (e.g. Instinct 2X Solar); falls back to the
    //! screen backlight on watches without one. Both are capability-guarded and
    //! wrapped in try/catch — the flashlight can be busy or unavailable, and
    //! backlight can throw on burn-in-protected displays.
    hidden function lightOn() {
        try {
            if (Attention has :setFlashlightMode) {
                Attention.setFlashlightMode(Attention.FLASHLIGHT_MODE_ON,
                    {:brightness => Attention.FLASHLIGHT_BRIGHTNESS_HIGH});
            } else if (Attention has :backlight) {
                Attention.backlight(true);
            } else {
                return;
            }
            _flashTimer.stop();
            _flashTimer.start(method(:lightOff), FLASH_MS, false);
        } catch (e) {
            // Light unavailable this beat; skip it.
        }
    }

    //! Turn the light back off. Public so the one-shot flash timer can call it.
    function lightOff() {
        try {
            if (Attention has :setFlashlightMode) {
                Attention.setFlashlightMode(Attention.FLASHLIGHT_MODE_OFF, null);
            } else if (Attention has :backlight) {
                Attention.backlight(false);
            }
        } catch (e) {
        }
    }
}
