# Glue Logic Requirements (GLR)

## Document Control
| Document Title | Glue Logic Requirements |
| Version Date | 17.04.2026 |
| Version Number | 0V01 |
| Prepared By | Name: . Sign: |
| Document Review By | Name: . Sign: |

---

## Amendments to the Document
| S. No. | Ver. No. | Ver. Date | Changed By | Section(s) Changed | Description of Change |
| 1 | 0V01 | 17.04.2026 | - | - | Initial Version |

---

## 1. Scope of the Document
This document explains the IO details and functional requirements of the FPGA for **Receiver Module (1000-REV-A)**. Targeted audience: Hardware Design and Firmware teams.

---

## 2. References

### 2.1 External
| Doc. Type | Part No. | Description |
|-----------|----------|-------------|
| Datasheet | HMC6180LP4E | Wideband LNA 5-20 GHz |
| Datasheet | HMC698LP4 | Digital VGA 0.5-20 GHz |
| Datasheet | HMC556LC4 | Wideband Mixer 5-26 GHz |
| Datasheet | LT3045EDD#PBF | LDO Regulator +3.3V Ultra-Low Noise |
| Datasheet | LT3094EDD#PBF | LDO Regulator +5V Low Noise |
| Datasheet | 142-0701-881 | SMA Female Connector |
| Datasheet | ICE40HX4K-TQ144 | FPGA Controller (Selected for Glue Logic) |
| Datasheet | FT2232H | USB-UART Bridge |

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
| AGC | Automatic Gain Control |
| ADC | Analog-to-Digital Converter |
| BOM | Bill of Materials |
| CLB | Configurable Logic Block |
| DAC | Digital-to-Analog Converter |
| DSP | Digital Signal Processing |
| EMC | Electromagnetic Compatibility |
| EMI | Electromagnetic Interference |
| FF | Flip-Flop |
| FPGA | Field-Programmable Gate Array |
| GND | Ground |
| GPIO | General Purpose Input/Output |
| HDL | Hardware Description Language |
| IF | Intermediate Frequency |
| I2C | Inter-Integrated Circuit |
| IO | Input/Output |
| LDO | Low Dropout Regulator |
| LNA | Low Noise Amplifier |
| LUT | Look-Up Table |
| LVDS | Low-Voltage Differential Signaling |
| PC | Personal Computer |
| PCB | Printed Circuit Board |
| PLL | Phase-Locked Loop |
| RF | Radio Frequency |
| RoHS | Restriction of Hazardous Substances |
| RTL | Register Transfer Level |
| SMA | SubMiniature version A |
| SPI | Serial Peripheral Interface |
| UART | Universal Asynchronous Receiver-Transmitter |
| VCC | Voltage Common Collector |
| VGA | Variable Gain Amplifier |

---

## 4. Module Overview
**RF SECTION:**
The RF chain utilizes the **HMC6180LP4E** LNA for the front-end amplification (5-18 GHz), followed by the **HMC698LP4** Digital VGA for gain control (0.5 dB steps, 31.5 dB range). Downconversion is handled by the **HMC556LC4** Mixer, accepting an external Local Oscillator (LO) input via an SMA connector. The chain includes DC blocking capacitors (04025C103KAT2A) at all RF ports.

**DIGITAL SECTION:**
An **ICE40HX4K-TQ144** FPGA serves as the central controller. It manages the gain settings of the HMC698LP4 via a parallel interface, monitors board health via I2C (Temperature sensors on power rails), and communicates with the host PC via a USB-UART bridge. It also implements the power-on sequencing logic to ensure proper LDO ramp-up.

**POWER SUPPLY SECTION:**
The module operates from a +12V DC input. An EMI filter and TVS protection (SMBJ12CA) are at the input. Two LT3045EDD#PBF LDOs provide ultra-low noise +3.3V rails for the FPGA and VGA logic. An LT3094EDD#PBF provides a +5V rail for the Mixer. Sequencing is handled by the FPGA monitoring the PGOOD signals.

