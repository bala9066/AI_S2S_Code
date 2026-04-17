# Glue Logic Requirements (GLR)

## Document Control
| Document Title | Glue Logic Requirements |
| :--- | :--- |
| **Project Name** | **receiver** |
| Version Date | 17.04.2026 |
| Version Number | 0V01 |
| Prepared By | **Name:** . **Sign:** |
| Document Review By | **Name:** . **Sign:** |

---

## Amendments to the Document
| S. No. | Ver. No. | Ver. Date | Changed By | Section(s) Changed | Description of Change |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | 0V01 | 17.04.2026 | - | - | Initial Version |

---

## 1. Scope of the Document
This document details the Input/Output (I/O) interfaces, functional logic requirements, and register map definitions for the **XCZU3EG-SFVA784** FPGA within the **receiver** project. It serves as the bridge between the hardware netlist (P4) and the FPGA HDL design (P7), defining the Glue Logic required to control the RF Front End (LNA/Mixer), synthesize the Local Oscillator, manage the Power Supply, and interface with the ADC.

**Target Audience:** FPGA Design Engineers, Firmware Engineers, and Hardware Integration Engineers.

---

## 2. References

### 2.1 External
| Doc. Type | Part No. | Description |
| :--- | :--- | :--- |
| Datasheet | **XCZU3EG-SFVA784** | Zynq UltraScale+ MPSoC Data Sheet (DC and AC Switching Characteristics) |
| Datasheet | **ADC12DJ3200** | 12-Bit, 3.2 GSPS, Dual ADC |
| Datasheet | **HMC698LP4** | GaAs MMIC PHEMT Wideband Variable Gain Amplifier |
| Datasheet | **HMC1048LP4E** | Wideband I/Q Demodulator |
| Datasheet | **ADF5355** | Wideband Synthesizer with Integrated VCO |
| Datasheet | **LTM4644** | Quad 4A DC-DC Converter |
| Datasheet | **LT1054** | Switched-Capacitor Voltage Converter |

### 2.2 Internal
| Reference | Document |
| :--- | :--- |
| **[HRS]** | Hardware Requirements Specification (P2) |
| **[SCH]** | Schematic (P4 Netlist) |
| **[GRS]** | General Requirements Specification |
| **[GDD]** | General Design Document |

---

## 3. Acronyms and Abbreviations
| Acronym | Expansion |
| :--- | :--- |
| **ADC** | Analog-to-Digital Converter |
| **AFC** | Automatic Frequency Control |
| **AGC** | Automatic Gain Control |
| **BGA** | Ball Grid Array |
| **BRAM** | Block RAM (FPGA on-chip memory) |
| **CLB** | Configurable Logic Block |
| **CPLD** | Complex Programmable Logic Device |
| **DAC** | Digital-to-Analog Converter |
| **DMA** | Direct Memory Access |
| **DSP** | Digital Signal Processing / Slice |
| **EMC** | Electromagnetic Compatibility |
| **FCC** | Federal Communications Commission |
| **FF** | Flip-Flop |
| **FIFO** | First-In-First-Out buffer |
| **FPGA** | Field-Programmable Gate Array |
| **FSM** | Finite State Machine |
| **GND** | Ground |
| **GPIO** | General Purpose Input/Output |
| **HDL** | Hardware Description Language |
| **I2C** | Inter-Integrated Circuit (Serial Interface) |
| **IO** | Input/Output |
| **IP** | Intellectual Property / Intercept Point |
| **JTAG** | Joint Test Action Group |
| **LED** | Light Emitting Diode |
| **LNA** | Low Noise Amplifier |
| **LO** | Local Oscillator |
| **LUT** | Look-Up Table |
| **LVTTL** | Low Voltage Transistor-Transistor Logic |
| **LVDS** | Low Voltage Differential Signaling |
| **MAC** | Media Access Control / Multiply Accumulate |
| **NF** | Noise Figure |
| **OS** | Operating System |
| **PCB** | Printed Circuit Board |
| **PLL** | Phase Locked Loop |
| **PS** | Processing System (ARM cores in Zynq) |
| **PWM** | Pulse Width Modulation |
| **RAM** | Random Access Memory |
| **RF** | Radio Frequency |
| **RoHS** | Restriction of Hazardous Substances |
| **RTL** | Register Transfer Level |
| **RX** | Receive |
| **SNR** | Signal-to-Noise Ratio |
| **SPI** | Serial Peripheral Interface |
| **SRIO** | Serial RapidIO |
| **SSTL** | Stub Series Terminated Logic |
| **TRP** | Transmit/Receive Pulse (Control Signal) |
| **UART** | Universal Asynchronous Receiver-Transmitter |
| **VCC** | Voltage Common Collector (Power Supply) |
| **VCO** | Voltage Controlled Oscillator |

