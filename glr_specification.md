# Glue Logic Requirements (GLR)

## Document Control
| Document Title | Glue Logic Requirements |
| Version Date | 16.04.2026 |
| Version Number | 0V01 |
| Prepared By | Name: . Sign: |
| Document Review By | Name: . Sign: |

---

## Amendments to the Document
| S. No. | Ver. No. | Ver. Date | Changed By | Section(s) Changed | Description of Change |
| 1 | 0V01 | 16.04.2026 | - | - | Initial Version |

---

## 1. Scope of the Document
This document explains the IO details and functional requirements of the FPGA for **sample**. Targeted audience: Hardware Design and Firmware teams.

---

## 2. References

### 2.1 External
| Doc. Type | Part No. | Description |
|----------|----------|-------------|
| Datasheet | HMC1134LP4ETR | 5-18 GHz GaAs MMIC LNA |
| Datasheet | HMC1118LP3E | GaAs SPDT Switch, DC-18 GHz |
| Datasheet | HMC559LP4 | Wideband Mixer 5-20 GHz |
| Datasheet | AD8376ABCZZ | Digital VGA, 700 MHz BW |
| Datasheet | AD9208-2500EBZ | Dual, 12-bit, 3 GSPS ADC, JESD204B/C |
| Datasheet | HMC7044LP6F | Ultra-low phase noise fractional-N PLL |
| Datasheet | LTC2975EUHF#PBF | Power Controller (PMBus) |
| Datasheet | XCZU2CG-1SFVC784E | Zynq UltraScale+ CG SoC FPGA |
| Datasheet | GRM32ER71H475KA88L | Decoupling Capacitor 4.7uF |

### 2.2 Internal
| Reference | Document |
| [HRS] | Hardware Requirements Specification |
| [SCH] | Schematic |
| [GRS] | General Requirements Specification |
| [GDD] | General Design Document |

---

## 3. Acronyms and Abbreviations
| Acronym | Expansion |
|---------|-----------|
| ADC | Analog-to-Digital Converter |
| AGC | Automatic Gain Control |
| BER | Bit Error Rate |
| BW | Bandwidth |
| CE RED | Radio Equipment Directive |
| CLB | Configurable Logic Block |
| DAC | Digital-to-Analog Converter |
| DSP | Digital Signal Processing |
| EMC | Electromagnetic Compatibility |
| ENOB | Effective Number of Bits |
| FF | Flip-Flop |
| FPGA | Field Programmable Gate Array |
| GND | Ground |
| GPIO | General Purpose Input/Output |
| GSPS | Giga Samples Per Second |
| HDL | Hardware Description Language |
| I2C | Inter-Integrated Circuit |
| IO | Input/Output |
| JESD | JESD204 Standard (High-speed serial) |
| JTAG | Joint Test Action Group |
| LNA | Low Noise Amplifier |
| LUT | Look-Up Table |
| LVDS | Low-Voltage Differential Signaling |
| PCB | Printed Circuit Board |
| PLL | Phase-Locked Loop |
| RF | Radio Frequency |
| RTL | Register Transfer Level |
| SPI | Serial Peripheral Interface |
| UART | Universal Asynchronous Receiver-Transmitter |
| VCC | Voltage Common Collector (Supply) |
| VGA | Variable Gain Amplifier |

---

## 4. Module Overview

**RF SECTION:**
The RF front end consists of a wideband LNA (HMC1134) covering 5-18 GHz, followed by a band-select SPDT switch (HMC1118) for discrete band filtering. The signal is downconverted using a wideband mixer (HMC559) driven by an LO source from the clock generator. The IF signal is conditioned by a high-performance VGA (AD8376) providing 31.5 dB gain range before digitization.

**DIGITAL SECTION:**
The core of the digital section is the Xilinx Zynq UltraScale+ FPGA (XCZU2CG-1SFVC784E). It acts as the system controller, managing the RF front-end gain (VGA), mixer LO synthesis (PLL), and power sequencing. It interfaces with the high-speed ADC (AD9208) via 8 lanes of JESD204B/C data links to receive digitized IF samples. The FPGA also provides the control interface (UART) to the host system.

**POWER SUPPLY SECTION:**
Power is managed by the LTC2975 PMBus controller. The system requires multiple rails: +5V for RF components (LNA, Mixer), +3.3V for FPGA IO and logic, +1.25V for ADC core, +2.5V for ADC IO, and +1.0V for FPGA core logic. The FPGA monitors these rails via I2C to ensure health.

