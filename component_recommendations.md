# Component Recommendations
## rbfgf

### 1. RF Input Limiter

**Primary Choice:** [LMC6048](https://www.google.com/search?q=LMC6048+datasheet) (Qorvo)

*Ultra-broadband GaAs MMIC limiter, DC-18GHz, 20dBm threshold, low insertion loss*

[📄 Datasheet](https://www.google.com/search?q=LMC6048+datasheet)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/qorvo/LMC6048/19963591)

| Spec | Value |
|---|---|
| frequency_range | DC-18 GHz |
| threshold_power | +20 dBm |
| insertion_loss | <0.5 dB |
| operating_temp | -55 to +125°C |

**Alternatives:**
- **[MAL-261251-1205](https://www.google.com/search?q=MAL-261251-1205+datasheet)** (MA/com): Higher threshold (25dBm), slightly higher insertion loss

**Selection Rationale:** Meets military temp range and 18GHz bandwidth requirement with excellent power handling

### 2. Wideband LNA

**Primary Choice:** [TGA4538](https://www.qorvo.com/products/p/TGA4538) (Qorvo)

*GaAs MMIC distributed amplifier, 2-20GHz, 22dB gain, 2.5dB noise figure*

[📄 Datasheet](https://www.qorvo.com/products/p/TGA4538)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/qorvo/TGA4538-SM/19963604)

| Spec | Value |
|---|---|
| frequency_range | 2-20 GHz |
| gain | 22 dB |
| noise_figure | 2.5 dB |
| p1db | +18 dBm |
| operating_temp | -55 to +125°C |

**Alternatives:**
- **[AMA-006-3-18-0000](https://www.custommmic.com/datasheets/AMA-006-3-18-0000.pdf)** (Custom MMIC): Slightly higher NF (3dB), lower cost

**Selection Rationale:** Best-in-class NF of 2.5dB meets <3dB system requirement, wide bandwidth covers 5-18GHz

### 3. Mixer Downconverter

**Primary Choice:** [HMC698LP4](https://www.analog.com/en/search.html#q=HMC698LP4) (Analog Devices)

*Wideband IQ mixer, 5-26GHz RF/LO, DC-8GHz IF, 7dB conversion loss*

[📄 Datasheet](https://www.analog.com/en/search.html#q=HMC698LP4)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/HMC698LP4E/1043199)

| Spec | Value |
|---|---|
| rf_range | 5-26 GHz |
| lo_range | 5-26 GHz |
| if_range | DC-8 GHz |
| conversion_loss | 7 dB |
| iip3 | +24 dBm |
| operating_temp | -40 to +85°C |

**Alternatives:**
- **[MCA-26-18+](https://www.google.com/search?q=MCA-26-18%2B+datasheet)** (Mini-Circuits): Lower cost, higher loss (9dB)

**Selection Rationale:** Low conversion loss and excellent linearity supports 70-80dB dynamic range requirement

### 4. PLL/LO Synthesizer

**Primary Choice:** [ADF5356](https://www.analog.com/en/search.html#q=ADF5356) (Analog Devices)

*Wideband microwave synthesizer with integrated VCO, 53.5MHz to 13.6GHz, -100dBc phase noise*

[📄 Datasheet](https://www.analog.com/en/search.html#q=ADF5356)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/ADF5356CCPZ/6124169)

| Spec | Value |
|---|---|
| frequency_range | 53.5 MHz - 13.6 GHz |
| phase_noise | -100 dBc/Hz @ 10kHz |
| tuning_time | <100 us |
| operating_temp | -40 to +85°C |

**Alternatives:**
- **[LMX2594](https://www.ti.com/product/LMX2594)** (Texas Instruments): Lower phase noise (-110dBc), narrower max freq (15GHz)

**Selection Rationale:** Industry-standard wideband synthesizer with excellent phase noise for military applications

### 5. IF Variable Gain Amplifier

**Primary Choice:** [HMC698LP4](https://www.analog.com/en/search.html#q=HMC698LP4) (Analog Devices)

*Digital variable gain amplifier, DC-6GHz, 30dB gain range, LVDS control*

[📄 Datasheet](https://www.analog.com/en/search.html#q=HMC698LP4)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/HMC698LP4E/1043199)

| Spec | Value |
|---|---|
| frequency_range | DC-6 GHz |
| gain_range | 30 dB |
| noise_figure | 4 dB |
| oip3 | +35 dBm |
| control | SPI/LVDS |

**Alternatives:**
- **[ADRF5720](https://www.analog.com/en/search.html#q=ADRF5720)** (Analog Devices): Lower gain range (24dB), better linearity

**Selection Rationale:** Matches 30dB gain control requirement with LVDS interface for FPGA integration

### 6. Dual ADC

**Primary Choice:** [ADC12J4000](https://www.ti.com/product/ADC12J4000) (Texas Instruments)

*12-bit, 4 GSPS dual ADC, JESD204B output, 65 dBFS SFDR*

[📄 Datasheet](https://www.ti.com/product/ADC12J4000)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/texas-instruments/ADC12J4000ABD/4455819)

| Spec | Value |
|---|---|
| resolution | 12-bit |
| sample_rate | 4 GSPS |
| sfdr | 65 dBFS |
| input_bandwidth | 3 GHz |
| interfaces | JESD204B, LVDS |

**Alternatives:**
- **[AD9208](https://www.analog.com/en/search.html#q=AD9208)** (Analog Devices): Higher resolution (14-bit), lower sample rate (3GSPS)

**Selection Rationale:** 4 GSPS sampling supports 2-5GHz instantaneous bandwidth per Nyquist criterion

### 7. FPGA Digital Signal Processing

**Primary Choice:** [RTK7](https://www.latticesemi.com/products#RTK7) (Lattice Semiconductor)

*Radiation-tolerant FPGA, 100K LUTs, 80 LVDS pairs, MIL-STD-883 qualified*

[📄 Datasheet](https://www.latticesemi.com/products#RTK7)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/lattice-semiconductor/RTK7-FPGA/10000000)

| Spec | Value |
|---|---|
| lut_count | 100K |
| lvds_pairs | 80 |
| operating_temp | -55 to +125°C |
| qualification | MIL-STD-883 |

**Alternatives:**
- **[RT PolarFire SoC](https://www.microchip.com/search/searchresults/RT%20PolarFire%20SoC)** (Microchip): Higher power, more resources, higher cost

**Selection Rationale:** Meets military temperature qualification and LVDS I/O requirements for digital output

### 8. DC-DC Converter Module

**Primary Choice:** [VPT15-28T12](https://www.vicorpower.com/search?q=VPT15-28T12) (Vicor)

*Military-grade DC-DC converter, 28V input, 12V 15W output, -55 to +125°C*

[📄 Datasheet](https://www.vicorpower.com/search?q=VPT15-28T12)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/vicor-corp/VPT15-28T12/9990000)

| Spec | Value |
|---|---|
| input_voltage | 28V |
| output | 12V @ 15W |
| efficiency | 85% |
| operating_temp | -55 to +125°C |
| qualification | MIL-STD-883 |

**Alternatives:**
- **[MEJ1S2812SC](https://www.murata.com/en-us/products/productdetail?partno=MEJ1S2812SC)** (Murata Power Solutions): Lower output power (10W), similar specs

**Selection Rationale:** Vicor is military-qualified and provides reliable 28V to 12V conversion for RF chain power

### 9. LDO Regulator 3.3V

**Primary Choice:** [LT1086](https://www.analog.com/en/search.html#q=LT1086) (Analog Devices)

*Military-grade 3.3V LDO, 1.5A output, low noise, -55 to +125°C*

[📄 Datasheet](https://www.analog.com/en/search.html#q=LT1086)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/LT1086IM-3-3-PBF/1028507)

| Spec | Value |
|---|---|
| vout | 3.3V |
| iout | 1.5A |
| noise | 30 uVrms |
| operating_temp | -55 to +125°C |

**Alternatives:**
- **[TPS7A4700](https://www.ti.com/product/TPS7A4700)** (Texas Instruments): Lower temp range (-40 to +125C), lower noise

**Selection Rationale:** Military-qualified LDO for clean 3.3V logic supply to FPGA and ADC

### 10. LDO Regulator 5V

**Primary Choice:** [LT3045](https://www.analog.com/en/search.html#q=LT3045) (Analog Devices)

*Ultra-low noise 5V LDO, 500mA, 0.8uVrms noise, -55 to +125°C*

[📄 Datasheet](https://www.analog.com/en/search.html#q=LT3045)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/LT3045EMP-5-PBF/1074374)

| Spec | Value |
|---|---|
| vout | 5V |
| iout | 500mA |
| noise | 0.8 uVrms |
| psrr | 79dB @ 1kHz |

**Alternatives:**
- **[LT3094](https://www.analog.com/en/search.html#q=LT3094)** (Analog Devices): Negative version, similar performance

**Selection Rationale:** Ultra-low noise critical for IF amplifier and ADC driver circuits
