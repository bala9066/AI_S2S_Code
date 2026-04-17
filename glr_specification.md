
# Glue Logic Requirements (GLR)

## Document Control
| Document Title | Glue Logic Requirements |
| :--- | :--- |
| **Version Date** | 17.04.2026 |
| **Version Number** | 0V01 |
| **Prepared By** | Name: . Sign: ____________________ |
| **Document Review By** | Name: . Sign: ____________________ |

---

## Amendments to the Document
| S. No. | Ver. No. | Ver. Date | Changed By | Section(s) Changed | Description of Change |
|:---:|:---:|:---:|:---:|:---:|:---|
| 1 | 0V01 | 17.04.2026 | - | - | Initial Release for Project JHF |

---

## 1. Scope of the Document
This document defines the input/output (I/O) details, functional requirements, and register map specifications for the FPGA utilized within the **JHF Wideband RF Receiver**.
The JHF receiver comprises a wideband RF front-end (5–18 GHz) and a control interface. The FPGA serves as the central logic controller, managing the Local Oscillator (LO) synthesizer, the digital Variable Gain Amplifier (VGA), and system health monitoring via a UART interface.
This document acts as the bridge between the Hardware Requirements Specification (HRS) and the FPGA HDL Design phase.

---

## 2. References

### 2.1 External
| Doc. Type | Part No. | Description |
|:---:|:---:|:---|
| Datasheet | **HMC698LP4** | Digital Variable Gain Amplifier (VGA), 6-bit Serial Control |
| Datasheet | **ADF5356** | Wideband Synthesizer with Integrated VCO (13.6 GHz) |
| Datasheet | **LT3042** | Ultra Low Noise LDO (3.3V Rail) |
| Datasheet | **LM2991** | Negative Regulator (-5V Rail) |
| Datasheet | **XC7A35T-1CPG238C** | Xilinx Artix-7 FPGA (Target Device) |
| Datasheet | **FTDI FT2232H** | USB-UART Multi-Protocol Synchronous Serial Engine |
| Datasheet | **AT25M01-SSHM-T** | 1Mb SPI EEPROM for Configuration/Storage |
| Datasheet | **LTC2992** | Dual Current/Voltage Monitor (I2C) |
| Datasheet | **AD7416** | 10-Bit Temperature Sensor & Voltage Monitor (I2C) |

### 2.2 Internal
| Reference | Document |
|:---|:---|
| [HRS] | JHF Hardware Requirements Specification (P1/P2) |
| [SCH] | JHF Schematic Capture (Netlist P4) |
| [GRS] | JHF General Requirements Specification |
| [GDD] | JHF General Design Document |

---

## 3. Acronyms and Abbreviations
| Acronym | Expansion |
|:---|:---|
| **ADC** | Analog-to-Digital Converter |
| **BOM** | Bill of Materials |
| **BRAM** | Block RAM (FPGA Resource) |
| **CLB** | Configurable Logic Block |
| **CPLD** | Complex Programmable Logic Device |
| **DAC** | Digital-to-Analog Converter |
| **DSP** | Digital Signal Processing / Slice |
| **EMC** | Electromagnetic Compatibility |
| **FF** | Flip-Flop |
| **FIFO** | First-In-First-Out Buffer |
| **FPGA** | Field Programmable Gate Array |
| **GND** | Ground |
| **HDL** | Hardware Description Language |
| **I2C** | Inter-Integrated Circuit (Serial Bus) |
| **IF** | Intermediate Frequency |
| **JTAG** | Joint Test Action Group |
| **LED** | Light Emitting Diode |
| **LFSR** | Linear Feedback Shift Register |
| **LNA** | Low Noise Amplifier |
| **LO** | Local Oscillator |
| **LUT** | Look-Up Table |
| **MISO** | Master In Slave Out |
| **MOSI** | Master Out Slave In |
| **PCB** | Printed Circuit Board |
| **PLL** | Phase Locked Loop |
| **RoHS** | Restriction of Hazardous Substances |
| **RTL** | Register Transfer Level |
| **RX** | Receive |
| **SPI** | Serial Peripheral Interface |
| **SSTL** | Stub Series Terminated Logic |
| **TX** | Transmit |
| **UART** | Universal Asynchronous Receiver-Transmitter |
| **VCC** | Voltage Common Collector (Supply) |
| **VGA** | Variable Gain Amplifier |
| **VCO** | Voltage Controlled Oscillator |

