# Glue Logic Requirements (GLR)

## Document Control
| Document Title | Glue Logic Requirements (GLR) |
| :--- | :--- |
| **Project Name** | Sample Ai Project |
| **Version Date** | 16.04.2026 |
| **Version Number** | 0V01 |
| **Prepared By** | Name: . Sign: |
| **Document Review By** | Name: . Sign: |

---

## Amendments to the Document
| S. No. | Ver. No. | Ver. Date | Changed By | Section(s) Changed | Description of Change |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | 0V01 | 16.04.2026 | - | - | Initial Release |

---

## 1. Scope of the Document
This document details the Input/Output (I/O) interfaces, signal connectivity, and functional requirements of the FPGA within the Sample Ai Project. It serves as the bridge between the hardware Netlist (P4) and the FPGA RTL Design (P7). It defines the pin-level electrical characteristics, timing constraints, register map architecture, and communication protocols required for the firmware implementation.

---

## 2. References

### 2.1 External
| Doc. Type | Part No. | Description |
| :--- | :--- | :--- |
| Datasheet | **RT-Kintex-7-RT** | Radiation-Tolerant Kintex-7 FPGA Family (Xilinx/AMD) |
| Datasheet | **ADC10D1000RF** | 10-Bit, 10 GSPS ADC (Texas Instruments) |
| Datasheet | **HMC698LP4E** | 6-Bit Digital Step Attenuator (Analog Devices) |
| Datasheet | **HMC7044** | High-Performance Clock Generator (Analog Devices) |
| Datasheet | **LTC2937** | Hex Power Supply Sequencer (Analog Devices) |
| Datasheet | **LT3045** | Low Noise Linear Regulator |
| Spec | **JESD204B** | Standard for High-Speed Data Converter Interface |

### 2.2 Internal
| Reference | Document |
| :--- | :--- |
| [HRS] | Hardware Requirements Specification (P1/P2) |
| [SCH] | Schematic Netlist (P4) |
| [BOM] | Bill of Materials (P1) |
| [GRS] | General Requirements Specification |
| [GDD] | General Design Document |

---

## 3. Acronyms and Abbreviations
| Acronym | Expansion |
| :--- | :--- |
| **ADC** | Analog-to-Digital Converter |
| **AGC** | Automatic Gain Control |
| **BOM** | Bill of Materials |
| **BRAM** | Block RAM (FPGA memory resource) |
| **CLB** | Configurable Logic Block |
| **CMOS** | Complementary Metal-Oxide-Semiconductor |
| **DAC** | Digital-to-Analog Converter |
| **DSA** | Digital Step Attenuator |
| **DSP** | Digital Signal Processing (Slice) |
| **EMC** | Electromagnetic Compatibility |
| **FF** | Flip-Flop |
| **FPGA** | Field-Programmable Gate Array |
| **GND** | Ground Reference |
| **GPIO** | General Purpose Input/Output |
| **GSPS** | Giga-Samples Per Second |
| **HDL** | Hardware Description Language |
| **I2C** | Inter-Integrated Circuit (Serial Bus) |
| **IIP3** | Input Third-Order Intercept Point |
| **JTAG** | Joint Test Action Group (Debug Interface) |
| **LVDS** | Low-Voltage Differential Signaling |
| **LUT** | Look-Up Table |
| **PCB** | Printed Circuit Board |
| **PLL** | Phase-Locked Loop |
| **RTL** | Register Transfer Level |
| **SFDR** | Spurious-Free Dynamic Range |
| **SPI** | Serial Peripheral Interface |
| **TTL** | Transistor-Transistor Logic |
| **UART** | Universal Asynchronous Receiver-Transmitter |
| **VCC** | Voltage Supply (Common) |

---

## 4. Module Overview

