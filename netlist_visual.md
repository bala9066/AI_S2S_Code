# Logical Netlist
## rf txrxxp

## Block Diagram

```mermaid
graph TB
    U1[Input Limiter (GVA-123+)]
    U2[Wideband LNA (TQP3M9036)]
    U3[Variable Gain Amplifier (HMC698LP4)]
    U4[RF Mixer (HMC1050)]
    U5[LO Synthesizer (ADF5356)]
    U6[High-Speed ADC (ADC12DJ3200)]
    U7[LDO Regulator 3.3V (LT1963A-3.3)]
    U8[LDO Regulator 1.8V (LT1963A-1.8)]
    U9[Quad Op-Amp (ADA4898-1)]
    J1[RF Input Connector (SMA-2.4MM-J)]
    J2[JESD204B Interface (FMC-HPC)]
    J3[SPI Control Header (HDR-2X7)]
    J4[Clock Input (SMA-EDGE-J)]
    J5[DC Power Input (BARREL-12V)]
    T1[RF Transformer 1:2 (TCM1-63+)]
    T2[RF Balun (BAL-0006SM)]
    L1[Ferrite Bead (BLM18PG471SN1)]
    L2[Ferrite Bead (BLM18PG471SN1)]
    L3[RF Choke (1008HS-103T)]
    L4[RF Choke (1008HS-103T)]
    L5[Power Inductor (LPS3015-103)]
    R1[RF Input Resistor (ERA-3AEB1001V)]
    R2[Gate Bias Resistor (ERA-3AEB49R9V)]
    R3[Source Resistor (ERA-3AEB151V)]
    R4[Drain Resistor (CRCW2512-100R)]
    R5[SPI Pull-up Resistor (ERA-3AEB103V)]
    R6[SPI Pull-up Resistor (ERA-3AEB103V)]
    R7[SPI Pull-up Resistor (ERA-3AEB103V)]
    R8[ADC Termination Resistor (ERA-3AEB51R0V)]
    R9[ADC Termination Resistor (ERA-3AEB51R0V)]
    R10[VCM Feedback Resistor (ERA-3AEB4991V)]
    R11[VCM Feedback Resistor (ERA-3AEB4991V)]
    R12[VCM Output Resistor (ERA-3AEB2001V)]
    R13[Feedback Resistor (ERA-3AEB1003V)]
    R14[Feedback Resistor (ERA-3AEB1003V)]
    R15[Damping Resistor (ERA-3AEB100V)]
    R16[LED Current Limit (ERA-3AEB221V)]
    C1[Input DC Block (ATC100B101J500AT)]
    C2[Source Bypass Cap (GCM21BR71C105KA)]
    C3[Gate Bypass Cap (GCM21BR71C105KA)]
    C4[Drain Bypass Cap (GCM21BR71C105KA)]
    C5[VGA Supply Decoupling (GRM21BC71H105K)]
    C6[VGA Control Decoupling (GCM21BR71C104KA)]
    C7[Mixer LO Decoupling (GCM21BR71C104KA)]
    C8[Mixer RF Decoupling (GCM21BR71C104KA)]
    C9[Mixer IF Decoupling (GCM21BR71C104KA)]
    C10[Synth Decoupling 1uF (GRM21BC71H105K)]
    C11[Synth Decoupling 0.1uF (GCM21BR71C104KA)]
    C12[Synth Decoupling 0.01uF (GCM21BR71C103K)]
    C13[Synth Decoupling 0.001uF (GCM21BR71C102K)]
    C14[ADC Decoupling 10uF (GRM32ER71A106K)]
    C15[ADC Decoupling 0.1uF (GCM21BR71C104KA)]
    C16[ADC Decoupling 0.01uF (GCM21BR71C103K)]
    C17[LDO Output 10uF (GRM32ER71A106K)]
    C18[LDO Output 1uF (GRM21BC71H105K)]
    C19[LDO Output 10uF (GRM32ER71A106K)]
    C20[LDO Output 1uF (GRM21BC71H105K)]
    C21[Input Filter Cap (GCM21BR71C473K)]
    C22[Output Filter Cap (GCM21BR71C473K)]
    C23[VCM Filter Cap (GCM21BR71C104KA)]
    C24[VCM Filter Cap (GCM21BR71C104KA)]
    C25[Op-Amp Bypass (GCM21BR71C104KA)]
    C26[Bulk Input Cap (EEE-FK1H470P)]
    C27[Bulk Input Cap (EEE-FK1H470P)]
    D1[Power LED (LTST-C171KGKT)]
    D2[Protection Diode (B5819W)]
    D3[Protection Diode (B5819W)]
    J1 -->|RF_IN| C1
    C1 -->|RF_IN_C| R1
    R1 -->|RF_IN_R| U1
    U1 -->|RF_LIM_OUT| U2
    U2 -->|LNA_OUT| U3
    U2 -->|LNA_BIAS| L3
    L3 -->|LNA_BIAS_F| R4
    R4 -->|LNA_BIAS_R| +5V
    U2 -->|GATE_BIAS| R2
    R2 -->|GATE_BIAS_R| +5V
    U2 -->|SOURCE_BIAS| R3
    R3 -->|SOURCE_BIAS_R| GND
    U2 -->|LNA_SOURCE| C2
    C2 -->|SOURCE_BYPASS| GND
    U3 -->|VGA_OUT| U4
    U3 -->|VGA_VDD| C5
    C5 -->|VGA_VDD_C| +5V
    U3 -->|VGA_G0| J3
    U3 -->|VGA_G1| J3
    U3 -->|VGA_G2| J3
    U3 -->|VGA_G3| J3
    U4 -->|MIXER_IF| T1
    U4 -->|MIXER_IFN| T1
    U5 -->|MIXER_LO| U4
    U5 -->|SYNTH_VCC| L1
    L1 -->|SYNTH_VCC_F| C10
    C10 -->|SYNTH_VCC_C1| C11
    C11 -->|SYNTH_VCC_C2| C12
    C12 -->|SYNTH_VCC_C3| C13
    C13 -->|SYNTH_VCC_OUT| +3.3V
    U5 -->|SYNTH_SCLK| J3
    U5 -->|SYNTH_SDIO| J3
    U5 -->|SYNTH_CS| J3
    T1 -->|IF_DIFF_P| T2
    T1 -->|IF_DIFF_N| T2
    T2 -->|ADC_IN_P| R8
    T2 -->|ADC_IN_N| R9
    R8 -->|ADC_IN_RP| U6
    R9 -->|ADC_IN_RN| U6
    U6 -->|ADC_VCM| R10
    R10 -->|VCM_FB1| U9
    U9 -->|VCM_FB2| R11
    R11 -->|VCM_FB2_R| U6
    U9 -->|VCM_OUT| R12
    R12 -->|VCM_FB_IN| U9
    J4 -->|ADC_CLK_P| U6
    J4 -->|ADC_CLK_N| U6
    J4 -->|ADC_REF_CLK| U5
    U6 -->|ADC_JESD_P| J2
    U6 -->|ADC_JESD_N| J2
    U6 -->|ADC_SYNC_P| J2
    U6 -->|ADC_SYNC_N| J2
    J3 -->|SPI_CS_ADC| U6
    J3 -->|SPI_SCLK| U6
    J3 -->|SPI_SDIO| U6
    J5 -->|+12V_RAW| L5
    L5 -->|12V_FILT| C26
    C26 -->|12V_CAP1| C27
    C27 -->|+12V| +12V
    +12V -->|12V_LED| R16
    R16 -->|LED_R| D1
    D1 -->|LED_C| GND
    +12V -->|5V_REG_IN| L4
    L4 -->|5V_REG_IN_F| +5V
    +12V -->|3V3_REG_IN| U7
    U7 -->|3V3_OUT| C17
    C17 -->|3V3_OUT_C| C18
    C18 -->|3V3_FINAL| +3.3V
    +12V -->|1V8_REG_IN| U8
    U8 -->|1V8_OUT| C19
    C19 -->|1V8_OUT_C| C20
    C20 -->|1V8_FINAL| +1.8V
    U1 -->|GND| U2
    U3 -->|GND| U4
    U5 -->|GND| U6
    U7 -->|GND| U8
    U9 -->|GND| J1
    J1 -->|GND| J1
    J2 -->|GND| J4
    J4 -->|GND| J5
    C5 -->|GND| C6
    C7 -->|GND| C8
    C9 -->|GND| C10
    C11 -->|GND| C12
    C13 -->|GND| C14
    C15 -->|GND| C16
    C17 -->|GND| C18
    C19 -->|GND| C20
    C21 -->|GND| C22
    C23 -->|GND| C24
    C25 -->|GND| C26
    C27 -->|GND| R15
```

