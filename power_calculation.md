# Power Calculation
## rf tx

**Date:** 14-04-2026

## Power Budget — Per Component Per Rail

> All values in Watts (W). TYP = typical operating power, MAX = worst-case (130% of TYP).
> Rail assignment is based on component operating voltage from BOM.

| SI NO | DESCRIPTION | Package | PART NO | QTY | 5V TYP (W) | 5V MAX (W) | 5V TOT TYP (W) | 5V TOT MAX (W) | 3.3V TYP (W) | 3.3V MAX (W) | 3.3V TOT TYP (W) | 3.3V TOT MAX (W) | 2.5V TYP (W) | 2.5V MAX (W) | 2.5V TOT TYP (W) | 2.5V TOT MAX (W) | 1.8V TYP (W) | 1.8V MAX (W) | 1.8V TOT TYP (W) | 1.8V TOT MAX (W) | TOT MAX POW (W) | TOT TYP POW (W) |
|-------|-------------|---------|---------|---- |-----------|-----------|--------------|--------------| |-----------|-----------|--------------|--------------| |-----------|-----------|--------------|--------------| |-----------|-----------|--------------|--------------|-----------------|-----------------|
| 1 | Wideband Low Noise Amplifier 5-18 GHz with 20 dB gain, 3 dB noise figure, +15 dBm P1dB | — | HMC1049LP3E | 1 |  |  |  |  | 0.99 | 1.287 | 0.99 | 1.287 |  |  |  |  |  |  |  |  | 1.287 | 0.99 |
| 2 | Wideband Mixer for 5-18 GHz downconversion to 2.4 GHz IF with +10 dBm LO drive | — | HMC1052LP4GE | 1 |  |  |  |  | 0.165 | 0.214 | 0.165 | 0.214 |  |  |  |  |  |  |  |  | 0.214 | 0.165 |
| 3 | Wideband Frequency Synthesizer 7.4-20.4 GHz LO generation with kHz tuning resolution | — | HMC830LP6GE | 1 |  |  |  |  | 0.165 | 0.214 | 0.165 | 0.214 |  |  |  |  |  |  |  |  | 0.214 | 0.165 |
| 4 | Variable Gain Amplifier IF stage with 40 dB gain control range at 2.4 GHz | — | HMC698LP4 | 1 |  |  |  |  | 0.99 | 1.287 | 0.99 | 1.287 |  |  |  |  |  |  |  |  | 1.287 | 0.99 |
| 5 | Wideband ADC for 2.4 GHz IF digitization with 12-bit resolution | — | ADC12J4000 | 1 |  |  |  |  | 0.165 | 0.214 | 0.165 | 0.214 |  |  |  |  |  |  |  |  | 0.214 | 0.165 |
| 6 | FPGA for digital signal processing, FFT, CW detection, and frequency measurement | — | XC7A100T-FGG484 | 1 |  |  |  |  | 1.65 | 2.145 | 1.65 | 2.145 |  |  |  |  |  |  |  |  | 2.145 | 1.65 |
| 7 | Microcontroller for UART control, SPI interface to RF components, and system management | — | STM32F407VGT6 | 1 |  |  |  |  | 0.495 | 0.643 | 0.495 | 0.643 |  |  |  |  |  |  |  |  | 0.643 | 0.495 |
| 8 | 5V LDO regulator for RF chain power supply with low noise | — | LT3045-5 | 1 | 1.5 | 1.95 | 1.5 | 1.95 |  |  |  |  |  |  |  |  |  |  |  |  | 1.95 | 1.5 |
| 9 | 3.3V LDO regulator for digital control and FPGA supply | — | LT3045-3.3 | 1 |  |  |  |  | 1.65 | 2.145 | 1.65 | 2.145 |  |  |  |  |  |  |  |  | 2.145 | 1.65 |
| 10 | RF Input SMA connector rated to 18 GHz | — | 142-0701-851 | 1 |  |  |  |  | 0.99 | 1.287 | 0.99 | 1.287 |  |  |  |  |  |  |  |  | 1.287 | 0.99 |
| | **TOTAL** | | |  | | | 1.5 | 1.95 | | | 7.26 | 9.436 | | | 0.0 | 0.0 | | | 0.0 | 0.0 | **11.386** | **8.76** |

---

## Power Summary

| Rail | Typical Power (W) | Max Power (W) |
|------|-------------------|---------------|
| 5V | 1.5 | 1.95 |
| 3.3V | 7.26 | 9.436 |
| 2.5V | 0.0 | 0.0 |
| 1.8V | 0.0 | 0.0 |
| **TOTAL** | **8.76** | **11.386** |

> Note: Power values are estimated from component datasheets and design parameters.
> Actual measurements should be taken during hardware bring-up and updated in this table.