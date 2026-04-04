# Logical Netlist
## rfgg

## Block Diagram

```mermaid
graph TB
    U1[QPA9226 (QPA9226)]
    U2[QPA9426 (QPA9426)]
    U3[LTC3780 (LTC3780)]
    U4[AD8318 (AD8318)]
    U5[LM555 (LM555)]
    U6[74LVC1G17 (74LVC1G17)]
    J1[SMA_Connector (SMA-EDGE-Launch)]
    J2[SMA_Connector (SMA-EDGE-Launch)]
    J3[Header_4Pin (HDR-4POS)]
    J4[Terminal_Block_2Pin (TB-2POS)]
    F1[Fuse (Fuse-15A)]
    D1[TVS_Diode (SMBJ15A)]
    Q1[MOSFET_P-Channel (Si7465DP)]
    Q2[MOSFET_P-Channel (Si7465DP)]
    L1[Inductor (4.7uH-10A)]
    L2[Inductor (4.7uH-10A)]
    C1[Capacitor (100pF-C0G)]
    C2[Capacitor (0.01uF-X7R)]
    C3[Capacitor (0.1uF-X7R)]
    C4[Capacitor (10uF-Tantalum)]
    C5[Capacitor (0.01uF-X7R)]
    C6[Capacitor (100pF-C0G)]
    C7[Capacitor (0.1uF-X7R)]
    C8[Capacitor (10uF-Tantalum)]
    C9[Capacitor (47uF-Electrolytic)]
    C10[Capacitor (47uF-Electrolytic)]
    C11[Capacitor (0.1uF-X7R)]
    C12[Capacitor (0.01uF-X7R)]
    C13[Capacitor (10uF-Tantalum)]
    C14[Capacitor (47uF-Electrolytic)]
    C15[Capacitor (0.1uF-X7R)]
    C16[Capacitor (0.01uF-X7R)]
    C17[Capacitor (1uF-Ceramic)]
    C18[Capacitor (0.1uF-Ceramic)]
    R1[Resistor (10k-0.25W)]
    R2[Resistor (100k-0.25W)]
    R3[Resistor (10k-0.25W)]
    R4[Resistor (100k-0.25W)]
    R5[Resistor (10k-0.25W)]
    R6[Resistor (100k-0.25W)]
    R7[Resistor (4.7k-0.25W)]
    R8[Resistor (10k-0.25W)]
    R9[Resistor (1k-0.25W)]
    R10[Resistor (52.3k-1%)]
    R11[Resistor (10k-1%)]
    R12[Resistor (1k-0.25W)]
    R13[Resistor (100-0.5W)]
    TP1[Test_Point (TP-1mm)]
    LED1[LED_Green (LED-GREEN)]
    J1 -->|RF_IN| C1
    C1 -->|RF_IN| U1
    U1 -->|RF_INTERSTAGE| C6
    C6 -->|RF_INTERSTAGE| U2
    U2 -->|RF_OUT_PA| C12
    C12 -->|RF_OUT_PA| TP1
    TP1 -->|RF_OUT_FILTERED| J2
    TP1 -->|RF_DET_IN| C17
    C17 -->|RF_DET_COUPLER| R13
    R13 -->|RF_DET_IN| U4
    J4 -->|VDD_12V| F1
    F1 -->|VDD_FUSED| D1
    D1 -->|VDD_PROTECTED| C9
    C9 -->|VDD_PROTECTED| Q1
    Q1 -->|VDD_PROTECTED| Q2
    Q2 -->|VDD_PROTECTED| U3
    U3 -->|VDD_PROTECTED| C10
    U3 -->|VDD_28V| L1
    L1 -->|VDD_28V| C11
    C11 -->|VDD_28V| Q1
    Q1 -->|VDD_PA1| U1
    Q1 -->|VDD_PA2| C2
    C2 -->|VDD_PA2| U2
    Q1 -->|VDD_GATE_DRV| Q2
    Q2 -->|VDD_GATE_DRV| C5
    C5 -->|VDD_GATE_DRV| U2
    Q2 -->|VDD_12V_LOGIC| R7
    J3 -->|TX_ENABLE| R9
    R9 -->|TX_ENABLE_FILT| U6
    U6 -->|TX_ENABLE_BUF| U5
    U5 -->|TX_ENABLE_BUF| R1
    R1 -->|DRV_GATE_CTRL| Q1
    Q1 -->|DRV_GATE_CTRL| R2
    U6 -->|FIN_GATE_CTRL| R5
    R5 -->|FIN_GATE_CTRL| Q2
    Q2 -->|FIN_GATE_CTRL| R6
    U5 -->|PA1_BIAS_REF| R3
    R3 -->|PA1_BIAS| U1
    U5 -->|PA2_BIAS_REF| R4
    R4 -->|PA2_BIAS_ADJ| U2
    U4 -->|VDET_OUT| R11
    R11 -->|VDET_FB| R10
    R10 -->|VDET_FB| U4
    R11 -->|DET_TELEMETRY| J3
    U3 -->|VBOOST_FB| L2
    L2 -->|VBOOST_FB| R8
    J4 -->|VSS| D1
    D1 -->|VSS| C9
    C9 -->|VSS| C10
    C10 -->|VSS| U3
    U3 -->|VSS| R2
    R2 -->|VSS| R6
    R6 -->|VSS| U1
    U1 -->|VSS| C3
    C3 -->|VSS| C4
    C4 -->|VSS| U2
    U2 -->|VSS| C7
    C7 -->|VSS| C8
    C8 -->|VSS| U4
    U4 -->|VSS| R10
    R10 -->|VSS| C18
    C18 -->|VSS| U5
    U5 -->|VSS| U6
    U6 -->|VSS| R13
    R13 -->|VSS| C15
    C15 -->|VSS| C16
    C16 -->|VSS| J2
    J2 -->|VSS| J1
    J1 -->|VSS| J3
    J3 -->|VSS| LED1
    U3 -->|VCC_3V3| R7
    R7 -->|VCC_3V3| U4
    U4 -->|VCC_3V3| C17
    C17 -->|VCC_3V3| U6
    U6 -->|VCC_3V3| C15
    C15 -->|VCC_3V3| U5
    U5 -->|VCC_3V3| C16
    R12 -->|LED_STATUS| LED1
    U6 -->|TX_ENABLE_BUF| R12
```

