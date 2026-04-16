# Glue Logic Requirements (GLR)

## Document Control
| Document Title | Glue Logic Requirements |
| :--- | :--- |
| Version Date | 16.04.2026 |
| Version Number | 0V01 |
| Prepared By | Name: . Sign: |
| Document Review By | Name: . Sign: |

---

## Amendments to the Document
| S. No. | Ver. No. | Ver. Date | Changed By | Section(s) Changed | Description of Change |
|:---:|:---:|:---:|:---:|:---|:---|
| 1 | 0V01 | 16.04.2026 | - | - | Initial Version |

---

## 1. Scope of the Document
This document explains the IO details and functional requirements of the **STM32F407VGT6** Microcontroller and its associated glue logic for the **ehg** Wideband RF Receiver project. It bridges the gap between the Hardware Requirements Specification (HRS) and the Firmware Design.

Targeted audience: Firmware Engineers, Hardware Design Engineers, and System Integration teams.

---

## 2. References

### 2.1 External
| Doc. Type | Part No. | Description |
|:---|:---|:---|
| Datasheet | HMC8141 | GaAs MMIC LNA, 6-20 GHz |
| Datasheet | HMC698LP4 | Digital VGA, DC-6 GHz |
| Datasheet | HMC-CMS19 | Double-balanced Mixer, 6-18 GHz |
| Datasheet | HMC5805 | High-dynamic range VGA, DC-1 GHz |
| Datasheet | EV10AQ190A | Quad-channel 10-bit ADC, 5 GSps |
| Datasheet | PKM4716TCD15 | Isolated DC-DC Converter |
| Datasheet | LT1086-5 | 5V LDO Regulator |
| Datasheet | LT1086-3.3 | 3.3V LDO Regulator |
| Datasheet | LT6656-2.5 | Voltage Reference (2.5V) |
| Datasheet | Si5345B-D | Clock Generator |
| Datasheet | ADCLK914 | Clock Buffer |
| Datasheet | STM32F407VGT6 | High Performance MCU |
| Datasheet | M24M02-DR | 2Mbit EEPROM |

### 2.2 Internal
| Reference | Document |
|:---|:---|
| [HRS] | Hardware Requirements Specification |
| [SCH] | Schematic |
| [GRS] | General Requirements Specification |
| [GDD] | General Design Document |

---

## 3. Acronyms and Abbreviations
| Acronym | Expansion |
|:---|:---|
| **ADC** | Analog to Digital Converter |
| **AGC** | Automatic Gain Control |
| **CPLD** | Complex Programmable Logic Device |
| **DC** | Direct Current |
| **DMA** | Direct Memory Access |
| **DSP** | Digital Signal Processing |
| **EMC** | Electromagnetic Compatibility |
| **FIFO** | First In First Out |
| **FPGA** | Field Programmable Gate Array |
| **GPIO** | General Purpose Input/Output |
| **HRS** | Hardware Requirements Specification |
| **I2C** | Inter-Integrated Circuit |
| **IF** | Intermediate Frequency |
| **IP3** | Third Order Intercept Point |
| **LNA** | Low Noise Amplifier |
| **LUT** | Look Up Table |
| **LVDS** | Low Voltage Differential Signaling |
| **MCU** | Microcontroller Unit |
| **PCB** | Printed Circuit Board |
| **PLL** | Phase Locked Loop |
| **RF** | Radio Frequency |
| **SFDR** | Spurious Free Dynamic Range |
| **SPI** | Serial Peripheral Interface |
| **UART** | Universal Asynchronous Receiver Transmitter |
| **VGA** | Variable Gain Amplifier |

---

## 4. Module Overview

### 4.1 RF SECTION
The RF chain processes signals from 5-18 GHz. It consists of:
1.  **Wideband LNA (HMC8141):** Provides 20 dB gain and 3 dB noise figure.
2.  **RF VGA (HMC698LP4):** Provides digital gain control (30 dB range) via SPI.
3.  **Mixer (HMC-CMS19):** Downconverts RF to IF using an external LO (not on this board, but signal is conditioned).
4.  **IF Amplifier (HMC5805):** Amplifies the IF signal before digitization.