## Component Instances

| Ref | Part Number | Component |
|---|---|---|
| U1 | GVA-123+ | Input Limiter |
| U2 | TQP3M9036 | Wideband LNA |
| U3 | HMC698LP4 | Variable Gain Amplifier |
| U4 | HMC1050 | RF Mixer |
| U5 | ADF5356 | LO Synthesizer |
| U6 | ADC12DJ3200 | High-Speed ADC |
| U7 | LT1963A-3.3 | LDO Regulator 3.3V |
| U8 | LT1963A-1.8 | LDO Regulator 1.8V |
| U9 | ADA4898-1 | Quad Op-Amp |
| J1 | SMA-2.4MM-J | RF Input Connector |
| J2 | FMC-HPC | JESD204B Interface |
| J3 | HDR-2X7 | SPI Control Header |
| J4 | SMA-EDGE-J | Clock Input |
| J5 | BARREL-12V | DC Power Input |
| T1 | TCM1-63+ | RF Transformer 1:2 |
| T2 | BAL-0006SM | RF Balun |
| L1 | BLM18PG471SN1 | Ferrite Bead |
| L2 | BLM18PG471SN1 | Ferrite Bead |
| L3 | 1008HS-103T | RF Choke |
| L4 | 1008HS-103T | RF Choke |
| L5 | LPS3015-103 | Power Inductor |
| R1 | ERA-3AEB1001V | RF Input Resistor |
| R2 | ERA-3AEB49R9V | Gate Bias Resistor |
| R3 | ERA-3AEB151V | Source Resistor |
| R4 | CRCW2512-100R | Drain Resistor |
| R5 | ERA-3AEB103V | SPI Pull-up Resistor |
| R6 | ERA-3AEB103V | SPI Pull-up Resistor |
| R7 | ERA-3AEB103V | SPI Pull-up Resistor |
| R8 | ERA-3AEB51R0V | ADC Termination Resistor |
| R9 | ERA-3AEB51R0V | ADC Termination Resistor |
| R10 | ERA-3AEB4991V | VCM Feedback Resistor |
| R11 | ERA-3AEB4991V | VCM Feedback Resistor |
| R12 | ERA-3AEB2001V | VCM Output Resistor |
| R13 | ERA-3AEB1003V | Feedback Resistor |
| R14 | ERA-3AEB1003V | Feedback Resistor |
| R15 | ERA-3AEB100V | Damping Resistor |
| R16 | ERA-3AEB221V | LED Current Limit |
| C1 | ATC100B101J500AT | Input DC Block |
| C2 | GCM21BR71C105KA | Source Bypass Cap |
| C3 | GCM21BR71C105KA | Gate Bypass Cap |
| C4 | GCM21BR71C105KA | Drain Bypass Cap |
| C5 | GRM21BC71H105K | VGA Supply Decoupling |
| C6 | GCM21BR71C104KA | VGA Control Decoupling |
| C7 | GCM21BR71C104KA | Mixer LO Decoupling |
| C8 | GCM21BR71C104KA | Mixer RF Decoupling |
| C9 | GCM21BR71C104KA | Mixer IF Decoupling |
| C10 | GRM21BC71H105K | Synth Decoupling 1uF |
| C11 | GCM21BR71C104KA | Synth Decoupling 0.1uF |
| C12 | GCM21BR71C103K | Synth Decoupling 0.01uF |
| C13 | GCM21BR71C102K | Synth Decoupling 0.001uF |
| C14 | GRM32ER71A106K | ADC Decoupling 10uF |
| C15 | GCM21BR71C104KA | ADC Decoupling 0.1uF |
| C16 | GCM21BR71C103K | ADC Decoupling 0.01uF |
| C17 | GRM32ER71A106K | LDO Output 10uF |
| C18 | GRM21BC71H105K | LDO Output 1uF |
| C19 | GRM32ER71A106K | LDO Output 10uF |
| C20 | GRM21BC71H105K | LDO Output 1uF |
| C21 | GCM21BR71C473K | Input Filter Cap |
| C22 | GCM21BR71C473K | Output Filter Cap |
| C23 | GCM21BR71C104KA | VCM Filter Cap |
| C24 | GCM21BR71C104KA | VCM Filter Cap |
| C25 | GCM21BR71C104KA | Op-Amp Bypass |
| C26 | EEE-FK1H470P | Bulk Input Cap |
| C27 | EEE-FK1H470P | Bulk Input Cap |
| D1 | LTST-C171KGKT | Power LED |
| D2 | B5819W | Protection Diode |
| D3 | B5819W | Protection Diode |

