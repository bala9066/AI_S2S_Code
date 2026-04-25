# Glue Logic Requirements (GLR)

## Document Control
| Document Title | Glue Logic Requirements |
| Version Date | 25.04.2026 |
| Version Number | 0V01 |
| Prepared By | Name: . Sign: |
| Document Review By | Name: . Sign: |

---

## Amendments to the Document
| S. No. | Ver. No. | Ver. Date | Changed By | Section(s) Changed | Description of Change |
| 1 | 0V01 | 25.04.2026 | - | - | Initial Version |

---

## 1. Scope of the Document
This document specifies the I/O details and functional requirements of the Field Programmable Gate Array (FPGA) for the **hv** project — an 18-40 GHz dual-channel double-IF superheterodyne radar receiver. It serves as the definitive interface specification between the Hardware Design (Netlist/P4 phase) and the FPGA HDL Design (P7 phase). The targeted audience includes the Digital Hardware Design, FPGA/RTL Engineering, and Embedded Firmware teams.

---

## 2. References

### 2.1 External
| Doc. Type | Part No. | Description |
|---|---|---|
| FPGA Datasheet | XC7K160T-1FFG676I | Xilinx Kintex-7 FPGA Family Data Sheet |
| ADC Datasheet | AD9627ABCPZ-150 | Analog Devices Dual 12-bit 150 MSPS ADC |
| LO1 PLL Datasheet | ADF4108BCPZ-RL7 | Analog Devices PLL Frequency Synthesizer |
| LO2 PLL Datasheet | LMX2487ESQ/NOPB | Texas Instruments Dual PLL Frequency Synthesizer |
| TCXO Datasheet | ASGTX-D-100.000MHZ-1 | Abracon 100 MHz TCXO Reference Oscillator |
| Buck Converter | TPS5450DDA | Texas Instruments 5.5V, 3A Buck Converter |
| 5V LDO | BD50GA3MEFJ-CE2 | ROHM 5V LDO Regulator |
| 3.3V LDO | LD1117S33TR | STMicroelectronics 3.3V LDO Regulator |
| 1.8V LDO | ADP1706AUJZ-1.8-R7 | Analog Devices 1.8V LDO Regulator |
| EEPROM | AT93C56B-SSHL-T | Microchip 2Kb SPI Serial EEPROM |
| Flash Memory | IS25LP256D | ISSI 256Mb QSPI Flash Memory |
| Temp Sensor | AD7416ARMZ | Analog Devices 10-bit Digital Temperature Sensor |

### 2.2 Internal
| Reference | Document |
|---|---|
| [HRS] | Hardware Requirements Specification (P1) |
| [SCH] | Schematic Document (P5) |
| [GRS] | General Requirements Specification |
| [GDD] | General Design Document |

---

## 3. Acronyms and Abbreviations
| Acronym | Expansion |
|---|---|
| ADC | Analog to Digital Converter |
| AGC | Automatic Gain Control |
| BPF | Band Pass Filter |
| BOM | Bill of Materials |
| CLB | Configurable Logic Block |
| DAC | Digital to Analog Converter |
| DMA | Direct Memory Access |
| DSP | Digital Signal Processing |
| EMC | Electromagnetic Compatibility |
| FF | Flip-Flop |
| FPGA | Field Programmable Gate Array |
| GND | Ground |
| HDL | Hardware Description Language |
| IBW | Instantaneous Bandwidth |
| IIP3 | Third-Order Input Intercept Point |
| IO | Input/Output |
| JTAG | Joint Test Action Group |
| LDO | Low Drop-Out |
| LNA | Low Noise Amplifier |
| LUT | Look-Up Table |
| LVDS | Low Voltage Differential Signaling |
| NF | Noise Figure |
| PCB | Printed Circuit Board |
| PLL | Phase-Locked Loop |
| RF | Radio Frequency |
| RoHS | Restriction of Hazardous Substances |
| RTL | Register Transfer Level |
| SFDR | Spurious-Free Dynamic Range |
| SPI | Serial Peripheral Interface |
| TCXO | Temperature Compensated Crystal Oscillator |
| UART | Universal Asynchronous Receiver Transmitter |
| VCC | Supply Voltage |

---

## 4. Module Overview

### RF SECTION:
The RF section consists of a dual-channel 18-40 GHz superheterodyne receiver chain. Each channel accepts RF signals via SMA connectors (J1, J2) and passes them through a GaAs Schottky diode limiter (HLM-40ABH) for +40 dBm survivability. Signals are filtered by a waveguide cavity preselector BPF (BFCN-1840+ on XM-A163-0204D) before amplification by a GaAs pHEMT LNA (PMA3-10203+). A fundamental IQ mixer (SMIQ-1844H+) driven by a shared LO1 performs the first downconversion to a 3.1 GHz IF1. After IF1 BPF filtering (LFCN-3000+) and driver amplification (CMD295C4), a second mixer/downconversion yields a 500 MHz IF2. The IF2 stage is filtered (LFCN-500+) and conditioned by an AGC VGA (ADL5330) before digitization. LO1 is synthesized by an ADF4108BCPZ-RL7 PLL and split to both channels via an EP2K1+ splitter. LO2 is synthesized by an LMX2487ESQ/NOPB dual PLL.

