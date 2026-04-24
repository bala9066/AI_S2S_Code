# Component Recommendations
## yhh

### 1. Low-noise amplifier per balanced pair arm (2 per channel, 8 total) covering 6-26.5 GHz with high gain and low noise figure

**Primary Choice:** [PMA4-6263LN+](https://www.digikey.com/en/products/result?keywords=PMA4-6263LN%2B) (Mini-Circuits)

*SMT MMIC Low-Noise Wideband Amplifier, 6 to 26.5 GHz, 50 ohm, QFN package*

[🔗 DigiKey](https://www.digikey.com/en/products/result?keywords=PMA4-6263LN%2B)  [🔗 Mouser](https://www.mouser.in/ProductDetail/Mini-Circuits/PMA4-6263LN%2b?qs=%252BXxaIXUDbq0EdEUzeTu0pg%3D%3D)

*Distributor data:* source: mouser

| Spec | Value |
|---|---|
| Frequency | 6 - 26.5 GHz |
| Gain | 22 dB typ at 18 GHz |
| Noise_Figure | 2.5 dB typ at 18 GHz |
| P1dB_Output | +14 dBm typ |
| OIP3 | +26 dBm typ |
| Supply | +5V / 100 mA |
| Package | 4mm QFN |

**Alternatives:**
- **[PMA3-15453+](https://www.digikey.com/en/products/result?keywords=PMA3-15453%2B)** (Mini-Circuits): Covers 15-45 GHz (full band) but higher NF (4.5 dB) and lower gain (15 dB). Use as gain block / driver stage.

**Selection Rationale:** Closest match to 18-40 GHz requirement. Covers 6-26.5 GHz with excellent NF of 2.5 dB and 22 dB gain. For full 40 GHz coverage, pair with PMA3-15453+ (15-45 GHz) as gain block. Note: user requested SiGe BiCMOS but no SiGe LNA covers full 18-40 GHz band — GaAs pHEMT is the practical choice at this frequency.

### 2. Ka-band gain block / driver amplifier per channel (15-45 GHz), used for stages 2 and 3 after the balanced LNA

**Primary Choice:** [PMA3-15453+](https://www.digikey.com/en/products/result?keywords=PMA3-15453%2B) (Mini-Circuits)

*SMT Gain Block Amplifier, 15 to 45 GHz, 50 ohm, QFN package*

[🔗 DigiKey](https://www.digikey.com/en/products/result?keywords=PMA3-15453%2B)  [🔗 Mouser](https://www.mouser.in/ProductDetail/Mini-Circuits/PMA3-15453%2b?qs=OcgtsXO%252B3gt5FNQmM1B%2FKA%3D%3D)

*Distributor data:* source: mouser

| Spec | Value |
|---|---|
| Frequency | 15 - 45 GHz |
| Gain | 15 dB typ at 29 GHz |
| Noise_Figure | 4.5 dB typ |
| P1dB_Output | +10 dBm typ |
| OIP3 | +20 dBm typ |
| Supply | +5V / 80 mA |
| Package | QFN |

**Alternatives:**
- **[QPA2225](https://www.digikey.com/en/products/result?keywords=QPA2225)** (Qorvo): 32-38 GHz only (narrower band), higher power (0.5W), GaN. Could be used for specific Ka-band sub-bands.

**Selection Rationale:** Only candidate covering the full 15-45 GHz range. Used as post-LNA gain block and driver amplifier. Two stages per channel provide 30 dB additional gain.

### 3. PIN diode limiter for front-end protection (1 per channel, 4 total). Survives +30 dBm, limits output to +15 dBm

**Primary Choice:** [CLA4611-085LF](https://www.digikey.com/en/products/result?keywords=CLA4611-085LF) (Skyworks Solutions, Inc.)

*PIN Limiter Diode, 0.25 pF junction capacitance, -40 to +150 C, SMT*

[🔗 DigiKey](https://www.digikey.com/en/products/result?keywords=CLA4611-085LF)  [🔗 Mouser](https://www.mouser.in/ProductDetail/Skyworks-Solutions-Inc/CLA4611-085LF?qs=Xy3FNZO%2FEu%2F0byCwjTRihw%3D%3D)

*Distributor data:* source: mouser

| Spec | Value |
|---|---|
| Junction_Capacitance | 0.25 pF |
| Insertion_Loss | < 0.3 dB small signal |
| Threshold | +10 to +15 dBm |
| Max_CW_Power | +30 dBm (with heatsink) |
| Recovery_Time | < 1 us |
| Package | SMT (0805) |
| Temp_Range | -40 to +150 C |

**Alternatives:**
- **[CLA4607-085LF](https://www.digikey.com/en/products/result?keywords=CLA4607-085LF)** (Skyworks Solutions, Inc.): Higher capacitance (0.35 pF) limits upper frequency performance but higher power handling.

**Selection Rationale:** Low capacitance (0.25 pF) enables broadband operation through 40 GHz. Handles +30 dBm survivability. Requires shunt-mounted circuit design with quarter-wave stub.

### 4. Ceramic preselector bandpass filter between limiter and LNA (1 per channel, 4 total). Also used as interstage BPF for high-gain stability (4 additional)

**Primary Choice:** [BFCN-1840+](https://www.digikey.com/en/products/result?keywords=BFCN-1840%2B) (Mini-Circuits)

*Ceramic Bandpass Filter, 18-40 GHz passband, surface mount*

[🔗 DigiKey](https://www.digikey.com/en/products/result?keywords=BFCN-1840%2B)  [🔗 Mouser](https://www.mouser.in/ProductDetail/Mini-Circuits/BFCN-1840%2b?qs=xZ%2FP%252Ba9zWqYAfeov1eIWJg%3D%3D)

*Distributor data:* source: mouser

| Spec | Value |
|---|---|
| Frequency_Range | 18 - 40 GHz |
| Passband_IL | 1.5 dB typ |
| Stopband_Rejection | > 20 dB |
| VSWR | 1.5:1 |
| Package | SMT ceramic |
| Power_Handling | +20 dBm |

**Alternatives:**
- **[XM-A163-0204D](https://www.digikey.com/en/products/result?keywords=XM-A163-0204D)** (Quantic X-Microwave): Module format based on BFCN-1840+, easier prototyping on X-Microwave platform but larger footprint.

**Selection Rationale:** Exact frequency match for the 18-40 GHz requirement. Ceramic technology as specified by user. SMT package suitable for compact multi-channel layout. Used 8 total: 4 preselector + 4 interstage.

### 5. T/R protection SPDT switch (1 per channel, 4 total). Isolates front-end during TX pulses, < 10 us switching

**Primary Choice:** [QPC2420SR](https://www.digikey.com/en/products/result?keywords=QPC2420SR) (Qorvo)

*SPDT RF Switch, 0.02 to 30 GHz, reflective, high power handling*

[🔗 DigiKey](https://www.digikey.com/en/products/result?keywords=QPC2420SR)  [🔗 Mouser](https://www.mouser.in/ProductDetail/Qorvo/QPC2420SR?qs=Q%2F5vwRdkjWJ3fSOW8ZA%2FtA%3D%3D)

*Distributor data:* source: mouser

| Spec | Value |
|---|---|
| Frequency | 0.02 - 30 GHz |
| Insertion_Loss | 1.5 dB typ |
| Isolation | 35 dB typ |
| Switching_Time | < 5 us |
| Power_Handling | +33 dBm CW |
| Control | 0/-5V TTL compatible |

**Alternatives:**
- **[QPC2320SR](https://www.digikey.com/en/products/result?keywords=QPC2320SR)** (Qorvo): 0.02-15 GHz only (does not cover full band), but lower cost and proven.

**Selection Rationale:** Covers 20 MHz to 30 GHz. Best available SPDT switch for this frequency range. Note: Above 30 GHz, isolation may degrade — characterize at 30-40 GHz or use limiter as primary protection above 30 GHz.

### 6. 4-way power splitter/combiner for monopulse comparator network. Combines 4 channel outputs into Sum and 3 Delta outputs

**Primary Choice:** [SCA-4-132+](https://www.digikey.com/en/products/result?keywords=SCA-4-132%2B) (Mini-Circuits)

*4-way power splitter/combiner, SMT, 50 ohm*

[🔗 DigiKey](https://www.digikey.com/en/products/result?keywords=SCA-4-132%2B)  [🔗 Mouser](https://www.mouser.in/ProductDetail/Mini-Circuits/SCA-4-132%2b?qs=xZ%2FP%252Ba9zWqYbGiqGHr1ctg%3D%3D)

*Distributor data:* source: mouser

| Spec | Value |
|---|---|
| Frequency | 3 - 3200 MHz (internal use for monopulse) |
| Insertion_Loss | 0.5 dB above theoretical (6 dB) |
| Isolation | > 20 dB |
| Amplitude_Balance | +/-0.3 dB |
| Phase_Balance | +/-3 deg |
| Package | SMT |

**Alternatives:**
- **[BP4U1+](https://www.digikey.com/en/products/result?keywords=BP4U1%2B)** (Mini-Circuits): Alternative 4-way splitter with different frequency range and package.

**Selection Rationale:** 4-way splitter/combiner used in monopulse comparator configuration. Multiple units combined to form Sigma/Delta-EL/Delta-AZ/Delta-Delta outputs. Note: Monopulse comparator is typically implemented as a network of 2-way hybrids (3 hybrids for 4 inputs) — SCA-4-132+ provides the building blocks. For 18-40 GHz monopulse, the comparator must be implemented in PCB as broadband 90-degree couplers.

### 7. DC-DC buck converter from +28V MIL bus to +5V rail for LNA and gain block bias supplies

**Primary Choice:** [TPS54531DDA](https://www.digikey.com/en/products/result?keywords=TPS54531DDA) (Texas Instruments)

*3.5-28V Input, 5A, 570 kHz Synchronous Step-Down Converter*

[🔗 DigiKey](https://www.digikey.com/en/products/result?keywords=TPS54531DDA)  [🔗 Mouser](https://www.mouser.in/ProductDetail/Texas-Instruments/TPS54531DDA?qs=jA5Ki6243omoJVKISZs%2FBg%3D%3D)

*Distributor data:* source: mouser

| Spec | Value |
|---|---|
| Input_Voltage | 3.5 - 28 V |
| Output_Voltage | Adjustable (set to 5.0V) |
| Max_Output_Current | 5 A |
| Switching_Frequency | 570 kHz |
| Efficiency | > 90% at 5V/3A |
| Package | 8-SO PowerPAD |

**Alternatives:**
- **[BD9F800MUX-ZE2](https://www.digikey.com/en/products/result?keywords=BD9F800MUX-ZE2)** (ROHM Semiconductor): 4-28V, 8A synchronous buck. Higher current capability but slightly more complex design.

**Selection Rationale:** Accepts +28V directly (max input 28V). Provides 5A output at 5V — sufficient for all 4 channels. High efficiency (>90%) minimizes thermal load. PowerPAD package for thermal management.
