
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
|:---:|:---:|:---:|:---|:---|:---|
| 1 | 0V01 | 16.04.2026 | - | - | Initial Version |

---

## 1. Scope of the Document
This document explains the IO details and functional requirements of the FPGA for the **rbfgf** Wideband RF Receiver project. It serves as the bridge between the hardware Netlist (P4) and the FPGA HDL Design (P7). It details the signal interfaces, register map, communication protocols, and logic functionality required to control the RF front-end, ADC, and power subsystems.

**Target Audience:** Hardware Design Engineers, FPGA Firmware Engineers, and Systems Engineers.

---

## 2. References

### 2.1 External
| Doc. Type | Part No. | Description |
|:---|:---|:---|
| Datasheet | LMC6048 | 18 GHz Limiter |
| Datasheet | TGA4538 | 2-20 GHz LNA |
| Datasheet | HMC698LP4 | IQ Mixer / Downconverter |
| Datasheet | ADF5356 | PLL Synthesizer |
| Datasheet | ADRF5720 | IF VGA, Digital Gain, LVDS |
| Datasheet | ADC12J4000 | 12-Bit, 4 GSPS ADC |
| Datasheet | XCZU9EG-FFVB1156 | Zynq UltraScale+ FPGA |
| Datasheet | LTM4644 | Quad 4A DC-DC Regulator |
| Datasheet | LTM8063 | 36VIN Buck Regulator |
| Datasheet | ADP5054 | Quad Regulator |
| Datasheet | EQL4320 | Balun 1:4 |
| Datasheet | TCM1-43X+ | Balun 1:2 |

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
| **ADC** | Analog-to-Digital Converter |
| **AGC** | Automatic Gain Control |
| **BER** | Bit Error Rate |
| **BOM** | Bill of Materials |
| **BRAM** | Block RAM (FPGA) |
| **CLB** | Configurable Logic Block |
| **DAC** | Digital-to-Analog Converter |
| **DSP** | Digital Signal Processing |
| **EMC** | Electromagnetic Compatibility |
| **FF** | Flip-Flop |
| **FIFO** | First-In-First-Out Memory |
| **FPGA** | Field-Programmable Gate Array |
| **FSM** | Finite State Machine |
| **GPIO** | General Purpose Input/Output |
| **GND** | Ground Reference |
| **HDL** | Hardware Description Language |
| **I2C** | Inter-Integrated Circuit |
| **IO** | Input/Output |
| **JTAG** | Joint Test Action Group |
| **LVDS** | Low-Voltage Differential Signaling |
| **LUT** | Look-Up Table |
| **PCB** | Printed Circuit Board |
| **PLL** | Phase-Locked Loop |
| **POR** | Power-On Reset |
| **RF** | Radio Frequency |
| **RoHS** | Restriction of Hazardous Substances |
| **RTL** | Register Transfer Level |
| **SFDR** | Spurious-Free Dynamic Range |
| **SPI** | Serial Peripheral Interface |
| **UART** | Universal Asynchronous Receiver-Transmitter |
| **VCC** | Voltage Supply (Common) |
| **VCO** | Voltage-Controlled Oscillator |

---

## 4. Module Overview

The **rbfgf** module is a high-performance 5–18 GHz wideband RF receiver designed for military environments. The hardware is divided into three main subsections:

### RF SECTION
The RF chain processes signals from 5 to 18 GHz. It utilizes the **LMC6048** input limiter for protection up to 20 dBm, feeding into the **TGA4538** Wideband LNA (22 dB gain). Downconversion is handled by the **HMC698LP4** IQ Mixer, driven by an **ADF5356** wideband synthesizer (LO). The IF path passes through an **ADRF5720** digitally controlled Variable Gain Amplifier (VGA) with 30 dB range, featuring LVDS gain control interfaces. The IF signal is AC-coupled via baluns (**TCM1-43X+**) before digitization.

### DIGITAL SECTION
The digital core is the **XCZU9EG-FFVB1156** (Zynq UltraScale+) FPGA. This device performs all system control, timing generation, and high-speed data capture. It interfaces directly with the **ADC12J4000** (4 GSPS) via JESD204B/LVDS lanes to capture the digitized IF bandwidth. The FPGA provides SPI control for the PLL, VGA, and ADC configuration. It manages power sequencing, health monitoring, and communication with the host system via a UART control interface.

