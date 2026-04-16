# Glue Logic Requirements (GLR)

## Document Control
| Document Title | Glue Logic Requirements |
| :--- | :--- |
| **Project Name** | **mnb (Wideband RF Receiver)** |
| Version Date | **17.04.2026** |
| Version Number | **0V01** |
| Prepared By | Name: . Sign: |
| Document Review By | Name: . Sign: |

---

## Amendments to the Document
| S. No. | Ver. No. | Ver. Date | Changed By | Section(s) Changed | Description of Change |
|:---:|:---:|:---:|:---:|:---|:---|
| 1 | 0V01 | 17.04.2026 | - | - | Initial Version |

---

## 1. Scope of the Document
This document details the Input/Output (I/O) interfaces, functional logic requirements, and register map definitions for the **XCZU4EG-SFVC784 FPGA** within the **mnb Wideband RF Receiver** project. It serves as the critical bridge between the hardware schematic/netlist and the firmware HDL design.

This specification defines the glue logic required to interface the FPGA with the RF Front End (LNA, Mixer), High-Speed ADC (ADC12DJ3200), PLL Synthesizer (ADF5355), Ethernet PHY, and configuration memories.

---

## 2. References

### 2.1 External
| Doc. Type | Part No. | Description |
|:---|:---|:---|
| Datasheet | **XCZU4EG-SFVC784** | AMD Xilinx Zynq UltraScale+ MPSoC |
| Datasheet | **ADC12DJ3200** | TI 12-Bit, 6.4 GSPS RF Sampling ADC |
| Datasheet | **ADF5355** | Analog Devices Microwave Wideband Synthesizer |
| Datasheet | **HMC698LP4** | Analog Devices GaAs MMIC Amplifier / DVGA |
| Datasheet | **HMC1061LP4** | Analog Devices Double Balanced Mixer |
| Datasheet | **88E1512** | Marvell Alaska Gigabit Ethernet PHY (Assumed) |
| Datasheet | **AT25M01** | 1Mb SPI EEPROM for Board ID |

### 2.2 Internal
| Reference | Document |
|:---|:---|
| **[HRS]** | Hardware Requirements Specification (mnb) |
| **[SCH]** | Schematic Schematics (Netlist P4) |
| **[GRS]** | General Requirements Specification |
| **[GDD]** | General Design Document |

---

## 3. Acronyms and Abbreviations
| Acronym | Expansion |
|:---|:---|
| **AGC** | Automatic Gain Control |
| **ADC** | Analog-to-Digital Converter |
| **BOM** | Bill of Materials |
| **CLB** | Configurable Logic Block |
| **DAC** | Digital-to-Analog Converter |
| **DMA** | Direct Memory Access |
| **DSP** | Digital Signal Processing |
| **EMC** | Electromagnetic Compatibility |
| **FCC** | Federal Communications Commission |
| **FF** | Flip-Flop |
| **FIFO** | First-In-First-Out |
| **FPGA** | Field-Programmable Gate Array |
| **GND** | Ground |
| **GPIO** | General Purpose Input/Output |
| **HDL** | Hardware Description Language |
| **I2C** | Inter-Integrated Circuit |
| **IF** | Intermediate Frequency |
| **LO** | Local Oscillator |
| **LUT** | Look-Up Table |
| **LVTTL** | Low Voltage Transistor-Transistor Logic |
| **LVDS** | Low-Voltage Differential Signaling |
| **PCB** | Printed Circuit Board |
| **PLL** | Phase-Locked Loop |
| **POR** | Power-On Reset |
| **RF** | Radio Frequency |
| **RoHS** | Restriction of Hazardous Substances |
| **RTL** | Register Transfer Level |
| **RX** | Receive |
| **SPI** | Serial Peripheral Interface |
| **SSTL** | Stub Series Terminated Logic |
| **TRP** | Transmit/Receive Pulse (or Control) |
| **UART** | Universal Asynchronous Receiver-Transmitter |
| **VCC** | Voltage Common Collector |
| **VCO** | Voltage-Controlled Oscillator |

