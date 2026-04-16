# Component Recommendations
## dfbvd

### 1. Wideband Low Noise Amplifier (5-18 GHz)

**Primary Choice:** [HMC1099LP4E](https://www.analog.com/en/search.html#q=HMC1099LP4E) (Analog Devices)

*GaAs MMIC PHEMT wideband low noise amplifier, 5-18 GHz, 20dB gain, 3.5dB NF, 21dBm P1dB, matches sensitivity requirements.*

[📄 Datasheet](https://www.analog.com/en/search.html#q=HMC1099LP4E)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/HMC1099LP4E/5960063)

| Spec | Value |
|---|---|
| frequency_range | 5-18 GHz |
| gain | 20 dB |
| noise_figure | 3.5 dB |
| p1db | 21 dBm |
| supply_current | 90 mA |
| package | 4x4 mm QFN |

**Alternatives:**
- **[MGA-31516](https://www.qorvo.com/products/d/PA004652)** (Qorvo): Similar performance, slightly higher NF 4dB, lower cost
- **[TQP3M9036](https://www.qorvo.com/products/d/PA005438)** (Qorvo): Wider bandwidth 2-20GHz, similar gain, NF 3.8dB

**Selection Rationale:** Selected for optimal NF (3.5dB) and gain (20dB) in 5-18GHz band to achieve -100dBm sensitivity. Industrial temp range, low power consumption suitable for portable module.

### 2. Wideband Mixer for Downconversion

**Primary Choice:** [HMC1022LP4E](https://www.analog.com/en/search.html#q=HMC1022LP4E) (Analog Devices)

*GaAs MMIC double-balanced mixer, 6-18 GHz RF/LO, 0-8 GHz IF, 9dB conversion loss, 24dBm IIP3.*

[📄 Datasheet](https://www.analog.com/en/search.html#q=HMC1022LP4E)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/HMC1022LP4E/5960062)

| Spec | Value |
|---|---|
| rf_lo_range | 6-18 GHz |
| if_range | DC-8 GHz |
| conversion_loss | 9 dB |
| iip3 | 24 dBm |
| lo_drive | 13-17 dBm |
| package | 4x4 mm QFN |

**Alternatives:**
- **[MAMC-000377-DIE](https://www.google.com/search?q=MAMC-000377-DIE+datasheet)** (Macom): Die form, wider 2-22GHz range, similar conversion loss
- **[MMIC-1004-DIE](https://www.custommmic.com/datasheets/MMIC-1004-DIE.pdf)** (Custom MMIC): Lower IIP3 20dBm, lower cost option

**Selection Rationale:** Excellent linearity (24dBm IIP3) contributes to 70-80dB SFDR goal. Low conversion loss improves cascaded NF. Wideband operation covers full 5-18GHz band.

### 3. PLL Frequency Synthesizer (LO Source)

**Primary Choice:** [ADF5356](https://www.analog.com/en/search.html#q=ADF5356) (Analog Devices)

*Wideband synthesizer with integrated VCO, 53.125 MHz to 13.6 GHz, -136 dBc/Hz phase noise at 1 kHz offset.*

[📄 Datasheet](https://www.analog.com/en/search.html#q=ADF5356)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/ADF5356CCPZ/6178623)

| Spec | Value |
|---|---|
| frequency_range | 53.125 MHz - 13.6 GHz |
| phase_noise | -136 dBc/Hz @ 1kHz |
| frequency_resolution | < 1 Hz |
| supply_current | 180 mA |
| package | 5x5 mm LFCSP |

**Alternatives:**
- **[LMX2595](https://www.ti.com/product/LMX2595)** (Texas Instruments): Similar specs, lower power 150mA, wider freq range to 20GHz
- **[HMC7044](https://www.analog.com/en/search.html#q=HMC7044)** (Analog Devices): Multi-loop synthesizer with better phase noise, more complex

**Selection Rationale:** Wideband output covers full LO requirements for 5-18GHz downconversion. Excellent phase noise critical for SFDR. Industrial temp rated.

### 4. High-Speed ADC (100-500 MSPS)

**Primary Choice:** [ADC12DJ3200](https://www.ti.com/product/ADC12DJ3200) (Texas Instruments)

*Dual-channel 12-bit ADC, up to 6.4 GSPS (3200 MSPS per channel), JESD204B output, 59 dB SNR, 70 dB SFDR.*

[📄 Datasheet](https://www.ti.com/product/ADC12DJ3200)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/texas-instruments/ADC12DJ3200AIRGZ/6048224)

| Spec | Value |
|---|---|
| resolution | 12 bit |
| max_sample_rate | 6400 MSPS (3200 per ch) |
| snr | 59 dB |
| sfdr | 70 dB |
| interface | JESD204B |
| power | 1.8W |

**Alternatives:**
- **[AD9208](https://www.analog.com/en/search.html#q=AD9208)** (Analog Devices): Single 14-bit ADC, 1 GSPS, better SNR 66dB, higher cost
- **[ISLA214P50](https://www.renesas.com/us/en/www/doc/datasheet/isla214p50.pdf)** (Renesas (Intersil)): 14-bit 500 MSPS, parallel LVDS, simpler interface

**Selection Rationale:** Exceeds 100-500 MSPS requirement with margin. 70 dB SFDR meets spec directly. JESD204B output simplifies LVDS interface. Industrial temp qualified.

### 5. Variable Gain IF Amplifier

**Primary Choice:** [ADL5202](https://www.analog.com/en/search.html#q=ADL5202) (Analog Devices)

*Digital variable gain amplifier, 100 MHz to 2.5 GHz, 0-26 dB gain range, 44 dBm OIP3, 8-bit gain control.*

[📄 Datasheet](https://www.analog.com/en/search.html#q=ADL5202)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/ADL5202ACPZN-R7/1921147)

| Spec | Value |
|---|---|
| frequency_range | 100-2500 MHz |
| gain_range | 0-26 dB |
| oip3 | 44 dBm |
| noise_figure | 6.5 dB |
| gain_control | 8-bit digital |

**Alternatives:**
- **[LMH6401](https://www.ti.com/product/LMH6401)** (Texas Instruments): Wider bandwidth 1 GHz, analog control voltage
- **[HMC698LP4](https://www.analog.com/en/search.html#q=HMC698LP4)** (Analog Devices): Higher frequency up to 6 GHz, narrower gain range

**Selection Rationale:** Wideband VGA with 26dB gain range for AGC. High OIP3 (44dBm) maintains SFDR. Digital gain control enables precise level adjustment for ADC.

### 6. DC-DC Converter (12V to Distribution Voltages)

**Primary Choice:** [LTM8074](https://www.analog.com/en/search.html#q=LTM8074) (Analog Devices)

*4V to 40V input, 0.8V to 10V output, 3A µModule regulator, low noise, high efficiency.*

[📄 Datasheet](https://www.analog.com/en/search.html#q=LTM8074)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/LTM8074EV-21-PBF/6271680)

| Spec | Value |
|---|---|
| vin | 4-40 V |
| vout | 0.8-10 V |
| iout | 3 A |
| switching_freq | 2 MHz |
| efficiency | > 90% |

**Alternatives:**
- **[TPS62913](https://www.ti.com/product/TPS62913)** (Texas Instruments): Lower current 2A, smaller size, lower cost
- **[LMR33630](https://www.ti.com/product/LMR33630)** (Texas Instruments): 3.5A, fixed output options, good for bulk supply

**Selection Rationale:** Wide input range accepts 12V military supply. µModule packaging reduces layout complexity. Low noise switching minimizes interference to sensitive RF circuits.

### 7. Low Noise LDO Regulator (RF Supply)

**Primary Choice:** [LT3045](https://www.analog.com/en/search.html#q=LT3045) (Analog Devices)

*Ultra-low noise LDO, 0.8µV RMS, 20V input, 500mA output, high PSRR.*

[📄 Datasheet](https://www.analog.com/en/search.html#q=LT3045)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/LT3045EDD-PBF/5625757)

| Spec | Value |
|---|---|
| vin | 20 V |
| vout | 0-15 V |
| iout | 500 mA |
| noise | 0.8 uV RMS |
| psrr | 79 dB @ 1kHz |

**Alternatives:**
- **[LT1965](https://www.analog.com/en/search.html#q=LT1965)** (Analog Devices): Lower noise 14uV RMS, 1.1A output
- **[TPS7A47](https://www.ti.com/product/TPS7A47)** (Texas Instruments): 4uV RMS, higher current 1A, similar PSRR

**Selection Rationale:** Ultra-low noise critical for LNA and mixer performance. High PSRR rejects switching regulator noise. Industrial temp operation.

### 8. RF Bandpass Filter (5-18 GHz)

**Primary Choice:** [CBP-5180-C+](https://www.qorvo.com/products/d/PA001133) (Qorvo (Mini-Circuits))

*Wideband bandpass filter, 5-18 GHz, 2.5dB insertion loss, 50 dB rejection at 3GHz and 22GHz.*

[📄 Datasheet](https://www.qorvo.com/products/d/PA001133)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/qorvo/CBP-5180-C/3652893)

| Spec | Value |
|---|---|
| passband | 5-18 GHz |
| insertion_loss | 2.5 dB |
| rejection | > 50 dB |
| vswr | < 2.0:1 |
| package | 0402 surface mount |

**Alternatives:**
- **[BP5G18G-18J](https://www.google.com/search?q=BP5G18G-18J+datasheet)** (Anatech Electronics): Custom filter, tighter specs, longer lead time
- **[VBF-1550+](https://www.google.com/search?q=VBF-1550%2B+datasheet)** (Mini-Circuits): Narrower band example, not suitable for wideband design

**Selection Rationale:** Defines passband for receiver. Low insertion loss (2.5dB) maintains cascaded NF. Excellent out-of-band rejection reduces interference. Compact for portable module.
