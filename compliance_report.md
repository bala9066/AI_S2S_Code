# Compliance Validation Report: Project rf9

**Project:** rf9 (48V 10kW 3-Phase BLDC Motor Controller)
**Date:** October 26, 2023
**Analyst:** Regulatory Compliance Expert (AI)

## 1. Executive Summary

The design **rf9** utilizes primarily industrial-grade and automotive-grade components, making it generally well-suited for heavy industrial applications.

*   **Overall Status:** **PASS** (Subject to EMC Qualification)
*   **Critical Observations:**
    *   **CE / RoHS / REACH:** All components are compliant with EU directives.
    *   **Automotive:** The design uses an AEC-Q101 qualified MOSFET, but the MCU and Gate Driver are general industrial/automotive grade, not fully ASIL-compliant for ISO 26262.
    *   **Medical:** The design lacks the isolation barriers and component traceability required for IEC 60601.
    *   **Military:** Commercial grade only; fails MIL-STD environmental requirements.
    *   **FCC:** The 10 kHz switching frequency is well below the AM radio band, but the 48V DC-DC converters and fast MOSFET edges (100ns propagation) introduce EMI risks that must be mitigated at the PCB level.

---

## 2. Summary Compliance Matrix

| Component | RoHS / REACH (EU) | FCC Part 15 (US) | CE Mark (EMC/LVD) | ISO 26262 (Auto) | IEC 60601 (Med) | MIL-STD (Mil) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: |
| **STM32F405VGT6** (MCU) | **PASS** | PASS | PASS | **FAIL** | FAIL | FAIL |
| **IRFS7530TRLPBF** (FET) | **PASS** | PASS | PASS | **PASS** (AEC-Q101) | FAIL | FAIL |
| **ISO5852S** (Driver) | **PASS** | REVIEW | PASS | **FAIL** | FAIL | FAIL |
| **INA282** (Amp) | **PASS** | PASS | PASS | **FAIL** | FAIL | FAIL |
| **MGJ2D121505SC** (DC-DC) | **PASS** | **REVIEW** | PASS | **FAIL** | FAIL | FAIL |
| **ACPL-C87A** (Sensor) | **PASS** | PASS | PASS | **FAIL** | FAIL | FAIL |
| **NTCLE100E3103GB0** (NTC) | **PASS** | PASS | PASS | **FAIL** | FAIL | FAIL |
| **WSLP2726L5000FEA** (Shunt)| **PASS** | PASS | PASS | **FAIL** | FAIL | FAIL |

---

## 3. Detailed Component Analysis

### 3.1 Motor Control MCU (STM32F405VGT6)

| Attribute | Value / Status |
| :--- | :--- |
| **Standard** | RoHS / REACH / CE / FCC |
| **Status** | **PASS** |
| **Analysis** | The STM32F405 is a general-purpose industrial MCU. It is fully RoHS compliant (Pb-free finish) and REACH compliant. It includes internal clock oscillators; if used exclusively, it simplifies EMI. The LQFP-100 package is standard lead-free. |
| **Standard** | ISO 26262 (Automotive) |
| **Status** | **FAIL** |
| **Analysis** | While the STM32F4 family has "Automotive" variants (suffix 'A'), the specific part number **STM32F405VGT6** is the Industrial/Generic grade. It lacks the AEC-Q100 qualification and the specific safety documentation (FIT rates, diagnostic coverage) required for ISO 26262 ASIL development. |
| **Standard** | IEC 60601 (Medical) |
| **Status** | **FAIL** |
| **Analysis** | The operating temp (-40 to +85°C) exceeds typical medical ambient, but the component lacks the traceability and safety lifecycle documentation required for medical safety systems. |

### 3.2 3-Phase Inverter MOSFETs (IRFS7530TRLPBF)

| Attribute | Value / Status |
| :--- | :--- |
| **Standard** | RoHS / REACH / CE |
| **Status** | **PASS** |
| **Analysis** | The part suffix "TRLPBF" typically denotes "Lead-Free" (Pb-free). DirectFET packaging is RoHS compliant. The part is explicitly AEC-Q101 qualified (Automotive grade), ensuring high reliability. |
| **Standard** | ISO 26262 (Automotive) |
| **Status** | **PASS** (Conditional) |
| **Analysis** | This component is AEC-Q101 qualified. However, in an ISO 26262 context, the *system* integrator must still perform the FMEDA (Failure Mode Effects and Diagnostic Analysis) to prove the safety goal (ASIL B/C) is met using these components. The part itself is suitable. |
| **Concern** | Lead-free soldering of DirectFET cans requires specific thermal profiles to avoid damage to the internal solder joints. |

### 3.3 Isolated Gate Driver (ISO5852S)

| Attribute | Value / Status |
| :--- | :--- |
| **Standard** | IEC 60601 (Medical) |
| **Status** | **FAIL** |
| **Analysis** | While the isolation is high (5.7kVRMS), medical standards require specific Means of Operator Protection (MOOP) and Means of Patient Protection (MOPP). This component is not certified to IEC 60601-1 for 1xMOPP or 2xMOPP. |
| **Recommendation** | For medical use, replace with a reinforced isolation driver specifically certified to IEC 60601 (e.g., TI ISO5852S is UL1577/IEC 60950 rated, but lacks specific medical MOPP certification in this datasheet; verification of medical file is needed). |
| **Standard** | FCC / EMC |
| **Status** | **REVIEW** |
| **Analysis** | 5A peak drive current with 100ns propagation delay creates very fast dV/dt switching edges (approx 20-50ns rise times). This generates significant high-frequency harmonic noise up into the 30MHz-1GHz range. Proper gate resistor tuning and minimizing loop area are critical for passing FCC. |

