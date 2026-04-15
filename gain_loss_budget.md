# RF Gain-Loss Budget
## hgyu

**Generated:** 2026-04-15  
**Document Status:** AI-GENERATED — verify against final component datasheets

## 1. System Parameters

| Parameter | Value | Unit |
|-----------|-------|------|
| Centre Frequency    | 11500   | MHz  |
| RF Bandwidth        | 5000     | MHz  |
| Input Signal Level  | -50   | dBm  |
| Target Output Power | -5  | dBm  |
| Required System Gain | 45 | dB   |

## 2. Stage-by-Stage Gain / Loss Budget

| # | Stage | Component | Gain/Loss (dB) | Cum. Gain (dB) | Output Power (dBm) | NF (dB) | Cum. NF (dB) | P1dB Out (dBm) | OIP3 (dBm) | Notes |
|---|-------|-----------|---------------|----------------|-------------------|---------|-------------|---------------|-----------|-------|
| 1 | Input Matching Network | SMA connector + microstrip matching | -0.5 | -0.5 | -50.5 | 0.50 | 0.50 | N/A | N/A | 50 ohm match, minimal loss |
| 2 | Wideband LNA | HMC1132LP6GE | +23.0 | 22.5 | -27.5 | 3.50 | 3.56 | 18.0 | 33.0 | First gain stage, dominates NF |
| 3 | Digital Attenuator/VGA | HMC698LP4 (set to 0 dB for max gain) | -4.0 | 18.5 | -31.5 | 4.00 | 3.81 | 25.0 | 40.0 | 0.5 dB steps, 0-31.5 dB range |
| 4 | Anti-Alias Filter | RBP-8250+ bandpass filter | -2.5 | 16.0 | -34.0 | 2.50 | 3.92 | N/A | N/A | 2.5 dB insertion loss, provides anti-aliasing |
| 5 | ADC Input Buffer | Internal to ADC10DX100 | +0.0 | 16.0 | -34.0 | 20.00 | 7.92 | 5.0 | 15.0 | ADC input termination, bandwidth limited to 3.5 GHz |

## 3. Budget Summary

| Metric | Value | Unit |
|--------|-------|------|
| Total System Gain     | 16.0  | dB  |
| Final Output Power    | -34.0  | dBm |
| Cascaded System NF    | 7.92 | dB  |
| Output Power Margin   | +29 | dB  |

## 4. Return Loss — Per Stage

| # | Stage | Component | S11 — Input RL (dB) | S22 — Output RL (dB) | Notes |
|---|-------|-----------|---------------------|----------------------|-------|
| 1 | Input Matching Network | SMA connector + microstrip matching | 15.0 | 20.0 | 50 ohm match, minimal loss |
| 2 | Wideband LNA | HMC1132LP6GE | 12.0 | 15.0 | First gain stage, dominates NF |
| 3 | Digital Attenuator/VGA | HMC698LP4 (set to 0 dB for max gain) | 20.0 | 20.0 | 0.5 dB steps, 0-31.5 dB range |

> Return loss values are referenced to 50 Ω. Higher value = better match.

## 5. Cascade Noise Figure — Friis Formula

$$F_{{sys}} = F_1 + \frac{{F_2 - 1}}{{G_1}} + \frac{{F_3 - 1}}{{G_1 G_2}} + \cdots$$

Where *F* = linear noise factor (not dB), *G* = linear gain.
The first stage NF dominates — minimise LNA/driver NF for best system sensitivity.

---
> **Note:** All values are estimated from component datasheets at 25 °C nominal.
> Verify with bench measurements (spectrum analyser + noise source) during hardware bring-up.