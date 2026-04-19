# Hardware Requirements
## hh

## 1. Project Summary

Dual-channel EW/ELINT front-end receiver covering 2-6 GHz with 4 parallel RF channels per antenna, providing robust signal acquisition in high-interference environments with GaAs pHEMT LNAs and SAW preselectors.

## 2. Design Parameters

| Parameter | Value |
|---|---|
| Noise Figure Db | 3 |
| Output Power Dbm | 0 |
| Iip3 Dbm | 30 |
| System Gain Db | 30 |
| Frequency Range Ghz | 2-6 |
| Bandwidth Mhz | 100 |
| Mds Dbm | -94 |
| Supply Voltage V | 12 |
| Power Budget W | 30 |
| Antenna Count | 2 |
| Channel Count | 4 |
| Preselector Tech | SAW |
| Interference Environment | High |
| Operating Temperature C | -55_to_125 |
| Connector Type | SMA |
| Semiconductor Technology | GaAs_pHEMT |
| Bias Scheme | Active |
| Lifecycle Status | active |

## 3. Requirements

### 3.1 Functional Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-001 | Frequency Range Coverage | Operate across 2-6 GHz frequency band with instantaneous bandwidth of 10-100 MHz | Must have | test | None | None |
| REQ-HW-011 | Multi-Antenna Operation | Support 2 independent receiver antennas | Must have | test | None | None |
| REQ-HW-012 | Channelised Filter Bank | Provide 4 parallel analog RF channels per antenna | Must have | test | None | None |
| REQ-HW-013 | Preselect Filter Technology | Implement SAW filters for out-of-band and image rejection | Must have | test | None | None |
| REQ-HW-015 | LNA Technology | Use GaAs pHEMT semiconductor technology for LNAs | Must have | test | None | None |
| REQ-HW-016 | Bias Sequencing | Implement gate-before-drain bias sequencing for GaAs pHEMT devices | Must have | analysis | REQ-HW-015 | None |

### 3.2 Performance Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-002 | System Noise Figure | Achieve system noise figure of 2-4 dB across the full frequency range | Must have | test | None | None |
| REQ-HW-003 | LNA Chain Gain | Provide 20-40 dB gain in the LNA chain | Must have | test | None | None |
| REQ-HW-004 | Linearity (IIP3) | Maintain +30 dBm IIP3 to handle strong interferers | Must have | test | None | None |
| REQ-HW-005 | Survivability | Withstand up to +20 dBm input without damage | Must have | test | None | None |
| REQ-HW-017 | MDS Performance | Achieve derived MDS of -94.0 dBm based on system noise figure | Should have | test | REQ-HW-002 | None |

### 3.3 Interface Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-006 | Input Return Loss | Maintain input return loss of -20 dB (1.2:1 VSWR) across 2-6 GHz | Must have | test | None | None |
| REQ-HW-014 | Antenna Interface | Single-ended 50Ω interface via SMA connectors | Must have | test | None | None |

### 3.4 Constraint Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-007 | Power Consumption | Total power consumption limited to >30 W at +12V supply | Must have | test | None | None |
| REQ-HW-020 | Interference Environment | Handle high interference environment with co-site radar and comms signals | Must have | test | None | None |

### 3.5 Environmental Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-008 | Operating Temperature | Operate reliably from -55°C to +125°C military temperature range | Must have | test | None | None |
| REQ-HW-009 | Environmental Vibration/Shock | Meet MIL-STD-810 heavy vibration and shock requirements | Must have | demonstration | None | None |
| REQ-HW-010 | Ingress Protection | Achieve IP67 rating for rugged operation | Must have | test | None | None |
| REQ-HW-018 | MIL-STD-461 Compliance | Meet MIL-STD-461 EMI/EMC requirements for co-site operation | Should have | test | None | None |
| REQ-HW-019 | MIL-STD-810 Compliance | Meet MIL-STD-810 environmental requirements | Should have | demonstration | None | None |