---

## 4. Module Overview

The **mnb** module is a high-performance Wideband RF Receiver designed for 5.0 GHz to 18.0 GHz signal interception and digitization.

**RF SECTION:**
The signal chain begins with an **SMA Input** followed by an **HMC698LP4** Low Noise Amplifier (LNA) providing 15.5 dB gain. The signal passes through a Bandpass Filter (5-18 GHz) into a Variable Gain Amplifier (VGA) stage (AGC control). Downconversion is handled by an **HMC1061LP4** Mixer, which accepts an LO input from the frequency synthesizer. The resulting IF signal is filtered and amplified before digitization.

**DIGITAL SECTION:**
The core of the digital section is the **XCZU4EG-SFVC784 Zynq UltraScale+ MPSoC**. It receives high-speed sampled data via JESD204B/SerDes from the **ADC12DJ3200**. The FPGA performs DSP (DDC, Filtering), and packetizes the I/Q data for transmission over a Gigabit Ethernet interface (RGMII/1000BASE-T). Control interfaces include SPI for the **ADF5355** PLL and **HMC698LP4** DVGA, and I2C for monitoring board health (Temperature, Power). Configuration is stored in external QSPI Flash.

**POWER SUPPLY SECTION:**
The board accepts +3.3V, +5V, and +12V DC inputs.
- **+12V**: Supplies the RF Power Amplifiers and high-current RF stages.
- **+5V**: Supplies the PLL synthesizer and Ethernet PHY.
- **+3.3V**: Supplies the FPGA IO Banks and auxiliary logic.
- Internal DC-DC converters (simulated in Netlist as U2/PWR) generate +1.0V (FPGA Core/VCCINT), +1.8V (FPGA RAM/IO), and +2.5V (ADC Clock Drivers).

---

## 5. Features
- **FPGA:** Xilinx XCZU4EG-SFVC784 (Zynq UltraScale+ MPSoC).
- **Processing:** Dual-core ARM Cortex-A53 + 53K Logic Cells.
- **ADC:** TI ADC12DJ3200 (12-bit, Dual 3.2 GSPS / Single 6.4 GSPS).
- **RF Range:** 5.0 GHz – 18.0 GHz Continuous Coverage.
- **LO Synthesis:** ADF5355 (13.6 GHz max output, <0.1 Hz resolution).
- **Data Interface:** Gigabit Ethernet (1000BASE-T) for streaming I/Q data.
- **Control Interface:** UART (Configuration/Debug), SPI (PLL/VGA Control), I2C (Sensors).
- **Configuration:** QSPI Flash (Xilinx standard) + Fallback JTAG.
- **Calibration:** On-board EEPROM for gain/phase correction tables.
- **Timing:** High-precision clock generation with <500 fs jitter.

---

## 6. FPGA Description

The **XCZU4EG-SFVC784** was selected to meet the high-throughput signal processing requirements of the mnb project. Its PS (Processing System) handles high-level control and Ethernet protocol stack, while the PL (Programmable Logic) handles the high-speed ADC interface and DSP.

**Specification Table:**

| S.NO | PARAMETERS | SPECIFICATION |
|:---:|:---|:---|
| 1 | Part Number | XCZU4EG-SFVC784I (Industrial Grade) |
| 2 | Logic Cells | ~50,000 (53,200) |
| 3 | CLB Flip-Flops | 106,400 |
| 4 | Number of Gates | 1.3M (ASIC equiv.) |
| 5 | Maximum Distributed RAM | 1750 Kb |
| 6 | Total Block RAM | 2.7 Mb |
| 7 | Maximum Single-Ended I/Os | 276 |
| 8 | Maximum DSP Slices | 192 (pre DSP48E2) |
| 9 | No of IO Bank | 4 (PS) + 2 (PL) Banks typically |
| 10 | Transceivers | 4 x 12.5 Gbps GTs (Used for ADC JESD204B) |