---

## 4. Module Overview

The **receiver** hardware module comprises an RF signal chain and a digital processing core. The FPGA (XCZU3EG) acts as the system controller, managing bias sequencing, frequency synthesis, gain settings, and high-speed data acquisition from the ADC.

**RF SECTION:**
*   **LNA / VGA (U1):** HMC698LP4. Provides variable gain control from 2-20 GHz. Controlled via SPI.
*   **Mixer (U2):** HMC1048LP4E. Wideband I/Q Demodulator (6-18 GHz). Downconverts RF to DC/IF I/Q signals.
*   **LO Synthesizer (Y1):** ADF5355. Generates the Local Oscillator signal for the mixer. Controlled via SPI.
*   **Input Connector (J1):** 2.4mm Female (50Ω).

**DIGITAL SECTION:**
*   **ADC (U3):** ADC12DJ3200. Dual 12-bit, 3.2 GSPS ADC. Digitizes the analog I/Q outputs from the mixer. Outputs JESD204B/C or DDR LVDS data to the FPGA.
*   **FPGA (U4):** XCZU3EG-SFVA784. Zynq UltraScale+ MPSoC. Handles:
    *   Configuration of RF chips (HMC698, ADF5355).
    *   High-speed interface to ADC (JESD204B).
    *   System control (UART commands from host).
    *   Power supply monitoring and sequencing.

**POWER SUPPLY SECTION:**
*   **Main Converter (U5):** LTM4644. Steps down +12V to intermediate rails (+5V, +3.3V, +1.8V).
*   **Negative Rail (U6):** LT1054. Generates -5V rail for RF biasing.
*   **Rails:** +12V (Input), +5V (RF Analog), +3.3V (FPGA IO), +1.0V (FPGA Core), -5V (RF Bias).

---

## 5. Features

*   **FPGA:** Xilinx XCZU3EG-SFVA784 (Zynq UltraScale+ MPSoC).
*   **RF Coverage:** 5.0 GHz to 18.0 GHz continuous wideband operation.
*   **High-Speed ADC Interface:** Direct interface to TI ADC12DJ3200 via JESD204B/DDR interface.
*   **Gain Control:** 16 dB digital gain control range via HMC698LP4 SPI interface.
*   **Frequency Agility:** ADF5355 SPI-controlled synthesizer with sub-Hz resolution.
*   **Communication:** UART (USB-UART bridge) for configuration and status reporting.
*   **Power Management:** PMBus/I2C based monitoring of LTM4644 and system currents.
*   **JTAG:** Standard 14-pin JTAG header for FPGA debugging and programming.
*   **Configuration:** Quad-SPI Flash for FPGA bitstream storage.

---

## 6. FPGA Description

**Selection Rationale:**
The **XCZU3EG-SFVA784** is selected to bridge the high-speed ADC domain (JESD204B) with the control domain (SPI/UART). The integrated ARM cores (PS) handle high-level communication and protocol stacks, while the programmable logic (PL) handles high-speed data capture and strict timing for RF control.

**Specification Table:**