---

## 5. Features
- **FPGA:** Lattice iCE40-HX4K TQ144 (Low Power, High Performance)
- **On-board clock oscillator:** 12 MHz CMOS Oscillator
- **Communication:** UART (USB-UART) at 3.0 Mbps
- **JTAG debugging support:** Standard JTAG header for FPGA programming
- **Configuration Flash:** 25Q128JVSI (128 Mbit) for FPGA bitstream
- **Temperature Monitoring:** 2x LM75A (I2C) for LDO and PA monitoring
- **Power monitoring:** LTC2992 (I2C) for +12V, +5V, +3.3V rail monitoring
- **Gain Control:** 8-bit Parallel Interface to HMC698LP4 VGA
- **RF Control:** TRP signal path control (internal switching logic)

---

## 6. FPGA Description
The **Lattice iCE40-HX4K** was selected for its ultra-low power consumption and small footprint, suitable for a defense-grade receiver module where thermal dissipation is critical. It provides sufficient logic cells to handle the UART protocol stack, I2C master interfaces, and parallel VGA control logic.

| S.NO | PARAMETERS | SPECIFICATION |
|------|-----------|---------------|
| 1 | Part Number | ICE40HX4K-TQ144 |
| 2 | Logic Cells | 3520 |
| 3 | CLB Flip-Flops | Not Applicable (PLC Architecture) |
| 4 | Number of Gates | ~40,000 |
| 5 | Maximum Distributed RAM (Kb) | 80 |
| 6 | Total Block RAM (Kb) | 240 |
| 7 | Maximum Single-Ended I/Os | 136 |
| 8 | Maximum DSP Slices | 0 (Uses HardWire logic) |
| 9 | No of IO Bank | 4 |

---

## 7. Block Diagram
(Reference to block diagram — described in text)
The FPGA connects to the USB-UART bridge (RX/TX), the VGA Control Header (LE, D0-D6), and the I2C bus for telemetry. It drives the ENABLE pins for the +3.3V and +5V LDOs.

---

## 8. Pinout Details

**Table: FPGA Pin Out Details**

