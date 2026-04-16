
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
This document details the Input/Output (I/O) interfaces, functional logic requirements, and register map definitions for the **khg** Wideband RF Receiver FPGA design. It bridges the gap between the hardware netlist (P4) and the FPGA HDL implementation (P7), serving as the primary specification for signal integrity, timing constraints, and firmware driver development.

---

## 2. References

### 2.1 External
| Doc. Type | Part No. | Description |
|:---|:---|:---|
| Datasheet | **ADC12DJ5200RF** | 12-Bit, 10.4 GSPS, Dual ADC JESD204C |
| Datasheet | **LMX2594** | Wideband PLL with Integrated VCO (10-20 GHz) |
| Datasheet | **HMC698LP4** | 6-Bit Digital Attenuator, DC-20 GHz |
| Datasheet | **MWC-1440+** | IQ Mixer, 5-18 GHz |
| Datasheet | **TQM473552** | Wideband LNA 2-20 GHz |
| Datasheet | **ADA4817-1** | 1 GHz Low Noise Low Bias Current RF Op Amp |
| Datasheet | **TPS7A4700** | 36-V, 1-A, Low-Noise, Positive LDO |
| Datasheet | **LTC7151S** | 20 V Synchronous Step-Down Regulator |
| Datasheet | **TPS62913** | 2-A, D-CAP3/PSM Mode Step-Down Converter |

### 2.2 Internal
| Reference | Document |
|:---|:---|
| [HRS] | Hardware Requirements Specification (khg) |
| [SCH] | Schematic (khg_Rx_Top) |
| [GRS] | General Requirements Specification |
| [GDD] | General Design Document |

---

## 3. Acronyms and Abbreviations

| Acronym | Expansion |
|:---|:---|
| **ADC** | Analog-to-Digital Converter |
| **AGC** | Automatic Gain Control |
| **BOM** | Bill of Materials |
| **CLB** | Configurable Logic Block |
| **DAC** | Digital-to-Analog Converter |
| **DSP** | Digital Signal Processing |
| **EMC** | Electromagnetic Compatibility |
| **FPGA** | Field-Programmable Gate Array |
| **GND** | Ground Reference |
| **HDL** | Hardware Description Language |
| **I2C** | Inter-Integrated Circuit |
| **IP3** | Third-order Intercept Point |
| **JESD** | JESD204C High-Speed Data Converter Interface |
| **JTAG** | Joint Test Action Group |
| **LNA** | Low Noise Amplifier |
| **LO** | Local Oscillator |
| **LUT** | Look-Up Table |
| **LVDS** | Low-Voltage Differential Signaling |
| **NF** | Noise Figure |
| **PCB** | Printed Circuit Board |
| **PLL** | Phase-Locked Loop |
| **POR** | Power-On Reset |
| **RF** | Radio Frequency |
| **RoHS** | Restriction of Hazardous Substances |
| **RTL** | Register Transfer Level |
| **SPI** | Serial Peripheral Interface |
| **UART** | Universal Asynchronous Receiver-Transmitter |
| **VCC** | Voltage Common Collector (Supply) |
| **VGA** | Variable Gain Amplifier |

---

## 4. Module Overview

**RF SECTION:**
The RF chain comprises an **LPA-518+** Limiter for input protection up to +20 dBm, followed by a **BP5G18G-5180-SM** Bandpass Filter (5–18 GHz). Amplification is handled by the **TQM473552** LNA (+20 dB gain). Gain control is managed by the **HMC698LP4** 6-bit parallel Digital Step Attenuator (0–31.5 dB range). Frequency conversion is performed by the **MWC-1440+** IQ Demodulator, driven by the **LMX2594** PLL/VCO synthesizer (LO source). Post-mixer, the **ADA4817-1** differential amplifiers condition the IF signal before digitization.

