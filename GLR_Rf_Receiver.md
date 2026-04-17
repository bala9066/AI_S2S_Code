# Glue Logic Requirements (GLR)

## Document Control
| Document Title | Glue Logic Requirements (GLR) |
| :--- | :--- |
| Version Date | 17.04.2026 |
| Version Number | 0V01 |
| Prepared By | Name: . Sign: |
| Document Review By | Name: . Sign: |

---

## Amendments to the Document
| S. No. | Ver. No. | Ver. Date | Changed By | Section(s) Changed | Description of Change |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | 0V01 | 17.04.2026 | - | - | Initial Version |

---

## 1. Scope of the Document
This document details the input/output (I/O) interfaces, functional requirements, and logic definitions for the **Rf Receiver** project. It serves as the bridge between the hardware netlist (P4) and the FPGA firmware implementation (P7).

The receiver module is a 5-18 GHz wideband ruggedized unit. While the RF chain is primarily analog, this document specifies the digital control and monitoring logic implemented within the FPGA to manage power supply health, temperature monitoring, serial communication interfaces, and future expandability for gain control.

---

## 2. References

### 2.1 External
| Doc. Type | Part No. | Description |
| :--- | :--- | :--- |
| Datasheet | AMMC-6241 | 5-20 GHz GaAs MMIC LNA |
| Datasheet | GVA-164+ | 6-18 GHz Driver Amplifier |
| Datasheet | VLVA-300-44 | GaAs Limiter Diode |
| Datasheet | LM22676-5.0 | 5V Buck Regulator |
| Datasheet | LT1964-8 | 8V LDO Regulator |
| Datasheet | 142-0701-851 | SMA Connector |
| Datasheet | DPX-MIL-DTL-38999 | MIL-Circular Connector |

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
| **ADC** | Analog to Digital Converter |
| **COTS** | Commercial Off-The-Shelf |
| **DAC** | Digital to Analog Converter |
| **dB** | Decibel |
| **dBm** | Decibel-milliwatts |
| **EMC** | Electromagnetic Compatibility |
| **EMI** | Electromagnetic Interference |
| **ESD** | Electrostatic Discharge |
| **FF** | Flip-Flop |
| **FIFO** | First-In-First-Out |
| **FPGA** | Field Programmable Gate Array |
| **GND** | Ground |
| **GPIO** | General Purpose Input/Output |
| **HDL** | Hardware Description Language |
| **HRS** | Hardware Requirements Specification |
| **I2C** | Inter-Integrated Circuit |
| **IO** | Input/Output |
| **JTAG** | Joint Test Action Group |
| **LDO** | Low Dropout Regulator |
| **LNA** | Low Noise Amplifier |
| **LUT** | Look-Up Table |
| **LVCMOS** | Low-Voltage CMOS |
| **LVTTL** | Low-Voltage Transistor-Transistor Logic |
| **MMIC** | Monolithic Microwave Integrated Circuit |
| **NF** | Noise Figure |
| **OIP3** | Output Third-order Intercept Point |
| **PCB** | Printed Circuit Board |
| **PLL** | Phase Locked Loop |
| **POR** | Power On Reset |
| **RTL** | Register Transfer Level |
| **SMA** | SubMiniature version A |
| **SPI** | Serial Peripheral Interface |
| **UART** | Universal Asynchronous Receiver-Transmitter |
| **VCC** | Voltage Common Collector |

---

## 4. Module Overview

**RF SECTION:**
The RF chain operates from 5 to 18 GHz. The input signal passes through a limiting protection stage (**D1: VLVA-300-44**) which clamps high-power transients. The signal is then amplified by the **U1: AMMC-6241** LNA (+20 dB gain) followed by the **U2: GVA-164+** Driver Amplifier (+15 dB gain) to provide the final output to the distribution port.

**DIGITAL SECTION:**
The design utilizes an FPGA (e.g., Xilinx Artix-7 or Lattice MachXO3) to act as the system controller.
*   **Power Control:** The FPGA monitors the supply rails. It sequences the enable signals for the RF amplifiers to ensure stable operation.
*   **Telemetry:** It monitors board temperature and supply currents via an I2C ADC.
*   **Communication:** A UART interface provides a command/control link to an external host PC for status reporting and configuration updates.

