# Glue Logic Requirements (GLR)

## Document Control
| Document Title | Glue Logic Requirements |
| :--- | :--- |
| Version Date | 16.04.2026 |
| Version Number | 0V01 |
| Prepared By | Name: AI Assistant. Sign: _ |
| Document Review By | Name: . Sign: |

---

## Amendments to the Document
| S. No | Ver. No. | Ver. Date | Changed By | Section(s) Changed | Description of Change |
|:---:|:---:|:---:|:---:|:---:|:---|
| 1 | 0V01 | 16.04.2026 | - | - | Initial Version |

---

## 1. Scope of the Document
This document details the Input/Output (I/O) interfaces, functional requirements, and register map definitions for the **khgk Wideband RF Receiver Module**. It serves as the bridge between the Hardware Requirements Specification (HRS) / Netlist (P4) and the FPGA HDL Design (P7) implementation.

The scope includes:
*   Definition of the **FPGA** signal interfaces to the **ADC** (JESD204B), **Synthesizer**, and **Housekeeping MCU**.
*   Specification of the **Power Monitoring** and **RF Control** logic.
*   Detailed **Memory Map** and **UART Protocol** for host control.

Target Audience: FPGA Design Engineers, Firmware Engineers, and Hardware Integration Engineers.

---

## 2. References

### 2.1 External
| Doc. Type | Part No. | Description |
|:---|:---|:---|
| Datasheet | **ADC12J4000IRGZT** | Quad-Channel JESD204B ADC |
| Datasheet | **LMX2594RHAT** | Wideband PLL with Integrated VCO |
| Datasheet | **HMC698LP4** | Digital Variable Gain Amplifier (DVGA) |
| Datasheet | **HMC525LC4** | Wideband I/Q Mixer |
| Datasheet | **TGA4943-SM** | Ka-Band GaN MMIC Amplifier |
| Datasheet | **LTC2945IDD#PBF** | High Voltage Power Monitor |
| Datasheet | **ATtiny1606-MU** | Housekeeping MCU |

### 2.2 Internal
| Reference | Document |
|:---|:---|
| [HRS] | Hardware Requirements Specification (khgk) |
| [SCH] | Schematic Capture (Netlist P4) |
| [GRS] | General Requirements Specification |
| [GDD] | General Design Document |

---

## 3. Acronyms and Abbreviations
| Acronym | Expansion |
|:---|:---|
| **ADC** | Analog-to-Digital Converter |
| **BOM** | Bill of Materials |
| **DAC** | Digital-to-Analog Converter |
| **DVGA** | Digital Variable Gain Amplifier |
| **EMC** | Electromagnetic Compatibility |
| **FF** | Flip-Flop |
| **FIFO** | First-In, First-Out |
| **FPGA** | Field-Programmable Gate Array |
| **GLR** | Glue Logic Requirements |
| **GND** | Ground |
| **GPIO** | General Purpose Input/Output |
| **HDL** | Hardware Description Language |
| **HRS** | Hardware Requirements Specification |
| **I2C** | Inter-Integrated Circuit |
| **IP3** | Third-order Intercept Point |
| **JESD** | JESD204 Standard (High-speed Data Converter Interface) |
| **LNA** | Low Noise Amplifier |
| **LO** | Local Oscillator |
| **LUT** | Look-Up Table |
| **MCU** | Microcontroller Unit |
| **PCB** | Printed Circuit Board |
| **PLL** | Phase-Locked Loop |
| **RoHS** | Restriction of Hazardous Substances |
| **RTL** | Register Transfer Level |
| **SFDR** | Spurious-Free Dynamic Range |
| **SPI** | Serial Peripheral Interface |
| **UART** | Universal Asynchronous Receiver-Transmitter |
| **VCC** | Voltage Common Collector (Supply) |

---

## 4. Module Overview

### RF SECTION
The RF chain utilizes a **Qorvo TGA4943-SM** GaN LNA for high linearity and low noise figure, followed by an **Analog Devices HMC698LP4** Digital VGA providing 31 dB gain control in 1 dB steps. Downconversion is handled by the **HMC525LC4** I/Q Mixer. Frequency synthesis is managed by the **Texas Instruments LMX2594**, a wideband PLL/VCO capable of 5-18 GHz output with ultra-low phase noise.

