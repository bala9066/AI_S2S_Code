# Power Calculation
## rbhjdaz

**Date:** 14-04-2026

## Power Budget — Per Component Per Rail

> All values in Watts (W). TYP = typical operating power, MAX = worst-case (130% of TYP).
> Rail assignment is based on component operating voltage from BOM.

| SI NO | DESCRIPTION | Package | PART NO | QTY | 5V TYP (W) | 5V MAX (W) | 5V TOT TYP (W) | 5V TOT MAX (W) | 3.3V TYP (W) | 3.3V MAX (W) | 3.3V TOT TYP (W) | 3.3V TOT MAX (W) | 2.5V TYP (W) | 2.5V MAX (W) | 2.5V TOT TYP (W) | 2.5V TOT MAX (W) | 1.8V TYP (W) | 1.8V MAX (W) | 1.8V TOT TYP (W) | 1.8V TOT MAX (W) | TOT MAX POW (W) | TOT TYP POW (W) |
|-------|-------------|---------|---------|---- |-----------|-----------|--------------|--------------| |-----------|-----------|--------------|--------------| |-----------|-----------|--------------|--------------| |-----------|-----------|--------------|--------------|-----------------|-----------------|
| 1 | RF Input Limiter | — | RFLM5012-10 | 1 |  |  |  |  | 0.99 | 1.287 | 0.99 | 1.287 |  |  |  |  |  |  |  |  | 1.287 | 0.99 |
| 2 | Wideband Low Noise Amplifier | — | TGA4537-SM | 1 |  |  |  |  | 0.99 | 1.287 | 0.99 | 1.287 |  |  |  |  |  |  |  |  | 1.287 | 0.99 |
| 3 | Variable Gain Amplifier (RF) | — | HMC698LP4 | 1 |  |  |  |  | 0.99 | 1.287 | 0.99 | 1.287 |  |  |  |  |  |  |  |  | 1.287 | 0.99 |
| 4 | Wideband Mixer | — | ADL5802 | 1 |  |  |  |  | 0.165 | 0.214 | 0.165 | 0.214 |  |  |  |  |  |  |  |  | 0.214 | 0.165 |
| 5 | LO Synthesizer / PLL | — | ADF5355 | 1 |  |  |  |  | 0.165 | 0.214 | 0.165 | 0.214 |  |  |  |  |  |  |  |  | 0.214 | 0.165 |
| 6 | Dual ADC 12-bit | — | ADC12DJ3200 | 1 |  |  |  |  | 0.165 | 0.214 | 0.165 | 0.214 |  |  |  |  |  |  |  |  | 0.214 | 0.165 |
| 7 | MCU Controller | LQFP-100 | STM32H753VI | 1 |  |  |  |  | 0.495 | 0.643 | 0.495 | 0.643 |  |  |  |  |  |  |  |  | 0.643 | 0.495 |
| 8 | DC-DC Converter 28V to 12V | — | VPT25-28-28-12-5-P | 1 |  |  |  |  | 0.033 | 0.043 | 0.033 | 0.043 |  |  |  |  |  |  |  |  | 0.043 | 0.033 |
| 9 | Selectable Bandpass Filters | — | BP Series Custom | 1 |  |  |  |  | 0.99 | 1.287 | 0.99 | 1.287 |  |  |  |  |  |  |  |  | 1.287 | 0.99 |
| | **TOTAL** | | |  | | | 0.0 | 0.0 | | | 4.983 | 6.476 | | | 0.0 | 0.0 | | | 0.0 | 0.0 | **6.476** | **4.983** |

---

## Power Summary

| Rail | Typical Power (W) | Max Power (W) |
|------|-------------------|---------------|
| 5V | 0.0 | 0.0 |
| 3.3V | 4.983 | 6.476 |
| 2.5V | 0.0 | 0.0 |
| 1.8V | 0.0 | 0.0 |
| **TOTAL** | **4.983** | **6.476** |

> Note: Power values are estimated from component datasheets and design parameters.
> Actual measurements should be taken during hardware bring-up and updated in this table.