**POWER SUPPLY SECTION:**
The module accepts +12V DC via a MIL-DTL-38999 connector (**J3**). This passes through an EMI filter (**F1**) and reverse polarity protection diode (**D2**). A Buck regulator (**U3: LM22676-5.0**) generates +5V for the LNA logic/control. An LDO regulator (**U4: LT1964-8**) generates +8V for the Driver Amplifier bias.

---

## 5. Features
- **FPGA:** [Assumed: Xilinx XC7A35T-CPG236I] (Industrial temp, Artix-7 family)
- **Power Supply:** 12V Input, Regulated 5V and 8V Outputs (Sequenced)
- **RF Chain:** 5-18 GHz operation with >35 dB total gain
- **Protection:** Input limiter up to +10 dBm continuous
- **Interface:** UART (115200 baud) for command/status
- **Monitoring:** I2C based voltage, current, and temperature monitoring
- **Status Indication:** LED Status indicator (Green)
- **Connectivity:** SMA Female (RF In/Out), MIL-DTL-38999 (Power)
- **Compliance:** MIL-STD-810G (Shock/Vibe), MIL-STD-461E (EMI)

---

## 6. FPGA Description
The FPGA is selected to provide robust control logic in a harsh military environment (-55°C to +125°C). The device must be Automotive or Industrial grade.

| S.NO | PARAMETERS | SPECIFICATION |
|------|-----------|---------------|
| 1 | Part Number | XC7A35T-CPG236I (Example) |
| 2 | Logic Cells | 33,280 |
| 3 | CLB Flip-Flops | 41,600 |
| 4 | Number of Gates | ~500k (ASIC equivalent) |
| 5 | Maximum Distributed RAM (Kb) | 225 |
| 6 | Total Block RAM (Kb) | 1,800 |
| 7 | Maximum Single-Ended I/Os | 210 |
| 8 | Maximum DSP Slices | 90 |
| 9 | No of IO Bank | 4 |

---

## 7. Block Diagram
The logic block diagram consists of the following main blocks:
1.  **Power Management Logic:** Handles sequencing of U3 (5V) and U4 (8V) enables.
2.  **I2C Master:** Communicates with telemetry sensors (ADC/Temp).
3.  **UART Controller:** RS422/RS485 transceiver interface to external host.
4.  **System Monitor (SYSMON):** Internal XADC for voltage/temperature monitoring.
5.  **Register Map:** Avalon/AXI4-Lite slave interface for register access.

---

## 8. Pinout Details

**Table: FPGA Pin Out Details**