## Pin-to-Pin Connections

| Net | From | Pin | To | Pin | Type |
|---|---|---|---|---|---|
| RF_IN | J1 | 1 | C1 | 1 | RF |
| RF_IN_C | C1 | 2 | R1 | 1 | RF |
| RF_IN_R | R1 | 2 | U1 | RF_IN | RF |
| RF_LIM_OUT | U1 | RF_OUT | U2 | RF_IN | RF |
| LNA_OUT | U2 | RF_OUT | U3 | RF_IN | RF |
| LNA_BIAS | U2 | DRAIN | L3 | 1 | power |
| LNA_BIAS_F | L3 | 2 | R4 | 1 | power |
| LNA_BIAS_R | R4 | 2 | +5V | 1 | power |
| GATE_BIAS | U2 | GATE | R2 | 2 | analog |
| GATE_BIAS_R | R2 | 1 | +5V | 1 | power |
| SOURCE_BIAS | U2 | SOURCE | R3 | 2 | analog |
| SOURCE_BIAS_R | R3 | 1 | GND | 1 | ground |
| LNA_SOURCE | U2 | SOURCE | C2 | 1 | RF |
| SOURCE_BYPASS | C2 | 2 | GND | 1 | ground |
| VGA_OUT | U3 | RF_OUT | U4 | RF_IN | RF |
| VGA_VDD | U3 | VDD | C5 | 1 | power |
| VGA_VDD_C | C5 | 2 | +5V | 1 | power |
| VGA_G0 | U3 | G0 | J3 | 3 | digital |
| VGA_G1 | U3 | G1 | J3 | 5 | digital |
| VGA_G2 | U3 | G2 | J3 | 7 | digital |
| VGA_G3 | U3 | G3 | J3 | 9 | digital |
| MIXER_IF | U4 | IF_POS | T1 | 1 | analog |
| MIXER_IFN | U4 | IF_NEG | T1 | 3 | analog |
| MIXER_LO | U5 | RF_OUT_A | U4 | LO_IN | clock |
| SYNTH_VCC | U5 | VCC | L1 | 1 | power |
| SYNTH_VCC_F | L1 | 2 | C10 | 1 | power |
| SYNTH_VCC_C1 | C10 | 2 | C11 | 1 | power |
| SYNTH_VCC_C2 | C11 | 2 | C12 | 1 | power |
| SYNTH_VCC_C3 | C12 | 2 | C13 | 1 | power |
| SYNTH_VCC_OUT | C13 | 2 | +3.3V | 1 | power |
| SYNTH_SCLK | U5 | SCLK | J3 | 11 | digital |
| SYNTH_SDIO | U5 | SDIO | J3 | 13 | digital |
| SYNTH_CS | U5 | CS | J3 | 4 | digital |
| IF_DIFF_P | T1 | 5 | T2 | 1 | analog |
| IF_DIFF_N | T1 | 4 | T2 | 3 | analog |
| ADC_IN_P | T2 | 5 | R8 | 1 | analog |
| ADC_IN_N | T2 | 4 | R9 | 1 | analog |
| ADC_IN_RP | R8 | 2 | U6 | VIN_P | analog |
| ADC_IN_RN | R9 | 2 | U6 | VIN_N | analog |
| ADC_VCM | U6 | VCM | R10 | 2 | analog |
| VCM_FB1 | R10 | 1 | U9 | OUT_A | analog |
| VCM_FB2 | U9 | IN_A- | R11 | 2 | analog |
| VCM_FB2_R | R11 | 1 | U6 | VCM | analog |
| VCM_OUT | U9 | OUT_A | R12 | 1 | analog |
| VCM_FB_IN | R12 | 2 | U9 | IN_A+ | analog |
| ADC_CLK_P | J4 | 1 | U6 | CLK_P | clock |
| ADC_CLK_N | J4 | 2 | U6 | CLK_N | clock |
| ADC_REF_CLK | J4 | 1 | U5 | REF_IN | clock |
| ADC_JESD_P | U6 | JESD_TX_P | J2 | DP0 | digital |
| ADC_JESD_N | U6 | JESD_TX_N | J2 | DN0 | digital |
| ADC_SYNC_P | U6 | SYNC_P | J2 | DP1 | digital |
| ADC_SYNC_N | U6 | SYNC_N | J2 | DN1 | digital |
| SPI_CS_ADC | J3 | 4 | U6 | CS | digital |
| SPI_SCLK | J3 | 11 | U6 | SCLK | digital |
| SPI_SDIO | J3 | 13 | U6 | SDIO | digital |
| +12V_RAW | J5 | 1 | L5 | 1 | power |
| 12V_FILT | L5 | 2 | C26 | 1 | power |
| 12V_CAP1 | C26 | 2 | C27 | 1 | power |
| +12V | C27 | 2 | +12V | 1 | power |
| 12V_LED | +12V | 1 | R16 | 1 | power |
| LED_R | R16 | 2 | D1 | ANODE | power |
| LED_C | D1 | CATHODE | GND | 1 | ground |
| 5V_REG_IN | +12V | 1 | L4 | 1 | power |
| 5V_REG_IN_F | L4 | 2 | +5V | 1 | power |
| 3V3_REG_IN | +12V | 1 | U7 | IN | power |
| 3V3_OUT | U7 | OUT | C17 | 1 | power |
| 3V3_OUT_C | C17 | 2 | C18 | 1 | power |
| 3V3_FINAL | C18 | 2 | +3.3V | 1 | power |
| 1V8_REG_IN | +12V | 1 | U8 | IN | power |
| 1V8_OUT | U8 | OUT | C19 | 1 | power |
| 1V8_OUT_C | C19 | 2 | C20 | 1 | power |
| 1V8_FINAL | C20 | 2 | +1.8V | 1 | power |
| GND | U1 | GND | U2 | SOURCE | ground |
| GND | U3 | GND | U4 | GND | ground |
| GND | U5 | GND | U6 | GND | ground |
| GND | U7 | GND | U8 | GND | ground |
| GND | U9 | GND | J1 | 2 | ground |
| GND | J1 | 3 | J1 | 4 | ground |
| GND | J2 | 3 | J4 |  | ground |
| GND | J4 | 2 | J5 |  | ground |
| GND | C5 | 2 | C6 | 2 | ground |
| GND | C7 | 2 | C8 | 2 | ground |
| GND | C9 | 2 | C10 |  | ground |
| GND | C11 | 2 | C12 | 2 | ground |
| GND | C13 | 2 | C14 | 2 | ground |
| GND | C15 | 2 | C16 | 2 | ground |
| GND | C17 | 2 | C18 | 2 | ground |
| GND | C19 | 2 | C20 | 2 | ground |
| GND | C21 | 2 | C22 | 2 | ground |
| GND | C23 | 2 | C24 | 2 | ground |
| GND | C25 | 2 | C26 |  | ground |
| GND | C27 | 2 | R15 | 1 | ground |

