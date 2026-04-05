# Glue Logic Requirements (GLR)

## Document Control
| Document Title | Glue Logic Requirements |
| :--- | :--- |
| Version Date | 05.04.2026 |
| Version Number | 0V01 |
| Prepared By | Name: . Sign: |
| Document Review By | Name: . Sign: |

---

## Amendments to the Document
| S. No | Ver. No. | Ver. Date | Changed By | Section(s) Changed | Description of Change |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | 0V01 | 05.04.2026 | - | - | Initial Version |

---

## 1. Scope of the Document
This document explains the IO details and functional requirements of the FPGA for **hkgg**. Targeted audience: Hardware Design and Firmware teams.

**Note:** The hkgg system utilizes a mixed-signal architecture where an FPGA acts as the system controller for the RF Power Amplifier module. The FPGA manages the digital interface to the Bias DAC (MAX1167), monitors system status via GPIO (Enable, Temperature flags), and handles communication with the host system. This document bridges the gap between the hkgg Hardware Requirements (P1) and the FPGA RTL implementation.

---

## 2. References

### 2.1 External
| Doc. Type | Part No. | Description |
| :--- | :--- | :--- |
| Datasheet | MRF1511G | 12V N-Channel Enhanced Mode LDMOS RF Power Transistor |
| Datasheet | GVA-123+ | Wideband MMIC Amplifier |
| Datasheet | MAX1167 | 12-Bit DAC with Internal Reference (I2C) |
| Datasheet | IRLML6402 | P-Channel MOSFET (Logic Level) |
| Datasheet | 10WPA-SCH | hkgg Schematic (Netlist P4) |
| Datasheet | XC6SLX16 | Spartan-6 FPGA (Selected Reference) |
| Datasheet | LM75A | Digital Temperature Sensor (I2C) - *Assumed for monitoring* |

### 2.2 Internal
| Reference | Document |
| :--- | :--- |
| [HRS] | hkgg Hardware Requirements Specification |
| [SCH] | hkgg Schematic |
| [GRS] | General Requirements Specification |
| [GDD] | General Design Document |

---

## 3. Acronyms and Abbreviations

| Acronym | Expansion |
| :--- | :--- |
| **ADC** | Analog-to-Digital Converter |
| **AFC** | Automatic Frequency Control |
| **CW** | Continuous Wave |
| **DAC** | Digital-to-Analog Converter |
| **dBm** | Decibel-milliwatts |
| **EMC** | Electromagnetic Compatibility |
| **FPGA** | Field Programmable Gate Array |
| **GND** | Ground |
| **GPIO** | General Purpose Input/Output |
| **HDL** | Hardware Description Language |
| **HRS** | Hardware Requirements Specification |
| **I2C** | Inter-Integrated Circuit |
| **LDMOS** | Laterally Diffused Metal Oxide Semiconductor |
| **LUT** | Look-Up Table |
| **LVDS** | Low-Voltage Differential Signaling |
| **PA** | Power Amplifier |
| **PCB** | Printed Circuit Board |
| **PLL** | Phase Locked Loop |
| **POR** | Power On Reset |
| **RF** | Radio Frequency |
| **RTL** | Register Transfer Level |
| **SMA** | SubMiniature version A (RF Connector) |
| **SPI** | Serial Peripheral Interface |
| **UART** | Universal Asynchronous Receiver-Transmitter |
| **VCC** | Voltage Common Collector (Supply) |
| **VSWR** | Voltage Standing Wave Ratio |

---

## 4. Module Overview

The hkgg hardware module is a wideband RF power amplifier capable of delivering +40 dBm (10W) output power across 50-500 MHz. It requires digital control for biasing and safety interlocks.

### RF SECTION
The RF chain consists of two stages:
1.  **Driver Stage:** Utilizing **GVA-123+** (Mini-Circuits), a wideband MMIC amplifier providing +20dB gain. It operates directly from the +12V supply rail via an RF choke (L1).
2.  **Final Power Stage:** Utilizing **MRF1511G** (MACOM), an LDMOS transistor delivering the final +41 dBm (12W) PSAT.
3.  **Matching:** Interstage matching uses a 4:1 impedance transformer (T2). Input/Output matching uses 1:1 and 1:4 transformers respectively.

