# RF Gain-Loss Budget
## j,fj

**Generated:** 2026-04-16  
**Document Status:** AI-GENERATED — verify against final component datasheets

## 1. System Parameters

| Parameter | Value | Unit |
|-----------|-------|------|
| Centre Frequency    | 11500   | MHz  |
| RF Bandwidth        | 4000     | MHz  |
| Input Signal Level  | -30   | dBm  |
| Target Output Power | -2  | dBm  |
| Required System Gain | 28 | dB   |

## 2. Stage-by-Stage Gain / Loss Budget

| # | Stage | Component | Gain/Loss (dB) | Cum. Gain (dB) | Output Power (dBm) | NF (dB) | Cum. NF (dB) | P1dB Out (dBm) | OIP3 (dBm) | Notes |
|---|-------|-----------|---------------|----------------|-------------------|---------|-------------|---------------|-----------|-------|
| 1 | ESD Protection Limiter | HMC1061LP3DE | -0.5 | -0.5 | -30.5 | 0.50 | 0.50 | 20.0 | 35.0 | Input protection, insertion loss |
| 2 | Wideband LNA | HMC1113LP3DE | +20.0 | 19.5 | -10.5 | 2.50 | 2.57 | 20.0 | 30.0 | Primary gain stage, sets system noise figure |
| 3 | Input Bandpass Filter | Custom 4.5-18.5 GHz | -2.0 | 17.5 | -12.5 | 2.00 | 2.84 | N/A | N/A | Image rejection filter |
| 4 | Mixer Downconverter | HMC1056LP4BE | -10.0 | 7.5 | -22.5 | 10.00 | 4.52 | 5.0 | 15.0 | Downconversion to IF, LO drive +17 dBm |
| 5 | IF Amplifier | HMC699LP4 VGA | +15.0 | 22.5 | -7.5 | 4.00 | 4.87 | 18.0 | 28.0 | Variable gain, mid-IF stage |
| 6 | ADC Driver/Final Gain | ADC12DJ3200 input | +5.5 | 28.0 | -2.0 | 5.00 | 5.23 | 4.0 | 15.0 | Sets proper ADC input level |

## 3. Budget Summary

| Metric | Value | Unit |
|--------|-------|------|
| Total System Gain     | 28.0  | dB  |
| Final Output Power    | -2.0  | dBm |
| Cascaded System NF    | 5.23 | dB  |
| Output Power Margin   | +0 | dB  |

## 4. Return Loss — Per Stage

| # | Stage | Component | S11 — Input RL (dB) | S22 — Output RL (dB) | Notes |
|---|-------|-----------|---------------------|----------------------|-------|
| 1 | ESD Protection Limiter | HMC1061LP3DE | 20.0 | 20.0 | Input protection, insertion loss |
| 2 | Wideband LNA | HMC1113LP3DE | 12.0 | 12.0 | Primary gain stage, sets system noise figure |
| 3 | Input Bandpass Filter | Custom 4.5-18.5 GHz | 15.0 | 15.0 | Image rejection filter |

> Return loss values are referenced to 50 Ω. Higher value = better match.

## 5. Cascade Noise Figure — Friis Formula

$$F_{{sys}} = F_1 + \frac{{F_2 - 1}}{{G_1}} + \frac{{F_3 - 1}}{{G_1 G_2}} + \cdots$$

Where *F* = linear noise factor (not dB), *G* = linear gain.
The first stage NF dominates — minimise LNA/driver NF for best system sensitivity.

---
> **Note:** All values are estimated from component datasheets at 25 °C nominal.
> Verify with bench measurements (spectrum analyser + noise source) during hardware bring-up.