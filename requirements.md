# Hardware Requirements
## rffff

## 1. Project Summary

High-power RF transmit system using Artix-7 FPGA generating wideband signals from 5-10GHz with 40dBm (10W) continuous output power. System operates from 110V AC mains, converts to 12V DC via isolated AC/DC supply, then uses buck converters to power FPGA and RF chain. Designed for industrial temperature range (-40 to +85°C) with FCC/CE compliance considerations.

## 2. Design Parameters

| Parameter | Value |
|---|---|
| Rf Frequency Range | 5-10 GHz continuous |
| Rf Output Power | 40 dBm (10W) minimum |
| Fpga Family | Xilinx Artix-7 |
| Ac Input Voltage | 110V AC, 50/60Hz |
| Dc Bus Voltage | 12V DC |
| Power Budget Estimate | 150-200W total (10W RF output + PA inefficiency + FPGA + aux) |
| Temperature Range | -40 to +85°C (Industrial) |
| Compliance | FCC Part 15, CISPR 32 Class A |
| Pa Topology | Single wideband PA 5-10GHz |
| System Architecture | Transmit-only |

## 3. Requirements

### 3.1 Functional Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-001 | RF Output Frequency Range | System shall generate RF output signals covering continuous frequency range from 5GHz to 10GHz. | Must have | test | None | Wideband PA bandwidth >= 5GHz, Flatness requirements TBD |
| REQ-HW-003 | FPGA Signal Generation | System shall use Xilinx Artix-7 FPGA to generate baseband or IF signals for RF transmission. | Must have | demonstration | DAC interface required | None |
| REQ-HW-004 | Signal Upconversion | System shall upconvert FPGA-generated signals to 5-10GHz RF output frequency using appropriate mixer architecture. | Must have | test | None | Local oscillator 5-10GHz required, Image rejection filtering |
| REQ-HW-005 | Main Power Input | System shall accept 110V AC mains input power at 50/60Hz. | Must have | test | None | Safety isolation required, EMI filtering per FCC/CE |
| REQ-HW-006 | AC/DC Power Conversion | System shall convert 110V AC to 12V DC using isolated AC/DC power supply module. | Must have | test | None | Isolation voltage >2500VAC, Power rating >150W to support 10W RF + system overhead |
| REQ-HW-007 | Buck Converter - FPGA Core | System shall provide regulated 1.0V (or Artix-7 VCCINT requirement) via buck converter for FPGA core logic. | Must have | test | 12V input bus | None |
| REQ-HW-008 | Buck Converter - FPGA I/O and Aux | System shall provide regulated voltages (1.2V, 1.8V, 2.5V, 3.3V) via buck converters for FPGA I/O banks and auxiliary circuits. | Must have | test | 12V input bus | None |
| REQ-HW-009 | Buck Converter - RF Chain | System shall provide regulated positive and negative voltages (typically +5V, -5V, +3.3V) via buck converters for RF amplifiers, mixers, and DAC. | Must have | test | 12V input bus | None |
| REQ-HW-013 | RF Output Connector | System shall provide 50-ohm RF output connector (SMA, 2.92mm, or N-type) suitable for 5-10GHz operation. | Must have | inspection | None | None |
| REQ-HW-017 | High-Speed DAC Interface | System shall include high-speed DAC (>= 1 GSPS) with JESD204B or parallel interface to Artix-7 FPGA. | Must have | test | FPGA transceiver or LVDS banks | None |
| REQ-HW-018 | Local Oscillator Generation | System shall generate tunable LO signal covering 5-10GHz range for upconversion. | Must have | test | None | Phase noise requirements TBD based on modulation |

### 3.2 Performance Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-002 | RF Output Power | System shall deliver minimum 40dBm (10W) output power across the 5-10GHz frequency range. | Must have | test | None | Requires PA with >40dBm Psat, Thermal management for 10W+ dissipation |
| REQ-HW-010 | Industrial Temperature Range | System shall operate reliably across industrial temperature range of -40°C to +85°C ambient. | Must have | test | None | Components must be industrial temperature grade, Derating required at +85°C |
| REQ-HW-014 | Output Power Control | System shall provide adjustable output power control with minimum 30dB dynamic range. | Should have | test | Digital attenuator or VGA | None |
| REQ-HW-016 | Power Sequencing | System shall implement proper power sequencing for Artix-7 FPGA as per Xilinx specifications. | Must have | test | None | None |

### 3.3 Interface Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-011 | FPGA Programming Interface | System shall provide JTAG interface for FPGA configuration and debugging. | Must have | inspection | None | None |

### 3.4 Constraint Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-012 | EMI/EMC Compliance | System shall meet FCC Part 15 and CISPR 32 Class A emissions requirements for industrial equipment. | Should have | test | None | Shielding required for 5-10GHz radiation |

### 3.5 Safety Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-015 | Thermal Protection | System shall include thermal monitoring and automatic shutdown to prevent component damage. | Must have | test | None | None |
