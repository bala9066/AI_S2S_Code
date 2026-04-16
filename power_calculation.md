# Power Calculation
## rbfgf

**Date:** 16-04-2026

> All values in Watts (W). TYP = typical operating power, MAX = worst-case (130% of TYP).
> Rail assignment is based on component operating voltage from BOM.

## Power Budget — 5 V & 3.3 V Rails

| SI | Description | Part No | Qty | 5V TYP (W) | 5V MAX (W) | 3.3V TYP (W) | 3.3V MAX (W) | Total TYP (W) | Total MAX (W) |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | RF Input Limiter | LMC6048 | 1 | — | — | 0.99 | 1.287 | 0.99 | 1.287 |
| 2 | Wideband LNA | TGA4538 | 1 | — | — | 0.165 | 0.214 | 0.165 | 0.214 |
| 3 | Mixer Downconverter | HMC698LP4 | 1 | — | — | 0.165 | 0.214 | 0.165 | 0.214 |
| 4 | PLL/LO Synthesizer | ADF5356 | 1 | — | — | 0.165 | 0.214 | 0.165 | 0.214 |
| 5 | IF Variable Gain Amplifier | HMC698LP4 | 1 | — | — | 0.99 | 1.287 | 0.99 | 1.287 |
| 6 | Dual ADC | ADC12J4000 | 1 | — | — | 0.165 | 0.214 | 0.165 | 0.214 |
| 7 | FPGA Digital Signal Processing | RTK7 | 1 | — | — | 1.65 | 2.145 | 1.65 | 2.145 |
| 8 | DC-DC Converter Module | VPT15-28T12 | 1 | — | — | 0.033 | 0.043 | 0.033 | 0.043 |
| 9 | LDO Regulator 3.3V | LT1086 | 1 | — | — | 0.033 | 0.043 | 0.033 | 0.043 |
| 10 | LDO Regulator 5V | LT3045 | 1 | 0.05 | 0.065 | — | — | 0.05 | 0.065 |
| | **TOTALS** | |  | **0.05** | **0.065** | **4.356** | **5.661** | **4.406** | **5.726** |

## Power Budget — 2.5 V & 1.8 V Rails

| SI | Description | Part No | Qty | 2.5V TYP (W) | 2.5V MAX (W) | 1.8V TYP (W) | 1.8V MAX (W) | Total TYP (W) | Total MAX (W) |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | RF Input Limiter | LMC6048 | 1 | — | — | — | — | — | — |
| 2 | Wideband LNA | TGA4538 | 1 | — | — | — | — | — | — |
| 3 | Mixer Downconverter | HMC698LP4 | 1 | — | — | — | — | — | — |
| 4 | PLL/LO Synthesizer | ADF5356 | 1 | — | — | — | — | — | — |
| 5 | IF Variable Gain Amplifier | HMC698LP4 | 1 | — | — | — | — | — | — |
| 6 | Dual ADC | ADC12J4000 | 1 | — | — | — | — | — | — |
| 7 | FPGA Digital Signal Processing | RTK7 | 1 | — | — | — | — | — | — |
| 8 | DC-DC Converter Module | VPT15-28T12 | 1 | — | — | — | — | — | — |
| 9 | LDO Regulator 3.3V | LT1086 | 1 | — | — | — | — | — | — |
| 10 | LDO Regulator 5V | LT3045 | 1 | — | — | — | — | — | — |
| | **TOTALS** | |  | **0.0** | **0.0** | **0.0** | **0.0** | **0.0** | **0.0** |

---

## Power Summary

| Rail | Typical Power (W) | Max Power (W) |
|------|-------------------|---------------|
| 5V | 0.05 | 0.065 |
| 3.3V | 4.356 | 5.661 |
| 2.5V | 0.0 | 0.0 |
| 1.8V | 0.0 | 0.0 |
| **TOTAL** | **4.406** | **5.726** |

> Note: Power values are estimated from component datasheets and design parameters.
> Actual measurements should be taken during hardware bring-up and updated in this table.