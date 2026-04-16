# Glue Logic Requirements (GLR)

## Document Control
| Document Title | Glue Logic Requirements |
| :--- | :--- |
| Version Date | 17.04.2026 |
| Version Number | 0V01 |
| Prepared By | Name: . Sign: |
| Document Review By | Name: . Sign: |

---

## Amendments to the Document
| S. No. | Ver. No. | Ver. Date | Changed By | Section(s) Changed | Description of Change |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | 0V01 | 17.04.2026 | - | - | Initial Version |

---

## 1. Scope of the Document
This document explains the IO details and functional requirements of the FPGA for **kb**.
**Targeted audience:** Hardware Design and Firmware teams.

---

## 2. References

### 2.1 External
| Doc. Type | Part No. | Description |
| :--- | :--- | :--- |
| Datasheet | ADC12DJ3200 | 12-Bit, 6.4 GSPS, Dual-Channel ADC |
| Datasheet | ADF5356 | Microwave Wideband Synthesizer with Integrated VCO |
| Datasheet | HMC698LP4 | 0.5 dB LSB, 7-Bit, Digital Step Attenuator |
| Datasheet | TGA4956-SM | DC to 20 GHz GaAs MMIC LNA |
| Datasheet | LMK04828 | Ultra-Low Noise JESD204B/C Clock Jitter Cleaner |
| Datasheet | AT25040N | 4-Kb SPI EEPROM |
| Datasheet | MT25QL01G | 1-Gbit Serial Flash Memory |
| Datasheet | LTC2992 | High Precision I2C Power, Current, Voltage Monitor |
| Datasheet | ADM1266 | Octal Super Sequencer and Margining Controller |

### 2.2 Internal
| Reference | Document |
| :--- | :--- |
| [HRS] | Hardware Requirements Specification |
| [SCH] | Schematic |
| [GRS] | General Requirements Specification |
| [GDD] | General Design Document |

---

## 3. Acronyms and Abbreviations

| Acronym | Expansion |
| :--- | :--- |
| **ADC** | Analog to Digital Converter |
| **AGC** | Automatic Gain Control |
| **CPLD** | Complex Programmable Logic Device |
| **DAC** | Digital to Analog Converter |
| **DSP** | Digital Signal Processing |
| **EMC** | Electromagnetic Compatibility |
| **ENOB** | Effective Number of Bits |
| **FF** | Flip-Flop |
| **FIFO** | First In First Out |
| **FPGA** | Field Programmable Gate Array |
| **GND** | Ground |
| **GPIO** | General Purpose Input/Output |
| **HDL** | Hardware Description Language |
| **I2C** | Inter-Integrated Circuit |
| **JTAG** | Joint Test Action Group |
| **LUT** | Look Up Table |
| **LVDS** | Low Voltage Differential Signaling |
| **PCB** | Printed Circuit Board |
| **PLL** | Phase Locked Loop |
| **RTL** | Register Transfer Level |
| **SPI** | Serial Peripheral Interface |
| **UART** | Universal Asynchronous Receiver/Transmitter |
| **VCC** | Voltage Common Collector |

---

## 4. Module Overview

**RF SECTION:**
The RF chain consists of a Mini-Circuits **LMLPF-BV-0+** Limiter for input protection up to 0 dBm, followed by a **VBFZ-5580+** 5-18 GHz Bandpass Filter. The signal is amplified by a Qorvo **TGA4956-SM** LNA (22dB gain, 2.5dB NF). Gain adjustment is handled by an Analog Devices **HMC698LP4** Digital Step Attenuator (31.5dB range, SPI controlled). Frequency downconversion is performed by a MACOM **MAMX-011034** Mixer driven by an Analog Devices **ADF5356** Wideband Synthesizer (LO).

**DIGITAL SECTION:**
The digital core is a Xilinx **Kintex UltraScale+ XQRKU060** (Space/Hi-Rel grade equivalent) FPGA. It interfaces directly with the Texas Instruments **ADC12DJ3200** via a JESD204B/C interface (8 lanes at 10 Gbps). The FPGA handles system control (AGC loops, LO frequency synthesis), data buffering, and communication with the host via UART.

**POWER SUPPLY SECTION:**
The system operates from a +12V DC input. Power regulation is managed by an **ADM1266** Super Sequencer controlling various DC/DC converters (not explicitly listed in BOM but implied) to generate +5V (RF/Analog), +3.3V (FPGA I/O), +1.8V (FPGA Aux), and +1.0V (FPGA Core). An **LTC2992** monitors voltage and current health on the main rails.

