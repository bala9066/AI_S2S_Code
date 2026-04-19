# Glue Logic Requirements (GLR)

## Document Control
| Document Title | Glue Logic Requirements |
| Version Date | 19.04.2026 |
| Version Number | 0V01 |
| Prepared By | Name: . Sign: |
| Document Review By | Name: . Sign: |

---

## Amendments to the Document
| S. No. | Ver. No. | Ver. Date | Changed By | Section(s) Changed | Description of Change |
| 1 | 0V01 | 19.04.2026 | - | - | Initial Version |

---

## 1. Scope of the Document
This document explains the IO details and functional requirements of the FPGA for the dgh radar RF front-end receiver project. Targeted audience: Hardware Design and Firmware teams. The document bridges the Netlist (P4) and FPGA HDL Design (P7) phases, providing a complete specification for the FPGA implementation including pinouts, functional requirements, register maps, and communication protocols.

---

## 2. References

### 2.1 External
| Doc. Type | Part No. | Description |
|-----------|----------|-------------|
| FPGA | XC7Z020-1CLG400C | Zynq-7000 SoC FPGA |
| EEPROM | AT24C256 | 256Kbit I2C EEPROM for configuration storage |
| Flash | IS25LP256D | 256Mb QSPI Flash for FPGA configuration |
| Temperature Sensor | AD7416 | I2C temperature sensor |
| Power Monitor | LTC2992 | I2C voltage and current monitor |
| Control Interface | MCP23017 | 16-bit I/O expander with SMBus interface |

### 2.2 Internal
| Reference | Document |
|-----------|----------|
| [HRS] | Hardware Requirements Specification |
| [SCH] | Schematic |
| [GRS] | General Requirements Specification |
| [GDD] | General Design Document |

---

## 3. Acronyms and Abbreviations
| Acronym | Expansion |
|---------|-----------|
| FPGA | Field Programmable Gate Array |
| UART | Universal Asynchronous Receiver/Transmitter |
| SPI | Serial Peripheral Interface |
| I2C | Inter-Integrated Circuit |
| GPIO | General Purpose Input/Output |
| JTAG | Joint Test Action Group |
| CLB | Configurable Logic Block |
| DSP | Digital Signal Processor |
| LUT | Look-Up Table |
| FF | Flip-Flop |
| IO | Input/Output |
| PCB | Printed Circuit Board |
| BOM | Bill of Materials |
| RoHS | Restriction of Hazardous Substances |
| EMC | Electromagnetic Compatibility |
| ADC | Analog-to-Digital Converter |
| DAC | Digital-to-Analog Converter |
| DMA | Direct Memory Access |
| RTL | Register Transfer Level |
| HDL | Hardware Description Language |
| VHDL | Very High-Speed Integrated Circuit Hardware Description Language |
| VCC | Power supply voltage |
| GND | Ground reference |
| SMA | SubMiniature version A connector |
| SAW | Surface Acoustic Wave |
| GaN | Gallium Nitride |
| HEMT | High Electron Mobility Transistor |
| LNA | Low Noise Amplifier |
| IIP3 | Third-order Input Intercept Point |
| VSWR | Voltage Standing Wave Ratio |
| CW | Continuous Wave |
| LFM | Linear Frequency Modulated |
| MDS | Minimum Detectable Signal |
| IP | Ingress Protection |
| LT | Linear Technology |

---

## 4. Module Overview

### RF SECTION:
The dgh radar front-end consists of a 4-channel RF receiver operating in the 5-18 GHz frequency band. Each channel includes a high power limiter (MACOM MADL-011017) that can withstand +30 dBm input, followed by a SAW pre-select filter (TDK SAW-518-HP) for out-of-band rejection. The filtered signal is then amplified by a GaN HEMT LNA chain consisting of a QPL9057 LNA and ADL5545 driver stage, providing 40-60 dB total gain with a noise figure of 4-6 dB. The final output is buffered by an MGA-68563 amplifier before being sent to the downstream superheterodyne receiver.

### DIGITAL SECTION:
The FPGA (Xilinx XC7Z020-1CLG400C) serves as the control hub for the system, managing power sequencing, monitoring critical parameters, and providing a control interface to the system. It interfaces with an MCP23017 I/O expander for digital control signals, an AD7416 temperature sensor, and an LTC2992 power monitor. The FPGA implements power-on sequencing, protection circuits, and status monitoring, with all status and control available via a UART interface for remote operation.