| S.NO | PARAMETERS | SPECIFICATION |
|:---|:---|:---|
| 1 | **Part Number** | XCZU3EG-SFVA784 |
| 2 | **Family** | Zynq UltraScale+ EG |
| 3 | **System Logic Cells** | ~50,000 |
| 4 | **CLB Flip-Flops** | 100,800 (approx) |
| 5 | **Total Block RAM** | 600 (18Kb) / ~2.1 Mb |
| 6 | **DSP Slices** | 192 |
| 7 | **Max User I/O** | 284 (Package fcFGA784) |
| 8 | **Transceivers** | 4 × 12.32 Gbps GTX (Used for ADC interface) |
| 9 | **Processing System** | Dual-core ARM Cortex-A53 @ 1.33 GHz |

---

## 7. Block Diagram
*(Refer to System Block Diagram in P4)*
The FPGA sits centrally between the RF Front End and the Data Backend.
1.  **Control Path:** FPGA → (SPI) → HMC698LP4 (Gain), ADF5355 (Freq).
2.  **Data Path:** HMC1048LP4E → (Analog I/Q) → ADC12DJ3200 → (JESD204B/LVDS) → FPGA GTX Banks.
3.  **Monitor Path:** LTM4644 → (PMBus/I2C) → FPGA.

---

## 8. Pinout Details

**Table: FPGA Pin Out Details**
*Derived from Netlist (P4) and Component Datasheets*

| S.No | Signal Name | Pin No (Package) | Voltage Level | Direction wrt FPGA | Source | Destination | Default Condition | Voltage Standard |
|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| **Power & Ground** | | | | | | | | |
| 1 | VCCO_34 | - | 3.3V | Power | LTM4644 | FPGA Bank 34 | ON | LVCMOS33 |
| 2 | VCCO_35 | - | 1.8V | Power | LTM4644 | FPGA Bank 35 | ON | LVCMOS18 |
| 3 | VCCINT | - | 1.0V | Power | LTM4644 | FPGA Core | ON | - |
| 4 | GND | - | 0V | Ground | Common | FPGA | - | - |
| **Clocking** | | | | | | | | |
| 5 | FPGA_CLK_125M | AA12 | 1.8V | Input | Oscillator | PL Logic | Clock | LVCMOS18 |
| 6 | GTX_REFCLK | G6 | 1.2V | Input | ADC/PLL | GTX Lane | Clock | CML |
| **JTAG** | | | | | | | | |
| 7 | TCK | E5 | 1.8V | Input | Debugger | FPGA JTAG | Pull-down | LVCMOS18 |
| 8 | TDI | F5 | 1.8V | Input | Debugger | FPGA JTAG | Pull-up | LVCMOS18 |
| 9 | TDO | G6 | 1.8V | Output | FPGA JTAG | Debugger | N/A | LVCMOS18 |
| 10 | TMS | D5 | 1.8V | Input | Debugger | FPGA JTAG | Pull-up | LVCMOS18 |
| **SPI - LNA (HMC698LP4)** | | | | | | | | |
| 11 | LNA_SCLK | M15 | 3.3V | Output | FPGA | U1 SCLK | Low | LVCMOS33 |
| 12 | LRA_SDI | N14 | 3.3V | Output | FPGA | U1 SDI (Data) | Low | LVCMOS33 |
| 13 | LNA_SDO | M14 | 3.3V | Input | U1 SDO | FPGA | High-Z | LVCMOS33 |
| 14 | LNA_LE_N | L14 | 3.3V | Output | FPGA | U1 LE (Latch) | High (Inactive) | LVCMOS33 |
| **SPI - LO (ADF5355)** | | | | | | | | |
| 15 | LO_SCLK | P15 | 3.3V | Output | FPGA | Y1 SCLK | Low | LVCMOS33 |
| 16 | LO_DATA | R16 | 3.3V | Output | FPGA | Y1 DATA | Low | LVCMOS33 |
| 17 | LO_LE_N | T15 | 3.3V | Output | FPGA | Y1 LE | High (Inactive) | LVCMOS33 |
| 18 | LO_MUXOUT | P16 | 3.3V | Input | Y1 MUXOUT | FPGA | High-Z | LVCMOS33 |
| **UART / Control** | | | | | | | | |
| 19 | UART_TX | K13 | 3.3V | Output | FPGA | USB-UART | High | LVCMOS33 |
| 20 | UART_RX | L13 | 3.3V | Input | USB-UART | FPGA | Pull-up | LVCMOS33 |
| 21 | FPGA_RESET_N | A10 | 1.8V | Input | Reset Button | FPGA | High | LVCMOS18 |
| 22 | LED_STATUS | M13 | 1.8V | Output | FPGA | LED (Green) | Low (Off) | LVCMOS18 |
| 23 | LED_ERROR | N13 | 1.8V | Output | FPGA | LED (Red) | Low (Off) | LVCMOS18 |
| **Power Monitor (I2C)** | | | | | | | | |
| 24 | PMB_SCL | Y18 | 3.3V | Bi-dir | FPGA | U5/Y1/LTM4644 | High | OD-33 |
| 25 | PMB_SDA | Y17 | 3.3V | Bi-dir | FPGA | U5/Y1/LTM4644 | High | OD-33 |
| **RF Control / Misc** | | | | | | | | |
| 26 | RF_SHDN_N | R14 | 3.3V | Output | FPGA | U1/U2 Enable | High (Active) | LVCMOS33 |
| 27 | VGA增益 (DAC) | N15 | 3.3V | Output | FPGA | U1 Vref | Set by SPI | LVCMOS33 |
| 28 | TEMP_ALERT | M16 | 1.8V | Input | Temp Sensor | FPGA | Low | LVCMOS18 |
| **ADC Interface (JESD204B)** | | | | | | | | |
| 29 | ADC_RX_P | G1 | CML | Input | U3 OUT+ | FPGA GTX_P | Diff | CML_1.2V |
| 30 | ADC_RX_N | H1 | CML | Input | U3 OUT- | FPGA GTX_N | Diff | CML_1.2V |
| 31 | ADC_SYNC_N | F2 | 1.8V | Output | FPGA | U3 SYNC | High | LVCMOS18 |
| **Flash (Config)** | | | | | | | | |
| 32 | FLASH_CS_N | H15 | 3.3V | Output | FPGA | Flash CS | High | LVCMOS33 |
| 33 | FLASH_CLK | G15 | 3.3V | Output | FPGA | Flash CLK | Low | LVCMOS33 |
| 34 | FLASH_MOSI | J15 | 3.3V | Output | FPGA | Flash MOSI | High-Z | LVCMOS33 |
| 35 | FLASH_MISO | K15 | 3.3V | Input | Flash MISO | FPGA | High-Z | LVCMOS33 |

