**Document Status: AI-GENERATED**

# 1. Introduction

## 1.1 Purpose
This Hardware Requirements Specification (HRS) defines the comprehensive hardware requirements for the **rf44** 3-phase BLDC motor controller. The purpose of this document is to establish a baseline for the detailed design, component selection, layout, and verification of the hardware subsystems.

Specific objectives of this specification are:
*   To detail the electrical, thermal, and mechanical characteristics required to achieve 10kW continuous power output at 48V DC input.
*   To specify the functional interfaces between the Power Stage, Gate Drive, Control Logic (MCU), and Sensor subsystems.
*   To serve as the single source of truth for hardware validation criteria, ensuring the design meets industrial reliability standards and EMI/EMC compliance (IEC 61800-3 / EN 55032).
*   To facilitate traceability between high-level system requirements and low-level hardware implementation via the REQ-HW-xxx identification system.

This document is intended for hardware engineers, PCB designers, validation engineers, and system integrators involved in the rf44 project lifecycle.

## 1.2 Scope
The scope of this document encompasses the complete electronic hardware design of the rf44 controller, excluding the mechanical enclosure and the BLDC motor itself (though the motor interface is defined).

**In-Scope Elements:**
1.  **Power Stage:** 48V DC to 3-phase AC inverter using DirectFET MOSFETs capable of 208A peak phase current.
2.  **Control System:** STM32F405RGT6-based MCU subsystem with FOC acceleration.
3.  **Gate Drivers:** Three-phase bootstrap high/low-side gate drive circuitry.
4.  **Sensing & Feedback:** Phase current sensing (shunt resistors + amplifiers), DC bus voltage sensing, and temperature monitoring.
5.  **Communication:** UART/RS-485 physical layer for host command and control.
6.  **Protection Circuits:** Hardware-based fast overcurrent, overvoltage, and undervoltage protection.
7.  **Physical Design:** PCB stackup, copper weight requirements for current carrying capacity, and thermal management constraints.

**Out-of-Scope Elements:**
*   Firmware algorithms beyond the hardware requirements necessary to execute them (e.g., specific FOC PID gains are software, but the ADC speed required to run them is hardware).
*   AC mains input rectification (the system assumes a 48V DC input source).
*   Mechanical housing design, though thermal interface dimensions are provided.

## 1.3 Definitions, Acronyms, and Abbreviations

| Term | Definition |
| :--- | :--- |
| **BLDC** | Brushless Direct Current Motor |
| **DC** | Direct Current |
| **EMC** | Electromagnetic Compatibility (the ability of a device to function as intended in its electromagnetic environment) |
| **EMI** | Electromagnetic Interference (unintended generation of electromagnetic energy) |
| **ESC** | Electronic Speed Controller |
| **FOC** | Field-Oriented Control (a control algorithm that optimizes torque generation by controlling the stator current vector) |
| **FPU** | Floating Point Unit |
| **HRS** | Hardware Requirements Specification |
| **IEC** | International Electrotechnical Commission |
| **ISR** | Interrupt Service Routine |
| **MCU** | Microcontroller Unit |
| **MOSFET** | Metal-Oxide-Semiconductor Field-Effect Transistor |
| **PCB** | Printed Circuit Board |
| **PFC** | Power Factor Correction |
| **PID** | Proportional-Integral-Derivative (control loop mechanism) |
| **PMSM** | Permanent Magnet Synchronous Motor |
| **PWM** | Pulse Width Modulation |
| **RDS(on)** | Drain-Source On-State Resistance (parameter of MOSFETs) |
| **RS-485** | Recommended Standard 485 (a standard defining the electrical characteristics of drivers and receivers in digital systems) |
| **SOIC** | Small Outline Integrated Circuit |
| **Tj** | Junction Temperature (semiconductor internal temperature) |
| **UART** | Universal Asynchronous Receiver-Transmitter |
| **Vds** | Drain-Source Voltage (MOSFET rating) |

## 1.4 References
The design of the rf44 hardware shall comply with or be guided by the following standards and documents:

1.  **IEEE Std 29148-2018:** Systems and software engineering — Life cycle processes — Requirements engineering.
2.  **IEC 61800-3:** Adjustable speed electrical power drive systems — Part 3: EMC requirements and specific test methods.
3.  **IEC 60730-1:** Automatic electrical controls for household and similar use - Part 1: General requirements (Safety reference).
4.  **IPC-2221:** Generic Standard on Printed Board Design (Trace width/carrying capacity).
5.  **STMicroelectronics, "AN4776: Motor control firmware developer guide for STM32F4"**, for hardware-software interface definition.
6.  **Infineon, "Bootstrap Network Design for Bootstrap Drivers"**, Application Note regarding bootstrap capacitor sizing.
7.  **ISO 26262:** Road vehicles – Functional safety (Referenced for ASIL considerations if applied in automotive contexts).

## 1.5 Overview
The rf44 system is a high-performance, industrial-grade 3-phase inverter designed to drive a BLDC/PMSM motor with a continuous power rating of 10kW. The architecture is partitioned into two distinct domains: the high-power 48V domain and the low-voltage logic domain (3.3V).

**System Operation:**
The system accepts a nominal 48V DC input (ranging from 36V to 60V). This DC voltage is buffered by a DC Link capacitor bank and switched by six low-RDS(on) DirectFET MOSFETs arranged in a 3-phase bridge configuration. The switching of these MOSFETs is controlled by three bootstrap gate driver ICs (IR2101), which receive logic-level PWM signals from the primary MCU (STM32F405RGT6).

**Control Strategy:**
The MCU implements Field-Oriented Control (FOC), requiring high-frequency feedback of phase currents (via INA240 shunt amplifiers) and rotor position (via an external encoder/Hall sensor interface). The control loop runs at a switching frequency of 20 kHz (configurable up to 50 kHz). Communication with the host system is established via an RS-485 transceiver (MAX3485ESA+) for robust command and telemetry in noisy industrial environments.

**Key Design Challenges:**
1.  **Thermal Management:** Dissipating approximately 400W of heat (assuming 96% efficiency) requires a PCB design with heavy copper pours and an external heatsink interface to keep MOSFET junctions (Tj) below 125°C.
2.  **High Current Routing:** The PCB must accommodate peak currents of 208A, necessitating careful calculation of trace widths (assuming 2 oz or 4 oz copper) and via stitching to minimize inductance and resistance.
3.  **Signal Integrity:** High-frequency switching (20 kHz edges) creates noise; the analog front-end (current/voltage sensing) must be filtered and referenced to a clean analog ground to prevent measurement errors.

Subsequent sections of this document will detail the specific requirements for power distribution, component selection, circuit protection, and physical layout constraints necessary to realize this architecture.

---

**Document Status: AI-GENERATED**

# 2. System Overview

## 2.1 System Description

The **rf44** system is a high-power, 3-phase Brushless DC (BLDC) motor controller designed for industrial traction and propulsion applications requiring high power density and precise torque control. The system operates from a nominal 48V DC power source (compatible with standard 48V automotive or industrial battery stacks ranging from 36V to 60V) and delivers continuous mechanical power of 10kW to the motor.

The core functionality of the rf44 unit is the conversion of fixed DC input voltage into a variable voltage, variable frequency 3-phase AC output. This conversion is achieved through a 6-switch inverter topology utilizing Pulse Width Modulation (PWM). The system employs Field-Oriented Control (FOC), implemented on a dedicated ARM Cortex-M4F microcontroller, to decouple the torque and flux components of the stator current. This allows for precise control of the motor's torque and speed across a wide speed range, maximizing efficiency and minimizing torque ripple.

### 2.1.1 Key Functional Blocks

The system is divided into four primary functional subsystems:

1.  **Power Stage:**
    This subsystem handles the high-current power flow. It consists of the input EMI filter, bulk DC link capacitance, and the 3-phase inverter bridge. The inverter bridge utilizes six Low-Side MOSFETs (specifically Infineon DirectFET parts) arranged in three half-bridge legs. These MOSFETs switch at high frequencies (configurable 10–50 kHz) to synthesize the 3-phase output. The power stage is designed to handle continuous phase currents of approximately 208A RMS and peak currents significantly higher during transient overload conditions.

2.  **Gate Drive & Isolation:**
    This subsystem provides the electrical interface between the low-voltage logic (3.3V MCU) and the high-voltage power stage (48V bus). It utilizes three bootstrap gate driver ICs (IR2101) to generate the required 15V gate-source voltage for the high-side and low-side MOSFETs. The drivers feature internal dead-time logic to prevent shoot-through currents and level shifters to drive the floating high-side MOSFETs.

3.  **Control & Sensing:**
    This subsystem is centered around the STM32F405RGT6 microcontroller. It reads feedback from various sensors to close the control loops:
    *   **Current Sensing:** Three inline shunt resistors measure the phase currents. INA240 amplifiers condition these signals for the MCU's ADC.
    *   **Voltage Sensing:** A resistive divider network scales the DC bus voltage for the ADC.
    *   **Position Sensing:** The MCU interfaces with an external encoder or Hall effect sensor to determine rotor position, essential for FOC commutation.
    *   **Thermal Sensing:** Thermistors monitor the temperature of the MOSFET heatsink and the PCB.

4.  **Communication & Interface:**
    This subsystem manages data exchange with external Master controllers or Human-Machine Interfaces (HMI). It utilizes a MAX3485 RS-485 transceiver to provide robust, noise-immune serial communication. The interface accepts command packets (torque setpoints, speed targets) and returns telemetry data (motor speed, bus voltage, current draw, fault codes).

### 2.1.2 Operational Modes

The rf44 system supports several operational modes managed by the MCU:

*   **Standby Mode:** The system is powered, but the inverter is disabled. Gate drives are held low, and the MCU awaits a start command. Power consumption is minimized.
*   **Closed-Loop Torque Control:** The primary operating mode. The MCU regulates the q-axis current component to maintain the commanded torque, regardless of rotor speed.
*   **Closed-Loop Speed Control:** The MCU regulates the motor speed using a PID loop that commands the necessary torque to overcome load and maintain setpoint speed.
*   **Fault Mode:** Triggered by internal protection circuitry or software logic. All PWM outputs are immediately disabled, gate drives are turned off, and a fault latch is engaged to prevent damage until the condition clears or a system reset occurs.

## 2.2 System Block Diagram

The following diagram illustrates the signal and power flow relationships between the major components of the rf44 system.

```mermaid
graph TD
    %% Power Flow
    DC_IN[DC Input<br/>36-60V] --> PWR[Power Distribution]
    
    subgraph Input_Filter [EMI Input Filter]
        PWR --> CM_CHOKE[Common Mode Choke]
        CM_CHOKE --> X_CAPS[X-Capacitors]
    end

    Input_Filter --> DC_POS[DC+ Bus]
    Input_Filter --> DC_NEG[DC- Bus]

    subgraph DC_Link [DC Link Stage]
        DC_POS -->|Charge| CAP[Bulk Capacitance<br/>470uF/100V]
        CAP --> PRE_R[Pre-charge Resistor<br/>Assumed 10 Ohm]
    end

    DC_POS --> INV_IN
    DC_NEG --> INV_GND

    subgraph Inverter [3-Phase Inverter Stage]
        INV_IN --> PHASE_U[Phase U Half Bridge<br/>IRFS7530 x2]
        INV_IN --> PHASE_V[Phase V Half Bridge<br/>IRFS7530 x2]
        INV_IN --> PHASE_W[Phase W Half Bridge<br/>IRFS7530 x2]
        
        PHASE_U --> U_OUT[U]
        PHASE_V --> V_OUT[V]
        PHASE_W --> W_OUT[W]
    end

    U_OUT --> MOTOR_M
    V_OUT --> MOTOR_M
    W_OUT --> MOTOR_M[Motor PMSM]

    %% Sensing & Feedback
    subgraph Sensing [Analog Sensing Front-End]
        PHASE_U -.-> |200A| SHUNT_U[Shunt 0.25mOhm]
        SHUNT_U --> AMP_U[INA240 Amp]
        PHASE_V -.-> |200A| SHUNT_V[Shunt 0.25mOhm]
        SHUNT_V --> AMP_V[INA240 Amp]
        PHASE_W -.-> |200A| SHUNT_W[Shunt 0.25mOhm]
        SHUNT_W --> AMP_W[INA240 Amp]
        
        DC_POS -.-> |Divider| V_SENSE[Bus Voltage Sense]
    end

    AMP_U --> ADC_UI[ADC 1]
    AMP_V --> ADC_VI[ADC 2]
    AMP_W --> ADC_WI[ADC 3]
    V_SENSE --> ADC_VB[ADC 3]

    %% Control Logic
    subgraph Controller [MCU STM32F405RGT6]
        ADC_UI
        ADC_VI
        ADC_WI
        ADC_VB
        ENC[Encoder Interface]
        TIMER[Advanced Timer<br/>PWM Generation]
        CORE[Cortex-M4F<br/>FOC Algorithm]
        UART[UART Peripheral]
    end

    %% Gate Drive Logic
    TIMER --> PWM_DRV[Bootstrap Drivers x3<br/>IR2101]
    PWM_DRV -->|Gate U| PHASE_U
    PWM_DRV -->|Gate V| PHASE_V
    PWM_DRV -->|Gate W| PHASE_W

    %% External Interfaces
    ENC --> POS_SRC[External Sensor<br/>(Encoder/Hall)]
    
    UART --> RS485[MAX3485 Transceiver]
    RS485 --> COMM_BUS[RS-485 Bus]
    COMM_BUS --> HOST[Host Controller]

    %% Safety & Thermal
    PHASE_U == "Heat" ==> THERMAL[Heatsink & Coldplate]
    PHASE_V == "Heat" ==> THERMAL
    PHASE_W == "Heat" ==> THERMAL
    
    THERMAL -.-> |NTC Thermistor| MCU_TEMP[ADC Temp Sense]
```