### DIGITAL SECTION
The digital section is based on an FPGA (e.g., Xilinx Spartan-6 LFX series). The FPGA functions as the system controller, performing the following tasks:
*   **Bias Control:** Sends I2C commands to the **MAX1167** DAC to set the Gate Voltage (Vgs) of the MRF1511G.
*   **RF Switching:** Controls the **IRLML6402** P-FET gate to enable/disable the +12V logic rail to the Bias circuitry.
*   **Housekeeping:** Monitors board temperature and receives the RF Enable command from an external host.

### POWER SUPPLY SECTION
*   **Main Input:** +12V DC via terminal block J3.
*   **Protection:** Reverse polarity protection via Schottky diode D1. Current limiting via PTC Fuse F1 (3.5A).
*   **Distribution:**
    *   **+12V_DRAIN:** Direct feed to the MRF1511G Drain (via L3).
    *   **+12V_DRIVER:** Feed to GVA-123+ Driver (via L1).
    *   **+12V_LOGIC:** Controlled feed via IRLML6402 switch to bias DAC circuitry.
    *   **+3.3V_REF:** Derived from the DAC MAX1167 internal reference, used as logic level for I2C pull-ups and FPGA IO reference (if applicable).

---

## 5. Features

*   **FPGA:** Xilinx XC6SLX16 (or equivalent) acting as System Controller.
*   **On-board clock oscillator:** 50 MHz CMOS Oscillator for FPGA system clock.
*   **Communication:** UART (115200 baud) for Host Control & Telemetry; I2C (400 kHz) for DAC biasing.
*   **JTAG debugging support:** Standard 14-pin or 6-pin header for FPGA programming.
*   **Bias EEPROM:** Not populated on schematic (MAX1167 is volatile, requires FPGA to program on boot).
*   **Temperature Monitoring:** LM75A (I2C) for Heatsink monitoring.
*   **RF Control:** Digital Enable path controlling RF Enable.
*   **Harmonic Filtering:** Passive Low Pass Filter (LPF) network integrated into output match.

---

## 6. FPGA Description

The FPGA must be a low-power, industrial-grade device capable of operating from +3.3V IO and +1.2V Core.

| S.NO | PARAMETERS | SPECIFICATION |
|:---|:---|:---|
| 1 | Part Number | XC6SLX16-FTG256 |
| 2 | Logic Cells | 14,579 |
| 3 | CLB Flip-Flops | 18,224 |
| 4 | Number of Gates | 1.5M (Approx ASIC Gates) |
| 5 | Maximum Distributed RAM (Kb) | 48 Kb |
| 6 | Total Block RAM (Kb) | 576 Kb (32 blocks) |
| 7 | Maximum Single-Ended I/Os | 158 |
| 8 | Maximum DSP Slices | 32 DSP48A1 |
| 9 | No of IO Bank | 4 Banks (0, 1, 2, 3) |

---

## 7. Block Diagram

**(Textual Description of Netlist Logic)**
The Host sends commands via UART to the FPGA. The FPGA processes these commands:
1.  **RF Enable:** Host sets '1'. FPGA asserts `RF_ENABLE_CTRL`. This turns off Q2 (IRLML6402), cutting ground/current to the Bias circuitry (active low logic in schematic). *Correction based on Netlist: Q2 is P-FET on high side. High logic on ENABLE_CTRL turns OFF Q2 (P-FET).*
2.  **Bias Set:** Host sends desired Gain/Duty cycle. FPGA calculates Gate Voltage via LUT. FPGA writes to MAX1167 (U2) via I2C. MAX1167 outputs `BIAS_SET` voltage, driving Q2's source to generate `PA_GATE` voltage.
3.  **Status:** FPGA reads LM75A via I2C. If Overtemp, FPGA de-asserts `RF_ENABLE`.

---

## 8. Pinout Details

**Table: FPGA Pin Out Details**

