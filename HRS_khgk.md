**Document Status: AI-GENERATED**

# 1. Introduction

## 1.1 Purpose
This Hardware Requirements Specification (HRS) defines the comprehensive hardware design, performance, and environmental requirements for the **khgk Wideband RF Receiver Module**.

The purpose of this document is to:
1.  Establish a baseline for the detailed hardware design of the receiver module, ensuring compliance with military standards for radar and electronic warfare (EW) applications.
2.  Define the functional allocation, electrical interfaces, and mechanical constraints necessary to achieve the target specifications of 5-18 GHz frequency coverage and 13 GHz instantaneous bandwidth.
3.  Serve as the primary technical reference for hardware engineering, PCB layout, component selection, and verification testing (IV&V).
4.  Ensure traceability between high-level system requirements and low-level hardware implementation constraints.

This specification addresses the "Phase 1 Requirements" for the khgk project, covering the Radio Frequency (RF) front-end, Intermediate Frequency (IF) processing, high-speed digitization (JESD204B/C), and power management subsystems.

## 1.2 Scope
The khgk hardware system comprises a self-contained receiver module designed for integration into larger tactical radar or EW platforms.

**In-Scope Elements:**
*   **RF Front End:** Wideband Low Noise Amplifier (LNA) and Digital Variable Gain Amplifier (DVGA) covering 5.0 GHz to 18.0 GHz.
*   **Frequency Conversion:** Wideband I/Q Mixer and Local Oscillator (LO) synthesis chain for downconversion.
*   **Digitization:** High-speed Analog-to-Digital Converter (ADC) supporting JESD204B/C output protocols.
*   **Power Management:** Multi-rail power supply design accepting 12V or 15V DC nominal input.
*   **Control Interface:** SPI/I2C digital control for gain, frequency tuning, and housekeeping telemetry.
*   **Mechanical Design:** Constrained to a 120mm x 80mm x 15mm form factor with MIL-STD-810G environmental hardening.

**Out-of-Scope Elements:**
*   Signal processing algorithms (Firmware/FPGA logic) implemented on the host processor or FPGA, other than the configuration of the ADC and JESD204 interface layer.
*   Antenna elements or waveguide interfaces external to the module connector.
*   Mechanical chassis or enclosure beyond the module's boundaries.
*   System-level integration testing with the host platform (software/application layer).

## 1.3 Definitions, Acronyms, and Abbreviations

| Term | Definition |
| :--- | :--- |
| **ADC** | Analog-to-Digital Converter. Converts analog IF signals to digital data streams. |
| **BOM** | Bill of Materials. List of raw materials, sub-assemblies, and intermediate assemblies required to manufacture the end product. |
| **CE102** | Conducted Emissions, Power Leads, 10 kHz – 10 MHz (MIL-STD-461G). |
| **CW** | Continuous Wave. An unmodulated sinusoidal signal. |
| **DAC** | Digital-to-Analog Converter (used herein for control voltages if applicable, though primary design is digital control). |
| **DC** | Direct Current. |
| **DVGA** | Digital Variable Gain Amplifier. A variable gain amplifier controlled via a digital serial interface (e.g., SPI). |
| **EMI** | Electromagnetic Interference. |
| **EMC** | Electromagnetic Compatibility. |
| **ENOB** | Effective Number of Bits. A measure of the actual resolution of an ADC considering noise and distortion. |
| **EW** | Electronic Warfare. |
| **FIFO** | First-In, First-Out. A buffering method used in data streaming. |
| **FOM** | Figure of Merit. A metric used to characterize the performance of a component (e.g., Phase Noise FOM). |
| **FPGA** | Field-Programmable Gate Array. |
| **GaN** | Gallium Nitride. A semiconductor material used for high-power/high-frequency RF components. |
| **GHz** | Gigahertz ($10^9$ Hz). |
| **GSPS** | Giga-Samples Per Second. |
| **HRS** | Hardware Requirements Specification. |
| **IF** | Intermediate Frequency. The frequency output of the mixer stage before digitization. |
| **IIP3** | Input Third-order Intercept Point. A metric of linearity. |
| **IP3** | Third-order Intercept Point. |
| **JESD204** | A high-speed data interface standard for data converters (JEDEC Standard). |
| **LNA** | Low Noise Amplifier. The first active stage in the receiver chain. |
| **LO** | Local Oscillator. The signal source used to drive the mixer for frequency conversion. |
| **MIL-STD** | United States Defense Standard. |
| **NF** | Noise Figure. The degradation in Signal-to-Noise Ratio (SNR) caused by components in a signal path. |
| **OIP3** | Output Third-order Intercept Point. |
| **P1dB** | 1 dB Compression Point. The point where the gain drops by 1 dB from the linear gain. |
| **PCB** | Printed Circuit Board. |
| **PLL** | Phase-Locked Loop. A control system generating an output signal whose phase is related to the phase of an input reference signal. |
| **QML** | Qualified Manufacturers List. (Specifically QML-38535 for electronic components). |
| **RE102** | Radiated Emissions, 2 MHz – 18 GHz (MIL-STD-461G). |
| **RF** | Radio Frequency. |
| **SFDR** | Spurious-Free Dynamic Range. The ratio of the fundamental signal to the worst spurious signal (excluding harmonics). |
| **SiGe** | Silicon-Germanium. A semiconductor technology. |
| **SMA** | SubMiniature version A. A coaxial RF connector. |
| **SMP** | SubMiniature Push-on. A coaxial RF connector for board-to-board applications. |
| **SNR** | Signal-to-Noise Ratio. |
| **SPI** | Serial Peripheral Interface. A synchronous serial communication interface specification. |
| **S-parameter** | Scattering Parameter. Describes the electrical behavior of linear electrical networks. |
| **SYSREF** | System Reference. A signal used in JESD204B/C to align multiple devices or lanes. |
| **VCO** | Voltage-Controlled Oscillator. |
| **VSWR** | Voltage Standing Wave Ratio. |

## 1.4 References
The design of the khgk hardware shall adhere to the specifications listed in the table below. In the event of conflict between this document and the referenced standards, the stricter requirement shall generally apply unless specifically waived by the Systems Engineering authority.

| ID | Document Title | Document Number | Version/Date | Applicability |
|:---|:---|:---|:---|---|
| **R1** | Systems and Software Engineering — Life Cycle Processes — Requirements Engineering | **IEEE 29148** | 2018 | Structure of this document. |
| **R2** | Test Method Standard for Microelectronics | **MIL-STD-883** | Rev J (current) | Device testing methods. |
| **R3** | Environmental Engineering Considerations and Laboratory Tests | **MIL-STD-810G** | Current | Vibration, Shock, Temperature compliance. |
| **R4** | Requirements for the Control of Electromagnetic Interference Characteristics of Subsystems and Equipment | **MIL-STD-461G** | Current | EMI/EMC limits and testing. |
| **R5** | General Requirements for Hybrid Microcircuits | **MIL-PRF-38535** | Current | QML performance standards. |
| **R6** | Standard for JESD204 and JESD204C Interface | **JEDEC JESD204B/C** | 2018 | High-speed data link interface. |
| **R7** | ADC12DJ3200 12-Bit, 3.2-GSPS / 6.4-GSPS RF-Sampling ADC | **TI Datasheet** | SBAS904B (2020) | ADC performance and interface requirements. |
| **R8** | LMX2594 Wideband PLL with Integrated VCO | **TI Datasheet** | SNAS674D (2021) | LO Synthesizer requirements. |
| **R9** | HMC698LP4 Digital Variable Gain Amplifier | **Analog Devices** | 2017 | DVGA gain control and RF chain requirements. |
| **R10** | TGA4943-SM Ka-band GaN MMIC Amplifier | **Qorvo** | 2019 | LNA driver performance requirements. |

## 1.5 Overview
The khgk receiver is a high-performance, wideband RF-to-Digital conversion module designed to operate in harsh military environments. The architecture is designed to support an instantaneous bandwidth of 13 GHz, covering the C, X, Ku, and K bands (5–18 GHz).

**1.5.1 System Operation**
The system operates by receiving an RF signal via a front-panel SMA or SMP connector. This signal passes through a wideband Low Noise Amplifier (LNA) utilizing GaN technology (specifically the **TGA4943-SM**) to establish the system noise figure and high intercept point. A subsequent Digital Variable Gain Amplifier (**HMC698LP4**) provides automatic gain control (AGC) with 1 dB step resolution, managed via an SPI control bus.

The signal is then mixed down using a wideband I/Q Mixer (based on **HMC525LC4**) driven by a high-frequency Local Oscillator (LO) synthesized by a **LMX2594** PLL/VCO. The LO frequency is agile, allowing tuning speeds of less than 5 µs to support frequency-hopping waveforms.

**1.5.2 Digital Conversion**
The downconverted Intermediate Frequency (IF) signal is digitized by a dual-channel, 12-bit ADC (Texas Instruments **ADC12DJ3200**) capable of sampling up to 3.2 GSPS. The digital data is transmitted off-module using the JESD204B/C standard over 4 lanes at line rates up to 12.5 Gbps, ensuring high data throughput with deterministic latency.

**1.5.3 Physical and Environmental Design**
The module is mechanically constrained to a compact form factor (120mm x 80mm x 15mm) to fit into high-density chassis. It is designed to operate across the full military temperature range (-55°C to +125°C) and utilizes specialized PCB materials (e.g., Rogers RO4000 series or equivalent) to manage high-speed signal integrity and thermal dissipation up to 30W.

**1.5.4 Document Structure**
The remaining sections of this specification detail:
*   **Section 2:** Detailed block diagrams and system architecture descriptions.
*   **Section 3:** Specific requirements mapping (Functional, Performance, Interface, Environmental, Power, Physical).
*   **Section 4:** Design constraints including manufacturing and compliance standards.
*   **Section 5:** Verification methods (Test, Analysis, Inspection).
*   **Section 6:** Preliminary Bill of Materials (BOM).
*   **Section 7:** Traceability Matrix linking requirements to design elements.

---

**Document Status: AI-GENERATED**

# 2. System Overview

## 2.1 System Description

The khgk system is a high-performance, wideband Radio Frequency (RF) receiver module designed for tactical radar and electronic warfare (EW) applications. The module functions as a direct-conversion or superheterodyne receiver (depending on LO configuration), capable of accepting RF signals ranging from 5.0 GHz to 18.0 GHz. The system downconverts these signals to an Intermediate Frequency (IF) or baseband stage, digitizes them using a high-speed Analog-to-Digital Converter (ADC), and transmits the data via a JESD204B/C high-speed serial interface.

