using Toybox.WatchUi as Ui;
using Toybox.System;

//! Input handling on the running screen.
//!
//! CPR must not be stopped by a single accidental press, but every watch must
//! still be able to leave it. Two devices classes need different gestures:
//!
//!   START/STOP (select)  — starts the metronome; never stops it.
//!   UP / DOWN            — switch between the beat page and the info page.
//!   BACK                 — ignored while running (a single press won't exit).
//!
//! Deliberate stop, whichever the hardware allows:
//!   • Any TWO buttons held at once — works on every multi-button watch. On
//!     5-button watches (Instinct / fēnix / Forerunner) the user can pick two
//!     on opposite sides so it can't happen by accident.
//!   • Press-and-hold the touchscreen — for touch watches whose buttons are all
//!     on one side (or that have a single button), where two opposite buttons
//!     aren't possible.
//!
//! Paging only changes what is drawn; the rhythm keeps running regardless.
class MetronomeDelegate extends Ui.BehaviorDelegate {

    hidden var _metro;
    hidden var _view;
    hidden var _pressed;   // set of currently-held key codes

    function initialize(metro, view) {
        BehaviorDelegate.initialize();
        _metro = metro;
        _view = view;
        _pressed = {};
    }

    //! Raw key-down: two buttons held simultaneously is the deliberate stop.
    function onKeyPressed(evt) {
        _pressed.put(evt.getKey(), true);
        if (_metro.isRunning() && _pressed.size() >= 2) {
            stopCpr();
            return true;   // consume: don't also start / page
        }
        return false;      // single key: let the normal behavior fire
    }

    //! Raw key-up: forget the released key.
    function onKeyReleased(evt) {
        _pressed.remove(evt.getKey());
        return false;
    }

    //! Touch press-and-hold: the deliberate stop on touch watches (a plain tap
    //! does nothing). A hold is hard to trigger by accident during compressions.
    function onHold(evt) {
        if (_metro.isRunning()) {
            stopCpr();
            return true;
        }
        return false;
    }

    //! Select / START single press: start only — never stops (that needs the
    //! two-button hold or a touch hold).
    function onSelect() {
        if (!_metro.isRunning()) {
            _metro.start();
            Ui.requestUpdate();
        }
        return true;
    }

    function onNextPage() {
        _view.nextPage();
        return true;
    }

    function onPreviousPage() {
        _view.prevPage();
        return true;
    }

    //! Plain BACK must not stop a running session; use a two-button or touch hold.
    function onBack() {
        if (_metro.isRunning()) {
            return true;   // ignore
        }
        Ui.popView(Ui.SLIDE_RIGHT);
        return true;
    }

    //! End the rhythm and return to the patient-type menu.
    hidden function stopCpr() {
        _pressed = {};
        _metro.stop();
        Ui.popView(Ui.SLIDE_RIGHT);
    }
}
