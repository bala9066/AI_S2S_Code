# Glue Logic Requirements (GLR)

## Document Control
| Document Title | Glue Logic Requirements |
| :--- | :--- |
| Version Date | 16.04.2026 |
| Version Number | 0V01 |
| Prepared By | Name: AI Gen. Sign: . |
| Document Review By | Name: . Sign: |

---

## Amendments to the Document
| S. No. | Ver. No. | Ver. Date | Changed By | Section(s) Changed | Description of Change |
|:---:|:---:|:---:|:---:|:---:|:---|
| 1 | 0V01 | 16.04.2026 | - | - | Initial Version |

---

## 1. Scope of the Document
This document explains the IO details and functional requirements of the FPGA for **sample rf**. Targeted audience: Hardware Design and Firmware teams.

---

## 2. References

### 2.1 External
| Doc. Type | Part No. | Description |
|:---|:---|:---|
| Datasheet | HMC698LP4ETRS | 2-20 GHz GaAs MMIC LNA |
| Datasheet | HMC1119LP4ETRS | 6-18 GHz GaAs MMIC Mixer |
| Datasheet | ADA4817-1ACPZ-R7 | 1 GHz Low Noise Op-Amp |
| Datasheet | ADC12J4000 | 12-Bit, 4 GSPS ADC |
| Datasheet | LMZ14203HVKIT | 42V Input, 3A Step-Down Power Module |
| Datasheet | TPS7A4700RGWT | 36V, 1A, Low Noise LDO |
| Datasheet | TPS62130RGTT | 17V, 3A Synchronous Step-Down Converter |
| Datasheet | 568-10088-1018-1 | Si5345 Any-Frequency Clock Generator |
| Datasheet | HMC364LP4ETRS | GaAs Inverter / Amplifier |
| Datasheet | TCM1-63AX+ | 4-8 GHz MMIC Balun |
| Datasheet | SAMTEC-HSTC-120 | High-Speed Termination Connector |

### 2.2 Internal
| Reference | Document |
|:---|:---|
| [HRS] | Hardware Requirements Specification |
| [SCH] | Schematic |
| [GRS] | General Requirements Specification |
| [GDD] | General Design Document |

---

## 3. Acronyms and Abbreviations
| Acronym | Expansion |
|:---|:---|
| **ADC** | Analog-to-Digital Converter |
| **BGA** | Ball Grid Array |
| **BOM** | Bill of Materials |
| **C** | Celsius |
| **CLB** | Configurable Logic Block |
| **DAC** | Digital-to-Analog Converter |
| **DMA** | Direct Memory Access |
| **DSP** | Digital Signal Processing / Slice |
| **EMC** | Electromagnetic Compatibility |
| **FF** | Flip-Flop |
| **FIFO** | First-In-First-Out |
| **FPGA** | Field-Programmable Gate Array |
| **GND** | Ground |
| **GPIO** | General Purpose Input/Output |
| **HDL** | Hardware Description Language |
| **HSTC** | High-Speed Samtec Termination Connector |
| **I2C** | Inter-Integrated Circuit |
| **IO** | Input/Output |
| **IQ** | In-phase / Quadrature |
| **JTAG** | Joint Test Action Group |
| **LED** | Light Emitting Diode |
| **LNA** | Low Noise Amplifier |
| **LUT** | Look-Up Table |
| **LVDS** | Low-Voltage Differential Signaling |
| **LVTTL** | Low Voltage Transistor-Transistor Logic |
| **PCB** | Printed Circuit Board |
| **PLL** | Phase-Locked Loop |
| **RF** | Radio Frequency |
| **RoHS** | Restriction of Hazardous Substances |
| **RTL** | Register Transfer Level |
| **SPI** | Serial Peripheral Interface |
| **UART** | Universal Asynchronous Receiver-Transmitter |
| **VCC** | Voltage Common Collector |

---

## 4. Module Overview

