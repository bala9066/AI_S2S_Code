# Component Recommendations
## rf78

### 1. Final RF Power Amplifier (2.4 GHz, 10 W, 28 V)

**Primary Choice:** QPF4528 (Qorvo)

*2.4 GHz 802.11b/g/n WLAN power amplifier module; +28 dBm P1dB typically, but verify 10 W capability — may need discrete GaN; alternate: WG26248-xx*

| Spec | Value |
|---|---|
| Frequency | 2.4–2.5 GHz |
| P1dB | +28 dBm (typ) |
| Gain | 32 dB |
| Supply | 3.3–5 V |
| Package | Module 4x4 mm |

**Alternatives:**
- **CGRM2812** (Wolfspeed (Cree)): Discrete GaN on SiC; 28 V supply; higher power (>15 W) requires external matching; higher efficiency but more complex design.
- **MGA-43016** (Qorvo): 2–6 GHz 2 W driver; can be cascaded for lower output; not 10 W alone.
- **TGF2995-3-10** (Qorvo/Wolfspeed): 10 W GaN FET; 2.7–3.1 GHz; requires external matching and bias network.

**Selection Rationale:** A 10 W 2.4 GHz PA at 28 V suggests a GaN/SiGe or GaAs device. The QPF4528 is a lower-power module; for true 10 W, a discrete GaN like CGRM2812 or a hybrid module is needed. Recomment prioritizing GaN for efficiency and thermal headroom. Verify BT linearity with device datasheet.

### 2. Driver Stage (optional if final PA requires high drive)

**Primary Choice:** MGA-43016 (Qorvo)

*2–6 GHz driver amplifier; +20 dBm P1dB; 28 dB gain.*

| Spec | Value |
|---|---|
| Frequency | 2–6 GHz |
| P1dB | +20 dBm |
| Gain | 28 dB |
| Supply | 5 V |
| Package | DFN 2x2 mm |

**Alternatives:**
- **HMC382** (Analog Devices): DC–6 GHz gain block; +18 dBm P1dB; similar performance.
- **PMA3-4034LN+** (Pasternack/Mini-Circuits): 40 dB gain block; check supply and linearity.

**Selection Rationale:** Driver to boost 0–10 dBm input to the ~20 dBm required by many 10 W final PA devices. The MGA-43016 provides good gain and linearity for Bluetooth modulation.

### 3. Directional Coupler (for VSWR monitoring)

**Primary Choice:** ACB4-50-4000+ (Mini-Circuits)

*2–4 GHz broadband directional coupler; 10 dB coupling; handles up to 50 W.*

| Spec | Value |
|---|---|
| Frequency | 2–4 GHz |
| Coupling | 10 dB |
| Directivity | >15 dB |
| Power Handling | 50 W avg |
| Insertion Loss | 0.3 dB |

**Alternatives:**
- **C0542-10** (Anaren): 2–6 GHz 10 dB coupler; similar specs.
- **PDC-20-10-2000/4000** (Pasternack): 20 dB coupling; lower directivity.

**Selection Rationale:** The ACB4-50-4000+ provides good directivity (>15 dB) for accurate VSWR detection, handles >10 W, and operates across 2.4 GHz band.

### 4. RF Power Detector (logarithmic, for forward and reverse power)

**Primary Choice:** AD8318 (Analog Devices)

**

| Spec | Value |
|---|---|
| Frequency | 1 MHz–8 GHz |
| Dynamic Range | 60 dB |
| Response Time | 10 ns |
| Supply | 2.7–5.5 V |
| Output | V_linear-in-dB |

**Alternatives:**
- **LTC5596** (Analog Devices): 100 MHz to 40 GHz; higher frequency; higher cost.
- **MAX2015** (Maxim Integrated): 0.1–2.5 GHz; lower frequency limit but sufficient.

**Selection Rationale:** The AD8318 is a wideband log detector suitable for 2.4 GHz power measurement. Two units can be used for forward and reverse monitoring, feeding comparators for VSWR logic.

### 5. Overtemperature Sensor (for thermal protection)

**Primary Choice:** TMP235 (Texas Instruments)

*Analog output temperature sensor; –40 to +150°C range; 10 mV/°C.*

| Spec | Value |
|---|---|
| Temperature Range | –40 to +150°C |
| Accuracy | ±2°C |
| Supply | 2.7–5.5 V |
| Output | 10 mV/degC |