### POWER SUPPLY SECTION
Power is derived from a +28V military standard input. **LTM8063** buck regulators step down +28V to intermediate rails. The **LTM4644** provides the main +5V RF and Logic rails. The **ADP5054** generates the specific FPGA voltages (+3.3V, +1.8V, +1.0V) and ADC rails (+1.8V, +1.0V) with strict sequencing requirements monitored by the FPGA.

---

## 5. Features
- **FPGA:** Xilinx XCZU9EG-FFVB1156 (Zynq UltraScale+).
- **ADC:** Texas Instruments ADC12J4000 (12-bit, 4 GSPS).
- **RF Coverage:** 5 GHz to 18 GHz instantaneous reception.
- **Gain Control:** ADRF5720 Digital VGA with 30 dB range and LVDS control.
- **LO Synthesis:** ADF5356 Integrated PLL/VCO (-100 dBc/Hz phase noise).
- **Data Interface:** 12-bit LVDS/JESD204B output from ADC to FPGA.
- **Communication:** UART (via USB-UART bridge) for register control and SPI for RF components.
- **Power Management:** Remote monitoring of rails and temperature via FPGA GPIO.
- **Protection:** LMC6048 Limiter at input.

---

## 6. FPGA Description
**Selection Rationale:** The XCZU9EG-FFVB1156 was selected to meet the high-speed interface requirements (4 GSPS ADC capture) while providing ample logic resources for DSP and standard I/O for RF control in a military-grade temperature range package.

| S.NO | PARAMETERS | SPECIFICATION |
|:---:|:---|:---|
| 1 | Part Number | XCZU9EG-FFVB1156 |
| 2 | Logic Cells | ~500,000 (approx) |
| 3 | CLB Flip-Flops | ~600,000 (approx) |
| 4 | Number of Gates | 8M+ (ASIC equiv.) |
| 5 | Maximum Distributed RAM (Kb) | ~2000 |
| 6 | Total Block RAM (Kb) | ~2000 (approx 25 Mb) |
| 7 | Maximum Single-Ended I/Os | 400+ |
| 8 | Maximum DSP Slices | ~2000 |
| 9 | No of IO Bank | High-performance HP banks |

---

## 7. Block Diagram
*(Refer to System Block Diagram in Section 4 of HRS)*
The FPGA sits at the center of the digital domain.
- **Inputs:** ADC LVDS Data (12 bits), ADC CLK (P/N), Frame/Sync signals from ADC.
- **Control Outputs:** SPI_SCLK, SPI_SDIO (MOSI), SPI_SDIO (MISO), SPI_CS_N (PLL, VGA, ADC), LVDS Gain Control (VGA).
- **System Interfaces:** UART TX/RX, JTAG, Power Good Monitors, Clock Oscillator input.

---

## 8. Pinout Details

**Table: FPGA Pin Out Details**

