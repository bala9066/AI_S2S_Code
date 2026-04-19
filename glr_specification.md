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
This document explains the IO details and functional requirements of the FPGA for the gvng project. Targeted audience: Hardware Design and Firmware teams.

---

## 2. References

### 2.1 External
| Doc. Type | Part No. | Description |
|-----------|----------|-------------|
| Datasheet | PE8135 | 8:1 GaAs SPDT RF Switch, 2-6 GHz, 0.5 dB insertion loss, 20 dB isolation |
| Datasheet | CGH40010F | GaN HEMT LNA, 2-18 GHz, 22 dB gain, 2.5 dB NF, +40 dBm OIP3 |
| Datasheet | BPFB-0600-5100+ | Bandpass Filter, 5.1 GHz center, 600 MHz bandwidth, 0.3 dB insertion loss |
| Datasheet | MADL-011019 | GaAs Limiter, 2-18 GHz, +40 dBm peak power handling |
| Datasheet | 141-0711-801 | SMP Jack Connector, 50Ω, panel mount |
| Datasheet | LMH6401 | Active Bias Circuit |
| Datasheet | LMR36506 | Power Supply Regulator |
| Datasheet | XC7Z020-1CLG400C | Zynq-7000 SoC FPGA |
| Datasheet | AT25SF161 | Serial Configuration Flash |
| Datasheet | 24LC256 | Serial EEPROM |

### 2.2 Internal
| Reference | Document |
|-----------|----------|
| [HRS] | Hardware Requirements Specification |
| [SCH] | Schematic |
| [GRS] | General Requirements Specification |
| [GDD] | General Design Document |
| [P4] | Logical Netlist |

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
| VHDL | VHSIC Hardware Description Language |
| VCC | Voltage at Collector (conventional power supply) |
| GND | Ground (reference point) |
| EW | Electronic Warfare |
| ESM | Electronic Support Measures |
| ELINT | Electronic Intelligence |
| GaN | Gallium Nitride |
| HEMT | High Electron Mobility Transistor |
| LNA | Low Noise Amplifier |
| IIP3 | Third-Order Input Intercept Point |
| NF | Noise Figure |
| VSWR | Voltage Standing Wave Ratio |
| MDS | Minimum Detectable Signal |
| SMP | Subminiature version P (connector) |
| IP67 | Ingress Protection rating (dust tight, temporary water immersion) |
| MIL-STD | Military Standard |
| QSPI | Quad Serial Peripheral Interface |
| TX | Transmit |
| RX | Receive |

---

## 4. Module Overview

**RF SECTION:**
The gvng project features an 8-channel RF front-end system covering 2-6 GHz frequency range with 10-100 MHz instantaneous bandwidth. The RF section includes:
- PE8135 8:1 GaAs SPDT RF switch for channel selection
- CGH40010F GaN HEMT LNA providing 22 dB gain with 2.5 dB noise figure
- BPFB-0600-5100+ ceramic pre-select filter for frequency band selection
- MADL-011019 GaAs limiter providing +40 dBm peak power handling
- Custom LC input and output matching networks for 50Ω impedance matching
- SMP connector (141-0711-801) for RF interface

**DIGITAL SECTION:**
The digital section is centered around the XC7Z020-1CLG400C Zynq-7000 SoC FPGA, which provides the processing capability for:
- Control of the RF switching matrix
- Configuration of gain settings and filter selection
- Monitoring of RF parameters and system status
- Interface to downstream processing systems
- Configuration storage and management
- Real-time signal processing capabilities

**POWER SUPPLY SECTION:**
The power supply section includes:
- Primary +12V input from external power supply
- LMR36506 power supply regulator providing regulated voltage to all components
- LMH6401 active bias circuit for GaN HEMT biasing
- Power monitoring and protection circuits
- Military-grade power sequencing for reliable operation across -55°C to +125°C

---

## 5. Features
- FPGA: XC7Z020-1CLG400C Zynq-7000 SoC with ARM Cortex-A9 and FPGA fabric
- On-board clock oscillator: 125 MHz primary system clock
- Communication: UART at 115200 bps for control interface, SPI for peripheral access
- JTAG debugging support for FPGA programming and debugging
- EEPROM: 24LC256 (256Kb) for storing configuration parameters
- Storage Flash: AT25SF161 (16Mb) for firmware updates and data logging
- Configuration Flash: MT25QL256 for FPGA boot configuration
- Temperature Monitoring: TMP100 digital temperature sensor via I2C
- Power monitoring: INA219 current/voltage monitoring for all power rails
- RF Control Interface: Digital control for PE8135 RF switch and CGH40010F LNA
- Military-grade operation: -55°C to +125°C operating temperature range

