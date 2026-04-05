# Logical Netlist
## hkgg

## Block Diagram

```mermaid
graph TB
    U1[GVA-123+ (GVA-123+)]
    Q1[MRF1511G (MRF1511G)]
    U2[MAX1167 (MAX1167)]
    Q2[IRLML6402 (IRLML6402)]
    J1[SMA_Female_Connector (SMA-F-50)]
    J2[SMA_Female_Connector (SMA-F-50)]
    J3[DC_Power_Terminal (TERMINAL-2POS)]
    T1[RF_Transformer_1:1 (TC1-1-13M+)]
    T2[RF_Transformer_4:1 (TC4-1W-150+)]
    T3[RF_Transformer_1:4 (TC1-4-150+)]
    L1[RF_Choke_Inductor (100nH_2A)]
    L2[Gate_Choke_Inductor (1uH_100mA)]
    L3[Drain_RFC (22nH_5A)]
    R1[Gate_Resistor (4.7_1W)]
    R2[Gate_Safety_Resistor (10_0.25W)]
    R3[Pull_Down_Resistor (10k_0.25W)]
    R4[Enable_Pullup_Resistor (10k_0.25W)]
    R5[I2C_Pullup_Resistor (4.7k_0.25W)]
    R6[I2C_Pullup_Resistor (4.7k_0.25W)]
    R7[DAC_Adjust_Resistor (10k_0.25W)]
    C1[Input_DC_Block (100pF_Ceramic)]
    C2[Driver_Decoupling (0.1uF_Ceramic)]
    C3[Driver_Decoupling_HF (1000pF_Ceramic)]
    C4[Interstage_DC_Block (470pF_Ceramic)]
    C5[Gate_Decoupling (0.1uF_Ceramic)]
    C6[Drain_Decoupling_Bulk (10uF_Tantalum)]
    C7[Drain_Decoupling_MF (1uF_Ceramic)]
    C8[Drain_Decoupling_HF (0.1uF_Ceramic)]
    C9[Output_DC_Block (470pF_Ceramic)]
    C10[Input_Capacitor (1uF_Ceramic)]
    C11[Logic_Decoupling (0.1uF_Ceramic)]
    C12[Input_Decoupling (10uF_Tantalum)]
    C13[Input_Decoupling_MF (0.1uF_Ceramic)]
    C14[Input_Decoupling_HF (1000pF_Ceramic)]
    D1[Schottky_Diode (SS34)]
    F1[PTC_Fuse (3.5A_Hold)]
    TP1[Test_Point (TP-1.5MM)]
    TP2[Test_Point (TP-1.5MM)]
    J1 -->|RF_IN| C1
    C1 -->|RF_IN_BLK| T1
    T1 -->|RF_DRIVER_IN| U1
    U1 -->|RF_DRIVER_OUT| T2
    T2 -->|RF_PA_IN_LOW| C4
    C4 -->|RF_PA_IN| Q1
    Q1 -->|RF_PA_OUT| T3
    T3 -->|RF_OUT_LOW| C9
    C9 -->|RF_OUT| J2
    J3 -->|DC_RAW| F1
    F1 -->|DC_FUSED| D1
    D1 -->|+12V_MAIN| C12
    C13 -->|+12V_DRIVER| L1
    L1 -->|DRV_VDD| U1
    L1 -->|+12V_DRAIN| L3
    L3 -->|PA_DRAIN| Q1
    D1 -->|+12V_LOGIC| Q2
    Q2 -->|DAC_VDD| C10
    C10 -->|+3.3V_REF| U2
    Q2 -->|BIAS_SW| L2
    L2 -->|GATE_BIAS_RAW| R2
    R2 -->|GATE_BIAS| R1
    R1 -->|PA_GATE| Q1
    U2 -->|DAC_OUT| R7
    R7 -->|BIAS_SET| Q2
    TP1 -->|ENABLE| R4
    R4 -->|ENABLE_CTRL| Q2
    TP2 -->|I2C_SDA| U2
    TP2 -->|I2C_SCL| U2
    J3 -->|GND| D1
    D1 -->|GND| C12
    C12 -->|GND| C13
    C13 -->|GND| C14
    C14 -->|GND| C2
    C2 -->|GND| C3
    C3 -->|GND| U1
    U1 -->|GND| T1
    T1 -->|GND| T2
    T2 -->|GND| T3
    T3 -->|GND| Q1
    Q1 -->|GND| C5
    C5 -->|GND| C6
    C6 -->|GND| C7
    C7 -->|GND| C8
    C8 -->|GND| U2
    U2 -->|GND| C11
    C11 -->|GND| C10
    C10 -->|GND| R3
    R3 -->|GND| R5
    R5 -->|GND| R6
    R5 -->|I2C_SDA_PU| U2
    R6 -->|I2C_SCL_PU| U2
    R1 -->|GATE_SAFETY| R3
```

