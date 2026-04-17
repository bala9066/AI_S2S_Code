# Power Calculation
## jhf

**Date:** 17-04-2026

> All values in Watts (W). TYP = typical operating power, MAX = worst-case (130% of TYP).
> Rail assignment is based on component operating voltage from BOM.

## Power Budget — 5 V & 3.3 V Rails

| SI | Description | Part No | Qty | 5V TYP (W) | 5V MAX (W) | 3.3V TYP (W) | 3.3V MAX (W) | Total TYP (W) | Total MAX (W) |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | Wideband Low Noise Amplifier 5-18 GHz | HMC6180LP4E | 1 | 0.96 | 1.248 | — | — | 0.96 | 1.248 |
| 2 | Wideband Variable Gain Amplifier/Attenuator | HMC698LP4 | 1 | — | — | 0.99 | 1.287 | 0.99 | 1.287 |
| 3 | Wideband Mixer for Downconversion | HMC558LC4 | 1 | — | — | 0.165 | 0.214 | 0.165 | 0.214 |
| 4 | Wideband Local Oscillator Synthesizer | ADF5356 | 1 | — | — | 0.165 | 0.214 | 0.165 | 0.214 |
| 5 | IF Amplifier | ADL5541 | 1 | — | — | 0.99 | 1.287 | 0.99 | 1.287 |
| 6 | RF Bandpass Filter 5-18 GHz | BP05G18G-06 | 1 | — | — | 0.99 | 1.287 | 0.99 | 1.287 |
| 7 | Power Management 12V to Rails | LM22676-12 | 1 | — | — | 9.9 | 12.87 | 9.9 | 12.87 |
| 8 | 3.3V LDO for Logic/Bias | LT3042 | 1 | — | — | 1.65 | 2.145 | 1.65 | 2.145 |
| 9 | RF Input Connector | 142-0701-851 | 1 | — | — | 0.99 | 1.287 | 0.99 | 1.287 |
| | **TOTALS** | |  | **0.96** | **1.248** | **15.84** | **20.591** | **16.8** | **21.839** |

---

## Power Summary

| Rail | Typical Power (W) | Max Power (W) |
|------|-------------------|---------------|
| 5V | 0.96 | 1.248 |
| 3.3V | 15.84 | 20.591 |
| 2.5V | 0.0 | 0.0 |
| 1.8V | 0.0 | 0.0 |
| **TOTAL** | **16.8** | **21.839** |

> Note: Power values are estimated from component datasheets and design parameters.
> Actual measurements should be taken during hardware bring-up and updated in this table.