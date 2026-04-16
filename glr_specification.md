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
| S. No | Ver. No. | Ver. Date | Changed By | Section(s) Changed | Description of Change |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | 0V01 | 17.04.2026 | - | - | Initial Release |

---

## 1. Scope of the Document
This document explains the IO details and functional requirements of the FPGA for **Project mn (Wideband RF Receiver)**.
This document serves as the bridge between the Hardware Requirements Specification (HRS) and the FPGA HDL Design phase. It defines the pin-level interfaces, timing constraints, functional blocks, and the software register map required for the firmware development team.

---

## 2. References

### 2.1 External
| Doc. Type | Part No. | Description |
| :--- | :--- | :--- |
| Datasheet | **XCZU4EV-SFVC784** | Zynq UltraScale+ MPSoC Data Sheet (DS925) |
| Datasheet | **ADC10D1000** | 10-bit, 1.0 Gsps ADC Data Sheet |
| Datasheet | **VSC8522** | VSC8522 Single Port Gigabit Ethernet PHY |
| Datasheet | **HMC698LP4(E)** | 5-20 GHz Low Noise Amplifier |
| Datasheet | **ADL5330** | Variable Gain Amplifier |
| Datasheet | **HMC521LC4** | GaAs MMIC Mixer |
| User Guide | **UG1085** | Zynq UltraScale+ Device Technical Reference Manual |

### 2.2 Internal
| Reference | Document |
| :--- | :--- |
| [HRS] | **mn Hardware Requirements Specification** |
| [SCH] | **mn Schematic (Pending Netlist Finalization)** |
| [GRS] | **mn General Requirements Specification** |
| [GDD] | **mn General Design Document** |

---

## 3. Acronyms and Abbreviations
| Acronym | Expansion |
| :--- | :--- |
| **ADC** | Analog-to-Digital Converter |
| **BOM** | Bill of Materials |
| **CLB** | Configurable Logic Block |
| **CPLD** | Complex Programmable Logic Device |
| **DAC** | Digital-to-Analog Converter |
| **dB** | Decibel |
| **DMA** | Direct Memory Access |
| **DSP** | Digital Signal Processing |
| **EMC** | Electromagnetic Compatibility |
| **FF** | Flip-Flop |
| **FIFO** | First In, First Out |
| **FPGA** | Field Programmable Gate Array |
| **GND** | Ground |
| **GPIO** | General Purpose Input/Output |
| **GTP** | Gigabit Transceiver (Xilinx) |
| **HDL** | Hardware Description Language |
| **I2C** | Inter-Integrated Circuit |
| **IF** | Intermediate Frequency |
| **LUT** | Look-Up Table |
| **LNA** | Low Noise Amplifier |
| **LVDS** | Low-Voltage Differential Signaling |
| **LVTTL** | Low-Voltage Transistor-Transistor Logic |
| **MAC** | Media Access Control |
| **PCB** | Printed Circuit Board |
| **PHY** | Physical Interface Layer |
| **PLL** | Phase-Locked Loop |
| **RAM** | Random Access Memory |
| **RoHS** | Restriction of Hazardous Substances |
| **RTL** | Register Transfer Level |
| **SPI** | Serial Peripheral Interface |
| **UART** | Universal Asynchronous Receiver/Transmitter |
| **VCC** | Voltage Common Collector |
| **VGA** | Variable Gain Amplifier |

---

## 4. Module Overview

**RF SECTION:**
The RF Front End accepts 5-18 GHz input signals via a 2.4mm connector.
*   **LNA:** **HMC698LP4(E)** provides 20 dB gain with 2.5 dB Noise Figure.
*   **VGA:** **ADL5330** provides 60 dB programmable gain range (digital gain control interface).
*   **Mixer:** **HMC521LC4** downconverts the RF signal to a DC-6 GHz IF based on an external Local Oscillator (LO).

**DIGITAL SECTION:**
The digital core is the **XCZU4EV-SFVC784** Zynq UltraScale+ MPSoC.
*   **PS Section:** ARM Cortex-A53 cores run Linux for high-level control and Ethernet stack management.
*   **PL Section:** Configured for high-speed data path. Captures data from **ADC10D1000** (Interleaved mode for 2.0 Gsps or Single for 1.0 Gsps). Includes real-time DSP blocks (DDC, Filtering).
*   **Interface:** **VSC8522** Gigabit Ethernet PHY connected via RGMII for data output.
*   **Configuration:** SPI boot from Configuration Flash.

