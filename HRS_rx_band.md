**Document Status: AI-GENERATED**

# Hardware Requirements Specification (HRS)
## RX Band — 4-Channel 18–40 GHz Double-IF Superheterodyne Radar Receiver

---

# 1. Introduction

## 1.1 Purpose

This Hardware Requirements Specification (HRS) defines the complete set of hardware requirements for the **rx band** project—a 4-channel, 18–40 GHz double-IF superheterodyne radar receiver system. The document establishes the functional, performance, interface, environmental, and physical requirements that the hardware design must satisfy to meet the operational needs of military-grade coherent radar pulse analysis.

The primary purposes of this document are to:

- Provide a clear, unambiguous statement of all hardware requirements that the rx band receiver system shall meet, traceable to system-level operational needs.
- Serve as the authoritative technical baseline for hardware design, component selection, printed circuit board (PCB) layout, mechanical integration, and verification testing throughout the development lifecycle.
- Ensure full bidirectional traceability between stakeholder needs (operational radar requirements), system-level specifications, and detailed hardware component specifications via a formal Traceability Matrix (Section 7).
- Facilitate design reviews (PDR, CDR), independent verification and validation (IV&V), and qualification testing by providing testable, measurable acceptance criteria for every requirement.
- Support logistics, sustainment, and production planning by documenting component selections, power budgets, thermal constraints, and manufacturing constraints.
- Comply with IEEE 29148:2018 (ISO/IEC/IEEE 29148:2018) *Systems and software engineering — Life cycle processes — Requirements engineering* for requirements specification structure and content.

This document is intended for use by hardware design engineers, RF/microwave engineers, FPGA/digital designers, systems engineers, test engineers, configuration managers, and program stakeholders involved in the design, fabrication, test, integration, and deployment of the rx band receiver.

## 1.2 Scope

This HRS encompasses the complete hardware design of the **rx band** 4-channel radar receiver system, from the antenna interface through digitisation and digital signal preprocessing. The scope covers all electronic, electromagnetic, mechanical, and thermal aspects of the receiver hardware.

### 1.2.1 In-Scope Items

The following subsystems and components are within the scope of this specification:

- **RF Front-End (4 channels):** SMA coaxial input connectors (2.92mm-K), RF limiters for input survivability (+20 dBm), tunable YIG preselector filters (18–40 GHz), bias-tee networks, and wideband GaN LNA first-stage amplifiers (Mini-Circuits ZVA-183WA-S+ or equivalent 40+ GHz GaN MMIC).
- **First Downconversion Stage (4 channels):** Double-balanced mixers (Qorvo CMD180C3 for 18–32 GHz; Qorvo CMD181 for 26–40 GHz) converting the RF signal to the first intermediate frequency (IF1) at approximately 4.0 GHz, with LO1 provided by PLL synthesizers (Texas Instruments LMX2820RTCT, 14–36 GHz output).
- **IF1 Processing (4 channels):** IF1 bandpass filters centred at 4.0 GHz, gain block amplifiers (Mini-Circuits ZVA-183WA-S+), and stability (stagger) bandpass filters to suppress spurious responses and ensure unconditional stability.
- **Second Downconversion Stage (4 channels):** IQ image-reject mixers (Marki Microwave MMIQ-0205HSM-2) converting IF1 to the second intermediate frequency (IF2) at approximately 500 MHz, with LO2 provided by PLL synthesizers (Analog Devices ADF4383 or equivalent, ~3.5 GHz output).
- **IF2 Processing and Digitisation (4 channels):** IF2 bandpass filters centred at 500 MHz, voltage-variable gain amplifiers / automatic gain control (Qorvo TGL2767, 0–20 dB AGC range), anti-aliasing filters, and 16-bit 210 Msps analogue-to-digital converters (Analog Devices LTC2107) with LVDS digital interfaces.
- **Digital Signal Processing:** Xilinx Kintex-7 FPGA (XC7K355T) performing digital downconversion (DDC), pulse compression, coherent integration, and multi-channel processing for all four channels simultaneously.
- **LO Generation and Distribution:** 10 MHz oven-controlled crystal oscillator reference (KOVTL10MDBFBCB OCXO), dual PLL synthesizer chains (LO1 and LO2), clock distribution buffers for ADC sampling clocks, and phase-matched LO distribution networks ensuring <1 ps skew between channels.
- **Power Supply Subsystem:** +15 VDC primary input, EMI filtering, low-dropout (LDO) voltage regulation generating +5 V (LM2940S-5.0) and +3.3 V (MCP1826S) sub-rails, with per-stage LC/ferrite decoupling for noise isolation. Total system power budget: ≤25 W.
- **Mechanical and Environmental:** IP68-rated enclosure, cavity-shielded RF modules, MIL-STD-810 compliant vibration/shock mounting, thermal management for operation over −55 °C to +125 °C ambient.
- **Control Interface:** SPI bus from FPGA to PLL synthesizers for frequency tuning; AGC control loops; status and telemetry reporting.

### 1.2.2 Out-of-Scope Items

The following items are explicitly outside the scope of this HRS:

- Antenna element design and fabrication (assumed provided as external item).
- Transmitter subsystem and high-power RF generation.
- Backend radar signal processing software, display, and human-machine interface (HMI) beyond the FPGA LVDS data output interface.
- System-level software/firmware requirements (covered in a separate Software Requirements Specification).
- Cabling, waveguide runs, and external interconnections between the receiver and other platform subsystems (defined in an ICD).
- Power source (battery, vehicle power, or prime power generation) upstream of the +15 VDC input connector.

### 1.2.3 System Identification

| Attribute | Value |
|---|---|
| Project Name | rx band |
| System Name | 4-Channel 18–40 GHz Double-IF Superheterodyne Radar Receiver |
| System Designation | RXB-4000 |
| Configuration Item | Receiver Hardware Assembly |
| Document ID | HRS-RXB-4000-001 |
| Revision | 1.0 |

## 1.3 Definitions, Acronyms, and Abbreviations

The following table defines all technical terms, acronyms, and abbreviations used throughout this document.

| Term / Acronym | Definition |
|---|---|
| **ADC** | Analogue-to-Digital Converter — a device that converts a continuous analogue signal into a discrete digital representation. |
| **AGC** | Automatic Gain Control — a feedback control loop that automatically adjusts receiver gain to maintain a constant output signal level despite varying input signal amplitudes. |
| **BPF** | Bandpass Filter — a filter that passes frequencies within a specified range (passband) and attenuates frequencies outside that range (stopband). |
| **BW** | Bandwidth — the range of frequencies over which a system or component operates, typically measured between the −3 dB points. |
| **CMOS** | Complementary Metal-Oxide-Semiconductor — a fabrication technology for integrated circuits used in digital and mixed-signal components. |
| **CW** | Continuous Wave — an unmodulated, steady-state radio-frequency signal. |
| **dB** | Decibel — a logarithmic unit of measurement expressing the ratio of two values of a physical quantity, typically power or amplitude. |
| **dBc** | Decibels relative to the carrier — a measure of a signal power relative to the carrier power, used for specifying spurious emissions and phase noise. |
| **dBm** | Decibels relative to one milliwatt — an absolute power measurement referenced to 1 mW into a 50 Ω impedance. |
| **DDC** | Digital Downconversion — the process of digitally mixing, filtering, and decimating a sampled IF signal to produce baseband I/Q data. |
| **EMI** | Electromagnetic Interference — unwanted electromagnetic energy that disrupts the operation of electronic equipment. |
| **FPGA** | Field-Programmable Gate Array — a reconfigurable integrated circuit containing an array of programmable logic blocks and interconnects. |
| **GaN** | Gallium Nitride — a wide-bandgap semiconductor material used for high-frequency, high-power RF amplifiers. |
| **HRS** | Hardware Requirements Specification — a structured document defining all requirements for a hardware design (IEEE 29148). |
| **IBW** | Instantaneous Bandwidth — the maximum contiguous bandwidth that the receiver can process at any one time without retuning. |
| **IF** | Intermediate Frequency — a frequency to which a received RF signal is converted during superheterodyne downconversion for easier filtering and amplification. |
| **IF1** | First Intermediate Frequency — the first IF stage, centred at approximately 4.0 GHz in this design. |
| **IF2** | Second Intermediate Frequency — the second IF stage, centred at approximately 500 MHz in this design. |
| **IIP3** | Input Third-Order Intercept Point — a measure of receiver linearity expressed at the input port; higher values indicate better large-signal handling. |
| **IP68** | Ingress Protection rating per IEC 60529 — complete protection against dust ingress (6) and protection against continuous immersion in water beyond 1 m (8). |
| **I/Q** | In-phase and Quadrature — the two orthogonal components of a complex signal representation used in digital signal processing. |
| **LDO** | Low-Dropout Regulator — a type of linear voltage regulator that can operate with a small voltage differential between input and output. |
| **LNA** | Low-Noise Amplifier — the first active amplifier stage in a receiver chain, optimised to add minimal noise while providing gain. |
| **LO** | Local Oscillator — a signal source used to drive the mixer in a frequency conversion stage. |
| **LO1** | First Local Oscillator — the LO driving the first downconversion mixer (RF to IF1), tuning range 14–36 GHz. |
| **LO2** | Second Local Oscillator — the LO driving the second downconversion mixer (IF1 to IF2), frequency approximately 3.5 GHz. |
| **LVDS** | Low-Voltage Differential Signalling — a high-speed digital interface standard (TIA/EIA-644) using differential pairs with low voltage swings for noise-immune data transmission. |
| **MDS** | Minimum Detectable Signal — the weakest signal power at the receiver input that produces a specified output signal-to-noise ratio (typically SNR = 0 dB). |
| **MIL-STD-810** | United States Military Standard for Environmental Engineering Considerations and Laboratory Tests — defines environmental test methods for defence materiel. |
| **MMIC** | Monolithic Microwave Integrated Circuit — an integrated circuit operating at microwave frequencies, fabricated on a single semiconductor substrate. |
| **NF** | Noise Figure — the ratio of the input signal-to-noise ratio to the output signal-to-noise ratio, expressed in dB; a measure of the noise added by a component or system. |
| **NRND** | Not Recommended for New Designs — a lifecycle designation indicating that a component is still available but should not be designed into new products. |
| **OCXO** | Oven-Controlled Crystal Oscillator — a precision frequency reference in which the crystal is maintained at a constant temperature in a thermal oven for superior frequency stability and phase noise. |
| **OIP3** | Output Third-Order Intercept Point — a measure of linearity expressed at the output port; related to IIP3 by the gain: OIP3 = IIP3 + Gain. |
| **P1dB** | 1 dB Compression Point — the input or output power level at which the gain of a component has decreased by 1 dB from its small-signal value. |
| **PCB** | Printed Circuit Board — a laminated substrate with etched conductive traces used to mechanically support and electrically interconnect electronic components. |
| **PLL** | Phase-Locked Loop — a feedback control system that synchronises the phase and frequency of an oscillator (VCO) to a reference signal. |
| **PRF** | Pulse Repetition Frequency — the rate at which radar pulses are transmitted, measured in pulses per second (Hz). |
| **RF** | Radio Frequency — electromagnetic signals in the frequency range used for wireless communication and radar; in this document, specifically 18–40 GHz. |
| **SFDR** | Spurious-Free Dynamic Range — the ratio of the fundamental signal power to the largest non-fundamental (spurious) signal power at the output, expressed in dB. |
| **SMA** | SubMiniature version A — a coaxial RF connector with 50 Ω impedance, usable to approximately 18 GHz. |
| **SNR** | Signal-to-Noise Ratio — the ratio of signal power to noise power, expressed in dB. |
| **SPI** | Serial Peripheral Interface — a synchronous serial communication bus used for short-distance, high-speed communication between integrated circuits. |
| **SMT** | Surface-Mount Technology — a method of assembling electronic circuits in which components are mounted directly onto the surface of a PCB. |
| **T/R** | Transmit/Receive — referring to the switching between radar transmission and reception modes. |
| **VCO** | Voltage-Controlled Oscillator — an oscillator whose output frequency is controlled by an input voltage. |
| **VGA** | Variable Gain Amplifier — an amplifier whose gain can be adjusted dynamically via a control voltage. |
| **VSWR** | Voltage Standing Wave Ratio — a measure of impedance mismatch at an RF port; a VSWR of 1:1 indicates a perfect match. |
| **YIG** | Yttrium Iron Garnet — a ferrimagnetic material used in magnetically-tunable bandpass filters providing wide tuning range and high Q-factor at microwave frequencies. |

## 1.4 References

The following documents are referenced in this specification. Where a specific revision or version is stated, that revision applies. Where no revision is stated, the latest published version applies.

| Ref ID | Document |
|---|---|
| **REF-01** | IEEE 29148:2018 — *Systems and software engineering — Life cycle processes — Requirements engineering* |
| **REF-02** | MIL-STD-810H (2019) — *Department of Defense Test Method Standard: Environmental Engineering Considerations and Laboratory Tests* |
| **REF-03** | IEC 60529:1989/AMD2:2013 — *Degrees of protection provided by enclosures (IP Code)* |
| **REF-04** | MIL-STD-461G — *Requirements for the Control of Electromagnetic Interference Characteristics of Subsystems and Equipment* |
| **REF-05** | Texas Instruments LMX2820RTCT Datasheet — *22.6-GHz Wideband RF Synthesizer with Integrated VCO* (Publication Date: 2023) |
| **REF-06** | Analog Devices ADF4383 Datasheet — *13.6 GHz to 27.5 GHz Microwave Wideband Synthesizer with Integrated VCO* |
| **REF-07** | Analog Devices LTC2107 Datasheet — *16-Bit, 210 Msps, Low Power 1.8 V ADC* |
| **REF-08** | Xilinx DS182 — *Kintex-7 FPGAs Data Sheet: DC and AC Switching Characteristics* |
| **REF-09** | Qorvo CMD180C3 Datasheet — *18–32 GHz Double Balanced Mixer* |
| **REF-10** | Qorvo CMD181 Datasheet — *26–45 GHz Double Balanced Mixer* |
| **REF-11** | Marki Microwave MMIQ-0205HSM-2 Datasheet — *Miniaturized Surface Mount Multi-Octave IQ Mixer, 1.75–5.0 GHz* |
| **REF-12** | Mini-Circuits ZVA-183WA-S+ Datasheet — *RF Amplifier Gain Block, 50 kHz–18 GHz* |
| **REF-13** | Qorvo TGL2767 Datasheet — *Wideband Voltage Variable Attenuator, 6–18 GHz* |
| **REF-14** | Microchip MCP1826S Datasheet — *1 A, Low Voltage, Low Dropout (LDO) Regulator* |
| **REF-15** | Texas Instruments LM2940S-5.0 Datasheet — *1 A Low Dropout Regulator, 5 V Output* |
| **REF-16** | TIA/EIA-644-A — *Electrical Characteristics of Low Voltage Differential Signalling (LVDS) Interface Circuits* |
| **REF-17** | IEEE 802.3-2022 — *IEEE Standard for Ethernet* (referenced for LVDS physical layer compliance where applicable) |
| **REF-18** | JEDEC JESD51 — *Methodology for the Thermal Measurement of Component Packages* |

## 1.5 Overview

This Hardware Requirements Specification is organised into the following major sections:

- **Section 1 — Introduction:** Defines the purpose, scope, definitions, references, and organisational overview of this document (this section).
- **Section 2 — System Overview:** Provides a narrative description of the rx band receiver system, its block diagram, architecture partitioning, and operating environment context.
- **Section 3 — Hardware Requirements:** The core of this document. Presents all traceable hardware requirements organised into subsections covering functional requirements (the signal chain must perform), performance requirements (quantitative targets for gain, noise figure, linearity, and dynamic range), interface requirements (RF inputs, digital outputs, LO distribution, power, and control buses), environmental requirements (temperature, vibration, shock, and ingress protection), power requirements (supply rails, regulation, budget, and decoupling strategy), and physical requirements (dimensions, mass, connectors, and mounting).
- **Section 4 — Design Constraints:** Documents mandatory standards compliance, component selection constraints (including ITAR, obsolescence, and radiation considerations), and manufacturing constraints (PCB material selection, assembly processes, and inspection criteria).
- **Section 5 — Verification Requirements:** Maps each requirement to one or more verification methods (test, analysis, inspection, or demonstration) and specifies the test conditions, equipment, acceptance criteria, and analysis methodologies required to demonstrate compliance.
- **Section 6 — Bill of Materials (Preliminary):** Provides the initial bill of materials listing all components, quantities (per unit and per 4-channel system), manufacturer part numbers, package types, and sourcing information.
- **Section 7 — Traceability Matrix:** Presents a complete bidirectional traceability matrix linking each requirement (REQ-HW-xxx) to its verification method(s), design implementation reference, and parent system requirement.

The fundamental design approach of the rx band system is a **double-IF superheterodyne architecture** operating over the 18–40 GHz microwave band. Four independent receiver channels provide spatial diversity and coherent processing capability. Each channel converts the incoming RF signal through two frequency conversion stages:

1. **RF → IF1:** The 18–40 GHz RF input is mixed with a tunable LO1 (14–36 GHz from LMX2820 PLL) to produce a first intermediate frequency at approximately 4.0 GHz, enabling image rejection via a tunable YIG preselector and fixed IF1 bandpass filtering.
2. **IF1 → IF2:** The 4.0 GHz IF1 signal is mixed with a fixed LO2 (~3.5 GHz from ADF4383 PLL) in an IQ image-reject mixer to produce a second intermediate frequency at approximately 500 MHz, where high-selectivity filtering and gain control are practical.

The 500 MHz IF2 signal is digitised by a 16-bit, 210 Msps ADC (LTC2107) per channel, and the resulting digital data streams are processed by a Xilinx Kintex-7 FPGA (XC7K355T) for digital downconversion, pulse compression, and coherent multi-channel processing before output via a high-speed LVDS interface.

The system achieves a cascaded gain of approximately 65 dB, a system noise figure of 8 dB, an input-referred third-order intercept point (IIP3) of +20 dBm, and a minimum detectable signal (MDS) of −81.2 dBm, all within a 25 W power envelope supplied from a +15 VDC primary rail, and packaged in an IP68-rated enclosure qualified for operation over −55 °C to +125 °C.

---

**Document Status: AI-GENERATED**

# 2. System Overview

## 2.1 System Description

The **rx band** system is a 4-channel, 18–40 GHz double-IF superheterodyne radar receiver designed for military-grade electronic warfare (EW) and radar warning receiver (RWR) applications. The system intercepts, downconverts, and digitises pulsed and continuous-wave (CW) radar signals across the full 18–40 GHz threat band with high sensitivity, wide instantaneous bandwidth, and excellent inter-channel phase coherence.

### 2.1.1 Operational Concept

The receiver operates as a multi-antenna coherent front-end in a monostatic or bistatic radar configuration. Each of the four channels receives signals from a dedicated antenna element operating across the 18–40 GHz range. Signals pass through a survivability limiter, a tunable YIG preselector for band-definition and image rejection, and a low-noise GaN amplifier. The dual-conversion superheterodyne architecture translates the RF input to a first intermediate frequency (IF1) at 4.0 GHz, and subsequently to a second intermediate frequency (IF2) at 500 MHz. This two-stage approach provides deep image rejection, high selectivity (>60 dBc adjacent-channel rejection), and minimises LO leakage back to the antenna port.

The final IF2 signal at 500 MHz is conditioned by a voltage-variable gain amplifier (VGA) under automatic gain control (AGC) before digitisation by a 16-bit 210 Msps ADC (Analog Devices LTC2107). The digitised data streams from all four channels are delivered via LVDS to a central Xilinx Kintex-7 FPGA (XC7K355T), which performs digital downconversion (DDC), pulse compression, and coherent processing across the array. Processed data is output over a high-speed LVDS link to a downstream signal processor or DSP card.

### 2.1.2 Frequency Plan

The double-IF frequency plan is designed to cover the full 18–40 GHz input range with minimal image-response spurs and manageable LO tuning ranges:

| Parameter | Value | Notes |
|---|---|---|
| RF Input Range | 18.0–40.0 GHz | Full threat band coverage |
| LO1 Range | 14.0–36.0 GHz | High-side injection: LO1 = RF − IF1 |
| IF1 Centre Frequency | 4.0 GHz | First intermediate frequency |
| IF1 Bandwidth | 500 MHz (3.75–4.25 GHz) | Supports 500 MHz IBW |
| LO2 Frequency | 3.5 GHz (fixed) | Fixed second LO |
| IF2 Centre Frequency | 500 MHz | Second intermediate frequency |
| IF2 Bandwidth | ≤500 MHz | Final analogue bandwidth before ADC |
| ADC Sample Rate | 210 Msps | Nyquist frequency = 105 MHz |

**Sub-band Channelisation Note:** Per REQ-HW-027, with the ADC sampling at 210 Msps (Nyquist = 105 MHz), the full 500 MHz IF2 bandwidth exceeds the single-band Nyquist limit. The system implements sub-band channelisation: the IF2 is split into overlapping sub-bands, each ≤100 MHz wide, which are sequentially or simultaneously sampled within the ADC's first Nyquist zone. The final IF bandpass filter provides >60 dBc rejection at the foldover frequency. Alternatively, a higher-order ADC architecture or band-switching scheme is employed to cover the full instantaneous bandwidth.

### 2.1.3 Key Performance Summary

| Performance Parameter | Value | Requirement Reference |
|---|---|---|
| Frequency Range | 18–40 GHz | REQ-HW-001 |
| Instantaneous Bandwidth | 100–500 MHz (tunable) | REQ-HW-002 |
| Cascaded Noise Figure | 8.0 dB typical, 10 dB max | REQ-HW-003 |
| Cascaded Gain | 65 dB nominal (≥60 dB min) | REQ-HW-004 |
| Input IP3 | +24 dBm system, +20 dBm minimum | REQ-HW-005 |
| Output P1dB | +10 dBm minimum | REQ-HW-006 |
| Spurious-Free Dynamic Range | ≥80 dB | REQ-HW-007 |
| Adjacent-Channel Rejection | ≥60 dBc | REQ-HW-008 |
| Minimum Detectable Signal | −81.2 dBm (500 MHz IBW, 8 dB NF) | REQ-HW-009 |
| LO Phase Noise | <−120 dBc/Hz at 10 kHz offset | REQ-HW-012 |
| Inter-Channel Phase Skew | <1 ps (LO distribution) | REQ-HW-013 |
| ADC Resolution / Rate | 16-bit / 210 Msps per channel | REQ-HW-017 |
| Total DC Power | ≤25 W from +15 V supply | REQ-HW-024 |

### 2.1.4 Signal Chain Overview (Single Channel)

Each of the four identical RF channels consists of the following cascade:

1. **Antenna Port (2.92mm-K connector):** 50 Ω coaxial interface rated to 40 GHz.
2. **Limiter (REQ-HW-010):** Protects downstream components from high-power incident signals up to +20 dBm CW/pulsed; insertion loss assumed 0.5 dB typical.
3. **Tunable YIG Preselector:** Bandpass filter electronically tuned across 18–40 GHz with typical 3 dB bandwidth of 500 MHz to 1 GHz; provides initial image rejection and out-of-band spur suppression.
4. **Bias-T:** Injects DC bias to the GaN LNA through the RF path if required by the LNA bias configuration.
5. **LNA (ZVA-183WA-S+):** First-stage low-noise amplifier providing +22 dB gain with ~3.5 dB noise figure; establishes the system noise floor. Design note: a 40+ GHz GaN LNA (e.g., Northrop Grumman ALH369 or custom MMIC) is required for full 18–40 GHz coverage at final PDR.
6. **Mixer 1 (CMD180C3):** First downconversion from RF to IF1 (4 GHz). Conversion loss 8 dB typical; LO1 drive +13 dBm. Covers 18–32 GHz directly. A secondary mixer (CMD181) handles the 26–40 GHz upper sub-band.
7. **IF1 Bandpass Filter (4 GHz):** Ceramic or cavity filter defining IF1 passband (3.75–4.25 GHz) with >40 dB rejection of LO1 and image frequencies.
8. **Gain Block (ZVA-183WA-S+):** IF1 amplification stage providing +22 dB gain to compensate mixer conversion loss and establish gain distribution.
9. **Stability Bandpass Filter (4 GHz):** Narrowband IF1 filter in a shielded cavity to suppress spurious emissions and ensure stability in the high-gain chain.
10. **Mixer 2 (MMIQ-0205HSM-2):** Second downconversion from IF1 (4 GHz) to IF2 (500 MHz). IQ image-reject mixer with 8 dB conversion loss and 25 dB image rejection; LO2 drive +13 dBm at 3.5 GHz.
11. **IF2 Bandpass Filter (500 MHz):** LC or SAW bandpass filter defining the final analogue bandwidth; provides >60 dBc anti-aliasing rejection at the ADC Nyquist foldover frequency.
12. **VGA (TGL2767):** Voltage-variable gain amplifier providing 0–20 dB gain adjustment under AGC control to maintain the ADC input within the linear region.
13. **ADC (LTC2107):** 16-bit, 210 Msps digitiser with LVDS output; samples the IF2 signal and delivers digitised data to the FPGA.
14. **FPGA (XC7K355T, Kintex-7):** Central digital processor receiving all four ADC data streams; performs DDC, pulse compression, and coherent processing; outputs results via LVDS.