**RF SECTION:**
The RF front-end captures the 5-18 GHz wideband signal via the SMA input connector (J1).
1.  **TGA4943-SL (U1)**: Wideband LNA provides 22 dB gain with a 3.5 dB noise figure.
2.  **HMC698LP4E (U2)**: 6-bit Digital Step Attenuator provides fine gain control (0.25 dB steps) to manage the dynamic range (-90 to -70 dBm).
3.  **CBP-1850+ (U3)**: Bandpass filter limits out-of-band noise.
These components are powered by the 5V (LNA) and 3.3V (DSA) rails derived from the LDO network.

**DIGITAL SECTION:**
The digital core is centered around the **RT-Kintex-7-RT (U5)**.
1.  **ADC10D1000RF (U4)**: Samples the filtered RF signal at up to 10 GSPS. It outputs dual-channel DDR LVDS data (12-bit effective width mapped to lanes) and frame clocks to the FPGA High-Speed I/O banks.
2.  **HMC7044 (U6)**: Generates the ultra-low jitter clock for the ADC and the system reference clock for the FPGA.
3.  **FPGA Logic**: Performs JESD204B lane alignment, packet framing, DSA gain control via SPI, and system health monitoring.

**POWER SUPPLY SECTION:**
The system accepts 12V input via J4.
1.  **LTM4644-1 (U7)**: DC-DC Buck regulator generates intermediate rails.
2.  **LT3045/LT3040 Family (U8-U13)**: Low-noise LDOs provide ripple-sensitive rails:
    *   5.0V (LNA)
    *   3.3V (DSA, ADC Analog, Clock)
    *   2.5V (ADC Digital)
    *   1.8V (FPGA VCCAUX)
    *   1.2V (FPGA VCCBRAM)
    *   1.0V (FPGA VCCINT)
3.  **LTC2937 (U14)**: Sequencer monitors the rails and enables the LDOs in a specific power-up sequence.

---

## 5. Features
*   **FPGA**: Xilinx/AMD RT-Kintex-7-RT (Radiation Tolerant) - High-speed signal processing capability.
*   **High-Speed ADC**: TI ADC10D1000RF running at 10 GSPS (5-10 GSPS configurable).
*   **Data Interface**: JESD204B (Subclass 1) compliant DDR LVDS interface (22 Lanes total).
*   **Clocking**: HMC7044 based low-jitter (<100 fs RMS) clock distribution.
*   **Gain Control**: 6-bit SPI-controlled Digital Step Attenuator (HMC698LP4E) for 31.75 dB range.
*   **Control Interface**: UART (for command/control) and I2C (for monitoring/sensor expansion).
*   **Power Management**: LTC2937-based power sequencing and health monitoring.
*   **Environmental**: Designed for -55°C to +125°C operation (Mil-Grade components).
*   **Configuration**: Remote programming capability via UART boot-loader.

---

## 6. FPGA Description

The RT-Kintex-7-RT is selected for its radiation tolerance (SEU mitigation) and high-performance transceivers suitable for processing 10 GSPS data rates.

| S.NO | PARAMETERS | SPECIFICATION |
|:---|:---|:---|
| 1 | Part Number | RT-Kintex-7-RT (XQRK7K325T or equivalent) |
| 2 | Logic Cells | 326,000 |
| 3 | CLB Flip-Flops | 407,200 |
| 4 | Number of Gates | ~4.6 Million (ASIC equiv.) |
| 5 | Max Distributed RAM (Kb) | 520 |
| 6 | Total Block RAM (Kb) | 16,620 |
| 7 | Max Single-Ended I/Os | 500 |
| 8 | Max DSP Slices | 1,540 |
| 9 | No of IO Bank | 14 (Includes High Range Banks) |

---

## 7. Block Diagram
(Reference P1 Block Diagram and P4 Netlist)
*   **Input**: RF (5-18 GHz) -> LNA -> DSA -> Filter -> ADC.
*   **Clock**: HMC7044 -> ADC CLK & FPGA REF CLK.
*   **Data**: ADC LVDS Pairs -> FPGA Banks (HR/MR).
*   **Control**: FPGA <-> HMC698LP4E (SPI), FPGA <-> ADC (SPI), FPGA <-> Host (UART).

---

## 8. Pinout Details

**Table: FPGA Pin Out Details**