| S.No | Signal Name | Pin No | Voltage Level | Direction wrt FPGA | Source | Destination | Default Condition | Voltage Standard |
|:---:|:---|:---:|:---|:---|:---|:---|:---|:---|
| **Power** |
| 1 | VCCO_0 | - | 1.8V | Power | LDO | FPGA Bank 0 | ON | LVCMOS18 |
| 2 | VCCO_1 | - | 3.3V | Power | LDO | FPGA Bank 1 | ON | LVCMOS33 |
| **Clock** |
| 3 | FPGA_CLK_125M | E12 | 3.3V | Input | OSC | FPGA | HIGH | LVDS / LVCMOS33 |
| **JTAG** |
| 4 | TCK | T5 | 1.8V | Input | Debugger | FPGA | Pull-down | LVCMOS18 |
| 5 | TDI | R4 | 1.8V | Input | Debugger | FPGA | Pull-up | LVCMOS18 |
| 6 | TDO | T6 | 1.8V | Output | FPGA | Debugger | High-Z | LVCMOS18 |
| 7 | TMS | R5 | 1.8V | Input | Debugger | FPGA | Pull-up | LVCMOS18 |
| **ADC Interface** |
| 8 | ADC_CLK_P | A15 | 1.8V | Input | ADC (U6) | FPGA | Swing | LVDS |
| 9 | ADC_CLK_N | B15 | 1.8V | Input | ADC (U6) | FPGA | Swing | LVDS |
| 10 | ADC_D0_P | C16 | 1.8V | Input | ADC (U6) | FPGA | Swing | LVDS |
| 11 | ADC_D0_N | D16 | 1.8V | Input | ADC (U6) | FPGA | Swing | LVDS |
| 12 | ADC_D1_P | ... | 1.8V | Input | ADC (U6) | FPGA | Swing | LVDS |
| 13 | ADC_D1_N | ... | 1.8V | Input | ADC (U6) | FPGA | Swing | LVDS |
| 14 | ADC_D2_P | ... | 1.8V | Input | ADC (U6) | FPGA | Swing | LVDS |
| 15 | ADC_D2_N | ... | 1.8V | Input | ADC (U6) | FPGA | Swing | LVDS |
| 16 | ADC_D3_P | ... | 1.8V | Input | ADC (U6) | FPGA | Swing | LVDS |
| 17 | ADC_D3_N | ... | 1.8V | Input | ADC (U6) | FPGA | Swing | LVDS |
| 18 | ADC_D4_P | ... | 1.8V | Input | ADC (U6) | FPGA | Swing | LVDS |
| 19 | ADC_D4_N | ... | 1.8V | Input | ADC (U6) | FPGA | Swing | LVDS |
| 20 | ADC_D5_P | ... | 1.8V | Input | ADC (U6) | FPGA | Swing | LVDS |
| 21 | ADC_D5_N | ... | 1.8V | Input | ADC (U6) | FPGA | Swing | LVDS |
| 22 | ADC_D6_P | ... | 1.8V | Input | ADC (U6) | FPGA | Swing | LVDS |
| 23 | ADC_D6_N | ... | 1.8V | Input | ADC (U6) | FPGA | Swing | LVDS |
| 24 | ADC_D7_P | ... | 1.8V | Input | ADC (U6) | FPGA | Swing | LVDS |
| 25 | ADC_D7_N | ... | 1.8V | Input | ADC (U6) | FPGA | Swing | LVDS |
| 26 | GPIO_LE_P | H4 | 1.8V | Input | ADC (U6) | FPGA | - | LVDS |
| 27 | GPIO_LE_N | J4 | 1.8V | Input | ADC (U6) | FPGA | - | LVDS |
| **SPI (PLL)** |
| 28 | SPI_PLL_SCLK | K10 | 3.3V | Output | FPGA | PLL (U4) | Low | LVCMOS33 |
| 29 | SPI_PLL_SDIO | L10 | 3.3V | Bi-Di | FPGA | PLL (U4) | High-Z | LVCMOS33 |
| 30 | SPI_PLL_CS_N | M11 | 3.3V | Output | FPGA | PLL (U4) | High | LVCMOS33 |
| **SPI (VGA)** |
| 31 | SPI_VGA_SCLK | N10 | 3.3V | Output | FPGA | VGA (U5) | Low | LVCMOS33 |
| 32 | SPI_VGA_SDIO | P10 | 3.3V | Bi-Di | FPGA | VGA (U5) | High-Z | LVCMOS33 |
| 33 | SPI_VGA_CS_N | R11 | 3.3V | Output | FPGA | VGA (U5) | High | LVCMOS33 |
| **SPI (ADC)** |
| 34 | SPI_ADC_SCLK | T10 | 3.3V | Output | FPGA | ADC (U6) | Low | LVCMOS33 |
| 35 | SPI_ADC_SDIO | U10 | 3.3V | Bi-Di | FPGA | ADC (U6) | High-Z | LVCMOS33 |
| 36 | SPI_ADC_CS_N | V11 | 3.3V | Output | FPGA | ADC (U6) | High | LVCMOS33 |
| **Control / RF** |
| 37 | PLL_LOCK | A5 | 3.3V | Input | PLL (U4) | FPGA | Low | LVCMOS33 |
| 38 | VGA_GAIN_CTRL0 | B6 | 3.3V | Output | FPGA | VGA (U5) | Low | LVCMOS33 |
| 39 | VGA_GAIN_CTRL1 | C7 | 3.3V | Output | FPGA | VGA (U5) | Low | LVCMOS33 |
| 40 | MIXER_EN | D8 | 3.3V | Output | FPGA | Mixer (U3) | Low | LVCMOS33 |
| 41 | LNA_EN | E8 | 3.3V | Output | FPGA | LNA (U2) | Low | LVCMOS33 |
| **System** |
| 42 | FPGA_RESET_N | F1 | 3.3V | Input | Reset_Circuit | FPGA | High | LVCMOS33 |
| 43 | PWR_GOOD_FPGA | G2 | 3.3V | Input | PMIC (U11) | FPGA | Low | LVCMOS33 |
| 44 | FPGA_DONE | H3 | 1.8V | Output | FPGA | LED | Low | LVCMOS18 |
| 45 | USB_UART_TX | J1 | 3.3V | Output | FPGA | USB_Bridge | High | LVCMOS33 |
| 46 | USB_UART_RX | K2 | 3.3V | Input | USB_Bridge | FPGA | High | LVCMOS33 |

