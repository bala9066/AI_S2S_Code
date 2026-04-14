# Glue Logic Requirements (GLR)

## Document Control
| Document Title | Glue Logic Requirements |
| Version Date | 14.04.2026 |
| Version Number | 0V01 |
| Prepared By | Name: . Sign: |
| Document Review By | Name: . Sign: |

---

## Amendments to the Document
| S. No. | Ver. No. | Ver. Date | Changed By | Section(s) Changed | Description of Change |
| 1 | 0V01 | 14.04.2026 | - | - | Initial Version |

---

## 1. Scope of the Document
This document details the Input/Output (IO) interfaces and functional logic requirements for the **ATMEGA328P-AU** microcontroller (System MCU) and the specific Glue Logic required for the **rbhjdaz** Wideband RF Receiver project. It serves as the bridge between the hardware netlist (P4) and the firmware design (P7), defining signal behaviors, voltage levels, and data flow control for the RF Front End, Frequency Synthesis, and Data Acquisition subsystems.

---

## 2. References

### 2.1 External
| Doc. Type | Part No. | Description |
|-----------|----------|-------------|
| Datasheet | ATMEGA328P-AU | 8-bit AVR Microcontroller with 32KB Flash |
| Datasheet | AD9208 | Dual, 14-Bit, 3 GSPS ADC/JESD204B |
| Datasheet | ADF5355 | Wideband Synthesizer with Integrated VCO (6.8 GHz to 13.6 GHz) |
| Datasheet | HMC698LP4 | DC-14 GHz Digital VGA, 1 dB Steps |
| Datasheet | LMK04828 | Jitter Cleaner/Clock Generator with Dual Loop PLLs |
| Datasheet | ADP5054 | Quad Output DC/DC Regulator |
| Datasheet | 24AA256 | 256Kb I2C EEPROM |
| Datasheet | ISOW7842 | Enhanced USB Digital Isolator |

### 2.2 Internal
| Reference | Document |
|-----------|----------|
| [HRS] | Hardware Requirements Specification (rbhjdaz) |
| [SCH] | Schematic (Netlist P4) |
| [GRS] | General Requirements Specification |
| [GDD] | General Design Document |

---

## 3. Acronyms and Abbreviations
| Acronym | Expansion |
|---------|-----------|
| ADC | Analog-to-Digital Converter |
| BIST | Built-In Self-Test |
| BOM | Bill of Materials |
| CLB | Configurable Logic Block |
| CSP | Chip Scale Packaging |
| DAC | Digital-to-Analog Converter |
| DMA | Direct Memory Access |
| DSP | Digital Signal Processing |
| EMC | Electromagnetic Compatibility |
| EEPROM | Electrically Erasable Programmable Read-Only Memory |
| FF | Flip-Flop |
| FPGA | Field Programmable Gate Array |
| GND | Ground Reference |
| GPIO | General Purpose Input/Output |
| HRS | Hardware Requirements Specification |
| I2C | Inter-Integrated Circuit |
| IO | Input/Output |
| JTAG | Joint Test Action Group |
| JESD | JEDEC Standard for High-Speed Data Interfaces |
| LDO | Low Dropout Regulator |
| LNA | Low Noise Amplifier |
| LVCMOS | Low-Voltage CMOS |
| LVTTL | Low-Voltage Transistor-Transistor Logic |
| MCU | Microcontroller Unit |
| PA | Power Amplifier |
| PCB | Printed Circuit Board |
| PLL | Phase-Locked Loop |
| RF | Radio Frequency |
| RTL | Register Transfer Level |
| RX | Receive |
| SPI | Serial Peripheral Interface |
| UART | Universal Asynchronous Receiver-Transmitter |
| VCC | Voltage Common Collector |
| VGA | Variable Gain Amplifier |

---

## 4. Module Overview

The **rbhjdaz** module is a high-performance Wideband RF Receiver designed for Electronic Warfare (EW) applications. The Glue Logic centers around the management and control of the analog signal chain and the synchronization of the high-speed data conversion.

