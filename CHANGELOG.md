# Changelog

All notable changes to MetronomeCPR are documented here.
Format loosely follows [Keep a Changelog](https://keepachangelog.com/);
versions follow [Semantic Versioning](https://semver.org/).

## [Unreleased]
### Added
- Initial documentation scaffold: README, LICENSE (MIT + not-a-medical-device notice),
  `.gitignore`, `CONTRIBUTING.md`, `CHANGELOG.md`.
- `docs/CPR-REFERENCE.md` — sourced rates, depths, and compression-to-ventilation ratios
  for Adult / Child / Infant modes.
- `docs/DEVICE-NOTES.md` — reference device (Instinct 2X Solar, `instinct2x`) hardware notes.
- `docs/ROADMAP.md` — planned milestones through v1.0.
- **Connect IQ application skeleton** (Monkey C), builds for `instinct2x`:
  - `manifest.xml`, `monkey.jungle`, `resources/` (strings, 62×62 monochrome launcher icon).
  - Patient-type menu: **Adult / Child / Infant** (`ModeMenu`).
  - `CprMode` — per-mode rhythm model (Adult / Child / Infant all 110/min, 30:2).
  - `Metronome` — repeating-timer engine emitting tone + vibration, capability-guarded
    (`Attention has :playTone` / `:vibrate`), tracking compression/ventilation cycle position.
  - `MetronomeView` — high-contrast running screen (beat indicator, PUSH/BREATHE cue,
    compression count, elapsed time); `MetronomeDelegate` for START/STOP and BACK.
- **Per-device layout** (`Layout` + device-specific drawing): the running screen adapts to the watch
  instead of assuming a plain centered screen. The Instinct layout **uses the width** — beat indicator
  on the left with cue/count on the right; info page shows coordinates as label-left / value-right rows
  and the start time in the top-left. It keeps clear of the **top-right sub-display** and uses that
  small round display for the **elapsed timer**. Other devices fall back to a generic centered layout.
  (Detection also matches 176×176 directly, so the Instinct layout can't silently fall back.)
- Running screen is now **two pages**, switched with UP / DOWN (page dots at the bottom):
  - **Beat page** (default) — beat indicator, PUSH/BREATHE, compression count, elapsed time.
  - **Info page** — wall-clock **CPR start time**, **GPS lat/lon**, and **MGRS** coordinates
    (needs the Positioning permission). Shows "Acquiring GPS…" until a fix.
  The metronome timer is independent of the view, so tone/vibration keep running while paging.
- **Accidental-stop protection:** the metronome can only be stopped by holding **GPS + ABC**
  together (ENTER + DOWN — opposite sides of the Instinct 2X). A single GPS press only *starts*;
  plain BACK is ignored while running. The info page shows a "Stop: hold GPS+ABC" hint.
- Distinct feedback for compressions vs. ventilations (louder tone / longer buzz on breaths).
- **Light/flash feedback** — the watch blinks its light in time with the beat. Prefers the physical
  **flashlight** (`Attention.setFlashlightMode`, e.g. Instinct 2X Solar) and falls back to the screen
  **backlight** on watches without one; both capability-guarded, and the light is always turned off on
  stop. A short one-shot timer ends each blink so it reads as a strobe against the beat.
- **Settings** — three independent feedback channels, **Beep / Vibrate / Flash**, each an on/off
  toggle (any combination). Editable both **on-device** (in-app Settings menu, `ToggleMenuItem`s) and
  from the **phone** (Connect IQ app settings via `resources/settings/`). Backed by a `Settings` module
  over CIQ boolean properties (`beepOn` / `vibrateOn` / `flashOn`; replaced the earlier single
  beep/vibrate/both list). (Rate / ratio settings were prototyped and then removed — each mode's rate
  stays fixed per protocol.)
- **Broad device support** — the manifest now targets **120 Connect IQ devices** (every device in the
  SDK at API level ≥ 3.0.0, the floor for the Menu2 / ToggleMenuItem UI), up from Instinct 2X Solar
  only. The product list was generated from `compatible_devices.csv` matched against the SDK device set;
  devices below 3.0 and products absent from this SDK (e.g. Forerunner 70 / 170) were left out. The
  sub-display anchor is now derived from screen width so it holds on the smaller Instinct 2S / E screens.
  Builds verified across all 22 locally-installed profiles (semi-octagon / round, 156–454 px, MIP &
  AMOLED, API 3.3–6.0); the 3.0–3.2 devices are included but not built locally.
- App logo / store icon: `MetronomeCPR.png` (1254×1254) and `MetronomeCPR-small.png` (500×500).
- `store/screenshots/` — five 176×176 Connect IQ Store screenshots.
- `docs/PUBLISHING.md` — how to build the `.iq` package and submit to the Connect IQ Store.
- `.gitattributes` tuned for Monkey C (LF normalization, binary assets, Linguist).

### Changed
- Shrank the 62×62 monochrome launcher icon so the heart fits inside the Instinct's round icon frame.
- **New application id (UUID).** Changing it makes this a fresh app in the Connect IQ Store (no shared
  listing/reviews with the previous id).

### Notes
- Compiles clean against Connect IQ SDK 9.2.0 for all 22 locally-installed device profiles.
- Sideloaded to an Instinct 2X Solar; interactive behavior on real hardware still to be verified/tuned.
- The single 62×62 launcher icon is auto-scaled to each device's icon size (per-device launcher icons
  could be added later); the Instinct beat/info screens are pixel-tuned for 176 px and only width-scaled
  on the smaller Instinct variants.