### POWER SUPPLY SECTION:
The power management system is built around an LT3636 dual DC-DC converter that takes a +28V input and generates multiple regulated outputs for the RF components. The primary outputs include +5V, +3.3V, +1.8V, and +1.0V rails. Power sequencing is critical to ensure proper startup and prevent damage to sensitive RF components. The FPGA monitors all rails through the LTC2992 IC, providing real-time voltage, current, and temperature data.

---

## 5. Features
- FPGA: Xilinx XC7Z020-1CLG400C Zynq-7000 SoC
- On-board clock oscillator: 125 MHz for system clock
- Communication: UART at 115200 bps for control interface
- JTAG debugging support through standard ARM JTAG interface
- EEPROM: AT24C256 (256Kbit) for system configuration storage
- Storage Flash: IS25LP256D (256Mb QSPI) for firmware updates and data logging
- Configuration Flash: IS25LP256D (256Mb QSPI) for FPGA boot configuration
- Temperature Monitoring: AD7416 I2C sensor with -40°C to +125°C range
- Power monitoring: LTC2992 I2C sensor for voltage/current monitoring
- I2C Control Interface: MCP23017 16-bit I/O expander for RF component control
- Four independent RF channels with individual power monitoring and control
- Power sequencing for safe startup and shutdown of GaN components
- Remote programming capability via UART interface
- Status monitoring for all critical parameters

---

## 6. FPGA Description
The Xilinx XC7Z020-1CLG400C Zynq-7000 SoC was selected for this design due to its integration of ARM Cortex-A9 processing system with FPGA fabric, providing both control logic processing and programmable hardware for signal processing. The device offers a good balance of resources for the control requirements while leaving room for potential future expansion.

| S.NO | PARAMETERS | SPECIFICATION |
|------|-----------|---------------|
| 1 | Part Number | XC7Z020-1CLG400C |
| 2 | Logic Cells | 52,800 |
| 3 | CLB Flip-Flops | 106,400 |
| 4 | Number of Gates | 1,061,000 |
| 5 | Maximum Distributed RAM (Kb) | 360 |
| 6 | Total Block RAM (Kb) | 1,680 |
| 7 | Maximum Single-Ended I/Os | 200 |
| 8 | Maximum DSP Slices | 80 |
| 9 | No of IO Bank | 8 |

---

## 7. Block Diagram

The dgh system consists of four parallel RF channels, each with a limiter, SAW filter, GaN LNA chain, and output buffer. All channels share a common power management system controlled by the FPGA. The FPGA interfaces with the system through several components:

- MCP23017 I/O expander for digital control signals to RF components
- AD7416 temperature sensor for thermal monitoring
- LTC2992 power monitor for voltage/current monitoring
- AT24C256 EEPROM for system configuration
- IS25LP256D Flash for storage and configuration

The FPGA implements power sequencing, protection circuits, status monitoring, and provides a UART interface for remote control and monitoring. The system also supports JTAG debugging for firmware development.

---

## 8. Pinout Details

**Table: FPGA Pin Out Details**