**RF SECTION:**
The signal path begins at the RF Input (J1), passing through a limiter (U1) for high-power protection (+30 dBm CW), followed by a Wideband LNA (U2: TGA4537-SM) providing 20 dB gain. The signal is conditioned by two cascaded Digital VGAs (U3, U4: HMC698LP4) offering a total gain control range of 62 dB. Frequency downconversion is handled by a two-stage mixer architecture. Mixer Stage 1 (U5: ADL5802) performs the initial downconversion using an LO derived from the Wideband Synthesizer (U7: ADF5355). Mixer Stage 2 (U6: HMC1174ST50E) performs further frequency translation to a final IF suitable for digitization.

**DIGITAL SECTION:**
The digital core consists of the System MCU (U13: ATMEGA328P-AU) acting as the master controller. It configures the RF gain via SPI (U3, U4), sets the LO frequency via SPI (U7), and initializes the ADC (U10) via a 3-wire SPI interface. The Clock Management IC (U11: LMK04828) distributes a low-jitter clock to the ADC and synthesizer, synchronized to an external 10 MHz reference. The high-speed digitized data is output via JESD204B lanes through the Samtec SEARAY connector (J5) to an external Signal Processor. System configuration and calibration data are stored in the EEPROM (U18).

**POWER SUPPLY SECTION:**
Power is sourced from a +28 VDC military input (J4). The Power Management IC (U12: ADP5054) steps this down to intermediate rails (+5V) and logic rails (+3.3V). Subsequent LDOs (U14, U15, U16) provide clean +3.3V (MCU), +1.8V (ADC IO), and +1.2V (ADC Core) supplies. Power sequencing is managed by the ADP5054's internal enable logic and monitored via GPIOs.

---

## 5. Features
- **MCU**: Atmel ATMEGA328P-AU (8-bit AVR, 20 MHz)
- **RF Downconversion**: Dual-stage mixing via ADL5802 and HMC1174ST50E
- **LO Synthesis**: ADF5355 Wideband Synthesizer with integrated VCO
- **Gain Control**: Dual HMC698LP4 Digital VGAs (62 dB range, SPI control)
- **High-Speed ADC**: AD9208 Dual 12-bit, 3 GSPS, JESD204B output
- **Clock Conditioning**: LMK04828 Jitter Cleaner with Dual PLL
- **Control Interface**: USB (Virtual COM) via ISOW7842 Isolator
- **Memory**: 24AA256 (256 Kbit I2C EEPROM) for calibration storage
- **Protection**: RFLM5012-10 Input Limiter for high-power survival

---

## 6. FPGA Description
*Note: In this architecture, the Glue Logic is implemented via the System MCU (ATMEGA328P) controlling the peripherals. While no custom FPGA logic is defined for this specific module (functionality fixed in MCU/ADC), the specifications below reflect the logic levels and timing requirements the MCU must meet to interface with these "FPGA-class" high-speed components.*

| S.NO | PARAMETERS | SPECIFICATION |
|------|-----------|---------------|
| 1 | Controller Part Number | ATMEGA328P-AU |
| 2 | Architecture | AVR 8-bit RISC |
| 3 | Flash Memory | 32 KB |
| 4 | SRAM | 2 KB |
| 5 | EEPROM | 1 KB |
| 6 | Max I/O Speed | 20 MHz |
| 7 | SPI Interfaces | 1 Master (Multiplexed to VGA, PLL, ADC) |
| 8 | I2C Interfaces | 1 Master (Multiplexed to Clock, EEPROM) |
| 9 | Operating Voltage | 3.3V (Note: Device is 3.3V variant or overclocked at 5V logic - assumed 3.3V LVTTL interface per schematic) |

---

## 7. Block Diagram
(Refer to Schematic P4 / System Block Diagram P1)
Data Flow: RF_IN → Limiter → LNA → VGA1/2 → Mixer1/2 → IF Amp → ADC (AD9208) → JESD204B → J5.
Control Flow: USB (J3) → Isolator → MCU → SPI/I2C → RF Components.

---

## 8. Pinout Details

**Table: MCU & System Interface Pin Out Details**

