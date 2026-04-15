# RF Gain-Loss Budget
## ajsfdvhjs

**Generated:** 2026-04-15  
**Document Status:** AI-GENERATED — verify against final component datasheets

## 1. System Parameters

| Parameter | Value | Unit |
|-----------|-------|------|
| Centre Frequency    | 11500   | MHz  |
| RF Bandwidth        | 1000     | MHz  |
| Input Signal Level  | -30   | dBm  |
| Target Output Power | -10  | dBm  |
| Required System Gain | 20 | dB   |

## 2. Stage-by-Stage Gain / Loss Budget

| # | Stage | Component | Gain/Loss (dB) | Cum. Gain (dB) | Output Power (dBm) | NF (dB) | Cum. NF (dB) | P1dB Out (dBm) | OIP3 (dBm) | Notes |
|---|-------|-----------|---------------|----------------|-------------------|---------|-------------|---------------|-----------|-------|
| 1 | Input Matching Network | 50 Ohm microstrip match | -0.5 | -0.5 | -30.5 | 0.50 | 0.50 | N/A | N/A | Board trace loss SMA to LNA |
| 2 | Wideband LNA | TGA4943-SL | +18.0 | 17.5 | -12.5 | 3.00 | 3.02 | 33.0 | 40.0 | High gain, high P1dB GaN driver |
| 3 | VGA / Attenuator | HMC698LP4 | -5.0 | 12.5 | -17.5 | 5.00 | 3.15 | 28.0 | 35.0 | Digital attenuator for AGC |
| 4 | Downconversion Mixer | HMC1048LP4BE | -7.5 | 5.0 | -25.0 | 7.50 | 3.62 | 15.0 | 23.0 | Double balanced mixer |
| 5 | IF Amplifier | HMC1119 IF Amp | +12.0 | 17.0 | -13.0 | 4.00 | 3.88 | 18.0 | 28.0 | Post-mixer IF gain stage |
| 6 | IQ Demodulator Filter | LC Lowpass Filter | -2.0 | 15.0 | -15.0 | 2.00 | 3.95 | N/A | N/A | Anti-aliasing filter |
| 7 | Baseband Amplifier | THS4509 | +15.0 | 30.0 | 0.0 | 4.00 | 4.03 | 20.0 | 35.0 | Fully differential driver to ADC |
| 8 | ADC Input Loss | ADC Input Network | -1.0 | 29.0 | -1.0 | 1.00 | 4.06 | N/A | N/A | Resistive termination |

## 3. Budget Summary

| Metric | Value | Unit |
|--------|-------|------|
| Total System Gain     | 29.0  | dB  |
| Final Output Power    | -1.0  | dBm |
| Cascaded System NF    | 4.06 | dB  |
| Output Power Margin   | -9 | dB  |

## 4. Cascade Noise Figure — Friis Formula

$$F_{sys} = F_1 + \frac{F_2 - 1}{G_1} + \frac{F_3 - 1}{G_1 G_2} + \cdots$$

Where *F* = linear noise factor (not dB), *G* = linear gain.
The first stage NF dominates — minimise LNA/driver NF for best system sensitivity.

---
> **Note:** All values are estimated from component datasheets at 25 °C nominal.
> Verify with bench measurements (spectrum analyser + noise source) during hardware bring-up.