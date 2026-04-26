# Glue Logic Requirements (GLR)

## Document Control
| Document Title | Glue Logic Requirements |
| Version Date | 26.04.2026 |
| Version Number | 0V01 |
| Prepared By | Name: . Sign: |
| Document Review By | Name: . Sign: |

---

## Amendments to the Document
| S. No. | Ver. No. | Ver. Date | Changed By | Section(s) Changed | Description of Change |
| 1 | 0V01 | 26.04.2026 | - | - | Initial Version |

---

## 1. Scope of the Document
This document specifies the I/O details and functional requirements of the FPGA for the **rx band** project (4-Channel 18-40 GHz Double-IF Superheterodyne Radar Receiver System). It bridges the Netlist (P4) and FPGA HDL Design (P7) phases, providing precise pin mappings, functional specifications, and firmware-level register mapping to guide Hardware Design and Firmware development teams.

---

## 2. References

### 2.1 External
| Doc. Type | Part No. | Description |
|---|---|---|
| FPGA Datasheet | XC7K355T-1FFG901I | Xilinx Kintex-7 FPGA Data Sheet |
| ADC Datasheet | LTC2107IUK PBF | 16-Bit 210Msps ADC Datasheet |
| LO1 Synthesizer | LMX2820RTCT | Texas Instruments 22.6 GHz Wideband RF Synthesizer |
| LO2 Synthesizer | ADF4383BCCZ | Analog Devices High Performance Microwave PLL |
| OCXO | KOVTL10MDBFBCB | 10MHz Oven Controlled Crystal Oscillator |
| VGA | TGL2767-SMEVB | Qorvo Variable Gain Amplifier |
| LO1 Mixer | CMD180C3 | Qorvo 18-32 GHz Double Balanced Mixer |
| LO2 IQ Mixer | MMIQ-0205HSM-2 | Marki Microwave 1.75-5.0 GHz IQ Mixer |
| Limiter | VLM-63A-S+ | Mini-Circuits RF Limiter |
| LNA | ZVA-183WA-S+ | Mini-Circuits Wideband RF Amplifier |
| 5V LDO | LM2940S-5.0/NOPB | Texas Instruments 5V LDO Regulator |
| 3.3V LDO | LT1962EMS8-3.3 PBF | Analog Devices 3.3V LDO Regulator |
| 1.8V LDO | LT1962EMS8-1.8 PBF | Analog Devices 1.8V LDO Regulator |
| 1.0V Buck | TPS54620RGWR | Texas Instruments 1.0V Buck Regulator |
| Buffer Amp | GVA-63+ | Mini-Circuits Gain Block Amplifier |

### 2.2 Internal
| Reference | Document |
|---|---|
| [HRS] | Hardware Requirements Specification |
| [SCH] | Schematic Diagram |
| [GRS] | General Requirements Specification |
| [GDD] | General Design Document |

---

## 3. Acronyms and Abbreviations
| Acronym | Expansion |
|---|---|
| FPGA | Field Programmable Gate Array |
| UART | Universal Asynchronous Receiver Transmitter |
| SPI | Serial Peripheral Interface |
| I2C | Inter-Integrated Circuit |
| GPIO | General Purpose Input Output |
| JTAG | Joint Test Action Group |
| CLB | Configurable Logic Block |
| DSP | Digital Signal Processing |
| LUT | Look-Up Table |
| FF | Flip-Flop |
| IO | Input/Output |
| PCB | Printed Circuit Board |
| BOM | Bill of Materials |
| RoHS | Restriction of Hazardous Substances |
| EMC | Electromagnetic Compatibility |
| ADC | Analog-to-Digital Converter |
| DAC | Digital-to-Analog Converter |
| DMA | Direct Memory Access |
| RTL | Register Transfer Level |
| HDL | Hardware Description Language |
| VHDL | VHSIC Hardware Description Language |
| VCC | Positive Supply Voltage |
| GND | Ground |
| LVDS | Low Voltage Differential Signaling |
| PLL | Phase-Locked Loop |
| VCO | Voltage Controlled Oscillator |
| LNA | Low Noise Amplifier |
| VGA | Variable Gain Amplifier |
| AGC | Automatic Gain Control |
| IF | Intermediate Frequency |
| LO | Local Oscillator |
| NF | Noise Figure |
| IIP3 | Input Third-Order Intercept Point |
| SFDR | Spurious-Free Dynamic Range |
| OCXO | Oven Controlled Crystal Oscillator |
| DDC | Digital Downconverter |
| YIG | Yttrium Iron Garnet |

---

## 4. Module Overview

### RF SECTION:
The receiver implements a 4-channel 18-40 GHz double-IF superheterodyne architecture. Each channel accepts an RF input via a 2.92mm-K SMA connector (J1) and routes it through an RF limiter (VLM-63A-S+) providing +20 dBm survivability. A tunable YIG preselector (18-40 GHz) filters the input before a bias tee (ZFBT-4R2GW+) feeds a GaN-based LNA (ZVA-183WA-S+). The first downconversion uses a CMD180C3 double-balanced mixer driven by an LMX2820 PLL synthesizer via a GVA-63+ buffer amplifier, converting RF to IF1 at 4 GHz. The second downconversion uses an MMIQ-0205HSM-2 IQ mixer driven by an ADF4383 PLL via a GVA-63+ buffer, converting IF1 to IF2 at 500 MHz. Final gain control is achieved via a TGL2767-SME VGA before digitisation.

### DIGITAL SECTION:
The Xilinx Kintex-7 FPGA (XC7K355T-1FFG901I) performs all digital signal processing and system control functions. It interfaces with four LTC2107 16-bit 210 Msps ADCs via high-speed LVDS links, performing digital downconversion (DDC), pulse compression, and coherent processing across all 4 channels. The FPGA also manages LO1/LMX2820 and LO2/ADF4383 PLL synthesizers via dedicated SPI buses, controls VGA gain via a serial DAC output, drives YIG bias tuning, and communicates with the host system via a high-speed data link through the 60-pin Samtec data connector.

### POWER SUPPLY SECTION:
The system operates from a single +15V input via a power connector (CON-POWER-2) through a common-mode choke. Power distribution includes: +5V_RF rail (LM2940S-5.0 LDO) powering the LNA, IF gain blocks, buffer amplifiers, and reference buffers; +3V3_DIG rail (LT1962EMS8-3.3 LDO) powering FPGA I/O, ADC I/O, and PLL synthesizers; +1V8 rail (LT1962EMS8-1.8 LDO) powering ADC core and FPGA auxiliary; +1V0_CORE rail (TPS54620RGWR buck converter) powering the FPGA core with a 10µH inductor (XAL5050-103ME). The 10 MHz OCXO (KOVTL10MDBFBCB) is powered directly from the filtered 15V supply through a current-limiting resistor.

---

## 5. Features
- FPGA: Xilinx Kintex-7 XC7K355T-1FFG901I in FFG901 package, industrial grade
- On-board clock oscillator: 10 MHz OCXO (KOVTL10MDBFBCB) providing ultra-low phase noise reference
- High-Speed ADC Interface: 4x LTC2107 16-bit 210 Msps ADCs with LVDS data interface
- PLL Control Interface: Dedicated SPI buses for LO1 (LMX2820) and LO2 (ADF4383) synthesizers
- JTAG debugging support: 10-pin 2x5 header (J6) for FPGA configuration and debug
- LO1 Debug Header: 10-pin 2x5 header (J4) for LO1 SPI/JTAG access
- LO2 Debug Header: 6-pin 2x3 header (J5) for LO2 SPI access
- AGC Control: Serial DAC output via FPGA for VGA gain adjustment
- YIG Preselector Bias: Bias tee control signal for YIG tuning
- Data Output: 60-pin Samtec LSHM connector for high-speed data transfer
- ADC Power-Down Control: FPGA-controlled ADC power-down for power management
- Signal Monitoring: ADC overflow detection via dedicated input
- Reference Distribution: Dual 10 MHz reference buffers (GVA-63+) for LO1 and LO2 PLLs