## Component Instances

| Ref | Part Number | Component |
|---|---|---|
| U1 | QPA9226 | QPA9226 |
| U2 | QPA9426 | QPA9426 |
| U3 | LTC3780 | LTC3780 |
| U4 | AD8318 | AD8318 |
| U5 | LM555 | LM555 |
| U6 | 74LVC1G17 | 74LVC1G17 |
| J1 | SMA-EDGE-Launch | SMA_Connector |
| J2 | SMA-EDGE-Launch | SMA_Connector |
| J3 | HDR-4POS | Header_4Pin |
| J4 | TB-2POS | Terminal_Block_2Pin |
| F1 | Fuse-15A | Fuse |
| D1 | SMBJ15A | TVS_Diode |
| Q1 | Si7465DP | MOSFET_P-Channel |
| Q2 | Si7465DP | MOSFET_P-Channel |
| L1 | 4.7uH-10A | Inductor |
| L2 | 4.7uH-10A | Inductor |
| C1 | 100pF-C0G | Capacitor |
| C2 | 0.01uF-X7R | Capacitor |
| C3 | 0.1uF-X7R | Capacitor |
| C4 | 10uF-Tantalum | Capacitor |
| C5 | 0.01uF-X7R | Capacitor |
| C6 | 100pF-C0G | Capacitor |
| C7 | 0.1uF-X7R | Capacitor |
| C8 | 10uF-Tantalum | Capacitor |
| C9 | 47uF-Electrolytic | Capacitor |
| C10 | 47uF-Electrolytic | Capacitor |
| C11 | 0.1uF-X7R | Capacitor |
| C12 | 0.01uF-X7R | Capacitor |
| C13 | 10uF-Tantalum | Capacitor |
| C14 | 47uF-Electrolytic | Capacitor |
| C15 | 0.1uF-X7R | Capacitor |
| C16 | 0.01uF-X7R | Capacitor |
| C17 | 1uF-Ceramic | Capacitor |
| C18 | 0.1uF-Ceramic | Capacitor |
| R1 | 10k-0.25W | Resistor |
| R2 | 100k-0.25W | Resistor |
| R3 | 10k-0.25W | Resistor |
| R4 | 100k-0.25W | Resistor |
| R5 | 10k-0.25W | Resistor |
| R6 | 100k-0.25W | Resistor |
| R7 | 4.7k-0.25W | Resistor |
| R8 | 10k-0.25W | Resistor |
| R9 | 1k-0.25W | Resistor |
| R10 | 52.3k-1% | Resistor |
| R11 | 10k-1% | Resistor |
| R12 | 1k-0.25W | Resistor |
| R13 | 100-0.5W | Resistor |
| TP1 | TP-1mm | Test_Point |
| LED1 | LED-GREEN | LED_Green |