---

## 5. Features
- **FPGA:** Xilinx XCZU2CG-1SFVC784E (Zynq UltraScale+ CG)
- **On-board clock:** HMC7044 PLL synthesizer with ultra-low phase noise
- **High-Speed Interface:** JESD204B/C (8 lanes) to AD9208 ADC @ up to 12.5 Gbps/lane
- **Control Interfaces:** 
  - UART (Host control)
  - SPI (ADC, Clock Gen, Power Controller)
  - I2C (Power monitoring, EEPROM)
- **RF Control:** SPI interfaces for HMC1118 Switch, AD8376 VGA (Parallel/SPI compatible), HMC7044 PLL
- **Power Monitoring:** LTC2975 (PMBus) for voltage/current/temp monitoring
- **JTAG:** Standard 14-pin header for FPGA debug

---

## 6. FPGA Description

The **Xilinx XCZU2CG-1SFVC784E** is selected for its high-speed transceiver capability (GTY) required for the JESD204B interface to the AD9208 ADC and the integrated PS (Processing System) for complex control logic handling.

| S.NO | PARAMETERS | SPECIFICATION |
|------|-----------|---------------|
| 1 | Part Number | XCZU2CG-1SFVC784E |
| 2 | Logic Cells | 43,200 |
| 3 | CLB Flip-Flops | 172,800 |
| 4 | Number of Gates | 2.1M (ASIC equiv) |
| 5 | Maximum Distributed RAM (Kb) | 438 |
| 6 | Total Block RAM (Kb) | 972 |
| 7 | Maximum Single-Ended I/Os | 288 |
| 8 | Maximum DSP Slices | 124 |
| 9 | No of IO Bank | 2 (PS), 4 (PL) - Approx 6 banks used |

---

## 7. Block Diagram
(Reference to block diagram — See Section 4 Overview)

---

## 8. Pinout Details

**Table: FPGA Pin Out Details**