---

## 9. Functional Specifications

| S.No. | Function Name | Description |
|:---:|:---|:---|
| 1 | Serial Communication Interface | UART for register and control access. |
| 2 | High Speed Interface | 12-bit LVDS capture from ADC at up to 4 Gsps. |
| 3 | Power Supply Sequencing | Monitoring of +3.3V, +1.8V, +1.0V rails via PWR_GOOD. |
| 4 | SPI Control | Master SPI for PLL (ADF5356), VGA (ADRF5720), and ADC config. |
| 5 | RF Path Control | Enable/Disable LNA and Mixer; Control Gain. |
| 6 | PLL Lock Detection | Monitoring of PLL_LOCK signal from ADF5356. |
| 7 | Data Processing | Decimation/Filtering of IF data (FIR/DUC). |
| 8 | Remote Update | FPGA bitstream update via UART. |

### 9.1 Serial Communication Interface
- **Interface Type:** UART
- **Physical Layer:** RS-232 / TTL via USB Bridge.
- **Baud Rate:** 115200 bps (Standard)
- **Frame Format:** 1 Start bit, 8 Data bits, No Parity, 1 Stop bit (8N1).
- **Protocol:** Register-based Read/Write (see Section 11).

### 9.2 High Speed Communication Interface
- **Interface:** LVDS (Source Synchronous)
- **Data Width:** 12 bits (D0-D11) + Frame Clock.
- **Data Rate:** Up to 4 Gbps per lane (handled by XCZU9EG HP I/O).
- **Protocol:** JESD204B subclass 0 or compatible raw LVDS capture mode.

### 9.3 Power On/Off Sequence
#### 9.3.1 Power ON/OFF Sequence
1. **+28V Applied:** LTM8063 and LTM4644 enable.
2. **+3.3V/+5V Stable:** ADP5054 enables FPGA rails.
3. **Power Good:** ADP5054 asserts `PWR_GOOD_FPGA`.
4. **FPGA Boot:** Configuration loads from Flash.
5. **Initialization:** FPGA asserts `LNA_EN` and `MIXER_EN`.
6. **ADC Calibration:** FPGA resets ADC via SPI.

### 9.4 Supply Voltage, Current & Temperature Monitoring
- **Method:** Analog monitoring via ADP5054 PMIC GPIOs and internal FPGA XADC.
- **Rails:** +1.0V (VCCINT), +1.8V (VCCINT_IO), +3.3V (VCCAUX).
- **Alert:** `TEMP_ALERT_FPGA` LED asserted if internal XADC temp > 100°C.

### 9.5 Flash & Interfaces
- **Configuration Flash:** Not explicitly on BOM but assumed to be SPI Flash connected to FPGA Boot pins (Standard Zynq QSPI).
- **Storage:** Reserved for ADC calibration tables and PLL LUTs.

