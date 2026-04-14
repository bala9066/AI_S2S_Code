# Glue Logic Requirements (GLR)

## Document Control
| Document Title | Glue Logic Requirements |
| :--- | :--- |
| Version Date | 14.04.2026 |
| Version Number | 0V01 |
| Prepared By | Name: . Sign: |
| Document Review By | Name: . Sign: |

---

## Amendments to the Document
| S. No. | Ver. No. | Ver. Date | Changed By | Section(s) Changed | Description of Change |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | 0V01 | 14.04.2026 | - | - | Initial Version |

---

## 1. Scope of the Document
This document explains the IO details and functional requirements of the FPGA for **TX Module**. Targeted audience: Hardware Design and Firmware teams.

---

## 2. References

### 2.1 External
| Doc. Type | Part No. | Description |
| :--- | :--- | :--- |
| Datasheet | GMMT2021-215 | GaN MMIC Power Amplifier, 5-18 GHz |
| Datasheet | GVA-123+ | GaAs Driver Amplifier |
| Datasheet | HMC698LP4 | GaAs MMIC 6-bit Digital Attenuator |
| Datasheet | LTC7004 | High Speed High Side MOSFET Driver |
| Datasheet | LT3080 | 200mA Low Noise Linear Regulator |
| Datasheet | LT8631 | Synchronous Step-Down Regulator |
| Datasheet | LTC2442 | 24-Bit High Speed ADC |
| Datasheet | AD8318ACPZ | RF Logarithmic Detector/Controller |
| Datasheet | IRF9540NPBF | P-Channel MOSFET |
| Datasheet | IRF540NPBF | N-Channel MOSFET |

### 2.2 Internal
| Reference | Document |
| :--- | :--- |
| [HRS] | Hardware Requirements Specification |
| [SCH] | Schematic |
| [GRS] | General Requirements Specification |
| [GDD] | General Design Document |

---

## 3. Acronyms and Abbreviations
| Acronym | Expansion |
| :--- | :--- |
| **FPGA** | Field Programmable Gate Array |
| **HRS** | Hardware Requirements Specification |
| **GLR** | Glue Logic Requirements |
| **RF** | Radio Frequency |
| **PA** | Power Amplifier |
| **VGA** | Variable Gain Amplifier |
| **LDO** | Low Dropout Regulator |
| **EMC** | Electromagnetic Compatibility |
| **EMI** | Electromagnetic Interference |
| **ADC** | Analog to Digital Converter |
| **DAC** | Digital to Analog Converter |
| **SPI** | Serial Peripheral Interface |
| **I2C** | Inter-Integrated Circuit |
| **GPIO** | General Purpose Input/Output |
| **UART** | Universal Asynchronous Receiver-Transmitter |
| **PCB** | Printed Circuit Board |
| **BOM** | Bill of Materials |
| **RoHS** | Restriction of Hazardous Substances |
| **ESD** | Electrostatic Discharge |
| **VSWR** | Voltage Standing Wave Ratio |
| **SMP** | Sub-Miniature Push-on |
| **GaN** | Gallium Nitride |
| **GDS** | Gate Drive Signal |
| **DET** | Detector |
| **CLK** | Clock |

---

## 4. Module Overview
The TX Module is a wideband (5–18 GHz) high-power (40 dBm) transmit chain designed for military applications. The module consists of three primary subsystems: RF Amplification, Power Management, and Digital Control (FPGA).

**RF SECTION:**
The RF chain amplifies a 0 dBm input signal to 40 dBm output power. It comprises a **GVA-123+** Driver Amplifier, an **HMC698LP4** 6-bit Digital Attenuator for gain control, and a **GMMT2021-215** GaN Final Power Amplifier. The output passes through a **TCM1-63+** balun and **JD102B-LC-G** filter/transformer network to the **SMP** output connector. An **AD8318ACPZ** RF Detector provides output power monitoring.

