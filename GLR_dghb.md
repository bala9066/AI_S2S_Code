
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
| :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | 0V01 | 16.04.2026 | - | - | Initial Version |

---

## 1. Scope of the Document
This document explains the IO details and functional requirements of the FPGA for **dghb**. It serves as the bridge between the Hardware Requirements Specification (HRS) / Netlist and the RTL Design phase.

**Target Audience:** Hardware Design Team, FPGA Firmware Engineers, and System Integration Engineers.

---

## 2. References

### 2.1 External
| Doc. Type | Part No. | Description |
| :--- | :--- | :--- |
| Datasheet | GVA-123+ | DC to 18 GHz MMIC Amplifier |
| Datasheet | HMC698LP4ETR | Digital Variable Gain Amplifier, 4-8 GHz |
| Datasheet | ADC12DJ5200RFABZ | 12-Bit, 10.25 GSPS RF ADC |
| Datasheet | LMK04828BKNPT | Ultra-Low Jitter Clock Generator |
| Datasheet | TPS7A4700RGWT | 1.6V, 5A Low-Noise LDO |
| Datasheet | TPS7A3301RGWR | Negative Low-Noise LDO |
| Datasheet | ISO7740FDWR | 5 kV RMS Triple-Channel Digital Isolator |
| Datasheet | BQ25895RTWT | Battery Charge Controller / System Power Path |
| Datasheet | TLC6C5712QDAPRQ1 | 12-Channel LED Driver |

### 2.2 Internal
| Reference | Document |
| :--- | :--- |
| [HRS] | Hardware Requirements Specification |
| [SCH] | Schematic |
| [GRS] | General Requirements Specification |
| [GDD] | General Design Document |
| [NET] | dghb Logical Netlist |

---

## 3. Acronyms and Abbreviations
| Acronym | Expansion |
| :--- | :--- |
| **ADC** | Analog-to-Digital Converter |
| **BOM** | Bill of Materials |
| **CLB** | Configurable Logic Block |
| **CPLD** | Complex Programmable Logic Device |
| **DAC** | Digital-to-Analog Converter |
| **DSP** | Digital Signal Processing |
| **EMC** | Electromagnetic Compatibility |
| **ESD** | Electrostatic Discharge |
| **FF** | Flip-Flop |
| **FIFO** | First-In-First-Out |
| **FPGA** | Field Programmable Gate Array |
| **GND** | Ground |
| **HDL** | Hardware Description Language |
| **HRS** | Hardware Requirements Specification |
| **I2C** | Inter-Integrated Circuit |
| **IO** | Input/Output |
| **JTAG** | Joint Test Action Group |
| **LED** | Light Emitting Diode |
| **LVDS** | Low-Voltage Differential Signaling |
| **LUT** | Look-Up Table |
| **LDO** | Low Dropout Regulator |
| **PCB** | Printed Circuit Board |
| **PLL** | Phase-Locked Loop |
| **POR** | Power-On Reset |
| **RF** | Radio Frequency |
| **RTL** | Register Transfer Level |
| **SPI** | Serial Peripheral Interface |
| **UART** | Universal Asynchronous Receiver-Transmitter |
| **VCC** | Voltage Common Collector |
| **VGA** | Variable Gain Amplifier |

---

## 4. Module Overview

### **RF SECTION:**
The RF chain processes signals from 5 GHz to 18 GHz.
1.  **Input Protection (F1):** GBLC03LC ESD protector.
2.  **LNA (U1):** GVA-123+ provides ~23.5 dB gain across the band.
3.  **VGA (U2):** HMC698LP4 provides fine gain control (-10 to +22 dB) via SPI.
4.  **ADC (U3):** ADC12DJ5200RF digitizes the IF/RF signal at up to 5.2 GSPS (Dual Mode).

