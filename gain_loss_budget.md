# RF Gain-Loss Budget
## dgh

**Generated:** 2026-04-19  
**Document Status:** AI-GENERATED — verify against final component datasheets

## 1. System Parameters

| Parameter | Value | Unit |
|-----------|-------|------|
| Centre Frequency    | 11500   | MHz  |
| RF Bandwidth        | 100     | MHz  |
| Input Signal Level  | -92   | dBm  |
| Target Output Power | 20  | dBm  |
| Required System Gain | 112 | dB   |

## 2. Stage-by-Stage Gain / Loss Budget

| # | Stage | Component | Gain/Loss (dB) | Cum. Gain (dB) | Output Power (dBm) | NF (dB) | Cum. NF (dB) | P1dB Out (dBm) | OIP3 (dBm) | Notes |
|---|-------|-----------|---------------|----------------|-------------------|---------|-------------|---------------|-----------|-------|
| 1 | Limiter | MACOM MADL-011017 | -0.5 | -0.5 | -92.5 | 0.50 | 0.50 | 30.0 | 40.0 | Survivability protection |
| 2 | SAW Filter | SAW-518-HP | -2.0 | -2.5 | -94.5 | 2.00 | 2.45 | 18.0 | 25.0 | Band selection |
| 3 | GaN LNA | QPL9057 | +20.0 | 17.5 | -74.5 | 2.50 | 4.90 | 15.0 | 25.0 | Main amplification |
| 4 | Driver Stage | ADL5545 | +15.0 | 32.5 | -59.5 | 3.00 | 7.10 | 15.0 | 20.0 | Additional gain |
| 5 | Output Buffer | MGA-68563 | +12.0 | 44.5 | -47.5 | 2.80 | 9.50 | 12.0 | 18.0 | Final stage |

## 3. Budget Summary

| Metric | Value | Unit |
|--------|-------|------|
| Total System Gain     | 44.5  | dB  |
| Final Output Power    | -47.5  | dBm |
| Cascaded System NF    | 9.50 | dB  |
| Output Power Margin   | +67.5 | dB  |

## 4. Return Loss — Per Stage

| # | Stage | Component | S11 — Input RL (dB) | S22 — Output RL (dB) | Notes |
|---|-------|-----------|---------------------|----------------------|-------|
| 1 | Limiter | MACOM MADL-011017 | 20.0 | 15.0 | Survivability protection |
| 2 | SAW Filter | SAW-518-HP | 15.0 | 12.0 | Band selection |
| 3 | GaN LNA | QPL9057 | 12.0 | 10.0 | Main amplification |
| 4 | Driver Stage | ADL5545 | 10.0 | 8.0 | Additional gain |
| 5 | Output Buffer | MGA-68563 | 8.0 | 6.0 | Final stage |

> Return loss values are referenced to 50 Ω. Higher value = better match.

## 5. Cascade Noise Figure — Friis Formula

$$F_{{sys}} = F_1 + \frac{{F_2 - 1}}{{G_1}} + \frac{{F_3 - 1}}{{G_1 G_2}} + \cdots$$

Where *F* = linear noise factor (not dB), *G* = linear gain.
The first stage NF dominates — minimise LNA/driver NF for best system sensitivity.

---
> **Note:** All values are estimated from component datasheets at 25 °C nominal.
> Verify with bench measurements (spectrum analyser + noise source) during hardware bring-up.