# RF Gain-Loss Budget
## Receiver Module

**Generated:** 2026-04-17  
**Document Status:** AI-GENERATED — verify against final component datasheets

## 1. System Parameters

| Parameter | Value | Unit |
|-----------|-------|------|
| Centre Frequency    | 11500   | MHz  |
| RF Bandwidth        | 13000     | MHz  |
| Input Signal Level  | -45   | dBm  |
| Target Output Power | 0  | dBm  |
| Required System Gain | 45 | dB   |

## 2. Stage-by-Stage Gain / Loss Budget

| # | Stage | Component | Gain/Loss (dB) | Cum. Gain (dB) | Output Power (dBm) | NF (dB) | Cum. NF (dB) | P1dB Out (dBm) | OIP3 (dBm) | Notes |
|---|-------|-----------|---------------|----------------|-------------------|---------|-------------|---------------|-----------|-------|
| 1 | Input Matching Network | 50-ohm microstrip + DC block | -0.5 | -0.5 | -45.5 | 0.50 | 0.50 | N/A | N/A | DC block (AVX 100pF) + input matching loss |
| 2 | Wideband LNA | HMC6180LP4E | +20.0 | 19.5 | -25.5 | 2.00 | 2.06 | 18.0 | 28.0 | Primary gain stage, sets noise figure |
| 3 | Variable Gain Amplifier | HMC698LP4 (set to max gain) | +15.5 | 35.0 | -10.0 | 5.00 | 2.34 | 15.0 | 30.0 | Gain control range 31.5 dB (0.5 dB steps), set to +15.5 dB for nominal operation |
| 4 | Bandpass Filter Bank | Mini-Circuits VLF-2200+ (example) | -3.0 | 32.0 | -13.0 | 3.00 | 2.58 | N/A | N/A | Image rejection and out-of-band filtering |
| 5 | Mixer (Downconversion) | HMC556LC4 | -9.0 | 23.0 | -22.0 | 9.00 | 2.85 | 5.0 | 15.0 | Conversion loss 9 dB, LO +7 dBm required |
| 6 | IF Amplifier | MAR-6+ (example IF amp) | +20.0 | 43.0 | -2.0 | 3.00 | 2.91 | 12.0 | 22.0 | IF gain stage to achieve 0 dBm output |
| 7 | IF Filter | IF bandpass filter | -2.0 | 41.0 | -4.0 | 2.00 | 2.92 | N/A | N/A | Final IF filtering |

## 3. Budget Summary

| Metric | Value | Unit |
|--------|-------|------|
| Total System Gain     | 41.0  | dB  |
| Final Output Power    | -4.0  | dBm |
| Cascaded System NF    | 2.92 | dB  |
| Output Power Margin   | +4 | dB  |

## 4. Return Loss — Per Stage

| # | Stage | Component | S11 — Input RL (dB) | S22 — Output RL (dB) | Notes |
|---|-------|-----------|---------------------|----------------------|-------|
| 1 | Wideband LNA | HMC6180LP4E | 15.0 | 10.0 | Primary gain stage, sets noise figure |

> Return loss values are referenced to 50 Ω. Higher value = better match.

## 5. Cascade Noise Figure — Friis Formula

$$F_{{sys}} = F_1 + \frac{{F_2 - 1}}{{G_1}} + \frac{{F_3 - 1}}{{G_1 G_2}} + \cdots$$

Where *F* = linear noise factor (not dB), *G* = linear gain.
The first stage NF dominates — minimise LNA/driver NF for best system sensitivity.

---
> **Note:** All values are estimated from component datasheets at 25 °C nominal.
> Verify with bench measurements (spectrum analyser + noise source) during hardware bring-up.