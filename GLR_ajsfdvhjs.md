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
| S. No. | Ver. No. | Ver. Date | Changed By | Section(s) Changed | Description of Change |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | 0V01 | 15.04.2026 | - | - | Initial Version |

---

## 1. Scope of the Document
This document details the Input/Output (I/O) interfaces, signal connectivity, and functional logic requirements for the **STM32F407** microcontroller and associated glue logic within the **ajsfdvhjs Wideband RF Receiver** project.

The "Glue Logic" in this context refers to the firmware and peripheral configurations required to bridge the RF Front-End components (LNA, Mixers, Synthesizer, ADC) and the Power Management system. This document serves as the bridge between the Hardware Requirements Specification (HRS) and the Firmware Design Document, ensuring precise electrical timing and protocol adherence for SPI, JESD204B synchronization, and power sequencing.

Target Audience: Embedded Firmware Engineers, FPGA Engineers (for JESD204B SYSREF logic), and Hardware Test Engineers.

---

## 2. References

### 2.1 External
| Doc. Type | Part No. | Description |
| :--- | :--- | :--- |
| Datasheet | **HMC1048LP4BE** | GaAs Schottky Diode Double Balanced Mixer |
| Datasheet | **TGA4943-SL** | Wideband GaN MMIC Power Amplifier (Driver/LNA) |
| Datasheet | **HMC1119LP4ME** | Wideband Integrated Receiver with IQ Demodulator |
| Datasheet | **ADF5356CCPZ** | Microwave Wideband Synthesizer with Integrated VCO |
| Datasheet | **AD9208-3000EBZ** | Dual, 14-Bit, 3 GSPS A/D Converter |
| Datasheet | **STM32F407VGT6** | High-Performance F4 Series MCU Reference Manual |
| Datasheet | **PE4259** | HaRP™ Technology Ultra-High Linearity SPDT Switch |
| Datasheet | **ADP5071ACPZ** | Dual Step-Up/Step-Down Regulator |
| Datasheet | **LT3045EDD** | Ultra Low Noise Linear Regulator |
| Datasheet | **LT3094IDE** | Ultra Low Noise Negative Linear Regulator |

### 2.2 Internal
| Reference | Document |
| :--- | :--- |
| [HRS] | Hardware Requirements Specification (ajsfdvhjs) |
| [SCH] | Schematic Schematic Capture (ajsfdvhjs) |
| [GRS] | General Requirements Specification |
| [GDD] | General Design Document |
| [BOM] | Bill of Materials (ajsfdvhjs) |

---

## 3. Acronyms and Abbreviations

| Acronym | Expansion |
| :--- | :--- |
| **ADC** | Analog-to-Digital Converter |
| **BOM** | Bill of Materials |
| **CML** | Current Mode Logic |
| **CPU** | Central Processing Unit |
| **DAC** | Digital-to-Analog Converter |
| **DMA** | Direct Memory Access |
| **DSP** | Digital Signal Processing |
| **EMC** | Electromagnetic Compatibility |
| **FPGA** | Field-Programmable Gate Array |
| **GPIO** | General Purpose Input/Output |
| **GND** | Ground Reference |
| **HRS** | Hardware Requirements Specification |
| **I2C** | Inter-Integrated Circuit |
| **IO** | Input/Output |
| **JESD** | JEDEC Standard for Serial Interface for Data Converters |
| **LVDS** | Low-Voltage Differential Signaling |
| **LNA** | Low Noise Amplifier |
| **LUT** | Look-Up Table |
| **MCU** | Microcontroller Unit |
| **PA** | Power Amplifier |
| **PCB** | Printed Circuit Board |
| **PLL** | Phase-Locked Loop |
| **RF** | Radio Frequency |
| **RoHS** | Restriction of Hazardous Substances |
| **RTL** | Register Transfer Level |
| **SPI** | Serial Peripheral Interface |
| **SSTL** | Stub Series Terminated Logic |
| **TRP** | Transmit/Receive Pulse (or Protection) |
| **TTL** | Transistor-Transistor Logic |
| **UART** | Universal Asynchronous Receiver-Transmitter |
| **VCC** | Voltage Common Collector (Supply) |

---

## 4. Module Overview