| S.No | Signal Name | Pin No | Voltage Level | Direction wrt MCU | Source | Destination | Default Condition | Voltage Standard |
|------|------------|--------|---------------|-------------------|--------|-------------|------------------|------------------|
| **POWER** |
| 1 | VCC | 4 | +3.3V | Input | LDO_3V3 | MCU | High | - |
| 2 | GND | 3/5 | GND | Ref | Common | MCU | Low | - |
| 3 | AVCC | 20 | +3.3V | Input | LDO_3V3 | MCU | High | - |
| **CLOCK & RESET** |
| 4 | XTAL1 | 7 | - | Input | Crystal 16MHz | MCU | Oscillating | - |
| 5 | XTAL2 | 8 | - | Output | Crystal 16MHz | MCU | Oscillating | - |
| 6 | MCU_RESET_N | 29 | +3.3V | Input | Button (SW1) | MCU | High (Pull-up) | LVTTL |
| **USB ISOLATED INTERFACE** |
| 7 | MCU_USB_D+ | 15 | +3.3V | Bidirectional | Isolator (ISOW7842) | MCU | Float | LVTTL |
| 8 | MCU_USB_D- | 16 | +3.3V | Bidirectional | Isolator (ISOW7842) | MCU | Float | LVTTL |
| **SPI BUS (SHARED)** |
| 9 | SPI_SCLK | 19 | +3.3V | Output | MCU | VGA1, VGA2, PLL | Low | LVTTL |
| 10 | SPI_MOSI | 17 | +3.3V | Output | MCU | VGA1, VGA2, PLL | Low | LVTTL |
| 11 | SPI_MISO | 18 | +3.3V | Input | VGA1, VGA2, PLL | MCU | High-Z | LVTTL |
| **VGA CONTROL (CS SELECT)** |
| 12 | VGA1_CS | 9 | +3.3V | Output | MCU | HMC698 (U3) | High | LVTTL |
| 13 | VGA2_CS | 10 | +3.3V | Output | MCU | HMC698 (U4) | High | LVTTL |
| **PLL CONTROL** |
| 14 | PLL_CS | 5 (GPIO) | +3.3V | Output | MCU | ADF5355 (U7) | High | LVTTL |
| **ADC SPI CONTROL** |
| 15 | ADC_SCLK | 24 (SCK) | +3.3V | Output | MCU | AD9208 (U10) | Low | LVTTL |
| 16 | ADC_SDIO | 23 (MOSI) | +3.3V | Bidirectional | MCU | AD9208 (U10) | High-Z | LVTTL |
| 17 | ADC_CS_N | 22 (SS) | +3.3V | Output | MCU | AD9208 (U10) | High | LVTTL |
| **I2C BUS** |
| 18 | I2C_SCL | 28 (SCL) | +3.3V | Bidirectional | MCU | Clk Gen, EEPROM | High (Pull-up) | I2C (Open Drain) |
| 19 | I2C_SDA | 27 (SDA) | +3.3V | Bidirectional | MCU | Clk Gen, EEPROM | High (Pull-up) | I2C (Open Drain) |
| **STATUS & CONTROL** |
| 20 | LED_STATUS | 6 | +3.3V | Output | MCU | LED1 | Low | LVTTL |
| 21 | ADC_LOCK_STATUS | 2 (INT0) | +3.3V | Input | LMK04828 | MCU | High | LVTTL |
| 22 | RF_DET | A0 | 0-3.3V | Input | RF Detector (ADC) | MCU | Low | Analog |
| 23 | TEMP_WARN | 3 (INT1) | +3.3V | Input | Temp Sensor | MCU | High | LVTTL |
| **JESD204B (Passive Monitor)** |
| 24 | JESD_SYNC_P | N/A | +1.8V | Input (Monitor) | AD9208 | J5 (FPGA) | - | CML_1V8 |
| 25 | JESD_SYNC_N | N/A | +1.8V | Input (Monitor) | AD9208 | J5 (FPGA) | - | CML_1V8 |
| 26 | JESD_C_P | N/A | +1.8V | Output | AD9208 | J5 (FPGA) | - | CML_1V8 |
| 27 | JESD_C_N | N/A | +1.8V | Output | AD9208 | J5 (FPGA) | - | CML_1V8 |
| 28 | JESD_D0_P | N/A | +1.8V | Output | AD9208 | J5 (FPGA) | - | CML_1V8 |
| 29 | JESD_D0_N | N/A | +1.8V | Output | AD9208 | J5 (FPGA) | - | CML_1V8 |
| 30 | JESD_D1_P | N/A | +1.8V | Output | AD9208 | J5 (FPGA) | - | CML_1V8 |
| 31 | JESD_D1_N | N/A | +1.8V | Output | AD9208 | J5 (FPGA) | - | CML_1V8 |
| **POWER CONTROL** |
| 32 | PWR_GOOD | 13 (PD3) | +3.3V | Input | PMIC (ADP5054) | MCU | High | LVTTL |
| 33 | PA_ENABLE | 11 (PB3) | +3.3V | Output | MCU | External PA | Low | LVTTL |
| 34 | RF_SHUTDOWN | 12 (PB4) | +3.3V | Output | MCU | LNA Gate | Low | LVTTL |
| 35 | MODE_SEL | 14 (PB0) | +3.3V | Input | Button (SW2) | MCU | High | LVTTL |

