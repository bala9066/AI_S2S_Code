# 1. Introduction

## 1.1 Purpose

This Hardware Requirements Specification (HRS) defines the comprehensive system-level requirements for the **rx module**, a wideband radio frequency (RF) receiver frontend. The purpose of this document is to establish a baseline for the design, verification, and validation of the hardware architecture.

This specification addresses the engineering requirements necessary to achieve a wideband receiver covering the 5.0 GHz to 18.0 GHz frequency range with specific performance metrics regarding gain flatness, noise figure, and environmental resilience. The requirements contained herein are derived from the system concept of operations (CONOPS) for high-frequency signal interception and analysis in constrained environments.

The intended audience for this document includes:
*   **Hardware Engineers:** Responsible for schematic capture, PCB layout, and component selection.
*   **FPGA/Digital Engineers:** Responsible for interfacing with the ADC and LVDS output logic.
*   **System Integration Engineers:** Responsible for module integration and test.
*   **Quality Assurance:** Responsible for verifying compliance with MIL-STD-810 and electrical performance standards.

## 1.2 Scope

The scope of this document encompasses the complete electrical, mechanical, and environmental design of the rx module. The hardware subsystems specified include:

1.  **RF Frontend:** Including the 5-18 GHz input matching network, bandpass filtering, and Low Noise Amplification (LNA).
2.  **Frequency Conversion:** Downconversion chain comprising a Variable Gain Amplifier (VGA) and Mixer stages for signal demodulation.
3.  **Baseband Processing:** IQ Demodulation and Analog-to-Digital Conversion (ADC).
4.  **Digital Logic:** FPGA interface for data processing and LVDS output drivers.
5.  **Power Management:** DC-DC conversion and power distribution derived from a 12V DC source.
6.  **Physical Packaging:** PCB form factor, connectorization, and environmental hardening.

This document does not cover:
*   Firmware or VHDL code hosted within the FPGA (other than pin-level interface requirements).
*   System-level software or user interfaces located downstream of the LVDS outputs.
*   Mechanical tooling design (machining drawings), though dimensional requirements are specified.

## 1.3 Definitions, Acronyms, and Abbreviations

To ensure clarity and consistency, the following definitions, acronyms, and abbreviations are used throughout this specification.

| Term / Acronym | Definition |
| :--- | :--- |
| **ADC** | Analog-to-Digital Converter. A device that converts continuous physical signals (analog) to digital numbers. |
| **BOM** | Bill of Materials. A formal list of parts and items required to build the product. |
| **DC** | Direct Current. The unidirectional flow of electric charge. |
| **DSP** | Digital Signal Processing. The numerical manipulation of signals to modify or improve them. |
| **FPGA** | Field-Programmable Gate Array. An integrated circuit designed to be configured by a customer or a designer after manufacturing. |
| **GHz** | Gigahertz. A unit of frequency equal to one billion hertz. |
| **IF** | Intermediate Frequency. A frequency to which a carrier wave is shifted as an intermediate step in transmission or reception. |
| **IIP3** | Third-order Intercept Point. A figure of merit for linearity and distortion performance. |
| **LO** | Local Oscillator. An electronic oscillator used to generate a signal, typically for mixing with another signal to convert frequency. |
| **LNA** | Low Noise Amplifier. An electronic amplifier used to amplify possibly very weak signals. |
| **LVDS** | Low-Voltage Differential Signaling. A high-speed digital interface standard (TIA/EIA-644). |
| **MMIC** | Monolithic Microwave Integrated Circuit. A type of integrated circuit (IC) device that operates at microwave frequencies. |
| **MIL-STD-810** | A U.S. military standard that emphasizes tailoring an equipment's environmental design and test limits to the conditions that it will experience throughout its service life. |
| **P1dB** | 1 dB Compression Point. The point at which the input signal causes the gain to drop by 1 dB from the linear gain. |
| **PCB** | Printed Circuit Board. |
| **PHEMT** | Pseudomorphic High-Electron-Mobility Transistor. |
| **RF** | Radio Frequency. |
| **RSS** | Root Sum Square. A mathematical method for combining uncertainty values. |
| **SNR** | Signal-to-Noise Ratio. |
| **SMA** | SubMiniature version A. A coaxial RF connector standard. |
| **VGA** | Variable Gain Amplifier. An electronic amplifier whose gain can be controlled digitally or via analog voltage. |
| **VSWR** | Voltage Standing Wave Ratio. A measure of how efficiently RF power is transmitted from a power source, through a transmission line, into a load. |

### 1.3.1 Physical Units

The following system of units and notations is used for all quantitative requirements:

*   **Frequency:** Gigahertz (GHz), Megahertz (MHz)
*   **Power:** dBm (decibel-milliwatts), dBW (decibel-watts)
*   **Voltage:** Volts (V), Millivolts (mV)
*   **Current:** Amperes (A), Milliamperes (mA)
*   **Time:** Seconds (s), Nanoseconds (ns), Picoseconds (ps)
*   **Temperature:** Degrees Celsius (°C)
*   **Length/Dimension:** Millimeters (mm), Inches (in)
*   **Impedance:** Ohms (Ω)

## 1.4 References

The design and verification of the rx module shall adhere to the latest revisions of the following documents, unless otherwise specified in the "Constraints" section of individual requirements.

| Document ID | Document Title | Publisher / Source |
| :--- | :--- | :--- |
| **IEEE 29148-2018** | Systems and software engineering — Life cycle processes — Requirements engineering | IEEE Standards Association |
| **TIA/EIA-644** | Electrical Characteristics of Low Voltage Differential Signaling (LVDS) Interface Circuits | Telecommunications Industry Association |
| **MIL-STD-810H** | Test Method Standard for Environmental Engineering Considerations and Laboratory Tests | US Department of Defense |
| **JEDEC JESD204B** | Serial Interface for Data Converters | JEDEC Solid State Technology Association |
| **IPC-6012** | Qualification and Performance Specification for Rigid Printed Boards | IPC (Association Connecting Electronics Industries) |
| **IPC-2221** | Generic Standard on Printed Board Design | IPC (Association Connecting Electronics Industries) |

### 1.4.1 Component Datasheets

Specific performance characteristics referenced in this document rely on the datasheets of the following primary components:

*   **Analog Devices HMC6180LP4E:** 6-20 GHz GaAs MMIC PHEMT LNA.
*   **Analog Devices HMC698LP4:** DC-14 GHz Digital/Analog VGA.
*   **Analog Devices HMC556LC3B:** 6-20 GHz Double-Balanced Mixer.
*   **Analog Devices ADL5380:** 400 MHz - 6 GHz IQ Demodulator.
*   **Analog Devices AD9208:** Dual 14-bit, 3 GSPS ADC.
*   **Xilinx/AMD Kintex UltraScale (Selected):** FPGA datasheet (Reference for banking and LVDS standards).

## 1.5 Overview

The rx module is a state-of-the-art wideband receiver designed to capture and digitize signals across the 5.0 GHz to 18.0 GHz frequency spectrum. The system is architected to support a fractional bandwidth of 50% centered at 13 GHz. This capability is critical for applications requiring the interception of frequency-hopping or wideband signals within the C-, X-, Ku-, and K-bands.

The system architecture utilizes a **Superheterodyne** approach, optimized for wideband instantaneous capture.
1.  **RF Input Chain:** Signals enter via a 50-ohm SMA connector, passing through a bandpass filter and a high-linearity LNA to minimize noise figure while handling high input power.
2.  **Gain Adjustment:** A Variable Gain Amplifier (VGA) allows for manual gain control (MGC), enabling the system to optimize dynamic range based on signal strength.
3.  **Downconversion:** An RF Mixer downconverts the wideband signal to an Intermediate Frequency (IF) range suitable for the IQ Demodulator.
4.  **Digitization:** The baseband I and Q signals are digitized by a high-speed Dual ADC (AD9208) operating at 3 GSPS, ensuring sufficient sampling rate for the 6.5 GHz instantaneous bandwidth.
5.  **Digital Interface:** The FPGA processes the high-speed parallel data and outputs serialized I/Q data via Low-Voltage Differential Signaling (LVDS) for robust transmission to downstream processing hardware.

A critical design challenge addressed by this specification is maintaining **Gain Flatness** within ±2 dB across the entire 13 GHz span. This requires careful impedance matching network design and potentially gain compensation tables within the FPGA logic or analog trimming.

The hardware is ruggedized to meet **MIL-STD-810** standards, ensuring operation under high vibration and shock conditions typical of aerospace or tactical deployments. The power supply design is optimized to convert a standard vehicle/bus 12V DC input into the clean, low-noise rails required by sensitive RF circuitry (3.3V, 5V, 1.0V).

---

**Document Status: AI-GENERATED**

# 2. System Overview

## 2.1 System Description

The **RX Module** is a state-of-the-art, wideband microwave receiver designed to intercept, condition, and digitize Radio Frequency (RF) signals spanning the 5.0 GHz to 18.0 GHz frequency spectrum. The system is engineered to meet stringent MIL-STD-810 environmental standards while maintaining high-fidelity signal acquisition characteristics necessary for advanced signal intelligence and electronic warfare applications.

The system operates on a heterodyne architecture optimized for wide instantaneous bandwidth. The RX Module accepts a 12V DC primary input and regulates this down to the necessary voltage rails (3.3V, 5.0V, 1.8V, 1.0V) to power the RF chain, Local Oscillator (LO) circuitry, and high-speed digital logic.

At the core of the RF chain is the **Analog Devices HMC6180LP4E** Low Noise Amplifier (LNA), providing a noise figure of 2.5 dB and a gain of 21 dB. This ensures the system meets the **REQ-HW-009** noise figure target. Following the LNA, signal gain is dynamically adjusted via the **HMC698LP4** Variable Gain Amplifier (VGA), fulfilling **REQ-HW-005** (Manual Gain Control). This component allows for gain adjustments from 0 dB to 50 dB, compensating for varying input signal strengths to prevent saturation of the mixer or compression of the ADC.

Frequency downconversion is managed by the **HMC556LC3B** double-balanced mixer, which translates the 5–18 GHz RF input to an Intermediate Frequency (IF) suitable for the demodulator. The **ADL5380** IQ Demodulator then splits the IF signal into In-phase (I) and Quadrature (Q) baseband components.

Digitization is performed by the **AD9208**, a dual 14-bit, 3 GSPS Analog-to-Digital Converter. This device supports the required instantaneous bandwidth (**REQ-HW-002**) and provides sufficient resolution for spectral analysis. The digital data is handed off to an FPGA (assumed Xilinx Kintex Ultrascale class) for signal processing and formatting before being transmitted to the backend via a high-speed Low-Voltage Differential Signaling (LVDS) interface (**REQ-HW-006**).

Physically, the RX Module is constructed as a enclosed metal machined enclosure (likely aluminum or brass-plated) to provide shielding against Electromagnetic Interference (EMI) and to act as a heat sink for the high-power RF components.

