# RF Gain-Loss Budget
## mnb

**Generated:** 2026-04-16  
**Document Status:** AI-GENERATED — verify against final component datasheets

## 1. System Parameters

| Parameter | Value | Unit |
|-----------|-------|------|
| Centre Frequency    | 11500   | MHz  |
| RF Bandwidth        | 750     | MHz  |
| Input Signal Level  | -30   | dBm  |
| Target Output Power | -10  | dBm  |
| Required System Gain | 20 | dB   |

## 2. Stage-by-Stage Gain / Loss Budget

| # | Stage | Component | Gain/Loss (dB) | Cum. Gain (dB) | Output Power (dBm) | NF (dB) | Cum. NF (dB) | P1dB Out (dBm) | OIP3 (dBm) | Notes |
|---|-------|-----------|---------------|----------------|-------------------|---------|-------------|---------------|-----------|-------|
| 1 | RF Input Connector | SMA 142-0771-821 | -0.2 | -0.2 | -30.2 | 0.20 | — | N/A | N/A | Connector loss |
| 2 | LNA Front-End | HMC698LP4(E) | +15.5 | 15.3 | -14.7 | 3.00 | — | -10.0 | 30.0 | Primary gain stage, dominates NF |
| 3 | Bandpass Filter | 5-18 GHz BPF | -2.0 | 13.3 | -16.7 | 2.00 | — | N/A | N/A | Image rejection filter |
| 4 | Variable Gain Amp | HMC698LP4 VGA | +20.0 | 33.3 | 3.3 | 7.00 | — | 15.0 | 25.0 | AGC range 0-30 dB, set to 20 dB |
| 5 | Mixer Downconverter | HMC1061LP4(E) | -7.5 | 25.8 | -4.2 | 7.50 | — | 5.0 | 15.0 | Conversion loss, LO feedthrough -60 dBm |
| 6 | IF Amplifier | IF Gain Stage | +15.0 | 40.8 | 10.8 | 4.00 | — | 18.0 | 28.0 | Post-mixer gain for ADC drive |
| 7 | IF Filter | IF BPF 500 MHz | -3.0 | 37.8 | 7.8 | 3.00 | — | N/A | N/A | Anti-aliasing filter |
| 8 | ADC Input | ADC12DJ3200 | +0.0 | 37.8 | 7.8 | 0.00 | — | 4.0 | N/A | Full scale approx 1.5Vpp (7.8 dBm) |

## 3. Budget Summary

| Metric | Value | Unit |
|--------|-------|------|
| Total System Gain     | 37.8  | dB  |
| Final Output Power    | 7.8  | dBm |
| Output Power Margin   | -17.8 | dB  |

## 4. Return Loss — Per Stage

| # | Stage | Component | S11 — Input RL (dB) | S22 — Output RL (dB) | Notes |
|---|-------|-----------|---------------------|----------------------|-------|
| 1 | RF Input Connector | SMA 142-0771-821 | 20.0 | 20.0 | Connector loss |
| 2 | LNA Front-End | HMC698LP4(E) | 15.0 | 12.0 | Primary gain stage, dominates NF |
| 3 | Mixer Downconverter | HMC1061LP4(E) | 10.0 | 10.0 | Conversion loss, LO feedthrough -60 dBm |
| 4 | ADC Input | ADC12DJ3200 | 15.0 | — | Full scale approx 1.5Vpp (7.8 dBm) |

> Return loss values are referenced to 50 Ω. Higher value = better match.

## 5. Cascade Noise Figure — Friis Formula

$$F_{{sys}} = F_1 + \frac{{F_2 - 1}}{{G_1}} + \frac{{F_3 - 1}}{{G_1 G_2}} + \cdots$$

Where *F* = linear noise factor (not dB), *G* = linear gain.
The first stage NF dominates — minimise LNA/driver NF for best system sensitivity.

---
> **Note:** All values are estimated from component datasheets at 25 °C nominal.
> Verify with bench measurements (spectrum analyser + noise source) during hardware bring-up.