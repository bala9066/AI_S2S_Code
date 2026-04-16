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
| S. No | Ver. No. | Ver. Date | Changed By | Section(s) Changed | Description of Change |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | 0V01 | 17.04.2026 | - | - | Initial Version |

---

## 1. Scope of the Document
This document explains the IO details and functional requirements of the FPGA for **kjk (Wideband RF Receiver)**. Targeted audience: Hardware Design and Firmware teams.

---

## 2. References

### 2.1 External
| Doc. Type | Part No. | Description |
| :--- | :--- | :--- |
| Datasheet | HMC698LP4 | DC to 20 GHz Low Noise Amplifier / IF Amp |
| Datasheet | HMC1049LC4 | 5-20 GHz Double-Balanced Mixer |
| Datasheet | ADF5356 | Wideband Synthesizer with Integrated VCO |
| Datasheet | ADC12DJ5200RF | 12-Bit, 5.2 GSPS RF Sampling ADC |
| Datasheet | 10GBASE-R/KR | Ethernet PHY Standard (Reference) |
| Datasheet | MT25QU02G | 2Gb Quad-SPI Flash (User) |
| Datasheet | IS25LP256D | 256Mb Quad-SPI Flash (Config) |
| Datasheet | ADM1278 | Hot Swap Controller / Power Monitor |
| Datasheet | ADT7420 | +/-0.5°C Accurate I2C Temperature Sensor |
| User Guide | Xilinx UG476 | SelectIO Resources |
| User Guide | Xilinx UG480 | 7 Series Clocking Wizard |

### 2.2 Internal
| Reference | Document |
| :--- | :--- |
| [HRS] | Hardware Requirements Specification (kjk) |
| [SCH] | Schematic (kjk) |
| [GRS] | General Requirements Specification |
| [GDD] | General Design Document |

---

## 3. Acronyms and Abbreviations

| Acronym | Expansion | Acronym | Expansion |
| :--- | :--- | :--- | :--- |
| **AGC** | Automatic Gain Control | **LSB** | Least Significant Bit |
| **ADC** | Analog to Digital Converter | **LUT** | Look-Up Table |
| **BOM** | Bill of Materials | **LVDS** | Low Voltage Differential Signaling |
| **CLB** | Configurable Logic Block | **LVTTL** | Low Voltage Transistor-Transistor Logic |
| **DAC** | Digital to Analog Converter | **MAC** | Media Access Control |
| **DMA** | Direct Memory Access | **MMCM** | Mixed-Mode Clock Manager |
| **DSP** | Digital Signal Processing | **MSB** | Most Significant Bit |
| **EMC** | Electromagnetic Compatibility | **NF** | Noise Figure |
| **FPGA** | Field Programmable Gate Array | **PCB** | Printed Circuit Board |
| **FF** | Flip-Flop | **PHY** | Physical Layer |
| **GPIO** | General Purpose Input/Output | **PLL** | Phase Locked Loop |
| **GND** | Ground | **QSPI** | Quad Serial Peripheral Interface |
| **HDL** | Hardware Description Language | **RAM** | Random Access Memory |
| **IF** | Intermediate Frequency | **RF** | Radio Frequency |
| **IP** | Intellectual Property | **RTL** | Register Transfer Level |
| **JTAG** | Joint Test Action Group | **SNR** | Signal to Noise Ratio |
| **LO** | Local Oscillator | **SPI** | Serial Peripheral Interface |
| **LNA** | Low Noise Amplifier | **UART** | Universal Asynchronous Receiver/Transmitter |
| **VCC** | Voltage Common Collector | **VCO** | Voltage Controlled Oscillator |

---

## 4. Module Overview

The **kjk Wideband RF Receiver** module is a high-performance signal processing unit designed to intercept and digitize RF signals from 5.0 to 18.0 GHz. The design utilizes a superheterodyne architecture with dual downconversion to maximize sensitivity and dynamic range.

**RF SECTION:**
The RF front-end comprises the **HMC698LP4** LNA providing 20 dB gain and a 2.5 dB Noise Figure. Frequency downconversion is handled by the **HMC1049LC4** double-balanced mixer, translating the 5–18 GHz input to a first IF stage. Frequency synthesis is managed by the **ADF5356** wideband synthesizer (53.125 MHz to 13.6 GHz), providing the Local Oscillator (LO) signal with ultra-low phase noise (-134 dBc/Hz @ 1 MHz). The system employs a triple-conversion architecture (as per BOM暗示) to filter and stage the signal effectively before digitization.

