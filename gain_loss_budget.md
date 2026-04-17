# RF Gain-Loss Budget
## receiver

**Generated:** 2026-04-17  
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
| 1 | Input Connector | 2.4mm connector | -0.2 | -0.2 | -20.2 | 0.20 | 0.20 | N/A | N/A | Insertion loss 0.2 dB at 10 GHz |
| 2 | LNA/VGA Stage 1 | HMC698LP4 | +22.0 | 21.8 | 1.8 | 5.00 | 5.01 | 1.0 | 25.0 | High gain, sets system NF |
| 3 | Bandpass Filter | Mini-Circuits VBF-5950+ | -2.0 | 19.8 | -0.2 | 2.00 | 5.14 | N/A | N/A | Image rejection filter, 2 dB insertion loss |
| 4 | I/Q Demodulator | HMC1048LP4E | +6.0 | 25.8 | 5.8 | 13.00 | 5.56 | 5.0 | 30.0 | Conversion gain 6 dB, IIP3 +24 dBm |
| 5 | Baseband Amplifier | AD8099 | +10.0 | 35.8 | 15.8 | 2.50 | 5.62 | 15.0 | 35.0 | Baseband I/Q gain, drives ADC |
| 6 | Anti-Alias Filter | LC network | -1.0 | 34.8 | 14.8 | 1.00 | 5.64 | N/A | N/A | 1 dB insertion loss |
| 7 | ADC I/Q | ADC12DJ3200 | +0.0 | 34.8 | 14.8 | 30.00 | 6.21 | 4.0 | 20.0 | Digital quantization, 57 dBFS SNR |

## 3. Budget Summary

| Metric | Value | Unit |
|--------|-------|------|
| Total System Gain     | 34.8  | dB  |
| Final Output Power    | 14.8  | dBm |
| Cascaded System NF    | 6.21 | dB  |
| Output Power Margin   | -24.8 | dB  |

## 4. Return Loss — Per Stage

| # | Stage | Component | S11 — Input RL (dB) | S22 — Output RL (dB) | Notes |
|---|-------|-----------|---------------------|----------------------|-------|
| 1 | Input Connector | 2.4mm connector | 25.0 | 25.0 | Insertion loss 0.2 dB at 10 GHz |
| 2 | LNA/VGA Stage 1 | HMC698LP4 | 12.0 | 12.0 | High gain, sets system NF |
| 3 | Bandpass Filter | Mini-Circuits VBF-5950+ | 15.0 | 15.0 | Image rejection filter, 2 dB insertion loss |
| 4 | I/Q Demodulator | HMC1048LP4E | 10.0 | 10.0 | Conversion gain 6 dB, IIP3 +24 dBm |
| 5 | Baseband Amplifier | AD8099 | 20.0 | 20.0 | Baseband I/Q gain, drives ADC |
| 6 | Anti-Alias Filter | LC network | 20.0 | 20.0 | 1 dB insertion loss |

> Return loss values are referenced to 50 Ω. Higher value = better match.

## 5. Cascade Noise Figure — Friis Formula

$$F_{{sys}} = F_1 + \frac{{F_2 - 1}}{{G_1}} + \frac{{F_3 - 1}}{{G_1 G_2}} + \cdots$$

Where *F* = linear noise factor (not dB), *G* = linear gain.
The first stage NF dominates — minimise LNA/driver NF for best system sensitivity.

---
> **Note:** All values are estimated from component datasheets at 25 °C nominal.
> Verify with bench measurements (spectrum analyser + noise source) during hardware bring-up.