The **ajsfdvhjs** Wideband RF Receiver module comprises a high-frequency analog chain digitized for signal processing. The Glue Logic (implemented in the STM32F407) acts as the system controller, managing component initialization, power sequencing, and real-time configuration.

### RF SECTION
*   **Input:** RF_IN (5-18 GHz) via **PE4259** SPDT Switch (A1) for protection/selection.
*   **Amplification:** **TGA4943-SL** (U1) acts as the initial gain stage.
*   **Downconversion:** **HMC1048LP4BE** (U2) and **HMC1119LP4ME** (U3) perform the downconversion and IQ demodulation.
*   **LO Generation:** **ADF5356** (U4) provides the local oscillator signal distributed via a Magic Tee (T1).
*   **Digitization:** **AD9208** (U5) digitizes the I/Q baseband signals.

### DIGITAL SECTION
*   **Controller:** **STM32F407VGT6** (U20). Manages SPI interfaces for PLL (U4) and ADC (U5).
*   **Interfaces:**
    *   **SPI (Master):** Controls the ADF5356 (U4) frequency synthesizer.
    *   **SPI (Master):** Configures the AD9208 (U5) register map.
    *   **JESD204B Interface:** The AD9208 outputs high-speed serial data (JESD_CKP, JESD_DxP/N) to an external FPGA (not detailed in BOM, but defined via connector J2). The STM32 manages the *SYSREF_REQ* and *SYNC_IN* slow-speed control lines for the ADC link setup.
    *   **PLL Monitor:** MUXOUT line from ADF5356 to STM32 for lock detection/status.

### POWER SUPPLY SECTION
*   **Primary Input:** +12V DC via Header J4, protected by F1 (PTC Fuse) and D1 (TVS).
*   **Generation:** **ADP5071** (U6, U7) generates intermediate rails from 12V.
*   **Regulation:** **LT3045** (U10, U11) provides low-noise positive rails (likely for RF blocks/ADC).
*   **Regulation:** **LT3094** (U12, U13) provides low-noise negative rails (likely for ADC bias).

---

## 5. Features
*   **MCU:** STM32F407VGT6 (ARM Cortex-M4, 168 MHz, 1MB Flash).
*   **RF Front End:** 5-18 GHz coverage using HMC1119LP4ME integrated receiver.
*   **High-Speed Digitization:** AD9208 Dual 14-bit ADC supporting up to 3 GSPS.
*   **LO Synthesis:** ADF5356 wideband synthesizer with low phase noise (<-100 dBc/Hz).
*   **Data Interface:** JESD204B subclass 1 (implied by SYSREF) support via high-speed connector J2.
*   **Control Interface:** Triple SPI bus management (PLL, ADC, and potentially generic GPIO).
*   **Power Management:** ADP5071-based switching supply with LT304x post-regulation for low noise.
*   **Protection:** PE4259 RF Switch and PTC Fuse on main input.

---

## 6. FPGA / MCU Description

*Note: The BOM specifies an STM32F407 MCU, which acts as the primary glue logic controller. While the prompt implies an FPGA document, the design utilizes a high-speed MCU for configuration.*

| S.NO | PARAMETERS | SPECIFICATION |
| :--- | :--- | :--- |
| 1 | Part Number | STM32F407VGT6 |
| 2 | Core | ARM Cortex-M4F with FPU |
| 3 | Max Frequency | 168 MHz |
| 4 | Flash Memory | 1 Mbyte |
| 5 | SRAM | 192 Kbytes (128+16+48) |
| 6 | Timers | Up to 14 timers (2x watchdog, SysTick, etc.) |
| 7 | Communication Interfaces | 3x SPI, 4x USART, 2x I2C, USB FS |
| 8 | Package | LQFP100 |
| 9 | GPIO Count | 80 I/O ports (5V tolerant on specific pins) |

---

## 7. Block Diagram

**Reference:**
*   **Control Center:** STM32F407 (U20)
*   **Frequency Synthesis:** ADF5356 (U4) <- SPI <- U20
*   **Digitizer:** AD9208 (U5) <- SPI/SYNC <- U20
*   **Data Output:** JESD204B -> Connector J2 -> External FPGA
*   **Power:** 12V -> ADP5071 -> LT3045/LT3094 -> RF/ADC Rails.

---

## 8. Pinout Details