---

## 7. Block Diagram
*(Textual Description of Reference Block Diagram)*
The RF signal enters the **LNA** -> **Mixer** (LO fed by **PLL**) -> **Filter** -> **ADC**.
**ADC** output connects to **FPGA GTY Transceivers** (JESD204B).
**FPGA PS** connects to **Eth PHY** via **RGMII** and **Host PC**.
**FPGA PL** connects to **EEPROM** (SPI), **Temp Sensors** (I2C), and **DACs** for RF Gain Control (SPI).

---

## 8. Pinout Details

**Table: FPGA Pin Out Details (Selected Primary Signals)**

| S.No | Signal Name | Pin No (Bank) | Voltage Level | Direction | Source | Destination | Default | Std |
|:---:|:---|:---:|:---:|:---:|:---|:---|:---|:---|
| **Power** |
| 1 | VCCINT | - | 1.0V | PWR | Regulator | FPGA Core | - | - |
| 2 | VCCAUX | - | 1.8V | PWR | Regulator | FPGA Aux | - | - |
| 3 | VCCO_34 | - | 3.3V | PWR | Regulator | Bank 34 IO | - | - |
| 4 | VCCO_35 | - | 1.8V | PWR | Regulator | Bank 35 IO | - | - |
| **Clock & Reset** |
| 5 | FPGA_CLK_125M | E12 | 1.8V | IN | Eth Phy | FPGA PS | High | LVCMOS18 |
| 6 | FPGA_RESET_N | K15 | 1.8V | IN | Sys Ctrl | Reset Logic | PullUp | LVCMOS18 |
| 7 | POR_N | M14 | 1.8V | IN | Supervisr | FPGA_PS | High | LVCMOS18 |
| **JTAG** |
| 8 | TCK | T1 | 1.8V | IN | JTAG Header | FPGA_JTAG | PullDown | LVCMOS18 |
| 9 | TDI | R3 | 1.8V | IN | JTAG Header | FPGA_JTAG | PullDown | LVCMOS18 |
| 10 | TDO | P2 | 1.8V | OUT | FPGA_JTAG | JTAG Header | - | LVCMOS18 |
| 11 | TMS | R1 | 1.8V | IN | JTAG Header | FPGA_JTAG | PullUp | LVCMOS18 |
| **Serial Control** |
| 12 | UART_TX | AA20 | 3.3V | OUT | FPGA_PS | USB-UART | High | LVCMOS33 |
| 13 | UART_RX | AB20 | 3.3V | IN | USB-UART | FPGA_PS | - | LVCMOS33 |
| 14 | UART_CTS | Y19 | 3.3V | IN | USB-UART | FPGA_PS | - | LVCMOS33 |
| 15 | UART_RTS | Y20 | 3.3V | OUT | FPGA_PS | USB-UART | High | LVCMOS33 |
| **SPI (Config)** |
| 16 | SPI_CLK | D15 | 3.3V | OUT | FPGA_PS | Flash | Low | LVCMOS33 |
| 17 | SPI_MOSI | E14 | 3.3V | OUT | FPGA_PS | Flash | Low | LVCMOS33 |
| 18 | SPI_MISO | F15 | 3.3V | IN | Flash | FPGA_PS | - | LVCMOS33 |
| 19 | SPI_CS_N | G14 | 3.3V | OUT | FPGA_PS | Flash | High | LVCMOS33 |
| **I2C (Sensors)** |
| 20 | I2C_SCL | H12 | 1.8V | BiDi | FPGA_PS | Temp/Pwr | High | LVCMOS18 |
| 21 | I2C_SDA | J13 | 1.8V | BiDi | FPGA_PS | Temp/Pwr | High | LVCMOS18 |
| **RF Control** |
| 22 | PLL_SPI_CLK | A10 | 1.8V | OUT | FPGA_PL | ADF5355 | Low | LVCMOS18 |
| 23 | PLL_DATA | B10 | 1.8V | OUT | FPGA_PL | ADF5355 | Low | LVCMOS18 |
| 24 | PLL_CS_N | C11 | 1.8V | OUT | FPGA_PL | ADF5355 | High | LVCMOS18 |
| 25 | PLL_LE | D11 | 1.8V | OUT | FPGA_PL | ADF5355 | Low | LVCMOS18 |
| 26 | VGA_GAIN_CLK | E10 | 1.8V | OUT | FPGA_PL | HMC698 | Low | LVCMOS18 |
| 27 | VGA_GAIN_DAT | F10 | 1.8V | OUT | FPGA_PL | HMC698 | Low | LVCMOS18 |
| 28 | TRP_CTRL | G12 | 1.8V | OUT | FPGA_PL | Mixer/LNA | Low | LVCMOS18 |
| **Gigabit Ethernet** |
| 29 | ETH_TXCLK | M2 | 1.8V | OUT | FPGA_PS | Eth Phy | Low | LVCMOS18 |
| 30 | ETH_TXD[0] | N1 | 1.8V | OUT | FPGA_PS | Eth Phy | Low | LVCMOS18 |
| 31 | ETH_TXD[1] | M1 | 1.8V | OUT | FPGA_PS | Eth Phy | Low | LVCMOS18 |
| 32 | ETH_RXCLK | P1 | 1.8V | IN | Eth Phy | FPGA_PS | - | LVCMOS18 |
| 33 | ETH_RXD[0] | R2 | 1.8V | IN | Eth Phy | FPGA_PS | - | LVCMOS18 |
| 34 | ETH_RXD[1] | T2 | 1.8V | IN | Eth Phy | FPGA_PS | - | LVCMOS18 |
| 35 | ETH_MDIO | L4 | 1.8V | BiDi | FPGA_PS | Eth Phy | High | LVCMOS18 |
| 36 | ETH_MDC | K5 | 1.8V | OUT | FPGA_PS | Eth Phy | Low | LVCMOS18 |
| **ADC Interface** |
| 37 | ADC_CLK_P | E1 | - | IN | ADC | GTY_P | - | CML |
| 38 | ADC_CLK_N | F1 | - | IN | ADC | GTY_N | - | CML |
| 39 | ADC_RX_P | G1 | - | IN | ADC | GTY_P | - | CML |
| 40 | ADC_RX_N | H1 | - | IN | ADC | GTY_N | - | CML |

