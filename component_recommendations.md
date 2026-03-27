# Component Recommendations
## rf44

### 1. MCU FOC Controller

**Primary Choice:** STM32F405RGT6 (STMicroelectronics)

*ARM Cortex-M4F with FPU, 168MHz, 1MB flash, 192KB RAM, advanced timer (PWM), 3x ADCs, 3x comparator, encoder interface, QFP-64, -40 to 85C.*

| Spec | Value |
|---|---|
| Cores | 1x Cortex-M4F @ 168MHz |
| Flash | 1 MB |
| RAM | 192 KB |
| Timers | Advanced (PWM), General |
| ADCs | 3x 2.4 MSPS 12-bit |
| Comparators | 3x built-in |
| Temp_Range | -40 to +85°C |
| Package | LQFP-64 |

**Alternatives:**
- **STM32G474CEU6** (STMicroelectronics): Newer, higher resolution PWM (HS), more analog features (ADC 4 MSPS), smaller footprint (QFP-48), slightly higher cost
- **TM4C1294NCPDT** (Texas Instruments): ARM Cortex-M4F, 120MHz, integrated Ethernet, more GPIO, larger package (NCPDT 128-pin)
- **MK66FN2M0VMD18** (NXP): Cortex-M4F, 180MHz, 2MB flash, 256KB RAM, more timers, BGA-144 package

**Selection Rationale:** STM32F405 widely used in motor control, good ecosystem (STM32Cube, X-CUBE-MC SDK), hardware FPU and advanced timers for FOC, industrial temp range, QFP-64 for easier assembly. (Newer STM32G4 series offers more analog features but F4 is proven.)

### 2. 3-Phase Inverter MOSFETs

**Primary Choice:** IRFS7530TRL7PP (Infineon (International Rectifier))

*30V, 200A, low RDSon ~1.5 mOhm DirectFET, optimized for high current BLDC/EV applications, -40 to 175°C junction.*

| Spec | Value |
|---|---|
| VDS | 30V |
| ID | 200A |
| RDSon | 1.5 mOhr |
| Package | DirectFET (Can be direct soldered to PCB for thermal) |
| Qg | 140 nC |
| Temp_Range | -55 to +175°C Tj |

**Alternatives:**
- **BSC078N12NS3G** (Infineon): 80V VDS (more margin), 1.8 mOhm, 130A, higher RDSon, slightly larger footprint
- **CSD18540Q5B** (Texas Instruments): 40V, 2.3 mOhr, SON 5x6mm, lower current but easier to place (no DirectFET)
- **IRFS3607** (Infineon (IR)): 75V, 200A, 4.5 mOhr, higher voltage margin but higher conduction loss

**Selection Rationale:** IRFS7530TRL7PP provides very low RDSon for high efficiency at 208A phase current. 30V rating is adequate for 48V bus with headroom, but consider 60V or 80V variants for more margin if bus can spike above 60V. DirectFET allows excellent thermal transfer to PCB/copper. (Confirm VDS derating for your max bus transients.)

### 3. Bootstrap Gate Driver (3x half-bridge drivers)

**Primary Choice:** IR2101 (Infineon (International Rectifier))

*600V, 3-phase bootstrap gate driver, 2A/2A source/sink, internal dead-time, 10-20V logic, -40 to 125°C.*

| Spec | Value |
|---|---|
| Voffset | 600V |
| Gate_Drive | 10-20V |
| Iout_source_sink | 2A/2A |
| Deadtime | 520 ns internal |
| Temp_Range | -40 to +125°C |
| Package | SOIC-8 (DIP-8 also available) |

**Alternatives:**
- **DRV8323RS** (Texas Instruments): 3x 1A half-bridge drivers, integrated buck regulator, SPI-configurable, more features but lower drive current
- **L6390** (STMicroelectronics): 3x 600V half-bridge drivers, analog comparator, built-in op-amp for current sensing, higher cost
- **2ED2106IS** (Infineon): Single 600V driver, need 3 pieces, higher pin count, more flexible layout

**Selection Rationale:** IR2101 is industry-standard, proven bootstrap driver. One driver per phase simplifies layout (2 MOSFETs each). Ensure bootstrap capacitor sizing (e.g., 10uF, 35V) near each driver for reliable high-side drive at 20 kHz. Confirm deadtime matches MOSFET switching characteristics.

### 4. Current Sense Amplifier

**Primary Choice:** INA240A1PW (Texas Instruments)

*Bidirectional current shunt monitor, -80V to +80V common-mode, Vos 5uV, Gain 20 V/V, -40 to 125°C, PWM rejection.*