### **DIGITAL SECTION:**
The digital section (Assumed **Kintex-7 / Zynq UltraScale+** class device based on JESD204B requirements) performs:
1.  **JESD204B Interface:** Receives high-speed serialized data from the ADC (U3) via LVDS lanes (J2).
2.  **Clock Control:** Configures the LMK04828 (U4/U5) clock generator via SPI to ensure jitter <200fs.
3.  **Gain Control:** Adjusts HMC698LP4 (U2) gain via SPI.
4.  **System Monitoring:** Controls LED driver (U13) and manages Power Path (U12) via GPIO/SPI.

### **POWER SUPPLY SECTION:**
The system operates from a 3.3V main rail (U12 BQ25895).
1.  **LDOs:**
    *   **U6 (TPS7A4700):** Generates 1.8V for ADC I/O and Clock I/O.
    *   **U7 (TPS7A4700):** Generates 1.0V for ADC Core.
    *   **U8 (TPS7A3301):** Generates -1.8V for analog biasing (if required).
2.  **Sequencing:** The FPGA must monitor the PGOOD signals (implied by LDO enable logic) to enable the ADC and Clock chips in the correct order.

---

## 5. Features
*   **FPGA:** Xilinx Kintex-7 (XC7K325T-FFG900) *Assumed for JESD204B capability matching ADC12DJ5200RF*.
*   **On-board Clock Generator:** LMK04828 (dual PLL, JESD204B SYSREF generation).
*   **Communication Interfaces:**
    *   **UART:** 115200 bps (configurable up to 12 Mbps) for Control/Status.
    *   **SPI Master:** 3 independent buses for VGA (HMC698LP4), Clock (LMK04828), and ADC configuration.
*   **High Speed Interface:** JESD204B/C ( subclass 1) from ADC12DJ5200RF.
*   **Power Management:** TPS7A4700/TPS7A3301 LDO control rails; Sequencing logic.
*   **Indicator LEDs:** Controlled via TLC6C5712 LED Driver (Status, Clock Lock, Error).
*   **RF Control:** Integrated gain control via HMC698LP4 SPI.
*   **Input Protection:** ESD protection up to +10 dBm.

---

## 6. FPGA Description
**Device Selection:** **Xilinx XC7K325T-FFG900I** (Industrial Grade, -40 to +100C)
*Rationale:* The ADC12DJ5200RF requires a JESD204B PHY capable of handling line rates up to 12.5 Gbps per lane. The Kintex-7 GTP transceivers are ideally suited for this interface with supported rates up to 12.5 Gbps. The device offers sufficient logic (326K cells) to deserialize, process, and packetize the RF data.

| S.NO | PARAMETERS | SPECIFICATION |
|:---|:---|:---|
| 1 | Part Number | XC7K325T-FFG900I |
| 2 | Logic Cells | 326,080 |
| 3 | CLB Flip-Flops | 407,200 |
| 4 | Number of Gates | ~5 Million (ASIC equiv.) |
| 5 | Maximum Distributed RAM (Kb) | 520 |
| 6 | Total Block RAM (Kb) | 16,890 (445 x 36Kb) |
| 7 | Maximum Single-Ended I/Os | 500 |
| 8 | Maximum DSP Slices | 840 |
| 9 | No of IO Bank | 14 (Select banks support VCCO 1.8V/3.3V) |

---

## 7. Block Diagram
(Reference to dghb Block Diagram):
The system comprises an RF Chain (U1/U2) feeding the ADC (U3). The FPGA sits downstream of the ADC (via J2) and controls the Clock Gen (U4/U5) and VGA (U2) via Isolated SPI (U10/U11). Power is managed by U12/U6/U7/U8.

---

## 8. Pinout Details

**Table: FPGA Pin Out Details**
*Note: Pins mapped to logical signals from Netlist. Physical pin numbers (e.g., E12, A15) are [specify] pending PCB Layout.*