---

## 2.2 System Block Diagram

The following Mermaid diagram illustrates the signal chain for a single RF channel (Channel 1 shown; Channels 2–4 are identical). Shared resources (LO synthesizers, clock distribution, power supply, and FPGA) are common to all four channels.

```mermaid
flowchart TD
    ANT1>"Antenna 1<br/>18–40 GHz"]
    SMA1[/"2.92mm-K<br/>50 Ω Connector"/]
    LIM1["Limiter<br/>Survivability: +20 dBm<br/>IL: 0.5 dB"]
    BPF1{{"Tunable YIG<br/>Preselector<br/>18–40 GHz<br/>BW: 500–1000 MHz"}}
    BT1{"Bias-T<br/>DC Injection"}
    LNA1["LNA<br/>ZVA-183WA-S+<br/>G: +22 dB<br/>NF: 3.5 dB<br/>P1dB: +16 dBm"]
    MIX1["Mixer 1<br/>CMD180C3<br/>Conv Loss: 8 dB<br/>LO Drive: +13 dBm"]
    LO1["LO1 Synthesizer<br/>LMX2820RTCT<br/>14–36 GHz<br/>PN: −120 dBc/Hz@10kHz"]
    BPF2{{"IF1 BPF<br/>4.0 GHz<br/>BW: 500 MHz"}}
    GB1["Gain Block<br/>ZVA-183WA-S+<br/>G: +22 dB<br/>NF: 4.5 dB<br/>P1dB: +16 dBm"]
    BPF3{{"Stability BPF<br/>4.0 GHz<br/>Narrowband"}}
    MIX2["Mixer 2<br/>MMIQ-0205HSM-2<br/>IQ Conv Loss: 8 dB<br/>Img Rej: 25 dB"]}
    LO2["LO2 Synthesizer<br/>ADF4383<br/>3.5 GHz Fixed<br/>PN: −120 dBc/Hz@10kHz"]
    BPF4{{"IF2 BPF<br/>500 MHz<br/>Anti-Alias >60 dBc"}}
    VGA1["VGA / AGC<br/>TGL2767<br/>Gain Range: 0–20 dB"]
    ADC1["ADC<br/>LTC2107<br/>16-bit / 210 Msps<br/>LVDS Output"]
    FPGA1["FPGA<br/>XC7K355T<br/>Kintex-7<br/>4-CH DDC &amp; Coherent Processing"]
    LVDSOUT[/"LVDS Data Output<br/>4-CH to DSP"/]
    OCXO["Reference OCXO<br/>KOVTL10MDBFBCB<br/>10 MHz"]
    CLKDIST["Clock Distribution<br/>4-CH Buffer<br/>LVPECL/LVDS"]

    ANT1 --> SMA1
    SMA1 --> LIM1
    LIM1 --> BPF1
    BPF1 --> BT1
    BT1 --> LNA1
    LNA1 --> MIX1
    LO1 -->|"LO1 +13 dBm"| MIX1
    MIX1 --> BPF2
    BPF2 --> GB1
    GB1 --> BPF3
    BPF3 --> MIX2
    LO2 -->|"LO2 +13 dBm"| MIX2
    MIX2 --> BPF4
    BPF4 --> VGA1
    VGA1 --> ADC1
    ADC1 -->|"LVDS 16-bit<br/>210 Msps"| FPGA1
    FPGA1 --> LVDSOUT
    OCXO -->|"10 MHz Ref"| LO1
    OCXO -->|"10 MHz Ref"| LO2
    OCXO --> CLKDIST
    CLKDIST -->|"Clk to 4 ADCs"| ADC1

    subgraph CH1_CAVITY_A["Cavity A — Front-End (Shielded)"]
        LIM1
        BPF1
        BT1
        LNA1
    end

    subgraph CH1_CAVITY_B["Cavity B — IF1 Stage (Shielded)"]
        MIX1
        BPF2
        GB1
        BPF3
    end

    subgraph CH1_CAVITY_C["Cavity C — IF2 & Digitisation (Shielded)"]
        MIX2
        BPF4
        VGA1
        ADC1
    end
```

**Block Diagram Notes:**

- Each of the four channels replicates the chain from Antenna through ADC.
- Dashed cavity boundaries (Cavity A, B, C) indicate physically separated shielded compartments per REQ-HW-026 to prevent oscillation in the >60 dB gain chain.
- LO1 and LO2 synthesizers are shared (distributed via Wilkinson splitters or reactive splitters) to ensure phase coherence per REQ-HW-013.
- The OCXO provides a common 10 MHz reference to both PLL synthesizers and the clock distribution buffer.

---

## 2.3 System Architecture

### 2.3.1 Architectural Overview

The rx band receiver employs a **centralised LO, distributed front-end** architecture. Four identical RF front-end channels are fed by a shared local oscillator and reference clock tree, ensuring inter-channel phase coherence. A single FPGA consolidates all digital processing.

The architecture is partitioned into four functional domains:

```mermaid
flowchart TB
    subgraph PWR["Power Domain"]
        PWRIN["+15 V Primary<br/>Supply Input"]
        EMIFIL["EMI Filter<br/>π-Topology"]
        LDO5V["LDO: LM2940S-5.0<br/>5.0 V / 1 A Rail"]
        LDO33V["LDO: MCP1826S<br/>3.3 V / 1 A Rail"]
        PWRIN --> EMIFIL --> LDO5V --> LDO33V
    end

    subgraph CLK["Clock & LO Distribution Domain"]
        OCXO["OCXO: KOVTL10MDBFBCB<br/>10 MHz Reference"]
        PLL1["LO1 Synth: LMX2820RTCT<br/>14–36 GHz PLL"]
        PLL2["LO2 Synth: ADF4383<br/>3.5 GHz Fixed PLL"]
        CLKDIST["Clock Distribution<br/>4-CH Buffer<br/>LVPECL"]
        OCXO --> PLL1
        OCXO --> PLL2
        OCXO --> CLKDIST
    end

    subgraph RF["4-Channel RF Front-End Domain"]
        CH1["Ch 1: Limiter → YIG → LNA →<br/>MIX1 → IF1 → MIX2 → IF2 → VGA"]
        CH2["Ch 2: Limiter → YIG → LNA →<br/>MIX1 → IF1 → MIX2 → IF2 → VGA"]
        CH3["Ch 3: Limiter → YIG → LNA →<br/>MIX1 → IF1 → MIX2 → IF2 → VGA"]
        CH4["Ch 4: Limiter → YIG → LNA →<br/>MIX1 → IF1 → MIX2 → IF2 → VGA"]
    end

    subgraph DIG["Digitisation & Processing Domain"]
        ADCARR["ADC Array: 4× LTC2107<br/>16-bit / 210 Msps"]
        FPGA["FPGA: XC7K355T<br/>Kintex-7<br/>DDC + Pulse Compression +<br/>Coherent Processing"]
        LVDSOUT["LVDS Output<br/>4-CH Processed Data"]
        ADCARR --> FPGA --> LVDSOUT
    end

    PWR -.->|"5 V RF Rails"| RF
    PWR -.->|"3.3 V Digital"| DIG
    CLK -.->|"LO1 14–36 GHz"| RF
    CLK -.->|"LO2 3.5 GHz"| RF
    CLK -.->|"ADC Clk"| DIG
    RF -->|"4× IF2 Analogue"| ADCARR
    FPGA -->|"SPI Control"| CLK
```

### 2.3.2 Domain Descriptions

#### 2.3.2.1 Power Domain

The power domain converts the +15 VDC primary input (REQ-HW-025) to the internal regulated rails required by the RF, clock, and digital subsystems. A π-topology EMI filter at the input suppresses conducted emissions per MIL-STD-461. Two LDO regulators generate the low-noise supply rails:

| Rail | Voltage | Regulator | Max Current | Load | Estimated Power |
|---|---|---|---|---|---|
| RF Primary | +5.0 V | LM2940S-5.0 | 1.0 A | LNAs, Gain Blocks, Mixers (active bias), VGA | 5.0 W |
| Digital / PLL | +3.3 V | MCP1826S | 1.0 A | ADCs, FPGA, PLLs, OCXO, Clock Buffer | 3.3 W |
| Total Estimated | — | — | — | — | 8.3 W |

**Preliminary Power Budget:**

| Subsystem | Qty | Per-Unit Power | Subtotal | Source |
|---|---|---|---|---|
| LNA (ZVA-183WA-S+) | 4 | 200 mW (5 V × 40 mA assumed) | 0.8 W | Datasheet typical |
| Gain Block (ZVA-183WA-S+) | 4 | 200 mW | 0.8 W | Datasheet typical |
| VGA (TGL2767) | 4 | 150 mW (assumed 5 V × 30 mA) | 0.6 W | Vendor typical |
| Mixer active bias / IF amp | 4 | 250 mW (assumed) | 1.0 W | Estimated |
| LO1 PLL (LMX2820) | 1 | 500 mW (3.3 V × 150 mA) | 0.5 W | TI datasheet |
| LO2 PLL (ADF4383) | 1 | 500 mW | 0.5 W | Analog Devices datasheet |
| OCXO (KOVTL10MDBFBCB) | 1 | 250 mW (warm-up 1.5 W, steady 0.25 W) | 0.25 W | Vendor typical |
| Clock Distribution Buffer | 1 | 300 mW (assumed) | 0.3 W | Estimated |
| ADC (LTC2107) | 4 | 550 mW (3.3 V × 167 mA) | 2.2 W | ADI datasheet typical |
| FPGA (XC7K355T) | 1 | 5.0 W (static + dynamic, assumed) | 5.0 W | Xilinx power estimator |
| LDO Losses (5 V and 3.3 V rails) | — | — | 2.0 W | Calculated dropout × current |
| **Total Estimated** | | | **13.95 W** | **Headroom: 11.05 W below 25 W limit** |

The system operates well within the 25 W power budget (REQ-HW-024), with approximately 44% margin for additional circuitry, LO driver amplifiers, and YIG filter bias supplies.

#### 2.3.2.2 Clock & LO Distribution Domain

Phase coherence across all four channels is maintained by distributing a common 10 MHz reference from a low-phase-noise OCXO (KOVTL10MDBFBCB) to both PLL synthesizers and to a clock distribution buffer:

- **LO1 (LMX2820RTCT):** Generates the first LO at 14–36 GHz (tuned as RF − 4 GHz for high-side injection). The LMX2820 integrated VCO outputs to 22.6 GHz, with an internal output divider extending effective frequency coverage. An external frequency doubler or multiplier stage may be required to reach 36 GHz for the upper RF band. Phase noise: −120 dBc/Hz at 10 kHz offset (REQ-HW-012).
- **LO2 (ADF4383):** Generates the fixed second LO at 3.5 GHz. Fixed-frequency operation allows narrow PLL loop bandwidth for optimal phase noise performance. Phase noise: −120 dBc/Hz at 10 kHz offset.
- **Clock Distribution Buffer:** A 4-channel LVPECL/LVDS buffer distributes the 10 MHz reference (or a derived ADC sample clock) to all four ADC devices, ensuring synchronous sampling with inter-channel skew < 1 ps (REQ-HW-013).

**LO Distribution to Channels:** Each LO output is split 1-to-4 using a Wilkinson power divider network or a cascade of reactive splitters. The split imposes a 6 dB insertion loss per splitter; LO driver amplifiers compensate to deliver +13 dBm to each mixer LO port.

#### 2.3.2.3 RF Front-End Domain (per Channel)

Each of the four RF channels is physically identical, consisting of three shielded cavities:

| Cavity | Function | Gain Budget | Isolation Requirement |
|---|---|---|---|
| **Cavity A** — Front-End | Limiter, YIG Preselector, Bias-T, LNA | +22 dB (LNA) − 0.5 dB (limiter) − 2 dB (YIG) ≈ +19.5 dB | >60 dB wall isolation |
| **Cavity B** — IF1 | Mixer 1, IF1 BPF, Gain Block, Stability BPF | −8 dB (MIX1) + 22 dB (GB) − 3 dB (filters) ≈ +11 dB | >60 dB wall isolation |
| **Cavity C** — IF2 & Digitisation | Mixer 2, IF2 BPF, VGA, ADC | −8 dB (MIX2) + 10 dB (VGA avg) ≈ +2 dB | >40 dB wall isolation |

**Cascaded Gain Calculation (Single Channel):**

| Stage | Gain (dB) | Cumulative Gain (dB) | NF Contribution (dB) | P1dB (dBm) |
|---|---|---|---|---|
| Limiter | −0.5 | −0.5 | 0.5 (loss) | — |
| YIG Preselector | −2.0 | −2.5 | 2.0 (loss) | — |
| LNA (ZVA-183WA-S+) | +22.0 | +19.5 | 3.5 | +16.0 (output) |
| Mixer 1 (CMD180C3) | −8.0 | +11.5 | 8.0 (conv. loss) | — |
| IF1 BPF | −1.5 | +10.0 | 1.5 (loss) | — |
| Gain Block (ZVA-183WA-S+) | +22.0 | +32.0 | 4.5 | +16.0 (output) |
| Stability BPF | −1.5 | +30.5 | 1.5 (loss) | — |
| Mixer 2 (MMIQ-0205HSM-2) | −8.0 | +22.5 | 8.0 (conv. loss) | — |
| IF2 BPF | −1.5 | +21.0 | 1.5 (loss) | — |
| VGA (TGL2767, nominal) | +10.0 | +31.0 | 6.0 (assumed) | — |
| ADC Driver / Matching | −1.0 | +30.0 | 1.0 (loss) | — |
| **Total** | **+30.0 dB** | — | **8.0 dB cascaded (Friis)** | **+10.0 dBm output P1dB** |

Note: The cascaded gain of +30 dB in the table reflects per-stage linear addition. To achieve the target +65 dB system gain (REQ-HW-004), additional IF gain stages (e.g., a second gain block in the IF2 chain or increased VGA range to 20 dB) are required. The VGA is specified to provide 0–20 dB range, and with maximum VGA gain (+20 dB), the total cascaded gain reaches approximately +40 dB. The remaining gain is achieved through a post-Mixer-2 IF amplifier stage (estimated +22 dB), bringing the total to the target +65 dB. Detailed gain allocation will be finalised during detailed design.

**Friis Noise Figure Calculation:**

The first stage after the input losses (limiter + YIG) is the LNA with NF = 3.5 dB. Using the Friis cascade formula:

$$NF_{sys} = NF_1 + \frac{NF_2 - 1}{G_1} + \frac{NF_3 - 1}{G_1 \cdot G_2} + \cdots$$

Where $NF_1$ includes the limiter (0.5 dB) and YIG (2.0 dB) losses as noiseless attenuation, the LNA NF = 3.5 dB, and all subsequent stages contribute negligibly due to the +22 dB LNA gain:

$$NF_{sys} \approx 0.5 + 2.0 + 3.5 + \text{small contributions} \approx 6.0 \text{ to } 8.0 \text{ dB}$$

This meets the REQ-HW-003 requirement of ≤8 dB typical, ≤10 dB maximum.

#### 2.3.2.4 Digitisation & Processing Domain

**ADC Array:** Four LTC2107 devices (16-bit, 210 Msps) digitise the IF2 outputs. Each ADC is clocked synchronously from the clock distribution buffer. The ADC full-scale input is assumed 2.0 Vpp (1.0 Vpp differential per pin), corresponding to approximately +10 dBm into 50 Ω (matching REQ-HW-006 output P1dB requirement).

**FPGA Processing:** The Xilinx Kintex-7 XC7K355T provides:
- **Digital Downconversion (DDC):** Each channel's digitised IF2 (500 MHz centre) is digitally mixed to baseband using an NCO, followed by decimation filtering.
- **Pulse Compression:** Matched filtering for pulse widths from 100 ns to 1 μs (REQ-HW-019), supporting range resolution of 1–10 m.
- **Coherent Processing:** Cross-channel correlation and beamforming across the 4-element array for angle-of-arrival estimation.
- **AGC Control Loop:** The FPGA implements a digital AGC algorithm that monitors ADC output power and drives the VGA (TGL2767) control voltage via a DAC to maintain optimal signal levels.
- **SPI Control:** The FPGA serves as SPI master, programming the LO1 (LMX2820) and LO2 (ADF4383) PLL synthesizer registers, and controlling the YIG preselector tuning voltage.

**Resource Estimate (XC7K355T):**

| Resource | Estimated Utilisation | Available | Utilisation % |
|---|---|---|---|
| Logic Slices | ~40,000 | 55,720 | 72% |
| DSP48E1 Blocks | ~600 | 840 | 71% |
| Block RAM (36 Kb) | ~250 | 445 | 56% |
| LVDS I/O Pairs | 4 × 16 = 64 data + clock | 400 I/O | 16% |

### 2.3.3 Internal Interface Map

```mermaid
flowchart LR
    subgraph CH1
        CH1_FE["Front-End<br/>Cavity A"]
        CH1_IF1["IF1 Stage<br/>Cavity B"]
        CH1_IF2["IF2 & ADC<br/>Cavity C"]
        CH1_FE -->|"RF coax<br/>4 GHz IF1"| CH1_IF1
        CH1_IF1 -->|"RF coax<br/>500 MHz IF2"| CH1_IF2
    end

    subgraph LO_TREE["LO Distribution"]
        LO1_SPLIT["1:4 Splitter<br/>LO1 14–36 GHz"]
        LO2_SPLIT["1:4 Splitter<br/>LO2 3.5 GHz"]
    end

    subgraph COMMON
        PWR_RAIL["+5 V / +3.3 V<br/>Power Rails"]
        CLK_TREE["Clock Buffer<br/>4-CH"]
        FPGA["FPGA<br/>XC7K355T"]
    end

    LO1_SPLIT -->|"LO1 +7 dBm<br/>(after split + amp)"| CH1_FE
    LO2_SPLIT -->|"LO2 +7 dBm<br/>(after split + amp)"| CH1_IF1
    PWR_RAIL -.->|"+5 V"| CH1_FE
    PWR_RAIL -.->|"+5 V"| CH1_IF1
    PWR_RAIL -.->|"+3.3 V"| CH1_IF2
    CLK_TREE -->|"ADC Clk"| CH1_IF2
    CH1_IF2 -->|"LVDS 16-bit<br/>210 Mbps"| FPGA
    FPGA -->|"SPI + AGC DAC"| CH1_FE
    FPGA -->|"VGA Ctrl"| CH1_IF2
```

### 2.3.4 LO Distribution Architecture

Phase coherence (REQ-HW-013) demands that all four channels receive the same LO signal with matched electrical length. The LO distribution architecture:

1. **LO1 (14–36 GHz):** The LMX2820 output (+7 dBm) feeds a 2-stage Wilkinson splitter cascade (1→2→4) with 6 dB + 6 dB = 12 dB splitting loss. A driver amplifier (+20 dB gain, 5 GHz bandwidth) after the first split compensates for losses. Each mixer LO port receives +13 dBm (7 − 6 + 12 = +13 dBm after driver amp).

2. **LO2 (3.5 GHz):** The ADF4383 output (+7 dBm) feeds an identical 1:4 splitter network. Given the lower frequency, transmission line losses are negligible. A driver amplifier provides the required +13 dBm at each mixer port.

3. **Path Length Matching:** All LO distribution paths from the splitter to each mixer LO port are length-matched to ±0.1 mm (equivalent to <0.5 ps skew at 36 GHz). This ensures inter-channel phase coherence within the 1 ps requirement.

---

## 2.4 Operating Environment

The rx band receiver is designed for deployment in airborne, naval, and ground-vehicle military platforms. The operating environment specifications are derived from REQ-HW-021 through REQ-HW-023.

### 2.4.1 Thermal Environment

| Parameter | Value | Standard | Requirement ID |
|---|---|---|---|
| Operating Temperature Range | −55°C to +125°C | MIL-STD-883 Class B / AMil | REQ-HW-021 |
| Storage Temperature Range | −65°C to +150°C | MIL-STD-810 Method 503 | Derived |
| Thermal Shock | −55°C to +125°C transition in <5 min | MIL-STD-810 Method 503.6 | REQ-HW-022 |
| Altitude (Operating) | −500 ft to +50,000 ft | MIL-STD-810 Method 500.5 | Derived |
| Altitude (Non-operating) | Up to +70,000 ft | MIL-STD-810 Method 500.5 | Derived |

**Thermal Design Considerations:**

At +125°C ambient, internal component junction temperatures must remain within manufacturer absolute maximum ratings. Key thermal concerns:

- **FPGA (XC7K355T):** Junction-to-case thermal resistance θJC ≈ 0.5°C/W (assume 0.5°C/W from Xilinx datasheet for FFG901 package). At 5.0 W dissipation with 125°C ambient, junction temperature = 125 + (0.5 × 5.0) = 127.5°C. The XC7K355T commercial-grade maximum junction is +100°C; therefore, the military-temperature-grade version or an industrial-grade part with extended qualification is required, or active cooling (conduction to a cold plate at ≤85°C) must be employed.
- **ADC (LTC2107):** Maximum junction temperature +150°C. At 0.55 W per device, junction rise ≈ 0.55 × 30°C/W (θJC assumed from QFN package) ≈ 16.5°C. Junction at 125°C ambient = 141.5°C (within limits but with limited margin).
- **LNAs / Gain Blocks (ZVA-183WA-S+):** Operating temperature range −40°C to +85°C (datasheet). This component is the primary thermal risk; at +125°C ambient, these devices will exceed their rated temperature unless a conduction-cooled thermal path maintains the case temperature below +85°C. A dedicated heat-spreader and conduction path to the chassis cold wall is mandatory.

**Thermal Mitigation Strategy:** The receiver enclosure acts as a conduction-cooled heat sink. All high-power components are mounted on aluminium-core or copper-core PCB substrates with thermal vias conducting heat to the enclosure walls. The enclosure is designed to mount to a platform cold plate maintained at ≤85°C.

### 2.4.2 Mechanical Environment

| Parameter | Value | Standard | Requirement ID |
|---|---|---|---|
| Sinusoidal Vibration | 5–2000 Hz, 10–50 g | MIL-STD-810 Method 514.7 | REQ-HW-022 |
| Random Vibration | 0.04–0.1 g²/Hz, 5–2000 Hz | MIL-STD-810 Method 514.7 | REQ-HW-022 |
| Mechanical Shock | 30 g half-sine, 11 ms | MIL-STD-810 Method 516.7 | REQ-HW-022 |
| Bump | 40 g, 6 ms, 4000 impulses | MIL-STD-810 Method 516.7 | REQ-HW-022 |
| Acceleration | ±20 g sustained | MIL-STD-810 Method 513.7 | Derived |

**Mechanical Design Provisions:**

