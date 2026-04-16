# Glue Logic Requirements (GLR)

## Document Control
| Document Title | Glue Logic Requirements |
| Version Date | 16.04.2026 |
| Version Number | 0V01 |
| Prepared By | Name: . Sign: |
| Document Review By | Name: . Sign: |

---

## Amendments to the Document
| S. No. | Ver. No. | Ver. Date | Changed By | Section(s) Changed | Description of Change |
| 1 | 0V01 | 16.04.2026 | - | - | Initial Version |

---

## 1. Scope of the Document
This document explains the IO details and functional requirements of the FPGA for **j,fj (Wideband RF Receiver Module)**. Targeted audience: Hardware Design and Firmware teams.

---

## 2. References

### 2.1 External
| Doc. Type | Part No. | Description |
|---|---|---|
| Datasheet | HMC1113LP3DE | 2-20 GHz GaAs MMIC PHEMT LNA |
| Datasheet | HMC1056LP4BE | 6-26 GHz GaAs MMIC Mixer |
| Datasheet | HMC699LP4 | DC-6 GHz VGA |
| Datasheet | ADF5356 | Microwave Wideband Synthesizer |
| Datasheet | ADC12DJ3200 | 12/14-bit Dual-Channel 6.4/12.8 GSPS ADC |
| Datasheet | LTC7138 | 5V to 3.3V Buck Converter |
| Datasheet | TPS7A4700 | 3.3V to 1.8V/1.0V LDO |
| Datasheet | SN65LVDS16 | LVDS Line Driver |
| Datasheet | AT24CS02 | 2Kb I2C EEPROM |
| Datasheet | XCZU9EG | (Example) Zynq UltraScale+ FPGA (Target for Logic) |

### 2.2 Internal
| Reference | Document |
| [HRS] | Hardware Requirements Specification (j,fj) |
| [SCH] | Schematic (j,fj) |
| [GRS] | General Requirements Specification |
| [GDD] | General Design Document |

---

## 3. Acronyms and Abbreviations
| Acronym | Expansion |
|---|---|
| **ADC** | Analog-to-Digital Converter |
| **BOM** | Bill of Materials |
| **BRAM** | Block RAM |
| **CLB** | Configurable Logic Block |
| **CML** | Current Mode Logic |
| **DAC** | Digital-to-Analog Converter |
| **DSP** | Digital Signal Processing |
| **EMC** | Electromagnetic Compatibility |
| **ESD** | Electrostatic Discharge |
| **FF** | Flip-Flop |
| **FIFO** | First-In-First-Out |
| **FPGA** | Field Programmable Gate Array |
| **GND** | Ground |
| **GPIO** | General Purpose Input/Output |
| **HDL** | Hardware Description Language |
| **HRS** | Hardware Requirements Specification |
| **I2C** | Inter-Integrated Circuit |
| **IF** | Intermediate Frequency |
| **JTAG** | Joint Test Action Group |
| **LVDS** | Low-Voltage Differential Signaling |
| **LUT** | Look-Up Table |
| **LNA** | Low Noise Amplifier |
| **LO** | Local Oscillator |
| **OS** | Operating System |
| **PCB** | Printed Circuit Board |
| **PLL** | Phase-Locked Loop |
| **RF** | Radio Frequency |
| **RoHS** | Restriction of Hazardous Substances |
| **RTL** | Register Transfer Level |
| **SPI** | Serial Peripheral Interface |
| **UART** | Universal Asynchronous Receiver-Transmitter |
| **VCC** | Voltage Common Collector |
| **VCO** | Voltage-Controlled Oscillator |

---

## 4. Module Overview

**RF SECTION:**
The RF chain comprises the **HMC1113LP3DE** LNA for low-noise amplification (4.5-18.5 GHz), followed by the **HMC1056LP4BE** Mixer for downconversion. Frequency mixing is driven by the **ADF5356** wideband synthesizer. The IF signal is conditioned by the **HMC699LP4** VGA before digitization. ESD protection is handled by the **HMC1061LP3DE** limiter.

**DIGITAL SECTION:**
The system digitizes the IF signal using the **ADC12DJ3200** (14-bit, 4 GSPS) operating in single-channel mode. Data is buffered via **SN65LVDS16** drivers and transmitted to a host FPGA. System control includes an **AT24CS02** EEPROM for non-volatile storage and an SPI bus for configuring the LO, VGA, and ADC.

