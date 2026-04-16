# Logical Netlist
## sample rf

## Block Diagram

```mermaid
graph TB
    U1[HMC698LP4 (HMC698LP4ETRS)]
    U2[HMC1119LP4 (HMC1119LP4ETRS)]
    U3[ADA4817-1 (ADA4817-1ACPZ-R7)]
    U4[ADC12J4000 (ADC12J4000EVM)]
    U5[TPS7A4700 (TPS7A4700RGWT)]
    U6[TPS7A4700 (TPS7A4700RGWT)]
    U7[TPS62130 (TPS62130RGTT)]
    U8[LMZ14203 (LMZ14203HVKIT)]
    U9[Si5345 (568-10088-1018-1)]
    U10[HMC364 (HMC364LP4ETRS)]
    U11[TCM1-63AX+ (TCM1-63AX+)]
    J1[SMA_CONNECTOR (142-0701-851)]
    J2[SMA_CONNECTOR (142-0701-851)]
    J3[HSTC_HEADER (SAMTEC-HSTC-120)]
    J4[POWER_TERMINAL (MKDSN-1.5/2-5.08)]
    J5[HEADER_2X5 (PPTC021LFBN-RC)]
    F1[FUSE (0451005.NRLF)]
    D1[TVS_DIODE (SMBJ5.0CA)]
    D2[LED_INDICATOR (LTST-C170KRKT)]
    L1[FERRITE_BEAD (BLM18KG221TN1)]
    L2[FERRITE_BEAD (BLM18KG221TN1)]
    L3[FERRITE_BEAD (BLM18KG221TN1)]
    L4[RF_CHOKE (1008HQ-22NXJW)]
    L5[RF_CHOKE (1008HQ-22NXJW)]
    C1[CAP_CERAMIC (GRM1555C1H4R7BA01D)]
    C2[CAP_CERAMIC (GJM1555C1H3R9BB01D)]
    C3[CAP_CERAMIC (GRM1555C1H4R7BA01D)]
    C4[CAP_CERAMIC (GJM1555C1H1R5BB01D)]
    C5[CAP_CERAMIC (GJM1555C1H1R5BB01D)]
    C6[CAP_CERAMIC (GRM1555C1H3R3BA01D)]
    C7[CAP_CERAMIC (GJM1555C1H1R0BB01D)]
    C8[CAP_CERAMIC (GJM1555C1H1R0BB01D)]
    C9[CAP_CERAMIC (GJM1555C1H1R8BB01D)]
    C10[CAP_CERAMIC (GJM1555C1H1R8BB01D)]
    C11[CAP_CERAMIC (GJM1555C1H1R5BB01D)]
    C12[CAP_CERAMIC (GJM1555C1H1R5BB01D)]
    C13[CAP_CERAMIC (GRM155R71C473KA88D)]
    C14[CAP_CERAMIC (GRM155R71C473KA88D)]
    C15[CAP_CERAMIC (GRM1555C1H101JA01D)]
    C16[CAP_CERAMIC (GRM1555C1H101JA01D)]
    C17[CAP_CERAMIC (GRM1555C1H221JA01D)]
    C18[CAP_CERAMIC (GRM1555C1H221JA01D)]
    C19[CAP_CERAMIC (GRM32ER71C226KA12L)]
    C20[CAP_CERAMIC (GRM32ER71C226KA12L)]
    C21[CAP_CERAMIC (GRM32ER71C476MA01L)]
    C22[CAP_CERAMIC (GRM32ER71C476MA01L)]
    R1[RESISTOR (CRCW06034K70FKEA)]
    R2[RESISTOR (CRCW0603100KFKEA)]
    R3[RESISTOR (CRCW0603200KFKEA)]
    R4[RESISTOR (CRCW06034K70FKEA)]
    R5[RESISTOR (CRCW06031K00FKEA)]
    R6[RESISTOR (CRCW06034K70FKEA)]
    R7[RESISTOR (CRCW06034K70FKEA)]
    R8[RESISTOR (CRCW06031K00FKEA)]
    R9[RESISTOR (CRCW06033K30FKEA)]
    R10[RESISTOR (CRCW06031K00FKEA)]
    R11[RESISTOR (CRCW0603100KFKEA)]
    R12[RESISTOR (CRCW06034K99FKEA)]
    J1 -->|RF_IN| U1
    J1 -->|RF_IN_DC_BLOCK| C1
    C1 -->|RF_IN_DC_BLOCK| U1
    U1 -->|LNA_OUT| C2
    C2 -->|LNA_OUT| U11
    U11 -->|MIXER_RF_IN| C3
    C3 -->|MIXER_RF_IN| U2
    J2 -->|LO_IN| C4
    C4 -->|LO_IN| U10
    U10 -->|LO_AMP_OUT| C5
    C5 -->|LO_AMP_OUT| U2
    U2 -->|IF_I_P| C6
    C6 -->|IF_I_P| U3
    U2 -->|IF_I_N| C7
    C7 -->|IF_I_N| U3
    U2 -->|IF_Q_P| C8
    C8 -->|IF_Q_P| U3
    U2 -->|IF_Q_N| C9
    C9 -->|IF_Q_N| U3
    U3 -->|AMP_OUT_I_P| C10
    C10 -->|AMP_OUT_I_P| U4
    U3 -->|AMP_OUT_I_N| C11
    C11 -->|AMP_OUT_I_N| U4
    U3 -->|AMP_OUT_Q_P| C12
    C12 -->|AMP_OUT_Q_P| U4
    U3 -->|AMP_OUT_Q_N| C13
    C13 -->|AMP_OUT_Q_N| U4
    U9 -->|ADC_CLK_P| U4
    U9 -->|ADC_CLK_N| U4
    U9 -->|DAC_CLK_P| U10
    U9 -->|DAC_CLK_N| U10
    J5 -->|CLK_REF_IN| U9
    J5 -->|CLK_REF_IN| U9
    J5 -->|SPI_SCLK| U4
    J5 -->|SPI_SDIO| U4
    J5 -->|SPI_CS| U4
    U4 -->|ADC_DATA_D0| J3
    U4 -->|ADC_DATA_D1| J3
    U4 -->|ADC_DATA_D2| J3
    U4 -->|ADC_DATA_D3| J3
    U4 -->|ADC_DATA_D4| J3
    U4 -->|ADC_DATA_D5| J3
    U4 -->|ADC_DATA_D6| J3
    U4 -->|ADC_DATA_D7| J3
    U4 -->|ADC_DATA_D8| J3
    U4 -->|ADC_DATA_D9| J3
    U4 -->|ADC_DATA_D10| J3
    U4 -->|ADC_DATA_D11| J3
    J4 -->|5V_MAIN| F1
    F1 -->|5V_MAIN| L1
    F1 -->|5V_MAIN| U8
    F1 -->|5V_MAIN| C19
    F1 -->|5V_MAIN| C20
    L1 -->|5V_FILT| C21
    L1 -->|5V_FILT| U1
    L1 -->|5V_FILT| U2
    L1 -->|5V_FILT| U10
    U8 -->|3V3_REG| L2
    U8 -->|3V3_REG| C22
    L2 -->|3V3_FILT| U5
    L2 -->|3V3_FILT| U7
    L2 -->|3V3_FILT| U9
    U5 -->|5V_LDO_OUT| L3
    U5 -->|5V_LDO_OUT| C15
    L3 -->|5V_AMP| U3
    L3 -->|5V_AMP| C16
    U7 -->|1V8_ADC| L4
    U7 -->|1V8_ADC| C17
    L4 -->|1V8_FILT| U4
    L4 -->|1V8_FILT| C18
    U6 -->|3V3_IO| L5
    U6 -->|3V3_IO| C14
    L5 -->|3V3_IO_FILT| U4
    L5 -->|3V3_IO_FILT| U9
    L5 -->|3V3_IO_FILT| R9
    J1 -->|GND| J4
    J1 -->|GND| J2
    J1 -->|GND| J3
    J1 -->|GND| J5
    J1 -->|GND| D1
    J1 -->|GND| C19
    J1 -->|GND| C20
    J1 -->|GND| C21
    J1 -->|GND| C22
    J1 -->|GND| C15
    J1 -->|GND| C16
    J1 -->|GND| C17
    J1 -->|GND| C18
    J1 -->|GND| C14
    U1 -->|GND| U2
    U1 -->|GND| U10
    U1 -->|GND| U11
    U1 -->|GND| U11
    U1 -->|GND| U8
    U1 -->|GND| U5
    U1 -->|GND| U6
    U1 -->|GND| U7
    U1 -->|GND| U3
    U1 -->|GND| U4
    U1 -->|GND| U9
    U1 -->|R1_TERM| R1
    R1 -->|R1_TERM| C2
    U3 -->|AMP_FB_I_P| R2
    R2 -->|AMP_FB_I_P| R3
    R3 -->|AMP_FB_I_P| C11
    U3 -->|AMP_FB_I_N| R4
    R4 -->|AMP_FB_I_N| R5
    R5 -->|AMP_FB_I_N| C10
    U3 -->|AMP_FB_Q_P| R6
    R6 -->|AMP_FB_Q_P| R7
    R7 -->|AMP_FB_Q_P| C12
    U3 -->|AMP_FB_Q_N| R8
    R8 -->|AMP_FB_Q_N| R10
    R10 -->|AMP_FB_Q_N| C13
    R9 -->|VDD_3V3_SEL| U6
    U6 -->|VDD_3V3_DIV| R10
    R10 -->|VDD_3V3_DIV| R11
    R11 -->|GND| U6
    R12 -->|LED_PWR| D2
    R12 -->|LED_PWR| U5
    D2 -->|GND| U5
    D1 -->|TVS_PROT| J4
    D1 -->|TVS_PROT| F1
```

