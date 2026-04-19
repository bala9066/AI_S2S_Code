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
This document explains the IO details and functional requirements of the FPGA for the hh project. Targeted audience: Hardware Design and Firmware teams.

---

## 2. References

### 2.1 External
| Doc. Type | Part No. | Description |
|------------|----------|-------------|
| IC | Xilinx XC7K70T-1FBG676C | FPGA Main Device |
| IC | AT25SF161 | Configuration SPI Flash |
| IC | 24AA256 | EEPROM for Configuration Storage |
| IC | ADS1115 | I2C 16-bit ADC |
| IC | LM75 | I2C Temperature Sensor |
| IC | ADM3251E | RS-422/RS-485 Transceiver |
| IC | TPS65263 | Power Management IC |

### 2.2 Internal
| Reference | Document |
|-----------|----------|
| [HRS] | Hardware Requirements Specification |
| [SCH] | Schematic |
| [GRS] | General Requirements Specification |
| [GDD] | General Design Document |
| [P1] | Component BOM |
| [P4] | Netlist Signal Connections |

---

## 3. Acronyms and Abbreviations
| Acronym | Expansion |
|---------|-----------|
| FPGA | Field-Programmable Gate Array |
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
| VHDL | VHSIC Hardware Description Language |
| VCC | Power Supply Voltage |
| GND | Ground |
| EW | Electronic Warfare |
| ELINT | Electronic Intelligence |
| pHEMT | Pseudomorphic High Electron Mobility Transistor |
| SAW | Surface Acoustic Wave |
| LNA | Low-Noise Amplifier |
| BPF | Band-Pass Filter |
| IIP3 | Third-Order Input Intercept Point |
| MDS | Minimum Detectable Signal |
| NF | Noise Figure |
| VSWR | Voltage Standing Wave Ratio |
| SMA | SubMiniature version A |
| LDO | Low Dropout Regulator |
| DC | Direct Current |
| RF | Radio Frequency |
| BIST | Built-in Self-Test |
| WDT | Watchdog Timer |
| FIFO | First-In-First-Out |
| TTL | Transistor-Transistor Logic |
| LVTTL | Low Voltage Transistor-Transistor Logic |
| LVCMOS | Low Voltage Complementary Metal-Oxide-Semiconductor |
| SSTL | Stub Series Terminated Logic |
| DIFF | Differential |

---

## 4. Module Overview

**RF SECTION:**
The hh project is a dual-channel EW/ELINT front-end receiver covering 2-6 GHz with 4 parallel RF channels per antenna. The RF section includes:
- RF Limiters: MADL-011017 (MACOM) - provides protection against high power signals
- Preselect Filters: SAW-2400-6000 (TriQuint) - provides 20 dB rejection for image frequencies
- Bias-T Networks: BTL-1-6-G-S+ (Mini-Circuits) - injects DC bias while maintaining RF isolation
- GaAs pHEMT LNAs: HMC8411 (Analog Devices) - provides 25 dB gain with 1.2 dB noise figure
- Power Splitters: PSA4-5043+ (Mini-Circuits) - splits RF signal into 4 channels
- Channel Filters: BLF-254+ (Mini-Circuits) - provides 100 MHz bandwidth with 25 dB rejection

**DIGITAL SECTION:**
The FPGA serves as the control and monitoring center for the RF system. Its primary functions include:
- Bias sequencing for GaAs pHEMT LNAs
- Power supply monitoring and control
- Temperature monitoring
- Configuration storage and management
- Communication interface (UART)
- System status monitoring and reporting
- Built-in self-test functionality

The FPGA used is Xilinx XC7K70T-1FBG676C, a Kintex-7 device offering sufficient resources for control functions while providing low power consumption.

**POWER SUPPLY SECTION:**
The power distribution system provides multiple voltage rails:
- +12V: Main supply input from external source
- +5V: Derived from +12V using LM5175 step-down converter
- +3.3V: Generated from +5V using TPS7A47 LDO
- +1.8V: Core voltage for FPGA
- +1.0V: Core voltage for FPGA

Power sequencing follows gate-before-drain bias sequencing requirements for GaAs pHEMT devices.

---

## 5. Features
- FPGA: Xilinx XC7K70T-1FBG676C (Kintex-7, 70K logic cells)
- On-board clock oscillator: 100 MHz
- Communication: UART via RS-422 (1 Mbps), SPI for Flash and EEPROM, I2C for sensors
- JTAG debugging support: 4-pin standard JTAG interface
- EEPROM: 24AA256 (256Kbit, for configuration storage)
- Storage Flash: AT25SF161 (16Mbit, for firmware updates)
- Configuration Flash: AT25SF161 (16Mbit, for FPGA configuration)
- Temperature Monitoring: LM75 via I2C (range -55°C to +125°C)
- Power monitoring: ADS1115 via I2C (4 channels)
- 8-channel bias control for GaAs pHEMT LNAs
- Built-in Self-Test (BIST) functionality
- Environmental monitoring (temperature, voltage, current)
- RF channel status monitoring
- System health reporting

---

## 6. FPGA Description
| S.NO | PARAMETERS | SPECIFICATION |
|------|-----------|---------------|
| 1 | Part Number | Xilinx XC7K70T-1FBG676C |
| 2 | Logic Cells | 70,200 |
| 3 | CLB Flip-Flops | 88,800 |
| 4 | Number of Gates | 1,260,000 |
| 5 | Maximum Distributed RAM (Kb) | 1,040 |
| 6 | Total Block RAM (Kb) | 1,350 |
| 7 | Maximum Single-Ended I/Os | 360 |
| 8 | Maximum DSP Slices | 240 |
| 9 | No of IO Bank | 8 |

