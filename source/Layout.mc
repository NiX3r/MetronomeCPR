using Toybox.System;

//! Per-device screen description. Different Garmin watches have very different
//! displays, so the running screen asks a Layout about the device instead of
//! assuming a plain centered square. The detailed element placement lives in
//! MetronomeView (one arrangement for the Instinct sub-display screens, one
//! generic centered arrangement for everything else).
class Layout {

    public var w;
    public var h;

    // Small round sub-display (Instinct family). hasSub == false on plain screens.
    public var hasSub;
    public var subCx;
    public var subCy;
    public var subR;

    function initialize() {
        var ds = System.getDeviceSettings();
        w = ds.screenWidth;
        h = ds.screenHeight;

        // Instinct 2 family: semi-octagon 176x176 with a top-right sub-display.
        // Match on the shape OR the exact size so the layout can't silently
        // fall back to the generic centered arrangement on this hardware.
        var semiOctagon = (ds.screenShape == System.SCREEN_SHAPE_SEMI_OCTAGON);
        if (semiOctagon || (w == 176 && h == 176)) {
            hasSub = true;
            subCx = 144;  subCy = 32;  subR = 31;
        } else {
            hasSub = false;
            subCx = 0;  subCy = 0;  subR = 0;
        }
    }
}
