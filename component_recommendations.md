# Component Recommendations
## rfgg

### 1. 2.4 GHz 2W Driver Power Amplifier

**Primary Choice:** QPA9226 (Qorvo)

*2W, 1.8-2.7 GHz GaN HEMT driver amplifier with 32dB gain, 20dBm P1dB*

| Spec | Value |
|---|---|
| gain | 32 dB |
| p1db | 20 dBm |
| psat | 22 dBm |
| supply | 12V |
| frequency | 1.8-2.7 GHz |
| efficiency | >35% PAE |

**Alternatives:**
- **MGA-43004** (Qorvo): Lower power (1W) but integrated matching, easier layout
- **GVA-123+** (Mini-Circuits): Discrete module, external matching required but flexible

**Selection Rationale:** QPA9226 provides excellent gain and output power at 2.4 GHz from 12V supply, with integrated matching reducing external components. GaN technology offers high efficiency and thermal performance for industrial temp range.

### 2. 2.4 GHz 10W Final Power Amplifier

**Primary Choice:** QPA9426 (Qorvo)

*10W, 2.0-2.7 GHz GaN HEMT power amplifier with 18dB gain, 40dBm Psat*

| Spec | Value |
|---|---|
| psat | 40 dBm |
| p1db | 39 dBm |
| gain | 18 dB |
| supply | 28V |
| frequency | 2.0-2.7 GHz |
| efficiency | >45% PAE |
| qfn_package | 6x6mm |

**Alternatives:**
- **TGA2578-CP** (Qorvo): Higher power (15W) but requires 28V supply, need boost converter
- **MGA-25843** (Qorvo): Lower power (5W) but operates from 12V directly, simpler supply

**Selection Rationale:** QPA9426 delivers 10W at 2.4 GHz with excellent efficiency. Although 28V nominal, can operate at reduced power from 12V or use small boost converter. GaN provides thermal robustness for industrial temperature range.

### 3. RF Power Detector for Output Monitoring

**Primary Choice:** AD8318 (Analog Devices)

*1 MHz to 8 GHz logarithmic RF detector, 60dB dynamic range, 1dB accuracy*

| Spec | Value |
|---|---|
| frequency | 1 MHz - 8 GHz |
| dynamic_range | 60 dB |
| accuracy | +/- 1 dB |
| supply | 2.7-5.5V |
| output | linear-in-dB voltage |

**Alternatives:**
- **LTC5596** (Analog Devices): Higher frequency (up to 40 GHz) but more expensive
- **MAX2015** (Maxim Integrated): Lower cost but limited to 2.5 GHz max

**Selection Rationale:** AD8318 offers wide frequency coverage covering 2.4 GHz with excellent accuracy and dynamic range. Low supply voltage compatible with 3.3V logic. Enables accurate output power monitoring.

### 4. DC-DC Boost Converter for PA Supply

**Primary Choice:** LTC3780 (Analog Devices)

*Synchronous 4-switch buck-boost controller, up to 36V output, 10A capable*

| Spec | Value |
|---|---|
| input_range | 4-38V |
| output_range | 2.5-36V |
| current | up to 10A |
| switching_freq | 200kHz-2MHz |
| efficiency | >96% |

**Alternatives:**
- **LM5175** (Texas Instruments): Similar performance, integrated FET drivers
- **TPS61088** (Texas Instruments): Lower current (5A) but smaller package, simpler layout

**Selection Rationale:** LTC3780 provides efficient 12V to 28V conversion at 10A current for final PA. Synchronous 4-switch design minimizes power loss. High switching frequency enables small inductor/capacitor selection.

### 5. Low Pass Filter for Harmonic Suppression

**Primary Choice:** HFCN-2400+ (Mini-Circuits)

*2.4 GHz bandpass/Lowpass filter, 30dBc harmonic rejection*

| Spec | Value |
|---|---|
| center_freq | 2.4 GHz |
| bandwidth | 100 MHz |
| insertion_loss | <1.5 dB |
| rejection | >30 dBc @ harmonics |
| power_handling | 20W |

**Alternatives:**
- **LFCN-2400+** (Mini-Circuits): Lower frequency corner, sharper roll-off
- **RFLP-2400+** (RF Labs): Similar specs, verify availability

**Selection Rationale:** Mini-Circuits HFCN-2400+ provides excellent harmonic suppression at 2.4 GHz with low insertion loss. Handles 20W power for final PA output. Module solution reduces PCB complexity.

### 6. RF Isolator/Circulator

**Primary Choice:** UIY-ISO-2400-S+ (UIY Inc)

*2.4 GHz coaxial isolator, 20W power handling, 20dB isolation*

| Spec | Value |
|---|---|
| frequency | 2.4 GHz |
| isolation | 20 dB |
| insertion_loss | <0.5 dB |
| vswr | <1.3:1 |
| power | 20W avg |

**Alternatives:**
- **JD-ISO-2400** (JD Microwave): Similar specs, check lead time
- **MIC-ISO-2400** (Microwave Inc): Lower power (10W) but smaller footprint

**Selection Rationale:** Isolator protects PA from VSWR mismatches at antenna. 20W rating provides headroom. Low insertion loss maintains output power. Essential for robustness in field applications.

### 7. Thermal Pad/Heatsink Interface

**Primary Choice:** Bergquist HP2-SilPad (Bergquist (Henkel))

*Thermally conductive silicone pad, 6 W/m-K thermal conductivity*

| Spec | Value |
|---|---|
| thermal_conductivity | 6 W/m-K |
| thickness | 0.25mm |
| dielectric_strength | 5 kV |
| temperature | -60 to +200C |

**Alternatives:**
- **Cho-Therm 1678** (Parker Chomerics): Higher conductivity (10 W/m-K) but thicker
- **AquaPAD** (Laird): Lower cost but lower conductivity

**Selection Rationale:** HP2-SilPad provides excellent thermal transfer between PA devices and heatsink with electrical isolation. Thin profile minimizes thermal resistance. Wide temperature range exceeds industrial requirements.
