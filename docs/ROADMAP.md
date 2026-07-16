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
- [x] Mode picker: Adult / Child / Infant
- [x] Vibration via `Attention.vibrate`
- [x] Device capability detection (`Attention has :playTone` / `:vibrate`) with graceful fallback
- [ ] Distinct tone/vibe for compression vs. ventilation confirmed on-device

## v0.4 — Settings & cues *(current)*
- [x] Feedback selector: beep / vibrate / both (on-device + phone app settings)
- [x] Elapsed-time and compression counters (running screen)
- [x] Second running page (UP/DOWN): CPR start time + GPS lat/lon + MGRS (Positioning permission)
- [ ] Screen-on / backlight behavior during a session
- Note: configurable rate / ratio was prototyped then removed — rates stay fixed per
  protocol for now. Revisit only if there's a clear need (see backlog).

## v1.0 — Broad coverage & release
- [ ] Expand device target list in `manifest.xml` toward all CIQ watches
- [ ] Per-device layout QA (round / semi-round / rectangle displays)
- [ ] Battery / performance check for long sessions
- [x] Store listing icon/logo (`MetronomeCPR.png`, `MetronomeCPR-small.png`)
- [x] Store screenshots (`store/screenshots/`, 176×176)
- [ ] Store listing description (with medical disclaimer)
- [ ] Connect IQ Store submission (`.iq` package — see `docs/PUBLISHING.md`)

## Backlog / ideas
- [ ] Separate neonatal mode (3:1 at 120 events/min) distinct from the Infant BLS mode
- [ ] Two-rescuer toggle switching 30:2 ↔ 15:2 for child/infant
- [ ] Voice/tone distinction between compression beat and "give breath" cue
- [ ] Localization of on-screen strings
- [ ] Glance / widget quick-start
