# Component Recommendations
## kjk

### 1. Wideband LNA (5-18 GHz)

**Primary Choice:** [HMC698LP4](https://www.analog.com/en/search.html#q=HMC698LP4) (Analog Devices)

*GaAs MMIC Wideband Low Noise Amplifier covering DC to 20 GHz. Provides 20 dB gain with 2.5 dB noise figure.*

[📄 Datasheet](https://www.analog.com/en/search.html#q=HMC698LP4)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-infineon/HMC698LP4ETR/6136086)

| Spec | Value |
|---|---|
| frequency_range | DC to 20 GHz |
| gain | 20 dB |
| noise_figure | 2.5 dB |
| p1db | 19 dBm |
| supply_voltage | +5V |
| packaging | QFN 4x4 mm |

**Alternatives:**
- **[MAAL-011141](https://www.google.com/search?q=MAAL-011141+datasheet)** (MACOM): Lower NF (2.0 dB) but lower P1dB (15 dBm)
- **[TGA4538-SM](https://www.google.com/search?q=TGA4538-SM+datasheet)** (Qorvo): Higher gain (24 dB) but slightly higher NF (3.5 dB)

**Selection Rationale:** Selected for excellent NF (2.5 dB) to meet 6-10 dB system NF requirement and wide bandwidth coverage. 20 dB gain provides sufficient margin for downstream mixer conversion loss.

### 2. First Mixer (RF to First IF)

**Primary Choice:** [HMC1049LC4](https://www.analog.com/en/search.html#q=HMC1049LC4) (Analog Devices)

*Wideband Double-Balanced Mixer covering 5-20 GHz RF/LO with 0.1-6 GHz IF. High IP3 for linear operation.*

[📄 Datasheet](https://www.analog.com/en/search.html#q=HMC1049LC4)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-infineon/HMC1049LC4TR/6189535)

| Spec | Value |
|---|---|
| rf_range | 5-20 GHz |
| lo_range | 5-20 GHz |
| if_range | DC to 6 GHz |
| conversion_loss | 7 dB |
| lo_power | +15 dBm |
| ip3 | +25 dBm |
| packaging | QFN 24-lead 4x4 mm |

**Alternatives:**
- **[MAMX-011017-DIE](https://www.google.com/search?q=MAMX-011017-DIE+datasheet)** (MACOM): Lower conversion loss (6 dB) but requires LO driver
- **[MCA-01-12](https://www.google.com/search?q=MCA-01-12+datasheet)** (Marki Microwave): Superior IP3 (31 dBm) at higher cost

**Selection Rationale:** Selected for wide frequency coverage matching 5-18 GHz requirement with good linearity (IP3 +25 dBm) to support 80-100 dB dynamic range.

### 3. First LO Synthesizer (4-14 GHz)

**Primary Choice:** [ADF5356](https://www.analog.com/en/search.html#q=ADF5356) (Analog Devices)

*Wideband Synthesizer with Integrated VCO covering 53.125 MHz to 13.6 GHz (or 26.5 GHz with dividers). Ultra-low phase noise.*

[📄 Datasheet](https://www.analog.com/en/search.html#q=ADF5356)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices/ADF5356CCPZ/10861837)

| Spec | Value |
|---|---|
| frequency_range | 53.125 MHz to 13.6 GHz |
| phase_noise | -134 dBc/Hz at 1 MHz offset |
| switching_time | 25 us |
| rf_output_power | -5 to +5 dBm |
| supply_voltage | 3.15-3.45 V |

**Alternatives:**
- **[LMX2594](https://www.ti.com/product/LMX2594)** (Texas Instruments): Higher max freq (20 GHz) but slightly higher phase noise
- **[HMC704LP4](https://www.analog.com/en/search.html#q=HMC704LP4)** (Analog Devices): Lower phase noise at expense of more complex design

**Selection Rationale:** Selected for wide coverage and ultra-low phase noise (-134 dBc/Hz @1 MHz) meeting system phase noise requirements.

### 4. Variable Gain IF Amplifier

**Primary Choice:** [HMC698LP4](https://www.analog.com/en/search.html#q=HMC698LP4) (Analog Devices)

*Digital Variable Gain Amplifier covering DC to 6 GHz with 31 dB gain range in 1 dB steps.*

[📄 Datasheet](https://www.analog.com/en/search.html#q=HMC698LP4)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-infineon/HMC698LP4ETR/6136086)

| Spec | Value |
|---|---|
| frequency_range | DC to 6 GHz |
| gain_range | -6 to +25 dB |
| gain_step | 1 dB |
| noise_figure | 6 dB |
| oip3 | +33 dBm |
| settling_time | 5 ns |

**Alternatives:**
- **[ADA4371](https://www.analog.com/en/search.html#q=ADA4371)** (Analog Devices): Wider gain range (45 dB) but narrower bandwidth (2 GHz)
- **[TRF37A75](https://www.ti.com/product/TRF37A75)** (Texas Instruments): Lower cost with similar specs

**Selection Rationale:** Selected for wide gain range (31 dB) enabling AGC implementation across 80-100 dB dynamic range requirement.

### 5. High-Speed ADC (5 GSPS)

**Primary Choice:** [ADC12DJ5200RF](https://www.ti.com/product/ADC12DJ5200RF) (Texas Instruments)

*12-bit, 5.2 GSPS Dual-Channel RF Sampling ADC with integrated DDC功能.*

[📄 Datasheet](https://www.ti.com/product/ADC12DJ5200RF)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/texas-instruments/ADC12DJ5200RFAB/6136295)

| Spec | Value |
|---|---|
| resolution | 12-bit |
| max_sampling_rate | 5.2 GSPS |
| input_bandwidth | 9 GHz |
| snr | 58 dBFS |
| sfdr | 70 dBc |
| interface | JESD204B (12 lanes) |

**Alternatives:**
- **[AD9213](https://www.analog.com/en/search.html#q=AD9213)** (Analog Devices): Higher resolution (14-bit) at lower speed (10 GSPS interleaved)
- **[ATKA1108](https://www.google.com/search?q=ATKA1108+datasheet)** (Teledyne e2v): Higher speed but more complex interface

**Selection Rationale:** Selected for 5 GSPS sampling rate meeting Nyquist requirement for 1-5 GHz instantaneous bandwidth with 12-bit resolution supporting 80-100 dB dynamic range.

### 6. FPGA Signal Processor

**Primary Choice:** [XCZU49DR-FFVF1760](https://www.google.com/search?q=XCZU49DR-FFVF1760+datasheet) (AMD/Xilinx)

*Zynq UltraScale+ RFSoC with integrated ADC/DAC support, high-speed transceivers for Ethernet, and DSP slices for DDC processing.*

[📄 Datasheet](https://www.google.com/search?q=XCZU49DR-FFVF1760+datasheet)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/xilinx-inc/XCZU49DR-FFVF1760-I/6135718)

| Spec | Value |
|---|---|
| dsp_slices | 1968 |
| logic_cells | 902K |
| transceivers | 32x 32.75 Gbps |
| memory | 12 Mb BRAM |
| processing_system | Quad-core ARM Cortex-A53 |

**Alternatives:**
- **[10AX115N3F45I1SG](https://www.google.com/search?q=10AX115N3F45I1SG+datasheet)** (Intel/Altera): Similar performance with different toolchain

**Selection Rationale:** Selected for integrated RF capabilities, high-speed transceivers for GigE, and DSP capacity for DDC and packetization.

### 7. Gigabit Ethernet PHY

**Primary Choice:** [VSC8514](https://www.microchip.com/search/searchresults/VSC8514) (Microchip)

*Quad-port Gigabit Ethernet PHY with RGMII/SGMII interfaces, industrial temperature qualified.*

[📄 Datasheet](https://www.microchip.com/search/searchresults/VSC8514)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/microchip-technology/VSC8514-IJK/4667770)

| Spec | Value |
|---|---|
| ports | 4x 1000BASE-T |
| interfaces | RGMII, SGMII, QSGMII |
| temperature | -40 to +85°C |
| power | 650 mW per port |
| emc | IEEE 802.3 compliant |

**Alternatives:**
- **[KSZ9031RNXCC](https://www.microchip.com/search/searchresults/KSZ9031RNXCC)** (Microchip): Single-port, lower cost
- **[88E1512](https://www.google.com/search?q=88E1512+datasheet)** (Marvell): Higher port count but more complex

**Selection Rationale:** Selected for industrial temperature range support and compliance with GigE requirements for data interface.

### 8. Wideband Bandpass Filters (5-18 GHz)

**Primary Choice:** [Custom Mini-Circuits Bank](https://www.minicircuits.com/WebStore/RFIC_Bandpass.html) (Mini-Circuits)

*Bank of switched bandpass filters covering 5-8 GHz, 8-12 GHz, and 12-18 GHz for preselection and image rejection.*

[📄 Datasheet](https://www.minicircuits.com/WebStore/RFIC_Bandpass.html)  [🛒 DigiKey](https://www.digikey.com/en/products/filter/rf-bandpass-passive/83)

| Spec | Value |
|---|---|
| band1 | 5-8 GHz |
| band2 | 8-12 GHz |
| band3 | 12-18 GHz |
| insertion_loss | 2-3 dB |
| rejection | 40 dB (at band edges) |
| switch_type | PIN diode or MEMS |

**Alternatives:**
- **[BP5G8G+](https://www.minicircuits.com/WebStore/modelSearch.html?model=BP5G8G%2B)** (Mini-Circuits): Fixed band requiring external switching
- **[BP12G18G+](https://www.minicircuits.com/WebStore/modelSearch.html?model=BP12G18G%2B)** (Mini-Circuits): Single band filter

**Selection Rationale:** Required to meet 70-90 dB spurious rejection specification through proper band pre-selection.

### 9. EMI Filter Module (MIL-STD-461)

**Primary Choice:** [DLB1R5-1212](https://www.tdk-lambda.com/search/?q=DLB1R5-1212) (TDK-Lambda)

*DC Input EMI Filter Module designed for compliance with MIL-STD-461 conducted emission requirements.*

[📄 Datasheet](https://www.tdk-lambda.com/search/?q=DLB1R5-1212)  [🛒 DigiKey](https://www.digikey.com/en/products/filter/emi-rfi/79)

| Spec | Value |
|---|---|
| current | 15 A |
| voltage | 12-48 VDC |
| attenuation | 60 dB @150 kHz-30 MHz |
| temperature | -40 to +85°C |

**Alternatives:**
- **[FN406-12-06](https://www.schaffner.com/products/emc-filters/)** (Schaffner): Higher current rating
- **[RBI-401-12](https://www.google.com/search?q=RBI-401-12+datasheet)** (Corcom): Lower cost alternative

**Selection Rationale:** Selected to meet MIL-STD-461 CE102 conducted emissions requirement at power input.

### 10. DC-DC Converter (Custom Voltage)

**Primary Choice:** [VHA500F48T500N](https://www.vicorpower.com/search?q=VHA500F48T500N) (Vicor)

*High-density DC-DC converter module with isolated 48V input and configurable output for industrial/military applications.*

[📄 Datasheet](https://www.vicorpower.com/search?q=VHA500F48T500N)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/vicor-corporation/VHA500F48T500N/11677249)

| Spec | Value |
|---|---|
| input_voltage | 36-75 VDC |
| output_power | 500 W |
| efficiency | 96% |
| isolation | 2250 VDC |
| temperature | -40 to +100°C |

**Alternatives:**
- **[NME2405SC](https://www.google.com/search?q=NME2405SC+datasheet)** (Murata Power Solutions): Lower power density but simpler design
- **[UWE-S24/8-D12](https://www.tdk-lambda.com/search/?q=UWE-S24%2F8-D12)** (TDK-Lambda): Medical-grade with enhanced isolation

**Selection Rationale:** Selected for high efficiency and industrial temperature range supporting MIL-STD-461 EMI requirements with proper filtering.