**Alternatives:**
- **NCT75** (ON Semiconductor): I2C digital sensor; requires I2C host.
- **MAX6607** (Maxim Integrated): Similar analog sensor; higher accuracy.

**Selection Rationale:** Simple analog-output sensor feeding a comparator for overtemperature shutdown. The TMP235 provides sufficient accuracy and operates across industrial temperature range.

### 6. Bias Sequencer / Enable Control

**Primary Choice:** LM555 (alt: 555 Timer + MOSFETs) (Texas Instruments / STMicroelectronics)

*Discrete 555-based delay generator with two MOSFETs for driver and PA bias sequencing.*

| Spec | Value |
|---|---|
| Delay | Adjustable via RC |
| Supply | Up to 28 V via MOSFETs |
| Channels | 2 |
| Logic Input | 3.3 V compatible |

**Alternatives:**
- **TPS22916** (Texas Instruments): Dual load switch; lower voltage; may need external FETs.
- **MAX16050** (Maxim Integrated): Dedicated bias sequencer; higher cost.

**Selection Rationale:** A simple 555-based RC delay or discrete MOSFET delay network provides inexpensive bias sequencing. For a more integrated solution, consider a dedicated bias controller if tighter timing is required.

### 7. Reverse Polarity Protection

**Primary Choice:** IRLR3105 (Infineon)

*P-channel MOSFET for reverse polarity protection on 28 V supply.*

| Spec | Value |
|---|---|
| Vds | –55 V |
| Id | –62 A |
| Rds_on | 11 mOhm |
| Package | TO-252 |

**Alternatives:**
- **FQP27P06** (ON Semiconductor): P-channel; lower current but sufficient.
- **Schottky Diode** (Generic): Simple diode drop; higher loss.

**Selection Rationale:** P-channel MOSFET provides low-loss reverse polarity protection. Ensure gate is pulled to ground when polarity is correct.

### 8. Lowpass Output Filter (harmonic suppression)

**Primary Choice:** Custom 5th-order LC LPF (Design / Assembly)

*5th-order Chebyshev lowpass filter centered at 2.5 GHz; cutoff ~3 GHz; harmonics < –30 dBc.*

| Spec | Value |
|---|---|
| Topology | 5th-order LC |
| Cutoff | 3.0 GHz |
| Insertion Loss | < 0.5 dB at 2.4 GHz |
| Rejection | > 30 dB at 4.8 GHz |

**Alternatives:**
- **LFCN-2500+** (Mini-Circuits): Off-the-shelf LPF; verify power handling.
- **HFCN-2500+** (Mini-Circuits): Highpass complement; not suitable.

**Selection Rationale:** Custom discrete LC filter allows power handling >10 W and precise harmonic suppression. Use high-Q RF inductors and NP0/C0G capacitors.

### 9. RF Connectors (SMA)

**Primary Choice:** 142-0701-851 (Cinch Johnson)

*SMA edge-launch PCB jack; 50 Ohm; suitable up to 18 GHz.*

| Spec | Value |
|---|---|
| Frequency | DC to 18 GHz |
| Impedance | 50 Ohm |
| Mount | Edge-launch |
| Gold Plating | Yes |

**Alternatives:**
- **PCB-SMA-EDGE-50** (Pasternack): Similar edge-launch SMA.
- **32K241-40ML5** (TE Connectivity): End-launch SMA; similar performance.

**Selection Rationale:** Industry-standard SMA connectors provide reliable RF interface up to 18 GHz. Edge-launch simplifies PCB routing.

### 10. Heatsink for PA

**Primary Choice:** AAVID 577100B00000G (AAVID (Boyd))

*Extruded aluminum heatsink with thermal resistance ~1.5°C/W; matches PA device footprint.*

| Spec | Value |
|---|---|
| Thermal Resistance | 1.5°C/W |
| Dimensions | TBD per PCB |
| Mounting | Screw mount |

**Alternatives:**
- **Custom heatsink** (Design / Machine shop): Optimized for specific enclosure and airflow.
- **Thermal pad + fan** (Generic): Lower thermal resistance with forced air.

**Selection Rationale:** A 10 W PA at ~35% PAE dissipates ~20 W. A heatsink with 1.5–2°C/W keeps junction temperature within limits at +85°C ambient with derating.
