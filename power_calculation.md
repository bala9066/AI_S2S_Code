# Power Calculation
## dghb

**Date:** 16-04-2026

> All values in Watts (W). TYP = typical operating power, MAX = worst-case (130% of TYP).
> Rail assignment is based on component operating voltage from BOM.

## Power Budget — 5 V & 3.3 V Rails

| SI | Description | Part No | Qty | 5V TYP (W) | 5V MAX (W) | 3.3V TYP (W) | 3.3V MAX (W) | Total TYP (W) | Total MAX (W) |
|----|-------------|---------|---- |-----------|-----------| |-----------|-----------|---------------|---------------|
| 1 | Wideband LNA (Low Noise Amplifier) covering 5-18 GHz with ~20-25 dB gain and low noise figure to meet system NF target of 5-8 dB. | GVA-123+ | 1 | — | — | 0.99 | 1.287 | 0.99 | 1.287 |
| 2 | Variable Gain Amplifier (VGA) for fine gain control to optimize signal level into the ADC over wide input power range (-60 to -40 dBm). | HMC698LP4 | 1 | — | — | 0.99 | 1.287 | 0.99 | 1.287 |
| 3 | Multi-GSPS ADC for direct IF sampling at 4-8 GSPS with 10-12 bit resolution and LVDS/JESD204B output interface. | ADC12DJ5200RF | 1 | — | — | 0.99 | 1.287 | 0.99 | 1.287 |
| 4 | Ultra-low jitter clock generator and synthesizer to drive multi-GSPS ADC with <200 fs RMS jitter to support high-order modulation and SFDR targets. | LMK04828 | 1 | — | — | 0.165 | 0.214 | 0.165 | 0.214 |
| 5 | RF input protection against ESD and over-voltage up to +10 dBm with minimal impact on NF and VSWR up to 18 GHz. | LM5000 | 1 | — | — | 0.99 | 1.287 | 0.99 | 1.287 |
| 6 | 5-18 GHz bandpass filter to restrict input bandwidth and reduce out-of-band interference/noise, improving system linearity and image rejection. | BP5G18G-25M01-C5F | 1 | — | — | 0.99 | 1.287 | 0.99 | 1.287 |
| 7 | MCU or CPLD for control interface (SPI/I2C) to configure VGA gain, ADC settings, clock generation, and monitor system status (temperature, power). | STM32F407VGT6 | 1 | — | — | 0.495 | 0.643 | 0.495 | 0.643 |
| 8 | Point-of-load DC-DC converters and LDO regulators to derive required supply voltages (1.0V, 1.8V, etc.) from main 3.3V input for high-performance ICs. | TPS62913 | 1 | — | — | — | — | — | — |
| 9 | RF input connector suitable for 5-18 GHz, 50 ohm impedance, SMA or 2.4mm format for board edge launch. | 142-0701-851 | 1 | — | — | 0.99 | 1.287 | 0.99 | 1.287 |
| 10 | Temperature sensors for thermal monitoring and protection across the system, particularly for high-power components like the LNA and ADC. | TMP235A2DCKR | 1 | — | — | 115.5 | 150.15 | 115.5 | 150.15 |
| | **TOTALS** | |  | **0.0** | **0.0** | **122.1** | **158.729** | **122.1** | **158.729** |

## Power Budget — 2.5 V & 1.8 V Rails

| SI | Description | Part No | Qty | 2.5V TYP (W) | 2.5V MAX (W) | 1.8V TYP (W) | 1.8V MAX (W) | Total TYP (W) | Total MAX (W) |
|----|-------------|---------|---- |-----------|-----------| |-----------|-----------|---------------|---------------|
| 1 | Wideband LNA (Low Noise Amplifier) covering 5-18 GHz with ~20-25 dB gain and low noise figure to meet system NF target of 5-8 dB. | GVA-123+ | 1 | — | — | — | — | — | — |
| 2 | Variable Gain Amplifier (VGA) for fine gain control to optimize signal level into the ADC over wide input power range (-60 to -40 dBm). | HMC698LP4 | 1 | — | — | — | — | — | — |
| 3 | Multi-GSPS ADC for direct IF sampling at 4-8 GSPS with 10-12 bit resolution and LVDS/JESD204B output interface. | ADC12DJ5200RF | 1 | — | — | — | — | — | — |
| 4 | Ultra-low jitter clock generator and synthesizer to drive multi-GSPS ADC with <200 fs RMS jitter to support high-order modulation and SFDR targets. | LMK04828 | 1 | — | — | — | — | — | — |
| 5 | RF input protection against ESD and over-voltage up to +10 dBm with minimal impact on NF and VSWR up to 18 GHz. | LM5000 | 1 | — | — | — | — | — | — |
| 6 | 5-18 GHz bandpass filter to restrict input bandwidth and reduce out-of-band interference/noise, improving system linearity and image rejection. | BP5G18G-25M01-C5F | 1 | — | — | — | — | — | — |
| 7 | MCU or CPLD for control interface (SPI/I2C) to configure VGA gain, ADC settings, clock generation, and monitor system status (temperature, power). | STM32F407VGT6 | 1 | — | — | — | — | — | — |
| 8 | Point-of-load DC-DC converters and LDO regulators to derive required supply voltages (1.0V, 1.8V, etc.) from main 3.3V input for high-performance ICs. | TPS62913 | 1 | — | — | 3.6 | 4.68 | 3.6 | 4.68 |
| 9 | RF input connector suitable for 5-18 GHz, 50 ohm impedance, SMA or 2.4mm format for board edge launch. | 142-0701-851 | 1 | — | — | — | — | — | — |
| 10 | Temperature sensors for thermal monitoring and protection across the system, particularly for high-power components like the LNA and ADC. | TMP235A2DCKR | 1 | — | — | — | — | — | — |
| | **TOTALS** | |  | **0.0** | **0.0** | **3.6** | **4.68** | **3.6** | **4.68** |

---

## Power Summary

| Rail | Typical Power (W) | Max Power (W) |
|------|-------------------|---------------|
| 5V | 0.0 | 0.0 |
| 3.3V | 122.1 | 158.729 |
| 2.5V | 0.0 | 0.0 |
| 1.8V | 3.6 | 4.68 |
| **TOTAL** | **125.7** | **163.409** |

> Note: Power values are estimated from component datasheets and design parameters.
> Actual measurements should be taken during hardware bring-up and updated in this table.