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
This document explains the IO details and functional requirements of the FPGA for **khv**.
The khv project is a Wideband RF Receiver (5-18 GHz) utilizing direct digitization via a high-speed ADC (EV12AQ600). The FPGA acts as the high-speed data capture and interface control device, managing the LVDS data link, configuring the RF Front End (LNA/VGA), Clock Synthesizer, and monitoring system health.
Targeted audience: Hardware Design and Firmware teams.

---

## 2. References

### 2.1 External
| Doc. Type | Part No. | Description |
|---|---|---|
| Datasheet | HMC698LP4ETR | 5-20 GHz GaAs MMIC LNA/VGA |
| Datasheet | EV12AQ600 | Quad-channel 12-bit ADC, up to 6.4 GSPS |
| Datasheet | LMK04828BLLPT | Dual-PLL Clock Jitter Cleaner |
| Datasheet | BP5G18G+ | 5-18 GHz Bandpass Filter |
| Datasheet | LTM4644IY | Quad Output High Efficiency DC-DC Regulator |
| Standard | JESD204B | Standard for high-speed data interface |
| Standard | MIL-STD-202 | Test method standard for electronic components |

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
| BGA | Ball Grid Array |
| CLB | Configurable Logic Block |
| CML | Current Mode Logic |
| DAC | Digital-to-Analog Converter (if applicable) |
| DMA | Direct Memory Access |
| DSP | Digital Signal Processing |
| EMC | Electromagnetic Compatibility |
| FF | Flip-Flop |
| FPGA | Field-Programmable Gate Array |
| GND | Ground |
| GPIO | General Purpose Input/Output |
| GSPS | Giga-Samples Per Second |
| HDL | Hardware Description Language |
| I2C | Inter-Integrated Circuit |
| IIP3 | Third-order Intercept Point (Input) |
| IO | Input/Output |
| JTAG | Joint Test Action Group |
| LVDS | Low-Voltage Differential Signaling |
| LUT | Look-Up Table |
| PCB | Printed Circuit Board |
| PLL | Phase-Locked Loop |
| RoHS | Restriction of Hazardous Substances |
| RTL | Register Transfer Level |
| SFDR | Spurious Free Dynamic Range |
| SMA | SubMiniature version A (RF Connector) |
| SPI | Serial Peripheral Interface |
| UART | Universal Asynchronous Receiver-Transmitter |
| VCC | Voltage Common Collector (Supply) |
| VHDL | VHSIC Hardware Description Language |

---

## 4. Module Overview

**RF SECTION:**
The RF chain amplifies and filters signals from 5 GHz to 18 GHz.
- **LNA/VGA**: **HMC698LP4ETR** (Analog Devices). Provides 24 dB gain and variable gain control.
- **Filter**: **BP5G18G+** (Mini-Circuits). Bandpass filter limiting out-of-band noise.
- **RF Input**: Dual SMA edge mount connectors (J1, J2).

**DIGITAL SECTION:**
The digital core performs signal capture and system control.
- **ADC**: **EV12AQ600** (Teledyne e2v). 12-bit, up to 6.4 GSPS. Outputs data via JESD204B-like LVDS lanes.
- **Clock Synthesizer**: **LMK04828BLLPT** (Texas Instruments). Generates ultra-low jitter clocks for ADC and FPGA.
- **FPGA Role**: Deserializes high-speed LVDS data, configures LNA gain (via SPI), programs Clock Synthesizer (via SPI), and manages power sequencing.

**POWER SUPPLY SECTION:**
- **Input**: 12V DC.
- **Regulator**: **LTM4644IY**. Quad-output DC-DC converter.
- **Rails**: 5.0V (LNA), 3.3V (FPGA IO/Clock), 1.8V (FPGA Aux), 1.0V (FPGA Core).

---

## 5. Features
- **FPGA**: Xilinx Kintex UltraScale+ XQKU5P-FFVB676 (Assumed based on I/O requirements and speed)
- **ADC**: EV12AQ600 (12-bit, 5-10 GSPS)
- **Clock Oscillator**: LMK04828 Synthesizer (<100fs jitter)
- **Communication**:
  - UART (RS422/RS232) for control console (115200 bps default)
  - SPI Master for LNA and Clock Synthesizer configuration
