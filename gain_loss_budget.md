# RF Gain-Loss Budget
## rbfgf

**Generated:** 2026-04-16  
**Document Status:** AI-GENERATED — verify against final component datasheets

## 1. System Parameters

| Parameter | Value | Unit |
|-----------|-------|------|
| Centre Frequency    | 11500   | MHz  |
| RF Bandwidth        | 3500     | MHz  |
| Input Signal Level  | -10   | dBm  |
| Target Output Power | -10  | dBm  |
| Required System Gain | 0 | dB   |

## 2. Stage-by-Stage Gain / Loss Budget

| # | Stage | Component | Gain/Loss (dB) | Cum. Gain (dB) | Output Power (dBm) | NF (dB) | Cum. NF (dB) | P1dB Out (dBm) | OIP3 (dBm) | Notes |
|---|-------|-----------|---------------|----------------|-------------------|---------|-------------|---------------|-----------|-------|
| 1 | Input Limiter | LMC6048 | -0.5 | -0.5 | -10.5 | 0.50 | 0.50 | 20.0 | N/A | Protection >20dBm threshold |
| 2 | Wideband LNA | TGA4538 | +22.0 | 21.5 | 11.5 | 2.50 | 2.51 | 18.0 | 30.0 | Primary gain stage, dominant NF |
| 3 | Input Bandpass Filter | Custom BPF 5-18GHz | -2.0 | 19.5 | 9.5 | 2.00 | 2.56 | N/A | N/A | Image rejection, anti-alias |
| 4 | Mixer Downconverter | HMC698LP4 | -7.0 | 12.5 | 2.5 | 7.00 | 2.94 | 15.0 | 24.0 | Downconvert to IF 2-5GHz |
| 5 | IF Amplifier | HMC698LP4 IF Amp | +15.0 | 27.5 | 17.5 | 3.50 | 2.99 | 20.0 | 35.0 | Drive IF chain |
| 6 | Variable Gain Amplifier | HMC698LP4 VGA | +0.0 | 27.5 | 17.5 | 4.00 | 3.02 | 25.0 | 35.0 | Set to 0dB for NF calculation, adjustable ±30dB |
| 7 | IF Bandpass Filter | Custom BPF 2-5GHz | -3.0 | 24.5 | 14.5 | 3.00 | 3.12 | N/A | N/A | Channel selection filter |
| 8 | ADC Driver Amplifier | ADC12J4000 Driver | +10.0 | 34.5 | 24.5 | 5.00 | 3.15 | 15.0 | 35.0 | Final drive to ADC input |

## 3. Budget Summary

| Metric | Value | Unit |
|--------|-------|------|
| Total System Gain     | 34.5  | dB  |
| Final Output Power    | 24.5  | dBm |
| Cascaded System NF    | 3.15 | dB  |
| Output Power Margin   | -34.5 | dB  |

## 4. Return Loss — Per Stage

| # | Stage | Component | S11 — Input RL (dB) | S22 — Output RL (dB) | Notes |
|---|-------|-----------|---------------------|----------------------|-------|
| 1 | Input Limiter | LMC6048 | 20.0 | 20.0 | Protection >20dBm threshold |
| 2 | Wideband LNA | TGA4538 | 15.0 | 12.0 | Primary gain stage, dominant NF |
| 3 | Input Bandpass Filter | Custom BPF 5-18GHz | 18.0 | 18.0 | Image rejection, anti-alias |
| 4 | Mixer Downconverter | HMC698LP4 | 12.0 | 10.0 | Downconvert to IF 2-5GHz |
| 5 | IF Amplifier | HMC698LP4 IF Amp | 15.0 | 15.0 | Drive IF chain |
| 6 | Variable Gain Amplifier | HMC698LP4 VGA | 18.0 | 18.0 | Set to 0dB for NF calculation, adjustable ±30dB |
| 7 | IF Bandpass Filter | Custom BPF 2-5GHz | 18.0 | 18.0 | Channel selection filter |
| 8 | ADC Driver Amplifier | ADC12J4000 Driver | 15.0 | 15.0 | Final drive to ADC input |

> Return loss values are referenced to 50 Ω. Higher value = better match.

## 5. Cascade Noise Figure — Friis Formula

$$F_{{sys}} = F_1 + \frac{{F_2 - 1}}{{G_1}} + \frac{{F_3 - 1}}{{G_1 G_2}} + \cdots$$

Where *F* = linear noise factor (not dB), *G* = linear gain.
The first stage NF dominates — minimise LNA/driver NF for best system sensitivity.

---
> **Note:** All values are estimated from component datasheets at 25 °C nominal.
> Verify with bench measurements (spectrum analyser + noise source) during hardware bring-up.