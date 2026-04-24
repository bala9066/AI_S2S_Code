# Hardware Requirements
## yhh

## 1. Project Summary

4-channel monopulse radar RF front-end (18–40 GHz, K/Ka-band) with balanced LNA architecture using quad-hybrid coupling. Four independent receive chains feed a Σ/Δ₁/Δ₂ monopulse comparator network. Each chain comprises: N-type connector → PIN diode limiter → BFCN-1840+ ceramic preselector → PMA4-6263LN+ LNA → PMA3-15453+ Ka-band gain block → interstage BFCN-1840+ BPF → PMA3-15453+ second gain block → SCA-4-132+ 4-way monopulse combiner. The balanced LNA topology (two LNAs per antenna via 3 dB/90° hybrid) provides 14 dB input return loss and 6 dB extra OIP3 per channel. Total cascaded gain ~50 dB per chain, system NF ~4.4 dB, IIP3 +20 dBm. Power budget: ~25 W from +28 V MIL bus. Military temperature range -55 to +125°C, IP67 sealed, MIL-STD-810 compliant.

## 2. Design Parameters

| Parameter | Value |
|---|---|
| Frequency Range Ghz | 18-40 |
| Bandwidth Mhz | 500 |
| Noise Figure Db | 4.4 |
| Output Power Dbm | -10 |
| Iip3 Dbm | 20 |
| System Gain Db | 50 |
| Mds Dbm | -99 |
| Supply Voltage V | 28 |
| Power Budget W | 30 |
| Antenna Count | 4 |
| Channel Count | 1 |
| Preselector Tech | Ceramic |
| Cascaded Nf Db | 4.4 |
| Cascaded Gain Db | 50 |
| Cascaded P1Db Dbm | 10 |
| Cascaded Iip3 Dbm | 70 |
| Center Freq Ghz | 29 |
| Lna Technology | GaAs pHEMT |
| Architecture | Balanced LNA (quad-hybrid) |
| Application | Radar monopulse |
| Num Monopulse Outputs | 4 |
| Lnas Per Channel | 2 |
| Phase Tracking Deg | 5 |
| Amplitude Tracking Db | 0.5 |

## 3. Requirements

### 3.1 Functional Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-001 | Frequency Range | The RF front-end shall operate over the full K/Ka-band frequency range of 18 GHz to 40 GHz (VSWR < 1.5:1, RL > 14 dB across band). All passive and active components must be specified and characterized across this entire range. | Must have | test | None | 18-40 GHz continuous coverage |
| REQ-HW-009 | Number of Parallel RF Channels | The system shall provide 4 independent RF receive channels, one per monopulse antenna element. Each channel has an identical signal chain (limiter, preselector, LNA, gain stages). Phase matching between channels: +/-5 degrees. Amplitude matching: +/-0.5 dB. | Must have | test | None | None |
| REQ-HW-010 | Monopulse Comparator Network | A 4-way monopulse comparator (SCA-4-132+ based) shall combine the 4 channel outputs to produce Sum (Sigma), Elevation Difference (Delta-EL), Azimuth Difference (Delta-AZ), and Delta-Delta channels. Comparator isolation: > 20 dB between sum and difference ports. | Must have | test | None | None |
| REQ-HW-011 | Balanced LNA Architecture | Each channel LNA shall use a balanced (quad-hybrid) topology: input 3 dB/90-degree hybrid feeds two identical LNAs, output hybrid recombines. Benefits: improved input return loss (> 20 dB), doubled OIP3 (+6 dB), redundancy if one LNA fails. Each balanced pair uses 2x PMA4-6263LN+. | Must have | test | None | None |
| REQ-HW-012 | Antenna Interface | Each of the 4 antenna inputs shall interface via N-type connector (50 ohm). Internally, a balun/transformer converts from the 100-ohm differential antenna feed to 50-ohm single-ended for the RF chain. Connector: N-type female panel-mount, IP67 sealed. | Must have | inspection | None | None |
| REQ-HW-013 | Preselector Filter | Each channel shall include a ceramic bandpass preselector filter (BFCN-1840+) between the limiter and LNA. This filter provides out-of-band rejection and limits noise bandwidth entering the LNA. The preselector is MANDATORY per canonical front-end topology. | Must have | test | None | None |
| REQ-HW-014 | Limiter Protection | A PIN diode limiter circuit using Skyworks CLA4611-085LF shall protect each channel front-end. Limiter threshold: +10 to +15 dBm. Insertion loss at small signal: < 0.5 dB. Peak power handling: +30 dBm. The limiter sits between the N-type connector and the preselector. | Must have | test | None | None |
| REQ-HW-015 | T/R Protection Switch | A Qorvo QPC2420SR SPDT switch (0.02–30 GHz) shall be placed at each channel input for T/R protection during transmit pulses. Switching time < 10 us. Isolation > 30 dB. Handles TX leakage of 0 to +10 dBm. Note: For full 40 GHz coverage, switch isolation above 30 GHz will require characterization or an alternative approach. | Should have | test | None | None |
| REQ-HW-020 | Active Bias Control | Each LNA and gain block shall use active bias circuitry to maintain constant quiescent current over temperature (-55 to +125 C) and supply variation. Bias settling time < 10 us after T/R switch transition. | Must have | test | None | None |
| REQ-HW-027 | High-Gain Stability | With cascaded gain of ~50 dB, the design shall incorporate interstage BPF (BFCN-1840+) between gain stages 1 and 2 to prevent oscillation via feedback. Shielded cavities per amplifier stage. Reverse input/output orientation on PCB layout. Minimum isolation between cavities: 80 dB. | Must have | analysis | None | None |
| REQ-HW-029 | LNA Semiconductor Technology | Per user specification, SiGe BiCMOS LNA technology is preferred. However, for 18-40 GHz operation, GaAs pHEMT MMICs (PMA4-6263LN+) are used as the closest available broadband technology covering the full band. If SiGe parts covering 18-40 GHz become available, they may be evaluated as drop-in replacements. | Should have | inspection | None | None |
| REQ-HW-034 | BIT / Self-Test | A built-in test capability shall be provided to verify front-end functionality: RF power detection at each channel output, temperature monitoring at LNA locations, and supply voltage monitoring. BIT shall detect > 90% of catastrophic failures. | Should have | test | None | None |

