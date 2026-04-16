# Glue Logic Requirements (GLR)

## Document Control
| Document Title | Glue Logic Requirements |
| :--- | :--- |
| Version Date | 16.04.2026 |
| Version Number | 0V01 |
| Prepared By | Name: AI-Gen. Sign: |
| Document Review By | Name: . Sign: |

---

## Amendments to the Document
| S. No. | Ver. No. | Ver. Date | Changed By | Section(s) Changed | Description of Change |
|:---:|:---:|:---:|:---:|:---|:---|
| 1 | 0V01 | 16.04.2026 | - | - | Initial Version |

---

## 1. Scope of the Document
This document explains the IO details and functional requirements of the FPGA for **sdfjbks**.
Targeted audience: Hardware Design and Firmware teams.

---

## 2. References

### 2.1 External
| Doc. Type | Part No. | Description |
|:---|:---|:---|
| Datasheet | ADC12DJ5200RF | 12-Bit, 5.2-GSPS, JESD204B RF ADC |
| Datasheet | ADF5356 | Microwave Wideband Synthesizer with Integrated VCO |
| Datasheet | HMC698LP4 | 6 GHz Digital Variable Gain Amplifier |
| Datasheet | LMK04828 | JESD204B Compliant Clock Jitter Cleaner/Sysref Generator |
| Datasheet | AT24C64C | 64-Kb I2C EEPROM |
| Datasheet | TPS7A4700 | 5-A, Ultra-Low Noise, High PSRR LDO |
| Datasheet | TPS62913 | 12-V input, 3-A, synchronous step-down converter |

### 2.2 Internal
| Reference | Document |
|:---|:---|
| [HRS] | Hardware Requirements Specification |
| [SCH] | Schematic |
| [GRS] | General Requirements Specification |
| [GDD] | General Design Document |

---

## 3. Acronyms and Abbreviations
| Acronym | Expansion |
|:---|:---|
| **ADC** | Analog to Digital Converter |
| **AGC** | Automatic Gain Control |
| **BER** | Bit Error Rate |
| **BOM** | Bill of Materials |
| **CML** | Current Mode Logic |
| **DAC** | Digital to Analog Converter |
| **EMC** | Electromagnetic Compatibility |
| **FCC** | Federal Communications Commission |
| **FIFO** | First In First Out |
| **FPGA** | Field Programmable Gate Array |
| **GND** | Ground |
| **HDL** | Hardware Description Language |
| **I2C** | Inter-Integrated Circuit |
| **IO** | Input Output |
| **JESD** | JESD204B Standard |
| **LDO** | Low Dropout Regulator |
| **LNA** | Low Noise Amplifier |
| **LO** | Local Oscillator |
| **LUT** | Look Up Table |
| **PCB** | Printed Circuit Board |
| **PLL** | Phase Locked Loop |
| **PSRR** | Power Supply Rejection Ratio |
| **RF** | Radio Frequency |
| **RoHS** | Restriction of Hazardous Substances |
| **RTL** | Register Transfer Level |
| **RX** | Receive |
| **SERDES** | Serializer/Deserializer |
| **SNR** | Signal to Noise Ratio |
| **SPI** | Serial Peripheral Interface |
| **SYSREF** | System Reference |
| **UART** | Universal Asynchronous Receiver Transmitter |
| **VCC** | Voltage Common Collector |
| **VGA** | Variable Gain Amplifier |

---

## 4. Module Overview
The hardware module is a Wideband RF Receiver (5-18 GHz) utilizing a direct sampling architecture.

**RF SECTION:**
The RF chain begins with a 2.4mm connector (J1) passing through a 5-18 GHz Bandpass Filter into a HMC6180LP4E LNA (20dB gain). The signal is fed to a HMC698LP4 Digital VGA for 31dB gain control. The ADF5356 Synthesizer generates the LO for the HMC1051LP4E IQ Mixer, downconverting the signal to an IF processed by a Balun and fed into the ADC.

