
Here is the complete, detailed Glue Logic Requirements (GLR) document for the **dfbvd** Wideband RF Receiver Module.

---

# Glue Logic Requirements (GLR)

## Document Control
| Document Title | Glue Logic Requirements |
| :--- | :--- |
| Version Date | 16.04.2026 |
| Version Number | 0V01 |
| Prepared By | Name: . Sign: |
| Document Review By | Name: . Sign: |

---

## Amendments to the Document
| S. No. | Ver. No. | Ver. Date | Changed By | Section(s) Changed | Description of Change |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | 0V01 | 16.04.2026 | - | - | Initial Version |

---

## 1. Scope of the Document
This document explains the IO details and functional requirements of the FPGA for **dfbvd**. It serves as the bridge between the Schematic/Netlist and the FPGA RTL Design.
Targeted audience: Hardware Design and Firmware teams.

---

## 2. References

### 2.1 External
| Doc. Type | Part No. | Description |
| :--- | :--- | :--- |
| Datasheet | HMC1099LP4E | 5-18 GHz Wideband LNA |
| Datasheet | HMC1022LP4E | 6-18 GHz Double-Balanced Mixer |
| Datasheet | ADF5356CCPZ | Wideband Synthesizer with Integrated VCO |
| Datasheet | ADC12DJ3200AIRGZ | 12-Bit, 6.4 GSPS, Dual-Channel ADC |
| Datasheet | LMK04828BISKQ | Ultra-Low Noise JESD204B Clock Jitter Cleaner |
| Datasheet | ADL5202ACPZN | Digital Variable Gain Amplifier (DVGA) |
| Datasheet | MGA-615P | High Gain Driver Amplifier |
| Datasheet | 7A50P | FPGA (Artix-7 Family - Representative) |

### 2.2 Internal
| Reference | Document |
| :--- | :--- |
| [HRS] | Hardware Requirements Specification |
| [SCH] | Schematic |
| [GRS] | General Requirements Specification |
| [GDD] | General Design Document |
| [NET] | Logical Netlist |

---

## 3. Acronyms and Abbreviations
| Acronym | Expansion |
| :--- | :--- |
| **ADC** | Analog-to-Digital Converter |
| **AGC** | Automatic Gain Control |
| **BOM** | Bill of Materials |
| **CLB** | Configurable Logic Block |
| **CPLD** | Complex Programmable Logic Device |
| **DAC** | Digital-to-Analog Converter |
| **DSP** | Digital Signal Processing |
| **EMC** | Electromagnetic Compatibility |
| **ESD** | Electrostatic Discharge |
| **FPGA** | Field Programmable Gate Array |
| **FF** | Flip-Flop |
| **GND** | Ground |
| **HDL** | Hardware Description Language |
| **I2C** | Inter-Integrated Circuit |
| **IO** | Input/Output |
| **JTAG** | Joint Test Action Group |
| **JESD** | JESD204B High-Speed Data Interface |
| **LVDS** | Low Voltage Differential Signaling |
| **LUT** | Look-Up Table |
| **PCB** | Printed Circuit Board |
| **PLL** | Phase Locked Loop |
| **RoHS** | Restriction of Hazardous Substances |
| **RTL** | Register Transfer Level |
| **SFDR** | Spurious-Free Dynamic Range |
| **SMA** | SubMiniature version A (RF Connector) |
| **SNR** | Signal-to-Noise Ratio |
| **SPI** | Serial Peripheral Interface |
| **UART** | Universal Asynchronous Receiver/Transmitter |
| **VCC** | Voltage Common Collector (Supply) |
| **VGA** | Variable Gain Amplifier |

---

## 4. Module Overview

**RF SECTION:**
The RF chain amplifies the 5-18 GHz input signal using a wideband LNA (**U1 HMC1099LP4E**), followed by a downconverting mixer (**U2 HMC1022LP4E**) driven by an LO synthesizer (**U3 ADF5356**). The IF signal passes through a VGA (**U6 ADL5202**) before being digitized by the ADC (**U4 ADC12DJ3200**).

