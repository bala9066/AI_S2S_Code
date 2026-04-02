# Compliance Report: Project "fug" (10 kW BLDC Controller)

**Project:** fug
**Date:** 2023-10-27
**Compliance Engineer:** AI Regulatory Expert
**Applicability:**
*   **Consumer/Industrial:** RoHS, REACH, CE (EMC/LVD), FCC
*   **Automotive:** ISO 26262 (Design Process/ASIL - *Recommended for EV*)
*   **Safety:** IEC 60730 (Class B - *Required*)

---

## 1. Executive Summary

The design utilizes industrial-grade components largely suitable for the intended 48V EV environment. The primary compliance risks involve the **Isolation Barriers** (Safety/IEC 60664) and **Supply Chain Traceability** required for automotive (ISO 26262) and medical standards (if applied later).

**Overall Status:**
*   **RoHS / REACH:** PASS (Based on standard SMD/Lead-free status of modern semis).
*   **FCC / CE (EMC):** REVIEW (Dependent on PCB layout and shielding; 20 kHz switching is a noise source).
*   **Safety (IEC 60730):** PASS (STM32 + AMC1200 support requirements).
*   **Automotive (ISO 26262):** REVIEW (BSC078N12NS3G is automotive qualified, but IR2101/AMC1200/Mornsun are Industrial grade).

---

## 2. Summary Compliance Matrix

| Component | Mfg | RoHS / REACH | FCC / CE (EMC) | IEC 60664-1 (Isolation) | IEC 60730 (Class B) | ISO 26262 (Auto) | Comments |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **STM32F407VGT6** | STMicro | **PASS** | **PASS** | N/A | **PASS** | **FAIL** | Industrial grade; lacks AEC-Q100. |
| **BSC078N12NS3G** | Infineon | **PASS** | **PASS** | N/A | N/A | **PASS** | Automotive qualified (AEC-Q101). |
| **IR2101** | Infineon | **PASS** | **REVIEW** | N/A | N/A | **FAIL** | Legacy industrial part; lacks Auto diagnostics. |
| **AMC1200** | TI | **PASS** | **PASS** | **FAIL*** | **PASS** | **FAIL** | Isolation rating insufficient for EV reinforced insulation. |
| **B0505S-1WR3** | Mornsun | **PASS** | **REVIEW** | **FAIL*** | N/A | **FAIL** | 1.5kV isolation is too low for 48V EV safety standards. |
| **ESL261RAN...** | UCC | **PASS** | **PASS** | N/A | N/A | **REVIEW** | Electrolytic life is a reliability limiter. |

---

## 3. Detailed Component Analysis

### 1. Main MCU: STM32F407VGT6

*   **RoHS / REACH:**
    *   **Status:** PASS
    *   **Detail:** STMicroelectronics modern microcontrollers are compliant with EU Directive 2011/65/EU (RoHS 2) and do not use Substances of Very High Concern (SVHC) above threshold limits in standard plastic packaging.
*   **FCC / CE (EMC):**
    *   **Status:** PASS
    *   **Detail:** The internal clock management allows for spread spectrum clocking (SSC) to reduce EMI, aiding FCC Part 15 compliance.
*   **IEC 60730 (Class B):**
    *   **Status:** PASS
    *   **Detail:** ST provides certified IEC 60730-1 Class B software libraries (STM32 SafeTS), covering Watchdog, Clock Monitor, and Flash memory tests as required by REQ-HW-009.
*   **ISO 26262 (Automotive):**
    *   **Status:** FAIL
    *   **Detail:** The STM32F407 is an "General Purpose" MCU. It is **not** AEC-Q100 qualified. Using this in a production EV requires rigorous safety validation (ASIL calculation) that the part itself does not support natively.

### 2. MOSFET Power Stage: BSC078N12NS3G

*   **RoHS / REACH:**
    *   **Status:** PASS
    *   **Detail:** Infineon OptiMOS 3 generation is lead-free and RoHS compliant.
*   **Automotive (ISO 26262):**
    *   **Status:** PASS
    *   **Detail:** This specific part number indicates "Automotive Grade" qualification (usually AEC-Q101). It supports the temperature range (-55 to +175°C) required for under-hood applications.
*   **FCC / CE (EMC):**
    *   **Status:** REVIEW
    *   **Detail:** While the component is compliant, the high di/dt (250A in <100ns) creates significant EMI. Gate resistance ($R_g$) tuning is critical here to meet EMC standards.

### 3. Gate Driver: IR2101

*   **RoHS / REACH:**
    *   **Status:** PASS
    *   **Detail:** Standard RoHS compliant IC.
*   **IEC 60730:**
    *   **Status:** REVIEW
    *   **Detail:** Lacks integrated diagnostic feedback (e.g., desaturation detection). REQ-HW-010 (Overcurrent) requires external fast shunt comparators (which are listed), so this is acceptable but relies on external design.
*   **ISO 26262:**
    *   **Status:** FAIL
    *   **Detail:** This is a legacy industrial driver. It lacks the safety metrics (FIT rate data, ASC - Automotive Safety Catalog) required for ISO 26262 documentation.

### 4. Isolated Amplifier: AMC1200

*   **RoHS / REACH:**
    *   **Status:** PASS
    *   **Detail:** Compliant.