| S.No | Signal Name | Pin No (Approx) | Voltage Level | Direction wrt FPGA | Source | Destination | Default Condition | Voltage Standard |
|------|-------------|-----------------|---------------|--------------------|--------|-------------|-------------------|------------------|
| 1 | VCC_3V3_IO | - | +3.3V | Power In | PWR | FPGA Bank 34 | Power Good | LVCMOS33 |
| 2 | VCC_1V25_ADC | - | +1.25V | Power In | PWR | FPGA GTX Termination | Power Good | - |
| 3 | GND | - | GND | Power In | PWR | FPGA | GND | - |
| 4 | CLK_REF_IN | E12 | +3.3V | Input | CLK_GEN | FPGA PS | Clock Running | LVDS |
| 5 | UART_TX | M15 | +3.3V | Output | FPGA | USB-UART | High | LVCMOS33 |
| 6 | UART_RX | M16 | +3.3V | Input | USB-UART | FPGA | High | LVCMOS33 |
| 7 | SPI_SCLK | K15 | +3.3V | Output | FPGA | ADC/PWR/CLK | Low | LVCMOS33 |
| 8 | SPI_SDI | L16 | +3.3V | Output | FPGA | ADC/PWR/CLK | Low | LVCMOS33 |
| 9 | SPI_SDO_ADC | K16 | +3.3V | Input | ADC | FPGA | High-Z | LVCMOS33 |
| 10 | SPI_SDO_CLK | J15 | +3.3V | Input | CLK_GEN | FPGA | High-Z | LVCMOS33 |
| 11 | SPI_SDO_PWR | H16 | +3.3V | Input | PWR_CTRL | FPGA | High-Z | LVCMOS33 |
| 12 | SPI_CS_ADC_N | J16 | +3.3V | Output | FPGA | ADC | High | LVCMOS33 |
| 13 | SPI_CS_CLK_N | G15 | +3.3V | Output | FPGA | CLK_GEN | High | LVCMOS33 |
| 14 | SPI_CS_PWR_N | G16 | +3.3V | Output | FPGA | PWR_CTRL | High | LVCMOS33 |
| 15 | VGA_GAIN_CLK | N15 | +3.3V | Output | FPGA | VGA | Low | LVCMOS33 |
| 16 | VGA_GAIN_DATA | N16 | +3.3V | Output | FPGA | VGA | Low | LVCMOS33 |
| 17 | VGA_GAIN_LE | P15 | +3.3V | Output | FPGA | VGA | Low | LVCMOS33 |
| 18 | SWITCH_CTRL_A | P16 | +3.3V | Output | FPGA | RF_SW | Low | LVCMOS33 |
| 19 | SWITCH_CTRL_B | R15 | +3.3V | Output | FPGA | RF_SW | Low | LVCMOS33 |
| 20 | FPGA_SYNC_P | T12 | +1.25V | Output | FPGA GTX | ADC SYNC | Low | CML |
| 21 | FPGA_SYNC_N | T13 | +1.25V | Output | FPGA GTX | ADC SYNC | Low | CML |
| 22 | JESD_RX0_P | Y1 | +1.25V | Input | ADC | FPGA GTX Lane 0 | AC Coupled | DIFF_SSTL12 |
| 23 | JESD_RX0_N | Y2 | +1.25V | Input | ADC | FPGA GTX Lane 0 | AC Coupled | DIFF_SSTL12 |
| 24 | JESD_RX1_P | Y3 | +1.25V | Input | ADC | FPGA GTX Lane 1 | AC Coupled | DIFF_SSTL12 |
| 25 | JESD_RX1_N | Y4 | +1.25V | Input | ADC | FPGA GTX Lane 1 | AC Coupled | DIFF_SSTL12 |
| 26 | JESD_RX2_P | Y5 | +1.25V | Input | ADC | FPGA GTX Lane 2 | AC Coupled | DIFF_SSTL12 |
| 27 | JESD_RX2_N | Y6 | +1.25V | Input | ADC | FPGA GTX Lane 2 | AC Coupled | DIFF_SSTL12 |
| 28 | JESD_RX3_P | Y7 | +1.25V | Input | ADC | FPGA GTX Lane 3 | AC Coupled | DIFF_SSTL12 |
| 29 | JESD_RX3_N | Y8 | +1.25V | Input | ADC | FPGA GTX Lane 3 | AC Coupled | DIFF_SSTL12 |
| 30 | JTAG_TCK | D6 | +3.3V | Input | Debugger | FPGA | Pull Up | LVCMOS33 |
| 31 | JTAG_TDI | C6 | +3.3V | Input | Debugger | FPGA | Pull Up | LVCMOS33 |
| 32 | JTAG_TDO | D7 | +3.3V | Output | FPGA | Debugger | High-Z | LVCMOS33 |
| 33 | JTAG_TMS | E6 | +3.3V | Input | Debugger | FPGA | Pull Up | LVCMOS33 |
| 34 | I2C_SCL | AA15 | +3.3V | Bidir | FPGA | Temp/PWR | High | I2C |
| 35 | I2C_SDA | AA16 | +3.3V | Bidir | FPGA | Temp/PWR | High | I2C |

---

## 9. Functional Specifications

**Summary table first:**

| S.No. | Function Name | Description |
|-------|--------------|-------------|
| 1 | Serial Communication Interface | UART between PC & FPGA for configuration and status |
| 2 | High Speed Communication Interface | 8-Lane JESD204B/C interface to AD9208 ADC (12 Gbps) |
| 3 | Power Supply Sequencing & Health Status | FPGA monitors LTC2975 via PMBus for sequencing |
| 4 | Supply Voltage, Current & Temperature Monitoring | Real-time monitoring via LTC2975 I2C interface |
| 5 | Flash Interfaces | SPI interfaces to external Config Flash (if applicable) |
| 6 | RF Switch Control | Digital control of HMC1118 SPDT switch via GPIO |
| 7 | ADC Interface Control | SPI configuration of AD9208 (Gain, Offset, Test Patterns) |
| 8 | VGA Gain Controlling | 3-wire serial interface to AD8376 for AGC |
| 9 | Clock Generation Control | SPI configuration of HMC7044 for LO generation |

Then provide DETAILED subsections:

### 9.1 Serial Communication Interface
- **Interface type:** UART
- **Physical layer:** TTL (3.3V logic), compatible with RS-232 via external level shifter
- **Baud rate:** 115200 bps (default), up to 921.6 kBd
- **Frame format:** 1 start bit, 8 data bits, 1 stop bit, no parity (8N1)
- **USB-UART converter IC:** FT2232H (External)
- **Signals:** UART_TX (FPGA → PC), UART_RX (PC → FPGA)
- **Protocol:** Custom register-based command/response (See Section 11)

