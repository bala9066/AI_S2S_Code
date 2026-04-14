# Hardware Requirements
## TX Module

## 1. Project Summary

Wideband military RF transmit module operating from 5-18 GHz with 40 dBm (10W) output power for analog modulation. High-efficiency power amplification in a compact form factor designed for military environments with emphasis on thermal management, power efficiency, improved matching (input/output return loss >13 dB), and SMP connectors for RF I/O interfaces.

## 2. Design Parameters

| Parameter | Value |
|---|---|
| --- | --- |
| Center Frequency Mhz | 11500 |
| Bandwidth Mhz | 13000 |
| Output Power Dbm | 40 |
| Gain Db | 40 |
| Input Power Dbm | 0 |
| Supply Voltage V | 28 |
| Efficiency Pae Percent | 25 |
| Input Return Loss Db | >13 |
| Output Return Loss Db | >13 |
| Input Vswr | <1.6 |
| Output Vswr | <1.6 |
| Input Connector Type | SMP |
| Output Connector Type | SMP |
| Temp Range C | -40 to +85 |

## 3. Requirements

### 3.1 Functional Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-001 | Operating Frequency Range | Must have | Must have | test | None | None |
| REQ-HW-002 | Output Power | Must have | Must have | test | None | None |
| REQ-HW-003 | Analog Modulation Support | Must have | Should have | test | None | None |
| REQ-HW-004 | Power Efficiency | Must have | Should have | test | None | None |
| REQ-HW-005 | Gain | Must have | Should have | test | None | None |
| REQ-HW-006 | Output Return Loss | Must have | Should have | test | None | None |
| REQ-HW-007 | RF Input Interface | Must have | Should have | test | None | None |
| REQ-HW-008 | RF Output Interface | Must have | Should have | test | None | None |
| REQ-HW-009 | Power Supply Interface | Must have | Should have | test | None | None |
| REQ-HW-010 | Enable/TX Control | Must have | Should have | test | None | None |
| REQ-HW-011 | Operating Temperature | Must have | Should have | test | None | None |
| REQ-HW-012 | Storage Temperature | Should have | Should have | test | None | None |
| REQ-HW-013 | Vibration and Shock | Must have | Should have | test | None | None |
| REQ-HW-014 | EMI/EMC Compliance | Must have | Should have | test | None | None |
| REQ-HW-015 | Size Constraints | Must have | Should have | test | None | None |
| REQ-HW-016 | Weight | Should have | Should have | test | None | None |
| REQ-HW-017 | Harmonic Output | Should have | Should have | test | None | None |
| REQ-HW-018 | Spurious Outputs | Should have | Should have | test | None | None |
| REQ-HW-019 | Thermal Management | Must have | Should have | test | None | None |
| REQ-HW-020 | Input Power Sensing | Could have | Should have | test | None | None |
