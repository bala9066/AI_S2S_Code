# Glue Logic Requirements (GLR)

## Document Control
| Document Title | Glue Logic Requirements |
| :--- | :--- |
| Version Date | 15.04.2026 |
| Version Number | 0V01 |
| Prepared By | Name: . Sign: |
| Document Review By | Name: . Sign: |

---

## Amendments to the Document
| S. No | Ver. No. | Ver. Date | Changed By | Section(s) Changed | Description of Change |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | 0V01 | 15.04.2026 | - | - | Initial Version |

---

## 1. Scope of the Document
This document explains the IO details and functional requirements of the FPGA for **kh**. Targeted audience: Hardware Design and Firmware teams.

This specification bridges the Hardware Requirements Specification (HRS) and the Netlist with the FPGA HDL Design phase. It defines the signal interfaces, timing constraints, power sequencing requirements, and communication protocols required for the wideband RF receiver module.

---

## 2. References

### 2.1 External
| Doc. Type | Part No. | Description |
| :--- | :--- | :--- |
| Datasheet | HMC1119LP4DE | 6-18 GHz GaAs MMIC LNA |
| Datasheet | HMC698LP4 | 6-18 GHz Digital VGA |
| Datasheet | HMC1051LP4BE | 6-26 GHz Double-Balanced Mixer |
| Datasheet | ADL5541 | 30 MHz-6 GHz IF Amplifier |
| Datasheet | ADC12DJ5200RF | Dual-channel 12-bit 5.2 GSPS ADC (JESD204B/C) |
| Datasheet | LMK04828BKNQ | Ultra-Low Noise JESD204B Clock Jitter Cleaner |
| Datasheet | LTC2975 | Quad Power System Manager |
| Datasheet | LTM4644IY | 4A DC/DC Buck Regulator |
| Datasheet | S25FL512S | 512 Mb Configuration Flash |

### 2.2 Internal
| Reference | Document |
| :--- | :--- |
| [HRS] | Hardware Requirements Specification (P1/P2) |
| [SCH] | Schematic (P4) |
| [NET] | Logical Netlist (P4) |
| [GRS] | General Requirements Specification |
| [GDD] | General Design Document |

---

## 3. Acronyms and Abbreviations
| Acronym | Expansion |
| :--- | :--- |
| **ADC** | Analog-to-Digital Converter |
| **AGC** | Automatic Gain Control |
| **BOM** | Bill of Materials |
| **CLB** | Configurable Logic Block |
| **DAC** | Digital-to-Analog Converter |
| **DSP** | Digital Signal Processor / Slice |
| **EMC** | Electromagnetic Compatibility |
| **FF** | Flip-Flop |
| **FPGA** | Field-Programmable Gate Array |
| **GND** | Ground |
| **GPIO** | General Purpose Input/Output |
| **HDL** | Hardware Description Language |
| **HRS** | Hardware Requirements Specification |
| **I2C** | Inter-Integrated Circuit |
| **IO** | Input/Output |
| **JTAG** | Joint Test Action Group |
| **LVDS** | Low-Voltage Differential Signaling |
| **LUT** | Look-Up Table |
| **PCB** | Printed Circuit Board |
| **PLL** | Phase-Locked Loop |
| **RTL** | Register Transfer Level |
| **RoHS** | Restriction of Hazardous Substances |
| **SFDR** | Spurious-Free Dynamic Range |
| **SPI** | Serial Peripheral Interface |
| **UART** | Universal Asynchronous Receiver-Transmitter |
| **VCC** | Voltage Common Collector |

---

## 4. Module Overview

### RF SECTION
The RF chain processes signals from **10-15 GHz**. It consists of:
1.  **HMC1119LP4DE (LNA):** Provides 20 dB gain with a 3 dB Noise Figure.
2.  **HMC698LP4 (Digital VGA):** Provides 31 dB gain range controlled via a 6-bit SPI interface.
3.  **HMC1051LP4BE (Mixer):** Downconverts the RF signal to an IF using an external Local Oscillator (LO) input.
4.  **ADL5541 (IF Amp):** Amplifies the IF signal before digitization.
5.  **ADC12DJ5200RF:** Digitizes the IF signal at up to 5.2 GSPS. Configured for dual-channel or single-channel interleaved mode (JESD204B subclass 1).

