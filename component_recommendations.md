# Component Recommendations
## fjxm

### 1. Primary PWM Controller for multi-output forward converter

**Primary Choice:** UCC28951A (Texas Instruments)

*Active clamp controller for high efficiency, supports synchronous rectification, current mode control, 200-300kHz operation.*

| Spec | Value |
|---|---|
| Input Range | Up to 100V |
| Switching Freq | 100kHz-1MHz |
| Features | Active clamp, sync rect, UVLO, OVP |
| Temp Range | -55°C to +150°C |
| Package | HTSSOP-24 |

**Alternatives:**
- **ISL6752** (Renesas/Intersil): ZVS full-bridge controller, higher cost but better efficiency at high power
- **LT8309** (Analog Devices): Simpler forward controller, fewer features but easier implementation

**Selection Rationale:** UCC28951A chosen for active clamp topology (reduces switching losses), excellent for 200W level, robust industrial temp range, integrated protection features needed for MIL-STD compliance.

### 2. 48V primary side MOSFET switch

**Primary Choice:** C3M0065090D (Wolfspeed)

*650V SiC MOSFET with 90mOhm Rds(on), optimized for high efficiency high frequency switching.*

| Spec | Value |
|---|---|
| Vds | 650V |
| Id | 36A |
| Rds(on) | 90mOhm |
| Qg | 44nC |
| Package | TO-247-3L |

**Alternatives:**
- **IPP60R099CPA** (Infineon): 600V CoolMOS, lower cost but higher Rds(on)
- **FDP047N10** (ON Semiconductor): 100V MOSFET, lower voltage rating sufficient for 48V bus

**Selection Rationale:** SiC MOSFET chosen for high efficiency at 200-300kHz switching, low switching losses critical for 200W output in forced air cooled application. High temperature rating supports MIL-STD requirements.

### 3. Synchronous rectifier MOSFETs for secondary side

**Primary Choice:** IRF7749L2PBF (Infineon)

*40V MOSFET in DirectFET package, ultra-low Rds(on) for secondary side rectification.*

| Spec | Value |
|---|---|
| Vds | 40V |
| Id | 100A |
| Rds(on) | 0.9mOhm |
| Qg | 62nC |
| Package | DirectFET CanPAK |

**Alternatives:**
- **BSC014N04LS** (Infineon): 40V OptiMOS, slightly higher Rds(on) but standard package
- **SI7466DP** (Vishay): 40V MOSFET in SO-8, easier assembly but higher thermal resistance

**Selection Rationale:** Ultra-low Rds(on) minimizes conduction losses in secondary rectification, DirectFET package offers excellent thermal performance for forced air cooling.

### 4. 12V linear post-regulator for noise reduction

**Primary Choice:** LT3086 (Analog Devices)

*30A low noise linear regulator with adjustable output, internal protection.*

| Spec | Value |
|---|---|
| Input Voltage | Up to 36V |
| Output Current | 30A |
| Vdropout | 300mV at 15A |
| Noise | 40uVrms |
| Package | LQFP-52-52 |

**Alternatives:**
- **LT3081** (Analog Devices): 10A version, simpler but may need paralleling
- **TPS7A4700** (Texas Instruments): 20A LDO, lower current capacity

**Selection Rationale:** High current linear regulator provides excellent ripple rejection (80dB+) for low-noise 12V rail, sufficient current margin for 12A load, integrated protection features.

### 5. 5V linear post-regulator

**Primary Choice:** LT3045-50 (Analog Devices)

*500mA ultra-low noise linear regulator, 79dB ripple rejection.*

| Spec | Value |
|---|---|
| Output Current | 500mA |
| Vdropout | 300mV |
| Output Noise | 0.8uVrms |
| Package | MSOP-12-EP |

**Alternatives:**
- **TPS7A47** (Texas Instruments): 1A LDO, higher current but larger package
- **AMS1117-5.0** (AMS): 1A fixed LDO, low cost but higher noise

**Selection Rationale:** Multiple LT3045-50 devices can be paralleled for 8A total, ultra-low noise spec meets 20mV ripple requirement, excellent ripple rejection critical for clean 5V rail.

### 6. 3.3V linear post-regulator

**Primary Choice:** LT3042-3.3 (Analog Devices)

*200mA ultra-low noise LDO, 0.8uVrms output noise.*

| Spec | Value |
|---|---|
| Output Current | 200mA |
| Vdropout | 200mV |
| Output Noise | 0.8uVrms |
| Package | DFN-12-EP |

**Alternatives:**
- **LT1763-3.3** (Analog Devices): 500mA LDO, higher current but slightly noisier
- **TPS7A33** (Texas Instruments): 1A negative LDO, different polarity

