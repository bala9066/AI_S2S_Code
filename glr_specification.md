# Glue Logic Requirements (GLR)

## Document Control

| Document Title | Glue Logic Requirements |
| :--- | :--- |
| **Version Date** | 19.04.2026 |
| **Version Number** | 0V01 |
| **Prepared By** | Name: Hardware Design Engineer Sign: \_\_\_\_\_\_\_\_\_\_ |
| **Document Review By** | Name: Firmware Lead & Systems Engineer Sign: \_\_\_\_\_\_\_\_\_\_ |

---

## Amendments to the Document

| S. No. | Ver. No. | Ver. Date | Changed By | Section(s) Changed | Description of Change |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | 0V01 | 19.04.2026 | Hardware Design Engineer | All | Initial Version |

---

## 1. Scope of the Document

This document specifies the I/O details and functional requirements of the Field Programmable Gate Array (FPGA) for the **hm** project — a UHF (300–1000 MHz) pulsed radar receiver module. The FPGA serves as the central digital controller for the superheterodyne RF chain, managing sub-band tuning, frequency synthesis, gain control, power sequencing, and data telemetry. 

This document bridges the Netlist (P4) and FPGA HDL Design (P7) phases. It is targeted at the Hardware Design and Firmware teams to provide a comprehensive specification for FPGA logic implementation, board-level integration, and software driver development.

---

## 2. References

### 2.1 External

| Doc. Type | Part No. | Description |
| :--- | :--- | :--- |
| FPGA Datasheet | XC7S25-1CSGA225 | Xilinx Spartan-7 FPGA Datasheet |
| PLL Synthesizer | ADF4153A | Analog Devices Fractional-N PLL Datasheet |
| VCO | ROS-1080+ | Mini-Circuits Voltage Controlled Oscillator Datasheet |
| IQ Demodulator | LTC5596 | Analog Devices High Linearity I/Q Demodulator Datasheet |
| IF VGA | ADL5330 | Analog Devices Variable Gain Amplifier Datasheet |
| Baseband LPF | LTC1569-7 | Analog Devices Continuous Time Linear Phase Filter Datasheet |
| DC-DC Converter | LTM8074 | Analog Devices Step-Down DC/DC Module Datasheet |
| LDO | LT3045 | Analog Devices Ultra-Low Noise LDO Datasheet |
| RF Switch | HMC253LC4 | Analog Devices SPDT Switch Datasheet |
| EEPROM | AT25SF041 | Renesas 4-Mbit SPI Flash Memory Datasheet |
| Flash Memory | IS25LP016D | ISSI 16-Mbit QSPI Flash Memory Datasheet |
| Temp Sensor | TMP112 | Texas Instruments Digital Temperature Sensor Datasheet |
| USB-UART | FT232H | FTDI USB to UART/FIFO IC Datasheet |

### 2.2 Internal

| Reference | Document |
| :--- | :--- |
| [HRS] | Hardware Requirements Specification (hm_v0V01) |
| [SCH] | Schematic Diagram (hm_sch_revA) |
| [GRS] | General Requirements Specification |
| [GDD] | General Design Document |

---

## 3. Acronyms and Abbreviations

| Acronym | Expansion |
| :--- | :--- |
| FPGA | Field Programmable Gate Array |
| UART | Universal Asynchronous Receiver/Transmitter |
| SPI | Serial Peripheral Interface |
| I2C | Inter-Integrated Circuit |
| GPIO | General Purpose Input/Output |
| JTAG | Joint Test Action Group |
| CLB | Configurable Logic Block |
| DSP | Digital Signal Processing |
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
| VCC | Positive Supply Voltage |
| GND | Ground |
| LO | Local Oscillator |
| PLL | Phase-Locked Loop |
| VCO | Voltage-Controlled Oscillator |
| LNA | Low Noise Amplifier |
| VGA | Variable Gain Amplifier |
| AGC | Automatic Gain Control |
| IF | Intermediate Frequency |
| RF | Radio Frequency |
| MDS | Minimum Discernible Signal |
| MTI | Moving Target Indication |

---

