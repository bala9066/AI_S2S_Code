# RF Gain-Loss Budget
## khg

**Generated:** 2026-04-16  
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
| 1 | Input Limiter | LPA-518+ | -0.5 | -0.5 | -50.5 | 0.50 | 0.50 | N/A | N/A | Protection for high input signals |
| 2 | Bandpass Filter | BP5G18G-5180-SM | -2.0 | -2.5 | -52.5 | 2.00 | 2.50 | N/A | N/A | Out-of-band rejection |
| 3 | Wideband LNA | TQM473552 | +20.0 | 17.5 | -32.5 | 3.50 | 3.65 | 18.0 | 30.0 | Primary gain stage, low NF critical |
| 4 | RF VGA | HMC698LP4 | -5.0 | 12.5 | -37.5 | 5.00 | 3.67 | N/A | 35.0 | Digital control 0-31.5 dB attenuation |
| 5 | IQ Demodulator | MWC-1440+ | -8.0 | 4.5 | -45.5 | 8.00 | 3.69 | N/A | N/A | Frequency translation to DC |
| 6 | IF VGA (Differential) | ADA4817-2 x2 (I/Q) | +10.0 | 14.5 | -35.5 | 4.00 | 3.72 | N/A | N/A | Variable gain driving ADC |
| 7 | ADC (Analog Front-End) | AD9213 | +0.0 | 14.5 | -35.5 | 0.00 | 3.72 | 4.0 | N/A | JESD204C digital output |

## 3. Budget Summary

| Metric | Value | Unit |
|--------|-------|------|
| Total System Gain     | 14.5  | dB  |
| Final Output Power    | -35.5  | dBm |
| Cascaded System NF    | 3.72 | dB  |
| Output Power Margin   | +30.5 | dB  |

## 4. Return Loss — Per Stage

| # | Stage | Component | S11 — Input RL (dB) | S22 — Output RL (dB) | Notes |
|---|-------|-----------|---------------------|----------------------|-------|
| 1 | Input Limiter | LPA-518+ | 15.0 | 18.0 | Protection for high input signals |
| 2 | Bandpass Filter | BP5G18G-5180-SM | 14.0 | 14.0 | Out-of-band rejection |
| 3 | Wideband LNA | TQM473552 | 12.0 | 15.0 | Primary gain stage, low NF critical |
| 4 | RF VGA | HMC698LP4 | 20.0 | 20.0 | Digital control 0-31.5 dB attenuation |
| 5 | IQ Demodulator | MWC-1440+ | 10.0 | 10.0 | Frequency translation to DC |
| 6 | IF VGA (Differential) | ADA4817-2 x2 (I/Q) | 20.0 | 10.0 | Variable gain driving ADC |
| 7 | ADC (Analog Front-End) | AD9213 | 15.0 | 99.0 | JESD204C digital output |

> Return loss values are referenced to 50 Ω. Higher value = better match.

## 5. Cascade Noise Figure — Friis Formula

$$F_{{sys}} = F_1 + \frac{{F_2 - 1}}{{G_1}} + \frac{{F_3 - 1}}{{G_1 G_2}} + \cdots$$

Where *F* = linear noise factor (not dB), *G* = linear gain.
The first stage NF dominates — minimise LNA/driver NF for best system sensitivity.

---
> **Note:** All values are estimated from component datasheets at 25 °C nominal.
> Verify with bench measurements (spectrum analyser + noise source) during hardware bring-up.