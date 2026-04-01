# Hardware Requirements
## rf78

## 1. Project Summary

2.4 GHz Bluetooth RF power amplifier module with integrated driver stage, delivering 40 dBm (10 W) output from 28 V supply, operating over –40 to +85°C industrial temperature range, with VSWR protection.

## 2. Design Parameters

| Parameter | Value |
|---|---|
| Center Frequency | 2.4 GHz |
| Bandwidth | 83.5 MHz (2.400–2.4835 GHz) |
| Output Power | +40 dBm (10 W) |
| Supply Voltage | 28 V DC ±10% |
| Supply Current Estimate | 1.5 to 2.0 A at 28 V (42–56 W) assuming 30–35% PAE |
| Gain | 35–40 dB (integrated driver + final PA) |
| Input Drive Level | 0 to +10 dBm |
| Modulation | Bluetooth (GFSK, π/4-DQPSK, 8DPSK) |
| Evm Target | < 3% at rated output |
| Vswr Protection Threshold | 2:1 to 3:1 configurable |
| Thermal Shutdown Threshold | +105°C PCB, auto-recover at +85°C |
| Temperature Range | –40 to +85°C ambient |
| Harmonics Limit | < –30 dBc up to 5th harmonic |

## 3. Requirements

### 3.1 Functional Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-001 | RF Output Power | The PA module shall deliver +40 dBm (10 W) nominal output power at 2.4 GHz under worst-case operating conditions. | Must have | test | 28V_SUPPLY, PA_DEVICE | Gain flatness ±1.5 dB, Power-added efficiency > 30% |
| REQ-HW-002 | Frequency Band | The PA module shall operate in the 2.400 to 2.4835 GHz ISM band. | Must have | test | None | Return loss > 10 dB |
| REQ-HW-003 | Input Drive Level | The PA module shall accept 0 to +10 dBm input drive level with integrated driver stage providing ~35–40 dB total gain. | Must have | test | DRIVER_STAGE | None |
| REQ-HW-011 | VSWR Protection | The PA module shall include VSWR monitoring with foldback protection; fault threshold shall be configurable 2:1 to 3:1. | Must have | test | DIRECTIONAL_COUPLER, RF_DETECTORS | None |
| REQ-HW-012 | Thermal Protection | Overtemperature shutdown at +105°C PCB temperature; auto-recover when below +85°C with hysteresis. | Must have | test | THERMISTOR_OR_SENSOR | None |
| REQ-HW-017 | Bias Sequencing | Bias sequencing shall ensure driver stage enables before final stage; disable sequencing reversed. | Must have | test | ENABLE_CONTROL_LOGIC | None |

### 3.2 Performance Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-004 | Gain | Small-signal gain shall be 35–40 dB from driver input to final output. | Should have | test | None | Gain flatness ±1.5 dB across band |
| REQ-HW-005 | Power-Added Efficiency | PAE shall be > 30% at rated output power under Bluetooth modulation. | Should have | test | PA_DEVICE, MATCHING_NETWORK | None |
| REQ-HW-006 | Error Vector Magnitude (EVM) | EVM contribution from PA shall be < 3% for Bluetooth modulation at rated output. | Should have | test | None | Linearity backoff applied per datasheet |
| REQ-HW-019 | Stability | Unconditional stability from 10 MHz to 6 GHz; K-factor > 1 and B1 > 0. | Must have | test | STABILITY_RESISTORS, RC_FEEDBACK | None |

### 3.3 Interface Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-007 | RF Input Interface | 50 Ohm single-ended RF input via SMA or edge-launch connector. | Must have | test | None | Return loss > 10 dB |
| REQ-HW-008 | RF Output Interface | 50 Ohm single-ended RF output via SMA or edge-launch connector. | Must have | test | None | Return loss > 10 dB, Harmonics < –30 dBc |
| REQ-HW-009 | DC Supply Interface | 28 V ±10% DC supply input with overcurrent protection and reverse-polarity protection. | Must have | test | PROTECTION_CIRCUITRY | None |
| REQ-HW-010 | Enable Control | Active-high TX enable input (3.3 V logic compatible) to bias up PA; bias sequencing ensures driver before final stage. | Must have | test | BIAS_SEQUENCING | None |
| REQ-HW-014 | Fault Indication | Open-drain active-low FAULT output for VSWR and overtemperature faults; pullup to 3.3 V. | Should have | test | LOGIC_GATE_OR | None |
| REQ-HW-020 | PCB Form Factor | Board footprint compatible with standard heatsink; mounting holes at corners; keep-out zones defined for PA device. | Should have | test | THERMAL_VIAS, HEATSINK_INTERFACE | None |

### 3.4 Environmental Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-013 | Operating Temperature Range | Full performance guaranteed over –40 to +85°C ambient. | Must have | test | None | Derating above +70°C per PA device datasheet |

### 3.5 Constraint Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-015 | Harmonic Content | Harmonics up to 5th shall be < –30 dBc at rated output. | Should have | test | LOWPASS_OUTPUT_FILTER | None |
| REQ-HW-016 | Supply Ripple Rejection | PA output shall remain stable with up to 200 mV pk-pk ripple on 28 V supply. | Should have | test | BULK_DECOUPLING, PI_FILTER | None |
| REQ-HW-018 | Output Matching Network | Output matching network optimized for 2.4 GHz center; handle >10 W peak without saturation. | Must have | test | HIGH_Q_INDUCTORS, RF_CAPACITORS | None |