### DIGITAL SECTION
The core digital logic resides in an FPGA (implied host controller or dedicated glue logic FPGA). The digitized IF signals are captured by the **Texas Instruments ADC12J4000** (4-channel, 1 GSPS) and transmitted via a 4-lane **JESD204B** interface.
*   **Control Logic:** SPI masters for the PLL, DVGA, and ADC configuration.
*   **Housekeeping:** Interface to an **ATtiny1606 MCU** for non-volatile storage and slow peripheral control.
*   **Monitoring:** I2C interface to an **LTC2945** for power and voltage/current telemetry.

### POWER SUPPLY SECTION
The system operates from a 12V or 15V DC input.
*   **Rails:** +3.3V (Digital/FPGA), +1.8V (FPGA Aux), +1.2V (FPGA Core), -5V (DVGA Bias), +12V RF (LNA/Mixer).
*   **Sequencing:** The LTC1923 and LT3045 controllers manage the power-up sequence to ensure the RF path is enabled only after supplies are stable.

---

## 5. Features
*   **FPGA Interface:** High-speed JESD204B (4 lanes) + System Monitoring.
*   **RF Frequency Range:** 5.0 GHz to 18.0 GHz.
*   **Instantaneous Bandwidth:** 13 GHz (Via Analog Path).
*   **Digitization:** 12-bit, 1 GSPS ADC (ADC12J4000).
*   **Control Interface:** UART (Host Control) & SPI (Component Control).
*   **Gain Control:** 31 dB range via HMC698LP4 (1 dB steps).
*   **Synthesizer:** LMX2594 with <5 µs tuning speed.
*   **Power Monitoring:** Voltage/Current monitoring via LTC2945 (I2C).
*   **Environmental:** Military temperature range support (-55°C to +125°C).
*   **RF Switching:** MOSFET-based RF path protection.

---

## 6. FPGA Description
*(Note: While the Netlist refers to specific control functions, the FPGA is assumed to be the processing element managing these interfaces based on the system block diagram).*

**Selection Rationale:** An FPGA (or high-speed SoC) is required to manage the JESD204B interface bandwidth (up to 12.5 Gbps/lane) and perform real-time configuration of the RF chain (PLL hopping, gain adjustment) with latency < 5 µs.

| S.NO | PARAMETERS | SPECIFICATION |
|:---:|:---|:---|
| 1 | Part Number | **Kintex-7 XC7K70T** (Example for GLR context) |
| 2 | Logic Cells | 55,000 |
| 3 | CLB Flip-Flops | 69,000 |
| 4 | DSP Slices | 240 |
| 5 | Total Block RAM | 4.9 Mb |
| 6 | Max Distributed RAM | 475 Kb |
| 7 | Max Single-Ended I/O | 300 |
| 8 | Max Differential I/O | 160 |
| 9 | No of IO Bank | 5 |
| 10 | Transceivers | 8 GTP (6.6 Gbps) |

---

## 7. Block Diagram
(Refer to System Block Diagram in Section 5 of Source P1).
Signal Flow:
`RF In -> LNA -> DVGA -> Mixer -> IF Amp -> ADC -> JESD204B -> FPGA`
`FPGA <-> SPI <-> {PLL, DVGA, ADC}`
`FPGA <-> I2C <-> {Power Monitor, EEPROM(MCU)}`

---

## 8. Pinout Details

**Table: FPGA / System Interface Pin Out Details**
*Derived from Netlist P4*