| S.No | Signal Name | Pin No (Pkg) | Voltage Level | Direction wrt FPGA | Source | Destination | Default Condition | Voltage Standard |
|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| **1** | **POWER & GROUND** | | | | | | | |
| 1.1 | VCCINT_1V0 | BGA Array | 1.0V | PWR | LDO (U13) | FPGA Core | - | - |
| 1.2 | VCCAUX_1V8 | BGA Array | 1.8V | PWR | LDO (U11) | FPGA Aux | - | - |
| 1.3 | VCCBRAM_1V2 | BGA Array | 1.2V | PWR | LDO (U12) | FPGA BRAM | - | - |
| 1.4 | GND | BGA Array | 0V | PWR | GND Plane | FPGA GND | - | - |
| **2** | **CLOCKING** | | | | | | | |
| 2.1 | FPGA_CLK_P | E12 | 1.8V | INPUT | HMC7044 (U6) | FPGA Global Buf | - | LVDS / DIFF_HSTL |
| 2.2 | FPGA_CLK_M | D12 | 1.8V | INPUT | HMC7044 (U6) | FPGA Global Buf | - | LVDS / DIFF_HSTL |
| 2.3 | ADC_CLK_P | F15 | 1.8V | OUTPUT (Optional) | FPGA | HMC7044/SYNC | - | LVDS |
| 2.4 | ADC_CLK_M | G15 | 1.8V | OUTPUT (Optional) | FPGA | HMC7044/SYNC | - | LVDS |
| **3** | **JTAG** | | | | | | | |
| 3.1 | TCK | J22 | 1.8V | INPUT | JTAG Header | FPGA JTAG | Pull Down | LVCMOS18 |
| 3.2 | TDI | K22 | 1.8V | INPUT | JTAG Header | FPGA JTAG | Pull Up | LVCMOS18 |
| 3.3 | TDO | L21 | 1.8V | OUTPUT | FPGA JTAG | JTAG Header | High Z | LVCMOS18 |
| 3.4 | TMS | M22 | 1.8V | INPUT | JTAG Header | FPGA JTAG | Pull Up | LVCMOS18 |
| **4** | **UART / CONTROL** | | | | | | | |
| 4.1 | FPGA_GPIO_UART_TX | N1 | 1.8V | OUTPUT | FPGA | Connector (J2) | High | LVCMOS18 |
| 4.2 | FPGA_GPIO_UART_RX | M1 | 1.8V | INPUT | Connector (J2) | FPGA | High Z | LVCMOS18 |
| 4.3 | FPGA_RESET_N | P2 | 1.8V | INPUT | Button/Jumper | FPGA System Reset | Pull Up | LVCMOS18 |
| **5** | **I2C INTERFACE** | | | | | | | |
| 5.1 | FPGA_SDA | R5 | 1.8V | BIDIR | FPGA | J2 / Sensors | High Z | LVCMOS18 (Open Drain) |
| 5.2 | FPGA_SCL | T5 | 1.8V | BIDIR | FPGA | J2 / Sensors | High Z | LVCMOS18 (Open Drain) |
| **6** | **SPI (DSA CONTROL)** | | | | | | | |
| 6.1 | DSA_LE | Y20 | 2.5V | OUTPUT | FPGA | HMC698LP4E | Low | LVCMOS25 |
| 6.2 | DSA_CLK | Y21 | 2.5V | OUTPUT | FPGA | HMC698LP4E | Low | LVCMOS25 |
| 6.3 | DSA_DATA | W22 | 2.5V | OUTPUT | FPGA | HMC698LP4E | Low | LVCMOS25 |
| 6.4 | DSA_CS | V22 | 2.5V | OUTPUT | FPGA | HMC698LP4E | High | LVCMOS25 |
| **7** | **SPI (ADC CONTROL)** | | | | | | | |
| 7.1 | ADC_SCLK | AA20 | 1.8V | OUTPUT | FPGA | ADC10D1000RF | Low | LVCMOS18 |
| 7.2 | ADC_SDIO | AB20 | 1.8V | BIDIR | FPGA | ADC10D1000RF | High Z | LVCMOS18 |
| 7.3 | ADC_CSB | AA21 | 1.8V | OUTPUT | FPGA | ADC10D1000RF | High | LVCMOS18 |
| **8** | **ADC DATA LANE 0** | | | | | | | |
| 8.1 | ADC_DOUT_D0_P | A1 | 1.8V | INPUT | ADC (U4) | FPGA DDR Input | - | LVDS_25 |
| 8.2 | ADC_DOUT_D0_M | B1 | 1.8V | INPUT | ADC (U4) | FPGA DDR Input | - | LVDS_25 |
| **9** | **ADC DATA LANE 1** | | | | | | | |
| 9.1 | ADC_DOUT_D1_P | C2 | 1.8V | INPUT | ADC (U4) | FPGA DDR Input | - | LVDS_25 |
| 9.2 | ADC_DOUT_D1_M | D2 | 1.8V | INPUT | ADC (U4) | FPGA DDR Input | - | LVDS_25 |
| **10** | **ADC DATA LANE 2** | | | | | | | |
| 10.1 | ADC_DOUT_D2_P | E3 | 1.8V | INPUT | ADC (U4) | FPGA DDR Input | - | LVDS_25 |
| 10.2 | ADC_DOUT_D2_M | F3 | 1.8V | INPUT | ADC (U4) | FPGA DDR Input | - | LVDS_25 |
| **11** | **ADC DATA LANE 3** | | | | | | | |
| 11.1 | ADC_DOUT_D3_P | G4 | 1.8V | INPUT | ADC (U4) | FPGA DDR Input | - | LVDS_25 |
| 11.2 | ADC_DOUT_D3_M | H4 | 1.8V | INPUT | ADC (U4) | FPGA DDR Input | - | LVDS_25 |
| **12** | **ADC DATA LANE 4** | | | | | | | |
| 12.1 | ADC_DOUT_D4_P | J5 | 1.8V | INPUT | ADC (U4) | FPGA DDR Input | - | LVDS_25 |
| 12.2 | ADC_DOUT_D4_M | K5 | 1.8V | INPUT | ADC (U4) | FPGA DDR Input | - | LVDS_25 |
| **13** | **ADC DATA LANE 5** | | | | | | | |
| 13.1 | ADC_DOUT_D5_P | L6 | 1.8V | INPUT | ADC (U4) | FPGA DDR Input | - | LVDS_25 |
| 13.2 | ADC_DOUT_D5_M | M6 | 1.8V | INPUT | ADC (U4) | FPGA DDR Input | - | LVDS_25 |
| **14** | **ADC DATA LANE 6** | | | | | | | |
| 14.1 | ADC_DOUT_D6_P | N7 | 1.8V | INPUT | ADC (U4) | FPGA DDR Input | - | LVDS_25 |
| 14.2 | ADC_DOUT_D6_M | P7 | 1.8V | INPUT | ADC (U4) | FPGA DDR Input | - | LVDS_25 |
| **15** | **ADC DATA LANE 7** | | | | | | | |
| 15.1 | ADC_DOUT_D7_P | R8 | 1.8V | INPUT | ADC (U4) | FPGA DDR Input | - | LVDS_25 |
| 15.2 | ADC_DOUT_D7_M | T8 | 1.8V | INPUT | ADC (U4) | FPGA DDR Input | - | LVDS_25 |
| **16** | **ADC DATA LANE 8** | | | | | | | |
| 16.1 | ADC_DOUT_D8_P | U9 | 1.8V | INPUT | ADC (U4) | FPGA DDR Input | - | LVDS_25 |
| 16.2 | ADC_DOUT_D8_M | V9 | 1.8V | INPUT | ADC (U4) | FPGA DDR Input | - | LVDS_25 |
| **17** | **ADC DATA LANE 9** | | | | | | | |
| 17.1 | ADC_DOUT_D9_P | W10 | 1.8V | INPUT | ADC (U4) | FPGA DDR Input | - | LVDS_25 |
| 17.2 | ADC_DOUT_D9_M | Y10 | 1.8V | INPUT | ADC (U4) | FPGA DDR Input | - | LVDS_25 |
| **18** | **ADC CLOCKING** | | | | | | | |
| 18.1 | ADC_DOUT_CLK_P | AA1 | 1.8V | INPUT | ADC (U4) | FPGA DDR Input | - | LVDS_25 |
| 18.2 | ADC_DOUT_CLK_M | AB1 | 1.8V | INPUT | ADC (U4) | FPGA DDR Input | - | LVDS_25 |
| 18.3 | ADC_FCO_P | AC2 | 1.8V | INPUT | ADC (U4) | FPGA DDR Input | - | LVDS_25 |
| 18.4 | ADC_FCO_M | AD2 | 1.8V | INPUT | ADC (U4) | FPGA DDR Input | - | LVDS_25 |
| **19** | **OUTPUT DATA INTERFACE** | | | | | | | |
| 19.1 | FPGA_DATA_OUT_P | E22 | 1.8V | OUTPUT | FPGA | J3 (Host) | - | LVDS |
| 19.2 | FPGA_DATA_OUT_M | F22 | 1.8V | OUTPUT | FPGA | J3 (Host) | - | LVDS |

