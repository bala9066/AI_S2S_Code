# Hardware Requirements
## fug

## 1. Project Summary

10 kW 3-phase BLDC motor controller for EV conversion. 48V DC bus input, 3-phase inverter output with industrial temperature range (-40 to +85C). PWM throttle input with Hall sensor feedback and IEC 60730 Class B compliance.

## 2. Design Parameters

| Parameter | Value |
|---|---|
| Dc Bus Voltage | 48V nominal (36-60V operating) |
| Output Power | 10 kW continuous |
| Phase Current Peak | 250A |
| Phase Current Continuous | 210A |
| Switching Frequency | 20 kHz |
| Pwm Input Range | 1-2 ms at 1-5 kHz |
| Hall Sensor Voltage | 5V pull-up |
| Current Sensing | 3x in-line shunts, ±2% accuracy, ≤0.5A resolution |
| Operating Temperature | -40 to +85°C (Industrial) |
| Safety Standard | IEC 60730 Class B |
| Compliance | RoHS, REACH |
| Commutation Method | Hall sensor based 120° |
| Control Topology | Trapezoidal 6-step commutation |
| Fault Response Time | ≤5 μs for overcurrent |
| Overvoltage Lockout Threshold | 65V |

## 3. Requirements

### 3.1 Functional Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-001 | DC Bus Input Voltage | System shall accept 48V DC bus input voltage with operating range of 36V to 60V nominal. | Must have | test | None | None |
| REQ-HW-002 | 3-Phase Inverter Output | System shall generate 3-phase PWM output to drive BLDC motor with peak current capability of 250A and continuous current rating of 210A at 48V bus. | Must have | test | None | None |
| REQ-HW-003 | PWM Throttle Input | System shall accept 1kHz to 5kHz PWM throttle input signal with 1-2ms pulse width range for speed command. | Must have | test | None | None |
| REQ-HW-004 | Hall Sensor Interface | System shall provide 5V pull-up interface for 3-wire Hall sensor feedback with 120-degree electrical spacing support. | Must have | test | None | None |
| REQ-HW-007 | 3x In-line Phase Shunts | System shall implement three in-line shunt resistors for independent phase current measurement, supporting full FOC control and per-phase fault detection. | Must have | inspection | REQ-HW-006 | None |
| REQ-HW-009 | IEC 60730 Class B Compliance | MCU and firmware architecture shall support IEC 60730 Class B safety requirements including watchdog timer, clock monitoring, and memory self-test. | Must have | analysis | None | None |
| REQ-HW-010 | Overcurrent Protection | System shall detect overcurrent fault within 5 microseconds and disable PWM outputs with hardware latch. | Must have | test | None | None |
| REQ-HW-011 | Overvoltage and Undervoltage Lockout | System shall monitor DC bus voltage and inhibit operation if voltage exceeds 65V (overvoltage lockout) or drops below 30V (undervoltage lockout). | Must have | test | REQ-HW-001 | None |
| REQ-HW-014 | Braking/Regenerative Capability | System shall support active braking with controlled current dump into braking resistor (regen optional). | Should have | test | None | None |

### 3.2 Performance Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-005 | Switching Frequency | Inverter switching frequency shall be 20 kHz minimum to minimize audible noise and maintain motor efficiency. | Must have | inspection | None | None |
| REQ-HW-006 | Current Sensing Resolution | Phase current measurement resolution shall be <= 0.5A with +/-2% accuracy across 0-250A range. | Must have | test | None | None |
| REQ-HW-013 | Power Stage Efficiency | Inverter power stage efficiency shall exceed 96% at rated load (10kW output). | Should have | test | None | None |

### 3.3 Environmental Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-008 | Operating Temperature Range | All components shall be rated for industrial temperature range of -40C to +85C ambient operation. | Must have | inspection | None | None |

### 3.4 Constraint Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-012 | RoHS/REACH Compliance | All components shall be RoHS and REACH compliant. | Must have | inspection | None | None |

### 3.5 Interface Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-015 | Fault Indicator Output | System shall provide open-drain fault indicator output for external status monitoring. | Could have | test | None | None |
