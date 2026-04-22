# Glue Logic Requirements (GLR)

## Document Control
| Document Title | Glue Logic Requirements |
| :--- | :--- |
| Version Date | 22.04.2026 |
| Version Number | 0V01 |
| Prepared By | Name: . Sign: |
| Document Review By | Name: . Sign: |

---

## Amendments to the Document
| S. No. | Ver. No. | Ver. Date | Changed By | Section(s) Changed | Description of Change |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | 0V01 | 22.04.2026 | - | - | Initial Version |

---

## 1. Scope of the Document
This document explains the IO details and functional requirements of the FPGA for **hfuf**. It bridges the gap between the Hardware Requirements Specification (HRS) and the FPGA HDL Design.
Targeted audience: Hardware Design, PCB Layout, and Firmware teams.

---

## 2. References

### 2.1 External
| Doc. Type | Part No. | Description |
| :--- | :--- | :--- |
| Datasheet | SKY16602-632LF | 0.2–4.0 GHz Limiter (Skyworks) |
| Datasheet | BFHK-5001+ | 4.5-5.3 GHz BPF LTCC (Mini-Circuits) |
| Datasheet | PE1604 | Bias Tee 100 MHz-6 GHz (Pasternack) |
| Datasheet | LVA-273PN+ | Gain Block 0.01-26.5 GHz (Mini-Circuits) |
| Datasheet | TPS62136RGXR | 4A Step-Down Buck Regulator (TI) |
| Datasheet | MIC5209-3.3YM | 500mA LDO 3.3V (Micrel) |
| Datasheet | **XC7A35T-1CPG238C** | FPGA Artix-7 35T (Target Device) |
| Datasheet | **FT2232H** | USB-UART/Multi-Protocol Synchronous FIFO |
| Datasheet | **AT25040N** | 4Kbit SPI EEPROM |
| Datasheet | **S25FL512S** | 512Mbit (64MB) Configuration Flash |
| Datasheet | **LM75A** | I2C Temperature Sensor |

### 2.2 Internal
| Reference | Document |
| :--- | :--- |
| [HRS] | Hardware Requirements Specification (hfuf) |
| [SCH] | Schematic (Netlist) |
| [GRS] | General Requirements Specification |
| [GDD] | General Design Document |

---

## 3. Acronyms and Abbreviations
| Acronym | Expansion |
| :--- | :--- |
| **ABC** | Active Bias Control |
| **ADC** | Analog-to-Digital Converter |
| **AFC** | Automatic Frequency Control |
| **BGA** | Ball Grid Array |
| **BOM** | Bill of Materials |
| **CLB** | Configurable Logic Block |
| **CPLD** | Complex Programmable Logic Device |
| **DAC** | Digital-to-Analog Converter |
| **DSP** | Digital Signal Processor / Slice |
| **EMC** | Electromagnetic Compatibility |
| **FIFO** | First-In-First-Out |
| **FF** | Flip-Flop |
| **FPGA** | Field Programmable Gate Array |
| **GaN** | Gallium Nitride |
| **GND** | Ground |
| **GPIO** | General Purpose Input/Output |
| **HDL** | Hardware Description Language |
| **I2C** | Inter-Integrated Circuit |
| **IO** | Input/Output |
| **IP** | Intellectual Property |
| **LDO** | Low Dropout Regulator |
| **LNA** | Low Noise Amplifier |
| **LUT** | Look-Up Table |
| **LVCMOS** | Low-Voltage CMOS |
| **LVTTL** | Low-Voltage TTL |
| **PCB** | Printed Circuit Board |
| **PLL** | Phase Locked Loop |
| **POR** | Power On Reset |
| **RF** | Radio Frequency |
| **RoHS** | Restriction of Hazardous Substances |
| **RTL** | Register Transfer Level |
| **SPI** | Serial Peripheral Interface |
| **TRP** | Transmit/Receive Pulse |
| **UART** | Universal Asynchronous Receiver/Transmitter |
| **VCC** | Voltage Common Collector |