**DIGITAL SECTION:**
The central controller is an FPGA. It manages the system boot, configures the RF chips via SPI/I2C, reads ADC status, controls the VGA gain loop, and bridges the high-speed JESD204B data from the ADC to the backplane LVDS outputs. It also manages the JESD204B clock cleaner (**U5 LMK04828B**).

**POWER SUPPLY SECTION:**
The system operates from a +12V input. DC-DC converters generate the required rails:
*   **+3.3V_PLL**: Supplies ADF5356, LMK04828B.
*   **AVDD_1V8**: ADC analog supply (1.8V).
*   **DVDD_1V8**: ADC digital supply, FPGA IO.
*   **FPGA Core**: Derived from DC-DC (1.0V or 1.2V, typically managed by internal regulators or external PMIC).

---

## 5. Features
- **FPGA**: Xilinx Artix-7 (Representative 50T/100T speed grade -1)
- **On-board clock oscillator**: 10 MHz (TCXO reference on J1 input)
- **Communication**: UART (Control interface), SPI (PLL/VGA Config)
- **JTAG debugging support**: Standard 14-pin header (internal)
- **Configuration Flash**: SPI Flash (Target: 128Mb)
- **Temperature Monitoring**: Via I2C or internal FPGA XADC
- **Power monitoring**: ADC12DJ3200 internal monitoring via SPI
- **RF Control**: Digital VGA (ADL5202) with 8-bit parallel control; PLL (ADF5356) frequency tuning.
- **High Speed Interface**: JESD204B Class 1 (Capture from ADC) -> LVDS (Output to Backplane)

---

## 6. FPGA Description

**Selection Rationale:**
The FPGA must handle the initialization sequence of the sensitive RF chain, process configuration data via UART, and manage the SPI buses for the PLL and Clock Generator. It buffers the JESD204B lane data or passes it through to the LVDS backplane connectors.

**Specification:**

| S.NO | PARAMETERS | SPECIFICATION |
|:---|:---|:---|
| 1 | Part Number | XC7A50T-1FGG484C (Example) |
| 2 | Logic Cells | 52,000 |
| 3 | CLB Flip-Flops | 81,900 |
| 4 | Number of Gates | 800,000 |
| 5 | Maximum Distributed RAM (Kb) | 624 |
| 6 | Total Block RAM (Kb) | 2700 |
| 7 | Maximum Single-Ended I/Os | 285 |
| 8 | Maximum DSP Slices | 120 |
| 9 | No of IO Bank | 6 |

---

## 7. Block Diagram
(Refer to [GRS] Block Diagram). The FPGA sits centrally connected to:
1.  **Host/PC** via UART.
2.  **RF Front End** via SPI (PLL control) and Parallel GPIO (VGA control).
3.  **ADC** via 3-wire SPI and SYNC_N signals.
4.  **Clock Generator** via SPI.
5.  **Power Management** via GPIO enables.

---

## 8. Pinout Details

**Table: FPGA Pin Out Details**

