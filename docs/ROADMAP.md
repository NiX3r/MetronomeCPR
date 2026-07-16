# Roadmap

Milestones for MetronomeCPR. Dates are aspirational; scope is the commitment.

## v0.1 — Docs & scaffold *(current)*
- [x] README, LICENSE, .gitignore
- [x] Medical disclaimer
- [x] CPR parameter reference (`docs/CPR-REFERENCE.md`)
- [x] Contributing guide
- [x] Connect IQ project skeleton (`manifest.xml`, `monkey.jungle`, `source/`, `resources/`)

## v0.2 — Minimal metronome
- [x] Beat rate (110 /min) via a repeating timer
- [x] Beep via `Attention.playTone`
- [x] Start / stop
- [x] Compiles for the reference device **Instinct 2X Solar** (`instinct2x`)
- [ ] Verified interactively in the Connect IQ simulator + on real hardware

## v0.3 — Patient modes + haptics
- [x] Mode picker: Newborn / Child / Adult
- [x] Newborn 3:1 cadence (90 comp + 30 breaths, 120 events/min)
- [x] Vibration via `Attention.vibrate`
- [x] Device capability detection (`Attention has :playTone` / `:vibrate`) with graceful fallback
- [ ] Distinct tone/vibe for compression vs. ventilation confirmed on-device

## v0.4 — Settings & cues
- [ ] Configurable rate (100–120 /min)
- [ ] Feedback selector: beep / vibrate / both
- [ ] Compression-to-ventilation cycle cues (30:2, 15:2)
- [ ] Optional elapsed-time and compression counters
- [ ] Screen-on / backlight behavior during a session

## v1.0 — Broad coverage & release
- [ ] Expand device target list in `manifest.xml` toward all CIQ watches
- [ ] Per-device layout QA (round / semi-round / rectangle displays)
- [ ] Battery / performance check for long sessions
- [ ] Store listing assets (icon, screenshots, description)
- [ ] Connect IQ Store submission

## Backlog / ideas
- [ ] Separate "Infant BLS" mode (100–120/min, 30:2 or 15:2) distinct from neonatal Newborn
- [ ] Two-rescuer toggle switching 30:2 ↔ 15:2 for child/infant
- [ ] Voice/tone distinction between compression beat and "give breath" cue
- [ ] Localization of on-screen strings
- [ ] Glance / widget quick-start