---

## 6. FPGA Description
The Xilinx Kintex-7 XC7K355T was selected for its optimal balance of high-performance DSP slices (required for 4-channel DDC and pulse compression), abundant block RAM (for FIFOs and coefficient storage), and high-speed I/O capability (for LVDS ADC interfaces). The industrial-grade -1FFG901I package ensures operation across the full -55°C to 125°C military temperature range.

| S.NO | PARAMETERS | SPECIFICATION |
|------|-----------|---------------|
| 1 | Part Number | XC7K355T-1FFG901I |
| 2 | Logic Cells | 328,320 |
| 3 | CLB Flip-Flops | 407,520 |
| 4 | Number of Gates | ~5,000,000 (equivalent) |
| 5 | Maximum Distributed RAM (Kb) | 4,300 |
| 6 | Total Block RAM (Kb) | 18,144 |
| 7 | Maximum Single-Ended I/Os | 500 |
| 8 | Maximum DSP Slices | 840 |
| 9 | No of IO Bank | 14 |

---

## 7. Block Diagram
(Refer to the System Block Diagram in the HRS document. The FPGA serves as the central digital processing and control element, interfacing with ADCs, PLLs, VGA, YIG bias, and the external host via the Samtec data connector.)

---

## 8. Pinout Details

**Table: FPGA Pin Out Details**

| S.No | Signal Name | Pin No | Voltage Level | Direction wrt FPGA | Source | Destination | Default Condition | Voltage Standard |
|------|-------------|--------|---------------|--------------------|--------|-------------|-------------------|------------------|
| 1 | VCC_1V0_CORE | A5, A6, A7, A8, A9, A10, A11 | 1.0V | Power | U16 (TPS54620) | U11 FPGA Core | Always ON | VCC |
| 2 | GND | A1, A2, A3, A4, A12, A13 | 0V | Ground | GND_STAR | U11 FPGA GND | Always ON | GND |
| 3 | VCCO_BANK12_1V8 | B1, B2 | 1.8V | Power | U15 (LT1962-1.8) | FPGA Bank 12 | Always ON | VCC |
| 4 | VCCO_BANK13_3V3 | C1, C2 | 3.3V | Power | U14 (LT1962-3.3) | FPGA Bank 13 | Always ON | VCC |
| 5 | LVDS_D0 | D1 | 1.8V | Input | U10 (ADC) | U11 FPGA | Pull-Down | LVDS_1V8 |
| 6 | LVDS_D0_N | D2 | 1.8V | Input | U10 (ADC) | U11 FPGA | Pull-Down | LVDS_1V8 |
| 7 | LVDS_D1 | D3 | 1.8V | Input | U10 (ADC) | U11 FPGA | Pull-Down | LVDS_1V8 |
| 8 | LVDS_D1_N | D4 | 1.8V | Input | U10 (ADC) | U11 FPGA | Pull-Down | LVDS_1V8 |
| 9 | LVDS_CLK_P | E1 | 1.8V | Input | U10 (ADC) | U11 FPGA | Pull-Down | LVDS_1V8 |
| 10 | LVDS_CLK_N | E2 | 1.8V | Input | U10 (ADC) | U11 FPGA | Pull-Down | LVDS_1V8 |
| 11 | ADC_OVR | E3 | 3.3V | Input | U10 (ADC) | U11 FPGA | Pull-Down | LVCMOS33 |
| 12 | ADC_PD | E4 | 3.3V | Output | U11 FPGA | U10 (ADC) | HIGH (PD ON) | LVCMOS33 |
| 13 | LVDS_D2 | F1 | 1.8V | Input | U10 (ADC) | U11 FPGA | Pull-Down | LVDS_1V8 |
| 14 | LVDS_D2_N | F2 | 1.8V | Input | U10 (ADC) | U11 FPGA | Pull-Down | LVDS_1V8 |
| 15 | LVDS_D3 | F3 | 1.8V | Input | U10 (ADC) | U11 FPGA | Pull-Down | LVDS_1V8 |
| 16 | LVDS_D3_N | F4 | 1.8V | Input | U10 (ADC) | U11 FPGA | Pull-Down | LVDS_1V8 |
| 17 | LVDS_D4 | G1 | 1.8V | Input | U10 (ADC) | U11 FPGA | Pull-Down | LVDS_1V8 |
| 18 | LVDS_D4_N | G2 | 1.8V | Input | U10 (ADC) | U11 FPGA | Pull-Down | LVDS_1V8 |
| 19 | LVDS_D5 | G3 | 1.8V | Input | U10 (ADC) | U11 FPGA | Pull-Down | LVDS_1V8 |
| 20 | LVDS_D5_N | G4 | 1.8V | Input | U10 (ADC) | U11 FPGA | Pull-Down | LVDS_1V8 |
| 21 | LVDS_D6 | H1 | 1.8V | Input | U10 (ADC) | U11 FPGA | Pull-Down | LVDS_1V8 |
| 22 | LVDS_D6_N | H2 | 1.8V | Input | U10 (ADC) | U11 FPGA | Pull-Down | LVDS_1V8 |
| 23 | LVDS_D7 | H3 | 1.8V | Input | U10 (ADC) | U11 FPGA | Pull-Down | LVDS_1V8 |
| 24 | LVDS_D7_N | H4 | 1.8V | Input | U10 (ADC) | U11 FPGA | Pull-Down | LVDS_1V8 |
| 25 | LO1_SPI_CS | J1 | 3.3V | Output | U11 FPGA | U3 (LMX2820) | HIGH (Deselected) | LVCMOS33 |
| 26 | LO1_SPI_SCLK | J2 | 3.3V | Output | U11 FPGA | U3 (LMX2820) | LOW | LVCMOS33 |
| 27 | LO1_SPI_SDIO | J3 | 3.3V | Output | U11 FPGA | U3 (LMX2820) | LOW | LVCMOS33 |
| 28 | LO1_SPI_SDO | J4 | 3.3V | Input | U3 (LMX2820) | U11 FPGA | Pull-Down | LVCMOS33 |
| 29 | LO2_SPI_CS | K1 | 3.3V | Output | U11 FPGA | U7 (ADF4383) | HIGH (Deselected) | LVCMOS33 |
| 30 | LO2_SPI_SCLK | K2 | 3.3V | Output | U11 FPGA | U7 (ADF4383) | LOW | LVCMOS33 |
| 31 | LO2_SPI_SDIO | K3 | 3.3V | Output | U11 FPGA | U7 (ADF4383) | LOW | LVCMOS33 |
| 32 | LO2_SPI_SDO | K4 | 3.3V | Input | U7 (ADF4383) | U11 FPGA | Pull-Down | LVCMOS33 |
| 33 | AGC_DAC | L1 | 3.3V | Output | U11 FPGA | R3/R2 to U9 VGA | LOW | LVCMOS33 |
| 34 | YIG_BIAS | L2 | 3.3V | Output | U11 FPGA | BT1 (Bias Tee) | LOW | LVCMOS33 |
| 35 | FPGA_INIT | M1 | 3.3V | Output | U11 FPGA | J2 (Data Conn) | LOW | LVCMOS33 |
| 36 | FPGA_TX0 | M2 | 3.3V | Output | U11 FPGA | J2 (Data Conn) | LOW | LVCMOS33 |
| 37 | FPGA_TX1 | M3 | 3.3V | Output | U11 FPGA | J2 (Data Conn) | LOW | LVCMOS33 |
| 38 | FPGA_TX2 | M4 | 3.3V | Output | U11 FPGA | J2 (Data Conn) | LOW | LVCMOS33 |
| 39 | FPGA_TX3 | N1 | 3.3V | Output | U11 FPGA | J2 (Data Conn) | LOW | LVCMOS33 |
| 40 | FPGA_TXC_P | N2 | 3.3V | Output | U11 FPGA | J2 (Data Conn) | LOW | LVDS_33 |
| 41 | FPGA_TXC_N | N3 | 3.3V | Output | U11 FPGA | J2 (Data Conn) | HIGH | LVDS_33 |
| 42 | FPGA_READY | N4 | 3.3V | Output | U11 FPGA | J2 (Data Conn) | LOW | LVCMOS33 |
| 43 | FPGA_MISO | P1 | 3.3V | Output | U11 FPGA | J2 (Data Conn) | HIGH-Z | LVCMOS33 |
| 44 | FPGA_SYNC | P2 | 3.3V | Output | U11 FPGA | J2 (Data Conn) | LOW | LVCMOS33 |
| 45 | FPGA_CLK_125M | P3 | 3.3V | Input | 125MHz Osc / PLL | U11 FPGA | Pull-Down | LVCMOS33 |
| 46 | FPGA_TCK | P4 | 3.3V | Input | J6 (JTAG Header) | U11 FPGA | Pull-Down | LVCMOS33 |
| 47 | FPGA_TDI | R1 | 3.3V | Input | J6 (JTAG Header) | U11 FPGA | Pull-Down | LVCMOS33 |
| 48 | FPGA_TDO | R2 | 3.3V | Output | U11 FPGA | J6 (JTAG Header) | HIGH-Z | LVCMOS33 |
| 49 | FPGA_TMS | R3 | 3.3V | Input | J6 (JTAG Header) | U11 FPGA | Pull-Up | LVCMOS33 |
| 50 | FPGA_RESET_N | R4 | 3.3V | Input | Supervisor | U11 FPGA | Pull-Up | LVCMOS33 |

