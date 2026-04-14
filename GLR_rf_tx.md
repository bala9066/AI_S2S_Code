# Glue Logic Requirements (GLR)

## Document Control
| Document Title | Glue Logic Requirements (GLR) |
| :--- | :--- |
| Version Date | 14.04.2026 |
| Version Number | 0V01 |
| Prepared By | Name: . Sign: |
| Document Review By | Name: . Sign: |

---

## Amendments to the Document
| S. No. | Ver. No. | Ver. Date | Changed By | Section(s) Changed | Description of Change |
|:---:|:---:|:---:|:---:|:---:|:---|
| 1 | 0V01 | 14.04.2026 | - | - | Initial Version |

---

## 1. Scope of the Document
This document details the Input/Output (IO) specifications, signal interfaces, and functional logic requirements for the FPGA (Device U6) within the **rf tx** Wideband Microwave Receiver project. It bridges the gap between the hardware netlist/schematic and the firmware HDL implementation. This document defines the pin-level interfaces for the JESD204B ADC link, the MCU SPI control bus, and system housekeeping signals.

---

## 2. References

### 2.1 External
| Doc. Type | Part No. | Description |
|:---|:---|:---|
| Datasheet | **XC7A35T-FTG256** | Xilinx Artix-7 FPGA (Target Device) |
| Datasheet | **ADC12J4000** | 12-Bit, 4 GSPS ADC (JESD204B Interface) |
| Datasheet | **STM32F407VGT6** | High-Performance MCU (Host Controller) |
| Datasheet | **HMC698LP4** | Digital VGA (SPI Slave) |
| Datasheet | **HMC830LP6GE** | Wideband Synthesizer (SPI Slave) |
| User Guide | **UG471** | 7 Series FPGAs SelectIO Resources |
| User Guide | **UG480** | 7 Series FPGAs Clocking Resources |

### 2.2 Internal
| Reference | Document |
|:---|:---|
| [HRS] | Hardware Requirements Specification |
| [SCH] | rf tx Schematic Schematic |
| [GRS] | General Requirements Specification |
| [GDD] | General Design Document |

---

## 3. Acronyms and Abbreviations
| Acronym | Expansion |
|:---|:---|
| **ADC** | Analog-to-Digital Converter |
| **CFA** | Clock Frequency Advisory |
| **CW** | Continuous Wave |
| **DAC** | Digital-to-Analog Converter |
| **DSP** | Digital Signal Processing |
| **EMC** | Electromagnetic Compatibility |
| **FPGA** | Field Programmable Gate Array |
| **GPIO** | General Purpose Input/Output |
| **HDL** | Hardware Description Language |
| **HRS** | Hardware Requirements Specification |
| **I2C** | Inter-Integrated Circuit |
| **JTAG** | Joint Test Action Group |
| **JESD** | JEDEC Standard for High-Speed Data Interfaces |
| **LFSR** | Linear Feedback Shift Register |
| **LUT** | Look-Up Table |
| **LVCMOS** | Low-Voltage CMOS |
| **LVTTL** | Low-Voltage Transistor-Transistor Logic |
| **MCU** | Microcontroller Unit |
| **MSB** | Most Significant Bit |
| **PLL** | Phase Locked Loop |
| **RoHS** | Restriction of Hazardous Substances |
| **RTL** | Register Transfer Level |
| **SPI** | Serial Peripheral Interface |
| **UART** | Universal Asynchronous Receiver/Transmitter |
| **VCC** | Voltage Common Collector (Supply) |
| **VGA** | Variable Gain Amplifier |

---

## 4. Module Overview

The **rf tx** module is a wideband microwave receiver designed for signal detection and measurement across the 5-18 GHz frequency range. The architecture utilizes a superheterodyne downconversion approach, converting RF inputs to a 2.4 GHz Intermediate Frequency (IF) for digitization and processing.

### RF SECTION
The RF chain consists of the **HMC1049LP3E** Wideband LNA providing 20 dB gain, followed by the **HMC1052LP4GE** Mixer. Frequency downconversion is driven by the **HMC830LP6GE** Wideband Synthesizer, which generates the Local Oscillator (LO) signal (7.4-20.4 GHz). The IF signal is conditioned by the **HMC698LP4** Digital VGA, which provides gain control via SPI.

### DIGITAL SECTION
The core digital logic resides within the **XC7A35T-FTG256** FPGA. The FPGA is responsible for receiving high-speed digitized IF data from the **ADC12J4000** via a JESD204B link (Lane rates up to 4 Gbps). It performs signal processing tasks including CW detection, FFT-based frequency analysis, and amplitude measurement. Control logic is managed by the **STM32F407VGT6** MCU, which communicates with the FPGA via SPI for configuration and status updates.

