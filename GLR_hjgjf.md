# Glue Logic Requirements (GLR)

## Document Control
| Document Title | Glue Logic Requirements |
| Version Date | 16.04.2026 |
| Version Number | 0V01 |
| Prepared By | Name: . Sign: |
| Document Review By | Name: . Sign: |

---

## Amendments to the Document
| S. No. | Ver. No. | Ver. Date | Changed By | Section(s) Changed | Description of Change |
| 1 | 0V01 | 16.04.2026 | - | - | Initial Version |

---

## 1. Scope of the Document
This document explains the IO details and functional requirements of the FPGA for **hjgjf (Wideband RF Receiver)**. Targeted audience: Hardware Design and Firmware teams.

---

## 2. References

### 2.1 External
| Doc. Type | Part No. | Description |
|---|---|---|
| Datasheet | EV10AQ190A | 10-bit, 5 Gsps Quad ADC |
| Datasheet | HMC1099LP5E | DC-20 GHz GaAs MMIC LNA |
| Datasheet | MA4L1010-1141T | Wideband Limiter |
| Datasheet | 1492A-10 | 2.4mm RF Connector |
| Datasheet | HMC7044 | Ultra-Low Phase Noise Clock Generator |
| Datasheet | DS90CR486 | 3.3V LVDS Line Driver |
| Datasheet | LTM4644 | 4-Output 4A DC-DC Regulator |

### 2.2 Internal
| Reference | Document |
| [HRS] | Hardware Requirements Specification |
| [SCH] | Schematic |
| [GRS] | General Requirements Specification |
| [GDD] | General Design Document |

---

## 3. Acronyms and Abbreviations

| Acronym | Expansion |
|---|---|
| ADC | Analog-to-Digital Converter |
| DAC | Digital-to-Analog Converter |
| DDR | Double Data Rate |
| DNL | Differential Non-Linearity |
| DSP | Digital Signal Processing |
| EMC | Electromagnetic Compatibility |
| ENOB | Effective Number Of Bits |
| FIFO | First-In-First-Out |
| FF | Flip-Flop |
| FPGA | Field-Programmable Gate Array |
| FS | Full Scale |
| GND | Ground |
| GPIO | General Purpose Input/Output |
| HRS | Hardware Requirements Specification |
| HDL | Hardware Description Language |
| I2C | Inter-Integrated Circuit |
| IO | Input/Output |
| JTAG | Joint Test Action Group |
| LNA | Low Noise Amplifier |
| LUT | Look-Up Table |
| LVDS | Low-Voltage Differential Signaling |
| PCB | Printed Circuit Board |
| PLL | Phase-Locked Loop |
| RoHS | Restriction of Hazardous Substances |
| RTL | Register Transfer Level |
| SFDR | Spurious-Free Dynamic Range |
| SPI | Serial Peripheral Interface |
| UART | Universal Asynchronous Receiver-Transmitter |
| VCC | Voltage Common Collector |

---

## 4. Module Overview

The hjgjf hardware module is a high-performance wideband RF receiver designed for defense/aerospace applications.

**RF SECTION:**
The RF chain commences at the **J1 (1492A-10)** 2.4mm female connector supporting the 5-18GHz bandwidth. The signal passes through a **MA4L1010-1141T** wideband limiter to protect against input signals exceeding +10dBm. The protected signal is amplified by the **HMC1099LP5E** GaAs MMIC LNA, providing 22dB gain and a noise figure of 2.8dB. This amplified RF is then presented to the EV10AQ190A ADC.

**DIGITAL SECTION:**
The core logic is implemented in an FPGA (assumed Xilinx Kintex-7 or Virtex-7 class equivalent to support 10Gbps LVDS). The FPGA manages the **EV10AQ190A** ADC interface via DDR LVDS, capturing the 10-bit, 5-10Gsps data. It also controls the **HMC7044** clock generator via SPI to ensure <100fs jitter for the ADC sampling clock. System configuration and monitoring are handled via a UART interface.

