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
|:---:|:---:|:---:|:---:|:---:|:---|
| 1 | 0V01 | 16.04.2026 | - | - | Initial Version |

---

## 1. Scope of the Document
This document explains the IO details and functional requirements of the FPGA for **rx receiver**. Targeted audience: Hardware Design and Firmware teams.

This specification bridges the system requirements (HRS) and the logical netlist, defining the precise pin-level connectivity, register map, and communication protocols required to integrate the Analog Devices RF Front End (LNA, Mixers), TI PLL Synthesizer, and High-Speed ADC under the control of the STM32 MCU and FPGA processing logic.

---

## 2. References

### 2.1 External
| Doc. Type | Part No. | Description |
|:---|:---|:---|
| Datasheet | **HMC6180LP4E** | Wideband LNA, 2-20 GHz |
| Datasheet | **HMC519LC4** | IQ Demodulator, 5-12 GHz |
| Datasheet | **MIXIQ-1030** | Wideband IQ Mixer, 10-30 GHz |
| Datasheet | **LMX2594RHAR** | Wideband PLL Synthesizer with Integrated VCO |
| Datasheet | **AD9680BCPZ-250** | Dual, 14-Bit, 250 MSPS A/D Converter |
| Datasheet | **STM32F407VGT6** | High-performance MCU |
| Datasheet | **TPS54332** | 4.5V to 28V Input, 3A Step-Down Converter |
| Datasheet | **TPS62130** | 3V to 17V Input, 3A Step-Down Converter |
| Datasheet | **MIC9430-44YM** | 3.3V Voltage Supervisor |
| Datasheet | **Kintex-7** | FPGA Family Reference (Selected for DSP/Logic) |

### 2.2 Internal
| Reference | Document |
|:---|:---|
| [HRS] | Hardware Requirements Specification (rx receiver) |
| [SCH] | Schematic |
| [GRS] | General Requirements Specification |
| [GDD] | General Design Document |

---

## 3. Acronyms and Abbreviations
| Acronym | Expansion |
|:---|:---|
| **ADC** | Analog to Digital Converter |
| **BOM** | Bill of Materials |
| **CLB** | Configurable Logic Block |
| **CPLD** | Complex Programmable Logic Device |
| **DAC** | Digital to Analog Converter |
| **DCO** | Data Clock Output |
| **DSP** | Digital Signal Processing |
| **EMC** | Electromagnetic Compatibility |
| **FCC** | Federal Communications Commission |
| **FIFO** | First In First Out |
| **FPGA** | Field Programmable Gate Array |
| **GND** | Ground |
| **HDL** | Hardware Description Language |
| **I2C** | Inter-Integrated Circuit |
| **IO** | Input Output |
| **JTAG** | Joint Test Action Group |
| **LED** | Light Emitting Diode |
| **LDO** | Low Dropout Regulator |
| **LO** | Local Oscillator |
| **LUT** | Look Up Table |
| **LVDS** | Low Voltage Differential Signaling |
| **PCB** | Printed Circuit Board |
| **PLL** | Phase Locked Loop |
| **PWB** | Printed Wiring Board |
| **RF** | Radio Frequency |
| **RoHS** | Restriction of Hazardous Substances |
| **RTL** | Register Transfer Level |
| **SFDR** | Spur-Free Dynamic Range |
| **SPI** | Serial Peripheral Interface |
| **SSTL** | Stub Series Terminated Logic |
| **TRP** | Transmit/Receive Pulse (Control) |
| **UART** | Universal Asynchronous Receiver Transmitter |
| **VCC** | Voltage Common Collector (Supply) |
| **VCO** | Voltage Controlled Oscillator |

---

## 4. Module Overview

### RF SECTION:
The RF front end consists of a wideband input stage utilizing the **HMC6180LP4E** LNA followed by signal splitting to cover the full 5-18 GHz bandwidth.
- **Lower Band (5-12 GHz):** Processed by the **HMC519LC4** IQ Demodulator.
- **Upper Band (10-30 GHz):** Processed by the **MIXIQ-1030** Wideband IQ Mixer.
- **Frequency Generation:** The **LMX2594RHAR** generates the Local Oscillator (LO) signal. This wideband PLL synthesizer covers 10 MHz to 20 GHz with ultra-low phase noise, feeding both mixers to downconvert the RF signal to baseband I/Q.

