# Component Recommendations
## dsf

### 1. Wideband Low-Noise Amplifier (5-18 GHz)

**Primary Choice:** [HMC698LP4E](https://www.analog.com/en/search.html#q=HMC698LP4E) (Analog Devices)

*GaAs MMIC PHEMT amplifier, 5-20 GHz, 22 dB gain, 3.5 dB NF, +18 dBm P1dB, 5x5 QFN package, military temp available.*

[📄 Datasheet](https://www.analog.com/en/search.html#q=HMC698LP4E)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-infineon/HMC698LP4E/5867496)

| Spec | Value |
|---|---|
| frequency_range | 5-20 GHz |
| gain | 22 dB |
| noise_figure | 3.5 dB |
| p1db | +18 dBm |
| package | 5x5 mm QFN |
| temperature | -55C to +125C |

**Alternatives:**
- **[TQP3M9036](https://www.qorvo.com/products/d/qa0133)** (Qorvo): Lower NF (2.8 dB) but slightly lower P1dB (+15 dBm)
- **[MAAM-011269](https://www.google.com/search?q=MAAM-011269+datasheet)** (MACOM): Higher P1dB (+20 dBm) but 4 dB NF

**Selection Rationale:** Best NF/Gain combination for military temp with adequate P1dB for input linearity requirement.

### 2. Wideband Mixer Downconverter

**Primary Choice:** [HMC1048LC4](https://www.analog.com/en/search.html#q=HMC1048LC4) (Analog Devices)

*Double-balanced mixer, 6-26 GHz RF/LO, DC-8 GHz IF, -7 dB conversion gain, +20 dBm P1dB, 24-lead LFCC package.*

[📄 Datasheet](https://www.analog.com/en/search.html#q=HMC1048LC4)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-infineon/HMC1048LC4/1888996)

| Spec | Value |
|---|---|
| rf_range | 6-26 GHz |
| lo_range | 6-26 GHz |
| if_range | DC-8 GHz |
| conversion_gain | -7 dB |
| p1db | +20 dBm |
| lo_drive | +13 to +17 dBm |

**Alternatives:**
- **[MAMX-011045](https://www.google.com/search?q=MAMX-011045+datasheet)** (MACOM): Higher isolation but requires +3 dB more LO drive
- **[MMIC-2004](https://www.custommmic.com/documents/datasheets/MMIC-2004.pdf)** (Custom MMIC): Lower insertion loss but narrower bandwidth

**Selection Rationale:** Wideband coverage matches 5-18 GHz requirement with good linearity and moderate LO drive.

### 3. 10 GSPS ADC

**Primary Choice:** [ADC10DX300](https://www.ti.com/product/ADC10DX300) (Texas Instruments)

*10-bit, 10 GSPS RF sampling ADC, 3 GHz analog bandwidth, JESD204B interface, 0.9W power consumption.*

[📄 Datasheet](https://www.ti.com/product/ADC10DX300)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/texas-instruments/ADC10DX300RHBK/5985633)

| Spec | Value |
|---|---|
| resolution | 10 bits |
| sample_rate | 10 GSPS |
| analog_bandwidth | 3 GHz |
| interface | JESD204B |
| sfdr | 59 dBFS |
| snr | 51 dB |

**Alternatives:**
- **[AD9213](https://www.analog.com/en/search.html#q=AD9213)** (Analog Devices): 12-bit resolution but lower sample rate (6.4 GSPS max)
- **[RFADC-4300](https://www.google.com/search?q=RFADC-4300+datasheet)** (Teledyne e2v): Military-screened available but higher power

**Selection Rationale:** 10 GSPS meets sample rate requirement with sufficient bandwidth for 3 GHz IF.

### 4. Wideband IF Amplifier

**Primary Choice:** [ADA4817-1](https://www.analog.com/en/search.html#q=ADA4817-1) (Analog Devices)

*1 GHz bandwidth voltage-feedback op-amp, 18 dB gain, 4 dB NF, low noise (1.3 nV/√Hz), 100 mA output drive.*

[📄 Datasheet](https://www.analog.com/en/search.html#q=ADA4817-1)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-infineon/ADA4817-1ACPZ-R7/2846906)

| Spec | Value |
|---|---|
| bandwidth | 1 GHz |
| gain | 18 dB |
| noise_figure | 4 dB |
| voltage_noise | 1.3 nV/√Hz |
| output_current | 100 mA |

**Alternatives:**
- **[OPA695](https://www.ti.com/product/OPA695)** (Texas Instruments): Lower bandwidth (500 MHz) but lower power
- **[THS4304](https://www.ti.com/product/THS4304)** (Texas Instruments): Higher bandwidth (3 GHz) but higher quiescent current

**Selection Rationale:** Good balance of bandwidth, noise, and drive capability for ADC input.

### 5. Variable Gain Amplifier

**Primary Choice:** [HMC698LP2](https://www.analog.com/en/search.html#q=HMC698LP2) (Analog Devices)

*Digital VGA, DC-6 GHz, 42 dB gain range, 1 dB steps, SPI control, 6.5 dB NF at max gain.*

[📄 Datasheet](https://www.analog.com/en/search.html#q=HMC698LP2)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-infineon/HMC698LP2/4892224)

| Spec | Value |
|---|---|
| bandwidth | DC-6 GHz |
| gain_range | 42 dB |
| step_size | 1 dB |
| control | SPI |
| noise_figure | 6.5 dB |

**Alternatives:**
- **[LMH6517](https://www.ti.com/product/LMH6517)** (Texas Instruments): Analog voltage control instead of digital SPI
- **[AD8372](https://www.analog.com/en/search.html#q=AD8372)** (Analog Devices): Higher bandwidth (750 MHz) but narrower gain range

**Selection Rationale:** Digital SPI control with 42 dB range meets AGC requirement.

### 6. LO Synthesizer

**Primary Choice:** [LMX2594](https://www.ti.com/product/LMX2594) (Texas Instruments)

*Wideband PLL synthesizer, 10 MHz to 15 GHz output, -136 dBc/Hz phase noise @ 1 MHz offset, JESD204B sync.*

[📄 Datasheet](https://www.ti.com/product/LMX2594)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/texas-instruments/LMX2594RHAR/6045738)

| Spec | Value |
|---|---|
| frequency_range | 10 MHz - 15 GHz |
| phase_noise | -136 dBc/Hz @ 1 MHz |
| output_power | -5 to +5 dBm |

**Alternatives:**
- **[ADF5355](https://www.analog.com/en/search.html#q=ADF5355)** (Analog Devices): Lower phase noise but narrower bandwidth
- **[ADF4372](https://www.analog.com/en/search.html#q=ADF4372)** (Analog Devices): Extended frequency to 16 GHz but higher power

**Selection Rationale:** Wideband coverage for 5-18 GHz LO generation with excellent phase noise.

### 7. RF Power Supply DC-DC Converter

**Primary Choice:** [LTM4644](https://www.analog.com/en/search.html#q=LTM4644) (Analog Devices)

*4-output DC-DC uModule regulator, 4A per channel, military temp available, low noise switching.*

[📄 Datasheet](https://www.analog.com/en/search.html#q=LTM4644)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-infineon/LTM4644IY-PBF/5975097)

| Spec | Value |
|---|---|
| inputs | 5V, 12V |
| outputs | 4x configurable (0.8V-15V) |
| current | 4A per channel |
| efficiency | 92% |

**Alternatives:**
- **[TPS65218](https://www.ti.com/product/TPS65218)** (Texas Instruments): Lower output current but PMIC with sequencing
- **[MPM54304](https://www.monolithicpower.com/en/documentview/productdocument/index/version/2/documenttype/1/productnumber/MPM54304/)** (Monolithic Power): Similar specs but QFN package

**Selection Rationale:** Multi-channel supply simplifies power distribution, military temp option available.

### 8. RF Input Limiter/ESD Protection

**Primary Choice:** [GVA-123+](https://www.google.com/search?q=GVA-123%2B+datasheet) (Marki Microwave)

*GaAs limiter, 0.1-20 GHz, 0.5 dB insertion loss, handles 10W peak, ESD protection to 2 kV.*

[📄 Datasheet](https://www.google.com/search?q=GVA-123%2B+datasheet)

| Spec | Value |
|---|---|
| frequency | 0.1-20 GHz |
| insertion_loss | 0.5 dB |
| threshold | +15 dBm |
| power_handling | 10W peak |

**Alternatives:**
- **[RCAT-3000+](https://www.google.com/search?q=RCAT-3000%2B+datasheet)** (Mini-Circuits): Higher insertion loss (1.2 dB) but lower threshold (+10 dBm)

**Selection Rationale:** Minimal insertion loss while protecting front-end from ESD and over-power.

### 9. Bandpass Filter 5-18 GHz

**Primary Choice:** [BP7G5G-18G-C3](https://www.google.com/search?q=BP7G5G-18G-C3+datasheet) (K&L Microwave)

*5-18 GHz bandpass filter, 2.5 dB insertion loss, >40 dB rejection, SMA connectors.*

[📄 Datasheet](https://www.google.com/search?q=BP7G5G-18G-C3+datasheet)

| Spec | Value |
|---|---|
| passband | 5-18 GHz |
| insertion_loss | 2.5 dB |
| rejection | >40 dB |
| vswr | <1.5:1 |

**Alternatives:**
- **[VBF-5200-1800-19-10](https://www.vectortelecom.com/specs.html)** (Vector Telecom): Lower loss (1.8 dB) but larger footprint

**Selection Rationale:** Wideband coverage with good rejection to filter out-of-band signals.

### 10. IF Lowpass Filter 3 GHz

**Primary Choice:** [LFCN-3000+](https://www.minicircuits.com/pdfs/LFCN-3000+.pdf) (Mini-Circuits)

*3 GHz lowpass filter, 1.5 dB insertion loss, >30 dB rejection at 4.5 GHz, SMA connector.*

[📄 Datasheet](https://www.minicircuits.com/pdfs/LFCN-3000+.pdf)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/mini-circuits/LFCN-3000%2B/3890238)

| Spec | Value |
|---|---|
| cutoff | 3 GHz |
| insertion_loss | 1.5 dB |
| rejection | >30 dB @ 4.5 GHz |
| passband_ripple | 0.2 dB |

**Alternatives:**
- **[SLP-3000+](https://www.google.com/search?q=SLP-3000%2B+datasheet)** (Mini-Circuits): Higher rejection (45 dB) but slightly higher loss (2 dB)

**Selection Rationale:** Limits bandwidth to 3 GHz for ADC input, anti-aliasing filter.

### 11. Military-Grade MCU for Control

**Primary Choice:** [STM32H743VIH6](https://www.st.com/en/search.html#q=STM32H743VIH6) (STMicroelectronics)

*ARM Cortex-M7, 480 MHz, 2MB Flash, 1MB RAM, -55 to +125°C, SPI/I2C/UART control interfaces.*

[📄 Datasheet](https://www.st.com/en/search.html#q=STM32H743VIH6)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/stmicroelectronics/STM32H743VIH6/10893786)

| Spec | Value |
|---|---|
| core | Cortex-M7 @ 480 MHz |
| flash | 2 MB |
| ram | 1 MB |
| temperature | -55 to +125C |
| package | 100-pin VFQFPN |

**Alternatives:**
- **[SAMA5D27](https://www.microchip.com/search/searchresults/SAMA5D27)** (Microchip): Cortex-A5 core, higher power but Linux capable
- **[TMS570LS1227](https://www.ti.com/product/TMS570LS1227)** (Texas Instruments): ARM Cortex-R4 with ECC, automotive-qualified

**Selection Rationale:** Military temp grade MCU with sufficient I/O for VGA, LO, and system control.
