# Power Calculation
## Test

**Date:** 17-04-2026

> All values in Watts (W). TYP = typical operating power, MAX = worst-case (130% of TYP).
> Rail assignment is based on component operating voltage from BOM.

## Power Budget — 5 V & 3.3 V Rails

| SI | Description | Part No | Qty | 5V TYP (W) | 5V MAX (W) | 3.3V TYP (W) | 3.3V MAX (W) | Total TYP (W) | Total MAX (W) |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | Wideband Low Noise Amplifier (LNA) - 5-18 GHz front-end gain block with low noise figure | HMC698LP4 | 1 | 0.45 | 0.585 | — | — | 0.45 | 0.585 |
| 2 | Programmable RF Variable Gain Amplifier (VGA/DSA) - Digital step attenuator for AGC | HMC698LP4E | 1 | — | — | 0.99 | 1.287 | 0.99 | 1.287 |
| 3 | Wideband Digital Step Attenuator - AGC covering up to 18 GHz | QPC9054 | 1 | — | — | 0.165 | 0.214 | 0.165 | 0.214 |
| 4 | 14-bit ADC, >5 GS/s sampling rate with JESD204B/C output | ADC12DJ5200RF | 1 | — | — | — | — | — | — |
| 5 | Ultra-low jitter clock generator for ADC sampling clock | LMK61E2 | 1 | — | — | 0.165 | 0.214 | 0.165 | 0.214 |
| 6 | DC-DC Buck Converter - 5V to 3.3V for analog rail | TPS62913 | 1 | 0.05 | 0.065 | — | — | 0.05 | 0.065 |
| 7 | LDO Regulator - 3.3V to 1.8V for ADC IO rail | TPS7A47 | 1 | — | — | — | — | — | — |
| 8 | LDO Regulator - 5V to 1.0V for ADC core rail (high current) | TPS7A8300 | 1 | 0.25 | 0.325 | — | — | 0.25 | 0.325 |
| 9 | Balun transformer - Single-ended to differential conversion for ADC input | EGL-2422-SM | 1 | — | — | 0.165 | 0.214 | 0.165 | 0.214 |
| 10 | SMA RF connector - Input port | 142-0701-851 | 1 | — | — | 0.99 | 1.287 | 0.99 | 1.287 |
| 11 | Microcontroller/FPGA for system control and SPI communication | STM32F407 | 1 | — | — | 1.65 | 2.145 | 1.65 | 2.145 |
| | **TOTALS** | |  | **0.75** | **0.975** | **4.125** | **5.361** | **4.875** | **6.336** |

## Power Budget — 2.5 V & 1.8 V Rails

| SI | Description | Part No | Qty | 2.5V TYP (W) | 2.5V MAX (W) | 1.8V TYP (W) | 1.8V MAX (W) | Total TYP (W) | Total MAX (W) |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | Wideband Low Noise Amplifier (LNA) - 5-18 GHz front-end gain block with low noise figure | HMC698LP4 | 1 | — | — | — | — | — | — |
| 2 | Programmable RF Variable Gain Amplifier (VGA/DSA) - Digital step attenuator for AGC | HMC698LP4E | 1 | — | — | — | — | — | — |
| 3 | Wideband Digital Step Attenuator - AGC covering up to 18 GHz | QPC9054 | 1 | — | — | — | — | — | — |
| 4 | 14-bit ADC, >5 GS/s sampling rate with JESD204B/C output | ADC12DJ5200RF | 1 | — | — | 0.05 | 0.065 | 0.05 | 0.065 |
| 5 | Ultra-low jitter clock generator for ADC sampling clock | LMK61E2 | 1 | — | — | — | — | — | — |
| 6 | DC-DC Buck Converter - 5V to 3.3V for analog rail | TPS62913 | 1 | — | — | — | — | — | — |
| 7 | LDO Regulator - 3.3V to 1.8V for ADC IO rail | TPS7A47 | 1 | — | — | 0.09 | 0.117 | 0.09 | 0.117 |
| 8 | LDO Regulator - 5V to 1.0V for ADC core rail (high current) | TPS7A8300 | 1 | — | — | — | — | — | — |
| 9 | Balun transformer - Single-ended to differential conversion for ADC input | EGL-2422-SM | 1 | — | — | — | — | — | — |
| 10 | SMA RF connector - Input port | 142-0701-851 | 1 | — | — | — | — | — | — |
| 11 | Microcontroller/FPGA for system control and SPI communication | STM32F407 | 1 | — | — | — | — | — | — |
| | **TOTALS** | |  | **0.0** | **0.0** | **0.14** | **0.182** | **0.14** | **0.182** |

---

## Power Summary

| Rail | Typical Power (W) | Max Power (W) |
|------|-------------------|---------------|
| 5V | 0.75 | 0.975 |
| 3.3V | 4.125 | 5.361 |
| 2.5V | 0.0 | 0.0 |
| 1.8V | 0.14 | 0.182 |
| **TOTAL** | **5.015** | **6.518** |

> Note: Power values are estimated from component datasheets and design parameters.
> Actual measurements should be taken during hardware bring-up and updated in this table.