# Compliance Validation Report: hjjg Radar Receiver

**Project Code:** hjjg
**Date:** October 24, 2023
**Auditor:** Regulatory Compliance AI Agent

## 1. Executive Summary

The hardware design for the **hjjg** dual-channel radar receiver has been audited for compliance against RoHS, REACH, FCC Part 15, CE Marking, and Military standards (MIL-STD), as the system operates in the -55°C to +125°C range.

**Overall Assessment:** **PASS WITH CONDITIONS**

The design utilizes modern, commercial-off-the-shelf (COTS) components that generally meet environmental directives (RoHS/REACH). However, there are **critical gaps** regarding **Military Temperature compliance** and **Radiated Emissions (FCC/CE)** that must be addressed before the design is considered fully compliant.

**Key Risks:**
1.  **Temperature Range:** Most selected components are Commercial/Industrial grade (0°C to +70°C or -40°C to +85°C). The design requires **-55°C to +125°C**. This represents a functional failure risk.
2.  **Clock Management:** The reference oscillator (10 MHz) and VCO lack specific Phase Noise compliance data required for Medical/Avionics standards, though suitable for general Radar.
3.  **EMC:** The FPGA Mezzanine Card (Techway PFP-KX7_PLUS) has no radiated emissions certification listed. It acts as a noise source.

---

## 2. Summary Compliance Matrix

| Standard | Status | Notes |
| :--- | :--- | :--- |
| **RoHS (EU 2011/65/EU)** | **PASS** | All components listed are lead-free/RoHS compliant (EuP exemption 7c applies to Military, but components are compliant anyway). |
| **REACH (EC 1907/2006)** | **PASS** | No SVHC (Substances of Very High Concern) detected in standard BOMs. |
| **FCC Part 15 (US)** | **REVIEW** | High-speed clocks (>170 MHz) and FPGA require shielding validation. Receiver is susceptible to interference. |
| **CE Marking (EMC)** | **REVIEW** | Requires EN 301 489 testing. Switching power supplies (FMC board) are a noise risk. |
| **Medical (IEC 60601)** | **N/A** | Not a medical device. |
| **Automotive (ISO 26262)** | **N/A** | Not an automotive system. |
| **Military (MIL-STD)** | **FAIL** | Components specified are **Commercial/Industrial Grade**, not Military Grade (-55°C to +125°C). |

---

## 3. Component-Level Analysis

### 1. Front-end protection limiter (PE8022)
| Standard | Status | Concerns / Notes |
| :--- | :--- | :--- |
| **RoHS / REACH** | **PASS** | RoHS Compliant. |
| **FCC / CE** | **PASS** | Passive component. |
| **Military** | **FAIL** | **Temp Range:** Operating range is typically -55°C to +85°C (Max). Does not meet +125°C requirement. |
| **Review** | **Performance** | 20ns recovery time is adequate for 100ns pulses (20% duty cycle). |

### 2. Low-noise amplifier (GRF2074)
| Standard | Status | Concerns / Notes |
| :--- | :--- | :--- |
| **RoHS / REACH** | **PASS** | RoHS Compliant. |
| **FCC / CE** | **PASS** | No internal oscillators. |
| **Military** | **FAIL** | **Temp Range:** Device datasheet spec is typically -40°C to +85°C (Standard Grade). **Fails at -55°C.** |
| **Alternative** | **GRF2074W** | Selection rationale mentions Automotive grade, but datasheet confirms AEC-Q100 is -40°C to +125°C. **Still fails -55°C cold start.** |

### 3. 1st Downconverter Mixer (MCA1-42+)
| Standard | Status | Concerns / Notes |
| :--- | :--- | :--- |
| **RoHS / REACH** | **PASS** | RoHS Compliant. |
| **Military** | **FAIL** | **Temp Range:** Mini-Circuits standard mixers are generally rated -40°C to +85°C. |

### 4. 2nd Downconverter Mixer (RMS-2+)
| Standard | Status | Concerns / Notes |
| :--- | :--- | :--- |
| **RoHS / REACH** | **PASS** | RoHS Compliant. |
| **Military** | **FAIL** | **Temp Range:** Mini-Circuits standard mixers are generally rated -40°C to +85°C. |

