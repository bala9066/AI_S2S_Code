# Component Recommendations
## receiver

### 1. Wideband LNA / Variable Gain Amplifier

**Primary Choice:** [HMC698LP4](https://www.analog.com/en/search.html#q=HMC698LP4) (Analog Devices)

*GaAs MMIC PHEMT Wideband Variable Gain Amplifier/Driver, 2-20 GHz, 16 dB gain range, programmable attenuation*

[📄 Datasheet](https://www.analog.com/en/search.html#q=HMC698LP4)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/HMC698LP4ETR/5843025)

| Spec | Value |
|---|---|
| frequency | 2-20 GHz |
| gain | 16 dB range |
| noise_figure | 5 dB |
| p1db | +23 dBm |
| control | SPI digital control |
| package | 4x4 mm QFN |

**Alternatives:**
- **[MAAM-011101](https://www.google.com/search?q=MAAM-011101+datasheet)** (Macom): Fixed gain, lower noise figure (3.5 dB), no digital gain control
- **[TGA4516-SM](https://www.google.com/search?q=TGA4516-SM+datasheet)** (Qorvo): Higher gain (22 dB), requires external gain control circuitry

**Selection Rationale:** Selected HMC698LP4 for integrated digital gain control covering 5-18 GHz with suitable NF and P1dB for input power range.

### 2. Mixer - Wideband I/Q Downconverter

**Primary Choice:** [HMC1048LP4E](https://www.analog.com/en/search.html#q=HMC1048LP4E) (Analog Devices)

*Wideband I/Q Demodulator, 6-18 GHz, direct conversion to I/Q baseband*

[📄 Datasheet](https://www.analog.com/en/search.html#q=HMC1048LP4E)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/HMC1048LP4E/5974748)

| Spec | Value |
|---|---|
| frequency | 6-18 GHz |
| conversion_gain | 6 dB |
| noise_figure | 13 dB |
| iip3 | +24 dBm |
| lo_power | 0 to +5 dBm |
| package | 24-lead 4x4 mm LFCSP |

**Alternatives:**
- **[MIX-0918](https://www.google.com/search?q=MIX-0918+datasheet)** (Marki Microwave): Double-balanced mixer, external LO required for I/Q generation
- **[ADL5380](https://www.analog.com/en/search.html#q=ADL5380)** (Analog Devices): Lower frequency range (700 MHz to 2.7 GHz), not suitable for 5-18 GHz

**Selection Rationale:** HMC1048LP4E provides direct I/Q demodulation across 6-18 GHz, eliminating need for external 90-degree hybrid. IP3 meets 20-30 dBm spec.

### 3. Local Oscillator Synthesizer

**Primary Choice:** [ADF5355](https://www.analog.com/en/search.html#q=ADF5355) (Analog Devices)

*Wideband Synthesizer with Integrated VCO, 13.6 GHz output, divide to 5-18 GHz coverage*

[📄 Datasheet](https://www.analog.com/en/search.html#q=ADF5355)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/ADF5355CCPZ/6109222)

| Spec | Value |
|---|---|
| frequency | 53.125 MHz to 13.6 GHz |
| phase_noise | -125 dBc/Hz at 1 MHz offset |
| spurious | -80 dBc |
| frequency_resolution | 0.001 Hz |
| package | 32-lead LFCSP |

**Alternatives:**
- **[LMX2594](https://www.ti.com/product/LMX2594)** (Texas Instruments): Up to 15 GHz output, similar performance
- **[HMC704](https://www.analog.com/en/search.html#q=HMC704)** (Analog Devices): Integer-N synthesizer, requires external VCO for 5-18 GHz

**Selection Rationale:** ADF5355 provides integrated PLL/VCO solution covering required LO range with excellent phase noise for 5-18 GHz receiver.

### 4. ADC - Dual I/Q Digitizer

**Primary Choice:** [ADC12DJ3200](https://www.ti.com/product/ADC12DJ3200) (Texas Instruments)

*12-bit, 3.2 GSPS Dual ADC, supports I/Q sampling up to 6.4 GSPS*

[📄 Datasheet](https://www.ti.com/product/ADC12DJ3200)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/texas-instruments/ADC12DJ3200EVM/5900541)

| Spec | Value |
|---|---|
| resolution | 12-bit |
| sample_rate | 3.2 GSPS per channel |
| snr | 57 dBFS |
| sfdr | 65 dBc |
| input_bandwidth | 6.5 GHz |
| package | 12x12 mm BGA |

**Alternatives:**
- **[AD9208](https://www.analog.com/en/search.html#q=AD9208)** (Analog Devices): 14-bit, 1 GSPS, better SNR but lower sample rate
- **[ISLA214P50](https://www.google.com/search?q=ISLA214P50+datasheet)** (Renesas (Intersil)): 14-bit, 500 MSPS, not adequate for 5-18 GHz direct sampling

**Selection Rationale:** ADC12DJ3200 provides sufficient bandwidth and sample rate for IF digitization or direct RF sampling of downconverted I/Q signals.

### 5. FPGA - Digital Signal Processing

**Primary Choice:** [XCZU3EG-SFVA784](https://www.amd.com/en/search/site-keyword-search.html#q=XCZU3EG-SFVA784) (AMD (Xilinx))

*Zynq UltraScale+ MPSoC with integrated ARM cores and programmable logic for signal processing*

[📄 Datasheet](https://www.amd.com/en/search/site-keyword-search.html#q=XCZU3EG-SFVA784)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/amd/XCZU3EG-SFVA784/6139328)

| Spec | Value |
|---|---|
| logic_cells | 50K |
| dsp_slices | 192 |
| memory | 8 MB BRAM |
| transceivers | Up to 12.32 Gbps |
| package | 784-ball FCGA |
| industrial_temp | -40°C to +100°C |

**Alternatives:**
- **[10M50DAF484I7G](https://www.google.com/search?q=10M50DAF484I7G+datasheet)** (Intel (Altera)): Max 10 FPGA, no ARM cores, lower DSP performance
- **[LFE5UM-85F-8MG381](https://www.latticesemi.com/products#LFE5UM-85F-8MG381)** (Lattice): ECP5 FPGA, smaller device, may be insufficient for signal processing

**Selection Rationale:** Zynq UltraScale+ provides ARM cores for control and programmable logic for high-speed I/Q data processing and interface.

### 6. RF Input Connector

**Primary Choice:** [149-0901-801](https://www.cinchsolutions.com/products/detail/2-4mm-rf-connectors/149-0901-801) (Cinch Connectivity Solutions (Johanson Technology))

*2.4mm Female PCB Connector, 50 ohm, DC to 40 GHz*

[📄 Datasheet](https://www.cinchsolutions.com/products/detail/2-4mm-rf-connectors/149-0901-801)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/cinch-connectivity-solutions/149-0901-801/1735705)

| Spec | Value |
|---|---|
| frequency | DC to 40 GHz |
| impedance | 50 ohm |
| vswr | 1.3:1 max |
| mounting | PCB edge launch |
| interface | 2.4mm female |

**Alternatives:**
- **[132364-50](https://www.google.com/search?q=132364-50+datasheet)** (HUBER+SUHNER): 2.92mm (K) connector, slightly lower frequency rating
- **[SMP-134-76-L-17](https://www.google.com/search?q=SMP-134-76-L-17+datasheet)** (Crane Aerospace): SMP connector, not suitable for 18 GHz+

**Selection Rationale:** 2.4mm connector provides optimal performance up to 40 GHz with margin for 5-18 GHz requirement.

### 7. DC-DC Converter - +12V Rail

**Primary Choice:** [LTM4644](https://www.google.com/search?q=LTM4644+datasheet) (Analog Devices (Linear Technology))

*Quad 4A DC-DC Regulator Module, 4-14V input, programmable outputs*

[📄 Datasheet](https://www.google.com/search?q=LTM4644+datasheet)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/LTM4644IY-PBF/5989292)

| Spec | Value |
|---|---|
| input | 4-14V |
| output_current | 4A per channel |
| output_voltage | 0.6V to 5.5V |
| efficiency | 90% |
| package | 16mm LGA module |

**Alternatives:**
- **[TPS65283](https://www.ti.com/product/TPS65283)** (Texas Instruments): Dual output converter, lower current
- **[RQH03120D50](https://www.google.com/search?q=RQH03120D50+datasheet)** (Murata Power Solutions): Single output, 12V to 5V module

**Selection Rationale:** LTM4644 provides compact quad-rail power conversion from intermediate bus voltage to required +12V, +5V, +3.3V rails.

### 8. Negative Rail Generator - -5V

**Primary Choice:** [LT1054](https://www.google.com/search?q=LT1054+datasheet) (Analog Devices (Linear Technology))

*Switched Capacitor Voltage Converter, generates negative supply*

[📄 Datasheet](https://www.google.com/search?q=LT1054+datasheet)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/LT1054CS8-PBF/1035691)

| Spec | Value |
|---|---|
| input | 3.5V to 15V |
| output | -1.25V to -15V |
| output_current | 100 mA |
| frequency | 25 kHz |
| package | 8-lead DIP or SO-8 |

**Alternatives:**
- **[ICL7660](https://www.google.com/search?q=ICL7660+datasheet)** (Maxim Integrated (Renesas)): Lower output current (20 mA)
- **[MAX1681](https://www.analog.com/en/search.html#q=MAX1681)** (Maxim Integrated): Higher frequency (125 kHz) for smaller capacitors

**Selection Rationale:** LT1054 provides simple -5V rail generation for mixer bias or negative supply requirements.