### POWER SUPPLY SECTION
The system is powered by a single +12V DC input. This is regulated down to +5V (using **TPS54340**) for the RF components (LNA, Mixer, VGA) and +3.3V (using **LT3045-3.3**) for the digital logic (FPGA, MCU, Synthesizer). Power sequencing ensures the FPGA core is stable before high-speed interfaces are enabled.

---

## 5. Features
- **FPGA:** Xilinx XC7A35T-FTG256 (Artix-7 Family, 20800 Logic Cells).
- **High-Speed ADC Interface:** JESD204B interface to TI ADC12J4000 (12-bit, 4 GSPS).
- **MCU Interface:** SPI Slave interface for configuration and data exchange with STM32F407.
- **Clocking:** Dedicated differential clock output to drive ADC sample clock.
- **RF Control Interface:** SPI pass-through or independent control for HMC698LP4 (VGA) and HMC830LP6GE (LO).
- **Programmable Logic:** Built-in DSP slices for FFT and filtering operations.
- **JTAG:** Standard 14-pin header for FPGA debugging and configuration.
- **Status Indication:** LED drive capability for "Link Status" and "Processing Active".

---

## 6. FPGA Description

The **XC7A35T-FTG256** is selected to bridge the high-speed ADC domain and the lower-speed control domain.

| S.NO | PARAMETERS | SPECIFICATION |
|:---:|:---|:---|
| 1 | Part Number | XC7A35T-FTG256 |
| 2 | Logic Cells | 20,800 |
| 3 | CLB Flip-Flops | 32,600 |
| 4 | Number of Gates (Est.) | 500,000 |
| 5 | Maximum Distributed RAM (Kb) | 200 |
| 6 | Total Block RAM (Kb) | 1,800 |
| 7 | Maximum Single-Ended I/Os | 210 |
| 8 | Maximum DSP Slices | 90 |
| 9 | No of IO Bank | 4 (Banks 13, 14, 15, 16) |

---

## 7. Block Diagram
*(Textual Description of Block Diagram)*
The system centers on the FPGA (U6).
1.  **High-Speed Path:** The ADC (U5) sends parallel JESD204B data (TX_P/N lanes) to the FPGA Bank 14/15 (HR I/Os). The FPGA generates the sample clock (ADC_CLK_P/N) via a PLL output.
2.  **Control Path:** The MCU (U7) connects via SPI to the FPGA (Bank 13). The FPGA acts as a slave, receiving register settings for the RF components.
3.  **RF Component Control:** The FPGA implements SPI Masters to control the VGA (U4) and LO (U3) via LVCMOS33 I/Os.

---

## 8. Pinout Details

**Table: FPGA Pin Out Details**
*Note: Pin numbers are illustrative references to the FTG256 package map; specific allocation is subject to PCB routing constraints.*

