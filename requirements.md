# Hardware Requirements
## hjjg

## 1. Project Summary

Dual-channel 2–6 GHz double-IF superheterodyne radar receiver with phase-coherent processing. Each of the two RF front-ends includes a PIN-diode limiter, tunable preselector BPF, and GaAs pHEMT LNA, followed by two down-conversion stages, IF filtering, and 14-bit 170 MSPS ADC digitisation. A Kintex-7 FPGA provides digital signal processing via LVDS interface. The system targets military temperature range (-55 to +125 °C) with ≤5 dB NF, ≥40 dB gain, +10 dBm IIP3, and 80 dB SFDR.

## 2. Design Parameters

| Parameter | Value |
|---|---|
| Application | Radar |
| Architecture | Double-IF Superheterodyne |
| Frequency Range Ghz | 2-6 |
| Bandwidth Mhz | 100 |
| Noise Figure Db | 5 |
| System Gain Db | 50 |
| Selectivity Dbc | 80 |
| Sfdr Db | 80 |
| Iip3 Dbm | 10 |
| Output P1Db Dbm | 10 |
| Max Input Dbm | 20 |
| Input Return Loss Db | 10 |
| Supply Voltage V | 12 |
| Power Budget W | 15 |
| Mds Dbm | -92 |
| Antenna Count | 2 |
| Channel Count | 2 |
| Preselector Tech | Tunable YIG / LC BPF bank |
| Lo Phase Noise Dbc Hz | -120 |
| Adc Sample Rate Msps | 250 |
| Adc Enob | 14 |
| Pulse Width Ns | 100-1000 |
| Pri | Staggered |
| Coherent Processing | Yes |
| Range Resolution M | 1 |
| Temperature Class | MIL -55 to 125C |
| Fmc Connector | FMC / FMC+ |
| F1 Mhz | 1300 |
| F2 Mhz | 200 |
| Lo1 Freq Ghz | 3.3-7.3 |
| Lo2 Freq Ghz | 1.1 |

## 3. Requirements

### 3.1 Functional Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-001 | RF Frequency Coverage | The receiver shall accept RF signals in the 2–6 GHz band with usable performance across the full range. | shall | test | None | None |
| REQ-HW-012 | Dual-Channel Phase Coherence | Both receiver channels shall be phase-coherent sharing a common LO chain to support coherent radar processing. | shall | test | None | None |
| REQ-HW-013 | Double-IF Architecture | The downconversion shall use two IF stages: 1st IF at 1300 MHz and 2nd IF at 200 MHz to achieve the required image rejection and selectivity. | shall | inspection | None | None |
| REQ-HW-017 | Radar Pulse Processing | The receiver shall support pulse widths from 100 ns to 1 us with staggered PRI and coherent-on-receive operation. | shall | demonstration | None | None |

### 3.2 Performance Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-002 | Instantaneous Bandwidth | Each receiver channel shall support a minimum instantaneous bandwidth of 100 MHz within the 2–6 GHz operating range. | shall | test | None | None |
| REQ-HW-003 | System Noise Figure | The cascaded system noise figure shall not exceed 5 dB measured at the antenna input port. | shall | test | None | None |
| REQ-HW-004 | Total System Gain | End-to-end voltage gain from antenna SMA to ADC full-scale input shall be 50 dB nominal (acceptable range 40–60 dB). | shall | test | None | None |
| REQ-HW-005 | Input Third-Order Intercept Point | System IIP3 shall be +10 dBm minimum (referred to the antenna input) with two in-band tones separated by 1 MHz. | shall | test | None | None |
| REQ-HW-006 | Output P1dB | The output 1 dB compression point at the final IF output shall be +10 dBm minimum. | shall | test | None | None |
| REQ-HW-007 | Spurious-Free Dynamic Range | Two-tone SFDR shall be 80 dB minimum referred to the ADC input. | shall | test | None | None |
| REQ-HW-008 | Selectivity / Adjacent-Channel Rejection | Adjacent-channel rejection shall be at least 80 dBc at one channel-width offset. | shall | test | None | None |
| REQ-HW-009 | Input Return Loss / VSWR | The antenna input return loss shall be better than -10 dB (VSWR < 2:1) across 2–6 GHz. | shall | test | None | None |
| REQ-HW-010 | Maximum Survivable Input Power | The receiver front-end shall survive a continuous input of +20 dBm without damage or performance degradation. | shall | test | None | None |
| REQ-HW-011 | Minimum Detectable Signal | Derived MDS shall be -92 dBm or better for a 100 MHz bandwidth at the specified system NF. | shall | analysis | None | None |
| REQ-HW-014 | LO Phase Noise | The LO chain phase noise shall be -120 dBc/Hz or better at 10 kHz offset from carrier. | shall | test | None | None |
| REQ-HW-015 | ADC Dynamic Performance | The ADC shall provide 14-bit resolution at 170 MSPS minimum with LVDS outputs achieving ENOB >= 11.5 bits at the 200 MHz IF. | shall | test | None | None |
| REQ-HW-018 | Range Resolution | The combined bandwidth and processing shall support range resolution better than 1 m. | shall | analysis | None | None |
| REQ-HW-022 | High-Gain Stability | With cascaded gain > 45 dB, the layout shall incorporate shielded-cavity construction, inter-stage BPF isolation, and LC/ferrite rail decoupling on every gain stage to prevent oscillation. | shall | inspection | None | None |

### 3.3 Interface Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-016 | Data Output Interface | Digitised ADC data shall be transferred to the processing FPGA via LVDS interface on an FMC connector. | shall | inspection | None | None |

### 3.4 Constraint Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-019 | Power Consumption | Total DC power consumption shall not exceed 15 W from a +12 V primary supply rail. | shall | test | None | None |

### 3.5 Environmental Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-020 | Operating Temperature Range | The receiver shall operate over -55 deg C to +125 deg C (military grade) with verified performance at both extremes. | shall | test | None | None |
| REQ-HW-021 | Vibration and Shock | The assembly shall meet MIL-STD-810 light vibration and shock requirements. | should | test | None | None |
