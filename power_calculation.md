# Power Calculation
## rf txrxxp

**Date:** 14-04-2026

## Power Budget — Per Component Per Rail

> All values in Watts (W). TYP = typical operating power, MAX = worst-case (130% of TYP).
> Rail assignment is based on component operating voltage from BOM.

| SI NO | DESCRIPTION | Package | PART NO | QTY | 5V TYP (W) | 5V MAX (W) | 5V TOT TYP (W) | 5V TOT MAX (W) | 3.3V TYP (W) | 3.3V MAX (W) | 3.3V TOT TYP (W) | 3.3V TOT MAX (W) | 2.5V TYP (W) | 2.5V MAX (W) | 2.5V TOT TYP (W) | 2.5V TOT MAX (W) | 1.8V TYP (W) | 1.8V MAX (W) | 1.8V TOT TYP (W) | 1.8V TOT MAX (W) | TOT MAX POW (W) | TOT TYP POW (W) |
|-------|-------------|---------|---------|---- |-----------|-----------|--------------|--------------| |-----------|-----------|--------------|--------------| |-----------|-----------|--------------|--------------| |-----------|-----------|--------------|--------------|-----------------|-----------------|
| 1 | Input Limiter Protection | — | Limiter SPDT GVA-123+ | 1 |  |  |  |  | 0.165 | 0.214 | 0.165 | 0.214 |  |  |  |  |  |  |  |  | 0.214 | 0.165 |
| 2 | Wideband LNA | — | MMIC Amplifier TQP3M9036 | 1 |  |  |  |  | 0.165 | 0.214 | 0.165 | 0.214 |  |  |  |  |  |  |  |  | 0.214 | 0.165 |
| 3 | Variable Gain Amplifier | — | HMC698LP4 | 1 |  |  |  |  | 0.99 | 1.287 | 0.99 | 1.287 |  |  |  |  |  |  |  |  | 1.287 | 0.99 |
| 4 | Mixer / Downconverter | — | HMC1050 | 1 |  |  |  |  | 0.165 | 0.214 | 0.165 | 0.214 |  |  |  |  |  |  |  |  | 0.214 | 0.165 |
| 5 | LO Synthesizer | — | ADF5356 | 1 |  |  |  |  | 0.165 | 0.214 | 0.165 | 0.214 |  |  |  |  |  |  |  |  | 0.214 | 0.165 |
| 6 | IF Amplifier | — | ADL8000 | 1 |  |  |  |  | 0.99 | 1.287 | 0.99 | 1.287 |  |  |  |  |  |  |  |  | 1.287 | 0.99 |
| 7 | High-Speed ADC | — | ADC12DJ3200 | 1 |  |  |  |  | 0.165 | 0.214 | 0.165 | 0.214 |  |  |  |  |  |  |  |  | 0.214 | 0.165 |
| 8 | Clock Generator / Jitter Cleaner | — | LMK04828 | 1 |  |  |  |  | 0.165 | 0.214 | 0.165 | 0.214 |  |  |  |  |  |  |  |  | 0.214 | 0.165 |
| 9 | Power Management | — | LTM4644 | 1 |  |  |  |  | 0.033 | 0.043 | 0.033 | 0.043 |  |  |  |  |  |  |  |  | 0.043 | 0.033 |
| 10 | RF Input Connector | — | SMA Connector 2.4mm | 1 |  |  |  |  | 0.99 | 1.287 | 0.99 | 1.287 |  |  |  |  |  |  |  |  | 1.287 | 0.99 |
| | **TOTAL** | | |  | | | 0.0 | 0.0 | | | 3.993 | 5.188 | | | 0.0 | 0.0 | | | 0.0 | 0.0 | **5.188** | **3.993** |

---

## Power Summary

| Rail | Typical Power (W) | Max Power (W) |
|------|-------------------|---------------|
| 5V | 0.0 | 0.0 |
| 3.3V | 3.993 | 5.188 |
| 2.5V | 0.0 | 0.0 |
| 1.8V | 0.0 | 0.0 |
| **TOTAL** | **3.993** | **5.188** |

> Note: Power values are estimated from component datasheets and design parameters.
> Actual measurements should be taken during hardware bring-up and updated in this table.