---

## 5. Features
*   **FPGA:** Xilinx XQRKU060-FFVA1760 (Kintex UltraScale+)
*   **On-board clock oscillator:** 125 MHz LVCMOS Crystal Oscillator
*   **Communication:** UART (RS-422) at 115200 baud
*   **JTAG debugging support:** Standard 14-pin header
*   **EEPROM:** AT25040N (4-Kb) for board serialization
*   **Storage Flash:** MT25QL01G (1-Gb) for calibration tables & user data
*   **Configuration Flash:** Internal BPI/Boot from MT25QL01G
*   **Temperature Monitoring:** FPGA internal XADC + external ADC12DJ3200 temp sensor
*   **Power monitoring:** LTC2992 via I2C
*   **High Speed Interface:** JESD204B/C (Subclass 1) to ADC

---

## 6. FPGA Description
The **Xilinx XQRKU060** FPGA is selected for its high-speed transceiver capability required for the 2 GSPS ADC interface and its radiation tolerance suitable for harsh environments (MIL-STD-810). It provides sufficient logic resources to perform real-time processing and control.

| S.NO | PARAMETERS | SPECIFICATION |
| :--- | :--- | :--- |
| 1 | Part Number | XQRKU060-FFVA1760 |
| 2 | Logic Cells | 603,360 |
| 3 | CLB Flip-Flops | 2,413,440 |
| 4 | Number of Gates | 10M+ (ASIC equiv.) |
| 5 | Maximum Distributed RAM (Kb) | 5,058 |
| 6 | Total Block RAM (Kb) | 38,304 |
| 7 | Maximum Single-Ended I/Os | 520 |
| 8 | Maximum DSP Slices | 2,760 |
| 9 | No of IO Bank | 4 (Selected Banks) |

---

## 7. Block Diagram
[Reference Schematic - Block Diagram Section]
The system is centered around the FPGA. The **ADC12DJ3200** connects via 8 lanes of LVDS (JESD204B/C). The **ADF5356** LO is controlled via SPI. The **HMC698LP4** Attenuator is controlled via SPI. The **LTC2992** Power Monitor is controlled via I2C. Configuration and storage memories utilize SPI. A UART port provides host command and control.

---

## 8. Pinout Details

**Table: FPGA Pin Out Details**

