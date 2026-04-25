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
This document explains the IO details and functional requirements of the FPGA for the **hjjg** project (Dual-channel 2–6 GHz double-IF superheterodyne radar receiver). Targeted audience: Hardware Design and Firmware teams. It bridges the Netlist (P4) and FPGA HDL Design (P7) phases, establishing the definitive interface between the dual-channel analog/RF receiver front-ends, mixed-signal ADCs, and the Kintex-7 DSP processing FPGA.

---

## 2. References

### 2.1 External
| Doc. Type | Part No. | Description |
|---|---|---|
| Datasheet | PFP-KX7_PLUS-310LC | Kintex-7 FPGA processing board / FMC+ carrier |
| Datasheet | AD9643BCPZ-170 | 14-bit dual-channel ADC, 170 MSPS, LVDS outputs |
| Datasheet | ADF4106BRUZ-RL | PLL Frequency Synthesizer, SPI interface |
| Datasheet | HMC586LC4BTR | 4-8 GHz VCO for LO1 |
| Datasheet | OSJ7014-10.0M | 10 MHz OCXO Reference Oscillator |
| Datasheet | MIC5209-3.3YM | Low-noise LDO regulator |
| Datasheet | AT25SL321 | 32Mb SPI Flash for FPGA configuration |
| Datasheet | 24AA025E48 | I2C EEPROM with EUI-48 MAC address |
| Datasheet | LMK1C1102 | 2-channel LVCMOS clock buffer |
| Datasheet | TMP116 | Digital temperature sensor, I2C interface |
| Datasheet | ADM1177-1 | Hot swap controller / Voltage-current monitor, I2C |

### 2.2 Internal
| Reference | Document |
|---|---|
| [HRS] | Hardware Requirements Specification |
| [SCH] | Schematic |
| [GRS] | General Requirements Specification |
| [GDD] | General Design Document |

---

## 3. Acronyms and Abbreviations
| Acronym | Expansion |
|---|---|
| ADC | Analog to Digital Converter |
| BPF | Bandpass Filter |
| CLB | Configurable Logic Block |
| DAC | Digital to Analog Converter |
| DSP | Digital Signal Processing |
| FMC | FPGA Mezzanine Card |
| GND | Ground |
| GPIO | General Purpose Input Output |
| I2C | Inter-Integrated Circuit |
| JTAG | Joint Test Action Group |
| LDO | Low Drop Out |
| LNA | Low Noise Amplifier |
| LO | Local Oscillator |
| LVDS | Low Voltage Differential Signaling |
| OCXO | Oven Controlled Crystal Oscillator |
| PCB | Printed Circuit Board |
| PRI | Pulse Repetition Interval |
| SFDR | Spurious Free Dynamic Range |
| SPI | Serial Peripheral Interface |
| VCO | Voltage Controlled Oscillator |

---

## 4. Module Overview

### RF SECTION
The RF front-end consists of two phase-coherent receiver channels. Each channel features a Pasternack PE8022 PIN-diode limiter (100W peak, 20 ns recovery) feeding a Guerrilla RF GRF2074 GaAs pHEMT LNA (0.8 dB NF, +20 dB gain). The signal passes through a tunable preselector BPF (2-6 GHz) before entering a Mini-Circuits MCA1-42+ 1st downconversion mixer (tuned by 3.3-7.3 GHz LO1) to produce a 1300 MHz 1st IF. A Mini-Circuits RMS-2+ 2nd mixer converts the 1300 MHz IF to a 200 MHz 2nd IF using a 1.1 GHz LO2. Gain stages utilize HMC788ALP2E driver amplifiers (+19 dBm P1dB) and GRF2040 linear gain blocks. LO distribution uses Mini-Circuits EP2K1+ 2-way power splitters.

### DIGITAL SECTION
The digital processing core is based on the Kintex-7 FPGA (PFP-KX7_PLUS-310LC). It receives digitized dual-channel 200 MHz IF signals from two AD9643BCPZ-170 14-bit 170 MSPS ADCs via high-speed LVDS interfaces. The FPGA implements radar DSP functions including DDC (Digital Downconversion), pulse compression, CFAR detection, and phase-coherent processing. Control interfaces include UART for host communication, SPI for PLL/VCO programming, and I2C for telemetry.

### POWER SUPPLY SECTION
The system operates from a primary +12 VDC input. DC-DC buck converters step down to intermediate +5 V and +3.3 V rails. MIC5209-3.3YM LDOs provide ultra-low-noise +3.3 V and +1.8 V rails for sensitive RF components (LNAs, PLLs, VCOs) and the ADC analog supplies. The FPGA core operates at +1.0V with +1.8V and +3.3V bank voltages.

---

