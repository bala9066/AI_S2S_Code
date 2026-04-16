
# Glue Logic Requirements (GLR)

## Document Control
| Document Title | Glue Logic Requirements |
| :--- | :--- |
| **Project Name** | **dsf** |
| **Version Date** | 16.04.2026 |
| **Version Number** | 0V01 |
| **Prepared By** | Name: AI Expert. Sign: ________________ |
| **Document Review By** | Name: . Sign: ________________ |

---

## Amendments to the Document
| S. No | Ver. No. | Ver. Date | Changed By | Section(s) Changed | Description of Change |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | 0V01 | 16.04.2026 | - | - | Initial Release |

---

## 1. Scope of the Document
This document defines the input/output (I/O) characteristics, pinout details, and functional requirements of the digital logic and FPGA components for the **dsf** project.

The dsf project is a 5–18 GHz Wideband RF Receiver. This GLR bridges the Hardware Requirements Specification (HRS) and the FPGA HDL Design phase. It details the interfaces between the high-speed ADC (ADC10DX300), the RF front-end control logic, and the back-end digital output.

**Target Audience:** FPGA Design Engineers, Hardware Engineers, and Systems Engineers.

---

## 2. References

### 2.1 External
| Doc. Type | Part No. | Description | Manufacturer |
| :--- | :--- | :--- | :--- |
| Datasheet | **ADC10DX300** | 10-Bit, 10-GSPS RF Sampling ADC | Texas Instruments |
| Datasheet | **LMX2594** | Wideband PLLATINUM Synthesizer | Texas Instruments |
| Datasheet | **HMC698LP2** | Digital Variable Gain Amplifier (VGA) | Analog Devices |
| Datasheet | **HMC1048LC4** | Double-Balanced Mixer | Analog Devices |
| Datasheet | **ADA4817-1** | 1 GHz Low Noise Op-Amp | Analog Devices |
| Datasheet | **LTM4644IY** | Quad 4A DC/DC Switching Regulator | Analog Devices |
| Datasheet | **LT3045** | Ultralow Noise Linear Regulator | Analog Devices |
| Datasheet | **GBDS04-24SLC** | ESD Protection Diode | ProTek Devices |

### 2.2 Internal
| Reference | Document Title |
| :--- | :--- |
| [HRS] | Hardware Requirements Specification (dsf) |
| [SCH] | Schematic Capture (dsf_RevA) |
| [GRS] | General Requirements Specification |
| [GDD] | General Design Document |

---

## 3. Acronyms and Abbreviations
| Acronym | Expansion |
| :--- | :--- |
| **ADC** | Analog to Digital Converter |
| **AGC** | Automatic Gain Control |
| **BGA** | Ball Grid Array |
| **BW** | Bandwidth |
| **CLK** | Clock |
| **CPCI** | Compact Peripheral Component Interconnect |
| **DAC** | Digital to Analog Converter |
| **dB** | Decibel |
| **dBc** | Decibel relative to carrier |
| **dBFS** | Decibel relative to Full Scale |
| **EMC** | Electromagnetic Compatibility |
| **EMI** | Electromagnetic Interference |
| **ESD** | Electrostatic Discharge |
| **FCC** | Federal Communications Commission |
| **FIFO** | First In First Out |
| **FPGA** | Field Programmable Gate Array |
| **FS** | Full Scale |
| **GBPS** | Gigabits Per Second |
| **GND** | Ground |
| **GPIO** | General Purpose Input Output |
| **HRS** | Hardware Requirement Specification |
| **I2C** | Inter-Integrated Circuit |
| **IF** | Intermediate Frequency |
| **JESD** | JESD204 Standard (JEDEC Standard) |
| **LDO** | Low Dropout Regulator |
| **LO** | Local Oscillator |
| **LUT** | Look Up Table |
| **LNA** | Low Noise Amplifier |
| **LVDS** | Low Voltage Differential Signaling |
| **NF** | Noise Figure |
| **PCB** | Printed Circuit Board |
| **P1dB** | 1 dB Compression Point |
| **PLL** | Phase Locked Loop |
| **QFN** | Quad Flat No-leads package |
| **RF** | Radio Frequency |
| **SFDR** | Spurious Free Dynamic Range |
| **SNR** | Signal to Noise Ratio |
| **SPI** | Serial Peripheral Interface |
| **UART** | Universal Asynchronous Receiver Transmitter |
| **VCC** | Voltage Common Collector |
| **VCO** | Voltage Controlled Oscillator |
| **VGA** | Variable Gain Amplifier |
| **VSWR** | Voltage Standing Wave Ratio |

