using Toybox.System;

//! Per-device screen geometry. Different Garmin watches have very different
//! displays, so the running screen asks a Layout where to place each element
//! instead of assuming a plain centered square.
//!
//! Implemented so far:
//!   - Instinct 2 family (semi-octagon 176×176 with the small round sub-display
//!     in the top-right) — content is kept clear of the sub-display, and the
//!     sub-display itself is used for the elapsed timer.
//!   - A generic centered fallback for any other device (added later).
class Layout {

    public var w;
    public var h;

    // Small round sub-display (Instinct). hasSub == false on plain screens.
    public var hasSub;
    public var subCx;
    public var subCy;
    public var subR;

    // Beat page
    public var titleCx;   // mode-label center x (kept left of the sub-display)
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

        if (ds.screenShape == System.SCREEN_SHAPE_SEMI_OCTAGON && w == 176 && h == 176) {
            initInstinct2();
        } else {
            initGeneric();
        }
    }

    //! Instinct 2 family — avoid the top-right sub-display at (144, 32) r31.
    hidden function initInstinct2() {
        hasSub = true;
        subCx = 144;  subCy = 32;  subR = 31;

        mainCx = 88;
        titleCx = 55;  titleY = 6;      // top-left, left of the sub-display
        beatCx = 84;   beatCy = 84;  beatR = 26;   // right edge (110) clears sub (113)
        cueY = 116;    countY = 140;  dotsY = 170;
        elapsedY = 0;                   // elapsed goes in the sub-display instead

        infoStartY = 66;                // first info row sits below the sub-display
        infoLatY = 90;   infoLonY = 105;  infoAcqY = 100;
        mgrsLabelY = 121;  mgrsValueY = 135;  hintY = 151;
    }

    //! Generic centered layout for other devices (round/rectangular).
    hidden function initGeneric() {
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
}
