# Power Calculation
## Rf Receiver

**Date:** 17-04-2026

> All values in Watts (W). TYP = typical operating power, MAX = worst-case (130% of TYP).
> Rail assignment is based on component operating voltage from BOM.

## Power Budget — 5 V & 3.3 V Rails

| SI | Description | Part No | Qty | 5V TYP (W) | 5V MAX (W) | 3.3V TYP (W) | 3.3V MAX (W) | Total TYP (W) | Total MAX (W) |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | Wideband LNA 5-18 GHz with low noise figure | AMMC-6241 | 1 | 0.25 | 0.325 | — | — | 0.25 | 0.325 |
| 2 | Driver amplifier for gain boost and output drive | GVA-164+ | 1 | 2.4 | 3.12 | — | — | 2.4 | 3.12 |
| 3 | RF input limiter for protection to +10 dBm | VLVA-300-44 | 1 | — | — | 0.99 | 1.287 | 0.99 | 1.287 |
| 4 | Voltage regulator for 12V to 5V/8V conversion | LM22676-5.0 | 1 | 0.05 | 0.065 | — | — | 0.05 | 0.065 |
| 5 | RF connectors for input and output | 142-0701-851 | 1 | — | — | 0.99 | 1.287 | 0.99 | 1.287 |
| 6 | DC power connector for military applications | DPX series MIL-DTL-38999 | 1 | — | — | 0.033 | 0.043 | 0.033 | 0.043 |
| 7 | EMI filter for power input | RCEP602A-241 | 1 | — | — | 0.033 | 0.043 | 0.033 | 0.043 |
| | **TOTALS** | |  | **2.7** | **3.51** | **2.046** | **2.66** | **4.746** | **6.17** |

---

## Power Summary

| Rail | Typical Power (W) | Max Power (W) |
|------|-------------------|---------------|
| 5V | 2.7 | 3.51 |
| 3.3V | 2.046 | 2.66 |
| 2.5V | 0.0 | 0.0 |
| 1.8V | 0.0 | 0.0 |
| **TOTAL** | **4.746** | **6.17** |

> Note: Power values are estimated from component datasheets and design parameters.
> Actual measurements should be taken during hardware bring-up and updated in this table.