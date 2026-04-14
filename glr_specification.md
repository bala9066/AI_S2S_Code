# Glue Logic Requirements (GLR)

## Document Control
| Document Title | Glue Logic Requirements |
| :--- | :--- |
| Version Date | 14.04.2026 |
| Version Number | 0V01 |
| Prepared By | Name: . Sign: |
| Document Review By | Name: . Sign: |

---

## Amendments to the Document
| S. No. | Ver. No. | Ver. Date | Changed By | Section(s) Changed | Description of Change |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | 0V01 | 14.04.2026 | - | - | Initial Version |

---

## 1. Scope of the Document
This document explains the IO details and functional requirements of the Microcontroller Unit (MCU) and Glue Logic for the **rx module**. Targeted audience: Hardware Design and Firmware teams. This specification bridges the schematic/netlist phase and the firmware driver development phase.

---

## 2. References

### 2.1 External
| Doc. Type | Part No. | Description |
| :--- | :--- | :--- |
| Datasheet | **STM32L433CBT6** | Ultra-low-power ARM Cortex-M4 MCU |
| Datasheet | **HMC1119LP4E** | 0.25 dB LSB GaAs Digital Step Attenuator, 6 GHz |
| Datasheet | **HMC384LP4** | GaAs MMIC PHEMT Amplifier, DC - 6 GHz |
| Datasheet | **AD8318ACPZ** | RF Logarithmic Detector/Controller, 1 MHz - 8 GHz |
| Datasheet | **TMP102AIDRLR** | Digital Temperature Sensor with Two-Wire Interface |
| Datasheet | **AMS1117-3.3** | 1-A Low Dropout Linear Regulator, 3.3V Fixed |
| Datasheet | **AMS1117-5.0** | 1-A Low Dropout Linear Regulator, 5.0V Fixed |
| Datasheet | **DMG3406L-7** | N-Channel MOSFET (Logic Level) |

### 2.2 Internal
| Reference | Document |
| :--- | :--- |
| [HRS] | Hardware Requirements Specification (RX-MOD-001-HRS) |
| [SCH] | Schematic Capture (rx_module) |
| [GRS] | General Requirements Specification |
| [GDD] | General Design Document |

---

## 3. Acronyms and Abbreviations
| Acronym | Expansion |
| :--- | :--- |
| MCU | Microcontroller Unit |
| RF | Radio Frequency |
| DSA | Digital Step Attenuator |
| PA | Power Amplifier (RF Amp) |
| GPIO | General Purpose Input/Output |
| SPI | Serial Peripheral Interface |
| I2C | Inter-Integrated Circuit |
| UART | Universal Asynchronous Receiver-Transmitter |
| ADC | Analog-to-Digital Converter |
| DAC | Digital-to-Analog Converter (Internal MCU) |
| OVP | Over Voltage Protection / Over Power Protection |
| OTP | Over Temperature Protection |
| VGG | Gate Bias Voltage (Negative) |
| LDO | Low Dropout Regulator |
| PCB | Printed Circuit Board |
| BOM | Bill of Materials |
| ESD | Electrostatic Discharge |
| EMC | Electromagnetic Compatibility |
| SMBus | System Management Bus (Compatible with I2C) |

---

## 4. Module Overview

**RF SECTION:**
The RF chain consists of a Digital Step Attenuator (DSA) **HMC1119LP4E** for gain control, followed by a Driver Amplifier **HMC384LP4**. Input is via SMA edge connector. Power detection is handled by **AD8318ACPZ**, sampling the coupled output from the amplifier to provide a DC voltage proportional to RF power.

**DIGITAL SECTION:**
Control is managed by an **STM32L433CBT6** MCU. This device manages the SPI interface to the DSA, reads the analog power detector and temperature sensor via internal ADC and I2C respectively, and generates gate bias control (VGG) and PA Enable signals using MOSFET drivers (**DMG3406L-7**). Communication to the host system is via UART and I2C through a 12-pin system header.