---

## 9. Functional Specifications

**Summary table first:**

| S.No. | Function Name | Description |
|:---|:---|:---|
| 1 | **Serial Comm Interface** | UART between PC Host & FPGA for register access and control. |
| 2 | **High Speed Data Interface** | JESD204B interface to ADC12DJ3200 for I/Q data capture. |
| 3 | **Power Supply Sequencing** | Monitors LTM4644 via PMBus; controls RF_SHDN_N based on rails. |
| 4 | **Supply & Temp Monitoring** | I2C (PMBus) monitoring of voltages/currents; On-die temp sensor. |
| 5 | **Gain Control (AGC)** | SPI interface to HMC698LP4; 1dB steps based on RSSI or Host command. |
| 6 | **LO Frequency Tuning** | SPI interface to ADF5355; sets N/Frac dividers for target RF freq. |
| 7 | **System Configuration** | Loads bitstream from QSPI Flash; manages warm resets. |
| 8 | **LED Indication** | Status/Error blinking patterns for health monitoring. |

### 9.1 Serial Communication Interface
*   **Interface Type:** UART 16550 compatible.
*   **Physical Layer:** TTL level connected to USB-UART bridge (e.g., FT2232).
*   **Baud Rate:** 115200 bps (default), configurable up to 921.6 kbps.
*   **Frame Format:** 8 data bits, 1 stop bit, no parity (8N1).
*   **Protocol:** Binary Frame-based register protocol (see Section 11).
*   **Purpose:** Host sends commands for Frequency (ADF5355), Gain (HMC698), and requests ADC samples.

