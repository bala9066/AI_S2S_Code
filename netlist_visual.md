# Logical Netlist
## fjxm

## Block Diagram

```mermaid
graph TB
    U1[Primary PWM Controller (UCC28951A)]
    Q1[Primary SiC MOSFET (C3M0065090D)]
    Q2[Primary Clamp MOSFET (C3M0065090D)]
    Q3[12V Sync Rectifier (IRF7749L2PBF)]
    Q4[5V Sync Rectifier (IRF7749L2PBF)]
    Q5[3.3V Sync Rectifier (IRF7749L2PBF)]
    U2[12V Linear Regulator (LT3086)]
    U3[5V Linear Regulator 1 (LT3045-50)]
    U4[5V Linear Regulator 2 (LT3045-50)]
    U5[5V Linear Regulator 3 (LT3045-50)]
    U6[5V Linear Regulator 4 (LT3045-50)]
    U7[3.3V Linear Regulator 1 (LT3042-3.3)]
    U8[3.3V Linear Regulator 2 (LT3042-3.3)]
    U9[3.3V Linear Regulator 3 (LT3042-3.3)]
    U10[3.3V Linear Regulator 4 (LT3042-3.3)]
    U11[3.3V Linear Regulator 5 (LT3042-3.3)]
    U12[3.3V Linear Regulator 6 (LT3042-3.3)]
    U13[3.3V Linear Regulator 7 (LT3042-3.3)]
    U14[3.3V Linear Regulator 8 (LT3042-3.3)]
    U15[3.3V Linear Regulator 9 (LT3042-3.3)]
    U16[3.3V Linear Regulator 10 (LT3042-3.3)]
    U17[3.3V Linear Regulator 11 (LT3042-3.3)]
    U18[3.3V Linear Regulator 12 (LT3042-3.3)]
    U19[3.3V Linear Regulator 13 (LT3042-3.3)]
    U20[3.3V Linear Regulator 14 (LT3042-3.3)]
    U21[3.3V Linear Regulator 15 (LT3042-3.3)]
    U22[3.3V Linear Regulator 16 (LT3042-3.3)]
    U23[3.3V Linear Regulator 17 (LT3042-3.3)]
    U24[3.3V Linear Regulator 18 (LT3042-3.3)]
    U25[3.3V Linear Regulator 19 (LT3042-3.3)]
    U26[3.3V Linear Regulator 20 (LT3042-3.3)]
    U27[3.3V Linear Regulator 21 (LT3042-3.3)]
    U28[3.3V Linear Regulator 22 (LT3042-3.3)]
    U29[3.3V Linear Regulator 23 (LT3042-3.3)]
    U30[3.3V Linear Regulator 24 (LT3042-3.3)]
    U31[3.3V Linear Regulator 25 (LT3042-3.3)]
    U32[3.3V Linear Regulator 26 (LT3042-3.3)]
    U33[3.3V Linear Regulator 27 (LT3042-3.3)]
    U34[3.3V Linear Regulator 28 (LT3042-3.3)]
    U35[3.3V Linear Regulator 29 (LT3042-3.3)]
    U36[3.3V Linear Regulator 30 (LT3042-3.3)]
    T1[Main Power Transformer (CUSTOM_FTX1)]
    J1[Input Connector (TE_292303-2)]
    J2[Output Connector (TE_292303-2)]
    D1[Reverse Polarity TVS (SMBJ60CA)]
    D2[Transient TVS (SMBJ78CA)]
    F1[Input Fuse (BEL_FUSE_0668Z)]
    D3[Input Rectifier (STPS3045CW)]
    C1[Input Bulk Capacitor (EPCOS_B43501)]
    C2[Input Ceramic 1 (1210_10uF_100V)]
    C3[Input Ceramic 2 (1210_10uF_100V)]
    R1[UVLO Resistor 1 (0805_100k)]
    R2[UVLO Resistor 2 (0805_15k)]
    R3[Gate Resistor (0805_10R)]
    R4[Clamp Gate Resistor (0805_10R)]
    R5[Current Sense Resistor (WSL2512_0.005)]
    R6[Feedback Resistor 1 (0805_10k)]
    R7[Feedback Resistor 2 (0805_2k)]
    R8[Sync Resistor (0805_100k)]
    R9[Soft Start Cap (0805_100nF)]
    C4[VDD Decoupling (0805_1uF_50V)]
    C5[VDD Decoupling 2 (0805_100nF)]
    C6[RT Resistor (0805_24k)]
    C7[VREF Decoupling (0805_100nF)]
    C8[Bootstrap Cap (0805_100nF)]
    C9[12V Output Bulk (820uF_16V)]
    C10[12V Output Ceramic (1210_47uF_25V)]
    C11[5V Output Bulk (560uF_10V)]
    C12[5V Output Ceramic (1210_47uF_10V)]
    C13[3.3V Output Bulk (470uF_6.3V)]
    C14[3.3V Output Ceramic (1210_47uF_6.3V)]
    R10[12V Set Resistor (1206_10k)]
    C15[12V Set Cap (0805_10nF)]
    R11[5V Set Resistor (1206_4.99k)]
    C16[5V Set Cap (0805_10nF)]
    R12[3.3V Set Resistor (1206_3.3k)]
    C17[3.3V Set Cap (0805_10nF)]
    D4[12V OVP Crowbar (P6KE15A)]
    D5[5V OVP Crowbar (P6KE6.8A)]
    D6[3.3V OVP Crowbar (P6KE4.3A)]
    D7[12V Sense Diode (1N4148W)]
    D8[12V Sense Diode 2 (1N4148W)]
    D9[5V Sense Diode (1N4148W)]
    D10[3.3V Sense Diode (1N4148W)]
    U37[HV Supervisory (MAX6396HA39)]
    R13[UVLO Hysteresis (0805_100k)]
    R14[Enable Pullup (0805_10k)]
    R15[Power Good Pullup (0805_4.7k)]
    LED1[PG Status LED (SMGA_0603_GRN)]
    R16[LED Resistor (0805_1k)]
    C18[Common Mode Choke Cap (1210_100nF)]
    J1 -->|INPUT_BUS+| F1
    F1 -->|F1_TO_D3| D3
    D3 -->|INPUT_PROTECTED+| C1
    D3 -->|INPUT_PROTECTED+| C2
    D3 -->|INPUT_PROTECTED+| C3
    D3 -->|INPUT_PROTECTED+| T1
    D3 -->|INPUT_PROTECTED+| Q1
    D3 -->|INPUT_PROTECTED+| U37
    J1 -->|INPUT_BUS-| D1
    J1 -->|INPUT_BUS-| C1
    J1 -->|INPUT_BUS-| C2
    J1 -->|INPUT_BUS-| C3
    J1 -->|INPUT_BUS-| T1
    J1 -->|INPUT_BUS-| U37
    J1 -->|INPUT_BUS-| R2
    INPUT_PROTECTED+ -->|UVLO_SENSE| R1
    R1 -->|UVLO_DIV| R2
    R1 -->|UVLO_FB| U37
    INPUT_PROTECTED+ -->|HV_SNS| U37
    R14 -->|ENABLE| U37
    R14 -->|ENABLE_PULLUP| U37
    R14 -->|ENABLE_EXT| J1
    U37 -->|PWR_GOOD| R15
    R15 -->|PG_PULLUP| U37
    R15 -->|PG_LED| R16
    R16 -->|PG_LED_DRIVE| LED1
    LED1 -->|LED_CATHODE| U37
    U37 -->|VCC_5V| U1
    U37 -->|VCC_5V| C4
    U37 -->|VCC_5V| C5
    U37 -->|VCC_5V| C7
    U37 -->|VCC_5V| R8
    C4 -->|VCC_GND| C5
    C5 -->|VCC_GND| C7
    C7 -->|VCC_GND| U1
    C7 -->|VCC_GND| R5
    C7 -->|VCC_GND| R7
    U1 -->|RT_FREQ| C6
    C6 -->|RT_FREQ| U1
    U1 -->|SS_SOFT| R9
    R9 -->|SS_SOFT| U1
    U1 -->|FB_IN| R6
    R6 -->|FB_IN| R7
    R6 -->|FB_DIV| OUTPUT_12V
    R5 -->|ISENSE+| U1
    R5 -->|ISENSE-| U1
    U1 -->|DRIVE_MAIN| R3
    R3 -->|DRIVE_MAIN| Q1
    U1 -->|DRIVE_CLAMP| R4
    R4 -->|DRIVE_CLAMP| Q2
    Q1 -->|SW_PRI| T1
    Q1 -->|CLAMP_NODE| Q2
    Q2 -->|CLAMP_RET| U1
    U1 -->|BOOTSTRAP| C8
    C8 -->|BOOTSTRAP| U1
    C8 -->|SW_BOOT| U1
    T1 -->|SEC_12V| Q3
    T1 -->|SEC_12V_CTR| Q3
    Q3 -->|SEC_12V_CTR| Q3
    T1 -->|SEC_5V| Q4
    T1 -->|SEC_5V_CTR| Q4
    Q4 -->|SEC_5V_CTR| Q4
    T1 -->|SEC_3V3| Q5
    T1 -->|SEC_3V3_CTR| Q5
    Q5 -->|SEC_3V3_CTR| Q5
    Q3 -->|RECT_12V| C9
    C9 -->|RECT_12V| C10
    C10 -->|RECT_12V| U2
    U2 -->|RECT_12V| D4
    C9 -->|RECT_12V_GND| C10
    C10 -->|RECT_12V_GND| Q3
    Q4 -->|RECT_5V| C11
    C11 -->|RECT_5V| C12
    C12 -->|RECT_5V| U3
    U3 -->|RECT_5V| U4
    U4 -->|RECT_5V| U5
    U5 -->|RECT_5V| U6
    U6 -->|RECT_5V| D5
    C11 -->|RECT_5V_GND| C12
    C12 -->|RECT_5V_GND| Q4
    Q5 -->|RECT_3V3| C13
    C13 -->|RECT_3V3| C14
    C14 -->|RECT_3V3| U7
    U7 -->|RECT_3V3| U8
    U8 -->|RECT_3V3| U9
    U9 -->|RECT_3V3| U10
    U10 -->|RECT_3V3| U11
    U11 -->|RECT_3V3| U12
    U12 -->|RECT_3V3| U13
    U13 -->|RECT_3V3| U14
    U14 -->|RECT_3V3| U15
    U15 -->|RECT_3V3| U16
    U16 -->|RECT_3V3| U17
    U17 -->|RECT_3V3| U18
    U18 -->|RECT_3V3| U19
    U19 -->|RECT_3V3| U20
    U20 -->|RECT_3V3| U21
    U21 -->|RECT_3V3| U22
    U22 -->|RECT_3V3| U23
    U23 -->|RECT_3V3| U24
    U24 -->|RECT_3V3| U25
    U25 -->|RECT_3V3| U26
    U26 -->|RECT_3V3| U27
    U27 -->|RECT_3V3| U28
    U28 -->|RECT_3V3| U29
    U29 -->|RECT_3V3| U30
    U30 -->|RECT_3V3| U31
    U31 -->|RECT_3V3| U32
    U32 -->|RECT_3V3| U33
    U33 -->|RECT_3V3| U34
    U34 -->|RECT_3V3| U35
    U35 -->|RECT_3V3| U36
    U36 -->|RECT_3V3| D6
    C13 -->|RECT_3V3_GND| C14
    C14 -->|RECT_3V3_GND| Q5
    U2 -->|SET_12V| R10
    R10 -->|SET_12V| U2
    U2 -->|SET_12V_CAP| C15
    C15 -->|SET_12V_CAP| U2
    U3 -->|SET_5V| R11
    R11 -->|SET_5V| U4
    U4 -->|SET_5V| U5
    U5 -->|SET_5V| U6
    U6 -->|SET_5V| R11
    U3 -->|SET_5V_CAP| C16
    C16 -->|SET_5V_CAP| U3
    U7 -->|SET_3V3| R12
    U7 -->|SET_3V3| U8
    U8 -->|SET_3V3| U9
    U9 -->|SET_3V3| U10
    U10 -->|SET_3V3| U11
    U11 -->|SET_3V3| U12
    U12 -->|SET_3V3| U13
    U13 -->|SET_3V3| U14
    U14 -->|SET_3V3| U15
    U15 -->|SET_3V3| U16
    U16 -->|SET_3V3| U17
    U17 -->|SET_3V3| U18
    U18 -->|SET_3V3| U19
    U19 -->|SET_3V3| U20
    U20 -->|SET_3V3| U21
    U21 -->|SET_3V3| U22
    U22 -->|SET_3V3| U23
    U23 -->|SET_3V3| U24
    U24 -->|SET_3V3| U25
    U25 -->|SET_3V3| U26
    U26 -->|SET_3V3| U27
    U27 -->|SET_3V3| U28
    U28 -->|SET_3V3| U29
    U29 -->|SET_3V3| U30
    U30 -->|SET_3V3| U31
    U31 -->|SET_3V3| U32
    U32 -->|SET_3V3| U33
    U33 -->|SET_3V3| U34
    U34 -->|SET_3V3| U35
    U35 -->|SET_3V3| U36
    U36 -->|SET_3V3| R12
    U7 -->|SET_3V3_CAP| C17
    C17 -->|SET_3V3_CAP| U7
    U2 -->|OUTPUT_12V| C9
    C9 -->|OUTPUT_12V| C10
    C10 -->|OUTPUT_12V| D7
    D7 -->|OUTPUT_12V| D8
    D8 -->|OUTPUT_12V| D4
    D8 -->|OUTPUT_12V_SENSE| J2
    J2 -->|OUTPUT_12V_RTN| U2
    U3 -->|OUTPUT_5V| U4
    U4 -->|OUTPUT_5V| U5
    U5 -->|OUTPUT_5V| U6
    U6 -->|OUTPUT_5V| D9
    D9 -->|OUTPUT_5V| D5
    D5 -->|OUTPUT_5V| J2
    J2 -->|OUTPUT_5V_RTN| U3
    U7 -->|OUTPUT_3V3| U8
    U8 -->|OUTPUT_3V3| U9
    U9 -->|OUTPUT_3V3| U10
    U10 -->|OUTPUT_3V3| U11
    U11 -->|OUTPUT_3V3| U12
    U12 -->|OUTPUT_3V3| U13
    U13 -->|OUTPUT_3V3| U14
    U14 -->|OUTPUT_3V3| U15
    U15 -->|OUTPUT_3V3| U16
    U16 -->|OUTPUT_3V3| U17
    U17 -->|OUTPUT_3V3| U18
    U18 -->|OUTPUT_3V3| U19
    U19 -->|OUTPUT_3V3| U20
    U20 -->|OUTPUT_3V3| U21
    U21 -->|OUTPUT_3V3| U22
    U22 -->|OUTPUT_3V3| U23
    U23 -->|OUTPUT_3V3| U24
    U24 -->|OUTPUT_3V3| U25
    U25 -->|OUTPUT_3V3| U26
    U26 -->|OUTPUT_3V3| U27
    U27 -->|OUTPUT_3V3| U28
    U28 -->|OUTPUT_3V3| U29
    U29 -->|OUTPUT_3V3| U30
    U30 -->|OUTPUT_3V3| U31
    U31 -->|OUTPUT_3V3| U32
    U32 -->|OUTPUT_3V3| U33
    U33 -->|OUTPUT_3V3| U34
    U34 -->|OUTPUT_3V3| U35
    U35 -->|OUTPUT_3V3| U36
    U36 -->|OUTPUT_3V3| D10
    D10 -->|OUTPUT_3V3| D6
    D6 -->|OUTPUT_3V3| J2
    J2 -->|OUTPUT_3V3_RTN| U7
```