**DIGITAL SECTION:**
The heart of the digital subsystem is the FPGA (Xilinx Kintex UltraScale+ XQRKU060-1FFVF1754E). It interfaces directly with the **ADC12DJ5200RF** via a 4-lane JESD204C Subclass 1 interface to capture digitized I/Q data at line rates up to 12.5 Gbps. The FPGA implements the JESD204C PHY and transport layer, high-speed clocks (PLL), SPI control for external RF components, and a slow-speed control UART for host communication.

**POWER SUPPLY SECTION:**
Power is input via a Molex connector (+12V DC). The **LTC7151S** DC-DC converter steps this down to +5V. A **TPS7A4700** Quad LDO generates +3.3V, +2.5V, +1.8V, and auxiliary rails. A dedicated **TPS62913** provides the +1.0V core rail for the ADC. The FPGA manages the power sequencing via enable signals and monitors health via the ADC's internal sensors and SPI/I2C telemetry.

---

## 5. Features
- **FPGA:** Xilinx XQRKU060-1FFVF1754E (Kintex UltraScale+ Radiation Tolerant)
- **High-Speed ADC:** TI ADC12DJ5200RF (12-bit, dual-channel, JESD204C Subclass 1)
- **LO Synthesis:** TI LMX2594 (Integrated VCO, 10–20 GHz output)
- **RF Control:** Analog Devices HMC698LP4 (6-bit parallel digital attenuator)
- **Data Interface:** 4-Lane JESD204C (up to 12.5 Gbps/lane) + SYSREF
- **Control Interface:** UART (3.3V LVTTL) for configuration and telemetry
- **Gain Control:** 6-bit parallel interface for fast gain setting (<10 ns switching)
- **Temperature Range:** Military (-55°C to +125°C) operation compliant
- **Power Sequencing:** Automated FPGA-controlled power-up/down sequencing

---

## 6. FPGA Description
**Selection Rationale:**
The Xilinx XQRKU060-1FFVF1754E is selected for its high-speed transceivers (capable of 12.5 Gbps required for JESD204C), radiation tolerance (critical for defense/space), and sufficient logic resources to handle real-time I/Q processing and packetization.

**Specification Table:**

| S.NO | PARAMETERS | SPECIFICATION |
|:---|:---|:---|
| 1 | Part Number | XQRKU060-1FFVF1754E |
| 2 | Logic Cells | 603,000 |
| 3 | CLB Flip-Flops | 1,209,600 |
| 4 | Number of Gates | ~10M (ASIC equivalent) |
| 5 | Maximum Distributed RAM (Kb) | 5,136 |
| 6 | Total Block RAM (Kb) | 31,152 |
| 7 | Maximum Single-Ended I/Os | 520 |
| 8 | Maximum DSP Slices | 2,760 |
| 9 | No of IO Bank | 3 (User accessible banks + High Speed Banks) |

---

## 7. Block Diagram
*Reference Schematic: khg_Rx_Top_SCH.pdf*
The block diagram illustrates the flow from the RF Input (SMA) through the Limiter/LNA/VGA chain to the Mixer. The LO path is depicted driving the Mixer. The IF outputs drive the ADC, which connects to the FPGA via JESD204C lanes. The control UART interfaces the FPGA to the external host/system controller.

---

## 8. Pinout Details

**Table: FPGA Pin Out Details**

