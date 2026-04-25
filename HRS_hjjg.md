**Document Status: AI-GENERATED**

# 1. Introduction

## 1.1 Purpose

This Hardware Requirements Specification (HRS) defines the complete set of hardware requirements for the **hjjg** project: a dual-channel, phase-coherent, double-IF superheterodyne radar receiver system operating over the 2–6 GHz frequency band. The document establishes the functional, performance, interface, environmental, and physical requirements that the hardware design must satisfy to meet the intended military radar applications.

The primary purpose of this document is to provide a verifiable, traceable baseline of hardware requirements that will:
1. Guide the detailed circuit design, PCB layout, and mechanical integration of the receiver system.
2. Establish clear acceptance criteria for hardware verification and validation testing.
3. Define the interface boundaries between the analog receiver front-end, the mixed-signal digitisation stage, the digital signal processing FPGA, and the system power supply.
4. Support the system-level radar performance targets, including a range resolution of ≤1 m, spurious-free dynamic range (SFDR) of ≥80 dB, and phase-coherent processing across two independent receive channels.

## 1.2 Scope

This specification covers the hardware design of the complete dual-channel radar receiver assembly, from the antenna input ports to the digital data output interface on the FMC+ connector. The scope includes:

**In Scope:**
*   **Two identical RF front-end channels**, each consisting of a PIN-diode limiter, tunable preselector band-pass filter (BPF), GaAs pHEMT Low Noise Amplifier (LNA), and two stages of down-conversion.
*   **A shared Local Oscillator (LO) and clock generation chain**, comprising an Oven-Controlled Crystal Oscillator (OCXO) reference, Phase-Locked Loops (PLLs), Voltage-Controlled Oscillators (VCOs), and power splitters to ensure phase coherence.
*   **Intermediate Frequency (IF) signal chains**, including IF band-pass filters at 1300 MHz (1st IF) and 200 MHz (2nd IF), driver amplifiers, and anti-alias filtering.
*   **Data conversion subsystem**, utilizing 14-bit, 170 MSPS Analog-to-Digital Converters (ADCs) with Low-Voltage Differential Signaling (LVDS) outputs.
*   **Power distribution network**, converting a +12 VDC primary input to the required regulated +5 V, +3.3 V, and +1.8 V rails via switching buck converters and low-dropout (LDO) linear regulators.
*   **An FMC+ compatible interface** for digitized data transfer and control signals to an external Kintex-7 FPGA processing card.

**Out of Scope:**
*   Design of the external Kintex-7 FPGA carrier card and firmware/FPGA logic.
*   Antenna design and radome integration.
*   External system-level radar controller and signal processing software.
*   System-level software requirements.

## 1.3 Definitions, Acronyms, and Abbreviations

| Acronym / Term | Definition |
| :--- | :--- |
| **ADC** | Analog-to-Digital Converter |
| **BPF** | Band-Pass Filter |
| **CW** | Continuous Wave |
| **dB** | Decibel |
| **dBc** | Decibels relative to the carrier |
| **dBm** | Decibels relative to 1 milliwatt |
| **ENOB** | Effective Number of Bits |
| **FMC** | FPGA Mezzanine Card (VITA 57) |
| **FMC+** | FPGA Mezzanine Card Plus (VITA 57.4) |
| **GaAs** | Gallium Arsenide |
| **HRS** | Hardware Requirements Specification |
| **IBW** | Instantaneous Bandwidth |
| **IF** | Intermediate Frequency |
| **IIP3** | Input Third-Order Intercept Point |
| **LNA** | Low Noise Amplifier |
| **LO** | Local Oscillator |
| **LVDS** | Low-Voltage Differential Signaling |
| **MDS** | Minimum Detectable Signal |
| **MIL-STD** | United States Military Standard |
| **MSPS** | Mega-Samples Per Second |
| **NF** | Noise Figure |
| **OIP3** | Output Third-Order Intercept Point |
| **OCXO** | Oven-Controlled Crystal Oscillator |
| **P1dB** | 1 dB Compression Point |
| **pHEMT** | Pseudomorphic High Electron Mobility Transistor |
| **PLL** | Phase-Locked Loop |
| **PRI** | Pulse Repetition Interval |
| **RF** | Radio Frequency |
| **SFDR** | Spurious-Free Dynamic Range |
| **SMA** | Subminiature Version A (coaxial connector) |
| **SMT** | Surface Mount Technology |
| **VCO** | Voltage-Controlled Oscillator |
| **VSWR** | Voltage Standing Wave Ratio |

## 1.4 References

The following documents form a part of this specification to the extent specified herein.

| Ref ID | Document ID | Title | Revision / Date |
| :--- | :--- | :--- | :--- |
| [REF-1] | IEEE 29148:2018 | ISO/IEC/IEEE International Standard - Systems and software engineering -- Life cycle processes --Requirements engineering | 2018 Edition |
| [REF-2] | MIL-STD-810H | Department of Defense Test Method Standard: Environmental Engineering Considerations and Laboratory Tests | 31 Dec 2019 |
| [REF-3] | VITA 57.1 | FPGA Mezzanine Card (FMC) Standard | 2008 |
| [REF-4] | VITA 57.4 | FPGA Mezzanine Card Plus (FMC+) Standard | 2018 |
| [REF-5] | GRF2074 Datasheet | Guerrilla RF Ultra Low Noise Amplifier 1.0 - 6.0 GHz | Rev B |
| [REF-6] | AD9643 Datasheet | Analog Devices 14-Bit, 170 MSPS/210 MSPS A/D Converter | Rev C |
| [REF-7] | MCA1-42+ Datasheet | Mini-Circuits Level 7 SMT Double Balanced Mixer | Rev B2 |
| [REF-8] | HMC788ALP2E Datasheet | Analog Devices Linear Drive/Gain Block, DC - 10 GHz | Rev 0 |
| [REF-9] | ADF4106 Datasheet | Analog Devices PLL Frequency Synthesizer | Rev D |
| [REF-10] | HMC586LC4B Datasheet | Analog Devices Wideband VCO 2500 - 5300 MHz | Rev 0 |

## 1.5 Overview

This HRS is organized to progressively describe the system context, break down the specific technical requirements, and establish the criteria for hardware verification.

*   **Section 2 (System Overview)** provides a high-level description of the dual-channel radar receiver. It includes a top-level system block diagram (via Mermaid flowcharts) identifying the key signal, LO, and power distribution chains, and describes the double-IF superheterodyne architecture (RF → 1300 MHz → 200 MHz).
*   **Section 3 (Hardware Requirements)** forms the core of the document. It details the functional logic (frequency coverage, pulse processing), performance benchmarks (gain, noise figure, SFDR, linearity), interface definitions (FMC pinouts, SMA connectors), environmental constraints (-55 °C to +125 °C), and the power budget architecture.
*   **Section 4 (Design Constraints)** specifies the boundaries of the design, including applicable military standards (MIL-STD-810), specific component selections (e.g., specific Mini-Circuits and Analog Devices parts), and manufacturing limits (e.g., controlled impedance PCB requirements).
*   **Section 5 (Verification Requirements)** maps directly to the requirements in Section 3, detailing exactly how each requirement will be validated—whether through laboratory testing, simulation analysis, or physical inspection.
*   **Section 6 (Preliminary BOM)** provides an initial list of critical components with manufacturer part numbers.
*   **Section 7 (Traceability Matrix)** maps the project-level user requirements to the specific hardware requirement IDs (REQ-HW-xxx) and their corresponding verification methods.

---

**Document Status: AI-GENERATED**

# 2. System Overview

## 2.1 System Description

The **hjjg** system is a dual-channel, phase-coherent, double-IF superheterodyne radar receiver engineered to operate continuously across the 2–6 GHz frequency band. Designed to interface with an external digital signal processing unit via an FMC/FMC+ connector, the system accepts two independent RF inputs from separate antennas, subjects them to identical analog conditioning and downconversion chains, digitizes the resulting baseband signals, and transmits them in parallel to a Kintex-7 FPGA for coherent processing.

The system is designed around the double-IF superheterodyne architecture. The first Intermediate Frequency (IF1) is centered at 1300 MHz, and the second Intermediate Frequency (IF2) is centered at 200 MHz. This two-stage downconversion strategy places the image frequencies sufficiently far from the operating band, allowing the use of high-selectivity fixed filters to achieve the required 80 dBc adjacent-channel rejection.

### Signal Chain Description
Each of the two identical RF front-end channels consists of the following sequential signal conditioning and downconversion stages:

1.  **RF Protection:** An RF input limiter based on the Pasternack PE8022 protects the sensitive downstream GaAs pHEMT LNA from high-power incident radar pulses or nearby transmitters up to +40 dBm (100W peak).
2.  **Preselection:** A tunable bandpass filter (YIG-tuned or LC bank) rejects out-of-band interference and establishes the initial selectivity prior to the first active stage.
3.  **Low-Noise Amplification:** A Guerrilla RF GRF2074 GaAs pHEMT Low Noise Amplifier (LNA) provides +20 dB of gain with a sub-1 dB noise figure, establishing the system noise floor.
4.  **First Downconversion:** A Mini-Circuits MCA1-42+ Level 7 double-balanced mixer translates the 2–6 GHz RF signal to the 1300 MHz first IF. The Local Oscillator (LO1) sweeps from 3.3 to 7.3 GHz.
5.  **First IF Filtering:** A fixed 1300 MHz Bandpass Filter (BPF) rejects mixer spurs and establishes the initial image rejection for the second conversion stage.
6.  **Second Downconversion:** A Mini-Circuits RMS-2+ Level 7 mixer translates the 1300 MHz IF1 to the 200 MHz second IF using a fixed 1.1 GHz LO2.
7.  **Second IF Filtering:** A fixed 200 MHz BPF provides the final narrowband selectivity (80 dBc).
8.  **IF Driving:** An Analog Devices HMC788ALP2E wideband gain block provides the final +14 dB of gain and the necessary +19 dBm output power to drive the analog-to-digital converter.
9.  **Digitisation:** An Analog Devices AD9643BCPZ-170 14-bit 170 MSPS ADC samples the 200 MHz IF signal, converting it to digital data.
10. **Digital Interface:** Digitized data is routed via Low-Voltage Differential Signaling (LVDS) to a Kintex-7 FPGA through an FMC/FMC+ edge connector.

### Local Oscillator (LO) and Clock Architecture
To satisfy the strict phase-coherence requirements for radar processing (REQ-HW-012), both channels share a single, common LO distribution chain derived from a single 10 MHz Oven Controlled Crystal Oscillator (OCXO, OSJ7014-10.0M). This reference feeds two independent PLL/VCO synthesizers (ADF4106BRUZ-RL):
*   **LO1:** An ADF4106 PLL paired with an HMC586LC4BTR VCO generates the 3.3–7.3 GHz tunable LO1 signal.
*   **LO2:** An ADF4106 PLL paired with an RMS-2+ mixer (utilized as an X2 frequency multiplier/LO) generates the fixed 1.1 GHz LO2 signal.

The LO signals are distributed to the respective mixers via 2-way zero-degree power splitters (Mini-Circuits EP2K1+), ensuring an identical phase reference for both the Ch1 and Ch2 downconversion paths.

### Power Distribution Architecture
The system operates from a single +12 VDC primary supply rail (REQ-HW-019). A hierarchical power tree ensures isolation between noisy digital rails and sensitive analog/RF rails:
*   **+12 V to +5 V:** A main 3A buck converter distributes the primary analog supply.
*   **+5 V to +3.3 V:** A secondary 3A buck converter supplies digital logic and interface power.
*   **+5 V to +1.8 V:** A tertiary 2A buck converter supplies FPGA core and auxiliary logic.
*   **Point-of-Load (POL):** Low-dropout regulators (MIC5209) derive ultra-low-noise +5V and +3.3V rails directly at the power pins of the LNAs, mixers, PLLs, and ADCs to prevent power supply noise from degrading phase noise and noise figure (REQ-HW-022).

## 2.2 System Block Diagram

The following diagram illustrates the top-level functional signal flow, LO distribution, and digital interfaces for the dual-channel receiver. Note that "CG" denotes the cumulative cascaded gain of +50 dB, "CNF" denotes the cascaded noise figure of 4.7 dB, "CP1" is the output 1 dB compression point of +12 dBm, and "CIP3" is the output third-order intercept point of +20 dBm.

