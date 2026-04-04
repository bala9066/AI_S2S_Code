# Compliance Report: fjxm 200W Industrial Power Supply

**Project:** fjxm  
**Date:** October 26, 2023  
**Compliance Expert:** Regulatory Audit System  
**Standard Scope:** RoHS, REACH, FCC/CE (EMC), MIL-STD (Environmental/EMI), IEC 60950-1 (Safety)

---

## 1. Executive Summary

The design utilizes high-performance components primarily suited for Industrial and Automotive grades. While the selected components offer excellent electrical performance, there are **critical compliance gaps** regarding **RoHS** (Restriction of Hazardous Substances) and **REACH** authorization.

**Major Findings:**
1.  **Lead (Pb) Exemptions:** The design relies on high-temperature, high-reliability components (HTSSOP, DirectFET, Certain Ceramics) that inherently use lead (Pb) in terminations or die attach.
2.  **SVHC Authorization:** The **Wolfspeed SiC MOSFET (C3M0065090D)** utilizes Silicon Carbide, a substance flagged in recent REACH updates (Authorization List). This presents a supply chain risk.
3.  **MIL-STD vs. COTS:** While military performance standards (temp range) are met by the silicon, most selected parts are Commercial-Off-The-Shelf (COTS) and lack **MIL-PRF-38535** (Class V) or **QML** certification, requiring DSCC (Defense Supply Center) drawing numbers for formal military qualification.

---

## 2. Summary Compliance Matrix

| Component | Status | RoHS 2011/65/EU | REACH (EC 1907/2006) | FCC / CE (EMC) | MIL-STD-883 / 461 |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **UCC28951A** (PWM Ctrl) | ⚠️ REVIEW | **FAIL** (Exempt 7c-I) | PASS | PASS | PASS (Perf) / FAIL (Qual) |
| **C3M0065090D** (SiC FET) | ⚠️ REVIEW | PASS | **FAIL** (SVHC Auth) | PASS | PASS (Perf) / FAIL (Qual) |
| **IRF7749L2PBF** (Sync FET) | ⚠️ REVIEW | **FAIL** (Exempt 7c-I) | PASS | PASS | PASS (Perf) / FAIL (Qual) |
| **LT3086** (12V LDO) | PASS | PASS | PASS | PASS | PASS (Perf) |
| **LT3045-50** (5V LDO) | PASS | PASS | PASS | PASS | PASS (Perf) |
| **LT3042-3.3** (3.3V LDO) | PASS | PASS | PASS | PASS | PASS (Perf) |
| **UCC27714** (Gate Driver) | ⚠️ REVIEW | **FAIL** (Exempt 7c-I) | PASS | PASS | PASS (Perf) / FAIL (Qual) |
| **Transformer** (Custom) | ⚠️ REVIEW | **FAIL** (Exempt 7c-I) | PASS | PASS | ⚠️ REVIEW |
| **HCPL-3700** (Opto) | ⚠️ REVIEW | **FAIL** (Exempt 7c-I) | PASS | PASS | ⚠️ REVIEW |
| **CM Choke** (Coilcraft) | PASS | PASS | PASS | PASS | PASS (Perf) |
| **EEV-FK1H101P** (Cap) | ⚠️ REVIEW | **FAIL** (Exempt 7c-I) | PASS | PASS | ⚠️ REVIEW |
| **C1210C106M4P** (Ceramic) | ⚠️ REVIEW | **FAIL** (Exempt 7c-I) | PASS | PASS | PASS |

> **Legend:** PASS = Compliant; FAIL = Non-Compliant (or requires specific exemption declaration); REVIEW = Qualification/Status dependent on specific batch/manufacturer.

---

## 3. Detailed Component Analysis