---

## 4. Module Overview

The JHF Wideband Receiver Module is a high-frequency down-conversion unit designed for military applications. It converts 5–18 GHz RF signals to a processable IF output (100 MHz – 2 GHz).

**RF SECTION:**
The RF chain utilizes an **HMC6180LP4E** LNA followed by an **HMC558LC4** Mixer. The local oscillator signal is provided by an **ADF5356** wideband synthesizer. Gain control is managed by an **HMC698LP4** digital VGA positioned in the IF path prior to the **ADL5541** IF amplifier.

**DIGITAL SECTION:**
The digital core is the **XC7A35T** Artix-7 FPGA. The FPGA implements a UART-to-SPI bridge, allowing the host system to configure the LO frequency (via ADF5356 SPI) and the IF Gain (via HMC698LP4 SPI). The FPGA also manages power-up sequencing, monitors system health (via I2C ADC/Sensors), and provides status indicators.

**POWER SUPPLY SECTION:**
The system operates from a **+12V DC** input supply. An **LM22676-12** Buck regulator provides distribution logic. **LT3042** generates the clean +3.3V rail for the FPGA and logic, while **LM2991** generates the -5V rail required by the RF mixers/VGA. The FPGA monitors the 12V and 3.3V rails via an I2C power monitor (LTC2992).

---

## 5. Features
- **FPGA:** Xilinx Artix-7 XC7A35T-1CPG238C (CPG238 Package)
- **On-board Clock:** 40 MHz CMOS Oscillator (Low Jitter)
- **Control Interface:** UART to USB (FTDI FT2232H on carrier), 3.0 Mbps capable
- **JTAG:** Standard 14-pin header (2.54mm pitch) for Xilinx programming/debug
- **LO Synthesis:** ADF5356 SPI interface (3-wire serial)
- **Gain Control:** HMC698LP4 SPI interface (Data/CLK/Latch)
- **Power Monitoring:** LTC2992 via I2C (Voltage/Current)
- **Temp Monitoring:** AD7416 via I2C (Internal/External Temp)
- **Configuration:** SPI Flash (AT25M01) for remote update/storage
- **Status Indicators:** RGB LED (Power/Lock/Fault)
- **Protection:** Schottky diode reverse polarity protection + Ferrite bead filtering

---

## 6. FPGA Description

The Xilinx Artix-7 family was selected for its balance of logic density, low power consumption, and robust I/O options. The CPG238 package offers ample I/O banks to interface with 3.3V logic and the specific voltage levels required by the RF components.

| S.NO | PARAMETERS | SPECIFICATION |
|:---:|:---|:---|
| 1 | Part Number | XC7A35T-1CPG238C |
| 2 | Logic Cells | 33,280 |
| 3 | CLB Flip-Flops | 41,600 |
| 4 | Number of Gates | ~500,000 (ASIC equiv.) |
| 5 | Maximum Distributed RAM (Kb) | 225 |
| 6 | Total Block RAM (Kb) | 1,800 (50 x 36Kb) |
| 7 | Maximum Single-Ended I/Os | 180 |
| 8 | Maximum DSP Slices | 90 (DSP48E1) |
| 9 | No of IO Bank | 4 (Banks 13, 14, 15, 16) |

---

## 7. Block Diagram
*(Reference Block Diagram Description)*
The FPGA is the central controller.
1. **Input:** USB-UART (RX/TX) from Host PC.
2. **Outputs:** SPI buses to the ADF5356 (LO) and HMC698LP4 (VGA).
3. **Monitor:** I2C bus to LTC2992 (Power) and AD7416 (Temp).
4. **Storage:** SPI bus to AT25M01 EEPROM.
5. **Feedback:** Lock detect signal from ADF5356 (MUXOUT pin) routed to FPGA GPIO.

---

## 8. Pinout Details

**Table: FPGA Pin Out Details (Target: XC7A35T-CPG238)**