| S.No | Signal Name | Pin No (Pkg) | Voltage Level | Direction wrt FPGA | Source | Destination | Default Condition | Voltage Standard |
|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| **1** | **VCCO_1V8** | - | +1.8V | Power In | PMIC | FPGA Bank 65 | - | - |
| **2** | **VCCO_3V3** | - | +3.3V | Power In | PMIC | FPGA Bank 64 | - | - |
| **3** | **VCCAU_1V1** | - | +1.1V | Power In | PMIC | FPGA GTH | - | - |
| **4** | **GND** | - | 0V | Power In | Chassis | FPGA | - | - |
| **5** | **FPGA_RESET_N** | E12 | +3.3V | In | System Controller | FPGA | Pull Up | LVCMOS18 |
| **6** | **JTAG_TCK** | F12 | +3.3V | In | Debugger | FPGA | Pull Down | LVCMOS18 |
| **7** | **JTAG_TDI** | G13 | +3.3V | In | Debugger | FPGA | Pull Up | LVCMOS18 |
| **8** | **JTAG_TDO** | H12 | +3.3V | Out | FPGA | Debugger | High Z | LVCMOS18 |
| **9** | **JTAG_TMS** | K13 | +3.3V | In | Debugger | FPGA | Pull Up | LVCMOS18 |
| **10** | **UART_TX** | N15 | +3.3V | Out | FPGA | Host (PC) | High Z | LVCMOS18 |
| **11** | **UART_RX** | M16 | +3.3V | In | Host (PC) | FPGA | Pull Up | LVCMOS18 |
| **12** | **ADC0_JESD_TX_P[0]** | G1 | - | Out | FPGA (GTX) | ADC JESD Input | High Z | CML_1V2 |
| **13** | **ADC0_JESD_TX_N[0]** | H1 | - | Out | FPGA (GTX) | ADC JESD Input | High Z | CML_1V2 |
| **14** | **ADC0_JESD_TX_P[1]** | J1 | - | Out | FPGA (GTX) | ADC JESD Input | High Z | CML_1V2 |
| **15** | **ADC0_JESD_TX_N[1]** | K1 | - | Out | FPGA (GTX) | ADC JESD Input | High Z | CML_1V2 |
| **16** | **ADC0_JESD_TX_P[2]** | L1 | - | Out | FPGA (GTX) | ADC JESD Input | High Z | CML_1V2 |
| **17** | **ADC0_JESD_TX_N[2]** | M1 | - | Out | FPGA (GTX) | ADC JESD Input | High Z | CML_1V2 |
| **18** | **ADC0_JESD_TX_P[3]** | N1 | - | Out | FPGA (GTX) | ADC JESD Input | High Z | CML_1V2 |
| **19** | **ADC0_JESD_TX_N[3]** | P1 | - | Out | FPGA (GTX) | ADC JESD Input | High Z | CML_1V2 |
| **20** | **ADC_REFCLK_P** | D1 | - | In | Clock Gen | FPGA (GTX) | - | LVDS |
| **21** | **ADC_REFCLK_N** | E1 | - | In | Clock Gen | FPGA (GTX) | - | LVDS |
| **22** | **SYSREF_P** | A1 | - | In | Clock Gen | FPGA | - | LVDS |
| **23** | **SYSREF_N** | B1 | - | In | Clock Gen | FPGA | - | LVDS |
| **24** | **SPI_SCK_PLL** | R14 | +3.3V | Out | FPGA | LMX2594 | Low | LVCMOS33 |
| **25** | **SPI_CS_PLL_N** | T13 | +3.3V | Out | FPGA | LMX2594 | High | LVCMOS33 |
| **26** | **SPI_MOSI_PLL** | T14 | +3.3V | Out | FPGA | LMX2594 | Low | LVCMOS33 |
| **27** | **SPI_MISO_PLL** | U13 | +3.3V | In | LMX2594 | FPGA | High Z | LVCMOS33 |
| **28** | **SPI_SCK_ADC** | P14 | +3.3V | Out | FPGA | ADC12DJ5200RF | Low | LVCMOS33 |
| **29** | **SPI_CS_ADC_N** | P15 | +3.3V | Out | FPGA | ADC12DJ5200RF | High | LVCMOS33 |
| **30** | **SPI_MOSI_ADC** | R15 | +3.3V | Out | FPGA | ADC12DJ5200RF | Low | LVCMOS33 |
| **31** | **SPI_MISO_ADC** | R16 | +3.3V | In | ADC12DJ5200RF | FPGA | High Z | LVCMOS33 |
| **32** | **VGA_LE** | A16 | +3.3V | Out | FPGA | HMC698LP4 | Low | LVCMOS33 |
| **33** | **VGA_DATA[0]** | B16 | +3.3V | Out | FPGA | HMC698LP4 | Low | LVCMOS33 |
| **34** | **VGA_DATA[1]** | C16 | +3.3V | Out | FPGA | HMC698LP4 | Low | LVCMOS33 |
| **35** | **VGA_DATA[2]** | D16 | +3.3V | Out | FPGA | HMC698LP4 | Low | LVCMOS33 |
| **36** | **VGA_DATA[3]** | E16 | +3.3V | Out | FPGA | HMC698LP4 | Low | LVCMOS33 |
| **37** | **VGA_DATA[4]** | F16 | +3.3V | Out | FPGA | HMC698LP4 | Low | LVCMOS33 |
| **38** | **VGA_DATA[5]** | G16 | +3.3V | Out | FPGA | HMC698LP4 | Low | LVCMOS33 |
| **39** | **LED_STATUS** | J16 | +3.3V | Out | FPGA | LED (Passive) | Low | LVCMOS33 |
| **40** | **FPGA_DONE** | K15 | +3.3V | Out | FPGA | Monitor | High Z | LVCMOS18 |
| **41** | **FPGA_INIT_N** | L15 | +3.3V | Bi-Di | FPGA | Config Flash | Low | LVCMOS18 |