**DIGITAL SECTION:**
The core logic is managed by an FPGA (implied host on FMC carrier). The ADC12DJ5200RF digitizes the IF and transmits data via JESD204B (Subclass 1) to the FPGA. The FPGA also manages the LMK04828 Clock Generator (providing SYSREF/Device Clock to ADC) and configures the RF Front End (SPI to VGA, PLL, ADC) via a header interface.

**POWER SUPPLY SECTION:**
Power is sourced from a 5V input (J3). TPS62913 Step-down generates 1.8V and 1.2V rails. TPS7A4700 LDO generates a clean 3.3V rail. The 5V rail is filtered for the RF LNA and Mixer.

---

## 5. Features
- **RF Input:** 5-18 GHz wideband reception via 2.4mm connector.
- **LNA:** HMC6180LP4E providing 20dB gain and 3.5dB NF.
- **Downconversion:** HMC1051LP4E IQ Mixer with ADF5356 Synthesizer (LO).
- **Variable Gain:** HMC698LP4 Digital VGA with 1dB steps (31dB range).
- **High-Speed ADC:** ADC12DJ5200RF (12-bit, JESD204B interface).
- **Clocking:** LMK04828 JESD204B Clock Jitter Cleaner.
- **Control Interface:** SPI for RF components; I2C for EEPROM.
- **Power Management:** 5V input with onboard DC-DC regulation.

---

## 6. FPGA Description
*Note: The "FPGA" in this context refers to the glue logic requirements for the processing device receiving the FMC card (sdfjbks) or internal logic if the sdfjbks is an SoC module. Given the "FPGA Module" prompt, we assume the logical interface requirements for the device controlling this card.*

| S.NO | PARAMETERS | SPECIFICATION |
|:---:|:---|:---|
| 1 | Part Number | Kintex-7 XC7K325T-FFG900 (Example Host Device) |
| 2 | Logic Cells | 326,000 |
| 3 | CLB Flip-Flops | 407,600 |
| 4 | Number of Gates | - |
| 5 | Maximum Distributed RAM (Kb) | 520 |
| 6 | Total Block RAM (Kb) | 16,890 |
| 7 | Maximum Single-Ended I/Os | 500 |
| 8 | Maximum DSP Slices | 840 |
| 9 | No of IO Bank | 14 |

---

## 7. Block Diagram
The system comprises an RF Front End (LNA -> VGA -> Mixer) feeding a high-speed ADC. The ADC output is serialized (JESD204B) and transmitted to the Host FPGA. A synchronous Clock Generator (LMK04828) ensures deterministic latency. An FPGA/MCU controls the gain (VGA), frequency (PLL), and capture mode (ADC) via SPI.

---

## 8. Pinout Details

**Table: FPGA Pin Out Details**