| S.No | Signal Name | Pin No (Ref) | Voltage Level | Direction wrt FPGA | Source | Destination | Default Condition | Voltage Standard |
|:---:|:---|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| 1 | VCCINT | - | 1.0V | PWR | Regulator | FPGA Core | - | - |
| 2 | VCCAUX | - | 1.8V | PWR | Regulator | FPGA Aux | - | - |
| 3 | VCCO_13 | - | 3.3V | PWR | Regulator | Bank 13 | - | - |
| 4 | VCCO_14 | - | 1.8V | PWR | Regulator | Bank 14 | - | - |
| 5 | GND | - | 0V | GND | GND Plane | FPGA | - | - |
| 6 | FPGA_RESET_N | T5 | 3.3V | IN | MCU STM32 | FPGA Reset Logic | ACTIVE LOW | LVCMOS33 |
| 7 | FPGA_DONE | R15 | 3.3V | OUT | FPGA Config | MCU STM32 | LOW until Config Done | LVCMOS33 |
| 8 | MCU_FPGA_SPI_SCLK | M4 | 3.3V | IN | MCU (SPI1_SCK) | FPGA SPI Slave | LOW | LVCMOS33 |
| 9 | MCU_FPGA_SPI_MOSI | N5 | 3.3V | IN | MCU (SPI1_MOSI) | FPGA SPI Slave | LOW | LVCMOS33 |
| 10 | MCU_FPGA_SPI_MISO | M6 | 3.3V | OUT | FPGA SPI Slave | MCU (SPI1_MISO) | High Z | LVCMOS33 |
| 11 | MCU_FPGA_SPI_CS | P6 | 3.3V | IN | MCU (SPI1_NSS) | FPGA SPI Slave | HIGH | LVCMOS33 |
| 12 | LO_SPI_SCLK | L1 | 3.3V | OUT | FPGA SPI Master 1 | HMC830 (SCLK) | LOW | LVCMOS33 |
| 13 | LO_SPI_SDI | K2 | 3.3V | OUT | FPGA SPI Master 1 | HMC830 (SDI) | LOW | LVCMOS33 |
| 14 | LO_SPI_SDO | K1 | 3.3V | IN | HMC830 (SDO) | FPGA SPI Master 1 | High Z | LVCMOS33 |
| 15 | LO_SPI_CS | L2 | 3.3V | OUT | FPGA SPI Master 1 | HMC830 (CS) | HIGH | LVCMOS33 |
| 16 | VGA_SPI_SCLK | D1 | 3.3V | OUT | FPGA SPI Master 2 | HMC698 (SCLK) | LOW | LVCMOS33 |
| 17 | VGA_SPI_SDI | E2 | 3.3V | OUT | FPGA SPI Master 2 | HMC698 (SDI) | LOW | LVCMOS33 |
| 18 | VGA_SPI_CS | D2 | 3.3V | OUT | FPGA SPI Master 2 | HMC698 (LE/CS) | HIGH | LVCMOS33 |
| 19 | JESD204B_D_P0 | B15 | 1.8V | IN | ADC12J4000 | FPGA Lane 0 | HIGH | LVDS / LVDS_25 |
| 20 | JESD204B_D_N0 | A15 | 1.8V | IN | ADC12J4000 | FPGA Lane 0 | HIGH | LVDS / LVDS_25 |
| 21 | JESD204B_D_P1 | B16 | 1.8V | IN | ADC12J4000 | FPGA Lane 1 | HIGH | LVDS / LVDS_25 |
| 22 | JESD204B_D_N1 | A16 | 1.8V | IN | ADC12J4000 | FPGA Lane 1 | HIGH | LVDS / LVDS_25 |
| 23 | JESD204B_D_P2 | C17 | 1.8V | IN | ADC12J4000 | FPGA Lane 2 | HIGH | LVDS / LVDS_25 |
| 24 | JESD204B_D_N2 | C18 | 1.8V | IN | ADC12J4000 | FPGA Lane 2 | HIGH | LVDS / LVDS_25 |
| 25 | JESD204B_D_P3 | D17 | 1.8V | IN | ADC12J4000 | FPGA Lane 3 | HIGH | LVDS / LVDS_25 |
| 26 | JESD204B_D_N3 | D18 | 1.8V | IN | ADC12J4000 | FPGA Lane 3 | HIGH | LVDS / LVDS_25 |
| 27 | JESD204B_SYNC_P | F15 | 1.8V | IN | ADC12J4000 | FPGA SYNC | HIGH | LVDS / LVDS_25 |
| 28 | JESD204B_SYNC_N | E15 | 1.8V | IN | ADC12J4000 | FPGA SYNC | HIGH | LVDS / LVDS_25 |
| 29 | ADC_CLK_P | G6 | 1.8V | OUT | FPGA PLL (BUFDS) | ADC (CLK+) | LOW | LVDS |
| 30 | ADC_CLK_N | G7 | 1.8V | OUT | FPGA PLL (BUFDS) | ADC (CLK-) | LOW | LVDS |
| 31 | ADC_CS_N | F5 | 1.8V | OUT | FPGA GPIO | ADC (CSB) | HIGH | LVCMOS18 |
| 32 | TCK | M10 | 3.3V | IN | JTAG Debugger | FPGA JTAG | HIGH | LVCMOS33 |
| 33 | TDI | N9 | 3.3V | IN | JTAG Debugger | FPGA JTAG | HIGH | LVCMOS33 |
| 34 | TDO | P10 | 3.3V | OUT | FPGA JTAG | JTAG Debugger | HIGH | LVCMOS33 |
| 35 | TMS | N10 | 3.3V | IN | JTAG Debugger | FPGA JTAG | HIGH | LVCMOS33 |

---

## 9. Functional Specifications

**Summary of FPGA Functions:**

| S.No. | Function Name | Description |
|:---:|:---|:---|
| 1 | **JESD204B Link Interface** | 4-Lane receiver to capture 12-bit ADC data at 4 GSPS. |
| 2 | **RF Component SPI Control** | Dual independent SPI masters to configure HMC830 (LO) and HMC698 (VGA). |
| 3 | **MCU Command Interface** | SPI Slave interface accepting configuration commands from STM32F407. |
| 4 | **Digital Signal Processing** | Real-time FFT and CW detection logic on FPGA fabric. |
| 5 | **ADC Clock Generation** | PLL-driven low-jitter clock source for the ADC. |
| 6 | **System Monitoring** | Power-good detection and configuration status reporting. |

