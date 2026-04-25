# Component Recommendations
## hjjg

### 1. Front-end protection limiter — protects LNA from high-power RF pulses up to +40 dBm

**Primary Choice:** [PE8022](https://www.digikey.com/en/products/result?keywords=PE8022) (Pasternack)

*High Power Limiter, SMA, 100W Peak Power, 20 ns Recovery, 18 dBm Flat Leakage, 2 GHz to 18 GHz*

[🔗 DigiKey](https://www.digikey.com/en/products/result?keywords=PE8022)  [🔗 Mouser](https://www.mouser.in/ProductDetail/Pasternack/PE8022?qs=3GbUB62Nf7erryDFrSN7Rw%3D%3D)

*Distributor data:* source: mouser

| Spec | Value |
|---|---|
| frequency | 2-18 GHz |
| flat_leakage | 18 dBm |
| recovery_time | 20 ns |
| insertion_loss | 0.5 dB typ |
| peak_power | 100 W |

**Alternatives:**
- **[PE8024](https://www.digikey.com/en/products/result?keywords=PE8024)** (Pasternack): 6-18 GHz range — does not cover 2-6 GHz band; otherwise identical

**Selection Rationale:** Covers full 2-6 GHz band with margin, provides 100W peak power handling, 20ns recovery suitable for radar pulses

### 2. Low-noise amplifier — first active stage after preselector, sets system noise figure

**Primary Choice:** [GRF2074](https://www.digikey.com/en/products/result?keywords=GRF2074) (Guerrilla RF)

*Ultra Low Noise Amplifier, Infrastructure LNA, 1.0 - 6.0 GHz, GaAs pHEMT*

[🔗 DigiKey](https://www.digikey.com/en/products/result?keywords=GRF2074)  [🔗 Mouser](https://www.mouser.in/ProductDetail/Guerrilla-RF/GRF2074?qs=hWgE7mdIu5RduliPAes1Xg%3D%3D)

*Distributor data:* source: mouser

| Spec | Value |
|---|---|
| frequency | 1.0-6.0 GHz |
| gain | 20 dB |
| noise_figure | 0.8 dB |
| p1db | +20 dBm |
| oip3 | +30 dBm |
| technology | GaAs pHEMT |

**Alternatives:**
- **[GRF2074W](https://www.digikey.com/en/products/result?keywords=GRF2074W)** (Guerrilla RF): AEC-Q100 automotive qualified version — same RF performance, higher cost

**Selection Rationale:** Covers 2-6 GHz exactly, NF 0.8 dB supports 5 dB system NF budget, GaAs pHEMT technology as specified, high OIP3 +30 dBm supports linearity requirements

### 3. 1st downconverter mixer — converts 2-6 GHz RF to 1300 MHz IF1

**Primary Choice:** [MCA1-42+](https://www.digikey.com/en/products/result?keywords=MCA1-42%2B) (Mini-Circuits)

*Level 7 SMT Double Balanced Mixer, RF/LO Freq 1000 - 4200 MHz*

[🔗 DigiKey](https://www.digikey.com/en/products/result?keywords=MCA1-42%2B)  [🔗 Mouser](https://www.mouser.in/ProductDetail/Mini-Circuits/MCA1-42%2b?qs=ZcfC38r4Pots4owO9VsMyQ%3D%3D)

*Distributor data:* source: mouser

| Spec | Value |
|---|---|
| rf_range | 1-4.2 GHz |
| lo_range | 1-4.2 GHz |
| if_range | DC-1500 MHz |
| conversion_loss | 7.0 dB typ |
| lo_drive | +13 dBm |
| p1db | +13 dBm |

**Alternatives:**
- **[RMS-30+](https://www.digikey.com/en/products/result?keywords=RMS-30%2B)** (Mini-Circuits): 200-3000 MHz range — limited upper frequency coverage

**Selection Rationale:** Covers lower portion of 2-6 GHz (1-4.2 GHz) for first downconversion; level 7 provides high IIP3 for strong interferer environment; SMT package

### 4. 2nd downconverter mixer — converts 1300 MHz IF1 to 200 MHz IF2

**Primary Choice:** [RMS-2+](https://www.digikey.com/en/products/result?keywords=RMS-2%2B) (Mini-Circuits)

*Level 7 SMT Double Balanced Mixer, RF/LO Freq 5 - 1000 MHz*

[🔗 DigiKey](https://www.digikey.com/en/products/result?keywords=RMS-2%2B)  [🔗 Mouser](https://www.mouser.in/ProductDetail/Mini-Circuits/RMS-2%2b?qs=ZcfC38r4Pov%2Fnv%252B7ayJXPw%3D%3D)

*Distributor data:* source: mouser

| Spec | Value |
|---|---|
| rf_range | 5-1000 MHz |
| lo_range | 5-1000 MHz |
| if_range | DC-500 MHz |
| conversion_loss | 6.5 dB typ |
| lo_drive | +13 dBm |

**Selection Rationale:** Suitable for 2nd IF conversion from 1300 MHz to 200 MHz region; level 7 for good linearity; wide IF bandwidth supports 100 MHz IBW

### 5. IF driver amplifier — provides gain and output drive to ADC in the 2nd IF chain

**Primary Choice:** [HMC788ALP2E](https://www.digikey.com/en/products/result?keywords=HMC788ALP2E) (Analog Devices)

*10 GHz gain block, Linear Drive/Gain Block, DC - 10 GHz*

[🔗 DigiKey](https://www.digikey.com/en/products/result?keywords=HMC788ALP2E)  [🔗 Mouser](https://www.mouser.in/ProductDetail/Analog-Devices/HMC788ALP2E?qs=664zcAxDQ0ks2b5CSVKMow%3D%3D)

*Distributor data:* source: mouser

| Spec | Value |
|---|---|
| frequency | DC-10 GHz |
| gain | 14 dB |
| p1db | +19 dBm |
| oip3 | +29 dBm |
| noise_figure | 5 dB |

**Alternatives:**
- **[GRF2040](https://www.digikey.com/en/products/result?keywords=GRF2040)** (Guerrilla RF): Lower gain (10.2 dB) and P1dB — used as buffer amp, not driver

**Selection Rationale:** Wideband gain block covers 200 MHz IF with excellent P1dB (+19) and OIP3 (+29) meeting +10 dBm output P1dB requirement; used in multiple IF stages

### 6. Linear gain block / buffer amp — moderate gain stage for IF chain signal conditioning

**Primary Choice:** [GRF2040](https://www.digikey.com/en/products/result?keywords=GRF2040) (Guerrilla RF)

*Linear Gain Block w/Bypass, 10.2 dB Gain; 50 MHz - 5 GHz*

[🔗 DigiKey](https://www.digikey.com/en/products/result?keywords=GRF2040)  [🔗 Mouser](https://www.mouser.in/ProductDetail/Guerrilla-RF/GRF2040?qs=mELouGlnn3fe3HZtpmCfiQ%3D%3D)

*Distributor data:* source: mouser

| Spec | Value |
|---|---|
| frequency | 50 MHz - 5 GHz |
| gain | 10.2 dB |
| p1db | +19 dBm |
| oip3 | +29 dBm |
| noise_figure | 4 dB |

**Selection Rationale:** Moderate gain block for buffer/trim stage between IF stages; bypass capability adds flexibility; good linearity for IF chain

### 7. Wideband RF power splitter — 2-way LO distribution to both receiver channels

**Primary Choice:** [EP2K1+](https://www.digikey.com/en/products/result?keywords=EP2K1%2B) (Mini-Circuits)

*MMIC Power Splitter/Combiner, 50 kHz to 26 GHz*

[🔗 DigiKey](https://www.digikey.com/en/products/result?keywords=EP2K1%2B)  [🔗 Mouser](https://www.mouser.in/ProductDetail/Mini-Circuits/EP2K1%2b?qs=xZ%2FP%252Ba9zWqYi5aYRkiB4Bg%3D%3D)

*Distributor data:* source: mouser

| Spec | Value |
|---|---|
| frequency | 50 kHz - 26 GHz |
| insertion_loss | 1.2 dB typ |
| isolation | 20 dB |
| amplitude_balance | 0.2 dB |
| phase_balance | 2 deg |

**Alternatives:**
- **[EP2K+](https://www.digikey.com/en/products/result?keywords=EP2K%2B)** (Mini-Circuits): Slightly higher insertion loss, same frequency range

**Selection Rationale:** Ultra-wideband covers all LO frequencies (1.1-7.3 GHz); excellent amplitude/phase balance critical for dual-channel phase coherence

### 8. PLL frequency synthesizer — generates tunable LO1 (3.3-7.3 GHz) and LO2 (1.1 GHz) from 10 MHz reference

**Primary Choice:** [ADF4106BRUZ-RL](https://www.digikey.com/en/products/result?keywords=ADF4106BRUZ-RL) (Analog Devices)

*6 GHz Integer-N PLL Synthesizer with reference doubler*

[🔗 DigiKey](https://www.digikey.com/en/products/result?keywords=ADF4106BRUZ-RL)  [🔗 Mouser](https://www.mouser.in/ProductDetail/Analog-Devices/ADF4106BRUZ-RL?qs=BpaRKvA4VqFjnJM8Lewaow%3D%3D)

*Distributor data:* source: mouser

| Spec | Value |
|---|---|
| rf_frequency | DC-6 GHz |
| phase_detector_freq | 104 MHz |
| phase_noise_floor | -153 dBc/Hz |
| reference_doubler | Yes |
| supply | 2.7-5.5V |

**Alternatives:**
- **[ADF4007BCPZ](https://www.digikey.com/en/products/result?keywords=ADF4007BCPZ)** (Analog Devices): 7.5 GHz capable but no reference doubler — slightly worse close-in phase noise

**Selection Rationale:** Covers LO2 (1.1 GHz) directly; LO1 uses external VCO + prescaler; integer-N architecture provides lowest phase noise for radar; reference doubler improves phase noise by 6 dB

### 9. VCO for LO1 — generates 4-8 GHz local oscillator signal for 1st downconversion

**Primary Choice:** [HMC586LC4BTR](https://www.digikey.com/en/products/result?keywords=HMC586LC4BTR) (Analog Devices)

*Wideband VCO SMT with Buffer Amp, 4 - 8 GHz*

[🔗 DigiKey](https://www.digikey.com/en/products/result?keywords=HMC586LC4BTR)  [🔗 Mouser](https://www.mouser.in/ProductDetail/Analog-Devices/HMC586LC4BTR?qs=pceeu5JH%2FH9tZO05xyl%252Bbg%3D%3D)

*Distributor data:* source: mouser

| Spec | Value |
|---|---|
| frequency | 4-8 GHz |
| output_power | +14 dBm |
| tuning_voltage | 1-18V |
| phase_noise_10kHz | -90 dBc/Hz |
| supply | 5V |

**Selection Rationale:** Covers 4-8 GHz range needed for LO1 (3.3-7.3 GHz output after x2 prescale); on-chip buffer amp; SMT package suitable for military environment

### 10. OCXO reference oscillator — provides ultra-stable 10 MHz frequency reference for PLL and system timing

**Primary Choice:** [OSJ7014-10.0M](https://www.digikey.com/en/products/result?keywords=OSJ7014-10.0M) (Pletronics Inc.)

*Ovenized Quartz Crystal High Precision Wave Generator, 3.3V, 10.0 MHz, SC-cut crystal*

[🔗 DigiKey](https://www.digikey.com/en/products/result?keywords=OSJ7014-10.0M)  [🔗 Mouser](https://www.mouser.in/ProductDetail/Pletronics-Inc/OSJ7014-10.0M?qs=9vOqFld9vZVJQ3Kw6dwfhQ%3D%3D)

*Distributor data:* source: mouser

| Spec | Value |
|---|---|
| frequency | 10 MHz |
| stability | 1e-10 (short term) |
| phase_noise_10kHz | -160 dBc/Hz |
| supply | 3.3V |
| crystal_cut | SC-cut |

**Alternatives:**
- **[KOVTL10MDBFBCB](https://www.digikey.com/en/products/result?keywords=KOVTL10MDBFBCB)** (KYOCERA AVX): 14-pin DIP — larger package, similar performance

**Selection Rationale:** SC-cut crystal provides best short-term stability for coherent radar; low phase noise supports -120 dBc/Hz system LO requirement; 3.3V supply compatible with PLL rail

### 11. 14-bit dual-channel ADC — digitises both IF2 channels simultaneously with LVDS output

**Primary Choice:** [AD9643BCPZ-170](https://www.digikey.com/en/products/result?keywords=AD9643BCPZ-170) (Analog Devices)

*14-Bit 170 MSPS Dual ADC with LVDS outputs*

[🔗 DigiKey](https://www.digikey.com/en/products/result?keywords=AD9643BCPZ-170)  [🔗 Mouser](https://www.mouser.in/ProductDetail/Analog-Devices/AD9643BCPZ-170?qs=BpaRKvA4VqFjRsuQ8NPU7Q%3D%3D)

*Distributor data:* source: mouser

| Spec | Value |
|---|---|
| resolution | 14-bit |
| sample_rate | 170 MSPS |
| channels | 2 (dual) |
| snr | 73 dBFS |
| sfdr | 85 dBc |
| interface | LVDS |
| supply | 1.8V |

**Alternatives:**
- **[AD9648BCPZ-125](https://www.digikey.com/en/products/result?keywords=AD9648BCPZ-125)** (Analog Devices): 125 MSPS — lower sample rate, still adequate for 100 MHz IBW

**Selection Rationale:** Dual-channel ADC serves both receiver channels in one IC for inherent channel matching; 170 MSPS oversamples 100 MHz IBW at 200 MHz IF; 85 dBc SFDR meets 80 dB SFDR requirement

### 12. Digital processing FPGA — performs radar DSP, pulse compression, CFAR detection, and LVDS data output

**Primary Choice:** [PFP-KX7_PLUS-310LC](https://www.digikey.com/en/products/result?keywords=PFP-KX7_PLUS-310LC) (Techway)

*PCIe FPGA Platform with Kintex-7 FPGA, PCIe x4 Gen2, FMC+ site*

[🔗 DigiKey](https://www.digikey.com/en/products/result?keywords=PFP-KX7_PLUS-310LC)  [🔗 Mouser](https://www.mouser.in/ProductDetail/Techway/PFP-KX7_PLUS-310LC?qs=HoCaDK9Nz5ea4a7Py6ARXg%3D%3D)

*Distributor data:* source: mouser

| Spec | Value |
|---|---|
| fpga | Xilinx Kintex-7 |
| interface | FMC+ / PCIe x4 Gen2 |
| adc_inputs | LVDS via FMC+ |
| logic_cells | 326K (XC7K325T) |

**Alternatives:**
- **[SKU89](https://www.digikey.com/en/products/result?keywords=SKU89)** (Zipcores): FMC-DSP mezzanine with 2xADC 2xDAC 500MSPS — smaller form factor

**Selection Rationale:** Complete Kintex-7 platform with FMC+ site for direct ADC interface; PCIe Gen2 x4 for data offload; supports dual-channel LVDS input from AD9643

### 13. Low-noise LDO regulator — provides clean supply rails for LNAs, mixers, PLLs, and ADCs

**Primary Choice:** [MIC5209-3.3YM](https://www.digikey.com/en/products/result?keywords=MIC5209-3.3YM) (Microchip Technology)

*500mA 1% Low Noise LDO Voltage Regulator, 3.3V fixed output*

[🔗 DigiKey](https://www.digikey.com/en/products/result?keywords=MIC5209-3.3YM)  [🔗 Mouser](https://www.mouser.in/ProductDetail/Microchip-Technology/MIC5209-3.3YM?qs=kh6iOki%2FeLG9S397j%2Fg9Ig%3D%3D)

*Distributor data:* source: mouser

| Spec | Value |
|---|---|
| output_voltage | 3.3V fixed |
| max_current | 500 mA |
| noise | 260 nV/sqrt(Hz) |
| psrr | 70 dB @ 1kHz |
| dropout | 450 mV typ |

**Alternatives:**
- **[MIC5209-3.3YU](https://www.digikey.com/en/products/result?keywords=MIC5209-3.3YU)** (Microchip Technology): Same specs, different package (SOT-89 vs SOT-223)

**Selection Rationale:** Low-noise LDO for RF/analog supply regulation; 500 mA sufficient for individual stage rails; high PSRR prevents supply noise from degrading NF; used per-stage with LC/ferrite decoupling
