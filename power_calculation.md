# Power Calculation
## dkfjg

**Date:** 16-04-2026

> All values in Watts (W). TYP = typical operating power, MAX = worst-case (130% of TYP).
> Rail assignment is based on component operating voltage from BOM.

## Power Budget — 5 V & 3.3 V Rails

| SI | Description | Part No | Qty | 5V TYP (W) | 5V MAX (W) | 3.3V TYP (W) | 3.3V MAX (W) | Total TYP (W) | Total MAX (W) |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | Wideband Low Noise Amplifier (5-18 GHz) | HMC1042LP4BE | 1 | 1.5 | 1.95 | — | — | 1.5 | 1.95 |
| 2 | Variable Gain Amplifier (5-18 GHz) | HMC698LP4 | 1 | 1.5 | 1.95 | — | — | 1.5 | 1.95 |
| 3 | Bandpass Filter (5-18 GHz) | CBP-1810-LF | 1 | — | — | 0.99 | 1.287 | 0.99 | 1.287 |
| 4 | Mixer for Downconversion | HMC774A | 1 | 0.25 | 0.325 | — | — | 0.25 | 0.325 |
| 5 | High-Speed ADC with LVDS Output | ADC12J4000 | 1 | — | — | 0.165 | 0.214 | 0.165 | 0.214 |
| 6 | Power Management - 12V to 5V/3.3V | LTM4644 | 1 | 0.05 | 0.065 | — | — | 0.05 | 0.065 |
| 7 | Low-Noise LDO for Analog Front-End | LT3045 | 1 | — | — | 0.033 | 0.043 | 0.033 | 0.043 |
| 8 | RF Input Connector (18 GHz) | 142-0701-801 | 1 | — | — | 0.99 | 1.287 | 0.99 | 1.287 |
| 9 | DC Block Capacitor Array | 1111-300K1-102 | 1 | — | — | 0.99 | 1.287 | 0.99 | 1.287 |
| | **TOTALS** | |  | **3.3** | **4.29** | **3.168** | **4.118** | **6.468** | **8.408** |

## Power Budget — 2.5 V & 1.8 V Rails

| SI | Description | Part No | Qty | 2.5V TYP (W) | 2.5V MAX (W) | 1.8V TYP (W) | 1.8V MAX (W) | Total TYP (W) | Total MAX (W) |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | Wideband Low Noise Amplifier (5-18 GHz) | HMC1042LP4BE | 1 | — | — | — | — | — | — |
| 2 | Variable Gain Amplifier (5-18 GHz) | HMC698LP4 | 1 | — | — | — | — | — | — |
| 3 | Bandpass Filter (5-18 GHz) | CBP-1810-LF | 1 | — | — | — | — | — | — |
| 4 | Mixer for Downconversion | HMC774A | 1 | — | — | — | — | — | — |
| 5 | High-Speed ADC with LVDS Output | ADC12J4000 | 1 | — | — | — | — | — | — |
| 6 | Power Management - 12V to 5V/3.3V | LTM4644 | 1 | — | — | — | — | — | — |
| 7 | Low-Noise LDO for Analog Front-End | LT3045 | 1 | — | — | — | — | — | — |
| 8 | RF Input Connector (18 GHz) | 142-0701-801 | 1 | — | — | — | — | — | — |
| 9 | DC Block Capacitor Array | 1111-300K1-102 | 1 | — | — | — | — | — | — |
| | **TOTALS** | |  | **0.0** | **0.0** | **0.0** | **0.0** | **0.0** | **0.0** |

---

## Power Summary

| Rail | Typical Power (W) | Max Power (W) |
|------|-------------------|---------------|
| 5V | 3.3 | 4.29 |
| 3.3V | 3.168 | 4.118 |
| 2.5V | 0.0 | 0.0 |
| 1.8V | 0.0 | 0.0 |
| **TOTAL** | **6.468** | **8.408** |

> Note: Power values are estimated from component datasheets and design parameters.
> Actual measurements should be taken during hardware bring-up and updated in this table.