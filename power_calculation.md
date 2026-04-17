# Power Calculation
## receiver

**Date:** 17-04-2026

> All values in Watts (W). TYP = typical operating power, MAX = worst-case (130% of TYP).
> Rail assignment is based on component operating voltage from BOM.

## Power Budget — 5 V & 3.3 V Rails

| SI | Description | Part No | Qty | 5V TYP (W) | 5V MAX (W) | 3.3V TYP (W) | 3.3V MAX (W) | Total TYP (W) | Total MAX (W) |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | Wideband LNA / Variable Gain Amplifier | HMC698LP4 | 1 | — | — | 0.99 | 1.287 | 0.99 | 1.287 |
| 2 | Mixer - Wideband I/Q Downconverter | HMC1048LP4E | 1 | — | — | 0.165 | 0.214 | 0.165 | 0.214 |
| 3 | Local Oscillator Synthesizer | ADF5355 | 1 | — | — | 0.165 | 0.214 | 0.165 | 0.214 |
| 4 | ADC - Dual I/Q Digitizer | ADC12DJ3200 | 1 | — | — | 0.165 | 0.214 | 0.165 | 0.214 |
| 5 | FPGA - Digital Signal Processing | XCZU3EG-SFVA784 | 1 | — | — | 1.65 | 2.145 | 1.65 | 2.145 |
| 6 | RF Input Connector | 149-0901-801 | 1 | — | — | 0.99 | 1.287 | 0.99 | 1.287 |
| 7 | DC-DC Converter - +12V Rail | LTM4644 | 1 | — | — | 0.033 | 0.043 | 0.033 | 0.043 |
| 8 | Negative Rail Generator - -5V | LT1054 | 1 | 0.25 | 0.325 | — | — | 0.25 | 0.325 |
| | **TOTALS** | |  | **0.25** | **0.325** | **4.158** | **5.404** | **4.408** | **5.729** |

---

## Power Summary

| Rail | Typical Power (W) | Max Power (W) |
|------|-------------------|---------------|
| 5V | 0.25 | 0.325 |
| 3.3V | 4.158 | 5.404 |
| 2.5V | 0.0 | 0.0 |
| 1.8V | 0.0 | 0.0 |
| **TOTAL** | **4.408** | **5.729** |

> Note: Power values are estimated from component datasheets and design parameters.
> Actual measurements should be taken during hardware bring-up and updated in this table.