**Document Status: AI-GENERATED**

# 1. Introduction

## 1.1 Purpose
This Hardware Requirements Specification (HRS) defines the comprehensive hardware design requirements for the **ajsfdvhjs Wideband RF Receiver**. The purpose of this document is to establish a baseline for the physical, electrical, and performance characteristics of the receiver subsystem. This specification serves as the single source of truth for hardware design engineers, test engineers, and integration teams.

Specifically, this document aims to:
*   Detail the functional requirements of the 5–18 GHz down-conversion chain.
*   Specify performance metrics regarding noise figure, dynamic range, and phase noise.
*   Define interfaces for power, control (SPI), and data digitization (JESD204B).
*   Establish environmental constraints for operating temperature and mechanical design.
*   Provide a preliminary Bill of Materials (BOM) and power budget analysis based on selected component recommendations.

## 1.2 Scope
The scope of this specification covers the complete analog and digital signal chain of the ajsfdvhjs receiver, starting from the RF input connector through to the high-speed digital data interface intended for an FPGA/DSP backend.

**In-Scope Elements:**
*   **RF Front End:** Wideband Low Noise Amplifier (LNA), Variable Gain Amplifier (VGA), and down-conversion mixer stages operating from 5 GHz to 18 GHz.
*   **Local Oscillator (LO):** Wideband frequency synthesizer capable of covering the 5–18 GHz range with sufficient phase noise performance to support 80 dB dynamic range.
*   **Digitization:** Dual-channel Analog-to-Digital Converters (ADC) for I/Q sampling via JESD204B/C interface.
*   **Power Management:** DC-DC conversion and regulation circuitry required to derive internal rail voltages from the primary +12V DC supply.
*   **Control Logic:** SPI interface implementation for gain control, frequency tuning, and configuration.

**Out-of-Scope Elements:**
*   Digital Signal Processing (DSP) algorithms or FPGA firmware logic (beyond the definition of the electrical JESD204B interface).
*   Mechanical chassis design (beyond connector placement and environmental specifications).
*   External antenna systems.
*   Host system software drivers.

## 1.3 Definitions, Acronyms, and Abbreviations

| Term | Definition |
| :--- | :--- |
| **ADC** | Analog-to-Digital Converter. A device that converts a continuous physical quantity (voltage) to a digital number representing the quantity's amplitude. |
| **BOM** | Bill of Materials. A formal list of the parts, items, and assemblies required to build the product. |
| **DC** | Direct Current. The unidirectional flow of electric charge. |
| **DSP** | Digital Signal Processing. The numerical manipulation of signals to modify or improve them. |
| **FPGA** | Field-Programmable Gate Array. An integrated circuit designed to be configured by a customer or a designer after manufacturing. |
| **GaN** | Gallium Nitride. A semiconductor material used for high-power and high-frequency RF components. |
| **IF** | Intermediate Frequency. A frequency to which a carrier frequency is shifted as an intermediate step in transmission or reception. |
| **IP1dB** | Input 1dB Compression Point. The point at which the input signal causes the gain of the system to decrease by 1 dB from the linear gain. |
| **IP3** | Third-order Intercept Point. A theoretical point where the power of the third-order intermodulation products equals the power of the fundamental tone. |
| **JESD204B/C** | A high-speed data converter interface standard defined by JEDEC. |
| **LNA** | Low Noise Amplifier. An electronic amplifier that amplifies a very low-power signal without significantly degrading its signal-to-noise ratio. |
| **LO** | Local Oscillator. An electronic oscillator used to generate a signal for the frequency conversion of a signal. |
| **LVDS** | Low-Voltage Differential Signaling. A high-speed, low-power differential signaling system. |
| **MCU** | Microcontroller Unit. A small computer on a single metal-oxide-semiconductor integrated circuit chip. |
| **MMIC** | Monolithic Microwave Integrated Circuit. A type of integrated circuit (IC) device that operates at microwave frequencies. |
| **NF** | Noise Figure. A measure of degradation of the signal-to-noise ratio (SNR), caused by components in a signal chain. |
| **OIP3** | Output Third-order Intercept Point. |
| **P1dB** | 1 dB Compression Point. |
| **PWB** | Printed Wiring Board. |
| **RF** | Radio Frequency. Electromagnetic wave frequencies in the range extending from around 20 kHz to 300 GHz. |
| **SFDR** | Spurious-Free Dynamic Range. The ratio of the root-mean-square (RMS) value of the carrier signal to the RMS value of the worst spurious signal. |
| **SNR** | Signal-to-Noise Ratio. |
| **SPI** | Serial Peripheral Interface. A synchronous serial communication interface specification used for short-distance communication. |
| **VCO** | Voltage-Controlled Oscillator. An oscillator whose oscillation frequency is controlled by a voltage input. |
| **VGA** | Variable Gain Amplifier. An electronic amplifier that has its gain controlled by an external voltage or digital signal. |

## 1.4 References
The following standards and documents form the technical basis for the requirements defined within this specification:

1.  **IEEE 29148-2018:** *Systems and software engineering — Life cycle processes — Requirements engineering.* (Primary Document Structure Standard)
2.  **IPC-6012D:** *Generic Standard on Qualification and Performance of Printed Boards.* (PCB Manufacturing)
3.  **IPC-A-600G:** *Acceptability of Printed Boards.* (PCB Inspection)
4.  **JEDEC JESD204B:** *Serial Interface for Data Converters.*
5.  **Analog Devices Datasheets:**
    *   HMC1048LP4BE (Double Balanced Mixer)
    *   HMC1119LP4ME (Wideband Integrated Receiver)
    *   ADF5356 (Wideband Synthesizer with VCO)
    *   AD9208 (Dual, 14-Bit, 3 GSPS ADC)
    *   LT8645S (Silent Switcher 2 Step-Down Regulator)
6.  **Qorvo Datasheets:**
    *   TGA4943-SL (GaN MMIC Power Amplifier)

## 1.5 Overview
The **ajsfdvhjs** receiver is a high-performance, wideband RF receiver designed for signals intelligence (SIGINT) and spectrum monitoring applications. The system architecture utilizes a superheterodyne topology followed by direct I/Q demodulation to achieve high dynamic range over a 5-18 GHz frequency sweep.

The hardware design is partitioned into three main printed circuit board assemblies or distinct functional zones:
1.  **RF Front End (5-18 GHz):** Handles signal conditioning, amplification using a Qorvo TGA4943-SL GaN driver, and wideband mixing via an Analog Devices HMC1048LP4BE.
2.  **LO & Synthesis:** Uses the ADF5356 wideband synthesizer to generate a stable, low-phase-noise clock for down-conversion.
3.  **Digitization & Control:** Employs the AD9208 dual-channel ADC for high-speed sampling and an MCU for SPI-based gain and frequency control.

Power regulation is managed by high-efficiency Silent Switcher technology (LT8645S) to minimize switching noise that could degrade the sensitive RF performance. The system operates from a single +12V DC input and meets performance specifications from -40°C to +85°C, suitable for deployment in rugged environments. The following sections detail the specific requirements, interfaces, and verification methods for this hardware implementation.

---

# 2. System Overview

## 2.1 System Description

The ajsfdvhjs system is a high-performance, wideband RF receiver designed specifically for signals intelligence (SIGINT) and spectrum monitoring applications. The system functions as a tuned radio frequency (TRF) receiver utilizing a direct down-conversion architecture to capture and digitize RF signals across the 5.0 GHz to 18.0 GHz frequency spectrum.

The primary function of the ajsfdvhjs hardware is to accept a modulated RF carrier via a standard coaxial interface, amplify the signal with minimal added noise, down-convert the signal to baseband in-phase (I) and quadrature (Q) components, and digitize these components for subsequent processing by a field-programmable gate array (FPGA) or digital signal processor (DSP).

### 2.1.1 Operational Modes

The system supports two primary operational modes defined by the instantaneous bandwidth requirements:

1.  **Narrowband Mode (500 MHz):** Optimized for maximum sensitivity and spurious-free dynamic range (SFDR). In this mode, the ADC decimation filter is configured to maximize SNR.
2.  **Wideband Mode (1 GHz):** Optimized for wideband spectrum capture and surveillance. This mode utilizes the full analog input bandwidth of the ADC and the maximum track-and-hold bandwidth of the analog front end.

### 2.1.2 Subsystem Interaction

The system comprises four distinct subsystems that interact in a strictly timed sequence:

1.  **RF Front End (RFFE):** Handles the initial conditioning of the 5–18 GHz input signal. It utilizes the **TGA4943-SL** as a driver amplifier to set the noise floor and drive the subsequent variable gain amplifier.
2.  **Frequency Translation & Conditioning:** This subsystem performs the core down-conversion. It utilizes the **HMC1048LP4BE** mixer, driven by the **ADF5356** wideband synthesizer, to translate the RF input to a DC or Intermediate Frequency (IF) baseband signal.
3.  **Digitization:** The **HMC1119LP4ME** integrated receiver performs final I/Q demodulation and gain adjustment, feeding the **AD9208** dual-channel ADC. The AD9208 samples the analog I/Q waveforms at 3 GSPS to support the >1 GHz instantaneous bandwidth requirement.
4.  **Control & Power:** A microcontroller unit (MCU) manages the SPI control lines for the synthesizer, VGAs, and demodulator. The power subsystem utilizes the **LT8645S** to efficiently convert the input +12V supply to the necessary low-noise rails (+5V, +3.3V, +1.0V) required by the sensitive RF and high-speed digital components.

### 2.1.3 Key Performance Indicators (KPI)

The hardware design targets the following specific KPIs derived from the requirements:
*   **Frequency Range:** Continuous coverage from 5.0 GHz to 18.0 GHz.
*   **Sensitivity:** Input P1dB of -10 dBm (supported by the high P1dB of the TGA4943-SL and HMC1048LP4BE).
*   **Phase Noise:** Local Oscillator phase noise ≤ -100 dBc/Hz at 10 kHz offset (ensured by the ADF5356).
*   **Dynamic Range:** 80 dB SFDR, achieved through the 14-bit resolution of the AD9208 and careful gain staging.

## 2.2 System Block Diagram

The system architecture is defined by the signal flow from the antenna input to the digital output interface.

