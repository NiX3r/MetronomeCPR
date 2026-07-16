using Toybox.Lang;

//! Describes one CPR patient type and the rhythm the metronome should produce.
//!
//! The metronome fires one "beat" every `intervalMs`. Within a repeating cycle
//! the first `compressions` beats are chest compressions and the remaining
//! `ventilations` beats are breath/ventilation cues. See docs/CPR-REFERENCE.md
//! for the guideline sources behind these numbers.
class CprMode {

    // Beat event types.
    enum {
        EVENT_COMPRESSION = 0,
        EVENT_VENTILATION = 1
    }

    public var key;          // Symbol identifier, e.g. :adult
    public var label;        // Display name
    public var intervalMs;   // Milliseconds between beats
    public var compressions; // Compressions per cycle
    public var ventilations; // Ventilations per cycle
    public var ratePerMin;   // Nominal beats/min (for display)

    function initialize(k, lbl, interval, comp, vent, rate) {
        key = k;
        label = lbl;
        intervalMs = interval;
        compressions = comp;
        ventilations = vent;
        ratePerMin = rate;
    }

    //! Total beats in one full compression:ventilation cycle.
    function cycleLength() {
        return compressions + ventilations;
    }

    //! Event type for a given 0-based beat index within a cycle.
    function eventTypeAt(indexInCycle) {
        return (indexInCycle < compressions) ? EVENT_COMPRESSION : EVENT_VENTILATION;
    }

    // ── Factory helpers ──────────────────────────────────────────────────
    // Adult / Child: 100-120/min, 30:2. We use 110/min (60000/110 = 545 ms).
    // Newborn (neonatal): 3:1 at 120 events/min (90 comp + 30 breaths); 500 ms.

    static function adult() as CprMode {
        return new CprMode(:adult, "Adult", 545, 30, 2, 110);
    }

    static function child() as CprMode {
        return new CprMode(:child, "Child", 545, 30, 2, 110);
    }

    static function newborn() as CprMode {
        return new CprMode(:newborn, "Newborn", 500, 3, 1, 120);
    }

    //! All modes in menu order.
    static function all() as Lang.Array<CprMode> {
        return [adult(), child(), newborn()];
    }

    //! Look up a mode by its Symbol key; returns null if not found.
    static function byKey(k) as CprMode or Null {
        var modes = all();
        for (var i = 0; i < modes.size(); i++) {
            if (modes[i].key == k) {
                return modes[i];
            }
        }
        return null;
    }
}
