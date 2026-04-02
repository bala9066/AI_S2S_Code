# Component Recommendations
## fug

### 1. Main MCU with Motor Control and IEC 60730 Class B Support

**Primary Choice:** STM32F407VGT6 (STMicroelectronics)

*ARM Cortex-M4 at 168MHz with FPU, advanced motor control timers, and IEC 60730 Class B certified library support. 1MB flash, 192KB RAM, 3x 12-bit ADCs at 2.4 MSPS.*

| Spec | Value |
|---|---|
| core | ARM Cortex-M4F @ 168MHz |
| flash | 1 MB |
| ram | 192 KB |
| timers | 3x advanced motor-control timers |
| temperature | -40 to +85C |
| package | LQFP-100 |

**Alternatives:**
- **TM4C129ENCPDT** (Texas Instruments): More expensive but offers Ethernet PHY integrated
- **MC56F82748VLC** (NXP): DSC architecture optimized for motor control, smaller ecosystem

**Selection Rationale:** Selected for mature motor control ecosystem, certified IEC 60730 library, and sufficient ADC channels for 3-phase current sensing. 168MHz provides margin for 20 kHz control loop with trapezoidal commutation.

### 2. 3-Phase MOSFET Power Stage

**Primary Choice:** BSC078N12NS3G (Infineon)

*OptiMOS 3 80V MOSFET in SuperSO8 package. 0.78 mOhm RDS(on) with 300A pulsed current capability. Optimized for high-current automotive applications.*

| Spec | Value |
|---|---|
| vds | 80V |
| rds_on | 0.78 mOhm |
| id_pulse | 300A |
| package | SuperSO8 5x6mm |
| temperature | -55 to +175C junction |

**Alternatives:**
- **CSD18540Q5B** (Texas Instruments): Higher RDS(on) at 0.85 mOhm but better availability
- **IRF7749L2PbF** (Infineon): DirectFET package requires different PCB footprint but better thermal performance

**Selection Rationale:** At 48V/210A continuous, conduction losses dominate. 0.78 mOhm with parallel devices achieves ~96% efficiency. 80V rating provides 1.6x safety margin over 65V OVP threshold. (verify availability - check Infineon distribution)

### 3. 3-Phase Gate Driver with Bootstrap and Protection

**Primary Choice:** IR2101 (Infineon)

*High/low side gate driver with bootstrap operation. 600V rating, 2A source/sink current. Integrated deadtime and undervoltage lockout. Industry standard for motor control.*

| Spec | Value |
|---|---|
| v_offset | 600V |
| drive_current | +2/-2A |
| deadtime | 520 ns typical |
| package | DIP-8 or SOIC-8 |
| temperature | -40 to +125C |

**Alternatives:**
- **UCC27714** (Texas Instruments): Faster propagation delay but higher cost
- **L6390** (STMicroelectronics): Integrated op-amp for current sensing but larger footprint

**Selection Rationale:** Proven reliability in EV motor controllers. Bootstrap topology simplifies power supply design (no 3 isolated supplies needed). 520ns deadtime prevents shoot-through at 20 kHz switching.

### 4. Phase Current Sensing - Isolated Amplifier

**Primary Choice:** AMC1200 (Texas Instruments)

*Isolated amplifier for current shunt measurement. 250kV/us CMRR, 3kVrms isolation. Fixed gain of 8V/V. Bandwidth supports 20 kHz PWM filtering.*

| Spec | Value |
|---|---|
| gain | 8 V/V |
| bandwidth | 60 kHz |
| isolation | 3 kVrms |
| accuracy | +/- 3% at 25C |
| package | SOIC-8 |

**Alternatives:**
- **HCPL-7840** (Broadcom (Avago)): Better offset drift but more expensive
- **ACS724** (Allegro): Integrated Hall sensor reduces PCB space but lower accuracy and bandwidth

**Selection Rationale:** Shunt-based measurement provides best accuracy for IEC 60730 current monitoring. Isolation required for safety in 48V EV systems. 3kVrms rating exceeds IEC 60664-1 requirements for 48V.

### 5. Gate Driver Power Supply - Isolated DC-DC

**Primary Choice:** B0505S-1WR3 (Mornsun)

*1W isolated 5V to 5V DC-DC converter. 1.5kVDC isolation. Ultra-wide temp range -40 to +85C. Provides clean bias for bootstrap circuitry.*

| Spec | Value |
|---|---|
| power | 1W |
| isolation | 1.5 kVDC |
| regulation | +/- 3% |
| efficiency | 80% typical |
| package | SIP-4 |

**Alternatives:**
- **AMC1S0505SZ** (Aimtec): Higher power rating at 2W but larger footprint
- **ADUM5000** (Analog Devices): iCoupler technology, lower isolation rating

**Selection Rationale:** Required for isolated high-side gate drive bias. Mornsun offers industrial temp rating at lower cost than alternatives. 1W sufficient for 3x IR2101 quiescent current plus gate charge.

### 6. DC Link Capacitor Bank

**Primary Choice:** ESL261RAN1020M3B0 (United Chemi-Con (Nippon Chemi-Con))

*Aluminum electrolytic capacitor 1000uF 63V 20% ripple. Snap-in mounting. 105C temperature rating. Low ESR of 18 mOhm.*

| Spec | Value |
|---|---|
| capacitance | 1000 uF |
| voltage | 63V DC |
| esr | 18 mOhm at 100kHz |
| ripple_current | 4.2A rms |
| temperature | -40 to +105C |
| lifetime | 2000 hrs at 105C |

**Alternatives:**
- **EEU-FR1V102** (Panasonic): Higher cost but longer lifetime
- **ESLL261RAN1020M3B0** (United Chemi-Con): Lower ESR (13 mOhm) but larger diameter

**Selection Rationale:** DC link ripple voltage at 210A/20kHz = I / (2*pi*f*C). Multiple units in parallel achieve required capacitance. 63V rating provides margin above 65V OVP with derating. 105C rating needed for ambient 85C with self-heating.