### 2.1.1 Functional Flow

1.  **RF Reception:** An RF signal enters the system via an SMA connector (**REQ-HW-010**). It passes through a bandpass filter to limit out-of-band noise.
2.  **Conditioning:** The signal is amplified by the LNA and then gain-adjusted by the VGA.
3.  **Conversion:** The Mixer, driven by an external Local Oscillator (LO), downconverts the signal to an IF.
4.  **Demodulation:** The IQ Demodulator separates the signal into I and Q analog baseband signals.
5.  **Digitization:** The dual ADC samples the I and Q signals.
6.  **Processing & Output:** The FPGA processes the samples and outputs them via the LVDS interface.

---

## 2.2 System Block Diagram

The following diagram illustrates the top-level signal flow and power distribution architecture of the RX Module.

```mermaid
flowchart TD
    %% Inputs
    RF_IN["RF Input\n5-18 GHz\nSMA Connector"] --> BPF1["Bandpass Filter\n5-18 GHz\n(REQ-HW-001)"]
    PWR_IN["Power Input\n12V DC\n(REQ-HW-007)"] --> DC_DC["DC-DC Converter\nModule"]
    LO_IN["LO Input\nExternal Source"] --> LO_BUF["LO Buffer\nAmplifier"]

    %% RF Chain
    BPF1 --> LNA["LNA\nHMC6180LP4E\n21dB Gain, 2.5dB NF"]
    subgraph GAIN_CONTROL ["Gain Stage"]
        LNA --> VGA["VGA\nHMC698LP4\n0-50dB Gain Range\n(REQ-HW-005)"]
    end

    %% Mixing Stage
    LO_BUF --> LO_DRIVE
    VGA --> RF_MIX_INPUT
    LO_DRIVE --> LO_MIX_INPUT
    MIXER["Mixer\nHMC556LC3B\nDownconverter"] <|-- RF_MIX_INPUT
    MIXER <|-- LO_MIX_INPUT

    %% IF / Baseband Chain
    MIXER --> IF_AMP["IF Amplifier\nGain Block"]
    IF_AMP --> DEMOD["IQ Demodulator\nADL5380\nBaseband Output"]
    
    %% Digitization
    I_SIGNAL["I (In-Phase)"] <--> DEMOD
    Q_SIGNAL["Q (Quadrature)"] <--> DEMOD
    ADC["Dual ADC\nAD9208\n14-bit, 3 GSPS"] <--> I_SIGNAL
    ADC <--> Q_SIGNAL

    %% Digital Processing
    ADC --> FPGA["FPGA\nDSP & JESD204B\nInterface"]
    
    %% Outputs
    FPGA --> LVDS_OUT["LVDS Output\nI/Q Data Stream\n(REQ-HW-006)"]
    
    %% Power Distribution
    DC_DC -->|3.3V @ ~300mA| LNA
    DC_DC -->|5.0V @ ~400mA| VGA
    DC_DC -->|5.0V| MIXER
    DC_DC -->|5.0V| DEMOD
    DC_DC -->|1.0V / 1.8V| ADC
    DC_DC -->|1.0V / 1.8V| FPGA

    style RF_IN fill:#f9f,stroke:#333,stroke-width:2px
    style LVDS_OUT fill:#bbf,stroke:#333,stroke-width:2px
    style PWR_IN fill:#ff9,stroke:#333,stroke-width:2px
```

---

## 2.3 System Architecture

The RX Module architecture is partitioned into four distinct subsystems to ensure design modularity, ease of manufacturing, and signal integrity isolation.

### 2.3.1 RF Front-End (RFFE)

The RFFE subsystem handles the high-frequency input signals (5–18 GHz).
*   **Input Matching:** The input port is impedance matched to 50Ω to satisfy **REQ-HW-011** and ensure VSWR ≤ 2:1 (**REQ-HW-003**). A distributed microstrip matching network is utilized on the PCB.
*   **LNA Stage:** The **HMC6180LP4E** is the active component here. It sets the noise floor for the entire system. Its 21 dB gain boosts the signal above the noise floor of subsequent stages.
*   **VGA Stage:** The **HMC698LP4** provides manual gain control. Control logic is routed from the FPGA or a manual potentiometer interface to the VGA's analog control pin or 6-bit digital interface.

### 2.3.2 Frequency Conversion & IF Chain

This subsystem shifts the high-frequency RF to a manageable Intermediate Frequency (IF) and finally to baseband.
*   **LO Distribution:** The LO input passes through a buffer amplifier to ensure the Mixer receives the specified +13 dBm drive level.
*   **Mixing:** The **HMC556LC3B** Mixer performs the subtraction of the LO frequency from the RF frequency.
*   **Demodulation:** The **ADL5380** accepts the IF signal and an LO reference (shifted 90 degrees internally or externally) to produce I and Q outputs. This quadrature demodulation preserves phase and amplitude information necessary for modern digital signal processing.

### 2.3.3 Digital Subsystem

This is the high-speed processing heart of the module.
*   **Data Acquisition:** The **AD9208** digitizes the analog I and Q channels. Operating at 3 GSPS, it captures a theoretical Nyquist bandwidth of 1.5 GHz, exceeding the 6.5 GHz RF bandwidth through complex sampling techniques inherent to IQ architectures.
*   **Logic Processing:** The FPGA (utilized as a generic signal processor here) manages the JESD204B interface with the ADC, performs framing, and implements the LVDS physical layer (PHY) for data transmission to the host system. It generates the gain control voltage for the VGA based on user commands received via a side-channel (not shown in primary block diagram).

### 2.3.4 Power Management (PM)

The PM subsystem converts the rough 12V input into clean, low-noise rails.
*   **Switching Regulators:** Used for high-current rails (FPGA core, ADC buffers) to maintain efficiency.
*   **Low Dropout (LDO) Regulators:** Used for sensitive analog rails (LNA, Mixer bias) to minimize phase noise and spurious emissions.

---

## 2.4 Operating Environment

The RX Module is designed to operate in rugged environments consistent with **REQ-HW-008** (MIL-STD-810).

### 2.4.1 Physical Environment

*   **Operating Temperature:** -40°C to +85°C (Standard MIL-STD range).
    *   *Analysis:* Components selected (e.g., HMC6180LP4E) are industrial or military grade. The internal heat generation requires thermal vias and likely a heatsink attached to the metal housing.
*   **Storage Temperature:** -55°C to +125°C.
*   **Shock:** The module will withstand 40g mechanical shock (11 ms, sawtooth wave) per MIL-STD-810 Method 516.6.
*   **Vibration:** The module will survive random vibration profiles typical of rotary-wing aircraft or tracked vehicles (MIL-STD-810 Method 514.6). PCB assembly will utilize conformal coating and staking of large components.

### 2.4.2 Electrical Environment

*   **Supply Voltage:** 12V DC nominal.
    *   *Tolerance:* The system must tolerate input voltage transients between 10.8V and 13.2V (±10%).
    *   *Ripple:* Input supply ripple must be suppressed to < 100mV peak-to-peak by internal filtering.
*   **Impedance:** The RF source impedance is defined as 50Ω.
*   **EMI/EMC:** The module shall not emit radiated emissions exceeding RE102 limits and must be immune to RS103 susceptibility limits.

### 2.4.3 Atmospheric Conditions

*   **Humidity:** 0% to 95% non-condensing.
*   **Altitude:** Operational up to 15,000 feet (unpressurized), requiring derating of high-voltage components (if any) and consideration of reduced cooling airflow.

---

**Document Status: AI-GENERATED**

# 3. Hardware Requirements

## 3.1 Functional Requirements

This section details the functional capabilities of the **rx module**. Each requirement is derived from the system architecture and component selections (Analog Devices HMC series, AD9208, Xilinx Zynq UltraScale+).

### 3.1.1 RF Signal Reception and Conditioning

| ID | Requirement | Description | Rationale | Verification Method | Priority |
|---|---|---|---|---|---|
| **REQ-HW-101** | **RF Input Reception** | The system shall accept a single-ended RF input signal via a 50Ω SMA connector (Edge-launch or PCB mount) covering the frequency range of 5.0 GHz to 18.0 GHz. | Primary operational input required by project scope. | Inspection / Test | **High** |
| **REQ-HW-102** | **Input Bandpass Filtering** | The system shall incorporate a bandpass filter at the input stage with a passband of 5-18 GHz and a rejection of ≥20 dB at 3 GHz and 20 GHz. | To limit out-of-band noise and interference prior to the LNA. | Analysis (S-Parameter) | **High** |
| **REQ-HW-103** | **Low Noise Amplification** | The system shall utilize the HMC6180LP4E LNA to provide a minimum of 20 dB of gain with a Noise Figure (NF) ≤ 2.8 dB across the band. | Sets the noise floor for the entire receiver chain. | Test (Noise Figure Meter) | **High** |
| **REQ-HW-104** | **Front-End Protection** | The system shall include a limiter or protection circuit capable of withstanding a 1W continuous wave (CW) input overload for 1 minute without degradation. | To protect the sensitive GaAs LNA from accidental high-power exposure. | Test (Power Injection) | **Medium** |
| **REQ-HW-105** | **Variable Gain Control (VGA)** | The system shall utilize the HMC698LP4 VGA to provide gain adjustment from 0 dB to 50 dB via a 6-bit parallel interface. | Facilitates manual gain control requirement (REQ-HW-005). | Test (Functional) | **High** |
| **REQ-HW-106** | **Gain Control Interface** | The 6-bit gain control words shall be supplied by the FPGA GPIO banks (3.3V logic levels) mapped to the VGA's parallel control pins. | Integration between digital logic and analog RF gain block. | Inspection / Demonstration | **High** |
| **REQ-HW-107** | **Mixer Downconversion** | The system shall employ the HMC556LC3B mixer to downconvert the RF signal to an Intermediate Frequency (IF) using an external Local Oscillator (LO). | Frequency translation required for signal processing. | Inspection | **High** |
| **REQ-HW-108** | **LO Input Interface** | The system shall provide a dedicated SMA connector for the LO input, accepting a signal level of +13 dBm to +17 dBm (sine wave) between 6 GHz and 20 GHz. | Specific drive requirement for the HMC556LC3B mixer. | Test | **High** |
| **REQ-HW-109** | **IF Amplification** | The system shall provide ≥15 dB of gain in the IF chain (post-mixer) to compensate for mixer conversion loss (~10 dB) and filter insertion loss. | To ensure sufficient signal level for the IQ Demodulator. | Analysis (Gain Budget) | **High** |

### 3.1.2 I/Q Demodulation and Digitization