**POWER SUPPLY SECTION:**
Power regulation starts with a 5V DC input. The **LTC7138** bucks this to 3.3V. The **TPS7A4700** LDOs generate 1.8V and 1.0V rails from the 3.3V rail to supply the ADC core and digital logic, ensuring low noise for sensitive analog circuitry.

---

## 5. Features
- **FPGA/Controller:** Xilinx Zynq UltraScale+ (or equivalent logic device)
- **On-board Clock:** Derived from ADF5356 Synthesizer reference or external oscillator
- **Communication:** UART for console/config (115200 bps), SPI for component control (up to 20 MHz), I2C for EEPROM
- **JTAG:** Dedicated debugging port
- **EEPROM:** AT24CS02 (2Kb) for MAC address / calibration storage
- **RF Control:** High-speed SPI for ADF5356 LO and HMC699LP4 VGA gain control
- **Data Interface:** 8-bit LVDS bus (via SN65LVDS16) at up to 400 MHz DDR (Data Rate: 800 Mbps)
- **Power Monitoring:** Voltage monitoring via I2C/SPI ADC channels (internal to FPGA or external monitor)
- **Protection:** Automatic shutdown via ADC over-range detection

---

## 6. FPGA Description

| S.NO | PARAMETERS | SPECIFICATION |
|------|-----------|---------------|
| 1 | Part Number | XCZU9EG-FFVB1156 (Example Target) |
| 2 | Logic Cells | ~250,000 |
| 3 | CLB Flip-Flops | ~500,000 |
| 4 | Number of Gates | ~5,000,000 |
| 5 | Maximum Distributed RAM (Kb) | ~1,500 |
| 6 | Total Block RAM (Kb) | ~20,000 |
| 7 | Maximum Single-Ended I/Os | ~400 |
| 8 | Maximum DSP Slices | ~1,200 |
| 9 | No of IO Bank | ~40 |

---

## 7. Block Diagram
*(Reference to System Block Diagram in Section 1)*
The FPGA acts as the central controller, managing the ADF5356 LO via SPI, setting the HMC699LP4 gain via SPI, and configuring the ADC12DJ3200 via its 3-wire SPI. It receives digitized data via the LVDS interface and streams it out.

---

## 8. Pinout Details

**Table: FPGA Pin Out Details**