### DIGITAL SECTION:
The digital processing core is built around a Xilinx Kintex-7 FPGA (XC7K160T-1FFG676I). The FPGA receives digitized data from a dual-channel 12-bit 150 Msps ADC (AD9627ABCPZ-150) via LVDS interfaces. It performs phase-coherent pulse processing, digital downconversion (DDC), decimation filtering, data formatting, and outputs processed radar data over LVDS to a digital I/O connector. The FPGA also serves as the central control hub, managing SPI interfaces for LO1 PLL, LO2 PLL, ADC configuration, and VGA gain control DACs. Communication with an external host is maintained via a USB-UART bridge.

### POWER SUPPLY SECTION:
The system operates from a +15V DC input (J_PWR). A TPS5450DDA buck converter steps this down to +5.5V. Three LDO regulators derive the required analog and digital rails: a BD50GA3MEFJ-CE2 provides +5.0V for RF/MMICs, an LD1117S33TR provides +3.3V for FPGA I/O banks, TCXO, and VGA control, and an ADP1706AUJZ-1.8-R7 provides +1.8V for the ADC and FPGA auxiliary supply. The FPGA generates its own internal +1.2V core voltage (VCCINT) via an internal regulator or external point-of-load (POL) from the +3.3V rail.

---

## 5. Features
- **FPGA:** Xilinx Kintex-7 XC7K160T-1FFG676I
- **On-board clock oscillator:** 100 MHz TCXO (ASGTX-D-100.000MHZ-1), phase noise -110 dBc/Hz @ 10 kHz offset
- **High-Speed Data Acquisition:** Dual-channel 12-bit LVDS interface at 150 MSPS via AD9627ABCPZ-150
- **Communication:** UART up to 12 Mbps via USB-UART bridge (FT232H)
- **JTAG Debugging Support:** Standard 4-wire JTAG (TCK, TMS, TDI, TDO) for debug and configuration
- **Configuration Flash:** IS25LP256D 256Mb QSPI for FPGA bitstream and remote firmware updates
- **Storage EEPROM:** AT93C56B-SSHL-T 2Kb SPI for calibration and board ID storage
- **Temperature Monitoring:** AD7416ARMZ digital temperature sensor via I2C
- **Power Monitoring:** Voltage and current sense inputs for +5V, +3.3V, and +1.8V rails via onboard ADC
- **RF Control:** Independent SPI control for LO1 PLL (ADF4108), LO2 PLL (LMX2487), and VGA gain (DAC via SPI)

---

## 6. FPGA Description
The Xilinx Kintex-7 XC7K160T-1FFG676I was selected for its optimal balance of high logic density, DSP processing capability, and LVDS I/O bandwidth, meeting the strict phase-coherent processing requirements for the 500 MHz IBW dual-channel radar receiver.

| S.NO | PARAMETERS | SPECIFICATION |
|------|---|---|
| 1 | Part Number | XC7K160T-1FFG676I |
| 2 | Logic Cells | 162,240 |
| 3 | CLB Flip-Flops | 202,800 |
| 4 | Number of Gates | ~12.3M (Equivalent) |
| 5 | Maximum Distributed RAM (Kb) | 2,385 |
| 6 | Total Block RAM (Kb) | 11,700 |
| 7 | Maximum Single-Ended I/Os | 400 |
| 8 | Maximum DSP Slices | 600 |
| 9 | No of IO Bank | 11 (HP & HR Mixed) |

---

## 7. Block Diagram
*(Reference: See System Block Diagram in HRS P1 and Netlist P4 Mermaid diagrams)*
The FPGA acts as the central digital controller and processor. It interfaces with the ADC for data capture, PLL ICs for LO frequency tuning, VGA DACs for AGC, and an external host via UART.

---

## 8. Pinout Details

**Table: FPGA Pin Out Details**