*(Note: Pin numbers are representative for a BGA package like FFG676 or similar; actual pin assignment depends on PCB layout constraints.)*

---

## 9. Functional Specifications

**Summary Table:**

| S.No. | Function Name | Description |
|:---|:---|:---|
| 1 | **High-Speed Data Capture** | Capture 22-bit LVDS data bus from ADC10D1000RF at DDR rates (approx 5 GHz per lane edge). |
| 2 | **JESD204B Interface** | Implement Transport layer (Framer) or Custom Bus mapping for ADC data. |
| 3 | **Gain Control Loop** | SPI configuration of HMC698LP4E DSA based on input signal level. |
| 4 | **Serial Communication** | UART Command/Response interface for register access and status reporting. |
| 5 | **Power Sequencing** | Monitor LTC2937 enable lines and provide status. |
| 6 | **Clock Distribution** | Sync with HMC7044 clock source. |
| 7 | **System Health** | Internal Xilinx System Monitor for die temp & VCCINT. |
| 8 | **Remote Programming** | Multi-boot configuration via SPI Flash. |

### 9.1 High Speed Data Capture Interface
*   **Interface**: Parallel DDR LVDS (22 bits total).
*   **Source**: ADC10D1000RF.
*   **Data Rate**: Up to 10 GSPS equivalent throughput.
*   **FPGA Implementation**: Use Input BUFH/BUFR and ISERDES blocks to deserialize the DDR LVDS inputs into SDR parallel words inside the FPGA fabric.
*   **Calibration**: Implement IDELAY calibration to compensate for PCB trace length mismatches between ADC lanes and FPGA pins.