| S.No | Signal Name | Pin No | Voltage Level | Direction wrt FPGA | Source | Destination | Default Condition | Voltage Standard |
|------|-------------|--------|--------------|-------------------|--------|-------------|-------------------|-----------------|
| 1 | VCC_FPGA_3V3 | AA10 | 3.3V | - | Power Supply | FPGA | Power On | LVTTL |
| 2 | GND | AB9 | 0V | - | Power Supply | FPGA | Ground | LVTTL |
| 3 | VCC_FPGA_1V8 | AC12 | 1.8V | - | Power Supply | FPGA | Power On | LVTTL |
| 4 | VCC_FPGA_1V0 | AD9 | 1.0V | - | Power Supply | FPGA | Power On | LVTTL |
| 5 | FPGA_CLK_125M | T22 | 3.3V | Input | Oscillator | FPGA | Crystal Oscillator | LVTTL |
| 6 | FPGA_RESET_N | AB11 | 3.3V | Input | Power Supply | FPGA | Power-On Reset | LVTTL |
| 7 | JTAG_TCK | G15 | 3.3V | Input | JTAG Header | FPGA | Debug Interface | LVTTL |
| 8 | JTAG_TDI | H16 | 3.3V | Input | JTAG Header | FPGA | Debug Interface | LVTTL |
| 9 | JTAG_TDO | H17 | 3.3V | Output | FPGA | JTAG Header | Debug Interface | LVTTL |
| 10 | JTAG_TMS | F16 | 3.3V | Input | JTAG Header | FPGA | Debug Interface | LVTTL |
| 11 | UART_TX | D18 | 3.3V | Output | FPGA | USB-UART | PC Interface | LVTTL |
| 12 | UART_RX | C18 | 3.3V | Input | USB-UART | FPGA | PC Interface | LVTTL |
| 13 | SPI_CLK_EEPROM | K17 | 3.3V | Output | FPGA | EEPROM | Memory Interface | LVTTL |
| 14 | SPI_MOSI_EEPROM | L18 | 3.3V | Output | FPGA | EEPROM | Memory Interface | LVTTL |
| 15 | SPI_MISO_EEPROM | M18 | 3.3V | Input | EEPROM | FPGA | Memory Interface | LVTTL |
| 16 | SPI_CS_EEPROM_N | R15 | 3.3V | Output | FPGA | EEPROM | Memory Interface | LVTTL |
| 17 | SPI_CLK_FLASH | T13 | 3.3V | Output | FPGA | Flash | Memory Interface | LVTTL |
| 18 | SPI_MOSI_FLASH | T14 | 3.3V | Output | FPGA | Flash | Memory Interface | LVTTL |
| 19 | SPI_MISO_FLASH | U14 | 3.3V | Input | Flash | FPGA | Memory Interface | LVTTL |
| 20 | SPI_CS_FLASH_N | U15 | 3.3V | Output | FPGA | Flash | Memory Interface | LVTTL |
| 21 | I2C_SCL | L16 | 3.3V | Output | FPGA | MCP23017 | Control Interface | LVTTL |
| 22 | I2C_SDA | M16 | 3.3V | Bidirectional | FPGA | MCP23017 | Control Interface | LVTTL |
| 23 | TEMP_ALERT_N | K16 | 3.3V | Input | AD7416 | FPGA | Temperature Sensor | LVTTL |
| 24 | POWER_ALERT_N | L15 | 3.3V | Input | LTC2992 | FPGA | Power Monitor | LVTTL |
| 25 | RF_CH1_ENABLE | E17 | 3.3V | Output | FPGA | MCP23017 | Channel Control | LVTTL |
| 26 | RF_CH2_ENABLE | F17 | 3.3V | Output | FPGA | MCP23017 | Channel Control | LVTTL |
| 27 | RF_CH3_ENABLE | G17 | 3.3V | Output | FPGA | MCP23017 | Channel Control | LVTTL |
| 28 | RF_CH4_ENABLE | H17 | 3.3V | Output | FPGA | MCP23017 | Channel Control | LVTTL |
| 29 | LNA_GAIN_CTRL | J17 | 3.3V | Output | FPGA | MCP23017 | Gain Control | LVTTL |
| 30 | FILTER_BYPASS | K18 | 3.3V | Output | FPGA | MCP23017 | Filter Control | LVTTL |
| 31 | TRP_CTRL | L18 | 3.3V | Output | FPGA | MCP23017 | Transmit/Receive Control | LVTTL |
| 32 | STATUS_LED | M17 | 3.3V | Output | FPGA | LED | System Status | LVTTL |
| 33 | FPGA_DONE | N17 | 3.3V | Output | FPGA | System | Configuration Complete | LVTTL |
| 34 | FPGA_INIT_N | P17 | 3.3V | Output | FPGA | System | Initialization Status | LVTTL |
| 35 | FPGA_PROGRAM_N | R18 | 3.3V | Input | System | FPGA | Programming Mode | LVTTL |
| 36 | VCCO_BANK0 | V13 | 3.3V | - | Power Supply | FPGA IO Bank | Power On | LVTTL |
| 37 | VCCO_BANK1 | W13 | 3.3V | - | Power Supply | FPGA IO Bank | Power On | LVTTL |
| 38 | VCCO_BANK2 | U12 | 3.3V | - | Power Supply | FPGA IO Bank | Power On | LVTTL |
| 39 | VCCO_BANK3 | V12 | 3.3V | - | Power Supply | FPGA IO Bank | Power On | LVTTL |
| 40 | VCCO_BANK4 | W12 | 3.3V | - | Power Supply | FPGA IO Bank | Power On | LVTTL |
| 41 | VCCO_BANK5 | U11 | 3.3V | - | Power Supply | FPGA IO Bank | Power On | LVTTL |
| 42 | VCCO_BANK6 | V11 | 3.3V | - | Power Supply | FPGA IO Bank | Power On | LVTTL |
| 43 | VCCO_BANK7 | W11 | 3.3V | - | Power Supply | FPGA IO Bank | Power On | LVTTL |
| 44 | I2C_SCL_TEMP | T11 | 3.3V | Output | FPGA | AD7416 | Temperature Sensor | LVTTL |
| 45 | I2C_SDA_TEMP | U11 | 3.3V | Bidirectional | FPGA | AD7416 | Temperature Sensor | LVTTL |
| 46 | I2C_SCL_PWR | T12 | 3.3V | Output | FPGA | LTC2992 | Power Monitor | LVTTL |
| 47 | I2C_SDA_PWR | U12 | 3.3V | Bidirectional | FPGA | LTC2992 | Power Monitor | LVTTL |
| 48 | GPIO_0 | E14 | 3.3V | Bidirectional | FPGA | External | General Purpose | LVTTL |
| 49 | GPIO_1 | E15 | 3.3V | Bidirectional | FPGA | External | General Purpose | LVTTL |
| 50 | GPIO_2 | F14 | 3.3V | Bidirectional | FPGA | External | General Purpose | LVTTL |
| 51 | GPIO_3 | F15 | 3.3V | Bidirectional | FPGA | External | General Purpose | LVTTL |