### 9.2 High Speed Communication Interface
*   **Interface:** JESD204B Subclass 1.
*   **Lanes:** 1 Lane (Lane 0).
*   **Data Rate:** 6.4 Gbps (configured in FPGA GTX).
*   **Protocol:** ADC12DJ3200 sends I/Q data (12-bit × 2 channels = 24 bits) mapped to 8B/10B encoded frames.
*   **Sync:** FPGA drives SYNC_N~ to align ADC multiframe clock.

### 9.3 Power On/Off Sequence
#### 9.3.1 Power ON/OFF Sequence
1.  **Input Supply:** +12V applied.
2.  **Rail Sequencing:**
    *   U5 (LTM4644) enables +1.0V (FPGA Core) → +1.8V (FPGA Aux) → +3.3V (FPGA IO).
    *   U6 (LT1054) generates -5V.
3.  **FPGA Boot:** FPGA configures from QSPI Flash (or JTAG).
4.  **RF Enable:**
    *   FPGA checks Power Good (PMBus).
    *   If good, FPGA asserts `RF_SHDN_N` (High).
    *   FPGA initializes ADF5355 → HMC698LP4 via SPI.
5.  **ADC Capture:** FPGA sends SYNC pulse to ADC; data transfer begins.

#### 9.3.2 Mode Configuration
| Mode | Signal | Value | Description |
|:---|:---|:---|:---|
| Normal | OPMODE[1:0] | 2'b00 | Standard RX Operation |
| Test | OPMODE[1:0] | 2'b01 | Internal Tone / Loopback (via FPGA PRBS) |
| Sleep | OPMODE[1:0] | 2'b11 | RF_SHDN_N = Low, Min Power |

### 9.4 Supply Voltage, Current & Temperature Monitoring
#### 9.4.1 Supply Voltage and Current Monitoring
*   **IC:** LTM4644 (Quad DC/DC).
*   **Interface:** PMBus (I2C derived).
*   **Address:** 0x54 (Default).
*   **Monitored Rails:**
    *   +V_IN (12V)
    *   +VOUT1 (+1.0V)
    *   +VOUT2 (+1.8V)
    *   +VOUT3 (+3.3V)
*   **Measurement:** 12-bit ADC inside PMIC, read by FPGA via I2C.

#### 9.4.2 Temperature Monitoring
*   **Source 1:** FPGA On-Die Sensor (XADC), accessible via PS/PL registers.
*   **Source 2:** External Sensor (optional, via I2C).
*   **Range:** -40°C to +100°C.
*   **Action:** If Temp > 90°C, assert `RF_SHDN_N` = Low to protect RF components.

### 9.5 Flash & Interfaces
#### 9.5.1 Configuration Flash
*   **Interface:** Standard Xilinx 4-bit x 1 QSPI (BSPI).
*   **Chip:** Compatible with Micron/Spansion S25FLxxx series.
*   **Capacity:** 256 Mb minimum.
*   **Purpose:** Stores `receiver.bit` and `receiver.bin`.

### 9.6 RF Control
#### 9.6.1 Gain Control (HMC698LP4)
*   **Interface:** SPI Mode 0/1 (CPOL=0, CPHA=0).
*   **Bit Width:** 8-bit register map.
*   **Function:** Sets attenuation from 0 to 15.5 dB in 0.5 dB steps.
*   **Latency:** ≤ 1 µs.

#### 9.6.2 Frequency Tuning (ADF5355)
*   **Interface:** SPI Mode 0 (CPOL=0, CPHA=0).
*   **Bit Width:** 32-bit shift register.
*   **Registers:**
    *   Reg 0: INT (Integer)
    *   Reg 1: FRAC1 (Fractional)
    *   Reg 4: Control (Muxout, PD)
*   **Lock Time:** < 100 µs typical.

---

## 10. Software Register Address Map

This section defines the memory-mapped register space accessible via the UART protocol (Section 11).

### 10.1 Register Base Addresses