| S.No | Signal Name | Pin No (Pkg) | Voltage Level | Direction wrt FPGA | Source | Destination | Default Condition | Voltage Standard |
|:---|:---|:---|:---|:--- |:---|:---|:---|:---|
| 1 | VDD_FPGA_3V3 | Bank 0 VCCO | 3.3V | Power | LDO Regulator | FPGA Core | N/A | 3.3V |
| 2 | GND | GND Pins | 0V | GND | Common | Plane | N/A | 0V |
| 3 | FPGA_CLK_50M | C9 | 3.3V | Input | Oscillator | PLL | - | LVCMOS33 |
| 4 | JTAG_TCK | B12 | 3.3V | Input | Debugger | FPGA JTAG | Pull Down | LVCMOS33 |
| 5 | JTAG_TDI | A12 | 3.3V | Input | Debugger | FPGA JTAG | Pull Up | LVCMOS33 |
| 6 | JTAG_TDO | B13 | 3.3V | Output | FPGA JTAG | Debugger | High Z | LVCMOS33 |
| 7 | JTAG_TMS | A13 | 3.3V | Input | Debugger | FPGA JTAG | Pull Up | LVCMOS33 |
| 8 | FPGA_RESET_N | A14 | 3.3V | Input | Reset Button | System Reset | Pull Up (Active Low) | LVCMOS33 |
| 9 | POR_N | B14 | 3.3V | Input | Supervisor IC | System Reset | High | LVCMOS33 |
| 10 | UART_RX | D15 | 3.3V | Input | USB-UART | FPGA RX | Pull Up | LVCMOS33 |
| 11 | UART_TX | C15 | 3.3V | Output | FPGA TX | USB-UART | High | LVCMOS33 |
| 12 | RF_ENABLE_IN | E16 | 3.3V | Input | Host System | FPGA GPIO | Pull Down | LVCMOS33 |
| 13 | RF_ENABLE_CTRL | F16 | 3.3V | Output | FPGA GPIO | Q2 (IRLML6402) Gate | Low (OFF) | LVCMOS33 |
| 14 | I2C_SCL | G15 | 3.3V | Bi-Dir | FPGA I2C Master | U2 (MAX1167) SCL | High | LVCMOS33 |
| 15 | I2C_SDA | G16 | 3.3V | Bi-Dir | FPGA I2C Master | U2 (MAX1167) SDA | High | LVCMOS33 |
| 16 | TEMP_ALERT | H15 | 3.3V | Input | Temp Sensor | FPGA IRQ | High | LVCMOS33 |
| 17 | LED_STATUS_TX | K13 | 3.3V | Output | FPGA GPIO | LED (Green) | Low | LVCMOS33 |
| 18 | LED_STATUS_FAULT | K14 | 3.3V | Output | FPGA GPIO | LED (Red) | Low | LVCMOS33 |
| 19 | FPGA_DONE | N13 | 3.3V | Output | FPGA Internal | Ext Indicator | Low until Config Done | LVCMOS33 |
| 20 | FPGA_INIT_N | M13 | 3.3V | Output | FPGA Internal | Ext Indicator | Low | LVCMOS33 |
| 21 | TP_DAC_OUT | - | Analog | Input | Test Point | U2 DAC Out (Mon) | N/A | N/A |
| 22 | TP_I2C_SCL | - | 3.3V | Bi-Dir | FPGA I2C | TP2 (Netlist) | High | LVCMOS33 |
| 23 | TP_I2C_SDA | - | 3.3V | Bi-Dir | FPGA I2C | TP2 (Netlist) | High | LVCMOS33 |
| 24 | TP_RF_IN | - | RF | Input | J1 | U1 (Driver) | AC GND | N/A |
| 25 | TP_RF_OUT | - | RF | Output | Q1 (PA) | J2 | AC GND | N/A |
| 26 | VCCO_0 | Bank 0 VCCO | 3.3V | Power | LDO | IO Bank | N/A | 3.3V |
| 27 | VCCO_1 | Bank 1 VCCO | 3.3V | Power | LDO | IO Bank | N/A | 3.3V |
| 28 | JTAG_VREF | T1 | 3.3V | Power | LDO | JTAG Header | N/A | 3.3V |
| 29 | SPARE_GPIO_01 | P1 | 3.3V | IO | N/A | Expansion Pin | Pull Down | LVCMOS33 |
| 30 | SPARE_GPIO_02 | P2 | 3.3V | IO | N/A | Expansion Pin | Pull Down | LVCMOS33 |
| 31 | SPARE_GPIO_03 | P3 | 3.3V | IO | N/A | Expansion Pin | Pull Down | LVCMOS33 |
| 32 | SPARE_GPIO_04 | P4 | 3.3V | IO | N/A | Expansion Pin | Pull Down | LVCMOS33 |
| 33 | MRF1511_GATE_MON | R1 | Analog | Input | OpAmp Buffer | PA Gate | N/A | 0-5V (Ext ADC) |
| 34 | +12V_SENSE | S1 | Analog | Input | Divider | DC Rail | N/A | 0-5V (Ext ADC) |
| 35 | GND_PAD | Pad | 0V | GND | PCB | Heatsink | N/A | 0V |

