using Toybox.WatchUi as Ui;

//! Patient-type picker shown at launch: Adult / Child / Newborn.
class ModeMenu extends Ui.Menu2 {

    function initialize() {
        Menu2.initialize({:title => Ui.loadResource(Rez.Strings.MenuTitle)});

        var modes = CprMode.all();
        for (var i = 0; i < modes.size(); i++) {
            var m = modes[i];
            addItem(new Ui.MenuItem(
                m.label,                       // label
                m.ratePerMin.toString() + "/min", // sub-label
                m.key,                         // identifier (Symbol)
                null));
        }

        // Settings entry (on-device configuration).
        addItem(new Ui.MenuItem(
            Ui.loadResource(Rez.Strings.MenuSettings), null, :settings, null));
    }
}

//! Handles selection in the patient-type menu.
class ModeMenuDelegate extends Ui.Menu2InputDelegate {

    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item) {
        var id = item.getId();

        if (id == :settings) {
            Ui.pushView(new SettingsMenu(), new SettingsMenuDelegate(), Ui.SLIDE_LEFT);
            return;
        }

        var mode = CprMode.byKey(id);
        if (mode == null) {
            return;
        }
        // Feedback (beep / vibrate / both) comes from settings; capability-guarded at play time.
        var metro = new Metronome(mode, Settings.useTone(), Settings.useVibe());
        Ui.pushView(new MetronomeView(metro), new MetronomeDelegate(metro), Ui.SLIDE_LEFT);
    }

    function onBack() {
        Ui.popView(Ui.SLIDE_RIGHT);
    }
}