| S.No | Signal Name | Pin No (Pkg) | Voltage Level | Direction wrt FPGA | Source | Destination | Default Condition | Voltage Standard |
|:---:|:---|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| 1 | VCCINT | N/A | 1.0V | PWR | Power Supply | FPGA Core | ON | N/A |
| 2 | VCCAUX | N/A | 1.8V | PWR | Power Supply | FPGA Aux | ON | N/A |
| 3 | VCCO_13 | N/A | 3.3V | PWR | LDO LT3042 | Bank 13 | ON | N/A |
| 4 | GND | N/A | 0V | PWR | GND Plane | FPGA GND | ON | N/A |
| 5 | FPGA_CLK_40M | L14 | 3.3V | IN | Oscillator | PLL/MMCM | High-Z | LVCMOS33 |
| 6 | FPGA_RESET_N | M13 | 3.3V | IN | Reset Button | Sys Ctrl | Pull Up | LVCMOS33 |
| 7 | UART_TX | N13 | 3.3V | OUT | FPGA UART | USB-UART (RX) | High | LVCMOS33 |
| 8 | UART_RX | M14 | 3.3V | IN | USB-UART (TX) | FPGA UART | High | LVCMOS33 |
| 9 | UART_CTS | L12 | 3.3V | IN | USB-UART | FPGA Flow Ctrl | High | LVCMOS33 |
| 10 | UART_RTS | K14 | 3.3V | OUT | FPGA Flow Ctrl | USB-UART | High | LVCMOS33 |
| 11 | TCK | A12 | 3.3V | IN | JTAG Debugger | JTAG TAP | Pull Up | LVCMOS33 |
| 12 | TDI | C12 | 3.3V | IN | JTAG Debugger | JTAG TAP | Pull Up | LVCMOS33 |
| 13 | TDO | B12 | 3.3V | OUT | JTAG TAP | JTAG Debugger | High | LVCMOS33 |
| 14 | TMS | D12 | 3.3V | IN | JTAG Debugger | JTAG TAP | Pull Up | LVCMOS33 |
| 15 | SPI_LO_CLK | J14 | 3.3V | OUT | FPGA SPI Master | ADF5356 CLK | Low | LVCMOS33 |
| 16 | SPI_LO_MOSI | K13 | 3.3V | OUT | FPGA SPI Master | ADF5356 DATA | Low | LVCMOS33 |
| 17 | SPI_LE_LO | H14 | 3.3V | OUT | FPGA SPI Master | ADF5356 LE | Low | LVCMOS33 |
| 18 | LO_MUXOUT_LOCK | L13 | 3.3V | IN | ADF5356 MUXOUT | FPGA GPIO | High | LVCMOS33 |
| 19 | SPI_VGA_CLK | F14 | 3.3V | OUT | FPGA SPI Master | HMC698LP4 CLK | Low | LVCMOS33 |
| 20 | SPI_VGA_DATA | G14 | 3.3V | OUT | FPGA SPI Master | HMC698LP4 DATA | Low | LVCMOS33 |
| 21 | SPI_LE_VGA | E13 | 3.3V | OUT | FPGA SPI Master | HMC698LP4 LE | Low | LVCMOS33 |
| 22 | I2C_SCL | K12 | 3.3V | Bi-Di | FPGA I2C Master | Temp/Pwr ICs | Pull Up | LVCMOS33 |
| 23 | I2C_SDA | L15 | 3.3V | Bi-Di | FPGA I2C Master | Temp/Pwr ICs | Pull Up | LVCMOS33 |
| 24 | SPI_EEPROM_CLK | P13 | 3.3V | OUT | FPGA SPI Master | AT25M01 CLK | Low | LVCMOS33 |
| 25 | SPI_EEPROM_MISO | R13 | 3.3V | IN | AT25M01 SO | FPGA SPI | High | LVCMOS33 |
| 26 | SPI_EEPROM_MOSI | T13 | 3.3V | OUT | FPGA SPI Master | AT25M01 SI | Low | LVCMOS33 |
| 27 | SPI_EEPROM_CS | P14 | 3.3V | OUT | FPGA SPI Master | AT25M01 CS | High | LVCMOS33 |
| 28 | LED_STATUS_R | T12 | 3.3V | OUT | FPGA GPIO | LED Red | Low | LVCMOS33 |
| 29 | LED_STATUS_G | R12 | 3.3V | OUT | FPGA GPIO | LED Green | Low | LVCMOS33 |
| 30 | LED_STATUS_B | P15 | 3.3V | OUT | FPGA GPIO | LED Blue | Low | LVCMOS33 |
| 31 | FPGA_DONE | N12 | 1.8V/3.3V | OUT | FPGA Config | Ext Indicator | Low | LVCMOS33 |
| 32 | FPGA_INIT_N | M16 | 3.3V | IN | Power Monitor | FPGA Config | Pull Up | LVCMOS33 |
| 33 | PROG_B | N16 | 3.3V | IN | Prog Button | FPGA Config | Pull Up | LVCMOS33 |
| 34 | TEMP_ALERT | K15 | 3.3V | IN | AD7416 ALERT | FPGA IRQ | High | LVCMOS33 |
| 35 | PGOOD_3V3 | J15 | 3.3V | IN | LT3042 PGOOD | FPGA GPIO | High (until OK) | LVCMOS33 |
| 36 | RF_ENABLE_N | G13 | 3.3V | OUT | FPGA GPIO | LNA Enable (via FET) | Low (Active) | LVCMOS33 |
| 37 | DAC_VREF_OUT | H13 | 3.3V | OUT | FPGA (PWM Filtered) | Test Point | N/A | LVCMOS33 |
| 38 | GPIO_1 | F13 | 3.3V | IO | FPGA | Expansion | High-Z | LVCMOS33 |
| 39 | GPIO_2 | E14 | 3.3V | IO | FPGA | Expansion | High-Z | LVCMOS33 |
| 40 | GPIO_3 | D14 | 3.3V | IO | FPGA | Expansion | High-Z | LVCMOS33 |

