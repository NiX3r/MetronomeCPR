# Device notes

Per-device hardware constraints that affect MetronomeCPR. The goal is all Connect IQ watches, but we
develop and test against a reference device first.

## Reference device — Garmin Instinct 2X Solar

| Property            | Value                                                        |
|---------------------|-------------------------------------------------------------|
| CIQ device id       | `instinct2x` (used with `monkeyc -d instinct2x`)            |
| Display             | Monochrome MIP (transflective), ~176×176, always-on         |
| Colors              | Effectively 1-bit — design for **high contrast**, no reliance on color |
| Input               | 5 physical buttons, **no touchscreen**                      |
| Tone / beep         | Supported (`Attention.playTone`)                            |
| Vibration           | Supported (`Attention.vibrate`)                             |
| Backlight           | LED backlight; consider keeping it on during a session      |

> Resolution and exact capabilities should be confirmed against the Connect IQ simulator device
> profile and `manifest.xml` once the SDK is installed.

### Button → Connect IQ key mapping
The device exposes 5 keys (`up, down, enter, esc, menu`). Physical buttons:

| Physical button | Side        | CIQ key     |
|-----------------|-------------|-------------|
| GPS             | upper right | `KEY_ENTER` |
| SET / BACK      | lower right | `KEY_ESC`   |
| CTRL            | upper left  | `KEY_UP`    |
| ABC             | lower left  | `KEY_DOWN`  |

The "stop CPR" combo uses **GPS + ABC** (`KEY_ENTER` + `KEY_DOWN`) — opposite sides, so it's hard
to trigger by accident.

### UI implications
- **Button-driven navigation only** — no tap targets. Map: mode select, start/stop, back.
- **Monochrome, large glyphs** — the running rate and beat indicator must be readable at a glance
  during a stressful situation.
- **Both feedback modes available** — offer beep, vibrate, or both.

### Display shape & the sub-display
The Instinct 2 display is a **semi-octagon (176×176)** with a **small round sub-display inset in the
top-right**. From the device profile, the sub-display occupies the box **x 113, y 1, 62×62** —
i.e. a circle centered at **(144, 32), radius ≈ 31**. Safe main content is the **top-left** (x < 113)
and everything **below y ≈ 66** (full width).

The app's `Layout` class encodes this: it keeps the mode label top-left, the beat indicator centered
but left of x 113, and places the **elapsed timer inside the sub-display**. Any device that is not a
semi-octagon 176×176 uses a generic centered layout. Add new devices by adding a branch in `Layout`.

### Icons — two distinct assets
- **On-watch launcher icon** (`resources/drawables/launcher_icon.png`): 62×62, must use only the
  device's 1bpp palette (black / white / transparent). We ship a white heart on transparent, sized
  to fit inside the Instinct's round icon frame.
- **Store / branding logo** (`MetronomeCPR.png`, `MetronomeCPR-small.png`): full color; used for the
  Connect IQ Store listing, not rendered on this device.

### Verifying capabilities at runtime
Even though this device supports both, always guard hardware calls so the same build behaves on
watches that lack a speaker or motor:

```monkeyc
if (Attention has :playTone) { Attention.playTone(Attention.TONE_LOUD_BEEP); }
if (Attention has :vibrate)  { Attention.vibrate([new Attention.VibeProfile(100, 120)]); }
```

## Expanding device coverage
When adding devices, record anything non-obvious here (missing beeper, round vs. rectangular layout,
AMOLED burn-in / always-on limits, touchscreen-only navigation) and add the product id to
`manifest.xml`.

Sources:
- [Toybox.Attention API](https://developer.garmin.com/connect-iq/api-docs/Toybox/Attention.html)
- [Instinct 2X Solar in the CIQ SDK Manager](https://forums.garmin.com/developer/connect-iq/b/news-announcements/posts/instinct-2x-solar-now-available-in-connect-iq-sdk-manager)
- [Compatible devices](https://developer.garmin.com/connect-iq/compatible-devices/)
