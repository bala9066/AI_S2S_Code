# RF Gain-Loss Budget
## sdfjbks

**Generated:** 2026-04-16  
**Document Status:** AI-GENERATED — verify against final component datasheets

## 1. System Parameters

| Parameter | Value | Unit |
|-----------|-------|------|
| Centre Frequency    | 11500   | MHz  |
| RF Bandwidth        | 13000     | MHz  |
| Input Signal Level  | -35   | dBm  |
| Target Output Power | -10  | dBm  |
| Required System Gain | 25 | dB   |

## 2. Stage-by-Stage Gain / Loss Budget

| # | Stage | Component | Gain/Loss (dB) | Cum. Gain (dB) | Output Power (dBm) | NF (dB) | Cum. NF (dB) | P1dB Out (dBm) | OIP3 (dBm) | Notes |
|---|-------|-----------|---------------|----------------|-------------------|---------|-------------|---------------|-----------|-------|
| 1 | RF Input Connector | 2.4mm female connector | -0.1 | -0.1 | -35.1 | 0.10 | 0.10 | N/A | N/A | Connector loss at 18 GHz |
| 2 | Bandpass Filter | BP06S-18S-A-SMA+ | -2.0 | -2.1 | -37.1 | 2.00 | 2.08 | N/A | N/A | 5-18 GHz band definition, 2 dB insertion loss |
| 3 | Wideband LNA Stage 1 | HMC6180LP4E | +20.0 | 17.9 | -17.1 | 3.50 | 3.53 | -15.0 | 33.0 | High gain stage, sets system noise figure |
| 4 | Variable Gain Amplifier | HMC698LP4 | +10.0 | 27.9 | -7.1 | 6.00 | 3.66 | -5.0 | 30.0 | Digital VGA, mid-band gain setting for AGC |
| 5 | Wideband IQ Mixer | HMC1051LP4E | -8.0 | 19.9 | -15.1 | 8.00 | 4.28 | 5.0 | 20.0 | Downconversion to IF, LO at +16 dBm drive |
| 6 | IF Amplifier | ADA4817 | +18.0 | 37.9 | 2.9 | 4.00 | 4.32 | 5.0 | 25.0 | ADC driver amplifier |
| 7 | ADC Input | ADC12DJ5200RF | +0.0 | 37.9 | 2.9 | 99.00 | 4.32 | -4.0 | N/A | Full-scale input -1 dBFS, matches target |

## 3. Budget Summary

| Metric | Value | Unit |
|--------|-------|------|
| Total System Gain     | 37.9  | dB  |
| Final Output Power    | 2.9  | dBm |
| Cascaded System NF    | 4.32 | dB  |
| Output Power Margin   | -12.9 | dB  |

## 4. Return Loss — Per Stage

| # | Stage | Component | S11 — Input RL (dB) | S22 — Output RL (dB) | Notes |
|---|-------|-----------|---------------------|----------------------|-------|
| 1 | RF Input Connector | 2.4mm female connector | 25.0 | 25.0 | Connector loss at 18 GHz |
| 2 | Bandpass Filter | BP06S-18S-A-SMA+ | 14.0 | 14.0 | 5-18 GHz band definition, 2 dB insertion loss |
| 3 | Wideband LNA Stage 1 | HMC6180LP4E | 12.0 | 10.0 | High gain stage, sets system noise figure |
| 4 | Variable Gain Amplifier | HMC698LP4 | 15.0 | 12.0 | Digital VGA, mid-band gain setting for AGC |
| 5 | Wideband IQ Mixer | HMC1051LP4E | 10.0 | 10.0 | Downconversion to IF, LO at +16 dBm drive |
| 6 | IF Amplifier | ADA4817 | 15.0 | 10.0 | ADC driver amplifier |

> Return loss values are referenced to 50 Ω. Higher value = better match.

## 5. Cascade Noise Figure — Friis Formula

$$F_{{sys}} = F_1 + \frac{{F_2 - 1}}{{G_1}} + \frac{{F_3 - 1}}{{G_1 G_2}} + \cdots$$

Where *F* = linear noise factor (not dB), *G* = linear gain.
The first stage NF dominates — minimise LNA/driver NF for best system sensitivity.

---
> **Note:** All values are estimated from component datasheets at 25 °C nominal.
> Verify with bench measurements (spectrum analyser + noise source) during hardware bring-up.