## 4. Module Overview

### RF SECTION
The **hm** module is a fully coherent superheterodyne radar receiver covering 300–1000 MHz (UHF). The RF front end features an RF limiter (SKY16406-321LF) for +20 dBm survivability, followed by a high-linearity LNA (PMA3-83LN+) boasting a 0.69 dB noise figure. Sub-band tuning is achieved via an RF SPDT switch matrix (HMC253LC4) routing signals through a switched filter bank. The selected sub-band is downconverted to a 70 MHz IF using a high-linearity mixer (ADE-25MH+). The LO chain consists of a PLL (ADF4153A) driving a VCO (ROS-1080+), buffered by a GVA-84+ amplifier. At IF, a bandpass filter (BFCG-70A+) provides image rejection, followed by an AGC-driven VGA (ADL5330). The signal is ultimately processed by an I/Q demodulator (LTC5596) yielding differential analog baseband I and Q channels, filtered by linear-phase low-pass filters (LTC1569-7).

### DIGITAL SECTION
The digital core is built around a Xilinx Spartan-7 FPGA (XC7S25-1CSGA225). The FPGA is responsible for deterministic control of the RF chain. Key functions include programming the ADF4153A PLL for fast frequency hopping, controlling the HMC253LC4 SPDT switches for filter bank selection, setting the ADL5330 VGA gain via a SPI DAC, adjusting the LTC1569-7 filter cutoff characteristics, and managing the LTC5596 enable/trip states. It also handles all telemetry data, reading temperature sensors and power monitors via I2C, and exposes a UART register-based command interface to an external host PC or radar controller.

### POWER SUPPLY SECTION
The module operates from a nominal +28VDC input. A high-efficiency buck converter (LTM8074) steps this down to a +5V rail, which powers the RF chain, VCO, and buffer amplifiers. An ultra-low noise LDO (LT3045) regulates the +5V down to a clean +3.3V rail, dedicated to sensitive analog components such as the PLL synthesizer, VCO tuning node, and the FPGA I/O banks. The FPGA core is powered by a dedicated +1.0V rail, with +1.8V supplied for auxiliary FPGA logic and memory interfaces, derived from additional point-of-load switching regulators.

---

## 5. Features

- **FPGA:** Xilinx Spartan-7 (XC7S25-1CSGA225) offering high logic density and low power consumption.
- **On-board Clock Oscillator:** 125 MHz LVCMOS oscillator providing the primary system clock for the FPGA and PLL reference.
- **Communication Interface:** UART via USB-UART bridge (FT232H), capable of up to 12 Mbps data rate for command and telemetry streaming.
- **Debugging Interface:** JTAG (IEEE 1149.1) header for FPGA programming and real-time debug.
- **EEPROM:** AT25SF041 (4-Mbit SPI) for storing non-volatile calibration data and factory configurations.
- **Storage Flash:** IS25LP016D (16-Mbit QSPI) for storing FPGA configuration bitstreams and holding complex look-up tables (LUTs) for AGC and frequency mapping.
- **Frequency Reference:** Internal PLL (ADF4153A) locked to a 125 MHz reference with -100 dBc/Hz phase noise at 10 kHz offset.
- **Temperature Monitoring:** TMP112 digital temperature sensor via I2C interface to monitor PCB hotspot near the LNA.
- **Power Monitoring:** Input power supply voltage and current monitored via FPGA ADC interface.
- **Sub-Band Control:** Dedicated GPIO control for fast switching (<50 ns) of HMC253LC4 RF SPDT filters.

---

## 6. FPGA Description

The Xilinx Spartan-7 FPGA was selected for its optimal balance of size, weight, power (SWaP), and DSP capability. It provides sufficient logic cells to implement a SPI master, I2C master, UART controller, and deterministic control state machines, while offering enough Block RAM to store frequency hop profiles and calibration tables internally.