**POWER SUPPLY SECTION:**
The system utilizes an **LTM4644** quad-output DC-DC regulator to generate the necessary rails from a standard input:
*   **+5.0V**: Primary supply input.
*   **+1.0V**: ADC and FPGA Core voltage.
*   **+1.8V**: FPGA and ADC I/O banking.
*   **+2.5V**: ADC Analog supply.
*   **+3.3V**: LVDS Buffers (DS90CR486) and FPGA auxiliary.
*   **-1.0V / -2.0V**: Generated via inverter for LNA/Gate biasing (if required).

---

## 5. Features
*   **FPGA:** High-Performance FPGA (Kintex-7 / UltraScale+ equivalent) for DDR LVDS data capture.
*   **On-board clock oscillator:** 100 MHz VXCO.
*   **Communication:** UART (3.125 Mbps default) for configuration and status.
*   **JTAG debugging support:** Standard 14-pin header.
*   **EEPROM:** CAT24C256 (32KB I2C) for board serial number / MAC address.
*   **Storage Flash:** S25FL512S (64Mb SPI) for FPGA configuration and user data.
*   **Temperature Monitoring:** ADT7420 (I2C) for ambient and junction temp.
*   **Power monitoring:** LTC2992 (I2C) for voltage, current, and power monitoring.
*   **ADC Interface:** Direct RF Sampling Interface (DDR LVDS) to EV10AQ190A.
*   **Clock Management:** HMC7044 SPI interface for ultra-low jitter clock synthesis.

---

## 6. FPGA Description

The FPGA is selected based on the requirement to interface directly with a 5-10 Gsps ADC (DDR LVDS) and perform preliminary signal processing or forwarding. A Xilinx Kintex-7 (XC7K325T-FFG900) or equivalent is selected to provide sufficient LVDS pairs and logic resources.

| S.NO | PARAMETERS | SPECIFICATION |
|---|---|---|
| 1 | Part Number | XC7K325T-FFG900I (Industrial Grade) |
| 2 | Logic Cells | 326,080 |
| 3 | CLB Flip-Flops | 407,200 |
| 4 | Number of Gates | ~2M (ASIC equiv) |
| 5 | Maximum Distributed RAM (Kb) | 520 |
| 6 | Total Block RAM (Kb) | 16,620 (Mb) |
| 7 | Maximum Single-Ended I/Os | 500 |
| 8 | Maximum DSP Slices | 840 |
| 9 | No of IO Bank | 14 (Banks 0-34, select 0, 13, 14, 15, 16) |

---

## 7. Block Diagram

The system consists of the RF Input feeding the Limiter -> LNA -> ADC. The FPGA interfaces to the ADC via DDR LVDS (Data and Clock). The FPGA controls the Clock Generator (HMC7044) via SPI. Power is managed by a DC-DC converter array monitored by the FPGA via I2C. Configuration is stored in SPI Flash. Host communication is via UART.

---

## 8. Pinout Details

**Table: FPGA Pin Out Details**
*Referring to Netlist (P4) and HRS (P2) assignments*