### RF SECTION:
The RF section covers the 5-18 GHz receiver chain. It utilizes the **HMC698LP4** LNA for front-end gain, followed by the **TCM1-63AX+** balun and **HMC1119LP4** mixer for downconversion. The Local Oscillator (LO) path is buffered by the **HMC364** amplifier. IF outputs (I/Q) are conditioned by the **ADA4817-1** op-amp before digitization.

### DIGITAL SECTION:
The digital core is the **ADC12J4000** (12-bit, 4 GSPS) providing digitized IQ data. The system requires an FPGA (implied companion device on HSTC interface or external) to process the **HSTC_HEADER** (J3) output, control the **Si5345** clock generator via I2C, and configure the ADC via SPI. Note: While the netlist shows discrete ADC logic, an FPGA is required to bridge the HSTC interface to the system processor and manage the glue logic defined in this document.

### POWER SUPPLY SECTION:
Power is input via J4 (5-12V). The **LMZ14203** steps this down to 3.3V. The **TPS7A4700** (U5) provides a clean 5V rail for the IF amplifier (ADA4817-1), and **TPS62130** provides 1.8V for the ADC analog supplies. **TPS7A4700** (U6) provides the 3.3V digital IO rail.

---

## 5. Features
- **RF Input**: 5 - 18 GHz Wideband Reception (via HMC698LP4)
- **High-Speed ADC**: TI ADC12J4000 (12-bit, 4 GSPS) with DDC
- **Clock Generation**: Si5345 Multi-frequency Clock Generator (programmable)
- **Data Interface**: High-Speed IQ Data via Samtec HSTC (J3)
- **Configuration**: SPI Interface for ADC setup (via J5 header)
- **Power Management**: Wide input range 5-12V, DC-DC switching + LDO regulation
- **Temperature Protection**: Industrial temperature range support (-40 to +85°C)
- **LO Buffering**: HMC364 for LO input conditioning

---

## 6. FPGA Description
*Note: The netlist describes the ADC and analog front-end. This section describes the Glue Logic FPGA requirements which are typically paired with such an module via the HSTC connector J3 or required to control the Si5345/ADC.*

**Selection Rationale:**
An FPGA is required to interface with the high-speed parallel LVDS outputs of the ADC12J4000 (J3) and perform initial frame alignment and packetization. It also serves as the host controller for the Si5345 clock generator (I2C) and ADC configuration (SPI).

**Specification:**

| S.NO | PARAMETERS | SPECIFICATION |
|:---:|:---|:---|
| 1 | Part Number | Xilinx Kintex-7 XC7K325T-FFG900 (Example for Interface) |
| 2 | Logic Cells | 326,000 |
| 3 | CLB Flip-Flops | 407,200 |
| 4 | Number of Gates | ~5 Million (ASIC equiv) |
| 5 | Maximum Distributed RAM (Kb) | 520 |
| 6 | Total Block RAM (Kb) | 10,260 |
| 7 | Maximum Single-Ended I/Os | 500 |
| 8 | Maximum DSP Slices | 840 |
| 9 | No of IO Bank | 14 (Multi-voltage support) |

---

## 7. Block Diagram
**System Block Diagram:**
[RF IN] -> [BPF] -> [LNA HMC698] -> [Mixer HMC1119] -> [IF Amp ADA4817] -> [ADC ADC12J4000] -> **[HSTC J3 -> FPGA]**
[Clock Ref J5] -> [Si5345] -> [ADC CLK] & [LO Amp HMC364]
[Host J5/SPI] -> [ADC SPI]
[FPGA] -> [I2C Bus] -> [Si5345, PMON]

---

## 8. Pinout Details

**Table: FPGA / Interface Pin Out Details**
*(Derived from Netlist J3, J5, J2 and Control signals)*

