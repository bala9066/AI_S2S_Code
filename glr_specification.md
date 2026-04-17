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
|:---:|:---:|:---:|:---:|:---:|:---|
| 1 | 0V01 | 17.04.2026 | - | - | Initial Version |

---

## 1. Scope of the Document
This document explains the IO details and functional requirements of the FPGA for **receiver**. Targeted audience: Hardware Design and Firmware teams.

It bridges the gap between the logical netlist (P4) and the RTL implementation (P7), defining the signal interfaces, timing constraints, register map, and communication protocols required to integrate the RF front-end, ADC, and control logic.

---

## 2. References

### 2.1 External
| Doc. Type | Part No. | Description |
|---|---|---|
| Datasheet | HMC1061LP4E | RF Limiter / Input Protection |
| Datasheet | TGA4506-SM | Wideband Low Noise Amplifier |
| Datasheet | HMC698LP4 | Variable Gain Amplifier (VGA) |
| Datasheet | HMC1052LP4E | IQ Mixer / Downconverter |
| Datasheet | ADF5356 | LO Frequency Synthesizer |
| Datasheet | ADA4817 | IF Amplifier (Baseband IQ) |
| Datasheet | LPF-1000+ | Anti-Alias Filter (Baseband) |
| Datasheet | AD9208 | Dual Channel IQ ADC |
| Datasheet | STM32F407VGT6 | Control MCU |
| Datasheet | LTM4644 | DC-DC Power Supply Module |

### 2.2 Internal
| Reference | Document |
|---|---|
| [HRS] | Hardware Requirements Specification |
| [SCH] | Schematic |
| [GRS] | General Requirements Specification |
| [GDD] | General Design Document |

---

## 3. Acronyms and Abbreviations
| Acronym | Expansion |
|---|---|
| **ADC** | Analog-to-Digital Converter |
| **AFC** | Automatic Frequency Control |
| **AGC** | Automatic Gain Control |
| **BOM** | Bill of Materials |
| **CPLD** | Complex Programmable Logic Device |
| **DAC** | Digital-to-Analog Converter |
| **DC** | Direct Current |
| **DMA** | Direct Memory Access |
| **DSP** | Digital Signal Processing |
| **EMC** | Electromagnetic Compatibility |
| **FCC** | Federal Communications Commission |
| **FF** | Flip-Flop |
| **FIFO** | First In, First Out |
| **FPGA** | Field-Programmable Gate Array |
| **GPIO** | General Purpose Input/Output |
| **HDL** | Hardware Description Language |
| **I2C** | Inter-Integrated Circuit |
| **IIP3** | Input Third-order Intercept Point |
| **IO** | Input/Output |
| **IRQ** | Interrupt Request |
| **JTAG** | Joint Test Action Group |
| **LE** | Logic Element |
| **LNA** | Low Noise Amplifier |
| **LO** | Local Oscillator |
| **LUT** | Look-Up Table |
| **LVDS** | Low-Voltage Differential Signaling |
| **MCU** | Microcontroller Unit |
| **PCB** | Printed Circuit Board |
| **PLL** | Phase-Locked Loop |
| **RoHS** | Restriction of Hazardous Substances |
| **RTL** | Register Transfer Level |
| **RX** | Receive |
| **SPI** | Serial Peripheral Interface |
| **SMA** | SubMiniature version A |
| **[specify]** | To Be Determined |
| **UART** | Universal Asynchronous Receiver-Transmitter |
| **VCC** | Voltage Common Collector |
| **VGA** | Variable Gain Amplifier |

---

## 4. Module Overview

The **receiver** module is a wideband RF receiver covering 5-18 GHz. It converts RF signals to digital I/Q data for processing. The design integrates high-performance RF components, a high-speed ADC, and an FPGA for digital signal processing and control.

