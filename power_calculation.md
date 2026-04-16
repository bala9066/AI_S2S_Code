# Power Calculation
## Sample Ai Project

**Date:** 16-04-2026

> All values in Watts (W). TYP = typical operating power, MAX = worst-case (130% of TYP).
> Rail assignment is based on component operating voltage from BOM.

## Power Budget — 5 V & 3.3 V Rails

| SI | Description | Part No | Qty | 5V TYP (W) | 5V MAX (W) | 3.3V TYP (W) | 3.3V MAX (W) | Total TYP (W) | Total MAX (W) |
|----|-------------|---------|---- |-----------|-----------| |-----------|-----------|---------------|---------------|
| 1 | Wideband Low Noise Amplifier (5-18 GHz) | TGA4943-SL | 1 | 0.45 | 0.585 | — | — | 0.45 | 0.585 |
| 2 | Digital Variable Gain Amplifier / DSA (5-18 GHz) | HMC698LP4E | 1 | — | — | 0.99 | 1.287 | 0.99 | 1.287 |
| 3 | 5-18 GHz Bandpass Filter | CBP-1850+ | 1 | — | — | 0.99 | 1.287 | 0.99 | 1.287 |
| 4 | High-Speed ADC (5-10 GSPS) | ADC10D1000RF | 1 | — | — | 0.165 | 0.214 | 0.165 | 0.214 |
| 5 | Radiation-Tolerant FPGA | RTVirtex5QV | 1 | — | — | 1.65 | 2.145 | 1.65 | 2.145 |
| 6 | Low-Jitter Clock Generator/Distribution | HMC7044 | 1 | — | — | 0.165 | 0.214 | 0.165 | 0.214 |
| 7 | Military-Grade DC-DC Converter (12V to 5V Rail) | VPT/DCDV1-28-5 | 1 | 0.05 | 0.065 | — | — | 0.05 | 0.065 |
| 8 | Point-of-Load DC-DC Converter (FPGA Rails) | LTM4644 | 1 | — | — | 1.65 | 2.145 | 1.65 | 2.145 |
| 9 | RF Input Connector (SMA, 18 GHz) | 142-0701-851 | 1 | — | — | 0.99 | 1.287 | 0.99 | 1.287 |
| 10 | FPGA Configuration Memory (Military) | S29GL01GS | 1 | — | — | 1.65 | 2.145 | 1.65 | 2.145 |
| | **TOTALS** | |  | **0.5** | **0.65** | **8.25** | **10.724** | **8.75** | **11.374** |

## Power Budget — 2.5 V & 1.8 V Rails

| SI | Description | Part No | Qty | 2.5V TYP (W) | 2.5V MAX (W) | 1.8V TYP (W) | 1.8V MAX (W) | Total TYP (W) | Total MAX (W) |
|----|-------------|---------|---- |-----------|-----------| |-----------|-----------|---------------|---------------|
| 1 | Wideband Low Noise Amplifier (5-18 GHz) | TGA4943-SL | 1 | — | — | — | — | — | — |
| 2 | Digital Variable Gain Amplifier / DSA (5-18 GHz) | HMC698LP4E | 1 | — | — | — | — | — | — |
| 3 | 5-18 GHz Bandpass Filter | CBP-1850+ | 1 | — | — | — | — | — | — |
| 4 | High-Speed ADC (5-10 GSPS) | ADC10D1000RF | 1 | — | — | — | — | — | — |
| 5 | Radiation-Tolerant FPGA | RTVirtex5QV | 1 | — | — | — | — | — | — |
| 6 | Low-Jitter Clock Generator/Distribution | HMC7044 | 1 | — | — | — | — | — | — |
| 7 | Military-Grade DC-DC Converter (12V to 5V Rail) | VPT/DCDV1-28-5 | 1 | — | — | — | — | — | — |
| 8 | Point-of-Load DC-DC Converter (FPGA Rails) | LTM4644 | 1 | — | — | — | — | — | — |
| 9 | RF Input Connector (SMA, 18 GHz) | 142-0701-851 | 1 | — | — | — | — | — | — |
| 10 | FPGA Configuration Memory (Military) | S29GL01GS | 1 | — | — | — | — | — | — |
| | **TOTALS** | |  | **0.0** | **0.0** | **0.0** | **0.0** | **0.0** | **0.0** |

---

## Power Summary

| Rail | Typical Power (W) | Max Power (W) |
|------|-------------------|---------------|
| 5V | 0.5 | 0.65 |
| 3.3V | 8.25 | 10.724 |
| 2.5V | 0.0 | 0.0 |
| 1.8V | 0.0 | 0.0 |
| **TOTAL** | **8.75** | **11.374** |

> Note: Power values are estimated from component datasheets and design parameters.
> Actual measurements should be taken during hardware bring-up and updated in this table.