*(Note: Pins are representative of Zynq MPSoC package mapping. VCCO banks are assigned 1.8V for high-speed interfaces and 3.3V for standard SPI/boot Flash)*.

---

## 9. Functional Specifications

| S.No. | Function Name | Description |
|:---:|:---|:---|
| 1 | Serial Communication | UART for command & control (Configuration of PLL, VGA). |
| 2 | High Speed Data | JESD204B interface to ADC12DJ3200 (Lane Rate ~6.144 Gbps). |
| 3 | Power Sequencing | Monitors VCCINT, VCCAUX; Enables RF power rails only after FPGA configuration. |
| 4 | Supply Monitoring | I2C interface to ADC (e.g., LTC2992) for V/I/T monitoring. |
| 5 | Configuration | QSPI Boot from Configuration Flash. |
| 6 | RF Control | SPI interface to ADF5355 (PLL) and Serial interface to HMC698 (VGA). |
| 7 | Remote Programming | Updating bitstream via UART protocol. |
| 8 | Beam/Gain Control | AGC loops setting VGA gain based on ADC power levels. |
| 9 | Ethernet Streaming | UDP/IP packetization of I/Q samples. |

### 9.1 Serial Communication Interface
- **Interface Type:** UART (NS16550 compatible).
- **Physical Layer:** RS-232 / USB-UART bridge (FTDI).
- **Baud Rate:** 921,600 bps default (Configurable).
- **Format:** 8-N-1 (8 data, no parity, 1 stop).
- **Signals:** `UART_TX`, `UART_RX`, `UART_RTS`, `UART_CTS`.
- **Protocol:** Frame-based binary protocol with Header/Checksum (See Sec 11).

