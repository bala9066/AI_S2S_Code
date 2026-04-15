# Logical Netlist
## hgyu

## Block Diagram

```mermaid
graph TB
    U1[HMC1132LP6GE (HMC1132LP6GE)]
    U2[HMC698LP4 (HMC698LP4)]
    U3[HMC698LP4 (HMC698LP4)]
    U4[ADC10DX100 (ADC10DX100IRGZ)]
    U5[LMK04828 (LMK04828B-NOPB)]
    U6[TPS7A4700 (TPS7A4700RGWT)]
    U7[TPS7A4700 (TPS7A4700RGWT)]
    U8[LTC3260 (LTC3260MPFE-1#PBF)]
    J1[SMA_CONNECTOR (CON-SMA-EDGE-S)]
    J2[SMA_CONNECTOR (CON-SMA-EDGE-S)]
    J3[SMA_CONNECTOR (CON-SMA-EDGE-S)]
    J4[FMC_HPC (FMC-HPC-Connector)]
    C1[CAPACITOR (GRM1555C1H220FA01J)]
    C2[CAPACITOR (GRM1555C1H220FA01J)]
    C3[CAPACITOR (GRM1555C1H220FA01J)]
    C4[CAPACITOR (GRM1555C1H220FA01J)]
    C5[CAPACITOR (GRM1555C1H220FA01J)]
    C6[CAPACITOR (GRT155R61E475ME13D)]
    C7[CAPACITOR (GRT155R61E475ME13D)]
    C8[CAPACITOR (GRT155R61E475ME13D)]
    C9[CAPACITOR (GRT155R61E475ME13D)]
    C10[CAPACITOR (GRM32ER71E476ME15L)]
    C11[CAPACITOR (GRM32ER71E476ME15L)]
    C12[CAPACITOR (GRM32ER71E476ME15L)]
    C13[CAPACITOR (GRT155R61E475ME13D)]
    C14[CAPACITOR (GRM1555C1H220FA01J)]
    C15[CAPACITOR (GRM1555C1H220FA01J)]
    C16[CAPACITOR (GRM1555C1H220FA01J)]
    C17[CAPACITOR (GRM1555C1H220FA01J)]
    C18[CAPACITOR (GRM1555C1H220FA01J)]
    C19[CAPACITOR (GRM1555C1H220FA01J)]
    C20[CAPACITOR (GRM32ER71E476ME15L)]
    C21[CAPACITOR (GRM32ER71E476ME15L)]
    C22[CAPACITOR (GRM32ER71E476ME15L)]
    C23[CAPACITOR (GRM32ER71E476ME15L)]
    L1[INDUCTOR (LQG31PN4N7M00L)]
    L2[INDUCTOR (LQG31PN4N7M00L)]
    L3[INDUCTOR (LQG31PN4N7M00L)]
    R1[RESISTOR (ERA-6AEB4993V)]
    R2[RESISTOR (ERA-6AEB4993V)]
    R3[RESISTOR (ERA-6AEB102V)]
    R4[RESISTOR (ERA-6AEB102V)]
    R5[RESISTOR (ERA-6AEB5136V)]
    R6[RESISTOR (CRCW25123K00FKEG)]
    R7[RESISTOR (ERA-6AEB103V)]
    R8[RESISTOR (ERA-6AEB5136V)]
    R9[RESISTOR (ERA-6AEB102V)]
    R10[RESISTOR (ERA-6AEB103V)]
    R11[RESISTOR (ERA-6AEB5136V)]
    R12[RESISTOR (ERA-6AEB103V)]
    R13[RESISTOR (ERA-6AEB102V)]
    R14[RESISTOR (ERA-6AEB5136V)]
    T1[RF_TRANSFORMER (TCM1-63+)]
    J1 -->|RF_IN| U1
    U1 -->|RF_LNA_OUT| U2
    U2 -->|RF_ATT1_OUT| U3
    U3 -->|RF_ATT2_OUT| T1
    T1 -->|RF_ADC_IN_P| U4
    T1 -->|RF_ADC_IN_N| U4
    J2 -->|CLK_REF_IN| U5
    U5 -->|CLK_ADC| U4
    U5 -->|CLK_SYSREF| U4
    U4 -->|JESD_D0_P| J4
    U4 -->|JESD_D0_N| J4
    U4 -->|JESD_D1_P| J4
    U4 -->|JESD_D1_N| J4
    U4 -->|JESD_D2_P| J4
    U4 -->|JESD_D2_N| J4
    U4 -->|JESD_D3_P| J4
    U4 -->|JESD_D3_N| J4
    U4 -->|JESD_D4_P| J4
    U4 -->|JESD_D4_N| J4
    U4 -->|JESD_D5_P| J4
    U4 -->|JESD_D5_N| J4
    U4 -->|JESD_D6_P| J4
    U4 -->|JESD_D6_N| J4
    U4 -->|JESD_D7_P| J4
    U4 -->|JESD_D7_N| J4
    U4 -->|JESD_SYNC_P| J4
    U4 -->|JESD_SYNC_N| J4
    J4 -->|SPI_SCLK| U4
    J4 -->|SPI_SCLK_U5| U5
    J4 -->|SPI_SDI_U4| U4
    J4 -->|SPI_SDI_U5| U5
    U4 -->|SPI_SDO_U4| J4
    U5 -->|SPI_SDO_U5| J4
    J4 -->|SPI_CS_U4| U4
    J4 -->|SPI_CS_U5| U5
    J4 -->|ATT1_LE| U2
    J4 -->|ATT2_LE| U3
    J4 -->|ATT1_D0| U2
    J4 -->|ATT2_D0| U3
    J4 -->|ATT1_D1| U2
    J4 -->|ATT2_D1| U3
    J4 -->|ATT1_D2| U2
    J4 -->|ATT2_D2| U3
    J4 -->|ATT1_D3| U2
    J4 -->|ATT2_D3| U3
    J4 -->|ATT1_D4| U2
    J4 -->|ATT2_D4| U3
    J4 -->|ATT1_D5| U2
    J4 -->|ATT2_D5| U3
    J3 -->|+5V| U6
    J3 -->|+5V| U8
    U6 -->|+5V_LNA| U1
    U7 -->|+3V3_DIG| U4
    U7 -->|+3V3_DIG| U5
    U7 -->|+3V3_DIG| U2
    U7 -->|+3V3_DIG| U3
    U8 -->|+1V8_ADC| U4
    U8 -->|+1V0_CORE| U4
    U1 -->|GND| U2
    U2 -->|GND| U3
    U3 -->|GND| U4
    U4 -->|GND| U5
    U5 -->|GND| J1
    J1 -->|GND| J2
    J2 -->|GND| J3
    J3 -->|GND| J4
    J4 -->|GND| C1
    C1 -->|GND| C2
    C2 -->|GND| C3
    C3 -->|GND| C4
    C4 -->|GND| C5
    C5 -->|GND| C6
    C6 -->|GND| C7
    C7 -->|GND| C8
    C8 -->|GND| C9
    C9 -->|GND| C10
    C10 -->|GND| C11
    C11 -->|GND| C12
    C12 -->|GND| C13
    C13 -->|GND| C14
    C14 -->|GND| C15
    C15 -->|GND| 
    C16 -->|GND| C17
    C17 -->|GND| C18
    C18 -->|GND| C19
    C19 -->|GND| C20
    C20 -->|GND| C21
    C21 -->|GND| C22
    C22 -->|GND| C23
    C23 -->|GND| R10
    R10 -->|GND| R12
    R12 -->|GND| R14
    R14 -->|GND| U6
    U6 -->|GND| U7
    U7 -->|GND| U8
    U6 -->|+5V| C1
    C1 -->|+5V| C6
    C6 -->|+5V| C10
    C10 -->|+5V| C20
    U7 -->|+3V3_DIG| C2
    C2 -->|+3V3_DIG| C7
    C7 -->|+3V3_DIG| C11
    C11 -->|+3V3_DIG| C21
    U8 -->|+1V8_ADC| C3
    C3 -->|+1V8_ADC| C8
    C8 -->|+1V8_ADC| C12
    C12 -->|+1V8_ADC| C22
    U8 -->|+1V0_CORE| C4
    C4 -->|+1V0_CORE| C9
    C9 -->|+1V0_CORE| C13
    C13 -->|+1V0_CORE| C23
    J3 -->|+5V| L1
    L1 -->|+5V_FILTERED| C5
    C5 -->|+5V_FILTERED| U6
    U1 -->|+5V_LNA| C14
    C14 -->|+5V_LNA| C15
    U2 -->|+3V3_DIG| C16
    C16 -->|+3V3_DIG| C17
    U3 -->|+3V3_DIG| C18
    C18 -->|+3V3_DIG| C19
    J4 -->|LNA_ENABLE| R1
    R1 -->|LNA_ENABLE_BIAS| U1
    J4 -->|ADC_RESET| R2
    R2 -->|ADC_RESET_FILTERED| C14
    C14 -->|ADC_RESET_FILTERED| U4
    J4 -->|ADC_PD| R3
    R3 -->|ADC_PD_BIAS| U4
    J4 -->|LDO_EN_5V| R4
    R4 -->|LDO_EN_5V_BIAS| U6
    J4 -->|LDO_EN_3V3| R5
    R5 -->|LDO_EN_3V3_BIAS| U7
    J4 -->|LDO_EN_1V8| R6
    R6 -->|LDO_EN_1V8_BIAS| U8
    J4 -->|LDO_EN_1V0| R7
    R7 -->|LDO_EN_1V0_BIAS| U8
    J2 -->|CLK_REF_P| R8
    R8 -->|CLK_REF_FILTERED| U5
    J2 -->|CLK_REF_N| R9
    R9 -->|CLK_REF_N_FILTERED| U5
    U4 -->|VREF_ADC_P| R11
    R11 -->|VREF_ADC_P_FILTERED| C13
    U4 -->|VREF_ADC_N| R12
    R12 -->|VREF_ADC_N_FILTERED| C13
    U5 -->|VREF_CLK| R13
    R13 -->|VREF_CLK_FILTERED| C14
    U6 -->|LDO_FB_5V| R14
    U7 -->|LDO_FB_3V3| R10
```