**POWER SUPPLY SECTION:**
The board accepts raw VIN (5.0V - 12.0V typical) via the system header. An on-board **AMS1117-5.0** generates a stable 5V rail for the RF components (PA, Power Detector, and 5V loads). A secondary **AMS1117-3.3** generates the 3.3V rail required for the MCU, DSA logic, and Temperature Sensor. Grounding is a common star ground.

---

## 5. Features
- **MCU**: STMicroelectronics STM32L433CBT6 (ARM Cortex-M4, 48-pin LQFP).
- **On-board Clock**: Internal 16MHz RC oscillator (HSE capable via optional footprint).
- **Communication**:
    - UART (System Interface) @ 3.0 Mbps.
    - I2C (Temp Sensor & System Interface) @ 400 kHz (Fast Mode).
    - SPI (DSA Control) @ 10 MHz max.
- **Telemetry**:
    - Internal 12-bit ADC for RF Power Detection.
    - I2C Temperature Sensor (TMP102AIDRLR) for board monitoring.
- **Calibration**: On-board DSA (HMC1119LP4E) with 0.25 dB resolution (7-bit).
- **Protection**:
    - Hardware Overtemp Alert (TMP102).
    - Software Overpower Protection (via ADC reading).
    - PA Enable logic with safe startup sequencing.

---

## 6. MCU Description

The **STM32L433CBT6** is selected for its ultra-low power consumption, integrated mixed-signal features (ADC, DAC), and rich communication peripheral set suitable for glue logic implementation.

**Specification Table:**

| S.NO | PARAMETERS | SPECIFICATION |
|:-----|:-----------|:--------------|
| 1 | Part Number | STM32L433CBT6 |
| 2 | Core | ARM Cortex-M4 with FPU |
| 3 | Flash Memory | 256 KB |
| 4 | SRAM | 64 KB |
| 5 | Max Frequency | 80 MHz |
| 6 | Supply Voltage | 1.71V to 3.6V (3.3V nominal) |
| 7 | Packages | LQFP48 |
| 8 | GPIOs | 37 I/Os |
| 9 | 12-bit ADC | 2.4 MSPS, 16 channels |
| 10 | SPI | 2 Interfaces |
| 11 | I2C | 2 Interfaces (SMBus/PMBus) |
| 12 | UART | 2 Interfaces |
| 13 | DAC | 2 Channels (Internal, used for VGG Ctrl) |

---

## 7. Block Diagram
(Reference to Block Diagram: The system follows a signal path: SMA Input -> DSA -> RF Amp -> SMA Output. A coupled path goes to RF Detector -> MCU ADC. Control flows from MCU -> SPI -> DSA, and MCU -> GPIO -> MOSFETs -> RF Amp Bias.)

---

## 8. Pinout Details

**Table: MCU (STM32L433CBT6) Pin Out Details**