| S.No | Signal Name | Pin No (Ref) | Voltage Level | Direction wrt FPGA | Source | Destination | Default Condition | Voltage Standard |
|:---:|:---|:---:|:---|:---|:---|:---|:---|:---|
| 1 | **ADC_DATA_D0** | J3-01 | 1.8V | Input | ADC12J4000 | FPGA | High-Z | LVDS / LVCMOS18 |
| 2 | **ADC_DATA_D1** | J3-03 | 1.8V | Input | ADC12J4000 | FPGA | High-Z | LVDS / LVCMOS18 |
| 3 | **ADC_DATA_D2** | J3-05 | 1.8V | Input | ADC12J4000 | FPGA | High-Z | LVDS / LVCMOS18 |
| 4 | **ADC_DATA_D3** | J3-07 | 1.8V | Input | ADC12J4000 | FPGA | High-Z | LVDS / LVCMOS18 |
| 5 | **ADC_DATA_D4** | J3-09 | 1.8V | Input | ADC12J4000 | FPGA | High-Z | LVDS / LVCMOS18 |
| 6 | **ADC_DATA_D5** | J3-11 | 1.8V | Input | ADC12J4000 | FPGA | High-Z | LVDS / LVCMOS18 |
| 7 | **ADC_DATA_D6** | J3-13 | 1.8V | Input | ADC12J4000 | FPGA | High-Z | LVDS / LVCMOS18 |
| 8 | **ADC_DATA_D7** | J3-15 | 1.8V | Input | ADC12J4000 | FPGA | High-Z | LVDS / LVCMOS18 |
| 9 | **ADC_DATA_D8** | J3-17 | 1.8V | Input | ADC12J4000 | FPGA | High-Z | LVDS / LVCMOS18 |
| 10 | **ADC_DATA_D9** | J3-19 | 1.8V | Input | ADC12J4000 | FPGA | High-Z | LVDS / LVCMOS18 |
| 11 | **ADC_DATA_D10** | J3-21 | 1.8V | Input | ADC12J4000 | FPGA | High-Z | LVDS / LVCMOS18 |
| 12 | **ADC_DATA_D11** | J3-23 | 1.8V | Input | ADC12J4000 | FPGA | High-Z | LVDS / LVCMOS18 |
| 13 | **SPI_SCLK** | J5-03 | 3.3V | Output | FPGA | ADC (U4) | Low | LVCMOS33 |
| 14 | **SPI_SDIO** | J5-01 | 3.3V | Bi-Dir | FPGA | ADC (U4) | High-Z | LVCMOS33 |
| 15 | **SPI_CS** | J5-05 | 3.3V | Output | FPGA | ADC (U4) | High | LVCMOS33 |
| 16 | **I2C_SDA** | FPGA_IO | 3.3V | Bi-Dir | FPGA | Si5345 (U9) | High-Z | LVCMOS33 |
| 17 | **I2C_SCL** | FPGA_IO | 3.3V | Output | FPGA | Si5345 (U9) | High | LVCMOS33 |
| 18 | **LED_STATUS** | D2 Net | 3.3V | Output | FPGA | LED (D2) | Low | LVTTL |
| 19 | **LO_IN_PRESENT** | J2 Mon | 3.3V | Input | LO Det (Ext) | FPGA | Low | LVTTL |
| 20 | **VDD_3V3_SEL** | R9 Net | 3.3V | Input | FPGA | Power Rail | High | LVTTL |
| 21 | **FPGA_RESET_N** | FPGA IO | 3.3V | Input | Ext Reset | FPGA | Pullup | LVTTL |
| 22 | **CLK_REF_IN** | J5-07 | 3.3V | Input | Ref Clk | FPGA / Si5345 | Clock | LVCMOS33 |
| 23 | **GND** | - | 0V | - | Common | Chassis | - | - |
| 24 | **VCCINT_1V0** | - | 1.0V | Power | Regulator | FPGA Core | - | - |
| 25 | **VCCAUX_1V8** | - | 1.8V | Power | Regulator | FPGA Aux | - | - |
| 26 | **VCCO_34_3V3** | - | 3.3V | Power | LDO U6 | FPGA IO Bank 34 | - | - |
| 27 | **VCCO_35_1V8** | - | 1.8V | Power | Buck U7 | FPGA IO Bank 35 | - | - |
| 28 | **UART_TX** | FPGA IO | 3.3V | Output | FPGA | UART/USB | High | LVTTL |
| 29 | **UART_RX** | FPGA IO | 3.3V | Input | UART/USB | FPGA | High | LVTTL |
| 30 | **JTAG_TCK** | FPGA IO | 3.3V | Input | Debugger | FPGA | Pullup | LVCMOS33 |
| 31 | **JTAG_TDI** | FPGA IO | 3.3V | Input | Debugger | FPGA | Pullup | LVCMOS33 |
| 32 | **JTAG_TDO** | FPGA IO | 3.3V | Output | FPGA | Debugger | High-Z | LVCMOS33 |
| 33 | **JTAG_TMS** | FPGA IO | 3.3V | Input | Debugger | FPGA | Pullup | LVCMOS33 |
| 34 | **FPGA_PG** | FPGA IO | 3.3V | Input | Power Mon | FPGA | Low | LVTTL |
| 35 | **DAC_CLK_P** | U9 Out | 3.3V | Input | Si5345 | LO Amp / FPGA | Clock | LVDS |