- **JTAG**: IEEE 1149.1 compliant debugging support
- **Power**: Integrated sequencing monitor via LTM4644 PG signals
- **Temperature Monitoring**: On-die FPGA sensor (XADC) and external sensor via I2C
- **Interface**: High-Speed LVDS (JESD204B) to ADC

---

## 6. FPGA Description
The **XQKU5P-FFVB676** is selected to meet the high-speed LVDS interface requirements (SERDES) and logic density needed for high-throughput data handling and processing. It is automotive/industrial grade to support the wider temperature range requirements better than commercial grade.

| S.NO | PARAMETERS | SPECIFICATION |
|------|-----------|---------------|
| 1 | Part Number | XQKU5P-FFVB676-1I |
| 2 | Logic Cells | 284,720 |
| 3 | CLB Flip-Flops | 1,139,000 |
| 4 | Number of Gates | ~7.8M (ASIC equiv) |
| 5 | Maximum Distributed RAM (Kb) | 1,734 |
| 6 | Total Block RAM (Kb) | 18,624 |
| 7 | Maximum Single-Ended I/Os | 520 (Package limited) |
| 8 | Maximum DSP Slices | 2,460 |
| 9 | No of IO Bank | 6 (High Performance Banks) |

---

## 7. Block Diagram
*(Textual Description of Mermaid Flowchart)*
The RF Input (SMA) enters the HMC698LP4 LNA. The output passes through the BP5G18G+ Filter into the EV12AQ600 ADC.
The LMK04828 Clock Gen receives a reference input and drives the ADC CLK_IN and the FPGA reference clock.
The FPGA interfaces to:
1. **ADC**: Via 12-bit LVDS Data Bus (D0-D11 diff) and Frame/CLK lines.
2. **Control**: SPI connection to HMC698 (Gain) and LMK04828 (Config).
3. **Host**: UART for commands.
Power (LTM4644) feeds all rails.

---

## 8. Pinout Details

**Table: FPGA Pin Out Details**

