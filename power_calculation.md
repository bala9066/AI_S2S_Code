# Power Calculation
## rx module

**Date:** 17-04-2026

> All values in Watts (W). TYP = typical operating power, MAX = worst-case (130% of TYP).
> Rail assignment is based on component operating voltage from BOM.

## Power Budget — 5 V & 3.3 V Rails

| SI | Description | Part No | Qty | 5V TYP (W) | 5V MAX (W) | 3.3V TYP (W) | 3.3V MAX (W) | Total TYP (W) | Total MAX (W) |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | Wideband Low Noise Amplifier (5-18 GHz) | HMC6180LP4E | 1 | — | — | 0.99 | 1.287 | 0.99 | 1.287 |
| 2 | Variable Gain Amplifier (Manual Gain Control) | HMC698LP4 | 1 | — | — | 0.99 | 1.287 | 0.99 | 1.287 |
| 3 | Mixer for Downconversion | HMC556LC3B | 1 | — | — | 0.165 | 0.214 | 0.165 | 0.214 |
| 4 | IQ Demodulator (Baseband) | ADL5380 | 1 | — | — | 0.165 | 0.214 | 0.165 | 0.214 |
| 5 | Dual High-Speed ADC | AD9208 | 1 | — | — | 0.165 | 0.214 | 0.165 | 0.214 |
| 6 | FPGA for Signal Processing | XCZU9EG-FFVB1156 | 1 | — | — | 1.65 | 2.145 | 1.65 | 2.145 |
| 7 | DC-DC Converter 12V to 3.3V/5V/7V | LTM4644 | 1 | 20.0 | 26.0 | — | — | 20.0 | 26.0 |
| 8 | RF Input SMA Connector | 142-0701-851 | 1 | — | — | 0.99 | 1.287 | 0.99 | 1.287 |
| 9 | Bandpass Filter 5-18 GHz | BP5G18G-4500-C4 | 1 | — | — | 0.99 | 1.287 | 0.99 | 1.287 |
| | **TOTALS** | |  | **20.0** | **26.0** | **6.105** | **7.935** | **26.105** | **33.935** |

---

## Power Summary

| Rail | Typical Power (W) | Max Power (W) |
|------|-------------------|---------------|
| 5V | 20.0 | 26.0 |
| 3.3V | 6.105 | 7.935 |
| 2.5V | 0.0 | 0.0 |
| 1.8V | 0.0 | 0.0 |
| **TOTAL** | **26.105** | **33.935** |

> Note: Power values are estimated from component datasheets and design parameters.
> Actual measurements should be taken during hardware bring-up and updated in this table.