| S.No | Signal Name | Pin No | Voltage Level | Direction wrt FPGA | Source | Destination | Default Condition | Voltage Standard |
|---|---|---|---|---|---|---|---|---|
| 1 | VDD_FPGA_CORE | - | 1.0V | Power In | PWR | FPGA Core | - | - |
| 2 | GND | - | 0V | Ground | PWR | FPGA | - | - |
| 3 | FPGA_CLK_125M | E11 | 1.8V | Input | OSC | FPGA PLL | Clock | LVCMOS18 |
| 4 | FPGA_RESET_N | D12 | 1.8V | Input | Reset_Circuit | FPGA | Pull-up | LVCMOS18 |
| 5 | UART_TX | F15 | 3.3V | Output | FPGA | USB-UART | High-Z | LVCMOS33 |
| 6 | UART_RX | F16 | 3.3V | Input | USB-UART | FPGA | High-Z | LVCMOS33 |
| 7 | UART_CTS | G15 | 3.3V | Input | USB-UART | FPGA | Pull-up | LVCMOS33 |
| 8 | UART_RTS | G16 | 3.3V | Output | FPGA | USB-UART | Low | LVCMOS33 |
| 9 | I2C_SCL | H12 | 3.3V | Bi-dir | FPGA | Temp/Pwr EEPROM | High-Z | LVCMOS33 (OD) |
| 10 | I2C_SDA | J12 | 3.3V | Bi-dir | FPGA | Temp/Pwr EEPROM | High-Z | LVCMOS33 (OD) |
| 11 | SPI_CLK | K11 | 3.3V | Output | FPGA | Flash/CLK_Gen | Low | LVCMOS33 |
| 12 | SPI_MOSI | K12 | 3.3V | Output | FPGA | Flash/CLK_Gen | Low | LVCMOS33 |
| 13 | SPI_MISO | L11 | 3.3V | Input | Flash/CLK_Gen | FPGA | High-Z | LVCMOS33 |
| 14 | SPI_CS_FLASH_N | L12 | 3.3V | Output | FPGA | Flash | High | LVCMOS33 |
| 15 | SPI_CS_CLK_N | M11 | 3.3V | Output | FPGA | HMC7044 | High | LVCMOS33 |
| 16 | TCK | T11 | 1.8V | Input | JTAG_Header | FPGA | High-Z | LVCMOS18 |
| 17 | TDI | R11 | 1.8V | Input | JTAG_Header | FPGA | Pull-up | LVCMOS18 |
| 18 | TDO | P11 | 1.8V | Output | FPGA | JTAG_Header | High-Z | LVCMOS18 |
| 19 | TMS | N11 | 1.8V | Input | JTAG_Header | FPGA | Pull-up | LVCMOS18 |
| 20 | ADC_CLK_P | AA1 | 1.8V | Input | EV10AQ190A | FPGA | High-Z | LVDS_18 |
| 21 | ADC_CLK_N | AB1 | 1.8V | Input | EV10AQ190A | FPGA | High-Z | LVDS_18 |
| 22 | ADC_D0_P | AC1 | 1.8V | Input | EV10AQ190A | FPGA | High-Z | LVDS_18 |
| 23 | ADC_D0_N | AD1 | 1.8V | Input | EV10AQ190A | FPGA | High-Z | LVDS_18 |
| 24 | ADC_D1_P | AE1 | 1.8V | Input | EV10AQ190A | FPGA | High-Z | LVDS_18 |
| 25 | ADC_D1_N | AF1 | 1.8V | Input | EV10AQ190A | FPGA | High-Z | LVDS_18 |
| 26 | ADC_D2_P | AA2 | 1.8V | Input | EV10AQ190A | FPGA | High-Z | LVDS_18 |
| 27 | ADC_D2_N | AB2 | 1.8V | Input | EV10AQ190A | FPGA | High-Z | LVDS_18 |
| 28 | ADC_D3_P | AC2 | 1.8V | Input | EV10AQ190A | FPGA | High-Z | LVDS_18 |
| 29 | ADC_D3_N | AD2 | 1.8V | Input | EV10AQ190A | FPGA | High-Z | LVDS_18 |
| 30 | ADC_D4_P | AE2 | 1.8V | Input | EV10AQ190A | FPGA | High-Z | LVDS_18 |
| 31 | ADC_D4_N | AF2 | 1.8V | Input | EV10AQ190A | FPGA | High-Z | LVDS_18 |
| 32 | ADC_D5_P | AA3 | 1.8V | Input | EV10AQ190A | FPGA | High-Z | LVDS_18 |
| 33 | ADC_D5_N | AB3 | 1.8V | Input | EV10AQ190A | FPGA | High-Z | LVDS_18 |
| 34 | ADC_D6_P | AC3 | 1.8V | Input | EV10AQ190A | FPGA | High-Z | LVDS_18 |
| 35 | ADC_D6_N | AD3 | 1.8V | Input | EV10AQ190A | FPGA | High-Z | LVDS_18 |
| 36 | ADC_D7_P | AE3 | 1.8V | Input | EV10AQ190A | FPGA | High-Z | LVDS_18 |
| 37 | ADC_D7_N | AF3 | 1.8V | Input | EV10AQ190A | FPGA | High-Z | LVDS_18 |
| 38 | ADC_D8_P | AA4 | 1.8V | Input | EV10AQ190A | FPGA | High-Z | LVDS_18 |
| 39 | ADC_D8_N | AB4 | 1.8V | Input | EV10AQ190A | FPGA | High-Z | LVDS_18 |
| 40 | ADC_D9_P | AC4 | 1.8V | Input | EV10AQ190A | FPGA | High-Z | LVDS_18 |
| 41 | ADC_D9_N | AD4 | 1.8V | Input | EV10AQ190A | FPGA | High-Z | LVDS_18 |
| 42 | LED_STATUS | M12 | 3.3V | Output | FPGA | LED | Low | LVCMOS33 |
| 43 | LED_ERROR | N12 | 3.3V | Output | FPGA | LED | Low | LVCMOS33 |
| 44 | FPGA_DONE | K13 | 1.8V | Output | FPGA_MGMT | MCU | High | LVCMOS18 |
| 45 | FPGA_INIT_N | L13 | 1.8V | Output | FPGA_MGMT | MCU | High | LVCMOS18 |

