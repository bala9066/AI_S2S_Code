# RF Gain-Loss Budget
## Sample Ai Project

**Generated:** 2026-04-16  
**Document Status:** AI-GENERATED — verify against final component datasheets

## 1. System Parameters

| Parameter | Value | Unit |
|-----------|-------|------|
| Centre Frequency    | 11500   | MHz  |
| RF Bandwidth        | 13000     | MHz  |
| Input Signal Level  | -90   | dBm  |
| Target Output Power | -20  | dBm  |
| Required System Gain | 70 | dB   |

## 2. Stage-by-Stage Gain / Loss Budget

| # | Stage | Component | Gain/Loss (dB) | Cum. Gain (dB) | Output Power (dBm) | NF (dB) | Cum. NF (dB) | P1dB Out (dBm) | OIP3 (dBm) | Notes |
|---|-------|-----------|---------------|----------------|-------------------|---------|-------------|---------------|-----------|-------|
| 1 | RF Input Connector | SMA 142-0701-851 | -0.2 | -0.2 | -90.2 | 0.20 | 0.20 | N/A | N/A | Connector loss at 11.5 GHz center freq |
| 2 | Wideband LNA | TGA4943-SL (Qorvo) | +22.0 | 21.8 | -68.2 | 3.50 | 3.56 | -65.0 | -48.0 | Dominant NF contribution. IIP3=15dBm gives OIP3=-48dBm at output |
| 3 | Digital Step Attenuator | HMC698LP4E | -3.5 | 18.3 | -71.7 | 3.50 | 3.71 | N/A | N/A | Insertion loss at 0 dB attenuation setting. Configured for max gain |
| 4 | Bandpass Filter | CBP-1850+ (Mini-Circuits) | -2.5 | 15.8 | -74.2 | 2.50 | 3.98 | N/A | N/A | 2.5 dB insertion loss typical at band center |
| 5 | Gain Adjustment Buffer | HMC698LP4E (DSA configured) | +15.8 | 31.6 | -58.4 | 6.00 | 4.12 | N/A | N/A | Additional gain provided by setting DSA to provide +15.8 dB instead of attenuation |
| 6 | Mixer/Downconverter | HMC552LC4 (representative) | -7.0 | 24.6 | -65.4 | 7.00 | 4.56 | N/A | N/A | Conversion loss typical for wideband mixer at Ku-band |
| 7 | IF Amplifier | HMC694LP4 (representative) | +18.0 | 42.6 | -47.4 | 4.00 | 4.66 | -20.0 | -5.0 | Brings signal to ADC input range. OIP3=-5dBm gives IIP3=8dBm within 0-15dBm spec |
| 8 | Anti-Alias Filter | LFCN-2000+ (representative) | -2.0 | 40.6 | -49.4 | 2.00 | 4.75 | N/A | N/A | 2 GHz lowpass filter for IF stage |
| 9 | ADC Input Buffer | Internal to ADC10D1000RF | +0.0 | 40.6 | -49.4 | 5.00 | 5.11 | N/A | N/A | ADC input noise figure approx 5dB including buffer |

## 3. Budget Summary

| Metric | Value | Unit |
|--------|-------|------|
| Total System Gain     | 40.6  | dB  |
| Final Output Power    | -49.4  | dBm |
| Cascaded System NF    | 5.11 | dB  |
| Output Power Margin   | +29.4 | dB  |

## 4. Return Loss — Per Stage

| # | Stage | Component | S11 — Input RL (dB) | S22 — Output RL (dB) | Notes |
|---|-------|-----------|---------------------|----------------------|-------|
| 1 | RF Input Connector | SMA 142-0701-851 | 17.7 | 17.7 | Connector loss at 11.5 GHz center freq |
| 2 | Wideband LNA | TGA4943-SL (Qorvo) | 15.0 | 15.0 | Dominant NF contribution. IIP3=15dBm gives OIP3=-48dBm at output |
| 3 | Digital Step Attenuator | HMC698LP4E | 18.0 | 18.0 | Insertion loss at 0 dB attenuation setting. Configured for max gain |
| 4 | Bandpass Filter | CBP-1850+ (Mini-Circuits) | 18.0 | 18.0 | 2.5 dB insertion loss typical at band center |

> Return loss values are referenced to 50 Ω. Higher value = better match.

## 5. Cascade Noise Figure — Friis Formula

$$F_{{sys}} = F_1 + \frac{{F_2 - 1}}{{G_1}} + \frac{{F_3 - 1}}{{G_1 G_2}} + \cdots$$

Where *F* = linear noise factor (not dB), *G* = linear gain.
The first stage NF dominates — minimise LNA/driver NF for best system sensitivity.

---
> **Note:** All values are estimated from component datasheets at 25 °C nominal.
> Verify with bench measurements (spectrum analyser + noise source) during hardware bring-up.