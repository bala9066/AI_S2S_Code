# Glue Logic Requirements (GLR)

## Document Control
| Document Title | Glue Logic Requirements |
| :--- | :--- |
| Version Date | 15.04.2026 |
| Version Number | 0V01 |
| Prepared By | Name: . Sign: |
| Document Review By | Name: . Sign: |

---

## Amendments to the Document
| S. No | Ver. No | Ver. Date | Changed By | Section(s) Changed | Description of Change |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | 0V01 | 15.04.2026 | - | - | Initial Version |

---

## 1. Scope of the Document
This document explains the IO details and functional requirements of the FPGA for the **hgyu Ultra-Wideband RF Receiver System**. It bridges the gap between the hardware netlist (P4) and the FPGA HDL design (P7), defining the signal interfaces, register map, and protocol specifications required to control the RF chain (LNA, VGAs), manage the ADC interface (JESD204B), and handle system power monitoring. Target audience: Hardware Design and Firmware teams.

---

## 2. References

### 2.1 External
| Doc. Type | Part No. | Description |
| :--- | :--- | :--- |
| Datasheet | HMC1132LP6GE | 6-18 GHz GaAs MMIC PHEMT LNA |
| Datasheet | HMC698LP4 | DC-12 GHz Digital Step Attenuator |
| Datasheet | ADC10DX100IRGZ | 10-Bit, 10-GSPS RF Sampling ADC |
| Datasheet | LMK04828B-NOPB | Ultra-Low Jitter Clock Jitter Cleaner |
| Datasheet | TPS7A4700RGWT | 5A, Ultra-Low Noise, High PSRR LDO |
| Datasheet | LTC3260MPFE-1 | Dual Charge Pump & Inverting Regulator |
| Spec | JESD204B | JESD204B Standard (Interface to ADC) |
| Spec | FMC-HPC | FMC High Pin Count Connector Standard |

### 2.2 Internal
| Reference | Document |
| :--- | :--- |
| [HRS] | Hardware Requirements Specification |
| [SCH] | System Schematic |
| [NET] | Logical Netlist (P4) |
| [GDD] | General Design Document |

---

## 3. Acronyms and Abbreviations
| Acronym | Expansion |
| :--- | :--- |
| ADC | Analog to Digital Converter |
| BRAM | Block RAM (FPGA memory resource) |
| CLB | Configurable Logic Block |
| DAC | Digital to Analog Converter |
| DMA | Direct Memory Access |
| DSP | Digital Signal Processor / Slice |
| EMC | Electromagnetic Compatibility |
| FF | Flip-Flop |
| FPGA | Field Programmable Gate Array |
| GND | Ground |
| GPIO | General Purpose Input/Output |
| HDL | Hardware Description Language |
| I2C | Inter-Integrated Circuit |
| IIP3 | Input Third-order Intercept Point |
| JTAG | Joint Test Action Group |
| JESD | JEDEC Standard for Serial Interfaces |
| LVDS | Low Voltage Differential Signaling |
| LUT | Look-Up Table |
| LNA | Low Noise Amplifier |
| OIP3 | Output Third-order Intercept Point |
| PCB | Printed Circuit Board |
| PLL | Phase Locked Loop |
| RoHS | Restriction of Hazardous Substances |
| RTL | Register Transfer Level |
| SFDR | Spurious-Free Dynamic Range |
| SNR | Signal to Noise Ratio |
| SPI | Serial Peripheral Interface |
| UART | Universal Asynchronous Receiver Transmitter |
| VCC | Voltage Common (Supply) |
| VHDL | VHSIC Hardware Description Language |
| VGA | Variable Gain Amplifier |

---

## 4. Module Overview

The **hgyu** module is an ultra-wideband RF receiver digitizer card designed to operate from 5.0 GHz to 18.0 GHz. It features a high-gain LNA, digitally controlled step attenuators for gain control, and a 10-bit, 10 GSPS ADC for direct digitization. The module interfaces to a host FPGA via an FMC HPC connector.

**RF SECTION:**
The RF chain consists of an **Analog Devices HMC1132LP6GE** LNA providing 23 dB gain and 3.5 dB Noise Figure. This is followed by two cascaded **HMC698LP4** digital step attenuators to provide a total attenuation range of >60 dB (0.5 dB steps). The filtered signal is fed to the **ADC10DX100**.