**DIGITAL SECTION:**
The digital section utilizes an **FPGA** (part number specified in Netlist P4 context, assumed to be a standard Xilinx/Altera generic for glue logic, referenced here as *U_FPGA*) to manage the RF chain. The FPGA provides the 6-bit parallel control word to the HMC698LP4 attenuator, generates the Gate Drive Control signals for the power sequencing MOSFETs (Q1, Q2) via the LTC7004, and interfaces with the LTC2442 ADC for monitoring power supply telemetry and RF detector levels.

**POWER SUPPLY SECTION:**
The module accepts a +28V DC input via a Molex connector. An **LTC7004** drives the high-side P-Channel MOSFET (**IRF9540NPBF**) to switch the 28V rail to the PA Drain. An **LT8631** bucks this +28V down to +5V for logic and driver stages. An **LT3080** provides a clean, low-noise analog rail for the Gate Bias references (VGA_VREF, PA_VG).

---

## 5. Features
- **FPGA:** Generic Glue Logic Device (Xilinx/Altera equivalent, QFP Package).
- **Clock Oscillator:** On-board 40 MHz CMOS oscillator for FPGA system timing.
- **RF Control:** 6-bit Parallel Interface to HMC698LP4 Digital Attenuator.
- **Power Sequencing:** Hardware/FPGA controlled Gate Drive sequencing for PA protection.
- **Telemetry:** 24-bit ADC (LTC2442) interface for Current Sense and RF Detector monitoring.
- **RS485/UART Interface:** Serial communication for remote control and monitoring (Header pins).
- **Temperature Monitoring:** On-board temperature sensor (via ADC channel) attached to PA heat sink.
- **Protection:** Over-current and Over-temperature protection logic implemented in FPGA.

---

## 6. FPGA Description
The FPGA is selected to handle the high-speed parallel control of the RF attenuator and the precise timing required for power sequencing (palettes).
*Selection Rationale:* The FPGA provides the necessary IO density to interface the LTC7004 Gate Driver, the 6-bit attenuator bus, and the SPI/ADC interface simultaneously while maintaining deterministic timing for the TX Enable signal.

| S.NO | PARAMETERS | SPECIFICATION |
|------|-----------|---------------|
| 1 | Part Number | XC6SLX9-TQG144 (Generic Reference) |
| 2 | Logic Cells | 9,152 |
| 3 | CLB Flip-Flops | 5,760 |
| 4 | Number of Gates | < 100,000 |
| 5 | Maximum Distributed RAM (Kb) | 32 |
| 6 | Total Block RAM (Kb) | 320 |
| 7 | Maximum Single-Ended I/Os | 102 |
| 8 | Maximum DSP Slices | 16 |
| 9 | No of IO Bank | 4 |

---

## 7. Block Diagram
The system is centered around the FPGA.
*   **Input:** Serial Commands (UART), 28V Supply Status.
*   **Control Logic:** FPGA interprets commands, asserts TX_ENABLE, controls 6-bit attenuation data, and sequences the MOSFET Gate Drivers.
*   **Feedback:** FPGA reads the LTC2442 ADC to monitor PA Drain Current (via R14 sense resistor) and RF Output Power (via AD8318).
*   **Output:** RF Control Lines to HMC698LP4, Gate Signals to Q1/Q2 drivers, Status LED.

---

## 8. Pinout Details

**Table: FPGA Pin Out Details**

