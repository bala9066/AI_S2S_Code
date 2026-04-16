# RF Gain-Loss Budget
## dghb

**Generated:** 2026-04-16  
**Document Status:** AI-GENERATED — verify against final component datasheets

## 1. System Parameters

| Parameter | Value | Unit |
|-----------|-------|------|
| Centre Frequency    | 11500   | MHz  |
| RF Bandwidth        | 13000     | MHz  |
| Input Signal Level  | -50   | dBm  |
| Target Output Power | 0  | dBm  |
| Required System Gain | 50 | dB   |

## 2. Stage-by-Stage Gain / Loss Budget

| # | Stage | Component | Gain/Loss (dB) | Cum. Gain (dB) | Output Power (dBm) | NF (dB) | Cum. NF (dB) | P1dB Out (dBm) | OIP3 (dBm) | Notes |
|---|-------|-----------|---------------|----------------|-------------------|---------|-------------|---------------|-----------|-------|
| 1 | Input Protection | LM5000 limiter | -0.5 | -0.5 | -50.5 | 0.50 | 0.50 | 12.0 | 30.0 | ESD/power limiter, minimal loss |
| 2 | Bandpass Filter | BP5G18G-25M01-C5F | -2.5 | -3.0 | -53.0 | 2.50 | 3.28 | N/A | N/A | Band limiting to 5-18 GHz, rejects out-of-band |
| 3 | Wideband LNA | GVA-123+ | +23.5 | 20.5 | -29.5 | 3.50 | 3.63 | 19.0 | 30.0 | Primary gain stage, sets system NF |
| 4 | Variable Gain Amp | HMC698LP4 at nominal gain | +6.0 | 26.5 | -23.5 | 6.00 | 3.81 | 19.0 | 28.0 | Gain adjustable -10 to +22 dB via SPI |
| 5 | ADC Input | ADC12DJ5200RF input network | -3.0 | 23.5 | -26.5 | 3.00 | 4.40 | 5.0 | 20.0 | Input matching/buffer loss, ADC requires -6 to +2 dBm FS |

## 3. Budget Summary

| Metric | Value | Unit |
|--------|-------|------|
| Total System Gain     | 23.5  | dB  |
| Final Output Power    | -26.5  | dBm |
| Cascaded System NF    | 4.40 | dB  |
| Output Power Margin   | +26.5 | dB  |

## 4. Return Loss — Per Stage

| # | Stage | Component | S11 — Input RL (dB) | S22 — Output RL (dB) | Notes |
|---|-------|-----------|---------------------|----------------------|-------|
| 1 | Input Protection | LM5000 limiter | 20.0 | 20.0 | ESD/power limiter, minimal loss |
| 2 | Bandpass Filter | BP5G18G-25M01-C5F | 15.0 | 15.0 | Band limiting to 5-18 GHz, rejects out-of-band |
| 3 | Wideband LNA | GVA-123+ | 12.0 | 12.0 | Primary gain stage, sets system NF |
| 4 | Variable Gain Amp | HMC698LP4 at nominal gain | 15.0 | 15.0 | Gain adjustable -10 to +22 dB via SPI |
| 5 | ADC Input | ADC12DJ5200RF input network | 10.0 | 10.0 | Input matching/buffer loss, ADC requires -6 to +2 dBm FS |

> Return loss values are referenced to 50 Ω. Higher value = better match.

## 5. Cascade Noise Figure — Friis Formula

$$F_{{sys}} = F_1 + \frac{{F_2 - 1}}{{G_1}} + \frac{{F_3 - 1}}{{G_1 G_2}} + \cdots$$

Where *F* = linear noise factor (not dB), *G* = linear gain.
The first stage NF dominates — minimise LNA/driver NF for best system sensitivity.

---
> **Note:** All values are estimated from component datasheets at 25 °C nominal.
> Verify with bench measurements (spectrum analyser + noise source) during hardware bring-up.