| S.NO | PARAMETERS | SPECIFICATION |
| :--- | :--- | :--- |
| 1 | Part Number | XC7S25-1CSGA225 |
| 2 | Logic Cells | 23,736 |
| 3 | CLB Flip-Flops | 30,090 |
| 4 | Number of Gates | ~1,200,000 (Equivalent) |
| 5 | Maximum Distributed RAM (Kb) | 182 |
| 6 | Total Block RAM (Kb) | 972 |
| 7 | Maximum Single-Ended I/Os | 130 |
| 8 | Maximum DSP Slices | 40 |
| 9 | No of IO Bank | 4 (Bank 0, 14, 15, 16) |

---

## 7. Block Diagram

The system block diagram illustrates the division of labor between the analog RF front end, power supply, and the FPGA control logic. The FPGA sits as the central digital controller. It connects via SPI to the PLL, Storage Flash, and EEPROM; via GPIO to the RF switches, VGAs, and Demodulator; via I2C to Temperature Sensors; and via UART to the external host.

---

## 8. Pinout Details

**Table: FPGA Pin Out Details**

| S.No | Signal Name | Pin No | Voltage Level | Direction wrt FPGA | Source | Destination | Default Condition | Voltage Standard |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | VCC_1V0_CORE | A6 | 1.0V | Power | DC-DC | FPGA Core | ON | VCC |
| 2 | VCC_1V8_AUX | B7 | 1.8V | Power | LDO | FPGA Aux | ON | VCC |
| 3 | VCCO_33_BANK0 | C8 | 3.3V | Power | LT3045 | FPGA Bank 0 | ON | VCCO |
| 4 | VCCO_33_BANK14 | D9 | 3.3V | Power | LT3045 | FPGA Bank 14 | ON | VCCO |
| 5 | GND | A1, B1... | 0V | Ground | PCB | PCB | 0V | GND |
| 6 | FPGA_CLK_125M | M4 | 3.3V | Input | TXC-125MHz Osc | FPGA PLL | Toggling | LVCMOS33 |
| 7 | JTAG_TCK | R15 | 3.3V | Input | JTAG Header | FPGA | Low | LVCMOS33 |
| 8 | JTAG_TDI | R16 | 3.3V | Input | JTAG Header | FPGA | High | LVCMOS33 |
| 9 | JTAG_TDO | P15 | 3.3V | Output | FPGA | JTAG Header | High-Z | LVCMOS33 |
| 10 | JTAG_TMS | P16 | 3.3V | Input | JTAG Header | FPGA | High | LVCMOS33 |
| 11 | FPGA_RESET_N | N5 | 3.3V | Input | Power Superv. | FPGA | Low (Active) | LVCMOS33 |
| 12 | POR_N | M5 | 3.3V | Output | FPGA | System | High | LVCMOS33 |
| 13 | USB_UART_TX | L12 | 3.3V | Output | FPGA | FT232H RX | High | LVCMOS33 |
| 14 | USB_UART_RX | L13 | 3.3V | Input | FT232H TX | FPGA | High | LVCMOS33 |
| 15 | USB_UART_CTS | M12 | 3.3V | Output | FPGA | FT232H CTS | High | LVCMOS33 |
| 16 | USB_UART_RTS | M13 | 3.3V | Input | FT232H RTS | FPGA | High | LVCMOS33 |
| 17 | SPI_CLK | K10 | 3.3V | Output | FPGA | Clock Tree | Low | LVCMOS33 |
| 18 | SPI_MOSI | K11 | 3.3V | Output | FPGA | Data Chain | Low | LVCMOS33 |
| 19 | SPI_MISO | K12 | 3.3V | Input | Data Chain | FPGA | High-Z | LVCMOS33 |
| 20 | PLL_CS_N | J9 | 3.3V | Output | FPGA | ADF4153A | High | LVCMOS33 |
| 21 | PLL_MUX | J10 | 3.3V | Input | ADF4153A | FPGA | Low | LVCMOS33 |
| 22 | EEPROM_CS_N | J11 | 3.3V | Output | FPGA | AT25SF041 | High | LVCMOS33 |
| 23 | FLASH_CS_N | J12 | 3.3V | Output | FPGA | IS25LP016D | High | LVCMOS33 |
| 24 | I2C_SCL | H9 | 3.3V | Output | FPGA | TMP112 | High | LVCMOS33 |
| 25 | I2C_SDA | H10 | 3.3V | I/O | FPGA / TMP112 | Shared | High | LVCMOS33 |
| 26 | RF_SW_CTRL[0] | G9 | 3.3V | Output | FPGA | HMC253LC4 (U3A) | Low | LVCMOS33 |
| 27 | RF_SW_CTRL[1] | G10 | 3.3V | Output | FPGA | HMC253LC4 (U3B) | Low | LVCMOS33 |
| 28 | RF_SW_CTRL[2] | G11 | 3.3V | Output | FPGA | HMC253LC4 (U3C) | Low | LVCMOS33 |
| 29 | VGA_GAIN_SYNC | F9 | 3.3V | Output | FPGA | ADL5330 | Low | LVCMOS33 |
| 30 | IQ_DEMOD_EN | F10 | 3.3V | Output | FPGA | LTC5596 | Low | LVCMOS33 |
| 31 | TRP_OUT | E9 | 3.3V | Output | FPGA | RF Front End | Low | LVCMOS33 |
| 32 | LNA_DISABLE_N | E10 | 3.3V | Output | FPGA | PMA3-83LN+ | High (ON) | LVCMOS33 |
| 33 | LPF_TUNE_CLK | D10 | 3.3V | Output | FPGA | LTC1569-7 | Low | LVCMOS33 |
| 34 | FPGA_DONE | N4 | 3.3V | Output | FPGA | Status LED | High | LVCMOS33 |
| 35 | FPGA_INIT_N | P3 | 3.3V | Output | FPGA | Status LED | High | LVCMOS33 |
| 36 | VCO_PWR_DWN_N | C10 | 3.3V | Output | FPGA | ROS-1080+ | High (ON) | LVCMOS33 |
| 37 | PSU_PG_IN | B9 | 3.3V | Input | Power Superv. | FPGA | High | LVCMOS33 |
| 38 | LED_STATUS | A9 | 3.3V | Output | FPGA | Debug LED | Low | LVCMOS33 |