| S.No | Signal Name | Pin No | Voltage Level | Direction wrt FPGA | Source | Destination | Default Condition | Voltage Standard |
|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| 1 | VDD_FPGA | - | 1.0V | Power In | PSU | FPGA Core | - | - |
| 2 | GND | - | 0V | Power In | PSU | FPGA | - | - |
| 3 | VCCO_34 | - | 1.8V | Power In | PSU | Bank 34 | - | - |
| 4 | EXT_CLK_P | A10 | 1.8V | Input | J1 | FPGA | High-Z | LVDS |
| 5 | EXT_CLK_M | B10 | 1.8V | Input | J1 | FPGA | High-Z | LVDS |
| 6 | FPGA_RESET_N | C15 | 1.8V | Input | System Reset | FPGA | Pull Up | LVCMOS18 |
| 7 | UART_TX | D20 | 1.8V | Output | FPGA | USB-UART | High | LVCMOS18 |
| 8 | UART_RX | E20 | 1.8V | Input | USB-UART | FPGA | High-Z | LVCMOS18 |
| 9 | SPI_SCLK_PLL | F5 | 1.8V | Output | FPGA | ADF5356 (CLK) | Low | LVCMOS18 |
| 10 | SPI_MOSI_PLL | G6 | 1.8V | Output | FPGA | ADF5356 (DATA) | Low | LVCMOS18 |
| 11 | SPI_MISO_PLL | H7 | 1.8V | Input | ADF5356 (MUXOUT) | FPGA | High-Z | LVCMOS18 |
| 12 | CS_PLL_N | J8 | 1.8V | Output | FPGA | ADF5356 (LE/CS) | High | LVCMOS18 |
| 13 | SDIO_ADC | K10 | 1.8V | Bi-Dir | FPGA | ADC12DJ3200 | Pull Up | LVCMOS18 |
| 14 | SCLK_ADC | L11 | 1.8V | Output | FPGA | ADC12DJ3200 | Low | LVCMOS18 |
| 15 | CS_ADC_N | M12 | 1.8V | Output | FPGA | ADC12DJ3200 | High | LVCMOS18 |
| 16 | RESET_ADC_N | N13 | 1.8V | Output | FPGA | ADC12DJ3200 | High | LVCMOS18 |
| 17 | SPI_CLK_CLKGEN | P15 | 1.8V | Output | FPGA | LMK04828B | Low | LVCMOS18 |
| 18 | SPI_MOSI_CLKGEN | R16 | 1.8V | Output | FPGA | LMK04828B | Low | LVCMOS18 |
| 19 | SPI_MISO_CLKGEN | T17 | 1.8V | Input | LMK04828B | FPGA | High-Z | LVCMOS18 |
| 20 | CS_CLKGEN_N | U18 | 1.8V | Output | FPGA | LMK04828B | High | LVCMOS18 |
| 21 | GPIO_VGA_BIT0 | A1 | 1.8V | Output | FPGA | ADL5202 | Low | LVCMOS18 |
| 22 | GPIO_VGA_BIT1 | B2 | 1.8V | Output | FPGA | ADL5202 | Low | LVCMOS18 |
| 23 | GPIO_VGA_BIT2 | C3 | 1.8V | Output | FPGA | ADL5202 | Low | LVCMOS18 |
| 24 | GPIO_VGA_BIT3 | D4 | 1.8V | Output | FPGA | ADL5202 | Low | LVCMOS18 |
| 25 | GPIO_VGA_BIT4 | E5 | 1.8V | Output | FPGA | ADL5202 | Low | LVCMOS18 |
| 26 | GPIO_VGA_BIT5 | F6 | 1.8V | Output | FPGA | ADL5202 | Low | LVCMOS18 |
| 27 | GPIO_VGA_BIT6 | G7 | 1.8V | Output | FPGA | ADL5202 | Low | LVCMOS18 |
| 28 | GPIO_VGA_BIT7 | H8 | 1.8V | Output | FPGA | ADL5202 | Low | LVCMOS18 |
| 29 | VGA_EN | J9 | 1.8V | Output | FPGA | ADL5202 | Low | LVCMOS18 |
| 30 | LNA_EN | K1 | 3.3V | Output | FPGA | RF Switch/LNA | High (ON) | LVCMOS33 |
| 31 | ADC_SYNC_N | L2 | 1.8V | Output | FPGA | ADC12DJ3200 | High | LVCMOS18 |
| 32 | LED_STATUS | M1 | 1.8V | Output | FPGA | LED | Low (OFF) | LVCMOS18 |
| 33 | TCK | N1 | 1.8V | Input | JTAG | FPGA | High-Z | LVCMOS18 |
| 34 | TDI | P2 | 1.8V | Input | JTAG | FPGA | High-Z | LVCMOS18 |
| 35 | TDO | R3 | 1.8V | Output | FPGA | JTAG | High-Z | LVCMOS18 |
| 36 | TMS | T4 | 1.8V | Input | JTAG | FPGA | High-Z | LVCMOS18 |

---

## 9. Functional Specifications

