# Power Calculation
## iguyc

**Date:** 15-04-2026

> All values in Watts (W). TYP = typical operating power, MAX = worst-case (130% of TYP).
> Rail assignment is based on component operating voltage from BOM.

## Power Budget — 5 V & 3.3 V Rails

| SI | Description | Part No | Qty | 5V TYP (W) | 5V MAX (W) | 3.3V TYP (W) | 3.3V MAX (W) | Total TYP (W) | Total MAX (W) |
|----|-------------|---------|---- |-----------|-----------| |-----------|-----------|---------------|---------------|
| 1 | Wideband Low Noise Amplifier covering 5-18 GHz with low noise figure and high linearity | HMC6987LP4E | 1 | — | — | 0.99 | 1.287 | 0.99 | 1.287 |
| 2 | Wideband downconversion mixer for 5-18 GHz IF translation | HMC1194LP4E | 1 | — | — | 0.165 | 0.214 | 0.165 | 0.214 |
| 3 | Wideband frequency synthesizer/PLL for LO generation 5-18 GHz | ADF5355 | 1 | — | — | 0.165 | 0.214 | 0.165 | 0.214 |
| 4 | Wideband Variable Gain Amplifier for AGC function | HMC698LP4 | 1 | — | — | 0.99 | 1.287 | 0.99 | 1.287 |
| 5 | High-speed ADC for signal digitization | ADC12DJ3200 | 1 | — | — | 0.165 | 0.214 | 0.165 | 0.214 |
| 6 | FPGA for signal processing and data interface | XCVU9P-FLGA2104 | 1 | — | — | 1.65 | 2.145 | 1.65 | 2.145 |
| 7 | RF Input Connector | 1492A-2-RFX | 1 | — | — | 0.99 | 1.287 | 0.99 | 1.287 |
| 8 | Wideband Bandpass Filter for front-end filtering | RBP-5180-10 | 1 | — | — | 0.99 | 1.287 | 0.99 | 1.287 |
| 9 | Power Supply Management | LTM4678 | 1 | — | — | 0.033 | 0.043 | 0.033 | 0.043 |
| | **TOTALS** | |  | **0.0** | **0.0** | **6.138** | **7.978** | **6.138** | **7.978** |

## Power Budget — 2.5 V & 1.8 V Rails

| SI | Description | Part No | Qty | 2.5V TYP (W) | 2.5V MAX (W) | 1.8V TYP (W) | 1.8V MAX (W) | Total TYP (W) | Total MAX (W) |
|----|-------------|---------|---- |-----------|-----------| |-----------|-----------|---------------|---------------|
| 1 | Wideband Low Noise Amplifier covering 5-18 GHz with low noise figure and high linearity | HMC6987LP4E | 1 | — | — | — | — | — | — |
| 2 | Wideband downconversion mixer for 5-18 GHz IF translation | HMC1194LP4E | 1 | — | — | — | — | — | — |
| 3 | Wideband frequency synthesizer/PLL for LO generation 5-18 GHz | ADF5355 | 1 | — | — | — | — | — | — |
| 4 | Wideband Variable Gain Amplifier for AGC function | HMC698LP4 | 1 | — | — | — | — | — | — |
| 5 | High-speed ADC for signal digitization | ADC12DJ3200 | 1 | — | — | — | — | — | — |
| 6 | FPGA for signal processing and data interface | XCVU9P-FLGA2104 | 1 | — | — | — | — | — | — |
| 7 | RF Input Connector | 1492A-2-RFX | 1 | — | — | — | — | — | — |
| 8 | Wideband Bandpass Filter for front-end filtering | RBP-5180-10 | 1 | — | — | — | — | — | — |
| 9 | Power Supply Management | LTM4678 | 1 | — | — | — | — | — | — |
| | **TOTALS** | |  | **0.0** | **0.0** | **0.0** | **0.0** | **0.0** | **0.0** |

---

## Power Summary

| Rail | Typical Power (W) | Max Power (W) |
|------|-------------------|---------------|
| 5V | 0.0 | 0.0 |
| 3.3V | 6.138 | 7.978 |
| 2.5V | 0.0 | 0.0 |
| 1.8V | 0.0 | 0.0 |
| **TOTAL** | **6.138** | **7.978** |

> Note: Power values are estimated from component datasheets and design parameters.
> Actual measurements should be taken during hardware bring-up and updated in this table.