| ID | Requirement | Description | Rationale | Verification Method | Priority |
|---|---|---|---|---|---|
| **REQ-HW-110** | **IQ Demodulation** | The system shall utilize the ADL5380 to generate differential I (In-phase) and Q (Quadrature) baseband signals from the IF input. | Direct conversion architecture simplifies digital filtering. | Test (Vector Signal Analyzer) | **High** |
| **REQ-HW-111** | **Baseband Anti-Aliasing Filtering** | The system shall include differential 7th-order elliptic low-pass filters (LC network) between the ADL5380 outputs and ADC inputs with a -3 dB cutoff of 1.5 GHz. | To meet Nyquist criteria for the 3 GSPS ADC and reject high-frequency mixing products. | Analysis (AC Simulation) | **High** |
| **REQ-HW-112** | **Analog-to-Digital Conversion** | The system shall digitize I and Q signals using the AD9208 Dual ADC operating at 3.0 GSPS. | Provides high sampling rate for wide instantaneous bandwidth. | Test (Capture Data) | **High** |
| **REQ-HW-113** | **ADC Clocking** | The system shall accept a differential low-jitter clock source (<100 fs RMS jitter) via an SMA connector to drive the AD9208 CLK+/- pins. | ADC clock jitter directly impacts Signal-to-Noise Ratio (SNR) at high frequencies. | Test (Phase Noise) | **High** |
| **REQ-HW-114** | **JESD204B Interface** | The ADC shall transmit digitized data to the FPGA via two lanes of JESD204B Subclass 1 operating at the line rate of 12.5 Gbps per lane. | High-speed data transfer standard compatible with Xilinx GTH transceivers. | Test (Link Training) | **High** |
| **REQ-HW-115** | **FPGA Buffering** | The FPGA (Xilinx Zynq UltraScale+) shall perform lane alignment and 8b/10b decoding on the incoming JESD204B streams. | Required to reconstruct the ADC samples in the fabric. | Test (Logic Analyzer) | **High** |

### 3.1.3 Digital Processing and Output

| ID | Requirement | Description | Rationale | Verification Method | Priority |
|---|---|---|---|---|---|
| **REQ-HW-116** | **Digital Decimation** | The system shall implement a programmable FIR filter within the FPGA fabric to decimate the 3 GSPS data stream to rates of 3.0, 1.5, or 0.75 GSPS. | Reduces data throughput requirements for the LVDS output interface. | Demonstration | **Medium** |
| **REQ-HW-117** | **LVDS Data Transmission** | The system shall output processed I/Q data to external backplane connectors via 16 LVDS pairs (8 for I, 8 for Q) operating at 1.2 Gbps per pair. | Interface requirement per project parameters. | Test (Eye Diagram) | **High** |
| **REQ-HW-118** | **Output Format** | The LVDS output shall utilize Double Data Rate (DDR) LVDS signaling, compliant to ANSI/TIA/EIA-644-A standard. | Ensures interoperability with standard LVDS receivers. | Inspection | **High** |

### 3.1.4 Power Distribution

| ID | Requirement | Description | Rationale | Verification Method | Priority |
|---|---|---|---|---|---|
| **REQ-HW-119** | **DC Input** | The system shall operate from a single 12V DC supply input (range 10.8V to 13.2V). | Standard vehicle/military supply rail (12V ±10%). | Test (Voltage Margin) | **High** |
| **REQ-HW-120** | **DC-DC Conversion** | The system shall employ isolated DC-DC converters to generate the following rails: <br> - 3.3V @ 500mA (LNA/VGA/LO Logic) <br> - 5.0V @ 1.5A (Mixer/Demodulator) <br> - 1.0V @ 3A (FPGA Core) <br> - 1.8V @ 2A (FPGA Aux/ADC) | To step down 12V input to voltage levels required by specific components. | Test (Load Regulation) | **High** |
| **REQ-HW-121** | **Power Sequencing** | The power management logic shall sequence the 1.0V FPGA rail before the 3.3V GPIO rails to prevent latch-up or IO damage. | Xilinx FPGA requirement for reliable startup. | Test (Oscilloscope) | **High** |

---

## 3.2 Performance Requirements

This section quantifies the measurable performance characteristics of the hardware. Values are derived from component datasheets and cascade analysis.

### 3.2.1 RF Performance

| ID | Parameter | Requirement Specification | Calculation / Basis | Verification | Priority |
|---|---|---|---|---|---|
| **REQ-HW-PW-101** | **Operational Frequency Range** | 5.0 GHz to 18.0 GHz | System design specification. | RF Sweep | **High** |
| **REQ-HW-PW-102** | **Input Return Loss (VSWR)** | ≤ 2.0:1 (Return Loss ≥ 9.54 dB) | Derived from HMC6180LP4E datasheet and input matching network design. | Network Analyzer | **High** |
| **REQ-HW-PW-103** | **Noise Figure (NF)** | ≤ 5.0 dB (System Total) | **Calculation:** <br> LNA NF (2.5 dB) dominates cascade. <br> $NF_{sys} \approx NF_{LNA} + \frac{NF_{sub}-1}{G_{LNA}}$ <br> Assuming VGA NF=6dB @ 20dB LNA Gain. <br> $2.5 + \frac{3.98-1}{100} \approx 2.53 dB$ at front end. <br> Total budget allows for mixer/ADC degradation up to 5dB. | Noise Figure Meter | **High** |
| **REQ-HW-PW-104** | **Gain (Maximum)** | 55 dB ± 3 dB (at Maximum VGA setting) | **Calculation:** <br> LNA (21 dB) + VGA Max (50 dB) - Mixer Loss (-10 dB) + IF Amp (15 dB) + Demod Gain (6 dB). <br> Total = 21 + 50 - 10 + 15 + 6 = 82 dB (Theoretical). <br> Requirement accounts for PCB losses and margin. | Gain Sweep | **High** |
| **REQ-HW-PW-105** | **Gain Flatness** | ± 2.0 dB (peak-to-peak) | Driven by filter response (BPF+LPF) and LNA gain slope (±1.5dB typical). | Vector Network Analyzer | **High** |
| **REQ-HW-PW-106** | **Input P1dB (Compression)** | ≥ -30 dBm (at Maximum Gain) | **Calculation:** <br> Limited by Mixer IIP3 (+23 dBm) and LNA OIP3. <br> System gain of 55 dB implies a very sensitive input. <br> P1dB_in = P1dB_out - Gain. <br> VGA P1dB is +19 dBm. <br> Input P1dB approx +19 - 55 = -36 dBm. | Two-Tone Test | **High** |
| **REQ-HW-PW-107** | **Instantaneous Bandwidth** | 6.5 GHz | Defined by RF Front-end (5-18 GHz range). The limiting factor is the ADL5380 demodulator bandwidth (1.7 GHz) and AD9208 input BW (9 GHz). | Modulation Test | **High** |

### 3.2.2 Digital and Signal Processing Performance

| ID | Parameter | Requirement Specification | Calculation / Basis | Verification | Priority |
|---|---|---|---|---|---|
| **REQ-HW-PW-108** | **ADC Resolution** | 14 bits (Effective Number of Bits > 10.5 at 1 GHz) | Based on AD9208 datasheet SNR performance (~65 dB FS). | FFT Analysis | **High** |
| **REQ-HW-PW-109** | **ADC Spurious-Free Dynamic Range (SFDR)** | ≥ 65 dBc | Requirement for detecting weak signals in presence of strong blockers. | FFT Analysis | **High** |
| **REQ-HW-PW-110** | **JESD204B Lane Rate** | 12.5 Gbps (configured for 3.0 GSPS capture) | **Calculation:** <br> Formula: $Lane Rate = \frac{20 \times M \times S \times 10}{8 \times F}$ <br> For M=2 (converters), S=1 (samples/converter), L=4 lanes. <br> Calculated rate to handle 3GSPS x 14bit raw data. | Link Training / BER | **High** |
| **REQ-HW-PW-111** | **LVDS Output Data Rate** | 1.2 Gbps per pair | Standard FPGA IO capability for DDR LVDS. | Timing Analysis | **High** |
| **REQ-HW-PW-112** | **Phase Noise (LO Input)** | -100 dBc/Hz @ 10 kHz offset | Required to maintain SNR. The ADL5380 requires clean LO. | Phase Noise Analyzer | **Medium** |

### 3.2.3 Environmental and Physical Performance

| ID | Parameter | Requirement Specification | Calculation / Basis | Verification | Priority |
|---|---|---|---|---|---|
| **REQ-HW-PW-113** | **Operating Temperature** | -40°C to +85°C (Baseplate) | MIL-STD-810 temperature range for storage and operation. Components (COTS) are Industrial/Auto grade rated to at least 85°C. | Thermal Chamber | **High** |
| **REQ-HW-PW-114** | **Power Consumption** | ≤ 25 Watts (Total) | **Calculation:** <br> HMC6180 LNA: 3.3V * 0.09A = 0.3W <br> HMC698 VGA: 5V * 0.1A = 0.5W <br> HMC556 Mixer: 5V * 0.15A = 0.75W <br> ADL5380 Demod: 5V * 0.24A = 1.2W <br> AD9208 ADC: 1.8V*1.2A + 1.0V*0.9A ≈ 3.0W <br> Zynq FPGA (e.g., ZU7EV): ~8W (typical). <br> Leakage/DCDC Losses: ~5W. <br> Total est: 19W. 25W is safe limit with margin. | Power Meter | **High** |
| **REQ-HW-PW-115** | **Thermal Resistance (Junction)** | $\Theta_{JA} \le 25°C/W$ (for critical RF ICs) | Ensures junction temps stay within limits assuming worst-case ambient. | Thermal Simulation | **High** |
| **REQ-HW-PW-116** | **Random Vibration** | Operate compliant to MIL-STD-810G Method 514.6, Category 4 (Jet aircraft/missile). | Military environment requirement defined in Project Summary. | Vibration Table | **High** |

---

**Document Status: AI-GENERATED**

# 3. Hardware Requirements

## 3.3 Interface Requirements

This section details the electrical and physical interfaces required for the RX Module to function within the system. Interfaces are categorized as external (connecting to other system units) and internal (inter-board or inter-component).

### 3.3.1 External Interfaces

The RX Module utilizes multiple external interfaces for RF signal ingress, power delivery, LO injection, and high-speed data egress.

#### 3.3.1.1 RF Input Interface

**REQ-HW-012:** The RX Module shall provide a single RF input port compatible with SMA connectors.
**REQ-HW-013:** The RF input port shall maintain a characteristic impedance of $50\,\Omega$.
**REQ-HW-014:** The RF input port shall exhibit a Voltage Standing Wave Ratio (VSWR) of 2:1 or less across the 5.0 GHz to 18.0 GHz operating band.

*Table 7: RF Input Interface Characteristics*