*(Note: Pin numbers are illustrative package locations for reference only. Final IO assignment must follow Xilinx Vivado constraints derived from the schematic.)*

---

## 9. Functional Specifications

**Summary Table:**

| S.No. | Function Name | Description |
|:---|:---|:---|
| 1 | Serial Communication Interface | UART between Host PC & FPGA for register control and status polling. |
| 2 | High Speed Communication Interface | JESD204C Subclass 1 (4 Lanes, 12.5 Gbps). |
| 3 | Power Supply Sequencing | FPGA controls Enables for LDOs to ensure correct ramp-up. |
| 4 | Supply & Temp Monitoring | SPI telemetry via ADC internal sensors. |
| 5 | RF AGC Control | 6-bit parallel bus to HMC698LP4 for fast gain stepping. |
| 6 | LO Frequency Control | SPI master to LMX2594 for frequency synthesis. |
| 7 | System Diagnostics | Heartbeat LED, status registers, error logging. |

### 9.1 Serial Communication Interface
- **Interface type:** UART 16550 compatible.
- **Physical layer:** 3.3V LVTTL.
- **Baud rate:** 115200 bps (default), configurable up to 921600 bps.
- **Frame format:** 1 start bit, 8 data bits, 1 stop bit, no parity (8N1).
- **Connector:** FTSH-105-01-L-DV (Header).
- **Protocol:** As defined in Section 11.

### 9.2 High Speed Communication Interface
- **Interface:** JESD204C Subclass 1.
- **Lanes:** 4 Lanes (Lane 0, 1, 2, 3).
- **Data Rate:** 12.5 Gbps per lane.
- **Encoding:** 64b/66b Scrambled.
- **SYNC~:** Handled between FPGA PHY and ADC.
- **SYSREF:** Continuous periodic SYSREF generated by FPGA or LMK (if applicable) for device alignment.

### 9.3 Power On/Off Sequence
#### 9.3.1 Power ON Sequence
1. **System +12V Applied:** `FPGA_RESET_N` held low by external pull-down/micro.
2. **Rail Sequencing:**
    - +5V Rail (LTC7151S) ramps up.
    - +3.3V Rail (TPS7A4700) ramps up.
    - +2.5V, +1.8V Rails ramp up.
    - +1.0V Rail (TPS62913) ramps up.
3. **FPGA Release:** `FPGA_RESET_N` asserted High.
4. **FPGA Configuration:** Loads bitstream from SPI Flash (not on BOM, assume onboard) or JTAG.
5. **Initialization:** FPGA configures PLL and ADC via SPI. `LED_STATUS` blinks.
6. **READY:** System asserts `SYS_READY` bit in Status Register.

#### 9.3.2 Mode Configuration
| Mode | Signal | Value | Description |
|:---|:---|:---|:---|
| Normal | MODE[1:0] (Internal) | 2'b00 | RX Active, JESD204C Link Active. |
| Calib | MODE[1:0] | 2'b01 | Background calibration mode (ADC). |
| Low Power | MODE[1:0] | 2'b10 | RF Front-end power saving. |