| S.No | Signal Name | Pin No | Voltage Level | Direction wrt FPGA | Source | Destination | Default Condition | Voltage Standard |
|------|---|---|---|---|---|---|---|---|
| 1 | VCCINT | A8, B8, C8 | 1.0V | Power | Internal Reg | U_FPGA Core | 1.0V | VCC |
| 2 | VCCAUX | D8, E8 | 1.8V | Power | U_18_LDO | U_FPGA Aux | 1.8V | VCC |
| 3 | VCCO_33_BANK14 | F8, G8 | 3.3V | Power | U_33_LDO | U_FPGA Bank 14 | 3.3V | VCC |
| 4 | GND | A9, B9, C9 | 0V | Ground | - | Chassis | 0V | GND |
| 5 | 100MHZ_TCXO_CLK | H8 | 3.3V | Input | U_TCXO | U_FPGA | 0 (Low) | LVCMOS33 |
| 6 | TCK | J8 | 3.3V | Input | JTAG Header | U_FPGA | 0 (Low) | LVCMOS33 |
| 7 | TMS | K8 | 3.3V | Input | JTAG Header | U_FPGA | 1 (High) | LVCMOS33 |
| 8 | TDI | L8 | 3.3V | Input | JTAG Header | U_FPGA | 1 (High) | LVCMOS33 |
| 9 | TDO | M8 | 3.3V | Output | U_FPGA | JTAG Header | Z | LVCMOS33 |
| 10 | FPGA_RESET_N | N8 | 3.3V | Input | Supervisor | U_FPGA | 0 (Low) | LVCMOS33 |
| 11 | FPGA_DONE | P8 | 3.3V | Output | U_FPGA | LED / Status | 0 (Low) | LVCMOS33 |
| 12 | FPGA_INIT_N | R8 | 3.3V | Bidirectional | U_FPGA | Flash / Status | 1 (High) | LVCMOS33 |
| 13 | UART_TX | T8 | 3.3V | Output | U_FPGA | FT232H | 1 (High) | LVCMOS33 |
| 14 | UART_RX | U8 | 3.3V | Input | FT232H | U_FPGA | 1 (High) | LVCMOS33 |
| 15 | ADC_CLK_OUT_P | A10 | 1.8V | Input | ADC1 | U_FPGA | Diff | LVDS_18 |
| 16 | ADC_CLK_OUT_N | A11 | 1.8V | Input | ADC1 | U_FPGA | Diff | LVDS_18 |
| 17 | ADC_FCO_P | B10 | 1.8V | Input | ADC1 | U_FPGA | Diff | LVDS_18 |
| 18 | ADC_FCO_N | B11 | 1.8V | Input | ADC1 | U_FPGA | Diff | LVDS_18 |
| 19 | LVDS_D0A_P/N | C10/C11 | 1.8V | Input | ADC1 | U_FPGA | Diff | LVDS_18 |
| 20 | LVDS_D1A_P/N | D10/D11 | 1.8V | Input | ADC1 | U_FPGA | Diff | LVDS_18 |
| 21 | LVDS_D2A_P/N | E10/E11 | 1.8V | Input | ADC1 | U_FPGA | Diff | LVDS_18 |
| 22 | LVDS_D3A_P/N | F10/F11 | 1.8V | Input | ADC1 | U_FPGA | Diff | LVDS_18 |
| 23 | LVDS_D4A_P/N | G10/G11 | 1.8V | Input | ADC1 | U_FPGA | Diff | LVDS_18 |
| 24 | LVDS_D5A_P/N | H10/H11 | 1.8V | Input | ADC1 | U_FPGA | Diff | LVDS_18 |
| 25 | LVDS_D0B_P/N | J10/J11 | 1.8V | Input | ADC1 | U_FPGA | Diff | LVDS_18 |
| 26 | LVDS_D1B_P/N | K10/K11 | 1.8V | Input | ADC1 | U_FPGA | Diff | LVDS_18 |
| 27 | LVDS_D2B_P/N | L10/L11 | 1.8V | Input | ADC1 | U_FPGA | Diff | LVDS_18 |
| 28 | LVDS_D3B_P/N | M10/M11 | 1.8V | Input | ADC1 | U_FPGA | Diff | LVDS_18 |
| 29 | LVDS_D4B_P/N | N10/N11 | 1.8V | Input | ADC1 | U_FPGA | Diff | LVDS_18 |
| 30 | LVDS_D5B_P/N | P10/P11 | 1.8V | Input | ADC1 | U_FPGA | Diff | LVDS_18 |
| 31 | ADC_SPI_SCLK | R10 | 3.3V | Output | U_FPGA | ADC1 | 0 (Low) | LVCMOS33 |
| 32 | ADC_SPI_SDIO | T10 | 3.3V | Bidirectional | U_FPGA | ADC1 | Z | LVCMOS33 |
| 33 | ADC_SPI_CSB | U10 | 3.3V | Output | U_FPGA | ADC1 | 1 (High) | LVCMOS33 |
| 34 | ADC_PDWN | V10 | 3.3V | Output | U_FPGA | ADC1 | 1 (High) | LVCMOS33 |
| 35 | ADC_OE | V11 | 3.3V | Output | U_FPGA | ADC1 | 1 (High) | LVCMOS33 |
| 36 | LO1PLL_SPI_CLK | W10 | 3.3V | Output | U_FPGA | U_LO1PLL | 0 (Low) | LVCMOS33 |
| 37 | LO1PLL_SPI_DATA | W11 | 3.3V | Output | U_FPGA | U_LO1PLL | 0 (Low) | LVCMOS33 |
| 38 | LO1PLL_SPI_LE | Y10 | 3.3V | Output | U_FPGA | U_LO1PLL | 1 (High) | LVCMOS33 |
| 39 | LO2PLL_SPI_CLK | Y11 | 3.3V | Output | U_FPGA | U_LO2PLL | 0 (Low) | LVCMOS33 |
| 40 | LO2PLL_SPI_DATA | AA10 | 3.3V | Output | U_FPGA | U_LO2PLL | 0 (Low) | LVCMOS33 |
| 41 | LO2PLL_SPI_CS | AA11 | 3.3V | Output | U_FPGA | U_LO2PLL | 1 (High) | LVCMOS33 |
| 42 | FLASH_SPI_CLK | AB10 | 3.3V | Output | U_FPGA | U_FLASH | 0 (Low) | LVCMOS33 |
| 43 | FLASH_SPI_MOSI | AB11 | 3.3V | Output | U_FPGA | U_FLASH | 0 (Low) | LVCMOS33 |
| 44 | FLASH_SPI_MISO | AC10 | 3.3V | Input | U_FLASH | U_FPGA | Z | LVCMOS33 |
| 45 | FLASH_SPI_CS_N | AC11 | 3.3V | Output | U_FPGA | U_FLASH | 1 (High) | LVCMOS33 |
| 46 | EEPROM_SPI_CLK | AD10 | 3.3V | Output | U_FPGA | U_EEPROM | 0 (Low) | LVCMOS33 |
| 47 | EEPROM_SPI_MOSI | AD11 | 3.3V | Output | U_FPGA | U_EEPROM | 0 (Low) | LVCMOS33 |
| 48 | EEPROM_SPI_MISO | AE10 | 3.3V | Input | U_EEPROM | U_FPGA | Z | LVCMOS33 |
| 49 | EEPROM_SPI_CS_N | AE11 | 3.3V | Output | U_FPGA | U_EEPROM | 1 (High) | LVCMOS33 |
| 50 | I2C_SCL | AF10 | 3.3V | Output (OD) | U_FPGA | Temp Sensor | 1 (High) | LVCMOS33 |
| 51 | I2C_SDA | AF11 | 3.3V | Bidirectional (OD)| U_FPGA | Temp / Pwr Mon | 1 (High) | LVCMOS33 |
| 52 | FPGA_VGA_GAIN_A | AF12 | 3.3V | Output | U_FPGA | VGA1 (ADL5330) | 0 (Mid) | LVCMOS33 |
| 53 | FPGA_VGA_GAIN_B | AF13 | 3.3V | Output | U_FPGA | VGA2 (ADL5330) | 0 (Mid) | LVCMOS33 |
| 54 | TRP_CTRL | AF14 | 3.3V | Output | U_FPGA | LO/RF Enable | 0 (Off) | LVCMOS33 |