| S.No | Signal Name | Pin No | Voltage Level | Direction wrt FPGA | Source | Destination | Default Condition | Voltage Standard |
|------|------------|--------|---------------|--------------------|--------|-------------|-------------------|------------------|
| 1 | VDD_FPGA_3V3 | - | 3.3V | Power In | Regulator | FPGA Bank 0 | On | - |
| 2 | VDD_FPGA_1V0 | - | 1.0V | Power In | Regulator | FPGA Core | On | - |
| 3 | GND | - | 0V | Ground | PCB | FPGA | - | - |
| 4 | FPGA_CLK_50M | E15 | 3.3V | Input | Oscillator | PLL | Clock | LVCMOS33 |
| 5 | FPGA_RESET_N | D5 | 3.3V | Input | Button/Power | Logic | High (Pullup) | LVCMOS33 |
| 6 | UART_TX | A10 | 3.3V | Output | FPGA | Transmitter | High | LVCMOS33 |
| 7 | UART_RX | B10 | 3.3V | Input | Receiver | FPGA | High | LVCMOS33 |
| 8 | FPGA_DONE | F4 | 3.3V | Output | FPGA Config | LED | Low | LVCMOS33 |
| 9 | LED_STATUS_N | G5 | 3.3V | Output | FPGA | D3 (LED) | High (Off) | LVCMOS33 |
| 10 | I2C_SCL | C12 | 3.3V | Bidirectional | FPGA | Sensor IO | High (Pullup) | LVCMOS33 |
| 11 | I2C_SDA | C13 | 3.3V | Bidirectional | FPGA | Sensor IO | High (Pullup) | LVCMOS33 |
| 12 | JTAG_TCK | H3 | 3.3V | Input | Debugger | FPGA JTAG | - | LVCMOS33 |
| 13 | JTAG_TDI | K3 | 3.3V | Input | Debugger | FPGA JTAG | - | LVCMOS33 |
| 14 | JTAG_TDO | L3 | 3.3V | Output | FPGA JTAG | Debugger | - | LVCMOS33 |
| 15 | JTAG_TMS | M3 | 3.3V | Input | Debugger | FPGA JTAG | - | LVCMOS33 |
| 16 | SPI_CS_FLASH_N | J15 | 3.3V | Output | FPGA | Flash | High | LVCMOS33 |
| 17 | SPI_MISO | K15 | 3.3V | Input | Flash | FPGA | High Z | LVCMOS33 |
| 18 | SPI_MOSI | L15 | 3.3V | Output | FPGA | Flash | Low | LVCMOS33 |
| 19 | SPI_CLK | M15 | 3.3V | Output | FPGA | Flash | Low | LVCMOS33 |
| 20 | RF_AMP_ENABLE_1 | N1 | 3.3V | Output | FPGA | U1 Enable | Low (Off) | LVCMOS33 |
| 21 | RF_AMP_ENABLE_2 | N2 | 3.3V | Output | FPGA | U2 Enable | Low (Off) | LVCMOS33 |
| 22 | LDO_ENABLE_8V | P1 | 3.3V | Output | FPGA | U4 Enable | Low | LVCMOS33 |
| 23 | MON_5V_PG | R1 | 3.3V | Input | U3 (PG) | FPGA | High | LVCMOS33 |
| 24 | MON_TEMP_ALERT | R2 | 3.3V | Input | Sensor | FPGA | Low | LVCMOS33 |
| 25 | GPIO_01 | T1 | 3.3V | Bidirectional | N/C | Testpoint | High Z | LVCMOS33 |
| 26 | GPIO_02 | T2 | 3.3V | Bidirectional | N/C | Testpoint | High Z | LVCMOS33 |
| 27 | SPARE_01 | U1 | 3.3V | Output | N/C | N/C | Low | LVCMOS33 |
| 28 | SPARE_02 | U2 | 3.3V | Output | N/C | N/C | Low | LVCMOS33 |
| 29 | DAC_CS_N | V1 | 3.3V | Output | FPGA | DAC (Future) | High | LVCMOS33 |
| 30 | SPI_CLK_DAC | V2 | 3.3V | Output | FPGA | DAC (Future) | Low | LVCMOS33 |
| 31 | VIN_SENSE_ADC | W1 | 3.3V | Input | ADC Divider | FPGA XADC | - | LVCMOS33 |
| 32 | IOUT_SENSE_ADC | W2 | 3.3V | Input | ADC Amp | FPGA XADC | - | LVCMOS33 |
| 33 | FPGA_INIT_N | Y1 | 3.3V | Output | FPGA Config | LED | Low | LVCMOS33 |
| 34 | POR_N | Y2 | 3.3V | Input | Supervisor | FPGA Reset | High | LVCMOS33 |
| 35 | PLL_LOCKED | Y3 | 3.3V | Output | PLL MGMT | FPGA Status | High | LVCMOS33 |

---

## 9. Functional Specifications

**Summary table first:**

| S.No. | Function Name | Description |
|-------|--------------|-------------|
| 1 | Serial Communication Interface | UART between PC & FPGA for configuration/status |
| 2 | Power Supply Sequencing | Controls turn-on/off of U3 (5V Buck) and U4 (8V LDO) |
| 3 | Health Status Monitoring | Reads voltage/current/temp via internal XADC and external I2C |
| 4 | Flash Interface | SPI configuration flash for remote updates |
| 5 | RF Control | Enable signals for AMMC-6241 (LNA) and GVA-164+ (Driver) |
| 6 | TRP Configuration | Transmit/Receive Pulse (unused in RX only, but implemented for future) |
| 7 | Remote Programming | Loading of FPGA bitstream via UART |
| 8 | LED Status Indication | Visual feedback on system health |
| 9 | Watchdog Timer | Auto-recovery on firmware hang |