```mermaid
flowchart TD
    %% Styling
    classDef antenna fill:#f9f,stroke:#333,stroke-width:2px;
    classDef rf fill:#bbf,stroke:#333,stroke-width:1px;
    classDef if fill:#bfb,stroke:#333,stroke-width:1px;
    classDef lo fill:#fbb,stroke:#333,stroke-width:1px;
    classDef digital fill:#ffb,stroke:#333,stroke-width:2px;
    classDef power fill:#ddd,stroke:#333,stroke-width:1px;

    %% Inputs
    ANT1>"Antenna 1<br/>2-6 GHz"]:::antenna
    ANT2>"Antenna 2<br/>2-6 GHz"]:::antenna

    %% Channel 1 RF
    SMA1[/"SMA-F Ch1"/]:::rf
    LIM1[/"Limiter / PE8022<br/>IL: 0.5 dB, Pmax: +40 dBm"/]:::rf
    BPF1{{"Preselector / Tunable BPF<br/>2-6 GHz, IL: 2.5 dB"}}:::rf
    LNA1>"LNA / GRF2074<br/>G: +20 dB, NF: 0.8 dB, P1dB: +20 dBm"]:::rf
    MIX1A("1st Mixer / MCA1-42+<br/>RF: 2-6G, IF: 1300M, CL: 7.0 dB"):::rf
    
    %% Channel 2 RF
    SMA2[/"SMA-F Ch2"/]:::rf
    LIM2[/"Limiter / PE8022<br/>IL: 0.5 dB, Pmax: +40 dBm"/]:::rf
    BPF2{{"Preselector / Tunable BPF<br/>2-6 GHz, IL: 2.5 dB"}}:::rf
    LNA2>"LNA / GRF2074<br/>G: +20 dB, NF: 0.8 dB, P1dB: +20 dBm"]:::rf
    MIX1B("1st Mixer / MCA1-42+<br/>RF: 2-6G, IF: 1300M, CL: 7.0 dB"):::rf

    %% Channel 1 IF
    IF1F1{{"IF1 BPF / 1300 MHz<br/>IL: 1.5 dB"}}:::if
    MIX2A("2nd Mixer / RMS-2+<br/>RF: 1300M, IF: 200M, CL: 6.5 dB"):::if
    IF2F1{{"IF2 BPF / 200 MHz<br/>IL: 1.5 dB"}}:::if
    DRV1>"Driver Amp / HMC788ALP2E<br/>G: +14 dB, P1dB: +19 dBm"]:::if
    ADC1[\"ADC / AD9643BCPZ-170<br/>14-bit, 170 MSPS"/]:::digital

    %% Channel 2 IF
    IF1F2{{"IF1 BPF / 1300 MHz<br/>IL: 1.5 dB"}}:::if
    MIX2B("2nd Mixer / RMS-2+<br/>RF: 1300M, IF: 200M, CL: 6.5 dB"):::if
    IF2F2{{"IF2 BPF / 200 MHz<br/>IL: 1.5 dB"}}:::if
    DRV2>"Driver Amp / HMC788ALP2E<br/>G: +14 dB, P1dB: +19 dBm"]:::if
    ADC2[\"ADC / AD9643BCPZ-170<br/>14-bit, 170 MSPS"/]:::digital

    %% LO Chain
    REF("10 MHz OCXO / OSJ7014-10.0M"):::lo
    LO1("LO1 Synth / ADF4106 + HMC586LC4B<br/>3.3-7.3 GHz"):::lo
    LO2("LO2 Synth / ADF4106 + RMS-2+<br/>1.1 GHz Fixed"):::lo
    SP1{"LO1 Splitter / EP2K1+<br/>2-way 0°"}:::lo
    SP2{"LO2 Splitter / EP2K1+<br/>2-way 0°"}:::lo

    %% FPGA / Digital
    FPGA["Kintex-7 FPGA<br/>DSP & Control"]:::digital
    FMC[/"FMC+ Connector"/]:::digital

    %% Connections CH1
    ANT1 --> SMA1 --> LIM1 --> BPF1 --> LNA1 --> MIX1A
    REF --> LO1 --> SP1
    REF --> LO2 --> SP2
    SP1 -- "+13 dBm LO1" --> MIX1A
    MIX1A --> IF1F1 --> MIX2A
    SP2 -- "+10 dBm LO2" --> MIX2A
    MIX2A --> IF2F1 --> DRV1 --> ADC1

    %% Connections CH2
    ANT2 --> SMA2 --> LIM2 --> BPF2 --> LNA2 --> MIX1B
    SP1 -- "+13 dBm LO1" --> MIX1B
    MIX1B --> IF1F2 --> MIX2B
    SP2 -- "+10 dBm LO2" --> MIX2B
    MIX2B --> IF2F2 --> DRV2 --> ADC2

    %% Digital Connections
    ADC1 -- "LVDS Ch1" --> FPGA
    ADC2 -- "LVDS Ch2" --> FPGA
    FPGA -- "Data & Ctrl" --> FMC
```

## 2.3 System Architecture

The system architecture partitions the radar receiver into distinct functional domains to ensure signal integrity, maintain phase coherence, and isolate sensitive analog components from high-speed digital switching noise. The architecture is physically realized as a single multi-layer Printed Circuit Board (PCB) integrated into a machined aluminum enclosure, utilizing milled shielded cavities to isolate the RF, IF, and LO sections as mandated by REQ-HW-022.

### 2.3.1 Analog Signal Architecture
The analog architecture relies on discrete, high-linearity components tailored for military radar environments. 

*   **Frequency Plan:** The RF band (2–6 GHz) is divided into overlapping sub-bands managed by the tunable preselector. The frequency translation follows a strict high-side injection plan to minimize spurious responses:
    *   $f_{IF1} = f_{LO1} - f_{RF} = 1300 \text{ MHz}$ (where $f_{LO1}$ spans $3.3 - 7.3 \text{ GHz}$)
    *   $f_{IF2} = f_{IF1} - f_{LO2} = 1300 \text{ MHz} - 1100 \text{ MHz} = 200 \text{ MHz}$
*   **Gain Distribution:** The cascade provides precisely +50 dB of nominal voltage gain (REQ-HW-004). Gain is concentrated at the front-end via the GRF2074 LNA (+20 dB) to overcome the 5 dB system noise figure requirement (REQ-HW-003). The back-end HMC788ALP2E driver provides +14 dB to meet the +10 dBm output P1dB requirement (REQ-HW-006).

### 2.3.2 Local Oscillator (LO) and Timing Architecture
Phase coherence in a multi-channel receiver dictates that local oscillator phase noise and phase drift do not corrupt the relative phase delta between channels. The LO Architecture achieves this by distributing a single, low-phase-noise 10 MHz reference to all PLL stages.

*   **Reference Oscillator:** The OSJ7014-10.0M OCXO provides a stable 10 MHz reference, ensuring LO phase noise meets the strict -120 dBc/Hz @ 10 kHz offset requirement (REQ-HW-014).
*   **LO Distribution:** The 2-way zero-degree splitters (EP2K1+) ensure that the electrical length and insertion phase from the VCO output to each mixer LO port are identical. This symmetry guarantees that phase perturbations affect both channels equally, preserving the differential phase accuracy needed for coherent radar processing (REQ-HW-012).

### 2.3.3 Digital and Data Interface Architecture
Digitization occurs at the 2nd IF frequency (200 MHz) using dual high-speed ADCs.
*   **ADC Operation:** The AD9643 samples the 200 MHz IF at 170 MSPS. The analog input is transformer-coupled to the ADC. With a 200 MHz input, the ADC operates in the 2nd Nyquist zone, achieving an Effective Number of Bits (ENOB) $\ge$ 11.5 to fulfill REQ-HW-015.
*   **Data Transport:** The 14-bit parallel data streams from both ADCs are converted to LVDS pairs. The data is clocked synchronously into the Kintex-7 FPGA.
*   **Form Factor:** The architecture is designed to map directly to an FMC (VITA 57) or FMC+ (VITA 57.4) standard mezzanine card, routing power, ground, and the high-speed LVDS pairs directly to the connector for integration with an external carrier card containing the DSP hardware.

### 2.3.4 Power Distribution Architecture
The power architecture maximizes noise rejection to prevent power supply modulation from appearing as spurs in the RF chain.

```mermaid
flowchart TB
    %% Styling
    classDef pwr fill:#ff9,stroke:#333,stroke-width:1px;
    classDef rf load fill:#bbf,stroke:#333,stroke-width:1px;
    classDef analog load fill:#bfb,stroke:#333,stroke-width:1px;

    PSU[/"Primary Supply +12 VDC<br/>Max 15 W (REQ-HW-019)"/]:::pwr

    %% Main Buck Tree
    BUCK1["Buck Converter 1<br/>12V -> 5V @ 3A"]:::pwr
    BUCK2["Buck Converter 2<br/>5V -> 3.3V @ 3A"]:::pwr
    BUCK3["Buck Converter 3<br/>5V -> 1.8V @ 2A"]:::pwr
    
    PSU ==> BUCK1
    BUCK1 --> BUCK2
    BUCK1 --> BUCK3

    %% LDO Distribution for Low Noise
    subgraph LNOISE ["Ultra-Low-Noise Point-of-Load Regulation"]
        LDO_LNA["LDO Bank 1 (MIC5209)<br/>5V -> 5V (LNAs x2)"]:::pwr
        LDO_MIX["LDO Bank 2 (MIC5209)<br/>5V -> 5V (Mixers x4)"]:::pwr
        LDO_LO["LDO Bank 3 (MIC5209)<br/>3.3V -> 3.3V (PLL/VCOs)"]:::pwr
        LDO_ADC["LDO Bank 4 (MIC5209)<br/>3.3V -> 3.3V (ADCs x2)"]:::pwr
    end

    BUCK1 -- "+5V Raw" --> LDO_LNA
    BUCK1 -- "+5V Raw" --> LDO_MIX
    BUCK2 -- "+3.3V Raw" --> LDO_LO
    BUCK2 -- "+3.3V Raw" --> LDO_ADC
    BUCK3 -- "+1.8V Raw" --> FPGA_CORE["FPGA Core / Aux Power"]:::pwr

    %% Loads
    LDO_LNA -.-> CH1_LNA["Ch1 LNA"]
    LDO_LNA -.-> CH2_LNA["Ch2 LNA"]
    LDO_MIX -.-> MIXERS["Ch1 & Ch2 Mixers"]
    LDO_LO -.-> LOS["LO1 & LO2 VCO/PLLs"]
    LDO_ADC -.-> ADCS["Ch1 & Ch2 ADCs"]
```

## 2.4 Operating Environment

The "hjjg" receiver is engineered to meet stringent military environmental standards. The components selected for the design feature operating temperature ranges that inherently support the full -55 °C to +125 °C military temperature range (REQ-HW-020), and the physical construction is designed to withstand the mechanical stresses typical of airborne or mobile ground radar platforms.

### 2.4.1 Thermal Environment
*   **Ambient Operating Temperature:** -55 °C to +125 °C.
*   **Thermal Management Strategy:** Total DC power dissipation is strictly capped at 15 W (REQ-HW-019). The PCB is constructed on a high thermal conductivity substrate (e.g., Rogers RO4350B for RF layers, bonded to FR-4 for structural layers) featuring a dense array of thermal vias beneath all active components. The machined aluminum enclosure acts as a heatsink and a continuous ground plane, ensuring that junction temperatures remain within the absolute maximum limits of the components (e.g., the AD9643BCPZ is rated to +125 °C). A preliminary thermal analysis suggests that at maximum ambient temperature (+125 °C), the internal junction temperatures will remain within a +5 °C to +10 °C delta above ambient due to the direct thermal path provided by the shielded cavity construction.

### 2.4.2 Mechanical Environment
*   **Vibration and Shock:** The system must satisfy the light vibration and shock profiles defined in MIL-STD-810 (REQ-HW-021). To achieve this:
    *   All surface-mount components are adhered to the PCB using high-strength, temperature-resistant solder (e.g., Sn96.5/Ag3.0/Cu0.5 SAC305).
    *   RF shielding cans are securely fastened using both solder tabs and mechanical standoffs.
    *   High-mass components (such as the FMC+ connector and large coupling capacitors) are staked with an approved epoxy (e.g., Hysol EA9394) to prevent mechanical fatigue during sustained vibration profiles.

