# Hardware Requirements
## rx band

## 1. Project Summary

4-channel 18-40 GHz Double-IF Superheterodyne Radar Receiver System. Each of the 4 antenna channels includes a GaN LNA front-end, dual downconversion stages, VGA/AGC gain control, and 16-bit 210 Msps digitisation feeding a Xilinx Kintex-7 FPGA. Designed for military-grade operation (-55 to 125°C, MIL-STD-810, IP68) with >60 dB cascaded gain, 6-10 dB system NF, +20 dBm IIP3, and phase-coherent processing for radar pulse analysis.

## 2. Design Parameters

| Parameter | Value |
|---|---|
| Frequency Range Ghz | 18-40 |
| Instantaneous Bandwidth Mhz | 100-500 |
| Noise Figure Db | 8 |
| System Gain Db | 65 |
| Iip3 Dbm | 20 |
| Output Power Dbm | 10 |
| Mds Dbm | -81.2 |
| Supply Voltage V | 15 |
| Power Budget W | 25 |
| Bandwidth Mhz | 500 |
| Antenna Count | 4 |
| Channel Count | 1 |
| Preselector Tech | tunable_yig |
| Cascaded Gain Db | 65.0 |
| Cascaded Nf Db | 8.0 |
| Cascaded P1Db Dbm | 10.0 |
| Cascaded Iip3 Dbm | 24.0 |
| Adc Sample Rate Msps | 210 |
| Adc Resolution Bits | 16 |
| Lo Phase Noise Dbc Hz At 10Khz | -120 |
| Number Of If Stages | 2 |
| If1 Frequency Ghz | 4.0 |
| If2 Frequency Mhz | 500 |

## 3. Requirements

### 3.1 Performance Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-001 | Frequency Range | The receiver shall operate over the 18-40 GHz frequency range supporting all specified radar bands. | shall | test | None | None |
| REQ-HW-002 | Instantaneous Bandwidth | The receiver shall support a tunable instantaneous bandwidth of 100-500 MHz across the operating frequency range. | shall | test | None | None |
| REQ-HW-003 | System Noise Figure | The cascaded system noise figure shall not exceed 8 dB typical, 10 dB maximum across all channels and frequencies. | shall | test | None | None |
| REQ-HW-004 | Total System Gain | The cascaded gain shall be greater than 60 dB, target 65 dB nominal, with VGA/AGC providing at least 30 dB dynamic range adjustment. | shall | test | None | None |
| REQ-HW-005 | IIP3 Linearity | The system input-referred third-order intercept point (IIP3) shall be at least +20 dBm under nominal gain conditions. | shall | test | None | None |
| REQ-HW-006 | Output P1dB | The output 1 dB compression point shall be at least +10 dBm at the final IF output before the ADC. | shall | test | None | None |
| REQ-HW-007 | SFDR | The spurious-free dynamic range (two-tone, IIP3-driven) shall be at least 80 dB at the ADC output. | shall | test | None | None |
| REQ-HW-008 | Selectivity | Adjacent-channel rejection shall be at least 60 dBc achieved through double-IF filtering and final IF bandpass. | shall | test | None | None |
| REQ-HW-009 | Minimum Detectable Signal | The system MDS shall be at least -81.2 dBm (derived from Friis calculation with 8 dB NF, 500 MHz IBW). | shall | analysis | None | None |
| REQ-HW-010 | Input Survivability | The receiver front-end shall survive a +20 dBm CW or pulsed input without damage. Limiter protection required. | shall | test | None | None |
| REQ-HW-011 | Input Return Loss / VSWR | The RF input return loss shall be better than -10 dB (VSWR < 2:1) across the full 18-40 GHz range. | shall | test | None | None |
| REQ-HW-012 | LO Phase Noise | The LO phase noise shall be better than -120 dBc/Hz at 10 kHz offset from carrier, using OCXO-referenced PLL synthesizers. | shall | test | None | None |
| REQ-HW-013 | Phase Coherence | All 4 channels shall maintain phase coherence for coherent pulse processing. LO distribution skew < 1 ps between channels. | shall | test | None | None |
| REQ-HW-014 | T/R Switching Time | Transmit/receive switching time shall be less than 1 microsecond for monostatic radar operation. | shall | test | None | None |

### 3.2 Functional Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-015 | 4-Channel Architecture | The receiver shall implement 4 independent RF channels, each with dedicated front-end (limiter, preselector, LNA) and dual downconversion chain. | shall | inspection | None | None |
| REQ-HW-016 | Double-IF Superheterodyne Conversion | Each channel shall implement dual downconversion: RF to IF1 (approx 4 GHz) and IF1 to IF2 (approx 500 MHz) for image rejection and selectivity. | shall | inspection | None | None |
| REQ-HW-017 | ADC Digitisation | Each channel shall digitise the final IF using a 16-bit ADC at 210 Msps (LTC2107) with LVDS interface to the FPGA. | shall | test | None | None |
| REQ-HW-018 | FPGA Digital Processing | A Xilinx Kintex-7 (XC7K355T) FPGA shall perform digital downconversion, pulse compression, and coherent processing for all 4 channels simultaneously. | shall | demonstration | None | None |
| REQ-HW-019 | Radar Pulse Processing | The system shall support pulse widths from 100 ns to 1 us with staggered PRF and achieve range resolution of 1-10 m. | shall | test | None | None |
| REQ-HW-028 | VGA/AGC Gain Control | A voltage-variable attenuator (TGL2767) shall provide AGC range to maintain ADC input within the linear region for varying signal levels. | shall | test | None | None |

### 3.3 Interface Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-020 | Data Output Interface | Digitised data shall be output via LVDS interface from the FPGA to the downstream signal processor. | shall | test | None | None |

### 3.4 Environmental Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-021 | Operating Temperature Range | The receiver shall operate over -55 to +125 degC (military temperature class). All active components must be rated for this range. | shall | test | None | None |
| REQ-HW-022 | Vibration and Shock | The receiver shall meet MIL-STD-810 heavy vibration and shock requirements. All RF modules shall use cavity shielding and mechanical retention. | shall | test | None | None |
| REQ-HW-023 | Ingress Protection | The receiver enclosure shall be rated IP68 for dust and water ingress protection. | shall | test | None | None |

### 3.5 Constraint Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-024 | Power Consumption | Total system DC power consumption shall not exceed 25 W from the +15 V primary supply rail. | shall | test | None | None |
| REQ-HW-025 | Supply Voltage | The primary supply rail is +15 VDC. Internal LDO regulation shall generate all required sub-rails (5V, 3.3V) with low-noise LC/ferrite decoupling per stage. | shall | test | None | None |
| REQ-HW-026 | High-Gain Stability Mitigation | With cascaded gain >60 dB, each major stage group shall reside in separate shielded cavities with isolated LC/ferrite-decoupled supply rails and reverse-orientation input/output routing to prevent oscillation. | shall | inspection | None | None |
| REQ-HW-027 | Nyquist Anti-Aliasing | With ADC at 210 Msps and IBW up to 500 MHz, the final IF BPF shall provide >60 dBc rejection at the Nyquist foldover frequency to prevent aliasing. Alternatively, implement sub-band channelisation. | should | analysis | None | None |
