# Component Recommendations
## Sample Ai Project

### 1. Wideband Low Noise Amplifier (5-18 GHz)

**Primary Choice:** [TGA4943-SL](https://www.qorvo.com/products/d/tga4943-sl) (Qorvo)

*GaAs MMIC LNA, 2-20 GHz, 22 dB gain, 3.5 dB noise figure, 20 dBm P1dB. Available in military temperature screening.*

[📄 Datasheet](https://www.qorvo.com/products/d/tga4943-sl)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/qorvo/TGA4943-SL/10182245)

| Spec | Value |
|---|---|
| frequency_range | 2-20 GHz |
| gain | 22 dB |
| noise_figure | 3.5 dB |
| p1db | 20 dBm |
| supply_voltage | 5V |
| current | 90 mA |
| operating_temp | -55°C to +125°C (screened) |

**Alternatives:**
- **[CMD263](https://www.custommmic.com/datasheets/CMD263.pdf)** (Custom MMIC): Similar NF, slightly lower gain (19 dB), same freq range
- **[AMMC-6241](https://www.google.com/search?q=AMMC-6241+datasheet)** (Analog Devices (Hittite)): 4 dB NF, 24 dB gain, 4-24 GHz range

**Selection Rationale:** Best-in-class noise figure at 3.5 dB, wideband coverage exceeds 5-18 GHz requirement, available in military temperature grade. 22 dB gain provides strong headroom for downstream losses.

### 2. Digital Variable Gain Amplifier / DSA (5-18 GHz)

**Primary Choice:** [HMC698LP4E](https://www.analog.com/en/search.html#q=HMC698LP4E) (Analog Devices)

*6-bit Digital Step Attenuator, 0.25 dB steps, 31.75 dB range, DC-18 GHz. Military temp available.*

[📄 Datasheet](https://www.analog.com/en/search.html#q=HMC698LP4E)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices/hmc698lp4e/3677200)

| Spec | Value |
|---|---|
| frequency_range | DC-18 GHz |
| attenuation_range | 0-31.75 dB |
| step_size | 0.25 dB |
| insertion_loss | 3.5 dB |
| power_handling | 27 dBm |
| control | Serial/Parallel |
| operating_temp | -55°C to +125°C |

**Alternatives:**
- **[PE4306](https://www.google.com/search?q=PE4306+datasheet)** (pSemi): 7-bit, 0.25 dB steps, 31.5 dB range, up to 6 GHz only
- **[HMCA0932](https://www.analog.com/en/search.html#q=HMCA0932)** (Analog Devices): Vector modulator approach, higher integration

**Selection Rationale:** 6-bit resolution provides 0.25 dB gain control steps meeting AGC requirements. 18 GHz upper limit covers entire band. Low insertion loss and high power handling suitable for LNA output.

### 3. 5-18 GHz Bandpass Filter

**Primary Choice:** [CBP-1850+](https://www.google.com/search?q=CBP-1850%2B+datasheet) (Mini-Circuits)

*Cavity bandpass filter, 5-18 GHz, 2.5 dB insertion loss, excellent rejection. Available in military grade.*

[📄 Datasheet](https://www.google.com/search?q=CBP-1850%2B+datasheet)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/mini-circuits/CBP-1850/3856380)

| Spec | Value |
|---|---|
| frequency_range | 5-18 GHz |
| insertion_loss | 2.5 dB |
| return_loss | >18 dB |
| passband_ripple | 0.5 dB |
| rejection | 40 dBc at stopband edges |
| operating_temp | -55°C to +125°C |

**Alternatives:**
- **[BP-1850+](https://www.google.com/search?q=BP-1850%2B+datasheet)** (Mini-Circuits): Similar specs, slightly larger form factor
- **[CRF-1850+](https://www.google.com/search?q=CRF-1850%2B+datasheet)** (Mini-Circuits): Cavity filter with sharper skirts

**Selection Rationale:** Low insertion loss preserves NF budget. Military temp option available. Good return loss (>18 dB) supports impedance matching. Mini-Circuits has military screening capability.

### 4. High-Speed ADC (5-10 GSPS)

**Primary Choice:** [ADC10D1000RF](https://www.ti.com/product/ADC10D1000RF) (Texas Instruments)

*Dual-channel 10-bit ADC, up to 10 GSPS, optimized for RF sampling. Military temperature grade available.*

[📄 Datasheet](https://www.ti.com/product/ADC10D1000RF)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/texas-instruments/ADC10D1000RF/5028604)

| Spec | Value |
|---|---|
| sampling_rate | 10 GSPS max |
| resolution | 10 bits |
| sfdr | 55 dBc at 3 GHz |
| snr | 52 dB |
| input_bandwidth | 9 GHz |
| power | 4.8 W |
| interface | DDR LVDS/JESD204B |
| operating_temp | -55°C to +125°C (screened) |

**Alternatives:**
- **[AT3216-10](https://www.google.com/search?q=AT3216-10+datasheet)** (Analog Devices (Teledyne e2v)): 10-bit, 10 GSPS, similar SFDR
- **[EV12AQ600](https://www.google.com/search?q=EV12AQ600+datasheet)** (Teledyne e2v): Quad-channel 12-bit at 6.4 GSPS, lower sample rate but better resolution

**Selection Rationale:** Meets 5-10 GSPS requirement at full 10 GSPS. 10-bit resolution provides 60 dB theoretical dynamic range. JESD204B interface ideal for FPGA connection. Direct RF sampling capability up to 9 GHz bandwidth enables simplified architecture.

### 5. Radiation-Tolerant FPGA

**Primary Choice:** [RTVirtex5QV](https://www.google.com/search?q=RTVirtex5QV+datasheet) (Xilinx (AMD))

*Virtex-5QV radiation-tolerant FPGA, high-speed transceivers, military/flight qualified. System Monitor for temp/power.*

[📄 Datasheet](https://www.google.com/search?q=RTVirtex5QV+datasheet)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/xilinx/XQR5VFX130-1CF1752/2797476)

| Spec | Value |
|---|---|
| logic_cells | 130,000 |
| dsp_slices | 320 |
| block_ram | 10 Mb |
| transceivers | Up to 13.1 Gbps GTX |
| radiation | SEL immune to >100 MeV |
| total_dose | >100 krad |
| power | 15-30 W |
| operating_temp | -55°C to +125°C |

**Alternatives:**
- **[RTKintex7QV](https://www.google.com/search?q=RTKintex7QV+datasheet)** (Xilinx (AMD)): Higher performance, more DSP, newer architecture
- **[RT PolarFire SoC](https://www.microchip.com/search/searchresults/RT%20PolarFire%20SoC)** (Microchip): Non-radiation-hardened, aerospace grade only

**Selection Rationale:** Radiation-hardened with SEL immunity, critical for military/aerospace. High-speed GTX transceivers support >10 Gbps data from ADC. Ample DSP blocks for real-time signal processing. Flight heritage provides reliability assurance.

### 6. Low-Jitter Clock Generator/Distribution

**Primary Choice:** [HMC7044](https://www.analog.com/en/search.html#q=HMC7044) (Analog Devices)

*Ultra-low jitter clock generator with dual PLLs, 14 outputs, programmable dividers. Military temp available.*

[📄 Datasheet](https://www.analog.com/en/search.html#q=HMC7044)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices/HMC7044/6209106)

| Spec | Value |
|---|---|
| output_frequencies | 1 kHz to 3.6 GHz |
| phase_noise | -134 dBc/Hz at 1 MHz offset |
| rms_jitter | 80 fs |
| num_outputs | 14 |
| output_format | LVDS/CMOS/LVPECL |
| power | 1.2 W |
| operating_temp | -55°C to +125°C |

**Alternatives:**
- **[LMK04828](https://www.ti.com/product/LMK04828)** (Texas Instruments): Similar jitter performance, more outputs
- **[Si5345](https://www.skyworksinc.com/products/si5345)** (Skyworks (Silicon Labs)): Lower jitter but limited to -40C to +85C

**Selection Rationale:** 80 fs RMS jitter meets <100 fs requirement for 10 GHz sampling. 14 outputs provide clock for ADC, FPGA, and supporting logic. Military temperature grade available. Dual PLL architecture enables flexible frequency planning.

### 7. Military-Grade DC-DC Converter (12V to 5V Rail)

**Primary Choice:** [VPT/DCDV1-28-5](https://www.vicorpower.com/search?q=VPT%2FDCDV1-28-5) (Vicor)

*Radiation-hardened DC-DC converter, 28V input to 5V output, 50W, military/flight qualified.*

[📄 Datasheet](https://www.vicorpower.com/search?q=VPT%2FDCDV1-28-5)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/vicor/DCDV1-28-5/9435242)

| Spec | Value |
|---|---|
| input_voltage | 16-40V DC nominal 28V |
| output_voltage | 5V |
| output_current | 10A (50W) |
| efficiency | 87% |
| radiation | SEL immune |
| total_dose | 50 krad |
| operating_temp | -55°C to +125°C |

**Alternatives:**
- **[MUR1S05](https://www.google.com/search?q=MUR1S05+datasheet)** (Murata Power Solutions): Similar specs, slightly lower power
- **[QMH24S1505](https://www.google.com/search?q=QMH24S1505+datasheet)** (Cosel): Non-radiation-hardened but ruggedized

**Selection Rationale:** Radiation-hardened with flight heritage. 50W capacity sufficient for 5V RF chain. Wide input voltage range accommodates 12-28V system bus. Military screening available.

### 8. Point-of-Load DC-DC Converter (FPGA Rails)

**Primary Choice:** [LTM4644](https://www.google.com/search?q=LTM4644+datasheet) (Analog Devices (Linear Technology))

*Quad-output DC-DC regulator module, 4A per channel, rail-to-rail output, high efficiency.*

[📄 Datasheet](https://www.google.com/search?q=LTM4644+datasheet)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices/LTM4644IY-PBF/5910605)

| Spec | Value |
|---|---|
| input_voltage | 2.375-20V |
| output_voltage | 0.6-5V (4 outputs) |
| output_current | 4A per channel |
| efficiency | 90% |
| switching_frequency | 2 MHz |
| operating_temp | -55°C to +125°C |

**Alternatives:**
- **[TPS65218](https://www.ti.com/product/TPS65218)** (Texas Instruments): Similar specs, fewer outputs
- **[MAX8588](https://www.google.com/search?q=MAX8588+datasheet)** (Maxim Integrated): Dual output only

**Selection Rationale:** Quad outputs can generate 3.3V, 1.8V, 1.2V, and auxiliary rail for FPGA from single input. High efficiency reduces power dissipation in compact form factor. Module solution simplifies layout.

### 9. RF Input Connector (SMA, 18 GHz)

**Primary Choice:** [142-0701-851](https://www.cinch.com/products/rf-connectors/sma/142-0701-851) (Cinch Connectivity Solutions)

*SMA jack, 50 ohm, 18 GHz, flange mount, gold-plated contacts, military-grade.*

[📄 Datasheet](https://www.cinch.com/products/rf-connectors/sma/142-0701-851)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/cinch-connectivity-solutions/142-0701-851/1311404)

| Spec | Value |
|---|---|
| frequency_range | DC to 18 GHz |
| impedance | 50 ohms |
| vswr | 1.3:1 max at 18 GHz |
| contact_material | Gold-plated beryllium copper |
| body_material | Stainless steel |
| operating_temp | -65°C to +165°C |

**Alternatives:**
- **[112647](https://www.te.com/en/search.html#q=112647)** (TE Connectivity): Similar specs, edge launch instead of flange
- **[SMP-0441-SS](https://www.google.com/search?q=SMP-0441-SS+datasheet)** (Pasternack): Higher frequency (26.5 GHz) but more expensive

**Selection Rationale:** 18 GHz upper limit covers entire band. Military-grade construction with extended temp range. VSWR of 1.3:1 translates to 17.7 dB return loss meeting >15 dB requirement. Flange mount provides secure PCB attachment.

### 10. FPGA Configuration Memory (Military)

**Primary Choice:** [S29GL01GS](https://www.google.com/search?q=S29GL01GS+datasheet) (Infineon (Cypress))

*128 Mb NOR Flash, SPI interface, military temperature, qualified for aerospace.*

[📄 Datasheet](https://www.google.com/search?q=S29GL01GS+datasheet)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/infineon-technologies/S29GL01GS10TFIR10/6133499)

| Spec | Value |
|---|---|
| density | 128 Mb (16 MB) |
| interface | SPI |
| endurance | 100,000 cycles |
| data_retention | 20 years at 125°C |
| speed | 108 MHz max |
| operating_temp | -55°C to +125°C |

**Alternatives:**
- **[MT28EW128ABA](https://www.google.com/search?q=MT28EW128ABA+datasheet)** (Micron): Similar specs, different interface
- **[MLC153068](https://www.microchip.com/search/searchresults/MLC153068)** (Microchip): Lower density, very high reliability

**Selection Rationale:** Military temperature rating supports entire operating range. 128 Mb capacity sufficient for large FPGA bitstreams. SPI interface simplifies PCB routing. Long data retention suitable for aerospace applications.
