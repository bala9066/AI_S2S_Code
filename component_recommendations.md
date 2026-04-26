# Component Recommendations
## rx band

### 1. RF LNA — first-stage amplifier at the antenna input for each of the 4 channels (GaN technology preferred)

**Primary Choice:** [ZVA-183WA-S+](https://www.digikey.com/en/products/result?keywords=ZVA-183WA-S%2B) (Mini-Circuits)

*RF Amplifier Gain Block, 100 - 18000 MHz, 50 Ohm — used here as the wideband front-end amplifier (closest match to 18-40 GHz from distributor pool)*

[🔗 DigiKey](https://www.digikey.com/en/products/result?keywords=ZVA-183WA-S%2B)  [🔗 Mouser](https://www.mouser.in/ProductDetail/Mini-Circuits/ZVA-183WA-S%2b?qs=Imq1NPwxi74H20oSZuuyHw%3D%3D)

*Distributor data:* source: mouser

| Spec | Value |
|---|---|
| Frequency | 0.1-18 GHz |
| Gain | 22 dB typ |
| Noise_Figure | ~3.5 dB est |
| P1dB | +16 dBm typ |
| OIP3 | ~+26 dBm est |
| Package | SMT |
| Supply | 5V |

**Alternatives:**
- **[PMA2-123LNW+](https://www.digikey.com/en/products/result?keywords=PMA2-123LNW%2B)** (Mini-Circuits): Wider bandwidth to 12 GHz, lower NF (~2 dB), but lower gain (~15 dB) and lower P1dB
- **[QPL1000SR](https://www.digikey.com/en/products/result?keywords=QPL1000SR)** (Qorvo): GaN technology as specified, but limited to 8-11 GHz band — not suitable for 18-40 GHz without redesign

**Selection Rationale:** Only wideband SMT amplifier from pool covering up to 18 GHz. Design note: for the 18-40 GHz band, a 40+ GHz GaN LNA (e.g. Northrop Grumman ALH369 or custom MMIC) will be needed at final PDR.

### 2. RF1 Mixer — first downconverter from RF (18-32 GHz) to IF1 (~4 GHz) for each channel

**Primary Choice:** [CMD180C3](https://www.digikey.com/en/products/result?keywords=CMD180C3) (Qorvo)

*RF Mixer 18-32 GHz Double Balanced Mixer — covers the lower portion of the required RF band*

[🔗 DigiKey](https://www.digikey.com/en/products/result?keywords=CMD180C3)  [🔗 Mouser](https://www.mouser.in/ProductDetail/Qorvo/CMD180C3?qs=OlC7AqGiEDm30fkEsYyhSQ%3D%3D)

*Distributor data:* source: mouser

| Spec | Value |
|---|---|
| RF_Frequency | 18-32 GHz |
| IF_Frequency | DC-8 GHz |
| LO_Frequency | 14-36 GHz |
| Conversion_Loss | 8 dB typ |
| LO_Rdrive | +13 dBm |
| Isolation_LO_RF | 35 dB |
| Package | SMT |
| Supply | Passive |

**Alternatives:**
- **[CMD181](https://www.digikey.com/en/products/result?keywords=CMD181)** (Qorvo): Covers 26-45 GHz extending to 40 GHz, but NRND lifecycle status. Use for upper sub-band.

**Selection Rationale:** Only pool mixer covering the 18+ GHz band. CMD180C3 covers 18-32 GHz; CMD181 (26-45 GHz, NRND) covers the upper end. Two mixer types needed for full 18-40 GHz coverage. Selected CMD180C3 as primary for 18-32 GHz.

### 3. RF2 Mixer — second downconverter from IF1 (~4 GHz) to IF2 (~500 MHz) for each channel

**Primary Choice:** [MMIQ-0205HSM-2](https://www.digikey.com/en/products/result?keywords=MMIQ-0205HSM-2) (Marki Microwave)

*Miniaturized surface-mount multi-octave 1.75-5.0 GHz IQ mixer, double balanced*

[🔗 DigiKey](https://www.digikey.com/en/products/result?keywords=MMIQ-0205HSM-2)  [🔗 Mouser](https://www.mouser.in/ProductDetail/Marki-Microwave/MMIQ-0205HSM-2?qs=6avfeC6zeS7KHke%2FX0QKVw%3D%3D)

*Distributor data:* source: mouser

| Spec | Value |
|---|---|
| RF_Frequency | 1.75-5.0 GHz |
| LO_Frequency | 1.75-5.0 GHz |
| IF_Frequency | DC-3 GHz |
| Conversion_Loss | 8 dB typ |
| LO_Drive | +13 dBm |
| Image_Rejection | 25 dB typ |
| Package | SMT |

**Alternatives:**
- **[CMD177C3-EVB](https://www.digikey.com/en/products/result?keywords=CMD177C3-EVB)** (Qorvo): Double balanced mixer 6-14 GHz, wider band but no IQ capability — requires external image-reject filter

**Selection Rationale:** IQ mixer provides inherent image rejection for the 2nd IF conversion, critical for selectivity. Covers the IF1 frequency range around 4 GHz.

### 4. LO1 PLL Synthesizer — generates LO1 for first downconversion (14-36 GHz)

**Primary Choice:** [LMX2820RTCT](https://www.digikey.com/en/products/result?keywords=LMX2820RTCT) (Texas Instruments)

*22.6-GHz wideband RF synthesizer with integrated VCO and phase detector*

[🔗 DigiKey](https://www.digikey.com/en/products/result?keywords=LMX2820RTCT)  [🔗 Mouser](https://www.mouser.in/ProductDetail/Texas-Instruments/LMX2820RTCT?qs=eP2BKZSCXI4hpj09QD%252Biqg%3D%3D)

*Distributor data:* source: mouser

| Spec | Value |
|---|---|
| Output_Frequency | 0.01-22.6 GHz (with divider to 43 GHz) |
| Phase_Noise_10kHz | -120 dBc/Hz typ |
| Reference_Input | 10-500 MHz |
| Output_Power | +7 dBm typ |
| Interface | SPI |
| Package | WQFN-24 |
| Supply | 3.3V |

**Alternatives:**
- **[LMX2595RHAT](https://www.digikey.com/en/products/result?keywords=LMX2595RHAT)** (Texas Instruments): 20 GHz max output, slightly lower frequency coverage but proven reliability and lower cost

**Selection Rationale:** Highest-frequency PLL from pool. 22.6 GHz output frequency with output divider extends effective range to cover the LO1 band. Excellent phase noise performance.

### 5. LO2 PLL Synthesizer — generates LO2 for second downconversion (~3.5 GHz)

**Primary Choice:** [ADF4383BCCZ](https://www.digikey.com/en/products/result?keywords=ADF4383BCCZ) (Analog Devices)

*PLL/VCO, 656 MHz to 21 GHz — used for LO2 generation around 3.5 GHz*

[🔗 DigiKey](https://www.digikey.com/en/products/result?keywords=ADF4383BCCZ)  [🔗 Mouser](https://www.mouser.in/ProductDetail/Analog-Devices/ADF4383BCCZ?qs=yc9RBI4tIALV5w28VhCXEw%3D%3D)

*Distributor data:* source: mouser

| Spec | Value |
|---|---|
| Output_Frequency | 0.656-21 GHz |
| Phase_Noise | Ultra-low |
| Reference_Input | 10-500 MHz |
| Interface | SPI |
| Package | LCC-24 |
| Supply | 3.3V |

**Alternatives:**
- **[LMX2592RHAT](https://www.digikey.com/en/products/result?keywords=LMX2592RHAT)** (Texas Instruments): 9.8 GHz max, sufficient for LO2, lower cost

**Selection Rationale:** Wideband PLL covers the LO2 frequency range. From ADI, complementary to the TI LO1 synth, providing diverse supply chain.

### 6. Reference OCXO — 10 MHz oven-controlled crystal oscillator for LO phase noise floor

**Primary Choice:** [KOVTL10MDBFBCB](https://www.digikey.com/en/products/result?keywords=KOVTL10MDBFBCB) (KYOCERA AVX)

*14-pin DIP standard OCXO, 10 MHz, SC-cut crystal, ultra-low phase noise*

[🔗 DigiKey](https://www.digikey.com/en/products/result?keywords=KOVTL10MDBFBCB)  [🔗 Mouser](https://www.mouser.in/ProductDetail/KYOCERA-AVX/KOVTL10MDBFBCB?qs=17ckDYBRdemjGXBQrqYR4w%3D%3D)

*Distributor data:* source: mouser

| Spec | Value |
|---|---|
| Frequency | 10 MHz |
| Stability | 1e-10 (aging/day) |
| Phase_Noise_10kHz | -160 dBc/Hz typ |
| Supply | 5V or 12V |
| Package | 14-pin DIP |
| Operating_Temp | -40 to +85C |

**Alternatives:**
- **[OSJ7014-10.0M](https://www.digikey.com/en/products/result?keywords=OSJ7014-10.0M)** (Pletronics Inc.): 3.3V supply, SC-cut, slightly different phase noise profile

**Selection Rationale:** Lowest phase noise OCXO from pool. SC-cut crystal provides excellent short-term stability critical for radar coherent processing.

### 7. ADC — 16-bit digitiser for final IF per channel

**Primary Choice:** [LTC2107IUK#PBF](https://www.digikey.com/en/products/result?keywords=LTC2107IUK%23PBF) (Analog Devices)

*16-Bit, 210 Msps High Performance ADC with LVDS outputs*

[🔗 DigiKey](https://www.digikey.com/en/products/result?keywords=LTC2107IUK%23PBF)  [🔗 Mouser](https://www.mouser.in/ProductDetail/Analog-Devices/LTC2107IUKPBF?qs=hVkxg5c3xu%252BDBFU6Gh3TXg%3D%3D)

*Distributor data:* source: mouser

| Spec | Value |
|---|---|
| Resolution | 16-bit |
| Sample_Rate | 210 Msps |
| SNR | 76.5 dBFS typ |
| SFDR | 89 dBc typ |
| Input_Bandwidth | 700 MHz |
| Interface | LVDS |
| Supply | 1.8V core, 3.3V IO |
| Package | QFN-64 |

**Alternatives:**
- **[LTC2184IUP#PBF](https://www.digikey.com/en/products/result?keywords=LTC2184IUP%23PBF)** (Analog Devices): 16-bit dual ADC at 105 Msps — lower sample rate per channel but integrates 2 ADCs in one package, reducing BOM count

**Selection Rationale:** Only 16-bit high-speed ADC from pool with LVDS interface. 210 Msps is adequate for 500 MHz IBW in under-sampled or baseband IF configurations. SFDR of 89 dBc exceeds the 80 dB spec.

### 8. FPGA — digital signal processing, DDC, pulse compression, coherent integration for all 4 channels

**Primary Choice:** [XC7K355T-1FFG901I](https://www.digikey.com/en/products/result?keywords=XC7K355T-1FFG901I) (AMD)

*Kintex-7 FPGA, 355K logic cells, 300 I/O, 901-pin FCBGA, industrial temperature grade*

[🔗 DigiKey](https://www.digikey.com/en/products/detail/amd/XC7K355T-1FFG901I/3641726)

*Distributor data:* source: digikey

| Spec | Value |
|---|---|
| Logic_Cells | 355,360 |
| DSP_Slices | 840 |
| BRAM | 16,120 Kb |
| I_O | 300 |
| Package | FFG901 |
| Speed_Grade | -1 (industrial) |
| Supply | 1.0V core, 1.8V/2.5V/3.3V bank |

**Alternatives:**
- **[XC7K420T-1FFG901C](https://www.digikey.com/en/products/result?keywords=XC7K420T-1FFG901C)** (AMD): Larger device (420K LC, 1540 BRAM) for heavier processing, but commercial temp grade only

**Selection Rationale:** Kintex-7 as specified by user. -1 speed grade industrial temp version for -55 to 125C support. 355K logic cells and 840 DSP slices sufficient for 4-channel DDC and pulse compression.

### 9. IF Gain Block — inter-stage amplifier at IF1 (~4 GHz) between the two mixer stages for gain makeup

**Primary Choice:** [PMA2-123LNW+](https://www.digikey.com/en/products/result?keywords=PMA2-123LNW%2B) (Mini-Circuits)

*SMT MMIC Low Noise Linear Gain Block Amplifier, 0.01-12 GHz, 50 Ohm, 2x2 mm QFN*

[🔗 DigiKey](https://www.digikey.com/en/products/result?keywords=PMA2-123LNW%2B)  [🔗 Mouser](https://www.mouser.in/ProductDetail/Mini-Circuits/PMA2-123LNW%2b?qs=4dK74SdgGtwEBDo2%2FF2buA%3D%3D)

*Distributor data:* source: mouser

| Spec | Value |
|---|---|
| Frequency | 0.01-12 GHz |
| Gain | 22 dB typ at 4 GHz |
| Noise_Figure | ~2.5 dB est at 4 GHz |
| P1dB | ~+15 dBm est |
| OIP3 | ~+26 dBm est |
| Package | 2x2 mm QFN |
| Supply | 5V, 90 mA |

**Alternatives:**
- **[ZVA-183WA-S+](https://www.digikey.com/en/products/result?keywords=ZVA-183WA-S%2B)** (Mini-Circuits): Same as LNA — higher power but larger package, could simplify BOM by using same part

**Selection Rationale:** Wideband gain block covering IF1 at 4 GHz. Provides gain between the two mixer stages to overcome mixer conversion loss while maintaining good NF. SMT QFN package suitable for compact layout.

### 10. VGA / AGC — voltage variable attenuator for automatic gain control in the IF chain

**Primary Choice:** [TGL2767-SMEVB](https://www.digikey.com/en/products/result?keywords=TGL2767-SMEVB) (Qorvo)

*2-31 GHz Voltage Variable Attenuator evaluation board — used for AGC range control*

[🔗 DigiKey](https://www.digikey.com/en/products/result?keywords=TGL2767-SMEVB)  [🔗 Mouser](https://www.mouser.in/ProductDetail/Qorvo/TGL2767-SMEVB?qs=BJlw7L4Cy7%2FjhfzYRJ0vUg%3D%3D)

*Distributor data:* source: mouser

| Spec | Value |
|---|---|
| Frequency | 2-31 GHz |
| Attenuation_Range | 0-20 dB typ |
| Insertion_Loss | 2.5 dB typ |
| Control_Voltage | 0 to -3V |
| Package | Evaluation board (die available) |
| Supply | Passive (control voltage only) |

**Alternatives:**
- **[MAAT-010521-L1TR05](https://www.digikey.com/en/products/result?keywords=MAAT-010521-L1TR05)** (MACOM): 5-16 GHz range, SMT 3mm QFN package — better suited for IF placement but limited frequency range

**Selection Rationale:** Only VVA from pool covering millimeter-wave frequencies. Provides AGC range to keep ADC in linear region. Design note: for IF2 placement, a lower-frequency VVA may be more appropriate at PDR.

### 11. 5V LDO Regulator — low-noise 5V supply rail from +15V input for RF amplifiers and mixers

**Primary Choice:** [LM2940S-5.0/NOPB](https://www.digikey.com/en/products/result?keywords=LM2940S-5.0%2FNOPB) (Texas Instruments)

*1A Low-Dropout Regulator, 5.0V fixed output, designed for automotive/military applications*

[🔗 DigiKey](https://www.digikey.com/en/products/result?keywords=LM2940S-5.0%2FNOPB)  [🔗 Mouser](https://www.mouser.in/ProductDetail/Texas-Instruments/LM2940S-5.0-NOPB?qs=X1J7HmVL2ZGiLtaPLl7V2Q%3D%3D)

*Distributor data:* source: mouser

| Spec | Value |
|---|---|
| Output_Voltage | 5.0V fixed |
| Max_Output_Current | 1A |
| Dropout_Voltage | 0.5V typ at 1A |
| PSRR | 72 dB at 120 Hz |
| Noise | ~100 uV rms |
| Package | TO-263 (SMD) |
| Operating_Temp | -40 to 125C |

**Alternatives:**
- **[ZLDO1117QK50TC](https://www.digikey.com/en/products/result?keywords=ZLDO1117QK50TC)** (Diodes Incorporated): Lower cost, 800 mA output, automotive qualified — may need paralleling for higher current

**Selection Rationale:** Robust 1A LDO with good PSRR for RF supply rails. LM2940 series is widely used in military applications. Low noise critical for RF amplifier supply decoupling.

### 12. 3.3V LDO Regulator — 3.3V digital supply rail for FPGA bank I/O, PLLs, and ADC digital I/O

**Primary Choice:** [MCP1826S-5002E/DBVAO](https://www.digikey.com/en/products/result?keywords=MCP1826S-5002E%2FDBVAO) (Microchip Technology)

*1.0A Low Voltage Low Quiescent Current LDO Regulator, 5.0V input to 3.3V output capable*

[🔗 DigiKey](https://www.digikey.com/en/products/result?keywords=MCP1826S-5002E%2FDBVAO)  [🔗 Mouser](https://www.mouser.in/ProductDetail/Microchip-Technology/MCP1826S-5002E-DBVAO?qs=5aG0NVq1C4zVYXmrNt5abA%3D%3D)

*Distributor data:* source: mouser

| Spec | Value |
|---|---|
| Output_Voltage | 3.3V (adjustable) |
| Max_Output_Current | 1A |
| Dropout_Voltage | 210 mV typ |
| PSRR | 70 dB at 1 kHz |
| Noise | 50 uV rms typ |
| Package | SOT-223 |
| Supply | Up to 6V input |

**Alternatives:**
- **[MCP1726-ADJE/MFVAO](https://www.digikey.com/en/products/result?keywords=MCP1726-ADJE%2FMFVAO)** (Microchip Technology): Similar specs, 1A, adjustable, different package (DFN-8) — pin-compatible alternative

**Selection Rationale:** 1A LDO with very low noise for sensitive digital rails. Adjustable output can be set to 3.3V via external resistor divider.