### 4.2 DIGITAL SECTION
The digital core is the **STM32F407VGT6**. It controls the RF chain:
*   **Control Logic:** Configures VGA gain, mixer enables, and ADC settings via SPI/I2C.
*   **Clocking:** Manages the Si5345B-D clock generator and ADCLK914 buffer.
*   **Data Interface:** The **EV10AQ190A ADC** outputs LVDS data (D0-D3, DCLK) directly to the backplane (J2), but the MCU configures the ADC via a 3-wire serial interface.
*   **Communication:** Host interface via UART (configuring registers).

### 4.3 POWER SUPPLY SECTION
*   **Input:** +28V DC (MIL-STD).
*   **Conversion:** PKM4716TCD15 converts +28V to +15V isolated.
*   **Regulation:**
    *   LT1086-5: Regulates to +5V for RF components (LNA, Mixer, VGA, IF Amp).
    *   LT1086-3.3: Regulates to +3.3V for Digital components (MCU, EEPROM, Clock, ADC logic).

---

## 5. Features
*   **MCU:** STM32F407VGT6 (ARM Cortex-M4, 168 MHz, 1MB Flash).
*   **High-Speed ADC Interface:** Support for EV10AQ190A (5 GSps) configuration and monitoring.
*   **Clock Generation:** Control of Si5345B-D (Quad Clock Generator) via I2C.
*   **Gain Control:** SPI interface to HMC698LP4 (VGA) for 30 dB digital gain range.
*   **Non-Volatile Memory:** M24M02-DR (2 Mbit) EEPROM via I2C for calibration storage.
*   **Power Management:** Control and monitoring of DC-DC converter enable signal.
*   **Debug Interface:** SWD (Serial Wire Debug) for firmware programming.
*   **Status Indication:** LED_STATUS control.

---

## 6. Microcontroller Description
While typically this section describes an FPGA, for this project, the glue logic is primarily handled by the STM32F407VGT6 MCU.

| S.NO | PARAMETERS | SPECIFICATION |
|:---:|:---|:---|
| 1 | Part Number | STM32F407VGT6 |
| 2 | Core | ARM Cortex-M4F |
| 3 | Max Frequency | 168 MHz |
| 4 | Flash Memory | 1024 KB |
| 5 | SRAM | 192 KB (128+16+64) |
| 6 | GPIO Count | 140 |
| 7 | SPI Interfaces | 3 |
| 8 | I2C Interfaces | 3 |
| 9 | UART Interfaces | 6 |
| 10 | Timers | 14 (Advanced, General, Basic) |
| 11 | Package | LQFP100 |

---

## 7. Block Diagram
The logical flow consists of the **Host PC** communicating via **UART** to the **STM32F407**. The STM32 configures the **RF Chain** (via SPI to VGA) and **Clock Gen** (via I2C). It also initializes the **ADC** (via 3-wire SPI). The **Power Supply** sequencing is handled by the MCU enabling the DC-DC converter.

---

## 8. Pinout Details

**Table: MCU/Logic Pin Out Details**

