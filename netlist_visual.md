# Logical Netlist
## rf78

## Block Diagram

```mermaid
graph TB
    J1[RF Input Connector (SMA-EDGE-50)]
    RM1[Input Matching Network (MATCH-NET-50-2.4G)]
    U1[RF Driver Amplifier (MGA-43016)]
    RM2[Interstage Matching Network (MATCH-NET-INTER-2.4G)]
    U2[GaN Final Power Amplifier (CGRM2812)]
    U3[Directional Coupler (ACB4-50-4000+)]
    RM3[Output Matching Network (MATCH-NET-OUT-2.4G-LPF)]
    J2[RF Output Connector (SMA-EDGE-50)]
    U4[RF Power Detector (Forward) (AD8318)]
    U5[RF Power Detector (Reverse) (AD8318)]
    U6[Temperature Sensor (TMP235)]
    U7[Dual Comparator (LM393)]
    U8[Bias Sequencer Timer (LM555)]
    Q1[Driver Bias MOSFET (BSS138)]
    Q2[PA Enable MOSFET (BSS138)]
    Q3[28V PA Power Switch (IRLML6401)]
    J3[DC Supply Input (TB-2PIN-5.08)]
    J4[Control Interface (HDR-1X3-2.54)]
    R1[Gate Resistor - Driver (ERA-3AEB1001V)]
    R2[Gate Resistor - PA (ERA-3AEB1001V)]
    R3[Timing Resistor - Sequencer (ERA-3AEB2202V)]
    C1[Decoupling - Driver 5V (GRM32ER71H106KA88L)]
    C2[Decoupling - PA Gate (GRM32ER71H106KA88L)]
    C3[Decoupling - Detector 5V (GRM32ER71H106KA88L)]
    C4[Bulk Capacitor - 28V (C3216X7R1H105K)]
    J1 -->|RF_IN| RM1
    RM1 -->|RF_DRV_IN| U1
    U1 -->|RF_DRV_OUT| RM2
    RM2 -->|RF_PA_IN| U2
    U2 -->|RF_PA_OUT| U3
    U3 -->|RF_FWD_CPL| U4
    U3 -->|RF_REV_CPL| U5
    U3 -->|RF_OUT_MAIN| RM3
    RM3 -->|RF_FINAL_OUT| J2
    U4 -->|V_FWD_DET| U7
    U5 -->|V_REV_DET| U7
    U6 -->|V_TEMP| U7
    U7 -->|FAULT_FLAG| U8
    J4 -->|TX_ENABLE| U8
    U8 -->|DRV_ENABLE| Q1
    U8 -->|PA_ENABLE_5V| Q2
    Q1 -->|DRV_BIAS| U1
    Q2 -->|PA_SWITCH_CTRL| Q3
    Q3 -->|VCC_28V_PA| U2
    P5V -->|VCC_5V| U1
    P5V -->|VCC_5V| U4
    P5V -->|VCC_5V| U5
    P5V -->|VCC_5V| U8
    P5V -->|VCC_5V| C1
    P5V -->|VCC_5V| C3
    P33V -->|VCC_3V3| U6
    P33V -->|VCC_3V3| U7
    J3 -->|VCC_28V_MAIN| Q3
    J3 -->|VCC_28V_MAIN| C4
    U1 -->|GND| GND
    U2 -->|GND| GND
    U3 -->|GND| GND
    U4 -->|GND| GND
    U5 -->|GND| GND
    U6 -->|GND| GND
    U7 -->|GND| GND
    U8 -->|GND| GND
    J3 -->|GND| GND
    C1 -->|GND| GND
    C2 -->|GND| GND
    C3 -->|GND| GND
    C4 -->|GND| GND
    Q1 -->|GATE_R1| R1
    R1 -->|GATE_R1| DRV_ENABLE
    Q2 -->|GATE_R2| R2
    R2 -->|GATE_R2| PA_ENABLE_5V
    U8 -->|TIMING_R3| R3
    R3 -->|TIMING_R3| DISCH
```