**DIGITAL SECTION:**
The core of the digital subsystem is a Xilinx Kintex-7 FPGA. It interfaces directly with the **ADC12DJ5200RF**, a 12-bit, 5.2 GSPS RF Sampling ADC, via JESD204B lanes. The FPGA performs real-time Digital Down Conversion (DDC), packetization, and control logic for the RF chain. It manages the SPI interfaces for the LO synthesizer, AGC gain settings, and I2C interfaces for system monitoring. Data is offloaded via a Gigabit Ethernet (1000BASE-T) interface.

**POWER SUPPLY SECTION:**
The system operates from a custom DC supply input. Internal rails required include +5.0V (RF Analog), +3.3V (FPGA IO), +1.8V (FPGA Aux), +1.0V (FPGA Core), and +1.2V (ADC/IO). The **ADM1278** provides in-rush current limiting and voltage/current monitoring via I2C. Power sequencing is managed by the FPGA to ensure the RF sections are powered only after the digital logic is stable.

---

## 5. Features
*   **FPGA:** Xilinx Kintex-7 (XC7K325T-FFG900) - High DSP count for DDC.
*   **High-Speed ADC:** TI ADC12DJ5200RF (Dual 12-bit, 5.2 GSPS) with JESD204B output.
*   **RF Coverage:** 5.0 GHz to 18.0 GHz instantaneous coverage via synthesized LO.
*   **LO Synthesis:** Analog Devices ADF5356 (Microwave PLL) with SPI control.
*   **Connectivity:** Gigabit Ethernet (1000BASE-T) for high-throughput I/Q data streaming.
*   **Memory:**
    *   **Configuration Flash:** IS25LP256D (256 Mb QSPI) for FPGA bitstream storage.
    *   **Storage Flash:** MT25QU02G (2 Gb QSPI) for firmware/factor calibration tables.
*   **Communication:**
    *   **UART:** 115200 baud (8N1) for console/command & control.
    *   **SPI:** Master interfaces for LO, Flash, and configuration control.
    *   **I2C:** Interface for temperature (ADT7420) and power (ADM1278) monitoring.
*   **Precision Monitoring:** On-board temperature sensing (+/- 0.5°C accuracy) and voltage/current telemetry.

---

## 6. FPGA Description

**Selection Rationale:**
The Xilinx Kintex-7 FPGA (XC7K325T) was selected to meet the massive data throughput requirements of the 5.2 GSPS ADC interface (JESD204B) and the complex DSP needs for wideband digital down conversion. The device offers a sufficient number of DSP slices for parallel filtering and mixing, along with dedicated transceivers for the Ethernet and JESD204B interfaces.

| S.NO | PARAMETERS | SPECIFICATION |
|:---|:---|:---|
| 1 | Part Number | XC7K325T-FFG900I |
| 2 | Logic Cells | 326,080 |
| 3 | CLB Flip-Flops | 407,200 |
| 4 | Number of Gates | ~5 Million (Equivalent ASIC) |
| 5 | Maximum Distributed RAM (Kb) | 1,710 |
| 6 | Total Block RAM (Kb) | 16,620 |
| 7 | Maximum Single-Ended I/Os | 500 |
| 8 | Maximum DSP Slices | 840 |
| 9 | No of IO Bank | 14 (Banks 15, 16, 17, 18, 34, 35) |

---

## 7. Block Diagram
*(Reference attached PDF. Text description below)*

**Flow:**
Antenna -> Band Select Filter -> LNA (HMC698LP4) -> Mixer (HMC1049LC4) -> IF Amp -> VGA -> Anti-Alias Filter -> ADC (ADC12DJ5200RF).
**Control:**
ADC -> [JESD204B RX] -> FPGA -> [Ethernet TX/RX] -> PHY.
FPGA -> [SPI Master] -> ADF5356 (LO), SPI Flash.
FPGA -> [I2C Master] -> Power Monitor, Temp Sensor.
FPGA -> [UART] -> Debug/Control Interface.

