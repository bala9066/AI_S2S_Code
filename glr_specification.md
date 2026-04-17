
# Glue Logic Requirements (GLR)

## Document Control
| Document Title | Glue Logic Requirements |
| :--- | :--- |
| Version Date | 17.04.2026 |
| Version Number | 0V01 |
| Prepared By | Name: . Sign: |
| Document Review By | Name: . Sign: |

---

## Amendments to the Document
| S. No. | Ver. No. | Ver. Date | Changed By | Section(s) Changed | Description of Change |
|:---:|:---:|:---:|:---:|:---|:---|
| 1 | 0V01 | 17.04.2026 | - | - | Initial Version |

---

## 1. Scope of the Document
This document explains the IO details and functional requirements of the FPGA for **Test (Wideband RF Receiver System)**. Targeted audience: Hardware Design and Firmware teams.

It bridges the Hardware Requirements Specification (HRS) and the Netlist with the FPGA HDL Design (RTL Development). It defines the pin-level interfaces, timing constraints, register map for the embedded control logic, and the communication protocol required for system operation.

---

## 2. References

### 2.1 External
| Doc. Type | Part No. | Description |
|:---|:---|:---|
| Datasheet | ADC12DJ5200RF | 12-bit/14-bit, 10.25 GSPS RF Sampling ADC, JESD204B/C Interface |
| Datasheet | QPC9054 | 0.25 dB Step, 31.75 dB Range Digital Step Attenuator, DC to 18 GHz |
| Datasheet | LMK61E2 | Ultra-Low Jitter Oscillator/Frequency Synthesizer |
| Datasheet | HMC698LP4 | GaAs MMIC Amplifier, 6-20 GHz |
| Datasheet | STM32F407VGT6 | High-Performance MCUs, DSP, FPU |
| Datasheet | TPS62913 | 4-A, 24-V Input, Synchronous Step-Down Converter |
| Datasheet | TPS7A47 | 20-V, 1-A, Low-Noise, LDO |
| Datasheet | TPS7A8300 | 20-V, 3-A, Low-Noise, Fast-Response LDO |

### 2.2 Internal
| Reference | Document |
|:---|:---|
| [HRS] | Hardware Requirements Specification (P2) |
| [SCH] | Schematic (P4) |
| [GRS] | General Requirements Specification |
| [GDD] | General Design Document |

---

## 3. Acronyms and Abbreviations
| Acronym | Expansion |
|:---|:---|
| **ADC** | Analog-to-Digital Converter |
| **AGC** | Automatic Gain Control |
| **BOM** | Bill of Materials |
| **BRAM** | Block RAM (FPGA Memory) |
| **CLB** | Configurable Logic Block |
| **CML** | Current Mode Logic |
| **DAC** | Digital-to-Analog Converter (if applicable in future) |
| **DMA** | Direct Memory Access |
| **DSP** | Digital Signal Processing |
| **DSA** | Digital Step Attenuator |
| **EMC** | Electromagnetic Compatibility |
| **FIFO** | First-In, First-Out Buffer |
| **FF** | Flip-Flop |
| **FPGA** | Field-Programmable Gate Array |
| **FSM** | Finite State Machine |
| **GND** | Ground |
| **HDL** | Hardware Description Language |
| **I2C** | Inter-Integrated Circuit |
| **IO** | Input/Output |
| **JESD** | JESD204 Standard (High-speed data converter interface) |
| **LVDS** | Low-Voltage Differential Signaling |
| **LUT** | Look-Up Table |
| **MCU** | Microcontroller Unit |
| **PCB** | Printed Circuit Board |
| **PLL** | Phase-Locked Loop |
| **RF** | Radio Frequency |
| **RoHS** | Restriction of Hazardous Substances |
| **RTL** | Register Transfer Level |
| **SFDR** | Spurious-Free Dynamic Range |
| **SNR** | Signal-to-Noise Ratio |
| **SPI** | Serial Peripheral Interface |
| **UART** | Universal Asynchronous Receiver-Transmitter |
| **VCC** | Voltage Common Collector (Supply) |
| **VCO** | Voltage-Controlled Oscillator |

---

## 4. Module Overview