---

## 4. Module Overview

### RF SECTION
The RF section comprises four parallel receive channels.
*   **Input Protection:** SKY16602-632LF Limiter (Survivable +30 dBm).
*   **Filtering:** BFHK-5001+ LTCC Bandpass filters.
*   **Amplification:** Three cascaded LVA-273PN+ Gain Blocks per channel.
*   **Bias:** Active Bias Control (ABC) network managing Drain and Gate voltages via DACs controlled by the FPGA.

### DIGITAL SECTION
The core logic is implemented in an **Xilinx Artix-7 XC7A35T-CPG238** FPGA.
*   **Control Logic:** Manages power sequencing (Buck/LDO enables) and RF safety (TPS62136 enable gates).
*   **Communication:** UART (USB-FT2232H) for command/control. I2C for sensor monitoring. SPI for Flash/EEPROM access.
*   **Signal Processing:** Real-time monitoring of Power Good and ABC status signals.

### POWER SUPPLY SECTION
*   **Input:** +12 V DC via CONN_DC_2PIN.
*   **Regulation:** TPS62136RGXR (Buck) generates +5 V rail. MIC5209-3.3YM (LDO) generates +3.3 V rail for FPGA and ABC logic.
*   **Sequence:** FPGA monitors the `EN_BUCK`, `EN_LDO`, and `EN_ABC` lines to ensure proper start-up.

---

## 5. Features
*   **FPGA:** Xilinx Artix-7 XC7A35T-CPG238I (Industrial Temp).
*   **Clock:** On-board 25 MHz CMOS Oscillator (multiplied internally to 100 MHz system clock).
*   **Communication:** UART to USB (FT2232H) @ 3.0 Mbps Baud.
*   **Debugging:** JTAG (14-pin header) for Xilinx Vivado.
*   **Configuration:** 512 Mbit SPI Flash (S25FL512S) for Remote Update capability.
*   **EEPROM:** 4 Kbit SPI EEPROM (AT25040N) for Board ID/Calibration storage.
*   **Sensors:** I2C Temperature (LM75A) & Voltage Monitoring (Internal FPGA XADC).
*   **Bias Control:** SPI DAC (integrated in U15 ABC) for 4-channel GaN Gate Control.
*   **Protection:** Digital monitoring of RF Limiter fault flags (if available via bias controller).

---

## 6. FPGA Description
The **XC7A35T** is selected to provide sufficient IOs (150+ user IOs) and logic resources to manage the power sequencing, RF bias control loops, and high-speed communication interfaces, while maintaining low power consumption suitable for the 22.5 W budget.

| S.NO | PARAMETERS | SPECIFICATION |
| :--- | :--- | :--- |
| 1 | Part Number | XC7A35T-1CPG238C |
| 2 | Logic Cells | 33,280 |
| 3 | CLB Flip-Flops | 41,600 |
| 4 | Number of Gates (Equivalent) | 500K |
| 5 | Maximum Distributed RAM (Kb) | 200 |
| 6 | Total Block RAM (Kb) | 1,800 |
| 7 | Maximum Single-Ended I/Os | 210 |
| 8 | Maximum DSP Slices | 90 |
| 9 | No of IO Bank | 4 (Banks 13, 14, 15, 16) |
| 10 | Package | CPG238 |
| 11 | Operating Temp | -40°C to +100°C (Junction) |

---

## 7. Block Diagram
The FPGA is the central controller. It reads configuration from the SPI Flash. It communicates with the host PC via UART. It controls the Power Supply Module (EN signals) and the Active Bias Controller (SPI/I2C). It monitors temperature and board ID.

---

## 8. Pinout Details

**Table: FPGA Pin Out Details**