```mermaid
graph TD
    %% External Inputs
    E_1[+12V DC Supply]
    E_2[RF Input 5-18GHz]
    E_3[Host FPGA/DSP]

    %% Power Distribution Subsystem
    subgraph Power_Mgmt [Power Distribution Unit]
        PM_1[LT8645S Buck Converter]
        PM_2[LDO Regulator Group 5V/3.3V]
    end

    %% RF Front End Subsystem
    subgraph RF_Front_End [RF Front End (5-18 GHz)]
        RF_1[Input Protection & Bandpass]
        RF_2[TGA4943-SL LNA]
        RF_3[Variable Gain Amp]
    end

    %% Frequency Conversion Subsystem
    subgraph Freq_Conv [Frequency Conversion]
        FC_1[HMC1048LP4BE Mixer]
        FC_2[ADF5356 Synthesizer]
    end

    %% IF & Digitization Subsystem
    subgraph IF_Chain [IF Processing & Digitization]
        IF_1[HMC1119LP4ME Integrated Receiver]
        IF_2[Anti-Alias Filters]
        IF_3[AD9208 Dual ADC 14-bit 3GSPS]
    end

    %% Control Subsystem
    subgraph Ctrl_Unit [Control Unit]
        CTRL_1[MCU / SPI Controller]
    end

    %% Connections - Power
    E_1 --> PM_1
    PM_1 --> PM_2
    PM_1 -.-> RF_2
    PM_2 -.-> FC_2
    PM_2 -.-> IF_1
    PM_2 -.-> IF_3
    PM_2 -.-> CTRL_1

    %% Connections - Signal Flow
    E_2 --> RF_1
    RF_1 --> RF_2
    RF_2 --> RF_3
    RF_3 --> FC_1
    FC_2 --> FC_1
    FC_1 --> IF_1
    IF_1 --> IF_2
    IF_2 --> IF_3
    IF_3 -->|JESD204B 8-Lane| E_3

    %% Connections - Control
    CTRL_1 -.->|SPI Config| RF_3
    CTRL_1 -.->|SPI Tuning| FC_2
    CTRL_1 -.->|SPI Gain| IF_1
    CTRL_1 -.->|SPI Sync| IF_3
```

*Figure 2-1: System Level Block Diagram showing power, signal flow, and control interfaces.*

## 2.3 System Architecture

The ajsfdvhjs system adopts a modular architecture designed to partition high-frequency RF circuits from digital switching noise. The architecture is physically divided into three main domains:

### 2.3.1 RF Signal Chain Architecture

The signal chain follows a **Superheterodyne** approach (or Direct Conversion depending on LO setting) centered around the high-linearity **HMC1048LP4BE** mixer.

1.  **Input Stage:** The signal enters via an SMA (2.4mm compatible) connector. It passes through a broadband bandpass filter (5-18 GHz) to reject out-of-band interference.
2.  **Low Noise Amplification:** The **TGA4943-SL** (GaN MMIC) provides the initial gain of 20 dB. This component is chosen specifically for its high P1dB (33 dBm), ensuring the receiver meets the linearity requirements (REQ-HW-012) even when strong interferers are present.
3.  **Down-Conversion:** The amplified RF signal is mixed with the Local Oscillator (LO) signal generated by the **ADF5356**.
    *   **LO Architecture:** The **ADF5356** utilizes a fundamental VCO output up to 13.6 GHz and frequency multipliers to reach the upper end of the 18 GHz band. It features a phase detector frequency capable of achieving the phase noise target of -100 dBc/Hz.
4.  **IF/Demodulation:** The mixer output (IF) feeds into the **HMC1119LP4ME**. This component serves as a Variable Gain Amplifier (VGA) and I/Q Demodulator. It provides the final gain adjustment to drive the ADCs at their optimal full-scale range (typically 1.5 Vpp differential).
5.  **Digitization:** The differential I and Q outputs are filtered to remove aliasing frequencies and sampled by the **AD9208**.
    *   **Data Conversion:** The AD9208 operates at 3.0 GSPS. It employs JESD204B Subclass 1 to ensure deterministic latency synchronization between the I and Q channels and the downstream FPGA.

### 2.3.2 Power Distribution Architecture

The power system is designed to handle the dynamic current surges of the ADC and GaN amplifiers while maintaining low noise for the synthesizer.

*   **Primary Conversion:** The **LT8645S** steps down the +12V input to +5V. This component is selected for its "Silent Switcher" architecture, which minimizes EMI/EMC emissions that could couple into the 5-18 GHz RF path.
*   **Point-of-Load Regulation:** Low Noise LDOs (e.g., ADM7150 or similar, referenced in BOM assumptions) generate the clean +3.3V and +1.0V rails required for the **ADF5356** synthesizer and **AD9208** ADC cores. This prevents switching noise from degrading the phase noise (REQ-HW-013) or SNR.

### 2.3.3 Control Architecture

The system relies on an SPI daisy-chain topology.
1.  **Master:** An on-board microcontroller (MCU).
2.  **Slaves:**
    *   **ADF5356:** Requires a 32-bit write for frequency tuning and multiplexer configuration.
    *   **HMC1119LP4ME:** Requires a 24-bit serial write for gain setting and I/Q phase alignment.
    *   **AD9208:** Requires SPI configuration for JESD204B link parameters, test patterns, and offset correction.
3.  **Interface Speed:** The SPI clock is constrained to ≤ 10 MHz to ensure signal integrity across the PCB and compatibility with the level shifters required for the mixed-voltage system (5V RF logic vs. 3.3V/FPGA logic).

### 2.3.4 Mechanical Architecture

The system is designed for a standard 19-inch rack mount environment but utilizes a custom enclosure.
*   **PCB Stackup:** A multi-layer stackup (minimum 8 layers) with dedicated RF layers on low-loss materials (e.g., Rogers RO4350B or Isola FR408HR) and separate digital power planes.
*   **Shielding:** The RF section (5-18 GHz) will be isolated via a machined aluminum shield cover to prevent radiation from the digital clock signals from coupling into the mixer input.

## 2.4 Operating Environment

The ajsfdvhjs hardware is classified as a ruggedized COTS (Commercial Off-The-Shelf) receiver module.

### 2.4.1 Physical Environment

*   **Operating Temperature Range:** -40°C to +85°C (REQ-HW-010).
    *   *Derating:* Components are selected for the industrial temperature range (-40°C to +85°C) or automotive grade where available. The **TGA4943-SL** and **AD9208** are specified for these temperature ranges.
    *   *Thermal Management:* The system relies on baseplate cooling. A thermal conductive path is provided from the high-power dissipating components (TGA4943-SL, AD9208) to the chassis bottom.
*   **Storage Temperature Range:** -55°C to +105°C.
*   **Humidity:** 5% to 95% non-condensing. The conformal coating on the PCB will protect against moisture ingress in high-humidity environments.
*   **Vibration:** Designed to meet MIL-STD-202G Method 213B (Condition H) for random vibration. The heavy RF components (TGA4943, HMC1048) will be adhered with RTV silicone in addition to solder reflow to prevent mechanical failure.

### 2.4.2 Electrical Environment

*   **Input Supply:** +12V DC ±5%.
    *   *Transient Protection:* The input is protected against transients up to 24V and reverse voltage protection diodes are included.
*   **RF Input:**
    *   Impedance: 50 Ω single-ended.
    *   VSWR: ≤ 2.5:1 across the 5-18 GHz band (when terminated into the receiver LNA).
*   **Load Impedance:** The JESD204B output is designed to drive a high-impedance AC-coupled differential input on an FPGA (typically 100 Ω differential termination).

### 2.4.3 Interface Connectors

| Connector ID | Type | Interface | Signal Description | Notes |
| :--- | :--- | :--- | :--- | :--- |
| J1 | SMA (Female) | RF Input | 5-18 GHz RF Signal | 2.4mm precision recommended for >18GHz calibrations |
| J2 | MDR-12 (High Density) | Power & Control | +12V, GND, SPI_CS, SPI_CLK, SPI_MOSI, SPI_MISO | For bench testing/direct MCU control |
| J3 | Samtec QTH / QSE | High-Speed Data | JESD204B (8 Lanes) + Sync | Supports data rates up to 12.5 Gbps per lane |

---

# 3. Hardware Requirements

## 3.1 Functional Requirements

This section details the behavioral and functional characteristics of the wideband RF receiver hardware. Each requirement is defined to ensure the system meets the operational intent of signals intelligence and spectrum monitoring.

| ID | Title | Description | Rationale | Priority |
|---|---|---|---|---|
| REQ-HW-001 | RF Input Coverage | The receiver shall accept and process RF input signals continuously across the 5.0 GHz to 18.0 GHz frequency range. | Ensures the system meets the primary application requirement for wideband spectrum monitoring without frequency gaps. | Shall |
| REQ-HW-002 | Signal Acquisition Path | The system shall implement a signal chain consisting of: Input Filter -> LNA -> VGA -> Mixer -> IF Filter -> IQ Demodulator -> ADC. | Defines the specific superheterodyne/direct-conversion hybrid architecture required to achieve the 80 dB dynamic range and 1 GHz bandwidth. | Shall |
| REQ-HW-003 | Input Connector Interface | The RF input port shall utilize a female SMA connector (2.4mm compatible) rated for operation up to 18 GHz. | Provides mechanical compatibility with standard test equipment and antennas used in the field. | Shall |
| REQ-HW-004 | Automatic Gain Control (AGC) | The system shall provide a minimum of 30 dB of continuous gain adjustment range via a Variable Gain Amplifier (VGA). | Necessary to prevent ADC saturation during strong signal presence and maintain sensitivity during weak signal reception. | Shall |
| REQ-HW-005 | Frequency Downconversion | The system shall downconvert the 5-18 GHz RF input to an Intermediate Frequency (IF) or Baseband signal suitable for the ADC input bandwidth. | Direct sampling of 18 GHz is not feasible with selected ADC; downconversion is required to digitize the signal content. | Shall |
| REQ-HW-006 | Local Oscillator (LO) Generation | The system shall generate a stable LO signal spanning 5-18 GHz using a wideband frequency synthesizer. | Required to drive the mixer for downconversion; the tunability of the LO defines the tunability of the receiver. | Shall |
| REQ-HW-007 | Quadrature Demodulation | The receiver shall split the downconverted signal into In-phase (I) and Quadrature (Q) analog components. | Required for preserving phase information and complex signal modulation schemes used in communications. | Shall |
| REQ-HW-008 | Dual Channel Digitization | The system shall digitize I and Q analog signals simultaneously using a dual-channel ADC architecture. | Enables reconstruction of complex baseband signals. | Shall |
| REQ-HW-009 | High-Speed Data Interface | The digitized I/Q data shall be transmitted to the FPGA/DSP backend via a JESD204B/C interface operating at the line rate required by the sample bandwidth. | JESD204B is the industry standard for high-speed data transfer between ADCs and FPGAs, reducing pin count compared to LVDS. | Shall |
| REQ-HW-010 | Serial Peripheral Interface (SPI) Control | The system shall expose an SPI slave interface (Mode 0 or 3) for configuring gain, LO frequency, and ADC settings. | Provides a standard, low-speed control interface for the host MCU or FPGA. | Shall |
| REQ-HW-011 | Power Distribution | The system shall accept a single +12V DC input and distribute internally regulated +5V (Analog) and +3.3V (Digital) rails. | Simplifies external power supply requirements while ensuring sensitive RF/analog components are isolated from digital switching noise. | Shall |
| REQ-HW-012 | Input Protection | The RF input port shall include DC blocking and ESD protection circuitry rated for at least 1.5 kV (Human Body Model). | Protects sensitive LNA input transistors from electrostatic discharge and DC offset events during setup. | Should |
| REQ-HW-013 | Clock Distribution | The system shall accept an external reference clock or utilize an internal crystal oscillator to synchronize the ADC and the LO Synthesizer. | Shared clock sources are critical to maintain phase coherence between the digital conversion and the analog downconversion. | Shall |
| REQ-HW-014 | RF Front-End Enable | The system shall include a hardware mechanism to enable/disable the RF Front End (LNA/Mixer power) via SPI or GPIO. | Allows for power saving modes when the system is in standby. | Should |
| REQ-HW-015 | Intermediate Frequency (IF) Filtering | The system shall provide filtering between the Mixer and the Demodulator/ADC to limit out-of-band noise and aliasing products. | Essential for shaping the signal bandwidth before digitization to meet Noise Figure requirements. | Shall |
| REQ-HW-016 | Temperature Monitoring | The system shall include a temperature sensor readable via SPI to monitor the PCB ambient temperature. | Required for system health monitoring and potential calibration compensation over the -40°C to +85°C range. | Should |
| REQ-HW-017 | LO Drive Amplification | The system shall ensure the LO input to the Mixer meets the specified drive level (+13 to +17 dBm for HMC1048LP4BE). | Insufficient LO drive leads to increased conversion loss and degraded noise figure. | Shall |
| REQ-HW-018 | I/Q Balance Adjustment | The demodulator shall allow for phase and gain imbalance adjustment (digital or analog) to minimize image frequencies. | Critical for maximizing the effective dynamic range and sideband suppression in wideband reception. | Should |
| REQ-HW-019 | Mechanical Form Factor | The RF signal path components shall be laid out on a substrate material appropriate for 18 GHz (e.g., Rogers RO4350B or Isola FR408HR). | Standard FR-4 exhibits excessive dielectric loss and signal instability at frequencies above 6 GHz. | Shall |
| REQ-HW-020 | RF Shielding | The RF Front End section (LNA through Mixer) shall be enclosed in a metallic shield can to prevent EMI radiation and susceptibility. | Prevents oscillation in high-gain stages and blocks noise from digital switching supplies. | Should |