| S.No | Signal Name | Pin No (BGA) | Voltage Level | Direction wrt FPGA | Source | Destination | Default Condition | Voltage Standard |
|---|---|---|---|---|---|---|---|---|
| **Power** | | | | | | | | |
| 1 | VCCINT_1V0 | - | 1.0V | PWR | PMIC | FPGA Core | - | - |
| 2 | VCCAUX_1V8 | - | 1.8V | PWR | PMIC | FPGA Aux | - | - |
| 3 | VCCO_34_3V3 | - | 3.3V | PWR | PMIC | Bank 34 | - | - |
| **Clock** | | | | | | | | |
| 4 | FPGA_CLK_125M | E12 | 1.8V/3.3V | IN | LMK04828 | Sys Logic | HIGH | LVCMOS18 |
| 5 | LVDS_CLK_P | AC12 | 1.8V | IN | EV12AQ600 | SERDES | HIGH | LVDS_18 |
| 6 | LVDS_CLK_N | AD12 | 1.8V | IN | EV12AQ600 | SERDES | HIGH | LVDS_18 |
| **JTAG** | | | | | | | | |
| 7 | TCK | Y1 | 1.8V | IN | Debugger | JTAG TAP | Pull Down | LVCMOS18 |
| 8 | TDI | Y2 | 1.8V | IN | Debugger | JTAG TAP | Pull Down | LVCMOS18 |
| 9 | TDO | Y3 | 1.8V | OUT | JTAG TAP | Debugger | Low | LVCMOS18 |
| 10 | TMS | Y4 | 1.8V | IN | Debugger | JTAG TAP | Pull Up | LVCMOS18 |
| **Reset** | | | | | | | | |
| 11 | FPGA_RESET_N | A5 | 1.8V | IN | PMIC/ResetCkt | System Logic | HIGH | LVCMOS18 |
| 12 | POR_N | B5 | 1.8V | IN | PMIC | FPGA Global | HIGH | LVCMOS18 |
| **UART/Serial** | | | | | | | | |
| 13 | UART_TX | F10 | 3.3V | OUT | FPGA | USB-UART | HIGH | LVCMOS33 |
| 14 | UART_RX | G11 | 3.3V | IN | USB-UART | FPGA | HIGH | LVCMOS33 |
| 15 | UART_RTS | H12 | 3.3V | OUT | FPGA | USB-UART | LOW | LVCMOS33 |
| 16 | UART_CTS | J12 | 3.3V | IN | USB-UART | FPGA | HIGH | LVCMOS33 |
| **SPI (LNA - HMC698)** | | | | | | | | |
| 17 | SPI_SCK_LNA | K15 | 3.3V | OUT | FPGA | HMC698LP4 | LOW | LVCMOS33 |
| 18 | SPI_MOSI_LNA | L16 | 3.3V | OUT | FPGA | HMC698LP4 | LOW | LVCMOS33 |
| 19 | SPI_MISO_LNA | M15 | 3.3V | IN | HMC698LP4 | FPGA | HIGH | LVCMOS33 |
| 20 | SPI_CS_LNA_N | M16 | 3.3V | OUT | FPGA | HMC698LP4 | HIGH | LVCMOS33 |
| **SPI (Clock Gen - LMK04828)** | | | | | | | | |
| 21 | SPI_SCK_CLK | N15 | 3.3V | OUT | FPGA | LMK04828 | LOW | LVCMOS33 |
| 22 | SPI_MOSI_CLK | P16 | 3.3V | OUT | FPGA | LMK04828 | LOW | LVCMOS33 |
| 23 | SPI_MISO_CLK | P15 | 3.3V | IN | LMK04828 | FPGA | HIGH | LVCMOS33 |
| 24 | SPI_CS_CLK_N | R16 | 3.3V | OUT | FPGA | LMK04828 | HIGH | LVCMOS33 |
| **I2C (Sensors/EEPROM)** | | | | | | | | |
| 25 | I2C_SCL | T10 | 3.3V | BiDir | FPGA | Temp/EEPROM | HIGH (OD) | LVCMOS33 |
| 26 | I2C_SDA | U11 | 3.3V | BiDir | FPGA | Temp/EEPROM | HIGH (OD) | LVCMOS33 |
| **GPIO / Control** | | | | | | | | |
| 27 | LED_STATUS | V12 | 3.3V | OUT | FPGA | LED | LOW | LVCMOS33 |
| 28 | LED_ERROR | W13 | 3.3V | OUT | FPGA | LED | LOW | LVCMOS33 |
| 29 | FPGA_DONE | - | 3.3V | OUT | FPGA Internal | Monitor | LOW | LVCMOS33 |
| 30 | TRP_OUT | Y14 | 3.3V | OUT | FPGA | LNA EN | HIGH | LVCMOS33 |
| **RF Control (Specifics)** | | | | | | | | |
| 31 | VGA_GAIN_0 | AA1 | 3.3V | OUT | FPGA | HMC698 | Low | LVCMOS33 |
| 32 | VGA_GAIN_1 | AB2 | 3.3V | OUT | FPGA | HMC698 | Low | LVCMOS33 |
| **High Speed LVDS (ADC Data)** | | | | | | | | |
| 33 | ADC_D0_P | A1 | 1.8V | IN | EV12AQ600 | SERDES | HIGH | DIFF_HSTL18 |
| 34 | ADC_D0_N | B2 | 1.8V | IN | EV12AQ600 | SERDES | HIGH | DIFF_HSTL18 |
| 35 | ADC_D1_P | C3 | 1.8V | IN | EV12AQ600 | SERDES | HIGH | DIFF_HSTL18 |
| 36 | ADC_D1_N | D4 | 1.8V | IN | EV12AQ600 | SERDES | HIGH | DIFF_HSTL18 |
| 37 | ADC_FRAME_P | E5 | 1.8V | IN | EV12AQ600 | SERDES | HIGH | DIFF_HSTL18 |
| 38 | ADC_FRAME_N | F6 | 1.8V | IN | EV12AQ600 | SERDES | HIGH | DIFF_HSTL18 |