---

## 9. Functional Specifications

| S.No. | Function Name | Description |
|:---:|:---|:---|
| 1 | Serial Communication Interface | UART between Host PC & FPGA for control/data (115200 default, up to 3Mbps) |
| 2 | RF Synthesizer Control | 3-wire SPI interface to ADF5356 for frequency tuning (5-18 GHz band) |
| 3 | Gain Control | 3-wire SPI interface to HMC698LP4 for 0.5dB step gain adjustment |
| 4 | Power Supply Monitoring | I2C interface to LTC2992 for 12V/3.3V rail health and current consumption |
| 5 | Temperature Monitoring | I2C interface to AD7416 for onboard die temperature monitoring |
| 6 | Configuration Storage | SPI interface to AT25M01 EEPROM for lookup tables & calibration data |
| 7 | RF Safety Interlock | Control logic for RF_ENABLE_N to prevent transmission during fault |
| 8 | Lock Detection | Hardware monitoring of ADF5356 MUXOUT pin for PLL lock verification |
| 9 | LED Indication | RGB Status LED driver logic (Power, Lock, Error) |

### 9.1 Serial Communication Interface
- **Interface:** UART
- **Physical:** RS-232 Levels (via MAX232 or similar transceiver on host side) or 3.3V TTL USB-UART.
- **Baud Rate:** 3,000,000 bps (3 Mbps) default for rapid config; 115,200 bps fallback.
- **Frame Format:** 1 Start bit, 8 Data bits, No Parity, 1 Stop bit (8N1).
- **Flow Control:** RTS/CTS hardware handshaking enabled to prevent FIFO overflow.
- **Protocol:** Register-based read/write (see Section 10 & 11).

### 9.2 RF Synthesizer Control
- **Target Device:** ADF5356 (LO Synthesizer).
- **Interface:** 3-Wire SPI (CLK, MUXOUT/Data-in, LE).
- **Max Speed:** 20 MHz clock.
- **Operation:**
    - FPGA writes 32-bit registers to ADF5356 to set INT, FRAC, and MOD dividers.
    - **Auto-Calibration Trigger:** Writing to Register 0 triggers the VCO calibration sequence (mandatory after frequency change > 10%).
- **Lock Detect:** The ADF5356 MUXOUT pin is configured to output "Digital Lock Detect". FPGA monitors this (LO_MUXOUT_LOCK) to verify PLL stability before enabling RF Chain.