## 5. Features
- **FPGA**: Kintex-7 XC7K160T-1FBG676C (PFP-KX7_PLUS-310LC board) processing 2-channel LVDS ADC data.
- **On-board clock oscillator**: 10 MHz ultra-stable OCXO (OSJ7014-10.0M) for system timing and PLL reference.
- **Communication**: UART at 115.2 kbps via FTDI USB-UART bridge; SPI up to 50 MHz; I2C at 400 kHz.
- **JTAG debugging support**: Standard 4-wire JTAG via FMC+ edge connector for FPGA programming/debug.
- **EEPROM**: 24AA025E48, 2 Kbit, I2C interface, stores board identification and calibration parameters.
- **Configuration Flash**: AT25SL321, 32 Mbit, standard SPI, stores FPGA configuration bitstream for remote updates.
- **Temperature Monitoring**: TMP116, I2C, military temperature range (-55°C to +125°C), 0.0078°C resolution.
- **Power Monitoring**: ADM1177-1, I2C, monitors +12V, +3.3V, +1.8V rails with voltage, current, and fault reporting.
- **PLL Control**: Dual SPI interfaces for ADF4106BRUZ-RL PLL synthesizers controlling LO1 and LO2.
- **ADC Interface**: Dual-channel 14-bit 170 MSPS AD9643BCPZ-170 with LVDS outputs and SPI control.

---

## 6. FPGA Description
The Kintex-7 XC7K160T was selected for its optimal balance of DSP processing power, high-speed LVDS I/O capability, and power efficiency required for real-time radar pulse compression and CFAR detection. It provides sufficient block RAM for dual-channel DDC FIFOs and matched filters, alongside dedicated DSP48E1 slices for high-throughput FIR filtering.

| S.NO | PARAMETERS | SPECIFICATION |
|------|-----------|---------------|
| 1 | Part Number | XC7K160T-1FBG676C (on PFP-KX7_PLUS-310LC) |
| 2 | Logic Cells | 162,240 |
| 3 | CLB Flip-Flops | 202,800 |
| 4 | Number of Gates | ~12.4M |
| 5 | Maximum Distributed RAM (Kb) | 2,635 |
| 6 | Total Block RAM (Kb) | 11,700 |
| 7 | Maximum Single-Ended I/Os | 400 |
| 8 | Maximum DSP Slices | 600 |
| 9 | No of IO Banks | 10 (HP + HR) |

---

## 7. Block Diagram
*(Reference to system block diagram — the FPGA serves as the central digital processing element. It receives dual-channel ADC data via LVDS, interfaces with the host via UART, controls PLL synthesizers via SPI, monitors telemetry via I2C, and outputs processed radar data via the FMC+ connector.)*

---

## 8. Pinout Details

**Table: FPGA Pin Out Details**