| S.No | Signal Name | MCU Pin / FPGA Pin | Voltage Level | Direction wrt MCU | Source | Destination | Default Condition | Voltage Standard |
|:---:|:---|:---|:---:|:---|:---|:---|:---|:---|
| 1 | VCC_3V3_DIG | 100 | 3.3V | PWR | LDO_3V3 | MCU/Core | ON | LVCMOS33 |
| 2 | GND | - | 0V | GND | LDO_3V3 | MCU/Core | GND | GND |
| 3 | RESET_NRST | 14 | 3.3V | IN | External | NRST_C | Pull High | LVCMOS33 |
| 4 | BOOT0 | 94 | 3.3V | IN | R3 | MCU_BOOT0 | Low (GND) | LVCMOS33 |
| 5 | SPI_SCK | PA5 | 3.3V | OUT | MCU | HMC698LP4 (SCK) | Low | LVCMOS33 |
| 6 | SPI_MOSI | PA7 | 3.3V | OUT | MCU | HMC698LP4 (SDI) | Low | LVCMOS33 |
| 7 | SPI_MISO | PA6 | 3.3V | IN | HMC698LP4 (SDO) | MCU | High Z | LVCMOS33 |
| 8 | VGA_CS | PA4 | 3.3V | OUT | MCU | HMC698LP4 (CS) | High | LVCMOS33 |
| 9 | AGC_ENABLE | PB1 | 3.3V | OUT | MCU | HMC698LP4 (CTRL) | Low | LVCMOS33 |
| 10 | I2C_SCL | PB6 | 3.3V | BIDIR | MCU | Si5345, EEPROM | High (OD) | I2C |
| 11 | I2C_SDA | PB7 | 3.3V | BIDIR | MCU | Si5345, EEPROM | High (OD) | I2C |
| 12 | ADC_SDIO | PB15 | 3.3V | BIDIR | MCU | EV10AQ190A (SDIO) | High Z | LVCMOS33 |
| 13 | ADC_CS_N | PB12 | 3.3V | OUT | MCU | EV10AQ190A (CS_N) | High | LVCMOS33 |
| 14 | ADC_SCK | PB13 | 3.3V | OUT | MCU | EV10AQ190A (SCK) | Low | LVCMOS33 |
| 15 | ADC_RST_N | PC4 | 3.3V | OUT | MCU | EV10AQ190A (RST_N) | High | LVCMOS33 |
| 16 | ADC_OE_N | PC5 | 3.3V | OUT | MCU | EV10AQ190A (OE_N) | High (Disabled) | LVCMOS33 |
| 17 | EN_DCDC | PC0 | 3.3V | OUT | MCU | PKM4716TCD15 (EN) | High (Enabled) | LVCMOS33 |
| 18 | CLK_OE | PC1 | 3.3V | OUT | MCU | ADCLK914 (OE) | High (Enabled) | LVCMOS33 |
| 19 | EEPROM_WP | PC2 | 3.3V | OUT | MCU | M24M02 (WP) | Low (Unlocked) | LVCMOS33 |
| 20 | LED_STATUS | PA8 | 3.3V | OUT | MCU | R14 (LED Anode) | Low | LVCMOS33 |
| 21 | UART_TX | PA9 | 3.3V | OUT | MCU | Host PC (RX) | High | LVCMOS33 |
| 22 | UART_RX | PA10 | 3.3V | IN | Host PC (TX) | MCU | High Z | LVCMOS33 |
| 23 | SWDIO | PA13 | 3.3V | BIDIR | Debugger | MCU | High Z | LVCMOS33 |
| 24 | SWCLK | PA14 | 3.3V | IN | Debugger | MCU | High Z | LVCMOS33 |
| 25 | VCC_28V_MON | PC3 | 3.3V | IN | Divider (R12/R13) | MCU ADC | - | Analog 0-3.3V |
| 26 | RF_TEMP_MON | PC5 | 3.3V | IN | Sensor/Divider | MCU ADC | - | Analog 0-3.3V |
| 27 | LVDS_D0_P | J2 Pin 1 | N/A | PASS | EV10AQ190A | BACKPLANE | Differential | LVDS |
| 28 | LVDS_D0_N | J2 Pin 2 | N/A | PASS | EV10AQ190A | BACKPLANE | Differential | LVDS |
| 29 | LVDS_D1_P | J2 Pin 3 | N/A | PASS | EV10AQ190A | BACKPLANE | Differential | LVDS |
| 30 | LVDS_D1_N | J2 Pin 4 | N/A | PASS | EV10AQ190A | BACKPLANE | Differential | LVDS |
| 31 | LVDS_DCLK_P | J2 Pin 9 | N/A | PASS | EV10AQ190A | BACKPLANE | Differential | LVDS |
| 32 | LVDS_DCLK_N | J2 Pin 10 | N/A | PASS | EV10AQ190A | BACKPLANE | Differential | LVDS |
| 33 | 5V_RF_LNA | N/A | 5.0V | PWR | U7 | U1 | ON | Analog |
| 34 | 15V_DCDC | N/A | 15.0V | PWR | U6 | U7 | ON | Analog |
| 35 | VREF_2V5 | N/A | 2.5V | PWR | U9 | U5 | ON | Analog |

---

## 9. Functional Specifications

**Summary table first:**

