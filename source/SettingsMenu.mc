using Toybox.WatchUi as Ui;

//! On-device settings. Each item cycles its value when selected, updates its own
//! sub-label, and persists to the same properties used by the phone settings.
class SettingsMenu extends Ui.Menu2 {

    function initialize() {
        Menu2.initialize({:title => Ui.loadResource(Rez.Strings.SettingsTitle)});

        addItem(new Ui.MenuItem(
            Ui.loadResource(Rez.Strings.SettingFeedback),
            Settings.feedbackLabel(Settings.feedbackMode()), :feedback, null));
    }
}

//! Handles selection / value cycling in the on-device settings menu.
class SettingsMenuDelegate extends Ui.Menu2InputDelegate {

    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item) {
        var id = item.getId();

        if (id == :feedback) {
            var m = (Settings.feedbackMode() + 1) % 3;
            Settings.setValue("feedbackMode", m);
            item.setSubLabel(Settings.feedbackLabel(m));
        }

        Ui.requestUpdate();
    }

    function onBack() {
        Ui.popView(Ui.SLIDE_RIGHT);
    }
}
