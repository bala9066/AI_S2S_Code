# Component Recommendations
## khv

### 1. Wideband LNA with integrated VGA

**Primary Choice:** [HMC698LP4](https://www.analog.com/en/search.html#q=HMC698LP4) (Analog Devices)

*GaAs MMIC 5-20 GHz wideband LNA with 24 dB gain and 3.5 dB noise figure. Includes integrated VGA functionality.*

[📄 Datasheet](https://www.analog.com/en/search.html#q=HMC698LP4)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/HMC698LP4ETR/6073784)

| Spec | Value |
|---|---|
| frequency_range | 5-20 GHz |
| gain | 24 dB |
| noise_figure | 3.5 dB |
| p1db | +18 dBm |
| ip3 | +28 dBm |
| supply | 5V @ 120 mA |
| operating_temp | -55 to +125°C |
| package | QFN 4x4 mm |

**Alternatives:**
- **[MAAL-011131](https://www.google.com/search?q=MAAL-011131+datasheet)** (MACOM): Similar performance but higher power consumption
- **[TGA4507-SM](https://www.google.com/search?q=TGA4507-SM+datasheet)** (Qorvo): Higher gain but slightly higher NF

**Selection Rationale:** Covers entire 5-18 GHz band with excellent noise figure and ultra-high IP3 (+28 dBm) meeting linearity requirements. Military temperature qualified.

### 2. High-speed ADC (5-10 GSPS)

**Primary Choice:** [EV12AQ600](https://www.google.com/search?q=EV12AQ600+datasheet) (Teledyne e2v)

*Quad-channel 12-bit ADC capable of 6.4 GSPS operation or single-channel up to 12.8 GSPS with interleaving.*

[📄 Datasheet](https://www.google.com/search?q=EV12AQ600+datasheet)

| Spec | Value |
|---|---|
| resolution | 12-bit |
| sampling_rate | up to 6.4 GSPS per channel |
| sfdr | 80 dBFS |
| input_bandwidth | 8 GHz |
| supply | 1.0V, 1.8V, 3.3V |
| operating_temp | -40 to +85°C (commercial grade) |
| package | BGA 17x17 mm |

**Alternatives:**
- **[ADC12DJ5200RF](https://www.ti.com/product/ADC12DJ5200RF)** (Texas Instruments): Dual-channel 10-bit, 5.2 GSPS max - slightly lower resolution
- **[AD9213](https://www.analog.com/en/search.html#q=AD9213)** (Analog Devices): Single-channel 12-bit 10 GSPS - high performance

**Selection Rationale:** One of few ADCs supporting >5 GSPS sampling rates. Provides 80 dB SFDR meeting requirement. Note: Commercial grade - may require thermal management for extended temp operation.

### 3. Ultra-low phase noise clock synthesizer

**Primary Choice:** [LMK04828](https://www.ti.com/product/LMK04828) (Texas Instruments)

*Dual-loop PLL clock jitter cleaner with 14 outputs. Provides <100 fs RMS jitter.*

[📄 Datasheet](https://www.ti.com/product/LMK04828)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/texas-instruments/LMK04828BLLPT/4679238)

| Spec | Value |
|---|---|
| output_frequency | up to 3.2 GHz |
| phase_noise | -140 dBc/Hz at 1 MHz |
| rms_jitter | 80 fs |
| outputs | 14 differential |
| supply | 3.3V |
| operating_temp | -40 to +85°C |
| package | HTQFP-64 |

**Alternatives:**
- **[AD9528](https://www.analog.com/en/search.html#q=AD9528)** (Analog Devices): Similar performance, different PLL architecture
- **[Si5345](https://www.skyworksinc.com/products/timing-clock-generation/Si5345)** (Skyworks (Silicon Labs)): Any-frequency clock synthesizer with 5 ppb stability

**Selection Rationale:** Industry-standard high-performance clock synthesizer with excellent phase noise meeting SFDR requirements.

### 4. Wideband RF bandpass filter

**Primary Choice:** [BP series 5-18 GHz](https://www.minicircuits.com/WebStore/dashboard.html?model=BP5G18G%2B) (Mini-Circuits)

*Surface mount bandpass filter covering 5-18 GHz range with low insertion loss.*

[📄 Datasheet](https://www.minicircuits.com/WebStore/dashboard.html?model=BP5G18G%2B)  [🛒 DigiKey](https://www.digikey.com/en/products/filter/bandpass-5-ghz-to-18-ghz)

| Spec | Value |
|---|---|
| passband | 5-18 GHz |
| insertion_loss | 2.5 dB |
| return_loss | 15 dB |
| power_handling | 1W |
| package | SMA drop-in or surface mount |
| operating_temp | -55 to +125°C |

**Alternatives:**
- **[RBP-5G18G+](https://www.google.com/search?q=RBP-5G18G%2B+datasheet)** (K&L Microwave): Similar specs, different package

**Selection Rationale:** Required band-limiting before ADC to prevent aliasing and reduce out-of-band noise.

### 5. Power management DC-DC converter

**Primary Choice:** [LTM4644](https://www.google.com/search?q=LTM4644+datasheet) (Analog Devices (Linear Tech))

*Quad-output high efficiency DC-DC regulator module. 4A per channel.*

[📄 Datasheet](https://www.google.com/search?q=LTM4644+datasheet)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/LTM4644IY-PBF/6008194)

| Spec | Value |
|---|---|
| input_range | 4.5-26V |
| outputs | 4 independent 0.6-5V |
| current_per_output | 4A |
| efficiency | >92% |
| operating_temp | -40 to +125°C |
| package | BGA 15x15 mm LGA |

**Alternatives:**
- **[TPS65260](https://www.ti.com/product/TPS65260)** (Texas Instruments): Quad-output but lower max temp

**Selection Rationale:** Compact quad-output regulator simplifies power tree design. Operates to +125°C meeting military temp requirement.

### 6. Wideband RF input SMA connector

**Primary Choice:** [142-0771-821](https://www.cinch.com/products/142-0771-821) (Cinch Connectivity Solutions)

*SMC/SMA RF connector end launch for PCB mounting. 50 Ohm impedance.*

[📄 Datasheet](https://www.cinch.com/products/142-0771-821)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/cinch-connectivity-solutions/142-0771-821/4257863)

| Spec | Value |
|---|---|
| frequency_range | DC to 18 GHz |
| vswr | 1.3:1 max |
| impedance | 50 Ohm |
| mounting | PCB end launch |
| operating_temp | -55 to +125°C |

**Alternatives:**
- **[142-0701-851](https://www.cinch.com/products/142-0701-851)** (Cinch Connectivity Solutions): Similar specs, slightly different footprint

**Selection Rationale:** Wideband connector supporting full 5-18 GHz range with military temperature rating.
