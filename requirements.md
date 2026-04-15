# Hardware Requirements
## uyj

## 1. Project Summary

Wideband RF receiver system covering 5-18 GHz with 1-4 GHz instantaneous bandwidth, direct RF digitization at 2-5 GSps (10-bit), and FPGA-based signal processing. Target applications include electronic warfare, SIGINT, or communications interception requiring high dynamic range and wide spectral coverage.

## 2. Design Parameters

| Parameter | Value |
|---|---|
| Center Frequency Mhz | 11500 |
| Tuning Range Mhz | 5000-18000 |
| Instantaneous Bandwidth Mhz | 1000-4000 |
| Frequency Resolution Mhz | 100 |
| Input Power Range Dbm | -50 to +10 |
| Noise Figure Db | <6.0 |
| Iip3 Dbm | +20 to +30 |
| Adc Sample Rate Gsps | 2-5 |
| Adc Resolution Bits | 10 |
| Supply Voltage V | 12 |
| Max Power W | 50 |
| Operating Temp C | -40 to +85 |
| Output Interface | UART |
| Fpga Required | Yes |
| Input Impedance Ohm | 50 |

## 3. Requirements

### 3.1 Functional Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-001 | Frequency Coverage | Receiver shall continuously tune across 5.0 GHz to 18.0 GHz frequency range with minimum frequency resolution of 100 MHz. | Must have | test | None | None |
| REQ-HW-002 | Instantaneous Bandwidth | Receiver shall support programmable instantaneous bandwidth from 1.0 GHz to 4.0 GHz. | Must have | test | None | None |
| REQ-HW-010 | FPGA Signal Processing | Receiver shall incorporate FPGA for real-time digital signal processing including DDC, filtering, and packetization. | Must have | demonstration | REQ-HW-006, REQ-HW-007 | JESD204B IP core, PCIe Gen3 x4 or DDR4 buffer |
| REQ-HW-014 | DC Offset Correction | Receiver shall implement automatic DC offset correction to compensate for ADC DC offsets and LO leakage. | Should have | demonstration | REQ-HW-010 | FPGA or ADC internal |

### 3.2 Performance Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-003 | Input Dynamic Range | Receiver shall accept input signal levels from -50 dBm to +10 dBm without damage or performance degradation. | Must have | test | None | input protection, LNA protection |
| REQ-HW-004 | Noise Figure | Overall receiver noise figure shall not exceed 6.0 dB across the entire 5-18 GHz operating band. | Must have | test | None | cascaded NF calculation |
| REQ-HW-005 | Linearity - IP3 | Receiver input third-order intercept point (IIP3) shall be +20 to +30 dBm to ensure adequate intermodulation performance. | Must have | test | None | OIP3 >= IIP3 + gain |
| REQ-HW-006 | ADC Sample Rate | ADC shall support programmable sampling rates from 2.0 GSps to 5.0 GSps. | Must have | test | None | JESD204B/C interface, clock jitter < 200 fs |
| REQ-HW-007 | ADC Resolution | ADC shall provide minimum 10-bit effective resolution at maximum sample rate. | Must have | test | REQ-HW-006 | ENOB > 8.5 bits at Nyquist |
| REQ-HW-009 | Power Consumption | Total receiver system power consumption shall not exceed 50W from 12V supply under worst-case operating conditions (maximum sample rate, full bandwidth). | Must have | test | None | 12V single rail, thermal management |
| REQ-HW-013 | Gain Control Range | Receiver shall provide minimum 40 dB of programmable gain adjustment in 1 dB steps. | Should have | test | None | digital VGA or DSA |
| REQ-HW-017 | Phase Noise | Local oscillator phase noise shall not exceed -100 dBc/Hz at 10 kHz offset from carrier across tuning range. | Could have | test | None | affects EVM and SNR |

### 3.3 Interface Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-008 | Digital Output Interface | Receiver shall provide UART control and status interface at standard baud rates (9600 to 115200 bps). | Must have | test | None | 3.3V CMOS levels, configurable 8N1 format |

### 3.4 Environmental Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-011 | Operating Temperature Range | Receiver shall meet all performance specifications over -40°C to +85°C operating temperature range. | Must have | test | None | industrial temperature grade components, derating required |
| REQ-HW-012 | Input Impedance | RF input shall present 50-ohm impedance with VSWR ≤ 2.0:1 across 5-18 GHz band. | Should have | test | None | SMA or 2.4mm connector |

### 3.5 Constraint Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-015 | Supply Voltage | System shall operate from single 12V DC supply input with protection against reverse polarity and over-voltage. | Must have | inspection | None | input protection circuitry, EMI filtering |
| REQ-HW-016 | Component Availability | All components shall be RoHS compliant and have active status with minimum 5-year lifecycle projection. | Must have | inspection | None | no VPT brand components, prefer major manufacturers |
