
# Glue Logic Requirements (GLR)

## Document Control
| Document Title | Glue Logic Requirements |
| Version Date | 15.04.2026 |
| Version Number | 0V01 |
| Prepared By | Name: . Sign: |
| Document Review By | Name: . Sign: |

---

## Amendments to the Document
| S. No. | Ver. No. | Ver. Date | Changed By | Section(s) Changed | Description of Change |
| 1 | 0V01 | 15.04.2026 | - | - | Initial Release for uyj Wideband RF Receiver |

---

## 1. Scope of the Document
This document details the Input/Output (IO) interfaces, signal connectivity, and functional requirements of the FPGA (XCZU9EG-FFVB1156) for the **uyj** Wideband RF Receiver System. It serves as the bridge between the hardware netlist (P4) and the FPGA HDL design (P7), specifying voltage standards, pin assignments, and logic behavior for RF control, high-speed data acquisition, power management, and communication interfaces.

---

## 2. References

### 2.1 External
| Doc. Type | Part No. | Description |
|-----------|----------|-------------|
| Datasheet | XCZU9EG-FFVB1156 | Xilinx Zynq UltraScale+ EG FPGA |
| Datasheet | ADC12DJ5200RF | TI 12-Bit, 5.2-GSPS RF Sampling ADC |
| Datasheet | HMC698LP4 | Analog Devices 6-18 GHz Digital VGA |
| Datasheet | LMK04828B | TI Ultra-Low Jitter JESD204B Clock Generator |
| Datasheet | HMC1061LP4E | Analog Devices GaAs MMIC Limiter |
| Datasheet | HMC1099LP5DE | Analog Devices GaN LNA |
| Datasheet | LTC7891 | Analog Devices High Voltage Step-Down Controller |
| Datasheet | LT3045 | Analog Devices Low Noise Linear Regulator |

### 2.2 Internal
| Reference | Document |
|-----------|----------|
| [HRS] | Hardware Requirements Specification (uyj) |
| [SCH] | Schematic Capture (uyj) |
| [NET] | Logical Netlist (uyj) |
| [GRS] | General Requirements Specification |

---

## 3. Acronyms and Abbreviations

| Acronym | Expansion |
|---------|-----------|
| FPGA | Field Programmable Gate Array |
| UART | Universal Asynchronous Receiver/Transmitter |
| SPI | Serial Peripheral Interface |
| I2C | Inter-Integrated Circuit |
| GPIO | General Purpose Input/Output |
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
| VCC | Voltage Common Collector (Supply) |
| GND | Ground |
| LNA | Low Noise Amplifier |
| VGA | Variable Gain Amplifier |
| JESD | JEDEC Standard for Serial Interfaces |
| DDC | Digital Down Converter |
| PS | Processing System (ARM Core in Zynq) |
| PL | Programmable Logic (FPGA Fabric) |
| SERDES | Serializer/Deserializer |

---

## 4. Module Overview

### RF SECTION
The RF chain processes signals from 5.0 GHz to 18.0 GHz. It consists of an **HMC1061LP4E** limiter for input protection, followed by an **HMC1099LP5DE** GaN LNA providing high gain and low noise figure. Variable gain control is handled by an **HMC698LP4** (6-18 GHz Digital VGA) which allows the FPGA to adjust gain levels dynamically via SPI to optimize the ADC input range.

### DIGITAL SECTION
Processing is centered around the **XCZU9EG-FFVB1156** Zynq UltraScale+ FPGA. This device handles the high-speed **JESD204B/C** interface (8 lanes) to capture data from the **ADC12DJ5200RF** operating at 5.2 GSPS. The FPGA performs Digital Down-Conversion (DDC), filtering, and packetization. It also manages system configuration via SPI for the RF components and clock generator, and communicates with the host PC via UART. The Zynq PS (Processing System) is utilized for control logic and data transfer management.

### POWER SUPPLY SECTION
Power is sourced from a 12V input (J3). The **LTC7891IUJ** acts as the main step-down controller, feeding various point-of-load regulators. **TPS62913DRCR** provides the 3.3V main rail. Precision regulation is handled by **LT3045** series LDOs: **LT3045-15** (1.5V for FPGA banks), **LT3045-12** (1.2V for FPGA MGT/AVCC), and **LT3045-10** (1.0V for ADC core). The FPGA monitors these rails via the XADC or internal PS monitors.

