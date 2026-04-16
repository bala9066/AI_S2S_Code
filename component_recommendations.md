# Component Recommendations
## dghb

### 1. Wideband LNA (Low Noise Amplifier) covering 5-18 GHz with ~20-25 dB gain and low noise figure to meet system NF target of 5-8 dB.

**Primary Choice:** [GVA-123+](https://www.minicircuits.com/pdfs/GVA-123+.pdf) (Mini-Circuits / Qorvo equivalent)

*Wideband DC-18 GHz MMIC amplifier, +23.5 dB typical gain, 3.5 dB noise figure, +19 dBm P1dB, operated at 3.3V or 5V.*

[📄 Datasheet](https://www.minicircuits.com/pdfs/GVA-123+.pdf)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/minicircuits/GVA-123%2B/7728928)

| Spec | Value |
|---|---|
| frequency_range | DC to 18 GHz |
| gain | +23.5 dB typical |
| noise_figure | 3.5 dB typical |
| p1db | +19 dBm output |
| supply_voltage | 3.3V to 5V |
| power | approx. 250 mW |

**Alternatives:**
- **[AMA-006-2-18-10](https://www.custommmic.com/documents/datasheets/ama-006-2-18-10.pdf)** (Custom MMIC): Slightly higher gain (26 dB), similar NF, operates from 3.3V, MMIC format.
- **[HMC698LP4](https://www.google.com/search?q=HMC698LP4+datasheet)** (Analog Devices (Hittite)): Integrated VGA + driver amp, -10 to +22 dB gain range, 4-8 GHz, not full 18 GHz.

**Selection Rationale:** The GVA-123+ provides excellent gain and NF across the entire 5-18 GHz band with modest power consumption. It helps achieve system NF target of 5-8 dB when placed early in the chain.

### 2. Variable Gain Amplifier (VGA) for fine gain control to optimize signal level into the ADC over wide input power range (-60 to -40 dBm).

**Primary Choice:** [HMC698LP4](https://www.analog.com/en/search.html#q=HMC698LP4) (Analog Devices)

*Digital variable gain amplifier with -10 to +22 dB gain range, 4-8 GHz, SPI programmable, integrated LNA + driver.*

[📄 Datasheet](https://www.analog.com/en/search.html#q=HMC698LP4)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/HMC698LP4ETR/4603381)

| Spec | Value |
|---|---|
| gain_range | -10 to +22 dB |
| bandwidth | 4 to 8 GHz |
| control | SPI digital |
| p1db | +19 dBm output |
| supply_voltage | 3.3V |

**Alternatives:**
- **[ADRF5720](https://www.analog.com/en/search.html#q=ADRF5720)** (Analog Devices): DC-6 GHz VGA, 31.5 dB range with 0.25 dB steps, SPI control, lower bandwidth but more resolution.
- **[MAAL-011111](https://www.google.com/search?q=MAAL-011111+datasheet)** (Macom): DC-20 GHz digital attenuator + driver, up to 31.75 dB range in 0.25 dB steps, broader frequency range.

**Selection Rationale:** HMC698LP4 offers wide gain range with digital control to maintain optimal ADC input level across varying input signal strength.

### 3. Multi-GSPS ADC for direct IF sampling at 4-8 GSPS with 10-12 bit resolution and LVDS/JESD204B output interface.

**Primary Choice:** [ADC12DJ5200RF](https://www.ti.com/product/ADC12DJ5200RF) (Texas Instruments)

*12-bit, dual-channel ADC up to 10.25 GSPS or 5.2 GSPS per channel in dual mode, JESD204B/C interface, 3.3V compatible.*

[📄 Datasheet](https://www.ti.com/product/ADC12DJ5200RF)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/texas-instruments/ADC12DJ5200RFABZ/6165506)

| Spec | Value |
|---|---|
| resolution | 12-bit |
| max_sampling_rate | 10.25 GSPS (single) / 5.2 GSPS per channel (dual) |
| sfdr | 55-62 dBc typical |
| input_bandwidth | up to 9 GHz (3dB) |
| interface | JESD204B/C (up to 16 lanes) |
| supply | 1.0V and 1.8V rails (from 3.3V via point-of-load regulators) |
| power | approx. 3.5W |

**Alternatives:**
- **[ADC12J4000](https://www.ti.com/product/ADC12J4000)** (Texas Instruments): 12-bit, 4 GSPS ADC, similar performance, JESD204B interface, lower max sample rate but simpler interface.
- **[AD9213](https://www.analog.com/en/search.html#q=AD9213)** (Analog Devices): 12.5 GSPS 12-bit ADC, JESD204C, excellent SFDR (~65 dBc), similar power consumption.
- **[E2V/EV12AQ605](https://www.google.com/search?q=E2V%2FEV12AQ605+datasheet)** (Teledyne e2v): Quad-channel 1.5 GSPS or single 6 GSPS 12-bit ADC, JESD204B, lower power but multiple channels.

**Selection Rationale:** ADC12DJ5200RF provides a high-performance, widely supported 12-bit ADC capable of 4-8+ GSPS sampling with excellent SFDR and the required JESD204B/C interface for LVDS data transfer.

### 4. Ultra-low jitter clock generator and synthesizer to drive multi-GSPS ADC with <200 fs RMS jitter to support high-order modulation and SFDR targets.

**Primary Choice:** [LMK04828](https://www.ti.com/product/LMK04828) (Texas Instruments)

*Ultra-low jitter clock generator with dual-loop PLL, 12 outputs, SYSREF for JESD204B/C, <100 fs RMS jitter typical.*

[📄 Datasheet](https://www.ti.com/product/LMK04828)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/texas-instruments/LMK04828BKNTR/5670970)

| Spec | Value |
|---|---|
| jitter_rms | <100 fs typical (12 kHz to 20 MHz) |
| output_count | 12 differential or 24 single-ended |
| sysref | JESD204B/C compliant |
| vco_freq | up to 3.4 GHz |
| supply | 1.8V and 3.3V |

**Alternatives:**
- **[LMK04832](https://www.ti.com/product/LMK04832)** (Texas Instruments): Enhanced version with even lower jitter (~85 fs), similar pinout, more integration.
- **[AD9528](https://www.analog.com/en/search.html#q=AD9528)** (Analog Devices): Dual-loop PLL clock generator, JESD204B support, <120 fs jitter, similar performance.

**Selection Rationale:** LMK04828 meets the stringent jitter requirement and provides dedicated JESD204B/C support including SYSREF generation, widely used in high-speed data acquisition systems.

### 5. RF input protection against ESD and over-voltage up to +10 dBm with minimal impact on NF and VSWR up to 18 GHz.

**Primary Choice:** [LM5000](https://www.google.com/search?q=LM5000+datasheet) (MACOM)

*Broadband limiter diode for ESD and input power protection, operates up to 20 GHz, low threshold (~10 dBm).*

[📄 Datasheet](https://www.google.com/search?q=LM5000+datasheet)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/macom/LM5000/5808746)

| Spec | Value |
|---|---|
| frequency_range | DC to 20 GHz |
| threshold | approx. 10-12 dBm |
| insertion_loss | <0.5 dB typical |
| esd_protection | Class 1C (500 W peak) |

**Alternatives:**
- **[GVA-114+](https://www.google.com/search?q=GVA-114%2B+datasheet)** (Mini-Circuits): Wideband limiter 10-2000 MHz, lower frequency range, similar protection.

**Selection Rationale:** LM5000 provides broadband protection with minimal insertion loss, helping to protect sensitive LNA and ADC inputs without significantly impacting system noise figure.

### 6. 5-18 GHz bandpass filter to restrict input bandwidth and reduce out-of-band interference/noise, improving system linearity and image rejection.

**Primary Choice:** [BP5G18G-25M01-C5F](https://www.google.com/search?q=BP5G18G-25M01-C5F+datasheet) (Kratos / K&L Microwave or equivalent)

*Miniature 5-18 GHz bandpass filter with SMA connectors, low insertion loss (<2.5 dB), sharp roll-off.*

[📄 Datasheet](https://www.google.com/search?q=BP5G18G-25M01-C5F+datasheet)

| Spec | Value |
|---|---|
| passband | 5 to 18 GHz |
| insertion_loss | ≤2.5 dB typical |
| rejection | ≥40 dB below 4 GHz / above 19 GHz |
| connectors | SMA female |
| vswr | ≤2.0:1 |

**Alternatives:**
- **[RBP5G18G-25M01](https://www.google.com/search?q=RBP5G18G-25M01+datasheet)** (Mini-Circuits): Semi-lumped bandpass filter, similar specifications, available with SMA or PCB edge-launch.

**Selection Rationale:** Provides necessary band limiting to reduce out-of-band energy and improve overall system linearity and spurious performance.

### 7. MCU or CPLD for control interface (SPI/I2C) to configure VGA gain, ADC settings, clock generation, and monitor system status (temperature, power).

**Primary Choice:** [STM32F407VGT6](https://www.st.com/en/search.html#q=STM32F407VGT6) (STMicroelectronics)

*ARM Cortex-M4F MCU with 168 MHz, 1 MB flash, 192 KB RAM, extensive SPI/I2C/UART interfaces, industrial temp.*

[📄 Datasheet](https://www.st.com/en/search.html#q=STM32F407VGT6)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/stmicroelectronics/STM32F407VGT6/1889973)

| Spec | Value |
|---|---|
| core | ARM Cortex-M4F @ 168 MHz |
| flash | 1 MB |
| ram | 192 KB |
| spi | 3 interfaces |
| i2c | 3 interfaces |
| temperature | -40 to +85°C |
| supply | 1.8V to 3.6V |

**Alternatives:**
- **[ATSAMV71Q21B-AAB](https://www.microchip.com/search/searchresults/ATSAMV71Q21B-AAB)** (Microchip): ARM Cortex-M7 @ 300 MHz, more performance, similar peripheral set.
- **[MAX10 10M08](https://www.google.com/search?q=MAX10%2010M08+datasheet)** (Intel/Altera): CPLD/FPGA with hard processor core, lower power, configurable logic.

**Selection Rationale:** STM32F407 provides a robust, cost-effective control solution with ample SPI/I2C interfaces for system configuration and monitoring, industrial temperature support.

### 8. Point-of-load DC-DC converters and LDO regulators to derive required supply voltages (1.0V, 1.8V, etc.) from main 3.3V input for high-performance ICs.

**Primary Choice:** [TPS62913](https://www.ti.com/product/TPS62913) (Texas Instruments)

*Low-noise 2-A buck converter with 4-V to 16-V input, output adjustable down to 0.6V, excellent load transient performance.*

[📄 Datasheet](https://www.ti.com/product/TPS62913)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/texas-instruments/TPS62913DRCR/9563326)

| Spec | Value |
|---|---|
| input | 4 to 16 V |
| output | 0.6 to 5.5 V |
| current | 2 A continuous |
| switching_freq | 1 MHz typical |
| noise | low output ripple (~10 mVpp) |

**Alternatives:**
- **[LT3045](https://www.google.com/search?q=LT3045+datasheet)** (Analog Devices (Linear Tech)): Ultra-low noise LDO, 500 mA, suitable for analog rails, lower efficiency but cleaner supply.
- **[LTC7150S](https://www.analog.com/en/search.html#q=LTC7150S)** (Analog Devices): Monolithic synchronous buck, 20 A, very high efficiency, suitable for digital loads.

**Selection Rationale:** TPS62913 provides efficient, low-noise power conversion from 3.3V or higher rails to the various core voltages required by the ADC, FPGA, and other ICs.

### 9. RF input connector suitable for 5-18 GHz, 50 ohm impedance, SMA or 2.4mm format for board edge launch.

**Primary Choice:** [142-0701-851](https://www.cinch.com/products/johnson/142-0701-851) (Cinch Connectivity Solutions (Johnson))

*SMA female 2-hole PCB jack, 50 ohm, excellent performance up to 18 GHz+.*

[📄 Datasheet](https://www.cinch.com/products/johnson/142-0701-851)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/cinch-connectivity-solutions-johnson/142-0701-851/15103787)

| Spec | Value |
|---|---|
| frequency_range | DC to 18 GHz+ |
| impedance | 50 ohm |
| mounting | 2-hole PCB launch |
| vswr | ≤1.5:1 typical to 18 GHz |
| contact_material | beryllium copper with gold plating |

**Alternatives:**
- **[086-1-4-4-400](https://www.te.com/en/search.html#q=086-1-4-4-400)** (TE Connectivity): 2.4mm precision connector for higher frequency (>26 GHz), more expensive.
- **[PC-SMA-J-P+TH](https://www.google.com/search?q=PC-SMA-J-P%2BTH+datasheet)** (Huber+Suhner): SMA PCB jack, similar performance, alternative source.

**Selection Rationale:** Standard SMA connector provides reliable, cost-effective 50 ohm connection up to 18 GHz with good VSWR and widely available cabling.

### 10. Temperature sensors for thermal monitoring and protection across the system, particularly for high-power components like the LNA and ADC.

**Primary Choice:** [TMP235A2DCKR](https://www.ti.com/product/TMP235) (Texas Instruments)

*Analog output temperature sensor, -40°C to +150°C range, ±2°C accuracy, low quiescent current (35 µA).*

[📄 Datasheet](https://www.ti.com/product/TMP235)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/texas-instruments/TMP235A2DCKR/9477154)

| Spec | Value |
|---|---|
| range | -40 to +150°C |
| accuracy | ±2°C (max) |
| output | 10 mV/°C analog |
| supply | 2.7V to 5.5V |
| current | 35 µA typical |

**Alternatives:**
- **[LM73](https://www.ti.com/product/LM73)** (Texas Instruments): Digital I2C temperature sensor, ±1.5°C accuracy, added I2C bus complexity.
- **[ADT7320](https://www.analog.com/en/search.html#q=ADT7320)** (Analog Devices): ±0.5°C accuracy, SPI interface, higher precision but more expensive.

**Selection Rationale:** TMP235 provides simple analog temperature monitoring without consuming I2C/SPI resources, adequate accuracy for thermal protection and fan control.