---

## 4. Module Overview

The dsf receiver module is designed to capture and digitize RF signals from 5 GHz to 18 GHz with an instantaneous bandwidth of 3 GHz.

### RF SECTION
The RF chain comprises a Wideband LNA (**HMC698LP4E**) followed by a Downconverter Mixer (**HMC1048LC4**) which mixes the RF input with a Local Oscillator (LO) from the **LMX2594** synthesizer. The IF output is filtered and conditioned by a VGA (**HMC698LP2**) for gain control and an IF Amplifier (**ADA4817-1**) before digitization. ESD protection is provided by **GBDS04-24SLC** diodes.

### DIGITAL SECTION
The core of the digital section is the **ADC10DX300**, a 10-bit, 10 GSPS ADC digitizing the conditioned IF signal. It outputs data via a JESD204B interface (Lane rates ~10 Gbps). An FPGA (or high-speed interface logic) manages the **SPI_SCLK**, **SPI_SDIO**, and **SPI_CS_L** lines to configure the VGA gain, Synthesizer frequency, and ADC internal registers. A UART interface provides external control for gain settings, frequency tuning, and status monitoring.

### POWER SUPPLY SECTION
The system is powered by a +12V input. A **LTM4644IY** DC-DC converter generates +5V (RF blocks) and +3.3V (Digital logic). **LT3045** and **LT3094** LDOs provide ultra-low noise rails for the analog sections (+3.3V_Analog) and the ADC core (+1.2V).

---

## 5. Features
*   **RF Input:** 5-18 GHz operation via SMA connector.
*   **Digitization:** 10-bit, 10 GSPS sampling using TI **ADC10DX300**.
*   **Digital Output:** High-speed JESD204B / LVDS outputs.
*   **LO Generation:** **LMX2594** PLL for precise frequency synthesis.
*   **Gain Control:** 42 dB range digital VGA (**HMC698LP2**) via SPI.
*   **Protection:** Input ESD protection and limiter circuitry.
*   **Power Efficiency:** Multi-rail DC-DC conversion with LDO post-regulation for low noise.
*   **Temperature:** Military temperature range (-55°C to +125°C) components selected.
*   **Control Interface:** SPI (for RF components) and UART (for system control).
*   **Synchronization:** JESD204B SYNC signal for lane alignment.

---

## 6. FPGA Description
*Note: The design implies high-speed interface logic or an FPGA capable of handling JESD204B / 10 Gbps LVDS. The following specification assumes a high-end Xilinx Kintex Ultrascale or similar device is used to buffer the JESD204B lanes and handle control logic.*

| S.NO | PARAMETERS | SPECIFICATION |
| :--- | :--- | :--- |
| 1 | Part Number | **Xilinx Kintex UltraScale XCKU115** (Example for glue logic feasibility) |
| 2 | Logic Cells | ~663,000 |
| 3 | CLB Flip-Flops | ~1,326,000 |
| 4 | Number of Gates | > 10 Million |
| 5 | Maximum Distributed RAM (Kb) | ~2,600 |
| 6 | Total Block RAM (Kb) | ~37,000 |
| 7 | Maximum Single-Ended I/Os | 520 |
| 8 | Maximum DSP Slices | 5,520 |
| 9 | No of IO Bank | 14 (Configurable for various voltages) |