| S.No | Signal Name | Pin No (Package) | Voltage Level | Direction wrt FPGA | Source | Destination | Default Condition | Voltage Standard |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | VDD_FPGA_3V3 | - | 3.3 | Power | LDO (U14) | FPGA Core IO | ON | LVCMOS33 |
| 2 | VDD_FPGA_1V0 | - | 1.0 | Power | Internal Regulator | FPGA Core | ON | - |
| 3 | GND | - | 0 | GND | GND Plane | FPGA GND | GND | - |
| 4 | FPGA_CLK_25M | J19 | 3.3 | Input | OSC_25MHZ | FPGA PLL | Clock | LVCMOS33 |
| 5 | TCK | L19 | 3.3 | Input | JTAG Header | Debug TAP | Pull Up | LVCMOS33 |
| 6 | TDI | K18 | 3.3 | Input | JTAG Header | Debug TAP | Pull Up | LVCMOS33 |
| 7 | TDO | K19 | 3.3 | Output | FPGA | Debug TAP | High Z | LVCMOS33 |
| 8 | TMS | L18 | 3.3 | Input | JTAG Header | Debug TAP | Pull Up | LVCMOS33 |
| 9 | FPGA_RESET_N | M13 | 3.3 | Input | Push Button | FPGA Reset | Active Low | LVCMOS33 |
| 10 | UART_TX | K17 | 3.3 | Output | FPGA | FT2232H (RXD) | High | LVCMOS33 |
| 11 | UART_RX | K16 | 3.3 | Input | FT2232H (TXD) | FPGA | High | LVCMOS33 |
| 12 | SPI_CLK_FLASH | H15 | 3.3 | Output | FPGA | S25FL512S (CLK) | Low | LVCMOS33 |
| 13 | SPI_CS_FLASH_N | J15 | 3.3 | Output | FPGA | S25FL512S (CS) | High | LVCMOS33 |
| 14 | SPI_MISO_FLASH | G16 | 3.3 | Input | S25FL512S (MISO) | FPGA | Pull Up | LVCMOS33 |
| 15 | SPI_MOSI_FLASH | H16 | 3.3 | Output | FPGA | S25FL512S (MOSI) | Low | LVCMOS33 |
| 16 | I2C_SDA | L14 | 3.3 | BiDir | FPGA / LM75A | I2C Bus | High | LVCMOS33 |
| 17 | I2C_SCL | L13 | 3.3 | Output | FPGA | I2C Bus | High | LVCMOS33 |
| 18 | LED_STATUS | M16 | 3.3 | Output | FPGA | LED Green | Low | LVCMOS33 |
| 19 | LED_FAULT | M15 | 3.3 | Output | FPGA | LED Red | Low | LVCMOS33 |
| 20 | FPGA_DONE | R14 | 2.5 | Output | FPGA Init | Done Indicator | Low | LVCMOS25 |
| 21 | FPGA_INIT_N | P14 | 2.5 | BiDir | FPGA Init | Init Indicator | High | LVCMOS25 |
| 22 | PROGRAM_B | P13 | 2.5 | Input | Reset Circuit | FPGA Config | High | LVCMOS25 |
| 23 | EN_BUCK | N17 | 3.3 | Output | FPGA | TPS62136 (EN) | Low | LVCMOS33 |
| 24 | PGOOD_BUCK | N16 | 3.3 | Input | TPS62136 (PG) | FPGA | Low (Power Bad) | LVCMOS33 |
| 25 | EN_LDO | N15 | 3.3 | Output | FPGA | MIC5209 (EN) | Low | LVCMOS33 |
| 26 | EN_ABC | P16 | 3.3 | Output | FPGA | ABC Ctrl (Enable) | Low | LVCMOS33 |
| 27 | ABC_SPI_CLK | M14 | 3.3 | Output | FPGA | U15 ABC (SCLK) | Low | LVCMOS33 |
| 28 | ABC_SPI_MOSI | N14 | 3.3 | Output | FPGA | U15 ABC (SDI) | Low | LVCMOS33 |
| 29 | ABC_SPI_MISO | L16 | 3.3 | Input | U15 ABC (SDO) | FPGA | Pull Up | LVCMOS33 |
| 30 | ABC_CS_N | M17 | 3.3 | Output | FPGA | U15 ABC (CS) | High | LVCMOS33 |
| 31 | GATE_STAT_CH1 | P17 | 3.3 | Input | U15 ABC | FPGA (Fault) | High | LVCMOS33 |
| 32 | GATE_STAT_CH2 | R18 | 3.3 | Input | U15 ABC | FPGA (Fault) | High | LVCMOS33 |
| 33 | GATE_STAT_CH3 | R17 | 3.3 | Input | U15 ABC | FPGA (Fault) | High | LVCMOS33 |
| 34 | GATE_STAT_CH4 | T17 | 3.3 | Input | U15 ABC | FPGA (Fault) | High | LVCMOS33 |
| 35 | TEMP_ALERT | T16 | 3.3 | Input | LM75A (INT) | FPGA | High | LVCMOS33 |