| Spec | Value |
|---|---|
| Vcm | -80 to +80V |
| Gain | 20 V/V |
| Vos | 5 uV |
| Bandwidth | 400 kHz |
| Supply | 2.7 to 5.5V |
| Package | MSOP-8 |
| Temp_Range | -40 to +125°C |

**Alternatives:**
- **INA282** (Texas Instruments): Bidirectional, -14 to +80V Vcm, Gain 50 V/V, slightly lower bandwidth (50kHz)
- **ACS724LLCTR-20AB** (Allegro): Hall-effect isolated sensor, 20A, requires external scaling and filtering, not shunt-based
- **MAX9918** (Maxim Integrated): High-side current sense amplifier, programmable gain, smaller package, less common in high current apps

**Selection Rationale:** INA240 excellent common-mode rejection and PWM-rejecting characteristics, suitable for inline shunts on motor phases. 20V gain works with low-side shunts (e.g., 0.001 ohm for 200A range). Need three units (one per phase). (Confirm shunt power rating and temperature coefficient.)

### 5. RS-485 Transceiver

**Primary Choice:** MAX3485ESA+ (Maxim Integrated)

*3.3V RS-485 transceiver, 1/8 unit load, up to 256 nodes, -40 to 85°C, SOIC-8.*

| Spec | Value |
|---|---|
| Supply | 3.0 to 3.6V |
| Data_Rate | 10 Mbps |
| Bus_Load | 1/8 unit load (up to 256 transceivers) |
| ESD_Protection | >15kV |
| Package | SOIC-8 |
| Temp_Range | -40 to +85°C |

**Alternatives:**
- **SP3485EN** (Maxim (ex Sipex)): 3.3V, 250kbps, similar features, slightly different pinout
- **LTC2865** (Analog Devices): 3.3V, 20Mbps, more robust fault protection, higher cost
- **ISO3082** (Texas Instruments): Isolated RS-485, adds isolation barrier, more expensive, useful if ground loops expected

**Selection Rationale:** MAX3485 industry-standard 3.3V transceiver with robust ESD protection. Works with MCU UART. Provides differential signaling for industrial noise immunity. (Ensure termination resistor at each end of bus if more than two nodes.)

### 6. DC Link Capacitor

**Primary Choice:** ESLLC450JAN (United Chemi-Con (or equivalent))

*450V, 100uF, snap-in aluminum electrolytic, low ESR, 105°C, high ripple current.*

| Spec | Value |
|---|---|
| Voltage | 450V DC |
| Capacitance | 100 uF |
| ESR | 15 mOhr (typ) |
| Ripple_Current | 3.2 A RMS |
| Temp_Range | -40 to +105°C |
| Package | Snap-in 18x35mm |

**Alternatives:**
- **EKXG450ELL100MJ20S** (Panasonic): 450V, 100uF, slightly lower ESR, similar footprint, higher cost
- **B43508A9108M000** (TDK): 450V, 1000uF, much larger capacitance, larger size, higher cost
- **C4AQCBW5100A3J** (KEMET): Film capacitor, 400V, 100uF, lower ESR, much larger size, non-polarized

**Selection Rationale:** 450V rating provides margin for 48V bus transients. 100uF gives reasonable energy buffer for switching ripple and regen events. Use multiple in parallel for higher ripple current rating and lower ESR if needed. (Consider adding a small high-frequency ceramic bank (e.g., 10uF X7R) close to inverter for high-frequency decoupling.)

### 7. EMI Input Filter

**Primary Choice:** Custom Filter (CM Choke + X/Y Caps) (Various)

*Common mode choke + X capacitors (line-line) + Y capacitors (line-ground) to reduce conducted EMI per EN 55032/IEC 61800-3.*

| Spec | Value |
|---|---|
| CM_Choke_Current | ≥ 250A DC |
| CM_Choke_Inductance | TBD |
| X_Cap_Voltage | 275VAC |
| Y_Cap_Voltage | 250VAC |

**Alternatives:**
- **744830130** (Wurth Elektronik): CM choke 33uH, 250A, vertical mount, may be larger than needed
- **SCDN-14** (Schaffner): Complete filter module, 300A, integrated choke and caps, expensive, larger footprint

**Selection Rationale:** Filter design depends on EMI test results, but starting point: CM choke rated for bus current, X caps (e.g., 1uF) across DC lines, Y caps (e.g., 10nF) from each line to chassis ground. Place filter close to DC input connector. Use shielded cables for motor phases if possible.
