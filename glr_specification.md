# Glue Logic Requirements (GLR)

## Document Control
| Document Title | Glue Logic Requirements |
| :--- | :--- |
| **Version Date** | 17.04.2026 |
| **Version Number** | 0V01 |
| **Prepared By** | Name: . Sign: |
| **Document Review By** | Name: . Sign: |

---

## Amendments to the Document
| S. No. | Ver. No. | Ver. Date | Changed By | Section(s) Changed | Description of Change |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | 0V01 | 17.04.2026 | - | - | Initial Release |

---

## 1. Scope of the Document
This document explains the IO details and functional requirements of the FPGA for **rx module**. Targeted audience: Hardware Design and Firmware teams.

---

## 2. References

### 2.1 External
| Doc. Type | Part No. | Description |
| :--- | :--- | :--- |
| Datasheet | **XCZU9EG-FFVB1156** | Xilinx Zynq UltraScale+ FPGA |
| Datasheet | **AD9208** | Dual, 14-Bit, 3 GSPS ADC w/ JESD204B |
| Datasheet | **ADL5380** | Wideband I/Q Demodulator |
| Datasheet | **HMC698LP4** | Variable Gain Amplifier |
| Datasheet | **HMC556LC3B** | Double-Balanced Mixer |
| Datasheet | **LTM4644** | Quad 4A DC/DC µModule Regulator |
| Standard | **MIL-STD-810** | Environmental Engineering Considerations |

### 2.2 Internal
| Reference | Document |
| :--- | :--- |
| [HRS] | Hardware Requirements Specification |
| [SCH] | rx_module_Sch |
| [GRS] | General Requirements Specification |
| [GDD] | General Design Document |

---

## 3. Acronyms and Abbreviations
| Acronym | Expansion |
| :--- | :--- |
| **ADC** | Analog to Digital Converter |
| **BOM** | Bill of Materials |
| **CLB** | Configurable Logic Block |
| **DAC** | Digital to Analog Converter |
| **DSP** | Digital Signal Processing |
| **EMC** | Electromagnetic Compatibility |
| **FCC** | Federal Communications Commission |
| **FIFO** | First In First Out |
| **FPGA** | Field Programmable Gate Array |
| **FF** | Flip Flop |
| **GND** | Ground |
| **GPIO** | General Purpose Input Output |
| **HDL** | Hardware Description Language |
| **I2C** | Inter-Integrated Circuit |
| **IO** | Input Output |
| **JTAG** | Joint Test Action Group |
| **LVDS** | Low Voltage Differential Signaling |
| **LUT** | Look Up Table |
| **PCB** | Printed Circuit Board |
| **PLL** | Phase Locked Loop |
| **RoHS** | Restriction of Hazardous Substances |
| **RTL** | Register Transfer Level |
| **SPI** | Serial Peripheral Interface |
| **UART** | Universal Asynchronous Receiver Transmitter |
| **VCC** | Voltage Common Collector |

---

## 4. Module Overview

### RF SECTION
The RF input section accepts a 5-18 GHz signal via an SMA connector (J1). The signal passes through a Bandpass Filter (U8: BP5G18G-4500-C4) to limit out-of-band noise. A Wideband LNA (U1: HMC6180LP4E) provides 21 dB gain. A Variable Gain Amplifier (U2: HMC698LP4) allows for manual gain adjustment of 0-50 dB via a digital control interface. Frequency downconversion is handled by a Mixer (U3: HMC556LC3B) and IQ Demodulator (U4: ADL5380) to generate baseband I and Q signals.

### DIGITAL SECTION
The core digital logic is contained within the Xilinx Zynq UltraScale+ FPGA (U6: XCZU9EG-FFVB1156). The FPGA interfaces directly with the Dual High-Speed ADC (U5: AD9208) via JESD204B lanes to capture digitized I/Q data at 3 GSPS. The FPGA performs signal processing, packing, and transmission via LVDS outputs. It also manages the gain control settings for the VGA and monitors board health via I2C/SPI.

### POWER SUPPLY SECTION
The system is powered by a single 12V DC input. A DC-DC Converter (U7: LTM4644) generates the necessary intermediate voltages: +3.3V (for RF components), +5V (for intermediate logic), and +1.0V (for FPGA core and ADC). The LTM4644 sequencing capability ensures proper power-up sequencing for the FPGA and RF components to prevent latch-up.

---

