# Contributing to MetronomeCPR

Thanks for helping! This is a Garmin **Connect IQ** app written in **Monkey C**.

## Prerequisites

1. **Connect IQ SDK** — install via the
   [SDK Manager](https://developer.garmin.com/connect-iq/sdk/). Note the SDK path.
2. **VS Code** + the official **Monkey C** extension (`garmin.monkey-c`).
   (The legacy Eclipse plugin also works but is not recommended for new setups.)
3. A **developer key** to sign builds:
   ```bash
   openssl genrsa -out developer_key.pem 4096
   openssl pkcs8 -topk8 -inform PEM -outform DER -in developer_key.pem \
     -out developer_key -nocrypt
   ```
   The `developer_key` file is **git-ignored** — never commit it.

## Build & run

Once source exists (`manifest.xml`, `monkey.jungle`, `source/`):

```bash
# Compile for the reference device (Instinct 2X Solar)
monkeyc -d instinct2x -f monkey.jungle -o bin/MetronomeCPR.prg -y developer_key

# Launch the simulator, then File → Open the .prg
connectiq
```

In VS Code you can instead use the Monkey C extension's **Build** / **Run** commands and the
`Ctrl/Cmd+Shift+P → Monkey C: Build Current Project` / `... Run` actions.

### Sideload to a real watch
Copy the built `.prg` to `GARMIN/APPS/` on the watch's USB mass-storage volume, then disconnect.

## Coding guidelines

- Keep the **metronome timing** logic isolated and testable (a pure function from mode → interval /
  cadence, separate from the UI/hardware calls).
- **Detect capabilities at runtime** before using them:
  ```monkeyc
  if (Attention has :playTone)  { /* beep  */ }
  if (Attention has :vibrate)   { /* haptic */ }
  ```
  Never assume a device has a speaker or vibration motor.
- Match the existing file's style, naming, and comment density.
- Prefer small, reviewable commits.

## Medical parameters — special rule

Any change to a **rate, depth, ratio, or cadence** must be reflected in
[`docs/CPR-REFERENCE.md`](docs/CPR-REFERENCE.md) with a citation (guideline document + year) and a
short changelog line. PRs that alter medical numbers without a source will not be merged.

## Pull requests

1. Branch from `main`.
2. Confirm it builds and runs in the simulator for at least one reference device.
3. Update `CHANGELOG.md` and, if relevant, `docs/CPR-REFERENCE.md`.
4. Describe what you tested (device, SDK version).