| S.No. | Function Name | Description |
|:---|:---|:---|
| 1 | Serial Communication Interface | UART between PC & FPGA for control/status |
| 2 | RF Component Control | SPI configuration of ADF5356 (PLL) and LMK04828B (Clock Gen) |
| 3 | VGA Gain Control | 8-bit parallel interface to ADL5202 for IF gain control |
| 4 | ADC Interface | 3-wire SPI configuration and SYNC signal generation for ADC12DJ3200 |
| 5 | Power Sequencing | Control of LNA_EN and regulator enables |
| 6 | System Health | Temperature monitoring via FPGA XADC |
| 7 | High-Speed Data Path | JESD204B subclass 1 capture (if applicable) or pass-through clocking |

### 9.1 Serial Communication Interface
- **Interface type:** UART
- **Physical layer:** TTL (1.8V logic) -> Translated to RS-232/USB off-board
- **Baud rate:** 115200 bps (Standard), 921600 bps (High Speed config)
- **Frame format:** 1 start bit, 8 data bits, 1 stop bit, no parity
- **Protocol:** Custom register-based command/response (see Section 11)
- **Signals:** UART_TX (FPGA -> PC), UART_RX (PC -> FPGA)

### 9.2 High Speed Communication Interface
- **Interface:** JESD204B (Subclass 1)
- **Lanes:** 2 Lanes (ADC outputs)
- **Data rate:** 12 Gbps per lane (configurable)
- **Protocol:** FPGA acts as JESD204B Receiver (Link Layer). The FPGA forwards or buffers this data. *Note: For this glue logic spec, the FPGA manages the SYNC_N signal and device initialization.*

### 9.3 Power On/Off Sequence
#### 9.3.1 Power ON/OFF Sequence
1.  +12V applied.
2.  FPGA voltages settle. Internal POR released.
3.  FPGA initializes GPIO (LNA_EN = Low, VGA_EN = Low).
4.  FPGA configures LMK04828B (Clock Gen) -> Outputs stable clocks.
5.  FPGA configures ADF5356 (PLL) -> Lock detect achieved (checked via SPI MUXOUT).
6.  FPGA asserts ADC_RESET_N (High) and configures ADC.
7.  FPGA asserts VGA_EN.
8.  FPGA asserts LNA_EN (RF Enable).
9.  System Ready.

#### 9.3.2 Mode Configuration
| Mode | Signal | Value | Description |
|:---|:---|:---|:---|
| Shutdown | LNA_EN | 0 | RF path disabled, power save |
| RX Active | LNA_EN | 1 | RF path enabled |

### 9.4 Supply Voltage, Current & Temperature Monitoring
#### 9.4.1 Supply Voltage and Current Monitoring
- **Method:** Reading internal ADC registers of ADC12DJ3200.
- **Interface:** SPI (via SDIO/SCLK pins).
- **Rails Monitored:** ADC AVDD, ADC DVDD (internal to ADC).
- **External:** FPGA monitors 1.8V rail via XADC.

#### 9.4.2 Temperature Monitoring
- **Method:** FPGA Internal XADC (Device Temp) and internal ADC die temp.
- **Range:** -40 to +85 °C.
- **Alert:** Threshold register in FPGA map.

### 9.5 Flash & Interfaces
#### 9.5.1 Configuration Flash
- **Interface:** SPI (x1 or x4).
- **Part:** External SPI Flash (Connected to FPGA dedicated pins).
- **Purpose:** Stores FPGA bitstream.

#### 9.5.2 User Data Storage
- **Interface:** None onboard in netlist. All config is volatile or loaded via UART.

### 9.6 RF Configuration
- **Components:** ADF5356 (PLL), LMK04828B (JESD Clock), ADL5202 (VGA).
- **Control:** FPGA acts as SPI Master.
- **Initialization Sequence:** LMK -> ADF5356 -> ADC.

### 9.7 VGA (Variable Gain Amplifier) Control
- **Part:** ADL5202.
- **Interface:** 8-bit Parallel bus (GPIO_VGA_BIT[7:0]) + 1 Enable (VGA_EN).
- **Gain Mapping:** 0dB to 26dB range.
- **Update Rate:** Instantaneous upon GPIO write.

### 9.8 ADC Interface
- **Part:** ADC12DJ3200AIRGZ.
- **Control SPI:** 4-wire (CS, SCLK, SDIO Bi-dir).
- **Sync:** SYNC_N signal for deterministic latency (Subclass 1).
- **Configuration:** Sample rate, JESD204B lane config, test patterns.