### DIGITAL SECTION:
The digital core is managed by an FPGA (Xilinx Kintex-7 family equivalent) for high-speed signal capture and an **STM32F407VGT6** MCU for system control.
- **FPGA Role:** Interfaces directly with the **AD9680BCPZ-250** Dual ADC (250 MSPS) via JESD204B/LVDS to capture digitized I/Q data. It handles buffering, decimation, and packetization.
- **MCU Role:** Acts as the system controller. It configures the RF chain via SPI (PLL gain, frequency, Mixer enables if applicable) and monitors system health via I2C (Power supply rails, Temperature sensors). The MCU communicates with the FPGA via UART for register access and control commands.

### POWER SUPPLY SECTION:
Power is derived from a 12V DC input.
- **Regulation:**
  - **U7 (LM2941-12):** 12V LDO/Pass-through protection.
  - **U8 (TPS54332):** Bucks 12V to +5V for the RF components (LNA U1, Mixers U2/U3).
  - **U9 (TPS62130):** Bucks 5V to +3.3V for digital logic (FPGA, ADC, MCU, Supervisors).
- **Sequencing:** The **MIC9430-44YM** ensures the 3.3V rail is stable and within tolerance before releasing the FPGA/MCU reset, ensuring proper Power-On Reset (POR) behavior.

---

## 5. Features
- **FPGA:** Xilinx Kintex-7 XC7K160T-1FBG484C (High DSP logic for I/Q processing)
- **MCU Controller:** STM32F407VGT6 (168 MHz Cortex-M4)
- **ADC Interface:** AD9680 (Dual 14-bit, 250 MSPS, JESD204B / LVDS interface)
- **Frequency Synthesis:** LMX2594 (10 MHz - 20 GHz output, < -134 dBc/Hz phase noise)
- **RF Front End:** Dual-band path using HMC6180 LNA + HMC519 (Low) / MIXIQ-1030 (High) mixers
- **Communication:**
  - **UART:** 3.0 Mbps between Host/MCU and FPGA
  - **SPI (MCU -> RF):** Control for LMX2594 (PLL) and AD9680 (ADC Config)
  - **I2C (MCU -> Monitors):** Voltage/Current monitoring
- **Configuration:** EEPROM (via I2C) for storing calibration tables and default PLL frequencies
- **Protection:** MIC9430-44YM 3.3V Voltage Supervisor with manual reset input
- **Environmental:** Operating range -40°C to +85°C

---

## 6. FPGA Description
The FPGA must provide high-speed LVDS receivers for the ADC interface and sufficient logic resources for digital down-conversion (DDC) and filtering.

| S.NO | PARAMETERS | SPECIFICATION |
|:---:|:---|:---|
| 1 | Part Number | **XC7K160T-1FBG484C** (Xilinx Kintex-7) |
| 2 | Logic Cells | 203,600 |
| 3 | CLB Flip-Flops | 162,400 |
| 4 | Number of Gates | 2.4 Million (ASIC equiv) |
| 5 | Maximum Distributed RAM (Kb) | 485 |
| 6 | Total Block RAM (Kb) | 3,650 |
| 7 | Maximum Single-Ended I/Os | 300 |
| 8 | Maximum DSP Slices | 600 |
| 9 | No of IO Bank | 10 (SelectIO Banks) |

---

## 7. Block Diagram
(Block Diagram Reference Schematic - Logic Flow:
**RF IN** → [LNA] → [Mixer I/Q] → [ADC] → [FPGA LVDS RX] → [DDR Buff/DDR3] → [FIFO] → [UART TX]
**MCU** → [SPI] → [PLL/ADC] & [UART] → [FPGA])

---

## 8. Pinout Details

**Table: FPGA Pin Out Details**

