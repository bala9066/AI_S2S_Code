# Component Recommendations
## mnb

### 1. Wideband Low Noise Amplifier 5-18 GHz front-end

**Primary Choice:** [HMC698LP4(E)](https://www.analog.com/en/search.html#q=HMC698LP4%28E%29) (Analog Devices)

*GaAs MMIC PHEMT amplifier, 5-20 GHz, 15.5 dB gain, 3 dB noise figure, +30 dBm OIP3, 3.3V operation*

[📄 Datasheet](https://www.analog.com/en/search.html#q=HMC698LP4%28E%29)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/hmc698lp4e/1124519)

| Spec | Value |
|---|---|
| Frequency Range | 5-20 GHz |
| Gain | 15.5 dB |
| Noise Figure | 3 dB |
| OIP3 | +30 dBm |
| Supply Voltage | 3.3V |
| Package | 4x4 mm QFN |

**Alternatives:**
- **[GVA-123+](https://www.minicircuits.com/WebStore/modelSearch.html?model=GVA-123%2B)** (Mini-Circuits): Lower cost, slightly higher NF (4.5 dB)

**Selection Rationale:** Excellent NF and linearity across 5-18 GHz band, RoHS compliant, industrial temperature range. Low power consumption.

### 2. Wideband Double Balanced Mixer for frequency conversion

**Primary Choice:** [HMC1061LP4(E)](https://www.analog.com/en/search.html#q=HMC1061LP4%28E%29) (Analog Devices)

*GaAs MMIC mixer, 6-26 GHz RF/LO, DC-8 GHz IF, +10 dBm LO drive, 7.5 dB conversion loss*

[📄 Datasheet](https://www.analog.com/en/search.html#q=HMC1061LP4%28E%29)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/hmc1061lp4e/1124492)

| Spec | Value |
|---|---|
| RF Range | 6-26 GHz |
| LO Range | 6-26 GHz |
| IF Range | DC-8 GHz |
| Conversion Loss | 7.5 dB |
| LO Drive | +10 dBm |
| Package | 4x4 mm QFN |

**Alternatives:**
- **[LRM0600MDN](https://www.google.com/search?q=LRM0600MDN+datasheet)** (L3 Narda-MITEQ): Higher frequency option for 18-40 GHz applications

**Selection Rationale:** Covers entire 5-18 GHz range with low conversion loss and excellent isolation. Integrated balun simplifies design.

### 3. Wideband PLL Frequency Synthesizer for LO generation

**Primary Choice:** [ADF5355](https://www.analog.com/en/search.html#q=ADF5355) (Analog Devices)

*Microwave wideband synthesizer with integrated VCO, 13.6 GHz max output, frequency division to 53 MHz, -127 dBc/Hz phase noise at 10 kHz offset*

[📄 Datasheet](https://www.analog.com/en/search.html#q=ADF5355)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/ADF5355BCPZ/6123619)

| Spec | Value |
|---|---|
| Frequency Range | 53 MHz - 13.6 GHz |
| Phase Noise | -127 dBc/Hz @ 10 kHz |
| Tuning Resolution | <0.1 Hz |
| Supply Voltage | 3.15-3.45V |
| Package | 32-lead LFCSP |

**Alternatives:**
- **[LMX2595](https://www.ti.com/product/LMX2595)** (Texas Instruments): Higher output (20 GHz), slightly higher phase noise, similar cost

**Selection Rationale:** Industry-standard wideband synthesizer with excellent phase noise, meets -100 dBc/Hz requirement. Low power consumption.

### 4. Variable Gain Amplifier for AGC/IF gain control

**Primary Choice:** [HMC698LP4](https://www.analog.com/en/search.html#q=HMC698LP4) (Analog Devices)

*Digital variable gain amplifier, 6-18 GHz, 30 dB gain range, digital step control in 1 dB increments*

[📄 Datasheet](https://www.analog.com/en/search.html#q=HMC698LP4)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/hmc698lp4e/1124519)

| Spec | Value |
|---|---|
| Frequency Range | 6-18 GHz |
| Gain Range | 30 dB |
| Step Size | 1 dB |
| Noise Figure | 7 dB |
| Package | QFN-24 |

**Alternatives:**
- **[HMC1119](https://www.analog.com/en/search.html#q=HMC1119)** (Analog Devices): Higher gain range (45 dB) but narrower bandwidth

**Selection Rationale:** Provides 30 dB adjustable gain with 1 dB resolution, compatible with AGC loops. Wideband coverage.

### 5. High-Speed ADC for IF digitization

**Primary Choice:** [ADC12DJ3200](https://www.ti.com/product/ADC12DJ3200) (Texas Instruments)

*Dual-channel 12-bit ADC, up to 6.4 GSPS (3.2 GSPS dual), 3.2 GHz input bandwidth, 59.6 dB SNR, -67 dBFS HD2*

[📄 Datasheet](https://www.ti.com/product/ADC12DJ3200)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/texas-instruments/ADC12DJ3200ABAB/6007711)

| Spec | Value |
|---|---|
| Resolution | 12-bit |
| Max Sample Rate | 6.4 GSPS |
| Input Bandwidth | 3.2 GHz |
| SNR | 59.6 dB |
| SFDR | 70 dBFS |
| Power | 2.1W |

**Alternatives:**
- **[AD9208](https://www.analog.com/en/search.html#q=AD9208)** (Analog Devices): Higher SNR (63 dB) but lower max sample rate (3 GSPS)

**Selection Rationale:** Exceeds 2 GSPS requirement with 12-bit resolution and 70 dB SFDR matching dynamic range spec. Dual-mode enables I/Q processing.

### 6. FPGA for digital signal processing and data forwarding

**Primary Choice:** [XCZU4EG-SFVC784](https://www.google.com/search?q=XCZU4EG-SFVC784+datasheet) (AMD/Xilinx)

*Zynq UltraScale+ MPSoC, 50K logic cells, 2 quad-core ARM Cortex-A53, 16-bit 12.5 Gbps transceivers, DSP slices for FIR/FFT*

[📄 Datasheet](https://www.google.com/search?q=XCZU4EG-SFVC784+datasheet)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/amd/xczu4eg-sfvc784-1-i/6240524)

| Spec | Value |
|---|---|
| Logic Cells | 50K |
| ARM Cores | 4x Cortex-A53 @ 1.3GHz |
| Transceivers | 16x 12.5 Gbps GTY |
| DSP Slices | 192 |
| Power | Typ 15W |
| Package | SFVC784 |

**Alternatives:**
- **[10CX220YF484I8G](https://www.google.com/search?q=10CX220YF484I8G+datasheet)** (Intel/Altera): Cyclone 10 GX - lower cost, no ARM cores

**Selection Rationale:** Sufficient DSP resources for DDC, filtering, and GigE packetization. Integrated ARM enables embedded control. High-speed transceivers for ADC interface.

### 7. Gigabit Ethernet PHY for data output interface

**Primary Choice:** [88E1512-A0-BKK2C000](https://www.google.com/search?q=88E1512-A0-BKK2C000+datasheet) (Marvell)

*Alaska Ultra Gigabit Ethernet PHY, 10/100/1000BASE-T, RGMII/SGMII interface, 0.9W power, industrial temp*

[📄 Datasheet](https://www.google.com/search?q=88E1512-A0-BKK2C000+datasheet)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/marvell-semiconductor/88E1512-A0-BKK2C000/5275364)

| Spec | Value |
|---|---|
| Data Rate | 10/100/1000 Mbps |
| Interface | RGMII/SGMII |
| Power | 0.9W |
| Temperature | -40 to +85°C |
| Package | QFN-64 |

**Alternatives:**
- **[VSC8541](https://www.google.com/search?q=VSC8541+datasheet)** (Microchip/Vitesse): Similar specs, lower power consumption

**Selection Rationale:** Industry-standard GigE PHY with proven reliability. RGMII interface compatible with FPGA. Industrial temperature rating.

### 8. Main 5V power input and distribution

**Primary Choice:** [LTM8058](https://www.analog.com/en/search.html#q=LTM8058) (Analog Devices)

*36VIN 2.5A step-down Silent Switcher module, 3.3V output, 2.1MHz switching, 91% efficiency, -40 to +125°C*

[📄 Datasheet](https://www.analog.com/en/search.html#q=LTM8058)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/LTM8058EV-3-3-PBF/5976572)

| Spec | Value |
|---|---|
| Input Voltage | 3.4V to 36V |
| Output | 3.3V @ 2.5A |
| Efficiency | 91% |
| Switching Frequency | 2.1 MHz |
| Package | 15x9x4.92 mm BGA |

**Alternatives:**
- **[MGJ2D121505SC](https://www.google.com/search?q=MGJ2D121505SC+datasheet)** (Murata Power Solutions): Isolated DC-DC converter option

**Selection Rationale:** High efficiency DC-DC module simplifies layout. Wide input range supports 12V input with headroom. Silent Switcher reduces EMI.

### 9. 3.3V LDO regulator for analog circuits

**Primary Choice:** [LT3045](https://www.analog.com/en/search.html#q=LT3045) (Analog Devices)

*Ultra-low noise linear regulator, 500mA output, 0.8uV RMS noise, 80dB PSRR, 20V max input*

[📄 Datasheet](https://www.analog.com/en/search.html#q=LT3045)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/LT3045EDD-PBF/5746178)

| Spec | Value |
|---|---|
| Output Current | 500 mA |
| Output Voltage | 3.3V |
| Noise | 0.8 uV RMS |
| PSRR | 80 dB |
| Dropout | 200mV |

**Alternatives:**
- **[TPS7A4700](https://www.ti.com/product/TPS7A4700)** (Texas Instruments): Similar performance, SOT-223 package

**Selection Rationale:** Ultra-low noise prevents degradation of receiver noise figure. High PSRR rejects switching regulator ripple.

### 10. 2.5V and 1.8V DDR3/FPGA rail generation

**Primary Choice:** [LTC3372](https://www.analog.com/en/search.html#q=LTC3372) (Analog Devices)

*Quad output low noise buck regulator, 4 independent channels, 2A total output, 2MHz switching*

[📄 Datasheet](https://www.analog.com/en/search.html#q=LTC3372)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/LTC3372IUJ-PBF/6031576)

| Spec | Value |
|---|---|
| Input Range | 2.7V to 18V |
| Outputs | 4 configurable |
| Total Output | 2A |
| Switching Freq | 2 MHz |
| Package | 4x4 mm LQFN-32 |

**Alternatives:**
- **[TPS650860](https://www.ti.com/product/TPS650860)** (Texas Instruments): PMIC with integrated LDOs

**Selection Rationale:** Efficient multi-rail generation for FPGA core and DDR3 supplies in single IC. Reduces component count.

### 11. RF Input SMA Connector

**Primary Choice:** [142-0771-821](https://www.cinch.com/products/connectors/rf-coaxial-connectors/sma/142-0771-821) (Cinch Connectivity Solutions)

*SMA jack, 50 ohm, solder mount, brass body, gold plating, frequency range DC-18 GHz*

[📄 Datasheet](https://www.cinch.com/products/connectors/rf-coaxial-connectors/sma/142-0771-821)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/cinch-connectivity-solutions/142-0771-821/4239068)

| Spec | Value |
|---|---|
| Impedance | 50 ohms |
| Frequency Range | DC-18 GHz |
| VSWR | <1.5:1 typical |
| Mounting | Solder PCB |
| Plating | Gold |

**Alternatives:**
- **[J502-ND](https://www.te.com/en/search.html#q=J502-ND)** (TE Connectivity): Equivalent performance, different manufacturer

**Selection Rationale:** Industry-standard SMA connector with excellent performance through 18 GHz. Reliable PCB termination.

### 12. Gigabit Ethernet RJ45 with integrated magnetics

**Primary Choice:** [0884-1G1C1F02](https://www.google.com/search?q=0884-1G1C1F02+datasheet) (Pulse Electronics)

*RJ45 connector with integrated 10/100/1000BASE-T magnetics, tab-up, ESD protection, LED indicators*

[📄 Datasheet](https://www.google.com/search?q=0884-1G1C1F02+datasheet)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/pulse-electronics/0884-1G1C1F02/10621613)

| Spec | Value |
|---|---|
| Data Rate | 1000BASE-T |
| Magnetics | Integrated 1:1 ratio |
| ESD Protection | ±15kV air/±8kV contact |
| Package | Through-hole 1x1 |
| Temperature | -40 to +85°C |

**Alternatives:**
- **[PMAG-2X2G-T](https://www.google.com/search?q=PMAG-2X2G-T+datasheet)** (Bel Fuse): Equivalent integrated mag-jack

**Selection Rationale:** Integrated magnetics reduces board space and BOM. Industrial temperature rating meets requirements.

### 13. DDR3 Memory for FPGA buffering

**Primary Choice:** [MT41J512M8RH-125](https://www.micron.com/products/dram/ddr3-sdram/part-catalog/mt41j512m8rh) (Micron Technology)

*DDR3 SDRAM 512Mb x8 (4Gb), 1600 Mbps, 1.5V, industrial temperature, FBGA 96-ball*

[📄 Datasheet](https://www.micron.com/products/dram/ddr3-sdram/part-catalog/mt41j512m8rh)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/micron-technology-inc/MT41J512M8RH-125-IT/4885179)

| Spec | Value |
|---|---|
| Density | 4 Gbit |
| Configuration | 512M x8 |
| Speed | DDR3-1600 (PC3-12800) |
| Voltage | 1.5V |
| Package | 96-ball FBGA |

**Alternatives:**
- **[AS4C512M8D4A-12BAN](https://www.google.com/search?q=AS4C512M8D4A-12BAN+datasheet)** (Alliance Memory): Lower cost, second-source option

**Selection Rationale:** Industrial temperature DDR3 compatible with Zynq UltraScale+ memory controller. Sufficient capacity for data buffering.

### 14. FPGA Configuration Flash

**Primary Choice:** [S25FL256SDPBHI010](https://www.google.com/search?q=S25FL256SDPBHI010+datasheet) (Infineon/Cypress)

*256 Mbit (32 MB) NOR Flash, Quad SPI, 108 MHz, 3.0V, industrial temperature, SOIC-8*

[📄 Datasheet](https://www.google.com/search?q=S25FL256SDPBHI010+datasheet)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/infineon-technologies/S25FL256SDPBHI010/5980003)

| Spec | Value |
|---|---|
| Density | 256 Mbit |
| Interface | Quad SPI (4-bit) |
| Speed | 108 MHz |
| Voltage | 2.7V to 3.6V |
| Package | SOIC-8 |

**Alternatives:**
- **[MT25QU256ABA](https://www.google.com/search?q=MT25QU256ABA+datasheet)** (Micron): Equivalent performance, alternative vendor

**Selection Rationale:** Industry-standard Quad SPI flash with reliable Xilinx FPGA configuration support. Industrial temperature rated.