---

## 7. Block Diagram
(Reference to block diagram — described in text)
The signal flows from the RF Input -> ESD Protection -> LNA -> Mixer -> IF Amp -> VGA -> ADC. The ADC output flows via LVDS lanes to the Digital Output Connector. Control signals (SPI/UART) interface between the Digital Connector and the RF components.

---

## 8. Pinout Details

**Table: FPGA / Interface Pin Out Details**

| S.No | Signal Name | Pin No (Ref) | Voltage Level | Direction wrt FPGA | Source | Destination | Default Condition | Voltage Standard |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | VDD_FPGA | - | +1.0V | Power In | LDO | FPGA Core | On | - |
| 2 | VCCO_3V3 | - | +3.3V | Power In | LTM4644 | FPGA IO Banks | On | - |
| 3 | GND | - | 0V | Ground | GND Plane | All | - | - |
| 4 | ADC_CLK_P | - | 1.8V | Input | LMX2594 | ADC (CLK_P) | Clock | LVDS / CML |
| 5 | ADC_CLK_N | - | 1.8V | Input | LMX2594 | ADC (CLK_N) | Clock | LVDS / CML |
| 6 | JESD_TX_P[0] | - | 1.8V (VDDIO) | Output | ADC | FPGA JESD IP | Data | LVDS |
| 7 | JESD_TX_N[0] | - | 1.8V (VDDIO) | Output | ADC | FPGA JESD IP | Data | LVDS |
| 8 | JESD_TX_P[1] | - | 1.8V (VDDIO) | Output | ADC | FPGA JESD IP | Data | LVDS |
| 9 | JESD_TX_N[1] | - | 1.8V (VDDIO) | Output | ADC | FPGA JESD IP | Data | LVDS |
| 10 | JESD_TX_P[2] | - | 1.8V (VDDIO) | Output | ADC | FPGA JESD IP | Data | LVDS |
| 11 | JESD_TX_N[2] | - | 1.8V (VDDIO) | Output | ADC | FPGA JESD IP | Data | LVDS |
| 12 | JESD_TX_P[3] | - | 1.8V (VDDIO) | Output | ADC | FPGA JESD IP | Data | LVDS |
| 13 | JESD_TX_N[3] | - | 1.8V (VDDIO) | Output | ADC | FPGA JESD IP | Data | LVDS |
| 14 | SPI_SCLK | - | +3.3V | Output | FPGA | LMX2594, VGA, ADC | Low | LVCMOS33 |
| 15 | SPI_SDIO | - | +3.3V | Bi-Dir | FPGA | LMX2594, VGA, ADC | High (Pull-up) | LVCMOS33 |
| 16 | SPI_CS_L | - | +3.3V | Output | FPGA | LMX2594, VGA, ADC | High | LVCMOS33 |
| 17 | VGA_CS_L | - | +3.3V | Output | FPGA | HMC698LP2 (CS) | High | LVCMOS33 |
| 18 | SYNTH_CS_L | - | +3.3V | Output | FPGA | LMX2594 (CS) | High | LVCMOS33 |
| 19 | ADC_CS_L | - | +3.3V | Output | FPGA | ADC10DX300 (CS) | High | LVCMOS33 |
| 20 | UART_TX | - | +3.3V | Output | FPGA | UART Transceiver | High | LVCMOS33 |
| 21 | UART_RX | - | +3.3V | Input | UART Transceiver | FPGA | High | LVCMOS33 |
| 22 | UART_CTS | - | +3.3V | Input | UART Transceiver | FPGA | High | LVCMOS33 |
| 23 | UART_RTS | - | +3.3V | Output | FPGA | UART Transceiver | High | LVCMOS33 |
| 24 | FPGA_RESET_N | - | +3.3V | Input | System Reset | FPGA | High (Pull-up) | LVCMOS33 |
| 25 | FPGA_DONE | - | +3.3V | Output | FPGA Internal | LED/Status | Low (Until Done) | LVCMOS33 |
| 26 | FPGA_INIT_N | - | +3.3V | Output | FPGA Internal | System Controller | Low | LVCMOS33 |
| 27 | TEMP_ALERT | - | +3.3V | Input | Temp Sensor | FPGA | Low | LVCMOS33 |
| 28 | PWR_GOOD | - | +3.3V | Input | PMIC | FPGA | High | LVCMOS33 |
| 29 | LED_STATUS | - | +3.3V | Output | FPGA | LED (Green) | Low | LVCMOS33 |
| 30 | LED_ERROR | - | +3.3V | Output | FPGA | LED (Red) | Low | LVCMOS33 |
| 31 | TRP | - | +3.3V | Output | FPGA | RF Front End Ctrl | Low | LVCMOS33 |
| 32 | GPIO_1 | - | +3.3V | Input/Output | Ext Connector | FPGA | High | LVCMOS33 |
| 33 | GPIO_2 | - | +3.3V | Input/Output | Ext Connector | FPGA | High | LVCMOS33 |
| 34 | JTAG_TCK | - | +3.3V | Input | Debugger | FPGA JTAG | High | LVCMOS33 |
| 35 | JTAG_TDI | - | +3.3V | Input | Debugger | FPGA JTAG | High | LVCMOS33 |
| 36 | JTAG_TDO | - | +3.3V | Output | FPGA JTAG | Debugger | High | LVCMOS33 |
| 37 | JTAG_TMS | - | +3.3V | Input | Debugger | FPGA JTAG | High | LVCMOS33 |
| 38 | SYNC_N | - | +3.3V | Bi-Dir | FPGA | ADC10DX300 (SYNC) | High | LVCMOS33 |