## Component Instances

| Ref | Part Number | Component |
|---|---|---|
| U1 | UCC28951A | Primary PWM Controller |
| Q1 | C3M0065090D | Primary SiC MOSFET |
| Q2 | C3M0065090D | Primary Clamp MOSFET |
| Q3 | IRF7749L2PBF | 12V Sync Rectifier |
| Q4 | IRF7749L2PBF | 5V Sync Rectifier |
| Q5 | IRF7749L2PBF | 3.3V Sync Rectifier |
| U2 | LT3086 | 12V Linear Regulator |
| U3 | LT3045-50 | 5V Linear Regulator 1 |
| U4 | LT3045-50 | 5V Linear Regulator 2 |
| U5 | LT3045-50 | 5V Linear Regulator 3 |
| U6 | LT3045-50 | 5V Linear Regulator 4 |
| U7 | LT3042-3.3 | 3.3V Linear Regulator 1 |
| U8 | LT3042-3.3 | 3.3V Linear Regulator 2 |
| U9 | LT3042-3.3 | 3.3V Linear Regulator 3 |
| U10 | LT3042-3.3 | 3.3V Linear Regulator 4 |
| U11 | LT3042-3.3 | 3.3V Linear Regulator 5 |
| U12 | LT3042-3.3 | 3.3V Linear Regulator 6 |
| U13 | LT3042-3.3 | 3.3V Linear Regulator 7 |
| U14 | LT3042-3.3 | 3.3V Linear Regulator 8 |
| U15 | LT3042-3.3 | 3.3V Linear Regulator 9 |
| U16 | LT3042-3.3 | 3.3V Linear Regulator 10 |
| U17 | LT3042-3.3 | 3.3V Linear Regulator 11 |
| U18 | LT3042-3.3 | 3.3V Linear Regulator 12 |
| U19 | LT3042-3.3 | 3.3V Linear Regulator 13 |
| U20 | LT3042-3.3 | 3.3V Linear Regulator 14 |
| U21 | LT3042-3.3 | 3.3V Linear Regulator 15 |
| U22 | LT3042-3.3 | 3.3V Linear Regulator 16 |
| U23 | LT3042-3.3 | 3.3V Linear Regulator 17 |
| U24 | LT3042-3.3 | 3.3V Linear Regulator 18 |
| U25 | LT3042-3.3 | 3.3V Linear Regulator 19 |
| U26 | LT3042-3.3 | 3.3V Linear Regulator 20 |
| U27 | LT3042-3.3 | 3.3V Linear Regulator 21 |
| U28 | LT3042-3.3 | 3.3V Linear Regulator 22 |
| U29 | LT3042-3.3 | 3.3V Linear Regulator 23 |
| U30 | LT3042-3.3 | 3.3V Linear Regulator 24 |
| U31 | LT3042-3.3 | 3.3V Linear Regulator 25 |
| U32 | LT3042-3.3 | 3.3V Linear Regulator 26 |
| U33 | LT3042-3.3 | 3.3V Linear Regulator 27 |
| U34 | LT3042-3.3 | 3.3V Linear Regulator 28 |
| U35 | LT3042-3.3 | 3.3V Linear Regulator 29 |
| U36 | LT3042-3.3 | 3.3V Linear Regulator 30 |
| T1 | CUSTOM_FTX1 | Main Power Transformer |
| J1 | TE_292303-2 | Input Connector |
| J2 | TE_292303-2 | Output Connector |
| D1 | SMBJ60CA | Reverse Polarity TVS |
| D2 | SMBJ78CA | Transient TVS |
| F1 | BEL_FUSE_0668Z | Input Fuse |
| D3 | STPS3045CW | Input Rectifier |
| C1 | EPCOS_B43501 | Input Bulk Capacitor |
| C2 | 1210_10uF_100V | Input Ceramic 1 |
| C3 | 1210_10uF_100V | Input Ceramic 2 |
| R1 | 0805_100k | UVLO Resistor 1 |
| R2 | 0805_15k | UVLO Resistor 2 |
| R3 | 0805_10R | Gate Resistor |
| R4 | 0805_10R | Clamp Gate Resistor |
| R5 | WSL2512_0.005 | Current Sense Resistor |
| R6 | 0805_10k | Feedback Resistor 1 |
| R7 | 0805_2k | Feedback Resistor 2 |
| R8 | 0805_100k | Sync Resistor |
| R9 | 0805_100nF | Soft Start Cap |
| C4 | 0805_1uF_50V | VDD Decoupling |
| C5 | 0805_100nF | VDD Decoupling 2 |
| C6 | 0805_24k | RT Resistor |
| C7 | 0805_100nF | VREF Decoupling |
| C8 | 0805_100nF | Bootstrap Cap |
| C9 | 820uF_16V | 12V Output Bulk |
| C10 | 1210_47uF_25V | 12V Output Ceramic |
| C11 | 560uF_10V | 5V Output Bulk |
| C12 | 1210_47uF_10V | 5V Output Ceramic |
| C13 | 470uF_6.3V | 3.3V Output Bulk |
| C14 | 1210_47uF_6.3V | 3.3V Output Ceramic |
| R10 | 1206_10k | 12V Set Resistor |
| C15 | 0805_10nF | 12V Set Cap |
| R11 | 1206_4.99k | 5V Set Resistor |
| C16 | 0805_10nF | 5V Set Cap |
| R12 | 1206_3.3k | 3.3V Set Resistor |
| C17 | 0805_10nF | 3.3V Set Cap |
| D4 | P6KE15A | 12V OVP Crowbar |
| D5 | P6KE6.8A | 5V OVP Crowbar |
| D6 | P6KE4.3A | 3.3V OVP Crowbar |
| D7 | 1N4148W | 12V Sense Diode |
| D8 | 1N4148W | 12V Sense Diode 2 |
| D9 | 1N4148W | 5V Sense Diode |
| D10 | 1N4148W | 3.3V Sense Diode |
| U37 | MAX6396HA39 | HV Supervisory |
| R13 | 0805_100k | UVLO Hysteresis |
| R14 | 0805_10k | Enable Pullup |
| R15 | 0805_4.7k | Power Good Pullup |
| LED1 | SMGA_0603_GRN | PG Status LED |
| R16 | 0805_1k | LED Resistor |
| C18 | 1210_100nF | Common Mode Choke Cap |