---

## 9. Functional Specifications

**Summary Table:**

| S.No. | Function Name | Description |
|-------|--------------|-------------|
| 1 | ADC Interface & Data Capture | LVDS reception and deserialization of 16-bit 210 Msps data from 4x LTC2107 ADCs |
| 2 | PLL Synthesizer Control | Dedicated SPI control for LO1 (LMX2820) and LO2 (ADF4383) frequency generation |
| 3 | VGA / AGC Control | Serial DAC output for TGL2767 VGA gain adjustment across 0-20 dB range |
| 4 | Power Supply Sequencing & Health Status | Controlled power-up sequence and health monitoring |
| 5 | Supply Voltage, Current & Temperature Monitoring | I2C-based rail monitoring and thermal protection |
| 6 | Flash Interfaces | Configuration and user data storage via SPI/QSPI |
| 7 | YIG Preselector Bias Control | Bias tee tuning voltage for YIG filter center frequency adjustment |
| 8 | Host Data Interface | High-speed LVDS data output via Samtec connector for processed radar pulses |
| 9 | FPGA Remote Programming | Configuration loading via host interface or JTAG |
| 10 | Digital Downconversion & Pulse Processing | Multi-channel DDC, filtering, and pulse compression in DSP slices |

### 9.1 Serial Communication Interface
- Interface type: UART (command/control path multiplexed on host data link)
- Physical layer: LVCMOS33 / translated to RS-422 on host interface card
- Baud rate: 115200 bps (default), configurable up to 12 Mbps
- Frame format: 1 start bit, 8 data bits, 1 stop bit, no parity (8N1)
- Protocol: Custom register-based command/response (detailed in Section 11)
- Signals: FPGA_TX0 (FPGA → Host), Host_RX routed via FPGA_MISO
- Purpose: Host PC sends tuning commands (LO frequency, VGA gain, YIG bias, mode control) and receives status/telemetry data

### 9.2 High Speed Communication Interface
- Interface: LVDS parallel data bus via Samtec LSHM-60 connector
- Number of lanes: 4 single-ended data lines (FPGA_TX0 to FPGA_TX3) + 1 differential clock pair (FPGA_TXC_P/N)
- Data rate per lane: 210 Mbps synchronous to ADC clock domain
- Protocol: Custom framed radar pulse data with sync header
- Physical: 60-pin Samtec LSHM-260 connector (J2)
- Control signals: FPGA_INIT (frame start), FPGA_READY (link active), FPGA_SYNC (frame synchronization)

### 9.3 Power On/Off Sequence

#### 9.3.1 Power ON/OFF Sequence
1. +15V input applied via J3 → Common mode choke (L1) → 15V_FILT rail active
2. LDOs enable: +5V_RF (U13) → +3V3_DIG (U14) → +1V8 (U15) sequence via natural LDO regulation
3. Buck converter (U16) starts → +1V0_CORE rail ramps to 1.0V
4. FPGA core powers up, internal POR asserts → FPGA_RESET_N released by supervisor
5. FPGA loads configuration from internal flash → FPGA_INIT driven HIGH
6. FPGA de-asserts ADC_PD (LOW) → ADCs power up and begin digitizing
7. OCXO (U12) stabilizes to 10 MHz → Reference buffers distribute to LO1/LO2 PLLs
8. FPGA configures LO1 (LMX2820) and LO2 (ADF4383) via SPI to default frequencies
9. FPGA sets AGC_DAC to mid-scale (default VGA gain)
10. FPGA asserts FPGA_READY → System operational

#### 9.3.2 Mode Configuration
| Mode | Signal | Value | Description |
|------|--------|-------|-------------|
| Normal | MODE[1:0] | 2'b00 | Normal operating mode with all channels active |
| Test | MODE[1:0] | 2'b01 | Built-in self-test with ADC loopback |
| Programming | MODE[1:0] | 2'b10 | FPGA remote programming mode |
| Standby | MODE[1:0] | 2'b11 | ADC powered down, LOs idle, minimal power |

### 9.4 Supply Voltage, Current & Temperature Monitoring

#### 9.4.1 Supply Voltage and Current Monitoring
- IC Part Number: LTC2992CMS#PBF (Quad I2C Power Monitor)
- Interface: I2C at address 0x6F
- Monitored rails: +15V_IN, +5V_RF, +3V3_DIG, +1V0_CORE
- Measurement range: 0 to 16V voltage, 0 to 5A current (via shunt)
- Resolution: 12-bit ADC (2.5 mV / 1.25 mA)
- Alert thresholds: Over-voltage +10%, under-voltage -10% from nominal
- Monitoring rate: 100 Hz continuous background polling

#### 9.4.2 Temperature Monitoring
- IC Part Number: AD7416ARMZ (10-Bit Digital Temperature Sensor)
- Interface: I2C at address 0x48
- Temperature range: -55°C to +125°C (matching military spec)
- Resolution: 0.25°C (10-bit ADC)
- Alert threshold: +85°C (over-temperature warning), +95°C (critical shutdown)
- Monitoring rate: 10 Hz background polling
- Alert output: Therm_Alert (active low) routed to FPGA GPIO

