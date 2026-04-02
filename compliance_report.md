# Compliance Validation Report: rfff RF Power Amplifier

**Project:** rfff (2.4 GHz GaN PA)
**Date:** October 26, 2023
**Standards:** RoHS 2 (2011/65/EU), REACH (EC 1907/2006), FCC Part 15, CE Marking (EMC Directive)

---

## 1. Executive Summary

The **rfff** project is a high-power RF device designed for the 2.4 GHz ISM band. The primary compliance risks involve **Electromagnetic Compatibility (EMC)** due to the fundamental emission of a high-power carrier (10W) and potential harmonic distortion.

**Overall Assessment:** **PASS** (Conditional on EMC shielding implementation).

### Summary Compliance Matrix

| Component | RoHS | REACH | FCC Part 15 | CE Marking | Medical (IEC 60601) | Auto (ISO 26262) | Mil (MIL-STD) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **QPA9424 (PA)** | PASS | PASS | REVIEW | REVIEW | N/A | N/A | N/A |
| **SMBJ33A (TVS)** | PASS | PASS | PASS | PASS | N/A | N/A | N/A |
| **BLM18PG471SN1 (Ferrite)** | PASS | PASS | PASS | PASS | N/A | N/A | N/A |
| **Tantalum Cap (100uF)** | PASS | PASS | PASS | PASS | N/A | N/A | N/A |
| **Ceramic Cap (10uF)** | PASS | PASS | PASS | PASS | N/A | N/A | N/A |
| **SMA Connector** | PASS | PASS | PASS | PASS | N/A | N/A | N/A |
| **Heatsink (Aluminum)** | PASS | PASS | N/A | N/A | N/A | N/A | N/A |
| **Sil-Pad 1500 (TIM)** | PASS | PASS | N/A | N/A | N/A | N/A | N/A |
| **Resistor (0805)** | PASS | PASS | PASS | PASS | N/A | N/A | N/A |

**Legend:**
*   **PASS**: Meets requirements based on specifications.
*   **REVIEW**: Requires system-level testing or specific design attention (Intentional Radiator).
*   **N/A**: Not applicable to this industrial/product classification.

---

## 2. Detailed Component Analysis

### 1. RF Power Amplifier (QPA9424)
**Description:** GaN Power Amplifier Module, 10W, 2.4 GHz.

| Standard | Status | Analysis & Constraints |
| :--- | :---: | :--- |
| **RoHS** | **PASS** | Mfg datasheet confirms "Active, RoHS Compliant". GaN on SiC technology is lead-free. |
| **REACH** | **PASS** | No SVHC (Substance of Very High Concern) typically present in the die or packaging of this specific Qorvo module. |
| **FCC Part 15**| **REVIEW** | **Intentional Radiator:** This component generates the fundamental RF energy. <br> • **Rule:** 15.247 requires bandwidth > 500 kHz or power density < 8 dBm in 3 kHz (likely met). <br> • **Limit:** 15.247(b) limits conducted spurious emissions to -20 dBc. <br> • **Risk:** Harmonics must be filtered below general radiated emission limits (Section 15.209) if they interfere. |
| **CE Marking** | **REVIEW** | **EMC Directive 2014/30/EU:** <br> • Must meet EN 55032 (Emissions) for Industrial equipment. <br> • **Risk:** -30 dBc harmonics (Req HW-014) may still be too high for radiated limits if external cabling acts as an antenna. Requires EN 55032 compliance testing on final unit. |

**Recommendation:** The component itself is compliant. The **system design** must ensure the 2nd and 3rd harmonics are attenuated via external filtering to meet FCC/CE spurious emission limits. The -30 dBc harmonic limit (Req HW-014) is a design target, but regulatory limits are often absolute (e.g., -30dBm or field strength). Ensure external LPF is added if harmonics exceed regulatory limits.

---

### 2. TVS Diode (SMBJ33A)
**Description:** 33V Transient Voltage Suppressor.

| Standard | Status | Analysis & Constraints |
| :--- | :---: | :--- |
| **RoHS** | **PASS** | Standard industry status for Vishay/ON Semi SMBJ series (Halogen-free/RoHS). |
| **REACH** | **PASS** | Silicon diodes typically exempt from SVHC declarations. |
| **FCC/CE** | **PASS** | Passive component. Assists compliance by preventing switching noise from the power supply from coupling onto the line. |

---

### 3. Pi-Filter Components (Ferrite & Capacitors)
**Description:** Input filtering for 28V rail.

| Standard | Status | Analysis & Constraints |
| :--- | :---: | :--- |
| **RoHS** | **PASS** | Ferrites (Murata) and Ceramics (Samsung/TDK) are RoHS compliant. **Note:** Verify specific Tantalum capacitor manufacturer date codes to ensure they are not legacy stock containing Lead (Pb) in terminations, though modern AVX/Kemet parts are Pb-free. |
| **REACH** | **PASS** | Passives generally compliant. |
| **FCC/CE** | **PASS** | **Critical for Compliance:** This filter is the primary defense against Conducted Emissions (FCC 15.107 / CISPR 32) on the DC input line. The 470 ohm impedance at 100MHz is well-selected to suppress switching noise from the PA. |