| S.No | Signal Name | Pin No | Voltage Level | Direction wrt FPGA | Source | Destination | Default Condition | Voltage Standard |
|:---:|:---|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| 1 | VCCINT_1V0 | - | 1.0V | PWR | PSU | FPGA Core | - | - |
| 2 | VCCAUX_1V8 | - | 1.8V | PWR | PSU | FPGA Aux | - | - |
| 3 | VCCO_34_3V3 | - | 3.3V | PWR | PSU | Bank 34 | - | - |
| 4 | GND | - | 0V | GND | PCB | FPGA | - | - |
| 5 | FPGA_CLK_125M | E15 | 3.3V | INPUT | Oscillator | FPGA Global Buf | High Z | LVCMOS33 |
| 6 | FPGA_RESET_N | D14 | 3.3V | INPUT | MIC9430_MR / MCU | FPGA Logic | Active Low Pullup | LVCMOS33 |
| 7 | JTAG_TCK | T13 | 3.3V | INPUT | Debugger | FPGA JTAG | Pullup | LVCMOS33 |
| 8 | JTAG_TDI | R12 | 3.3V | INPUT | Debugger | FPGA JTAG | Pullup | LVCMOS33 |
| 9 | JTAG_TDO | P14 | 3.3V | OUTPUT | FPGA JTAG | Debugger | High Z | LVCMOS33 |
| 10 | JTAG_TMS | R13 | 3.3V | INPUT | Debugger | FPGA JTAG | Pullup | LVCMOS33 |
| 11 | UART_TX_FPGA | M16 | 3.3V | OUTPUT | FPGA UART | MCU (RX) | High | LVCMOS33 |
| 12 | UART_RX_FPGA | M15 | 3.3V | INPUT | MCU (TX) | FPGA UART | High Z | LVCMOS33 |
| 13 | I2C_SCL_FPGA | N14 | 3.3V | INOUT | FPGA I2C | Temp/Pwr Monitor | High Z | LVCMOS33 |
| 14 | I2C_SDA_FPGA | M14 | 3.3V | INOUT | FPGA I2C | Temp/Pwr Monitor | High Z | LVCMOS33 |
| 15 | LED_STATUS | L16 | 3.3V | OUTPUT | FPGA Ctrl | LED (Green) | Low | LVCMOS33 |
| 16 | LED_ERROR | K16 | 3.3V | OUTPUT | FPGA Ctrl | LED (Red) | Low | LVCMOS33 |
| 17 | SPI_SCLK_PLL | N12 | 3.3V | OUTPUT | FPGA SPI | LMX2594_SCLK | Low | LVCMOS33 |
| 18 | SPI_SDI_PLL | M12 | 3.3V | OUTPUT | FPGA SPI | LMX2594_SDIO | Low | LVCMOS33 |
| 19 | SPI_SDO_PLL | N13 | 3.3V | INPUT | LMX2594_SDIO | FPGA SPI | High Z | LVCMOS33 |
| 20 | SPI_CS_PLL_N | L12 | 3.3V | OUTPUT | FPGA SPI | LMX2594_CS_N | High | LVCMOS33 |
| 21 | ADC_DCO_P | A15 | 1.8V | INPUT | AD9680 | FPGA Buf | High Z | LVDS_18 |
| 22 | ADC_DCO_N | B15 | 1.8V | INPUT | AD9680 | FPGA Buf | High Z | LVDS_18 |
| 23 | ADC_FR_P | A14 | 1.8V | INPUT | AD9680 | FPGA Buf | High Z | LVDS_18 |
| 24 | ADC_FR_N | B14 | 1.8V | INPUT | AD9680 | FPGA Buf | High Z | LVDS_18 |
| 25 | ADC_DA_P | A12 | 1.8V | INPUT | AD9680 | FPGA Buf | High Z | LVDS_18 |
| 26 | ADC_DA_N | B12 | 1.8V | INPUT | AD9680 | FPGA Buf | High Z | LVDS_18 |
| 27 | ADC_DB_P | C12 | 1.8V | INPUT | AD9680 | FPGA Buf | High Z | LVDS_18 |
| 28 | ADC_DB_N | D12 | 1.8V | INPUT | AD9680 | FPGA Buf | High Z | LVDS_18 |
| 29 | GPIO_TRX_CTRL | J16 | 3.3V | OUTPUT | FPGA Ctrl | RF Switch | Low | LVCMOS33 |
| 30 | PG_3V3 | K14 | 3.3V | INPUT | U9 (TPS62130 PG) | FPGA Monitor | High | LVCMOS33 |
| 31 | IRQ_TEMP_MONITOR | P15 | 3.3V | INPUT | Temp Sensor | FPGA Interrupt | High | LVCMOS33 |
| 32 | DAC_SPI_CS_N | R16 | 3.3V | OUTPUT | FPGA SPI | External DAC | High | LVCMOS33 |
| 33 | ADC_PDWN | L14 | 3.3V | OUTPUT | FPGA Ctrl | AD9680_PDWN | High | LVCMOS33 |
| 34 | PLL_CE | M13 | 3.3V | OUTPUT | FPGA Ctrl | LMX2594_CE | Low | LVCMOS33 |
| 35 | FPGA_INIT_N | E16 | 3.3V | OUTPUT | FPGA Ctrl | MCU GPIO | High (Done) | LVCMOS33 |
| 36 | DDR3_CAS_N | - | SSTL15 | OUT | FPGA DDR PHY | DDR3 Mem | - | SSTL15 |
| 37 | DDR3_RAS_N | - | SSTL15 | OUT | FPGA DDR PHY | DDR3 Mem | - | SSTL15 |

