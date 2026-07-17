using Toybox.Application;
using Toybox.WatchUi as Ui;
using Toybox.Lang;

//! Central access to user settings, backed by Connect IQ app properties.
//! Feedback is three independent channels — beep, vibrate, flash — any
//! combination may be on. Values are editable from the phone
//! (resources/settings/settings.xml) and on-device (SettingsMenu); both
//! read/write the same property keys.
module Settings {

    //! Whether the beat should beep (device speaker permitting).
    function useTone()  { return readBool("beepOn", true); }
    //! Whether the beat should vibrate (device motor permitting).
    function useVibe()  { return readBool("vibrateOn", true); }
    //! Whether the beat should blink the flashlight / backlight.
    function useFlash() { return readBool("flashOn", false); }

    function setValue(key, value) {
        Application.Properties.setValue(key, value);
    }

    //! Read a boolean property, tolerating the number / string forms that the
    //! phone settings or older builds may have stored.
    function readBool(key, def) {
        var v = null;
        try {
            v = Application.Properties.getValue(key);
        } catch (e) {
            v = null;
        }
        if (v == null)                 { return def; }
        if (v instanceof Lang.Boolean) { return v; }
        if (v instanceof Lang.Number)  { return v != 0; }
        if (v instanceof Lang.Float)   { return v != 0.0; }
        if (v instanceof Lang.String)  { return v.equals("true") || v.equals("1"); }
        return def;
    }
}
