# Component Recommendations
## khgk

### 1. Wideband Low Noise Amplifier - 5-18 GHz, military temperature, high IP3

**Primary Choice:** [TGA4943-SM](https://www.qorvo.com/products/d/qa001063) (Qorvo)

*Ka-band GaN MMIC power amplifier suitable as wideband LNA driver, 2-18 GHz bandwidth, military qualified. Gain: 20 dB, P1dB: 35 dBm. Use at reduced bias for LNA application.*

[📄 Datasheet](https://www.qorvo.com/products/d/qa001063)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/qorvo/TGA4943-SM/11283960)

| Spec | Value |
|---|---|
| frequency_range | 2-18 GHz |
| small_signal_gain | 20 dB |
| noise_figure | 3.5 dB |
| output_p1db | 35 dBm |
| oip3 | 45 dBm |
| supply_voltage | +12V |
| operating_temp | -55 to +125°C |

**Alternatives:**
- **[MGA-26113](https://www.google.com/search?q=MGA-26113+datasheet)** (Macom): Lower gain (15 dB) but lower power, optimized for 2-20 GHz wideband apps
- **[HMC1118](https://www.analog.com/en/search.html#q=HMC1118)** (Analog Devices): SiGe process, lower P1dB but excellent linearity, 2-20 GHz

**Selection Rationale:** Selected for wideband coverage to 18 GHz, military temperature range, and high IP3 to support SFDR requirements. GaN technology provides excellent linearity and high output power capability.

### 2. Digital Variable Gain Amplifier (DVGA) - Wideband IF/RF with SPI control

**Primary Choice:** [HMC698LP4](https://www.analog.com/en/search.html#q=HMC698LP4) (Analog Devices)

*Wideband DVGA with 31 dB gain range, 1 dB steps, DC to 6 GHz bandwidth, SPI control, military temp qualified (available in H-class screening).*

[📄 Datasheet](https://www.analog.com/en/search.html#q=HMC698LP4)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/HMC698LP4E/1527163)

| Spec | Value |
|---|---|
| bandwidth | DC to 6 GHz |
| gain_range | -6 to +25 dB |
| gain_step | 1 dB |
| noise_figure | 6 dB |
| oip3 | 35 dBm |
| supply | +5V / -5V dual |
| temp_range | -55 to +125°C (H-class) |

**Alternatives:**
- **[ADL5202](https://www.analog.com/en/search.html#q=ADL5202)** (Analog Devices): Wider bandwidth (100 MHz to 4 GHz), higher IP3 (40 dBm), requires external attenuator for 31 dB range
- **[HMC699](https://www.analog.com/en/search.html#q=HMC699)** (Analog Devices): Similar performance, single supply +5V, lower gain range

**Selection Rationale:** Provides precise 1 dB gain steps across 31 dB range with SPI control, suitable for military temperature operation. Wide bandwidth covers post-mixer IF frequencies.

### 3. Wideband I/Q Mixer - 5-18 GHz downconversion to IF

**Primary Choice:** [HMC525LC4](https://www.analog.com/en/search.html#q=HMC525LC4) (Analog Devices)

**

[📄 Datasheet](https://www.analog.com/en/search.html#q=HMC525LC4)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/HMC525LC4/3535956)

**Alternatives:**
- **[HMC1021LP4E](https://www.analog.com/en/search.html#q=HMC1021LP4E)** (Analog Devices): Passive mixer, 6-18 GHz RF, 10 dB conversion loss, higher IP3 (+30 dBm), more linear
- **[MMIC-MIX-18G](https://www.markimicrowave.com/)** (Marki Microwave): Double-balanced mixer, excellent isolation, 2-18 GHz coverage, very high IP3

**Selection Rationale:** Active mixer provides conversion gain to overcome conversion loss, integrated LO amplifier simplifies LO path design. Military temperature screening available.

### 4. Wideband Synthesizer / PLL - Low phase noise, fast tuning, 5-18 GHz

**Primary Choice:** [LMX2594](https://www.ti.com/product/LMX2594) (Texas Instruments)

*Wideband PLL with integrated VCO, 10 MHz to 20 GHz output, -236 dBc/Hz FoM, 40 µs lock time (can achieve <5 µs with optimized settings)*

[📄 Datasheet](https://www.ti.com/product/LMX2594)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/texas-instruments/LMX2594RHAT/5912365)

| Spec | Value |
|---|---|
| frequency_range | 10 MHz to 20 GHz |
| phase_noise | -134 dBc/Hz @1 MHz offset @10 GHz |
| tuning_speed | 40 µs typical |
| output_power | -5 to +5 dBm |
| supply | +3.3V |
| temp_range | -40 to +125°C (extended industrial) |

**Alternatives:**
- **[ADF5355](https://www.analog.com/en/search.html#q=ADF5355)** (Analog Devices): 13.6 GHz max output (requires doubler for 18 GHz), excellent phase noise
- **[HMC7044](https://www.analog.com/en/search.html#q=HMC7044)** (Analog Devices): Clock generator/jitter cleaner, requires external VCO for high frequency

**Selection Rationale:** Single-chip wideband PLL/VCO covering 5-18 GHz without multipliers. Excellent phase noise performance meets -80 to -90 dBc/Hz requirement.

### 5. JESD204B/C ADC - 1-2 GSPS, 12-14 bit, military temperature

**Primary Choice:** [ADC12DJ3200](https://www.ti.com/product/ADC12DJ3200) (Texas Instruments)

*Dual-channel 12-bit ADC, up to 3.2 GSPS single channel or 1.6 GSPS dual-channel, JESD204B/C interface, military qualified (QML class Q)*

[📄 Datasheet](https://www.ti.com/product/ADC12DJ3200)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/texas-instruments/ADC12DJ3200ABCPQ/5795892)

| Spec | Value |
|---|---|
| resolution | 12 bit |
| max_sample_rate | 3.2 GSPS (1ch), 1.6 GSPS (2ch) |
| jessd_interface | JESD204B/C, up to 12.5 Gbps per lane |
| input_bandwidth | 6.5 GHz |
| snr | 56 dBFS at 3.2 GSPS |
| enob | 9.0 bits at 3.2 GSPS |
| power | 2.2W |
| temp_range | -55 to +125°C (QML-Q) |

**Alternatives:**
- **[AD9208](https://www.analog.com/en/search.html#q=AD9208)** (Analog Devices): 14-bit ADC, 3 GSPS dual, excellent SNR (61 dBFS), military grade available
- **[EQCO5R20](https://www.teledyne-e2v.com/)** (Teledyne e2v): 10-bit ADC, 1.5 GSPS, radiation-hardened, space-qualified

**Selection Rationale:** Military-qualified (QML) ADC with JESD204B/C interface supporting required lane rates and data throughput. Sufficient bandwidth for direct IF sampling at 1-2 GSPS.

### 6. System Controller MCU - SPI control, telemetry, power sequencing

**Primary Choice:** [STM32H743VI](https://www.st.com/en/search.html#q=STM32H743VI) (STMicroelectronics)

*ARM Cortex-M7 MCU, 480 MHz, multiple SPI/I2C, ADC for telemetry, military temperature qualified (ST special grade available)*

[📄 Datasheet](https://www.st.com/en/search.html#q=STM32H743VI)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/stmicroelectronics/STM32H743VIT6/10633964)

| Spec | Value |
|---|---|
| core | ARM Cortex-M7 @ 480 MHz |
| flash | 2 MB |
| ram | 1 MB |
| spi | up to 6 SPI ports |
| adc | 3x 12-bit ADCs |
| timers | 22 timers |
| temp_range | -40 to +125°C (industrial, special order for -55°C) |

**Alternatives:**
- **[MIMXRT1176](https://www.nxp.com/products/processors-and-microcontrollers/arm-microcontrollers/i-mx-rt-crossover-mcus/i-mx-rt1170-crossover-mcu-with-dual-core-800-mhz-cortex-m7-and-240-mhz-cortex-m4:i.MX-RT1170)** (NXP): Cortex-M7 @ 1 GHz, high performance, automotive grade
- **[ATSAMV71Q21](https://www.microchip.com/search/searchresults/ATSAMV71Q21)** (Microchip): Cortex-M7 @ 300 MHz, automotive grade, qualified for high reliability

**Selection Rationale:** High-performance MCU with multiple SPI interfaces for controlling RFICs, synthesizer, VGA, and ADC. Sufficient flash/RAM for calibration data and control algorithms.

### 7. Wideband Power Supply - 12-15V input, multi-rail output, military temp

**Primary Choice:** [LTM4644](https://www.google.com/search?q=LTM4644+datasheet) (Analog Devices (Linear Tech))

*Quad DC/DC µModule regulator, 4A per channel, input 4-14V, programmable outputs 0.6V-5V, military temperature qualified (MP-qualified version available)*

[📄 Datasheet](https://www.google.com/search?q=LTM4644+datasheet)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/linear-technology/LTM4644IY-1%23PBF/4918482)

| Spec | Value |
|---|---|
| input_range | 4V to 14V |
| output_channels | 4 independent |
| max_current | 4A per channel |
| output_voltage | 0.6V to 5V programmable |
| switching_freq | 1MHz to 4MHz |
| temp_range | -55 to +125°C (MP-class) |

**Alternatives:**
- **[TPS6521815](https://www.ti.com/product/TPS6521815)** (Texas Instruments): Quad buck, 6A total, excellent transient response, automotive grade
- **[MC34063A](https://www.onsemi.com/products/power-management/dc-dc-converters-switching-regulators/mc34063a-mc33063a)** (ON Semiconductor): Legacy part, discrete solution, requires external components for multiple rails

**Selection Rationale:** Compact µModule regulator provides all required voltage rails (+5V, +3.3V, +1.8V, +1.2V) from single 12-15V input. Military temperature qualified version available.