| S.No. | Function Name | Description |
|:---:|:---|:---|
| 1 | Serial Control Interface | UART between PC & MCU (RS422/RS232 levels external to board) |
| 2 | RF Gain Control | SPI interface to HMC698LP4 for 30 dB gain range |
| 3 | Clock Management | I2C configuration of Si5345B-D and buffering via ADCLK914 |
| 4 | Power Supply Sequencing | Control of DC-DC Enable and monitoring of 28V input |
| 5 | ADC Configuration | 3-wire serial setup of EV10AQ190A sampling parameters |
| 6 | Data Routing | LVDS output buffering from ADC to connector J2 |
| 7 | EEPROM Storage | Storage of calibration tables and gain settings |
| 8 | Temperature Monitoring | Analog monitoring of board/RF temperature |
| 9 | LED Status Indicator | Visual feedback of system state |

### 9.1 Serial Communication Interface
*   **Interface type:** UART
*   **Physical layer:** TTL (3.3V CMOS) on board. External circuitry (not on BOM) must convert to RS-485/RS-422 for long haul.
*   **Baud rate:** 115200 bps (Default), Configurable up to 921600.
*   **Frame format:** 1 start bit, 8 data bits, 1 stop bit, no parity (8N1).
*   **Signals:** UART_TX (MCU → PC), UART_RX (PC → MCU).
*   **Protocol:** Register-based command/response (Detailed in Section 11).

### 9.2 High Speed Communication Interface (Data Path)
*   **Interface:** LVDS (Low Voltage Differential Signaling).
*   **Source:** EV10AQ190A (U5).
*   **Destination:** SAMTEC Connector J2.
*   **Data Lines:** D0[7:0], D1[7:0], D2[7:0], D3[7:0] (Mapped to LVDS outputs D0-D3 pairs).
*   **Clock:** DCLK_P/N (Synchronous to data).
*   **Rate:** 5 Gbps data rate per lane (corresponding to 5 GSps sampling).

### 9.3 Power On/Off Sequence
#### 9.3.1 Power ON/OFF Sequence
1.  **Input Applied:** +28V DC applied to J3.
2.  **MCU Boot:** Internal LDOs generate 1.8V/3.3V. STM32 starts execution.
3.  **Enable DC-DC:** MCU asserts `EN_DCDC` (High). PKM4716TCD15 enables +15V rail.
4.  **Enable LDOs:** +15V flows to LT1086-5 (+5V) and LT1086-3.3 (+3.3V logic).
5.  **ADC Ramp:** +5V and +3.3V stabilize. MCU waits for `VREF_2V5` stable.
6.  **Configuration:** MCU writes configuration to EV10AQ190A via SPI.
7.  **Data Enable:** MCU asserts `ADC_OE_N` (Low) to enable LVDS outputs.
8.  **RF Enable:** MCU sets `AGC_ENABLE` to apply bias to LNA/VGA.

#### 9.3.2 Mode Configuration
| Mode | Signal | Value | Description |
|:---|:---|:---|:---|
| Normal | `ADC_RST_N` | HIGH | ADC Operational |
| Reset | `ADC_RST_N` | LOW | ADC in Reset |
| Low Power | `ADC_OE_N` | HIGH | LVDS Outputs Disabled (High Z) |
| Programming | `BOOT0` | HIGH | STM32 DFU Mode |

### 9.4 Supply Voltage, Current & Temperature Monitoring
#### 9.4.1 Supply Voltage Monitoring
*   **Method:** Resistive divider (R12, R13) feeding MCU ADC1 channel.
*   **Range:** 0-40V (scaled to 0-3.3V).
*   **Resolution:** 12-bit ADC (STM32 internal).
*   **Monitored Rail:** +28V Input.

#### 9.4.2 Temperature Monitoring
*   **Method:** Analog sensor (e.g., NTC or TMP36 - not explicitly in BOM but assumed or using PA4 as `RF_TEMP_MON` net) feeding MCU ADC.
*   **Range:** -55°C to +125°C.
*   **Alert:** If temperature > +110°C, MCU asserts `LED_STATUS` fast blink and disables RF amplifiers.

### 9.5 Flash & Interfaces
#### 9.5.1 EEPROM (User/Calib)
*   **Part Number:** M24M02-DR (2 Mbit).
*   **Interface:** I2C (Address 0xA0/0xA1).
*   **Purpose:** Stores gain calibration tables, LUTs for VGA attenuation vs frequency.
*   **Write Protect:** Controlled by `EEPROM_WP` pin.

