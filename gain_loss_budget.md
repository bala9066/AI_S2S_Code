# RF Gain-Loss Budget
## Test

**Generated:** 2026-04-17  
**Document Status:** AI-GENERATED — verify against final component datasheets

## 1. System Parameters

| Parameter | Value | Unit |
|-----------|-------|------|
| Centre Frequency    | 11500   | MHz  |
| RF Bandwidth        | 13000     | MHz  |
| Input Signal Level  | -80   | dBm  |
| Target Output Power | 0  | dBm  |
| Required System Gain | 80 | dB   |

## 2. Stage-by-Stage Gain / Loss Budget

| # | Stage | Component | Gain/Loss (dB) | Cum. Gain (dB) | Output Power (dBm) | NF (dB) | Cum. NF (dB) | P1dB Out (dBm) | OIP3 (dBm) | Notes |
|---|-------|-----------|---------------|----------------|-------------------|---------|-------------|---------------|-----------|-------|
| 1 | Input Matching Network | RF trace + DC block + SMA connector | -0.5 | -0.5 | -80.5 | 0.50 | 0.50 | N/A | N/A | Wideband matching, minimal loss |
| 2 | Wideband LNA | HMC698LP4 | +20.0 | 19.5 | -60.5 | 3.50 | 3.59 | 18.0 | 30.0 | Front-end gain, sets noise floor |
| 3 | Digital Step Attenuator | QPC9054 (minimum loss setting) | -4.5 | 15.0 | -65.0 | 4.50 | 4.10 | 27.0 | 40.0 | Variable attenuation 0-31.75 dB, min loss shown |
| 4 | Anti-Alias Bandpass Filter | 5-18 GHz BPF | -2.0 | 13.0 | -67.0 | 2.00 | 4.19 | N/A | N/A | Wideband passband filter |
| 5 | Balun Transformer | EGL-2422-SM | -1.5 | 11.5 | -68.5 | 1.50 | 4.27 | N/A | N/A | Single-ended to differential conversion |
| 6 | ADC Input Buffer | ADC12DJ5200RF internal buffer | +0.0 | 11.5 | -68.5 | 6.00 | 7.12 | 4.0 | 20.0 | ADC analog input stage, effective NF includes quantization |

## 3. Budget Summary

| Metric | Value | Unit |
|--------|-------|------|
| Total System Gain     | 11.5  | dB  |
| Final Output Power    | -68.5  | dBm |
| Cascaded System NF    | 7.12 | dB  |
| Output Power Margin   | +68.5 | dB  |

## 4. Return Loss — Per Stage

| # | Stage | Component | S11 — Input RL (dB) | S22 — Output RL (dB) | Notes |
|---|-------|-----------|---------------------|----------------------|-------|
| 1 | Input Matching Network | RF trace + DC block + SMA connector | 15.0 | 20.0 | Wideband matching, minimal loss |
| 2 | Wideband LNA | HMC698LP4 | 12.0 | 15.0 | Front-end gain, sets noise floor |
| 3 | Digital Step Attenuator | QPC9054 (minimum loss setting) | 10.0 | 10.0 | Variable attenuation 0-31.75 dB, min loss shown |
| 4 | Anti-Alias Bandpass Filter | 5-18 GHz BPF | 12.0 | 12.0 | Wideband passband filter |
| 5 | Balun Transformer | EGL-2422-SM | 15.0 | 15.0 | Single-ended to differential conversion |
| 6 | ADC Input Buffer | ADC12DJ5200RF internal buffer | 20.0 | 0.0 | ADC analog input stage, effective NF includes quantization |

> Return loss values are referenced to 50 Ω. Higher value = better match.

## 5. Cascade Noise Figure — Friis Formula

$$F_{{sys}} = F_1 + \frac{{F_2 - 1}}{{G_1}} + \frac{{F_3 - 1}}{{G_1 G_2}} + \cdots$$

Where *F* = linear noise factor (not dB), *G* = linear gain.
The first stage NF dominates — minimise LNA/driver NF for best system sensitivity.

---
> **Note:** All values are estimated from component datasheets at 25 °C nominal.
> Verify with bench measurements (spectrum analyser + noise source) during hardware bring-up.