**POWER SUPPLY SECTION:**
System accepts single **+5V** supply (Industrial range).
*   **Input:** 5V @ 5A max (25W limit).
*   **Rails:**
    *   +1.0V (VCCINT) for FPGA Core.
    *   +1.8V (VCCINT_18) for FPGA PS and ADC.
    *   +3.3V (VCCO_34) for FPGA IO and PHY IO.
    *   +5V (RF_VCC) for RF components (LNA, Mixer).
*   **Sequencing:** Power Management IC (PMIC) ensures ramp-up sequence: 1.0V -> 1.8V -> 3.3V.

---

## 5. Features
*   **FPGA:** Xilinx Zynq UltraScale+ **XCZU4EV-SFVC784** (53K Logic Cells).
*   **Processor:** Dual-core ARM Cortex-A53 @ 1.2GHz integrated in FPGA.
*   **High-Speed ADC:** **ADC10D1000** (Dual 10-bit @ 1 Gsps) interface via Parallel LVDS.
*   **Communication:** Gigabit Ethernet via **VSC8522** PHY (RGMII interface).
*   **Control Interface:** UART for console/debug and SPI for configuration flash.
*   **Gain Control:** 16-bit parallel/SPI control for **ADL5330** VGA.
*   **Clocking:** On-board 125MHz Oscillator for FPGA system clock; programmable clock synthesizer for ADC sampling clock.
*   **Temperature Monitoring:** On-die ARM sensors and external I2C sensor (located near RF front end).
*   **LED Status:** Tri-color LED for System Status (Green=OK, Red=Fault, Amber=Boot).
*   **Remote Update:** Supports FPGA bitstream update over Ethernet (SCP/Flash programming).

---

## 6. FPGA Description

**Selection Rationale:**
The **XCZU4EV-SFVC784** is selected to provide a heterogeneous computing platform. The PS (Processing System) handles the complex Gigabit Ethernet protocol stack (UDP/TCP offload), while the PL (Programmable Logic) handles the high-throughput raw ADC data capture and signal processing (DSP). The integrated GTP transceivers are utilized for high-speed clocking and potential future expansion, though the primary Ethernet interface utilizes the RGMII PS-IO for PHY connection.

**Specifications:**

| S.NO | PARAMETERS | SPECIFICATION |
|:---|:---|:---|
| 1 | Part Number | XCZU4EV-SFVC784-1-i |
| 2 | Logic Cells | ~53,200 |
| 3 | CLB Flip-Flops | 212,000 (approx) |
| 4 | LUTs | 106,000 (approx) |
| 5 | Total Block RAM | 1.8 Mb |
| 6 | DSP Slices | 192 (28x18 multipliers) |
| 7 | Maximum Single-Ended I/O | 256 |
| 8 | No. of IO Banks | 4 (IO Bank 34, 35, 500, 501 - pkg specific) |
| 9 | Transceivers | 4 GTPs (6.6 Gb/s) |
| 10 | ARM Cores | Dual Core Cortex-A53 |

---

## 7. Block Diagram
*(Reference: System Block Diagram in HRS Section 10)*
The GLR defines the logic between the **ADC**, **VGA**, **PHY**, and **FPGA Pins**. The internal FPGA architecture consists of:
1.  **ADC Interface Module:** Deserializes LVDS data from ADC10D1000.
2.  **DSP Chain:** DDC (Digital Down Converter) and FIR Filter implemented in DSP Slices.
3.  **DMA Engine:** Moves processed data from PL to PS DDR memory.
4.  **PS Ethernet:** AXI Ethernet MAC connected to VSC8522 via RGMII.
5.  **Register Slave:** AXI-Lite peripheral mapped to ARM address space for control registers.

---

## 8. Pinout Details

**Table: FPGA Pin Out Details**