### 9.6 RF Control (AGC)
*   **Component:** HMC698LP4.
*   **Interface:** SPI (Mode 0 or 3).
*   **Function:** Sets attenuation in 1 dB steps (0 to -30 dB).
*   **Algorithm:** Software calculates gain required based on RSSI (if available) or user setpoint. MCU sends 8-bit command via SPI.

### 9.7 FPGA/MCU Remote Programming
*   **Protocol:** UART Bootloader (DFU).
*   **Trigger:** `BOOT0` pin high + Reset.
*   **Procedure:** Host sends new firmware image via UART (typically at 115200 baud).

### 9.8 Phase Shifter Controlling
*   *N/A for this specific BOM.* The Mixer (HMC-CMS19) is passive and does not require phase control logic beyond LO frequency selection.

### 9.9 Beam Steering Calculation
*   *N/A.* This is a receiver module.

### 9.10 Gate Voltage Writing in DAC
*   *N/A.* The HMC698LP4 is a digital VGA controlled via SPI, not an analog DAC gate.

---

## 10. Software Register Address Map

### 10.1 Register Base Addresses

| Block Name | Base Address | Address Range | Description |
|:---|:---:|:---:|:---|
| System / Identification | 0x0000 | 0x0000–0x00FF | Board ID, firmware version, status |
| UART Control | 0x0100 | 0x0100–0x01FF | Baud rate, FIFO control, status |
| SPI Control | 0x0200 | 0x0200–0x02FF | SPI master, chip-select control |
| I2C Control | 0x0300 | 0x0300–0x03FF | I2C master, device address, data |
| GPIO | 0x0400 | 0x0400–0x04FF | General purpose I/O control |
| Clock Control | 0x0500 | 0x0500–0x05FF | Si5345 config, CLK buffer enables |
| ADC Control | 0x0600 | 0x0600–0x06FF | EV10AQ190A config, enable, reset |
| RF Control | 0x0700 | 0x0700–0x07FF | VGA Gain, AGC settings |
| EEPROM | 0x0800 | 0x0800–0x08FF | EEPROM address, data, command |
| Diagnostics | 0x0900 | 0x0900–0x09FF | Fault log, uptime counter, ADC input mon |

### 10.2 Detailed Register Map

**Block 0x0000 — System / Identification**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|:---|:---|:---:|:---:|:---:|:---|
| 0x00 | BOARD_ID | 16 | R | 0xE410 | Board identifier code (Project: EHG) |
| 0x01 | FW_VERSION_MAJOR | 16 | R | 0x0001 | Firmware major version |
| 0x02 | FW_VERSION_MINOR | 16 | R | 0x0000 | Firmware minor version |
| 0x03 | SYS_STATUS | 16 | R | 0x0000 | [15:4] Reserved, [3] DCDC_OK, [2] TEMP_OK, [1] ADC_LOCK, [0] PLL_LOCK |
| 0x04 | SYS_CTRL | 16 | R/W | 0x0000 | [0] SOFT_RESET, [1] RF_ENABLE, [2] LED_OVERRIDE |

**Block 0x0100 — UART Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|:---|:---|:---:|:---:|:---:|:---|
| 0x00 | BAUD_DIV | 16 | R/W | 0x0036 | Baud rate divisor (Default 115200) |
| 0x01 | UART_CTRL | 16 | R/W | 0x0001 | [0] UART_ENABLE, [1] LOOPBACK_EN |
| 0x02 | UART_STATUS | 16 | R | 0x0000 | [0] TX_BUSY, [1] RX_AVAIL, [2] PARITY_ERR |

**Block 0x0600 — ADC Control (EV10AQ190A)**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|:---|:---|:---:|:---:|:---:|:---|
| 0x00 | ADC_CTRL | 16 | R/W | 0x0000 | [0] ADC_RST_N, [1] ADC_OE_N, [2] START_CONV |
| 0x01 | ADC_CONFIG | 16 | R/W | 0x0004 | [2:0] MODE (000=Single, 111=Quad 5:1) |
| 0x02 | ADC_GAIN | 16 | R/W | 0x0000 | Gain correction offset |
| 0x03 | ADC_STATUS | 16 | R | 0x0000 | [0] OR_FLAG (Over-range) |