| Parameter | Value | Unit | Notes |
| :--- | :--- | :--- | :--- |
| **Connector Type** | SMA (Female) | - | Threaded interface for vibration robustness |
| **Impedance** | 50 | $\Omega$ | Nominal |
| **Frequency Range** | 5.0 - 18.0 | GHz | Operational band |
| **VSWR (Max)** | 2.0:1 | - | Corresponds to Return Loss $\ge$ 9.5 dB |
| **Maximum Input Power** | +15 | dBm | 10 dB below P1dB of HMC6180LP4E |
| **Insertion Loss** | $\le$ 0.5 | dB | Estimate for edge-launch connector and trace |

#### 3.3.1.2 Local Oscillator (LO) Input Interface

To facilitate the downconversion mixers, an external LO signal must be injected.

**REQ-HW-015:** The module shall provide an SMA input for the Local Oscillator signal.
**REQ-HW-016:** The LO input shall operate over a frequency range sufficient to downconvert the 5–18 GHz RF band to the desired IF frequency (assumption: LO range 4.8–17.8 GHz for 200 MHz IF).
**REQ-HW-017:** The LO input shall accept a signal level of +13 dBm $\pm$ 3 dB.

*Table 8: LO Input Interface Characteristics*

| Parameter | Value | Unit | Notes |
| :--- | :--- | :--- | :--- |
| **Connector Type** | SMA (Female) | - | |
| **Impedance** | 50 | $\Omega$ | |
| **Frequency Range** | 4.8 - 17.8 | GHz | Matching Mixer HMC556LC3B range |
| **Input Power** | +13 $\pm$ 3 | dBm | Optimized for HMC556LC3B drive level |
| **Return Loss** | $\ge$ 10 | dB | |

#### 3.3.1.3 DC Power Input Interface

**REQ-HW-018:** The module shall accept input power via a 12V DC supply.
**REQ-HW-019:** The module shall utilize a qualified MIL-SPEC circular connector (e.g., Amphenol 97-Series) or a compliant micro-D connector for the primary power input to ensure vibration resistance.

*Table 9: DC Power Input Pin Definition*

| Pin Number | Signal Name | Description | Voltage | Current (Max) |
| :--- | :--- | :--- | :--- | :--- |
| 1 | +12V_IN | Main Power Input | +10.8V to +13.2V | 2.5 A |
| 2 | +12V_IN | Main Power Input (Return path) | +10.8V to +13.2V | 2.5 A |
| 3 | GND | Power Return | 0 V | 2.5 A |
| 4 | GND | Power Return | 0 V | 2.5 A |

### 3.3.2 Internal Interfaces

These interfaces define the connectivity between the major components on the RX Module PCB (e.g., LNA to VGA, Mixer to IF Amp).

#### 3.3.2.1 RF Signal Chain Interconnects

**REQ-HW-020:** Signal traces between the LNA, VGA, Mixer, and IF Amplifier shall be controlled impedance transmission lines (microstrip or grounded coplanar waveguide) matched to $50\,\Omega$.

*Table 10: Internal RF Interconnects*

| From Block | To Block | Interface Type | Trace Impedance | Length (Est.) |
| :--- | :--- | :--- | :--- | :--- |
| **SMA In** | **LNA** | Controlled Microstrip | 50 $\Omega$ | 0.25 in |
| **LNA Out** | **VGA In** | Controlled Microstrip | 50 $\Omega$ | 0.5 in |
| **VGA Out** | **Mixer RF In** | Controlled Microstrip | 50 $\Omega$ | 0.5 in |
| **Mixer IF Out** | **IF Amp In** | Controlled Microstrip | 50 $\Omega$ | 0.75 in |
| **IF Amp Out** | **IQ Demod In** | Controlled Microstrip | 50 $\Omega$ | 0.5 in |

#### 3.3.2.2 FPGA to ADC Interface

**REQ-HW-021:** The FPGA shall receive digitized data from the ADC via a JESD204B serial interface.
**REQ-HW-022:** The JESD204B interface shall operate at a line rate compliant with the ADC sample rate (3 GSPS $\times$ 14 bits / lanes $\approx$ 12.91 Gbps per lane).

*Table 11: ADC to FPGA Signal Mapping*

| Signal Name | Direction | Driver | Receiver | Voltage Standard |
| :--- | :--- | :--- | :--- | :--- |
| JESD_CKP | ADC $\to$ FPGA | AD9208 | FPGA IO | CML (Current Mode Logic) |
| JESD_CKN | ADC $\to$ FPGA | AD9208 | FPGA IO | CML |
| JESD_FKP | ADC $\to$ FPGA | AD9208 | FPGA IO | CML |
| JESD_FKN | ADC $\to$ FPGA | AD9208 | FPGA IO | CML |
| SYNC~ | FPGA $\to$ ADC | FPGA IO | AD9208 | LVDS |
| REFCLK | FPGA $\to$ ADC | FPGA PLL | AD9208 | LVDS / HCSL |

### 3.3.3 Communication Interfaces

This section covers the digital data output and control interfaces.

#### 3.3.3.1 LVDS Digital Output

**REQ-HW-023:** The RX Module shall output processed I/Q data via an LVDS-compatible high-speed connector (e.g., Samtec QTE/QSE series).
**REQ-HW-024:** The LVDS outputs shall comply with the TIA/EIA-644-A electrical standard.

*Table 12: LVDS Output Interface Pin Definition (High-Speed)*

| Pin Number | Signal Name | Description | I/O Type |
| :--- | :--- | :--- | :--- |
| 1 | I_Data_P | In-phase Data Positive | Output |
| 2 | I_Data_N | In-phase Data Negative | Output |
| 3 | Q_Data_P | Quadrature Data Positive | Output |
| 4 | Q_Data_N | Quadrature Data Negative | Output |
| 5 | CLK_P | Data Clock Positive | Output |
| 6 | CLK_N | Data Clock Negative | Output |
| 7..12 | GND | Ground Reference | - |

*Table 13: LVDS Electrical Characteristics*

| Parameter | Min | Typ | Max | Unit |
| :--- | :--- | :--- | :--- | :--- |
| **Common Mode Voltage** | 1.125 | 1.2 | 1.375 | V |
| **Differential Swing** | 247 | 350 | 454 | mV |
| **Data Rate** | - | - | 3.0 | Gbps |

#### 3.3.3.2 Gain Control Interface

**REQ-HW-025:** The RX Module shall support Manual Gain Control (MGC) via a serial peripheral interface (SPI) or analog voltage.

*Table 14: Gain Control Interface*

| Interface Type | Connector/Pin | Logic Level | Description |
| :--- | :--- | :--- | :--- |
| **Digital SPI** | Header (2x3) | 3.3V CMOS | MOSI, MISO, SCK, CSb to control HMC698LP4 VGA gain settings. |
| **Analog Backup** | Test Point | 0 - 3.3V | Single pin for direct analog gain control voltage if digital mode fails. |

## 3.4 Environmental Requirements

The RX Module is designed for deployment in harsh environments as defined by military standards.

**REQ-HW-026:** The RX Module shall comply with MIL-STD-810G (Method 520.3) for temperature operation.
**REQ-HW-027:** The RX Module shall maintain functional integrity during vibration exposure per MIL-STD-810G (Method 514.6).
**REQ-HW-028:** The RX Module shall withstand pyroshock and functional shock per MIL-STD-810G (Method 516.6).

*Table 15: Environmental Operating Limits*

| Parameter | Requirement | Specification Level | Test Method |
| :--- | :--- | :--- | :--- |
| **Operating Temp** | Standard | -40°C to +71°C | MIL-810G 520.3, Proc I |
| **Storage Temp** | Storage | -55°C to +85°C | MIL-810G 520.3, Proc II |
| **Humidity** | Immersion | 95% RH (Non-condensing) | MIL-810G 507.5 |
| **Vibration** | Helicopter/Air | 5-2000 Hz, 0.03 g^2/Hz | MIL-810G 514.6, Cat 20/21 |
| **Shock** | Transit Drop | 40g, 11ms, half-sine | MIL-810G 516.6, Proc IV |
| **Altitude** | Pressure | 0 to 15,000 ft | MIL-810G 500.5 |

*Table 16: Derating and Safety Factors*

| Component Type | Stress Parameter | Derating Factor |
| :--- | :--- | :--- |
| **Voltage Regulators** | Output Voltage | 20% headroom maintained |
| **Capacitors** | Voltage Rating | 50% (Operating $\le$ 50% of Rated) |
| **RF Components** | Input Power | -10 dB (Operating input < P1dB - 10dB) |
| **Connectors** | Current | 50% (Operating < 50% of Rated) |

## 3.5 Power Requirements

This section defines the power consumption and distribution requirements based on the selected components. Calculations assume maximum load conditions and 12V nominal input.

### 3.5.1 Total Power Budget

**REQ-HW-029:** The RX Module shall consume no more than 30 Watts of total input power at 12V DC.

### 3.5.2 Power Rail Analysis

The system requires a 12V input, which is stepped down to various rails. Based on the selected components:

*   **LNA (HMC6180LP4E):** 3.3V @ 90 mA
*   **VGA (HMC698LP4):** 5V @ 180 mA (Assumed typ for high gain)
*   **Mixer (HMC556LC3B):** 5V @ 150 mA (Assumed)
*   **IQ Demod (ADL5380):** 5.0V @ 250 mA (Typical 240mA)
*   **ADC (AD9208):** 1.0V (Core) @ 1.8A, 1.8V (IO) @ 500mA (High performance mode)
*   **FPGA (Artix-7 or similar):** 1.0V (Core) @ 2.5A, 2.5V (Aux) @ 200mA (Assumed for LVDS buffers)
*   **LO Buffer (Driver):** 5V @ 100 mA

*Table 17: Detailed Power Budget*

| Voltage Rail | Source | Component(s) | Current (Typ) | Current (Max) | Power (W) |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **12V Input** | External Supply | DC-DC Input | - | **2.10 A** | **25.20 W** |
| **7.0 V** | DC-DC Converter | LO Driver / Bias T | 100 mA | 120 mA | 0.84 W |
| **5.0 V** | DC-DC Converter | VGA, Mixer, IQ Mod, | 760 mA | 900 mA | 4.50 W |
| **3.3 V** | DC-DC Converter | LNA, FPGAs IO | 150 mA | 200 mA | 0.66 W |
| **2.5 V** | DC-DC Converter | FPGA Aux | 200 mA | 250 mA | 0.63 W |
| **1.8 V** | DC-DC Converter | FPGA IO, ADC IO | 700 mA | 850 mA | 1.53 W |
| **1.0 V** | DC-DC Converter | FPGA Core, ADC Core | 3.80 A | 4.50 A | 4.50 W |
| **Efficiency** | Assumption | DC-DC Conv. | - | - | **85%** |
| **Total Power** | **Calculated** | **System Total** | - | - | **~24.5 W** |

*Note: Power calculations include 85% efficiency factor for DC-DC conversion.*

**REQ-HW-030:** The DC-DC conversion subsystem shall maintain a minimum efficiency of 80% at full load.
**REQ-HW-031:** The power supply shall utilize input filtering to limit input ripple and conductive emissions per MIL-STD-461.