## Component Instances

| Ref | Part Number | Component |
|---|---|---|
| U1 | GVA-123+ | GVA-123+ |
| Q1 | MRF1511G | MRF1511G |
| U2 | MAX1167 | MAX1167 |
| Q2 | IRLML6402 | IRLML6402 |
| J1 | SMA-F-50 | SMA_Female_Connector |
| J2 | SMA-F-50 | SMA_Female_Connector |
| J3 | TERMINAL-2POS | DC_Power_Terminal |
| T1 | TC1-1-13M+ | RF_Transformer_1:1 |
| T2 | TC4-1W-150+ | RF_Transformer_4:1 |
| T3 | TC1-4-150+ | RF_Transformer_1:4 |
| L1 | 100nH_2A | RF_Choke_Inductor |
| L2 | 1uH_100mA | Gate_Choke_Inductor |
| L3 | 22nH_5A | Drain_RFC |
| R1 | 4.7_1W | Gate_Resistor |
| R2 | 10_0.25W | Gate_Safety_Resistor |
| R3 | 10k_0.25W | Pull_Down_Resistor |
| R4 | 10k_0.25W | Enable_Pullup_Resistor |
| R5 | 4.7k_0.25W | I2C_Pullup_Resistor |
| R6 | 4.7k_0.25W | I2C_Pullup_Resistor |
| R7 | 10k_0.25W | DAC_Adjust_Resistor |
| C1 | 100pF_Ceramic | Input_DC_Block |
| C2 | 0.1uF_Ceramic | Driver_Decoupling |
| C3 | 1000pF_Ceramic | Driver_Decoupling_HF |
| C4 | 470pF_Ceramic | Interstage_DC_Block |
| C5 | 0.1uF_Ceramic | Gate_Decoupling |
| C6 | 10uF_Tantalum | Drain_Decoupling_Bulk |
| C7 | 1uF_Ceramic | Drain_Decoupling_MF |
| C8 | 0.1uF_Ceramic | Drain_Decoupling_HF |
| C9 | 470pF_Ceramic | Output_DC_Block |
| C10 | 1uF_Ceramic | Input_Capacitor |
| C11 | 0.1uF_Ceramic | Logic_Decoupling |
| C12 | 10uF_Tantalum | Input_Decoupling |
| C13 | 0.1uF_Ceramic | Input_Decoupling_MF |
| C14 | 1000pF_Ceramic | Input_Decoupling_HF |
| D1 | SS34 | Schottky_Diode |
| F1 | 3.5A_Hold | PTC_Fuse |
| TP1 | TP-1.5MM | Test_Point |
| TP2 | TP-1.5MM | Test_Point |

## Pin-to-Pin Connections