---

## 9. Functional Specifications

**Summary table first:**

| S.No. | Function Name | Description |
|:---:|:---|:---|
| 1 | High Speed Data Capture | 12-bit parallel LVDS capture from ADC12J4000 via J3 |
| 2 | Serial Communication | UART (RS-232/USB) for register access and control |
| 3 | Clock Management | I2C control of Si5345 for ADC and LO clock synthesis |
| 4 | ADC Interface | SPI configuration of ADC12J4000 (Gain, Format, DDC settings) |
| 5 | Power Sequencing | Monitoring of 5V, 3.3V, 1.8V rails and enable sequencing |
| 6 | LED Indication | Status LED blink patterns for system health |
| 7 | LO Path Control | Monitoring of LO input presence |
| 8 | Data Processing | Basic packetization of IQ data for transport |

### 9.1 Serial Communication Interface
- **Interface type:** UART
- **Physical layer:** TTL (3.3V) level, FTDI USB-UART on host PC
- **Baud rate:** 3.0 Mbps (configurable)
- **Frame format:** 1 start bit, 8 data bits, 1 stop bit, no parity (8N1)
- **Protocol:** Custom register-based command/response (See Section 11)
- **Signals:** UART_TX (FPGA → PC), UART_RX (PC → FPGA)

### 9.2 High Speed Communication Interface
- **Interface:** Parallel LVDS (via J3 HSTC Header)
- **Data Width:** 12 bits (D0-D11)
- **Data Rate:** up to 400 Mbps per lane (Source Synchronous)
- **Protocol:** Double Data Rate (DDR) capture on both clock edges
- **Physical:** Samtec HSTC-120 (high-speed termination)

### 9.3 Power On/Off Sequence
#### 9.3.1 Power ON Sequence
1. Input Supply (+5V to +12V) applied to J4.
2. Fuse F1 and TVS D1 verify safety.
3. LMZ14203 (U8) enables 3.3V rail.
4. TPS62130 (U7) and TPS7A4700 (U5/U6) sequence up 1.8V and 5V/3.3V_IO.
5. FPGA initiates Power-Good (FPGA_PG) check.
6. FPGA loads configuration from Flash (if present).
7. FPGA configures Si5345 via I2C.
8. ADC enable signals asserted.

#### 9.3.2 Mode Configuration
| Mode | Signal | Value | Description |
|:---|:---|:---|:---|
| Normal | MODE[1:0] | 2'b00 | Full speed ADC operation |
| BIST | MODE[1:0] | 2'b01 | Built-in self-test (Loopback) |
| Low Power | MODE[1:0] | 2'b10 | Clock gating / ADC power down |

