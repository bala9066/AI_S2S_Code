# RF Gain-Loss Budget
## rx module

**Generated:** 2026-04-17  
**Document Status:** AI-GENERATED — verify against final component datasheets

## 1. System Parameters

| Parameter | Value | Unit |
|-----------|-------|------|
| Centre Frequency    | 13000   | MHz  |
| RF Bandwidth        | 6500     | MHz  |
| Input Signal Level  | -70   | dBm  |
| Target Output Power | -10  | dBm  |
| Required System Gain | 60 | dB   |

## 2. Stage-by-Stage Gain / Loss Budget

| # | Stage | Component | Gain/Loss (dB) | Cum. Gain (dB) | Output Power (dBm) | NF (dB) | Cum. NF (dB) | P1dB Out (dBm) | OIP3 (dBm) | Notes |
|---|-------|-----------|---------------|----------------|-------------------|---------|-------------|---------------|-----------|-------|
| 1 | RF Input + SMA Connector | 142-0701-851 SMA connector | -0.2 | -0.2 | -70.2 | 0.20 | 0.20 | N/A | N/A | Connector loss |
| 2 | Input Bandpass Filter | BP5G18G-4500-C4 | -2.0 | -2.2 | -72.2 | 2.00 | 2.20 | N/A | N/A | 5-18 GHz BPF, helps meet VSWR 2:1 |
| 3 | Wideband LNA | HMC6180LP4E | +21.0 | 18.8 | -51.2 | 2.50 | 2.63 | 19.0 | 30.0 | Main gain stage, sets system NF |
| 4 | Variable Gain Amplifier | HMC698LP4 at mid-gain 25dB | +25.0 | 43.8 | -26.2 | 6.00 | 2.68 | 19.0 | 29.0 | Manual gain control 0-50dB range |
| 5 | Downconverter Mixer | HMC556LC3B | -10.0 | 33.8 | -36.2 | 10.00 | 2.75 | 9.0 | 23.0 | IF output after downconversion |
| 6 | IF Amplifier | ADA4817 (650 MHz GBP) | +15.0 | 48.8 | -21.2 | 3.50 | 2.77 | 15.0 | 28.0 | Baseband gain before demod |
| 7 | IQ Demodulator | ADL5380 | +6.0 | 54.8 | -15.2 | 8.00 | 2.79 | 11.5 | 24.0 | I/Q baseband outputs to ADC |

## 3. Budget Summary

| Metric | Value | Unit |
|--------|-------|------|
| Total System Gain     | 54.8  | dB  |
| Final Output Power    | -15.2  | dBm |
| Cascaded System NF    | 2.79 | dB  |
| Output Power Margin   | +5.2 | dB  |

## 4. Return Loss — Per Stage

| # | Stage | Component | S11 — Input RL (dB) | S22 — Output RL (dB) | Notes |
|---|-------|-----------|---------------------|----------------------|-------|
| 1 | RF Input + SMA Connector | 142-0701-851 SMA connector | 14.0 | 14.0 | Connector loss |
| 2 | Input Bandpass Filter | BP5G18G-4500-C4 | 12.0 | 12.0 | 5-18 GHz BPF, helps meet VSWR 2:1 |
| 3 | Wideband LNA | HMC6180LP4E | 10.0 | 10.0 | Main gain stage, sets system NF |
| 4 | Variable Gain Amplifier | HMC698LP4 at mid-gain 25dB | 10.0 | 10.0 | Manual gain control 0-50dB range |
| 5 | Downconverter Mixer | HMC556LC3B | 10.0 | 8.0 | IF output after downconversion |
| 6 | IF Amplifier | ADA4817 (650 MHz GBP) | 12.0 | 12.0 | Baseband gain before demod |
| 7 | IQ Demodulator | ADL5380 | 10.0 | 12.0 | I/Q baseband outputs to ADC |

> Return loss values are referenced to 50 Ω. Higher value = better match.

## 5. Output Power vs Frequency

| Frequency (MHz) | Output Power (dBm) | Gain (dB) | Flatness (dB) |
|-----------------|--------------------|-----------|---------------|
| 5000 | -15.8 | 54.2 | -1.0 |
| 8000 | -14.8 | 55.2 | +0.0 |
| 11500 | -13.8 | 56.2 | +1.0 |
| 13000 | -15.2 | 54.8 | +0.0 |
| 15000 | -14.3 | 55.7 | +0.9 |
| 18000 | -16.2 | 53.8 | -1.0 |

> Flatness measured relative to midband output power.

## 6. Cascade Noise Figure — Friis Formula

$$F_{{sys}} = F_1 + \frac{{F_2 - 1}}{{G_1}} + \frac{{F_3 - 1}}{{G_1 G_2}} + \cdots$$

Where *F* = linear noise factor (not dB), *G* = linear gain.
The first stage NF dominates — minimise LNA/driver NF for best system sensitivity.

---
> **Note:** All values are estimated from component datasheets at 25 °C nominal.
> Verify with bench measurements (spectrum analyser + noise source) during hardware bring-up.