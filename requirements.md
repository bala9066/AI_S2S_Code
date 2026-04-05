# Hardware Requirements
## hkgg

## 1. Project Summary

Wideband RF power amplifier delivering +40 dBm (10W) output power across 50-500 MHz bandwidth with continuous wave (CW) modulation. The system operates from +12V DC supply in commercial temperature environments (0-70°C) and accepts +10 dBm input drive level.

## 2. Design Parameters

| Parameter | Value |
|---|---|
| Output Power | +40 dBm (10W) |
| Frequency Range | 50-500 MHz |
| Input Power | +10 dBm |
| Gain | 30 dB |
| Supply Voltage | +12V DC +/-10% |
| Supply Current Max | 3.5A |
| Modulation | Continuous Wave (CW) |
| Input Impedance | 50 ohms |
| Output Impedance | 50 ohms |
| Vswr Max | 2.0:1 |
| Efficiency Min | 35% PAE |
| Operating Temp | 0 to +70°C commercial |
| Connectors | SMA female RF, banana jack/terminal DC |

## 3. Requirements

### 3.1 Functional Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-001 | RF Power Output | Amplifier shall deliver minimum +40 dBm (10W) output power across 50-500 MHz frequency range under continuous wave (CW) operation. | Must have | test | None | P1dB > 40 dBm, PSAT >= 41 dBm |
| REQ-HW-002 | Gain Requirement | Amplifier shall provide minimum 30dB gain to amplify +10 dBm input to +40 dBm output. | Must have | test | REQ-HW-001 | Flatness +/- 2dB over bandwidth |
| REQ-HW-003 | Input/Output Impedance | Input and output RF ports shall be matched to 50 ohm impedance with VSWR <= 2.0:1. | Must have | test | None | S11 < -10dB, S22 < -10dB |
| REQ-HW-007 | RF Connectors | RF input and output shall use SMA female 50 ohm connectors. | Must have | inspection | None | None |
| REQ-HW-009 | RF Enable Control | Amplifier shall include RF enable/disable control pin with logic high = ON. | Should have | test | None | TTL/CMOS compatible |

### 3.2 Performance Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-004 | Power Supply | Amplifier shall operate from +12V DC supply with +/- 10% tolerance. | Must have | test | None | Max current < 3.5A at full power |
| REQ-HW-005 | Efficiency | Power added efficiency (PAE) shall be >= 35% at rated output power. | Should have | test | REQ-HW-001 | None |
| REQ-HW-010 | Harmonic Distortion | Second and third harmonic distortion shall be <= -30 dBc at rated output power. | Should have | test | REQ-HW-001 | None |
| REQ-HW-011 | Stability | Amplifier shall be unconditionally stable with K-factor > 1 and B1 > 0 across 50-500 MHz. | Must have | analysis | None | None |

### 3.3 Environmental Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-006 | Operating Temperature | Amplifier shall meet all electrical specifications over commercial temperature range 0°C to +70°C. | Must have | test | None | None |
| REQ-HW-013 | RoHS Compliance | All components shall be RoHS compliant. | Must have | inspection | None | None |

### 3.4 Constraint Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-008 | Thermal Management | Amplifier shall include thermal pad for heatsink attachment with thermal resistance <= 2°C/W. | Must have | inspection | REQ-HW-006 | None |
| REQ-HW-012 | Reverse Power Protection | Amplifier shall survive up to +2W reverse power for 5 minutes without damage. | Should have | test | None | None |

### 3.5 Interface Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-014 | DC Power Connector | DC power input shall use banana jack or terminal block for +12V and GND connection. | Could have | inspection | REQ-HW-004 | None |
