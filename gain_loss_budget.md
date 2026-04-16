# RF Gain-Loss Budget
## rx receiver

**Generated:** 2026-04-16  
**Document Status:** AI-GENERATED — verify against final component datasheets

## 1. System Parameters

| Parameter | Value | Unit |
|-----------|-------|------|
| Centre Frequency    | 11500   | MHz  |
| RF Bandwidth        | 2000     | MHz  |
| Input Signal Level  | -50   | dBm  |
| Target Output Power | -10  | dBm  |
| Required System Gain | 40 | dB   |

## 2. Stage-by-Stage Gain / Loss Budget

| # | Stage | Component | Gain/Loss (dB) | Cum. Gain (dB) | Output Power (dBm) | NF (dB) | Cum. NF (dB) | P1dB Out (dBm) | OIP3 (dBm) | Notes |
|---|-------|-----------|---------------|----------------|-------------------|---------|-------------|---------------|-----------|-------|
| 1 | RF Input Connector | SMA Edge Launch Connector | -0.2 | -0.2 | -50.2 | 0.20 | 0.20 | N/A | N/A | Connector loss |
| 2 | Wideband LNA (Lower Band) | HMC6180LP4E | +20.0 | 19.8 | -30.2 | 2.50 | 2.54 | -35.2 | -25.2 | Primary gain stage, sets system NF |
| 3 | Bandpass Filter 5-18 GHz | CBP-1800-S+ | -2.5 | 17.3 | -32.7 | 2.50 | 2.60 | N/A | N/A | Image and spurious rejection |
| 4 | IQ Mixer Lower (5-12 GHz) | HMC519LC4 | +10.0 | 27.3 | -22.7 | 7.50 | 3.28 | -22.7 | -12.7 | Downconversion with gain |
| 5 | IF Amplifier | HMC698LP4 (VGA) | +15.0 | 42.3 | -7.7 | 6.00 | 3.43 | -7.7 | 12.3 | Variable gain control, mid-range setting |
| 6 | LPF Anti-Aliasing | LPF-2000-S+ | -1.5 | 40.8 | -9.2 | 1.50 | 3.44 | N/A | N/A | Anti-aliasing filter for ADC |
| 7 | ADC Input | ADC12DJ3200 | +0.0 | 40.8 | -9.2 | 0.00 | 3.44 | N/A | N/A | ADC full scale typically -1 dBFS = -1 dBm |

## 3. Budget Summary

| Metric | Value | Unit |
|--------|-------|------|
| Total System Gain     | 40.8  | dB  |
| Final Output Power    | -9.2  | dBm |
| Cascaded System NF    | 3.44 | dB  |
| Output Power Margin   | -0.8 | dB  |

## 4. Return Loss — Per Stage

| # | Stage | Component | S11 — Input RL (dB) | S22 — Output RL (dB) | Notes |
|---|-------|-----------|---------------------|----------------------|-------|
| 1 | RF Input Connector | SMA Edge Launch Connector | 25.0 | 25.0 | Connector loss |
| 2 | Wideband LNA (Lower Band) | HMC6180LP4E | 12.0 | 12.0 | Primary gain stage, sets system NF |
| 3 | Bandpass Filter 5-18 GHz | CBP-1800-S+ | 10.0 | 10.0 | Image and spurious rejection |
| 4 | IQ Mixer Lower (5-12 GHz) | HMC519LC4 | 15.0 | 15.0 | Downconversion with gain |
| 5 | IF Amplifier | HMC698LP4 (VGA) | 10.0 | 10.0 | Variable gain control, mid-range setting |
| 6 | LPF Anti-Aliasing | LPF-2000-S+ | 10.0 | 10.0 | Anti-aliasing filter for ADC |
| 7 | ADC Input | ADC12DJ3200 | 15.0 | 15.0 | ADC full scale typically -1 dBFS = -1 dBm |

> Return loss values are referenced to 50 Ω. Higher value = better match.

## 5. Cascade Noise Figure — Friis Formula

$$F_{{sys}} = F_1 + \frac{{F_2 - 1}}{{G_1}} + \frac{{F_3 - 1}}{{G_1 G_2}} + \cdots$$

Where *F* = linear noise factor (not dB), *G* = linear gain.
The first stage NF dominates — minimise LNA/driver NF for best system sensitivity.

---
> **Note:** All values are estimated from component datasheets at 25 °C nominal.
> Verify with bench measurements (spectrum analyser + noise source) during hardware bring-up.