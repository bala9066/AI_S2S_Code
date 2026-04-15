# RF Gain-Loss Budget
## kh

**Generated:** 2026-04-15  
**Document Status:** AI-GENERATED — verify against final component datasheets

## 1. System Parameters

| Parameter | Value | Unit |
|-----------|-------|------|
| Centre Frequency    | 12500   | MHz  |
| RF Bandwidth        | 5000     | MHz  |
| Input Signal Level  | -10   | dBm  |
| Target Output Power | -10  | dBm  |
| Required System Gain | 0 | dB   |

## 2. Stage-by-Stage Gain / Loss Budget

| # | Stage | Component | Gain/Loss (dB) | Cum. Gain (dB) | Output Power (dBm) | NF (dB) | Cum. NF (dB) | P1dB Out (dBm) | OIP3 (dBm) | Notes |
|---|-------|-----------|---------------|----------------|-------------------|---------|-------------|---------------|-----------|-------|
| 1 | Bandpass Filter | CBP-1250-C3 | -2.0 | -2.0 | -12.0 | 2.00 | 2.00 | N/A | N/A | Input BPF defines frequency band |
| 2 | LNA | HMC1119LP4DE | +20.0 | 18.0 | 8.0 | 3.00 | 3.06 | 20.0 | 32.0 | Primary gain stage, sets system NF |
| 3 | VGA | HMC698LP4 | +15.0 | 33.0 | 23.0 | 3.50 | 3.11 | 33.0 | N/A | Mid-band gain, AGC capability |
| 4 | Mixer | HMC1051LP4BE | -8.0 | 25.0 | 15.0 | 8.00 | 3.19 | 15.0 | 24.0 | Downconversion to IF, LO drive +10dBm |
| 5 | IF Amplifier | ADL5541 | +20.0 | 45.0 | 35.0 | 3.50 | 3.23 | 43.0 | 62.0 | Drive ADC to optimal level |
| 6 | Anti-alias Filter | LPF 500MHz | -2.0 | 43.0 | 33.0 | 2.00 | 3.25 | N/A | N/A | Limit bandwidth to ADC requirements |

## 3. Budget Summary

| Metric | Value | Unit |
|--------|-------|------|
| Total System Gain     | 43.0  | dB  |
| Final Output Power    | 33.0  | dBm |
| Cascaded System NF    | 3.25 | dB  |
| Output Power Margin   | -43 | dB  |

## 4. Return Loss — Per Stage

| # | Stage | Component | S11 — Input RL (dB) | S22 — Output RL (dB) | Notes |
|---|-------|-----------|---------------------|----------------------|-------|
| 1 | Bandpass Filter | CBP-1250-C3 | 15.0 | 15.0 | Input BPF defines frequency band |
| 2 | LNA | HMC1119LP4DE | 12.0 | 12.0 | Primary gain stage, sets system NF |
| 3 | VGA | HMC698LP4 | 10.0 | 10.0 | Mid-band gain, AGC capability |
| 4 | Mixer | HMC1051LP4BE | 12.0 | 12.0 | Downconversion to IF, LO drive +10dBm |
| 5 | IF Amplifier | ADL5541 | 15.0 | 15.0 | Drive ADC to optimal level |
| 6 | Anti-alias Filter | LPF 500MHz | 12.0 | 12.0 | Limit bandwidth to ADC requirements |

> Return loss values are referenced to 50 Ω. Higher value = better match.

## 5. Cascade Noise Figure — Friis Formula

$$F_{{sys}} = F_1 + \frac{{F_2 - 1}}{{G_1}} + \frac{{F_3 - 1}}{{G_1 G_2}} + \cdots$$

Where *F* = linear noise factor (not dB), *G* = linear gain.
The first stage NF dominates — minimise LNA/driver NF for best system sensitivity.

---
> **Note:** All values are estimated from component datasheets at 25 °C nominal.
> Verify with bench measurements (spectrum analyser + noise source) during hardware bring-up.