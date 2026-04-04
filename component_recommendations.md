# Component Recommendations
## tf

### 1. RF Power Amplifier - 2.4GHz 10W 12V

**Primary Choice:** QPA2211D (Qorvo)

*2-stage GaN MMIC power amplifier, 2-4 GHz, 10W saturated power, 50-ohm matched, operates from 12V. Ideal for 2.4GHz ISM band applications with CW and modulation support.*

| Spec | Value |
|---|---|
| Frequency | 2-4 GHz |
| Psat | 40 dBm (10W) |
| Gain | 33 dB |
| PAE | 55% typical |
| VDD | 12V |
| Package | QFN 7x7mm |
| Temp | -40°C to +85°C |

**Alternatives:**
- **AM0110500-1R1** (Custom MMIC): Slightly lower gain (28dB), similar power output, better availability
- **GVA-123+** (Mini-Circuits): Requires 15V supply, similar power, lower cost but supply voltage mismatch
- **HMC1114LP4DE** (Analog Devices): Higher gain (40dB), lower power (8W), higher cost

**Selection Rationale:** QPA2211D meets all critical requirements: 40dBm output, 12V operation, 30+dB gain, industrial temperature range, and 50-ohm matched ports simplify matching network design. GaN technology provides excellent efficiency and thermal performance.

### 2. RF SMA Connector - Female PCB Mount

**Primary Choice:** 142-0701-801 (Cinch Connectivity Solutions (Johnson))

*SMA female jack connector, 50-ohm, flange mount, gold-plated contacts, brass body, designed for PCB edge-mount applications up to 18GHz.*

| Spec | Value |
|---|---|
| Frequency | DC to 18 GHz |
| Impedance | 50 ohms |
| VSWR | 1.25:1 max |
| Mount | Through-hole flange |
| Contact | Gold plating |
| Temp | -55°C to +155°C |

**Alternatives:**
- **32K243-40ML5** (Amphenol RF): Similar specs, edge-mount style, lower cost alternative
- **0734120110** (Molex): End-launch style, excellent performance at 2.4GHz, tighter board spacing

**Selection Rationale:** Johnson SMA connectors are defense-industry standard with proven reliability. Flange mount provides mechanical stability and proper grounding for high-power RF applications.

### 3. RF Capacitor - Input/Output DC Block

**Primary Choice:** 0402JA1H6R8CXTE (AVX)

*6.8pF NP0/C0 ceramic capacitor, 0402, 50V rated, ultra-low ESR, designed for RF coupling/matching applications up to 6GHz.*

| Spec | Value |
|---|---|
| Capacitance | 6.8 pF |
| Dielectric | C0/NP0 |
| Voltage | 50V DC |
| ESR | 0.05 ohm |
| Temp Coeff | ±30 ppm/°C |
| Package | 0402 |

**Alternatives:**
- **GQM1555C1H6R8JB01** (Murata): 01005 package, similar RF performance, tighter tolerance
- **UHFJ1H6R8BWCR** (KEMET): High-Q design, 0603 package, wider availability

**Selection Rationale:** NP0/C0 dielectric provides stable capacitance over temperature and voltage with minimal loss. Critical for maintaining impedance matching and efficiency at 2.4GHz.

### 4. RF Inductor - Matching Network

**Primary Choice:** 0402CS-3N9XJL (Coilcraft)

*3.9 nH air-core wirewound inductor, 0402, high-Q RF choke/matching inductor for 2.4GHz matching networks.*

| Spec | Value |
|---|---|
| Inductance | 3.9 nH |
| Q Factor | 55 typical at 1GHz |
| SRF | >6 GHz |
| DCR | 0.045 ohm |
| Package | 0402 |
| Current | 800 mA |

**Alternatives:**
- **LQG15HS3N9S02D** (Murata): Wirewound, 0402, slightly lower Q (45), similar specs
- **0402AF-3N9XJRU** (Coilcraft): Ceramic core, higher Q (60), tighter tolerance

