# RF Gain-Loss Budget
## kgo

**Generated:** 2026-04-16  
**Document Status:** AI-GENERATED — verify against final component datasheets

## 1. System Parameters

| Parameter | Value | Unit |
|-----------|-------|------|
| Centre Frequency    | 11500   | MHz  |
| RF Bandwidth        | 13000     | MHz  |
| Input Signal Level  | -60   | dBm  |
| Target Output Power | -10  | dBm  |
| Required System Gain | 50 | dB   |

## 2. Stage-by-Stage Gain / Loss Budget

| # | Stage | Component | Gain/Loss (dB) | Cum. Gain (dB) | Output Power (dBm) | NF (dB) | Cum. NF (dB) | P1dB Out (dBm) | OIP3 (dBm) | Notes |
|---|-------|-----------|---------------|----------------|-------------------|---------|-------------|---------------|-----------|-------|
| 1 | Input Matching Network | Microstrip/stripline matching | -0.5 | -0.5 | -60.5 | 0.50 | 0.50 | N/A | N/A | Matching network for 5-18 GHz, broadband design |
| 2 | Wideband LNA | HMC1099LP4DE | +20.0 | 19.5 | -40.5 | 3.50 | 3.71 | -40.5 | -21.0 | First gain stage, dominates noise figure |
| 3 | Digital VGA | HMC698LP4 (set to +10 dB) | +10.0 | 29.5 | -30.5 | 5.00 | 3.95 | -25.0 | -8.0 | Variable gain for AGC, set mid-range |
| 4 | Bandpass Filter | 5-18 GHz BPF | -2.0 | 27.5 | -32.5 | 2.00 | 4.19 | N/A | N/A | Image rejection filter |
| 5 | Mixer (Downconversion) | HMC1052LP4E | -7.5 | 20.0 | -40.0 | 7.50 | 4.63 | -40.0 | -23.0 | Conversion loss 7.5 dB typical |
| 6 | IF Amplifier | IF gain stage (low noise) | +15.0 | 35.0 | -25.0 | 4.00 | 4.67 | -15.0 | 5.0 | Gain before ADC |
| 7 | ADC Input (Full Scale) | 12-bit ADC | +0.0 | 35.0 | -25.0 | 0.00 | 4.67 | 0.0 | N/A | Digital conversion, target -25 dBm input to ADC |

## 3. Budget Summary

| Metric | Value | Unit |
|--------|-------|------|
| Total System Gain     | 35.0  | dB  |
| Final Output Power    | -25.0  | dBm |
| Cascaded System NF    | 4.67 | dB  |
| Output Power Margin   | +15 | dB  |

## 4. Return Loss — Per Stage

| # | Stage | Component | S11 — Input RL (dB) | S22 — Output RL (dB) | Notes |
|---|-------|-----------|---------------------|----------------------|-------|
| 1 | Input Matching Network | Microstrip/stripline matching | 15.0 | 15.0 | Matching network for 5-18 GHz, broadband design |
| 2 | Wideband LNA | HMC1099LP4DE | 12.0 | 12.0 | First gain stage, dominates noise figure |
| 3 | Digital VGA | HMC698LP4 (set to +10 dB) | 15.0 | 15.0 | Variable gain for AGC, set mid-range |
| 4 | Bandpass Filter | 5-18 GHz BPF | 18.0 | 18.0 | Image rejection filter |
| 5 | Mixer (Downconversion) | HMC1052LP4E | 14.0 | 14.0 | Conversion loss 7.5 dB typical |
| 6 | IF Amplifier | IF gain stage (low noise) | 15.0 | 15.0 | Gain before ADC |
| 7 | ADC Input (Full Scale) | 12-bit ADC | 15.0 | 15.0 | Digital conversion, target -25 dBm input to ADC |

> Return loss values are referenced to 50 Ω. Higher value = better match.

## 5. Cascade Noise Figure — Friis Formula

$$F_{{sys}} = F_1 + \frac{{F_2 - 1}}{{G_1}} + \frac{{F_3 - 1}}{{G_1 G_2}} + \cdots$$

Where *F* = linear noise factor (not dB), *G* = linear gain.
The first stage NF dominates — minimise LNA/driver NF for best system sensitivity.

---
> **Note:** All values are estimated from component datasheets at 25 °C nominal.
> Verify with bench measurements (spectrum analyser + noise source) during hardware bring-up.