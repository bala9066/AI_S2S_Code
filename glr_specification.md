# Glue Logic Requirements (GLR)

## Document Control
| Document Title | Glue Logic Requirements |
| :--- | :--- |
| **Project Name** | rf txrxxp |
| **Version Date** | 14.04.2026 |
| **Version Number** | 0V01 |
| **Prepared By** | Name: FPGA Lead Arch. <br> Sign: ________________ |
| **Document Review By** | Name: HW Lead Engineer <br> Sign: ________________ |

---

## Amendments to the Document
| S. No. | Ver. No. | Ver. Date | Changed By | Section(s) Changed | Description of Change |
|:---:|:---:|:---:|:---:|:---:|:---|
| 1 | 0V01 | 14.04.2026 | FPGA Lead Arch. | - | Initial Release for rf txrxxp Project |

---

## 1. Scope of the Document
This document defines the Input/Output (I/O) interfaces, signal connectivity, and functional logic requirements for the FPGA acting as the digital backbone for the **rf txrxxp** Wideband Microwave Radar Receiver.

The FPGA serves as the primary controller for the RF Front End (Gain, Synthesizer), the high-speed data link for the ADC (JESD204B/C), and the system monitor. This specification bridges the **Hardware Requirements Specification (HRS)** and the physical **Netlist**, providing the necessary constraints for the FPGA RTL design.

---

## 2. References

### 2.1 External
| Doc. Type | Part No. | Description |
|:---|:---|:---|
| Datasheet | **ADC12DJ3200** | 12-Bit, 6.4 GSPS, Dual-Channel ADC (Texas Instruments) |
| Datasheet | **ADF5356** | Wideband Synthesizer with Integrated VCO (Analog Devices) |
| Datasheet | **HMC698LP4** | 6-18 GHz Digital VGA, 4-bit Parallel Control (Analog Devices) |
| Datasheet | **LT1963A-3.3** | 1.5A, Low Noise LDO Regulator |
| Datasheet | **LT1963A-1.8** | 1.5A, Low Noise LDO Regulator |
| Datasheet | **ADA4898-1** | High Voltage, Low Noise, Low Distortion Op-Amp |
| Datasheet | **XCZU4EV** | (Example Target) Zynq UltraScale+ MPSoC (or selected FPGA) |
| Standard | **JESD204B** | JEDEC Standard for High-Speed Serial Interface |

### 2.2 Internal
| Reference | Document |
|:---|:---|
| [HRS] | Hardware Requirements Specification (rf txrxxp) |
| [SCH] | rf txrxxp Schematic Capture |
| [GRS] | General Requirements Specification |
| [GDD] | General Design Document |

---

## 3. Acronyms and Abbreviations

| Acronym | Expansion |
|:---|:---|
| **ADC** | Analog-to-Digital Converter |
| **AGC** | Automatic Gain Control |
| **BGA** | Ball Grid Array |
| **CLB** | Configurable Logic Block |
| **DAC** | Digital-to-Analog Converter |
| **DMA** | Direct Memory Access |
| **DSP** | Digital Signal Processing |
| **EMC** | Electromagnetic Compatibility |
| **FF** | Flip-Flop |
| **FIFO** | First-In-First-Out |
| **FMC** | FPGA Mezzanine Card |
| **FPGA** | Field Programmable Gate Array |
| **GPIO** | General Purpose Input/Output |
| **HDL** | Hardware Description Language |
| **I2C** | Inter-Integrated Circuit |
| **IIP3** | Third-order Input Intercept Point |
| **JTAG** | Joint Test Action Group |
| **JESD** | JESD204 (Standard for ADC interface) |
| **LED** | Light Emitting Diode |
| **LNA** | Low Noise Amplifier |
| **LO** | Local Oscillator |
| **LUT** | Look-Up Table |
| **LDO** | Low Dropout Regulator |
| **LVDS** | Low Voltage Differential Signaling |
| **PCB** | Printed Circuit Board |
| **PLL** | Phase Locked Loop |
| **RTL** | Register Transfer Level |
| **SFDR** | Spurious-Free Dynamic Range |
| **SPI** | Serial Peripheral Interface |
| **UART** | Universal Asynchronous Receiver-Transmitter |
| **VCC** | Voltage Common Collector (Supply) |
| **VCO** | Voltage Controlled Oscillator |
| **GND** | Ground |

---

## 4. Module Overview