| S.No | Signal Name | Pin No | Voltage Level | Direction wrt FPGA | Source | Destination | Default Condition | Voltage Standard |
|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| **Power** |
| 1 | VCCO_1V8 | - | 1.8V | Input | LDO U6 | FPGA Bank 16 | - | - |
| 2 | VCCO_3V3 | - | 3.3V | Input | LDO U12 | FPGA Bank 15 | - | - |
| **Clocking** |
| 3 | FPGA_CLK_125M | [specify] | 1.8V | Input | Oscillator | FPGA MGTHXCP | HIGH | LVDS |
| **JTAG** |
| 4 | TCK | [specify] | 3.3V | Input | Debugger | FPGA | PullDown | LVCMOS33 |
| 5 | TDI | [specify] | 3.3V | Input | Debugger | FPGA | PullDown | LVCMOS33 |
| 6 | TDO | [specify] | 3.3V | Output | FPGA | Debugger | HIGH_Z | LVCMOS33 |
| 7 | TMS | [specify] | 3.3V | Input | Debugger | FPGA | PullUp | LVCMOS33 |
| **Reset & Init** |
| 8 | FPGA_RESET_N | [specify] | 3.3V | Input | Button | FPGA | PullUp | LVCMOS33 |
| 9 | DONE | [specify] | 1.8V | Output | FPGA | LED | OpenDrain | LVCMOS18 |
| **High Speed JESD204B (ADC Interface)** |
| 10 | LVSD_TX0_P | [specify] | 1.8V (Diff) | Input | ADC U3 | FPGA GTP | HIGH | LVDS_1V8 |
| 11 | LVSD_TX0_M | [specify] | 1.8V (Diff) | Input | ADC U3 | FPGA GTP | HIGH | LVDS_1V8 |
| 12 | LVSD_TX1_P | [specify] | 1.8V (Diff) | Input | ADC U3 | FPGA GTP | HIGH | LVDS_1V8 |
| 13 | LVSD_TX1_M | [specify] | 1.8V (Diff) | Input | ADC U3 | FPGA GTP | HIGH | LVDS_1V8 |
| 14 | LVSD_TX2_P | [specify] | 1.8V (Diff) | Input | ADC U3 | FPGA GTP | HIGH | LVDS_1V8 |
| 15 | LVSD_TX2_M | [specify] | 1.8V (Diff) | Input | ADC U3 | FPGA GTP | HIGH | LVDS_1V8 |
| 16 | LVSD_TX3_P | [specify] | 1.8V (Diff) | Input | ADC U3 | FPGA GTP | HIGH | LVDS_1V8 |
| 17 | LVSD_TX3_M | [specify] | 1.8V (Diff) | Input | ADC U3 | FPGA GTP | HIGH | LVDS_1V8 |
| 18 | LVSD_SYSREF_P | [specify] | 1.8V (Diff) | Input | Clock U4 | FPGA | HIGH | LVDS_1V8 |
| 19 | LVSD_SYSREF_M | [specify] | 1.8V (Diff) | Input | Clock U4 | FPGA | HIGH | LVDS_1V8 |
| **UART (Control Interface)** |
| 20 | UART_TX | [specify] | 3.3V | Output | FPGA | ISO7740 U10 | HIGH | LVCMOS33 |
| 21 | UART_RX | [specify] | 3.3V | Input | ISO7740 U10 | FPGA | HIGH | LVCMOS33 |
| **SPI Bus 0 (VGA & Clock - Isolated)** |
| 22 | SPI_SCLK_CTRL | [specify] | 3.3V | Output | FPGA | ISO7740 U10 | LOW | LVCMOS33 |
| 23 | SPI_SDIO_CTRL | [specify] | 3.3V | BiDir | FPGA | ISO7740 U10 | HIGH_Z | LVCMOS33 |
| 24 | SPI_CS0 | [specify] | 3.3V | Output | FPGA | ISO7740 U10 (To U4) | HIGH | LVCMOS33 |
| 25 | SPI_CS1 | [specify] | 3.3V | Output | FPGA | ISO7740 U11 (To U2) | HIGH | LVCMOS33 |
| **SPI Bus 1 (ADC - Non-isolated)** |
| 26 | SPI_CS_ADC | [specify] | 3.3V | Output | FPGA | ADC U3 | HIGH | LVCMOS33 |
| 27 | ADC_SDIO | [specify] | 1.8V | BiDir | FPGA | ADC U3 | HIGH_Z | LVCMOS18 |
| 28 | ADC_SCLK | [specify] | 1.8V | Output | FPGA | ADC U3 | LOW | LVCMOS18 |
| **I2C (PMIC - Aux)** |
| 29 | PMIC_SCL | [specify] | 3.3V | BiDir | FPGA | PMIC/EEPROM | HIGH_Z | I2C_3V3 |
| 30 | PMIC_SDA | [specify] | 3.3V | BiDir | FPGA | PMIC/EEPROM | HIGH_Z | I2C_3V3 |
| **GPIO / LED Control** |
| 31 | LED_STATUS | [specify] | 3.3V | Output | FPGA | LED Driver U13 | LOW | LVCMOS33 |
| 32 | LED_LOCK | [specify] | 3.3V | Output | FPGA | LED Driver U13 | LOW | LVCMOS33 |
| 33 | LED_ERROR | [specify] | 3.3V | Output | FPGA | LED Driver U13 | LOW | LVCMOS33 |
| 34 | PGOOD_ADC | [specify] | 3.3V | Input | LDO U7 | FPGA | LOW | LVCMOS33 |
| 35 | PGOOD_CLK | [specify] | 3.3V | Input | LDO U8 | FPGA | LOW | LVCMOS33 |
| 36 | POWER_EN | [specify] | 3.3V | Output | FPGA | PMIC U12 | LOW | LVCMOS33 |

