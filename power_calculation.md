# Power Calculation
## kb

**Date:** 17-04-2026

> All values in Watts (W). TYP = typical operating power, MAX = worst-case (130% of TYP).
> Rail assignment is based on component operating voltage from BOM.

## Power Budget — 5 V & 3.3 V Rails

| SI | Description | Part No | Qty | 5V TYP (W) | 5V MAX (W) | 3.3V TYP (W) | 3.3V MAX (W) | Total TYP (W) | Total MAX (W) |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | RF Input Limiter Protection | LMLPF-BV-0+ | 1 | — | — | 0.99 | 1.287 | 0.99 | 1.287 |
| 2 | Wideband Bandpass Filter | VBFZ-5580+ | 1 | — | — | 0.99 | 1.287 | 0.99 | 1.287 |
| 3 | Wideband Low Noise Amplifier | TGA4956-SM | 1 | 0.425 | 0.553 | — | — | 0.425 | 0.553 |
| 4 | Variable Gain Attenuator | HMC698LP4 | 1 | — | — | 0.165 | 0.214 | 0.165 | 0.214 |
| 5 | Wideband Mixer | MAMX-011034 | 1 | — | — | 0.165 | 0.214 | 0.165 | 0.214 |
| 6 | Wideband LO Synthesizer | ADF5356 | 1 | — | — | 0.165 | 0.214 | 0.165 | 0.214 |
| 7 | 2 GSPS ADC | ADC12DJ3200 | 1 | — | — | 0.165 | 0.214 | 0.165 | 0.214 |
| 8 | Low Jitter Clock Generator | LMK04828 | 1 | — | — | 0.165 | 0.214 | 0.165 | 0.214 |
| 9 | Wideband LNA Alternative | NC1020-1212 | 1 | 0.56 | 0.728 | — | — | 0.56 | 0.728 |
| 10 | IF Bandpass Filter | BP1-500+ | 1 | — | — | 0.99 | 1.287 | 0.99 | 1.287 |
| 11 | IF Driver Amplifier | ADA4817-1 | 1 | 0.095 | 0.123 | — | — | 0.095 | 0.123 |
| 12 | Power Supply LDO 5V | LT3045 | 1 | 0.05 | 0.065 | — | — | 0.05 | 0.065 |
| 13 | Power Supply LDO 3.3V | LT3094 | 1 | — | — | 0.033 | 0.043 | 0.033 | 0.043 |
| 14 | Power Supply LDO 1.8V | ADP1741 | 1 | — | — | — | — | — | — |
| | **TOTALS** | |  | **1.13** | **1.469** | **3.828** | **4.974** | **4.958** | **6.443** |

## Power Budget — 2.5 V & 1.8 V Rails

| SI | Description | Part No | Qty | 2.5V TYP (W) | 2.5V MAX (W) | 1.8V TYP (W) | 1.8V MAX (W) | Total TYP (W) | Total MAX (W) |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | RF Input Limiter Protection | LMLPF-BV-0+ | 1 | — | — | — | — | — | — |
| 2 | Wideband Bandpass Filter | VBFZ-5580+ | 1 | — | — | — | — | — | — |
| 3 | Wideband Low Noise Amplifier | TGA4956-SM | 1 | — | — | — | — | — | — |
| 4 | Variable Gain Attenuator | HMC698LP4 | 1 | — | — | — | — | — | — |
| 5 | Wideband Mixer | MAMX-011034 | 1 | — | — | — | — | — | — |
| 6 | Wideband LO Synthesizer | ADF5356 | 1 | — | — | — | — | — | — |
| 7 | 2 GSPS ADC | ADC12DJ3200 | 1 | — | — | — | — | — | — |
| 8 | Low Jitter Clock Generator | LMK04828 | 1 | — | — | — | — | — | — |
| 9 | Wideband LNA Alternative | NC1020-1212 | 1 | — | — | — | — | — | — |
| 10 | IF Bandpass Filter | BP1-500+ | 1 | — | — | — | — | — | — |
| 11 | IF Driver Amplifier | ADA4817-1 | 1 | — | — | — | — | — | — |
| 12 | Power Supply LDO 5V | LT3045 | 1 | — | — | — | — | — | — |
| 13 | Power Supply LDO 3.3V | LT3094 | 1 | — | — | — | — | — | — |
| 14 | Power Supply LDO 1.8V | ADP1741 | 1 | — | — | 0.018 | 0.023 | 0.018 | 0.023 |
| | **TOTALS** | |  | **0.0** | **0.0** | **0.018** | **0.023** | **0.018** | **0.023** |

---

## Power Summary

| Rail | Typical Power (W) | Max Power (W) |
|------|-------------------|---------------|
| 5V | 1.13 | 1.469 |
| 3.3V | 3.828 | 4.974 |
| 2.5V | 0.0 | 0.0 |
| 1.8V | 0.018 | 0.023 |
| **TOTAL** | **4.976** | **6.466** |

> Note: Power values are estimated from component datasheets and design parameters.
> Actual measurements should be taken during hardware bring-up and updated in this table.