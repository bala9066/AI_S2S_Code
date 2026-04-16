# RF Gain-Loss Budget
## khgk

**Generated:** 2026-04-16  
**Document Status:** AI-GENERATED — verify against final component datasheets

## 1. System Parameters

| Parameter | Value | Unit |
|-----------|-------|------|
| Centre Frequency    | 11500   | MHz  |
| RF Bandwidth        | 13000     | MHz  |
| Input Signal Level  | -60   | dBm  |
| Target Output Power | 0  | dBm  |
| Required System Gain | 60 | dB   |

## 2. Stage-by-Stage Gain / Loss Budget

| # | Stage | Component | Gain/Loss (dB) | Cum. Gain (dB) | Output Power (dBm) | NF (dB) | Cum. NF (dB) | P1dB Out (dBm) | OIP3 (dBm) | Notes |
|---|-------|-----------|---------------|----------------|-------------------|---------|-------------|---------------|-----------|-------|
| 1 | Input Matching Network | 50 Ohm microstrip matching network | -0.5 | -0.5 | -60.5 | 0.50 | 0.50 | N/A | N/A | Includes SMA connector loss and input matching |
| 2 | Wideband LNA | Qorvo TGA4943-SM (biased for LNA operation) | +18.0 | 17.5 | -42.5 | 3.50 | 3.54 | 20.0 | 35.0 | GaN MMIC biased for low-noise operation |
| 3 | Digital VGA (mid-band setting) | Analog Devices HMC698LP4 @ +10 dB gain | +10.0 | 27.5 | -32.5 | 6.00 | 3.74 | 25.0 | 35.0 | Typical gain setting for nominal input |
| 4 | RF Bandpass Filter (Tracking) | 5-18 GHz tracking bandpass filter | -2.0 | 25.5 | -34.5 | 2.00 | 4.08 | N/A | N/A | Out-of-band rejection, provides image rejection |
| 5 | Wideband I/Q Mixer | Analog Devices HMC525LC4 | +7.0 | 32.5 | -27.5 | 10.00 | 4.96 | 15.0 | 28.0 | Active mixer with +7 dB conversion gain |
| 6 | IF Amplifier Stage 1 | Wideband IF amplifier @ +15 dB gain | +15.0 | 47.5 | -12.5 | 4.00 | 5.01 | 20.0 | 30.0 | Programmable IF gain, DC-2 GHz bandwidth |
| 7 | Anti-Alias Filter | 500 MHz LPF or BPF | -1.0 | 46.5 | -13.5 | 1.00 | 5.09 | N/A | N/A | Anti-aliasing before ADC, 500 MHz bandwidth |
| 8 | JESD204B/C ADC | TI ADC12DJ3200 @ 1.6 GSPS dual | +0.0 | 46.5 | -13.5 | 0.00 | 5.09 | 0.0 | N/A | Digital quantization, effective SNR ~56 dBFS at ADC input |

## 3. Budget Summary

| Metric | Value | Unit |
|--------|-------|------|
| Total System Gain     | 46.5  | dB  |
| Final Output Power    | -13.5  | dBm |
| Cascaded System NF    | 5.09 | dB  |
| Output Power Margin   | +13.5 | dB  |

## 4. Return Loss — Per Stage

| # | Stage | Component | S11 — Input RL (dB) | S22 — Output RL (dB) | Notes |
|---|-------|-----------|---------------------|----------------------|-------|
| 1 | Input Matching Network | 50 Ohm microstrip matching network | 15.0 | — | Includes SMA connector loss and input matching |
| 2 | Wideband LNA | Qorvo TGA4943-SM (biased for LNA operation) | 12.0 | 10.0 | GaN MMIC biased for low-noise operation |
| 3 | Digital VGA (mid-band setting) | Analog Devices HMC698LP4 @ +10 dB gain | 14.0 | 12.0 | Typical gain setting for nominal input |
| 4 | RF Bandpass Filter (Tracking) | 5-18 GHz tracking bandpass filter | 15.0 | 15.0 | Out-of-band rejection, provides image rejection |
| 5 | Wideband I/Q Mixer | Analog Devices HMC525LC4 | 10.0 | 8.0 | Active mixer with +7 dB conversion gain |
| 6 | IF Amplifier Stage 1 | Wideband IF amplifier @ +15 dB gain | 12.0 | 10.0 | Programmable IF gain, DC-2 GHz bandwidth |
| 7 | Anti-Alias Filter | 500 MHz LPF or BPF | 15.0 | 15.0 | Anti-aliasing before ADC, 500 MHz bandwidth |
| 8 | JESD204B/C ADC | TI ADC12DJ3200 @ 1.6 GSPS dual | 10.0 | — | Digital quantization, effective SNR ~56 dBFS at ADC input |

> Return loss values are referenced to 50 Ω. Higher value = better match.

## 5. Cascade Noise Figure — Friis Formula

$$F_{{sys}} = F_1 + \frac{{F_2 - 1}}{{G_1}} + \frac{{F_3 - 1}}{{G_1 G_2}} + \cdots$$

Where *F* = linear noise factor (not dB), *G* = linear gain.
The first stage NF dominates — minimise LNA/driver NF for best system sensitivity.

---
> **Note:** All values are estimated from component datasheets at 25 °C nominal.
> Verify with bench measurements (spectrum analyser + noise source) during hardware bring-up.