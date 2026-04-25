# Compliance Report: Project HV (18-40 GHz Radar Receiver)

**Project Code:** hv
**Compliance Scope:** RoHS, REACH, FCC Part 15, CE Marking, IEC 60601 (Medical), ISO 26262 (Auto), MIL-STD
**Date:** October 26, 2023

---

## 1. Summary Compliance Matrix

| Component | Mfg Part # | RoHS (2011/65/EU) | REACH (EC 1907/2006) | FCC Part 15 | CE Marking | Medical (IEC 60601) | Auto (ISO 26262) | Military (MIL-STD) |
| :--- | :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **Limiter** | HLM-40ABH | **PASS** | **PASS** | **PASS** | **PASS** | N/A | N/A | **FAIL** |
| **BPF** | XM-A163-0204D | **PASS** | **PASS** | **PASS** | **PASS** | N/A | N/A | **FAIL** |
| **LNA** | PMA3-10203+ | **PASS** | **PASS** | **PASS** | **PASS** | N/A | N/A | **FAIL** |
| **Mixer** | SMIQ-1844H+ | **PASS** | **PASS** | **PASS** | **PASS** | N/A | N/A | **FAIL** |
| **IF Amp** | CMD295C4 | **PASS** | **PASS** | **PASS** | **PASS** | N/A | N/A | **FAIL** |
| **PLL LO1** | ADF4108BCPZ | **PASS** | **PASS** | **PASS** | **PASS** | N/A | N/A | **FAIL** |
| **PLL LO2** | LMX2487ESQ | **PASS** | **PASS** | **PASS** | **PASS** | N/A | N/A | **FAIL** |
| **TCXO** | ASGTX-D-100M | **PASS** | **PASS** | **PASS** | **PASS** | N/A | N/A | **FAIL** |
| **ADC** | AD9627ABCPZ | **PASS** | **PASS** | **PASS** | **PASS** | N/A | N/A | **FAIL** |
| **FPGA** | XC7K160T-1FFG | **PASS** | **PASS** | **PASS** | **PASS** | N/A | N/A | **FAIL** |
| **Splitter** | EP2K1+ | **PASS** | **PASS** | **PASS** | **PASS** | N/A | N/A | **FAIL** |
| **LDO** | BD50GA3MEFJ | **PASS** | **PASS** | **REVIEW** | **PASS** | N/A | N/A | **FAIL** |

**Legend:**
*   **PASS:** Meets requirements based on manufacturer specifications.
*   **FAIL:** Does not meet requirements (e.g., Commercial grade vs. Military Temp).
*   **REVIEW:** Requires specific design mitigation (e.g., Filtering).
*   **N/A:** Standard not applicable to the component type or project intent (assumes Commercial Radar).

---

## 2. Detailed Component Analysis

### 1. Limiter: HLM-40ABH (Marki Microwave)
*   **Standard RoHS:** **PASS** (GaAs Schottky diodes are typically RoHS compliant; Marki certifies compliance for standard catalog items).
*   **Standard REACH:** **PASS** (No SVHC concentrations >0.1% typical in Marki bare die assemblies).
*   **Standard FCC:** **PASS** (Passive component, non-emissive).
*   **Standard CE:** **PASS** (Passive component).
*   **Medical (IEC 60601):** N/A.
*   **Auto (ISO 26262):** **FAIL** (Manufacturer lacks AEC-Q100 qualification for this specific high-frequency limiter).
*   **Military (MIL-STD):** **FAIL**.
    *   **Analysis:** The operating temperature requirement is **-55°C to +125°C**. Marki Microwave HLM series data sheets typically specify commercial operating ranges (e.g., -40°C to +85°C or similar) unless specifically ordered as "Hermetic" or "MIL-Space".
    *   **Action:** Verify if the HLM-40ABH is a bare die assembly that can be mounted on a high-reliability substrate. Assuming standard connectorized module or drop-in MMIC, it will fail at -55°C cold start.

### 2. Preselector BPF: XM-A163-0204D (Quantic X-Microwave)
*   **Standard RoHS:** **PASS** (Quantic/X-Microwave modules are RoHS compliant).
*   **Standard REACH:** **PASS**.
*   **Standard FCC:** **PASS** (Passive filtering).
*   **Standard CE:** **PASS**.
*   **Medical (IEC 60601):** N/A.
*   **Auto (ISO 26262):** **FAIL**.
*   **Military (MIL-STD):** **FAIL**.
    *   **Analysis:** X-Microwave evaluation modules are designed for prototyping (Commercial/Industrial). They do not meet MIL-STD-883 thermal shock or vibration standards. The core filter (BFCN-1840+) is also a commercial component.