**Selection Rationale:** Coilcraft 0402CS series offers excellent Q-factor and self-resonant frequency well above 2.4GHz, minimizing losses in matching network.

### 5. DC Power Decoupling Capacitor Array

**Primary Choice:** GRM32ER72A475KA35L (Murata)

*4.7uF X7R ceramic capacitor, 0805, 100V rated, low-ESR, for primary power supply decoupling at PA supply pin.*

| Spec | Value |
|---|---|
| Capacitance | 4.7 µF |
| Dielectric | X7R |
| Voltage | 100V DC |
| ESR | 3 m ohm |
| Temp | -55°C to +125°C |
| Package | 0805 |

**Alternatives:**
- **C2012X7R2A475K125AA** (TDK): Same value, 0805, similar performance, alternative source
- **885012207072** (Würth Elektronik): WCA series, automotive grade, larger footprint but higher surge current

**Selection Rationale:** X7R dielectric maintains capacitance over temperature. 4.7uF provides bulk decoupling for PA supply transients. 100V rating gives 8x derating margin.

### 6. High Frequency Decoupling Capacitor

**Primary Choice:** GCM1555C1H102FA16 (Murata)

*1000pF (1nF) NP0/C0 capacitor, 0402, 50V, ultra-high Q for RF decoupling up to several GHz.*

| Spec | Value |
|---|---|
| Capacitance | 1000 pF |
| Dielectric | C0/NP0 |
| Voltage | 50V DC |
| Q | 500 typical at 1MHz |
| Package | 0402 |

**Alternatives:**
- **CBR04C102J3GAC** (KEMET): High-frequency C0G, 0402, similar specs
- **UHFJ1H101XWR5** (KEMET): Ultra-high Q RF series, excellent for 2.4GHz decoupling

**Selection Rationale:** NP0/C0 provides lowest loss at RF frequencies. 1000pF presents low impedance at 2.4GHz for effective high-frequency decoupling.

### 7. Enable Control Logic Gate

**Primary Choice:** SN74LVC1G17DBVR (Texas Instruments)

*Single Schmitt-trigger buffer with 3-state output, 5V tolerant, operates from 1.65V to 5.5V for enable signal conditioning.*

| Spec | Value |
|---|---|
| Supply | 1.65V to 5.5V |
| Input Threshold | Schmitt trigger |
| Output Current | 32 mA |
| Propagation | 7 ns max |
| Temp | -40°C to +125°C |
| Package | SOT-23-5 |

**Alternatives:**
- **NC7SZU04P5X** (onsemi (Fairchild)): Unbuffered inverter, lower power, SOT-353 package
- **74LVC1G07GV** (Nexperia): Open-drain buffer, similar specs, alternative source

**Selection Rationale:** Schmitt-trigger provides clean enable switching with hysteresis to prevent oscillation. 5V tolerant accepts 3.3V or 5V logic inputs.

### 8. Thermal Protection Sensor

**Primary Choice:** TMP235A2DCKR (Texas Instruments)

*Analog output temperature sensor with 10mV/°C slope, operates from 2.7V to 5.5V, accurate to ±2°C over -40°C to +150°C.*

| Spec | Value |
|---|---|
| Range | -40°C to +150°C |
| Accuracy | ±2°C |
| Supply | 2.7V to 5.5V |
| Output | 10 mV/°C |
| Current | 35 uA |
| Package | SC-70 (5-pin) |

**Alternatives:**
- **LM94071CIX-5** (Texas Instruments): Similar specs, lower gain (5.5mV/°C), SOT-23 package
- **MAX6576UTA+T** (Maxim Integrated): Digital PWM output, requires microcontroller, higher accuracy

**Selection Rationale:** Analog output interfaces directly to PA bias controller for thermal shutdown. Wide temp range covers full operating spec with headroom for die temperature monitoring.