The hardware module is a Wideband RF Receiver System designed for direct sampling of signals from 5 GHz to 18 GHz.

**RF SECTION:**
The RF chain consists of an SMA input connector (J1) feeding a wideband Low Noise Amplifier **HMC698LP4 (U1)**. The output of the LNA is conditioned by a **QPC9054 (U2)** Digital Step Attenuator (DSA) to provide programmable gain control (0–40 dB range). The signal passes through a wideband balun **EGL-2422-SM (T1)** to convert single-ended RF to differential signals suitable for the ADC.

**DIGITAL SECTION:**
The core digitization is performed by the **ADC12DJ5200RF (U3)**, a dual-channel 12-bit/14-bit RF sampling ADC capable of >5 GS/s. It outputs data via a JESD204B/C high-speed serial interface (JESD204B_CKP/N) to the FPGA (System-on-Chip / FPGA). The system is controlled by an **STM32F407VGT6 (U8)** MCU which manages the SPI configuration of the ADC and DSA, and communicates with the host system. The clock source is the **LMK61E2 (U4)** providing ultra-low jitter reference.

**POWER SUPPLY SECTION:**
The system is powered from a single 5V DC input. A **TPS62913 (U5)** Buck converter steps this down to 3.3V for the DSA and Clock. An LDO **TPS7A47 (U6)** generates 1.8V for analog interfaces and IO. A high-current LDO **TPS7A8300 (U7)** provides the 1.0V core rail required by the high-speed ADC.

---

## 5. Features
*   **FPGA/SoC**: Acts as the JESD204B/C Receiver and Data Processing engine (Implicit in System Diagram, treated as "FPGA" for GLR scope).
*   **System Control MCU**: STM32F407VGT6 for register configuration and housekeeping.
*   **RF Front-End**: 5–18 GHz coverage using HMC698LP4 LNA.
*   **Gain Control**: 0.25 dB step resolution via QPC9054 DSA.
*   **High-Speed ADC**: ADC12DJ5200RF supporting up to 10.25 GSPS.
*   **Data Interface**: JESD204B/C (Sub-Class 1 or similar) output via LVDS.
*   **Clocking**: LMK61E2 Ultra-low jitter clock generator (<100 fs RMS).
*   **Power Management**: Distributed rails (5V, 3.3V, 1.8V, 1.0V) with TPS62913/7A47/7A8300.
*   **Control Interface**: SPI (via MCU) for ADC and DSA control; UART for host communication.

---

## 6. FPGA Description
*Note: While the hardware platform uses an STM32F407, the GLR document addresses the Logic Requirements for the programmable logic receiving the high-speed data (the "FPGA" function in the signal chain).*

| S.NO | PARAMETERS | SPECIFICATION |
|:---:|:---|:---|
| 1 | Part Number | **System-on-Module / FPGA** (Implied Platform for JESD204B Rx) |
| 2 | Logic Cells | 100k - 500k (Minimum for JESD204B IP + Buffering) |
| 3 | CLB Flip-Flops | [specify] by selected FPGA (e.g., Kintex-7 or Artix-7 class) |
| 4 | Number of Gates | > 5 Million |
| 5 | Maximum Distributed RAM (Kb) | 500+ Kb |
| 6 | Total Block RAM (Kb) | 1000+ Kb (Required for high-speed data buffering) |
| 7 | Maximum Single-Ended I/Os | 200+ |
| 8 | Maximum DSP Slices | 200+ (For Digital Down-Conversion optional logic) |
| 9 | No of IO Bank | 4+ |

---

## 7. Block Diagram
(Reference to block diagram — described in text)
The system comprises an RF Input Chain (LNA + DSA + Balun) feeding an ADC. The ADC sends serial data lanes (JESD204B_CKP/N) to the Logic Device. The Control MCU (STM32) bridges the SPI commands from a Host/UART to the ADC/DSA peripherals. The Power tree supplies 5V->3.3V->1.8V/1.0V rails.

---

## 8. Pinout Details

**Table: FPGA / Logic Interface Pin Out Details**
*Note: This table maps the signals from the Netlist (P4) to the Logic/FPGA boundary pins.*