### 3.5.3 Power Sequencing

**REQ-HW-032:** The power management circuitry shall sequence the voltage rails such that the 1.0V FPGA core rail ramps *after* the 2.5V/3.3V IO rails to prevent latch-up.

## 3.6 Physical Requirements

### 3.6.1 Enclosure and Dimensions

**REQ-HW-033:** The RX Module shall be enclosed in a conductive (plated aluminum or copper) RF shield to contain EMI.
**REQ-HW-034:** The module shall utilize a standard conduction-cooled card edge or wedge lock interface for thermal transfer to the chassis.

*Table 18: Mechanical Dimensions*

| Dimension | Value | Unit | Tolerance |
| :--- | :--- | :--- | :--- |
| **Width** | 3.0 | inches | $\pm$ 0.010 |
| **Depth** | 4.0 | inches | $\pm$ 0.010 |
| **Height** (max component) | 0.4 | inches | $\pm$ 0.005 |
| **PCB Thickness** | 0.062 | inches | $\pm$ 0.004 |
| **Mounting Holes** | #4-40 UNC | - | - |

### 3.6.2 Weight

**REQ-HW-035:** The total weight of the RX Module (excluding connectors) shall not exceed 250 grams.

### 3.6.3 Material Finish

**REQ-HW-036:** The PCB shall utilize Rogers RO4350B or equivalent low-loss material (Er $\approx$ 3.48) for RF traces and standard FR-4 for digital sections (hybrid stackup).
**REQ-HW-037:** The enclosure finish shall be Electroless Nickel Immersion Gold (ENIG) or Chem Film (Alodine) per MIL-DTL-5541 Class 3 for corrosion resistance.

### 3.6.4 Thermal Requirements

**REQ-HW-038:** The RX Module shall operate within the temperature limits of Section 3.4 without the need for forced air cooling (conduction cooled only).
**REQ-HW-039:** Thermal vias shall be placed under the high-power dissipating components (ADC, FPGA, LNA) to transfer heat to the chassis.

*Table 19: Thermal Dissipation Estimates*

| Component | Power Dissipation | Thermal Resistance ($\theta_{JA}$) | Temp Rise |
| :--- | :--- | :--- | :--- |
| **FPGA** | 4.5 W | 15 °C/W (W/Heatsink) | 67.5 °C |
| **ADC** | 2.0 W | 25 °C/W (W/Heatsink) | 50.0 °C |
| **LNA** | 0.3 W | 80 °C/W | 24.0 °C |
| **Regulators** | 3.0 W | 30 °C/W | 90.0 °C |
| **Total** | **24.5 W** | - | - |

**Thermal Analysis:**
Assuming a case temperature of 55°C (max operating ambient + rise), the FPGA junction temperature would be approx:
$T_j = T_c + (P \times \theta_{JC}) + (P \times \theta_{\text{interface}})$
$T_j \approx 55^\circ C + (4.5W \times 0.5^\circ C/W) + (4.5W \times 0.1^\circ C/W) \approx 57.7^\circ C$ (well under safe limits).

**REQ-HW-040:** The PCB stackup shall have a minimum of 6 layers to provide adequate ground and power planes (Layer stack: Top(Sig)-GND-PWR(Sig)-GND-PWR(Sig)-Bot(Sig)).

---

**Document Status: AI-GENERATED**

# 4. Design Constraints

## 4.1 Standards Compliance

The rx module hardware design shall adhere to the following industry and military standards to ensure manufacturability, reliability, environmental resilience, and electromagnetic compatibility. Compliance with these standards forms the baseline for the design rules and verification procedures.

### 4.1.1 Hardware Construction and Materials
*   **IPC-2221 Generic Standard on Printed Board Design:** The printed circuit board (PCB) stackup, trace widths, spacing, and conductor thickness shall be designed in accordance with IPC-2221. Specifically, given the high-frequency operation (up to 18 GHz), strict microstrip and stripline impedance control tolerances of ±5% (derived from 50Ω system impedance) shall be maintained via controlled dielectric construction.
*   **IPC-6012 Qualification and Performance Specification for Rigid Printed Boards:** The bare PCB fabrication shall meet Class 3 requirements of IPC-6012 (High Performance Electronic Products) to ensure reliability in harsh environments. This includes requirements for plating thickness, hole wall quality, and laminate integrity.
*   **IPC-7711/7721 Rework of Electronic Assemblies:** Any repair or rework of the populated assembly shall follow IPC-7711/7721 guidelines to prevent damage to high-frequency laminates and sensitive MMICs.

### 4.1.2 Environmental and Mechanical
*   **MIL-STD-810H Environmental Engineering Considerations and Laboratory Tests:** As required by REQ-HW-008, the design shall physically withstand the test methods defined in MIL-STD-810H. Specifically:
    *   **Method 514.6 (Vibration):** The design shall survive random vibration profiles typical of rotary-wing aircraft or tracked vehicles (assumed 20-2000Hz, 0.04g²/Hz).
    *   **Method 516.6 (Shock):** The module shall maintain functionality after 40g, 11ms shock pulses.
    *   **Method 527.5 (Vibration - Mechanical):** Component mounting methods (adhesives, staking) shall be employed for components with a mass > 1 gram.
*   **MIL-STD-202G Test Methods for Electronic and Electrical Component Parts:** The selected active and passive components shall be qualified to relevant test methods within MIL-STD-202G (e.g., Method 213 for Moisture Resistance) where applicable.

### 4.1.3 Electromagnetic Compliance (EMC)
*   **MIL-STD-461G Requirements for the Control of Electromagnetic Interference Characteristics of Subsystems and Equipment:** The module design shall limit conducted and radiated emissions.
    *   **CE102 (Conducted Emissions, Power Leads, 10 kHz – 10 MHz):** DC-DC converter switching noise shall be filtered to meet these limits on the 12V input line.
    *   **RE102 (Radiated Emissions, Electric Field, 2 MHz – 18 GHz):** The shielded enclosure and RF connector grounding shall ensure radiated emissions do not exceed limits.
*   **IEEE 29148:2018 Systems and software engineering — Life cycle processes — Requirements engineering:** This document is generated in compliance with this standard.

### 4.1.4 Safety and Hazardous Materials
*   **RoHS (Restriction of Hazardous Substances) Directive 2011/65/EU:** The design shall comply with RoHS restrictions. However, given the MIL-STD requirement, "RoHS-Exempt" lead-based solder finishes (SnPb) may be utilized for high-reliability solder joints if deemed necessary for thermal cycling performance, otherwise Tin-Silver-Copper (SAC) alloy shall be used.
*   **REACH (Registration, Evaluation, Authorisation and Restriction of Chemicals):** All substances shall be registered under REACH.
*   **UL 94 (Standard for Safety of Flammability of Plastic Materials):** All PCB laminates and insulating materials used in the module must achieve a V-0 flammability rating.

### 4.1.5 Interconnect and Data
*   **TIA/EIA-644-A Electrical Characteristics of Low Voltage Differential Signaling (LVDS) Interface Circuits:** The digital I/Q outputs shall strictly adhere to this standard to ensure interoperability with downstream signal processing equipment.
*   **JESD204B Standard (JEDEC):** The high-speed link between the ADC and FPGA shall comply with JESD204B subclass 1 deterministic latency requirements.

---

## 4.2 Component Constraints

The selection and application of electronic components are governed by specific constraints to ensure system longevity, performance under environmental stress, and supply chain stability.

### 4.2.1 Supply Chain and Lifecycle
*   **Lifecycle Status:** All components designated for production shall be in "Active" or "Not Recommended for New Design" (NRND) status only if sufficient inventory for the full production run (assumed 500 units minimum) is secured. Obsolete components are strictly prohibited.
*   **Form, Fit, Function (FFF):** Any proposed substitution for the primary components listed in Section 6 must be a drop-in replacement (pin-to-pin compatible) or require a PCB spin (Level 3 Engineering Change Order).
*   **Supplier Diversity:** Critical components (FPGA, ADC, MMICs) shall be dual-sourced where possible. For single-source items like the AD9208 ADC, a "Last Time Buy" (LTB) strategy or long-term supply agreement must be established.

### 4.2.2 Frequency and Packaging Constraints
*   **RF Component Packaging:** To minimize parasitic inductance and capacitance at 18 GHz, all components in the RF chain (up to the IQ Demodulator) shall utilize surface-mount packages compatible with RF microstrip transmission lines.
    *   *Allowed:* Chip Scale Packages (CSP), QFN (no leads), or die-on-ceramic.
    *   *Prohibited:* Leaded packages (SOIC, TSSOP) in the RF signal path.
*   **Dielectric Constant Stability:** Components utilizing internal dielectrics (capacitors, filters) shall specify C0G/NP0 dielectric for temperature stability (±30 ppm/°C or better). X7R is not permitted in the RF signal path due to piezoelectric effects and voltage coefficient.

### 4.2.3 Component Derating
To ensure reliability and reduce stress-induced failures, components shall be operated below their maximum absolute ratings as defined in Table 4-1.

**Table 4-1: Component Derating Criteria**

| Component Type | Parameter | Max Rating | Derating Limit | Applied Constraint |
|---|---|---|---|---|
| **Resistors** | Power | 0.25W | 50% | Max dissipation limited to 0.125W |
| **Capacitors** | Voltage | 50V | 60% | Applied voltage ≤ 30V (for 12V rail) |
| **LNA/VGA/Mixer** | P1dB (Input) | +19 dBm | 10 dB | Input power ≤ +9 dBm (RF input) |
| **DC-DC Converter** | Output Current | 2A | 80% | Max load ≤ 1.6A |
| **Voltage Regulators** | Junction Temp | 150°C | 40% | Max Tj ≤ 110°C (worst case) |
| **Connectors** | Current/Contact | 3A | 66% | Max current 2A per pin |

### 4.2.4 Specific Component Application Constraints
*   **HMC6180LP4E (LNA):** Requires a controlled impedance of 50Ω at both RF ports. The bias tee circuitry must be placed within 0.050 inches (1.27mm) of the supply pin to prevent instability.
*   **AD9208 (ADC):** The sample clock input jitter must be ≤ 100 fs RMS to maintain SNR performance. The clock source shall be a low-noise fanout buffer capable of driving 50Ω.
*   **FPGA:** Must support JESD204B IP core with lane rates ≥ 6.6 Gbps. The device must be industrial temperature grade (-40°C to +85°C) or military grade (-55°C to +125°C).

---

## 4.3 Manufacturing Constraints

This section defines the physical limitations and assembly processes required to produce the rx module. These constraints ensure the design is manufacturable using standard industry equipment while meeting the high-frequency performance requirements.