### 9.2 High Speed Communication Interface
- **Standard:** JESD204B Subclass 1.
- **Lanes:** 1 Lane (ADC in Dual-channel mode or Decimated mode).
- **Data Rate:** 6.144 Gbps.
- **Lane Mapping:** ADC Lane 0 -> FPGA GTY Transceiver 0.

### 9.3 Power On/Off Sequence
1. **+3.3V** applied to FPGA VCCO.
2. **FPGA_PS** powers up (Internal 1.0V core).
3. **FPGA_DONE** pin goes High.
4. Firmware asserts **RF_PWR_EN** signal.
5. **+12V** regulator enabled (for LNA/Mixer).
6. **ADF5355** PLL Initialized via SPI.

### 9.4 Supply Voltage, Current & Temperature Monitoring
- **IC:** LTC2992 (Dual Voltage/Current Monitor).
- **Interface:** I2C (Address 0x6F).
- **Monitored Rails:** +12V RF Input, +3.3V Digital IO, +1.0V Core.
- **Action:** Trigger `SYS_STATUS[5]` (VOLT_FAULT) if >10% deviation.

### 9.5 Flash & Interfaces
- **Config Flash:** Micron MT25QU01GB (1 Gb QSPI).
- **Usage:** Primary Boot image (FSBL), U-Boot, Linux/RTOS.
- **EEPROM:** AT25M01 (1 Mb SPI EEPROM) for Board Calibration Data (Serial Number, Gain Lookup Tables).

### 9.6 RF Control Configuration
- **PLL:** ADF5355 controlled via 3-wire Serial Interface (`CLK`, `DATA`, `LE`). Frequency writes trigger VCO calibration (t_lock < 100 us).
- **VGA:** HMC698 controlled via Serial Data (Shift Register). Gain setting 0-30 dB in 1 dB steps.

### 9.7 FPGA Remote Programming
- **Protocol:** UART Frame (See Sec 11).
- **Mechanism:** Host writes `.bit` image to `0x0900` Flash Block. FPGA triggers soft reset to reload from Flash.

### 9.8 Gain/Phase Control
- **ADC SPI:** Used for internal gain adjustment and test patterns.
- **Algorithm:** FPGA DSP monitors RMS level of received I/Q data; adjusts VGA SPI register to target -10 dBFS ADC level.

### 9.9 Data Streaming
- **Format:** UDP Packet.
- **Payload:** 1024 I/Q Samples (16-bit I + 16-bit Q x 1024).
- **Header:** Sequence Counter, Timestamp.

---

## 10. Software Register Address Map

### 10.1 Register Base Addresses

| Block Name | Base Address | Address Range | Description |
|------------|-------------|---------------|-------------|
| System / Identification | 0x0000 | 0x0000–0x00FF | Board ID, firmware version |
| UART Control | 0x0100 | 0x0100–0x01FF | Baud rate, FIFO status |
| SPI Control | 0x0200 | 0x0200–0x02FF | PLL/VGA SPI master |
| I2C Control | 0x0300 | 0x0300–0x03FF | Temp/Pwr monitor I2C |
| GPIO | 0x0400 | 0x0400–0x04FF | LED, TRP, RF Enable |
| PLL Control | 0x0500 | 0x0500–0x05FF | ADF5355 Registers (Indirect) |
| ADC Control | 0x0600 | 0x0600–0x06FF | JESD204B Config, ADC Gain |
| RF Control | 0x0700 | 0x0700–0x07FF | Attenuation, TRP control |
| Flash / EEPROM | 0x0800 | 0x0800–0x08FF | Flash address, data |
| Ethernet / Stream | 0x0900 | 0x0900–0x09FF | Dest IP, Port, Enable |
| Diagnostics | 0x0A00 | 0x0A00–0x0AFF | Fault log, uptime |