| S.No | Signal Name | Pin No (Package) | Voltage Level | Direction wrt FPGA | Source | Destination | Default Condition | Voltage Standard |
|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| 1 | VCCO_34 | - | 3.3V | Power In | PMIC | FPGA Bank 34 | - | - |
| 2 | GND | - | 0V | Power In | PMIC | FPGA GND | - | - |
| 3 | FPGA_CLK_125M | E19 | 1.8V | Input | Oscillator | PLL/PS_CLK | - | LVCMOS18 |
| 4 | FPGA_RESET_N | F20 | 1.8V | Input | Sys Reset | PS_POR | HIGH (Pulled up) | LVCMOS18 |
| 5 | UART_TX | M21 | 3.3V | Output | FPGA (PS) | USB-UART | HIGH | LVCMOS33 |
| 6 | UART_RX | L21 | 3.3V | Input | USB-UART | FPGA (PS) | HIGH | LVCMOS33 |
| 7 | ETH_TXC (GTX_CLK) | K15 | 1.8V/2.5V | Output | FPGA (PS) | VSC8522 | Low | LVCMOS18 |
| 8 | ETH_TX_CTL | J15 | 1.8V/2.5V | Output | FPGA (PS) | VSC8522 | Low | LVCMOS18 |
| 9 | ETH_TXD[0] | K14 | 1.8V/2.5V | Output | FPGA (PS) | VSC8522 | Low | LVCMOS18 |
| 10 | ETH_TXD[1] | L14 | 1.8V/2.5V | Output | FPGA (PS) | VSC8522 | Low | LVCMOS18 |
| 11 | ETH_TXD[2] | M14 | 1.8V/2.5V | Output | FPGA (PS) | VSC8522 | Low | LVCMOS18 |
| 12 | ETH_TXD[3] | N14 | 1.8V/2.5V | Output | FPGA (PS) | VSC8522 | Low | LVCMOS18 |
| 13 | ETH_RXC | M15 | 1.8V/2.5V | Input | VSC8522 | FPGA (PS) | - | LVCMOS18 |
| 14 | ETH_RX_CTL | L15 | 1.8V/2.5V | Input | VSC8522 | FPGA (PS) | - | LVCMOS18 |
| 15 | ETH_RXD[0] | K16 | 1.8V/2.5V | Input | VSC8522 | FPGA (PS) | - | LVCMOS18 |
| 16 | ETH_RXD[1] | L16 | 1.8V/2.5V | Input | VSC8522 | FPGA (PS) | - | LVCMOS18 |
| 17 | ETH_RXD[2] | M16 | 1.8V/2.5V | Input | VSC8522 | FPGA (PS) | - | LVCMOS18 |
| 18 | ETH_RXD[3] | N16 | 1.8V/2.5V | Input | VSC8522 | FPGA (PS) | - | LVCMOS18 |
| 19 | ETH_MDC | N20 | 3.3V | Output | FPGA (PS) | VSC8522 | Low | LVCMOS33 |
| 20 | ETH_MDIO | M20 | 3.3V | Bi-dir | FPGA (PS) | VSC8522 | High (Z) | LVCMOS33 |
| 21 | ETH_RESET_N | P20 | 3.3V | Output | FPGA (PS) | VSC8522 | Low | LVCMOS33 |
| 22 | ADC_CLK_P | A1 | 1.8V | Input | ADC10D1000 | FPGA (PL) | - | LVDS |
| 23 | ADC_CLK_N | B1 | 1.8V | Input | ADC10D1000 | FPGA (PL) | - | LVDS |
| 24 | ADC_DA_P[9:0] | A5..A15 | 1.8V | Input | ADC10D1000 | FPGA (PL) | - | LVDS |
| 25 | ADC_DA_N[9:0] | B5..B15 | 1.8V | Input | ADC10D1000 | FPGA (PL) | - | LVDS |
| 26 | ADC_DB_P[9:0] | C5..C15 | 1.8V | Input | ADC10D1000 | FPGA (PL) | - | LVDS |
| 27 | ADC_DB_N[9:0] | D5..D15 | 1.8V | Input | ADC10D1000 | FPGA (PL) | - | LVDS |
| 28 | ADC_OR | D1 | 1.8V | Input | ADC10D1000 | FPGA (PL) | Low | LVCMOS18 |
| 29 | VGA_CLK | H5 | 3.3V | Output | FPGA (PL) | ADL5330 | Low | LVCMOS33 |
| 30 | VGA_DATA | G5 | 3.3V | Output | FPGA (PL) | ADL5330 | Low | LVCMOS33 |
| 31 | VGA_LE | F5 | 3.3V | Output | FPGA (PL) | ADL5330 | Low | LVCMOS33 |
| 32 | FLASH_MOSI | P21 | 3.3V | Output | FPGA (PS) | Config Flash | Low | LVCMOS33 |
| 33 | FLASH_MISO | R21 | 3.3V | Input | Config Flash | FPGA (PS) | High | LVCMOS33 |
| 34 | FLASH_SCK | T21 | 3.3V | Output | FPGA (PS) | Config Flash | Low | LVCMOS33 |
| 35 | FLASH_CS_N | U21 | 3.3V | Output | FPGA (PS) | Config Flash | High | LVCMOS33 |
| 36 | LED_STATUS_R | Y20 | 3.3V | Output | FPGA (PS) | LED | High | LVCMOS33 |
| 37 | LED_STATUS_G | W20 | 3.3V | Output | FPGA (PS) | LED | High | LVCMOS33 |

