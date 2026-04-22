# Component Recommendations
## hfuf

### 1. Input Limiter Protection (per channel)

**Primary Choice:** [SKY16602-632LF](https://www.skyworksinc.com/Search?k=SKY16602-632LF) (Skyworks Solutions Inc.)

**

[📄 Datasheet](https://www.skyworksinc.com/Search?k=SKY16602-632LF)

| Spec | Value |
|---|---|
| frequency_range | 0.2-4.0 GHz |
| max_cw_power | +30 dBm |
| insertion_loss | 0.3 dB typ |
| recovery_time | < 10 ns |

**Alternatives:**
- **[SKY16603-632LF](https://www.skyworksinc.com/Search?k=SKY16603-632LF)** (Skyworks Solutions Inc.): Wider bandwidth but higher insertion loss; anti-parallel PIN configuration
- **[LM200802-M-A-300-T](https://duckduckgo.com/?q=LM200802-M-A-300-T%20MACOM%20Technology%20Solutions%20datasheet)** (MACOM Technology Solutions): Integrated module limiter, easier assembly but larger footprint

**Selection Rationale:**  broadband PIN limiter covering S-band with +30 dBm survivability. Excellent match to +30 dBm spec. Operates to 4 GHz; C-band (4-6 GHz) coverage requires complementary device or parallel limiter stage.

### 2. LC Preselector Bandpass Filter (per channel)

**Primary Choice:** [Mini-Circuits BFHK-5001+](https://www.minicircuits.com/WebStore/dashboard.html?model=Mini-CircuitsBFHK-5001%2B) (Mini-Circuits)

**

[📄 Datasheet](https://www.minicircuits.com/WebStore/dashboard.html?model=Mini-CircuitsBFHK-5001%2B)

| Spec | Value |
|---|---|
| center_frequency | 4.9 GHz |
| passband | 4.5-5.3 GHz |
| insertion_loss | 2.0 dB typ |
| rejection | ≥ 20 dB at ±500 MHz |

**Alternatives:**
- **[PE8740](https://www.pasternack.com/search.aspx?q=PE8740)** (Pasternack): Connectorized 5.25-5.85 GHz BPF, higher performance but board space penalty
- **[QPQ3509SR](https://duckduckgo.com/?q=QPQ3509SR%20Qorvo%20datasheet)** (Qorvo): BAW technology 3.7-3.98 GHz, excellent rejection but narrow band

**Selection Rationale:** LTCC SMT bandpass filter near center of 2-6 GHz band. Provides 20 dB out-of-band rejection for image protection. Note: Covers 4.5-5.3 GHz sub-band; full 2-6 GHz coverage requires switched filter bank or custom LC design per REQ-HW-010.

### 3. RF Bias Tee (per LNA)

**Primary Choice:** [PE1604](https://www.pasternack.com/search.aspx?q=PE1604) (Pasternack)

**

[📄 Datasheet](https://www.pasternack.com/search.aspx?q=PE1604)

| Spec | Value |
|---|---|
| frequency_range | 100 MHz - 6 GHz |
| max_dc_current | 500 mA |
| max_dc_voltage | 50 V |
| insertion_loss | 0.15 dB typ |

**Alternatives:**
- **[PE1611](https://www.pasternack.com/search.aspx?q=PE1611)** (Pasternack): Higher current (2.5A) and voltage (100V) rating, lower frequency (2.5 GHz)
- **[PE1630](https://www.pasternack.com/search.aspx?q=PE1630)** (Pasternack): Wider bandwidth to 12 GHz, same current/voltage

**Selection Rationale:** Surface-mount bias tee covering entire 2-6 GHz band with 500 mA current rating sufficient for GaN LNA bias.

### 4. GaN/GaAs LNA Stage (per channel, 3 cascaded)

**Primary Choice:** [LVA-273PN+](https://www.minicircuits.com/WebStore/dashboard.html?model=LVA-273PN%2B) (Mini-Circuits)

**

[📄 Datasheet](https://www.minicircuits.com/WebStore/dashboard.html?model=LVA-273PN%2B)

| Spec | Value |
|---|---|
| frequency_range | 0.01 - 26.5 GHz |
| gain | 14 dB typ at 4 GHz |
| oip3 | +22 dBm typ |
| p1db | +10 dBm typ |
| noise_figure | 3.5 dB typ |
| supply_voltage | +5 V |
| current_draw | 75 mA typ |

**Alternatives:**
- **[TGA2525](https://www.qorvo.com/products/p/TGA2525)** (Qorvo): 2-18 GHz GaN MMIC with AGC, higher linearity but wider bandwidth than needed
- **[PMA2-123LNW+](https://www.minicircuits.com/WebStore/dashboard.html?model=PMA2-123LNW%2B)** (Mini-Circuits): Lower frequency (12 GHz max), lower noise figure (2.5 dB), smaller package

**Selection Rationale:** Broadband GaAs MMIC gain block covering 2-6 GHz with excellent linearity (+22 dBm OIP3) and moderate NF (3.5 dB). Three cascaded stages achieve ~42 dB gain; additional gain stage required for 50 dB target. Note: Part is GaAs; true GaN LNAs were not available from search in 2-6 GHz range. For pure GaN requirement, consider custom GaN MMIC or discrete GaN HEMT design.

### 5. Buck Step-Down Regulator (12V → 5V)

**Primary Choice:** [TPS62136RGXR](https://www.ti.com/sitesearch/en-us/docs/universalsearch.tsp?searchTerm=tps62136rgxr) (Texas Instruments)

**

[📄 Datasheet](https://www.ti.com/sitesearch/en-us/docs/universalsearch.tsp?searchTerm=tps62136rgxr)

| Spec | Value |
|---|---|
| input_voltage | 3-17 V |
| output_voltage | 5 V fixed |
| max_output_current | 4.0 A |
| switching_frequency | 1.2 MHz typ |
| efficiency | >90% at 12V in |
| package | VQFN-16 |

**Alternatives:**
- **[ACT4533AYH-T](https://duckduckgo.com/?q=ACT4533AYH-T%20Qorvo%20datasheet)** (Qorvo): Integrated step-down converter, smaller footprint but lower current (1.5A)
- **[BD8303MUV-E2](https://duckduckgo.com/?q=BD8303MUV-E2%20ROHM%20Semiconductor%20datasheet)** (ROHM Semiconductor): Lower input voltage (14V max), smaller package

**Selection Rationale:** 4A buck regulator with 17 V max input suitable for 12V rail. Provides 5V at 4A (20W) for LNA chains and bias circuits. High efficiency reduces thermal load.

### 6. Low-Noise LDO Regulator (5V → 3.3V)

**Primary Choice:** [MIC5209-3.3YM](https://duckduckgo.com/?q=MIC5209-3.3YM%20Microchip%20Technology%20datasheet) (Microchip Technology)

**

[📄 Datasheet](https://duckduckgo.com/?q=MIC5209-3.3YM%20Microchip%20Technology%20datasheet)

| Spec | Value |
|---|---|
| input_voltage | 2.3-16 V |
| output_voltage | 3.3 V fixed |
| max_output_current | 500 mA |
| noise_voltage | 80 µVrms typ |
| psrr | 75 dB at 1 kHz |
| package | SOT-223 |

**Alternatives:**
- **[TPS78533BQWDRBRQ1](https://www.ti.com/sitesearch/en-us/docs/universalsearch.tsp?searchTerm=tps78533bqwdrbrq1)** (Texas Instruments): Automotive grade, higher current (1A), better accuracy
- **[AP7361E-33FGE-7](https://duckduckgo.com/?q=AP7361E-33FGE-7%20Diodes%20Incorporated%20datasheet)** (Diodes Incorporated): Smaller U-DFN package, slightly higher noise

**Selection Rationale:** 500 mA low-noise LDO with 80 µVrms noise floor suitable for sensitive RF bias circuits. High PSRR (75 dB) rejects buck regulator switching noise.
