# RF Gain-Loss Budget
## rbhjdaz

**Generated:** 2026-04-14  
**Document Status:** AI-GENERATED — verify against final component datasheets

## 1. System Parameters

| Parameter | Value | Unit |
|-----------|-------|------|
| Centre Frequency    | 11500   | MHz  |
| RF Bandwidth        | 2000     | MHz  |
| Input Signal Level  | -30   | dBm  |
| Target Output Power | 0  | dBm  |
| Required System Gain | 30 | dB   |

## 2. Stage-by-Stage Gain / Loss Budget

| # | Stage | Component | Gain/Loss (dB) | Cum. Gain (dB) | Output Power (dBm) | NF (dB) | Cum. NF (dB) | P1dB Out (dBm) | OIP3 (dBm) | Notes |
|---|-------|-----------|---------------|----------------|-------------------|---------|-------------|---------------|-----------|-------|
| 1 | Input Matching | SMA to microstrip transition | -0.2 | -0.2 | -30.2 | 0.20 | 0.20 | N/A | N/A | Connector loss |
| 2 | Limiter Protection | RFLM5012-10 (cascaded for 18GHz) | -1.5 | -1.7 | -31.7 | 1.50 | 1.70 | N/A | N/A | Protection limiter |
| 3 | LNA Front-end | TGA4537-SM | +20.0 | 18.3 | -11.7 | 2.50 | 2.77 | 22.0 | N/A | Primary NF contributor |
| 4 | VGA 1 (Rx gain) | HMC698LP4 (set to +15 dB) | +15.0 | 33.3 | 3.3 | 6.00 | 2.85 | 20.0 | N/A | SPI-controlled gain |
| 5 | Band Filter Bank | Mini-Circuits BP+ (switchable) | -2.5 | 30.8 | 0.8 | 2.50 | 2.98 | N/A | N/A | Image rejection & band selection |
| 6 | Downconversion Mixer | ADL5802 | +7.5 | 38.3 | 8.3 | 13.50 | 3.43 | 15.0 | 28.5 | RF to IF conversion |
| 7 | IF Amplifier | MAR-6+ | +18.0 | 56.3 | 26.3 | 3.50 | 3.46 | 16.0 | N/A | IF gain stage |
| 8 | VGA 2 (IF gain) | HMC698LP4 (set to -6 dB) | -6.0 | 50.3 | 20.3 | 6.00 | 3.46 | 20.0 | N/A | Adjust to ADC full scale |
| 9 | Anti-alias Filter | IF BPF 500M-2G | -2.0 | 48.3 | 18.3 | 2.00 | 3.47 | N/A | N/A | Bandlimiting before ADC |
| 10 | ADC Front-end | ADC12DJ3200 input buffer | +0.0 | 48.3 | 18.3 | 0.00 | 3.47 | 4.0 | N/A | Full-scale: +4 dBm |

## 3. Budget Summary

| Metric | Value | Unit |
|--------|-------|------|
| Total System Gain     | 48.3  | dB  |
| Final Output Power    | 18.3  | dBm |
| Cascaded System NF    | 3.47 | dB  |
| Output Power Margin   | -18.3 | dB  |

## 4. Cascade Noise Figure — Friis Formula

$$F_{sys} = F_1 + \frac{F_2 - 1}{G_1} + \frac{F_3 - 1}{G_1 G_2} + \cdots$$

Where *F* = linear noise factor (not dB), *G* = linear gain.
The first stage NF dominates — minimise LNA/driver NF for best system sensitivity.

---
> **Note:** All values are estimated from component datasheets at 25 °C nominal.
> Verify with bench measurements (spectrum analyser + noise source) during hardware bring-up.