---

## 9. Functional Specifications

**Summary table:**

| S.No. | Function Name | Description |
|:---|:---|:---|
| 1 | Serial Communication Interface | UART between Host PC & FPGA via USB-UART (Control & Telemetry) |
| 2 | I2C Master Interface | I2C control of MAX1167 DAC and LM75A Temp Sensor |
| 3 | Bias Generation & Control | Digital generation of PA Gate Bias via DAC |
| 4 | Supply & Temp Monitoring | Monitoring of 3.3V rail and Heatsink Temp |
| 5 | RF Enable Logic | Hardware interlock control of Q2 (P-FET) |
| 6 | Beam Steering Calculation | N/A (Not applicable for fixed PA, but Gain scheduling supported) |
| 7 | FPGA Remote Programming | Configuration loading via JTAG or UART (if loader implemented) |
| 8 | Fault Management | Automatic shutdown on Overtemp or Comms Loss |
| 9 | LED Indicators | Visual feedback on TX and Fault status |

Then provide DETAILED subsections:

### 9.1 Serial Communication Interface
*   **Interface type:** UART
*   **Physical layer:** TTL (3.3V CMOS)
*   **Baud rate:** 115200 bps (Configurable 9600 - 921600)
*   **Frame format:** 1 start bit, 8 data bits, 1 stop bit, no parity
*   **USB-UART converter IC:** FT232R (External to FPGA, assumed on carrier)
*   **Signals:** UART_TX (FPGA → PC), UART_RX (PC → FPGA)
*   **Protocol:** ASCII Command based.
    *   `SET_GAIN <0-100>`: Sets DAC output 0-3.3V (mapped to PA Gate bias).
    *   `SET_ENABLE <1/0>`: Toggles RF_ENABLE_CTRL.
    *   `GET_TEMP`: Returns LM75A reading.
    *   `GET_STATUS`: Returns Fault flags.

### 9.2 High Speed Communication Interface
*   **Interface:** None required for this specific RF PA module.
*   **Future:** High-speed clock output (clk_out) can be enabled on GPIO for synchronization if multiple PA modules are used.

### 9.3 Power On/Off Sequence

#### 9.3.1 Power ON/OFF Sequence
1.  **Input:** +12V DC applied to J3.
2.  **Protection:** F1 (PTC) and D1 (Schottky) protect main rail.
3.  **Sequencing:**
    *   +12V main powers L3 (Drain Choke) and L1 (Driver Choke). PA is unbiased (Off).
    *   +12V Logic rail powers Q2 Source.
    *   FPGA powers up ( assumes +3.3V and +1.2V LDOs are present on board).
    *   FPGA boots -> Initializes I2C -> Checks LM75A temp.
    *   If Safe Temp -> Wait for Host Command `SET_ENABLE 1`.
4.  **Enable:**
    *   FPGA asserts `RF_ENABLE_CTRL` (High).
    *   Q2 (P-FET) turns OFF (Wait, schematic analysis required: If Q2 is High Side Switch, Gate needs to be Low to turn ON. Assuming `RF_ENABLE_CTRL` logic is active HIGH from FPGA to Enable).
    *   *Correction:* Schematic shows Q2 (IRLML6402) as P-Channel. Source is +12V. Drain is DAC_VDD. To Turn ON Q2, Vgs must be < -4V (Gate must be ~8V). To Turn OFF Q2, Gate must be 12V.
    *   *Revised Logic:* Netlist shows `ENABLE_CTRL` connected to R4 (10k) pulling to Gate. Need level shifter or check if Q2 is used as High-side switch. Assuming FPGA drives a Transistor to pull Gate low to enable.
    *   *Alternative:* If Q2 is N-FET in schematic or P-FET logic inverted: FPGA `RF_ENABLE_CTRL` = 1 -> PA BIAS ON.

#### 9.3.2 Mode Configuration
| Mode | Signal | Value | Description |
|:---|:---|:---|:---|
| STANDBY | RF_ENABLE_CTRL | 0 | Bias Disabled. PA Off. |
| TX | RF_ENABLE_CTRL | 1 | Bias Enabled. PA Amplifying. |
| FAULT | RF_ENABLE_CTRL | 0 | Triggered by Temp/Loss of Comms. |

