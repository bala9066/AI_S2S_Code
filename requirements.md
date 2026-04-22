# Hardware Requirements
## hfuf

## 1. Project Summary

4-Channel 2-6 GHz Radar RF Front-End Module with GaN LNA chain, limiter-protected front-end, and LC preselector filters. Designed for monopulse ΣΔΔ radar receiver (feeds superheterodyne back-end) with +30 dBm survivability, 40-60 dB gain, 4-6 dB system NF, +20 dBm IIP3, and 10 µs T/R switching. Operates from +12 V supply, 15-30 W power budget, 0 to +70°C commercial temperature range with IP54 environmental protection and MIL-STD-810 light compliance.

## 2. Design Parameters

| Parameter | Value |
|---|---|
| Frequency Range Ghz | 2-6 |
| Bandwidth Mhz | 100 |
| Noise Figure Db | 5 |
| System Gain Db | 50 |
| Iip3 Dbm | 20 |
| Output Power Dbm | 10 |
| Mds Dbm | -92 |
| Supply Voltage V | 12 |
| Power Budget W | 22.5 |
| Antenna Count | 4 |
| Channel Count | 1 |
| Preselector Tech | LC discrete |
| Lna Semiconductor | GaN HEMT |
| Input Return Loss Db | 14 |
| Max Safe Input Dbm | 30 |
| Tx Leakage Dbm | 15 |
| Tr Switching Time Us | 10 |
| Pulse Width Range Us | 1-10 |
| Interference Environment | Low |
| Operating Temp C | 0 to +70 |
| Ip Rating | IP54 |
| Vibration Standard | MIL-STD-810 light |
| Output Impedance Ohm | 50 |
| Rf Connector Type | 2.92mm |
| Phase Matching Deg | 5 |
| Amplitude Matching Db | 0.5 |

## 3. Requirements

### 3.1 Functional Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-001 | Frequency Range | RF front-end shall operate from 2.0 to 6.0 GHz with full coverage across S-band (2-4 GHz) and C-band (4-6 GHz). | Must have | test | None | S-band and C-band coverage, Single-ended 50Ω input impedance |
| REQ-HW-009 | Input Limiter Protection | Input limiter shall activate at ≤ +15 dBm and provide protection up to +30 dBm with < 0.5 dB flat loss and < 10 ns recovery time. | Must have | test | REQ-HW-007 | None |
| REQ-HW-010 | Preselector Filtering | LC bandpass preselector shall provide ≥ 15 dB out-of-band rejection at ±500 MHz from passband edges. | Must have | test | REQ-HW-003 | None |
| REQ-HW-011 | GaN LNA Technology | Low-noise amplifier stages shall use GaN HEMT technology for high linearity and power handling. | Must have | inspection | REQ-HW-005 | None |
| REQ-HW-014 | 4-Channel Parallel Architecture | System shall provide 4 independent parallel RF channels for monopulse ΣΔΔ beamforming with phase-matched paths. | Must have | inspection | None | Phase matching: ±5° across band, Amplitude matching: ±0.5 dB across band |
| REQ-HW-015 | RF Interface Connector | RF input/output connectors shall be 2.92mm (K) type, 50Ω, female. | Must have | inspection | None | None |
| REQ-HW-017 | Active Bias Control | LNA bias shall use active bias circuitry for temperature compensation and gate sequencing (negative gate before positive drain for GaN). | Must have | test | None | Gate-before-drain sequencing required |
| REQ-HW-018 | Supply Voltage | Primary supply voltage shall be +12 V DC ±10%. | Must have | test | None | None |
| REQ-HW-027 | Interface to Downconverter | RF outputs shall interface to superheterodyne downconverter with 50Ω single-ended impedance. | Must have | inspection | None | Compatible with 70 MHz or 140 MHz first-IF |
| REQ-HW-033 | Minimum Detectable Signal (MDS) | System MDS shall be −92 dBm (derived from 5 dB NF, 100 MHz BW, 10 dB SNR). | Should have | analysis | None | MDS = −174 + 10·log10(BW) + NF + SNR, Assumes 100 MHz IBW, 5 dB NF, 10 dB SNR |
| REQ-HW-035 | Calibration Interface | Front-end shall provide calibration access for gain/phase trimming per channel. | Could have | inspection | REQ-HW-014 | None |