**Table: STM32F407 & System Pin Out Details**
*Note: MCU Pin numbers are logical assignments or generic LQFP100 references for the design capture. "Netlist Name" refers to the signal name defined in P4.*

| S.No | Signal Name | Pin No (Ref) | Voltage Level | Direction wrt MCU | Source | Destination | Default Condition | Voltage Standard |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | **12V_SUPPLY** | J4-Pin1 | 12.0V | Input | External PSU | F1 | OFF | N/A |
| 2 | **GND** | J4-Pin2 | 0V | Reference | External PSU | GND | GND | N/A |
| 3 | **RF_IN_FROM_SMA** | J1-Pin1 | RF | Input | Antenna | A1 (PE4259) | 50 Ohm | RF |
| 4 | **SPI_SCLK** | PA5 | 3.3V | Output | MCU | ADF5356_CLK | LOW | CMOS |
| 5 | **SPI_SDIO** | PA7 | 3.3V | Bidirectional | MCU | ADF5356_DATA | HIGH Z | CMOS |
| 6 | **SPI_CS_PLL** | PA4 | 3.3V | Output | MCU | ADF5356_LE | HIGH | CMOS |
| 7 | **PLL_MUXOUT** | PE6 | 3.3V | Input | ADF5356 | MCU | LOW | CMOS |
| 8 | **SPI_SCLK_ADC** | PB13 | 3.3V | Output | MCU | AD9208_SCK | LOW | CMOS |
| 9 | **SPI_SDIO_ADC** | PB15 | 3.3V | Bidirectional | MCU | AD9208_SDI/SDO | HIGH Z | CMOS |
| 10 | **SPI_CS_ADC** | PB12 | 3.3V | Output | MCU | AD9208_CS | HIGH | CMOS |
| 11 | **ADC_SDO** | PB14 | 3.3V | Input | AD9208 | MCU | LOW | CMOS |
| 12 | **SYSREF_REQ** | PA8 | 3.3V | Output | MCU | AD9208 | LOW | LVCMOS |
| 13 | **SYNC_IN** | PA0 | 3.3V | Output | MCU | AD9208_SYNC | LOW | LVCMOS |
| 14 | **JESD_CKP** | J2-Pin1 | 1.8V/3.3V | Output | AD9208 | FPGA | Differential | CML |
| 15 | **JESD_CKN** | J2-Pin2 | 1.8V/3.3V | Output | AD9208 | FPGA | Differential | CML |
| 16 | **JESD_D0P** | J2-Pin3 | 1.8V/3.3V | Output | AD9208 | FPGA | Differential | CML |
| 17 | **JESD_D0N** | J2-Pin4 | 1.8V/3.3V | Output | AD9208 | FPGA | Differential | CML |
| 18 | **JESD_D1P** | J2-Pin5 | 1.8V/3.3V | Output | AD9208 | FPGA | Differential | CML |
| 19 | **JESD_D1N** | J2-Pin6 | 1.8V/3.3V | Output | AD9208 | FPGA | Differential | CML |
| 20 | **RF_TO_LNA** | (Net) | RF | Signal | PE4259 | TGA4943 | 50 Ohm | RF |
| 21 | **LO_MAIN** | (Net) | RF | Output | ADF5356 | Magic_Tee | -5dBm | RF |
| 22 | **LO_MIXER1_PATH** | (Net) | RF | Signal | Magic_Tee | HMC1048 | 50 Ohm | RF |
| 23 | **I_OUT_P** | (Net) | Analog | Output | HMC1119 | AD9208 | DC Bias | Analog |
| 24 | **I_OUT_N** | (Net) | Analog | Output | HMC1119 | AD9208 | DC Bias | Analog |
| 25 | **Q_OUT_P** | (Net) | Analog | Output | HMC1119 | AD9208 | DC Bias | Analog |
| 26 | **Q_OUT_N** | (Net) | Analog | Output | HMC1119 | AD9208 | DC Bias | Analog |
| 27 | **VDD_FPGA** | (Logic) | 3.3V | Power | LDO | MCU IO | 3.3V | N/A |
| 28 | **ADC_REF_MID** | (Net) | 0.9V | Reference | R14/R15 | AD9208_REF | 0.9V | Analog |
| 29 | **MCU_RX** | PA10 | 3.3V | Input | Debugger | MCU | HIGH | UART |
| 30 | **MCU_TX** | PA9 | 3.3V | Output | MCU | Debugger | HIGH | UART |
| 31 | **MCU_RESET** | NRST | 3.3V | Input | Debugger | MCU | HIGH | CMOS |
| 32 | **MCU_BOOT0** | BOOT0 | 3.3V | Input | PullDn | MCU | LOW | CMOS |
| 33 | **MCU_VCAP** | VCAP | 1.8V | Power | Regulator | MCU Core | 1.8V | N/A |
| 34 | **LED_STATUS** | PA15 | 3.3V | Output | MCU | LED1 | LOW | CMOS |
| 35 | **LED_ERROR** | PB9 | 3.3V | Output | MCU | LED2 | LOW | CMOS |
| 36 | **SPI_MISO** | PA6 | 3.3V | Input | Peripherals | MCU | HIGH Z | CMOS |