### RF SECTION:
*   **RF Limiter (HMC1061LP4E)**: Protects the LNA from input powers >20 dBm.
*   **LNA (TGA4506-SM)**: Provides 21 dB gain with low noise figure (2.5 dB).
*   **VGA (HMC698LP4)**: Digital variable gain amplifier (31 dB range, 1 dB steps) controlled via SPI.
*   **Mixer (HMC1052LP4E)**: Downconverts 5-18 GHz RF to baseband I/Q using a high-side LO injection.
*   **LO Synthesizer (ADF5356)**: Generates the required LO frequency (5-18 GHz) with low phase noise.
*   **IF Amp (ADA4817)**: Amplifies baseband I/Q signals before ADC.
*   **Anti-Alias Filter (LPF-1000+)**: Limits bandwidth to 1 GHz.

### DIGITAL SECTION:
*   **FPGA (XCZU15EG-FFVB1156)**: Acts as the system controller and signal processor.
    *   Interfacing with ADC AD9208 via JESD204B.
    *   Controlling RF components (VGA, LO Synth) via SPI.
    *   Processing I/Q data (Filtering, Decimation).
    *   Communicating with MCU (STM32) via UART.
*   **Control MCU (STM32F407VGT6)**: Handles higher-level protocol, user commands, and Ethernet/USB communication.

### POWER SUPPLY SECTION:
*   **Input**: +12V DC (External Supply).
*   **DC-DC Converter (LTM4644)**: Generates required rails:
    *   +5V (RF Components: Limiter, VGA, Mixer).
    *   +6V (LNA).
    *   +3.3V (FPGA IO, MCU).
    *   +1.0V (FPGA Core/ADC Rails).
*   **Sequencing**: +1.0V Core must ramp before +3.3V IO during power-up.

---

## 5. Features
*   **FPGA**: Xilinx Zynq UltraScale+ XCZU15EG-FFVB1156 (ARM + Logic).
*   **On-board clock oscillator**: 125 MHz (Low jitter CMOS oscillator).
*   **Communication**:
    *   UART (FPGA <-> MCU) @ 3 Mbps.
    *   SPI (FPGA <-> VGA, LO, ADC).
    *   JTAG (for FPGA debug/programming).
*   **Data Interface**: JESD204B (Lane rate: 6.144 Gbps) to AD9208.
*   **EEPROM**: CAT24C256 (32 Kb I2C) for storing calibration data and MAC address.
*   **Temperature Monitoring**: On-die sensors (FPGA/MCU) + NCT75 (I2C) for ambient monitoring.
*   **Power monitoring**: LT2991 (I2C PMIC) for +12V, +5V, +6V rail monitoring.
*   **RF Control**:
    *   31 dB Digital Gain Control via HMC698LP4.
    *   Frequency Synthesis via ADF5356.

---

## 6. FPGA Description

The Xilinx Zynq UltraScale+ MPSoC XCZU15EG is selected to meet the high-speed data processing requirements of the wideband receiver. The programmable logic (PL) handles the JESD204B interface and high-throughput DSP, while the Processing System (PS) handles control and communication.

| S.NO | PARAMETERS | SPECIFICATION |
|:---:|:---|:---|
| 1 | Part Number | XCZU15EG-FFVB1156 |
| 2 | Logic Cells | 504k |
| 3 | CLB Flip-Flops | 604k |
| 4 | Number of Gates | N/A (ASIC metric) |
| 5 | Maximum Distributed RAM (Kb) | 1,831 |
| 6 | Total Block RAM (Kb) | 14,064 |
| 7 | Maximum Single-Ended I/Os | 400 |
| 8 | Maximum DSP Slices | 1,248 |
| 9 | No of IO Bank | 5 (User accessible) |

---

## 7. Block Diagram

*(Reference to Block Diagram - See System Block Diagram in P1)*