---

## 9. Functional Specifications

**Summary table:**

| S.No. | Function Name | Description |
|-------|--------------|-------------|
| 1 | Serial Communication Interface | UART between PC & FPGA via USB-UART (RS232) |
| 2 | I2C Control Interface | Control of MCP23017 I/O expander and monitoring sensors |
| 3 | Power Supply Sequencing & Health Status | Based on supply voltage, control PA drain voltage and monitor health |
| 4 | Supply Voltage, Current & Temperature Monitoring | I2C-based monitoring via LTC2992 and AD7416 |
| 5 | Flash & EEPROM Interfaces | Configuration and storage via SPI/QSPI |
| 6 | RF Channel Control | Control of RF components via MCP23017 |
| 7 | FPGA Remote Programming | Configuration loading via communication interface |
| 8 | System Status & Error Handling | LED status and fault detection |

### 9.1 Serial Communication Interface
- Interface type: UART
- Physical layer: RS-232
- Baud rate: 115200 bps
- Frame format: 1 start bit, 8 data bits, 1 stop bit, no parity
- USB-UART converter IC: CH340G
- Signals: UART_TX (FPGA → PC), UART_RX (PC → FPGA)
- Protocol: Custom register-based command/response for system control and monitoring

### 9.2 I2C Control Interface
- Interface: I2C SMBus
- Number of devices: 3 (MCP23017, AD7416, LTC2992)
- Addresses: MCP23017 (0x20), AD7416 (0x48), LTC2992 (0x4C)
- Speed: 100 kHz standard mode
- Signals: I2C_SCL, I2C_SDA
- Protocol: Standard I2C read/write operations for configuration and status monitoring

### 9.3 Power On/Off Sequence
#### 9.3.1 Power ON/OFF Sequence
Step-by-step sequence:
1. Input supply (+28V) detected — FPGA_PG_IN asserted
2. FPGA core voltage enabled (1.0V → 1.8V → 3.3V sequencing)
3. Wait for stable voltages (1ms per rail)
4. Initialize I2C devices and read initial status
5. Enable bias circuits for RF components
6. Configure MCP23017 initial state
7. Assert FPGA_DONE signal
8. System READY status

#### 9.3.2 Mode Configuration
| Mode | Signal | Value | Description |
|------|--------|-------|-------------|
| Normal | MODE[1:0] | 2'b00 | Normal operating mode |
| Test | MODE[1:0] | 2'b01 | Built-in self-test mode |
| Programming | MODE[1:0] | 2'b10 | FPGA remote programming mode |