---

## 9. Functional Specifications

**Summary Table:**

| S.No. | Function Name | Description |
| :--- | :--- | :--- |
| 1 | Serial Communication Interface | UART between PC & FPGA via USB-UART |
| 2 | Power Supply Sequencing & Health | Control of Buck/LDO/ABC rails based on fault feedback |
| 3 | Voltage & Temperature Monitoring | I2C based monitoring of LM75A & Internal XADC |
| 4 | Flash Interfaces | Config Flash (S25FL512S) & EEPROM (AT25040N) via SPI |
| 5 | RF Bias Control (ABC) | SPI interface to Active Bias Controller for Gate Voltages |
| 6 | Fault Management | Real-time monitoring of GATE_STAT lines and PGOOD signals |
| 7 | FPGA Remote Programming | Configuration loading via UART to Flash |
| 8 | System Identification | Reading Board ID from EEPROM |

### 9.1 Serial Communication Interface
*   **Interface Type:** UART
*   **Physical Layer:** UART to USB (FT2232H on PCB)
*   **Baud Rate:** 3.0 Mbps (Configurable 9600 - 3 Mbps)
*   **Frame Format:** 1 Start bit, 8 Data bits, 1 Stop bit, No Parity (8N1)
*   **Signals:** UART_TX (FPGA -> PC), UART_RX (PC -> FPGA)
*   **Protocol:** Register-based command/response (detailed in Section 11).

### 9.2 High Speed Communication Interface
*   *Note: This board primarily uses RF outputs. No high-speed digital transceivers (GTP) are used in this specific Artix-7 package (CPG238).*

### 9.3 Power On/Off Sequence

#### 9.3.1 Power ON Sequence
1.  **Input:** +12V DC applied to J9.
2.  **FPGA Init:** FPGA configures from SPI Flash (Slave Serial or Master SPI).
3.  **Sequencing Logic:**
    *   FPGA asserts `EN_BUCK` (High).
    *   FPGA monitors `PGOOD_BUCK`. Wait for T_lock (approx 2ms).
    *   Once PGOOD is High, FPGA asserts `EN_LDO` (High).
    *   Wait for 3.3V LDO to stabilize (monitored via XADC).
    *   FPGA asserts `EN_ABC` (High).
    *   FPGA writes configuration to ABC SPI DACs to enable GaN Gates (Safe State).
4.  **Ready:** LED_STATUS turns Green. RF Paths active.

#### 9.3.2 Mode Configuration
| Mode | Signal | Value | Description |
| :--- | :--- | :--- | :--- |
| Normal | OP_MODE | 2'b00 | Full RX Path Enabled |
| Standby | OP_MODE | 2'b01 | LNA Drains On, Gates Low (Low Power) |
| Safe Shutdown | OP_MODE | 2'b10 | All Rails Disabled |
| Fault | OP_MODE | 2'b11 | Latched Fault State (Latch clear required) |

### 9.4 Supply Voltage, Current & Temperature Monitoring

#### 9.4.1 Supply Voltage and Current Monitoring
*   **Method:** FPGA Internal XADC (7 Series).
*   **Monitored Rails:** +12V Input (via divider), +5V Buck, +3.3V LDO.
*   **Measurement Range:** 0V to 15V.
*   **Resolution:** 12-bit (1.2V reference scaled).

