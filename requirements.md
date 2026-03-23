# Hardware Requirements
## rf1

## 1. Project Summary

Non-isolated multi-rail DC-DC buck converter stepping down 48V input to 12V at 10A (120W), plus 3.3V and 5V rails sharing remaining ~80W. Industrial temperature range (–40–85°C), latch-off protection, ±1% regulation on 12V rail. Target applications: industrial/telecom power distribution.

## 2. Design Parameters

| Parameter | Value |
|---|---|
| Input Voltage Nominal | 48V DC |
| Input Voltage Range | 40–60V |
| Topology | Non-isolated buck converter (multi-rail) |
| 12V Rail Current | 10A continuous (120W) |
| 5V Rail Power | Up to 40W (load share) |
| 3.3V Rail Power | Up to 40W (load share) |
| Total Output Power | 200W maximum |
| 12V Regulation | ±1% |
| 5V 3.3V Regulation | ±2–3% |
| Ambient Temperature Range | –40 to +85°C |
| Protection | Latch-off OCP, UVLO |
| Enable Control | None (internal) |
| Power Good Signals | None |
| Efficiency Target | >90% at full load (12V rail) |
| Emissions Compliance | Board-level EMI control (no formal EN 55032 requirement) |

## 3. Requirements

### 3.1 Functional Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-001 | Input Voltage Range | Accept input voltage range of 40V to 60V (48V nominal). | Must have | test | None | -40–85°C ambient |
| REQ-HW-002 | 12V Output Rail | Provide regulated 12V output at up to 10A continuous current (120W). | Must have | test | REQ-HW-001 | ±1% load regulation, ±1% line regulation |
| REQ-HW-003 | 5V Output Rail | Provide regulated 5V output supporting up to 40W load share. | Must have | test | REQ-HW-001 | ±2–3% regulation acceptable |
| REQ-HW-004 | 3.3V Output Rail | Provide regulated 3.3V output supporting up to 40W load share. | Must have | test | REQ-HW-001 | ±2–3% regulation acceptable |
| REQ-HW-008 | Overcurrent Protection | Each output rail shall include latch-off overcurrent protection. | Must have | test | REQ-HW-002, REQ-HW-003, REQ-HW-004 | no auto-retry |
| REQ-HW-009 | Undervoltage Lockout (UVLO) | Disable operation when input voltage falls below 36V. | Must have | test | REQ-HW-001 | None |
| REQ-HW-013 | Soft Start | Include soft-start to limit inrush current. | Should have | test | None | None |

### 3.2 Performance Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-005 | Total Output Power | Support combined output power up to 200W across all rails. | Must have | test | REQ-HW-002, REQ-HW-003, REQ-HW-004 | None |
| REQ-HW-006 | Efficiency | Achieve at least 90% efficiency at full load on primary 12V rail. | Should have | test | None | 48V input |
| REQ-HW-012 | 12V Transient Response | Maintain ±1% output voltage during 10% to 90% load step. | Could have | test | REQ-HW-002 | recovery within 50us |

### 3.3 Environmental Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-007 | Operating Temperature | Maintain specification across –40°C to +85°C ambient. | Must have | test | None | None |

### 3.4 Interface Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-010 | Output Enable Control | Provide external enable pin for each output rail. | Won't have | inspection | None | None |
| REQ-HW-011 | Power Good Signals | Provide power-good indicator signals. | Won't have | inspection | None | None |
