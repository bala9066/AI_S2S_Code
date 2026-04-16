# Power Calculation
## j,fj

**Date:** 16-04-2026

> All values in Watts (W). TYP = typical operating power, MAX = worst-case (130% of TYP).
> Rail assignment is based on component operating voltage from BOM.

## Component Power Budget

| # | Component | Part Number | Rail | TYP (W) | MAX (W) |
|---|-----------|-------------|------|----------|----------|
| 1 | Wideband Low Noise Amplifier | HMC1113LP3DE | 3.3V | 0.99 | 1.287 |
| 2 | Wideband Mixer | HMC1056LP4BE | 3.3V | 0.165 | 0.214 |
| 3 | Wideband IF Amplifier | HMC699LP4 | 3.3V | 0.99 | 1.287 |
| 4 | Wideband LO Synthesizer | ADF5356 | 3.3V | 0.165 | 0.214 |
| 5 | 14-bit 4 GSPS ADC | ADC12DJ3200 | 3.3V | 0.165 | 0.214 |
| 6 | Power Management | TPS62913 | 3.3V | 0.033 | 0.043 |
| 7 | ESD Protection Limiter | HMC1061LP3DE | 3.3V | 0.165 | 0.214 |

## Power Summary by Rail

| Rail | Typical Power (W) | Max Power (W) |
|------|-------------------|---------------|
| 5V | 0.0 | 0.0 |
| 3.3V | 2.673 | 3.473 |
| 2.5V | 0.0 | 0.0 |
| 1.8V | 0.0 | 0.0 |
| **TOTAL** | **2.673** | **3.473** |

> Note: Power values are estimated from component datasheets and design parameters.
> Actual measurements should be taken during hardware bring-up and updated in this table.