### DIGITAL SECTION
The core control logic is implemented in an FPGA (Xilinx Kintex-7 or equivalent).
*   **Signal Processing:** Handles JESD204B IP core, data buffering, and framing.
*   **Control Logic:** Interfaces with the Power Manager (LTC2975) and Clock Generator (LMK04828BKNQ) via I2C.
*   **RF Control:** Interfaces with the VGA (HMC698LP4) via SPI to implement AGC.
*   **Communication:** UART command interface for system configuration and status reporting.

### POWER SUPPLY SECTION
Power is generated using modular DC/DC regulators:
*   **LTM4644IY:** Generates +5V (LNA/VGA supply) and +3.3V (FPGA I/O).
*   **LTM4625:** Generates +1.8V (FPGA Aux) and +1.2V (FPGA Core/ADC Drv).
*   **LTC2975:** Monitors all rails, sequences the power-on, and provides fault detection via I2C.

---

## 5. Features
*   **FPGA:** Xilinx Kintex-7 325T (XC7K325T-FFG900) - *Note: Assumption based on JESD204B requirements.*
*   **On-board clock oscillator:** 10 MHz Reference (input to Clock Generator).
*   **Communication:**
    *   UART (3.3V LVTTL) at 115200 bps for Command & Control.
    *   I2C (Multi-master) for Power/Clock management.
*   **JTAG:** IEEE 1149.1 compliant debugging support.
*   **Configuration Flash:** S25FL512S (512 Mb) for FPGA image storage.
*   **Temperature Monitoring:** Via LTC2975 internal sensor and external remote diodes.
*   **Power monitoring:** LTC2975 (Voltage/Current on all rails).
*   **High-Speed Interface:** JESD204B Subclass 1 (Lane rate: 6.144 Gbps).

---

## 6. FPGA Description
**Selection Rationale:** The selected FPGA must support high-speed transceivers compatible with JESD204B (Class 1) to interface with the ADC12DJ5200RF. It requires sufficient logic to perform data packetization and synchronization. The Xilinx Kintex-7 family offers the required GTP transceivers and logic density within the industrial temperature range.

| S.NO | PARAMETERS | SPECIFICATION |
| :--- | :--- | :--- |
| 1 | Part Number | XC7K325T-FFG900I |
| 2 | Logic Cells | 326,080 |
| 3 | CLB Flip-Flops | 407,600 |
| 4 | Number of Gates | N/A (Logic Cell based arch) |
| 5 | Maximum Distributed RAM (Kb) | 442 |
| 6 | Total Block RAM (Kb) | 16,620 |
| 7 | Maximum Single-Ended I/Os | 500 |
| 8 | Maximum DSP Slices | 840 |
| 9 | No of IO Bank | 14 (includes High Range Banks) |

---

## 7. Block Diagram
*(Reference to Netlist/HRS Block Diagram)*
The system consists of an RF Input connected to an LNA and VGA. The downconverted IF signal is digitized by the TI ADC. The ADC sends JESD204B data to the FPGA. The FPGA controls the VGA gain via SPI and manages power sequencing via I2C. A UART link provides host connectivity.

---

## 8. Pinout Details

**Table: FPGA Pin Out Details**