---

## 6. FPGA Description
The XC7Z020-1CLG400C Zynq-7000 SoC was selected for its combination of ARM processor and FPGA fabric, providing both processing flexibility and hardware acceleration capabilities. The Zynq architecture allows for efficient control of the RF front-end while also providing the processing necessary for signal analysis in EW/ESM/ELINT applications.

| S.NO | PARAMETERS | SPECIFICATION |
|------|-----------|---------------|
| 1 | Part Number | XC7Z020-1CLG400C |
| 2 | Logic Cells | 44,000 |
| 3 | CLB Flip-Flops | 106,400 |
| 4 | Number of Gates | 1,270,000 |
| 5 | Maximum Distributed RAM (Kb) | 360 |
| 6 | Total Block RAM (Kb) | 1,800 |
| 7 | Maximum Single-Ended I/Os | 200 |
| 8 | Maximum DSP Slices | 80 |
| 9 | No of IO Bank | 8 |

---

## 7. Block Diagram

The gvng system consists of an RF front-end section and a digital control section. The RF front-end includes an 8:1 RF switch, GaN HEMT LNA, ceramic pre-select filter, RF limiter, and input/output matching networks. The digital control section is centered around the XC7Z020-1CLG400C Zynq-7000 SoC FPGA, which provides control signals to the RF components, monitors system status, and interfaces with external systems.

The digital section includes:
- ARM Cortex-A9 processor for control and processing
- FPGA fabric for custom hardware acceleration
- UART interface for control commands
- SPI interfaces for peripheral communication
- I2C interface for sensor monitoring
- GPIO for general control functions
- JTAG interface for programming and debugging

The RF section includes:
- PE8135 RF switch controlled by FPGA
- CGH40010F GaN HEMT LNA with bias control
- BPFB-0600-5100+ ceramic filter
- MADL-011019 RF limiter
- Custom LC matching networks

---

## 8. Pinout Details

**Table: FPGA Pin Out Details**

