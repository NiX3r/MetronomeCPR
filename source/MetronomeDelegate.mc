using Toybox.WatchUi as Ui;

//! Input handling on the running screen:
//!   START/STOP (select) toggles the metronome,
//!   UP / DOWN switch between the beat page and the info page,
//!   BACK stops it and returns to the patient-type menu.
//! Paging only changes what is drawn; the rhythm keeps running.
class MetronomeDelegate extends Ui.BehaviorDelegate {

    hidden var _metro;
    hidden var _view;

    function initialize(metro, view) {
        BehaviorDelegate.initialize();
        _metro = metro;
        _view = view;
    }

    function onSelect() {
        _metro.toggle();
        Ui.requestUpdate();
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

    function onBack() {
        _metro.stop();
        Ui.popView(Ui.SLIDE_RIGHT);
        return true;
    }
}
