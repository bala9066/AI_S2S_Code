# Compliance Validation Report: Project rffff

**Date:** October 26, 2023
**Project:** High-Power RF Transmit System (rffff)
**Standards Evaluated:** RoHS (2011/65/EU), REACH (EC 1907/2006), FCC Part 15 (US), CE Marking (EU), IEC 60601 (Medical - *Not Applicable per design intent*), ISO 26262 (Automotive - *Not Applicable*), MIL-STD (Military - *Not Applicable*).

---

### 1. Executive Summary

The **rffff** project is a high-power (10W), wideband (5-10 GHz) RF transmitter designed for industrial applications. The design poses significant compliance challenges, primarily concerning Electromagnetic Compatibility (EMC) due to the fundamental emission frequency (5-10 GHz) overlapping with restricted bands and the high output power acting as a potential interference source.

**Overall Compliance Status:** **CONDITIONAL PASS**
*Major hurdles exist in FCC/CE certification due to the "Intentional Radiator" nature of the device. Power supply safety isolation and thermal management for the Power Amplifier (PA) are critical safety concerns.*

### 2. Summary Compliance Matrix

| Component | RoHS | REACH | FCC Part 15 | CE Marking | Safety / High Voltage | RF / EMC Risk |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: |
| **XC7A100T-FPGA** | PASS | PASS | PASS | PASS | PASS | LOW |
| **AC/DC Supply (TBD)** | FAIL* | FAIL* | REVIEW | REVIEW | **CRITICAL FAIL** | HIGH |
| **TPS543C20 (FPGA Core)** | PASS | PASS | PASS | PASS | PASS | MED |
| **TPS62913 (FPGA Aux)** | PASS | PASS | PASS | PASS | PASS | MED |
| **LT8650S (RF Rail)** | PASS | PASS | PASS | PASS | PASS | LOW |
| **AD9172 (DAC)** | PASS | PASS | FAIL* | FAIL* | PASS | HIGH |
| **HMC1144 (Mixer)** | PASS | PASS | FAIL* | FAIL* | PASS | HIGH |
| **PA Module (TBD)** | FAIL* | FAIL* | **CRITICAL** | **CRITICAL** | **HAZARD** | **CRITICAL** |
| **ADF5356 (LO)** | PASS | PASS | FAIL* | FAIL* | PASS | HIGH |

*\*TBD items require validation of specific BOM. "Fail" indicates likely lack of certification data or inherent environmental/health hazards associated with the specific technology (e.g., Lead-based die attach in high-power RF).*


---

### 3. Detailed Component Analysis

#### 1. FPGA: Xilinx Artix-7 (XC7A100T-2FGG484I)
*   **RoHS:** **PASS.** Xilinx/AMD Artix-7 devices are fully compliant with EU Directive 2011/65/EU (RoHS 2) and are free from Lead (Pb) in the molding compound and most interconnects.
*   **REACH:** **PASS.** Does not contain Substances of Very High Concern (SVHC) above 0.1% weight by weight.
*   **FCC / CE (EMC):** **PASS.** The component itself is a digital processing element. However, the clock frequencies (DSP slices) will generate harmonics. **Constraint:** The FPGA must not generate clocks > 1.75x the fundamental oscillator frequency to avoid inadvertent radiation below 30MHz (FCC rule), though this is an ASIC-level rule usually managed by the chip vendor.
*   **Specific Concerns:** None. This is the lowest-risk component in the BOM.

#### 2. AC/DC Power Supply (TBD - Isolated 110V AC to 12V DC)
*   **RoHS / REACH:** **REVIEW.** Compliance depends entirely on the final vendor selection (Mean Well vs. TDK-Lambda). Industrial supplies often use Lead-free solder but may have exempted Lead in internal relays or high-capacitance ceramics.
*   **FCC / CE (EMC):** **REVIEW.** This is the primary entry point for conducted emissions.
    *   **Requirement:** The supply must meet EN 55032 / CISPR 32 (Class A Industrial) limits for conducted emissions on the AC mains lines.
    *   **Risk:** A generic supply might generate excessive noise that couples into the sensitive RF chain.
