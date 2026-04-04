# Hardware Requirements
## tf

## 1. Project Summary

A 2.4 GHz continuous-wave (CW) RF power amplifier delivering +40 dBm (10W) output power from a +10 dBm input using a 12V supply. Operating temperature range is -40°C to +85°C industrial. Design includes 50-ohm input/output matching, temperature compensation, and enable control for defense-industrial applications.

## 2. Design Parameters

| Parameter | Value |
|---|---|
| Center Frequency | 2.4 GHz |
| Bandwidth | 100 MHz (2.4-2.5 GHz) |
| Output Power | 40 dBm (10 W) |
| Input Power | 10 dBm |
| Required Gain | 30 dB |
| Supply Voltage | 12 V DC ±10% |
| Max Current | 3 A |
| Efficiency Target | 45% PAE minimum |
| Input Impedance | 50 ohms |
| Output Impedance | 50 ohms |
| Vswr Max | 2.0:1 |
| Harmonic Suppression | 30 dBc minimum |
| Operating Temp | -40°C to +85°C |
| Storage Temp | -55°C to +125°C |
| Modulation | CW (continuous wave) |
| Enable Logic | TTL 3.3V/5V compatible |
| Rf Connectors | SMA female 50-ohm |
| Pcb Material | Rogers RO4350B or equivalent high-frequency laminate |

## 3. Requirements

### 3.1 Performance Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-001 | Output Power | Amplifier shall deliver minimum +40 dBm (10W) output power at 2.4 GHz CW under all operating conditions. | Must have | test | None | P1dB > 40 dBm, 3 dB compression point required |
| REQ-HW-002 | Gain | Amplifier shall provide minimum 30 dB power gain from +10 dBm input to +40 dBm output. | Must have | test | None | Gain flatness ±1.5 dB across 2.4-2.5 GHz |
| REQ-HW-005 | Power Added Efficiency | Amplifier shall achieve minimum 45% PAE at +40 dBm output. | Should have | test | REQ-HW-001 | None |
| REQ-HW-010 | Harmonic Suppression | Output harmonics (2nd, 3rd) shall be attenuated by minimum 30 dBc relative to fundamental. | Should have | test | REQ-HW-001 | Post-match filtering recommended |

### 3.2 Functional Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-003 | Operating Frequency | Amplifier shall operate at 2.4 GHz center frequency with 2.4-2.5 GHz bandwidth. | Must have | test | None | ISM band operation |
| REQ-HW-004 | Supply Voltage | Amplifier shall operate from 12V DC supply with ±10% tolerance. | Must have | test | None | Maximum current draw 3A |
| REQ-HW-009 | Enable Control | Amplifier shall include high-impedance TTL-compatible enable pin (logic high = on, logic low = shutdown). | Must have | test | None | Turn-on time ≤ 10 µs, Turn-off time ≤ 5 µs |
| REQ-HW-015 | Reverse Isolation | Amplifier shall provide minimum 20 dB reverse isolation to protect source from load reflections. | Should have | test | REQ-HW-007 | None |

### 3.3 Environmental Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-006 | Operating Temperature | Amplifier shall meet all specifications over -40°C to +85°C ambient temperature range. | Must have | test | None | Industrial temperature grade, Derating above +70°C |
| REQ-HW-011 | Thermal Protection | Amplifier shall include thermal shutdown protection that disables output when die temperature exceeds +150°C. | Must have | test | REQ-HW-006 | Auto-recovery when cooled |
| REQ-HW-014 | EMC Compliance | Amplifier shall meet EN 55032 Class B emissions limits when operated within specified conditions. | Could have | test | None | Shielding may be required |

### 3.4 Interface Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-007 | Impedance Matching | Input and output ports shall be matched to 50-ohm impedance with VSWR ≤ 2.0:1. | Must have | test | None | Return loss ≥ 10 dB |
| REQ-HW-008 | RF Connectors | RF input and output shall use SMA female connectors (50 ohm, flush mount). | Must have | inspection | None | Gold-plated contacts, Through-hole PCB mount |
| REQ-HW-013 | Power Supply Connector | DC input shall use a 2-pin terminal block or Molex Mini-Fit Jr connector rated for 5A minimum. | Should have | inspection | REQ-HW-004 | Polarized keying, 10-32 AWG support |

### 3.5 Constraint Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-012 | Component Lifecycle | All active components shall be RoHS-compliant with production status NOT set to NRND (Not Recommended for New Design) or EOL. | Must have | inspection | None | Defense-industry sourcing guidelines |