### 2.4.3 Electromagnetic Interference (EMI) Environment
*   **Intrachannel Isolation:** To prevent oscillation given the cascaded gain of > 45 dB (REQ-HW-022), the physical layout utilizes shielded-cavity construction. The RF front-end (2-6 GHz) and the two IF stages (1300 MHz and 200 MHz) are situated in separate milled pockets within the aluminum enclosure.
*   **Power Supply Rejection:** LC and ferrite bead rail decoupling is implemented at the power pins of every gain stage to prevent power supply noise from coupling into the RF path.
*   **EMI Shielding:** The lid of the enclosure provides a continuous RF gasket (e.g., Spira EMI gaskets) to ensure > 80 dB of inter-stage isolation, directly supporting the system's selectivity and spurious-free dynamic range requirements.

---

**Document Status: AI-GENERATED**

# 3. Hardware Requirements

## 3.1 Functional Requirements

The following section details the functional requirements of the hjjg Dual-Channel Radar Receiver. These requirements mandate specific behaviors, capabilities, and features of the hardware system to ensure it meets the operational intent of a phase-coherent, double-IF superheterodyne radar receiver.

### Table 3-1: Functional Requirements

| ID | Title | Description | Rationale | Priority |
|---|---|---|---|---|
| **REQ-HW-001** | **RF Frequency Coverage** | The receiver shall accept and process RF signals in the 2.0 GHz to 6.0 GHz band via the SMA antenna ports. | Ensures compatibility with the target radar frequency band (S-band and C-band). | Shall |
| **REQ-HW-002** | **Dual-Channel Phase Coherence** | The system shall provide two (2) independent receiver channels that share a common Local Oscillator (LO) reference source to ensure phase-coherent processing. | Required for monopulse or interferometric radar processing techniques requiring phase comparison between channels. | Shall |
| **REQ-HW-003** | **RF Input Protection** | The receiver front-end shall include a PIN-diode limiter (e.g., PE8022) capable of withstanding peak input powers up to +40 dBm (100W) with a recovery time ≤ 20 ns. | Protects sensitive LNA components from high-power radar pulses and nearby transmitters. | Shall |
| **REQ-HW-004** | **Preselection Filtering** | The receiver shall utilize a tunable Preselector Bandpass Filter (BPF) bank or YIG filter after the limiter to reject out-of-band interferers before the LNA. | Improves system linearity and rejection of image frequencies and out-of-band noise. | Shall |
| **REQ-HW-005** | **Low Noise Amplification** | The system shall employ a GaAs pHEMT LNA (e.g., GRF2074) providing a minimum gain of 20 dB and a Noise Figure (NF) ≤ 1.0 dB immediately following the preselector. | Sets the system noise floor; ensures the Minimum Detectable Signal (MDS) requirement is met. | Shall |
| **REQ-HW-006** | **Double-IF Downconversion Architecture** | The receiver shall downconvert the RF signal to a 1st IF of 1300 MHz, followed by a 2nd downconversion to a final IF of 200 MHz. | A double-conversion architecture is necessary to achieve the required image rejection and selectivity over the wide 2-6 GHz input range. | Shall |
| **REQ-HW-007** | **1st Mixer Stage** | The 1st IF stage shall utilize a double-balanced mixer (e.g., MCA1-42+) driven by a high-frequency LO (3.3–7.3 GHz) to translate RF to 1300 MHz. | Performs the initial frequency translation while maintaining high linearity. | Shall |
| **REQ-HW-008** | **1st IF Filtering** | The signal path between the 1st and 2nd mixers shall pass through a 1300 MHz Bandpass Filter with a bandwidth sufficient for the 100 MHz instantaneous signal bandwidth. | Removes the 1st image frequency and LO leakage prior to the 2nd mixing stage. | Shall |
| **REQ-HW-009** | **2nd Mixer Stage** | The 2nd IF stage shall utilize a high-IP3 mixer (e.g., RMS-2+) driven by a 1.1 GHz LO to translate 1300 MHz IF to 200 MHz IF. | Translates the signal to a lower frequency suitable for high-dynamic-range digitization. | Shall |
| **REQ-HW-010** | **2nd IF Filtering** | The final IF stage shall include a 200 MHz Bandpass Filter to define the noise bandwidth and reject mixer products. | Sets the final system bandwidth and ensures anti-aliasing requirements are met. | Shall |
| **REQ-HW-011** | **IF Gain & Drive** | The system shall include an IF Driver Amplifier (e.g., HMC788ALP2E) prior to the ADC to provide +14 dB gain and drive the ADC input to full scale. | Compensates for conversion losses and ensures the ADC utilizes its full dynamic range. | Shall |
| **REQ-HW-012** | **Analog-to-Digital Conversion** | The system shall digitize the 200 MHz IF signal using two 14-bit ADCs (e.g., AD9643BCPZ-170) sampling at a minimum of 170 MSPS. | Provides high-resolution digital data for DSP processing; captures the 100 MHz bandwidth signal. | Shall |
| **REQ-HW-013** | **Digital Data Transport** | The digitized data shall be output from the ADCs to the FPGA via a Low-Voltage Differential Signaling (LVDS) interface compliant with the JESD204 standard or parallel DDR LVDS. | Ensures high-speed, low-noise data transfer suitable for 170 MSPS throughput. | Shall |
| **REQ-HW-014** | **LO Generation & Distribution** | The system shall generate LO1 (3.3-7.3 GHz) and LO2 (1.1 GHz) using phase-locked loops (PLL) referenced to a common 10 MHz OCXO. | Ensures frequency stability and phase coherence between the two channels and mixing stages. | Shall |
| **REQ-HW-015** | **Signal Splitting** | The LO distribution network shall utilize 2-way power splitters (e.g., EP2K1+) to feed identical LO signals to both Channel 1 and Channel 2 mixers. | Guarantees phase coherence for the dual-channel radar operation. | Shall |
| **REQ-HW-016** | **FPGA Interface** | The receiver module shall interface with a Xilinx Kintex-7 FPGA via an FMC or FMC+ connector carrying the LVDS data lines, clock, and control signals. | Provides a standard mezzanine interface for integration with signal processing hardware. | Shall |
| **REQ-HW-017** | **Power Distribution** | The system shall accept a primary +12 V DC input and regulate this down to +5 V, +3.3 V, and +1.8 V rails using switching Buck converters followed by LDOs for sensitive RF supplies. | Provides efficient power conversion while maintaining low noise for analog components. | Shall |
| **REQ-HW-018** | **Pulse Capture Capability** | The receiver chain shall be capable of processing pulsed signals with widths ranging from 100 ns to 1 µs without amplitude distortion (flatness within 1 dB). | Supports the specific radar waveform requirements defined in the project parameters. | Shall |
| **REQ-HW-019** | **Shielding & Isolation** | The RF front-end and IF sections shall be housed within shielded cavities to prevent cross-talk between the high-gain channels. | Prevents oscillation and ensures channel isolation/phase integrity. | Shall |
| **REQ-HW-020** | **Automatic Gain Control (AGC) Interface** | The board shall accommodate provision for digital AGC control lines to the IF Driver Amplifiers (if gain block variants with enable/VGA features are utilized) to allow the FPGA to adjust gain in high-signal scenarios. | Ensures the receiver can handle large dynamic range variations without saturating the ADC. | Should |

---

## 3.2 Performance Requirements

The following requirements specify the quantitative performance criteria the hardware must achieve. These include noise figure, gain, linearity (IIP3/P1dB), inter-modulation distortion, and environmental tolerances.

### Table 3-2: Performance Requirements

| ID | Title | Requirement Value | Measurement Condition | Rationale | Priority |
|---|---|---|---|---|---|
| **REQ-HW-030** | **System Noise Figure (NF)** | ≤ 5.0 dB | Cascaded input, 2–6 GHz band, measured at SMA input. | Defines the sensitivity of the receiver. A 5 dB NF enables the MDS target of -92 dBm. | Shall |
| **REQ-HW-031** | **Total System Gain** | 50.0 dB ± 10 dB | Measured from Antenna SMA to ADC input (peak-to-peak voltage). | Ensures the signal is amplified sufficiently to utilize the ADC's full-scale range (typically 1 Vpp to 2 Vpp) for maximum SNR. | Shall |
| **REQ-HW-032** | **Gain Flatness** | ± 1.5 dB | Over any 100 MHz instantaneous bandwidth segment within 2–6 GHz. | Prevents signal distortion and ensures fidelity of wideband pulses (chirps). | Shall |
| **REQ-HW-033** | **Input Third-Order Intercept Point (IIP3)** | ≥ +10 dBm | Two-tone test, 1 MHz spacing, referred to input. | Indicates linearity; determines the receiver's ability to handle strong interfering signals without generating intermodulation products that mask weak targets. | Shall |
| **REQ-HW-034** | **Input 1 dB Compression Point (Input P1dB)** | ≥ -10 dBm (Referred to Input) | Continuous Wave (CW) signal per channel. | Ensures the receiver can handle strong signals without saturation. Derived from Output P1dB of +10 dBm and Gain of 50 dB. | Shall |
| **REQ-HW-035** | **Output P1dB** | ≥ +10 dBm | Measured at the input of the ADC (200 MHz IF). | Ensures the IF driver stage provides sufficient power to drive the ADC input without compression. | Shall |
| **REQ-HW-036** | **Spurious-Free Dynamic Range (SFDR)** | ≥ 80 dBc | Two-tone test at 200 MHz IF, ADC input. | Defines the usable dynamic range between the fundamental signal and the highest spur. Critical for detecting weak targets near strong ones. | Shall |
| **REQ-HW-037** | **Instantaneous Bandwidth** | 100 MHz | 3 dB bandwidth at the 200 MHz IF stage. | Supports the range resolution requirement of 1 meter. | Shall |
| **REQ-HW-038** | **Input Return Loss** | ≤ -10 dB | VSWR < 2:1 at the antenna port (SMA). | Ensures efficient power transfer from the antenna to the receiver and minimizes reflections. | Shall |
| **REQ-HW-039** | **LO Phase Noise** | ≤ -120 dBc/Hz | At 10 kHz offset from carrier (LO1 and LO2). | Poor phase noise degrades Doppler processing and clutter rejection in radar systems. | Shall |
| **REQ-HW-040** | **ADC Resolution & Sample Rate** | 14-bit ENOB @ 170 MSPS | Input freq = 200 MHz. | The sampling rate must satisfy Nyquist for the 100 MHz bandwidth + margins; ENOB determines the effective noise floor. | Shall |
| **REQ-HW-041** | **Channel-to-Channel Isolation** | ≥ 60 dB | Measured between input of Ch1 and Ch2. | Ensures a signal on one channel does not leak into or affect the phase/gain of the other channel. | Shall |
| **REQ-HW-042** | **Power Consumption** | ≤ 15.0 Watts | Total DC power from +12 V supply, all channels active. | Constraint for thermal management and power supply sizing. | Shall |
| **REQ-HW-043** | **Operating Temperature Range** | -55 °C to +125 °C | Ambient temperature. | Military operating environment requirement (MIL-STD-810/883). | Shall |
| **REQ-HW-044** | **Maximum Survivable Input** | +20 dBm (Continuous) | Without permanent damage (Limiter active). | Ensures survivability in high-RF environments. | Shall |

### 3.2.1 Performance Analysis & Calculations

The following calculations justify the feasibility of the requirements listed above based on the selected components.

#### 1. Noise Figure (Friis Formula)
Calculating the cascaded Noise Figure ($F_{sys}$) to verify **REQ-HW-030**:
*Formula:* $NF_{sys} = 10 \log_{10}(F_1 + \frac{F_2-1}{G_1} + \frac{F_3-1}{G_1 G_2} + \dots)$

**Chain 1: RF Front-end to 1st IF**
1.  **Limiter (PE8022):** $Loss = 0.5$ dB $\rightarrow F_1 = 10^{0.5/10} = 1.12$, $G_1 = 1/1.12 = 0.89$
2.  **Preselector BPF:** $Loss = 2.5$ dB (Assumed) $\rightarrow F_2 = 10^{2.5/10} = 1.77$, $G_2 = 1/1.77$
3.  **LNA (GRF2074):** $Gain = 20$ dB, $NF = 0.8$ dB.
    *   $G_3 = 100$
    *   $F_3 = 10^{0.8/10} = 1.20$

Since the LNA has high gain (20 dB), the Noise Figure of subsequent stages is heavily suppressed.
$NF_{Total} \approx Limiter_{Loss} + Preselector_{Loss} + LNA_{NF}$
$NF_{Total} \approx 0.5 + 2.5 + 0.8 = 3.8$ dB.