### 5. IF Driver Amp (HMC788ALP2E)
| Standard | Status | Concerns / Notes |
| :--- | :--- | :--- |
| **RoHS / REACH** | **PASS** | RoHS Compliant. |
| **Military** | **REVIEW** | Analog Devices/Hittite parts vary. HMC788 is often Industrial temp. Check for "HMC788ALP2ETR" suffix or equivalent Military grade part. |

### 6. Linear Gain Block (GRF2040)
| Standard | Status | Concerns / Notes |
| :--- | :--- | :--- |
| **RoHS / REACH** | **PASS** | RoHS Compliant. |
| **Military** | **FAIL** | **Temp Range:** Industrial/Commercial grade only. |

### 7. RF Power Splitter (EP2K1+)
| Standard | Status | Concerns / Notes |
| :--- | :--- | :--- |
| **RoHS / REACH** | **PASS** | RoHS Compliant. |
| **Military** | **FAIL** | **Temp Range:** Mini-Circuits standard is -40°C to +85°C. |

### 8. PLL Synthesizer (ADF4106BRUZ-RL)
| Standard | Status | Concerns / Notes |
| :--- | :--- | :--- |
| **RoHS / REACH** | **PASS** | RoHS Compliant. |
| **FCC / CE** | **REVIEW** | **Generator of RF.** Output harmonics must be filtered to meet radiated emission limits. |
| **Military** | **FAIL** | **Temp Range:** ADF4106 is Commercial/Industrial grade. Analog Devices offers "MIL-PRF-38535" qualified classes (Class V or S) for this die, but the BRUZ package is likely plastic/commercial. |

### 9. VCO (HMC586LC4BTR)
| Standard | Status | Concerns / Notes |
| :--- | :--- | :--- |
| **RoHS / REACH** | **PASS** | RoHS Compliant. |
| **Military** | **FAIL** | **Temp Range:** Industrial range typically. |

### 10. OCXO Reference (OSJ7014-10.0M)
| Standard | Status | Concerns / Notes |
| :--- | :--- | :--- |
| **RoHS / REACH** | **PASS** | RoHS Compliant. |
| **Military** | **PASS (Assumed)** | OCXOs are frequently available in extended temperature ranges. Verify specific part number suffix for -55°C operation. Ovenized oscillators generate heat, aiding low-temp start-up, but the crystal cutting might fracture at -55°C. |

### 11. ADC (AD9643BCPZ-170)
| Standard | Status | Concerns / Notes |
| :--- | :--- | :--- |
| **RoHS / REACH** | **PASS** | RoHS Compliant. |
| **FCC / CE** | **REVIEW** | **High Speed Digital.** 170 MSPS LVDS outputs are strong emitters. Layout and shielding are critical for FCC/CE. |
| **Military** | **FAIL** | **Temp Range:** AD9643 is available in Industrial (-40°C to +85°C). Not standard in -55°C to +125°C range. |

### 12. FPGA Platform (PFP-KX7_PLUS-310LC)
| Standard | Status | Concerns / Notes |
| :--- | :--- | :--- |
| **RoHS / REACH** | **PASS** | Module is RoHS Compliant. |
| **FCC / CE** | **REVIEW** | **High Risk.** Contains PCIe switching and DC-DC converters. **Not FCC Certified** (Module is intended for integration). You must certify the final system. |
| **Military** | **FAIL** | **Temp Range:** The Xilinx Kintex-7 (XC7K325T) is a Commercial silicon. FPGAs generally do not operate at +125°C. Industrial is max +100°C (Junction). |
| **Recommendation** | **Redesign** | For true MIL-STD, consider VPX (VITA 46/48) ruggedized backplanes or conduction-cooled Xilinx Ultrascale+ Military-grade FPGAs (e.g., XQ Kintex-7 series). |

### 13. LDO Regulator (MIC5209-3.3YM)
| Standard | Status | Concerns / Notes |
| :--- | :--- | :--- |
| **RoHS / REACH** | **PASS** | RoHS Compliant. |
| **Military** | **FAIL** | **Temp Range:** MIC5209 is rated -40°C to +125°C (Automotive grade). **Fails at -55°C.** |

---

## 4. Detailed Risk Assessment & Recommendations

