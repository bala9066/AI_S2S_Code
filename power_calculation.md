# Power Calculation
## mn

**Date:** 17-04-2026

> All values in Watts (W). TYP = typical operating power, MAX = worst-case (130% of TYP).
> Rail assignment is based on component operating voltage from BOM.

## Power Budget — 5 V & 3.3 V Rails

| SI | Description | Part No | Qty | 5V TYP (W) | 5V MAX (W) | 3.3V TYP (W) | 3.3V MAX (W) | Total TYP (W) | Total MAX (W) |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | Wideband LNA 5-18 GHz | HMC698LP4(E) | 1 | — | — | 0.165 | 0.214 | 0.165 | 0.214 |
| 2 | Variable Gain Amplifier IF/RF | ADL5330 | 1 | — | — | 0.99 | 1.287 | 0.99 | 1.287 |
| 3 | RF Mixer Downconverter | HMC521LC4 | 1 | — | — | 0.99 | 1.287 | 0.99 | 1.287 |
| 4 | High Speed ADC 1-10 Gsps | ADC10D1000 | 1 | — | — | 0.165 | 0.214 | 0.165 | 0.214 |
| 5 | FPGA Signal Processing | XCZU4EV-SFVC784 | 1 | — | — | 1.65 | 2.145 | 1.65 | 2.145 |
| 6 | Gigabit Ethernet PHY | VSC8522 | 1 | — | — | 0.165 | 0.214 | 0.165 | 0.214 |
| 7 | 3.3V LDO Regulator | TPS7A4700 | 1 | — | — | 0.033 | 0.043 | 0.033 | 0.043 |
| 8 | 1.8V LDO Regulator | LT3045 | 1 | — | — | — | — | — | — |
| 9 | RF Input Connector | 149-1011-801 | 1 | — | — | 0.99 | 1.287 | 0.99 | 1.287 |
| | **TOTALS** | |  | **0.0** | **0.0** | **5.148** | **6.691** | **5.148** | **6.691** |

## Power Budget — 2.5 V & 1.8 V Rails

| SI | Description | Part No | Qty | 2.5V TYP (W) | 2.5V MAX (W) | 1.8V TYP (W) | 1.8V MAX (W) | Total TYP (W) | Total MAX (W) |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | Wideband LNA 5-18 GHz | HMC698LP4(E) | 1 | — | — | — | — | — | — |
| 2 | Variable Gain Amplifier IF/RF | ADL5330 | 1 | — | — | — | — | — | — |
| 3 | RF Mixer Downconverter | HMC521LC4 | 1 | — | — | — | — | — | — |
| 4 | High Speed ADC 1-10 Gsps | ADC10D1000 | 1 | — | — | — | — | — | — |
| 5 | FPGA Signal Processing | XCZU4EV-SFVC784 | 1 | — | — | — | — | — | — |
| 6 | Gigabit Ethernet PHY | VSC8522 | 1 | — | — | — | — | — | — |
| 7 | 3.3V LDO Regulator | TPS7A4700 | 1 | — | — | — | — | — | — |
| 8 | 1.8V LDO Regulator | LT3045 | 1 | — | — | 0.018 | 0.023 | 0.018 | 0.023 |
| 9 | RF Input Connector | 149-1011-801 | 1 | — | — | — | — | — | — |
| | **TOTALS** | |  | **0.0** | **0.0** | **0.018** | **0.023** | **0.018** | **0.023** |

---

## Power Summary

| Rail | Typical Power (W) | Max Power (W) |
|------|-------------------|---------------|
| 5V | 0.0 | 0.0 |
| 3.3V | 5.148 | 6.691 |
| 2.5V | 0.0 | 0.0 |
| 1.8V | 0.018 | 0.023 |
| **TOTAL** | **5.166** | **6.714** |

> Note: Power values are estimated from component datasheets and design parameters.
> Actual measurements should be taken during hardware bring-up and updated in this table.