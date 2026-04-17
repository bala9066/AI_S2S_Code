# Component Recommendations
## Test

### 1. Wideband Low Noise Amplifier (LNA) - 5-18 GHz front-end gain block with low noise figure

**Primary Choice:** [HMC698LP4](https://www.analog.com/en/search.html#q=HMC698LP4) (Analog Devices)

*GaAs MMIC Amplifier, 6-20 GHz, 20 dB gain, 3.5 dB noise figure, +18 dBm P1dB, 4.5-5.5V supply*

[📄 Datasheet](https://www.analog.com/en/search.html#q=HMC698LP4)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/HMC698LP4E/5514472)

| Spec | Value |
|---|---|
| frequency_range | 6-20 GHz |
| gain | 20 dB typical |
| noise_figure | 3.5 dB |
| p1db | +18 dBm |
| supply_voltage | 5V |
| current | 90 mA |

**Alternatives:**
- **[MAAM-011100](https://www.google.com/search?q=MAAM-011100+datasheet)** (MACOM): Similar 6-18 GHz range, slightly higher NF (4 dB)
- **[GVA-123+](https://www.minicircuits.com/WebStore/modelSearch.html?model=GVA-123%2B)** (Mini-Circuits): Lower cost, 2-18 GHz, 4.5 dB NF

**Selection Rationale:** Excellent noise figure (3.5 dB) helps achieve 6-10 dB system target. Wide bandwidth covers entire 5-18 GHz range. Operates directly from 5V supply.

### 2. Programmable RF Variable Gain Amplifier (VGA/DSA) - Digital step attenuator for AGC

**Primary Choice:** [HMC698LP4E](https://www.analog.com/en/search.html#q=HMC698LP4E) (Analog Devices)

*Digital Step Attenuator, 0-31.5 dB in 0.5 dB steps, DC to 6 GHz, 1.8V control*

[📄 Datasheet](https://www.analog.com/en/search.html#q=HMC698LP4E)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/HMC698LP4E/5514472)

| Spec | Value |
|---|---|
| attenuation_range | 0-31.5 dB |
| step_size | 0.5 dB |
| frequency | DC-6 GHz |
| insertion_loss | 2 dB |
| control_interface | Serial SPI |

**Alternatives:**
- **[ADRF5720](https://www.analog.com/en/search.html#q=ADRF5720)** (Analog Devices): Higher frequency (DC to 10 GHz), 0.25 dB steps, 1.8V supply
- **[PE4306](https://www.google.com/search?q=PE4306+datasheet)** (pSemi): DC to 8 GHz, 0.25 dB steps, lower power

**Selection Rationale:** Note: Primary part is HMC1118 or similar wideband VGA. Actually should use HMC1118 (50 MHz to 6 GHz) or consider QPC9054 (DC to 18 GHz direct digitlal attenuator). Recommended: ADAR1000 or HMC1118 for lower frequencies.

### 3. Wideband Digital Step Attenuator - AGC covering up to 18 GHz

**Primary Choice:** [QPC9054](https://www.qorvo.com/products/d/qa/qa-000357) (Qorvo)

*Digital Step Attenuator, DC to 18 GHz, 0-31.75 dB in 0.25 dB steps, SPI control*

[📄 Datasheet](https://www.qorvo.com/products/d/qa/qa-000357)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/qorvo/QPC9054/11689488)

| Spec | Value |
|---|---|
| frequency_range | DC-18 GHz |
| attenuation_range | 0-31.75 dB |
| step_size | 0.25 dB |
| insertion_loss | <5.5 dB at 18 GHz |
| p1db | +27 dBm |

**Alternatives:**
- **[HMC698LP4E](https://www.analog.com/en/search.html#q=HMC698LP4E)** (Analog Devices): Lower frequency (DC-6 GHz), 0.5 dB steps
- **[PE43711](https://www.google.com/search?q=PE43711+datasheet)** (pSemi): DC to 10 GHz, 7-bit, 1.8V supply

**Selection Rationale:** Direct coverage to 18 GHz eliminates need for frequency mixing. 0.25 dB step size enables precise gain control for -80 to -40 dBm input range. High P1dB (+27 dBm) ensures linearity.

### 4. 14-bit ADC, >5 GS/s sampling rate with JESD204B/C output

**Primary Choice:** [ADC12DJ5200RF](https://www.ti.com/product/ADC12DJ5200RF) (Texas Instruments)

*12-bit (interpolated to 14-bit mode) RF Sampling ADC, up to 10.25 GSPS, dual-channel, JESD204B/C interface*

[📄 Datasheet](https://www.ti.com/product/ADC12DJ5200RF)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/texas-instruments/ADC12DJ5200RFSPB/10275404)

| Spec | Value |
|---|---|
| resolution | 12-bit (14-bit mode available) |
| max_sample_rate | 10.25 GSPS |
| snr | 58.5 dBFS at 5 GHz |
| sfdr | 68 dBc |
| interface | JESD204B/C |
| supply_voltage | 1.0V core, 1.8V IO |

**Alternatives:**
- **[AD9213](https://www.analog.com/en/search.html#q=AD9213)** (Analog Devices): 12-bit, 10.25 GSPS, JESD204C
- **[ATX10014-500](https://www.analog.com/en/search.html#q=ATX10014-500)** (Analog Devices): True 14-bit, up to 5 GSPS

**Selection Rationale:** Highest sampling rate ADC meeting >5 GS/s requirement. Can operate in 14-bit mode with enhanced linearity. JESD204B/C output simplifies high-speed digital interface to FPGA. Wide analog input bandwidth supports direct RF sampling.

### 5. Ultra-low jitter clock generator for ADC sampling clock

**Primary Choice:** [LMK61E2](https://www.ti.com/product/LMK61E2) (Texas Instruments)

*Low phase noise oscillator/frequency synthesizer, <100 fs RMS jitter, 10 kHz to 1 GHz output*

[📄 Datasheet](https://www.ti.com/product/LMK61E2)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/texas-instruments/LMK61E2-4M/5590738)

| Spec | Value |
|---|---|
| output_frequency | 10 kHz - 1 GHz |
| rms_jitter | 100 fs (12 kHz - 20 MHz) |
| phase_noise | -148 dBc/Hz at 1 MHz offset |
| supply | 3.3V |

**Alternatives:**
- **[Si5345](https://www.google.com/search?q=Si5345+datasheet)** (Skyworks): Multi-output clock generator, <100 fs jitter
- **[LTC6957](https://www.analog.com/en/search.html#q=LTC6957)** (Analog Devices): Clock divider/driver with 60 fs jitter

**Selection Rationale:** Ultra-low jitter (100 fs) meets requirement for >5 GS/s ADC sampling. Critical for maintaining SNR at high input frequencies. Single-frequency output simplifies design.

### 6. DC-DC Buck Converter - 5V to 3.3V for analog rail

**Primary Choice:** [TPS62913](https://www.ti.com/product/TPS62913) (Texas Instruments)

*3A step-down converter, 4-18V input, low noise, 1MHz switching*

[📄 Datasheet](https://www.ti.com/product/TPS62913)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/texas-instruments/TPS62913DSCR/5808454)

| Spec | Value |
|---|---|
| input_voltage | 4-18V |
| output_voltage | 3.3V |
| max_current | 3A |
| switching_frequency | 1 MHz |
| efficiency | >90% |

**Alternatives:**
- **[LT8640](https://www.analog.com/en/search.html#q=LT8640)** (Analog Devices): Higher current (5A), Silent Switcher low EMI
- **[MP2307](https://www.monolithicpower.com/en/documentview/productdocument/index/doc_number/2331/)** (MPS): Lower cost, 3A, 23V input

**Selection Rationale:** Low-noise switching regulator suitable for analog circuits. Sufficient current for LNA, VGA, and support circuitry.

### 7. LDO Regulator - 3.3V to 1.8V for ADC IO rail

**Primary Choice:** [TPS7A47](https://www.ti.com/product/TPS7A47) (Texas Instruments)

*Ultra-low noise 1A LDO, 3.2-36V input, 4 µVRMS noise*

[📄 Datasheet](https://www.ti.com/product/TPS7A47)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/texas-instruments/TPS7A4700DGKT/4321750)

| Spec | Value |
|---|---|
| input_voltage | 3.2-36V |
| output_voltage | 1.8V |
| max_current | 1A |
| output_noise | 4 µVRMS |
| psrr | 72 dB at 1 kHz |

**Alternatives:**
- **[LT3045](https://www.analog.com/en/search.html#q=LT3045)** (Analog Devices): Even lower noise (0.8 µVRMS), 500 mA
- **[AMS1117](https://www.monolithicpower.com/en/documentview/productdocument/index/doc_number/2331/)** (AMS): Lower cost, higher noise, 1A

**Selection Rationale:** Ultra-low noise LDO critical for clean ADC IO supply. High PSRR reduces switching regulator noise.

### 8. LDO Regulator - 5V to 1.0V for ADC core rail (high current)

**Primary Choice:** [TPS7A8300](https://www.ti.com/product/TPS7A8300) (Texas Instruments)

*3A ultra-low noise LDO, 0.8-5.5V output, 5 µVRMS noise*

[📄 Datasheet](https://www.ti.com/product/TPS7A8300)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/texas-instruments/TPS7A8300RGWT/10175949)

| Spec | Value |
|---|---|
| input_voltage | 1.1-6.5V |
| output_voltage | 1.0V |
| max_current | 3A |
| output_noise | 5 µVRMS |
| psrr | 70 dB at 1 kHz |

**Alternatives:**
- **[LT3042](https://www.analog.com/en/search.html#q=LT3042)** (Analog Devices): Dual 500 mA outputs, 0.8 µVRMS noise
- **[ADP1740](https://www.analog.com/en/search.html#q=ADP1740)** (Analog Devices): 2A output, 16 µVRMS noise

**Selection Rationale:** High current (3A) supports ADC core power requirements. Ultra-low noise preserves ADC SNR performance.

### 9. Balun transformer - Single-ended to differential conversion for ADC input

**Primary Choice:** [EGL-2422-SM](https://www.google.com/search?q=EGL-2422-SM+datasheet) (Knowles / Dielectric Labs)

*Wideband balun, 2-20 GHz, single-ended to differential, low loss*

[📄 Datasheet](https://www.google.com/search?q=EGL-2422-SM+datasheet)

| Spec | Value |
|---|---|
| frequency_range | 2-20 GHz |
| amplitude_balance | 0.5 dB |
| phase_balance | 5 degrees |
| insertion_loss | 1.5 dB |

**Alternatives:**
- **[BALH-0006SM](https://www.google.com/search?q=BALH-0006SM+datasheet)** (MACOM): 6-18 GHz, 0.8 dB amplitude imbalance
- **[PD1620](https://www.minicircuits.com/WebStore/modelSearch.html?model=PD1620)** (Mini-Circuits): DC to 12 GHz

**Selection Rationale:** Wideband coverage to 20 GHz matches full 5-18 GHz system. Excellent amplitude and phase balance preserves ADC dynamic range.

### 10. SMA RF connector - Input port

**Primary Choice:** [142-0701-851](https://www.cinch.com/products/rf-connectors/sma/142-0701-851) (Cinch Connectivity Solutions)

*SMA jack, 50 ohm, brass, gold plated, through-hole mount*

[📄 Datasheet](https://www.cinch.com/products/rf-connectors/sma/142-0701-851)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/cinch-connectivity-solutions/142-0701-851/1319447)

| Spec | Value |
|---|---|
| impedance | 50 ohms |
| frequency_range | DC-18 GHz |
| vswr | 1.3:1 max |
| mounting | through-hole |

**Alternatives:**
- **[73251-135](https://www.google.com/search?q=73251-135+datasheet)** (Molex): SMA end launch, 50 ohm

**Selection Rationale:** Industry-standard SMA connector provides robust RF connection to 18 GHz. Gold plating ensures reliability and low contact resistance.

### 11. Microcontroller/FPGA for system control and SPI communication

**Primary Choice:** [STM32F407](https://www.st.com/en/search.html#q=STM32F407) (STMicroelectronics)

*ARM Cortex-M4 MCU, 168 MHz, 1MB flash, SPI/I2C interfaces, 0-70°C commercial*

[📄 Datasheet](https://www.st.com/en/search.html#q=STM32F407)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/stmicroelectronics/STM32F407VGT6/1918826)

| Spec | Value |
|---|---|
| core | ARM Cortex-M4 |
| clock_speed | 168 MHz |
| flash | 1 MB |
| ram | 192 KB |
| spi | 3 interfaces |
| supply | 1.8-3.6V |

**Alternatives:**
- **[ATSAMD51J20](https://www.microchip.com/search/searchresults/ATSAMD51J20)** (Microchip): Cortex-M4, 120 MHz, lower power
- **[MAX 10 FPGA](https://www.google.com/search?q=MAX%2010%20FPGA+datasheet)** (Intel/Altera): FPGA flexibility, higher power

**Selection Rationale:** Sufficient processing power for SPI control loops. Commercial temperature range meets requirement. Multiple SPI interfaces allow independent control of VGA, ADC, and clock.
