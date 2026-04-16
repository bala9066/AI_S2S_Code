# RF Gain-Loss Budget
## khv

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
| 1 | Input Matching Network | 50 Ohm microstrip transformer | -0.5 | -0.5 | -60.5 | 0.50 | 0.50 | N/A | N/A | Impedance match to LNA input |
| 2 | Wideband LNA | HMC698LP4 | +24.0 | 23.5 | -36.5 | 3.50 | 3.51 | -6.0 | 4.0 | Primary gain stage, defines NF |
| 3 | Variable Gain Amplifier | HMC698LP4 integrated VGA | -10.0 | 13.5 | -46.5 | 10.00 | 3.59 | -16.0 | -6.0 | Set to -10 dB for max input |
| 4 | Bandpass Filter | Mini-Circuits BP5G18G+ | -2.5 | 11.0 | -49.0 | 2.50 | 3.68 | N/A | N/A | Anti-aliasing filter |
| 5 | ADC Input Buffer | Internal to ADC | -1.0 | 10.0 | -50.0 | 1.00 | 3.72 | -5.0 | 15.0 | ADC analog input buffer |
| 6 | ADC Digitizer | EV12AQ600 ADC | +0.0 | 10.0 | -50.0 | 0.00 | 3.72 | N/A | N/A | Quantization and digitization |

## 3. Budget Summary

| Metric | Value | Unit |
|--------|-------|------|
| Total System Gain     | 10.0  | dB  |
| Final Output Power    | -50.0  | dBm |
| Cascaded System NF    | 3.72 | dB  |
| Output Power Margin   | +40 | dB  |

## 4. Return Loss — Per Stage

| # | Stage | Component | S11 — Input RL (dB) | S22 — Output RL (dB) | Notes |
|---|-------|-----------|---------------------|----------------------|-------|
| 1 | Input Matching Network | 50 Ohm microstrip transformer | 20.0 | 20.0 | Impedance match to LNA input |
| 2 | Wideband LNA | HMC698LP4 | 15.0 | 15.0 | Primary gain stage, defines NF |
| 3 | Variable Gain Amplifier | HMC698LP4 integrated VGA | 15.0 | 15.0 | Set to -10 dB for max input |

> Return loss values are referenced to 50 Ω. Higher value = better match.

## 5. Cascade Noise Figure — Friis Formula

$$F_{{sys}} = F_1 + \frac{{F_2 - 1}}{{G_1}} + \frac{{F_3 - 1}}{{G_1 G_2}} + \cdots$$

Where *F* = linear noise factor (not dB), *G* = linear gain.
The first stage NF dominates — minimise LNA/driver NF for best system sensitivity.

---
> **Note:** All values are estimated from component datasheets at 25 °C nominal.
> Verify with bench measurements (spectrum analyser + noise source) during hardware bring-up.