---

## 8. Pinout Details

**Table: FPGA Pin Out Details**

| S.No | Signal Name | Pin No | Voltage Level | Direction wrt FPGA | Source | Destination | Default Condition | Voltage Standard |
|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| 1 | VCCO_15 | N/A | 1.8V | Power | Power Supply | FPGA Bank 15 | On | N/A |
| 2 | VCCO_35 | N/A | 3.3V | Power | Power Supply | FPGA Bank 35 | On | N/A |
| 3 | FPGA_CLK_125M | E12 | 1.8V | Input | Oscillator (Si5341) | FPGA/MMCM | Clock | LVDS |
| 4 | FPGA_RESET_N | D10 | 1.8V | Input | Reset Button | FPGA | Pull High | LVCMOS18 |
| 5 | JTAG_TCK | AA5 | 1.8V | Input | JTAG Header | FPGA | Pull Low | LVCMOS18 |
| 6 | JTAG_TDI | AB5 | 1.8V | Input | JTAG Header | FPGA | Pull Up | LVCMOS18 |
| 7 | JTAG_TDO | Y5 | 1.8V | Output | FPGA | JTAG Header | High Z | LVCMOS18 |
| 8 | JTAG_TMS | AA6 | 1.8V | Input | JTAG Header | FPGA | Pull Up | LVCMOS18 |
| 9 | UART_TX | M19 | 3.3V | Output | FPGA | UART-USB IC | High | LVCMOS33 |
| 10 | UART_RX | L20 | 3.3V | Input | UART-USB IC | FPGA | High Z | LVCMOS33 |
| 11 | ETH_TXD[0] | C4 | 1.8V | Output | FPGA | ETH PHY | High | LVDS_18 |
| 12 | ETH_TXD[1] | B4 | 1.8V | Output | FPGA | ETH PHY | High | LVDS_18 |
| 13 | ETH_RXD[0] | A6 | 1.8V | Input | ETH PHY | FPGA | High Z | LVDS_18 |
| 14 | ETH_RXD[1] | B6 | 1.8V | Input | ETH PHY | FPGA | High Z | LVDS_18 |
| 15 | ETH_GTX_CLK | D3 | 1.8V | Input | ETH PHY | FPGA | Clock | LVDS_18 |
| 16 | ETH_MDC | A5 | 1.8V | Output | FPGA | ETH PHY | Low | LVCMOS18 |
| 17 | ETH_MDIO | B5 | 1.8V | BiDir | FPGA | ETH PHY | High Z | LVCMOS18 |
| 18 | I2C_SDA | K21 | 3.3V | BiDir | FPGA | Temp/Pwr Mon | High Z | LVCMOS33 |
| 19 | I2C_SCL | J21 | 3.3V | Output | FPGA | Temp/Pwr Mon | High | LVCMOS33 |
| 20 | LO_SPI_SCK | F18 | 1.8V | Output | FPGA | ADF5356 | Low | LVCMOS18 |
| 21 | LO_SPI_CS_N | G19 | 1.8V | Output | FPGA | ADF5356 | High | LVCMOS18 |
| 22 | LO_SPI_MOSI | H18 | 1.8V | Output | FPGA | ADF5356 | Low | LVCMOS18 |
| 23 | LO_SPI_MISO | J18 | 1.8V | Input | ADF5356 | FPGA | High Z | LVCMOS18 |
| 24 | LO_MUX_OUT | K19 | 1.8V | Input | ADF5356 | FPGA | Low | LVCMOS18 |
| 25 | FLASH_CS_N | G20 | 3.3V | Output | FPGA | Config Flash | High | LVCMOS33 |
| 26 | FLASH_CLK | H20 | 3.3V | Output | FPGA | Config Flash | Low | LVCMOS33 |
| 27 | FLASH_MOSI | J20 | 3.3V | Output | FPGA | Config Flash | Low | LVCMOS33 |
| 28 | FLASH_MISO | K20 | 3.3V | Input | Config Flash | FPGA | High Z | LVCMOS33 |
| 29 | USER_FLASH_CS_N | M20 | 3.3V | Output | FPGA | Storage Flash | High | LVCMOS33 |
| 30 | ADC_JESD_RX_P | AA15 | 1.0V | Input | ADC12DJ5200RF | FPGA GTY | Diff 100 Ohm | CML_1V0 |
| 31 | ADC_JESD_RX_N | AB15 | 1.0V | Input | ADC12DJ5200RF | FPGA GTY | Diff 100 Ohm | CML_1V0 |
| 32 | ADC_SYNC_N | AA14 | 1.8V | Output | FPGA | ADC | Low | LVCMOS18 |
| 33 | VGA_GAIN_CLK | E16 | 1.8V | Output | FPGA | VGA (HMC698) | Low | LVCMOS18 |
| 34 | VGA_GAIN_DATA | F16 | 1.8V | Output | FPGA | VGA (HMC698) | Low | LVCMOS18 |
| 35 | PA_ENABLE | G16 | 3.3V | Output | FPGA | RF Front End | Low | LVCMOS33 |
| 36 | LED_STATUS | A20 | 3.3V | Output | FPGA | LED Heartbeat | Low | LVCMOS33 |
| 37 | GND | N/A | 0V | Ground | PCB | FPGA | 0V | N/A |