| S.No | Signal Name | Pin No | Voltage Level | Direction wrt FPGA | Source | Destination | Default Condition | Voltage Standard |
|------|-------------|--------|---------------|--------------------|--------|-------------|-------------------|------------------|
| 1 | VCC_CORE | B5 | 1.0V | Power | DC-DC | FPGA | 1.0V | VCCINT |
| 2 | VCCO_BANK14 | C5 | 3.3V | Power | LDO | FPGA | 3.3V | VCCO_330 |
| 3 | VCCO_BANK15 | D5 | 1.8V | Power | LDO | FPGA | 1.8V | VCCO_180 |
| 4 | GND | A1 | 0V | Ground | GND_STAR | FPGA | 0V | GND |
| 5 | SYS_CLK_10M | H21 | 3.3V | Input | LMK1C1102 (Y2) | FPGA | Low | LVCMOS33 |
| 6 | FPGA_CLK_125M | J21 | 1.8V | Input | FMC+ OSC | FPGA | Low | LVCMOS18 |
| 7 | TCK | M2 | 3.3V | Input | FMC+ JTAG | FPGA | Low | LVCMOS33 |
| 8 | TDI | N2 | 3.3V | Input | FMC+ JTAG | FPGA | Low | LVCMOS33 |
| 9 | TDO | P2 | 3.3V | Output | FPGA | FMC+ JTAG | Low | LVCMOS33 |
| 10 | TMS | R2 | 3.3V | Input | FMC+ JTAG | FPGA | High | LVCMOS33 |
| 11 | FPGA_RESET_N | K22 | 3.3V | Input | FMC+ Reset Logic | FPGA | High (Active) | LVCMOS33 |
| 12 | POR_N | L22 | 3.3V | Output | FPGA | FMC+ Status | High | LVCMOS33 |
| 13 | UART_TX | T20 | 3.3V | Output | FPGA | FTDI RX | High | LVCMOS33 |
| 14 | UART_RX | T21 | 3.3V | Input | FTDI TX | FPGA | High | LVCMOS33 |
| 15 | UART_CTS | U20 | 3.3V | Output | FPGA | FTDI CTS | High | LVCMOS33 |
| 16 | UART_RTS | U21 | 3.3V | Input | FTDI RTS | FPGA | High | LVCMOS33 |
| 17 | SPI_CLK | V20 | 3.3V | Output | FPGA | Flash / PLLs | Low | LVCMOS33 |
| 18 | SPI_MOSI | V21 | 3.3V | Output | FPGA | Flash / PLLs | Low | LVCMOS33 |
| 19 | SPI_MISO | W20 | 3.3V | Input | Flash / PLLs | FPGA | Low | LVCMOS33 |
| 20 | SPI_CS_FLASH_N | W21 | 3.3V | Output | FPGA | AT25SL321 | High | LVCMOS33 |
| 21 | I2C_SCL | Y21 | 3.3V | Output | FPGA | TMP116 / ADM1177 | High (Open Drain) | LVCMOS33 |
| 22 | I2C_SDA | Y22 | 3.3V | Bidirectional | FPGA | TMP116 / ADM1177 | High (Open Drain) | LVCMOS33 |
| 23 | TRP | AA21 | 3.3V | Output | FPGA | RF Front-End | Low | LVCMOS33 |
| 24 | FPGA_DONE | AB22 | 3.3V | Output | FPGA | FMC+ Status | Low | LVCMOS33 |
| 25 | FPGA_INIT_N | AA22 | 3.3V | Bidirectional | FPGA | FMC+ Status | High | LVCMOS33 |
| 26 | LED_STATUS | Y20 | 3.3V | Output | FPGA | Onboard LED | Low | LVCMOS33 |
| 27 | SPI_CS_PLL1_N | U19 | 3.3V | Output | FPGA | ADF4106 (LO1) | High | LVCMOS33 |
| 28 | SPI_CS_PLL2_N | U18 | 3.3V | Output | FPGA | ADF4106 (LO2) | High | LVCMOS33 |
| 29 | ADC_D0A_P | T3 | 1.8V | Input | U9 (Ch1) | FPGA | Differential | LVDS_18 |
| 30 | ADC_D0A_N | T4 | 1.8V | Input | U9 (Ch1) | FPGA | Differential | LVDS_18 |
| 31 | ADC_D6A_P | N5 | 1.8V | Input | U9 (Ch1) | FPGA | Differential | LVDS_18 |
| 32 | ADC_D6A_N | N6 | 1.8V | Input | U9 (Ch1) | FPGA | Differential | LVDS_18 |
| 33 | ADC_D0B_P | V3 | 1.8V | Input | U9 (Ch2) | FPGA | Differential | LVDS_18 |
| 34 | ADC_D0B_N | V4 | 1.8V | Input | U9 (Ch2) | FPGA | Differential | LVDS_18 |
| 35 | ADC_CLK_OUT_P | H3 | 1.8V | Input | U9 | FPGA | Differential | LVDS_18 |
| 36 | ADC_CLK_OUT_N | H4 | 1.8V | Input | U9 | FPGA | Differential | LVDS_18 |
| 37 | ADC_SPI_CS_N | R20 | 1.8V | Output | FPGA | U9 | High | LVCMOS18 |
| 38 | ADC_SPI_SDO | R21 | 1.8V | Input | U9 | FPGA | Low | LVCMOS18 |
| 39 | ADC_SPI_SDI | R22 | 1.8V | Output | FPGA | U9 | Low | LVCMOS18 |
| 40 | ADC_OE_N | P20 | 1.8V | Output | FPGA | U9 | High | LVCMOS18 |
| 41 | PWR_PG_12V | P21 | 3.3V | Input | DC-DC PGOOD | FPGA | Low | LVCMOS33 |
| 42 | MODE_0 | P22 | 3.3V | Input | Pull-Down | FPGA | Low | LVCMOS33 |
| 43 | MODE_1 | N20 | 3.3V | Input | Pull-Down | FPGA | Low | LVCMOS33 |

---

## 9. Functional Specifications

**Summary table:**

| S.No. | Function Name | Description |
|-------|--------------|-------------|
| 1 | Serial Communication Interface | UART between PC & FPGA via USB-UART bridge |
| 2 | High Speed LVDS ADC Interface | Dual-channel 14-bit 170 MSPS ADC data reception via LVDS |
| 3 | Power Supply Sequencing & Health Status | DC-DC and LDO sequencing, TRP control, health monitoring |
| 4 | Supply Voltage, Current & Temperature Monitoring | I2C-based telemetry via ADM1177 and TMP116 |
| 5 | Flash Interfaces | Configuration flash via SPI for remote updates |
| 6 | TRP Configuration | Transmit/Receive Pulse for radar timing and RF front-end gating |
| 7 | FPGA Remote Programming | Bitstream update via UART host interface |
| 8 | PLL & VCO Controlling | Dual LO frequency synthesis control via SPI (3.3-7.3 GHz & 1.1 GHz) |
| 9 | Radar DSP Processing | DDC, Pulse Compression, and CFAR detection processing |

