# Power Calculation
## Receiver Module

**Date:** 17-04-2026

> All values in Watts (W). TYP = typical operating power, MAX = worst-case (130% of TYP).
> Rail assignment is based on component operating voltage from BOM.

## Power Budget — 5 V & 3.3 V Rails

| SI | Description | Part No | Qty | 5V TYP (W) | 5V MAX (W) | 3.3V TYP (W) | 3.3V MAX (W) | Total TYP (W) | Total MAX (W) |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | Wideband Low Noise Amplifier (5-18 GHz) | HMC6180LP4E | 1 | — | — | 0.9 | 1.17 | 0.9 | 1.17 |
| 2 | Variable Gain Amplifier / Attenuator | HMC698LP4 | 1 | 1.5 | 1.95 | — | — | 1.5 | 1.95 |
| 3 | Wideband Mixer (Downconversion) | HMC556LC4 | 1 | 0.25 | 0.325 | — | — | 0.25 | 0.325 |
| 4 | LDO Regulator for RF Circuits (+3.3V) | LT3045EDD#PBF | 1 | — | — | 0.99 | 1.287 | 0.99 | 1.287 |
| 5 | LDO Regulator for +5V Rail | LT3094EDD#PBF | 1 | 0.05 | 0.065 | — | — | 0.05 | 0.065 |
| 6 | RF Input/Output SMA Connector | 142-0701-881 | 1 | — | — | 0.99 | 1.287 | 0.99 | 1.287 |
| 7 | DC Blocking Capacitor (RF) | 0402HT Series | 1 | — | — | 0.99 | 1.287 | 0.99 | 1.287 |
| | **TOTALS** | |  | **1.8** | **2.34** | **3.87** | **5.031** | **5.67** | **7.371** |

---

## Power Summary

| Rail | Typical Power (W) | Max Power (W) |
|------|-------------------|---------------|
| 5V | 1.8 | 2.34 |
| 3.3V | 3.87 | 5.031 |
| 2.5V | 0.0 | 0.0 |
| 1.8V | 0.0 | 0.0 |
| **TOTAL** | **5.67** | **7.371** |

> Note: Power values are estimated from component datasheets and design parameters.
> Actual measurements should be taken during hardware bring-up and updated in this table.