| S.No | Signal Name | Pin No | Voltage Level | Direction wrt FPGA | Source | Destination | Default Condition | Voltage Standard |
|------|-------------|--------|---------------|-------------------|--------|-------------|-------------------|------------------|
| 1 | VCC_FPGA_3V3 | T20 | 3.3V | - | Power Supply | FPGA | - | LVTTL |
| 2 | VCC_FPGA_1V8 | T19 | 1.8V | - | Power Supply | FPGA | - | LVCMOS18 |
| 3 | VCC_FPGA_1V0 | W18 | 1.0V | - | Power Supply | FPGA | - | LVTTL |
| 4 | GND_FPGA | T21, T22, U22, W19 | 0V | - | Power Supply | FPGA | - | - |
| 5 | FPGA_CLK_125M | E19 | 3.3V | Input | Oscillator | FPGA | - | LVCMOS33 |
| 6 | TCK | D11 | 3.3V | Input | JTAG Header | FPGA | - | JTAG |
| 7 | TDI | C11 | 3.3V | Input | JTAG Header | FPGA | - | JTAG |
| 8 | TDO | D12 | 3.3V | Output | FPGA | JTAG Header | - | JTAG |
| 9 | TMS | E11 | 3.3V | Input | JTAG Header | FPGA | - | JTAG |
| 10 | FPGA_RESET_N | K16 | 3.3V | Input | Reset Circuit | FPGA | HIGH | LVTTL |
| 11 | POR_N | H16 | 3.3V | Input | Power Supply | FPGA | HIGH | LVTTL |
| 12 | UART_TX | F12 | 3.3V | Output | FPGA | USB-UART | HIGH | LVTTL |
| 13 | UART_RX | G12 | 3.3V | Input | USB-UART | FPGA | - | LVTTL |
| 14 | UART_CTS | H12 | 3.3V | Input | USB-UART | FPGA | HIGH | LVTTL |
| 15 | UART_RTS | J12 | 3.3V | Output | FPGA | USB-UART | LOW | LVTTL |
| 16 | SPI_CLK_EEPROM | K14 | 3.3V | Output | FPGA | EEPROM | - | LVCMOS33 |
| 17 | SPI_MOSI_EEPROM | K15 | 3.3V | Output | FPGA | EEPROM | - | LVCMOS33 |
| 18 | SPI_MISO_EEPROM | L15 | 3.3V | Input | EEPROM | FPGA | - | LVCMOS33 |
| 19 | SPI_CS_EEPROM_N | M15 | 3.3V | Output | FPGA | EEPROM | HIGH | LVCMOS33 |
| 20 | FLASH_CLK | T14 | 3.3V | Output | FPGA | Flash | - | LVCMOS33 |
| 21 | FLASH_MOSI | T13 | 3.3V | Output | FPGA | Flash | - | LVCMOS33 |
| 22 | FLASH_MISO | R13 | 3.3V | Input | Flash | FPGA | - | LVCMOS33 |
| 23 | FLASH_CS_N | T12 | 3.3V | Output | FPGA | Flash | HIGH | LVCMOS33 |
| 24 | I2C_SCL | H14 | 3.3V | Output | FPGA | I2C Devices | HIGH | LVTTL |
| 25 | I2C_SDA | J14 | 3.3V | Bidirectional | FPGA | I2C Devices | Pull-up | LVTTL |
| 26 | LED_STATUS | M14 | 3.3V | Output | FPGA | Status LED | LOW | LVCMOS33 |
| 27 | FPGA_DONE | N16 | 3.3V | Output | FPGA | Status Indicator | - | LVCMOS33 |
| 28 | FPGA_INIT_N | M16 | 3.3V | Input | FPGA | Status Indicator | - | LVTTL |
| 29 | RF_SW_SELECT0 | A16 | 3.3V | Output | FPGA | PE8135 | LOW | LVCMOS33 |
| 30 | RF_SW_SELECT1 | B16 | 3.3V | Output | FPGA | PE8135 | LOW | LVCMOS33 |
| 31 | RF_SW_SELECT2 | C16 | 3.3V | Output | FPGA | PE8135 | LOW | LVCMOS33 |
| 32 | RF_SW_ENABLE | D16 | 3.3V | Output | FPGA | PE8135 | LOW | LVCMOS33 |
| 33 | LNA_GAIN_EN | E16 | 3.3V | Output | FPGA | CGH40010F | LOW | LVCMOS33 |
| 34 | LNA_BIAS_ADJ | F16 | 3.3V | Output | FPGA | CGH40010F | - | LVCMOS33 |
| 35 | LIMiter_ENABLE | G16 | 3.3V | Output | FPGA | MADL-011019 | LOW | LVCMOS33 |
| 36 | TRP | H15 | 3.3V | Output | FPGA | RF Circuit | LOW | LVCMOS33 |
| 37 | TEMP_ALERT | J15 | 3.3V | Input | Temperature Sensor | FPGA | HIGH | LVCMOS33 |
| 38 | POWER_FAULT | K15 | 3.3V | Input | Power Monitor | FPGA | HIGH | LVCMOS33 |
| 39 | TEST_MODE | L14 | 3.3V | Input | DIP Switch | FPGA | LOW | LVCMOS33 |
| 40 | CLK_REF_OUT | M13 | 3.3V | Output | FPGA | External Circuit | - | LVCMOS33 |
| 41 | FPGA_PLL_LOCK | N14 | 3.3V | Output | FPGA | Status Indicator | - | LVCMOS33 |
| 42 | GATE_IN | P14 | 3.3V | Input | External Circuit | FPGA | - | LVCMOS33 |
| 43 | VOLT_MONITOR | R14 | 3.3V | Input | Voltage Monitor | FPGA | - | LVCMOS33 |
| 44 | CURRENT_MONITOR | T14 | 3.3V | Input | Current Monitor | FPGA | - | LVCMOS33 |
| 45 | RF_PWR_DET | U14 | 3.3V | Input | RF Detector | FPGA | - | LVCMOS33 |
| 46 | TEMP_DATA | V14 | 3.3V | Input | Temperature Sensor | FPGA | - | LVCMOS33 |
| 47 | ADDR_LOW | A15 | 3.3V | Output | FPGA | Address Bus | - | LVCMOS33 |
| 48 | ADDR_HIGH | B15 | 3.3V | Output | FPGA | Address Bus | - | LVCMOS33 |
| 49 | DATA_LOW | C15 | 3.3V | Bidirectional | FPGA | Data Bus | - | LVCMOS33 |
| 50 | DATA_HIGH | D15 | 3.3V | Bidirectional | FPGA | Data Bus | - | LVCMOS33 |

---

## 9. Functional Specifications

**Summary table:**

