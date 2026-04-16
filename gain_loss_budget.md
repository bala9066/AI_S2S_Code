# RF Gain-Loss Budget
## mn

**Generated:** 2026-04-16  
**Document Status:** AI-GENERATED — verify against final component datasheets

## 1. System Parameters

| Parameter | Value | Unit |
|-----------|-------|------|
| Centre Frequency    | 11500   | MHz  |
| RF Bandwidth        | 13000     | MHz  |
| Input Signal Level  | -20   | dBm  |
| Target Output Power | -10  | dBm  |
| Required System Gain | 10 | dB   |

## 2. Stage-by-Stage Gain / Loss Budget

| # | Stage | Component | Gain/Loss (dB) | Cum. Gain (dB) | Output Power (dBm) | NF (dB) | Cum. NF (dB) | P1dB Out (dBm) | OIP3 (dBm) | Notes |
|---|-------|-----------|---------------|----------------|-------------------|---------|-------------|---------------|-----------|-------|
| 1 | RF Input Connector | 2.4mm PCB jack | -0.1 | -0.1 | -20.1 | — | — | — | — | Connector loss |
| 2 | Wideband LNA | HMC698LP4(E) | +20.0 | 19.9 | -0.1 | 2.50 | 2.50 | 18.0 | 28.0 | Primary gain stage |
| 3 | Variable Gain Amplifier | ADL5330 | +20.0 | 39.9 | 19.9 | 6.00 | 2.60 | 20.0 | 30.0 | Gain set to maximum for NF calculation |
| 4 | Bandpass Filter | 5-18 GHz BPF | -2.0 | 37.9 | 17.9 | 2.00 | 2.60 | — | — | Filter insertion loss |
| 5 | RF Mixer | HMC521LC4 | -8.0 | 29.9 | 9.9 | 8.00 | 2.70 | 12.0 | 22.0 | Downconversion loss |
| 6 | IF Amplifier | MMIC Amp | +15.0 | 44.9 | 24.9 | 4.00 | 2.70 | 15.0 | 25.0 | IF gain before ADC |
| 7 | ADC Input | ADC10D1000 | +0.0 | 44.9 | 24.9 | — | 2.70 | — | — | Requires -1 dBFS full scale, attenuator needed |

## 3. Budget Summary

| Metric | Value | Unit |
|--------|-------|------|
| Total System Gain     | 44.9  | dB  |
| Final Output Power    | 24.9  | dBm |
| Cascaded System NF    | 2.70 | dB  |
| Output Power Margin   | -34.9 | dB  |

## 4. Return Loss — Per Stage

| # | Stage | Component | S11 — Input RL (dB) | S22 — Output RL (dB) | Notes |
|---|-------|-----------|---------------------|----------------------|-------|
| 1 | RF Input Connector | 2.4mm PCB jack | 30.0 | — | Connector loss |
| 2 | Wideband LNA | HMC698LP4(E) | 15.0 | 12.0 | Primary gain stage |

> Return loss values are referenced to 50 Ω. Higher value = better match.

## 5. Cascade Noise Figure — Friis Formula

$$F_{{sys}} = F_1 + \frac{{F_2 - 1}}{{G_1}} + \frac{{F_3 - 1}}{{G_1 G_2}} + \cdots$$

Where *F* = linear noise factor (not dB), *G* = linear gain.
The first stage NF dominates — minimise LNA/driver NF for best system sensitivity.

---
> **Note:** All values are estimated from component datasheets at 25 °C nominal.
> Verify with bench measurements (spectrum analyser + noise source) during hardware bring-up.