# Power Calculation
## rx receiver

**Date:** 16-04-2026

> All values in Watts (W). TYP = typical operating power, MAX = worst-case (130% of TYP).
> Rail assignment is based on component operating voltage from BOM.

## Component Power Budget

| # | Component | Part Number | Rail | TYP (W) | MAX (W) |
|---|-----------|-------------|------|----------|----------|
| 1 | Wideband Low Noise Amplifier (5-18 GHz) | HMC6180LP4E | 5V | 0.45 | 0.585 |
| 2 | IQ Demodulator Mixer (5-18 GHz) | HMC519LC4 | 5V | 0.25 | 0.325 |
| 3 | Wideband IQ Mixer (8-18 GHz) - Upper Band Option | MIXIQ-1030 | 3.3V | 0.165 | 0.214 |
| 4 | PLL/Frequency Synthesizer with Integrated VCO | LMX2594 | 3.3V | 0.165 | 0.214 |
| 5 | Variable Gain IF Amplifier | HMC698LP4 | 3.3V | 0.99 | 1.287 |
| 6 | Dual High-Speed ADC for I/Q Digitization | ADC12DJ3200 | 3.3V | 0.165 | 0.214 |
| 7 | FPGA for Digital Signal Processing | XCZU4EV-SFVC784 | 3.3V | 1.65 | 2.145 |
| 8 | ARM Cortex MCU for System Control | STM32H753BI | 3.3V | 0.495 | 0.643 |
| 9 | Wideband Bandpass Filter (5-18 GHz) | CBP-1800-S+ | 3.3V | 0.99 | 1.287 |
| 10 | 12V to 5V DC-DC Converter | LTM4644 | 5V | 0.05 | 0.065 |
| 11 | RF Input Connector | 142-0701-851 | 3.3V | 0.99 | 1.287 |
| 12 | IF Low Pass Filter (2 GHz cutoff) | LPF-2000-S+ | 3.3V | 0.99 | 1.287 |

## Power Summary by Rail

| Rail | Typical Power (W) | Max Power (W) |
|------|-------------------|---------------|
| 5V | 0.75 | 0.975 |
| 3.3V | 6.6 | 8.578 |
| 2.5V | 0.0 | 0.0 |
| 1.8V | 0.0 | 0.0 |
| **TOTAL** | **7.35** | **9.553** |

> Note: Power values are estimated from component datasheets and design parameters.
> Actual measurements should be taken during hardware bring-up and updated in this table.