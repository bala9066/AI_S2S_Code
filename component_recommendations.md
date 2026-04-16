# Component Recommendations
## sample rf

### 1. Wideband Low Noise Amplifier (LNA) - Front-end gain stage with low noise figure

**Primary Choice:** [HMC698LP4](https://www.analog.com/en/search.html#q=HMC698LP4) (Analog Devices)

*GaAs MMIC LNA, 2-20 GHz, 14 dB gain, 3.5 dB noise figure, +18 dBm P1dB*

[📄 Datasheet](https://www.analog.com/en/search.html#q=HMC698LP4)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/hmc698lp4-etrs/5526140)

| Spec | Value |
|---|---|
| frequency_range | 2-20 GHz |
| gain | 14 dB |
| noise_figure | 3.5 dB |
| p1db | +18 dBm |
| oip3 | +28 dBm |
| supply | 5V @ 80 mA |

**Alternatives:**
- **[MGA-61563](https://www.qorvo.com/products/d/da001938)** (Qorvo): Lower gain (12 dB) but lower power consumption
- **[MMIC MGA-13516](https://www.google.com/search?q=MMIC%20MGA-13516+datasheet)** (Macom): Wider bandwidth (DC-20 GHz) but higher NF

**Selection Rationale:** Selected HMC698LP4 for excellent noise figure (3.5 dB), gain (14 dB), and linearity (+28 dBm OIP3) covering the full 5-18 GHz band. Industrial temperature rating and RoHS compliant.

### 2. Wideband Mixer - RF downconverter for frequency translation

**Primary Choice:** [HMC1119LP4](https://www.analog.com/en/search.html#q=HMC1119LP4) (Analog Devices)

*GaAs MMIC mixer, 6-18 GHz, 8 dB conversion loss, +15 dBm P1dB*

[📄 Datasheet](https://www.analog.com/en/search.html#q=HMC1119LP4)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/hmc1119lp4etrs/5919145)

| Spec | Value |
|---|---|
| rf_frequency | 6-18 GHz |
| lo_frequency | DC-18 GHz |
| if_frequency | DC-6 GHz |
| conversion_loss | 8 dB |
| lo_drive | +10 to +15 dBm |
| p1db | +15 dBm |

**Alternatives:**
- **[MCA-22-24](https://www.google.com/search?q=MCA-22-24+datasheet)** (Marki Microwave): Lower conversion loss but narrower bandwidth
- **[MAD-10](https://www.google.com/search?q=MAD-10+datasheet)** (Mini-Circuits): Lower cost but higher conversion loss

**Selection Rationale:** Selected HMC1119LP4 for wideband operation (6-18 GHz), low conversion loss (8 dB), and good linearity matching the OIP3 requirements.

### 3. IF Amplifier - Intermediate frequency gain stage

**Primary Choice:** [ADA4817-1](https://www.analog.com/en/search.html#q=ADA4817-1) (Analog Devices)

*High-speed op-amp, 1 GHz bandwidth, low noise, low distortion*

[📄 Datasheet](https://www.analog.com/en/search.html#q=ADA4817-1)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/ADA4817-1ACPZ-R7/1176299)

| Spec | Value |
|---|---|
| bandwidth | 1 GHz |
| voltage_noise | 4 nV/rtHz |
|  slew_rate | 1000 V/us |
| supply | 5V to 10V |

**Alternatives:**
- **[OPA659](https://www.ti.com/product/OPA659)** (Texas Instruments): Similar performance but slightly higher noise
- **[THS4304](https://www.ti.com/product/THS4304)** (Texas Instruments): Higher bandwidth (1.8 GHz) but higher power

**Selection Rationale:** Selected ADA4817-1 for high bandwidth (1 GHz), low noise (4 nV/rtHz), and excellent distortion performance suitable for baseband signal conditioning.

### 4. High-Speed ADC - Digitizer for baseband IQ conversion

**Primary Choice:** [ADC12J4000](https://www.ti.com/product/ADC12J4000) (Texas Instruments)

*12-bit, 4 GSPS ADC with integrated DDC*

[📄 Datasheet](https://www.ti.com/product/ADC12J4000)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/texas-instruments/ADC12J4000EVM/4590319)

| Spec | Value |
|---|---|
| resolution | 12-bit |
| sample_rate | 4 GSPS |
| analog_bandwidth | 2.2 GHz |
| input_voltage | 1V p-p diff |
| supply | 3.3V and 1.8V |

**Alternatives:**
- **[AD9208](https://www.analog.com/en/search.html#q=AD9208)** (Analog Devices): Higher resolution (14-bit) but lower sample rate (3 GSPS)
- **[AT78400](https://www.google.com/search?q=AT78400+datasheet)** (Teledyne e2v): Radiation tolerant but higher cost

**Selection Rationale:** Selected ADC12J4000 for high sampling rate (4 GSPS) supporting the wide bandwidth requirement with 12-bit resolution and integrated digital down-converter for IQ output.

### 5. Wideband Bandpass Filter - Input filtering for 5-18 GHz

**Primary Choice:** [BP0650-18-10-S1](https://www.google.com/search?q=BP0650-18-10-S1+datasheet) (Mini-Circuits)

*Bandpass filter, 5-18 GHz, 10% passband*

[📄 Datasheet](https://www.google.com/search?q=BP0650-18-10-S1+datasheet)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/mini-circuits/BP0650-18-10-S1/3898169)

| Spec | Value |
|---|---|
| passband | 5-18 GHz |
| insertion_loss | 2 dB |
| rejection | 40 dB @ 2 GHz, 3 GHz |
| vswr | 2.0:1 |

**Alternatives:**
- **[RBP-518+](https://www.google.com/search?q=RBP-518%2B+datasheet)** (Mini-Circuits): Cheaper but higher insertion loss
- **[LBF-18-18+](https://www.google.com/search?q=LBF-18-18%2B+datasheet)** (Mini-Circuits): Lower frequency range (6-18 GHz)

**Selection Rationale:** Selected BP0650-18-10-S1 for covering the full 5-18 GHz band with low insertion loss (2 dB) and good out-of-band rejection.

### 6. Power Management - Voltage regulation for 5-12V input

**Primary Choice:** [LTM4650](https://www.analog.com/en/search.html#q=LTM4650) (Analog Devices)

*36 V, 10 A Step-Down Silent Switcher Module*

[📄 Datasheet](https://www.analog.com/en/search.html#q=LTM4650)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/LTM4650IUHPF-1PBF/6004231)

| Spec | Value |
|---|---|
| input_voltage | 4.5V to 36V |
| output_current | 10 A |
| switching_frequency | 2.2 MHz |
| efficiency | 95% |

**Alternatives:**
- **[TPS546D24A](https://www.ti.com/lit/ds/symlink/tps546d24a.pdf)** (Texas Instruments): Lower cost but higher output ripple
- **[LT8645](https://www.analog.com/en/search.html#q=LT8645)** (Analog Devices): Single output, simpler design

**Selection Rationale:** Selected LTM4650 for wide input range (4.5-36V) accommodating 5-12V supply, high efficiency (95%), and low EMI Silent Switcher technology suitable for RF applications.

### 7. RF Connector - SMA input connector for 5-18 GHz

**Primary Choice:** [142-0701-851](https://www.cinch.com/products/detail/142-0701-851) (Cinch Connectivity Solutions)

*SMA PCB jack, 50 ohm, end launch*

[📄 Datasheet](https://www.cinch.com/products/detail/142-0701-851)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/cinch-connectivity-solutions-johnson/142-0701-851/1579921)

| Spec | Value |
|---|---|
| frequency | DC to 18 GHz |
| vswr | 1.3:1 max |
| impedance | 50 ohms |

**Alternatives:**
- **[73251-135](https://www.google.com/search?q=73251-135+datasheet)** (Molex): Lower frequency rating (12.4 GHz)
- **[0688995534](https://www.te.com/en/search.html#q=0688995534)** (TE Connectivity): Higher VSWR

**Selection Rationale:** Selected 142-0701-851 for good performance to 18 GHz, low VSWR (1.3:1), and end-launch PCB mounting for minimal RF discontinuity.