| S.No | Signal Name | Pin No | Voltage Level | Direction wrt FPGA | Source | Destination | Default Condition | Voltage Standard |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | VCCO_3V3 | - | 3.3V | Power | PMIC | FPGA Bank 34 | ON | - |
| 2 | GND | - | 0V | Ground | GND Plane | FPGA | - | - |
| 3 | FPGA_CLK_125M_P | AA12 | 1.8V | Input | Oscillator | PLL | HIGH | LVDS |
| 4 | FPGA_CLK_125M_N | AB12 | 1.8V | Input | Oscillator | PLL | HIGH | LVDS |
| 5 | JTAG_TCK | E5 | 1.8V | Input | Connector | FPGA | Pull Down | LVCMOS18 |
| 6 | JTAG_TDI | D5 | 1.8V | Input | Connector | FPGA | Pull Down | LVCMOS18 |
| 7 | JTAG_TDO | E6 | 1.8V | Output | FPGA | Connector | High Z | LVCMOS18 |
| 8 | JTAG_TMS | F5 | 1.8V | Input | Connector | FPGA | Pull Up | LVCMOS18 |
| 9 | FPGA_RESET_N | G12 | 1.8V | Input | Reset Button | FPGA | HIGH | LVCMOS18 |
| 10 | POR_N | H12 | 1.8V | Input | ADM1266 | FPGA | HIGH | LVCMOS18 |
| 11 | UART_TX | Y15 | 3.3V | Output | FPGA | Transceiver | HIGH | LVCMOS33 |
| 12 | UART_RX | AA15 | 3.3V | Input | Transceiver | FPGA | HIGH | LVCMOS33 |
| 13 | SPI_SDO | T18 | 3.3V | Output | FPGA | ADC/Flash | HIGH | LVCMOS33 |
| 14 | SPI_SDI | R18 | 3.3V | Input | ADC/Flash | FPGA | Pull Down | LVCMOS33 |
| 15 | SPI_SCK | P18 | 3.3V | Output | FPGA | ADC/Flash | LOW | LVCMOS33 |
| 16 | ADC_CS_N | M18 | 3.3V | Output | FPGA | ADC12DJ3200 | HIGH | LVCMOS33 |
| 17 | FLASH_CS_N | L18 | 3.3V | Output | FPGA | MT25QL01G | HIGH | LVCMOS33 |
| 18 | LO_CS_N | K18 | 3.3V | Output | FPGA | ADF5356 | HIGH | LVCMOS33 |
| 19 | VGA_CS_N | J18 | 3.3V | Output | FPGA | HMC698LP4 | HIGH | LVCMOS33 |
| 20 | I2C_SCL | N15 | 3.3V | Bi-Dir | FPGA | LTC2992 | HIGH | LVCMOS33 (OD) |
| 21 | I2C_SDA | P15 | 3.3V | Bi-Dir | FPGA | LTC2992 | HIGH | LVCMOS33 (OD) |
| 22 | LED_STATUS | A10 | 1.8V | Output | FPGA | LED | LOW | LVCMOS18 |
| 23 | LED_ERROR | B10 | 1.8V | Output | FPGA | LED | LOW | LVCMOS18 |
| 24 | ADC_SYNC_N | C18 | 1.8V | Output | FPGA | ADC | HIGH | LVCMOS18 |
| 25 | FPGA_DONE | D11 | 1.8V | Output | FPGA | LED/Controller | LOW | LVCMOS18 |
| 26 | FPGA_INIT_N | C11 | 1.8V | Output | FPGA | Controller | LOW | LVCMOS18 |
| 27 | JESD_RX_P[0] | E1 | 1.0V | Input | ADC | FPGA | CML | VCCO-1.0V |
| 28 | JESD_RX_N[0] | F1 | 1.0V | Input | ADC | FPGA | CML | VCCO-1.0V |
| 29 | JESD_RX_P[1] | G1 | 1.0V | Input | ADC | FPGA | CML | VCCO-1.0V |
| 30 | JESD_RX_N[1] | H1 | 1.0V | Input | ADC | FPGA | CML | VCCO-1.0V |
| 31 | JESD_RX_P[2] | K1 | 1.0V | Input | ADC | FPGA | CML | VCCO-1.0V |
| 32 | JESD_RX_N[2] | L1 | 1.0V | Input | ADC | FPGA | CML | VCCO-1.0V |
| 33 | JESD_RX_P[3] | M1 | 1.0V | Input | ADC | FPGA | CML | VCCO-1.0V |
| 34 | JESD_RX_N[3] | N1 | 1.0V | Input | ADC | FPGA | CML | VCCO-1.0V |
| 35 | ADC_CLK_P | R1 | 1.0V | Input | LMK04828 | FPGA | CML | VCCO-1.0V |
| 36 | ADC_CLK_N | T1 | 1.0V | Input | LMK04828 | FPGA | CML | VCCO-1.0V |
| 37 | TRP_OUT | V15 | 3.3V | Output | FPGA | External Test Port | LOW | LVCMOS33 |

---

## 9. Functional Specifications

| S.No. | Function Name | Description |
| :--- | :--- | :--- |
| 1 | Serial Communication Interface | UART RS-422 between Host PC & FPGA |
| 2 | High Speed Communication Interface | JESD204B/C Subclass 1 Interface to ADC12DJ3200 |
| 3 | Power Supply Sequencing & Health Status | Monitoring via I2C (LTC2992), Control via GPIO |
| 4 | Supply Voltage, Current & Temperature Monitoring | I2C-based monitoring of Rails 12V, 5V, 3.3V, 1.0V |
| 5 | Flash Interfaces | SPI Configuration (MT25QL01G) & Storage (MT25QL01G) |
| 6 | TRP Configuration | Test Point / Trigger output for synchronization |
| 7 | FPGA Remote Programming | Configuration loading via UART SelectMAP |
| 8 | Gain Control (AGC) | HMC698LP4 SPI control for 31.5dB range |
| 9 | LO Synthesis Control | ADF5356 SPI control for Frequency Tuning (5-18GHz) |

### 9.1 Serial Communication Interface
*   **Interface type:** UART
*   **Physical layer:** RS-422 Differential
*   **Baud rate:** 115200 bps (Fixed)
*   **Frame format:** 1 start bit, 8 data bits, 1 stop bit, no parity (8N1)
*   **USB-UART converter IC:** FT4232H (External Interface)
*   **Signals:** UART_TX (FPGA → Host), UART_RX (Host → FPGA)
*   **Protocol:** Custom register-based command/response (See Section 11)

