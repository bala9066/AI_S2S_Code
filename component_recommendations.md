# Component Recommendations
## rf4

### 1. High-Power GaN PA (Final Stage)

**Primary Choice:** Qorvo QPD1020 (Qorvo)

*GaN-on-SiC power transistor, 2W to 10W output at 2-4 GHz, 28V capable but usable at 12V with reduced output, 50-ohm matched.*

| Spec | Value |
|---|---|
| frequency | 2-4 GHz |
| pout | 10W (40 dBm) |
| gain | 12-15 dB |
| efficiency | 40-50% |
| supply | 12-28V |

**Alternatives:**
- **Cree CGH27010** (Wolfspeed/Cree): Higher power (15W), requires 28V rail, better efficiency
- **NXP AFT05MS031** (NXP): LDMOS, lower cost, 31W but at higher voltage, less efficient at 12V

**Selection Rationale:** QPD1020 operates well at 12V, provides 40 dBm output with decent gain. Verified for 2.4 GHz ISM applications.

### 2. Driver Amplifier MMIC

**Primary Choice:** Mini-Circuits ERA-5SM+ (Mini-Circuits)

*GaAs MMIC amplifier, 2-8 GHz, +18.5 dB gain, +20 dBm P1dB, runs on +5V.*

| Spec | Value |
|---|---|
| frequency | 2-8 GHz |
| gain | 18.5 dB |
| p1db | +20 dBm |
| supply | +5V at 70mA |
| package | SOT-89 |

**Alternatives:**
- **Peregrine PE4259** (Peregrine Semi): Lower gain (15dB), lower power, but better linearity
- **Analog Devices HMC311** (Analog Devices): Similar specs, higher cost, better thermal performance

**Selection Rationale:** ERA-5SM+ provides ~20 dB gain to drive PA to 40 dBm output. Low cost, easy 5V supply, industry standard.

### 3. RF Directional Coupler

**Primary Choice:** Mini-Circuits ZGDC30-33HP+ (Mini-Circuits)

*2.2-2.6 GHz directional coupler, 30 dB coupling, handles 20W.*

| Spec | Value |
|---|---|
| frequency | 2.2-2.6 GHz |
| coupling | 30 dB |
| directivity | 15 dB |
| power | 20W avg |

**Alternatives:**
- **MACAT MABC-002000-CP000H** (MACOM): Higher coupling (20dB), higher directivity, more expensive
- **Anaren X3C25P2-03S** (Anaren): 25 dB coupling, smaller footprint

**Selection Rationale:** Provides power monitoring without tap loss. 30dB coupling is safe for spectrum analyzer input.

### 4. Voltage Regulator (Driver)

**Primary Choice:** Texas Instruments TPS54335A (Texas Instruments)

*Buck converter, 4.5-28V in to 5V out, 3A output, high efficiency.*

| Spec | Value |
|---|---|
| vin | 4.5-28V |
| vout | 5V adj |
| iout | 3A |
| efficiency | >90% |
| switching_freq | 500kHz |

**Alternatives:**
- **Analog Devices LT8610** (Analog Devices): Lower noise, higher cost, synchronous rectification
- **Murata 78SR05** (Murata): Linear regulator, simpler, lower efficiency, more heat

**Selection Rationale:** Efficient 5V supply for driver MMIC from 12V main rail. Switching frequency avoids RF band interference.

### 5. RF SMA Connectors

**Primary Choice:** TE Connectivity 2-1994554-1 (TE Connectivity)

*SMA edge jack, 50-ohm, PCB mount, 2-hole flange.*

| Spec | Value |
|---|---|
| freq_range | DC-18 GHz |
| vswr | 1.5:1 max |
| mounting | PCB edge |

**Alternatives:**
- **Molex 73251-1350** (Molex): End launch, better VSWR, more expensive
- **Amphenol 901-10511-3** (Amphenol): SMB instead of SMA, lower frequency limit

**Selection Rationale:** Standard SMA connector, reliable, good performance to 18GHz, easy PCB footprint.

### 6. Thermistor (Temp Sensing)

**Primary Choice:** Murata NCP18XH103F03RB (Murata)

*NTC thermistor, 10kΩ at 25°C, ±1% tolerance.*

| Spec | Value |
|---|---|
| r25 | 10kΩ |
| beta | 3380K |
| tolerance | ±1% |
| package | 0603 |

**Alternatives:**
- **Vishay NTCS0603E3104FHT** (Vishay): 100kΩ, different beta curve
- **TDK NTCG063JF103FTDS** (TDK): Similar specs, lower cost

**Selection Rationale:** Provides thermal feedback for PA protection. Standard 10k NTC with known characteristics.