### 9.3 Variable Gain Amplifier Control
- **Target Device:** HMC698LP4 (Digital VGA/Attenuator).
- **Interface:** 3-Wire Serial (Data, Clock, Latch).
- **Logic:** Active High (Data sampled on rising edge of CLK).
- **Data Width:** 6 bits (Gain setting from 0 to 31.5 dB in 0.5 dB steps).
- **Sequence:**
    1. FPGA pulls Latch Low.
    2. FPGA clocks out 6 bits.
    3. FPGA pulls Latch High to load new gain.

### 9.4 Power Supply Monitoring
- **IC:** LTC2992.
- **Interface:** I2C (Address 0x6C).
- **Monitored Rails:**
    - **12V Input:** Via V1 pin.
    - **3.3V Logic:** Via V2 pin.
    - **Current:** Via Sense Resistor on 12V return path.
- **Alert:** FPGA alerts Host if Voltage < 11.0V (Undervoltage) or > 13.2V (Overvoltage).

### 9.5 Temperature Monitoring
- **IC:** AD7416.
- **Interface:** I2C (Address 0x48).
- **Resolution:** 10-bit (0.25°C).
- **Range:** -55°C to +125°C.
- **Alert Threshold:** +85°C (matches REQ-HW-011).
- **Action:** FPGA asserts RF_ENABLE_N = High (OFF) if Temperature > 85°C.

### 9.6 Flash / EEPROM Interfaces
- **Device:** AT25M01 (1Mb SPI EEPROM).
- **Purpose:** Stores calibration tables (Frequency Correction vs Temp) and default configuration.
- **Interface:** Standard SPI (Mode 0).
- **Speed:** 10 MHz.

### 9.7 RF Safety Interlock
- **Signal:** RF_ENABLE_N.
- **Logic:** Active Low.
- **Control:**
    - Default state is HIGH (RF OFF) during power-up.
    - FPGA asserts LOW (RF ON) only when:
        - Power Good (PGOOD_3V3) is asserted.
        - PLL Lock is detected (LO_MUXOUT_LOCK).
        - Temperature is < 85°C.
        - Host explicitly sends `ENABLE_RF` command via UART.

### 9.8 LED Indication
- **Red LED (LED_STATUS_R):** Solid = Fault (Temp or PWR).
- **Green LED (LED_STATUS_G):** Solid = PLL Locked & RF Ready.
- **Blue LED (LED_STATUS_B):** Blinking = UART Traffic / Heartbeat.

### 9.9 FPGA Remote Programming
- **Method:** Secondary SPI Bootloader.
- **Protocol:** Xilinx 4-wire SPI boot mode.
- **Storage:** AT25M01 holds the Golden Image fallback.
- **Update:** Host can upload new bitstream via UART to FPGA RAM, then FPGA writes to SPI Flash and triggers reboot.

---

## 10. Software Register Address Map

### 10.1 Register Base Addresses

| Block Name | Base Address | Address Range | Description |
|:---|:---:|:---:|:---|
| **System / ID** | 0x0000 | 0x0000–0x00FF | Board ID, Firmware Version, Status |
| **UART Control** | 0x0100 | 0x0100–0x01FF | Baud Rate, Interrupt Enables |
| **SPI LO Control** | 0x0200 | 0x0200–0x02FF | ADF5356 Register Access Buffer |
| **SPI VGA Control** | 0x0300 | 0x0300–0x03FF | HMC698LP4 Gain Setting |
| **I2C Control** | 0x0400 | 0x0400–0x04FF | I2C Master Command Register |
| **Power Monitor** | 0x0500 | 0x0500–0x05FF | Voltage/Current Readings (LTC2992) |
| **Temperature Monitor** | 0x0600 | 0x0600–0x06FF | Temperature Reading (AD7416) |
| **RF Control** | 0x0700 | 0x0700–0x07FF | RF Enable, Gain Table Select |
| **Flash / EEPROM** | 0x0800 | 0x0800–0x08FF | EEPROM Read/Write Command |
| **Diagnostics** | 0x0900 | 0x0900–0x09FF | Uptime, Fault Log, Lock Status |

### 10.2 Detailed Register Map