### 9.2 Gain Control Loop (DSA)
*   **Target**: HMC698LP4E (Digital Step Attenuator).
*   **Interface**: SPI-compatible Serial Interface.
*   **Signals**: DATA, CLK, LE (Latch Enable), CS (Chip Select).
*   **Protocol**: 6-bit shift register.
    1.  Drive CS Low.
    2.  Clock in 6 bits of data (MSB first).
    3.  Drive CS High.
    4.  Pulse LE High to load new attenuation value.
*   **Latency**: < 1 µs from register write to LE assertion.

### 9.3 Serial Communication Interface (UART)
*   **Physical Interface**: UART via Header J2.
*   **Voltage Levels**: 1.8V LVCMOS (FPGA side). Level shifter required if external host is 3.3V/5V.
*   **Baud Rate**: 115200 bps (default), Configurable up to 921600 bps.
*   **Protocol**: 8-N-1 (8 data bits, No parity, 1 stop bit).
*   **Framing**: Packet-based structure defined in Section 11.

### 9.4 Clock Distribution & Synchronization
*   **Clock Source**: HMC7044.
*   **FPGA Input**: Differential LVDS (FPGA_CLK_P/M).
*   **Frequency**: 125 MHz or 156.25 MHz (depending on ADC configuration).
*   **Function**: Provides the system clock for the FPGA logic and synchronizes the ADC data capture domain.
*   **Reset**: A global reset (FPGA_RESET_N) ensures all logic starts in a known state after clock lock is achieved.