**DIGITAL SECTION:**
The core logic resides on an external FPGA (host) interfacing via the FMC connector (J4). The primary high-speed link is a **JESD204B** interface (8 lanes) running at up to 12.5 Gbps per lane to receive 10-bit samples from the ADC10DX100. Control logic includes SPI masters for the ADC, Clock Generator, and Attenuators.

**POWER SUPPLY SECTION:**
The board accepts +5V via the FMC connector. **TPS7A4700** LDOs (U6, U7) generate clean +5V (LNA) and +3.3V (Digital) rails. An **LTC3260** (U8) provides the negative rail (if needed) and generates the core voltages for the ADC (+1.8V and +1.0V).

---

## 5. Features
- **ADC:** Texas Instruments **ADC10DX100** (10-bit, 10 GSPS).
- **LNA:** Analog Devices **HMC1132LP6GE** (6-18 GHz, 23 dB Gain).
- **Gain Control:** Dual **HMC698LP4** attenuators (0-31.5 dB range, 0.5 dB step, parallel interface).
- **Clocking:** **LMK04828** JESD204B clock generator with <100 fs RMS jitter.
- **High-Speed Interface:** JESD204B Subclass 1 (8 lanes) via FMC HPC.
- **Control Interface:** SPI (ADC, Clock) and Parallel GPIO (Attenuators).
- **Power Management:** Sequenced enable pins (LDO_EN_5V, 3V3, 1V8, 1V0).
- **Monitoring:** SPI based configuration and status readback.
- **Environmental:** Support for -55°C to +125°C operation (MIL-STD-810).

---

## 6. FPGA Description

*Note: The GLR describes the logic requirements for the Host FPGA controlling this module, assuming a Xilinx Kintex UltraScale or Virtex Ultrascale+ class device.*

**Selection Rationale:**
The FPGA must support 8 lanes of JESD204B IP cores running at line rates compatible with the 10 GSPS ADC output (approx 12.5 Gbps line rate for 10:8 gearbox). A device with GTY/GTH transceivers is required.

| S.NO | PARAMETERS | SPECIFICATION |
|------|-----------|---------------|
| 1 | Part Number | Xilinx KU15P (or equivalent) |
| 2 | Logic Cells | ~450,000 |
| 3 | CLB Flip-Flops | ~900,000 |
| 4 | Number of Gates | ~10M ASIC Gates |
| 5 | Maximum Distributed RAM (Kb) | 3500 |
| 6 | Total Block RAM (Kb) | 36,000 (1000 blocks) |
| 7 | Maximum Single-Ended I/Os | 520 |
| 8 | Maximum DSP Slices | 1800 |
| 9 | No of IO Bank | 8 |

---

## 7. Block Diagram

```
+-------------------+          +-------------------+
| Host FPGA         |          | hgyu RF Module    |
| (External)        |          |                   |
|                   |          |                   |
| [JESD204B Core]   |<-------->| [ADC10DX100]      |
|                   |  LVDS    | U4                |
| [SPI Master]      |<-------->| [LMK04828] U5     |
|                   |          | [HMC698LP4] U2/U3  |
| [GPIO Control]    |<-------->| [Attenuator Ctrl] |
|                   |          |                   |
+-------------------+          +-------------------+
```

---

## 8. Pinout Details

**Table: FPGA Pin Out Details**