| S.No | Signal Name | Pin No | Voltage Level | Direction wrt FPGA | Source | Destination | Default Condition | Voltage Standard |
|---|---|---|---|---|---|---|---|---|
| 1 | VDD_FPGA_1V0 | - | 1.0V | PWR | Regulator | FPGA Core | ON | - |
| 2 | VDD_FPGA_1V8 | - | 1.8V | PWR | Regulator | FPGA Aux | ON | - |
| 3 | VDD_FPGA_3V3 | - | 3.3V | PWR | Regulator | FPGA IO | ON | - |
| 4 | GND | - | 0V | GND | GND | FPGA | - | - |
| 5 | FPGA_CLK_125M | AA12 | 3.3V | IN | Oscillator | PLL | HIGH | LVCMOS33 |
| 6 | FPGA_RESET_N | AB15 | 3.3V | IN | Reset Button | SysCtrl | HIGH (Pullup) | LVCMOS33 |
| 7 | UART_TX | Y11 | 3.3V | OUT | FPGA | UART-USB | HIGH | LVCMOS33 |
| 8 | UART_RX | AA11 | 3.3V | IN | UART-USB | FPGA | HIGH | LVCMOS33 |
| 9 | SPI_SCLK | T10 | 3.3V | OUT | FPGA | LO/VGA/ADC | LOW | LVCMOS33 |
| 10 | SPI_MOSI | U10 | 3.3V | OUT | FPGA | Peripherals | LOW | LVCMOS33 |
| 11 | SPI_MISO | V10 | 3.3V | IN | Peripherals | FPGA | HIGH | LVCMOS33 |
| 12 | LO_CS_N | W12 | 3.3V | OUT | FPGA | ADF5356 | HIGH | LVCMOS33 |
| 13 | VGA_CS_N | Y12 | 3.3V | OUT | FPGA | HMC699LP4 | HIGH | LVCMOS33 |
| 14 | ADC_CS_N | Y13 | 3.3V | OUT | FPGA | ADC12DJ3200 | HIGH | LVCMOS33 |
| 15 | I2C_SCL | R14 | 3.3V | BiDir | FPGA | EEPROM | HIGH | LVCMOS33 (OD) |
| 16 | I2C_SDA | R13 | 3.3V | BiDir | FPGA | EEPROM | HIGH | LVCMOS33 (OD) |
| 17 | JTAG_TCK | M5 | 1.8V | IN | Debugger | FPGA | HIGH | LVCMOS18 |
| 18 | JTAG_TDI | N5 | 1.8V | IN | Debugger | FPGA | HIGH | LVCMOS18 |
| 19 | JTAG_TDO | P5 | 1.8V | OUT | FPGA | Debugger | HIGH | LVCMOS18 |
| 20 | JTAG_TMS | M6 | 1.8V | IN | Debugger | FPGA | HIGH | LVCMOS18 |
| 21 | LED_STATUS | G15 | 3.3V | OUT | FPGA | LED | LOW | LVCMOS33 |
| 22 | FPGA_DONE | H15 | 1.8V | OUT | FPGA | Monitor | LOW | LVCMOS18 |
| 23 | LVDS_CLK_P | A1 | 1.8V | IN | ADC | FPGA | HIGH | DIFF_HSTL18_II |
| 24 | LVDS_CLK_N | B1 | 1.8V | IN | ADC | FPGA | LOW | DIFF_HSTL18_II |
| 25 | ADC_DO0_P | C1 | 1.8V | IN | ADC | FPGA | - | DIFF_HSTL18_II |
| 26 | ADC_DO0_N | D1 | 1.8V | IN | ADC | FPGA | - | DIFF_HSTL18_II |
| 27 | ADC_DO1_P | E1 | 1.8V | IN | ADC | FPGA | - | DIFF_HSTL18_II |
| 28 | ADC_DO1_N | F1 | 1.8V | IN | ADC | FPGA | - | DIFF_HSTL18_II |
| 29 | ADC_DO2_P | G1 | 1.8V | IN | ADC | FPGA | - | DIFF_HSTL18_II |
| 30 | ADC_DO2_N | H1 | 1.8V | IN | ADC | FPGA | - | DIFF_HSTL18_II |
| 31 | ADC_DO3_P | J1 | 1.8V | IN | ADC | FPGA | - | DIFF_HSTL18_II |
| 32 | ADC_DO3_N | K1 | 1.8V | IN | ADC | FPGA | - | DIFF_HSTL18_II |
| 33 | ADC_DO4_P | L1 | 1.8V | IN | ADC | FPGA | - | DIFF_HSTL18_II |
| 34 | ADC_DO4_N | M1 | 1.8V | IN | ADC | FPGA | - | DIFF_HSTL18_II |
| 35 | ADC_DO5_P | N1 | 1.8V | IN | ADC | FPGA | - | DIFF_HSTL18_II |
| 36 | ADC_DO5_N | P1 | 1.8V | IN | ADC | FPGA | - | DIFF_HSTL18_II |
| 37 | ADC_DO6_P | R1 | 1.8V | IN | ADC | FPGA | - | DIFF_HSTL18_II |
| 38 | ADC_DO6_N | T1 | 1.8V | IN | ADC | FPGA | - | DIFF_HSTL18_II |
| 39 | ADC_DO7_P | U1 | 1.8V | IN | ADC | FPGA | - | DIFF_HSTL18_II |
| 40 | ADC_DO7_N | V1 | 1.8V | IN | ADC | FPGA | - | DIFF_HSTL18_II |

---

## 9. Functional Specifications

**Summary table first:**

| S.No. | Function Name | Description |
|-------|--------------|-------------|
| 1 | Serial Communication Interface | UART between PC & FPGA for command/status |
| 2 | High Speed Data Capture | 8-bit LVDS interface capturing data from ADC12DJ3200 |
| 3 | Power Supply Sequencing & Health | Based on supply voltage, monitor rails and health |
| 4 | Supply Voltage & Temp Monitoring | I2C-based monitoring of onboard rails |
| 5 | Flash / EEPROM Interfaces | I2C EEPROM for config storage |
| 6 | RF Control (LO) | SPI control of ADF5356 frequency synthesizer |
| 7 | RF Control (VGA) | SPI control of HMC699LP4 variable gain amplifier |
| 8 | ADC Interface Control | SPI control of ADC12DJ3200 configuration |
| 9 | LVDS Buffering | Deserialization and buffering of ADC data |