## 5. Features
- **FPGA:** Xilinx XCZU9EG-FFVB1156 (Zynq UltraScale+ MPSoC).
- **ADC:** Dual 14-bit, 3 GSPS AD9208 with JESD204B interface (Subclass 1).
- **RF Range:** 5.0 GHz to 18.0 GHz reception.
- **Gain Control:** Digital control of HMC698LP4 VGA (50 dB range).
- **Communication:** UART (RS-422 level) for command/control.
- **Data Output:** High-speed LVDS I/Q outputs.
- **Monitoring:** On-board I2C temperature and power monitoring.
- **Config Memory:** QSPI Flash for FPGA bitstream storage.
- **JTAG:** Standard 14-pin header for debugging.

---

## 6. FPGA Description
The **XCZU9EG-FFVB1156** is selected to meet the high-throughput signal processing requirements of the 3 GSPS ADC interface. Its integrated PS (Processing System) handles the UART control protocol, while the PL (Programmable Logic) implements the JESD204B IP cores and LVDS output drivers. The -2 speed grade ensures timing closure at 3.0 Gbps line rates.

| S.NO | PARAMETERS | SPECIFICATION |
|------|-----------|---------------|
| 1 | Part Number | XCZU9EG-FFVB1156 |
| 2 | Logic Cells | 438,000 |
| 3 | CLB Flip-Flops | 876,000 |
| 4 | Number of Gates | 6,400,000 (est) |
| 5 | Maximum Distributed RAM (Kb) | 1,824 |
| 6 | Total Block RAM (Kb) | 11,700 |
| 7 | Maximum Single-Ended I/Os | 432 |
| 8 | Maximum DSP Slices | 1,248 |
| 9 | No of IO Bank | 25 (subset used) |

---

## 7. Block Diagram
*See System Block Diagram in HRS (Section 2.6). The FPGA sits between the ADC (JESD204B input) and the Backplane/Data Output (LVDS), controlled by the UART interface.*

---

## 8. Pinout Details

**Table: FPGA Pin Out Details**