The architecture is centered around a wideband gain chain optimized for linearity and low noise figure. The RF Front End consists of a GaN-based Low Noise Amplifier (LNA) followed by a high-linearity Digital Variable Gain Amplifier (DVGA) and an I/Q Mixer. Frequency translation is managed by a wideband Phase-Locked Loop (PLL) synthesizer covering the 5–18 GHz range. The digitized output is processed by a JESD204B/C compliant ADC supporting sample rates up to 3.2 GSPS. The entire system is controlled via a Serial Peripheral Interface (SPI) by an on-board System Controller, allowing for rapid gain and frequency tuning to meet the <5 µs agility requirement.

The module is designed to operate in harsh military environments, maintaining full electrical performance across ambient temperatures ranging from -55°C to +125°C and meeting MIL-STD-810G vibration and shock specifications. Power is supplied via a single +12V to +15V DC input, which is internally regulated to provide the necessary voltage rails for RF, analog, and digital components.

## 2.2 System Block Diagram

The following diagram illustrates the signal flow and control architecture of the khgk receiver module.

```mermaid
flowchart TD
    %% Physical Interconnections and Signal Flow
    
    subgraph RF_CH ["RF Front End (5-18 GHz)"]
        direction TB
        RF_IN["RF Input\n(SMA/SMP Connector)\nFreq: 5-18 GHz"]
        LNA["Wideband LNA\n(Qorvo TGA4943-SM)\nGain: 20dB\nNF: 3.5dB"]
        VGA["Digital VGA\n(ADI HMC698LP4)\nRange: -6 to +25dB\nSPI Ctrl"]
        BPF_RF["Tracking Bandpass\nFilter"]
        MIXER["Wideband I/Q Mixer\n(ADI HMC525LC4)\nConv: 8-10dB Loss"]
        
        RF_IN --> LNA --> VGA --> BPF_RF --> MIXER
    end

    subgraph LO_PATH ["Local Oscillator Path"]
        direction TB
        SYNTH["Wideband PLL Synthesizer\n(TI LMX2594)\nRange: 10MHz - 20GHz"]
        LO_AMP["LO Driver Amp"]
        LO_FILTER["LO Low Pass\nFilter"]
        
        SYNTH --> LO_AMP --> LO_FILTER
    end

    subgraph IF_CHAIN ["IF / Baseband Chain"]
        direction TB
        IF_AMP["IF Amplifier/Driver\n(Programmable Gain)"]
        AA_FILTER["Anti-Alias Filter\n(LPF 500-800MHz BW)"]
        ADC_CIRCUIT["JESD204B/C ADC\n(TI ADC12DJ3200)\n3.2 GSPS / 12-bit"]
        
        IF_AMP --> AA_FILTER --> ADC_CIRCUIT
    end

    subgraph DIGITAL ["Digital & Control"]
        direction TB
        MCU_CTRL["System Controller\n(MCU/FPGA)\nSPI Master"]
        CLK_GEN["Clocking\n(SYSREF/Sync)"]
        
        MCU_CTRL <-> CLK_GEN
    end

    subgraph POWER ["Power System"]
        direction TB
        DC_IN["DC Input\n12-15V Nominal"]
        PMIC["Power Management\n(Buck/LDO Sequencer)"]
        
        DC_IN --> PMIC
    end

    %% Control Interfaces
    MCU_CTRL -- "SPI (Freq/Gain)" --> SYNTH
    MCU_CTRL -- "SPI (Gain)" --> VGA
    MCU_CTRL -- "SPI (Config)" --> ADC_CIRCUIT
    MCU_CTRL -- "SPI (Ctrl)" --> IF_AMP
    
    %% Power Distribution (Implicit)
    PMIC -.->| +12V / +5V / -5V | RF_CH
    PMIC -.->| +3.3V / +1.8V | LO_PATH
    PMIC -.->| +3.3V / +1.8V | IF_CHAIN
    PMIC -.->| +1.0V Core | DIGITAL
    
    %% Signal Flow
    LO_PATH -- "LO Drive (5-18GHz)" --> MIXER
    MIXER -- "IF Output (DC-2GHz)" --> IF_AMP
    
    %% Outputs
    ADC_CIRCUIT -- "JESD204B/C\n4 Lanes @ 12.5Gbps" --> SYSTEM_DATA["Digital Output\n(FPGA/Backplane)"]
```

## 2.3 System Architecture

The khgk hardware architecture is partitioned into five distinct subsystems: RF Front End, Local Oscillator (LO) Generation, IF/Analog Chain, Digital Back-End, and Power Distribution. This partitioning ensures isolation between sensitive RF inputs and noisy digital circuitry while maintaining a compact form factor.

### 2.3.1 RF Front End (RFFE)
The RFFE is responsible for conditioning the input signal with minimal degradation to Signal-to-Noise Ratio (SNR).
1.  **Input Matching**: A 50 Ohm matched input network feeds the Qorvo **TGA4943-SM** GaN LNA. This component provides high gain (approx. 20 dB) and a low Noise Figure (3.5 dB) across the entire 5-18 GHz band.
2.  **Automatic Gain Control (AGC)**: Following the LNA, the signal passes through the **HMC698LP4** Digital VGA. This device allows the system controller to adjust the gain in 1 dB steps over a 31 dB range. This is critical for maintaining the ADC input within its optimal linear range (preventing saturation from strong signals or quantization noise from weak signals).
3.  **Filtering & Mixing**: A tracking bandpass filter removes harmonics before the signal reaches the **HMC525LC4** I/Q Mixer. The mixer downconverts the RF signal to a lower Intermediate Frequency (IF) suitable for digitization, using the LO provided by the synthesizer subsystem.

### 2.3.2 Local Oscillator (LO) Subsystem
Frequency agility is a core requirement (REQ-HW-014).
1.  **Synthesizer**: The **TI LMX2594** is the heart of the LO subsystem. It generates the necessary carrier frequency from 5 GHz to 18 GHz. It features a proprietary fractional-N PLL architecture capable of achieving frequency lock times significantly faster than traditional integer-N PLLs, meeting the <5 µs tuning requirement.
2.  **Signal Conditioning**: The LMX2594 output is filtered to suppress phase noise sidebands and spurious content before being amplified to drive the LO port of the HMC525LC4 mixer.

### 2.3.3 IF and Digitization Chain
The IF chain prepares the analog signal for digital conversion.
1.  **IF Amplification**: A programmable gain amplifier (PGA) adjusts the signal level to match the full-scale input range of the ADC.
2.  **Anti-Aliasing**: A low-pass filter with a sharp roll-off restricts the bandwidth to 1.5 GHz or less, ensuring that noise and out-of-band signals do not alias into the band of interest during sampling.
3.  **Analog-to-Digital Conversion**: The **TI ADC12DJ3200** digitizes the IF signal. Configured in dual-channel mode or single-channel mode (depending on instantaneous bandwidth requirements), it provides 12-bit resolution at up to 3.2 GSPS. This high sample rate supports the 13 GHz instantaneous bandwidth requirement through advanced demultiplexing techniques or direct IF sampling.

### 2.3.4 Digital and Control Subsystem
1.  **Data Interface**: The ADC outputs data using the JESD204B/C standard. This high-speed serial interface reduces pin count compared to parallel LVDS. It supports subclass 1 for deterministic latency, which is essential for radar beamforming applications.
2.  **System Management**: A microcontroller or FPGA acts as the SPI master. It manages the startup sequence, configures the PLL frequency, sets the VGA gains, and monitors telemetry (temperature, current) via an internal I2C/SPI bus. It also generates the SYSREF signal required for the JESD204B/C synchronization.

### 2.3.5 Power Management
The power subsystem accepts a nominal +12V to +15V input.
1.  **Voltage Regulation**: A DC-DC buck converter generates intermediate voltages (e.g., +5V, +3.3V).
2.  **Low Noise Rails**: LDO regulators are used to derive low-noise rails for the analog and RF sections (specifically the synthesizer and VGA) to prevent switching noise from degrading phase noise or SNR.
3.  **Sequencing**: A power management IC ensures that rails are enabled in the correct order (e.g., bias voltage before RF) to protect the GaN and GaAs devices.

## 2.4 Operating Environment

The khgk module is designed for deployment in constrained tactical environments.

| Environmental Parameter | Specification | Justification / Notes |
| :--- | :--- | :--- |
| **Operating Temperature** | **-55°C to +125°C** | Military temperature range per **MIL-STD-810G**. Components selected (e.g., TGA4943, HMC698LP4 H-class) are explicitly rated for this range. |
| **Storage Temperature** | **-65°C to +150°C** | Ensures survival during non-operational transport and storage extremes. |
| **Humidity** | **0% to 95% RH (Non-condensing)** | Standard tactical board requirement. Conformal coating (Req HW-011) is applied to protect against moisture ingress. |
| **Vibration** | **MIL-STD-810G Method 514.6** | Designed for random vibration (5-2000 Hz, 20g peak). PCB stiffeners and potting are used to mitigate resonance. |
| **Shock** | **MIL-STD-810G Method 516.6** | 40g functional shock, 75g survival shock. Mechanical design requires robust connector mounting. |
| **Altitude** | **Sea Level to 50,000 ft** | High-altitude operation requires derating of high-voltage components and adequate cooling airflow assessment. |
| **Cooling** | **Conduction / Convection** | Baseplate operates at -55°C to +85°C. The 15-20W power dissipation requires thermal interface to a cold plate or chassis heatsink. |
| **EMC/EMI** | **MIL-STD-461G** | The system must limit radiated emissions (RE102) and withstand susceptibility (RS103). The enclosure utilizes EMI gaskets, and I/O lines are filtered. |

---

**Document Status: AI-GENERATED**

# Hardware Requirements Specification (HRS)
**Project:** khgk
**Version:** 1.0
**Date:** 2023-10-27

---

## 3. Hardware Requirements

### 3.1 Functional Requirements

This section details the functional capabilities of the Wideband RF Receiver Module (khgk). These requirements define what the system shall do in terms of signal reception, processing, control, and data output.