### 9.6 RF Path & Gain Control
- **Components:** LNA (TGA4538), Mixer (HMC698LP4), VGA (ADRF5720).
- **LNA Control:** `LNA_EN` signal (Active High).
- **Mixer Control:** `MIXER_EN` signal (Active High).
- **Gain Control:** `VGA_GAIN_CTRL[1:0]` pins parallel the LVDS interface. Primary control is via SPI (writes to ADRF5720).

### 9.7 PLL Configuration (ADF5356)
- **Interface:** SPI (3-wire: SCLK, SDIO, CS_N).
- **Frequency Range:** 5 GHz to 18 GHz (RF out).
- **Lock Time:** <100 us.
- **Lock Detect:** `PLL_LOCK` signal monitored by FPGA for system ready status.

---

## 10. Software Register Address Map

### 10.1 Register Base Addresses

| Block Name | Base Address | Address Range | Description |
|:---|:---:|:---|:---|
| System / Identification | 0x0000 | 0x0000–0x00FF | Board ID, firmware version, status |
| UART Control | 0x0100 | 0x0100–0x01FF | Baud rate, FIFO control |
| SPI Master Control | 0x0200 | 0x0200–0x02FF | SPI divisors, CS control |
| GPIO Control | 0x0300 | 0x0300–0x03FF | RF Enables, LEDs, Misc IO |
| RF Control (VGA) | 0x0400 | 0x0400–0x04FF | Gain settings, Attenuation |
| RF Control (PLL) | 0x0500 | 0x0500–0x05FF | Frequency tuning, Int/N frac |
| ADC Control | 0x0600 | 0x0600–0x06FF | ADC config, Power down |
| Diagnostics / XADC | 0x0A00 | 0x0A00–0x0AFF | Temp, Voltage rails |

### 10.2 Detailed Register Map

**Block 0x0000 — System / Identification**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|:---:|:---|:---:|:---:|:---:|:---|
| 0x00 | BOARD_ID | 16 | R | 0xBFBF | Board identification code (Magic Number) |
| 0x01 | FW_VERSION | 16 | R | 0x0100 | Firmware version (Major.Minor) |
| 0x02 | SYS_STATUS | 16 | R | 0x0000 | [0] PLL_LOCK, [1] PWR_GOOD, [2] ADC_CAL_DONE |
| 0x03 | SYS_RESET | 16 | W | 0x0000 | [0] SOFT_RESET (Write 1 to trigger) |
| 0x04 | CLK_SELECT | 16 | R/W | 0x0000 | [0] CLK_SRC (0=OSC, 1=ADC_CLK) |

**Block 0x0300 — GPIO Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|:---:|:---|:---:|:---:|:---:|:---|
| 0x00 | GPIO_DATA | 16 | R/W | 0x0000 | [0] LNA_EN, [1] MIXER_EN, [2] LED_STATUS |
| 0x01 | GPIO_DIR | 16 | R/W | 0xFFFF | Direction (0=In, 1=Out) |
| 0x02 | GPIO_READ | 16 | R | 0x0000 | Read input pins (current state) |

**Block 0x0400 — RF Control (VGA)**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|:---:|:---|:---:|:---:|:---:|:---|
| 0x00 | VGA_GAIN | 16 | R/W | 0x0000 | Gain setting (0-1023, mapped to 0-30dB) |
| 0x01 | VGA_SPI_CTRL | 16 | R/W | 0x0000 | Triggers SPI transaction to VGA |

**Block 0x0500 — RF Control (PLL)**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|:---:|:---|:---:|:---:|:---:|:---|
| 0x00 | PLL_FREQ_HIGH | 16 | R/W | 0x0000 | Frequency Integer bits (High) |
| 0x01 | PLL_FREQ_LOW | 16 | R/W | 0x0000 | Frequency Fractional bits (Low) |
| 0x02 | PLL_REG_ADDR | 16 | R/W | 0x0000 | ADF5356 Register Address |
| 0x03 | PLL_REG_DATA | 16 | R/W | 0x0000 | ADF5356 Register Data |
| 0x04 | PLL_WRITE | 16 | W | 0x0000 | Write 1 to execute SPI Write to PLL |

**Block 0x0600 — ADC Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|:---:|:---|:---:|:---:|:---:|:---|
| 0x00 | ADC_PDWN | 16 | R/W | 0x0001 | [0] Power Down (1=PD, 0=ON) |
| 0x01 | ADC_TEST | 16 | R/W | 0x0000 | [0] Test Pattern Enable |