| S.No | Signal Name | Pin No | Voltage Level | Direction wrt FPGA | Source | Destination | Default Condition | Voltage Standard |
|------|-------------|--------|---------------|--------------------|--------|-------------|-------------------|------------------|
| 1 | VCC_FPGA_3V3 | - | +3.3V | Power | LT8631 | FPGA Core | ON | - |
| 2 | GND | - | 0V | GND | Common | FPGA | ON | - |
| 3 | FPGA_CLK_40M | 10 | +3.3V | Input | OSC_40MHZ | FPGA | Oscillating | LVCMOS33 |
| 4 | FPGA_RESET_N | 12 | +3.3V | Input | EXT_HEADER | FPGA | HIGH (Active Low) | LVCMOS33 |
| 5 | TX_ENABLE | 15 | +3.3V | Input | EXT_HEADER | FPGA | LOW | LVCMOS33 |
| 6 | GPIO_MODE_0 | 16 | +3.3V | Input | EXT_HEADER | FPGA | HIGH | LVCMOS33 |
| 7 | GPIO_MODE_1 | 17 | +3.3V | Input | EXT_HEADER | FPGA | HIGH | LVCMOS33 |
| 8 | UART_TX | 20 | +3.3V | Output | FPGA | EXT_HEADER | HIGH | LVCMOS33 |
| 9 | UART_RX | 21 | +3.3V | Input | EXT_HEADER | FPGA | HIGH | LVCMOS33 |
| 10 | LED_STATUS | 25 | +3.3V | Output | FPGA | LED | LOW | LVCMOS33 |
| 11 | VGA_LE | 30 | +3.3V | Output | FPGA | HMC698LP4 | LOW | LVCMOS33 |
| 12 | VGA_CLK | 31 | +3.3V | Output | FPGA | HMC698LP4 | LOW | LVCMOS33 |
| 13 | VGA_DATA_0 | 32 | +3.3V | Output | FPGA | HMC698LP4 | LOW | LVCMOS33 |
| 14 | VGA_DATA_1 | 33 | +3.3V | Output | FPGA | HMC698LP4 | LOW | LVCMOS33 |
| 15 | VGA_DATA_2 | 34 | +3.3V | Output | FPGA | HMC698LP4 | LOW | LVCMOS33 |
| 16 | VGA_DATA_3 | 35 | +3.3V | Output | FPGA | HMC698LP4 | LOW | LVCMOS33 |
| 17 | VGA_DATA_4 | 38 | +3.3V | Output | FPGA | HMC698LP4 | LOW | LVCMOS33 |
| 18 | VGA_DATA_5 | 39 | +3.3V | Output | FPGA | HMC698LP4 | LOW | LVCMOS33 |
| 19 | PA_GATE_CTRL | 40 | +5.0V | Output | FPGA | LTC7004 (Q1) | LOW | LVCMOS33 (w/ Ext Buf) |
| 20 | DRV_GATE_CTRL | 41 | +5.0V | Output | FPGA | LTC7004 (Q2) | LOW | LVCMOS33 (w/ Ext Buf) |
| 21 | ADC_CS_N | 45 | +3.3V | Output | FPGA | LTC2442 | HIGH | LVCMOS33 |
| 22 | ADC_SCK | 46 | +3.3V | Output | FPGA | LTC2442 | LOW | LVCMOS33 |
| 23 | ADC_SDI | 47 | +3.3V | Output | FPGA | LTC2442 | LOW | LVCMOS33 |
| 24 | ADC_SDO | 48 | +3.3V | Input | LTC2442 | FPGA | HIGH | LVCMOS33 |
| 25 | MON_RF_DET | 50 | +3.3V | Input | AD8318 (via R15) | FPGA (ADC Ch) | V_CC/2 | LVCMOS33 |
| 26 | MON_PA_CURR | 51 | +3.3V | Input | R14 (Sense) | FPGA (ADC Ch) | 0V | LVCMOS33 |
| 27 | MON_TEMP | 52 | +3.3V | Input | Temp Sensor | FPGA (ADC Ch) | V_CC/2 | LVCMOS33 |
| 28 | FPGA_DONE | 55 | +3.3V | Output | FPGA Int | LED | LOW | LVCMOS33 |
| 29 | FPGA_INIT_N | 56 | +3.3V | Input | FPGA Int | Pullup | HIGH | LVCMOS33 |
| 30 | TRP_OUT | 60 | +3.3V | Output | FPGA | Test Point | LOW | LVCMOS33 |
| 31 | BIAS_EN | 61 | +3.3V | Output | FPGA | LT3080 Enable | HIGH | LVCMOS33 |
| 32 | VGA_VREF_DAC | 62 | +3.3V | Output | FPGA | LT3080 Set | 1.2V | LVCMOS33 |
| 33 | JTAG_TCK | 100 | +3.3V | Input | JTAG Header | FPGA | LOW | LVCMOS33 |
| 34 | JTAG_TDI | 101 | +3.3V | Input | JTAG Header | FPGA | HIGH | LVCMOS33 |
| 35 | JTAG_TDO | 102 | +3.3V | Output | FPGA | JTAG Header | HIGH | LVCMOS33 |
| 36 | JTAG_TMS | 103 | +3.3V | Input | JTAG Header | FPGA | HIGH | LVCMOS33 |