---

## 9. Functional Specifications

| S.No. | Function Name | Description |
|-------|---|---|
| 1 | Serial Communication Interface | UART between Host PC & FPGA via FT232H USB-UART bridge |
| 2 | High Speed Data Acquisition | Dual 12-bit LVDS data capture at 150 MSPS from AD9627 |
| 3 | Power Supply Sequencing & Health Status | Controlled sequencing of +5V, +3.3V, +1.8V, +1.2V and monitoring health |
| 4 | Supply Voltage, Current & Temperature Monitoring | I2C-based monitoring of rails and ambient temperature |
| 5 | Flash Interfaces | Configuration Flash (IS25LP256D) and EEPROM (AT93C56B) via SPI |
| 6 | TRP Configuration | Transmit/Receive Pulse signal for Radar mode ON/OFF control |
| 7 | FPGA Remote Programming | Configuration loading via UART into QSPI Flash |
| 8 | LO1/LO2 PLL Frequency Tuning | Independent SPI control of RF and IF local oscillators |
| 9 | VGA Gain Control (AGC) | Variable Gain Amplifier control for automatic gain leveling |
| 10 | Radar Pulse Processing | DDC, Decimation, Phase-Coherent processing of dual-channel data |

### 9.1 Serial Communication Interface
- **Interface type:** UART (Universal Asynchronous Receiver Transmitter)
- **Physical layer:** USB to RS232 / UART via FT232H
- **Baud rate:** 115200 bps (Default), up to 3 Mbps configurable
- **Frame format:** 1 start bit, 8 data bits, 1 stop bit, no parity
- **USB-UART converter IC:** FT232H
- **Signals:** UART_TX (FPGA → Host), UART_RX (Host → FPGA)
- **Protocol:** Custom register-based command/response (See Section 11)

### 9.2 High Speed Data Acquisition
- **Interface:** LVDS (Low Voltage Differential Signaling)
- **Source IC:** AD9627ABCPZ-150 (Dual 12-bit, 150 Msps ADC)
- **Number of channels:** 2 (Channel A and Channel B)
- **Data bus width:** 12 bits per channel, mapped to 6 LVDS pairs per channel (Double Data Rate, DDR)
- **Clock:** LVDS frame clock (FCO) and bit clock (DCO) sourced from ADC
- **Maximum Data Rate:** 150 MHz word rate, 750 MHz LVDS bit rate (DDR)
- **Digital Output Format:** Offset Binary / Two's Complement (configurable via ADC SPI)

