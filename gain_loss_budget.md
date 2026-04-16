# RF Gain-Loss Budget
## sample

**Generated:** 2026-04-16  
**Document Status:** AI-GENERATED — verify against final component datasheets

## 1. System Parameters

| Parameter | Value | Unit |
|-----------|-------|------|
| Centre Frequency    | 11500   | MHz  |
| RF Bandwidth        | 13000     | MHz  |
| Input Signal Level  | -40   | dBm  |
| Target Output Power | -10  | dBm  |
| Required System Gain | 30 | dB   |

## 2. Stage-by-Stage Gain / Loss Budget

| # | Stage | Component | Gain/Loss (dB) | Cum. Gain (dB) | Output Power (dBm) | NF (dB) | Cum. NF (dB) | P1dB Out (dBm) | OIP3 (dBm) | Notes |
|---|-------|-----------|---------------|----------------|-------------------|---------|-------------|---------------|-----------|-------|
| 1 | Input Band Switch | HMC1118 | -1.2 | -1.2 | -41.2 | 1.20 | 1.20 | N/A | N/A | Insertion loss at mid-band, contributes to NF |
| 2 | Wideband LNA | HMC1134 | +19.0 | 17.8 | -22.2 | 2.50 | 2.63 | 20.0 | 32.0 | Dominant NF contributor per Friis |
| 3 | Mixer Downconverter | HMC559 | -7.0 | 10.8 | -29.2 | 7.00 | 3.13 | 16.0 | 25.0 | Conversion loss, NF = loss value |
| 4 | IF Amplifier | ADL5541 | +20.0 | 30.8 | -9.2 | 5.50 | 3.41 | 18.5 | 32.0 | Provides IF gain |
| 5 | VGA / Attenuator | AD8376 | +0.0 | 30.8 | -9.2 | 11.00 | 3.45 | 14.0 | N/A | Set to 0 dB nominal, adjustable -31.5 to +0 dB |
| 6 | ADC Input | AD9208 | +0.0 | 30.8 | -9.2 | 30.00 | 3.46 | 4.0 | N/A | ADC full-scale optimized, NF not critical |

## 3. Budget Summary

| Metric | Value | Unit |
|--------|-------|------|
| Total System Gain     | 30.8  | dB  |
| Final Output Power    | -9.2  | dBm |
| Cascaded System NF    | 3.46 | dB  |
| Output Power Margin   | -0.8 | dB  |

## 4. Return Loss — Per Stage

| # | Stage | Component | S11 — Input RL (dB) | S22 — Output RL (dB) | Notes |
|---|-------|-----------|---------------------|----------------------|-------|
| 1 | Input Band Switch | HMC1118 | 15.0 | 15.0 | Insertion loss at mid-band, contributes to NF |
| 2 | Wideband LNA | HMC1134 | 12.0 | 12.0 | Dominant NF contributor per Friis |
| 3 | Mixer Downconverter | HMC559 | 10.0 | 10.0 | Conversion loss, NF = loss value |
| 4 | IF Amplifier | ADL5541 | 15.0 | 15.0 | Provides IF gain |
| 5 | VGA / Attenuator | AD8376 | 20.0 | 20.0 | Set to 0 dB nominal, adjustable -31.5 to +0 dB |
| 6 | ADC Input | AD9208 | 15.0 | 15.0 | ADC full-scale optimized, NF not critical |

> Return loss values are referenced to 50 Ω. Higher value = better match.

## 5. Cascade Noise Figure — Friis Formula

$$F_{{sys}} = F_1 + \frac{{F_2 - 1}}{{G_1}} + \frac{{F_3 - 1}}{{G_1 G_2}} + \cdots$$

Where *F* = linear noise factor (not dB), *G* = linear gain.
The first stage NF dominates — minimise LNA/driver NF for best system sensitivity.

---
> **Note:** All values are estimated from component datasheets at 25 °C nominal.
> Verify with bench measurements (spectrum analyser + noise source) during hardware bring-up.