| S.No | Signal Name | Pin No | Voltage Level | Direction wrt FPGA | Source | Destination | Default Condition | Voltage Standard |
|---|---|---|---|---|---|---|---|---|
| 1 | VCCINT_1V2 | 15 | +1.2V | Power | LDO | FPGA Core | - | - |
| 2 | VCCIO_3V3 | 16 | +3.3V | Power | LDO | FPGA IO Banks | - | - |
| 3 | GND | 17 | 0V | Ground | PCB | FPGA | - | - |
| 4 | FPGA_CLK_12M | 25 | 3.3V | Input | Oscillator | FPGA PLL | Clock | LVCMOS33 |
| 5 | JTAG_TCK | 121 | 3.3V | Input | Debugger | FPGA | Pull-Down | LVCMOS33 |
| 6 | JTAG_TDI | 122 | 3.3V | Input | Debugger | FPGA | Pull-Up | LVCMOS33 |
| 7 | JTAG_TDO | 123 | 3.3V | Output | FPGA | Debugger | High-Z | LVCMOS33 |
| 8 | JTAG_TMS | 124 | 3.3V | Input | Debugger | FPGA | Pull-Up | LVCMOS33 |
| 9 | RESET_N | 80 | 3.3V | Input | System Reset | FPGA | Pull-Up | LVCMOS33 |
| 10 | UART_RX | 9 | 3.3V | Input | USB-UART | FPGA | High-Z | LVCMOS33 |
| 11 | UART_TX | 10 | 3.3V | Output | FPGA | USB-UART | High | LVCMOS33 |
| 12 | VGA_LE | 50 | 3.3V | Output | FPGA | HMC698LP4 (LE) | Low | LVCMOS33 |
| 13 | VGA_D0 | 51 | 3.3V | Output | FPGA | HMC698LP4 (D0) | Low | LVCMOS33 |
| 14 | VGA_D1 | 52 | 3.3V | Output | FPGA | HMC698LP4 (D1) | Low | LVCMOS33 |
| 15 | VGA_D2 | 55 | 3.3V | Output | FPGA | HMC698LP4 (D2) | Low | LVCMOS33 |
| 16 | VGA_D3 | 56 | 3.3V | Output | FPGA | HMC698LP4 (D3) | Low | LVCMOS33 |
| 17 | VGA_D4 | 57 | 3.3V | Output | FPGA | HMC698LP4 (D4) | Low | LVCMOS33 |
| 18 | VGA_D5 | 58 | 3.3V | Output | FPGA | HMC698LP4 (D5) | Low | LVCMOS33 |
| 19 | VGA_D6 | 59 | 3.3V | Output | FPGA | HMC698LP4 (D6) | Low | LVCMOS33 |
| 20 | I2C_SCL | 110 | 3.3V | Bi-Dir | FPGA | Pull-Up (R3) | High | LVCMOS33 |
| 21 | I2C_SDA | 111 | 3.3V | Bi-Dir | FPGA | Pull-Up (R4) | High | LVCMOS33 |
| 22 | SPI_CS_N | 98 | 3.3V | Output | FPGA | Flash CS | High | LVCMOS33 |
| 23 | SPI_CLK | 99 | 3.3V | Output | FPGA | Flash CLK | Low | LVCMOS33 |
| 24 | SPI_MOSI | 100 | 3.3V | Output | FPGA | Flash DI | Low | LVCMOS33 |
| 25 | SPI_MISO | 101 | 3.3V | Input | Flash DO | FPGA | High-Z | LVCMOS33 |
| 26 | LED_STATUS | 120 | 3.3V | Output | FPGA | LED (Green) | Low | LVCMOS33 |
| 27 | LED_ERROR | 119 | 3.3V | Output | FPGA | LED (Red) | Low | LVCMOS33 |
| 28 | EN_3V3_LDO | 85 | 3.3V | Output | FPGA | LT3045 EN | Low (Off) | LVCMOS33 |
| 29 | PGOOD_3V3 | 86 | 3.3V | Input | LT3045 PG | FPGA | Pull-Up | LVCMOS33 |
| 30 | EN_5V_LDO | 87 | 3.3V | Output | FPGA | LT3094 EN | Low (Off) | LVCMOS33 |
| 31 | PGOOD_5V | 88 | 3.3V | Input | LT3094 PG | FPGA | Pull-Up | LVCMOS33 |
| 32 | TEMP_ALERT | 115 | 3.3V | Input | LM75A Int | FPGA | Pull-Up | LVCMOS33 |
| 33 | CDONE | 14 | 3.3V | Output | FPGA | Config Status | High-Z | LVCMOS33 |
| 34 | CRESET | 13 | 3.3V | Input | Reset Logic | FPGA | Pull-Up | LVCMOS33 |
| 35 | VIN_MON_AN | 102 | 3.3V | Input | ADC Div | FPGA ADC | High-Z | LVCMOS33 |

---

## 9. Functional Specifications

**Summary table first:**

| S.No. | Function Name | Description |
|---|---|---|
| 1 | Serial Communication Interface | UART between PC & FPGA via USB-UART (RS232 level translation) |
| 2 | RF Gain Control Interface | 8-bit Parallel interface to HMC698LP4 VGA |
| 3 | Power Supply Sequencing & Health Status | Based on LDO PGOOD signals, controls enable pins |
| 4 | Supply Voltage, Current & Temperature Monitoring | I2C-based monitoring via LTC2992 and LM75A |
| 5 | Flash Interfaces | Configuration Flash (SPI) for FPGA bitstream storage |
| 6 | Diagnostics | Status LED indication and fault logging to internal registers |
| 7 | FPGA Remote Programming | Bitstream loading via UART Slave SPI method |
| 8 | RF Switch Control | General control for external RF path switching (if applicable) |

