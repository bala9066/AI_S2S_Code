# Hardware Requirements
## rfgg

## 1. Project Summary

A 2.4 GHz continuous-wave RF power amplifier delivering +40 dBm (10W) output power with 12V supply, operating over -40°C to +85°C industrial temperature range for defense applications.

## 2. Design Parameters

| Parameter | Value |
|---|---|
| Center Frequency | 2.4 GHz |
| Output Power | 40 dBm (10W) |
| Gain | 40 dB minimum |
| Supply Voltage | 12V DC +/- 5% |
| Input Power | 0 dBm nominal |
| Modulation | CW (continuous wave) |
| Temperature Range | -40°C to +85°C (industrial) |
| Input Impedance | 50 ohm |
| Output Impedance | 50 ohm |
| Efficiency Target | >35% PAE |
| Harmonic Suppression | >30 dBc |
| Control Interface | TX enable pin (3.3V logic) |
| Connector Type | SMA or edge-launch |
| Thermal Dissipation | up to 20W |
| Stability | K-factor > 1 unconditional |

## 3. Requirements

### 3.1 Functional Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-001 | RF Output Power | Amplifier shall deliver +40 dBm (10W) minimum output power at 2.4 GHz under CW operation | Must have | test | REQ-HW-002 | PA_saturated_power >= 40dBm, VSWR_load <= 2:1 |
| REQ-HW-002 | Operating Frequency | Amplifier shall operate at 2.4 GHz center frequency with minimum 100 MHz bandwidth | Must have | test | None | center_frequency = 2.4GHz, bandwidth >= 100MHz |
| REQ-HW-005 | Supply Voltage | Amplifier shall operate from single 12V DC supply | Must have | test | None | Vsupply = 12V +/-5%, current_consumption <= 10A |
| REQ-HW-007 | RF Input Interface | Amplifier shall accept 0 dBm nominal input power via 50 ohm SMA or edge-launch connector | Must have | test | None | input_impedance = 50_ohm, input_return_loss >= 10dB |
| REQ-HW-008 | RF Output Interface | Amplifier shall deliver output power via 50 ohm SMA or edge-launch connector | Must have | test | REQ-HW-001 | output_impedance = 50_ohm, output_VSWR <= 2:1 |
| REQ-HW-009 | Enable/TX Control | Amplifier shall include TX enable pin for power control and bias sequencing | Must have | inspection | None | logic_high = 3.3V_compatible |
| REQ-HW-012 | Overcurrent Protection | Amplifier shall include current limit or protection against output shorts | Should have | test | REQ-HW-005 | current_limit_threshold <= 12A, response_time < 100us |
| REQ-HW-015 | RF Detector | Amplifier shall include output power detector for monitoring | Could have | test | REQ-HW-001 | detector_range = 20_to_50dBm, accuracy = +/-1dB |

### 3.2 Performance Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-003 | Power Gain | Amplifier shall provide minimum 40dB power gain from input to output | Must have | test | REQ-HW-001 | gain_flatness <= +/-1dB |
| REQ-HW-004 | Power Added Efficiency | Amplifier shall achieve minimum 35% PAE at rated output power | Should have | test | REQ-HW-001 | PAE >= 35% at Pout=40dBm |
| REQ-HW-010 | Harmonic Suppression | Amplifier output harmonics shall be suppressed by minimum 30 dBc below fundamental | Should have | test | REQ-HW-001 | harmonic_filters >= 2nd_harmonic |
| REQ-HW-014 | Stability | Amplifier shall be unconditionally stable across temperature range with K-factor > 1 | Must have | analysis | REQ-HW-006 | Rollett_stability_factor_K > 1, B1 > 0 |

### 3.3 Environmental Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-006 | Operating Temperature Range | Amplifier shall meet all specifications over -40°C to +85°C ambient temperature | Must have | test | REQ-HW-001, REQ-HW-003 | industrial_temperature_range |
| REQ-HW-013 | RoHS Compliance | All components shall be RoHS compliant | Must have | inspection | None | RoHS_2011_65_EU_compliant |

### 3.4 Constraint Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-011 | Thermal Management | Amplifier PCB shall accommodate heatsink or thermal pad for power dissipation up to 20W | Must have | analysis | REQ-HW-001, REQ-HW-006 | thermal_resistance_junction_case <= 2_C/W |