---

## 9. Functional Specifications

### 9.1 System Configuration & Control Interface
*   **Primary Interface:** The STM32F407 configures the RF chain via two dedicated SPI buses.
*   **PLL Control (ADF5356):**
    *   **Protocol:** 3-wire SPI (CLK, DATA, LE).
    *   **Functionality:** Write frequency registers (INT, FRAC, MOD), prescaler, and output divider settings to achieve 5-18 GHz RF output (including VCO multiplication).
    *   **Feedback:** Monitor **PLL_MUXOUT** to confirm Lock Detect (Active High).
*   **ADC Control (AD9208):**
    *   **Protocol:** SPI 4-wire (SCK, SDIO, SDO, CS).
    *   **Functionality:** Configure JESD204B link parameters (Lane rate, K, F, M, S, Subclass), test modes, and power-down states.
    *   **Sync Mechanism:** Drive **SYNC_IN** signal to align the JESD204B local multi-frame clock (LMFC) across the device.

### 9.2 High Speed Communication Interface (JESD204B)
*   **Physical Layer:** CML (Current Mode Logic) drivers on AD9208 interfacing to an FPGA via Connector J2.
*   **Lanes:** 2 Lanes (Lane 0 and Lane 1).
*   **Data Rate:** Configurable up to 12.5 Gbps per lane (scaled down based on ADC sampling rate).
*   **Encoding:** 8b/10b scrambled.
*   **Subclass:** Subclass 1 (Deterministic Latency).
*   **Glue Logic Role:** The STM32 is responsible for the initial bring-up of the link. It must toggle **SYSREF_REQ** to generate a SYSREF event if the clock generator supports it, or manually trigger synchronization via **SYNC_IN** until the ADC's "CODE_GRP_SYNC" status register indicates alignment.

### 9.3 Power On/Off Sequence
#### 9.3.1 Power ON Sequence
1.  **Apply +12V:** System receives power via J4. F1 and D1 protect against over-voltage/reverse polarity.
2.  **Supply Generation:** ADP5071 enables switching regulators to generate intermediate rails (e.g., +/- 5V or intermediate voltages).
3.  **Linear Regulation:** LT3045 (Pos) and LT3094 (Neg) regulators enable to provide low-noise rails for the HMC1119 and AD9208.
4.  **MCU Start:** STM32F407 boots. firmware initializes GPIO (All CS lines High, Drivers Low).
5.  **RF Enable:** Configure **PE4259** (A1) switch to pass RF to LNA (TGA4943-SL).
6.  **LO Configuration:** Write to **ADF5356** to set default frequency. Wait for LOCK.
7.  **ADC Calibration:** Configure **AD9208**. Run offset/gain calibration routines.

#### 9.3.2 Mode Configuration
| Mode | Condition | Action |
| :--- | :--- | :--- |
| **Normal RX** | Default | PE4259 RF Path Closed. ADC Streaming. |
| **Standby** | CMD received | PE4259 RF Path Open. ADC Power Down. |
| **Test Mode** | Pin Strapped | ADC generates internal digital test patterns (PRBS/Custom). |