## 2.3 System Architecture

The rf44 system architecture is physically partitioned to manage high-power switching noise and thermal dissipation effectively. The design employs a multi-layer PCB approach (minimum 4 layers) to separate power control circuitry from logic.

### 2.3.1 Power Domain Architecture

The system utilizes a two-tier power distribution architecture:

1.  **High Voltage (HV) Domain (48V):**
    *   **Nominal Voltage:** 48V DC.
    *   **Range:** 36V (Low Battery) to 60V (Charging/Regen).
    *   **Currents:** Continuous RMS current up to 250A (including losses). Peak currents limited by hardware protection to ~400A.
    *   **Isolation:** The HV domain is galvanically isolated from the communication port (RS-485) but shares a common ground reference with the logic domain for the gate drivers and current sensors. Note: While the system ground is common, layout separation ensures high-frequency switching noise does not disrupt sensitive logic.

2.  **Low Voltage (LV) Domain (3.3V & 5V):**
    *   **3.3V Rail:** Powers the MCU, RS-485 transceiver, and signal conditioning circuitry. Generated by a high-precision Buck regulator (or LDO) derived from the 48V input.
    *   **5V/12V Rail:** Powers the operational amplifiers (INA240) and the primary side of the gate drivers.

### 2.3.2 Control Loop Architecture

The software/hardware co-design implements a cascaded control loop structure essential for FOC:

*   **Fast Current Loop (Inner Loop):**
    *   **Frequency:** Executed at the PWM switching frequency (20 kHz typical).
    *   **Function:** Measures phase currents via ADC, transforms them (Clarke/Park transforms) into D/Q rotating frame coordinates, and compares them to the torque/flux setpoints.
    *   **Actuator:** Space Vector Modulation (SVM) updates the duty cycle of the Advanced Timer registers.
    *   **Hardware:** The STM32F405's 12-bit ADC (2.4 MSPS) is synchronized with the timer PWM period to sample current at the center of the PWM pulse (center-aligned sampling), minimizing switching noise effects.

*   **Medium Speed Loop:**
    *   **Frequency:** 1 kHz to 10 kHz.
    *   **Function:** Estimates rotor angle/speed from the encoder interface. Handles the outer speed or position control loop if commanded.
    *   **Protection:** Monitors DC bus voltage and temperature for soft protection (derating).

*   **Communication Loop:**
    *   **Frequency:** Asynchronous/Event-driven.
    *   **Function:** Processes Modbus or custom binary packets over RS-485. Updates setpoints and streams telemetry.

### 2.3.3 Protection Architecture

The system implements a multi-layered protection strategy to ensure survivability at 10kW power levels:

1.  **Hardware Protection (Cycle-by-Cycle):**
    *   **Desaturation/Overcurrent:** The INA240 amplifiers feed into analog comparators (internal to STM32 or external). If current exceeds the safe threshold (e.g., 300A), the comparator triggers a hardware fault input (BKIN) on the advanced timer, instantly shutting down all PWM outputs within microseconds.
    *   **Under-Voltage Lockout (UVLO):** Internal to the IR2101 gate drivers. If the bootstrap capacitor voltage drops below 10V, the gates are turned off to prevent linear mode operation and explosion of the MOSFETs.

2.  **Firmware Protection (ms response):**
    *   **Over-Temperature:** The MCU monitors NTC thermistors. If temperature exceeds 110°C, the firmware ramps down torque (derating) or shuts down the drive.
    *   **Over-Voltage:** If regenerative energy pumps the DC bus above 65V, the firmware engages braking (resistive or mechanical) or cuts torque to zero.

## 2.4 Operating Environment

The rf44 controller is designed for rugged industrial environments. The following environmental specifications dictate the design constraints for component selection, PCB conformal coating, and mechanical packaging.

### 2.4.1 Environmental Conditions

| Parameter | Minimum | Typical | Maximum | Unit | Comments |
|---|---|---|---|---|---|
| **Ambient Temperature** | -40 | 25 | +85 | °C | Industrial operating range. Components rated "Industrial" (-40 to +85°C) or "Automotive" Grade 2 or 1. |
| **Storage Temperature** | -55 | - | +125 | °C | Non-operating transport conditions. |
| **Relative Humidity** | 5 | - | 95 | % | Non-condensing. PCB requires conformal coating (e.g., Humiseal) to prevent moisture-induced leakage currents and corrosion. |
| **Altitude** | 0 | - | 2000 | m | Derating required above 1000m for air cooling (reduced air density). |
| **Vibration** | - | - | 5G | 10-2000Hz | Per IEC 60068-2-6. Designed for fixed mounting on motor or chassis. |
| **Shock** | - | - | 30G | 11ms | Operational shock. |
| **Pollution Degree** | - | - | 3 | - | Conductive pollution expected (industrial dust). Conformal coating mandatory. |

### 2.4.2 Electrical Environment

*   **Source Impedance:** The DC source is assumed to be a low-impedance lead-acid or Li-Ion battery pack. The controller must handle regenerative energy return from the motor during rapid deceleration, which causes DC bus voltage spikes.
*   **EMC Compatibility:** The system must operate reliably in an environment saturated with electromagnetic interference.
    *   **Emissions:** Radiated and conducted emissions must comply with **EN 55032 Class A** (Industrial). This necessitates the input pi-filter and optimized gate driver slew rates (not too fast to cause ringing, not too slow to cause excess heat).
    *   **Immunity:** The system must withstand Level 3 Electrostatic Discharge (ESD) (±8kV contact, ±15kV air) on communication ports and connectors.

### 2.4.3 Mechanical Environment

*   **Mounting:** The unit is designed for base-plate mounting to a thermally conductive surface or cold plate. The MOSFETs (DirectFET packages) are soldered directly to the PCB, and thermal vias conduct heat to the bottom copper layers or an attached heatsink.
*   **Cooling:** Convection cooling is assumed for base units, but forced air cooling (fan) is recommended for continuous 10kW operation to keep junction temperatures <125°C.

---

**Document Status: AI-GENERATED**

# 3. Hardware Requirements

## 3.1 Functional Requirements

This section details the functional requirements of the **rf44** 10kW Motor Controller. These requirements specify the fundamental actions and behaviors the system must perform to meet the project goals.

| ID | Title | Description | Rationale | Verification Method | Priority | Source |
|---|---|---|---|---|---|---|
| **REQ-HW-101** | **DC Input Voltage Regulation** | The system shall accept a DC input voltage range of **36V to 60V** and operate continuously at the nominal voltage of **48V**. | Supports standard industrial 48V battery systems with typical charge/discharge fluctuations. | Test: Variable DC Supply | Mandatory | Customer |
| **REQ-HW-102** | **3-Phase Power Stage Topology** | The system shall implement a **3-phase Full-Bridge (6-switch)** inverter topology using **N-channel MOSFETs** to drive the BLDC motor. | Standard topology for 3-phase BLDC/PMSM motors. | Inspection: Schematic Review | Mandatory | Architecture |
| **REQ-HW-103** | **Continuous Power Output** | The power stage shall deliver a continuous output power of **10kW** at 48V DC bus input without exceeding thermal limits. | Base system performance requirement. | Test: Dynamometer Load | Mandatory | Project Spec |
| **REQ-HW-104** | **Phase Current Handling** | The inverter stage shall handle a peak phase current of **208A** (derived from $P = \sqrt{3} \cdot V \cdot I \cdot \text{PF}$). | Ensures the hardware can support the 10kW power target. | Analysis: Current Calculation | Mandatory | Project Spec |
| **REQ-HW-105** | **Bootstrap Gate Drive Supply** | The system shall utilize a **bootstrap circuit** to generate the floating supply for the high-side MOSFET gates, operating at **15V** relative to the source. | Eliminates the need for an isolated auxiliary power supply for the high-side drivers. | Inspection: Schematic Review | Mandatory | Design Constraint |
| **REQ-HW-106** | **Gate Drive Strength** | The gate driver (IR2101) shall provide a peak source/sink current of **2.0A** to charge/discharge the MOSFET gates ($Q_g \approx 140\text{nC}$) within **100ns**. | Ensures fast switching transitions to minimize switching losses. | Calculation: $I = Q_g/t$ | Mandatory | Component Spec |
| **REQ-HW-107** | **FOC Algorithm Implementation** | The MCU (STM32F405) shall execute **Field-Oriented Control (FOC)** algorithms utilizing the hardware **FPU** to calculate Park/Clarke transforms. | Required for high-efficiency torque control and minimal torque ripple. | Demonstration: Debug Monitor | Mandatory | Functional Req |
| **REQ-HW-108** | **Position Sensor Interface** | The MCU shall interface with an external position sensor (Encoder/Hall/Resolver) via the **Quadrature Encoder Interface (QE)** or GPIO interrupts. | FOC requires precise rotor position feedback for commutation. | Test: Signal Injection | Mandatory | Functional Req |
| **REQ-HW-109** | **3-Phase Current Sensing** | The system shall measure current on all three motor phases using **bidirectional shunt amplifiers** (INA240) with a gain of **20 V/V**. | Required for FOC phase reconstruction and overcurrent protection. | Test: Signal Injection | Mandatory | Functional Req |
| **REQ-HW-110** | **DC Bus Voltage Sensing** | The system shall monitor the DC bus voltage via a resistive divider scaled to the MCU's **3.3V ADC** range, covering **0V to 65V**. | Provides data for UVLO/OVLO protection and field weakening. | Test: Voltage Sweep | Mandatory | Safety |
| **REQ-HW-111** | **Shunt Resistor Specification** | The phase current sense shunts shall be **0.0005 Ohms (500 $\mu\Omega$)**, capable of handling **208A** continuous current with a power rating of at least **25W**. | Balances signal amplitude ($V = I \cdot R$) against conduction losses ($P = I^2 \cdot R$). | Inspection: BOM Review | Mandatory | Design Constraint |
| **REQ-HW-112** | **Hardware Overcurrent Trip** | The system shall implement a hardware comparator trip (or DESAT detection) that triggers a fault state if phase current exceeds **250A** (>120% rated) within **2$\mu$s**. | Critical safety mechanism to protect MOSFETs during shoot-through or fault conditions. | Test: Short Circuit Simulation | Mandatory | Safety |
| **REQ-HW-113** | **RS-485 Communication Physical Layer** | The system shall implement an isolated or non-isolated **RS-485** interface using the **MAX3485** transceiver, capable of **10 Mbps** data rates. | Standard industrial communication protocol noise immunity. | Test: Bit Error Rate | Mandatory | I/O Req |
| **REQ-HW-114** | **DC Link Capacitance** | The DC bus shall include bulk capacitance of at least **470$\mu$F** (Electrolytic) and **10$\mu$F** (Ceramic) to buffer ripple current and handle regenerative braking energy. | Stabilizes the bus voltage during high current transients. | Analysis: Ripple Simulation | Mandatory | Power Stability |
| **REQ-HW-115** | **Undervoltage Lockout (UVLO)** | The control logic shall inhibit PWM switching if the DC bus voltage drops below **36V** or the logic supply drops below **2.8V**. | Prevents runaway motor behavior or unstable logic during power loss. | Test: Power Dip | Mandatory | Safety |
| **REQ-HW-116** | **Deadtime Insertion** | The gate drivers shall maintain a hardware deadtime of **520ns** (min) to prevent shoot-through during MOSFET switching transitions. | Prevents catastrophic short circuits across the half-bridge. | Inspection: Scope Waveform | Mandatory | Protection |
| **REQ-HW-117** | **Temperature Monitoring** | The system shall include **NTC Thermistors** (10k$\Omega$ @ 25°C) on the heatsink and PCB power plane to monitor thermal performance. | Enables thermal derating and shutdown protection. | Test: Heat Application | Mandatory | Environmental |
| **REQ-HW-118** | **Fault Latching** | In the event of a critical fault (Overcurrent, Overtemp), the system shall latch off the PWM outputs and require a **hardware reset or specific UART command** to restart. | Prevents system cycling that could damage components. | Test: Fault Trigger | Mandatory | Safety Logic |
| **REQ-HW-119** | **Enable/Disable Control** | The system shall provide a physical **Enable (EN)** signal that must be asserted high for the inverter to operate. | Required for safety interlocks in industrial equipment. | Test: Enable Toggle | Optional | Safety |
| **REQ-HW-120** | **Status LED Indication** | The system shall provide a bi-color LED indicating **Power Good (Green)** and **Fault State (Red)**. | Provides immediate visual feedback to operators. | Inspection: Visual | Optional | UI/HMI |

