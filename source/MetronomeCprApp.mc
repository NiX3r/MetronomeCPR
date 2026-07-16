using Toybox.Application as App;
using Toybox.WatchUi as Ui;

//! Application entry point. Opens the patient-type menu.
class MetronomeCprApp extends App.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    function onStart(state) {
    }

    function onStop(state) {
    }

    //! First view: the Adult / Child / Newborn picker.
    function getInitialView() {
        return [new ModeMenu(), new ModeMenuDelegate()];
    }
}
