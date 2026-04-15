# Component Recommendations
## kh

### 1. RF Low Noise Amplifier (LNA)

**Primary Choice:** [HMC1119LP4DE](https://www.analog.com/en/search.html#q=HMC1119LP4DE) (Analog Devices)

*Wideband GaAs MMIC LNA, 6-18 GHz, 20 dB gain, 3 dB noise figure, +20 dBm P1dB*

[📄 Datasheet](https://www.analog.com/en/search.html#q=HMC1119LP4DE)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/1124-1035-ND/5833646)

| Spec | Value |
|---|---|
| frequency_range | 6-18 GHz |
| gain | 20 dB |
| noise_figure | 3 dB |
| p1db | +20 dBm |
| supply_voltage | +5V |

**Alternatives:**
- **[TQP3M9036](https://www.qorvo.com/products/d/qa0158)** (Qorvo): Similar performance, slightly higher NF 3.5dB
- **[MAAL-011141](https://www.google.com/search?q=MAAL-011141+datasheet)** (MACOM): Lower gain 16dB, lower power

**Selection Rationale:** Excellent NF of 3dB meets spec requirement, wide bandwidth covers entire 10-15GHz range with margin

### 2. Variable Gain Amplifier (VGA)

**Primary Choice:** [HMC698LP4](https://www.analog.com/en/search.html#q=HMC698LP4) (Analog Devices)

*Digital VGA, 6-18 GHz, 31 dB gain range, 3.5 dB noise figure*

[📄 Datasheet](https://www.analog.com/en/search.html#q=HMC698LP4)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/1124-1048-ND/5833659)

| Spec | Value |
|---|---|
| frequency_range | 6-18 GHz |
| gain_range | 31 dB |
| noise_figure | 3.5 dB |
| p1db | +18 dBm |
| gain_control | 6-bit digital |

**Alternatives:**
- **[ADL5201](https://www.analog.com/en/search.html#q=ADL5201)** (Analog Devices): Analog VGA, lower frequency range 100MHz-2GHz

**Selection Rationale:** Digital gain control enables AGC implementation, wideband operation matches LNA frequency range

### 3. RF Mixer for Downconversion

**Primary Choice:** [HMC1051LP4BE](https://www.analog.com/en/search.html#q=HMC1051LP4BE) (Analog Devices)

*Double-balanced mixer, 6-26 GHz, IF DC-6 GHz, +10 dBm LO drive*

[📄 Datasheet](https://www.analog.com/en/search.html#q=HMC1051LP4BE)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/1124-1051-ND/5833662)

| Spec | Value |
|---|---|
| rf_frequency | 6-26 GHz |
| if_frequency | DC-6 GHz |
| conversion_loss | 8 dB |
| lo_drive | +10 dBm |
| ip3 | +24 dBm |

**Alternatives:**
- **[MMIC-2085](https://www.google.com/search?q=MMIC-2085+datasheet)** (Marki Microwave): Lower conversion loss 6dB, higher LO drive required

**Selection Rationale:** Wideband mixer supports entire RF input range with good linearity for SFDR requirement

### 4. IF Amplifier

**Primary Choice:** [ADL5541](https://www.analog.com/en/search.html#q=ADL5541) (Analog Devices)

*IF gain block amplifier, 30 MHz-6 GHz, 20 dB gain*

[📄 Datasheet](https://www.analog.com/en/search.html#q=ADL5541)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/ADL5541ACPZ-R7/5859756)

| Spec | Value |
|---|---|
| frequency_range | 30 MHz-6 GHz |
| gain | 20 dB |
| oip3 | +42 dBm |
| p1db | +18 dBm |
| noise_figure | 3.5 dB |

**Alternatives:**
- **[TQP3M9035](https://www.qorvo.com/products/d/tqp3m9035)** (Qorvo): Similar gain, higher OIP3 +45dBm

**Selection Rationale:** Provides gain before ADC while maintaining linearity for SFDR requirement

### 5. High-Speed ADC with LVDS

**Primary Choice:** [ADC12DJ5200RF](https://www.ti.com/product/ADC12DJ5200RF) (Texas Instruments)

*Dual-channel 12-bit ADC, up to 5.2 GSPS, JESD204B/C interface*

[📄 Datasheet](https://www.ti.com/product/ADC12DJ5200RF)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/texas-instruments/ADC12DJ5200RFAB/6487216)

| Spec | Value |
|---|---|
| resolution | 12-bit |
| sampling_rate | Up to 5.2 GSPS |
| input_bandwidth | 9 GHz |
| sfdr | 75 dBc @ 2.6 GHz |
| interface | JESD204B/C |
| power | 2.5W |

**Alternatives:**
- **[AD9208](https://www.analog.com/en/search.html#q=AD9208)** (Analog Devices): Single channel 14-bit 3 GSPS, similar power
- **[EV12AQ600](https://www.google.com/search?q=EV12AQ600+datasheet)** (Teledyne e2v): Quad-channel 12-bit 1.6 GSPS, lower power per channel

**Selection Rationale:** High sampling rate exceeds 500 MSPS requirement with margin, wide input bandwidth, JESD204B interface for LVDS-like high-speed data transmission

### 6. Bandpass Filter 10-15 GHz

**Primary Choice:** [CBP-1250-C3](https://www.google.com/search?q=CBP-1250-C3+datasheet) (Crystek)

*Bandpass filter, 10-15 GHz, 3-section ceramic*

[📄 Datasheet](https://www.google.com/search?q=CBP-1250-C3+datasheet)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/crystek-corporation/CBP-1250-C3/17595975)

| Spec | Value |
|---|---|
| center_frequency | 12.5 GHz |
| bandwidth | 5 GHz |
| insertion_loss | 2 dB |
| rejection | 40 dB @ 8/17 GHz |

**Alternatives:**
- **[BP-12500-C4](https://www.google.com/search?q=BP-12500-C4+datasheet)** (Mini-Circuits): Sharper roll-off, higher insertion loss 3dB

**Selection Rationale:** Defines input frequency band and rejects out-of-band interference before LNA

### 7. DC-DC Power Converter

**Primary Choice:** [LTM4625](https://www.analog.com/en/search.html#q=LTM4625) (Analog Devices)

*5A step-down power module, 4.5-20V input*

[📄 Datasheet](https://www.analog.com/en/search.html#q=LTM4625)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/LTM4625EV-12-PBF/6028697)

| Spec | Value |
|---|---|
| input_voltage | 4.5-20V |
| output_voltage | 0.6-5V |
| max_current | 5A |
| efficiency | 92% |
| switching_frequency | 1MHz |

**Alternatives:**
- **[TPS62913](https://www.ti.com/product/TPS62913)** (Texas Instruments): Lower current 3A, smaller footprint

**Selection Rationale:** Provides efficient power conversion with low noise suitable for RF applications

### 8. LDO Regulator for Analog

**Primary Choice:** [LT3045](https://www.analog.com/en/search.html#q=LT3045) (Analog Devices)

*Ultra-low noise LDO, 500mA, 0.8μV RMS noise*

[📄 Datasheet](https://www.analog.com/en/search.html#q=LT3045)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/LT3045IDD-1-PBF/5884129)

| Spec | Value |
|---|---|
| output_current | 500 mA |
| input_voltage | 2.3-20V |
| output_voltage | 0.2-15V |
| noise | 0.8μV RMS |
| psrr | 79dB @ 1kHz |

**Alternatives:**
- **[LT3094](https://www.analog.com/en/search.html#q=LT3094)** (Analog Devices): Dual LDO, higher noise 2μV RMS

**Selection Rationale:** Ultra-low noise LDO for sensitive RF components, critical for maintaining NF spec
