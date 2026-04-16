# Power Calculation
## hjgjf

**Date:** 16-04-2026

> All values in Watts (W). TYP = typical operating power, MAX = worst-case (130% of TYP).
> Rail assignment is based on component operating voltage from BOM.

## Power Budget — 5 V & 3.3 V Rails

| SI | Description | Part No | Qty | 5V TYP (W) | 5V MAX (W) | 3.3V TYP (W) | 3.3V MAX (W) | Total TYP (W) | Total MAX (W) |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | Wideband RF Limiter protecting LNA from >+10dBm inputs | Limtrprotect Wideband Limiter | 1 | — | — | 0.99 | 1.287 | 0.99 | 1.287 |
| 2 | Wideband Low Noise Amplifier covering 5-18GHz | HMC1099LP5E | 1 | 1.5 | 1.95 | — | — | 1.5 | 1.95 |
| 3 | High-speed ADC for direct RF sampling 5-18GHz | EV10AQ190A | 1 | — | — | 0.99 | 1.287 | 0.99 | 1.287 |
| 4 | RF Input Connector for 5-18GHz operation | 1492A-10 | 1 | — | — | 0.99 | 1.287 | 0.99 | 1.287 |
| 5 | Clock distribution for low-jitter ADC sampling | HMC7044 | 1 | — | — | 0.165 | 0.214 | 0.165 | 0.214 |
| 6 | LVDS output buffer/driver for ADC data interface | DS90CR486 | 1 | — | — | 0.99 | 1.287 | 0.99 | 1.287 |
| 7 | Multi-rail DC-DC converter for system power distribution | LTM4644 | 1 | — | — | 0.033 | 0.043 | 0.033 | 0.043 |
| 8 | Negative rail generator for analog front-end | LTC1983 | 1 | — | — | 0.165 | 0.214 | 0.165 | 0.214 |
| 9 | Wideband DC blocking capacitor at RF input | 0805HT-200J | 1 | — | — | 0.99 | 1.287 | 0.99 | 1.287 |
| 10 | 5-18GHz bandpass filter (optional, for out-of-band rejection) | BP5-18G-1 | 1 | — | — | 0.99 | 1.287 | 0.99 | 1.287 |
| | **TOTALS** | |  | **1.5** | **1.95** | **6.303** | **8.193** | **7.803** | **10.143** |

---

## Power Summary

| Rail | Typical Power (W) | Max Power (W) |
|------|-------------------|---------------|
| 5V | 1.5 | 1.95 |
| 3.3V | 6.303 | 8.193 |
| 2.5V | 0.0 | 0.0 |
| 1.8V | 0.0 | 0.0 |
| **TOTAL** | **7.803** | **10.143** |

> Note: Power values are estimated from component datasheets and design parameters.
> Actual measurements should be taken during hardware bring-up and updated in this table.