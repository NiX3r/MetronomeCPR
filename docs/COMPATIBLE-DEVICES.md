# Compatible devices

Garmin Connect IQ watches this build of **MetronomeCPR** targets. The list is generated from
[`compatible_devices.csv`](../compatible_devices.csv) and matched against the Connect IQ SDK device
set; it mirrors the `<iq:product>` entries in [`manifest.xml`](../manifest.xml).

A device is **compatible** when it runs Connect IQ **API level ≥ 3.0.0** — the floor for the
`Menu2` / `ToggleMenuItem` interface the app uses. All **120** devices below are compatible and are
declared in the manifest.

## Legend

- **Compatible** — ✅ the app is built for and declared to support this device.
- **Tested** — ✅ the running-screen **layout** (beat page + info page, incl. Lat/Lon/MGRS) was verified
  in the Connect IQ **simulator** for this device's screen geometry. The app draws from a per-geometry
  layout, so one representative per unique shape+resolution covers every device that shares it. This is
  a layout check, not a physical-hardware or feedback (beep/vibrate/flash) sign-off.
  - ᵍ = verified via a sibling of the same layout family because this device's simulator profile would
    not load; the scaled layout was confirmed on the sibling and the geometry fits.

> Feedback channels degrade gracefully per hardware: **beep** needs `Attention has :playTone`,
> **vibrate** needs `Attention has :vibrate`, **flash** uses the physical flashlight
> (`Attention has :setFlashlightMode`, e.g. Instinct 2X Solar) and otherwise the screen backlight.
> A device missing one channel simply uses the others.

## Supported devices (120)