---

## 9. Functional Specifications

**Summary table:**

| S.No. | Function Name | Description |
|-------|--------------|-------------|
| 1 | Serial Communication Interface | UART between PC & FPGA for control/telemetry |
| 2 | RF Gain Control (Attenuation) | 6-bit parallel control to HMC698LP4 VGA |
| 3 | Power Supply Sequencing | Gate drive control for Q1 (PA Drain) and Q2 (Driver Drain) |
| 4 | Supply Voltage & Current Monitoring | 24-bit ADC (LTC2442) monitoring PA Current and RF Power |
| 5 | Temperature Monitoring | ADC based monitoring of heatsink thermistor |
| 6 | TRP Configuration | TX Pulse generation logic |
| 7 | FPGA Remote Programming | Configuration loading via JTAG/SPI |
| 8 | Gate Voltage Writing | DAC/LDO control for PA Gate Bias |

### 9.1 Serial Communication Interface
- **Interface type:** UART
- **Physical layer:** TTL (3.3V) levels via Header J4.
- **Baud rate:** 115200 bps
- **Frame format:** 1 start bit, 8 data bits, 1 stop bit, no parity.
- **USB-UART converter:** External (on carrier board).
- **Signals:** `UART_TX` (FPGA → PC), `UART_RX` (PC → FPGA).
- **Protocol:** Custom packet structure. Commands: SET_ATT (6-bit value), SET_TX_EN (High/Low), GET_TEMP, GET_PWR.

### 9.2 High Speed Communication Interface
*Not applicable for this specific discrete design.* Future revisions may use GTP for high-speed telemetry.

### 9.3 Power On/Off Sequence

#### 9.3.1 Power ON/OFF Sequence
The FPGA manages the `LTC7004` gate drivers to ensure the PA (`U1`) and Driver (`U2`) receive drain voltage (`Vd`) only after the negative gate voltage (`Vg`) is stable and stable.

**Power ON Sequence:**
1.  Input supply (+28V) detected stable.
2.  FPGA initializes IO. `BIAS_EN` asserted high to enable `LT3080`.
3.  FPGA waits 10ms for `LT3080` to settle Gate Bias voltages (`PA_VG`, `DRIVER_VG`).
4.  FPGA asserts `DRV_GATE_CTRL` (enables Q2/LTC7004).
5.  FPGA asserts `PA_GATE_CTRL` (enables Q1/LTC7004) 5ms after driver enable.
6.  TX Ready flag set.

**Power OFF Sequence:**
1.  `TX_ENABLE` signal de-asserted or Power Down command received.
2.  FPGA de-asserts `PA_GATE_CTRL` (Removes 28V from PA Drain).
3.  Wait 5ms.
4.  FPGA de-asserts `DRV_GATE_CTRL`.

#### 9.3.2 Mode Configuration
| Mode | Signal | Value | Description |
|------|--------|-------|-------------|
| Normal | MODE[1:0] | 2'b00 | Normal operating mode |
| Bypass | MODE[1:0] | 2'b01 | Attenuator bypassed (Test mode) |
| Calibrate | MODE[1:0] | 2'b10 | Self-Calibration routine |

### 9.4 Supply Voltage, Current & Temperature Monitoring

#### 9.4.1 Supply Voltage and Current Monitoring
- **IC Part Number:** LTC2442
- **Interface:** SPI (using `ADC_CS_N`, `ADC_SCK`, `ADC_SDI`, `ADC_SDO`)
- **Monitored Rails:**
    - Channel 0: PA Drain Current (via sense resistor `R14`).
    - Channel 1: RF Detector Voltage (via `R15`).
    - Channel 2: +28V Input divider.
- **Measurement Range:** 0 to 40A (Current), -60 to 0dBm (RF Power).
- **Resolution:** 24-bit (High Speed mode).