---

## 9. Functional Specifications

**Summary table first:**

| S.No. | Function Name | Description |
|---|---|---|
| 1 | Serial Communication Interface | UART between PC & FPGA for configuration/telemetry. |
| 2 | High Speed LVDS Interface | Capture of 10-bit DDR LVDS from EV10AQ190A ADC. |
| 3 | Power Supply Sequencing & Health | Monitoring of 1.0V, 1.8V, 2.5V rails via I2C PMIC. |
| 4 | Temperature Monitoring | I2C-based monitoring of board temp (ADT7420). |
| 5 | Flash Interfaces | SPI Configuration Flash (S25FL512S). |
| 6 | Clock Generator Control | SPI control of HMC7044 for Synthesizer config. |
| 7 | FPGA Remote Programming | Bitstream update via UART. |
| 8 | Data Buffering | 40-bit wide buffering of ADC data to block RAM. |
| 9 | Diagnostics | Error detection and reporting via UART register map. |

Then provide DETAILED subsections:

### 9.1 Serial Communication Interface
- Interface type: UART
- Physical layer: RS-232 / TTL (via USB-UART bridge)
- Baud rate: 3.125 Mbps (Configurable divisors in register map)
- Frame format: 1 start bit, 8 data bits, 1 stop bit, no parity
- USB-UART converter IC: FT2232H (Mini-module)
- Signals: UART_TX (FPGA → PC), UART_RX (PC → FPGA)
- Protocol: Custom register-based command/response (see Section 11)

### 9.2 High Speed Communication Interface
- Interface: DDR LVDS (Source Synchronous)
- Source: EV10AQ190A ADC
- Data Width: 10 bits (physical lanes) + 1 CLK lane
- Data rate: Up to 800 Mbps per lane (DDR operation effectively 1.6 Gbps per pin pair)
- Deserialization: 1:8 or 1:16 SERDES inside FPGA ISERDES blocks.
- Physical: AC-coupled LVDS (on-module or at FPGA).

### 9.3 Power On/Off Sequence
#### 9.3.1 Power ON/OFF Sequence
Step-by-step sequence:
1. Input supply (+5V) detected — Power Good asserted.
2. FPGA Core voltage (1.0V) ramps up.
3. FPGA IO voltages (1.8V, 2.5V, 3.3V) ramp up (Monitored by FPGA).
4. FPGA releases INIT_N and loads configuration from Flash.
5. FPGA DONE signal asserted.
6. FPGA enables ADC Power Rails via GPIO (if controlled).
7. System READY status set in register.

#### 9.3.2 Mode Configuration
| Mode | Signal | Value | Description |
|---|---|---|---|
| Normal | MODE[1:0] | 2'b00 | Normal operating mode (Data capture active) |
| Test | MODE[1:0] | 2'b01 | Built-in self-test (PRBS pattern generation) |
| Programming | MODE[1:0] | 2'b10 | FPGA remote programming mode |