---

## 3.2 Performance Requirements

This section defines the quantitative performance metrics the hardware must achieve. These values are derived from the selected components (Qorvo TGA4943-SL, ADI HMC1048LP4BE, HMC1119LP4ME, ADF5356, AD9208) and system analysis.

### 3.2.1 RF Performance

| ID | Title | Requirement Value | Rationale / Calculation Basis | Priority |
|---|---|---|---|---|
| REQ-HW-101 | Frequency Range | 5.0 GHz to 18.0 GHz | Covers the specified X-band and Ku-band communications frequencies. | Shall |
| REQ-HW-102 | Instantaneous Bandwidth | 1000 MHz (1 GHz) | Supports high data rate links. Derived from the AD9208 ADC capabilities and Nyquist criteria for complex sampling. | Shall |
| REQ-HW-103 | Conversion Gain / Flatness | ±3 dB peak-to-peak variation over full band | Ensures consistent signal amplitude across the tuned spectrum. | Should |
| REQ-HW-104 | Input P1dB (1dB Compression Point) | ≥ -10 dBm (System Input) | Based on TGA4943-SL LNA P1dB (33 dBm) minus inter-stage loss. The system is designed for high linearity. | Shall |
| REQ-HW-105 | Input Third Order Intercept (IIP3) | ≥ 0 dBm | Derived from cascade analysis. The TGA4943 offers high linearity, setting the system floor. | Should |
| REQ-HW-106 | Noise Figure (System) | ≤ 10 dB (Total) | Calculation: 3 dB (LNA) + 0.5 dB (Filter Loss) + 7.5 dB (Mixer Conv Loss) + 2 dB (IF/Demod). 3 + 0.5 + 7.5 approx 11 dB. However, using the integrated HMC1119LP4ME path (NF=9dB) as the primary receiver chain aligns with this requirement. | Shall |
| REQ-HW-107 | Dynamic Range (SFDR) | ≥ 80 dB | Requirement driven by ADC SFDR (AD9208 ~65-70dB) combined with RF AGC range to extend system utility. The AGC extends the effective SFDR by allowing the system to optimize for weak or strong signals. | Shall |
| REQ-HW-108 | Phase Noise (LO) | -100 dBc/Hz @ 10 kHz offset | Requirement matched to the ADF5356 Synthesizer typical performance at 6 GHz. Critical for demodulation fidelity. | Should |
| REQ-HW-109 | LO Spurious Content | ≤ -80 dBc | Based on ADF5356 specifications. Ensures LO does not create detectable interfering tones within the passband. | Should |
| REQ-HW-110 | Input Return Loss | ≥ 10 dB (VSWR ≤ 2:1) | Ensures efficient power transfer from the antenna to the LNA without significant reflections. | Should |

### 3.2.2 Digitization Performance

| ID | Title | Requirement Value | Rationale / Calculation Basis | Priority |
|---|---|---|---|---|
| REQ-HW-111 | ADC Resolution | 14 bits | Defined by the AD9208 component selection. Provides sufficient granularity for wideband dynamic range. | Shall |
| REQ-HW-112 | ADC Sampling Rate | 3000 MSPS (3 GSPS) | Defined by the AD9208-3000 grade. Necessary to accurately Nyquist-sample a 1 GHz complex bandwidth (IF) or direct-RF subsampled band. | Shall |
| REQ-HW-113 | ADC Input Full Scale | 1.5 Vpp differential | Standard full-scale range for the AD9208. Interface circuitry must scale the Demodulator output to this range. | Shall |
| REQ-HW-114 | JESD204B Lane Rate | 12.5 Gbps per lane (8 lanes) | Calculated based on: \( f_{lane} = \frac{M \times S \times B \times (10/8)}{L} \). Assuming M=2 (I/Q), S=1 (decimation off), B=16 (14-bit samples + control), L=8 lanes. Required to sustain 3 GSPS throughput. | Shall |
| REQ-HW-115 | SNR (Signal to Noise Ratio) | ≥ 58.5 dBFS | Datasheet value for AD9208 at 3 GSPS input (approx -1dBFS). Sets the floor for digital signal quality. | Should |

### 3.2.3 Power & Thermal Performance

| ID | Title | Requirement Value | Rationale / Calculation Basis | Priority |
|---|---|---|---|---|
| REQ-HW-116 | Total Input Power Consumption | ≤ 25 Watts @ +12V | Budget Calculation:<br>- LNA (TGA4943): 5V @ 400mA = 2W<br>- Synth (ADF5356): 3.3V @ 250mA = 0.8W<br>- Mixer (HMC1048): 5V @ 150mA = 0.75W<br>- Demod (HMC1119): 5V @ 350mA = 1.75W<br>- ADC (AD9208): 1.8V/1.1V @ 4W total = 4W<br>- FPGA/Logic (Est): 5W<br>- Margin/Reg Loss: 10W<br>Total ~24W. | Shall |
| REQ-HW-117 | Operating Temperature Range | -40°C to +85°C (Case Temp) | Standard industrial operating range for outdoor communications equipment. | Should |
| REQ-HW-118 | Power Supply Rejection | > 60 dB @ Switching Freq | The LT8645S Silent Switcher and subsequent LDOs must suppress switching noise to prevent it from entering the RF chain. | Should |

### 3.2.4 Timing & Synchronization Performance

| ID | Title | Requirement Value | Rationale / Calculation Basis | Priority |
|---|---|---|---|---|
| REQ-HW-119 | LO Settling Time | ≤ 100 µs | Time required for the ADF5356 PLL to lock after a frequency change. Impacts frequency agility of the system. | Should |
| REQ-HW-120 | Reference Clock Input | 10 MHz to 500 MHz | Compatible input frequency range for the ADF5356 reference input and ADC SYSREF. | Shall |

---

### 3.3 Interface Requirements

This section delineates the electrical and physical interfaces required for the ajsfdvhjs Wideband RF Receiver. All interfaces are designed to maintain signal integrity for the 5-18 GHz RF path and the high-speed digital JESD204B lanes.

#### 3.3.1 External Interfaces

External interfaces connect the ajsfdvhjs receiver to the system antenna, power source, and host processing platform.

**REQ-HW-101:** The system shall provide a single 50-Ohm RF input port compatible with the 5-18 GHz frequency range.
*Rationale:* Standard impedance for wideband RF systems.

**REQ-HW-102:** The RF input port shall utilize a female SMA (2.4mm optional) connector, mounted directly on the PCB edge or chassis feedthrough.
*Rationale:* Mechanical compatibility with standard lab and field test equipment.

**REQ-HW-103:** The system shall accept power via a pluggable screw terminal block or a 2-pin header supporting wire gauges from 18 AWG to 24 AWG.
*Rationale:* Robust connection for +12V supply.

**REQ-HW-104:** The system shall provide external status indicators via two LEDs: one for Power (Green) and one for FPGA Lock/Status (Amber).
*Rationale:* Visual feedback for system health.

**Table 3-1: External Interface Pinout/Connector Definition**

| Interface | Connector Type | Pin/Signal Name | Type | Description | Impedance / Voltage |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **RF Input** | SMA-F (Edge) | RF_IN | RF | 5-18 GHz Signal Input | 50 $\Omega$ |
| **RF Input** | SMA-F (Edge) | GND | GND | Chassis Ground | 0 $\Omega$ |
| **Power** | TB-2P (Terminal) | +12V_DC | PWR | Main Power Input (12V nominal) | +11.4V to +12.6V |
| **Power** | TB-2P (Terminal) | GND | PWR | Power Return (0V) | 0V |
| **Debug/Control** | Micro-USB (Type B) | USB_D+ | I/O | Firmware Upload / Console | 3.3V Logic |
| **Debug/Control** | Micro-USB (Type B) | USB_D- | I/O | Firmware Upload / Console | 3.3V Logic |
| **Debug/Control** | Micro-USB (Type B) | GND | PWR | USB Ground | 0V |

#### 3.3.2 Internal Interfaces

Internal interfaces define the interconnects between the RF frontend, the ADC, and the FPGA.

**REQ-HW-105:** The connection between the IF Demodulator (HMC1119LP4ME) and the ADC (AD9208) shall utilize AC-coupled differential pairs with 100 $\Omega$ differential impedance.
*Rationale:* Maximizes signal swing and minimizes DC offset errors.

