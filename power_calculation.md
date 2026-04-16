# Power Calculation
## sample

**Date:** 16-04-2026

> All values in Watts (W). TYP = typical operating power, MAX = worst-case (130% of TYP).
> Rail assignment is based on component operating voltage from BOM.

## Power Budget — 5 V & 3.3 V Rails

| SI | Description | Part No | Qty | 5V TYP (W) | 5V MAX (W) | 3.3V TYP (W) | 3.3V MAX (W) | Total TYP (W) | Total MAX (W) |
|----|-------------|---------|---- |-----------|-----------| |-----------|-----------|---------------|---------------|
| 1 | Wideband LNA 5-18 GHz | HMC1134 | 1 | — | — | 0.281 | 0.365 | 0.281 | 0.365 |
| 2 | RF Band Switch | HMC1118 | 1 | — | — | 0.99 | 1.287 | 0.99 | 1.287 |
| 3 | Wideband Mixer | HMC559 | 1 | — | — | 0.165 | 0.214 | 0.165 | 0.214 |
| 4 | IF VGA / Attenuator | AD8376 | 1 | — | — | 0.165 | 0.214 | 0.165 | 0.214 |
| 5 | High-Speed ADC | AD9208 | 1 | — | — | 0.165 | 0.214 | 0.165 | 0.214 |
| 6 | Clock Generator / Jitter Cleaner | LMK04828 | 1 | — | — | 0.165 | 0.214 | 0.165 | 0.214 |
| 7 | Wideband PLL / LO Source | HMC7044 | 1 | — | — | 0.165 | 0.214 | 0.165 | 0.214 |
| 8 | Power Management - 3.3V | LT8610 | 1 | — | — | 8.25 | 10.725 | 8.25 | 10.725 |
| 9 | Power Management - 2.5V (ADC) | LT3045 | 1 | 2.5 | 3.25 | — | — | 2.5 | 3.25 |
| 10 | Power Management - 1.8V (Digital) | TPS62913 | 1 | — | — | — | — | — | — |
| 11 | Control MCU | STM32H743 | 1 | — | — | 0.495 | 0.643 | 0.495 | 0.643 |
| | **TOTALS** | |  | **2.5** | **3.25** | **10.841** | **14.09** | **13.341** | **17.34** |

## Power Budget — 2.5 V & 1.8 V Rails

| SI | Description | Part No | Qty | 2.5V TYP (W) | 2.5V MAX (W) | 1.8V TYP (W) | 1.8V MAX (W) | Total TYP (W) | Total MAX (W) |
|----|-------------|---------|---- |-----------|-----------| |-----------|-----------|---------------|---------------|
| 1 | Wideband LNA 5-18 GHz | HMC1134 | 1 | — | — | — | — | — | — |
| 2 | RF Band Switch | HMC1118 | 1 | — | — | — | — | — | — |
| 3 | Wideband Mixer | HMC559 | 1 | — | — | — | — | — | — |
| 4 | IF VGA / Attenuator | AD8376 | 1 | — | — | — | — | — | — |
| 5 | High-Speed ADC | AD9208 | 1 | — | — | — | — | — | — |
| 6 | Clock Generator / Jitter Cleaner | LMK04828 | 1 | — | — | — | — | — | — |
| 7 | Wideband PLL / LO Source | HMC7044 | 1 | — | — | — | — | — | — |
| 8 | Power Management - 3.3V | LT8610 | 1 | — | — | — | — | — | — |
| 9 | Power Management - 2.5V (ADC) | LT3045 | 1 | — | — | — | — | — | — |
| 10 | Power Management - 1.8V (Digital) | TPS62913 | 1 | — | — | 3.6 | 4.68 | 3.6 | 4.68 |
| 11 | Control MCU | STM32H743 | 1 | — | — | — | — | — | — |
| | **TOTALS** | |  | **0.0** | **0.0** | **3.6** | **4.68** | **3.6** | **4.68** |

---

## Power Summary

| Rail | Typical Power (W) | Max Power (W) |
|------|-------------------|---------------|
| 5V | 2.5 | 3.25 |
| 3.3V | 10.841 | 14.09 |
| 2.5V | 0.0 | 0.0 |
| 1.8V | 3.6 | 4.68 |
| **TOTAL** | **16.941** | **22.02** |

> Note: Power values are estimated from component datasheets and design parameters.
> Actual measurements should be taken during hardware bring-up and updated in this table.