---

## 9. Functional Specifications

| S.No. | Function Name | Description |
| :--- | :--- | :--- |
| 1 | Serial Communication Interface | UART between PC & FPGA via USB-UART (RS422/RS232) for command and telemetry. |
| 2 | High Speed Communication Interface | Not applicable (Analog out module); instead, optimized SPI bus running at 25 MHz. |
| 3 | Power Supply Sequencing & Health Status | Based on supply voltage, control PA/LNA drain voltage and monitor health. |
| 4 | Supply Voltage, Current & Temperature Monitoring | I2C-based monitoring via TMP112 and discrete ADC measurements. |
| 5 | Flash Interfaces | Configuration and Storage flash via SPI/QSPI. |
| 6 | TRP Configuration | TRP signal for coherent pulse RF ON/OFF control. |
| 7 | FPGA Remote Programming | Configuration loading via communication interface. |
| 8 | Phase Shifter Controlling | Not applicable; replaced by Frequency Synthesizer (PLL) fast-hopping control. |
| 9 | Switched Filter Bank Control | GPIO-based deterministic control for sub-band tuning. |

### 9.1 Serial Communication Interface
- **Interface type:** UART
- **Physical layer:** USB to RS-485 (via FT232H)
- **Baud rate:** 12 Mbps (maximum)
- **Frame format:** 1 start bit, 8 data bits, 1 stop bit, no parity (8N1)
- **USB-UART converter IC:** FT232H
- **Signals:** USB_UART_TX (FPGA → Host), USB_UART_RX (Host → FPGA)
- **Protocol:** Custom register-based command/response (Defined in Section 11).

### 9.2 High Speed Communication Interface
- **Interface:** High-Speed SPI (Mode 0)
- **Number of lanes:** 1
- **Data rate per lane:** 25 MHz (max)
- **Protocol:** Custom SPI with 24-bit / 32-bit words depending on target peripheral.
- **Physical:** Point-to-point PCB traces.

### 9.3 Power On/Off Sequence