*   **Safety (IEC/UL 62368-1):** **CRITICAL.**
    *   **Requirement:** Since the system runs off 110V AC and outputs 10W RF, the power supply **MUST** be certified to IEC 62368-1 (Audio/Video equipment) or IEC 60950-1. Isolation voltage must be >2500VAC (as stated in requirements) to prevent shock hazards.
*   **Recommendation:** Select a supply with pre-existing CE and UL certifications. Do not use an open-frame supply without additional enclosure shielding.

#### 3. Buck Converter - FPGA Core (TPS543C20RVFT)
*   **RoHS / REACH:** **PASS.** TI parts are standard Green products.
*   **FCC / CE (EMC):** **PASS.** Switching frequency (200kHz - 1.2MHz) is low enough that harmonics are manageable.
*   **Specific Concerns:** **Thermal Derating.** Providing 20A at 1.0V (20W) for the FPGA requires careful PCB layout (copper pour) to remain within the industrial temperature range (-40 to +85°C) at the high end.

#### 4. Buck Converter - FPGA Aux (TPS62913)
*   **RoHS / REACH:** **PASS.**
*   **FCC / CE (EMC):** **PASS.** Similar to the core converter.
*   **Specific Concerns:** **Sequencing.** Improper sequencing of FPGA rails (VCCINT before VCCAUX) can cause latch-up or long-term reliability damage, violating safety intents.

#### 5. Buck Converter - RF Chain (LT8650S)
*   **RoHS / REACH:** **PASS.**
*   **FCC / CE (EMC):** **PASS.** Selected specifically for "Silent Switcher" technology.
*   **Specific Concerns:** **Crucial for RF Performance.** Switching noise from this rail will directly modulate the DAC/Mixer/LO. If this rail is noisy, the device will fail spurious emissions standards regardless of shielding. The LT8650S is an excellent choice here.

#### 6. High-Speed DAC (AD9172)
*   **RoHS / REACH:** **PASS.**
*   **FCC / CE (EMC):** **FAIL (Likely).**
    *   **Issue:** The AD9172 operates at JESD204B rates (up to 12.5 Gbps).
    *   **Constraint:** While the chip itself is compliant, the interface tracks (SerDes lanes) carrying this data act as transmission antennas. The FPGA-to-DAC connection **must** be impedance controlled (100 Ohm differential) and length-matched.
    *   **Risk:** High-speed digital noise coupling into the RF output. This will likely fail CISPR 32 radiated emissions at 1-3GHz harmonics if the board layout is not perfect.
*   **Recommendation:** Implement ground shielding (copper stitch vias) between the DAC digital section and the RF output section.

#### 7. RF Mixer (HMC1144)
*   **RoHS / REACH:** **REVIEW.**
    *   **Concern:** Many high-performance RF mixers and PAs still use **Gold (Au)** or **Lead (Pb)** based eutectic die attach or internal packaging to manage thermal stress and reliability at high frequencies.
    *   **Status:** The HMC1144 is generally RoHS compliant, but check the specific Orderable Part Number (OPN) for the "-E" or "-R" suffix denoting Lead-free.
*   **FCC / CE (EMC):** **FAIL (System Level).**
    *   **Issue:** Mixers generate "spurious" outputs (Intermodulation Products). The HMC1144 takes LO and IF and outputs RF.
    *   **Constraint:** LO leakage at the output must be filtered to < -60dBm to meet FCC Part 15.209 limits if operating in restricted bands.

#### 8. Wideband Power Amplifier (TBD - High Power PA)
*   **RoHS / REACH:** **FAIL (Engineering Review Required).**
    *   **Concern:** High-power GaN (Gallium Nitride) or GaAs amplifiers often utilize **Lead (Pb)**-based solder (Sn/Pb or Au/Ge) for die attach under RoHS exemptions (Annex III categories 7 or 9) due to high operating temperatures and reliability needs.
    *   **Action:** You must check if the industrial application allows for RoHS-exempt components. If "RoHS Compliant" is a strict requirement, you may struggle to find a 10W+ 5-10GHz module that doesn't use exempted materials.