## Component Instances

| Ref | Part Number | Component |
|---|---|---|
| U1 | HMC1132LP6GE | HMC1132LP6GE |
| U2 | HMC698LP4 | HMC698LP4 |
| U3 | HMC698LP4 | HMC698LP4 |
| U4 | ADC10DX100IRGZ | ADC10DX100 |
| U5 | LMK04828B-NOPB | LMK04828 |
| U6 | TPS7A4700RGWT | TPS7A4700 |
| U7 | TPS7A4700RGWT | TPS7A4700 |
| U8 | LTC3260MPFE-1#PBF | LTC3260 |
| J1 | CON-SMA-EDGE-S | SMA_CONNECTOR |
| J2 | CON-SMA-EDGE-S | SMA_CONNECTOR |
| J3 | CON-SMA-EDGE-S | SMA_CONNECTOR |
| J4 | FMC-HPC-Connector | FMC_HPC |
| C1 | GRM1555C1H220FA01J | CAPACITOR |
| C2 | GRM1555C1H220FA01J | CAPACITOR |
| C3 | GRM1555C1H220FA01J | CAPACITOR |
| C4 | GRM1555C1H220FA01J | CAPACITOR |
| C5 | GRM1555C1H220FA01J | CAPACITOR |
| C6 | GRT155R61E475ME13D | CAPACITOR |
| C7 | GRT155R61E475ME13D | CAPACITOR |
| C8 | GRT155R61E475ME13D | CAPACITOR |
| C9 | GRT155R61E475ME13D | CAPACITOR |
| C10 | GRM32ER71E476ME15L | CAPACITOR |
| C11 | GRM32ER71E476ME15L | CAPACITOR |
| C12 | GRM32ER71E476ME15L | CAPACITOR |
| C13 | GRT155R61E475ME13D | CAPACITOR |
| C14 | GRM1555C1H220FA01J | CAPACITOR |
| C15 | GRM1555C1H220FA01J | CAPACITOR |
| C16 | GRM1555C1H220FA01J | CAPACITOR |
| C17 | GRM1555C1H220FA01J | CAPACITOR |
| C18 | GRM1555C1H220FA01J | CAPACITOR |
| C19 | GRM1555C1H220FA01J | CAPACITOR |
| C20 | GRM32ER71E476ME15L | CAPACITOR |
| C21 | GRM32ER71E476ME15L | CAPACITOR |
| C22 | GRM32ER71E476ME15L | CAPACITOR |
| C23 | GRM32ER71E476ME15L | CAPACITOR |
| L1 | LQG31PN4N7M00L | INDUCTOR |
| L2 | LQG31PN4N7M00L | INDUCTOR |
| L3 | LQG31PN4N7M00L | INDUCTOR |
| R1 | ERA-6AEB4993V | RESISTOR |
| R2 | ERA-6AEB4993V | RESISTOR |
| R3 | ERA-6AEB102V | RESISTOR |
| R4 | ERA-6AEB102V | RESISTOR |
| R5 | ERA-6AEB5136V | RESISTOR |
| R6 | CRCW25123K00FKEG | RESISTOR |
| R7 | ERA-6AEB103V | RESISTOR |
| R8 | ERA-6AEB5136V | RESISTOR |
| R9 | ERA-6AEB102V | RESISTOR |
| R10 | ERA-6AEB103V | RESISTOR |
| R11 | ERA-6AEB5136V | RESISTOR |
| R12 | ERA-6AEB103V | RESISTOR |
| R13 | ERA-6AEB102V | RESISTOR |
| R14 | ERA-6AEB5136V | RESISTOR |
| T1 | TCM1-63+ | RF_TRANSFORMER |

