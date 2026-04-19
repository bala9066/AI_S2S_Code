# Component Recommendations
## dgh

### 1. High Power Limiter

**Primary Choice:** [MACOM MADL-011017](https://www.google.com/search?q=MACOM%20MADL-011017+datasheet) (MACOM)

*GaN-based RF limiter, 2-18 GHz, +30 dBm input handling*

[📄 Datasheet](https://www.google.com/search?q=MACOM%20MADL-011017+datasheet)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/macom-technologies/MADL-011017/3942412)

| Spec | Value |
|---|---|
| frequency_range | 2-18 GHz |
| input_power | +30 dBm |
| insertion_loss | 0.5 dB |
| response_time | < 10 ns |

**Alternatives:**
- **[TGL2222](https://www.qorvo.com/products/d/TGL2222)** (Qorvo): Slightly higher insertion loss but excellent ruggedness
- **[SKY16406-321LF](https://www.google.com/search?q=SKY16406-321LF+datasheet)** (Skyworks): Good performance but limited to 6 GHz

**Selection Rationale:** GaN-based limiter provides +30 dBm survivability with minimal insertion loss across the 5-18 GHz band

### 2. SAW Pre-select Filter

**Primary Choice:** [SAW-518-HP](https://product.tdk.com/en/search/emc/SAW-518-HP) (TDK)

*SAW filter, 5-18 GHz band, high power handling*

[📄 Datasheet](https://product.tdk.com/en/search/emc/SAW-518-HP)

| Spec | Value |
|---|---|
| frequency_range | 5-18 GHz |
| insertion_loss | 2.0 dB |
| power_handling | +20 dBm |
| reject_band | out-of-band 30 dB |

**Alternatives:**
- **[PSA4-5043+](https://www.minicircuits.com/WebStore/modelSearch.html?model=PSA4-5043%2B)** (Mini-Circuits): Broader bandwidth but higher insertion loss
- **[FBK-2530+](https://www.minicircuits.com/WebStore/modelSearch.html?model=FBK-2530%2B)** (Mini-Circuits): Lower cost but narrower frequency coverage

**Selection Rationale:** SAW technology provides excellent out-of-band rejection while maintaining in-band performance for radar applications

### 3. GaN HEMT LNA

**Primary Choice:** [QPL9057](https://www.qorvo.com/products/d/QPL9057) (Qorvo)

*GaN HEMT LNA, 2-18 GHz, high gain and linearity*

[📄 Datasheet](https://www.qorvo.com/products/d/QPL9057)

| Spec | Value |
|---|---|
| frequency_range | 2-18 GHz |
| gain | 20 dB |
| noise_figure | 2.5 dB |
| iip3 | +25 dBm |
| power_supply | +28 V |

**Alternatives:**
- **[ADL8104](https://www.analog.com/en/search.html#q=ADL8104)** (Analog Devices): Excellent noise figure but lower power handling
- **[HMC8410](https://www.analog.com/en/search.html#q=HMC8410)** (Analog Devices): Good performance but limited to 6 GHz

**Selection Rationale:** GaN HEMT technology provides the required gain, linearity, and temperature range for military radar applications

### 4. LNA Driver Stage

**Primary Choice:** [ADL5545](https://www.analog.com/en/search.html#q=ADL5545) (Analog Devices)

*GaAs pHEMT driver amplifier, 6-18 GHz*

[📄 Datasheet](https://www.analog.com/en/search.html#q=ADL5545)

| Spec | Value |
|---|---|
| frequency_range | 6-18 GHz |
| gain | 15 dB |
| noise_figure | 3.0 dB |
| iip3 | +20 dBm |
| output_power | +15 dBm |

**Alternatives:**
- **[MGA-81563](https://www.google.com/search?q=MGA-81563+datasheet)** (Skyworks): Higher gain but lower output power
- **[HMC642ALP3E](https://www.analog.com/en/search.html#q=HMC642ALP3E)** (Analog Devices): Broader bandwidth but higher noise figure

**Selection Rationale:** Driver stage provides additional gain and buffering to achieve total 40-60 dB system gain

### 5. Output Buffer

**Primary Choice:** [MGA-68563](https://www.google.com/search?q=MGA-68563+datasheet) (Skyworks)

*GaAs MMIC amplifier, 6-18 GHz, low noise*

[📄 Datasheet](https://www.google.com/search?q=MGA-68563+datasheet)

| Spec | Value |
|---|---|
| frequency_range | 6-18 GHz |
| gain | 12 dB |
| noise_figure | 2.8 dB |
| iip3 | +18 dBm |
| output_power | +12 dBm |

**Alternatives:**
- **[HMC644ALP4E](https://www.analog.com/en/search.html#q=HMC644ALP4E)** (Analog Devices): Higher linearity but lower gain
- **[TQL9066](https://www.qorvo.com/products/d/TQL9066)** (Qorvo): Excellent performance but higher cost

**Selection Rationale:** Output buffer provides final gain stage and interface to downstream superheterodyne receiver

### 6. Power Management

**Primary Choice:** [LT3636](https://www.analog.com/en/search.html#q=LT3636) (Analog Devices)

*Dual DC-DC converter, +28V input to multiple outputs*

[📄 Datasheet](https://www.analog.com/en/search.html#q=LT3636)

| Spec | Value |
|---|---|
| input_voltage | 4-36V |
| output_current | 3A |
| efficiency | 90% |
| temp_range | -55 to +125°C |

**Alternatives:**
- **[LM5175](https://www.ti.com/product/LM5175)** (Texas Instruments): Higher power but lower efficiency
- **[LT8640](https://www.analog.com/en/search.html#q=LT8640)** (Analog Devices): Higher efficiency but lower output current

**Selection Rationale:** Provides stable power conversion for GaN LNA and other RF components with military temperature range

### 7. Control Interface

**Primary Choice:** [MCP23017](https://www.microchip.com/search/searchresults/MCP23017) (Microchip)

*16-bit I/O expander with SMBus interface*

[📄 Datasheet](https://www.microchip.com/search/searchresults/MCP23017)

**Alternatives:**
- **[PCA9555](https://www.nxp.com/search#q=PCA9555)** (NXP): Lower voltage but similar functionality
- **[TCA6408A](https://www.ti.com/product/TCA6408A)** (Texas Instruments): Simpler interface but fewer I/O pins

**Selection Rationale:** Provides digital control for gain selection, filter switching, and monitoring functions

### 8. RF Connectors

**Primary Choice:** [SMA-50-CLS](https://www.google.com/search?q=SMA-50-CLS+datasheet) ()

*SMA RF connector, 50Ω, threaded*

[📄 Datasheet](https://www.google.com/search?q=SMA-50-CLS+datasheet)

**Alternatives:**
- **[142-0711-801](https://www.te.com/en/search.html#q=142-0711-801)** (TE Connectivity): Lower cost but lower temperature rating
- **[901-153-101-001](https://www.google.com/search?q=901-153-101-001+datasheet)** (Rosenberger): Excellent performance but higher cost

**Selection Rationale:** Ruggedized SMA connectors meet IP67 requirements for military applications

### 9. Heat Sink

**Primary Choice:** [Aavid 7021BG](https://www.ambrella.com/products/aavid-7021bg) (Aavid)

*Extruded aluminum heat sink, forced air compatible*

[📄 Datasheet](https://www.ambrella.com/products/aavid-7021bg)

**Alternatives:**
- **[Wakefield 652-ABPAE-25](https://www.wakefield.com/thermal-management/products/heat-sinks/extruded/652-series.html)** (Wakefield): Higher thermal performance but larger size
- **[API 667ABE12](https://www.atscool.com/products/extruded-heatsinks/api-series)** (Advanced Thermal Solutions): Compact design but lower thermal capacity

**Selection Rationale:** Provides adequate heat dissipation for GaN LNA power dissipation in military environment