---

## 9. Functional Specifications

**Summary table first:**

| S.No. | Function Name | Description |
|---|---|---|
| 1 | Serial Communication Interface | UART between PC & FPGA for register access and control. |
| 2 | High Speed Data Capture | LVDS JESD204B interface to capture 6.4 GSPS ADC data. |
| 3 | Power Supply Sequencing & Health | Monitors 12V->1V rails and enables RF Power Amplifier/LNA only when stable. |
| 4 | Temperature & Voltage Monitoring | I2C monitoring of internal FPGA XADC and external EEPROM. |
| 5 | RF Front End Control | SPI configuration of HMC698LP4 VGA and Gain settings. |
| 6 | Clock Synthesizer Control | SPI configuration of LMK04828 for frequency/phase tuning. |
| 7 | TRP Configuration | Transmit/Receive Pulse control for timing synchronization. |
| 8 | FPGA Remote Programming | Configuration bitstream update via UART. |
| 9 | Beam/Data Processing | Basic decimation and data forwarding logic. |

Then provide DETAILED subsections:

### 9.1 Serial Communication Interface
- Interface type: UART
- Physical layer: RS-422 (Differential) for noise immunity.
- Baud rate: Configurable, default 115200 bps (up to 921600 bps).
- Frame format: 1 start bit, 8 data bits, 1 stop bit, no parity (8N1).
- USB-UART converter IC: FT2232H (On Host Board).
- Signals: UART_TX (FPGA → PC), UART_RX (PC → FPGA).
- Protocol: Custom register-based command/response (See Section 11).

### 9.2 High Speed Communication Interface
- Interface: JESD204B Subclass 1 (Compatible).
- Number of lanes: 1 Lane (configured for high sample rate).
- Data rate per lane: 6.4 Gbps (configurable).
- Protocol: JESD204B Frame format (F=2, K=16, M=1).
- Physical: AC-coupled LVDS (1.8V CML).

### 9.3 Power On/Off Sequence
#### 9.3.1 Power ON/OFF Sequence
1. Input supply (+12V) detected.
2. LTM4644 enables 1.0V Core Rail. FPGA monitors POR_N.
3. Once 1.0V stable, 1.8V and 3.3V rails enabled.
4. FPGA initiates configuration from SPI Flash.
5. FPGA Done pin goes High. Firmware initializes SPI peripherals.
6. Firmware reads Power Good status.
7. **TRP_OUT** signal asserted HIGH to enable HMC698 LNA.
8. System READY status set.

#### 9.3.2 Mode Configuration
| Mode | Signal | Value | Description |
|---|---|---|---|
| Normal | MODE[1:0] | 2'b00 | Full Rate Acquisition (6.4 GSPS) |
| Decimated | MODE[1:0] | 2'b01 | DDC Decimation mode enabled |
| Programming | MODE[1:0] | 2'b10 | FPGA Remote Update mode |

### 9.4 Supply Voltage, Current & Temperature Monitoring
#### 9.4.1 Supply Voltage and Current Monitoring
- IC Part Number: LTC2992 (Assumed from BOM "Power Monitoring").
- Interface: I2C at Address 0x6F.
- Monitored rails: 12V Input, 5V LNA, 3.3V IO, 1.0V Core.
- Measurement range: 0 to 20V, 0 to 5A.
- Resolution: 10mV / 1mA.

#### 9.4.2 Temperature Monitoring
- IC Part Number: AD7416 (On Board).
- Interface: I2C at Address 0x48.
- FPGA XADC: Internal monitoring.
- Temperature range: -55 to +125 °C.
- Resolution: 0.25°C.
- Alert threshold: > 110°C.

### 9.5 Flash & Interfaces
#### 9.5.1 Configuration Flash
- Part Number: MT25QU01G (Assumed Standard).
- Interface: QSPI (x4).
- Capacity: 1 Gb (128 MB).
- Purpose: Stores FPGA bitstream.
- Programming: Via USB-UART (Secondary Bootloader).