**Textual Description:**
The RF signal enters via the SMA connector, passes through the Limiter and LNA. The VGA adjusts the signal level before the Mixer downconverts it using the LO. The IF I/Q signals are filtered and digitized by the ADC. The FPGA receives digitized data via JESD204B, processes it, and passes it to the MCU or outputs it directly. The MCU manages the user interface and configures the FPGA via UART. The FPGA configures the RF chain via SPI.

---

## 8. Pinout Details

**Table: FPGA Pin Out Details**

| S.No | Signal Name | Pin No | Voltage Level | Direction wrt FPGA | Source | Destination | Default Condition | Voltage Standard |
|:---:|---|---|---|---|---|---|---|---|
| 1 | VCCINT | - | 1.0V | Power In | LTM4644 | FPGA Core | Powered | N/A |
| 2 | VCCAUX | - | 1.8V | Power In | LTM4644 | FPGA Aux | Powered | N/A |
| 3 | VCCO_34 | - | 3.3V | IO Bank | LTM4644 | Bank 34 IO | Powered | LVCMOS33 |
| 4 | GND | - | 0V | Ground | Common | FPGA | GND | N/A |
| 5 | FPGA_CLK_125M_P | E12 | 1.8V | Input | Oscillator | PL Clock | HIGH | LVDS |
| 6 | FPGA_CLK_125M_N | F11 | 1.8V | Input | Oscillator | PL Clock | HIGH | LVDS |
| 7 | JTAG_TCK | AA12 | 1.8V | Input | Debugger | FPGA JTAG | Pull-up | LVCMOS18 |
| 8 | JTAG_TDI | AB11 | 1.8V | Input | Debugger | FPGA JTAG | Pull-up | LVCMOS18 |
| 9 | JTAG_TDO | AA11 | 1.8V | Output | FPGA JTAG | Debugger | High-Z | LVCMOS18 |
| 10 | JTAG_TMS | AA10 | 1.8V | Input | Debugger | FPGA JTAG | Pull-up | LVCMOS18 |
| 11 | FPGA_RESET_N | D5 | 3.3V | Input | Reset_Circuit | FPGA_PS | HIGH (Active Low) | LVCMOS33 |
| 12 | UART_TX_MCU | Y3 | 3.3V | Output | FPGA_PS | MCU_RX | HIGH | LVCMOS33 |
| 13 | UART_RX_MCU | Y4 | 3.3V | Input | MCU_TX | FPGA_PS | HIGH | LVCMOS33 |
| 14 | SPI_VGA_CLK | M1 | 3.3V | Output | FPGA_PS | HMC698LP4 | LOW | LVCMOS33 |
| 15 | SPI_VGA_MOSI | M2 | 3.3V | Output | FPGA_PS | HMC698LP4 | LOW | LVCMOS33 |
| 16 | SPI_VGA_MISO | L3 | 3.3V | Input | HMC698LP4 | FPGA_PS | High-Z | LVCMOS33 |
| 17 | SPI_VGA_CS_N | L4 | 3.3V | Output | FPGA_PS | HMC698LP4 | HIGH | LVCMOS33 |
| 18 | SPI_LO_CLK | N1 | 3.3V | Output | FPGA_PS | ADF5356 | LOW | LVCMOS33 |
| 19 | SPI_LO_MOSI | N2 | 3.3V | Output | FPGA_PS | ADF5356 | LOW | LVCMOS33 |
| 20 | SPI_LO_MISO | P1 | 3.3V | Input | ADF5356 | FPGA_PS | High-Z | LVCMOS33 |
| 21 | SPI_LO_CS_N | P2 | 3.3V | Output | FPGA_PS | ADF5356 | HIGH | LVCMOS33 |
| 22 | I2C_SYS_SCL | R5 | 3.3V | Bidirectional | FPGA_PS | EEPROM/Temp | HIGH (Pullup) | LVCMOS33 |
| 23 | I2C_SYS_SDA | R6 | 3.3V | Bidirectional | FPGA_PS | EEPROM/Temp | HIGH (Pullup) | LVCMOS33 |
| 24 | ADC_REFCLK_P | T1 | 1.8V | Output | FPGA_PLL | AD9208 | CLK | LVDS |
| 25 | ADC_REFCLK_N | T2 | 1.8V | Output | FPGA_PLL | AD9208 | CLK | LVDS |
| 26 | ADC_RX0_P | A10 | 1.0V (Diff) | Input | AD9208 | FPGA_GTYP | Data | CML |
| 27 | ADC_RX0_N | B10 | 1.0V (Diff) | Input | AD9208 | FPGA_GTYP | Data | CML |
| 28 | ADC_RX1_P | C12 | 1.0V (Diff) | Input | AD9208 | FPGA_GTYP | Data | CML |
| 29 | ADC_RX1_N | D12 | 1.0V (Diff) | Input | AD9208 | FPGA_GTYP | Data | CML |
| 30 | ADC_SYNC_N | E5 | 1.8V | Output | FPGA_GPIO | AD9208 | HIGH | LVCMOS18 |
| 31 | LED_STATUS | K1 | 3.3V | Output | FPGA_PS | LED_Green | LOW | LVCMOS33 |
| 32 | LED_ERROR | K2 | 3.3V | Output | FPGA_PS | LED_Red | LOW | LVCMOS33 |
| 33 | TEMP_ALERT | J3 | 3.3V | Input | Temp_Sensor | FPGA_GPIO | LOW | LVCMOS33 |
| 34 | PG_1V0 | H1 | 3.3V | Input | PMIC | FPGA_GPIO | HIGH (PG) | LVCMOS33 |
| 35 | FMC_LA00_CC_P | - | - | - | Reserved | FMC_Connector | - | - |
| 36 | FMC_LA00_CC_N | - | - | - | Reserved | FMC_Connector | - | - |
| 37 | FMC_LA01_CC_P | - | - | - | Reserved | FMC_Connector | - | - |
| 38 | FMC_LA01_CC_N | - | - | - | Reserved | FMC_Connector | - | - |

