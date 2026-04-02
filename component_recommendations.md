# Component Recommendations
## rfff

### 1. RF Power Amplifier - 2.4 GHz, 40 dBm, 28V GaN

**Primary Choice:** QPA9424 (Qorvo)

*GaN broadband PA module, 1.8-4.0 GHz, 10W saturated output power, 30 dB typical gain, operates at 28V, internal matching, designed for CW and pulsed applications. Industrial temp qualified.*

| Spec | Value |
|---|---|
| freq_range | 1.8-4.0 GHz |
| psat | 40-41 dBm (10-12W) |
| gain | 30 dB typical |
| pae | ~45% at 10W |
| vdd | 28V nominal |
| idq | 500 mA typical |
| operating_temp | −40 to +85°C |
| package | QFN 10x10mm, DFN |
| matching | Internal 50 ohm input/output |
| status | Active, RoHS compliant |

**Alternatives:**
- **TGA2227-SM** (Qorvo): Similar GaN PA, 2-6 GHz, 10W, slightly higher cost but wider bandwidth; also requires external matching network.
- **CGRAD1R244GN** (Wolfspeed / Cree): Discrete GaN die, requires full external matching design; lowest cost but highest design complexity.
- **HMC1114** (Analog Devices): GaAs-based, lower voltage (12V), lower output power (34-36 dBm) but easier biasing; not suitable for 40 dBm requirement without additional stages.

**Selection Rationale:** QPA9424 selected as primary: fully integrated module with internal matching meets 'fully integrated' requirement, single 28V supply, 30 dB gain, 10W output power, industrial temp, active lifecycle. Note: verify current availability and lead times; alternate TGA2227-SM provides backup if stock constrained.

### 2. TVS Diode - Overvoltage Protection

**Primary Choice:** SMBJ33A (Vishay / Littelfuse / ON Semiconductor)

*33V breakdown TVS diode for 28V supply overvoltage clamping, protects PA module from transients up to 600W peak pulse power.*

| Spec | Value |
|---|---|
| vrwm | 33V |
| vbr | 36.7V min |
| ipp | 13.5A |
| power | 600W |
| package | SMB (DO-214AA) |
| status | Active, RoHS |

**Alternatives:**
- **SMAJ33A** (Multiple): SMA package lower power (400W), smaller footprint.
- **P6KE33A** (Multiple): Through-hole axial, higher power but larger footprint.

**Selection Rationale:** SMBJ33A provides compact surface-mount protection with adequate power rating for industrial 28V rail clamping to ~33V.

### 3. Pi-Filter Components - EMI Suppression

**Primary Choice:** BLM18PG471SN1D (Ferrite) + 100uF/50V (Tantalum) + 10uF/50V (Ceramic) (Murata (Ferrite), AVX/Kemet (Tantalum), Samsung/TDK (Ceramic))

*Ferrite bead (470 ohm @ 100MHz) + bulk tantalum + ceramic decoupling capacitors for 28V input pi-filter network.*

| Spec | Value |
|---|---|
| ferrite_impedance | 470 ohm @ 100MHz |
| current_rating | 3A+ |
| capacitor_voltage | 50V minimum |
| temp_range | −55 to +125°C |
| status | Active, RoHS |

**Alternatives:**
- **BLM18AG601SN1D** (Murata): 600 ohm impedance, higher attenuation but larger DC resistance.
- **CBR04C100F5GAC** (Kemet): Ceramic bulk capacitor alternative to tantalum, no MTBF reliability concerns but larger case size.

**Selection Rationale:** Standard pi-filter configuration for 28V PA supply; ferrite bead suppresses RF feedback and EMI; tantalum provides bulk capacitance with stable capacitance over temperature.

### 4. RF Connectors - Input/Output

**Primary Choice:** 142-0701-851 (SMA Edge Launch) (Cinch Connectivity Solutions / TE Connectivity / Amphenol)

*SMA PCB edge-launch jack, 50 ohm, suitable for 2.4 GHz operation up to 18 GHz, gold-plated contacts.*

| Spec | Value |
|---|---|
| freq_range | DC to 18 GHz |
| vswr | <1.25:1 at 2.4 GHz |
| impedance | 50 ohms |
| mounting | PCB edge launch |
| termination | Solder termination |
| status | Active, RoHS |

**Alternatives:**
- **086K1-4-4-4** (Molex / Radiall): End-launch vertical SMA, alternative PCB layout footprint.
- **2.4mm/APC-7** (Various): Higher frequency connectors unnecessary for 2.4 GHz; higher cost.

**Selection Rationale:** Standard SMA edge-launch connector for 2.4 GHz PA input and output; robust, industry-standard, 50-ohm matched.

### 5. Heatsink - Thermal Management

**Primary Choice:** AAVID 577302B00000G (custom) (AAVID / Wakefield-Vette / CUI)

*Extruded aluminum heatsink, thermal resistance ≤2°C/W at natural convection, compatible with PA module mounting footprint.*

| Spec | Value |
|---|---|
| thermal_resistance | ≤2°C/W @ 400 LFM |
| material | Aluminum 6063-T5 |
| dimensions | Approx 80mm x 40mm x 25mm |
| mounting | Clip or screw mount |
| finish | Black anodized |
| status | Active, RoHS |

**Alternatives:**
- **HS-CA-3020** (CUI Devices): Copper heatsink with lower thermal resistance but higher cost and weight.
- **FST-75-40** (Aavid Thermalloy): Forced convection heatsink requiring fan; lower resistance but adds moving part complexity.

**Selection Rationale:** Passive heatsink with ≤2°C/W resistance ensures junction temperature remains under 150°C at 85°C ambient for 10W dissipation. Confirm footprint compatibility with selected PA module.

### 6. Thermal Interface Material (TIM)

**Primary Choice:** Bergquist Sil-Pad 1500 (Henkel Bergquist / Laird / 3M)

*Thermally conductive electrically insulative pad, thermal conductivity 1.5 W/m-K, 0.15mm thickness.*

| Spec | Value |
|---|---|
| thermal_conductivity | 1.5 W/m-K |
| dielectric_strength | 6 kV |
| thickness | 0.15mm |
| temp_range | −60 to +200°C |
| status | Active, RoHS |

**Alternatives:**
- **TGP 5000UL** (Laird): Higher conductivity (5 W/m-K) graphite pad; lower thermal resistance but higher cost.
- **TC-5022** (3M): Thermally conductive adhesive tape; permanent bonding, rework difficult.

**Selection Rationale:** Sil-Pad provides adequate thermal coupling with electrical isolation; reusable for assembly and rework.

### 7. Enable Pullup Resistor

**Primary Choice:** RC0805FR-0710KL (Yageo / Vishay / Panasonic)

*Surface mount 10 kohm resistor, 1/8W, 0805 size, for TTL enable pullup to 3.3V.*

| Spec | Value |
|---|---|
| resistance | 10 kohm |
| power | 0.125W |
| tolerance | ±1% |
| package | 0805 |
| tc | ±100 ppm/K |
| status | Active, RoHS |

**Alternatives:**
- **CRCW080510K0FKEA** (Vishay): Thick film resistor, higher tempco.
- **ERA-6AEB104V** (Panasonic): Thin film precision resistor; higher cost.

**Selection Rationale:** Standard pullup resistor for active-high enable control; 10 kohm provides weak pullup with minimal current draw.