## Component Instances

| Ref | Part Number | Component |
|---|---|---|
| U1 | HMC698LP4ETRS | HMC698LP4 |
| U2 | HMC1119LP4ETRS | HMC1119LP4 |
| U3 | ADA4817-1ACPZ-R7 | ADA4817-1 |
| U4 | ADC12J4000EVM | ADC12J4000 |
| U5 | TPS7A4700RGWT | TPS7A4700 |
| U6 | TPS7A4700RGWT | TPS7A4700 |
| U7 | TPS62130RGTT | TPS62130 |
| U8 | LMZ14203HVKIT | LMZ14203 |
| U9 | 568-10088-1018-1 | Si5345 |
| U10 | HMC364LP4ETRS | HMC364 |
| U11 | TCM1-63AX+ | TCM1-63AX+ |
| J1 | 142-0701-851 | SMA_CONNECTOR |
| J2 | 142-0701-851 | SMA_CONNECTOR |
| J3 | SAMTEC-HSTC-120 | HSTC_HEADER |
| J4 | MKDSN-1.5/2-5.08 | POWER_TERMINAL |
| J5 | PPTC021LFBN-RC | HEADER_2X5 |
| F1 | 0451005.NRLF | FUSE |
| D1 | SMBJ5.0CA | TVS_DIODE |
| D2 | LTST-C170KRKT | LED_INDICATOR |
| L1 | BLM18KG221TN1 | FERRITE_BEAD |
| L2 | BLM18KG221TN1 | FERRITE_BEAD |
| L3 | BLM18KG221TN1 | FERRITE_BEAD |
| L4 | 1008HQ-22NXJW | RF_CHOKE |
| L5 | 1008HQ-22NXJW | RF_CHOKE |
| C1 | GRM1555C1H4R7BA01D | CAP_CERAMIC |
| C2 | GJM1555C1H3R9BB01D | CAP_CERAMIC |
| C3 | GRM1555C1H4R7BA01D | CAP_CERAMIC |
| C4 | GJM1555C1H1R5BB01D | CAP_CERAMIC |
| C5 | GJM1555C1H1R5BB01D | CAP_CERAMIC |
| C6 | GRM1555C1H3R3BA01D | CAP_CERAMIC |
| C7 | GJM1555C1H1R0BB01D | CAP_CERAMIC |
| C8 | GJM1555C1H1R0BB01D | CAP_CERAMIC |
| C9 | GJM1555C1H1R8BB01D | CAP_CERAMIC |
| C10 | GJM1555C1H1R8BB01D | CAP_CERAMIC |
| C11 | GJM1555C1H1R5BB01D | CAP_CERAMIC |
| C12 | GJM1555C1H1R5BB01D | CAP_CERAMIC |
| C13 | GRM155R71C473KA88D | CAP_CERAMIC |
| C14 | GRM155R71C473KA88D | CAP_CERAMIC |
| C15 | GRM1555C1H101JA01D | CAP_CERAMIC |
| C16 | GRM1555C1H101JA01D | CAP_CERAMIC |
| C17 | GRM1555C1H221JA01D | CAP_CERAMIC |
| C18 | GRM1555C1H221JA01D | CAP_CERAMIC |
| C19 | GRM32ER71C226KA12L | CAP_CERAMIC |
| C20 | GRM32ER71C226KA12L | CAP_CERAMIC |
| C21 | GRM32ER71C476MA01L | CAP_CERAMIC |
| C22 | GRM32ER71C476MA01L | CAP_CERAMIC |
| R1 | CRCW06034K70FKEA | RESISTOR |
| R2 | CRCW0603100KFKEA | RESISTOR |
| R3 | CRCW0603200KFKEA | RESISTOR |
| R4 | CRCW06034K70FKEA | RESISTOR |
| R5 | CRCW06031K00FKEA | RESISTOR |
| R6 | CRCW06034K70FKEA | RESISTOR |
| R7 | CRCW06034K70FKEA | RESISTOR |
| R8 | CRCW06031K00FKEA | RESISTOR |
| R9 | CRCW06033K30FKEA | RESISTOR |
| R10 | CRCW06031K00FKEA | RESISTOR |
| R11 | CRCW0603100KFKEA | RESISTOR |
| R12 | CRCW06034K99FKEA | RESISTOR |

