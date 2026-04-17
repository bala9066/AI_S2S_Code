# Component Recommendations
## Rf Receiver

### 1. Wideband LNA 5-18 GHz with low noise figure

**Primary Choice:** [AMMC-6241](https://www.google.com/search?q=AMMC-6241+datasheet) (Analog Devices (Hittite))

*GaAs MMIC LNA, 5-20 GHz, 20 dB gain, 3 dB noise figure, military temp grade available*

[📄 Datasheet](https://www.google.com/search?q=AMMC-6241+datasheet)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/AMMC-6241/1625690)

| Spec | Value |
|---|---|
| frequency_range | 5-20 GHz |
| gain | 20 dB |
| noise_figure | 3 dB |
| p1dB | +15 dBm |
| oip3 | +25 dBm |
| supply_voltage | +5V @ 80 mA |
| operating_temp | -55°C to +125°C (optional) |

**Alternatives:**
- **[GVA-123+](https://www.minicircuits.com/WebStore/modelSearch.html?model=GVA-123%2B)** (Mini-Circuits): Slightly higher NF (3.5 dB), lower cost, good availability
- **[TGA4706-CP](https://www.qorvo.com/products/d/qa003970)** (Qorvo): Higher P1dB (+20 dBm), similar NF, wider bandwidth 2-20 GHz

**Selection Rationale:** Selected for optimal noise figure (3 dB) meeting target specification, wide bandwidth coverage of 5-18 GHz, and military temperature grade availability.

### 2. Driver amplifier for gain boost and output drive

**Primary Choice:** [GVA-164+](https://www.minicircuits.com/WebStore/modelSearch.html?model=GVA-164%2B) (Mini-Circuits)

*Wideband driver amplifier, 6-18 GHz, 15 dB gain, +25 dBm P1dB, excellent linearity*

[📄 Datasheet](https://www.minicircuits.com/WebStore/modelSearch.html?model=GVA-164%2B)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/mini-circuits/GVA-164/371654)

| Spec | Value |
|---|---|
| frequency_range | 6-18 GHz |
| gain | 15 dB |
| p1dB | +25 dBm |
| oip3 | +38 dBm |
| supply_voltage | +8V @ 150 mA |
| operating_temp | -55°C to +125°C |

**Alternatives:**
- **[AMMC-6220](https://www.analog.com/en/search.html#q=AMMC-6220)** (Analog Devices): Higher frequency range (DC-20 GHz), lower gain (12 dB)
- **[TQP3M9036](https://www.qorvo.com/products/d/qa002591)** (Qorvo): Lower power consumption, slightly lower P1dB (+20 dBm)

**Selection Rationale:** Provides required gain and output power capability with excellent linearity (OIP3 +38 dBm). Military temperature rated and covers full frequency band.

### 3. RF input limiter for protection to +10 dBm

**Primary Choice:** [VLVA-300-44](https://www.google.com/search?q=VLVA-300-44+datasheet) (Microsemi (Microchip))

*GaAs limiter diode, threshold +10 dBm, fast recovery, covers DC-20 GHz*

[📄 Datasheet](https://www.google.com/search?q=VLVA-300-44+datasheet)

| Spec | Value |
|---|---|
| frequency_range | DC-20 GHz |
| threshold_power | +10 dBm |
| max_power | 1W peak |
| insertion_loss | 0.5 dB |
| operating_temp | -55°C to +125°C |

**Alternatives:**
- **[CLAMP-008-13LF](https://www.l3harris.com)** (L3 Narda-MITEQ): Higher threshold (+13 dBm), higher insertion loss
- **[LM4112](https://www.google.com/search?q=LM4112+datasheet)** (Macom): Integrated limiter LNA combination

**Selection Rationale:** Provides protection up to specified +10 dBm input level with fast recovery and low insertion loss. Military rated device.

### 4. Voltage regulator for 12V to 5V/8V conversion

**Primary Choice:** [LM22676-5.0](https://www.ti.com/product/LM22676) (Texas Instruments)

*3A step-down switching regulator, adjustable, 4.5-42V input, military temp grade*

[📄 Datasheet](https://www.ti.com/product/LM22676)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/texas-instruments/LM22676-5-0-NOPB/1864940)

| Spec | Value |
|---|---|
| input_voltage | 4.5-42V |
| output_voltage | 5V fixed |
| output_current | 3A |
| efficiency | >90% |
| operating_temp | -55°C to +125°C |

**Alternatives:**
- **[LT3045](https://www.google.com/search?q=LT3045+datasheet)** (Analog Devices (Linear Tech)): LDO regulator (lower noise), 500mA max current
- **[TPS54620](https://www.ti.com/product/TPS54620)** (Texas Instruments): Synchronous buck converter, 6A output, lower voltage only

**Selection Rationale:** Handles wide input voltage range, provides sufficient current for both amplifiers, military temperature rating, high efficiency reduces thermal load.

### 5. RF connectors for input and output

**Primary Choice:** [142-0701-851](https://www.cinch.com/products/connectors/rf-connectors/sma-connectors) (Cinch Connectivity Solutions (Johnson))

*SMA female jack, 50 ohm, 4-hole flange mount, stainless steel, military qualified*

[📄 Datasheet](https://www.cinch.com/products/connectors/rf-connectors/sma-connectors)

| Spec | Value |
|---|---|
| frequency_range | DC-18 GHz |
| impedance | 50 ohms |
| vswr | 1.3:1 max |
| contact_material | Beryllium copper gold plated |
| operating_temp | -65°C to +165°C |

**Alternatives:**
- **[132323](https://www.te.com/en/search.html#q=132323)** (TE Connectivity): Similar specs, different mounting style
- **[73251-135](https://www.google.com/search?q=73251-135+datasheet)** (Molex): Cost-optimized version

**Selection Rationale:** Military qualified SMA connector rated for full frequency range, rugged stainless steel construction suitable for harsh environments.

### 6. DC power connector for military applications

**Primary Choice:** [DPX series MIL-DTL-38999](https://www.google.com/search?q=DPX%20series%20MIL-DTL-38999+datasheet) (Amphenol Aerospace)

*MIL-DTL-38999 Series III circular connector, shell size 11, 3 contacts, crimp termination*

[📄 Datasheet](https://www.google.com/search?q=DPX%20series%20MIL-DTL-38999+datasheet)

| Spec | Value |
|---|---|
| series | MIL-DTL-38999 Series III |
| shell_size | 11 |
| contacts | 3 |
| current_rating | 13A per contact |
| operating_temp | -65°C to +200°C |
| vibration | MIL-STD-202 Method 213 |

**Alternatives:**
- **[D-38999 Series I](https://www.ittcannon.com/product-families/d38999-circular-connectors/)** (ITT Cannon): Series I instead of III, lower cost
- **[MS27467](https://www.google.com/search?q=MS27467+datasheet)** (Souriau): Equivalent specification

**Selection Rationale:** Standard military circular connector meeting MIL-DTL-38999 specification, rugged and reliable for harsh environments.

### 7. EMI filter for power input

**Primary Choice:** [RCEP602A-241](https://www.te.com/commerce/DocumentDelivery/DDEController?Action=showsrch&DocId=Specification+Or+Standard%7F2094297%7F1%7Fpdf%7FEnglish%7FENG_SS_2094297_1.pdf%7F2094297-1) (TE Connectivity)

*EMI power line filter, 6A, 24VDC, MIL-grade pi-filter configuration*

[📄 Datasheet](https://www.te.com/commerce/DocumentDelivery/DDEController?Action=showsrch&DocId=Specification+Or+Standard%7F2094297%7F1%7Fpdf%7FEnglish%7FENG_SS_2094297_1.pdf%7F2094297-1)

| Spec | Value |
|---|---|
| current_rating | 6A |
| voltage_rating | 24VDC |
| insertion_loss | >40dB @ 100kHz |
| operating_temp | -55°C to +125°C |

**Alternatives:**
- **[142-0701-851](https://www.cinch.com)** (Cinch): Different form factor
- **[SDC144](https://www.google.com/search?q=SDC144+datasheet)** (SCHURTER): Commercial grade, not military temp

**Selection Rationale:** Provides EMI filtering required for MIL-STD-461 compliance, military temperature rated, adequate current capacity.