### 9.5 Flash & Interfaces

#### 9.5.1 Configuration Flash
- Part Number: IS25LP256D-RKLE (ISSI)
- Interface: QSPI (quad SPI)
- Capacity: 256 Mbit (32 MB)
- Purpose: Stores FPGA programming bitstream for power-on configuration and remote programming
- Programming: Via host UART interface through GUI tool
- Erase/Write cycles: 100,000 minimum

#### 9.5.2 Storage Flash (User Flash)
- Part Number: MT25QU02GBBB8E12-S (Micron)
- Interface: QSPI
- Capacity: 2 Gbit (256 MB)
- Purpose: Stores LO frequency tuning tables, VGA gain calibration curves, YIG bias lookup tables, and captured pulse data
- Partitioning: Bank 0 = LO tables (64 MB), Bank 1 = VGA calibration (64 MB), Bank 2 = YIG tables (64 MB), Bank 3 = Data capture buffer (64 MB)

### 9.6 YIG Preselector Bias Control
- Signal: YIG_BIAS
- Direction: FPGA → Bias Tee (BT1)
- Logic level: 3.3V LVCMOS33
- Function: Controls YIG tunable preselector center frequency (18-40 GHz)
- Interface: Internal FPGA DAC or PWM output followed by external reconstruction filter
- Tuning range: 0 to 10V analog (via external op-amp buffer)
- Resolution: 12-bit (2.44 mV per LSB)
- Calibration: Frequency-to-bias lookup table stored in User Flash
- Control: Written via UART register command (YIG_FREQ register)

