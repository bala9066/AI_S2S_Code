# Hardware Requirements
## khg

## 1. Project Summary

Wideband RF receiver front-end operating from 5-18 GHz with 5-10 GHz instantaneous bandwidth, 6-10 dB noise figure, and +20-30 dBm IP3. Outputs digitized I/Q data via JESD204C interface to FPGA/processor. Designed for military operating environment (-55 to +125°C) with moderate vibration tolerance.

## 2. Design Parameters

| Parameter | Value |
|---|---|
| Frequency Range | 5-18 GHz |
| Instantaneous Bandwidth | 5-10 GHz (3 dB) |
| Noise Figure | ≤10 dB (target 6-8 dB) |
| Sfdr | ≥70 dB (target 80 dB) |
| Iip3 | +20 to +30 dBm |
| Digital Interface | JESD204C Subclass 1 |
| Gain Control Range | 40-60 dB analog |
| Input Impedance | Differential 100Ω |
| Power Budget | ≤50W (target 30-40W) |
| Operating Temperature | -55°C to +125°C (military) |
| Vibration | Moderate per MIL-STD-883 |
| Supply Voltage | +12V DC ±10% |
| Control Interface | SPI |

## 3. Requirements

### 3.1 Performance Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-001 | Operating Frequency Range | Receiver shall tune across 5-18 GHz frequency range with continuous coverage. | Must have | test | None | None |
| REQ-HW-002 | Instantaneous Bandwidth | Receiver shall support minimum 5 GHz instantaneous 3 dB bandwidth. | Must have | test | REQ-HW-001 | flatness: ±2 dB over 5 GHz |
| REQ-HW-003 | Noise Figure | System noise figure shall not exceed 10 dB across 5-18 GHz band. | Must have | test | None | target NF: ≤6 dB achievable with optimized LNA selection |
| REQ-HW-004 | Dynamic Range (SFDR) | Receiver spurious-free dynamic range shall be ≥70 dB. | Must have | test | REQ-HW-003 | target SFDR: 80 dB achievable |
| REQ-HW-005 | Input Third-Order Intercept Point | System input IP3 shall be +20 dBm minimum. | Must have | test | None | target IIP3: +25 to +30 dBm |
| REQ-HW-007 | Gain Control Range | Receiver shall provide minimum 40 dB of analog gain control in 1 dB steps. | Must have | test | None | target range: 60 dB |
| REQ-HW-009 | Power Consumption | Total receiver power consumption shall not exceed 50W. | Must have | test | None | target: 30-40W typical |

### 3.2 Interface Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-006 | Digital Output Interface | Digitized I/Q data shall output via JESD204C SerDes interface. | Must have | demonstration | None | lane rate: up to 12.5 Gbps per lane, subclass: 1 with SYSREF |
| REQ-HW-012 | Control Interface | Receiver shall support SPI serial interface for gain, frequency, and configuration control. | Must have | demonstration | None | clock rate: up to 50 MHz |

### 3.3 Constraint Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-008 | Input Impedance | RF input shall present differential 100Ω impedance. | Must have | test | None | VSWR ≤2.0:1 |
| REQ-HW-013 | Supply Voltage | System shall operate from +12V DC primary supply. | Must have | inspection | None | allowable range: +10V to +14V DC |

### 3.4 Environmental Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-010 | Operating Temperature Range | Receiver shall operate over military temperature range -55°C to +125°C. | Must have | test | None | All components shall meet MIL-PRF or industrial temp with derating |
| REQ-HW-011 | Vibration Tolerance | Receiver shall withstand moderate vibration per MIL-STD-883 Method 2007. | Should have | test | None | random vibration: 20-2000 Hz, 0.04 g²/Hz |

### 3.5 Functional Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-014 | RF Front-End Protection | Receiver shall include input limiter/protection for survivability to +20 dBm input. | Should have | test | None | recovery time: <100 ns |
| REQ-HW-015 | Automatic Gain Control | Receiver shall support automatic gain control mode to maintain optimal ADC input level. | Could have | test | REQ-HW-007 | settling time: <1 µs |

### 3.6 Compliance Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-016 | Component Compliance | All components shall be RoHS compliant and available in military or industrial temperature grades. | Must have | inspection | None | avoid EOL parts |
