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
    }
}

//! Handles selection in the patient-type menu.
class ModeMenuDelegate extends Ui.Menu2InputDelegate {

    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item) {
        var mode = CprMode.byKey(item.getId());
        if (mode == null) {
            return;
        }
        // Default feedback: tone + vibration (both, capability-guarded at play time).
        var metro = new Metronome(mode, true, true);
        Ui.pushView(new MetronomeView(metro), new MetronomeDelegate(metro), Ui.SLIDE_LEFT);
    }

    function onBack() {
        Ui.popView(Ui.SLIDE_RIGHT);
    }
}