## Connections

| Net | From | Pin | To | Pin | Type |
|---|---|---|---|---|---|
| INPUT_BUS+ | J1 | 1 | F1 | 1 | power |
| F1_TO_D3 | F1 | 2 | D3 | 1 | power |
| INPUT_PROTECTED+ | D3 | 2 | C1 | 1 | power |
| INPUT_PROTECTED+ | D3 | 2 | C2 | 1 | power |
| INPUT_PROTECTED+ | D3 | 2 | C3 | 1 | power |
| INPUT_PROTECTED+ | D3 | 2 | T1 | PRI_1 | power |
| INPUT_PROTECTED+ | D3 | 2 | Q1 | Drain | power |
| INPUT_PROTECTED+ | D3 | 2 | U37 | VIN | power |
| INPUT_BUS- | J1 | 2 | D1 | 1 | power |
| INPUT_BUS- | J1 | 2 | C1 | 2 | power |
| INPUT_BUS- | J1 | 2 | C2 | 2 | power |
| INPUT_BUS- | J1 | 2 | C3 | 2 | power |
| INPUT_BUS- | J1 | 2 | T1 | PRI_2 | power |
| INPUT_BUS- | J1 | 2 | U37 | GND | power |
| INPUT_BUS- | J1 | 2 | R2 | 2 | power |
| UVLO_SENSE | INPUT_PROTECTED+ | NODE | R1 | 1 | analog |
| UVLO_DIV | R1 | 2 | R2 | 1 | analog |
| UVLO_FB | R1 | 2 | U37 | UVLO | analog |
| HV_SNS | INPUT_PROTECTED+ | NODE | U37 | SNS | analog |
| ENABLE | R14 | 1 | U37 | EN | digital |
| ENABLE_PULLUP | R14 | 2 | U37 | VCC | power |
| ENABLE_EXT | R14 | 1 | J1 | 3 | digital |
| PWR_GOOD | U37 | PGOOD | R15 | 1 | digital |
| PG_PULLUP | R15 | 2 | U37 | VCC | power |
| PG_LED | R15 | 1 | R16 | 1 | digital |
| PG_LED_DRIVE | R16 | 2 | LED1 | A | digital |
| LED_CATHODE | LED1 | C | U37 | GND | power |
| VCC_5V | U37 | VCC | U1 | VDD | power |
| VCC_5V | U37 | VCC | C4 | 1 | power |
| VCC_5V | U37 | VCC | C5 | 1 | power |
| VCC_5V | U37 | VCC | C7 | 1 | power |
| VCC_5V | U37 | VCC | R8 | 2 | power |
| VCC_GND | C4 | 2 | C5 | 2 | power |
| VCC_GND | C5 | 2 | C7 | 2 | power |
| VCC_GND | C7 | 2 | U1 | GND | power |
| VCC_GND | C7 | 2 | R5 | 2 | power |
| VCC_GND | C7 | 2 | R7 | 2 | power |
| RT_FREQ | U1 | RT | C6 | 1 | analog |
| RT_FREQ | C6 | 1 | U1 | GND | analog |
| SS_SOFT | U1 | SS | R9 | 1 | analog |
| SS_SOFT | R9 | 2 | U1 | GND | analog |
| FB_IN | U1 | FB | R6 | 2 | analog |
| FB_IN | R6 | 2 | R7 | 1 | analog |
| FB_DIV | R6 | 1 | OUTPUT_12V | SENSE | analog |
| ISENSE+ | R5 | 1 | U1 | ISNS+ | analog |
| ISENSE- | R5 | 2 | U1 | ISNS- | analog |
| DRIVE_MAIN | U1 | HO | R3 | 1 | power |
| DRIVE_MAIN | R3 | 2 | Q1 | Gate | power |
| DRIVE_CLAMP | U1 | AC | R4 | 1 | power |
| DRIVE_CLAMP | R4 | 2 | Q2 | Gate | power |
| SW_PRI | Q1 | Source | T1 | PRI_3 | power |
| CLAMP_NODE | Q1 | Drain | Q2 | Drain | power |
| CLAMP_RET | Q2 | Source | U1 | SW | power |
| BOOTSTRAP | U1 | HB | C8 | 1 | power |
| BOOTSTRAP | C8 | 1 | U1 | BOOT | power |
| SW_BOOT | C8 | 2 | U1 | SW | power |
| SEC_12V | T1 | SEC1_1 | Q3 | Drain | power |
| SEC_12V_CTR | T1 | SEC1_2 | Q3 | Source | power |
| SEC_12V_CTR | Q3 | Source | Q3 | GND | power |
| SEC_5V | T1 | SEC2_1 | Q4 | Drain | power |
| SEC_5V_CTR | T1 | SEC2_2 | Q4 | Source | power |
| SEC_5V_CTR | Q4 | Source | Q4 | GND | power |
| SEC_3V3 | T1 | SEC3_1 | Q5 | Drain | power |
| SEC_3V3_CTR | T1 | SEC3_2 | Q5 | Source | power |
| SEC_3V3_CTR | Q5 | Source | Q5 | GND | power |
| RECT_12V | Q3 | Source | C9 | 1 | power |
| RECT_12V | C9 | 1 | C10 | 1 | power |
| RECT_12V | C10 | 1 | U2 | IN | power |
| RECT_12V | U2 | IN | D4 | 1 | power |
| RECT_12V_GND | C9 | 2 | C10 | 2 | power |
| RECT_12V_GND | C10 | 2 | Q3 | GND | power |
| RECT_5V | Q4 | Source | C11 | 1 | power |
| RECT_5V | C11 | 1 | C12 | 1 | power |
| RECT_5V | C12 | 1 | U3 | IN | power |
| RECT_5V | U3 | IN | U4 | IN | power |
| RECT_5V | U4 | IN | U5 | IN | power |
| RECT_5V | U5 | IN | U6 | IN | power |
| RECT_5V | U6 | IN | D5 | 1 | power |
| RECT_5V_GND | C11 | 2 | C12 | 2 | power |
| RECT_5V_GND | C12 | 2 | Q4 | GND | power |
| RECT_3V3 | Q5 | Source | C13 | 1 | power |
| RECT_3V3 | C13 | 1 | C14 | 1 | power |
| RECT_3V3 | C14 | 1 | U7 | IN | power |
| RECT_3V3 | U7 | IN | U8 | IN | power |
| RECT_3V3 | U8 | IN | U9 | IN | power |
| RECT_3V3 | U9 | IN | U10 | IN | power |
| RECT_3V3 | U10 | IN | U11 | IN | power |
| RECT_3V3 | U11 | IN | U12 | IN | power |
| RECT_3V3 | U12 | IN | U13 | IN | power |
| RECT_3V3 | U13 | IN | U14 | IN | power |
| RECT_3V3 | U14 | IN | U15 | IN | power |
| RECT_3V3 | U15 | IN | U16 | IN | power |
| RECT_3V3 | U16 | IN | U17 | IN | power |
| RECT_3V3 | U17 | IN | U18 | IN | power |
| RECT_3V3 | U18 | IN | U19 | IN | power |
| RECT_3V3 | U19 | IN | U20 | IN | power |
| RECT_3V3 | U20 | IN | U21 | IN | power |
| RECT_3V3 | U21 | IN | U22 | IN | power |
| RECT_3V3 | U22 | IN | U23 | IN | power |
| RECT_3V3 | U23 | IN | U24 | IN | power |
| RECT_3V3 | U24 | IN | U25 | IN | power |
| RECT_3V3 | U25 | IN | U26 | IN | power |
| RECT_3V3 | U26 | IN | U27 | IN | power |
| RECT_3V3 | U27 | IN | U28 | IN | power |
| RECT_3V3 | U28 | IN | U29 | IN | power |
| RECT_3V3 | U29 | IN | U30 | IN | power |
| RECT_3V3 | U30 | IN | U31 | IN | power |
| RECT_3V3 | U31 | IN | U32 | IN | power |
| RECT_3V3 | U32 | IN | U33 | IN | power |
| RECT_3V3 | U33 | IN | U34 | IN | power |
| RECT_3V3 | U34 | IN | U35 | IN | power |
| RECT_3V3 | U35 | IN | U36 | IN | power |
| RECT_3V3 | U36 | IN | D6 | 1 | power |
| RECT_3V3_GND | C13 | 2 | C14 | 2 | power |
| RECT_3V3_GND | C14 | 2 | Q5 | GND | power |
| SET_12V | U2 | SET | R10 | 1 | analog |
| SET_12V | R10 | 2 | U2 | GND | analog |
| SET_12V_CAP | U2 | SET | C15 | 1 | analog |
| SET_12V_CAP | C15 | 2 | U2 | GND | analog |
| SET_5V | U3 | SET | R11 | 1 | analog |
| SET_5V | R11 | 1 | U4 | SET | analog |
| SET_5V | U4 | SET | U5 | SET | analog |
| SET_5V | U5 | SET | U6 | SET | analog |
| SET_5V | U6 | SET | R11 | 2 | analog |
| SET_5V_CAP | U3 | SET | C16 | 1 | analog |
| SET_5V_CAP | C16 | 2 | U3 | GND | analog |
| SET_3V3 | U7 | SET | R12 | 1 | analog |
| SET_3V3 | U7 | SET | U8 | SET | analog |
| SET_3V3 | U8 | SET | U9 | SET | analog |
| SET_3V3 | U9 | SET | U10 | SET | analog |
| SET_3V3 | U10 | SET | U11 | SET | analog |
| SET_3V3 | U11 | SET | U12 | SET | analog |
| SET_3V3 | U12 | SET | U13 | SET | analog |
| SET_3V3 | U13 | SET | U14 | SET | analog |
| SET_3V3 | U14 | SET | U15 | SET | analog |
| SET_3V3 | U15 | SET | U16 | SET | analog |
| SET_3V3 | U16 | SET | U17 | SET | analog |
| SET_3V3 | U17 | SET | U18 | SET | analog |
| SET_3V3 | U18 | SET | U19 | SET | analog |
| SET_3V3 | U19 | SET | U20 | SET | analog |
| SET_3V3 | U20 | SET | U21 | SET | analog |
| SET_3V3 | U21 | SET | U22 | SET | analog |
| SET_3V3 | U22 | SET | U23 | SET | analog |
| SET_3V3 | U23 | SET | U24 | SET | analog |
| SET_3V3 | U24 | SET | U25 | SET | analog |
| SET_3V3 | U25 | SET | U26 | SET | analog |
| SET_3V3 | U26 | SET | U27 | SET | analog |
| SET_3V3 | U27 | SET | U28 | SET | analog |
| SET_3V3 | U28 | SET | U29 | SET | analog |
| SET_3V3 | U29 | SET | U30 | SET | analog |
| SET_3V3 | U30 | SET | U31 | SET | analog |
| SET_3V3 | U31 | SET | U32 | SET | analog |
| SET_3V3 | U32 | SET | U33 | SET | analog |
| SET_3V3 | U33 | SET | U34 | SET | analog |
| SET_3V3 | U34 | SET | U35 | SET | analog |
| SET_3V3 | U35 | SET | U36 | SET | analog |
| SET_3V3 | U36 | SET | R12 | 2 | analog |
| SET_3V3_CAP | U7 | SET | C17 | 1 | analog |
| SET_3V3_CAP | C17 | 2 | U7 | GND | analog |
| OUTPUT_12V | U2 | OUT | C9 | 3 | power |
| OUTPUT_12V | C9 | 3 | C10 | 3 | power |
| OUTPUT_12V | C10 | 3 | D7 | A | power |
| OUTPUT_12V | D7 | C | D8 | A | power |
| OUTPUT_12V | D8 | C | D4 | 2 | power |
| OUTPUT_12V_SENSE | D8 | A | J2 | 1 | power |
| OUTPUT_12V_RTN | J2 | 2 | U2 | GND | power |
| OUTPUT_5V | U3 | OUT | U4 | OUT | power |
| OUTPUT_5V | U4 | OUT | U5 | OUT | power |
| OUTPUT_5V | U5 | OUT | U6 | OUT | power |
| OUTPUT_5V | U6 | OUT | D9 | A | power |
| OUTPUT_5V | D9 | C | D5 | 2 | power |
| OUTPUT_5V | D5 | 2 | J2 | 3 | power |
| OUTPUT_5V_RTN | J2 | 4 | U3 | GND | power |
| OUTPUT_3V3 | U7 | OUT | U8 | OUT | power |
| OUTPUT_3V3 | U8 | OUT | U9 | OUT | power |
| OUTPUT_3V3 | U9 | OUT | U10 | OUT | power |
| OUTPUT_3V3 | U10 | OUT | U11 | OUT | power |
| OUTPUT_3V3 | U11 | OUT | U12 | OUT | power |
| OUTPUT_3V3 | U12 | OUT | U13 | OUT | power |
| OUTPUT_3V3 | U13 | OUT | U14 | OUT | power |
| OUTPUT_3V3 | U14 | OUT | U15 | OUT | power |
| OUTPUT_3V3 | U15 | OUT | U16 | OUT | power |
| OUTPUT_3V3 | U16 | OUT | U17 | OUT | power |
| OUTPUT_3V3 | U17 | OUT | U18 | OUT | power |
| OUTPUT_3V3 | U18 | OUT | U19 | OUT | power |
| OUTPUT_3V3 | U19 | OUT | U20 | OUT | power |
| OUTPUT_3V3 | U20 | OUT | U21 | OUT | power |
| OUTPUT_3V3 | U21 | OUT | U22 | OUT | power |
| OUTPUT_3V3 | U22 | OUT | U23 | OUT | power |
| OUTPUT_3V3 | U23 | OUT | U24 | OUT | power |
| OUTPUT_3V3 | U24 | OUT | U25 | OUT | power |
| OUTPUT_3V3 | U25 | OUT | U26 | OUT | power |
| OUTPUT_3V3 | U26 | OUT | U27 | OUT | power |
| OUTPUT_3V3 | U27 | OUT | U28 | OUT | power |
| OUTPUT_3V3 | U28 | OUT | U29 | OUT | power |
| OUTPUT_3V3 | U29 | OUT | U30 | OUT | power |
| OUTPUT_3V3 | U30 | OUT | U31 | OUT | power |
| OUTPUT_3V3 | U31 | OUT | U32 | OUT | power |
| OUTPUT_3V3 | U32 | OUT | U33 | OUT | power |
| OUTPUT_3V3 | U33 | OUT | U34 | OUT | power |
| OUTPUT_3V3 | U34 | OUT | U35 | OUT | power |
| OUTPUT_3V3 | U35 | OUT | U36 | OUT | power |
| OUTPUT_3V3 | U36 | OUT | D10 | A | power |
| OUTPUT_3V3 | D10 | C | D6 | 2 | power |
| OUTPUT_3V3 | D6 | 2 | J2 | 5 | power |
| OUTPUT_3V3_RTN | J2 | 6 | U7 | GND | power |