| Block Name | Base Address | Address Range | Description |
|:---|:---|:---|:---|
| System / Identification | 0x0000 | 0x0000–0x00FF | Board ID, firmware version, reset control |
| UART Control | 0x0100 | 0x0100–0x01FF | Baud rate, FIFO control |
| SPI Control (LNA) | 0x0200 | 0x0200–0x02FF | HMC698LP4 SPI master |
| SPI Control (LO) | 0x0300 | 0x0300–0x03FF | ADF5355 SPI master |
| I2C / PMBus | 0x0400 | 0x0400–0x04FF | LTM4644 Power Monitor interface |
| RF Control | 0x0500 | 0x0500–0x05FF | RF_SHDN_N, Gain Shadow, LO Shadow |
| JESD204B / ADC | 0x0600 | 0x0600–0x06FF | ADC Link status, decimation setting |
| Diagnostics | 0x0A00 | 0x0A00–0x0AFF | Fault log, uptime, temperature |

### 10.2 Detailed Register Map

**Block 0x0000 — System / Identification**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|:---|:---|:---|:---|:---|:---|
| 0x00 | BOARD_ID | 16 | R | 0xA5A5 | Magic number: 0xA5A5 (Receiver Project) |
| 0x01 | FW_VERSION_MAJOR | 16 | R | 0x0001 | Firmware major version |
| 0x02 | FW_VERSION_MINOR | 16 | R | 0x0000 | Firmware minor version |
| 0x03 | SYS_STATUS | 16 | R | 0x0000 | [15:8] Reserved, [7] PLL_LOCKED (LO), [6] TEMP_ALERT, [5] PWR_GOOD_12V, [4] PWR_GOOD_5V, [3] ADC_LOCK, [2:0] Reserved |
| 0x04 | SYS_RESET | 16 | W | 0x0000 | [0] SOFT_RESET (Write 1 to trigger) |
| 0x05 | OPMODE | 16 | R/W | 0x0000 | [1:0] Operating Mode (00=Normal, 01=Test, 11=Sleep) |

**Block 0x0200 — SPI Control (LNA / HMC698LP4)**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|:---|:---|:---|:---|:---|:---|
| 0x00 | LNA_GAIN_CTRL | 16 | R/W | 0x0000 | [7:0] Gain/Attenuation code (0-31 scale) |
| 0x01 | LNA_SPI_WR | 16 | W | 0x0000 | Write to initiate SPI transaction to U1 |
| 0x02 | LNA_SPI_RD | 16 | R | 0x0000 | Readback last value written |

**Block 0x0300 — SPI Control (LO / ADF5355)**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|:---|:---|:---|:---|:---|:---|
| 0x00 | LO_FREQ_INT | 16 | R/W | 0x0000 | [15:0] INT divider value (Low word) |
| 0x01 | LO_FREQ_FRAC | 16 | R/W | 0x0000 | [15:0] FRAC divider value (Low word) |
| 0x02 | LO_CTRL | 16 | R/W | 0x0000 | [0] MUTE (CE pin), [1] WRITE_UPDATE (Strobe) |

**Block 0x0500 — RF Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|:---|:---|:---|:---|:---|:---|
| 0x00 | RF_ENABLE | 16 | R/W | 0x0000 | [0] RF_SHDN_N (1=ON, 0=OFF) |
| 0x01 | GAIN_TARGET | 16 | R/W | 0x0000 | [7:0] Target Gain (dB) |

**Block 0x0600 — JESD204B / ADC Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|:---|:---|:---|:---|:---|:---|
| 0x00 | ADC_LINK_STAT | 16 | R | 0x0000 | [0] LINK_UP, [1] CODE_GRP_SYNC |
| 0x01 | ADC_RESET | 16 | W | 0x0000 | [0] ADC_RST_N (1=Active) |

---

## 11. UART Register Protocol Specification

### 11.1 Physical Layer
*   **Baud Rate:** 115200 bps.
*   **Frame Format:** 8N1 (1 Start, 8 Data, 1 Stop, No Parity).
*   **Connector:** Micro-USB or Header (USB-UART bridge).