| S.No | Signal Name | Pin No (Pkg) | Voltage Level | Direction wrt FPGA | Source | Destination | Default Condition | Voltage Standard |
|------|-------------|--------------|---------------|--------------------|--------|-------------|-------------------|------------------|
| **Power & Ground** |
| 1 | VCCO_0 | N/A | 1.8V | Power In | LTM4644 | Bank 0 Supply | Power Good | LVCMOS18 |
| 2 | VCCO_1 | N/A | 3.3V | Power In | LTM4644 | Bank 1 Supply | Power Good | LVCMOS33 |
| 3 | VCCINT | N/A | 1.0V | Power In | LTM4644 | Core Supply | Power Good | - |
| **JTAG** |
| 4 | TCK | J4.A2 | 3.3V | Input | Debugger | FPGA | Pull Down | LVCMOS33 |
| 5 | TDI | J4.A3 | 3.3V | Input | Debugger | FPGA | Pull Up | LVCMOS33 |
| 6 | TDO | J4.A4 | 3.3V | Output | FPGA | Debugger | High Z | LVCMOS33 |
| 7 | TMS | J4.A5 | 3.3V | Input | Debugger | FPGA | Pull Up | LVCMOS33 |
| **Clocking** |
| 8 | FPGA_CLK_125M | AA12 | 1.8V | Input | Oscillator | PLL | Always Running | LVDS |
| 9 | ADC_REFCLK | AB11 | 1.8V | Output | FPGA (PLL) | AD9208 | Clock Running | CML (diff) |
| **Reset & Init** |
| 10 | FPGA_RESET_N | M15 | 3.3V | Input | System Controller | FPGA | Active Low | LVCMOS33 |
| 11 | FPGA_INIT_N | K14 | 3.3V | Output | FPGA | LED | High = Init Fail | LVCMOS33 |
| 12 | FPGA_DONE | L14 | 3.3V | Output | FPGA | LED | High = Config Done | LVCMOS33 |
| **UART (Control)** |
| 13 | UART_TX | F18 | 3.3V | Output | FPGA | RS-422 Transceiver | High Z | LVCMOS33 |
| 14 | UART_RX | G19 | 3.3V | Input | RS-422 Transceiver | FPGA | High Z | LVCMOS33 |
| **I2C (Monitoring)** |
| 15 | I2C_SCL_FPGA | T20 | 3.3V | Bi-Dir | FPGA | Temp/Pwr Mon | High Z | I2C (Open Drain) |
| 16 | I2C_SDA_FPGA | R20 | 3.3V | Bi-Dir | FPGA | Temp/Pwr Mon | High Z | I2C (Open Drain) |
| **SPI (VGA Control)** |
| 17 | SPI_SCK | E12 | 3.3V | Output | FPGA | HMC698LP4 | Low | LVCMOS33 |
| 18 | SPI_MOSI | D13 | 3.3V | Output | FPGA | HMC698LP4 | Low | LVCMOS33 |
| 19 | SPI_MISO | C14 | 3.3V | Input | HMC698LP4 | FPGA | High Z | LVCMOS33 |
| 20 | VGA_CS_N | B15 | 3.3V | Output | FPGA | HMC698LP4 | High | LVCMOS33 |
| **JESD204B (ADC Interface)** |
| 21 | JESD_RX_P_0 | Y1 | 1.8V (Diff) | Input | AD9208 | FPGA | High Z | LVDS |
| 22 | JESD_RX_N_0 | Y2 | 1.8V (Diff) | Input | AD9208 | FPGA | High Z | LVDS |
| 23 | JESD_RX_P_1 | Y3 | 1.8V (Diff) | Input | AD9208 | FPGA | High Z | LVDS |
| 24 | JESD_RX_N_1 | Y4 | 1.8V (Diff) | Input | AD9208 | FPGA | High Z | LVDS |
| 25 | JESD_SYNC_N | AB1 | 1.8V | Bi-Dir | AD9208 | FPGA | High Z | LVCMOS18 |
| **LVDS Data Output** |
| 26 | LVDS_IQ_P_0 | M1 | 1.8V | Output | FPGA | Backplane | High Z | LVDS |
| 27 | LVDS_IQ_N_0 | M2 | 1.8V | Output | FPGA | Backplane | High Z | LVDS |
| 28 | LVDS_IQ_P_1 | N1 | 1.8V | Output | FPGA | Backplane | High Z | LVDS |
| 29 | LVDS_IQ_N_1 | N2 | 1.8V | Output | FPGA | Backplane | High Z | LVDS |
| 30 | LVDS_CLK_P | P1 | 1.8V | Output | FPGA | Backplane | High Z | LVDS |
| 31 | LVDS_CLK_N | P2 | 1.8V | Output | FPGA | Backplane | High Z | LVDS |
| **Flash Memory** |
| 32 | FLASH_CS_N | H14 | 3.3V | Output | FPGA | QSPI Flash | High | LVCMOS33 |
| 33 | FLASH_CLK | J13 | 3.3V | Output | FPGA | QSPI Flash | Low | LVCMOS33 |
| 34 | FLASH_MOSI | K13 | 3.3V | Output | FPGA | QSPI Flash | Low | LVCMOS33 |
| 35 | FLASH_MISO | L13 | 3.3V | Input | QSPI Flash | FPGA | High Z | LVCMOS33 |
| **RF Control** |
| 36 | MIXER_EN | D18 | 3.3V | Output | FPGA | HMC556LC3B | Low | LVCMOS33 |
| 37 | LNA_EN | E18 | 3.3V | Output | FPGA | HMC6180LP4E | Low | LVCMOS33 |
| **GPIO / Status** |
| 38 | LED_STATUS | A20 | 3.3V | Output | FPGA | LED | Low | LVCMOS33 |
| 39 | PG_FPGA_3V3 | B19 | 3.3V | Input | LTM4644 | FPGA | High (Good) | LVCMOS33 |

---

## 9. Functional Specifications

**Summary Table:**

| S.No. | Function Name | Description |
|-------|--------------|-------------|
| 1 | JESD204B Interface | Captures 14-bit I/Q data from AD9208 at 3 GSPS. |
| 2 | LVDS Data Output | Forwards processed I/Q data to backplane. |
| 3 | Manual Gain Control | SPI interface to HMC698LP4 for 50dB gain range. |
| 4 | Serial Comm (UART) | Control interface for registers and status. |
| 5 | RF Control | Enables LNA and Mixer via GPIO. |
| 6 | Temp & Power Mon | I2C interface to ADM1175/LM75. |
| 7 | Remote Programming | Updates QSPI Flash via UART. |
| 8 | Clock Gen | Generates 491.52MHz REFCLK for ADC via PLL. |
| 9 | System Monitor | Xilinx SYSMON for internal die temp. |

### 9.1 JESD204B Interface
- **Interface:** JESD204B Subclass 1.
- **Lanes:** 2 lanes (Lane 0: I-Data, Lane 1: Q-Data).
- **Data Rate:** 12.5 Gbps per lane (derived from 3 GSPS * 14bit * 8b/10b / 2).
- **FPGA IP:** Xilinx JESD204B RX Subsystem.
- **Sync Mechanism:** SYSREF alignment for deterministic latency.
- **Status:** Link integrity monitored via Register 0x1000 (LINK_UP).

