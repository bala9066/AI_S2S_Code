# Component Recommendations
## rf tx

### 1. Wideband Low Noise Amplifier 5-18 GHz with 20 dB gain, 3 dB noise figure, +15 dBm P1dB

**Primary Choice:** [HMC1049LP3E](https://www.analog.com/media/en/technical-documentation/data-sheets/hmc1049lp3e.pdf) (Analog Devices)

*GaAs MMIC PHEMT distributed amplifier, 5-20 GHz, 20 dB gain, 3 dB noise figure, +15 dBm P1dB in QFN package*

[📄 Datasheet](https://www.analog.com/media/en/technical-documentation/data-sheets/hmc1049lp3e.pdf)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/hmc1049lp3e/5589062)

| Spec | Value |
|---|---|
| Frequency Range | 5-20 GHz |
| Gain | 20 dB |
| Noise Figure | 3 dB |
| P1dB | +15 dBm |
| Supply | +5V @ 120 mA |

**Alternatives:**
- **[TGA4509-SM](https://www.qorvo.com/products/d/rsa007249)** (Qorvo): Slightly higher noise figure (3.5 dB) but wider bandwidth (2-20 GHz)

**Selection Rationale:** Best-in-class noise figure of 3 dB at 5-18 GHz ensures system meets 6 dB target NF. High P1dB of +15 dBm provides good linearity.

### 2. Wideband Mixer for 5-18 GHz downconversion to 2.4 GHz IF with +10 dBm LO drive

**Primary Choice:** [HMC1052LP4GE](https://www.analog.com/media/en/technical-documentation/data-sheets/hmc1052lp4ge.pdf) (Analog Devices)

*GaAs MMIC mixer, 5-20 GHz RF/LO, DC-6 GHz IF, +7 dB conversion gain, +10 dBm LO drive, 24-lead QFN*

[📄 Datasheet](https://www.analog.com/media/en/technical-documentation/data-sheets/hmc1052lp4ge.pdf)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/hmc1052lp4e/5589065)

| Spec | Value |
|---|---|
| RF/LO Range | 5-20 GHz |
| IF Range | DC-6 GHz |
| Conversion Gain | +7 dB |
| LO Drive | +10 dBm |
| IP3 | +20 dBm |

**Alternatives:**
- **[MCA-28+](https://www.minicircuits.com/pdfs/MCA-28+.pdf)** (Mini-Circuits): Lower LO drive requirement (+7 dBm) but lower conversion gain (5 dB)

**Selection Rationale:** Active mixer provides +7 dB conversion gain reducing VGA requirements. High IP3 of +20 dBm supports target IIP3 specification.

### 3. Wideband Frequency Synthesizer 7.4-20.4 GHz LO generation with kHz tuning resolution

**Primary Choice:** [HMC830LP6GE](https://www.analog.com/media/en/technical-documentation/data-sheets/hmc830lp6ge.pdf) (Analog Devices)

*Fractional-N PLL synthesizer, 25 MHz to 3 GHz output (with multipliers to 20 GHz), <50 kHz tuning resolution, -136 dBc/Hz phase noise*

[📄 Datasheet](https://www.analog.com/media/en/technical-documentation/data-sheets/hmc830lp6ge.pdf)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/hmc830lp6ge/6126156)

| Spec | Value |
|---|---|
| Frequency Range | 25 MHz - 3 GHz (x6-8 to 20 GHz) |
| Tuning Resolution | <50 kHz |
| Phase Noise | -136 dBc/Hz @ 1 MHz |
| Supply | +3.3V @ 320 mA |

**Alternatives:**
- **[LMX2594](https://www.ti.com/lit/ds/symlink/lmx2594.pdf)** (Texas Instruments): Lower phase noise but requires external multipliers for 20 GHz

**Selection Rationale:** Integrated wideband synthesizer eliminates need for external multipliers. Excellent phase noise enables CW signal detection.

### 4. Variable Gain Amplifier IF stage with 40 dB gain control range at 2.4 GHz

**Primary Choice:** [HMC698LP4](https://www.analog.com/media/en/technical-documentation/data-sheets/hmc698lp4.pdf) (Analog Devices)

*Digital VGA, 0.05-6 GHz, 44 dB gain range, 1 dB steps, +18 dBm P1dB, SPI control, 24-lead QFN*

[📄 Datasheet](https://www.analog.com/media/en/technical-documentation/data-sheets/hmc698lp4.pdf)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/hmc698lp4/6126188)

| Spec | Value |
|---|---|
| Frequency Range | 0.05-6 GHz |
| Gain Range | 44 dB |
| Gain Step | 1 dB |
| P1dB | +18 dBm |
| Noise Figure | 6 dB |

**Alternatives:**
- **[AD8369](https://www.analog.com/media/en/technical-documentation/data-sheets/ad8369.pdf)** (Analog Devices): Lower gain range (44 dB vs 45 dB) but lower power consumption

**Selection Rationale:** Wideband VGA covers IF frequency precisely with 1 dB step resolution enabling accurate gain control for 60-80 dB dynamic range.

### 5. Wideband ADC for 2.4 GHz IF digitization with 12-bit resolution

**Primary Choice:** [ADC12J4000](https://www.ti.com/lit/ds/symlink/adc12j4000.pdf) (Texas Instruments)

*12-bit, 4 GSPS RF-sampling ADC with on-chip DDR memory interface, 3.2 GHz analog bandwidth*

[📄 Datasheet](https://www.ti.com/lit/ds/symlink/adc12j4000.pdf)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/texas-instruments/ADC12J4000EVM/4482255)

| Spec | Value |
|---|---|
| Resolution | 12 bits |
| Sampling Rate | 4 GSPS |
| Analog Bandwidth | 3.2 GHz |
| SNR | 58 dB |
| Power | 2.3W |

**Alternatives:**
- **[AD9208](https://www.analog.com/media/en/technical-documentation/data-sheets/ad9208.pdf)** (Analog Devices): Lower sampling rate (3 GSPS) but better SFDR

**Selection Rationale:** RF-sampling ADC directly digitizes 2.4 GHz IF without additional mixing. High sampling rate enables wide FFT bins for kHz frequency resolution.

### 6. FPGA for digital signal processing, FFT, CW detection, and frequency measurement

**Primary Choice:** [XC7A100T-FGG484](https://www.amd.com/system/files/documents/fpga-silicon-packages/xilinx-product-brief.pdf) (AMD (Xilinx))

*Artix-7 FPGA with 101,440 logic cells, 240 DSP slices, 4.9 Mb block RAM, 667 MHz max clock*

[📄 Datasheet](https://www.amd.com/system/files/documents/fpga-silicon-packages/xilinx-product-brief.pdf)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/amd-xilinx/XC7A100T-2FGG484I/4887996)

| Spec | Value |
|---|---|
| Logic Cells | 101,440 |
| DSP Slices | 240 |
| Block RAM | 4.9 Mb |
| User I/O | 285 |
| Transceivers | 0 |

**Alternatives:**
- **[10M08DAF256I7G](https://www.intel.com/content/www/us/en/docs/programmable/683432/current/features.html)** (Intel (Altera)): Lower DSP capacity but lower power consumption

**Selection Rationale:** Artix-7 provides sufficient DSP slices for FFT-based CW detection and frequency measurement. FPGAs enable flexible algorithm updates.

### 7. Microcontroller for UART control, SPI interface to RF components, and system management

**Primary Choice:** [STM32F407VGT6](https://www.st.com/resource/en/datasheet/stm32f407vg.pdf) (STMicroelectronics)

*ARM Cortex-M4F MCU, 168 MHz, 1 MB Flash, 192 KB RAM, extensive peripherals*

[📄 Datasheet](https://www.st.com/resource/en/datasheet/stm32f407vg.pdf)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/stmicroelectronics/STM32F407VGT6/551634)

| Spec | Value |
|---|---|
| Core | Cortex-M4F @ 168 MHz |
| Flash | 1 MB |
| RAM | 192 KB |
| SPI | 3 |
| UART | 6 |
| Timers | 14 |

**Alternatives:**
- **[ATSAM3X8E](https://ww1.microchip.com/downloads/en/DeviceDoc/Atmel-11057-32-bit-Cortex-M3-Microcontroller-SAM3X-SAM3A_Datasheet.pdf)** (Microchip): Similar performance but different ecosystem

**Selection Rationale:** Cortex-M4 provides ample processing for UART command parsing and SPI control. Rich peripheral set simplifies interface to multiple RF components.

### 8. 5V LDO regulator for RF chain power supply with low noise

**Primary Choice:** [LT3045-5](https://www.analog.com/media/en/technical-documentation/data-sheets/3045fa.pdf) (Analog Devices)

*Ultra-low noise LDO regulator, 500 mA output, 0.8uV RMS noise, 79dB PSRR*

[📄 Datasheet](https://www.analog.com/media/en/technical-documentation/data-sheets/3045fa.pdf)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/LT3045-5/P5143)

| Spec | Value |
|---|---|
| Output | +5V @ 500 mA |
| Noise | 0.8 uV RMS |
| PSRR | 79 dB @ 1 kHz |
| Input | Up to 20V |

**Alternatives:**
- **[TPS7A4700](https://www.ti.com/lit/ds/symlink/tps7a4700.pdf)** (Texas Instruments): Lower noise (4 uV RMS) but lower output current (1A)

**Selection Rationale:** Ultra-low noise critical for wideband receiver. High PSRR reduces supply-induced spurious signals.

### 9. 3.3V LDO regulator for digital control and FPGA supply

**Primary Choice:** [LT3045-3.3](https://www.analog.com/media/en/technical-documentation/data-sheets/3045fa.pdf) (Analog Devices)

*Ultra-low noise LDO regulator, 500 mA output, 0.8uV RMS noise, 79dB PSRR*

[📄 Datasheet](https://www.analog.com/media/en/technical-documentation/data-sheets/3045fa.pdf)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/LT3045-3-3/P5143)

| Spec | Value |
|---|---|
| Output | +3.3V @ 500 mA |
| Noise | 0.8 uV RMS |
| PSRR | 79 dB @ 1 kHz |
| Input | Up to 20V |

**Alternatives:**
- **[AMS1117-3.3](https://www.advanced-monolithic.com/pdf/ds1117.pdf)** (Advanced Monolithic Systems): Lower cost but higher noise and lower PSRR

**Selection Rationale:** Same ultra-low noise characteristics for clean digital supply. Low noise prevents digital clock coupling into RF chain.

### 10. RF Input SMA connector rated to 18 GHz

**Primary Choice:** [142-0701-851](https://www.cinch.com/products/detail/142-0701-851) (Cinch Connectivity Solutions (Johnson))

*SMA jack, female, 50 ohm, through-hole mount, 0-18 GHz frequency range*

[📄 Datasheet](https://www.cinch.com/products/detail/142-0701-851)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/cinch-connectivity-solutions/142-0701-851/1285186)

| Spec | Value |
|---|---|
| Frequency | DC-18 GHz |
| Impedance | 50 ohms |
| VSWR | <1.5:1 to 18 GHz |
| Contact Material | Gold plated beryllium copper |

**Alternatives:**
- **[132323-12](https://www.te.com/commerce/DocumentDelivery/DDEController?Action=showdoc&DocId=Customer+Drawing%7F132323%7FC10%7Fpdf%7FEnglish%7FENG_CD_132323_C10.pdf)** (TE Connectivity): Similar specifications, different mounting

**Selection Rationale:** 18 GHz rating matches upper frequency limit. Gold plating ensures reliable connections and low insertion loss.