## Pin-to-Pin Connections

| Net | From | Pin | To | Pin | Type |
|---|---|---|---|---|---|
| RF_IN | J1 | 1 | U1 | RF_IN | RF |
| RF_LNA_OUT | U1 | RF_OUT | U2 | RF_IN | RF |
| RF_ATT1_OUT | U2 | RF_OUT | U3 | RF_IN | RF |
| RF_ATT2_OUT | U3 | RF_OUT | T1 | 1 | RF |
| RF_ADC_IN_P | T1 | 3 | U4 | AIN_P | RF_DIFF |
| RF_ADC_IN_N | T1 | 4 | U4 | AIN_N | RF_DIFF |
| CLK_REF_IN | J2 | 1 | U5 | CLK_IN0 | CLOCK |
| CLK_ADC | U5 | CLK_OUT0 | U4 | CLK_IN | CLOCK |
| CLK_SYSREF | U5 | CLK_OUT1 | U4 | SYSREF | CLOCK |
| JESD_D0_P | U4 | D0_P | J4 | DP0_P | LVDS |
| JESD_D0_N | U4 | D0_N | J4 | DP0_N | LVDS |
| JESD_D1_P | U4 | D1_P | J4 | DP1_P | LVDS |
| JESD_D1_N | U4 | D1_N | J4 | DP1_N | LVDS |
| JESD_D2_P | U4 | D2_P | J4 | DP2_P | LVDS |
| JESD_D2_N | U4 | D2_N | J4 | DP2_N | LVDS |
| JESD_D3_P | U4 | D3_P | J4 | DP3_P | LVDS |
| JESD_D3_N | U4 | D3_N | J4 | DP3_N | LVDS |
| JESD_D4_P | U4 | D4_P | J4 | DP4_P | LVDS |
| JESD_D4_N | U4 | D4_N | J4 | DP4_N | LVDS |
| JESD_D5_P | U4 | D5_P | J4 | DP5_P | LVDS |
| JESD_D5_N | U4 | D5_N | J4 | DP5_N | LVDS |
| JESD_D6_P | U4 | D6_P | J4 | DP6_P | LVDS |
| JESD_D6_N | U4 | D6_N | J4 | DP6_N | LVDS |
| JESD_D7_P | U4 | D7_P | J4 | DP7_P | LVDS |
| JESD_D7_N | U4 | D7_N | J4 | DP7_N | LVDS |
| JESD_SYNC_P | U4 | SYNC_P | J4 | SYNC_P | LVDS |
| JESD_SYNC_N | U4 | SYNC_N | J4 | SYNC_N | LVDS |
| SPI_SCLK | J4 | SCLK | U4 | SCLK | SPI |
| SPI_SCLK_U5 | J4 | SCLK | U5 | SCLK | SPI |
| SPI_SDI_U4 | J4 | MOSI | U4 | SDI | SPI |
| SPI_SDI_U5 | J4 | MOSI | U5 | SDI | SPI |
| SPI_SDO_U4 | U4 | SDO | J4 | MISO | SPI |
| SPI_SDO_U5 | U5 | SDO | J4 | MISO | SPI |
| SPI_CS_U4 | J4 | CS0 | U4 | CS | SPI |
| SPI_CS_U5 | J4 | CS1 | U5 | CS | SPI |
| ATT1_LE | J4 | GPIO0 | U2 | LE | DIGITAL |
| ATT2_LE | J4 | GPIO1 | U3 | LE | DIGITAL |
| ATT1_D0 | J4 | GPIO2 | U2 | D0 | DIGITAL |
| ATT2_D0 | J4 | GPIO2 | U3 | D0 | DIGITAL |
| ATT1_D1 | J4 | GPIO3 | U2 | D1 | DIGITAL |
| ATT2_D1 | J4 | GPIO3 | U3 | D1 | DIGITAL |
| ATT1_D2 | J4 | GPIO4 | U2 | D2 | DIGITAL |
| ATT2_D2 | J4 | GPIO4 | U3 | D2 | DIGITAL |
| ATT1_D3 | J4 | GPIO5 | U2 | D3 | DIGITAL |
| ATT2_D3 | J4 | GPIO5 | U3 | D3 | DIGITAL |
| ATT1_D4 | J4 | GPIO6 | U2 | D4 | DIGITAL |
| ATT2_D4 | J4 | GPIO6 | U3 | D4 | DIGITAL |
| ATT1_D5 | J4 | GPIO7 | U2 | D5 | DIGITAL |
| ATT2_D5 | J4 | GPIO7 | U3 | D5 | DIGITAL |
| +5V | J3 | 1 | U6 | VIN | POWER |
| +5V | J3 | 1 | U8 | VIN | POWER |
| +5V_LNA | U6 | VOUT | U1 | VDD | POWER |
| +3V3_DIG | U7 | VOUT | U4 | DVDD | POWER |
| +3V3_DIG | U7 | VOUT | U5 | DVDD | POWER |
| +3V3_DIG | U7 | VOUT | U2 | VDD | POWER |
| +3V3_DIG | U7 | VOUT | U3 | VDD | POWER |
| +1V8_ADC | U8 | VOUT1 | U4 | AVDD | POWER |
| +1V0_CORE | U8 | VOUT2 | U4 | CVDD | POWER |
| GND | U1 | GND | U2 | GND | GROUND |
| GND | U2 | GND | U3 | GND | GROUND |
| GND | U3 | GND | U4 |  | GROUND |
| GND | U4 | GND | U5 | GND | GROUND |
| GND | U5 | GND | J1 | 2 | GROUND |
| GND | J1 | 2 | J2 | 2 | GROUND |
| GND | J2 | 2 | J3 | 2 | GROUND |
| GND | J3 | 2 | J4 | GND | GROUND |
| GND | J4 | GND | C1 | 2 | GROUND |
| GND | C1 | 2 | C2 | 2 | GROUND |
| GND | C2 | 2 | C3 | 2 | GROUND |
| GND | C3 | 2 | C4 | 2 | GROUND |
| GND | C4 | 2 | C5 | 2 | GROUND |
| GND | C5 | 2 | C6 | 2 | GROUND |
| GND | C6 | 2 | C7 | 2 | GROUND |
| GND | C7 | 2 | C8 | 2 | GROUND |
| GND | C8 | 2 | C9 | 2 | GROUND |
| GND | C9 | 2 | C10 | 2 | GROUND |
| GND | C10 | 2 | C11 | 2 | GROUND |
| GND | C11 | 2 | C12 | 2 | GROUND |
| GND | C12 | 2 | C13 | 2 | GROUND |
| GND | C13 | 2 | C14 | 2 | GROUND |
| GND | C14 | 2 | C15 | 2 | GROUND |
| GND | C15 | 2 |  | 2 | GROUND |
| GND | C16 | 2 | C17 | 2 | GROUND |
| GND | C17 | 2 | C18 | 2 | GROUND |
| GND | C18 | 2 | C19 | 2 | GROUND |
| GND | C19 | 2 | C20 | 2 | GROUND |
| GND | C20 | 2 | C21 | 2 | GROUND |
| GND | C21 | 2 | C22 | 2 | GROUND |
| GND | C22 | 2 | C23 | 2 | GROUND |
| GND | C23 | 2 | R10 | 2 | GROUND |
| GND | R10 | 2 | R12 | 2 | GROUND |
| GND | R12 | 2 | R14 | 2 | GROUND |
| GND | R14 | 2 | U6 | GND | GROUND |
| GND | U6 | GND | U7 | GND | GROUND |
| GND | U7 | GND | U8 | GND | GROUND |
| +5V | U6 | VOUT | C1 | 1 | POWER |
| +5V | C1 | 1 | C6 | 1 | POWER |
| +5V | C6 | 1 | C10 | 1 | POWER |
| +5V | C10 | 1 | C20 | 1 | POWER |
| +3V3_DIG | U7 | VOUT | C2 | 1 | POWER |
| +3V3_DIG | C2 | 1 | C7 | 1 | POWER |
| +3V3_DIG | C7 | 1 | C11 | 1 | POWER |
| +3V3_DIG | C11 | 1 | C21 | 1 | POWER |
| +1V8_ADC | U8 | VOUT1 | C3 | 1 | POWER |
| +1V8_ADC | C3 | 1 | C8 | 1 | POWER |
| +1V8_ADC | C8 | 1 | C12 | 1 | POWER |
| +1V8_ADC | C12 | 1 | C22 | 1 | POWER |
| +1V0_CORE | U8 | VOUT2 | C4 | 1 | POWER |
| +1V0_CORE | C4 | 1 | C9 | 1 | POWER |
| +1V0_CORE | C9 | 1 | C13 | 1 | POWER |
| +1V0_CORE | C13 | 1 | C23 | 1 | POWER |
| +5V | J3 | 1 | L1 | 1 | POWER |
| +5V_FILTERED | L1 | 2 | C5 | 1 | POWER |
| +5V_FILTERED | C5 | 1 | U6 | VIN | POWER |
| +5V_LNA | U1 | VDD | C14 | 1 | POWER |
| +5V_LNA | C14 | 1 | C15 | 1 | POWER |
| +3V3_DIG | U2 | VDD | C16 | 1 | POWER |
| +3V3_DIG | C16 | 1 | C17 | 1 | POWER |
| +3V3_DIG | U3 | VDD | C18 | 1 | POWER |
| +3V3_DIG | C18 | 1 | C19 | 1 | POWER |
| LNA_ENABLE | J4 | GPIO8 | R1 | 1 | DIGITAL |
| LNA_ENABLE_BIAS | R1 | 2 | U1 | EN | DIGITAL |
| ADC_RESET | J4 | GPIO9 | R2 | 1 | DIGITAL |
| ADC_RESET_FILTERED | R2 | 2 | C14 | 1 | DIGITAL |
| ADC_RESET_FILTERED | C14 | 1 | U4 | RESET | DIGITAL |
| ADC_PD | J4 | GPIO10 | R3 | 1 | DIGITAL |
| ADC_PD_BIAS | R3 | 2 | U4 | PD | DIGITAL |
| LDO_EN_5V | J4 | GPIO11 | R4 | 1 | DIGITAL |
| LDO_EN_5V_BIAS | R4 | 2 | U6 | EN | DIGITAL |
| LDO_EN_3V3 | J4 | GPIO12 | R5 | 1 | DIGITAL |
| LDO_EN_3V3_BIAS | R5 | 2 | U7 | EN | DIGITAL |
| LDO_EN_1V8 | J4 | GPIO13 | R6 | 1 | DIGITAL |
| LDO_EN_1V8_BIAS | R6 | 2 | U8 | EN1 | DIGITAL |
| LDO_EN_1V0 | J4 | GPIO14 | R7 | 1 | DIGITAL |
| LDO_EN_1V0_BIAS | R7 | 2 | U8 | EN2 | DIGITAL |
| CLK_REF_P | J2 | 1 | R8 | 1 | CLOCK |
| CLK_REF_FILTERED | R8 | 2 | U5 | CLK_IN0_P | CLOCK |
| CLK_REF_N | J2 | 2 | R9 | 1 | CLOCK |
| CLK_REF_N_FILTERED | R9 | 2 | U5 | CLK_IN0_N | CLOCK |
| VREF_ADC_P | U4 | VREF_P | R11 | 1 | ANALOG |
| VREF_ADC_P_FILTERED | R11 | 2 | C13 | 1 | ANALOG |
| VREF_ADC_N | U4 | VREF_N | R12 | 1 | ANALOG |
| VREF_ADC_N_FILTERED | R12 | 2 | C13 | 2 | ANALOG |
| VREF_CLK | U5 | VREF | R13 | 1 | ANALOG |
| VREF_CLK_FILTERED | R13 | 2 | C14 | 1 | ANALOG |
| LDO_FB_5V | U6 | FB | R14 | 2 | ANALOG |
| LDO_FB_3V3 | U7 | FB | R10 | 2 | ANALOG |