Then provide DETAILED subsections:

### 9.1 Serial Communication Interface
- Interface type: UART
- Physical layer: TTL (via USB-UART bridge)
- Baud rate: 115200 bps
- Frame format: 1 start bit, 8 data bits, 1 stop bit, no parity (8N1)
- USB-UART converter IC: FT2232H (External) or CP2102 (On-board)
- Signals: UART_TX (FPGA → PC), UART_RX (PC → FPGA)
- Protocol: Custom register-based command/response (see Section 11)

### 9.2 High Speed Communication Interface
- Interface: LVDS Parallel (Source Synchronous)
- Number of lanes: 8 Data lanes + 1 Clock lane
- Data rate per lane: 800 Mbps (DDR operation)
- Protocol: Proprietary framer based on ADC12DJ3200 output modes
- Physical: Samtec CLT-122-01-X-D connector

### 9.3 Power On/Off Sequence
#### 9.3.1 Power ON/OFF Sequence
Step-by-step sequence:
1. Input supply (+5V) detected.
2. 3.3V Buck (LTC7138) enables -> VCC_3V3 good.
3. 1.8V LDO enables -> VCC_1V8 good.
4. 1.0V LDO enables -> VCC_1V0 good.
5. FPGA releases internal reset (INIT_N high).
6. FPGA configures ADC and LO via SPI.
7. System READY status asserted.

#### 9.3.2 Mode Configuration
| Mode | Signal | Value | Description |
|------|--------|-------|-------------|
| Normal | MODE[1:0] | 2'b00 | Normal operating mode |
| BIST | MODE[1:0] | 2'b01 | Built-in self-test (RAM/EEPROM) |
| Programming | MODE[1:0] | 2'b10 | FPGA remote programming mode |

### 9.4 Supply Voltage, Current & Temperature Monitoring
#### 9.4.1 Supply Voltage and Current Monitoring
- Method: FPGA internal XADC (or similar if available) monitoring external dividers.
- Monitored rails: +5V input, +3.3V, +1.8V, +1.0V.
- Measurement range: 0 to 6V.
- Resolution: 12-bit (approx 1.5mV).

#### 9.4.2 Temperature Monitoring
- Sensor: TI TMP102 or similar (via I2C).
- Interface: I2C address 0x48.
- Temperature range: -40°C to +125°C.
- Resolution: 0.0625°C.
- Alert threshold: +85°C (force RF gain reduction/shutdown).

### 9.5 Flash & Interfaces
#### 9.5.1 Configuration Flash (External)
- Part Number: S25FL128S (128 Mb)
- Interface: QSPI (x4)
- Purpose: Stores FPGA bitstream for remote update.
- Note: *If supported by target FPGA platform.*

#### 9.5.2 Storage Flash (User Flash / EEPROM)
- Part Number: AT24CS02-SH-T
- Interface: I2C (address 0x50)
- Capacity: 2 Kb (256 x 8 bits)
- Purpose: Stores MAC address, serial number, calibration tables.

### 9.6 TRP Configuration
- *Not applicable for Receive-only module j,fj.*

### 9.7 FPGA Remote Programming
- Protocol: UART at 115200 bps
- Tool: Vendor GUI or Serial Loader
- Procedure:
  1. Host sends programming command via UART.
  2. FPGA enters programming mode.
  3. Bitstream transferred via XMODEM or similar.
  4. FPGA reboots from new configuration.
- Fallback: JTAG.

### 9.8 Phase Shifter Controlling
- *Not applicable (Direct LO synthesis used).*

### 9.9 Beam Steering Calculation
- *Not applicable.*

### 9.10 Gain Control (VGA)
- DAC Part Number: HMC699LP4 (Analog VGA controlled via SPI)
- Interface: SPI
- Channels: 1 (IF Gain)
- Voltage range: Controlled via internal lookup table
- Resolution: 6-bit SPI word (Gain range -3 to +24 dB)

---

## 10. Software Register Address Map

This section is CRITICAL for firmware development — it defines the complete FPGA register address space as seen by the software.

### 10.1 Register Base Addresses

