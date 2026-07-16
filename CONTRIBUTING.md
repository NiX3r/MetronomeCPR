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
   The `developer_key` file is **git-ignored** — never commit it. **Back it up**: the Connect IQ
   Store ties your app's identity to this key, so losing it means you can't publish updates.
   (On Windows without OpenSSL on `PATH`, use the copy bundled with Git:
   `C:\Program Files\Git\usr\bin\openssl.exe`.)

## Build & run

```bash
# Compile & sign for the reference device (Instinct 2X Solar)
monkeyc -d instinct2x -f monkey.jungle -o bin/MetronomeCPR.prg -y developer_key -w
```

`monkeyc` lives in the SDK's `bin/` (it is not on `PATH` by default; call it by full path, e.g.
`…/connectiq-sdk-win-<version>/bin/monkeyc.bat`). In VS Code you can instead use the Monkey C
extension's **Build** / **Run** commands (`Ctrl/Cmd+Shift+P → Monkey C: Build Current Project`).

### Sideload to a real watch
1. Connect the watch by USB (mass-storage mode).
2. Copy `bin/MetronomeCPR.prg` to `GARMIN/APPS/` on the watch volume.
3. Safely eject and unplug — the app appears in the watch's app list after disconnect.

To **remove** it, delete the `.prg` from `GARMIN/APPS/` and disconnect.

### Package for the Connect IQ Store
```bash
# Build a signed .iq bundle for every product in manifest.xml
monkeyc -e -o bin/MetronomeCPR.iq -f monkey.jungle -y developer_key -r -w
```
Upload the `.iq` at the developer dashboard — see [`docs/PUBLISHING.md`](docs/PUBLISHING.md).

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