#### 9.4.2 Temperature Monitoring
- **Sensor:** NTC Thermistor on PA Heat sink.
- **Interface:** Single-ended ADC input (`MON_TEMP` to FPGA/ADC).
- **Temperature Range:** -40°C to +125°C.
- **Alert Threshold:** FPGA internal comparator triggers shutdown at >100°C.

### 9.5 Flash & Interfaces

#### 9.5.1 Configuration Flash
- **Part Number:** Not populated on BOM (assumed external or QSPI on FPGA if available). *Default behavior: FPGA loads from internal flash or JTAG.*
- **Interface:** SPI or JTAG.
- **Capacity:** 16 Mb (minimum).
- **Purpose:** Stores FPGA firmware.

#### 9.5.2 Storage Flash (User Flash)
*Not utilized in this specific analog module design.* Calibration data will be stored in FPGA internal registers or small EEPROM if added.

### 9.6 TRP Configuration
- **Signal:** `TRP_OUT` (TTL).
- **Direction:** FPGA → Test Point / External Modulator.
- **Logic level:** 3.3V LVTTL.
- **Active state:** HIGH = TX Pulse ON.
- **Timing:** Minimum 1.0 µs pulse width.
- **Control:** Mapped directly to `TX_ENABLE` input status.

### 9.7 FPGA Remote Programming
- **Protocol:** JTAG (IEEE 1149.1).
- **Tool:** Xilinx Vivado / Quartus Programmer.
- **Procedure:** Standard boundary scan. No custom bootloader implemented in V0V01.

### 9.8 Phase Shifter Controlling (RF projects)
*Not applicable.* This module is a fixed-frequency/gain-variable amplifier chain, not a phased array element.

### 9.9 Beam Steering Calculation
*Not applicable.*

### 9.10 Gate Voltage Writing in DAC (if applicable)
- **DAC Part Number:** LT3080 (Low Noise LDO used as adjustable source).
- **Interface:** Analog control via DAC or Digital Potentiometer (FPGA GPIO `VGA_VREF_DAC`).
- **Channels:**
    - `PA_VG_ADJ`: Sets GaN PA Gate bias (approx -2.0V).
    - `VGA_VREF`: Sets HMC698LP4 reference voltage.
- **Voltage Range:** 0V to +3.3V control range resulting in -3.0V to 0V bias range.

---

## Annexure A — Requirement Traceability Matrix

| S.No. | Requirement ID | Description | HRS Section | GLR Section |
|-------|---------------|-------------|-------------|-------------|
| 1 | REQ-HW-001 | Operating Frequency Range (5-18GHz) | HRS §3.1 | 4 (RF Overview) |
| 2 | REQ-HW-002 | Output Power (40dBm) | HRS §3.1 | 4 (RF Overview), 9.4.1 |
| 3 | REQ-HW-003 | Analog Modulation Support | HRS §3.1 | 9.6 (TRP Config) |
| 4 | REQ-HW-004 | Power Efficiency | HRS §3.1 | 9.3 (Power Sequencing) |
| 5 | REQ-HW-005 | Gain Control (40dB) | HRS §3.1 | 9.2 (VGA Control) |
| 6 | REQ-HW-006 | Output Return Loss | HRS §3.1 | N/A (Passive Circuit) |
| 7 | REQ-HW-007 | RF Input Interface | HRS §3.1 | 8 (Pinout) |
| 8 | REQ-HW-008 | RF Output Interface | HRS §3.1 | 8 (Pinout) |
| 9 | REQ-HW-009 | Power Supply Interface | HRS §3.1 | 9.3 (Power Seq) |
| 10 | REQ-HW-010 | Enable/TX Control | HRS §3.1 | 9.3, 9.6 |
| 11 | REQ-HW-011 | Operating Temperature | HRS §3.1 | 9.4.2 (Temp Mon) |
| 12 | REQ-HW-019 | Thermal Management | HRS §3.1 | 9.10 (Gate Control) |
| 13 | REQ-HW-020 | Input Power Sensing | HRS §3.1 | 9.4.1 (ADC Mon) |