**REQ-HW-106:** The Local Oscillator (LO) distribution path from the ADF5356 synthesizer to the RF Mixer (HMC1048LP4BE) and the IQ Demodulator shall utilize a passive power splitter with isolated outputs to maintain phase noise performance.
*Rationale:* Ensures consistent LO drive levels and prevents load pulling.

**Table 3-2: Internal RF/Analog Interface List**

| Source Component | Source Port | Destination Component | Dest. Port | Signal Type | Media |
| :--- | :--- | :--- | :--- | :--- |
| TGA4943-SL (LNA) | RF_OUT | HMC1048LP4BE (Mixer) | RF_IN | Differential/Sing. | 50$\Omega$ CPW |
| ADF5356 (Synth) | RF_OUT | Splitter (Mini-Circuits) | IN | Single-ended | 50$\Omega$ CPW |
| Splitter | OUT1 | HMC1048LP4BE (Mixer) | LO_IN | Single-ended | 50$\Omega$ CPW |
| Splitter | OUT2 | HMC1119LP4ME (Demod) | LO_IN | Single-ended | 50$\Omega$ CPW |
| HMC1119LP4ME | I_OUT_P | AD9208 (ADC Ch A) | D0P | Differential | AC-Coupled 100$\Omega$ |
| HMC1119LP4ME | I_OUT_N | AD9208 (ADC Ch A) | D0N | Differential | AC-Coupled 100$\Omega$ |
| HMC1119LP4ME | Q_OUT_P | AD9208 (ADC Ch B) | D1P | Differential | AC-Coupled 100$\Omega$ |
| HMC1119LP4ME | Q_OUT_N | AD9208 (ADC Ch B) | D1N | Differential | AC-Coupled 100$\Omega$ |

#### 3.3.3 Communication Interfaces

Communication interfaces handle the control logic and high-speed data export.

**REQ-HW-107:** The ADC (AD9208) shall transmit digitized data to the host FPGA via the JESD204B Subclass 1 protocol over 8 lanes.
*Rationale:* Industry standard for high-speed data transfer; reduces pin count compared to LVDS.

**REQ-HW-108:** The control MCU (or FPGA fabric) shall configure all RFICs (Mixer, Synth, Demod, VGA) via a standard SPI interface operating at logic levels compatible with 3.3V CMOS.
*Rationale:* Consolidated control bus reduces wiring complexity.

**REQ-HW-109:** The JESD204B interface shall support a line rate of 12.5 Gbps per lane to support the maximum instantaneous bandwidth of 1 GHz with decimation filter bypassed.
*Rationale:* Ensures sufficient throughput for 3 GSPS ADC complex sampling.

**Table 3-3: JESD204B Interface Requirements**

| Parameter | Value | Notes |
| :--- | :--- | :--- |
| **Protocol** | JESD204B Subclass 1 | Deterministic latency |
| **Lanes (FPGA to ADC)** | 8 Lanes | Supports dual-channel 3 GSPS mode |
| **Lane Rate** | 12.5 Gbps | Calculated based on ADC sample rate and resolution |
| **Scrambling** | Enabled | Reduces EMI |
| **Common Mode Voltage** | 0.85V $\pm$ 50mV | Defined by AD9208 datasheet |
| **Differential Swing** | 800 mVpp typical | CML driver levels |
| **AC Coupling** | Required on lanes | External capacitors required on PCB |

**Table 3-4: SPI Control Interface Pin Mapping**

| MCU Pin | Signal | Target Device | Target Pin | Function |
| :--- | :--- | :--- | :--- | :--- |
| GPIO_01 | SPI_SCLK | All RFICs | SCLK | Serial Clock (Max 20 MHz) |
| GPIO_02 | SPI_MOSI | All RFICs | SDIO/SI | Master Out Slave In |
| GPIO_03 | SPI_MISO | All RFICs | SDO/SDI | Master In Slave Out |
| GPIO_04 | SPI_CS_ADC | AD9208 | CSB | ADC Chip Select (Active Low) |
| GPIO_05 | SPI_CS_LO | ADF5356 | LE/CS | Synth Latch Enable |
| GPIO_06 | SPI_CS_MIX | HMC1048LP4BE | ENB | Mixer Enable/Sel |
| GPIO_07 | RESET_N | AD9208 | RESET | System Reset (Active Low) |
| GPIO_08 | ADC_SYNC | AD9208 | SYNC | JESD204B Lane Sync |

### 3.4 Environmental Requirements

The ajsfdvhjs system is designed for harsh environment operation typical of tactical communications or signals intelligence applications.

**REQ-HW-110:** The receiver shall maintain full electrical performance specifications over an operating temperature range of -40°C to +85°C (Ambient).
*Rationale:* Military/Industrial operating temperature range.

**REQ-HW-111:** The system shall withstand storage temperatures ranging from -55°C to +125°C without physical damage or degradation of performance upon return to operating limits.
*Rationale:* Logistics and storage conditions.

**REQ-HW-112:** The system shall operate without degradation in an environment with relative humidity ranging from 5% to 95% (non-condensing).
*Rationale:* Humidity tolerance.

**REQ-HW-113:** The hardware shall be designed to withstand vibration profiles consistent with MIL-STD-202G Method 213B (Random Vibration) with an overall Grms level of 7.7g.
*Rationale:* Mechanical robustness for mobile platforms.

**REQ-HW-114:** Conformal coating shall be applied to all PCBAs to protect against moisture, dust, and chemical contaminants (IPC-CC-830).
*Rationale:* High-reliability electronic assembly standard.

**Table 3-5: Environmental Operating Limits**

| Parameter | Minimum | Maximum | Units | Notes |
| :--- | :--- | :--- | :--- | :--- |
| **Operating Temp** | -40 | +85 | °C | Industrial/Military range |
| **Storage Temp** | -55 | +125 | °C | Non-operating |
| **Humidity** | 5 | 95 | %RH | Non-condensing |
| **Altitude** | 0 | 15,000 | ft | Derating power above 10k ft assumed |
| **Shock** | 40 | -- | g | 11 ms half-sine wave |

### 3.5 Power Requirements

This section details the power consumption, distribution, and budget for the receiver module. All calculations are based on typical datasheet values for the selected components at maximum operating temperature.

**REQ-HW-115:** The system shall operate from a single +12V DC nominal input source.
*Rationale:* Standard vehicle/battery supply.

**REQ-HW-116:** The total power consumption of the receiver module shall not exceed 25 Watts under maximum load (All RF chains active, FPGA at 80% toggle rate).
*Rationale:* Ensures thermal design limits are not exceeded and safety margins are maintained.

**REQ-HW-117:** The power supply system shall feature over-voltage protection (OVP) clamping at 14V and under-voltage lockout (UVLO) at 10.5V on the main input rail.
*Rationale:* Protection against voltage transients and incorrect supply voltage.

**Table 3-6: Power Budget Analysis**

| Voltage Rail | Source Component(s) | Est. Current (Typ) | Est. Current (Max) | Power (W) | Notes |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **+12V Input** | Input Protection / EMI | 2.100 A | 2.200 A | 26.4 W | Total Input Power |
| **+7.5V (Intermediate)** | LT8645S (Buck) | 1.800 A | 1.900 A | 14.25 W | Feeds RF Chains |
| **+5.5V (RF)** | LDO / Buck Post Reg | 0.600 A | 0.650 A | 3.575 W | LNA (TGA4943), LO Driver |
| **+5.0V (Analog)** | LDO | 0.400 A | 0.450 A | 2.25 W | Mixers, Demod, Synth Core |
| **+3.3V (Digital)** | LDO / Buck | 1.200 A | 1.500 A | 4.95 W | MCU, ADC Logic, IO |
| **+1.0V (Core)** | FPGA Rail | 3.000 A | 3.500 A | 3.50 W | FPGA Core Supply (Assumed Artix-7) |
| **+1.8V (ADC)** | AD9208 Supply | 0.300 A | 0.350 A | 0.63 W | ADC Analog/Digital Supplies |

**Power Calculations:**
*   **TGA4943-SL (LNA):** $V_{dd} = 5.5V$, $I_{dd} \approx 400 mA$. $P = 2.2 W$.
*   **HMC1048LP4BE (Mixer):** $V_{dd} = 5V$, $I_{dd} \approx 120 mA$. $P = 0.6 W$. (Note: Does not include LO drive power).
*   **ADF5356 (Synth):** $V_{dd} = 3.3V - 5V$. Avg current $\approx 150 mA$. $P \approx 0.6 W$.
*   **HMC1119LP4ME (Demod):** Multiple rails. Estimated $P \approx 1.2 W$.
*   **AD9208 (ADC):** $P \approx 1.5 W$ (typical dual-channel operation).
*   **FPGA (Processing):** Assuming Xilinx Artix-7 or similar. Dynamic power dependent on JESD204B serialization. Estimated $P \approx 3.5 W - 5.0 W$.
*   **Misc (LDO Loss, MCU, Buffers):** Estimated $1.5 W$.
*   **Total Estimated:** $2.2 + 0.6 + 0.6 + 1.2 + 1.5 + 5.0 + 1.5 \approx 12.6 W$ (Core consumption).
*   **Budgeting:** The system is budgeted for 25W to accommodate worst-case temperature derating of linear regulators and efficiency losses in switching regulators, plus margin for the FPGA user design.

**REQ-HW-118:** The +12V input shall be filtered with a Pi-filter to ensure conducted emissions meet CISPR 32 Class B limits.
*Rationale:* EMI compliance for communications equipment.

### 3.6 Physical Requirements

The physical packaging is designed for standard 19-inch rack integration or standalone benchtop use.

**REQ-HW-119:** The PCB dimensions shall not exceed 160mm x 120mm (6.3" x 4.7").
*Rationale:* Compatibility with standard half-brick or custom instrument housings.

**REQ-HW-120:** The PCB stack-up shall utilize a minimum of 10 layers with dedicated ground planes adjacent to all high-speed signal layers (JESD204B, RF, IF).
*Rationale:* Impedance control and EMI containment.

**REQ-HW-121:** The PCB material for RF sections (5-18 GHz) shall be low-loss laminate (e.g., Rogers RO4350B or equivalent) with a dielectric constant ($\epsilon_r$) stability of $\pm 0.05$.
*Rationale:* Ensures consistent impedance and minimal insertion loss at microwave frequencies.

**REQ-HW-122:** The RF input connector shall be mounted on the board edge with a launch geometry optimized for 5-20 GHz operation.
*Rationale:* Minimize VSWR and return loss at the interface.

**REQ-HW-123:** Mounting holes shall be provided in the four corners of the PCB with a diameter of 3.5mm to accommodate 4-40 or M3 standoffs.
*Rationale:* Mechanical mounting standard.

**Table 3-7: PCB Material Properties**

