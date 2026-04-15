# Power Calculation
## kh

**Date:** 15-04-2026

> All values in Watts (W). TYP = typical operating power, MAX = worst-case (130% of TYP).
> Rail assignment is based on component operating voltage from BOM.

## Power Budget — 5 V & 3.3 V Rails

| SI | Description | Part No | Qty | 5V TYP (W) | 5V MAX (W) | 3.3V TYP (W) | 3.3V MAX (W) | Total TYP (W) | Total MAX (W) |
|----|-------------|---------|---- |-----------|-----------| |-----------|-----------|---------------|---------------|
| 1 | RF Low Noise Amplifier (LNA) | HMC1119LP4DE | 1 | 1.5 | 1.95 | — | — | 1.5 | 1.95 |
| 2 | Variable Gain Amplifier (VGA) | HMC698LP4 | 1 | — | — | 0.99 | 1.287 | 0.99 | 1.287 |
| 3 | RF Mixer for Downconversion | HMC1051LP4BE | 1 | — | — | 0.99 | 1.287 | 0.99 | 1.287 |
| 4 | IF Amplifier | ADL5541 | 1 | — | — | 0.99 | 1.287 | 0.99 | 1.287 |
| 5 | High-Speed ADC with LVDS | ADC12DJ5200RF | 1 | — | — | 0.165 | 0.214 | 0.165 | 0.214 |
| 6 | Bandpass Filter 10-15 GHz | CBP-1250-C3 | 1 | — | — | 0.99 | 1.287 | 0.99 | 1.287 |
| 7 | DC-DC Power Converter | LTM4625 | 1 | — | — | 0.033 | 0.043 | 0.033 | 0.043 |
| 8 | LDO Regulator for Analog | LT3045 | 1 | — | — | 0.033 | 0.043 | 0.033 | 0.043 |
| | **TOTALS** | |  | **1.5** | **1.95** | **4.191** | **5.448** | **5.691** | **7.398** |

## Power Budget — 2.5 V & 1.8 V Rails

| SI | Description | Part No | Qty | 2.5V TYP (W) | 2.5V MAX (W) | 1.8V TYP (W) | 1.8V MAX (W) | Total TYP (W) | Total MAX (W) |
|----|-------------|---------|---- |-----------|-----------| |-----------|-----------|---------------|---------------|
| 1 | RF Low Noise Amplifier (LNA) | HMC1119LP4DE | 1 | — | — | — | — | — | — |
| 2 | Variable Gain Amplifier (VGA) | HMC698LP4 | 1 | — | — | — | — | — | — |
| 3 | RF Mixer for Downconversion | HMC1051LP4BE | 1 | — | — | — | — | — | — |
| 4 | IF Amplifier | ADL5541 | 1 | — | — | — | — | — | — |
| 5 | High-Speed ADC with LVDS | ADC12DJ5200RF | 1 | — | — | — | — | — | — |
| 6 | Bandpass Filter 10-15 GHz | CBP-1250-C3 | 1 | — | — | — | — | — | — |
| 7 | DC-DC Power Converter | LTM4625 | 1 | — | — | — | — | — | — |
| 8 | LDO Regulator for Analog | LT3045 | 1 | — | — | — | — | — | — |
| | **TOTALS** | |  | **0.0** | **0.0** | **0.0** | **0.0** | **0.0** | **0.0** |

---

## Power Summary

| Rail | Typical Power (W) | Max Power (W) |
|------|-------------------|---------------|
| 5V | 1.5 | 1.95 |
| 3.3V | 4.191 | 5.448 |
| 2.5V | 0.0 | 0.0 |
| 1.8V | 0.0 | 0.0 |
| **TOTAL** | **5.691** | **7.398** |

> Note: Power values are estimated from component datasheets and design parameters.
> Actual measurements should be taken during hardware bring-up and updated in this table.