| S.No. | Function Name | Description |
|-------|--------------|-------------|
| 1 | Serial Communication Interface | UART between PC & FPGA via USB-UART (RS232) |
| 2 | High Speed Communication Interface | Ethernet GEM interface for data streaming |
| 3 | Power Supply Sequencing & Health Status | Based on supply voltage, control PA drain voltage and monitor health |
| 4 | Supply Voltage, Current & Temperature Monitoring | I2C-based monitoring |
| 5 | Flash Interfaces | Configuration and Storage flash via SPI/QSPI |
| 6 | RF Control Interface | Digital control of PE8135 RF switch and CGH40010F LNA |
| 7 | FPGA Remote Programming | Configuration loading via communication interface |
| 8 | Phase Shifter Controlling | Phase control for beamforming applications |
| 9 | Beam Steering Calculation | Beam steering logic for antenna array control |

### 9.1 Serial Communication Interface
- Interface type: UART
- Physical layer: RS-232
- Baud rate: 115200 bps (configurable via register)
- Frame format: 1 start bit, 8 data bits, 1 stop bit, no parity
- USB-UART converter IC: FT232RL
- Signals: UART_TX (FPGA → PC), UART_RX (PC → FPGA)
- Protocol: Custom register-based command/response
- Flow control: Hardware CTS/RTS implemented

### 9.2 High Speed Communication Interface
- Interface: Gigabit Ethernet via GEM (Gigabit Ethernet Media) in Zynq
- Number of lanes: 1 (RGMII)
- Data rate: 1 Gbps
- Protocol: TCP/IP stack running on ARM processor
- Physical: RJ45 connector with magnetics
- Features: Jumbo frames support, IEEE 1588 Precision Time Protocol (PTP)

### 9.3 Power On/Off Sequence
#### 9.3.1 Power ON/OFF Sequence
Step-by-step sequence:
1. Input supply (+12V) detected — FPGA_PG_IN asserted
2. 3.3V rail enabled (first power rail)
3. 1.8V rail enabled for FPGA I/O banks
4. 1.0V rail enabled for FPGA core
5. FPGA initialization completes
6. PLL locks and provides system clock
7. Configuration flash loaded
8. System ready signal asserted
9. RF components enabled based on configuration

#### 9.3.2 Mode Configuration
| Mode | Signal | Value | Description |
|------|--------|-------|-------------|
| Normal | TEST_MODE | 0 | Normal operating mode |
| Test | TEST_MODE | 1 | Built-in self-test mode |
| Programming | TEST_MODE | Z | FPGA remote programming mode |

### 9.4 Supply Voltage, Current & Temperature Monitoring
#### 9.4.1 Supply Voltage and Current Monitoring
- IC Part Number: INA219
- Interface: I2C at address 0x40
- Monitored rails: +12V, +5V, +3.3V, +1.8V, +1.0V
- Measurement range: 0 to 26V, 0 to 3.2A
- Resolution: 4mV / 1mA
- Conversion rate: 64 samples per second

#### 9.4.2 Temperature Monitoring
- IC Part Number: TMP100
- Interface: I2C at address 0x48
- Temperature range: -55 to +125°C
- Resolution: 0.5°C (9-bit ADC)
- Alert threshold: Configurable via register
- Conversion rate: 1 sample per second

### 9.5 Flash & Interfaces
#### 9.5.1 Configuration Flash
- Part Number: MT25QL256
- Interface: QSPI (quad SPI)
- Capacity: 256 Mb
- Purpose: Stores FPGA programming bitstream for remote programming
- Programming: Via USB-UART interface through GUI tool

#### 9.5.2 Storage Flash (User Flash)
- Part Number: AT25SF161
- Interface: SPI
- Capacity: 16 Mb
- Purpose: Stores calibration data, attenuation/phase tables, configuration parameters

### 9.6 RF Control Interface
- RF Switch Control (PE8135):
  - Signals: RF_SW_SELECT[0:2], RF_SW_ENABLE
  - Interface: 4-bit parallel control
  - Active state: HIGH = selected
  - Update rate: Configurable via register
  - Purpose: Channel selection for 8:1 RF switch

- LNA Control (CGH40010F):
  - Signals: LNA_GAIN_EN, LNA_BIAS_ADJ
  - Interface: Enable pin and bias adjust
  - Active state: HIGH = enabled
  - Update rate: Real-time
  - Purpose: LNA on/off and gain control

- Limiter Control (MADL-011019):
  - Signals: LIMiter_ENABLE
  - Interface: Simple enable signal
  - Active state: HIGH = enabled
  - Purpose: RF limiter on/off control

### 9.7 FPGA Remote Programming
- Protocol: UART at 115200 bps
- Tool: GUI application on host PC
- Procedure:
  1. Host sends programming command via UART
  2. FPGA enters programming mode (TEST_MODE = Z)
  3. Bitstream transferred in 256-byte packets
  4. Configuration flash written via FPGA SPI master
  5. FPGA reboots from new configuration