| S.No | Signal Name | Pin No | Voltage Level | Direction wrt Logic | Source | Destination | Default Condition | Voltage Standard |
|:---:|:---|:---:|:---:|:---:|:---|:---|:---|:---|
| 1 | **JESD204B_CKP** | E1 | 1.8V | INPUT | ADC (U3) | Logic Device | Idle | LVDS / CML |
| 2 | **JESD204B_CKN** | E2 | 1.8V | INPUT | ADC (U3) | Logic Device | Idle | LVDS / CML |
| 3 | **ADC_CLK_IN_P** | D1 | 1.8V | INPUT | Clock Gen (U4) | Logic Device | Clock | LVDS |
| 4 | **ADC_CLK_IN_N** | D2 | 1.8V | INPUT | Clock Gen (U4) | Logic Device | Clock | LVDS |
| 5 | **SPI_SCLK_ADC** | B1 | 3.3V | OUTPUT | MCU (U8) | ADC (U3) | Low | LVCMOS33 |
| 6 | **SPI_MOSI_ADC** | B2 | 3.3V | OUTPUT | MCU (U8) | ADC (U3) | Low | LVCMOS33 |
| 7 | **SPI_MISO_ADC** | B3 | 3.3V | INPUT | ADC (U3) | MCU (U8) | High-Z | LVCMOS33 |
| 8 | **SPI_CS_ADC_N** | B4 | 3.3V | OUTPUT | MCU (U8) | ADC (U3) | High | LVCMOS33 |
| 9 | **SPI_SCLK_DSA** | C1 | 3.3V | OUTPUT | MCU (U8) | DSA (U2) | Low | LVCMOS33 |
| 10 | **SPI_MOSI_DSA** | C2 | 3.3V | OUTPUT | MCU (U8) | DSA (U2) | Low | LVCMOS33 |
| 11 | **SPI_CS_DSA_N** | C3 | 3.3V | OUTPUT | MCU (U8) | DSA (U2) | High | LVCMOS33 |
| 12 | **UART_TX** | A1 | 3.3V | OUTPUT | MCU (U8) | Host / Debugger | High | LVCMOS33 |
| 13 | **UART_RX** | A2 | 3.3V | INPUT | Host / Debugger | MCU (U8) | High-Z | LVCMOS33 |
| 14 | **RESET_N** | A3 | 3.3V | INPUT | System / Supervisor | Logic Device | High | LVCMOS33 |
| 15 | **VCC_1V0** | - | 1.0V | POWER | LDO (U7) | FPGA Core | - | - |
| 16 | **VCC_1V8** | - | 1.8V | POWER | LDO (U6) | FPGA IO/JESD | - | - |
| 17 | **VCC_3V3** | - | 3.3V | POWER | Buck (U5) | FPGA IO | - | - |
| 18 | **GND** | - | 0V | GND | Common | Logic Device | - | - |
| 19 | **GPIO_LNA_EN** | F1 | 3.3V | OUTPUT | MCU (U8) | LNA Power SW | Low | LVCMOS33 |
| 20 | **ADC_PD_N** | F2 | 3.3V | OUTPUT | MCU (U8) | ADC (U3) | High | LVCMOS33 |
| 21 | **SYS_CLK_REF** | D3 | 3.3V | INPUT | Oscillator | Logic Device | Clock | LVCMOS33 |
| 22 | **LED_STATUS** | G1 | 3.3V | OUTPUT | Logic Device | LED (Green) | Low | LVCMOS33 |
| 23 | **LED_ERROR** | G2 | 3.3V | OUTPUT | Logic Device | LED (Red) | Low | LVCMOS33 |
| 24 | **TEMP_ALERT** | H1 | 3.3V | INPUT | Sensor | MCU / Logic | Low | LVCMOS33 |
| 25 | **PGOOD_3V3** | H2 | 3.3V | INPUT | PMIC (U5) | MCU / Logic | High | LVCMOS33 |
| 26 | **PGOOD_1V8** | H3 | 1.8V | INPUT | PMIC (U6) | MCU / Logic | High | LVCMOS18 |
| 27 | **PGOOD_1V0** | H4 | 1.0V | INPUT | PMIC (U7) | MCU / Logic | High | LVCMOS18 |
| 28 | **JTAG_TCK** | J1 | 3.3V | INPUT | Debugger | Logic Device | Low | LVCMOS33 |
| 29 | **JTAG_TDI** | J2 | 3.3V | INPUT | Debugger | Logic Device | High-Z | LVCMOS33 |
| 30 | **JTAG_TDO** | J3 | 3.3V | OUTPUT | Logic Device | Debugger | High-Z | LVCMOS33 |
| 31 | **JTAG_TMS** | J4 | 3.3V | INPUT | Debugger | Logic Device | High | LVCMOS33 |
| 32 | **ADC_SYNC_N** | K1 | 1.8V | OUTPUT | Logic Device | ADC (U3) | High | LVCMOS18 |
| 33 | **LMK_SYNC** | K2 | 3.3V | OUTPUT | MCU (U8) | Clk Gen (U4) | High | LVCMOS33 |
| 34 | **I2C_SCL** | L1 | 3.3V | BIDIR | MCU (U8) | EEPROM/Monitor | High | I2C |
| 35 | **I2C_SDA** | L2 | 3.3V | BIDIR | MCU (U8) | EEPROM/Monitor | High | I2C |