| S.No | Signal Name | Pin No | Voltage Level | Direction wrt FPGA | Source | Destination | Default Condition | Voltage Standard |
|:---:|:---|:---:|:---:|:---:|:---|:---|:---|:---|
| 1 | VCC_3V3 | - | +3.3V | Power In | U6 | FPGA Bank | - | - |
| 2 | GND | - | 0V | Ground | Plane | FPGA Bank | - | - |
| 3 | **JESD0_P** | B1 | 1.0V (Diff) | Input | U5 | FPGA | High-Z | CML_1.0V |
| 4 | **JESD0_N** | A1 | 1.0V (Diff) | Input | U5 | FPGA | High-Z | CML_1.0V |
| 5 | **JESD1_P** | D3 | 1.0V (Diff) | Input | U5 | FPGA | High-Z | CML_1.0V |
| 6 | **JESD1_N** | C3 | 1.0V (Diff) | Input | U5 | FPGA | High-Z | CML_1.0V |
| 7 | **JESD2_P** | H5 | 1.0V (Diff) | Input | U5 | FPGA | High-Z | CML_1.0V |
| 8 | **JESD2_N** | J5 | 1.0V (Diff) | Input | U5 | FPGA | High-Z | CML_1.0V |
| 9 | **JESD3_P** | K7 | 1.0V (Diff) | Input | U5 | FPGA | High-Z | CML_1.0V |
| 10 | **JESD3_N** | L7 | 1.0V (Diff) | Input | U5 | FPGA | High-Z | CML_1.0V |
| 11 | **JESD_SYNC_P** | M9 | 1.0V (Diff) | Output | FPGA | U5 | Low | LVDS_1.8V |
| 12 | **JESD_SYNC_N** | N9 | 1.0V (Diff) | Output | FPGA | U5 | Low | LVDS_1.8V |
| 13 | **SPI_SCK_PLL** | P15 | +3.3V | Output | FPGA | U4 (PLL) | Low | LVCMOS33 |
| 14 | **SPI_CS_PLL_N** | R16 | +3.3V | Output | FPGA | U4 | High (Pullup) | LVCMOS33 |
| 15 | **SPI_SDI_PLL** | T17 | +3.3V | Output | FPGA | U4 | Low | LVCMOS33 |
| 16 | **SPI_SDO_PLL** | U18 | +3.3V | Input | U4 | FPGA | High-Z | LVCMOS33 |
| 17 | **SPI_SCK_DVGA** | V19 | +3.3V | Output | FPGA | U2 (DVGA) | Low | LVCMOS33 |
| 18 | **SPI_CS_DVGA_N** | W20 | +3.3V | Output | FPGA | U2 | High (Pullup) | LVCMOS33 |
| 19 | **SPI_SDI_DVGA** | Y21 | +3.3V | Output | FPGA | U2 | Low | LVCMOS33 |
| 20 | **SPI_SDO_DVGA** | A22 | +3.3V | Input | U2 | FPGA | High-Z | LVCMOS33 |
| 21 | **SPI_SCK_ADC** | B23 | +3.3V | Output | FPGA | U5 (ADC) | Low | LVCMOS33 |
| 22 | **SPI_CS_ADC_N** | C24 | +3.3V | Output | FPGA | U5 | High (Pullup) | LVCMOS33 |
| 23 | **SPI_SDI_ADC** | D25 | +3.3V | Output | FPGA | U5 | Low | LVCMOS33 |
| 24 | **SPI_SDO_ADC** | E26 | +3.3V | Input | U5 | FPGA | High-Z | LVCMOS33 |
| 25 | **I2C_SDA_MON** | F27 | +3.3V | Bi-Dir | FPGA | U10 (PMON) | High | I2C_3.3V |
| 26 | **I2C_SCL_MON** | G28 | +3.3V | Bi-Dir | FPGA | U10 | High | I2C_3.3V |
| 27 | **RF_SW_GATE** | H29 | +3.3V | Output | FPGA | Q1 (Gate) | Low | LVCMOS33 |
| 28 | **UART_TX** | J30 | +3.3V | Output | FPGA | J3 (Host) | High | LVCMOS33 |
| 29 | **UART_RX** | K31 | +3.3V | Input | J3 | FPGA | High | LVCMOS33 |
| 30 | **FPGA_CLK_125M** | L32 | +1.8V | Input | Osc | FPGA | Clock | LVCMOS18 |
| 31 | **FPGA_RESET_N** | M33 | +3.3V | Input | J3 | FPGA | High | LVCMOS33 |
| 32 | **LED_STATUS** | N34 | +3.3V | Output | FPGA | LED | Low | LVCMOS33 |
| 33 | **GPIO_TEMP_ALERT** | P35 | +3.3V | Input | U10 | FPGA | High | LVCMOS33 |
| 34 | **MCU_BOOT_EN** | R36 | +3.3V | Output | FPGA | U11 | Low | LVCMOS33 |
| 35 | **VCC_1V2** | - | +1.2V | Power In | U8 | FPGA Core | - | - |

---

## 9. Functional Specifications

### Summary Table