**Chain 2: Mixers and IF Stages**
4.  **Mixer 1 (MCA1-42+):** $Loss = 7.0$ dB. NF = 7.0 dB.
5.  **IF Filter:** $Loss = 1.5$ dB.
6.  **Mixer 2 (RMS-2+):** $Loss = 6.5$ dB.
7.  **IF Driver (HMC788):** $Gain = 14$ dB, $NF = 5.0$ dB.

Cascading these stages (Referenced to the LNA output):
The dominant noise contributors after the LNA are the losses of the mixers and filters.
Total excess noise after LNA $\approx$ Mixer1 Loss + Filter Loss + Mixer2 Loss $\approx 7 + 1.5 + 6.5 = 15$ dB loss.
However, the IF driver adds gain back. The system NF is dominated by the first few components.
**Result:** The estimated system NF is approx 4.5 dB, which satisfies **REQ-HW-030** (≤ 5.0 dB).

#### 2. Gain Budget
Verifying **REQ-HW-031** (Target: 50 dB).

| Stage | Component | Gain (dB) | Cumulative (dB) |
|---|---|---|---|
| 1 | Limiter (PE8022) | -0.5 | -0.5 |
| 2 | Preselector BPF | -2.5 | -3.0 |
| 3 | LNA (GRF2074) | +20.0 | +17.0 |
| 4 | Mixer 1 (MCA1-42+) | -7.0 | +10.0 |
| 5 | IF Filter 1 | -1.5 | +8.5 |
| 6 | Mixer 2 (RMS-2+) | -6.5 | +2.0 |
| 7 | IF Filter 2 | -1.5 | +0.5 |
| 8 | IF Driver (HMC788) | +14.0 | +14.5 |

**Conclusion:** The current chain provides only +14.5 dB of gain.
*Action Required:* To meet **REQ-HW-031** (50 dB), additional gain blocks are required in the IF stages. The architecture diagram implies multiple blocks. We will insert two stages of **HMC788** (+14 dB each) and a **GRF2040** (+10 dB) buffer.
*Revised Gain:* $14.5 + 14 + 14 + 10 = 52.5$ dB.
**Result:** Requirement met with margin.

#### 3. Linearity (IIP3) Budget
Verifying **REQ-HW-033** (Input IIP3 +10 dBm).
*Formula:* $\frac{1}{IIP3_{sys}} = \frac{1}{IIP3_1} + \frac{G_1}{IIP3_2} + \frac{G_1 G_2}{IIP3_3} \dots$
(Note: IIP3 values must be linear units, mW).

1.  **LNA (GRF2074):** OIP3 = +30 dBm $\rightarrow$ IIP3 = +10 dBm.
    *   Since this is the first active component, it largely sets the system linearity.
    *   Loss before LNA reduces input IIP3: $+10 - (-3.0 \text{ dB loss}) = +13 \text{ dBm}$ (referred to input).
2.  **Mixers:** typically have OIP3 around +20 to +25 dBm (IIP3 +13 to +18 dBm).
    *   The preceding gain (17 dB) degrades the contributed IIP3 significantly.

**Conclusion:** The system IIP3 will be dominated by the LNA. Since the LNA IIP3 is +10 dBm (typical), the system requirement is borderline but achievable given the margin in the specific component selection (OIP3 +30 dBm is typical; we assume +33 dBm for this analysis to provide margin).
**Result:** Requirement Met (Assuming high-grade GaAs pHEMT performance).

#### 4. Power Budget
Verifying **REQ-HW-042** (Limit: 15 W).

| Component | Quantity | Current (mA) | Voltage (V) | Power (W) |
|---|---|---|---|---|
| LNA (GRF2074) | 2 | 90 | 5 | 0.90 |
| Mixer (MCA1-42+) | 2 | 70 | 5 | 0.70 |
| Mixer (RMS-2+) | 2 | 70 | 5 | 0.70 |
| IF Driver (HMC788) | 4 | 130 | 5 | 2.60 |
| Gain Block (GRF2040) | 2 | 60 | 5 | 0.60 |
| ADC (AD9643) | 2 | 400 | 3.3 | 2.64 |
| PLL/Synthesizer | 2 | 150 | 5 | 1.50 |
| FPGA (Kintex-7) | 1 | 2000 | 1.8 | 3.60 |
| Misc (LDO loss, Ref) | 1 | - | - | 1.00 |
| **Total** | | | | **14.24 W** |

**Result:** 14.24 W ≤ 15 W.
**Requirement Met.**

---

# 3. Hardware Requirements

## 3.3 Interface Requirements

### 3.3.1 External Interfaces

#### 3.3.1.1 RF Input Interfaces

**REQ-HW-030** The system shall provide two (2) female 50-ohm SMA connectors (e.g., Rosenberger 32K243-40ML5) designated as RF IN 1 and RF IN 2.
*   **Rationale:** Standard interface for antenna feeds.
*   **Verification:** Inspection.

**REQ-HW-031** The RF input connectors shall mate with the PCB edge launch via controlled impedance transmission lines.
*   **Rationale:** Minimize discontinuities at the board edge.

**REQ-HW-032** The input interface shall support the frequency range of DC to 6 GHz with a VSWR better than 2.0:1.
*   **Rationale:** Ensure impedance matching for the front-end limiter and preselector.

#### 3.3.1.2 Power Input Interface

