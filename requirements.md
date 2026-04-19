# Hardware Requirements
## gvng

## 1. Project Summary

8-channel RF front-end for EW/ESM/ELINT applications covering 2-6 GHz with 10-100 MHz instantaneous bandwidth. Active GaN HEMT LNA chain provides 40-60 dB gain, +20 dBm IIP3, and +40 dBm survivability. Designed for military (-55°C to +125°C) environments with MIL-STD-810 heavy vibration and IP67 ruggedness.

## 2. Design Parameters

| Parameter | Value |
|---|---|
| Noise Figure Db | 5 |
| Output Power Dbm | 20 |
| Iip3 Dbm | 20 |
| System Gain Db | 50 |
| Frequency Range Ghz | 2-6 |
| Bandwidth Mhz | 100 |
| Mds Dbm | -92 |
| Supply Voltage V | 12 |
| Power Budget W | 25 |

## 3. Requirements

### 3.1 Functional Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-001 | RF Front-End Operation | 8-channel RF front-end covering 2-6 GHz frequency range with 10-100 MHz instantaneous bandwidth for EW/ESM/ELINT applications | Must have | test | None | None |
| REQ-HW-002 | Channel Parallelism | Simultaneous operation of 8 independent RF channels | Must have | test | None | None |
| REQ-HW-017 | Simultaneous Signal Handling | Handle 5-16 simultaneous signals | Should have | test | None | None |
| REQ-HW-018 | Threat Band Coverage | Multi-band (octave) threat band coverage | Should have | test | None | None |

### 3.2 Performance Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-003 | System Noise Figure | Target system noise figure of 4-6 dB across 2-6 GHz band | Must have | test | None | None |
| REQ-HW-004 | System Gain | LNA chain gain of 40-60 dB | Must have | test | None | None |
| REQ-HW-005 | Linearity (IIP3) | Target IIP3 of +20 dBm | Must have | test | None | None |
| REQ-HW-006 | Maximum Input Power | Safe input handling up to +40 dBm with survivability requirements | Must have | test | None | None |
| REQ-HW-007 | Return Loss/VSWR | Input return loss of -20 dB (1.2:1 VSWR) | Must have | test | None | None |
| REQ-HW-008 | MDS (Friis) | Minimum detectable signal of -92.0 dBm | Must have | test | None | None |

### 3.3 Interface Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-009 | Antenna Interface | Single-ended 50Ω antenna interface | Must have | test | None | None |
| REQ-HW-010 | RF Connector | SMP connector for RF input | Must have | test | None | None |
| REQ-HW-011 | Output Interface | Interface to superheterodyne receiver | Must have | test | None | None |

### 3.4 Environmental Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-012 | Operating Temperature | Military temperature range: -55°C to +125°C | Must have | test | None | None |
| REQ-HW-013 | Vibration/Shock | MIL-STD-810 heavy vibration/shock environment | Must have | test | None | None |
| REQ-HW-014 | Ingress Protection | IP67 ruggedized enclosure | Must have | test | None | None |

### 3.5 Constraint Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-015 | Power Budget | Total power consumption limited to 15-30 W | Must have | test | None | None |
| REQ-HW-016 | Supply Voltage | Primary supply voltage: +12 V | Must have | test | None | None |
| REQ-HW-019 | LNA Technology | GaN HEMT semiconductor technology for LNA | Should have | test | None | None |
| REQ-HW-020 | Filter Technology | Ceramic pre-select filter technology | Should have | test | None | None |
| REQ-HW-021 | Biasing Scheme | Active biasing for LNA | Should have | test | None | None |