---

## 9. Functional Specifications

**Summary table first:**

| S.No. | Function Name | Description |
|:---:|:---|:---|
| 1 | Serial Communication Interface | UART between Host PC & MCU (UART1). |
| 2 | High Speed Communication Interface | JESD204B/C (Lane 0) for ADC sample data. |
| 3 | Power Supply Sequencing & Health Status | 5V -> 3.3V -> 1.8V -> 1.0V sequencing monitoring via PGOOD pins. |
| 4 | Supply Voltage, Current & Temperature Monitoring | I2C monitoring of PMICs and onboard sensors. |
| 5 | Flash Interfaces | SPI Flash (Boot) and EEPROM (Calib) via MCU or FPGA. |
| 6 | RF Control | DSA Attenuation & LNA Enable control. |
| 7 | FPGA Remote Programming | Bitstream loading via UART/System Bootloader. |
| 8 | Phase Shifter Controlling | N/A (Direct RF Architecture) |
| 9 | Beam Steering Calculation | N/A (Single Channel Receiver) |
| 10 | High Speed Data Capture | Capturing >5 GSPS data to internal BRAM/DMA. |

Then provide DETAILED subsections:

### 9.1 Serial Communication Interface
- **Interface type:** UART
- **Physical layer:** TTL (3.3V) - Translated to USB on Host side.
- **Baud rate:** 115200 bps (Boot) / 12 Mbps (App Configurable)
- **Frame format:** 1 start bit, 8 data bits, 1 stop bit, no parity (8N1)
- **USB-UART converter IC:** External Debugger (ST-Link) or On-board (Optional)
- **Signals:** UART_TX (MCU → Host), UART_RX (Host → MCU)
- **Protocol:** Custom register-based command/response (defined in Section 11).

### 9.2 High Speed Communication Interface
- **Interface:** JESD204B / JESD204C
- **Number of lanes:** 1 Lane (C_P/N)
- **Data rate:** Up to 10.25 Gbps (line rate).
- **Protocol:** JESD204B Subclass 1 (SYSREF alignment).
- **Physical:** AC-coupled LVDS inputs on FPGA.
- **Scrambling:** Enabled (standard for JESD204B).

### 9.3 Power On/Off Sequence
#### 9.3.1 Power ON/OFF Sequence
Step-by-step sequence:
1.  **Input Supply (+5V) applied**. U5 (Buck) enabled.
2.  **3.3V Rail (U5) ramps up**. MCU starts.
3.  **1.8V Rail (U6) ramps up**. Powers IO and Clock distribution.
4.  **1.0V Rail (U7) ramps up**. Powers ADC Core.
5.  **PGOOD assertion**: Monitor pins (PGOOD_1V0, etc.) go High.
6.  **FPGA/MCU Init**: Release Reset_N.
7.  **Configuration**: Loads bitstream/calibration.
8.  **RF Enable**: Assert LNA_EN, set DSA to safe default.

