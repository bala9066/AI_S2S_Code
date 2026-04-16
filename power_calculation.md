# Power Calculation
## kgo

**Date:** 16-04-2026

> All values in Watts (W). TYP = typical operating power, MAX = worst-case (130% of TYP).
> Rail assignment is based on component operating voltage from BOM.

## Power Budget — 5 V & 3.3 V Rails

| SI | Description | Part No | Qty | 5V TYP (W) | 5V MAX (W) | 3.3V TYP (W) | 3.3V MAX (W) | Total TYP (W) | Total MAX (W) |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | Wideband LNA (5-18 GHz) | HMC1099LP4DE | 1 | — | — | 0.165 | 0.214 | 0.165 | 0.214 |
| 2 | Digital VGA / Variable Gain Amplifier | HMC698LP4 | 1 | — | — | 0.99 | 1.287 | 0.99 | 1.287 |
| 3 | High-Frequency Mixer | HMC1052LP4E | 1 | — | — | 0.165 | 0.214 | 0.165 | 0.214 |
| 4 | LO Synthesizer / PLL | ADF5356 | 1 | — | — | 0.165 | 0.214 | 0.165 | 0.214 |
| 5 | 12-bit ADC (1-10 GSPS) | RFADC-12X1000 | 1 | — | — | 0.165 | 0.214 | 0.165 | 0.214 |
| 6 | Clock Generator / Jitter Cleaner | LMK04828 | 1 | — | — | 0.165 | 0.214 | 0.165 | 0.214 |
| 7 | LVDS Buffer | DS90LV047A | 1 | — | — | 0.165 | 0.214 | 0.165 | 0.214 |
| 8 | DC-DC Converter (Power) | PTH08T240W | 1 | — | — | 0.033 | 0.043 | 0.033 | 0.043 |
| 9 | LDO Regulator (Low Noise) | LT3045 | 1 | — | — | 0.033 | 0.043 | 0.033 | 0.043 |
| 10 | Control Logic (FPGA) | iCE40-HK | 1 | — | — | 1.65 | 2.145 | 1.65 | 2.145 |
| 11 | RF Input Connector | 142-0701-851 | 1 | — | — | 0.99 | 1.287 | 0.99 | 1.287 |
| | **TOTALS** | |  | **0.0** | **0.0** | **4.686** | **6.089** | **4.686** | **6.089** |

## Power Budget — 2.5 V & 1.8 V Rails

| SI | Description | Part No | Qty | 2.5V TYP (W) | 2.5V MAX (W) | 1.8V TYP (W) | 1.8V MAX (W) | Total TYP (W) | Total MAX (W) |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | Wideband LNA (5-18 GHz) | HMC1099LP4DE | 1 | — | — | — | — | — | — |
| 2 | Digital VGA / Variable Gain Amplifier | HMC698LP4 | 1 | — | — | — | — | — | — |
| 3 | High-Frequency Mixer | HMC1052LP4E | 1 | — | — | — | — | — | — |
| 4 | LO Synthesizer / PLL | ADF5356 | 1 | — | — | — | — | — | — |
| 5 | 12-bit ADC (1-10 GSPS) | RFADC-12X1000 | 1 | — | — | — | — | — | — |
| 6 | Clock Generator / Jitter Cleaner | LMK04828 | 1 | — | — | — | — | — | — |
| 7 | LVDS Buffer | DS90LV047A | 1 | — | — | — | — | — | — |
| 8 | DC-DC Converter (Power) | PTH08T240W | 1 | — | — | — | — | — | — |
| 9 | LDO Regulator (Low Noise) | LT3045 | 1 | — | — | — | — | — | — |
| 10 | Control Logic (FPGA) | iCE40-HK | 1 | — | — | — | — | — | — |
| 11 | RF Input Connector | 142-0701-851 | 1 | — | — | — | — | — | — |
| | **TOTALS** | |  | **0.0** | **0.0** | **0.0** | **0.0** | **0.0** | **0.0** |

---

## Power Summary

| Rail | Typical Power (W) | Max Power (W) |
|------|-------------------|---------------|
| 5V | 0.0 | 0.0 |
| 3.3V | 4.686 | 6.089 |
| 2.5V | 0.0 | 0.0 |
| 1.8V | 0.0 | 0.0 |
| **TOTAL** | **4.686** | **6.089** |

> Note: Power values are estimated from component datasheets and design parameters.
> Actual measurements should be taken during hardware bring-up and updated in this table.