# Component Recommendations
## ehg

### 1. Wideband LNA 5-18 GHz

**Primary Choice:** [HMC8141](https://www.analog.com/en/search.html#q=HMC8141) (Analog Devices)

*GaAs MMIC LNA, 6-20 GHz, 20 dB gain, 3 dB noise figure*

[📄 Datasheet](https://www.analog.com/en/search.html#q=HMC8141)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/hmc8141/5559686)

| Spec | Value |
|---|---|
| gain_db | 20 |
| noise_figure_db | 3 |
| p1db_dbm | 18 |
| ip3_dbm | 28 |
| supply_voltage_v | 5 |
| current_ma | 85 |

**Alternatives:**
- **[MAAM-011100](https://www.google.com/search?q=MAAM-011100+datasheet)** (Macom): Similar NF, lower gain
- **[TGA4516](https://www.qorvo.com/products/d/1500786)** (Qorvo): Higher power, wider bandwidth

**Selection Rationale:** Selected for 5-18 GHz coverage, low 3 dB NF contribution, and military temperature range support

### 2. Variable Gain Amplifier

**Primary Choice:** [HMC698LP4](https://www.analog.com/en/search.html#q=HMC698LP4) (Analog Devices)

*Digital VGA, DC-6 GHz, 30 dB gain range, SPI control*

[📄 Datasheet](https://www.analog.com/en/search.html#q=HMC698LP4)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/hmc698lp4/1102435)

| Spec | Value |
|---|---|
| gain_range_db | 30 |
| bandwidth_ghz | 6 |
| gain_step_db | 1 |
| supply_voltage_v | 5 |
| current_ma | 90 |

**Alternatives:**
- **[ADL5240](https://www.analog.com/en/search.html#q=ADL5240)** (Analog Devices): Analog control vs digital

**Selection Rationale:** Digital gain control enables AGC implementation, wideband performance

### 3. Wideband Mixer

**Primary Choice:** [HMC-CMS19](https://www.analog.com/en/search.html#q=HMC-CMS19) (Analog Devices)

*Double-balanced mixer, 6-18 GHz RF/LO, high IP3*

[📄 Datasheet](https://www.analog.com/en/search.html#q=HMC-CMS19)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/hmc-cms19-ep4e/4920085)

| Spec | Value |
|---|---|
| rf_range_ghz | 6-18 |
| lo_range_ghz | 3-12 |
| if_range_mhz | DC-4 |
| conversion_loss_db | 8 |
| ip3_dbm | 24 |

**Alternatives:**
- **[MCA-06](https://www.google.com/search?q=MCA-06+datasheet)** (Macom): Lower frequency range

**Selection Rationale:** Wideband coverage to 18 GHz, high linearity for 0-10 dBm IP3 target

### 4. IF Amplifier

**Primary Choice:** [HMC5805](https://www.analog.com/en/search.html#q=HMC5805) (Analog Devices)

*High-dynamic range VGA, DC-1 GHz, 40 dB gain range*

[📄 Datasheet](https://www.analog.com/en/search.html#q=HMC5805)

| Spec | Value |
|---|---|
| bandwidth_ghz | DC-1 |
| gain_range_db | 40 |
| noise_figure_db | 6 |
| supply_voltage_v | 5 |

**Alternatives:**
- **[ADL8126](https://www.analog.com/en/search.html#q=ADL8126)** (Analog Devices): Lower gain range

**Selection Rationale:** Provides IF gain and level control before ADC

### 5. High-Speed ADC

**Primary Choice:** [EV10AQ190A](https://www.google.com/search?q=EV10AQ190A+datasheet) (Teledyne e2v)

*Quad-channel 10-bit ADC, up to 5 GSps, LVDS output*

[📄 Datasheet](https://www.google.com/search?q=EV10AQ190A+datasheet)

| Spec | Value |
|---|---|
| resolution_bits | 10 |
| max_sample_rate_gsps | 5 |
| input_bandwidth_ghz | 3 |
| sfdr_db | 80 |
| power_mw | 2000 |
| output_interface | LVDS |

**Alternatives:**
- **[ADC10D1500](https://www.ti.com/lit/ds/symlink/adc10d1500.pdf)** (Texas Instruments): Lower sample rate
- **[AT1046](https://www.analog.com/en/search.html#q=AT1046)** (Analog Devices): Single channel

**Selection Rationale:** 5 GSps achieves 80+ dB SFDR with 10-bit resolution, LVDS output required, MIL-STD compliant

### 6. DC-DC Converter 28V to 5V

**Primary Choice:** [PKM4716TCD15](https://www.google.com/search?q=PKM4716TCD15+datasheet) (Murata Power Solutions)

*Isolated DC-DC converter, 28V in, 15V out, 40W*

[📄 Datasheet](https://www.google.com/search?q=PKM4716TCD15+datasheet)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/murata-power-solutions-inc/PKM4716TCD15/3995247)

| Spec | Value |
|---|---|
| input_voltage_v | 28 |
| output_voltage_v | 15 |
| power_w | 40 |
| isolation_v | 1500 |
| efficiency_percent | 87 |

**Alternatives:**
- **[PCMIAH16S15](https://www.vicorpower.com/search?q=PCMIAH16S15)** (Vicor): Higher cost

**Selection Rationale:** MIL-STD compliant DC-DC for 28V aircraft/military input voltage

### 7. LDO Regulator Low Noise

**Primary Choice:** [LT3045](https://www.analog.com/en/search.html#q=LT3045) (Analog Devices)

*Ultra-low noise LDO, 500mA, 0.8uV RMS noise*

[📄 Datasheet](https://www.analog.com/en/search.html#q=LT3045)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/LT3045EDD%23PBF/5654682)

| Spec | Value |
|---|---|
| output_current_a | 0.5 |
| output_voltage_v | 0-15 |
| noise_uv_rms | 0.8 |
| psrr_db | 79 |
| input_voltage_v | 20 |

**Alternatives:**
- **[LT3094](https://www.analog.com/en/search.html#q=LT3094)** (Analog Devices): Negative rail only

**Selection Rationale:** Ultra-low noise for sensitive RF/analog circuits, -55 to +125C operating range

### 8. RF Input Connector

**Primary Choice:** [142-0701-851](https://www.cinch.com/products/adapters/142-0701-851) (Cinch Connectivity Solutions)

*SMA jack, 50 ohm, straight PCB mount*

[📄 Datasheet](https://www.cinch.com/products/adapters/142-0701-851)

| Spec | Value |
|---|---|
| impedance_ohms | 50 |
| frequency_ghz | 18 |
| vswr | 1.3 |
| mounting | PCB edge |

**Alternatives:**
- **[2211502450](https://www.te.com/commerce/DocumentDelivery/DDEController?Action=showdoc&DocId=Customer+Drawings%2F2211502450%7FA%7Fpdf%7FEnglish%7FENG_CD_2211502450_A.pdf)** (TE Connectivity): Similar specs

**Selection Rationale:** Standard SMA connector supports 5-18 GHz range with good VSWR

### 9. Bandpass Filter 5-18 GHz

**Primary Choice:** [VBF-1850+](https://www.google.com/search?q=VBF-1850%2B+datasheet) (Mini-Circuits)

*Wideband bandpass filter, 5-18 GHz, low insertion loss*

[📄 Datasheet](https://www.google.com/search?q=VBF-1850%2B+datasheet)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/mini-circuits/VBF-1850%2B/3887408)

| Spec | Value |
|---|---|
| passband_ghz | 5-18 |
| insertion_loss_db | 2 |
| rejection_db | 30 |
| vswr | 2 |

**Alternatives:**
- **[BP5S-1800S-S+](https://www.google.com/search?q=BP5S-1800S-S%2B+datasheet)** (Mini-Circuits): Lower rejection

**Selection Rationale:** Wideband filter provides image rejection and out-of-band signal suppression