| S.No | Signal Name | Pin No (MCU) | Voltage Level | Direction wrt MCU | Source | Destination | Default Condition | Voltage Standard |
|:-----|:------------|:-------------|:--------------|:------------------|:-------|:------------|:------------------|:-----------------|
| 1 | VDD | 24 | 3.3V | Power | 3.3V_LDO | MCU_VDD | On | - |
| 2 | VDDA | 13 | 3.3V | Power | 3.3V_LDO | MCU_VDDA | On | - |
| 3 | VSS | 23 | GND | Power | GND | MCU_VSS | On | - |
| 4 | VSSA | 12 | GND | Power | GND | MCU_VSSA | On | - |
| 5 | BOOT0 | 44 | 3.3V | Input | Pull-Dn | MCU | Low | CMOS |
| 6 | NRST | 4 | 3.3V | Input | Ext/Header | MCU_Reset | High | CMOS |
| 7 | OSC32_IN | 3 | 3.3V | Input | 32kHz_Xtal | MCU | Floating | CMOS |
| 8 | OSC32_OUT | 2 | 3.3V | Output | MCU | 32kHz_Xtal | Low | CMOS |
| 9 | PH0-OSC_IN | 5 | 3.3V | Input | 8MHz_Xtal | MCU | Floating | CMOS |
| 10 | PH1-OSC_OUT | 6 | 3.3V | Output | MCU | 8MHz_Xtal | Low | CMOS |
| 11 | PA2-WKUP-USART2_TX | 21 | 3.3V | Output | MCU | J3(SYS_TXD) | High (Idle) | CMOS |
| 12 | PA3-USART2_RX | 22 | 3.3V | Input | J3(SYS_RXD) | MCU | High | CMOS |
| 13 | PB8-I2C1_SCL | 45 | 3.3V | Bidirectional | MCU | J3, U5 | High | I2C |
| 14 | PB9-I2C1_SDA | 46 | 3.3V | Bidirectional | MCU | J3, U5 | High | I2C |
| 15 | PA5-SPI1_SCK | 20 | 3.3V | Output | MCU | U3(DSA) | Low | SPI |
| 16 | PA7-SPI1_MOSI | 19 | 3.3V | Output | MCU | U3(DSA) | Low | SPI |
| 17 | PA4-SPI1_NSS | 18 | 3.3V | Output | MCU | U3(CS) | High | SPI |
| 18 | PA0-ADC1_IN5 | 14 | 0-3.3V | Input | U4(Det) | MCU | Hi-Z | Analog |
| 19 | PA1-ADC1_IN6 | 15 | 0-3.3V | Input | U4(Det/Adj) | MCU | Hi-Z | Analog |
| 20 | PB1-VGG_CTRL_DAC | 35 | 0-3.3V | Output | MCU(DAC1_CH1) | Q1_Gate | Low | Analog |
| 21 | PA8-PA_ENABLE | 29 | 3.3V | Output | MCU | Q2_Gate | Low | CMOS |
| 22 | PB0-STAT_LED | 36 | 3.3V | Output | MCU | LED1 | Low | CMOS |
| 23 | PA9-OVP_TRIG | 32 | 3.3V | Input | U4(VDET) | MCU(Int) | Low | CMOS |
| 24 | PB6-TEMP_ALERT | 40 | 3.3V | Input | U5(ALERT) | MCU(Int) | High | CMOS |
| 25 | PA10-SYS_TX_ALT | 43 | 3.3V | Alt Output | MCU | Debug | High | CMOS |
| 26 | PA11-SYS_RX_ALT | 44 | 3.3V | Alt Input | Debug | MCU | High | CMOS |
| 27 | PB10-SPI2_SCK | 47 | 3.3V | Alt Out | MCU | Exp | Low | SPI |
| 28 | PB11-SPI2_MISO | 48 | 3.3V | Alt In | Exp | MCU | High | SPI |
| 29 | PB12-RESET_SENSE | 49 | 3.3V | Input | Button | MCU | High | CMOS |
| 30 | PB13-SWDIO | 34 | 3.3V | In/Out | Debugger | MCU | High | SWD |
| 31 | PB14-SWCLK | 37 | 3.3V | Input | Debugger | MCU | High | SWD |
| 32 | PC13-TAMPER | 2 | 3.3V | Input | Button | RTC | High | CMOS |
| 33 | PC14-OSC32 | 3 | 3.3V | Input | XTAL | MCU | Hi-Z | Analog |
| 34 | PC15-OSC32 | 4 | 3.3V | Output | MCU | XTAL | Low | Analog |
| 35 | PA11-USB_DM | USB | 3.3V | Bidirectional | MCU | USB | Floating | USB |
| 36 | PA12-USB_DP | USB | 3.3V | Bidirectional | MCU | USB | Floating | USB |

---

## 9. Functional Specifications

**Summary table:**