| Device | Screen resolution | Shape | Display technology | API level | Compatible | Tested |
|--------|-------------------|-------|--------------------|-----------|:----------:|:------:|
| Approach® S50 | 390 x 390 | round | AMOLED | 5.1 | ✅ | ✅ |
| Approach® S62 | 260 x 260 | round | Memory-In-Pixel (64 colors) | 3.0 | ✅ | ✅ |
| Approach® S70 42mm | 390 x 390 | round | AMOLED | 5.1 | ✅ | ✅ |
| Approach® S70 47mm | 454 x 454 | round | AMOLED | 5.1 | ✅ | ✅ |
| Captain Marvel | 218 x 218 | round | Memory-In-Pixel (64 colors) | 3.3 | ✅ | ✅ |
| D2™ Air | 390 x 390 | round | AMOLED | 3.2 | ✅ | ✅ |
| D2™ Air X10 | 416 x 416 | round | AMOLED | 5.0 | ✅ | ✅ |
| D2™ Charlie | 240 x 240 | round | Memory-In-Pixel (64 colors) | 3.0 | ✅ | ✅ |
| D2™ Delta | 240 x 240 | round | Memory-In-Pixel (64 colors) | 3.1 | ✅ | ✅ |
| D2™ Delta PX | 240 x 240 | round | Memory-In-Pixel (64 colors) | 3.1 | ✅ | ✅ |
| D2™ Delta S | 240 x 240 | round | Memory-In-Pixel (64 colors) | 3.1 | ✅ | ✅ |
| D2™ Mach 1 | 416 x 416 | round | AMOLED | 5.2 | ✅ | ✅ |
| D2™ Mach 2 | 454 x 454 | round | AMOLED | 5.2 | ✅ | ✅ |
| D2™ Mach 2 Pro | 454 x 454 | round | AMOLED | 6.0 | ✅ | ✅ |
| Darth Vader™ | 260 x 260 | round | Memory-In-Pixel (64 colors) | 3.3 | ✅ | ✅ |
| Descent™ G1 / G1 Solar | 176 x 176 | semi-octagon | Memory-In-Pixel (2 colors) | 3.4 | ✅ | ✅ |
| Descent™ G2 | 390 x 390 | round | AMOLED | 5.1 | ✅ | ✅ |
| Descent™ Mk1 | 240 x 240 | round | Memory-In-Pixel (64 colors) | 3.1 | ✅ | ✅ |
| Descent™ Mk2 / Mk2i | 280 x 280 | round | Memory-In-Pixel (64 colors) | 3.4 | ✅ | ✅ |
| Descent™ Mk2 S | 240 x 240 | round | Memory-In-Pixel (64 colors) | 3.4 | ✅ | ✅ |
| Descent™ Mk3 43mm / Mk3i 43mm | 390 x 390 | round | AMOLED | 5.1 | ✅ | ✅ |
| Descent™ Mk3i 51mm | 454 x 454 | round | AMOLED | 5.1 | ✅ | ✅ |
| Enduro™ | 280 x 280 | round | Memory-In-Pixel (64 colors) | 3.4 | ✅ | ✅ |
| Enduro™ 3 | 280 x 280 | round | Memory-In-Pixel (64 colors) | 6.0 | ✅ | ✅ |
| epix™ (Gen 2) / quatix® 7 Sapphire | 416 x 416 | round | AMOLED | 5.2 | ✅ | ✅ |
| epix™ Pro (Gen 2) 42mm | 390 x 390 | round | AMOLED | 5.2 | ✅ | ✅ |
| epix™ Pro (Gen 2) 47mm / quatix® 7 Pro | 416 x 416 | round | AMOLED | 5.2 | ✅ | ✅ |
| epix™ Pro (Gen 2) 51mm / D2™ Mach 1 Pro / tactix® 7 – AMOLED Edition | 454 x 454 | round | AMOLED | 5.2 | ✅ | ✅ |
| fēnix® 5 / quatix® 5 | 240 x 240 | round | Memory-In-Pixel (64 colors) | 3.1 | ✅ | ✅ |
| fēnix® 5 Plus | 240 x 240 | round | Memory-In-Pixel (64 colors) | 3.3 | ✅ | ✅ |
| fēnix® 5S | 218 x 218 | round | Memory-In-Pixel (64 colors) | 3.1 | ✅ | ✅ |
| fēnix® 5S Plus | 240 x 240 | round | Memory-In-Pixel (64 colors) | 3.3 | ✅ | ✅ |
| fēnix® 5X / tactix® Charlie | 240 x 240 | round | Memory-In-Pixel (64 colors) | 3.1 | ✅ | ✅ |
| fēnix® 5X Plus | 240 x 240 | round | Memory-In-Pixel (64 colors) | 3.3 | ✅ | ✅ |
| fēnix® 6 / 6 Solar / 6 Dual Power | 260 x 260 | round | Memory-In-Pixel (64 colors) | 3.4 | ✅ | ✅ |
| fēnix® 6 Pro / 6 Sapphire / 6 Pro Solar / 6 Pro Dual Power / quatix® 6 | 260 x 260 | round | Memory-In-Pixel (64 colors) | 3.4 | ✅ | ✅ |
| fēnix® 6S / 6S Solar / 6S Dual Power | 240 x 240 | round | Memory-In-Pixel (64 colors) | 3.4 | ✅ | ✅ |
| fēnix® 6S Pro / 6S Sapphire / 6S Pro Solar / 6S Pro Dual Power | 240 x 240 | round | Memory-In-Pixel (64 colors) | 3.4 | ✅ | ✅ |
| fēnix® 6X Pro / 6X Sapphire / 6X Pro Solar / tactix® Delta Sapphire / Delta Solar / Delta Solar - Ballistics Edition / quatix® 6X / 6X Solar / 6X Dual Power | 280 x 280 | round | Memory-In-Pixel (64 colors) | 3.4 | ✅ | ✅ |
| fēnix® 7 / quatix® 7 | 260 x 260 | round | Memory-In-Pixel (64 colors) | 5.2 | ✅ | ✅ |
| fēnix® 7 Pro | 260 x 260 | round | Memory-In-Pixel (64 colors) | 5.2 | ✅ | ✅ |
| fēnix® 7 Pro - Solar Edition (no Wi-Fi) | 260 x 260 | round | Memory-In-Pixel (64 colors) | 5.2 | ✅ | ✅ |
| fēnix® 7S | 240 x 240 | round | Memory-In-Pixel (64 colors) | 5.2 | ✅ | ✅ |
| fēnix® 7S Pro | 240 x 240 | round | Memory-In-Pixel (64 colors) | 5.2 | ✅ | ✅ |
| fēnix® 7X / tactix® 7 / quatix® 7X Solar / Enduro™ 2 | 280 x 280 | round | Memory-In-Pixel (64 colors) | 5.2 | ✅ | ✅ |
| fēnix® 7X Pro | 280 x 280 | round | Memory-In-Pixel (64 colors) | 5.2 | ✅ | ✅ |
| fēnix® 7X Pro - Solar Edition (no Wi-Fi) | 280 x 280 | round | Memory-In-Pixel (64 colors) | 5.2 | ✅ | ✅ |
| fēnix® 8 43mm | 416 x 416 | round | AMOLED | 6.0 | ✅ | ✅ |
| fēnix® 8 47mm / 51mm / tactix® 8 47mm / 51mm / quatix® 8 47mm / 51mm | 454 x 454 | round | AMOLED | 6.0 | ✅ | ✅ |
| fēnix® 8 Pro 47mm / 51mm / MicroLED / quatix® 8 Pro 47mm / 51mm | 454 x 454 | round | AMOLED | 6.0 | ✅ | ✅ |
| fēnix® 8 Solar 47mm | 260 x 260 | round | Memory-In-Pixel (64 colors) | 6.0 | ✅ | ✅ |
| fēnix® 8 Solar 51mm / tactix® 8 Solar 51mm | 280 x 280 | round | Memory-In-Pixel (64 colors) | 6.0 | ✅ | ✅ |
| fēnix® Chronos | 218 x 218 | round | Memory-In-Pixel (64 colors) | 3.1 | ✅ | ✅ |
| fēnix® E | 416 x 416 | round | AMOLED | 6.0 | ✅ | ✅ |
| First Avenger | 260 x 260 | round | Memory-In-Pixel (64 colors) | 3.3 | ✅ | ✅ |
| Forerunner® 165 | 390 x 390 | round | AMOLED | 5.2 | ✅ | ✅ |
| Forerunner® 165 Music | 390 x 390 | round | AMOLED | 5.2 | ✅ | ✅ |
| Forerunner® 245 | 240 x 240 | round | Memory-In-Pixel (64 colors) | 3.3 | ✅ | ✅ |
| Forerunner® 245 Music | 240 x 240 | round | Memory-In-Pixel (64 colors) | 3.3 | ✅ | ✅ |
| Forerunner® 255 | 260 x 260 | round | Memory-In-Pixel (64 colors) | 5.2 | ✅ | ✅ |
| Forerunner® 255 Music | 260 x 260 | round | Memory-In-Pixel (64 colors) | 5.2 | ✅ | ✅ |
| Forerunner® 255s | 218 x 218 | round | Memory-In-Pixel (64 colors) | 5.2 | ✅ | ✅ |
| Forerunner® 255s Music | 218 x 218 | round | Memory-In-Pixel (64 colors) | 5.2 | ✅ | ✅ |
| Forerunner® 265 | 416 x 416 | round | AMOLED | 5.2 | ✅ | ✅ |
| Forerunner® 265s | 360 x 360 | round | AMOLED | 5.2 | ✅ | ✅ |
| Forerunner® 55 | 208 x 208 | round | Memory-In-Pixel (8 colors) | 3.4 | ✅ | ✅ |
| Forerunner® 570 42mm | 390 x 390 | round | AMOLED | 6.0 | ✅ | ✅ |
| Forerunner® 570 47mm | 454 x 454 | round | AMOLED | 6.0 | ✅ | ✅ |
| Forerunner® 645 | 240 x 240 | round | Memory-In-Pixel (64 colors) | 3.1 | ✅ | ✅ |
| Forerunner® 645 Music | 240 x 240 | round | Memory-In-Pixel (64 colors) | 3.2 | ✅ | ✅ |
| Forerunner® 745 | 240 x 240 | round | Memory-In-Pixel (64 colors) | 3.3 | ✅ | ✅ |
| Forerunner® 935 | 240 x 240 | round | Memory-In-Pixel (64 colors) | 3.1 | ✅ | ✅ |
| Forerunner® 945 | 240 x 240 | round | Memory-In-Pixel (64 colors) | 3.3 | ✅ | ✅ |
| Forerunner® 945 LTE | 240 x 240 | round | Memory-In-Pixel (64 colors) | 3.4 | ✅ | ✅ |
| Forerunner® 955 / Solar | 260 x 260 | round | Memory-In-Pixel (64 colors) | 5.2 | ✅ | ✅ |
| Forerunner® 965 | 454 x 454 | round | AMOLED | 5.2 | ✅ | ✅ |
| Forerunner® 970 | 454 x 454 | round | AMOLED | 6.0 | ✅ | ✅ |
| Instinct® 2 / Solar / Dual Power / dēzl Edition | 176 x 176 | semi-octagon | Memory-In-Pixel (2 colors) | 3.4 | ✅ | ✅ |
| Instinct® 2S / Solar / Dual Power | 163 x 156 | semi-octagon | Memory-In-Pixel (2 colors) | 3.4 | ✅ | ✅ ᵍ |
| Instinct® 2X Solar | 176 x 176 | semi-octagon | Memory-In-Pixel (2 colors) | 3.4 | ✅ | ✅ |
| Instinct® 3 AMOLED 45mm | 390 x 390 | round | AMOLED | 5.1 | ✅ | ✅ |
| Instinct® 3 AMOLED 50mm | 416 x 416 | round | AMOLED | 5.1 | ✅ | ✅ |
| Instinct® 3 Solar 45mm / 50mm | 176 x 176 | semi-octagon | Memory-In-Pixel (2 colors) | 5.1 | ✅ | ✅ |
| Instinct® Crossover | 176 x 176 | semi-octagon | Memory-In-Pixel (2 colors) | 3.4 | ✅ | ✅ |
| Instinct® Crossover AMOLED | 390 x 390 | round | AMOLED | 5.1 | ✅ | ✅ |
| Instinct® E 40mm | 166 x 166 | semi-octagon | Memory-In-Pixel (2 colors) | 5.1 | ✅ | ✅ |
| Instinct® E 45mm | 176 x 176 | semi-octagon | Memory-In-Pixel (2 colors) | 5.1 | ✅ | ✅ |
| MARQ® (Gen 2) Athlete / Adventurer / Captain / Golfer / Carbon Edition / Commander - Carbon Edition | 390 x 390 | round | AMOLED | 5.2 | ✅ | ✅ |
| MARQ® (Gen 2) Aviator | 390 x 390 | round | AMOLED | 5.2 | ✅ | ✅ |
| MARQ® Adventurer | 240 x 240 | round | Memory-In-Pixel (64 colors) | 3.4 | ✅ | ✅ |
| MARQ® Athlete | 240 x 240 | round | Memory-In-Pixel (64 colors) | 3.4 | ✅ | ✅ |
| MARQ® Aviator | 240 x 240 | round | Memory-In-Pixel (64 colors) | 3.4 | ✅ | ✅ |
| MARQ® Captain / MARQ® Captain: American Magic Edition | 240 x 240 | round | Memory-In-Pixel (64 colors) | 3.4 | ✅ | ✅ |
| MARQ® Commander | 240 x 240 | round | Memory-In-Pixel (64 colors) | 3.4 | ✅ | ✅ |
| MARQ® Driver | 240 x 240 | round | Memory-In-Pixel (64 colors) | 3.4 | ✅ | ✅ |
| MARQ® Expedition | 240 x 240 | round | Memory-In-Pixel (64 colors) | 3.4 | ✅ | ✅ |
| MARQ® Golfer | 240 x 240 | round | Memory-In-Pixel (64 colors) | 3.4 | ✅ | ✅ |
| Rey™ | 218 x 218 | round | Memory-In-Pixel (64 colors) | 3.3 | ✅ | ✅ |
| Venu® | 390 x 390 | round | AMOLED | 3.3 | ✅ | ✅ |
| Venu® 2 | 416 x 416 | round | AMOLED | 5.0 | ✅ | ✅ |
| Venu® 2 Plus | 416 x 416 | round | AMOLED | 5.0 | ✅ | ✅ |
| Venu® 2S | 360 x 360 | round | AMOLED | 5.0 | ✅ | ✅ |
| Venu® 3 | 454 x 454 | round | AMOLED | 5.2 | ✅ | ✅ |
| Venu® 3S | 390 x 390 | round | AMOLED | 5.2 | ✅ | ✅ |
| Venu® 4 41mm | 390 x 390 | round | AMOLED | 6.0 | ✅ | ✅ |
| Venu® 4 45mm / D2™ Air X15 | 454 x 454 | round | AMOLED | 6.0 | ✅ | ✅ |
| Venu® Mercedes-Benz® Collection | 390 x 390 | round | AMOLED | 3.3 | ✅ | ✅ |
| Venu® Sq | 240 x 240 | rectangle | Transflective Liquid-Crystal (High Color) | 3.3 | ✅ |  |
| Venu® Sq 2 | 320 x 360 | rectangle | AMOLED | 5.0 | ✅ |  |
| Venu® Sq 2 Music | 320 x 360 | rectangle | AMOLED | 5.0 | ✅ |  |
| Venu® Sq. Music Edition | 240 x 240 | rectangle | Transflective Liquid-Crystal (High Color) | 3.3 | ✅ |  |
| Venu® X1 | 448 x 486 | rectangle | AMOLED | 6.0 | ✅ |  |
| vívoactive® 3 | 240 x 240 | round | Memory-In-Pixel (64 colors) | 3.1 | ✅ | ✅ |
| vívoactive® 3 Mercedes-Benz® Collection | 240 x 240 | round | Memory-In-Pixel (64 colors) | 3.0 | ✅ | ✅ |
| vívoactive® 3 Music | 240 x 240 | round | Memory-In-Pixel (64 colors) | 3.2 | ✅ | ✅ |
| vívoactive® 3 Music LTE | 240 x 240 | round | Memory-In-Pixel (64 colors) | 3.1 | ✅ | ✅ |
| vívoactive® 4 | 260 x 260 | round | Memory-In-Pixel (64 colors) | 3.3 | ✅ | ✅ |
| vívoactive® 4S | 218 x 218 | round | Memory-In-Pixel (64 colors) | 3.3 | ✅ | ✅ |
| vívoactive® 5 | 390 x 390 | round | AMOLED | 5.2 | ✅ | ✅ |
| vívoactive® 6 | 390 x 390 | round | AMOLED | 6.0 | ✅ | ✅ |

