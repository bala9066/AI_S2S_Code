# RF Gain-Loss Budget
## kjk

**Generated:** 2026-04-16  
**Document Status:** AI-GENERATED — verify against final component datasheets

## 1. System Parameters

| Parameter | Value | Unit |
|-----------|-------|------|
| Centre Frequency    | 11500   | MHz  |
| RF Bandwidth        | 3000     | MHz  |
| Input Signal Level  | -90   | dBm  |
| Target Output Power | 20  | dBm  |
| Required System Gain | 110 | dB   |

## 2. Stage-by-Stage Gain / Loss Budget

| # | Stage | Component | Gain/Loss (dB) | Cum. Gain (dB) | Output Power (dBm) | NF (dB) | Cum. NF (dB) | P1dB Out (dBm) | OIP3 (dBm) | Notes |
|---|-------|-----------|---------------|----------------|-------------------|---------|-------------|---------------|-----------|-------|
| 1 | RF Input | SMA Connector + Misc Loss | -0.5 | -0.5 | -90.5 | 0.50 | 0.50 | N/A | N/A | Connector loss estimated |
| 2 | Band Preselection Filter | Switched Filter Bank (Mini-Circuits) | -2.5 | -3.0 | -93.0 | 2.50 | 2.99 | N/A | N/A | Wideband filter loss |
| 3 | Wideband LNA 1 | HMC698LP4 | +20.0 | 17.0 | -73.0 | 2.50 | 3.50 | 19.0 | 33.0 | Primary LNA sets system NF |
| 4 | First Mixer | HMC1049LC4 | -7.0 | 10.0 | -80.0 | 7.00 | 4.07 | 12.0 | 25.0 | Conversion loss, LO @ 15 dBm |
| 5 | IF Filter 1 | 1-4 GHz Bandpass | -2.0 | 8.0 | -82.0 | 2.00 | 4.21 | N/A | N/A | Image rejection filtering |
| 6 | IF Amplifier 1 | MMIC Amp | +15.0 | 23.0 | -67.0 | 4.00 | 4.50 | 18.0 | 28.0 | Restore mixer loss |
| 7 | Second Mixer | HMC1049LC4 | -7.0 | 16.0 | -74.0 | 7.00 | 4.68 | 12.0 | 25.0 | Second downconversion |
| 8 | IF Filter 2 | 100-500 MHz Bandpass 200 MHz BW | -3.0 | 13.0 | -77.0 | 3.00 | 4.79 | N/A | N/A | Channel selection filter |
| 9 | Variable Gain Amp 1 | Digital VGA (HMC698) | +0.0 | 13.0 | -77.0 | 6.00 | 4.84 | 20.0 | 33.0 | Mid gain point (AGC range -6 to +25) |
| 10 | Variable Gain Amp 2 | Digital VGA (HMC698) | +0.0 | 13.0 | -77.0 | 6.00 | 4.88 | 20.0 | 33.0 | Additional gain control |
| 11 | IF Driver Amplifier | High Linearity Amp | +20.0 | 33.0 | -57.0 | 5.00 | 5.09 | 20.0 | 35.0 | Drive ADC at optimum level |
| 12 | Anti-Alias Filter | Low-pass Filter | -1.0 | 32.0 | -58.0 | 1.00 | 5.10 | N/A | N/A | Reconstruction filter |
| 13 | ADC Input | ADC12DJ5200RF | +0.0 | 32.0 | -58.0 | 30.00 | 5.93 | 4.0 | N/A | Full scale input assumed -1 dBFS |

## 3. Budget Summary

| Metric | Value | Unit |
|--------|-------|------|
| Total System Gain     | 32.0  | dB  |
| Final Output Power    | -58.0  | dBm |
| Cascaded System NF    | 5.93 | dB  |
| Output Power Margin   | +78 | dB  |

## 4. Return Loss — Per Stage

| # | Stage | Component | S11 — Input RL (dB) | S22 — Output RL (dB) | Notes |
|---|-------|-----------|---------------------|----------------------|-------|
| 1 | RF Input | SMA Connector + Misc Loss | 20.0 | 20.0 | Connector loss estimated |
| 2 | Band Preselection Filter | Switched Filter Bank (Mini-Circuits) | 15.0 | 15.0 | Wideband filter loss |
| 3 | Wideband LNA 1 | HMC698LP4 | 12.0 | 12.0 | Primary LNA sets system NF |

> Return loss values are referenced to 50 Ω. Higher value = better match.

## 5. Cascade Noise Figure — Friis Formula

$$F_{{sys}} = F_1 + \frac{{F_2 - 1}}{{G_1}} + \frac{{F_3 - 1}}{{G_1 G_2}} + \cdots$$

Where *F* = linear noise factor (not dB), *G* = linear gain.
The first stage NF dominates — minimise LNA/driver NF for best system sensitivity.

---
> **Note:** All values are estimated from component datasheets at 25 °C nominal.
> Verify with bench measurements (spectrum analyser + noise source) during hardware bring-up.