| S.No | Signal Name | Pin No | Voltage Level | Direction wrt FPGA | Source | Destination | Default Condition | Voltage Standard |
|------|------------|--------|---------------|--------------------|--------|-------------|-------------------|------------------|
| 1 | FMC_VADJ | N/A | 1.8V | Input | Power Supply | FMC Connector | N/A | N/A |
| 2 | GND | N/A | 0V | N/A | GND | System | N/A | N/A |
| 3 | JESD_D0_P | E12 | LVDS | Input | ADC10DX100 | FPGA | High Z | LVDS |
| 4 | JESD_D0_N | F12 | LVDS | Input | ADC10DX100 | FPGA | High Z | LVDS |
| 5 | JESD_D1_P | E11 | LVDS | Input | ADC10DX100 | FPGA | High Z | LVDS |
| 6 | JESD_D1_N | F11 | LVDS | Input | ADC10DX100 | FPGA | High Z | LVDS |
| 7 | JESD_D2_P | D11 | LVDS | Input | ADC10DX100 | FPGA | High Z | LVDS |
| 8 | JESD_D2_N | E10 | LVDS | Input | ADC10DX100 | FPGA | High Z | LVDS |
| 9 | JESD_D3_P | D10 | LVDS | Input | ADC10DX100 | FPGA | High Z | LVDS |
| 10 | JESD_D3_N | C10 | LVDS | Input | ADC10DX100 | FPGA | High Z | LVDS |
| 11 | JESD_D4_P | C9 | LVDS | Input | ADC10DX100 | FPGA | High Z | LVDS |
| 12 | JESD_D4_N | D9 | LVDS | Input | ADC10DX100 | FPGA | High Z | LVDS |
| 13 | JESD_D5_P | C8 | LVDS | Input | ADC10DX100 | FPGA | High Z | LVDS |
| 14 | JESD_D5_N | D8 | LVDS | Input | ADC10DX100 | FPGA | High Z | LVDS |
| 15 | JESD_D6_P | B7 | LVDS | Input | ADC10DX100 | FPGA | High Z | LVDS |
| 16 | JESD_D6_N | C7 | LVDS | Input | ADC10DX100 | FPGA | High Z | LVDS |
| 17 | JESD_D7_P | A7 | LVDS | Input | ADC10DX100 | FPGA | High Z | LVDS |
| 18 | JESD_D7_N | B6 | LVDS | Input | ADC10DX100 | FPGA | High Z | LVDS |
| 19 | JESD_SYNC_P | B5 | LVDS | Output | FPGA | ADC10DX100 | Low | LVDS |
| 20 | JESD_SYNC_N | A5 | LVDS | Output | FPGA | ADC10DX100 | Low | LVDS |
| 21 | SPI_SCLK_U4 | G13 | 1.8V/3.3V | Output | FPGA | ADC10DX100 | Low | LVCMOS18 |
| 22 | SPI_SDI_U4 | H13 | 1.8V/3.3V | Output | FPGA | ADC10DX100 | Low | LVCMOS18 |
| 23 | SPI_SDO_U4 | J13 | 1.8V/3.3V | Input | ADC10DX100 | FPGA | High Z | LVCMOS18 |
| 24 | SPI_CS_U4 | K13 | 1.8V/3.3V | Output | FPGA | ADC10DX100 | High | LVCMOS18 |
| 25 | SPI_SCLK_U5 | L14 | 3.3V | Output | FPGA | LMK04828 | Low | LVCMOS33 |
| 26 | SPI_SDI_U5 | M14 | 3.3V | Output | FPGA | LMK04828 | Low | LVCMOS33 |
| 27 | SPI_SDO_U5 | N14 | 3.3V | Input | LMK04828 | FPGA | High Z | LVCMOS33 |
| 28 | SPI_CS_U5 | P14 | 3.3V | Output | FPGA | LMK04828 | High | LVCMOS33 |
| 29 | ATT1_LE | A15 | 3.3V | Output | FPGA | HMC698LP4 (U2) | Low | LVCMOS33 |
| 30 | ATT1_D0 | B15 | 3.3V | Output | FPGA | HMC698LP4 (U2) | Low | LVCMOS33 |
| 31 | ATT1_D1 | C15 | 3.3V | Output | FPGA | HMC698LP4 (U2) | Low | LVCMOS33 |
| 32 | ATT1_D2 | D15 | 3.3V | Output | FPGA | HMC698LP4 (U2) | Low | LVCMOS33 |
| 33 | ATT1_D3 | E15 | 3.3V | Output | FPGA | HMC698LP4 (U2) | Low | LVCMOS33 |
| 34 | ATT1_D4 | F15 | 3.3V | Output | FPGA | HMC698LP4 (U2) | Low | LVCMOS33 |
| 35 | ATT1_D5 | G15 | 3.3V | Output | FPGA | HMC698LP4 (U2) | Low | LVCMOS33 |
| 36 | ATT2_LE | H15 | 3.3V | Output | FPGA | HMC698LP4 (U3) | Low | LVCMOS33 |
| 37 | ATT2_D0 | J15 | 3.3V | Output | FPGA | HMC698LP4 (U3) | Low | LVCMOS33 |
| 38 | LNA_ENABLE | K15 | 3.3V | Output | FPGA | HMC1132LP6GE | Low | LVCMOS33 |
| 39 | ADC_RESET | L15 | 3.3V | Output | FPGA | ADC10DX100 | High | LVCMOS33 |
| 40 | ADC_PD | M15 | 3.3V | Output | FPGA | ADC10DX100 | Low | LVCMOS33 |
| 41 | LDO_EN_5V | N15 | 3.3V | Output | FPGA | TPS7A4700 (U6) | Low | LVCMOS33 |
| 42 | LDO_EN_3V3 | P15 | 3.3V | Output | FPGA | TPS7A4700 (U7) | Low | LVCMOS33 |
| 43 | LDO_EN_1V8 | R16 | 3.3V | Output | FPGA | LTC3260 | Low | LVCMOS33 |
| 44 | LDO_EN_1V0 | T16 | 3.3V | Output | FPGA | LTC3260 | Low | LVCMOS33 |
| 45 | CLK_REF_P | V17 | 1.8V/3.3V | Input | External | LMK04828 | High Z | LVCMOS33 |
| 46 | CLK_REF_N | V18 | 1.8V/3.3V | Input | External | LMK04828 | High Z | LVCMOS33 |