### 9.4 Supply Voltage, Current & Temperature Monitoring

#### 9.4.1 Supply Voltage and Current Monitoring
*   **Method:** Analog measurement via FPGA internal XADC (if available) or external ADC.
*   **Monitored rails:** +12V_MAIN (via divider to <3.3V).
*   **Measurement range:** 0V to 15V.

#### 9.4.2 Temperature Monitoring
*   **IC Part Number:** LM75A (Assumed similar to MAX1167 footprint) or onboard sensor.
*   **Interface:** I2C (Address 0x48 or 0x49).
*   **Temperature range:** -40°C to +125°C.
*   **Resolution:** 0.5°C to 0.125°C (11-bit).
*   **Alert threshold:** +85°C (Triggers FAULT, cuts Bias).

### 9.5 Flash & Interfaces
*   **Note:** No Flash specified in BOM.
*   **Implementation:** FPGA bitstream loaded from JTAG or onboard SPI Flash (if populated in footprint).
*   **Non-Volatile Settings:** MAX1167 is volatile. FPGA must write default Bias values on power-up.

### 9.6 TRP Configuration (TX Enable)
*   **Signal:** RF_ENABLE_CTRL
*   **Direction:** FPGA → Q2 (Bias Switch)
*   **Logic level:** 3.3V LVTTL
*   **Active state:** Logic HIGH = Enable Bias / LOW = Disable.
*   **Timing:** < 1us response time.
*   **Control:** Written via UART register command `SET_RF_STATE`.

### 9.7 FPGA Remote Programming
*   **Protocol:** IEEE 1149.1 JTAG.
*   **Tool:** Xilinx Vivado / iMPACT.
*   **Procedure:**
    1. Connect JTAG debugger to header.
    2. Identify device.
    3. Program Bitstream.
*   **Field Upgrade:** UART Bootloader (Optional) to load *.bit* from SD card or serial stream.

### 9.8 Phase Shifter Controlling
*   **Application:** N/A (This is a Fixed Gain Power Amp, not a Phased Array).
*   *However:* Bias Voltage control acts as "Gain Control".

### 9.9 Beam Steering Calculation
*   **Application:** N/A.

### 9.10 Gate Voltage Writing in DAC (Primary Control Loop)
*   **DAC Part Number:** MAX1167.
*   **Interface:** I2C.
*   **Address:** 0x10 (Example, depends on pin strapping).
*   **Voltage Range:** 0 to Vref (2.048V internal or 3.3V external). MRF1511G Gate requires roughly +2.5V to +4.0V for Class AB.
*   **Note:** MAX1167 output is typically 0-Vref. A Rail-to-Rail OpAmp buffer is recommended (R7 in netlist suggests gain/attenuation network).
*   **Resolution:** 12-bit (4096 steps).
*   **Procedure:**
    1. FPGA calculates desired Gate V (e.g., 3.2V for 10W).
    2. FPGA maps 3.2V to DAC Code.
    3. FPGA sends [ADDR, CMD, MSB, LSB] via I2C.
    4. Voltage settles on `PA_GATE`.

---

## Annexure A — Requirement Traceability Matrix

| S.No | Requirement ID | Description | HRS Section | GLR Section |
|:---|:---|:---|:---|:---|
| 1 | HRS-001 | RF Power Output (+40 dBm) | HRS §3.1 | 9.10 (Bias Control ensures PA meets spec) |
| 2 | HRS-002 | Gain Requirement (30dB) | HRS §3.1 | 9.10 (Gate Bias sets Gain) |
| 3 | HRS-003 | Input/Output Impedance (50 Ohm) | HRS §3.1 | N/A (Passive Hardware) |
| 4 | HRS-004 | Power Supply (+12V) | HRS §3.2 | 9.3 (Power Sequencing) |
| 5 | HRS-005 | Efficiency (35%) | HRS §3.2 | 9.10 (Optimizing Bias for PAE) |
| 6 | HRS-006 | Operating Temperature (0-70C) | HRS §3.3 | 9.4 (Temp Monitoring & Fault) |
| 7 | HRS-007 | RF Connectors | HRS §3.1 | N/A (Mechanical) |
| 8 | HRS-009 | RF Enable Control | HRS §3.1 | 9.1 & 9.6 (UART Cmd & FPGA IO) |
| 9 | HRS-010 | Harmonic Distortion | HRS §3.2 | N/A (Output Filter Hardware) |