## Connections

| Net | From | Pin | To | Pin | Type |
|---|---|---|---|---|---|
| RF_IN | J1 | SIG | C1 | 1 | RF |
| RF_IN | C1 | 2 | U1 | RF_IN | RF |
| RF_INTERSTAGE | U1 | RF_OUT | C6 | 1 | RF |
| RF_INTERSTAGE | C6 | 2 | U2 | RF_IN | RF |
| RF_OUT_PA | U2 | RF_OUT | C12 | 1 | RF |
| RF_OUT_PA | C12 | 2 | TP1 | SIG | RF |
| RF_OUT_FILTERED | TP1 | SIG | J2 | SIG | RF |
| RF_DET_IN | TP1 | SIG | C17 | 1 | RF |
| RF_DET_COUPLER | C17 | 2 | R13 | 1 | RF |
| RF_DET_IN | R13 | 2 | U4 | IN | RF |
| VDD_12V | J4 | 1 | F1 | 1 | power |
| VDD_FUSED | F1 | 2 | D1 | 1 | power |
| VDD_PROTECTED | D1 | 2 | C9 | 1 | power |
| VDD_PROTECTED | C9 | 1 | Q1 | S | power |
| VDD_PROTECTED | Q1 | S | Q2 | S | power |
| VDD_PROTECTED | Q2 | S | U3 | VIN | power |
| VDD_PROTECTED | U3 | VIN | C10 | 1 | power |
| VDD_28V | U3 | VOUT | L1 | 1 | power |
| VDD_28V | L1 | 1 | C11 | 1 | power |
| VDD_28V | C11 | 1 | Q1 | D | power |
| VDD_PA1 | Q1 | D | U1 | VDD | power |
| VDD_PA2 | Q1 | D | C2 | 1 | power |
| VDD_PA2 | C2 | 1 | U2 | VDD1 | power |
| VDD_GATE_DRV | Q1 | D | Q2 | D | power |
| VDD_GATE_DRV | Q2 | D | C5 | 1 | power |
| VDD_GATE_DRV | C5 | 1 | U2 | VGG | power |
| VDD_12V_LOGIC | Q2 | D | R7 | 1 | power |
| TX_ENABLE | J3 | 1 | R9 | 1 | digital |
| TX_ENABLE_FILT | R9 | 2 | U6 | A | digital |
| TX_ENABLE_BUF | U6 | Y | U5 | TRIG | digital |
| TX_ENABLE_BUF | U5 | TRIG | R1 | 1 | digital |
| DRV_GATE_CTRL | R1 | 2 | Q1 | G | digital |
| DRV_GATE_CTRL | Q1 | G | R2 | 2 | digital |
| FIN_GATE_CTRL | U6 | Y | R5 | 1 | digital |
| FIN_GATE_CTRL | R5 | 2 | Q2 | G | digital |
| FIN_GATE_CTRL | Q2 | G | R6 | 2 | digital |
| PA1_BIAS_REF | U5 | OUT | R3 | 1 | analog |
| PA1_BIAS | R3 | 2 | U1 | VGG | analog |
| PA2_BIAS_REF | U5 | THR | R4 | 1 | analog |
| PA2_BIAS_ADJ | R4 | 2 | U2 | BIAS_ADJ | analog |
| VDET_OUT | U4 | VOUT | R11 | 1 | analog |
| VDET_FB | R11 | 2 | R10 | 2 | analog |
| VDET_FB | R10 | 2 | U4 | VSET | analog |
| DET_TELEMETRY | R11 | 2 | J3 | 3 | analog |
| VBOOST_FB | U3 | FB | L2 | 1 | analog |
| VBOOST_FB | L2 | 1 | R8 | 1 | analog |
| VSS | J4 | 2 | D1 | 2 | ground |
| VSS | D1 | 2 | C9 | 2 | ground |
| VSS | C9 | 2 | C10 | 2 | ground |
| VSS | C10 | 2 | U3 | GND | ground |
| VSS | U3 | GND | R2 | 1 | ground |
| VSS | R2 | 1 | R6 | 1 | ground |
| VSS | R6 | 1 | U1 | GND | ground |
| VSS | U1 | GND | C3 | 2 | ground |
| VSS | C3 | 2 | C4 | 2 | ground |
| VSS | C4 | 2 | U2 | GND | ground |
| VSS | U2 | GND | C7 | 2 | ground |
| VSS | C7 | 2 | C8 | 2 | ground |
| VSS | C8 | 2 | U4 | GND | ground |
| VSS | U4 | GND | R10 | 1 | ground |
| VSS | R10 | 1 | C18 | 2 | ground |
| VSS | C18 | 2 | U5 | GND | ground |
| VSS | U5 | GND | U6 | GND | ground |
| VSS | U6 | GND | R13 | 2 | ground |
| VSS | R13 | 2 | C15 | 2 | ground |
| VSS | C15 | 2 | C16 | 2 | ground |
| VSS | C16 | 2 | J2 | GND | ground |
| VSS | J2 | GND | J1 | GND | ground |
| VSS | J1 | GND | J3 | 4 | ground |
| VSS | J3 | 4 | LED1 | CATHODE | ground |
| VCC_3V3 | U3 | INTVCC | R7 | 2 | power |
| VCC_3V3 | R7 | 2 | U4 | VPOS | power |
| VCC_3V3 | U4 | VPOS | C17 | 2 | power |
| VCC_3V3 | C17 | 2 | U6 | VCC | power |
| VCC_3V3 | U6 | VCC | C15 | 1 | power |
| VCC_3V3 | C15 | 1 | U5 | VCC | power |
| VCC_3V3 | U5 | VCC | C16 | 1 | power |
| LED_STATUS | R12 | 2 | LED1 | ANODE | digital |
| TX_ENABLE_BUF | U6 | Y | R12 | 1 | digital |

