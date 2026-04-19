# Hardware Requirements
## hm

## 1. Project Summary

UHF (300–1000 MHz) pulsed radar receiver module using a superheterodyne architecture with sub-band tuning via switched filter bank. Fully coherent operation with strict group delay variation (< 1 ns) and coherent pulse-Doppler/MTI processing support. Key specs: 1–10 MHz instantaneous bandwidth, -100 dBm MDS, < 2 dB NF, +20 dBm max input, > 50 dB image rejection, 30 dB system gain. Baseband I/Q analog output into 50 Ω SMA. Powered from +28V rail, 5–15W dissipation.

## 2. Design Parameters

| Parameter | Value |
|---|---|
| Application | Radar / pulse-Doppler / MTI |
| Frequency Range | 300–1000 MHz (UHF) |
| Instantaneous Bandwidth | 1–10 MHz |
| Sensitivity Mds | -100 dBm |
| Max Input Power | +20 dBm |
| Architecture | Superheterodyne (single/double IF) |
| Tuning Method | Sub-band tuning (switched filter bank) |
| System Gain | 30 dB |
| Noise Figure | < 2 dB |
| Input Iip3 | -10 dBm |
| Input P1Db | -20 dBm |
| Image Rejection | > 50 dB |
| Lo Phase Noise | -100 dBc/Hz @ 10 kHz offset |
| Signal Type | Pulsed (1 µs pulse width) |
| Phase Coherence | Fully coherent |
| Group Delay Variation | < 1 ns across IBW |
| Coherent Processing | Yes (pulse-Doppler / MTI) |
| Blockers | Yes (strong adjacent and out-of-band) |
| Output Type | Analog baseband (I/Q differential) |
| Output Impedance | 50 Ω |
| Output Connector | SMA |
| Baseband Bandwidth | 1–10 MHz |
| Output Level | 1 Vpp (default) |
| Supply Voltage | +28V |
| Power Consumption | 5–15 W |
| Frequency Reference | Internal PLL (standard) |
| Operating Temperature | -40°C to +85°C |
| Cooling Method | Conduction (default) |
| Form Factor | SWaP module (default) |
| Compliance | MIL-STD-461 / MIL-STD-810 (default) |
| If Center Freq | 70 MHz |
| Lo Range | 230–930 MHz or 370–1070 MHz |

## 3. Requirements

### 3.1 Functional Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-001 | Receiver Architecture | Superheterodyne receiver (single or double IF) covering 300–1000 MHz with sub-band tuning via switched filter bank. | Must have | test | None | None |
| REQ-HW-002 | Frequency Range | The receiver shall operate across 300–1000 MHz (UHF band). | Must have | test | None | None |
| REQ-HW-012 | Tuning Method | Sub-band tuning via switched filter bank across the 300–1000 MHz range. | Must have | test | None | None |
| REQ-HW-013 | Signal Type Support | Receiver shall process pulsed radar signals with 1 µs nominal pulse width. | Must have | test | None | None |
| REQ-HW-014 | Phase Coherence | Fully coherent operation required for pulse-Doppler and MTI processing. | Must have | test | None | None |
| REQ-HW-016 | Coherent Processing Support | Receiver shall support coherent pulse-Doppler and MTI processing. | Must have | demonstration | None | None |
| REQ-HW-017 | Blocker Handling | Receiver shall operate in the presence of strong adjacent and out-of-band blockers. | Must have | test | None | None |
| REQ-HW-024 | Frequency Reference | Internal PLL frequency reference with standard stability (engineering default). | Should have | test | None | None |

### 3.2 Performance Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-003 | Instantaneous Bandwidth | Instantaneous bandwidth shall be 1–10 MHz. | Must have | test | None | None |
| REQ-HW-004 | Sensitivity (MDS) | Minimum discernible signal shall be -100 dBm or better. | Must have | test | None | None |
| REQ-HW-005 | Maximum Input Power | The receiver shall survive +20 dBm CW at the antenna port without damage. | Must have | test | None | None |
| REQ-HW-006 | System Noise Figure | System noise figure shall be less than 2 dB. | Must have | test | None | None |
| REQ-HW-007 | System Gain | Total system gain shall be 30 dB nominal. | Must have | test | None | None |
| REQ-HW-008 | Input IP3 | Input third-order intercept point shall be -10 dBm or better. | Must have | test | None | None |
| REQ-HW-009 | Input P1dB | Input 1 dB compression point shall be -20 dBm or better. | Must have | test | None | None |
| REQ-HW-010 | Image Rejection | Image rejection shall exceed 50 dB across the tuning range. | Must have | test | None | None |
| REQ-HW-011 | LO Phase Noise | Local oscillator phase noise shall be -100 dBc/Hz at 10 kHz offset. | Must have | test | None | None |
| REQ-HW-015 | Group Delay Variation | Group delay variation shall be less than 1 ns across the instantaneous bandwidth. | Must have | test | None | None |
| REQ-HW-023 | Power Consumption | Total power consumption shall be 5–15 W. | Must have | test | None | None |

### 3.3 Interface Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-018 | Output Type | Analog baseband output (I/Q differential pair). | Must have | test | None | None |
| REQ-HW-019 | Output Impedance and Connector | 50 Ω output impedance with SMA connectors. | Must have | inspection | None | None |
| REQ-HW-020 | Baseband Bandwidth | Baseband output bandwidth shall support the 1–10 MHz instantaneous bandwidth requirement. | Must have | test | None | None |
| REQ-HW-021 | Output Signal Level | Baseband output level 1 Vpp nominal (engineering default). | Should have | test | None | None |
| REQ-HW-022 | Power Supply | Primary supply voltage shall be +28V (MIL standard bus). | Must have | test | None | None |

### 3.4 Environmental Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-025 | Operating Temperature | Operating temperature range -40°C to +85°C (engineering default for military/defense application). | Should have | test | None | None |
| REQ-HW-026 | Cooling Method | Conduction-cooled for military deployment (engineering default given +28V rail). | Should have | inspection | None | None |
| REQ-HW-027 | Form Factor | SWaP-optimized module (engineering default for +28V defense application). | Should have | inspection | None | None |

### 3.5 Constraint Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-028 | Compliance | Design shall comply with MIL-STD-461 EMI and MIL-STD-810 environmental standards (engineering default for defense radar application). | Should have | analysis | None | None |