**Block 0x0700 — RF Control (VGA)**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|:---|:---|:---:|:---:|:---:|:---|
| 0x00 | VGA_GAIN | 16 | R/W | 0x0000 | [4:0] Gain setting (0-30 dB) |
| 0x01 | AGC_ENABLE | 16 | R/W | 0x0000 | [0] AGC Loop Enable |
| 0x02 | VGA_STATUS | 16 | R | 0x0000 | [0] VGA_PRESENT (Ack from SPI) |

**Block 0x0500 — Clock Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|:---|:---|:---:|:---:|:---:|:---|
| 0x00 | CLK_SEL | 16 | R/W | 0x0001 | [0] CLK_BUF_OE (ADCLK914) |
| 0x01 | CLK_FREQ | 16 | R/W | 0x0BB8 | Target Frequency (MHz multiplier) |

---

## 11. UART Register Protocol Specification

This section provides the EXACT byte-level frame format for the UART register protocol. Firmware MUST implement this exactly.

### 11.1 Physical Layer
*   **Baud rate:** 115200 bps (Configurable).
*   **Frame format:** 1 start bit, 8 data bits, 1 stop bit, no parity (8N1).
*   **Signal levels:** 3.3V LVCMOS.

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
0x15 (NAK) — sent by MCU when:
  - CMD byte not recognized
  - Address out of valid range
  - Write to read-only register
  - Parser timeout (inter-byte gap > 50ms)
```

### 11.3 Protocol Timing Constraints
| Parameter | Min | Typical | Max | Unit |
|:---|:---:|:---:|:---:|:---:|
| Inter-byte gap (TX side) | — | — | 50 | ms |
| Single Write response time | — | 0.5 | 1 | ms |
| Single Read response time | — | 1 | 2 | ms |
| Bulk Write response time (N=64) | — | 3 | 5 | ms |
| Bulk Read response time (N=64) | — | 3 | 5 | ms |
| Parser reset on timeout | 50 | — | — | ms |

---

## 12. FPGA/MCU Resource Utilization Estimate

*Note: Since the active controller is the STM32F407, this section estimates the firmware resource load on the MCU (Flash/RAM usage) rather than FPGA resources.*

| Resource | Available | Estimated Usage | Utilization % |
|:---|:---:|:---:|:---:|
| Flash Memory (Code) | 1024 KB | 128 KB | 12.5% |
| SRAM (Data/Stack) | 192 KB | 32 KB | 16.6% |
| IO Pins Used | 140 | 35 | 25% |
| Timers Used | 14 | 2 | 14% |
| UART Interfaces | 6 | 1 | 16% |
| SPI Interfaces | 3 | 2 | 66% |
| I2C Interfaces | 3 | 1 | 33% |

*Development Tool:* STM32CubeIDE (GCC)
*Target Device:* STM32F407VGT6
*Timing Constraint:* 168 MHz System Clock

---

## Annexure A — Requirement Traceability Matrix

| S.No | GLR-ID | Description | Source HRS Section | GLR Section | Verification Method | Status |
|:---:|:---|:---|:---|:---|:---|:---|
| 1 | GLR-001 | Frequency Range Support | HRS §2.1 | 4.1 | Test | Open |
| 2 | GLR-002 | Noise Figure & Gain | HRS §3.2 | 9.6 | Test | Open |
| 3 | GLR-003 | ADC Sampling Rate | HRS §3.2 | 9.2 | Test | Open |
| 4 | GLR-004 | LVDS Output Interface | HRS §3.3 | 9.2 | Test | Open |
| 5 | GLR-005 | Power Supply Sequencing | HRS §3.1 | 9.3 | Test | Open |
| 6 | GLR-006 | 28V Input Monitoring | HRS §3.1 | 9.4 | Test | Open |
| 7 | GLR-007 | Temperature Range (-55 to +125) | HRS §3.4 | 9.4 | Test | Open |
| 8 | GLR-008 | MIL-STD Compliance | HRS §3.4 | 4.3 | Analysis | Open |
| 9 | GLR-009 | RF Input Return Loss | HRS §3.2 | 4.1 | Test | Open |
| 10 | GLR-010 | SPI Interface to VGA | HRS §3.1 | 9.6 | Inspection | Open |
| 11 | GLR-011 | UART Register Protocol | HRS §3.1 | 11 | Test | Open |
| 12 | GLR-012 | Control Loop / AGC | HRS §3.1 | 9.6 | Demonstration | Open |