### 9.7 FPGA Remote Programming
- Protocol: UART at 115200 bps (default)
- Tool: Custom GUI application on host PC
- Procedure:
  1. Host sends PROGRAMMING_MODE command via UART
  2. FPGA enters programming mode (MODE = 2'b10), asserts FPGA_INIT LOW
  3. Bitstream transferred in 256-byte packets with CRC-32 verification
  4. FPGA writes configuration flash via SPI master
  5. Host sends REBOOT command
  6. FPGA triggers internal reconfiguration from updated flash
  7. FPGA_INIT driven HIGH on successful configuration
- Fallback: JTAG programming via 10-pin header (J6) using Xilinx Platform Cable
- Timeout: 30 seconds maximum for full bitstream transfer

### 9.8 LO Synthesizer Control (PLL Programming)

#### 9.8.1 LO1 Synthesizer (LMX2820RTCT)
- Control basis: Target RF frequency calculation → N/R divider computation
- Interface: SPI (LO1_SPI_SCLK, LO1_SPI_SDIO, LO1_SPI_CS, LO1_SPI_SDO)
- SPI clock rate: 20 MHz maximum
- Register width: 24-bit per register access
- Frequency range: 14-36 GHz (with output divider)
- Phase noise target: -120 dBc/Hz at 10 kHz offset
- Reference: 10 MHz from OCXO via GVA-63+ buffer
- Programming: Frequency register calculation performed in FPGA, values stored in lookup table

#### 9.8.2 LO2 Synthesizer (ADF4383BCCZ)
- Control basis: Target IF1 → IF2 conversion → LO2 frequency calculation
- Interface: SPI (LO2_SPI_SCLK, LO2_SPI_SDIO, LO2_SPI_CS, LO2_SPI_SDO)
- SPI clock rate: 20 MHz maximum
- Register width: 24-bit per register access
- Frequency: Fixed at 3.5 GHz (IF1 4 GHz → IF2 500 MHz)
- Reference: 10 MHz from OCXO via GVA-63+ buffer

### 9.9 ADC Interface & Digital Downconversion

#### 9.9.1 ADC Data Capture
- ADC Part Number: LTC2107IUK PBF
- Interface: LVDS (16 data bits differential + 1 differential clock + 1 overflow bit)
- Sample rate: 210 Msps
- Resolution: 16 bits (split as D[7:0] per edge = 16 bits per clock cycle on DDR LVDS)
- Clock: LVDS_CLK_P/N from ADC (source-synchronous)
- Data lines: LVDS_D0 through LVDS_D7 (8 differential pairs = 16 bits)
- Overflow: ADC_OVR flag indicates clipping
- Power-down: ADC_PD controlled by FPGA (active HIGH = power down)

#### 9.9.2 Digital Downconversion (DDC)
- Architecture: 4-channel parallel DDC (one per ADC)
- Input: 16-bit real samples at 210 Msps
- Processing: Numerically controlled oscillator (NCO) → Mixer → CIC decimation filter → FIR compensation → Output
- Decimation factor: Programmable (2, 4, 8, 16, 32)
- Output format: Complex I/Q samples, 16-bit each
- NCO frequency resolution: 32-bit phase accumulator (0.05 Hz steps at 210 Msps)
- DSP slice usage: 4 DSP48E1 per channel (16 total for 4 channels)
- Block RAM: 4 KB per channel for coefficient storage

### 9.10 VGA / AGC Control
- VGA Part Number: TGL2767-SMEVB
- Interface: Analog control voltage via FPGA AGC_DAC output through R3/R2 resistor network
- AGC_DAC resolution: 12-bit PWM or sigma-delta DAC output
- Control voltage range: 0V to 2.5V at VGA control pin
- Gain range: 0 dB to 20 dB
- Default: Mid-scale (10 dB nominal gain)
- Update rate: 1 kHz (AGC loop bandwidth)
- Protection: ADC_OVR flag triggers immediate gain reduction if clipping detected

---

## 10. Software Register Address Map

### 10.1 Register Base Addresses

| Block Name | Base Address | Address Range | Description |
|------------|-------------|---------------|-------------|
| System / Identification | 0x0000 | 0x0000–0x00FF | Board ID, firmware version, status, control |
| UART Control | 0x0100 | 0x0100–0x01FF | Baud rate, FIFO control, status |
| SPI Control | 0x0200 | 0x0200–0x02FF | SPI master, chip-select control |
| I2C Control | 0x0300 | 0x0300–0x03FF | I2C master, device address, data |
| GPIO | 0x0400 | 0x0400–0x04FF | General purpose I/O control |
| LO1 PLL Control | 0x0500 | 0x0500–0x05FF | LO1/LMX2820 frequency, dividers, status |
| LO2 PLL Control | 0x0600 | 0x0600–0x06FF | LO2/ADF4383 frequency, dividers, status |
| Temperature Monitor | 0x0700 | 0x0700–0x07FF | Temp sensor readings, alert threshold |
| Power Monitor | 0x0800 | 0x0800–0x08FF | Voltage/current ADC readings per rail |
| ADC / DDC Control | 0x0900 | 0x0900–0x09FF | ADC power-down, NCO freq, decimation |
| VGA / AGC Control | 0x0A00 | 0x0A00–0x0AFF | AGC_DAC value, AGC mode, thresholds |
| YIG Preselector | 0x0B00 | 0x0B00–0x0BFF | YIG bias DAC value, frequency tuning |
| Flash / EEPROM | 0x0C00 | 0x0C00–0x0CFF | Flash address, data, command register |
| Diagnostics | 0x0D00 | 0x0D00–0x0DFF | Fault log, uptime counter, loopback |

### 10.2 Detailed Register Map

**Block 0x0000 — System / Identification**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|--------------|-------|-----|-------------|----------------------|
| 0x00 | BOARD_ID | 16 | R | 0x4B37 | Board identification code ('K7' ASCII) |
| 0x01 | FW_VERSION_MAJOR | 16 | R | 0x0001 | Firmware major version |
| 0x02 | FW_VERSION_MINOR | 16 | R | 0x0000 | Firmware minor version |
| 0x03 | SYS_STATUS | 16 | R | 0x0000 | [15:10] Reserved, [9] FLASH_BUSY, [8] DATA_LINK_UP, [7] LO2_LOCKED, [6] LO1_LOCKED, [5] TEMP_ALERT, [4] VOLT_FAULT, [3] ADC_OVR, [2] FPGA_READY, [1] FPGA_INIT, [0] PLL_REF_LOCK |
| 0x04 | SYS_CTRL | 16 | R/W | 0x0000 | [15:4] Reserved, [3] STANDBY_EN, [2] RF_ENABLE, [1] WDT_ENABLE, [0] SOFT_RESET |
| 0x05 | SYS_MODE | 16 | R/W | 0x0000 | [15:2] Reserved, [1:0] MODE_SEL (0=Normal, 1=Test, 2=Prog, 3=Standby) |
| 0x06 | SYS_IRQ_MASK | 16 | R/W | 0x00FF | [7] LO_UNLOCK_IRQ, [6] TEMP_ALERT_IRQ, [5] VOLT_FAULT_IRQ, [4] ADC_OVR_IRQ, [3:0] Reserved |
| 0x07 | SYS_IRQ_STATUS | 16 | R/C | 0x0000 | [7] LO_UNLOCK_PEND, [6] TEMP_ALERT_PEND, [5] VOLT_FAULT_PEND, [4] ADC_OVR_PEND, [3:0] Reserved (write 1 to clear) |
| 0x08 | UPTIME_LSB | 16 | R | 0x0000 | Uptime counter bits [15:0] in milliseconds |
| 0x09 | UPTIME_MSB | 16 | R | 0x0000 | Uptime counter bits [31:16] in milliseconds |

**Block 0x0100 — UART Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|--------------|-------|-----|-------------|----------------------|
| 0x00 | BAUD_DIV | 16 | R/W | 0x0036 | Baud rate divisor = 125MHz / (16 × BAUD_RATE). Default: 0x36=115200 bps |
| 0x01 | UART_CTRL | 16 | R/W | 0x0001 | [15:3] Reserved, [2] CRC_EN, [1] LOOPBACK_EN, [0] UART_ENABLE |
| 0x02 | UART_STATUS | 16 | R | 0x0000 | [15:4] Reserved, [3] FRAME_ERR, [2] RX_OVERRUN, [1] RX_AVAIL, [0] TX_BUSY |
| 0x03 | TX_FIFO_COUNT | 16 | R | 0x0000 | [15:8] Reserved, [7:0] Number of bytes in TX FIFO |
| 0x04 | RX_FIFO_COUNT | 16 | R | 0x0000 | [15:8] Reserved, [7:0] Number of bytes in RX FIFO |
| 0x05 | TX_DATA | 16 | R/W | 0x0000 | [15:8] Reserved, [7:0] Transmit data byte (write triggers TX) |
| 0x06 | RX_DATA | 16 | R | 0x0000 | [15:8] Reserved, [7:0] Received data byte (read clears FIFO) |

**Block 0x0200 — SPI Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|--------------|-------|-----|-------------|----------------------|
| 0x00 | SPI_CLK_DIV | 16 | R/W | 0x0006 | SPI clock divisor = FPGA_CLK / (2 × (DIV+1)). Default: 6 = ~9 MHz |
| 0x01 | SPI_CTRL | 16 | R/W | 0x0000 | [15:5] Reserved, [4] SPI_START, [3] CPOL, [2] CPHA, [1:0] SPI_SEL (0=LO1, 1=LO2, 2=Flash, 3=EEPROM) |
| 0x02 | SPI_STATUS | 16 | R | 0x0001 | [15:1] Reserved, [0] SPI_READY (1=Idle, 0=Busy) |
| 0x03 | SPI_TX_DATA | 16 | R/W | 0x0000 | [15:8] TX_BYTE_2, [7:0] TX_BYTE_1 (MSB-first, 16-bit or 24-bit frame) |
| 0x04 | SPI_TX_DATA_H | 16 | R/W | 0x0000 | [15:8] TX_BYTE_4, [7:0] TX_BYTE_3 (for 24/32-bit PLL frames) |
| 0x05 | SPI_RX_DATA | 16 | R | 0x0000 | [15:8] RX_BYTE_2, [7:0] RX_BYTE_1 |
| 0x06 | SPI_RX_DATA_H | 16 | R | 0x0000 | [15:8] RX_BYTE_4, [7:0] RX_BYTE_3 |
| 0x07 | SPI_FRAME_LEN | 16 | R/W | 0x0003 | [15:3] Reserved, [2:0] Frame length in bytes (1-8) |

**Block 0x0300 — I2C Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|--------------|-------|-----|-------------|----------------------|
| 0x00 | I2C_CTRL | 16 | R/W | 0x0000 | [15:3] Reserved, [2] I2C_START, [1] I2C_RW (0=Write, 1=Read), [0] I2C_ENABLE |
| 0x01 | I2C_STATUS | 16 | R | 0x0001 | [15:4] Reserved, [3] NACK, [2] BUS_ERROR, [1] BUSY, [0] I2C_READY |
| 0x02 | I2C_DEV_ADDR | 16 | R/W | 0x0000 | [15:8] Reserved, [7:1] Device address, [0] Reserved |
| 0x03 | I2C_REG_ADDR | 16 | R/W | 0x0000 | [15:8] Reserved, [7:0] Register address within target device |
| 0x04 | I2C_TX_DATA | 16 | R/W | 0x0000 | [15:8] Reserved, [7:0] Transmit data byte |
| 0x05 | I2C_RX_DATA | 16 | R | 0x0000 | [15:8] Reserved, [7:0] Received data byte |
| 0x06 | I2C_CLK_DIV | 16 | R/W | 0x0064 | I2C clock divisor (default 100 = 400 kHz) |

**Block 0x0400 — GPIO**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|--------------|-------|-----|-------------|----------------------|
| 0x00 | GPIO_OUTPUT | 16 | R/W | 0x0000 | [15:10] Reserved, [9] YIG_BIAS_EN, [8] DATA_LINK_EN, [7] LED_STATUS, [6:4] Reserved, [3] FPGA_SYNC, [2] FPGA_READY, [1] FPGA_INIT, [0] ADC_PD (active high) |
| 0x01 | GPIO_INPUT | 16 | R | 0x0000 | [15:4] Reserved, [3] ADC_OVR, [2] THERM_ALERT_N, [1] VOLT_FAULT_N, [0] FPGA_RESET_N |
| 0x02 | GPIO_DIR | 16 | R/W | 0x0007 | [15:0] Direction per bit (0=Input, 1=Output). Default: bits [2:0] output |
| 0x03 | GPIO_IRQ_MASK | 16 | R/W | 0x0000 | [15:4] Reserved, [3] ADC_OVR_IRQ_EN, [2] THERM_IRQ_EN, [1] VOLT_IRQ_EN, [0] RESET_IRQ_EN |

**Block 0x0500 — LO1 PLL Control (LMX2820)**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|--------------|-------|-----|-------------|----------------------|
| 0x00 | LO1_FREQ_INT | 16 | R/W | 0x4000 | Integer part of N divider (target frequency / f_PD) |
| 0x01 | LO1_FREQ_FRAC | 16 | R/W | 0x0000 | Fractional part of N divider [15:0] (upper bits) |
| 0x02 | LO1_FREQ_FRAC_LSB | 16 | R/W | 0x0000 | Fractional N divider lower bits [15:0] |
| 0x03 | LO1_PLL_CTRL | 16 | R/W | 0x0000 | [15:4] Reserved, [3] PLL_FCAL_EN, [2] PLL_BYPASS, [1] PLL_RESET, [0] PLL_ENABLE |
| 0x04 | LO1_PLL_STATUS | 16 | R | 0x0000 | [15:4] Reserved, [3] PLL_VTUNE_OK, [2] PLL_FCAL_DONE, [1] PLL_LOSS_OF_LOCK, [0] PLL_LOCKED |
| 0x05 | LO1_R_DIV | 16 | R/W | 0x0001 | R divider value (10MHz ref / R = phase detector freq) |
| 0x06 | LO1_OUT_POWER | 16 | R/W | 0x0003 | [15:4] Reserved, [3:0] Output power level (0-15, default 3 = +7 dBm) |
| 0x07 | LO1_LOCK_TIMEOUT | 16 | R/W | 0x0064 | Lock timeout in 1 ms units (default 100 ms) |
| 0x08 | LO1_SPI_DIRECT_0 | 16 | R/W | 0x0000 | Direct SPI register 0 data [15:0] for advanced LMX2820 programming |
| 0x09 | LO1_SPI_DIRECT_1 | 16 | R/W | 0x0000 | Direct SPI register 1 data [15:0] |
| 0x0A | LO1_SPI_DIRECT_2 | 16 | R/W | 0x0000 | Direct SPI register 2 data [15:0] |
| 0x0B | LO1_FREQ_WORD | 16 | R/W | 0x0000 | Target frequency in MHz [15:0] (auto-computes N/R dividers) |
| 0x0C | LO1_FREQ_WORD_MSB | 16 | R/W | 0x0000 | Target frequency in MHz [31:16] (upper bits for 18-40 GHz) |

**Block 0x0600 — LO2 PLL Control (ADF4383)**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|--------------|-------|-----|-------------|----------------------|
| 0x00 | LO2_FREQ_INT | 16 | R/W | 0x0E00 | Integer N divider for fixed 3.5 GHz LO2 (N=350 at 10 MHz f_PD) |
| 0x01 | LO2_FREQ_FRAC | 16 | R/W | 0x0000 | Fractional N divider [15:0] |
| 0x02 | LO2_PLL_CTRL | 16 | R/W | 0x0000 | [15:4] Reserved, [3] PLL_FCAL_EN, [2] PLL_BYPASS, [1] PLL_RESET, [0] PLL_ENABLE |
| 0x03 | LO2_PLL_STATUS | 16 | R | 0x0000 | [15:4] Reserved, [3] PLL_VTUNE_OK, [2] PLL_FCAL_DONE, [1] PLL_LOSS_OF_LOCK, [0] PLL_LOCKED |
| 0x04 | LO2_R_DIV | 16 | R/W | 0x0001 | R divider value (default 1 for 10 MHz f_PD) |
| 0x05 | LO2_OUT_POWER | 16 | R/W | 0x0002 | [15:4] Reserved, [3:0] Output power level (default 2) |
| 0x06 | LO2_LOCK_TIMEOUT | 16 | R/W | 0x0064 | Lock timeout in 1 ms units (default 100 ms) |
| 0x07 | LO2_SPI_DIRECT_0 | 16 | R/W | 0x0000 | Direct ADF4383 register 0 [15:0] |
| 0x08 | LO2_SPI_DIRECT_1 | 16 | R/W | 0x0000 | Direct ADF4383 register 1 [15:0] |
| 0x09 | LO2_SPI_DIRECT_2 | 16 | R/W | 0x0000 | Direct ADF4383 register 2 [15:0] |

**Block 0x0700 — Temperature Monitor (AD7416)**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|--------------|-------|-----|-------------|----------------------|
| 0x00 | TEMP_VALUE | 16 | R | 0x0000 | [15:6] Temperature value (10-bit, 0.25°C/LSB), [5:0] Reserved |
| 0x01 | TEMP_CONFIG | 16 | R/W | 0x0000 | [15:6] Reserved, [5:4] Fault queue, [3] ALERT_POL, [2] COMP_INT, [1:0] Conversion rate |
| 0x02 | TEMP_ALERT_HIGH | 16 | R/W | 0x0554 | Over-temperature alert threshold (default +85°C = 0x554) |
| 0x03 | TEMP_ALERT_LOW | 16 | R/W | 0x0000 | Under-temperature alert threshold (default 0°C) |
| 0x04 | TEMP_CRITICAL | 16 | R/W | 0x05F0 | Critical shutdown threshold (default +95°C = 0x5F0) |
| 0x05 | TEMP_STATUS | 16 | R | 0x0000 | [15:2] Reserved, [1] UNDER_TEMP, [0] OVER_TEMP |

**Block 0x0800 — Power Monitor (LTC2992)**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|--------------|-------|-----|-------------|----------------------|
| 0x00 | PWR_V_15V | 16 | R | 0x0000 | [15:4] 12-bit voltage reading for +15V rail (LSB = 2.5 mV) |
| 0x01 | PWR_V_5V | 16 | R | 0x0000 | [15:4] 12-bit voltage reading for +5V_RF rail |
| 0x02 | PWR_V_3V3 | 16 | R | 0x0000 | [15:4] 12-bit voltage reading for +3V3_DIG rail |
| 0x03 | PWR_V_1V0 | 16 | R | 0x0000 | [15:4] 12-bit voltage reading for +1V0_CORE rail |
| 0x04 | PWR_I_15V | 16 | R | 0x0000 | [15:4] 12-bit current reading for +15V input (LSB = 1.25 mA) |
| 0x05 | PWR_I_5V | 16 | R | 0x0000 | [15:4] 12-bit current reading for +5V_RF rail |
| 0x06 | PWR_I_3V3 | 16 | R | 0x0000 | [15:4] 12-bit current reading for +3V3_DIG rail |
| 0x07 | PWR_I_1V0 | 16 | R | 0x0000 | [15:4] 12-bit current reading for +1V0_CORE rail |
| 0x08 | PWR_CTRL | 16 | R/W | 0x0001 | [15:1] Reserved, [0] PWR_MONITOR_EN (default: enabled) |
| 0x09 | PWR_STATUS | 16 | R | 0x0000 | [15:4] Reserved, [3] I_1V0_FAULT, [2] I_3V3_FAULT, [1] I_5V_FAULT, [0] V_FAULT_ANY |
| 0x0A | PWR_FAULT_MASK | 16 | R/W | 0x000F | [15:4] Reserved, [3] I_1V0_MASK, [2] I_3V3_MASK, [1] I_5V_MASK, [0] V_FAULT_MASK |
| 0x0B | PWR_ALERT_THRESH | 16 | R/W | 0x0CCC | [15:4] Over-voltage threshold (default 10% above nominal) |

**Block 0x0900 — ADC / DDC Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|--------------|-------|-----|-------------|----------------------|
| 0x00 | ADC_CTRL | 16 | R/W | 0x0001 | [15:5] Reserved, [4] CH4_PD, [3] CH3_PD, [2] CH2_PD, [1] CH1_PD, [0] ADC_GLOBAL_PD |
| 0x01 | ADC_STATUS | 16 | R | 0x0000 | [15:4] Reserved, [3] CH4_OVR, [2] CH3_OVR, [1] CH2_OVR, [0] CH1_OVR |
| 0x02 | DDC_NCO_FREQ_LSB | 16 | R/W | 0x0000 | NCO frequency tuning word [15:0] (32-bit total, freq = FTW × 210MHz / 2³²) |
| 0x03 | DDC_NCO_FREQ_MSB | 16 | R/W | 0x0000 | NCO frequency tuning word [31:16] |
| 0x04 | DDC_DECIMATION | 16 | R/W | 0x0008 | [15:3] Reserved, [2:0] DEC_FACTOR (0=x2, 1=x4, 2=x8, 3=x16, 4=x32, default=x16) |
| 0x05 | DDC_CTRL | 16 | R/W | 0x000F | [15:4] Reserved, [3] CH4_DDC_EN, [2] CH3_DDC_EN, [1] CH2_DDC_EN, [0] CH1_DDC_EN |
| 0x06 | DDC_GAIN_CH1 | 16 | R/W | 0x1000 | [15:0] Digital gain factor for CH1 (1.15 fixed point, default 1.0) |
| 0x07 | DDC_GAIN_CH2 | 16 | R/W | 0x1000 | [15:0] Digital gain factor for CH2 |
| 0x08 | DDC_GAIN_CH3 | 16 | R/W | 0x1000 | [15:0] Digital gain factor for CH3 |
| 0x09 | DDC_GAIN_CH4 | 16 | R/W | 0x1000 | [15:0] Digital gain factor for CH4 |
| 0x0A | DDC_FIFO_LEVEL | 16 | R | 0x0000 | [15:0] Current FIFO fill level in samples (per channel) |

**Block 0x0A00 — VGA / AGC Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|--------------|-------|-----|-------------|----------------------|
| 0x00 | AGC_DAC_VALUE | 16 | R/W | 0x0800 | [15:0] 12-bit DAC value for VGA control (0x000=0V, 0xFFF=2.5V). Default: mid-scale |
| 0x01 | AGC_CTRL | 16 | R/W | 0x0000 | [15:2] Reserved, [1] AGC_AUTO_EN, [0] AGC_ENABLE |
| 0x02 | AGC_TARGET | 16 | R/W | 0x6000 | [15:0] Target RMS power level for AGC loop (default -6 dBFS) |
| 0x03 | AGC_MIN_GAIN | 16 | R/W | 0x0000 | [15:0] Minimum DAC value (0 dB VGA gain) |
| 0x04 | AGC_MAX_GAIN | 16 | R/W | 0x0FFF | [15:0] Maximum DAC value (20 dB VGA gain) |
| 0x05 | AGC_ATTACK_RATE | 16 | R/W | 0x0010 | [15:0] Attack rate (gain decrease speed, default 16) |
| 0x06 | AGC_DECAY_RATE | 16 | R/W | 0x0004 | [15:0] Decay rate (gain increase speed, default 4) |
| 0x07 | AGC_STATUS | 16 | R | 0x0000 | [15:0] Current RMS power measurement |

**Block 0x0B00 — YIG Preselector**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|--------------|-------|-----|-------------|----------------------|
| 0x00 | YIG_BIAS_DAC | 16 | R/W | 0x0800 | [15:0] 12-bit DAC value for YIG bias voltage (0 to 10V analog) |
| 0x01 | YIG_FREQ_TARGET | 16 | R/W | 0x0000 | [15:0] Target center frequency in GHz × 100 (e.g. 18 GHz = 0x0710) |
| 0x02 | YIG_FREQ_TARGET_MSB | 16 | R/W | 0x0000 | [15:0] Upper bits for sub-MHz resolution |
| 0x03 | YIG_CTRL | 16 | R/W | 0x0000 | [15:1] Reserved, [0] YIG_TUNING_EN |
| 0x04 | YIG_STATUS | 16 | R | 0x0000 | [15:1] Reserved, [0] YIG_TUNING_LOCK (analog feedback) |
| 0x05 | YIG_CAL_TABLE_SEL | 16 | R/W | 0x0000 | [15:8] Reserved, [7:0] Calibration table index from Flash (0-255) |

**Block 0x0C00 — Flash / EEPROM**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|--------------|-------|-----|-------------|----------------------|
| 0x00 | FLASH_ADDR_LSB | 16 | R/W | 0x0000 | Flash address [15:0] |
| 0x01 | FLASH_ADDR_MSB | 16 | R/W | 0x0000 | Flash address [31:16] |
| 0x02 | FLASH_DATA_0 | 16 | R/W | 0x0000 | Data word 0 [15:0] |
| 0x03 | FLASH_DATA_1 | 16 | R/W | 0x0000 | Data word 1 [15:0] |
| 0x04 | FLASH_DATA_2 | 16 | R/W | 0x0000 | Data word 2 [15:0] |
| 0x05 | FLASH_DATA_3 | 16 | R/W | 0x0000 | Data word 3 [15:0] |
| 0x06 | FLASH_CTRL | 16 | R/W | 0x0000 | [15:5] Reserved, [4] FLASH_ERASE, [3] FLASH_READ, [2] FLASH_WRITE, [1] FLASH_SEL (0=Config, 1=User), [0] FLASH_START |
| 0x07 | FLASH_STATUS | 16 | R | 0x0001 | [15:1] Reserved, [0] FLASH_READY (1=Idle, 0=Busy) |
| 0x08 | FLASH_SECTOR_COUNT | 16 | R/W | 0x0001 | Number of sectors to read/write (1-256) |
| 0x09 | FLASH_CRC | 16 | R | 0x0000 | [15:0] CRC-16 of last transferred data block |
| 0x0A | FLASH_CONFIG_TRIGGER | 16 | R/W | 0x0000 | [15:1] Reserved, [0] RECONFIG_TRIGGER (write 1 then 0 to trigger FPGA reconfiguration) |

**Block 0x0D00 — Diagnostics**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|--------------|-------|-----|-------------|----------------------|
| 0x00 | DIAG_CTRL | 16 | R/W | 0x0000 | [15:4] Reserved, [3] PRBS_EN, [2] LOOPBACK_EN, [1] SELF_TEST_START, [0] DIAG_ENABLE |
| 0x01 | DIAG_STATUS | 16 | R | 0x0000 | [15:4] Reserved, [3] PRBS_LOCK, [2] SELF_TEST_PASS, [1] SELF_TEST_FAIL, [0] SELF_TEST_RUNNING |
| 0x02 | DIAG_ERROR_COUNT | 16 | R | 0x0000 | [15:0] PRBS error count (cumulative) |
| 0x03 | DIAG_FAULT_LOG_0 | 16 | R | 0x0000 | [15:0] Most recent fault code |
| 0x04 | DIAG_FAULT_LOG_1 | 16 | R | 0x0000 | [15:0] Second most recent fault code |
| 0x05 | DIAG_FAULT_LOG_2 | 16 | R | 0x0000 | [15:0] Third most recent fault code |
| 0x06 | DIAG_FAULT_LOG_3 | 16 | R | 0x0000 | [15:0] Fourth most recent fault code |
| 0x07 | DIAG_FAULT_TIMESTAMP | 16 | R | 0x0000 | [15:0] Timestamp (ms) of last fault [15:0] |
| 0x08 | DIAG_LOOPBACK_TX | 16 | R/W | 0x0000 | [15:0] Loopback transmit data pattern |
| 0x09 | DIAG_LOOPBACK_RX | 16 | R | 0x0000 | [15:0] Loopback received data pattern |
| 0x0A | DIAG_ADC_CH1_CAPTURE | 16 | R | 0x0000 | [15:0] Latest ADC sample CH1 (diagnostic readback) |
| 0x0B | DIAG_ADC_CH2_CAPTURE | 16 | R | 0x0000 | [15:0] Latest ADC sample CH2 |
| 0x0C | DIAG_ADC_CH3_CAPTURE | 16 | R | 0x0000 | [15:0] Latest ADC sample CH3 |
| 0x0D | DIAG_ADC_CH4_CAPTURE | 16 | R | 0x0000 | [15:0] Latest ADC sample CH4 |

### 10.3 Register Access Rules
- All registers are 16-bit wide; accessed via UART Single/Bulk Read/Write protocol (Section 11)
- Read: set bit15 of address (address OR 0x8000)
- Write: address as-is
- Shadow registers: LO1_FREQ_INT, LO1_FREQ_FRAC, LO2_FREQ_INT, LO2_FREQ_FRAC, AGC_DAC_VALUE, YIG_BIAS_DAC are double-buffered; values are applied on writing the respective PLL_CTRL[0] (PLL_ENABLE) bit from 0→1
- Atomic access: Bulk Write used for multi-register atomic updates (e.g., frequency change requiring N-divider and R-divider writes together)
- Auto-increment: Bulk Read/Write accesses consecutive register addresses within the same block

---

## 11. UART Register Protocol Specification

### 11.1 Physical Layer
- Baud rate: 115200 bps (default, configurable via UART_CTRL.BAUD_DIV up to 12 Mbps)
- Frame format: 1 start bit, 8 data bits, 1 stop bit, no parity (8N1)
- Physical interface: LVCMOS33 on FPGA, translated to RS-422 via external transceiver on host interface card
- Signal levels: 3.3V logic (LVCMOS33) at FPGA pins

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
  - Address out of valid range (> 0x0DFF)
  - Write to read-only register (bit [0] of status registers)
  - N count = 0 or N count > 64 in bulk operation
  - Parser timeout (inter-byte gap > 50ms)
```

### 11.3 Protocol Timing Constraints
| Parameter | Min | Typical | Max | Unit |
|-----------|-----|---------|-----|------|
| Inter-byte gap (TX side) | 0 | — | 50 | ms |
| Single Write response time | 0.1 | 0.5 | 1 | ms |
| Single Read response time | 0.2 | 1 | 2 | ms |
| Bulk Write response time (N=64) | 1 | 3 | 5 | ms |
| Bulk Read response time (N=64) | 1 | 3 | 5 | ms |
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
#define REG_LO1_BASE    (0x0500U)
#define REG_LO2_BASE    (0x0600U)
#define REG_TEMP_BASE   (0x0700U)
#define REG_PWR_BASE    (0x0800U)
#define REG_ADC_BASE    (0x0900U)
#define REG_AGC_BASE    (0x0A00U)
#define REG_YIG_BASE    (0x0B00U)
#define REG_FLASH_BASE  (0x0C00U)
#define REG_DIAG_BASE   (0x0D00U)

// System status bit definitions
#define SYS_STS_PLL_REF_LOCK    (1 << 0)
#define SYS_STS_FPGA_INIT       (1 << 1)
#define SYS_STS_FPGA_READY      (1 << 2)
#define SYS_STS_ADC_OVR         (1 << 3)
#define SYS_STS_VOLT_FAULT      (1 << 4)
#define SYS_STS_TEMP_ALERT      (1 << 5)
#define SYS_STS_LO1_LOCKED      (1 << 6)
#define SYS_STS_LO2_LOCKED      (1 << 7)
#define SYS_STS_DATA_LINK_UP    (1 << 8)
#define SYS_STS_FLASH_BUSY      (1 << 9)
```

---

## 12. FPGA Resource Utilization Estimate

| Resource | Available | Estimated Usage | Utilization % |
|---------|-----------|----------------|--------------|
| Slice LUTs | 218,880 | 65,664 | 30% |
| Slice Flip-Flops | 407,520 | 48,902 | 12% |
| Block RAM (36Kb) | 506 | 42 | 8% |
| DSP Slices | 840 | 64 | 8% |
| MMCM/PLL | 10 | 3 | 30% |
| I/O Buffers | 500 | 52 | 10% |
| LVDS Input Pairs | 140 | 18 | 13% |

**Synthesis tool:** Vivado 2024.1
**Target device:** XC7K355T-1FFG901I (Kintex-7, Industrial Grade)
**Timing constraint:** 210 MHz primary ADC clock domain, 125 MHz processing clock domain, 20 MHz SPI clock domain

**Resource Breakdown by Function:**
- DDC (4 channels): ~16,000 LUTs, 64 DSP slices, 8 BRAM
- SPI/I2C Masters: ~2,000 LUTs
- UART Controller: ~1,500 LUTs
- AGC Loop: ~4,000 LUTs, 4 DSP slices
- Data Formatter/Output: ~8,000 LUTs, 12 BRAM
- Register Bank/Control: ~6,000 LUTs, 16 BRAM
- Temperature/Power Monitor: ~3,000 LUTs
- Flash Controller: ~4,000 LUTs, 6 BRAM
- Diagnostics/PRBS: ~2,000 LUTs
- Reset/Clocking/Infrastructure: ~5,000 LUTs

---

## Annexure A — Requirement Traceability Matrix

| S.No. | GLR-ID | Description | Source HRS Section | GLR Section | Verification Method | Status |
|-------|--------|-------------|-------------------|-------------|--------------------|--------|
| 1 | GLR-001 | Serial Communication Interface | REQ-HW-018 | 9.1, 11 | Test | Open |
| 2 | GLR-002 | High Speed Data Output Interface | REQ-HW-017, 018 | 9.2 | Test | Open |
| 3 | GLR-003 | Power Supply Sequencing | REQ-HW-010, 015 | 9.3 | Test | Open |
| 4 | GLR-004 | Voltage/Current/Temperature Monitoring | REQ-HW-003, 010 | 9.4 | Test | Open |
| 5 | GLR-005 | Flash Interfaces (Config and User) | REQ-HW-018 | 9.5 | Test | Open |
| 6 | GLR-006 | YIG Preselector Bias Control | REQ-HW-001, 002 | 9.6 | Test | Open |
| 7 | GLR-007 | FPGA Remote Programming | REQ-HW-018 | 9.7 | Demonstration | Open |
| 8 | GLR-008 | LO Synthesizer Control (LO1/LO2) | REQ-HW-012, 016 | 9.8 | Test | Open |
| 9 | GLR-009 | ADC Interface & Digital Downconversion | REQ-HW-017, 018, 019 | 9.9 | Test | Open |
| 10 | GLR-010 | VGA / AGC Control | REQ-HW-004, 007 | 9.10 | Test | Open |
| 11 | GLR-011 | Register Address Map | REQ-HW-018 | 10 | Inspection | Open |
| 12 | GLR-012 | UART Protocol Specification | REQ-HW-018 | 11 | Test | Open |
| 13 | GLR-013 | FPGA Resource Budget | REQ-HW-018 | 12 | Analysis | Open |
| 14 | GLR-014 | 4-Channel Phase Coherent Processing | REQ-HW-013 | 9.9 | Test | Open |
| 15 | GLR-015 | Input Survivability (Limiter Control) | REQ-HW-010 | 9.3, 9.10 | Inspection | Open |
| 16 | GLR-016 | T/R Switching Time < 1 µs | REQ-HW-014 | 9.6, 9.9 | Test | Open |
| 17 | GLR-017 | Pinout Details (50 signals) | REQ-HW-017, 018 | 8 | Inspection | Open |