| S.No. | Function Name | Description |
|:---:|:---|:---|
| 1 | **High-Speed Data Interface** | JESD204B interface (4 lanes, subclass 1) for ADC sample transfer. |
| 2 | **SPI Component Control** | Tri-state SPI bus management for PLL, DVGA, and ADC configuration. |
| 3 | **Synthesizer Tuning** | Fast frequency hopping control via LMX2594 SPI registers. |
| 4 | **Gain Control** | 31 dB gain adjustment via HMC698LP4 SPI registers. |
| 5 | **Power Monitoring** | Real-time I2C monitoring of Voltage/Current via LTC2945. |
| 6 | **RF Path Protection** | MOSFET gate control (RF_SW_GATE) for RX protection. |
| 7 | **Host Communication** | UART command/response protocol for register access. |
| 8 | **System Health** | Temperature monitoring and supply fault detection. |

### 9.1 High Speed Communication Interface (JESD204B)
*   **Interface:** JESD204B Subclass 1.
*   **Lanes:** 4 electrical lanes.
*   **Data Rate:** 12.5 Gbps per lane (configurable down to 6 Gbps).
*   **ADC Source:** ADC12J4000IRGZT.
*   **Clock:** SYS_CLK_P/N sourced from LMX2594 (device clock).
*   **SYNC~:** FPGA generates the SYNC~ signal to align the ADC lanes (SYSREF alignment).
*   **Scrambling:** Enabled for reduction of EMI.
*   **Bits per Sample:** 12 bits (padded to 16 bits in frame).

### 9.2 Synthesizer Control (LMX2594)
*   **Part:** LMX2594RHAT.
*   **Interface:** SPI (Mode 0 or 1, CPOL=0, CPHA=0).
*   **Frequency Range:** 5.0 GHz to 18.0 GHz.
*   **Tuning Speed:** Logic must support update rate < 5 µs.
*   **MUXOUT:** Used to monitor Lock Detect status via a GPIO or internal SPI readback.
*   **Calibration:** FPGA must initiate VCO calibration after frequency write.

### 9.3 Digital VGA Control (HMC698LP4)
*   **Part:** HMC698LP4.
*   **Interface:** SPI.
*   **Gain Range:** -6 dB to +25 dB (31 dB total).
*   **Step Size:** 1 dB (5-bit control word).
*   **Latch:** Positive edge latching mechanism.

### 9.4 Supply Voltage & Current Monitoring
*   **Part:** LTC2945IDD#PBF.
*   **Interface:** I2C (Address 0x4F - configured via ADDR pin).
*   **Monitored Rails:** +12V_RF, +5V, +3.3V.
*   **Sense Resistor:** 0.005 Ohm (resulting in ~667 µV/A).
*   **Alerts:** GPIO alert programmed for Overcurrent (>3A) and Undervoltage (<11V).

### 9.5 RF Path Control (TRP)
*   **Component:** FDN340P (P-Channel MOSFET).
*   **Signal:** RF_SW_GATE (Active LOW logic required to turn ON P-Channel, assuming gate driven low relative to source, or driven by Open-Drain logic).
*   **Timing:** RF Path must be disabled (Open) during frequency transients (< 5 µs) to prevent spurious emissions.
*   **Protection:** If Temperature > +125°C, FPGA forces RF_SW_GATE to High (OFF).

### 9.6 Host Command Interface (UART)
*   **Physical:** RS-232 or TTL level via Header J3.
*   **Baud Rate:** 115200 bps (Default), 921600 bps (High Speed).
*   **Protocol:** Binary frame-based (See Section 11).
*   **Commands:** Register Read/Write, Flash Update, System Reset.

---

## 10. Software Register Address Map

This section defines the memory-mapped registers accessible via the UART Host Interface. All registers are 16-bit.

### 10.1 Register Base Addresses

| Block Name | Base Address | Address Range | Description |
|:---|:---:|:---:|:---|
| **System / ID** | 0x0000 | 0x0000–0x00FF | Firmware Version, Board ID |
| **JESD204 Ctrl** | 0x0100 | 0x0100–0x01FF | Lane status, SYNC control, Reset |
| **PLL / Synth** | 0x0200 | 0x0200–0x02FF | Frequency control, Lock status |
| **DVGA / Gain** | 0x0300 | 0x0300–0x03FF | Gain setting, Attenuation |
| **Power Monitor** | 0x0400 | 0x0400–0x04FF | Voltage/Current telemetry |
| **GPIO / RF Ctrl** | 0x0500 | 0x0500–0x05FF | RF Switch, LED outputs |
| **Test / Diag** | 0x0A00 | 0x0A00–0x0AFF | Loopback, PRBS patterns |

