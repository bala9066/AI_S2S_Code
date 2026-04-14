# Hardware Requirements
## rbhjdaz

## 1. Project Summary

Wideband RF receiver (5-18 GHz) for military radar electronic warfare applications. System provides 500 MHz to 2 GHz instantaneous bandwidth with 3-6 dB noise figure and 60-80 dB dynamic range. Architecture features RF front-end, selectable band filters, multi-stage downconversion to IF or direct digitization at high IF, 12-bit ADCs at up to 3 GSPS, and digital interface for signal processing. Designed for harsh environments with military-grade components and MIL-STD compliance.

## 2. Design Parameters

| Parameter | Value |
|---|---|
| Rf Frequency Range Min | 5.0 GHz |
| Rf Frequency Range Max | 18.0 GHz |
| Instantaneous Bandwidth Min | 500 MHz |
| Instantaneous Bandwidth Max | 2.0 GHz |
| Noise Figure Target | 3-6 dB |
| Dynamic Range Sfdr | 60-80 dB |
| Input Power Min | -80 dBm |
| Input Power Max | +20 dBm |
| Input Protection | +30 dBm CW, 100 W pulsed 1 µs |
| Gain Control Range | 60 dB |
| Adc Resolution | 12 bits |
| Adc Sample Rate Max | 3.0 GSPS |
| Input Supply | +28 VDC military |
| Power Budget Max | 50 W |
| Operating Temp Min | -40 C |
| Operating Temp Max | +85 C |
| Lo Phase Noise | -100 dBc/Hz @ 1 kHz |
| Image Rejection | >60 dB |
| Gain Flatness | +/-2 dB per 2 GHz IBW |

## 3. Requirements

### 3.1 Functional Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-001 | RF Input Frequency Range | Receiver shall accept RF input signals from 5.0 GHz to 18.0 GHz. | Must have | test | None | None |
| REQ-HW-005 | Input Power Handling | Receiver shall accept input signal levels from -80 dBm to +20 dBm without damage or degradation. | Must have | test | None | None |
| REQ-HW-007 | Frequency Downconversion | System shall downconvert 5-18 GHz RF to a digitizable IF (direct sampling or multi-stage conversion). | Must have | inspection | None | None |
| REQ-HW-013 | Reference Clock Input | System shall accept an external 10 MHz reference clock input (50 Ω, sinusoidal or CMOS). | Must have | test | None | None |
| REQ-HW-020 | RF Input Connector | RF input port shall use SMA-50 or 2.4mm precision connector for 18 GHz operation. | Must have | inspection | None | None |
| REQ-HW-021 | Input Protection | RF input shall include limiter/protection to survive +30 dBm CW and 100 W pulsed (1 µs). | Must have | test | None | None |
| REQ-HW-024 | Self-Test Capability | Receiver shall include built-in self-test (BIST) for power supply, LO lock, and ADC validity. | Should have | test | None | None |

### 3.2 Performance Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-002 | Instantaneous Bandwidth | Receiver shall support instantaneous signal bandwidths from 500 MHz to 2.0 GHz, digitally configurable. | Must have | test | None | None |
| REQ-HW-003 | Noise Figure | System noise figure shall be 3.0 dB to 6.0 dB across the 5-18 GHz operating band. | Must have | test | None | None |
| REQ-HW-004 | Dynamic Range | Receiver shall provide 60-80 dB spurious-free dynamic range (SFDR) across instantaneous bandwidth. | Must have | test | None | None |
| REQ-HW-006 | Gain Control Range | Receiver shall provide at least 60 dB of electronic gain control in 1 dB steps. | Must have | test | None | None |
| REQ-HW-008 | Phase Noise | LO phase noise shall be better than -100 dBc/Hz at 1 kHz offset across the band. | Should have | test | None | None |
| REQ-HW-009 | Image Rejection | Image rejection shall exceed 60 dB across all operating bands. | Should have | test | None | None |
| REQ-HW-022 | Gain Flatness | Gain flatness shall be ±2 dB across any 2 GHz instantaneous bandwidth. | Should have | test | None | None |

### 3.3 Interface Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-010 | ADC Resolution and Sample Rate | Digitizer shall use 12-bit ADCs sampling at up to 3.0 GSPS to support 2 GHz IBW. | Must have | inspection | None | None |
| REQ-HW-011 | Digital Output Interface | ADC data shall be output via parallel LVDS or JESD204B/C interfaces to DSP/FPGA. | Must have | inspection | None | None |
| REQ-HW-012 | Control Interface | Receiver configuration (gain, frequency, filters) shall be programmable via SPI interface. | Must have | test | None | None |
| REQ-HW-023 | LO Input Option | System shall optionally accept external LO input for coherent multi-receiver operation. | Could have | inspection | None | None |

### 3.4 Power Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-014 | Input Power Supply | Primary input shall be +28 VDC military supply with transient protection. | Must have | test | None | None |
| REQ-HW-015 | Power Consumption | Total power consumption shall not exceed 50 W during continuous operation. | Should have | test | None | None |

### 3.5 Environmental Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-016 | Operating Temperature | Receiver shall operate from -40°C to +85°C ambient per MIL-STD-810. | Must have | test | None | None |
| REQ-HW-017 | Vibration and Shock | Design shall withstand vibration and shock per MIL-STD-810G. | Must have | test | None | None |
| REQ-HW-018 | EMC/EMI Compliance | System shall meet MIL-STD-461 electromagnetic emission and susceptibility requirements. | Must have | test | None | None |

### 3.6 Constraint Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-019 | Component Availability | All critical components shall have documented availability of 10+ years or be military-qualified (883/B). | Should have | inspection | None | None |