## 3.2 Performance Requirements

This section defines the quantitative performance criteria the hardware must achieve.

| ID | Title | Description | Rationale | Verification Method | Priority | Source |
|---|---|---|---|---|---|---|
| **REQ-HW-201** | **Power Conversion Efficiency** | The system shall achieve a total power conversion efficiency (**$\eta$**) of **$\ge$ 96%** at rated load (10kW, 48V input). | Minimizes heat generation, reducing heatsink size and improving energy consumption. | Calculation: $P_{out} / P_{in}$ | Mandatory | Project Spec |
| **REQ-HW-202** | **Maximum MOSFET Junction Temp** | The MOSFET junction temperature ($T_j$) shall not exceed **125°C** when operating at 10kW continuous output in an ambient temperature of **40°C**. | Ensures long-term reliability of the power semiconductors. | Analysis: $T_j = T_a + (P \cdot R_{\theta ja})$ | Mandatory | Thermal Limit |
| **REQ-HW-203** | **PWM Switching Frequency** | The system shall support PWM switching frequencies ranging from **10 kHz to 50 kHz**, with a default operating frequency of **20 kHz**. | Audible noise avoidance vs. switching loss trade-off. | Test: Frequency Counter | Mandatory | Control Spec |
| **REQ-HW-204** | **Current Control Loop Bandwidth** | The FOC current loop (PI Controller) shall achieve a closed-loop bandwidth of at least **1 kHz** (Phase margin > 45°). | Ensures the controller can track torque commands rapidly. | Test: Step Response / Bode | Mandatory | Dynamic Response |
| **REQ-HW-205** | **Current Sensing Accuracy** | The phase current measurement circuit shall have an accuracy of **$\pm$2%** of full-scale scale (200A) across the operating temperature range. | Essential for smooth torque production and accurate limits. | Test: Reference Shunt | Mandatory | Control Accuracy |
| **REQ-HW-206** | **Voltage Sensing Resolution** | The DC bus voltage sensing ADC shall resolve changes of at least **0.1V** (approx. 30 LSBs with 12-bit ADC). | Allows precise monitoring of battery state of charge. | Test: ADC Readback | Mandatory | Monitoring |
| **REQ-HW-207** | **RS-485 Communication Latency** | The round-trip communication latency for a command packet shall be **< 10ms** at 115200 baud. | Ensures responsive control for remote master systems. | Test: Loopback Timing | Should Have | Comms |
| **REQ-HW-208** | **Thermal Time Constant** | The heatsink assembly shall provide a thermal time constant sufficient to withstand **150%** overload current for **5 seconds** without triggering thermal shutdown. | Allows temporary peak torque operations typical in traction applications. | Analysis: Thermal Simulation | Should Have | Transient Perf |
| **REQ-HW-209** | **Input Voltage Ripple Rejection** | The control logic shall maintain stable operation with a DC input ripple voltage of up to **5V pk-pk** at the switching frequency. | Ensures the system functions with noisy input sources. | Test: Injected Ripple | Should Have | EMI/EMC |
| **REQ-HW-210** | **Gate Drive Rise/Fall Time** | The gate driver output rise and fall times ($t_r / t_f$) into a **3000pF** load (MOSFET $C_{iss}$) shall be **< 50ns**. | Confirms the MOSFETs are driven in saturation region quickly to minimize switching loss. | Test: Oscilloscope 10%->90% | Mandatory | Switching Loss |
| **REQ-HW-211** | **Isolation Barrier (Optional)** | If an isolated gate driver option is utilized, the isolation barrier shall withstand **2500 Vrms** for 1 minute. | Safety requirement for high power industrial systems. | Test: Hipot Test | Should Have | Safety |
| **REQ-HW-212** | **Capacitor Ripple Current Rating** | The DC Link capacitor shall be rated for a ripple current of at least **50A RMS** at 20kHz. | Prevents capacitor overheating and failure due to AC current. | Analysis: Simulation | Mandatory | Component Stress |
| **REQ-HW-213** | **Deadtime Tolerance** | The variation in inserted deadtime between phases shall be less than **20ns**. | Prevents imbalance in 3-phase current waveforms. | Test: Scope Measurement | Should Have | Balance |

---

# 3. Hardware Requirements

## 3.3 Interface Requirements

### 3.3.1 External Interfaces

The external interfaces define the electrical and physical connections between the **rf44** motor controller and external system elements, including the power source, the motor, and control peripherals.

#### REQ-HW-019: DC Power Input Interface
**Description:** The system shall provide a connection point for the DC power source (Battery/Supercapacitor) capable of handling continuous currents of 250A and peak currents up to 400A to support the 10kW output power including regenerative currents.
**Priority:** Must have
**Validation:** Test, Inspection

**Interface Specification:**
*   **Connector Type:** Terminal Block or PCB Bus Bar (e.g., Anderson Powerpole, or M6 threaded stud).
*   **Terminal Designation:** `DC+` (Positive), `DC-` (Negative).
*   **Wire Gauge:** Support for 4 AWG to 2 AWG (25 mm² to 35 mm²).
*   **Isolation:** The DC input shall be galvanically isolated from the logic ground ( chassis earth) via the EMI filter components.

#### REQ-HW-020: Motor Output Interface (U, V, W)
**Description:** The system shall provide three high-current output terminals for connection to the 3-phase BLDC motor.
**Priority:** Must have
**Validation:** Test, Inspection

**Interface Specification:**
*   **Connector Type:** Terminal Block or PCB Bus Bar matching the input rating (M6 stud).
*   **Terminal Designation:** `U`, `V`, `W`.
*   **Current Rating:** Continuous 250A per phase.
*   **Insulation:** Rated for 600V isolation relative to the heatsink/chassis.

#### REQ-HW-021: Position Sensor Interface (Encoder/ABZ)
**Description:** The system shall provide a connector for the external position sensor (Incremental Encoder or Hall Effect).
**Priority:** Must have
**Validation:** Test

**Pin Definition Table (J_ENCODER):**

| Pin Number | Signal Name | Type        | Description                           | Source/Dest |
|------------|-------------|-------------|---------------------------------------|-------------|
| 1          | +5V_EN      | Power Out   | +5V Sensor Supply (Limited to 300mA)  | rf44        |
| 2          | GND_EN      | Ground      | Sensor Ground                         | rf44        |
| 3          | ENC_A       | Input       | Encoder Phase A (Differential or Single) | External    |
| 4          | ENC_B       | Input       | Encoder Phase B                       | External    |
| 5          | ENC_Z       | Input       | Encoder Index                         | External    |
| 6          | ENC_A-      | Input       | Encoder Phase A Complement (Diff)     | External    |
| 7          | ENC_B-      | Input       | Encoder Phase B Complement (Diff)     | External    |
| Shell      | SHIELD      | Chassis     | Cable Shield Connection               | Chassis     |

*Note: If single-ended encoder is used, Pins 6 and 7 remain unconnected (NC).*

#### REQ-HW-022: External Safety Interlock Interface
**Description:** The system shall provide a hardware emergency stop input that, when opened, immediately cuts the PWM signals to the gate drivers regardless of software state.
**Priority:** Must have
**Validation:** Test

*   **Connector:** 2-pin Pluggable screw terminal (3.81mm pitch).
*   **Logic:** Normally Open (NO) dry contact. Internal pull-up provided.
*   **Reaction Time:** Hardwired cutoff < 10 µs (via MCU BRK input or external logic gate).

---

### 3.3.2 Internal Interfaces

Internal interfaces refer to the electrical connections between sub-circuits on the **rf44** PCB (e.g., MCU to Gate Driver, Power Stage to Current Sense).

#### REQ-HW-023: MCU-to-Gate Driver PWM Interface
**Description:** The MCU shall generate six PWM signals (High/Low side pairs) and one Brake/Enable signal to control the 3x IR2101 Gate Drivers.
**Priority:** Must have
**Validation:** Inspection

**Pin Definition Table (J_DRV):**

| Signal Name   | Source  | Destination | Description                    | Logic Level | Voltage |
|---------------|---------|-------------|--------------------------------|-------------|---------|
| PWM_UH        | MCU     | INV Driver  | Phase U High-Side Gate Signal  | 3.3V CMOS   | 3.3V    |
| PWM_UL        | MCU     | INV Driver  | Phase U Low-Side Gate Signal   | 3.3V CMOS   | 3.3V    |
| PWM_VH        | MCU     | INV Driver  | Phase V High-Side Gate Signal  | 3.3V CMOS   | 3.3V    |
| PWM_VL        | MCU     | INV Driver  | Phase V Low-Side Gate Signal   | 3.3V CMOS   | 3.3V    |
| PWM_WH        | MCU     | INV Driver  | Phase W High-Side Gate Signal  | 3.3V CMOS   | 3.3V    |
| PWM_WL        | MCU     | INV Driver  | Phase W Low-Side Gate Signal   | 3.3V CMOS   | 3.3V    |
| nEN_DRV       | MCU     | INV Driver  | Active Low Enable for all drivers | 3.3V CMOS   | 3.3V    |

#### REQ-HW-024: Current Sense Analog Interface
**Description:** The analog outputs of the three INA240 amplifiers shall be routed to the MCU's ADC inputs.
**Priority:** Must have
**Validation:** Inspection

**Signal Routing Table:**

| Source          | Destination (MCU) | Net Name      | Signal Range | Filter        |
|-----------------|-------------------|---------------|--------------|---------------|
| INA240 (Phase U)| ADC1_IN0 (PA0)    | CURR_U_SENSE  | 0 - 3.3V     | RC Low-pass   |
| INA240 (Phase V)| ADC1_IN1 (PA1)    | CURR_V_SENSE  | 0 - 3.3V     | RC Low-pass   |
| INA240 (Phase W)| ADC1_IN2 (PA2)    | CURR_W_SENSE  | 0 - 3.3V     | RC Low-pass   |

*Assumption: Shunt resistors are 300 µΩ. Max current 200A $\rightarrow$ 60mV drop. Gain 20 V/V $\rightarrow$ 1.2V output. This stays safely within the 3.3V ADC range.*

#### REQ-HW-025: Gate Driver Bootstrap Interface
**Description:** The IR2101 drivers require external bootstrap capacitors and diodes connected to the switching nodes (Phase outputs).
**Priority:** Must have
**Validation:** Inspection