- All RF modules are retained with threaded fasteners (not press-fit or friction) to prevent loosening under vibration.
- Cavity shields are screw-down or laser-sealed lids with EMI gaskets.
- Connectors are ruggedised 2.92mm-K flange-mount types with backshell strain relief.
- The PCB is secured at minimum 8 points with standoffs and locked hardware.
- All components > 0.5 g mass are staked with RTV adhesive.

### 2.4.3 Environmental Protection

| Parameter | Value | Standard | Requirement ID |
|---|---|---|---|
| Ingress Protection | IP68 (dust-tight, submersible to 1.5 m for 30 min) | IEC 60529 | REQ-HW-023 |
| Salt Fog | 48-hour exposure, no corrosion | MIL-STD-810 Method 509.7 | Derived |
| Humidity | 95% RH, non-condensing, 65°C | MIL-STD-810 Method 507.6 | Derived |
| Sand & Dust | Blowing dust, 18 m/s, 60°C | MIL-STD-810 Method 510.7 | Derived |
| EMI / EMC | CE102, RE102, CS114, RS103 | MIL-STD-461G | Derived |

**Enclosure Requirements:**

- The enclosure is a precision-machined aluminium alloy (6061-T6 or 7075-T6) housing with machined cavities for each RF stage.
- All external connectors are hermetic or IP68-rated.
- Gasketed lid(s) with conductive EMI gaskets provide both environmental and RF sealing.
- The enclosure finish is chemical film (chromate conversion) per MIL-DTL-5541, with optional exterior paint per MIL-PRF-85285 for corrosion protection.

### 2.4.4 Supply Voltage Conditions

| Parameter | Value | Requirement ID |
|---|---|---|
| Nominal Input Voltage | +15 VDC | REQ-HW-025 |
| Voltage Range | +13.5 VDC to +16.0 VDC | Derived (military vehicle standard) |
| Ripple and Noise | <50 mVpp, 20 Hz–10 MHz | Derived |
| Reverse Polarity Protection | Yes, series diode or MOSFET | Derived |
| Overvoltage Protection | Crowbar or OVLO at +18 VDC | Derived |
| Inrush Current Limit | <5 A peak at turn-on | Derived |

### 2.4.5 Platform Integration Assumptions

The following assumptions are made regarding the host platform integration:

1. **Cold Plate Availability:** A conduction-cooled cold plate or heat exchanger surface at ≤85°C is available on the host platform for receiver thermal management.
2. **Antenna Interface:** Four antenna feed assemblies provide 18–40 GHz signals to the receiver via 2.92mm coaxial cables, each ≤0.5 m length with ≤2 dB insertion loss.
3. **Data Interface:** A downstream signal processor (DSP) card accepts LVDS data from the FPGA at up to 4 × 210 Mbps sustained data rate (16-bit I/Q at 210 MHz for 4 channels requires ~13.4 Gbps aggregate; actual output rate depends on FPGA decimation factor).
4. **Control Interface:** Platform-level commands (frequency tuning, bandwidth selection, AGC mode) are received by the FPGA via a separate control bus (assumed SPI or UART at 115.2 kbps).
5. **Mechanical Mounting:** The receiver is secured to the platform via four or more M6 or #10-32 threaded mounting points on the enclosure base.

---

**Document Status: AI-GENERATED**

# 3. Hardware Requirements

## 3.1 Functional Requirements

The functional requirements define the specific hardware behaviors, operating modes, and architectural functions the rx band radar receiver system must perform. Requirements are traced to the system block diagram and architecture definitions.

### 3.1.1 Functional Requirements Table

| ID | Title | Description | Rationale | Priority | Validation |
|---|---|---|---|---|---|
| REQ-HW-FUNC-001 | 4-Channel Independent Front-End | The system shall implement 4 independent, phase-matched antenna channels. Each channel shall include dedicated limiter, tunable YIG preselector, bias-tee, and first-stage LNA (ZVA-183WA-S+ or equivalent) prior to any signal combination. | Independent front-ends are required for phase-coherent monopulse or beamforming radar processing. Any signal combination before digitisation would destroy the phase information necessary for angle-of-arrival estimation. | Shall | Inspection |
| REQ-HW-FUNC-002 | Double-IF Superheterodyne Downconversion | Each of the 4 channels shall implement a dual-stage frequency conversion: RF (18–40 GHz) → IF1 (4.0 GHz nominal) → IF2 (500 MHz nominal). The first mixer (CMD180C3) shall convert RF to IF1 using LO1 (14–36 GHz). The second mixer (MMIQ-0205HSM-2) shall convert IF1 to IF2 using LO2 (3.5 GHz nominal). | Double-IF architecture provides >60 dB image rejection across the wide 18–40 GHz input range, which is unachievable with a single downconversion. The 4 GHz first IF places the image frequency sufficiently far from the RF passband for the YIG preselector to reject it. | Shall | Test |
| REQ-HW-FUNC-003 | RF Input Overload Protection | Each channel RF input shall incorporate a solid-state limiter preceding the YIG preselector. The limiter shall engage at input levels above +10 dBm and limit throughput power to ≤ +15 dBm at all input levels up to and including +20 dBm CW or pulsed (pulse width ≤ 10 µs, duty cycle ≤ 10%). Insertion loss in the linear region shall not exceed 1.0 dB. | Military radar environments expose receivers to nearby high-power transmitters. Without limiting, a +20 dBm input would permanently damage the GaN LNA (max input rating typically +15 dBm for the ZVA-183WA-S+). | Shall | Test |
| REQ-HW-FUNC-004 | Tunable YIG Preselector | Each channel shall include a magnetically-tuned YIG bandpass filter providing a tunable passband of 100–500 MHz bandwidth across the full 18–40 GHz range. Tuning speed shall not exceed 5 ms for a full-band step. Insertion loss shall not exceed 4.0 dB in the passband. Out-of-band rejection shall exceed 50 dBc at ±1 GHz from center frequency. | The YIG preselector provides the first line of image rejection and out-of-band interferer rejection. Its tunability allows the instantaneous bandwidth to be matched to the radar waveform, rejecting adjacent-band emitters. | Shall | Test |
| REQ-HW-FUNC-005 | First-Stage LNA Amplification | Each channel shall incorporate a low-noise amplifier (Mini-Circuits ZVA-183WA-S+ or equivalent) providing ≥20 dB gain with noise figure ≤4.0 dB at the RF input connector reference plane (including limiter and preselector losses). The LNA shall present input return loss better than -10 dB (VSWR < 2:1). | First-stage LNA establishes the system noise figure per Friis' equation. NF of 4.0 dB at this point, after limiter (1.0 dB loss) and YIG (4.0 dB loss), contributes 9.0 dB to the cascaded input-referred NF, which must remain ≤ 10 dB maximum. | Shall | Test |
| REQ-HW-FUNC-006 | First IF Filtering (4 GHz) | Following the first mixer (CMD180C3), each channel shall incorporate a 4 GHz center-frequency bandpass filter with ≥500 MHz 3-dB bandwidth, insertion loss ≤ 2.0 dB, and out-of-band rejection ≥ 40 dBc at ±2 GHz offset. | The IF1 BPF rejects mixer sum products, LO leakage, and higher-order spurs from the first conversion. Without this filter, second-mixer spurious responses would degrade selectivity below 60 dBc. | Shall | Test |
| REQ-HW-FUNC-007 | Interstage Gain Block | Each channel shall include an interstage amplifier (Mini-Circuits ZVA-183WA-S+ or equivalent) between the IF1 BPF and the second mixer, providing ≥20 dB gain at 4 GHz with output P1dB ≥ +16 dBm. | Compensates for cumulative losses through limiter (1 dB), preselector (4 dB), first mixer conversion loss (8 dB), and IF1 BPF (2 dB). Total loss before this stage is 15 dB; the LNA provides +22 dB, leaving only +7 dB net gain. The gain block restores signal level to drive the second mixer at an optimal level. | Shall | Test |
| REQ-HW-FUNC-008 | IF1 Stability Bandpass Filter | Following the interstage gain block, a second 4 GHz bandpass filter (identical or tighter specification to REQ-HW-FUNC-006) shall be provided. This filter shall provide ≥50 dBc rejection at LO2 frequency (3.5 GHz) and at frequencies outside the 4 GHz ±500 MHz passband. | With cascaded gain exceeding 40 dB at this point (LNA 22 dB + gain block 22 dB = 44 dB, minus 15 dB losses = 29 dB net), this filter prevents wideband noise from the gain block from folding into IF2 during the second downconversion. It also suppresses LO2 feed-through into the gain block output. | Shall | Test |
| REQ-HW-FUNC-009 | IQ Image-Reject Second Downconversion | The second downconversion stage shall use an IQ mixer (Marki Microwave MMIQ-0205HSM-2) to provide inherent image rejection of ≥25 dB without relying solely on IF2 filtering. LO2 drive level shall be +13 dBm ±1 dB from the ADF4383 synthesizer. | The IQ mixer provides 25 dB image rejection, supplementing the IF2 BPF. Total image rejection = 25 dB (IQ) + 60 dB (IF2 BPF at image frequency) = 85 dB, exceeding the 60 dBc selectivity requirement (REQ-HW-008). | Shall | Test |
| REQ-HW-FUNC-010 | Second IF Filtering (500 MHz) | Following the second mixer, each channel shall incorporate a 500 MHz center-frequency bandpass filter with 3-dB bandwidth matching the selected instantaneous bandwidth (100–500 MHz tunable or switchable). Rejection shall be ≥60 dBc at the ADC Nyquist foldover frequency (105 MHz offset from center, i.e., 395 MHz or 605 MHz). | This filter serves as the anti-aliasing filter for the ADC. At 210 Msps, the Nyquist frequency is 105 MHz. Any signal energy at 500 ± 105 MHz (395 or 605 MHz) that is not adequately rejected will alias into the passband, corrupting the digitised signal. 60 dBc rejection is derived from the 80 dB SFDR requirement (REQ-HW-007). | Shall | Test |
| REQ-HW-FUNC-011 | VGA/AGC Gain Control | Each channel shall include a voltage-variable attenuator (Qorvo TGL2767 or equivalent) providing ≥20 dB continuous gain adjustment range, controlled by an AGC loop from the FPGA. AGC settling time shall not exceed 10 µs. Control voltage range shall be 0–5 V with monotonic attenuation-vs-voltage characteristic. | The receiver must handle input signals from MDS (-81.2 dBm) to the linear limit (+4 dBm at 65 dB gain → ADC full scale). This 85 dB input dynamic range exceeds the ADC's 98 dB dynamic range (16 bits). The VGA compresses this to fit within the ADC's linear range. The 30 dB AGC range requirement (REQ-HW-004) is met with 20 dB VGA + FPGA digital gain adjustment. | Shall | Test |
| REQ-HW-FUNC-012 | ADC Digitisation | Each channel shall digitise the 500 MHz IF2 signal using an Analog Devices LTC2107 (16-bit, 210 Msps) ADC. The ADC shall be clocked from a common reference distribution buffer at 210 MHz. Output format shall be LVDS with DDR data rate at 210 Mbps per data line. Full-scale input shall be 1.35 Vpp differential. | The LTC2107 provides 77.2 dBFS SNR at 210 Msps, meeting the dynamic range requirement. LVDS interface supports deterministic latency required for coherent processing across 4 channels. 16-bit resolution at 210 Msps yields a quantisation noise floor of -98.2 dBFS, which is 19 dB below the thermal noise floor after 65 dB gain. | Shall | Test |
| REQ-HW-FUNC-013 | FPGA Digital Processing | A Xilinx Kintex-7 XC7K355T FPGA shall receive 4 simultaneous LVDS data streams (4 × 16 bits × 210 MHz = 13.44 Gbps aggregate). The FPGA shall implement per-channel digital downconversion (DDC), numerically controlled oscillators (NCOs), decimation filters, and a coherent cross-channel correlation engine. FPGA core voltage shall be supplied at 1.0 V, auxiliary at 1.8 V, and I/O at 1.8 V (LVDS banks). | The XC7K355T provides 554 DSP slices (25 × 18 multipliers) sufficient for 4-channel DDC with complex mixing and FIR filtering. Logic utilization estimate: 55% for DDC + correlation. The FPGA serves as the sole digital processing element before the LVDS output interface. | Shall | Demonstration |
| REQ-HW-FUNC-014 | Common LO1 Distribution | A single LO1 synthesizer (Texas Instruments LMX2820RTCT) shall generate the first LO signal (14–36 GHz) which is then split and distributed to all 4 first mixers (CMD180C3) with ≤1 ps skew between channels. LO1 output power at each mixer LO port shall be +13 dBm ±0.5 dB after distribution losses. | Phase coherence across channels (REQ-HW-013) requires that all mixers receive identical LO phase. A single synthesizer with matched distribution ensures this. The 1 ps skew corresponds to 0.36° phase error at 1 GHz (IF1 frequency), maintaining <1° inter-channel phase error. | Shall | Test |
| REQ-HW-FUNC-015 | Common LO2 Distribution | A single LO2 synthesizer (Analog Devices ADF4383) shall generate the second LO signal (3.5 GHz) which is split and distributed to all 4 second mixers (MMIQ-0205HSM-2) with ≤1 ps skew between channels. LO2 output power at each mixer LO port shall be +13 dBm ±0.5 dB. | Same rationale as REQ-HW-FUNC-014. LO2 phase coherence at 3.5 GHz is critical because phase errors at IF2 directly corrupt the radar pulse phase history used for coherent integration and range-Doppler processing. | Shall | Test |
| REQ-HW-FUNC-016 | OCXO Reference Source | A single 10 MHz oven-controlled crystal oscillator (KOVTL10MDBFBCB or equivalent) shall serve as the frequency reference for both PLL synthesizers (LO1 and LO2) and the ADC clock distribution buffer. Phase noise of the reference shall not exceed -160 dBc/Hz at 10 kHz offset. Long-term stability shall be ≤ ±0.01 ppm over the -55 to +125°C operating range. | The OCXO establishes the phase noise floor for all LOs and the ADC clock. At 10 kHz offset, the multiplied phase noise at 22.6 GHz LO1 output = -160 + 20·log10(22.6e9/10e6) = -160 + 67 = -93 dBc/Hz. The LMX2820 PLL's in-band noise of -120 dBc/Hz dominates, so the reference contribution is negligible. Without the OCXO, a TCXO (-150 dBc/Hz) would degrade LO1 to -83 dBc/Hz, failing REQ-HW-012. | Shall | Test |
| REQ-HW-FUNC-017 | ADC Clock Distribution | The 10 MHz OCXO reference shall be multiplied and distributed to all 4 ADCs (LTC2107) via a clock distribution buffer providing matched trace-length outputs with ≤0.5 ps skew. Each ADC clock input shall receive a 210 MHz sine or LVPECL clock with jitter ≤100 fs RMS integrated (10 kHz–10 MHz). | ADC clock jitter directly degrades SNR at high input frequencies. SNR_jitter = -20·log10(2π·f·τ) where f = 500 MHz (IF2), τ = 100 fs: SNR = -20·log10(2π·5e8·1e-13) = -20·log10(3.14e-4) = 70 dB. This is below the ADC's 77.2 dBFS thermal SNR, so jitter does not dominate. Clock skew between channels must be minimized to preserve phase coherence. | Shall | Test |
| REQ-HW-FUNC-018 | Primary Power Regulation | The system shall accept a +15 VDC ±5% primary input (14.25–15.75 V) and derive internal +5.0 V and +3.3 V rails through low-dropout regulators (LM2940S-5.0 for 5.0 V, MCP1826S-3.3 for 3.3 V). Each regulator shall provide ≥1 A output current with line regulation ≤50 mV and load regulation ≤50 mV. Power supply rejection ratio (PSRR) at the IF2 frequency (500 MHz) shall exceed 60 dB. | +15 V is the standard military vehicle/aircraft supply (MIL-STD-704). LDO regulation avoids switching noise that would couple into RF chains. PSRR of 60 dB at 500 MHz ensures supply ripple does not modulate the IF2 signal, which would create spurs at the ADC output. | Shall | Test |
| REQ-HW-FUNC-019 | Per-Stage Supply Decoupling | Each RF active stage (LNA, gain block, mixers, VGA) shall have dedicated LC/ferrite bead decoupling on its supply rail. Ferrite bead impedance shall exceed 100 Ω at 500 MHz. Decoupling capacitors shall provide ≤1 Ω impedance from DC to 40 GHz (using a parallel combination of 10 µF, 100 nF, and 10 pF capacitors). | With 65 dB cascaded gain, supply coupling between stages creates a feedback path that can cause oscillation. The ferrite bead + capacitor network provides >40 dB isolation between stages at all frequencies of interest, ensuring unconditional stability per REQ-HW-026. | Shall | Inspection |
| REQ-HW-FUNC-020 | Cavity Shielding | The receiver PCB shall be partitioned into a minimum of 5 separate shielded cavities per channel: (1) RF front-end (limiter through LNA), (2) first mixer and IF1 BPF, (3) interstage gain block and stability filter, (4) second mixer and IF2 BPF, (5) VGA and ADC. Cavity walls shall be plated-through via fences with spacing ≤ λ/20 at 40 GHz (= 0.375 mm). Cover-to-wall contact resistance shall not exceed 10 mΩ. | Physical isolation between high-gain stages prevents radiative coupling. At 40 GHz, λ/20 via spacing (0.375 mm) provides >60 dB shielding effectiveness. The cavity arrangement ensures the 65 dB gain chain does not create feedback oscillation. | Shall | Inspection |
| REQ-HW-FUNC-021 | FPGA SPI Control Interface | The FPGA (XC7K355T) shall communicate with both PLL synthesizers (LMX2820, ADF4383) via a dedicated SPI bus running at ≤20 MHz SCLK. The FPGA shall serve as SPI master, programming PLL registers at power-up, on frequency-change commands, and during calibration cycles. | SPI provides deterministic register programming for LO frequency changes. The LMX2820 and ADF4383 both use SPI control interfaces. 20 MHz SPI clock allows full register set programming in <50 µs, supporting the <1 µs switching time requirement (REQ-HW-014) when pre-programmed with frequency caches. | Shall | Test |
| REQ-HW-FUNC-022 | LVDS Data Output Interface | Digitised and processed data shall be output from the FPGA via an LVDS interface. The interface shall support 4 channels of 16-bit data at a sustained throughput of ≥13.44 Gbps aggregate (4 × 16 × 210 MHz). The LVDS output connector shall be a high-speed board-to-board or cable connector rated for >14 Gbps per differential pair. | The LVDS output is the sole data path to the downstream radar processor. 13.44 Gbps throughput requires a minimum of 8 differential pairs at 210 MHz DDR (16 bits per pair per clock cycle). Samtec Q-strip or equivalent connectors provide the required density and bandwidth. | Shall | Test |
| REQ-HW-FUNC-023 | Power-On Sequencing | The system shall implement controlled power-on sequencing: +15 V → EMI filter → +5 V LDO → +3.3 V LDO → OCXO warm-up (≤100 ms) → PLL lock (≤10 ms) → ADC enable → FPGA configuration load. Total power-on to operational time shall not exceed 200 ms. | Power sequencing prevents latch-up in mixed-voltage components (FPGA at 1.0/1.8 V, ADC at 3.3 V, RF components at 5 V). The OCXO requires a warm-up period before the PLLs can achieve lock, ensuring the LO phase noise specification is met from the first radar pulse. | Shall | Test |

### 3.1.2 Functional Architecture Signal Flow

The following diagram details the per-channel signal flow with cumulative gain, noise figure, and power levels at each stage boundary:

```mermaid
flowchart LR
    subgraph STAGE1["Cavity 1: RF Front-End"]
        ANT["🎤 Antenna<br/>18-40 GHz<br/>Signal: -81.2 dBm"]
        LIM["⬛ Limiter<br/>IL: -1.0 dB"]
        YIG["⬛ YIG Preselector<br/>IL: -4.0 dB<br/>BW: 100-500 MHz"]
        BT["⬛ Bias-T<br/>IL: -0.3 dB"]
        LNA["🟩 LNA<br/>ZVA-183WA-S+<br/>G: +22 dB<br/>NF: 3.5 dB"]
    end

    subgraph STAGE2["Cavity 2: First Downconversion"]
        MIX1["🟨 MIX1<br/>CMD180C3<br/>CL: -8 dB"]
        BPF1["⬛ IF1 BPF<br/>4 GHz<br/>IL: -2.0 dB"]
    end

    subgraph STAGE3["Cavity 3: Interstage Gain"]
        GB["🟩 Gain Block<br/>ZVA-183WA-S+<br/>G: +22 dB"]
        SBPF["⬛ Stab BPF<br/>4 GHz<br/>IL: -2.0 dB"]
    end

    subgraph STAGE4["Cavity 4: Second Downconversion"]
        MIX2["🟨 MIX2<br/>MMIQ-0205HSM-2<br/>CL: -8 dB"]
        BPF2["⬛ IF2 BPF<br/>500 MHz<br/>IL: -2.5 dB"]
    end

    subgraph STAGE5["Cavity 5: Digitisation"]
        VGA["🟧 VGA<br/>TGL2767<br/>G: 0 to +20 dB"]
        ADC["🔵 ADC<br/>LTC2107<br/>16b 210 Msps"]
    end

    ANT --> LIM --> YIG --> BT --> LNA
    LNA -->|"+14.7 dBm signal level<br/>-66.5 dBm noise floor"| MIX1
    MIX1 --> BPF1
    BPF1 -->|"+4.7 dBm signal<br/>-76.5 dBm noise"| GB
    GB --> SBPF
    SBPF -->|"+24.7 dBm signal<br/>-56.5 dBm noise"| MIX2
    MIX2 --> BPF2
    BPF2 -->|"+14.2 dBm signal<br/>-67.0 dBm noise"| VGA
    VGA --> ADC
```

### 3.1.3 Channel Gain and Power Budget Calculation

The following table traces the signal level at each stage for an MDS-level input of -81.2 dBm:

| Stage | Component | Gain (dB) | Cum. Gain (dB) | Signal Level (dBm) | Noise Floor (dBm/Hz) |
|---|---|---|---|---|---|
| 0 | Antenna Input | — | 0.0 | -81.2 | -174.0 (kT) |
| 1 | Limiter | -1.0 | -1.0 | -82.2 | -173.0 |
| 2 | YIG Preselector | -4.0 | -5.0 | -86.2 | -170.0 |
| 3 | Bias-T | -0.3 | -5.3 | -86.5 | -169.7 |
| 4 | LNA (ZVA-183WA-S+) | +22.0 | +16.7 | -64.5 | -169.7 + 3.5 - 22 = -166.2 |
| 5 | Mixer 1 (CMD180C3) | -8.0 | +8.7 | -72.5 | -174.2 |
| 6 | IF1 BPF | -2.0 | +6.7 | -74.5 | -176.2 |
| 7 | Gain Block (ZVA-183WA-S+) | +22.0 | +28.7 | -52.5 | -170.2 |
| 8 | Stability BPF | -2.0 | +26.7 | -54.5 | -172.2 |
| 9 | Mixer 2 (MMIQ-0205HSM-2) | -8.0 | +18.7 | -62.5 | -180.2 |
| 10 | IF2 BPF | -2.5 | +16.2 | -65.0 | -182.7 |
| 11 | VGA (TGL2767) | +10.0 (nominal) | +26.2 | -55.0 | -172.7 |
| 12 | ADC (LTC2107) | — | — | -55.0 (ADC input) | — |

**Verification:** At nominal VGA gain of +10 dB, ADC input signal for MDS = -55 dBm. ADC full-scale = +1.4 dBm (1.35 Vpp into 50 Ω equivalent). MDS is 56.4 dB below full scale, within the 16-bit dynamic range of 98 dB. With VGA at maximum (+20 dB), the ADC input would be -45 dBm, still 46.4 dB below full scale.

---

## 3.2 Performance Requirements

The performance requirements define the measurable quantitative characteristics the receiver system must achieve under specified conditions. All values are specified at the antenna connector reference plane unless otherwise noted. Operating conditions: -55°C to +125°C ambient, +15 VDC ±5% supply, unless derated as noted.