#### 9.3.2 Mode Configuration
| Mode | Signal | Value | Description |
|:---|:---|:---|:---|
| Normal | OPMODE[1:0] | 2'b00 | High-speed data acquisition mode |
| Diagnostics | OPMODE[1:0] | 2'b01 | Loopback / PRBS generation |
| Sleep | OPMODE[1:0] | 2'b10 | Low power, RF chain disabled |

### 9.4 Supply Voltage, Current & Temperature Monitoring
#### 9.4.1 Supply Voltage and Current Monitoring
- **Monitoring Method**: PMIC Telemetry (via I2C) or Dedicated ADC channels in MCU (STM32F407).
- **Interface**: Internal ADC or I2C.
- **Monitored rails**: 5V, 3.3V, 1.8V, 1.0V.
- **Measurement range**: 0 to 6V, 0 to 5A.
- **Resolution**: 12-bit (MCU ADC).

#### 9.4.2 Temperature Monitoring
- **Sensor**: Internal STM32 Temperature Sensor or External I2C sensor (if fitted).
- **Interface**: I2C / Internal ADC.
- **Temperature range**: -40°C to +85°C.
- **Alert threshold**: +70°C (Force gain reduction / shutdown).

### 9.5 Flash & Interfaces
#### 9.5.1 Configuration Flash (FPGA)
- **Interface**: QSPI/SPI.
- **Purpose**: Stores FPGA bitstream (if using external flash) or Firmware.

#### 9.5.2 Storage Flash (User)
- **Part Number**: Generic SPI EEPROM (e.g., M24M02).
- **Interface**: I2C/SPI.
- **Capacity**: 256 Kb - 1 Mb.
- **Purpose**: Stores DSA calibration tables, temperature coefficients, serial number.

### 9.6 RF Control
- **Components**: QPC9054 (DSA), HMC698LP4 (LNA).
- **Interface**: SPI (CS_DSA, MOSI, SCLK).
- **LNA Control**: GPIO (LNA_EN).
- **Logic level**: 3.3V LVTTL.
- **Operation**:
  - Write 8-bit / 16-bit words to DSA to set attenuation (0.25 dB steps).
  - Sync attenuation with frequency hopping if needed.

### 9.7 FPGA Remote Programming
- **Protocol**: UART / DFU (STM32).
- **Procedure**:
  1. Host commands MCU to enter Programming Mode.
  2. Host sends bitstream/calib data packets.
  3. MCU writes to SPI Flash / EEPROM.
  4. MCU triggers FPGA Reset / Reboot.

### 9.8 High Speed Data Capture & Buffering
- **Source**: ADC12DJ5200RF.
- **Interface**: JESD204B IP Core inside FPGA.
- **Processing**:
  - Descramble & Lane alignment.
  - Deframing (8b/10b decode if applicable, or raw bit unpacking).
  - Convert 14-bit ADC samples to 16-bit (sign extension).
  - Write to DDR Memory or BRAM FIFO.

---

## 10. Software Register Address Map

This section defines the registers exposed by the MCU/FPGA firmware to the Host via the UART protocol.

### 10.1 Register Base Addresses

| Block Name | Base Address | Address Range | Description |
|------------|-------------|---------------|-------------|
| System / Identification | 0x0000 | 0x0000–0x00FF | Board ID, firmware version, status |
| UART Control | 0x0100 | 0x0100–0x01FF | Baud rate, FIFO control |
| SPI Control | 0x0200 | 0x0200–0x02FF | SPI master, DSA/ADC chip-select |
| I2C Control | 0x0300 | 0x0300–0x03FF | I2C master, PMIC control |
| GPIO | 0x0400 | 0x0400–0x04FF | LED, LNA Enable, Resets |
| PLL / Clock Control | 0x0500 | 0x0500–0x05FF | LMK61E2 config, ADC SYSREF |
| ADC Config | 0x0600 | 0x0600–0x06FF | ADC12DJ5200RF SPI bridge |
| RF Control | 0x0700 | 0x0700–0x07FF | QPC9054 DSA Gain settings |
| Data Capture | 0x0800 | 0x0800–0x08FF | Trigger, Buffer Size, Transfer |
| Diagnostics | 0x0A00 | 0x0A00–0x0AFF | Fault log, uptime, temperature |