| S.No | Signal Name | Pin No | Voltage Level | Direction wrt FPGA | Source | Destination | Default Condition | Voltage Standard |
|:---:|:---|:---:|:---|:---|:---|:---|:---|:---|
| 1 | VCC_5V | - | 5.0V | PWR | Supply | J3 | - | - |
| 2 | GND | - | 0V | PWR | Supply | J3 | - | - |
| 3 | VCC_3V3 | - | 3.3V | PWR | LDO | FPGA_IO | - | - |
| 4 | VCC_1V8 | - | 1.8V | PWR | DCDC | FPGA_IO | - | - |
| 5 | VCC_1V2 | - | 1.2V | PWR | DCDC | FPGA_CORE | - | - |
| 6 | SPI_CLK | 5 | 3.3V | OUT | FPGA | Header/J3 | Low | LVCMOS33 |
| 7 | SPI_MOSI | 7 | 3.3V | OUT | FPGA | Header/J3 | Low | LVCMOS33 |
| 8 | SPI_MISO | 9 | 3.3V | IN | Header/J3 | FPGA | High-Z | LVCMOS33 |
| 9 | SPI_CS_ADC_N | 11 | 3.3V | OUT | FPGA | Header/J3 | High | LVCMOS33 |
| 10 | SPI_CS_PLL_N | 13 | 3.3V | OUT | FPGA | Header/J3 | High | LVCMOS33 |
| 11 | SPI_CS_VGA_N | 15 | 3.3V | OUT | FPGA | Header/J3 | High | LVCMOS33 |
| 12 | I2C_SCL | 17 | 3.3V | BIDIR | FPGA | EEPROM (U10) | High | LVCMOS33 |
| 13 | I2C_SDA | 19 | 3.3V | BIDIR | FPGA | EEPROM (U10) | High | LVCMOS33 |
| 14 | RESET_N | 21 | 3.3V | OUT | FPGA | ADC/PLL | High | LVCMOS33 |
| 15 | JESD_TX0_P | 25 | 1.2V/3.3V | IN | ADC (U4) | FPGA | Idle | CML_1.2V |
| 16 | JESD_TX0_N | 27 | 1.2V/3.3V | IN | ADC (U4) | FPGA | Idle | CML_1.2V |
| 17 | JESD_TX1_P | 29 | 1.2V/3.3V | IN | ADC (U4) | FPGA | Idle | CML_1.2V |
| 18 | JESD_TX1_N | 31 | 1.2V/3.3V | IN | ADC (U4) | FPGA | Idle | CML_1.2V |
| 19 | JESD_SYNC_P | 33 | LVDS | OUT | FPGA | ADC (U4) | Low | LVDS |
| 20 | JESD_SYNC_N | 35 | LVDS | OUT | FPGA | ADC (U4) | Low | LVDS |
| 21 | CLK_REF_IN | 37 | LVDS | OUT | FPGA | LMK (U8) | Clk | LVDS |
| 22 | SYSREF | 39 | LVDS | BIDIR | FPGA <-> LMK | Idle | LVDS |
| 23 | UART_TX | 41 | 3.3V | OUT | FPGA | Debug Header | High | LVCMOS33 |
| 24 | UART_RX | 43 | 3.3V | IN | Debug Header | FPGA | High | LVCMOS33 |
| 25 | LED_STATUS | 45 | 3.3V | OUT | FPGA | LED | Low | LVCMOS33 |
| 26 | TRP | 47 | 3.3V | OUT | FPGA | RF Enable | Low | LVCMOS33 |
| 27 | TEMP_ALERT | 49 | 3.3V | IN | Sensor | FPGA | Low | LVCMOS33 |
| 28 | FPGA_PG | 51 | 3.3V | IN | PMIC | FPGA | Low | LVCMOS33 |
| 29 | CLK_ADC_IN | 53 | LVDS | OUT | LMK | ADC | Clk | LVDS |
| 30 | VIN_MON | A0 | 0-5V | IN | Supply | FPGA_ADC | - | - |
| 31 | IIN_MON | A1 | 0-5V | IN | Sense Amp | FPGA_ADC | - | - |
| 32 | MODE_0 | 55 | 3.3V | IN | Dip/Header | PullUp | LVCMOS33 |
| 33 | MODE_1 | 57 | 3.3V | IN | Dip/Header | PullUp | LVCMOS33 |
| 34 | JTAG_TCK | 60 | 3.3V | IN | Debugger | FPGA | - | LVCMOS33 |
| 35 | JTAG_TDI | 62 | 3.3V | IN | Debugger | FPGA | - | LVCMOS33 |
| 36 | JTAG_TDO | 64 | 3.3V | OUT | FPGA | Debugger | - | LVCMOS33 |
| 37 | JTAG_TMS | 66 | 3.3V | IN | Debugger | FPGA | - | LVCMOS33 |

---

## 9. Functional Specifications

**Summary table:**

