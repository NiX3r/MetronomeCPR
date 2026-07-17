using Toybox.System;

//! Per-device screen geometry. Different Garmin watches have very different
//! displays, so the running screen (MetronomeView) asks a Layout WHERE to place
//! each element instead of hard-coding pixels. MetronomeView never assumes a
//! shape — it only reads the fields below — so a new watch is supported purely
//! by producing the right numbers here.
//!
//! How a device is resolved, in order:
//!   1. initFamily()          — pick a base arrangement from the screen SHAPE
//!                              (Instinct semi-octagon / round / rectangular).
//!                              Every family starts from the same Instinct-derived
//!                              vertical column, scaled to the device.
//!   2. applyDeviceOverride() — optional per-watch tuning keyed on partNumber,
//!                              for when real-world feedback says one specific
//!                              model needs different numbers than its family.
//!
//! Runtime can only distinguish devices by screen geometry and partNumber (there
//! is no "which model am I" symbol), so those two steps are the whole story.
class Layout {

    public var w;
    public var h;

    // Small round sub-display (Instinct semi-octagon only). false elsewhere.
    public var hasSub;
    public var subCx;
    public var subCy;
    public var subR;

    // Beat page
    public var titleCx;   // mode-label center x (kept clear of the sub-display)
    public var titleY;
    public var beatCx;
    public var beatCy;
    public var beatR;
    public var cueY;
    public var countY;
    public var elapsedY;  // used only when there is no sub-display
    public var dotsY;
    public var mainCx;    // center x for the main text column

    // Info page rows
    public var infoStartY;
    public var infoLatY;
    public var infoLonY;
    public var infoAcqY;
    public var mgrsLabelY;
    public var mgrsValueY;
    public var hintY;

    function initialize() {
        var ds = System.getDeviceSettings();
        w = ds.screenWidth;
        h = ds.screenHeight;

        initFamily(ds.screenShape);
        applyDeviceOverride(ds.partNumber);
    }

    // ── Step 1: base arrangement by screen family ────────────────────────
    hidden function initFamily(shape) {
        // The Instinct MIP watches are semi-octagon AND carry the small round
        // sub-display in the top-right. Match on the shape so the whole Instinct
        // family (2 / 2S / 2X / E / Crossover MIP) gets the sub-display layout.
        if (shape == System.SCREEN_SHAPE_SEMI_OCTAGON) {
            initInstinct();
        } else if (shape == System.SCREEN_SHAPE_RECTANGLE) {
            initRectangular();
        } else {
            // SCREEN_SHAPE_ROUND / SEMI_ROUND and anything else: centered round.
            initRound();
        }
    }

    //! Instinct family — semi-octagon MIP watches with a small round sub-display
    //! in the top-right. Content is kept clear of the sub-display, and the sub
    //! itself shows the elapsed timer.
    //!
    //! The 176×176 numbers are the reference layout verified on the Instinct 2X
    //! Solar (and shared by the other 176 models: Instinct 2 / Crossover /
    //! 3 Solar 45 / Descent G1). Smaller Instincts (2S 163×156, E 40mm 166×166)
    //! can't reuse those absolutes — dotsY=170 falls off a 156 px screen — so
    //! they scale the same vertical column to their own height.
    hidden function initInstinct() {
        hasSub = true;
        mainCx = w / 2;
        elapsedY = 0;                                 // elapsed lives in the sub

        if (w == 176 && h == 176) {
            // Verified 176 reference — do not change without re-checking the 2X.
            subR = 31;   subCx = w - 32;   subCy = 32;
            titleCx = 55;  titleY = 6;                // top-left, left of the sub
            beatCx = 84;   beatCy = 84;   beatR = 26; // right edge (110) clears sub (113)
            cueY = 116;    countY = 140;  dotsY = 170;
            infoStartY = 66;                          // first info row below the sub
            infoLatY = 90;   infoLonY = 105;   infoAcqY = 100;
            mgrsLabelY = 121;  mgrsValueY = 135;  hintY = 151;
        } else {
            // Smaller semi-octagon: scale to fit. Sub shrinks with the screen and
            // stays in the top-right; the column keeps the 176 proportions.
            subR = (h * 0.17).toNumber();             // ~27 on 156, ~28 on 166
            subCx = w - subR - 1;
            subCy = subR + 1;
            titleCx = (w * 0.31).toNumber();
            titleY  = (h * 0.04).toNumber();
            beatCx  = (w * 0.475).toNumber();
            beatCy  = (h * 0.47).toNumber();
            beatR   = (w * 0.15).toNumber();
            cueY    = (h * 0.65).toNumber();
            countY  = (h * 0.78).toNumber();
            dotsY   = (h * 0.92).toNumber();
            infoStartY = (h * 0.40).toNumber();       // clears the (smaller) sub
            infoLatY   = (h * 0.53).toNumber();
            infoLonY   = (h * 0.62).toNumber();
            infoAcqY   = (h * 0.58).toNumber();
            mgrsLabelY = (h * 0.71).toNumber();
            mgrsValueY = (h * 0.80).toNumber();
            hintY      = (h * 0.88).toNumber();
        }
    }

    //! Round watches (fenix / Forerunner / Venu-round / vívoactive, …).
    //! Same vertical column as the Instinct, expressed as fractions of height so
    //! it scales from 208 px up to 454 px. Starts identical to the Instinct;
    //! tune per model via applyDeviceOverride() as feedback arrives.
    hidden function initRound() {
        hasSub = false;
        subCx = 0;  subCy = 0;  subR = 0;

        mainCx = w / 2;
        titleCx = w / 2;  titleY = h * 0.06;
        beatCx = w / 2;   beatCy = h * 0.37;  beatR = w * 0.15;
        cueY = h * 0.58;  countY = h * 0.73;  dotsY = h * 0.95;
        elapsedY = h * 0.85;

        infoStartY = h * 0.05;
        infoLatY = h * 0.28;  infoLonY = h * 0.40;  infoAcqY = h * 0.42;
        mgrsLabelY = h * 0.57;  mgrsValueY = h * 0.67;  hintY = h * 0.83;
    }

    //! Rectangular watches (Venu Sq, Instinct Crossover has a round face so it is
    //! NOT here). Wider than tall handling is the same column, but the fractions
    //! give a bit more vertical breathing room. Starts identical to round.
    hidden function initRectangular() {
        initRound();   // same column; kept separate so it can diverge on feedback
    }

    // ── Step 2: per-device overrides (keyed on DeviceSettings.partNumber) ──
    //! Every watch starts from its family layout above. When feedback shows a
    //! specific model needs different numbers, add a branch here — it only
    //! affects that one device and cannot regress the others.
    //!
    //! partNumber examples: Instinct 2X Solar = "006-B4394-00".
    hidden function applyDeviceOverride(partNumber) {
        if (partNumber == null) { return; }

        // The Instinct 2X Solar is the verified reference; it uses the family
        // defaults unchanged. Left here as the template for future per-device
        // tuning, e.g.:
        //
        //   if (partNumber.equals("006-XXXXX-00")) {
        //       beatCy = 90; cueY = 120; countY = 148;   // that model only
        //   }
    }
}