### 9.2 High Speed Communication Interface
- **Interface:** JESD204B / JESD204C
- **Number of lanes:** 8 Lanes (GTX Transceivers)
- **Data rate per lane:** 12.5 Gbps (configurable)
- **Protocol:** JESD204B Subclass 1 (Synchronized)
- **Physical:** AC-coupled differential pairs (CML) to AD9208
- **Scrambling:** Enabled
- **Framer:** Link layer synchronization via FPGA_SYNC_P/N

### 9.3 Power On/Off Sequence
#### 9.3.1 Power ON/OFF Sequence
Step-by-step sequence:
1. Input supply (+12V) detected.
2. FPGA enables +3.3V IO rail via LTC2975.
3. FPGA enables +1.0V Core rail.
4. FPGA initializes PS (Processing System) and waits for "Power Good" from LTC2975.
5. FPGA configures +5V RF rails via SPI to LTC2975.
6. FPGA asserts FPGA_DONE and releases RESET_N.
7. FPGA enables RF components via GPIO enables.
8. System READY status asserted.

#### 9.3.2 Mode Configuration
| Mode | Signal | Value | Description |
|------|--------|-------|-------------|
| Normal | MODE[1:0] | 2'b00 | Standard RX operation |
| BIST | MODE[1:0] | 2'b01 | Loopback mode (internal test patterns) |
| Sleep | MODE[1:0] | 2'b10 | Low power state, clocks gated |

### 9.4 Supply Voltage, Current & Temperature Monitoring
#### 9.4.1 Supply Voltage and Current Monitoring
- **IC Part Number:** LTC2975EUHF#PBF
- **Interface:** PMBus over I2C (Address 0x54)
- **Monitored rails:** +5V_RF, +3.3V_IO, +1.25V_ADC, +1.0V_CORE, +2.5V_ADC_IO
- **Measurement range:** 0 to 6.0V
- **Resolution:** 16-bit ADC (approx 100uV/LSB)

#### 9.4.2 Temperature Monitoring
- **IC Part Number:** Internal to LTC2975 (and optional ADT7410 on I2C bus)
- **Interface:** I2C at 0x4C
- **Temperature range:** -40°C to +125°C
- **Resolution:** 0.0625°C (10-bit internal sensor)
- **Alert threshold:** >85°C

### 9.5 Flash & Interfaces
*(Note: No specific external flash for bitstream storage is explicitly listed in the minimal BOM, but Zynq typically uses QSPI. Assuming standard QSPI flash for boot)*
- **Interface:** QSPI (Quad SPI)
- **Capacity:** 128 Mb (Default)
- **Purpose:** Stores FPGA bitstream and system firmware
- **Programming:** Via JTAG or UART

### 9.6 RF Switch Configuration
- **Component:** HMC1118LP3E
- **Control Signal:** SWITCH_CTRL_A, SWITCH_CTRL_B
- **Logic:**
  - A=0, B=0 -> RF1 (Path 1)
  - A=1, B=0 -> RFC (Common Path)
- **Timing:** Switching time 3 ns (1-2 FPGA clock cycles)

### 9.7 ADC Interface Control
- **Component:** AD9208-2500EBZ
- **Interface:** SPI (Chip Select: SPI_CS_ADC_N)
- **Functions:**
  - Register write for JESD204B link config (F, K, L, M parameters)
  - Test pattern generation
  - Gain/Offset correction

### 9.8 VGA Gain Controlling
- **Component:** AD8376ABCZZ
- **Interface:** 3-wire serial (CLK, DATA, LE)
- **Gain Range:** 0 to 31.5 dB
- **Resolution:** 0.5 dB steps (7-bit data word)
- **Update Rate:** Max 50 MHz serial clock
- **Protocol:** FPGA shifts 8-bit data (7 bits gain + 1 latch bit) on VGA_GAIN_CLK.

### 9.9 Clock Generation Control
- **Component:** HMC7044LP6F
- **Interface:** SPI (Chip Select: SPI_CS_CLK_N)
- **Function:** Set output dividers for ADC_CLK and MIXER_LO.
- **Frequency:** Fin (Ref), Fout = N * Fin.