### 9.1 Serial Communication Interface
- Interface type: UART
- Physical layer: RS-232 (via FT2232H to USB)
- Baud rate: 3,000,000 bps (3.0 Mbps)
- Frame format: 1 start bit, 8 data bits, 1 stop bit, no parity
- USB-UART converter IC: FT2232H
- Signals: UART_TX (FPGA → PC), UART_RX (PC → FPGA)
- Protocol: Custom register-based command/response (See Section 11)

### 9.2 High Speed Communication Interface
- Interface: Not applicable on this receiver module (Control interface only).

### 9.3 Power On/Off Sequence
#### 9.3.1 Power ON/OFF Sequence
1. Input supply (+12V) detected.
2. FPGA CRESET released (internal POR done).
3. FPGA waits 10ms, then asserts EN_3V3_LDO.
4. FPGA waits for PGOOD_3V3 assertion.
5. FPGA asserts EN_5V_LDO.
6. FPGA waits for PGOOD_5V assertion.
7. FPGA loads configuration from SPI Flash.
8. System READY status asserted.

#### 9.3.2 Mode Configuration
| Mode | Signal | Value | Description |
|------|--------|-------|-------------|
| Normal | MODE[1:0] | 2'b00 | Normal operating mode |
| Programming | MODE[1:0] | 2'b01 | FPGA remote programming mode |
| Test | MODE[1:0] | 2'b10 | Built-in self-test |

### 9.4 Supply Voltage, Current & Temperature Monitoring
#### 9.4.1 Supply Voltage and Current Monitoring
- IC Part Number: LTC2992
- Interface: I2C at Address 0x6F
- Monitored rails: +12V Input, +3.3V Logic, +5V RF
- Measurement range: 0 to 20V, 0 to 5A
- Resolution: 0.5mV / 0.1mA

#### 9.4.2 Temperature Monitoring
- IC Part Number: LM75A (x2 instances)
- Interface: I2C at Address 0x48 and 0x49
- Temperature range: -55°C to +125°C
- Resolution: 0.5°C (11-bit ADC)
- Alert threshold: 120°C (Programmable)

### 9.5 Flash & Interfaces
#### 9.5.1 Configuration Flash
- Part Number: 25Q128JVSI
- Interface: SPI (Standard)
- Capacity: 128 Mbit (16 MB)
- Purpose: Stores FPGA programming bitstream
- Programming: Via USB-UART interface using Flash Upgrade utility

### 9.6 TRP Configuration
- Signal: TRP (Transmit/Receive Pulse)
- Direction: FPGA → RF front-end (if applicable)
- Logic level: 3.3V LVTTL
- Active state: HIGH = RX enabled
- Timing: Immediate update upon register write

### 9.7 FPGA Remote Programming
- Protocol: UART at 3.0 Mbps
- Tool: iCEburn GUI or equivalent
- Procedure:
  1. Host sends programming command via UART.
  2. FPGA enters programming mode.
  3. Bitstream transferred.
  4. FPGA writes to external Flash.
  5. FPGA reboots.

### 9.8 Gain Control (VGA) Interface
- Control basis: Host PC command (Gain Setpoint in dB)
- Interface: Parallel (LE, D6..D0)
- Gain resolution: 0.5 dB
- Update rate: < 10us
- Gain table: Linear 0.5dB steps.

---

## 10. Software Register Address Map

### 10.1 Register Base Addresses