### 10.2 Detailed Register Map

**Block 0x0000 — System / Identification**

| Offset | Register Name | Width | R/W | Reset | Description |
|--------|--------------|-------|-----|-------|-------------|
| 0x00 | BOARD_ID | 16 | R | 0x4D4E | 'MN' ASCII ID |
| 0x01 | FW_VERSION | 16 | R | 0x0100 | v1.0 |
| 0x02 | SYS_STATUS | 16 | R | 0x0000 | [15:8] Reserved, [7] PLL_LOCK, [6] TEMP_ALERT, [5] VOLT_FAULT, [4] ADC_LOCK, [3:0] INIT_STATE |
| 0x03 | SYS_CTRL | 16 | W | 0x0000 | [0] SOFT_RESET, [1] RF_PWR_EN, [2] STREAM_EN |

**Block 0x0200 — SPI Control (PLL/VGA)**

| Offset | Register Name | Width | R/W | Reset | Description |
|--------|--------------|-------|-----|-------|-------------|
| 0x00 | SPI_DATA | 32 | W | 0x0 | Data to be shifted out (MSB first) |
| 0x02 | SPI_CTRL | 16 | W | 0x0 | [0] START, [1] AUTO_CS, [8:4] BIT_COUNT |
| 0x03 | SPI_STATUS | 16 | R | 0x0 | [0] BUSY, [1] DONE |

**Block 0x0500 — PLL Control (ADF5355)**

| Offset | Register Name | Width | R/W | Reset | Description |
|--------|--------------|-------|-----|-------|-------------|
| 0x00 | PLL_REG0 | 32 | W | 0x0 | ADF5355 Reg 0 (Int, Frac) |
| 0x01 | PLL_REG1 | 32 | W | 0x0 | ADF5355 Reg 1 (Modulus) |
| 0x02 | PLL_FREQ_HI | 16 | W | 0x0 | Frequency (MHz) High Word |
| 0x03 | PLL_FREQ_LO | 16 | W | 0x0 | Frequency (MHz) Low Word |
| 0x04 | PLL_CMD | 16 | W | 0x0 | [0] WRITE_FREQ, [1] CALIBRATE |

**Block 0x0600 — ADC Control (ADC12DJ3200)**

| Offset | Register Name | Width | R/W | Reset | Description |
|--------|--------------|-------|-----|-------|-------------|
| 0x00 | ADC_GAIN | 16 | W | 0x0 | 0x00 = 0dB ... 0x0F = Max Fine Gain |
| 0x01 | ADC_MODE | 16 | W | 0x0 | [0] DES_MODE (1=Dual, 0=Single) |
| 0x02 | ADC_STATUS | 16 | R | 0x0 | [0] JESD_LOCK, [1] PLL_LOCK |

**Block 0x0900 — Ethernet / Streaming**

| Offset | Register Name | Width | R/W | Reset | Description |
|--------|--------------|-------|-----|-------|-------------|
| 0x00 | DEST_IP_0 | 16 | W | 0x0 | Dest IP Byte 3 & 2 |
| 0x01 | DEST_IP_1 | 16 | W | 0x0 | Dest IP Byte 1 & 0 |
| 0x02 | DEST_PORT | 16 | W | 0x0 | UDP Destination Port |
| 0x03 | STREAM_CTRL | 16 | W | 0x0 | [0] START_STREAM, [1] STOP_STREAM |

---

## 11. UART Register Protocol Specification

### 11.1 Physical Layer
- **Baud Rate:** 921,600 bps (Default)
- **Data Bits:** 8
- **Parity:** None
- **Stop Bits:** 1
- **Byte Order:** Little Endian (LSB first for register values)

### 11.2 Command Frame Formats