#### 9.3.1 Power ON/OFF Sequence
1. Input supply (+28V) detected — DC-DC converter initializes, PSU_PG_IN goes HIGH.
2. FPGA core voltages enabled (1.0V → 1.8V → 3.3V sequencing).
3. FPGA_DONE signal asserted after configuration load from IS25LP016D Flash.
4. LNA_DISABLE_N set HIGH (LNA enabled), VCO_PWR_DWN_N set HIGH (VCO enabled).
5. PLL programmed to default tuning word, PLL_MUX locked status verified.
6. IQ_DEMOD_EN set HIGH. System READY status via telemetry.

#### 9.3.2 Mode Configuration
| Mode | Signal | Value | Description |
| :--- | :--- | :--- | :--- |
| Normal | MODE[1:0] | 2'b00 | Normal operating mode (RX Active) |
| Test | MODE[1:0] | 2'b01 | Built-in self-test (LPF, Loopbacks active) |
| Programming | MODE[1:0] | 2'b10 | FPGA remote programming mode (Flash write) |

### 9.4 Supply Voltage, Current & Temperature Monitoring

#### 9.4.1 Supply Voltage and Current Monitoring
- **IC Part Number:** Discrete implementation using FPGA internal logic + external passives (derived from analog comparators/VIP). Future revision: LTC2992.
- **Monitored rails:** +28V, +5V, +3.3V.
- **Measurement range:** 0 to 32V.
- **Resolution:** ~10mV.

#### 9.4.2 Temperature Monitoring
- **IC Part Number:** TMP112
- **Interface:** I2C at address 0x48
- **Temperature range:** -40°C to +125°C
- **Resolution:** 0.0625°C (12-bit ADC)
- **Alert threshold:** 85°C (Power Limit) and 95°C (Shutdown limit).

### 9.5 Flash & Interfaces

#### 9.5.1 Configuration Flash
- **Part Number:** IS25LP016D
- **Interface:** QSPI (quad SPI)
- **Capacity:** 16 Mbit
- **Purpose:** Stores FPGA programming bitstream for remote programming and boot.
- **Programming:** Via USB-UART interface through GUI tool.

#### 9.5.2 Storage Flash (User Flash)
- **Part Number:** AT25SF041
- **Interface:** SPI
- **Capacity:** 4 Mbit
- **Purpose:** Stores calibration data, frequency hopping tables, and AGC threshold settings.

### 9.6 TRP Configuration
- **Signal:** TRP_OUT (Transmit/Receive Pulse)
- **Direction:** FPGA → RF front-end / System Controller
- **Logic level:** 3.3V LVCMOS
- **Active state:** HIGH = RX gate enabled (coherent processing window open)
- **Timing:** Synchronous to 125 MHz clock; minimum 1 µs gate width (matches radar pulse constraints).
- **Control:** Written via UART register command.