---

## 9. Functional Specifications

| S.No. | Function Name | Description |
|:---:|:---|:---|
| 1 | High-Speed ADC Interface | Capture dual-channel 14-bit I/Q data at 250 MSPS via LVDS (AD9680). |
| 2 | Serial Communication Interface | UART control/status interface between Host/MCU and FPGA. |
| 3 | SPI PLL Control | Direct SPI control of LMX2594 frequency synthesizer. |
| 4 | Power Supply Monitoring | I2C monitoring of 12V, 5V, and 3.3V rails and current consumption. |
| 5 | Digital Signal Processing | Real-time DDC, filtering, and decimation of I/Q data. |
| 6 | RF Control | GPIO control for TRX switching and PA/LNA bias enables. |
| 7 | Temperature Monitoring | On-board sensor reading via I2C. |
| 8 | Memory Interface | DDR3-1333 interface for sample buffering. |

### 9.1 Serial Communication Interface
- **Interface:** UART (Asynchronous)
- **Physical Layer:** RS-422 Transceiver (接待 FPGA UART IO to 422 standard)
- **Baud Rate:** 3.0 Mbps (Fixed)
- **Frame Format:** 1 Start, 8 Data, 1 Stop, No Parity (8N1)
- **Protocol:** Register-based command/response (defined in Section 11)
- **Signals:** `UART_TX_FPGA`, `UART_RX_FPGA`

### 9.2 High Speed Communication Interface (ADC Data)
- **Interface:** JESD204B / Source Synchronous LVDS
- **Source:** AD9680BCPZ-250
- **Data Rate:** 250 MSPS x 14-bit (Dual Channel)
- **Lanes:** 2 Data Lanes (`DA_P/N`, `DB_P/N`) + 1 Frame Clock (`FR_P/N`) + 1 Data Clock (`DCO_P/N`)
- **Voltage:** 1.8V LVDS (Bank voltage VCCO = 1.8V)
- **Function:** Captures I/Q baseband data from RF mixers.

### 9.3 Power On/Off Sequence
#### 9.3.1 Power ON/OFF Sequence
1. **12V Input** applied to J1.
2. **U8 (TPS54332)** ramps +5V rail.
3. **U9 (TPS62130)** ramps +3.3V rail.
4. **U10 (MIC9430)** monitors +3.3V. Once voltage > 3.08V for 200ms, `RESET_OUT` asserts High.
5. **FPGA** completes configuration; `FPGA_INIT_N` goes High.
6. **FPGA** enables `PLL_CE` and `ADC_PDWN` via register control.
7. **System** enters READY state (LED_STATUS Solid Green).