### 1. UCC28951A (Primary PWM Controller)
*   **RoHS Status:** **FAIL (Exempt)**. The HTSSOP-24 package with thermal dissipation requirements typically uses high-temperature lead-based solder plating or die-attach. This falls under **Annex III Category 7(c)-I**: Lead in solder for servers, storage, and storage array systems, or network infrastructure equipment. *Assumption: Industrial automation qualifies as infrastructure equipment.*
*   **REACH Status:** **PASS**. Standard silicon BOM.
*   **MIL-STD:** **Performance PASS**. Operating range (-55°C to +150°C) exceeds MIL-STD-883.
*   **Concern:** For true Military procurement (QML), this COTS part is not technically qualified.

### 2. C3M0065090D (Wolfspeed SiC MOSFET)
*   **RoHS Status:** **PASS**. SiC devices are generally RoHS compliant (Pb-free finish).
*   **REACH Status:** **FAIL (Authorization Required)**. Silicon Carbide (SVHC group: Inorganic Cohesive Substances) is subject to strict authorization limits (日落条款) as of recent ECHA rulings. Continued use requires explicit ECHA authorization which may be denied or expire.
*   **MIL-STD:** **Performance PASS**. High temperature rating suits MIL-STD-883.
*   **Recommendation:** Assess supply chain risk regarding SiC authorization.

### 3. IRF7749L2PBF (Infineon DirectFET)
*   **RoHS Status:** **FAIL (Exempt)**. DirectFET cans often utilize high-temperature solder alloys containing Lead or Cadmium to withstand reflow and automotive soldering profiles. Falls under exemption 7(c)-I or 8(b).
*   **REACH Status:** **PASS**.
*   **Safety (IEC 60950-1):** **Review Creepage/Clearance**. The DirectFET metal can is a conductive surface on the component top. The PCB layout must maintain creepage/clearance distances (Req-HW-007: 1500VDC) to any nearby traces or heatsinks.

### 4. LT3086 / LT3045 / LT3042 (Linear Regulators)
*   **Compliance:** These Analog Devices parts are generally **RoHS Compliant** (Green packages) and **REACH Compliant**.
*   **Medical (IEC 60601):** The LT3086 offers low noise suitable for medical applications, but the **creepage/clearance** on the LQFP-52 package must be verified against 250VAC (MOPP) requirements if used in a medical end-product. Since this is an industrial supply, this is for reference only.

### 5. UCC27714 (Gate Driver)
*   **RoHS Status:** **FAIL (Exempt)**. High-voltage drivers often use specific die-attach compounds under exemption 7(c)-I or 6(c).

### 6. CUSTOM_MULTIWIND_200W (Transformer)
*   **RoHS Status:** **FAIL (Exempt)**. The magnet wire insulation and potting compounds are high-temperature systems. **IEC 60950-1** requires 1500VDC isolation. This often mandates high-grade insulation that historically relies on substances restricted by RoHS. It falls under **Annex III 7(a)**: Lead in glass in files and cermet.
*   **MIL-STD-461:** The construction must utilize a **toroidal or shielded bobbin** to contain magnetic flux (preventing RE102 failures). The user specification "Custom" does not guarantee a shielded can.
*   **Recommendation:** Specify **Nanocrystalline** or high-permeability ferrite core with a **flux band** or full copper shield can.

### 7. HCPL-3700 (Optocoupler)
*   **RoHS Status:** **FAIL (Exempt)**. Optocouplers utilizing internal lead-based solder die attach are common. Exempt under 7(c)-I.
*   **Concern:** Ensure the "MIL-STD qualified version" mentioned in Rationale corresponds to the DSCC drawing number (e.g., 5962-xxxxxxx). The commercial HCPL-3700 is **NOT** MIL-PRF-38534 qualified by default.

### 8. CMD12-101-501 (CM Choke)
*   **RoHS Status:** **PASS**. Coilcraft modern surface mount parts are generally RoHS compliant.
*   **EMC:** **CRITICAL for MIL-STD-461G**.
    *   **CE102:** The selected 50uH inductance is suitable, but ensure the core material does not saturate at 12A DC bias (if any exists on the line) or the fundamental switching frequency (300kHz).
    *   **RE102:** The windings must be symmetrical to minimize stray magnetic fields.