## Validation Notes

- CRITICAL: QPA9426 (U2) requires 28V nominal supply. Current LTC3780 boost converter (U3) configured for 12V→28V at 10A. Verify inductor saturation current rating >= 12A with margin.
- CRITICAL: TX_ENABLE signal (J3 pin 1) specified as 3.3V logic. U6 (74LVC1G17) provides 3.3V-compatible input threshold (Vih >= 2.0V). Confirm host system output voltage compliance.
- WARNING: Gate bias sequencing for U2 (QPA9426) requires VGG to be applied BEFORE VDD1 to prevent device damage. LM555 (U5) monostable timer provides ~10ms delay. Verify timing matches QPA9426 datasheet requirements.
- WARNING: RF detector AD8318 (U4) input coupling capacitor C17 (1uF) may be too large for 2.4 GHz. Consider reducing to 100pF-1000pF range or using DC blocking with appropriate reactance.
- WARNING: PA Enable MOSFETs Q1, Q2 are P-Channel devices. Ensure gate drive voltage (from U6) can fully turn OFF at Vdd=28V (Vgs_threshold check). 74LVC1G17 Voh=2.4V min may be insufficient for strong turn-off at 28V.
- NOTICE: Output test point TP1 provides RF detector tap and output monitoring. Insertion loss from C12/R13 coupler is ~0.5dB. Account for this in power budget.
- NOTICE: Boost converter feedback (U3 FB pin) sensed from post-inductor node via L2/R8 divider. Ensure compensation network values are calculated for 10A load with adequate phase margin (>45°).
- NOTICE: Decoupling: U1 has C2(0.01uF)/C3(0.1uF)/C4(10uF), U2 has C5(0.01uF)/C7(0.1uF)/C8(10uF). Recommended adding 1000pF C0G at each device VDD pin for optimal 2.4GHz decoupling.
- THERMAL: U2 (QPA9426) at 10W output will dissipate ~12-15W at 35-45% PAE. Requires copper area >= 400mm^2 or heatsink with thermal resistance < 2°C/W.
- THERMAL: U1 (QPA9226) at 2W output will dissipate ~3W. Requires thermal relief vias to ground plane.
- STABILITY: QPA9426 requires K-factor > 1 analysis. Ensure output matching network provides load stability margin (Gamma_L stability circle analysis required).
- EMI: Boost converter switching at 200kHz-2MHz may couple into RF path. Maintain >10mm separation between L1/L2 and RF traces. Use shielded inductors recommended.
- PROTECTION: F1 (15A fuse) protects against PA overcurrent. Consider adding fast-acting electronic current limit with <100us response time as per REQ-HW-012.
- CALIBRATION: AD8318 detector output requires temperature compensation for industrial range (-40 to +85°C). Consider adding NTC thermistor compensation network.
- HARMONIC: Output filter requirement (REQ-HW-010) for >30dBc suppression. Current netlist includes DC blocking only. Add Mini-Circuits HFCN-2400+ or equivalent between TP1 and J2.