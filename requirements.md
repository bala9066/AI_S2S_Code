# Hardware Requirements
## rf9

## 1. Project Summary

48V 10kW 3-phase BLDC motor controller with industrial temperature rating, featuring both trapezoidal 6-step and FOC sinusoidal control modes. The system supports up to 208A continuous current, 10 kHz PWM switching, encoder-based position feedback, UART communication, 0-5V analog throttle input, isolated gate drive topology, 3-shunt current sensing for precise FOC implementation, and comprehensive over-temperature protection.

## 2. Design Parameters

| Parameter | Value |
|---|---|
| Bus Voltage | 48V nominal |
| Max Continuous Current | 208A |
| Peak Current Rating | 300A for <5s |
| Switching Frequency | 10 kHz (adjustable 5-20 kHz) |
| Control Modes | Trapezoidal 6-step and FOC sinusoidal |
| Position Sensor | Quadrature encoder (up to 2500 PPR) |
| Current Sensing | 3-shunt low-side sensing |
| Gate Drive Topology | Isolated gate drive (5kV RMS) |
| Communication Interface | UART (9600-115200 baud) |
| Throttle Input | 0-5V analog with protection |
| Operating Temperature | -40°C to +85°C industrial |
| Protection Features | Over-temperature, undervoltage/overvoltage lockout |
| Efficiency Target | >96% at full load |
| Dead Time Range | 500ns to 2us programmable |

## 3. Requirements

### 3.1 Functional Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-001 | 3-Phase Inverter Output | Generate 3-phase PWM output to drive BLDC motor with configurable dead time and shoot-through protection. | Must have | test | None | 48V bus max, 10 kHz switching |
| REQ-HW-002 | Control Mode Support | Support both trapezoidal 6-step commutation and field-oriented control (FOC) sinusoidal modes with runtime switching. | Must have | demonstration | REQ-HW-003, REQ-HW-004 | None |
| REQ-HW-003 | Encoder Position Feedback Interface | Read quadrature encoder signals (A/B/Index) for rotor position and speed sensing. | Must have | test | None | Up to 2500 PPR encoder support |
| REQ-HW-004 | 3-Shunt Current Sensing | Measure all three phase currents using low-side shunt resistors with differential amplifiers for FOC current reconstruction. | Must have | test | None | +/- 250A range, Isolated measurement path recommended |
| REQ-HW-007 | Isolated Gate Drive | Drive all 6 MOSFET gates using isolated gate drivers with reinforced isolation (5kV RMS) for enhanced safety and noise immunity. | Must have | inspection | None | Gate drive voltage 12-15V, UVLO protection |
| REQ-HW-010 | Over-Temperature Protection | Monitor MOSFET heatsink temperature and MCU die temperature with configurable shutdown thresholds and hysteresis. | Must have | test | None | Thermistor or digital sensor, Latch-off or auto-recovery selectable |
| REQ-HW-013 | Dead Time Insertion | Implement programmable dead time (typically 500ns-2us) between high-side and low-side gate signals to prevent shoot-through. | Must have | test | REQ-HW-007 | Resolution <50ns |
| REQ-HW-014 | DC Bus Voltage Sensing | Measure 48V DC bus voltage through resistive divider with isolation or level shifting. | Should have | test | None | Undervoltage and overvoltage lockout |
| REQ-HW-016 | Fault Detection and Reporting | Detect and report fault conditions via UART: overcurrent, over-temperature, undervoltage, overvoltage, and encoder loss. | Should have | test | REQ-HW-005, REQ-HW-010, REQ-HW-014 | Sub-10ms fault response time |

### 3.2 Interface Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-005 | UART Communication | Provide UART interface (3.3V CMOS) for configuration, telemetry, and firmware updates. | Must have | test | None | Baud rates 9600-115200, 5V tolerant if possible |
| REQ-HW-006 | Analog Throttle Input | Accept 0-5V analog input for speed/duty cycle reference with filtering and protection. | Must have | test | None | Input impedance >10k, Overvoltage protection to 12V |
| REQ-HW-017 | Status Indicators | Provide LED indicators for power, fault, and running status. | Could have | inspection | None | None |

### 3.3 Performance Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-008 | Current Rating | Support continuous phase current of 208A with capability to handle peak currents up to 300A for short durations (<5 seconds). | Must have | test | REQ-HW-010 | Derating at 85°C ambient |
| REQ-HW-009 | PWM Switching Frequency | Generate PWM signals at 10 kHz switching frequency with <100ns edge timing accuracy. | Must have | test | None | Adjustable 5-20kHz for optimization |
| REQ-HW-015 | Efficiency Target | Achieve >96% power conversion efficiency at full load (10kW) with proper thermal design. | Should have | test | REQ-HW-008, REQ-HW-010 | Low Rds(on) MOSFETs, Minimize parasitic inductance |
| REQ-HW-020 | Current Measurement Accuracy | Phase current measurement accuracy of +/- 2% of full scale for FOC performance. | Should have | test | REQ-HW-004 | 12-bit ADC minimum, Oversampling recommended |

### 3.4 Environmental Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-011 | Industrial Temperature Range | All components must be rated and characterized for operation from -40°C to +85°C ambient. | Must have | inspection | None | Automotive or industrial grade components |

### 3.5 Constraint Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-012 | 48V Bus Voltage Rating | Power stage components rated for minimum 60V Vds to provide margin above 48V nominal bus. | Must have | inspection | None | 80V or 100V MOSFETs recommended for transients |
| REQ-HW-018 | RoHS Compliance | All components shall be RoHS compliant for environmental regulations. | Must have | inspection | None | No lead, mercury, cadmium, etc. |
| REQ-HW-019 | Component Lifecycle | Prioritize components with >5 year remaining lifecycle and preferred automotive or industrial qualification. | Should have | inspection | None | Avoid NRND or EOL components |
