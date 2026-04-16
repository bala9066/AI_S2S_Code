# Power Calculation
## khg

**Date:** 16-04-2026

> All values in Watts (W). TYP = typical operating power, MAX = worst-case (130% of TYP).
> Rail assignment is based on component operating voltage from BOM.

## Power Budget — 5 V & 3.3 V Rails

| SI | Description | Part No | Qty | 5V TYP (W) | 5V MAX (W) | 3.3V TYP (W) | 3.3V MAX (W) | Total TYP (W) | Total MAX (W) |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | RF Input Limiter Protection | LPA-518+ | 1 | — | — | 0.99 | 1.287 | 0.99 | 1.287 |
| 2 | RF Bandpass Filter 5-18 GHz | BP5G18G-5180-SM | 1 | — | — | 0.99 | 1.287 | 0.99 | 1.287 |
| 3 | Wideband RF LNA | TQM473552 | 1 | — | — | 0.99 | 1.287 | 0.99 | 1.287 |
| 4 | RF Variable Gain Amplifier (Digital Control) | HMC698LP4 | 1 | — | — | 0.99 | 1.287 | 0.99 | 1.287 |
| 5 | IQ Demodulator/Mixer | MWC-1440+ | 1 | — | — | 0.165 | 0.214 | 0.165 | 0.214 |
| 6 | Wideband PLL/VCO Local Oscillator | LMX2594 | 1 | — | — | 0.165 | 0.214 | 0.165 | 0.214 |
| 7 | Differential IF VGA (Post-Mixer) | ADA4817-2 | 1 | — | — | 0.165 | 0.214 | 0.165 | 0.214 |
| 8 | Dual/Quad RF ADC with JESD204C | AD9213 | 1 | — | — | 0.99 | 1.287 | 0.99 | 1.287 |
| 9 | Power Management IC | LTC7815 | 1 | — | — | 0.033 | 0.043 | 0.033 | 0.043 |
| 10 | Low Noise LDO for RF Circuits | LT3045 | 1 | — | — | 0.99 | 1.287 | 0.99 | 1.287 |
| 11 | DC/DC Power Module | UCC12040 | 1 | — | — | 0.033 | 0.043 | 0.033 | 0.043 |
| | **TOTALS** | |  | **0.0** | **0.0** | **6.501** | **8.45** | **6.501** | **8.45** |

---

## Power Summary

| Rail | Typical Power (W) | Max Power (W) |
|------|-------------------|---------------|
| 5V | 0.0 | 0.0 |
| 3.3V | 6.501 | 8.45 |
| 2.5V | 0.0 | 0.0 |
| 1.8V | 0.0 | 0.0 |
| **TOTAL** | **6.501** | **8.45** |

> Note: Power values are estimated from component datasheets and design parameters.
> Actual measurements should be taken during hardware bring-up and updated in this table.