### 9.4 Supply Voltage, Current & Temperature Monitoring
*   **Requirement:** The system includes precision references (R14, R15) for ADC calibration. While no dedicated PMIC I2C monitor is explicitly netlisted in the summary (excluding ADC internal monitors), the **AD9208** features internal on-chip temperature and voltage sensors accessible via its SPI register map.
*   **Glue Logic:** Periodically read AD9208 Register 0x014 (Die Temperature) and supply status registers.
*   **Action:** If Temperature > +85°C, disable **PE4259** (RF_IN) and assert LED_ERROR.

### 9.5 Flash & Interfaces
*   **Internal Flash:** STM32F407 utilizes its 1MB internal Flash to store:
    *   Frequency Lookup Tables (LUTs) for the ADF5356.
    *   Default SPI configuration structures for the AD9208.
    *   Firmware calibration constants.
*   **No Ext. Flash:** No external EEPROM or Flash is present in the provided BOM; all non-volatile storage relies on the MCU's internal memory.

### 9.6 RF Path / TRP Configuration
*   **Path Control:** The **PE4259** (U1, labeled A1 in Netlist) controls the RF Input path.
*   **Control Signal:** Controlled by a GPIO (e.g., RF_EN).
*   **Logic:**
    *   Logic High = RF Path Closed (Signal passes to LNA).
    *   Logic Low = RF Path Open (50 Ohm termination to GND on alternate port).

### 9.7 Remote Programming
*   **Interface:** UART (Connected via debugger header J4/SWD).
*   **Protocol:** Custom command structure.
    *   `SET_FREQ <MHz>` -> calculates ADF5356 regs -> Writes SPI.
    *   `SET_GAIN <dB>` -> (If supported by VGA/ADC gain block) -> Writes SPI.
*   **Bootloader:** STM32F407 supports DFU (Device Firmware Upgrade) via USB if populated, or UART Bootloader for remote firmware updates.

### 9.8 Synthesizer Control (LO Generation)
*   **Target:** ADF5356 (U4).
*   **Frequency Range:** System requires 5-18 GHz.
    *   ADF5356 Fund. range: 53.125 MHz to 13.6 GHz.
    *   VCO Doubler: Engaged for 13.6 GHz to 27.2 GHz range.
*   **Implementation:**
    *   For 5-13.6 GHz: Use fundamental VCO.
    *   For 13.6-18 GHz: Enable VCO doubler.
*   **GUI/Firmware:** Must calculate the INT, FRAC, and MOD values based on the PFD frequency (likely 100 MHz - 125 MHz reference oscillator).

### 9.9 Beam Steering / Signal Processing
*   *Note: Beam steering is typically handled post-digitization by an FPGA connected to J2.*
*   **Role of Glue Logic:** The STM32 only ensures the high-fidelity capture of I/Q data via the AD9208. It does not calculate phase weights digitally.

### 9.10 Gate Voltage / Bias Control
*   **Implicit Control:** The **TGA4943-SL** is a GaN amplifier requiring specific gate biasing.
*   **Implementation:** In the provided schematic snippet, bias is likely derived from the **LT3045** or controlled via the **PE4259** enable line tied to a buffer.
*   **Requirement:** Ensure the Gate Voltage is sequenced *after* the Drain voltage (handled by Power Supply sequencer) or held low until the PA is enabled to prevent burnout.

---

## Annexure A — Requirement Traceability Matrix

| S.No | Requirement ID | Description | HRS Section | GLR Section |
| :--- | :--- | :--- | :--- | :--- |
| 1 | HRS-001 | Serial Communication Interface (Control) | HRS §3.3 | 9.1 |
| 2 | HRS-002 | High Speed Communication (JESD204B) | HRS §3.3 | 9.2 |
| 3 | HRS-003 | Power Supply Sequencing | HRS §3.4 | 9.3 |
| 4 | HRS-004 | Voltage/Current/Temperature Monitoring | HRS §3.4 | 9.4 |
| 5 | HRS-005 | Flash Interfaces (Storage) | HRS §3.3 | 9.5 |
| 6 | HRS-006 | RF Control (PE4259 Switch) | HRS §3.1 | 9.6 |
| 7 | HRS-007 | FPGA/MCU Remote Programming | HRS §3.3 | 9.7 |
| 8 | HRS-008 | Frequency Synthesizer Control | HRS §3.1 | 9.8 |
| 9 | HRS-009 | ADC Interface & Control | HRS §3.2 | 9.1, 9.2 |