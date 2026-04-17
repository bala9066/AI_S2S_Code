# RF Gain-Loss Budget
## jhf

**Generated:** 2026-04-17  
**Document Status:** AI-GENERATED — verify against final component datasheets

## 1. System Parameters

| Parameter | Value | Unit |
|-----------|-------|------|
| Centre Frequency    | 11500   | MHz  |
| RF Bandwidth        | 13000     | MHz  |
| Input Signal Level  | -50   | dBm  |
| Target Output Power | -10  | dBm  |
| Required System Gain | 40 | dB   |

## 2. Stage-by-Stage Gain / Loss Budget

| # | Stage | Component | Gain/Loss (dB) | Cum. Gain (dB) | Output Power (dBm) | NF (dB) | Cum. NF (dB) | P1dB Out (dBm) | OIP3 (dBm) | Notes |
|---|-------|-----------|---------------|----------------|-------------------|---------|-------------|---------------|-----------|-------|
| 1 | Input SMA Connector | Cinch 142-0701-851 | -0.1 | -0.1 | -50.1 | 0.10 | 0.10 | N/A | N/A | Connector loss |
| 2 | Bandpass Filter | UIY BP05G18G-06 | -2.5 | -2.6 | -52.6 | 2.50 | 2.51 | N/A | N/A | 5-18 GHz filter insertion loss |
| 3 | LNA Stage | HMC6180LP4E | +16.0 | 13.4 | -36.6 | 3.00 | 3.61 | 18.0 | 28.0 | Primary gain stage, low NF |
| 4 | VGA Stage | HMC698LP4 | +15.0 | 28.4 | -21.6 | 6.00 | 4.04 | 15.0 | 25.0 | Mid gain, variable control |
| 5 | Mixer Stage | HMC558LC4 | +8.0 | 36.4 | -13.6 | 8.00 | 4.32 | 15.0 | 25.0 | Downconversion to IF |
| 6 | IF Amplifier | ADL5541 | +20.0 | 56.4 | 6.4 | 4.00 | 4.35 | 18.0 | 35.0 | IF output drive |

## 3. Budget Summary

| Metric | Value | Unit |
|--------|-------|------|
| Total System Gain     | 56.4  | dB  |
| Final Output Power    | 6.4  | dBm |
| Cascaded System NF    | 4.35 | dB  |
| Output Power Margin   | -16.4 | dB  |

## 4. Return Loss — Per Stage

| # | Stage | Component | S11 — Input RL (dB) | S22 — Output RL (dB) | Notes |
|---|-------|-----------|---------------------|----------------------|-------|
| 1 | Input SMA Connector | Cinch 142-0701-851 | 20.0 | 20.0 | Connector loss |
| 2 | Bandpass Filter | UIY BP05G18G-06 | 15.0 | 15.0 | 5-18 GHz filter insertion loss |
| 3 | LNA Stage | HMC6180LP4E | 12.0 | 12.0 | Primary gain stage, low NF |

> Return loss values are referenced to 50 Ω. Higher value = better match.

## 5. Cascade Noise Figure — Friis Formula

$$F_{{sys}} = F_1 + \frac{{F_2 - 1}}{{G_1}} + \frac{{F_3 - 1}}{{G_1 G_2}} + \cdots$$

Where *F* = linear noise factor (not dB), *G* = linear gain.
The first stage NF dominates — minimise LNA/driver NF for best system sensitivity.

---
> **Note:** All values are estimated from component datasheets at 25 °C nominal.
> Verify with bench measurements (spectrum analyser + noise source) during hardware bring-up.