### 9.10 Gate Voltage Writing in DAC
*(Not present in current BOM - RF amps are fixed bias. Placeholder for future expansion)*

---

## 10. Software Register Address Map

This section defines the complete FPGA register address space.

### 10.1 Register Base Addresses

| Block Name | Base Address | Address Range | Description |
|------------|-------------|---------------|-------------|
| System / Identification | 0x0000 | 0x0000–0x00FF | Board ID, firmware version, status |
| UART Control | 0x0100 | 0x0100–0x01FF | Baud rate, FIFO control |
| SPI Control | 0x0200 | 0x0200–0x02FF | SPI master, chip-select control |
| I2C Control | 0x0300 | 0x0300–0x03FF | I2C master, device address |
| GPIO | 0x0400 | 0x0400–0x04FF | Switch control, LED control |
| JESD / ADC Control | 0x0500 | 0x0500–0x05FF | ADC SPI wrapper, JESD Link Status |
| RF / VGA Control | 0x0600 | 0x0600–0x06FF | VGA gain, Frequency selection |
| Power Monitor | 0x0700 | 0x0700–0x07FF | Voltage/current ADC readings |
| PLL Control | 0x0800 | 0x0800–0x08FF | HMC7044 SPI wrapper |
| Diagnostics | 0x0A00 | 0x0A00–0x0AFF | Fault log, uptime counter |

### 10.2 Detailed Register Map

**Block 0x0000 — System / Identification**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|--------------|-------|-----|-------------|----------------------|
| 0x00 | BOARD_ID | 16 | R | 0xA501 | Board identification code (A=Sample, 501=Rev) |
| 0x01 | FW_VERSION_MAJOR | 16 | R | 0x0001 | Firmware major version |
| 0x02 | FW_VERSION_MINOR | 16 | R | 0x0000 | Firmware minor version |
| 0x03 | SYS_STATUS | 16 | R | 0x0000 | [15:8] Reserved, [7] JESD_LOCKED, [6] TEMP_ALERT, [5] PWR_GOOD, [4] RF_ENABLED |

**Block 0x0400 — GPIO**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|--------------|-------|-----|-------------|----------------------|
| 0x00 | RF_SWITCH_CTRL | 16 | R/W | 0x0000 | [0] SWITCH_CTRL_A, [1] SWITCH_CTRL_B |
| 0x01 | LED_CTRL | 16 | R/W | 0x0001 | [0] LED_STATUS (1=ON) |
| 0x02 | SYS_FLAGS | 16 | R | 0x0000 | [0] BUTTON_PRESSED |

**Block 0x0600 — RF / VGA Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|--------------|-------|-----|-------------|----------------------|
| 0x00 | VGA_GAIN_MSB | 16 | R/W | 0x0000 | [6:0] Gain MSBs (part of 8-bit gain) |
| 0x01 | VGA_GAIN_LSB | 16 | R/W | 0x0000 | [0] Gain LSB (Latch bit) |
| 0x02 | BAND_SELECT | 16 | R/W | 0x0000 | [1:0] Band selection index (0-3) |

**Block 0x0700 — Power Monitor (LTC2975)**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|--------|--------------|-------|-----|-------------|----------------------|
| 0x00 | PMBUS_PAGE | 16 | R/W | 0x0000 | Selects rail for monitoring (0=5V, 1=3.3V...) |
| 0x01 | READ_VOUT | 16 | R | 0x0000 | Voltage reading (hex) |
| 0x02 | READ_IOUT | 16 | R | 0x0000 | Current reading (hex) |
| 0x03 | READ_TEMP | 16 | R | 0x0000 | Temperature reading |

---

## 11. UART Register Protocol Specification

### 11.1 Physical Layer
- **Baud rate:** 115200 bps (default)
- **Frame format:** 1 start bit, 8 data bits, 1 stop bit, no parity (8N1)
- **Physical interface:** TTL (3.3V logic)

### 11.2 Command Frame Formats

**Single Register Write (CMD = 0x57 'W'):**
```
Byte 0: 0x57 (CMD)
Byte 1: ADDR[15:8] (address MSB)
Byte 2: ADDR[7:0]  (address LSB)
Byte 3: DATA[15:8] (data MSB)
Byte 4: DATA[7:0]  (data LSB)
→ Response: 0x06 (ACK) within 1ms
Total frame: 5 bytes TX, 1 byte RX
```

