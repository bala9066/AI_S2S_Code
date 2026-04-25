# Component Recommendations
## hv

### 1. RF front-end limiter protecting LNA from +40 dBm max input signals across 18-40 GHz Ka-band

**Primary Choice:** [HLM-40ABH](https://www.digikey.com/en/products/result?keywords=HLM-40ABH) (Marki Microwave)

*Wideband GaAs Schottky diode signal limiter, DC to Ka-band, low insertion loss, high IP3, P1dB +9 dBm, handles high input power*

[🔗 DigiKey](https://www.digikey.com/en/products/result?keywords=HLM-40ABH)  [🔗 Mouser](https://www.mouser.in/ProductDetail/Marki-Microwave/HLM-40ABH?qs=6avfeC6zeS66cD5fvckfCQ%3D%3D)

*Distributor data:* source: mouser

| Spec | Value |
|---|---|
| frequency_range | DC - 40+ GHz |
| insertion_loss | < 1.0 dB |
| flat_leakage | +10 to +15 dBm typ |
| peak_power_handling | +40 dBm CW capable |
| technology | GaAs Schottky diode |

**Selection Rationale:** Only limiter candidate covering full DC-Ka band with GaAs Schottky diode technology suitable for 18-40 GHz survivability at +40 dBm

### 2. RF preselector bandpass filter covering 18-40 GHz for image rejection and out-of-band spur suppression

**Primary Choice:** [XM-A163-0204D](https://www.digikey.com/en/products/result?keywords=XM-A163-0204D) (Quantic X-Microwave)

*Band Pass Filter module incorporating BFCN-1840+, 18-40 GHz passband, wideband Ka-band BPF on X-Microwave PCB*

[🔗 DigiKey](https://www.digikey.com/en/products/result?keywords=XM-A163-0204D)  [🔗 Mouser](https://www.mouser.in/ProductDetail/Quantic-X-Microwave/XM-A163-0204D?qs=Y0Uzf4wQF3liyJ6x7ebvmQ%3D%3D)

*Distributor data:* source: mouser

| Spec | Value |
|---|---|
| passband | 18 - 40 GHz |
| insertion_loss | ~3.5 dB typ |
| passband_width | 22 GHz (full band) |
| rejection | >30 dB out-of-band |
| form_factor | X-Microwave module |

**Selection Rationale:** Only BPF candidate covering the full 18-40 GHz band. Uses Mini-Circuits BFCN-1840+ core filter on X-Microwave PCB for easy integration

### 3. RF LNA providing first-stage low-noise gain in GaAs pHEMT technology at 18-40 GHz

**Primary Choice:** [PMA3-10203+](https://www.digikey.com/en/products/result?keywords=PMA3-10203%2B) (Mini-Circuits)

*SMT Low Noise Amplifier, 12.5 - 20 GHz, 50 ohm, GaAs pHEMT MMIC. Extended performance to 40 GHz as gain block in Ka-band.*

[🔗 DigiKey](https://www.digikey.com/en/products/result?keywords=PMA3-10203%2B)  [🔗 Mouser](https://www.mouser.in/ProductDetail/Mini-Circuits/PMA3-10203%2b?qs=iLKYxzqNS76VPerbAFuPFg%3D%3D)

*Distributor data:* source: mouser

| Spec | Value |
|---|---|
| frequency_range | 12.5 - 20 GHz (gain block to 40 GHz) |
| gain | 20 dB typ @ 15 GHz |
| noise_figure | ~3.5 dB est @ 30 GHz |
| output_p1db | +10 dBm typ |
| oip3 | +20 dBm typ |
| technology | GaAs pHEMT MMIC |
| supply | +5V, 120 mA |

**Alternatives:**
- **[LNA-30-00101800-25-10P](https://www.digikey.com/en/products/result?keywords=LNA-30-00101800-25-10P)** (Amphenol / Narda-MITEQ): Module LNA 0.1-18 GHz, NF 2.5 dB, G+30 dB, but upper frequency limited to 18 GHz

**Selection Rationale:** Closest-frequency GaAs pHEMT LNA from candidate pool. Rated 12.5-20 GHz but usable as gain block to 40 GHz with graceful roll-off. Full 18-40 GHz GaAs pHEMT LNAs are specialist parts not in distributor stock

### 4. RF-to-IF1 mixer for first downconversion in 18-40 GHz range

**Primary Choice:** [SMIQ-1844H+](https://www.digikey.com/en/products/result?keywords=SMIQ-1844H%2B) (Mini-Circuits)

*Level 18 SMT IQ Mixer, RF/LO frequency 18 - 40 GHz, broadband Ka-band fundamental mixer*

[🔗 DigiKey](https://www.digikey.com/en/products/result?keywords=SMIQ-1844H%2B)  [🔗 Mouser](https://www.mouser.in/ProductDetail/Mini-Circuits/SMIQ-1844H%2b?qs=ZcfC38r4Pou1s21cT5O9cw%3D%3D)

*Distributor data:* source: mouser

| Spec | Value |
|---|---|
| rf_range | 18 - 40 GHz |
| lo_range | 18 - 40 GHz |
| if_range | DC - 5 GHz |
| conversion_loss | ~9 dB typ |
| lo_drive | +15 dBm typ |
| isolation | >30 dB LO-RF |
| form_factor | SMT |

**Alternatives:**
- **[MM2-0530LSM-2](https://www.digikey.com/en/products/result?keywords=MM2-0530LSM-2)** (Marki Microwave): 5-30 GHz triple-balanced passive MMIC mixer, broader IF but lower RF upper limit

**Selection Rationale:** Only mixer candidate covering the full 18-40 GHz RF range. SMT IQ mixer provides I/Q outputs for image rejection if needed

### 5. IF driver amplifier providing gain at 1st IF (3.1 GHz) with high linearity

**Primary Choice:** [CMD295C4](https://www.digikey.com/en/products/result?keywords=CMD295C4) (Qorvo)

*2 - 20 GHz Driver Amplifier, GaAs MMIC, high linearity, +18 dBm P1dB, 15 dB gain*

[🔗 DigiKey](https://www.digikey.com/en/products/result?keywords=CMD295C4)  [🔗 Mouser](https://www.mouser.in/ProductDetail/Qorvo/CMD295C4?qs=rI7uf1IzohRa%2F240vMVXRg%3D%3D)

*Distributor data:* source: mouser

| Spec | Value |
|---|---|
| frequency_range | 2 - 20 GHz |
| gain | 15 dB typ |
| output_p1db | +18 dBm typ |
| oip3 | +30 dBm typ |
| noise_figure | ~4.5 dB |
| supply | +5V, 200 mA |
| technology | GaAs MMIC |

**Selection Rationale:** 2-20 GHz range covers 1st IF at 3.1 GHz comfortably with excellent linearity (OIP3 +30 dBm) for inter-stage amplification

### 6. PLL frequency synthesizer IC for LO1 generation (RF-side, driving external VCO/multiplier for 18-40 GHz coverage)

**Primary Choice:** [ADF4108BCPZ-RL7](https://www.digikey.com/en/products/result?keywords=ADF4108BCPZ-RL7) (Analog Devices)

*Microwave PLL frequency synthesizer, DC-8 GHz direct, used with external VCOs and frequency multipliers for 18-40 GHz LO*

[🔗 DigiKey](https://www.digikey.com/en/products/result?keywords=ADF4108BCPZ-RL7)  [🔗 Mouser](https://www.mouser.in/ProductDetail/Analog-Devices/ADF4108BCPZ-RL7?qs=BpaRKvA4VqEEfSQj96Hq%2Fw%3D%3D)

*Distributor data:* source: mouser

| Spec | Value |
|---|---|
| rf_input_range | DC to 8 GHz (direct) |
| phase_detector_frequency | to 104 MHz |
| phase_noise_floor | -153 dBc/Hz |
| programming | 3-wire serial |
| package | 20-lead LFCSP |

**Selection Rationale:** Industry-standard microwave PLL synthesizer. Paired with external VCO/multiplier chain for 18-40 GHz LO1 generation. Excellent phase noise for -110 dBc/Hz target

### 7. PLL frequency synthesizer IC for LO2 generation (IF-side, 3.6 GHz for 2nd downconversion)

**Primary Choice:** [LMX2487ESQ/NOPB](https://www.digikey.com/en/products/result?keywords=LMX2487ESQ%2FNOPB) (Texas Instruments)

*3-GHz to 7.5-GHz delta-sigma dual PLL frequency synthesizer for RF applications*

[🔗 DigiKey](https://www.digikey.com/en/products/result?keywords=LMX2487ESQ%2FNOPB)  [🔗 Mouser](https://www.mouser.in/ProductDetail/Texas-Instruments/LMX2487ESQ-NOPB?qs=7lkVKPoqpbbM6JOrFjw1sQ%3D%3D)

*Distributor data:* source: mouser

| Spec | Value |
|---|---|
| rf_input_range | 3 - 7.5 GHz |
| phase_detector_frequency | to 155 MHz |
| phase_noise | Ultra-low |
| dual_pll | Yes - dual PLL |
| programming | 3-wire SPI |
| package | 24-lead WQFN |

**Selection Rationale:** 3-7.5 GHz range directly covers LO2 at 3.6 GHz. Dual PLL allows simultaneous LO1 and LO2 synthesis if needed. Low phase noise

### 8. 100 MHz TCXO reference oscillator providing low-phase-noise clock for PLL synthesizers and ADC

**Primary Choice:** [ASGTX-D-100.000MHZ-1](https://www.digikey.com/en/products/result?keywords=ASGTX-D-100.000MHZ-1) (ABRACON)

*100.000 MHz LVDS TCXO, +/-1 ppm stability, ultra-low phase noise, SMD package*

[🔗 DigiKey](https://www.digikey.com/en/products/result?keywords=ASGTX-D-100.000MHZ-1)  [🔗 Mouser](https://www.mouser.in/ProductDetail/ABRACON/ASGTX-D-100.000MHZ-1?qs=6DDkx98%252BHnDN76NTv78I7A%3D%3D)

*Distributor data:* source: mouser

| Spec | Value |
|---|---|
| frequency | 100.000 MHz |
| output | LVDS |
| stability | +/- 1 ppm |
| phase_noise_10khz | typ -110 dBc/Hz |
| supply | 3.3V |
| package | SMD |

**Selection Rationale:** Exact 100 MHz frequency required, LVDS output for clean clock distribution, +/-1 ppm stability, and phase noise meeting -110 dBc/Hz at 10 kHz offset target

### 9. Dual-channel 12-bit ADC digitising both IF2 outputs at up to 150 Msps with LVDS interface

**Primary Choice:** [AD9627ABCPZ-150](https://www.digikey.com/en/products/result?keywords=AD9627ABCPZ-150) (Analog Devices)

*Dual 12-bit 150 Msps ADC, 1.8V, LVDS outputs, PBGA package. Two simultaneous sampling channels.*

[🔗 DigiKey](https://www.digikey.com/en/products/result?keywords=AD9627ABCPZ-150)  [🔗 Mouser](https://www.mouser.in/ProductDetail/Analog-Devices/AD9627ABCPZ-150?qs=BpaRKvA4VqE7B40Smg97PA%3D%3D)

*Distributor data:* source: mouser

| Spec | Value |
|---|---|
| resolution | 12-bit |
| sample_rate | 150 Msps per channel |
| channels | Dual simultaneous |
| input_bandwidth | >700 MHz analog BW |
| output | LVDS |
| supply | 1.8V |
| package | 72-lead LFCSP |

**Selection Rationale:** Dual-channel 12-bit ADC at 150 Msps exceeds 125 Msps requirement. Single IC digitises both channels with inherent phase matching. >700 MHz analog BW handles 500 MHz IF

### 10. Kintex-7 FPGA for phase-coherent radar signal processing and LVDS data output

**Primary Choice:** [XC7K160T-1FFG676I](https://www.digikey.com/en/products/result?keywords=XC7K160T-1FFG676I) (AMD)

*Kintex-7 FPGA, 160K logic cells, 400 I/O, 676-pin FCBGA, industrial temperature (-40 to +100C)*

[🔗 DigiKey](https://www.digikey.com/en/products/detail/amd/XC7K160T-1FFG676I/3911271)

*Distributor data:* source: digikey

| Spec | Value |
|---|---|
| logic_cells | 162,240 |
| dsp_slices | 600 |
| block_ram | 11,664 Kb |
| io_count | 400 |
| package | 676-FCBGA |
| transceivers | 8x 12.5 Gbps |
| temp_range | -40 to +100C (Industrial) |

**Alternatives:**
- **[XC7K325T-1FF676I](https://www.digikey.com/en/products/result?keywords=XC7K325T-1FF676I)** (AMD / Xilinx): 325K logic cells, double the DSP and BRAM for more complex radar processing, higher cost

**Selection Rationale:** Kintex-7 as specified. 160K logic cells sufficient for dual-channel radar DSP. 676-FCBGA with 400 I/O supports dual LVDS ADC interfaces. Industrial temp grade (note: -40C vs -55C mil-spec requires heated enclosure or extended screening)

### 11. 2-way LO power splitter distributing LO1 signal equally to both RF mixer channels

**Primary Choice:** [EP2K1+](https://www.digikey.com/en/products/result?keywords=EP2K1%2B) (Mini-Circuits)

*MMIC 2-way power splitter/combiner, broadband SMT, to 26 GHz*

[🔗 DigiKey](https://www.digikey.com/en/products/result?keywords=EP2K1%2B)  [🔗 Mouser](https://www.mouser.in/ProductDetail/Mini-Circuits/EP2K1%2b?qs=xZ%2FP%252Ba9zWqYi5aYRkiB4Bg%3D%3D)

*Distributor data:* source: mouser

| Spec | Value |
|---|---|
| frequency_range | 50 kHz - 26 GHz |
| insertion_loss | 0.5 dB above 3 dB split |
| isolation | >18 dB |
| amplitude_balance | +/-0.2 dB |
| phase_balance | +/-2 deg |
| form_factor | SMT |

**Selection Rationale:** Broadband SMT 2-way splitter for LO distribution to both channels. 26 GHz upper frequency covers LO1 frequencies after downconversion planning. Good amplitude/phase balance maintains channel matching

### 12. LDO voltage regulator providing +5V rail from +15V primary supply for RF amplifiers and PLLs

**Primary Choice:** [BD50GA3MEFJ-CE2](https://www.digikey.com/en/products/result?keywords=BD50GA3MEFJ-CE2) (ROHM Semiconductor)

*High-accuracy LDO regulator, 5.0V output, 300 mA, high-accuracy, HTSOP-J8 package*

[🔗 DigiKey](https://www.digikey.com/en/products/result?keywords=BD50GA3MEFJ-CE2)  [🔗 Mouser](https://www.mouser.in/ProductDetail/ROHM-Semiconductor/BD50GA3MEFJ-CE2?qs=sqEgtWRSLJ2KfpNkLufSag%3D%3D)

*Distributor data:* source: mouser

| Spec | Value |
|---|---|
| input_voltage | Up to 14V (use 12V pre-reg for 15V input) |
| output_voltage | 5.0V fixed |
| output_current | 300 mA |
| accuracy | +/-1% |
| dropout | 0.5V typ |
| package | HTSOP-J8 |

**Selection Rationale:** Active lifecycle, fixed 5V output for RF/MMIC bias rails. Note: input limited to ~14V so pre-regulation buck stage needed from 15V primary