The **rf txrxxp** module is a high-performance microwave receiver designed for 5-18 GHz radar applications.

### RF SECTION
The RF chain comprises a wideband input limiter (**GVA-123+**), followed by a low-noise amplifier (**TQP3M9036**) providing ~20 dB gain. A variable gain amplifier (**HMC698LP4**) provides digital gain control steps via a 4-bit parallel interface (30 dB range). The signal is downconverted using the **HMC1050** mixer driven by an **ADF5356** wideband synthesizer (LO). The IF output is filtered and conditioned by the **ADA4898-1** op-amp before digitization.

### DIGITAL SECTION
The **ADC12DJ3200** digitizes the IF signal at >1 GSPS (configurable up to 3.2 GSPS per channel). Data is transmitted to the FPGA via the JESD204B/C high-speed serial interface. The FPGA processes the data, buffers it, and controls the RF front end.
*   **Control Logic:** SPI interface to configure the ADF5356 synthesizer.
*   **Gain Control:** 4-bit parallel GPIO to control the HMC698LP4 VGA.
*   **Monitoring:** Feedback monitoring of Power Good (PG) signals and Clock Detect.

### POWER SUPPLY SECTION
The system operates from a +12V DC input (Barrel Jack). Internal LDO regulators (**LT1963A-3.3** and **LT1963A-1.8**) generate clean 3.3V and 1.8V rails for the analog and digital circuitry.
*   **VCC_3V3:** Primary supply for FPGA IO, Synthesizer, and ADC Logic.
*   **VCC_1V8:** Supply for ADC driver and specific FPGA banks.
*   **VCC_5V:** Derived from input, feeds LNA and VGA.

---

## 5. Features

*   **FPGA Target:** Xilinx Kintex-7 / Zynq UltraScale+ (or equivalent) supporting >6.6 Gbps transceivers.
*   **High-Speed ADC:** Texas Instruments **ADC12DJ3200** (12-bit, Dual-channel, up to 6.4 GSPS).
*   **Data Interface:** **JESD204B/C** Subclass 1 (deterministic latency) via FMC HPC connector lanes.
*   **RF Control:** 3-wire **SPI** interface for ADF5356 LO Synthesizer.
*   **Gain Control:** 4-bit parallel interface for **HMC698LP4** VGA (30 dB range, 2 dB steps).
*   **Clocking:** High-quality SMA clock input for ADC sample clock and FPGA reference.
*   **Power Management:** Power Good monitoring via GPIO for 3.3V and 1.8V rails.
*   **Protection:** Input Limiter (GVA-123+) handling up to 10W peak input power.
*   **Temperature:** Operational range -40°C to +85°C.

---

## 6. FPGA Description

*Selection Rationale:* The FPGA must support JESD204B IP cores capable of line rates matching the ADC12DJ3200's output (decimated or bypass modes). It requires sufficient transceivers (GTX/GTY) and logic fabric to handle the >1 GSPS data throughput.

| S.NO | PARAMETERS | SPECIFICATION |
|:---:|:---|:---|
| 1 | Part Number | **XCZU4EV-SFVC784** (Example: Zynq UltraScale+) |
| 2 | Logic Cells | ~50,000 - 100,000 (depending on final selection) |
| 3 | CLB Flip-Flops | ~200,000 |
| 4 | DSP Slices | >200 (for FIR filtering/FFT) |
| 5 | Block RAM (BRAM) | >500 Mb (for high-speed data buffering) |
| 6 | Maximum Single-Ended I/O | ~300 |
| 7 | Transceivers | 8 x GTY (Up to 12.5 Gbps) |
| 8 | Max Operating Frequency | >400 MHz (Internal Logic) |
| 9 | IO Banks | 4-6 (Separate banks for 1.8V and 3.3V) |

---

## 7. Block Diagram
*(Textual Representation of Netlist Flow)*

[RF INPUT SMA] -> (GVA-123+ Limiter) -> (TQP3M9036 LNA) -> (HMC698LP4 VGA) -> (HMC1050 Mixer)
                                                                                       ^
[ADC12DJ3200] <- (ADA4898-1 Driver) <- (Balun T1/T2) <- [IF OUTPUT]                    |
     |                                                                              [ADF5356 Synth]
     |                                                                                  ^
     +---------------- [JESD204B/C] -----------------> [FPGA GTY Transceivers]      [SPI FPGA_CTRL]

