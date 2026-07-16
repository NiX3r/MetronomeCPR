using Toybox.WatchUi as Ui;

//! Input handling on the running screen.
//!
//! To avoid accidentally stopping CPR, the metronome cannot be stopped with a
//! single button:
//!   START/STOP (GPS / ENTER)  — starts the metronome; does NOT stop it.
//!   UP / DOWN                 — switch between the beat page and the info page.
//!   BACK (SET / ESC)          — ignored while running (would otherwise exit).
//!   GPS + ABC held together   — the deliberate two-button stop: stops the
//!     rhythm and returns to the patient-type menu. On the Instinct 2X Solar
//!     these are on opposite sides (ENTER = GPS, DOWN = ABC), so they are hard
//!     to press by accident.
//!
//! Paging only changes what is drawn; the rhythm keeps running regardless.
class MetronomeDelegate extends Ui.BehaviorDelegate {

    hidden var _metro;
    hidden var _view;
    hidden var _enterDown;   // GPS button currently held
    hidden var _abcDown;     // ABC button currently held

    function initialize(metro, view) {
        BehaviorDelegate.initialize();
        _metro = metro;
        _view = view;
        _enterDown = false;
        _abcDown = false;
    }

    //! Raw key-down: track the two combo keys; fire the stop when both are held.
    function onKeyPressed(evt) {
        var k = evt.getKey();
        if (k == Ui.KEY_ENTER) { _enterDown = true; }
        if (k == Ui.KEY_DOWN)  { _abcDown = true; }

        if (_enterDown && _abcDown) {
            stopCombo();
            return true;   // consume: don't also start / page
        }
        return false;      // otherwise let the normal behavior fire
    }

    //! Raw key-up: clear the held state.
    function onKeyReleased(evt) {
        var k = evt.getKey();
        if (k == Ui.KEY_ENTER) { _enterDown = false; }
        if (k == Ui.KEY_DOWN)  { _abcDown = false; }
        return false;
    }

    //! GPS single press: start only — never stops (that needs the combo).
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

    //! Plain BACK must not stop a running session; use the GPS + ABC combo.
    function onBack() {
        if (_metro.isRunning()) {
            return true;   // ignore
        }
        Ui.popView(Ui.SLIDE_RIGHT);
        return true;
    }

    //! Deliberate two-button stop: end the rhythm and return to the menu.
    hidden function stopCombo() {
        _enterDown = false;
        _abcDown = false;
        _metro.stop();
        Ui.popView(Ui.SLIDE_RIGHT);
    }
}