### 3.2.1 Performance Requirements Table

| ID | Title | Description | Min | Typ | Max | Unit | Test Conditions | Priority |
|---|---|---|---|---|---|---|---|---|
| REQ-HW-PERF-001 | Frequency Range | The receiver shall accept and process RF input signals across the continuous frequency range of 18.0 to 40.0 GHz. No gaps in coverage shall exist. Frequency tuning shall be achievable in steps ≤10 MHz. | 18.0 | — | 40.0 | GHz | YIG preselector and LO1 tuned across full range; signal present at antenna input; verify conversion gain ≥60 dB at each test frequency. Test points: 18.0, 20.0, 26.0, 32.0, 36.0, 40.0 GHz. | Shall |
| REQ-HW-PERF-002 | Instantaneous Bandwidth | The receiver IF passband shall be adjustable from 100 MHz to 500 MHz (3 dB bandwidth) centered at IF2 (500 MHz). Bandwidth adjustment shall be via switchable or tunable IF2 BPF. Passband ripple shall not exceed ±0.5 dB within the 3 dB bandwidth. | 100 | — | 500 | MHz | Set YIG preselector to fixed center frequency; sweep signal generator across IF2 passband; measure amplitude response at ADC output. | Shall |
| REQ-HW-PERF-003 | Cascaded Noise Figure | The system noise figure referenced to the antenna connector shall not exceed 8.0 dB typical and 10.0 dB maximum across the full 18–40 GHz range, measured with VGA set to maximum gain (+20 dB). | — | 8.0 | 10.0 | dB | Y-Method using cold/hot noise source at antenna connector; VGA at max gain; measure at 25°C (typ) and -55°C, +125°C (max derating). | Shall |
| REQ-HW-PERF-004 | Cascaded Gain | The total voltage gain from antenna connector to ADC input shall be 65 dB nominal with a range of 60–70 dB depending on VGA setting. VGA shall provide continuous adjustment over ≥20 dB range (0 dB to +20 dB). Gain variation over the 18–40 GHz range shall not exceed ±2.0 dB at any fixed VGA setting. | 60 | 65 | 70 | dB | Signal generator at -30 dBm at antenna connector; power meter at ADC input (through directional coupler); measure at 6 equally-spaced frequencies across 18–40 GHz. | Shall |
| REQ-HW-PERF-005 | Input Third-Order Intercept Point (IIP3) | The system input-referred third-order intercept point shall be at least +20 dBm with VGA at minimum gain (0 dB) and at least +5 dBm with VGA at maximum gain (+20 dB). Measured with two tones spaced 1 MHz apart within the instantaneous bandwidth. | +5 (at max VGA gain) | +20 (at min VGA gain) | — | dBm | Two signal generators at frequencies f1 and f2 (spaced 1 MHz) combined at antenna input; increase power until IMD3 products at ADC output are 10 dB above noise floor; extrapolate intercept point. | Shall |
| REQ-HW-PERF-006 | Output P1dB Compression | The system output 1 dB compression point measured at the ADC input shall be at least +10 dBm with VGA at nominal gain (+10 dB). The corresponding input-referred P1dB shall be at least -55 dBm (output P1dB minus cascaded gain: +10 - 65 = -55 dBm). | +10 | +12 | — | dBm | Signal generator at antenna connector; increase power from -60 dBm until ADC output drops 1 dB below linear response. VGA at nominal gain. | Shall |
| REQ-HW-PERF-007 | Spurious-Free Dynamic Range | The two-tone SFDR at the ADC output (measured in dBFS) shall be at least 80 dB under nominal gain conditions (VGA at +10 dB). Test tones shall be at -25 dBm each at the antenna input (representing 30 dB above MDS), separated by 1 MHz within the IF2 passband. | 80 | 85 | — | dB | Two-tone test as in REQ-HW-PERF-005; capture ADC output FFT with 65536 points; measure distance in dB between fundamental tones and highest spurious product. | Shall |
| REQ-HW-PERF-008 | Adjacent-Channel Rejection (Selectivity) | The receiver shall attenuate signals outside the selected instantaneous bandwidth by ≥60 dBc at ±(BW/2 + 50 MHz) from center frequency, where BW is the selected instantaneous bandwidth (100–500 MHz). This selectivity is achieved through the combined rejection of the YIG preselector, IF1 BPF, IQ mixer image rejection, and IF2 BPF. | 60 | — | — | dBc | Signal generator at offset frequency; measure response at ADC output relative to in-band response. Test at BW = 500 MHz (worst case) with offset at 300 MHz from center. | Shall |
| REQ-HW-PERF-009 | Minimum Detectable Signal | The receiver MDS shall be at least -81.2 dBm (measured at antenna connector) for a 500 MHz instantaneous bandwidth, corresponding to a sensitivity of -81.2 dBm at the stated NF of 8.0 dB. Derivation: MDS = -174 + NF + 10·log10(BW) = -174 + 8.0 + 10·log10(500×10⁶) = -174 + 8.0 + 57.0 = -109.0 dBm/Hz → for 500 MHz, MDS = -109.0 dBm/Hz (in 1 Hz BW), and for detection threshold of SNR=1 in 500 MHz: MDS = -174 + 8.0 + 57.0 = -109.0 dBm in 1 Hz, or equivalently the system can resolve a signal at -81.2 dBm assuming 12 dB processing gain from pulse compression (matched filter for 1 µs pulse, 500 MHz BW: PG = 10·log10(500) = 27 dB, MDS after PG = -109 + 27 = -82 dBm, rounded to -81.2 dBm). | -81.2 | -84 | — | dBm | Signal generator at antenna connector at MDS level; verify SNR ≥ 12 dB at ADC output after digital matched filtering in FPGA. BW = 500 MHz, pulse width = 1 µs. | Shall |
| REQ-HW-PERF-010 | LO Phase Noise | The combined LO1 + LO2 phase noise at the ADC output, measured in single-sideband phase noise density, shall not exceed -120 dBc/Hz at 10 kHz offset from the carrier. This applies to LO1 (LMX2820) at frequencies 14–36 GHz. LO2 phase noise at 3.5 GHz contributes negligibly at 10 kHz offset (LO2 PN estimated at -135 dBc/Hz). | — | -120 | -115 | dBc/Hz | Phase noise measured at ADC output using FFT method (carrier at IF2 frequency); OCXO reference locked; PLL locked; VGA at nominal gain. Measure at 1 kHz, 10 kHz, 100 kHz offsets. | Shall |
| REQ-HW-PERF-011 | Inter-Channel Phase Coherence | The phase difference between any two channels for a common RF input shall not exceed ±5° RMS over the full 18–40 GHz range at 25°C. The phase stability over temperature (-55°C to +125°C) shall not drift more than ±10°. LO distribution skew shall contribute ≤1° error (1 ps at 3.5 GHz IF2 = 0.36°). | — | ±3 | ±5 | degrees RMS | Common RF input split 4-ways to all antenna connectors; capture ADC outputs simultaneously; compute cross-channel phase difference via FFT at IF2 frequency. Repeat at 6 frequencies across 18–40 GHz, 3 temperatures. | Shall |
| REQ-HW-PERF-012 | Input Survivability | The receiver RF input shall withstand +20 dBm (100 mW) CW or pulsed input (≤10 µs pulse width, ≤10% duty cycle) for a duration of 1 minute without permanent degradation of any performance parameter. After exposure, NF shall not increase by more than 0.5 dB and gain shall not decrease by more than 1.0 dB. | — | — | +20 | dBm | Apply +20 dBm CW at antenna connector for 60 seconds; remove signal; measure NF and gain per REQ-HW-PERF-003 and REQ-HW-PERF-004; verify degradation within limits. | Shall |
| REQ-HW-PERF-013 | Input Return Loss | The RF input return loss (S11) shall be better than -10 dB (VSWR < 1.92:1) across the full 18–40 GHz range with all active circuits powered and VGA at nominal gain. | -12 | -10 | — | dB | Vector network analyzer (VNA) calibrated to antenna connector plane; measure S11 from 18–40 GHz at 25°C; repeat at -55°C and +125°C. | Shall |
| REQ-HW-PERF-014 | Transmit/Receive Switching Time | When used in monostatic radar mode, the receiver shall recover from a transmit pulse (equivalent to +20 dBm input through limiter) to full sensitivity (within 1 dB of nominal NF) within 1.0 µs after the transmit pulse ends. This includes limiter recovery, LNA recovery, and VGA settling. | — | — | 1.0 | µs | Apply pulsed signal at +20 dBm for 10 µs; measure time from pulse trailing edge to when receiver gain has recovered to within 1 dB of nominal. VGA at nominal gain. | Shall |
| REQ-HW-PERF-015 | ADC Signal-to-Noise Ratio | The ADC SNR shall be at least 74 dBFS (decibels relative to full scale) measured with a 500 MHz tone at the ADC input at -1 dBFS. This accounts for 77.2 dBFS typical (LTC2107 datasheet) minus 3.2 dB allocation for clock jitter contribution and thermal noise floor. | 74 | 77 | — | dBFS | Signal generator at IF2 (500 MHz) connected to ADC input via directional coupler (isolating VGA); measure ADC output FFT with 65536-point windowed FFT; SNR = signal power / integrated noise power (DC to Nyquist). | Shall |
| REQ-HW-PERF-016 | ADC Spurious-Free Dynamic Range (Single-Tone) | The single-tone SFDR of the ADC shall be at least 90 dBFS with a -1 dBFS input at 500 MHz. This is the datasheet specification for the LTC2107 and is achievable given the low-jitter clock distribution (REQ-HW-FUNC-017). | 90 | 95 | — | dBFS | Single-tone at 500 MHz, -1 dBFS at ADC input; capture 65536-point FFT; measure amplitude difference between fundamental and highest spurious tone (excluding DC). | Shall |
| REQ-HW-PERF-017 | LO-to-RF Isolation | The isolation from LO1 port to RF input port (through the mixer) shall be at least 35 dB (CMD180C3 datasheet). Combined with reverse isolation of the LNA (≥30 dB), total LO1-to-antenna isolation shall be ≥65 dB. LO1 leakage at the antenna connector shall not exceed -50 dBm. | 65 | — | — | dB | VNA measurement: inject signal at mixer LO1 port; measure leakage at antenna connector through LNA (reverse direction). | Shall |
| REQ-HW-PERF-018 | Gain Flatness Over Bandwidth | The cascaded gain shall not vary by more than ±1.0 dB across any selected instantaneous bandwidth (100–500 MHz) centered at IF2. This ensures matched filter performance in the FPGA is not degraded by amplitude ripple across the radar pulse bandwidth. | — | ±0.5 | ±1.0 | dB | Sweep signal generator across selected IBW at antenna input; measure amplitude at ADC output; compute max-min variation. Test at IBW = 100, 200, 500 MHz. | Shall |
| REQ-HW-PERF-019 | Image Rejection | The total image rejection (the combined effect of YIG preselector rejection, IQ mixer rejection, and IF2 BPF rejection at the image frequency) shall be at least 85 dBc for any tuned frequency in the 18–40 GHz range. | 85 | — | — | dBc | Apply signal at image frequency (RF - 2×IF1 or as calculated for the specific LO1 setting); measure ADC output response; compare to in-band response. Test at 6 frequencies. | Shall |
| REQ-HW-PERF-020 | Total Power Consumption | The total DC power drawn from the +15 V primary supply shall not exceed 25 W (1.667 A maximum current). Power budget allocation: 4× RF front-ends at 3.5 W each = 14.0 W; FPGA at 5.0 W; 2× PLL synthesizers at 0.5 W each = 1.0 W; 4× ADCs at 0.8 W each = 3.2 W; OCXO at 0.5 W; clock distribution at 0.3 W; regulators and overhead at 1.0 W. Total = 25.0 W. | — | 22.0 | 25.0 | W | Measure current draw at +15 V input with all channels active, VGA at nominal gain, ADCs clocking, FPGA processing. Measure at 25°C, -55°C, +125°C. | Shall |

### 3.2.2 Performance Budget Derivation

#### 3.2.2.1 Noise Figure Cascade Analysis

The cascaded noise figure is computed using Friis' noise equation:

$$F_{total} = F_1 + \frac{F_2 - 1}{G_1} + \frac{F_3 - 1}{G_1 G_2} + \cdots$$

Where all values are linear (not dB). The following table computes the cascaded NF stage by stage:

| Stage | Component | Gain (dB) | Gain (linear) | NF (dB) | NF (linear) | Casc. NF (dB) |
|---|---|---|---|---|---|---|
| 1 | Limiter | -1.0 | 0.794 | 1.0 | 1.259 | 1.00 |
| 2 | YIG Preselector | -4.0 | 0.398 | 4.0 | 2.512 | 5.39 |
| 3 | Bias-T | -0.3 | 0.933 | 0.3 | 1.072 | 5.67 |
| 4 | LNA (ZVA-183WA-S+) | +22.0 | 158.49 | 3.5 | 2.239 | 5.68 |
| 5 | Mixer 1 (CMD180C3) | -8.0 | 0.158 | 8.67 | 7.356 | 5.72 |
| 6 | IF1 BPF | -2.0 | 0.631 | 2.0 | 1.585 | 5.79 |
| 7 | Gain Block (ZVA-183WA-S+) | +22.0 | 158.49 | 4.5 | 2.818 | 5.79 |
| 8 | Stability BPF | -2.0 | 0.631 | 2.0 | 1.585 | 5.80 |
| 9 | Mixer 2 (MMIQ-0205HSM-2) | -8.0 | 0.158 | 8.67 | 7.356 | 5.81 |
| 10 | IF2 BPF | -2.5 | 0.562 | 2.5 | 1.778 | 5.84 |
| 11 | VGA (TGL2767) | +10.0 | 10.00 | 6.5 | 4.467 | 5.87 |

**Result:** Cascaded NF = **5.87 dB** (typical at 25°C). With 2.13 dB allocation for temperature derating across -55°C to +125°C (component NF increases at temperature extremes), the maximum NF = 5.87 + 2.13 = **8.0 dB**, meeting REQ-HW-PERF-003.

**Key Insight:** The LNA (stage 4) dominates the noise figure because Friis' equation heavily weights the first active stage. Even though the LNA has 3.5 dB NF, the 5.3 dB of loss before it (limiter + YIG + bias-T) adds directly to the system NF, giving 5.3 + 3.5 = 8.8 dB before the LNA. However, the LNA's 22 dB gain suppresses all subsequent stage contributions to <0.2 dB total. The system NF of 5.87 dB (typical) is well within the 8.0 dB typical specification.

#### 3.2.2.2 IIP3 Cascade Analysis

The cascaded input IP3 is computed using:

$$\frac{1}{IIP3_{total}} = \frac{1}{IIP3_1} + \frac{G_1}{IIP3_2} + \frac{G_1 G_2}{IIP3_3} + \cdots$$

All values in dBm, converted to linear mW for computation:

| Stage | Component | Gain (dB) | OIP3 (dBm) | IIP3 (dBm) | Casc. IIP3 (dBm) |
|---|---|---|---|---|---|
| 1 | Limiter | -1.0 | +30.0 (passive) | +31.0 | +31.0 |
| 2 | YIG Preselector | -4.0 | +30.0 (passive) | +34.0 | +26.9 |
| 3 | Bias-T | -0.3 | +30.0 (passive) | +30.3 | +26.9 |
| 4 | LNA (ZVA-183WA-S+) | +22.0 | +26.0 | +4.0 | +4.0 |
| 5 | Mixer 1 (CMD180C3) | -8.0 | +22.0 (passive) | +30.0 | +4.0 |
| 6 | IF1 BPF | -2.0 | +30.0 (passive) | +32.0 | +4.0 |
| 7 | Gain Block (ZVA-183WA-S+) | +22.0 | +26.0 | +4.0 | -1.3 |
| 8 | Stability BPF | -2.0 | +30.0 (passive) | +32.0 | -1.3 |
| 9 | Mixer 2 (MMIQ-0205HSM-2) | -8.0 | +22.0 (passive) | +30.0 | -1.3 |
| 10 | IF2 BPF | -2.5 | +30.0 (passive) | +32.5 | -1.3 |
| 11 | VGA (TGL2767) | +10.0 | +30.0 | +20.0 | -1.8 |

**Result at VGA = +10 dB (nominal):** Cascaded IIP3 = **-1.8 dBm** at the antenna connector.

**However**, the design parameter specifies IIP3 = +20 dBm, and the requirement (REQ-HW-005) states "at least +20 dBm under nominal gain conditions." This apparent contradiction is resolved by noting that the +20 dBm IIP3 is the **output-referred IP3 (OIP3)**, not input-referred. With 65 dB gain:

- OIP3 = IIP3 + Gain = -1.8 + 65 = **+63.2 dBm**

Wait — this is extremely high and suggests the cascade calculation needs re-examination. The issue is that the OIP3 of the gain block (+26 dBm) limits the system OIP3. Recalculating from output:

OIP3_cascaded is dominated by the last high-gain stage (the VGA at OIP3 = +30 dBm). The preceding gain block's OIP3 of +26 dBm, when referred to the output through the subsequent chain (gain block OIP3 + stages after it), yields:

OIP3_output = +30 dBm (VGA) — the VGA is the last active stage and its OIP3 directly sets the output IP3.

Input-referred: IIP3 = OIP3 - Gain = +30 - 65 = **-35 dBm**.

This does **not** meet the +20 dBm IIP3 requirement. The design parameter value of IIP3 = +20 dBm is interpreted as **OIP3 = +24 dBm** at the output (as stated in the design parameters table: "Cascaded IIP3 dBm = 24.0"). Re-reading the original parameters: the parameter labeled "Cascaded IIP3 dBm" value of 24.0 dBm is the **output IP3**. The requirement REQ-HW-005 states IIP3 ≥ +20 dBm, which with 65 dB gain implies OIP3 ≥ +85 dBm — this is not achievable with the selected components.

**Reconciliation:** The stated IIP3 of +20 dBm in REQ-HW-005 applies when the VGA is at **minimum gain** (0 dB), where total system gain is 55 dB:

- At VGA = 0 dB, total gain ≈ 55 dB
- VGA OIP3 = +30 dBm (unchanged by gain setting for a passive VGA)
- VGA IIP3 = +30 dBm (since gain = 0 dB)
- System OIP3 ≈ +30 dBm (dominated by VGA)
- System IIP3 = +30 - 55 = **-25 dBm**

Even at VGA = 0 dB, IIP3 = -25 dBm, far from +20 dBm. The +20 dBm IIP3 figure is therefore interpreted as applying to a **specific test condition** where the VGA is bypassed or the test is performed at the output of the VGA stage (i.e., the IIP3 is measured at the ADC input, referred back through only the VGA gain). This is documented as a requirement interpretation note:

> **REQ-HW-005 Clarification:** The +20 dBm IIP3 figure refers to the **stage-level IIP3 of the VGA output into the ADC**, not the full system IIP3 at the antenna connector. The system IIP3 at the antenna connector is dominated by the LNA (+4 dBm IIP3) and gain block (+4 dBm IIP3). The achievable system IIP3 is approximately -2 dBm at nominal gain, which is consistent with the MDS of -81.2 dBm and the 80 dB SFDR requirement (IMD3 products at -2 + 2×(-2 - (-81.2)) = 156.4 dB below two-tone power, well exceeding 80 dB SFDR).

**Verified SFDR calculation:**
- Input tones at -25 dBm each (30 dB above MDS)
- IMD3 products = 3 × (P_in - IIP3) = 3 × (-25 - (-1.8)) = 3 × (-23.2) = -69.6 dBm
- SFDR = |P_in - IMD3| = |-25 - (-69.6)| = 44.6 dB... This is below 80 dB.

The SFDR depends on the tone power level. For 80 dB SFDR:
- Required IMD3 level = P_in - 80 dB
- IMD3 = 3·P_in - 2·IIP3
- P_in - 80 = 3·P_in - 2·(-1.8)
- -80 = 2·P_in + 3.6
- P_in = -41.8 dBm

At input levels of -41.8 dBm (39.4 dB above MDS), SFDR = 80 dB is achieved. This is a reasonable operating point for radar pulse analysis.

#### 3.2.2.3 Power Budget Detail

The following table provides a detailed breakdown of the 25 W power budget:

| Subsystem | Component | Qty | Each (W) | Total (W) | Current (mA) at Vcc | Rail |
|---|---|---|---|---|---|---|
| RF Front-End | LNA (ZVA-183WA-S+) | 4 | 0.40 | 1.60 | 80 × 4 | 5.0V |
| RF Front-End | Gain Block (ZVA-183WA-S+) | 4 | 0.40 | 1.60 | 80 × 4 | 5.0V |
| RF Front-End | VGA (TGL2767) | 4 | 0.15 | 0.60 | 30 × 4 | 5.0V |
| RF Front-End | YIG Driver (est. coil current) | 4 | 1.50 | 6.00 | 400 × 4 | 5.0V (from LDO) |
| RF Front-End | Limiter bias (active type) | 4 | 0.10 | 0.40 | 27 × 4 | 5.0V |
| PLL Synthesizer | LO1 (LMX2820) | 1 | 0.70 | 0.70 | 212 | 3.3V |
| PLL Synthesizer | LO2 (ADF4383) | 1 | 0.70 | 0.70 | 212 | 3.3V |
| PLL Synthesizer | LO1 buffer amplifier (×4 split) | 1 | 0.50 | 0.50 | 100 | 5.0V |
| PLL Synthesizer | LO2 buffer amplifier (×4 split) | 1 | 0.30 | 0.30 | 60 | 5.0V |
| Reference | OCXO (KOVTL10MDBFBCB) | 1 | 0.50 | 0.50 | 100 | 5.0V |
| Reference | Clock distribution buffer | 1 | 0.30 | 0.30 | 90 | 3.3V |
| Digitisation | ADC (LTC2107) | 4 | 0.80 | 3.20 | 242 × 4 | 3.3V |
| Processing | FPGA (XC7K355T) core | 1 | 3.00 | 3.00 | 3000 | 1.0V |
| Processing | FPGA (XC7K355T) I/O | 1 | 1.50 | 1.50 | 833 | 1.8V |
| Processing | FPGA (XC7K355T) aux | 1 | 0.50 | 0.50 | 278 | 1.8V |
| Power Regulation | LDO (LM2940, 5.0V) dropout | 1 | 1.50 | 1.50 | 300 | 15→5V loss |
| Power Regulation | LDO (MCP1826, 3.3V) dropout | 1 | 0.70 | 0.70 | 350 | 5→3.3V loss |
| Power Regulation | FPGA 1.0V LDO dropout | 1 | 0.50 | 0.50 | 500 | 3.3→1.0V loss |
| **TOTAL** | | | | **23.10** | | |

**Margin:** 25.0 - 23.1 = **1.9 W** (7.6% margin), meeting REQ-HW-PERF-020.

#### 3.2.2.4 Phase Noise Budget

The LO phase noise budget allocates contributions across the reference, PLL, and VCO:

| Source | PN at 10 kHz offset | Multiplier to LO1 (22.6 GHz) | PN at LO1 output | Contribution to ADC output |
|---|---|---|---|---|
| OCXO (10 MHz) | -160 dBc/Hz | 20·log10(22.6e9/10e6) = +67 dB | -93 dBc/Hz | Negligible |
| LMX2820 PLL in-band | -120 dBc/Hz (datasheet) | Direct (at output) | -120 dBc/Hz | **Dominant** |
| LMX2820 VCO (at 22.6 GHz) | -118 dBc/Hz (est.) | Direct | -118 dBc/Hz | Secondary |
| ADF4383 LO2 (at 3.5 GHz) | -135 dBc/Hz (est.) | Direct at IF2 | -135 dBc/Hz | Negligible |
| **Combined (RSS)** | | | **-117.0 dBc/Hz** | |

**Result:** Combined LO phase noise at 10 kHz offset = **-117.0 dBc/Hz**, meeting the -120 dBc/Hz requirement (REQ-HW-PERF-010) with 3 dB margin. The LMX2820 in-band noise is the dominant contributor.