### 9.9 Remote Programming
- **Protocol:** UART.
- **Method:** FPGA bitstream update via Slave Serial or SelectMAP triggered by UART command (writing to specific register address in range 0x09xx).

---

## 10. Software Register Address Map

### 10.1 Register Base Addresses

| Block Name | Base Address | Address Range | Description |
|:---|:---|:---|:---|
| System / Identification | 0x0000 | 0x0000–0x00FF | Board ID, firmware version, status |
| UART Control | 0x0100 | 0x0100–0x01FF | Baud rate, FIFO control, status |
| PLL Control (ADF5356) | 0x0200 | 0x0200–0x02FF | Shadow registers for PLL Config |
| Clock Gen (LMK04828) | 0x0300 | 0x0300–0x03FF | Shadow registers for CLKGEN |
| ADC Control (ADC12DJ) | 0x0400 | 0x0400–0x04FF | ADC SPI control, Gain Config |
| GPIO / VGA | 0x0500 | 0x0500–0x05FF | Parallel VGA port control, LNA_EN |
| Diagnostics / XADC | 0x0600 | 0x0600–0x06FF | Temp, Voltage readings |

### 10.2 Detailed Register Map

**Block 0x0000 — System / Identification**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|:---|:---|:---|:---|:---|:---|
| 0x00 | BOARD_ID | 16 | R | 0xDFB0 | Board identification code (Hex: DFB0) |
| 0x01 | FW_VERSION | 16 | R | 0x0001 | Firmware version (Major.Minor) |
| 0x02 | SYS_STATUS | 16 | R | 0x0000 | [0] PLL_LOCK, [1] CLKGEN_LOCK, [2] ADC_CAL_DONE, [3] RDY |
| 0x03 | SYS_CTRL | 16 | R/W | 0x0000 | [0] SOFT_RESET, [1] RF_ENABLE (LNA_EN) |

**Block 0x0100 — UART Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|:---|:---|:---|:---|:---|:---|
| 0x00 | BAUD_DIV | 16 | R/W | 0x0026 | Baud rate divisor (for 100MHz clk) |
| 0x01 | UART_CTRL | 16 | R/W | 0x0001 | [0] UART_ENABLE, [1] LOOPBACK_EN |
| 0x02 | UART_STATUS | 16 | R | 0x0000 | [0] TX_BUSY, [1] RX_AVAIL, [2] RX_OVERRUN |

**Block 0x0200 — PLL Control (ADF5356)**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|:---|:---|:---|:---|:---|:---|
| 0x00 | PLL_REG_0 | 32 | W | 0x00000000 | Shadow for ADF5356 Reg 0 (Int, Frac) |
| ... | ... | ... | ... | ... | ... (Shadow regs 0-12) |
| 0x10 | PLL_WR_EN | 8 | W | 0x00 | Write 1 to push shadow regs to PLL SPI |
| 0x11 | PLL_LOCK_RAW | 8 | R | 0x00 | Read MUXOUT status directly |

**Block 0x0400 — ADC Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|:---|:---|:---|:---|:---|:---|
| 0x00 | ADC_GAIN_IDX | 16 | R/W | 0x0000 | 8-bit parallel gain value (0-255) |
| 0x01 | ADC_CFG_BANK | 8 | W | 0x00 | Selects SPI register bank for next write |
| 0x02 | ADC_CFG_DATA | 16 | W | 0x0000 | Data to write to selected register |
| 0x03 | ADC_CFG_TRIG | 8 | W | 0x00 | Write 1 to trigger SPI transaction to ADC |
| 0x04 | ADC_SYNC_PULSE | 8 | W | 0x00 | Toggle to generate SYNC_N pulse |

**Block 0x0500 — GPIO / VGA**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|:---|:---|:---|:---|:---|:---|
| 0x00 | VGA_PARALLEL | 8 | R/W | 0x00 | Direct control of ADL5202 [7:0] |
| 0x01 | RF_CTRL | 8 | R/W | 0x00 | [0] LNA_EN, [1] VGA_EN |