---

## 5. Features
- **FPGA**: Xilinx XCZU9EG-FFVB1156 (Zynq UltraScale+ EG Series).
- **High-Speed ADC**: TI ADC12DJ5200RFSPB (12-bit, 5.2 GSPS, JESD204B/C Interface).
- **Clocking**: LMK04828B-NOPB (Ultra-low jitter, JESD204B Class support).
- **RF Control**: SPI control interface for HMC698LP4 VGA (Gain setting).
- **Data Interface**: 8-lane JESD204B/C (Sub-class 1) interface to ADC.
- **Communication**: UART to Host (Debug/Control).
- **Protection**: HMC1061LP4E Input Limiter.
- **Power**: Multi-rail supply (12V, 5V, 3.3V, 1.5V, 1.2V, 1.0V).

---

## 6. FPGA Description
The **XCZU9EG-FFVB1156** is selected for its high transceiver count and DSP capacity. It integrates a quad-core ARM Cortex-A53 (PS) with the programmable logic (PL), enabling a flexible architecture where the PS handles control/communication (UART, SPI) and the PL handles the high-speed JESD204B lanes and DSP algorithms.

| S.NO | PARAMETERS | SPECIFICATION |
|------|-----------|---------------|
| 1 | Part Number | XCZU9EG-FFVB1156 |
| 2 | Logic Cells | 531,200 (approx) |
| 3 | CLB Flip-Flops | 844,800 (approx) |
| 4 | Number of Gates | > 10 Million (equivalent) |
| 5 | Maximum Distributed RAM (Kb) | 1,865 |
| 6 | Total Block RAM (Mb) | 25.4 |
| 7 | Maximum Single-Ended I/Os | 338 (Package specific) |
| 8 | Maximum DSP Slices | 1,968 |
| 9 | No of IO Bank | Variable (utilizing HP/HR banks) |
| 10 | GTX/GTY Transceivers | Up to 32 (Utilizing 16 lanes for JESD) |

---

## 7. Block Diagram
*(Reference to Netlist Topology)*
**Flow:**
`RF_IN` -> `Limiter` -> `LNA` -> `VGA` -> `ADC` -> `JESD204B (8 Lanes)` -> `FPGA`.
`FPGA` -> `SPI` -> `VGA`, `ADC`, `CLK_Gen`.
`FPGA` <-> `UART` <-> `Host PC`.
`Power` -> `Regulators` -> `FPGA Rails`.

---

## 8. Pinout Details

**Table: FPGA Pin Out Details**