- Fallback: JTAG programming via debug header

### 9.8 Phase Shifter Controlling
- Control basis: Frequency, Azimuth angle, Elevation angle
- Interface: SPI (CLK, DATA, LATCH)
- Phase resolution: 6 bits
- Update rate: 100 Hz
- Phase table: Pre-computed and stored in Storage Flash
- Number of channels: 8 (one per RF channel)

### 9.9 Beam Steering Calculation
- Algorithm: Taylor weighting with phase-only control
- Computation: FPGA-based with ARM processor coordination
- Inputs: Target azimuth, elevation, frequency, antenna parameters
- Outputs: Per-element phase shift values
- Update rate: 10 Hz (configurable)
- Control range: ±45 degrees azimuth and elevation

### 9.10 Gate Voltage Writing in DAC
- DAC Part Number: AD5683R
- Interface: SPI
- Number of channels: 4
- Voltage range: 0 to 5V
- Resolution: 16 bits
- Purpose: PA gate bias control for each RF channel
- Update rate: 1 kHz
- Calibration: Factory calibration stored in EEPROM

---

## 10. Software Register Address Map

### 10.1 Register Base Addresses

| Block Name | Base Address | Address Range | Description |
|------------|-------------|---------------|-------------|
| System / Identification | 0x0000 | 0x0000–0x00FF | Board ID, firmware version, status |
| UART Control | 0x0100 | 0x0100–0x01FF | Baud rate, FIFO control, status |
| SPI Control | 0x0200 | 0x0200–0x02FF | SPI master, chip-select control |
| I2C Control | 0x0300 | 0x0300–0x03FF | I2C master, device address, data |
| GPIO | 0x0400 | 0x0400–0x04FF | General purpose I/O control |
| PLL Control | 0x0500 | 0x0500–0x05FF | PLL N/R dividers, status, config |
| Temperature Monitor | 0x0600 | 0x0600–0x06FF | Temp sensor readings, alert threshold |
| Power Monitor | 0x0700 | 0x0700–0x07FF | Voltage/current ADC readings per rail |
| RF Control | 0x0800 | 0x0800–0x08FF | RF switch, LNA, limiter, phase control |
| Flash / EEPROM | 0x0900 | 0x0900–0x09FF | Flash address, data, command register |
| Diagnostics | 0x0A00 | 0x0A00–0x0AFF | Fault log, uptime counter, loopback |

### 10.2 Detailed Register Map

**Block 0x0000 — System / Identification**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|--------------|-------|-----|-------------|----------------------|
| 0x00 | BOARD_ID | 16 | R | 0x4756 | 'GV' ASCII code for gvng project |
| 0x01 | FW_VERSION_MAJOR | 8 | R | 0x01 | Firmware major version |
| 0x02 | FW_VERSION_MINOR | 8 | R | 0x00 | Firmware minor version |
| 0x03 | FW_VERSION_PATCH | 8 | R | 0x00 | Firmware patch version |
| 0x04 | SYS_STATUS | 16 | R | 0x0000 | [15:10] Reserved, [9] PLL_LOCK, [8] TEMP_ALERT, [7] POWER_FAULT, [6] RF_ACTIVE, [5:0] Reserved |
| 0x05 | SYS_CTRL | 16 | R/W | 0x0000 | [15:8] Reserved, [7] SOFT_RESET, [6] WDT_ENABLE, [5] RF_ENABLE, [4] TEST_MODE, [3:0] Reserved |
| 0x06 | UPTIME_COUNTER | 32 | R | 0x00000000 | System uptime in seconds since power-on |

**Block 0x0100 — UART Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|--------------|-------|-----|-------------|----------------------|
| 0x00 | BAUD_RATE | 16 | R/W | 0x0036 | Baud rate divisor = FPGA_CLK / (16 × BAUD_RATE) |
| 0x01 | UART_CTRL | 16 | R/W | 0x0001 | [15:8] Reserved, [7] TX_ENABLE, [6] RX_ENABLE, [5] LOOPBACK, [4] PARITY_EN, [3] EVEN_PARITY, [2] STOP_BIT_2, [1] RTS_FLOW, [0] CTS_FLOW |
| 0x02 | UART_STATUS | 16 | R | 0x0000 | [15:8] Reserved, [7] TX_BUSY, [6] RX_EMPTY, [5] RX_FULL, [4] RX_OVERRUN, [3] FRAME_ERR, [2] PARITY_ERR, [1] BREAK_DET, [0] CTS_STATUS |
| 0x03 | TX_FIFO_COUNT | 8 | R | 0x00 | Number of bytes in TX FIFO (0-64) |
| 0x04 | RX_FIFO_COUNT | 8 | R | 0x00 | Number of bytes in RX FIFO (0-64) |