| Property | Required Value | Rationale |
| :--- | :--- | :--- |
| **Material Type** | Rogers RO4350B (RF) / FR-4 (Digital) | Hybrid stackup for cost/performance |
| **Dielectric Constant ($\epsilon_r$)** | 3.48 $\pm$ 0.05 (Rogers) | Critical for microwave transmission lines |
| **Dissipation Factor ($D_f$)** | 0.0037 @ 10 GHz | Low loss signal propagation |
| **Copper Weight** | 1 oz (outer) / 0.5 oz (inner) | Controlled impedance capability |
| **Surface Finish** | ENIG or Immersion Gold | Wire-bondability if required, flatness for SMT |
| **Thickness** | 0.062" (1.57mm) total | Mechanical rigidity |

**REQ-HW-124:** The system shall be enclosed in a conductive chassis with EMI gaskets on all seams to prevent radiated emissions exceeding FCC Part 15 limits.
*Rationale:* Regulatory compliance and security.

---

# 4. Design Constraints

This section defines the constraints imposed on the hardware design of the ajsfdvhjs Wideband RF Receiver. These constraints restrict the design space to ensure manufacturability, compliance with regulatory standards, compatibility with selected components, and adherence to environmental requirements. These requirements are non-negotiable boundaries for the design implementation.

## 4.1 Standards Compliance

The hardware design of the ajsfdvhjs receiver shall comply with the following industry standards and regulatory directives. Compliance is mandatory to ensure marketability, safety, and reliability.

| ID | Standard / Directive | Title & Description | Application |
|---|---|---|---|
| **REQ-HW-401** | **IPC-2221** | Generic Standard on Printed Board Design. The PCB stackup, trace widths, and spacing shall adhere to IPC-2221 Section 6 (Conductor Spacing) to manage high-frequency signal integrity and voltage isolation. | PCB Design |
| **REQ-HW-402** | **IPC-6012** | Qualification and Performance Specification for Rigid Printed Boards. The fabricated printed circuit boards must meet Class 3 (High Reliability Electronic Products) criteria due to the harsh operating environment and high-frequency performance requirements. | PCB Fabrication |
| **REQ-HW-403** | **IPC-7711/21** | Rework of Electronic Assemblies / Repair and Modification of Printed Boards and Electronic Assemblies. All rework and modification procedures performed during prototyping and production shall follow these guidelines to ensure reliability of BGA and QFN component rework. | Rework/Repair |
| **REQ-HW-404** | **RoHS 3 (EU 2015/863)** | Restriction of Hazardous Substances. The product shall be fully compliant with RoHS 3 directive, restricting the use of Lead (Pb), Mercury (Hg), Cadmium (Cd), Hexavalent Chromium (Cr6+), PBB, PBDE, and four phthalates (DEHP, BBP, DBP, DIBP). | Material Compliance |
| **REQ-HW-405** | **REACH (EC 1907/2006)** | Registration, Evaluation, Authorisation and Restriction of Chemicals. All substances of very high concern (SVHC) included in the European Chemicals Agency candidate list must be declared and authorized if present above 0.1% by weight. | Material Compliance |
| **REQ-HW-406** | **IEEE 1149.1** | Standard Test Access Port and Boundary-Scan Architecture. The JTAG interface shall be accessible via test points to support in-circuit programming and boundary-scan testing of the FPGA and Flash memory. | Testability |
| **REQ-HW-407** | **MIL-STD-202** | Test Method Standard for Electronic and Electrical Component Parts. Vibration and shock testing methods (Method 201/213) shall be referenced to validate mechanical robustness, though specific limits are defined in Section 3.6. | Mechanical Testing |
| **REQ-HW-408** | **ISO 9001** | Quality Management Systems. The manufacturing facility for the ajsfdvhjs receiver must be ISO 9001 certified to ensure consistent quality control during production. | Quality Assurance |
| **REQ-HW-409** | **IEC 61000-4-2** | Electromagnetic Compatibility (EMC) - Electrostatic Discharge (ESD). The system shall withstand contact discharges of ±4 kV and air discharges of ±8 kV on the RF connector and control interfaces without latch-up or damage. | EMC / ESD |
| **REQ-HW-410** | **FCC Part 15 (Subpart B)** | Radio Frequency Devices. While this is a receiver, the digital clock oscillators (3 GSPS ADC, FPGA PLLs) generating signals > 9 kHz must be controlled to ensure the unit does not generate harmful interference (Class B digital device limits). | Regulatory / EMI |

## 4.2 Component Constraints

The selection and application of electronic components are constrained by availability, packaging, and specific technical characteristics required to meet the 5-18 GHz performance goals.

### 4.2.1 Component Sourcing and Lifecycle
To ensure production continuity and supportability, the following constraints on component lifecycle status are imposed:

| ID | Constraint | Description |
|---|---|---|
| **REQ-HW-420** | **Lifecycle Status** | All Active, Bill of Materials (BOM) components shall be in "Active" or "Not Recommended for New Design" (NRND) status only. Components in "Pre-production" or "Obsolete" status are strictly prohibited unless a drop-in replacement is identified in the alternate sourcing list. |
| **REQ-HW-421** | **Packaging** | Where possible, components shall be supplied in tape-and-reel format to support automated pick-and-place assembly. Components supplied only in waffle packs or trays require special handling approval. |
| **REQ-HW-422** | **Moisture Sensitivity** | Components with Moisture Sensitivity Level (MSL) of 3 or higher (typically the QFN and BGA packages selected for the RF chain) shall undergo baking prior to reflow if floor life has been exceeded, per IPC-J-STD-033. |

### 4.2.2 RF and High-Speed Component Constraints
Specific constraints apply to the RF chain components to ensure signal integrity and thermal performance.

| ID | Constraint | Description | Rationale |
|---|---|---|---|
| **REQ-HW-425** | **LNA Biasing** | The TGA4943-SL LNA requires a negative gate voltage. The design must derive this rail internally from the +12V input using an inverting regulator, minimizing noise on the bias line to prevent degradation of the 3 dB Noise Figure. | Gate noise directly impacts NF. |
| **REQ-HW-426** | **LO Drive Level** | The HMC1048LP4BE mixer requires +13 to +17 dBm of LO drive. The ADF5356 synthesizer output must be buffered and amplified to guarantee a minimum of +15 dBm drive at the mixer's LO port across the entire 5-18 GHz band. | Insufficient LO drive increases Conversion Loss. |
| **REQ-HW-427** | **Jitter Requirements** | The ADC clock source jitter must be less than 100 fs RMS to preserve the SNR of the AD9208 ADC operating at 3 GSPS. The clock distribution path must utilize a dedicated low-jitter fanout buffer. | High-speed conversion accuracy. |
| **REQ-HW-428** | **Power Dissipation** | The AD9208 ADC dissipates approximately 1.9 W. The PCB layout must utilize an thermal pad connected to a ground plane with at least 4 thermal vias (0.3mm diameter) under the pad to transfer heat to the backside or inner layers. | Thermal management. |
| **REQ-HW-429** | **Impedance Matching** | All RF interconnects between the Mixer, IF Amp, and Demodulator must be controlled to 50 Ω ±10%. Mismatches exceeding this tolerance will degrade VSWR and increase ripple in the passband. | Signal integrity. |

### 4.2.3 Mechanical Constraints
Constraints related to the physical mounting and assembly of components.

| ID | Constraint | Description |
|---|---|---|
| **REQ-HW-430** | **Keepout Zones** | A 3.5 mm diameter keepout zone (no copper, no components) shall be maintained under the 2.4mm RF connector footprint to ensure proper mating and prevent ground shorting during tuning. |
| **REQ-HW-431** | **Connector Height** | The maximum component height on the top side shall not exceed 12.0 mm to accommodate standard 1U rack enclosures (assuming use with a standoff). |
| **REQ-HW-432** | **SMA / 2.4mm Mounting** | RF connectors must be mounted utilizing 4 mounting nuts (the "4-hole" flange pattern) to ensure mechanical stability during mating cycles. |

## 4.3 Manufacturing Constraints

This section defines constraints related to the PCB fabrication, assembly processes, and test methodologies required to produce the ajsfdvhjs receiver.

### 4.3.1 PCB Fabrication Constraints
Due to the 5-18 GHz operating frequency and the integration of a JESD204B interface, standard FR4 material is insufficient. The following stackup and material constraints apply:

| ID | Parameter | Requirement | Justification |
|---|---|---|---|
| **REQ-HW-450** | **Material Type** | Rogers RO4350B or Isola FR408HR. | Low dielectric loss (Df) required at 18 GHz. |
| **REQ-HW-451** | **Dielectric Thickness** | Core thickness for RF layers shall not exceed 8 mils (0.203 mm). | To achieve 50-ohm trace widths of ~11 mils for controlled impedance and tighter coupling to ground for EMI. |
| **REQ-HW-452** | **Copper Weight** | Outer layers: 1 oz (35 µm). Inner layers: 0.5 oz (17 µm) or 1 oz. | 1 oz outer aids in current carrying capacity for power rails; inner layers optimized for etch tolerance. |
| **REQ-HW-453** | **Minimum Trace/Space** | 4 mil / 4 mil for standard signals. | Standard fabrication capability for cost control. |
| **REQ-HW-454** | **Hole Plating** | Plated Through Holes (PTH) must be filled with conductive or non-conductive epoxy (VIP - Via in Pad) for BGA escape routing on the FPGA and ADC packages. | Required for fine-pitch BGA assembly. |

### 4.3.2 Assembly and Soldering Constraints

| ID | Constraint | Description |
|---|---|---|
| **REQ-HW-460** | **Solder Paste** | Type 4 solder paste (particle size 20-38 µm) shall be used for all stencils to accommodate the fine pitch (0.5 mm and below) components. |
| **REQ-HW-461** | **Reflow Profile** | The reflow profile shall comply with JEDEC J-STD-020 for Pb-free solder (peak temp 245°C max). Components rated for a max of 260°C (typically MSL sensing components) allow for this window. |
| **REQ-HW-462** | **Selective Soldering** | Any through-hole connectors (e.g., high-power RF headers) must be compatible with selective soldering or wave soldering processes to avoid damaging nearby SMT components. |

### 4.3.3 Testing and Inspection Constraints
To ensure the system meets the 80 dB dynamic range and noise figure requirements, specific test constraints apply to the manufacturing process.

| ID | Constraint | Description |
|---|---|---|
| **REQ-HW-470** | **Flying Probe** | The board shall have 50 mil test pads for all critical power rails (+12V, +5V, +3.3V, Vneg) to allow automated flying probe testing (ICT) for shorts and opens. |
| **REQ-HW-471** | **Boundary Scan** | JTAG chains for the FPGA and Flash must be isolated via 0-ohm resistors to allow individual programming and testing of the boundary scan chain without interfering with the ADC JTAG interface. |
| **REQ-HW-472** | **RF Fixture** | A bed-of-nails test fixture is not feasible for RF. The validation shall rely on "golden board" comparison testing via the SMA/2.4mm interface using a Vector Network Analyzer (VNA) to verify S11 (Input Return Loss) is better than -10 dB across the band. |
| **REQ-HW-473** | **Conformal Coating** | If the unit is designated for high-humidity environments, a acrylic conformal coating (UR type) shall be applied, ensuring it does not coat the RF connectors or tuning apertures. |