| S.No. | Function Name | Description |
|:---:|:---|:---|
| 1 | JESD204B Interface | 2-Lane, 12.5 Gbps lane rate, Subclass 1 deterministic latency |
| 2 | Clock Distribution | LMK04828 SYSREF generation & Device Clock distribution |
| 3 | RF Front End Control | SPI control of VGA (HMC698) and PLL (ADF5356) |
| 4 | ADC Interface Control | SPI Configuration of ADC12DJ5200RF |
| 5 | Serial Communication | UART (115200 baud) for register access & debug |
| 6 | Power Monitoring | I2C (PMBus) monitoring of rails (1.2V, 1.8V, 3.3V, 5V) |
| 7 | Non-Volatile Storage | I2C EEPROM for configuration/gain table storage |
| 8 | AGC Algorithm | Internal AGC loop adjusting VGA gain based on ADC power |
| 9 | System Reset | Power-on reset and software controlled reset sequence |

### 9.1 JESD204B Interface
- **Interface:** JESD204B Subclass 1
- **Lanes:** 2 lanes (Lane 0, Lane 1)
- **Lane Rate:** 12.5 Gbps
- **Mappers:** ADC12DJ5200RF configured in Dual Channel Mode.
- **Scrambling:** Enabled.
- **SYSREF:** Continuous SYSREF generated by LMK04828, synchronized by FPGA.
- **SYNC~:** FPGA drives SYNC~ to ADC to establish alignment.

### 9.2 Clock Distribution
- **Device:** LMK04828BKNTE.
- **Input Reference:** 10 MHz or 122.88 MHz from FPGA or Header.
- **Output:** CLK_ADC_IN (LVDS) to ADC sample clock input.
- **SYSREF:** Used for aligning the JESD204B local multi-frame clocks (Subclass 1).
- **SPI:** Configuration via FPGA SPI Master.

### 9.3 RF Front End Control
- **LNA:** Fixed gain (HMC6180LP4E), enabled by Power Rail.
- **VGA (HMC698LP4):** Controlled via dedicated SPI_CS_VGA_N line.
    - Gain range: 31dB.
    - Steps: 1dB.
    - Interface: 8-bit parallel-to-serial load (via FPGA GPIO or SPI bridge).
- **PLL (ADF5356):** Controlled via SPI_CS_PLL_N.
    - Frequency range: 5.4 GHz to 18 GHz (assuming LO > RF).
    - Interface: 3-wire Serial (CLK, MOSI, CS/N).

### 9.4 Power Supply Monitoring
- **Monitor IC:** On-chip ADC or external I2C monitor (e.g., UCD90120 implied by monitoring req).
- **Rails Monitored:** +5V, +3.3V, +1.8V, +1.2V.
- **Thresholds:** Over-voltage and Under-voltage detection with interrupt alert.

### 9.5 AGC (Automatic Gain Control)
- **Input:** ADC RMS power level (calculated in FPGA DSP).
- **Loop:** Digital integrator adjusts HMC698 gain index.
- **Rate:** Update rate < 10us.

### 9.6 EEPROM / NVM
- **Device:** AT24C64C (64-Kb).
- **Interface:** I2C (400kHz).
- **Content:** Default PLL frequencies, Gain Table calibration data, Board MAC ID.

---

## 10. Software Register Address Map

### 10.1 Register Base Addresses

| Block Name | Base Address | Address Range | Description |
|:---|:---:|:---|:---|
| System / Identification | 0x0000 | 0x0000–0x00FF | Board ID, firmware version, status |
| JESD204B Control | 0x0100 | 0x0100–0x01FF | Lane status, SYNC~ control, error count |
| SPI Master Control | 0x0200 | 0x0200–0x02FF | SPI config, TX FIFO, RX data |
| RF Control | 0x0300 | 0x0300–0x03FF | VGA Gain, PLL Frequency, Enable |
| ADC Interface | 0x0400 | 0x0400–0x04FF | Decimation, Test Pattern, Format |
| I2C Master | 0x0500 | 0x0500–0x05FF | I2C config for EEPROM/Monitor |
| GPIO / General | 0x0600 | 0x0600–0x06FF | LED, TRP, Mode Pins |
| Power Monitor | 0x0700 | 0x0700–0x07FF | Voltage/Current readings |
| Diagnostics | 0x0A00 | 0x0A00–0x0AFF | Temperature, Uptime, CRC errors |