---

### 4. RF Connectors (SMA Edge Launch)
**Description:** 50 Ohm Interface.

| Standard | Status | Analysis & Constraints |
| :--- | :---: | :--- |
| **RoHS** | **PASS** | Gold plating over Nickel; standard RoHS finish. |
| **REACH** | **PASS** | Plated metals generally compliant. |
| **FCC/CE** | **PASS** | **Shielding Requirement:** The connector interface must maintain 360-degree shielding. Ensure the enclosure (heatsink or chassis) makes good electrical contact with the connector shell to prevent RF leakage. |

---

### 5. Heatsink (AAVID 577302B00000G)
**Description:** Aluminum Extrusion.

| Standard | Status | Analysis & Constraints |
| :--- | :---: | :--- |
| **RoHS** | **PASS** | Aluminum is exempt from RoHS, but surface finish (anodizing/passivation) must not contain Cr(VI) (Hexavalent Chromium). "Black anodized" usually implies organic dye, **PASS**. |
| **REACH** | **PASS** | Aluminum alloy compliant. |
| **FCC/CE** | **REVIEW** | **EMC Shielding:** Aluminum heatsinks act as parasitic radiators. This unit must be the ground reference. Ensure the PA module flange is electrically bonded to the heatsink (conductive TIM or direct mount). If using Sil-Pad 1500 (insulating), verify if the PA module needs grounding via a specific tab or if the floatingPA causes common mode noise. |

---

### 6. Thermal Interface Material (Bergquist Sil-Pad 1500)
**Description:** Insulative thermal pad.

| Standard | Status | Analysis & Constraints |
| :--- | :---: | :--- |
| **RoHS** | **PASS** | Silicone rubber/filler construction is RoHS compliant. |
| **REACH** | **PASS** | Compliant. |
| **FCC/CE** | **REVIEW** | **Caution:** Sil-Pad 1500 is **electrically insulating** (6 kV dielectric). This prevents the PA module's metal tab from contacting the grounded heatsink. <br> • **Risk:** A "floating" PA ground plane can lead to instability or increased EMI. <br> • **Recommendation:** Ensure the QPA9424 eval board schematic is followed regarding ground vias. If the PA requires a grounded flange, switch to **Bergquist Hi-Flow** or a thermally conductive graphite pad (electrically conductive). |

**Recommendation:** Verify grounding scheme of QPA9424. If the reference design calls for the flange to be ground, Sil-Pad 1500 creates an open circuit at RF ground potential. Consider electrically conductive TIM.

---

### 7. Enable Pullup Resistor (10k 0805)
**Description:** General SMD resistor.

| Standard | Status | Analysis & Constraints |
| :--- | :---: | :--- |
| **RoHS** | **PASS** | Standard component. |
| **REACH** | **PASS** | Standard component. |

---

## 3. System-Level Risk Items & Recommendations

### High Priority (Design Changes Required)

1.  **EMC / Spurious Emissions (FCC & CE)**
    *   **Concern:** The QPA9424 is a Class C amplifier. It generates significant harmonics (2nd harmonic at 4.8 GHz, 3rd at 7.2 GHz). Requirement HW-014 specifies -30 dBc, which for a 10W (40 dBm) carrier means harmonics are still 10 dBm (10 mW).
    *   **Restriction:** FCC Part 15.247 and EN 55032 generally require emissions to be much lower for non-intentional frequencies (often approaching -40 to -60 dBm equivalent power depending on frequency).
    *   **Recommendation:** A **Low Pass Filter (LPF)** or Band Pass Filter (BPF) *must* be placed between the PA output (QPA9424) and the RF output connector. The provided component list does not include an output filter. Add a 2.4-2.5 GHz bandpass filter with sharp rejection to suppress harmonics to regulatory limits.

2.  **Thermal Interface Grounding**
    *   **Concern:** Selection of Sil-Pad 1500 (Insulating) with a metal-can GaN module (QPA9424).
    *   **Recommendation:** If the QPA9424 datasheet indicates the mounting tab is the source or ground connection, an insulating pad will prevent the heatsink from acting as a heat spreader and RF ground. **Verify datasheet grounding.** If tab is ground, switch to electrically conductive thermal interface (e.g., Cho-Therm or Graphite) to ensure heatsink acts as an RF shield.

### Medium Priority (Verification)

3.  **Input Matching Stability**
    *   **Concern:** The QPA9424 has internal matching, but stability depends on the PCB layout and the PI-filter impedance.
    *   **Recommendation:** Perform a stability analysis (K-factor) in simulation, particularly ensuring the Ferrite bead (BLM18PG471) does not create a resonant tank with the capacitors at low frequencies where the PA gain is high.

### Low Priority (Administrative)

4.  **REACH SVHC Declaration**
    *   **Action:** Request a full REACH SVHC declaration from Qorvo for the QPA9424 to maintain audit trails, as GaN devices can sometimes use exotic materials in the substrate.