| S.No. | Function Name | Description |
|:-----|:--------------|:-------------|
| 1 | Serial Communication Interface | UART between Host PC & Module (Command/Control). |
| 2 | High Speed Communication Interface | Not utilized on this specific module (Reserved for future expansion). |
| 3 | Power Supply Sequencing & Health Status | 3.3V/5V LDO sequencing, PA Enable timing control. |
| 4 | Supply Voltage, Current & Temperature Monitoring | I2C Temp sensor & internal ADC monitoring. |
| 5 | Flash Interfaces | Internal Flash for calibration tables/parameters. |
| 6 | TRP Configuration | PA_ENABLE controls RF Transmit/Receive path active state. |
| 7 | Remote Programming | Bootloader via UART for firmware updates. |
| 8 | Phase Shifter Controlling | Implemented as DSA (Gain/Atten) control via SPI. |
| 9 | Beam Steering Calculation | N/A (Single channel module, but supports table-based attenuation). |
| 10 | Gate Voltage Writing | Internal DAC generates control voltage for VGG MOSFET. |

### 9.1 Serial Communication Interface
- **Interface Type:** UART (Universal Asynchronous Receiver/Transmitter)
- **Physical Layer:** TTL Level (3.3V CMOS) connected to System Header (J3).
- **Baud Rate:** 3.0 Mbps (Default), configurable to 115200 bps.
- **Frame Format:** 1 Start bit, 8 Data bits, No Parity, 1 Stop bit (8N1).
- **Signals:**
    - `SYS_TXD` (MCU -> Host): Transmits telemetry data.
    - `SYS_RXD` (Host -> MCU): Receives commands.
- **Protocol:** ASCII-based command set (e.g., `SET_ATTEN:10;`) plus Binary mode for high-speed telemetry streaming.

### 9.2 High Speed Communication Interface
- **Status:** Not Active in Rev A hardware.
- **Reservation:** Pins PA11/PA12 are mapped to USB or high-speed GPIO for future data streaming use cases (e.g., IQ data sampling).
- **Constraint:** Ensure these pins are not configured as outputs driving low during initialization to prevent contention with potential host pull-ups.

### 9.3 Power On/Off Sequence
#### 9.3.1 Power ON/OFF Sequence
1. **Input Applied:** VIN (5V-12V) applied to Header J3.
2. **Regulator Startup:** 5.0V LDO (U7) ramps up.
3. **Logic Rail:** 3.3V LDO (U6) ramps up, powering MCU and Logic.
4. **MCU Initialization:** STM32L4 boots, initializes GPIOs to **Safe States** (PA_Enable = 0, VGG_DAC = 0V).
5. **Bias Ramp:** Firmware enables DAC channel and ramps `VGG_CTRL` to the calculated PA operating point (e.g., -0.5V) over 10ms.
6. **RF Enable:** `PA_ENABLE` signal asserted High (3.3V) to turn on Q2, enabling the HMC384.
7. **Ready:** `STAT_LED` turns solid Green.

#### 9.3.2 Mode Configuration
| Mode | Signal | Value | Description |
|:-----|:-------|:------|:-------------|
| SHUTDOWN | PA_ENABLE | 0 | RF Amp disabled, VGG pulled to GND. |
| RX_MODE | PA_ENABLE | 1 | RF Amp active (pass-through). |
| STANDBY | PA_ENABLE | 0 | MCU active but RF path disabled to save power. |

### 9.4 Supply Voltage, Current & Temperature Monitoring
#### 9.4.1 Supply Voltage and Current Monitoring
- **Method:** ADC Channels PA0 and PA1 connected to VDET_OUT (AD8318) and voltage dividers.
- **Measurement Range:** 0V to 3.3V.
- **Resolution:** 12-bit (4096 levels).
- **Update Rate:** 10 Hz via Timer interrupt.

#### 9.4.2 Temperature Monitoring
- **Sensor:** TMP102AIDRLR (Local board temp).
- **Interface:** I2C (Address 0x48).
- **Range:** -40°C to +125°C.
- **Alert Logic:** The `TEMP_ALERT` pin (Active Low) triggers MCU Interrupt (PB6) if Temp > 85°C (Threshold).
- **Response:** Immediate shutdown of PA_ENABLE if alert triggered.

### 9.5 Flash & Interfaces
#### 9.5.1 Internal Configuration Flash
- **Memory:** STM32L433 Internal Flash (256 KB).
- **Purpose:** Stores:
    - Factory Attenuation Calibration Table (DSA vs Frequency).
    - PA Bias Look-Up Table (VGG vs Temp).
    - Unique Device ID/Serial Number.