---

## 9. Functional Specifications

### 9.1 Serial Communication Interface (Control)
- **Interface:** UART
- **Physical Layer:** RS-422 (via ISO7740FDWR isolation to connector J3)
- **Baud Rate:** 115200 bps default (configurable to 921600 bps)
- **Frame:** 8N1 (1 start, 8 data, 1 stop, no parity)
- **Protocol:** Register-based Read/Write (See Section 11)

### 9.2 High Speed Communication Interface
- **Interface:** JESD204B/C Subclass 1
- **Lanes:** 4 Lanes (LVSD_TX[3:0]_P/M)
- **Data Rate:** 10.0 Gbps per lane (configured via LMK04828/ADC SPI)
- **Protocol:** JESD204B (Frame size = 4 bytes, F=2, K=32, M=4)
- **Physical:** Samtec High-Speed Array (J2) to FPGA GTP pins.

### 9.3 Power On/Off Sequence
#### 9.3.1 Power ON Sequence
1. **3.3V Main** (U12) stabilizes -> `POWER_EN` asserted by FPGA.
2. **FPGA** receives `VCCO_3V3` and `VCCO_1V8`.
3. **FPGA** Init Complete -> `DONE` pin high.
4. **FPGA** enables **LDOs (U6, U7, U8)**.
5. Wait for `PGOOD_ADC` and `PGOOD_CLK` to be HIGH.
6. **FPGA** configures **LMK04828 (U4)** via SPI.
7. **FPGA** waits for `LED_LOCK` (LMK04828 Status) -> Stable.
8. **FPGA** configures **ADC12DJ5200RF (U3)** via SPI.
9. **System Ready**: Link establishes.

#### 9.3.2 Mode Configuration
| Mode | Signal | Value | Description |
|:---|:---|:---|:---|
| Normal | MODE[1:0] | 2'b00 | Standard RX Operation |
| BIST | MODE[1:0] | 2'b01 | ADC Test Pattern Mode |
| Sleep | MODE[1:0] | 2'b10 | Power Down RF Chain |

