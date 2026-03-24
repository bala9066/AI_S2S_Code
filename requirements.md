# Hardware Requirements
## rf4

## 1. Project Summary

High-power RF amplifier for 2.4 GHz ISM band delivering 40 dBm (10W) output power. Suitable for continuous wave (CW) and moderately modulated signals (ASK/OOK/low-order FSK) with 40 dB gain. Operates from 12V DC supply with thermal management designed for convection cooling with heatsink.

## 2. Design Parameters

| Parameter | Value |
|---|---|
| Frequency Center | 2.4 GHz |
| Frequency Bandwidth | 2.4-2.5 GHz (100 MHz) |
| Pout Target | +40 dBm (10W) |
| Gain Target | 40 dB |
| Input Drive | 0 to +10 dBm |
| Supply Voltage | +12V DC ±10% |
| Max Current | 5A |
| Efficiency Target | ≥20% PAE |
| Impedance | 50Ω |
| Connectors | SMA female (RF), terminal block (DC) |
| Operating Temp | 0 to +50°C (with heatsink) |
| Gain Topology | 2-stage (driver + PA) |
| Control Interface | TTL enable pin |

## 3. Requirements

### 3.1 Performance Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-001 | Output Power | Amplifier shall deliver minimum +40 dBm (10W) output power at 2.4 GHz center frequency into 50-ohm load. | Must have | test | None | P1dB, thermal_limit |
| REQ-HW-002 | Frequency Range | Amplifier shall operate over 2.4 to 2.5 GHz ISM band (2.4 GHz WiFi/Bluetooth band). | Must have | test | None | S11, S22 |
| REQ-HW-003 | Power Gain | Amplifier shall provide minimum 40 dB gain from input to output (0 dBm in, 40 dBm out). | Must have | test | REQ-HW-006 | None |
| REQ-HW-004 | Input Return Loss | Input return loss shall be better than 10 dB across operating band. | Should have | test | None | None |
| REQ-HW-005 | Output Return Loss | Output return loss shall be better than 10 dB across operating band. | Should have | test | None | None |
| REQ-HW-006 | Input Drive Level | Amplifier shall accept 0 to +10 dBm input drive level without compression. | Must have | test | None | None |
| REQ-HW-008 | DC Current Draw | Maximum DC current draw shall not exceed 5A at 12V (60W total input) at full output power. | Must have | test | None | None |
| REQ-HW-009 | Power Added Efficiency | PA shall achieve minimum 20% PAE at full power output. | Should have | test | None | None |
| REQ-HW-011 | Harmonic Output | Harmonic output shall be at least 30 dBc below fundamental at 2x and 3x harmonics. | Should have | test | None | None |
| REQ-HW-017 | Stability | Amplifier shall be unconditionally stable with K-factor > 1 across all frequencies. | Must have | analysis | None | None |

### 3.2 Functional Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-007 | Power Supply | Amplifier shall operate from single +12V DC supply with ±10% tolerance. | Must have | test | None | current_limit |
| REQ-HW-010 | Enable Control | Amplifier shall include TTL/CMOS-compatible enable pin for TX/RX switching. | Must have | demonstration | None | None |
| REQ-HW-018 | Output Power Detect | Amplifier shall provide coupler output for power monitoring (-20 dB coupled). | Could have | test | None | None |

### 3.3 Environmental Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-012 | Operating Temperature | Amplifier shall operate from 0 to +50°C with heatsink. | Must have | test | None | derating |

### 3.4 Constraint Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-013 | Thermal Protection | Amplifier shall include thermal shutdown or derating above +85°C case temperature. | Should have | test | None | None |
| REQ-HW-016 | Impedance | All RF ports shall be matched to 50-ohm single-ended impedance. | Must have | test | None | None |

### 3.5 Interface Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-014 | RF Connectors | Input and output shall use SMA female connectors (50-ohm). | Must have | inspection | None | None |
| REQ-HW-015 | DC Power Connector | DC input shall use banana jack or terminal block for 12V connection. | Should have | inspection | None | None |