## Not currently supported

These appear in `compatible_devices.csv` but are **not** in the manifest. Devices below API 3.0 can't
run the `Menu2`-based UI; the rest are not present in the SDK version used to build (they can be added
once the SDK is updated).

| Device | Screen resolution | API level | Reason |
|--------|-------------------|-----------|--------|
| Approach® S60 | 240 x 240 | 2.4 | Below API 3.0 (no Menu2 UI) |
| D2™ Bravo | 218 x 218 | 1.4 | Below API 3.0 (no Menu2 UI) |
| D2™ Bravo Titanium | 218 x 218 | 1.4 | Below API 3.0 (no Menu2 UI) |
| epix™ | 205 x 148 | 1.2 | Below API 3.0 (no Menu2 UI) |
| fēnix® 3 / tactix® Bravo / quatix® 3 | 218 x 218 | 1.4 | Below API 3.0 (no Menu2 UI) |
| fēnix® 3 HR | 218 x 218 | 1.4 | Below API 3.0 (no Menu2 UI) |
| Forerunner® 230 | 215 x 180 | 1.4 | Below API 3.0 (no Menu2 UI) |
| Forerunner® 235 | 215 x 180 | 1.4 | Below API 3.0 (no Menu2 UI) |
| Forerunner® 45 | 208 x 208 | 1.4 | Below API 3.0 (no Menu2 UI) |
| Forerunner® 630 | 215 x 180 | 1.4 | Below API 3.0 (no Menu2 UI) |
| Forerunner® 735xt | 215 x 180 | 2.4 | Below API 3.0 (no Menu2 UI) |
| Forerunner® 920XT | 205 x 148 | 1.4 | Below API 3.0 (no Menu2 UI) |
| Garmin Swim™ 2 | 208 x 208 | 1.4 | Below API 3.0 (no Menu2 UI) |
| vívoactive® | 205 x 148 | 1.4 | Below API 3.0 (no Menu2 UI) |
| vívoactive® HR | 148 x 205 | 2.4 | Below API 3.0 (no Menu2 UI) |
| Forerunner® 170 | 390 x 390 | 6.0 | Not in current SDK device set |
| Forerunner® 170 Music | 390 x 390 | 6.0 | Not in current SDK device set |
| Forerunner® 70 | 390 x 390 | 6.0 | Not in current SDK device set |
