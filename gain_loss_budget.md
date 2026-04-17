# RF Gain-Loss Budget
## receiver

**Generated:** 2026-04-17  
**Document Status:** AI-GENERATED — verify against final component datasheets

## 1. System Parameters

| Parameter | Value | Unit |
|-----------|-------|------|
| Centre Frequency    | 11500   | MHz  |
| RF Bandwidth        | 13000     | MHz  |
| Input Signal Level  | -30   | dBm  |
| Target Output Power | -10  | dBm  |
| Required System Gain | 20 | dB   |

## 2. Stage-by-Stage Gain / Loss Budget

| # | Stage | Component | Gain/Loss (dB) | Cum. Gain (dB) | Output Power (dBm) | NF (dB) | Cum. NF (dB) | P1dB Out (dBm) | OIP3 (dBm) | Notes |
|---|-------|-----------|---------------|----------------|-------------------|---------|-------------|---------------|-----------|-------|
| 1 | RF Input Connector | SMA Female 50Ω | -0.1 | -0.1 | -30.1 | 0.10 | 0.10 | N/A | N/A | Connector insertion loss, VSWR 1.2:1 |
| 2 | RF Limiter | HMC1061LP4E | -1.8 | -1.9 | -31.9 | 1.80 | 1.90 | N/A | N/A | Overpower protection, activated at 20 dBm |
| 3 | Wideband LNA | TGA4506-SM | +21.0 | 19.1 | -10.9 | 2.50 | 3.03 | 18.0 | 30.0 | Primary gain stage, sets system noise figure |
| 4 | Variable Gain Amplifier | HMC698LP4 (at 15 dB gain) | +15.0 | 34.1 | 4.1 | 5.00 | 3.04 | 17.0 | 26.0 | Digital gain control 0-31 dB, set to mid-range |
| 5 | IQ Mixer Downconverter | HMC1052LP4E | +10.0 | 44.1 | 14.1 | 11.00 | 3.05 | 12.0 | 23.0 | Frequency translation to baseband IF |
| 6 | IF Amplifier | ADA4817 | +10.0 | 54.1 | 24.1 | 2.50 | 3.05 | 20.0 | 35.0 | Baseband I/Q amplification |
| 7 | Anti-Alias Filter | LPF-1000+ | -2.0 | 52.1 | 22.1 | 2.00 | 3.05 | N/A | N/A | Filter for ADC anti-aliasing |
| 8 | ADC Input | AD9208 | +0.0 | 52.1 | 22.1 | 30.00 | 3.05 | 4.0 | N/A | Digitization point, 1V full-scale |

## 3. Budget Summary

| Metric | Value | Unit |
|--------|-------|------|
| Total System Gain     | 52.1  | dB  |
| Final Output Power    | 22.1  | dBm |
| Cascaded System NF    | 3.05 | dB  |
| Output Power Margin   | -32.1 | dB  |

## 4. Return Loss — Per Stage

| # | Stage | Component | S11 — Input RL (dB) | S22 — Output RL (dB) | Notes |
|---|-------|-----------|---------------------|----------------------|-------|
| 1 | RF Input Connector | SMA Female 50Ω | 20.0 | 20.0 | Connector insertion loss, VSWR 1.2:1 |
| 2 | RF Limiter | HMC1061LP4E | 15.0 | 15.0 | Overpower protection, activated at 20 dBm |
| 3 | Wideband LNA | TGA4506-SM | 12.0 | 12.0 | Primary gain stage, sets system noise figure |
| 4 | Variable Gain Amplifier | HMC698LP4 (at 15 dB gain) | 10.0 | 10.0 | Digital gain control 0-31 dB, set to mid-range |
| 5 | IQ Mixer Downconverter | HMC1052LP4E | 10.0 | 10.0 | Frequency translation to baseband IF |
| 6 | IF Amplifier | ADA4817 | 12.0 | 12.0 | Baseband I/Q amplification |
| 7 | Anti-Alias Filter | LPF-1000+ | 15.0 | 15.0 | Filter for ADC anti-aliasing |
| 8 | ADC Input | AD9208 | 10.0 | 99.0 | Digitization point, 1V full-scale |

> Return loss values are referenced to 50 Ω. Higher value = better match.

## 5. Cascade Noise Figure — Friis Formula

$$F_{{sys}} = F_1 + \frac{{F_2 - 1}}{{G_1}} + \frac{{F_3 - 1}}{{G_1 G_2}} + \cdots$$

Where *F* = linear noise factor (not dB), *G* = linear gain.
The first stage NF dominates — minimise LNA/driver NF for best system sensitivity.

---
> **Note:** All values are estimated from component datasheets at 25 °C nominal.
> Verify with bench measurements (spectrum analyser + noise source) during hardware bring-up.