| Block Name | Base Address | Address Range | Description |
|------------|-------------|---------------|-------------|
| System / Identification | 0x0000 | 0x0000–0x00FF | Board ID, firmware version, status |
| UART Control | 0x0100 | 0x0100–0x01FF | Baud rate, FIFO control, status |
| GPIO | 0x0400 | 0x0400–0x04FF | General purpose I/O control |
| I2C Control | 0x0300 | 0x0300–0x03FF | I2C master, device address, data |
| RF Control | 0x0800 | 0x0800–0x08FF | VGA Gain, TRP control |
| Power Monitor | 0x0700 | 0x0700–0x07FF | Voltage/current ADC readings per rail |
| Flash / EEPROM | 0x0900 | 0x0900–0x09FF | Flash address, data, command register |
| Diagnostics | 0x0A00 | 0x0A00–0x0AFF | Fault log, uptime counter |

### 10.2 Detailed Register Map

**Block 0x0000 — System / Identification**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|--------------|-------|-----|-------------|----------------------|
| 0x00 | BOARD_ID | 16 | R | 0x1000 | Board identification code (1000-REV-A) |
| 0x01 | FW_VERSION_MAJOR | 16 | R | 0x0001 | Firmware major version |
| 0x02 | FW_VERSION_MINOR | 16 | R | 0x0000 | Firmware minor version |
| 0x03 | SYS_STATUS | 16 | R | 0x0000 | [15:8] Reserved, [7] PGOOD_5V, [6] PGOOD_3V3, [5] TEMP_ALERT, [4:0] Reserved |
| 0x04 | SYS_CTRL | 16 | R/W | 0x0000 | [0] SOFT_RESET, [1] RF_ENABLE |

**Block 0x0100 — UART Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|--------------|-------|-----|-------------|----------------------|
| 0x00 | BAUD_DIV | 16 | R/W | 0x0002 | Baud rate divisor (Default for 3Mbps) |
| 0x01 | UART_CTRL | 16 | R/W | 0x0001 | [0] UART_ENABLE, [1] LOOPBACK_EN |
| 0x02 | UART_STATUS | 16 | R | 0x0000 | [0] TX_BUSY, [1] RX_AVAIL, [2] RX_OVERRUN |
| 0x03 | TX_FIFO_COUNT | 16 | R | 0x0000 | Number of bytes in TX FIFO |
| 0x04 | RX_FIFO_COUNT | 16 | R | 0x0000 | Number of bytes in RX FIFO |

**Block 0x0300 — I2C Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|--------------|-------|-----|-------------|----------------------|
| 0x00 | I2C_CLK_DIV | 16 | R/W | 0x0032 | Clock divider for 100kHz I2C |
| 0x01 | I2C_CTRL | 16 | R/W | 0x0000 | [0] I2C_ENABLE, [1] START_COND, [2] STOP_COND |
| 0x02 | I2C_TX_DATA | 16 | R/W | 0x0000 | [7:0] Byte to transmit |
| 0x03 | I2C_RX_DATA | 16 | R | 0x0000 | [7:0] Byte received |
| 0x04 | I2C_STATUS | 16 | R | 0x0000 | [0] ACK_RECEIVED, [1] BUSY |

**Block 0x0800 — RF Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|--------------|-------|-----|-------------|----------------------|
| 0x00 | VGA_GAIN_6BIT | 16 | R/W | 0x0000 | [6:0] 7-bit Parallel gain code (0-127 = 0-31.5dB) |
| 0x01 | VGA_LOAD_LE | 16 | R/W | 0x0000 | [0] Pulse HIGH to load gain (Write 1 then 0) |
| 0x02 | RF_MODE | 16 | R/W | 0x0000 | [0] RX_ENABLE (1 = Active) |

**Block 0x0700 — Power Monitor**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|--------------|-------|-----|-------------|----------------------|
| 0x00 | VOLT_12V_MSB | 16 | R | 0x0000 | Voltage MSB (LTC2992) |
| 0x01 | VOLT_12V_LSB | 16 | R | 0x0000 | Voltage LSB |
| 0x02 | TEMP_BOARD | 16 | R | 0x0000 | [15:5] Temperature (0.0625°C/LSB) |

