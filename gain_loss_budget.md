# RF Gain-Loss Budget
## hm

**Generated:** 2026-04-18  
**Document Status:** AI-GENERATED — verify against final component datasheets

## 1. System Parameters

| Parameter | Value | Unit |
|-----------|-------|------|
| Centre Frequency    | 650   | MHz  |
| RF Bandwidth        | 10     | MHz  |
| Input Signal Level  | -100   | dBm  |
| Target Output Power | -70  | dBm  |
| Required System Gain | 30 | dB   |

## 2. Stage-by-Stage Gain / Loss Budget

| # | Stage | Component | Gain/Loss (dB) | Cum. Gain (dB) | Output Power (dBm) | NF (dB) | Cum. NF (dB) | P1dB Out (dBm) | OIP3 (dBm) | Notes |
|---|-------|-----------|---------------|----------------|-------------------|---------|-------------|---------------|-----------|-------|
| 1 | Input Protection Limiter | SKY16406-321LF | -0.6 | -0.6 | -100.6 | 0.60 | 0.60 | N/A | N/A | Low leakage; protects LNA from high-power signals up to +20 dBm at antenna port |
| 2 | RF Switched Filter Bank (SPDT x2 + BPF) | HMC253LC4 + LC BPF | -2.8 | -3.4 | -103.4 | 2.80 | 3.40 | N/A | N/A | 2x SPDT switches (0.7 dB each) + sub-band BPF (1.4 dB) |
| 3 | LNA | PMA3-83LN+ | +21.6 | 18.2 | -81.8 | 0.69 | 1.77 | 19.7 | 35.5 | Sets system NF; 0.69 dB NF at 650 MHz |
| 4 | RF Driver Amplifier | PMA3-83LN+ | +21.6 | 39.8 | -60.2 | 0.69 | 1.78 | 19.7 | 35.5 | Provides gain to overcome mixer and filter losses |
| 5 | 1st Mixer | ADE-25MH+ | -5.6 | 34.2 | -65.8 | 5.60 | 1.78 | 13.0 | 18.0 | RF to 70 MHz IF downconversion; LO at +7 dBm |
| 6 | IF Bandpass Filter 70 MHz | BFCG-70A+ | -3.0 | 31.2 | -68.8 | 3.00 | 1.78 | N/A | N/A | 10 MHz BW crystal filter; image rejection stage |
| 7 | IF VGA (AGC) | ADL5330 | -4.0 | 27.2 | -72.8 | 7.00 | 1.78 | 38.0 | 38.0 | Set to -4 dB gain for nominal -100 dBm input; AGC adjusts over 44 dB range |
| 8 | IQ Demodulator | LTC5596 | -0.3 | 26.9 | -73.1 | 0.30 | 1.78 | 26.0 | 26.0 | Splits IF to I/Q baseband; excellent IIP2 (+62 dBm) and I/Q balance |
| 9 | Baseband LPF (I and Q) | LTC1569-7 | -1.0 | 25.9 | -74.1 | 1.00 | 1.78 | N/A | N/A | 5 MHz cutoff per channel; Bessel for <1 ns group delay variation |
| 10 | BB Output Driver (I and Q) | ADA4899-1 | +6.0 | 31.9 | -68.1 | 3.00 | 1.78 | N/A | N/A | Drives 50 Ohm SMA; 1 Vpp output level at nominal input |

## 3. Budget Summary

| Metric | Value | Unit |
|--------|-------|------|
| Total System Gain     | 31.9  | dB  |
| Final Output Power    | -68.1  | dBm |
| Cascaded System NF    | 1.78 | dB  |
| Output Power Margin   | -1.9 | dB  |

## 4. Return Loss — Per Stage

| # | Stage | Component | S11 — Input RL (dB) | S22 — Output RL (dB) | Notes |
|---|-------|-----------|---------------------|----------------------|-------|
| 1 | Input Protection Limiter | SKY16406-321LF | 15.0 | 15.0 | Low leakage; protects LNA from high-power signals up to +20 dBm at antenna port |
| 2 | RF Switched Filter Bank (SPDT x2 + BPF) | HMC253LC4 + LC BPF | 12.0 | 12.0 | 2x SPDT switches (0.7 dB each) + sub-band BPF (1.4 dB) |
| 3 | LNA | PMA3-83LN+ | 18.0 | 15.0 | Sets system NF; 0.69 dB NF at 650 MHz |
| 4 | BB Output Driver (I and Q) | ADA4899-1 | — | 20.0 | Drives 50 Ohm SMA; 1 Vpp output level at nominal input |

> Return loss values are referenced to 50 Ω. Higher value = better match.

## 5. Cascade Noise Figure — Friis Formula

$$F_{{sys}} = F_1 + \frac{{F_2 - 1}}{{G_1}} + \frac{{F_3 - 1}}{{G_1 G_2}} + \cdots$$

Where *F* = linear noise factor (not dB), *G* = linear gain.
The first stage NF dominates — minimise LNA/driver NF for best system sensitivity.

---
> **Note:** All values are estimated from component datasheets at 25 °C nominal.
> Verify with bench measurements (spectrum analyser + noise source) during hardware bring-up.