### 9.5 Power Supply Sequencing & Monitoring
*   **Sequencer**: LTC2937.
*   **FPGA Role**: The FPGA must ensure that the configuration bitstream accounts for the power-up sequence defined by the LTC2937 (VCCINT must be stable before configuration begins).
*   **Monitoring**:
    *   **Internal**: Xilinx System Monitor (XADC) for on-die temperature and VCCINT/VCCAUX.
    *   **External**: FPGA GPIOs can be used to read "Power Good" signals from the LTC2937 if implemented in the netlist.

### 9.6 Flash Interfaces (Configuration)
*   **Primary**: SPI Boot Flash (not explicitly listed in Netlist snippet but assumed for RT-FPGA operation).
*   **Interface**: Quad-SPI (x4).
*   **Function**: Stores FPGA bitstream. FPGA loads configuration on power-up.
*   **Remote Update**: Design must support a Multiboot configuration to allow remote firmware updates via UART.

---

## 10. Software Register Address Map

This section defines the memory-mapped registers accessible via the UART protocol.

### 10.1 Register Base Addresses

| Block Name | Base Address | Address Range | Description |
|:---|:---|:---|:---|
| **System / ID** | 0x0000 | 0x0000–0x00FF | Board ID, Firmware Version, Status |
| **UART Control** | 0x0100 | 0x0100–0x01FF | Baud Rate, FIFO Control |
| **DSA / RF Control** | 0x0200 | 0x0200–0x02FF | Attenuation setting, RF Enable |
| **SPI Flash / Config** | 0x0300 | 0x0300–0x03FF | Configuration control |
| **System Monitor** | 0x0400 | 0x0400–0x04FF | FPGA Temp, Voltage readings |
| **ADC Interface** | 0x0500 | 0x0500–0x05FF | ADC SPI control, ADC Status |

### 10.2 Detailed Register Map

**Block 0x0000 — System / Identification**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|:---|:---|:---|:---|:---|:---|
| 0x00 | BOARD_ID | 16 | R | 0xA105 | Board Identifier (A105 = Sample Ai) |
| 0x01 | FW_VERSION | 16 | R | 0x0001 | Firmware Version Number |
| 0x02 | SYSTEM_STATUS | 16 | R | 0x0000 | [15:2] Reserved, [1] FPGA_LOCKED, [0] POWER_GOOD |
| 0x03 | SYSTEM_CTRL | 16 | R/W | 0x0000 | [0] SOFT_RESET, [1] FACTORY_RESET |

**Block 0x0100 — UART Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|:---|:---|:---|:---|:---|:---|
| 0x00 | BAUD_DIV | 16 | R/W | 0x0016 | Baud Rate Divisor |
| 0x01 | UART_CONFIG | 16 | R/W | 0x0000 | [0] PARITY_EN |

**Block 0x0200 — DSA / RF Control (HMC698LP4E)**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|:---|:---|:---|:---|:---|:---|
| 0x00 | DSA_ATTENUATION | 16 | R/W | 0x0000 | [5:0] 6-bit Attenuation Value (0-63) |
| 0x01 | DSA_CTRL | 16 | R/W | 0x0000 | [0] DSA_LE (Latch), [1] DSA_CS (Chip Select) |

**Block 0x0400 — System Monitor (XADC)**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|:---|:---|:---|:---|:---|:---|
| 0x00 | FPGA_TEMP | 16 | R | 0x0000 | Raw ADC value for Die Temp |
| 0x01 | VCCINT_MEAS | 16 | R | 0x0000 | Raw ADC value for VCCINT (1.0V) |
| 0x02 | VCCAUX_MEAS | 16 | R | 0x0000 | Raw ADC value for VCCAUX (1.8V) |
| 0x03 | ALARM_STATUS | 16 | R | 0x0000 | [0] OT_TRIGGER (Overtemp) |

