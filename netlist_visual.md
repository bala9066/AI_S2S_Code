# Logical Netlist
## tf

## Block Diagram

```mermaid
graph TB
    U1[QPA2211D (QPA2211D)]
    J1[SMA_FEMALE_CONN (142-0701-801)]
    J2[SMA_FEMALE_CONN (142-0701-801)]
    C1[RF_DC_BLOCK_CAP (0402JA1H6R8CXTE)]
    C2[RF_DC_BLOCK_CAP (0402JA1H6R8CXTE)]
    C3[RF_DC_BLOCK_CAP (0402JA1H6R8CXTE)]
    C4[RF_DC_BLOCK_CAP (0402JA1H6R8CXTE)]
    L1[RF_MATCH_INDUCTOR (0402CS-3N9XJL)]
    L2[RF_MATCH_INDUCTOR (0402CS-3N9XJL)]
    L3[RF_MATCH_INDUCTOR (0402CS-3N9XJL)]
    L4[RF_MATCH_INDUCTOR (0402CS-3N9XJL)]
    C5[DC_DECOUPLE_4U7 (GRM32ER72A475KA35L)]
    C6[DC_DECOUPLE_4U7 (GRM32ER72A475KA35L)]
    C7[DC_DECOUPLE_100NF (GRM188R72A104KA35D)]
    C8[DC_DECOUPLE_100NF (GRM188R72A104KA35D)]
    R1[GATE_BIAS_RES (CRCW080510K0FKEA)]
    R2[ENABLE_PULLUP (CRCW080510K0FKEA)]
    R3[THERM_SENSE_RES (CRCW080510K0FKEA)]
    Q1[ENABLE_BJT_NPN (MMBT3904)]
    J3[DC_POWER_CONN (TB006-500-P02)]
    J4[CTRL_HEADER_3POS (M20-9980346)]
    TP1[TEST_POINT_RF (5001)]
    TP2[TEST_POINT_RF (5001)]
    FB1[FERRITE_BEAD_PWR (BLM21PG331SN1)]
    D1[ESD_PROTECT_TVSC (RSLIC06V24-4)]
    C9[DC_DECOUPLE_100NF (GRM188R72A104KA35D)]
    J1 -->|RF_INPUT_2G4| C1
    C1 -->|RF_IN_MATCH| L1
    L1 -->|RF_IN_MATCH| C3
    L1 -->|RF_IN_TO_PA| U1
    C3 -->|RF_IN_TO_PA| U1
    U1 -->|RF_IN_TEST| TP1
    U1 -->|RF_OUTPUT_2G4| L2
    L2 -->|RF_OUT_MATCH| L3
    L3 -->|RF_OUT_MATCH| C2
    C2 -->|RF_OUT_MATCH| L4
    L4 -->|RF_OUT_FINAL| C4
    C4 -->|RF_OUT_FINAL| J2
    C4 -->|RF_OUT_TEST| TP2
    J3 -->|VDD_12V_MAIN| FB1
    FB1 -->|VDD_12V_FILT| C5
    FB1 -->|VDD_12V_FILT| C7
    C5 -->|VDD_PA| U1
    C7 -->|VDD_PA| U1
    J3 -->|GND| C5
    C5 -->|GND| C7
    C7 -->|GND| U1
    U1 -->|GND| C6
    C6 -->|GND| C8
    C8 -->|GND| J1
    J1 -->|GND| J2
    J2 -->|GND| C1
    C1 -->|GND| C2
    C2 -->|GND| C3
    C3 -->|GND| C4
    C4 -->|GND| D1
    D1 -->|GND| R1
    R1 -->|GND| Q1
    Q1 -->|GND| C9
    C9 -->|GND| J4
    VDD_12V_FILT -->|VGG_BIAS_RAW| R1
    R1 -->|VGG_GATE| U1
    J4 -->|ENABLE_CTRL| R2
    R2 -->|ENABLE_PULLUP| VDD_12V_FILT
    R2 -->|ENABLE_DRIVE| Q1
    Q1 -->|ENABLE_PA| U1
    Q1 -->|ENABLE_PA| C6
    U1 -->|THERM_SENSE| R3
    R3 -->|THERM_STATUS| J4
    FB1 -->|VDD_AUX| C9
    C9 -->|VDD_AUX| C8
    J4 -->|ESD_CLAMP| D1
```

## Component Instances