### 4.3.1 PCB Fabrication Constraints
*   **Material Selection:** The PCB laminate shall be Rogers RO4350B or equivalent (ceramic-filled PTFE) to minimize dielectric loss (Df ≈ 0.0037) at 18 GHz. FR-4 is strictly prohibited for RF layers.
*   **Layer Stackup:** The board shall consist of a minimum of 8 layers.
    *   *Layers 1-2:* Top RF Microstrip, Ground Plane (critical for 5-18GHz).
    *   *Layers 3-4:* Signal/Power Split.
    *   *Layers 5-6:* Power Planes (12V, 3.3V, 1.8V).
    *   *Layers 7-8:* Bottom Signals, Ground Plane.
*   **Minimum Trace/Space:**
    *   *RF Signals:* Determined by 50Ω impedance calculation (calculated approx 15 mil width on Rogers 4350B, 6.6 mil thickness).
    *   *Digital Signals:* 5 mil / 5 mil (standard).
*   **Plating:** Electroless Nickel Immersion Gold (ENIG) is prohibited for RF signal pads due to nickel skin effect losses at 18 GHz. Electrolytic Hard Gold over Nickel or Immersion Silver is required for all RF contact pads.

### 4.3.2 Assembly and Soldering Constraints
*   **Solder Paste:** Type 4 solder paste (particle size 20-38 µm) shall be used to accommodate fine-pitch components (0.5mm pitch FPGA/BGA).
*   **Via Filling:** All vias located in RF transmission lines or under BGA packages must be filled and planarized (capped) to prevent solder wicking and signal loss.
*   **Stencil Thickness:** A laser-cut stainless steel stencil with a thickness of 0.004 inches (4 mil) shall be used to ensure proper solder paste deposition for fine-pitch components.

### 4.3.3 Mechanical and Enclosure Constraints
*   **Enclosure Material:** The module housing shall be machined Aluminum 6061-T6 with conductive chromate conversion coating (Alodine) or nickel plating to ensure grounding and corrosion resistance.
*   **RF Connector Interface:** The SMA connectors (Edge launch) shall be mounted to the PCB with a minimum of 2 mounting nuts to prevent torque loosening during vibration.
*   **Conformal Coating:** The assembled board (excluding RF connectors and mating edges) shall be coated with acrylic or urethane conformal coating (IPC-CC-830) to protect against moisture and contaminants.
*   **Fastener Hardware:** All threaded fasteners shall utilize self-locking mechanisms (Nyloc nuts or thread-locking adhesive) to prevent loosening under vibration (MIL-STD-810).

### 4.3.4 Test and Inspection Constraints
*   **X-Ray Inspection:** Due to the high density of the FPGA and ADC BGAs, 100% X-Ray inspection (AXI) is required to verify BGA voiding < 15% per IPC-7095.
*   **Flying Probe vs Bed-of-Nails:** Due to the high density and lack of test points on RF lines, electrical test shall be performed via Flying Probe or Boundary Scan (JTAG) rather than traditional ICT (In-Circuit Test) fixtures.

---

# 5. Verification Requirements

This section defines the methods and criteria for verifying that the **rx module** hardware meets all specified requirements. It utilizes a combination of Test, Analysis, and Inspection methods.

## 5.1 Test Requirements

This subsection details the specific test procedures necessary to validate the functional and performance requirements of the rx module. These tests require a calibrated laboratory environment including Vector Network Analyzers (VNA), Spectrum Analyzers (SA), Signal Generators, Oscilloscopes, and Power Meters.

### 5.1.1 RF Performance Verification (REQ-HW-001, REQ-HW-002, REQ-HW-003, REQ-HW-004, REQ-HW-009)

**Test Setup:** VNA (e.g., Keysight N5242A) calibrated to the SMA connector interface. Power Supply set to 12.0V DC.

**Test Case 1: Frequency Response & Bandwidth**
*   **Requirement IDs:** REQ-HW-001, REQ-HW-002
*   **Test Method:** S21 Measurement.
*   **Procedure:**
    1.  Configure VNA for S21 measurement (Transmission).
    2.  Sweep frequency from 4 GHz to 19 GHz.
    3.  Set Manual Gain Control (MGC) voltage to mid-range (e.g., 1.5V assuming 0-3V scale) or set digital gain to code 32 (mid-scale).
    4.  Measure Gain (Magnitude S21) in dB.
*   **Pass Criteria:**
    *   Gain > 0 dB (system active) from 5.0 GHz to 18.0 GHz.
    *   -3 dB bandwidth points must encompass the 5-18 GHz range.
    *   No dropouts (>10 dB deviation) within the band.

**Test Case 2: Input VSWR**
*   **Requirement IDs:** REQ-HW-003
*   **Test Method:** S11 Measurement.
*   **Procedure:**
    1.  Configure VNA for S11 measurement.
    2.  Sweep 5 GHz to 18 GHz.
    3.  Measure VSWR derived from Reflection Coefficient ($\Gamma$).
*   **Pass Criteria:** VSWR $\le$ 2.0:1 (Return Loss $\ge$ 9.54 dB) across 100% of the band.

**Test Case 3: Gain Flatness**
*   **Requirement IDs:** REQ-HW-004
*   **Test Method:** S21 Measurement (derived from Test Case 1 data).
*   **Procedure:**
    1.  Extract S21 data points across 5-18 GHz.
    2.  Determine Peak gain ($G_{max}$) and Minimum gain ($G_{min}$).
    3.  Calculate Flatness = $(G_{max} - G_{min}) / 2$.
*   **Pass Criteria:** Flatness variation $\le$ $\pm$ 2.0 dB relative to the nominal gain curve.

**Test Case 4: Noise Figure (NF)**
*   **Requirement IDs:** REQ-HW-009
*   **Test Method:** Noise Figure Analyzer (e.g., Keysight N8975A) using Y-Factor method or Cold Source method.
*   **Procedure:**
    1.  Connect Noise Source (e.g., 34 dB ENR) to RF Input.
    2.  Measure Noise Figure at spot frequencies: 5 GHz, 11.5 GHz (Center), 18 GHz.
    3.  Ensure Gain is high enough to mask analyzer noise floor.
*   **Pass Criteria:** Noise Figure $\le$ 5.0 dB (Target) at all spot frequencies.

### 5.1.2 Gain Control Verification (REQ-HW-005)

**Test Setup:** RF Signal Generator at 10 GHz. Power Meter or Spectrum Analyzer at LVDS output logic analyzer (monitoring ADC codes).

**Test Case 5: Gain Control Range & Linearity**
*   **Requirement IDs:** REQ-HW-005
*   **Test Method:** Functional Sweep.
*   **Procedure:**
    1.  Set RF Input to -40 dBm.
    2.  Sweep MGC voltage/control word from Minimum to Maximum.
    3.  Record output power (RF or Digital codes) at each step.
*   **Pass Criteria:**
    *   Total gain range $\ge$ 30 dB (Assumed based on VGA HMC698LP4 capability of 50dB minus system constraints).
    *   Monotonic increase in output power with increasing gain command.
    *   No oscillation or instability at any gain setting.

### 5.1.3 Digital Interface Verification (REQ-HW-006)

**Test Setup:** High-Speed Differential Oscilloscope (e.g., Teledyne LeCroy WaveMaster) with LVDS probing. FPGA configured to output a repetitive data pattern (e.g., K28.5 commas).

**Test Case 6: LVDS Electrical Compliance**
*   **Requirement IDs:** REQ-HW-006
*   **Test Method:** Eye Diagram Analysis.
*   **Procedure:**
    1.  Trigger oscilloscope on LVDS clock.
    2.  Accumulate eye diagram for Data I and Data Q lines.
    3.  Measure Differential Voltage ($V_{od}$), Common Mode Voltage ($V_{cm}$), and Jitter.
*   **Pass Criteria:**
    *   $V_{od}$: 250 mV to 450 mV (Per TIA/EIA-644).
    *   $V_{cm}$: 1.125V to 1.375V.
    *   Eye opening > 70% of unit interval at target clock rate (e.g., 1 Gbps).

### 5.1.4 Power & Environmental Stress (REQ-HW-007, REQ-HW-008)

**Test Setup:** DC Power Supply with current measurement capability. Thermal Chamber for environmental testing.

**Test Case 7: Power Consumption & Voltage Regulation**
*   **Requirement IDs:** REQ-HW-007
*   **Test Method:** Electrical Measurement.
*   **Procedure:**
    1.  Apply 12.0 V DC.
    2.  Measure Current ($I_{total}$) at Nominal, Low (10.8V), and High (13.2V) input voltages.
*   **Pass Criteria:**
    *   Operation stable at all input voltages ($\pm$10%).
    *   Total Power $P_{total} = V \times I \le$ Calculated Budget (approx 8W).

**Test Case 8: MIL-STD-810 Vibration (Functional)**
*   **Requirement IDs:** REQ-HW-008
*   **Test Method:** Operational Vibration Test.
*   **Procedure:**
    1.  Mount unit on vibration shaker.
    2.  Apply vibration profile per MIL-STD-810G, Method 514.6 (Category 14/21, Generic Helicopter/Transport).
    3.  Inject RF Tone and monitor output for dropouts during vibration.
*   **Pass Criteria:**
    *   No mechanical failure.
    *   RF signal remains uninterrupted (Gain variation < 1 dB) during test.

**Test Case 9: Temperature Extremes**
*   **Requirement IDs:** REQ-HW-008
*   **Test Method:** Thermal Soak.
*   **Procedure:**
    1.  Place unit in chamber at -40°C.
    2.  Soak for 2 hours. Power on and verify functionality.
    3.  Raise chamber to +71°C.
    4.  Soak for 2 hours. Verify functionality.
*   **Pass Criteria:** Unit meets VSWR, Gain, and Phase Noise specs at both temperature extremes.

### 5.1.5 Signal Chain Integrity (REQ-HW-011)

**Test Case 10: Input Impedance**
*   **Requirement IDs:** REQ-HW-011
*   **Test Method:** VNA Smith Chart Measurement.
*   **Procedure:**
    1.  Measure S11 at SMA port.
    2.  Transform to Impedance ($Z_{in}$).
*   **Pass Criteria:** $Z_{in} = 50 \pm 10 \Omega$ (Resistive component dominates across band).

---

## 5.2 Analysis Requirements

This subsection covers requirements that are verified through engineering calculations, simulations, or design reviews rather than physical measurement on the unit under test. This includes thermal, mechanical, and interference analysis.

### 5.2.1 Thermal Analysis (Requirement: MIL-STD-810 / High Temp Operation)

**Objective:** Verify junction temperatures ($T_j$) of critical components (LNA HMC6180LP4E, Mixer HMC556LC3B, FPGA) remain within datasheet limits at maximum ambient temperature ($+71^\circ$C).

**Method:** Computational Fluid Dynamics (CFD) or Excel-based thermal resistance calculation.
*   **Input Data:** Power Dissipation ($P_d$) from Section 6 (BOM) calculations.
*   **Assumption:** Module is enclosed in a sealed CONDUIT housing or similar chassis. $\theta_{JA}$ (Junction-to-Ambient) estimated based on PCB copper weight (2 oz copper) and potential heat sinking.