---

## 9. Functional Specifications

| S.No. | Function Name | Description |
|:---|:---|:---|
| 1 | Serial Communication Interface | UART (RS-232/TTL) for command, control, and configuration upload. |
| 2 | High Speed Communication Interface | Gigabit Ethernet (1000BASE-T) for streaming I/Q data. |
| 3 | Power Supply Sequencing & Health Status | Monitor ADM1278 via I2C; sequence 5V -> 3.3V -> 1.0V. |
| 4 | Supply Voltage, Current & Temperature Monitoring | I2C telemetry from ADM1278 (Pwr) and ADT7420 (Temp). |
| 5 | Flash Interfaces | QSPI for Configuration (IS25LP256D) and User Data (MT25QU02G). |
| 6 | TRP Configuration | TRP (Transmit/Receive Pulse) logic for time-domain blanking. |
| 7 | FPGA Remote Programming | Update bitstream in Config Flash via UART protocol. |
| 8 | Phase Shifter Controlling | N/A (Direct frequency conversion architecture utilized). |
| 9 | Beam Steering Calculation | N/A (Single channel receiver). |
| 10 | LO Synthesis Control | SPI interface to ADF5356 for frequency tuning (5-18 GHz). |

### 9.1 Serial Communication Interface
- **Interface type:** UART
- **Physical layer:** TTL level (3.3V), compatible with RS-232 drivers
- **Baud rate:** 115200 bps (8 data bits, 1 stop bit, no parity)
- **USB-UART converter IC:** FT232R (on-board)
- **Signals:** UART_TX (FPGA -> PC), UART_RX (PC -> FPGA)
- **Protocol:** Binary frame-based register access (See Section 11)

### 9.2 High Speed Communication Interface
- **Interface:** Gigabit Ethernet (GMII/RGMII to PHY)
- **PHY:** Marvell 88E1512
- **Data Rate:** 1 Gbps (125 MHz clock)
- **Protocol:** UDP/IP for streaming IQ samples.

### 9.3 Power On/Off Sequence
**Power ON:**
1. Input 12V Supply applied.
2. ADM1278 asserts power good (FPGA_PG_IN).
3. FPGA enables internal regulators (sequenced by hardware).
4. FPGA initializes, reads Mode pins.
5. FPGA enables 5V RF rail via PWR_EN_5V signal.
6. System Ready asserted.

**Mode Configuration:**
| Mode | Signal | Value | Description |
|---|---|---|---|
| Normal | MODE[1:0] | 2'b00 | Operational RX Mode |
| Test | MODE[1:0] | 2'b01 | Built-in Self-Test (Loopback) |
| Programming | MODE[1:0] | 2'b10 | Flash Update Mode |

### 9.4 Supply Voltage, Current & Temperature Monitoring
- **IC Part Number:** ADM1278 (Power), ADT7420 (Temp)
- **Interface:** I2C (Standard mode 100kHz)
- **Monitored Rails:** +12V Input, +5V RF, +1.0V FPGA Core
- **Temp Range:** -40°C to +100°C (Alarm threshold @ 85°C)