### 9.4 Supply Voltage, Current & Temperature Monitoring
- **Method:** On-chip sensors of ADC12DJ5200RF read back via SPI.
- **Monitored Rails:** +1.0V ADC Core, +1.8V, +2.5V, +3.3V, +5.0V (via ADC general-purpose inputs or external dividers).
- **Temperature:** Internal ADC temperature sensor.
- **Alerts:** `TEMP_ALERT` bit set if > 120°C.

### 9.5 Flash & Interfaces
- **Configuration Flash:** Not explicitly listed in BOM, assumed external (Industrial SPI Flash, e.g., S25FL128S) for FPGA bitstream storage.
- **Storage Flash:** Not utilized in this specific hardware revision.

### 9.6 RF Gain Control (HMC698LP4)
- **Interface:** 6-bit Parallel (LVCMOS33).
- **Signals:** `VGA_DATA[5:0]` + `VGA_LE`.
- **Logic:**
    - Write data to `VGA_DATA[5:0]`.
    - Pulse `VGA_LE` High for > 10 ns.
    - Data latched on falling edge of `VGA_LE`.
- **Range:** 0 to 31.5 dB attenuation in 0.5 dB steps.

### 9.7 FPGA Remote Programming
- **Protocol:** JTAG over FT2232H or internal ICAP.
- **Trigger:** "Remote Update" command via UART forces FPGA to reboot from secondary image or load new bitstream from external flash.

### 9.8 LO Synthesis Control (LMX2594)
- **Control:** SPI Interface (Mode 0, CPOL=0, CPHA=0).
- **Frequency Range:** 5-18 GHz (divide by 2 options internally).
- **Setup:** FPGA writes to multiplier/divider registers and triggers recalibration.

### 9.9 Beam Steering / Signal Processing
- **Function:** N/A (This is a receiver front end only; beam steering is upstream/downstream).

### 9.10 Gate Voltage Writing
- **Function:** N/A (RF Power Amplifier not present on this RX board).

---

## 10. Software Register Address Map

### 10.1 Register Base Addresses

| Block Name | Base Address | Address Range | Description |
|:---|:---|:---|:---|
| System / Identification | 0x0000 | 0x0000–0x00FF | Board ID, firmware version, status registers |
| UART Control | 0x0100 | 0x0100–0x01FF | Baud rate, FIFO control |
| SPI Flash | 0x0200 | 0x0200–0x02FF | SPI Master for Config Flash |
| SPI ADC | 0x0300 | 0x0300–0x03FF | SPI Master for ADC12DJ5200RF |
| SPI PLL | 0x0400 | 0x0400–0x04FF | SPI Master for LMX2594 |
| GPIO / RF Control | 0x0500 | 0x0500–0x05FF | VGA control, LEDs, Mode pins |
| JESD204C Control | 0x0600 | 0x0600–0x06FF | Link config, Enable, Reset, Status |
| Telemetry | 0x0700 | 0x0700–0x07FF | ADC Temp, Voltage monitors |
| Diagnostics | 0x0A00 | 0x0A00–0x0AFF | Fault log, uptime counter |

### 10.2 Detailed Register Map

**Block 0x0000 — System / Identification**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|:---|:---|:---|:---|:---|:---|
| 0x00 | BOARD_ID | 16 | R | 0x4B48 | 'KH' (0x4B48) ASCII ID |
| 0x01 | FW_VERSION | 16 | R | 0x0100 | Firmware Version 1.0 |
| 0x02 | SYS_STATUS | 16 | R | 0x0000 | [15:4] Reserved, [3] JESD_LOCK, [2] PLL_LOCK, [1] TEMP_ALERT, [0] READY |
| 0x03 | SYS_CTRL | 16 | R/W | 0x0000 | [0] GLOBAL_RESET, [1] SOFT_RESET |