---

## 9. Functional Specifications

| S.No. | Function Name | Description |
| :--- | :--- | :--- |
| 1 | **JESD204B Interface** | Capture 10-bit ADC data at 10 GSPS via 4-lane JESD204B interface. |
| 2 | **SPI Control Bus** | Tri-stateable SPI bus to control VGA Gain, Synthesizer Frequency, and ADC Config. |
| 3 | **UART Command Interface** | Asynchronous serial interface for host control (Set Freq, Set Gain, Get Status). |
| 4 | **Gain Control (AGC)** | Digital control of HMC698LP2 VGA via SPI (0 to 42 dB range). |
| 5 | **LO Frequency Tuning** | Programming of LMX2594 PLL via SPI for 5-18 GHz downconversion. |
| 6 | **Power Sequencing** | Monitoring PWR_GOOD and TEMP_ALERT to enable/disable RF chain. |
| 7 | **System Diagnostics** | Real-time monitoring of ADC Over-range, PLL Lock, and Temperature. |
| 8 | **Data Formatting** | Packing of 10-bit ADC data into 32-bit/64-bit words for transmission. |
| 9 | **Remote Update** | FPGA configuration update via UART (MCS/JTAG indirect). |

### 9.1 JESD204B Interface
*   **Standard:** JESD204B Subclass 1.
*   **Lanes:** 4 lanes.
*   **Lane Rate:** 10 Gbps (configured via FPGA GTX transceivers).
*   **M (Bits per Sample):** 10 bits (ADC10DX300 output).
*   **L (Lanes):** 4.
*   **F (Octets per Frame):** 4 (Configurable).
*   **SYNC\_N:** Bi-directional synchronization signal managed by FPGA IP core.

### 9.2 Serial Peripheral Interface (SPI)
*   **Type:** Mode 0 (CPOL=0, CPHA=0) or Mode 3 (CPOL=1, CPHA=1), configurable.
*   **Max Frequency:** 20 MHz (limited by VGA/Synthesizer).
*   **Topologies:**
    *   **VGA (HMC698LP2):** 8-bit register map for gain setting (1dB steps).
    *   **Synthesizer (LMX2594):** Multi-register write for frequency/internally generated dividers.
    *   **ADC (ADC10DX300):** Configuration registers for JESD204B link parameters.