---

## 7. Block Diagram
The system consists of two identical receiver channels (Antenna 1 and Antenna 2). Each channel includes:
- RF input through SMA connector
- Limiter for protection
- SAW preselect filter
- Bias-T network
- GaAs pHEMT LNA
- 1:4 power splitter
- Four channel-specific BPFs

The FPGA controls and monitors the system through:
- Bias voltage control for LNAs
- Power supply monitoring
- Temperature monitoring
- Configuration management
- Communication interfaces

---

## 8. Pinout Details

| S.No | Signal Name | Pin No | Voltage Level | Direction wrt FPGA | Source | Destination | Default Condition | Voltage Standard |
|------|-------------|--------|---------------|-------------------|--------|-------------|-------------------|------------------|
| 1 | VCC_FPGA_1V0 | B24 | 1.0V | Power | Power Supply | FPGA Core | - | - |
| 2 | VCC_FPGA_1V8 | E25 | 1.8V | Power | Power Supply | FPGA Core | - | - |
| 3 | VCC_FPGA_3V3 | D22 | 3.3V | Power | Power Supply | FPGA IO | - | - |
| 4 | GND_FPGA | B23 | 0V | Power | Power Supply | FPGA | - | - |
| 5 | GND_FPGA | E24 | 0V | Power | Power Supply | FPGA | - | - |
| 6 | GND_FPGA | D23 | 0V | Power | Power Supply | FPGA | - | - |
| 7 | FPGA_CLK_100M | H12 | 3.3V | Input | Clock Oscillator | FPGA Clock | - | LVCMOS33 |
| 8 | JTAG_TCK | K13 | 3.3V | Input | JTAG Header | FPGA JTAG | - | LVCMOS33 |
| 9 | JTAG_TDI | K14 | 3.3V | Input | JTAG Header | FPGA JTAG | - | LVCMOS33 |
| 10 | JTAG_TDO | K15 | 3.3V | Output | FPGA JTAG | JTAG Header | - | LVCMOS33 |
| 11 | JTAG_TMS | K16 | 3.3V | Input | JTAG Header | FPGA JTAG | - | LVCMOS33 |
| 12 | FPGA_RESET_N | D14 | 3.3V | Input | Power Supply | FPGA Reset | - | LVTTL |
| 13 | POR_N | C13 | 3.3V | Input | Power Supply | FPGA | - | LVTTL |
| 14 | UART_TX | H18 | 3.3V | Output | FPGA | RS-422 Transceiver | - | LVCMOS33 |
| 15 | UART_RX | G19 | 3.3V | Input | RS-422 Transceiver | FPGA | - | LVCMOS33 |
| 16 | UART_CTS | G18 | 3.3V | Input | RS-422 Transceiver | FPGA | - | LVCMOS33 |
| 17 | UART_RTS | H19 | 3.3V | Output | FPGA | RS-422 Transceiver | - | LVCMOS33 |
| 18 | SPI_CLK_FLASH | E15 | 3.3V | Output | FPGA | Configuration Flash | - | LVCMOS33 |
| 19 | SPI_MOSI_FLASH | D15 | 3.3V | Output | FPGA | Configuration Flash | - | LVCMOS33 |
| 20 | SPI_MISO_FLASH | D16 | 3.3V | Input | Configuration Flash | FPGA | - | LVCMOS33 |
| 21 | SPI_CS_FLASH_N | E16 | 3.3V | Output | FPGA | Configuration Flash | - | LVCMOS33 |
| 22 | SPI_CLK_EEPROM | F15 | 3.3V | Output | FPGA | EEPROM | - | LVCMOS33 |
| 23 | SPI_MOSI_EEPROM | F16 | 3.3V | Output | FPGA | EEPROM | - | LVCMOS33 |
| 24 | SPI_MISO_EEPROM | G16 | 3.3V | Input | EEPROM | FPGA | - | LVCMOS33 |
| 25 | SPI_CS_EEPROM_N | E14 | 3.3V | Output | FPGA | EEPROM | - | LVCMOS33 |
| 26 | I2C_SCL | C15 | 3.3V | Bidirectional | FPGA | Temperature Sensor & ADC | Pull-up | LVCMOS33 |
| 27 | I2C_SDA | C16 | 3.3V | Bidirectional | FPGA | Temperature Sensor & ADC | Pull-up | LVCMOS33 |
| 28 | LNA_BIAS_EN1 | A15 | 3.3V | Output | FPGA | LNA Bias Circuit | - | LVCMOS33 |
| 29 | LNA_BIAS_EN2 | B15 | 3.3V | Output | FPGA | LNA Bias Circuit | - | LVCMOS33 |
| 30 | LNA_BIAS_GATE1 | A16 | 3.3V | Output | FPGA | LNA Bias Circuit | - | LVCMOS33 |
| 31 | LNA_BIAS_GATE2 | B16 | 3.3V | Output | FPGA | LNA Bias Circuit | - | LVCMOS33 |
| 32 | LNA_BIAS_DRAIN1 | C17 | 3.3V | Output | FPGA | LNA Bias Circuit | - | LVCMOS33 |
| 33 | LNA_BIAS_DRAIN2 | D17 | 3.3V | Output | FPGA | LNA Bias Circuit | - | LVCMOS33 |
| 34 | LED_STATUS | A17 | 3.3V | Output | FPGA | Status LED | - | LVCMOS33 |
| 35 | FPGA_DONE | B18 | 3.3V | Output | FPGA | System Status | - | LVCMOS33 |
| 36 | FPGA_INIT_N | A18 | 3.3V | Input | FPGA | System Status | - | LVCMOS33 |
| 37 | FPGA_PROGRAM_N | A19 | 3.3V | Input | System Control | FPGA | - | LVCMOS33 |
| 38 | TEMP_ALERT | C18 | 3.3V | Input | Temperature Sensor | FPGA | - | LVCMOS33 |
| 39 | VOLT_ALERT | C19 | 3.3V | Input | Voltage Monitor | FPGA | - | LVCMOS33 |
| 40 | RF_CHANNEL_EN1 | D18 | 3.3V | Output | FPGA | Channel Filter Bank | - | LVCMOS33 |
| 41 | RF_CHANNEL_EN2 | E17 | 3.3V | Output | FPGA | Channel Filter Bank | - | LVCMOS33 |
| 42 | RF_CHANNEL_EN3 | E18 | 3.3V | Output | FPGA | Channel Filter Bank | - | LVCMOS33 |
| 43 | RF_CHANNEL_EN4 | F17 | 3.3V | Output | FPGA | Channel Filter Bank | - | LVCMOS33 |
| 44 | RF_CHANNEL_EN5 | F18 | 3.3V | Output | FPGA | Channel Filter Bank | - | LVCMOS33 |
| 45 | RF_CHANNEL_EN6 | G17 | 3.3V | Output | FPGA | Channel Filter Bank | - | LVCMOS33 |
| 46 | RF_CHANNEL_EN7 | G18 | 3.3V | Output | FPGA | Channel Filter Bank | - | LVCMOS33 |
| 47 | RF_CHANNEL_EN8 | H17 | 3.3V | Output | FPGA | Channel Filter Bank | - | LVCMOS33 |
| 48 | POWER_MON_EN | H18 | 3.3V | Output | FPGA | Voltage Monitor | - | LVCMOS33 |
| 49 | BIST_START | J18 | 3.3V | Output | FPGA | BIST Circuit | - | LVCMOS33 |
| 50 | BIST_PASS | K18 | 3.3V | Input | BIST Circuit | FPGA | - | LVCMOS33 |