### 9.4 Supply Voltage, Current & Temperature Monitoring
#### 9.4.1 Supply Voltage and Current Monitoring
- IC Part Number: LTC2992
- Interface: I2C at Address 0x6F
- Monitored rails: 1.0V (Core), 1.8V (IO), 2.5V (ADC_ANA), 3.3V (ADC_Dig)
- Measurement range: 0 to 6V, 0 to 5A
- Resolution: 0.5mV / 0.1mA

#### 9.4.2 Temperature Monitoring
- IC Part Number: ADT7420
- Interface: I2C at Address 0x49
- Temperature range: -55°C to +150°C
- Resolution: 0.0625°C (16-bit ADC)
- Alert threshold: +115°C (Critical) / +100°C (Warning)

### 9.5 Flash & Interfaces
#### 9.5.1 Configuration Flash
- Part Number: S25FL512SAGBHI200
- Interface: SPI (Quad SPI capable)
- Capacity: 512 Mb (64 MB)
- Purpose: Stores FPGA programming bitstream and user data
- Programming: Via UART Remote Update or JTAG

### 9.6 Clock Configuration
- Device: HMC7044
- Interface: SPI
- Registers: Dividers, Output Enables, Mux selection.
- Function: Generate ADC clock (e.g., 2.5GHz or 5.0GHz) and FPGA reference from 100MHz VXCO.

