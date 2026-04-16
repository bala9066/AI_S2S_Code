# Component Recommendations
## rx receiver

### 1. Wideband Low Noise Amplifier (5-18 GHz)

**Primary Choice:** [HMC6180LP4E](https://www.analog.com/en/search.html#q=HMC6180LP4E) (Analog Devices)

*GaAs MMIC PHEMT LNA, 2-20 GHz, 20 dB gain, 2.5 dB noise figure, +15 dBm P1dB, operates from 5V supply.*

[📄 Datasheet](https://www.analog.com/en/search.html#q=HMC6180LP4E)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-infineon/HMC6180LP4E/7244264)

| Spec | Value |
|---|---|
| frequency_range | 2-20 GHz |
| gain | 20 dB |
| noise_figure | 2.5 dB |
| p1db | +15 dBm |
| supply_voltage | +5V |
| current | 90 mA |

**Alternatives:**
- **[MAAL-011141](https://www.google.com/search?q=MAAL-011141+datasheet)** (Macom): Slightly higher NF (3.5 dB) but lower power (50 mW)
- **[TQP3M9036](https://www.qorvo.com/products/p/TQP3M9036)** (Qorvo): Wider bandwidth (DC-20 GHz) with similar gain

**Selection Rationale:** Selected for excellent noise figure (2.5 dB) well within 4-6 dB requirement, wideband coverage exceeding 5-18 GHz, and high gain to set system noise floor. Operating temperature range and RoHS compliance meet requirements.

### 2. IQ Demodulator Mixer (5-18 GHz)

**Primary Choice:** [HMC519LC4](https://www.analog.com/en/search.html#q=HMC519LC4) (Analog Devices)

*IQ demodulator, 5-12 GHz, 10 dB conversion gain, excellent I/Q balance, operates from 5V supply.*

[📄 Datasheet](https://www.analog.com/en/search.html#q=HMC519LC4)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-infineon/HMC519LC4/7244116)

| Spec | Value |
|---|---|
| rf_frequency | 5-12 GHz |
| lo_frequency | 5-12 GHz |
| if_bandwidth | DC to 2 GHz |
| conversion_gain | 10 dB |
| lo_drive | 0 to +5 dBm |
| supply_voltage | +5V |

**Alternatives:**
- **[MIXIQ-0827](https://www.google.com/search?q=MIXIQ-0827+datasheet)** (Marki Microwave): Higher frequency (8-27 GHz) coverage, better isolation
- **[ADL5380](https://www.analog.com/en/search.html#q=ADL5380)** (Analog Devices): 700 MHz to 2.7 GHz, lower frequency range

**Selection Rationale:** Optimized for 5-12 GHz range covering lower portion of band with excellent I/Q balance critical for SFDR performance. Integrated LO buffer reduces external component count.

### 3. Wideband IQ Mixer (8-18 GHz) - Upper Band Option

**Primary Choice:** [MIXIQ-1030](https://www.google.com/search?q=MIXIQ-1030+datasheet) (Marki Microwave)

*IQ mixer, 10-30 GHz, ultra-broadband, excellent phase and amplitude balance, LO drive 0-15 dBm.*

[📄 Datasheet](https://www.google.com/search?q=MIXIQ-1030+datasheet)

| Spec | Value |
|---|---|
| rf_frequency | 10-30 GHz |
| if_bandwidth | DC to 12 GHz |
| conversion_loss | 8 dB |
| lo_drive | +10 to +15 dBm |
| amplitude_balance | 0.5 dB |

**Alternatives:**
- **[HMC694LP4](https://www.analog.com/en/search.html#q=HMC694LP4)** (Analog Devices): 6-18 GHz, slightly higher conversion loss

**Selection Rationale:** Covers upper frequency band (10-30 GHz) complementing HMC519. Marki mixers offer industry-leading balance for superior SFDR performance.

### 4. PLL/Frequency Synthesizer with Integrated VCO

**Primary Choice:** [LMX2594](https://www.ti.com/product/LMX2594) (Texas Instruments)

*Wideband PLL synthesizer with integrated VCO, 10 MHz to 20 GHz, -134 dBc/Hz phase noise at 1 MHz offset, ultra-low noise floor.*

[📄 Datasheet](https://www.ti.com/product/LMX2594)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/texas-instruments/LMX2594RHAR/5964825)

| Spec | Value |
|---|---|
| frequency_range | 10 MHz to 20 GHz |
| phase_noise | -134 dBc/Hz at 1 MHz offset |
| vco_phase_noise | -101 dBc/Hz at 100 kHz offset |
| rf_output_power | -2 to +5 dBm |
| supply_voltage | 3.3V |

**Alternatives:**
- **[ADF5356](https://www.analog.com/en/search.html#q=ADF5356)** (Analog Devices): Similar performance, different SPI interface
- **[HMC7044](https://www.analog.com/en/search.html#q=HMC7044)** (Analog Devices): Better phase noise but higher power consumption

**Selection Rationale:** Best-in-class phase noise (-101 to -134 dBc/Hz) easily meets -80 to -85 dBc/Hz requirement. Wideband VCO covers entire 5-18 GHz range. Low power consumption supports 10-20W budget.

### 5. Variable Gain IF Amplifier

**Primary Choice:** [HMC698LP4](https://www.analog.com/en/search.html#q=HMC698LP4) (Analog Devices)

*Digital variable gain amplifier, DC to 6 GHz, 31 dB gain range, 1 LSB resolution, SPI programmable.*

[📄 Datasheet](https://www.analog.com/en/search.html#q=HMC698LP4)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-infineon/HMC698LP4/7244180)

| Spec | Value |
|---|---|
| bandwidth | DC to 6 GHz |
| gain_range | 31 dB |
| gain_step | 1 dB |
| noise_figure | 6 dB |
| output_ip3 | +30 dBm |

**Alternatives:**
- **[AD8368](https://www.analog.com/en/search.html#q=AD8368)** (Analog Devices): VGA with analog control, lower cost
- **[HMC680LP4](https://www.analog.com/en/search.html#q=HMC680LP4)** (Analog Devices): Higher frequency (up to 12 GHz)

**Selection Rationale:** SPI-controlled VGA enables digital gain control (REQ-HW-015). 31 dB range supports system dynamic range requirements. DC-6 GHz bandwidth covers entire IF output from mixers.

### 6. Dual High-Speed ADC for I/Q Digitization

**Primary Choice:** [ADC12DJ3200](https://www.ti.com/product/ADC12DJ3200) (Texas Instruments)

*Dual-channel 12-bit ADC, up to 6.4 GSPS, 3.2 GSPS per channel, JESD204B interface, SFDR up to 75 dBc at 2 GHz.*

[📄 Datasheet](https://www.ti.com/product/ADC12DJ3200)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/texas-instruments/ADC12DJ3200AAV/6004449)

| Spec | Value |
|---|---|
| resolution | 12-bit |
| max_sample_rate | 6.4 GSPS |
| channels | 2 dual-channel |
| input_bandwidth | 3.2 GHz |
| sfdr | 75 dBc at 2 GHz |
| interface | JESD204B |

**Alternatives:**
- **[AD9208](https://www.analog.com/en/search.html#q=AD9208)** (Analog Devices): Single channel 14-bit at 3 GSPS
- **[EV12AQ600](https://www.google.com/search?q=EV12AQ600+datasheet)** (Teledyne e2v): Quad-channel 12-bit 1.6 GSPS

**Selection Rationale:** Dual-channel architecture captures I and Q signals simultaneously. 3.2 GHz sample rate exceeds 1-2 GHz instantaneous bandwidth requirement (Nyquist criterion). JESD204B interface standard for FPGA connectivity.

### 7. FPGA for Digital Signal Processing

**Primary Choice:** [XCZU4EV-SFVC784](https://www.amd.com/en/search/site-keyword-search.html#q=XCZU4EV-SFVC784) (AMD (Xilinx))

*Zynq UltraScale+ MPSoC, 4th Gen ARM Cortex-A53 + Cortex-R5, 53K logic cells, 3.3 Mb BRAM, integrated JESD204B IP.*

[📄 Datasheet](https://www.amd.com/en/search/site-keyword-search.html#q=XCZU4EV-SFVC784)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/amd/xczu4ev-sfvc784-1-e/6243122)

| Spec | Value |
|---|---|
| logic_cells | 53,200 |
| bram | 3.3 Mb |
| dsp_slices | 192 |
| transceivers | 4x 12.5 Gbps GTY |
| arm_cores | 2x A53 + 2x R5 |
| power | approx 5W |

**Alternatives:**
- **[ Cyclone 10 GX](https://www.google.com/search?q=%20Cyclone%2010%20GX+datasheet)** (Intel (Altera)): Lower power but fewer transceivers
- **[LFE5UM-85](https://www.latticesemi.com/products#LFE5UM-85)** (Lattice Semiconductor): Lower cost, lower power, smaller device

**Selection Rationale:** Zynq UltraScale+ integrates ARM cores for control and FPGA fabric for DSP. 4 high-speed transceivers support JESD204B interface to ADC. Sufficient DSP slices for digital filtering and FFT operations. Industrial temperature grade available.

### 8. ARM Cortex MCU for System Control

**Primary Choice:** [STM32H753BI](https://www.st.com/en/search.html#q=STM32H753BI) (STMicroelectronics)

*ARM Cortex-M7 MCU, 480 MHz, 2 MB Flash, 1 MB RAM, multiple SPI/I2C/UART, USB HS, -40 to +85°C.*

[📄 Datasheet](https://www.st.com/en/search.html#q=STM32H753BI)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/stmicroelectronics/STM32H753BIT6/9599021)

| Spec | Value |
|---|---|
| core | ARM Cortex-M7 |
| frequency | 480 MHz |
| flash | 2 MB |
| ram | 1 MB |
| spi | 4 |
| i2c | 3 |
| usb | HS |
| temperature | -40 to +85°C |

**Alternatives:**
- **[ATSAME70Q21](https://www.microchip.com/search/searchresults/ATSAME70Q21)** (Microchip): Cortex-M7, similar performance, different ecosystem
- **[TM4C129X](https://www.ti.com/product/TM4C129XNCZAD)** (Texas Instruments): Cortex-M4F, lower cost but less performance

**Selection Rationale:** Cortex-M7 provides ample processing for control loop and host communication. Multiple SPI/I2C interfaces support control of PLL, VGA, ADC, and FPGA. USB High Speed enables host PC interface. Industrial temperature rating meets requirements.

### 9. Wideband Bandpass Filter (5-18 GHz)

**Primary Choice:** [CBP-1800-S+](https://www.minicircuits.com/WebStore/dashboard.html?model=CBP-1800%2B) (Mini-Circuits)

*Surface mount bandpass filter, 5-18 GHz, 2.5 dB insertion loss, 30 dB rejection at 3 GHz and 23 GHz.*

[📄 Datasheet](https://www.minicircuits.com/WebStore/dashboard.html?model=CBP-1800%2B)

| Spec | Value |
|---|---|
| passband | 5-18 GHz |
| insertion_loss | 2.5 dB |
| rejection | 30 dB @ out-of-band |
| vswr | 2.0:1 |
| package | SMT 5x5 mm |

**Alternatives:**
- **[BP-5-18G-S+](https://www.google.com/search?q=BP-5-18G-S%2B+datasheet)** (Kratos (General Microwave)): Similar specs, different form factor
- **[RBP-5-18+](https://www.minicircuits.com/WebStore/dashboard.html?model=RBP-5-18%2B)** (Mini-Circuits): Higher rejection (40 dB) but larger footprint

**Selection Rationale:** Defines system bandwidth and provides out-of-band rejection for image and spurious signal suppression. Low insertion loss (2.5 dB) contributes to noise figure budget.

### 10. 12V to 5V DC-DC Converter

**Primary Choice:** [LTM4644](https://www.google.com/search?q=LTM4644+datasheet) (Analog Devices (Linear Technology))

*Quad-output step-down regulator module, 4A per channel, 4.5-28V input, high efficiency, low noise, integrated inductors.*

[📄 Datasheet](https://www.google.com/search?q=LTM4644+datasheet)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-infineon/LTM4644IV%23PBF/5289734)

| Spec | Value |
|---|---|
| input_voltage | 4.5-28V |
| output_voltage | 0.6-5V |
| output_current | 4A per channel |
| efficiency | 92% at 12V in 5V out |
| switching_frequency | 1 MHz |

**Alternatives:**
- **[TPS62913](https://www.ti.com/product/TPS62913)** (Texas Instruments): Single output, lower power (3A)
- **[BMR491](https://www.vicorpower.com/search?q=BMR491)** (Vicor): Higher power density, higher cost

**Selection Rationale:** Module integrates inductors and minimizes design complexity. Quad outputs allow generation of 5V, 3.3V, and 1.8V rails from single 12V supply. High efficiency reduces power consumption and thermal load.

### 11. RF Input Connector

**Primary Choice:** [142-0701-851](https://www.google.com/search?q=142-0701-851+datasheet) (Corry Micronics)

*SMA PCB jack, 50 ohm, 0-18 GHz, low loss VSWR 1.3:1, solder mount for 0.062" board.*

[📄 Datasheet](https://www.google.com/search?q=142-0701-851+datasheet)

| Spec | Value |
|---|---|
| frequency_range | DC-18 GHz |
| impedance | 50 ohms |
| vswr | 1.3:1 max |
| mounting | PCB edge launch |
| contact_material | Beryllium copper gold plated |

**Alternatives:**
- **[132143](https://www.te.com/en/search.html#q=132143)** (TE Connectivity): Similar specs, different manufacturer
- **[086-1-4-3-100-8-12-0](https://www.google.com/search?q=086-1-4-3-100-8-12-0+datasheet)** (Molex): 2.4mm connector for higher frequency applications

**Selection Rationale:** SMA connector is standard for 5-18 GHz applications. Provides 50 ohm impedance matching with low VSWR (<1.3:1). PCB edge mount simplifies layout.

### 12. IF Low Pass Filter (2 GHz cutoff)

**Primary Choice:** [LPF-2000-S+](https://www.minicircuits.com/WebStore/dashboard.html?model=LPF-2000%2B) (Mini-Circuits)

*Surface mount low pass filter, DC-2 GHz, 1.5 dB insertion loss, 40 dB rejection at 3 GHz.*

[📄 Datasheet](https://www.minicircuits.com/WebStore/dashboard.html?model=LPF-2000%2B)

| Spec | Value |
|---|---|
| cutoff_frequency | 2.0 GHz |
| passband | DC-2 GHz |
| insertion_loss | 1.5 dB |
| rejection | 40 dB @ 3 GHz |
| vswr | 1.5:1 |

**Alternatives:**
- **[NLP-2000+](https://www.minicircuits.com/WebStore/dashboard.html?model=NLP-2000%2B)** (Mini-Circuits): Higher rejection (50 dB) but larger footprint
- **[HLPL2-2000](https://www.google.com/search?q=HLPL2-2000+datasheet)** (Kratos): Surface mount, similar specs

**Selection Rationale:** Anti-aliasing filter for ADC input. Defines IF bandwidth (2 GHz) to meet instantaneous bandwidth requirement. Low insertion loss preserves signal-to-noise ratio.