### 9.1 Serial Communication Interface
- **Interface type:** UART
- **Physical layer:** USB-UART bridge (FTDI FT232H)
- **Baud rate:** 115,200 bps (configurable via register)
- **Frame format:** 1 start bit, 8 data bits, 1 stop bit, no parity (8N1)
- **Signals:** UART_TX (FPGA → Host), UART_RX (Host → FPGA)
- **Protocol:** Custom register-based command/response protocol detailed in Section 11.

### 9.2 High Speed LVDS ADC Interface
- **ADC Part:** AD9643BCPZ-170
- **Channels:** 2 (Phase-coherent, matched path)
- **Sample Rate:** 170 MSPS per channel
- **Data Width:** 14 bits per channel, LVDS serialized
- **Interface:** 7 LVDS pairs per channel (DDR), + 1 LVDS bit-clock pair + 1 LVDS frame-clock pair per channel
- **Voltage Level:** 1.8V LVDS
- **FPGA Processing:** On-chip ISERDES (1:8 deserialization), cascaded to DSP pipeline for DDC.

### 9.3 Power On/Off Sequence
#### 9.3.1 Power ON/OFF Sequence
1. +12 VDC input detected — PWR_PG_12V asserted by DC-DC converter.
2. FPGA core voltage (1.0V) and aux (1.8V) ramp via on-board power supply.
3. FPGA DONE signal asserted after configuration bitstream load from Flash.
4. FPGA releases POR_N to system, enabling 3.3V LDOs for RF components.
5. PLLs programmed, LOs locked.
6. ADCs enabled (ADC_OE_N set LOW).
7. System READY — TRP logic enabled for radar timing.

#### 9.3.2 Mode Configuration
| Mode | MODE[1:0] | Description |
|------|-----------|-------------|
| Normal | 2'b00 | Active radar DSP mode, continuous LVDS capture and processing |
| Test | 2'b01 | Built-in self-test (BIST), ADC loopback, PRBS pattern test |
| Programming | 2'b10 | FPGA remote programming mode via UART |

### 9.4 Supply Voltage, Current & Temperature Monitoring
#### 9.4.1 Supply Voltage and Current Monitoring
- **IC Part Number:** ADM1177-1
- **Interface:** I2C (Address: 0x58)
- **Monitored rails:** +12V main supply, +3.3V digital rail
- **Current sensing:** High-side sense resistor on +12V rail (50 mΩ)
- **Measurement range:** 0 to 16.5V, 0 to 6A.
- **Accuracy:** Voltage ±1.5%, Current ±2%.

#### 9.4.2 Temperature Monitoring
- **IC Part Number:** TMP116
- **Interface:** I2C (Address: 0x48)
- **Temperature range:** -55°C to +125°C (military spec compliant)
- **Resolution:** 0.0078°C (16-bit)
- **Accuracy:** ±0.2°C (from -10°C to +85°C)
- **Alert threshold:** Programmable via I2C (Default high: +85°C, Low: -40°C).

### 9.5 Flash & Interfaces
#### 9.5.1 Configuration Flash
- **Part Number:** AT25SL321
- **Interface:** Standard SPI (up to 50 MHz)
- **Capacity:** 32 Mbit (4 MB)
- **Purpose:** Stores FPGA configuration bitstream for master SPI programming mode and remote updates.
- **Programming:** Initiated via UART command (Section 11).

#### 9.5.2 User EEPROM
- **Part Number:** 24AA025E48
- **Interface:** I2C (Address: 0x50)
- **Capacity:** 2 Kbit (256 bytes)
- **Purpose:** Stores board serial number, calibration coefficients (gain/phase vs freq), and IP addresses.

### 9.6 TRP Configuration
- **Signal:** TRP (Transmit/Receive Pulse)
- **Direction:** FPGA → RF Front-end limiters / protectors
- **Logic level:** 3.3V LVCMOS
- **Active state:** HIGH = RX mode enabled, LOW = RF protected / TX cycle
- **Timing:** Precision PRI generation in FPGA (staggered mode supported), minimum pulse width 100 ns.
- **Control:** Real-time automatic via PRI sequencer state machine; overridable via UART register.