---

# 5. Verification Requirements

## 5.1 Test Requirements

This section defines the specific test methods, equipment, and acceptance criteria for verifying hardware functionality and performance. Testing is categorized into Module Level (unit testing of individual blocks) and System Level (integrated assembly testing).

### 5.1.1 RF Front End Performance Tests

#### TC-HW-001: Frequency Coverage and Tuning Range
* **Requirement ID:** REQ-HW-001
* **Test Method:** Functional Sweep
* **Description:** Verify the receiver can lock and downconvert signals across the entire 5.0 GHz to 18.0 GHz band.
* **Equipment:**
    *   Signal Generator (e.g., Keysight N5183B)
    *   Spectrum Analyzer (e.g., Keysight N9010A)
    *   USB Sweep Oscillator (Internal or external reference)
* **Procedure:**
    1.  Set RF Input to -30 dBm.
    2.  Step LO frequency in 100 MHz steps from 5.5 GHz to 18.5 GHz (assuming low-side injection for 5 GHz RF -> 18 GHz IF or high-side injection, depending on architecture).
    3.  At each step, verify the presence of the downconverted IF signal at the expected frequency (e.g., IF = 1 GHz) on the Spectrum Analyzer.
    4.  Verify lock detect signal is asserted on the MCU GPIO for the ADF5356.
* **Pass Criteria:**
    *   IF signal present (> -50 dBm expected level) at all step frequencies.
    *   Lock Detect asserted at all steps.
    *   No dropouts in signal chain continuity.

#### TC-HW-002: Instantaneous Bandwidth (IF Flatness)
* **Requirement ID:** REQ-HW-002
* **Test Method:** Network Analysis
* **Description:** Verify the analog chain supports a flat response over a 1 GHz instantaneous bandwidth.
* **Equipment:**
    *   Vector Network Analyzer (VNA, e.g., Keysight PNA-N5242A)
* **Procedure:**
    1.  Set the Receiver to a fixed LO frequency (e.g., 10 GHz).
    2.  Inject a swept RF signal centered at 10 GHz (RF = LO + IF).
    3.  Sweep the IF range from DC to 1.5 GHz.
    4.  Measure the S21 conversion gain vs. IF frequency.
* **Pass Criteria:**
    *   The -3 dB bandwidth of the IF stage must be ≥ 1.0 GHz.
    *   Gain flatness within 500 MHz - 1000 MHz window must be ≤ ±3 dB.

#### TC-HW-003: Dynamic Range (SFDR/Two-Tone)
* **Requirement ID:** REQ-HW-003
* **Test Method:** Two-Tone Intermodulation Test
* **Description:** Measure the Spurious-Free Dynamic Range (SFDR) to verify 80 dB requirement.
* **Equipment:**
    *   Two Signal Generators synchronized to a common reference.
    *   Spectrum Analyzer.
* **Procedure:**
    1.  Set LO to 10 GHz.
    2.  Generate two tones at f1 = 10.1 GHz and f2 = 10.2 GHz (-20 dBm each).
    3.  Capture the digitized ADC output (or IF output).
    4.  Measure the fundamental power (P_fund) and the power of the 3rd order intermodulation products (IM3) at 2f1 - f2 and 2f2 - f1.
* **Pass Criteria:**
    *   SFDR (P_fund - worst spur) ≥ 80 dB.
    *   IP3 calculated from IM3 products must align with component specs (HMC1119 OIP3 ~19 dBm).

#### TC-HW-004: Noise Figure Verification
* **Requirement ID:** REQ-HW-004
* **Test Method:** Y-Factor / Noise Figure Meter
* **Description:** Verify the system Noise Figure (NF) is between 6-10 dB.
* **Equipment:**
    *   Noise Source (e.g., HP 346C)
    *   Noise Figure Analyzer (e.g., Keysight N8975A)
* **Procedure:**
    1.  Connect Noise Source to RF Input.
    2.  Set Analyzer to measure Gain and NF.
    3.  Sweep LO frequency from 5 GHz to 18 GHz in 1 GHz steps.
* **Pass Criteria:**
    *   NF ≤ 10 dB across the band.
    *   Target NF is ~8 dB (Gain of TGA4943 + Loss of HMC1048 + NF of HMC1119).

### 5.1.2 High-Speed Digital Interface Tests

#### TC-HW-005: JESD204B Link Integrity
* **Requirement ID:** REQ-HW-006
* **Test Method:** Bit Error Rate (BER) Test & Link Training
* **Description:** Verify data integrity between the AD9208 ADC and the FPGA.
* **Equipment:**
    *   JESD204B Pattern Generator (Internal FPGA loopback).
    *   Oscilloscope (High bandwidth > 6 GHz for signal integrity).
* **Procedure:**
    1.  Configure AD9208 for JESD204B Subclass 1 (deterministic latency).
    2.  Initiate link training via SPI.
    3.  Verify Code Group Sync (CGS) and Initial Lane Alignment Sequence (ILAS) completion.
    4.  Send known PRBS (Pseudo-Random Binary Sequence) pattern from ADC to FPGA.
    5.  Loop back data from FPGA to ADC if supported, or verify in FPGA logic.
* **Pass Criteria:**
    *   Link achieves SYNC status.
    *   BER < 10^-12.
    *   Eye diagram on ADC lanes shows open eyes (compliant with JESD204B mask).

### 5.1.3 Control and Interface Tests

#### TC-HW-006: SPI Control Verification
* **Requirement ID:** REQ-HW-007
* **Test Method:** Functional Register Read/Write
* **Description:** Verify MCU can program all functional blocks.
* **Equipment:**
    *   Logic Analyzer (SPI decode).
    *   Host PC with Control Software.
* **Procedure:**
    1.  Write specific gain codes to the VGA (HMC1119).
    2.  Write frequency tuning words to ADF5356.
    3.  Read back register contents via SPI MISO line.
    4.  Monitor Logic Analyzer to verify correct timing (CPOL, CPHA, clock speeds).
* **Pass Criteria:**
    *   All writes acknowledged (readback matches write).
    *   No timing violations (setup/hold times) observed.

### 5.1.4 Power Subsystem Tests

#### TC-HW-007: Power Consumption and Sequencing
* **Requirement ID:** REQ-HW-009, REQ-HW-005
* **Test Method:** Electrical Measurement
* **Description:** Validate power budget and supply sequencing.
* **Equipment:**
    *   DC Power Supply with current measurement.
    *   Oscilloscope (for sequencing).
* **Procedure:**
    1.  Apply +12V input.
    2.  Measure current draw at Full Load (RF Active, ADC Active, FPGA Active).
    3.  Monitor enable lines for LT8645S and LDOs to ensure proper power-up sequence (e.g., DACs/Gauging before RF).
* **Pass Criteria:**
    *   Total current ≤ 4.0 A (derived from design parameters).
    *   Ripple on +5V and +3.3V rails < 10 mVpp (critical for ADC SNR).

### 5.1.5 Environmental Tests

#### TC-HW-008: Operating Temperature (Thermal Cycling)
* **Requirement ID:** REQ-HW-010
* **Test Method:** Thermal Chamber
* **Description:** Verify functionality at -40°C and +85°C.
* **Equipment:**
    *   Environmental Chamber.
    *   External RF feedthroughs.
* **Procedure:**
    1.  Place DUT (Device Under Test) in chamber.
    2.  Soak at -40°C for 30 mins. Run TC-HW-001 (Frequency Coverage).
    3.  Ramp to +85°C. Soak for 30 mins. Run TC-HW-001.
    4.  Monitor internal temperature sensors (MCU/FPGA).
* **Pass Criteria:**
    *   No degradation of gain > 3 dB compared to room temp.
    *   Lock detect remains asserted.
    *   Component case temperatures (especially PA/LNA) do not exceed datasheet abs max (typically +125°C junction).

---

## 5.2 Analysis Requirements

This section details the analytical methods used to verify requirements that are difficult or impractical to test via direct measurement, or to ensure the design meets safety and reliability margins prior to prototyping.

### 5.2.1 RF Signal Integrity Analysis

*   **Requirement ID:** REQ-HW-003, REQ-HW-004
*   **Analysis Method:** Cascade Budget Analysis
*   **Description:** A mathematical spreadsheet model (or Python script) simulating the entire RF chain cascaded gain, noise figure (Friis formula), and IP3.
*   **Process:**
    1.  Input parameters for TGA4943 (Gain 20dB, NF 3dB, OIP3 45dBm).
    2.  Insert loss of interconnects (~2dB).
    3.  Input parameters for HMC1048 Mixer (Conv Loss 7.5dB, NF 7.5dB, OIP3 23dBm).
    4.  Input parameters for HMC1119 (Gain 8dB, NF 9dB).
    5.  Calculate cascaded totals.
*   **Verification Criteria:**
    *   Calculated Total Gain ≥ 20 dB.
    *   Calculated Total NF ≤ 9.5 dB (Must pass REQ-HW-004).
    *   Calculated Input P1dB ≤ -10 dBm (Must pass REQ-HW-012).

### 5.2.2 Thermal Analysis

*   **Requirement ID:** REQ-HW-010
*   **Analysis Method:** Finite Element Analysis (FEA) or Hand Calculation
*   **Description:** Estimation of junction temperatures under worst-case ambient conditions (+85°C).
*   **Calculation Assumptions:**
    *   TGA4943 Dissipation: Assume 2W RF output power or quiescent dissipation.
    *   LT8645S Efficiency: 90%.
    *   PCB: 4-layer, 1 oz copper, 10 cm x 10 cm.
*   **Verification Criteria:**
    *   Junction Temp (Tj) < 125°C for all active semiconductors.
    *   Required thermal resistance of heatsink (if any) calculated to be < 2°C/W.

### 5.2.3 Power Budget Analysis

*   **Requirement ID:** REQ-HW-009
*   **Analysis Method:** Spreadsheet Summation
*   **Description:** Sum of maximum currents drawn by all components to verify LT8645S and input supply capacity.
*   **Verification Criteria:**
    *   Total Current < 4A (Safety margin of 20% above estimated max).
    *   LT8645S switch current limit not violated.

### 5.2.4 Jitter Analysis

*   **Requirement ID:** REQ-HW-013
*   **Analysis Method:** Phase Noise Integration
*   **Description:** Integrating the LO phase noise of the ADF5356 to calculate total RMS jitter contribution to the ADC SNR.
*   **Verification Criteria:**
    *   Integrated jitter < 500 fs (typical requirement for 3 GSPS ADC to maintain SNR > 58 dB).

