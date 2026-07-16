# Publishing to the Connect IQ Store

How to package MetronomeCPR and submit it so users can install it from the Connect IQ Store /
Garmin Connect Mobile.

## 0. Protect the signing key (critical)

The app is signed with `developer_key` (git-ignored). The Store ties the app's identity to this key.
**If you lose it, you can never update the published app** — you'd have to republish as a new listing.
Back it up somewhere safe (password manager / encrypted backup).

## 1. Build the `.iq` package

The Store accepts a signed `.iq` bundle (not a `.prg`). `-e` builds an export package covering **every**
`<iq:product>` in `manifest.xml`:

```bash
monkeyc -e -o bin/MetronomeCPR.iq -f monkey.jungle -y developer_key -r -w
```

> Widen device coverage **before** first publish: add more `<iq:product id="…"/>` entries to
> `manifest.xml` and rebuild, so early users aren't limited to the Instinct 2X Solar.

## 2. Developer account

Sign in with your Garmin account at the developer dashboard and accept the developer agreement:
<https://apps.garmin.com/en-US/developer/dashboard>

## 3. Upload & create the listing

- Dashboard → **Add App** → upload `bin/MetronomeCPR.iq`.
- The dashboard reads supported devices from the package.
- Fill in the listing:
  - **Type:** Watch App
  - **Name:** CPR Metronome
  - **Category:** Health & Fitness
  - **Description:** what it does **+ the medical disclaimer** (Store review is stricter on health
    apps — lead with "training aid, not a medical device")
  - **Icon:** `MetronomeCPR.png` (color logo)
  - **Screenshots:** the 176×176 images in [`../store/screenshots/`](../store/screenshots)
  - **Pricing:** Free
  - **Languages:** English

## 4. Submit for review

Garmin reviews submissions manually (typically a few days). Once approved, the app is public and
installable via the Connect IQ Store app and Garmin Connect Mobile.

## Assets checklist

| Asset | Location | Status |
|-------|----------|--------|
| `.iq` package | `bin/MetronomeCPR.iq` (git-ignored) | built |
| Store icon | `MetronomeCPR.png` | ✅ |
| Screenshots | `store/screenshots/*.png` (176×176) | ✅ |
| Description text | — | TODO |
| Device coverage | `manifest.xml` (`instinct2x` only) | expand before release |
