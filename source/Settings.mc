using Toybox.Application;
using Toybox.WatchUi as Ui;
using Toybox.Lang;

//! Central access to user settings, backed by Connect IQ app properties.
//! Values are configurable from the phone (resources/settings/settings.xml) and
//! on-device (SettingsMenu); both read/write the same property keys.
module Settings {

    // feedbackMode property values
    enum {
        FEEDBACK_BEEP    = 0,
        FEEDBACK_VIBRATE = 1,
        FEEDBACK_BOTH    = 2
    }

    function feedbackMode() {
        return clamp(readNum("feedbackMode", FEEDBACK_BOTH), 0, 2);
    }

    //! Whether tone / vibration should fire, derived from feedbackMode.
    function useTone() {
        var m = feedbackMode();
        return (m == FEEDBACK_BEEP || m == FEEDBACK_BOTH);
    }
    function useVibe() {
        var m = feedbackMode();
        return (m == FEEDBACK_VIBRATE || m == FEEDBACK_BOTH);
    }

    //! Human-readable label for a feedback mode value.
    function feedbackLabel(m) {
        if (m == FEEDBACK_BEEP)    { return Ui.loadResource(Rez.Strings.FeedbackBeep); }
        if (m == FEEDBACK_VIBRATE) { return Ui.loadResource(Rez.Strings.FeedbackVibrate); }
        return Ui.loadResource(Rez.Strings.FeedbackBoth);
    }

    function setValue(key, value) {
        Application.Properties.setValue(key, value);
    }

    function readNum(key, def) {
        var v = null;
        try {
            v = Application.Properties.getValue(key);
        } catch (e) {
            v = null;
        }
        if (v == null) { return def; }
        if (v instanceof Lang.Number) { return v; }
        if (v instanceof Lang.Float)  { return v.toNumber(); }
        if (v instanceof Lang.String) { return v.toNumber(); }
        return def;
    }

    function clamp(v, lo, hi) {
        if (v == null) { return lo; }
        if (v < lo)    { return lo; }
        if (v > hi)    { return hi; }
        return v;
    }
}