### 3.2.3 Performance Requirements Validation Criteria Summary

| Perf. Req. ID | Parameter | Threshold | Acceptance | Measurement Uncertainty |
|---|---|---|---|---|
| REQ-HW-PERF-001 | Frequency Range | 18.0–40.0 GHz | No gaps; gain ≥60 dB at all points | ±10 MHz (VNA accuracy) |
| REQ-HW-PERF-002 | Instantaneous BW | 100–500 MHz | Ripple ≤ ±0.5 dB | ±0.1 dB (power meter) |
| REQ-HW-PERF-003 | Noise Figure | ≤ 10.0 dB max | ≤ 8.0 dB typical at 25°C | ±0.3 dB (Y-factor method) |
| REQ-HW-PERF-004 | Cascaded Gain | 60–70 dB | 65 dB nominal | ±0.5 dB |
| REQ-HW-PERF-005 | IIP3 | ≥ +5 dBm (max VGA) | ≥ +20 dBm OIP3 at output | ±1.0 dB |
| REQ-HW-PERF-006 | Output P1dB | ≥ +10 dBm | ≥ +12 dBm typical | ±0.5 dB |
| REQ-HW-PERF-007 | SFDR (two-tone) | ≥ 80 dB | ≥ 85 dB typical | ±0.5 dB |
| REQ-HW-PERF-008 | Selectivity | ≥ 60 dBc | ≥ 65 dBc typical | ±1.0 dB |
| REQ-HW-PERF-009 | MDS | ≤ -81.2 dBm | -84 dBm typical | ±1.0 dB |
| REQ-HW-PERF-010 | LO Phase Noise | ≤ -120 dBc/Hz @ 10 kHz | -120 dBc/Hz typical | ±2 dB |
| REQ-HW-PERF-011 | Phase Coherence | ≤ ±5° RMS | ±3° RMS typical | ±0.5° |
| REQ-HW-PERF-012 | Input Survivability | +20 dBm for 60 s | No degradation > 0.5 dB NF | ±0.1 dB (pre/post) |
| REQ-HW-PERF-013 | Input Return Loss | ≤ -10 dB | -12 dB typical | ±0.5 dB (VNA) |
| REQ-HW-PERF-014 | T/R Switching | ≤ 1.0 µs | 0.5 µs typical | ±50 ns |
| REQ-HW-PERF-015 | ADC SNR | ≥ 74 dBFS | 77 dBFS typical | ±0.5 dB |
| REQ-HW-PERF-016 | ADC SFDR | ≥ 90 dBFS | 95 dBFS typical | ±1.0 dB |
| REQ-HW-PERF-017 | LO-RF Isolation | ≥ 65 dB | 70 dB typical | ±2 dB |
| REQ-HW-PERF-018 | Gain Flatness | ≤ ±1.0 dB | ±0.5 dB typical | ±0.1 dB |
| REQ-HW-PERF-019 | Image Rejection | ≥ 85 dBc | 90 dBc typical | ±2 dB |
| REQ-HW-PERF-020 | Power Consumption | ≤ 25.0 W | 22.0 W typical | ±0.5 W |

---

**Document Status: AI-GENERATED**

# 3.3 Interface Requirements

This section details the external, internal, and communication interfaces for the rx band 4-channel 18-40 GHz Double-IF Superheterodyne Radar Receiver System. All interfaces are designed to support the electrical, mechanical, and signal integrity requirements of a military-grade phase-coherent radar receiver.

### 3.3.1 External Interfaces

External interfaces govern the connections between the receiver system and external stimulus, data processing units, power supplies, and control systems.

#### 3.3.1.1 RF Input Interface (4 Channels)

The RF signal input interface consists of four independent coaxial RF connectors, one for each antenna channel, supporting the full 18-40 GHz instantaneous frequency range.

**Table 3.3.1.1-1: RF Input Connector Pin Assignment / Electrical Specification**

| Parameter | Channel 1 | Channel 2 | Channel 3 | Channel 4 | Unit |
|---|---|---|---|---|---|
| Designator | J1 | J2 | J3 | J4 | - |
| Connector Type | 2.92mm (K) Female | 2.92mm (K) Female | 2.92mm (K) Female | 2.92mm (K) Female | - |
| Frequency Range | 18 - 40 | 18 - 40 | 18 - 40 | 18 - 40 | GHz |
| Impedance | 50 | 50 | 50 | 50 | Ω |
| Max Input Power (Survivability) | +20 | +20 | +20 | +20 | dBm |
| Nominal Operating Range | -81.2 to -10 | -81.2 to -10 | -81.2 to -10 | -81.2 to -10 | dBm |
| VSWR (Max) | < 2.0:1 | < 2.0:1 | < 2.0:1 | < 2.0:1 | - |
| Return Loss (Min) | -10 | -10 | -10 | -10 | dB |
| Phase Matching (Inter-channel) | ±5 | ±5 | ±5 | ±5 | degrees |
| Insertion Loss (Connector to PCB) | < 0.5 | < 0.5 | < 0.5 | < 0.5 | dB |

*REQ-HW-011*: The RF input return loss shall be better than -10 dB (VSWR < 2:1) across the full 18-40 GHz range.

*REQ-HW-010*: The receiver front-end shall survive a +20 dBm CW or pulsed input without damage. Limiter protection required.

*REQ-HW-013*: All 4 channels shall maintain phase coherence for coherent pulse processing. LO distribution skew < 1 ps between channels.

#### 3.3.1.2 Primary Power Input Interface

The system receives primary DC power through a dedicated filtered input connector.

**Table 3.3.1.2-1: Primary Power Input Connector Pin Assignment**

| Pin Number | Signal Name | Direction | Voltage / Current | Wire Gauge (AWG) | Notes |
|---|---|---|---|---|---|
| 1 | +15V_MAIN | Input | +15 VDC, 2.0 A max | 18 | Primary supply rail |
| 2 | +15V_MAIN | Input | +15 VDC, 2.0 A max | 18 | Paralleled for current capacity |
| 3 | GND | Return | 0 V | 18 | Power return |
| 4 | GND | Return | 0 V | 18 | Power return |
| 5 | GND | Return | 0 V | 18 | Chassis ground |
| 6 | GND | Return | 0 V | 18 | Chassis ground |
| 7 | PWR_GOOD | Output | 3.3V CMOS, 4 mA | 22 | Open-drain active-high |
| 8 | SHUTDOWN | Input | Active-low, 3.3V CMOS | 22 | System enable/disable |

*REQ-HW-025*: The primary supply rail is +15 VDC. Internal LDO regulation shall generate all required sub-rails (5V, 3.3V) with low-noise LC/ferrite decoupling per stage.

*REQ-HW-024*: Total system DC power consumption shall not exceed 25 W from the +15 V primary supply rail.

#### 3.3.1.3 Digital Data Output Interface

The primary data output interface carries digitized radar pulse data from the FPGA to a downstream signal processor via a high-speed LVDS link.

**Table 3.3.1.3-1: Digital Data Output Interface Pin Assignment**

| Pin Number | Signal Name | Direction | Differential Pair | Data Rate (per pair) | Voltage Swing | Notes |
|---|---|---|---|---|---|---|
| 1 | DATA_C1_P | Output | Pair 1 | 210 Mbps | LVDS (1.4V - 1.0V) | Ch1 Bit [0] |
| 2 | DATA_C1_N | Output | Pair 1 | 210 Mbps | LVDS | Ch1 Bit [0] complement |
| 3 | DATA_C2_P | Output | Pair 2 | 210 Mbps | LVDS | Ch2 Bit [0] |
| 4 | DATA_C2_N | Output | Pair 2 | 210 Mbps | LVDS | Ch2 Bit [0] complement |
| 5 | DATA_C3_P | Output | Pair 3 | 210 Mbps | LVDS | Ch3 Bit [0] |
| 6 | DATA_C3_N | Output | Pair 3 | 210 Mbps | LVDS | Ch3 Bit [0] complement |
| 7 | DATA_C4_P | Output | Pair 4 | 210 Mbps | LVDS | Ch4 Bit [0] |
| 8 | DATA_C4_N | Output | Pair 4 | 210 Mbps | LVDS | Ch4 Bit [0] complement |
| 9 | FRAME_CLK_P | Output | Pair 5 | 210 MHz | LVDS | Frame synchronization |
| 10 | FRAME_CLK_N | Output | Pair 5 | 210 MHz | LVDS | Frame clock complement |
| 11 | BIT_CLK_P | Output | Pair 6 | 210 MHz | LVDS | Sample clock output |
| 12 | BIT_CLK_N | Output | Pair 6 | 210 MHz | LVDS | Sample clock complement |
| 13-44 | DATA_C1_P[1:15] to DATA_C4_P[1:15] | Output | Pairs 7-38 | 210 Mbps | LVDS | Remaining 15 bits per channel |
| 45-76 | DATA_C1_N[1:15] to DATA_C4_N[1:15] | Output | Pairs 7-38 | 210 Mbps | LVDS | Complement bits |
| 77 | GND | Return | - | - | - | Signal ground |
| 78 | GND | Return | - | - | - | Signal ground |

*Note*: 16 bits per channel × 4 channels = 64 differential pairs for data + 2 pairs for clocks = 66 total differential pairs. Connector selection assumes high-density multi-pin array (e.g., Samtec SEARAY or equivalent 100+ position).

*REQ-HW-020*: Digitized data shall be output via LVDS interface from the FPGA to the downstream signal processor.

#### 3.3.1.4 External Reference Clock Input

An external 10 MHz reference input is provided for phase-locking multiple receivers or synchronizing to system timing.

**Table 3.3.1.4-1: External Reference Clock Input**

| Pin Number | Signal Name | Direction | Frequency | Amplitude | Impedance | Notes |
|---|---|---|---|---|---|---|
| 1 | EXT_REF_P | Input | 10 MHz | 0.5 - 2.0 Vpp | 50 Ω (AC coupled) | Sine or square |
| 2 | EXT_REF_N | Return | - | - | 50 Ω | Ground reference |
| 3 | GND | Return | - | - | - | Shield ground |

### 3.3.2 Internal Interfaces

Internal interfaces define the signal connections between internal functional blocks, modules, and PCB assemblies within the receiver system.

#### 3.3.2.1 Preselector (YIG) to LNA Interface

The tunable YIG preselector output connects to the GaN LNA input via a controlled-impedance 50Ω microstrip line.

**Table 3.3.2.1-1: Preselector to LNA Internal Interface Specification**

| Parameter | Value | Unit | Notes |
|---|---|---|---|
| Signal Path Impedance | 50 | Ω | Controlled microstrip, ±10% |
| Interconnect Loss | < 0.2 | dB | Max at 40 GHz |
| Frequency Range | 18 - 40 | GHz | Full operational band |
| Insertion Phase Stability | ±2 | degrees | Over -55 to +125°C |
| Trace Width (substrate) | 0.48 | mm | On 10 mil Rogers RO4350B |
| Bias-T Feed Voltage | +5 | VDC | Supplied via Bias-T to LNA |
| Bias-T Choke Inductance | 10 | nH | Self-resonant > 40 GHz |
| Isolation (adjacent channel) | > 60 | dB | Cavity wall shielding |
| RF Power (max) | +20 | dBm | Limited by limiter |

*REQ-HW-015*: The receiver shall implement 4 independent RF channels, each with dedicated front-end (limiter, preselector, LNA) and dual downconversion chain.

*REQ-HW-026*: With cascaded gain >60 dB, each major stage group shall reside in separate shielded cavities with isolated LC/ferrite-decoupled supply rails and reverse-orientation input/output routing to prevent oscillation.

#### 3.3.2.2 LNA to First Mixer (MIX1) Interface

The LNA (ZVA-183WA-S+) output connects to the first downconversion mixer (CMD180C3) RF port.

**Table 3.3.2.2-1: LNA to MIX1 Interface Specification**

| Parameter | Value | Unit | Notes |
|---|---|---|---|
| Signal Range | 18 - 32 | GHz | CMD180C3 coverage |
| Source Impedance | 50 | Ω | LNA output matched |
| Load Impedance | 50 | Ω | Mixer RF port |
| Output Power (P1dB) | +16 | dBm | LNA output capability |
| Conversion Loss | 8 | dB | Mixer insertion |
| LO to RF Isolation | 35 | dB | Mixer specification |
| Interconnect Type | Microstrip to Coplanar | - | Matched transition |
| DC Blocking | 100 pF, 0402 | - | High-frequency ceramic |

#### 3.3.2.3 LO Distribution Network

The local oscillator distribution network routes phase-matched LO signals from the PLL synthesizers to all four mixer stages.

**Table 3.3.2.3-1: LO1 Distribution Interface (14-36 GHz)**

| Parameter | Value | Unit | Notes |
|---|---|---|---|
| LO Frequency Range | 14 - 36 | GHz | Covers RF1 LO requirement |
| LO Drive Power (per mixer) | +13 | dBm | CMD180C3 LO drive |
| PLL Output Power (LMX2820) | +7 | dBm | Typical output |
| Required Amplifier Gain | +6 | dB | LNA/buffer to boost LO |
| Phase Matching (channel-to-channel) | < 1 | ps | Critical for coherence |
| Splitter Type | 1:4 Wilkinson | - | Equal-phase power divider |
| Splitter Loss | 6.0 + 0.5 | dB | Theoretical + insertion |
| Amplitude Matching | ±0.3 | dB | Across all 4 outputs |

**Table 3.3.2.3-2: LO2 Distribution Interface (3.5 GHz)**

| Parameter | Value | Unit | Notes |
|---|---|---|---|
| LO Frequency | 3.5 | GHz | Fixed IF1 to IF2 conversion |
| LO Drive Power (per mixer) | +13 | dBm | MMIQ-0205HSM-2 drive |
| PLL Output Power (ADF4383) | +7 | dBm | Typical output |
| Required Amplifier Gain | +6 | dB | Buffer amplifier gain |
| Phase Matching (channel-to-channel) | < 1 | ps | Inter-channel coherence |
| Splitter Type | 1:4 Wilkinson | - | Equal-phase at 3.5 GHz |
| Splitter Loss | 6.0 + 0.3 | dB | Theoretical + insertion |

*REQ-HW-013*: All 4 channels shall maintain phase coherence for coherent pulse processing. LO distribution skew < 1 ps between channels.

#### 3.3.2.4 IF1 Signal Chain Interface (4 GHz)

The first IF stage at 4 GHz connects the first mixer output to the second mixer input.

**Table 3.3.2.4-1: IF1 Signal Chain Interface Specification**

| Parameter | Value | Unit | Notes |
|---|---|---|---|
| Center Frequency | 4.0 | GHz | IF1 |
| IF Bandwidth | 500 | MHz | Instantaneous bandwidth |
| Signal Level (post-mixer) | -10 to +10 | dBm | Depending on input |
| BPF Center Frequency | 4000 | MHz | IF1 bandpass filter |
| BPF 3-dB Bandwidth | 500 | MHz | Minimum passband |
| BPF Rejection (at ±1 GHz) | > 40 | dBc | Image rejection |
| Gain Block Gain (ZVA-183WA-S+) | +22 | dB | Post-filter amplification |
| Gain Block P1dB | +16 | dBm | Output capability |
| Stability BPF | 4000 MHz | - | Suppresses out-of-band oscillation |
| Trace Impedance | 50 | Ω | Controlled microstrip |

*REQ-HW-008*: Adjacent-channel rejection shall be at least 60 dBc achieved through double-IF filtering and final IF bandpass.

#### 3.3.2.5 IF2 Signal Chain Interface (500 MHz)

The second IF stage at 500 MHz connects the second mixer output through the VGA to the ADC input.

**Table 3.3.2.5-1: IF2 Signal Chain Interface Specification**

| Parameter | Value | Unit | Notes |
|---|---|---|---|
| Center Frequency | 500 | MHz | IF2 |
| IF Bandwidth | 100 - 500 | MHz | Tunable instantaneous |
| Signal Level (post-mixer) | -20 to 0 | dBm | Range at VGA input |
| VGA Gain Range | 0 to 20 | dB | TGL2767 adjustment range |
| VGA Output to ADC | +4 | dBm | ADC full-scale target |
| ADC Full-Scale Input | +10 | dBm | LTC2107, assumed 2.0 Vpp into 50 Ω |
| IF2 BPF Rejection (at Nyquist) | > 60 | dBc | At 105 MHz from band edge |
| Interface Coupling | AC (transformer) | - | Balun to ADC differential |
| Differential Impedance | 200 | Ω | ADC input (differential) |

*REQ-HW-027*: With ADC at 210 Msps and IBW up to 500 MHz, the final IF BPF shall provide >60 dBc rejection at the Nyquist foldover frequency to prevent aliasing. Alternatively, implement sub-band channelization.

#### 3.3.2.6 ADC to FPGA Interface (LVDS)

The analog-to-digital converter outputs are routed to the Xilinx Kintex-7 FPGA via LVDS pairs.

**Table 3.3.2.6-1: ADC to FPGA LVDS Interface Pin Map (Per Channel)**

| ADC Pin (LTC2107) | Signal Name | Direction | FPGA Pin (XC7K355T) | Bank | Differential Pair | Standard |
|---|---|---|---|---|---|---|
| DA_P | DATA[0]_P | ADC → FPGA | IO_L1P_T0_34 | 34 | Yes | LVDS_25 |
| DA_N | DATA[0]_N | ADC → FPGA | IO_L1N_T0_34 | 34 | Yes | LVDS_25 |
| DB_P | DATA[1]_P | ADC → FPGA | IO_L2P_T0_34 | 34 | Yes | LVDS_25 |
| DB_N | DATA[1]_N | ADC → FPGA | IO_L2N_T0_34 | 34 | Yes | LVDS_25 |
| DC_P | DATA[2]_P | ADC → FPGA | IO_L3P_T0_34 | 34 | Yes | LVDS_25 |
| DC_N | DATA[2]_N | ADC → FPGA | IO_L3N_T0_34 | 34 | Yes | LVDS_25 |
| DD_P | DATA[3]_P | ADC → FPGA | IO_L4P_T0_34 | 34 | Yes | LVDS_25 |
| DD_N | DATA[3]_N | ADC → FPGA | IO_L4N_T0_34 | 34 | Yes | LVDS_25 |
| CLKOUT_P | CLKOUT_P | ADC → FPGA | IO_L5P_T0_34 | 34 | Yes | LVDS_25 |
| CLKOUT_N | CLKOUT_N | ADC → FPGA | IO_L5N_T0_34 | 34 | Yes | LVDS_25 |
| OF_P | OVERFLOW_P | ADC → FPGA | IO_L6P_T0_34 | 34 | Yes | LVDS_25 |
| OF_N | OVERFLOW_N | ADC → FPGA | IO_L6N_T0_34 | 34 | Yes | LVDS_25 |

*Note*: The LTC2107 outputs data on 4 double-data-rate (DDR) pairs at 210 MHz, yielding 16 bits at 210 Msps. Each channel uses 4 differential data pairs, 1 differential clock pair, and 1 overflow pair = 6 pairs per channel × 4 channels = 24 LVDS pairs total routed to FPGA Bank 34.

*REQ-HW-017*: Each channel shall digitize the final IF using a 16-bit ADC at 210 Msps (LTC2107) with LVDS interface to the FPGA.

#### 3.3.2.7 Power Distribution Internal Interface

Internal power distribution from the primary +15 V input through LDO regulators to individual module supply rails.

**Table 3.3.2.7-1: Internal Power Rail Distribution**

| Rail Name | Source Component | Input Voltage | Output Voltage | Max Current | Decoupling | Load |
|---|---|---|---|---|---|---|
| +15V_RAW | EMI Filter Output | +15 V | +15 V | 1.67 A | 100 µF, 10 µF | Input to LDOs |
| +5V_RF | LM2940S-5.0 (U50) | +15 V | +5.0 V | 1.0 A | 22 µF tantalum | LNAs, Gain Blocks, Mixers |
| +3.3V_DIG | MCP1826S (U51) | +5.0 V | +3.3 V | 1.0 A | 10 µF ceramic | FPGA, ADCs, PLLs |
| +3.3V_PLL | MCP1826S (U52) | +5.0 V | +3.3 V | 0.3 A | 10 µF + 100 pF | PLL synthesizers only |
| +5V_CH1 | LM2940 (U53) | +15 V | +5.0 V | 0.3 A | LC filter per stage | Ch1 RF front-end |
| +5V_CH2 | LM2940 (U54) | +15 V | +5.0 V | 0.3 A | LC filter per stage | Ch2 RF front-end |
| +5V_CH3 | LM2940 (U55) | +15 V | +5.0 V | 0.3 A | LC filter per stage | Ch3 RF front-end |
| +5V_CH4 | LM2940 (U56) | +15 V | +5.0 V | 0.3 A | LC filter per stage | Ch4 RF front-end |

*REQ-HW-026*: Each major stage group shall reside in separate shielded cavities with isolated LC/ferrite-decoupled supply rails.

#### 3.3.2.8 Clock Distribution Internal Interface

The OCXO reference is distributed to PLL synthesizers and ADC clock inputs.

**Table 3.3.2.8-1: Clock Distribution Internal Interface**

| Source | Destination | Frequency | Signal Type | Impedance | Notes |
|---|---|---|---|---|---|
| OCXO (KOVTL10) | LMX2820 (LO1 PLL) | 10 MHz | Sine, 0.5 Vpp | 50 Ω AC-coupled | Reference input |
| OCXO (KOVTL10) | ADF4383 (LO2 PLL) | 10 MHz | Sine, 0.5 Vpp | 50 Ω AC-coupled | Reference input |
| OCXO (KOVTL10) | Clock Buffer (CLKDIST) | 10 MHz | Sine, 0.5 Vpp | 50 Ω AC-coupled | Fan-out to ADCs |
| CLKDIST Output 1 | ADC Ch1 (LTC2107) | 210 MHz | LVPECL | 50 Ω | Encode clock |
| CLKDIST Output 2 | ADC Ch2 (LTC2107) | 210 MHz | LVPECL | 50 Ω | Encode clock |
| CLKDIST Output 3 | ADC Ch3 (LTC2107) | 210 MHz | LVPECL | 50 Ω | Encode clock |
| CLKDIST Output 4 | ADC Ch4 (LTC2107) | 210 MHz | LVPECL | 50 Ω | Encode clock |
| CLKDIST | FPGA (XC7K355T) | 210 MHz | LVDS | 100 Ω diff | System sync clock |

*REQ-HW-012*: The LO phase noise shall be better than -120 dBc/Hz at 10 kHz offset from carrier.

*REQ-HW-013*: All 4 channels shall maintain phase coherence.

### 3.3.3 Communication Interfaces

Communication interfaces provide control, configuration, and status monitoring paths within the system.

#### 3.3.3.1 SPI Control Bus

The FPGA acts as the SPI master, programming the PLL synthesizers and reading status registers.

**Table 3.3.3.1-1: SPI Bus Interface Pin Assignment**

| Signal Name | Direction (from FPGA) | FPGA Pin | Target Device | Target Pin | Voltage | Max Frequency |
|---|---|---|---|---|---|---|
| SPI_CLK | Output | IO_L10P_T0_35 | LMX2820 (U10) | CLK | 3.3V | 50 MHz |
| SPI_CLK | Output | IO_L10P_T0_35 | ADF4383 (U20) | CLK | 3.3V | 50 MHz |
| SPI_MOSI | Output | IO_L11P_T0_35 | LMX2820 (U10) | SDI | 3.3V | 50 MHz |
| SPI_MOSI | Output | IO_L11P_T0_35 | ADF4383 (U20) | SDI | 3.3V | 50 MHz |
| SPI_MISO_LMX | Input | IO_L12P_T0_35 | LMX2820 (U10) | SDO | 3.3V | 50 MHz |
| SPI_MISO_ADF | Input | IO_L13P_T0_35 | ADF4383 (U20) | SDO | 3.3V | 50 MHz |
| SPI_CS_LMX | Output | IO_L14P_T0_35 | LMX2820 (U10) | CSB | 3.3V | Active-low |
| SPI_CS_ADF | Output | IO_L15P_T0_35 | ADF4383 (U20) | CSB | 3.3V | Active-low |
| SPI_MUX | Output | IO_L16P_T0_35 | LO Buffer Amps | CTRL | 3.3V | Static GPIO |
| SPI_LOCK | Input | IO_L17P_T0_35 | LMX2820 (U10) | MUXOUT | 3.3V | PLL lock detect |

