# RF Gain-Loss Budget
## dkfjg

**Generated:** 2026-04-16  
**Document Status:** AI-GENERATED — verify against final component datasheets

## 1. System Parameters

| Parameter | Value | Unit |
|-----------|-------|------|
| Centre Frequency    | 11500   | MHz  |
| RF Bandwidth        | 13000     | MHz  |
| Input Signal Level  | -70   | dBm  |
| Target Output Power | -30  | dBm  |
| Required System Gain | 40 | dB   |

## 2. Stage-by-Stage Gain / Loss Budget

| # | Stage | Component | Gain/Loss (dB) | Cum. Gain (dB) | Output Power (dBm) | NF (dB) | Cum. NF (dB) | P1dB Out (dBm) | OIP3 (dBm) | Notes |
|---|-------|-----------|---------------|----------------|-------------------|---------|-------------|---------------|-----------|-------|
| 1 | RF Input Connector | 2.92mm SMA Connector | -0.2 | -0.2 | -70.2 | 0.20 | 0.20 | N/A | N/A | Connector insertion loss @ 18 GHz |
| 2 | DC Blocking Capacitor | 100 pF C0G (AVX) | -0.1 | -0.3 | -70.3 | 0.10 | 0.30 | N/A | N/A | Negligible loss at 5-18 GHz |
| 3 | LNA Stage | HMC1042LP4BE | +24.0 | 23.7 | -46.3 | 2.50 | 2.68 | 18.0 | 24.0 | Primary gain stage, sets system NF |
| 4 | Variable Gain Amplifier | HMC698LP4 | +16.0 | 39.7 | -30.3 | 3.50 | 2.72 | 15.0 | 27.0 | Set to +16 dB for max gain mode |
| 5 | Bandpass Filter | CBP-1810-LF LTCC | -3.5 | 36.2 | -33.8 | 3.50 | 2.73 | N/A | N/A | 3.5 dB insertion loss, limits out-of-band noise |
| 6 | Mixer Downconverter | HMC774A | -7.5 | 28.7 | -41.3 | 7.50 | 2.84 | 15.0 | 25.0 | High linearity, requires 10-15 dBm LO drive |
| 7 | IF Amplifier | ADA4817 | +10.0 | 38.7 | -31.3 | 4.00 | 2.87 | 12.0 | 30.0 | IF gain stage, buffers for ADC input |

## 3. Budget Summary

| Metric | Value | Unit |
|--------|-------|------|
| Total System Gain     | 38.7  | dB  |
| Final Output Power    | -31.3  | dBm |
| Cascaded System NF    | 2.87 | dB  |
| Output Power Margin   | +1.3 | dB  |

## 4. Return Loss — Per Stage

| # | Stage | Component | S11 — Input RL (dB) | S22 — Output RL (dB) | Notes |
|---|-------|-----------|---------------------|----------------------|-------|
| 1 | RF Input Connector | 2.92mm SMA Connector | 25.0 | 25.0 | Connector insertion loss @ 18 GHz |
| 2 | LNA Stage | HMC1042LP4BE | 15.0 | 12.0 | Primary gain stage, sets system NF |
| 3 | Variable Gain Amplifier | HMC698LP4 | 12.0 | 10.0 | Set to +16 dB for max gain mode |
| 4 | Bandpass Filter | CBP-1810-LF LTCC | 15.0 | 15.0 | 3.5 dB insertion loss, limits out-of-band noise |
| 5 | Mixer Downconverter | HMC774A | 10.0 | 10.0 | High linearity, requires 10-15 dBm LO drive |
| 6 | IF Amplifier | ADA4817 | 10.0 | 10.0 | IF gain stage, buffers for ADC input |

> Return loss values are referenced to 50 Ω. Higher value = better match.

## 5. Cascade Noise Figure — Friis Formula

$$F_{{sys}} = F_1 + \frac{{F_2 - 1}}{{G_1}} + \frac{{F_3 - 1}}{{G_1 G_2}} + \cdots$$

Where *F* = linear noise factor (not dB), *G* = linear gain.
The first stage NF dominates — minimise LNA/driver NF for best system sensitivity.

---
> **Note:** All values are estimated from component datasheets at 25 °C nominal.
> Verify with bench measurements (spectrum analyser + noise source) during hardware bring-up.