**Block 0x0200 — SPI Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|--------------|-------|-----|-------------|----------------------|
| 0x00 | SPI_CTRL | 16 | R/W | 0x0000 | [15:12] CLK_DIV (0-15), [11:8] Reserved, [7] MASTER_MODE, [6] RX_ENABLE, [5] TX_ENABLE, [4] POLARITY, [3] PHASE, [2] LSB_FIRST, [1] CONTINUOUS, [0] ENABLE |
| 0x01 | SPI_STATUS | 16 | R | 0x0000 | [15:8] Reserved, [7] BUSY, [6] RX_EMPTY, [5] RX_FULL, [4] TX_EMPTY, [3] TX_FULL, [2] WCOL, [1] SPI_ERROR, [0] SPI_DONE |
| 0x02 | SPI_CS_EN | 8 | R/W | 0x00 | Bitmask for chip-select enable (0=disabled, 1=enabled) |
| 0x03 | SPI_DATA | 16 | R/W | 0x0000 | Data register for SPI transmission/reception |

**Block 0x0300 — I2C Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|--------------|-------|-----|-------------|----------------------|
| 0x00 | I2C_CTRL | 16 | R/W | 0x0000 | [15:8] Reserved, [7] MASTER_MODE, [6] REPEATED_START, [5] GENERAL_CALL, [4] STOP, [3] START, [2] ACK_EN, [1] NAK, [0] I2C_ENABLE |
| 0x01 | I2C_STATUS | 16 | R | 0x0000 | [15:8] Reserved, [7] BUS_BUSY, [6] ARBITRATION_LOST, [5] NAK_RCVD, [4] TX_EMPTY, [3] RX_FULL, [2] TX_EMPTY, [1] RX_FULL, [0] I2C_DONE |
| 0x02 | I2C_ADDR | 8 | R/W | 0x40 | I2C device address (7-bit address << 1) |
| 0x03 | I2C_DATA | 8 | R/W | 0x00 | Data register for I2C transmission/reception |

**Block 0x0400 — GPIO**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|--------------|-------|-----|-------------|----------------------|
| 0x00 | GPIO_DIR | 16 | R/W | 0xFFFF | Bitmask for direction (0=input, 1=output) |
| 0x01 | GPIO_OUT | 16 | R/W | 0x0000 | Output register value (1=high, 0=low) |
| 0x02 | GPIO_IN | 16 | R | 0x0000 | Input register value (1=high, 0=low) |
| 0x03 | GPIO_OE | 16 | R/W | 0xFFFF | Output enable (1=enabled, 0=disabled) |

**Block 0x0500 — PLL Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|--------------|-------|-----|-------------|----------------------|
| 0x00 | PLL_N_DIV | 16 | R/W | 0x0020 | PLL feedback N divider (integer) |
| 0x01 | PLL_R_DIV | 16 | R/W | 0x0001 | PLL reference R divider |
| 0x02 | PLL_F_DIV | 16 | R/W | 0x0000 | Fractional divider (fractional part only) |
| 0x03 | PLL_CTRL | 16 | R/W | 0x0000 | [15:8] Reserved, [7] RESET, [6] BYPASS, [5] POWERDOWN, [4] LOCK_DET_EN, [3] DIVIDE_BY_2, [2] CLKIN_DIV, [1:0] Reserved |
| 0x04 | PLL_STATUS | 16 | R | 0x0000 | [15:8] Reserved, [7] LOCKED, [6] REF_CLK_MISSING, [5] POWER_DOWN, [4:0] Reserved |
| 0x05 | PLL_LOCK_TIMEOUT | 16 | R/W | 0x0064 | Lock timeout in 1ms units (default 100ms) |

**Block 0x0600 — Temperature Monitor**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|--------------|-------|-----|-------------|----------------------|
| 0x00 | TEMP_CONFIG | 8 | R/W | 0x00 | [7:5] Reserved, [4] SHUTDOWN, [3] POLARITY, [2] THERmostat_COMP_IN, [1] THERmostat_MODE, [0] TEMPERATURE_MODE |
| 0x01 | TEMP_THRESHOLD | 16 | R/W | 0x0190 | Temperature threshold in °C (default 25°C) |
| 0x02 | TEMP_ALERT | 16 | R | 0x0000 | [15:8] Reserved, [7] TEMP_HIGH, [6] TEMP_LOW, [5] THERmostat, [4:0] Reserved |
| 0x03 | TEMP_READING | 16 | R | 0x0000 | Temperature reading in °C (resolution 0.5°C) |

