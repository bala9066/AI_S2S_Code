# Power Calculation
## kjk

**Date:** 17-04-2026

> All values in Watts (W). TYP = typical operating power, MAX = worst-case (130% of TYP).
> Rail assignment is based on component operating voltage from BOM.

## Power Budget — 5 V & 3.3 V Rails

| SI | Description | Part No | Qty | 5V TYP (W) | 5V MAX (W) | 3.3V TYP (W) | 3.3V MAX (W) | Total TYP (W) | Total MAX (W) |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | Wideband LNA (5-18 GHz) | HMC698LP4 | 1 | 0.25 | 0.325 | — | — | 0.25 | 0.325 |
| 2 | First Mixer (RF to First IF) | HMC1049LC4 | 1 | — | — | 0.99 | 1.287 | 0.99 | 1.287 |
| 3 | First LO Synthesizer (4-14 GHz) | ADF5356 | 1 | — | — | 0.158 | 0.205 | 0.158 | 0.205 |
| 4 | Variable Gain IF Amplifier | HMC698LP4 | 1 | — | — | 0.99 | 1.287 | 0.99 | 1.287 |
| 5 | High-Speed ADC (5 GSPS) | ADC12DJ5200RF | 1 | — | — | 0.165 | 0.214 | 0.165 | 0.214 |
| 6 | FPGA Signal Processor | XCZU49DR-FFVF1760 | 1 | — | — | 1.65 | 2.145 | 1.65 | 2.145 |
| 7 | Gigabit Ethernet PHY | VSC8514 | 1 | — | — | 0.165 | 0.214 | 0.165 | 0.214 |
| 8 | Wideband Bandpass Filters (5-18 GHz) | Custom Mini-Circuits Bank | 1 | — | — | 0.99 | 1.287 | 0.99 | 1.287 |
| 9 | EMI Filter Module (MIL-STD-461) | DLB1R5-1212 | 1 | 180.0 | 234.0 | — | — | 180.0 | 234.0 |
| 10 | DC-DC Converter (Custom Voltage) | VHA500F48T500N | 1 | — | — | 0.033 | 0.043 | 0.033 | 0.043 |
| | **TOTALS** | |  | **180.25** | **234.325** | **5.141** | **6.682** | **185.391** | **241.007** |

---

## Power Summary

| Rail | Typical Power (W) | Max Power (W) |
|------|-------------------|---------------|
| 5V | 180.25 | 234.325 |
| 3.3V | 5.141 | 6.682 |
| 2.5V | 0.0 | 0.0 |
| 1.8V | 0.0 | 0.0 |
| **TOTAL** | **185.391** | **241.007** |

> Note: Power values are estimated from component datasheets and design parameters.
> Actual measurements should be taken during hardware bring-up and updated in this table.