### 10.2 Detailed Register Map

**Block 0x0000 — System / Identification**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|:---|:---|:---:|:---:|:---:|:---|
| 0x00 | BOARD_ID | 16 | R | 0x5BF6 | Unique ID for 'sdfjbks' hardware |
| 0x01 | FW_VERSION | 16 | R | 0x0100 | Firmware Major.Minor |
| 0x02 | SYS_STATUS | 16 | R | 0x0000 | [15:8] Reserved, [7] PLL_LOCKED, [6] JESD_ALIGNED, [5] TEMP_OK, [4:0] Reserved |
| 0x03 | SYS_RESET | 16 | W | 0x0000 | [0] SOFT_RESET (Self-clearing) |

**Block 0x0300 — RF Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|:---|:---|:---:|:---:|:---:|:---|
| 0x00 | VGA_GAIN_CTRL | 8 | R/W | 0x0F | 5-bit Gain Code (0-31) for HMC698LP4 |
| 0x01 | PLL_INT_DIV | 16 | R/W | 0x0064 | ADF5356 Integer Divider (N) |
| 0x02 | PLL_FRAC_DIV | 24 | R/W | 0x000000 | ADF5356 Fractional Divider |
| 0x03 | RF_ENABLE | 8 | R/W | 0x00 | [0] TX_ENABLE (TRP control), [1] RX_ENABLE |
| 0x04 | AGC_ENABLE | 8 | R/W | 0x00 | [0] AGC Loop Enable |
| 0x05 | AGC_TARGET | 16 | R/W | 0x8000 | Target ADC code (-3dBFS) |

**Block 0x0100 — JESD204B Control**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|:---|:---|:---:|:---:|:---:|:---|
| 0x00 | LANE_STATUS | 16 | R | 0x0000 | [1:0] Lane0 aligned, [3:2] Lane1 aligned |
| 0x01 | CTRL_SYNC | 8 | W | 0x00 | Writing 1 toggles SYNC_N pin to ADC |
| 0x02 | DISP_ERR | 16 | R | 0x0000 | Disparity error counter per lane |

**Block 0x0200 — SPI Master**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|:---|:---|:---:|:---:|:---:|:---|
| 0x00 | SPI_CONFIG | 16 | R/W | 0x0003 | [0] CPHA, [1] CPOL |
| 0x01 | SPI_TX_DATA | 32 | W | - | Data to shift out |
| 0x02 | SPI_RX_DATA | 32 | R | - | Data captured |
| 0x03 | SPI_CS_SEL | 8 | R/W | 0x0F | [0] CS_PLL, [1] CS_VGA, [2] CS_ADC |

**Block 0x0400 — ADC Interface**

| Offset | Register Name | Width | R/W | Reset Value | Bit-Field Description |
|:---|:---|:---:|:---:|:---:|:---|
| 0x00 | ADC_DECIM | 16 | R/W | 0x0001 | Decimation Factor (1, 2, 4...) |
| 0x01 | ADC_FORMAT | 8 | R/W | 0x00 | Output data format (Twos complement/Offset binary) |

### 10.3 Register Access Rules
- **Addressing:** 16-bit word addressing.
- **Endianness:** Big Endian for multi-byte registers.
- **Atomicity:** 16-bit writes are atomic. 32-bit writes require two 16-bit transactions.
- **Side Effects:** Writing to `PLL_INT_DIV` or `PLL_FRAC_DIV` does not update the VCO until `RF_ENABLE` is toggled or a dedicated `PLL_UPDATE` command is sent.

---

## 11. UART Register Protocol Specification