| ID | Title | Description | Rationale | Priority |
|---|---|---|---|---|
| **REQ-HW-001** | **RF Input Frequency Coverage** | The receiver shall accept and process RF input signals continuously from 5.0 GHz to 18.0 GHz. | Enables operation in C, X, Ku, and part of Ka bands for multi-band radar and EW systems. | Must |
| **REQ-HW-002** | **Instantaneous Bandwidth** | The receiver shall maintain a minimum flatness of ±3 dB over a 13 GHz instantaneous bandwidth (5-18 GHz). | Ensures signal integrity for wideband pulses and frequency hopping waveforms without per-band tuning. | Must |
| **REQ-HW-003** | **Signal Gain Range** | The system shall provide a total gain control range from 0 dB to 60 dB via cascaded RF and IF gain stages. | Compensates for varying input signal strengths from weak distant targets to strong jammers. | Must |
| **REQ-HW-004** | **Fine Gain Step Resolution** | The system shall allow gain adjustment in steps of 1.0 dB or finer across the programmable gain range. | Allows for precise automatic gain control (AGC) loop implementation to optimize ADC dynamic range. | Must |
| **REQ-HW-005** | **RF to IF Downconversion** | The receiver shall downconvert the 5-18 GHz RF input to an Intermediate Frequency (IF) suitable for the ADC (DC to 1.5 GHz) using a mixing stage. | Translates high-frequency signals to a processable frequency range for high-speed digitization. | Must |
| **REQ-HW-006** | **Local Oscillator Generation** | The system shall generate a stable Local Oscillator (LO) signal tunable from 5 GHz to 18 GHz to facilitate downconversion. | Provides the necessary frequency injection to select the desired RF band for processing. | Must |
| **REQ-HW-007** | **Frequency Agility** | The synthesizer shall support switching between any two frequencies within the 5-18 GHz band in less than 5 µs. | Required for frequency hopping waveforms and fast threat scanning in EW environments. | Must |
| **REQ-HW-008** | **Signal Digitization** | The system shall digitize the conditioned IF signal using a dual-channel 12-bit ADC operating at a minimum sample rate of 3.2 GSPS in single-channel mode or 1.6 GSPS in dual-channel mode. | Captures signal bandwidth up to Nyquist frequency with sufficient resolution (12 bits) for analysis. | Must |
| **REQ-HW-009** | **JESD204B/C Data Transmission** | The system shall output digitized data via a JESD204B or JESD204C interface. | Standard high-speed serial interface for moving data between ADC and FPGA/Processor. | Must |
| **REQ-HW-010** | **Lane Configuration** | The JESD204B/C interface shall support operation using 2, 3, or 4 lanes. | Provides flexibility for backplane width constraints and data throughput requirements. | Must |
| **REQ-HW-011** | **Deterministic Latency** | The JESD204 interface shall support Subclass 1 operation to ensure deterministic latency across the digital link. | Critical for time-sensitive beamforming and TDOA applications. | Must |
| **REQ-HW-012** | **SPI Control Interface** | The system shall configure all functional blocks (Gain, Frequency, ADC) via a standard Serial Peripheral Interface (SPI). | Widely adopted control protocol for integration with host processors. | Must |
| **REQ-HW-013** | **Gain Settling Time** | The system shall settle to within 0.5 dB of the programmed gain value within 1 µs after a SPI command is received. | Ensures AGC loops can react to transient signal changes without corrupting data. | Must |
| **REQ-HW-014** | **RF Input Impedance** | The RF input port shall present a nominal 50 Ω impedance to the source. | Matches standard RF interconnect systems (coax, connectors) to minimize reflections. | Must |
| **REQ-HW-015** | **Anti-Aliasing Filtering** | The system shall include an anti-aliasing filter with a cut-off frequency set appropriately for the ADC sampling rate (approx. 500-600 MHz LPF). | Prevents out-of-band noise and signals from folding into the band of interest during digitization. | Must |
| **REQ-HW-016** | **Power Supply Sequencing** | The system shall implement a power-up sequence that enables bias voltages to the LNA and Mixer only after the main supply rails have stabilized. | Protects sensitive GaAs/GaN components from latch-up or damage during power transients. | Should |
| **REQ-HW-017** | **Automatic Gain Control (AGC)** | The receiver shall support an AGC mode where the system automatically adjusts the gain stages based on the ADC's peak signal level to maximize SFDR. | Reduces host processor overhead and ensures optimal signal quality in dynamic environments. | Should |
| **REQ-HW-018** | **Internal Temperature Monitoring** | The system shall include an internal temperature sensor readable via the SPI interface. | Allows for system health monitoring and potential temperature compensation calibration. | Should |
| **REQ-HW-019** | **LO Amplification** | The LO path shall include a driver amplifier to ensure the mixer receives LO power between -5 dBm and +5 dBm across the 5-18 GHz band. | Ensures optimal mixer conversion loss and linearity performance. | Must |
| **REQ-HW-020** | **DC Power Input** | The system shall operate from a single nominal DC supply voltage of +12V or +15V. | Compatible with standard tactical vehicle and aircraft power supplies. | Must |

### 3.2 Performance Requirements

This section specifies the quantitative performance characteristics of the hardware. Values are derived from the design parameters and selected component data sheets (Qorvo TGA4943-SM, TI LMX2594, TI ADC12DJ3200).

| ID | Title | Value / Metric | Conditions | Rationale | Priority |
|---|---|---|---|---|---|
| **REQ-HW-P101** | **Noise Figure (NF)** | ≤ 6.0 dB | Full Band (5-18 GHz), 25°C | Defines the system's sensitivity. Calculation: LNA NF (3.5 dB) + Mixer (~8 dB Loss) + VGA (6 dB). High LNA gain suppresses downstream noise. | Must |
| **REQ-HW-P102** | **Signal-to-Noise Ratio (SNR)** | ≥ 55 dB (full scale) | At maximum input, -1 dBFS | Ensures adequate distinction between signal and noise floor for demodulation. | Must |
| **REQ-HW-P103** | **Spurious-Free Dynamic Range (SFDR)** | ≥ 60 dB | Full Band, -1 dBFS input | Measures the ratio between the fundamental signal and the worst spur. | Must |
| **REQ-HW-P104** | **Input Third-Order Intercept Point (IIP3)** | ≥ +10 dBm | Two-tone test, 1 MHz spacing | Defines system linearity. Based on TGA4943-SM IIP3 (+45 dBm) and cascade analysis. | Must |
| **REQ-HW-P105** | **Input 1 dB Compression Point (Input P1dB)** | ≥ -20 dBm | CW Input | The point where gain drops by 1 dB. Ensures the receiver can handle strong signals without saturation. | Must |
| **REQ-HW-P106** | **Phase Noise (LO)** | ≤ -90 dBc/Hz | 10 kHz offset, 10 GHz carrier | Critical for Doppler processing and modulation fidelity. Derived from LMX2594 performance. | Must |
| **REQ-HW-P107** | **Frequency Tuning Speed** | < 5 µs | Full band hop | Requirement for fast frequency hopping (FFH) waveforms. | Must |
| **REQ-HW-P108** | **Amplitude Flatness** | ± 3.0 dB | 5-18 GHz, at any gain setting | Ensures consistent signal strength across the entire operational bandwidth. | Must |
| **REQ-HW-P109** | **Input Return Loss** | ≥ 10 dB | Full Band (5-18 GHz) | Ensures minimal signal reflection at the input SMA connector (VSWR ≤ 2:1). | Must |
| **REQ-HW-P110** | **ADC Effective Number of Bits (ENOB)** | ≥ 9.5 bits | 500 MHz IF Input, -1 dBFS | Measure of ADC true resolution after noise and distortion. | Must |
| **REQ-HW-P111** | **Power Consumption** | ≤ 30 W | Max traffic, all rails on | Thermal design limit. Target is 15-20W typical, but 30W is the hard limit for the form factor. | Must |
| **REQ-HW-P112** | **Gain Settling Time** | < 1 µs | Step change 30 dB to 0 dB | Required for fast AGC response. Based on HMC698LP4 VGA settling time. | Must |
| **REQ-HW-P113** | **JESD204 Bit Error Rate (BER)** | < 10^-15 | Per lane | Ensures reliable data transmission to the processor. | Must |
| **REQ-HW-P114** | **LO Leakage (RF Feedthrough)** | ≤ -40 dBm | At RF Output Port | Minimizes self-interference. | Should |

---

**Document Status: AI-GENERATED**

# 3. Hardware Requirements

## 3.3 Interface Requirements

### 3.3.1 External Interfaces

This section defines the electrical and mechanical characteristics of interfaces connecting the **khgk** Wideband RF Receiver Module to external systems, including power sources, antennas, and digital backplanes.

#### 3.3.1.1 RF Input Interface

**REQ-HW-020:** The receiver shall provide a single RF input port compatible with 50 Ω impedance systems.
*Rationale:* Ensures compatibility with standard test equipment and antenna arrays.

**REQ-HW-021:** The RF input connector shall be a female SMA (SubMiniature version A) or SMP (Micro miniature push-on) connector, selected based on final integration geometry.
*Rationale:* SMA provides excellent RF performance up to 18 GHz and is widely available in military-grade variants. SMP is preferred for dense blind-mate applications.

**REQ-HW-022:** The RF input interface shall maintain a Voltage Standing Wave Ratio (VSWR) of 2.0:1 or better (Return Loss ≥ -9.54 dB) across the 5.0 to 18.0 GHz frequency range under all environmental conditions.
*Ref:* REQ-HW-001, REQ-HW-013.

**REQ-HW-023:** The RF input port shall include DC blockage to prevent external DC bias from damaging the internal LNA.
*Constraint:* Capacitance must be rated for high current RF operation to prevent "burn-out."

#### 3.3.1.2 High-Speed Digital Output Interface (JESD204B/C)

**REQ-HW-024:** The digitized IF/Baseband data shall be transmitted via a JESD204B or JESD204C compliant high-speed serial interface.
*Ref:* REQ-HW-005.

**REQ-HW-025:** The JESD204 interface shall operate at a lane rate of 6.25 Gbps to 12.5 Gbps per lane.
*Constraint:* Deterministic latency (Subclass 1) is required for radar time-of-flight calculations.

**REQ-HW-026:** The module shall provide four (4) differential transmit lanes (CML logic) utilizing a Samtec BTH/Launch or equivalent high-speed connector (e.g., BTH-030-01-F-D-AD).
*Ref:* Design parameters.

**REQ-HW-027:** The physical layer (PHY) for the JESD204 lanes shall support AC-coupling.
*Requirement:* Series coupling capacitors (0.1 µF) shall be placed near the transmitter pins.

**Table 3-1: JESD204 High-Speed Connector Pinout**

| Pin # | Signal Name | Description | Differential Pair | Notes |
|---|---|---|---|---|
| 1 | GND | Ground | N/A | Shield |
| 2 | JESD_TX0_P | Lane 0 Positive | Lane 0 | AC Coupled |
| 3 | JESD_TX0_N | Lane 0 Negative | Lane 0 | AC Coupled |
| 4 | JESD_TX1_P | Lane 1 Positive | Lane 1 | AC Coupled |
| 5 | JESD_TX1_N | Lane 1 Negative | Lane 1 | AC Coupled |
| 6 | GND | Ground | N/A | Shield |
| ... | ... | ... | ... | (Lanes 2 & 3 similar) |
| M | SYNC_N | Synchronization Input | Single Ended | LVDS / CMOS |
| N | SYSREF | System Reference | Single Ended | LVDS |

#### 3.3.1.3 Power Input Interface

**REQ-HW-028:** The module shall accept DC power via a circular connector (e.g., Micro-D or Nano-D) or a 2-pin header.
*Voltage:* +12V to +15V DC nominal.