| Ref | Part Number | Component |
|---|---|---|
| U1 | QPA2211D | QPA2211D |
| J1 | 142-0701-801 | SMA_FEMALE_CONN |
| J2 | 142-0701-801 | SMA_FEMALE_CONN |
| C1 | 0402JA1H6R8CXTE | RF_DC_BLOCK_CAP |
| C2 | 0402JA1H6R8CXTE | RF_DC_BLOCK_CAP |
| C3 | 0402JA1H6R8CXTE | RF_DC_BLOCK_CAP |
| C4 | 0402JA1H6R8CXTE | RF_DC_BLOCK_CAP |
| L1 | 0402CS-3N9XJL | RF_MATCH_INDUCTOR |
| L2 | 0402CS-3N9XJL | RF_MATCH_INDUCTOR |
| L3 | 0402CS-3N9XJL | RF_MATCH_INDUCTOR |
| L4 | 0402CS-3N9XJL | RF_MATCH_INDUCTOR |
| C5 | GRM32ER72A475KA35L | DC_DECOUPLE_4U7 |
| C6 | GRM32ER72A475KA35L | DC_DECOUPLE_4U7 |
| C7 | GRM188R72A104KA35D | DC_DECOUPLE_100NF |
| C8 | GRM188R72A104KA35D | DC_DECOUPLE_100NF |
| R1 | CRCW080510K0FKEA | GATE_BIAS_RES |
| R2 | CRCW080510K0FKEA | ENABLE_PULLUP |
| R3 | CRCW080510K0FKEA | THERM_SENSE_RES |
| Q1 | MMBT3904 | ENABLE_BJT_NPN |
| J3 | TB006-500-P02 | DC_POWER_CONN |
| J4 | M20-9980346 | CTRL_HEADER_3POS |
| TP1 | 5001 | TEST_POINT_RF |
| TP2 | 5001 | TEST_POINT_RF |
| FB1 | BLM21PG331SN1 | FERRITE_BEAD_PWR |
| D1 | RSLIC06V24-4 | ESD_PROTECT_TVSC |
| C9 | GRM188R72A104KA35D | DC_DECOUPLE_100NF |

## Connections

| Net | From | Pin | To | Pin | Type |
|---|---|---|---|---|---|
| RF_INPUT_2G4 | J1 | SIG | C1 | 1 | rf |
| RF_IN_MATCH | C1 | 2 | L1 | 1 | rf |
| RF_IN_MATCH | L1 | 1 | C3 | 1 | rf |
| RF_IN_TO_PA | L1 | 2 | U1 | RF_IN | rf |
| RF_IN_TO_PA | C3 | 2 | U1 | RF_IN | rf |
| RF_IN_TEST | U1 | RF_IN | TP1 | 1 | rf |
| RF_OUTPUT_2G4 | U1 | RF_OUT | L2 | 1 | rf |
| RF_OUT_MATCH | L2 | 2 | L3 | 1 | rf |
| RF_OUT_MATCH | L3 | 2 | C2 | 1 | rf |
| RF_OUT_MATCH | C2 | 1 | L4 | 1 | rf |
| RF_OUT_FINAL | L4 | 2 | C4 | 1 | rf |
| RF_OUT_FINAL | C4 | 2 | J2 | SIG | rf |
| RF_OUT_TEST | C4 | 2 | TP2 | 1 | rf |
| VDD_12V_MAIN | J3 | 1 | FB1 | 1 | power |
| VDD_12V_FILT | FB1 | 2 | C5 | 1 | power |
| VDD_12V_FILT | FB1 | 2 | C7 | 1 | power |
| VDD_PA | C5 | 1 | U1 | VDD | power |
| VDD_PA | C7 | 1 | U1 | VDD | power |
| GND | J3 | 2 | C5 | 2 | ground |
| GND | C5 | 2 | C7 | 2 | ground |
| GND | C7 | 2 | U1 | GND | ground |
| GND | U1 | GND | C6 | 2 | ground |
| GND | C6 | 2 | C8 | 2 | ground |
| GND | C8 | 2 | J1 | GND | ground |
| GND | J1 | GND | J2 | GND | ground |
| GND | J2 | GND | C1 | 2 | ground |
| GND | C1 | 2 | C2 | 2 | ground |
| GND | C2 | 2 | C3 | 2 | ground |
| GND | C3 | 2 | C4 | 2 | ground |
| GND | C4 | 2 | D1 | GND | ground |
| GND | D1 | GND | R1 | 2 | ground |
| GND | R1 | 2 | Q1 | E | ground |
| GND | Q1 | E | C9 | 2 | ground |
| GND | C9 | 2 | J4 | 2 | ground |
| VGG_BIAS_RAW | VDD_12V_FILT | 1 | R1 | 1 | power |
| VGG_GATE | R1 | 1 | U1 | VGG | power |
| ENABLE_CTRL | J4 | 1 | R2 | 1 | digital |
| ENABLE_PULLUP | R2 | 2 | VDD_12V_FILT | 1 | power |
| ENABLE_DRIVE | R2 | 1 | Q1 | B | digital |
| ENABLE_PA | Q1 | C | U1 | ENABLE | digital |
| ENABLE_PA | Q1 | C | C6 | 1 | digital |
| THERM_SENSE | U1 | THERM | R3 | 1 | analog |
| THERM_STATUS | R3 | 2 | J4 | 3 | analog |
| VDD_AUX | FB1 | 2 | C9 | 1 | power |
| VDD_AUX | C9 | 1 | C8 | 1 | power |
| ESD_CLAMP | J4 | 1 | D1 | IO | digital |

