# Power Calculation
## dgh

**Date:** 19-04-2026

> All values in Watts (W). TYP = typical operating power, MAX = worst-case (130% of TYP).
> Rail assignment is based on component operating voltage from BOM.

## Power Budget — 5 V & 3.3 V Rails

| SI | Description | Part No | Qty | 5V TYP (W) | 5V MAX (W) | 3.3V TYP (W) | 3.3V MAX (W) | Total TYP (W) | Total MAX (W) |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | High Power Limiter | MACOM MADL-011017 | 1 | — | — | 0.033 | 0.043 | 0.033 | 0.043 |
| 2 | SAW Pre-select Filter | SAW-518-HP | 1 | — | — | 0.165 | 0.214 | 0.165 | 0.214 |
| 3 | GaN HEMT LNA | QPL9057 | 1 | — | — | 0.165 | 0.214 | 0.165 | 0.214 |
| 4 | LNA Driver Stage | ADL5545 | 1 | — | — | 0.165 | 0.214 | 0.165 | 0.214 |
| 5 | Output Buffer | MGA-68563 | 1 | — | — | 0.165 | 0.214 | 0.165 | 0.214 |
| 6 | Power Management | LT3636 | 1 | — | — | 0.033 | 0.043 | 0.033 | 0.043 |
| 7 | Control Interface | MCP23017 | 1 | — | — | 0.99 | 1.287 | 0.99 | 1.287 |
| 8 | RF Connectors | SMA-50-CLS | 1 | — | — | 0.99 | 1.287 | 0.99 | 1.287 |
| 9 | Heat Sink | Aavid 7021BG | 1 | — | — | 0.165 | 0.214 | 0.165 | 0.214 |
| | **TOTALS** | |  | **0.0** | **0.0** | **2.871** | **3.73** | **2.871** | **3.73** |

---

## Power Summary

| Rail | Typical Power (W) | Max Power (W) |
|------|-------------------|---------------|
| 5V | 0.0 | 0.0 |
| 3.3V | 2.871 | 3.73 |
| 2.5V | 0.0 | 0.0 |
| 1.8V | 0.0 | 0.0 |
| **TOTAL** | **2.871** | **3.73** |

> Note: Power values are estimated from component datasheets and design parameters.
> Actual measurements should be taken during hardware bring-up and updated in this table.