## Net Connection List

| Net Name | Reference Designator - Pin No. |
|----------|-------------------------------|
| +1V0_CORE | U8 - VOUT2,  U4 - CVDD,  C4 - 1,  C9 - 1,  C13 - 1,  C23 - 1 |
| +1V8_ADC | U8 - VOUT1,  U4 - AVDD,  C3 - 1,  C8 - 1,  C12 - 1,  C22 - 1 |
| +3V3_DIG | U7 - VOUT,  U4 - DVDD,  U5 - DVDD,  U2 - VDD,  U3 - VDD,  C2 - 1,  C7 - 1,  C11 - 1,  C21 - 1,  C16 - 1,  C17 - 1,  C18 - 1,  C19 - 1 |
| +5V | J3 - 1,  U6 - VIN,  U8 - VIN,  U6 - VOUT,  C1 - 1,  C6 - 1,  C10 - 1,  C20 - 1,  L1 - 1 |
| +5V_FILTERED | L1 - 2,  C5 - 1,  U6 - VIN |
| +5V_LNA | U6 - VOUT,  U1 - VDD,  C14 - 1,  C15 - 1 |
| ADC_PD | J4 - GPIO10,  R3 - 1 |
| ADC_PD_BIAS | R3 - 2,  U4 - PD |
| ADC_RESET | J4 - GPIO9,  R2 - 1 |
| ADC_RESET_FILTERED | R2 - 2,  C14 - 1,  U4 - RESET |
| ATT1_D0 | J4 - GPIO2,  U2 - D0 |
| ATT1_D1 | J4 - GPIO3,  U2 - D1 |
| ATT1_D2 | J4 - GPIO4,  U2 - D2 |
| ATT1_D3 | J4 - GPIO5,  U2 - D3 |
| ATT1_D4 | J4 - GPIO6,  U2 - D4 |
| ATT1_D5 | J4 - GPIO7,  U2 - D5 |
| ATT1_LE | J4 - GPIO0,  U2 - LE |
| ATT2_D0 | J4 - GPIO2,  U3 - D0 |
| ATT2_D1 | J4 - GPIO3,  U3 - D1 |
| ATT2_D2 | J4 - GPIO4,  U3 - D2 |
| ATT2_D3 | J4 - GPIO5,  U3 - D3 |
| ATT2_D4 | J4 - GPIO6,  U3 - D4 |
| ATT2_D5 | J4 - GPIO7,  U3 - D5 |
| ATT2_LE | J4 - GPIO1,  U3 - LE |
| CLK_ADC | U5 - CLK_OUT0,  U4 - CLK_IN |
| CLK_REF_FILTERED | R8 - 2,  U5 - CLK_IN0_P |
| CLK_REF_IN | J2 - 1,  U5 - CLK_IN0 |
| CLK_REF_N | J2 - 2,  R9 - 1 |
| CLK_REF_N_FILTERED | R9 - 2,  U5 - CLK_IN0_N |
| CLK_REF_P | J2 - 1,  R8 - 1 |
| CLK_SYSREF | U5 - CLK_OUT1,  U4 - SYSREF |
| GND | U1 - GND,  U2 - GND,  U3 - GND,  U4 - ,  U4 - GND,  U5 - GND,  J1 - 2,  J2 - 2,  J3 - 2,  J4 - GND,  C1 - 2,  C2 - 2,  C3 - 2,  C4 - 2,  C5 - 2,  C6 - 2,  C7 - 2,  C8 - 2,  C9 - 2,  C10 - 2,  C11 - 2,  C12 - 2,  C13 - 2,  C14 - 2,  C15 - 2,   - 2,  C16 - 2,  C17 - 2,  C18 - 2,  C19 - 2,  C20 - 2,  C21 - 2,  C22 - 2,  C23 - 2,  R10 - 2,  R12 - 2,  R14 - 2,  U6 - GND,  U7 - GND,  U8 - GND |
| JESD_D0_N | U4 - D0_N,  J4 - DP0_N |
| JESD_D0_P | U4 - D0_P,  J4 - DP0_P |
| JESD_D1_N | U4 - D1_N,  J4 - DP1_N |
| JESD_D1_P | U4 - D1_P,  J4 - DP1_P |
| JESD_D2_N | U4 - D2_N,  J4 - DP2_N |
| JESD_D2_P | U4 - D2_P,  J4 - DP2_P |
| JESD_D3_N | U4 - D3_N,  J4 - DP3_N |
| JESD_D3_P | U4 - D3_P,  J4 - DP3_P |
| JESD_D4_N | U4 - D4_N,  J4 - DP4_N |
| JESD_D4_P | U4 - D4_P,  J4 - DP4_P |
| JESD_D5_N | U4 - D5_N,  J4 - DP5_N |
| JESD_D5_P | U4 - D5_P,  J4 - DP5_P |
| JESD_D6_N | U4 - D6_N,  J4 - DP6_N |
| JESD_D6_P | U4 - D6_P,  J4 - DP6_P |
| JESD_D7_N | U4 - D7_N,  J4 - DP7_N |
| JESD_D7_P | U4 - D7_P,  J4 - DP7_P |
| JESD_SYNC_N | U4 - SYNC_N,  J4 - SYNC_N |
| JESD_SYNC_P | U4 - SYNC_P,  J4 - SYNC_P |
| LDO_EN_1V0 | J4 - GPIO14,  R7 - 1 |
| LDO_EN_1V0_BIAS | R7 - 2,  U8 - EN2 |
| LDO_EN_1V8 | J4 - GPIO13,  R6 - 1 |
| LDO_EN_1V8_BIAS | R6 - 2,  U8 - EN1 |
| LDO_EN_3V3 | J4 - GPIO12,  R5 - 1 |
| LDO_EN_3V3_BIAS | R5 - 2,  U7 - EN |
| LDO_EN_5V | J4 - GPIO11,  R4 - 1 |
| LDO_EN_5V_BIAS | R4 - 2,  U6 - EN |
| LDO_FB_3V3 | U7 - FB,  R10 - 2 |
| LDO_FB_5V | U6 - FB,  R14 - 2 |
| LNA_ENABLE | J4 - GPIO8,  R1 - 1 |
| LNA_ENABLE_BIAS | R1 - 2,  U1 - EN |
| RF_ADC_IN_N | T1 - 4,  U4 - AIN_N |
| RF_ADC_IN_P | T1 - 3,  U4 - AIN_P |
| RF_ATT1_OUT | U2 - RF_OUT,  U3 - RF_IN |
| RF_ATT2_OUT | U3 - RF_OUT,  T1 - 1 |
| RF_IN | J1 - 1,  U1 - RF_IN |
| RF_LNA_OUT | U1 - RF_OUT,  U2 - RF_IN |
| SPI_CS_U4 | J4 - CS0,  U4 - CS |
| SPI_CS_U5 | J4 - CS1,  U5 - CS |
| SPI_SCLK | J4 - SCLK,  U4 - SCLK |
| SPI_SCLK_U5 | J4 - SCLK,  U5 - SCLK |
| SPI_SDI_U4 | J4 - MOSI,  U4 - SDI |
| SPI_SDI_U5 | J4 - MOSI,  U5 - SDI |
| SPI_SDO_U4 | U4 - SDO,  J4 - MISO |
| SPI_SDO_U5 | U5 - SDO,  J4 - MISO |
| VREF_ADC_N | U4 - VREF_N,  R12 - 1 |
| VREF_ADC_N_FILTERED | R12 - 2,  C13 - 2 |
| VREF_ADC_P | U4 - VREF_P,  R11 - 1 |
| VREF_ADC_P_FILTERED | R11 - 2,  C13 - 1 |
| VREF_CLK | U5 - VREF,  R13 - 1 |
| VREF_CLK_FILTERED | R13 - 2,  C14 - 1 |