### 9.2 LVDS Data Output
- **Standard:** IEEE 1596.3 (LVDS).
- **Width:** 16-bit Data (8 I + 8 Q) + 1 Clock.
- **Format:** DDR (Double Data Rate) transmission.
- **Clock Speed:** 156.25 MHz (supports 312.5 MSPS effective output rate).
- **Buffers:** SelectIO UltraScale+ LVDS output drivers.

### 9.3 Manual Gain Control (VGA)
- **Target:** HMC698LP4 (U2).
- **Interface:** SPI Mode 0 (CPOL=0, CPHA=0).
- **Clock Freq:** Max 10 MHz.
- **Data Width:** 6-bit gain code (0-63).
- **Control:** Value written to `RF_GAIN` register (0x0800) triggers SPI transaction.

### 9.4 Serial Communication Interface (UART)
- **Physical:** RS-422 (Differential).
- **Transceiver:** SN65HVD178 (or similar).
- **Baud Rate:** 921.6 kbps (Standard).
- **Protocol:** Register-based (see Section 11).

### 9.5 Power Supply Monitoring
- **IC:** LTM4644 I2C Interface.
- **Rails Monitored:** 12V Input, 3.3V RF Rail, 1.0V Core Rail.
- **Alerts:** Over-Current (OC), Under-Voltage (UV) flags mapped to `SYS_STATUS` register.

### 9.6 Temperature Monitoring
- **Internal:** Xilinx SYSMON (On-die sensor).
- **External:** I2C Temp sensor (e.g., LM75A) near RF components.
- **Threshold:** Auto-shutdown if T > 95°C.

### 9.7 RF Enable Control
- **Signals:** `LNA_EN`, `MIXER_EN`.
- **Logic:** Active HIGH.
- **Sequencing:** `MIXER_EN` delayed by 10ms after `LNA_EN` to prevent LO leakage.

### 9.8 FPGA Remote Programming
- **Interface:** UART.
- **Tool:** Custom Host Loader.
- **Memory:** MT25QU02G (2Gb) QSPI Flash.

### 9.9 Clock Generation
- **Input:** 125 MHz Crystal Oscillator.
- **PLL:** MMCME4_ADV in Xilinx FPGA.
- **Outputs:**
  - 491.52 MHz for JESD204B Refclk.
  - 156.25 MHz for LVDS Output.
  - 100 MHz for AXI Interconnect.

---

## 10. Software Register Address Map

### 10.1 Register Base Addresses

| Block Name | Base Address | Address Range | Description |
|------------|-------------|---------------|-------------|
| System / Identification | 0x0000 | 0x0000–0x00FF | ID, Firmware, Sysmon |
| UART Control | 0x0100 | 0x0100–0x01FF | Baud, FIFO |
| JESD204B Control | 0x0200 | 0x0200–0x02FF | Link Status, Reset |
| RF Control | 0x0800 | 0x0800–0x08FF | VGA Gain, LNA/Mixer En |
| LVDS Output Control | 0x0900 | 0x0900–0x09FF | Test patterns, enable |
| I2C / Monitor | 0x0A00 | 0x0A00–0x0AFF | Temp, Power rail data |
| Flash Control | 0x0B00 | 0x0B00–0x0BFF | Erase/Write commands |

### 10.2 Detailed Register Map

**Block 0x0000 — System / Identification**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|--------------|-------|-----|-------------|----------------------|
| 0x00 | BOARD_ID | 16 | R | 0x5801 | RX-Module ID Code |
| 0x01 | FW_VERSION | 16 | R | 0x0100 | Major.Minor |
| 0x02 | SYS_STATUS | 16 | R | 0x0000 | [15:2] Res, [1] JESD_LOCK, [0] PWR_GOOD |
| 0x03 | SYS_RESET | 16 | W | - | Write 0xDEAD to trigger soft reset |

**Block 0x0200 — JESD204B Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|--------------|-------|-----|-------------|----------------------|
| 0x00 | LINK_CTRL | 16 | R/W | 0x0000 | [0] ENABLE, [1] RESET |
| 0x01 | LINK_STATUS | 16 | R | 0x0000 | [0] ALIGNED, [1] CODE_GRP_SYNC |
| 0x02 | DISP_ERR | 16 | R | 0x0000 | Disparity error counter (R/C) |

**Block 0x0800 — RF Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|--------------|-------|-----|-------------|----------------------|
| 0x00 | VGA_GAIN | 16 | R/W | 0x0020 | [5:0] 6-bit Gain Code (Linear dB) |
| 0x01 | RF_ENABLE | 16 | R/W | 0x0000 | [0] LNA_EN, [1] MIXER_EN |
| 0x02 | RF_STATUS | 16 | R | - | [0] LNA_FAULT (via ADC) |