**REQ-HW-029:** The power input shall include reverse polarity protection and input filtering (PI filter) to meet MIL-STD-461G conducted emissions requirements.
*Ref:* REQ-HW-016.

### 3.3.2 Internal Interfaces

This section details the interfaces between the **khgk** internal subsystems (e.g., Synthesizer to Mixer, MCU to VGAs).

#### 3.3.2.1 Local Oscillator (LO) Distribution

**REQ-HW-030:** The wideband synthesizer (LMX2594) shall drive the I/Q Mixer (HMC525LC4) via a single-ended 50 Ω transmission line.
*Ref:* Component Recommendations.

**REQ-HW-031:** An LO amplifier (gain ~15 dB) shall be inserted between the Synthesizer and the Mixer to ensure the LO drive level meets the Mixer's P1dB requirement (typically +5 dBm to +10 dBm).
*Calculation:* LMX2594 output is ~-5 to +5 dBm. HMC525 requires +5 dBm. Therefore, a gain stage is mandatory to ensure saturation headroom.

#### 3.3.2.2 Analog IF Chain Interface

**REQ-HW-032:** The interface between the IF Amplifier and the ADC (ADC12DJ3200) shall be differential analog.
*Requirement:* A balun or differential amplifier shall convert the single-ended mixer output to a differential signal for the ADC inputs.

**REQ-HW-033:** The common-mode voltage of the ADC inputs shall be set to 0.9V (typical for ADC12DJ3200) via internal ADC references or external bias tees.

### 3.3.3 Communication Interfaces

#### 3.3.3.1 Control Interface (SPI/I2C)

**REQ-HW-034:** The system control MCU shall communicate with the Synthesizer, VGA, and ADC via a Serial Peripheral Interface (SPI) bus operating in Mode 0 (CPOL=0, CPHA=0).
*Ref:* REQ-HW-012.

**REQ-HW-035:** The SPI clock frequency shall be 10 MHz maximum.
*Rationale:* High-speed clocking is limited by the cable length and EMI considerations in a tactical environment.

**REQ-HW-036:** Chip Select (CS) lines shall be independent for each slave device to allow independent programming.

**Table 3-2: Internal SPI Address Map (Preliminary)**

| Slave Device | Chip Select ID | Register Range | Function |
|---|---|---|---|
| LMX2594 (Synth) | CS_0 | 0x00 - 0x3F | Frequency tuning, power down |
| HMC698 (VGA) | CS_1 | 0x00 - 0x0F | Gain setting, attenuation |
| ADC12DJ3200 | CS_2 | 0x00 - 0xFF | JESD config, test modes, offset |
| Temp Sensor | CS_3 | 0x00 - 0x05 | On-board telemetry reading |

#### 3.3.3.2 Synchronization Signals

**REQ-HW-037:** The module shall accept an external SYSREF signal (LVDS) to align the JESD204 local multi-frame clocks.
*Ref:* JESD204B Subclass 1 requirement.

**REQ-HW-038:** The SYNC~ signal shall be driven by the FPGA/ASIC to the ADC to initiate link re-synchronization if the link loses lock.

## 3.4 Environmental Requirements

This section specifies the environmental conditions the **khgk** hardware must withstand during operation, storage, and transport.

### 3.4.1 Operating and Storage Temperature

**REQ-HW-039:** The receiver module shall maintain full electrical performance (NF, Gain, IP3) over an ambient operating temperature range of **-55°C to +125°C**.
*Ref:* REQ-HW-009.

**REQ-HW-040:** All active components (MMICs, ADCs, Synthesizer) shall be sourced in military temperature grade variants (e.g., "H" class for Analog Devices, QML-qualified for TI) or screened to equivalent limits.
*Constraint:* Industrial grade components (-40 to +85°C) are strictly prohibited.

### 3.4.2 Humidity and Moisture

**REQ-HW-041:** The module shall operate in 5% to 95% relative humidity (non-condensing).
*Mitigation:* The PCB shall be conformal coated (UReSil or AR type) to prevent moisture ingress and corrosion.

### 3.4.3 Vibration and Shock

**REQ-HW-042:** The module shall be designed to survive vibration per MIL-STD-810G, Method 514.6 (Category 4, tactical wheeled vehicles: 5-200 Hz, 1.0 g RMS).
*Ref:* REQ-HW-015.

**REQ-HW-043:** The module shall withstand operational shock of 40g, 11 ms, half-sine wave per MIL-STD-810G, Method 516.6.
*Design Action:* Heavy components (e.g., RF connectors, large capacitors) shall be secured with adhesive or staking compound in addition to solder.

### 3.4.4 EMI/EMC

**REQ-HW-044:** The module shall not emit radiated emissions exceeding the limits set forth in MIL-STD-461G, RE102 (Electric Field, Radiated Emissions, 2 MHz - 18 GHz).
*Ref:* REQ-HW-016.

**REQ-HW-045:** The module shall be immune to radiated susceptibility per MIL-STD-461G, RS103 (20 V/m from 2 MHz - 18 GHz).
*Design Action:* Shielding cans shall be utilized over the RF Front End and LO Synthesizer sections.

## 3.5 Power Requirements

This section details the power supply requirements, distribution, and consumption budget for the **khgk** module.

### 3.5.1 Power Input Specifications

**REQ-HW-046:** The primary input voltage shall be **+12V DC ±10%**.
*Ref:* REQ-HW-010.

**REQ-HW-047:** The module shall support an input voltage range up to +15V DC to accommodate vehicle/aircraft power transients.
*Note:* Internal switching regulators must accommodate this wide input range.

### 3.5.2 Power Consumption Budget

The following power budget is calculated based on typical supply currents for the selected components (Qorvo TGA4943, TI LMX2594, TI ADC12DJ3200) with a 15% engineering margin.

**REQ-HW-048:** The total power consumption shall not exceed **30 Watts**.
*Ref:* REQ-HW-010.

**Table 3-3: Detailed Power Budget (at +25°C and +125°C)**

| Subsystem | Component(s) | Voltage (V) | Typical Current (A) | Max Current (A) | Power (W) |
|---|---|---|---|---|---|
| **RF Front End** | TGA4943 LNA | +12 | 0.30 | 0.36 | 4.32 |
| | HMC698 VGA | +5 / -5 | 0.10 | 0.12 | 1.20 |
| **LO / Synth** | LMX2594 | +3.3 | 0.30 | 0.36 | 1.19 |
| | LO Amp | +5 | 0.10 | 0.12 | 0.60 |
| **IF / ADC** | ADC12DJ3200 | +1.0 / +1.8 / +2.5 | 2.50 | 3.00 | 5.50 |
| **Digital / FPGA** | FIFO / Logic | +1.0 / +1.2 | 1.50 | 1.80 | 2.50 |
| **MCU / Ctrl** | ARM Cortex-M | +3.3 | 0.05 | 0.06 | 0.20 |
| **Misc / Aux** | Temp Sensors / LDOs | +3.3 / +5 | 0.20 | 0.24 | 1.20 |
| **Subtotal** | | | | | **16.71 W** |
| **Eng. Margin (15%)** | | | | | **2.51 W** |
| **Total** | | | | | **~19.2 W** |

*Note: The Total of 19.2W is well within the 30W limit, providing significant headroom for thermal management.*

### 3.5.3 Supply Sequencing

**REQ-HW-049:** The power management system shall sequence the voltage rails to prevent latch-up or excessive current draw.
*Sequence:*
1. +3.3V (Digital Logic/MCU)
2. +5V / +12V (Analog RF)
3. +1.0V (FPGA Core)
4. +1.8V (ADC Cores)

**REQ-HW-050:** An under-voltage lockout (UVLO) circuit shall disable the module if input voltage drops below 10.8V.

### 3.5.4 Thermal Requirements

**REQ-HW-051:** The module shall be designed to operate at an ambient temperature of +125°C with a case temperature (Tc) not exceeding +85°C on critical component junctions (Tj), assuming a heat sink or cold plate interface is provided by the system integrator.

**REQ-HW-052:** The PCB shall utilize a metal-core (e.g., Rogers RO4350B or similar high-Tg laminate on aluminum or copper backing) or heavy copper (2 oz - 4 oz) layers to spread heat from high-power dissipators (LNA, ADC).

## 3.6 Physical Requirements

This section defines the mechanical and physical constraints of the **khgk** Wideband RF Receiver Module.

### 3.6.1 Dimensions

**REQ-HW-053:** The maximum envelope of the module shall not exceed **120mm (L) x 80mm (W) x 15mm (H)**.
*Ref:* REQ-HW-011.

**REQ-HW-054:** The PCB outline shall conform to a standard Eurocard or VPX slot width, compatible with the specified 120mm length.

### 3.6.2 Connectors and Mounting

**REQ-HW-055:** The module shall utilize four (4) #4-40 or M3 mounting holes, one in each corner, for secure chassis attachment.
*Requirement:* Holes shall be plated (non-functional) or clearance holes with appropriate keep-out zones.

**REQ-HW-056:** RF connectors shall be edge-mounted on the 120mm side.
*Pitch:* Standard 0.5" (12.7mm) pitch or SMP ganged pitch.

### 3.6.3 Materials and Finish

**REQ-HW-057:** The PCB laminate shall be Rogers RO4003C or RO4350B material.
*Justification:* These materials offer stable dielectric constant (Dk) and low dissipation factor (Df) over the military temperature range, essential for 18 GHz operation.

**REQ-HW-058:** Solder mask shall be green or black (LPI) and conformal coating (Acrylic or Urethane) shall be applied to all assemblies.

**REQ-HW-059:** The chassis/case (if supplied) shall be machined Aluminum 6061-T6 with Chem-film (Alodine) or Anodized finish for corrosion resistance and EMI grounding.

---

**Document Status: AI-GENERATED**

# 4. Design Constraints

This section defines the constraints placed on the hardware design of the khgk Wideband RF Receiver Module. These constraints encompass standards compliance, component selection limitations, and manufacturing processes required to achieve the target military performance, reliability, and environmental goals.

## 4.1 Standards Compliance

The hardware design shall adhere to the specific industry and military standards listed below. Compliance ensures interoperability, reliability in harsh environments, and safety.

### 4.1.1 Environmental and Mechanical Standards
The design of the khgk receiver module shall comply with the following environmental standards to ensure survival in tactical military environments:

*   **MIL-STD-810G:** *Environmental Engineering Considerations and Laboratory Tests.*
    *   **Section 506.5 (Vibration):** The design must withstand functional vibration profiles (Category 14, Jet aircraft/VSTOL) and transportation vibration. PCB stiffeners and conformal coating are required per **REQ-HW-015**.
    *   **Section 516.6 (Shock):** The design must withstand transit drop and operational shock (40g, 11ms pulse).
    *   **Section 507.5 (Temperature):** Qualification testing must validate performance from -55°C to +125°C (Method 507.5, Procedure III - Thermal Shock may be applicable for rapid cycling).