---

## 9. Functional Specifications

**Summary Table:**

| S.No. | Function Name | Description |
|:---|:---|:---|
| 1 | **ADC Data Capture** | Deserialization of dual 10-bit LVDS buses (1.0 Gsps per channel) |
| 2 | **Gigabit Ethernet Output** | UDP/TCP packet transmission of processed samples via RGMII PHY |
| 3 | **VGA Gain Control** | SPI/Parallel interface to ADL5330 for 60dB gain adjustment |
| 4 | **Signal Processing (DSP)** | Digital Down Conversion (DDC) and Decimation filtering |
| 5 | **Clock Management** | Generation of ADC sampling clock (varies 1-10 GHz ext ref) |
| 6 | **Power Monitoring** | I2C interface to PMIC and current sensors for health check |
| 7 | **Thermal Monitoring** | I2C interface to temp sensors (Internal + External) |
| 8 | **UART Control** | Console access for Linux and Register Debug interface |
| 9 | **Remote Programming** | Update FPGA Bitstream and Software Images over Ethernet |

### 9.1 ADC Data Capture Interface
*   **Component:** ADC10D1000 (TI)
*   **Mode:** Dual Channel, 10-bit resolution.
*   **Interface Type:** DDR LVDS (Double Data Rate).
*   **Data Rate:** 1 Gsps per channel. (Resulting in 500 MHz toggle rate per LVDS pair).
*   **Timing:** FPGA ISERDES blocks capture data using the ADC_CLK_P/N outputs.
*   **FPGA Logic:** Bitslip alignment logic required to synchronize with ADC frame boundary.

### 9.2 Gigabit Ethernet Interface (RGMII)
*   **PHY:** VSC8522 (Microchip)
*   **MAC:** Integrated PS GEM (Gigabit Ethernet MAC) in Zynq.
*   **Interface:** RGMII (Reduced Gigabit Media Independent Interface).
*   **Clock:** 125MHz TX clock sourced from FPGA, RX clock sourced from PHY. Includes 1.8V/2.5V IO constraints.
*   **Feature:** IEEE 1588 PTP supported for precision timing synchronization.

### 9.3 RF Gain Control (VGA)
*   **Component:** ADL5330
*   **Control:** Serial (SPI-like) Interface.
*   **Signals:** CLK (FPGA -> VGA), DATA (FPGA -> VGA), LE (Latch Enable).
*   **Logic:** 16-bit shift register inside FPGA updates gain based on host command.
*   **Range:** 0 to 255 decimal mapped to -30dB to +30dB attenuation range.

### 9.4 Signal Processing Chain (DSP)
*   **Input:** 10-bit I/Q samples from ADC.
*   **Processing:**
    *   Numerically Controlled Oscillator (NCO) for frequency translation.
    *   Cascaded Integrator-Comb (CIC) Filter for Decimation.
    *   FIR Filter for final shaping.
*   **Output:** 16-bit I/Q complex samples.
*   **Resource Utilization:** Uses Zynq DSP Slices for multipliers.

### 9.5 Power Supply Sequencing
*   **Sequence:** 5V Input -> 1.0V (Core) -> 1.8V (PS) -> 3.3V (IO).
*   **Monitor:** ADC lines from PMIC connected to FPGA XADC pins.
*   **Fault Action:** FPGA enters safe state (LED Red, disable RF Amplifiers) if voltage droops < 5% of nominal.

### 9.6 Thermal Management
*   **Sensors:** On-chip TSD (Thermal Sensor Diode) + External I2C sensor (TMP102 or similar).
*   **Thresholds:**
    *   Warning: > 85°C (Reduce FPGA clock, lower VGA gain).
    *   Critical: > 100°C (Shutdown RF path).