**Calculation Example:**
*   **Component:** HMC6180LP4E (LNA)
*   $P_d = 3.3V \times 0.09A = 0.297W$
*   $\theta_{JA}$ (QFN, 4-layer board, no heatsink) $\approx 60^\circ C/W$ (Assumed conservative value).
*   Max Ambient $T_A = 71^\circ C$.
*   $T_j = T_A + (P_d \times \theta_{JA}) = 71 + (0.297 \times 60) = 71 + 17.8 = 88.8^\circ C$.

**Verification Criteria:**
*   Calculated $T_j$ must be $< T_{j(max)}$ (Usually 125°C or 150°C for GaAs/SiGe).
*   **Result:** PASS (88.8°C < 125°C).

### 5.2.2 Power Integrity (PI) Analysis

**Objective:** Verify DC-DC converter stability and voltage ripple are within tolerances for the FPGA and ADC.

**Method:** LTSpice Simulation of the Power Distribution Network (PDN).
*   **Simulate:** Load transient response (FPGA switching from Idle to Max Toggle).
*   **Check:** Ringing and overshoot on the 3.3V, 1.8V, and 1.0V rails.

**Verification Criteria:**
*   Ripple $< 50 mV_{pp}$ on analog rails (3.3V).
*   Ripple $< 100 mV_{pp}$ on digital rails.
*   *Derivation:* Based on AD9208 ADC datasheet requirement for analog supply noise rejection.

### 5.2.3 Signal Integrity / Eye Diagram Analysis (Simulated)

**Objective:** Verify the trace lengths from FPGA to LVDS connector do not introduce inter-symbol interference (ISI).

**Method:** HyperLynx or Keysight ADS simulation.
*   **Model:** Microstrip traces on Rogers RO4350B material ($\epsilon_r = 3.48$).
*   **Target:** Single-ended impedance 50$\Omega$, Differential 100$\Omega$.

**Verification Criteria:**
*   Insertion Loss < 3 dB at Nyquist frequency ($\approx 1.5 \times F_{clock}$).
*   No impedance discontinuities > 10%.

### 5.2.4 EMI / EMC Analysis (Requirement: MIL-STD-810 / EMI Control)

**Objective:** Predict radiated emissions from the 13 GHz RF chain and LVDS clocks.

**Method:** Review of shielding effectiveness design.
*   **Analysis:** Conductive gasketing and seam calculations.
*   **Equation:** $SE = A + R + B$ (Absorption + Reflection + Correction).
*   **Assumption:** Aluminum wall thickness > 0.060".

**Verification Criteria:**
*   Calculated shielding effectiveness $> 80 dB$ at 10 GHz (Standard for machined aluminum enclosures).
*   Ensures leakage from LO does not violate MIL-STD-461 (if applicable).

---

## 5.3 Inspection Requirements

This subsection covers requirements verified by visual examination, dimensional measurement, or reviewing manufacturing records (AVL/AVB).

### 5.3.1 Physical Interface Inspection (REQ-HW-010)

**Requirement ID:** REQ-HW-010 (RF Input Connector)

**Method:** Visual and Mechanical Inspection.
*   **Tools:** Calipers, SMA Gauge (e.g., Kingsmith Gauge), Borescope.

**Procedure:**
1.  Verify connector type is SMA (Female/Jack typically).
2.  Verify mounting (threaded or press-fit) is secure.
3.  Verify dielectric is not recessed (Check for "air gap").
4.  Verify proper torqueing of flange nuts (if applicable).

**Pass Criteria:**
*   Connector part number matches AVL (e.g., TE Connectivity 1-2273144-1 or equivalent).
*   No visible damage to center pin.
*   Check with Go/No-Go gauge passes.

### 5.3.2 Workmanship & PCB Inspection (Req: Design Constraints)

**Objective:** Ensure PCB fabrication and assembly meet Class 3/IPC-A-610G standards for Military hardware.

**Method:** Microscopic Inspection (5x - 30x magnification).

**Checklist:**
*   **Solder Joints:** Fillets must be concave, wetting to both pad and lead. No dewetting.
*   **Component Orientation:** Polarity markings on electrolytic capacitors and diodes must align with silkscreen.
*   **Cleaning:** No flux residue visible under UV light on RF paths (Flux can cause impedance changes/leakage at 18 GHz).
*   **Conformal Coating:** Uniform coverage, no bridging on fine-pitch FPGA BGAs.

### 5.3.3 Bill of Materials (BOM) Verification

**Objective:** Ensure components used match the approved AVL (Approved Vendor List).

**Method:** Cross-reference part markings on physical components with BOM.

**Procedure:**
1.  Inspect critical RF ICs (HMC6180, HMC698, HMC556).
2.  Verify date codes are within shelf-life limits (if moisture sensitive).
3.  Verify passive component values (S resistor/cap networks) match schematic.

---

## 5.4 Verification Cross-Reference Matrix

The following table maps each requirement to its primary verification method and success criteria.

| REQ ID | Requirement Title | Verification Method | Key Pass Criteria | Responsibility (Role) |
| :--- | :--- | :--- | :--- | :--- |
| **REQ-HW-001** | RF Input Frequency Range | **Test** (VNA Sweep) | Gain > 0 dB from 5.0 - 18.0 GHz | RF Engineer |
| **REQ-HW-002** | Instantaneous Bandwidth | **Test** (Modulation / Pulse) | Passband -3dB points cover 6.5 GHz span | RF Engineer |
| **REQ-HW-003** | Input VSWR | **Test** (VNA S11) | VSWR $\le$ 2.0:1 (Return Loss $\ge$ 9.5 dB) | RF Engineer |
| **REQ-HW-004** | Gain Flatness | **Test** (VNA S21) | Gain variation $\le$ $\pm$ 2.0 dB | RF Engineer |
| **REQ-HW-005** | Manual Gain Control | **Test** (Signal Gen + Scope) | Gain range > 30 dB; Monotonic response | Systems Engineer |
| **REQ-HW-006** | LVDS Digital Output | **Test** (High-Speed Scope Eye) | Eye compliant with TIA/EIA-644; Vod > 250mV | FPGA Engineer |
| **REQ-HW-007** | Supply Voltage | **Test** (DC Source/Load) | Stable operation 10.8V - 13.2V | Power Engineer |
| **REQ-HW-008** | MIL-STD-810 Compliance | **Test** (Env. Chamber + Vib.) | No failure during vibe; Functional at -40C/+71C | Mechanical/QA |
| **REQ-HW-009** | Noise Figure | **Test** (NFA Meter) | NF $\le$ 5.0 dB (Target) | RF Engineer |
| **REQ-HW-010** | RF Input Connector | **Inspection** | Correct P/N, torque, no damage; Go/No-Go gauge pass | Quality Inspector |
| **REQ-HW-011** | Input Impedance | **Test** (VNA Smith Chart) | Zin = 50 $\Omega$ (within tolerance) | RF Engineer |
| **DES-001** | Thermal Performance | **Analysis** (Simulation) | Junction Temps < 125°C at Max Ambient | Mechanical Engineer |
| **DES-002** | Power Consumption | **Analysis** (Calculation) | Total Power < Estimated Budget (e.g., < 10W) | Power Engineer |
| **DES-003** | PCB Impedance Control | **Inspection** (TDR Test) | Trace Impedance = 50 $\Omega$ $\pm$ 10% | PCB Vendor / QA |

### 5.4.1 Requirement Traceability Summary

*   **Test:** 9 Requirements (Functional & Performance)
*   **Analysis:** 2 Requirements (Thermal, Power)
*   **Inspection:** 2 Requirements (Mechanical/Interface)

**Verification Status:**
*   The proposed test plan covers 100% of the "Must Have" requirements.
*   "Should Have" requirements (like Noise Figure optimization) are included in the characterization plan.
*   Analysis is used to pre-verify reliability before hardware is built (e.g., thermal simulation of the LNA).

---

The following section is extracted from the complete Hardware Requirements Specification (HRS) for the **rx module**.

***

# 6. Bill of Materials (Preliminary)

**Document Status: AI-GENERATED**

## 6.1 Introduction
This section lists the preliminary Bill of Materials (BOM) for the Wideband RF Receiver Module. Costs are estimated based on unit pricing for medium-volume production (1k units) from major distributors (DigiKey, Mouser) or direct manufacturer pricing where applicable. Quantities reflect a single receiver module assembly.

### 6.1.1 Cost Summary
| Category | Estimated Cost (USD) |
| :--- | :--- |
| RF Front End Components | $460.00 |
| IF & Baseband Components | $310.00 |
| Digital Processing (FPGA) | $650.00 |
| Power Management | $85.00 |
| Interconnect & Mechanical | $150.00 |
| Passives & Misc. | $75.00 |
| **TOTAL ESTIMATED COST** | **$1,730.00** |

---

## 6.2 Detailed BOM

### 6.2.1 RF Front End

| Item No | Ref Des | Part Number | Description | Manufacturer | Qty | Unit Cost | Total Cost | Notes |
|:---|:---|:---|:---|:---|---|---|---|---|
| 1 | U1 | HMC6180LP4E | Wideband LNA, 6-20 GHz, 21 dB Gain | Analog Devices | 1 | $95.00 | $95.00 | Gain Block 1 |
| 2 | U2 | HMC6180LP4E | Wideband LNA, 6-20 GHz, 21 dB Gain | Analog Devices | 1 | $95.00 | $95.00 | Gain Block 2 (Driver) |
| 3 | U3 | HMC698LP4 | VGA, DC-14 GHz, 50 dB Range | Analog Devices | 1 | $110.00 | $110.00 | Digital/Analog Control |
| 4 | U4 | HMC556LC3B | Mixer, 6-20 GHz, Double Balanced | Analog Devices | 1 | $45.00 | $45.00 | Downconverter |
| 5 | FL1 | BP0618-S3 | Bandpass Filter, 5-18 GHz | KR Electronics | 1 | $110.00 | $110.00 | Input Pre-selector |
| 6 | J1 | 142-0701-851 | SMA Jack, 50 Ohm, PCB Edge Launch | Rosenberger | 1 | $8.50 | $8.50 | RF Input |

---

### 6.2.2 IF and Baseband Chain