| Block Name | Base Address | Address Range | Description |
|------------|-------------|---------------|-------------|
| System / Identification | 0x0000 | 0x0000–0x00FF | Board ID, firmware version, status |
| UART Control | 0x0100 | 0x0100–0x01FF | Baud rate, FIFO control, status |
| SPI Control | 0x0200 | 0x0200–0x02FF | SPI master, chip-select control |
| I2C Control | 0x0300 | 0x0300–0x03FF | I2C master, device address, data |
| GPIO | 0x0400 | 0x0400–0x04FF | General purpose I/O control |
| PLL Control (LO) | 0x0500 | 0x0500–0x05FF | ADF5356 N/R dividers, status, config |
| Temperature Monitor | 0x0600 | 0x0600–0x06FF | Temp sensor readings, alert threshold |
| Power Monitor | 0x0700 | 0x0700–0x07FF | Voltage/current ADC readings per rail |
| RF Control (VGA/ADC) | 0x0800 | 0x0800–0x08FF | HMC699 Gain, ADC Mode select |
| EEPROM | 0x0900 | 0x0900–0x09FF | EEPROM address, data, command register |
| Diagnostics | 0x0A00 | 0x0A00–0x0AFF | Fault log, uptime counter, loopback |

### 10.2 Detailed Register Map

**Block 0x0000 — System / Identification**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|--------------|-------|-----|-------------|----------------------|
| 0x00 | BOARD_ID | 16 | R | 0x4A46 | ASCII "JF" (Project ID) |
| 0x01 | FW_VERSION_MAJOR | 16 | R | 0x0001 | Firmware major version |
| 0x02 | FW_VERSION_MINOR | 16 | R | 0x0000 | Firmware minor version |
| 0x03 | SYS_STATUS | 16 | R | 0x0000 | [15:8] Reserved, [7] ADC_LOCKED, [6] TEMP_ALERT, [5] VOLT_FAULT, [4] LVDS_ALIGN_ERR, [3:0] Reserved |
| 0x04 | SYS_CTRL | 16 | R/W | 0x0000 | [0] SOFT_RESET, [1] WDT_ENABLE, [2] RF_ENABLE |

**Block 0x0100 — UART Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|--------------|-------|-----|-------------|----------------------|
| 0x00 | BAUD_DIV | 16 | R/W | 0x0022 | Baud rate divisor = FPGA_CLK / (16 × BAUD_RATE) |
| 0x01 | UART_CTRL | 16 | R/W | 0x0001 | [0] UART_ENABLE, [1] LOOPBACK_EN |
| 0x02 | UART_STATUS | 16 | R | 0x0000 | [0] TX_BUSY, [1] RX_AVAIL, [2] RX_OVERRUN, [3] FRAME_ERR |
| 0x03 | TX_FIFO_COUNT | 16 | R | 0x0000 | Number of bytes in TX FIFO |
| 0x04 | RX_FIFO_COUNT | 16 | R | 0x0000 | Number of bytes in RX FIFO |

**Block 0x0500 — LO Synthesizer (PLL) Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|--------------|-------|-----|-------------|----------------------|
| 0x00 | LO_INT_DIV | 16 | R/W | 0x0064 | ADF5356 Integer Divider (INT) |
| 0x01 | LO_FRAC_DIV | 32 | R/W | 0x00000000 | ADF5356 Fractional Divider (FRAC1, FRAC2, FRAC3) |
| 0x02 | LO_CTRL | 16 | R/W | 0x0000 | [0] LO_ENABLE, [1] LO_RESET, [2] AUTO_CALIB, [3] MUX_SEL |
| 0x03 | LO_STATUS | 16 | R | 0x0000 | [0] PLL_LOCKED, [1] LD_PIN, [2] CAL_BUSY |
| 0x04 | LO_FREQ_HZ | 32 | R/W | 0x2DC6C000 | Target Frequency (Hz) - Shadow Register |

**Block 0x0800 — RF Control (VGA/ADC)**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|--------------|-------|-----|-------------|----------------------|
| 0x00 | VGA_GAIN | 16 | R/W | 0x0000 | HMC699 Gain Setting (0-63 mapped to -3 to +24dB) |
| 0x01 | ADC_MODE | 16 | R/W | 0x0001 | [0] ADC_PWR_DWN, [1] DDR_EN, [2] TEST_PATTERN_EN |
| 0x02 | ADC_OVR_FLAG | 16 | R | 0x0000 | [0] ADC_OVER_RANGE, [1:15] Reserved |