### 9.4 Supply Voltage, Current & Temperature Monitoring
- **Mechanism:** FPGA monitors internal XADC (VCCINT, VCCAUX) and external PGOOD signals.
- **Thermal:** Alert from internal temperature sensor.
- **Power Budget:** Total consumption 30-50W. Alerts triggered if internal FPGA temp > 100°C.

### 9.5 Flash & Interfaces
- **Note:** No dedicated configuration Flash shown in Netlist (implies Slave Serial or JTAG configuration).
- **Storage:** Not applicable (No NAND/NOR Flash in BOM). System configuration is volatile unless utilizing BQ25895 NVRAM or ADC internal memory for calibration.

### 9.6 RF Configuration (Gain Control)
- **Target:** HMC698LP4 (U2).
- **Interface:** SPI Bus 1 (Isolated via ISO7740 U11).
- **Control:** FPGA writes 8-bit Gain Index to register `0x0840` (See Section 10).
- **Gain Map:** 0-31dB (Steps of 1dB).

### 9.7 FPGA Remote Programming
- **Protocol:** JTAG via boundary scan header (preliminary).
- **Firmware:** UART Bootloader (Not implemented in V01).

### 9.8 Phase Shifter Controlling
- **N/A:** No digital phase shifter in BOM.

### 9.9 Beam Steering Calculation
- **N/A:** Single channel receiver.

### 9.10 Clock Generation Control
- **Target:** LMK04828 (U4).
- **Interface:** SPI Bus 0 (Isolated via ISO7740 U10).
- **Configuration:** FPGA writes PLL Divider N, R values to achieve desired sampling rate (e.g., 5.0 GHz).

---

## 10. Software Register Address Map

### 10.1 Register Base Addresses

| Block Name | Base Address | Address Range | Description |
|:---|:---|:---|:---|
| System / Identification | 0x0000 | 0x0000–0x00FF | Board ID, firmware version, reset |
| UART Control | 0x0100 | 0x0100–0x01FF | Baud rate, status |
| JESD204B Control | 0x0200 | 0x0200–0x02FF | Link status, enable, error count |
| SPI (Clock/VGA) | 0x0300 | 0x0300–0x03FF | SPI Master 0 Command/Data |
| SPI (ADC) | 0x0400 | 0x0400–0x04FF | SPI Master 1 Command/Data |
| GPIO / LEDs | 0x0500 | 0x0500–0x05FF | LED control, Status inputs |
| RF Control | 0x0800 | 0x0800–0x08FF | VGA Gain Table, Attenuation |
| ADC Metadata | 0x0900 | 0x0900–0x09FF | Sample rate, decimation factor |
| Diagnostics | 0x0A00 | 0x0A00–0x0AFF | Fault log, uptime |

### 10.2 Detailed Register Map

**Block 0x0000 — System / Identification**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|:---|:---|:---|:---|:---|:---|
| 0x00 | BOARD_ID | 16 | R | 0xDGH0 | Board identification code |
| 0x01 | FW_VERSION | 16 | R | 0x0001 | Firmware Version (0.1) |
| 0x02 | SYS_STATUS | 16 | R | 0x0000 | [15:3] Reserved, [2] PGOOD_CLK, [1] PGOOD_ADC, [0] READY |
| 0x03 | SYS_CTRL | 16 | R/W | 0x0000 | [0] SOFT_RESET, [1] LED_TEST_MODE |

**Block 0x0200 — JESD204B Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|:---|:---|:---|:---|:---|:---|
| 0x00 | LINK_CTRL | 16 | R/W | 0x0000 | [0] ENABLE, [1] RESET |
| 0x01 | LINK_STATUS | 16 | R | 0x0000 | [0] ALIGNED, [1] CODE_GRP_SYNC, [2] PLL_LOCK |
| 0x02 | LANE_ERR_CNT | 16 | R | 0x0000 | Disparity error counter [7:0] |

**Block 0x0800 — RF Control (VGA)**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|:---|:---|:---|:---|:---|:---|
| 0x40 | VGA_GAIN_INDEX | 16 | R/W | 0x0010 | Gain index (0-31). 16 = mid gain. |

