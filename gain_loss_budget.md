# RF Gain-Loss Budget
## dfbvd

**Generated:** 2026-04-16  
**Document Status:** AI-GENERATED — verify against final component datasheets

## 1. System Parameters

| Parameter | Value | Unit |
|-----------|-------|------|
| Centre Frequency    | 11500   | MHz  |
| RF Bandwidth        | 13000     | MHz  |
| Input Signal Level  | -100   | dBm  |
| Target Output Power | -10  | dBm  |
| Required System Gain | 90 | dB   |

## 2. Stage-by-Stage Gain / Loss Budget

| # | Stage | Component | Gain/Loss (dB) | Cum. Gain (dB) | Output Power (dBm) | NF (dB) | Cum. NF (dB) | P1dB Out (dBm) | OIP3 (dBm) | Notes |
|---|-------|-----------|---------------|----------------|-------------------|---------|-------------|---------------|-----------|-------|
| 1 | RF Input ESD/Limiter | ESD Protection + Limiter | -0.5 | -0.5 | -100.5 | 0.50 | 0.50 | 20.0 | 40.0 | Input protection, minimal loss |
| 2 | Wideband LNA | HMC1099LP4E | +20.0 | 19.5 | -80.5 | 3.50 | 3.53 | 21.0 | 34.0 | Primary gain stage, sets NF |
| 3 | RF Bandpass Filter | CBP-5180-C+ | -2.5 | 17.0 | -83.0 | 2.50 | 3.68 | N/A | N/A | Out-of-band rejection |
| 4 | Driver Amplifier | HMC1099LP4E (2nd stage) | +15.0 | 32.0 | -68.0 | 3.50 | 3.74 | 21.0 | 34.0 | Boosts signal for mixer |
| 5 | Mixer Downconverter | HMC1022LP4E | -9.0 | 23.0 | -77.0 | 9.00 | 4.54 | 15.0 | 24.0 | RF to IF translation, LO drive 15dBm |
| 6 | IF Amplifier | HMC698LP4 | +20.0 | 43.0 | -57.0 | 4.00 | 4.60 | 18.0 | 32.0 | IF gain stage |
| 7 | IF Bandpass Filter | IF Filter (anti-alias) | -2.0 | 41.0 | -59.0 | 2.00 | 4.66 | N/A | N/A | Anti-aliasing, noise bandwidth limiting |
| 8 | Variable Gain Amplifier | ADL5202 | +10.0 | 51.0 | -49.0 | 6.50 | 5.12 | 20.0 | 44.0 | Gain control for AGC, set to 10dB |
| 9 | ADC Input Buffer | ADC input network | -1.0 | 50.0 | -50.0 | 1.00 | 5.22 | 5.0 | N/A | ADC interface, matching |
| 10 | ADC Digitizer | ADC12DJ3200 | +0.0 | 50.0 | -50.0 | 0.00 | 5.22 | 5.0 | N/A | Digital quantization, 70dB SFDR |

## 3. Budget Summary

| Metric | Value | Unit |
|--------|-------|------|
| Total System Gain     | 50.0  | dB  |
| Final Output Power    | -50.0  | dBm |
| Cascaded System NF    | 5.22 | dB  |
| Output Power Margin   | +40 | dB  |

## 4. Return Loss — Per Stage

| # | Stage | Component | S11 — Input RL (dB) | S22 — Output RL (dB) | Notes |
|---|-------|-----------|---------------------|----------------------|-------|
| 1 | RF Input ESD/Limiter | ESD Protection + Limiter | 20.0 | 20.0 | Input protection, minimal loss |
| 2 | Wideband LNA | HMC1099LP4E | 15.0 | 12.0 | Primary gain stage, sets NF |
| 3 | RF Bandpass Filter | CBP-5180-C+ | 15.0 | 15.0 | Out-of-band rejection |
| 4 | Driver Amplifier | HMC1099LP4E (2nd stage) | 15.0 | 12.0 | Boosts signal for mixer |
| 5 | Mixer Downconverter | HMC1022LP4E | 10.0 | 10.0 | RF to IF translation, LO drive 15dBm |
| 6 | IF Amplifier | HMC698LP4 | 12.0 | 12.0 | IF gain stage |
| 7 | IF Bandpass Filter | IF Filter (anti-alias) | 15.0 | 15.0 | Anti-aliasing, noise bandwidth limiting |
| 8 | Variable Gain Amplifier | ADL5202 | 15.0 | 15.0 | Gain control for AGC, set to 10dB |
| 9 | ADC Input Buffer | ADC input network | 15.0 | 15.0 | ADC interface, matching |
| 10 | ADC Digitizer | ADC12DJ3200 | 15.0 | 15.0 | Digital quantization, 70dB SFDR |

> Return loss values are referenced to 50 Ω. Higher value = better match.

## 5. Cascade Noise Figure — Friis Formula

$$F_{{sys}} = F_1 + \frac{{F_2 - 1}}{{G_1}} + \frac{{F_3 - 1}}{{G_1 G_2}} + \cdots$$

Where *F* = linear noise factor (not dB), *G* = linear gain.
The first stage NF dominates — minimise LNA/driver NF for best system sensitivity.

---
> **Note:** All values are estimated from component datasheets at 25 °C nominal.
> Verify with bench measurements (spectrum analyser + noise source) during hardware bring-up.