---

## 11. UART Register Protocol Specification

### 11.1 Physical Layer
- **Baud Rate:** 115200
- **Data Bits:** 8
- **Parity:** None
- **Stop Bits:** 1

### 11.2 Command Frame Formats

**Single Register Write (CMD = 0x57 'W'):**
```
Byte 0: 0x57 (CMD)
Byte 1: ADDR[15:8] (address MSB)
Byte 2: ADDR[7:0]  (address LSB)
Byte 3: DATA[15:8] (data MSB)
Byte 4: DATA[7:0]  (data LSB)
→ Response: 0x06 (ACK) within 2ms
Total: 5 bytes TX, 1 byte RX
```

**Single Register Read (CMD = 0x52 'R'):**
```
Byte 0: 0x52 (CMD)
Byte 1: (ADDR[15:8] | 0x80) (MSB with read bit set)
Byte 2: ADDR[7:0]          (address LSB)
→ Response: DATA[15:8], DATA[7:0] within 2ms
Total: 3 bytes TX, 2 bytes RX
```

**Bulk Register Write (CMD = 0x42 'B'):**
```
Byte 0: 0x42 (CMD)
Byte 1: ADDR[15:8] (start address MSB)
Byte 2: ADDR[7:0]  (start address LSB)
Byte 3: N          (register count, 1–64)
Byte 4..4+2N-1: DATA[0]_H, DATA[0]_L, ..., DATA[N-1]_H, DATA[N-1]_L
→ Response: 0x06 (ACK)
Total: (4 + 2N) bytes TX, 1 byte RX
```

**Bulk Register Read (CMD = 0x62 'b'):**
```
Byte 0: 0x62 (CMD)
Byte 1: (ADDR[15:8] | 0x80)
Byte 2: ADDR[7:0]
Byte 3: N             (register count, 1–64)
→ Response: DATA[0]_H...DATA[N-1]_L
Total: 4 bytes TX, 2N bytes RX
```

### 11.3 Error Handling
- **NAK (0x15):** Returned if Address Out of Bounds, or Command Invalid.

---

## 12. FPGA Resource Utilization Estimate

| Resource | Available | Estimated Usage | Utilization % |
|:---|:---:|:---:|:---:|
| Slice LUTs | 260,000 (approx) | 45,000 | ~17% |
| Slice Registers | 520,000 (approx) | 30,000 | ~6% |
| Block RAM (36Kb) | 900 | 120 | ~13% |
| DSP Slices | 1,968 | 200 | ~10% |
| IO Banks | - | - | ~40% (Active Banks) |

**Synthesis Tool:** Vivado 2026.1
**Target Device:** XCZU9EG-FFVB1156

---

## Annexure A — Requirement Traceability Matrix

| S.No | GLR-ID | Description | Source HRS Section | GLR Section | Verification Method | Status |
|:---:|:---|:---|:---|:---|:---|:---|
| 1 | GLR-001 | RF Input Limiter Protection | HRS §3.1 | 4, 8 | Test | Open |
| 2 | GLR-002 | LNA Gain Control | HRS §3.1 | 9.6, 10.2 | Test | Open |
| 3 | GLR-003 | PLL Synthesizer Interface | HRS §3.1 | 8, 10.2 | Test | Open |
| 4 | GLR-004 | ADC Data Interface (LVDS) | HRS §3.5 | 8, 9.2 | Test | Open |
| 5 | GLR-005 | Power Supply Monitoring | HRS §3.2, 3.4 | 9.4 | Test | Open |
| 6 | GLR-006 | Serial Control Interface | HRS §3.5 | 9.1, 11 | Test | Open |
| 7 | GLR-007 | Environmental Temp Range | HRS §3.3 | 4 | Analysis | Open |
| 8 | GLR-008 | FPGA Register Map | HRS §3.5 | 10 | Inspection | Open |
| 9 | GLR-009 | UART Protocol | HRS §3.5 | 11 | Test | Open |
| 10 | GLR-010 | VGA Control Logic | HRS §3.1 | 9.6, 10.2 | Test | Open |