| S.No | Signal Name | Pin No (Package) | Voltage Level | Direction wrt FPGA | Source | Destination | Default Condition | Voltage Standard |
|------|-------------|------------------|---------------|--------------------|--------|-------------|-------------------|------------------|
| 1 | VCCO_1V8 | - | 1.8V | Power In | LDO | FPGA Bank MGMT | - | - |
| 2 | VCCO_3V3 | - | 3.3V | Power In | Regulator | FPGA Bank HP | - | - |
| 3 | VCCO_1V2_MGT | - | 1.2V | Power In | LDO | FPGA GTX AVCC | - | - |
| 4 | GND | - | 0V | GND | GND Plane | FPGA | - | - |
| 5 | FPGA_CLK_125M | AA12 | 1.8V | Input | Oscillator | PS/PL | High | LVCMOS18 |
| 6 | FPGA_RESET_N | AB15 | 1.8V | Input | Reset Circuit | System | Active Low Pullup | LVCMOS18 |
| 7 | UART_TXD | M15 | 3.3V | Output | FPGA (PS) | Host (J2) | High | LVCMOS33 |
| 8 | UART_RXD | M16 | 3.3V | Input | Host (J2) | FPGA (PS) | High | LVCMOS33 |
| 9 | VGA_SPI_SCLK | T10 | 3.3V | Output | FPGA (PS) | VGA (U3) | Low | LVCMOS33 |
| 10 | VGA_SPI_SDIO | R11 | 3.3V | Bi-Dir | FPGA (PS) | VGA (U3) | High Z | LVCMOS33 |
| 11 | VGA_SPI_CS | T11 | 3.3V | Output | FPGA (PS) | VGA (U3) | High | LVCMOS33 |
| 12 | ADCO_SPI_SCLK | U12 | 3.3V | Output | FPGA (PS) | ADC (U4) | Low | LVCMOS33 |
| 13 | ADCO_SPI_SDIO | V12 | 3.3V | Bi-Dir | FPGA (PS) | ADC (U4) | High Z | LVCMOS33 |
| 14 | ADCO_SPI_CS | W13 | 3.3V | Output | FPGA (PS) | ADC (U4) | High | LVCMOS33 |
| 15 | CLK_SPI_SCLK | Y14 | 3.3V | Output | FPGA (PS) | Clk Gen (U6) | Low | LVCMOS33 |
| 16 | CLK_SPI_SDIO | Y15 | 3.3V | Bi-Dir | FPGA (PS) | Clk Gen (U6) | High Z | LVCMOS33 |
| 17 | CLK_SPI_CS | AA16 | 3.3V | Output | FPGA (PS) | Clk Gen (U6) | High | LVCMOS33 |
| 18 | JESD_RX_P0 | G1 | 1.2V (Diff) | Input | ADC (U4) | FPGA GTX | CML | CML / LVDS |
| 19 | JESD_RX_N0 | G2 | 1.2V (Diff) | Input | ADC (U4) | FPGA GTX | CML | CML / LVDS |
| 20 | JESD_RX_P1 | H3 | 1.2V (Diff) | Input | ADC (U4) | FPGA GTX | CML | CML / LVDS |
| 21 | JESD_RX_N1 | H4 | 1.2V (Diff) | Input | ADC (U4) | FPGA GTX | CML | CML / LVDS |
| 22 | JESD_RX_P2 | J5 | 1.2V (Diff) | Input | ADC (U4) | FPGA GTX | CML | CML / LVDS |
| 23 | JESD_RX_N2 | J6 | 1.2V (Diff) | Input | ADC (U4) | FPGA GTX | CML | CML / LVDS |
| 24 | JESD_RX_P3 | K7 | 1.2V (Diff) | Input | ADC (U4) | FPGA GTX | CML | CML / LVDS |
| 25 | JESD_RX_N3 | K8 | 1.2V (Diff) | Input | ADC (U4) | FPGA GTX | CML | CML / LVDS |
| 26 | JESD_RX1_P | L1 | 1.2V (Diff) | Input | ADC (U4) | FPGA GTX | CML | CML / LVDS |
| 27 | JESD_RX1_N | L2 | 1.2V (Diff) | Input | ADC (U4) | FPGA GTX | CML | CML / LVDS |
| 28 | ADCO_SYNC_P | E5 | 1.2V (Diff) | Input/Output | ADC (U4) | FPGA GTX | CML | LVDS |
| 29 | ADCO_SYNC_N | E6 | 1.2V (Diff) | Input/Output | ADC (U4) | FPGA GTX | CML | LVDS |
| 30 | REFCLK_P | D1 | 1.2V (Diff) | Input | Clk Gen (U6) | FPGA GTX | CML | LVDS |
| 31 | REFCLK_N | D2 | 1.2V (Diff) | Input | Clk Gen (U6) | FPGA GTX | CML | LVDS |
| 32 | FPGA_DONE | A20 | 1.8V | Output | FPGA Intern | LED (Status) | Low | LVCMOS18 |
| 33 | FPGA_INIT_N | B20 | 1.8V | Output | FPGA Intern | LED (Status) | High (Active Low) | LVCMOS18 |
| 34 | TEMP_ALERT | F20 | 1.8V | Input | Temp Sensor | FPGA PS | High | LVCMOS18 |
| 35 | POWER_GOOD | G20 | 1.8V | Input | PMIC | FPGA PS | High | LVCMOS18 |

*(Note: Pin numbers in column "Pin No" are representative Xilinx BGA locations for functional signal types; actual location is determined in constraints file.)*

---

## 9. Functional Specifications

**Summary Table:**