---

## 9. Functional Specifications

**Summary Table:**

| S.No. | Function Name | Description |
|:---:|---|---|
| 1 | Serial Communication Interface | UART between FPGA (PS) and MCU (STM32) for register access and control. |
| 2 | High Speed Communication Interface | JESD204B (Lane Rate 6.144 Gbps) for IQ Data capture from AD9208. |
| 3 | Power Supply Sequencing | Monitors Power Good signals; enables LNA/Mixer only after rails are stable. |
| 4 | Supply Voltage & Temp Monitoring | I2C interface to LT2991 (Power) and NCT75 (Temp). |
| 5 | RF Control Interfaces | SPI Master interfaces for HMC698LP4 (VGA) and ADF5356 (LO). |
| 6 | Data Processing | Decimation, Filtering, and Packetization of IQ data. |
| 7 | Gain Control | Automatic Gain Control (AGC) loop logic based on signal power. |
| 8 | Synchronization | System sync pulse distribution via ADC_SYNC_N. |

### 9.1 Serial Communication Interface (UART)
*   **Interface Type**: UART (Async)
*   **Physical Layer**: 3.3V CMOS (Direct connect to STM32F407)
*   **Baud Rate**: 3,000,000 bps (3 Mbps)
*   **Frame Format**: 1 Start bit, 8 Data bits, No Parity, 1 Stop bit (8N1)
*   **Protocol**: Custom Register-Based Protocol (See Section 11)
*   **Signals**:
    *   `UART_TX_MCU` (FPGA -> MCU)
    *   `UART_RX_MCU` (MCU -> FPGA)