### 9.3 Power On/Off Sequence

#### 9.3.1 Power ON/OFF Sequence
1. +15V DC applied to J_PWR.
2. Buck converter (TPS5450DDA) generates intermediate +5.5V rail.
3. LDOs active: +5.0V (RF), +3.3V (FPGA I/O, TCXO), +1.8V (ADC, FPGA Aux).
4. FPGA core regulator initializes +1.2V (VCCINT). `FPGA_RESET_N` deasserts.
5. FPGA loads bitstream from IS25LP256D. `FPGA_DONE` asserts.
6. FPGA initializes ADC, PLLs, and outputs fixed VGA gain. `TRP_CTRL` = 0.
7. Host commands `TRP_CTRL` = 1, enabling active radar reception and PLL RF outputs.

#### 9.3.2 Mode Configuration
| Mode | Signal | Value | Description |
|------|---|---|---|
| Standby | TRP_CTRL | 1'b0 | LO outputs disabled, ADC sleeping, VGAs at minimum gain |
| Active Rx | TRP_CTRL | 1'b1 | Full active radar receiving mode, PLLs locked, AGC enabled |
| Programming | FPGA_INIT_N | 1'b0 | FPGA remote programming mode via UART |

### 9.4 Supply Voltage, Current & Temperature Monitoring

#### 9.4.1 Supply Voltage and Current Monitoring
- **Implementation:** FPGA embedded logic with external passives / multiplexed ADC
- **Monitored Rails:** +5.0V, +3.3V, +1.8V, +1.2V
- **Accuracy:** ±2% measurement accuracy
- **Fault Thresholds:** Under-voltage lockout (UVLO) at 90% of nominal; Over-voltage (OV) at 110% of nominal.

#### 9.4.2 Temperature Monitoring
- **IC Part Number:** AD7416ARMZ
- **Interface:** I2C (Address: 0x48)
- **Temperature Range:** -55°C to +125°C
- **Resolution:** 0.25°C (10-bit ADC)
- **Alert Threshold:** Programmable OTI (Over-Temperature Interrupt) default +85°C.

### 9.5 Flash & Interfaces

#### 9.5.1 Configuration Flash
- **Part Number:** IS25LP256D
- **Interface:** Standard SPI (1-bit mode used for configuration, 4-bit QSPI reserved for future)
- **Capacity:** 256 Mbit (32 MB)
- **Purpose:** Primary storage for the Kintex-7 FPGA configuration bitstream.

#### 9.5.2 Storage Flash (User Flash)
*Note: Configuration flash reserves upper sectors for user data.*
- **Purpose:** Stores radar calibration tables, gain/phase compensation, and board serial number.
- **Alternative EEPROM:** AT93C56B-SSHL-T (2 Kb) used exclusively for critical startup parameters and hardware ID (I2C/SPI).

### 9.6 TRP Configuration
- **Signal:** TRP_CTRL
- **Direction:** FPGA → RF Front End (Enable logic)
- **Logic Level:** 3.3V LVCMOS
- **Active State:** HIGH = Active Receive Mode
- **Timing:** < 1 µs switching time required to meet radar PRI requirements.
- **Control:** Mapped directly to System Control Register (Bit 2).

### 9.7 FPGA Remote Programming
- **Protocol:** UART at 115200 bps.
- **Tool:** Host PC GUI Application / Xilinx iMPACT via JTAG secondary.
- **Procedure:**
  1. Host sends "Enter Programming Mode" UART command.
  2. FPGA asserts `FPGA_INIT_N` low, holding itself in reset / pausing logic.
  3. Bitstream data block is transmitted over UART.
  4. FPGA writes data to IS25LP256D via SPI.
  5. Host sends "Reboot" command; FPGA toggles `FPGA_RESET_N` via system supervisor or pulses `FPGA_INIT_N`. FPGA reconfigures from updated flash.

### 9.8 LO1 / LO2 PLL Frequency Tuning
- **LO1 (RF Downconverter):** ADF4108BCPZ-RL7
  - **Interface:** 3-wire SPI (LO1PLL_SPI_CLK, LO1PLL_SPI_DATA, LO1PLL_SPI_LE)
  - **Reference Clock:** 100 MHz TCXO
  - **Output:** 18-40 GHz (via external VCO/multiplier)
- **LO2 (IF Downconverter):** LMX2487ESQ/NOPB
  - **Interface:** 3-wire SPI (LO2PLL_SPI_CLK, LO2PLL_SPI_DATA, LO2PLL_SPI_CS)
  - **Reference Clock:** 100 MHz TCXO