### 10.3 Register Access Rules
- All registers are 16-bit wide.
- Read: set bit15 of address (address OR 0x8000)
- Write: address as-is.

---

## 11. UART Register Protocol Specification

### 11.1 Physical Layer
- Baud rate: 3,000,000 bps (Fixed).
- Frame format: 1 start bit, 8 data bits, 1 stop bit, no parity (8N1).
- Physical interface: RS-232 Levels via FT2232H.
- Signal levels: +/- 3.0V RS-232 logic.

### 11.2 Command Frame Formats

**Single Register Write (CMD = 0x57 'W'):**
```
Byte 0: 0x57 (CMD)
Byte 1: ADDR[15:8] (address MSB)
Byte 2: ADDR[7:0]  (address LSB)
Byte 3: DATA[15:8] (data MSB)
Byte 4: DATA[7:0]  (data LSB)
→ Response: 0x06 (ACK) within 1ms
Total frame: 5 bytes TX, 1 byte RX
```

**Single Register Read (CMD = 0x52 'R'):**
```
Byte 0: 0x52 (CMD)
Byte 1: (ADDR[15:8] | 0x80)
Byte 2: ADDR[7:0]
→ Response: DATA[15:8], DATA[7:0]
Total frame: 3 bytes TX, 2 bytes RX
```

**Bulk Register Write (CMD = 0x42 'B'):**
```
Byte 0: 0x42 (CMD)
Byte 1: ADDR[15:8]
Byte 2: ADDR[7:0]
Byte 3: N
Byte 4..: DATA[0]...DATA[N-1]
→ Response: 0x06 (ACK)
```

**Bulk Register Read (CMD = 0x62 'b'):**
```
Byte 0: 0x62 (CMD)
Byte 1: (ADDR[15:8] | 0x80)
Byte 2: ADDR[7:0]
Byte 3: N
→ Response: DATA[0]...DATA[N-1]
```

**Error Response:**
```
0x15 (NAK) — Invalid CMD or Address.
```

### 11.3 Protocol Timing Constraints
| Parameter | Min | Typical | Max | Unit |
|-----------|-----|---------|-----|------|
| Inter-byte gap (TX side) | - | - | 50 | ms |
| Single Write response | - | 0.5 | 1 | ms |

---

## 12. FPGA Resource Utilization Estimate

| Resource | Available | Estimated Usage | Utilization % |
|---------|-----------|----------------|--------------|
| Slice LUTs | 3520 | 1200 | 34% |
| Slice Flip-Flops | - | 800 | 22% |
| Block RAM (1Kb) | 240 | 32 | 13% |
| DSP Slices | 0 | 0 | 0% |
| PLL | 1 | 1 | 100% |
| I/O Buffers | 136 | 35 | 25% |

Synthesis tool: Lattice Radiant 2024.1
Target device: ICE40HX4K-TQ144
Timing constraint: 12 MHz System Clock

---

## Annexure A — Requirement Traceability Matrix

| S.No. | GLR-ID | Description | Source HRS Section | GLR Section | Verification Method | Status |
|-------|--------|-------------|-------------------|-------------|--------------------|----|
| 1 | GLR-001 | Serial Communication Interface | HRS §3.3 | 9.1, 11 | Test | Open |
| 2 | GLR-002 | Power Supply Sequencing | HRS §3.1 | 9.3 | Test | Open |
| 3 | GLR-003 | Voltage/Current/Temperature Monitoring | HRS §3.2 | 9.4 | Test | Open |
| 4 | GLR-004 | RF Gain Control | HRS §3.1 (REQ-HW-011) | 9.8, 10 | Test | Open |
| 5 | GLR-005 | Register Address Map | HRS §3.3 | 10 | Inspection | Open |
| 6 | GLR-006 | UART Protocol Specification | HRS §3.3 | 11 | Test | Open |
| 7 | GLR-007 | FPGA Resource Budget | HRS §3.5 | 12 | Analysis | Open |