---

## 9. Functional Specifications

### Summary Table

| S.No. | Function Name | Description |
|-------|--------------|-------------|
| 1 | Serial Communication Interface | UART between PC & FPGA via RS-422 (1 Mbps) |
| 2 | High Speed Communication Interface | Not applicable for this system |
| 3 | Power Supply Sequencing & Health Status | Gate-before-drain bias sequencing for GaAs pHEMT devices |
| 4 | Supply Voltage, Current & Temperature Monitoring | I2C-based monitoring using ADS1115 and LM75 |
| 5 | Flash Interfaces | Configuration and Storage flash via SPI |
| 6 | LNA Bias Control | 8-channel bias control for GaAs pHEMT LNAs |
| 7 | FPGA Remote Programming | Configuration loading via SPI interface |
| 8 | Channel Filter Control | Enable/disable 8 RF channels (4 per antenna) |
| 9 | System Health Monitoring | Real-time monitoring of system status and alerts |

### 9.1 Serial Communication Interface
- Interface type: UART
- Physical layer: RS-422
- Baud rate: 1 Mbps
- Frame format: 1 start bit, 8 data bits, 1 stop bit, no parity
- UART converter IC: ADM3251E
- Signals: UART_TX (FPGA → RS-422), UART_RX (RS-422 → FPGA)
- Protocol: Custom register-based command/response
- Data width: 8 bits
- Flow control: Hardware (RTS/CTS)
- Error detection: Parity, framing, and overrun detection
- FIFO size: 16 bytes RX and TX
- Timeout: 50ms inter-character timeout

### 9.2 High Speed Communication Interface
- Interface: Not applicable
- Data rate: Not applicable
- Protocol: Not applicable
- Physical: Not applicable

### 9.3 Power On/Off Sequence
#### 9.3.1 Power ON/OFF Sequence
Step-by-step sequence:
1. +12V input supply detected — FPGA_POWER_GOOD asserted
2. +3.3V auxiliary rails enabled
3. FPGA configured from external flash (JTAG or SPI)
4. LNA gate bias enabled (LNA_BIAS_GATE1/2)
5. LNA drain bias enabled (LNA_BIAS_DRAIN1/2)
6. System operational status signaled (LED_STATUS)
7. All RF channels enabled

#### 9.3.2 Mode Configuration
| Mode | Signal | Value | Description |
|------|--------|-------|-------------|
| Normal | MODE[1:0] | 2'b00 | Normal operating mode |
| Test | MODE[1:0] | 2'b01 | Built-in self-test mode |
| Programming | MODE[1:0] | 2'b10 | FPGA programming mode |

### 9.4 Supply Voltage, Current & Temperature Monitoring
#### 9.4.1 Supply Voltage and Current Monitoring
- IC Part Number: ADS1115
- Interface: I2C at address 0x48
- Monitored rails: +12V, +5V, +3.3V, +1.8V
- Measurement range: 0 to 25V, 0 to 3A
- Resolution: 16-bit ADC (15.625 µV)
- Sampling rate: 8 samples per second
- Alert threshold: Programmable for each rail

#### 9.4.2 Temperature Monitoring
- IC Part Number: LM75
- Interface: I2C at address 0x48
- Temperature range: -55°C to +125°C
- Resolution: 9-bit ADC (0.5°C)
- Alert threshold: Programmable
- Hysteresis: 4°C programmable
- Operating mode: Continuous conversion

### 9.5 Flash & Interfaces
#### 9.5.1 Configuration Flash
- Part Number: AT25SF161
- Interface: SPI (Mode 0, 3.3V)
- Capacity: 16Mbit (2MB)
- Purpose: Stores FPGA programming bitstream
- Organization: 256 sectors of 64KB each
- Write protection: Hardware (WP pin) and software

