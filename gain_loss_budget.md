# RF Gain-Loss Budget
## dsf

**Generated:** 2026-04-16  
**Document Status:** AI-GENERATED — verify against final component datasheets

## 1. System Parameters

| Parameter | Value | Unit |
|-----------|-------|------|
| Centre Frequency    | 11500   | MHz  |
| RF Bandwidth        | 3000     | MHz  |
| Input Signal Level  | -60   | dBm  |
| Target Output Power | 5  | dBm  |
| Required System Gain | 65 | dB   |

## 2. Stage-by-Stage Gain / Loss Budget

| # | Stage | Component | Gain/Loss (dB) | Cum. Gain (dB) | Output Power (dBm) | NF (dB) | Cum. NF (dB) | P1dB Out (dBm) | OIP3 (dBm) | Notes |
|---|-------|-----------|---------------|----------------|-------------------|---------|-------------|---------------|-----------|-------|
| 1 | Input Limiter/ESD | Limiter GVA-123+ | -0.5 | -0.5 | -60.5 | 0.50 | 0.50 | 40.0 | 55.0 | ESD protection, minimal insertion loss |
| 2 | Wideband LNA | HMC698LP4E | +22.0 | 21.5 | -38.5 | 3.50 | 3.54 | 18.0 | 30.0 | Low-noise front-end amplifier |
| 3 | Bandpass Filter | BPF-51800-3000 | -2.5 | 19.0 | -41.0 | 2.50 | 4.15 | N/A | N/A | 5-18 GHz bandpass, image rejection |
| 4 | Driver Amplifier | HMC1119 | +14.0 | 33.0 | -27.0 | 6.00 | 4.26 | 22.0 | 35.0 | Gain block to drive mixer |
| 5 | Mixer Downconverter | HMC1048 | -7.0 | 26.0 | -34.0 | 7.00 | 4.35 | 20.0 | 30.0 | Double-balanced mixer, IF output |
| 6 | IF Amplifier | ADA4817 | +18.0 | 44.0 | -16.0 | 4.00 | 4.37 | 15.0 | 28.0 | Wideband IF gain stage |
| 7 | IF Filter | LFCN-3000 | -1.5 | 42.5 | -17.5 | 1.50 | 4.38 | N/A | N/A | 3 GHz lowpass filter |
| 8 | Variable Gain Amplifier | HMC698LP2 | +20.0 | 62.5 | 2.5 | 6.00 | 4.39 | 12.0 | 25.0 |  digitally controlled VGA |

## 3. Budget Summary

| Metric | Value | Unit |
|--------|-------|------|
| Total System Gain     | 62.5  | dB  |
| Final Output Power    | 2.5  | dBm |
| Cascaded System NF    | 4.39 | dB  |
| Output Power Margin   | +2.5 | dB  |

## 4. Return Loss — Per Stage

| # | Stage | Component | S11 — Input RL (dB) | S22 — Output RL (dB) | Notes |
|---|-------|-----------|---------------------|----------------------|-------|
| 1 | Input Limiter/ESD | Limiter GVA-123+ | 20.0 | 20.0 | ESD protection, minimal insertion loss |
| 2 | Wideband LNA | HMC698LP4E | 12.0 | 15.0 | Low-noise front-end amplifier |
| 3 | Bandpass Filter | BPF-51800-3000 | 18.0 | 18.0 | 5-18 GHz bandpass, image rejection |
| 4 | Driver Amplifier | HMC1119 | 15.0 | 12.0 | Gain block to drive mixer |
| 5 | Mixer Downconverter | HMC1048 | 10.0 | 12.0 | Double-balanced mixer, IF output |
| 6 | IF Amplifier | ADA4817 | 15.0 | 10.0 | Wideband IF gain stage |
| 7 | IF Filter | LFCN-3000 | 15.0 | 15.0 | 3 GHz lowpass filter |
| 8 | Variable Gain Amplifier | HMC698LP2 | 12.0 | 12.0 |  digitally controlled VGA |

> Return loss values are referenced to 50 Ω. Higher value = better match.

## 5. Cascade Noise Figure — Friis Formula

$$F_{{sys}} = F_1 + \frac{{F_2 - 1}}{{G_1}} + \frac{{F_3 - 1}}{{G_1 G_2}} + \cdots$$

Where *F* = linear noise factor (not dB), *G* = linear gain.
The first stage NF dominates — minimise LNA/driver NF for best system sensitivity.

---
> **Note:** All values are estimated from component datasheets at 25 °C nominal.
> Verify with bench measurements (spectrum analyser + noise source) during hardware bring-up.