# Power Calculation
## sample rf

**Date:** 16-04-2026

> All values in Watts (W). TYP = typical operating power, MAX = worst-case (130% of TYP).
> Rail assignment is based on component operating voltage from BOM.

## Power Budget — 5 V & 3.3 V Rails

| SI | Description | Part No | Qty | 5V TYP (W) | 5V MAX (W) | 3.3V TYP (W) | 3.3V MAX (W) | Total TYP (W) | Total MAX (W) |
|----|-------------|---------|---- |-----------|-----------| |-----------|-----------|---------------|---------------|
| 1 | Wideband Low Noise Amplifier (LNA) - Front-end gain stage with low noise figure | HMC698LP4 | 1 | — | — | 0.99 | 1.287 | 0.99 | 1.287 |
| 2 | Wideband Mixer - RF downconverter for frequency translation | HMC1119LP4 | 1 | — | — | 0.99 | 1.287 | 0.99 | 1.287 |
| 3 | IF Amplifier - Intermediate frequency gain stage | ADA4817-1 | 1 | — | — | 0.99 | 1.287 | 0.99 | 1.287 |
| 4 | High-Speed ADC - Digitizer for baseband IQ conversion | ADC12J4000 | 1 | — | — | 0.165 | 0.214 | 0.165 | 0.214 |
| 5 | Wideband Bandpass Filter - Input filtering for 5-18 GHz | BP0650-18-10-S1 | 1 | — | — | 0.99 | 1.287 | 0.99 | 1.287 |
| 6 | Power Management - Voltage regulation for 5-12V input | LTM4650 | 1 | — | — | 0.033 | 0.043 | 0.033 | 0.043 |
| 7 | RF Connector - SMA input connector for 5-18 GHz | 142-0701-851 | 1 | — | — | 0.99 | 1.287 | 0.99 | 1.287 |
| | **TOTALS** | |  | **0.0** | **0.0** | **5.148** | **6.692** | **5.148** | **6.692** |

## Power Budget — 2.5 V & 1.8 V Rails

| SI | Description | Part No | Qty | 2.5V TYP (W) | 2.5V MAX (W) | 1.8V TYP (W) | 1.8V MAX (W) | Total TYP (W) | Total MAX (W) |
|----|-------------|---------|---- |-----------|-----------| |-----------|-----------|---------------|---------------|
| 1 | Wideband Low Noise Amplifier (LNA) - Front-end gain stage with low noise figure | HMC698LP4 | 1 | — | — | — | — | — | — |
| 2 | Wideband Mixer - RF downconverter for frequency translation | HMC1119LP4 | 1 | — | — | — | — | — | — |
| 3 | IF Amplifier - Intermediate frequency gain stage | ADA4817-1 | 1 | — | — | — | — | — | — |
| 4 | High-Speed ADC - Digitizer for baseband IQ conversion | ADC12J4000 | 1 | — | — | — | — | — | — |
| 5 | Wideband Bandpass Filter - Input filtering for 5-18 GHz | BP0650-18-10-S1 | 1 | — | — | — | — | — | — |
| 6 | Power Management - Voltage regulation for 5-12V input | LTM4650 | 1 | — | — | — | — | — | — |
| 7 | RF Connector - SMA input connector for 5-18 GHz | 142-0701-851 | 1 | — | — | — | — | — | — |
| | **TOTALS** | |  | **0.0** | **0.0** | **0.0** | **0.0** | **0.0** | **0.0** |

---

## Power Summary

| Rail | Typical Power (W) | Max Power (W) |
|------|-------------------|---------------|
| 5V | 0.0 | 0.0 |
| 3.3V | 5.148 | 6.692 |
| 2.5V | 0.0 | 0.0 |
| 1.8V | 0.0 | 0.0 |
| **TOTAL** | **5.148** | **6.692** |

> Note: Power values are estimated from component datasheets and design parameters.
> Actual measurements should be taken during hardware bring-up and updated in this table.