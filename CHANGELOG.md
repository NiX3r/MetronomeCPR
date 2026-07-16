# Changelog

All notable changes to MetronomeCPR are documented here.
Format loosely follows [Keep a Changelog](https://keepachangelog.com/);
versions follow [Semantic Versioning](https://semver.org/).

## [Unreleased]
### Added
- Initial documentation scaffold: README, LICENSE (MIT + not-a-medical-device notice),
  `.gitignore`, `CONTRIBUTING.md`, `CHANGELOG.md`.
- `docs/CPR-REFERENCE.md` — sourced rates, depths, and compression-to-ventilation ratios
  for Adult / Child / Newborn modes.
- `docs/DEVICE-NOTES.md` — reference device (Instinct 2X Solar, `instinct2x`) hardware notes.
- `docs/ROADMAP.md` — planned milestones through v1.0.
- **Connect IQ application skeleton** (Monkey C), builds for `instinct2x`:
  - `manifest.xml`, `monkey.jungle`, `resources/` (strings, 62×62 monochrome launcher icon).
  - Patient-type menu: **Adult / Child / Newborn** (`ModeMenu`).
  - `CprMode` — per-mode rhythm model (Adult/Child 110/min 30:2; Newborn 3:1 at 120 events/min).
  - `Metronome` — repeating-timer engine emitting tone + vibration, capability-guarded
    (`Attention has :playTone` / `:vibrate`), tracking compression/ventilation cycle position.
  - `MetronomeView` — high-contrast running screen (beat indicator, PUSH/BREATHE cue,
    compression count, elapsed time); `MetronomeDelegate` for START/STOP and BACK.
- Running screen shows the **wall-clock time CPR was started** ("Start HH:MM") for handover/records,
  alongside the elapsed timer.
- Distinct feedback for compressions vs. ventilations (louder tone / longer buzz on breaths).
- **Settings** — configurable feedback mode (beep / vibrate / both), editable both **on-device**
  (in-app Settings menu) and from the **phone** (Connect IQ app settings via `resources/settings/`).
  Backed by a `Settings` module over CIQ properties. (Rate / ratio settings were prototyped and then
  removed — each mode's rate stays fixed per protocol.)
- App logo / store icon: `MetronomeCPR.png` (1254×1254) and `MetronomeCPR-small.png` (500×500).
- `store/screenshots/` — five 176×176 Connect IQ Store screenshots.
- `docs/PUBLISHING.md` — how to build the `.iq` package and submit to the Connect IQ Store.
- `.gitattributes` tuned for Monkey C (LF normalization, binary assets, Linguist).

### Changed
- Shrank the 62×62 monochrome launcher icon so the heart fits inside the Instinct's round icon frame.

### Notes
- Compiles clean (no warnings) against Connect IQ SDK 9.2.0 for the Instinct 2X Solar.
- Sideloaded to an Instinct 2X Solar; interactive behavior on real hardware still to be verified/tuned.