- **Access:** In-Application Programming (IAP) via UART.

#### 9.5.2 Storage Flash (External)
- **Status:** Not populated on Rev A. Firmware supports SPI Flash (25xx series) on future expansion header.

### 9.6 TRP Configuration
- **Signal:** `PA_ENABLE` (GPIO PA8).
- **Function:** Acts as the Transmit/Receive Pulse (TRP) or T/R switch control.
- **State:**
    - HIGH (3.3V): RF Path Active.
    - LOW (0V): RF Path Shutdown.
- **Timing:** Minimum pulse width 1us. Latency from command to output < 5us.

### 9.7 Remote Programming
- **Protocol:** UART Bootloader (STM32 System Bootloader or Custom DFU).
- **Tool:** STM32CubeProgrammer or Custom Python GUI.
- **Procedure:**
    1. Host sends `UPDATE_MODE` command.
    2. MCU resets into Bootloader.
    3. New firmware binary sent via XMODEM/YMODEM.
    4. MCU reboots and verifies CRC.

### 9.8 Phase Shifter Controlling (DSA Control)
- **Interface:** SPI (Clock, MOSI, CS_N).
- **Target:** HMC1119LP4E (Digital Step Attenuator).
- **Control Logic:**
    - 8-bit Serial Data packet (MSB First).
    - Latches on falling edge of CS_N.
- **Attenuation Range:** 31.75 dB in 0.25 dB steps.
- **Update Rate:** Max 10 MHz SPI clock.

### 9.9 Beam Steering Calculation
- **Status:** Not applicable (Single Element).
- **Function:** Firmware calculates required attenuation based on RSSI (Received Signal Strength Indication) from AD8318 to maintain linear output or prevent saturation.

### 9.10 Gate Voltage Writing in DAC
- **Mechanism:** Internal 12-bit DAC (DAC1 Channel 1) on pin PB1.
- **Circuit:** DAC output drives Gate of N-Channel MOSFET (Q1).
- **Transfer Function:**
    - DAC 0V -> VGG = -5V (PA Off/Min Gain).
    - DAC 1.2V -> VGG = 0V (PA Max Gain).
    - DAC 3.3V -> VGG = +2.5V (Protected region, avoid).
- **Calibration:** Firmware uses temp sensor to adjust DAC value, maintaining constant PA bias current over temperature.

---

## Annexure A — Requirement Traceability Matrix

| S.No | Requirement ID | Description | HRS Section | GLR Section |
|:-----|:---------------|:-------------|:------------|:------------|
| 1 | REQ-HW-001 | Digital Control Interface (SPI/I2C) | HRS §3.1 | 9.1, 9.8 |
| 2 | REQ-HW-002 | RF Amplifier Bias Control (Vgg) | HRS §3.1 | 9.10 |
| 3 | REQ-HW-003 | RF Power Detection & Telemetry | HRS §3.1 | 9.4.1 |
| 4 | REQ-HW-004 | GPIO / PA Enable Control | HRS §3.1 | 9.6 |
| 5 | REQ-HW-005 | Temperature Monitoring & OTP | HRS §3.1 | 9.4.2 |
| 6 | REQ-HW-006 | Power Supply Sequencing | HRS §3.1 | 9.3 |
| 7 | REQ-HW-007 | UART System Interface | HRS §3.1 | 9.1 |
| 8 | REQ-HW-008 | Remote Update Capability | HRS §3.1 | 9.7 |
| 9 | REQ-HW-009 | Digital Step Attenuator Control | HRS §3.1 | 9.8 |
| 10 | REQ-HW-010 | LED Status Indication | HRS §3.1 | 8 (Pin 22) |
| 11 | REQ-HW-011 | Protection Logic (OVP/OTP) | HRS §3.1 | 9.4.1, 9.4.2 |
| 12 | REQ-HW-012 | Physical Connector Interface | HRS §3.1 | 8 (J3 Signals) |

---
**End of Document**