using Toybox.Timer;
using Toybox.Attention;
using Toybox.WatchUi as Ui;
using Toybox.System;

//! Drives the CPR rhythm: a repeating timer that fires beats and produces
//! tone / vibration feedback, while tracking position within the
//! compression:ventilation cycle for the UI to display.
class Metronome {

    hidden var _mode;
    hidden var _timer;
    hidden var _running;
    hidden var _beatInCycle;   // 0-based beat index within the current cycle
    hidden var _cycleCount;    // number of completed cycles
    hidden var _lastEvent;     // most recent event type
    hidden var _startMs;       // session start (ms), 0 when never started
    hidden var _useTone;
    hidden var _useVibe;

    function initialize(mode, useTone, useVibe) {
        _mode = mode;
        _useTone = useTone;
        _useVibe = useVibe;
        _timer = new Timer.Timer();
        resetState();
    }

    hidden function resetState() {
        _running = false;
        _beatInCycle = 0;
        _cycleCount = 0;
        _lastEvent = CprMode.EVENT_COMPRESSION;
        _startMs = 0;
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

    // ── Control ──────────────────────────────────────────────────────────
    function start() {
        if (_running) { return; }
        resetState();
        _running = true;
        _startMs = System.getTimer();
        onBeat();                                    // instant first beat
        _timer.start(method(:onBeat), _mode.intervalMs, true);
    }

    function stop() {
        if (!_running) { return; }
        _timer.stop();
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

    //! Produce tone and/or vibration, guarded by device capability so the
    //! same build runs on watches lacking a speaker or vibration motor.
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
    }
}
