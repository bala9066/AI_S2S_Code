# Component Recommendations
## hgyu

### 1. Wideband Low Noise Amplifier (5-18 GHz)

**Primary Choice:** [HMC1132LP6GE](https://www.analog.com/en/search.html#q=HMC1132LP6GE) (Analog Devices)

*GaAs MMIC PHEMT LNA, 6-18 GHz, 23 dB gain, 3.5 dB noise figure, +33 dBm OIP3. Operating temperature -40 to +85°C base, extended temp screening required for -55 to +125°C operation.*

[📄 Datasheet](https://www.analog.com/en/search.html#q=HMC1132LP6GE)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/hmc1132lp6ge/6039186)

| Spec | Value |
|---|---|
| frequency_range | 6-18 GHz |
| gain | 23 dB |
| noise_figure | 3.5 dB |
| oip3 | +33 dBm |
| p1db | +18 dBm |
| supply | 5V @ 120 mA |

**Alternatives:**
- **[TQP3M9038](https://www.qorvo.com/products/d/rsa0123)** (Qorvo): Slightly higher NF (4 dB) but wider band DC-12 GHz, lower power. Extended temp available.

**Selection Rationale:** Selected for wideband 6-18 GHz coverage with excellent 3.5 dB NF to meet system 6-10 dB target. High OIP3 (+33 dBm) supports 20-25 dBm IIP3 requirement. Note: Extended temperature screening required for -55 to +125°C operation.

### 2. Wideband Variable Gain Amplifier / Attenuator (5-18 GHz)

**Primary Choice:** [HMC698LP4](https://www.analog.com/en/search.html#q=HMC698LP4) (Analog Devices)

*Digital Step Attenuator, 0-31.5 dB range, 0.5 dB steps, DC-12 GHz. Requires cascade for 5-18 GHz coverage. Extended temp range available.*

[📄 Datasheet](https://www.analog.com/en/search.html#q=HMC698LP4)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/hmc698lp4e/10044424)

| Spec | Value |
|---|---|
| frequency_range | DC-12 GHz |
| attenuation_range | 0-31.5 dB |
| step_size | 0.5 dB |
| insertion_loss | 4 dB |
| control | Parallel 6-bit |

**Alternatives:**
- **[PE4306](https://www.google.com/search?q=PE4306+datasheet)** (pSemi): DC-8 GHz only, lower insertion loss, lower power. Not suitable for full 18 GHz.
- **[ADRF5720](https://www.analog.com/en/search.html#q=ADRF5720)** (Analog Devices): DC-13.5 GHz, 0.5 dB steps, 31.5 dB range. Good alternative.

**Selection Rationale:** Selected for 31.5 dB programmable attenuation range with 0.5 dB resolution. Meets 30 dB gain control requirement. Parallel digital interface allows fast gain settling. Note: May require two-stage design for full 18 GHz coverage.

### 3. 5-10 GSPS Ultra-Wideband ADC

**Primary Choice:** [ADC10DX100](https://www.ti.com/product/ADC10DX100) (Texas Instruments)

*10-bit, 10 GSPS RF sampling ADC with JESD204B interface. 3.5 GHz input bandwidth. Operating temp -40 to +85°C, requires screening for -55 to +125°C.*

[📄 Datasheet](https://www.ti.com/product/ADC10DX100)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/texas-instruments/ADC10DX100IRGZ/6137755)

| Spec | Value |
|---|---|
| resolution | 10 bits |
| sample_rate | 10 GSPS |
| input_bandwidth | 3.5 GHz |
| sfdr | 68 dBc |
| snr | 55 dBFS |
| power | 3.2W |
| interface | JESD204B 8 lanes |

**Alternatives:**
- **[EV12AQ605](https://www.google.com/search?q=EV12AQ605+datasheet)** (Teledyne e2v): 12-bit resolution, 5 GSPS, excellent SNR but higher power (5W). Extended temp rated.
- **[ATR1225](https://www.analog.com/en/search.html#q=ATR1225)** (Analog Devices): 12-bit, 2.5 GSPS JESD204C, lower power but not meeting 5 GSPS minimum.

**Selection Rationale:** Selected as one of the few commercially available 10 GSPS ADCs with JESD204B interface. 10-bit resolution supports 70-80 dB dynamic range target. 3.5 GHz input bandwidth requires IF operation (not direct RF sampling at 18 GHz).

### 4. Ultra-Low Jitter Clock Generator

**Primary Choice:** [LMK04828](https://www.ti.com/lit/ds/symlink/lmk04828.pdf) (Texas Instruments)

*Dual-loop PLL clock jitter cleaner with 14 outputs. <100 fs RMS jitter from 12 kHz to 20 MHz. Supports JESD204B subclass 1.*

[📄 Datasheet](https://www.ti.com/lit/ds/symlink/lmk04828.pdf)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/texas-instruments/LMK04828B-NOPB/5015577)

| Spec | Value |
|---|---|
| output_freq | 1 Hz to 3.1 GHz |
| jitter_rms | <100 fs |
| phase_noise | -132 dBc/Hz @ 1 MHz |
| outputs | 14 configurable |
| power | 1.2W |

**Alternatives:**
- **[AD9528](https://www.analog.com/en/search.html#q=AD9528)** (Analog Devices): Similar performance, dual PLL, JESD204B support. Also good option.

**Selection Rationale:** Selected for ultra-low jitter (<100 fs) required for 5-10 GSPS sampling with good SNR. Dual-loop PLL enables clean clock synthesis from external reference. JESD204B subclass 1 support for deterministic latency.

### 5. Wideband Anti-Alias Filter (5-10 GHz)

**Primary Choice:** [RBP-8250+](https://www.google.com/search?q=RBP-8250%2B+datasheet) (Mini-Circuits)

*Bandpass filter, 8.25 GHz center frequency, 2.5 GHz bandwidth (7-9.5 GHz passband). Requires multiple filters switched for 5-10 GHz coverage.*

[📄 Datasheet](https://www.google.com/search?q=RBP-8250%2B+datasheet)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/mini-circuits/RBP-8250/3877192)

| Spec | Value |
|---|---|
| center_freq | 8.25 GHz |
| bandwidth | 2.5 GHz |
| insertion_loss | 2.5 dB |
| rejection | 40 dB @ +/-2 GHz |
| passband_ripple | 0.5 dB |

**Alternatives:**
- **[BP-6600+](https://www.google.com/search?q=BP-6600%2B+datasheet)** (Mini-Circuits): 6.6 GHz center, 1 GHz BW. Additional filter required for full coverage.

**Selection Rationale:** Commercial bandpass filters provide anti-aliasing for ADC. Multiple filters (switched or parallel) needed for 5-10 GHz instantaneous bandwidth coverage. Custom filter may be required for optimal performance.

### 6. Power Management Module

**Primary Choice:** [LTM4644](https://www.analog.com/en/search.html#q=LTM4644) (Analog Devices)

*Quad 4A DC/DC µModule regulator. 4-14V input, programmable outputs 0.6V-5V. Operating -40 to +125°C.*

[📄 Datasheet](https://www.analog.com/en/search.html#q=LTM4644)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices/LTM4644IYPBF/4884627)

| Spec | Value |
|---|---|
| input_range | 4-14V |
| output_channels | 4x 4A |
| output_voltage | 0.6-5V |
| efficiency | >90% |
| temp_range | -40 to +125°C |

**Alternatives:**
- **[TPS65218](https://www.ti.com/lit/ds/symlink/tps65218.pdf)** (Texas Instruments): PMIC with fewer rails, lower current. Not suitable for 20W total power.

**Selection Rationale:** Selected for +125°C operation rating and quad output capability to supply multiple rails (5V for RF, 3.3V, 1.8V, 1.0V digital). µModule packaging simplifies layout and improves reliability.

### 7. Control Microcontroller

**Primary Choice:** [ATSAMC21G18A-MUT](https://ww1.microchip.com/downloads/en/DeviceDoc/40001895A.pdf) (Microchip Technology)

*ARM Cortex-M0+, 256KB Flash, 32KB RAM, SPI/I2C interfaces, 48 MHz. Industrial temp with extended screening available.*

[📄 Datasheet](https://ww1.microchip.com/downloads/en/DeviceDoc/40001895A.pdf)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/microchip-technology/ATSAMC21G18A-MUT/4952705)

| Spec | Value |
|---|---|
| core | ARM Cortex-M0+ |
| flash | 256 KB |
| ram | 32 KB |
| clock | 48 MHz |
| interfaces | SPI, I2C, UART |
| temp_range | -40 to +105°C (base) |

**Alternatives:**
- **[STM32F407VG](https://www.st.com/en/search.html#q=STM32F407VG)** (STMicroelectronics): Cortex-M4, more performance, but industrial temp only. Screening required.

**Selection Rationale:** Selected for SPI control of attenuator/ADC and general system management. ARM Cortex-M0+ provides adequate control processing. Extended temperature screening required for -55 to +125°C operation.