## Pin-to-Pin Connections

| Net | From | Pin | To | Pin | Type |
|---|---|---|---|---|---|
| RF_IN | J1 | 1 | U1 | 1 | RF |
| RF_IN_DC_BLOCK | J1 | 1 | C1 | 1 | RF |
| RF_IN_DC_BLOCK | C1 | 2 | U1 | 1 | RF |
| LNA_OUT | U1 | 4 | C2 | 1 | RF |
| LNA_OUT | C2 | 2 | U11 | 1 | RF |
| MIXER_RF_IN | U11 | 2 | C3 | 1 | RF |
| MIXER_RF_IN | C3 | 2 | U2 | 1 | RF |
| LO_IN | J2 | 1 | C4 | 1 | RF |
| LO_IN | C4 | 2 | U10 | 1 | RF |
| LO_AMP_OUT | U10 | 4 | C5 | 1 | RF |
| LO_AMP_OUT | C5 | 2 | U2 | 8 | RF |
| IF_I_P | U2 | 4 | C6 | 1 | analog |
| IF_I_P | C6 | 2 | U3 | 3 | analog |
| IF_I_N | U2 | 5 | C7 | 1 | analog |
| IF_I_N | C7 | 2 | U3 | 4 | analog |
| IF_Q_P | U2 | 6 | C8 | 1 | analog |
| IF_Q_P | C8 | 2 | U3 | 5 | analog |
| IF_Q_N | U2 | 7 | C9 | 1 | analog |
| IF_Q_N | C9 | 2 | U3 | 6 | analog |
| AMP_OUT_I_P | U3 | 8 | C10 | 1 | analog |
| AMP_OUT_I_P | C10 | 2 | U4 | A7 | analog |
| AMP_OUT_I_N | U3 | 1 | C11 | 1 | analog |
| AMP_OUT_I_N | C11 | 2 | U4 | A8 | analog |
| AMP_OUT_Q_P | U3 | 2 | C12 | 1 | analog |
| AMP_OUT_Q_P | C12 | 2 | U4 | A9 | analog |
| AMP_OUT_Q_N | U3 | 7 | C13 | 1 | analog |
| AMP_OUT_Q_N | C13 | 2 | U4 | A10 | analog |
| ADC_CLK_P | U9 | 15 | U4 | H12 | clock |
| ADC_CLK_N | U9 | 16 | U4 | H13 | clock |
| DAC_CLK_P | U9 | 17 | U10 | 3 | clock |
| DAC_CLK_N | U9 | 18 | U10 | 2 | clock |
| CLK_REF_IN | J5 | 1 | U9 | 1 | clock |
| CLK_REF_IN | J5 | 3 | U9 | 2 | clock |
| SPI_SCLK | J5 | 5 | U4 | B1 | digital |
| SPI_SDIO | J5 | 7 | U4 | A2 | digital |
| SPI_CS | J5 | 9 | U4 | C3 | digital |
| ADC_DATA_D0 | U4 | J1 | J3 | 1 | digital |
| ADC_DATA_D1 | U4 | K2 | J3 | 2 | digital |
| ADC_DATA_D2 | U4 | L3 | J3 | 3 | digital |
| ADC_DATA_D3 | U4 | M4 | J3 | 4 | digital |
| ADC_DATA_D4 | U4 | N5 | J3 | 5 | digital |
| ADC_DATA_D5 | U4 | P6 | J3 | 6 | digital |
| ADC_DATA_D6 | U4 | R7 | J3 | 7 | digital |
| ADC_DATA_D7 | U4 | T8 | J3 | 8 | digital |
| ADC_DATA_D8 | U4 | U1 | J3 | 9 | digital |
| ADC_DATA_D9 | U4 | V2 | J3 | 10 | digital |
| ADC_DATA_D10 | U4 | W3 | J3 | 11 | digital |
| ADC_DATA_D11 | U4 | Y4 | J3 | 12 | digital |
| 5V_MAIN | J4 | 1 | F1 | 1 | power |
| 5V_MAIN | F1 | 2 | L1 | 1 | power |
| 5V_MAIN | F1 | 2 | U8 | 1 | power |
| 5V_MAIN | F1 | 2 | C19 | 1 | power |
| 5V_MAIN | F1 | 2 | C20 | 1 | power |
| 5V_FILT | L1 | 2 | C21 | 1 | power |
| 5V_FILT | L1 | 2 | U1 | 3 | power |
| 5V_FILT | L1 | 2 | U2 | 3 | power |
| 5V_FILT | L1 | 2 | U10 | 6 | power |
| 3V3_REG | U8 | 3 | L2 | 1 | power |
| 3V3_REG | U8 | 3 | C22 | 1 | power |
| 3V3_FILT | L2 | 2 | U5 | 5 | power |
| 3V3_FILT | L2 | 2 | U7 | 1 | power |
| 3V3_FILT | L2 | 2 | U9 | 9 | power |
| 5V_LDO_OUT | U5 | 6 | L3 | 1 | power |
| 5V_LDO_OUT | U5 | 6 | C15 | 1 | power |
| 5V_AMP | L3 | 2 | U3 | 9 | power |
| 5V_AMP | L3 | 2 | C16 | 1 | power |
| 1V8_ADC | U7 | 6 | L4 | 1 | power |
| 1V8_ADC | U7 | 6 | C17 | 1 | power |
| 1V8_FILT | L4 | 2 | U4 | K10 | power |
| 1V8_FILT | L4 | 2 | C18 | 1 | power |
| 3V3_IO | U6 | 6 | L5 | 1 | power |
| 3V3_IO | U6 | 6 | C14 | 1 | power |
| 3V3_IO_FILT | L5 | 2 | U4 | A5 | power |
| 3V3_IO_FILT | L5 | 2 | U9 | 19 | power |
| 3V3_IO_FILT | L5 | 2 | R9 | 1 | power |
| GND | J1 | 2 | J4 | 2 | ground |
| GND | J1 | 2 | J2 | 2 | ground |
| GND | J1 | 12 | J3 |  | ground |
| GND | J1 | 10 | J5 |  | ground |
| GND | J1 | 2 | D1 | 2 | ground |
| GND | J1 | 2 | C19 | 2 | ground |
| GND | J1 | 2 | C20 | 2 | ground |
| GND | J1 | 2 | C21 | 2 | ground |
| GND | J1 | 2 | C22 | 2 | ground |
| GND | J1 | 2 | C15 | 2 | ground |
| GND | J1 | 2 | C16 | 2 | ground |
| GND | J1 | 2 | C17 | 2 | ground |
| GND | J1 | 2 | C18 | 2 | ground |
| GND | J1 | 2 | C14 | 2 | ground |
| GND | U1 | 2 | U2 | 2 | ground |
| GND | U1 | 2 | U10 | 5 | ground |
| GND | U1 | 2 | U11 | 3 | ground |
| GND | U1 | 2 | U11 | 4 | ground |
| GND | U1 | 2 | U8 | 2 | ground |
| GND | U1 | 2 | U5 |  | ground |
| GND | U1 | 2 | U6 |  | ground |
| GND | U1 | 2 | U7 |  | ground |
| GND | U1 | 10 | U3 |  | ground |
| GND | U1 | 2 | U4 | G10 | ground |
| GND | U1 | 4 | U9 |  | ground |
| R1_TERM | U1 | 4 | R1 | 1 | analog |
| R1_TERM | R1 | 2 | C2 | 1 | analog |
| AMP_FB_I_P | U3 | 1 | R2 | 1 | analog |
| AMP_FB_I_P | R2 | 2 | R3 | 1 | analog |
| AMP_FB_I_P | R3 | 2 | C11 | 1 | analog |
| AMP_FB_I_N | U3 | 8 | R4 | 1 | analog |
| AMP_FB_I_N | R4 | 2 | R5 | 1 | analog |
| AMP_FB_I_N | R5 | 2 | C10 | 1 | analog |
| AMP_FB_Q_P | U3 | 2 | R6 | 1 | analog |
| AMP_FB_Q_P | R6 | 2 | R7 | 1 | analog |
| AMP_FB_Q_P | R7 | 2 | C12 | 1 | analog |
| AMP_FB_Q_N | U3 | 7 | R8 | 1 | analog |
| AMP_FB_Q_N | R8 | 2 | R10 | 1 | analog |
| AMP_FB_Q_N | R10 | 2 | C13 | 1 | analog |
| VDD_3V3_SEL | R9 | 2 | U6 | 4 | power |
| VDD_3V3_DIV | U6 | 4 | R10 | 2 | power |
| VDD_3V3_DIV | R10 | 2 | R11 | 1 | power |
| GND | R11 | 2 | U6 | 2 | ground |
| LED_PWR | R12 | 1 | D2 | 1 | power |
| LED_PWR | R12 | 2 | U5 | 6 | power |
| GND | D2 | 2 | U5 | 2 | ground |
| TVS_PROT | D1 | 1 | J4 | 1 | power |
| TVS_PROT | D1 | 1 | F1 | 1 | power |

