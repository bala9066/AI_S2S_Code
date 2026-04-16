# Power Calculation
## mnb

**Date:** 17-04-2026

> All values in Watts (W). TYP = typical operating power, MAX = worst-case (130% of TYP).
> Rail assignment is based on component operating voltage from BOM.

## Power Budget — 5 V & 3.3 V Rails

| SI | Description | Part No | Qty | 5V TYP (W) | 5V MAX (W) | 3.3V TYP (W) | 3.3V MAX (W) | Total TYP (W) | Total MAX (W) |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | Wideband Low Noise Amplifier 5-18 GHz front-end | HMC698LP4(E) | 1 | — | — | 0.99 | 1.287 | 0.99 | 1.287 |
| 2 | Wideband Double Balanced Mixer for frequency conversion | HMC1061LP4(E) | 1 | — | — | 0.165 | 0.214 | 0.165 | 0.214 |
| 3 | Wideband PLL Frequency Synthesizer for LO generation | ADF5355 | 1 | — | — | 0.165 | 0.214 | 0.165 | 0.214 |
| 4 | Variable Gain Amplifier for AGC/IF gain control | HMC698LP4 | 1 | — | — | 0.99 | 1.287 | 0.99 | 1.287 |
| 5 | High-Speed ADC for IF digitization | ADC12DJ3200 | 1 | — | — | 0.165 | 0.214 | 0.165 | 0.214 |
| 6 | FPGA for digital signal processing and data forwarding | XCZU4EG-SFVC784 | 1 | — | — | 1.65 | 2.145 | 1.65 | 2.145 |
| 7 | Gigabit Ethernet PHY for data output interface | 88E1512-A0-BKK2C000 | 1 | — | — | 0.99 | 1.287 | 0.99 | 1.287 |
| 8 | Main 5V power input and distribution | LTM8058 | 1 | 0.05 | 0.065 | — | — | 0.05 | 0.065 |
| 9 | 3.3V LDO regulator for analog circuits | LT3045 | 1 | — | — | 0.033 | 0.043 | 0.033 | 0.043 |
| 10 | 2.5V and 1.8V DDR3/FPGA rail generation | LTC3372 | 1 | 2.5 | 3.25 | — | — | 2.5 | 3.25 |
| 11 | RF Input SMA Connector | 142-0771-821 | 1 | — | — | 0.99 | 1.287 | 0.99 | 1.287 |
| 12 | Gigabit Ethernet RJ45 with integrated magnetics | 0884-1G1C1F02 | 1 | — | — | 0.165 | 0.214 | 0.165 | 0.214 |
| 13 | DDR3 Memory for FPGA buffering | MT41J512M8RH-125 | 1 | — | — | — | — | — | — |
| 14 | FPGA Configuration Flash | S25FL256SDPBHI010 | 1 | — | — | 1.65 | 2.145 | 1.65 | 2.145 |
| | **TOTALS** | |  | **2.55** | **3.315** | **7.953** | **10.337** | **10.503** | **13.652** |

## Power Budget — 2.5 V & 1.8 V Rails

| SI | Description | Part No | Qty | 2.5V TYP (W) | 2.5V MAX (W) | 1.8V TYP (W) | 1.8V MAX (W) | Total TYP (W) | Total MAX (W) |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | Wideband Low Noise Amplifier 5-18 GHz front-end | HMC698LP4(E) | 1 | — | — | — | — | — | — |
| 2 | Wideband Double Balanced Mixer for frequency conversion | HMC1061LP4(E) | 1 | — | — | — | — | — | — |
| 3 | Wideband PLL Frequency Synthesizer for LO generation | ADF5355 | 1 | — | — | — | — | — | — |
| 4 | Variable Gain Amplifier for AGC/IF gain control | HMC698LP4 | 1 | — | — | — | — | — | — |
| 5 | High-Speed ADC for IF digitization | ADC12DJ3200 | 1 | — | — | — | — | — | — |
| 6 | FPGA for digital signal processing and data forwarding | XCZU4EG-SFVC784 | 1 | — | — | — | — | — | — |
| 7 | Gigabit Ethernet PHY for data output interface | 88E1512-A0-BKK2C000 | 1 | — | — | — | — | — | — |
| 8 | Main 5V power input and distribution | LTM8058 | 1 | — | — | — | — | — | — |
| 9 | 3.3V LDO regulator for analog circuits | LT3045 | 1 | — | — | — | — | — | — |
| 10 | 2.5V and 1.8V DDR3/FPGA rail generation | LTC3372 | 1 | — | — | — | — | — | — |
| 11 | RF Input SMA Connector | 142-0771-821 | 1 | — | — | — | — | — | — |
| 12 | Gigabit Ethernet RJ45 with integrated magnetics | 0884-1G1C1F02 | 1 | — | — | — | — | — | — |
| 13 | DDR3 Memory for FPGA buffering | MT41J512M8RH-125 | 1 | 1.25 | 1.625 | — | — | 1.25 | 1.625 |
| 14 | FPGA Configuration Flash | S25FL256SDPBHI010 | 1 | — | — | — | — | — | — |
| | **TOTALS** | |  | **1.25** | **1.625** | **0.0** | **0.0** | **1.25** | **1.625** |

---

## Power Summary

| Rail | Typical Power (W) | Max Power (W) |
|------|-------------------|---------------|
| 5V | 2.55 | 3.315 |
| 3.3V | 7.953 | 10.337 |
| 2.5V | 1.25 | 1.625 |
| 1.8V | 0.0 | 0.0 |
| **TOTAL** | **11.753** | **15.277** |

> Note: Power values are estimated from component datasheets and design parameters.
> Actual measurements should be taken during hardware bring-up and updated in this table.