*   **FCC / CE (EMC):** **CRITICAL FAIL.**
    *   **Issue:** 40dBm (10 Watts) is an immense amount of power.
    *   **Compliance:**
        *   **FCC Part 15:** Requires intentional radiators to undergo specific testing (Subpart C).
        *   **Restricted Bands:** 5-10GHz hits radar bands (5.6GHz, 9-10GHz) and WiFi bands (5.8GHz).
        *   **Action:** Unless this device is specifically licensed under Part 5 (Experimental Radio) or Part 101 (Fixed Microwave), **it is illegal to operate this device at 10W continuous power in the US/EU without a specific license.** It cannot be "Certified" for general use under Part 15.
*   **Safety (RF Exposure):**
    *   **Issue:** 10W RF output creates a Specific Absorption Rate (SAR) and Maximum Permissible Exposure (MPE) hazard.
    *   **Requirement:** Requires RF interlocks (auto-shutoff when enclosure opened) to comply with FCC/CE safety codes.

#### 9. Local Oscillator (ADF5356)
*   **RoHS / REACH:** **PASS.**
*   **FCC / CE (EMC):** **FAIL (System Level).**
    *   **Issue:** Phase Noise and Spurs.
    *   **Constraint:** The ADF5356 generates the fundamental frequency. If the PLL loop filter is poorly designed, "fractional spurs" will appear at the RF output. Spurs must be > 60dB below carrier to pass spectral mask requirements.

---

### 4. System-Level Risk & Recommendations

#### Risk Items Requiring Human Review
1.  **Licensing/Regulatory (CRITICAL):**
    *   **Finding:** 40dBm (10W) output is too high for unlicensed operation (FCC Part 15) in the 5-10GHz band.
    *   **Resolution:** Confirm if this device falls under **FCC Part 15 (Subpart C)** requiring a grant of certification, or if it requires an **FCC Part 5 Experimental License**. For CE marking, compliance with **ETSI EN 300 440** (Short Range Devices) or **EN 302 217** (Fixed Satellite/Point-to-Point) is required. 10W is typically restricted to licensed Fixed Microwave services.

2.  **Safety - Isolation (CRITICAL):**
    *   **Finding:** 110V AC input with an external "TBD" supply poses a shock risk.
    *   **Resolution:** The final AC/DC selection **must** have UL/CSA/CE 60950-1 or 62368-1 certification. Do not rely on a generic "brick" without confirming safety file numbers.

3.  **Thermal Management:**
    *   **Finding:** 10W RF output + Class A/B PA inefficiency (typically 20-30% PAE) means ~30-40W of heat generated in the PA stage alone.
    *   **Resolution:** The chassis must be designed as a heatsink. The industrial temp range (-40 to +85C) is difficult to achieve at 10W output without forced air (fan) or significant heatsinking.

#### Recommendations for Non-Compliant Components

1.  **Power Amplifier (TBD):**
    *   **Current:** TBD (Generic High Power).
    *   **Recommendation:** Select a module with integrated harmonic filtering and a built-in RF detector (for safety interlock).
    *   **Specific Part:** Consider the **Qorvo QPA1003** or similar GaN PA module. Ensure the specific vendor SKU is "RoHS 5/6" compliant if strict RoHS is needed, but be prepared to accept an exemption for high-reliability die attach.

2.  **AC/DC Supply:**
    *   **Current:** TBD.
    *   **Recommendation:** Use the **TDK-Lambda CUS200M12** (Medical Grade).
    *   **Rationale:** Medical grade supplies have the lowest leakage current and strictest EMI performance, which will help your high-gain RF system pass emissions testing.

3.  **DAC Interface:**
    *   **Current:** AD9172.
    *   **Recommendation:** Add a **low-pass filter** (LPF) on the clock inputs and JESD204B lanes as close to the FPGA/DAC pins as possible. Use 100-ohm differential impedance control strictly.