# Hardware Requirements
## dgh

## 1. Project Summary

Radar RF front-end receiver design covering 5-18 GHz with 10-100 MHz instantaneous bandwidth, featuring GaN HEMT LNA chain, SAW pre-select filters, and +30 dBm survivability. Supports 4 parallel channels with superheterodyne downstream receiver interface.

## 2. Design Parameters

| Parameter | Value |
|---|---|
| Frequency Range | 5-18 GHz |
| Instantaneous Bandwidth | 10-100 MHz |
| Noise Figure | 4-6 dB |
| Gain | 40-60 dB |
| Iip3 | +20 dBm |
| Max Input | +30 dBm |
| Input Return Loss | -14 dB |
| Power Budget | 5-15 W |
| Supply Voltage | +28 V |
| Temperature Range | -55 to +125°C |
| Vibration | MIL-STD-810 heavy |
| Ingress Protection | IP67 |
| Channels | 4 |
| Antenna Interface | Single-ended 50Ω |
| Connector Type | SMA |
| Lna Technology | GaN HEMT |
| Filter Technology | SAW |
| Biasing Scheme | Active bias |
| Tr Switching | No T/R switch |
| Signal Types | CW/LFM |
| Interference Environment | High |
| Downstream Receiver | Superheterodyne |

## 3. Requirements

### 3.1 Functional Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-001 | Frequency Range | Operate across 5-18 GHz frequency band for radar applications | shall | test | None | None |
| REQ-HW-014 | Channel Count | Support 4 parallel RF channels simultaneously | shall | test | None | None |
| REQ-HW-016 | Signal Types | Support CW and LFM (Linear Frequency Modulated) radar signals | should | test | None | None |
| REQ-HW-017 | LNA Technology | Utilize GaN HEMT technology for LNA implementation | shall | inspection | None | None |
| REQ-HW-018 | Filter Technology | SAW pre-select filter technology for RF filtering | should | test | None | None |
| REQ-HW-019 | LNA Biasing | Active biasing scheme for LNA stability | should | test | None | None |

### 3.2 Performance Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-002 | Instantaneous Bandwidth | Support 10-100 MHz instantaneous bandwidth for signal processing | shall | test | None | None |
| REQ-HW-003 | System Noise Figure | Target system noise figure of 4-6 dB across 5-18 GHz range | shall | test | None | None |
| REQ-HW-004 | LNA Chain Gain | Provide 40-60 dB total gain through LNA chain | shall | test | None | None |
| REQ-HW-005 | Linearity (IIP3) | Achieve +20 dBm IIP3 for robust interference handling | shall | test | None | None |
| REQ-HW-006 | Survivability | Withstand +30 dBm maximum input without damage | shall | test | None | None |
| REQ-HW-021 | MDS (Friis) | Derived minimum detectable signal of -92.0 dBm | shall | calculation | None | None |

### 3.3 Interface Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-007 | Input Return Loss | Maintain -14 dB input return loss (1.5:1 VSWR) across 5-18 GHz | shall | test | None | None |
| REQ-HW-008 | Antenna Interface | Single-ended 50Ω antenna interface via SMA connectors | shall | inspection | None | None |
| REQ-HW-015 | Downstream Interface | Interface with superheterodyne receiver architecture | shall | inspection | None | None |

### 3.4 Constraint Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-009 | Power Consumption | Total power consumption limited to 5-15 W | should | test | None | None |
| REQ-HW-010 | Supply Voltage | Operate from +28 V primary rail | shall | test | None | None |
| REQ-HW-020 | Interference Environment | High interference environment (co-site radar/communications) | shall | test | None | None |

### 3.5 Environmental Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-011 | Operating Temperature | Military temperature range: -55°C to +125°C | shall | test | None | None |
| REQ-HW-012 | Vibration/Shock | Meet MIL-STD-810 heavy vibration/shock requirements | shall | test | None | None |
| REQ-HW-013 | Ingress Protection | IP67 rating for rugged environmental protection | should | test | None | None |
