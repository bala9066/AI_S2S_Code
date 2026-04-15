# RF Gain-Loss Budget
## iguyc

**Generated:** 2026-04-15  
**Document Status:** AI-GENERATED — verify against final component datasheets

## 1. System Parameters

| Parameter | Value | Unit |
|-----------|-------|------|
| Centre Frequency    | 11500   | MHz  |
| RF Bandwidth        | 2000     | MHz  |
| Input Signal Level  | -55   | dBm  |
| Target Output Power | -10  | dBm  |
| Required System Gain | 45 | dB   |

## 2. Stage-by-Stage Gain / Loss Budget

| # | Stage | Component | Gain/Loss (dB) | Cum. Gain (dB) | Output Power (dBm) | NF (dB) | Cum. NF (dB) | P1dB Out (dBm) | OIP3 (dBm) | Notes |
|---|-------|-----------|---------------|----------------|-------------------|---------|-------------|---------------|-----------|-------|
| 1 | RF Input Connector | 2.4mm Connector | -0.5 | -0.5 | -55.5 | 0.50 | 0.50 | N/A | N/A | Connector loss |
| 2 | Wideband LNA | HMC6987LP4E | +13.0 | 12.5 | -42.5 | 3.00 | 3.20 | 18.0 | 30.0 | Primary gain stage with low NF |
| 3 | Bandpass Filter | RBP-5180-10 | -2.0 | 10.5 | -44.5 | 2.00 | 3.40 | N/A | N/A | Front-end filtering |
| 4 | Downconversion Mixer | HMC1194LP4E | -7.5 | 3.0 | -52.0 | 7.50 | 4.10 | N/A | 25.0 | First downconversion to IF |
| 5 | IF Amplifier | HMC698LP4 | +20.0 | 23.0 | -32.0 | 6.00 | 4.30 | 15.0 | 28.0 | Gain recovery with VGA |
| 6 | IF Bandpass Filter | Custom IF BPF | -2.0 | 21.0 | -34.0 | 2.00 | 4.50 | N/A | N/A | IF filtering for channel selection |
| 7 | Variable Gain Amplifier | HMC698LP4 (AGC) | +10.0 | 31.0 | -24.0 | 6.00 | 4.60 | 14.0 | 28.0 | AGC adjustment range 0-31 dB |
| 8 | ADC Input Driver | Transformer Matching | -6.0 | 25.0 | -30.0 | 6.00 | 4.90 | N/A | N/A | Impedance matching to ADC |

## 3. Budget Summary

| Metric | Value | Unit |
|--------|-------|------|
| Total System Gain     | 25.0  | dB  |
| Final Output Power    | -30.0  | dBm |
| Cascaded System NF    | 4.90 | dB  |
| Output Power Margin   | +20 | dB  |

## 4. Return Loss — Per Stage

| # | Stage | Component | S11 — Input RL (dB) | S22 — Output RL (dB) | Notes |
|---|-------|-----------|---------------------|----------------------|-------|
| 1 | RF Input Connector | 2.4mm Connector | 20.0 | 20.0 | Connector loss |
| 2 | Wideband LNA | HMC6987LP4E | 15.0 | 15.0 | Primary gain stage with low NF |
| 3 | Bandpass Filter | RBP-5180-10 | 20.0 | 20.0 | Front-end filtering |
| 4 | Downconversion Mixer | HMC1194LP4E | 10.0 | 10.0 | First downconversion to IF |
| 5 | IF Amplifier | HMC698LP4 | 15.0 | 12.0 | Gain recovery with VGA |
| 6 | IF Bandpass Filter | Custom IF BPF | 20.0 | 20.0 | IF filtering for channel selection |
| 7 | Variable Gain Amplifier | HMC698LP4 (AGC) | 15.0 | 12.0 | AGC adjustment range 0-31 dB |
| 8 | ADC Input Driver | Transformer Matching | 20.0 | 20.0 | Impedance matching to ADC |

> Return loss values are referenced to 50 Ω. Higher value = better match.

## 5. Cascade Noise Figure — Friis Formula

$$F_{{sys}} = F_1 + \frac{{F_2 - 1}}{{G_1}} + \frac{{F_3 - 1}}{{G_1 G_2}} + \cdots$$

Where *F* = linear noise factor (not dB), *G* = linear gain.
The first stage NF dominates — minimise LNA/driver NF for best system sensitivity.

---
> **Note:** All values are estimated from component datasheets at 25 °C nominal.
> Verify with bench measurements (spectrum analyser + noise source) during hardware bring-up.