*   **Chip Selects:** Dedicated GPIOs for CS\_VGA, CS\_SYNTH, CS\_ADC. Driven active Low.

### 9.3 Serial Communication Interface (UART)
*   **Physical Layer:** RS-422 (Differential) for noise immunity in military environments.
*   **Baud Rate:** 3.0 Mbps (default) or 115.2 Mbps.
*   **Frame:** 8 Data bits, 1 Stop bit, No Parity (8N1).
*   **Purpose:** Host sends commands (e.g., "SET_FREQ 11500") and receives responses ("ACK").

### 9.4 RF Gain Control
*   **Range:** 0 to 42 dB.
*   **Resolution:** 1 dB.
*   **Device:** HMC698LP2.
*   **Interface:** SPI Register Write.
*   **Equation:** Gain (dB) = SPI\_Data\_Value (where Data is 0x00 to 0x2A).
*   **Behavior:** FPGA calculates SPI data based on requested gain from UART and writes to VGA.

### 9.5 LO Frequency Synthesis
*   **Device:** LMX2594.
*   **Output Range:** 5-18 GHz (Actual LO depends on IF, e.g., RF - IF).
*   **SPI Control:** FPGA writes to MUXOUT, CALIB, and INT/FRAC registers.
*   **Lock Detect:** FPGA reads MUXOUT (converted to GPIO) to verify PLL_LOCK before asserting RF_ENABLE.

### 9.6 Power Supply Monitoring
*   **Inputs:** PWR_GOOD (from PMIC), TEMP_ALERT (from thermal sensor).
*   **Action:**
    *   If PWR_GOOD = Low, FPGA asserts RESET\_N, disables VGA.
    *   If TEMP_ALERT = High, FPGA reduces VGA gain to minimum (Safe State).

### 9.7 High Speed Data Output
*   **Protocol:** The FPGA receives raw JESD204B data, de-encapsulates it to 10-bit samples, and buffers it.
*   **Output:** Data is transmitted out via a high-speed connector (e.g., or buffered LVDS for downstream processing).

### 9.8 SPI Flash Configuration
*   **Flash:** Configuration Flash (SPI) for FPGA bitstream storage.
*   **Fallback:** If Master SPI mode fails, JTAG fallback is supported.

---

## 10. Software Register Address Map

### 10.1 Register Base Addresses

| Block Name | Base Address | Address Range | Description |
| :--- | :--- | :--- | :--- |
| **System / ID** | 0x0000 | 0x0000–0x00FF | Board ID, Firmware Version, Status Register |
| **UART Control** | 0x0100 | 0x0100–0x01FF | Baud Rate, FIFO Levels, IRQ Enable |
| **SPI Control** | 0x0200 | 0x0200–0x02FF | SPI Config, TX/RX Data, CS Select |
| **JESD204B** | 0x0300 | 0x0300–0x03FF | Link Config, Lane Status, SYSREF |
| **RF Control** | 0x0400 | 0x0400–0x04FF | Gain (VGA), Freq (Synth), PA Enable |
| **Diagnostics** | 0x0500 | 0x0500–0x05FF | Temperature, Lock Status, PWR Good |
| **GPIO** | 0x0600 | 0x0600–0x06FF | GPIO Direction and Data |
| **Test / RAM** | 0x0A00 | 0x0A00–0x0AFF | Internal Loopback, BIST Memory |

### 10.2 Detailed Register Map

#### Block 0x0000 — System / Identification
| Offset | Name | Width | R/W | Reset | Description |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 0x00 | BOARD_ID | 16 | R | 0xD5F0 | 0xD5F0 = 'dsf' Project ID |
| 0x01 | FW_VERSION | 16 | R | 0x0100 | Major.Minor version (1.0) |
| 0x02 | SYS_STATUS | 16 | R | 0x0000 | [0] PLL_LOCK, [1] ADC_LOCK, [2] TEMP_OK, [3] PWR_OK |
| 0x03 | SYS_CTRL | 16 | R/W | 0x0000 | [0] SOFT_RESET, [1] RF_ENABLE |