## Component Instances

| Ref | Part Number | Component |
|---|---|---|
| J1 | SMA-EDGE-50 | RF Input Connector |
| RM1 | MATCH-NET-50-2.4G | Input Matching Network |
| U1 | MGA-43016 | RF Driver Amplifier |
| RM2 | MATCH-NET-INTER-2.4G | Interstage Matching Network |
| U2 | CGRM2812 | GaN Final Power Amplifier |
| U3 | ACB4-50-4000+ | Directional Coupler |
| RM3 | MATCH-NET-OUT-2.4G-LPF | Output Matching Network |
| J2 | SMA-EDGE-50 | RF Output Connector |
| U4 | AD8318 | RF Power Detector (Forward) |
| U5 | AD8318 | RF Power Detector (Reverse) |
| U6 | TMP235 | Temperature Sensor |
| U7 | LM393 | Dual Comparator |
| U8 | LM555 | Bias Sequencer Timer |
| Q1 | BSS138 | Driver Bias MOSFET |
| Q2 | BSS138 | PA Enable MOSFET |
| Q3 | IRLML6401 | 28V PA Power Switch |
| J3 | TB-2PIN-5.08 | DC Supply Input |
| J4 | HDR-1X3-2.54 | Control Interface |
| R1 | ERA-3AEB1001V | Gate Resistor - Driver |
| R2 | ERA-3AEB1001V | Gate Resistor - PA |
| R3 | ERA-3AEB2202V | Timing Resistor - Sequencer |
| C1 | GRM32ER71H106KA88L | Decoupling - Driver 5V |
| C2 | GRM32ER71H106KA88L | Decoupling - PA Gate |
| C3 | GRM32ER71H106KA88L | Decoupling - Detector 5V |
| C4 | C3216X7R1H105K | Bulk Capacitor - 28V |

## Connections

