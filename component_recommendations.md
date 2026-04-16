# Component Recommendations
## khg

### 1. RF Input Limiter Protection

**Primary Choice:** [LPA-518+](https://www.minicircuits.com/WebStore/modelSearch.html?model=LPA-518%2B) (Mini-Circuits)

*Surface mount limiter 5-18 GHz, handles up to +20 dBm input, 10 ns recovery*

[📄 Datasheet](https://www.minicircuits.com/WebStore/modelSearch.html?model=LPA-518%2B)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/minicircuits/LPA-518/16035962)

| Spec | Value |
|---|---|
| freq_range | 5-18 GHz |
| max_power | +20 dBm |
| insertion_loss | 0.5 dB |
| recovery_time | 10 ns |
| operating_temp | -55 to +125°C |

**Alternatives:**
- **[MCLA-500+](https://www.minicircuits.com/WebStore/modelSearch.html?model=MCLA-500%2B)** (Mini-Circuits): Wider bandwidth 2-18 GHz but slightly higher insertion loss

**Selection Rationale:** Wideband limiter covering entire 5-18 GHz band with military temperature range and fast recovery time.

### 2. RF Bandpass Filter 5-18 GHz

**Primary Choice:** [BP5G18G-5180-SM](https://www.google.com/search?q=BP5G18G-5180-SM+datasheet) (K&L Microwave)

*5-18 GHz bandpass filter, SMA edge mount*

[📄 Datasheet](https://www.google.com/search?q=BP5G18G-5180-SM+datasheet)

| Spec | Value |
|---|---|
| freq_range | 5-18 GHz |
| insertion_loss | 2.0 dB |
| vswr | 2.0:1 |
| rejection | 40 dBc at 3/20 GHz |

**Alternatives:**
- **[BP5G18G-5180-SM](https://www.google.com/search?q=BP5G18G-5180-SM+datasheet)** (K&L Microwave (Cr制)): Similar specs, verify availability

**Selection Rationale:** Provides band-limiting to reduce out-of-band interference before LNA.

### 3. Wideband RF LNA

**Primary Choice:** [TQM473552](https://www.qorvo.com/products/d/qa001019) (Qorvo)

*GaAs MMIC amplifier 2-20 GHz, 20 dB gain, 3.5 dB NF*

[📄 Datasheet](https://www.qorvo.com/products/d/qa001019)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/qorvo/TQM473552/8574649)

| Spec | Value |
|---|---|
| freq_range | 2-20 GHz |
| gain | 20 dB |
| noise_figure | 3.5 dB |
| p1db | +18 dBm |
| oip3 | +30 dBm |
| supply | +5V 150mA |
| operating_temp | -55 to +125°C |

**Alternatives:**
- **[MGA-82563](https://www.google.com/search?q=MGA-82563+datasheet)** (MACOM): Slightly higher NF 4.5 dB but lower current consumption
- **[HMC1118](https://www.analog.com/en/search.html#q=HMC1118)** (Analog Devices): Excellent NF 2.8 dB but limited to 2-14 GHz

**Selection Rationale:** Excellent noise figure and gain across entire 5-18 GHz band with military temperature rating.

### 4. RF Variable Gain Amplifier (Digital Control)

**Primary Choice:** [HMC698LP4](https://www.analog.com/en/search.html#q=HMC698LP4) (Analog Devices)

*Digital step attenuator 0-31.5 dB, 0.5 dB steps, DC-20 GHz*

[📄 Datasheet](https://www.analog.com/en/search.html#q=HMC698LP4)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/HMC698LP4E/2974481)

| Spec | Value |
|---|---|
| freq_range | DC-20 GHz |
| attenuation_range | 0-31.5 dB |
| step_size | 0.5 dB |
| insertion_loss | 5 dB |
| ip3 | +40 dBm |
| control | 6-bit parallel |
| operating_temp | -40 to +85°C |

**Alternatives:**
- **[HMC1119](https://www.analog.com/en/search.html#q=HMC1119)** (Analog Devices): Wider temp range -55 to +125°C but lower IP3

**Selection Rationale:** Precise 0.5 dB gain steps via digital control for AGC implementation.

### 5. IQ Demodulator/Mixer

**Primary Choice:** [MWC-1440+](https://www.minicircuits.com/WebStore/modelSearch.html?model=MWC-1440%2B) (Mini-Circuits)

*IQ mixer 5-18 GHz, IF DC-4 GHz, LO drive 0-10 dBm*

[📄 Datasheet](https://www.minicircuits.com/WebStore/modelSearch.html?model=MWC-1440%2B)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/minicircuits/MWC-1440/16041689)

| Spec | Value |
|---|---|
| rf_freq | 5-18 GHz |
| lo_freq | 5-18 GHz |
| if_freq | DC-4 GHz |
| conversion_loss | 8 dB |
| lo_drive | +10 dBm |
| sideband_suppression | 30 dB |

**Alternatives:**
- **[HMC1145](https://www.analog.com/en/search.html#q=HMC1145)** (Analog Devices): Integrated LO amplifier, single-sideband mixer

**Selection Rationale:** Wideband IQ mixer covering entire RF band with good sideband suppression.

### 6. Wideband PLL/VCO Local Oscillator

**Primary Choice:** [LMX2594](https://www.ti.com/product/LMX2594) (Texas Instruments)

*Wideband PLL with integrated VCO, 10-20 GHz output*

[📄 Datasheet](https://www.ti.com/product/LMX2594)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/texas-instruments/LMX2594RHAR/5984656)

| Spec | Value |
|---|---|
| freq_range | 10-20 GHz |
| phase_noise | -104 dBc/Hz at 100kHz |
| tuning_time | <20 µs |
| supply | +3.3V 440mA |
| operating_temp | -40 to +125°C |

**Alternatives:**
- **[ADF5356](https://www.analog.com/en/search.html#q=ADF5356)** (Analog Devices): Lower phase noise but requires external VCO

**Selection Rationale:** Integrated VCO simplifies design, excellent phase noise, covers LO range.

### 7. Differential IF VGA (Post-Mixer)

**Primary Choice:** [ADA4817-2](https://www.analog.com/en/search.html#q=ADA4817-2) (Analog Devices)

*Low noise differential OpAmp VGA, 1 GHz bandwidth*

[📄 Datasheet](https://www.analog.com/en/search.html#q=ADA4817-2)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/ADA4817-2ACPZ-R7/2597622)

| Spec | Value |
|---|---|
| bandwidth | 1 GHz |
| noise | 4 nV/√Hz |
| slew_rate | 1000 V/µs |
| gain_range | -20 to +20 dB |
| supply | ±5V |

**Alternatives:**
- **[THS4509](https://www.ti.com/product/THS4509)** (Texas Instruments): Higher bandwidth 2.1 GHz but slightly higher noise

**Selection Rationale:** Low-noise differential amplifier suitable for driving ADC inputs with variable gain.

### 8. Dual/Quad RF ADC with JESD204C

**Primary Choice:** [AD9213](https://www.analog.com/en/search.html#q=AD9213) (Analog Devices)

*Dual 12-bit 10 GSPS ADC with JESD204C*

[📄 Datasheet](https://www.analog.com/en/search.html#q=AD9213)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/AD9213-10EBCPZ/6016543)

| Spec | Value |
|---|---|
| resolution | 12-bit |
| sample_rate | 10 GSPS |
| analog_bandwidth | 9 GHz |
| sfdr | 80 dBFS |
| snr | 55 dBFS |
| interface | JESD204C 8 lanes |
| power | 2.4W |
| operating_temp | -40 to +85°C |

**Alternatives:**
- **[ADC12DJ3200](https://www.ti.com/product/ADC12DJ3200)** (Texas Instruments): Dual 12-bit 3.2 GSPS, JESD204B instead of C
- **[ATKA1166](https://www.teledyne-e2v.com/)** (Teledyne e2v): Military grade version with extended temp range

**Selection Rationale:** Meets instantaneous bandwidth requirement with JESD204C interface and excellent SFDR.

### 9. Power Management IC

**Primary Choice:** [LTC7815](https://www.analog.com/en/search.html#q=LTC7815) (Analog Devices)

*Quad output synchronous DC/DC controller*

[📄 Datasheet](https://www.analog.com/en/search.html#q=LTC7815)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/LTC7815EUHF-PBF/5864476)

| Spec | Value |
|---|---|
| input_range | 4.5-38V |
| outputs | 4 configurable rails |
| switching_freq | 200-600 kHz |
| efficiency | >92% |
| operating_temp | -40 to +125°C |

**Alternatives:**
- **[LM5175](https://www.ti.com/product/LM5175)** (Texas Instruments): Dual output controller, lower cost

**Selection Rationale:** Generates all required voltage rails from single +12V input with high efficiency.

### 10. Low Noise LDO for RF Circuits

**Primary Choice:** [LT3045](https://www.analog.com/en/search.html#q=LT3045) (Analog Devices)

*Ultra low noise LDO regulator 500 mA*

[📄 Datasheet](https://www.analog.com/en/search.html#q=LT3045)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/LT3045EDD-PBF/5432083)

| Spec | Value |
|---|---|
| output_current | 500 mA |
| noise | 0.8 µVrms |
| psrr | 79 dB at 10kHz |
| dropout_voltage | 200mV |
| operating_temp | -40 to +125°C |

**Alternatives:**
- **[TPS7A47](https://www.ti.com/product/TPS7A47)** (Texas Instruments): Higher output current 1A but slightly higher noise

**Selection Rationale:** Ultra-low noise critical for RF front-end supply rails.

### 11. DC/DC Power Module

**Primary Choice:** [UCC12040](https://www.ti.com/product/UCC12040) (Texas Instruments)

*5V isolated DC/DC converter module 1W*

[📄 Datasheet](https://www.ti.com/product/UCC12040)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/texas-instruments/UCC12040DYEVM/5883036)

| Spec | Value |
|---|---|
| input | 5V |
| output | 5V |
| power | 1W |
| isolation | 1 kV RMS |
| efficiency | >80% |
| operating_temp | -40 to +125°C |

**Alternatives:**
- **[MGJ1D121505SC](https://www.google.com/search?q=MGJ1D121505SC+datasheet)** (Murata Power Solutions): Wider input range but larger footprint

**Selection Rationale:** Provides isolated bias for PLL to minimize phase noise coupling.