*   **IPC-6012DS:** *Performance Specification for High Density Interconnect (HDI) Printed Boards.*
    *   Given the high-speed JESD204B/C interfaces (>12.5 Gbps) and dense RF layout, the PCB must be manufactured to Class 3A (High Performance Electronics) specifications with HDI capabilities (microvias, laser drills) to manage signal integrity.

*   **IPC-2221:** *Generic Standard on Printed Board Design.*
    *   Trace widths and spacing shall be calculated per IPC-2221 for the current carrying capacity required by the 15W-30W power budget and high-voltage isolation (where applicable).
    *   **Constraint:** For RF signal lines controlled impedance, the dielectric thickness tolerance must be ±10% or better to maintain impedance accuracy.

### 4.1.2 Electromagnetic Compliance (EMC)
The receiver must operate within a dense electromagnetic environment without causing interference or being susceptible to it.

*   **MIL-STD-461G:** *Requirements for the Control of Electromagnetic Interference Characteristics of Subsystems and Equipment.*
    *   **REQ-HW-016 (CE102):** Conducted emissions on power leads must be suppressed using pi-filters at the DC input connector.
    *   **REQ-HW-016 (RE102):** Radiated emissions (2 MHz - 18 GHz) must be minimized. This requires shielding cans over the RF section and the Digital/FPGA section.
    *   **REQ-HW-016 (CS101):** Conducted susceptibility on power leads requires the input DC-DC converters to have high rejection (PSRR) ratings and input filtering.
    *   **CS114/CS115:** Bulk cable injection immunity requires I/O filtering on all digital control lines (SPI, JESD204 lanes).

### 4.1.3 Materials and Safety
*   **RoHS (Restriction of Hazardous Substances):** The module shall be RoHS compliant (Directive 2011/65/EU) for commercial markets, unless explicitly waived by the specific military contract for high-reliability leaded solder.
*   **REACH:** Compliance with Registration, Evaluation, Authorisation and Restriction of Chemicals.
*   **UL 94V-0:** All PCB materials used must meet the UL 94V-0 flammability standard.

## 4.2 Component Constraints

To meet the lifecycle, temperature, and performance requirements, the Bill of Materials (BOM) is subject to the following strict constraints.

### 4.2.1 Temperature and Reliability Classification
All active and critical passive components must meet the military operating temperature range.
*   **Operating Range:** Components must be rated for **-55°C to +125°C**.
*   **Acceptable Grades:**
    *   **QML-38535:** Qualified Manufacturer List, Class Q (Military), Class V (Space) preferred for FPGAs/ADCs.
    *   **883 B/Class S:** MIL-STD-883 compliant devices.
    *   **Automotive Grade:** (-40°C to +125°C) are acceptable for non-critical support logic (e.g., EEPROM, temperature sensors) provided system-level derating analysis allows it.
    *   **High-Temp Industrial:** Only acceptable if screening data (burn-in) is supplied and the specific part does not derate performance below -55°C.

### 4.2.2 Lifecycle and Sourcing
**REQ-HW-017** dictates strict sourcing rules to prevent obsolescence.
*   **Lifecycle Status:** All components shall be "Production" or "Not Recommended for New Designs" (NRND) only if a drop-in replacement exists. "Obsolete" parts are strictly forbidden.
*   **Single Source Mitigation:** For the specific recommended components (e.g., TGA4943-SM, LMX2594), a second-source equivalent must be identified in the design documentation, or a lifetime buy must be planned if the project volume exceeds 500 units.
*   **Packaging:** Plastic encapsulated microcircuits (PEM) are generally acceptable but must be evaluated for "popcorning" due to moisture absorption. Ceramic hermetic packages are required for the ultimate high-reliability configuration.

### 4.2.3 Component Derating
To ensure reliability at 125°C junction temperature, the following derating rules apply per **DoD-STD-1547** (unless specific component datasheets specify otherwise):
*   **Voltage:** Maximum applied voltage shall be ≤ 80% of the Absolute Maximum Rating.
*   **Current:** Maximum current shall be ≤ 75% of the Absolute Maximum Rating.
*   **Power (Dissipation):** Maximum power dissipation shall be ≤ 70% of the rating at the maximum case temperature.
*   **Junction Temperature ($T_j$):** Calculated $T_j$ must remain ≤ 110°C (90% of max) under worst-case ambient conditions (+125°C).
    *   *Calculation Check:* For the Qorvo TGA4943-SM (GaN), junction temperature is critical. With $T_{case(max)} = 125°C$ and $R_{th(j-c)} \approx 10°C/W$, at 5W dissipation, $T_j = 125 + (5 \times 10) = 175°C$. This is within the typical GaN limit but requires the PCB heatsink pad to maintain $T_{case} \le 125°C$.

## 4.3 Manufacturing Constraints

The physical realization of the khgk module requires specialized manufacturing techniques to support 5-18 GHz RF operation and military ruggedness.

### 4.3.1 PCB Material and Stackup
*   **Dielectric Material:** Rogers RO4350B or Tachyon 100G laminates are required for the RF layers.
    *   **Reasoning:** Standard FR-4 has a high Dissipation Factor (Df) ~0.02 at high frequencies, causing excessive loss.
    *   **Spec Target:** Df ≤ 0.0037 at 10 GHz. Dielectric Constant (Dk) stability of ±0.05 across temperature.
*   **Layer Stackup (10-12 layers proposed):**
    *   **Layer 1-2:** RF Signal / Ground (Core, Low loss).
    *   **Layer 3-8:** Mixed Signal (JESD204, Power), Internal Ground Planes.
    *   **Layer 9-10:** Power Planes.
    *   **Layer 11-12:** Control signals, Bottom ground pour.
*   **Plating:** Electroless Nickel Immersion Gold (ENIG) is required for the wirebond pads (if hybrids are used) or Edge Plating for the RF connector launch. Electroless Nickel Palladium Gold (ENEPIG) is preferred for fine-pitch BGAs (ADC/FPGA) to prevent "black pad" syndrome.

### 4.3.2 Assembly and Inspection
*   **Solder Paste:** Type 4 or Type 5 solder paste powder is required for the fine-pitch JESD204B/C escape routing on the FPGA/ADC (0.5mm pitch or lower).
*   **RF Connections:** Chip-on-board (COB) wirebonding or ribbon bonding is required for the GaN MMIC (TGA4943-SM) and Mixer to minimize parasitic inductance. Surface mount technology (SMT) is acceptable for frequencies below 6 GHz.
*   **Conformal Coating:** The assembled board shall be coated with a military-grade conformal coating (e.g., UR type - Polyurethane or AR type - Acrylic) per MIL-I-46058C to protect against moisture and chemical exposure.
*   **Cleaning:** A strict No-Clean process requires validation for ionic contamination (J-STD-001, Class 3).

### 4.3.3 Mechanical Design
*   **Enclosure:** The module must fit within a 120mm x 80mm x 15mm envelope.
*   **RF Connectors:**
    *   **Input:** SMA (End-launch) or SMP (Blind-mate) for PCB edge.
    *   **Constraint:** Keep-out zones of 2.5 mm around RF connector footprints to accommodate tooling for hex nuts.
*   **Thermal Management:**
    *   **Heat Spreader:** A copper-invar-copper (CIC) or copper-tungsten (CuW) heat spreader is recommended under the GaN LNA and ADC to manage CTE mismatch and thermal conductivity.
    *   **Mounting:** The PCB must have stiffening rails or a bracket attached to the chassis to prevent resonance during vibration (MIL-STD-810G).
*   **Keep-Out Areas:**
    *   High-speed digital oscillators (FPGA clock) must be physically placed > 1.0 inch away from the RF input chain to prevent phase noise degradation.

### 4.3.4 Test and Inspection Constraints
*   **Flying Probe:** Not allowed for high-frequency RF nets; correlated with **Requirement ID: N/A (Manufacturing)**.
*   **Boundary Scan (JTAG):** The design must include a JTAG chain (IEEE 1149.1) encompassing the FPGA, ADC, and Flash to enable board-level manufacturing diagnostics.
*   **X-Ray Inspection:** Required for all BGA packages (ADC, FPGA) to verify bump collapse and voiding (>15% voiding is rejectable per IPC-A-610G Class 3).

---

# 5. Verification Requirements

This section defines the verification methods for all hardware requirements specified in Section 3. The verification methodology ensures that the "khgk" Wideband RF Receiver Module meets its functional, performance, environmental, and interface requirements under military operating conditions. Verification is categorized into three methods:
*   **Test (T):** Quantitative measurement of performance parameters using test equipment (e.g., Spectrum Analyzers, Network Analyzers, Power Meters).
*   **Analysis (A):** Quantitative evaluation through calculation, simulation, or modeling (e.g., Power Budget, Thermal Simulation).
*   **Inspection (I):** Qualitative or quantitative visual examination, design review, or check against documentation (e.g., BOM review, connector mating).

## 5.1 Test Requirements

This subsection details the specific test procedures, setups, and acceptance criteria for requirements verified through testing. All tests shall be conducted at the nominal supply voltage (+12V DC or +15V DC as configured) and at the temperature extremes of -55°C and +125°C (ambient) to validate military performance, unless otherwise specified.

### 5.1.1 RF Performance Test Setup
The testing requires the following equipment configuration:
*   **Signal Source:** Wideband Microwave Signal Generator (e.g., Keysight N5183B) covering 5-18 GHz.
*   **Analyzer:** Vector Signal Analyzer or Spectrum Analyzer with tracking generator (e.g., Keysux N9040B) covering DC to 18 GHz.
*   **Network Analyzer:** Vector Network Analyzer (e.g., Keysight PNA) for S-parameter measurements.
*   **Power Supply:** Programmable DC Power Supply capable of 12-15V, 5A.
*   **Thermal Chamber:** Environmental chamber capable of -55°C to +125°C with feedthrough ports for RF and DC.
*   **Digital Load:** FPGA or JESD204B/C Test Loopback Card (e.g., Texas Instruments ADC12DJ3200EVM) to verify bit integrity.

### 5.1.2 Detailed Test Cases

#### Test Case TC-RF-001: Input Frequency Range & Input Return Loss
*   **Requirement ID:** REQ-HW-001, REQ-HW-013
*   **Method:** Network Analyzer Measurement
*   **Procedure:**
    1.  Calibrate VNA to the SMA connector interface of the DUT (Device Under Test).
    2.  Set the DUT gain to mid-range (30 dB).
    3.  Sweep the input frequency from 4 GHz to 19 GHz.
    4.  Measure S11 (Input Return Loss).
    5.  Observe the system gain response to verify coverage.
*   **Pass Criteria:**
    *   Input Return Loss (S11) ≤ -10 dB across 5.0 GHz to 18.0 GHz.
    *   Gain variation within the specified flatness (derived from system NF/IP3) across the band.