**Block 0x0700 — Power Monitor**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|--------------|-------|-----|-------------|----------------------|
| 0x00 | PWR_MONITOR_EN | 8 | R/W | 0x1F | Enable mask for power monitors (bit 0=+12V, bit 1=+5V, etc.) |
| 0x01 | +12V_VOLTAGE | 16 | R | 0x0000 | +12 rail voltage in mV |
| 0x02 | +12V_CURRENT | 16 | R | 0x0000 | +12 rail current in mA |
| 0x03 | +5V_VOLTAGE | 16 | R | 0x0000 | +5 rail voltage in mV |
| 0x04 | +5V_CURRENT | 16 | R | 0x0000 | +5 rail current in mA |
| 0x05 | +3V3_VOLTAGE | 16 | R | 0x0000 | +3.3 rail voltage in mV |
| 0x06 | +3V3_CURRENT | 16 | R | 0x0000 | +3.3 rail current in mA |
| 0x07 | +1V8_VOLTAGE | 16 | R | 0x0000 | +1.8 rail voltage in mV |
| 0x08 | +1V8_CURRENT | 16 | R | 0x0000 | +1.8 rail current in mA |
| 0x09 | +1V0_VOLTAGE | 16 | R | 0x0000 | +1.0 rail voltage in mV |
| 0x0A | +1V0_CURRENT | 16 | R | 0x0000 | +1.0 rail current in mA |

**Block 0x0800 — RF Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|--------------|-------|-----|-------------|----------------------|
| 0x00 | RF_SW_SELECT | 8 | R/W | 0x00 | RF switch channel selection (0-7) |
| 0x01 | RF_SW_ENABLE | 8 | R/W | 0x00 | RF switch enable (1=enabled, 0=disabled) |
| 0x02 | LNA_GAIN | 8 | R/W | 0x00 | LNA gain setting (0-31 for 0-31dB) |
| 0x03 | LNA_BIAS | 8 | R/W | 0x80 | LNA bias control (0-255, default 128) |
| 0x04 | LNA_ENABLE | 8 | R/W | 0x00 | LNA enable (1=enabled, 0=disabled) |
| 0x05 | LIMiter_ENABLE | 8 | R/W | 0x00 | RF limiter enable (1=enabled, 0=disabled) |
| 0x06 | FILTER_SELECT | 8 | R/W | 0x00 | Pre-select filter selection (0-7) |
| 0x07 | TRP_CTRL | 8 | R/W | 0x00 | TRP control register |
| 0x08 | PHASE_DATA0 | 8 | R/W | 0x00 | Phase shifter data channel 0 |
| 0x09 | PHASE_DATA1 | 8 | R/W | 0x00 | Phase shifter data channel 1 |
| 0x0A | PHASE_DATA2 | 8 | R/W | 0x00 | Phase shifter data channel 2 |
| 0x0B | PHASE_DATA3 | 8 | R/W | 0x00 | Phase shifter data channel 3 |
| 0x0C | PHASE_DATA4 | 8 | R/W | 0x00 | Phase shifter data channel 4 |
| 0x0D | PHASE_DATA5 | 8 | R/W | 0x00 | Phase shifter data channel 5 |
| 0x0E | PHASE_DATA6 | 8 | R/W | 0x00 | Phase shifter data channel 6 |
| 0x0F | PHASE_DATA7 | 8 | R/W | 0x00 | Phase shifter data channel 7 |

**Block 0x0900 — Flash / EEPROM**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|--------------|-------|-----|-------------|----------------------|
| 0x00 | FLASH_ADDR | 24 | R/W | 0x000000 | 24-bit flash address |
| 0x01 | FLASH_DATA | 16 | R/W | 0x0000 | Flash data register |
| 0x02 | FLASH_CMD | 8 | R/W | 0x00 | Flash command register |
| 0x03 | FLASH_STATUS | 8 | R | 0x00 | Flash status register |
| 0x04 | EEPROM_ADDR | 16 | R/W | 0x0000 | EEPROM address register |
| 0x05 | EEPROM_DATA | 8 | R/W | 0x00 | EEPROM data register |
| 0x06 | EEPROM_CMD | 8 | R/W | 0x00 | EEPROM command register |