#### 9.3.2 Mode Configuration
| Mode | Signal | Value | Description |
|:---:|:---:|:---:|:---|
| Normal | OP_MODE[1:0] | 2'b00 | Full Rate I/Q Capture |
| Diagnostic | OP_MODE[1:0] | 2'b01 | Built-in PRBS Loopback |
| Sleep | OP_MODE[1:0] | 2'b10 | RF Front End Power Down |

### 9.4 Supply Voltage, Current & Temperature Monitoring
#### 9.4.1 Supply Voltage and Current Monitoring
- **IC:** LTC2992 (Added to BOM for monitoring).
- **Interface:** I2C (Address 0x6E).
- **Rails Monitored:**
  - 12V Input (via divider).
  - 5V Reg Output.
  - 3.3V Reg Output.
  - Current sense on 5V and 3.3V feeds.
- **Measurement Range:** 0-20V, 0-5A.
- **Resolution:** 16-bit ADC.

#### 9.4.2 Temperature Monitoring
- **IC:** AD7416 (10-bit Digital Temp Sensor).
- **Interface:** I2C (Address 0x48).
- **Range:** -55°C to +125°C.
- **Alert:** Pin `IRQ_TEMP_MONITOR` asserts Low if > 85°C.

### 9.5 Flash & Interfaces
#### 9.5.1 Configuration Flash
- **Part Number:** IS25LP256D (32 MB SPI Flash).
- **Interface:** QSPI (x4 mode).
- **Purpose:** Stores FPGA bitstream.
- **Access:** FPGA Master Mode on boot.

#### 9.5.2 Storage Flash (User Data)
- **Part Number:** Same die or partition.
- **Purpose:** Stores Gain Calibration Tables and LMX2594 Frequency Look-Up Tables (LUTs).

### 9.6 TRP Configuration
- **Signal:** `GPIO_TRX_CTRL`
- **Logic:** High = RX Mode Enabled (LNA Active), Low = Mute/Protected.
- **Timing:** Toggled via Register 0x0800.

### 9.7 FPGA Remote Programming
- **Protocol:** UART Protocol (Section 11).
- **Command:** Write to `FLASH_CTRL` Register (Block 0x09).
- **Mechanism:** FPGA erases/writes QSPI flash via internal SPI master, then triggers IProg soft-reset.

### 9.8 Phase Shifter Controlling
- *Not applicable (Direct Conversion Architecture).*
- **Replaced by:** **LO Frequency Control** (LMX2594).
- **Interface:** SPI (Section 9.3).
- **Registers:** 0x0500 block maps 32-bit frequency words to LMX2594 multiplier/divider registers.

### 9.9 Beam Steering Calculation
- **Not applicable (Single Channel Receiver).**
- **Processing:** FPGA performs channelization and FFT.

### 9.10 Gate Voltage Writing in DAC
- **Part:** AD5681R (18-bit DAC) for VGA/ATTEN control.
- **Interface:** SPI (`DAC_SPI_CS_N`).
- **Voltage Range:** 0-5V.
- **Purpose:** Fine analog gain control of IF VGA.

---

## 10. Software Register Address Map

### 10.1 Register Base Addresses

| Block Name | Base Address | Address Range | Description |
|:---|:---:|:---:|:---|
| System / Identification | 0x0000 | 0x0000–0x00FF | Board ID, Firmware version, Reset control |
| UART Control | 0x0100 | 0x0100–0x01FF | Baud rate, FIFO enable |
| SPI Master Control | 0x0200 | 0x0200–0x02FF | SPI config for PLL/DAC |
| I2C Master Control | 0x0300 | 0x0300–0x03FF | I2C config for Sensors |
| GPIO / RF Control | 0x0400 | 0x0400–0x04FF | Pin level control |
| PLL Control (LMX2594) | 0x0500 | 0x0500–0x05FF | Frequency registers (N, R, INT) |
| ADC Interface Control | 0x0600 | 0x0600–0x06FF | AD9680 Power, Test Patterns |
| DDR3 Controller | 0x0700 | 0x0700–0x07FF | Buffer status, Address pointers |
| DSP / Processing | 0x0800 | 0x0800–0x08FF | DDC Config, Decimation factor |
| Flash / EEPROM | 0x0900 | 0x0900–0x09FF | QSPI Erase/Prog/Read |
| Diagnostics | 0x0A00 | 0x0A00–0x0AFF | Error logs, Eye width monitor |