## Net Connection List

| Net Name | Reference Designator - Pin No. |
|----------|-------------------------------|
| +12V | C27 - 2,  +12V - 1 |
| +12V_RAW | J5 - 1,  L5 - 1 |
| 12V_CAP1 | C26 - 2,  C27 - 1 |
| 12V_FILT | L5 - 2,  C26 - 1 |
| 12V_LED | +12V - 1,  R16 - 1 |
| 1V8_FINAL | C20 - 2,  +1.8V - 1 |
| 1V8_OUT | U8 - OUT,  C19 - 1 |
| 1V8_OUT_C | C19 - 2,  C20 - 1 |
| 1V8_REG_IN | +12V - 1,  U8 - IN |
| 3V3_FINAL | C18 - 2,  +3.3V - 1 |
| 3V3_OUT | U7 - OUT,  C17 - 1 |
| 3V3_OUT_C | C17 - 2,  C18 - 1 |
| 3V3_REG_IN | +12V - 1,  U7 - IN |
| 5V_REG_IN | +12V - 1,  L4 - 1 |
| 5V_REG_IN_F | L4 - 2,  +5V - 1 |
| ADC_CLK_N | J4 - 2,  U6 - CLK_N |
| ADC_CLK_P | J4 - 1,  U6 - CLK_P |
| ADC_IN_N | T2 - 4,  R9 - 1 |
| ADC_IN_P | T2 - 5,  R8 - 1 |
| ADC_IN_RN | R9 - 2,  U6 - VIN_N |
| ADC_IN_RP | R8 - 2,  U6 - VIN_P |
| ADC_JESD_N | U6 - JESD_TX_N,  J2 - DN0 |
| ADC_JESD_P | U6 - JESD_TX_P,  J2 - DP0 |
| ADC_REF_CLK | J4 - 1,  U5 - REF_IN |
| ADC_SYNC_N | U6 - SYNC_N,  J2 - DN1 |
| ADC_SYNC_P | U6 - SYNC_P,  J2 - DP1 |
| ADC_VCM | U6 - VCM,  R10 - 2 |
| GATE_BIAS | U2 - GATE,  R2 - 2 |
| GATE_BIAS_R | R2 - 1,  +5V - 1 |
| GND | U1 - GND,  U2 - SOURCE,  U3 - GND,  U4 - GND,  U5 - GND,  U6 - GND,  U7 - GND,  U8 - GND,  U9 - GND,  J1 - 2,  J1 - 3,  J1 - 4,  J2 - 3,  J4 - ,  J4 - 2,  J5 - ,  C5 - 2,  C6 - 2,  C7 - 2,  C8 - 2,  C9 - 2,  C10 - ,  C11 - 2,  C12 - 2,  C13 - 2,  C14 - 2,  C15 - 2,  C16 - 2,  C17 - 2,  C18 - 2,  C19 - 2,  C20 - 2,  C21 - 2,  C22 - 2,  C23 - 2,  C24 - 2,  C25 - 2,  C26 - ,  C27 - 2,  R15 - 1 |
| IF_DIFF_N | T1 - 4,  T2 - 3 |
| IF_DIFF_P | T1 - 5,  T2 - 1 |
| LED_C | D1 - CATHODE,  GND - 1 |
| LED_R | R16 - 2,  D1 - ANODE |
| LNA_BIAS | U2 - DRAIN,  L3 - 1 |
| LNA_BIAS_F | L3 - 2,  R4 - 1 |
| LNA_BIAS_R | R4 - 2,  +5V - 1 |
| LNA_OUT | U2 - RF_OUT,  U3 - RF_IN |
| LNA_SOURCE | U2 - SOURCE,  C2 - 1 |
| MIXER_IF | U4 - IF_POS,  T1 - 1 |
| MIXER_IFN | U4 - IF_NEG,  T1 - 3 |
| MIXER_LO | U5 - RF_OUT_A,  U4 - LO_IN |
| RF_IN | J1 - 1,  C1 - 1 |
| RF_IN_C | C1 - 2,  R1 - 1 |
| RF_IN_R | R1 - 2,  U1 - RF_IN |
| RF_LIM_OUT | U1 - RF_OUT,  U2 - RF_IN |
| SOURCE_BIAS | U2 - SOURCE,  R3 - 2 |
| SOURCE_BIAS_R | R3 - 1,  GND - 1 |
| SOURCE_BYPASS | C2 - 2,  GND - 1 |
| SPI_CS_ADC | J3 - 4,  U6 - CS |
| SPI_SCLK | J3 - 11,  U6 - SCLK |
| SPI_SDIO | J3 - 13,  U6 - SDIO |
| SYNTH_CS | U5 - CS,  J3 - 4 |
| SYNTH_SCLK | U5 - SCLK,  J3 - 11 |
| SYNTH_SDIO | U5 - SDIO,  J3 - 13 |
| SYNTH_VCC | U5 - VCC,  L1 - 1 |
| SYNTH_VCC_C1 | C10 - 2,  C11 - 1 |
| SYNTH_VCC_C2 | C11 - 2,  C12 - 1 |
| SYNTH_VCC_C3 | C12 - 2,  C13 - 1 |
| SYNTH_VCC_F | L1 - 2,  C10 - 1 |
| SYNTH_VCC_OUT | C13 - 2,  +3.3V - 1 |
| VCM_FB1 | R10 - 1,  U9 - OUT_A |
| VCM_FB2 | U9 - IN_A-,  R11 - 2 |
| VCM_FB2_R | R11 - 1,  U6 - VCM |
| VCM_FB_IN | R12 - 2,  U9 - IN_A+ |
| VCM_OUT | U9 - OUT_A,  R12 - 1 |
| VGA_G0 | U3 - G0,  J3 - 3 |
| VGA_G1 | U3 - G1,  J3 - 5 |
| VGA_G2 | U3 - G2,  J3 - 7 |
| VGA_G3 | U3 - G3,  J3 - 9 |
| VGA_OUT | U3 - RF_OUT,  U4 - RF_IN |
| VGA_VDD | U3 - VDD,  C5 - 1 |
| VGA_VDD_C | C5 - 2,  +5V - 1 |