---

## 9. Functional Specifications

**Summary table:**

| S.No. | Function Name | Description |
|-------|--------------|-------------|
| 1 | JESD204B Rx Interface | 8-lane JESD204B Subclass 1 Interface to ADC10DX100. |
| 2 | Clock Synchronization | SYSREF signal generation for multi-device synchronization. |
| 3 | RF Gain Control | Parallel GPIO control of dual HMC698LP4 attenuators. |
| 4 | LNA Enable | Power control for HMC1132LP6GE. |
| 5 | Power Sequencing | Enable pin sequencing for LDOs. |
| 6 | SPI Configuration | SPI Master interfaces for ADC, Clock Gen, and temp sensors. |
| 7 | Control & Status | Register based control via UART over FMC. |
| 8 | Remote Update | Remote programming of FPGA bitstream via FMC. |

Then provide DETAILED subsections:

### 9.1 JESD204B Rx Interface
- **Interface:** JESD204B Subclass 1.
- **Lanes:** 8 Electrical lanes (C2P/C2N).
- **Line Rate:** 12.5 Gbps (configured for 10 GSPS ADC sampling).
- **Scrambling:** Enabled.
- **Subclass:** 1 (Supports deterministic latency).
- **FPGA IP:** Xilinx JESD204B Rx IP core.
- **Buffering:** AXI-Stream interface to internal buffers.

### 9.2 RF Gain Control
- **Components:** Dual HMC698LP4.
- **Interface Type:** 6-bit Parallel (Data + Latch).
- **Logic:** Active High for Data bits, Positive pulse on LE to latch.
- **Range:** 0 to 31.5 dB per device (Total 63 dB).
- **Latency:** < 1 us.

### 9.3 Power On/Off Sequence
#### 9.3.1 Power ON/OFF Sequence
Step-by-step sequence:
1. FMC +5V and +12V supplies stable.
2. FPGA asserts `LDO_EN_5V` (Enable LNA Supply).
3. Wait 1ms (TPS7A4700 start-up time).
4. FPGA asserts `LDO_EN_3V3` (Enable Digital Supply).
5. FPGA asserts `LDO_EN_1V8` and `LDO_EN_1V0` (Enable ADC Core).
6. FPGA de-asserts `ADC_RESET` and `ADC_PD`.
7. FPGA asserts `LNA_ENABLE`.
8. System enters `READY` state.

#### 9.3.2 Mode Configuration
| Mode | Signal | Value | Description |
|------|--------|-------|-------------|
| Normal | MODE[1:0] | 2'b00 | Normal operating mode |
| Test | MODE[1:0] | 2'b01 | Built-in self-test (Loopback) |
| Programming | MODE[1:0] | 2'b10 | FPGA remote programming mode |