*   **Priority:** Must Have

#### Test Case TC-RF-002: System Noise Figure (NF)
*   **Requirement ID:** REQ-HW-002
*   **Method:** Noise Figure Analyzer (Y-Factor Method)
*   **Procedure:**
    1.  Connect Noise Source (e.g., 34 dB ENR) to DUT input.
    2.  Set DUT Gain to Maximum (to minimize measurement uncertainty).
    3.  Measure Noise Figure at frequency points: 5, 7, 10, 13, 16, 18 GHz.
    4.  Repeat at -55°C and +125°C ambient.
*   **Pass Criteria:**
    *   System NF ≤ 6.0 dB across 5-18 GHz.
    *   Target NF ≤ 4.0 dB in optimal sub-bands (10-12 GHz).
*   **Priority:** Must Have

#### Test Case TC-RF-003: Spurious-Free Dynamic Range (SFDR) & Linearity
*   **Requirement ID:** REQ-HW-003, REQ-HW-008
*   **Method:** Two-Tone Intermodulation Test
*   **Procedure:**
    1.  Generate two CW tones ($f_1$ and $f_2$) separated by 1 MHz (e.g., $f_c$ + 0.5 MHz and $f_c$ - 0.5 MHz) within the 5-18 GHz band.
    2.  Set input power level such that the fundamental tones are at -10 dBm at the DUT input (back off from P1dB).
    3.  Capture the DUT output spectrum via the ADC digital output (to include converter distortion) or IF output.
    4.  Measure the power of the fundamental ($P_{fund}$) and the 3rd-order intermodulation products ($P_{IM3}$).
    5.  Calculate SFDR = $P_{fund} - P_{spur\_max}$ (worst spur).
*   **Pass Criteria:**
    *   SFDR ≥ 60 dB (Typical > 70 dB).
    *   Input IP3 calculated from IM3 products must be ≥ +10 dBm.
*   **Priority:** Must Have

#### Test Case TC-RF-004: Gain Control Range & Accuracy
*   **Requirement ID:** REQ-HW-004
*   **Method:** Scalar Gain Measurement
*   **Procedure:**
    1.  Set frequency to 10 GHz.
    2.  Step the SPI gain register from minimum code (0 dB) to maximum code (60 dB) in 1 dB increments.
    3.  Record measured output power vs. input power at each step.
    4.  Verify step accuracy and monotonicity.
    5.  Repeat at -55°C and +125°C.
*   **Pass Criteria:**
    *   Total Gain Range ≥ 60 dB.
    *   Step Error: ±1.0 dB relative to ideal curve.
    *   Settling time: < 1 µs (observed on high-speed scope).
*   **Priority:** Must Have

#### Test Case TC-RF-005: Phase Noise & Frequency Agility
*   **Requirement ID:** REQ-HW-007, REQ-HW-014
*   **Method:** Phase Noise Measurement & Frequency Hopping Timing
*   **Procedure:**
    1.  Set LO frequency to 10 GHz.
    2.  Measure Phase Noise using a Signal Source Analyzer (e.g., Keysight E5052B) at offsets 1 kHz, 10 kHz, 100 kHz, and 1 MHz.
    3.  **Agility Test:** Command a frequency hop from 5.0 GHz to 18.0 GHz via SPI. Monitor the PLL Lock Detect (LD) pin on the LMX2594 with an oscilloscope to measure time between SPI write and Lock High.
*   **Pass Criteria:**
    *   Phase Noise ≤ -80 dBc/Hz @ 1 kHz.
    *   Phase Noise ≤ -90 dBc/Hz @ 10 kHz.
    *   Tuning Speed (Lock Time) < 5 µs.
*   **Priority:** Must Have

#### Test Case TC-RF-006: ADC Interface & Digital Output
*   **Requirement ID:** REQ-HW-005, REQ-HW-006
*   **Method:** Bit Error Rate (BER) Test & Protocol Analysis
*   **Procedure:**
    1.  Input a known CW tone into the RF path.
    2.  Connect JESD204B/C lanes to a Logic Analyzer or FPGA with known-good reference design.
    3.  Verify alignment of Sync~ (SUBCLASS 1) and SYSREF.
    4.  Capture 1 million samples. Perform FFT on captured data in MATLAB/FPGA.
    5.  Calculate ENOB.
*   **Pass Criteria:**
    *   Link establishes successfully (Code Group Sync).
    *   Deterministic Latency maintained.
    *   ENOB > 9.0 bits at Nyquist.
    *   Lane data rate stable at configured rate (e.g., 6.25 Gbps or 12.5 Gbps).
*   **Priority:** Must Have

#### Test Case TC-ENV-001: Operating Temperature & Thermal Performance
*   **Requirement ID:** REQ-HW-009
*   **Method:** Environmental Stress Screening
*   **Procedure:**
    1.  Place DUT in thermal chamber.
    2.  Soak at -55°C for 30 mins. Perform functional test (TC-RF-001, TC-RF-002).
    3.  Soak at +125°C for 30 mins. Perform functional test.
    4.  During +125°C test, monitor case temperature of critical components (ADC, PA) using IR camera or embedded sensors.
*   **Pass Criteria:**
    *   All parameter specifications met (NF, Gain, SFDR) at limits.
    *   No component junction temperature exceeds rating (Assumed Tj_max = 150°C for military silicon).
    *   Thermal shutdown (if enabled) does not trigger.
*   **Priority:** Must Have

#### Test Case TC-ENV-002: Vibration and Shock
*   **Requirement ID:** REQ-HW-015
*   **Method:** Mechanical Shaker Table
*   **Procedure:**
    1.  Mount DUT on vibration fixture simulating installation.
    2.  Perform MIL-STD-810G Method 514.6 vibration (Random 5-2000 Hz, 20g).
    3.  Perform functional check.
    4.  Apply mechanical shock (40g, 11ms) per MIL-STD-810G Method 516.6.
    5.  Perform visual inspection (microscope) and functional test.
*   **Pass Criteria:**
    *   No physical damage (cracks, detached components).
    *   Intermittent signal continuity (Momentary Intervals) < 1 µs.
    *   Functional test passes post-vibration.
*   **Priority:** Should Have

#### Test Case TC-EMC-001: EMI/EMC Compliance
*   **Requirement ID:** REQ-HW-016
*   **Method:** Conducted/Radiated Emissions Scan
*   **Procedure:**
    1.  Place DUT in EMI chamber (per MIL-STD-461G setup).
    2.  Measure Radiated Emissions (RE102) from 2 MHz to 18 GHz.
    3.  Measure Conducted Emissions (CE102) on power lines.
*   **Pass Criteria:**
    *   Emissions levels stay below MIL-STD-461G limits for Army/Air Force applications.
    *   No spurs exceeding -60 dBm radiated from the cabinet seams.
*   **Priority:** Should Have

## 5.2 Analysis Requirements

This subsection details requirements verified through engineering analysis, simulation, and calculation prior to physical prototyping or in conjunction with design validation.

### 5.2.1 Power Budget Analysis
*   **Requirement ID:** REQ-HW-010
*   **Method:** Spreadsheet Calculation & Component Datasheet Aggregation.
*   **Details:**
    The total power consumption must be calculated based on the selected components from Section 6 (BOM).
    
    *Table: Estimated Power Consumption (Typical vs Max)*
    
    | Component Block | Component Ref | Quan | Voltage (V) | Current Typ (A) | Current Max (A) | Power Typ (W) | Power Max (W) |
    |---|---|---|---|---|---|---|---|
    | RF Front End (LNA) | TGA4943-SM | 1 | 12 | 0.30 | 0.45 | 3.6 | 5.4 |
    | DVGA | HMC698LP4 | 1 | +/-5 | 0.12 | 0.15 | 1.2 | 1.5 |
    | Mixer | HMC525LC4 | 1 | 5 | 0.15 | 0.20 | 0.75 | 1.0 |
    | Synthesizer | LMX2594 | 1 | 3.3 | 0.20 | 0.25 | 0.66 | 0.82 |
    | ADC | ADC12DJ3200 | 1 | 1.1/1.8/2.5 | 2.50 | 3.80 | 3.5 | 5.2 |
    | MCU/FPGA | Artix-7/STM32 | 1 | 1.0/3.3 | 1.00 | 1.50 | 2.0 | 3.0 |
    | LDO/Buck Losses | Power Mgmt | 1 | - | - | - | 1.5 | 2.5 |
    | **Total** | | | | | | **13.21 W** | **19.42 W** |
    
*   **Verification:** The calculation confirms that with a +12V supply at 3A max capacity (36W available), the design targets 13-20W consumption. The analysis shows headroom of ~16W for safety margin.
*   **Pass Criteria:** Total calculated power ≤ 30W (Req) and target 15-20W typical achieved.

### 5.2.2 RF Chain Cascade Analysis
*   **Requirement ID:** REQ-HW-002, REQ-HW-003, REQ-HW-008
*   **Method:** RF Cascade Simulation (e.g., Keysight Genesys, Analog Office).
*   **Details:**
    The system linearity (IP3) and noise figure (NF) are verified by cascading the S-parameters of specific components.
    
    *   *Gain:* LNA (20dB) + Mixer (-8dB) + IF Amp (15dB) ≈ 27dB (adjusted by VGA).
    *   *NF:* Dominated by first LNA (3.5dB) + Mixer Loss (8dB) / LNA Gain.
        *   Calculation: $F_{sys} = F_1 + (F_2-1)/G_1 ...$
        *   $NF_{sys} \approx 3.5 + (8-1)/100 \approx 3.57$ dB (at maximum LNA gain). Meets 3-6dB target.
    *   *OIP3:* Cascaded IIP3 calculated to ensure +10 dBm input IIP3.
        *   Mixer IIP3 (+23 dBm) - Preceding Gain (20dB) = Input IIP3 of +3 dBm.
        *   *Analysis Result:* The current design risks violating the +10 dBm Input IP3 requirement because the high gain of the LNA reduces the system linearity before the mixer.
        *   *Design Adjustment Required:* Reduce LNA gain or insert a switched attenuator before the mixer to meet the +10 dBm IIP3 requirement. Alternatively, verify if "Input IP3" refers to the *saturated* input where the VGA is minimum.
        *   *Assumption:* Requirement assumed at maximum gain setting for sensitivity, or minimum gain setting for linearity. Analysis confirms > +10 dBm IIP3 is achievable at < 10dB gain settings.
*   **Pass Criteria:** Calculated system NF < 6dB. Calculated system P1dB > 0dBm output.

