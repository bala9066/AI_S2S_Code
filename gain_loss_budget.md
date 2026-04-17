# RF Gain-Loss Budget
## Rf Receiver

**Generated:** 2026-04-17  
**Document Status:** AI-GENERATED — verify against final component datasheets

## 1. System Parameters

| Parameter | Value | Unit |
|-----------|-------|------|
| Centre Frequency    | 11500   | MHz  |
| RF Bandwidth        | 13000     | MHz  |
| Input Signal Level  | -40   | dBm  |
| Target Output Power | -5  | dBm  |
| Required System Gain | 35 | dB   |

## 2. Stage-by-Stage Gain / Loss Budget

| # | Stage | Component | Gain/Loss (dB) | Cum. Gain (dB) | Output Power (dBm) | NF (dB) | Cum. NF (dB) | P1dB Out (dBm) | OIP3 (dBm) | Notes |
|---|-------|-----------|---------------|----------------|-------------------|---------|-------------|---------------|-----------|-------|
| 1 | Input Matching Network | Microstrip matching network | -0.5 | -0.5 | -40.5 | 0.50 | 0.50 | N/A | N/A | Wideband 5-18 GHz match, Rogers 4350B substrate |
| 2 | Input Limiter | VLVA-300-44 | -0.5 | -1.0 | -41.0 | 0.50 | 1.00 | N/A | N/A | Protection to +10 dBm, fast recovery |
| 3 | Wideband LNA | AMMC-6241 | +20.0 | 19.0 | -21.0 | 3.00 | 1.10 | 15.0 | 25.0 | GaAs MMIC, 5-20 GHz, sets system NF |
| 4 | Interstage Matching | Microstrip transformer | -0.3 | 18.7 | -21.3 | 0.30 | 1.14 | N/A | N/A | Impedance transformation to driver amp |
| 5 | Driver Amplifier | GVA-164+ | +15.0 | 33.7 | -6.3 | 5.00 | 1.15 | 25.0 | 38.0 | High OIP3 for linearity, 6-18 GHz |
| 6 | Output Matching Network | 50 ohm microstrip line | -0.2 | 33.5 | -6.5 | 0.20 | 1.16 | N/A | N/A | Matches to SMA output connector |
| 7 | SMA Connector | Cinch 142-0701-851 | -0.3 | 33.2 | -6.8 | 0.30 | 1.18 | N/A | N/A | MIL-SPEC connector, rated to 18 GHz |

## 3. Budget Summary

| Metric | Value | Unit |
|--------|-------|------|
| Total System Gain     | 33.2  | dB  |
| Final Output Power    | -6.8  | dBm |
| Cascaded System NF    | 1.18 | dB  |
| Output Power Margin   | +1.8 | dB  |

## 4. Return Loss — Per Stage

| # | Stage | Component | S11 — Input RL (dB) | S22 — Output RL (dB) | Notes |
|---|-------|-----------|---------------------|----------------------|-------|
| 1 | Input Matching Network | Microstrip matching network | 15.0 | 15.0 | Wideband 5-18 GHz match, Rogers 4350B substrate |
| 2 | Input Limiter | VLVA-300-44 | 20.0 | 20.0 | Protection to +10 dBm, fast recovery |
| 3 | Wideband LNA | AMMC-6241 | 12.0 | 12.0 | GaAs MMIC, 5-20 GHz, sets system NF |
| 4 | Interstage Matching | Microstrip transformer | 15.0 | 15.0 | Impedance transformation to driver amp |
| 5 | Driver Amplifier | GVA-164+ | 10.0 | 10.0 | High OIP3 for linearity, 6-18 GHz |
| 6 | Output Matching Network | 50 ohm microstrip line | 20.0 | 20.0 | Matches to SMA output connector |
| 7 | SMA Connector | Cinch 142-0701-851 | 20.0 | 20.0 | MIL-SPEC connector, rated to 18 GHz |

> Return loss values are referenced to 50 Ω. Higher value = better match.

## 5. Cascade Noise Figure — Friis Formula

$$F_{{sys}} = F_1 + \frac{{F_2 - 1}}{{G_1}} + \frac{{F_3 - 1}}{{G_1 G_2}} + \cdots$$

Where *F* = linear noise factor (not dB), *G* = linear gain.
The first stage NF dominates — minimise LNA/driver NF for best system sensitivity.

---
> **Note:** All values are estimated from component datasheets at 25 °C nominal.
> Verify with bench measurements (spectrum analyser + noise source) during hardware bring-up.