### 9.7 FPGA Remote Programming
- **Protocol:** UART at 12 Mbps
- **Tool:** Custom GUI application on host PC
- **Procedure:**
  1. Host sends programming command via UART.
  2. FPGA enters programming mode (MODE = 2'b10).
  3. Bitstream transferred in 256-byte packets.
  4. Configuration flash (IS25LP016D) written via FPGA QSPI master.
  5. FPGA reboots from new configuration via JTAG_STARTUP primitive.
- **Fallback:** JTAG programming via debug header.

### 9.8 Frequency Synthesizer (PLL) Control
- **Control basis:** Target RF frequency (300-1000 MHz).
- **Interface:** SPI (3-wire: SPI_CLK, SPI_MOSI, PLL_CS_N).
- **Target IC:** ADF4153A
- **Update rate:** Up to 500 kHz hop rate.
- **PLL Register Structure:** Requires loading R, N, and Function registers on each frequency change.

### 9.9 Switched Filter Bank Control
- **Control basis:** Selected Sub-Band.
- **Interface:** Direct GPIO (RF_SW_CTRL[0:2]).
- **Latency:** < 50 ns (determined by HMC253LC4 specs).
- **Truth Table:** Mapped directly to target frequency ranges to ensure appropriate preselection.

### 9.10 VGA and Baseband Configuration
- **VGA Control (ADL5330):** Gain adjusted via parallel or SPI-driven DAC logic mapped from `VGA_GAIN_SYNC` and SPI packet. Gain range ~ -30 dB to +17 dB.
- **Baseband LPF (LTC1569-7):** Filter cutoff tuned via `LPF_TUNE_CLK` clock-rate logic to maintain <1 ns group delay variation across 1-10 MHz IBW.

---

## 10. Software Register Address Map

This section defines the complete FPGA register address space as seen by the host software over the UART interface.

### 10.1 Register Base Addresses

| Block Name | Base Address | Address Range | Description |
| :--- | :--- | :--- | :--- |
| System / Identification | 0x0000 | 0x0000–0x00FF | Board ID, firmware version, status, mode |
| UART Control | 0x0100 | 0x0100–0x01FF | Baud rate, FIFO control, status |
| SPI Control | 0x0200 | 0x0200–0x02FF | SPI master, chip-select control |
| I2C Control | 0x0300 | 0x0300–0x03FF | I2C master, TMP112 temp reads |
| GPIO | 0x0400 | 0x0400–0x04FF | General purpose I/O control (RF Switches, Enables) |
| PLL Control | 0x0500 | 0x0500–0x05FF | ADF4153A N/R dividers, status, config |
| Temperature Monitor | 0x0600 | 0x0600–0x06FF | Temp sensor readings, alert threshold |
| Power Monitor | 0x0700 | 0x0700–0x07FF | Voltage input status |
| RF Control | 0x0800 | 0x0800–0x08FF | TRP, IQ Demod, VGA gain, LPF tune |
| Flash / EEPROM | 0x0900 | 0x0900–0x09FF | Flash address, data, command register |
| Diagnostics | 0x0A00 | 0x0A00–0x0AFF | Fault log, uptime counter, loopback |

### 10.2 Detailed Register Map

**Block 0x0000 — System / Identification**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 0x00 | BOARD_ID | 16 | R | 0x000A | Board identification code (0x000A for hm UHF RX) |
| 0x01 | FW_VERSION_MAJOR | 16 | R | 0x0001 | Firmware major version |
| 0x02 | FW_VERSION_MINOR | 16 | R | 0x0000 | Firmware minor version |
| 0x03 | SYS_STATUS | 16 | R | 0x0000 | [15:8] Reserved, [7] PLL_LOCKED, [6] TEMP_ALERT, [5] VOLT_FAULT, [4:0] Reserved |
| 0x04 | SYS_CTRL | 16 | R/W | 0x0000 | [0] SOFT_RESET, [1] WDT_ENABLE, [2] RF_ENABLE |

**Block 0x0100 — UART Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 0x00 | BAUD_DIV | 16 | R/W | 0x0036 | Baud rate divisor = FPGA_CLK / (16 × BAUD_RATE) |
| 0x01 | UART_CTRL | 16 | R/W | 0x0001 | [0] UART_ENABLE, [1] LOOPBACK_EN, [2] CRC_EN |
| 0x02 | UART_STATUS | 16 | R | 0x0000 | [0] TX_BUSY, [1] RX_AVAIL, [2] RX_OVERRUN, [3] FRAME_ERR |
| 0x03 | TX_FIFO_COUNT | 16 | R | 0x0000 | Number of bytes in TX FIFO |
| 0x04 | RX_FIFO_COUNT | 16 | R | 0x0000 | Number of bytes in RX FIFO |

**Block 0x0200 — SPI Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 0x00 | SPI_CLK_DIV | 16 | R/W | 0x0005 | SPI clock divisor (125 MHz / (2 * Div)) |
| 0x01 | SPI_CTRL | 16 | R/W | 0x0000 | [0] SPI_START, [1] CPOL, [2] CPHA, [3] SPI_BUSY |
| 0x02 | SPI_CS_SEL | 16 | R/W | 0x0000 | [0] PLL_CS_N, [1] EEPROM_CS_N, [2] FLASH_CS_N |
| 0x03 | SPI_TX_DATA | 16 | R/W | 0x0000 | TX data register |
| 0x04 | SPI_RX_DATA | 16 | R | 0x0000 | RX data register |

**Block 0x0300 — I2C Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 0x00 | I2C_CTRL | 16 | R/W | 0x0000 | [0] I2C_START, [1] I2C_RW (0=W, 1=R), [2] I2C_BUSY |
| 0x01 | I2C_DEV_ADDR | 16 | R/W | 0x0048 | TMP112 I2C Device Address (7-bit left shifted) |
| 0x02 | I2C_REG_ADDR | 16 | R/W | 0x0000 | TMP112 Internal Register Pointer |
| 0x03 | I2C_DATA_H | 16 | R | 0x0000 | Upper byte of I2C Read Data |
| 0x04 | I2C_DATA_L | 16 | R | 0x0000 | Lower byte of I2C Read Data |

**Block 0x0400 — GPIO**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 0x00 | GPIO_OUTPUT | 16 | R/W | 0x0400 | [0] RF_SW_0, [1] RF_SW_1, [2] RF_SW_2, [10] LNA_DISABLE_N (1=ON) |
| 0x01 | GPIO_INPUT | 16 | R | 0x0000 | [0] PSU_PG_IN |
| 0x02 | GPIO_DIRECTION | 16 | R/W | 0x0400 | Direction config (1=OUT, 0=IN). Default LNA & Switches OUT. |

**Block 0x0500 — PLL Control (ADF4153A)**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 0x00 | PLL_R_DIV | 16 | R/W | 0x0001 | R divider value (Ref divider) |
| 0x01 | PLL_N_DIV | 16 | R/W | 0x0020 | N divider value (INT portion) |
| 0x02 | PLL_FRAC_DIV | 16 | R/W | 0x0000 | FRAC divider value (12-bit) |
| 0x03 | PLL_CTRL | 16 | R/W | 0x0000 | [0] PLL_LOAD_EN, [1] PLL_RESET, [2] PLL_MUX_EN |
| 0x04 | PLL_STATUS | 16 | R | 0x0000 | [0] PLL_LOCKED (from PLL_MUX), [1] SPI_XFER_DONE |

**Block 0x0600 — Temperature Monitor**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 0x00 | TEMP_VALUE | 16 | R | 0x0000 | 12-bit temperature reading from TMP112 |
| 0x01 | TEMP_ALERT_HI | 16 | R/W | 0x0AA0 | High alert threshold (85°C) |
| 0x02 | TEMP_ALERT_LO | 16 | R/W | 0x0500 | Low alert threshold (-40°C) |
| 0x03 | TEMP_STATUS | 16 | R | 0x0000 | [0] ALERT_ACTIVE |

**Block 0x0700 — Power Monitor**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 0x00 | PWR_STATUS | 16 | R | 0x0000 | [0] VCC_28V_OK, [1] VCC_5V_OK, [2] VCC_3V3_OK, [3] VCC_1V8_OK |

**Block 0x0800 — RF Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 0x00 | VGA_GAIN | 16 | R/W | 0x0800 | 10-bit gain setting for ADL5330 (via SPI DAC logic) |
| 0x01 | TRP_CONFIG | 16 | R/W | 0x0000 | [0] TRP_EN, [1] TRP_POLARITY |
| 0x02 | IQ_DEMOD_CTRL | 16 | R/W | 0x0000 | [0] IQ_DEMOD_EN, [1] IQ_PWR_DWN |
| 0x03 | LPF_CTRL | 16 | R/W | 0x0000 | [3:0] LPF_TUNE_VAL (Cutoff tuning for LTC1569-7) |

**Block 0x0900 — Flash / EEPROM**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 0x00 | FLASH_ADDR | 16 | R/W | 0x0000 | Flash Address Pointer |
| 0x01 | FLASH_DATA | 16 | R/W | 0x0000 | Flash Data Payload (16-bit) |
| 0x02 | FLASH_CMD | 16 | R/W | 0x0000 | [0] ERASE_CMD, [1] WRITE_CMD, [2] READ_CMD |

**Block 0x0A00 — Diagnostics**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 0x00 | DIAG_FAULT_LOG | 16 | R | 0x0000 | Latched fault flags (Temp, Volt) |
| 0x01 | DIAG_UPTIME | 16 | R | 0x0000 | System uptime in seconds |

### 10.3 Register Access Rules
- All registers are 16-bit wide; accessed via UART Single/Bulk Read/Write protocol (Section 11).
- Read operation: Set bit15 of address (address OR 0x8000).
- Write operation: Address as-is (bit15 cleared).
- Shadow registers: PLL_N_DIV, PLL_FRAC_DIV, and PLL_R_DIV are double-buffered; logic pushes all upon writing `PLL_CTRL[0] = 1`.
- Atomic access: Bulk Write is used for multi-register atomic updates (e.g., full frequency profile changes).

---

## 11. UART Register Protocol Specification

This section provides the EXACT byte-level frame format for the UART register protocol. Firmware MUST implement this exactly.

### 11.1 Physical Layer
- **Baud rate:** 12 Mbps (configurable via `REG_UART_BASE + 0x00` `BAUD_DIV`)
- **Frame format:** 1 start bit, 8 data bits, 1 stop bit, no parity (8N1)
- **Physical interface:** USB-UART (FT232H)
- **Signal levels:** 3.3V LVCMOS logic between FPGA and FT232H, USB on host side.

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
  - Address out of valid range (e.g. > 0x0AFF)
  - Write to read-only register
  - Parser timeout (inter-byte gap > 50ms)
```

### 11.3 Protocol Timing Constraints

| Parameter | Min | Typical | Max | Unit |
| :--- | :--- | :--- | :--- | :--- |
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
| :--- | :--- | :--- | :--- |
| Slice LUTs | 14,540 | 2,900 | 20% |
| Slice Flip-Flops | 17,400 | 1,800 | 10% |
| Block RAM (36Kb) | 27 | 5 | 18% |
| DSP Slices | 40 | 0 | 0% |
| MMCM/PLL | 3 | 1 | 33% |
| I/O Buffers | 130 | 32 | 24% |

**Synthesis tool:** Vivado 2024.1
**Target device:** XC7S25-1CSGA225
**Timing constraint:** 125.000 MHz primary clock

---

## Annexure A — Requirement Traceability Matrix

| S.No. | GLR-ID | Description | Source HRS Section | GLR Section | Verification Method | Status |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | GLR-001 | Serial Communication Interface | REQ-HW-018, 019 | 9.1, 11 | Test | Open |
| 2 | GLR-002 | High Speed Communication / SPI | REQ-HW-024 | 9.2 | Test | Open |
| 3 | GLR-003 | Power Supply Sequencing & Health Status | REQ-HW-023 | 9.3 | Test | Open |
| 4 | GLR-004 | Voltage/Current/Temperature Monitoring | REQ-HW-023, 017 | 9.4 | Test | Open |
| 5 | GLR-005 | Flash Interfaces (EEPROM/Flash) | REQ-HW-001 | 9.5 | Test | Open |
| 6 | GLR-006 | TRP Configuration (Pulse Control) | REQ-HW-013, 016 | 9.6 | Inspection | Open |
| 7 | GLR-007 | FPGA Remote Programming | System Architecture | 9.7 | Demonstration | Open |
| 8 | GLR-008 | Frequency Synthesizer (PLL) Control | REQ-HW-011, 024 | 9.8 | Test | Open |
| 9 | GLR-009 | Switched Filter Bank Control | REQ-HW-012 | 9.9 | Test | Open |
| 10 | GLR-010 | VGA & Baseband Filter Control | REQ-HW-003, 015 | 9.10 | Test | Open |
| 11 | GLR-011 | Register Address Map (UART / SPI) | REQ-HW-018 | 10 | Inspection | Open |
| 12 | GLR-012 | UART Protocol Specification | REQ-HW-018 | 11 | Test | Open |
| 13 | GLR-013 | FPGA Resource Budget Utilization | System Constraints | 12 | Analysis | Open |