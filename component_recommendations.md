# Component Recommendations
## rffff

### 1. FPGA - Signal Processing and Control

**Primary Choice:** XC7A100T-2FGG484I (Xilinx/AMD)

*Artix-7 FPGA, 100K logic cells, industrial temp grade, FGG484 package. Provides DSP slices and transceivers for high-speed DAC interface.*

| Spec | Value |
|---|---|
| Logic Cells | 101,400 |
| DSP Slices | 240 |
| Transceivers | 4 GTP up to 6.6Gbps |
| VCCINT | 1.0V |
| Temp Range | -40 to +100°C (I-grade) |
| Package | FGG484 (23mm x 23mm) |

**Alternatives:**
- **XC7A50T-2FGG484I** (Xilinx): Lower cost, 50K logic cells, fewer DSP slices (120), may be sufficient depending on signal processing requirements
- **XC7A200T-2SBG484I** (Xilinx): Higher performance, 200K logic cells, more DSP, higher cost and power

**Selection Rationale:** XC7A100T provides good balance of DSP resources (240 slices) for signal processing, GTP transceivers for JESD204B DAC interface, and industrial temperature rating. TCB: Confirm GTP transceiver requirements match DAC interface speed.

### 2. AC/DC Power Supply - Isolated 110V AC to 12V DC

**Primary Choice:** TBD - Customer Specified (TBC)

*Isolated AC/DC power supply module, 110V AC input to 12V DC output, minimum 200W capacity, industrial temperature range.*

| Spec | Value |
|---|---|
| Input | 85-265V AC, 47-63Hz |
| Output | 12V DC |
| Power | ≥200W continuous |
| Isolation | >2500VAC |
| Efficiency | ≥85% |
| Protections | OVP, OCP, SCP, OTP |
| Temp Range | -40 to +85°C |

**Alternatives:**
- **TDK-Lambda CUS200M12** (TDK-Lambda): 200W medical-grade supply, high reliability, may exceed requirements
- **Mean Well RSP-200-12** (Mean Well): 200W industrial supply, lower cost, verify temp range derating

**Selection Rationale:** Safety-critical component requiring UL/IEC 60950-1 or 62368-1 certification. Medical or industrial grade recommended for reliability. TBC: Final part selection based on safety certifications and EMI requirements.

### 3. Buck Converter - FPGA Core (1.0V High Current)

**Primary Choice:** TPS543C20RVFT (Texas Instruments)

*Synchronous buck converter with integrated FETs, output current up to 20A, suitable for Artix-7 VCCINT rail.*

| Spec | Value |
|---|---|
| Input | 4.5-18V |
| Output | 0.6-5.5V |
| Current | 20A |
| Switching Freq | 200kHz to 1.2MHz |
| Efficiency | ≥95% @ 12V to 1V |
| Temp Range | -40 to +125°C |

**Alternatives:**
- **LT8636** (Analog Devices): Similar specs, low noise, verify availability
- **BD9E202FVM** (Rohm): Lower cost, lower current (15A), may be sufficient for smaller Artix-7

**Selection Rationale:** 20A capacity provides margin for Artix-7 core current (typically 5-10A depending on utilization). TBC: Verify Artix-7 device size and utilization to confirm current requirement. Source: TI TPS543C20 datasheet, SNVSAU0C, March 2023.

### 4. Buck Converter - FPGA Auxiliary Rails (1.2V, 1.8V, 3.3V)

**Primary Choice:** TPS62913 (Texas Instruments)

*4-switch synchronous buck converter, 5A output, configurable output voltage via feedback divider, suitable for FPGA VCCBRAM, VCCAUX, and IO rails.*

| Spec | Value |
|---|---|
| Input | 4.5-28V |
| Output | 0.6-5.5V |
| Current | 5A |
| Switching Freq | 200kHz to 2.2MHz |
| Efficiency | ≥93% @ 12V to 1.8V |
| Temp Range | -40 to +125°C |

**Alternatives:**
- **LTC3372** (Analog Devices): Quad output buck, single IC for multiple rails, verify current requirements
- **MP8869** (Monolithic Power): Lower cost, similar specs, verify availability

**Selection Rationale:** Multiple units provide separate 1.2V (VCCBRAM), 1.8V (VCCAUX), and 3.3V (FPGA IO) rails with proper sequencing. TBC: Verify sequencing requirements and use Power Good signals. Source: TI TPS62913 datasheet, SLVSCT2D, May 2023.

### 5. Buck Converter - RF Chain Low Noise (5V for DAC, Mixer, LO)

**Primary Choice:** LT8650S (Analog Devices)

*Silent Switcher synchronous buck converter, ultra-low noise, 4A output, optimized for sensitive RF/analog circuits.*

| Spec | Value |
|---|---|
| Input | 3-42V |
| Output | 0.8-15V |
| Current | 4A |
| Switching Freq | 2MHz |
| Noise | 25μV RMS |
| Temp Range | -40 to +125°C |