**Block 0x0000 — System / Identification**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|:---:|:---|:---:|:---:|:---:|:---|
| 0x00 | BOARD_ID | 16 | R | 0x4A48 | 'JH' (ASCII) |
| 0x01 | FW_VERSION | 16 | R | 0x0101 | v1.01 |
| 0x02 | SYS_STATUS | 16 | R | 0x0000 | [15:4] Reserved, [3] TEMP_FAULT, [2] PWR_FAULT, [1] PLL_LOCK, [0] RF_ENABLED |
| 0x03 | SYS_RESET | 16 | W | 0x0000 | [0] SOFT_RESET (Write 1 to trigger) |
| 0x04 | LED_CTRL | 16 | R/W | 0x0002 | [2:0] RGB Manual Override (Red, Green, Blue) |

**Block 0x0100 — UART Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|:---:|:---|:---:|:---:|:---:|:---|
| 0x00 | BAUD_DIV | 16 | R/W | 0x000D | Divisor for 40MHz clk (Default ~115200) |
| 0x01 | UART_CTRL | 16 | R/W | 0x0000 | [0] UART_EN, [1] LOOPBACK |
| 0x02 | UART_STATUS | 16 | R | 0x0000 | [0] TX_BUSY, [1] RX_READY |
| 0x03 | RX_DATA | 16 | R | 0x0000 | [7:0] Received Byte |
| 0x04 | TX_DATA | 16 | W | 0x0000 | [7:0] Byte to Transmit |

**Block 0x0200 — SPI LO Control (ADF5356)**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|:---:|:---|:---:|:---:|:---:|:---|
| 0x00 | LO_REG_0 | 32 | W | 0x00000000 | ADF5356 Reg 0 (Function) |
| 0x01 | LO_REG_1 | 32 | W | 0x00000000 | ADF5356 Reg 1 (HLDIV) |
| 0x02 | LO_REG_2 | 32 | W | 0x00000000 | ADF5356 Reg 2 (N Divider) |
| 0x03 | LO_REG_3 | 32 | W | 0x00000000 | ADF5356 Reg 3 (INT) |
| 0x04 | LO_REG_4 | 32 | W | 0x00000000 | ADF5356 Reg 4 (FRAC1) |
| 0x05 | LO_REG_5 | 32 | W | 0x00000000 | ADF5356 Reg 5 (FRAC2) |
| 0x06 | LO_REG_6 | 32 | W | 0x00000000 | ADF5356 Reg 6 (MOD2) |
| 0x07 | LO_REG_12 | 32 | W | 0x00000000 | ADF5356 Reg 12 (VCO Band/Cal) |
| 0x10 | LO_TRIGGER | 16 | W | 0x0001 | [0] TRIGGER_WRITE (Pulse high to send SPI data) |
| 0x11 | LO_LOCK_RAW | 16 | R | 0x0000 | [0] READBACK of LOCK Pin |

**Block 0x0300 — SPI VGA Control (HMC698LP4)**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|:---:|:---|:---:|:---:|:---:|:---|
| 0x00 | VGA_GAIN | 16 | R/W | 0x0000 | [5:0] Gain Code (0-63). 0=Max Atten, 63=Min Atten |
| 0x01 | VGA_LOAD | 16 | W | 0x0000 | [0] LOAD (Strobe latch) |

**Block 0x0700 — RF Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|:---:|:---|:---:|:---:|:---:|:---|
| 0x00 | RF_ENABLE | 16 | R/W | 0x0000 | [0] RF_ON (1=Enable, 0=Safe State) |
| 0x01 | RF_MODE | 16 | R/W | 0x0000 | [0] CW, [1] Pulsed |

**Block 0x0500 & 0x0600 — I2C Monitoring (Simplified)**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|:---:|:---|:---:|:---:|:---:|:---|
| 0x00 | I2C_TRIGGER | 16 | W | 0x0000 | [7:0] Device Address (Write to trigger read) |
| 0x01 | I2C_DATA_H | 16 | R | 0x0000 | MSB of last read value |
| 0x02 | I2C_DATA_L | 16 | R | 0x0000 | LSB of last read value (Temperature/ADC) |

---

## 11. UART Register Protocol Specification

This section defines the low-level communication protocol between the Host PC and the FPGA.

### 11.1 Physical Layer
- **Baud Rate:** 3,000,000 bps (Configurable)
- **Frame:** 8N1
- **Interface:** 3.3V CMOS logic levels (via USB-UART bridge).

### 11.2 Command Frame Formats