#### Block 0x0100 — UART Control
| Offset | Name | Width | R/W | Reset | Description |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 0x00 | BAUD_DIV | 16 | R/W | 0x0003 | Divisor for Baud Rate (Clk/16/Baud) |
| 0x01 | UART_CTRL | 16 | R/W | 0x0000 | [0] TX_EN, [1] RX_EN, [2] PARITY_EN |
| 0x02 | UART_STAT | 16 | R | 0x0000 | [0] TX_BUSY, [1] RX_READY, [2] OVERRUN |
| 0x03 | TX_DATA | 16 | W | 0x0000 | Write to transmit |
| 0x04 | RX_DATA | 16 | R | 0x0000 | Read received byte |

#### Block 0x0200 — SPI Control
| Offset | Name | Width | R/W | Reset | Description |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 0x00 | SPI_DIV | 16 | R/W | 0x0014 | SCLK Divider |
| 0x01 | SPI_CTRL | 16 | R/W | 0x0000 | [0] CPOL, [1] CPHA, [2] AUTO_CS |
| 0x02 | SPI_TX | 16 | W | 0x0000 | Transmit Data Register |
| 0x03 | SPI_RX | 16 | R | 0x0000 | Receive Data Register |
| 0x04 | CS_SELECT | 16 | R/W | 0x0000 | [0] CS_ADC, [1] CS_SYNTH, [2] CS_VGA |

#### Block 0x0300 — JESD204B / ADC
| Offset | Name | Width | R/W | Reset | Description |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 0x00 | JESD_CTRL | 16 | R/W | 0x0000 | [0] LINK_ENABLE, [1] RESET_LINK |
| 0x01 | JESD_STAT | 16 | R | 0x0000 | [3:0] LANE_LOCK_STATUS |
| 0x02 | SUBCLASS | 16 | R/W | 0x0001 | Subclass Config (0/1) |
| 0x03 | K_VAL | 16 | R/W | 0x0010 | JESD204B K parameter (Framer) |

#### Block 0x0400 — RF Control
| Offset | Name | Width | R/W | Reset | Description |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 0x00 | RF_GAIN | 16 | R/W | 0x0000 | 0-42 dB gain code (HMC698LP2) |
| 0x01 | RF_FREQ_LO | 32 | W | 0x0000 | LO Frequency (Hz) for Synthesizer |
| 0x02 | RF_FREQ_HI | 32 | W | 0x0000 | (Upper 32 bits of 64-bit freq) |
| 0x03 | RF_STATE | 16 | R | 0x0000 | [0] TX_ENABLED, [1] RX_ENABLED |

#### Block 0x0500 — Diagnostics
| Offset | Name | Width | R/W | Reset | Description |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 0x00 | TEMP_VAL | 16 | R | 0x0000 | Temperature sensor reading (raw) |
| 0x01 | PWR_STAT | 16 | R | 0x0000 | Power Good Flags |
| 0x02 | ADC_OVR | 16 | R | 0x0000 | ADC Overrange flag |

---

## 11. UART Register Protocol Specification

This section defines the protocol for the host PC to control the FPGA/Receiver via UART.

### 11.1 Physical Layer
*   **Baud Rate:** 3.0 Mbps (default).
*   **Data:** 8 Bits.
*   **Stop:** 1 Bit.
*   **Parity:** None.

### 11.2 Frame Formats

**1. Single Register Write (CMD = 0x57 'W')**
Used to set a specific register (e.g., Gain, Frequency, Enable).
```
Byte 0: 0x57 (CMD 'W')
Byte 1: ADDR_H (Address Bits 15:8)
Byte 2: ADDR_L (Address Bits 7:0)
Byte 3: DATA_H (Data Bits 15:8)
Byte 4: DATA_L (Data Bits 7:0)
```
**Response:** `0x06` (ACK) if successful, `0x15` (NAK) if error.