#### 9.5.2 Storage Flash (User Flash)
- Part Number: Same IC or partitioned.
- Purpose: Stores LUTs for VGA Gain curves and Calibration data.

### 9.6 TRP Configuration
- Signal: TRP_OUT (FPGA → HMC698).
- Logic level: 3.3V LVTTL.
- Active state: HIGH = RF Chain Enabled.
- Timing: Minimum 10 µs delay from Power Good to TRP High.

### 9.7 FPGA Remote Programming
- Protocol: UART at 115200 bps.
- Tool: Vendor GUI / OpenOCD.
- Procedure:
  1. Host sends 0x55 AA Sync sequence.
  2. FPGA erases Flash sector.
  3. Bitstream transferred in 256-byte packets.
  4. CRC-32 check performed.
  5. Warm reset applied to load new image.

### 9.8 Phase Shifter / Gain Controlling
- Target: HMC698LP4 (VGA).
- Control basis: Desired Gain (dB).
- Interface: SPI (CLK, MOSI, MISO, CS_LNA_N).
- Gain resolution: 0.5 dB (internal 6-bit control).
- Update rate: Up to 10 MHz SPI clock.

### 9.9 Beam Steering Calculation
- Note: For this receiver module, "beam steering" refers to the downstream system, but this FPGA calculates local timestamps and aligns data frames.
- Algorithm: Frame alignment based on JESD204B ILAS.

### 9.10 Gate Voltage Writing / Bias Control
- Control: HMC698 operates from 5V.
- Interface: GPIO or DAC (if external).
- Here: Fixed 5V Rail enable via GPIO "TRP_OUT" controls the RF bias path.

---

## 10. Software Register Address Map

This section is CRITICAL for firmware development — it defines the complete FPGA register address space as seen by the software.

### 10.1 Register Base Addresses

| Block Name | Base Address | Address Range | Description |
|---|---|---|---|
| System / Identification | 0x0000 | 0x0000–0x00FF | Board ID, firmware version, status |
| UART Control | 0x0100 | 0x0100–0x01FF | Baud rate, FIFO control |
| SPI (LNA) Control | 0x0200 | 0x0200–0x02FF | SPI Master for HMC698 |
| SPI (CLK) Control | 0x0300 | 0x0300–0x03FF | SPI Master for LMK04828 |
| GPIO / TRP | 0x0400 | 0x0400–0x04FF | LNA Enable, LEDs |
| I2C Control | 0x0500 | 0x0500–0x05FF | I2C Master for Temp/EEPROM |
| ADC Data Interface | 0x0600 | 0x0600–0x06FF | JESD204B Link Status |
| Power Monitor | 0x0700 | 0x0700–0x07FF | Voltage/Current readings |
| RF / LNA Config | 0x0800 | 0x0800–0x08FF | Gain Setpoints, LUT access |
| Flash / EEPROM | 0x0900 | 0x0900–0x09FF | Flash interface regs |
| Diagnostics | 0x0A00 | 0x0A00–0x0AFF | Fault log, uptime |

### 10.2 Detailed Register Map

**Block 0x0000 — System / Identification**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|---|---|---|---|---|---|
| 0x00 | BOARD_ID | 16 | R | 0x4B48 | 'KH' ASCII (Project ID) |
| 0x01 | FW_VERSION_MAJOR | 16 | R | 0x0001 | Firmware major version |
| 0x02 | FW_VERSION_MINOR | 16 | R | 0x0000 | Firmware minor version |
| 0x03 | SYS_STATUS | 16 | R | 0x0000 | [15:8] Reserved, [7] PLL_LOCKED, [6] TEMP_ALERT, [5] VOLT_FAULT, [4] ADC_LOCK, [3] SPI_BUSY, [2] UART_RX_EMPTY, [1:0] Reserved |
| 0x04 | SYS_CTRL | 16 | R/W | 0x0000 | [0] SOFT_RESET, [1] FACTORY_RESET, [2] RF_ENABLE (TRP) |
| 0x05 | UPTIME counter | 32 | R | 0x00000000 | Seconds since boot |