### 9.4 Supply Voltage, Current & Temperature Monitoring
*Note: Voltages monitored via I2C/SPI PMIC on motherboard, module utilizes internal ADC monitors.*

#### 9.4.1 Supply Voltage Monitoring
- **Interface:** SPI reading ADC10DX100 internal monitors.
- **Monitored Rails:** VCC (1.8V), VDD (1.0V).

#### 9.4.2 Temperature Monitoring
- **Part Number:** TMP102 (Mounted on ADC card, optional based on BOM availability).
- **Interface:** I2C.
- **Address:** 0x48.
- **Range:** -55°C to +125°C.

### 9.5 Flash & Interfaces
*Configuration storage handled by Host FPGA Flash.* This module contains no dedicated configuration flash for itself, relying on the Host FPGA. If local storage is required for calibration tables:
- **Interface:** SPI.
- **Memory Map:** Look-up tables for Gain vs Temperature correction.

### 9.6 TRP Configuration
*Not applicable for Receive-only module.*
- **Signal:** N/A.
- **Logic:** N/A.

### 9.7 FPGA Remote Programming
- **Protocol:** UART at 115200 Baud.
- **Tool:** Vendor GUI (Vivado Hardware Manager or Custom).
- **Procedure:** Standard MultiBoot or SelectMAP via FMC pins.

### 9.8 Phase Shifter Controlling
*Not applicable for this receiver design.*

### 9.9 Beam Steering Calculation
*Not applicable for this receiver design (offloaded to Host).*

### 9.10 Gate Voltage Writing in DAC
*Not applicable (Gain control is digital).*

---

## 10. Software Register Address Map

### 10.1 Register Base Addresses

| Block Name | Base Address | Address Range | Description |
|------------|-------------|---------------|-------------|
| System / Identification | 0x0000 | 0x0000–0x00FF | Board ID, firmware version, status |
| UART Control | 0x0100 | 0x0100–0x01FF | Baud rate, FIFO control |
| SPI Control | 0x0200 | 0x0200–0x02FF | SPI master, chip-select control |
| GPIO | 0x0400 | 0x0400–0x04FF | General purpose I/O control |
| RF Control | 0x0800 | 0x0800–0x08FF | Attenuator values, LNA Enable |
| JESD204B Control | 0x0900 | 0x0900–0x09FF | ADC Config, JESD Link status |
| Diagnostics | 0x0A00 | 0x0A00–0x0AFF | Fault log, uptime counter |

### 10.2 Detailed Register Map

**Block 0x0000 — System / Identification**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|--------------|-------|-----|-------------|----------------------|
| 0x00 | BOARD_ID | 16 | R | 0x4859 | 'h' 'y' (Ascii for hgyu) |
| 0x01 | FW_VERSION_MAJOR | 16 | R | 0x0001 | Firmware major version |
| 0x02 | FW_VERSION_MINOR | 16 | R | 0x0000 | Firmware minor version |
| 0x03 | SYS_STATUS | 16 | R | 0x0000 | [15:8] Reserved, [7] JESD_LINK, [6] TEMP_ALERT, [5] PWR_GOOD, [0] READY |
| 0x04 | SYS_CTRL | 16 | R/W | 0x0000 | [0] SOFT_RESET, [1] JESD_RST_N |

**Block 0x0100 — UART Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|--------------|-------|-----|-------------|----------------------|
| 0x00 | BAUD_DIV | 16 | R/W | 0x0036 | Baud rate divisor (default 115200) |
| 0x01 | UART_CTRL | 16 | R/W | 0x0001 | [0] UART_ENABLE, [1] LOOPBACK_EN |
| 0x02 | UART_STATUS | 16 | R | 0x0000 | [0] TX_BUSY, [1] RX_AVAIL |

**Block 0x0400 — GPIO**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|--------------|-------|-----|-------------|----------------------|
| 0x00 | GPIO_OUT | 16 | R/W | 0x0000 | [15:0] GPIO Outputs (mapped to LDO_EN) |
| 0x01 | GPIO_IN | 16 | R | 0x0000 | [15:0] GPIO Inputs |
| 0x02 | GPIO_DIR | 16 | R/W | 0xFFFF | 1=Output, 0=Input |