### 5.2.3 Thermal Analysis
*   **Requirement ID:** REQ-HW-009
*   **Method:** Computational Fluid Dynamics (CFD) or Hand Calculation.
*   **Details:**
    *   Calculate junction temperature ($T_j$) for the ADC and LNA.
    *   Equation: $T_j = T_a + (P_d \times \theta_{ja})$
    *   Assumptions:
        *   $T_a$ (Ambient) = +125°C (Worst case).
        *   $P_d$ (ADC Dissipation) = 5.2W.
        *   $\theta_{ja}$ (Package to Air with heatsink) = 15°C/W (Target design value).
    *   $T_j = 125 + (5.2 \times 15) = 125 + 78 = 203°C$.
*   **Analysis Result:**
    *   This exceeds the typical silicon limit of ~150°C.
    *   *Design Requirement:* The thermal resistance of the PCB/conductive cooling path must be significantly improved. $\theta_{ja}$ must be < 4°C/W, or the power consumption of the ADC must be managed (lower sample rate/duty cycle) to meet MIL-TEMP requirements without active cooling.
*   **Pass Criteria:** Demonstrated thermal path design ensuring $T_j < 150°C$ at $+125°C$ ambient.

## 5.3 Inspection Requirements

This subsection covers requirements verified by visual review, design audit, or manufacturing inspection.

### 5.3.1 Mechanical Inspection
*   **Requirement ID:** REQ-HW-011
*   **Method:** Physical Measurement & Visual Review.
*   **Procedure:**
    1.  Measure the length, width, and height of the assembled module.
    2.  Inspect connector placement (SMA, Circular Digital).
    3.  Verify mounting hole alignment.
*   **Pass Criteria:**
    *   Dimensions ≤ 120mm x 80mm x 15mm.
    *   Connectors do not protrude beyond keep-out zones defined in mechanical drawing.
    *   Conformal coating is uniformly applied (visual check).

### 5.3.2 Component Sourcing & BOM Verification
*   **Requirement ID:** REQ-HW-017
*   **Method:** BOM Review / Design for Manufacturability (DFM) Audit.
*   **Procedure:**
    1.  Review the Bill of Materials (Section 6).
    2.  Verify all active components have "Military" or "Extended Industrial" temperature ratings (-55°C to +125°C).
    3.  Check lifecycle status of critical parts (LMX2594, ADC12DJ3200) on manufacturer websites (e.g., TI indicates "Active" or "Not Recommended for New Designs" - if NRND, redesign is required).
*   **Pass Criteria:** 100% of components meet temperature rating. 0 critical components are EOL (End of Life).

### 5.3.3 Workmanship & Standards Compliance
*   **Requirement ID:** REQ-HW-016
*   **Method:** Visual Inspection under Microscope (IPC-A-610 Class 3).
*   **Procedure:**
    1.  Inspect solder joints of high-frequency components (LNA, Mixer).
    2.  Verify EMI gasket installation on enclosure lid if applicable.
    3.  Check for proper torquing of screws.
*   **Pass Criteria:** No solder bridges, cold joints, or insufficient solder on RF pads. EMI gasket makes continuous contact.

### 5.3.4 Interface Pinout Verification
*   **Requirement ID:** REQ-HW-005, REQ-HW-012
*   **Method:** Continuity Check (Multimeter).
*   **Procedure:**
    1.  Verify pin-to-pin continuity from the PCB edge connector to the specific IC pins (ADC JESD lanes, MCU SPI pins).
    2.  Verify no shorts between adjacent pins (especially for high-speed differential pairs).
*   **Pass Criteria:** 100% continuity. 0 shorts.

---

### 5.4 Verification Traceability Matrix

The following table maps all requirements to their verification method defined above.

| REQ ID | Requirement Title | Verification Method | Test Case / Analysis Ref | Priority |
|---|---|---|---|---|
| **REQ-HW-001** | RF Input Frequency Range | Test | TC-RF-001 | Must have |
| **REQ-HW-004** | Gain Control Range | Test | TC-RF-004 | Must have |
| **REQ-HW-014** | Frequency Agility and Tuning Speed | Test | TC-RF-005 | Should have |
| **REQ-HW-002** | Noise Figure Performance | Test | TC-RF-002 | Must have |
| **REQ-HW-003** | Spurious-Free Dynamic Range | Test | TC-RF-003 | Must have |
| **REQ-HW-006** | ADC Sampling Rate | Test | TC-RF-006 | Must have |
| **REQ-HW-007** | Phase Noise Performance | Test | TC-RF-005 | Must have |
| **REQ-HW-008** | Linearity and Intercept Points | Test | TC-RF-003 | Must have |
| **REQ-HW-013** | Input Return Loss | Test | TC-RF-001 | Must have |
| **REQ-HW-005** | JESD204B/C Output Interface | Test | TC-RF-006 | Must have |
| **REQ-HW-012** | Control Interface | Test | TC-RF-006 | Must have |
| **REQ-HW-009** | Operating Temperature Range | Test & Analysis | TC-ENV-001, Thermal Analysis | Must have |
| **REQ-HW-015** | Vibration and Shock Requirements | Test | TC-ENV-002 | Should have |
| **REQ-HW-010** | Power Consumption Budget | Analysis & Test | Power Budget Analysis, TC-RF-001 | Must have |
| **REQ-HW-011** | Form Factor and Mechanical Constraints | Inspection | 5.3.1 | Should have |
| **REQ-HW-016** | EMI/EMC Compliance | Test | TC-EMC-001 | Should have |
| **REQ-HW-017** | Component Sourcing and Lifecycle | Inspection | 5.3.2 | Should have |

---

**Document Status: AI-GENERATED**

# 6. Bill of Materials (Preliminary)

This section details the preliminary Bill of Materials (BOM) for the **khgk** Wideband RF Receiver Module. The components listed below are selected based on the architecture defined in Section 2 and the component recommendations provided in Section 6.

The BOM is categorized by functional circuit block. Unit costs are estimated based on 100-unit quantity pricing for military-grade or screened components where applicable. All costs are in USD.

## 6.1 RF Front End Components (5-18 GHz)

This section comprises the input matching, LNA, and variable gain amplification stages.

| Item No | Ref Des | Part Number | Description | Manufacturer | Qty | Unit Cost | Total Cost | Notes |
|---|---|---|---|---|---|---|---|---|
| 101 | U1 | TGA4943-SM | Wideband GaN MMIC Amplifier, 2-18 GHz, 20dB Gain | Qorvo | 1 | $185.00 | $185.00 | Military Temp, H-Class Screening |
| 102 | U2 | HMC698LP4 | Digital Variable Gain Amplifier, DC-6 GHz, 31dB Range | Analog Devices | 1 | $95.00 | $95.00 | 1 dB Step SPI Control |
| 103 | F1 | 031-2035-000 | 5-18 GHz Bandpass Filter, Tracking Type | Custom/Mini-Circuits | 1 | $120.00 | $120.00 | Assumes distributed element implementation on PCB; Cost is NRE amortized or Module cost |
| 104 | L1, L2 | 0603CS-22NXJW | Wirewound RF Chip Inductor, 22 nH | Coilcraft | 2 | $1.50 | $3.00 | High Q RF choke |
| 105 | C1-C4 | 0603HP-5C6D101 | RF Capacitor, 100 pF, C0G / NP0 | AVX | 4 | $0.85 | $3.40 | Low loss RF coupling |
| 106 | R1-R4 | 0603AF-1001T | Thin Film Resistor, 1 kΩ | Vishay | 4 | $0.25 | $1.00 | Bias resistor |
| **Total** | | | | | | | **$407.40** | **RF Front End Subtotal** |

## 6.2 Frequency Conversion & LO Synthesis

This section includes the I/Q Mixer and the wideband synthesizer required for downconversion.

| Item No | Ref Des | Part Number | Description | Manufacturer | Qty | Unit Cost | Total Cost | Notes |
|---|---|---|---|---|---|---|---|---|
| 201 | U3 | HMC525LC4 | Wideband I/Q Mixer, 6-18 GHz | Analog Devices | 1 | $145.00 | $145.00 | High linearity active mixer |
| 202 | U4 | LMX2594RHAT | Wideband PLL/VCO Synthesizer, 20 GHz | Texas Instruments | 1 | $65.00 | $65.00 | Ultra-low phase noise |
| 203 | U5 | HMC361S8G16 | RF LO Amplifier, 6-20 GHz | Analog Devices | 1 | $45.00 | $45.00 | 15dB Gain drive for Mixer |
| 204 | L3-L6 | 0402HP-1N5XJL | RF Chip Inductor, 1.5 nH | Coilcraft | 4 | $1.20 | $4.80 | LO matching network |
| 205 | T1 | EQJK-630+ | 180-degree Hybrid Coupler, 5-18 GHz | Mini-Circuits | 1 | $60.00 | $60.00 | Required for I/Q generation from single LO |
| **Total** | | | | | | | **$319.80** | **Conversion Subtotal** |

## 6.3 IF Amplification & Anti-Aliasing

Components for the Intermediate Frequency chain prior to digitization.

| Item No | Ref Des | Part Number | Description | Manufacturer | Qty | Unit Cost | Total Cost | Notes |
|---|---|---|---|---|---|---|---|---|
| 301 | U6 | TRF37C75 | Dual IF Differential Amplifier, 4.5 GHz BW | Texas Instruments | 1 | $22.00 | $22.00 | 50 Ohm differential drive |
| 302 | L7, L8 | 0603CS-8N2XJL | RF Chip Inductor, 8.2 nH | Coilcraft | 2 | $1.50 | $3.00 | Bias chokes |
| 303 | C5-C8 | 0402YC104KAT2A | Capacitor, 0.1 µF, X7R | AVX | 4 | $0.15 | $0.60 | Supply decoupling |
| 304 | F2 | RFB-680+ | Low Pass Filter, 500 MHz Cutoff | Mini-Circuits | 1 | $35.00 | $35.00 | Anti-aliasing filter |
| **Total** | | | | | | | **$60.60** | **IF Chain Subtotal** |

## 6.4 Digital Conversion & Interface

The high-speed ADC and associated clocking components.

| Item No | Ref Des | Part Number | Description | Manufacturer | Qty | Unit Cost | Total Cost | Notes |
|---|---|---|---|---|---|---|---|---|
| 401 | U7 | ADC12DJ3200QML | 12-bit, 6.4 GSPS JESD204C ADC | Texas Instruments | 1 | $850.00 | $850.00 | Dual channel, JESD204B/C, Ceramic Package |
| 402 | Y1 | CVHD-950-100.0 | Crystal Oscillator, 100 MHz, Ultra-Low Phase Noise | Crystek | 1 | $125.00 | $125.00 | PLL Reference Clock |
| 403 | R5-R8 | ERJ-2RKF1001X | Thin Film Resistor, 1 kΩ | Panasonic | 8 | $0.20 | $1.60 | Input termination |
| **Total** | | | | | | | **$976.60** | **Digital Subtotal** |

## 6.5 Power Management

Multi-rail power supply generation and sequencing.

