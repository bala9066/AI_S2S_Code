# Component Recommendations
## hm

### 1. RF limiter / input protection — protects LNA from +20 dBm overload and ESD. 120 dBm dynamic range, low insertion loss.

**Primary Choice:** [SKY16406-321LF](https://www.google.com/search?q=SKY16406-321LF+datasheet) (Skyworks Solutions)

**

[📄 Datasheet](https://www.google.com/search?q=SKY16406-321LF+datasheet)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/skyworks-solutions-inc/SKY16406-321LF/11236114)

| Spec | Value |
|---|---|
| frequency | DC to 6000 MHz |
| insertion_loss | 0.6 dB typ |
| leakage | +12 dBm max |
| recovery_time | 1000 ns |
| package | DFN 3x3 mm |

**Alternatives:**
- **[MADL-011017](https://www.google.com/search?q=MADL-011017+datasheet)** (MACOM): Lower leakage, wider bandwidth, higher cost

**Selection Rationale:** Wideband silicon limiter with low insertion loss at UHF, protects downstream LNA from high-power signals up to +20 dBm at the antenna port.

### 2. LNA — first active stage in the signal chain. Sets system noise figure to < 2 dB.

**Primary Choice:** [PMA3-83LN+](https://www.minicircuits.com/WebStore/modelSearch.html?model=PMA3-83LN%2B) (Mini-Circuits)

**

[📄 Datasheet](https://www.minicircuits.com/WebStore/modelSearch.html?model=PMA3-83LN%2B)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/mini-circuits/PMA3-83LN+/10262872)

| Spec | Value |
|---|---|
| frequency | 50 to 3000 MHz |
| gain | 21.6 dB typ at 500 MHz |
| noise_figure | 0.69 dB typ |
| oip3 | +35.5 dBm |
| p1db_out | +19.7 dBm |
| supply | +5V, 80 mA |
| package | QFN 4x4 mm |

**Alternatives:**
- **[QPL9057](https://www.qorvo.com/products/p/QPL9057)** (Qorvo): Higher gain (23 dB), comparable NF, different footprint

**Selection Rationale:** Excellent NF (0.69 dB) at UHF gives system NF < 2 dB with comfortable margin. High OIP3 meets linearity targets with strong blockers present.

### 3. RF SPDT switches for sub-band filter bank — routes signal through the appropriate bandpass filter for the selected 300–1000 MHz sub-band.

**Primary Choice:** [HMC253LC4](https://www.analog.com/en/search.html#q=HMC253LC4) (Analog Devices)

**

[📄 Datasheet](https://www.analog.com/en/search.html#q=HMC253LC4)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/HMC253LC4/5784755)

| Spec | Value |
|---|---|
| frequency | DC to 4000 MHz |
| insertion_loss | 0.7 dB typ |
| isolation | 30 dB |
| switching_time | 50 ns |
| p0_5db | +30 dBm |
| supply | +5V |
| package | TSSOP-16 |

**Alternatives:**
- **[MASWSS0185](https://www.google.com/search?q=MASWSS0185+datasheet)** (MACOM): Higher isolation (35 dB), higher insertion loss

**Selection Rationale:** Low insertion loss (< 1 dB) preserves system noise figure. Fast switching time supports rapid sub-band selection.

### 4. 1st mixer — converts selected UHF sub-band (300–1000 MHz) down to 70 MHz IF using high-side LO injection.

**Primary Choice:** [ADE-25MH+](https://www.minicircuits.com/WebStore/modelSearch.html?model=ADE-25MH%2B) (Mini-Circuits)

**

[📄 Datasheet](https://www.minicircuits.com/WebStore/modelSearch.html?model=ADE-25MH%2B)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/mini-circuits/ADE-25MH+/1979837)

| Spec | Value |
|---|---|
| lo_rf_range | 5 to 2500 MHz |
| conversion_loss | 5.6 dB typ |
| lo_rf_isolation | 45 dB |
| iip3 | +18 dBm |
| if_range | DC to 1000 MHz |
| lo_power | +7 dBm |
| package | SMT 5x5 mm |

**Alternatives:**
- **[ADE-35MH+](https://www.minicircuits.com/WebStore/modelSearch.html?model=ADE-35MH%2B)** (Mini-Circuits): Higher IIP3 (+20 dBm), slightly more conversion loss

**Selection Rationale:** High IIP3 (+18 dBm) ensures strong blocker handling. Low conversion loss preserves noise figure. LO power compatible with synthesizer output.

### 5. IF bandpass filter — 70 MHz center frequency, 10 MHz bandwidth crystal or LC filter for channel selection and image rejection.

**Primary Choice:** [BFCG-70A+](https://www.minicircuits.com/WebStore/modelSearch.html?model=BFCG-70A%2B) (Mini-Circuits)

**

[📄 Datasheet](https://www.minicircuits.com/WebStore/modelSearch.html?model=BFCG-70A%2B)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/mini-circuits/BFCG-70A+/971411)

| Spec | Value |
|---|---|
| center_freq | 70 MHz |
| 3db_bw | 10 MHz min |
| insertion_loss | 3 dB typ |
| shape_factor | 2.5:1 |
| package | SMT 6.2x4.4 mm |

**Alternatives:**
- **[Crystal filter custom](https://www.tte.com/)** (TTE/Qorvo): Sharper selectivity, longer lead time, higher cost

**Selection Rationale:** Standard 70 MHz IF filter with 10 MHz bandwidth matches IBW requirement. Adequate selectivity for > 50 dB image rejection when combined with RF pre-selection.

### 6. IF VGA with AGC — maintains constant IF output level despite varying input signal levels. Provides ~40 dB gain control range.

**Primary Choice:** [ADL5330](https://www.analog.com/en/search.html#q=ADL5330) (Analog Devices)

**

[📄 Datasheet](https://www.analog.com/en/search.html#q=ADL5330)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/ADL5330/1917665)

| Spec | Value |
|---|---|
| frequency | LF to 1000 MHz |
| gain_range | -23 to +21 dB |
| gain_control | Analog voltage |
| oip3 | +38 dBm |
| noise_figure | 7 dB at max gain |
| supply | +5V, 90 mA |
| package | TSSOP-20 |

**Alternatives:**
- **[LMH6526](https://www.ti.com/product/LMH6526)** (Texas Instruments): Higher bandwidth, different control interface (SPI)

**Selection Rationale:** Wide gain control range (44 dB) accommodates the 120 dB input dynamic range (+20 dBm to -100 dBm). Linear-in-dB gain control simplifies AGC loop design.

### 7. IQ demodulator — splits the 70 MHz IF into quadrature baseband I and Q channels for coherent pulse-Doppler processing.

**Primary Choice:** [LTC5596](https://www.analog.com/en/search.html#q=LTC5596) (Analog Devices)

**

[📄 Datasheet](https://www.analog.com/en/search.html#q=LTC5596)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/LTC5596IUF-PBF/5830556)

| Spec | Value |
|---|---|
| if_range | 0 to 1500 MHz |
| conversion_gain | -0.3 dB typ |
| iip2 | +62 dBm |
| iip3 | +26 dBm |
| iq_amplitude_balance | 0.07 dB |
| iq_phase_balance | 0.5 degrees |
| baseband_bw | 530 MHz |
| supply | +5V, 195 mA |
| package | QFN 4x4 mm |

**Alternatives:**
- **[ADL5387](https://www.analog.com/en/search.html#q=ADL5387)** (Analog Devices): Wider bandwidth, higher current, slightly lower IIP2

**Selection Rationale:** Excellent IIP2 (+62 dBm) critical for even-order distortion rejection. Outstanding I/Q balance supports coherent processing. 530 MHz BB BW well exceeds 10 MHz requirement.

### 8. PLL synthesizer — generates tunable LO (230–930 MHz) for 1st mixer, plus quadrature LO for IQ demod. Phase noise -100 dBc/Hz at 10 kHz offset.

**Primary Choice:** [ADF4153A](https://www.analog.com/en/search.html#q=ADF4153A) (Analog Devices)

**

[📄 Datasheet](https://www.analog.com/en/search.html#q=ADF4153A)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/ADF4153ABCPZ-RL7/5146443)

| Spec | Value |
|---|---|
| frequency | 0 to 4000 MHz |
| phase_noise_floor | -220 dBc/Hz |
| reference_freq | 10 to 250 MHz |
| resolution | 1 Hz |
| interface | SPI 3-wire |
| supply | +3.3V, 50 mA |
| package | TSSOP-16 |

**Alternatives:**
- **[LMX2594](https://www.ti.com/product/LMX2594)** (Texas Instruments): Higher max freq (15 GHz), integrated VCO, more complex programming

**Selection Rationale:** Ultra-low phase noise floor (-220 dBc/Hz) enables meeting the -100 dBc/Hz at 10 kHz offset requirement when paired with a quality VCO. SPI interface for digital frequency control.

### 9. VCO — voltage-controlled oscillator for the PLL loop. Covers 370–1070 MHz for high-side LO injection to 300–1000 MHz RF.

**Primary Choice:** [ROS-1080+](https://www.minicircuits.com/WebStore/modelSearch.html?model=ROS-1080%2B) (Mini-Circuits)

**

[📄 Datasheet](https://www.minicircuits.com/WebStore/modelSearch.html?model=ROS-1080%2B)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/mini-circuits/ROS-1080+/973559)

| Spec | Value |
|---|---|
| frequency | 700 to 1080 MHz |
| tuning_voltage | 0.5 to 22V |
| phase_noise | -106 dBc/Hz at 10 kHz |
| output_power | +4 dBm |
| supply | +5V, 25 mA |
| package | SMT 0.3x0.3 in |

**Alternatives:**
- **[ZOS-1000+](https://www.minicircuits.com/WebStore/modelSearch.html?model=ZOS-1000%2B)** (Mini-Circuits): Wider tuning range, slightly higher phase noise

**Selection Rationale:** Phase noise of -106 dBc/Hz at 10 kHz offset exceeds the -100 dBc/Hz system requirement with margin. Frequency range covers the needed LO frequencies.

### 10. LO buffer amplifier — provides +7 dBm drive to the mixer LO port and isolation between LO chain and mixer.

**Primary Choice:** [GVA-84+](https://www.minicircuits.com/WebStore/modelSearch.html?model=GVA-84%2B) (Mini-Circuits)

**

[📄 Datasheet](https://www.minicircuits.com/WebStore/modelSearch.html?model=GVA-84%2B)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/mini-circuits/GVA-84+/648059)

| Spec | Value |
|---|---|
| frequency | DC to 8000 MHz |
| gain | 20 dB typ |
| p1db_out | +15.5 dBm |
| oip3 | +28 dBm |
| nf | 6.5 dB |
| supply | +5V, 55 mA |
| package | SOT-89 |

**Alternatives:**
- **[GVA-123+](https://www.minicircuits.com/WebStore/modelSearch.html?model=GVA-123%2B)** (Mini-Circuits): Higher output power, higher current

**Selection Rationale:** Provides sufficient output power to drive mixer LO port (+7 dBm) with margin. High gain compensates VCO output level.

### 11. Baseband low-pass filter — 5 MHz cutoff for I and Q channels. Active filter with Butterworth/Bessel response for strict group delay variation < 1 ns.

**Primary Choice:** [LTC1569-7](https://www.analog.com/en/search.html#q=LTC1569-7) (Analog Devices)

**

[📄 Datasheet](https://www.analog.com/en/search.html#q=LTC1569-7)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/LTC1569-7IGN-PBF/716983)

| Spec | Value |
|---|---|
| type | 10th order elliptic LPF |
| cutoff_range | 10 kHz to 150 kHz (tunable to 5 MHz in cascade) |
| passband_ripple | 0.1 dB |
| stopband_attenuation | 50 dB |
| dynamic_range | 110 dB |
| supply | +/-5V or single +5V |
| package | SSOP-16 |

**Alternatives:**
- **[ADA4899-1 (op-amp for active LC filter)](https://www.analog.com/en/search.html#q=ADA4899-1%20%28op-amp%20for%20active%20LC%20filter%29)** (Analog Devices): Higher bandwidth, manual filter design needed

**Selection Rationale:** Provides steep roll-off needed to meet 10 MHz IBW with good stopband attenuation. Low group delay variation supports the < 1 ns requirement.

### 12. DC-DC converter — steps down +28V to +5V for powering RF chain, synthesizer, and baseband.

**Primary Choice:** [LTM8074](https://www.analog.com/en/search.html#q=LTM8074) (Analog Devices)

**

[📄 Datasheet](https://www.analog.com/en/search.html#q=LTM8074)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/LTM8074IY-5-PBF/10413262)

| Spec | Value |
|---|---|
| input_range | 4.5 to 40V |
| output | 1.2 to 12V adjustable |
| current | 1.2A |
| switching_freq | 1.5 MHz |
| efficiency | 90% |
| package | uModule BGA 6.25x6.25 mm |
| isolation | Non-isolated |

**Alternatives:**
- **[VXR10-28S5](https://en.cosel.co.jp/product/search/?q=VXR10-28S5)** (Cosel): Isolated converter, higher current, larger footprint

**Selection Rationale:** Compact uModule with 40V max input covers +28V MIL bus with margin. 1.2A output sufficient for 5-15W total budget. Internal inductor reduces component count.

### 13. Low-noise LDO — generates clean +3.3V rail from +5V for PLL synthesizer, VCO tuning, and control logic.

**Primary Choice:** [LT3045](https://www.analog.com/en/search.html#q=LT3045) (Analog Devices)

**

[📄 Datasheet](https://www.analog.com/en/search.html#q=LT3045)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/LT3045EDF-PBF/5110258)

| Spec | Value |
|---|---|
| input_range | 1.8 to 20V |
| output | 0 to 15V adjustable |
| current | 500 mA |
| noise | 0.8 uVrms (10 Hz to 100 kHz) |
| psrr | 82 dB at 1 MHz |
| dropout | 260 mV |
| package | DFN 3x3 mm |

**Alternatives:**
- **[TPS7A4700](https://www.ti.com/product/TPS7A4700)** (Texas Instruments): Higher current (1A), slightly higher noise

**Selection Rationale:** Ultra-low noise (0.8 uVrms) and high PSRR (82 dB) prevent supply noise from degrading phase noise performance of the PLL/VCO.