**Block 0x0100 — UART Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|---|---|---|---|---|---|
| 0x00 | BAUD_DIV | 16 | R/W | 0x002A | Baud rate divisor (for 125MHz ref) |
| 0x01 | UART_CTRL | 16 | R/W | 0x0001 | [0] UART_ENABLE, [1] LOOPBACK_EN |
| 0x02 | UART_STATUS | 16 | R | 0x0000 | [0] TX_BUSY, [1] RX_AVAIL, [2] PARITY_ERR |
| 0x03 | TX_DATA | 16 | W | 0x0000 | Write byte to TX FIFO (Lower 8 bits) |
| 0x04 | RX_DATA | 16 | R | 0x0000 | Read byte from RX FIFO (Lower 8 bits) |

**Block 0x0200 — SPI (LNA) Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|---|---|---|---|---|---|
| 0x00 | SPI_LNA_CTRL | 16 | R/W | 0x0000 | [0] START, [1] AUTO_INC, [2:3] CPHA_CPOL |
| 0x01 | SPI_LNA_TX | 16 | W | 0x0000 | 16-bit data to transmit |
| 0x02 | SPI_LNA_RX | 16 | R | 0x0000 | 16-bit data received |
| 0x03 | SPI_LNA_CS | 16 | R/W | 0x0001 | [0] CS_N (0=Active) |

**Block 0x0300 — SPI (CLK) Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|---|---|---|---|---|---|
| 0x00 | SPI_CLK_CTRL | 16 | R/W | 0x0000 | [0] START, [2:3] CPHA_CPOL |
| 0x01 | SPI_CLK_TX | 32 | W | 0x00000000 | 32-bit data for LMK config |
| 0x02 | SPI_CLK_RX | 32 | R | 0x00000000 | 32-bit read data |
| 0x03 | SPI_CLK_CS | 16 | R/W | 0x0001 | [0] CS_N |

**Block 0x0400 — GPIO / TRP**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|---|---|---|---|---|---|
| 0x00 | GPIO_DATA | 16 | R/W | 0x0000 | [0] TRP_OUT, [1] LED_STATUS, [2] LED_ERROR |
| 0x01 | GPIO_DIR | 16 | R/W | 0xFFFF | 0=Input, 1=Output |

**Block 0x0500 — I2C Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|---|---|---|---|---|---|
| 0x00 | I2C_CTRL | 16 | R/W | 0x0000 | [0] ENABLE, [1] START, [2] STOP |
| 0x01 | I2C_TX | 16 | W | 0x0000 | Byte to transmit |
| 0x02 | I2C_RX | 16 | R | 0x0000 | Byte received |
| 0x03 | I2C_STATUS | 16 | R | 0x0000 | [0] BUSY, [1] ACK_ERR, [2] ARB_LOST |

**Block 0x0800 — RF / LNA Config**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|---|---|---|---|---|---|
| 0x00 | LNA_GAIN_SET | 16 | R/W | 0x0018 | Gain setting in 0.5dB steps (default 12dB) |
| 0x01 | LNA_STATUS | 16 | R | 0x0000 | [0] LNA_PRESENT, [1] TEMP_WARNING |

**Block 0x0600 — ADC Interface**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|---|---|---|---|---|---|
| 0x00 | ADC_LINK_STAT | 16 | R | 0x0000 | [0] CODE_SYNC, [1] NIT_ERROR, [2] UNEXPECTED_K |
| 0x01 | ADC_SAMPLE_RATE | 16 | R/W | 0x0001 | 0=5GSPS, 1=6.4GSPS |

### 10.3 Register Access Rules
- All registers are 16-bit or 32-bit as specified.
- Byte order: Big Endian over UART.
- Write protection: System Control registers (Base 0x00) require a Write-Key sequence (Write 0x5A to 0x0FF before write).

---

## 11. UART Register Protocol Specification

This section provides the EXACT byte-level frame format for the UART register protocol. Firmware MUST implement this exactly.

### 11.1 Physical Layer
- Baud rate: 115200 bps (Default).
- Frame format: 1 start bit, 8 data bits, 1 stop bit, no parity (8N1).
- Physical interface: RS-422.
- Signal levels: Differential 3.3V logic.

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
  - CMD byte not recognized (not 0x57, 0x52, 0x42, 0x62)
  - Address out of valid range
  - Write to read-only register
  - Parser timeout (inter-byte gap > 50ms)
