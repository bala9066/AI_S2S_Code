# Hardware Requirements
## rf tx

## 1. Project Summary

Wideband microwave receiver covering 5-18 GHz (C through Ku bands) for continuous wave (CW) signal detection and measurement. System provides 60-80 dB dynamic range, 6-10 dB noise figure, and kHz-level frequency tuning resolution with UART control interface. Architecture uses wideband superheterodyne downconversion to 2.4 GHz IF with digital signal processing via FPGA for CW detection, frequency measurement, and amplitude analysis.

## 2. Design Parameters

| Parameter | Value |
|---|---|
| Frequency Range Min Hz | 5000000000 |
| Frequency Range Max Hz | 18000000000 |
| If Frequency Hz | 2400000000 |
| Lo Frequency Range Hz | 7400000000-20400000000 |
| Tuning Resolution Hz | 10000 |
| Noise Figure Db Max | 10 |
| Noise Figure Db Target | 6 |
| Dynamic Range Db Min | 60 |
| Dynamic Range Db Target | 80 |
| Signal Type | CW (Continuous Wave) |
| Input Impedance Ohm | 50 |
| Rf Connector | SMA female 18GHz |
| Supply Voltage V | 12 |
| Operating Temperature C | -40 to +85 |
| Control Interface | UART 115200 8N1 |
| Adc Sampling Rate Msps | 4000 |
| Adc Resolution Bits | 12 |
| Fpga Dsp Slices | 600+ |
| Fpga Logic Cells | 50000+ |

## 3. Requirements

### 3.1 Functional Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-001 | RF Input Frequency Range | System shall accept RF input signals from 5.0 GHz to 18.0 GHz. | Must have | test | None | 50 ohm input impedance |
| REQ-HW-005 | Signal Type Compatibility | System shall detect and process continuous wave (CW) signals. | Must have | test | None | None |
| REQ-HW-007 | Downconversion Architecture | System shall use superheterodyne downconversion to 2.4 GHz intermediate frequency. | Must have | inspection | None | None |
| REQ-HW-008 | Local Oscillator Generation | LO shall cover 7.4-20.4 GHz with phase noise better than -100 dBc/Hz at 100 kHz offset. | Must have | test | REQ-HW-002 | None |
| REQ-HW-009 | Gain Control Range | System shall provide at least 40 dB of gain control via digital VGA. | Must have | test | None | Step size: 1 dB |
| REQ-HW-019 | FPGA Signal Processing | FPGA shall perform digital downconversion, CW detection, frequency measurement, and amplitude detection. | Must have | demonstration | REQ-HW-015 | None |
| REQ-HW-020 | CW Detection Mode | FPGA shall provide configurable CW detection with FFT-based frequency analysis and power measurement. | Must have | demonstration | None | None |

### 3.2 Performance Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-002 | Frequency Tuning Resolution | System shall provide frequency tuning resolution of 10 kHz or better across the 5-18 GHz range. | Must have | test | None | None |
| REQ-HW-003 | Noise Figure | System noise figure shall not exceed 10 dB (target 6 dB) from RF input to IF output. | Must have | test | None | None |
| REQ-HW-004 | Dynamic Range | System shall provide minimum 60 dB dynamic range with target of 80 dB for CW signal detection. | Must have | test | None | None |
| REQ-HW-013 | Power Consumption | Total power consumption shall not exceed 15W. | Should have | test | None | None |
| REQ-HW-014 | Input Third-Order Intercept (IIP3) | System input IP3 shall be better than +10 dBm. | Could have | test | None | None |
| REQ-HW-017 | Input Return Loss | RF input return loss shall be better than 10 dB across 5-18 GHz. | Should have | test | None | None |
| REQ-HW-018 | LO Leakage Suppression | LO leakage at RF input port shall be suppressed to below -60 dBm. | Should have | test | None | None |

### 3.3 Interface Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-006 | RF Input Connector | RF input shall use SMA female connector rated for operation to at least 18 GHz. | Must have | inspection | None | VSWR < 2.0:1 |
| REQ-HW-010 | UART Control Interface | System shall provide UART interface at 115200 baud for frequency tuning, gain control, and status readback. | Must have | test | None | 8N1 format, 3.3V logic levels |
| REQ-HW-015 | IF Output Interface | System shall digitize IF at 2.4 GHz using 12-bit ADC and provide digital I/Q data to FPGA. | Must have | test | REQ-HW-007 | None |

### 3.4 Environmental Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-011 | Operating Temperature Range | System shall operate from -40C to +85C. | Should have | test | None | None |
| REQ-HW-016 | RF Shielding Requirements | RF sections shall be properly shielded to minimize EMI and LO leakage. | Should have | inspection | None | None |

### 3.5 Constraint Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-012 | Supply Voltage Requirements | System shall operate from single +12V DC supply input. | Must have | test | None | Voltage range: 11-14V DC |
