# Hardware Requirements
## rf44

## 1. Project Summary

48V 10kW 3-phase BLDC motor controller with FOC using position sensor feedback, bootstrap gate drive, UART/RS-485 communication, industrial temperature range –40–85°C, and EMI compliance.

## 2. Design Parameters

| Parameter | Value |
|---|---|
| Bus Voltage Nominal | 48V DC |
| Bus Voltage Range | 36–60V DC |
| Output Power | 10kW continuous |
| Phase Current Peak | ≈208A (at 48V, 10kW) |
| Motor Type | BLDC (PMSM) |
| Control Algorithm | FOC (Field-Oriented Control) |
| Position Sensor | External (encoder/Hall/resolver) |
| Current Sensing | 3-phase shunt amplifiers |
| Gate Drive Type | Bootstrap, 15V |
| Switching Frequency | 10–50 kHz (typical 20 kHz) |
| Comm Interface | UART / RS-485 |
| Operating Temp | –40 to +85°C (industrial) |
| Emi Compliance | Yes (industrial IEC 61800-3 or EN 55032) |
| Thermal Target | Maintain MOSFET Tj ≤ 125°C at 10kW |
| Efficiency Target | ≥96% at rated power |
| Protection Features | Overcurrent, overvoltage, undervoltage, overtemperature |

## 3. Requirements

### 3.1 Functional Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-001 | 3-Phase Inverter Output Stage | Provide 3-phase PWM output to drive a BLDC motor at 48V bus voltage with 10kW continuous power rating (approx 208A phase current). | Must have | test | BUS_VOLTAGE_NOMINAL, PHASE_CURRENT_PEAK | 48V_DC_BUS, BRIDGE_CONFIG |
| REQ-HW-002 | Field-Oriented Control (FOC) | Implement FOC algorithm for torque/speed control using position sensor feedback. | Must have | demonstration | POSITION_SENSOR | MCU_FPU_REQUIRED |
| REQ-HW-003 | Position Sensor Interface | Interface to external position sensor (encoder, Hall, or resolver) for FOC commutation. | Must have | test | None | ENCODER_ABZ_OR_HALL |
| REQ-HW-004 | 3-Phase Current Sensing | Measure all three phase currents via inline shunts and amplifier circuit for FOC feedback and overcurrent protection. | Must have | test | SHUNT_RESISTOR, CURRENT_SENSE_AMP | BIDIRECTIONAL_SENSING |
| REQ-HW-005 | Bootstrap Gate Drive | Provide bootstrap-powered high-side gate drive for 6-switch 3-phase inverter. | Must have | inspection | DC_BUS_LINK_CAP | BOOTSTRAP_CAP_REQUIRED, 15V_GATE_DRIVE |
| REQ-HW-006 | UART/RS-485 Communication | Provide UART or RS-485 interface for external command and telemetry (torque/speed setpoint, status, fault reporting). | Must have | test | None | RS485_TRANSCEIVER |
| REQ-HW-007 | DC Bus Voltage Sensing | Measure DC bus voltage for undervoltage/overvoltage protection and FOC feedforward compensation. | Must have | test | VOLTAGE_DIVIDER_RANGE | RESISTIVE_DIVIDER |
| REQ-HW-008 | Overcurrent Protection | Fast hardware-based overcurrent trip on phase currents (via comparator or driver DESAT) to protect power stage. | Must have | test | CURRENT_SENSE_AMP | TRIP_THRESHOLD |
| REQ-HW-009 | DC Bus Link Capacitor | Provide sufficient bulk capacitance to buffer DC bus ripple and handle regenerative energy. | Must have | inspection | DC_BUS_VOLTAGE | CAP_RATING_VOLTAGE, LOW_ESR |
| REQ-HW-010 | Heat Dissipation | Design thermal path (heatsink, PCB copper, thermal interface) to maintain MOSFET junction temperature within limits at 10kW. | Must have | analysis | THERMAL_TARGET | THERMAL_RESISTANCE |

### 3.2 Performance Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-011 | Switching Frequency | Support PWM switching frequency configurable from 10 kHz to 50 kHz (typical 20 kHz for vehicle traction). | Should have | test | MOSFET_Td | MAX_PWM_FREQUENCY |
| REQ-HW-012 | Current Control Loop Bandwidth | Achieve current control loop bandwidth ≥ 1 kHz for FOC performance. | Should have | test | MCU_ADC_RATE | ADC_SAMPLING_RATE |
| REQ-HW-013 | Efficiency Target | Achieve ≥ 96% efficiency at rated power (excluding mechanical losses). | Could have | test | MOSFET_RDSon, SWITCHING_FREQ | THERMAL_LIMIT |

### 3.3 Environmental Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-014 | Industrial Temperature Range | All components rated for –40 to +85°C ambient operation. | Must have | inspection | None | COMPONENT_TEMP_GRADE |
| REQ-HW-015 | EMI/EMC Compliance | Design to meet relevant EMI standards (e.g., EN 55032 Class A or industrial IEC 61800-3) including input filter and layout constraints. | Must have | test | INPUT_FILTER | LAYOUT_GUIDELINES |

### 3.4 Constraint Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-016 | 48V DC Bus | System designed for 48V nominal DC input (typical automotive/industrial 36–60V range). | Must have | inspection | None | MOSFET_VDS_RATING |
| REQ-HW-017 | Power Budget | Total system power dissipation limited by thermal design; target ≤ 400W losses at 10kW output (96% efficiency). | Should have | analysis | MOSFET_RDSon, GATE_CHARGE | HEATSINK_SIZE |
| REQ-HW-018 | PCB Constraints | Use multi-layer PCB (minimum 4 layers) with dedicated power plane, high-current paths, and thermal relief. | Should have | inspection | CURRENT_CAPACITY | TRACE_WIDTH, COPPER_WEIGHT |