| S.No | Signal Name | Pin No | Voltage Level | Direction wrt FPGA | Source | Destination | Default Condition | Voltage Standard |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **Power & Ground** | | | | | | | | |
| 1 | VCCINT | N/A | 1.2V | Power In | LTM4625 | FPGA Core | - | - |
| 2 | VCCAUX | N/A | 1.8V | Power In | LTM4625 | FPGA Aux | - | - |
| 3 | VCCO_34 | N/A | 3.3V | Power In | LTM4644 | Bank 34 IO | - | - |
| 4 | GND | N/A | 0V | GND | Common | FPGA GND | - | - |
| **Clock & JTAG** | | | | | | | | |
| 5 | FPGA_CLK_125M | AB12 | 1.8V | Input | Oscillator | FPGA MGMT | - | LVCMOS18 |
| 6 | TCK | T13 | 1.8V | Input | JTAG Header | FPGA JTAG | Pull-down | LVCMOS18 |
| 7 | TDI | R13 | 1.8V | Input | JTAG Header | FPGA JTAG | Pull-up | LVCMOS18 |
| 8 | TDO | P12 | 1.8V | Output | FPGA JTAG | JTAG Header | - | LVCMOS18 |
| 9 | TMS | N13 | 1.8V | Input | JTAG Header | FPGA JTAG | Pull-up | LVCMOS18 |
| **Reset** | | | | | | | | |
| 10 | FPGA_RESET_N | F11 | 3.3V | Input | Button | FPGA Reset | Active Low Pull-up | LVCMOS33 |
| **UART** | | | | | | | | |
| 11 | UART_TX | D10 | 3.3V | Output | FPGA | USB-UART | High | LVCMOS33 |
| 12 | UART_RX | E10 | 3.3V | Input | USB-UART | FPGA | - | LVCMOS33 |
| **SPI (VGA)** | | | | | | | | |
| 13 | SPI_SCLK | H20 | 3.3V | Output | FPGA | HMC698LP4 | Low | LVCMOS33 |
| 14 | SPI_SDIO | J21 | 3.3V | Bi-Dir | FPGA | HMC698LP4 | High-Z | LVCMOS33 |
| 15 | SPI_CSN_VGA | K20 | 3.3V | Output | FPGA | HMC698LP4 | High | LVCMOS33 |
| **SPI (Flash)** | | | | | | | | |
| 16 | FLASH_CLK | G19 | 3.3V | Output | FPGA | S25FL512S | Low | LVCMOS33 |
| 17 | FLASH_MOSI | H21 | 3.3V | Output | FPGA | S25FL512S | Low | LVCMOS33 |
| 18 | FLASH_MISO | J19 | 3.3V | Input | S25FL512S | FPGA | - | LVCMOS33 |
| 19 | FLASH_CS_N | K21 | 3.3V | Output | FPGA | S25FL512S | High | LVCMOS33 |
| **I2C (Control)** | | | | | | | | |
| 20 | I2C_SCL | M15 | 3.3V | Bi-Dir | FPGA | LTC2975/LMK04828 | High | LVCMOS33 |
| 21 | I2C_SDA | N15 | 3.3V | Bi-Dir | FPGA | LTC2975/LMK04828 | High | LVCMOS33 |
| **GPIO / Status** | | | | | | | | |
| 22 | LED_STATUS | A12 | 3.3V | Output | FPGA | LED (Heartbeat) | Low | LVCMOS33 |
| 23 | FPGA_DONE | K13 | 3.3V | Output | FPGA | Internal/Ext | Low (Init) | LVCMOS33 |
| 24 | FPGA_INIT_N | L13 | 3.3V | Input | Internal | FPGA | High (Ready) | LVCMOS33 |
| **JESD204B (ADC)** | | | | | | | | |
| 25 | JESD_CKP | F5 | 1.2V (HSTL) | Input | ADC12DJ | FPGA GTXP0 | - | CML 1.2V |
| 26 | JESD_CKN | G5 | 1.2V (HSTL) | Input | ADC12DJ | FPGA GTXN0 | - | CML 1.2V |
| 27 | JESD_D0_P | B6 | 1.2V (HSTL) | Input | ADC12DJ | FPGA GTXP1 | - | CML 1.2V |
| 28 | JESD_D0_N | C6 | 1.2V (HSTL) | Input | ADC12DJ | FPGA GTXN1 | - | CML 1.2V |
| 29 | JESD_D1_P | D6 | 1.2V (HSTL) | Input | ADC12DJ | FPGA GTXP2 | - | CML 1.2V |
| 30 | JESD_D1_N | E6 | 1.2V (HSTL) | Input | ADC12DJ | FPGA GTXN2 | - | CML 1.2V |
| **SPI (ADC Config)** | | | | | | | | |
| 31 | ADC_SCLK | P20 | 3.3V | Output | FPGA | ADC12DJ | Low | LVCMOS33 |
| 32 | ADC_SDIO | R20 | 3.3V | Bi-Dir | FPGA | ADC12DJ | High-Z | LVCMOS33 |
| 33 | ADC_CS_N | T19 | 3.3V | Output | FPGA | ADC12DJ | High | LVCMOS33 |
| **Sync / Sysref** | | | | | | | | |
| 34 | SYSREQ_P | E4 | 1.2V | Input | LMK04828 | FPGA | - | LVDS |
| 35 | SYSREQ_N | F4 | 1.2V | Input | LMK04828 | FPGA | - | LVDS |

