# Power Calculation
## hgyu

**Date:** 15-04-2026

> All values in Watts (W). TYP = typical operating power, MAX = worst-case (130% of TYP).
> Rail assignment is based on component operating voltage from BOM.

## Component Power Budget

| # | Component | Part Number | Rail | TYP (W) | MAX (W) |
|---|-----------|-------------|------|----------|----------|
| 1 | Wideband Low Noise Amplifier (5-18 GHz) | HMC1132LP6GE | 3.3V | 0.99 | 1.287 |
| 2 | Wideband Variable Gain Amplifier / Attenuator (5-18 GHz) | HMC698LP4 | 3.3V | 0.99 | 1.287 |
| 3 | 5-10 GSPS Ultra-Wideband ADC | ADC10DX100 | 3.3V | 0.165 | 0.214 |
| 4 | Ultra-Low Jitter Clock Generator | LMK04828 | 3.3V | 0.165 | 0.214 |
| 5 | Wideband Anti-Alias Filter (5-10 GHz) | RBP-8250+ | 3.3V | 0.165 | 0.214 |
| 6 | Power Management Module | LTM4644 | 3.3V | 0.033 | 0.043 |
| 7 | Control Microcontroller | ATSAMC21G18A-MUT | 3.3V | 0.495 | 0.643 |

## Power Summary by Rail

| Rail | Typical Power (W) | Max Power (W) |
|------|-------------------|---------------|
| 5V | 0.0 | 0.0 |
| 3.3V | 3.003 | 3.902 |
| 2.5V | 0.0 | 0.0 |
| 1.8V | 0.0 | 0.0 |
| **TOTAL** | **3.003** | **3.902** |

> Note: Power values are estimated from component datasheets and design parameters.
> Actual measurements should be taken during hardware bring-up and updated in this table.