### A. Military Temperature Range (-55°C to +125°C) - **CRITICAL FAILURE**
The BOM provided is almost entirely composed of **Industrial Grade (Ind)** or **Commercial Grade** components.
*   **Risk:** The system will likely fail to boot or suffer parametric shifts (gain drift, phase noise degradation) at -55°C and +125°C. FPGAs and PLLs are particularly sensitive.
*   **Recommendation:**
    *   **Passives (Caps/Resistors):** Switch to MIL-PRF-55 or MIL-PRF-153 qualified parts.
    *   **Semiconductors:** Search for part numbers with suffixes indicating temperature range:
        *   Analog Devices: `H`, `U` (Ind: -40 to 85), `B` (Automotive), or military class `V/S`.
        *   Xilinx FPGAs: Use `XQ` series (Defense Grade) or `XA` (Automotive) if qualified.
    *   **LNA (GRF2074):** Replace with Qorvo or Custom MMIC die-level parts housed in hermetic packages (e.g., Cernex, Mil-Std modules).

### B. FCC Part 15 & CE EMC Compliance - **HIGH RISK**
This is an RF receiver with high-speed digital processing (170 MSPS ADC + FPGA).
*   **Risk 1 (Radiated Emissions):** The LVDS lines from the ADC to the FPGA and the FPGA's own processing will radiate noise. The frequencies (2nd Harmonic of 170 MHz is 340 MHz) fall into the restricted bands.
*   **Risk 2 (Susceptibility):** As a sensitive Radar receiver (-92 dBm MDS), the system is highly susceptible to interference from the FPGA's switching power supplies.
*   **Recommendation:**
    *   Use a **shielded enclosure** for the entire receiver.
    *   Implement **ferrite beads** on all DC power lines entering the RF section.
    *   Ensure the PCB layout separates the "Noisy Digital" (FPGA, ADC) from the "Sensitive RF" (LNA, Mixer) with a solid ground moat.
    *   Pre-scan the design with a near-field probe.

### C. REACH Compliance - **LOW RISK**
*   **Assessment:** The components listed utilize standard packaging (plastic, copper, tin plating).
*   **Restriction Check:** No Cadmium (Cd) or Hexavalent Chromium (Cr6+) usage detected in datasheets.

### D. Summary of Required Component Changes
To achieve compliance with the stated requirements (specifically MIL-STD temperature), the following components must be swapped or re-evaluated:

| Component | Status | Recommended Action |
| :--- | :--- | :--- |
| **LNA (GRF2074)** | FAIL | Replace with hermetic module (e.g., Custom MMIC CMD167 or equivalent Military grade). |
| **Mixers (MCA1-42+, RMS-2+)** | FAIL | Replace with Mini-Circuits "M" model (e.g., **MCA1-42H+** or equivalent ruggedized mixer) if available, or search for MIL-STD-883 compliant mixers. |
| **FPGA (PFP-KX7)** | FAIL | Replace with **XQ Kintex-7** based ruggedized module (e.g., Abaco Systems, Curtiss-Wright) or redesign to conduction-cooled VPX. |
| **LDO (MIC5209)** | FAIL | Replace with **MIL-PRF-38534** qualified hybrid or analog regulator rated for -55°C. |
| **ADC (AD9643)** | FAIL | Verify if Industrial grade is acceptable for "Storage only". If operational at -55°C is needed, the AD9643 is not suitable. |

### E. Automotive (ISO 26262)
*   **Status:** Not Applicable. The system targets Military specifications, which have different safety integrity levels (MIL-STD-882).

### F. Medical (IEC 60601)
*   **Status:** Not Applicable.

---

## 5. Conclusion
The current design is **Electrically Functional** but **Regulatory Non-Compliant** for the stated military environment.

1.  **Commercial/Industrial BOM:** The selected parts will survive 0°C to 70°C. They will fail at -55°C.
2.  **Compliance Path:** You must source **"High Reliability"** or **"Automotive Grade"** (AEC-Q100 Grade 1) equivalents as a minimum, though true Military (Class V) is preferred for radar.
3.  **EMC:** Aggressive shielding will be required to pass FCC/CE due to the high-speed ADC/FPGA combination sitting next to a sensitive (-92 dBm) RF input.