### 9.4 Supply Voltage & Current Monitoring
*Note: Netlist shows discrete regulators. Monitoring is assumed via FPGA internal ADC or I2C PMIC.*
- **Interface:** Internal FPGA XADC (7-series) or I2C (if PMIC added).
- **Monitored Rails:** 5V_MAIN, 3V3_REG, 1V8_ADC.
- **Thresholds:** Over-voltage > 5.5V, Under-voltage < 4.5V.
- **Action:** Reset assertion on fault.

### 9.5 Flash & Interfaces
#### 9.5.1 Configuration Flash
- **Interface:** QSPI or Slave Serial (dependent on FPGA).
- **Purpose:** Store FPGA bitstream.
- **Update:** Remote update via UART.

#### 9.5.2 SPI Flash / EEPROM
- **Part Number:** N/A (Standard SPI boot flash).
- **Purpose:** Storage for Si5345 register maps and ADC calibration tables.

### 9.6 ADC Control (SPI)
- **Target:** ADC12J4000 (U4).
- **Interface:** SPI (Mode 0, CPOL=0, CPHA=0).
- **Speed:** Max 20 MHz.
- **Functionality:** Programming NCO frequency for DDC, adjusting gain, setting test patterns.

### 9.7 Clock Generation Control (I2C)
- **Target:** Si5345 (U9).
- **Interface:** I2C (Standard mode, 100 kHz).
- **Address:** 0x68 (Default).
- **Functionality:** Programming output frequencies for ADC_CLK and DAC_CLK.

### 9.8 LED Status Indication
- **LED:** D2 (LTST-C170KRKT).
- **States:**
  - Solid ON: Power Good, Initialization Done.
  - 1Hz Blink: Data Transfer Active.
  - Fast Blink (4Hz): Fault detected.

### 9.9 Data Flow
1. RF Input (5-18 GHz) -> Mixer -> IF -> ADC.
2. ADC outputs 12-bit DDR data to FPGA J3.
3. FPGA de-serializes and buffers into Block RAM.
4. FPGA transmits processed packets via UART or High-speed link (Host).

---

## 10. Software Register Address Map

### 10.1 Register Base Addresses

| Block Name | Base Address | Address Range | Description |
|:---|:---:|:---:|:---|
| System / Identification | 0x0000 | 0x0000–0x00FF | Board ID, firmware version, status |
| UART Control | 0x0100 | 0x0100–0x01FF | Baud rate, FIFO control |
| SPI (ADC) Control | 0x0200 | 0x0200–0x02FF | SPI master for ADC12J4000 |
| I2C (CLK) Control | 0x0300 | 0x0300–0x03FF | I2C master for Si5345 |
| GPIO | 0x0400 | 0x0400–0x04FF | LED, Mode pins, Control |
| PLL / Clock Status | 0x0500 | 0x0500–0x05FF | Clock monitoring, LOS |
| ADC Interface | 0x0600 | 0x0600–0x06FF | ADC data format, overflow flags |
| Diagnostics | 0x0A00 | 0x0A00–0x0AFF | Fault log, uptime |

### 10.2 Detailed Register Map

**Block 0x0000 — System / Identification**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|:---:|:---|:---:|:---:|:---:|:---|
| 0x00 | BOARD_ID | 16 | R | 0xA101 | Board ID (Sample RF) |
| 0x01 | FW_VERSION | 16 | R | 0x0100 | Firmware Version 1.0 |
| 0x02 | SYS_STATUS | 16 | R | 0x0000 | [0] PWR_GOOD, [1] CLK_LOCKED, [2] ADC_READY, [15:3] Reserved |
| 0x03 | SYS_CTRL | 16 | R/W | 0x0000 | [0] SOFT_RESET, [1] LED_EN, [2] ADC_PD_N (Power Down) |