### 3. LNA: PMA3-10203+ (Mini-Circuits)
*   **Standard RoHS:** **PASS** (Mini-Circuits labels this as RoHS compliant).
*   **Standard REACH:** **PASS**.
*   **Standard FCC:** **PASS** (Non-emissive).
*   **Standard CE:** **PASS**.
*   **Medical (IEC 60601):** N/A.
*   **Auto (ISO 26262):** **FAIL**.
*   **Military (MIL-STD):** **FAIL**.
    *   **Analysis:** Spec sheet lists Commercial operating range.
    *   **Tech Note:** While selected as a "Primary Choice," it covers 12.5-20 GHz. Using it as a "gain block" at 40 GHz is electrically risky (gain will drop significantly, likely < 10 dB, and NF will degrade to > 6 dB). Compliance-wise, it fails the -55°C requirement.

### 4. Mixer: SMIQ-1844H+ (Mini-Circuits)
*   **Standard RoHS:** **PASS**.
*   **Standard REACH:** **PASS**.
*   **Standard FCC:** **PASS**.
*   **Standard CE:** **PASS**.
*   **Medical (IEC 60601):** N/A.
*   **Auto (ISO 26262):** **FAIL**.
*   **Military (MIL-STD):** **FAIL**.
    *   **Analysis:** Standard Commercial grade MMIC mixer.

### 5. IF Amp: CMD295C4 (Qorvo)
*   **Standard RoHS:** **PASS** (Qorvo standard process is lead-free).
*   **Standard REACH:** **PASS**.
*   **Standard FCC:** **PASS**.
*   **Standard CE:** **PASS**.
*   **Medical (IEC 60601):** N/A.
*   **Auto (ISO 26262):** **FAIL**.
*   **Military (MIL-STD):** **FAIL**.
    *   **Analysis:** Standard Commercial/Industrial GaAs MMIC. Fails -55°C start-up requirement.

### 6. PLL LO1: ADF4108 (Analog Devices)
*   **Standard RoHS:** **PASS**.
*   **Standard REACH:** **PASS**.
*   **Standard FCC:** **PASS** (Clock generator).
*   **Standard CE:** **PASS**.
*   **Medical (IEC 60601):** N/A.
*   **Auto (ISO 26262):** **FAIL**.
*   **Military (MIL-STD):** **FAIL**.
    *   **Analysis:** ADF4108 is a commercial PLL. Extended temp versions (-40 to +125) exist, but -55°C operation is not supported by the datasheet electrical specifications.

### 7. PLL LO2: LMX2487 (Texas Instruments)
*   **Standard RoHS:** **PASS**.
*   **Standard REACH:** **PASS**.
*   **Standard FCC:** **PASS**.
*   **Standard CE:** **PASS**.
*   **Medical (IEC 60601):** N/A.
*   **Auto (ISO 26262):** **FAIL** (Not AEC-Q100 qualified).
*   **Military (MIL-STD):** **FAIL**.
    *   **Analysis:** Commercial grade silicon.

### 8. TCXO: ASGTX-D-100M (ABRACON)
*   **Standard RoHS:** **PASS**.
*   **Standard REACH:** **PASS**.
*   **Standard FCC:** **PASS**.
*   **Standard CE:** **PASS**.
*   **Medical (IEC 60601):** N/A.
*   **Auto (ISO 26262):** **FAIL**.
*   **Military (MIL-STD):** **FAIL**.
    *   **Analysis:** The ASGTX series stability (1 ppm) is excellent, but the operating temp range of standard SMD TCXOs is typically -40°C to +85°C. It will not function at -55°C without internal heater power, which stresses the crystal.

### 9. ADC: AD9627 (Analog Devices)
*   **Standard RoHS:** **PASS**.
*   **Standard REACH:** **PASS**.
*   **Standard FCC:** **PASS**.
*   **Standard CE:** **PASS**.
*   **Medical (IEC 60601):** N/A.
*   **Auto (ISO 26262):** **FAIL**.
*   **Military (MIL-STD):** **FAIL**.
    *   **Analysis:** Available in Industrial temp (-40 to +105/125C), but not -55°C.

### 10. FPGA: XC7K160T-1FFG676I (AMD/Xilinx)
*   **Standard RoHS:** **PASS**.
*   **Standard REACH:** **PASS**.
*   **Standard FCC:** **PASS**.
*   **Standard CE:** **PASS**.
*   **Medical (IEC 60601):** N/A.
*   **Auto (ISO 26262):** **FAIL** (Xilinx Kintex-7 is not Automotive qualified like the Automotive (XA) Zynq or Versal series).
*   **Military (MIL-STD):** **FAIL**.
    *   **Analysis:** The part number suffix **"I"** denotes **Industrial** temperature (-40°C to +100°C). This fails the **-55°C** requirement.
    *   **Note:** Xilinx offers "Military" (-55°C to +125°C) FPGAs (e.g., XQR Kintex-7 in ceramic packaging), but the selected specific part number `XC7K160T-1FFG676I` is Industrial grade Plastic BGA.