*   **Bootstrap Capacitors:** 10 µF, 35V Ceramic (X7R) connected between `BOOT` and `VS` pins of IR2101.
*   **Bootstrap Diodes:** Ultra-fast recovery diode (e.g., UF4007) connected from `VCC` (12V) to `BOOT`.

---

### 3.3.3 Communication Interfaces

#### REQ-HW-026: RS-485 Serial Communication
**Description:** The system shall implement an isolated RS-485 interface (half-duplex) using the MAX3485ESA+ transceiver for communication with an external Vehicle Control Unit (VCU) or Master PLC.
**Priority:** Must have
**Validation:** Test

**Interface Specifications:**
*   **Connector:** 3-pin Pluggable Screw Terminal (5.08mm pitch).
*   **Baud Rate:** Configurable 9600 bps to 115200 bps (Default: 115200).
*   **Protocol:** Modbus RTU or Custom Binary Protocol.

**Connector Pinout (J_RS485):**

| Pin Number | Signal Name   | Description                      |
|------------|---------------|----------------------------------|
| 1          | RS485_A (D+)  | Differential Data Positive        |
| 2          | RS485_B (D-)  | Differential Data Negative        |
| 3          | GND           | Signal Ground Reference          |

**Circuit Requirements:**
*   **Bias Resistors:** 560Ω resistors on A (pulled to Vcc) and B (pulled to GND) to ensure defined state when bus is idle.
*   **Termination:** 120Ω termination resistor across A and B lines (selectable via 0Ω resistor or jumper).
*   **ESD Protection:** TVS Diode array (e.g., SMBJ24CA) on A/B lines to chassis ground.
*   **Isolation:** The MAX3485 logic side shall be isolated from the RS-485 line side using a digital isolator (e.g., ADuM1201) to protect the MCU from ground loops in the motor system.

---

## 3.4 Environmental Requirements

### REQ-HW-027: Operating Ambient Temperature
**Description:** The electronic controller shall operate reliably in ambient temperatures ranging from **–40°C to +85°C**.
**Priority:** Must have
**Validation:** Test
**Derating:** Components (specifically the Aluminum Electrolytic DC Link capacitors and MOSFETs) shall be derated to ensure lifetime at +85°C ambient.
*   *Calculation:* At 85°C ambient, if power dissipation is 400W, and thermal resistance is 0.15°C/W (heatsink), rise is 60°C. Case temp = 145°C. This exceeds the limit. **Action:** Requirement updated in 3.5 (Thermal) to force active cooling or lower thermal resistance.

### REQ-HW-028: Storage Temperature
**Description:** The system shall survive storage in temperatures ranging from **–55°C to +125°C** without degradation.
**Priority:** Must have
**Validation:** Inspection

### REQ-HW-029: Humidity
**Description:** The system shall operate in relative humidity up to 95% (non-condensing).
**Priority:** Must have
**Validation:** Test
**Mitigation:** All PCBs shall be conformally coated (Acrylic or Urethane) to prevent moisture ingress and corrosion.

### REQ-HW-030: Vibration and Shock
**Description:** The controller shall withstand vibration and shock typical of industrial/automotive environments (IEC 60068-2-6 / IEC 60068-2-27).
**Priority:** Should have
**Validation:** Analysis
*   **Vibration:** 10 to 2000 Hz, 2G (RMS).
*   **Shock:** 40G, 11ms, half-sine wave.
*   **Hardware:** Heavy components (DC Link Caps, Heatsink) shall be secured with mechanical fixings (screws/standoffs) in addition to solder joints.

### REQ-HW-031: EMI Compliance
**Description:** The system shall meet electromagnetic interference requirements for industrial environments.
**Priority:** Must have
**Validation:** Test
**Standard:** **EN 55032 (Class A)** or **IEC 61800-3 (C2 Category)**.
*   **Conducted Emissions:** 150 kHz – 30 MHz (Input filter required).
*   **Radiated Emissions:** 30 MHz – 1 GHz.
*   **Design Features:**
    *   Input X-capacitors and Y-capacitors.
    *   Common Mode Choke on DC input.
    *   Shielded cables for Motor output (ferrite beads recommended).

---

## 3.5 Power Requirements

### REQ-HW-032: DC Bus Input Power
**Description:** The input power connection must supply the continuous power required by the motor plus losses.
**Priority:** Must have
**Validation:** Analysis

*   **Nominal Voltage:** 48 V DC
*   **Voltage Range:** 36 V – 60 V DC
*   **Max Input Current (Continuous):**
    *   $I_{in} = \frac{P_{out}}{V \times \eta} = \frac{10,000W}{48V \times 0.96} \approx 217A$
*   **Peak Input Current:** 400A (for 3-5 second acceleration bursts).

### REQ-HW-033: Auxiliary Power Supply (Logic Rails)
**Description:** The system shall generate internal low-voltage rails from the 48V DC Bus to power the MCU, Gate Drivers, and Sensors.
**Priority:** Must have
**Validation:** Test

**Power Budget Table:**

| Rail Name | Voltage | Source       | Load Components           | Est. Current | Max Current | Power (W) |
|-----------|---------|-------------|---------------------------|--------------|-------------|-----------|
| 12V_VCC   | 12 V    | Buck Conv   | Gate Drivers (3x IR2101)  | 30 mA        | 100 mA      | 1.2 W     |
| 5V_SENSOR | 5.0 V   | LDO / Buck  | Encoder/ Hall Sensors     | 250 mA       | 500 mA      | 1.25 W    |
| 3V3_MCU   | 3.3 V   | LDO         | STM32F405, Logic, LEDs    | 150 mA       | 300 mA      | 0.5 W     |
| 5V_ISO    | 5.0 V   | Iso Converter| RS-485 Isolated Side      | 50 mA        | 100 mA      | 0.25 W    |

**Total Auxiliary Power:** Approx 3.2 Watts at full load.
**Source:** A buck converter (e.g., LM5060 or similar) rated for 60V input, 5A output to be safe.

### REQ-HW-034: Gate Drive Power
**Description:** The bootstrap gate drive power is derived from the switched 12V VCC rail.
**Priority:** Must have
**Validation:** Inspection
*   **Charge Requirement:** $Q_g = 140 nC$ (IRFS7530).
*   **Frequency:** 20 kHz.
*   **Current per MOSFET:** $I = Q_g \times f_{sw} = 140nC \times 20kHz = 2.8 mA$.
*   **Total Gate Drive Current:** $2.8 mA \times 6 \text{ (MOSFETs)} = 16.8 mA$ (well within 12V rail capability).

### REQ-HW-035: Thermal Dissipation (Derating Analysis)
**Description:** The thermal design must ensure junction temperatures are not exceeded.
**Priority:** Must have
**Validation:** Analysis

**Thermal Analysis Calculation:**
*   **Target:** $T_j \le 125^\circ\text{C}$.
*   **Ambient:** $T_a = 85^\circ\text{C}$ (Worst case).
*   **Max Allowed Rise:** $\Delta T = 125^\circ\text{C} - 85^\circ\text{C} = 40^\circ\text{C}$.
*   **Total Losses:** 400W (4% of 10kW).
*   **Required Thermal Resistance ($R_{\theta sa}$):** $R_{\theta sa} = \frac{\Delta T}{P} = \frac{40^\circ\text{C}}{400W} = 0.1^\circ\text{C/W}$.

*Note:* A heatsink with 0.1 C/W without forced air is extremely large (massive extrusion). To meet this requirement in a reasonable form factor, the system **MUST** employ **forced air cooling (fan)** or liquid cooling, or the "10kW" requirement must be de-rated to a lower duty cycle at 85°C ambient.

**Constraint:** **REQ-HW-035-1**: The design shall include mounting provisions for a forced air fan (12V, 80mm) to maintain thermal limits. **Or**, the 10kW rating is specified at $40^\circ\text{C}$ ambient with 200 CFM airflow.

**Component Specific Thermal Limits:**
*   **MOSFET ($T_j$):** $\le 125^\circ\text{C}$ (IRFS7530 data).
*   **Schottky Diodes:** $\le 125^\circ\text{C}$.
*   **PCB $T_g$:** Material shall be High-Tg FR4 (Tg > 150°C) to survive soldering and high operating temps.

---

## 3.6 Physical Requirements

### REQ-HW-036: PCB Specifications
**Description:** The controller shall be built on a multi-layer Printed Circuit Board (PCB) to support high current switching and thermal management.
**Priority:** Must have
**Validation:** Inspection

**Stack-up:** **4 Layers** (Minimum 6 recommended for high current, but 4 acceptable with careful layout).
*   **Layer 1 (Top):** High Current Signal, Component Placement (SMD), 3 oz copper.
*   **Layer 2 (GND):** Ground Plane, 2 oz copper.
*   **Layer 3 (Power):** DC+ and Phase U/V/W routing (if needed), 2 oz copper. (Or GND pour for 4-layer).
*   **Layer 4 (Bottom):** Control Signals, Gate Drive Logic, Heatsink Pad (for DirectFET), 3 oz copper.

**Copper Weight:**
*   **Outer Layers:** 3 oz/ft² (105 µm) minimum to handle 200A+ phase currents.
*   **Inner Layers:** 2 oz/ft² (70 µm) minimum.

**Trace Width Calculation:**
*   Target Current: 208A.
*   Temp Rise: 10°C.
*   Width (External, 3oz): Approx 25 mm (1.0 inch) of trace width per amp is a rule of thumb, but for high current, **copper pours (planes)** are used instead of traces.
*   **Requirement:** All high-current paths (DC Link to MOSFETs, MOSFETs to Motor Outputs) shall be established as **copper pours** covering at least 40% of the PCB surface area.

### REQ-HW-037: Enclosure and Heatsinking
**Description:** The hardware shall be designed for integration into an industrial enclosure.
**Priority:** Must have
**Validation:** Inspection

*   **Heatsink Material:** Aluminum 6061-T6 or Copper.
*   **Thermal Interface:** The MOSFETs (DirectFET) shall be soldered directly to the PCB. The PCB bottom layer shall interface with the heatsink using thermal vias and a Thermally Conductive Pad (e.g., Berquist Sil-Pad, 1W/m-K).
*   **Mounting:** PCB shall use rigid standoffs (M4 or M5) to prevent board flexure due to heavy capacitors/heatsink.

### REQ-HW-038: Connector Locations
**Description:** Connectors shall be placed along one edge ("Panel Mount" edge) of the PCB for easy integration into the enclosure.
**Priority:** Should have
**Validation:** Inspection
*   **Layout:** High Power connectors (DC In, Motor Out) on one side. Control/Signal connectors (RS-485, Encoder) on opposite or adjacent side to prevent noise coupling.

### REQ-HW-039: Clearances and Creepage
**Description:** The PCB layout must maintain isolation spacing per UL 60950-1 or IEC 60664-1.
**Priority:** Must have
**Validation:** Inspection
*   **Voltage:** 48V DC is considered Safety Extra-Low Voltage (SELV) / Low Voltage, however, transients can reach 60V-100V.
*   **Clearance:** Minimum 3.0 mm (Pollution Degree 2).
*   **Creepage:** Minimum 3.2 mm (Pollution Degree 2).
*   **Slots:** A 2mm routing slot shall be placed under high-voltage isolation points (e.g., between Gate Driver Logic and Power Stage) if necessary.

---

**Document Status: AI-GENERATED**

# 4. Design Constraints

## 4.1 Standards Compliance

The design and manufacturing of the rf44 10kW Motor Controller shall adhere to the following industry standards and regulations. These constraints ensure the safety, reliability, environmental compatibility, and legal marketability of the hardware.

### 4.1.1 Safety and Regulatory Compliance
**REQ-HW-401:** The system shall comply with **UL 60950-1** (or **IEC 62368-1**) for "Safety of Information Technology Equipment." Given the 48V DC input (60V max), this falls under SELV (Safety Extra-Low Voltage) limits; however, the high output current and energy storage capabilities necessitate strict adherence to fire enclosure and spacing requirements.

**REQ-HW-402:** The design shall comply with **IEC 61800-5-1** (Adjustable Speed Electrical Power Drive Systems - Part 5-1: Safety Requirements). This specifically addresses electrical, thermal, and mechanical safety associated with Power Drive Systems (PDS).