### 9.1 Serial Communication Interface
- **Interface type:** UART
- **Physical layer:** RS422 Differential (Full Duplex)
- **Baud rate:** 115200 bps (configurable to 921.6 kbps)
- **Frame format:** 1 start bit, 8 data bits, 1 stop bit, no parity
- **Connector:** MIL-DTL-38999 (Assigned pins)
- **Signals:** FPGA_TXD, FPGA_RXD
- **Protocol:** Custom register-based command/response (See Section 11)

### 9.2 High Speed Communication Interface
*Not applicable for this specific Rx module revision. Future revisions may implement High-Speed SERDES for digital IF output.*

### 9.3 Power On/Off Sequence
#### 9.3.1 Power ON Sequence
1.  Input +12V applied.
2.  Reverse polarity protection (D2) and EMI Filter (F1) pass voltage.
3.  **U3 (LM22676-5.0)** enables. 5V rail rises.
4.  FPGA initiates Power-On Reset (POR).
5.  FPGA waits for `MON_5V_PG` (Power Good) signal from U3.
6.  Once `MON_5V_PG` is high, FPGA asserts `LDO_ENABLE_8V`.
7.  **U4 (LT1964-8)** enables. 8V rail rises.
8.  FPGA asserts `RF_AMP_ENABLE_1` (LNA) and `RF_AMP_ENABLE_2` (Driver).
9.  System enters READY state.

#### 9.3.2 Mode Configuration
| Mode | Signal | Value | Description |
|------|--------|-------|-------------|
| Normal | MODE[1:0] | 2'b00 | Standard RX Operation |
| Bypass | MODE[1:0] | 2'b01 | Signal bypass (RF gain minimized) |
| Test | MODE[1:0] | 2'b10 | Factory Test Mode (Loopback enabled) |
| Sleep | MODE[1:0] | 2'b11 | Low power mode (Amplifiers disabled) |

### 9.4 Supply Voltage, Current & Temperature Monitoring
#### 9.4.1 Supply Voltage and Current Monitoring
- **Method:** FPGA internal XADC (12-bit SAR ADC).
- **Monitored Rails:** +12V Input (via divider), +5V, +8V.
- **Current Monitoring:** High-side sense amplifier output into XADC.
- **Resolution:** 1.22 mV/LSB (scaled).

#### 9.4.2 Temperature Monitoring
- **Source:** Internal FPGA temperature sensor + External I2C sensor (if populated).
- **Range:** -55°C to +125°C.
- **Alert:** `MON_TEMP_ALERT` latched if temp > +110°C.

### 9.5 Flash & Interfaces
#### 9.5.1 Configuration Flash
- **Part Number:** [See BOM — e.g., S25FL128S]
- **Interface:** SPI (x1 or x4).
- **Capacity:** 128 Mb (16 MB).
- **Purpose:** Stores FPGA bitstream and non-volatile register settings.

### 9.6 TRP Configuration
- **Signal:** TRP (Transmit/Receive Pulse) — *Reserved for future use or legacy compatibility.*
- **Logic:** High = Transmit mode (Rx path muted), Low = Receive mode.

### 9.7 FPGA Remote Programming
- **Trigger:** Command `0xB0` via UART.
- **Process:**
    1.  FPGA erases Flash sector.
    2.  Receives bitstream packets via UART.
    3.  Writes to SPI Flash.
    4.  Triggers IPROG command to reload bitstream.

### 9.8 Phase Shifter Controlling
*Not applicable (Fixed analog phase linearity).*

### 9.9 Beam Steering Calculation
*Not applicable (Single element receiver).*

### 9.10 Gate Voltage Writing in DAC
*Reserved for future variable gain amplifier (VGA) control if gain flatness adjustment is required.*

---

## 10. Software Register Address Map

This section defines the 16-bit register address space accessible via the UART protocol.

### 10.1 Register Base Addresses