### 11. Splitter: EP2K1+ (Mini-Circuits)
*   **Standard RoHS:** **PASS**.
*   **Standard REACH:** **PASS**.
*   **Standard FCC:** **PASS**.
*   **Standard CE:** **PASS**.
*   **Medical (IEC 60601):** N/A.
*   **Auto (ISO 26262):** **FAIL**.
*   **Military (MIL-STD):** **FAIL**.
    *   **Analysis:** Commercial grade MMIC.

### 12. LDO Regulator: BD50GA3MEFJ (ROHM)
*   **Standard RoHS:** **PASS**.
*   **Standard REACH:** **PASS**.
*   **Standard FCC:** **REVIEW**.
    *   **Concern:** Switching regulators or noisy LDOs can generate spurious emissions if layout is poor. This is a linear LDO, so risk is low, but the 15V->5V conversion implies significant power dissipation (heat) unless preceded by a buck.
*   **Standard CE:** **PASS**.
*   **Medical (IEC 60601):** N/A.
*   **Auto (ISO 26262):** **FAIL**.
*   **Military (MIL-STD):** **FAIL**.
    *   **Analysis:** The datasheet for BD50GA3MEFJ lists operating ambient temperature as **-40°C to +105°C**. It fails the -55°C requirement.

---

## 3. Critical Risk Items & Recommendations

### Risk 1: Temperature Compliance (MIL-STD / Project Spec)
**Severity:** High
**Analysis:** The design requires **-55°C to +125°C**. Almost every component selected (FPGA, LDO, LNAs, PLLs, ADC) is rated for **Industrial (-40°C to +85/100°C)** or Commercial grade.
*   **Consequence:** The system will likely fail to boot or experience parameter drift (latching, bit errors, gain collapse) at the cold temperature extreme.
*   **Recommendation:**
    1.  **Review Actual Environment:** Is the enclosure heated? If the internal ambient stays > -40°C, the current Industrial grade parts are acceptable.
    2.  **If True -55°C is Required:** You must select **Military-grade** (Class S or B) or **High-Rel Automotive** grade parts.
        *   **FPGA:** Switch to Xilinx/XQR Military grade (e.g., XQR Kintex-7).
        *   **LDO:** Replace with Military-grade DC-DC converter (e.g., VPT, GAIA).
        *   **RF Components:** Source "Hi-Rel" or "883" screened versions from vendors like Qorvo (TriQuint) or Custom MMIC, or be prepared to perform 100% screen testing on commercial parts.

### Risk 2: LNA Frequency Coverage (Performance)
**Severity:** Medium (Design Compliance)
**Analysis:** The PMA3-10203+ is rated 12.5-20 GHz. The project requirement is 18-40 GHz.
*   **Consequence:** At 40 GHz, this LNA will likely provide very little gain (perhaps 3-6 dB) and poor noise figure (>5-6 dB), failing the system NF and Gain requirements.
*   **Recommendation:** Replace with a broadband MMIC LNA covering DC to 40+ GHz (e.g., Custom MMIC CMD179 or similar broadband pHEMT).

### Risk 3: LDO Input Voltage Constraint
**Severity:** Medium
**Analysis:** The BD50GA3MEFJ has an absolute max input voltage of 14V. The supply is 15V.
*   **Consequence:** The LDO will be destroyed at power-up.
*   **Recommendation:** Add a pre-regulator (Buck converter) to step 15V down to ~7-9V before the LDO, or select a high-voltage LDO (e.g., ROHM BD7xx series or LT Linear Regs) rated for >20V input.

### Risk 4: Radiated Emissions (FCC/CE)
**Severity:** Low (Mitigatable)
**Analysis:** The system operates at 18-40 GHz (Ka-Band). While these are intentional radiators (via Antenna), the digital section (FPGA, ADC LVDS @ 150 MSPS) running at 125-150 MHz fundamental frequencies can generate harmonics into the 1-6 GHz range.
*   **Recommendation:** Ensure strict LVDS impedance matching and use ground planes under the ADC-FPGA link. The switching pre-regulator (if added) must be shielded to prevent switching noise from coupling into the sensitive 3.1 GHz or 500 MHz IF stages.