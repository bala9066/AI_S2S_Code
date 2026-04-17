# Component Recommendations
## Receiver Module

### 1. Wideband Low Noise Amplifier (5-18 GHz)

**Primary Choice:** [HMC6180LP4E](https://www.analog.com/en/search.html#q=HMC6180LP4E) (Analog Devices)

*GaAs MMIC LNA, 5-20 GHz, 2.0 dB typical NF, 20 dB gain, +3V operation, military temperature range available.*

[📄 Datasheet](https://www.analog.com/en/search.html#q=HMC6180LP4E)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/hmc6180lp4e/5616633)

| Spec | Value |
|---|---|
| frequency_range | 5-20 GHz |
| noise_figure | 2.0 dB typical |
| gain | 20 dB typical |
| p1db | +18 dBm |
| supply_voltage | +3 to +5V |
| operating_temp | -55 to +125°C (HMC grade) |

**Alternatives:**
- **[TQP3M9036](https://www.qorvo.com/products/d/da001858)** (Qorvo): Slightly higher NF (2.5 dB) but higher OIP3 (+33 dBm) for improved linearity

**Selection Rationale:** Selected for ultra-low noise figure (<2 dB) across 5-18 GHz band, meeting system NF <3 dB requirement with margin. Military temperature rating available.

### 2. Variable Gain Amplifier / Attenuator

**Primary Choice:** [HMC698LP4](https://www.analog.com/en/search.html#q=HMC698LP4) (Analog Devices)

*Digital variable gain amplifier, 0.5-20 GHz, 31.5 dB gain range in 0.5 dB steps, 8-bit parallel control.*

[📄 Datasheet](https://www.analog.com/en/search.html#q=HMC698LP4)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/hmc698lp4/5617301)

| Spec | Value |
|---|---|
| frequency_range | 0.5-20 GHz |
| gain_range | 31.5 dB |
| step_size | 0.5 dB |
| noise_figure | 5 dB typical |
| ip3 | +30 dBm |
| supply_voltage | +5V |

**Alternatives:**
- **[PE4306](https://www.google.com/search?q=PE4306+datasheet)** (pSemi): Silicon-based, 0-4 GHz only (not suitable - need higher frequency)
- **[HMC941LP4E](https://www.analog.com/en/search.html#q=HMC941LP4E)** (Analog Devices): 6-bit digital attenuator, DC-14 GHz (limited coverage at high end)

**Selection Rationale:** Wideband coverage across full 5-18 GHz range with 31.5 dB gain control range exceeding 20 dB requirement. Parallel interface allows simple MCU or FPGA control for AGC implementation.

### 3. Wideband Mixer (Downconversion)

**Primary Choice:** [HMC556LC4](https://www.analog.com/en/search.html#q=HMC556LC4) (Analog Devices)

*Double-balanced mixer, 5-26 GHz RF, 0.1-6 GHz IF, +7 dBm LO drive, 9 dB conversion loss.*

[📄 Datasheet](https://www.analog.com/en/search.html#q=HMC556LC4)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/hmc556lc4/5616557)

| Spec | Value |
|---|---|
| rf_frequency | 5-26 GHz |
| if_frequency | DC-6 GHz |
| lo_drive | +7 dBm |
| conversion_loss | 9 dB typical |
| lo_to_rf_isolation | 35 dB |
| supply_voltage | +5V |

**Alternatives:**
- **[MAMX-011027-DIE](https://www.google.com/search?q=MAMX-011027-DIE+datasheet)** (MACOM): Die format, 6-18 GHz, lower conversion loss (7 dB)
- **[ADL5801](https://www.analog.com/en/search.html#q=ADL5801)** (Analog Devices): 10 MHz to 6 GHz only (insufficient frequency range)

**Selection Rationale:** Single device covers entire 5-18 GHz RF range with excellent conversion loss and isolation. Operates from +5V supply simplifying power rail design.

### 4. LDO Regulator for RF Circuits (+3.3V)

**Primary Choice:** [LT3045EDD#PBF](https://www.analog.com/en/search.html#q=LT3045EDD%23PBF) (Analog Devices)

*Ultra-low noise LDO regulator, 20V input, 500mA output, 0.8uV RMS noise, military temp available.*

[📄 Datasheet](https://www.analog.com/en/search.html#q=LT3045EDD%23PBF)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/lt3045edd-pbf/5064042)

| Spec | Value |
|---|---|
| input_voltage | 20V max |
| output_voltage | Adjustable 0-15V |
| output_current | 500 mA |
| output_noise | 0.8 uV RMS |
| psrr | 79 dB @ 10 kHz |
| operating_temp | -55 to +125°C (MP grade) |

**Alternatives:**
- **[TPS7A4700](https://www.ti.com/product/TPS7A4700)** (Texas Instruments): Slightly higher noise (4 uV RMS), lower cost

**Selection Rationale:** Ultra-low output noise critical for sensitive RF receiver front-end. High PSRR rejects +12V supply noise. Military temp range available.

### 5. LDO Regulator for +5V Rail

**Primary Choice:** [LT3094EDD#PBF](https://www.analog.com/en/search.html#q=LT3094EDD%23PBF) (Analog Devices)

*Low noise negative LDO (used for positive rail), 500mA, 0.8uV RMS noise, military temp available.*

[📄 Datasheet](https://www.analog.com/en/search.html#q=LT3094EDD%23PBF)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/lt3094edd-pbf/5405525)

| Spec | Value |
|---|---|
| input_voltage | 20V max |
| output_voltage | Adjustable |
| output_current | 500 mA |
| output_noise | 0.8 uV RMS |
| operating_temp | -55 to +125°C (MP grade) |

**Alternatives:**
- **[LT1763A](https://www.analog.com/en/search.html#q=LT1763A)** (Analog Devices): 500 mA max, 20 uV RMS noise (higher)

**Selection Rationale:** Provides clean +5V rail for mixer and VGA. Matches LT3045 family for common design approach. Military temp rated.

### 6. RF Input/Output SMA Connector

**Primary Choice:** [142-0701-881](https://www.google.com/search?q=142-0701-881+datasheet) (Cinch Connectivity Solutions)

*SMA female connector, 2-hole flange mount, 50 ohm, stainless steel, gold-plated contact.*

[📄 Datasheet](https://www.google.com/search?q=142-0701-881+datasheet)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/cinch-connectivity-solutions-johnson/142-0701-881/1646215)

| Spec | Value |
|---|---|
| impedance | 50 ohms |
| frequency | DC-18 GHz |
| mounting | 2-hole flange |
| contact_plating | Gold over nickel |
| body_material | Stainless steel |

**Alternatives:**
- **[0734110125](https://www.google.com/search?q=0734110125+datasheet)** (Molex): End-launch PCB mount (different footprint)

**Selection Rationale:** Flange mount provides robust mechanical connection for vibration environments. Rated to 18 GHz with excellent VSWR performance.

### 7. DC Blocking Capacitor (RF)

**Primary Choice:** [0402HT Series](https://www.google.com/search?q=0402HT%20Series+datasheet) (AVX)

*High-frequency 0402 ceramic capacitor, 100 pF, C0G dielectric, low ESR, 0.040" x 0.020".*

[📄 Datasheet](https://www.google.com/search?q=0402HT%20Series+datasheet)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/avx-corporation/04025C103KAT2A/478-1008-1-ND)

| Spec | Value |
|---|---|
| capacitance | 100 pF |
| dielectric | C0G/NP0 |
| voltage_rating | 50V |
| esr | <0.1 ohm |
| srf | >2 GHz |
| case_size | 0402 |

**Alternatives:**
- **[GRM1555C1H101JA01](https://www.murata.com/en-us/products/productdetail?partno=GRM1555C1H101JA01%23)** (Murata): 0402 C0G, 100 pF, 50V (similar specs)

**Selection Rationale:** C0G dielectric provides stable capacitance and low loss at microwave frequencies. 100 pF presents low reactance at 5 GHz (~0.3 ohm).