### 11.1 Physical Layer
- **Baud Rate:** 115200 bps (Configurable via divider).
- **Data Bits:** 8
- **Parity:** None
- **Stop Bits:** 1
- **Interface:** UART (TTL levels)

### 11.2 Command Frame Formats

**Single Register Write (CMD = 0x57 'W'):**
```
Byte 0: 0x57 (CMD)
Byte 1: ADDR[15:8] (address MSB)
Byte 2: ADDR[7:0]  (address LSB)
Byte 3: DATA[15:8] (data MSB)
Byte 4: DATA[7:0]  (data LSB)
→ Response: 0x06 (ACK) or 0x15 (NAK)
Total: 5 bytes TX, 1 byte RX
```

**Single Register Read (CMD = 0x52 'R'):**
```
Byte 0: 0x52 (CMD)
Byte 1: ADDR[15:8] (address MSB)
Byte 2: ADDR[7:0]  (address LSB)
→ Response: DATA[15:8], DATA[7:0]
Total: 3 bytes TX, 2 bytes RX
```

**Bulk Register Write (CMD = 0x42 'B'):**
```
Byte 0: 0x42 (CMD)
Byte 1: ADDR[15:8]
Byte 2: ADDR[7:0]
Byte 3: COUNT (Number of words)
Byte 4..: Data words...
→ Response: 0x06 (ACK) or 0x15 (NAK)
```

**Bulk Register Read (CMD = 0x62 'b'):**
```
Byte 0: 0x62 (CMD)
Byte 1: ADDR[15:8]
Byte 2: ADDR[7:0]
Byte 3: COUNT (Number of words)
→ Response: Data words...
```

### 11.3 Protocol Timing Constraints
| Parameter | Min | Typical | Max | Unit |
|:---|:---:|:---:|:---:|:---:|
| Inter-byte gap (TX) | - | - | 10 | ms |
| Response Delay | - | 0.5 | 2 | ms |

---

## 12. FPGA Resource Utilization Estimate

| Resource | Available | Estimated Usage | Utilization % |
|:---|:---:|:---:|:---:|
| Slice LUTs | 203,800 | 45,000 | 22 % |
| Slice Flip-Flops | 407,600 | 30,000 | 7 % |
| Block RAM (36Kb) | 445 | 60 | 13 % |
| DSP Slices | 840 | 40 | 4 % |
| MMCM/PLL | 10 | 2 | 20 % |

*Target Device: Kintex-7 XC7K325T - Note: Actual utilization depends on final JESD204B IP core configuration.*

---

## Annexure A — Requirement Traceability Matrix

| S.No | GLR-ID | Description | Source HRS Section | GLR Section | Verification Method | Status |
|:---:|:---:|:---|:---|:---|:---|:---|
| 1 | GLR-001 | RF Input Frequency Range (5-18 GHz) | HRS 3.1 | 4.0, 9.3 | Test | Open |
| 2 | GLR-002 | JESD204B Output Interface (3Gbps) | HRS 3.3 | 9.1, 11 | Demonstration | Open |
| 3 | GLR-003 | Power Supply 5V Input | HRS 3.4 | 4.0, 8 | Test | Open |
| 4 | GLR-004 | AGC Functionality (20dB range) | HRS 3.1 | 9.5, 10.2 | Test | Open |
| 5 | GLR-005 | I2C/SPI Control Interface | HRS 3.3 | 8, 11 | Test | Open |
| 6 | GLR-006 | Phase Noise (-100dBc/Hz) | HRS 3.2 | 9.3 (PLL) | Analysis | Open |
| 7 | GLR-007 | Operating Temp (-40 to +85) | HRS 3.5 | 9.4 (Monitor) | Test | Open |
| 8 | GLR-008 | FPGA Register Map | GLR Spec | 10 | Inspection | Open |
| 9 | GLR-009 | UART Protocol Spec | GLR Spec | 11 | Test | Open |
| 10 | GLR-010 | Pinout Verification | Schematic | 8 | Inspection | Open |