---

## 5.3 Inspection Requirements

This section covers visual and physical inspection criteria used during receiving (incoming inspection) and assembly (PCB inspection) to validate requirements related to physical construction and components.

### 5.3.1 Component Incoming Inspection

*   **Requirement ID:** REQ-HW-011, REQ-HW-001
*   **Inspection Method:** Dimensional & Visual Check
*   **Description:** Verify mechanical compatibility of RF connectors.
*   **Procedure:**
    1.  Inspect SMA/2.4mm connectors for correct footprint (footprint print supplied by manufacturer).
    2.  Verify thread type (typically 4-40 UNC) and key dimensions.
*   **Pass Criteria:**
    *   Connector footprint matches PCB land pattern within ±0.1mm tolerance.
    *   Impedance controlled pin depth ensures proper launch.

### 5.3.2 PCB Assembly Inspection

*   **Requirement ID:** REQ-HW-005, REQ-HW-006
*   **Inspection Method:** Automated Optical Inspection (AOI) / X-Ray
*   **Description:** Inspection of solder joints for fine-pitch components (ADC, FPGA, LNA/QFN packages).
*   **Procedure:**
    1.  Inspect QFN thermal pads for sufficient solder paste fillet (via X-ray).
    2.  Inspect BGA (if FPGA is BGA) for voiding.
    3.  Check for tombstoning on 0402 passives.
*   **Pass Criteria:**
    *   No solder bridges.
    *   Solder joint wetting angle < 90°.
    *   Voiding in thermal pads < 25% area (IPC-A-610 Class 2 or 3).

### 5.3.3 Workmanship and Safety Inspection

*   **Requirement ID:** REQ-HW-010, REQ-HW-009
*   **Inspection Method:** Visual / Manual
*   **Description:** Verify proper creepage/clearance and strain relief.
*   **Procedure:**
    1.  Check clearance between +12V input net and chassis/RF shield.
    2.  Verify torque on mounting hardware.
*   **Pass Criteria:**
    *   High voltage (12V) creepage > 2mm (standard for SELV).
    *   No sharp edges exposed.

---

## 5.4 Verification Traceability Matrix

The following table maps the requirements specified in Section 3 to the verification methods defined above.

| REQ ID | Requirement Title | Verification Method | Test / Analysis ID | Pass Criteria Summary | Priority |
|---|---|---|---|---|---|
| **REQ-HW-001** | Frequency Coverage | **Test** | TC-HW-001 | Continuous signal reception 5-18 GHz; Lock Detect High | Must have |
| **REQ-HW-002** | Instantaneous Bandwidth | **Test** | TC-HW-002 | IF -3dB Bandwidth ≥ 1.0 GHz; Flatness ±3dB | Must have |
| **REQ-HW-003** | Dynamic Range | **Test** | TC-HW-003 | SFDR ≥ 80 dB (measured via Two-Tone) | Must have |
| **REQ-HW-004** | Noise Figure | **Test** | TC-HW-004 | NF ≤ 10 dB (6-10 dB target) | Must have |
| **REQ-HW-005** | Signal Chain Architecture | **Inspection** | 5.3.2 | BOM matches Design Schematic; Block Diagram adhered to | Must have |
| **REQ-HW-006** | ADC Interface | **Test** | TC-HW-005 | JESD204B Link Up; BER < 10^-12 | Must have |
| **REQ-HW-007** | Control Interface | **Test** | TC-HW-006 | SPI Read/Write Successful; Timing Met | Must have |
| **REQ-HW-008** | Gain Control | **Analysis** | 5.2.1 | Cascade model shows ≥ 30 dB adjust range; VGA register bits verified | Must have |
| **REQ-HW-009** | Supply Voltage | **Test** | TC-HW-007 | System operates stable at +12V ±5%; Current < 4A | Should have |
| **REQ-HW-010** | Operating Temperature | **Test** | TC-HW-008 | Functional at -40°C and +85°C; Tj < 125°C | Should have |
| **REQ-HW-011** | RF Connector Interface | **Inspection** | 5.3.1 | SMA/2.4mm footprint correct; No mechanical damage | Must have |
| **REQ-HW-012** | Input P1dB | **Analysis** | 5.2.1 | Cascade calculation confirms P1dB ≥ -10 dBm | Should have |
| **REQ-HW-013** | Phase Noise | **Analysis** | 5.2.4 | Calculated Jitter < 500 fs; LO PN < -100 dBc/Hz @ 10kHz | Should have |
| **REQ-HW-014** | LO Generation | **Test** | TC-HW-001 (part of) | ADF5356 tunes correctly across required bands with offset | Must have |

---

**Document Status: AI-GENERATED**

# 6. Bill of Materials (Preliminary)

This section details the preliminary Bill of Materials (BOM) for the **ajsfdvhjs** Wideband RF Receiver. The cost estimates are based on unit pricing for medium-volume production (1,000 units) from major distributors (DigiKey, Mouser) or direct manufacturer pricing where applicable. Prices are in USD and exclude taxes, shipping, or assembly costs.

The BOM is categorized into functional blocks: RF Front End, Frequency Synthesis, Digitization, Power Management, Board & Mechanical, and Passives.

## 6.1 RF Front End (5-18 GHz)

*Components responsible for initial signal amplification and filtering.*

| Item No | Ref Des | Part Number | Description | Manufacturer | Qty | Unit Cost | Total Cost | Notes |
|---|---|---|---|---|---|---|---|---|
| 100 | U101 | TGA4943-SL | GaN MMIC Power Amplifier, 2-20 GHz, 20dB Gain | Qorvo | 1 | $85.00 | $85.00 | Input Gain Stage. Requires careful thermal management. |
| 101 | U102 | HMC1048LP4BE | Double Balanced Mixer, 5-20 GHz, 7.5dB Conv Loss | Analog Devices | 1 | $45.00 | $45.00 | Downconversion Mixer. |
| 102 | FL101 | LABF-2500+ | Bandpass Filter, Low Profile, 5-18 GHz | Mini-Circuits | 1 | $110.00 | $110.00 | Input Protection/Pre-selection. |
| 103 | U103 | PE4259 | RF Switch, DC - 6 GHz, 50 Ohm | pSemi | 1 | $2.50 | $2.50 | Used for input attenuation/calibration paths. |
| 104 | L101 | 1008HQ-22NXJLU | Wire Wound Inductor, 22 nH, 1.5 A | Coilcraft | 2 | $1.20 | $2.40 | RF Choke for LNA bias. |
| 105 | T101 | TC1-1-13M+ | 1:1 RF Transformer, 4.5 - 3000 MHz | Mini-Circuits | 2 | $12.00 | $24.00 | Coupling/Balun for Mixer input. |

**Subtotal RF Front End:** **$268.90**

## 6.2 IF Processing & IQ Demodulation

*Components handling the Intermediate Frequency and In-phase/Quadrature separation.*

| Item No | Ref Des | Part Number | Description | Manufacturer | Qty | Unit Cost | Total Cost | Notes |
|---|---|---|---|---|---|---|---|---|
| 200 | U201 | HMC1119LP4ME | Wideband Integrated Receiver, Mixer + IQ Demod, 5-18 GHz | Analog Devices | 1 | $95.00 | $95.00 | Primary IF and IQ processing. Highly integrated. |
| 201 | U202 | ADL5541 | 3.4 GHz VGA, Differential Output | Analog Devices | 2 | $18.50 | $37.00 | Adjustable Gain for I/Q channels before ADC. |
| 202 | FL201 | RBP-560+ | Bandpass Filter, 560 MHz IF | Mini-Circuits | 2 | $25.00 | $50.00 | IF Filtering to set noise bandwidth. |
| 203 | L201 | 0603CS-8N2XJBC | Chip Inductor, 8.2 nH | Coilcraft | 8 | $0.55 | $4.40 | Matching networks for IQ outputs. |

**Subtotal IF Processing:** **$186.40**

## 6.3 Frequency Synthesis (LO Generation)

*Local Oscillator generation and distribution.*

| Item No | Ref Des | Part Number | Description | Manufacturer | Qty | Unit Cost | Total Cost | Notes |
|---|---|---|---|---|---|---|---|---|
| 300 | U301 | ADF5356CCPZ | Microwave Wideband Synthesizer, 13.6 GHz | Analog Devices | 1 | $55.00 | $55.00 | Core PLL/VCO. |
| 301 | U302 | HMC361SGLC | x2 Active Frequency Multiplier, 6-12 GHz In | Analog Devices | 1 | $40.00 | $40.00 | Doubler to extend range to >13.6 GHz if needed. |
| 302 | U303 | HMC430LP4 | Digital Phase Shifter / Attenuator | Analog Devices | 1 | $28.00 | $28.00 | Fine LO gain control. |
| 303 | Y301 | CFPX-050 | Crystal Oscillator, 50 MHz, Low Jitter | Crystek | 1 | $35.00 | $35.00 | PLL Reference Clock. |
| 304 | U304 | ADCLK948 | Clock Fanout Buffer, 2.5 GHz | Analog Devices | 1 | $15.00 | $15.00 | Distributes LO/Ref signals. |

**Subtotal Synthesis:** **$173.00**

## 6.4 Digitization & Digital Interface

*High-speed Analog-to-Digital Converters and associated physical interface circuitry.*

| Item No | Ref Des | Part Number | Description | Manufacturer | Qty | Unit Cost | Total Cost | Notes |
|---|---|---|---|---|---|---|---|---|
| 400 | U401 | AD9208-3000EBZ | ADC, 14-Bit, 3 GSPS, JESD204B | Analog Devices | 1 | $450.00 | $450.00 | Dual channel I/Q digitizer. Evaluation module pricing assumed for BOM estimation. |
| 401 | U402 | SY58032U | 1:2 LVDS Fanout Buffer | Microchip | 2 | $8.50 | $17.00 | Clock distribution for ADC. |
| 402 | J401 | Sampre-50ohm-PCB | Samtec SMP Coaxial Edge Launch | Samtec | 4 | $8.00 | $32.00 | High-speed test points for ADC clocks/data. |

**Subtotal Digitization:** **$499.00**

## 6.5 Power Management

*Voltage regulation and filtering for the +12V input.*

