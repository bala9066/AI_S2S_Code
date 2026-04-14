# RF Gain-Loss Budget
## rf tx

**Generated:** 2026-04-14  
**Document Status:** AI-GENERATED — verify against final component datasheets

## 1. System Parameters

| Parameter | Value | Unit |
|-----------|-------|------|
| Centre Frequency    | 11500   | MHz  |
| RF Bandwidth        | 13000     | MHz  |
| Input Signal Level  | -70   | dBm  |
| Target Output Power | -10  | dBm  |
| Required System Gain | 60 | dB   |

## 2. Stage-by-Stage Gain / Loss Budget

| # | Stage | Component | Gain/Loss (dB) | Cum. Gain (dB) | Output Power (dBm) | NF (dB) | Cum. NF (dB) | P1dB Out (dBm) | OIP3 (dBm) | Notes |
|---|-------|-----------|---------------|----------------|-------------------|---------|-------------|---------------|-----------|-------|
| 1 | RF Input Connector | SMA 142-0701-851 | -0.1 | -0.1 | -70.1 | 0.10 | 0.10 | N/A | N/A | Connector insertion loss |
| 2 | Wideband LNA | HMC1049LP3E | +20.0 | 19.9 | -50.1 | 3.00 | 3.01 | 15.0 | 25.0 | Sets system noise figure |
| 3 | RF Bandpass Filter | BP Filter 5-18 GHz | -2.0 | 17.9 | -52.1 | 2.00 | 3.45 | N/A | N/A | Image rejection and out-of-band rejection |
| 4 | Wideband Mixer | HMC1052LP4GE | +7.0 | 24.9 | -45.1 | 8.00 | 3.80 | 5.0 | 20.0 | Downconversion to 2.4 GHz IF, conversion gain |
| 5 | IF Bandpass Filter | BP Filter 2.4 GHz | -1.5 | 23.4 | -46.6 | 1.50 | 3.99 | N/A | N/A | IF shaping and LO feedthrough rejection |
| 6 | Variable Gain Amplifier | HMC698LP4 | +15.0 | 38.4 | -31.6 | 6.00 | 4.13 | 18.0 | 28.0 | Mid-range gain setting, 44 dB range available |
| 7 | ADC Input Driver | Transformer/Amp | -1.0 | 37.4 | -32.6 | 1.00 | 4.17 | N/A | N/A | Matching to ADC input |

## 3. Budget Summary

| Metric | Value | Unit |
|--------|-------|------|
| Total System Gain     | 37.4  | dB  |
| Final Output Power    | -32.6  | dBm |
| Cascaded System NF    | 4.17 | dB  |
| Output Power Margin   | +22.6 | dB  |

## 4. Cascade Noise Figure — Friis Formula

$$F_{sys} = F_1 + \frac{F_2 - 1}{G_1} + \frac{F_3 - 1}{G_1 G_2} + \cdots$$

Where *F* = linear noise factor (not dB), *G* = linear gain.
The first stage NF dominates — minimise LNA/driver NF for best system sensitivity.

---
> **Note:** All values are estimated from component datasheets at 25 °C nominal.
> Verify with bench measurements (spectrum analyser + noise source) during hardware bring-up.