# Hardware Requirements
## hv

## 1. Project Summary

18-40 GHz dual-channel double-IF superheterodyne radar receiver covering K/Ka-band with 100-500 MHz IBW. The system provides >60 dB cascaded gain, 6-10 dB NF, and phase-coherent processing for agile-PRF pulsed radar with 10-100 m range resolution. Two independent RF front-ends feed separate ADC channels digitised by a Kintex-7 FPGA over LVDS.

## 2. Design Parameters

| Parameter | Value |
|---|---|
| Frequency Range Ghz | 18-40 |
| Instantaneous Bandwidth Mhz | 500 |
| Noise Figure Db | 6 |
| System Gain Db | 65 |
| Iip3 Dbm | 30 |
| Output Power Dbm | 30 |
| Mds Dbm | -81.2 |
| Supply Voltage V | 15 |
| Power Budget W | 15 |
| Bandwidth Mhz | 500 |
| Antenna Count | 2 |
| Channel Count | 2 |
| Preselector Tech | waveguide cavity BPF |
| If1 Mhz | 3100 |
| If2 Mhz | 500 |
| Lo1 Phase Noise Dbc Per Hz | -110 |
| Adc Sample Rate Msps | 125 |
| Adc Enob Bits | 12 |
| Operating Temp Min C | -55 |
| Operating Temp Max C | 125 |
| Selectivity Dbc | 100 |
| Sfdr Db | 90 |
| Input Return Loss Db | -10 |
| Max Input Dbm | 40 |
| Cascaded Nf Db | 7.5 |
| Cascaded Gain Db | 65 |
| Cascaded P1Db Dbm | 18 |
| Cascaded Iip3 Dbm | 27 |

## 3. Requirements

### 3.1 Functional Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-001 | Frequency Coverage | Receiver shall accept RF input signals in the 18-40 GHz (K/Ka-band) range with a double-IF superheterodyne architecture. | shall | test | None | None |
| REQ-HW-015 | Dual-Channel Phase Coherence | Two RF channels shall be phase-coherent sharing common LO references for coherent radar processing. | shall | test | None | None |
| REQ-HW-021 | T/R Switching | T/R switching time shall be less than 1 us for pulse radar operation. | shall | test | None | None |

### 3.2 Performance Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-002 | Instantaneous Bandwidth | Each RF channel shall support a minimum instantaneous bandwidth of 100 MHz and a maximum of 500 MHz. NOTE: 500 MHz IBW with 125 Msps ADC requires decimation or channelised processing per Architect Warning. | shall | test | None | None |
| REQ-HW-003 | System Noise Figure | Total system noise figure shall not exceed 10 dB across the full 18-40 GHz band, with a target of 6 dB at band centre. | shall | test | None | None |
| REQ-HW-004 | Total System Gain | End-to-end cascaded gain shall exceed 60 dB from RF input to ADC input, with a target of 65 dB. | shall | test | None | None |
| REQ-HW-005 | Selectivity | Adjacent-channel rejection shall exceed 100 dBc, achieved through cascaded BPF stages in double-IF architecture. | shall | test | None | None |
| REQ-HW-006 | Spurious-Free Dynamic Range | Two-tone SFDR shall exceed 90 dB, derived from IIP3-driven linearity and low noise floor. | shall | test | None | None |
| REQ-HW-007 | Input Linearity | System input IIP3 shall be at least +30 dBm to handle moderate blocker environments without desensitisation. | shall | test | None | None |
| REQ-HW-008 | Output P1dB | Output 1 dB compression point at the ADC driver output shall be +30 dBm. | shall | test | None | None |
| REQ-HW-009 | Survivability | Front-end shall survive continuous +40 dBm input at the antenna port without damage, protected by a GaAs Schottky limiter. | shall | test | None | None |
| REQ-HW-010 | Input Return Loss | RF input return loss shall be better than -10 dB (VSWR < 2:1) across 18-40 GHz. | shall | test | None | None |
| REQ-HW-011 | Gain Stability Mitigation | With cascaded gain >60 dB, each gain stage shall reside in a separate shielded cavity with isolated LC/ferrite-decoupled supply rails. A buffer amp shall be inserted between major gain blocks. AGC manages dynamic range only and does NOT prevent oscillation. | shall | inspection | None | None |
| REQ-HW-016 | Pulse Processing | System shall support pulse widths from 100 ns to 1 us with agile/jittered PRI and coherent processing intervals. | shall | demonstration | None | None |

### 3.3 Interface Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-012 | ADC Interface | Dual-channel 12-bit ADC at 125 Msps per channel with LVDS outputs to FPGA. Clock jitter <250 fs rms. | shall | test | None | None |
| REQ-HW-013 | LO Phase Noise | LO phase noise shall be better than -110 dBc/Hz at 10 kHz offset from carrier, using TCXO + PLL architecture. | shall | test | None | None |
| REQ-HW-014 | Digital Processing | Kintex-7 FPGA shall perform phase-coherent pulse processing, data formatting, and LVDS output interface. | shall | demonstration | None | None |

### 3.4 Environmental Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-017 | Operating Temperature | All components shall operate over -55 to +125 deg C (military temperature grade). | shall | test | None | None |
| REQ-HW-018 | Vibration and Shock | Assembly shall meet MIL-STD-810 light vibration and shock profiles. | shall | test | None | None |

### 3.5 Constraint Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-019 | Power Budget | Total DC power consumption shall not exceed 15 W from a +15 V primary supply rail. Estimated system draw: ~11.5 W. | shall | test | None | None |
| REQ-HW-020 | ADC Nyquist Warning | IBW up to 500 MHz with 125 Msps ADC creates aliasing risk. Mitigation: limit effective IBW to <=50 MHz per channel or upgrade ADC to >=1.25 GSPS JESD204B. The 125 Msps rate supports 100 ns pulse capture for narrow sub-bands only. | should | analysis | None | None |
