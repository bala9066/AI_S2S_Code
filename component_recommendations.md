# Component Recommendations
## mn

### 1. Wideband LNA 5-18 GHz

**Primary Choice:** [HMC698LP4(E)](https://www.analog.com/en/search.html#q=HMC698LP4%28E%29) (Analog Devices)

*GaAs MMIC HEMT Low Noise Amplifier, 5-20 GHz, 20 dB gain, 2.5 dB noise figure*

[📄 Datasheet](https://www.analog.com/en/search.html#q=HMC698LP4%28E%29)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/hmc698lp4e/3977553)

| Spec | Value |
|---|---|
| frequency_range | 5-20 GHz |
| gain_db | 20 |
| noise_figure_db | 2.5 |
| p1db_dbm | 18 |
| supply_voltage_v | 5 |
| package | QFN 4x4 mm |

**Alternatives:**
- **[MAAL-011141](https://www.google.com/search?q=MAAL-011141+datasheet)** (MACOM): Lower gain (15 dB) but lower power consumption

**Selection Rationale:** Wideband coverage exceeds 18 GHz requirement with excellent noise figure and gain. Direct 5V operation matches supply requirement.

### 2. Variable Gain Amplifier IF/RF

**Primary Choice:** [ADL5330](https://www.analog.com/en/search.html#q=ADL5330) (Analog Devices)

*Wideband Variable Gain Amplifier, 100 MHz to 4 GHz, 60 dB gain range*

[📄 Datasheet](https://www.analog.com/en/search.html#q=ADL5330)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/ADL5330ACPZ/1179284)

| Spec | Value |
|---|---|
| frequency_range | 100 MHz - 4 GHz |
| gain_range_db | 60 |
| noise_figure_db | 6 |
| oip3_dbm | 30 |
| supply_voltage_v | 5 |

**Alternatives:**
- **[HMC698LP4](https://www.analog.com/en/search.html#q=HMC698LP4)** (Analog Devices): Fixed gain, no VGA capability

**Selection Rationale:** Wideband VGA with 60 dB gain control range enables dynamic range optimization. 5V single supply operation.

### 3. RF Mixer Downconverter

**Primary Choice:** [HMC521LC4](https://www.analog.com/en/search.html#q=HMC521LC4) (Analog Devices)

*GaAs MMIC Mixer, 5-18 GHz RF, -10 to +6 GHz IF, +17 dBm LO drive*

[📄 Datasheet](https://www.analog.com/en/search.html#q=HMC521LC4)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/HMC521LC4/1814186)

| Spec | Value |
|---|---|
| rf_frequency_range | 5-18 GHz |
| if_frequency_range | DC-6 GHz |
| conversion_loss_db | 8 |
| lo_drive_dbm | 17 |
| supply_voltage_v | 5 |

**Alternatives:**
- **[MGA-22103](https://www.qorvo.com/products/d/mga-22103)** (Qorvo): Higher LO drive required

**Selection Rationale:** Wideband mixer covers entire 5-18 GHz RF range with flexible IF output. Integrated amplifier reduces external component count.

### 4. High Speed ADC 1-10 Gsps

**Primary Choice:** [ADC10D1000](https://www.ti.com/product/ADC10D1000) (Texas Instruments)

*Dual 10-bit 1.0 Gsps ADC, interleavable to 2.0 Gsps, 1.8V supply*

[📄 Datasheet](https://www.ti.com/product/ADC10D1000)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/texas-instruments/ADC10D1000RHBR/2740665)

| Spec | Value |
|---|---|
| resolution_bits | 10 |
| sampling_rate_gsps | 1.0 |
| snr_db | 59 |
| sfdr_db | 70 |
| supply_voltage_v | 1.8 |
| power_mw | 1800 |

**Alternatives:**
- **[ADC12DJ3200](https://www.ti.com/product/ADC12DJ3200)** (Texas Instruments): Higher resolution (12-bit) but lower max sample rate (3.2 Gsps)

**Selection Rationale:** Dual-channel ADC can be interleaved for higher effective sampling rates. Excellent SFDR meets linearity requirements.

### 5. FPGA Signal Processing

**Primary Choice:** [XCZU4EV-SFVC784](https://www.amd.com/en/search/site-keyword-search.html#q=XCZU4EV-SFVC784) (AMD (Xilinx))

*Zynq UltraScale+ MPSoC, 53K logic cells, integrated ARM Cortex-A53*

[📄 Datasheet](https://www.amd.com/en/search/site-keyword-search.html#q=XCZU4EV-SFVC784)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/amd/XCZU4EV-SFVC784-1-i/6189748)

| Spec | Value |
|---|---|
| logic_cells | 53K |
| dsp_slices | 192 |
| transceivers_gtp | 4 |
| serdes_gbps | 6.6 |
| supply_v | 1.8V core |
| package | SFVC784 |

**Alternatives:**
- **[10CX220YF780I5G](https://www.google.com/search?q=10CX220YF780I5G+datasheet)** (Intel (Altera)): No hard processor, requires external MCU

**Selection Rationale:** Zynq UltraScale+ provides integrated ARM cores for control and FPGA fabric for DSP. Integrated GTP transceivers support GigE interface.

### 6. Gigabit Ethernet PHY

**Primary Choice:** [VSC8522](https://www.microchip.com/search/searchresults/VSC8522) (Microchip)

*Single Port Gigabit Ethernet PHY, 1000BASE-T, RGMII/SGMII interface*

[📄 Datasheet](https://www.microchip.com/search/searchresults/VSC8522)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/microchip-technology/VSC8522-I-JM/5982395)

| Spec | Value |
|---|---|
| data_rate | 1Gbps |
| interface | RGMII/SGMII |
| supply_voltage_v | 1.8/2.5/3.3 |
| power_mw | 550 |
| package | QFN-48 |

**Alternatives:**
- **[RTL8211F](https://www.realtek.com/en/products/communications-network-ics/item/rtl8211f)** (Realtek): Consumer grade, limited industrial documentation

**Selection Rationale:** Industrial temperature qualified PHY with flexible interface options. Low power consumption suitable for embedded systems.

### 7. 3.3V LDO Regulator

**Primary Choice:** [TPS7A4700](https://www.ti.com/product/TPS7A4700) (Texas Instruments)

*Ultra-low noise LDO, 1A output, 4µVRMS noise, 3.3V fixed output*

[📄 Datasheet](https://www.ti.com/product/TPS7A4700)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/texas-instruments/TPS7A4700RGWT/2658606)

| Spec | Value |
|---|---|
| output_voltage_v | 3.3 |
| output_current_a | 1 |
| noise_uv_rms | 4 |
| psrr_db | 72 at 1kHz |
| input_voltage_max_v | 20 |

**Alternatives:**
- **[LT3045](https://www.analog.com/en/search.html#q=LT3045)** (Analog Devices): Lower current (500 mA)

**Selection Rationale:** Ultra-low noise LDO critical for clean ADC and FPGA supply rails. High PSRR reduces supply noise coupling.

### 8. 1.8V LDO Regulator

**Primary Choice:** [LT3045](https://www.analog.com/en/search.html#q=LT3045) (Analog Devices)

*Ultra-low noise LDO, 500 mA output, 0.8µVRMS noise, adjustable*

[📄 Datasheet](https://www.analog.com/en/search.html#q=LT3045)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/LT3045EDD%23PBF/5960773)

| Spec | Value |
|---|---|
| output_voltage_v | 1.8 adj |
| output_current_a | 0.5 |
| noise_uv_rms | 0.8 |
| psrr_db | 79 at 10kHz |

**Alternatives:**
- **[TPS7A4700](https://www.ti.com/product/TPS7A4700)** (Texas Instruments): Higher noise (4 µVRMS)

**Selection Rationale:** Lowest noise LDO available for sensitive ADC and FPGA core supplies. Excellent load transient response.

### 9. RF Input Connector

**Primary Choice:** [149-1011-801](https://www.te.com/en/search.html#q=149-1011-801) (TE Connectivity)

*2.4mm female PCB jack, 50 ohm, operation to 50 GHz*

[📄 Datasheet](https://www.te.com/en/search.html#q=149-1011-801)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/te-connectivity-amp-connectors/149-1011-801/615885)

| Spec | Value |
|---|---|
| connector_type | 2.4mm female |
| impedance_ohm | 50 |
| frequency_max_ghz | 50 |
| mounting | PCB through-hole |

**Alternatives:**
- **[086-1-4-4-910-000](https://www.google.com/search?q=086-1-4-4-910-000+datasheet)** (Radiall): Higher cost

**Selection Rationale:** 2.4mm connector provides excellent performance up to 50 GHz, well beyond 18 GHz requirement. Low VSWR and repeatable connections.