- **Control Mechanism:** Host calculates N, R, and Prescaler values based on desired RF frequency. Values are written sequentially to PLL registers via FPGA SPI Masters.

### 9.9 VGA Gain Control (AGC)
- **Target Component:** ADL5330 (VGA 1 & 2)
- **Control Method:** Analog control voltage generated by FPGA-driven DAC or direct PWM filtered output. (Assuming direct PWM/DAC via `FPGA_VGA_GAIN_A` and `FPGA_VGA_GAIN_B`).
- **Resolution:** 8-bit (0 to 255 steps mapping to full gain range)
- **Update Rate:** 1 kHz (continuous AGC adjustment loop)
- **Control Loop:** FPGA calculates RSSI from ADC data, adjusts VGA_GAIN registers to maintain optimal ADC input levels.

### 9.10 Radar Pulse Processing
- **DDC (Digital Downconverter):** Translates the 500 MHz IF2 band to baseband.
- **Decimation:** Decimation filter (CIC + FIR) reduces 150 MSPS sample rate to an effective output rate matched to the 500 MHz IBW real or complex baseband.
- **Phase Coherence:** Shared 100 MHz reference clock ensures phase coherence between CH1 and CH2.
- **Packetization:** Processed data is formatted into custom radar data packets (Header, Timestamp, CH1 I/Q, CH2 I/Q) and transmitted over LVDS output connector (J_DIG).

---

## 10. Software Register Address Map

### 10.1 Register Base Addresses

| Block Name | Base Address | Address Range | Description |
|---|---|---|---|
| System / Identification | 0x0000 | 0x0000–0x00FF | Board ID, firmware version, system status/control |
| UART Control | 0x0100 | 0x0100–0x01FF | Baud rate, FIFO control, status flags |
| SPI Control | 0x0200 | 0x0200–0x02FF | SPI masters, chip-select mappings |
| I2C Control | 0x0300 | 0x0300–0x03FF | I2C master for temperature / power |
| GPIO | 0x0400 | 0x0400–0x04FF | General purpose I/O, TRP, LEDs |
| PLL Control | 0x0500 | 0x0500–0x05FF | LO1 & LO2 PLL N/R dividers, lock status |
| Temperature Monitor | 0x0600 | 0x0600–0x06FF | AD7416 readings, alert thresholds |
| Power Monitor | 0x0700 | 0x0700–0x07FF | Voltage/current ADC readings per rail |
| RF Control | 0x0800 | 0x0800–0x08FF | VGA Gain (AGC), TRP, ADC PDWN/OE |
| Flash / EEPROM | 0x0900 | 0x0900–0x09FF | Flash address, data, command register |
| Diagnostics | 0x0A00 | 0x0A00–0x0AFF | Fault log, uptime counter, loopback |

### 10.2 Detailed Register Map

**Block 0x0000 — System / Identification**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|---|---|---|---|---|
| 0x00 | BOARD_ID | 16 | R | 0x0211 | Board identification code (0x02=Radar, 0x11=Rev1.1) |
| 0x01 | FW_VERSION_MAJOR | 16 | R | 0x0001 | Firmware major version |
| 0x02 | FW_VERSION_MINOR | 16 | R | 0x0000 | Firmware minor version |
| 0x03 | SYS_STATUS | 16 | R | 0x0000 | [7] PLL1_LOCK, [6] PLL2_LOCK, [5] TEMP_ALERT, [4] VOLT_FAULT, [0] FPGA_DONE |
| 0x04 | SYS_CTRL | 16 | R/W | 0x0000 | [0] SOFT_RESET, [1] WDT_ENABLE, [2] TRP_CTRL, [3] RF_ENABLE |

**Block 0x0100 — UART Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|---|---|---|---|---|
| 0x00 | BAUD_DIV | 16 | R/W | 0x0012 | Baud rate divisor = CLK / (16 × BAUD) |
| 0x01 | UART_CTRL | 16 | R/W | 0x0001 | [0] UART_ENABLE, [1] LOOPBACK_EN |
| 0x02 | UART_STATUS | 16 | R | 0x0000 | [0] TX_BUSY, [1] RX_AVAIL, [2] RX_OVERRUN, [3] FRAME_ERR |
| 0x03 | TX_FIFO_COUNT | 16 | R | 0x0000 | Number of bytes in TX FIFO |
| 0x04 | RX_FIFO_COUNT | 16 | R | 0x0000 | Number of bytes in RX FIFO |

**Block 0x0200 — SPI Control (ADC, LO1, LO2, Flash, EEPROM)**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|---|---|---|---|---|
| 0x00 | SPI_CTRL | 16 | R/W | 0x0000 | [1:0] SPI_TARGET (0=ADC, 1=LO1, 2=LO2, 3=Flash), [2] SPI_START |
| 0x01 | SPI_WR_DATA | 16 | R/W | 0x0000 | Data payload to transmit |
| 0x02 | SPI_RD_DATA | 16 | R | 0x0000 | Data payload received |
| 0x03 | SPI_STATUS | 16 | R | 0x0001 | [0] SPI_READY, [1] SPI_ACTIVE, [2] SPI_ERROR |

