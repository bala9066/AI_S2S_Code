# Power Calculation
## dsf

**Date:** 16-04-2026

> All values in Watts (W). TYP = typical operating power, MAX = worst-case (130% of TYP).
> Rail assignment is based on component operating voltage from BOM.

## Power Budget — 5 V & 3.3 V Rails

| SI | Description | Part No | Qty | 5V TYP (W) | 5V MAX (W) | 3.3V TYP (W) | 3.3V MAX (W) | Total TYP (W) | Total MAX (W) |
|----|-------------|---------|---- |-----------|-----------| |-----------|-----------|---------------|---------------|
| 1 | Wideband Low-Noise Amplifier (5-18 GHz) | HMC698LP4E | 1 | — | — | 0.99 | 1.287 | 0.99 | 1.287 |
| 2 | Wideband Mixer Downconverter | HMC1048LC4 | 1 | — | — | 0.165 | 0.214 | 0.165 | 0.214 |
| 3 | 10 GSPS ADC | ADC10DX300 | 1 | — | — | 0.165 | 0.214 | 0.165 | 0.214 |
| 4 | Wideband IF Amplifier | ADA4817-1 | 1 | — | — | 0.99 | 1.287 | 0.99 | 1.287 |
| 5 | Variable Gain Amplifier | HMC698LP2 | 1 | — | — | 0.99 | 1.287 | 0.99 | 1.287 |
| 6 | LO Synthesizer | LMX2594 | 1 | — | — | 0.165 | 0.214 | 0.165 | 0.214 |
| 7 | RF Power Supply DC-DC Converter | LTM4644 | 1 | — | — | 13.2 | 17.16 | 13.2 | 17.16 |
| 8 | RF Input Limiter/ESD Protection | GVA-123+ | 1 | — | — | 0.99 | 1.287 | 0.99 | 1.287 |
| 9 | Bandpass Filter 5-18 GHz | BP7G5G-18G-C3 | 1 | — | — | 0.99 | 1.287 | 0.99 | 1.287 |
| 10 | IF Lowpass Filter 3 GHz | LFCN-3000+ | 1 | — | — | 0.99 | 1.287 | 0.99 | 1.287 |
| 11 | Military-Grade MCU for Control | STM32H743VIH6 | 1 | — | — | 0.495 | 0.643 | 0.495 | 0.643 |
| | **TOTALS** | |  | **0.0** | **0.0** | **20.13** | **26.167** | **20.13** | **26.167** |

## Power Budget — 2.5 V & 1.8 V Rails

| SI | Description | Part No | Qty | 2.5V TYP (W) | 2.5V MAX (W) | 1.8V TYP (W) | 1.8V MAX (W) | Total TYP (W) | Total MAX (W) |
|----|-------------|---------|---- |-----------|-----------| |-----------|-----------|---------------|---------------|
| 1 | Wideband Low-Noise Amplifier (5-18 GHz) | HMC698LP4E | 1 | — | — | — | — | — | — |
| 2 | Wideband Mixer Downconverter | HMC1048LC4 | 1 | — | — | — | — | — | — |
| 3 | 10 GSPS ADC | ADC10DX300 | 1 | — | — | — | — | — | — |
| 4 | Wideband IF Amplifier | ADA4817-1 | 1 | — | — | — | — | — | — |
| 5 | Variable Gain Amplifier | HMC698LP2 | 1 | — | — | — | — | — | — |
| 6 | LO Synthesizer | LMX2594 | 1 | — | — | — | — | — | — |
| 7 | RF Power Supply DC-DC Converter | LTM4644 | 1 | — | — | — | — | — | — |
| 8 | RF Input Limiter/ESD Protection | GVA-123+ | 1 | — | — | — | — | — | — |
| 9 | Bandpass Filter 5-18 GHz | BP7G5G-18G-C3 | 1 | — | — | — | — | — | — |
| 10 | IF Lowpass Filter 3 GHz | LFCN-3000+ | 1 | — | — | — | — | — | — |
| 11 | Military-Grade MCU for Control | STM32H743VIH6 | 1 | — | — | — | — | — | — |
| | **TOTALS** | |  | **0.0** | **0.0** | **0.0** | **0.0** | **0.0** | **0.0** |

---

## Power Summary

| Rail | Typical Power (W) | Max Power (W) |
|------|-------------------|---------------|
| 5V | 0.0 | 0.0 |
| 3.3V | 20.13 | 26.167 |
| 2.5V | 0.0 | 0.0 |
| 1.8V | 0.0 | 0.0 |
| **TOTAL** | **20.13** | **26.167** |

> Note: Power values are estimated from component datasheets and design parameters.
> Actual measurements should be taken during hardware bring-up and updated in this table.