**2. Single Register Read (CMD = 0x52 'R')**
Used to read status or config.
```
Byte 0: 0x52 (CMD 'R')
Byte 1: ADDR_H (Address Bits 15:8)
Byte 2: ADDR_L (Address Bits 7:0)
```
**Response:** `DATA_H, DATA_L` (2 bytes).

**3. Bulk Register Write (CMD = 0x42 'B')**
Used for frequency synth tables or multi-reg updates.
```
Byte 0: 0x42 (CMD 'B')
Byte 1: ADDR_H
Byte 2: ADDR_L
Byte 3: N (Count of registers to write, 1-32)
Byte 4...N*2: DATA pairs
```
**Response:** `0x06` (ACK) after all writes completed.

**4. Bulk Register Read (CMD = 0x62 'b')**
```
Byte 0: 0x62 (CMD 'b')
Byte 1: ADDR_H
Byte 2: ADDR_L
Byte 3: N (Count)
```
**Response:** `DATA` pairs (N * 2 bytes).

### 11.3 Timing
| Parameter | Min | Max | Unit |
| :--- | :--- | :--- | :--- |
| Inter-Byte Delay | - | 10 | ms |
| ACK Response Time | - | 5 | ms |

---

## 12. FPGA Resource Utilization Estimate

| Resource | Available (KU115) | Estimated Usage | Utilization % |
| :--- | :--- | :--- | :--- |
| **LUTs** | 663,360 | 85,000 | 12.8% |
| **Flip-Flops** | 1,326,720 | 110,000 | 8.2% |
| **Block RAM** | 36 Mb | 4.5 Mb | 12.5% |
| **DSP48E2** | 5,520 | 0 | 0% |
| **GTX / GTH** | 32 | 4 | 12.5% |
| **I/O Pins** | 520 | 45 | 8.6% |

*Note: Utilization estimates include JESD204B IP core, UART/SPI controllers, and register decoding logic.*

---

## Annexure A — Requirement Traceability Matrix

| S.No | GLR-ID | Description | Source HRS Section | GLR Section | Verification Method | Status |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | GLR-001 | RF Input Frequency Range 5-18GHz | HRS 3.1 REQ-HW-001 | 4 | Test | Open |
| 2 | GLR-002 | Instantaneous BW 3GHz | HRS 3.2 REQ-HW-002 | 9.1 | Test | Open |
| 3 | GLR-003 | Noise Figure < 8dB | HRS 3.2 REQ-HW-003 | 4 | Analysis | Open |
| 4 | GLR-004 | ADC Sample Rate 10GSPS | HRS 3.2 REQ-HW-006 | 9.1 | Test | Open |
| 5 | GLR-005 | Digital Output LVDS/JESD204B | HRS 3.3 REQ-HW-007 | 9.1 | Inspection | Open |
| 6 | GLR-006 | Operating Temp -55 to +125C | HRS 3.4 REQ-HW-009 | 4 | Test | Open |
| 7 | GLR-007 | Gain Control Range 40dB+ | HRS 3.2 REQ-HW-011 | 9.4 | Test | Open |
| 8 | GLR-008 | FCC Compliance (EMC) | HRS 3.5 REQ-HW-010 | 9.3 | Test | Open |
| 9 | GLR-009 | UART Control Interface | Derived Req | 9.3, 11 | Test | Open |
| 10 | GLR-010 | FPGA Register Map | Derived Req | 10 | Inspection | Open |
| 11 | GLR-011 | Phase Noise < -100dBc/Hz | HRS 3.2 REQ-HW-014 | 9.5 | Test | Open |
| 12 | GLR-012 | Resource Estimate | Derived Req | 12 | Analysis | Open |