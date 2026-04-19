# RF Gain-Loss Budget
## gvng

**Generated:** 2026-04-19  
**Document Status:** AI-GENERATED — verify against final component datasheets

## 1. System Parameters

| Parameter | Value | Unit |
|-----------|-------|------|
| Centre Frequency    | 4000   | MHz  |
| RF Bandwidth        | 100     | MHz  |
| Input Signal Level  | -92   | dBm  |
| Target Output Power | 0  | dBm  |
| Required System Gain | 92 | dB   |

## 2. Stage-by-Stage Gain / Loss Budget

| # | Stage | Component | Gain/Loss (dB) | Cum. Gain (dB) | Output Power (dBm) | NF (dB) | Cum. NF (dB) | P1dB Out (dBm) | OIP3 (dBm) | Notes |
|---|-------|-----------|---------------|----------------|-------------------|---------|-------------|---------------|-----------|-------|
| 1 | Input Matching Network | LC Network | -0.2 | -0.2 | -92.2 | 0.20 | 0.20 | N/A | N/A | 50Ω matching |
| 2 | 8:1 RF Switch | PE8135 | -0.5 | -0.7 | -92.7 | 0.50 | 0.70 | 29.5 | 29.5 | Channel switching |
| 3 | GaN HEMT LNA | CGH40010F | +22.0 | 21.3 | 29.3 | 2.50 | 3.16 | 18.0 | 40.0 | Primary gain stage |
| 4 | Ceramic Pre-select Filter | BPFB-0600-5100+ | -0.3 | 21.0 | 29.0 | 0.30 | 3.43 | 18.0 | 39.7 | Band selection |
| 5 | RF Limiter | MADL-011019 | -0.5 | 20.5 | 28.5 | 0.50 | 3.89 | 17.5 | 39.2 | Protection |

## 3. Budget Summary

| Metric | Value | Unit |
|--------|-------|------|
| Total System Gain     | 20.5  | dB  |
| Final Output Power    | 28.5  | dBm |
| Cascaded System NF    | 3.89 | dB  |
| Output Power Margin   | +71.5 | dB  |

## 4. Return Loss — Per Stage

| # | Stage | Component | S11 — Input RL (dB) | S22 — Output RL (dB) | Notes |
|---|-------|-----------|---------------------|----------------------|-------|
| 1 | Input Matching Network | LC Network | 20.0 | — | 50Ω matching |

> Return loss values are referenced to 50 Ω. Higher value = better match.

## 5. Cascade Noise Figure — Friis Formula

$$F_{{sys}} = F_1 + \frac{{F_2 - 1}}{{G_1}} + \frac{{F_3 - 1}}{{G_1 G_2}} + \cdots$$

Where *F* = linear noise factor (not dB), *G* = linear gain.
The first stage NF dominates — minimise LNA/driver NF for best system sensitivity.

---
> **Note:** All values are estimated from component datasheets at 25 °C nominal.
> Verify with bench measurements (spectrum analyser + noise source) during hardware bring-up.