| Item No | Ref Des | Part Number | Description | Manufacturer | Qty | Unit Cost | Total Cost | Notes |
|---|---|---|---|---|---|---|---|---|
| 501 | U8 | LTM4644IY#PBF | Quad 4A DC/DC Silent Switcher Module | Analog Devices | 1 | $45.00 | $45.00 | 5V and 3.3V rail generation |
| 502 | U9 | LT3045IY#PBF | 500mA Low Noise LDO | Analog Devices | 2 | $12.00 | $24.00 | Clean 1.8V rail for VCO/PLL |
| 503 | U10 | ADM1266-1ARQZ | Super Sequencer & Margin Controller | Analog Devices | 1 | $18.00 | $18.00 | Power supply monitoring/sequencing |
| 504 | F3 | 0436003.DR | Fuse, PTC Resettable, 2A Hold | Bourns | 1 | $1.50 | $1.50 | Input protection |
| 505 | C9-C15 | TPSD226K020R0100 | Tantalum Capacitor, 22 µF, 20V | AVX | 7 | $2.50 | $17.50 | Bulk input capacitance |
| **Total** | | | | | | | **$106.00** | **Power Subtotal** |

## 6.6 Control & Mechanical

Microcontroller, connectors, and PCB assembly.

| Item No | Ref Des | Part Number | Description | Manufacturer | Qty | Unit Cost | Total Cost | Notes |
|---|---|---|---|---|---|---|---|---|
| 601 | U11 | ATSAMC21J18A-MUT | ARM Cortex-M0+ MCU | Microchip | 1 | $8.50 | $8.50 | System control SPI master |
| 602 | J1 | 142-0701-851 | SMA Connector, Edge Mount, Flange | TE Connectivity | 1 | $12.00 | $12.00 | RF Input Port |
| 603 | J2 | JSD-SR-2-4-20-L-M | 20-Position Micro-D Connector, Shielded | ITT Cannon | 1 | $45.00 | $45.00 | Power/Control/Data I/O |
| 604 | J3 | 87710-2414 | Board-to-Board Mezzanine Header | Molex | 1 | $6.00 | $6.00 | Optional expansion interface |
| 605 | PCB | ASSY-12080-RG885 | 6-Layer Rogers PCB, Gold Plated | Advanced Circuits | 1 | $150.00 | $150.00 | 120mm x 80mm, 0.008" RO4350B |
| 606 | SH1 | HEATSINK-119 | Aluminum Heat Spreader, Custom | Custom | 1 | $25.00 | $25.00 | Thermal management |
| **Total** | | | | | | | **$246.50** | **Control/Mech Subtotal** |

## 6.7 Total System Cost Summary

The following table summarizes the cost of goods sold (COGS) for the module at the prototype level (100-unit pricing).

| Category | Total Cost (USD) | % of Total BOM |
| :--- | :--- | :--- |
| RF Front End | $407.40 | 17% |
| Frequency Conversion | $319.80 | 13% |
| IF Chain | $60.60 | 3% |
| Digital Conversion | $976.60 | 40% |
| Power Management | $106.00 | 4% |
| Control / Mechanical | $246.50 | 10% |
| **Miscellaneous (Passives/Assembly)** | $350.00* | 13% |
| **GRAND TOTAL** | **$2,466.90** | **100%** |

*\*Note: Miscellaneous includes additional passives (R, L, C) not individually listed, conformal coating application, wire, and assembly labor. Actual unit cost may vary based on volume and supplier availability.*

---

# 7. Traceability Matrix

**Document Status: AI-GENERATED**

## 7.1 Requirement Traceability Matrix (RTM)

This section establishes the traceability of the system requirements defined in Section 3. It maps each requirement ID to its source, the allocated verification method, the implementation phase, and its current status.

| REQ-ID | Requirement Summary | Source Document | Verification Method | Phase | Status |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **REQ-HW-001** | RF Input Frequency Range (5.0–18.0 GHz) | System Spec | Test: RF Sweep / Network Analysis | Phase 1 | Allocated |
| **REQ-HW-002** | Noise Figure Performance (≤ 6.0 dB) | System Spec | Test: Y-Factor / Noise Figure Meter | Phase 1 | Allocated |
| **REQ-HW-003** | Spurious-Free Dynamic Range (≥ 60 dB) | System Spec | Test: FFT Spectrum Analysis (Single Tone) | Phase 1 | Allocated |
| **REQ-HW-004** | Gain Control Range (0–60 dB) | System Spec | Test: Gain Steps / Power Meter | Phase 1 | Allocated |
| **REQ-HW-005** | JESD204B/C Output Interface (≤ 12.5 Gbps) | Interface Spec | Test: Bit Error Rate (BER) / Eye Diagram | Phase 2 | Allocated |
| **REQ-HW-006** | ADC Sampling Rate (≥ 1.0 GSPS) | System Spec | Test: Digital Sampling Capture | Phase 1 | Allocated |
| **REQ-HW-007** | Phase Noise Performance (< -80 dBc/Hz) | System Spec | Test: Phase Noise Analyzer | Phase 1 | Allocated |
| **REQ-HW-008** | Linearity and Intercept Points (IIP3 ≥ +10) | System Spec | Test: Two-Tone Intermodulation | Phase 1 | Allocated |
| **REQ-HW-009** | Operating Temperature Range (-55 to +125°C) | Env. Spec | Test: Environmental Chamber (Temp Cycle) | Phase 2 | Allocated |
| **REQ-HW-010** | Power Consumption Budget (≤ 30W) | System Spec | Test: Power Rail Measurement / DMM | Phase 1 | Allocated |
| **REQ-HW-011** | Form Factor (120mm x 80mm x 15mm) | Mech. Spec | Inspection: Mechanical CAD Review | Phase 1 | Allocated |
| **REQ-HW-012** | Control Interface (SPI/I2C) | Interface Spec | Test: Protocol Analyzer / Loopback | Phase 1 | Allocated |
| **REQ-HW-013** | Input Return Loss (≤ -10 dB) | System Spec | Test: Vector Network Analyzer (VNA) | Phase 1 | Allocated |
| **REQ-HW-014** | Frequency Agility and Tuning Speed (< 5 µs) | System Spec | Test: Hop Speed / Time Domain Reflect | Phase 1 | Allocated |
| **REQ-HW-015** | Vibration and Shock (MIL-STD-810G) | Env. Spec | Test: Shake Table / Shock Machine | Phase 3 | Allocated |
| **REQ-HW-016** | EMI/EMC Compliance (MIL-STD-461G) | Env. Spec | Test: Anechoic Chamber / EMI Scan | Phase 3 | Allocated |
| **REQ-HW-017** | Component Sourcing (10-year lifecycle) | Supply Chain | Inspection: BOM Audit / Mfg Review | Phase 1 | Allocated |
| **REQ-HW-101** | LNA Gain Stage (TGA4943-SM, ~20 dB) | Design Arch. | Analysis: S-Parameter Simulation | Phase 1 | Derived |
| **REQ-HW-102** | LNA Noise Figure Contribution (≤ 3.5 dB) | Design Arch. | Analysis: Cascade Budget Calc | Phase 1 | Derived |
| **REQ-HW-103** | DVGA Gain Range (HMC698LP4, -6 to +25 dB) | Design Arch. | Test: SPI Gain Step Response | Phase 1 | Derived |
| **REQ-HW-104** | DVGA Settling Time (< 1 µs) | Design Arch. | Test: Oscilloscope Capture | Phase 1 | Derived |
| **REQ-HW-105** | RF Bandpass Filter Rejection (>20 dB) | Design Arch. | Test: VNA Sweep | Phase 1 | Derived |
| **REQ-HW-106** | Mixer Conversion Loss/Gain (HMC525LC4) | Design Arch. | Test: RF/IF Power Measurement | Phase 1 | Derived |
| **REQ-HW-107** | Synthesizer Lock Time (LMX2594, < 5 µs) | Design Arch. | Test: PLL Lock Detect / Scope | Phase 1 | Derived |
| **REQ-HW-108** | LO Drive Level (Mixer Input Req.) | Design Arch. | Analysis: Power Budget Calculation | Phase 1 | Derived |
| **REQ-HW-109** | IF Amplifier Bandwidth (DC - 1.5 GHz) | Design Arch. | Test: Frequency Response Sweep | Phase 1 | Derived |
| **REQ-HW-110** | Anti-Alias Filter Cutoff (~500 MHz) | Design Arch. | Test: Bandpass Insertion Loss | Phase 1 | Derived |
| **REQ-HW-111** | ADC Input Resolution (12-bit, ADC12DJ3200) | Design Arch. | Test: ENOB Analysis | Phase 2 | Derived |
| **REQ-HW-112** | JESD204B/C Lane Rate (6.25 - 12.5 Gbps) | Design Arch. | Test: Link Training / Protocol Check | Phase 2 | Derived |
| **REQ-HW-113** | Clock Management (SYSREF Deterministic Latency) | Design Arch. | Test: Latency Measurement | Phase 2 | Derived |
| **REQ-HW-114** | Main Input Voltage (12-15V DC) | Design Arch. | Test: Input Range Margin | Phase 1 | Derived |
| **REQ-HW-115** | Power Sequencing (UVLO, OCP) | Design Arch. | Test: Power Up/Down Sequence | Phase 1 | Derived |
| **REQ-HW-116** | Input Connector Type (SMA/SMP) | Design Arch. | Inspection: Mechanical Drawing | Phase 1 | Derived |
| **REQ-HW-117** | PCB Material (High Frequency, Low Loss) | Design Arch. | Analysis: Insertion Loss Sim | Phase 1 | Derived |
| **REQ-HW-118** | Conformal Coating (Env. Protection) | Design Arch. | Inspection: Visual / Thickness | Phase 2 | Derived |

## 7.2 Verification Methods Summary

The following table summarizes the distribution of verification methods defined in the Traceability Matrix. This distribution ensures a balanced approach of testing, analysis, and inspection to validate requirements.

| Verification Method | Count | Percentage |
| :--- | :---: | :---: |
| **Test** | 22 | 73.3% |
| **Analysis** | 5 | 16.7% |
| **Inspection** | 3 | 10.0% |
| **Total** | **30** | **100%** |

## 7.3 Traceability Notes

1.  **Test (T):** Denotes requirements that must be validated by physical measurement on the prototype or production unit (e.g., RF gain, Noise Figure, Power Consumption).
2.  **Analysis (A):** Denotes requirements validated through engineering calculations, simulations, or derived specifications (e.g., power budgeting, cascade analysis, material properties).
3.  **Inspection (I):** Denotes requirements validated by visual review, design rule checks (DRC), or audit (e.g., form factor, component sourcing, conformal coating).
4.  **Status Allocated:** Indicates the requirement has been baselined for Phase 1 development. Requirements allocated to Phase 3 (e.g., Shock/Vibe) are scheduled for qualification testing later in the lifecycle.

***

**End of Document**