| Block Name | Base Address | Address Range | Description |
|------------|-------------|---------------|-------------|
| System / Identification | 0x0000 | 0x0000–0x00FF | Board ID, firmware version, reset control |
| UART Control | 0x0100 | 0x0100–0x01FF | Baud rate, status |
| SPI / Flash Control | 0x0200 | 0x0200–0x02FF | SPI master, flash control |
| I2C / Sensor Control | 0x0300 | 0x0300–0x03FF | I2C master, sensor data |
| GPIO Control | 0x0400 | 0x0400–0x04FF | General purpose IO |
| RF Control | 0x0800 | 0x0800–0x08FF | LNA/Driver enables, TRP |
| Diagnostics / ADC | 0x0A00 | 0x0A00–0x0AFF | XADC data, fault logs |

### 10.2 Detailed Register Map

**Block 0x0000 — System / Identification**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|--------------|-------|-----|-------------|----------------------|
| 0x00 | BOARD_ID | 16 | R | 0x5F18 | Fixed ID: 5GHz(F)-18GHz |
| 0x01 | FW_VERSION | 16 | R | 0x0100 | Major.Minor version (1.0) |
| 0x02 | SYS_STATUS | 16 | R | 0x0000 | [0] 5V_PG, [1] 8V_PG, [2] TEMP_OK, [3] RF_ENABLED |
| 0x03 | SYS_RESET | 16 | W | 0x0000 | Write 0xDEAD to trigger soft reset |
| 0x04 | MODE_SELECT | 16 | R/W | 0x0000 | [1:0] Operating mode (Normal/Bypass/Test/Sleep) |

**Block 0x0100 — UART Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|--------------|-------|-----|-------------|----------------------|
| 0x00 | BAUD_DIV | 16 | R/W | 0x0022 | Divisor for 115200 baud @ 50MHz clk |
| 0x01 | UART_STATUS | 16 | R | 0x0000 | [0] TX_BUSY, [1] RX_AVAIL |

**Block 0x0300 — I2C / Sensor Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|--------------|-------|-----|-------------|----------------------|
| 0x00 | I2C_TX_DATA | 16 | W | 0x0000 | Data to write to I2C bus |
| 0x01 | I2C_RX_DATA | 16 | R | 0x0000 | Data read from I2C bus |
| 0x02 | I2C_CTRL | 16 | R/W | 0x0000 | [0] START, [1] STOP, [2] READ_NOT_WRITE |
| 0x03 | SENSOR_TEMP | 16 | R | 0x0000 | Signed temperature (°C * 10) |

**Block 0x0800 — RF Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|--------------|-------|-----|-------------|----------------------|
| 0x00 | RF_ENABLE | 16 | R/W | 0x0000 | [0] LNA_EN, [1] DRIVER_EN, [2] TRP |
| 0x01 | RF_STATUS | 16 | R | 0x0000 | [0] LNA_FAULT, [1] DRIVER_FAULT |

**Block 0x0A00 — Diagnostics / ADC**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|--------------|-------|-----|-------------|----------------------|
| 0x00 | ADC_12V | 16 | R | 0x0000 | 12-bit ADC value of 12V rail |
| 0x01 | ADC_5V | 16 | R | 0x0000 | 12-bit ADC value of 5V rail |
| 0x02 | ADC_8V | 16 | R | 0x0000 | 12-bit ADC value of 8V rail |
| 0x03 | TEMP_FPGA | 16 | R | 0x0000 | FPGA internal temp raw data |

### 10.3 Register Access Rules
- Addresses are 16-bit words.
- Write access is ignored for Read-Only (R) registers.
- Negative temperatures in `SENSOR_TEMP` are represented as Two's Complement 16-bit integers.

---

## 11. UART Register Protocol Specification

This section specifies the byte-level protocol for host communication.

### 11.1 Physical Layer
- Baud Rate: 115200 (Default)
- Data Bits: 8
- Parity: None
- Stop Bits: 1
- Flow Control: None (SW handshake)

### 11.2 Command Frame Formats

**Single Register Write (CMD = 0x57 'W'):**
```
Byte 0: 0x57 (CMD)
Byte 1: ADDR[15:8] (address MSB)
Byte 2: ADDR[7:0]  (address LSB)
Byte 3: DATA[15:8] (data MSB)
Byte 4: DATA[7:0]  (data LSB)
→ Response: 0x06 (ACK)
```