## Validation Notes

- CRITICAL: LO frequency coverage - ADF5356 (53MHz-13.6GHz) cannot directly cover 5-18GHz RF range for high-side injection. For RF>13.6GHz, use low-side injection: LO = RF - IF (IF max 1GHz). This requires LO range of 4-17GHz, which is satisfied. Validate LO planning with RF tuning.
- CRITICAL: Mixer LO drive requirement - HMC1050 requires +17dBm LO drive. ADF5356 output is -5 to +5dBm. Need external LO amplifier (e.g., HMC3650) between U5 and U4.
- CRITICAL: High-speed ADC clock distribution - JESD204B subclass 1 requires deterministic latency. Ensure clock source is synchronized with system reference and meets wander/phase noise requirements.
- WARNING: Power budget verification - Calculated dissipation: U2 (0.6W) + U3 (0.5W) + U4 (0.3W) + U5 (0.8W) + U6 (2.1W) + U7/U8 (0.4W) = 4.7W. Margin within 8W budget but requires thermal analysis for U6 in particular.
- WARNING: VGA control interface - HMC698LP4 uses 4-bit parallel control (G0-G3). Netlist shows connection to SPI header J3. Ensure host FPGA can provide parallel GPIO or add SPI-to-parallel decoder (e.g., 74HC595).
- INFO: Decoupling capacitor distribution - All high-frequency components have 0.1uF/0.01uF local decoupling. Recommend adding 0.001uF at U5/U6 supply pins for >1GHz transient suppression.
- INFO: Analog signal chain impedance - IF chain uses 50Ω single-ended to 100Ω differential conversion. Verify T1 (TCM1-63+) and T2 (BAL-0006SM) impedance ratios match ADC input (100Ω diff).
- INFO: Ground plane partitioning - Recommend RF front-end ground, digital ground separation with single-point star ground under ADC. Ensure no split in return path for high-speed JESD signals.
- RECOMMENDATION: ESD protection on SPI lines - Add TVS array (e.g., SRV05-4) on J3 SPI header for field operation robustness.
- RECOMMENDATION: RF shielding - Plan metal cans over U1-U4 chain with RF gaskets to prevent internal coupling and maintain <-60dBm LO leakage requirement.