**Block 0x0100 — UART Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|:---|:---|:---|:---|:---|:---|
| 0x00 | BAUD_DIV | 16 | R/W | 0x0026 | Divisor for 115200 @ 100MHz |
| 0x01 | UART_CTRL | 16 | R/W | 0x0000 | [0] UART_ENABLE |
| 0x02 | UART_STATUS | 16 | R | 0x0000 | [0] TX_BUSY, [1] RX_AVAIL |

**Block 0x0400 — SPI PLL (LMX2594)**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|:---|:---|:---|:---|:---|:---|
| 0x00 | PLL_MUX | 16 | R/W | 0x0000 | Selects register address for burst write |
| 0x01 | PLL_DATA | 16 | R/W | 0x0000 | Data to be written to PLL |
| 0x02 | PLL_EXEC | 16 | R/W | 0x0000 | [0] GO_BIT (Write 1 to execute write) |
| 0x03 | PLL_STATUS | 16 | R | 0x0000 | [0] LD (Lock Detect) raw input |

**Block 0x0500 — GPIO / RF Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|:---|:---|:---|:---|:---|:---|
| 0x00 | VGA_ATT_DATA | 16 | R/W | 0x0000 | [5:0] Attenuation value (0-63), [6] LE_PULSE (self-clearing) |
| 0x01 | LED_CTRL | 16 | R/W | 0x0001 | [0] LED_STATUS (1=ON) |
| 0x02 | RF_MODE | 16 | R/W | 0x0000 | [0] RX_ENABLE (RF Power Supply enable) |

**Block 0x0600 — JESD204C Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|:---|:---|:---|:---|:---|:---|
| 0x00 | JESD_CTRL | 16 | R/W | 0x0000 | [0] LINK_RESET, [1] LINK_ENABLE |
| 0x01 | JESD_STATUS | 16 | R | 0x0000 | [0] ALIGNED, [1] SYSREF_OK |
| 0x02 | JESD_LANE_CNTR | 16 | R | 0x0000 | [15:0] Disparity Error Counter |

**Block 0x0700 — Telemetry**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|:---|:---|:---|:---|:---|:---|
| 0x00 | ADC_TEMP | 16 | R | 0x0000 | Raw ADC temp sensor value |
| 0x01 | ADC_VCC_1V0 | 16 | R | 0x0000 | Raw ADC 1.0V monitor value |
| 0x02 | ADC_VCC_1V8 | 16 | R | 0x0000 | Raw ADC 1.8V monitor value |

### 10.3 Register Access Rules
- **Endianess:** Big Endian (MSB first) over UART.
- **Write:** Data is written to the register immediately.
- **Read:** Reading triggers a capture of the current status for volatile registers (like counters).

---

## 11. UART Register Protocol Specification

This section defines the protocol for accessing the registers defined in Section 10 via the UART interface.

### 11.1 Physical Layer
- **Baud Rate:** 115200 bps (Default).
- **Data Bits:** 8.
- **Stop Bits:** 1.
- **Parity:** None.
- **Flow Control:** None.

### 11.2 Command Frame Formats

**Single Register Write (CMD = 0x57 'W'):**
Used to write a single 16-bit register.
```
Byte 0: 0x57 (CMD)
Byte 1: ADDR[15:8]  (address MSB)
Byte 2: ADDR[7:0]   (address LSB)
Byte 3: DATA[15:8]  (data MSB)
Byte 4: DATA[7:0]   (data LSB)
→ Response: 0x06 (ACK) within 2ms, or 0x15 (NAK)
Total: 5 Bytes TX, 1 Byte RX
```

**Single Register Read (CMD = 0x52 'R'):**
Used to read a single 16-bit register.
```
Byte 0: 0x52 (CMD)
Byte 1: ADDR[15:8]  (address MSB)
Byte 2: ADDR[7:0]   (address LSB)
→ Response: DATA[15:8], DATA[7:0] within 2ms
Total: 3 Bytes TX, 2 Bytes RX
```