**Single Register Write (CMD = 0x57 'W')**
| Byte Index | Value | Description |
|:---:|:---:|:---|
| 0 | 0x57 | Command Write |
| 1 | ADDR[15:8] | Address MSB |
| 2 | ADDR[7:0] | Address LSB |
| 3 | DATA[15:8] | Data MSB |
| 4 | DATA[7:0] | Data LSB |
| **Response** | 0x06 | ACK (Success) |

**Single Register Read (CMD = 0x52 'R')**
| Byte Index | Value | Description |
|:---:|:---:|:---|
| 0 | 0x52 | Command Read |
| 1 | ADDR[15:8] | Address MSB |
| 2 | ADDR[7:0] | Address LSB |
| **Response** | DATA_H | Data MSB |
| **Response+1** | DATA_L | Data LSB |

**Bulk Register Write (CMD = 0x42 'B')**
| Byte Index | Value | Description |
|:---:|:---:|:---|
| 0 | 0x42 | Command Bulk Write |
| 1 | ADDR[15:8] | Start Address MSB |
| 2 | ADDR[7:0] | Start Address LSB |
| 3 | N | Count (1-32) |
| 4 ... | DATA... | Packed 16-bit Data (Low, High) |
| **Response** | 0x06 | ACK |

**Error Response**
| Byte Index | Value | Description |
|:---:|:---:|:---|
| 0 | 0x15 | NAK (Invalid Address/CRC/CMD) |

### 11.3 Protocol Timing Constraints
| Parameter | Max Value | Unit |
|---|---|---|
| Inter-byte gap (Response) | 10 | ms |
| Bulk Write Size | 32 | words |

---

## 12. FPGA Resource Utilization Estimate

| Resource | Available | Estimated Usage | Utilization % |
|---------|-----------|----------------|--------------|
| Slice LUTs | 53,200 | 22,000 | 41% |
| Slice Flip-Flops | 106,400 | 15,000 | 14% |
| Block RAM (36Kb) | 144 | 48 | 33% |
| DSP Slices | 192 | 64 | 33% |
| PLL/MMCM | 4 | 2 | 50% |
| GTY Transceivers | 4 | 1 | 25% |

**Synthesis Tool:** Vivado 2024.1
**Target Device:** XCZU4EG-SFVC784
**Primary Clock:** 125 MHz (PS), 200 MHz (PL), 491.52 MHz (JESD204B Core)

---

## Annexure A — Requirement Traceability Matrix

| S.No. | GLR-ID | Description | Source HRS ID | GLR Section | Verification | Status |
|-------|--------|-------------|---------------|-------------|--------------|--------|
| 1 | GLR-001 | RF Input Freq Range 5-18 GHz | REQ-HW-001 | 4, 9.6 | Test | Open |
| 2 | GLR-002 | Input Power Handling -30 dBm | REQ-HW-005 | 4 | Analysis | Open |
| 3 | GLR-003 | SPI Interface for PLL Tuning | REQ-HW-009 | 8, 10, 11 | Test | Open |
| 4 | GLR-004 | VGA Gain Control (30 dB) | REQ-HW-011 | 9.6, 10.2 | Test | Open |
| 5 | GLR-005 | Multi-Voltage Power Supply | REQ-HW-016 | 4, 9.3 | Inspection | Open |
| 6 | GLR-006 | Gigabit Ethernet Interface | REQ-HW-027 | 8, 9.9 | Test | Open |
| 7 | GLR-007 | ADC Sample Rate Support >2 GSPS | REQ-HW-030 | 7, 9.2 | Test | Open |
| 8 | GLR-008 | Noise Figure 6-10 dB | REQ-HW-003 | 4 | Analysis | Open |
| 9 | GLR-009 | I/Q Balance Correction | REQ-HW-019 | 9.4, 10.2 | Test | Open |
| 10 | GLR-010 | Operating Temp -40 to +85 C | HRS Intro | 4 | Analysis | Open |

---
**End of Document**