## Validation Notes

- **CRITICAL: PA Heatsinking Required** - QPA2211D dissipates ~8W at 10W output. Requires thermal pad to copper pour with multiple thermal vias to inner/bottom layers. Calculate junction temperature: Tj = Pd * RthJA + Ta. At 85°C ambient, RthJA must be <8°C/W to stay below 150°C.
- **Component thermal limit** - Inductor L4 in output path handles full RF current. Verify SRF >6GHz and power rating >3W. Consider 1008 or larger package if 0402 marginal.
- **Saturated Power margin** - QPA2211D Psat=40dBm exactly meets requirement, but no headroom for load VSWR mismatch. Consider adding 1-2dB attenuator pad before PA if source stability critical.
- **Enable timing** - Turn-on time spec (≤10µs) depends on C6 (4.7µF) and R2 (10k) RC time constant. Current τ = 47ms - EXCEEDS spec by 4700x. Reduce C6 to 100nF or R2 to 100Ω for <1µs response.
- **Power Supply budget** - At 45% PAE, 10W output requires 22W DC input. At 12V, this is 1.83A average. With 2.0:1 VSWR, peak current can exceed 3A. Ensure 12V source can deliver 4A peak.
- **Input Matching** - Single L-section (L1||C3) may be insufficient for optimum return loss. Consider π-network (series-L, shunt-C, series-L) for broader bandwidth and better VSWR control.
- **Output LPF not explicitly shown** - REQ-HW-010 requires 30dBc harmonic suppression. Output L-network (L2-L3-L4||C2) provides some filtering, but dedicated 5-element LPF recommended for 2nd/3rd harmonic suppression.
- **Gate Bias Resistor Power** - R1 (10k) drops ~5V at ~1mA = 5mW - safe for 0805 (125W rating). OK.
- **Ferrite Bead Selection** - BLM21PG331SN1 (330Ω @100MHz) rated for DC current. At 3A, verify impedance doesn't drop below 30Ω or saturation occurs. Consider power bead (5A rating).
- **ESD Protection on Enable Pin** - D1 protection on J4 pin1 good practice. Verify TVS clamping voltage (<5V) compatible with TTL input logic.
- **Thermal Shutdown** - R3 thermistor network provides analog temperature sense. U1 internal thermal protection at 150°C provides backup. Both required per REQ-HW-011.
- **Missing Current Limit** - No overcurrent protection shown. 3A max current requirement suggests need for polyfuse or electronic current limit on 12V input.
- **PCB Material** - RO4350B specified (εr=3.48). Verify trace width for 3A current (≥12mil for 1oz copper with 10°C rise). RF traces likely 50Ω microstrip (~24mil width on 30mil dielectric).
- **GPIO Pin Protection** - J4 exposed to external connection. D1 ESD protection needed. Series resistor (100Ω) recommended in addition to TVS for current limiting.
- **Stability Resistors** - No gate stopper resistor shown. Q1 collector series resistor (10-47Ω) recommended to prevent parasitic oscillation in enable line.
- **RF Test Points** - TP1 and TP2 provide VNA access. Ensure they are placed to minimize stub length (<λ/20 at 2.4GHz = 6mm) or use non-intrusive coupling.
- **Decoupling Placement** - C5 (4.7µF) and C7 (100nF) must be within 3mm of U1 VDD pin. C7 closest to device for high-frequency bypass.
- **Ground Return Paths** - All RF ground connections (J1, J2, U1 EPAD) must connect directly to ground plane with no shared paths with high-current DC return (J3 pin2).