### 9. EEV-FK1H101P (Panasonic Polymer Cap)
*   **RoHS Status:** **FAIL (Exempt)**. Conductive polymer capacitors often use Lead (Pb) in the terminal electrodes for solderability stress relief. Exempt under 7(c)-I.
*   **Lifecycle:** Panasonic "FK" series industrial grade offers the 10-year life required.

### 10. C1210C106M4PACTU (KEMET Ceramic)
*   **RoHS Status:** **FAIL (Exempt)**. High-voltage (100V) X7R capacitors often use Lead-based barrier layers in the ceramic dielectric or electrode terminations. Exempt under 7(a) or 8(b).

---

## 4. Critical Risk Items & Recommendations

### A. REACH Compliance (SiC)
**Risk:** The **C3M0065090D** utilizes Silicon Carbide.
*   **Action:** Verify if the specific Wolfspeed die has been granted an Authorization by the ECHA. If not, this part effectively cannot be legally sold in the EU after the "Sunset Date" without renewal.
*   **Alternative:** Consider replacing with a **GaN (Gallium Nitride)** device (e.g., GS-065) or a high-performance Silicon SuperJunction MOSFET (e.g., Infineon CoolMOS P7/C7 series) which are generally REACH compliant, though SiC is preferred for high-temperature MIL-STD environments.

### B. PCB Layout & Isolation (Req-HW-007: 1500VDC)
**Risk:** The use of **DirectFET (IRF7749L2PBF)** and **TO-247** packages.
*   **Action:** The DirectFET metal can is "live" at the Drain voltage. On a 48V input (boosted to ~60V+ during transients), standard creepage is not an issue. However, for the **1500VDC isolation** requirement:
    *   Ensure the transformer secondary side components (including the DirectFETs) maintain sufficient spacing from the primary side heatsink (if shared) or traces.
    *   **Slotting:** The PCB under the transformer must be slotted (milled out) to maintain the 1500V creepage path.

### C. MIL-STD Qualification vs. Performance
**Risk:** The components listed are "High Reliability" or "Automotive" grade, but they are **not** MIL-SPEC (QPL) parts.
*   **Action:** If this project requires formal military certification (e.g., for a US DoD contract), you must source components with **SMD** (Standard Microcircuit Drawing) numbers.
    *   *Example:* Instead of the commercial UCC28951A, you would need a part like the **UCC28951A-SP** (Texas Instruments Space/Hi-Rel equivalent) or a DSCC approved equivalent.
    *   **Current Selection Risk:** Using COTS parts in a "MIL-STD" environment requires a **Waiver** and severe **Up-Screening** (burn-in and temp cycling) at your facility.

### D. Paralleling LT3045 for 8A
**Risk:** The selection rationale suggests paralleling LT3045-50 (500mA) to achieve 8A.
*   **Technical Concern:** Paralleling 16x LT3045s is highly inefficient layout-wise and introduces current sharing instability risks.
*   **Recommendation:** Re-evaluate this choice. Use a dedicated high-current controller or switch to the **LT3086** (also used for the 12V rail, or the LT3080 variant) for the 5V rail. A single **LT3083** (3A) paralleled 3x is more realistic than 16x 500mA parts.

---

## 5. Final Verdict

| Category | Verdict |
| :--- | :--- |
| **RoHS** | **Non-Compliant** (Relies on Exemptions 7c-I, 8b). Acceptable for Industrial Infrastructure. |
| **REACH** | **Non-Compliant** (SiC component). |
| **FCC / CE** | **Likely Pass** (Subject to EMC testing of final unit). |
| **MIL-STD** | **Performance Compliant** (Electrical specs match). **Qualification Non-Compliant** (Components are COTS, not QML). |