**Block 0x0900 — LVDS Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|--------------|-------|-----|-------------|----------------------|
| 0x00 | LVDS_CTRL | 16 | R/W | 0x0001 | [0] OUTPUT_EN |
| 0x01 | TEST_MODE | 16 | R/W | 0x0000 | [1:0] 0=Normal, 1=Counter, 2=PN9 |

**Block 0x0A00 — I2C / Monitor**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|--------------|-------|-----|-------------|----------------------|
| 0x00 | TEMP_FPGA | 16 | R | - | Raw Sysmon Temp (signed) |
| 0x01 | TEMP_RF | 16 | R | - | Ext LM75 Temp (signed) |
| 0x02 | PWR_12V | 16 | R | - | 12V ADC Reading (mV) |

---

## 11. UART Register Protocol Specification

This section defines the command structure for the external host to control the FPGA.

### 11.1 Physical Layer
- Baud Rate: 921,600 bps (Default)
- Data Bits: 8
- Parity: None
- Stop Bits: 1
- Flow Control: None

### 11.2 Command Frame Formats

**Single Register Write (CMD = 0x57 'W'):**
```
Byte 0: 0x57 (CMD)
Byte 1: ADDR[15:8]
Byte 2: ADDR[7:0]
Byte 3: DATA[15:8]
Byte 4: DATA[7:0]
→ Response: 0x06 (ACK)
```

**Single Register Read (CMD = 0x52 'R'):**
```
Byte 0: 0x52 (CMD)
Byte 1: (ADDR[15:8] | 0x80)
Byte 2: ADDR[7:0]
→ Response: DATA_H, DATA_L
```

**Bulk Register Write (CMD = 0x42 'B'):**
```
Byte 0: 0x42
Byte 1: START_ADDR_H
Byte 2: START_ADDR_L
Byte 3: COUNT (N)
Byte 4... : Data pairs
→ Response: 0x06
```

**Bulk Register Read (CMD = 0x62 'b'):**
```
Byte 0: 0x62
Byte 1: (ADDR[15:8] | 0x80)
Byte 2: ADDR[7:0]
Byte 3: COUNT (N)
→ Response: Data pairs (N * 2 bytes)
```

### 11.3 Protocol Timing Constraints
| Parameter | Min | Max | Unit |
|-----------|-----|-----|------|
| Inter-byte gap | 0 | 50 | ms |
| Response time | - | 5 | ms |

### 11.4 Software Implementation Notes
*See Section 11.4 in system prompt example.*
```c
#define REG_RF_BASE    (0x0800U)
#define FPGA_WRITE_RF_GAIN(g)    FPGA_WRITE(REG_RF_BASE + 0x00, g)
#define FPGA_READ_TEMP_FPGA()    FPGA_READ(0x0A00 + 0x00)
```

---

## 12. FPGA Resource Utilization Estimate

| Resource | Available | Estimated Usage | Utilization % |
|---------|-----------|----------------|--------------|
| Slice LUTs | 218,800 | 45,000 | 20% |
| Slice Flip-Flops | 437,600 | 30,000 | 6% |
| Block RAM (36Kb) | 432 | 80 | 18% |
| DSP Slices | 1,248 | 32 | 2% |
| MMCM/PLL | 20 | 2 | 10% |
| I/O Buffers | 432 | 120 | 27% |

Synthesis tool: Vivado 2025.1
Target device: XCZU9EG-FFVB1156
Timing constraint: 500 MHz (JESD204B)

---

## Annexure A — Requirement Traceability Matrix

| S.No | GLR-ID | Description | Source HRS Section | GLR Section | Verification Method | Status |
|-------|--------|-------------|-------------------|-------------|--------------------|----|
| 1 | GLR-001 | RF Input Frequency | HRS §3.1 | 9.3 | Test | Open |
| 2 | GLR-002 | JESD204B Interface | HRS §3.3 | 9.1 | Simulation | Open |
| 3 | GLR-003 | LVDS Output | HRS §3.3 | 9.2 | Test | Open |
| 4 | GLR-004 | Manual Gain Control | HRS §3.1 | 9.3 | Test | Open |
| 5 | GLR-005 | UART Control | HRS §3.3 | 9.4, 11 | Test | Open |
| 6 | GLR-006 | Power Monitoring | HRS §3.4 | 9.5 | Test | Open |
| 7 | GLR-007 | Temp Monitoring | HRS §3.4 | 9.6 | Test | Open |
| 8 | GLR-008 | Register Map | HRS §3.3 | 10 | Inspection | Open |
| 9 | GLR-009 | Resource Budget | HRS §2 | 12 | Analysis | Open |