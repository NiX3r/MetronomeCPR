using Toybox.WatchUi as Ui;

//! On-device settings. Each item cycles its value when selected, updates its own
//! sub-label, and persists to the same properties used by the phone settings.
class SettingsMenu extends Ui.Menu2 {

    function initialize() {
        Menu2.initialize({:title => Ui.loadResource(Rez.Strings.SettingsTitle)});

        addItem(new Ui.MenuItem(
            Ui.loadResource(Rez.Strings.SettingFeedback),
            Settings.feedbackLabel(Settings.feedbackMode()), :feedback, null));

        addItem(new Ui.MenuItem(
            Ui.loadResource(Rez.Strings.SettingRate),
            Settings.compressionRate().toString() + "/min", :rate, null));

        addItem(new Ui.MenuItem(
            Ui.loadResource(Rez.Strings.SettingCompressions),
            Settings.compressionsPerCycle().toString(), :comp, null));

        addItem(new Ui.MenuItem(
            Ui.loadResource(Rez.Strings.SettingVentilations),
            Settings.ventilationsPerCycle().toString(), :vent, null));
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

        } else if (id == :rate) {
            var r = Settings.compressionRate() + 5;   // cycle 100..120 in 5s
            if (r > 120) { r = 100; }
            Settings.setValue("compressionRate", r);
            item.setSubLabel(r.toString() + "/min");

        } else if (id == :comp) {
            var c = (Settings.compressionsPerCycle() == 30) ? 15 : 30; // 30:2 <-> 15:2
            Settings.setValue("compressionsPerCycle", c);
            item.setSubLabel(c.toString());

        } else if (id == :vent) {
            var v = Settings.ventilationsPerCycle() + 1;               // cycle 0..3
            if (v > 3) { v = 0; }
            Settings.setValue("ventilationsPerCycle", v);
            item.setSubLabel(v.toString());
        }

        Ui.requestUpdate();
    }

    function onBack() {
        Ui.popView(Ui.SLIDE_RIGHT);
    }
}
