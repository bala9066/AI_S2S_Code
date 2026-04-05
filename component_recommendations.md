# Component Recommendations
## hkgg

### 1. Driver Amplifier (20dB gain, 50-500MHz, +12V supply)

**Primary Choice:** GVA-123+ (Mini-Circuits)

*Wideband MMIC amplifier, 50-1000MHz, +20dB gain, +28dBm P1dB, operates from +5V to +15V, 50ohm input/output matched. Ideal driver stage for 10W PA.*

| Spec | Value |
|---|---|
| frequency_range | DC-1000 MHz |
| gain | +20 dB typical |
| p1db | +28 dBm |
| supply | +5V to +15V |
| current | 90 mA typ |
| package | SOT-89 |

**Alternatives:**
- **MMG3007N** (NXP (formerly Freescale)): Similar gain, slightly lower P1dB at +26dBm, lower cost
- **ERA-5SM+** (Mini-Circuits): Lower gain (+16dB) but excellent linearity and stability

**Selection Rationale:** The GVA-123+ provides required 20dB gain, wide bandwidth covering 50-500MHz, operates directly from +12V supply with minimal external components, and has 50ohm matched ports simplifying matching network design. SOT-89 package enables good thermal performance.

### 2. Final Power Amplifier (10W, 40dBm PSAT, 50-500MHz)

**Primary Choice:** MGA-21063 (Qorvo (formerly TriQuint))

*10W GaN HEMT power amplifier module, 20-500MHz, +40dBm PSAT, 14dB gain, operates from +28V but can be derated for +12V operation. Integrated matching.*

| Spec | Value |
|---|---|
| frequency_range | 20-500 MHz |
| psat | +40 dBm |
| gain | 14 dB |
| supply | +28V (derated) |
| efficiency | 45% typical |
| package | Flange mount with thermal pad |

**Alternatives:**
- **CGRB2025V2-250** (Wolfspeed): Higher performance GaN device requiring +28V supply, more complex bias circuitry
- **BLF2425M9S140** (Ampleon (formerly NXP)): 25W LDMOS device, requires +32V supply, overkill for 10W requirement
- **MRF1511** (MACOM/NXP): 12V LDMOS suitable, 30W capability, VHF optimized

**Selection Rationale:** Note: The GVA-123+ and MGA-21063 combination presents a supply voltage challenge. The MGA-21063 is designed for +28V. For a true +12V single-supply design, the MRF1511 N-channel LDMOS FET is better suited - it operates at +12V, delivers 12W at VHF, with 13dB gain. Requires external matching networks but supports single supply operation.

### 3. Output Power Transistor (LDMOS 12V, 10W, 50-500MHz) - CORRECTED PRIMARY

**Primary Choice:** MRF1511G (MACOM)

*12V N-channel enhanced mode LDMOS RF power transistor designed for wideband applications up to 500MHz. 12W PSAT, 13dB gain, 50% efficiency.*

| Spec | Value |
|---|---|
| frequency_range | DC-500 MHz |
| psat | +41 dBm (12W) |
| gain | 13 dB |
| supply | +12V |
| efficiency | 50% typical |
| package | NI-1230 (flange mount) |

**Alternatives:**
- **BLF2425M9S140** (Ampleon): Higher voltage device (32V), more power capability but requires supply conversion
- **AFT05MS031N** (NXP): 31W VHF device, similar characteristics, higher cost

**Selection Rationale:** The MRF1511G is optimized for +12V operation across the 50-500MHz bandwidth. Provides required 10W output with margin, good efficiency reducing thermal load. Industry-standard flange package with excellent thermal characteristics for heatsink mounting.

### 4. Bias Controller / Gate Reference

**Primary Choice:** MAX1167 (Maxim Integrated (Analog Devices))

*Precision 12-bit DAC with internal reference, generates adjustable gate bias voltage for LDMOS control. I2C programmable.*

| Spec | Value |
|---|---|
| resolution | 12-bit |
| output | 0 to Vref |
| interface | I2C |
| supply | +2.7V to +5.5V |
| package | SOT-23 |

**Alternatives:**
- **MCP4725** (Microchip): Lower cost 12-bit DAC, similar functionality
- **DAC5578** (Texas Instruments): 8-channel DAC, overkill for single gate bias control

**Selection Rationale:** Provides precision gate voltage control for LDMOS device biasing. Small footprint, easy interface to MCU if digital control needed, or preset to fixed bias via resistors.

### 5. Gate Bias MOSFET Switch (Enable Control)

**Primary Choice:** IRLML6402 (Infineon)