### 10.2 Detailed Register Map

**Block 0x0000 — System / Identification**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|--------------|-------|-----|-------------|----------------------|
| 0x00 | BOARD_ID | 16 | R | 0xA5A5 | [15:0] Board Identifier (Wideband Rx) |
| 0x01 | FW_VERSION_MAJOR | 16 | R | 0x0001 | Firmware major version |
| 0x02 | FW_VERSION_MINOR | 16 | R | 0x0000 | Firmware minor version |
| 0x03 | SYS_STATUS | 16 | R | 0x0000 | [15:8] Reserved, [7] PGOOD_1V0, [6] PGOOD_1V8, [5] PGOOD_3V3, [4] JESD_LINK, [3] TEMP_ALERT, [2:0] Reserved |
| 0x04 | SYS_RESET | 16 | W | 0x0000 | [0] SOFT_RESET (Self-clearing) |
| 0x05 | OPMODE_SEL | 16 | R/W | 0x0000 | [1:0] 00=Normal, 01=Diag, 10=Sleep |

**Block 0x0700 — RF Control (QPC9054 DSA)**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|--------------|-------|-----|-------------|----------------------|
| 0x00 | DSA_ATTENUATION | 16 | R/W | 0x0000 | [7:0] Attenuation setting (0.25dB steps, 0=max gain, 127=max attenuation) |
| 0x01 | DSA_LOAD | 16 | W | 0x0000 | [0] Load Shadow Register to Hardware (Latch) |
| 0x02 | LNA_ENABLE | 16 | R/W | 0x0000 | [0] LNA Power Enable (1=On) |
| 0x03 | RF_GAIN_LOOKUP | 16 | R/W | 0x0000 | [15:0] Index for gain lookup table |

**Block 0x0800 — Data Capture Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|--------------|-------|-----|-------------|----------------------|
| 0x00 | CAPTURE_CTRL | 16 | R/W | 0x0000 | [0] START_CAP, [1] STOP_CAP, [2] RESET_FIFO |
| 0x01 | TRIG_MODE | 16 | R/W | 0x0000 | [1:0] 00=Immediate, 01=Software, 10=External Trigger |
| 0x02 | CAPTURE_LEN | 16 | R/W | 0x0400 | Number of samples to capture (Max 64k) |
| 0x03 | DATA_ADDR | 16 | R | 0x0000 | [15:0] Pointer to data buffer start |

**(Other blocks follow similar structure...)**

---

## 11. UART Register Protocol Specification

This section provides the EXACT byte-level frame format for the UART register protocol implemented by the STM32F407 firmware.

### 11.1 Physical Layer
- Baud rate: 115200 (Default), up to 3 Mbps (High-speed).
- Frame format: 1 start bit, 8 data bits, 1 stop bit, no parity (8N1).
- Physical interface: 3.3V CMOS logic.

### 11.2 Command Frame Formats

**Single Register Write (CMD = 0x57 'W'):**
```
Byte 0: 0x57 (CMD)
Byte 1: ADDR[15:8] (address MSB)
Byte 2: ADDR[7:0]  (address LSB)
Byte 3: DATA[15:8] (data MSB)
Byte 4: DATA[7:0]  (data LSB)
→ Response: 0x06 (ACK) within 2ms, or 0x15 (NAK) on error
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
→ Response: 0x06 (ACK) within 10ms, or 0x15 (NAK)
Total frame: (4 + 2N) bytes TX, 1 byte RX
```

**Bulk Register Read (CMD = 0x62 'b'):**
```
Byte 0: 0x62 (CMD)
Byte 1: (ADDR[15:8] | 0x80)  (MSB with read bit set)
Byte 2: ADDR[7:0]             (start address LSB)
Byte 3: N                     (register count, 1–64)
→ Response: DATA[0]_H, DATA[0]_L, ..., DATA[N-1]_H, DATA[N-1]_L within 10ms
Total frame: 4 bytes TX, 2N bytes RX
```

