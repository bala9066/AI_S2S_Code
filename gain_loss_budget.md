# RF Gain-Loss Budget
## rf txrxxp

**Generated:** 2026-04-14  
**Document Status:** AI-GENERATED — verify against final component datasheets

## 1. System Parameters

| Parameter | Value | Unit |
|-----------|-------|------|
| Centre Frequency    | 11500   | MHz  |
| RF Bandwidth        | 13000     | MHz  |
| Input Signal Level  | -60   | dBm  |
| Target Output Power | -10  | dBm  |
| Required System Gain | 50 | dB   |

## 2. Stage-by-Stage Gain / Loss Budget

| # | Stage | Component | Gain/Loss (dB) | Cum. Gain (dB) | Output Power (dBm) | NF (dB) | Cum. NF (dB) | P1dB Out (dBm) | OIP3 (dBm) | Notes |
|---|-------|-----------|---------------|----------------|-------------------|---------|-------------|---------------|-----------|-------|
| 1 | Input Matching/Limiter | GVA-123+ limiter | -0.5 | -0.5 | -60.5 | 0.50 | 0.50 | N/A | N/A | Input protection, minimal loss |
| 2 | Wideband LNA | TQP3M9036 MMIC | +20.0 | 19.5 | -40.5 | 2.50 | 2.53 | 19.0 | 29.0 | Primary gain stage, sets NF |
| 3 | Variable Gain Amp | HMC698LP4 VGA | +0.0 | 19.5 | -40.5 | 6.00 | 2.53 | 15.0 | 27.0 | 0dB nominal (0-30dB range for AGC) |
| 4 | Downconversion Mixer | HMC1050 mixer | -7.5 | 12.0 | -48.0 | 7.50 | 2.74 | N/A | 24.0 | 7.5dB conversion loss, IIP3 = 16.5dBm |
| 5 | IF Amplifier | ADL8000 VGA | +18.0 | 30.0 | -30.0 | 3.50 | 3.29 | N/A | 35.0 | IF gain stage (6dB headroom for ADC) |
| 6 | IF Filter / Match | Bandpass filter (DC-1GHz) | -2.0 | 28.0 | -32.0 | 2.00 | 3.30 | N/A | N/A | Anti-alias filtering |
| 7 | ADC Input | ADC12DJ3200 input | +0.0 | 28.0 | -32.0 | 30.00 | 4.84 | N/A | N/A | Full-scale drive -1dBFS |

## 3. Budget Summary

| Metric | Value | Unit |
|--------|-------|------|
| Total System Gain     | 28.0  | dB  |
| Final Output Power    | -32.0  | dBm |
| Cascaded System NF    | 4.84 | dB  |
| Output Power Margin   | +22 | dB  |

## 4. Cascade Noise Figure — Friis Formula

$$F_{sys} = F_1 + \frac{F_2 - 1}{G_1} + \frac{F_3 - 1}{G_1 G_2} + \cdots$$

Where *F* = linear noise factor (not dB), *G* = linear gain.
The first stage NF dominates — minimise LNA/driver NF for best system sensitivity.

---
> **Note:** All values are estimated from component datasheets at 25 °C nominal.
> Verify with bench measurements (spectrum analyser + noise source) during hardware bring-up.