### 9.1 JESD204B High Speed Interface
- **Standard:** JEDEC JESD204B (Revision B).
- **Lane Rate:** Configurable up to 4.0 Gbps (requires FPGA GTX transceiver logic or high-performance I/O SERDES blocks depending on FPGA utilization; Note: XC7A35T does not have GTX, so interface must be implemented using ISERDES blocks in HP I/O Banks if supported, or source-synchronous logic).
- **Encoding:** 8b/10b scrambled.
- **Lanes:** 4 physical lanes (Lane 0, 1, 2, 3).
- **Scrambler:** Enables to reduce EMI.
- **FPGA Role:** Link Layer and Transport Layer implementation.
- **Buffering:** Implements a small FIFO (Block RAM) to decouple the high-speed ADC data domain from the processing domain.

### 9.2 SPI Control Interface (RF Components)
The FPGA implements two independent SPI Master modules to offload the STM32 MCU.
- **Interface 1: LO Synthesizer (HMC830LP6GE)**
  - **Clock Frequency:** Max 20 MHz.
  - **Frame Size:** 32-bit (Instruction + Data).
  - **Function:** Programs frequency (7.4-20.4 GHz) and output power.
- **Interface 2: VGA (HMC698LP4)**
  - **Clock Frequency:** Max 10 MHz.
  - **Frame Size:** 8-bit parallel load + Latch signal.
  - **Function:** Sets gain from 0 to 44 dB in 1 dB steps.

### 9.3 MCU Communication Interface
- **Protocol:** SPI Mode 0 (CPOL=0, CPHA=0).
- **Data Width:** 8-bit.
- **Bit Order:** MSB First.
- **Commands:**
  - `0x01`: Write LO Frequency (pass-through to LO_SPI).
  - `0x02`: Write VGA Gain (pass-through to VGA_SPI).
  - `0x03`: Read FPGA Status (DONE, Locked, Error codes).
  - `0x04`: Reset ADC Link.

### 9.4 ADC Clock Generation
- **Source:** On-board 125 MHz Oscillator (Reference for FPGA PLL).
- **PLL:** Xilinx MMCM/PLL primitive.
- **Output Frequency:** 250 MHz (to suit ADC requirements or system sample rate).
- **Output Type:** LVDS (Low Voltage Differential Signaling).
- **Jitter:** < 1 ps RMS (required for SFDR performance).

### 9.5 Signal Processing Pipeline
1.  **Data Alignment:** Aligns the 4 JESD204B lanes into a single 12-bit data stream.
2.  **Decimation:** Digital Low Pass Filter (FIR) to bandwidth-limit signal to IF bandwidth (e.g., 20 MHz).
3.  **FFT Engine:** 1024-point FFT core (using DSP Slices) for frequency analysis.
4.  **Peak Detect:** Detects peak magnitude and frequency bin index.
5.  **Output:** Results buffered in BRAM and flagged to MCU via GPIO interrupt.

### 9.6 Power Supply Sequencing & Monitoring
- **Sequencing:** FPGA waits for `FPGA_RESET_N` to be released by MCU.
- **Monitoring:** FPGA monitors `VCCINT` (1.0V) via internal XADC.
- **Action:** If voltage drops below threshold (0.95V), FPGA halts processing and asserts error flag to MCU.

### 9.7 Configuration & Programming
- **Mode:** Master BPI or SPI (Standard Xilinx boot modes).
- **Init:** On power-up, FPGA loads bitstream from external Flash (Not explicitly in BOM but assumed for production) or JTAG.
- **Remote Update:** MCU can trigger a "MultiBoot" address change to load a backup image stored in flash.

---

## Annexure A — Requirement Traceability Matrix

| S.No. | Requirement ID | Description | HRS Section | GLR Section |
|:---:|:---|:---|:---:|:---:|
| 1 | REQ-HW-001 | RF Input Frequency Range (5-18 GHz) | HRS §3.1 | 9.2 (LO Control) |
| 2 | REQ-HW-005 | Signal Type Compatibility (CW) | HRS §3.1 | 9.5 (DSP Pipeline) |
| 3 | REQ-HW-007 | Downconversion Architecture | HRS §3.1 | 9.2 (LO/VGA Control) |
| 4 | REQ-HW-008 | Local Oscillator Generation | HRS §3.1 | 9.2 (LO SPI Interface) |
| 5 | REQ-HW-009 | Gain Control Range (40 dB) | HRS §3.1 | 9.2 (VGA SPI Interface) |
| 6 | REQ-HW-019 | FPGA Signal Processing | HRS §3.1 | 9.5 (DSP/FFT) |
| 7 | REQ-HW-020 | CW Detection Mode | HRS §3.1 | 9.5 (Peak Detect) |
| 8 | REQ-HW-002 | Frequency Tuning Resolution | HRS §3.2 | 9.2 (LO Precision) |