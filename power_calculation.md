# Power Calculation
## khgk

**Date:** 16-04-2026

> All values in Watts (W). TYP = typical operating power, MAX = worst-case (130% of TYP).
> Rail assignment is based on component operating voltage from BOM.

## Power Budget — 5 V & 3.3 V Rails

| SI | Description | Part No | Qty | 5V TYP (W) | 5V MAX (W) | 3.3V TYP (W) | 3.3V MAX (W) | Total TYP (W) | Total MAX (W) |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | Wideband Low Noise Amplifier - 5-18 GHz, military temperature, high IP3 | TGA4943-SM | 1 | 3.6 | 4.68 | — | — | 3.6 | 4.68 |
| 2 | Digital Variable Gain Amplifier (DVGA) - Wideband IF/RF with SPI control | HMC698LP4 | 1 | — | — | 0.99 | 1.287 | 0.99 | 1.287 |
| 3 | Wideband I/Q Mixer - 5-18 GHz downconversion to IF | HMC525LC4 | 1 | — | — | 0.165 | 0.214 | 0.165 | 0.214 |
| 4 | Wideband Synthesizer / PLL - Low phase noise, fast tuning, 5-18 GHz | LMX2594 | 1 | — | — | 0.165 | 0.214 | 0.165 | 0.214 |
| 5 | JESD204B/C ADC - 1-2 GSPS, 12-14 bit, military temperature | ADC12DJ3200 | 1 | — | — | 0.165 | 0.214 | 0.165 | 0.214 |
| 6 | System Controller MCU - SPI control, telemetry, power sequencing | STM32H743VI | 1 | — | — | 0.495 | 0.643 | 0.495 | 0.643 |
| 7 | Wideband Power Supply - 12-15V input, multi-rail output, military temp | LTM4644 | 1 | 0.05 | 0.065 | — | — | 0.05 | 0.065 |
| | **TOTALS** | |  | **3.65** | **4.745** | **1.98** | **2.572** | **5.63** | **7.317** |

## Power Budget — 2.5 V & 1.8 V Rails

| SI | Description | Part No | Qty | 2.5V TYP (W) | 2.5V MAX (W) | 1.8V TYP (W) | 1.8V MAX (W) | Total TYP (W) | Total MAX (W) |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | Wideband Low Noise Amplifier - 5-18 GHz, military temperature, high IP3 | TGA4943-SM | 1 | — | — | — | — | — | — |
| 2 | Digital Variable Gain Amplifier (DVGA) - Wideband IF/RF with SPI control | HMC698LP4 | 1 | — | — | — | — | — | — |
| 3 | Wideband I/Q Mixer - 5-18 GHz downconversion to IF | HMC525LC4 | 1 | — | — | — | — | — | — |
| 4 | Wideband Synthesizer / PLL - Low phase noise, fast tuning, 5-18 GHz | LMX2594 | 1 | — | — | — | — | — | — |
| 5 | JESD204B/C ADC - 1-2 GSPS, 12-14 bit, military temperature | ADC12DJ3200 | 1 | — | — | — | — | — | — |
| 6 | System Controller MCU - SPI control, telemetry, power sequencing | STM32H743VI | 1 | — | — | — | — | — | — |
| 7 | Wideband Power Supply - 12-15V input, multi-rail output, military temp | LTM4644 | 1 | — | — | — | — | — | — |
| | **TOTALS** | |  | **0.0** | **0.0** | **0.0** | **0.0** | **0.0** | **0.0** |

---

## Power Summary

| Rail | Typical Power (W) | Max Power (W) |
|------|-------------------|---------------|
| 5V | 3.65 | 4.745 |
| 3.3V | 1.98 | 2.572 |
| 2.5V | 0.0 | 0.0 |
| 1.8V | 0.0 | 0.0 |
| **TOTAL** | **5.63** | **7.317** |

> Note: Power values are estimated from component datasheets and design parameters.
> Actual measurements should be taken during hardware bring-up and updated in this table.