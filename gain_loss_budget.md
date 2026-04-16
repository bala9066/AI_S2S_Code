# RF Gain-Loss Budget
## hjgjf

**Generated:** 2026-04-16  
**Document Status:** AI-GENERATED — verify against final component datasheets

## 1. System Parameters

| Parameter | Value | Unit |
|-----------|-------|------|
| Centre Frequency    | 11500   | MHz  |
| RF Bandwidth        | 13000     | MHz  |
| Input Signal Level  | -100   | dBm  |
| Target Output Power | -10  | dBm  |
| Required System Gain | 90 | dB   |

## 2. Stage-by-Stage Gain / Loss Budget

| # | Stage | Component | Gain/Loss (dB) | Cum. Gain (dB) | Output Power (dBm) | NF (dB) | Cum. NF (dB) | P1dB Out (dBm) | OIP3 (dBm) | Notes |
|---|-------|-----------|---------------|----------------|-------------------|---------|-------------|---------------|-----------|-------|
| 1 | RF Input Connector | 2.4mm female connector | -0.2 | -0.2 | -100.2 | 0.20 | 0.20 | N/A | N/A | Connector loss, VSWR < 1.5:1 |
| 2 | DC Blocking Capacitor | 20pF C0G capacitor | -0.1 | -0.3 | -100.3 | 0.10 | 0.30 | N/A | N/A | Minimal loss, high Q capacitor |
| 3 | RF Limiter Protection | MACOM MA4L-series limiter | -0.5 | -0.8 | -100.8 | 0.50 | 0.80 | 20.0 | N/A | Threshold +10dBm, protects LNA |
| 4 | Bandpass Filter | Mini-Circuits BP5-18G | -2.5 | -3.3 | -103.3 | 2.50 | 3.42 | N/A | N/A | Optional filter for out-of-band rejection |
| 5 | Wideband LNA | ADI HMC1099LP5E | +22.0 | 18.7 | -81.3 | 2.80 | 3.67 | -6.0 | 20.0 | Main gain stage, sets system NF |
| 6 | Output Matching Network | Microstrip matching network | -1.5 | 17.2 | -82.8 | 1.50 | 3.75 | N/A | N/A | Matches LNA output to 50 ohm ADC input |
| 7 | RF ADC | e2v EV10AQ190A | +0.0 | 17.2 | -82.8 | 25.00 | 5.85 | 0.0 | 40.0 | Digitizes 17.2dB gain signal, ADC NF dominates total |

## 3. Budget Summary

| Metric | Value | Unit |
|--------|-------|------|
| Total System Gain     | 17.2  | dB  |
| Final Output Power    | -82.8  | dBm |
| Cascaded System NF    | 5.85 | dB  |
| Output Power Margin   | +72.8 | dB  |

## 4. Return Loss — Per Stage

| # | Stage | Component | S11 — Input RL (dB) | S22 — Output RL (dB) | Notes |
|---|-------|-----------|---------------------|----------------------|-------|
| 1 | RF Input Connector | 2.4mm female connector | 20.0 | 20.0 | Connector loss, VSWR < 1.5:1 |
| 2 | DC Blocking Capacitor | 20pF C0G capacitor | 25.0 | 25.0 | Minimal loss, high Q capacitor |
| 3 | RF Limiter Protection | MACOM MA4L-series limiter | 15.0 | 15.0 | Threshold +10dBm, protects LNA |
| 4 | Bandpass Filter | Mini-Circuits BP5-18G | 10.0 | 10.0 | Optional filter for out-of-band rejection |
| 5 | Wideband LNA | ADI HMC1099LP5E | 12.0 | 12.0 | Main gain stage, sets system NF |
| 6 | Output Matching Network | Microstrip matching network | 10.0 | 20.0 | Matches LNA output to 50 ohm ADC input |
| 7 | RF ADC | e2v EV10AQ190A | 15.0 | 99.0 | Digitizes 17.2dB gain signal, ADC NF dominates total |

> Return loss values are referenced to 50 Ω. Higher value = better match.

## 5. Cascade Noise Figure — Friis Formula

$$F_{{sys}} = F_1 + \frac{{F_2 - 1}}{{G_1}} + \frac{{F_3 - 1}}{{G_1 G_2}} + \cdots$$

Where *F* = linear noise factor (not dB), *G* = linear gain.
The first stage NF dominates — minimise LNA/driver NF for best system sensitivity.

---
> **Note:** All values are estimated from component datasheets at 25 °C nominal.
> Verify with bench measurements (spectrum analyser + noise source) during hardware bring-up.