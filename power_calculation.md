# Power Calculation
## dfbvd

**Date:** 16-04-2026

> All values in Watts (W). TYP = typical operating power, MAX = worst-case (130% of TYP).
> Rail assignment is based on component operating voltage from BOM.

## Component Power Budget

| # | Component | Part Number | Rail | TYP (W) | MAX (W) |
|---|-----------|-------------|------|----------|----------|
| 1 | Wideband Low Noise Amplifier (5-18 GHz) | HMC1099LP4E | 3.3V | 0.297 | 0.386 |
| 2 | Wideband Mixer for Downconversion | HMC1022LP4E | 3.3V | 0.165 | 0.214 |
| 3 | PLL Frequency Synthesizer (LO Source) | ADF5356 | 3.3V | 0.594 | 0.772 |
| 4 | High-Speed ADC (100-500 MSPS) | ADC12DJ3200 | 3.3V | 0.165 | 0.214 |
| 5 | Variable Gain IF Amplifier | ADL5202 | 3.3V | 0.99 | 1.287 |
| 6 | DC-DC Converter (12V to Distribution Voltages) | LTM8074 | 3.3V | 0.033 | 0.043 |
| 7 | Low Noise LDO Regulator (RF Supply) | LT3045 | 3.3V | 0.99 | 1.287 |
| 8 | RF Bandpass Filter (5-18 GHz) | CBP-5180-C+ | 3.3V | 0.99 | 1.287 |

## Power Summary by Rail

| Rail | Typical Power (W) | Max Power (W) |
|------|-------------------|---------------|
| 5V | 0.0 | 0.0 |
| 3.3V | 4.224 | 5.49 |
| 2.5V | 0.0 | 0.0 |
| 1.8V | 0.0 | 0.0 |
| **TOTAL** | **4.224** | **5.49** |

> Note: Power values are estimated from component datasheets and design parameters.
> Actual measurements should be taken during hardware bring-up and updated in this table.