| S.No. | Function Name | Description |
|-------|--------------|-------------|
| 1 | Serial Communication Interface | UART between FPGA (PS) & Host PC via Header (J2). |
| 2 | High Speed Communication Interface | JESD204B/C (8 Lanes) for ADC sample capture at 5.2 GSPS. |
| 3 | RF Gain Control | SPI control of HMC698LP4 VGA for gain adjustment. |
| 4 | ADC Configuration | SPI control of ADC12DJ5200RF (Sample rate, JESD mode). |
| 5 | Clock Synchronization | SYSREF & Device Clock via LMK04828B & SYNC pins. |
| 6 | Power Supply Monitoring | Monitoring of 12V, 5V, 3.3V rails via XADC. |
| 7 | Signal Processing | DDC, Decimation, and Packetization in PL. |
| 8 | Remote Programming | FPGA Bitstream update via UART (if supported by Boot Mode). |
| 9 | Status Indication | LED status for Power, Init, and Done. |

### 9.1 Serial Communication Interface
- **Interface Type:** UART 16550 compatible.
- **Physical Layer:** 3.3V LVCMOS.
- **Baud Rate:** 115200 bps (Standard), up to 921600 bps (Configurable).
- **Frame Format:** 1 Start bit, 8 Data bits, No Parity, 1 Stop bit.
- **Connector:** 6-pin Header (M20-9980346).
- **Signals:** `UART_TXD` (FPGA -> Host), `UART_RXD` (Host -> FPGA).
- **Protocol:** Custom frame structure:
  - Header: `0xAA`, `0x55`
  - CMD: `[1 Byte]`
  - Length: `[1 Byte]`
  - Payload: `[N Bytes]`
  - CRC: `[2 Bytes]`

### 9.2 High Speed Communication Interface
- **Interface:** JESD204B / JESD204C.
- **Number of Lanes:** 8 Lanes (4 links x 2 lanes or 1 link x 8 lanes depending on ADC configuration).
- **Data Rate per Lane:** 10 Gbps (based on ADC12DJ5200RF output for 5.2GSPS dual-channel).
- **Scrambling:** Enabled (for data balance).
- **Subclass:** Subclass 1 (Deterministic Latency).
- **Lane Mapping:**
  - ADC Lane 0 -> FPGA GTX Channel 0 (`JESD_RX_P0/N0`)
  - ADC Lane 1 -> FPGA GTX Channel 1 (`JESD_RX_P1/N1`)
  - ... (Mapped sequentially per netlist)

### 9.3 Power On/Off Sequence

#### 9.3.1 Power ON Sequence
1. **12V Input Applied:** J3 connected. `LTC7891` enables 5V rail.
2. **3.3V Rail:** `TPS62913` enables 3.3V.
3. **FPGA IO/Bank Rails:** 1.8V and 1.5V (`LT3045-15`) ramp up.
4. **Core/MGT Rails:** 1.0V and 1.2V (`LT3045-10/12`) ramp up.
5. **Power Good Assert:** Internal logic releases `FPGA_RESET_N`.
6. **FPGA Boot:** Configuration bitstream loaded from Flash (not explicitly listed in Netlist but standard) or JTAG.
7. **System Ready:** `FPGA_DONE` signal goes High.

#### 9.3.2 Mode Configuration
Boot mode is assumed to be Quad-SPI Flash (standard for XCZU9EG).

| Mode | Signal | Value | Description |
|------|--------|-------|-------------|
| Normal | BOOT_MODE[3:0] | 4'b0010 | Boot from QSPI |
| JTAG | BOOT_MODE[3:0] | 4'b0000 | Debug/Boundary Scan |

### 9.4 Supply Voltage, Current & Temperature Monitoring
- **Interface:** Xilinx XADC (Within PL/PS).
- **Monitored Rails:** 12V (via Divider), 5V, 3.3V, 1.5V, 1.2V, 1.0V.
- **Measurement:** Internal ADC channels `VAUXP[15:0]`.
- **Temperature:** On-die sensor monitored by XADC.
- **Alerts:** `TEMP_ALERT` pin can be generated by PS GPIO if threshold exceeded (>85°C).
- **Power Consumption:**
  - ADC Core (1.0V): ~4W
  - FPGA (1.0V/1.2V): ~10-15W
  - RF Chain (5V): ~3-5W