### 3.2 Performance Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-002 | Instantaneous Bandwidth | Each RF channel shall support a minimum instantaneous bandwidth (IBW) of 500 MHz within the 18–40 GHz operating range, selectable via sub-band ceramic preselector filters. | Must have | test | None | None |
| REQ-HW-003 | System Noise Figure | The cascaded system noise figure shall not exceed 6.0 dB at any frequency within the 18–40 GHz range. Target NF is 4.0–5.0 dB at mid-band (29 GHz). Derivation: NF = MDS - (-174 + 10*log10(BW)) - SNR_target. | Must have | test | None | None |
| REQ-HW-004 | LNA Chain Gain | Each RF channel shall provide a total small-signal gain of 40–60 dB (nominal 50 dB) across the operating band. Gain variation shall not exceed +/-2 dB across any 500 MHz sub-band. | Must have | test | None | None |
| REQ-HW-005 | Input Third-Order Intercept Point (IIP3) | System IIP3 shall be +20 dBm minimum. Balanced LNA architecture with quad-hybrid coupling provides 6 dB OIP3 improvement over single-ended topology. OIP3 target: +70 dBm (IIP3 + Gain = +20 + 50 = +70 dBm). | Must have | test | None | None |
| REQ-HW-006 | Maximum Input Power / Survivability | The front-end shall survive continuous input power of +30 dBm (1 W) without damage or performance degradation. PIN diode limiter network (CLA4611-085LF) shall limit LNA input to < +15 dBm CW. Recovery time < 1 us after overload removal. | Must have | test | None | None |
| REQ-HW-007 | Input Return Loss / VSWR | Input return loss shall be better than 14 dB (VSWR < 1.5:1) across 18–40 GHz. The balanced LNA topology inherently provides excellent input match through 90-degree hybrid coupling. | Must have | test | None | None |
| REQ-HW-008 | Minimum Detectable Signal | Derived MDS shall be -84.2 dBm for 500 MHz bandwidth at NF = 5 dB, using MDS = -174 + 10*log10(500e6) + NF + SNR = -174 + 57 + 5 + 13 = -99 dBm (for pulsed radar with SNR=13 dB processing gain). For 100 MHz BW: MDS = -174 + 50 + 5 + 13 = -106 dBm. | Must have | analysis | None | None |
| REQ-HW-016 | Pulse Handling | The front-end shall faithfully process radar pulses with widths from 100 ns to 1 us without amplitude droop or phase distortion exceeding 0.5 dB and 5 degrees respectively. Group delay variation across any 500 MHz sub-band shall not exceed 2 ns. | Must have | test | None | None |
| REQ-HW-017 | Phase Coherence | The 4-channel front-end shall maintain phase coherence suitable for monopulse processing. Inter-channel phase tracking: +/-5 degrees across 18–40 GHz. Inter-channel amplitude tracking: +/-0.5 dB. | Must have | test | None | None |
| REQ-HW-018 | TX Leakage Handling | The front-end shall withstand TX leakage levels of 0 to +10 dBm at the LNA input without gain compression or damage. The T/R switch + limiter cascade provides > 40 dB isolation during TX phase. | Must have | test | None | None |
| REQ-HW-019 | Output Interface to Downstream Receiver | Each monopulse comparator output (Sigma, Delta-EL, Delta-AZ, Delta-Delta) shall present a 50-ohm RF output at SMA-female connectors, suitable for feeding a superheterodyne receiver. Output power range: -60 to -10 dBm. Output P1dB > +10 dBm. | Must have | test | None | None |
| REQ-HW-032 | Gain Flatness | Total gain variation across the full 18-40 GHz band shall not exceed +/-3 dB. Within any 500 MHz sub-band, gain variation shall not exceed +/-1 dB. | Should have | test | None | None |
| REQ-HW-033 | Output P1dB | Each channel output P1dB shall exceed +10 dBm. Each monopulse comparator output P1dB shall exceed +5 dBm after combining losses. | Must have | test | None | None |
| REQ-HW-035 | Noise Figure Budget per Cascade Stage | Friis cascade analysis (see GLB): System NF at 29 GHz = 3.55 dB (LNA input) + 0.5 dB (preselector IL) + contributions from post-LNA stages = ~4.4 dB total, within the 4-6 dB target. | Must have | analysis | None | None |