## Validation Notes

- CRITICAL: Temperature Range - HMC1132LP6GE rated -40 to +85°C, extended screening required for -55 to +125°C operation
- CRITICAL: Temperature Range - ADC10DX100 rated -40 to +85°C, extended screening required for -55 to +125°C operation
- WARNING: HMC698LP4 frequency range DC-12GHz, cascade of two devices may not achieve full 18GHz coverage with optimal performance
- WARNING: ADC input bandwidth 3.5GHz limits direct RF sampling - must operate in IF mode with downconversion or undersampling
- REVIEW: JESD204B lane rate verification needed - 8 lanes at 10GSPS requires ~12.5Gbps/lane (JESD204B subclass 1)
- REVIEW: Power budget validation - estimated 18W total (LNA: 0.6W, DSAs: 0.4W, ADC: 3.2W, Clock: 1W, LDOs: 2W, margin: 10.8W)
- REVIEW: Gain control range - two 31.5dB DSAs provide 63dB total, exceeds 30dB requirement with margin
- REVIEW: System noise figure calculation needed - LNA 3.5dB + DSAs 8dB total insertion loss = ~11.5dB, may exceed 6-10dB spec
- ACTION: Add input matching network for 10dB return loss across 5-18GHz
- ACTION: Verify LVDS termination resistors (100 ohm differential) on JESD204 lanes
- ACTION: Confirm decoupling capacitor placement - requires <2mm from device pins for effective RF decoupling
- ACTION: Add ESD protection on RF input for MIL-STD-883 compliance
- ACTION: Design controlled impedance transmission lines - 50 ohm single-ended, 100 ohm differential LVDS
- ACTION: Add clock source phase noise analysis - verify <100fs RMS jitter from 12kHz to 20MHz
- ACTION: Implement power sequencing - ensure 1.0V core before 1.8V analog before 3.3V digital
- ACTION: Add thermal vias under high-power devices (ADC, LDOs) for heat dissipation
- ACTION: Verify SPI address conflicts - ADC and Clock IC may have same default address
- ACTION: Add ferrite beads on power inputs to EMI-sensitive RF sections