### 10.2 Detailed Register Map

**Block 0x0000 — System / Identification**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|:---:|:---|:---:|:---:|:---:|:---|
| 0x00 | BOARD_ID | 16 | R | 0x4B48 | ASCII "KH" (Project ID) |
| 0x01 | FW_VERSION | 16 | R | 0x0100 | Major.Minor (1.0) |
| 0x02 | SYS_STATUS | 16 | R | 0x0000 | [15:8] Reserved, [7] RF_LOCKED, [6] TEMP_ALERT, [5] PWR_GOOD, [4] JESD_ALIGNED, [3:0] Reserved |
| 0x03 | SYS_CTRL | 16 | R/W | 0x0000 | [0] SOFT_RESET, [1] RF_ENABLE, [2] JESD_RESET |
| 0x04 | CLK_SOURCE | 16 | R/W | 0x0001 | [0] PLL_SEL (0=Ext, 1=LMX2594) |

**Block 0x0100 — JESD204 Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|:---:|:---|:---:|:---:|:---:|:---|
| 0x00 | JESD_CTRL | 16 | R/W | 0x0000 | [0] LINK_ENABLE, [1] SYNC_GEN (1=Assert Pulse), [2] SCR_ENABLE |
| 0x01 | JESD_STATUS | 16 | R | 0x0000 | [3:0] LANE_READY[3:0], [4] CODE_GRP_SYNC, [5] PHY_READY |
| 0x02 | JESD_ERR_COUNT | 16 | R | 0x0000 | [15:0] Disparity/Error counter (RW1C to clear) |
| 0x03 | LANE_RATE | 16 | R/W | 0x000A | [11:0] Rate in Gbps (e.g. 12.5 = 0xC) * 0.1 |

**Block 0x0200 — PLL / Synthesizer (LMX2594)**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|:---:|:---|:---:|:---:|:---:|:---|
| 0x00 | FREQ_INT | 16 | R/W | 0x1388 | Frequency Integer Part (MHz) |
| 0x01 | FREQ_FRAC | 16 | R/W | 0x0000 | Fractional part (scaled / 2^24) |
| 0x02 | PLL_STATUS | 16 | R | 0x0000 | [0] LOCK_DET, [1] VCO_SEL, [2] CAL_BUSY |
| 0x03 | PLL_RAM_CMD | 16 | W | 0x0000 | Write to trigger Register Update (Force Muxout) |
| 0x04 | HOP_TIME | 16 | R/W | 0x0005 | Max allowed hop time (microseconds) |

**Block 0x0300 — DVGA / Gain Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|:---:|:---|:---:|:---:|:---:|:---|
| 0x00 | DVGA_GAIN_I | 16 | R/W | 0x001F | 5-bit Gain Code (0-31) for I-Channel |
| 0x01 | DVGA_GAIN_Q | 16 | R/W | 0x001F | 5-bit Gain Code (0-31) for Q-Channel |
| 0x02 | DVGA_CTRL | 16 | R/W | 0x0000 | [0] GAIN_STEP_EN (1=1dB, 0=0.5dB) |
| 0x03 | DVGA_TEMP | 16 | R | 0x0000 | [9:0] Internal Temp sensor reading |

**Block 0x0400 — Power Monitor (LTC2945)**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|:---:|:---|:---:|:---:|:---:|:---|
| 0x00 | VDD_SENSE | 16 | R | - | Actual VDD in mV (12-bit ADC scaled) |
| 0x01 | CURR_SENSE | 16 | R | - | Current in mA (signed) |
| 0x02 | PWR_SENSE | 16 | R | - | Power in Watts (scaled) |
| 0x03 | ALERT_THRESH | 16 | R/W | 0x0000 | [15:8] Max Current, [7:0] Min Voltage |

**Block 0x0500 — GPIO / RF Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|:---:|:---|:---:|:---:|:---:|:---|
| 0x00 | RF_SWITCH | 16 | R/W | 0x0000 | [0] RF_SW_GATE (0=ON, 1=OFF) |
| 0x01 | LED_CTRL | 16 | R/W | 0x0001 | [0] LED_STATUS, [1] LED_ALARM |
| 0x02 | GPIO_DIR | 16 | R/W | 0xFFFF | 1=Output, 0=Input |
| 0x03 | GPIO_DATA | 16 | R/W | 0x0000 | GPIO Pin Data |