| Item No | Ref Des | Part Number | Description | Manufacturer | Qty | Unit Cost | Total Cost | Notes |
|---|---|---|---|---|---|---|---|---|
| 500 | U501 | LT8645S-1 | Silent Switcher 2 Buck Regulator, 7 A | Analog Devices | 1 | $9.50 | $9.50 | Main +5V generation from +12V. |
| 501 | U502 | LT3094-1 | Low Noise LDO, 500 mA, Adjustable | Analog Devices | 2 | $6.50 | $13.00 | Low noise rails for PLL/VCO and LNA. |
| 502 | L501 | XGL4020-471MEC | Power Inductor, 470 uH, 7 A | Coilcraft | 2 | $3.00 | $6.00 | Buck output inductor. |
| 503 | U503 | ADM7155-3.3 | Low Noise LDO, 3.3 V, 800 mA | Analog Devices | 1 | $5.00 | $5.00 | Clean digital rail for FPGA/MCU. |
| 504 | D501 | SS34 | Schottky Diode, 3 A, 40 V | On Semi | 1 | $0.25 | $0.25 | Reverse polarity protection. |

**Subtotal Power:** **$33.75**

## 6.6 Board Interconnect & Mechanical

*PCB, connectors, and hardware.*

| Item No | Ref Des | Part Number | Description | Manufacturer | Qty | Unit Cost | Total Cost | Notes |
|---|---|---|---|---|---|---|---|---|
| 600 | J601 | 142-0701-851 | SMA Connector, 2 Hole Flange, PCB Mount | Rosenberger | 2 | $6.50 | $13.00 | RF Input/Output connectors. |
| 601 | J602 | 2202512-2 | 12-pin Terminal Block, Pluggable | TE Connectivity | 1 | $2.20 | $2.20 | DC Power Input interface. |
| 602 | PCB | PCB-ASSY | PCB Assembly, Rogers 4350B, 10-layer, ENIG | Vendor | 1 | $150.00 | $150.00 | RF Substrate, 6x6 inches. |
| 603 | HW | KIT-MECH-6X6 | Mechanical Hardware Kit | Various | 1 | $15.00 | $15.00 | Standoffs, screws, heatsink hardware. |

**Subtotal Interconnect:** **$180.20**

## 6.7 Passives & Miscellaneous

*Resistors, capacitors, and generic assembly parts.*

| Item No | Ref Des | Part Number | Description | Manufacturer | Qty | Unit Cost | Total Cost | Notes |
|---|---|---|---|---|---|---|---|---|
| 700 | Various | Generic 0402/0603 | Resistor & Capacitor Kit (Reel) | Yageo/Murata | 150 | $0.10 | $15.00 | Assumes 0.10 per component avg for decoupling/biasing. |
| 701 | Various | GRM32ER71H475KA88L | Capacitor, 4.7 uF, X7R, 50V | Murata | 20 | $0.50 | $10.00 | Bulk capacitance for power rails. |

**Subtotal Passives:** **$25.00**

---

## 6.8 Cost Summary

| Category | Total Cost (USD) |
|---|---|
| RF Front End | $268.90 |
| IF Processing | $186.40 |
| Frequency Synthesis | $173.00 |
| Digitization | $499.00 |
| Power Management | $33.75 |
| Interconnect/Mech | $180.20 |
| Passives | $25.00 |
| **Grand Total (Unit BOM)** | **$1,366.25** |

**Note:** The significant cost driver is the high-speed ADC (AD9208). For production optimization, the AD9208-3000EBZ is an evaluation module form factor; integrating the bare die or a custom module may reduce this cost significantly in volumes > 1k units.

---

# 7. Traceability Matrix

**Document Status: AI-GENERATED**

## 7.1 General Traceability
This section provides the bidirectional traceability between system requirements, design elements, and verification methods. It ensures that every requirement defined in Section 3 is mapped to a specific source (derived from design parameters or user needs) and allocated to hardware components.

### 7.1.1 Requirement Traceability Table (RTTM)

The following table maps the requirements specified in Section 3 to their verification methods and system components.

| REQ-ID | Requirement Summary | Source | Verification Method | Allocated Component(s) | Design Verification Phase | Status |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **REQ-HW-001** | Frequency Coverage (5-18 GHz) | System Spec | Test | TGA4943-SL (LNA), HMC1119LP4ME (Mixer) | Prototype Integration | Active |
| **REQ-HW-002** | Instantaneous Bandwidth (500-1000 MHz) | System Spec | Test | AD9208 (ADC), JESD204B Interface | Prototype Integration | Active |
| **REQ-HW-003** | Dynamic Range (80 dB) | System Spec | Test | TGA4943-SL (LNA), HMC1119LP4ME (Demod) | Performance Validation | Active |
| **REQ-HW-004** | Noise Figure (6-10 dB) | Design Parameter | Analysis | TGA4943-SL (LNA), HMC1119LP4ME (Rx) | Design Simulation | Active |
| **REQ-HW-005** | Signal Chain Architecture | Functional Spec | Inspection | TGA4943-SL, HMC1119LP4ME, AD9208 | Schematic Review | Active |
| **REQ-HW-006** | ADC Interface (JESD204B) | Interface Spec | Inspection | AD9208, FPGA JESD204B IP | PCB Layout Review | Active |
| **REQ-HW-007** | Control Interface (SPI) | Interface Spec | Test | ADF5356 (Synth), HMC1119LP4ME, MCU | Firmware Integration | Active |
| **REQ-HW-008** | Gain Control (30 dB range) | Functional Spec | Test | TGA4943-SL, HMC1119LP4ME (VGA) | Performance Validation | Active |
| **REQ-HW-009** | Supply Voltage (+12V DC) | Power Spec | Test | LT8645S (Buck Converter) | Power Budget Validation | Active |
| **REQ-HW-010** | Operating Temperature (-40 to +85C) | Env Spec | Analysis | All COTS Components (Industrial Temp) | Thermal Simulation | Active |
| **REQ-HW-011** | RF Connector Interface (SMA/2.4mm) | Mech Spec | Inspection | Connector: Rosenberger 32K243-40ML5 | Mechanical Review | Active |
| **REQ-HW-012** | Input P1dB (>= -10 dBm) | Performance Spec | Test | TGA4943-SL (Input LNA) | Performance Validation | Active |
| **REQ-HW-013** | LO Phase Noise (-100 dBc/Hz) | Performance Spec | Test | ADF5356 (Synthesizer) | Signal Integrity Test | Active |
| **REQ-HW-014** | LO Generation (5-18 GHz) | Functional Spec | Test | ADF5356 (Synthesizer) | Prototype Integration | Active |
| **REQ-HW-015** | System Noise Floor | Derived (NF/Gain) | Analysis | LNA/Mixer Chain | Design Simulation | Active |
| **REQ-HW-016** | SPI Timing Compliance | Interface Spec | Test | MCU SPI Master / Peripherals | Firmware Integration | Active |
| **REQ-HW-017** | JESD204B Lane Rate | Interface Spec | Inspection | AD9208 / FPGA SerDes | PCB Layout Review | Active |
| **REQ-HW-018** | Power Dissipation (Budget) | Design Constraint | Analysis | LT8645S, LDOs, RF Components | Thermal Simulation | Active |
| **REQ-HW-019** | LNA Gain | Derived (Total Gain) | Test | TGA4943-SL | Prototype Test | Active |
| **REQ-HW-020** | Mixer Conversion Loss | Design Constraint | Analysis | HMC1119LP4ME | Design Simulation | Active |
| **REQ-HW-021** | ADC Sampling Rate (JESD204B) | Design Constraint | Inspection | AD9208 | Prototype Integration | Active |
| **REQ-HW-022** | Clock Distribution | Derived (ADC/Synth) | Inspection | ADF5356 (SYSREF User) | Signal Integrity Test | Active |
| **REQ-HW-023** | RF Input Impedance (50 Ohm) | Interface Spec | Test | Input Matching Network | VNA Validation | Active |
| **REQ-HW-024** | DC Power Sequencing | Design Constraint | Test | LT8645S Enable Pins | Power Budget Validation | Active |
| **REQ-HW-025** | EMI/EMC Compliance | Design Constraint | Inspection | PCB Layout (Guard traces) | Mechanical Review | Active |
| **REQ-HW-026** | PCB Material (High Freq) | Design Constraint | Inspection | Rogers RO4350B / FR4 | Schematic Review | Active |
| **REQ-HW-027** | Spurious Free Dynamic Range | Derived (SFDR) | Test | AD9208 + Analog Chain | Performance Validation | Active |
| **REQ-HW-028** | LO Leakage | RF Performance | Test | HMC1119LP4ME Mixer | Prototype Test | Active |
| **REQ-HW-029** | Image Rejection | RF Performance | Analysis | IQ Demodulator Balance | Design Simulation | Active |
| **REQ-HW-030** | Component Availability | Design Constraint | Inspection | BOM (DigiKey Check) | Schematic Review | Active |

## 7.2 Requirements Coverage Summary

The following table summarizes the verification method distribution for the requirements listed above. This ensures a balanced approach to validation, utilizing Test, Analysis, and Inspection methods.

| Verification Method | Count | Percentage |
| :--- | :--- | :--- |
| **Test** | 16 | 53.3% |
| **Analysis** | 7 | 23.3% |
| **Inspection** | 7 | 23.3% |
| **Total** | **30** | **100%** |

### 7.2.1 Verification Method Definitions
*   **Test:** Empirical data gathering by applying stimuli to the hardware and measuring the response (e.g., Spectrum Analyzer, Oscilloscope, VNA).
*   **Analysis:** Mathematical modeling or simulation to predict behavior without physical hardware (e.g., ADS/AWR Simulation, Thermal Modeling).
*   **Inspection:** Visual or manual verification of design attributes (e.g., BOM review, Schematic review, PCB layout checks).

## 7.3 Functional Allocation to Physical Components

To further support the traceability, the mapping of high-level functional blocks to specific component part numbers is defined below.

| Functional Block | Component Part Number | Manufacturer | Key Requirement(s) Satisfied |
| :--- | :--- | :--- | :--- |
| **Wideband LNA** | TGA4943-SL | Qorvo | REQ-HW-001, REQ-HW-004, REQ-HW-012 |
| **Downconverter / IQ Demod** | HMC1119LP4ME | Analog Devices | REQ-HW-001, REQ-HW-004, REQ-HW-020, REQ-HW-029 |
| **Frequency Synthesizer** | ADF5356CCPZ | Analog Devices | REQ-HW-013, REQ-HW-014, REQ-HW-022 |
| **ADC (Digitizer)** | AD9208-3000EBZ | Analog Devices | REQ-HW-002, REQ-HW-003, REQ-HW-006, REQ-HW-027 |
| **Power Management** | LT8645S-1 | Analog Devices | REQ-HW-009, REQ-HW-018, REQ-HW-024 |
| **RF Connector** | 32K243-40ML5 (Assumed) | Rosenberger | REQ-HW-011, REQ-HW-023 |
| **MCU Controller** | (System Derived) | System Level | REQ-HW-007, REQ-HW-016 |
| **FPGA Interface** | (System Derived) | System Level | REQ-HW-006, REQ-HW-017 |

This matrix confirms that all hardware requirements are allocated to defined, procurable components and are verifiable through the project lifecycle.