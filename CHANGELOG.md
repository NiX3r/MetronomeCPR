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

### Notes
- Compiles clean (no warnings) against Connect IQ SDK 9.2.0 for the Instinct 2X Solar.
- Not yet verified interactively in the simulator / on-device.
