# Power Calculation
## sdfjbks

**Date:** 16-04-2026

> All values in Watts (W). TYP = typical operating power, MAX = worst-case (130% of TYP).
> Rail assignment is based on component operating voltage from BOM.

## Component Power Budget

| # | Component | Part Number | Rail | TYP (W) | MAX (W) |
|---|-----------|-------------|------|----------|----------|
| 1 | Wideband RF Low Noise Amplifier covering 5-18 GHz | HMC6180LP4E | 5V | 0.4 | 0.52 |
| 2 | Wideband IQ Mixer for downconversion | HMC1051LP4E | 3.3V | 0.165 | 0.214 |
| 3 | Wideband synthesizer with low phase noise | ADF5356 | 3.3V | 0.165 | 0.214 |
| 4 | Direct RF sampling ADC with JESD204B | ADC12DJ5200RF | 3.3V | 0.99 | 1.287 |
| 5 | Wideband variable gain amplifier | HMC698LP4 | 3.3V | 0.99 | 1.287 |
| 6 | RF Bandpass filter 5-18 GHz | BP06S-18S-A-SMA+ | 3.3V | 0.99 | 1.287 |
| 7 | RF input connector 5-18 GHz | 142-0701-841 | 3.3V | 0.99 | 1.287 |
| 8 | Buck converter 5V to 1.2V for ADC | TPS62913 | 5V | 0.25 | 0.325 |
| 9 | Buck converter 5V to 3.3V for RF front-end | TPS562201 | 5V | 1.5 | 1.95 |
| 10 | LDO 5V to 1.8V for JESD204B interface | TPS7A47 | 5V | 1.5 | 1.95 |
| 11 | Microcontroller for system control | STM32F407VGT6 | 3.3V | 0.495 | 0.643 |

## Power Summary by Rail

| Rail | Typical Power (W) | Max Power (W) |
|------|-------------------|---------------|
| 5V | 3.65 | 4.745 |
| 3.3V | 4.785 | 6.219 |
| 2.5V | 0.0 | 0.0 |
| 1.8V | 0.0 | 0.0 |
| **TOTAL** | **8.435** | **10.964** |

> Note: Power values are estimated from component datasheets and design parameters.
> Actual measurements should be taken during hardware bring-up and updated in this table.