# RF Gain-Loss Budget
## ehg

**Generated:** 2026-04-16  
**Document Status:** AI-GENERATED — verify against final component datasheets

## 1. System Parameters

| Parameter | Value | Unit |
|-----------|-------|------|
| Centre Frequency    | 11500   | MHz  |
| RF Bandwidth        | 13000     | MHz  |
| Input Signal Level  | -90   | dBm  |
| Target Output Power | -10  | dBm  |
| Required System Gain | 80 | dB   |

## 2. Stage-by-Stage Gain / Loss Budget

| # | Stage | Component | Gain/Loss (dB) | Cum. Gain (dB) | Output Power (dBm) | NF (dB) | Cum. NF (dB) | P1dB Out (dBm) | OIP3 (dBm) | Notes |
|---|-------|-----------|---------------|----------------|-------------------|---------|-------------|---------------|-----------|-------|
| 1 | RF Input Matching | SMA Connector + Matching Network | -0.5 | -0.5 | -90.5 | 0.50 | 0.50 | N/A | N/A | Input return loss 10 dB |
| 2 | LNA | HMC8141 | +20.0 | 19.5 | -70.5 | 3.00 | 3.04 | 18.0 | 28.0 | 6-18 GHz coverage |
| 3 | Variable Gain Amp | HMC698LP4 | +15.0 | 34.5 | -55.5 | 6.00 | 3.42 | 20.0 | 30.0 | Set to mid-gain for analysis |
| 4 | Bandpass Filter | VBF-1850+ | -2.0 | 32.5 | -57.5 | 2.00 | 3.59 | N/A | N/A | Image rejection |
| 5 | Mixer Downconverter | HMC-CMS19 | -8.0 | 24.5 | -65.5 | 8.00 | 4.17 | 16.0 | 24.0 | IF output ~1-2 GHz |
| 6 | IF Amplifier | HMC5805 | +20.0 | 44.5 | -45.5 | 6.00 | 4.35 | 22.0 | 32.0 | IF gain and matching |
| 7 | ADC Input | EV10AQ190A | -6.0 | 38.5 | -51.5 | 6.00 | 4.60 | 5.0 | 15.0 | SFDR 80 dB target |

## 3. Budget Summary

| Metric | Value | Unit |
|--------|-------|------|
| Total System Gain     | 38.5  | dB  |
| Final Output Power    | -51.5  | dBm |
| Cascaded System NF    | 4.60 | dB  |
| Output Power Margin   | +41.5 | dB  |

## 4. Return Loss — Per Stage

| # | Stage | Component | S11 — Input RL (dB) | S22 — Output RL (dB) | Notes |
|---|-------|-----------|---------------------|----------------------|-------|
| 1 | RF Input Matching | SMA Connector + Matching Network | 10.0 | 15.0 | Input return loss 10 dB |
| 2 | LNA | HMC8141 | 12.0 | 12.0 | 6-18 GHz coverage |
| 3 | Variable Gain Amp | HMC698LP4 | 10.0 | 10.0 | Set to mid-gain for analysis |
| 4 | Bandpass Filter | VBF-1850+ | 15.0 | 15.0 | Image rejection |
| 5 | Mixer Downconverter | HMC-CMS19 | 10.0 | 8.0 | IF output ~1-2 GHz |
| 6 | IF Amplifier | HMC5805 | 12.0 | 12.0 | IF gain and matching |
| 7 | ADC Input | EV10AQ190A | 10.0 | 99.0 | SFDR 80 dB target |

> Return loss values are referenced to 50 Ω. Higher value = better match.

## 5. Cascade Noise Figure — Friis Formula

$$F_{{sys}} = F_1 + \frac{{F_2 - 1}}{{G_1}} + \frac{{F_3 - 1}}{{G_1 G_2}} + \cdots$$

Where *F* = linear noise factor (not dB), *G* = linear gain.
The first stage NF dominates — minimise LNA/driver NF for best system sensitivity.

---
> **Note:** All values are estimated from component datasheets at 25 °C nominal.
> Verify with bench measurements (spectrum analyser + noise source) during hardware bring-up.