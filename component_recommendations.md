# Component Recommendations
## sdfjbks

### 1. Wideband RF Low Noise Amplifier covering 5-18 GHz

**Primary Choice:** [HMC6180LP4E](https://www.analog.com/en/search.html#q=HMC6180LP4E) (Analog Devices)

*GaAs MMIC LNA, 2-20 GHz, 20 dB gain, 3.5 dB noise figure, +33 dBm OIP3*

[📄 Datasheet](https://www.analog.com/en/search.html#q=HMC6180LP4E)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-infineon/HMC6180LP4E/5853003)

| Spec | Value |
|---|---|
| frequency_range | 2-20 GHz |
| gain | 20 dB |
| noise_figure | 3.5 dB |
| p1db | +18 dBm |
| supply_voltage | 5V |
| current | 80 mA |

**Alternatives:**
- **[TQP3M9036](https://www.qorvo.com/products/d/da001767)** (Qorvo): Similar performance, lower NF at 2.8 dB, but limited to 6 GHz

**Selection Rationale:** Selected for wide frequency coverage meeting 5-18 GHz requirement with adequate gain and noise figure

### 2. Wideband IQ Mixer for downconversion

**Primary Choice:** [HMC1051LP4E](https://www.analog.com/en/search.html#q=HMC1051LP4E) (Analog Devices)

*IQ Mixer, 6-18 GHz, 8 dB conversion loss, LO+10 to +20 dBm drive*

[📄 Datasheet](https://www.analog.com/en/search.html#q=HMC1051LP4E)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-infineon/HMC1051LP4E/5852245)

| Spec | Value |
|---|---|
| rf_range | 6-18 GHz |
| lo_range | 6-18 GHz |
| if_range | DC-6 GHz |
| conversion_loss | 8 dB |
| lo_drive | +16 dBm |

**Alternatives:**
- **[MM1-0618HSM](https://www.google.com/search?q=MM1-0618HSM+datasheet)** (Marki Microwave): Superior linearity and lower conversion loss at 6 dB, but higher cost

**Selection Rationale:** Wideband IQ mixer enables direct downconversion within 5-18 GHz range with good linearity

### 3. Wideband synthesizer with low phase noise

**Primary Choice:** [ADF5356](https://www.analog.com/en/search.html#q=ADF5356) (Analog Devices)

*Microwave PLL synthesizer, 53.125 MHz to 13.6 GHz, -100 dBc/Hz phase noise at 10 kHz offset*

[📄 Datasheet](https://www.analog.com/en/search.html#q=ADF5356)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices/ADF5356CCPZ/7996220)

| Spec | Value |
|---|---|
| frequency_range | 53.125 MHz - 13.6 GHz |
| phase_noise | -100 dBc/Hz @ 10 kHz |
| freq_settling_time | 100 us |
| supply_voltage | 3.3V/5V |

**Alternatives:**
- **[LMX2594](https://www.ti.com/product/LMX2594)** (Texas Instruments): Wider frequency range up to 15 GHz, similar phase noise performance

**Selection Rationale:** Low phase noise critical for receiver sensitivity; covers LO frequency requirements

### 4. Direct RF sampling ADC with JESD204B

**Primary Choice:** [ADC12DJ5200RF](https://www.ti.com/product/ADC12DJ5200RF) (Texas Instruments)

*12-bit dual-channel ADC, up to 5.2 GSPS, JESD204B 12.5 Gbps lane rate, 6.5 GHz input bandwidth*

[📄 Datasheet](https://www.ti.com/product/ADC12DJ5200RF)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/texas-instruments/ADC12DJ5200RFAB/6175659)

| Spec | Value |
|---|---|
| resolution | 12-bit |
| max_sample_rate | 5.2 GSPS |
| input_bandwidth | 6.5 GHz |
|  jesd_lane_rate | 12.5 Gbps |
| snr | 57 dBFS |
| supply | 1.2V/1.8V |

**Alternatives:**
- **[AD9213](https://www.analog.com/en/search.html#q=AD9213)** (Analog Devices): 10-bit resolution but 10.25 GSPS sample rate, lower power

**Selection Rationale:** Only ADC meeting 3+ GSPS requirement with integrated JESD204B interface for 5-18 GHz direct sampling or IF sampling

### 5. Wideband variable gain amplifier

**Primary Choice:** [HMC698LP4](https://www.analog.com/en/search.html#q=HMC698LP4) (Analog Devices)

*Digital VGA, DC-7 GHz, 31 dB gain range, 1 dB steps, +30 dBm OIP3*

[📄 Datasheet](https://www.analog.com/en/search.html#q=HMC698LP4)

| Spec | Value |
|---|---|
| frequency_range | DC-7 GHz |
| gain_range | 31 dB |
| gain_step | 1 dB |
| p1db | +15 dBm |
| noise_figure | 6 dB |

**Alternatives:**
- **[ADL5202](https://www.analog.com/en/search.html#q=ADL5202)** (Analog Devices): Wider bandwidth up to 10 GHz but lower OIP3 at +26 dBm

**Selection Rationale:** Provides AGC functionality with digital control and adequate linearity for receiver dynamic range

### 6. RF Bandpass filter 5-18 GHz

**Primary Choice:** [BP06S-18S-A-SMA+](https://www.google.com/search?q=BP06S-18S-A-SMA%2B+datasheet) (Mini-Circuits)

*Bandpass filter, 5-18 GHz, 2 dB insertion loss, 50 ohm SMA connector*

[📄 Datasheet](https://www.google.com/search?q=BP06S-18S-A-SMA%2B+datasheet)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/minicircuits/BP06S-18S-A-SMA/3902529)

| Spec | Value |
|---|---|
| passband | 5-18 GHz |
| insertion_loss | 2 dB |
| return_loss | 14 dB |
| power_handling | 1W |

**Alternatives:**
- **[CBP-1800+](https://www.google.com/search?q=CBP-1800%2B+datasheet)** (Mini-Circuits): Wider passband 1-18 GHz with slightly higher insertion loss at 3 dB

**Selection Rationale:** Defines receiver input bandwidth and provides out-of-band rejection for image suppression

### 7. RF input connector 5-18 GHz

**Primary Choice:** [142-0701-841](https://www.google.com/search?q=142-0701-841+datasheet) (Cristek)

*2.4mm female coaxial connector, panel mount, 50 ohm, DC to 50 GHz*

[📄 Datasheet](https://www.google.com/search?q=142-0701-841+datasheet)

| Spec | Value |
|---|---|
| frequency_range | DC - 50 GHz |
| vswr | 1.25:1 max |
| impedance | 50 ohms |
| mounting | Panel mount |

**Alternatives:**
- **[232101-2](https://www.google.com/search?q=232101-2+datasheet)** (Huber+Suhner): SMA connector to 18 GHz, lower cost but reduced frequency margin

**Selection Rationale:** 2.4mm connector required for optimal performance up to 18 GHz with low VSWR

### 8. Buck converter 5V to 1.2V for ADC

**Primary Choice:** [TPS62913](https://www.ti.com/product/TPS62913) (Texas Instruments)

*Step-down converter, 4-18V input, 1.2V output, 10A, low noise for ADC supplies*

[📄 Datasheet](https://www.ti.com/product/TPS62913)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/texas-instruments/TPS62913RPWR/10257312)

| Spec | Value |
|---|---|
| vin | 4-18V |
| vout | 0.6-5.5V |
| iout | 10A |
| switching_freq | 500 kHz - 2.2 MHz |
| efficiency | 95% |

**Alternatives:**
- **[LT8636](https://www.analog.com/en/search.html#q=LT8636)** (Analog Devices): Similar specs with wider input range up to 42V, higher quiescent current

**Selection Rationale:** Provides high current 1.2V rail for ADC with low switching noise, critical for conversion performance

### 9. Buck converter 5V to 3.3V for RF front-end

**Primary Choice:** [TPS562201](https://www.ti.com/product/TPS562201) (Texas Instruments)

*Step-down converter, 4.5-17V input, 3.3V output, 2A, SOT-23-6*

[📄 Datasheet](https://www.ti.com/product/TPS562201)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/texas-instruments/TPS562201DDCR/7958675)

| Spec | Value |
|---|---|
| vin | 4.5-17V |
| vout | 0.8-6V |
| iout | 2A |
| switching_freq | 500 kHz |
| efficiency | 92% |

**Alternatives:**
- **[LMZM23601](https://www.ti.com/product/LMZM23601)** (Texas Instruments): Power module version with integrated inductor, simpler layout

**Selection Rationale:** Cost-effective solution for 3.3V rail supplying LNA and mixer bias circuits

### 10. LDO 5V to 1.8V for JESD204B interface

**Primary Choice:** [TPS7A47](https://www.ti.com/product/TPS7A47) (Texas Instruments)

*Low-noise LDO, 1A output, 4.5 uVrms noise, for clean digital supply*

[📄 Datasheet](https://www.ti.com/product/TPS7A47)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/texas-instruments/TPS7A4700DGKR/4691395)

| Spec | Value |
|---|---|
| vin | 3-20V |
| vout | 1.2-19V |
| iout | 1A |
| noise | 4.5 uVrms |
| psrr | 72 dB @ 1kHz |

**Alternatives:**
- **[LT3045](https://www.analog.com/en/search.html#q=LT3045)** (Analog Devices): Ultra-low noise 0.8 uVrms, lower current 500mA

**Selection Rationale:** Low-noise LDO critical for JESD204B PHY supply to minimize bit errors in high-speed data lanes

### 11. Microcontroller for system control

**Primary Choice:** [STM32F407VGT6](https://www.st.com/en/search.html#q=STM32F407VGT6) (STMicroelectronics)

*ARM Cortex-M4, 168MHz, 1MB Flash, SPI/I2C interfaces for gain/LO control*

[📄 Datasheet](https://www.st.com/en/search.html#q=STM32F407VGT6)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/stmicroelectronics/STM32F407VGT6/1773632)

| Spec | Value |
|---|---|
| core | Cortex-M4F |
| clock | 168MHz |
| flash | 1MB |
| ram | 192KB |
| spi | 3 |
| i2c | 3 |
| supply | 1.8-3.6V |

**Alternatives:**
- **[ATSAMV71Q21](https://www.microchip.com/search/searchresults/ATSAMV71Q21)** (Microchip): Cortex-M7 at 300MHz with ECC, pin-compatible alternative

**Selection Rationale:** Provides SPI/I2C interfaces for VGA, synthesizer, and ADC programming with sufficient I/O for system monitoring