### 9.5 Flash & Interfaces
- **Configuration Flash:** IS25LP256D (32 MB)
- **User Flash:** MT25QU02G (256 MB) - Stores LUT tables, cal data.
- **Interface:** QSPI (x4 mode) for high-speed configuration loading.

### 9.6 TRP Configuration
- **Signal:** TRP_N
- **Logic:** Active High. Enables RF Front-end during valid RX window.

### 9.7 FPGA Remote Programming
- **Protocol:** UART Binary Protocol
- **Procedure:** Host sends "Program Mode" command -> FPGA acks -> Host sends Bitstream -> FPGA writes to SPI Flash -> FPGA Reboot.

### 9.8 Phase Shifter Controlling
- *N/A for this receiver architecture.*

### 9.9 Beam Steering Calculation
- *N/A for this receiver architecture.*

### 9.10 Gate Voltage Writing in DAC
- *Not utilized in this specific design.*

---

## 10. Software Register Address Map

### 10.1 Register Base Addresses

| Block Name | Base Address | Address Range | Description |
| :--- | :--- | :--- | :--- |
| System / Identification | 0x0000 | 0x0000–0x00FF | Board ID, firmware version, status |
| UART Control | 0x0100 | 0x0100–0x01FF | Baud rate, FIFO control |
| SPI Control | 0x0200 | 0x0200–0x02FF | SPI master, ADF5356 control |
| I2C Control | 0x0300 | 0x0300–0x03FF | I2C master, Temp/Pwr monitor |
| GPIO | 0x0400 | 0x0400–0x04FF | Leds, Enables, Mode pins |
| PLL/LO Control | 0x0500 | 0x0500–0x05FF | ADF5356 shadow registers |
| ADC/JESD Control | 0x0600 | 0x0600–0x06FF | ADC Gain, Test patterns |
| Ethernet Control | 0x0700 | 0x0700–0x07FF | MAC Address, Dest IP, Port |
| RF Control | 0x0800 | 0x0800–0x08FF | Gain settings, TRP |
| Flash / EEPROM | 0x0900 | 0x0900–0x09FF | Flash address, data |
| Diagnostics | 0x0A00 | 0x0A00–0x0AFF | Fault log, uptime |

### 10.2 Detailed Register Map

**Block 0x0000 — System / Identification**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|:---|:---|:---|:---|:---|:---|
| 0x00 | BOARD_ID | 16 | R | 0x4B4A | 'kJ' Magic Number |
| 0x01 | FW_VERSION_MAJOR | 16 | R | 0x0001 | Firmware major version |
| 0x02 | FW_VERSION_MINOR | 16 | R | 0x0002 | Firmware minor version |
| 0x03 | SYS_STATUS | 16 | R | 0x0000 | [15:8] Reserved, [7] ETH_LINK, [6] TEMP_ALERT, [5] PWR_GOOD, [4] ADC_LOCKED, [3:0] Reserved |
| 0x04 | SYS_RESET | 16 | W | 0x0000 | [0] SOFT_RESET (Self-clearing) |

**Block 0x0100 — UART Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|:---|:---|:---|:---|:---|:---|
| 0x00 | UART_BAUD_DIV | 16 | R/W | 0x0026 | Baud divisor (default 115200) |
| 0x01 | UART_CTRL | 16 | R/W | 0x0001 | [0] UART_ENABLE, [1] LOOPBACK |
| 0x02 | UART_STATUS | 16 | R | 0x0000 | [0] TX_BUSY, [1] RX_READY |

**Block 0x0200 — SPI Control (LO/Flash)**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|:---|:---|:---|:---|:---|:---|
| 0x00 | SPI_TX_DATA | 32 | W | 0x00000000 | Data to shift out |
| 0x01 | SPI_RX_DATA | 32 | R | 0x00000000 | Data shifted in |
| 0x02 | SPI_CTRL | 16 | R/W | 0x0000 | [1:0] DEVICE_SEL (00=Flash, 01=LO), [2] START, [3] CPHA |
| 0x03 | SPI_DIV | 16 | R/W | 0x000A | Clock divisor (SCK = Core/Div) |

