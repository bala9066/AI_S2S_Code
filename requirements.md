# Hardware Requirements
## Receiver Module

## 1. Project Summary

Wideband RF receiver module covering 5-18 GHz frequency range with analog IF output, designed for military environments. The system operates from +12V supply and achieves low noise figure performance while handling input signal levels from -60 to -30 dBm.

## 2. Design Parameters

| Parameter | Value |
|---|---|
| Frequency Range | 5-18 GHz |
| Input Power Range | -60 to -30 dBm |
| Noise Figure | <3 dB |
| Rf Input Impedance | 50 ohms |
| Rf Output Impedance | 50 ohms |
| Supply Voltage | +12V DC |
| Operating Temperature | -55 to +125°C |
| Compliance Standards | ['MIL-STD-883', 'MIL-STD-461', 'MIL-I-46058C'] |
| Input Connector | SMA female (flange mount) |
| Output Connector | SMA female |

## 3. Requirements

### 3.1 Functional Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-001 | Frequency Range Coverage | The receiver shall cover the frequency range from 5 GHz to 18 GHz continuous coverage. | Must have | test | None | None |
| REQ-HW-011 | RF Gain Control | The receiver shall include RF gain control capability (either manual or AGC) to optimize dynamic range. | Should have | test | REQ-HW-002 | Gain adjustment range: ≥20 dB |
| REQ-HW-013 | DC Blocking | DC blocking capacitors shall be provided at RF input and output ports. | Must have | inspection | REQ-HW-004, REQ-HW-005 | Cutoff frequency < 100 MHz |

### 3.2 Performance Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-002 | Input Power Dynamic Range | The receiver shall accept input signal levels ranging from -60 dBm to -30 dBm without degradation. | Must have | test | None | None |
| REQ-HW-003 | Noise Figure | The system noise figure shall be less than 3 dB across the entire 5-18 GHz operating band. | Must have | test | REQ-HW-001 | Cascaded NF calculation required |
| REQ-HW-012 | Input Return Loss | The input RF return loss shall be ≥10 dB across the 5-18 GHz band (VSWR ≤ 2.0:1). | Should have | test | REQ-HW-001 | Impedance matching network required |

### 3.3 Interface Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-004 | RF Input Interface | RF input shall be via 50-ohm SMA connector (female, 2-hole flange mount). | Must have | inspection | None | Impedance: 50 ohms, VSWR < 2.0:1 |
| REQ-HW-005 | Analog IF Output | Receiver shall provide analog intermediate frequency output on 50-ohm SMA connector. | Must have | test | None | Impedance: 50 ohms |
| REQ-HW-006 | Power Supply Input | The module shall operate from a single +12V DC power supply input. | Must have | test | None | Voltage range: +11V to +13V, Reverse polarity protection required |

### 3.4 Environmental Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-007 | Military Temperature Range | The receiver shall operate reliably across the military temperature range of -55°C to +125°C. | Must have | test | None | Components must be -55 to +125°C rated |
| REQ-HW-008 | Vibration and Shock | The receiver shall meet MIL-STD-883 vibration and shock requirements for military applications. | Must have | test | None | MIL-STD-883 compliant, PCB stiffener required |
| REQ-HW-010 | Conformal Coating | The PCB assembly shall have conformal coating per MIL-I-46058C for moisture and contamination protection. | Should have | inspection | None | None |

### 3.5 Constraint Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-009 | EMI/EMC Compliance | The design shall comply with MIL-STD-461 for electromagnetic interference and susceptibility. | Must have | test | None | Shielding required, Proper filtering on I/O lines |
