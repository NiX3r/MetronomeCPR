# CPR reference — the numbers behind each mode

This document records **why** MetronomeCPR uses the rates and cycles it does, so the medical
parameters stay traceable and reviewable. It is background reference, **not** medical advice — read
the disclaimer in the [README](../README.md).

> ⚠️ Guidelines are revised periodically (typically on a ~5-year cycle) and differ by region and
> rescuer training level. Before changing any default in the app, cite the current guideline you are
> following here. Values below reflect the AHA / ERC / ILCOR 2020–2021 consensus at the time of
> writing and should be re-verified against the latest guidance.

## Compression rate

All ages of **basic life support** (BLS) share the same compression **rate**:

- **100–120 compressions per minute** for adults, children, and infants.
- MetronomeCPR uses **110 /min** as the default midpoint for Adult and Child modes.

At 110 /min the beep interval is `60000 ms / 110 ≈ 545 ms`.

## Compression depth (rescuer's responsibility — the app cannot measure this)

| Patient | Depth guidance                                             |
|---------|------------------------------------------------------------|
| Adult   | ~5 cm (2 in), not more than 6 cm                           |
| Child   | ~5 cm, at least one-third of chest depth                   |
| Infant  | ~4 cm, at least one-third of chest depth                   |

Depth is displayed as a reminder only; the watch has no way to sense compression depth.

## Compression-to-ventilation cycles

| Scenario                          | Ratio | Notes                                             |
|-----------------------------------|-------|---------------------------------------------------|
| Adult, single or two rescuers     | 30:2  | 30 compressions, then 2 breaths                   |
| Child / infant, single rescuer    | 30:2  |                                                   |
| Child / infant, two rescuers      | 15:2  |                                                   |
| **Newborn (neonatal, at birth)**  | 3:1   | 90 compressions + 30 breaths = **120 events/min** |

### Why "Newborn" is a distinct mode

Newborn resuscitation immediately after birth (neonatal) is intentionally different from infant BLS:

- It uses a **3:1 compression-to-ventilation ratio**.
- The target is **120 events per minute** — i.e. **90 compressions + 30 ventilations** per minute.
- This produces a different audible/haptic pattern than a plain 110/min compression beat.

The app's Newborn mode should model this 3:1 cadence, not just a faster metronome. (An "Infant BLS"
mode with 100–120/min and 30:2 or 15:2 may be added separately later — tracked in
[`ROADMAP.md`](ROADMAP.md).)

## Sources to cite when editing

Record the exact guideline document and year alongside any change:

- American Heart Association (AHA) Guidelines for CPR & ECC
- European Resuscitation Council (ERC) Guidelines
- International Liaison Committee on Resuscitation (ILCOR) Consensus on Science (CoSTR)

> When you update a value, add a line here: *what changed, new value, source + year, reviewer.*