---

## 11. UART Register Protocol Specification

### 11.1 Physical Layer
*   **Baud Rate**: 115200 bps (Default).
*   **Data Bits**: 8.
*   **Parity**: None.
*   **Stop Bits**: 1.
*   **Interface**: UART (RX/TX).

### 11.2 Command Frame Formats

**Single Register Write (CMD = 0x57 'W')**
Host to FPGA:
```
Byte 0: 0x57 (CMD)
Byte 1: ADDR[15:8]
Byte 2: ADDR[7:0]
Byte 3: DATA[15:8]
Byte 4: DATA[7:0]
```
FPGA Response:
```
Byte 0: 0x06 (ACK) on success.
Byte 0: 0x15 (NAK) on invalid address.
```

**Single Register Read (CMD = 0x52 'R')**
Host to FPGA:
```
Byte 0: 0x52 (CMD)
Byte 1: ADDR[15:8]
Byte 2: ADDR[7:0]
```
FPGA Response:
```
Byte 0: DATA[15:8]
Byte 1: DATA[7:0]
```

**Bulk Register Write (CMD = 0x42 'B')**
Used for writing blocks (e.g., updating gain tables).
```
Byte 0: 0x42
Byte 1: START_ADDR[15:8]
Byte 2: START_ADDR[7:0]
Byte 3: COUNT (N)
Bytes 4..3+(N*2): Data Words
```
Response: `0x06` (ACK).

**Bulk Register Read (CMD = 0x62 'b')**
```
Byte 0: 0x62
Byte 1: START_ADDR[15:8]
Byte 2: START_ADDR[7:0]
Byte 3: COUNT (N)
```
Response: `N` words of data (2*N bytes).

### 11.3 Protocol Timing Constraints
| Parameter | Min | Max | Unit |
|:---|:---|:---|:---|
| Inter-byte gap | - | 50 | ms |
| ACK Response Time | - | 2 | ms |
| Read Response Time | - | 5 | ms |

---

## 12. FPGA Resource Utilization Estimate

| Resource | Available (K325T) | Estimated Usage | Utilization % |
|:---|:---|:---|:---|
| **Slice LUTs** | 203,800 | 45,000 | 22% |
| **Slice Flip-Flops** | 407,600 | 60,000 | 14% |
| **Block RAM (36Kb)** | 445 | 120 | 27% |
| **DSP Slices** | 1,540 | 50 | 3% |
| **MMCM/PLL** | 10 | 2 | 20% |
| **I/O Banks** | 14 | 6 | 42% |
| **LVDS Pairs** | 240 | 22 | 9% |

*Tool Estimate: Based on Xilinx Vivado 2023.2 synthesis targets.*

---

## Annexure A — Requirement Traceability Matrix

| S.No | GLR-ID | Description | Source HRS Section | GLR Section | Verification Method | Status |
|:---|:---|:---|:---|:---|:---|:---|
| 1 | GLR-001 | ADC Data Interface (10GSPS) | REQ-HW-004 | 8, 9.1 | Simulation / Signal Integrity | Open |
| 2 | GLR-002 | Gain Control (DSA) | REQ-HW-012 | 9.2 | Test | Open |
| 3 | GLR-003 | Clock Distribution | REQ-HW-015 | 9.4 | Test | Open |
| 4 | GLR-004 | Serial Control Interface | REQ-HW-005 | 9.3, 11 | Test | Open |
| 5 | GLR-005 | Power Consumption/Thermal | REQ-HW-006 | 12, 9.5 | Measurement | Open |
| 6 | GLR-006 | Environmental Compliance | REQ-HW-007 | 4 | Review | Open |
| 7 | GLR-007 | FPGA Specification | REQ-HW-010 | 6 | Review | Open |
| 8 | GLR-008 | Configuration Memory | REQ-HW-017 | 9.6 | Demonstration | Open |