**Error Response:**
```
0x15 (NAK) — sent by Firmware when:
  - CMD byte not recognized
  - Address out of valid range
  - Write to read-only register
  - Checksum mismatch (if enabled)
```

### 11.3 Protocol Timing Constraints
| Parameter | Min | Typical | Max | Unit |
|-----------|-----|---------|-----|------|
| Inter-byte gap (TX side) | 0 | - | 50 | ms |
| Single Write response time | - | 1 | 5 | ms |
| Single Read response time | - | 1 | 5 | ms |
| Bulk Write response time (N=64) | - | 5 | 10 | ms |
| Bulk Read response time (N=64) | - | 5 | 10 | ms |
| Parser reset on timeout | 50 | - | - | ms |

### 11.4 Software Implementation Notes
```c
// Firmware register write wrapper
#define SYS_CTRL_WRITE(addr, data)    UART_WriteReg((uint16_t)(addr), (uint16_t)(data))
// Firmware register read wrapper
#define SYS_CTRL_READ(addr, pdata)    UART_ReadReg((uint16_t)(addr) | 0x8000U, (pdata))

// Block registers by base address
#define REG_SYS_BASE    (0x0000U)
#define REG_RF_BASE     (0x0700U)
#define REG_DATA_BASE   (0x0800U)
```

---

## 12. FPGA Resource Utilization Estimate

| Resource | Available | Estimated Usage | Utilization % |
|---------|-----------|----------------|--------------|
| Slice LUTs | 50,400 (XC7K70T) | 18,500 | 36% |
| Slice Flip-Flops | 100,800 | 25,000 | 24% |
| Block RAM (36Kb) | 240 | 80 | 33% |
| DSP Slices | 240 | 10 | 4% |
| MMCM/PLL | 10 | 2 | 20% |
| I/O Buffers | 200 | 60 | 30% |

*Synthesis tool: Vivado 2025.1*
*Target device: Kintex-7 XC7K70T-FBG484 (or equivalent class)*
*Timing constraint: 156.25 MHz (JESD20b Lane Rate / 20)*

---

## Annexure A — Requirement Traceability Matrix

| S.No | GLR-ID | Description | Source HRS Section | GLR Section | Verification Method | Status |
|-------|--------|-------------|-------------------|-------------|--------------------|----|
| 1 | GLR-001 | RF Input Frequency Range 5-18 GHz | HRS §3.2 REQ-HW-001 | 4, 8 | Test | Open |
| 2 | GLR-002 | Input Power Range -80 to -40 dBm | HRS §3.2 REQ-HW-002 | 9.6 | Test | Open |
| 3 | GLR-003 | Noise Figure < 10 dB | HRS §3.2 REQ-HW-003 | 4 | Test | Open |
| 4 | GLR-004 | ADC Sampling Rate >5 GS/s | HRS §3.2 REQ-HW-004 | 9.2, 12 | Analysis | Open |
| 5 | GLR-005 | ADC Resolution 14-bit | HRS §3.2 REQ-HW-005 | 9.2 | Inspection | Open |
| 6 | GLR-006 | Supply Voltage 5V Single | HRS §3.1 REQ-HW-006 | 9.3 | Test | Open |
| 7 | GLR-007 | Gain Control 0-40 dB | HRS §3.2 REQ-HW-008 | 9.6 | Test | Open |
| 8 | GLR-008 | JESD204B Interface | HRS §3.4 REQ-HW-009 | 9.2 | Test | Open |
| 9 | GLR-009 | SPI Control Interface | HRS §3.4 REQ-HW-010 | 9.5, 10 | Inspection | Open |
| 10 | GLR-010 | Operating Temperature 0-70°C | HRS §3.3 REQ-HW-007 | 9.4 | Test | Open |
| 11 | GLR-011 | PCB Material Rogers | HRS §3.3 REQ-HW-013 | 4 | Inspection | Open |
| 12 | GLR-012 | Register Address Map | Derived | 10 | Inspection | Open |
| 13 | GLR-013 | UART Protocol Spec | Derived | 11 | Test | Open |
| 14 | GLR-014 | Power Monitoring | HRS §3.1 REQ-HW-014 | 9.4 | Test | Open |