### 9.5 Flash & Interfaces
*Note: Specific Flash IC not explicitly detailed in Netlist snippet, but standard practice implies:*
- **Interface:** QSPI (Quad SPI).
- **Purpose:** Store FPGA Bitstream.
- **Capacity:** Minimum 128 Mb (e.g., S25FL128).
- **Access:** PS MIO pins.

### 9.6 RF Front End Control (VGA)
- **Component:** HMC698LP4.
- **Interface:** 3-Wire SPI (SCLK, SDIO, CS).
- **Control Logic:** 8-bit gain register.
- **Range:** -6 dB to +14 dB (example).
- **Frequency:** 6-18 GHz.
- **Operation:**
  1. FPGA calculates required gain based on ADC signal power.
  2. FPGA writes 16-bit word to HMC698LP4 via `VGA_SPI` lines.
  3. Latch data.

### 9.7 ADC Configuration
- **Component:** ADC12DJ5200RF.
- **Interface:** 4-Wire SPI compatible.
- **Configuration Parameters:**
  - Sample Rate (5.0 GSPS vs 2.5 GSPS).
  - JESD204B Lane rate.
  - Decimation settings (DDC bypass or enabled).
  - Test patterns.
- **Procedure:**
  1. Ensure `ADCO_SPI_CS` is High.
  2. Pull `ADCO_SPI_CS` Low.
  3. Clock out command + address + data on `SDIO`.
  4. Release `ADCO_SPI_CS`.

### 9.8 Clock Generation & Synchronization
- **Component:** LMK04828B.
- **Function:** Generate Device Clock and SYSREF for JESD204B.
- **Interface:** SPI (`CLK_SPI`).
- **Inputs:**
  - OSC_IN (Ref Clk source, assumed external crystal or clk module).
- **Outputs:**
  - `ADCO_CLK_P/N`: Sampling clock to ADC.
  - `REFCLK_P/N`: Reference clock to FPGA GTX.
  - `SYSREF`: To FPGA and ADC for Subclass 1 alignment.
- **Synchronization:**
  - FPGA acts as Master, triggering SYNC pulse via GPIO or SPI command to LMK to align SYSREF edges.

### 9.9 Signal Processing (DSP)
- **Algorithm:**
  - Input: 12-bit raw IQ from JESD204B IP.
  - DDC: NCO (Numerically Controlled Oscillator) shifts frequency to DC.
  - Filter: FIR Low Pass Filter (decimation factor 4, 8, or 16).
  - Output: 16-bit or 32-bit IQ samples to memory/DMA.
- **Implementation:** Xilinx IP blocks (JESD204B RX, FIR Compiler, DDS Compiler).

---

## Annexure A — Requirement Traceability Matrix

| S.No. | Requirement ID | Description | HRS Section | GLR Section |
|-------|---------------|-------------|-------------|-------------|
| 1 | REQ-HW-001 | Frequency Coverage (5-18 GHz) | HRS §3.1 | 9.6 (VGA Control) |
| 2 | REQ-HW-002 | Instantaneous Bandwidth (1-4 GHz) | HRS §3.1 | 9.9 (DSP/Decimation) |
| 3 | REQ-HW-003 | Input Dynamic Range (-50 to +10 dBm) | HRS §3.2 | 9.6 (VGA AGC Loop) |
| 4 | REQ-HW-004 | Noise Figure (<6.0 dB) | HRS §3.2 | 9.6 (Gain Staging) |
| 5 | REQ-HW-005 | Linearity (IIP3) | HRS §3.2 | Hardware Spec (LNA/VGA) |
| 6 | REQ-HW-006 | ADC Sample Rate (2-5 GSps) | HRS §3.2 | 9.7 (ADC Config) |
| 7 | REQ-HW-007 | ADC Resolution (10-bit) | HRS §3.2 | 9.7 (ADC Config) |
| 8 | REQ-HW-010 | FPGA Signal Processing | HRS §3.1 | 9.9 (DSP) |
| 9 | REQ-HW-014 | DC Offset Correction | HRS §3.1 | 9.9 (DSP Correction Logic) |
| 10 | REQ-HW-009 | Power Consumption (<50W) | HRS §3.2 | 9.4 (Power Monitoring) |