| Net | From | Pin | To | Pin | Type |
|---|---|---|---|---|---|
| RF_IN | J1 | 1 | C1 | 1 | RF |
| RF_IN_BLK | C1 | 2 | T1 | 1 | RF |
| RF_DRIVER_IN | T1 | 3 | U1 | 1 | RF |
| RF_DRIVER_OUT | U1 | 3 | T2 | 1 | RF |
| RF_PA_IN_LOW | T2 | 3 | C4 | 1 | RF |
| RF_PA_IN | C4 | 2 | Q1 | GATE | RF |
| RF_PA_OUT | Q1 | DRAIN | T3 | 1 | RF |
| RF_OUT_LOW | T3 | 3 | C9 | 1 | RF |
| RF_OUT | C9 | 2 | J2 | 1 | RF |
| DC_RAW | J3 | 1 | F1 | 1 | POWER |
| DC_FUSED | F1 | 2 | D1 | 1 | POWER |
| +12V_MAIN | D1 | 2 | C12 | 1 | POWER |
| +12V_DRIVER | C13 | 1 | L1 | 1 | POWER |
| DRV_VDD | L1 | 2 | U1 | 2 | POWER |
| +12V_DRAIN | L1 | 2 | L3 | 1 | POWER |
| PA_DRAIN | L3 | 2 | Q1 | DRAIN | POWER |
| +12V_LOGIC | D1 | 2 | Q2 | 2 | POWER |
| DAC_VDD | Q2 | 2 | C10 | 1 | POWER |
| +3.3V_REF | C10 | 1 | U2 | 4 | POWER |
| BIAS_SW | Q2 | 1 | L2 | 1 | POWER |
| GATE_BIAS_RAW | L2 | 2 | R2 | 1 | POWER |
| GATE_BIAS | R2 | 2 | R1 | 1 | POWER |
| PA_GATE | R1 | 2 | Q1 | GATE | BIAS |
| DAC_OUT | U2 | 1 | R7 | 1 | ANALOG |
| BIAS_SET | R7 | 2 | Q2 | 3 | ANALOG |
| ENABLE | TP1 | 1 | R4 | 1 | DIGITAL |
| ENABLE_CTRL | R4 | 2 | Q2 | 3 | DIGITAL |
| I2C_SDA | TP2 | 1 | U2 | 3 | DIGITAL |
| I2C_SCL | TP2 | 2 | U2 | 2 | DIGITAL |
| GND | J3 | 2 | D1 | 3 | GROUND |
| GND | D1 | 3 | C12 | 2 | GROUND |
| GND | C12 | 2 | C13 | 2 | GROUND |
| GND | C13 | 2 | C14 | 2 | GROUND |
| GND | C14 | 2 | C2 | 2 | GROUND |
| GND | C2 | 2 | C3 | 2 | GROUND |
| GND | C3 | 2 | U1 | 4 | GROUND |
| GND | U1 | 4 | T1 | 2 | GROUND |
| GND | T1 | 2 | T2 | 2 | GROUND |
| GND | T2 | 2 | T3 | 2 | GROUND |
| GND | T3 | 2 | Q1 | SOURCE | GROUND |
| GND | Q1 | SOURCE | C5 | 2 | GROUND |
| GND | C5 | 2 | C6 | 2 | GROUND |
| GND | C6 | 2 | C7 | 2 | GROUND |
| GND | C7 | 2 | C8 | 2 | GROUND |
| GND | C8 | 2 | U2 | 2 | GROUND |
| GND | U2 | 2 | C11 | 2 | GROUND |
| GND | C11 | 2 | C10 | 2 | GROUND |
| GND | C10 | 2 | R3 | 2 | GROUND |
| GND | R3 | 2 | R5 | 2 | GROUND |
| GND | R5 | 2 | R6 | 2 | GROUND |
| I2C_SDA_PU | R5 | 1 | U2 | 3 | DIGITAL |
| I2C_SCL_PU | R6 | 1 | U2 | 2 | DIGITAL |
| GATE_SAFETY | R1 | 2 | R3 | 1 | BIAS |

## Net Connection List