[12V DC] -> [LT1963A 3.3V] -> [ADC/FPGA IO Rail]
[12V DC] -> [LT1963A 1.8V] -> [ADC Driver Rail]

---

## 8. Pinout Details

**Table: FPGA Pin Out Details**
*Based on Netlist `P4` and FMC-HPC/J3 mappings.*

| S.No | Signal Name | Pin No (Ref) | Voltage Level | Direction wrt FPGA | Source | Destination | Default Condition | Voltage Standard |
|:---:|:---|:---|:---|:---|:---|:---|:---|:---|
| 1 | **VDD_FPGA** | - | 1.0V | Power In | LDO | FPGA Core | Power Up | N/A |
| 2 | **VCCO_34** | - | 3.3V | Power In | LT1963A-3.3 | Bank 34 | Power Up | 3.3V |
| 3 | **GND** | - | 0V | GND | GND Plane | FPGA | 0V | 0V |
| 4 | **FPGA_RESET_N** | J3-Pin5 | 3.3V | Input | Ext Header | Reset Logic | Active Low Pullup | LVCMOS33 |
| 5 | **SYNTH_SCLK** | J3-Pin9 | 3.3V | Output | FPGA | ADF5356 (CLK) | Low | LVCMOS33 |
| 6 | **SYNTH_SDIO** | J3-Pin7 | 3.3V | Bi-Dir | FPGA | ADF5356 (DIO) | High Z | LVCMOS33 |
| 7 | **SYNTH_CS** | J3-Pin11 | 3.3V | Output | FPGA | ADF5356 (LE/CS) | High | LVCMOS33 |
| 8 | **VGA_G0** | J3-Pin1 | 3.3V | Output | FPGA | HMC698LP4 (G0) | Low | LVCMOS33 |
| 9 | **VGA_G1** | J3-Pin2 | 3.3V | Output | FPGA | HMC698LP4 (G1) | Low | LVCMOS33 |
| 10 | **VGA_G2** | J3-Pin3 | 3.3V | Output | FPGA | HMC698LP4 (G2) | Low | LVCMOS33 |
| 11 | **VGA_G3** | J3-Pin4 | 3.3V | Output | FPGA | HMC698LP4 (G3) | Low | LVCMOS33 |
| 12 | **ADC_JESD_RX_P** | J2-DP0_P | 1.8V | Input | ADC12DJ3200 | FPGA GTY0 | CDR Idle | HSPS16 |
| 13 | **ADC_JESD_RX_N** | J2-DP0_N | 1.8V | Input | ADC12DJ3200 | FPGA GTY0 | CDR Idle | HSPS16 |
| 14 | **ADC_JESD_RX1_P** | J2-DP1_P | 1.8V | Input | ADC12DJ3200 | FPGA GTY1 | CDR Idle | HSPS16 |
| 15 | **ADC_JESD_RX1_N** | J2-DP1_N | 1.8V | Input | ADC12DJ3200 | FPGA GTY1 | CDR Idle | HSPS16 |
| 16 | **ADC_CLK_P** | J4-Center | 1.8V | Input | Oscillator | FPGA GT Ref | 100 MHz | LVDS |
| 17 | **ADC_CLK_N** | J4-Shell | 1.8V | Input | Oscillator | FPGA GT Ref | 100 MHz | LVDS |
| 18 | **FPGA_SYNC_N** | J2-GA1 | 1.8V | Output | FPGA | ADC (SYNC~) | High | LVCMOS18 |
| 19 | **PWR_GOOD_3V3** | J3-Pin10 | 3.3V | Input | LT1963A-3.3 | FPGA Monitor | High | LVCMOS33 |
| 20 | **PWR_GOOD_1V8** | J3-Pin12 | 3.3V | Input | LT1963A-1.8 | FPGA Monitor | High | LVCMOS33 |
| 21 | **LED_STATUS** | LED D1 Anode | 3.3V | Output | FPGA | LED (Green) | Low | LVCMOS33 |
| 22 | **LED_ERROR** | LED (Ext) | 3.3V | Output | FPGA | LED (Red) | Low | LVCMOS33 |
| 23 | **SPI_SCLK_FMC** | J2-LA10 | 2.5V | Output | FPGA | FMC EEPROM | Low | LVCMOS25 |
| 24 | **SPI_MOSI_FMC** | J2-LA14 | 2.5V | Output | FPGA | FMC EEPROM | High Z | LVCMOS25 |
| 25 | **SPI_MISO_FMC** | J2-LA17_CC_P | 2.5V | Input | FPGA | FMC EEPROM | High Z | LVCMOS25 |
| 26 | **UART_TX** | J3-Pin6 | 3.3V | Output | FPGA | USB-UART | High | LVCMOS33 |
| 27 | **UART_RX** | J3-Pin8 | 3.3V | Input | USB-UART | FPGA | High | LVCMOS33 |
| 28 | **I2C_SCL** | J3-Pin13 | 3.3V | Output | FPGA | Temp Sensor (Opt) | High | OD_33 |
| 29 | **I2C_SDA** | J3-Pin14 | 3.3V | Bi-Dir | FPGA | Temp Sensor (Opt) | High | OD_33 |
| 30 | **GPI_TRIG_IN** | J3-Pin15 | 3.3V | Input | Ext Source | FPGA | Low | LVCMOS33 |
| 31 | **GPO_TRIG_OUT** | J3-Pin16 | 3.3V | Output | FPGA | Ext Scope | Low | LVCMOS33 |
| 32 | **VCCO_18** | - | 1.8V | Power In | LT1963A-1.8 | Bank 18 | Power Up | 1.8V |
| 33 | **FPGA_INIT_B** | Header | 3.3V | Output | FPGA | LED/Debug | Low (During cfg) | LVCMOS33 |
| 34 | **FPGA_DONE** | Header | 3.3V | Output | FPGA | LED/Debug | Low (Until done) | LVCMOS33 |
| 35 | **JTAG_TCK** | Header | 3.3V | Input | Programmer | FPGA JTAG | Pull Low | LVCMOS33 |
| 36 | **JTAG_TDI** | Header | 3.3V | Input | Programmer | FPGA JTAG | Pull Up | LVCMOS33 |
| 37 | **JTAG_TDO** | Header | 3.3V | Output | FPGA JTAG | Programmer | High Z | LVCMOS33 |
| 38 | **JTAG_TMS** | Header | 3.3V | Input | Programmer | FPGA JTAG | Pull Up | LVCMOS33 |