### 10.2 Detailed Register Map

**Block 0x0000 — System / Identification**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|:---:|:---|:---:|:---:|:---:|:---|
| 0x00 | BOARD_ID | 16 | R | 0xA5A5 | Fixed Identification Code |
| 0x01 | FW_VERSION_MAJOR | 16 | R | 0x0001 | Firmware Major Version |
| 0x02 | FW_VERSION_MINOR | 16 | R | 0x0002 | Firmware Minor Version |
| 0x03 | SYS_STATUS | 16 | R | 0x0000 | [15:4] Reserved, [3] TEMP_ALERT, [2] PWR_GOOD, [1] PLL_LOCKED, [0] ADC_LOCKED |
| 0x04 | SYS_RESET | 16 | W | 0x0000 | Write 0xDEAD to trigger soft reset |

**Block 0x0100 — UART Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|:---:|:---|:---:|:---:|:---:|:---|
| 0x00 | UART_BAUD_DIV | 16 | R/W | 0x0001 | Baud divisor (Freq/BAUD) |
| 0x01 | UART_CTRL | 16 | R/W | 0x0000 | [0] TX_EN, [1] RX_EN, [2] PARITY_EN |
| 0x02 | UART_STATUS | 16 | R | 0x0000 | [0] TX_BUSY, [1] RX_EMPTY, [2] RX_OVERRUN |

**Block 0x0400 — GPIO / RF Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|:---:|:---|:---:|:---:|:---:|:---|
| 0x00 | GPIO_DATA | 16 | R/W | 0x0000 | [0] TRX_CTRL, [1] LED_STATUS, [2] LED_ERROR |
| 0x01 | GPIO_DIR | 16 | R/W | 0xFFFF | 0=Input, 1=Output |

**Block 0x0500 — PLL Control (LMX2594)**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|:---:|:---|:---:|:---:|:---:|:---|
| 0x00 | PLL_FREQ_LO | 32 | W | 0x00000000 | Lower 32-bits of 64-bit frequency word |
| 0x02 | PLL_FREQ_HI | 32 | W | 0x00000000 | Upper 32-bits of 64-bit frequency word |
| 0x04 | PLL_TRIGGER | 16 | W | 0x0000 | Write 0x1 to push freq to SPI |
| 0x05 | PLL_LOCK_STATUS | 16 | R | 0x0000 | [0] LOCK_DET (Readback from LMX2594 MUX) |

**Block 0x0600 — ADC Interface Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|:---:|:---|:---:|:---:|:---:|:---|
| 0x00 | ADC_PDWN | 16 | R/W | 0x0001 | [0] Power Down (1=Off), [1] Standby |
| 0x01 | ADC_TEST_MODE | 16 | R/W | 0x0000 | [2:0] 000=Normal, 001=midscale, 010=1111 pattern |
| 0x02 | ADC_OFFSET_CORR | 16 | R/W | 0x0000 | Coarse gain adjustment |

**Block 0x0900 — Flash / EEPROM**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|:---:|:---|:---:|:---:|:---:|:---|
| 0x00 | FLASH_ADDR | 32 | W | 0x00000000 | Address to write/read |
| 0x02 | FLASH_DATA_WR | 32 | W | 0x00000000 | Data to write |
| 0x04 | FLASH_DATA_RD | 32 | R | 0x00000000 | Data read |
| 0x06 | FLASH_CMD | 16 | W | 0x0000 | 1=Read, 2=Write, 3=Erase Sector |

### 10.3 Register Access Rules
- **Byte Order:** Little Endian.
- **Read/Write:** 16-bit data width aligned.
- **Atomic Access:** Bulk writes (N=2) required for 32-bit frequency values.

---

## 11. UART Register Protocol Specification

### 11.1 Physical Layer
- **Baud:** 3,000,000 bps (3.0 Mbps)
- **Format:** 8N1
- **Interface:** 3.3V CMOS / RS-422

