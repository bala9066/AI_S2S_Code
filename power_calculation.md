# Power Calculation
## ehg

**Date:** 16-04-2026

> All values in Watts (W). TYP = typical operating power, MAX = worst-case (130% of TYP).
> Rail assignment is based on component operating voltage from BOM.

## Component Power Budget

| # | Component | Part Number | Rail | TYP (W) | MAX (W) |
|---|-----------|-------------|------|----------|----------|
| 1 | Wideband LNA 5-18 GHz | HMC8141 | 3.3V | 0.165 | 0.214 |
| 2 | Variable Gain Amplifier | HMC698LP4 | 3.3V | 0.99 | 1.287 |
| 3 | Wideband Mixer | HMC-CMS19 | 3.3V | 0.165 | 0.214 |
| 4 | IF Amplifier | HMC5805 | 3.3V | 0.99 | 1.287 |
| 5 | High-Speed ADC | EV10AQ190A | 3.3V | 0.165 | 0.214 |
| 6 | DC-DC Converter 28V to 5V | PKM4716TCD15 | 5V | 0.05 | 0.065 |
| 7 | LDO Regulator Low Noise | LT3045 | 3.3V | 0.033 | 0.043 |
| 8 | RF Input Connector | 142-0701-851 | 3.3V | 0.99 | 1.287 |
| 9 | Bandpass Filter 5-18 GHz | VBF-1850+ | 3.3V | 0.99 | 1.287 |

## Power Summary by Rail

| Rail | Typical Power (W) | Max Power (W) |
|------|-------------------|---------------|
| 5V | 0.05 | 0.065 |
| 3.3V | 4.488 | 5.833 |
| 2.5V | 0.0 | 0.0 |
| 1.8V | 0.0 | 0.0 |
| **TOTAL** | **4.538** | **5.898** |

> Note: Power values are estimated from component datasheets and design parameters.
> Actual measurements should be taken during hardware bring-up and updated in this table.