---

## 9. Functional Specifications

**Summary Table:**

| S.No. | Function Name | Description |
|:---:|:---|:---|
| 1 | **JESD204B/C Interface** | High-speed data capture from ADC12DJ3200 using Subclass 1确定性延迟. |
| 2 | **RF Gain Control** | Parallel 4-bit control of HMC698LP4 for fine gain steps. |
| 3 | **LO Synthesizer Control** | SPI configuration of ADF5356 for frequency tuning (5-18 GHz band). |
| 4 | **Power Sequencing** | Monitoring of PWR_GOOD signals to enable RF path only when supplies are stable. |
| 5 | **Clock Distribution** | Management of ADC Sample Clock and FPGA Reference Clock. |
| 6 | **UART Command Interface** | Control interface for host PC (Gain/Set Frequency commands). |
| 7 | **FMC Initialization** | Automatic read of FMC EEPROM to identify carrier card. |
| 8 | **Data Processing** | Decimation/Filtering (Optional in GLR, defined in GDD). |
| 9 | **Safety Interlock** | Monitoring of temperature/current if sensors are present. |

### 9.1 JESD204B/C Interface (Primary Data Path)
*   **Standard:** JESD204B (Revision C compatible).
*   **Lanes:** 2 Lanes (ADC12DJ3200 Dual Channel Mode).
*   **Line Rate:** Configurable 6.144 Gbps to 12.288 Gbps depending on ADC Decimation.
*   **FPGA Transceiver:** GTX/GTY set to AC coupling.
*   **Subclass:** Subclass 1 (SYSREF required for deterministic latency).
*   **Bits per Sample:** 12-bit (mapped to 16-bit words).
*   **Scrambling:** Enabled (as per TI ADC recommendation).
*   **SYNC~ Signal:** FPGA monitors ADC SYNC~. If asserted, FPGA re-initializes the IP core.

### 9.2 RF Gain Control (HMC698LP4)
*   **Interface Type:** 4-bit Parallel (Not SPI).
*   **Gain Range:** 30 dB total.
*   **Step Size:** ~2 dB per step.
*   **Logic:**
    *   '0000' = Minimum Gain (approx 0-2 dB).
    *   '1111' = Maximum Gain (approx 30-31 dB).
*   **Latency:** Changes occur within <10 ns of pin toggle.