### 3.2 Performance Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-002 | Instantaneous Bandwidth | Front-end shall support 10 to 100 MHz instantaneous bandwidth per channel. | Must have | test | None | None |
| REQ-HW-003 | System Noise Figure | Overall system noise figure shall be 4 to 6 dB (includes limiter, preselector, LNA chain losses). | Must have | test | REQ-HW-010, REQ-HW-011 | None |
| REQ-HW-004 | LNA Chain Gain | LNA chain shall provide 40 to 60 dB of gain per channel across 2-6 GHz. | Must have | test | REQ-HW-010 | None |
| REQ-HW-005 | Input Linearity (IIP3) | System input-referred third-order intercept point (IIP3) shall be +20 dBm minimum. | Must have | test | None | None |
| REQ-HW-006 | Input Return Loss | Input return loss shall be 14 dB minimum (VSWR ≤ 1.5:1) across 2-6 GHz. | Must have | test | None | None |
| REQ-HW-007 | Maximum Survivable Input | Front-end shall survive +30 dBm CW input power at antenna port without damage. | Must have | test | REQ-HW-009 | None |
| REQ-HW-008 | TX Leakage Handling | Front-end shall tolerate +10 to +20 dBm TX leakage at LNA input during transmit mode with < 0.5 dB gain compression. | Must have | test | None | Requires fast T/R switching |
| REQ-HW-012 | Gain Flatness | Gain flatness shall be ±2.5 dB across 2-6 GHz per channel. | Should have | test | None | None |
| REQ-HW-013 | Reverse Isolation | Reverse isolation shall be ≥ 40 dB to prevent LO leakage and transmitter back-reflection. | Should have | test | None | None |
| REQ-HW-016 | T/R Switching Speed | T/R switching time shall be ≤ 10 µs from transmit-to-receive and receive-to-transmit transitions. | Must have | test | REQ-HW-008 | None |
| REQ-HW-019 | Power Consumption | Total power consumption shall be 15 to 30 W across all 4 channels including bias and control circuits. | Must have | test | None | None |
| REQ-HW-028 | Phase Noise Contribution | LNA chain additive phase noise shall be ≤ −150 dBc/Hz at 10 kHz offset (no LO contribution). | Should have | test | None | None |
| REQ-HW-029 | Stability | LNA chain shall be unconditionally stable with K-factor > 1.5 and B1 > 0 across 2-6 GHz. | Must have | test | None | None |
| REQ-HW-030 | Group Delay Variation | Group delay variation shall be ≤ 5 ns across 100 MHz instantaneous bandwidth for 1-10 µs radar pulses. | Should have | test | None | None |
| REQ-HW-034 | MTBF | Mean time between failures (MTBF) shall be ≥ 50,000 hours at 40°C ambient. | Could have | analysis | None | None |
| REQ-HW-037 | Thermal Management | Junction temperature of all active devices shall remain ≤ 125°C at +70°C ambient with worst-case power dissipation. | Must have | analysis | REQ-HW-019, REQ-HW-020 | None |
| REQ-HW-038 | Output Power Capability | Each LNA chain shall deliver 0 to +10 dBm output power into 50Ω load at 1 dB compression. | Should have | test | None | None |

### 3.3 Environmental Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-020 | Operating Temperature | Operating temperature range shall be 0 to +70°C (commercial). | Must have | test | None | None |
| REQ-HW-021 | Storage Temperature | Storage temperature range shall be −40 to +85°C. | Should have | inspection | None | None |
| REQ-HW-022 | Vibration and Shock | Unit shall survive MIL-STD-810 light vibration and shock profiles. | Should have | test | None | MIL-STD-810 Method 514.6 (Vibration), MIL-STD-810 Method 516.6 (Shock) |
| REQ-HW-023 | Ingress Protection | Enclosure shall provide IP54 rating (dust-protected, water-splash resistant) for outdoor deployment. | Must have | inspection | None | None |
| REQ-HW-024 | Humidity | Unit shall operate at 5% to 95% relative humidity (non-condensing). | Should have | test | None | None |

### 3.4 Constraint Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-025 | Semiconductor Technology | LNA shall use GaN HEMT technology as specified. | Must have | inspection | REQ-HW-011 | None |
| REQ-HW-026 | Filter Technology | Preselector filters shall use discrete LC technology for custom 2-6 GHz tuning. | Must have | inspection | REQ-HW-010 | None |
| REQ-HW-031 | EMC Compliance | Unit shall meet applicable EMC requirements for commercial radar equipment. | Should have | test | None | FCC Part 15 Subpart B (unintentional radiator), EN 55032 Class B emissions limit |
| REQ-HW-032 | RoHS Compliance | All components shall be RoHS 2011/65/EU compliant. | Must have | inspection | None | None |
| REQ-HW-036 | Bias Sequencing (GaN) | For GaN HEMT LNAs, negative gate voltage shall be applied before positive drain voltage; drain shall be enabled before RF signal path. | Must have | inspection | None | Gate-before-drain sequence prevents device destruction |