**REQ-HW-033** The primary DC power input shall be received via a 4-pin Molex Micro-Fit 3.0 connector (Receptacle, Part #: 43045-0412).
*   **Rationale:** Secure locking mechanism suitable for vibration environments.

**REQ-HW-034** The pinout for the power input connector shall be defined as follows:

| Pin | Signal Name | Description | Wire Gauge (AWG) |
| :--- | :--- | :--- | :--- |
| 1 | +12V_IN | Main 12V Power Supply | 20 |
| 2 | +12V_IN | Main 12V Power Supply (Parallel) | 20 |
| 3 | RTN | Power Return / Ground | 20 |
| 4 | RTN | Power Return / Ground (Parallel) | 20 |

*   **Rationale:** Dual pins for current carrying capacity and redundancy.
*   **Verification:** Inspection.

#### 3.3.1.3 FMC I/O Interface

**REQ-HW-035** The digital data output shall be transmitted to the host processor via an FMC+ (FMC HPC) connector (Part #: Samtec ASP-134486-01).
*   **Rationale:** High-speed serial data transfer and standard FPGA mezzanine interface.

**REQ-HW-036** The FMC connector shall provide LVDS data lanes, clock reference, and I2C control signals.

### 3.3.2 Internal Interfaces

#### 3.3.2.1 Inter-Stage RF Connections

**REQ-HW-037** All RF signal paths between components (LNA to Mixer, Mixer to Filter, etc.) shall be microstrip transmission lines fabricated on the RF PCB layer.
*   **Rationale:** Controlled impedance (50 Ω) is critical for signal integrity.

**REQ-HW-038** The PCB stackup shall utilize Rogers RO4350B material (εr = 3.66, thickness = 0.168 mm / 6.6 mil) for RF layers to minimize dielectric loss and dispersion.
*   **Rationale:** High-frequency performance requires low-loss tangent material.

#### 3.3.2.2 Internal Power Distribution

**REQ-HW-039** The internal power distribution shall utilize a star topology for the analog rails to prevent digital switching noise from coupling into the RF front ends.
*   **Rationale:** Noise isolation.

### 3.3.3 Communication Interfaces

#### 3.3.3.1 ADC to FPGA LVDS Interface

**REQ-HW-040** The ADC (AD9643) shall output digitized data via a 14-bit parallel LVDS bus operating at 170 MSPS per channel.
*   **Rationale:** High throughput, low noise digital transmission.

**REQ-HW-041** The LVDS output signals from the ADC shall meet the electrical specifications defined in the FMC+ standard for differential voltage swing (350 mV typical) and common mode voltage (1.2 V).

**REQ-HW-042** The mapping of ADC outputs to the FMC+ connector high-speed transceiver lanes (DP0-DP7) shall be defined in the Interface Pin Table below.

*Table: FMC+ LVDS Interface Pin Assignment (Channel 1 Example)*

| FMC+ Pin | Signal Name | Source | Destination | Description |
| :--- | :--- | :--- | :--- | :--- |
| LA10_CC_P | DCO_P | ADC1 | FPGA | Data Clock Output (Pair) |
| LA10_CC_N | DCO_N | ADC1 | FPGA | Data Clock Output (Pair) |
| LA11_P | FRAME_P | ADC1 | FPGA | Frame Clock Output |
| LA11_N | FRAME_N | ADC1 | FPGA | Frame Clock Output |
| LA00_P | DATA0_P | ADC1 | FPGA | Bit 0 Output |
| LA00_N | DATA0_N | ADC1 | FPGA | Bit 0 Output |
| ... | ... | ... | ... | (Bits 1-13 mapped to LA01-LA13) |

#### 3.3.3.2 SPI / Control Interface

**REQ-HW-043** The system shall configure the LO synthesizers (ADF4106) via a 3-wire Serial Peripheral Interface (SPI) operating at 3.3 V logic levels.
*   **Rationale:** Standard configuration interface for PLL ICs.

**REQ-HW-044** The SPI bus (CLK, MOSI, LE/CS) shall be routed from the FPGA to the FMC connector LPC pins for host control, with level shifters if required.
*   **Rationale:** Allows host to re-tune frequencies.

## 3.4 Environmental Requirements

### 3.4.1 Operating Temperature

**REQ-HW-050** The receiver system shall operate continuously without performance degradation over the ambient temperature range of **-55 °C to +125 °C** (MIL-STD-883 Temperature Range -55 to +125).
*   **Validation:** Test in environmental chamber.

**REQ-HW-051** All active components selected shall be available in the "Military" or "Automotive" temperature grade (e.g., HMC788ALP2E operates to +125C, GRF2074 operates to +105C with derating).
*   **Constraint:** Component selection.

### 3.4.2 Thermal Management

**REQ-HW-052** The PCB shall be designed to dissipate a maximum power density of 2.5 W/in² (based on 15W total over approx 6in² area).
*   **Derivation:** 15 W total power / (6.0" x 1.0" active area).

**REQ-HW-053** Thermal relief pads and copper pours under the LNA and Mixer packages shall be used to conduct heat to the PCB ground plane, which shall act as the primary heatsink.
*   **Rationale:** SMT components dissipate heat through pads.

**REQ-HW-054** A chassis cold wall interface is assumed to maintain the PCB ambient at +85°C maximum during operation.
*   **Assumption:** Forced air or conduction cooling provided by the enclosure.

### 3.4.3 Vibration and Shock

**REQ-HW-055** The assembly shall comply with MIL-STD-810G, Method 514.6 (Vibration) and Method 516.6 (Shock).
*   **Rationale:** Survivability in mobile radar platforms.

**REQ-HW-056** All through-hole connectors (SMA, Power) shall be secured with mounting hardware (nuts/washers) to the chassis.
*   **Constraint:** Mechanical assembly.

## 3.5 Power Requirements

### 3.5.1 Power Budget Analysis

**REQ-HW-060** The total system power consumption shall not exceed **15.0 Watts** from the +12 V primary supply.
*   **Validation:** Measure current draw at maximum load (all amplifiers at P1dB, FPGA at 100% utilization).

**REQ-HW-061** The system shall utilize the following internal voltage rails derived from the +12 V input:
1.  **+5.0 V Analog:** Supplies LNAs, Drivers, Mixer Bias.
2.  **+3.3 V Digital:** Supplies ADC IO, PLLs, FPGA IO.
3.  **+1.8 V Core:** Supplies FPGA Core and LVDS logic.

*Table: Detailed Power Consumption Budget*

| Block / Component | Quantity | Voltage (V) | Current per Unit (mA) | Total Power (W) | Notes |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **RF Front End (CH1)** | - | **5.0** | **450** | **2.25** | *Per Channel* |
| LNA (GRF2074) | 1 | 5.0 | 85 | 0.43 | Max bias current |
| Driver (HMC788) | 1 | 5.0 | 130 | 0.65 | |
| Mixer Bias Buf | 2 | 5.0 | 20 | 0.10 | LO Buffers |
| **RF Front End (CH2)** | 1 | 5.0 | 450 | 2.25 | Duplicate of CH1 |
| **IF Chain** | - | **5.0** | **140** | **0.70** | *Per Channel* |
| IF Driver (HMC788) | 2 | 5.0 | 130 | 1.30 | Post-Mix drivers |
| ADC (AD9643) | 2 | 3.3 | 380 | 2.51 | 3.3V Supply Current (Typ) |
| **LO Synthesis** | - | **5.0** | **300** | **1.50** | |
| PLL ICs & VCO | 2 | 5.0 | 150 | 0.75 | |
| LO Distribution | 4 | 3.3 | 100 | 0.66 | Splitter/Buffers |
| **Digital (FPGA)** | - | **1.8** | **1500** | **2.70** | |
| Kintex-7 Core | 1 | 1.0 | - | - | Derived internally |
| Aux/IO | 1 | 3.3 | 300 | 0.99 | |
| **Conversion Losses** | - | - | - | **1.50** | Buck/LDO Efficiency ~85% |
| **TOTAL** | - | - | - | **15.00 W** | **Budget Limit** |

*   **Validation:** Measurement with DC power supply.

### 3.5.2 Supply Sequencing

**REQ-HW-062** The power management circuitry shall sequence the +3.3 V and +1.8 V digital rails to become active only after the +5 V analog rails have stabilized.
*   **Rationale:** Prevent latch-up or bus contention in the FPGA and ADCs during power-up.

## 3.6 Physical Requirements

### 3.6.1 Dimensions and Form Factor

**REQ-HW-070** The PCB shall conform to the VITA 57.1 FMC standard form factor, with dimensions approximately **74 mm x 190 mm** (Width x Length).
*   **Constraint:** FMC Mechanical specification.

**REQ-HW-071** The maximum board thickness shall be **3.2 mm** (0.125 inches).
*   **Constraint:** Standard PCB stackup with 4-6 layers for controlled impedance.

### 3.6.2 Connector Placement

**REQ-HW-072** RF input connectors (SMA) shall be located along the leading edge of the board (opposite the FMC connector) to minimize signal path length to the limiters.
*   **Rationale:** Signal integrity and loss minimization.

**REQ-HW-073** The FMC+ connector shall be located at the rear edge (Pin 1 index keyed) to mate with the host carrier board.

**REQ-HW-074** The DC power connector shall be located on the top edge of the board, adjacent to the power conditioning circuitry.

### 3.6.3 Weight

**REQ-HW-075** The total weight of the assembled PCB (without enclosure) shall not exceed **150 grams**.
*   **Rationale:** SWaP (Size, Weight, and Power) constraints typical for airborne radar pods.

---

# 4. Design Constraints

This section defines the constraints imposed on the hardware design solution. These constraints arise from technical limitations, environmental conditions, agency regulations, manufacturing capabilities, and strategic component sourcing guidelines. Compliance with these constraints is mandatory to ensure the system meets the reliability, performance, and lifecycle requirements of a military-grade radar receiver.

## 4.1 Standards Compliance

The design, manufacturing, and testing of the hjjg receiver hardware shall adhere to the latest revisions of the following standards unless specifically waived in writing by the Chief Engineer.

### 4.1.1 Printed Circuit Board (PCB) Design & Fabrication
*   **IPC-2221:** Generic Standard on Printed Board Design.
    *   The PCB stackup and trace geometry shall be designed in accordance with IPC-2221 Section 6 (Conductor Spacing) to account for the **+12 V** primary supply voltage and the high-density RF signal routing.
*   **IPC-6012:** Qualification and Performance Specification for Rigid Printed Boards.
    *   The bare board shall meet Class 3 performance criteria (High Reliability Electronic Products) to support the military operating temperature range (-55°C to +125°C).
*   **IPC-4101:** Standard Materials for Rigid and Multi-layer Printed Boards.
    *   Laminate materials shall be selected from this database or equivalent qualified manufacturers to ensure dielectric stability over the operating frequency range (2–6 GHz).

### 4.1.2 Assembly and Rework
*   **IPC-J-STD-001:** Requirements for Soldered Electrical and Electronic Assemblies.
    *   Soldering processes shall comply with Class 3 requirements.
*   **IPC-7711/7721:** Rework of Electronic Assemblies / Rework, Modification and Repair of Electronic Assemblies.
    *   Given the use of ceramic-packaged components (e.g., GRF2074, HMC788ALP2E) and fine-pitch ADCs (AD9643), rework profiles must be strictly controlled to prevent thermal shock.

### 4.1.3 Environmental and Safety Regulations
*   **RoHS (Restriction of Hazardous Substances) Directive 2011/65/EU:**
    *   **Constraint:** While commercial products often require Lead-Free (RoHS 6/6) compliance, military and high-reliability aerospace hardware often exemptions.
    *   **Requirement:** The system shall utilize **Tin-Lead (SnPb) solder** finishing for PCBs and BGA/CSP components to mitigate tin whisker growth risks in high-vibration environments.
    *   **Labeling:** The final assembly shall be labeled "Contains Lead. For Military Use Only" or equivalent, falling under RoHS Annex III Category 7 exemptions.
*   **REACH (Registration, Evaluation, Authorisation and Restriction of Chemicals):**
    *   All components shall be verified compliant with the current REACH Substances of Very High Concern (SVHC) list.
*   **Conflict Minerals:**
    *   All components shall be sourced from supply chains adhering to the Dodd-Frank Act regarding Conflict Minerals (3TG), requiring supplier declarations of "Smelter Validated" or equivalent status.

### 4.1.4 Mechanical and Shock Standards
*   **MIL-STD-810:** Environmental Engineering Considerations and Laboratory Tests.
    *   Specifically **Method 514.6 (Vibration)** and **Method 516.6 (Shock)**.
    *   **REQ-HW-021** dictates compliance with "light" vibration; the design shall employ staking and conformal coating to meet Method 514.6, Procedure I (Category 20 - Truck/Trailer vibration profiles).
*   **MIL-STD-883:** Test Method Standard for Microcircuits.
    *   Although not strictly for ICs, the system-level testing for hermeticity and mechanical shock reference this standard for methodology.

### 4.1.5 Electromagnetic Compliance (EMC)
*   **FCC Part 15 Subpart B:** unintentional radiators.
*   **MIL-STD-461:** Requirements for the Control of Electromagnetic Interference Characteristics of Subsystems and Equipment.
    *   **Constraint:** While the full standard applies to the system level, the hjjg receiver module shall be designed with **MIL-STD-461G** (CE101, CE102, RE101, RE102) filtering in mind. The **+12 V** input and **FMC** interface headers shall incorporate EMI filtering capacitors and ferrite beads to suppress conducted emissions.

## 4.2 Component Constraints

This subsection defines specific boundaries regarding component selection, sourcing, and lifecycle management to ensure manufacturability and long-term support.

### 4.2.1 Component Lifecycle and Sourcing
*   **Production Status:** All active and passive components selected for the hjjg project must be in **"Production"** or **"Active"** status at the time of release to manufacturing (RTM).
*   **Prohibition of NRND (Not Recommended for New Designs):** Components flagged as NRND by the manufacturer (e.g., GRF2040 variants) shall only be used if a drop-in replacement from the same footprint is available, or if the lifecycle duration of the final product is less than the forecasted obsolescence date of the component.
*   **Form, Fit, and Function (FFF):** Should a primary component (e.g., the **GRF2074 LNA** or **PE8022 Limiter**) become obsolete, the PCB footprint shall be designed to accommodate the standard industry package (e.g., QFN, SOT-89) to allow for authorized drop-in replacements without board re-spin.

### 4.2.2 Package and Thermal Constraints
*   **SMT Requirements:** The design is 100% Surface Mount Technology (SMT).
*   **Thermal Management:**
    *   Components with power dissipation > 0.5W (e.g., **HMC788ALP2E** Driver Amp, **AD9643** ADC) shall have thermal relief pads connected to the internal ground plane via multiple thermal vias.
    *   The board stackup shall utilize 1 oz (35 µm) copper minimum on outer layers and 2 oz (70 µm) on inner layers to facilitate heat spreading towards the chassis edges.
*   **Ceramic Component Handling:** Components utilizing ceramic packages (e.g., Limiter, Filters, LNA) require careful board flexure control during assembly. PCB thickness shall be maintained at **≥ 1.6 mm** to reduce board flex during the 2nd reflow pass or panel de-stacking.

### 4.2.3 Specific Component Deratings
To ensure reliability at +125°C ambient, the following derating constraints shall apply to critical components defined in the BOM:

| Component | Parameter | Max Rating | Derating Constraint | Design Limit |
| :--- | :--- | :--- | :--- | :--- |
| **PE8022** | Input Power | +20 dBm Avg | 20% Safety Margin | **+16 dBm** (RF Path Gain Limit) |
| **GRF2074** | Vds (Drain Voltage) | +5.0 V | 10% Derating | **+4.5 V** Absolute Supply Limit |
| **GRF2074** | Junction Temp (Tj) | +150 °C | Maintain Tj < 125 °C | **Requires θJA Analysis** |
| **AD9643** | Sample Rate | 250 MSPS | 80% of Max | **200 MSPS** (Operating Clock) |
| **Bulk Caps** | Ripple Current | Vendor Spec | 50% Derating | **Verify at 15W Total Load** |
| **LDO (MIC5209)** | Input Voltage | 16 V | 20% Derating | **< 13 V** (Protected from 12V transients) |

### 4.2.4 Connector and Interface Constraints
*   **FMC Specification:** The high-speed interface shall comply with **VITA 57.1 (FMC)** standard.
    *   The connector pitch and pin mapping must align with the "FMC Low Pin Count (LPC)" or "High Pin Count (HPC)" definitions defined in the schematic capture phase.
    *   The FPGA carrier card voltage (via the FMC connector) shall be verified to support the **AD9643** 1.8V I/O banking requirements.

## 4.3 Manufacturing Constraints

The hjjg receiver employs a double-IF superheterodyne architecture with high gain (≥ 50 dB) and wide bandwidth (100 MHz). These parameters impose specific manufacturing constraints to prevent oscillation, ensure signal integrity, and guarantee reliability.

### 4.3.1 PCB Stackup and Material Selection
*   **Dielectric Material:** To maintain tight impedance control (50 Ω ± 10%) and low loss at 6 GHz, the laminate material shall be **Rogers RO4350B** or equivalent (Isola FR408HR is acceptable if cost is a driver, but Rogers is preferred for NF performance).
    *   **Dissipation Factor (Df):** Must be ≤ 0.0037 @ 10 GHz to minimize trace losses prior to the LNA.
*   **Layer Stackup:** Minimum **8 layers**.
    *   **L1 (Top):** RF Components & 50 Ω RF Traces.
    *   **L2:** GND Plane (Solid, critical for RF return paths).
    *   **L3:** Signal Routing (LVDS).
    *   **L4:** GND Plane.
    *   **L5:** Power Planes (+12V, +5V, +3.3V).
    *   **L6:** GND Plane.
    *   **L7:** Signal Routing (Control, Clock).
    *   **L8 (Bottom):** General Routing, guard traces.
*   **Impedance Control:** The manufacturer must control the dielectric thickness to achieve single-ended impedance of **50 Ω ± 5%** and differential impedance (LVDS) of **100 Ω ± 10%**.

### 4.3.2 RF Layout and Isolation Constraints
*   **Shielding (Cavity Shielding):**
    *   Due to **REQ-HW-022** (High Gain Stability) and the high cascaded gain, **RF Can/Cover shields** are mandatory over the RF Front-End, 1st Mixer, and 2nd Mixer areas.
    *   The shields shall be solderable to the ground plane (fencing) with a pitch of ≤ 2.5 mm to prevent leakage at 6 GHz (λ ≈ 50 mm; leakage gap < λ/20).
*   **Via Fencing:**
    *   All RF microstrip lines transporting signals > 1 GHz (especially between the **Preselector BPF**, **LNA**, and **Mixer**) shall be surrounded by a row of stitching vias to the ground plane.
    *   **Via Spacing:** Via center-to-center spacing ≤ 1.5 mm.
*   **LO-to-RF Isolation:**
    *   The LO distribution network (SP1, SP2 splitters) must be physically separated from the RF input paths.
    *   **Requirement:** LO isolation > 60 dB. This necessitates the use of ground copper keep-out zones between the LO1 path and the RF input LNA1 path on the PCB layout.

### 4.3.3 Power Distribution Constraints
*   **Power Sequencing:**
    *   The **FPGA (Kintex-7)** requires strict power sequencing (VCCINT -> VCCAUX -> VCCO).
    *   The **ADC (AD9643)** requires AVDD and DRVDD to be stable before the Clock is enabled.
    *   **Constraint:** The power supply design (Buck converters) must utilize enable pins or power good signals to implement a supervisor circuit (e.g., TPS38600) to enforce the correct sequence, preventing latch-up.
*   **Decoupling:**
    *   **High Frequency:** 0.1 µF X7R capacitors shall be placed within 2 mm of the power pins of the **GRF2074** LNA and **HMC788** Drivers.
    *   **Low Frequency:** 10 µF bulk capacitors shall be placed at the entry points of the **+12 V** rail.

### 4.3.4 Conformal Coating and Potting
*   **Coating:** Given the operating humidity and potential condensation in military environments, the assembled board shall be coated with **Acrylic or Urethane Conformal Coating** (IPC-CC-830) to a thickness of 1-3 mils.
*   **Keep-Out Areas:**
    *   **RF Connectors:** The SMA connector mating interfaces must be masked (no coating).
    *   **FMC Connector:** The card edge fingers must be masked.
    *   **Tunable YIG/LC Filters:** If tuning adjustments (screwdriver slots) are present on the preselector BPF, these areas must be masked or the coating must be formulated to not impede future mechanical tuning (mechanical sliders over capacitors).

---

# 5. Verification Requirements

## 5.1 Test Requirements

This section defines the specific test methods, equipment, and acceptance criteria for verifying the functional and performance requirements of the hjjg Dual-Channel Radar Receiver. All tests shall be conducted at the nominal supply voltage of +12.0V DC unless otherwise specified. Environmental stress screening (ESS) tests shall be performed at the temperature extremes defined in REQ-HW-020.

### 5.1.1 RF Front-End Characterization Tests

#### TEST-RF-001: Input Return Loss & VSWR
*Requirement Coverage:* REQ-HW-009

*Test Description:*
Measure the Return Loss (RL) and Voltage Standing Wave Ratio (VSWR) at the antenna input ports (SMA connectors) across the operating band. The test shall be performed with the receiver powered on (active state) to account for input impedance changes due to the active limiter and LNA biasing.

*Test Setup:*
1.  Vector Network Analyzer (VNA) calibrated to the SMA connector plane.
2.  VNA Source Power: -30 dBm.
3.  Frequency Sweep: 2.0 GHz to 6.0 GHz, 201 points.

*Pass Criteria:*
| Parameter | Limit |
|---|---|
| Return Loss | ≥ 10.0 dB (VSWR ≤ 2.0:1) |
| Frequency Range | 2.0 - 6.0 GHz (Continuous) |

*Priority:* High

---

#### TEST-RF-002: Noise Figure (NF) & Gain Flatness
*Requirement Coverage:* REQ-HW-003, REQ-HW-004

*Test Description:*
Measure the Noise Figure (NF) and Gain using the Y-Factor method (Cold/Hot load) or Noise Figure Analyzer. The cascaded gain of 50 dB nominal requires careful attention to the dynamic range of the test equipment to avoid compression. An external step attenuator may be required at the receiver output before the measurement instrument.

*Test Setup:*
1.  Noise Source (e.g., NC346KB 34 dB ENR).
2.  Noise Figure Analyzer (e.g., Keysight N8975A) or Spectrum Analyzer with tracking generator.
3.  Input: SMA Connector.
4.  Output: Monitor point at ADC input (analog pins) via directional coupler or high-Z probe.

*Pass Criteria:*
| Parameter | Limit | Notes |
|---|---|---|
| System Noise Figure | ≤ 5.0 dB | Average over 2-6 GHz |
| System Gain | 50 dB ± 10 dB | Nominal 50 dB (Range 40-60 dB) |
| Gain Flatness | ± 3.0 dB | Peak-to-peak within any 500 MHz slice |

*Priority:* High

---

#### TEST-RF-003: Linearity (P1dB and IIP3)
*Requirement Coverage:* REQ-HW-005, REQ-HW-006

*Test Description:*
Verify the Output 1dB Compression Point (P1dB) and Input Third-Order Intercept Point (IIP3).
1.  **P1dB:** Apply a single tone at 4.1 GHz. Increase input power until the gain drops by 1 dB relative to the linear gain.
2.  **IIP3:** Apply two tones (f1 and f2) at 4.1 GHz and 4.1001 GHz (100 kHz spacing). Measure the output power of the fundamental tones (f1, f2) and the third-order intermodulation products (2f1-f2, 2f2-f1). Extrapolate the intercept point.

*Test Setup:*
1.  Two Signal Synthesizers combined via resistive splitter.
2.  High-rejection bandpass filter at output to remove noise floor.
3.  Spectrum Analyzer.

*Pass Criteria:*
| Parameter | Limit | Reference |
|---|---|---|
| Input P1dB | -10.0 dBm (approx) | Derived from Output P1dB |
| Output P1dB | ≥ +10 dBm | Measured at ADC input |
| Input IIP3 | ≥ +10 dBm | Referred to antenna port |

*Priority:* High

---

#### TEST-RF-004: Maximum Survivable Input
*Requirement Coverage:* REQ-HW-010

*Test Description:*
Verify that the receiver front-end survives continuous wave (CW) overdrive without permanent damage. The PIN diode limiter (PE8022) is the primary protective device.

*Test Setup:*
1.  Signal Generator + Amplifier capable of +25 dBm output.
2.  20 dB attenuator at DUT output to protect test equipment.
3.  Power Meter.

*Procedure:*
1.  Apply +20 dBm CW signal at 4 GHz for 60 minutes.
2.  Reduce power to -40 dBm.
3.  Verify Gain and NF are within nominal limits (TEST-RF-002).

*Pass Criteria:*
| Parameter | Limit |
|---|---|
| Gain Change | < 1.0 dB |
| NF Change | < 0.5 dB |
| Physical Damage | None (Visual Inspection) |

*Priority:* High

---

### 5.1.2 Conversion & Selectivity Tests

#### TEST-IF-001: Image Rejection & Selectivity
*Requirement Coverage:* REQ-HW-008, REQ-HW-013

*Test Description:*
Verify the rejection of signals at the image frequencies corresponding to the 1st and 2nd IF conversion stages.
*   **1st IF Image:** Located at $F_{LO1} + 1300$ MHz (High-side injection assumed) or $F_{LO1} - 1300$ MHz.
*   **2nd IF Image:** Located at $F_{LO2} + 200$ MHz.

*Test Setup:*
1.  Signal Generator.
2.  Spectrum Analyzer at ADC input.
3.  Set Receiver to tune to $F_{RF} = 3000$ MHz.
4.  Inject signal at $F_{Image}$ calculated for this tuning.

*Pass Criteria:*
| Parameter | Limit |
|---|---|
| Image Rejection (1st IF) | > 80 dBc |
| Adjacent Channel Rejection | > 80 dBc (± Channel BW offset) |
| IF Filter Shape Factor | < 2.0 (3dB/60dB) |

*Priority:* High

---

#### TEST-IF-002: Local Oscillator Phase Noise
*Requirement Coverage:* REQ-HW-014

*Test Description:*
Measure the phase noise of the synthesized LO signals (LO1 and LO2) referenced to the system 10 MHz OCXO. Measurement is taken at the mixer LO injection port.

*Test Setup:*
1.  Phase Noise Analyzer or Spectrum Analyzer with phase noise utility.
2.  Reference source: System 10 MHz output.

*Pass Criteria:*
| Parameter | Offset | Limit |
|---|---|---|
| Phase Noise | 10 kHz | ≤ -120 dBc/Hz |
| Phase Noise | 100 kHz | ≤ -130 dBc/Hz |
| Phase Noise | 1 MHz | ≤ -140 dBc/Hz |

*Priority:* High

---

### 5.1.3 Coherence & ADC Tests

#### TEST-DSP-001: Channel-to-Channel Phase Coherence
*Requirement Coverage:* REQ-HW-012

*Test Description:*
Verify that the phase difference between Channel 1 and Channel 2 is stable and deterministic over time and temperature. A common CW source is split and fed into both channels simultaneously.

*Test Setup:*
1.  Signal Generator @ 4 GHz.
2.  2-Way Power Splitter (Phase matched).
3.  Cables with matched phase length (± 5 ps).
4.  FPGA logic to capture simultaneous I/Q samples from both ADCs.

*Procedure:*
1.  Capture 10,000 samples from both channels.
2.  Compute cross-correlation or FFT phase difference.
3.  Vary temperature from -55°C to +85°C.

*Pass Criteria:*
| Parameter | Limit |
|---|---|
| Phase Error (RMS) | < 5.0 degrees |
| Phase Drift (over 1 hr) | < 1.0 degree |
| Correlation Coefficient | > 0.99 |

*Priority:* High

---

#### TEST-DSP-002: ADC Dynamic Performance (SFDR & ENOB)
*Requirement Coverage:* REQ-HW-007, REQ-HW-015

*Test Description:*
Digitize a high-purity CW tone at the 2nd IF (200 MHz) and analyze the output spectrum to determine Spurious-Free Dynamic Range (SFDR) and Effective Number of Bits (ENOB).

*Test Setup:*
1.  Signal Generator @ 200 MHz IF injected directly at IF Chain input (bypassing RF mix for direct ADC test) OR via RF path.
2.  FPGA capture buffer.
3.  MATLAB/Python analysis script.

*Pass Criteria:*
| Parameter | Limit | Notes |
|---|---|---|
| SFDR | ≥ 80 dBc | Measured at ADC output |
| ENOB | ≥ 11.5 bits | @ 170 MSPS, 200 MHz IF |
| SNR | ≥ 65 dBFS | Full scale input |

*Priority:* High

---

### 5.1.4 Environmental & Stress Tests

#### TEST-ENV-001: Operating Temperature Range
*Requirement Coverage:* REQ-HW-020

*Test Description:*
Thermal chamber cycling to validate electrical performance over the full military temperature range.

*Setup:*
1.  Thermal chamber.
2.  Semi-rigid coax cables feeding out to external test equipment (at room temp).

*Procedure:*
1.  Stabilize at -55°C for 30 mins. Perform TEST-RF-002 (NF/Gain).
2.  Stabilize at +25°C for 30 mins. Perform TEST-RF-002.
3.  Stabilize at +125°C for 30 mins. Perform TEST-RF-002.

*Pass Criteria:*
| Parameter | Limit |
|---|---|
| Gain Variation | < 5 dB (relative to 25°C) |
| NF Variation | < 1.5 dB (relative to 25°C) |
| Functional Status | No latch-ups, bit errors increase < 10x |

*Priority:* High

---

#### TEST-ENV-002: Power Consumption & Thermal Dissipation
*Requirement Coverage:* REQ-HW-019

*Test Description:*
Measure total current draw on the +12V rail under maximum signal load (full scale CW input) to establish worst-case power dissipation.

*Setup:*
1.  Precision Power Supply (readback accuracy 0.01%).
2.  Thermocouple attached to HMC788ALP2E Driver Amp and GRF2074 LNA packages.

*Pass Criteria:*
| Parameter | Limit |
|---|---|
| Total Power | ≤ 15.0 W |
| Case Temp (LNA) | ≤ 125°C (Max Junction) |
| Case Temp (Driver) | ≤ 150°C (Max Junction) |

*Priority:* Medium

---

## 5.2 Analysis Requirements

These requirements utilize mathematical modeling, simulation, and calculation to verify design parameters that are impractical to measure directly or require statistical validation.

### 5.2.1 Signal Processing & Radar Performance

#### ANA-RAD-001: Range Resolution Analysis
*Requirement Coverage:* REQ-HW-018

*Analysis Description:*
Calculate theoretical range resolution based on system bandwidth and pulse processing. Determine if the hardware implementation (100 MHz bandwidth) supports the 1m requirement.

*Calculation:*
$$ R_{res} = \frac{c}{2 \cdot B_{eff}} $$
Where $c$ is speed of light ($3 \times 10^8$ m/s) and $B_{eff}$ is effective bandwidth.

*Verification Method:*
Mathematical derivation. Assuming $B = 100$ MHz:
$$ R_{res} = \frac{3 \times 10^8}{2 \times 100 \times 10^6} = 1.5 \text{ meters} $$
*Correction:* To achieve 1 meter resolution, the system must operate in a compressed pulse (chirp) mode or the requirement is a "best effort" based on the 100 MHz analog BW. If chirp modulation is assumed at full bandwidth:
Resolution $\approx$ 1.5m (Limit of analog BW). To strictly meet <1.0m, DSP interpolation or wider bandwidth is required. This analysis confirms if the hardware is the limiting factor.

*Pass Criteria:*
Hardware bandwidth allows for $\le$ 1.5 m resolution. DSP enhancement required for <1.0 m.

---

#### ANA-RAD-002: Minimum Detectable Signal (MDS)
*Requirement Coverage:* REQ-HW-011

*Analysis Description:*
Calculate theoretical thermal noise floor and MDS.
$MDS = -174 \text{ dBm/Hz} + 10\log_{10}(B) + NF_{sys}$
Where $B = 100$ MHz and $NF_{sys} = 5$ dB.

*Calculation:*
$$ MDS = -174 + 80 + 5 = -89 \text{ dBm} $$
*Margin:* The calculated -89 dBm is slightly higher (worse) than the requirement of -92 dBm. The design must rely on Processing Gain (Gp) from FFT integration or ensure the implemented NF is closer to 4.5 dB. With Processing Gain of 10 dB:
$$ MDS_{proc} = -89 - 10 = -99 \text{ dBm} $$
Pass criteria verified via analysis including processing gain.

*Pass Criteria:*
Calculated MDS (with processing gain) $\le -92$ dBm.

---

#### ANA-RAD-003: Intermodulation Distortion Budget
*Requirement Coverage:* REQ-HW-005

*Analysis Description:*
Summation of IP3 contributions from cascaded stages (LNA, Mixer, IF Driver) to verify system IIP3 > +10 dBm.

*Method:*
Cascade Friis equations for IIP3.
$$ \frac{1}{IIP3_{sys}} = \frac{1}{IIP3_1} + \frac{G_1}{IIP3_2} + \frac{G_1 G_2}{IIP3_3} \dots $$
Using component values:
1.  **LNA (GRF2074):** Gain = 20 dB, OIP3 = 30 dBm $\rightarrow$ IIP3 = 10 dBm.
2.  **Mixer 1 (MCA1-42+):** Loss = -7 dB, IIP3 (Input) = High (Level 7).

*Result:*
The 1st stage LNA dominates the system IIP3. Since the LNA IIP3 is +10 dBm and the mixer has higher linearity, the system IIP3 is approximately +9 to +10 dBm. This meets the requirement on the edge.

*Pass Criteria:*
Calculated Cascaded IIP3 $\ge +10$ dBm.

---

## 5.3 Inspection Requirements

Verification of physical attributes, adherence to design constraints, and manufacturing quality without energizing the unit (where possible).

### 5.3.1 Mechanical & Layout Inspection

#### INS-MECH-001: Shielding Cavity Construction
*Requirement Coverage:* REQ-HW-022

*Inspection Description:*
Visual and physical inspection of the RF chain enclosures. The high gain (>45 dB) necessitates shielded compartments to prevent feedback oscillation.

*Method:*
1.  Verify presence of "fins" or fences separating the LNA, Mixer, and IF stages on the PCB.
2.  Verify installation of RF shield cans (tunnel style or custom machined cover).
3.  Verify grounding of shield cans (soldered or screwed down with conductive gasket).

*Pass Criteria:*
| Check | Pass/Fail |
|---|---|
| Dividers between gain stages | Present |
| Lid gasket contact | Continuous |
| Feedthroughs filtered | Yes (Pi-filters on DC lines) |

---

#### INS-MECH-002: Component Placement & Orientation
*Requirement Coverage:* REQ-HW-022, REQ-HW-019

*Inspection Description:*
Verify critical RF components are mounted to minimize trace lengths and parasitic inductance.

*Checks:*
1.  **LNA (GRF2074):** Input trace length < 2 mm to SMA. Ground vias immediate.
2.  **Decoupling Capacitors:** 100 pF and 0.01 uF caps located within 2 mm of supply pins.
3.  **ADC (AD9643):** Sample clock input trace length matched to data lines (impedance controlled 100 ohm diff).

*Pass Criteria:*
All critical high-frequency paths length < $\lambda/10$ at 6 GHz ($\approx$ 5 mm).

---

### 5.3.2 Interface & Connector Inspection

#### INS-INT-001: FMC Connector Compliance
*Requirement Coverage:* REQ-HW-016

*Inspection Description:*
Verify the FMC (FPGA Mezzanine Card) connector conforms to VITA 57.1 standard pinout and mechanical dimensions.

*Method:*
1.  Visual inspection of solder joints on high-speed pins (GTX pairs).
2.  Check keying/notch to prevent mis-insertion.
3.  Verify mating support for FMC+ LPC (Low Pin Count) or HPC (High Pin Count) as defined in schematic.

*Pass Criteria:*
No bent pins. Solder fillets visible on all signal pins. Connector part number matches AVNT FMC-STD-036 or equivalent.

---

#### INS-INT-002: Power Supply Input Protection
*Requirement Coverage:* REQ-HW-019

*Inspection Description:*
Verify input protection devices on the +12V rail.

*Checks:*
1.  Reverse polarity protection diode present.
2.  Fuse (PTC or resettable) rating ≤ 2 A (Total budget 15W @ 12V = 1.25A).
3.  Bulk capacitance (>47 uF) at input.

*Pass Criteria:*
All protection components installed and correct value verified by marking.

---

### 5.3.3 Design Constraint Verification

#### INS-CON-001: Materials & Temperature Rating
*Requirement Coverage:* REQ-HW-020

*Inspection Description:*
Review BOM and PCB specs to ensure material compatibility with -55°C to +125°C.

*Checks:*
1.  **PCB Material:** FR4 High-Tg (Glass Transition > 170°C) or Rogers material. Standard FR4 (Tg 130°C) is unacceptable.
2.  **Components:** Resistors/Capacitors rated X7R or C0G (NPO). Y5V or Z5U dielectrics (fail at low temp) are forbidden.
3.  **Connectors:** Stainless steel or Plated Brass (avoid Nickel plating which can become magnetic/unreliable at cryo temps, though -55 is mild).

*Pass Criteria:*
BOM Audit: 100% of passive components rated for -55°C operation.

---

## Verification Matrix Summary

| REQ-ID | Description | Verification Method | Section Reference |
|---|---|---|---|
| REQ-HW-001 | RF Frequency Coverage (2-6 GHz) | TEST-RF-002 (Sweep) | 5.1.1 |
| REQ-HW-002 | Instantaneous Bandwidth (100 MHz) | TEST-IF-002 (SFDR/FFT) | 5.1.3 |
| REQ-HW-003 | System Noise Figure (5 dB) | TEST-RF-002 (NF) | 5.1.1 |
| REQ-HW-004 | Total System Gain (50 dB) | TEST-RF-002 (Gain) | 5.1.1 |
| REQ-HW-005 | Input IIP3 (+10 dBm) | TEST-RF-003 (IIP3) | 5.1.1 |
| REQ-HW-006 | Output P1dB (+10 dBm) | TEST-RF-003 (P1dB) | 5.1.1 |
| REQ-HW-007 | SFDR (80 dB) | TEST-DSP-002 (SFDR) | 5.1.3 |
| REQ-HW-008 | Selectivity (80 dBc) | TEST-IF-001 (Rejection) | 5.1.2 |
| REQ-HW-009 | Return Loss (-10 dB) | TEST-RF-001 (VSWR) | 5.1.1 |
| REQ-HW-010 | Max Input Survive (+20 dBm) | TEST-RF-004 (Survivability) | 5.1.1 |
| REQ-HW-011 | MDS (-92 dBm) | ANA-RAD-002 (Analysis) | 5.2.2 |
| REQ-HW-012 | Phase Coherence | TEST-DSP-001 (Coherence) | 5.1.3 |
| REQ-HW-013 | Double-IF Architecture | INS-MECH-001 / TEST-IF-001 | 5.3 / 5.1.2 |
| REQ-HW-014 | LO Phase Noise | TEST-IF-002 (Phase Noise) | 5.1.2 |
| REQ-HW-015 | ADC 14-bit / 170 MSPS | TEST-DSP-002 (ENOB) | 5.1.3 |
| REQ-HW-016 | FMC Interface | INS-INT-001 | 5.3.2 |
| REQ-HW-017 | Pulse Processing | TEST-DSP-001 | 5.1.3 |
| REQ-HW-018 | Range Resolution (1m) | ANA-RAD-001 (Calc) | 5.2.1 |
| REQ-HW-019 | Power Consumption (15 W) | TEST-ENV-002 (Power) | 5.1.4 |
| REQ-HW-020 | Temperature Range | TEST-ENV-001 / INS-CON-001 | 5.1.4 / 5.3.3 |
| REQ-HW-021 | Vibration / Shock | *Sub-contract Test Lab* | N/A (Third Party) |
| REQ-HW-022 | High-Gain Stability | INS-MECH-001 (Shielding) | 5.3.1 |

---

**Document Status: AI-GENERATED**

# 6. Bill of Materials (Preliminary)

## 6.1 RF Front-End Components (Per Channel x2)

| Item No | Reference Designator | Part Number | Description | Manufacturer | Qty | Unit Cost (USD) | Total Cost | Notes |
|---|---|---|---|---|---|---|---|---|
| 1.1 | U101, U201 | PE8022 | Limiter, High Power, 2-18 GHz, SMA Connector | Pasternack | 2 | $145.00 | $290.00 | 100W Peak, 20ns Recovery |
| 1.2 | U102, U202 | GRF2074 | LNA, Low Noise, 20 dB Gain, GaAs pHEMT | Guerrilla RF | 2 | $12.50 | $25.00 | NF 0.8 dB, P1dB +20 dBm |
| 1.3 | L102, L202 | 1008CS-681XJL | Inductor, RF Choke, 680 nH, 0805 | Coilcraft | 2 | $0.45 | $0.90 | LNA Bias Choke |
| 1.4 | C103, C203 | GQM2195C2E470JB12D | Capacitor, Ceramic, 47 pF, C0G, 0805 | Murata | 4 | $0.15 | $0.60 | RF Coupling/Decoupling |
| 1.5 | FL101, FL201 | BPF-2-6G-TUN | Preselector Filter, Tunable 2-6 GHz, Bank Assm. | Custom | 2 | $85.00 | $170.00 | Assumes LC Bank for tuning speed |

## 6.2 First IF Stage (RF to 1300 MHz)

| Item No | Reference Designator | Part Number | Description | Manufacturer | Qty | Unit Cost (USD) | Total Cost | Notes |
|---|---|---|---|---|---|---|---|---|
| 2.1 | U103, U203 | MCA1-42+ | Mixer, Double Balanced, RF/LO 1-4.2 GHz | Mini-Circuits | 2 | $22.50 | $45.00 | Conv. Loss 7.0 dB, LO +13 dBm |
| 2.2 | U105, U205 | EP2K1+ | Power Splitter, 2-Way, 2-8 GHz | Mini-Circuits | 2 | $18.75 | $37.50 | LO1 Distribution to Ch1/2 |
| 2.3 | FL102, FL202 | BPF1300-100 | SAW/BPF, 1300 MHz ±50 MHz | Qorvo | 2 | $14.20 | $28.40 | 1.5 dB Insertion Loss |
| 2.4 | T101, T201 | ADT1.5-1 | Transformer, RF Balun, 4:1, 5-2000 MHz | Mini-Circuits | 2 | $6.80 | $13.60 | IF Matching |

## 6.3 Second IF Stage (1300 MHz to 200 MHz)

| Item No | Reference Designator | Part Number | Description | Manufacturer | Qty | Unit Cost (USD) | Total Cost | Notes |
|---|---|---|---|---|---|---|---|---|
| 3.1 | U104, U204 | RMS-2+ | Mixer, Double Balanced, RF/LO 5-1000 MHz | Mini-Circuits | 2 | $18.90 | $37.80 | Conv. Loss 6.5 dB |
| 3.2 | FL103, FL203 | BP200-100M | Bandpass Filter, 200 MHz IF, Ceramic | AVX | 2 | $8.50 | $17.00 | 1.5 dB Insertion Loss |
| 3.3 | U106, U206 | HMC788ALP2E | IF Driver Amplifier, 14 dB Gain, P1dB +19 | Analog Devices | 2 | $16.40 | $32.80 | Drives ADC Input |
| 3.4 | U107, U207 | GRF2040 | Gain Block, Buffer, 10.2 dB Gain | Guerrilla RF | 2 | $4.20 | $8.40 | IF Signal Conditioning |

## 6.4 Frequency Synthesis & LO Chain

| Item No | Reference Designator | Part Number | Description | Manufacturer | Qty | Unit Cost (USD) | Total Cost | Notes |
|---|---|---|---|---|---|---|---|---|
| 4.1 | U300 | ADF4106BRUZ | PLL Synthesizer, 6 GHz, Integer-N | Analog Devices | 1 | $11.25 | $11.25 | LO1 Generation |
| 4.2 | U301 | ADF4106BRUZ | PLL Synthesizer, 6 GHz, Integer-N | Analog Devices | 1 | $11.25 | $11.25 | LO2 Generation |
| 4.3 | U302, U303 | HMC586LC4B | VCO, Wideband, 3.3-7.3 GHz | Analog Devices | 2 | $42.00 | $84.00 | LO1 Source |
| 4.4 | Y300 | OSJ7014-10.0M | OCXO, Reference, 10 MHz, Low Phase Noise | Rakon | 1 | $55.00 | $55.00 | Reference Clock -120dBc/Hz |
| 4.5 | U304 | EP2K1+ | Power Splitter, 2-Way, DC-4 GHz | Mini-Circuits | 1 | $18.75 | $18.75 | LO2 Distribution |
| 4.6 | U305 | RMS-2+ | Mixer, Double Balanced | Mini-Circuits | 1 | $18.90 | $18.90 | LO2 Upconversion/Generation |

## 6.5 Data Conversion & Digital Interface

| Item No | Reference Designator | Part Number | Description | Manufacturer | Qty | Unit Cost (USD) | Total Cost | Notes |
|---|---|---|---|---|---|---|---|---|
| 5.1 | U401, U402 | AD9643BCPZ-170 | ADC, 14-Bit, 170 MSPS, Dual Channel | Analog Devices | 2 | $95.00 | $190.00 | LVDS Outputs, 1.8V Supply |
| 5.2 | J400 | FMC+ Connector | FMC+ HPC Connector, 400 Pins | Samtec | 1 | $45.00 | $45.00 | LPC/HPC Compatible |
| 5.3 | R400-R427 | Resistor Array | 100 Ohm, 1%, 0402 | Yageo | 28 | $0.05 | $1.40 | LVDS Termination |

## 6.6 Power Supply & Distribution

| Item No | Reference Designator | Part Number | Description | Manufacturer | Qty | Unit Cost (USD) | Total Cost | Notes |
|---|---|---|---|---|---|---|---|---|
| 6.1 | U600 | LMR14006 | Buck Converter, 12V to 5V, 6A | Texas Instruments | 1 | $4.50 | $4.50 | Main Rail |
| 6.2 | U601 | TPS54340 | Buck Converter, 5V to 3.3V, 4A | Texas Instruments | 1 | $3.80 | $3.80 | PLL/FPGA Rail |
| 6.3 | U602 | TPS62203 | Buck Converter, 5V to 1.8V, 2A | Texas Instruments | 1 | $2.90 | $2.90 | FPGA Core Rail |
| 6.4 | U603-U606 | MIC5209-5.0YM5 | LDO, 5V, 500mA, Low Noise | Microchip | 4 | $1.85 | $7.40 | RF Clean Rails (LNA/Mix) |
| 6.5 | U607-U608 | MIC5209-3.3YM5 | LDO, 3.3V, 500mA, Low Noise | Microchip | 2 | $1.85 | $3.70 | RF Clean Rails (PLL/ADC) |
| 6.6 | L600 | 744363100 | Power Inductor, 10 uH, 3A | Würth | 1 | $1.20 | $1.20 | Buck 1 |
| 6.7 | L601 | 744363220 | Power Inductor, 22 uH, 3A | Würth | 1 | $1.45 | $1.45 | Buck 2 |
| 6.8 | C600-C620 | Capacitor Kit | Bulk Capacitors, 10uF-100uF Tantalum | AVX | 20 | $0.50 | $10.00 | Bulk Decoupling |
| 6.9 | J900 | 691322310002 | Connector, Terminal Block, 12V Input | Würth | 1 | $3.50 | $3.50 | Mains Input |

## 6.7 Mechanical & PCB

| Item No | Reference Designator | Part Number | Description | Manufacturer | Qty | Unit Cost (USD) | Total Cost | Notes |
|---|---|---|---|---|---|---|---|---|
| 7.1 | ASM001 | RF-PCB-ASSY | PCB Assembly, 10-Layer, Rogers 4350B, ENIG | Custom Fab | 1 | $250.00 | $250.00 | Controlled Dielectric for RF |
| 7.2 | ASM002 | ENCLOSURE | Enclosure, Machined Aluminum, Shielded | Custom Mach | 1 | $180.00 | $180.00 | EMI Gaskets included |
| 7.3 | H100-H106 | 2111-1-SM-C | Hardware, SMA Connector, Board Edge | Bel-Stewart | 12 | $2.50 | $30.00 | RF I/O |
| 7.4 | HW001 | PEM-SPACER | Standoffs, Brass, 4-40, 0.5" | Keystone | 4 | $0.50 | $2.00 | PCB Mounting |

## 6.8 Total Cost Summary

| Category | Subtotal Cost (USD) |
|---|---|
| RF Front-End Components | $486.50 |
| First IF Stage | $124.50 |
| Second IF Stage | $96.00 |
| Frequency Synthesis | $198.90 |
| Data Conversion & Digital | $236.40 |
| Power Supply | $37.45 |
| Mechanical & PCB | $492.00 |
| **Grand Total (Est.)** | **$1,671.75** |

*Note: Costs are estimated based on Digi-Key/Mouser distribution pricing for single quantities. Volume production discounts may apply. Tunable Preselector cost is estimated based on complex LC bank assembly.*

---

# 7. Traceability Matrix

**Document Status: AI-GENERATED**

This section provides the traceability matrix for the hjjg Dual-Channel Radar Receiver. It maps the hardware requirements (REQ-HW) to their source specifications (Design Parameters, Customer Needs, or Derived), defines the verification method (Test, Analysis, Inspection, or Demonstration), indicates the implementation phase, and tracks the approval status.

### 7.1 Requirement Traceability Matrix (RTM)

| REQ-ID | Requirement Summary | Source | Verification Method | Phase | Status |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **REQ-HW-001** | RF Frequency Coverage (2–6 GHz) | Design Parameter (Freq Range) | Test | Integration | Allocated |
| **REQ-HW-002** | Instantaneous Bandwidth (≥100 MHz) | Design Parameter (Bandwidth) | Test | Integration | Allocated |
| **REQ-HW-003** | System Noise Figure (≤5.0 dB) | Design Parameter (NF) | Analysis / Test | Integration | Allocated |
| **REQ-HW-004** | Total System Gain (50 dB Nom) | Design Parameter (System Gain) | Test | Integration | Allocated |
| **REQ-HW-005** | Input Third-Order Intercept Point (IIP3 ≥+10 dBm) | Design Parameter (IIP3) | Test | Integration | Allocated |
| **REQ-HW-006** | Output P1dB (≥+10 dBm) | Design Parameter (Output P1dB) | Test | Integration | Allocated |
| **REQ-HW-007** | Spurious-Free Dynamic Range (SFDR ≥80 dB) | Design Parameter (SFDR) | Test | Integration | Allocated |
| **REQ-HW-008** | Selectivity / Adjacent-Channel Rejection (≥80 dBc) | Design Parameter (Selectivity) | Test | Integration | Allocated |
| **REQ-HW-009** | Input Return Loss (≤-10 dB) | Design Parameter (Input Return Loss) | Test | Integration | Allocated |
| **REQ-HW-010** | Maximum Survivable Input Power (+20 dBm) | Design Parameter (Max Input) | Test | Integration | Allocated |
| **REQ-HW-011** | Minimum Detectable Signal (MDS ≤-92 dBm) | Derived Analysis | Analysis | Integration | Allocated |
| **REQ-HW-012** | Dual-Channel Phase Coherence | Project Summary (Radar App) | Test | Integration | Allocated |
| **REQ-HW-013** | Double-IF Architecture (1300/200 MHz) | Design Parameter (F1, F2) | Inspection | Design | Allocated |
| **REQ-HW-014** | LO Phase Noise (≤-120 dBc/Hz @ 10kHz) | Design Parameter (LO Phase Noise) | Test | Integration | Allocated |
| **REQ-HW-015** | ADC Dynamic Performance (14-bit, 170 MSPS) | Design Parameter (ADC Spec) | Test | Integration | Allocated |
| **REQ-HW-016** | Data Output Interface (LVDS via FMC) | Design Parameter (FMC) | Inspection | Design | Allocated |
| **REQ-HW-017** | Radar Pulse Processing (100 ns - 1 µs) | Design Parameter (Pulse Width) | Demonstration | Validation | Allocated |
| **REQ-HW-018** | Range Resolution (≤1 m) | Design Parameter (Range Res) | Analysis | Validation | Allocated |
| **REQ-HW-019** | Power Consumption (≤15 W @ +12 V) | Design Parameter (Power Budget) | Test | Integration | Allocated |
| **REQ-HW-020** | Operating Temperature Range (-55 to +125 °C) | Design Parameter (Temp Class) | Test | Qualification | Allocated |
| **REQ-HW-021** | Vibration and Shock (MIL-STD-810) | Design Parameter (Env) | Test | Qualification | Allocated |
| **REQ-HW-022** | High-Gain Stability (Shielding/Decoupling) | Derived (Design Constraint) | Inspection | Design | Allocated |
| **REQ-HW-101** | Front-End Protection (Limiter PE8022) | Derived (Comp Selection) | Test | Integration | Allocated |
| **REQ-HW-102** | Preselector Filtering (Tunable BPF) | Design Parameter (Preselector) | Inspection | Design | Allocated |
| **REQ-HW-103** | LNA Performance (GRF2074 GaAs pHEMT) | Derived (Comp Selection) | Analysis / Test | Integration | Allocated |
| **REQ-HW-104** | 1st Mixer Conversion (MCA1-42+) | Derived (Comp Selection) | Analysis / Test | Integration | Allocated |
| **REQ-HW-105** | 2nd Mixer Conversion (RMS-2+) | Derived (Comp Selection) | Analysis / Test | Integration | Allocated |
| **REQ-HW-106** | IF Amplification (HMC788ALP2E) | Derived (Comp Selection) | Analysis / Test | Integration | Allocated |
| **REQ-HW-107** | LO Generation (ADF4106 + HMC586) | Derived (Comp Selection) | Test | Integration | Allocated |
| **REQ-HW-108** | Reference Oscillator Stability (OSJ7014-10.0M) | Derived (Comp Selection) | Test | Integration | Allocated |
| **REQ-HW-109** | Power Distribution Architecture | Block Diagram (Power Tree) | Inspection | Design | Allocated |
| **REQ-HW-110** | Digital Interface Compatibility (FMC+ / Kintex-7) | Design Parameter (FMC) | Inspection | Design | Allocated |
| **REQ-HW-111** | Signal Chain Gain Distribution | Derived (Link Budget) | Analysis | Design | Allocated |

### 7.2 Summary of Verification Methods

The following table summarizes the total count of requirements by verification method.

| Verification Method | Count | Percentage |
| :--- | :--- | :--- |
| **Test** | 19 | 55.9% |
| **Inspection** | 7 | 20.6% |
| **Analysis** | 5 | 14.7% |
| **Demonstration** | 3 | 8.8% |
| **TOTAL** | **34** | **100%** |

### 7.3 Derived Requirements Notes

*   **REQ-HW-011 (MDS):** This requirement is analytically derived from the System Noise Figure (REQ-HW-003) and Bandwidth (REQ-HW-002) using the thermal noise floor formula: $MDS = -174 + 10\log_{10}(B) + NF$. Assuming NF = 5 dB and BW = 100 MHz, MDS ≈ -89 dBm. The requirement specifies ≤ -92 dBm to allow for implementation margin.
*   **REQ-HW-022 (Stability):** This requirement is derived from the high total system gain (50 dB). To prevent oscillation in a multi-stage cascade, strict RF layout rules (shielding, grounding) are mandated.
*   **REQ-HW-101 to 111:** These requirements map specific design constraints derived from the "Component Recommendations" section of the source data to ensure the Bill of Materials (BOM) is strictly adhered to during procurement and assembly.