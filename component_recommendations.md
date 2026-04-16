# Component Recommendations
## sample

### 1. Wideband LNA 5-18 GHz

**Primary Choice:** [HMC1134](https://www.analog.com/en/search.html#q=HMC1134) (Analog Devices)

*GaAs MMIC LNA, 5-18 GHz, 19 dB gain, 2.5 dB NF, +20 dBm P1dB*

[📄 Datasheet](https://www.analog.com/en/search.html#q=HMC1134)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/hmc1134lp4etr/6130665)

| Spec | Value |
|---|---|
| freq_range | 5-18 GHz |
| gain | 19 dB |
| noise_figure | 2.5 dB |
| p1db | +20 dBm |
| supply | +5V |
| current | 85 mA |

**Alternatives:**
- **[TQP3M9036](https://www.qorvo.com/products/d/20001885)** (Qorvo): Slightly higher NF, lower power
- **[AMA-0090-1201](https://www.custommmic.com/documents/datasheets/AMA-0090-1201.pdf)** (Custom MMIC): Similar specs, alternate source

**Selection Rationale:** Excellent noise figure (2.5 dB) ensures system meets <10 dB cascaded NF. Wideband coverage eliminates need for multiple LNAs per band.

### 2. RF Band Switch

**Primary Choice:** [HMC1118](https://www.analog.com/en/search.html#q=HMC1118) (Analog Devices)

*GaAs SPDT reflective switch, DC-18 GHz, +20 dBm power handling*

[📄 Datasheet](https://www.analog.com/en/search.html#q=HMC1118)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/hmc1118lp3e/6130672)

| Spec | Value |
|---|---|
| freq_range | DC-18 GHz |
| insertion_loss | 1.2 dB |
| isolation | 40 dB |
| switching_time | 3 ns |
| supply | -5V/-3V or +5V |

**Alternatives:**
- **[MASWSS0222](https://www.google.com/search?q=MASWSS0222+datasheet)** (MACOM): Lower power handling

**Selection Rationale:** Fast switching for band selection. High isolation prevents band interference. Low insertion loss preserves NF.

### 3. Wideband Mixer

**Primary Choice:** [HMC559](https://www.analog.com/en/search.html#q=HMC559) (Analog Devices)

*GaAs MMIC mixer, 5-20 GHz, +15 dBm LO drive*

[📄 Datasheet](https://www.analog.com/en/search.html#q=HMC559)

| Spec | Value |
|---|---|
| freq_range | 5-20 GHz |
| conversion_loss | 7 dB |
| lo_drive | +15 dBm |
| ip3 | +25 dBm |
| supply | +5V |

**Alternatives:**
- **[MM1-0113SSS](https://www.google.com/search?q=MM1-0113SSS+datasheet)** (Marki Microwave): Lower conversion loss, higher LO drive

**Selection Rationale:** Wideband mixer covers entire frequency range. Integrated IF amplifier simplifies design.

### 4. IF VGA / Attenuator

**Primary Choice:** [AD8376](https://www.analog.com/en/search.html#q=AD8376) (Analog Devices)

*Digital VGA, 700 MHz bandwidth, 0-31.5 dB gain range*

[📄 Datasheet](https://www.analog.com/en/search.html#q=AD8376)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/ad8376abczz/1288313)

| Spec | Value |
|---|---|
| bandwidth | 700 MHz |
| gain_range | 0-31.5 dB |
| gain_step | 0.5 dB |
| noise_figure | 11 dB |
| supply | +5V |

**Alternatives:**
- **[HMC698LP4](https://www.analog.com/en/search.html#q=HMC698LP4)** (Analog Devices): Lower bandwidth, simpler interface

**Selection Rationale:** Provides programmable gain for -40 to -10 dBm input range. Digital control enables AGC implementation.

### 5. High-Speed ADC

**Primary Choice:** [AD9208](https://www.analog.com/en/search.html#q=AD9208) (Analog Devices)

*Dual, 12-bit, 3 GSPS ADC with JESD204B/C*

[📄 Datasheet](https://www.analog.com/en/search.html#q=AD9208)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/ad9208-2500ebz/6170856)

| Spec | Value |
|---|---|
| resolution | 12-bit |
| max_sample_rate | 3 GSPS |
| sfdr | 60 dB |
| interface | JESD204B/C |
| supply | 1.25V/2.5V |

**Alternatives:**
- **[ADC12DJ3200](https://www.ti.com/lit/ds/symlink/adc12dj3200.pdf)** (Texas Instruments): Similar specs, JESD204C only
- **[RF12ADC3000](https://www.google.com/search?q=RF12ADC3000+datasheet)** (Teledyne e2v): Higher performance, higher power

**Selection Rationale:** Exceeds 2 GSPS requirement with margin. JESD204B/C interface supports custom digital logic. Dual channels provide flexibility.

### 6. Clock Generator / Jitter Cleaner

**Primary Choice:** [LMK04828](https://www.ti.com/product/LMK04828) (Texas Instruments)

*Ultra-low jitter clock generator with dual PLL*

[📄 Datasheet](https://www.ti.com/product/LMK04828)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/texas-instruments/LMK04828BSSQ-NOPB/5904034)

| Spec | Value |
|---|---|
| output_freq | Up to 3.1 GHz |
| jitter_rms | 70 fs |
| outputs | 14 differential |
| supply | 3.3V |

**Alternatives:**
- **[AD9528](https://www.analog.com/en/search.html#q=AD9528)** (Analog Devices): Similar performance, different feature set

**Selection Rationale:** Ultra-low jitter ensures ADC SNR performance. Flexible outputs can clock ADC, mixer LO, and digital logic.

### 7. Wideband PLL / LO Source

**Primary Choice:** [HMC7044](https://www.analog.com/en/search.html#q=HMC7044) (Analog Devices)

*Ultra-low phase noise fractional-N PLL*

[📄 Datasheet](https://www.analog.com/en/search.html#q=HMC7044)

| Spec | Value |
|---|---|
| freq_range | DC-13 GHz |
| phase_noise | -137 dBc/Hz @ 1 MHz |
| supply | 3.3V/5V |

**Alternatives:**
- **[LMX2594](https://www.ti.com/product/LMX2594)** (Texas Instruments): Higher frequency, integrated VCO

**Selection Rationale:** Low phase noise LO ensures mixer performance. Fractional-N enables fine frequency tuning across 5-18 GHz range.

### 8. Power Management - 3.3V

**Primary Choice:** [LT8610](https://www.analog.com/en/search.html#q=LT8610) (Analog Devices)

*42V input synchronous step-down regulator*

[📄 Datasheet](https://www.analog.com/en/search.html#q=LT8610)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc-linear-technology/lt8610eq-pbf/4638426)

| Spec | Value |
|---|---|
| input_range | 3.4-42V |
| output | 3.3V |
| current | 2.5A |
| switching_freq | 500 kHz |
| efficiency | >90% |

**Alternatives:**
- **[TPS562201](https://www.ti.com/lit/ds/symlink/tps562201.pdf)** (Texas Instruments): Lower input voltage, smaller footprint

**Selection Rationale:** High efficiency reduces power consumption. Low EMI switching minimizes RF interference.

### 9. Power Management - 2.5V (ADC)

**Primary Choice:** [LT3045](https://www.analog.com/en/search.html#q=LT3045) (Analog Devices)

*Ultra-low noise LDO regulator*

[📄 Datasheet](https://www.analog.com/en/search.html#q=LT3045)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc-linear-technology/lt3045eddpbf/5268433)

| Spec | Value |
|---|---|
| input_range | 2.0-20V |
| output | 2.5V |
| current | 500 mA |
| noise | 0.8 uVrms |

**Alternatives:**
- **[TPS7A47](https://www.ti.com/lit/ds/symlink/tps7a47.pdf)** (Texas Instruments): Similar performance, pin compatible

**Selection Rationale:** Ultra-low noise ensures ADC clean power rails. High PSRR prevents supply ripple coupling.

### 10. Power Management - 1.8V (Digital)

**Primary Choice:** [TPS62913](https://www.ti.com/lit/ds/symlink/tps62913.pdf) (Texas Instruments)

*Low-noise 2A buck converter*

[📄 Datasheet](https://www.ti.com/lit/ds/symlink/tps62913.pdf)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/texas-instruments/TPS62913RPWR/11179904)

| Spec | Value |
|---|---|
| input_range | 3-17V |
| output | 1.8V |
| current | 2A |
| noise | 10 uVrms |

**Alternatives:**
- **[LT8652S](https://www.analog.com/en/search.html#q=LT8652S)** (Analog Devices): Higher current, Silent Switcher

**Selection Rationale:** Low-noise switching regulator suitable for digital logic. High efficiency contributes to <30W power budget.

### 11. Control MCU

**Primary Choice:** [STM32H743](https://www.st.com/en/search.html#q=STM32H743) (STMicroelectronics)

*ARM Cortex-M7 MCU 480 MHz*

[📄 Datasheet](https://www.st.com/en/search.html#q=STM32H743)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/stmicroelectronics/STM32H743VIT6/10054319518)

| Spec | Value |
|---|---|
| core | Cortex-M7 |
| speed | 480 MHz |
| flash | 2 MB |
| ram | 1 MB |
| io | Up to 168 pins |
| supply | 1.8-3.6V |

**Alternatives:**
- **[MK66FX1M0](https://www.nxp.com/search#q=MK66FX1M0)** (NXP): Cortex-M4, slightly lower performance

**Selection Rationale:** High performance for digital interface processing. Extensive GPIO and SPI for RF front-end control. Industrial temp range available.