*   **IEC 60664-1 (Isolation):**
    *   **Status:** **FAIL** (Safety Critical)
    *   **Detail:**
        *   **Requirement:** For a 48V EV system connected to a mains-charged battery (or considered "floating"), Reinforced Isolation is standard.
        *   **Spec:** The AMC1200 has a working voltage of 4000Vpk but only **3 kVrms** isolation for 1 minute (basic).
        *   **Risk:** In an EV fault scenario (transient surge), 3kVrms is marginal. Modern EV designs typically require **5 kVrms** reinforced isolation ratings (e.g., AMC1201 or AMC1301).
*   **Accuracy:**
    *   **Status:** PASS
    *   **Detail:** ±3% accuracy satisfies REQ-HW-006 (±2%) marginally if calibration is used, but note that ±3% is at 25°C; drift over -40°C to +85°C might exceed 2%.

### 5. Isolated DC-DC: B0505S-1WR3

*   **RoHS / REACH:**
    *   **Status:** PASS
    *   **Detail:** Compliant.
*   **IEC 60664-1 (Isolation):**
    *   **Status:** **FAIL** (Safety Critical)
    *   **Detail:**
        *   **Spec:** 1.5 kVDC isolation.
        *   **Requirement:** For 60V DC bus systems, IEC 60664-1 suggests pollution degree 2, overvoltage category II, which requires significantly higher clearance/creepage and isolation voltage (typically >3.7 kVDC for reinforced).
        *   **Risk:** This converter is likely underspecified for the isolation barrier of the high-side gate driver supply in an automotive context.

### 6. DC Link Capacitor: ESL261RAN1020M3B0

*   **RoHS / REACH:**
    *   **Status:** PASS
    *   **Detail:** United Chemi-Con parts are RoHS compliant.
*   **Automotive Reliability:**
    *   **Status:** REVIEW
    *   **Detail:**
        *   **Lifetime:** 2000 hours at 105°C.
        *   **Analysis:** If the ambient is 85°C (REQ-HW-001) and there is self-heating (10-15°C rise), the capacitor runs near 100°C.
        *   **Failure Mechanism:** The Arrhenius equation predicts rapid lifespan degradation. At 100°C, life is approx 4000 hours (~6 months). This is insufficient for a commercial EV.
        *   **Correction Needed:** User must derate significantly or use a "High Temp" automotive grade (e.g., 105°C rating but 5000-10000 hrs base life).

---

## 4. Risk Items & Engineering Review

1.  **Isolation Barrier Coordination (High Risk):**
    *   **Issue:** The AMC1200 (3kV) and B0505S (1.5kV) isolation ratings do not align. Creepage and clearance on the PCB must be designed for the *lowest* rated component in the barrier.
    *   **Action:** Upgrade the DC-DC converter to match the isolation of the amplifier (or vice versa). For EV safety, aim for **5kV reinforced** across the board.

2.  **Capacitor End-of-Life (Medium Risk):**
    *   **Issue:** The selected electrolytic capacitor will fail prematurely if operated at 85°C ambient + Ripple heating.
    *   **Action:** Calculate temperature rise: $\Delta T \approx (I_{ripple}^2 \times ESR) / (Surface Area)$. If $\Delta T > 10°C$, you must select a capacitor with higher voltage rating (derating) or higher lifetime spec (e.g., 3000+ hrs at 105°C).

3.  **FCC/EMC Filter Strategy (Medium Risk):**
    *   **Issue:** The inputs (PWM Throttle, Hall Sensors) act as antennas for the 20 kHz switching noise.
    *   **Action:** Ensure RC filtering or ferrite beads are placed on all input lines immediately at the connector.

---

## 5. Recommendations for Non-Compliant Components

### 1. Replace Gate Driver Power Supply (B0505S-1WR3)
*   **Reason:** 1.5kV isolation fails safety requirements for 48V EV reinforced insulation.
*   **Recommended Alternative:** **Mornsun B0505S-1WR3** -> **Mornsun B0505XT-1WR3** or **CRE1S0505SC**
    *   **Target Spec:** 5 kVDC isolation or 3.75 kVAC reinforced.
    *   *Alternative:* **MEJ1S0512SC** (Murata) for higher automotive grade reliability.

### 2. Replace Isolated Amplifier (AMC1200)
*   **Reason:** 3kVrms is borderline; automotive trends require reinforced isolation (5kV). Also accuracy budget is tight.
*   **Recommended Alternative:** **AMC1200** -> **AMC1301** or **AMC1311**
    *   **Benefit:** 7 kV peak isolation, higher CMRR, better accuracy drift performance over temperature.

### 3. DC-DC Capacitor Reliability Update
*   **Reason:** Lifetime risk at 85°C ambient.
*   **Recommendation:** Select a part with "Automotive Grade" or "High Ripple" / "Long Life" specification.
    *   **Alternative:** **Panasonic EEU-FR1V102** (Listed in user docs as alternative, recommended as primary). It typically has better lifetime specs. Or **United Chemi-Con EKX** series.

### 4. MCU Qualification (If Automotive)
*   **Reason:** STM32F407 is not AEC-Q100.
*   **Recommendation:** If this vehicle requires OEM homologation, switch to **STM32G4** series (Auto-Grade) or **TC3xx (AURIX)**. For hobby/conversion, STM32F407 is acceptable with a disclaimer.