### 9.3 LO Synthesizer Control (ADF5356)
*   **Interface Type:** SPI (3-wire: SCLK, SDIO, CS).
*   **Clock Freq (SCLK):** Max 20 MHz (FPGA must throttle generic SPI).
*   **Register Map:** Refer to ADF5356 Datasheet (Reg 0 to Reg 12).
*   **Functionality:**
    *   FPGA writes frequency (RFout) and divider settings to registers.
    *   **INT/FRAC** mode calculation must be performed by FPGA (or host software).
    *   **MUXOUT** monitoring (optional) for lock detection if connected.

### 9.4 Power On/Off Sequence
**Power ON Sequence:**
1.  +12V DC Applied.
2.  LT1963A Regulators enable. Wait for **PWR_GOOD_3V3** and **PWR_GOOD_1V8** to assert HIGH.
3.  FPGA finishes configuration (FPGA_DONE = HIGH).
4.  FPGA Initializes JESD204B IP (Send SYNC~ pulses).
5.  FPGA Configures ADF5356 to default frequency.
6.  FPGA Sets VGA to Safe Gain (Mid-range).
7.  **RF_ENABLE** signal (Internal or External) can be asserted.

**Power OFF Sequence:**
1.  Host/FPGA sets VGA to Minimum Gain (Attenuation).
2.  Disable ADF5356 RF Output (Mute Register).
3.  System Power removed.

### 9.5 UART Command Interface (Host Comms)
*   **Baud Rate:** 115200 bps (standard), configurable up to 921600.
*   **Data Format:** 8N1.
*   **Protocol:** ASCII or Binary packets.
    *   `SET_GAIN [0-15]`: Sets VGA pins.
    *   `SET_FREQ [Hz]`: Triggers calculation and SPI write to ADF5356.
    *   `GET_STATUS`: Returns ADC lock status, Temp, PG flags.

### 9.6 ADC Clocking
*   **Source:** External SMA Input (J4) or FMC oscillator.
*   **Frequency:** 122.88 MHz or variable (depending on decimation).
*   **Buffering:** FPGA clock capable input (CC pin) used to route to GT Transceiver refclk.

### 9.7 FMC Interface Management
*   **EEPROM Read:** FPGA must read I2C EEPROM on FMC carrier (if present) to check compatibility.
*   **PSen:** Connected to VADJ supplies.

### 9.8 Logic Level Constraints
*   **ADF5356 SPI:** 3.3V Logic (VCCIO = 3.3V).
*   **HMC698 VGA:** 3.3V Logic.
*   **ADC JESD:** 1.8V VCCIO (requires bank voltage set to 1.8V).

### 9.9 Remote Programming / Update
*   Supports bitstream update via JTAG or UART (if specific IP like MultiBoot is implemented).
*   Golden image in Flash (QSPI) fallback mechanism.

---

## Annexure A — Requirement Traceability Matrix

| S.No | Requirement ID | Description | HRS Section | GLR Section |
|:---:|:---|:---|:---|:---|
| 1 | REQ-HW-001 | Frequency Range (5-18 GHz) | HRS §3.1 | 9.3 (Synth Control) |
| 2 | REQ-HW-002 | Noise Figure (6-10 dB) | HRS §3.1 | 9.2 (Gain Control) |
| 3 | REQ-HW-003 | Dynamic Range (>80 dB) | HRS §3.1 | 9.1 (JESD Interface) |
| 4 | REQ-HW-005 | ADC Sampling Rate (>1 GSPS) | HRS §3.1 | 9.1 (JESD Interface) |
| 5 | REQ-HW-007 | Gain Control (30-40 dB) | HRS §3.1 | 9.2 (HMC698 Logic) |
| 6 | REQ-HW-008 | Input VSWR (<2.0:1) | HRS §3.1 | (Hardware Constraint - N/A for Logic) |
| 7 | REQ-HW-015 | LO Phase Noise | HRS §3.1 | 9.3 (Synth Programming) |
| 8 | HRS-FUNC-01 | JESD204B Data Transfer | HRS §3.2 | 9.1 |
| 9 | HRS-FUNC-02 | SPI Serial Control | HRS §3.2 | 9.3 |
| 10 | HRS-FUNC-03 | Power Sequencing | HRS §3.2 | 9.4 |
| 11 | HRS-FUNC-04 | UART Interface | HRS §3.2 | 9.5 |

---
**End of Document**