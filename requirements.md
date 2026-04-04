# Hardware Requirements
## fjxm

## 1. Project Summary

48V to 3.3V/5V/12V multi-output power supply for industrial DC bus applications. Total output power 200W with forced-air cooling, MIL-STD-883 environmental compliance, and linear post-regulation for low-noise outputs.

## 2. Design Parameters

| Parameter | Value |
|---|---|
| Input Voltage Range | 40-60V DC (industrial 48V bus) |
| Input Transient Protection | 80V for 100ms per MIL-STD-1275 |
| Output Power Total | 200W maximum |
| Output 12V | 12A max (144W), ±1% regulation, <50mV ripple |
| Output 5V | 8A max (40W), ±1% regulation, linear post-regulator, <20mV ripple |
| Output 3.3V | 6A max (20W), ±1% regulation, linear post-regulator, <20mV ripple |
| Isolation | 1500VDC input-output, 500VDC output-output |
| Efficiency Target | >90% at full load with forced air |
| Operating Temperature | -40°C to +85°C ambient per MIL-STD-883 |
| Cooling | Forced air, minimum 200 LFM airflow |
| Emi Standard | MIL-STD-461G (RE102, CE102) |
| Topography | Multi-output forward converter with mag-amp post regulation |
| Switching Frequency | 200-300 kHz for optimal magnetics size |
| Protection Features | OCP, OVP, UVP, reverse polarity, UVLO |
| Pcb Coating | Conformal coating per MIL-I-46058C |
| Component Lifecycle | Minimum 10 years availability |

## 3. Requirements

### 3.1 Functional Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-001 | Input Voltage Range | Accept 40V to 60V DC input voltage from industrial DC bus with transient protection to 80V for 100ms. | Must have | test | None | MIL-STD-1275 transient protection, Reverse polarity protection required |
| REQ-HW-002 | Multi-Rail Output Voltages | Provide simultaneous isolated 12V, 5V, and 3.3V DC outputs from a single 48V input. | Must have | test | REQ-HW-003 | None |
| REQ-HW-007 | Input Output Isolation | Minimum 1500VDC isolation between input and all outputs. 500VDC isolation between output rails. | Must have | test | None | IEC 60950-1 reinforced insulation |
| REQ-HW-008 | Overcurrent Protection | Independent overcurrent protection on each output rail with auto-recovery latch. Current limit set to 120% of max rated current. | Must have | test | None | None |
| REQ-HW-009 | Overvoltage Protection | Overvoltage protection crowbar circuits on 12V, 5V, and 3.3V rails set to 115-125% of nominal voltage. | Must have | test | None | None |
| REQ-HW-015 | Input Reverse Polarity Protection | Protect against reverse input voltage connection up to -60V without damage. | Must have | test | None | None |
| REQ-HW-016 | Undervoltage Lockout | Input UVLO set to 36V with 2V hysteresis. Prevent operation below safe operating voltage. | Must have | test | None | None |
| REQ-HW-021 | Remote Sense | Remote sense capability on 12V rail (±0.5V compensate) for load regulation improvement. | Could have | test | None | None |

### 3.2 Performance Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-003 | Output Current Capability | 12V rail: 12A max (144W), 5V rail: 8A max (40W), 3.3V rail: 6A max (20W). Total system power capacity 200W with headroom. | Must have | test | None | Thermal derating above 50°C |
| REQ-HW-004 | Voltage Regulation Accuracy | All outputs maintain ±1% regulation from 10% to 100% load. Linear post-regulators on 5V and 3.3V rails for low noise. | Must have | test | None | None |
| REQ-HW-005 | Output Ripple and Noise | Output ripple and noise less than 50mVpk-pk on 12V rail, less than 20mVpk-pk on 5V and 3.3V rails (20MHz bandwidth). | Must have | test | REQ-HW-004 | None |
| REQ-HW-012 | Efficiency Requirements | Minimum 85% efficiency at 75% load. 90%+ target at full load with forced air cooling. | Should have | test | None | None |
| REQ-HW-017 | Transient Response | Output voltage deviation less than 5% for 50% load step with recovery within 500us. | Should have | test | None | None |

### 3.3 Environmental Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-006 | Operating Temperature Range | Full specification operation from -40°C to +85°C ambient per MIL-STD-883. Storage temperature -55°C to +125°C. | Must have | demonstration | None | Forced air cooling required |
| REQ-HW-013 | EMI Compliance | Meet conducted and radiated EMI requirements per MIL-STD-461G (RE102, CE102). | Must have | test | None | Input and output filtering required |
| REQ-HW-014 | Vibration and Shock | Withstand MIL-STD-883 Method 2007.5 vibration (20-2000Hz, 20g) and Method 2002.4 shock (1500g, 0.5ms). | Must have | test | None | Conformal coating required |
| REQ-HW-019 | Forced Air Cooling | System requires minimum 200 LFM (linear feet per minute) airflow for full 200W output operation. | Must have | demonstration | REQ-HW-003, REQ-HW-012 | None |
| REQ-HW-023 | Altitude Operation | Derated operation up to 50,000 feet altitude per MIL-STD-810H. | Should have | analysis | REQ-HW-019 | None |

### 3.4 Interface Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-010 | Output Enable Control | TTL-compatible active-high enable input with internal pull-down. Soft-start duration 50-100ms. | Should have | test | None | None |
| REQ-HW-011 | Power Good Indicators | Open-drain power-good signals for each rail with 10ms deglitch. Valid when output is within ±5% of target. | Should have | test | None | None |
| REQ-HW-022 | Current Monitor Output | Analog current monitor output (0-2V proportional to 0-100% load) for primary 12V rail. | Could have | test | None | None |

### 3.5 Constraint Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-018 | Component Lifecycle | All components shall be RoHS compliant and have minimum 10-year lifecycle availability per manufacturer. | Must have | inspection | None | None |
| REQ-HW-020 | PCB Conformal Coating | PCB assembly shall receive acrylic or silicone conformal coating per MIL-STD-860 for moisture protection. | Must have | inspection | None | None |
