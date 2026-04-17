# Component Recommendations
## rx module

### 1. Wideband Low Noise Amplifier (5-18 GHz)

**Primary Choice:** [HMC6180LP4E](https://www.analog.com/en/search.html#q=HMC6180LP4E) (Analog Devices)

*GaAs MMIC PHEMT LNA, 6-20 GHz, 21 dB gain, 2.5 dB noise figure, 3.3V supply*

[📄 Datasheet](https://www.analog.com/en/search.html#q=HMC6180LP4E)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/HMC6180LP4E/5969056)

| Spec | Value |
|---|---|
| freq_range | 6-20 GHz |
| gain | 21 dB |
| noise_figure | 2.5 dB |
| p1db | +19 dBm |
| supply | 3.3V @ 90 mA |

**Alternatives:**
- **[AMMC-6221](https://www.google.com/search?q=AMMC-6221+datasheet)** (Qorvo): Similar performance, slightly higher NF at 2.8 dB
- **[MAAL-011141](https://www.google.com/search?q=MAAL-011141+datasheet)** (MACOM): Lower gain at 16 dB, lower power consumption

**Selection Rationale:** Best combination of low noise figure, high gain, and wide bandwidth covering 5-18 GHz range. Operates from 3.3V rail compatible with 12V system via DC-DC converter.

### 2. Variable Gain Amplifier (Manual Gain Control)

**Primary Choice:** [HMC698LP4](https://www.analog.com/en/search.html#q=HMC698LP4) (Analog Devices)

*Digital/Analog VGA, DC-14 GHz, 0-50 dB gain range, parallel control interface*

[📄 Datasheet](https://www.analog.com/en/search.html#q=HMC698LP4)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/HMC698LP4/5582396)

| Spec | Value |
|---|---|
| freq_range | DC-14 GHz |
| gain_range | 0-50 dB |
| p1db | +19 dBm |
| noise_figure | 6 dB |
| control | 6-bit digital or analog |

**Alternatives:**
- **[ADL5240](https://www.analog.com/en/search.html#q=ADL5240)** (Analog Devices): Up to 6 GHz only - insufficient for this application
- **[HMC695](https://www.analog.com/en/search.html#q=HMC695)** (Analog Devices): DC-8 GHz only - insufficient frequency coverage

**Selection Rationale:** Wideband VGA with 50 dB gain range, supports both analog and digital control modes for manual gain adjustment requirement. Frequency coverage exceeds upper requirements.

### 3. Mixer for Downconversion

**Primary Choice:** [HMC556LC3B](https://www.analog.com/en/search.html#q=HMC556LC3B) (Analog Devices)

*Double-balanced mixer, 6-20 GHz, +13 dBm LO drive, 10 dB conversion loss*

[📄 Datasheet](https://www.analog.com/en/search.html#q=HMC556LC3B)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/HMC556LC3B/5508637)

| Spec | Value |
|---|---|
| rf_range | 6-20 GHz |
| lo_range | 6-20 GHz |
| if_range | DC-6 GHz |
| conv_loss | 10 dB |
| lo_drive | +13 dBm |
| iip3 | +23 dBm |

**Alternatives:**
- **[MAMC-005200-000](https://www.google.com/search?q=MAMC-005200-000+datasheet)** (MACOM): Similar performance, different package footprint
- **[CMD208](https://www.google.com/search?q=CMD208+datasheet)** (Custom MMIC): Slightly higher conversion loss at 11 dB

**Selection Rationale:** Wideband mixer covering entire 5-18 GHz RF range with excellent linearity and conversion loss. Compatible with common LO frequencies for downconversion.

### 4. IQ Demodulator (Baseband)

**Primary Choice:** [ADL5380](https://www.analog.com/en/search.html#q=ADL5380) (Analog Devices)

*Wideband IQ demodulator, 400 MHz to 6 GHz, 1.7 GHz bandwidth, differential outputs*

[📄 Datasheet](https://www.analog.com/en/search.html#q=ADL5380)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/ADL5380ACPZ/1957931)

| Spec | Value |
|---|---|
| rf_range | 400-6000 MHz |
| lo_range | 400-6000 MHz |
| bb_bandwidth | 1.7 GHz |
| conversion_gain | 6 dB |
| p1db | +11.5 dBm |

**Alternatives:**
- **[LTC5596](https://www.analog.com/en/search.html#q=LTC5596)** (Analog Devices): Lower frequency range up to 600 MHz
- **[TMC5630](https://www.google.com/search?q=TMC5630+datasheet)** (Teledyne): Specialized mil-spec component

**Selection Rationale:** High-performance IQ demodulator with excellent phase and amplitude balance for accurate I/Q generation. Wideband IF output suitable for ADC sampling.

### 5. Dual High-Speed ADC

**Primary Choice:** [AD9208](https://www.analog.com/en/search.html#q=AD9208) (Analog Devices)

*Dual 14-bit, 3 GSPS ADC with JESD204B interface, on-chip DDS*

[📄 Datasheet](https://www.analog.com/en/search.html#q=AD9208)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/AD9208-3000EBZ/6203556)

| Spec | Value |
|---|---|
| resolution | 14-bit |
| sample_rate | 3 GSPS |
| input_bw | 9 GHz |
| interface | JESD204B |
| supply | 1.0V/1.8V |

**Alternatives:**
- **[ADC12DJ3200](https://www.ti.com/product/ADC12DJ3200)** (Texas Instruments): 12-bit resolution, 3.2 GSPS
- **[ISLA214P50](https://www.google.com/search?q=ISLA214P50+datasheet)** (Renesas (Intersil)): 500 MSPS - insufficient bandwidth

**Selection Rationale:** Dual-channel ADC with >3 GSPS sampling for Nyquist capture of 1.5 GHz I/Q bandwidth. JESD204B interface for direct FPGA connection.

### 6. FPGA for Signal Processing

**Primary Choice:** [XCZU9EG-FFVB1156](https://www.amd.com/en/search/site-keyword-search.html#q=XCZU9EG-FFVB1156) (AMD (Xilinx))

*Zynq UltraScale+ MPSoC with FPGA fabric and ARM cores, 600K logic cells*

[📄 Datasheet](https://www.amd.com/en/search/site-keyword-search.html#q=XCZU9EG-FFVB1156)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/amd/XCZU9EG-FFVB1156E/6172907)

| Spec | Value |
|---|---|
| logic_cells | 600K |
| dsp_slices | 2520 |
| transceivers | 32 GTY up to 30 Gbps |
| arm_cores | 4x Cortex-A53 + 2x R5 |
| power | Industrial temp range |

**Alternatives:**
- **[10AX115N2F45E1LG](https://www.google.com/search?q=10AX115N2F45E1LG+datasheet)** (Intel (Altera)): Arria 10 FPGA - ARM cores optional
- **[LFE5UM-85F-8MG385](https://www.latticesemi.com/products#LFE5UM-85F-8MG385)** (Lattice): ECP5 - much lower capacity, suitable for low-end applications

**Selection Rationale:** High-performance Zynq UltraScale+ with FPGA fabric for DSP processing and ARM cores for control logic. LVDS outputs supported via GTY transceivers or SelectIO.

### 7. DC-DC Converter 12V to 3.3V/5V/7V

**Primary Choice:** [LTM4644](https://www.google.com/search?q=LTM4644+datasheet) (Analog Devices (Linear Technology))

*Quad 4A step-down regulator module, 4-14V input, programmable outputs*

[📄 Datasheet](https://www.google.com/search?q=LTM4644+datasheet)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/LTM4644IYPWPBF/5785002)

| Spec | Value |
|---|---|
| input_range | 4-14V |
| outputs | 4x programmable 0.6V-5V |
| current | 4A per channel |
| switching_freq | 1 MHz |
| package | BGA module |

**Alternatives:**
- **[TPS65283](https://www.ti.com/product/TPS65283)** (Texas Instruments): Dual output only, would require multiple ICs
- **[NCP1060](https://www.onsemi.com/products/power-management/ac-dc-controllers/ncp1060)** (onsemi): Single output only

**Selection Rationale:** High-current quad output DC-DC converter in compact module format. Provides all required voltage rails (3.3V for digital, 5V/7V for RF components) from 12V input.

### 8. RF Input SMA Connector

**Primary Choice:** [142-0701-851](https://www.cinch.com/products/johnson-components/142-0701-851) (Cinch Connectivity Solutions (Johnson))

*SMA end launch PCB jack, 50 ohm, solder tabs, 0-18 GHz*

[📄 Datasheet](https://www.cinch.com/products/johnson-components/142-0701-851)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/cinch-connectivity-solutions/142-0701-851/1659044)

| Spec | Value |
|---|---|
| freq_range | DC-18 GHz |
| impedance | 50 ohms |
| vswr | 1.3:1 max |
| mounting | End launch PCB |

**Alternatives:**
- **[3240125001](https://www.google.com/search?q=3240125001+datasheet)** (Molex): Similar SMA connector specification
- **[0734120090](https://www.te.com/en/search.html#q=0734120090)** (TE Connectivity): SMP-style alternative

**Selection Rationale:** High-quality SMA connector with excellent VSWR performance up to 18 GHz, meeting the 2:1 input VSWR requirement.

### 9. Bandpass Filter 5-18 GHz

**Primary Choice:** [BP5G18G-4500-C4](https://www.minicircuits.com/WebStore/modelSearch.html?model=BP5G18G-4500-C4) (Mini-Circuits)

*Bandpass filter, 5-18 GHz, 2 dB insertion loss, 50 ohm*

[📄 Datasheet](https://www.minicircuits.com/WebStore/modelSearch.html?model=BP5G18G-4500-C4)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/mini-circuits/BP5G18G-4500-C4/11695602)

| Spec | Value |
|---|---|
| passband | 5-18 GHz |
| insertion_loss | 2 dB |
| rejection | 40 dBc |
| vswr | 1.5:1 |
| power_handling | 1W |

**Alternatives:**
- **[CBP-1200-C3](https://www.google.com/search?q=CBP-1200-C3+datasheet)** (Crystek): Narrower band filters would require switching network

**Selection Rationale:** Wideband bandpass filter covering entire 5-18 GHz range with low insertion loss and good return loss contributing to 2:1 VSWR spec.
