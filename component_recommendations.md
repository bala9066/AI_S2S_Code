# Component Recommendations
## hjgjf

### 1. Wideband RF Limiter protecting LNA from >+10dBm inputs

**Primary Choice:** [Limtrprotect Wideband Limiter](https://www.google.com/search?q=Limtrprotect%20Wideband%20Limiter+datasheet) (MACOM / Qorvo)

*Broadband limiter with fast recovery, low insertion loss, 5-18GHz coverage*

[📄 Datasheet](https://www.google.com/search?q=Limtrprotect%20Wideband%20Limiter+datasheet)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/macom/MA4L1010-1141T/6835016)

| Spec | Value |
|---|---|
| frequency_range | DC-18GHz |
| threshold_power | +10 to +15dBm |
| insertion_loss | <0.5dB |
| recovery_time | <10ns |

**Alternatives:**
- **[HMC941LC4](https://www.analog.com/en/search.html#q=HMC941LC4)** (Analog Devices): Integrated limiter+LNA, higher gain

**Selection Rationale:** Essential input protection circuit with low impact on noise figure

### 2. Wideband Low Noise Amplifier covering 5-18GHz

**Primary Choice:** [HMC1099LP5E](https://www.analog.com/en/search.html#q=HMC1099LP5E) (Analog Devices)

*GaAs MMIC LNA, 20-25dB gain, 2.5-3dB NF, DC-20GHz coverage, operates from +5V supply*

[📄 Datasheet](https://www.analog.com/en/search.html#q=HMC1099LP5E)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/HMC1099LP5E/5801637)

| Spec | Value |
|---|---|
| frequency_range | DC-20GHz |
| gain | 22dB |
| noise_figure | 2.8dB |
| p1db | +18dBm |
| supply_voltage | +5V |

**Alternatives:**
- **[TQP3M9036](https://www.qorvo.com/products/d/rsa06031000)** (Qorvo): Lower NF but less gain
- **[LNA6-18G](https://www.google.com/search?q=LNA6-18G+datasheet)** (Custom MMIC): Wider bandwidth but lower P1dB

**Selection Rationale:** Excellent NF and gain across full band, qualified for extended temperature

### 3. High-speed ADC for direct RF sampling 5-18GHz

**Primary Choice:** [EV10AQ190A](https://www.google.com/search?q=EV10AQ190A+datasheet) (e2v (now Teledyne))

*10-bit quad-channel ADC sampling up to 5Gsps, supports interleaving to 10Gsps*

[📄 Datasheet](https://www.google.com/search?q=EV10AQ190A+datasheet)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/teledyne-e2v/EV10AQ190/5997492)

| Spec | Value |
|---|---|
| resolution | 10-bit |
| sampling_rate | 5Gsps per channel (interleaved to 10Gsps) |
| analog_bandwidth | 5GHz |
| sfdr | 65dBc |
| input_full_scale | 1.5Vpp |

**Alternatives:**
- **[ADC10DX100](https://www.ti.com/product/ADC10DX100)** (Texas Instruments): 10Gsps single channel, simpler interface
- **[AD9208](https://www.analog.com/en/search.html#q=AD9208)** (Analog Devices): 3Gsps max, lower bandwidth

**Selection Rationale:** One of few ADCs meeting 5-10Gsps requirement with sufficient resolution

### 4. RF Input Connector for 5-18GHz operation

**Primary Choice:** [1492A-10](https://www.google.com/search?q=1492A-10+datasheet) (Huber+Suhner (or Rosenberger))

*2.4mm female coaxial connector, rated DC-40GHz, low VSWR*

[📄 Datasheet](https://www.google.com/search?q=1492A-10+datasheet)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/huber-suhner/1492A-10/2220413)

| Spec | Value |
|---|---|
| frequency_range | DC-40GHz |
| vswr | <1.3:1 to 18GHz |
| impedance | 50 ohm |
| body_style | PCB mount |

**Alternatives:**
- **[32K241-40ML5](https://www.google.com/search?q=32K241-40ML5+datasheet)** (Rosenberger): Similar performance, alternate supplier

**Selection Rationale:** Industry standard connector for wideband microwave applications

### 5. Clock distribution for low-jitter ADC sampling

**Primary Choice:** [HMC7044](https://www.analog.com/en/search.html#q=HMC7044) (Analog Devices)

*Ultra-low phase noise clock generator/fanout buffer with <100fs jitter*

[📄 Datasheet](https://www.analog.com/en/search.html#q=HMC7044)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/HMC7044LP7E/6142789)

| Spec | Value |
|---|---|
| output_frequencies | 1-3GHz |
| phase_noise | -164dBc/Hz at 1MHz offset |
| rms_jitter | 80fs |
| outputs | 14 LVDS/HSTL |

**Alternatives:**
- **[LMK04828](https://www.ti.com/product/LMK04828)** (Texas Instruments): More outputs, higher power

**Selection Rationale:** Critical for meeting ADC SNR requirements at 5-10Gsps sampling

### 6. LVDS output buffer/driver for ADC data interface

**Primary Choice:** [DS90CR486](https://www.ti.com/product/DS90CR486) (Texas Instruments)

*High-speed LVDS driver, supports up to 1.5Gbps per lane*

[📄 Datasheet](https://www.ti.com/product/DS90CR486)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/texas-instruments/DS90CR486MTD/254632)

| Spec | Value |
|---|---|
| data_rate | 10Mbps to 1.5Gbps |
| supply_voltage | 3.3V |
| differential_output | LVDS |
| skew | 50ps |

**Alternatives:**
- **[DS90LV047A](https://www.ti.com/product/DS90LV047A)** (Texas Instruments): Quad driver, lower data rate

**Selection Rationale:** Industry standard LVDS driver for ADC-FPGA interfaces

### 7. Multi-rail DC-DC converter for system power distribution

**Primary Choice:** [LTM4644](https://www.google.com/search?q=LTM4644+datasheet) (Analog Devices (Linear Technology))

*Quad 4A output DC-DC regulator module, operates from 4.5-26V input*

[📄 Datasheet](https://www.google.com/search?q=LTM4644+datasheet)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/LTM4644-1/P4083677)

| Spec | Value |
|---|---|
| input_voltage | 4.5 to 26V |
| outputs | 4x 0.6-5V |
| output_current | 4A per channel |
| switching_frequency | 1MHz |

**Alternatives:**
- **[TPS65218](https://www.ti.com/product/TPS65218)** (Texas Instruments): Lower power, integrated PMIC

**Selection Rationale:** Compact solution providing multiple positive rails, efficient thermal performance

### 8. Negative rail generator for analog front-end

**Primary Choice:** [LTC1983](https://www.google.com/search?q=LTC1983+datasheet) (Analog Devices (Linear Technology))

*Switched capacitor negative voltage converter, generates -1V and -2V from positive supply*

[📄 Datasheet](https://www.google.com/search?q=LTC1983+datasheet)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/LTC1983ES6-3.3-PBF/1207679)

| Spec | Value |
|---|---|
| input_voltage | 1.5 to 5.5V |
| output_current | 100mA |
| output_voltage | adjustable negative |
| efficiency | 90% |

**Alternatives:**
- **[LM27762](https://www.ti.com/product/LM27762)** (Texas Instruments): Integrated LDO, lower output current

**Selection Rationale:** Compact solution for generating negative bias rails required by LNA and ADC

### 9. Wideband DC blocking capacitor at RF input

**Primary Choice:** [0805HT-200J](https://www.google.com/search?q=0805HT-200J+datasheet) (AVX)

*High-Q RF ceramic capacitor, 20pF, 0805 package*

[📄 Datasheet](https://www.google.com/search?q=0805HT-200J+datasheet)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/avx-corporation/08055A200JAT2A/597778)

| Spec | Value |
|---|---|
| capacitance | 20pF |
| voltage_rating | 200V |
| q_factor | >1000 at 1GHz |
| temperature_coefficient | C0G/NP0 |

**Alternatives:**
- **[GQM2195C2E200JB12D](https://www.murata.com/en-us/products/productdetail?partno=GQM2195C2E200JB12D)** (Murata): Higher Q, larger package

**Selection Rationale:** Critical for DC isolation while maintaining RF performance to 18GHz

### 10. 5-18GHz bandpass filter (optional, for out-of-band rejection)

**Primary Choice:** [BP5-18G-1](https://www.google.com/search?q=BP5-18G-1+datasheet) (Mini-Circuits / K&L Microwave)

*Wideband bandpass filter, 5-18GHz, low insertion loss*

[📄 Datasheet](https://www.google.com/search?q=BP5-18G-1+datasheet)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/minicircuits/BP5-18G-1/2583711)

| Spec | Value |
|---|---|
| passband | 5-18GHz |
| insertion_loss | <3dB |
| rejection | >40dB outside band |
| vswr | <2.0:1 |

**Alternatives:**
- **[VBF-1800+](https://www.minicircuits.com/WebStore/modelSearch.html?model=VBF-1800%2B)** (Mini-Circuits): Narrower band, higher rejection

**Selection Rationale:** Improves out-of-band rejection and reduces interference
