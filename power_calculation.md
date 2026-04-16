# Power Calculation
## khv

**Date:** 16-04-2026

> All values in Watts (W). TYP = typical operating power, MAX = worst-case (130% of TYP).
> Rail assignment is based on component operating voltage from BOM.

## Power Budget — 5 V & 3.3 V Rails

| SI | Description | Part No | Qty | 5V TYP (W) | 5V MAX (W) | 3.3V TYP (W) | 3.3V MAX (W) | Total TYP (W) | Total MAX (W) |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | Wideband LNA with integrated VGA | HMC698LP4 | 1 | — | — | 0.165 | 0.214 | 0.165 | 0.214 |
| 2 | High-speed ADC (5-10 GSPS) | EV12AQ600 | 1 | — | — | 0.165 | 0.214 | 0.165 | 0.214 |
| 3 | Ultra-low phase noise clock synthesizer | LMK04828 | 1 | — | — | 0.165 | 0.214 | 0.165 | 0.214 |
| 4 | Wideband RF bandpass filter | BP series 5-18 GHz | 1 | — | — | 0.99 | 1.287 | 0.99 | 1.287 |
| 5 | Power management DC-DC converter | LTM4644 | 1 | — | — | 0.033 | 0.043 | 0.033 | 0.043 |
| 6 | Wideband RF input SMA connector | 142-0771-821 | 1 | — | — | 0.99 | 1.287 | 0.99 | 1.287 |
| | **TOTALS** | |  | **0.0** | **0.0** | **2.508** | **3.259** | **2.508** | **3.259** |

## Power Budget — 2.5 V & 1.8 V Rails

| SI | Description | Part No | Qty | 2.5V TYP (W) | 2.5V MAX (W) | 1.8V TYP (W) | 1.8V MAX (W) | Total TYP (W) | Total MAX (W) |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | Wideband LNA with integrated VGA | HMC698LP4 | 1 | — | — | — | — | — | — |
| 2 | High-speed ADC (5-10 GSPS) | EV12AQ600 | 1 | — | — | — | — | — | — |
| 3 | Ultra-low phase noise clock synthesizer | LMK04828 | 1 | — | — | — | — | — | — |
| 4 | Wideband RF bandpass filter | BP series 5-18 GHz | 1 | — | — | — | — | — | — |
| 5 | Power management DC-DC converter | LTM4644 | 1 | — | — | — | — | — | — |
| 6 | Wideband RF input SMA connector | 142-0771-821 | 1 | — | — | — | — | — | — |
| | **TOTALS** | |  | **0.0** | **0.0** | **0.0** | **0.0** | **0.0** | **0.0** |

---

## Power Summary

| Rail | Typical Power (W) | Max Power (W) |
|------|-------------------|---------------|
| 5V | 0.0 | 0.0 |
| 3.3V | 2.508 | 3.259 |
| 2.5V | 0.0 | 0.0 |
| 1.8V | 0.0 | 0.0 |
| **TOTAL** | **2.508** | **3.259** |

> Note: Power values are estimated from component datasheets and design parameters.
> Actual measurements should be taken during hardware bring-up and updated in this table.