---

## 9. Functional Specifications

**Summary table:**

| S.No. | Function Name | Description |
| :--- | :--- | :--- |
| 1 | Serial Communication Interface | UART between Host PC & FPGA for control and monitoring |
| 2 | High Speed Communication Interface | JESD204B Subclass 1 interface to ADC (12-bit, up to 5.2 GSPS) |
| 3 | Power Supply Sequencing & Health | Control via I2C (LTC2975) to sequence rails and monitor faults |
| 4 | Supply Voltage, Current & Temp Monitoring | Real-time monitoring via LTC2975 |
| 5 | Flash Interfaces | SPI interface to S25FL512S for configuration storage |
| 6 | VGA Configuration | SPI interface to HMC698LP4 for Gain Control |
| 7 | FPGA Remote Programming | Bitstream update via UART to Flash |
| 8 | ADC Configuration | SPI interface to ADC12DJ5200RF for setup |
| 9 | JESD204B Lane Alignment | SYSREQ/SYSREF alignment for deterministic latency |

### 9.1 Serial Communication Interface
*   **Interface type:** UART
*   **Physical layer:** 3.3V LVTTL (Connected to USB-UART bridge)
*   **Baud rate:** 115200 bps
*   **Frame format:** 1 start bit, 8 data bits, 1 stop bit, no parity
*   **Protocol Structure:**
    *   Header: `[0xAA, 0x55, CMD_ID, LENGTH]`
    *   Payload: `DATA...`
    *   CRC: 16-bit CRC-CCITT
*   **Commands:** Set VGA Gain, Get Temp, Get Current, JESD Link Reset, Flash Update Mode.

### 9.2 High Speed Communication Interface
*   **Interface:** JESD204B Subclass 1
*   **Number of lanes:** 2 Lanes (ADC configured in Dual Channel mode or Deserializer mode).
*   **Data rate per lane:** 6.144 Gbps (configured for 500 MSPS sample rate with overprocessing).
*   **Protocol:** JESD204B Revision C.
*   **Physical:** AC-coupled LVDS (CML) inputs on FPGA GTX banks.
*   **Scrambling:** Enabled.
*   **Subclass:** 1 (Deterministic Latency using SYSREF).

### 9.3 Power On/Off Sequence
#### 9.3.1 Power ON/OFF Sequence
Step-by-step sequence:
1.  **Input Supply (+12V)** detected by LTC2975.
2.  **Sequence Enable:** LTC2975 enables **+5V** rail (RF Supplies). Wait for `PGOOD_5V`.
3.  **FPGA IO Enable:** LTC2975 enables **+3.3V** and **+1.8V**. Wait for `PGOOD_3V3`.
4.  **Core Enable:** LTC2975 enables **+1.2V (Core)**.
5.  **FPGA Start-up:** `FPGA_INIT_N` goes High. FPGA loads bitstream from Flash.
6.  **Configuration:** FPGA configures ADC and Clock Gen via I2C/SPI.
7.  **ADC Enable:** FPGA asserts ADC_PD_N pin.
8.  **System Ready:** `FPGA_DONE` goes High, LED_STATUS turns solid.

#### 9.3.2 Mode Configuration
| Mode | Signal | Value | Description |
| :--- | :--- | :--- | :--- |
| Normal | MODE_STRAP[1:0] | 2'b00 | Normal RX mode, JESD Link active |
| BIST | MODE_STRAP[1:0] | 2'b01 | Internal ADC test pattern mode |
| Programming | MODE_STRAP[1:0] | 2'b10 | FPGA enters update mode (UART) |