| Net | From | Pin | To | Pin | Type |
|---|---|---|---|---|---|
| RF_IN | J1 | SIG | RM1 | IN | RF |
| RF_DRV_IN | RM1 | OUT | U1 | RF_IN | RF |
| RF_DRV_OUT | U1 | RF_OUT | RM2 | IN | RF |
| RF_PA_IN | RM2 | OUT | U2 | GATE | RF |
| RF_PA_OUT | U2 | DRAIN | U3 | IN | RF_POWER |
| RF_FWD_CPL | U3 | FWD | U4 | RF_IN | RF_COUPLED |
| RF_REV_CPL | U3 | REV | U5 | RF_IN | RF_COUPLED |
| RF_OUT_MAIN | U3 | OUT | RM3 | IN | RF_POWER |
| RF_FINAL_OUT | RM3 | OUT | J2 | SIG | RF |
| V_FWD_DET | U4 | VOUT | U7 | IN_A+ | ANALOG |
| V_REV_DET | U5 | VOUT | U7 | IN_B+ | ANALOG |
| V_TEMP | U6 | OUT | U7 | IN_C+ | ANALOG |
| FAULT_FLAG | U7 | OUT_A | U8 | RST | DIGITAL |
| TX_ENABLE | J4 | PIN1 | U8 | TRIG | DIGITAL |
| DRV_ENABLE | U8 | OUT | Q1 | GATE | DIGITAL |
| PA_ENABLE_5V | U8 | DISCH | Q2 | GATE | DIGITAL |
| DRV_BIAS | Q1 | DRAIN | U1 | ENABLE | POWER |
| PA_SWITCH_CTRL | Q2 | DRAIN | Q3 | GATE | POWER |
| VCC_28V_PA | Q3 | DRAIN | U2 | DRAIN | POWER |
| VCC_5V | P5V | SOURCE | U1 | VDD | POWER |
| VCC_5V | P5V | SOURCE | U4 | VPOS | POWER |
| VCC_5V | P5V | SOURCE | U5 | VPOS | POWER |
| VCC_5V | P5V | SOURCE | U8 | VCC | POWER |
| VCC_5V | P5V | SOURCE | C1 | PIN1 | POWER |
| VCC_5V | P5V | SOURCE | C3 | PIN1 | POWER |
| VCC_3V3 | P33V | SOURCE | U6 | VDD | POWER |
| VCC_3V3 | P33V | SOURCE | U7 | VCC | POWER |
| VCC_28V_MAIN | J3 | PIN1 | Q3 | SOURCE | POWER |
| VCC_28V_MAIN | J3 | PIN1 | C4 | PIN1 | POWER |
| GND | U1 | GND | GND | PLANES | GROUND |
| GND | U2 | SOURCE | GND | PLANES | GROUND |
| GND | U3 | GND | GND | PLANES | GROUND |
| GND | U4 | GND | GND | PLANES | GROUND |
| GND | U5 | GND | GND | PLANES | GROUND |
| GND | U6 | GND | GND | PLANES | GROUND |
| GND | U7 | GND | GND | PLANES | GROUND |
| GND | U8 | GND | GND | PLANES | GROUND |
| GND | J3 | PIN2 | GND | PLANES | GROUND |
| GND | C1 | PIN2 | GND | PLANES | GROUND |
| GND | C2 | PIN2 | GND | PLANES | GROUND |
| GND | C3 | PIN2 | GND | PLANES | GROUND |
| GND | C4 | PIN2 | GND | PLANES | GROUND |
| GATE_R1 | Q1 | GATE | R1 | PIN1 | SIGNAL |
| GATE_R1 | R1 | PIN2 | DRV_ENABLE | NET | SIGNAL |
| GATE_R2 | Q2 | GATE | R2 | PIN1 | SIGNAL |
| GATE_R2 | R2 | PIN2 | PA_ENABLE_5V | NET | SIGNAL |
| TIMING_R3 | U8 | THR | R3 | PIN1 | SIGNAL |
| TIMING_R3 | R3 | PIN2 | DISCH | NET | SIGNAL |

## Validation Notes

- CRITICAL: QPF4528 datasheet shows +28 dBm P1dB at 3.3-5V, incompatible with 10W (40 dBm) requirement. CGRM2812 GaN is correct choice for final stage.
- CRITICAL: CGRM2812 may require negative gate bias or specific Vgs threshold. Verify datasheet and add negative rail if needed.
- CRITICAL: 5V control (Q2) switching 28V PA gate inadequate. Use gate driver IC or level-shifter for 28V rail-to-rail.
- WARNING: VSWR foldback logic undefined. Define comparator reference voltages for 2:1 (10.5 dB) and 3:1 (6 dB) return loss thresholds.
- WARNING: Stability components (RC feedback, gate resistors) not fully specified. Add per CGRM2812 datasheet for K-factor > 1.
- WARNING: Harmonic filtering not included. Output matching network should include LPF for <-30 dBc harmonics.
- WARNING: Decoupling capacitor values placeholder. Add 100nF ceramic + 10uF bulk at each IC supply pin.
- WARNING: Matching networks (RM1, RM2, RM3) require EM simulation (ADS/HFSS) for 2.4-2.4835 GHz band.
- WARNING: Reverse polarity protection missing. Add Schottky diode OR-ing or MOSFET protection at J3.
- WARNING: Thermal management requires heatsink interface. 56W dissipation needs thermal vias and copper pour.
- INFO: Driver stage MGA-43016 gain 28 dB, P1dB +20 dBm adequate to drive CGRM2812.
- INFO: AD8318 bandwidth 8 GHz exceeds 2.4 GHz requirement.
- INFO: ACB4-50-4000+ directivity >15 dB adequate for VSWR measurement.
- INFO: TMP235 range -40 to +150C covers operating range + shutdown margin.
- INFO: BLE linearity (EVM < 3%) requires characterization. May need backoff from 40 dBm.