*P-channel MOSFET for high-side gate bias switching, -20V Vds, -3.7A Id, logic level gate.*

| Spec | Value |
|---|---|
| vds | -20V |
| id | -3.7A |
| rds_on | 0.065 ohm |
| package | SOT-23 |
| gate_charge | 8.5 nC |

**Alternatives:**
- **AO4407** (Alpha & Omega): Similar specs, different package option
- **DMG2305UX** (Diodes Inc): Lower current rating but sufficient for bias switching

**Selection Rationale:** Low Rds(on) minimizes voltage drop in bias supply path. Logic-level gate compatible with 3.3V/5V control signals. SOT-23 package saves board space.

### 6. RF Input SMA Connector

**Primary Choice:** 142-0701-851 (Cinch Connectivity Solutions (Johnson))

*SMA female 50 ohm PCB jack, end launch, for 0.062 inch board thickness. Gold plated contacts.*

| Spec | Value |
|---|---|
| frequency | DC-18 GHz |
| impedance | 50 ohms |
| vswr | <1.3:1 |
| mounting | PCB end launch |
| package | SMA jack |

**Alternatives:**
- **32K234-40ML5** (TE Connectivity): Similar specs, different mounting footprint
- **0734120120** (Molex): Cost-optimized option, good performance to 6GHz

**Selection Rationale:** Industry-standard SMA connector for RF input. End-launch configuration provides controlled impedance transition to PCB. Excellent VSWR performance at 500MHz.

### 7. RF Output SMA Connector

**Primary Choice:** 142-0701-851 (Cinch Connectivity Solutions (Johnson))

*SMA female 50 ohm PCB jack, end launch, for 0.062 inch board thickness. Gold plated contacts.*

| Spec | Value |
|---|---|
| frequency | DC-18 GHz |
| impedance | 50 ohms |
| vswr | <1.3:1 |
| mounting | PCB end launch |
| package | SMA jack |

**Alternatives:**
- **32K234-40ML5** (TE Connectivity): Similar specs, different mounting footprint
- **0734120120** (Molex): Cost-optimized option, good performance to 6GHz

**Selection Rationale:** Same connector as input for BOM consolidation and manufacturing efficiency. Handles 10W RF power with margin.

### 8. EMI Input Filter + Reverse Protection

**Primary Choice:** B82786C0113N201 (TDK Electronics)

*SMT common mode choke for DC supply filtering, 100uH, 4A current rating. Combined with schottky diode for reverse protection.*

| Spec | Value |
|---|---|
| impedance | 100uH |
| current | 4A |
| dcr | 4 mOhm |
| package | SMT (10x12x5mm) |

**Alternatives:**
- **DLW32SN101SQ2L** (Murata): Lower current rating, smaller footprint
- **ACSL7320T-2R5P-N** (Toko): Higher inductance, larger package

**Selection Rationale:** Provides EMI filtering on DC supply line. 4A rating exceeds required 3.5A maximum current. Low DCR minimizes voltage drop.

### 9. 3.5A Fuse Holder + Fuse

**Primary Choice:** 0217005.HXP (Littelfuse)

*Surface mount fuse holder for 5x20mm fuse. Combined with 3.5A fast-acting fuse for overcurrent protection.*

| Spec | Value |
|---|---|
| current_rating | 3.5A |
| voltage_rating | 250V AC |
| package | SMT holder + 5x20mm fuse |

**Alternatives:**
- **NANO2 3.5A** (Bel Fuse): Direct SMT fuse, no holder needed, smaller footprint
- **MF-R0330** (Bourns): PTC resettable fuse, no replacement needed but higher trip time

**Selection Rationale:** Traditional fuse holder provides field serviceability. 3.5A rating protects supply source while allowing full power operation. Fast-acting characteristic provides rapid protection.

### 10. DC Power Input Terminal

**Primary Choice:** 1985804 (Phoenix Contact)

*2-position pluggable terminal block, 5.08mm pitch, supports up to 16AWG wire. rated for 10A.*

| Spec | Value |
|---|---|
| positions | 2 |
| pitch | 5.08mm |
| current | 10A |
| wire_gauge | 16-24 AWG |
| voltage | 320V |

**Alternatives:**
- **320050028** (Molex): Smaller pitch, lower current rating
- **OSTTE020104** (On Shore Technology): Lower cost option, lower voltage rating

**Selection Rationale:** Pluggable connector allows easy field installation and removal. 10A rating provides margin for 3.5A load. 5.08mm pitch provides spacing for safety clearances.