```

### 11.3 Protocol Timing Constraints
| Parameter | Min | Typical | Max | Unit |
|---|---|---|---|---|
| Inter-byte gap (TX side) | — | — | 50 | ms |
| Single Write response time | — | 0.5 | 1 | ms |
| Single Read response time | — | 1 | 2 | ms |
| Bulk Write response time (N=64) | — | 3 | 5 | ms |
| Bulk Read response time (N=64) | — | 3 | 5 | ms |
| Parser reset on timeout | 50 | — | — | ms |

### 11.4 Software Implementation Notes
```c
// Firmware register write wrapper
#define FPGA_WRITE(addr, data)    UART_WriteReg((uint16_t)(addr), (uint16_t)(data))
// Firmware register read wrapper
#define FPGA_READ(addr, pdata)    UART_ReadReg((uint16_t)(addr) | 0x8000U, (pdata))

// Base Addresses
#define REG_SYS_BASE    (0x0000U)
#define REG_UART_BASE   (0x0100U)
#define REG_SPI_LNA     (0x0200U)
#define REG_SPI_CLK     (0x0300U)
#define REG_GPIO_BASE   (0x0400U)
#define REG_I2C_BASE    (0x0500U)
#define REG_ADC_BASE    (0x0600U)
#define REG_PWR_BASE    (0x0700U)
#define REG_RF_BASE     (0x0800U)
```

---

## 12. FPGA Resource Utilization Estimate

| Resource | Available | Estimated Usage | Utilization % |
|---|---|---|---|
| Slice LUTs | 148,000 | 45,000 | 30% |
| Slice Flip-Flops | 296,000 | 30,000 | 10% |
| Block RAM (36Kb) | 540 | 80 | 14% |
| DSP Slices | 1,240 | 20 | 1% |
| MMCM/PLL | 10 | 2 | 20% |
| I/O Buffers | 520 | 100 | 19% |
| GTY Transceivers | 32 | 2 | 6% |

Synthesis tool: Vivado 2025.1
Target device: XQKU5P-FFVB676-1I
Timing constraint: 500 MHz Internal, 6.4 Gbps GTY

---

## Annexure A — Requirement Traceability Matrix

| S.No | GLR-ID | Description | Source HRS Section | GLR Section | Verification Method | Status |
|---|---|---|---|---|---|---|
| 1 | GLR-001 | RF Input Frequency Range | HRS §3.2 | 9.8, 10.2 | Test | Open |
| 2 | GLR-002 | Input Power Range | HRS §3.2 | 9.4 | Test | Open |
| 3 | GLR-003 | Noise Figure | HRS §3.2 | 9.8 | Test (System) | Open |
| 4 | GLR-004 | ADC Sampling Rate | HRS §3.2 | 9.2, 10.2 | Test | Open |
| 5 | GLR-005 | Spurious Free Dynamic Range | HRS §3.2 | 9.2 | Test | Open |
| 6 | GLR-006 | Linearity - IP3 | HRS §3.2 | 9.8 | Test (System) | Open |
| 7 | GLR-007 | Digital Output Interface | HRS §3.3 | 9.2, 8 | Inspection | Open |
| 8 | GLR-008 | Operating Temperature Range | HRS §3.4 | 9.4 | Test | Open |
| 9 | GLR-009 | Supply Voltage | HRS §3.5 | 9.3 | Test | Open |
| 10 | GLR-010 | Compliance Standards | HRS §3.5 | 4 | Inspection | Open |
| 11 | GLR-011 | RF Gain Control | HRS §3.1 | 9.8 | Demonstration | Open |
| 12 | GLR-012 | Register Address Map | HRS §3.3 | 10 | Inspection | Open |
| 13 | GLR-013 | UART Protocol Specification | HRS §3.3 | 11 | Test | Open |
| 14 | GLR-014 | FPGA Resource Budget | HRS §3.5 | 12 | Analysis | Open |