#### 9.4.2 Temperature Monitoring
*   **IC Part Number:** LM75A (or compatible I2C sensor).
*   **Interface:** I2C at Address 0x48.
*   **Temperature Range:** -55°C to +125°C.
*   **Alert Threshold:** +85°C (Triggers `TEMP_ALERT` pin and shutdown).

### 9.5 Flash & Interfaces

#### 9.5.1 Configuration Flash
*   **Part Number:** S25FL512S ( Cypress/Infineon).
*   **Interface:** SPI (1x Mode for config, 4x for user data if needed).
*   **Capacity:** 512 Mb (64 MB).
*   **Purpose:** Stores FPGA Bitstream and User Data (Gain tables).
*   **Programming:** JTAG or UART Remote Update.

#### 9.5.2 EEPROM (ID Storage)
*   **Part Number:** AT25040N.
*   **Interface:** SPI.
*   **Capacity:** 4 Kbit (512 Bytes).
*   **Purpose:** Stores MAC Address, Board Serial Number, and Calibration Constants.

### 9.6 TRP / RF Configuration
*   *Note: While the hardware handles RX, the FPGA controls the "RF Enable" state via the ABC.*
*   **Signal:** `EN_ABC` acts as the master RF enable.
*   **Logic level:** 3.3V LVTTL.
*   **Active state:** HIGH = RF Enabled.

### 9.7 FPGA Remote Programming
*   **Protocol:** UART Protocol (See Section 11).
*   **Procedure:**
    1.  Host sends "Enter Update Mode" command (0x55).
    2.  FPGA halts normal operations.
    3.  Host sends Bitstream packets.
    4.  FPGA writes to SPI Flash via SPI Master IP.
    5.  FPGA verifies CRC.
    6.  FPGA reboots (asserts PROGRAM_B).

### 9.8 Phase Shifter / Bias Controlling
*   **Interface:** SPI (Channel 2 of SPI controller, shared with Flash via mux).
*   **Target:** U15 (Active Bias Controller).
*   **Control:** Sets Vgs for GaN transistors.
*   **Registers:** 16-bit DAC values per channel.

### 9.9 Gate Voltage Writing in DAC
*   **DAC Interface:** Inside U15 (ABC), accessed via SPI.
*   **Voltage Range:** 0V to +5V (limited to ~ -2V to 0V for GaN Gate via bias circuit).
*   **Resolution:** 16-bit.
*   **Safety:** FPGA monitors `GATE_STAT` pins (Open/Short detection).

---

## 10. Software Register Address Map

### 10.1 Register Base Addresses

| Block Name | Base Address | Address Range | Description |
| :--- | :--- | :--- | :--- |
| System / Identification | 0x0000 | 0x0000–0x00FF | Board ID, firmware version, status |
| UART Control | 0x0100 | 0x0100–0x01FF | Baud rate, FIFO control, status |
| SPI Flash Control | 0x0200 | 0x0200–0x02FF | SPI master, flash commands |
| I2C Control | 0x0300 | 0x0300–0x03FF | I2C master, device address, data |
| GPIO | 0x0400 | 0x0400–0x04FF | General purpose I/O control |
| ABC Bias Control | 0x0500 | 0x0500–0x05FF | DAC values, ABC Enable, Status |
| Temperature Monitor | 0x0600 | 0x0600–0x06FF | Temp sensor readings, alert threshold |
| Power Monitor | 0x0700 | 0x0700–0x07FF | XADC Voltage/Current readings |
| RF Control | 0x0800 | 0x0800–0x08FF | LNA Enable, RF Path Status |
| Flash / EEPROM | 0x0900 | 0x0900–0x09FF | EEPROM address, data, command |
| Diagnostics | 0x0A00 | 0x0A00–0x0AFF | Fault log, uptime counter |

### 10.2 Detailed Register Map