**Block 0x0600 — Diagnostics (XADC)**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|:---|:---|:---|:---|:---|:---|
| 0x00 | FPGA_TEMP | 16 | R | Variable | FPGA Die Temp (Signed Celsius) |
| 0x01 | VCCINT_1V0 | 16 | R | Variable | Core Voltage (mV) |
| 0x02 | VCCAUX_1V8 | 16 | R | Variable | Aux Voltage (mV) |

---

## 11. UART Register Protocol Specification

### 11.1 Physical Layer
- **Baud rate:** 115200 bps (Default)
- **Frame format:** 1 start bit, 8 data bits, 1 stop bit, no parity (8N1)
- **Physical interface:** 1.8V CMOS (Translated to USB/RS232 off-board)

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

**Error Response:**
```
0x15 (NAK) — sent by FPGA when:
  - CMD byte not recognized
  - Address out of valid range
  - Write to read-only register
  - Parser timeout (inter-byte gap > 50ms)
```

### 11.3 Protocol Timing Constraints
| Parameter | Min | Typical | Max | Unit |
|:---|:---|:---|:---|:---|
| Inter-byte gap (TX side) | - | - | 50 | ms |
| Single Write response time | - | 0.5 | 1 | ms |
| Single Read response time | - | 1 | 2 | ms |

### 11.4 Software Implementation Notes
```c
// Firmware register write wrapper
#define FPGA_WRITE(addr, data)    UART_WriteReg((uint16_t)(addr), (uint16_t)(data))
// Firmware register read wrapper
#define FPGA_READ(addr, pdata)    UART_ReadReg((uint16_t)(addr) | 0x8000U, (pdata))

// Block Base Addresses
#define REG_SYS_BASE    (0x0000U)
#define REG_UART_BASE   (0x0100U)
#define REG_PLL_BASE    (0x0200U)
#define REG_CLKGEN_BASE (0x0300U)
#define REG_ADC_BASE    (0x0400U)
#define REG_GPIO_BASE   (0x0500U)
#define REG_DIAG_BASE   (0x0600U)
```

---

## 12. FPGA Resource Utilization Estimate

| Resource | Available (XC7A50T) | Estimated Usage | Utilization % |
|:---|:---|:---|:---|
| Slice LUTs | 20,800 | 6,500 | 31% |
| Slice Flip-Flops | 41,600 | 8,200 | 19% |
| Block RAM (36Kb) | 75 | 10 | 13% |
| DSP Slices | 120 | 4 | 3% |
| MMCM/PLL | 6 | 2 | 33% |
| I/O Buffers | 200 | 45 | 22% |

**Synthesis tool:** Vivado 2025.1
**Target device:** XC7A50T-1FGG484C
**Timing constraint:** Primary Clock (200 MHz), User Clock (50 MHz)

---

## Annexure A — Requirement Traceability Matrix

| S.No. | GLR-ID | Description | Source HRS Section | GLR Section | Verification Method | Status |
|:---|:---|:---|:---|:---|:---|:---|
| 1 | GLR-001 | Serial Communication Interface | HRS §3.3 | 9.1, 11 | Test | Open |
| 2 | GLR-002 | High Speed Communication (JESD) | HRS §3.3 | 9.2, 9.8 | Test | Open |
| 3 | GLR-003 | Power Supply Sequencing | HRS §3.1 | 9.3 | Test | Open |
| 4 | GLR-004 | Voltage/Temperature Monitoring | HRS §3.1 | 9.4 | Test | Open |
| 5 | GLR-005 | RF Component Control | HRS §3.1 | 9.6, 10 | Test | Open |
| 6 | GLR-006 | VGA Control (Gain) | HRS §3.1 (REQ-HW-013) | 9.7, 10 | Test | Open |
| 7 | GLR-007 | Register Address Map | HRS §3.3 | 10 | Inspection | Open |
| 8 | GLR-008 | UART Protocol Specification | HRS §3.3 | 11 | Test | Open |
| 9 | GLR-009 | FPGA Resource Budget | HRS §3.5 | 12 | Analysis | Open |
| 10 | GLR-010 | RF Frequency Range Support | HRS §2 (5-18GHz) | 4, 9.6 | Test | Open |