**REQ-HW-403:** The system shall meet **RoHS (Restriction of Hazardous Substances) Directive 2011/65/EU** and **REACH (EC 1907/2006)** requirements. All PCBs, cables, and assemblies shall be Lead-Free (LF) and marked accordingly.

**REQ-HW-404:** The system shall comply with **FCC Part 15 Subpart B** (Class A Industrial) and **ICES-003 Issue 6** (Canada) for radiated and conducted emissions.

**REQ-HW-405:** The system shall demonstrate compliance with **EN 55032** (Multimedia equipment - Radiofrequency disturbance limits) and **EN 61000-6-2** (Immunity for Industrial Environments).

### 4.1.2 PCB Design and Layout Standards
**REQ-HW-410:** The Printed Circuit Board (PCB) design shall strictly adhere to **IPC-2221** (Generic Standard on Printed Board Design). Specific calculations for trace width, clearance, and current carrying capacity shall be derived from **IPC-2152** (Standard for Determining Current-Carrying Capacity in Printed Board Design).

**REQ-HW-411:** High-current traces (DC Bus and Motor Phases) shall be calculated based on a maximum temperature rise of **20°C** above ambient. For the phase current requirement of **208A peak**, the external layers must utilize copper weights of **4 oz to 6 oz (140µm - 210µm)**. If internal layers are used for high current, they must be significantly widened or doubled up to account for reduced heat dissipation compared to external layers.

**REQ-HW-412:** Creepage and clearance distances for the 48V DC input (which can transiently reach 60V) shall meet the requirements for **Pollution Degree 2** (per IEC 60664) and **Overvoltage Category II**.
*   *Minimum clearance:* 2.0 mm (conservative for 60VDC transients).
*   *Minimum creepage:* 2.5 mm (considering functional insulation requirements).

**REQ-HW-413:** The PCB assembly shall meet **IPC-A-610 Class 2** (Acceptability of Electronic Assemblies) standards for workmanship, with target criteria aiming for **Class 3** (High Performance Products) for the power stage solder joints to mitigate thermal fatigue.

### 4.1.3 Environmental and Mechanical Standards
**REQ-HW-420:** The enclosure and cooling design shall facilitate **IEC 60529** (Degrees of Protection provided by Enclosures) rating **IP20** (protected against solid objects >12.5mm, no water protection required for open-frame chassis mount) unless specified otherwise by the application enclosure.

**REQ-HW-421:** The system shall meet **IEC 60068-2** environmental testing standards:
*   **IEC 60068-2-14:** Temperature cycling (-40°C to +85°C).
*   **IEC 60068-2-6:** Vibration testing (random vibration 10Hz to 500Hz, typical industrial profile).

### 4.1.4 Electromagnetic Compatibility (EMC)
**REQ-HW-430:** The EMI input filter design and PCB layout shall satisfy **EN 55032 Class A** limits for conducted emissions (150 kHz – 30 MHz) and radiated emissions (30 MHz – 1 GHz).

**REQ-HW-431:** To minimize EMI, the gate drive loop area must be minimized. The length of the high-frequency switching node (phase node) shall be less than **20 mm** from the MOSFET drain to the bootstrap capacitor anode.

---

## 4.2 Component Constraints

This section defines the limitations and selection criteria for electronic components based on the "Component Recommendations" provided in the system architecture.

### 4.2.1 Component Derating and Lifecycle
**REQ-HW-450:** All active and passive components shall be derated to ensure reliability at the upper end of the industrial temperature range (+85°C ambient, potentially >100°C junction).
*   **Voltage Derating:** Capacitors and Semiconductors shall be operated at ≤ **80%** of their rated maximum voltage.
    *   *Example:* The DC Link Capacitor rated for 63V or higher must be used for a 60V max bus. MOSFETs rated for 30V (IRFS7530) are operating at >80% rating for a 48V nominal bus.
    *   *Constraint Analysis:* The selection of the **IRFS7530TRL7PP** (30V VDS) presents a critical constraint. Under regenerative braking or transient load dumps, the 48V bus can spike. A 30V MOSFET offers **0%** voltage margin for a nominal 48V bus and **< 50%** margin for a 60V max bus. **Constraint Exception:** If IRFS7530 is used, strict input voltage clamping (TVS/Transient suppressor) must be active at 55V, **OR** the component selection MUST be changed to the **BSC078N12NS3G** (80V) alternative to meet the derating requirement of REQ-HW-401. *Assumption for this document: The design will utilize the BSC078N12NS3G or an equivalent 60V/80V MOSFET to satisfy safety derating.*

**REQ-HW-451:** Components shall be selected from sources with a minimum availability life cycle of **5 years** from the date of production. "Not Recommended for New Designs" (NRND) components are prohibited without engineering approval.

**REQ-HW-452:** All components shall be available in **Surface Mount Technology (SMT)** packages suitable for pick-and-place assembly. Through-hole components are restricted to connectors and high-power screw terminals only.

### 4.2.2 Specific Component Constraints
**REQ-HW-460 (Microcontroller):** The **STM32F405RGT6** is the baseline requirement.
*   **Constraint:** The firmware must fit within 1MB Flash and 192KB RAM.
*   **Constraint:** The LQFP-64 package footprint must be strictly followed on the PCB land pattern.
*   **Clock:** The design must provide a stable 8MHz HSE (High Speed External) crystal for the system clock to meet USB/UART accuracy requirements.

**REQ-HW-461 (Gate Drivers):** The **IR2101** drivers require a bootstrap capacitor.
*   **Constraint:** The bootstrap capacitor value shall be calculated based on the gate charge (Qg) of the MOSFET and the switching frequency.
    *   *Calculation:* $Q_g \approx 140 \text{ nC}$. For $V_{drop} < 0.5V$ at 20kHz: $C_{boot} \geq \frac{Q_g}{\Delta V} = \frac{140\text{nC}}{0.5} \approx 280 \text{ nF}$. A standard **470 nF** or **1.0 µF** ceramic capacitor (X7R, 25V min) shall be used.
*   **Constraint:** The high-side floating supply absolute voltage rating (600V) sets the maximum allowable isolation distance between the gate driver IC and the power MOSFETs.

**REQ-HW-462 (Current Sense):** The **INA240A1PW** amplifier has a specific input common-mode range.
*   **Constraint:** The input voltage of the INA240 must not exceed +80V or go below -80V relative to ground.
*   **Constraint:** The shunt resistors must be **Four-Terminal (Kelvin)** type to minimize inductance and ensure accurate measurement at high frequencies. The power rating of the shunt must handle $I^2R$ losses.
    *   *Calculation:* For 200A peak and a 0.5 mOhm shunt: $P = (200)^2 \times 0.0005 = 20 \text{ Watts (pulse)}$. A continuous rating of at least **3W to 5W** is required for the resistor.

**REQ-HW-463 (DC Link Capacitor):** Aluminum Electrolytic or Film capacitors shall be used for bulk storage.
*   **RMS Current Constraint:** The capacitor must handle the RMS ripple current.
    *   *Ripple Estimate:* $I_{ripple} \approx 0.5 \times I_{phase\_peak} \approx 100A$. The selected capacitor must have an RMS ripple current rating > 100A at 100°C (or use multiple parallel parts).
*   **ESR Constraint:** Equivalent Series Resistance (ESR) must be low enough to prevent excessive voltage ripple.
    *   *Calculation:* $\Delta V = I_{ripple} \times ESR$. For $\Delta V < 2V$: $ESR < 2V / 100A = 20 \text{ m}\Omega$.

**REQ-HW-464 (RS-485 Transceiver):** The **MAX3485ESA+** operates at 3.3V logic levels.
*   **Constraint:** The MCU UART pins must be 3.3V tolerant (standard on STM32F405). Level shifters are not required.
*   **Constraint:** The fault pin (if utilized) requires a pull-up resistor defined by the MCU GPIO configuration.

---

## 4.3 Manufacturing Constraints

This section addresses the physical realization, testing, and quality constraints for the rf44 project.

### 4.3.1 PCB Fabrication and Assembly
**REQ-HW-480:** The PCB shall be constructed using a minimum of **4 Layers**.
*   **Layer Stackup:**
    *   Layer 1 (Top): Signals, High Current Traces (Components)
    *   Layer 2: Ground Plane (Solid)
    *   Layer 3: Power Plane (48V DC Bus distribution)
    *   Layer 4 (Bottom): Signals, Low Current Control Logic.

**REQ-HW-481:** To manage the thermal dissipation of the DirectFET MOSFETs (if used) or D2PAK/TO-220 alternatives, the PCB under the FETs shall utilize **Copper Vias (Thermal Vias)**.
*   **Via Count:** Minimum 12 vias under the drain tab for DirectFET.
*   **Via Size:** 0.3mm drill diameter, filled and plugged (tented) to prevent solder wicking during assembly.

**REQ-HW-482:** The board finish shall be **Immersion Gold (ENIG)** or **Immersion Silver (IAg)** to support the fine pitch of the LQFP-64 MCU and to ensure good wetting for the high-current pads.

**REQ-HW-483:** Solder mask shall be applied to the board. However, the high-current conduction paths (DC Bus input, Motor Phase outputs) may utilize **Exposed Copper (Nickel/Gold Plated Bus Bars)** or heavy solder mask defined (SMD) pads to allow wiring with crimped lugs or heavy gauge wires.