---

## 9. Functional Specifications

**Summary table:**

| S.No. | Function Name | Description |
|-------|--------------|-------------|
| 1 | Serial Communication Interface | USB-UART bridge for configuration and telemetry |
| 2 | High Speed Communication Interface | JESD204B (Lane 0, Lane 1, SYSREF) |
| 3 | Power Supply Sequencing | +28V input to +1.2V core sequencing via ADP5054 |
| 4 | Supply & Temp Monitoring | I2C monitoring via LMK04828 and internal MCU ADC |
| 5 | Flash/EEPROM Interfaces | 24AA256 I2C EEPROM for Cal data |
| 6 | Gain Control | SPI interface to HMC698LP4 Dual VGAs |
| 7 | Frequency Tuning | SPI interface to ADF5355 PLL |
| 8 | Remote Programming | MCU Bootloader via USB-UART |
| 9 | Self-Test (BIST) | GPIO polling for Lock Detect and Power Good |

### 9.1 Serial Communication Interface
- **Interface Type:** USB 2.0 Full Speed (Virtual COM Port)
- **Physical Layer:** Isolated USB via ISOW7842 (5000 VRMS isolation)
- **Connector:** USB Micro-B (J3)
- **Baud Rate:** Configurable (default 115200 bps)
- **Protocol:** Custom ASCII binary packet structure.
  - **Commands:** `SET_GAIN [dB]`, `SET_FREQ [Hz]`, `GET_STATUS`.
  - **Response:** Packetized data containing ADC lock status, temperature, voltage rails.
- **Control Logic:** The MCU uses standard `D+/D-` lines connected to the ISOW7842 side A. Side B connects to the USB connector.

### 9.2 High Speed Communication Interface
- **Interface:** JESD204B Subclass 1
- **Lanes:** 2 Lanes (Lane 0, Lane 1)
- **Data Rate:** 12 Gbps per lane (configured via LMK04828)
- **Signals:** JESD_C_P/N, JESD_D0_P/N, JESD_D1_P/N, JESD_SYNC_P/N.
- **Logic:** The MCU configures the AD9208 SPI registers to enable the JESD204B link. The LMK04828 provides the device clock and SYSREF for synchronization.
- **Connection:** Direct LVDS connection from AD9208 to Samtec SEARAY (J5). MCU does not process high-speed data but monitors the SYNC signal status for link integrity.

### 9.3 Power On/Off Sequence
#### 9.3.1 Power ON/OFF Sequence
1. **+28V Applied:** J4 receives power.
2. **Enable Sequence:** ADP5054 (U12) enables rails in priority order:
    - T0: +5V (Analog/LO)
    - T1 + 1ms: +3.3V (MCU/Digital IO)
    - T2 + 5ms: +1.8V and +1.2V (ADC rails)
3. **MCU Reset:** MCU_RESET_N released high.
4. **Init:** MCU initializes I2C/SPI. Checks `PWR_GOOD` and `ADC_LOCK_STATUS`.
5. **RF Enable:** If status OK, asserts `PA_ENABLE` and `LNA_VDD` (via `RF_SHUTDOWN` logic).
6. **Ready:** System enters RX mode.

#### 9.3.2 Mode Configuration
| Mode | Signal | Value | Description |
|------|--------|-------|-------------|
| Normal | MODE_SEL | High | Default operational mode |
| BIST | MODE_SEL | Low (held at boot) | Built-in self-test mode (Loops back test patterns if supported) |
| Programming | UART CMD | `CMD_ENTER_BOOTLOADER` | Firmware upgrade mode |

### 9.4 Supply Voltage, Current & Temperature Monitoring
#### 9.4.1 Supply Voltage and Current Monitoring
- **Method:** ADP5054 provides I2C telemetry for voltage and current.
- **Interface:** I2C (SMBus) at 100 kHz.
- **Monitored Rails:** +5V, +3.3V, +1.8V, +1.2V.
- **Thresholds:** Over-Current (OCP) and Under-Voltage (UVP) flags are latched in the PMIC and polled by the MCU.