### 11.2 Command Frame Formats

**Single Register Write (CMD = 0x57 'W'):**
| Byte | Value | Description |
|:---|:---|:---|
| 0 | 0x57 | Command Write |
| 1 | ADDR[15:8] | Address High Byte |
| 2 | ADDR[7:0] | Address Low Byte |
| 3 | DATA[15:8] | Data High Byte |
| 4 | DATA[7:0] | Data Low Byte |
| **RSP** | **0x06** | **ACK (Success)** |

**Single Register Read (CMD = 0x52 'R'):**
| Byte | Value | Description |
|:---|:---|:---|
| 0 | 0x52 | Command Read |
| 1 | ADDR[15:8] | Address High Byte |
| 2 | ADDR[7:0] | Address Low Byte |
| **RSP 0** | **DATA[15:8]** | **Data High Byte** |
| **RSP 1** | **DATA[7:0]** | **Data Low Byte** |

**Bulk Register Write (CMD = 0x42 'B'):**
| Byte | Value | Description |
|:---|:---|:---|
| 0 | 0x42 | Command Bulk Write |
| 1-2 | ADDR | Start Address |
| 3 | N | Count (1-64) |
| 4.. | DATA | Packed Data (High, Low...) |
| **RSP** | **0x06** | **ACK** |

**Error Response:**
*   **0x15 (NAK):** Invalid address, timeout, or write to read-only register.

### 11.3 Protocol Timing Constraints
| Parameter | Max | Unit |
|:---|:---|:---|
| Inter-byte gap | 50 | ms |
| Processing Delay | 10 | ms |

---

## 12. FPGA Resource Utilization Estimate

*Target Device: XCZU3EG-SFVA784 (Logic Cells ~50k)*

| Resource | Available | Estimated Usage | Utilization % |
|:---|:---|:---|:---|
| **Slice LUTs** | 53,200 | 12,500 | 23% |
| **Slice Flip-Flops** | 106,400 | 18,000 | 17% |
| **Block RAM (36Kb)** | 432 | 60 | 14% |
| **DSP Slices** | 192 | 32 | 16% |
| **GTX Transceivers** | 4 | 1 | 25% |
| **PLL/MMCM** | 4 | 2 | 50% |

**Synthesis Tool:** Xilinx Vivado 2023.2
**Timing Constraints:**
*   Clock 125MHz (System)
*   Clock 10MHz (SPI/Control)
*   Clock 156.25MHz (GTX Refclk)

---

## Annexure A — Requirement Traceability Matrix

| S.No | GLR-ID | Description | Source HRS Section | GLR Section | Verification Method | Status |
|:---|:---|:---|:---|:---|:---|:---|
| 1 | GLR-001 | RF Frequency Coverage 5-18 GHz | HRS §2 | 9.6.2 | Lab Test | Open |
| 2 | GLR-002 | Gain Control Interface (SPI) | HRS §3.1 | 9.6.1 | Inspection | Open |
| 3 | GLR-003 | Local Oscillator Phase Noise | HRS §3.2 | 9.6.2 | Analysis | Open |
| 4 | GLR-004 | I/Q Digitization (12-bit, 500MSPS) | HRS §3.3 | 9.2 | Test | Open |
| 5 | GLR-005 | Power Supply Sequencing (+12V to +3.3V) | HRS §3.1 | 9.3 | Test | Open |
| 6 | GLR-006 | Temperature Range (-40 to +85C) | HRS §3.4 | 9.4 | Test | Open |
| 7 | GLR-007 | UART Configuration Interface | HRS §3.1 | 9.1, 11 | Test | Open |
| 8 | GLR-008 | Register Address Map Definition | HRS §3.1 | 10 | Inspection | Open |
| 9 | GLR-009 | Power Consumption Monitoring | HRS §3.1 | 9.4 | Test | Open |
| 10 | GLR-010 | RoHS Compliance | HRS §3.6 | 6 (Desc) | Inspection | Open |

---
*End of Document*