### 9.7 Flash Configuration & Remote Programming
*   **Config Flash:** Spansion S25FL256S (32MB), QSPI interface.
*   **Boot Mode:** Primary Boot from QSPI.
*   **Remote Update:** Images stored in Flash; Handoff register bit triggers PS reboot to load new image.

---

## 10. Software Register Address Map

This section defines the memory-mapped registers accessible by the ARM processor (via AXI) or external UART host for controlling the PL logic.

### 10.1 Register Base Addresses

| Block Name | Base Address | Address Range | Description |
|:---|:---|:---|:---|
| **System / ID** | 0x4000_0000 | 0x4000_0FFF | Core identification, version, reset control |
| **ADC Control** | 0x4001_0000 | 0x4001_0FFF | ADC interface config, capture enable, status |
| **VGA Control** | 0x4002_0000 | 0x4002_0FFF | Gain setting index, latch control |
| **DSP Config** | 0x4003_0000 | 0x4003_0FFF | NCO Frequency, Decimation rate |
| **GPIO / LEDs** | 0x4004_0000 | 0x4004_0FFF | LED control, general outputs |
| **Power Monitor** | 0x4005_0000 | 0x4005_0FFF | XADC readback, over/under voltage flags |
| **Packetizer** | 0x4006_0000 | 0x4006_0FFF | Ethernet packet headers, stream enable |

### 10.2 Detailed Register Map

**Block 0x4000_0000 — System / Identification**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|:---|:---|:---|:---|:---|:---|
| 0x00 | **DEVICE_ID** | 32 | R | 0x4D4E_5631 | ASCII Code "MN_V1" (Project Mn Version 1) |
| 0x04 | **FW_VERSION** | 32 | R | 0x0001_0000 | [31:16] Major, [15:0] Minor |
| 0x10 | **SYS_RESET** | 32 | W | 0x0000_0000 | [0] PL_RESET (Write 1 to reset PL Logic) |
| 0x14 | **SYS_TICK** | 32 | R | 0x0000_0000 | Free running counter (1ms resolution) |

**Block 0x4001_0000 — ADC Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|:---|:---|:---|:---|:---|:---|
| 0x00 | **ADC_CTRL** | 32 | R/W | 0x0000_0000 | [0] ADC_EN (Enable Capture), [1] OR_EN (Overrange En) |
| 0x04 | **ADC_STATUS** | 32 | R | 0x0000_0000 | [0] LOCKED (IDELAY Locked), [1] OR_FLAG (Overrange detected) |
| 0x08 | **ADC_DELAY_A** | 32 | R/W | 0x0000_0000 | [4:0] IDELAY value for Channel A (Taps) |
| 0x0C | **ADC_DELAY_B** | 32 | R/W | 0x0000_0000 | [4:0] IDELAY value for Channel B (Taps) |

**Block 0x4002_0000 — VGA Control (RF Gain)**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|:---|:---|:---|:---|:---|:---|
| 0x00 | **VGA_GAIN_IDX** | 32 | R/W | 0x0000_0080 | Gain Index (0-255). 128 = Midpoint (0dB) |
| 0x04 | **VGA_UPDATE** | 32 | W | 0x0000_0000 | [0] LATCH (Write 1 to update ADL5330) |

**Block 0x4003_0000 — DSP Config**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|:---|:---|:---|:---|:---|:---|
| 0x00 | **NCO_FREQ** | 32 | R/W | 0x0000_0000 | 32-bit Tuning word for NCO (Frequency Control) |
| 0x04 | **DECIMATION_RATE**| 32 | R/W | 0x0000_0004 | Decimation factor (default 4) |
| 0x08 | **DSP_STATUS** | 32 | R | 0x0000_0000 | [0] FIFO_EMPTY, [1] FIFO_FULL |

**Block 0x4006_0000 — Packetizer / Ethernet**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|:---|:---|:---|:---|:---|:---|
| 0x00 | **STREAM_EN** | 32 | R/W | 0x0000_0000 | [0] START_ETHERNET_STREAM |
| 0x04 | **PKT_COUNTER** | 32 | R | 0x0000_0000 | Rolling count of UDP packets transmitted |
| 0x08 | **DST_MAC_HI** | 32 | R/W | 0xFFFF_FFFF | Destination MAC Address [47:32] |
| 0x0C | **DST_MAC_LO** | 32 | R/W | 0xFFFF_FFFF | Destination MAC Address [31:0] |
| 0x10 | **DST_IP** | 32 | R/W | 0xFFFFFFFF | Destination IP Address |
| 0x14 | **DST_PORT** | 32 | R/W | 0x0000_1234 | Destination UDP Port |