**Single Register Read (CMD = 0x52 'R'):**
```
Byte 0: 0x52 (CMD)
Byte 1: ADDR[15:8] (address MSB)
Byte 2: ADDR[7:0]  (address LSB)
→ Response: DATA[15:8], DATA[7:0]
```

**Bulk Register Write (CMD = 0x42 'B'):**
```
Byte 0: 0x42 (CMD)
Byte 1: ADDR[15:8] (start address MSB)
Byte 2: ADDR[7:0]  (start address LSB)
Byte 3: N          (register count, 1–32)
Byte 4..4+2N-1: DATA pairs
→ Response: 0x06 (ACK)
```

**Bulk Register Read (CMD = 0x62 'b'):**
```
Byte 0: 0x62 (CMD)
Byte 1: ADDR[15:8] (start address MSB)
Byte 2: ADDR[7:0]  (start address LSB)
Byte 3: N          (register count, 1–32)
→ Response: DATA[0]_H, DATA[0]_L, ..., DATA[N-1]_H, DATA[N-1]_L
```

### 11.3 Protocol Timing Constraints
| Parameter | Max | Unit |
|-----------|-----|------|
| Inter-byte gap | 50 | ms |
| ACK Response time | 10 | ms |

---

## 12. FPGA Resource Utilization Estimate

Target Device: **Xilinx XC7A35T-CPG236I** (Artix-7)

| Resource | Available | Estimated Usage | Utilization % |
|---------|-----------|----------------|--------------|
| Slice LUTs | 20,800 | 2,500 | 12% |
| Slice Flip-Flops | 41,600 | 3,000 | 7% |
| Block RAM (36Kb) | 50 | 4 | 8% |
| DSP Slices | 90 | 0 | 0% |
| MMCM/PLL | 2 | 1 | 50% |
| I/O Buffers | 210 | 35 | 16% |

*Tool Version: Vivado 2023.2*
*Timing Constraint: 50 MHz Primary Clock*

---

## Annexure A — Requirement Traceability Matrix

| S.No. | GLR-ID | Description | Source HRS Section | GLR Section | Verification Method | Status |
|-------|--------|-------------|-------------------|-------------|--------------------|----|
| 1 | GLR-001 | RF Input Frequency | REQ-HW-001 | 8, 10 | Signal Gen Test | Open |
| 2 | GLR-002 | Noise Figure | REQ-HW-002 | 4, 6 | Noise Figure Meter | Open |
| 3 | GLR-003 | Power Supply 12V Input | REQ-HW-006 | 4, 9.3 | Power Supply Test | Open |
| 4 | GLR-004 | Reverse Polarity Protection | REQ-HW-015 | 4, 9.3 | Mis-wiring Test | Open |
| 5 | GLR-005 | Input Power Handling | REQ-HW-003 | 4 | Power Injection Test | Open |
| 6 | GLR-006 | Return Loss / VSWR | REQ-HW-009 | 4 | VNA Measurement | Open |
| 7 | GLR-007 | Operating Temp Range | REQ-HW-007 | 6, 9.4 | Chamber Test | Open |
| 8 | GLR-008 | Connector Interface | REQ-HW-004 | 8 | Inspection | Open |
| 9 | GLR-009 | UART Control Interface | GLR Spec | 9.1, 11 | Loopback Test | Open |
| 10 | GLR-010 | Register Map Access | GLR Spec | 10 | Host Software | Open |
| 11 | GLR-011 | Power Sequencing | REQ-HW-006 | 9.3 | Oscilloscope | Open |
| 12 | GLR-012 | LED Indication | REQ-HW-019 | 8, 9 | Visual Inspection | Open |
| 13 | GLR-013 | FPGA Resource Budget | Design Const | 12 | Synthesis Report | Open |
| 14 | GLR-014 | EMI/EMC Compliance | REQ-HW-014 | 4 | Scan / Chamber | Open |
| 15 | GLR-015 | Mechanical Shock/Vibe | REQ-HW-013 | 4 | Vibe Table | Open |