### 9.2 High Speed Communication Interface (JESD204B)
*   **Interface**: JESD204B Subclass 1
*   **Lanes**: 2 Lanes (Lane 0 = I, Lane 1 = Q)
*   **Data Rate**: 6.144 Gbps per lane
*   **Converter Resolution**: 12 bits
*   **Samples per Frame**: 1
*   **Frames per Multiframe**: 32
*   **Scrambling**: Enabled
*   **Control Bits**: 0
*   **SysRef Source**: FPGA (Generated from PLL)
*   **Sync State Machine**: FPGA monitors `SYNC_N~` input from AD9208.

### 9.3 Power On/Off Sequence
**9.3.1 Power ON Sequence:**
1.  +12V Input applied.
2.  LTM4644 generates +1.0V (FPGA Core) and +3.3V (IO).
3.  FPGA releases internal reset (`FPGA_RESET_N` High).
4.  FPGA monitors `PG_1V0`.
5.  FPGA boots from QSPI Flash.
6.  FPGA enables `EN_LNA` and `EN_MIXER` signals (via GPIO expander or SPI) to power RF chain.
7.  FPGA asserts `LED_STATUS`.

**9.3.2 Mode Configuration:**
| Mode | Signal | Value | Description |
|---|---|---|---|
| Normal | OP_MODE[1:0] | 2'b00 | Full Receive Path Active |
| Diagnostic | OP_MODE[1:0] | 2'b01 | Loopback mode, RF path disabled |
| Standby | OP_MODE[1:0] | 2'b10 | RF Disabled, Low Power |

### 9.4 Supply Voltage, Current & Temperature Monitoring
**9.4.1 Supply Monitoring:**
*   **IC**: LT2991 (Quad I2C Voltage/Current Monitor)
*   **Interface**: I2C (Address 0x1F)
*   **Rails**:
    *   +12V Input
    *   +6V (LNA)
    *   +5V (RF ICs)
    *   +1.0V (FPGA Core)
*   **Resolution**: 16-bit ADC.
*   **Thresholds**: Over-voltage latched if +12V > 13.2V. Under-voltage if +12V < 10.8V.

**9.4.2 Temperature Monitoring:**
*   **IC**: NCT75 (Digital Temp Sensor)
*   **Interface**: I2C (Address 0x48)
*   **Range**: -40°C to +125°C
*   **Resolution**: 0.0625°C (11-bit)
*   **Alert**: `TEMP_ALERT` pin asserted if Temp > +70°C.

### 9.5 Flash & Interfaces
**9.5.1 Configuration Flash:**
*   **Part**: MT25QU01G (128 Mb)
*   **Interface**: QSPI (Xilinx PS Boot)
*   **Purpose**: Stores FPGA Bitstream and MCU Firmware backup.
*   **Location**: Connected to PS (Processing System) QSPI pins.

**9.5.2 EEPROM:**
*   **Part**: CAT24C256 (32 Kb)
*   **Interface**: I2C (Address 0x50)
*   **Purpose**: Stores MAC Address, Board Serial Number, and Factory Gain Calibration Tables.

### 9.6 TRP Configuration
*   *Note: Receiver only, does not transmit pulse.*
*   **RX Enable**: Continuous operation.
*   **LNA Enable**: Controlled by GPIO `RX_EN` bit in register. High = LNA Bias On.

### 9.7 FPGA Remote Programming
*   **Protocol**: UART Bootloader (See STM32 AN4221 style logic adapted for FPGA PS).
*   **Trigger**: Magic byte sequence `0xAA 0x55 0xA5` on UART.
*   **Process**: FPGA halts DSP, writes new bitstream to QSPI, soft-resets PS.

### 9.8 Phase Shifter Controlling
*   *Not applicable for this receiver configuration (Fixed Phase LO).*

### 9.9 Beam Steering Calculation
*   *Not applicable (Single Channel Receiver).*

### 9.10 Gate Voltage Writing (DAC)
*   *Not applicable (VGA is digital SPI, PA is not present in Receiver).*

---

## 10. Software Register Address Map

### 10.1 Register Base Addresses