### 10.3 Register Access Rules
*   **Addressing:** All registers are 32-bit word aligned.
*   **Read:** Readable registers return current status.
*   **Write:** Writeable registers update immediately unless a LATCH bit is required (see VGA block).
*   **Atomicity:** Registers within a block are not atomic unless using a dedicated bulk transaction command (supported by internal AXI bus but not exposed externally).

---

## 11. UART Register Protocol Specification

*Note: While the primary control is via the internal ARM (Linux), a low-level UART interface is provided for factory test and emergency configuration.*

### 11.1 Physical Layer
*   **Interface:** UART (RS-232 Transceiver level converted to 3.3V LVTTL)
*   **Baud Rate:** 115200 bps (Fixed)
*   **Format:** 8 Data bits, No Parity, 1 Stop bit (8N1)

### 11.2 Command Frame Formats

**Single Register Write (CMD = 0x57 'W'):**
```
Byte 0: 0x57 (CMD)
Byte 1: ADDR[31:24] (Base MSB)
Byte 2: ADDR[23:16]
Byte 3: ADDR[15:8]
Byte 4: ADDR[7:0]  (Base LSB)
Byte 5: DATA[31:24]
Byte 6: DATA[23:16]
Byte 7: DATA[15:8]
Byte 8: DATA[7:0]
→ Response: 0x06 (ACK)
```

**Single Register Read (CMD = 0x52 'R'):**
```
Byte 0: 0x52 (CMD)
Byte 1: ADDR[31:24]
Byte 2: ADDR[23:16]
Byte 3: ADDR[15:8]
Byte 4: ADDR[7:0]
→ Response: DATA[31:24] ... DATA[7:0]
```

### 11.3 Error Response
*   **0x15 (NAK):** Invalid Address, Timeout, or Command Error.

---

## 12. FPGA Resource Utilization Estimate

| Resource | Available (XCZU4EV) | Estimated Usage | Utilization % |
|:---|:---|:---|:---|
| **Slice LUTs** | 53,200 | 22,000 | ~41% |
| **Slice Registers** | 106,400 | 15,000 | ~14% |
| **Block RAM (36Kb)** | ~192 (approx Mb/Kb) | 64 | ~33% |
| **DSP Slices** | 192 | 48 | ~25% |
| **GTP Transceivers** | 4 | 0 (Uses RGMII) | 0% |
| **IO Banks** | 4 | 3 | 75% |
| **PLL/MMCM** | 4 | 2 | 50% |

**Synthesis Tool:** Vivado 2025.1
**Timing Constraint:** 500 MHz for ADC Interface Capture Clock.

---

## Annexure A — Requirement Traceability Matrix

| S.No | GLR-ID | Description | Source HRS Section | GLR Section | Verification Method | Status |
|:---|:---|:---|:---|:---|:---|:---|
| 1 | GLR-001 | RF Input Frequency Range (5-18GHz) | HRS §2.2 | 4, 9.1 | Simulation / Test | Open |
| 2 | GLR-002 | ADC Interface (10-bit, 1 Gsps) | HRS §3.6 (Perf) | 8, 9.1 | Timing Analysis | Open |
| 3 | GLR-003 | Gigabit Ethernet Output | HRS §3.3 (Interface)| 8, 9.2 | Test | Open |
| 4 | GLR-004 | VGA Gain Control | HRS §3.1 (Functional)| 8, 9.3 | Test | Open |
| 5 | GLR-005 | Power Supply (5V Input) | HRS §3.3 (Interface)| 4, 9.5 | Test | Open |
| 6 | GLR-006 | Operating Temp (-40 to +85) | HRS §3.4 (Env) | 9.6 | Environmental Test | Open |
| 7 | GLR-007 | Register Map Structure | Derived | 10 | Inspection | Open |
| 8 | GLR-008 | UART Protocol | Derived | 11 | Test | Open |
| 9 | GLR-009 | FPGA Resource Budget | HRS §3.5 (Constraints)| 12 | Synthesis Report | Open |
| 10 | GLR-010 | Dynamic Range (40-60dB) | HRS §3.2 (Perf) | 9.3, 9.4 | Test | Open |
