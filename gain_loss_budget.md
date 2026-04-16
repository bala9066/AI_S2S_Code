# RF Gain-Loss Budget
## kb

**Generated:** 2026-04-16  
**Document Status:** AI-GENERATED — verify against final component datasheets

## 1. System Parameters

| Parameter | Value | Unit |
|-----------|-------|------|
| Centre Frequency    | 11500   | MHz  |
| RF Bandwidth        | 13000     | MHz  |
| Input Signal Level  | -140   | dBm  |
| Target Output Power | -10  | dBm  |
| Required System Gain | 130 | dB   |

## 2. Stage-by-Stage Gain / Loss Budget

| # | Stage | Component | Gain/Loss (dB) | Cum. Gain (dB) | Output Power (dBm) | NF (dB) | Cum. NF (dB) | P1dB Out (dBm) | OIP3 (dBm) | Notes |
|---|-------|-----------|---------------|----------------|-------------------|---------|-------------|---------------|-----------|-------|
| 1 | RF Input Limiter | LMLPF-BV-0+ | -0.5 | -0.5 | -140.5 | 0.50 | 0.50 | N/A | N/A | Input protection, minimal insertion loss |
| 2 | Wideband Bandpass Filter | VBFZ-5580+ | -2.5 | -3.0 | -143.0 | 2.50 | 2.61 | N/A | N/A | Passband filtering 5-18 GHz |
| 3 | Wideband LNA | TGA4956-SM | +22.0 | 19.0 | -121.0 | 2.50 | 2.76 | 18.0 | 28.0 | Primary gain stage, low noise |
| 4 | Variable Gain Attenuator | HMC698LP4 | -15.8 | 3.2 | -136.8 | 15.75 | 3.95 | 20.0 | 35.0 | Mid-range attenuation setting for AGC |
| 5 | Wideband Mixer | MAMX-011034 | -8.0 | -4.8 | -144.8 | 8.00 | 5.89 | 7.0 | 17.0 | Downconversion to IF |
| 6 | IF Bandpass Filter | BP1-500+ | -2.0 | -6.8 | -146.8 | 2.00 | 6.26 | N/A | N/A | Anti-alias filtering |
| 7 | IF Driver Amplifier | ADA4817-1 | +16.8 | 10.0 | -130.0 | 6.00 | 6.48 | 15.0 | 25.0 | Drive to ADC input |
| 8 | ADC Input | ADC12DJ3200 | -10.0 | 0.0 | -140.0 | 30.00 | 7.94 | 5.0 | 15.0 | Full-scale reference, includes SFDR |

## 3. Budget Summary

| Metric | Value | Unit |
|--------|-------|------|
| Total System Gain     | 0.0  | dB  |
| Final Output Power    | -140.0  | dBm |
| Cascaded System NF    | 7.94 | dB  |
| Output Power Margin   | +130 | dB  |

## 4. Return Loss — Per Stage

| # | Stage | Component | S11 — Input RL (dB) | S22 — Output RL (dB) | Notes |
|---|-------|-----------|---------------------|----------------------|-------|
| 1 | RF Input Limiter | LMLPF-BV-0+ | 15.0 | 15.0 | Input protection, minimal insertion loss |
| 2 | Wideband Bandpass Filter | VBFZ-5580+ | 12.0 | 12.0 | Passband filtering 5-18 GHz |
| 3 | Wideband LNA | TGA4956-SM | 10.0 | 10.0 | Primary gain stage, low noise |
| 4 | Variable Gain Attenuator | HMC698LP4 | 20.0 | 20.0 | Mid-range attenuation setting for AGC |
| 5 | Wideband Mixer | MAMX-011034 | 10.0 | 10.0 | Downconversion to IF |
| 6 | IF Bandpass Filter | BP1-500+ | 15.0 | 15.0 | Anti-alias filtering |
| 7 | IF Driver Amplifier | ADA4817-1 | 20.0 | 20.0 | Drive to ADC input |
| 8 | ADC Input | ADC12DJ3200 | 15.0 | 15.0 | Full-scale reference, includes SFDR |

> Return loss values are referenced to 50 Ω. Higher value = better match.

## 5. Cascade Noise Figure — Friis Formula

$$F_{{sys}} = F_1 + \frac{{F_2 - 1}}{{G_1}} + \frac{{F_3 - 1}}{{G_1 G_2}} + \cdots$$

Where *F* = linear noise factor (not dB), *G* = linear gain.
The first stage NF dominates — minimise LNA/driver NF for best system sensitivity.

---
> **Note:** All values are estimated from component datasheets at 25 °C nominal.
> Verify with bench measurements (spectrum analyser + noise source) during hardware bring-up.