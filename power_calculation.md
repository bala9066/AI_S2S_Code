# Power Calculation
## hkgg

**Date:** 05-04-2026

## Power Budget — Per Component Per Rail

> All values in Watts (W). TYP = typical operating power, MAX = worst-case (130% of TYP).
> Rail assignment is based on component operating voltage from BOM.

| SI NO | DESCRIPTION | Package | PART NO | QTY | 5V TYP (W) | 5V MAX (W) | 5V TOT TYP (W) | 5V TOT MAX (W) | 3.3V TYP (W) | 3.3V MAX (W) | 3.3V TOT TYP (W) | 3.3V TOT MAX (W) | 2.5V TYP (W) | 2.5V MAX (W) | 2.5V TOT TYP (W) | 2.5V TOT MAX (W) | 1.8V TYP (W) | 1.8V MAX (W) | 1.8V TOT TYP (W) | 1.8V TOT MAX (W) | TOT MAX POW (W) | TOT TYP POW (W) |
|-------|-------------|---------|---------|---- |-----------|-----------|--------------|--------------| |-----------|-----------|--------------|--------------| |-----------|-----------|--------------|--------------| |-----------|-----------|--------------|--------------|-----------------|-----------------|
| 1 | Driver Amplifier (20dB gain, 50-500MHz, +12V supply) | SOT-89 | GVA-123+ | 1 |  |  |  |  | 0.297 | 0.386 | 0.297 | 0.386 |  |  |  |  |  |  |  |  | 0.386 | 0.297 |
| 2 | Final Power Amplifier (10W, 40dBm PSAT, 50-500MHz) | Flange mount with thermal pad | MGA-21063 | 1 |  |  |  |  | 0.99 | 1.287 | 0.99 | 1.287 |  |  |  |  |  |  |  |  | 1.287 | 0.99 |
| 3 | Output Power Transistor (LDMOS 12V, 10W, 50-500MHz) - CORRECTED PRIMARY | NI-1230 (flange mount) | MRF1511G | 1 |  |  |  |  | 0.033 | 0.043 | 0.033 | 0.043 |  |  |  |  |  |  |  |  | 0.043 | 0.033 |
| 4 | Bias Controller / Gate Reference | SOT-23 | MAX1167 | 1 |  |  |  |  | 0.165 | 0.214 | 0.165 | 0.214 |  |  |  |  |  |  |  |  | 0.214 | 0.165 |
| 5 | Gate Bias MOSFET Switch (Enable Control) | SOT-23 | IRLML6402 | 1 |  |  |  |  | 0.165 | 0.214 | 0.165 | 0.214 |  |  |  |  |  |  |  |  | 0.214 | 0.165 |
| 6 | RF Input SMA Connector | SMA jack | 142-0701-851 | 1 |  |  |  |  | 0.99 | 1.287 | 0.99 | 1.287 |  |  |  |  |  |  |  |  | 1.287 | 0.99 |
| 7 | RF Output SMA Connector | SMA jack | 142-0701-851 | 1 |  |  |  |  | 0.99 | 1.287 | 0.99 | 1.287 |  |  |  |  |  |  |  |  | 1.287 | 0.99 |
| 8 | EMI Input Filter + Reverse Protection | SMT (10x12x5mm) | B82786C0113N201 | 1 |  |  |  |  | 13.2 | 17.16 | 13.2 | 17.16 |  |  |  |  |  |  |  |  | 17.16 | 13.2 |
| 9 | 3.5A Fuse Holder + Fuse | SMT holder + 5x20mm fuse | 0217005.HXP | 1 |  |  |  |  | 0.165 | 0.214 | 0.165 | 0.214 |  |  |  |  |  |  |  |  | 0.214 | 0.165 |
| 10 | DC Power Input Terminal | — | 1985804 | 1 | 3200.0 | 4160.0 | 3200.0 | 4160.0 |  |  |  |  |  |  |  |  |  |  |  |  | 4160.0 | 3200.0 |
| | **TOTAL** | | |  | | | 3200.0 | 4160.0 | | | 16.995 | 22.092 | | | 0.0 | 0.0 | | | 0.0 | 0.0 | **4182.092** | **3216.995** |

---

## Power Summary

| Rail | Typical Power (W) | Max Power (W) |
|------|-------------------|---------------|
| 5V | 3200.0 | 4160.0 |
| 3.3V | 16.995 | 22.092 |
| 2.5V | 0.0 | 0.0 |
| 1.8V | 0.0 | 0.0 |
| **TOTAL** | **3216.995** | **4182.092** |

> Note: Power values are estimated from component datasheets and design parameters.
> Actual measurements should be taken during hardware bring-up and updated in this table.