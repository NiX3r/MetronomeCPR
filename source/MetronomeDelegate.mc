using Toybox.WatchUi as Ui;

//! Input handling on the running screen:
//!   START/STOP (select) toggles the metronome,
//!   BACK stops it and returns to the patient-type menu.
class MetronomeDelegate extends Ui.BehaviorDelegate {

    hidden var _metro;

    function initialize(metro) {
        BehaviorDelegate.initialize();
        _metro = metro;
    }

    function onSelect() {
        _metro.toggle();
        Ui.requestUpdate();
        return true;
    }

    function onBack() {
        _metro.stop();
        Ui.popView(Ui.SLIDE_RIGHT);
        return true;
    }
}