### 9.7 FPGA Remote Programming
- Protocol: UART at 3.0 Mbps
- Tool: GUI application on host PC
- Procedure:
  1. Host sends programming command (CMD 0x57) to Register 0x0999 (trigger).
  2. FPGA enters programming mode (MODE = 2'b10).
  3. Bitstream transferred in 256-byte packets.
  4. Configuration flash written via FPGA SPI master.
  5. FPGA triggers IPROG command to reload.
- Fallback: JTAG programming via debug header.

### 9.8 Data Capture Logic
- Interface: ISERDES2 / ISERDESE3 primitives.
- Alignment: Bitslip alignment training sequence at startup.
- Buffer: 4096-deep Block RAM FIFO per channel.

---

## 10. Software Register Address Map

### 10.1 Register Base Addresses

| Block Name | Base Address | Address Range | Description |
|---|---|---|---|
| System / Identification | 0x0000 | 0x0000–0x00FF | Board ID, firmware version, status |
| UART Control | 0x0100 | 0x0100–0x01FF | Baud rate, FIFO control, status |
| SPI Control | 0x0200 | 0x0200–0x02FF | SPI master, chip-select control |
| I2C Control | 0x0300 | 0x0300–0x03FF | I2C master, device address, data |
| GPIO | 0x0400 | 0x0400–0x04FF | General purpose I/O control |
| Clock Gen Control | 0x0500 | 0x0500–0x05FF | HMC7044 SPI Bridge & Dividers |
| Temp Monitor | 0x0600 | 0x0600–0x06FF | ADT7420 Temp sensor readings |
| Power Monitor | 0x0700 | 0x0700–0x07FF | LTC2992 Voltage/Current ADC |
| ADC Interface | 0x0800 | 0x0800–0x08FF | FIFO status, capture control |
| Flash / EEPROM | 0x0900 | 0x0900–0x09FF | Flash address, data, command |
| Diagnostics | 0x0A00 | 0x0A00–0x0AFF | Fault log, uptime counter |

### 10.2 Detailed Register Map

**Block 0x0000 — System / Identification**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|---|---|---|---|---|---|
| 0x00 | BOARD_ID | 16 | R | 0xA5A5 | Board identification code |
| 0x01 | FW_VERSION_MAJOR | 16 | R | 0x0001 | Firmware major version |
| 0x02 | FW_VERSION_MINOR | 16 | R | 0x0000 | Firmware minor version |
| 0x03 | SYS_STATUS | 16 | R | 0x0000 | [15:8] Reserved, [7] PLL_LOCKED, [6] TEMP_ALERT, [5] VOLT_FAULT, [4] ADC_LOCKED, [3:0] READY |
| 0x04 | SYS_CTRL | 16 | R/W | 0x0000 | [0] SOFT_RESET, [1] WDT_ENABLE, [2] ADC_ENABLE |

**Block 0x0100 — UART Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|---|---|---|---|---|---|
| 0x00 | BAUD_DIV | 16 | R/W | 0x0002 | Baud rate divisor (125MHz/(16*Target)) |
| 0x01 | UART_CTRL | 16 | R/W | 0x0001 | [0] UART_ENABLE, [1] LOOPBACK_EN |
| 0x02 | UART_STATUS | 16 | R | 0x0000 | [0] TX_BUSY, [1] RX_AVAIL, [2] RX_OVERRUN |
| 0x03 | TX_FIFO_COUNT | 16 | R | 0x0000 | Number of bytes in TX FIFO |
| 0x04 | RX_FIFO_COUNT | 16 | R | 0x0000 | Number of bytes in RX FIFO |

**Block 0x0200 — SPI Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|---|---|---|---|---|---|
| 0x00 | SPI_CLK_DIV | 16 | R/W | 0x0010 | SPI Clock divisor |
| 0x01 | SPI_CTRL | 16 | R/W | 0x0000 | [1:0] CPOL/CPHA, [2] AUTO_CS |
| 0x02 | SPI_TX_DATA | 32 | W | 0x00000000 | Data to transmit |
| 0x03 | SPI_RX_DATA | 32 | R | 0x00000000 | Data received |
| 0x04 | SPI_STATUS | 16 | R | 0x0000 | [0] BUSY, [1] DONE |

**Block 0x0300 — I2C Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|---|---|---|---|---|---|
| 0x00 | I2C_CLK_DIV | 16 | R/W | 0x00C8 | SCL clock divisor (100kHz target) |
| 0x01 | I2C_CTRL | 16 | R/W | 0x0000 | [0] ENABLE, [1] STOP condition |
| 0x02 | I2C_TX_DATA | 8 | W | 0x00 | Byte to write |
| 0x03 | I2C_RX_DATA | 8 | R | 0x00 | Byte read |
| 0x04 | I2C_STATUS | 16 | R | 0x0000 | [0] BUSY, [1] ACK_ERROR |

**Block 0x0800 — ADC Interface Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|---|---|---|---|---|---|
| 0x00 | ADC_FIFO_CTRL | 16 | R/W | 0x0000 | [0] RESET_FIFO, [1] CAPTURE_ENABLE |
| 0x01 | ADC_FIFO_LEVEL | 16 | R | 0x0000 | Current FIFO fill level |
| 0x02 | ADC_STATUS | 16 | R | 0x0000 | [0] OVERFLOW, [1] LOCKED |

### 10.3 Register Access Rules
- All registers are 16-bit wide.
- Read: set bit15 of address (address OR 0x8000).
- Write: address as-is.

---

## 11. UART Register Protocol Specification

This section provides the EXACT byte-level frame format for the UART register protocol. Firmware MUST implement this exactly.

### 11.1 Physical Layer
- Baud rate: 3.125 Mbps (default 115.2 kbps at boot)
- Frame format: 1 start bit, 8 data bits, 1 stop bit, no parity (8N1)
- Physical interface: RS-232 / TTL
- Signal levels: 3.3V logic

### 11.2 Command Frame Formats

**Single Register Write (CMD = 0x57 'W'):**
```
Byte 0: 0x57 (CMD)
Byte 1: ADDR[15:8] (address MSB)
Byte 2: ADDR[7:0]  (address LSB)
Byte 3: DATA[15:8] (data MSB)
Byte 4: DATA[7:0]  (data LSB)
→ Response: 0x06 (ACK) within 1ms, or 0x15 (NAK) on error
Total frame: 5 bytes TX, 1 byte RX
```

**Single Register Read (CMD = 0x52 'R'):**
```
Byte 0: 0x52 (CMD)
Byte 1: (ADDR[15:8] | 0x80)  (MSB with read bit set)
Byte 2: ADDR[7:0]             (address LSB)
→ Response: DATA[15:8], DATA[7:0] within 2ms
Total frame: 3 bytes TX, 2 bytes RX
```

**Bulk Register Write (CMD = 0x42 'B'):**
```
Byte 0: 0x42 (CMD)
Byte 1: ADDR[15:8] (start address MSB)
Byte 2: ADDR[7:0]  (start address LSB)
Byte 3: N          (register count, 1–64)
Byte 4..4+2N-1: DATA[0]_H, DATA[0]_L, ..., DATA[N-1]_H, DATA[N-1]_L
→ Response: 0x06 (ACK) within 5ms, or 0x15 (NAK)
Total frame: (4 + 2N) bytes TX, 1 byte RX
```

**Bulk Register Read (CMD = 0x62 'b'):**
```
Byte 0: 0x62 (CMD)
Byte 1: (ADDR[15:8] | 0x80)  (MSB with read bit set)
Byte 2: ADDR[7:0]             (start address LSB)
Byte 3: N                     (register count, 1–64)
→ Response: DATA[0]_H, DATA[0]_L, ..., DATA[N-1]_H, DATA[N-1]_L within 5ms
Total frame: 4 bytes TX, 2N bytes RX
```

### 11.3 Protocol Timing Constraints
| Parameter | Min | Typical | Max | Unit |
|---|---|---|---|---|
| Inter-byte gap (TX side) | — | — | 50 | ms |
| Single Write response time | — | 0.5 | 1 | ms |
| Single Read response time | — | 1 | 2 | ms |
| Bulk Write response time (N=64) | — | 3 | 5 | ms |

---

## 12. FPGA Resource Utilization Estimate

| Resource | Available | Estimated Usage | Utilization % |
|---|---|---|---|
| Slice LUTs | 203,800 | 45,000 | 22% |
| Slice Flip-Flops | 407,200 | 60,000 | 14% |
| Block RAM (36Kb) | 445 | 120 | 26% |
| DSP Slices | 840 | 20 | 2% |
| MMCM/PLL | 10 | 2 | 20% |
| I/O Buffers | 500 | 150 | 30% |

*Synthesis tool: Vivado 2023.2*
*Target device: XC7K325T-FFG900I*
*Timing constraint: 200 MHz Internal, 800 Mbps LVDS*

---

## Annexure A — Requirement Traceability Matrix

| S.No. | GLR-ID | Description | Source HRS Section | GLR Section | Verification Method | Status |
|---|---|---|---|---|---|---|
| 1 | GLR-001 | Operating Frequency Range Support | HRS 3.1 REQ-HW-001 | 9.2 | Test | Open |
| 2 | GLR-002 | ADC Sampling Rate Interface | HRS 3.1 REQ-HW-006 | 9.2 | Test | Open |
| 3 | GLR-003 | Power Supply Sequencing | HRS 3.1 REQ-HW-013 | 9.3 | Test | Open |
| 4 | GLR-004 | RF Input Protection Logic | HRS 3.1 REQ-HW-014 | 9.6 | Test | Open |
| 5 | GLR-005 | Clock Input / Jitter | HRS 3.1 REQ-HW-016 | 9.6 | Test | Open |
| 6 | GLR-006 | Dynamic Range / Resolution | HRS 3.2 REQ-HW-005 | 9.2 | Test | Open |
| 7 | GLR-007 | LNA Gain Control | HRS 3.2 REQ-HW-007 | 4.0 | Inspection | Open |
| 8 | GLR-008 | LVDS Interface Standard | HRS 3.3 REQ-HW-009 | 8.0 | Inspection | Open |
| 9 | GLR-009 | Operating Temperature Logic | HRS 3.4 REQ-HW-010 | 9.4 | Test | Open |
| 10 | GLR-010 | Power Consumption Logic | HRS 3.5 REQ-HW-012 | 9.4 | Analysis | Open |
| 11 | GLR-011 | UART Register Map | GLR 10 | 10 | Inspection | Open |
| 12 | GLR-012 | UART Protocol Spec | GLR 11 | 11 | Test | Open |