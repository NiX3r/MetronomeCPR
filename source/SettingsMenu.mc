using Toybox.WatchUi as Ui;

//! On-device settings. Each feedback channel is an independent toggle that
//! persists to the same properties used by the phone settings.
class SettingsMenu extends Ui.Menu2 {

    function initialize() {
        Menu2.initialize({:title => Ui.loadResource(Rez.Strings.SettingsTitle)});

        // Identifiers are the property keys, so the delegate can persist directly.
        addItem(new Ui.ToggleMenuItem(
            Ui.loadResource(Rez.Strings.SettingBeep),    null, "beepOn",    Settings.useTone(),  null));
        addItem(new Ui.ToggleMenuItem(
            Ui.loadResource(Rez.Strings.SettingVibrate), null, "vibrateOn", Settings.useVibe(),  null));
        addItem(new Ui.ToggleMenuItem(
            Ui.loadResource(Rez.Strings.SettingFlash),   null, "flashOn",   Settings.useFlash(), null));
    }
}

//! Persists each toggle when it is flipped. Menu2 updates the item's own state
//! before calling onSelect, so isEnabled() is already the new value.
class SettingsMenuDelegate extends Ui.Menu2InputDelegate {

    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item) {
        var toggle = item as Ui.ToggleMenuItem;
        Settings.setValue(toggle.getId(), toggle.isEnabled());
    }

    function onBack() {
        Ui.popView(Ui.SLIDE_RIGHT);
    }
}