#### 9.5.2 Storage Flash (User Flash)
- Part Number: AT25SF161
- Interface: SPI (Mode 0, 3.3V)
- Capacity: 16Mbit (2MB)
- Purpose: Stores calibration data, status logs, and configuration updates
- Organization: 256 sectors of 64KB each

### 9.6 LNA Bias Control
- Signals: LNA_BIAS_EN1/2, LNA_BIAS_GATE1/2, LNA_BIAS_DRAIN1/2
- Direction: FPGA → RF front-end
- Logic level: 3.3V LVCMOS
- Active state: HIGH = enabled
- Timing: Gate voltage applied before drain voltage (minimum 10 µs delay)
- Control: Written via UART register commands
- Protection: Current limiting and voltage monitoring
- Sequencing: Gate voltage applied, followed by drain voltage after 10 µs delay

### 9.7 FPGA Remote Programming
- Protocol: SPI at 20 MHz
- Tool: Xilinx iMPACT or custom tool
- Procedure:
  1. Host sends programming command via UART
  2. FPGA enters programming mode (MODE = 2'b10)
  3. Bitstream transferred via SPI interface
  4. Configuration flash written via FPGA SPI master
  5. FPGA reboots from new configuration
- Fallback: JTAG programming via debug header
- Verification: CRC check of programmed bitstream
- Security: Optional password protection

### 9.8 Channel Filter Control
- Signals: RF_CHANNEL_EN1-8
- Direction: FPGA → Channel Filter Bank
- Logic level: 3.3V LVCMOS
- Active state: HIGH = channel enabled
- Control: Written via UART register commands
- Purpose: Enable/disable individual RF channels
- Status: Channel enable status readable via register map
- Protection: Simultaneous enable across all channels for operation

### 9.9 System Health Monitoring
- Monitoring parameters:
  - Temperature (LM75)
  - Voltage rails (ADS1115)
  - Current consumption
  - LNA bias status
  - Channel filter status
  - FPGA operational status
- Alert conditions:
  - Temperature > 85°C
  - Voltage deviation > ±5%
  - Current > threshold
  - LNA bias failure
- Response:
  - LED indication
  - UART status report
  - Automatic shutdown of critical components
- Logging: Events logged in storage flash

---

## 10. Software Register Address Map

### 10.1 Register Base Addresses

| Block Name | Base Address | Address Range | Description |
|------------|-------------|---------------|-------------|
| System / Identification | 0x0000 | 0x0000–0x00FF | Board ID, firmware version, status |
| UART Control | 0x0100 | 0x0100–0x01FF | Baud rate, FIFO control, status |
| SPI Control | 0x0200 | 0x0200–0x02FF | SPI master, chip-select control |
| I2C Control | 0x0300 | 0x0300–0x03FF | I2C master, device address, data |
| GPIO / Control | 0x0400 | 0x0400–0x04FF | General purpose I/O control |
| PLL Control | 0x0500 | 0x0500–0x05FF | PLL configuration, status |
| Temperature Monitor | 0x0600 | 0x0600–0x06FF | Temp sensor readings, alert threshold |
| Power Monitor | 0x0700 | 0x0700–0x07FF | Voltage/current ADC readings per rail |
| RF Control | 0x0800 | 0x0800–0x08FF | LNA bias, channel enable, status |
| Flash / EEPROM | 0x0900 | 0x0900–0x09FF | Flash address, data, command register |
| Diagnostics / BIST | 0x0A00 | 0x0A00–0x0AFF | Fault log, BIST results, system tests |

### 10.2 Detailed Register Map

**Block 0x0000 — System / Identification**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|--------------|-------|-----|-------------|----------------------|
| 0x00 | BOARD_ID | 16 | R | 0xHHH0 | Board identification code (hhh = project code) |
| 0x01 | FW_VERSION_MAJOR | 16 | R | 0x0001 | Firmware major version |
| 0x02 | FW_VERSION_MINOR | 16 | R | 0x0000 | Firmware minor version |
| 0x03 | HW_VERSION | 16 | R | 0x0000 | Hardware version (PCB revision) |
| 0x04 | SYS_STATUS | 16 | R | 0x0000 | [15:8] Reserved, [7] TEMP_ALERT, [6] VOLT_FAULT, [5] RF_FAULT, [4] LNA_BIAS_FAULT, [3:0] Reserved |
| 0x05 | SYS_CTRL | 16 | R/W | 0x0000 | [0] SOFT_RESET, [1] WDT_ENABLE, [2] RF_ENABLE, [3] BIST_START, [4:0] Reserved |
| 0x06 | MODE_CONFIG | 16 | R/W | 0x0000 | [1:0] MODE_SEL, [2] RF_CAL_EN, [3] DIAG_EN, [4] FAST_BOOT, [15:5] Reserved |
| 0x07 | BUILD_DATE | 16 | R | 0x2604 | BCD encoded date (YYWW format) |
| 0x08 | UPTIME_CNT | 32 | R | 0x00000000 | System uptime counter (1 second increments) |
| 0x0A | FAULT_CODE | 16 | R | 0x0000 | Fault code from last system fault |
| 0x0B | FAULT_CNT | 16 | R | 0x0000 | Number of system faults since last reset |
| 0x0C | DIAG_RESULT | 16 | R | 0x0000 | [7:0] TEST_RESULT, [15:8] TEST_ID |

**Block 0x0100 — UART Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|--------------|-------|-----|-------------|----------------------|
| 0x00 | BAUD_DIV | 16 | R/W | 0x0036 | Baud rate divisor = FPGA_CLK / (16 × BAUD_RATE) |
| 0x01 | UART_CTRL | 16 | R/W | 0x0001 | [0] UART_ENABLE, [1] LOOPBACK_EN, [2] CRC_EN, [3] RTS_AUTO, [4] CTS_EN, [15:5] Reserved |
| 0x02 | UART_STATUS | 16 | R | 0x0000 | [0] TX_BUSY, [1] RX_AVAIL, [2] RX_OVERRUN, [3] FRAME_ERR, [4] PARITY_ERR, [5] BREAK_DET, [6] CTS_STATE, [7] RTS_STATE |
| 0x03 | TX_FIFO_COUNT | 16 | R | 0x0000 | Number of bytes in TX FIFO |
| 0x04 | RX_FIFO_COUNT | 16 | R | 0x0000 | Number of bytes in RX FIFO |
| 0x05 | TX_FIFO_DATA | 16 | W | 0x0000 | Write data to TX FIFO |
| 0x06 | RX_FIFO_DATA | 16 | R | 0x0000 | Read data from RX FIFO |
| 0x07 | UART_ERR_CNT | 16 | R | 0x0000 | [7:0] RX_ERR_CNT, [15:8] TX_ERR_CNT |
| 0x08 | RTS_DELAY | 16 | R/W | 0x0008 | RTS to CTS delay in character times |
| 0x09 | BREAK_TIME | 16 | R/W | 0x0010 | Break transmission time in ms |

**Block 0x0200 — SPI Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|--------------|-------|-----|-------------|----------------------|
| 0x00 | SPI_CTRL | 16 | R/W | 0x0001 | [0] SPI_ENABLE, [1] SPI_MASTER, [2] SPI_LOOPBACK, [3:0] SPI_MODE |
| 0x01 | SPI_CLK_DIV | 16 | R/W | 0x0008 | SPI clock divisor (0=disable, 1=÷2, ..., 15=÷256) |
| 0x02 | SPI_STATUS | 16 | R | 0x0000 | [0] BUSY, [1] TX_FIFO_FULL, [2] RX_FIFO_EMPTY, [3] TX_FIFO_EMPTY, [4] RX_FIFO_FULL |
| 0x03 | TX_FIFO_COUNT | 16 | R | 0x0000 | Number of bytes in TX FIFO |
| 0x04 | RX_FIFO_COUNT | 16 | R | 0x0000 | Number of bytes in RX FIFO |
| 0x05 | TX_FIFO_DATA | 16 | W | 0x0000 | Write data to TX FIFO |
| 0x06 | RX_FIFO_DATA | 16 | R | 0x0000 | Read data from RX FIFO |
| 0x07 | CS_EN | 16 | R/W | 0x0000 | [3:0] CS0_EN, [7:4] CS1_EN, [11:8] CS2_EN, [15:12] CS3_EN |
| 0x08 | CS_DELAY | 16 | R/W | 0x0001 | [7:0] PRE_DELAY, [15:8] POST_DELAY (in SPI clocks) |

**Block 0x0300 — I2C Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|--------------|-------|-----|-------------|----------------------|
| 0x00 | I2C_CTRL | 16 | R/W | 0x0001 | [0] I2C_ENABLE, [1] I2C_MASTER, [2] I2C_REPEAT, [3] I2C_AUTO_STOP |
| 0x01 | I2C_CLK_DIV | 16 | R/W | 0x0020 | I2C clock divisor (0=disable, 1=÷2, ..., 255=÷256) |
| 0x02 | I2C_STATUS | 16 | R | 0x0000 | [0] BUSY, [1] NACK, [2] ARB_LOST, [3] TX_EMPTY, [4] RX_FULL |
| 0x03 | TX_FIFO_COUNT | 16 | R | 0x0000 | Number of bytes in TX FIFO |
| 0x04 | RX_FIFO_COUNT | 16 | R | 0x0000 | Number of bytes in RX FIFO |
| 0x05 | TX_FIFO_DATA | 16 | W | 0x0000 | Write data to TX FIFO |
| 0x06 | RX_FIFO_DATA | 16 | R | 0x0000 | Read data from RX FIFO |
| 0x07 | I2C_ADDR | 16 | R/W | 0x0048 | I2C device address (7-bit, left-aligned) |
| 0x08 | I2C_CMD | 16 | W | 0x0000 | [7:0] COMMAND, [15:8] DATA_LEN |
| 0x09 | I2C_BYTE_CNT | 16 | R | 0x0000 | Number of bytes transferred in last transaction |

**Block 0x0400 — GPIO / Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|--------------|-------|-----|-------------|----------------------|
| 0x00 | GPIO_DIR | 16 | R/W | 0x0000 | [0] GPIO0_DIR (0=in, 1=out), [15:1] Other GPIO directions |
| 0x01 | GPIO_OUT | 16 | R/W | 0x0000 | [0] GPIO0_OUT, [15:1] Other GPIO outputs |
| 0x02 | GPIO_IN | 16 | R | 0x0000 | [0] GPIO0_IN, [15:1] Other GPIO inputs |
| 0x03 | GPIO_INT_EN | 16 | R/W | 0x0000 | [0] GPIO0_INT_EN, [15:1] Other GPIO interrupt enables |
| 0x04 | GPIO_INT_STS | 16 | R | 0x0000 | [0] GPIO0_INT_STS, [15:1] Other GPIO interrupt status |
| 0x05 | GPIO_INT_CLR | 16 | W | 0x0000 | [0] GPIO0_INT_CLR, [15:1] Other GPIO interrupt clear |
| 0x06 | RF_CTRL | 16 | R/W | 0x0000 | [0] RF_EN1, [1] RF_EN2, [2] RF_CAL_EN, [3:0] Reserved |
| 0x07 | LNA_BIAS_EN | 16 | R/W | 0x0000 | [0] LNA_BIAS_EN1, [1] LNA_BIAS_EN2, [2:0] Reserved |
| 0x08 | LNA_BIAS_GATE | 16 | R/W | 0x0000 | [0] LNA_BIAS_GATE1, [1] LNA_BIAS_GATE2, [2:0] Reserved |
| 0x09 | LNA_BIAS_DRAIN | 16 | R/W | 0x0000 | [0] LNA_BIAS_DRAIN1, [1] LNA_BIAS_DRAIN2, [2:0] Reserved |
| 0x0A | RF_CHANNEL_EN | 16 | R/W | 0x0000 | [0] CH1_EN, [1] CH2_EN, [2] CH3_EN, [3] CH4_EN, [4] CH5_EN, [5] CH6_EN, [6] CH7_EN, [7] CH8_EN |
| 0x0B | BIST_CTRL | 16 | R/W | 0x0000 | [0] BIST_START, [1] BIST_RESET, [7:2] BIST_TEST_SEL |
| 0x0C | BIST_STATUS | 16 | R | 0x0000 | [0] BIST_BUSY, [1] BIST_PASS, [2] BIST_FAIL, [3:0] BIST_TEST_ID |

**Block 0x0500 — PLL Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|--------------|-------|-----|-------------|----------------------|
| 0x00 | PLL_N_DIV | 16 | R/W | 0x0020 | PLL feedback N divider (integer) |
| 0x01 | PLL_R_DIV | 16 | R/W | 0x0001 | PLL reference R divider |
| 0x02 | PLL_CTRL | 16 | R/W | 0x0000 | [0] PLL_ENABLE, [1] PLL_RESET, [2] PLL_BYPASS, [3] PLL_LOCK |
| 0x03 | PLL_STATUS | 16 | R | 0x0000 | [0] PLL_LOCKED, [1] PLL_LOSS_OF_LOCK, [2] PLL_ERROR, [3:0] Reserved |
| 0x04 | PLL_FREQ | 32 | R | 0x00000000 | Actual PLL output frequency in Hz |
| 0x05 | PLL_LOCK_TIMEOUT | 16 | R/W | 0x0064 | Lock timeout in 1ms units (default 100ms) |
| 0x06 | PLL_BANDWIDTH | 16 | R/W | 0x0004 | PLL loop bandwidth setting |
| 0x07 | PLL_DITHER_EN | 16 | R/W | 0x0000 | [0] PLL_DITHER_EN, [15:1] Reserved |
| 0x08 | PLL_DIV_SEL | 16 | R/W | 0x0000 | PLL output divider selection |

**Block 0x0600 — Temperature Monitor**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|--------------|-------|-----|-------------|----------------------|
| 0x00 | TEMP_READ | 16 | R | 0x0000 | Temperature reading in °C × 2 (9-bit value) |
| 0x01 | TEMP_THRESH_HIGH | 16 | R/W | 0x01A0 | High temperature threshold in °C × 2 |
| 0x02 | TEMP_THRESH_LOW | 16 | R/W | 0x00C0 | Low temperature threshold in °C × 2 |
| 0x03 | TEMP_HYST | 16 | R/W | 0x0008 | Temperature hysteresis in °C × 2 |
| 0x04 | TEMP_CONFIG | 16 | R/W | 0x0000 | [0] TEMP_SHUTDOWN, [1] TEMP_COMP_HIGH, [2] TEMP_COMP_LOW, [3:0] Reserved |
| 0x05 | TEMP_STATUS | 16 | R | 0x0000 | [0] TEMP_ALERT, [1] TEMP_FAULT, [2:0] Reserved |
| 0x06 | TEMP_RATE | 16 | R/W | 0x0000 | Temperature sampling rate (0=0.25Hz, 1=1Hz, 2=4Hz, 3=16Hz) |
| 0x07 | TEMP_SENSOR_ID | 16 | R | 0x0040 | LM75 device ID |

**Block 0x0700 — Power Monitor**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|--------------|-------|-----|-------------|----------------------|
| 0x00 | VOLT_READ_12V | 16 | R | 0x0000 | +12V rail voltage in mV |
| 0x01 | VOLT_READ_5V | 16 | R | 0x0000 | +5V rail voltage in mV |
| 0x02 | VOLT_READ_3V3 | 16 | R | 0x0000 | +3.3V rail voltage in mV |
| 0x03 | VOLT_READ_1V8 | 16 | R | 0x0000 | +1.8V rail voltage in mV |
| 0x04 | VOLT_THRESH_HIGH | 16 | R/W | 0x0F00 | High voltage threshold in mV |
| 0x05 | VOLT_THRESH_LOW | 16 | R/W | 0x0F00 | Low voltage threshold in mV |
| 0x06 | VOLT_CONFIG | 16 | R/W | 0x0000 | [0] VOLT_SHUTDOWN, [1] VOLT_COMP_HIGH, [2] VOLT_COMP_LOW, [3:0] Reserved |
| 0x07 | VOLT_STATUS | 16 | R | 0x0000 | [0] VOLT_ALERT, [1] VOLT_FAULT, [2:0] Reserved |
| 0x08 | CURRENT_READ_12V | 16 | R | 0x0000 | +12V rail current in mA |
| 0x09 | CURRENT_READ_5V | 16 | R | 0x0000 | +5V rail current in mA |
| 0x0A | CURRENT_READ_3V3 | 16 | R | 0x0000 | +3.3V rail current in mA |
| 0x0B | CURRENT_READ_1V8 | 16 | R | 0x0000 | +1.8V rail current in mA |
| 0x0C | POWER_CALC_12V | 16 | R | 0x0000 | +12V rail power in mW (V × I) |
| 0x0D | POWER_CALC_5V | 16 | R | 0x0000 | +5V rail power in mW (V × I) |
| 0x0E | POWER_CALC_3V3 | 16 | R | 0x0000 | +3.3V rail power in mW (V × I) |
| 0x0F | POWER_CALC_1V8 | 16 | R | 0x0000 | +1.8V rail power in mW (V × I) |

**Block 0x0800 — RF Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|--------------|-------|-----|-------------|----------------------|
| 0x00 | LNA_BIAS_TIME | 16 | R/W | 0x000A | Gate-to-drain delay in 100µs units |
| 0x01 | LNA_BIAS_VOLT | 16 | R/W | 0x0C80 | LNA bias voltage in mV (default 3.3V) |
| 0x02 | RF_CHANNEL_CFG | 16 | R/W | 0xFFFF | [0] CH1_CFG, [1] CH2_CFG, [2] CH3_CFG, [3] CH4_CFG, [4] CH5_CFG, [5] CH6_CFG, [6] CH7_CFG, [7] CH8_CFG |
| 0x03 | RF_GAIN_SET | 16 | R/W | 0x0800 | RF gain setting (dB) × 10 |
| 0x04 | RF_FILTER_CFG | 16 | R/W | 0x0000 | RF filter configuration parameters |
| 0x05 | RF_STATUS | 16 | R | 0x0000 | [0] RF_CH1_POW, [1] RF_CH2_POW, [2] RF_CH3_POW, [3] RF_CH4_POW, [4] RF_CH5_POW, [5] RF_CH6_POW, [6] RF_CH7_POW, [7] RF_CH8_POW, [15:8] Reserved |
| 0x06 | RF_CAL_DATA | 16 | R | 0x0000 | RF calibration data from storage |
| 0x07 | RF_CAL_ADDR | 16 | R/W | 0x0000 | RF calibration data address in storage flash |
| 0x08 | LNA_BIAS_STATUS | 16 | R | 0x0000 | [0] LNA1_BIAS_OK, [1] LNA2_BIAS_OK, [2] LNA1_TEMP_OK, [3] LNA2_TEMP_OK, [4] LNA1_CURRENT_OK, [5] LNA2_CURRENT_OK, [6:0] Reserved |
| 0x09 | RF_BIST_RESULT | 16 | R | 0x0000 | [7:0] RF_BIST_CODE, [15:8] RF_BIST_ID |

**Block 0x0900 — Flash / EEPROM**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|--------------|-------|-----|-------------|----------------------|
| 0x00 | FLASH_ADDR | 32 | R/W | 0x00000000 | Flash memory address pointer |
| 0x02 | FLASH_DATA | 16 | R/W | 0x0000 | Flash memory data read/write |
| 0x03 | FLASH_CMD | 16 | W | 0x0000 | Flash command (0=Read, 1=Write, 2=Erase, 3=Read ID) |
| 0x04 | FLASH_STATUS | 16 | R | 0x0000 | [0] BUSY, [1] WP, [2] BP0, [3] BP1, [4] BP2, [5] BP3, [6] SUS, [7] Reserved, [8-15] Manufacturer ID |
| 0x05 | FLASH_SIZE | 16 | R | 0x4000 | Flash size in sectors (0x4000 = 16Mbit) |
| 0x06 | FLASH_SECTOR | 16 | R/W | 0x0000 | Current sector for erase operations |
| 0x07 | FLASH_PAGE_SIZE | 16 | R | 0x0100 | Flash page size (0x100 = 256 bytes) |
| 0x08 | EEPROM_ADDR | 16 | R/W | 0x0000 | EEPROM memory address pointer |
| 0x09 | EEPROM_DATA | 16 | R/W | 0x0000 | EEPROM memory data read/write |
| 0x0A | EEPROM_CMD | 16 | W | 0x0000 | EEPROM command (0=Read, 1=Write, 2=Write Enable, 3=Write Disable) |
| 0x0B | EEPROM_STATUS | 16 | R | 0x0000 | [0] BUSY, [1] WEL, [2] BP0, [3] BP1, [4] BP2, [5] BP3, [6] Reserved, [7] Reserved, [8-15] Manufacturer ID |

**Block 0x0A00 — Diagnostics / BIST**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|--------------|-------|-----|-------------|----------------------|
| 0x00 | BIST_START | 16 | W | 0x0000 | [0] BIST_START, [1] BIST_RESET, [2] BIST_PAUSE, [3] BIST_RESUME, [15:4] Reserved |
| 0x01 | BIST_STATUS | 16 | R | 0x0000 | [0] BIST_BUSY, [1] BIST_PASS, [2] BIST_FAIL, [3] BIST_PAUSE, [4] BIST_RESUME, [7:5] Reserved, [15:8] BIST_PERCENT |
| 0x02 | BIST_RESULT | 16 | R | 0x0000 | [7:0] TEST_RESULT, [15:8] TEST_ID |
| 0x03 | BIST_CTRL | 16 | R/W | 0x0000 | [0] BIST_LOOP_EN, [1] BIST_LOG_EN, [2] BIST_AUTO_EN, [3:0] BIST_TEST_SEL |
| 0x04 | DIAG_RESULT | 16 | R | 0x0000 | [7:0] TEST_RESULT, [15:8] TEST_ID |
| 0x05 | DIAG_CMD | 16 | W | 0x0000 | [7:0] TEST_ID, [15:8] TEST_CMD |
| 0x06 | FAULT_CODE | 16 | R | 0x0000 | Fault code from last system fault |
| 0x07 | FAULT_CNT | 16 | R | 0x0000 | Number of system faults since last reset |
| 0x08 | FAULT_LOG_ADDR | 16 | R/W | 0x0000 | Fault log address in storage flash |
| 0x09 | FAULT_LOG_DATA | 16 | R | 0x0000 | Fault log data from storage flash |
| 0x0A | TEST_PATTERN | 16 | R/W | 0xFFFF | Test pattern for BIST operations |
| 0x0B | TEST_MASK | 16 | R/W | 0x0000 | Test mask for BIST operations |
| 0x0C | LOOPBACK_EN | 16 | R/W | 0x0000 | [0] UART_LOOPBACK, [1] SPI_LOOPBACK, [2] I2C_LOOPBACK, [3:0] Reserved |
| 0x0D | ERROR_COUNT | 16 | R | 0x0000 | [7:0] ERR_COUNT, [15:8] ERR_TYPE |

### 10.3 Register Access Rules
- All registers are 16-bit wide; accessed via UART Single/Bulk Read/Write protocol (Section 9.1)
- Read: set bit15 of address (address OR 0x8000)
- Write: address as-is
- Shadow registers: PLL_N_DIV and PLL_R_DIV are double-buffered; write PLL_CTRL[0]=0 then 1 to apply
- Atomic access: Bulk Write used for multi-register atomic updates (e.g. frequency change)
- Protected registers: Some registers require password or special command to modify
- Auto-increment: Bulk operations auto-increment address for contiguous memory access

---

## 11. UART Register Protocol Specification

### 11.1 Physical Layer
- Baud rate: 1,000,000 bps
- Frame format: 1 start bit, 8 data bits, 1 stop bit, no parity (8N1)
- Physical interface: RS-422
- Signal levels: ±5V differential
- Character timeout: 50ms
- Maximum frame size: 258 bytes (bulk read/write)

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
#define REG_SPI_BASE    (0x0200U)
#define REG_I2C_BASE    (0x0300U)
#define REG_GPIO_BASE   (0x0400U)
#define REG_PLL_BASE    (0x0500U)
#define REG_TEMP_BASE   (0x0600U)
#define REG_PWR_BASE    (0x0700U)
#define REG_RF_BASE     (0x0800U)
#define REG_FLASH_BASE  (0x0900U)
#define REG_DIAG_BASE   (0x0A00U)
```

---

## 12. FPGA Resource Utilization Estimate

| Resource | Available | Estimated Usage | Utilization % |
|---------|-----------|----------------|--------------|
| Slice LUTs | 70,200 | 15,000 | 21% |
| Slice Flip-Flops | 88,800 | 8,000 | 9% |
| Block RAM (36Kb) | 1,350 | 50 | 3.7% |
| DSP Slices | 240 | 0 | 0% |
| MMCM/PLL | 6 | 2 | 33% |
| I/O Buffers | 360 | 50 | 14% |

Synthesis tool: Vivado 2022.1
Target device: Xilinx XC7K70T-1FBG676C
Timing constraint: 100 MHz primary clock

---

## Annexure A — Requirement Traceability Matrix

| S.No. | GLR-ID | Description | Source HRS Section | GLR Section | Verification Method | Status |
|-------|--------|-------------|-------------------|-------------|--------------------|--------|
| 1 | GLR-001 | Serial Communication Interface | HRS §3.1 | 9.1, 11 | Test | Open |
| 2 | GLR-002 | High Speed Communication | HRS §3.1 | 9.2 | Analysis | Open |
| 3 | GLR-003 | Power Supply Sequencing | HRS §3.4 | 9.3 | Test | Open |
| 4 | GLR-004 | Voltage/Current/Temperature Monitoring | HRS §3.2 | 9.4 | Test | Open |
| 5 | GLR-005 | Flash Interfaces | HRS §3.1 | 9.5 | Test | Open |
| 6 | GLR-006 | LNA Bias Control | HRS §3.1, 3.16 | 9.6 | Inspection | Open |
| 7 | GLR-007 | FPGA Remote Programming | HRS §3.1 | 9.7 | Demonstration | Open |
| 8 | GLR-008 | Channel Filter Control | HRS §3.12 | 9.8 | Test | Open |
| 9 | GLR-009 | System Health Monitoring | HRS §3.2 | 9.9 | Inspection | Open |
| 10 | GLR-010 | Register Address Map | HRS §3.1 | 10 | Inspection | Open |
| 11 | GLR-011 | UART Protocol Specification | HRS §3.1 | 11 | Test | Open |
| 12 | GLR-012 | FPGA Resource Budget | HRS §3.4 | 12 | Analysis | Open |
| 13 | GLR-013 | Dual-Antenna Operation | HRS §3.11 | 9.6, 9.8 | Test | Open |
| 14 | GLR-014 | Channelised Filter Bank | HRS §3.12 | 9.8 | Test | Open |
| 15 | GLR-015 | Preselect Filter Technology | HRS §3.13 | 9.6 | Inspection | Open |
| 16 | GLR-016 | LNA Technology | HRS §3.15 | 9.6 | Inspection | Open |
| 17 | GLR-017 | System Noise Figure | HRS §3.2 | 9.6 | Test | Open |
| 18 | GLR-018 | LNA Chain Gain | HRS §3.3 | 9.6 | Test | Open |
| 19 | GLR-019 | Linearity (IIP3) | HRS §3.4 | 9.6 | Test | Open |
| 20 | GLR-020 | MDS Performance | HRS §3.2 | 9.6 | Test | Open |