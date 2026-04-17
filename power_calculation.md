# Power Calculation
## receiver

**Date:** 17-04-2026

> All values in Watts (W). TYP = typical operating power, MAX = worst-case (130% of TYP).
> Rail assignment is based on component operating voltage from BOM.

## Power Budget — 5 V & 3.3 V Rails

| SI | Description | Part No | Qty | 5V TYP (W) | 5V MAX (W) | 3.3V TYP (W) | 3.3V MAX (W) | Total TYP (W) | Total MAX (W) |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | RF Limiter / Input Protection | HMC1061LP4E | 1 | 1.5 | 1.95 | — | — | 1.5 | 1.95 |
| 2 | Wideband Low Noise Amplifier | TGA4506-SM | 1 | 1.8 | 2.34 | — | — | 1.8 | 2.34 |
| 3 | Variable Gain Amplifier | HMC698LP4 | 1 | 1.5 | 1.95 | — | — | 1.5 | 1.95 |
| 4 | IQ Mixer / Downconverter | HMC1052LP4E | 1 | 0.25 | 0.325 | — | — | 0.25 | 0.325 |
| 5 | LO Frequency Synthesizer | ADF5356 | 1 | — | — | 0.158 | 0.205 | 0.158 | 0.205 |
| 6 | IF Amplifier (Baseband IQ) | ADA4817 | 1 | 0.098 | 0.127 | — | — | 0.098 | 0.127 |
| 7 | Anti-Alias Filter (Baseband) | LPF-1000+ | 1 | — | — | 0.165 | 0.214 | 0.165 | 0.214 |
| 8 | Dual Channel IQ ADC | AD9208 | 1 | — | — | — | — | — | — |
| 9 | Control MCU | STM32F407VGT6 | 1 | — | — | — | — | — | — |
| 10 | DC-DC Power Supply Module | LTM4644 | 1 | — | — | 0.033 | 0.043 | 0.033 | 0.043 |
| | **TOTALS** | |  | **5.148** | **6.692** | **0.356** | **0.462** | **5.504** | **7.154** |

## Power Budget — 2.5 V & 1.8 V Rails

| SI | Description | Part No | Qty | 2.5V TYP (W) | 2.5V MAX (W) | 1.8V TYP (W) | 1.8V MAX (W) | Total TYP (W) | Total MAX (W) |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | RF Limiter / Input Protection | HMC1061LP4E | 1 | — | — | — | — | — | — |
| 2 | Wideband Low Noise Amplifier | TGA4506-SM | 1 | — | — | — | — | — | — |
| 3 | Variable Gain Amplifier | HMC698LP4 | 1 | — | — | — | — | — | — |
| 4 | IQ Mixer / Downconverter | HMC1052LP4E | 1 | — | — | — | — | — | — |
| 5 | LO Frequency Synthesizer | ADF5356 | 1 | — | — | — | — | — | — |
| 6 | IF Amplifier (Baseband IQ) | ADA4817 | 1 | — | — | — | — | — | — |
| 7 | Anti-Alias Filter (Baseband) | LPF-1000+ | 1 | — | — | — | — | — | — |
| 8 | Dual Channel IQ ADC | AD9208 | 1 | — | — | 0.05 | 0.065 | 0.05 | 0.065 |
| 9 | Control MCU | STM32F407VGT6 | 1 | — | — | 0.27 | 0.351 | 0.27 | 0.351 |
| 10 | DC-DC Power Supply Module | LTM4644 | 1 | — | — | — | — | — | — |
| | **TOTALS** | |  | **0.0** | **0.0** | **0.32** | **0.416** | **0.32** | **0.416** |

---

## Power Summary

| Rail | Typical Power (W) | Max Power (W) |
|------|-------------------|---------------|
| 5V | 5.148 | 6.692 |
| 3.3V | 0.356 | 0.462 |
| 2.5V | 0.0 | 0.0 |
| 1.8V | 0.32 | 0.416 |
| **TOTAL** | **5.824** | **7.57** |

> Note: Power values are estimated from component datasheets and design parameters.
> Actual measurements should be taken during hardware bring-up and updated in this table.