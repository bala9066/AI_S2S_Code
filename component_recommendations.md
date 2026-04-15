# Component Recommendations
## iguyc

### 1. Wideband Low Noise Amplifier covering 5-18 GHz with low noise figure and high linearity

**Primary Choice:** [HMC6987LP4E](https://www.analog.com/media/en/technical-documentation/data-sheets/hmc6987.pdf) (Analog Devices)

*GaAs MMIC PHEMT distributed amplifier, 5-20 GHz, 13 dB gain, 3 dB noise figure, +30 dBm OIP3*

[📄 Datasheet](https://www.analog.com/media/en/technical-documentation/data-sheets/hmc6987.pdf)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/hmc6987lp4e/4544381)

| Spec | Value |
|---|---|
| frequency_range | 5-20 GHz |
| gain | 13 dB |
| noise_figure | 3 dB |
| oip3 | +30 dBm |
| p1db | +18 dBm |
| supply | +5V / 90 mA |

**Alternatives:**
- **[MAAM-011101](https://www.macom.com/datasheets/MAAM-011101.pdf)** (Macom): Slightly higher NF but lower power consumption
- **[TQP3M9036](https://www.qorvo.com/products/p/TQP3M9036)** (Qorvo): Lower gain but excellent linearity

**Selection Rationale:** Excellent wideband coverage with low NF and high linearity meeting SFDR requirements. Operates well within industrial temperature range.

### 2. Wideband downconversion mixer for 5-18 GHz IF translation

**Primary Choice:** [HMC1194LP4E](https://www.analog.com/media/en/technical-documentation/data-sheets/hmc1194.pdf) (Analog Devices)

*Wideband passive mixer, 6-18 GHz, 7.5 dB conversion loss, +25 dBm IIP3*

[📄 Datasheet](https://www.analog.com/media/en/technical-documentation/data-sheets/hmc1194.pdf)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/hmc1194lp4e/5974490)

| Spec | Value |
|---|---|
| rf_frequency | 6-18 GHz |
| lo_frequency | 6-18 GHz |
| if_frequency | DC-6 GHz |
| conversion_loss | 7.5 dB |
| iip3 | +25 dBm |
| lo_drive | +15 dBm |

**Alternatives:**
- **[MCA-15+](https://www.markimicrowave.com/assetcatalog/MCA-15.pdf)** (Marki Microwave): Higher frequency range but similar performance

**Selection Rationale:** Excellent linearity and conversion loss across full band. Passive design provides superior IP3 for SFDR requirements.

### 3. Wideband frequency synthesizer/PLL for LO generation 5-18 GHz

**Primary Choice:** [ADF5355](https://www.analog.com/media/en/technical-documentation/data-sheets/ADF5355.pdf) (Analog Devices)

*Wideband microwave synthesizer with integrated VCO, 53.125 MHz to 13.6 GHz (with dividers)*

[📄 Datasheet](https://www.analog.com/media/en/technical-documentation/data-sheets/ADF5355.pdf)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/ADF5355CCPZ/5907272)

| Spec | Value |
|---|---|
| frequency_range | 53.125 MHz - 13.6 GHz |
| phase_noise | -125 dBc/Hz @ 1 MHz offset |
| vco_frequency | 3.4 - 6.8 GHz |
| output_power | -5 dBm |

**Alternatives:**
- **[LMX2594](https://www.ti.com/product/LMX2594)** (Texas Instruments): Similar performance but different architecture

**Selection Rationale:** Industry-standard wideband synthesizer with excellent phase noise. Can be multiplied for 5-18 GHz coverage.

### 4. Wideband Variable Gain Amplifier for AGC function

**Primary Choice:** [HMC698LP4](https://www.analog.com/media/en/technical-documentation/data-sheets/hmc698.pdf) (Analog Devices)

*Digital variable gain amplifier, DC-8 GHz, 31 dB gain range, 6-bit digital control*

[📄 Datasheet](https://www.analog.com/media/en/technical-documentation/data-sheets/hmc698.pdf)

| Spec | Value |
|---|---|
| frequency_range | DC-8 GHz |
| gain_range | 0-31 dB |
| gain_step | 0.5 dB |
| noise_figure | 6 dB |
| oip3 | +28 dBm |

**Alternatives:**
- **[ADL5240](https://www.analog.com/media/en/technical-documentation/data-sheets/ADL5240.pdf)** (Analog Devices): Analog control instead of digital

**Selection Rationale:** Excellent AGC capability with fine gain resolution and high linearity for SFDR requirements.

### 5. High-speed ADC for signal digitization

**Primary Choice:** [ADC12DJ3200](https://www.ti.com/product/ADC12DJ3200) (Texas Instruments)

*12-bit, 3.2 GSPS dual-channel ADC with JESD204B interface*

[📄 Datasheet](https://www.ti.com/product/ADC12DJ3200)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/texas-instruments/ADC12DJ3200IRGZT/6206614)

| Spec | Value |
|---|---|
| resolution | 12-bit |
| max_sample_rate | 3.2 GSPS |
| snr | 58.5 dBFS @ 2 GHz |
| sfdr | 70 dBc @ 2 GHz |
| interface | JESD204B/C |

**Alternatives:**
- **[AD9208](https://www.analog.com/media/en/technical-documentation/data-sheets/AD9208.pdf)** (Analog Devices): Similar specs, different interface options

**Selection Rationale:** Meets bandwidth and resolution requirements with excellent SFDR performance. JESD204B interface compatible with FPGA.

### 6. FPGA for signal processing and data interface

**Primary Choice:** [XCVU9P-FLGA2104](https://www.amd.com/en/products/fpgas-and-adaptive-socs/virtex-ultrascale-plus-fpgas/virtex-ultrascale-plus-fpga-product-table) (AMD (Xilinx))

*Virtex UltraScale+ FPGA with 1,782,600 logic cells, high-speed transceivers*

[📄 Datasheet](https://www.amd.com/en/products/fpgas-and-adaptive-socs/virtex-ultrascale-plus-fpgas/virtex-ultrascale-plus-fpga-product-table)

| Spec | Value |
|---|---|
| logic_cells | 1,782,600 |
| dsp_slices | 6,840 |
| transceivers | 64G (32.75Gb/s) |
| power | Programmable |
| industrial_temp | Supported |

**Alternatives:**
- **[10AX115N2F45I1SG](https://www.intel.com/content/www/us/en/docs/programmable/683127/current/arria-10-gx-fpga-overview.html)** (Intel (Altera)): Arria 10 GX with similar capabilities

**Selection Rationale:** High-performance FPGA family with extensive DSP resources and high-speed transceivers. Meets MIL-STD-883 qualification options available.

### 7. RF Input Connector

**Primary Choice:** [1492A-2-RFX](https://www.te.com/commerce/DocumentDelivery/DDEController?Action=showdoc&DocId=Customer+Drawing%7F1492A%7FJ3%7Fpdf%7FEnglish%7FENG_CD_1492A_J3.pdf%7F1580666) (TE Connectivity)

*2.4mm RF connector, female, 2-hole flange mount, up to 50 GHz*

[📄 Datasheet](https://www.te.com/commerce/DocumentDelivery/DDEController?Action=showdoc&DocId=Customer+Drawing%7F1492A%7FJ3%7Fpdf%7FEnglish%7FENG_CD_1492A_J3.pdf%7F1580666)

| Spec | Value |
|---|---|
| frequency_range | DC-50 GHz |
| impedance | 50 Ohm |
| vswr | <1.3:1 |
| mounting | 2-hole flange |

**Alternatives:**
- **[073411-6051](https://www.molex.com/molex/products/datasheet.jsp?part=active/0734116051_R_F_CONNECTORS.pdf)** (Molex): Similar specifications

**Selection Rationale:** High-quality connector suitable for 5-18 GHz operation with excellent VSWR characteristics.

### 8. Wideband Bandpass Filter for front-end filtering

**Primary Choice:** [RBP-5180-10](https://www.klmicrowave.com/products) (K&L Microwave (A Dover Company))

*5-18 GHz bandpass filter, 10% bandwidth, low insertion loss*

[📄 Datasheet](https://www.klmicrowave.com/products)

| Spec | Value |
|---|---|
| passband | 5-18 GHz |
| insertion_loss | <2 dB |
| rejection | >40 dB |
| vswr | <2.0:1 |

**Alternatives:**
- **[BP-5180+](https://www.minicircuits.com/pdfs/BP-5180+.pdf)** (Mini-Circuits): Off-the-shelf alternative with slightly different specs

**Selection Rationale:** Custom filter option for precise 5-18 GHz coverage. Meets rejection requirements for front-end filtering.

### 9. Power Supply Management

**Primary Choice:** [LTM4678](https://www.analog.com/media/en/technical-documentation/data-sheets/ltm4678.pdf) (Analog Devices)

*Dual 20A or single 40A DC/DC µModule regulator with digital power system management*

[📄 Datasheet](https://www.analog.com/media/en/technical-documentation/data-sheets/ltm4678.pdf)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/ltm4678ivy-3-3-pbf/11215188)

| Spec | Value |
|---|---|
| input_voltage | 4.5-16V |
| output_current | 40A single |
| output_voltage | 0.5-3.3V |
| efficiency | >95% |

**Alternatives:**
- **[TPS546D24A](https://www.ti.com/product/TPS546D24A)** (Texas Instruments): Lower current but efficient alternative

**Selection Rationale:** High-efficiency power module suitable for FPGA and RF components. Digital power management helps stay within 10-20W budget.