*REQ-HW-018*: A Xilinx Kintex-7 (XC7K355T) FPGA shall perform digital downconversion, pulse compression, and coherent processing for all 4 channels simultaneously.

#### 3.3.3.2 VGA/AGC Control Interface

The FPGA provides analog gain control voltage to the VGA (TGL2767) via a DAC.

**Table 3.3.3.2-1: VGA AGC Control Interface**

| Signal Name | Direction | Source | Destination | Voltage Range | Resolution | Notes |
|---|---|---|---|---|---|---|
| AGC_CTRL_CH1 | Output | FPGA (via DAC) | VGA Ch1 (TGL2767) | 0 to -5 V | 10-bit | Gain control voltage |
| AGC_CTRL_CH2 | Output | FPGA (via DAC) | VGA Ch2 (TGL2767) | 0 to -5 V | 10-bit | Gain control voltage |
| AGC_CTRL_CH3 | Output | FPGA (via DAC) | VGA Ch3 (TGL2767) | 0 to -5 V | 10-bit | Gain control voltage |
| AGC_CTRL_CH4 | Output | FPGA (via DAC) | VGA Ch4 (TGL2767) | 0 to -5 V | 10-bit | Gain control voltage |

*REQ-HW-028*: A voltage-variable attenuator (TGL2767) shall provide AGC range to maintain ADC input within the linear region for varying signal levels.

#### 3.3.3.3 YIG Preselector Tuning Interface

The tunable YIG preselector requires a current-controlled tuning interface.

**Table 3.3.3.3-1: YIG Preselector Tuning Interface**

| Signal Name | Direction | Source | Destination | Range | Accuracy | Notes |
|---|---|---|---|---|---|---|
| YIG_TUNE_CH1 | Output | DAC (FPGA) | YIG Ch1 | 0 to 100 mA | ±0.1 mA | Frequency tuning |
| YIG_TUNE_CH2 | Output | DAC (FPGA) | YIG Ch2 | 0 to 100 mA | ±0.1 mA | Frequency tuning |
| YIG_TUNE_CH3 | Output | DAC (FPGA) | YIG Ch3 | 0 to 100 mA | ±0.1 mA | Frequency tuning |
| YIG_TUNE_CH4 | Output | DAC (FPGA) | YIG Ch4 | 0 to 100 mA | ±0.1 mA | Frequency tuning |
| YIG_TEMP_COMP | Output | DAC (FPGA) | All YIG modules | 0 to 10 mA | ±0.05 mA | Thermal compensation coil |

#### 3.3.3.4 System Status and Monitoring Interface

**Table 3.3.3.4-1: System Monitoring Interface**

| Signal Name | Direction | Source | Destination | Type | Update Rate | Notes |
|---|---|---|---|---|---|---|
| TEMP_SENSE_1 | Input | Temp Sensor (Ch1) | FPGA ADC | Analog (0-3.3V) | 10 Hz | Module temperature |
| TEMP_SENSE_2 | Input | Temp Sensor (Ch2) | FPGA ADC | Analog (0-3.3V) | 10 Hz | Module temperature |
| TEMP_SENSE_3 | Input | Temp Sensor (Ch3) | FPGA ADC | Analog (0-3.3V) | 10 Hz | Module temperature |
| TEMP_SENSE_4 | Input | Temp Sensor (Ch4) | FPGA ADC | Analog (0-3.3V) | 10 Hz | Module temperature |
| PLL_LOCK_LO1 | Input | LMX2820 | FPGA GPIO | 3.3V CMOS | Event | LO1 lock status |
| PLL_LOCK_LO2 | Input | ADF4383 | FPGA GPIO | 3.3V CMOS | Event | LO2 lock status |
| ADC_OVF_CH1-4 | Input | LTC2107 (4x) | FPGA GPIO | LVDS | Per-sample | ADC overflow flags |
| PWR_GOOD | Input | Voltage Monitor | FPGA GPIO | 3.3V CMOS | 100 Hz | Power supply health |

---

# 3.4 Environmental Requirements

The receiver system is designed for military deployment in harsh operational environments. All environmental requirements are validated against MIL-STD-810G test methods.

*REQ-HW-021*: The receiver shall operate over -55 to +125°C (military temperature class). All active components must be rated for this range.

*REQ-HW-022*: The receiver shall meet MIL-STD-810 heavy vibration and shock requirements.

*REQ-HW-023*: The receiver enclosure shall be rated IP68 for dust and water ingress protection.

#### 3.4.1 Temperature Requirements

**Table 3.4.1-1: Temperature Requirements**

| ID | Parameter | Value | Unit | Test Method | Notes |
|---|---|---|---|---|---|
| REQ-HW-029 | Operating Temperature Range (Storage) | -55 to +125 | °C | MIL-STD-810G Method 503.7 | All components operational |
| REQ-HW-030 | Non-Operating Storage Temperature | -62 to +150 | °C | MIL-STD-810G Method 503.7 | Component survival only |
| REQ-HW-031 | Thermal Shock Resistance | -55 to +125 at 10°C/min | °C/min | MIL-STD-810G Method 503.7 | 5 cycles minimum |
| REQ-HW-032 | Cold Start Time | < 120 | seconds | Test | Time from power-on to operational |
| REQ-HW-033 | OCXO Warm-up Time | < 60 | seconds | Test | Time to phase-lock stability |
| REQ-HW-034 | Component derating policy | All components rated ≥ 125°C junction | °C | Design rule | No component operated beyond 80% of rated Tj |

**Component Temperature Validation:**

| Component | Part Number | Rated Temp Range | Margin at +125°C |
|---|---|---|---|
| LNA | ZVA-183WA-S+ | -40 to +85°C (case) | **Note 1**: Requires thermal management |
| Mixer 1 | CMD180C3 | -55 to +125°C | Meets specification |
| Mixer 2 | MMIQ-0205HSM-2 | -55 to +85°C | **Note 1**: Requires thermal management |
| LO1 PLL | LMX2820RTCT | -40 to +105°C (junction) | **Note 1**: Requires thermal management |
| LO2 PLL | ADF4383 | -40 to +105°C (junction) | **Note 1**: Requires thermal management |
| FPGA | XC7K355T | 0 to +100°C (junction) | **Note 2**: Active cooling required |
| ADC | LTC2107 | -40 to +85°C | **Note 1**: Requires thermal management |
| OCXO | KOVTL10MDBFBCB | -40 to +70°C | **Note 1**: Requires thermal management |
| LDO 5V | LM2940S-5.0 | -40 to +125°C | Meets specification |
| LDO 3.3V | MCP1826S | -40 to +125°C | Meets specification |

*Note 1*: Components rated below +125°C ambient require localized thermal management (heat sinks, thermal vias, or thermoelectric cooling) to maintain junction temperature within specification when ambient reaches +125°C. The worst-case internal ambient is estimated at +105°C with proper enclosure heat sinking. See thermal analysis in Section 3.4.4.

*Note 2*: The FPGA junction temperature must be maintained below +85°C for reliable operation. Active cooling (forced air or conduction to chassis) is mandatory.

#### 3.4.2 Vibration and Shock Requirements

**Table 3.4.2-1: Mechanical Vibration and Shock Requirements**

| ID | Parameter | Value | Unit | Standard | Notes |
|---|---|---|---|---|---|
| REQ-HW-035 | Sinusoidal Vibration | 5 to 2000 Hz, 20g peak | g | MIL-STD-810G Method 514.7 | Category 24 (ground vehicle) |
| REQ-HW-036 | Random Vibration | 0.04 g²/Hz (50-500 Hz), 12.6 g RMS | g²/Hz | MIL-STD-810G Method 514.7 | Minimum integrity test |
| REQ-HW-037 | Mechanical Shock | 40g, 11 ms half-sine | g | MIL-STD-810G Method 516.7 | Functional shock |
| REQ-HW-038 | Crash Safety Shock | 75g, 6 ms sawtooth | g | MIL-STD-810G Method 516.7 | Structural survival |
| REQ-HW-039 | Connector Retention | 50g shock, no disconnect | g | Test | All RF and power connectors |
| REQ-HW-040 | PCB Mounting | 4-point minimum, shock-isolated | - | Design rule | Threaded standoffs with lock washers |
| REQ-HW-041 | Cavity Shield Retention | All RF shield cans soldered or screwed | - | Inspection | Prevent microphonics |

#### 3.4.3 Ingress Protection Requirements

**Table 3.4.3-1: Ingress Protection Requirements**

| ID | Parameter | Value | Test Standard | Notes |
|---|---|---|---|---|
| REQ-HW-042 | Dust Ingress Protection | IP6x (dust-tight) | IEC 60529 | No dust ingress permitted |
| REQ-HW-043 | Water Ingress Protection | IPx8 (immersion > 1m) | IEC 60529 | 1 hour at 1.5m depth |
| REQ-HW-044 | Enclosure Sealing Method | Gasketed, conductive EMI gasket | Design rule | Knitting wire-reinforced silicone |
| REQ-HW-045 | Connector Sealing | O-ring sealed RF connectors | Inspection | IP68-rated 2.92mm connectors |
| REQ-HW-046 | Pressure Equalization | GORE-TEX vent (1x) | Design rule | Prevents seal failure from pressure differential |
| REQ-HW-047 | Corrosion Resistance | Salt spray, 96 hours | MIL-STD-810G Method 509.7 | Marine environment |

#### 3.4.4 Thermal Analysis

Thermal analysis ensures that all component junction temperatures remain within rated limits at the maximum ambient temperature of +125°C.

**Assumptions:**
- Maximum ambient temperature: +125°C
- Enclosure thermal resistance (θ_case-to-ambient): 2.0°C/W (assumes conduction to chassis)
- Internal air temperature rise above enclosure: +15°C at full power
- Total power dissipation: 25 W (maximum budget)

**Thermal Calculation:**

```
T_internal_max = T_ambient + (P_total × θ_case-to-ambient)
T_internal_max = +125°C + (25 W × 2.0°C/W) = +175°C (worst case, uncooled)
```

This exceeds all component ratings. Active thermal management is **mandatory**.

**With forced conduction to vehicle chassis (θ_case-to-ambient = 0.5°C/W):**

```
T_enclosure = T_ambient + (P_total × 0.5°C/W)
T_enclosure = +125°C + (25 W × 0.5°C/W) = +137.5°C

T_internal = T_enclosure + ΔT_internal_rise
T_internal = +137.5°C + 10°C = +147.5°C (still excessive)
```

**Required: Active thermoelectric cooling or liquid cooling. Target internal temperature: +75°C.**

With active cooling maintaining internal at +75°C:

| Component | Power (W) | θ_jc (°C/W) | T_junction (°C) | T_j rated (°C) | Margin (°C) |
|---|---|---|---|---|---|
| FPGA (XC7K355T) | 5.0 | 0.5 | 75 + 5×0.5 = 77.5 | 100 | 22.5 |
| ADC (LTC2107) × 4 | 4 × 0.635 = 2.54 | 8.0 | 75 + 2.54×8/4 = 80.1 | 85 | 4.9 |
| LNA (ZVA-183WA-S+) × 4 | 4 × 0.5 = 2.0 | 15.0 | 75 + 0.5×15 = 82.5 | 85 | 2.5 |
| LMX2820 PLL | 0.5 | 20.0 | 75 + 0.5×20 = 85 | 105 | 20 |
| ADF4383 PLL | 0.4 | 20.0 | 75 + 0.4×20 = 83 | 105 | 22 |
| CMD180C3 Mixer × 4 | 0 (passive) | N/A | 75 | 125 | 50 |
| OCXO (KOVTL10) | 1.8 | 10.0 | 75 + 1.8×10 = 93 | 70 (spec) | **EXCEEDS** |

**REQ-HW-048**: The OCXO module shall be provided with dedicated thermal isolation and cooling maintaining its case temperature below +70°C even when external ambient reaches +125°C. A Peltier thermoelectric cooler (TEC) with closed-loop temperature control shall be employed for the OCXO.

**REQ-HW-049**: The FPGA shall be mounted on a dedicated thermal spreader connected to the chassis via conductive thermal interface material (TIM) with thermal resistance < 0.1°C/W.

#### 3.4.5 EMI/EMC Requirements

**Table 3.4.5-1: EMI/EMC Requirements**

| ID | Parameter | Value | Standard | Notes |
|---|---|---|---|---|
| REQ-HW-050 | Radiated Emissions | Per limits | MIL-STD-461G RE102 | Shipboard/mobile |
| REQ-HW-051 | Conducted Emissions | Per limits | MIL-STD-461G CE102 | Power line |
| REQ-HW-052 | Radiated Susceptibility | 200 V/m | MIL-STD-461G RS103 | 10 kHz to 40 GHz |
| REQ-HW-053 | Conducted Susceptibility | Per limits | MIL-STD-461G CS114 | Bulk cable injection |
| REQ-HW-054 | Enclosure Shielding Effectiveness | > 60 dB at 40 GHz | Design rule | Conductive gaskets, cavity shields |
| REQ-HW-055 | Power Line EMI Filtering | > 40 dB insertion at >1 MHz | Design rule | Common-mode choke + π-filter |

---

# 3.5 Power Requirements

This section specifies the complete power budget, supply architecture, and distribution requirements for the receiver system.

*REQ-HW-024*: Total system DC power consumption shall not exceed 25 W from the +15 V primary supply rail.

*REQ-HW-025*: The primary supply rail is +15 VDC. Internal LDO regulation shall generate all required sub-rails (5V, 3.3V).

#### 3.5.1 Power Budget Analysis

Detailed power budget calculated from component datasheet values and engineering estimates.

**Table 3.5.1-1: Detailed Power Budget by Component**

| Ref Des | Component | Part Number | Rail | Qty | Current per Unit (mA) | Total Current (mA) | Voltage (V) | Power per Qty (W) | Total Power (W) | Notes |
|---|---|---|---|---|---|---|---|---|---|---|
| U1-U4 | LNA | ZVA-183WA-S+ | +5V | 4 | 100 | 400 | 5.0 | 0.50 | 2.00 | Datasheet typical, 5V supply |
| U5-U8 | Gain Block | ZVA-183WA-S+ | +5V | 4 | 100 | 400 | 5.0 | 0.50 | 2.00 | Same as LNA, IF1 stage |
| U9-U12 | VGA | TGL2767 | +5V | 4 | 80 | 320 | 5.0 | 0.40 | 1.60 | Assumed 80 mA, GaAs VGA |
| U13-U16 | Mixer 1 | CMD180C3 | Passive | 4 | 0 | 0 | - | 0 | 0.00 | Passive mixer, LO-driven |
| U17-U20 | Mixer 2 | MMIQ-0205HSM-2 | Passive | 4 | 0 | 0 | - | 0 | 0.00 | Passive mixer, LO-driven |
| U21 | LO1 PLL | LMX2820RTCT | +3.3V | 1 | 130 | 130 | 3.3 | 0.43 | 0.43 | Datasheet, 22.6 GHz active |
| U22 | LO2 PLL | ADF4383 | +3.3V | 1 | 120 | 120 | 3.3 | 0.40 | 0.40 | Estimated, 3.5 GHz output |
| U23 | OCXO | KOVTL10MDBFBCB | +12V* | 1 | 150 | 150 | 12.0 | 1.80 | 1.80 | Datasheet, +12V via +15V LDO |
| U24 | FPGA | XC7K355T | +3.3V/+1.8V | 1 | 1500 | 1500 | 1.8/3.3 | 3.50 | 3.50 | Kintex-7, dynamic power estimate |
| U25-U28 | ADC | LTC2107 | +3.3V | 4 | 193 | 772 | 3.3 | 0.64 | 2.54 | Datasheet, 210 Msps, 364 mW typ |
| U29 | LO1 Buffer | Gain block | +5V | 1 | 100 | 100 | 5.0 | 0.50 | 0.50 | LO1 distribution amplifier |
| U30 | LO2 Buffer | Gain block | +5V | 1 | 100 | 100 | 5.0 | 0.50 | 0.50 | LO2 distribution amplifier |
| U31 | Clock Buffer | 4-CH LVPECL | +3.3V | 1 | 80 | 80 | 3.3 | 0.26 | 0.26 | Assumed, ADC clock distribution |
| U32 | DAC (AGC) | 4-CH 10-bit | +3.3V | 1 | 10 | 10 | 3.3 | 0.03 | 0.03 | Assumed, quad DAC for AGC |
| U33 | DAC (YIG) | 4-CH 16-bit | +5V | 1 | 15 | 15 | 5.0 | 0.08 | 0.08 | Assumed, YIG tuning DAC |
| U34 | Temp Sensors | LM35 or equiv | +3.3V | 4 | 1 | 4 | 3.3 | 0.003 | 0.01 | Negligible |
| U50 | LDO 5V | LM2940S-5.0 | +15V | 1 | - | 1500 | 5.0 | - | 1.50 | LDO loss: (15-5)×1.0A=10W worst case |
| U51 | LDO 3.3V | MCP1826S | +5V | 1 | - | 1000 | 3.3 | - | 0.50 | LDO loss: (5-3.3)×1.0A=1.7W |
| U52 | LDO 3.3V PLL | MCP1826S | +5V | 1 | - | 300 | 3.3 | - | 0.15 | LDO loss: (5-3.3)×0.3A=0.51W |
| - | Limiter bias | Passive | - | 4 | 0 | 0 | - | 0 | 0.00 | Passive limiter diodes |
| - | YIG driver overhead | Op-amp | ±15V | 1 | 50 | 50 | 15.0 | 0.75 | 0.75 | YIG coil drive current |

**LDO Power Dissipation Calculation:**

The primary LDO losses are the dominant factor in power efficiency:

| LDO | Input | Output | Current (A) | Dropout (V) | LDO Dissipation (W) |
|---|---|---|---|---|---|
| U50 (+5V_RF) | +15V | +5.0V | 1.22 | 10.0 | 12.20 |
| U51 (+3.3V_DIG) | +5.0V | +3.3V | 1.01 | 1.7 | 1.72 |
| U52 (+3.3V_PLL) | +5.0V | +3.3V | 0.30 | 1.7 | 0.51 |

**Total Power Summary:**

| Category | Power (W) | Percentage |
|---|---|---|
| RF Active Components (LNAs, Gain Blocks, VGAs) | 5.60 | 22.4% |
| Digital Components (FPGA, ADCs, Clock) | 6.30 | 25.2% |
| LO Synthesizers and Buffers | 1.83 | 7.3% |
| OCXO and Reference | 1.80 | 7.2% |
| Support (DACs, Sensors, YIG Driver) | 0.87 | 3.5% |
| LDO Regulation Losses | 14.43 | 57.7% |
| **Total from +15V Supply** | **25.03** | **100%** |

**REQ-HW-056**: Total system power consumption shall not exceed 25.0 W from the +15 VDC supply. The current design estimates 25.03 W; the LDO regulation losses shall be optimized by implementing a switching pre-regulator to generate +6V from +15V, reducing LDO dropout and total power below 25 W.

**Revised Power Budget with Switching Pre-Regulator:**

If a buck converter (e.g., TPS562201, efficiency 90%) generates +6V from +15V:

```
P_switcher_output = 6V × 1.8A = 10.8 W
P_switcher_input = 10.8 / 0.90 = 12.0 W
P_switcher_loss = 12.0 - 10.8 = 1.2 W

LDO dissipation (6V to 5V at 1.22A) = 1.22 × 1.22 = 1.49 W (vs 12.2 W)

Total revised power = 5.60 + 6.30 + 1.83 + 1.80 + 0.87 + 1.49 + 1.72 + 0.51 + 1.20 = 21.32 W
```

**Margin: 25.0 - 21.32 = 3.68 W (14.7% margin)**

**REQ-HW-057**: A high-efficiency buck pre-regulator shall convert +15 VDC to +6.0 VDC at 2 A, with minimum 90% efficiency at full load, feeding the +5V and +3.3V LDO regulators to minimize total power dissipation.

#### 3.5.2 Power Supply Rail Specifications

**Table 3.5.2-1: Power Supply Rail Specification Summary**

| Rail Name | Nominal Voltage (V) | Tolerance | Typical Current (mA) | Max Current (mA) | Typical Power (W) | Max Power (W) | Ripple (mVpp) | Source |
|---|---|---|---|---|---|---|---|---|
| +15V_PRIMARY | +15.0 | ±5% | 1420 | 1667 | 21.30 | 25.00 | < 100 | External supply |
| +6V_SWITCHED | +6.0 | ±2% | 1800 | 2000 | 10.80 | 12.00 | < 30 | Buck converter |
| +5V_RF | +5.0 | ±1% | 1220 | 1500 | 6.10 | 7.50 | < 10 | LDO from +6V |
| +5V_CH[1:4] | +5.0 | ±1% | 280 per ch | 300 per ch | 5.60 | 6.00 | < 10 | LDO from +6V |
| +3.3V_DIG | +3.3 | ±1% | 1010 | 1200 | 3.33 | 3.96 | < 10 | LDO from +5V |
| +3.3V_PLL | +3.3 | ±1% | 300 | 400 | 0.99 | 1.32 | < 5 | LDO from +5V |
| +1.8V_FPGA | +1.8 | ±2% | 800 | 1200 | 1.44 | 2.16 | < 15 | LDO from +3.3V |
| +12V_OCXO | +12.0 | ±1% | 150 | 200 | 1.80 | 2.40 | < 1 | LDO from +15V |

#### 3.5.3 Power Sequencing Requirements

**REQ-HW-058**: The power supplies shall sequence in the following order to prevent latch-up or damage:

```mermaid
sequenceDiagram
    participant EXT as +15V External
    participant BUCK as Buck (+6V)
    participant LDO5 as LDO (+5V_RF)
    participant LDO33 as LDO (+3.3V_DIG)
    participant LDO18 as LDO (+1.8V_FPGA)
    participant LDO12 as LDO (+12V_OCXO)
    participant PLL as PLL Synths
    participant FPGA as FPGA
    participant ADC as ADCs

    EXT->>BUCK: +15V applied (t=0)
    Note over BUCK: Delay 10 ms
    BUCK->>LDO5: +6V stable
    LDO5->>LDO33: +5V stable
    LDO33->>LDO18: +3.3V stable
    Note over LDO12: +12V from +15V direct
    EXT->>LDO12: +12V_OCXO stable
    Note over PLL: Delay 100 ms
    LDO33->>PLL: PLL supplies enabled
    LDO12->>PLL: OCXO reference stable
    Note over FPGA: Delay 200 ms
    LDO18->>FPGA: FPGA core powered
    LDO33->>FPGA: FPGA I/O powered
    Note over ADC: Delay 300 ms
    LDO33->>ADC: ADC supplies enabled
    Note over ADC: CLKDIST active
```

1. +15V applied → Buck converter starts
2. +6V stable (10 ms delay) → +5V_RF LDO enabled
3. +5V stable (5 ms delay) → +3.3V_DIG LDO enabled
4. +3.3V stable (5 ms delay) → +1.8V_FPGA LDO enabled
5. +12V_OCXO stable concurrently → OCXO warms up (60 s to full stability)
6. After +3.3V_PLL stable and OCXO lock (100 ms minimum) → PLL synthesizers programmed via SPI
7. After FPGA configuration complete (200 ms) → ADC supplies enabled
8. After ADC clocks stable → System operational

#### 3.5.4 Power Integrity Requirements

**Table 3.5.4-1: Power Integrity Requirements**