### 11.2 Command Frame Formats

**Single Register Write (CMD = 0x57 'W'):**
```
Byte 0: 0x57 (CMD)
Byte 1: ADDR[15:8] (address MSB)
Byte 2: ADDR[7:0]  (address LSB)
Byte 3: DATA[15:8] (data MSB)
Byte 4: DATA[7:0]  (data LSB)
→ Response: 0x06 (ACK)
Total: 5 bytes TX, 1 byte RX
```

**Single Register Read (CMD = 0x52 'R'):**
```
Byte 0: 0x52 (CMD)
Byte 1: ADDR[15:8]
Byte 2: ADDR[7:0]
→ Response: DATA[15:8], DATA[7:0]
Total: 3 bytes TX, 2 bytes RX
```

**Bulk Register Write (CMD = 0x42 'B'):**
```
Byte 0: 0x42 (CMD)
Byte 1: ADDR[15:8]
Byte 2: ADDR[7:0]
Byte 3: N (Count)
Bytes 4+: Data Pairs...
→ Response: 0x06 (ACK)
```

**Error Response:**
```
0x15 (NAK) — Invalid address, timeout, or write-protected register.
```

### 11.3 Protocol Timing Constraints
| Parameter | Min | Typical | Max | Unit |
|:---|:---:|:---:|:---:|:---:|
| Inter-byte gap (TX) | - | - | 10 | ms |
| Response delay (ACK) | - | 0.5 | 2 | ms |

### 11.4 Software Implementation Notes
- The MCU/Host must implement a retry mechanism if NAK is received.
- Addresses are 16-bit word aligned (e.g., reg 0x00 is address 0x0000, reg 0x01 is 0x0002).

---

## 12. FPGA Resource Utilization Estimate

Target Device: **Xilinx XC7K160T-1FBG484C**

| Resource | Available | Estimated Usage | Utilization % |
|:---|:---:|:---:|:---:|
| Slice LUTs | 101,600 | 22,400 | 22 % |
| Slice Flip-Flops | 203,200 | 18,500 | 9 % |
| Block RAM (36Kb) | 325 | 48 | 14 % |
| DSP Slices | 600 | 64 | 10 % |
| MMCM/PLL | 10 | 2 | 20 % |
| I/O Buffers | 285 | 85 | 30 % |

*Estimation assumes 2x DDC chains, 64-tap FIR filters, and a UART/SPI register bridge.*

---

## Annexure A — Requirement Traceability Matrix

| S.No. | GLR-ID | Description | Source HRS Section | GLR Section | Verification Method | Status |
|:---:|:---|:---|:---|:---|:---|:---|
| 1 | GLR-001 | RF Input 5-18 GHz Coverage | HRS §2 | 9.3 | Analysis | Open |
| 2 | GLR-002 | ADC Interface (250 MSPS) | HRS §2 | 9.2, 8 | Test | Open |
| 3 | GLR-003 | PLL Control via SPI | HRS §3.3 | 9.3, 10 | Test | Open |
| 4 | GLR-004 | Power Supply Sequencing | HRS §3.5 | 9.3.1 | Test | Open |
| 5 | GLR-005 | Temp/Voltage Monitoring | HRS §3.4 | 9.4, 10 | Test | Open |
| 6 | GLR-006 | UART Control Interface | HRS §3.3 | 9.1, 11 | Test | Open |
| 7 | GLR-007 | Frequency Synthesis Accuracy | HRS §2 | 9.8 (via PLL) | Analysis | Open |
| 8 | GLR-008 | Digital Gain Control | HRS §3.1 | 9.10, 10 | Test | Open |
| 9 | GLR-009 | Flash Configuration Storage | HRS §3.5 | 9.5, 10 | Inspection | Open |
| 10 | GLR-010 | Low Phase Noise Implementation | HRS §2 | 4, 9.8 | Analysis | Open |
| 11 | GLR-011 | Register Map Compliance | HRS §3.3 | 10 | Inspection | Open |
| 12 | GLR-012 | 12V Power Consumption Limit | HRS §3.5 | 9.4 | Test | Open |