### 9.2 High Speed Communication Interface
*   **Interface:** JESD204B/C Subclass 1
*   **Number of lanes:** 8 Lanes
*   **Data rate per lane:** 10 Gbps (to support 2 GSPS ADC x 12 bits)
*   **Protocol:** JESD204B/C compliant
*   **Physical:** AC-coupled LVDS

### 9.3 Power On/Off Sequence
#### 9.3.1 Power ON/OFF Sequence
1.  Input supply (+12V) detected.
2.  ADM1266 enables +3.3V and +5V rails.
3.  FPGA receives POR_N signal.
4.  FPGA loads configuration from SPI Flash.
5.  FPGA asserts DONE.
6.  FPGA enables +1.0V Core Rail (via enable GPIO) - *Note: Xilinx FPGAs usually manage this internally, but assume external sequencing requirement for specific power-up.*
7.  FPGA enters Idle State.
8.  Host commands Power Up → FPGA enables RF Power Amplifiers via TRP_OUT.

#### 9.3.2 Mode Configuration
| Mode | Signal | Value | Description |
| :--- | :--- | :--- | :--- |
| Normal | MODE[1:0] | 2'b00 | Normal Operating Mode (RX) |
| BIST | MODE[1:0] | 2'b01 | Built-in Self-Test (Loopback) |
| Programming | MODE[1:0] | 2'b10 | FPGA Remote Programming Mode |

### 9.4 Supply Voltage, Current & Temperature Monitoring
#### 9.4.1 Supply Voltage and Current Monitoring
*   **IC Part Number:** LTC2992
*   **Interface:** I2C at 0x6C
*   **Monitored rails:** +12V Input, +5V RF, +3.3V IO, +1.0V Core.
*   **Measurement range:** 0 to 20V, 0 to 5A.
*   **Resolution:** 16-bit (0.3mV / 0.1mA).

#### 9.4.2 Temperature Monitoring
*   **IC Part Number:** XADC (Internal) + LTC2992
*   **Interface:** I2C (LTC2992) / DRP (XADC)
*   **Temperature range:** -55°C to +125°C.
*   **Alert threshold:** > 110°C (Warning), > 120°C (Critical Shutdown).

### 9.5 Flash & Interfaces
#### 9.5.1 Configuration Flash
*   **Part Number:** MT25QL01G
*   **Interface:** SPI (x4)
*   **Capacity:** 128 Mb
*   **Purpose:** Stores FPGA bitstream and boot firmware.
*   **Programming:** Via UART JTAG bridge or Direct SPI.

#### 9.5.2 Storage Flash (User Flash)
*   **Part Number:** MT25QL01G (Same device, Partitioned)
*   **Interface:** SPI
*   **Capacity:** Reserved Partition
*   **Purpose:** Stores LUTs for Gain/Phase correction, Calibration data.

### 9.6 TRP Configuration
*   **Signal:** TRP_OUT
*   **Direction:** FPGA → External Scope/Trigger
*   **Logic level:** 3.3V LVTTL
*   **Active state:** HIGH = RX Window Active
*   **Timing:** Synchronized with JESD204B Frame boundary.