### 9.7 FPGA Remote Programming
- **Protocol:** UART at 115,200 bps
- **Procedure:**
  1. Host sends programming command sequence via UART.
  2. FPGA halts radar DSP, enters programming mode (MODE=2'b10).
  3. Erase configuration flash sector via SPI.
  4. Bitstream transferred in 128-byte packets, written to AT25SL321.
  5. FPGA sends 0x06 (ACK) per packet.
  6. Host sends REBOOT command; FPGA asserts internal IPROG.
- **Fallback:** JTAG programming via FMC+ connector.

### 9.8 PLL & VCO Controlling
- **Control basis:** Commanded RF frequency (2-6 GHz) mapped to LO1 frequency (3.3-7.3 GHz).
- **PLL1 (LO1):** ADF4106BRUZ-RL, SPI (Polarity 0, Phase 0), SPI_CS_PLL1_N.
- **VCO1:** HMC586LC4BTR (4-8 GHz).
- **PLL2 (LO2):** ADF4106BRUZ-RL, SPI, SPI_CS_PLL2_N. Fixed at 1.1 GHz.
- **Update Rate:** Changed on a per-dwell or per-PRI basis.
- **Lock Detect:** Hardware pin routed to FPGA general I/O for lock status verification before TRP assertion.

### 9.9 Radar DSP Processing
- **DDC (Digital Downconverter):** NCO + complex mixer for shifting 200 MHz IF to baseband, followed by decimation filter (typical output 25 MSPS I/Q).
- **Pulse Compression:** Matched filter via FFT/IFFT (128 to 1024 point) utilizing DSP48E1 slices.
- **CFAR (Constant False Alarm Rate):** Cell-averaging CFAR (CA-CFAR) detection algorithm for target thresholding.
- **Outputs:** Processed target reports (Range, Doppler, Angle) output via FMC+ interface to host CPU.

---

## 10. Software Register Address Map

### 10.1 Register Base Addresses

| Block Name | Base Address | Address Range | Description |
|------------|-------------|---------------|-------------|
| System / Identification | 0x0000 | 0x0000–0x00FF | Board ID, firmware version, status, reset control |
| UART Control | 0x0100 | 0x0100–0x01FF | Baud rate, FIFO control, loopback, status |
| SPI Control | 0x0200 | 0x0200–0x02FF | SPI master control for flash and PLLs |
| I2C Control | 0x0300 | 0x0300–0x03FF | I2C master controller, prescaler, data, command |
| GPIO | 0x0400 | 0x0400–0x04FF | General purpose I/O, mode pins, misc control |
| PLL Control | 0x0500 | 0x0500–0x05FF | LO1/LO2 R, N, M dividers, lock status |
| Temperature Monitor | 0x0600 | 0x0600–0x06FF | TMP116 temp readings, alert config |
| Power Monitor | 0x0700 | 0x0700–0x07FF | ADM1177 voltage/current readings, alerts |
| Radar Control (RF) | 0x0800 | 0x0800–0x08FF | TRP control, PRI timing, stagger sequence |
| Flash Control | 0x0900 | 0x0900–0x09FF | Flash address, data, erase/program commands |
| Diagnostics | 0x0A00 | 0x0A00–0x0AFF | Built-in test, ADC PRBS check, fault log |

### 10.2 Detailed Register Map

**Block 0x0000 — System / Identification**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|--------------|-------|-----|-------------|----------------------|
| 0x00 | BOARD_ID | 16 | R | 0x0HJJ | ASCII board identification code (0x68 0x6A 0x6A 0x67 mapped to 16-bit halves) |
| 0x01 | FW_VERSION_MAJOR | 16 | R | 0x0001 | Firmware major version |
| 0x02 | FW_VERSION_MINOR | 16 | R | 0x0000 | Firmware minor version |
| 0x03 | SYS_STATUS | 16 | R | 0x0000 | [15:8] Reserved, [7] PLL1_LOCKED, [6] PLL2_LOCKED, [5] TEMP_ALERT, [4] VOLT_FAULT, [3] ADC_ACTIVE, [2:0] MODE_STATE |
| 0x04 | SYS_CTRL | 16 | R/W | 0x0000 | [0] SOFT_RESET, [1] WDT_ENABLE, [2] RF_ENABLE (TRP master enable), [3] ADC_EN |

**Block 0x0100 — UART Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|--------------|-------|-----|-------------|----------------------|
| 0x00 | BAUD_DIV | 16 | R/W | 0x0036 | Baud rate divisor = 125MHz / (16 × BAUD_RATE). Default 54 = ~115.2 kbps |
| 0x01 | UART_CTRL | 16 | R/W | 0x0001 | [0] UART_ENABLE, [1] LOOPBACK_EN, [2] CRC_EN |
| 0x02 | UART_STATUS | 16 | R | 0x0000 | [0] TX_BUSY, [1] RX_AVAIL, [2] RX_OVERRUN, [3] FRAME_ERR, [4] PARITY_ERR |
| 0x03 | TX_FIFO_COUNT | 16 | R | 0x0000 | Number of bytes in TX FIFO |
| 0x04 | RX_FIFO_COUNT | 16 | R | 0x0000 | Number of bytes in RX FIFO |

**Block 0x0200 — SPI Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|--------------|-------|-----|-------------|----------------------|
| 0x00 | SPI_CLK_DIV | 16 | R/W | 0x0002 | SPI clock divisor (FPGA_CLK / (2 × DIV)). Default = 2 (31.25 MHz) |
| 0x01 | SPI_CTRL | 16 | R/W | 0x0000 | [0] SPI_START_XFER, [1] SPI_BUSY (R), [2] CPOL, [3] CPHA, [4] MSB_FIRST |
| 0x02 | SPI_CS_SEL | 16 | R/W | 0x0001 | [0] CS_FLASH_EN, [1] CS_PLL1_EN, [2] CS_PLL2_EN, [3] CS_ADC_EN |
| 0x03 | SPI_TX_DATA | 16 | R/W | 0x0000 | TX data payload (8 or 16-bit transfer) |
| 0x04 | SPI_RX_DATA | 16 | R | 0x0000 | RX data payload read-back |

**Block 0x0300 — I2C Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|--------------|-------|-----|-------------|----------------------|
| 0x00 | I2C_CLK_PRESCALE | 16 | R/W | 0x009C | I2C prescaler for 400 kHz at 125 MHz clk (~156) |
| 0x01 | I2C_CTRL | 16 | R/W | 0x0000 | [0] I2C_EN, [1] I2C_START, [2] I2C_STOP, [3] I2C_READ, [4] I2C_WRITE, [5] I2C_ACK |
| 0x02 | I2C_STATUS | 16 | R | 0x0000 | [0] I2C_BUSY, [1] RX_DATA_VALID, [2] ACK_RECEIVED, [3] ARB_LOST |
| 0x03 | I2C_DEV_ADDR | 16 | R/W | 0x0000 | [7:1] 7-bit I2C address (e.g. 0x48 for TMP116), [0] R/W bit |
| 0x04 | I2C_TX_DATA | 16 | R/W | 0x0000 | TX data payload (8-bit) |
| 0x05 | I2C_RX_DATA | 16 | R | 0x0000 | RX data payload read-back (8-bit) |

**Block 0x0400 — GPIO**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|--------------|-------|-----|-------------|----------------------|
| 0x00 | GPIO_OUTPUT | 16 | R/W | 0x0000 | [0] LED_STATUS, [1] ADC_OE_N, [2] POR_N |
| 0x01 | GPIO_INPUT | 16 | R | 0x0000 | [0] MODE_0, [1] MODE_1, [2] PWR_PG_12V |
| 0x02 | GPIO_DIR | 16 | R/W | 0x0005 | Direction bit per GPIO (1=OUT, 0=IN). Default: outputs enabled |

**Block 0x0500 — PLL Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|--------------|-------|-----|-------------|----------------------|
| 0x00 | LO1_R_DIV | 16 | R/W | 0x0001 | LO1 PLL R divider (default 1 for 10 MHz ref) |
| 0x01 | LO1_N_DIV | 16 | R/W | 0x0220 | LO1 PLL N divider (integer part). Default 544 for 5.44 GHz |
| 0x02 | LO1_CTRL | 16 | R/W | 0x0000 | [0] LO1_PLL_EN, [1] LO1_PLL_RESET, [2] LO1_RF_EN |
| 0x03 | LO1_STATUS | 16 | R | 0x0000 | [0] LO1_LOCKED, [1] LO1_LOSS_OF_LOCK |
| 0x04 | LO2_R_DIV | 16 | R/W | 0x0001 | LO2 PLL R divider (default 1) |
| 0x05 | LO2_N_DIV | 16 | R/W | 0x006E | LO2 PLL N divider. Default 110 for 1.1 GHz |
| 0x06 | LO2_CTRL | 16 | R/W | 0x0000 | [0] LO2_PLL_EN, [1] LO2_PLL_RESET, [2] LO2_RF_EN |
| 0x07 | LO2_STATUS | 16 | R | 0x0000 | [0] LO2_LOCKED, [1] LO2_LOSS_OF_LOCK |
| 0x08 | PLL_APPLY | 16 | R/W | 0x0000 | [0] WRITE_PULSE - auto-clears, triggers shadow register transfer to PLLs |

**Block 0x0600 — Temperature Monitor**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|--------------|-------|-----|-------------|----------------------|
| 0x00 | TEMP_RAW | 16 | R | 0x0000 | 16-bit raw temperature from TMP116 (0.0078°C LSB) |
| 0x01 | TEMP_DEGREES_X10 | 16 | R | 0x0000 | Scaled temperature in 0.1°C units (e.g., 25.0°C = 250) |
| 0x02 | TEMP_ALERT_HIGH | 16 | R/W | 0x0D48 | High alert threshold (Default +85°C) |
| 0x03 | TEMP_ALERT_LOW | 16 | R/W | 0xFC18 | Low alert threshold (Default -40°C, twos complement) |
| 0x04 | TEMP_STATUS | 16 | R | 0x0000 | [0] ALERT_ACTIVE, [1] SENSOR_FAULT |

**Block 0x0700 — Power Monitor**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|--------------|-------|-----|-------------|----------------------|
| 0x00 | VOLTAGE_12V_RAW | 16 | R | 0x0000 | 12V supply raw ADC reading via ADM1177 |
| 0x00 | VOLTAGE_12V_MV | 16 | R | 0x0000 | Scaled 12V supply in millivolts |
| 0x02 | CURRENT_12V_RAW | 16 | R | 0x0000 | 12V supply raw current reading via ADM1177 |
| 0x03 | CURRENT_12V_MA | 16 | R | 0x0000 | Scaled 12V supply current in milliamps |
| 0x04 | PWR_STATUS | 16 | R | 0x0000 | [0] V12_FAULT, [1] I12_OVERCURRENT, [2] PG_12V_STATE, [3] V33_STATE |

**Block 0x0800 — Radar Control (RF)**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|--------------|-------|-----|-------------|----------------------|
| 0x00 | TRP_CTRL | 16 | R/W | 0x0000 | [0] TRP_MANUAL_EN, [1] TRP_AUTO_EN, [2] TRP_POLARITY |
| 0x01 | TRP_MANUAL_STATE | 16 | R/W | 0x0000 | [0] TRP_STATE (Manual override. 1=RX ON, 0=RX OFF) |
| 0x02 | PRI_PERIOD_CLKS | 16 | R/W | 0x00C8 | PRI period in FPGA clock cycles (125 MHz). Default 200 (1.6 µs) |
| 0x03 | PRI_PULSE_WIDTH | 16 | R/W | 0x000D | TRP pulse width in clock cycles. Default 13 (~100 ns) |
| 0x04 | STAGGER_EN | 16 | R/W | 0x0000 | [0] STAGGER_ENABLE |
| 0x05 | STAGGER_IDX | 16 | R/W | 0x0000 | Current index in stagger table (0-7) |
| 0x06 | STAGGER_TABLE_0 | 16 | R/W | 0x00C8 | Stagger PRI value 0 (clocks) |
| 0x07 | STAGGER_TABLE_1 | 16 | R/W | 0x00D0 | Stagger PRI value 1 (clocks) |
| 0x08 | STAGGER_TABLE_2 | 16 | R/W | 0x00D6 | Stagger PRI value 2 (clocks) |
| 0x09 | STAGGER_TABLE_3 | 16 | R/W | 0x00E4 | Stagger PRI value 3 (clocks) |
| 0x0A | DDC_NCO_FREQ | 16 | R/W | 0x0199 | DDC tuning word for 200 MHz IF (Freq = NCO*Clk/2^16) |

**Block 0x0900 — Flash Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|--------------|-------|-----|-------------|----------------------|
| 0x00 | FLASH_ADDR | 16 | R/W | 0x0000 | 16-bit byte address for flash read/write operations |
| 0x01 | FLASH_DATA | 16 | R/W | 0x0000 | 16-bit data payload for flash read/write operations |
| 0x02 | FLASH_CMD | 16 | R/W | 0x0000 | [0] WRITE_CMD, [1] READ_CMD, [2] ERASE_SECTOR, [3] ERASE_BULK |
| 0x03 | FLASH_STATUS | 16 | R | 0x0000 | [0] BUSY, [1] WRITE_ERROR, [2] ERASE_ERROR, [7] FW_UPDATE_DONE |
| 0x04 | FLASH_PROG_TRIGGER | 16 | R/W | 0x0000 | [0] REBOOT_FPGA - Initiate FPGA reconfiguration from new bitstream |

**Block 0x0A00 — Diagnostics**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|--------------|-------|-----|-------------|----------------------|
| 0x00 | DIAG_CTRL | 16 | R/W | 0x0000 | [0] ADC_LOOPBACK_EN, [1] ADC_PRBS_EN, [2] SELF_TEST_START |
| 0x01 | ADC_PRBS_ERR_CNT_CH1 | 16 | R | 0x0000 | PRBS error count for ADC Channel 1 |
| 0x02 | ADC_PRBS_ERR_CNT_CH2 | 16 | R | 0x0000 | PRBS error count for ADC Channel 2 |
| 0x03 | UPTIME_COUNTER | 16 | R | 0x0000 | System uptime in seconds (rolls over at 65535) |
| 0x04 | FAULT_LOG | 16 | R | 0x0000 | Latched fault flags [0]=TEMP, [1]=PWR, [2]=PLL1, [3]=PLL2 |
| 0x05 | BIST_RESULT | 16 | R | 0x0000 | [0] DSP_RAM_PASS, [1] DSP_MATH_PASS, [2] LVDS_LINK_PASS |

### 10.3 Register Access Rules
- All registers are 16-bit wide; accessed via UART Single/Bulk Read/Write protocol (Section 11).
- Read: set bit15 of address byte (address OR 0x8000).
- Write: address as-is (bit15 = 0).
- Shadow registers: PLL dividers (Block 0x0500) are double-buffered. Writing to `PLL_APPLY` (0x0508) triggers a simultaneous synchronous update of LO1 and LO2 PLL registers over SPI to prevent frequency glitching.
- Atomic access: Bulk Write is used for multi-register atomic updates (e.g., changing PRI_PULSE_WIDTH and PRI_PERIOD_CLKS simultaneously).

---

## 11. UART Register Protocol Specification

### 11.1 Physical Layer
- Baud rate: 115,200 bps (configurable via UART_CTRL.BAUD_DIV)
- Frame format: 1 start bit, 8 data bits, 1 stop bit, no parity (8N1)
- Physical interface: USB-UART (FTDI FT232H) bridging host PC to FPGA UART pins
- Signal levels: 3.3V LVCMOS on PCB, USB on host side

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
  - Address out of valid range
  - Write to read-only register
  - Parser timeout (inter-byte gap > 50ms)
```

### 11.3 Protocol Timing Constraints
| Parameter | Min | Typical | Max | Unit |
|-----------|-----|---------|-----|------|
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

| Resource | Available | Estimated Usage | Utilization % |
|---------|-----------|----------------|--------------|
| Slice LUTs | 202,800 | 62,000 | 30.5% |
| Slice Flip-Flops | 202,800 | 45,000 | 22.1% |
| Block RAM (36Kb) | 325 | 98 | 30.1% |
| DSP Slices | 600 | 210 | 35.0% |
| MMCM/PLL | 10 | 3 | 30.0% |
| I/O Buffers | 400 | 65 | 16.2% |

- **Synthesis tool:** Vivado 2024.1
- **Target device:** XC7K160T-1FBG676C
- **Timing constraint:** 125.000 MHz primary system clock; 170.000 MHz LVDS bit-clock constraint (per ADC channel)
- **Note:** DSP utilization is dominated by dual-channel Pulse Compression FFTs and DDC decimation FIR chains. BRAM is utilized primarily for LVDS input deserialization FIFOs, CFAR windowing buffers, and stagger PRI history storage.

---

## Annexure A — Requirement Traceability Matrix

| S.No. | GLR-ID | Description | Source HRS Section | GLR Section | Verification Method | Status |
|-------|--------|-------------|-------------------|-------------|--------------------|--------|
| 1 | GLR-001 | Serial Communication Interface | HRS §3.3 | 9.1, 11 | Test | Open |
| 2 | GLR-002 | High Speed LVDS ADC Interface | HRS §3.2 (REQ-HW-015) | 9.2 | Test | Open |
| 3 | GLR-003 | Power Supply Sequencing & Health | HRS §3.2 (REQ-HW-022) | 9.3 | Test | Open |
| 4 | GLR-004 | Voltage/Current/Temperature Monitoring | HRS §3.2 (REQ-HW-022) | 9.4 | Test | Open |
| 5 | GLR-005 | Flash & Configuration Interfaces | HRS §3.3 | 9.5 | Test | Open |
| 6 | GLR-006 | TRP Configuration & PRI Timing | HRS §3.1 (REQ-HW-017) | 9.6 | Inspection | Open |
| 7 | GLR-007 | FPGA Remote Programming | HRS §3.3 | 9.7 | Demonstration | Open |
| 8 | GLR-008 | PLL/VCO Controlling (LO1/LO2) | HRS §3.2 (REQ-HW-014) | 9.8 | Test | Open |
| 9 | GLR-009 | Radar DSP (DDC/PC/CFAR) | HRS §3.1 (REQ-HW-017, REQ-HW-018) | 9.9 | Analysis | Open |
| 10 | GLR-010 | Register Address Map | HRS §3.3 | 10 | Inspection | Open |
| 11 | GLR-011 | UART Protocol Specification | HRS §3.3 | 11 | Test | Open |
| 12 | GLR-012 | FPGA Resource Budget | HRS §3.2 | 12 | Analysis | Open |
| 13 | GLR-013 | Dual-Channel Phase Coherence | HRS §3.1 (REQ-HW-012) | 9.2, 9.8 | Test | Open |
| 14 | GLR-014 | Double-IF Architecture Support | HRS §3.1 (REQ-HW-013) | 9.8 | Inspection | Open |
| 15 | GLR-015 | Military Temp Range Support | HRS §3.2 | 9.4, 6 | Test | Open |