**Alternatives:**
- **TPS62912** (Texas Instruments): Low noise alternative, verify RF performance
- **MAX17610** (Maxim Integrated): Ultra-low noise, lower current, may be sufficient for LO and mixer

**Selection Rationale:** Silent Switcher technology minimizes switching noise coupling into RF chain. Critical for LO phase noise and DAC SNR performance. TBC: Verify current requirements for DAC, mixer, and LO. Source: Analog Devices LT8650S datasheet, Rev 0, 2022.

### 6. High-Speed DAC - FPGA Interface

**Primary Choice:** AD9172 (Analog Devices)

*Dual-channel, 12-bit, 12 GSPS DAC with JESD204B interface, suitable for generating IF/baseband signals for upconversion to 5-10GHz.*

| Spec | Value |
|---|---|
| Resolution | 12-bit |
| Sample Rate | up to 12 GSPS |
| Interface | JESD204B (up to 12.5 Gbps per lane) |
| Analog BW | 6GHz |
| Power | 1.8W (typ) |
| Temp Range | -40 to +85°C |

**Alternatives:**
- **DAC38J84** (Texas Instruments): Quad-channel, 16-bit, 2.5 GSPS, lower sample rate but higher resolution
- **AD9144** (Analog Devices): 16-bit, 2.4 GSPS, higher resolution, lower sample rate

**Selection Rationale:** 12 GSPS enables direct IF generation up to Nyquist limits, reducing mixer stages. JESD204B interface connects directly to Artix-7 GTP transceivers. TBC: Verify sample rate and bandwidth requirements based on signal bandwidth. Source: Analog Devices AD9172 datasheet, Rev A, 2021.

### 7. RF Mixer - Upconversion to 5-10GHz

**Primary Choice:** HMC1144 (Analog Devices)

*Wideband I/Q mixer covering 5-12GHz RF range, suitable for upconverting IF signals to final output frequency.*

| Spec | Value |
|---|---|
| RF Frequency | 5-12GHz |
| LO Frequency | 4-11GHz |
| IF Frequency | DC-6GHz |
| Conversion Gain | 6dB |
| OIP3 | 24dBm |
| Temp Range | -40 to +85°C |

**Alternatives:**
- **MAMX-011045** (Macom): Double-balanced mixer, 6-18GHz, verify performance at 5GHz lower edge
- **ADL5375** (Analog Devices): Broadband I/Q modulator, 400MHz-6GHz, may not cover upper 5-10GHz range

**Selection Rationale:** Covers 5-10GHz range with good linearity. I/Q architecture enables complex modulation if needed. TBC: Verify LO frequency planning and IF frequency selection. Source: Analog Devices HMC1144 datasheet, Rev C, 2022.

### 8. Wideband Power Amplifier - 5-10GHz 40dBm Output

**Primary Choice:** TBD - High Power PA (TBC)

*GaN or GaAs wideband power amplifier covering 5-10GHz with minimum 40dBm (10W) saturated output power. Requires external matching and thermal management.*

| Spec | Value |
|---|---|
| Frequency Range | 5-10GHz |
| Psat | ≥40dBm (10W) |
| Gain | ≥30dB |
| PAE | ≥20% (target) |
| Supply | ≥12V (depends on technology) |
| Temp Range | -40 to +85°C |

**Alternatives:**
- **GaN-based MMIC PA** (Qorvo / Macom / Wolfspeed): Higher power density, requires higher supply voltage (28-50V), more complex supply
- **TDA-based PA module** (Custom or module supplier): Mature technology, lower voltage, may require multiple stages

**Selection Rationale:** <safety_flag>SAFETY CRITICAL: 40dBm RF output is hazardous - requires proper shielding and interlock. PA requires significant thermal management (heatsink/fan). TBC: Final PA selection critical - requires detailed vendor evaluation for bandwidth, power, efficiency trade-offs. Source: Survey of GaN/GaAs PA vendors (Qorvo, Macom, Wolfspeed, Analog Devices).

### 9. Local Oscillator - Tunable 5-10GHz

**Primary Choice:** ADF5356 (Analog Devices)

*Wideband synthesizer with integrated VCO, covering 53.125 MHz to 13.6 GHz output frequency, low phase noise.*

| Spec | Value |
|---|---|
| Output Frequency | 53.125 MHz to 13.6 GHz |
| Phase Noise | -125dBc/Hz @ 1MHz offset @ 5GHz |
| Tuning Res | Not specified (fractional-N) |
| Power | Single supply |
| Temp Range | -40 to +85°C |

**Alternatives:**
- **LMX2594** (Texas Instruments): Similar performance, lower phase noise option, verify compatibility
- **HMC704** (Analog Devices): Integer-N synthesizer, lower phase noise, may be sufficient

**Selection Rationale:** Covers entire 5-10GHz LO range with margin. Low phase noise critical for modulation quality. SPI programmable from Artix-7. TBC: Verify phase noise and spurious requirements based on modulation scheme. Source: Analog Devices ADF5356 datasheet, Rev B, 2020.