**Block 0x0000 — System / Identification**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 0x00 | BOARD_ID | 16 | R | 0x4855 | 'h55 = "U", 'h48 = "H" (Project Code) |
| 0x01 | FW_VERSION_MAJOR | 16 | R | 0x0001 | Firmware major version |
| 0x02 | FW_VERSION_MINOR | 16 | R | 0x0000 | Firmware minor version |
| 0x03 | SYS_STATUS | 16 | R | 0x0000 | [15:6] Reserved, [5] ABC_READY, [4] LDO_PG, [3] BUCK_PG, [2] TEMP_FAULT, [1] RF_ENABLED, [0] SYS_OK |
| 0x04 | SYS_CTRL | 16 | R/W | 0x0000 | [0] SOFT_RESET, [1] RF_ENABLE, [2] ABC_ENABLE |

**Block 0x0100 — UART Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 0x00 | BAUD_DIV | 16 | R/W | 0x0001 | Baud divisor (See 11.4) |
| 0x01 | UART_CTRL | 16 | R/W | 0x0000 | [0] UART_ENABLE, [1] LOOPBACK_EN |
| 0x02 | UART_STATUS | 16 | R | 0x0000 | [0] TX_BUSY, [1] RX_AVAIL, [2] RX_OVERRUN |
| 0x03 | TX_DATA | 16 | W | 0x0000 | Write byte to TX FIFO (Lower 8 bits) |
| 0x04 | RX_DATA | 16 | R | 0x0000 | Read byte from RX FIFO (Lower 8 bits) |

**Block 0x0300 — I2C Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 0x00 | I2C_CLK_DIV | 16 | R/W | 0x0032 | SCL clock divider (100kHz default) |
| 0x01 | I2C_TX_RX | 16 | R/W | 0x0000 | [7:0] Data to write / Data read |
| 0x02 | I2C_CTRL | 16 | R/W | 0x0000 | [0] START, [1] STOP, [2] READ, [3] WRITE, [4] ACK |
| 0x03 | I2C_STATUS | 16 | R | 0x0000 | [0] BUSY, [1] ARBIT_LOST, [2] TIMEOUT |

**Block 0x0500 — ABC Bias Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 0x00 | ABC_CH1_DAC | 16 | R/W | 0x0000 | Channel 1 Gate DAC Value (0-65535) |
| 0x01 | ABC_CH2_DAC | 16 | R/W | 0x0000 | Channel 2 Gate DAC Value |
| 0x02 | ABC_CH3_DAC | 16 | R/W | 0x0000 | Channel 3 Gate DAC Value |
| 0x03 | ABC_CH4_DAC | 16 | R/W | 0x0000 | Channel 4 Gate DAC Value |
| 0x04 | ABC_STATUS | 16 | R | 0x0000 | [3:0] Fault bits for CH4-CH1 (1=Fault) |
| 0x05 | ABC_LOAD_NOW | 16 | R/W | 0x0000 | Write 0x0001 to latch DAC values to output |

**Block 0x0700 — Power Monitor (XADC)**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 0x00 | ADC_12V_INPUT | 16 | R | ADC | Upper 12 bits of 12V reading |
| 0x01 | ADC_5V_BUCK | 16 | R | ADC | Upper 12 bits of 5V reading |
| 0x02 | ADC_3V3_LDO | 16 | R | ADC | Upper 12 bits of 3.3V reading |
| 0x03 | ADC_TEMP_INT | 16 | R | ADC | FPGA Internal Temperature |

**Block 0x0800 — RF Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 0x00 | RF_ENABLE | 16 | R/W | 0x0000 | [0] RF_ENABLE (Sets EN_ABC) |

---

## 11. UART Register Protocol Specification

This section defines the serial protocol for host access to FPGA registers.

### 11.1 Physical Layer
*   **Baud Rate:** Default 3,000,000 bps (See `BAUD_DIV` in 10.2).
*   **Frame Format:** 8N1 (1 Start, 8 Data, 1 Stop, No Parity).
*   **Physical Interface:** RS-232 level (via FT2232H) to 3.3V LVTTL.