### 10.3 Register Access Rules
- All registers are 16-bit wide; accessed via UART protocol (Section 11).
- Read: set bit15 of address (address OR 0x8000).
- Write: address as-is.
- Atomic access: Bulk Write used for frequency changes (Integer/ Fractional dividers).

---

## 11. UART Register Protocol Specification

This section provides the EXACT byte-level frame format for the UART register protocol. Firmware MUST implement this exactly.

### 11.1 Physical Layer
- Baud rate: 115200 bps
- Frame format: 1 start bit, 8 data bits, 1 stop bit, no parity (8N1)
- Physical interface: RS-232 / TTL
- Signal levels: 3.3V logic

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
  - CMD byte not recognized
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
// Firmware register write wrapper
#define FPGA_WRITE(addr, data)    UART_WriteReg((uint16_t)(addr), (uint16_t)(data))
// Firmware register read wrapper
#define FPGA_READ(addr, pdata)    UART_ReadReg((uint16_t)(addr) | 0x8000U, (pdata))
// Block registers by base address
#define REG_SYS_BASE    (0x0000U)
#define REG_UART_BASE   (0x0100U)
#define REG_SPI_BASE    (0x0200U)
#define REG_I2C_BASE    (0x0300U)
#define REG_GPIO_BASE   (0x0400U)
#define REG_LO_BASE     (0x0500U)
#define REG_TEMP_BASE   (0x0600U)
#define REG_PWR_BASE    (0x0700U)
#define REG_RF_BASE     (0x0800U)
#define REG_EEP_BASE    (0x0900U)
#define REG_DIAG_BASE   (0x0A00U)
```

---

## 12. FPGA Resource Utilization Estimate

| Resource | Available | Estimated Usage | Utilization % |
|---------|-----------|----------------|--------------|
| Slice LUTs | 260,000 | 45,000 | 17% |
| Slice Flip-Flops | 520,000 | 30,000 | 5% |
| Block RAM (36Kb) | 900 | 120 | 13% |
| DSP Slices | 1,200 | 0 | 0% |
| MMCM/PLL | 20 | 2 | 10% |
| I/O Buffers | 500 | 85 | 17% |

Synthesis tool: Vivado 2025.1
Target device: XCZU9EG-FFVB1156
Timing constraint: 125 MHz (System), 400 MHz (LVDS DDR)

---

## Annexure A — Requirement Traceability Matrix

| S.No. | GLR-ID | Description | Source HRS Section | GLR Section | Verification Method | Status |
|-------|--------|-------------|-------------------|-------------|--------------------|----|
| 1 | GLR-001 | Serial Communication Interface | HRS 3.3 | 9.1, 11 | Test | Open |
| 2 | GLR-002 | High Speed LVDS Data Capture | HRS 3.3 | 9.2, 8 | Test | Open |
| 3 | GLR-003 | Power Supply Sequencing | HRS 3.4 | 9.3 | Test | Open |
| 4 | GLR-004 | Voltage/Current/Temperature Monitoring | HRS 3.5 | 9.4 | Test | Open |
| 5 | GLR-005 | Flash / EEPROM Interfaces | HRS 3.3 | 9.5 | Inspection | Open |
| 6 | GLR-006 | LO Synthesizer Control (SPI) | HRS 3.1 | 9.8 | Test | Open |
| 7 | GLR-007 | FPGA Remote Programming | HRS 3.3 | 9.7 | Demonstration | Open |
| 8 | GLR-008 | Gain Control (VGA) | HRS 3.1 | 9.10 | Test | Open |
| 9 | GLR-009 | LVDS Interface Implementation | HRS 3.3 | 8 | Test | Open |
| 10 | GLR-010 | Register Address Map | HRS 3.3 | 10 | Inspection | Open |
| 11 | GLR-011 | UART Protocol Specification | HRS 3.3 | 11 | Test | Open |
| 12 | GLR-012 | FPGA Resource Budget | HRS 3.2 | 12 | Analysis | Open |
| 13 | GLR-013 | LVDS Voltage Levels | HRS 3.2 | 8 | Test | Open |
| 14 | GLR-014 | Temperature Range Compliance | HRS 3.5 | 9.4 | Test | Open |