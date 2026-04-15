# Hardware Requirements
## iguyc

## 1. Project Summary

Wideband RF receiver covering 5-18 GHz with 1-2 GHz instantaneous bandwidth for military applications. The design achieves >10 dB noise figure, 70-80 dB SFDR, and -90 to -100 dBc/Hz phase noise while handling -70 to -40 dBm input power range. Output is via custom CMOS interface to FPGA processing chain, operating at 10-20W power consumption in industrial temperature range (-40 to +85°C) with MIL-STD-883 compliance.

## 2. Design Parameters

| Parameter | Value |
|---|---|
| Center Frequency Mhz | 11500 |
| Bandwidth Mhz | 1000-2000 |
| Input Power Dbm | -70 to -40 |
| Noise Figure Db | <10 |
| Sfdr Db | 70-80 |
| Phase Noise Dbc Hz | -90 to -100 |
| Iip3 Dbm | 10-20 |
| Power Budget W | 10-20 |
| Temp Range C | -40 to +85 |
| Compliance Standard | MIL-STD-883 |
| Output Interface | Custom CMOS to FPGA |
| Adc Resolution Bits | 12-14 |
| Adc Sample Rate Msps | 2000-4000 |

## 3. Requirements

### 3.1 Functional Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-001 | RF Input Frequency Range | Receiver shall accept RF input signals from 5 GHz to 18 GHz with a minimum instantaneous bandwidth of 1 GHz and target of 2 GHz. | Must have | test | None | None |
| REQ-HW-014 | Automatic Gain Control | Receiver shall include AGC functionality to maintain optimal signal levels across input power range. | Should have | test | REQ-HW-003 | None |
| REQ-HW-015 | LO Synthesis | Receiver shall include wideband frequency synthesizer covering 5-18 GHz tuning range. | Must have | test | REQ-HW-001 | tuning_range: 5-18 GHz |

### 3.2 Performance Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-002 | Noise Figure | System noise figure shall be greater than 10 dB (better than 10 dB) across the full 5-18 GHz operating band. | Must have | test | REQ-HW-001 | frequency_range: 5-18 GHz |
| REQ-HW-003 | Input Power Range | Receiver shall accept input power levels from -70 dBm to -40 dBm without degradation. | Must have | test | REQ-HW-001 | max_input: -40 dBm, min_sensitivity: -70 dBm |
| REQ-HW-004 | Spurious-Free Dynamic Range | System SFDR shall be 70-80 dB across the operating band. | Must have | test | REQ-HW-001, REQ-HW-002 | min_sfdr: 70 dB, target_sfdr: 80 dB |
| REQ-HW-005 | Phase Noise | Local oscillator phase noise shall be -90 to -100 dBc/Hz at appropriate offset frequencies. | Must have | test | None | phase_noise_range: -90 to -100 dBc/Hz |
| REQ-HW-006 | Third-Order Intercept Point | System input-referred IP3 (IIP3) shall be 10-20 dBm. | Must have | test | REQ-HW-001 | iip3_range: 10-20 dBm |
| REQ-HW-012 | Instantaneous Bandwidth | Receiver shall support instantaneous bandwidth of minimum 1 GHz with target of 2 GHz for signal capture. | Must have | test | REQ-HW-001 | min_bw: 1 GHz, target_bw: 2 GHz |

### 3.3 Interface Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-007 | Custom CMOS Output Interface | Digitized output shall be provided via custom CMOS interface compatible with FPGA input requirements. | Must have | demonstration | None | interface_type: custom_cmos |
| REQ-HW-008 | FPGA Data Interface | Receiver shall include required FPGA to process digitized signals from the ADC via custom CMOS interface. | Must have | demonstration | REQ-HW-007 | interface_type: custom_cmos |
| REQ-HW-013 | RF Input Connector | RF input shall use 2.4mm female connector suitable for 5-18 GHz operation. | Should have | inspection | REQ-HW-001 | connector_type: 2.4mm_female |

### 3.4 Environmental Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-009 | Operating Temperature Range | Receiver shall operate continuously over industrial temperature range of -40°C to +85°C. | Must have | test | None | temp_min: -40C, temp_max: +85C |
| REQ-HW-011 | MIL-STD-883 Compliance | Design and component selection shall comply with MIL-STD-883 requirements for military applications. | Must have | inspection | REQ-HW-009 | standard: MIL-STD-883 |

### 3.5 Constraint Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-010 | Power Consumption | Total receiver power consumption shall be within 10-20W budget. | Must have | test | None | power_min: 10W, power_max: 20W |