### 11.2 Command Frame Formats

**Single Register Write (CMD = 0x57 'W')**
```text
Byte 0: 0x57 (CMD)
Byte 1: ADDR[15:8]
Byte 2: ADDR[7:0]
Byte 3: DATA[15:8]
Byte 4: DATA[7:0]
→ Response: 0x06 (ACK)
```

**Single Register Read (CMD = 0x52 'R')**
```text
Byte 0: 0x52 (CMD)
Byte 1: (ADDR[15:8] | 0x80)
Byte 2: ADDR[7:0]
→ Response: DATA[15:8], DATA[7:0]
```

**Bulk Register Write (CMD = 0x42 'B')**
```text
Byte 0: 0x42 (CMD)
Byte 1: ADDR[15:8]
Byte 2: ADDR[7:0]
Byte 3: N (Count 1-64)
Byte 4..4+2N-1: DATA pairs...
→ Response: 0x06 (ACK)
```

**Bulk Register Read (CMD = 0x62 'b')**
```text
Byte 0: 0x62 (CMD)
Byte 1: (ADDR[15:8] | 0x80)
Byte 2: ADDR[7:0]
Byte 3: N (Count 1-64)
→ Response: DATA pairs (2N bytes)
```

**Error Response:**
```text
0x15 (NAK) — Invalid CMD, Address Error, or Timeout.
```

### 11.3 Protocol Timing Constraints
| Parameter | Min | Typical | Max | Unit |
| :--- | :--- | :--- | :--- | :--- |
| Inter-byte gap (TX) | — | — | 50 | ms |
| Single Write Response | — | 0.5 | 1 | ms |
| Single Read Response | — | 1 | 2 | ms |
| Parser Timeout | 50 | — | — | ms |

---

## 12. FPGA Resource Utilization Estimate

| Resource | Available | Estimated Usage | Utilization % |
| :--- | :--- | :--- | :--- |
| Slice LUTs | 20,800 | 4,500 | 21% |
| Slice Flip-Flops | 41,600 | 5,200 | 12% |
| Block RAM (36Kb) | 50 | 4 | 8% |
| DSP Slices | 90 | 0 | 0% |
| MMCM/PLL | 5 | 1 | 20% |
| I/O Buffers | 210 | 45 | 21% |

**Synthesis Tool:** Xilinx Vivado 2023.2
**Target Device:** XC7A35T-CPG238C
**Timing Constraint:** 100 MHz (10ns)

---

## Annexure A — Requirement Traceability Matrix

| S.No. | GLR-ID | Description | Source HRS Section | GLR Section | Verification Method | Status |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | GLR-001 | Serial Communication Interface | HRS §3.2 | 9.1, 11 | Test | Open |
| 2 | GLR-002 | Power Supply Sequencing | HRS §3.2 | 9.3 | Test | Open |
| 3 | GLR-003 | Voltage/Current Monitoring | HRS §3.2 | 9.4 | Test | Open |
| 4 | GLR-004 | Flash Interfaces (Config/EEPROM) | HRS §3.2 | 9.5 | Test | Open |
| 5 | GLR-005 | RF Bias Control (ABC) | HRS §3.1 | 9.8, 9.9 | Test | Open |
| 6 | GLR-006 | Gate Voltage Writing | HRS §3.1 | 9.9, 10.2 | Inspection | Open |
| 7 | GLR-007 | Temperature Monitoring | HRS §3.2 | 9.4, 10.2 | Test | Open |
| 8 | GLR-008 | Remote Programming | HRS §3.2 | 9.7 | Demonstration | Open |
| 9 | GLR-009 | Fault Management (GATE_STAT) | HRS §3.2 | 9.6, 10.2 | Test | Open |
| 10 | GLR-010 | Register Address Map | HRS §3.2 | 10 | Inspection | Open |
| 11 | GLR-011 | Pinout Definition | HRS §3.2 | 8 | Inspection | Open |
| 12 | GLR-012 | Resource Budget | HRS §3.2 | 12 | Analysis | Open |