**Block 0x0100 — UART Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|:---:|:---|:---:|:---:|:---:|:---|
| 0x00 | BAUD_DIV | 16 | R/W | 0x0002 | Baud divisor (Clk/16/Baud) |
| 0x01 | UART_CTRL | 16 | R/W | 0x0001 | [0] TX_EN, [1] RX_EN, [2] PARITY_EN |
| 0x02 | UART_STATUS | 16 | R | 0x0000 | [0] TX_DONE, [1] RX_AVAIL, [2] OVERRUN |
| 0x03 | TX_DATA | 16 | W | 0x0000 | Data to transmit |
| 0x04 | RX_DATA | 16 | R | 0x0000 | Data received |

**Block 0x0200 — SPI (ADC) Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|:---:|:---|:---:|:---:|:---:|:---|
| 0x00 | SPI_DIV | 16 | R/W | 0x0004 | SCLK Divider |
| 0x01 | SPI_CTRL | 16 | R/W | 0x0000 | [0] CS_N, [1] START_XFER, [2] AUTO_CS |
| 0x02 | SPI_TX | 16 | W | 0x0000 | SPI Transmit Data |
| 0x03 | SPI_RX | 16 | R | 0x0000 | SPI Receive Data |
| 0x04 | SPI_STAT | 16 | R | 0x0000 | [0] BUSY, [1] DONE |

**Block 0x0300 — I2C (Si5345) Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|:---:|:---|:---:|:---:|:---:|:---|
| 0x00 | I2C_CLK_DIV | 16 | R/W | 0x0032 | SCL Divider (100kHz) |
| 0x01 | I2C_CTRL | 16 | R/W | 0x0000 | [0] START, [1] STOP, [2] ACK |
| 0x02 | I2C_TX | 16 | W | 0x0000 | Byte to transmit |
| 0x03 | I2C_RX | 16 | R | 0x0000 | Byte received |
| 0x04 | I2C_ADDR | 16 | R/W | 0x0068 | Si5345 Slave Address (7-bit << 1) |

**Block 0x0400 — GPIO**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|:---:|:---|:---:|:---:|:---:|:---|
| 0x00 | GPIO_OUT | 16 | R/W | 0x0000 | [0] LED_STATUS, [1] AMP_EN |
| 0x01 | GPIO_IN | 16 | R | 0x0000 | [0] LO_IN_PRESENT, [1] FPGA_PG |
| 0x02 | GPIO_DIR | 16 | R/W | 0x0001 | 0=Input, 1=Output |

**Block 0x0500 — PLL / Clock Status**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|:---:|:---|:---:|:---:|:---:|:---|
| 0x00 | CLK_STATUS | 16 | R | 0x0000 | [0] ADC_CLK_LOS, [1] DAC_CLK_LOS |
| 0x01 | CLK_COUNT | 16 | R | 0x0000 | Free running counter based on Ref Clk |

**Block 0x0600 — ADC Interface**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|:---:|:---|:---:|:---:|:---:|:---|
| 0x00 | ADC_CTRL | 16 | R/W | 0x0000 | [0] ADC_RESET, [1] DDC_EN, [2] FORMAT_SEL |
| 0x01 | ADC_STATUS | 16 | R | 0x0000 | [0] FIFO_FULL, [1] FIFO_EMPTY |

---

## 11. UART Register Protocol Specification

### 11.1 Physical Layer
- **Baud Rate:** 3,000,000 bps (Default)
- **Data Bits:** 8
- **Stop Bits:** 1
- **Parity:** None
- **Connector:** Header J5 (Pin 1, 3, 5, 7, 9) mapped to UART.

### 11.2 Command Frame Formats