## Net Connection List

| Net Name | Reference Designator - Pin No. |
|----------|-------------------------------|
| 1V8_ADC | U7 - 6,  L4 - 1,  C17 - 1 |
| 1V8_FILT | L4 - 2,  U4 - K10,  C18 - 1 |
| 3V3_FILT | L2 - 2,  U5 - 5,  U7 - 1,  U9 - 9 |
| 3V3_IO | U6 - 6,  L5 - 1,  C14 - 1 |
| 3V3_IO_FILT | L5 - 2,  U4 - A5,  U9 - 19,  R9 - 1 |
| 3V3_REG | U8 - 3,  L2 - 1,  C22 - 1 |
| 5V_AMP | L3 - 2,  U3 - 9,  C16 - 1 |
| 5V_FILT | L1 - 2,  C21 - 1,  U1 - 3,  U2 - 3,  U10 - 6 |
| 5V_LDO_OUT | U5 - 6,  L3 - 1,  C15 - 1 |
| 5V_MAIN | J4 - 1,  F1 - 1,  F1 - 2,  L1 - 1,  U8 - 1,  C19 - 1,  C20 - 1 |
| ADC_CLK_N | U9 - 16,  U4 - H13 |
| ADC_CLK_P | U9 - 15,  U4 - H12 |
| ADC_DATA_D0 | U4 - J1,  J3 - 1 |
| ADC_DATA_D1 | U4 - K2,  J3 - 2 |
| ADC_DATA_D10 | U4 - W3,  J3 - 11 |
| ADC_DATA_D11 | U4 - Y4,  J3 - 12 |
| ADC_DATA_D2 | U4 - L3,  J3 - 3 |
| ADC_DATA_D3 | U4 - M4,  J3 - 4 |
| ADC_DATA_D4 | U4 - N5,  J3 - 5 |
| ADC_DATA_D5 | U4 - P6,  J3 - 6 |
| ADC_DATA_D6 | U4 - R7,  J3 - 7 |
| ADC_DATA_D7 | U4 - T8,  J3 - 8 |
| ADC_DATA_D8 | U4 - U1,  J3 - 9 |
| ADC_DATA_D9 | U4 - V2,  J3 - 10 |
| AMP_FB_I_N | U3 - 8,  R4 - 1,  R4 - 2,  R5 - 1,  R5 - 2,  C10 - 1 |
| AMP_FB_I_P | U3 - 1,  R2 - 1,  R2 - 2,  R3 - 1,  R3 - 2,  C11 - 1 |
| AMP_FB_Q_N | U3 - 7,  R8 - 1,  R8 - 2,  R10 - 1,  R10 - 2,  C13 - 1 |
| AMP_FB_Q_P | U3 - 2,  R6 - 1,  R6 - 2,  R7 - 1,  R7 - 2,  C12 - 1 |
| AMP_OUT_I_N | U3 - 1,  C11 - 1,  C11 - 2,  U4 - A8 |
| AMP_OUT_I_P | U3 - 8,  C10 - 1,  C10 - 2,  U4 - A7 |
| AMP_OUT_Q_N | U3 - 7,  C13 - 1,  C13 - 2,  U4 - A10 |
| AMP_OUT_Q_P | U3 - 2,  C12 - 1,  C12 - 2,  U4 - A9 |
| CLK_REF_IN | J5 - 1,  U9 - 1,  J5 - 3,  U9 - 2 |
| DAC_CLK_N | U9 - 18,  U10 - 2 |
| DAC_CLK_P | U9 - 17,  U10 - 3 |
| GND | J1 - 2,  J4 - 2,  J2 - 2,  J1 - 12,  J3 - ,  J1 - 10,  J5 - ,  D1 - 2,  C19 - 2,  C20 - 2,  C21 - 2,  C22 - 2,  C15 - 2,  C16 - 2,  C17 - 2,  C18 - 2,  C14 - 2,  U1 - 2,  U2 - 2,  U10 - 5,  U11 - 3,  U11 - 4,  U8 - 2,  U5 - ,  U6 - ,  U7 - ,  U1 - 10,  U3 - ,  U4 - G10,  U1 - 4,  U9 - ,  R11 - 2,  U6 - 2,  D2 - 2,  U5 - 2 |
| IF_I_N | U2 - 5,  C7 - 1,  C7 - 2,  U3 - 4 |
| IF_I_P | U2 - 4,  C6 - 1,  C6 - 2,  U3 - 3 |
| IF_Q_N | U2 - 7,  C9 - 1,  C9 - 2,  U3 - 6 |
| IF_Q_P | U2 - 6,  C8 - 1,  C8 - 2,  U3 - 5 |
| LED_PWR | R12 - 1,  D2 - 1,  R12 - 2,  U5 - 6 |
| LNA_OUT | U1 - 4,  C2 - 1,  C2 - 2,  U11 - 1 |
| LO_AMP_OUT | U10 - 4,  C5 - 1,  C5 - 2,  U2 - 8 |
| LO_IN | J2 - 1,  C4 - 1,  C4 - 2,  U10 - 1 |
| MIXER_RF_IN | U11 - 2,  C3 - 1,  C3 - 2,  U2 - 1 |
| R1_TERM | U1 - 4,  R1 - 1,  R1 - 2,  C2 - 1 |
| RF_IN | J1 - 1,  U1 - 1 |
| RF_IN_DC_BLOCK | J1 - 1,  C1 - 1,  C1 - 2,  U1 - 1 |
| SPI_CS | J5 - 9,  U4 - C3 |
| SPI_SCLK | J5 - 5,  U4 - B1 |
| SPI_SDIO | J5 - 7,  U4 - A2 |
| TVS_PROT | D1 - 1,  J4 - 1,  F1 - 1 |
| VDD_3V3_DIV | U6 - 4,  R10 - 2,  R11 - 1 |
| VDD_3V3_SEL | R9 - 2,  U6 - 4 |

