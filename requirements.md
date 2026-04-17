# Hardware Requirements
## receiver

## 1. Project Summary

Wideband RF receiver covering 5-18 GHz frequency range with digital I/Q output. Designed for desktop form factor with industrial temperature operation. Provides 40-60 dB gain, 6-10 dB noise figure, and 20-30 dBm IP3 for signals from -30 to -10 dBm input power.

## 2. Design Parameters

| Parameter | Value |
|---|---|
| Frequency Range | 5-18 GHz |
| Noise Figure | 6-10 dB |
| Gain | 40-60 dB |
| Input Power Range | -30 to -10 dBm |
| Ip3 | 20-30 dBm (input) |
| Output Format | Digital I/Q |
| Temperature Range | -40 to +85°C |
| Form Factor | Desktop/benchtop |
| Power Supply | Custom (+12V, +5V, +3.3V, -5V rails) |
| Input Connector | 2.4mm female (50Ω) |
| Adc Resolution | 12-bit minimum |
| Sample Rate | ≥ 500 MSPS |

## 3. Requirements

### 3.1 Functional Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-001 | Frequency Range | Receiver shall operate from 5 GHz to 18 GHz continuous coverage. | Must have | test | None | None |
| REQ-HW-009 | Power Supply | Receiver shall operate from custom power supply input. | Must have | inspection | None | Voltage rails to be determined based on component selection, Require +12V, +5V, +3.3V, -5V typical for RF design |
| REQ-HW-012 | Gain Control Interface | Receiver shall provide digital gain control interface (SPI or parallel). | Must have | test | REQ-HW-003 | SPI preferred for minimal pin count, Gain setting latency ≤ 1 µs |

### 3.2 Performance Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-002 | Noise Figure | System noise figure shall be 6-10 dB across the full 5-18 GHz band. | Must have | test | REQ-HW-001 | Cascaded NF calculated via Friis formula |
| REQ-HW-003 | Gain Range | Receiver shall provide 40-60 dB of configurable gain. | Must have | test | REQ-HW-001 | Gain flatness ±3 dB across band, Digital gain control in 1 dB steps |
| REQ-HW-004 | Input Power Range | Receiver shall accept input signals from -30 dBm to -10 dBm without degradation. | Must have | test | None | Include 10 dB margin above maximum input |
| REQ-HW-005 | Third-Order Intercept Point | Input IP3 shall be 20-30 dBm across operating frequency range. | Must have | test | REQ-HW-001 | OIP3 = IIP3 + Gain |
| REQ-HW-010 | Input Return Loss | Input VSWR shall be ≤ 2.0:1 (return loss ≥ 10 dB) across 5-18 GHz. | Should have | test | REQ-HW-001 | Achieved via input matching network |
| REQ-HW-013 | Phase Noise | Local oscillator phase noise shall be ≤ -100 dBc/Hz at 10 kHz offset. | Should have | test | None | Affects ADC SNR and reciprocal mixing performance |
| REQ-HW-015 | Image Rejection | Image rejection shall be ≥ 60 dB for downconversion architecture. | Should have | test | None | Achieved via RF/IF filtering or image-reject mixer |

### 3.3 Interface Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-006 | Digital I/Q Output | Receiver shall provide digital I/Q output from ADC. | Must have | test | None | Minimum 12-bit resolution, Sample rate ≥ 500 MSPS for Nyquist coverage |
| REQ-HW-011 | RF Input Connector | RF input shall use 2.4mm female connector for 5-18 GHz coverage. | Must have | inspection | None | 2.4mm or 2.92mm (K) connector rated to 18 GHz+, 50 ohm impedance |

### 3.4 Environmental Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-007 | Operating Temperature | Receiver shall operate from -40°C to +85°C (industrial temperature range). | Must have | test | None | All components rated for -40°C to +85°C minimum |

### 3.5 Constraint Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-008 | Form Factor | Receiver shall fit within desktop enclosure form factor. | Must have | inspection | None | Standard 19-inch rack or benchtop enclosure, PCB dimensions ≤ 6U × 160mm Eurocard format |

### 3.6 Compliance Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-014 | RoHS Compliance | All components shall be RoHS 2011/65/EU compliant. | Must have | inspection | None | Lead-free solder compatible, No banned substances |
