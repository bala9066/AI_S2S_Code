# Component Recommendations
## jhf

### 1. Wideband Low Noise Amplifier 5-18 GHz

**Primary Choice:** [HMC6180LP4E](https://www.analog.com/en/search.html#q=HMC6180LP4E) (Analog Devices)

*GaAs MMIC HEMT Low Noise Amplifier, 6-18 GHz, 16 dB gain, 3 dB noise figure, 12V compatible*

[📄 Datasheet](https://www.analog.com/en/search.html#q=HMC6180LP4E)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/HMC6180LP4E/5561264)

| Spec | Value |
|---|---|
| frequency_range | 6-18 GHz |
| gain | 16 dB |
| noise_figure | 3 dB |
| p1db | +18 dBm |
| supply_voltage | +12V |
| current | 80 mA |

**Alternatives:**
- **[AMMC-6241](https://www.google.com/search?q=AMMC-6241+datasheet)** (Custom MMIC): Similar performance, slightly higher NF

**Selection Rationale:** Excellent NF and gain performance across band, 12V operation, MIL-STD compatible packaging

### 2. Wideband Variable Gain Amplifier/Attenuator

**Primary Choice:** [HMC698LP4](https://www.analog.com/en/search.html#q=HMC698LP4) (Analog Devices)

*Digital Variable Gain Amplifier, DC-6 GHz, 31.5 dB range, 0.5 dB steps*

[📄 Datasheet](https://www.analog.com/en/search.html#q=HMC698LP4)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/HMC698LP4/1815877)

| Spec | Value |
|---|---|
| gain_range | 31.5 dB |
| bandwidth | DC-6 GHz |
| steps | 0.5 dB |
| supply | +5V/-5V |

**Alternatives:**
- **[ADRF5720](https://www.analog.com/en/search.html#q=ADRF5720)** (Analog Devices): Wider bandwidth DC-6.5 GHz, digital control

**Selection Rationale:** Digital gain control, compatible with IF output frequency range

### 3. Wideband Mixer for Downconversion

**Primary Choice:** [HMC558LC4](https://www.analog.com/en/search.html#q=HMC558LC4) (Analog Devices)

*Wideband Mixer 4-8 GHz RF, 2-8 GHz LO, DC-2.5 GHz IF*

[📄 Datasheet](https://www.analog.com/en/search.html#q=HMC558LC4)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/HMC558LC4/1929866)

| Spec | Value |
|---|---|
| rf_range | 4-8 GHz |
| lo_range | 2-8 GHz |
| if_range | DC-2.5 GHz |
| conversion_gain | 8 dB |
| p1db | +15 dBm |

**Alternatives:**
- **[MCA-08M+](https://www.google.com/search?q=MCA-08M%2B+datasheet)** (Macom): Broader RF/LO range, passive mixer

**Selection Rationale:** Active mixer with good conversion gain, covers portion of band

### 4. Wideband Local Oscillator Synthesizer

**Primary Choice:** [ADF5356](https://www.analog.com/en/search.html#q=ADF5356) (Analog Devices)

*Microwave Wideband Synthesizer with Integrated VCO, 53.125 MHz to 13.6 GHz*

[📄 Datasheet](https://www.analog.com/en/search.html#q=ADF5356)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/ADF5356CCPZ/7272474)

| Spec | Value |
|---|---|
| frequency_range | 53.125 MHz - 13.6 GHz |
| phase_noise | -125 dBc/Hz @ 1 MHz |
| supply | 3.3-5.25V |

**Alternatives:**
- **[LMX2594](https://www.ti.com/product/LMX2594)** (Texas Instruments): Wider range to 20 GHz, similar phase noise

**Selection Rationale:** Wideband coverage, excellent phase noise for military applications

### 5. IF Amplifier

**Primary Choice:** [ADL5541](https://www.analog.com/en/search.html#q=ADL5541) (Analog Devices)

*IF Gain Block Amplifier, 100 MHz - 4 GHz, 20 dB gain*

[📄 Datasheet](https://www.analog.com/en/search.html#q=ADL5541)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/ADL5541ACPZ-R7/5803537)

| Spec | Value |
|---|---|
| frequency_range | 100 MHz - 4 GHz |
| gain | 20 dB |
| p1db | +18 dBm |
| oip3 | 35 dBm |
| supply | 5V |

**Alternatives:**
- **[GVA-123+](https://www.minicircuits.com/WebStore/modelSearch.html?model=GVA-123%2B)** (Mini-Circuits): Similar performance, lower cost

**Selection Rationale:** Covers IF output range, good linearity

### 6. RF Bandpass Filter 5-18 GHz

**Primary Choice:** [BP05G18G-06](https://www.google.com/search?q=BP05G18G-06+datasheet) (UIY Inc)

*Bandpass Filter 5-18 GHz SMA connector*

[📄 Datasheet](https://www.google.com/search?q=BP05G18G-06+datasheet)

| Spec | Value |
|---|---|
| passband | 5-18 GHz |
| insertion_loss | 2.5 dB |
| rejection | 40 dBc |

**Alternatives:**
- **[CBP-1800-S+](https://www.minicircuits.com/WebStore/modelSearch.html?model=CBP-1800-S%2B)** (Mini-Circuits): Similar spec, verify availability

**Selection Rationale:** Wideband coverage for image rejection and out-of-band filtering

### 7. Power Management 12V to Rails

**Primary Choice:** [LM22676-12](https://www.ti.com/product/LM22676) (Texas Instruments)

*12V Output 3A Step-Down DC/DC Converter with 42V Max Input*

[📄 Datasheet](https://www.ti.com/product/LM22676)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/texas-instruments/LM22676-ADJRE-P5/1852489)

| Spec | Value |
|---|---|
| input | 4.5-42V |
| output | 12V |
| current | 3A |
| switching_freq | 500 kHz |

**Alternatives:**
- **[LT8640](https://www.analog.com/en/search.html#q=LT8640)** (Analog Devices): Higher efficiency, lower noise

**Selection Rationale:** Industrial temp rated, robust 12V regulation

### 8. 3.3V LDO for Logic/Bias

**Primary Choice:** [LT3042](https://www.analog.com/en/search.html#q=LT3042) (Analog Devices)

*Ultra Low Noise High PSRR LDO 500mA*

[📄 Datasheet](https://www.analog.com/en/search.html#q=LT3042)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/LT3042EDD%23PBF/5665854)

| Spec | Value |
|---|---|
| output | 3.3V |
| current | 500 mA |
| noise | 0.8 uV RMS |
| psrr | 79 dB @ 1 MHz |

**Alternatives:**
- **[TPS7A4700](https://www.ti.com/product/TPS7A4700)** (Texas Instruments): Similar ultra-low noise performance

**Selection Rationale:** Ultra-low noise critical for sensitive RF circuits

### 9. RF Input Connector

**Primary Choice:** [142-0701-851](https://www.cinch.com/products/detail/sma-jack-50-ohm-4-hole-flange) (Cinch Connectivity Solutions)

*SMA Jack 50 Ohm PCB Mount 4-Hole Flange*

[📄 Datasheet](https://www.cinch.com/products/detail/sma-jack-50-ohm-4-hole-flange)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/cinch-connectivity-solutions/142-0701-851/2938775)

| Spec | Value |
|---|---|
| frequency | DC-18 GHz |
| impedance | 50 ohm |
| mounting | 4-hole flange |

**Alternatives:**
- **[32K243-40ML5](https://www.te.com/en/search.html#q=32K243-40ML5)** (TE Connectivity): Equivalent SMA jack

**Selection Rationale:** Industry standard SMA for wideband RF to 18 GHz