**Single Register Write (CMD = 0x57 'W'):**
| Byte Index | Content | Description |
|:---:|:---|:---|
| 0 | 0x57 | Command Write |
| 1 | ADDR_H | Address High Byte |
| 2 | ADDR_L | Address Low Byte |
| 3 | DATA_H | Data High Byte |
| 4 | DATA_L | Data Low Byte |
→ **Response:** 0x06 (ACK) or 0x15 (NAK)

**Single Register Read (CMD = 0x52 'R'):**
| Byte Index | Content | Description |
|:---:|:---|:---|
| 0 | 0x52 | Command Read |
| 1 | ADDR_H \| 0x80 | Address High (R/W bit set) |
| 2 | ADDR_L | Address Low Byte |
→ **Response:** DATA_H, DATA_L

**Bulk Register Write (CMD = 0x42 'B'):**
| Byte Index | Content | Description |
|:---:|:---|:---|
| 0 | 0x42 | Command Bulk Write |
| 1 | ADDR_H | Start Address High |
| 2 | ADDR_L | Start Address Low |
| 3 | COUNT | Number of Registers (N) |
| 4... | DATA | 2*N Bytes (Data0_H, Data0_L, ...) |
→ **Response:** 0x06 (ACK)

**Bulk Register Read (CMD = 0x62 'b'):**
| Byte Index | Content | Description |
|:---:|:---|:---|
| 0 | 0x62 | Command Bulk Read |
| 1 | ADDR_H \| 0x80 | Start Address High |
| 2 | ADDR_L | Start Address Low |
| 3 | COUNT | Number of Registers (N) |
→ **Response:** 2*N Bytes of Data

### 11.3 Protocol Timing Constraints
| Parameter | Min | Max | Unit |
|:---|:---:|:---:|:---:|
| Inter-byte delay | - | 50 | ms |
| Response time | - | 10 | ms |

---

## 12. FPGA Resource Utilization Estimate

| Resource | Available | Estimated Usage | Utilization % |
|:---|:---:|:---:|:---:|
| Slice LUTs | 203,800 | 24,500 | 12% |
| Slice Flip-Flops | 407,200 | 15,000 | 3.6% |
| Block RAM (36Kb) | 445 | 40 | 9% |
| DSP Slices | 840 | 20 | 2.3% |
| MMCM/PLL | 10 | 2 | 20% |
| I/O Buffers | 500 | 80 | 16% |

**Synthesis Tool:** Vivado 2023.2
**Target Device:** XC7K325T-FFG900
**Primary Constraint:** 200 MHz processing clock for SPI/UART, 400 Mbps for ADC interface.

---

## Annexure A — Requirement Traceability Matrix

| S.No. | GLR-ID | Description | Source HRS Section | GLR Section | Verification Method | Status |
|:---:|:---|:---|:---|:---|:---|:---:|
| 1 | GLR-001 | RF Input Frequency Range | REQ-HW-001 | 4.0, 8.0 | Test | Open |
| 2 | GLR-002 | Baseband Digital Output (IQ) | REQ-HW-002 | 8.0 (J3) | Inspection | Open |
| 3 | GLR-003 | Power Supply Input (5-12V) | REQ-HW-008 | 4.0 | Test | Open |
| 4 | GLR-004 | Temp Range (-40 to +85) | REQ-HW-009 | 5.0 | Analysis | Open |
| 5 | GLR-005 | UART Interface | HRS §3 | 9.1, 11 | Test | Open |
| 6 | GLR-006 | ADC SPI Interface | HRS §3 | 9.6, 10.2 | Test | Open |
| 7 | GLR-007 | Clock Generator I2C | HRS §3 | 9.7, 10.2 | Test | Open |
| 8 | GLR-008 | Register Map Definition | HRS §3 | 10 | Inspection | Open |
| 9 | GLR-009 | Weight Constraint (<200g) | REQ-HW-010 | 4.0 | Inspection | Open |
| 10 | GLR-010 | RoHS Compliance | REQ-HW-013 | 2.1 | Inspection | Open |