| Block Name | Base Address | Address Range | Description |
|---|---|---|---|
| System / Identification | 0x0000 | 0x0000–0x00FF | Board ID, firmware version, status |
| UART Control | 0x0100 | 0x0100–0x01FF | Baud rate, FIFO control |
| JESD204B / ADC | 0x0200 | 0x0200–0x02FF | ADC Status, Lane config, Test pattern |
| SPI Control | 0x0300 | 0x0300–0x03FF | SPI master for VGA/LO |
| I2C Control | 0x0400 | 0x0400–0x04FF | I2C master access |
| GPIO | 0x0500 | 0x0500–0x05FF | LED, RX_EN control |
| RF Control | 0x0600 | 0x0600–0x06FF | Gain, Frequency, RX_Enable |
| Diagnostics | 0x0A00 | 0x0A00–0x0AFF | Fault log, uptime |

### 10.2 Detailed Register Map

**Block 0x0000 — System / Identification**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|---|---|---|---|---|---|
| 0x00 | BOARD_ID | 16 | R | 0xA5A5 | Magic Number for board detection |
| 0x01 | FW_VERSION | 16 | R | 0x0100 | Firmware Version (1.0) |
| 0x02 | STATUS | 16 | R | 0x0000 | [15:2] Reserved, [1] PLL_LOCKED, [0] ADC_LOCKED |

**Block 0x0200 — JESD204B / ADC**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|---|---|---|---|---|---|
| 0x00 | ADC_CTRL | 16 | R/W | 0x0001 | [0] ADC_ENABLE, [1] SYNC_RESET |
| 0x01 | ADC_STATUS | 16 | R | 0x0000 | [0] LANE0_ALIGN, [1] LANE1_ALIGN, [2] SYSREF_OK |
| 0x02 | SAMPLE_RATE | 16 | R/W | 0x07D0 | Decimation Factor (2000 = 200 MSPS effective) |

**Block 0x0300 — SPI Control (VGA & LO)**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|---|---|---|---|---|---|
| 0x00 | SPI_VGA_GAIN | 16 | R/W | 0x0000 | [4:0] Gain Setting (0-31dB, 1dB steps) |
| 0x01 | SPI_LO_DIV | 16 | R/W | 0x0040 | Integer Divider for ADF5356 |
| 0x02 | SPI_LO_FRAC | 32 | R/W | 0x00000000 | Fractional Divider for ADF5356 (Write Low then High) |
| 0x03 | SPI_LO_WRITE | 8 | W | 0x00 | Write pulse to latch ADF5356 registers |

**Block 0x0500 — GPIO**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|---|---|---|---|---|---|
| 0x00 | GPIO_CTRL | 16 | R/W | 0x0000 | [0] LED_STATUS, [1] LED_ERROR, [2] RX_LNA_EN |
| 0x01 | GPIO_READ | 16 | R | Input | [0] PG_1V0, [1] TEMP_ALERT |

**Block 0x0600 — RF Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|---|---|---|---|---|---|
| 0x00 | RX_GAIN | 16 | R/W | 0x001F | 5-bit Gain Value (0-31dB) |
| 0x01 | RX_FREQ_MHZ | 32 | R/W | 11500 | RF Frequency in MHz (5000-18000) |
| 0x02 | AGC_ENABLE | 8 | R/W | 0x01 | [0] Enable/Disable AGC Loop |

### 10.3 Register Access Rules
*   **Write**: Address LSB is even.
*   **Read**: Address OR 0x8000 (MSB set).
*   **Burst**: Supported for Address ranges that align.

---

## 11. UART Register Protocol Specification

This section defines the protocol used by the external MCU (or PC via USB-UART) to access FPGA registers.

### 11.1 Physical Layer
*   **Baud Rate**: 3,000,000 bps
*   **Data Bits**: 8
*   **Stop Bits**: 1
*   **Parity**: None
*   **Interface**: 3.3V LVCMOS

### 11.2 Command Frame Formats