**Block 0x0500 — PLL Control (ADF5356)**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|:---|:---|:---|:---|:---|:---|
| 0x00 | LO_REG_00 | 32 | R/W | 0x00000000 | ADF5356 Register 0 (Int) |
| ... | ... | ... | ... | ... | ... (See ADF5356 Datasheet for reg map) |
| 0x0C | LO_FREQ_HZ | 32 | W | 0x00000000 | Writes desired frequency, triggers calc |
| 0x0D | LO_STATUS | 16 | R | 0x0000 | [0] MUX_LOCK (Status of PLL) |

**Block 0x0800 — RF Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|:---|:---|:---|:---|:---|:---|
| 0x00 | RF_GAIN | 16 | R/W | 0x0000 | Gain index for VGA (0-31) |
| 0x01 | RF_TRP_EN | 16 | R/W | 0x0000 | [0] TRP_ENABLE (Time domain blanking) |
| 0x02 | RF_FREQ_SEL | 16 | R/W | 0x0000 | [3:0] Band Select (0=5-8G, 1=8-12G, etc) |

---

## 11. UART Register Protocol Specification

### 11.1 Physical Layer
- **Baud rate:** 115200 bps
- **Frame format:** 8N1 (1 start, 8 data, 1 stop, no parity)
- **Interface:** UART (TTL)

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

### 11.3 Protocol Timing Constraints
| Parameter | Min | Typical | Max | Unit |
|:---|:---|:---|:---|:---|
| Inter-byte gap (TX side) | — | — | 50 | ms |
| Single Write response time | — | 0.5 | 1 | ms |
| Single Read response time | — | 1 | 2 | ms |

---

## 12. FPGA Resource Utilization Estimate

| Resource | Available | Estimated Usage | Utilization % |
|:---|:---|:---|:---|
| Slice LUTs | 203,800 | 85,000 | 41.7% |
| Slice Flip-Flops | 407,200 | 100,000 | 24.5% |
| Block RAM (36Kb) | 445 | 150 | 33.7% |
| DSP Slices | 840 | 200 | 23.8% |
| GTX Transceivers | 16 | 4 (2 ETH, 2 JESD) | 25% |
| MMCM/PLL | 10 | 3 | 30% |

**Synthesis Tool:** Vivado 2024.1
**Target Device:** XC7K325T-FFG900I
**Primary Clock:** 125 MHz (Ethernet) / 156.25 MHz (JESD204B)

---

## Annexure A — Requirement Traceability Matrix

| S.No | GLR-ID | Description | Source HRS Section | GLR Section | Verification Method | Status |
|:---|:---|:---|:---|:---|:---|:---|
| 1 | GLR-001 | Serial Communication Interface | HRS §3.3 | 9.1, 11 | Test | Open |
| 2 | GLR-002 | High Speed Communication | HRS §3.3 (REQ-HW-007) | 9.2 | Test | Open |
| 3 | GLR-003 | Power Supply Sequencing | HRS §3.3 (REQ-HW-014) | 9.3 | Test | Open |
| 4 | GLR-004 | Voltage/Current/Temperature Monitoring | HRS §3.2 (REQ-HW-015) | 9.4 | Test | Open |
| 5 | GLR-005 | Flash Interfaces | HRS §3.1 | 9.5 | Test | Open |
| 6 | GLR-006 | TRP Configuration | HRS §3.1 | 9.6 | Inspection | Open |
| 7 | GLR-007 | FPGA Remote Programming | HRS §3.1 | 9.7 | Demonstration | Open |
| 8 | GLR-008 | LO Synthesis Control | HRS §3.2 (REQ-HW-012) | 9.10 | Test | Open |
| 9 | GLR-009 | Register Address Map | HRS §3.1 | 10 | Inspection | Open |
| 10 | GLR-010 | UART Protocol Specification | HRS §3.1 | 11 | Test | Open |
| 11 | GLR-011 | FPGA Resource Budget | HRS §3.1 | 12 | Analysis | Open |
| 12 | GLR-012 | Operating Frequency Range Support | HRS §3.2 (REQ-HW-001) | 9.10 | Test | Open |
| 13 | GLR-013 | GigE Interface Support | HRS §3.2 (REQ-HW-007) | 9.2 | Test | Open |
| 14 | GLR-014 | Environmental Monitoring | HRS §3.2 (REQ-HW-008) | 9.4 | Test | Open |