**Block 0x0500 — GPIO / LEDs**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|:---|:---|:---|:---|:---|:---|
| 0x00 | LED_CTRL | 16 | R/W | 0x0000 | [2] LED_ERROR, [1] LED_LOCK, [0] LED_STATUS (1=ON) |

---

## 11. UART Register Protocol Specification

### 11.1 Physical Layer
- **Baud:** 115200 bps
- **Frame:** 8N1
- **Interface:** RS-422 (Differential)

### 11.2 Command Frame Formats

**Single Register Write (CMD = 0x57 'W'):**
```
Byte 0: 0x57 (CMD)
Byte 1: ADDR[15:8]
Byte 2: ADDR[7:0]
Byte 3: DATA[15:8]
Byte 4: DATA[7:0]
→ Response: 0x06 (ACK) / 0x15 (NAK)
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
Byte 1: ADDR[15:8]
Byte 2: ADDR[7:0]
Byte 3: N (Count)
Byte 4..: DATA Word 0, Word 1... Word N
→ Response: 0x06
```

**Bulk Register Read (CMD = 0x62 'b'):**
```
Byte 0: 0x62
Byte 1: (ADDR[15:8] | 0x80)
Byte 2: ADDR[7:0]
Byte 3: N
→ Response: DATA Word 0... Word N
```

### 11.3 Timing Constraints
| Parameter | Min | Typical | Max | Unit |
|:---|:---|:---|:---|:---|
| Inter-byte gap | - | - | 50 | ms |
| Response time | - | 1 | 5 | ms |

---

## 12. FPGA Resource Utilization Estimate

| Resource | Available | Estimated Usage | Utilization % |
|:---|:---|:---|:---|
| Slice LUTs | 203,800 | 45,000 | 22% |
| Slice Flip-Flops | 407,200 | 60,000 | 14% |
| Block RAM (36Kb) | 445 | 80 | 18% |
| DSP Slices | 840 | 20 | 2% |
| GTX/GTP Transceivers | 16 | 4 | 25% |

*Synthesis Tool:* Vivado 2024.1
*Target Device:* XC7K325T-FFG900I

---

## Annexure A — Requirement Traceability Matrix

| S.No | GLR-ID | Description | Source HRS Section | GLR Section | Verification Method | Status |
|:---|:---|:---|:---|:---|:---|:---|
| 1 | GLR-001 | RF Input 5-18 GHz | HRS §3.1 | 4.0 RF Section | Test | Open |
| 2 | GLR-002 | ADC 4-8 GSPS Interface | HRS §3.2 | 9.2 HS Interface | Test | Open |
| 3 | GLR-003 | Power Sequencing (30-50W) | HRS §3.2/3.4 | 9.3 Power Seq | Test | Open |
| 4 | GLR-004 | 3.3V Supply Interface | HRS §3.2 | 8.0 Pinout | Inspection | Open |
| 5 | GLR-005 | LVDS Output Interface | HRS §3.3 | 8.0 Pinout | Test | Open |
| 6 | GLR-006 | Control Interface (SPI/UART) | HRS §3.3 | 9.1 / 11 | Test | Open |
| 7 | GLR-007 | Temp Range -40 to +85 | HRS §3.4 | 6.0 FPGA Spec | Analysis | Open |
| 8 | GLR-008 | JESD204B Implementation | HRS §3.3 | 9.2 | Test | Open |
| 9 | GLR-009 | Gain Control SPI | HRS §3.3 | 9.6 | Test | Open |
| 10 | GLR-010 | Register Map Def | HRS §3.3 | 10.0 | Inspection | Open |
| 11 | GLR-011 | Phase Noise (<200fs) | HRS §3.2 | 9.10 | Test | Open |
| 12 | GLR-012 | Resource Budget | HRS §3.2 | 12.0 | Analysis | Open |