**Single Register Write (CMD = 0x57 'W'):**
```
Byte 0: 0x57 (CMD)
Byte 1: ADDR[15:8] (address MSB)
Byte 2: ADDR[7:0]  (address LSB)
Byte 3: DATA[15:8] (data MSB)
Byte 4: DATA[7:0]  (data LSB)
→ Response: 0x06 (ACK) or 0x15 (NAK)
```

**Single Register Read (CMD = 0x52 'R'):**
```
Byte 0: 0x52 (CMD)
Byte 1: (ADDR[15:8] | 0x80)
Byte 2: ADDR[7:0]
→ Response: DATA[15:8], DATA[7:0]
```

**Bulk Register Write (CMD = 0x42 'B'):**
```
Byte 0: 0x42 (CMD)
Byte 1: ADDR[15:8]
Byte 2: ADDR[7:0]
Byte 3: N (count)
Byte 4..4+2N-1: DATA pairs
→ Response: 0x06 (ACK)
```

**Bulk Register Read (CMD = 0x62 'b'):**
```
Byte 0: 0x62 (CMD)
Byte 1: (ADDR[15:8] | 0x80)
Byte 2: ADDR[7:0]
Byte 3: N (count)
→ Response: DATA[0]_H...DATA[N-1]_L
```

### 11.3 Protocol Timing Constraints
| Parameter | Min | Typical | Max | Unit |
|---|---|---|---|---|
| Inter-byte gap | 1 | - | 100 | ms |
| Response Time (Write) | - | 0.5 | 5 | ms |
| Response Time (Read) | - | 1 | 10 | ms |

---

## 12. FPGA Resource Utilization Estimate

| Resource | Available | Estimated Usage | Utilization % |
|---|---|---|---|
| Slice LUTs | 253,200 | 45,000 | 17.7% |
| Slice Flip-Flops | 506,400 | 30,000 | 5.9% |
| Block RAM (36Kb) | 912 | 120 | 13.1% |
| DSP Slices | 1,248 | 64 | 5.1% |
| GTYP Transceivers | 16 | 2 | 12.5% |
| PLL/MMCM | 6 | 3 | 50% |

**Synthesis Tool**: Xilinx Vivado 2024.1
**Target Device**: XCZU15EG-FFVB1156
**Primary Clock**: 125 MHz (Input), 200 MHz (Processing), 6.144 Gbps (SERDES)

---

## Annexure A — Requirement Traceability Matrix

| S.No. | GLR-ID | Description | Source HRS Section | GLR Section | Verification Method | Status |
|---|---|---|---|---|---|---|
| 1 | GLR-001 | Frequency Range Control | HRS §2, REQ-HW-001 | 9.1, 10.2 | Test | Open |
| 2 | GLR-002 | Digital I/Q Output (JESD204B) | HRS §2, REQ-HW-006 | 9.2 | Test | Open |
| 3 | GLR-003 | Gain Control (VGA) | HRS §3.1, REQ-HW-007 | 9.8, 10.2 | Test | Open |
| 4 | GLR-004 | LO Synthesizer Interface | HRS §3.1, REQ-HW-009 | 9.8, 10.2 | Test | Open |
| 5 | GLR-005 | RF Limiter Protection | HRS §3.1, REQ-HW-014 | 9.3 | Test | Open |
| 6 | GLR-006 | Serial Comm Interface | HRS §3.3, REQ-HW-010 | 9.1, 11 | Test | Open |
| 7 | GLR-007 | Power Supply Interface | HRS §3.3, REQ-HW-012 | 9.4, 9.3 | Test | Open |
| 8 | GLR-008 | Register Map Definition | HRS §2 | 10 | Inspection | Open |
| 9 | GLR-009 | JESD204B Link | HRS §2 | 9.2 | Simulation | Open |
| 10 | GLR-010 | Resource Budget | HRS §2 | 12 | Analysis | Open |