### 9.4 Supply Voltage, Current & Temperature Monitoring
#### 9.4.1 Supply Voltage and Current Monitoring
- IC Part Number: LTC2992
- Interface: I2C at address 0x4C
- Monitored rails: +28V, +5V, +3.3V, +1.8V, +1.0V
- Measurement range: 0 to 40V, 0 to 3A
- Resolution: 10mV / 1mA
- Alert threshold: ±5% of nominal voltage

#### 9.4.2 Temperature Monitoring
- IC Part Number: AD7416
- Interface: I2C at address 0x48
- Temperature range: -40°C to +125°C
- Resolution: 0.25°C
- Alert threshold: +85°C

### 9.5 Flash & EEPROM Interfaces
#### 9.5.1 Configuration Flash
- Part Number: IS25LP256D
- Interface: QSPI (quad SPI)
- Capacity: 256 Mb
- Purpose: Stores FPGA programming bitstream for remote programming
- Programming: Via UART interface through GUI tool

#### 9.5.2 EEPROM
- Part Number: AT24C256
- Interface: I2C
- Capacity: 256 Kbit
- Purpose: Stores system configuration and calibration data

### 9.6 RF Channel Control
- Interface: MCP23017 I/O expander via I2C
- Control signals:
  - Channel Enable (GPIO0-3): Individual channel control
  - LNA Gain Control (GPIO4): Analog gain adjustment
  - Filter Bypass (GPIO5): SAW filter bypass control
  - TRP Control (GPIO6): Transmit/Receive pulse control
- Update rate: 100 Hz for dynamic control
- Protection: Automatic shutdown on temperature or voltage fault

