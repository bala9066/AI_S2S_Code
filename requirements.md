# Hardware Requirements
## receiver

## 1. Project Summary

Wideband RF receiver covering 5-18 GHz frequency range for communications applications. Portable benchtop form factor with digital I/Q output, featuring 3-5 dB noise figure and 20-30 dBm input power handling capability. Includes return loss specifications for RF input and output matching.

## 2. Design Parameters

| Parameter | Value |
|---|---|
| Center Frequency Mhz | 11500 |
| Frequency Range Mhz | 5000-18000 |
| Bandwidth Mhz | 13000 |
| System Noise Figure Db | 3-5 |
| Input Power Range Dbm | -90 to +30 |
| Max Input Power Dbm | 30 |
| System Gain Db | 40-70 |
| Iip3 Dbm | >= 20 |
| Lo Frequency Range Mhz | 5000-18000 |
| Lo Phase Noise Dbc Hz | -100 @ 100kHz |
| Output Interface | Digital I/Q |
| Adc Resolution Bits | >= 12 |
| Adc Sample Rate Msp | >= 200 |
| Control Interface | SPI |
| Rf Input Connector | SMA female 50Ω |
| Input Return Loss Db | ≥ 10 (5-18 GHz) |
| Output Return Loss Db | ≥ 10 |
| Operating Temperature C | 0 to +50 |
| Storage Temperature C | -40 to +85 |
| Supply Voltage | +12V DC ±10% |
| Max Power W | 15 |
| Form Factor | Portable benchtop |
| Dimensions Mm | ≤ 200 x 150 x 50 |
| Weight Kg | < 2.0 |
| Compliance | RoHS 3, FCC Part 15B, EN 55032 Class B |

## 3. Requirements

### 3.1 Functional Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-001 | Frequency Range | The receiver shall operate across the 5-18 GHz frequency band with no gaps in coverage. | Must have | test | None | None |
| REQ-HW-007 | Gain Control | The receiver shall provide at least 30 dB of gain adjustment range in 1 dB steps via digital control. | Should have | test | None | SPI control interface |
| REQ-HW-009 | Local Oscillator | The receiver shall include a frequency synthesizer providing LO signals from 5-18 GHz with phase noise better than -100 dBc/Hz at 100 kHz offset. | Must have | test | None | Frequency resolution <= 1 MHz |
| REQ-HW-014 | RF Limiter Protection | The receiver shall include an RF limiter at the input to protect downstream components from excessive input power. | Must have | test | None | Activation threshold < 15 dBm, Recovery time < 1 µs |

### 3.2 Performance Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-002 | Noise Figure | The receiver shall achieve a system noise figure of 3-5 dB across the 5-18 GHz band. | Must have | test | REQ-HW-001 | Includes contributions from all RF front-end stages |
| REQ-HW-003 | Input Power Handling | The receiver shall accept input signal levels from -90 dBm to +30 dBm without damage. | Must have | test | REQ-HW-014 | CW signal, 25°C ambient |
| REQ-HW-004 | Maximum Input Power | The receiver shall withstand +30 dBm CW input power at the RF input port for at least 5 minutes without permanent damage. | Must have | test | None | At any frequency within 5-18 GHz band |
| REQ-HW-008 | Input Third-order Intercept Point | The receiver shall achieve an input-referred third-order intercept point (IIP3) of at least 20 dBm. | Should have | test | REQ-HW-001 | Measured at maximum gain setting |
| REQ-HW-015 | Gain Flatness | The receiver gain shall vary by no more than ±3 dB across the entire 5-18 GHz frequency band. | Should have | test | REQ-HW-001, REQ-HW-007 | Measured at any gain setting |
| REQ-HW-019 | Input Return Loss | The RF input port shall achieve a minimum return loss of 10 dB across the 5-18 GHz operating band. | Must have | test | REQ-HW-001, REQ-HW-005 | 50-ohm reference impedance, Includes connector and internal matching |
| REQ-HW-020 | Output Return Loss | The RF signal path output (to mixer) shall maintain a minimum return loss of 10 dB to ensure proper impedance matching. | Should have | test | REQ-HW-001 | 50-ohm reference impedance, At mixer RF input port |

### 3.3 Interface Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-005 | RF Input Connector | The receiver shall provide a 50-ohm SMA female connector for the RF input. | Must have | inspection | None | Impedance: 50 ohms |
| REQ-HW-006 | Digital I/Q Output | The receiver shall provide digital I/Q output data streams with at least 12-bit resolution per channel. | Must have | test | None | CMOS or LVDS interface levels, Sample rate >= 200 MSPS |
| REQ-HW-010 | Control Interface | The receiver shall provide an SPI interface for configuration and control of gain, LO frequency, and operational settings. | Must have | test | None | Standard SPI mode 0-3, Max clock rate 10 MHz |
| REQ-HW-012 | Power Supply | The receiver shall operate from a single +12V DC power supply with a maximum power consumption of 15W. | Must have | test | None | Voltage tolerance ±10% |
| REQ-HW-016 | Clock Output | The receiver may provide a buffered output of the sampling clock or reference clock for external synchronization. | Could have | test | None | SMA connector, AC-coupled |

### 3.4 Environmental Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-011 | Operating Temperature | The receiver shall operate over a temperature range of 0°C to +50°C. | Must have | test | None | All specifications valid over full temperature range |

### 3.5 Constraint Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-013 | Form Factor | The receiver shall be packaged in a portable benchtop enclosure with dimensions not exceeding 200mm x 150mm x 50mm. | Must have | inspection | None | Weight < 2 kg, Include cooling vents |
| REQ-HW-017 | EMC Compliance | The receiver shall comply with applicable EMC standards for radiated and conducted emissions. | Must have | test | None | FCC Part 15 Subpart B, EN 55032 Class B |
| REQ-HW-018 | RoHS Compliance | The receiver shall comply with RoHS 3 Directive 2011/65/EU and its amendments. | Must have | inspection | None | All components and assembly processes |