### 9.4 Supply Voltage, Current & Temperature Monitoring
#### 9.4.1 Supply Voltage and Current Monitoring
*   **IC:** LTC2975
*   **Interface:** I2C (Address 0x54)
*   **Monitored Rails:**
    *   +5V_RF (LNA/VGA)
    *   +3.3V_IO
    *   +1.8V_AUX
    *   +1.2V_CORE
*   **Action:** If current > 110% of max, log error to UART. If > 125%, force shut down rail.

#### 9.4.2 Temperature Monitoring
*   **Sources:**
    *   LTC2975 Internal Sensor.
    *   ADC Thermal Diode (Read via ADC SPI).
*   **Alert Threshold:**
    *   Warning: +75°C
    *   Critical: +85°C (Shut down RF PA/LNA).

### 9.5 Flash & Interfaces
#### 9.5.1 Configuration Flash
*   **Part Number:** S25FL512S (512 Mb / 64 MB)
*   **Interface:** QSPI (Quad SPI) in x4 mode.
*   **Capacity:** Sufficient for multiple Kintex-7 bitstreams.
*   **Purpose:** Stores Golden Image and Updated Application Image.

### 9.6 VGA Configuration
*   **Device:** HMC698LP4
*   **Interface:** SPI (Mode 0/3).
*   **Register Map:** 6-bit Gain Register (0-63).
*   **Range:** -11 dB to +20 dB (approximate range based on 31 dB span).
*   **Control:** Auto-gain loop running in FPGA logic or manual UART command.

### 9.7 FPGA Remote Programming
*   **Protocol:** UART (XMODEM-CRC).
*   **Tool:** Python/GUI Host Tool.
*   **Procedure:**
    1.  Host sends `ENTER_UPDATE_MODE` command.
    2.  FPGA erases Flash sector.
    3.  Host sends binary packets.
    4.  FPGA writes to S25FL512S.
    5.  FPGA asserts IPROG trigger to reload bitstream.

### 9.8 Phase Shifter Controlling
*   *Not applicable to this specific receiver module (Fixed RF Chain).*
*   *(Reserved for future expansion to phased array).* N/A.

### 9.9 Beam Steering Calculation
*   *Not applicable to this specific receiver module.* N/A.

### 9.10 Gate Voltage Writing in DAC
*   *Not applicable to this specific receiver module.*
*   *(Gain is controlled digitally via HMC698LP4 SPI).* N/A.

---

## Annexure A — Requirement Traceability Matrix

| S.No | Requirement ID | Description | HRS Section | GLR Section |
| :--- | :--- | :--- | :--- | :--- |
| 1 | REQ-HW-001 | RF Input Frequency Range | HRS §3.1 | 9.6 (VGA Calibration) |
| 2 | REQ-HW-002 | Noise Figure | HRS §3.2 | 9.6 (Ensured by LNA/VGA setup) |
| 3 | REQ-HW-003 | SFDR | HRS §3.2 | 9.2 (JESD204B Data Integrity) |
| 4 | REQ-HW-004 | Input Power Range | HRS §3.2 | 9.6 (AGC Implementation) |
| 5 | REQ-HW-005 | ADC Sampling Rate | HRS §3.2 | 9.2 (JESD204B Link Config) |
| 6 | REQ-HW-006 | Digital Output Interface | HRS §3.3 | 9.2 (JESD204B Electrical Spec) |
| 7 | REQ-HW-007 | Operating Temperature | HRS §3.4 | 9.4.2 (Temp Monitoring) |
| 8 | REQ-HW-010 | RF Front-End Gain | HRS §3.1 | 9.6 (VGA Control) |
| 9 | REQ-HW-011 | Input Return Loss | HRS §3.2 | 4.0 (RF Description) |
| 10 | REQ-HW-012 | Power Supply Regulation | HRS §3.1 | 9.3 (Sequencing) |

---
**End of Document**