**Single Register Write (CMD = 0x57 'W'):**
Used to write a single 16-bit register.
```
Byte 0: 0x57 (CMD 'W')
Byte 1: ADDR[15:8]
Byte 2: ADDR[7:0]
Byte 3: DATA[15:8]
Byte 4: DATA[7:0]
Response (1 byte): 0x06 (ACK) or 0x15 (NAK)
```

**Single Register Read (CMD = 0x52 'R'):**
Used to read a single 16-bit register.
```
Byte 0: 0x52 (CMD 'R')
Byte 1: ADDR[15:8]
Byte 2: ADDR[7:0]
Response (3 bytes): 0x06 (ACK), DATA[15:8], DATA[7:0]
```

**Bulk Register Write (CMD = 0x42 'B'):**
Used to write multiple registers (e.g., ADF5356 register set).
```
Byte 0: 0x42 (CMD 'B')
Byte 1: START_ADDR[15:8]
Byte 2: START_ADDR[7:0]
Byte 3: COUNT (N)
Byte 4..4+(2N-1): DATA0_H, DATA0_L, ... DATAN_H, DATAN_L
Response (1 byte): 0x06 (ACK)
```

**Bulk Register Read (CMD = 0x62 'b'):**
```
Byte 0: 0x62 (CMD 'b')
Byte 1: START_ADDR[15:8]
Byte 2: START_ADDR[7:0]
Byte 3: COUNT (N)
Response (1 + 2N bytes): 0x06 (ACK), DATA0_H, DATA0_L ...
```

### 11.3 Protocol Timing Constraints
| Parameter | Min | Typical | Max | Unit |
|:---|:---:|:---:|:---:|:---:|
| Inter-byte gap | 1 | - | 50 | ms |
| Acknowledge delay | - | 0.2 | 1 | ms |
| Bulk transfer delay | - | 1 | 10 | ms |

---

## 12. FPGA Resource Utilization Estimate

| Resource | Available | Estimated Usage | Utilization % |
|:---|:---:|:---:|:---:|
| Slice LUTs | 20,800 | 4,200 | 20% |
| Slice Flip-Flops | 41,600 | 3,500 | 8% |
| Block RAM (36Kb) | 50 | 4 | 8% |
| DSP Slices | 90 | 0 | 0% |
| MMCM/PLL | 2 | 1 | 50% |
| I/O Buffers | 180 | 40 | 22% |

*Synthesis Tool: Vivado 2025.1*
*Target Device: XC7A35T-CPG238C*
*Timing Constraint: 40 MHz Primary Clock (25ns period)*

---

## Annexure A — Requirement Traceability Matrix

| S.No | GLR-ID | Description | Source HRS Section | GLR Section | Verification Method | Status |
|:---:|:---|:---|:---|:---|:---|:---|
| 1 | GLR-001 | Frequency Range Control | REQ-HW-001 | 9.2 (LO Control) | Simulation / Test | Open |
| 2 | GLR-002 | RF Input Interface | REQ-HW-004 | 8 (Pinout) | Inspection | Open |
| 3 | GLR-003 | Variable Gain Control | REQ-HW-010 | 9.3 (VGA Control) | Test | Open |
| 4 | GLR-004 | IF Output Path | REQ-HW-008 | 4 (Module Overview) | Inspection | Open |
| 5 | GLR-005 | Supply Voltage | REQ-HW-006 | 9.4 (Power Mon) | Test | Open |
| 6 | GLR-006 | Input Impedance | REQ-HW-003 | N/A (PCB Layout) | Test | Open |
| 7 | GLR-007 | Operating Temperature | REQ-HW-011 | 9.5 (Temp Mon) | Environmental Test | Open |
| 8 | GLR-008 | Gain Range | REQ-HW-010 | 9.3 (VGA Control) | Test | Open |
| 9 | GLR-009 | Low Noise Figure | REQ-HW-002 | N/A (RF Design) | RF Measurement | Open |
| 10 | GLR-010 | Digital Interface | REQ-HW-009 | 11 (UART Protocol) | Test | Open |
| 11 | GLR-011 | MIL-STD-461 EMC | REQ-HW-014 | 4 (Power Supply) | EMC Test | Open |
| 12 | GLR-012 | Power Monitoring | REQ-HW-007 | 9.4 (Power Mon) | Test | Open |