**Block 0x0300 — I2C Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|---|---|---|---|---|
| 0x00 | I2C_CTRL | 16 | R/W | 0x0000 | [0] I2C_START, [1] I2C_RW (0=W, 1=R) |
| 0x01 | I2C_DEV_ADDR | 16 | R/W | 0x0048 | Target device address (Default 0x48 for AD7416) |
| 0x02 | I2C_REG_ADDR | 16 | R/W | 0x0000 | Register address within target device |
| 0x03 | I2C_WR_DATA | 16 | R/W | 0x0000 | I2C write data |
| 0x04 | I2C_RD_DATA | 16 | R | 0x0000 | I2C read data |
| 0x05 | I2C_STATUS | 16 | R | 0x0001 | [0] I2C_READY, [1] I2C_BUSY, [2] I2C_ACK_ERR |

**Block 0x0400 — GPIO**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|---|---|---|---|---|
| 0x00 | GPIO_OUTPUT | 16 | R/W | 0x0000 | [0] LED_STATUS, [1] LOOPBACK_OE |
| 0x01 | GPIO_INPUT | 16 | R | 0x0000 | [0] FPGA_INIT_N, [1] FPGA_DONE |

**Block 0x0500 — PLL Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|---|---|---|---|---|
| 0x00 | LO1_N_DIV | 16 | R/W | 0x00C8 | LO1 Feedback N divider (integer) |
| 0x01 | LO1_R_DIV | 16 | R/W | 0x0001 | LO1 Reference R divider |
| 0x02 | LO1_CTRL | 16 | R/W | 0x0000 | [0] LO1_ENABLE, [1] LO1_RESET, [2] LO1_CP_POL |
| 0x03 | LO1_STATUS | 16 | R | 0x0000 | [0] LO1_LOCKED, [1] LO1_ERROR |
| 0x04 | LO2_N_DIV | 16 | R/W | 0x0004 | LO2 Feedback N divider |
| 0x05 | LO2_R_DIV | 16 | R/W | 0x0001 | LO2 Reference R divider |
| 0x06 | LO2_CTRL | 16 | R/W | 0x0000 | [0] LO2_ENABLE, [1] LO2_RESET |
| 0x07 | LO2_STATUS | 16 | R | 0x0000 | [0] LO2_LOCKED, [1] LO2_ERROR |

**Block 0x0600 — Temperature Monitor**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|---|---|---|---|---|
| 0x00 | TEMP_VALUE | 16 | R | 0x0000 | [9:0] 10-bit temperature reading (0.25°C/LSB) |
| 0x01 | TEMP_ALERT_THR | 16 | R/W | 0x0154 | OTI threshold (default +85°C) |
| 0x02 | TEMP_HYST_THR | 16 | R/W | 0x014A | OTI hysteresis (default +75°C) |
| 0x03 | TEMP_STATUS | 16 | R | 0x0000 | [0] ALERT_ACTIVE |

**Block 0x0700 — Power Monitor**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|---|---|---|---|---|
| 0x00 | VOLTAGE_5V0 | 16 | R | 0x0000 | Scaled 12-bit ADC reading for +5.0V rail |
| 0x01 | VOLTAGE_3V3 | 16 | R | 0x0000 | Scaled 12-bit ADC reading for +3.3V rail |
| 0x02 | VOLTAGE_1V8 | 16 | R | 0x0000 | Scaled 12-bit ADC reading for +1.8V rail |
| 0x03 | VOLTAGE_1V2 | 16 | R | 0x0000 | Scaled 12-bit ADC reading for +1.2V core rail |
| 0x04 | PWR_STATUS | 16 | R | 0x0000 | [0] V5_FAULT, [1] V3_FAULT, [2] V1_FAULT |

**Block 0x0800 — RF Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|---|---|---|---|---|
| 0x00 | VGA_GAIN_A | 16 | R/W | 0x0080 | [7:0] 8-bit VGA gain setting for CH1 |
| 0x01 | VGA_GAIN_B | 16 | R/W | 0x0080 | [7:0] 8-bit VGA gain setting for CH2 |
| 0x02 | ADC_CTRL | 16 | R/W | 0x0003 | [0] ADC_PDWN, [1] ADC_OE |
| 0x03 | RF_STATUS | 16 | R | 0x0000 | [0] RSSI_CH1_OVFL, [1] RSSI_CH2_OVFL |

**Block 0x0900 — Flash / EEPROM**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|---|---|---|---|---|
| 0x00 | FLASH_ADDR | 16 | R/W | 0x0000 | Target memory address |
| 0x01 | FLASH_WR_DATA | 16 | R/W | 0x0000 | Data to write |
| 0x02 | FLASH_RD_DATA | 16 | R | 0x0000 | Data read back |
| 0x03 | FLASH_CTRL | 16 | R/W | 0x0000 | [0] FLASH_RDWR (0=R, 1=W), [1] FLASH_ERASE, [2] FLASH_INITIATE |
| 0x04 | FLASH_STATUS | 16 | R | 0x0001 | [0] FLASH_BUSY, [1] FLASH_ERROR |