#### 9.4.2 Temperature Monitoring
- **Primary Sensor:** AD9208 internal temperature sensor (read via SPI).
- **Secondary Sensor:** LMK04828 internal sensor.
- **MCU Action:** If Temp > +85°C, assert `RF_SHUTDOWN` low (Attenuate/LNA Off) to protect hardware. Send warning via UART.

### 9.5 Flash & Interfaces
#### 9.5.1 Configuration EEPROM
- **Part Number:** 24AA256 (32KB)
- **Interface:** I2C (Address 0x50).
- **Purpose:** Stores gain calibration tables (lookup tables mapping dB to VGA hex codes), frequency compensation tables, and serial number.
- **Access:** Read by MCU at startup to apply calibration to HMC698 and ADF5355.

### 9.6 RF Gain Control
- **Components:** HMC698LP4 (U3, U4).
- **Interface:** SPI (Chip Selects: `VGA1_CS`, `VGA2_CS`).
- **Resolution:** 1 dB steps (5-bit control word).
- **Range:** 0 dB to 31 dB per VGA. Total system gain adjustable from -20 to +60 dB via cascaded stages.
- **Logic:** MCU translates desired `SET_GAIN [dB]` command into SPI words:
  - SPI Word: `[Address (8bit) | Data (8bit)]`
  - Data: `Gain Setting (5b) | Shadow (1b) | Rsvd (2b)`

### 9.7 Frequency Synthesis (PLL) Control
- **Component:** ADF5355 (U7).
- **Interface:** SPI.
- **Write Sequence:**
  1. Write 4 bytes to Register 0 (Function) to program INT, FRAC, MOD.
  2. Write to Register 2 (Control) to toggle `SYNC` bit for phase resync.
- **Lock Detect:** `ADC_LOCK_STATUS` pin (MUXed with PLL_LD) polled by MCU. Operation only proceeds when Lock = High.

### 9.8 MCU Remote Programming
- **Protocol:** UART (bootloader protocol).
- **Tool:** AVRDUDE or proprietary GUI.
- **Procedure:**
  1. Host sends specific character sequence to trigger reset into bootloader.
  2. MCU erases Flash pages and writes new firmware received via UART.
  3. Verification via CRC check.
  4. Application jump.

### 9.9 Beam Steering / Advanced RF (N/A)
*Note: Not applicable for this specific receiver module (RBHJDAZ) as it is a single-channel RX without an active phased array. Functionality disabled in firmware.*

---

## Annexure A — Requirement Traceability Matrix

| S.No | Requirement ID | Description | HRS Section | GLR Section |
|-------|---------------|-------------|-------------|-------------|
| 1 | REQ-HW-001 | RF Input Frequency Range (5-18 GHz) | HRS §2 | 4 (RF Section), 9.7 (PLL) |
| 2 | REQ-HW-002 | Instantaneous Bandwidth (500M-2G) | HRS §2 | 9.2 (JESD204B Setup) |
| 3 | REQ-HW-003 | Noise Figure | HRS §2 | 9.6 (Gain Control Strategy) |
| 4 | REQ-HW-005 | Input Power Handling | HRS §2 | 4 (Limiter Desc.) |
| 5 | REQ-HW-007 | Frequency Downconversion | HRS §2 | 4 (Mixer Desc.), 9.7 (LO Config) |
| 6 | REQ-HW-013 | Reference Clock Input (10 MHz) | HRS §2 | 9.2 (LMK04828 Config) |
| 7 | REQ-HW-020 | RF Input Connector | HRS §2 | 4 (RF Input) |
| 8 | REQ-HW-021 | Input Protection | HRS §2 | 4 (Limiter/LNA) |
| 9 | REQ-HW-024 | Self-Test Capability (BIST) | HRS §2 | 9.3.2 (Mode Config), 9.9 (Monitoring) |
| 10 | GLR-001 | SPI Interface to VGA/GLL | - | 9.6, 8 (Pinout) |
| 11 | GLR-002 | I2C Interface to EEPROM | - | 9.5.1, 8 (Pinout) |
| 12 | GLR-003 | JESD204B Data Interface | - | 9.2, 8 (Pinout) |

---