| Net Name | Reference Designator - Pin No. |
|----------|-------------------------------|
| +12V_DRAIN | L1 - 2,  L3 - 1 |
| +12V_DRIVER | C13 - 1,  L1 - 1 |
| +12V_LOGIC | D1 - 2,  Q2 - 2 |
| +12V_MAIN | D1 - 2,  C12 - 1 |
| +3.3V_REF | C10 - 1,  U2 - 4 |
| BIAS_SET | R7 - 2,  Q2 - 3 |
| BIAS_SW | Q2 - 1,  L2 - 1 |
| DAC_OUT | U2 - 1,  R7 - 1 |
| DAC_VDD | Q2 - 2,  C10 - 1 |
| DC_FUSED | F1 - 2,  D1 - 1 |
| DC_RAW | J3 - 1,  F1 - 1 |
| DRV_VDD | L1 - 2,  U1 - 2 |
| ENABLE | TP1 - 1,  R4 - 1 |
| ENABLE_CTRL | R4 - 2,  Q2 - 3 |
| GATE_BIAS | R2 - 2,  R1 - 1 |
| GATE_BIAS_RAW | L2 - 2,  R2 - 1 |
| GATE_SAFETY | R1 - 2,  R3 - 1 |
| GND | J3 - 2,  D1 - 3,  C12 - 2,  C13 - 2,  C14 - 2,  C2 - 2,  C3 - 2,  U1 - 4,  T1 - 2,  T2 - 2,  T3 - 2,  Q1 - SOURCE,  C5 - 2,  C6 - 2,  C7 - 2,  C8 - 2,  U2 - 2,  C11 - 2,  C10 - 2,  R3 - 2,  R5 - 2,  R6 - 2 |
| I2C_SCL | TP2 - 2,  U2 - 2 |
| I2C_SCL_PU | R6 - 1,  U2 - 2 |
| I2C_SDA | TP2 - 1,  U2 - 3 |
| I2C_SDA_PU | R5 - 1,  U2 - 3 |
| PA_DRAIN | L3 - 2,  Q1 - DRAIN |
| PA_GATE | R1 - 2,  Q1 - GATE |
| RF_DRIVER_IN | T1 - 3,  U1 - 1 |
| RF_DRIVER_OUT | U1 - 3,  T2 - 1 |
| RF_IN | J1 - 1,  C1 - 1 |
| RF_IN_BLK | C1 - 2,  T1 - 1 |
| RF_OUT | C9 - 2,  J2 - 1 |
| RF_OUT_LOW | T3 - 3,  C9 - 1 |
| RF_PA_IN | C4 - 2,  Q1 - GATE |
| RF_PA_IN_LOW | T2 - 3,  C4 - 1 |
| RF_PA_OUT | Q1 - DRAIN,  T3 - 1 |

## Validation Notes

- CRITICAL: LDMOS device (MRF1511G) requires NEGATIVE gate bias for proper Class AB operation. Current netlist shows positive gate drive - MUST revise to use negative bias generator (-3V to -5V) or add bias tee network
- WARNING: Single +12V supply operation for MRF1511G provides marginal output power. Device PSAT of +41dBm (12W) at +12V may drop to +38-39dBm (6-8W) at lower end of frequency range
- RECOMMENDED: Add RF direction detector or coupler for VSWR protection to meet REQ-HW-012 (reverse power protection)
- NOTE: Driver-to-PA impedance matching (T2: 4:1 step-down) is approximate. Final values require Smith chart optimization based on PCB parasitics
- NOTE: PA output matching (T3: 1:4 step-up) assumes 12.5Ω opt. load. May need adjustment for flat gain across 50-500MHz
- THERMAL: MRF1511G requires θJC ≤ 2°C/W heatsink at 10W output. Estimated junction temp rise is ~80°C without heatsinking - MUST provide thermal pad per REQ-HW-008
- CHECK: Gate resistor R1 (4.7Ω) value depends on LDMOS input impedance. Typical range is 2-10Ω for stability
- RECOMMENDED: Add ferrite beads on DAC supply and I2C lines to reduce RF coupling into control circuitry
- STABILITY: Low-value source inductance (via PCB trace) recommended for MRF1511G stability. Ensure source connects directly to ground plane with multiple vias
- FERRITE: Consider adding ferrite bead on +12V input to reduce conducted EMI from PA switching currents
- HARMONICS: Output low-pass filter recommended to meet REQ-HW-010 (-30dBc harmonics). Current design relies on PA output matching only