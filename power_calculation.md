# Power Calculation
## uyj

**Date:** 15-04-2026

> All values in Watts (W). TYP = typical operating power, MAX = worst-case (130% of TYP).
> Rail assignment is based on component operating voltage from BOM.

## Power Budget — 5 V & 3.3 V Rails

| SI | Description | Part No | Qty | 5V TYP (W) | 5V MAX (W) | 3.3V TYP (W) | 3.3V MAX (W) | Total TYP (W) | Total MAX (W) |
|----|-------------|---------|---- |-----------|-----------| |-----------|-----------|---------------|---------------|
| 1 | RF Limiter/Protector | HMC1061LP4E | 1 | — | — | 0.99 | 1.287 | 0.99 | 1.287 |
| 2 | Wideband LNA | HMC1099LP5DE | 1 | — | — | 0.165 | 0.214 | 0.165 | 0.214 |
| 3 | Variable Gain Amplifier | ADL5240 | 1 | — | — | 0.99 | 1.287 | 0.99 | 1.287 |
| 4 | Direct RF Sampling ADC | ADC12DJ5200RF | 1 | — | — | 0.99 | 1.287 | 0.99 | 1.287 |
| 5 | FPGA for Signal Processing | XCZU9EG-FFVB1156 | 1 | — | — | 1.65 | 2.145 | 1.65 | 2.145 |
| 6 | Clock Synthesizer/Jitter Cleaner | LMK04828 | 1 | — | — | 0.165 | 0.214 | 0.165 | 0.214 |
| 7 | DC-DC Converter 12V to Intermediate Rails | LTM4644 | 1 | — | — | 0.033 | 0.043 | 0.033 | 0.043 |
| 8 | Ultra-Low Noise LDO for Analog Supplies | LT3045 | 1 | — | — | 0.033 | 0.043 | 0.033 | 0.043 |
| | **TOTALS** | |  | **0.0** | **0.0** | **5.016** | **6.52** | **5.016** | **6.52** |

## Power Budget — 2.5 V & 1.8 V Rails

| SI | Description | Part No | Qty | 2.5V TYP (W) | 2.5V MAX (W) | 1.8V TYP (W) | 1.8V MAX (W) | Total TYP (W) | Total MAX (W) |
|----|-------------|---------|---- |-----------|-----------| |-----------|-----------|---------------|---------------|
| 1 | RF Limiter/Protector | HMC1061LP4E | 1 | — | — | — | — | — | — |
| 2 | Wideband LNA | HMC1099LP5DE | 1 | — | — | — | — | — | — |
| 3 | Variable Gain Amplifier | ADL5240 | 1 | — | — | — | — | — | — |
| 4 | Direct RF Sampling ADC | ADC12DJ5200RF | 1 | — | — | — | — | — | — |
| 5 | FPGA for Signal Processing | XCZU9EG-FFVB1156 | 1 | — | — | — | — | — | — |
| 6 | Clock Synthesizer/Jitter Cleaner | LMK04828 | 1 | — | — | — | — | — | — |
| 7 | DC-DC Converter 12V to Intermediate Rails | LTM4644 | 1 | — | — | — | — | — | — |
| 8 | Ultra-Low Noise LDO for Analog Supplies | LT3045 | 1 | — | — | — | — | — | — |
| | **TOTALS** | |  | **0.0** | **0.0** | **0.0** | **0.0** | **0.0** | **0.0** |

---

## Power Summary

| Rail | Typical Power (W) | Max Power (W) |
|------|-------------------|---------------|
| 5V | 0.0 | 0.0 |
| 3.3V | 5.016 | 6.52 |
| 2.5V | 0.0 | 0.0 |
| 1.8V | 0.0 | 0.0 |
| **TOTAL** | **5.016** | **6.52** |

> Note: Power values are estimated from component datasheets and design parameters.
> Actual measurements should be taken during hardware bring-up and updated in this table.