**Bulk Register Write (CMD = 0x42 'B'):**
Used to write N registers sequentially.
```
Byte 0: 0x42 (CMD)
Byte 1: ADDR[15:8]  (start address MSB)
Byte 2: ADDR[7:0]   (start address LSB)
Byte 3: N          (Number of registers to write)
Byte 4..: DATA[0]_H, DATA[0]_L, ... DATA[N-1]_H, DATA[N-1]_L
→ Response: 0x06 (ACK) within 10ms
Total: 4 + 2*N Bytes TX
```

**Bulk Register Read (CMD = 0x62 'b'):**
Used to read N registers sequentially.
```
Byte 0: 0x62 (CMD)
Byte 1: ADDR[15:8]  (start address MSB)
Byte 2: ADDR[7:0]   (start address LSB)
Byte 3: N          (Number of registers to read)
→ Response: DATA[0]_H, DATA[0]_L, ... DATA[N-1]_H, DATA[N-1]_L
Total: 4 Bytes TX, 2*N Bytes RX
```

### 11.3 Protocol Timing Constraints
| Parameter | Min | Typical | Max | Unit |
|:---|:---|:---|:---|:---|
| Inter-byte gap (TX) | - | - | 50 | ms |
| ACK/NAK Response Time | - | 1 | 5 | ms |
| Read Data Response Time | - | 2 | 10 | ms |

### 11.4 Software Implementation Notes
```c
// Example Write Macro
#define FPGA_WRITE(addr, data) \
    UART_SendByte(0x57); \
    UART_SendByte((uint8_t)((addr) >> 8)); \
    UART_SendByte((uint8_t)(addr)); \
    UART_SendByte((uint8_t)((data) >> 8)); \
    UART_SendByte((uint8_t)(data));

// Base Address Registers
#define REG_SYS_BASE    0x0000
#define REG_RF_BASE     0x0500
#define REG_JESD_BASE   0x0600
```

---

## 12. FPGA Resource Utilization Estimate

| Resource | Available | Estimated Usage | Utilization % |
|:---|:---|:---|:---|
| Slice LUTs | 303,600 | 45,000 | 14.8% |
| Slice Flip-Flops | 607,200 | 60,000 | 9.8% |
| Block RAM (36Kb) | 864 | 80 | 9.2% |
| DSP Slices | 2,760 | 20 | 0.7% |
| UltraScale+ GTY | 32 | 4 | 12.5% |
| I/O Pins | 520 | 50 | 9.6% |

**Synthesis Tool:** Xilinx Vivado 2023.2
**Target Device:** XQRKU060-1FFVF1754E
**Timing Constraint:** 500 MHz (Logic), 12.5 Gbps (GTY)

*Logic resources primarily consumed by JESD204B IP Core (Transport/PHY layers) and UART/SPI peripherals.*

---

## Annexure A — Requirement Traceability Matrix

| S.No | GLR-ID | Description | Source HRS Section | GLR Section | Verification Method | Status |
|:---|:---|:---|:---|:---|:---|:---|
| 1 | GLR-001 | JESD204C Data Interface | REQ-HW-006 | 9.2, 12 | Test (Eye Diagram) | Open |
| 2 | GLR-002 | SPI Control Interface | REQ-HW-012 | 9.1, 10, 11 | Test (Bit-bang) | Open |
| 3 | GLR-003 | RF Gain Control | REQ-HW-007 | 9.6, 10.2 | Inspection (Scope) | Open |
| 4 | GLR-004 | LO Generation Control | REQ-HW-001 | 9.8, 10.2 | Test (Freq out) | Open |
| 5 | GLR-005 | Power Supply Sequencing | REQ-HW-009 | 9.3 | Inspection | Open |
| 6 | GLR-006 | Environmental Temp Operation | REQ-HW-010 | 4, 6 | Analysis (Derating) | Open |
| 7 | GLR-007 | UART Protocol Spec | REQ-HW-012 | 11 | Test (Loopback) | Open |
| 8 | GLR-008 | Register Map Definition | - | 10 | Inspection | Open |
| 9 | GLR-009 | Pinout Definition | - | 8 | Inspection | Open |