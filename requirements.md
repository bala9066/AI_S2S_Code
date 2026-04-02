# Hardware Requirements
## rfff

## 1. Project Summary

28V GaN-based RF power amplifier delivering 40 dBm (10W) CW output power at 2.4 GHz with 30 dB gain, designed for continuous wave operation in industrial temperature range (−40 to 85°C) using a fully integrated PA module approach.

## 2. Design Parameters

| Parameter | Value |
|---|---|
| Center Frequency | 2.4 GHz |
| Bandwidth | 100 MHz (2.4-2.5 GHz) |
| Output Power | 40 dBm (10W) |
| Gain | 30 dB minimum |
| Supply Voltage | 28V DC ±10% |
| Supply Current Max | 2.5A |
| Technology | GaN (Gallium Nitride) |
| Signal Type | CW (continuous wave) |
| Operating Temp | −40°C to +85°C |
| Input Impedance | 50 ohms |
| Output Impedance | 50 ohms |
| Efficiency Target | PAE ≥40% |
| Harmonics | ≤−30 dBc (2nd/3rd) |
| Integration Level | Fully integrated PA module |
| Thermal Resistance Max | 2°C/W heatsink |

## 3. Requirements

### 3.1 Performance Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-001 | Output Power | The PA shall deliver minimum 40 dBm (10W) output power at 2.4 GHz CW operation. | Must have | test | None | GaN technology required |
| REQ-HW-002 | Gain | The PA shall provide minimum 30 dB small-signal gain across 2.4–2.5 GHz band. | Must have | test | None | None |
| REQ-HW-003 | Operating Frequency | Center frequency shall be 2.4 GHz with minimum 100 MHz bandwidth for 2.4–2.5 GHz ISM band operation. | Must have | test | None | None |
| REQ-HW-005 | Power Supply | The PA shall operate from single 28V DC supply rail with ±10% tolerance. | Must have | test | None | None |
| REQ-HW-006 | DC Current | Maximum quiescent DC current shall not exceed 2.5A at 28V for thermal budget compliance. | Should have | test | None | None |
| REQ-HW-007 | PAE | Power-added efficiency shall be minimum 40% at 40 dBm output power. | Should have | test | None | None |
| REQ-HW-014 | Harmonic Suppression | Second and third harmonic levels shall be ≤−30 dBc relative to fundamental carrier. | Should have | test | None | None |

### 3.2 Functional Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-004 | Modulation Support | The PA shall support continuous wave (CW) signal operation without signal degradation. | Must have | demonstration | None | None |
| REQ-HW-011 | RF Enable/Shutdown | The PA shall include a TTL-compatible enable/shutdown control pin for power-up sequencing. | Should have | test | None | None |
| REQ-HW-013 | Input/Output Matching | Fully integrated module shall include internal input and output matching networks optimized for 2.4 GHz. | Must have | inspection | None | None |
| REQ-HW-016 | Overvoltage Protection | The PA shall include reverse polarity protection and input overvoltage clamping to 32V. | Should have | test | None | None |

### 3.3 Environmental Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-008 | Operating Temperature | The PA shall maintain full specifications over −40°C to +85°C ambient temperature range. | Must have | test | None | None |
| REQ-HW-012 | Thermal Management | The PA module shall be mounted on heatsink with thermal resistance ≤2°C/W to maintain junction temperature below 150°C at 85°C ambient. | Must have | analysis | None | Heatsink required, Thermal interface material required |

### 3.4 Interface Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-009 | RF Input Interface | Input RF port shall be 50-ohm matched with SMA edge-launch connector or compatible footprint. | Must have | inspection | None | None |
| REQ-HW-010 | RF Output Interface | Output RF port shall be 50-ohm matched with SMA edge-launch connector or compatible footprint. | Must have | inspection | None | None |

### 3.5 Constraint Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-015 | Component Lifecycle | All active components shall be RoHS compliant and have production status 'Active' with minimum 5-year lifecycle forecast. | Must have | inspection | None | None |