**Block 0x0A00 — Diagnostics**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|--------------|-------|-----|-------------|----------------------|
| 0x00 | FAULT_LOG | 32 | R | 0x00000000 | Fault log register (bit field for different fault types) |
| 0x01 | ERROR_COUNT | 16 | R | 0x0000 | Error counter |
| 0x02 | UPTIME_SECONDS | 32 | R | 0x00000000 | System uptime in seconds |
| 0x03 | UPTIME_MSECONDS | 16 | R | 0x0000 | Uptime milliseconds (LSB) |
| 0x04 | LOOPBACK_CTRL | 8 | R/W | 0x00 | Loopback control register |
| 0x05 | TEST_PATTERN | 16 | R/W | 0x0000 | Test pattern generator |

### 10.3 Register Access Rules
- All registers are 16-bit wide; accessed via UART Single/Bulk Read/Write protocol (Section 9.1)
- Read: set bit15 of address (address OR 0x8000)
- Write: address as-is
- Shadow registers: PLL_N_DIV and PLL_R_DIV are double-buffered; write PLL_CTRL[0]=0 then 1 to apply
- Atomic access: Bulk Write used for multi-register atomic updates (e.g. frequency change)

---

## 11. UART Register Protocol Specification

### 11.1 Physical Layer
- Baud rate: 115200 bps (configurable via UART_CTRL.BAUD_RATE)
- Frame format: 1 start bit, 8 data bits, 1 stop bit, no parity (8N1)
- Physical interface: RS-232
- Signal levels: ±12V logic
- Flow control: Hardware CTS/RTS implemented

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
| Slice LUTs | 44,000 | 18,300 | 41.6% |
| Slice Flip-Flops | 106,400 | 28,700 | 27.0% |
| Block RAM (36Kb) | 1,800 | 420 | 23.3% |
| DSP Slices | 80 | 15 | 18.8% |
| MMCM/PLL | 4 | 2 | 50.0% |
| I/O Buffers | 200 | 90 | 45.0% |

Synthesis tool: Vivado 2022.1
Target device: XC7Z020-1CLG400C
Timing constraint: 125 MHz primary clock

---

## Annexure A — Requirement Traceability Matrix

| S.No. | GLR-ID | Description | Source HRS Section | GLR Section | Verification Method | Status |
|-------|--------|-------------|-------------------|-------------|--------------------|--------|
| 1 | GLR-001 | Serial Communication Interface | HRS §3.1 | 9.1, 11 | Test | Open |
| 2 | GLR-002 | High Speed Communication | HRS §3.1 | 9.2 | Test | Open |
| 3 | GLR-003 | Power Supply Sequencing | HRS §2.5 | 9.3 | Test | Open |
| 4 | GLR-004 | Voltage/Current/Temperature Monitoring | HRS §3.4 | 9.4 | Test | Open |
| 5 | GLR-005 | Flash Interfaces | HRS §3.5 | 9.5 | Test | Open |
| 6 | GLR-006 | RF Control Interface | HRS §3.1 | 9.6 | Inspection | Open |
| 7 | GLR-007 | FPGA Remote Programming | HRS §3.5 | 9.7 | Demonstration | Open |
| 8 | GLR-008 | Phase Shifter Control | HRS §3.1 | 9.8 | Test | Open |
| 9 | GLR-009 | Beam Steering | HRS §3.1 | 9.9 | Analysis | Open |
| 10 | GLR-010 | Register Address Map | HRS §3.5 | 10 | Inspection | Open |
| 11 | GLR-011 | UART Protocol Specification | HRS §3.1 | 11 | Test | Open |
| 12 | GLR-012 | FPGA Resource Budget | HRS §2.5 | 12 | Analysis | Open |
| 13 | GLR-013 | Temperature Monitoring | HRS §2.12 | 9.4.2 | Test | Open |
| 14 | GLR-014 | Power Budget | HRS §2.15 | 9.3 | Test | Open |
| 15 | GLR-015 | Frequency Range | HRS §2.1 | 9.6 | Test | Open |
| 16 | GLR-016 | System Gain | HRS §2.4 | 9.6 | Test | Open |
| 17 | GLR-017 | IIP3 Performance | HRS §2.5 | 9.6 | Test | Open |
| 18 | GLR-018 | Minimum Detectable Signal | HRS §2.8 | 9.6 | Test | Open |
| 19 | GLR-019 | Operating Temperature | HRS §2.12 | 9.3 | Test | Open |
| 20 | GLR-020 | Military Environmental | HRS §2.13 | 9.3 | Test | Open |