## Validation Notes

- CRITICAL: 3V3 IO supply not connected to U4 IO bank - verify ADC datasheet pin A5 is correct IO supply pin
- CRITICAL: U3 configured for differential input but single-ended output recommended - verify datasheet configuration
- WARNING: LO amplifier U10 may not provide sufficient drive for mixer LO port - minimum +10dBm required
- WARNING: IF amplifier U3 bandwidth (1GHz) may not support full 6GHz IF from mixer - consider dual-stage amplification
- INFO: Clock generator U9 pin mapping estimated - verify Si5345 datasheet for correct pin assignments
- INFO: ADC digital outputs D0-D11 assumed LVDS - verify J3 HSTC connector matches ADC interface standard
- INFO: RF matching networks not included - 50-ohm transmission line matching required for U1 and U2 inputs/outputs
- INFO: Mixer I and Q outputs combined - netlist shows single output path, verify balun configuration
- INFO: Power budget estimated at 1.5A maximum - verify supply can deliver required current
- RECOMMENDATION: Add 0.1uF ceramic capacitors close to each IC power pin for high-frequency decoupling
- RECOMMENDATION: Consider adding EMI suppression ferrite beads on all DC supply lines entering RF section
- RECOMMENDATION: Verify ADC input common-mode voltage matches U3 output or add AC coupling capacitors