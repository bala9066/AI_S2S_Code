# Power Calculation
## TX Module

**Date:** 14-04-2026

## Power Budget — Per Component Per Rail

> All values in Watts (W). TYP = typical operating power, MAX = worst-case (130% of TYP).
> Rail assignment is based on component operating voltage from BOM.

| SI NO | DESCRIPTION | Package | PART NO | QTY | 5V TYP (W) | 5V MAX (W) | 5V TOT TYP (W) | 5V TOT MAX (W) | 3.3V TYP (W) | 3.3V MAX (W) | 3.3V TOT TYP (W) | 3.3V TOT MAX (W) | 2.5V TYP (W) | 2.5V MAX (W) | 2.5V TOT TYP (W) | 2.5V TOT MAX (W) | 1.8V TYP (W) | 1.8V MAX (W) | 1.8V TOT TYP (W) | 1.8V TOT MAX (W) | TOT MAX POW (W) | TOT TYP POW (W) |
|-------|-------------|---------|---------|---- |-----------|-----------|--------------|--------------| |-----------|-----------|--------------|--------------| |-----------|-----------|--------------|--------------| |-----------|-----------|--------------|--------------|-----------------|-----------------|
| 1 | Bandwidth Mhz | — | 11500 | 1 |  |  |  |  | 0.165 | 0.214 | 0.165 | 0.214 |  |  |  |  |  |  |  |  | 0.214 | 0.165 |
| 2 | Output Connector Type | — | SMP | 1 |  |  |  |  | 0.165 | 0.214 | 0.165 | 0.214 |  |  |  |  |  |  |  |  | 0.214 | 0.165 |
| 3 | ID | — | 200 | 1 |  |  |  |  | 0.165 | 0.214 | 0.165 | 0.214 |  |  |  |  |  |  |  |  | 0.214 | 0.165 |
| 4 | Must have | — | REQ-HW-001 | 1 |  |  |  |  | 0.165 | 0.214 | 0.165 | 0.214 |  |  |  |  |  |  |  |  | 0.214 | 0.165 |
| 5 | Must have | — | REQ-HW-002 | 1 |  |  |  |  | 0.165 | 0.214 | 0.165 | 0.214 |  |  |  |  |  |  |  |  | 0.214 | 0.165 |
| 6 | Must have | — | REQ-HW-003 | 1 |  |  |  |  | 0.165 | 0.214 | 0.165 | 0.214 |  |  |  |  |  |  |  |  | 0.214 | 0.165 |
| 7 | Must have | — | REQ-HW-004 | 1 |  |  |  |  | 0.165 | 0.214 | 0.165 | 0.214 |  |  |  |  |  |  |  |  | 0.214 | 0.165 |
| 8 | Must have | — | REQ-HW-005 | 1 |  |  |  |  | 0.165 | 0.214 | 0.165 | 0.214 |  |  |  |  |  |  |  |  | 0.214 | 0.165 |
| 9 | Must have | — | REQ-HW-006 | 1 |  |  |  |  | 0.165 | 0.214 | 0.165 | 0.214 |  |  |  |  |  |  |  |  | 0.214 | 0.165 |
| 10 | Must have | — | REQ-HW-007 | 1 |  |  |  |  | 0.165 | 0.214 | 0.165 | 0.214 |  |  |  |  |  |  |  |  | 0.214 | 0.165 |
| | **TOTAL** | | |  | | | 0.0 | 0.0 | | | 1.65 | 2.14 | | | 0.0 | 0.0 | | | 0.0 | 0.0 | **2.14** | **1.65** |

---

## Power Summary

| Rail | Typical Power (W) | Max Power (W) |
|------|-------------------|---------------|
| 5V | 0.0 | 0.0 |
| 3.3V | 1.65 | 2.14 |
| 2.5V | 0.0 | 0.0 |
| 1.8V | 0.0 | 0.0 |
| **TOTAL** | **1.65** | **2.14** |

> Note: Power values are estimated from component datasheets and design parameters.
> Actual measurements should be taken during hardware bring-up and updated in this table.