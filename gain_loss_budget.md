# RF Gain-Loss Budget
## hh

**Generated:** 2026-04-19  
**Document Status:** AI-GENERATED — verify against final component datasheets

## 1. System Parameters

| Parameter | Value | Unit |
|-----------|-------|------|
| Centre Frequency    | 4000   | MHz  |
| RF Bandwidth        | 100     | MHz  |
| Input Signal Level  | -94   | dBm  |
| Target Output Power | -64  | dBm  |
| Required System Gain | 30 | dB   |

## 2. Stage-by-Stage Gain / Loss Budget

| # | Stage | Component | Gain/Loss (dB) | Cum. Gain (dB) | Output Power (dBm) | NF (dB) | Cum. NF (dB) | P1dB Out (dBm) | OIP3 (dBm) | Notes |
|---|-------|-----------|---------------|----------------|-------------------|---------|-------------|---------------|-----------|-------|
| 1 | SMA Connector | SMA | +0.0 | 0.0 | -94.0 | 0.00 | 0.00 | N/A | N/A | Ideal connector |
| 2 | Limiter | MADL-011017 | -0.8 | -0.8 | -94.8 | 0.80 | 0.80 | N/A | N/A | +30 dBm survivable |
| 3 | Preselector BPF | SAW-2400-6000 | -2.5 | -3.3 | -97.3 | 2.50 | 3.26 | N/A | N/A | 2-6 GHz SAW filter |
| 4 | Bias-T | BTL-1-6-G-S+ | -0.3 | -3.6 | -97.6 | 0.30 | 3.51 | N/A | N/A | DC bias injection |
| 5 | LNA | HMC8411 | +25.0 | 21.4 | -72.6 | 1.20 | 1.71 | 5.0 | 25.0 | GaAs pHEMT 25dB gain |
| 6 | 1:4 Power Splitter | PSA4-5043+ | -6.5 | 14.9 | -79.1 | 6.50 | 3.18 | -1.5 | 18.5 | 4-way splitter |
| 7 | Channel Filter BPF | BLF-254+ | -1.5 | 13.4 | -80.6 | 1.50 | 3.33 | -3.0 | 17.0 | 100 MHz channel filter |

## 3. Budget Summary

| Metric | Value | Unit |
|--------|-------|------|
| Total System Gain     | 13.4  | dB  |
| Final Output Power    | -80.6  | dBm |
| Cascaded System NF    | 3.33 | dB  |
| Output Power Margin   | +16.6 | dB  |

## 4. Return Loss — Per Stage

| # | Stage | Component | S11 — Input RL (dB) | S22 — Output RL (dB) | Notes |
|---|-------|-----------|---------------------|----------------------|-------|
| 1 | SMA Connector | SMA | 20.0 | — | Ideal connector |
| 2 | Limiter | MADL-011017 | 15.0 | — | +30 dBm survivable |
| 3 | Preselector BPF | SAW-2400-6000 | 18.0 | — | 2-6 GHz SAW filter |
| 4 | Bias-T | BTL-1-6-G-S+ | 20.0 | — | DC bias injection |
| 5 | LNA | HMC8411 | 12.0 | — | GaAs pHEMT 25dB gain |
| 6 | 1:4 Power Splitter | PSA4-5043+ | 15.0 | — | 4-way splitter |
| 7 | Channel Filter BPF | BLF-254+ | 20.0 | — | 100 MHz channel filter |

> Return loss values are referenced to 50 Ω. Higher value = better match.

## 5. Cascade Noise Figure — Friis Formula

$$F_{{sys}} = F_1 + \frac{{F_2 - 1}}{{G_1}} + \frac{{F_3 - 1}}{{G_1 G_2}} + \cdots$$

Where *F* = linear noise factor (not dB), *G* = linear gain.
The first stage NF dominates — minimise LNA/driver NF for best system sensitivity.

---
> **Note:** All values are estimated from component datasheets at 25 °C nominal.
> Verify with bench measurements (spectrum analyser + noise source) during hardware bring-up.