**Block 0x0A00 — Diagnostics**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|---|---|---|---|---|
| 0x00 | UPTIME_COUNTER | 16 | R | 0x0000 | LSB of system uptime (1ms ticks) |
| 0x01 | DIAG_CTRL | 16 | R/W | 0x0000 | [0] LOOPBACK_ENABLE |
| 0x02 | FAULT_LOG | 16 | R | 0x0000 | Latched fault flags |

### 10.3 Register Access Rules
- All registers are 16-bit wide; accessed via UART Single/Bulk Read/Write protocol (Section 11).
- **Read:** Set bit15 of address (address OR 0x8000).
- **Write:** Address as-is.
- **Shadow registers:** PLL_N_DIV and PLL_R_DIV are double-buffered; sequence requires writing dividers, followed by toggling LOx_CTRL[0] (Enable -> Disable -> Enable) to latch values.
- **Atomic access:** Bulk Write used for multi-register atomic updates (e.g., LO1_N_DIV, LO1_R_DIV, LO1_CTRL simultaneously).

---

## 11. UART Register Protocol Specification

### 11.1 Physical Layer
- **Baud rate:** 115200 bps (configurable via UART_CTRL.BAUD_DIV)
- **Frame format:** 1 start bit, 8 data bits, 1 stop bit, no parity (8N1)
- **Physical interface:** RS-232 via FT232H USB Bridge
- **Signal levels:** 3.3V LVTTL logic on PCB, USB on host side.

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
  - Address out of valid range (e.g., unmapped space)
  - Write to read-only register
  - Parser timeout (inter-byte gap > 50ms)
```

### 11.3 Protocol Timing Constraints
| Parameter | Min | Typical | Max | Unit |
|---|---|---|---|---|
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

| Resource | Available (XC7K160T) | Estimated Usage | Utilization % |
|---|---|---|---|
| Slice LUTs | 202,800 | 38,500 | 19% |
| Slice Flip-Flops | 202,800 | 25,000 | 12% |
| Block RAM (36Kb) | 325 | 55 | 17% |
| DSP Slices | 600 | 160 | 27% |
| MMCM/PLL | 10 | 2 | 20% |
| I/O Buffers | 400 | 65 | 16% |

- **Synthesis tool:** Vivado 2023.2
- **Target device:** XC7K160T-1FFG676I
- **Timing constraint:** Primary 150 MHz LVDS clock constraint, 100 MHz TCXO clock constraint.
- **Estimation Justification:** High DSP usage (27%) driven by dual-channel DDC (CIC/FIR decimation filters) and AGC RSSI math. LUT/FF estimates include UART protocol, SPI/I2C masters, PLL control logic, and LVDS deserialization.

---

## Annexure A — Requirement Traceability Matrix

| S.No. | GLR-ID | Description | Source HRS Section | GLR Section | Verification Method | Status |
|-------|---|---|---|---|---|---|
| 1 | GLR-001 | Serial Communication Interface (UART) | REQ-HW-014 | 9.1 | Test | Open |
| 2 | GLR-002 | High Speed LVDS Data Acquisition | REQ-HW-012 | 9.2 | Test | Open |
| 3 | GLR-003 | Power Supply Sequencing & Control | System Specs | 9.3 | Test | Open |
| 4 | GLR-004 | Voltage, Current & Temperature Monitoring | REQ-HW-017 | 9.4 | Test | Open |
| 5 | GLR-005 | Flash & EEPROM Interfaces | REQ-HW-014 | 9.5 | Test | Open |
| 6 | GLR-006 | TRP Configuration (T/R Switching <1µs) | REQ-HW-021 | 9.6 | Inspection | Open |
| 7 | GLR-007 | FPGA Remote Programming | REQ-HW-014 | 9.7 | Demonstration | Open |
| 8 | GLR-008 | LO1/LO2 PLL Tuning (Phase Noise -110 dBc/Hz) | REQ-HW-013 | 9.8 | Test | Open |
| 9 | GLR-009 | VGA Gain Control / AGC | REQ-HW-004, REQ-HW-003 | 9.9 | Test | Open |
| 10 | GLR-010 | Radar Pulse Processing (Phase Coherent) | REQ-HW-015, REQ-HW-016 | 9.10 | Demonstration | Open |
| 11 | GLR-011 | Register Address Map Specification | REQ-HW-014 | 10 | Inspection | Open |
| 12 | GLR-012 | UART Protocol Specification | REQ-HW-014 | 11 | Test | Open |
| 13 | GLR-013 | FPGA Resource Budget | REQ-HW-014 | 12 | Analysis | Open |