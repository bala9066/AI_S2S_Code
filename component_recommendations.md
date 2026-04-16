# Component Recommendations
## kb

### 1. RF Input Limiter Protection

**Primary Choice:** [LMLPF-BV-0+](https://www.minicircuits.com/WebStore/modelSearch.html?model=LMLPF-BV-0%2B) (Mini-Circuits)

*Wideband limiter 0.5-20 GHz, handles 0 dBm CW, 10W peak with fast recovery*

[📄 Datasheet](https://www.minicircuits.com/WebStore/modelSearch.html?model=LMLPF-BV-0%2B)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/mini-circuits/LMLPF-BV/16905193)

| Spec | Value |
|---|---|
| frequency_range | 0.5-20 GHz |
| max_input_power | 10W peak |
| threshold | 10-15 dBm |
| insertion_loss | 0.5 dB |
| recovery_time | 10 ns |

**Alternatives:**
- **[SFL-0128](https://www.google.com/search?q=SFL-0128+datasheet)** (MACOM): Lower power handling, slightly higher insertion loss

**Selection Rationale:** Provides required input protection up to 0 dBm continuous with wide bandwidth coverage

### 2. Wideband Bandpass Filter

**Primary Choice:** [VBFZ-5580+](https://www.minicircuits.com/WebStore/modelSearch.html?model=VBFZ-5580%2B) (Mini-Circuits)

*5-18 GHz bandpass filter, low insertion loss*

[📄 Datasheet](https://www.minicircuits.com/WebStore/modelSearch.html?model=VBFZ-5580%2B)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/mini-circuits/VBFZ-5580/16905204)

| Spec | Value |
|---|---|
| passband | 5-18 GHz |
| insertion_loss | 2.5 dB |
| rejection | 30 dB typical |
| vswr | 2.0:1 |

**Alternatives:**
- **[BP1-18+](https://www.google.com/search?q=BP1-18%2B+datasheet)** (Stanford Research Systems): Narrower passband may not cover full 5-18 GHz

**Selection Rationale:** Directly specified for 5-18 GHz passband with low insertion loss

### 3. Wideband Low Noise Amplifier

**Primary Choice:** [TGA4956-SM](https://www.qorvo.com/products/d/qa001495) (Qorvo)

*DC-20 GHz GaAs MMIC LNA, low noise figure*

[📄 Datasheet](https://www.qorvo.com/products/d/qa001495)

| Spec | Value |
|---|---|
| frequency_range | DC-20 GHz |
| gain | 22 dB |
| noise_figure | 2.5 dB |
| p1db | 18 dBm |
| supply_voltage | 5V |
| current | 85 mA |

**Alternatives:**
- **[MGA-61563](https://www.google.com/search?q=MGA-61563+datasheet)** (MACOM): Slightly higher noise figure at high frequencies
- **[AMA-0091-27170](https://www.google.com/search?q=AMA-0091-27170+datasheet)** (Custom MMIC): Higher power consumption

**Selection Rationale:** Excellent noise figure performance across full band with military-grade available

### 4. Variable Gain Attenuator

**Primary Choice:** [HMC698LP4](https://www.analog.com/en/search.html#q=HMC698LP4) (Analog Devices)

*Digital step attenuator 0.5-6 GHz, wideband variant covers to 18 GHz*

[📄 Datasheet](https://www.analog.com/en/search.html#q=HMC698LP4)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices/HMC698LP4ETR/3472772)

| Spec | Value |
|---|---|
| frequency_range | DC-6 GHz |
| attenuation_range | 0-31.5 dB |
| step_size | 0.5 dB |
| insertion_loss | 2.5 dB |
| control | SPI |

**Alternatives:**
- **[PE4306](https://www.google.com/search?q=PE4306+datasheet)** (pSemi): Lower frequency range, lower attenuation range
- **[ADL5240](https://www.analog.com/en/search.html#q=ADL5240)** (Analog Devices): Analog control only, higher power

**Selection Rationale:** Digital control enables AGC loop for 80 dB dynamic range

### 5. Wideband Mixer

**Primary Choice:** [MAMX-011034](https://www.google.com/search?q=MAMX-011034+datasheet) (MACOM)

*Double balanced mixer 6-18 GHz*

[📄 Datasheet](https://www.google.com/search?q=MAMX-011034+datasheet)

| Spec | Value |
|---|---|
| rf_frequency | 6-18 GHz |
| lo_frequency | 6-18 GHz |
| if_frequency | DC-6 GHz |
| conversion_loss | 8 dB |
| p1db | 15 dBm |
| lo_drive | 13-17 dBm |

**Alternatives:**
- **[HMC1059LP4BE](https://www.analog.com/en/search.html#q=HMC1059LP4BE)** (Analog Devices): Higher LO drive required
- **[MM1-0926HSM](https://www.google.com/search?q=MM1-0926HSM+datasheet)** (Marki Microwave): Higher cost, lower frequency range

**Selection Rationale:** Wideband mixer with low conversion loss for direct conversion to IF

### 6. Wideband LO Synthesizer

**Primary Choice:** [ADF5356](https://www.analog.com/en/search.html#q=ADF5356) (Analog Devices)

*Microwave wideband synthesizer with integrated VCO*

[📄 Datasheet](https://www.analog.com/en/search.html#q=ADF5356)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices/ADF5356BCPZ/6846625)

| Spec | Value |
|---|---|
| frequency_range | 53.125 MHz - 13.6 GHz |
| phase_noise | -125 dBc/Hz at 1 MHz offset |
| output_power | -5 to 2 dBm |
| supply_voltage | 3.3V |

**Alternatives:**
- **[LMX2594](https://www.ti.com/product/LMX2594)** (Texas Instruments): Higher frequency range but higher power
- **[MAX2871](https://www.analog.com/en/search.html#q=MAX2871)** (Maxim Integrated): Lower maximum frequency

**Selection Rationale:** Wide frequency coverage with excellent phase noise for receiver applications

### 7. 2 GSPS ADC

**Primary Choice:** [ADC12DJ3200](https://www.ti.com/product/ADC12DJ3200) (Texas Instruments)

*12-bit, 6.4 GSPS RF sampling ADC*

[📄 Datasheet](https://www.ti.com/product/ADC12DJ3200)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/texas-instruments/ADC12DJ3200EVM/6108076)

| Spec | Value |
|---|---|
| resolution | 12-bit |
| max_sampling_rate | 6.4 GSPS |
| input_bandwidth | 6.5 GHz |
| snr | 58 dBFS |
| sfdr | 70 dBc |
| power | 1.4W |
| interface | JESD204B |

**Alternatives:**
- **[AD9213](https://www.analog.com/en/search.html#q=AD9213)** (Analog Devices): Lower max sample rate
- **[ATR1222](https://www.analog.com/en/search.html#q=ATR1222)** (Analog Devices): Military grade variant with screened parameters

**Selection Rationale:** Industry-leading RF sampling ADC with direct sampling up to 6.5 GHz IF

### 8. Low Jitter Clock Generator

**Primary Choice:** [LMK04828](https://www.ti.com/product/LMK04828) (Texas Instruments)

*Ultra-low noise clock jitter cleaner with dual loop PLL*

[📄 Datasheet](https://www.ti.com/product/LMK04828)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/texas-instruments/LMK04828B-NOPB/5743796)

| Spec | Value |
|---|---|
| output_frequency | up to 3.1 GHz |
| phase_noise | -163 dBc/Hz at 1 MHz offset |
| jitter | 80 fs rms |
| outputs | 14 differential |
| supply_voltage | 3.3V |

**Alternatives:**
- **[ADCLK948](https://www.analog.com/en/search.html#q=ADCLK948)** (Analog Devices): Single device, less flexible
- **[Si5345](https://www.google.com/search?q=Si5345+datasheet)** (Skyworks Solutions): Higher jitter performance

**Selection Rationale:** Ultra-low jitter required for 2 GSPS ADC performance

### 9. Wideband LNA Alternative

**Primary Choice:** [NC1020-1212](https://www.qorvo.com/products/d/qa001495) (Qorvo)

*DC-12 GHz wideband LNA, military grade*

[📄 Datasheet](https://www.qorvo.com/products/d/qa001495)

| Spec | Value |
|---|---|
| frequency_range | DC-12 GHz |
| gain | 20 dB |
| noise_figure | 2.0 dB |
| p1db | 20 dBm |
| supply_voltage | 8V |
| current | 70 mA |
| screening | MIL-PRF-38534 |

**Alternatives:**
- **[TQP3M9036](https://www.qorvo.com/products/d/tqp3m9036)** (Qorvo): Lower frequency range

**Selection Rationale:** Military-screened alternative for -55 to +125C operation

### 10. IF Bandpass Filter

**Primary Choice:** [BP1-500+](https://www.minicircuits.com/WebStore/modelSearch.html?model=BP1-500%2B) (Mini-Circuits)

*500 MHz bandpass filter for anti-alias*

[📄 Datasheet](https://www.minicircuits.com/WebStore/modelSearch.html?model=BP1-500%2B)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/mini-circuits/BP1-500/16905161)

| Spec | Value |
|---|---|
| center_frequency | 500 MHz |
| bandwidth | 200 MHz |
| insertion_loss | 2.0 dB |
| rejection | 40 dB |

**Alternatives:**
- **[SCLF-850+](https://www.minicircuits.com/WebStore/modelSearch.html?model=SCLF-850%2B)** (Mini-Circuits): Different center frequency

**Selection Rationale:** Anti-alias filtering for IF signal before ADC

### 11. IF Driver Amplifier

**Primary Choice:** [ADA4817-1](https://www.analog.com/en/search.html#q=ADA4817-1) (Analog Devices)

*1 GHz low noise op-amp for IF signal drive*

[📄 Datasheet](https://www.analog.com/en/search.html#q=ADA4817-1)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices/ADA4817-1ACPZ-R7/4435473)

| Spec | Value |
|---|---|
| bandwidth | 1 GHz |
| noise_figure | 4 nV/sqrt Hz |
| slew_rate | 1200 V/us |
| supply_voltage | 5V |
| quiescent_current | 19 mA |

**Alternatives:**
- **[THS4304](https://www.ti.com/product/THS4304)** (Texas Instruments): Higher power

**Selection Rationale:** High-speed amplifier to drive ADC input

### 12. Power Supply LDO 5V

**Primary Choice:** [LT3045](https://www.analog.com/en/search.html#q=LT3045) (Analog Devices)

*High PSRR low noise 500mA LDO*

[📄 Datasheet](https://www.analog.com/en/search.html#q=LT3045)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices/LT3045IDD-5-PBF/6190629)

| Spec | Value |
|---|---|
| output_voltage | 5V |
| max_current | 500 mA |
| noise_rms | 0.8 uV |
| psrr | 79 dB at 1 MHz |
| input_voltage | 20V max |

**Alternatives:**
- **[TPS7A47](https://www.ti.com/product/TPS7A47)** (Texas Instruments): Slightly higher noise

**Selection Rationale:** Ultra-low noise for RF sensitive circuits, -55C to +125C operation

### 13. Power Supply LDO 3.3V

**Primary Choice:** [LT3094](https://www.analog.com/en/search.html#q=LT3094) (Analog Devices)

*Low noise negative LDO for split rail, 500mA*

[📄 Datasheet](https://www.analog.com/en/search.html#q=LT3094)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices/LT3094IDD-3.3-PBF/6190630)

| Spec | Value |
|---|---|
| output_voltage | 3.3V |
| max_current | 500 mA |
| noise_rms | 0.8 uV |
| input_voltage | 20V max |

**Alternatives:**
- **[TPS7A33](https://www.ti.com/product/TPS7A33)** (Texas Instruments): Lower maximum current

**Selection Rationale:** Low noise LDO supporting full temperature range

### 14. Power Supply LDO 1.8V

**Primary Choice:** [ADP1741](https://www.analog.com/en/search.html#q=ADP1741) (Analog Devices)

*1A low noise LDO 1.8V output*

[📄 Datasheet](https://www.analog.com/en/search.html#q=ADP1741)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices/ADP1741ACPZ-1.8-R7/5877212)

| Spec | Value |
|---|---|
| output_voltage | 1.8V |
| max_current | 1A |
| noise_rms | 16 uV |
| dropout_voltage | 200 mV |

**Alternatives:**
- **[TPS74401](https://www.ti.com/product/TPS74401)** (Texas Instruments): Higher quiescent current

**Selection Rationale:** High current LDO for ADC digital supply