### 9.7 FPGA Remote Programming
- Protocol: UART at 115200 bps
- Tool: GUI application on host PC
- Procedure:
  1. Host sends programming command via UART
  2. FPGA enters programming mode (MODE = 2'b10)
  3. Bitstream transferred in 256-byte packets
  4. Configuration flash written via FPGA SPI master
  5. FPGA reboots from new configuration
- Fallback: JTAG programming via debug header

### 9.8 System Status & Error Handling
- Status monitoring: All voltage rails, temperature, and RF status
- Error detection: Overvoltage, undervoltage, overtemperature
- Error response: Automatic shutdown of RF components
- Status indicators: LED status with multiple blink patterns
- Fault logging: Non-volatile storage of fault events in EEPROM

---

## 10. Software Register Address Map

### 10.1 Register Base Addresses

| Block Name | Base Address | Address Range | Description |
|------------|-------------|---------------|-------------|
| System / Identification | 0x0000 | 0x0000–0x00FF | Board ID, firmware version, status |
| UART Control | 0x0100 | 0x0100–0x01FF | Baud rate, FIFO control, status |
| I2C Control | 0x0200 | 0x0200–0x02FF | I2C master, device address, data |
| GPIO Control | 0x0300 | 0x0300–0x03FF | General purpose I/O control |
| Power Management | 0x0400 | 0x0400–0x04FF | Power sequencing, monitoring |
| Temperature Monitor | 0x0500 | 0x0500–0x05FF | Temp sensor readings, alert threshold |
| RF Control | 0x0600 | 0x0600–0x06FF | Channel control, gain, filter bypass |
| EEPROM | 0x0700 | 0x0700–0x07FF | EEPROM read/write, configuration |
| Flash Control | 0x0800 | 0x0800–0x08FF | Flash read/write, programming |
| Diagnostics | 0x0900 | 0x0900–0x09FF | Fault log, uptime counter, loopback |

### 10.2 Detailed Register Map

**Block 0x0000 — System / Identification**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|--------------|-------|-----|-------------|----------------------|
| 0x00 | BOARD_ID | 16 | R | 0xDGH0 | Board identification code |
| 0x01 | FW_VERSION_MAJOR | 16 | R | 0x0001 | Firmware major version |
| 0x02 | FW_VERSION_MINOR | 16 | R | 0x0000 | Firmware minor version |
| 0x03 | SYS_STATUS | 16 | R | 0x0000 | [15:8] Reserved, [7] PLL_LOCKED, [6] TEMP_ALERT, [5] VOLT_FAULT, [4:0] Reserved |
| 0x04 | SYS_CTRL | 16 | R/W | 0x0000 | [0] SOFT_RESET, [1] WDT_ENABLE, [2] RF_ENABLE |
| 0x05 | UPTIME_COUNTER | 32 | R | 0x00000000 | System uptime in seconds |
| 0x06 | ERROR_CODE | 16 | R | 0x0000 | Last error code |

**Block 0x0100 — UART Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|--------------|-------|-----|-------------|----------------------|
| 0x00 | BAUD_DIV | 16 | R/W | 0x0036 | Baud rate divisor = FPGA_CLK / (16 × BAUD_RATE) |
| 0x01 | UART_CTRL | 16 | R/W | 0x0001 | [0] UART_ENABLE, [1] LOOPBACK_EN, [2] CRC_EN |
| 0x02 | UART_STATUS | 16 | R | 0x0000 | [0] TX_BUSY, [1] RX_AVAIL, [2] RX_OVERRUN, [3] FRAME_ERR |
| 0x03 | TX_FIFO_COUNT | 16 | R | 0x0000 | Number of bytes in TX FIFO |
| 0x04 | RX_FIFO_COUNT | 16 | R | 0x0000 | Number of bytes in RX FIFO |
| 0x05 | TX_DATA | 16 | W | 0x0000 | Data to be transmitted |
| 0x06 | RX_DATA | 16 | R | 0x0000 | Received data |

**Block 0x0200 — I2C Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|--------------|-------|-----|-------------|----------------------|
| 0x00 | I2C_DEVICE_ADDR | 16 | R/W | 0x0020 | Selected I2C device address |
| 0x01 | I2C_DATA | 16 | R/W | 0x0000 | Data for I2C transfer |
| 0x02 | I2C_CTRL | 16 | R/W | 0x0000 | [0] START, [1] STOP, [2] READ, [3] WRITE, [4] RESTART |
| 0x03 | I2C_STATUS | 16 | R | 0x0000 | [0] BUSY, [1] NACK, [2] ARB_LOST, [3] COMPLETE |
| 0x04 | I2C_CLOCK | 16 | R/W | 0x0001 | I2C clock speed: 0=100kHz, 1=400kHz |
| 0x05 | I2C_TIMEOUT | 16 | R/W | 0x0064 | I2C transaction timeout in 1ms units |

**Block 0x0300 — GPIO Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|--------------|-------|-----|-------------|----------------------|
| 0x00 | GPIO_DIR | 16 | R/W | 0x00FF | Direction: 1=Output, 0=Input |
| 0x01 | GPIO_OUT | 16 | R/W | 0x0000 | Output values for GPIO pins |
| 0x02 | GPIO_IN | 16 | R | 0x0000 | Input values from GPIO pins |
| 0x03 | GPIO_INT_EN | 16 | R/W | 0x0000 | Interrupt enable mask |
| 0x04 | GPIO_INT_STAT | 16 | R/W | 0x0000 | Interrupt status flags |

**Block 0x0400 — Power Management**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|--------------|-------|-----|-------------|----------------------|
| 0x00 | POWER_SEQ_CTRL | 16 | R/W | 0x0000 | [0] PWR_ON, [1] PWR_OFF, [2] RESET |
| 0x01 | POWER_STATUS | 16 | R | 0x0000 | Power status flags per rail |
| 0x02 | POWER_SEQ_DELAY | 16 | R/W | 0x0010 | Sequencing delay in ms |
| 0x03 | POWER_ENABLE | 16 | R/W | 0x000F | Power enable mask per rail |
| 0x04 | POWER_MONITOR | 16 | R | 0x0000 | Power monitoring status |
| 0x05 | POWER_ALERT_THRESH | 16 | R/W | 0x0505 | Alert threshold in 5% increments |

**Block 0x0500 — Temperature Monitor**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|--------------|-------|-----|-------------|----------------------|
| 0x00 | TEMP_READING | 16 | R | 0x0000 | Temperature reading in °C × 4 |
| 0x01 | TEMP_THRESH_HIGH | 16 | R/W | 0x3400 | High temperature threshold in °C × 4 |
| 0x02 | TEMP_THRESH_LOW | 16 | R/W | 0xEC00 | Low temperature threshold in °C × 4 |
| 0x03 | TEMP_CTRL | 16 | R/W | 0x0000 | [0] TEMP_ENABLE, [1] TEMP_ALERT_EN |
| 0x04 | TEMP_STATUS | 16 | R | 0x0000 | Temperature status flags |
| 0x05 | TEMP_HYSTERESIS | 16 | R/W | 0x0400 | Temperature hysteresis in °C × 4 |

**Block 0x0600 — RF Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|--------------|-------|-----|-------------|----------------------|
| 0x00 | RF_CHANNEL_ENABLE | 16 | R/W | 0x0000 | Channel enable: 1=Enabled, 0=Disabled |
| 0x01 | RF_GAIN_CTRL | 16 | R/W | 0x00FF | Gain control for each channel |
| 0x02 | RF_FILTER_BYPASS | 16 | R/W | 0x0000 | Filter bypass: 1=Bypassed, 0=Enabled |
| 0x03 | RF_TRP_CTRL | 16 | R/W | 0x0000 | TRP control: 1=TX mode, 0=RX mode |
| 0x04 | RF_STATUS | 16 | R | 0x0000 | RF channel status flags |
| 0x05 | RF_CAL_DATA | 32 | R/W | 0x00000000 | Calibration data for RF components |
| 0x06 | RF_TEST_MODE | 16 | R/W | 0x0000 | [0] TEST_EN, [1] TEST_PATTERN_EN |

**Block 0x0700 — EEPROM**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|--------------|-------|-----|-------------|----------------------|
| 0x00 | EEPROM_ADDR_HIGH | 16 | R/W | 0x0000 | High byte of EEPROM address |
| 0x01 | EEPROM_ADDR_LOW | 16 | R/W | 0x0000 | Low byte of EEPROM address |
| 0x02 | EEPROM_DATA | 16 | R/W | 0x0000 | Data for EEPROM transfer |
| 0x03 | EEPROM_CTRL | 16 | R/W | 0x0000 | [0] WRITE, [1] READ, [2] ERASE, [3] COMPLETE |
| 0x04 | EEPROM_STATUS | 16 | R | 0x0000 | EEPROM operation status |
| 0x05 | EEPROM_BUSY_TIMEOUT | 16 | R/W | 0x00FF | EEPROM operation timeout in 100ms units |

**Block 0x0800 — Flash Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|--------------|-------|-----|-------------|----------------------|
| 0x00 | FLASH_ADDR_HIGH | 16 | R/W | 0x0000 | High byte of Flash address |
| 0x01 | FLASH_ADDR_LOW | 16 | R/W | 0x0000 | Low byte of Flash address |
| 0x02 | FLASH_DATA | 16 | R/W | 0x0000 | Data for Flash transfer |
| 0x03 | FLASH_CTRL | 16 | R/W | 0x0000 | [0] WRITE, [1] READ, [2] ERASE, [3] ERASE_CHIP |
| 0x04 | FLASH_STATUS | 16 | R | 0x0000 | Flash operation status |
| 0x05 | FLASH_BUSY_TIMEOUT | 16 | R/W | 0x00FF | Flash operation timeout in 100ms units |
| 0x06 | FLASH_WRITE_ENABLE | 16 | W | 0x0000 | [0] WREN command |
| 0x07 | FLASH_WRITE_DISABLE | 16 | W | 0x0000 | [0] WRDI command |

**Block 0x0900 — Diagnostics**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|--------------|-------|-----|-------------|----------------------|
| 0x00 | FAULT_LOG_ADDR | 16 | R/W | 0x0000 | Fault log pointer |
| 0x01 | FAULT_LOG_DATA | 16 | R | 0x0000 | Fault log entry |
| 0x02 | FAULT_COUNT | 16 | R | 0x0000 | Total number of faults |
| 0x03 | DIAG_CTRL | 16 | R/W | 0x0000 | [0] LOOPBACK_EN, [1] FAULT_CLEAR |
| 0x04 | LOOPBACK_DATA | 16 | R/W | 0x0000 | Loopback test data |
| 0x05 | LOOPBACK_STATUS | 16 | R | 0x0000 | Loopback test results |
| 0x06 | TEST_PATTERN | 16 | R/W | 0x0000 | Test pattern generator |
| 0x07 | TEST_RESULT | 16 | R | 0x0000 | Test pattern results |

### 10.3 Register Access Rules
- All registers are 16-bit wide; accessed via UART Single/Bulk Read/Write protocol (Section 9.1)
- Read: set bit15 of address (address OR 0x8000)
- Write: address as-is
- Shadow registers: RF_GAIN_CTRL and RF_CAL_DATA are double-buffered; write RF_CTRL[0]=1 then 0 to apply
- Atomic access: Bulk Write used for multi-register atomic updates (e.g. frequency change)

---

## 11. UART Register Protocol Specification

### 11.1 Physical Layer
- Baud rate: 115200 bps (configurable via UART_CTRL.BAUD_DIV)
- Frame format: 1 start bit, 8 data bits, 1 stop bit, no parity (8N1)
- Physical interface: RS-232
- Signal levels: ±12V logic

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
|-----------|-----|---------|-----|------|
| Inter-byte gap (TX side) | — | — | 50 | ms |
| Single Write response time | — | 0.5 | 1 | ms |
| Single Read response time | — | 1 | 2 | ms |
| Bulk Write response time (N=64) | — | 3 | 5 | ms |
| Bulk Read response time (N=64) | — | 3 | 5 | ms |
| Parser reset on timeout | 50 | — | — | ms |

### 11.4 Software Implementation Notes
```c
// Firmware register write wrapper — always use this macro
#define FPGA_WRITE(addr, data)    UART_WriteReg((uint16_t)(addr), (uint16_t)(data))
// Firmware register read wrapper
#define FPGA_READ(addr, pdata)    UART_ReadReg((uint16_t)(addr) | 0x8000U, (pdata))
// Block registers by base address
#define REG_SYS_BASE    (0x0000U)
#define REG_UART_BASE   (0x0100U)
#define REG_I2C_BASE    (0x0200U)
#define REG_GPIO_BASE   (0x0300U)
#define REG_PWR_BASE    (0x0400U)
#define REG_TEMP_BASE   (0x0500U)
#define REG_RF_BASE     (0x0600U)
#define REG_EEPROM_BASE (0x0700U)
#define REG_FLASH_BASE  (0x0800U)
#define REG_DIAG_BASE   (0x0900U)
```

---

## 12. FPGA Resource Utilization Estimate

| Resource | Available | Estimated Usage | Utilization % |
|---------|-----------|----------------|--------------|
| Slice LUTs | 52,800 | 15,840 | 30% |
| Slice Flip-Flops | 106,400 | 21,280 | 20% |
| Block RAM (36Kb) | 1,680 | 360 | 21% |
| DSP Slices | 80 | 16 | 20% |
| MMCM/PLL | 4 | 1 | 25% |
| I/O Buffers | 200 | 51 | 25.5% |

Synthesis tool: Vivado 2023.1
Target device: Xilinx XC7Z020-1CLG400C
Timing constraint: 125 MHz primary clock

---

## Annexure A — Requirement Traceability Matrix

| S.No. | GLR-ID | Description | Source HRS Section | GLR Section | Verification Method | Status |
|-------|--------|-------------|-------------------|-------------|--------------------|--------|
| 1 | GLR-001 | Serial Communication Interface | HRS §3.3 | 9.1, 11 | Test | Open |
| 2 | GLR-002 | I2C Control Interface | HRS §3.3 | 9.2 | Test | Open |
| 3 | GLR-003 | Power Supply Sequencing | HRS §3.4 | 9.3 | Test | Open |
| 4 | GLR-004 | Voltage/Current/Temperature Monitoring | HRS §3.2, §3.5 | 9.4 | Test | Open |
| 5 | GLR-005 | Flash & EEPROM Interfaces | HRS §3.3 | 9.5 | Test | Open |
| 6 | GLR-006 | RF Channel Control | HRS §3.1 | 9.6 | Inspection | Open |
| 7 | GLR-007 | FPGA Remote Programming | HRS §3.3 | 9.7 | Demonstration | Open |
| 8 | GLR-008 | System Status & Error Handling | HRS §3.4 | 9.8 | Test | Open |
| 9 | GLR-009 | Register Address Map | HRS §3.3 | 10 | Inspection | Open |
| 10 | GLR-010 | UART Protocol Specification | HRS §3.3 | 11 | Test | Open |
| 11 | GLR-011 | FPGA Resource Budget | HRS §3.4 | 12 | Analysis | Open |
| 12 | GLR-012 | Pinout Details | HRS §3.3 | 8 | Inspection | Open |