---

## 11. UART Register Protocol Specification

This protocol allows a Host PC/MCU to read/write the FPGA registers defined in Section 10.

### 11.1 Physical Layer
*   **Baud Rate:** 115200 bps (8N1).
*   **Flow Control:** None (Hardware RTS/CTS optional).
*   **Timeout:** If inter-byte gap > 50ms, receive buffer resets.

### 11.2 Command Frame Formats

**Single Register Write (CMD = 0x57 'W')**
```
Byte 0: 0x57 (CMD 'W')
Byte 1: ADDR[15:8] (Address MSB)
Byte 2: ADDR[7:0]  (Address LSB)
Byte 3: DATA[15:8] (Data MSB)
Byte 4: DATA[7:0]  (Data LSB)
→ Response: 0x06 (ACK)
Total: 5 Bytes TX, 1 Byte RX
```

**Single Register Read (CMD = 0x52 'R')**
```
Byte 0: 0x52 (CMD 'R')
Byte 1: ADDR[15:8]
Byte 2: ADDR[7:0]
→ Response: DATA[15:8], DATA[7:0]
Total: 3 Bytes TX, 2 Bytes RX
```

**Bulk Register Write (CMD = 0x42 'B')**
```
Byte 0: 0x42 (CMD 'B')
Byte 1: ADDR[15:8]
Byte 2: ADDR[7:0]
Byte 3: N (Count 1-64)
Byte 4...: DATA[0]...DATA[N]
→ Response: 0x06 (ACK)
```

**Bulk Register Read (CMD = 0x62 'b')**
```
Byte 0: 0x62 (CMD 'b')
Byte 1: ADDR[15:8]
Byte 2: ADDR[7:0]
Byte 3: N (Count 1-64)
→ Response: DATA[0]...DATA[N]
```

### 11.3 Error Response
*   **NAK (0x15):** Invalid command, Address out of range, or Write to Read-Only register.

---

## 12. FPGA Resource Utilization Estimate

*Based on Xilinx Kintex-7 XC7K70T implementation.*

| Resource | Available | Estimated Usage | Utilization % |
|:---|:---:|:---:|:---:|
| Slice LUTs | 43,600 | 18,500 | 42% |
| Slice Flip-Flops | 87,200 | 24,000 | 27% |
| Block RAM (36Kb) | 140 | 25 | 17% |
| DSP Slices | 240 | 10 | 4% |
| GTX/GTP Transceivers | 8 | 4 | 50% |

**Synthesis Tool:** Vivado 2023.2
**Timing Constraint:** 156.25 MHz (JESD204B Ref Clock) & 200 MHz (System Clock).

---

## Annexure A — Requirement Traceability Matrix

| S.No | GLR-ID | Description | Source HRS Section | GLR Section | Verification Method | Status |
|:---:|:---|:---|:---|:---|:---|:---:|
| 1 | GLR-001 | RF Input Frequency Range 5-18 GHz | HRS §3.1 | 4 (Module) | Simulation | Open |
| 2 | GLR-002 | JESD204B Interface (4 Lanes) | HRS §3.3 (REQ-HW-005) | 9.1 | Lab Test | Open |
| 3 | GLR-003 | SPI Control Interface | HRS §3.3 (REQ-HW-012) | 8 (Pinout) | Inspection | Open |
| 4 | GLR-004 | Gain Control Range 31dB | HRS §3.1 (REQ-HW-004) | 9.3, 10.2 | Lab Test | Open |
| 5 | GLR-005 | Synthesizer Tuning <5 µs | HRS §3.1 (REQ-HW-014) | 9.2, 10.2 | Timing Analysis | Open |
| 6 | GLR-006 | Power Monitoring I2C | HRS §4 (Power) | 9.4, 8 (Pinout) | Test | Open |
| 7 | GLR-007 | UART Register Map | HRS §3.3 | 10, 11 | Review | Open |
| 8 | GLR-008 | RF Path Protection | HRS §3.1 | 9.5, 10.2 | Demonstration | Open |
| 9 | GLR-009 | Resource Estimate | HRS §5 (Form Factor) | 12 | Analysis | Open |