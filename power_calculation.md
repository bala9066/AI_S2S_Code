# Power Calculation
## ajsfdvhjs

**Date:** 15-04-2026

## Power Budget — Per Component Per Rail

> All values in Watts (W). TYP = typical operating power, MAX = worst-case (130% of TYP).
> Rail assignment is based on component operating voltage from BOM.

| SI NO | DESCRIPTION | Package | PART NO | QTY | 5V TYP (W) | 5V MAX (W) | 5V TOT TYP (W) | 5V TOT MAX (W) | 3.3V TYP (W) | 3.3V MAX (W) | 3.3V TOT TYP (W) | 3.3V TOT MAX (W) | 2.5V TYP (W) | 2.5V MAX (W) | 2.5V TOT TYP (W) | 2.5V TOT MAX (W) | 1.8V TYP (W) | 1.8V MAX (W) | 1.8V TOT TYP (W) | 1.8V TOT MAX (W) | TOT MAX POW (W) | TOT TYP POW (W) |
|-------|-------------|---------|---------|---- |-----------|-----------|--------------|--------------| |-----------|-----------|--------------|--------------| |-----------|-----------|--------------|--------------| |-----------|-----------|--------------|--------------|-----------------|-----------------|
| 1 | Wideband RF Mixer for downconversion | — | HMC1048LP4BE | 1 |  |  |  |  | 0.99 | 1.287 | 0.99 | 1.287 |  |  |  |  |  |  |  |  | 1.287 | 0.99 |
| 2 | Wideband LNA - Initial gain stage | — | TGA4943-SL | 1 |  |  |  |  | 0.165 | 0.214 | 0.165 | 0.214 |  |  |  |  |  |  |  |  | 0.214 | 0.165 |
| 3 | Wideband Integrated Receiver (Mixer + IF Amp + IQ Demod) | — | HMC1119LP4ME | 1 |  |  |  |  | 0.165 | 0.214 | 0.165 | 0.214 |  |  |  |  |  |  |  |  | 0.214 | 0.165 |
| 4 | Wideband Frequency Synthesizer (LO Generation) | — | ADF5356 | 1 |  |  |  |  | 0.165 | 0.214 | 0.165 | 0.214 |  |  |  |  |  |  |  |  | 0.214 | 0.165 |
| 5 | Dual/Quad Channel ADC for I/Q digitization | — | AD9208 | 1 |  |  |  |  | 0.165 | 0.214 | 0.165 | 0.214 |  |  |  |  |  |  |  |  | 0.214 | 0.165 |
| 6 | Power Management - Buck Converter | — | LT8645S | 1 |  |  |  |  | 0.033 | 0.043 | 0.033 | 0.043 |  |  |  |  |  |  |  |  | 0.043 | 0.033 |
| 7 | Control MCU | — | STM32H743 | 1 |  |  |  |  | 0.495 | 0.643 | 0.495 | 0.643 |  |  |  |  |  |  |  |  | 0.643 | 0.495 |
| 8 | RF Input Connector | — | 142-0701-851 | 1 |  |  |  |  | 0.99 | 1.287 | 0.99 | 1.287 |  |  |  |  |  |  |  |  | 1.287 | 0.99 |
| | **TOTAL** | | |  | | | 0.0 | 0.0 | | | 3.168 | 4.116 | | | 0.0 | 0.0 | | | 0.0 | 0.0 | **4.116** | **3.168** |

---

## Power Summary

| Rail | Typical Power (W) | Max Power (W) |
|------|-------------------|---------------|
| 5V | 0.0 | 0.0 |
| 3.3V | 3.168 | 4.116 |
| 2.5V | 0.0 | 0.0 |
| 1.8V | 0.0 | 0.0 |
| **TOTAL** | **3.168** | **4.116** |

> Note: Power values are estimated from component datasheets and design parameters.
> Actual measurements should be taken during hardware bring-up and updated in this table.