**Block 0x0800 — RF Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|--------------|-------|-----|-------------|----------------------|
| 0x00 | ATTENUATOR_1 | 16 | R/W | 0x0000 | [5:0] Attenuation value for U2 (0-31 x 0.5dB). [6] LE Pulse trigger |
| 0x01 | ATTENUATOR_2 | 16 | R/W | 0x0000 | [5:0] Attenuation value for U3 (0-31 x 0.5dB). [6] LE Pulse trigger |
| 0x02 | LNA_CTRL | 16 | R/W | 0x0000 | [0] LNA_ENABLE (Active High) |

**Block 0x0900 — JESD204B Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|--------------|-------|-----|-------------|----------------------|
| 0x00 | JESD_CTRL | 16 | R/W | 0x0001 | [0] LINK_ENABLE, [1] RESET_N |
| 0x01 | JESD_STATUS | 16 | R | 0x0000 | [0] LINK_LOCKED, [1] CODE_GROUP_SYNC |
| 0x02 | ADC_CONFIG | 16 | R/W | 0x0000 | [2:0] Decimation select |

### 10.3 Register Access Rules
- All registers are 16-bit wide.
- Write: Write data directly.
- Read: Read current state.
- LE Pulse: Writing to bit [6] of ATTENUATOR_x triggers a 10ns pulse on the LE pin automatically.

---

## 11. UART Register Protocol Specification

### 11.1 Physical Layer
- Baud rate: 115200 bps (configurable).
- Frame format: 1 start bit, 8 data bits, 1 stop bit, no parity (8N1).
- Physical interface: FMC LPC/HPC UART pins.

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

---

## 12. FPGA Resource Utilization Estimate

| Resource | Available | Estimated Usage | Utilization % |
|---------|-----------|----------------|--------------|
| Slice LUTs | 270,000 | 45,000 | 16% |
| Slice Flip-Flops | 540,000 | 30,000 | 5% |
| Block RAM (36Kb) | 900 | 100 | 11% |
| DSP Slices | 1,800 | 10 | <1% |
| MMCM/PLL | 10 | 2 | 20% |
| I/O Buffers | 520 | 100 | 19% |

Synthesis tool: Vivado 2025.1
Target device: Xilinx KU15P
Timing constraint: 125 MHz System Clock, 12.5 Gbps JESD Line Rate

---

## Annexure A — Requirement Traceability Matrix

| S.No | GLR-ID | Description | Source HRS Section | GLR Section | Verification Method | Status |
|-------|--------|-------------|-------------------|-------------|--------------------|----|
| 1 | GLR-001 | RF Input Frequency Range | HRS §3.2 REQ-HW-001 | 4, 5, 8 | Test | Open |
| 2 | GLR-002 | JESD204B Interface | HRS §3.3 REQ-HW-008 | 9.1, 10.2 | Test | Open |
| 3 | GLR-003 | Gain Control Range | HRS §3.1 REQ-HW-013 | 9.2, 10.2 | Test | Open |
| 4 | GLR-004 | Power Supply Sequencing | HRS §3.5 REQ-HW-010 | 9.3 | Test | Open |
| 5 | GLR-005 | Control Interface | HRS §3.3 REQ-HW-015 | 11, 10.2 | Test | Open |
| 6 | GLR-006 | JESD204B Subclass 1 | HRS §3.2 REQ-HW-007 | 9.1 | Test | Open |
| 7 | GLR-007 | JESD204B Latency | HRS §3.2 REQ-HW-007 | 9.1 | Analysis | Open |
| 8 | GLR-008 | Register Address Map | HRS §3.3 | 10 | Inspection | Open |
| 9 | GLR-009 | UART Protocol Specification | HRS §3.3 | 11 | Test | Open |
| 10 | GLR-010 | FPGA Resource Budget | HRS §3.5 | 12 | Analysis | Open |
| 11 | GLR-011 | Clock Input Reference | HRS §3.1 REQ-HW-014 | 8 | Test | Open |
| 12 | GLR-012 | Operating Temperature | HRS §3.4 REQ-HW-009 | 4 | Test | Open |