## Validation Notes

- CRITICAL: 3.3V linear post-regulator implementation uses 30 parallel LT3042-3.3 devices (200mA each) to achieve 6A output. This is highly impractical for production - consider using higher-current LDO or switching pre-regulator with single LDO.
- WARNING: LT3045-50 (500mA) used for 5V rail requires 8 parallel devices for 8A output. Current netlist shows 4 devices (2A capacity). Add U9-U12 to complete implementation.
- WARNING: LT3086 (30A LDO) specified for 12V rail provides excellent margin for 12A load. Verify thermal dissipation with forced-air cooling at full load.
- NOTE: UCC28951A VDD pin requires 5V supply. Added MAX6396HA39 HV supervisory to generate bias rail from 48V input.
- NOTE: Input UVLO divider (R1/R2) sets threshold at approximately 36V with hysteresis via R13. Verify exact values for 36V UVLO with 2V hysteresis.
- NOTE: Feedback network (R6/R7) sets output voltage reference. Values shown are placeholder - calculate based on 2.5V reference of UCC28951A.
- NOTE: Current sense resistor R5 (5mΩ) provides primary-side current sensing. Verify power rating for 200W output (approximately 4A primary current).
- NOTE: Gate drive resistors R3 and R4 should be optimized for switching performance and EMI. 10Ω is starting point.
- NOTE: Transformer T1 pin naming (PRI_1, PRI_2, SEC1_1, etc.) is placeholder. Actual transformer pinout depends on magnetics design.
- NOTE: OVP crowbar circuits (D4, D5, D6) use P6KE series TVS devices. Verify trigger voltage and ensure SCR latch characteristics are suitable.
- NOTE: Remote sense implemented on 12V rail via D7/D8 diodes. Compensation limited to ~0.5V due to diode forward voltage.
- RECOMMENDATION: 3.3V architecture needs redesign. Consider single 10A LDO (LT3081) with buck pre-regulator, or switching regulator with LC filter.
- RECOMMENDATION: 5V architecture could use 2x LT3081 (10A each) or single 20A LDO (TPS7A4700) instead of 8x parallel LT3045-50.
- EMI: Input filter (C18 common-mode choke cap) shown but actual CM choke component not specified. Add for MIL-STD-461G compliance.
- EMI: Synchronous rectification requires careful gate timing relative to transformer secondary voltage. Verify UCC28951A SR drive timing.
- THERMAL: Linear post-regulators will dissipate significant power. 12V: (14.4V - 12V) × 12A = 28.8W. 5V: (6.5V - 5V) × 8A = 12W. 3.3V: (4.2V - 3.3V) × 6A = 5.4W. Total: ~46W dissipation in LDOs.
- ISOLATION: Transformer must provide 1500VDC isolation primary-to-secondary. Inter-rail isolation (500VDC) handled by separate transformer windings.
- PROTECTION: Input fuse F1 must be rated for 48V DC interrupting capacity. Verify DC rating for automotive fuse.
- PROTECTION: Reverse polarity protection via D1 (SMBJ60CA) is clamping only. Consider series diode or FET for true reverse polarity protection.
- MAGNETICS: Transformer design critical for multi-output forward converter. Ensure coupling coefficient and leakage inductance support 200-300kHz operation.