**Single Register Read (CMD = 0x52 'R'):**
```
Byte 0: 0x52 (CMD)
Byte 1: (ADDR[15:8] | 0x80)  (MSB with read bit set)
Byte 2: ADDR[7:0]             (address LSB)
→ Response: DATA[15:8], DATA[7:0]
Total frame: 3 bytes TX, 2 bytes RX
```

**Bulk Register Write (CMD = 0x42 'B'):**
```
Byte 0: 0x42 (CMD)
Byte 1: ADDR[15:8] (start address MSB)
Byte 2: ADDR[7:0]  (start address LSB)
Byte 3: N          (register count, 1–64)
Byte 4..4+2N-1: DATA[0]_H, DATA[0]_L, ...
→ Response: 0x06 (ACK)
Total frame: (4 + 2N) bytes TX, 1 byte RX
```

**Bulk Register Read (CMD = 0x62 'b'):**
```
Byte 0: 0x62 (CMD)
Byte 1: (ADDR[15:8] | 0x80)  (MSB with read bit set)
Byte 2: ADDR[7:0]             (start address LSB)
Byte 3: N                     (register count, 1–64)
→ Response: DATA[0]_H, DATA[0]_L, ...
Total frame: 4 bytes TX, 2N bytes RX
```

### 11.3 Protocol Timing Constraints
| Parameter | Min | Typical | Max | Unit |
|-----------|-----|---------|-----|------|
| Inter-byte gap (TX side) | - | - | 50 | ms |
| Single Write response time | - | 0.5 | 1 | ms |
| Single Read response time | - | 1 | 2 | ms |
| Bulk Read response time (N=64) | - | 3 | 5 | ms |

---

## 12. FPGA Resource Utilization Estimate

| Resource | Available | Estimated Usage | Utilization % |
|---------|-----------|----------------|--------------|
| Slice LUTs | 53,200 | 8,500 | 16% |
| Slice Flip-Flops | 106,400 | 12,000 | 11% |
| Block RAM (36Kb) | 144 | 18 | 12.5% |
| DSP Slices | 124 | 4 | 3.2% |
| GTX Transceivers | 8 | 8 | 100% |
| I/O Buffers | 288 | 85 | 29% |

**Synthesis tool:** Vivado 2024.1
**Target device:** XCZU2CG-1SFVC784E
**Timing constraint:** 125 MHz (Control Logic), 3.0 GHz (GTX)

---

## Annexure A — Requirement Traceability Matrix

| S.No | GLR-ID | Description | Source HRS Section | GLR Section | Verification Method | Status |
|-------|--------|-------------|-------------------|-------------|--------------------|----|
| 1 | GLR-001 | RF Input Frequency Coverage | HRS §3.1 REQ-HW-001 | 9.6 | Test | Open |
| 2 | GLR-002 | ADC Sampling Rate & Resolution | HRS §3.1 REQ-HW-004, REQ-HW-005 | 9.7, 9.2 | Test | Open |
| 3 | GLR-003 | Discrete Band Selection | HRS §3.1 REQ-HW-011 | 9.6 | Demonstration | Open |
| 4 | GLR-004 | Clock Generation | HRS §3.1 REQ-HW-014 | 9.9 | Test | Open |
| 5 | GLR-005 | Noise Figure / Gain Control | HRS §3.2 REQ-HW-002, REQ-HW-003 | 9.8 | Test | Open |
| 6 | GLR-006 | Power Consumption & Monitoring | HRS §3.2 REQ-HW-008 | 9.4, 9.3 | Test | Open |
| 7 | GLR-007 | Operating Temperature Range | HRS §3.4 REQ-HW-007 | 9.4.2 | Test | Open |
| 8 | GLR-008 | Regulatory Compliance (EMC) | HRS §3.5 REQ-HW-009 | 4 (Module) | Inspection | Open |
| 9 | GLR-009 | Custom Digital Interface (JESD) | HRS §3.3 REQ-HW-006 | 9.2 | Test | Open |
| 10 | GLR-010 | UART Protocol Specification | Derived Req | 11 | Test | Open |
| 11 | GLR-011 | FPGA Resource Budget | Derived Req | 12 | Analysis | Open |
| 12 | GLR-012 | Register Address Map | Derived Req | 10 | Inspection | Open |