**Selection Rationale:** Multiple LT3042 devices paralleled for 6A total, extremely low noise specification ensures 3.3V rail meets tight ripple requirements, excellent load regulation.

### 7. High voltage gate driver for primary MOSFET

**Primary Choice:** UCC27714 (Texas Instruments)

*4A high-side/low-side gate driver, 120V bootstrap capability.*

| Spec | Value |
|---|---|
| Supply Voltage | Up to 120V |
| Peak Current | 4A source/sink |
| Propagation Delay | 30ns |
| Package | SOIC-8 |

**Alternatives:**
- **IR2184** (Infineon): 600V gate driver, higher voltage rating not needed
- **LM5114** (Texas Instruments): 100V dual gate driver, simpler but lower current

**Selection Rationale:** Robust high-voltage gate driver suitable for 48V input application, sufficient drive current for SiC MOSFET, military temperature range available.

### 8. Power transformer with three isolated secondaries

**Primary Choice:** CUSTOM_MULTIWIND_200W (Custom/Coilcraft)

*Custom designed flyback/forward transformer with primary and three secondaries for 12V/5V/3.3V outputs.*

| Spec | Value |
|---|---|
| Power Rating | 200W |
| Primary Turns | Calculated per design |
| Secondaries | 12V, 5V, 3.3V windings |
| Isolation | 1500VDC input-output |
| Core Material | Ferrite (3C90 or equivalent) |

**Alternatives:**
- **PQ2620 series** (TDK): Standard core, custom winding required
- **EE40 core set** (Magnetics Inc): Lower cost, custom winding required

**Selection Rationale:** Custom transformer allows optimization for all three output voltages with required isolation, core size chosen for 200W at 200-300kHz switching frequency.

### 9. Optocoupler for isolated feedback

**Primary Choice:** HCPL-3700 (Broadcom/Avago)

*High speed optocoupler with transistor output, 1000V isolation.*

| Spec | Value |
|---|---|
| Isolation Voltage | 3750Vrms |
| Bandwidth | 200kHz |
| CTR | 200-800% |
| Package | DIP-8 |

**Alternatives:**
- **SFH615A-3** (Vishay): Standard optocoupler, lower bandwidth
- **TIL111** (Texas Instruments): Lower cost optocoupler, basic specifications

**Selection Rationale:** High speed optocoupler provides necessary isolation (exceeds 1500V requirement) and bandwidth for feedback loop, MIL-STD qualified versions available.

### 10. Input EMI filter common mode choke

**Primary Choice:** CMD12-101-501 (Coilcraft)

*Common mode choke for EMI suppression, 50uH, 12A current.*

| Spec | Value |
|---|---|
| Inductance | 50uH |
| Current Rating | 12A |
| DCR | 5mOhm |
| Isolation | 1500VDC |

**Alternatives:**
- **744830200133** (Würth Elektronik): CM choke with slightly different specs
- **DLJ11-501** (TDK): Lower current rating alternative

**Selection Rationale:** Common mode choke critical for MIL-STD-461G EMI compliance, 12A rating provides margin, low DSR minimizes losses.

### 11. Output bulk capacitors for filtering

**Primary Choice:** EEV-FK1H101P (Panasonic)

*Conductive polymer aluminum electrolytic capacitor, 100uF 50V, high ripple current.*

| Spec | Value |
|---|---|
| Capacitance | 100uF |
| Voltage Rating | 50V |
| Ripple Current | 3A |
| ESR | 20mOhm |
| Temp Range | -55°C to +105°C |

**Alternatives:**
- **OS-CON 50SVP100M** (Nichicon): Similar specs, different manufacturer
- **APXH100DN50R-7** (KYOCERA AVX): Higher temp range but larger footprint

**Selection Rationale:** Conductive polymer caps provide excellent ripple current handling and low ESR for output filtering, MIL-STD temperature range available, long lifetime.

### 12. Ceramic input/output capacitors for high frequency decoupling

**Primary Choice:** C1210C106M4PACTU (KEMET)

*X7R 10uF 100V ceramic capacitor in 1210 package.*

| Spec | Value |
|---|---|
| Capacitance | 10uF |
| Voltage | 100V |
| Dielectric | X7R |
| Temp Range | -55°C to +125°C |
| Package | 1210 |

**Alternatives:**
- **GRM32ER71H106KA12L** (Murata): Similar specs, different form factor
- **C0805C106K4PAC** (KEMET): Smaller package but lower voltage rating

**Selection Rationale:** X7R ceramic provides stable capacitance over temperature and voltage, essential for high frequency decoupling at switching node.