| Item No | Ref Des | Part Number | Description | Manufacturer | Qty | Unit Cost | Total Cost | Notes |
|:---|:---|:---|:---|:---|---|---|---|---|
| 7 | U5 | ADL5380ACPZ | IQ Demodulator, 400 MHz - 6 GHz | Analog Devices | 1 | $65.00 | $65.00 | Direct Conversion/Zero IF |
| 8 | U6 | ADL5240 | IF VGA, Programmable, 0.5 - 6 GHz | Analog Devices | 1 | $45.00 | $45.00 | Baseband Gain Adjustment |
| 9 | U7 | ADL5330 | Variable Gain Amplifier | Analog Devices | 1 | $35.00 | $35.00 | Fine Gain Control |
| 10 | U8 | AD8129 | Triple 700 MHz Differential Driver | Analog Devices | 2 | $12.00 | $24.00 | ADC Interface Drivers |
| 11 | T1 | ADT1-1WT | 1:1 Transformer Balun, 10 Hz - 1 GHz | Mini-Circuits | 4 | $5.50 | $22.00 | AC Coupling / Single-Ended to Diff |

---

### 6.2.3 Digital Section & Data Conversion

| Item No | Ref Des | Part Number | Description | Manufacturer | Qty | Unit Cost | Total Cost | Notes |
|:---|:---|:---|:---|:---|---|---|---|---|
| 12 | U9 | AD9208-3000EBZ | Dual 14-bit, 3 GSPS ADC, JESD204B | Analog Devices | 1 | $450.00 | $450.00 | Core Digitizer |
| 13 | U10 | XCVU9P-FLGB2104 | Kintex UltraScale+ FPGA | Xilinx/AMD | 1 | $550.00 | $550.00 | Signal Processing & Data Pack |
| 14 | U11 | MKR-0430-08S-102 | 43.0625 MHz LVDS Oscillator | Crystek | 1 | $35.00 | $35.00 | FPGA SysClk (Ref) |
| 15 | R1 | 49.9 Ohm | Thin Film Resistor, 0402, 1% | Vishay | 20 | $0.10 | $2.00 | Input Term |
| 16 | U12 | DS90LV047A | Quad LVDS Driver 3.3V | Texas Instruments | 4 | $4.50 | $18.00 | Output Interface Buffers |

---

### 6.2.4 Power Distribution

| Item No | Ref Des | Part Number | Description | Manufacturer | Qty | Unit Cost | Total Cost | Notes |
|:---|:---|:---|:---|:---|---|---|---|---|
| 17 | U13 | LTM4644IY | Quad 4A DC-DC Buck Regulator | Analog Devices | 2 | $35.00 | $70.00 | Generates 1.0V, 1.8V, 3.3V, 5V |
| 18 | J2 | 691622310002 | Phoenix Connector, 2-pos, Pluggable | Phoenix Contact | 1 | $3.50 | $3.50 | 12V DC Input |
| 19 | D1 | SMBJ33CA | TVS Diode, 33V, Bidirectional | Littelfuse | 1 | $0.80 | $0.80 | Input Protection |
| 20 | L1 | 7443631000 | Power Inductor, 10 µH | Würth | 4 | $1.20 | $4.80 | Buck Output Filter |
| 21 | C20 | 470 µF | Tantalum Capacitor, 16V | AVX | 6 | $2.50 | $15.00 | Bulk Capacitance |

---

### 6.2.5 Mechanical & Hardware

| Item No | Ref Des | Part Number | Description | Manufacturer | Qty | Unit Cost | Total Cost | Notes |
|:---|:---|:---|:---|---|---|---|---|---|
| 22 | A1 | 5013-01-105 | Blank PCB, Rogers RO4350B, 10 mil | Custom Fab | 1 | $85.00 | $85.00 | RF Laminate |
| 23 | A2 | 5501-16-0200 | Machined Aluminum Enclosure | Custom Machined | 1 | $60.00 | $60.00 | EMI Shield / Heat Sink |
| 24 | H1 | 90116-1002 | Board standoff, 4-40 thread, Hex | Keystone | 4 | $0.50 | $2.00 | PCB Mounting |

---

## 6.3 Mechanical BOM Summary

### 6.3.1 Board Stack-up
*   **Layer 1 (Top):** RF Components (Ground accessible via vias)
*   **Layer 2:** GND Plane (Solid)
*   **Layer 3:** Power Rails (3.3V, 5V, 1.8V)
*   **Layer 4 (Bottom):** Digital Routing, LVDS Signals, Control Lines
*   **Material:** Rogers RO4350B (Er = 3.48) for critical RF sections, hybrid with FR4 for digital sections if cost constraints dictate (Assuming full RO4350B for performance).
*   **Finish:** ENIG (Electroless Nickel Immersion Gold)

### 6.3.2 Connector Pinout Definition
| Pin # | Signal Name | Type | Description |
|:---|:---|:---|---|
| 1 | +12V_IN | Power | Main Supply Input |
| 2 | GND | Power | Return Path |
| 3 | GND | Power | Return Path |
| 4 | MGC_VSET | Analog | Manual Gain Control Voltage Input (0-5V) |

*(Note: All other interfaces are via edge-launch RF or board-to-board headers)*

---

# 7. Traceability Matrix

**Document Status: AI-GENERATED**

## 7.1 General
This section provides the comprehensive traceability matrix for the rx module Wideband RF Receiver. This matrix maps the system-level requirements derived from the project requirements, component specifications, and design parameters to their verification methods. It ensures that every functional, performance, and interface requirement is validated through test, analysis, inspection, or demonstration.

## 7.2 Traceability Matrix Table

| REQ-ID | Requirement Summary | Source | Verification Method | Phase | Status |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **REQ-HW-001** | RF Input Frequency Range (5.0-18.0 GHz) | Project Requirement | Test | Prototype | Active |
| **REQ-HW-002** | Instantaneous Bandwidth (≥ 6.5 GHz) | Project Requirement | Test | Prototype | Active |
| **REQ-HW-003** | Input VSWR (≤ 2:1) | Project Requirement | Test | Production | Active |
| **REQ-HW-004** | Gain Flatness (±2 dB) | Project Requirement | Test | Production | Active |
| **REQ-HW-005** | Manual Gain Control (Analog/Digital) | Project Requirement | Test | Prototype | Active |
| **REQ-HW-006** | LVDS Digital Output (I/Q Data) | Project Requirement | Test | Prototype | Active |
| **REQ-HW-007** | Supply Voltage (12V DC ±10%) | Project Requirement | Test | Unit Integration | Active |
| **REQ-HW-008** | MIL-STD-810 Environmental Compliance | Project Requirement | Test | Qualification | Active |
| **REQ-HW-009** | System Noise Figure (≤ 5.0 dB) | Project Requirement | Test | Prototype | Active |
| **REQ-HW-010** | RF Input Connector (SMA 50Ω) | Project Requirement | Inspection | Production | Active |
| **REQ-HW-011** | Input Impedance (50 Ω) | Project Requirement | Test | Production | Active |
| **REQ-HW-012** | LNA Frequency Coverage (6-20 GHz) | Component: HMC6180LP4E | Analysis | Design | Active |
| **REQ-HW-013** | LNA Gain (21 dB nominal) | Component: HMC6180LP4E | Test | Production | Active |
| **REQ-HW-014** | LNA Noise Figure (2.5 dB) | Component: HMC6180LP4E | Analysis | Design | Active |
| **REQ-HW-015** | VGA Gain Range (0-50 dB) | Component: HMC698LP4 | Test | Prototype | Active |
| **REQ-HW-016** | VGA Frequency Range (DC-14 GHz) | Component: HMC698LP4 | Analysis | Design | Active |
| **REQ-HW-017** | Mixer Conversion Loss (≤ 10 dB) | Component: HMC556LC3B | Test | Prototype | Active |
| **REQ-HW-018** | Mixer RF/LO Range (6-20 GHz) | Component: HMC556LC3B | Analysis | Design | Active |
| **REQ-HW-019** | Mixer LO Drive Level (+13 dBm) | Component: HMC556LC3B | Test | Prototype | Active |
| **REQ-HW-020** | IQ Demodulator Baseband BW (1.7 GHz) | Component: ADL5380 | Test | Prototype | Active |
| **REQ-HW-021** | IQ Demodulator Conversion Gain (6 dB) | Component: ADL5380 | Test | Prototype | Active |
| **REQ-HW-022** | ADC Resolution (14-bit) | Component: AD9208 | Test | Prototype | Active |
| **REQ-HW-023** | ADC Sample Rate (3 GSPS) | Component: AD9208 | Test | Prototype | Active |
| **REQ-HW-024** | ADC Input Bandwidth (9 GHz) | Component: AD9208 | Analysis | Design | Active |
| **REQ-HW-025** | ADC Interface (JESD204B) | Component: AD9208 | Test | Prototype | Active |
| **REQ-HW-026** | FPGA LVDS Output Compliance (TIA/EIA-644) | Interface Requirement | Test | Prototype | Active |
| **REQ-HW-027** | Total Power Dissipation (≤ 25 Watts) | Design Calculation | Analysis | Design | Active |
| **REQ-HW-028** | LNA Power Supply (3.3V @ 90 mA) | Component: HMC6180LP4E | Test | Production | Active |
| **REQ-HW-029** | VGA Power Supply (Assumed 5V) | Component: HMC698LP4 | Test | Production | Active |
| **REQ-HW-030** | Mixer Power Supply (Assumed 5V) | Component: HMC556LC3B | Test | Production | Active |
| **REQ-HW-031** | IQ Demodulator Supply (5V) | Component: ADL5380 | Test | Production | Active |
| **REQ-HW-032** | Power Supply Rejection Ratio (PSRR) | Design Constraint | Analysis | Design | Active |
| **REQ-HW-033** | Operating Temperature Range (-40°C to +85°C) | MIL-STD-810 | Test | Qualification | Active |
| **REQ-HW-034** | PCB Material (Rogers RO4350B) | Design Constraint | Inspection | Production | Active |
| **REQ-HW-035** | Connector Mounting Torque | Mechanical | Inspection | Production | Active |
| **REQ-HW-036** | Board Conformal Coating | Environmental | Inspection | Production | Active |
| **REQ-HW-037** | RF Trace Impedance Tolerance (±5%) | Design Constraint | Inspection | Production | Active |

## 7.3 Verification Summary

The following table summarizes the distribution of verification methods across all identified hardware requirements.

| Verification Method | Count | Percentage |
| :--- | :--- | :--- |
| **Test** | 22 | 59.5% |
| **Analysis** | 8 | 21.6% |
| **Inspection** | 6 | 16.2% |
| **Demonstration** | 1 | 2.7% |
| **Total** | **37** | **100%** |

### 7.3.1 Verification Method Definitions
*   **Test**: Operation of the hardware item under specific conditions (stimulus) to observe correct behavior (e.g., Gain, VSWR, Frequency Response). Used for the majority of RF performance parameters.
*   **Analysis**: Mathematical or simulation-based verification (e.g., Power Budget, Thermal Analysis, S-parameter simulations) where physical measurement is impractical during early design or derived from component datasheets.
*   **Inspection**: Visual examination or simple verification of physical attributes (e.g., Connector type, PCB material, Torque settings).
*   **Demonstration**: Operational evaluation without precise instrumentation (e.g., basic functionality of Manual Gain Control interface).

---
*End of Section 7*