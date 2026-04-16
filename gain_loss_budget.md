# RF Gain-Loss Budget
## sample rf

**Generated:** 2026-04-16  
**Document Status:** AI-GENERATED — verify against final component datasheets

## 1. System Parameters

| Parameter | Value | Unit |
|-----------|-------|------|
| Centre Frequency    | 11500   | MHz  |
| RF Bandwidth        | 13000     | MHz  |
| Input Signal Level  | -55   | dBm  |
| Target Output Power | 12  | dBm  |
| Required System Gain | 67 | dB   |

## 2. Stage-by-Stage Gain / Loss Budget

| # | Stage | Component | Gain/Loss (dB) | Cum. Gain (dB) | Output Power (dBm) | NF (dB) | Cum. NF (dB) | P1dB Out (dBm) | OIP3 (dBm) | Notes |
|---|-------|-----------|---------------|----------------|-------------------|---------|-------------|---------------|-----------|-------|
| 1 | Input BPF | BP0650-18-10-S1 | -2.0 | -2.0 | -57.0 | 2.00 | 2.00 | N/A | N/A | Insertion loss 2 dB, good return loss |
| 2 | Wideband LNA Stage 1 | HMC698LP4 | +14.0 | 12.0 | -43.0 | 3.50 | 3.58 | 18.0 | 28.0 | Primary gain stage, low noise figure |
| 3 | Interstage BPF | BP0650-18-10-S1 | -2.0 | 10.0 | -45.0 | 2.00 | 3.86 | N/A | N/A | Image rejection and filtering |
| 4 | Wideband LNA Stage 2 | HMC698LP4 | +14.0 | 24.0 | -31.0 | 3.50 | 3.66 | 18.0 | 28.0 | Additional gain for sensitivity |
| 5 | Mixer/Downconverter | HMC1119LP4 | -8.0 | 16.0 | -39.0 | 8.00 | 4.68 | 15.0 | 25.0 | Frequency translation to IF/baseband |
| 6 | IF Amplifier | ADA4817-1 | +20.0 | 36.0 | -19.0 | 4.00 | 4.63 | 15.0 | 30.0 | Baseband amplification and drive |
| 7 | ADC Input | ADC12J4000 | -6.0 | 30.0 | -25.0 | 6.00 | 5.63 | 5.0 | 20.0 | ADC input attenuation and digitization |

## 3. Budget Summary

| Metric | Value | Unit |
|--------|-------|------|
| Total System Gain     | 30.0  | dB  |
| Final Output Power    | -25.0  | dBm |
| Cascaded System NF    | 5.63 | dB  |
| Output Power Margin   | +37 | dB  |

## 4. Return Loss — Per Stage

| # | Stage | Component | S11 — Input RL (dB) | S22 — Output RL (dB) | Notes |
|---|-------|-----------|---------------------|----------------------|-------|
| 1 | Input BPF | BP0650-18-10-S1 | 15.0 | 15.0 | Insertion loss 2 dB, good return loss |
| 2 | Wideband LNA Stage 1 | HMC698LP4 | 12.0 | 10.0 | Primary gain stage, low noise figure |
| 3 | Interstage BPF | BP0650-18-10-S1 | 15.0 | 15.0 | Image rejection and filtering |
| 4 | Wideband LNA Stage 2 | HMC698LP4 | 12.0 | 10.0 | Additional gain for sensitivity |
| 5 | Mixer/Downconverter | HMC1119LP4 | 10.0 | 10.0 | Frequency translation to IF/baseband |
| 6 | IF Amplifier | ADA4817-1 | 20.0 | 20.0 | Baseband amplification and drive |
| 7 | ADC Input | ADC12J4000 | 15.0 | 15.0 | ADC input attenuation and digitization |

> Return loss values are referenced to 50 Ω. Higher value = better match.

## 5. Cascade Noise Figure — Friis Formula

$$F_{{sys}} = F_1 + \frac{{F_2 - 1}}{{G_1}} + \frac{{F_3 - 1}}{{G_1 G_2}} + \cdots$$

Where *F* = linear noise factor (not dB), *G* = linear gain.
The first stage NF dominates — minimise LNA/driver NF for best system sensitivity.

---
> **Note:** All values are estimated from component datasheets at 25 °C nominal.
> Verify with bench measurements (spectrum analyser + noise source) during hardware bring-up.