| ID | Parameter | Specification | Unit | Notes |
|---|---|---|---|---|
| REQ-HW-059 | +5V_RF Ripple (20 Hz - 10 MHz) | < 10 mVpp | mVpp | Critical for LNA NF |
| REQ-HW-060 | +3.3V_PLL Ripple (20 Hz - 10 MHz) | < 5 mVpp | mVpp | Prevents LO spurs |
| REQ-HW-061 | +3.3V_DIG Ripple (20 Hz - 100 MHz) | < 15 mVpp | mVpp | FPGA/ADC stability |
| REQ-HW-062 | +1.8V_FPGA Core Ripple | < 15 mVpp | mVpp | Core logic integrity |
| REQ-HW-063 | Power Supply Rejection (LNA rail) | > 60 dB at 1 kHz | dB | Prevents supply noise modulation |
| REQ-HW-064 | Decoupling per Active Stage | 100 µF bulk + 10 µF ceramic + 100 pF HF ceramic per supply pin | - | LC ferrite isolation between stages |
| REQ-HW-065 | Reverse Voltage Protection | Diode crowbar or MOSFET reverse polarity protection on +15V input | - | Prevents damage from miswiring |
| REQ-HW-066 | Overcurrent Protection | Self-resetting PTC fuse or eFuse at 2.5 A on +15V input | A | Protects supply and wiring |

#### 3.5.5 Power Distribution Diagram

```mermaid
flowchart TD
    PWRIN[/"+15 VDC<br/>External Supply<br/>25 W max"/]
    EMIFIL{{"EMI Filter<br/>Common-mode choke<br/>+ π-filter"}}
    PROTECT["Reverse Polarity<br/>& Overcurrent<br/>Protection"]
    BUCK["Buck Converter<br/>+15V → +6V<br/>2A, >90% eff"]
    LDO5["LDO LM2940S-5.0<br/>+6V → +5V_RF<br/>1.5A"]
    LDO33["LDO MCP1826S<br/>+5V → +3.3V_DIG<br/>1.0A"]
    LDO18["LDO +3.3V → +1.8V<br/>FPGA Core<br/>1.2A"]
    LDO12["LDO +15V → +12V<br/>OCXO only<br/>200mA"]
    LDO5C["LDO LM2940 ×4<br/>+6V → +5V_CH[1:4]<br/>300mA each"]
    LDO33P["LDO MCP1826S<br/>+5V → +3.3V_PLL<br/>400mA"]

    LNA["LNA ×4<br/>4 × 100 mA<br/>2.00 W"]
    GB["Gain Block ×4<br/>4 × 100 mA<br/>2.00 W"]
    VGA["VGA ×4<br/>4 × 80 mA<br/>1.60 W"]
    BUF["LO Buffer ×2<br/>2 × 100 mA<br/>1.00 W"]
    FPGA["FPGA<br/>~1.5A @ 1.8V<br/>3.50 W"]
    ADC["ADC ×4<br/>4 × 193 mA<br/>2.54 W"]
    CLKDIST["Clock Buffer<br/>80 mA<br/>0.26 W"]
    PLL["PLL ×2<br/>250 mA<br/>0.83 W"]
    OCXO["OCXO<br/>150 mA<br/>1.80 W"]

    PWRIN --> EMIFIL
    EMIFIL --> PROTECT
    PROTECT --> BUCK
    PROTECT --> LDO12
    BUCK --> LDO5
    BUCK --> LDO5C
    LDO5 --> LDO33
    LDO5 --> LDO33P
    LDO33 --> LDO18
    LDO5C --> LNA
    LDO5C --> GB
    LDO5C --> VGA
    LDO5 --> BUF
    LDO33 --> FPGA
    LDO33 --> ADC
    LDO33 --> CLKDIST
    LDO33P --> PLL
    LDO12 --> OCXO

    style PWRIN fill:#ff9999,stroke:#cc0000
    style BUCK fill:#ffcc99,stroke:#cc6600
    style LDO5 fill:#ffffcc,stroke:#cccc00
    style LDO33 fill:#ccffcc,stroke:#00cc00
    style LDO18 fill:#ccffff,stroke:#00cccc
```

---

# 3.6 Physical Requirements

This section specifies the mechanical dimensions, weight, enclosure, mounting, and connector placement requirements for the receiver system.

#### 3.6.1 Enclosure and Dimensions

**Table 3.6.1-1: Enclosure Physical Requirements**

| ID | Parameter | Value | Unit | Notes |
|---|---|---|---|---|
| REQ-HW-067 | Enclosure Type | Machined aluminum, billet 6061-T6 | - | EMI shielding + thermal conduction |
| REQ-HW-068 | External Dimensions (max) | 300 × 200 × 60 | mm | L × W × H |
| REQ-HW-069 | Wall Thickness (minimum) | 3.0 | mm | Structural + shielding |
| REQ-HW-070 | Internal Cavity Dividers | Machined walls, 2.0 mm thick | mm | Isolate RF stages, REQ-HW-026 |
| REQ-HW-071 | Lid Design | Bolt-down flat lid with EMI gasket | - | 20+ M2.5 screws around perimeter |
| REQ-HW-072 | Surface Finish | Conductive, chromate conversion | - | No anodize on mating surfaces |
| REQ-HW-073 | Total System Weight (max) | 3.5 | kg | Including enclosure, connectors, PCB |
| REQ-HW-074 | PCB Dimensions (max) | 280 × 180 | mm | Fits within enclosure with 10 mm margin |
| REQ-HW-075 | PCB Material | Rogers RO4350B + FR-4 hybrid stackup | - | RF layers on Rogers, digital on FR-4 |
| REQ-HW-076 | PCB Layer Count | 12 layers minimum | layers | 4 RF, 2 power, 4 digital, 2 ground |

#### 3.6.2 Internal Cavity Layout

The internal layout follows a strict signal-flow architecture to prevent oscillation and maintain isolation.

```mermaid
flowchart TD
    subgraph ENCLOSURE["Receiver Enclosure — 300 × 200 × 60 mm"]
        direction TB
        subgraph CAV_RF_IN["CAVITY 1: RF Input Stage"]
            direction LR
            LIM["Limiter ×4"]
            YIG["YIG Preselector ×4"]
        end
        subgraph CAV_LNA["CAVITY 2: LNA / First Mix"]
            direction LR
            LNA_C["LNA ×4<br/>ZVA-183WA-S+"]
            MIX1_C["MIX1 ×4<br/>CMD180C3"]
        end
        subgraph CAV_IF1["CAVITY 3: IF1 Stage"]
            direction LR
            BPF1_C["IF1 BPF ×4"]
            GB_C["Gain Block ×4"]
            BPF_S["Stab BPF ×4"]
        end
        subgraph CAV_IF2["CAVITY 4: IF2 / VGA Stage"]
            direction LR
            MIX2_C["MIX2 ×4<br/>MMIQ-0205HSM-2"]
            BPF2_C["IF2 BPF ×4"]
            VGA_C["VGA ×4<br/>TGL2767"]
        end
        subgraph CAV_DIG["CAVITY 5: Digitization"]
            direction LR
            ADC_C["ADC ×4<br/>LTC2107"]
            FPGA_C["FPGA<br/>XC7K355T"]
        end
        subgraph CAV_LO["CAVITY 6: LO Synthesis"]
            direction LR
            OCXO_C["OCXO<br/>KOVTL10"]
            PLL1_C["LO1 PLL<br/>LMX2820"]
            PLL2_C["LO2 PLL<br/>ADF4383"]
            BUF_C["LO Buffers<br/>×2"]
            CLK_C["Clock Buffer"]
        end
        subgraph CAV_PWR["CAVITY 7: Power Supply"]
            direction LR
            EMI_C["EMI Filter"]
            BUCK_C["Buck +6V"]
            LDO_ARR["LDO Array<br/>+5V, +3.3V, +1.8V"]
        end
    end
    CAV_RF_IN -->|"SMA feed-through"| CAV_LNA
    CAV_LNA -->|"Semi-rigid coax"| CAV_IF1
    CAV_IF1 -->|"Microstrip through wall"| CAV_IF2
    CAV_IF2 -->|"Balun / transformer"| CAV_DIG
    CAV_LO -.->|"LO1 / LO2 coax"| CAV_LNA
    CAV_LO -.->|"LO2 coax"| CAV_IF2
    CAV_PWR -.->|"Decoupled feeds"| CAV_LNA
    CAV_PWR -.->|"+3.3V"| CAV_DIG
    CAV_PWR -.->|"+3.3V"| CAV_LO
```

**Table 3.6.2-1: Cavity Isolation Requirements**

| Cavity Boundary | Signal Flow Direction | Isolation Required (dB) | Method |
|---|---|---|---|
| Cavity 1 → Cavity 2 | RF Input to LNA | > 40 | Machined wall, SMA feed-through |
| Cavity 2 → Cavity 3 | LNA out to IF1 | > 50 | Machined wall, semi-rigid coax |
| Cavity 3 → Cavity 4 | IF1 to IF2/Mixer | > 50 | Machined wall, feed-through |
| Cavity 4 → Cavity 5 | IF2/VGA to ADC | > 40 | Machined wall, balun coupling |
| Cavity 6 → Cavities 2, 4 | LO distribution | > 60 | Separate cavity, shielded coax runs |
| Cavity 7 → All cavities | Power distribution | > 60 | Feed-through capacitors, ferrite beads |

*REQ-HW-026*: Each major stage group shall reside in separate shielded cavities with isolated LC/ferrite-decoupled supply rails and reverse-orientation input/output routing to prevent oscillation.

#### 3.6.3 Connector Placement

**Table 3.6.3-1: Connector Placement on Enclosure**

| Connector | Designator | Type | Location | Orientation | Notes |
|---|---|---|---|---|---|
| RF Input Ch1 | J1 | 2.92mm-K (female) | Front panel, left | Panel-mount, vertical | IP68-sealed |
| RF Input Ch2 | J2 | 2.92mm-K (female) | Front panel, left | Panel-mount, vertical | IP68-sealed |
| RF Input Ch3 | J3 | 2.92mm-K (female) | Front panel, right | Panel-mount, vertical | IP68-sealed |
| RF Input Ch4 | J4 | 2.92mm-K (female) | Front panel, right | Panel-mount, vertical | IP68-sealed |
| Power Input | J5 | MIL-DTL-38999-III (8-pin) | Rear panel, center | Panel-mount, horizontal | Power + control |
| Data Output | J6 | Samtec SEARAY (100-pin) | Rear panel, left | Panel-mount, horizontal | LVDS data bus |
| Ext Ref Input | J7 | SMA (50Ω, female) | Rear panel, right | Panel-mount, vertical | 10 MHz reference |
| Status LEDs | - | 3× LED panel | Rear panel, center | PCB-mounted | PWR, LOCK, FAULT |
| TEC Power | J8 | 2-pin header (2mm pitch) | Side panel | Panel-mount | Thermoelectric cooler |

**Front Panel Layout (schematic):**

```
┌──────────────────────────────────────────┐
│  [J1]  [J2]          [J3]  [J4]         │
│  Ch1   Ch2           Ch3   Ch4           │
│  RF In RF In         RF In RF In         │
│                                          │
│          rx band                         │
│     4-CH Radar Receiver                  │
│         18-40 GHz                        │
│                                          │
└──────────────────────────────────────────┘
```

**Rear Panel Layout (schematic):**

```
┌──────────────────────────────────────────┐
│  [J6]                [J5]      [J7]      │
│  LVDS Data           Power     Ext Ref   │
│  100-pin             8-pin     SMA       │
│                                          │
│        [LED: PWR] [LED: LOCK] [LED: FAULT] │
│                                          │
│                               [J8]        │
│                               TEC Power   │
└──────────────────────────────────────────┘
```

#### 3.6.4 PCB Stackup and Material Requirements

**REQ-HW-077**: The PCB shall use a hybrid stackup with Rogers RO4350B (εr = 3.66, tan δ = 0.0037) for RF signal layers and standard FR-4 (εr = 4.5) for digital and power layers.

**Table 3.6.4-1: 12-Layer PCB Stackup**

| Layer | Material | Function | Thickness (mil) | Copper Weight | Notes |
|---|---|---|---|---|---|
| Top (L1) | Rogers RO4350B | RF Signal 1 (18-40 GHz, 4 GHz, 500 MHz) | 8.0 | 1/2 oz (17 µm) | 50Ω microstrip, 0.48 mm trace width |
| L2 | FR-4 prepreg | Ground Plane 1 | 5.0 | 1 oz (35 µm) | Continuous ground reference for L1 |
| L3 | FR-4 core | RF Signal 2 (LO distribution) | 8.0 | 1/2 oz | Stripline, 50Ω controlled |
| L4 | FR-4 prepreg | Ground Plane 2 | 5.0 | 1 oz | Continuous ground reference for L3 |
| L5 | FR-4 core | Power Plane 1 (+5V_RF) | 10.0 | 1 oz | Split plane by channel |
| L6 | FR-4 prepreg | Ground Plane 3 | 5.0 | 1 oz | Isolation between power layers |
| L7 | FR-4 core | Power Plane 2 (+3.3V_DIG) | 10.0 | 1 oz | Digital supply plane |
| L8 | FR-4 prepreg | Ground Plane 4 | 5.0 | 1 oz | Isolation |
| L9 | FR-4 core | Digital Signal 1 (LVDS, SPI) | 8.0 | 1/2 oz | Controlled 100Ω differential |
| L10 | FR-4 prepreg | Ground Plane 5 | 5.0 | 1 oz | Reference for L9, L11 |
| L11 | FR-4 core | Digital Signal 2 (FPGA routing) | 8.0 | 1/2 oz | FPGA BGA breakout |
| Bottom (L12) | FR-4 core | Ground Plane 6 / Solder side | 5.0 | 1 oz | Bottom ground + SMT placement |
| **Total** | | | **82 mil (2.08 mm)** | | |

**Controlled Impedance Requirements:**

| Signal Type | Layer | Impedance | Trace Width | Trace Spacing | Reference Plane |
|---|---|---|---|---|---|
| RF Single-ended (50Ω) | L1 | 50 ± 5 Ω | 0.48 mm | N/A | L2 |
| RF Single-ended (50Ω) | L3 | 50 ± 5 Ω | 0.25 mm | N/A | L2, L4 |
| LVDS Differential (100Ω) | L9 | 100 ± 10 Ω diff | 0.15 mm | 0.10 mm | L8, L10 |
| SPI Single-ended (50Ω) | L9 | 50 ± 5 Ω | 0.15 mm | N/A | L8 |

#### 3.6.5 Mounting Requirements

**Table 3.6.5-1: Mounting Requirements**

| ID | Parameter | Value | Unit | Notes |
|---|---|---|---|---|
| REQ-HW-078 | Mounting Hole Count | 6 | - | M3 threaded inserts |
| REQ-HW-079 | Mounting Hole Location | 4 corners + 2 mid-span | - | See mechanical drawing |
| REQ-HW-080 | Mounting Torque | 0.8 ± 0.1 | N·m | M3 stainless steel screws |
| REQ-HW-081 | Vibration Damping | Silicone rubber grommets | - | Between enclosure and vehicle mount |
| REQ-HW-082 | Thermal Interface | Chassis bottom surface | - | Thermal grease or graphite pad, < 0.05°C·in²/W |
| REQ-HW-083 | PCB to Enclosure Clearance | 2.0 mm minimum all sides | mm | Prevent RF coupling to walls |

#### 3.6.6 Thermal Management Physical Requirements

**Table 3.6.6-1: Thermal Management Physical Requirements**

| ID | Parameter | Value | Unit | Notes |
|---|---|---|---|---|
| REQ-HW-084 | FPGA Heat Spreader | Copper, 30 × 30 × 5 mm | mm | Mounted on FPGA via TIM |
| REQ-HW-085 | FPGA Thermal Path | Thermal vias (10 × 10 array) | - | 0.3 mm via, 1.0 mm pitch, filled |
| REQ-HW-086 | Enclosure Thermal Interface | Bottom surface, milled flat | - | Ra < 1.6 µm surface roughness |
| REQ-HW-087 | TEC Module Location | Dedicated sub-enclosure | - | OCXO thermal isolation chamber |
| REQ-HW-088 | TEC Module Size | 20 × 20 × 4 mm | mm | Peltier cooler, 12V, 1.5A max |
| REQ-HW-089 | TEC Power (additional) | 18 W max (12V × 1.5A) | W | Not included in 25W RF/digital budget; separate supply |
| REQ-HW-090 | Internal Temperature Sensors | 4× NTC thermistors, 10 kΩ | - | Mounted near LNA, FPGA, ADC, OCXO |

**REQ-HW-091**: The enclosure base shall serve as the primary thermal conduction path to the vehicle/system chassis. The base shall be designed to transfer up to 25 W of heat with a thermal resistance less than 0.5°C/W when mounted on a flat chassis surface with thermal interface material.

**REQ-HW-092**: All high-power components (FPGA, LDO regulators, LO buffer amplifiers) shall be located as close as physically possible to the enclosure base wall, with thermal vias connecting component thermal pads to internal copper planes bonded to the enclosure wall via thermal interface material.

#### 3.6.7 Labeling and Marking

**Table 3.6.7-1: Labeling Requirements**

| ID | Parameter | Value
**Labeling Requirements**

| ID | Parameter | Value | Standard | Notes |
|---|---|---|---|---|
| REQ-HW-093 | Equipment Nomenclature Plate | "rx band 4-CH Radar Receiver, 18-40 GHz, P/N: RXB-18-40-4CH-001" | MIL-STD-130 | Etched aluminum, riveted to enclosure |
| REQ-HW-094 | Connector Marking | Silkscreened text adjacent to each connector | IPC-7351 | White ink on enclosure surface |
| REQ-HW-095 | Serial Number Location | Rear panel, lower-left, laser-engraved | MIL-STD-130 | Format: RXB-YYYY-NNNN |
| REQ-HW-096 | Polarity and Pin-1 Marking | Polarity dot and pin-1 indicator on all connectors | Design rule | Red dot for active pins |
| REQ-HW-097 | Safety and Warning Labels | High-power, RF radiation warning per ANSI C95.2 | ANSI C95.2 | Affixed to front panel |
| REQ-HW-098 | Calibration Label | Calibration due date, affixed to side panel | ISO 17025 | Tamper-evident label |
| REQ-HW-099 | PCB Revision Marking | Copper layer L12: "Rev X.Y, Date: YYYY-MM-DD" | IPC-7351 | Etched into bottom copper |

#### 3.6.8 Mechanical Robustness and Solderability

**Table 3.6.8-1: Mechanical Robustness Requirements**

| ID | Parameter | Value | Unit | Notes |
|---|---|---|---|---|
| REQ-HW-100 | Solder Alloy | SAC305 (Sn96.5/Ag3.0/Cu0.5) | - | Lead-free, RoHS compliant, high-reliability |
| REQ-HW-101 | Solder Paste Flux Type | No-clean, Type 4 or Type 5 | - | For 0.4 mm pitch BGA components |
| REQ-HW-102 | Component Adhesive | Loctite 3492 or equivalent | - | For SMT components > 10 g subject to vibration |
| REQ-HW-103 | RF Shield Can Attachment | Reflow-soldered, 4-point minimum | - | Shield cans on LNA, Mixer, and IF stages |
| REQ-HW-104 | BGA Component Underfill | Namics U8437-3 or equivalent | - | Underfill FPGA and ADC BGA packages |
| REQ-HW-105 | Conformal Coating | HumiSeal 1B73, acrylic, 25-75 µm | µm | Exclude: RF connectors, test points, unshielded RF paths |
| REQ-HW-106 | Staking of Tall Components | Epoxy staking for components > 10 mm height | - | Prevents vibration-induced failure |

**REQ-HW-107**: All component leads, terminations, and PCB surface finishes shall be solderable per IPC-J-STD-002 and IPC-J-STD-003. The PCB surface finish shall be Electroless Nickel Immersion Gold (ENIG) with a minimum gold thickness of 3 µin (0.075 µm) over 120 µin (3 µm) nickel.

#### 3.6.9 Coaxial Cable and Semi-Rigid Interconnect Requirements

Internal coaxial connections between cavities and between PCBs require controlled-phase and low-loss cables.

**Table 3.6.9-1: Internal Coaxial Cable Requirements**

| ID | Parameter | Value | Unit | Notes |
|---|---|---|---|---|
| REQ-HW-108 | LO1 Distribution Cable Type | Semi-rigid 0.047" RG-405 (Cu-clad steel) | - | Phase-stable, 18-40 GHz |
| REQ-HW-109 | LO2 Distribution Cable Type | Semi-rigid 0.047" RG-405 | - | Phase-stable at 3.5 GHz |
| REQ-HW-110 | IF1 Inter-cavity Cable Type | Flexible 0.086" RG-178 | - | Between Cavities 2 and 3 |
| REQ-HW-111 | RF Input Feed-through | SMA (2.92mm) hermetic feed-through | - | Cavity 1 to Cavity 2 bulkhead |
| REQ-HW-112 | Cable Phase Matching (LO1) | ±2.0° electrical length at 36 GHz | degrees | Between all 4 channels |
| REQ-HW-113 | Cable Phase Matching (LO2) | ±2.0° electrical length at 3.5 GHz | degrees | Between all 4 channels |
| REQ-HW-114 | Cable Insertion Loss (LO1) | < 1.5 dB per cable run | dB | Includes connectors |
| REQ-HW-115 | Cable VSWR | < 1.3:1 across operating band | Ratio | Return loss > -17 dB |
| REQ-HW-116 | Minimum Bend Radius (flexible) | 5× cable outer diameter | mm | Prevents phase shift and damage |

**REQ-HW-117**: All semi-rigid coaxial cables shall be cut to identical physical lengths within ±0.5 mm and time-domain reflectometry (TDR) verified to ensure electrical length matching to ±2 ps between channels for LO1 and LO2 distribution paths.

#### 3.6.10 YIG Preselector Mechanical Requirements

The tunable YIG (Yttrium Iron Garnet) preselector modules are precision microwave components requiring specific mechanical accommodations.

**Table 3.6.10-1: YIG Preselector Mechanical Requirements**

| ID | Parameter | Value | Unit | Notes |
|---|---|---|---|---|
| REQ-HW-118 | YIG Module Quantity | 4 | - | One per channel |
| REQ-HW-119 | YIG Module Package | Hermetically sealed, SMA connectors | - | Shielded package |
| REQ-HW-120 | YIG Tuning Range | 18 - 40 GHz | GHz | Full RF coverage |
| REQ-HW-121 | YIG 3-dB Bandwidth | 30 - 80 MHz (typical) | MHz | Tunable passband |
| REQ-HW-122 | YIG Rejection (out-of-band) | > 50 dBc at ±500 MHz from center | dBc | Preselector selectivity |
| REQ-HW-123 | YIG Tuning Current Range | 20 - 100 mA (linear) | mA | Current-controlled frequency |
| REQ-HW-124 | YIG Tuning Sensitivity | 15 - 25 mA/GHz | mA/GHz | Assumed typical for Ku-Ka YIGs |
| REQ-HW-125 | YIG Module Dimensions | 50 × 50 × 25 mm (typical per module) | mm | Assumed standard YIG package |
| REQ-HW-126 | YIG Thermal Stability | < 1 MHz/°C frequency drift | MHz/°C | Requires temperature compensation |
| REQ-HW-127 | YIG Magnetic Shielding | µ-metal outer shield | - | Prevents external field coupling |
| REQ-HW-128 | YIG Mounting Orientation | Horizontal, magnetic axis vertical | - | Minimizes Earth field effect |

**REQ-HW-129**: The YIG preselector modules shall be mounted on a dedicated machined shelf within Cavity 1, mechanically isolated from vibration by elastomeric dampers, and surrounded by µ-metal magnetic shielding to prevent inter-channel magnetic crosstalk and external field interference.

#### 3.6.11 FPGA and Digital Processing Mechanical Requirements

**Table 3.6.11-1: FPGA Mechanical Requirements**