### 4.3.2 Testability and Debug (DFT)
**REQ-HW-490:** The design shall include a standard **10-pin ARM Cortex Debug Connector (0.05" pitch)** footprint (SWD) for the STM32F405.
*   **Signals:** VDD, GND, SWDIO, SWCLK, RESET, NRST, SWO (optional).

**REQ-HW-491:** Test Points (TP) shall be provided for all critical analog signals:
*   DC Bus Voltage (sensed)
*   Phase U, V, W Currents (amplified output)
*   Gate Drive Outputs (HO_U, LO_U, etc.)
*   V_ref (3.3V)

**REQ-HW-492:** The board shall support **In-Circuit Testing (ICT)** or **Flying Probe** testing. All nets shall be accessible via test points or component pads where possible. High voltage nodes shall be isolated for safety testing.

### 4.3.3 Conformal Coating
**REQ-HW-500:** Given the industrial environment (-40 to +85°C, potential humidity/vibration), the assembled PCB shall be coated with a **Acrylic or Urethane Conformal Coating** (e.g., Humiseal 1B31 or equivalent).
*   **Masking:** All connectors (UART/RS485, Power Terminals), LED indicators, and the MCU programming header shall be masked from coating.
*   **Exclusion:** The power MOSFETs and heatsink interface area shall not be coated to ensure optimal thermal transfer, or a thermally conductive (but electrically insulating) coating shall be used if the MOSFETs are coated.

### 4.3.4 Mechanical Assembly
**REQ-HW-510:** The heatsink assembly shall utilize **M4 or M5 Standoffs and Screws**.
*   **Torque Constraint:** The screw torque for mounting the MOSFETs to the heatsink shall be strictly controlled to prevent cracking the semiconductor die or PCB substrate (typical torque 0.6 Nm for M4, refer to MOSFET datasheet).
*   **Thermal Interface Material (TIM):** A high-performance thermal pad or phase-change material (e.g., Bergquist Sil-Pad) must be used between the MOSFET and heatsink. The thickness shall be chosen to accommodate surface irregularities while minimizing thermal resistance (Target thickness: 0.2mm - 0.5mm).

---

**Document Status: AI-GENERATED**

# 5. Verification Requirements

This section defines the verification methods for the hardware requirements specified in Section 3. The requirements are categorized into Test Requirements (dynamic electrical characteristics), Analysis Requirements (calculations, simulations, and thermal/structural margins), and Inspection Requirements (visual and mechanical conformity).

## 5.1 Test Requirements

This subsection details the electrical testing required to validate the functional and performance specifications of the `rf44` 10kW Motor Controller. All tests are to be performed at nominal ambient temperature (25°C) unless otherwise specified, with final verification performed at temperature extremes (-40°C and +85°C).

### 5.1.1 Power Stage & Output Tests

**Test ID:** T-HW-001  
**Requirement ID:** REQ-HW-001, REQ-HW-016  
**Title:** 3-Phase Output Voltage Saturation & Current Stress Test  
**Description:** Verify the inverter can drive a 10kW load (resistive/reactive load bank or dynamometer) at 48V DC bus without saturation or excessive voltage drop.  
**Procedure:**
1. Connect the Controller Output to a 3-phase load bank capable of dissipating 10kW.
2. Apply 48V DC to the input bus.
3. Configure MCU to output 3-phase sine waves (or SVM) at 20 kHz switching frequency.
4. Increase modulation index until phase current reaches 208A RMS.
5. Monitor Phase-to-Phase voltage amplitude and linearity.
6. Run for 60 minutes (thermal soak).

**Pass Criteria:**
- Phase-to-Phase voltage (fundamental) is within 5% of theoretical max ($V_{out} \approx \frac{V_{bus}}{\sqrt{3}}$).
- No audible "strangling" or PWM distortion.
- Device does not trip on Overtemperature (assuming cooling is active).

---

**Test ID:** T-HW-002  
**Requirement ID:** REQ-HW-001, REQ-HW-011  
**Title:** Switching Frequency & Deadtime Verification  
**Description:** Verify the MOSFET gate drivers can sustain 50 kHz switching frequency without overheating or suffering from shoot-through.  
**Procedure:**
1. Connect oscilloscope probes (High Voltage differential or isolated) to Low-Side and High-Side Gate pins (relative to Source) of Phase A.
2. Configure MCU for 50 kHz PWM frequency with 520ns deadtime (standard for IR2101).
3. Capture the Gate-to-Source waveforms ($V_{gs}$) for both MOSFETs during a switching transition.
4. Measure deadtime insertion and propagation delay.

**Pass Criteria:**
- $V_{gs}$ rises cleanly to 12V–15V (Gate Drive voltage) at 50 kHz.
- No Miller Plateau-induced cross-conduction (shoot-through) observed.
- Deadtime is consistently > 400 ns and < 600 ns.

---

**Test ID:** T-HW-003  
**Requirement ID:** REQ-HW-004  
**Title:** Current Sensing Accuracy & Linearity  
**Description:** Verify the accuracy of the 3-phase current sensing circuit using the INA240 across the full dynamic range (-220A to +220A).  
**Procedure:**
1. Inject a known bidirectional current into a single phase using a calibrated current source (or high-precision shunt).
2. Sweep current from -220A to +220A in steps of 20A.
3. Record the ADC output code (from MCU) and the differential voltage at the INA240 output.
4. Calculate error against the ideal transfer function.

**Pass Criteria:**
- Measurement error $\le$ 2% of full-scale scale (FSR) across the range.
- Zero current offset < 0.5A.
- Signal-to-Noise Ratio (SNR) sufficient to distinguish 1A steps.

---

**Test ID:** T-HW-004  
**Requirement ID:** REQ-HW-008  
**Title:** Overcurrent Protection Response Time  
**Description:** Verify that the hardware trip circuitry disables the PWM fast enough to prevent MOSFET failure during a hard short circuit.  
**Procedure:**
1. Set up a "Hard Switch" fault injection rig (low inductance short across DC Bus).
2. Enable Inverter with low current (10A) to maintain operation.
3. Trigger the short circuit (via controlled contactor or MOSFET).
4. Capture current waveform (using current probe) and PWM disable signal (GPIO) on oscilloscope.
5. Measure the time from current crossing threshold (e.g., 250A) to PWM turn-off.

**Pass Criteria:**
- Total response time (Detection + Processing + Turn-off) $\le$ 5 µs.
- Peak current during fault does not exceed MOSFET Safe Operating Area (SOA).

---

**Test ID:** T-HW-005  
**Requirement ID:** REQ-HW-013  
**Title:** Efficiency Measurement (Power Losses)  
**Description:** Confirm the system meets the $\ge$ 96% efficiency target at rated power.  
**Procedure:**
1. Connect the controller to a dynamometer (or high-quality regenerative load).
2. Set DC Bus Input to 48.0V.
3. Run motor at a speed/load point corresponding to 10kW mechanical output.
4. Measure Input Power ($P_{in} = V_{bus} \times I_{bus}$) and Output Power ($P_{out} = \tau \times \omega$).
5. Calculate Efficiency: $\eta = \frac{P_{out}}{P_{in}} \times 100\%$.
6. Repeat for 25%, 50%, 75%, 100%, and 125% load.

**Pass Criteria:**
- Efficiency $\ge$ 96.0% at 10kW rated point.
- Total measured losses $\le$ 415W.

---

### 5.1.2 Control & Interface Tests

**Test ID:** T-HW-006  
**Requirement ID:** REQ-HW-003  
**Title:** Position Sensor Interface Integration  
**Description:** Validate the MCU's ability to read and decode the external position sensor (Encoder/Hall) without noise or jitter.  
**Procedure:**
1. Connect a calibrated Quadrature Encoder (e.g., 2000 PPR) to the sensor input.
2. Spin the encoder manually at varying speeds (slow to ~6000 RPM equivalent).
3. Use a debug script to log captured position and calculated velocity.
4. Check for missed steps or backward jumps.

**Pass Criteria:**
- Zero missed counts recorded over 10,000 revolutions.
- Velocity estimation jitter < 1% at 1000 RPM.

---

**Test ID:** T-HW-007  
**Requirement ID:** REQ-HW-006  
**Title:** RS-485 Communication Robustness  
**Description:** Verify UART/RS-485 communication integrity under noise load.  
**Procedure:**
1. Connect `rf44` to a host PC via RS-485 (twisted pair).
2. Terminate the bus with 120$\Omega$ resistor at both ends.
3. Operate the motor at 10kW to generate maximum EMI.
4. Transmit continuous packets (100 Hz) containing incrementing counters.
5. Inject common-mode noise onto the RS-485 lines (using a noise generator or coupling a motor driver line nearby).

**Pass Criteria:**
- Bit Error Rate (BER) = 0 (no corrupted packets over 10,000 transactions).
- CRC checks pass 100% of the time.

---

## 5.2 Analysis Requirements

This subsection details the analytical and simulation work required to verify requirements that are destructive, difficult to measure physically, or reliant on complex environmental factors.

### 5.2.1 Thermal Analysis

**Analysis ID:** A-HW-001  
**Requirement ID:** REQ-HW-010, REQ-HW-017  
**Title:** Heatsink & Junction Temperature Simulation  
**Description:** Perform a Finite Element Analysis (FEA) or lumped-parameter thermal simulation to verify MOSFET junction temperatures remain safe under worst-case ambient conditions.  
**Methodology:**
- **Inputs:** $P_{loss} \approx 350W$ (Total MOSFET losses @ 208A), $R_{\theta JC} = 0.4^\circ C/W$ (approx for DirectFET), Heatsink Thermal Resistance.
- **Model:** Construct a thermal resistance network: $T_j = T_a + (P \times R_{\theta JA})$.
- **Scenario 1:** $T_a = 25^\circ C$ (Forced Air, 200 LFM).
- **Scenario 2:** $T_a = 85^\circ C$ (Still Air, Worst Case Ambient).

**Calculations (Sample for Phase Leg):**
Assumptions:
- Current ($I_{rms}$) = 208A.
- $R_{DS(on)}$ (IRFS7530) = $1.5 m\Omega$.
- Conduction Loss ($P_{cond}$) per MOSFET $\approx I^2 \times R \times Duty$.
  $P_{cond} \approx (208)^2 \times 0.0015 \times 0.5 \approx 32.5 W$.
- Switching Loss ($P_{sw}$) estimated at 15W per FET at 20kHz.
- Total losses per 6-MOSFET bridge $\approx 6 \times (32.5 + 15) = 285 W$.
- Add Gate Driver/Misc losses $\approx 15W$.
- **Total Power to Dissipate $\approx 300W$.**

**Required Thermal Resistance ($R_{\theta SA}$):**
Target $T_j \le 125^\circ C$.
Max $\Delta T = T_j - T_a = 125^\circ C - 85^\circ C = 40^\circ C$.
Max System $R_{\theta SA} = \frac{\Delta T}{P_{total}} = \frac{40}{300} = 0.133^\circ C/W$.

**Pass Criteria:**
- Selected Heatsink (e.g., extruded aluminum with forced fan) must have $R_{\theta SA} \le 0.13^\circ C/W$.
- FEA simulation must show no hotspots exceeding $125^\circ C$ junction temperature.

---

### 5.2.2 Power Integrity & Stability Analysis

**Analysis ID:** A-HW-002  
**Requirement ID:** REQ-HW-009  
**Title:** DC Link Capacitor Ripple & Voltage Deviation  
**Description:** Analyze the DC Link capacitor bank to ensure voltage ripple remains within FOC algorithm limits ($\Delta V < 5\%$).  
**Methodology:**
1. Calculate maximum ripple current based on motor phase current and modulation index.
2. Verify capacitor RMS current rating ($I_{rms}$) is not exceeded.
3. Calculate voltage droop under maximum regenerative braking energy.

**Calculations:**
- Peak Ripple Current $I_{ripple} \approx 0.5 \times I_{phase} \approx 100A$.
- Selected Caps: 2x 470µF electrolytic + 10µF ceramic.
- ESR Check: Voltage ripple $\Delta V = I_{ripple} \times ESR_{total}$.
- If $ESR < 1 m\Omega$, then $\Delta V \approx 0.1V$. (Pass).

**Pass Criteria:**
- Capacitor $I_{rms}$ rating > 20A (per datasheet of large screw-terminal or radial caps).
- Calculated ripple $\Delta V < 2.4V$ (5% of 48V).

---

**Analysis ID:** A-HW-003  
**Requirement ID:** REQ-HW-016  
**Title:** MOSFET Voltage Transient Analysis (Vds Spike)  
**Description:** Analyze the parasitic inductance of the power loop and the resulting voltage spike on $V_{DS}$ during turn-off.  
**Methodology:**
- Extract stray inductance from PCB layout ($L_{stray} \approx 10-20 nH$).
- Simulate turn-off event: $V_{spike} = L_{stray} \times \frac{di}{dt}$.
- Assume $\frac{di}{dt} \approx 200 A / 50 ns = 4 A/ns$.
- $V_{spike} = 20 nH \times 4 A/ns = 80 V$.
- Peak Voltage = $V_{bus} + V_{spike} = 48V + 80V = 128V$.

**Pass Criteria:**
- Peak Voltage (128V) must be < MOSFET $V_{DSS}$ rating (30V for IRFS7530).
  - **CRITICAL NOTE:** The calculation (128V > 30V) indicates a potential failure mode with the selected 30V MOSFET if $L_{stray}$ is high. The design must minimize loop inductance (thick copper, parallel layers) to reduce spike, OR select a 60V/80V MOSFET.
  - *Revised Pass Criteria for this document:* $L_{stray}$ must be reduced to $< 5 nH$ via layout, keeping spike < 20V.

---

## 5.3 Inspection Requirements

This subsection lists the visual, mechanical, and "paper" verification activities to ensure design intent is met before power is applied.

### 5.3.1 PCB Assembly & Manufacturing

**Inspection ID:** I-HW-001  
**Requirement ID:** REQ-HW-018  
**Title:** PCB Fabrication and Stack-up Verification  
**Description:** Verify the physical PCB matches the design parameters (layer count, copper weight, trace width).  
**Method:**
- Microscopic inspection of PCB cross-section.
- Measurement of trace widths on power layers.

**Pass Criteria:**
- PCB is 4 layers or more.
- Power layer copper weight $\ge 2 oz$ (70 µm).
- High current traces (Phase A/B/C, DC Bus) width $\ge 10mm$ or equivalent copper area.

---

**Inspection ID:** I-HW-002  
**Requirement ID:** REQ-HW-005, REQ-HW-018  
**Title:** Bootstrap Circuit Assembly Check  
**Description:** Visual inspection of the bootstrap capacitors and gate drive supply isolation.  
**Method:**
- Verify polarity of electrolytic bootstrap capacitors.
- Check for shorts between HV (48V) and Logic (3.3V) planes.

**Pass Criteria:**
- No assembly defects (bridging, tombstoning).
- Bootstrap capacitor values match BOM (e.g., 10µF, 35V).

---

### 5.3.2 Component & Compliance Verification

**Inspection ID:** I-HW-003  
**Requirement ID:** REQ-HW-014  
**Title:** Temperature Rating Compliance Check  
**Description:** Review BOM to ensure all active and critical passive components are rated for Industrial Temperature range.  
**Method:**
- Datasheet review of primary components: MCU, Gate Drivers, MOSFETs, Op-Amps.
- Check part numbers for "I" or "E" suffix indicating industrial temp (-40 to +85°C or +125°C).

**Pass Criteria:**
- All primary components rated for $T_a \ge 85^\circ C$.
- Electrolytic capacitors rated for $105^\circ C$ lifetime derating.

---

**Inspection ID:** I-HW-004  
**Requirement ID:** REQ-HW-015  
**Title:** EMI/EMC Layout Inspection  
**Description:** Visual inspection of the PCB layout to ensure EMI mitigation design rules were followed.  
**Method:**
- Verify input filter placement (components close to connector).
- Check for minimization of high-frequency loop areas.
- Verify presence and placement of shield cans or ferrite beads if designed.

**Pass Criteria:**
- Input EMI filter inductors/capacitors placed immediately adjacent to DC Input connector.
- Gate driver loops (Source to Gate) minimized (< 2 cm length).

---

# Verification Summary Matrix

The following table maps the requirements defined in Section 3 to the verification methods detailed in Section 5.

| REQ-ID | Requirement Title | Verification Method | Pass Criteria Summary |
| :--- | :--- | :--- | :--- |
| **REQ-HW-001** | 3-Phase Inverter Output | T-HW-001 (Power Stage Test) | Drives 208A phase current without saturation. |
| **REQ-HW-002** | FOC Algorithm | Demonstration (SW) | Motor runs smoothly; torque ripple < 5%. |
| **REQ-HW-003** | Position Sensor Interface | T-HW-006 (Sensor Test) | Zero missed counts; velocity stable. |
| **REQ-HW-004** | 3-Phase Current Sensing | T-HW-003 (Accuracy Test) | Error $\le$ 2% FSR. |
| **REQ-HW-005** | Bootstrap Gate Drive | T-HW-002 (Switching Test) | Clean 15V gate drive; no cross-conduction. |
| **REQ-HW-006** | UART/RS-485 Comm | T-HW-007 (Comm Test) | 0% Packet error at 10kW noise load. |
| **REQ-HW-007** | DC Bus Voltage Sensing | T-HW-003 (Accuracy Test) | Accuracy within 1% (ADC + Divider). |
| **REQ-HW-008** | Overcurrent Protection | T-HW-004 (Fault Response) | Trip time $\le$ 5 µs. |
| **REQ-HW-009** | DC Bus Link Capacitor | A-HW-002 (Ripple Analysis) | Ripple < 5%. |
| **REQ-HW-010** | Heat Dissipation | A-HW-001 (Thermal Analysis) | $T_j \le 125^\circ C$ at $T_a = 85^\circ C$. |
| **REQ-HW-011** | Switching Frequency | T-HW-002 (Switching Test) | Stable operation at 20 kHz (up to 50 kHz). |
| **REQ-HW-012** | Current Control Bandwidth | Demonstration (SW/Bode) | Bandwidth $\ge$ 1 kHz. |
| **REQ-HW-013** | Efficiency Target | T-HW-005 (Efficiency Test) | $\eta \ge 96\%$ @ 10kW. |
| **REQ-HW-014** | Industrial Temp Range | I-HW-003 (Compliance Check) + Thermal Chamber Test | All components rated -40 to +85°C. |
| **REQ-HW-015** | EMI/EMC Compliance | I-HW-004 (Layout Insp.) + EMC Scan | Pass EN 55032 Class A limits. |
| **REQ-HW-016** | 48V DC Bus Constraints | A-HW-003 (Transient Analysis) | $V_{ds\_peak} < V_{rating}$ (via layout/control). |
| **REQ-HW-017** | Power Budget | A-HW-001 (Thermal Analysis) | Total Losses $\le$ 400W. |
| **REQ-HW-018** | PCB Constraints | I-HW-001 (Fab Inspection) | Min 4 layers, 2oz copper power traces. |

---

# 6. Bill of Materials (Preliminary)

This section lists the preliminary Bill of Materials (BOM) for the **rf44 48V 10kW Motor Controller**. The BOM is categorized by functional block. Cost estimates are based on 100-unit quantity pricing from major distributors (DigiKey, Mouser, Avnet) as of the current date and are subject to change.

**Assembly Information:**
- **PCB Reference:** rf44-REV-A1
- **Assembly Variant:** Production
- **Total Estimated Material Cost (MCMS):** $292.75 (Excluding heatsink and chassis)

## 6.1 Power Stage (Inverter)

| Item No | Ref Des | Part Number | Description | Manuf | Qty | Unit Cost | Total Cost | Notes |
|---|---|---|---|---|---|---|---|---|
| 100 | Q1-Q6 | **IRFS7530TRL7PP** | MOSFET N-Ch 30V 200A DirectFET | Infineon | 6 | $8.50 | $51.00 | Primary Switching Devices. Max Rds(on) 1.5mΩ. |
| 110 | C1-C4 | **B82790C2103N202** | EMI Filter Choke 10µH 30A | TDK | 1 | $4.20 | $4.20 | Input Common Mode Choke. |
| 120 | C5-C6 | **B32352C4106J** | Film Cap 10µF 100V DC | TDK | 4 | $1.80 | $7.20 | DC Link Snubber/Damping. |
| 130 | C7-C12 | **UPW1H471MPD** | Electrolytic Cap 470µF 63V | Nichicon | 6 | $2.50 | $15.00 | DC Link Bulk Capacitor (Rail mounted to PCB). |
| 140 | R1-R3 | **WSLP2512** | Shunt Resistor 0.0005Ω 1% 3W | Vishay | 3 | $1.85 | $5.55 | Phase Current Sense (Kelvin connected). |
| 150 | R4-R6 | **WSLP2512** | Shunt Resistor 0.001Ω 1% 2W | Vishay | 3 | $1.45 | $4.35 | DC Bus Current Sense. |
| 160 | TVS1 | **SMBJ48CA** | TVS Diode 48V Bidirectional | Littelfuse | 2 | $0.45 | $0.90 | Input Overvoltage Clamp. |
| **Subtotal** | | | | | | | **$93.20** | |

## 6.2 Gate Drive & Bootstrap

| Item No | Ref Des | Part Number | Description | Manuf | Qty | Unit Cost | Total Cost | Notes |
|---|---|---|---|---|---|---|---|---|
| 200 | U1, U2, U3 | **IR2101SPBF** | High/Low Side Driver 600V | Infineon | 3 | $3.10 | $9.30 | One per phase. SOIC-8 Package. |
| 210 | C20-C22 | **C3216X5R1V226M** | Ceramic Cap 22µF 35V X5R | TDK | 3 | $0.85 | $2.55 | Bootstrap Capacitors. |
| 220 | R10-R18 | **CRCW1206** | Resistor 10Ω 1206 | Vishay | 9 | $0.05 | $0.45 | Gate Series Resistors. |
| 230 | R19-R21 | **CRCW1206** | Resistor 100Ω 1206 | Vishay | 3 | $0.05 | $0.15 | Gate Pull-down. |
| 240 | D1-D3 | **ES2J** | Ultrafast Rectifier 200V 2A | ON Semi | 3 | $0.35 | $1.05 | Bootstrap Recovery Diodes. |
| **Subtotal** | | | | | | | **$13.50** | |

## 6.3 Control & Sensing (MCU)

| Item No | Ref Des | Part Number | Description | Manuf | Qty | Unit Cost | Total Cost | Notes |
|---|---|---|---|---|---|---|---|---|
| 300 | U100 | **STM32F405RGT6** | MCU Cortex-M4F 168MHz 1MB Flash | STMicro | 1 | $12.50 | $12.50 | Main Controller. LQFP-64. |
| 310 | Y1 | **ABM8-25.000MHZ-D2Y-T** | Crystal 25MHz 20ppp | Abracon | 1 | $1.20 | $1.20 | System Clock. |
| 320 | U101 | **LD1117S33TR** | LDO Regulator 3.3V 800mA | STMicro | 1 | $0.60 | $0.60 | Logic Supply. |
| 330 | C101-C106 | **GRM188R61E106KA** | Ceramic Cap 10µF 25V X5R | Murata | 6 | $0.25 | $1.50 | MCU Decoupling. |
| 340 | R100 | **ERA-6AEB103V** | Resistor 10kΩ 0.1% | Panasonic | 1 | $0.15 | $0.15 | Reset Pull-up. |
| **Subtotal** | | | | | | | **$15.95** | |

## 6.4 Analog Signal Conditioning

| Item No | Ref Des | Part Number | Description | Manuf | Qty | Unit Cost | Total Cost | Notes |
|---|---|---|---|---|---|---|---|---|
| 400 | U201-U203 | **INA240A1PW** | Current Sense Amp 20 V/V Gain | TI | 3 | $3.85 | $11.55 | Phase Current Amplification. |
| 410 | U204 | **INA240A2PW** | Current Sense Amp 50 V/V Gain | TI | 1 | $3.85 | $3.85 | DC Bus Current Amplification. |
| 420 | R200-R206 | **ERA-6AEB1001V** | Resistor Array 1kΩ 0.1% | Panasonic | 7 | $0.20 | $1.40 | Differential Amp Input. |
| 430 | R210-R215 | **ERA-6AEB4993V** | Resistor Array 499kΩ 0.1% | Panasonic | 6 | $0.20 | $1.20 | Voltage Divider for Bus Sensing. |
| 440 | C200-C205 | **C0402C103K3R** | Ceramic Cap 0.01µF 25V X7R | Kemet | 6 | $0.15 | $0.90 | Input RC Filters. |
| 450 | R220 | **ERA-2AED103X** | Resistor 10kΩ 0.1% | Panasonic | 1 | $0.10 | $0.10 | Reference Buffer. |
| **Subtotal** | | | | | | | **$20.00** | |

## 6.5 Communication & Interface

| Item No | Ref Des | Part Number | Description | Manuf | Qty | Unit Cost | Total Cost | Notes |
|---|---|---|---|---|---|---|---|---|
| 500 | U300 | **MAX3485ESA+** | RS-485 Transceiver 3.3V | Maxim | 1 | $2.45 | $2.45 | UART to RS-485. |
| 510 | J1 | **5-103531-2** | Terminal Block 2-pos Plug | TE Conn | 1 | $1.10 | $1.10 | Power Input Connector. |
| 520 | J2 | **5-103532-5** | Terminal Block 5-pos Plug | TE Conn | 1 | $1.50 | $1.50 | Motor Output Connector (U/V/W/PE). |
| 530 | J3 | **MCP-AB-07-S-T** | Header 7-pin 2.54mm | Sullins | 1 | $0.80 | $0.80 | Encoder/UART Interface. |
| 540 | R301, R302 | **470-0133-001** | Resistor 120Ω 0.25W | Bourns | 1 | $0.15 | $0.15 | RS-485 Termination (Solder bridge selectable). |
| **Subtotal** | | | | | | | **$6.00** | |

## 6.6 Mechanical & Protection

| Item No | Ref Des | Part Number | Description | Manuf | Qty | Unit Cost | Total Cost | Notes |
|---|---|---|---|---|---|---|---|---|
| 600 | K1-K3 | **G5LE-14 DC12** | Power Relay 12V Coil SPDT | Omron | 3 | $3.20 | $9.60 | Pre-charge / Contactor Logic (Optional user fit). |
| 610 | F1 | **0451005.MR** | Fuse Holder 5x20mm | Littelfuse | 1 | $0.60 | $0.60 | Fuse Holder. |
| 620 | FUSE1 | **0451008.NRLD** | Fuse 10A Fast Acting 5x20 | Littelfuse | 1 | $0.75 | $0.75 | Input Protection. |
| 630 | TH1 | **9703-101-1000-S-26** | Thermistor NTC 10K | BetaTHERM | 2 | $1.25 | $2.50 | Heatsink Temp Monitoring. |
| 640 | PCB1 | **rf44-MAIN-PCB** | PCB Assembly 4-Layer 2oz Cu | - | 1 | $45.00 | $45.00 | Fabrication only. |
| **Subtotal** | | | | | | | **$58.45** | |

## 6.7 Test Points & Indicators

| Item No | Ref Des | Part Number | Description | Manuf | Qty | Unit Cost | Total Cost | Notes |
|---|---|---|---|---|---|---|---|---|
| 700 | TP1-TP20 | **5001** | Test Pin Yellow 2.54mm | Keystone | 20 | $0.12 | $2.40 | Critical Signal Nodes. |
| 710 | LED1, LED2 | **LTST-C170TBKT** | LED Green 0805 | Lite-On | 2 | $0.25 | $0.50 | Status Indicators. |
| 720 | LED3 | **LTST-C170EKT** | LED Red 0805 | Lite-On | 1 | $0.25 | $0.25 | Fault Indicator. |
| **Subtotal** | | | | | | | **$3.15** | |

## 6.8 Grand Total Summary

| Category | Total Cost (USD) |
|---|---|
| Power Stage | $93.20 |
| Gate Drive | $13.50 |
| Control MCU | $15.95 |
| Analog Sensing | $20.00 |
| Communication | $6.00 |
| Mechanical/PCB | $58.45 |
| Test Points | $3.15 |
| **Total Estimated BOM Cost** | **$210.25** |
| **NRE/Tooling (Est.)** | **$82.50** |
| **Total Project Cost** | **$292.75** |

**Notes on Pricing:**
1.  **Semiconductors:** Prices are based on spot market rates for 100-piece quantities. High-volume production (>1k units) typically reduces these costs by 15-30%.
2.  **Magnetic Components:** Input Choke pricing assumes custom windings or standard off-the-shelf parts.
3.  **PCB:** Cost represents a standard 4-layer, 2oz copper, FR4 material with ENIG finish.
4.  **Assembly:** This BOM excludes labor costs for SMT assembly and Through-Hole soldering. It is assumed assembly is done in-house or contracted separately.
5.  **Excluded:** The main Heatsink (extrusion or cold plate) is not listed as it is highly mechanical-dependent, but a target budget of $25.00-$40.00 should be allocated for the thermal solution.

---

# 7. Traceability Matrix

**Document Status: AI-GENERATED**

## 7.1 Requirement Traceability Matrix (RTM)

This table maps the system requirements defined in Section 3 to their verification methods, sources, and implementation status. It ensures that every requirement allocated to the hardware is verified and traceable to the project design parameters.

| REQ-ID | Requirement Summary | Source | Verification Method | Phase | Status |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **REQ-HW-001** | **3-Phase Inverter Output Stage** | Design Parameters (Output Power) | **Test** (Hi-pot, Load Test) | Phase 1 | Allocated |
| **REQ-HW-002** | **Field-Oriented Control (FOC)** | Functional Requirements (FOC) | **Demonstration** (SW Exec) | Phase 1 | Allocated |
| **REQ-HW-003** | **Position Sensor Interface** | Functional Requirements (Sensor) | **Test** (Signal Integrity) | Phase 1 | Allocated |
| **REQ-HW-004** | **3-Phase Current Sensing** | Functional Requirements (Sensing) | **Test** (Calibration) | Phase 1 | Allocated |
| **REQ-HW-005** | **Bootstrap Gate Drive** | Functional Requirements (Drive) | **Inspection** (Schematic) | Phase 1 | Allocated |
| **REQ-HW-006** | **UART/RS-485 Communication** | Functional Requirements (Comm) | **Test** (Protocol Analy.) | Phase 1 | Allocated |
| **REQ-HW-007** | **DC Bus Voltage Sensing** | Functional Requirements (Sensing) | **Test** (Accuracy Check) | Phase 1 | Allocated |
| **REQ-HW-008** | **Overcurrent Protection** | Functional Requirements (Protection) | **Test** (Fault Injection) | Phase 1 | Allocated |
| **REQ-HW-009** | **DC Bus Link Capacitor** | Functional Requirements (Bulk Cap) | **Analysis** (Ripple Sim) | Phase 1 | Allocated |
| **REQ-HW-010** | **Heat Dissipation** | Functional Requirements (Thermal) | **Analysis** (Therm Sim) | Phase 1 | Allocated |
| **REQ-HW-011** | **Switching Frequency** | Performance Requirements (PWM) | **Test** (Scope Measure) | Phase 1 | Allocated |
| **REQ-HW-012** | **Current Control Loop BW** | Performance Requirements (FOC) | **Test** (Bode Plot) | Phase 1 | Allocated |
| **REQ-HW-013** | **Efficiency Target** | Performance Requirements (Losses) | **Test** (Power Meter) | Phase 1 | Allocated |
| **REQ-HW-014** | **Industrial Temperature Range** | Environmental Requirements | **Inspection** (Datasheet) | Phase 1 | Allocated |
| **REQ-HW-015** | **EMI/EMC Compliance** | Environmental Requirements (EMI) | **Test** (Lab Scan) | Phase 1 | Allocated |
| **REQ-HW-016** | **48V DC Bus Constraint** | Constraint Requirements (Input) | **Inspection** (Schematic) | Phase 1 | Allocated |
| **REQ-HW-017** | **Power Budget** | Constraint Requirements (Losses) | **Analysis** (Calculations) | Phase 1 | Allocated |
| **REQ-HW-018** | **PCB Constraints** | Constraint Requirements (Layout) | **Inspection** (Gerber Review) | Phase 1 | Allocated |
| **REQ-HW-019** | **MCU Processing Capability** | Derived (REQ-HW-002) | **Analysis** (MIPs Load) | Phase 1 | Allocated |
| **REQ-HW-020** | **MOSFET Safe Operating Area** | Derived (REQ-HW-001) | **Analysis** (SOA Chart) | Phase 1 | Allocated |
| **REQ-HW-021** | **Gate Drive Voltage** | Derived (REQ-HW-005) | **Test** (Vgs Measure) | Phase 1 | Allocated |
| **REQ-HW-022** | **Current Sense Accuracy** | Derived (REQ-HW-004) | **Test** (Error %) | Phase 1 | Allocated |
| **REQ-HW-023** | **Shunt Resistor Power Rating** | Derived (REQ-HW-004) | **Analysis** (I²R Calc) | Phase 1 | Allocated |
| **REQ-HW-024** | **Bootstrap Capacitance Value** | Derived (REQ-HW-005) | **Analysis** (Charge Balance) | Phase 1 | Allocated |
| **REQ-HW-025** | **Deadtime Insertion** | Derived (REQ-HW-001) | **Inspection** (Timer Config) | Phase 1 | Allocated |
| **REQ-HW-026** | **Isolation/Protection Ratings** | Derived (Safety) | **Inspection** (Creepage) | Phase 1 | Allocated |
| **REQ-HW-027** | **Analog Supply Noise** | Derived (REQ-HW-004) | **Test** (Oscilloscope) | Phase 1 | Allocated |
| **REQ-HW-028** | **Logic Level Compatibility** | Derived (Interface) | **Inspection** (Schematic) | Phase 1 | Allocated |
| **REQ-HW-029** | **PCB Copper Weight** | Derived (REQ-HW-018) | **Inspection** (Fab Draw) | Phase 1 | Allocated |
| **REQ-HW-030** | **Heatsink Thermal Resistance** | Derived (REQ-HW-010) | **Analysis** (Rth Calc) | Phase 1 | Allocated |
| **REQ-HW-031** | **Voltage Divider Tolerance** | Derived (REQ-HW-007) | **Analysis** (Error Budget) | Phase 1 | Allocated |
| **REQ-HW-032** | **Decoupling Capacitors** | Derived (Design Rules) | **Inspection** (Placement) | Phase 1 | Allocated |

---

## 7.2 Derived Requirements Detail

The following requirements were derived from architectural decisions and component selection to satisfy the primary project requirements.

**REQ-HW-019: MCU Processing Capability**
*Description:* The MCU (STM32F405RGT6) must provide sufficient floating-point performance (FPU) and interrupt handling capability to execute the FOC algorithm at a minimum loop rate of 20 kHz.
*Rationale:* Ensures the control loop (REQ-HW-002) remains stable under dynamic load changes.

**REQ-HW-020: MOSFET Safe Operating Area**
*Description:* The selected MOSFETs (IRFS7530TRL7PP) must operate within the Safe Operating Area (SOA) for inductive switching at 48V DC and peak currents (208A), ensuring junction temperature does not exceed 125°C.
*Rationale:* Prevents device failure during high-current switching events (REQ-HW-001).

**REQ-HW-021: Gate Drive Voltage**
*Description:* The gate driver must supply a gate-source voltage (Vgs) of 10V to 15V to fully enhance the MOSFET channels (Vgs_th typically 2-4V) while staying below the max Vgs rating of 20V.
*Rationale:* Balances low Rds(on) conduction losses against gate oxide reliability (REQ-HW-005).

**REQ-HW-022: Current Sense Accuracy**
*Description:* The combined error of the shunt resistor, amplifier (INA240), and ADC must be less than 2% of full-scale scale (±208A) to ensure smooth torque control.
*Rationale:* High error in current measurement translates directly to torque ripple in FOC (REQ-HW-004).

**REQ-HW-023: Shunt Resistor Power Rating**
*Description:* The shunt resistors must handle the RMS current (approx. 147A) with a safety factor of 2. For a 0.25mΩ shunt, power dissipation is approx. 5.4W. Requires 5W+ rated component.
*Rationale:* Ensures the sense element does not fail under continuous operation (REQ-HW-004).

**REQ-HW-024: Bootstrap Capacitance Value**
*Description:* The bootstrap capacitors must be sized (min 10µF, 35V) to maintain sufficient charge for the high-side gate drive during the maximum on-time of the low-side switching at minimum duty cycles.
*Rationale:* Prevents accidental turn-off of high-side MOSFETs due to gate charge depletion (REQ-HW-005).

**REQ-HW-025: Deadtime Insertion**
*Description:* The PWM timers must inject a configurable deadtime (typically 500ns - 1µs) to prevent shoot-through currents in the bridge legs.
*Rationale:* Critical for reliability of the bridge inverter (REQ-HW-001).

**REQ-HW-026: Isolation/Protection Ratings**
*Description:* The PCB layout must maintain creepage and clearance distances appropriate for 60V DC (Functional Isolation) per IPC-2221 standards.
*Rationale:* Safety requirement for high-power board (REQ-HW-016).

**REQ-HW-027: Analog Supply Noise**
*Description:* The 3.3V analog supply for the ADC and current sense amplifiers must have ripple < 10mV peak-to-peak to prevent signal corruption.
*Rationale:* Ensures accuracy of feedback sensors (REQ-HW-004).

**REQ-HW-028: Logic Level Compatibility**
*Description:* All digital interfaces between the MCU (3.3V logic) and external peripherals (RS-485, Potentiometers) must be level-shifted if 5V tolerance is not native.
*Rationale:* Guarantees communication reliability (REQ-HW-006).

**REQ-HW-029: PCB Copper Weight**
*Description:* All high-current paths (Phase outputs, DC inputs) must utilize inner and outer layers with minimum 2oz (70µm) copper to reduce resistive losses and thermal stress.
*Rationale:* Supports thermal management for 10kW output (REQ-HW-018).

**REQ-HW-030: Heatsink Thermal Resistance**
*Description:* The heatsink assembly must provide a thermal junction-to-ambient resistance (Rth_sa) low enough such that with 400W dissipation, the MOSFET junctions stay ≤125°C in 40°C ambient. Assuming Rth_jc ~0.4°C/W and Rth_cs ~0.1°C/W, Max Rth_sa < 0.25°C/W.
*Rationale:* Validates thermal design (REQ-HW-010).

**REQ-HW-031: Voltage Divider Tolerance**
*Description:* The resistive divider for DC Bus sensing must use 1% tolerance components to ensure accurate Overvoltage/Undervoltage detection.
*Rationale:* Ensures protection logic triggers correctly (REQ-HW-007).

**REQ-HW-032: Decoupling Capacitors**
*Description:* Every IC must have high-frequency decoupling (0.1µF ceramic) placed within 5mm of the supply pins to manage switching transients.
*Rationale:* General EMC and signal integrity design rule (REQ-HW-015).

---

## 7.3 Verification Method Summary

| Verification Method | Count | Percentage |
| :--- | :--- | :--- |
| **Test** | 12 | 37.5% |
| **Analysis** | 10 | 31.25% |
| **Inspection** | 9 | 28.125% |
| **Demonstration** | 1 | 3.125% |
| **TOTAL** | **32** | **100%** |