### 9.7 FPGA Remote Programming
*   **Protocol:** UART at 115200 baud
*   **Tool:** Host Python GUI / script
*   **Procedure:**
    1.  Host sends programming command (0x55).
    2.  FPGA enters Programming Mode (MODE = 2'b10).
    3.  Bitstream transferred in 256-byte packets.
    4.  Configuration flash written via FPGA SPI master.
    5.  FPGA triggers IPROG command.

### 9.8 Gain Control (AGC)
*   **Device:** HMC698LP4
*   **Interface:** SPI
*   **Control Logic:** 7-bit parallel load or Serial (Assuming Serial per schematic).
*   **Attenuation Range:** 0 to 31.5 dB in 0.5 dB steps.
*   **Algorithm:** Histogram based measurement of ADC code density to adjust gain.

### 9.9 LO Synthesis Control
*   **Device:** ADF5356
*   **Interface:** SPI (3-wire: CLK, DATA, LE)
*   **Frequency Range:** 5 GHz to 18 GHz RF (Mixing scheme dependent).
*   **Registers:** 6x 32-bit registers for Int, Frac, Mod, and Dividers.

---

## 10. Software Register Address Map

### 10.1 Register Base Addresses

| Block Name | Base Address | Address Range | Description |
| :--- | :--- | :--- | :--- |
| System / Identification | 0x0000 | 0x0000–0x00FF | Board ID, firmware version, status |
| UART Control | 0x0100 | 0x0100–0x01FF | Baud rate, FIFO control |
| SPI Control | 0x0200 | 0x0200–0x02FF | SPI master, chip-select control |
| I2C Control | 0x0300 | 0x0300–0x03FF | I2C master, device address |
| GPIO | 0x0400 | 0x0400–0x04FF | General purpose I/O control |
| RF Control | 0x0500 | 0x0500–0x05FF | HMC698, ADF5356 Control Registers |
| Temp Monitor | 0x0600 | 0x0600–0x06FF | XADC/LTC2992 Temp readings |
| Power Monitor | 0x0700 | 0x0700–0x07FF | Voltage/Current ADC readings |
| JESD204B Control | 0x0800 | 0x0800–0x08FF | ADC Link config, status |
| Flash / EEPROM | 0x0900 | 0x0900–0x09FF | Flash address, data |
| Diagnostics | 0x0A00 | 0x0A00–0x0AFF | Fault log, uptime counter |

### 10.2 Detailed Register Map

**Block 0x0000 — System / Identification**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 0x00 | BOARD_ID | 16 | R | 0x4B42 | "KB" (Project Code) |
| 0x01 | FW_VERSION_MAJOR | 16 | R | 0x0001 | Firmware major version |
| 0x02 | FW_VERSION_MINOR | 16 | R | 0x0000 | Firmware minor version |
| 0x03 | SYS_STATUS | 16 | R | 0x0000 | [15:8] Reserved, [7] JESD_LINK_RDY, [6] TEMP_ALERT, [5] VOLT_FAULT, [4] PWR_GOOD, [3:0] INIT_STATE |
| 0x04 | SYS_CTRL | 16 | R/W | 0x0000 | [0] SOFT_RESET, [1] RF_ENABLE, [2] LED_MODE |
| 0x05 | UPTIME_COUNTER | 32 | R | 0x00000000 | Seconds since power-up |

**Block 0x0100 — UART Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 0x00 | BAUD_DIV | 16 | R/W | 0x001A | Baud rate divisor (default 115200) |
| 0x01 | UART_CTRL | 16 | R/W | 0x0000 | [0] UART_ENABLE, [1] LOOPBACK_EN |
| 0x02 | UART_STATUS | 16 | R | 0x0000 | [0] TX_BUSY, [1] RX_AVAIL, [2] RX_OVERRUN |
| 0x03 | TX_DATA | 8 | W | - | Write byte to transmit |
| 0x04 | RX_DATA | 8 | R | - | Read received byte |

**Block 0x0200 — SPI Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 0x00 | SPI_DIV | 16 | R/W | 0x000A | Clock divisor (SCK = Core / (2*(DIV+1))) |
| 0x01 | SPI_CTRL | 16 | R/W | 0x0000 | [0] SPI_EN, [1] CPOL, [2] CPHA |
| 0x02 | SPI_TX | 32 | W | - | Data to transmit |
| 0x03 | SPI_RX | 32 | R | - | Data received |
| 0x04 | SPI_CS | 16 | R/W | 0xFFFF | [0] FLASH_CS, [1] LO_CS, [2] VGA_CS (Active Low) |

**Block 0x0500 — RF Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 0x00 | VGA_ATTENUATION | 8 | R/W | 0x00 | HMC698 Attenuation (0-63 = 0-31.5dB) |
| 0x01 | LO_FREQ_INT | 16 | R/W | 0x0000 | ADF5356 Integer Divider value |
| 0x02 | LO_FREQ_FRAC | 24 | R/W | 0x000000 | ADF5356 Fractional value |
| 0x03 | LO_MUXOUT | 16 | R | 0x0000 | Read ADF5356 Muxout status |
| 0x04 | RF_STATE | 16 | R/W | 0x0000 | [0] RX_ENABLE, [1] PA_TX_ENABLE |

**Block 0x0800 — JESD204B Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 0x00 | JESD_CTRL | 16 | R/W | 0x0000 | [0] LINK_ENABLE, [1] RESET_LINK |
| 0x01 | JESD_STATUS | 16 | R | 0x0000 | [0] LINK_LOCKED, [1] CODE_GROUP_SYNC |
| 0x02 | JESD_LANES | 16 | R | 0x000F | Number of lanes detected (4) |

**Block 0x0A00 — Diagnostics**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 0x00 | FAULT_LOG | 32 | R | 0x00000000 | [31:0] Fault bitmap |
| 0x01 | CLEAR_FAULT | 16 | W | 0x0000 | Write 0x0001 to clear log |

### 10.3 Register Access Rules
*   All registers are 16-bit or 32-bit aligned.
*   Read: set bit15 of address (address OR 0x8000) *if using 8-bit protocol, otherwise address is direct.*
*   SPI Registers require CS assertion handled internally by the block.

---

## 11. UART Register Protocol Specification

### 11.1 Physical Layer
*   **Baud rate:** 115200
*   **Frame format:** 1 start bit, 8 data bits, 1 stop bit, no parity (8N1)
*   **Physical interface:** RS-422
*   **Signal levels:** 0V to +3.3V logic (transceiver side)

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
Byte 1: ADDR[15:8] (address MSB)
Byte 2: ADDR[7:0]  (address LSB)
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
Byte 1: ADDR[15:8] (start address MSB)
Byte 2: ADDR[7:0]  (start address LSB)
Byte 3: N          (register count, 1–64)
→ Response: DATA[0]_H, DATA[0]_L, ..., DATA[N-1]_H, DATA[N-1]_L within 5ms
Total frame: 4 bytes TX, 2N bytes RX
```

**Error Response:**
```
0x15 (NAK) — sent by FPGA when:
  - CMD byte not recognized
  - Address out of valid range (> 0x0AFF)
  - Write to read-only register
```

### 11.3 Protocol Timing Constraints
| Parameter | Min | Typical | Max | Unit |
| :--- | :--- | :--- | :--- | :--- |
| Inter-byte gap (TX side) | - | - | 50 | ms |
| Single Write response time | - | 0.5 | 1 | ms |
| Single Read response time | - | 1 | 2 | ms |
| Bulk Write response time (N=64) | - | 3 | 5 | ms |
| Bulk Read response time (N=64) | - | 3 | 5 | ms |

---

## 12. FPGA Resource Utilization Estimate

| Resource | Available | Estimated Usage | Utilization % |
| :--- | :--- | :--- | :--- |
| Slice LUTs | 303,000 | 85,000 | 28% |
| Slice Flip-Flops | 606,000 | 60,000 | 10% |
| Block RAM (36Kb) | 1,200 | 180 | 15% |
| DSP Slices | 2,760 | 40 | 1% |
| MMCM/PLL | 20 | 2 | 10% |
| I/O Buffers | 520 | 150 | 29% |

**Synthesis tool:** Vivado 2025.1
**Target device:** XQRKU060-FFVA1760
**Timing constraint:** 500 MHz (JESD204B SERDES internal)

---

## Annexure A — Requirement Traceability Matrix

| S.No. | GLR-ID | Description | Source HRS Section | GLR Section | Verification Method | Status |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | GLR-001 | Serial Communication Interface | HRS §3.3 | 9.1, 11 | Test | Open |
| 2 | GLR-002 | High Speed Communication | HRS §3.3 (REQ-HW-007) | 9.2 | Test | Open |
| 3 | GLR-003 | Power Supply Sequencing | HRS §3.1 (REQ-HW-021) | 9.3 | Test | Open |
| 4 | GLR-004 | Voltage/Current/Temperature Monitoring | HRS §3.1 (REQ-HW-022) | 9.4 | Test | Open |
| 5 | GLR-005 | Flash Interfaces | HRS §3.3 | 9.5 | Test | Open |
| 6 | GLR-006 | TRP Configuration | HRS §3.3 | 9.6 | Inspection | Open |
| 7 | GLR-007 | FPGA Remote Programming | HRS §3.3 | 9.7 | Demonstration | Open |
| 8 | GLR-008 | Gain Control (AGC) | HRS §3.1 (REQ-HW-013) | 9.8 | Test | Open |
| 9 | GLR-009 | LO Synthesis Control | HRS §3.1 (REQ-HW-016) | 9.9 | Test | Open |
| 10 | GLR-010 | Register Address Map | HRS §3.3 | 10 | Inspection | Open |
| 11 | GLR-011 | UART Protocol Specification | HRS §3.3 | 11 | Test | Open |
| 12 | GLR-012 | FPGA Resource Budget | HRS §3.2 | 12 | Analysis | Open |