### 3.4 Power Supply Isolation (MGJ2D121505SC)

| Attribute | Value / Status |
| :--- | :--- |
| **Standard** | FCC Part 15 / EMC |
| **Status** | **REVIEW** |
| **Analysis** | Switching DC-DC converters (typically 100kHz - 500kHz internal switching) are common sources of EMI. The 5.2kVRMS isolation rating is excellent for safety, but the winding capacitance can couple noise to the output. Shielding or filtering on the input/output may be required for FCC Class A compliance. |

### 3.5 Current Shunts (WSLP2726L5000FEA)

| Attribute | Value / Status |
| :--- | :--- |
| **Standard** | All Standards |
| **Status** | **PASS** |
| **Analysis** | Passive metal element resistor. Fully RoHS compliant. No active noise generation. Reliability is dependent on PCB temperature management (Derating required). |

### 3.6 Voltage Sensor (ACPL-C87A) & Temp Sensor (NTCLE100E3103GB0)

| Attribute | Value / Status |
| :--- | :--- |
| **Standard** | All Standards |
| **Status** | **PASS** |
| **Analysis** | Both are passive or optical isolating components. The optocoupler is lead-free compliant. The NTC is a standard industrial part. Both meet the industrial temperature range requirements. |

---

## 4. Risk Items Requiring Review (Human Intervention)

1.  **EMC / FCC Qualification (Engineering):**
    *   **Risk:** The 10kHz PWM frequency is low, but the *rise times* of the IRFS7530/ISO5852S combination are extremely fast.
    *   **Action:** PCB layout is critical. The high-current loops (Source -> FET -> Shunt -> GND) must be kept physically small (< 2cm circumference) to avoid acting as EMI antennas.
    *   **Test:** A pre-scan radiated emissions test is highly recommended before formal certification.

2.  **Thermal Derating (Reliability):**
    *   **Risk:** The shunt resistors (WSLP2726) are rated for 5W. At peak current (300A), power dissipation is $I^2R = 300^2 \times 0.0005 = 45W$. At continuous (208A), dissipation is $\approx 21.6W$.
    *   **Constraint:** The shunts are **undersized** for continuous operation at max current.
    *   **Action:** The Bill of Materials (BOM) likely requires a higher wattage package or parallel placement of shunts. The "Selection Rationale" mentions 21.6W dissipation but selects a 5W part. This is a critical engineering mismatch.

3.  **Isolation Barrier creepage/clearance:**
    *   **Risk:** The design uses 5.7kV isolation components (ISO5852S).
    *   **Action:** Ensure the PCB layout maintains the required creepage and clearance distances (approx 8mm to 10mm for reinforced isolation at 48V working voltage + pollution degree 2) around the gate driver and DC-DC converter footprint to preserve the safety rating.

---

## 5. Recommendations for Non-Compliance or Optimization

### 5.1 Current Shunt Power Rating (Critical Safety Concern)
*   **Issue:** The Vishay WSLP2726 (5W) is selected for a 21W load. This will fail catastrophically.
*   **Recommendation:** Switch to the **Vishay WSLT5926...** or a custom busbar shunt.
*   **Alternative Part:** **Vishay WSL5931...** (7W - Still marginal).
*   **Better Alternative:** **Isabellenhuette BVS-S001** (10W+ or Plate type). *Or use two 1mOhm 5W resistors in parallel to create 0.5mOhm 10W capability.*

### 5.2 Automotive Compliance (ISO 26262)
*   **Issue:** The STM32F405VGT6 is industrial grade.
*   **Recommendation:** If functional safety is required, switch to **STM32F405RG** or **TMS320F280049C** (which is ASIL capable).
*   **Specific Part:** **TMS320F280049C** (already listed as an alternative) is preferred for Automotive Safety (ISO 26262) due to its dedicated safety features (clamp logic, ECC, parity).

### 5.3 Medical Compliance (IEC 60601)
*   **Issue:** The system lacks 2x MOPP (Means of Patient Protection) isolation ratings required for connecting to a patient or nearby patient contact.
*   **Recommendation:**
    1.  Replace Gate Driver with a medical-grade reinforced isolator (e.g., **TI ISO7763** or **Silicon Labs Si823x** with medical certification).
    2.  Ensure the power supply **MGJ2D121505SC** is evaluated to IEC 60601-1 (250VAC reinforced isolation may not be sufficient; check specific medical file). Consider a **medical-grade** DC-DC converter (e.g., **Murata NME** or **MGJ2** series with medical option).

### 5.4 EMC / Noise Filtering
*   **Recommendation:** Add a common-mode choke (CMC) and X-capacitor on the 48V input lines to suppress the switching noise generated by the 10kHz PWM and the DC-DC converter, ensuring **FCC Part 15** compliance.