### 3.3 Constraint Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-021 | Power Budget | Total DC power consumption shall not exceed 30 W from the +28 V MIL-STD-704 bus. Estimated breakdown: 8x PMA4-6263LN+ LNAs at 2 W each = 16 W, 8x PMA3-15453+ gain blocks at 1 W each = 8 W, bias/splitter/limiter/control = 6 W. Total ~30 W. | Must have | test | None | None |
| REQ-HW-022 | Supply Voltage | Primary supply shall be +28 VDC per MIL-STD-704. Internal DC-DC conversion to +5V (via TI TPS54531DDA buck) and LDO regulation to required LNA/gain-block rails. Reverse polarity protection required on +28V input. | Must have | test | None | None |
| REQ-HW-023 | Operating Temperature Range | The front-end shall operate over the full military temperature range of -55 C to +125 C (storage: -55 C to +125 C). All component junction temperatures shall remain within manufacturer-rated limits at T_amb = 125 C with appropriate thermal design (copper coins, thermal vias). | Must have | analysis | None | None |
| REQ-HW-028 | PCB Stack-Up | RF PCB shall use Rogers RO4350B or equivalent low-loss laminate (Dk=3.66, tan delta=0.0037 at 10 GHz). Controlled-impedance 50-ohm microstrip or grounded coplanar waveguide. Minimum 4-layer stack-up with continuous ground plane on layer 2. Via fencing on all RF traces. | Must have | inspection | None | None |
| REQ-HW-030 | RoHS / REACH Compliance | All components and assemblies shall comply with EU RoHS (2011/65/EU) and REACH regulations. Exemptions for defense applications shall be documented per project-specific ITAR requirements. | Must have | inspection | None | None |
| REQ-HW-031 | ITAR Compliance | This radar front-end design is subject to ITAR (International Traffic in Arms Regulations, 22 CFR 120-130) as a defense article. All design data, components, and manufacturing shall be controlled accordingly. | Must have | inspection | None | None |
| REQ-HW-036 | Regulator Thermal Budget | For each DC-DC converter and LDO: T_junction <= 125 C at T_amb = 85 C (derated from 125 C operational for margin). TI TPS54531DDA buck: P_diss = P_out * (1-eta)/eta. At 15 W output, eta ~90%: P_diss = 1.67 W. T_j = 85 + 1.67 * theta_ja. Heatsink/copper pour required if T_j > 110 C. | Must have | analysis | None | None |
| REQ-HW-037 | Interstage Isolation Budget | With 50 dB cascaded gain, the reverse isolation through shared supply/ground paths must be > 80 dB to prevent oscillation. Each gain stage shall have independent LC-filtered bias feeds. Shielded cavity walls between stages. | Must have | analysis | None | None |

### 3.4 Environmental Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-024 | Vibration and Shock | The assembly shall meet MIL-STD-810 light vibration and shock requirements. All SMT components shall use underfill. Connectors shall be secured with locking hardware. | Must have | test | None | None |
| REQ-HW-025 | Ingress Protection | The enclosure shall be rated IP67 (dust-tight, temporary immersion to 1 m). All RF connectors shall be IP67-sealed N-type. Gasketed enclosure lid with EMI gasket. | Must have | test | None | None |
| REQ-HW-026 | EMC Compliance | The front-end shall comply with MIL-STD-461G CE102, CS101, CS114, RE102, RS103. Shielded compartments for each gain stage. Ferrite bead + LC decoupling on every bias rail. | Must have | test | None | None |