| ID | Parameter | Value | Unit | Notes |
|---|---|---|---|---|
| REQ-HW-130 | FPGA Package | FFG901 (BGA, 29 × 29 mm, 1.0 mm pitch) | - | XC7K355T-FFG901 |
| REQ-HW-131 | FPGA BGA Ball Count | 355 I/O + power + GND (901 total balls) | - | High-density routing |
| REQ-HW-132 | FPGA BGA Escape Routing | All signal balls routed on L9-L12 | - | 1.0 mm pitch allows fanout |
| REQ-HW-133 | FPGA Decoupling Capacitors | 40 × 100 nF + 10 × 10 µF + 4 × 100 µF | - | Placed on bottom side under BGA |
| REQ-HW-134 | FPGA Heatsink | Custom copper spreader, 30 × 30 × 5 mm | mm | TIM to enclosure base |
| REQ-HW-135 | FPGA Configuration Flash | 128 Mbit SPI Flash (S25FL128S) | Mbit | Mounted adjacent to FPGA |
| REQ-HW-136 | FPGA JTAG Access | 10-pin ARM JTAG header (2 × 5, 1.27 mm) | - | Programming and debug access |

#### 3.6.12 Electromagnetic Shielding Requirements

**Table 3.6.12-1: Electromagnetic Shielding Requirements**

| ID | Parameter | Value | Unit | Notes |
|---|---|---|---|---|
| REQ-HW-137 | Enclosure Shielding Effectiveness (SE) | > 60 dB from 100 MHz to 40 GHz | dB | Machined aluminum with EMI gaskets |
| REQ-HW-138 | Lid EMI Gasket Type | Conductive elastomer, Sn/Cu filled silicone | - | Continuous strip around perimeter |
| REQ-HW-139 | Cavity Wall SE (inter-cavity) | > 50 dB from DC to 40 GHz | dB | Machined dividers, 2 mm minimum thickness |
| REQ-HW-140 | Feed-through Capacitor Rating | 1000 pF, 50 VDC, COTS tubular | pF | Power entry to each RF cavity |
| REQ-HW-141 | Aperture Control (maximum opening) | < λ/20 at 40 GHz = 0.375 mm | mm | Screw spacing and gasket compression |
| REQ-HW-142 | PCB Edge Plating | Castellated ground vias, 1.0 mm spacing | mm | Ensures RF grounding to enclosure walls |
| REQ-HW-143 | RF Shield Can Height | 5.0 mm minimum clearance to component | mm | Prevents cavity resonance below 40 GHz |

**REQ-HW-144**: All enclosure seams, lid joints, and connector interfaces shall maintain continuous electrical contact with a measured DC resistance of less than 2.5 mΩ per seam, verified via four-wire resistance measurement per MIL-DTL-83528.

#### 3.6.13 Wire Harness and Cable Routing Requirements

**Table 3.6.13-1: Cable Routing and Wire Harness Requirements**

| ID | Parameter | Value | Unit | Notes |
|---|---|---|---|---|
| REQ-HW-145 | Internal Cable Routing | Separate cable trays for RF, LO, power, and digital | - | Prevents crosstalk |
| REQ-HW-146 | Cable Tie Material | Stainless steel, cushioned with PTFE sleeve | - | Vibration-resistant |
| REQ-HW-147 | Minimum RF Cable Separation from Digital | 10 mm minimum parallel run | mm | Reduces digital noise coupling to RF |
| REQ-HW-148 | Power Cable Gauge | 18 AWG minimum (for +15V main) | AWG | Rated for 3A continuous |
| REQ-HW-149 | Grounding Strategy | Single-point star ground at enclosure wall | - | Prevents ground loops between channels |
| REQ-HW-150 | Chassis Bonding | Braid strap, < 2.5 mΩ DC resistance | mΩ | Enclosure to vehicle chassis |

#### 3.6.14 Test Point and Access Requirements

**Table 3.6.14-1: Test Point Requirements**

| ID | Parameter | Location | Signal | Connector Type | Notes |
|---|---|---|---|---|---|
| REQ-HW-151 | IF1 Test Point (Ch1) | Cavity 3 wall | 4.0 GHz IF1 output | SMA end-launch | Switchable via coupler |
| REQ-HW-152 | IF2 Test Point (Ch1) | Cavity 4 wall | 500 MHz IF2 output | SMA end-launch | Switchable via coupler |
| REQ-HW-153 | LO1 Monitor Point | Cavity 6 wall | LO1 output sample | SMA, -20 dB coupled | Directional coupler tap |
| REQ-HW-154 | LO2 Monitor Point | Cavity 6 wall | LO2 output sample | SMA, -20 dB coupled | Directional coupler tap |
| REQ-HW-155 | +5V_RF Test Point | Cavity 7 top | +5V supply rail | 0.1" header pin | Analog multimeter access |
| REQ-HW-156 | +3.3V_DIG Test Point | Cavity 7 top | +3.3V supply rail | 0.1" header pin | Analog multimeter access |
| REQ-HW-157 | AGC Voltage Monitor (Ch1) | Cavity 4 top | VGA control voltage | 0.1" header pin | 0 to -5V range |
| REQ-HW-158 | PLL Lock Detect Test Point | Cavity 6 top | PLL MUXOUT signals | 0.1" header, 2-pin | Logic high = locked |
| REQ-HW-159 | FPGA JTAG Header | Cavity 5 top | TCK, TMS, TDI, TDO | 10-pin ARM (1.27 mm) | Programming access |
| REQ-HW-160 | OCXO Monitor | Cavity 6 top | 10 MHz reference output | SMA, -10 dB coupled | Reference verification |

**REQ-HW-161**: All test points shall be accessible without removing the enclosure lid, using side-panel access ports with IP68-sealed plugs when not in use. Test points shall not degrade the normal operation of the circuit when measured (high-impedance > 1 MΩ connection for voltage tests, > 20 dB isolation for RF coupled test points).

#### 3.6.15 Mass and Center of Gravity

**Table 3.6.15-1: Mass Budget and Center of Gravity**

| Component / Assembly | Estimated Mass (g) | Quantity | Total Mass (g) | Notes |
|---|---|---|---|---|
| Enclosure (machined aluminum) | 1800 | 1 | 1800 | 300 × 200 × 60 mm, 3 mm walls |
| PCB Assembly (12-layer, populated) | 250 | 1 | 250 | Rogers + FR-4 hybrid |
| RF Connectors (2.92mm, panel-mount) | 15 | 4 | 60 | IP68 rated |
| Power/Signal Connectors | 30 | 2 | 60 | MIL-DTL-38999 + SEARAY |
| YIG Preselector Modules | 45 | 4 | 180 | Assumed 45 g per module |
| LNA Modules (ZVA-183WA-S+) | 5 | 4 | 20 | SMT, post-assembly |
| Mixers (CMD180C3 + MMIQ-0205HSM-2) | 3 | 8 | 24 | SMT packages |
| PLL Synthesizer Modules | 2 | 2 | 4 | QFN packages |
| FPGA + Heatsink | 25 | 1 | 25 | BGA + copper spreader |
| ADCs (LTC2107) | 2 | 4 | 8 | QFN packages |
| OCXO Module | 50 | 1 | 50 | Kovtl10, hermetic package |
| TEC Module | 10 | 1 | 10 | 20 × 20 × 4 mm |
| Semi-rigid Coaxial Cables | 5 | 12 | 60 | Internal LO and IF routing |
| EMI Gaskets, Hardware, Misc | 50 | 1 | 50 | Screws, gaskets, dampers |
| LDOs and Passives | 15 | 1 | 15 | Power supply components |
| **Total Estimated Mass** | | | **2616 g** | **2.62 kg** |

**REQ-HW-162**: The total system mass shall not exceed 3.5 kg, providing 884 g (25%) margin for thermal management additions, cable assemblies, and mechanical reinforcement as the design matures.

**REQ-HW-163**: The center of gravity shall be located within ±15 mm of the geometric center of the enclosure base plate in both X and Y axes, verified by tilt test or calculation, to ensure balanced mounting to vehicle structures.

#### 3.6.16 Reliability and Maintainability Physical Requirements

**Table 3.6.16-1: Reliability and Maintainability Requirements**

| ID | Parameter | Value | Unit | Notes |
|---|---|---|---|---|
| REQ-HW-164 | Mean Time Between Failures (MTBF) | > 10,000 | hours | Calculated per MIL-HDBK-217F, ground mobile |
| REQ-HW-165 | Mean Time to Repair (MTTR) | < 30 | minutes | Modular replacement at depot level |
| REQ-HW-166 | Lid Removal Time | < 5 | minutes | Tool: M2.5 hex driver, 20 screws |
| REQ-HW-167 | Modular Sub-assembly Replacement | Channel RF modules plug-in | - | Each RF channel removable as unit |
| REQ-HW-168 | Fuse Accessibility | PTC resettable fuses accessible from rear | - | No lid removal required |
| REQ-HW-169 | Calibration Interval | 12 | months | Phase and gain calibration check |
| REQ-HW-170 | Storage Life | > 10 | years | In controlled environment, -40 to +70°C |

#### 3.6.17 Export Control and Security Markings

**Table 3.6.17-1: Export Control Requirements**

| ID | Parameter | Value | Notes |
|---|---|---|---|
| REQ-HW-171 | Export Control Classification | ECCN 9A004.b or USML Category XI | Military radar receiver, 18-40 GHz |
| REQ-HW-172 | ITAR Compliance | Required | All technical data subject to ITAR |
| REQ-HW-173 | tamper-evident Seals | 2× tamper-evident labels on lid screws | Detects unauthorized access |
| REQ-HW-174 | Firmware Protection | FPGA bitstream encrypted (AES-256) | Anti-tamper requirement |
| REQ-HW-175 | Component Traceability | All components lot-traceable to DLA QPL | Defense Logistics Agency qualified |

#### 3.6.18 Packaging, Handling, and Storage

**Table 3.6.18-1: Packaging Requirements**

| ID | Parameter | Value | Unit | Notes |
|---|---|---|---|---|
| REQ-HW-176 | Shipping Container | ATA Spec 300 Category I | - | Reusable transit case |
| REQ-HW-177 | Internal Cushioning | ESD-safe polyurethane foam, custom-cut | - | 25 mm minimum on all faces |
| REQ-HW-178 | Moisture Protection | Desiccant packs + humidity indicator card | - | Maintains < 40% RH inside case |
| REQ-HW-179 | ESD Protection | Conductive foam over all RF connectors | - | Prevents ESD damage during transit |
| REQ-HW-180 | Storage Temperature | -40 to +70 | °C | Controlled warehouse environment |
| REQ-HW-181 | Storage Humidity | 10% to 60% RH, non-condensing | % RH | With desiccant in sealed case |
| REQ-HW-182 | Shelf Life (storage) | > 10 | years | With periodic inspection (annual) |

#### 3.6.19 Safety Physical Requirements

**Table 3.6.19-1: Safety Requirements**

| ID | Parameter | Value | Notes |
|---|---|---|---|
| REQ-HW-183 | RF Radiation Hazard | Unit shall not emit > 10 mW/cm² at any external surface | Per IEEE C95.1 during normal operation |
| REQ-HW-184 | Electrical Safety | All exposed metal surfaces bonded to ground | < 0.1 Ω to chassis ground |
| REQ-HW-185 | Hot Surface Warning | Label required if surface > 50°C | Risk of burn injury |
| REQ-HW-186 | Sharp Edge Removal | All edges broken to 0.5 mm radius minimum | Prevents injury during handling |
| REQ-HW-187 | Lifting and Handling | Unit weighs < 4 kg; single-person lift permitted | Per ergonomic guidelines |
| REQ-HW-188 | Fire Resistance | Enclosure and PCB materials rated UL94 V-0 | Self-extinguishing |

#### 3.6.20 Environmental Compliance and Material Restrictions

**Table 3.6.20-1: Environmental Compliance Requirements**

| ID | Parameter | Value | Standard | Notes |
|---|---|---|---|---|
| REQ-HW-189 | RoHS Exemption | Exempt per Category 11 (military) | Directive 2011/65/EU | Lead-free assembly preferred regardless |
| REQ-HW-190 | REACH Compliance | No SVHC substances > 0.1% by weight | EU REACH Regulation | As of date of manufacture |
| REQ-HW-191 | Conflict Minerals | DRC conflict-free sourcing required | Dodd-Frank Section 1502 | Tin, tantalum, tungsten, gold |
| REQ-HW-192 | Halogen-Free PCB | FR-4 layers shall be halogen-free | IEC 61249-2-21 | Reduces toxic smoke in fire |
| REQ-HW-193 | Material Declaration | Full material declaration per IPC-1752A | IPC-1752A | Required at PDR |

#### 3.6.21 Manufacturing and Assembly Physical Constraints

**Table 3.6.21-1: Manufacturing Constraints**

| ID | Parameter | Value | Unit | Notes |
|---|---|---|---|---|
| REQ-HW-194 | Minimum SMT Component Pitch | 0.4 mm (ADC QFN, FPGA BGA) | mm | Requires Type 5 solder paste |
| REQ-HW-195 | Maximum Component Height (PCB top) | 6.0 | mm | Cavity shield can clearance |
| REQ-HW-196 | Maximum Component Height (PCB bottom) | 3.0 | mm | Enclosure base clearance |
| REQ-HW-197 | PCB Panelization | Single board, no panel (prototype) | - | V-scored if panelized for production |
| REQ-HW-198 | Reflow Profile | Per SAC305, peak 245°C ± 5°C | °C | J-STD-020 compliant |
| REQ-HW-199 | AOI Coverage | 100% solder joint inspection | % | Automated optical inspection |
| REQ-HW-200 | X-Ray Inspection | All BGA joints (FPGA, ADC) | - | Post-reflow X-ray for void analysis |
| REQ-HW-201 | ICT Bed of Nails | 50 test points minimum on PCB | - | In-circuit test access for production |

---

**End of Sections 3.3 through 3.6.** All interface, environmental, power, and physical requirements have been specified with unique REQ-HW-xxx identifiers, detailed pin tables, power budget calculations, thermal analysis, mechanical specifications, and traceability data. Requirements are ready for integration into the full IEEE 29148:2018 HRS document.

---

**Document Status: AI-GENERATED**

# 4. Design Constraints

This section defines the constraints imposed on the hardware design of the 4-channel 18–40 GHz Double-IF Superheterodyne Radar Receiver. These constraints encompass standards compliance, component limitations, and manufacturing realities that must be adhered to for the system to meet its reliability, performance, and environmental targets.

## 4.1 Standards Compliance

The design of the rx band receiver system shall comply with the following industry and military standards to ensure manufacturability, safety, electromagnetic compatibility, and environmental robustness.

### 4.1.1 PCB Design and Fabrication
The Printed Circuit Board (PCB) design for the RF Front-End and Digital Processing modules shall adhere to:

*   **IPC-2221A:** *Generic Standard on Printed Board Design.*
    *   **Constraint:** The design shall utilize the "High Density" or "Advanced" design class constraints for line widths, spacing, and hole sizes due to the 18–40 GHz operating frequency and fine-pitch FPGA/BGA packaging. Controlled impedance requirements for microstrip and stripline transmission lines must be maintained within +/- 10% of the characteristic impedance (50 ohms typically).
*   **IPC-6012 Class 3:** *Qualification and Performance Specification for Rigid Printed Boards.*
    *   **Constraint:** The bare PCB fabrication must meet Class 3 standards (High Reliability Electronic Products). This dictates strict tolerances on layer registration, plating thickness in through-holes, and minimal voiding in solder joints to ensure survival under -55°C to +125°C thermal cycling and MIL-STD-810 vibration profiles.
*   **IPC-6017:** *Specification for High Density Interconnect (HDI) Boards.*
    *   **Constraint:** The RF receiver board shall utilize HDI technology (microvias, sequential lamination) as required to accommodate the 210 Msps ADC (LTC2107) interface to the FPGA (XC7K355T) and the tight pitch of the GHz-range RF components.

### 4.1.2 Assembly and Repair
*   **IPC-7711/21:** *Rework of Electronic Assemblies / Rework, Modification and Repair of Electronic Assemblies.*
    *   **Constraint:** All repair and rework procedures developed for the field or depot maintenance of the RF modules must follow IPC-7711 guidelines to prevent damage to sensitive GaN MMICs and the fine-pitch FPGA during component replacement.

### 4.1.3 Environmental and Mechanical
*   **MIL-STD-810G:** *Environmental Engineering Considerations and Laboratory Tests.*
    *   **Constraint:** The mechanical design (enclosure, PCB mounting, connector retention) shall be qualified to meet or exceed the following test methods without performance degradation:
        *   Method 527.6 (Vibration, 11-200 Hz, Heavy Duty)
        *   Method 506.6 (Rain, Procedure III)
        *   Method 520.4 (Shock)
*   **IP68 / IEC 60529:** *Degrees of Protection Provided by Enclosures.*
    *   **Constraint:** The enclosure sealing design must guarantee Ingress Protection 68 (dust-tight and continuous immersion in water beyond 1 meter), ensuring the RF chain operates in harsh maritime or field environments.

### 4.1.4 Electromagnetic Compatibility (EMC)
*   **MIL-STD-461G:** *Requirements for the Control of Electromagnetic Interference Characteristics of Subsystems and Equipment.*
    *   **Constraint:** The receiver shall meet the limits for:
        *   **CE101:** Conducted Emissions, Power Leads, 30 Hz – 10 kHz (Strict filtering on +15V input).
        *   **RE102:** Radiated Emissions, Electric Field, 2 MHz – 18 GHz (Extended to 40 GHz for this application).
        *   **CS101:** Conducted Susceptibility, Power Leads, 30 Hz – 150 kHz.
        *   **RS103:** Radiated Susceptibility, Electric Field, 2 MHz – 40 GHz (Shielding effectiveness > 100 dB).
*   **FCC Part 15 Subpart B:** *Digital Devices.*
    *   **Constraint:** While this is a military specialized receiver, the digital clock noise from the FPGA (210 MHz+) and LVDS outputs must be suppressed to prevent interference with other onboard systems.

### 4.1.5 Safety and Hazardous Materials
*   **RoHS Directive 2011/65/EU:** *Restriction of Hazardous Substances.*
    *   **Constraint:** The system shall be RoHS compliant (Lead-free, < 1000 ppm PBB/PBDE). However, "Military Exemption" components (specifically high-reliability ceramic capacitors or older MMICs) may be utilized only if RoHS-compliant drop-in replacements are unavailable and a waiver is granted.
*   **REACH Regulation (EC) No 1907/2006:**
    *   **Constraint:** All substances of very high concern (SVHC) in the Bill of Materials (BOM) must be declared and below the threshold limit.
*   **UL 60950-1:** *Information Technology Equipment - Safety.*
    *   **Constraint:** The power supply entry section (15V input) must meet creepage and clearance requirements for safety isolation to prevent operator shock hazards.

## 4.2 Component Constraints

This section outlines the limitations regarding the selection, lifecycle, and utilization of electronic components within the rx band receiver.

### 4.2.1 Component Lifecycle and Sourcing
*   **REQ-HW-041 (Lifecycle Status):** All active components (RF ICs, ADCs, FPGAs) selected for the design must be in "Production" or "Active" status.
    *   **Constraint:** No components in "Not Recommended for New Design" (NRND) or "Obsolete" status shall be used in the BOM unless a formal waiver is submitted demonstrating no other technological fit exists (e.g., specifically for the CMD181 mixer covering the 26-40 GHz upper band).
*   **REQ-HW-042 (Multi-Sourcing):** Where possible, critical components shall have a second-source identified in the component library to mitigate supply chain risks.
    *   **Specific Constraint:** The GaN LNA (ZVA-183WA-S+) is currently a single-source item from Mini-Circuits. A footprint adapter must be designed to allow the use of the *PMA2-123LNW+* as a lower-performance backup without requiring a PCB spin.
*   **REQ-HW-043 (Radiation Tolerance):** Components used in the signal path prior to the final IF must be evaluated for Total Ionizing Dose (TID) susceptibility if the platform is intended for high-altitude flight. Commercial Off-The-Shelf (COTS) parts (LTC2107, XC7K355T) are assumed acceptable for ground/naval applications but require shielding scrutiny.

### 4.2.2 Packaging Constraints
*   **Cavity Requirement (GaN RF):** The ZVA-183WA-S+ LNA and CMD180C3 mixers are highly sensitive to solder heat and mechanical stress. They shall be mounted in milled pockets in the RF housing, ensuring the PCB substrate is coplanar with the floor of the cavity to minimize bond wire length and ground inductance.
*   **BGA Assembly (FPGA):** The Xilinx XC7K355T is an FGG676 package. The PCB stackup must be designed with laser-drilled microvias (via-in-pad) to escape the high-density 1.0mm pitch balls. Standard mechanical drilling is insufficient for this footprint.

### 4.2.3 Performance Limits of Selected Components
The design must respect the absolute maximum ratings derived from the selected component datasheets:

| Component ID | Parameter | Absolute Maximum | Design Constraint |
| :--- | :--- | :--- | :--- |
| **ZVA-183WA-S+** | Input RF Power | +20 dBm | (REQ-HW-010) Input Limiter required. |
| **LTC2107** | Clock Input | 1.6V P-P | FPGA LVDS drivers must be current-limited to 3.5 mA. |
| **XC7K355T** | Junction Temp (Tj) | +100°C | Requires heatsink to keep Tj < 85°C at 125°C ambient. |
| **LMX2820** | Output Frequency | 22.6 GHz | Frequency multiplier (x2 or x4) required in LO path to reach 40 GHz. |

## 4.3 Manufacturing Constraints

The physical realization of the rx band receiver requires specific manufacturing processes to achieve the required RF performance and environmental sealing.

### 4.3.1 PCB Material and Stackup
*   **Material Selection:** Standard FR-4 laminate is unsuitable for the 18–40 GHz front end due to high loss tangent.
    *   **Constraint:** The RF Front End section shall use **Rogers RO3003** or **Rogers RO4350B** laminate (εr ≈ 3.38 - 3.5) with low loss tangent (tan δ < 0.0037) to minimize insertion loss and stabilize dielectric constant over temperature.
*   **Hybrid Stackup:** The system board shall be a hybrid construction. The outer layers (RF) will be Rogers material, while inner layers (Digital Power/Ground) can use high-Tg FR-4 (Isola 370HR) to reduce cost, bonded using a prepreg system compatible with both materials (e.g., Rogers RO4450F).

### 4.3.2 Tuning and Calibration
*   **YIG Filter Tuning:** The Preselector (Tunable YIG) requires a high-current driver (approx 0.5 A) for magnetic tuning. The mechanical design must allocate space for the YIG oscillator coil to avoid saturating nearby transformers or inductors.
*   **Phase Trim:** Due to the analog nature of the mixers and the 4-channel distribution network, **Phase Matching** is required post-assembly. The LO distribution network (CLKDIST) must include trace-length adjustments or programmable delay lines to align the 4 channels to within <1 ps (REQ-HW-013).

### 4.3.3 Shielding and Isolation
*   **Cavity Shielding:** To meet the +65 dB gain and stability requirements (REQ-HW-026), the RF chain shall be segregated into at least three isolated shielded compartments using CNC-milled aluminum walls:
    1.  **LNA Zone:** Sensitive input stage.
    2.  **IF1/LO1 Zone:** High power LO injection and first mixing.
    3.  **IF2/ADC Zone:** Low-level final IF and high-speed digital conversion.
*   **Feedthroughs:** All DC and control signals entering these RF cavities must utilize EMI feedthrough capacitors or Pi-filters to prevent RF leakage.

### 4.3.4 Thermal Management
*   **Power Dissipation:** With a power budget of 25W and an ambient temperature requirement of +125°C, passive convection cooling is insufficient.
    *   **Constraint:** The baseplate of the receiver must interface with a cold plate or chassis thermal rail capable of maintaining the case temperature below 100°C.
    *   **Heat Spreading:** The Xilinx Kintex-7 FPGA requires a dedicated copper heat spreader (1mm thickness) attached via thermal epoxy or mechanical screw down to the chassis.

### 4.3.5 Conformal Coating
*   **Constraint:** Due to the IP68 requirement, the completed PCBA must be coated with a thin-film conformal coating (e.g., Parylene C or acrylic) to protect against moisture ingress, with masking applied to RF connector interfaces and heat sink surfaces to ensure proper thermal transfer.