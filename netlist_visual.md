# Logical Netlist
## ajsfdvhjs

## Block Diagram

```mermaid
graph TB
    U1[TGA4943-SL (TGA4943-SL)]
    U2[HMC1048LP4BE (HMC1048LP4BE)]
    U3[HMC1119LP4ME (HMC1119LP4ME)]
    U4[ADF5356 (ADF5356CCPZ)]
    U5[AD9208 (AD9208-3000EBZ)]
    U6[ADP5071 (ADP5071ACPZ)]
    U7[ADP5071 (ADP5071ACPZ)]
    U8[ADP174 (ADP174ACPZ)]
    U9[ADP174 (ADP174ACPZ)]
    U10[LT3045 (LT3045EDD)]
    U11[LT3045 (LT3045EDD)]
    U12[LT3094 (LT3094IDE)]
    U13[LT3094 (LT3094IDE)]
    J1[SMA_CONNECTOR (CON-SMA-EDGE-S)]
    J2[SMA_CONNECTOR (CON-SMA-EDGE-S)]
    J3[SMA_CONNECTOR (CON-SMA-EDGE-S)]
    T1[MAGIC_TEE (MACOM-MT4T-18G)]
    T2[POWER_COMBINER (PCN-2-18G+)]
    A1[PE4259 (PE4259)]
    U20[STM32F407 (STM32F407VGT6)]
    J4[HEADER_10X2 (PH2RA-20-UA)]
    R1[RESISTOR (ERJ-2RKF1001X)]
    R2[RESISTOR (ERJ-2RKF1001X)]
    R3[RESISTOR (ERJ-2RKF1002X)]
    R4[RESISTOR (ERJ-2RKF1002X)]
    R5[RESISTOR (ERJ-2RKF1000X)]
    R6[RESISTOR (ERJ-2RKF4701X)]
    R7[RESISTOR (ERJ-2RKF4701X)]
    R8[RESISTOR (ERJ-2RKF1003X)]
    R9[RESISTOR (ERJ-2RKF1003X)]
    R10[RESISTOR (ERJ-2RKF1001X)]
    R11[RESISTOR (ERJ-2RKF1002X)]
    R12[RESISTOR (ERJ-2RKF1003X)]
    R13[RESISTOR (ERJ-2RKF1003X)]
    R14[RESISTOR (ERJ-2RWF4990X)]
    R15[RESISTOR (ERJ-2RWF4990X)]
    C1[CAPACITOR (GRM1555C1H102JA01J)]
    C2[CAPACITOR (GRM1555C1H102JA01J)]
    C3[CAPACITOR (GRM1555C1H103JA01J)]
    C4[CAPACITOR (GRM1555C1H103JA01J)]
    C5[CAPACITOR (GRM1555C1H104JA01J)]
    C6[CAPACITOR (GRM1555C1H104JA01J)]
    C7[CAPACITOR (GRM32ER61C476KE15L)]
    C8[CAPACITOR (GRM32ER61C476KE15L)]
    C9[CAPACITOR (GRM32ER61C476KE15L)]
    C10[CAPACITOR (GRM32ER61C476KE15L)]
    C11[CAPACITOR (GRM32ER61C106KE15L)]
    C12[CAPACITOR (GRM32ER61C106KE15L)]
    C13[CAPACITOR (GRM21BC71A106KE15L)]
    C14[CAPACITOR (GRM21BC71A106KE15L)]
    C15[CAPACITOR (GRM21BC71A106KE15L)]
    C16[CAPACITOR (GRM21BC71A106KE15L)]
    C17[CAPACITOR (GRM32EC70J226ME05L)]
    C18[CAPACITOR (GRM32EC70J226ME05L)]
    C19[CAPACITOR (GRM32EC70J226ME05L)]
    C20[CAPACITOR (GRM32EC70J226ME05L)]
    C21[CAPACITOR (GRM1555C1H102JA01J)]
    C22[CAPACITOR (GRM1555C1H102JA01J)]
    C23[CAPACITOR (GRM1555C1H103JA01J)]
    C24[CAPACITOR (GRM1555C1H103JA01J)]
    C25[CAPACITOR (GRM1555C1H104JA01J)]
    C26[CAPACITOR (GRM1555C1H104JA01J)]
    C27[CAPACITOR (GRM32ER61C476KE15L)]
    C28[CAPACITOR (GRM32ER61C476KE15L)]
    C29[CAPACITOR (GRM32ER61C476KE15L)]
    C30[CAPACITOR (GRM32ER61C476KE15L)]
    C31[CAPACITOR (GRM32ER61C106KE15L)]
    C32[CAPACITOR (GRM32ER61C106KE15L)]
    C33[CAPACITOR (GRM21BC71A106KE15L)]
    C34[CAPACITOR (GRM21BC71A106KE15L)]
    C35[CAPACITOR (GRM21BC71A106KE15L)]
    C36[CAPACITOR (GRM21BC71A106KE15L)]
    C37[CAPACITOR (GRM32EC70J226ME05L)]
    C38[CAPACITOR (GRM32EC70J226ME05L)]
    C39[CAPACITOR (GRM32EC70J226ME05L)]
    C40[CAPACITOR (GRM32EC70J226ME05L)]
    L1[INDUCTOR (LQG31PN4N7M00L)]
    L2[INDUCTOR (LQG31PN4N7M00L)]
    L3[INDUCTOR (LQH32PN4N7M00L)]
    L4[INDUCTOR (LQH32PN4N7M00L)]
    L5[INDUCTOR (LQH32PN100NME0L)]
    L6[INDUCTOR (LQH32PN100NME0L)]
    F1[FUSE_PTC (0ZCG0050FF2G)]
    D1[TVS_DIODE (SMBJ33A)]
    LED1[LED (LTST-C191KGKT)]
    LED2[LED (LTST-C191KGKT)]
    J1 -->|RF_IN_FROM_SMA| A1
    A1 -->|RF_TO_LNA| U1
    U1 -->|LNA_OUT_TO_MIXER_RF| U2
    U4 -->|LO_MAIN| T1
    T1 -->|LO_MIXER1_PATH| U2
    T1 -->|LO_MIXER2_PATH| U3
    U2 -->|IF1_TO_MIXER2| U3
    U3 -->|I_OUT_P| U5
    U3 -->|I_OUT_N| U5
    U3 -->|Q_OUT_P| U5
    U3 -->|Q_OUT_N| U5
    U5 -->|ADC_REF_P| R14
    U5 -->|ADC_REF_N| R14
    R14 -->|ADC_REF_MID| R15
    U20 -->|SPI_SCLK| U4
    U20 -->|SPI_SCLK_ADC| U5
    U20 -->|SPI_SDIO| U4
    U20 -->|SPI_SDIO_ADC| U5
    U20 -->|SPI_CS_PLL| U4
    U20 -->|SPI_CS_ADC| U5
    U4 -->|PLL_MUXOUT| U20
    U5 -->|ADC_SDO| U20
    U20 -->|SYSREF_REQ| U5
    U5 -->|JESD_CKP| J2
    U5 -->|JESD_CKN| J2
    U5 -->|JESD_D0P| J2
    U5 -->|JESD_D0N| J2
    U5 -->|JESD_D1P| J2
    U5 -->|JESD_D1N| J2
    U20 -->|SYNC_IN| U5
    J4 -->|12V_SUPPLY| F1
    F1 -->|12V_FUSED| D1
    D1 -->|12V_PROTECTED| U6
    D1 -->|12V_TO_LNA| U1
    D1 -->|12V_TO_MIXER| U2
    U6 -->|+5V_MAIN| C7
    C7 -->|+5V_MAIN| C8
    C8 -->|+5V_MAIN| U8
    U8 -->|+5V_MAIN| U9
    U9 -->|+5V_MAIN| U4
    U6 -->|-5V_MAIN| C9
    C9 -->|-5V_MAIN| C10
    U8 -->|+3V3_ADC| C11
    C11 -->|+3V3_ADC| C12
    C12 -->|+3V3_ADC| U10
    U9 -->|+3V3_MCUX| C13
    C13 -->|+3V3_MCUX| C14
    C14 -->|+3V3_MCUX| U20
    U20 -->|+3V3_MCUX| LED1
    U10 -->|+1V8_ADC| C15
    C15 -->|+1V8_ADC| C16
    C16 -->|+1V8_ADC| U5
    U7 -->|+1V5_PLL| C27
    C27 -->|+1V5_PLL| C28
    C28 -->|+1V5_PLL| U12
    U12 -->|+1V5_PLL| U4
    U7 -->|+1V2_PLL| C29
    C29 -->|+1V2_PLL| C30
    C30 -->|+1V2_PLL| U11
    U11 -->|+1V0_CORE| C31
    C31 -->|+1V0_CORE| C32
    C32 -->|+1V0_CORE| U5
    U6 -->|+5V_IF_AMP| U3
    J1 -->|GND| J1
    J1 -->|GND| J1
    J1 -->|GND| J1
    J1 -->|GND| J4
    J4 -->|GND| F1
    F1 -->|GND| D1
    D1 -->|GND| U1
    U1 -->|GND| U2
    U2 -->|GND| U3
    U3 -->|GND| U4
    U4 -->|GND| U5
    U5 -->|GND| U6
    U6 -->|GND| U7
    U7 -->|GND| U8
    U8 -->|GND| U9
    U9 -->|GND| U10
    U10 -->|GND| U11
    U11 -->|GND| U12
    U12 -->|GND| U20
    U20 -->|GND| T1
    T1 -->|GND| T2
    T2 -->|GND| A1
    A1 -->|GND| C1
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
    C15 -->|GND| C16
    C16 -->|GND| C17
    C17 -->|GND| C18
    C18 -->|GND| C19
    C19 -->|GND| C20
    C20 -->|GND| C21
    C21 -->|GND| C22
    C22 -->|GND| C23
    C23 -->|GND| C24
    C24 -->|GND| C25
    C25 -->|GND| C26
    C26 -->|GND| C27
    C27 -->|GND| C28
    C28 -->|GND| C29
    C29 -->|GND| C30
    C30 -->|GND| C31
    C31 -->|GND| C32
    C32 -->|GND| C33
    C33 -->|GND| C34
    C34 -->|GND| C35
    C35 -->|GND| C36
    C36 -->|GND| C37
    C37 -->|GND| C38
    C38 -->|GND| C39
    C39 -->|GND| C40
    C40 -->|GND| R6
    R6 -->|GND| R7
    R7 -->|GND| R15
    R15 -->|GND| LED1
    LED1 -->|GND| LED2
    U20 -->|RST_N_PLL| U4
    U20 -->|RST_N_ADC| U5
    U4 -->|PLL_LD| U20
    U1 -->|C5| C5
    U2 -->|C6| C6
    U5 -->|R5| R5
    R5 -->|C25| C25
    C25 -->|C26| C26
```

## Component Instances

| Ref | Part Number | Component |
|---|---|---|
| U1 | TGA4943-SL | TGA4943-SL |
| U2 | HMC1048LP4BE | HMC1048LP4BE |
| U3 | HMC1119LP4ME | HMC1119LP4ME |
| U4 | ADF5356CCPZ | ADF5356 |
| U5 | AD9208-3000EBZ | AD9208 |
| U6 | ADP5071ACPZ | ADP5071 |
| U7 | ADP5071ACPZ | ADP5071 |
| U8 | ADP174ACPZ | ADP174 |
| U9 | ADP174ACPZ | ADP174 |
| U10 | LT3045EDD | LT3045 |
| U11 | LT3045EDD | LT3045 |
| U12 | LT3094IDE | LT3094 |
| U13 | LT3094IDE | LT3094 |
| J1 | CON-SMA-EDGE-S | SMA_CONNECTOR |
| J2 | CON-SMA-EDGE-S | SMA_CONNECTOR |
| J3 | CON-SMA-EDGE-S | SMA_CONNECTOR |
| T1 | MACOM-MT4T-18G | MAGIC_TEE |
| T2 | PCN-2-18G+ | POWER_COMBINER |
| A1 | PE4259 | PE4259 |
| U20 | STM32F407VGT6 | STM32F407 |
| J4 | PH2RA-20-UA | HEADER_10X2 |
| R1 | ERJ-2RKF1001X | RESISTOR |
| R2 | ERJ-2RKF1001X | RESISTOR |
| R3 | ERJ-2RKF1002X | RESISTOR |
| R4 | ERJ-2RKF1002X | RESISTOR |
| R5 | ERJ-2RKF1000X | RESISTOR |
| R6 | ERJ-2RKF4701X | RESISTOR |
| R7 | ERJ-2RKF4701X | RESISTOR |
| R8 | ERJ-2RKF1003X | RESISTOR |
| R9 | ERJ-2RKF1003X | RESISTOR |
| R10 | ERJ-2RKF1001X | RESISTOR |
| R11 | ERJ-2RKF1002X | RESISTOR |
| R12 | ERJ-2RKF1003X | RESISTOR |
| R13 | ERJ-2RKF1003X | RESISTOR |
| R14 | ERJ-2RWF4990X | RESISTOR |
| R15 | ERJ-2RWF4990X | RESISTOR |
| C1 | GRM1555C1H102JA01J | CAPACITOR |
| C2 | GRM1555C1H102JA01J | CAPACITOR |
| C3 | GRM1555C1H103JA01J | CAPACITOR |
| C4 | GRM1555C1H103JA01J | CAPACITOR |
| C5 | GRM1555C1H104JA01J | CAPACITOR |
| C6 | GRM1555C1H104JA01J | CAPACITOR |
| C7 | GRM32ER61C476KE15L | CAPACITOR |
| C8 | GRM32ER61C476KE15L | CAPACITOR |
| C9 | GRM32ER61C476KE15L | CAPACITOR |
| C10 | GRM32ER61C476KE15L | CAPACITOR |
| C11 | GRM32ER61C106KE15L | CAPACITOR |
| C12 | GRM32ER61C106KE15L | CAPACITOR |
| C13 | GRM21BC71A106KE15L | CAPACITOR |
| C14 | GRM21BC71A106KE15L | CAPACITOR |
| C15 | GRM21BC71A106KE15L | CAPACITOR |
| C16 | GRM21BC71A106KE15L | CAPACITOR |
| C17 | GRM32EC70J226ME05L | CAPACITOR |
| C18 | GRM32EC70J226ME05L | CAPACITOR |
| C19 | GRM32EC70J226ME05L | CAPACITOR |
| C20 | GRM32EC70J226ME05L | CAPACITOR |
| C21 | GRM1555C1H102JA01J | CAPACITOR |
| C22 | GRM1555C1H102JA01J | CAPACITOR |
| C23 | GRM1555C1H103JA01J | CAPACITOR |
| C24 | GRM1555C1H103JA01J | CAPACITOR |
| C25 | GRM1555C1H104JA01J | CAPACITOR |
| C26 | GRM1555C1H104JA01J | CAPACITOR |
| C27 | GRM32ER61C476KE15L | CAPACITOR |
| C28 | GRM32ER61C476KE15L | CAPACITOR |
| C29 | GRM32ER61C476KE15L | CAPACITOR |
| C30 | GRM32ER61C476KE15L | CAPACITOR |
| C31 | GRM32ER61C106KE15L | CAPACITOR |
| C32 | GRM32ER61C106KE15L | CAPACITOR |
| C33 | GRM21BC71A106KE15L | CAPACITOR |
| C34 | GRM21BC71A106KE15L | CAPACITOR |
| C35 | GRM21BC71A106KE15L | CAPACITOR |
| C36 | GRM21BC71A106KE15L | CAPACITOR |
| C37 | GRM32EC70J226ME05L | CAPACITOR |
| C38 | GRM32EC70J226ME05L | CAPACITOR |
| C39 | GRM32EC70J226ME05L | CAPACITOR |
| C40 | GRM32EC70J226ME05L | CAPACITOR |
| L1 | LQG31PN4N7M00L | INDUCTOR |
| L2 | LQG31PN4N7M00L | INDUCTOR |
| L3 | LQH32PN4N7M00L | INDUCTOR |
| L4 | LQH32PN4N7M00L | INDUCTOR |
| L5 | LQH32PN100NME0L | INDUCTOR |
| L6 | LQH32PN100NME0L | INDUCTOR |
| F1 | 0ZCG0050FF2G | FUSE_PTC |
| D1 | SMBJ33A | TVS_DIODE |
| LED1 | LTST-C191KGKT | LED |
| LED2 | LTST-C191KGKT | LED |

## Pin-to-Pin Connections

| Net | From | Pin | To | Pin | Type |
|---|---|---|---|---|---|
| RF_IN_FROM_SMA | J1 | SIG | A1 | RF1 | RF |
| RF_TO_LNA | A1 | RF2 | U1 | RF_IN | RF |
| LNA_OUT_TO_MIXER_RF | U1 | RF_OUT | U2 | RF | RF |
| LO_MAIN | U4 | RFOUT_A | T1 | IN | RF_LO |
| LO_MIXER1_PATH | T1 | OUT1 | U2 | LO | RF_LO |
| LO_MIXER2_PATH | T1 | OUT2 | U3 | LO_IN | RF_LO |
| IF1_TO_MIXER2 | U2 | IF | U3 | RF_IN | IF |
| I_OUT_P | U3 | I_P | U5 | VA_IN_P | ANALOG |
| I_OUT_N | U3 | I_N | U5 | VA_IN_N | ANALOG |
| Q_OUT_P | U3 | Q_P | U5 | VB_IN_P | ANALOG |
| Q_OUT_N | U3 | Q_N | U5 | VB_IN_N | ANALOG |
| ADC_REF_P | U5 | REFIO_P | R14 | 1 | REFERENCE |
| ADC_REF_N | U5 | REFIO_N | R14 | 2 | REFERENCE |
| ADC_REF_MID | R14 | 2 | R15 | 1 | REFERENCE |
| SPI_SCLK | U20 | PA5 | U4 | SCLK | DIGITAL |
| SPI_SCLK_ADC | U20 | PA5 | U5 | SCLK | DIGITAL |
| SPI_SDIO | U20 | PA7 | U4 | SDIO | DIGITAL |
| SPI_SDIO_ADC | U20 | PA7 | U5 | SDIO | DIGITAL |
| SPI_CS_PLL | U20 | PA4 | U4 | CS | DIGITAL |
| SPI_CS_ADC | U20 | PA3 | U5 | CS | DIGITAL |
| PLL_MUXOUT | U4 | MUXOUT | U20 | PA0 | DIGITAL |
| ADC_SDO | U5 | SDO | U20 | PA6 | DIGITAL |
| SYSREF_REQ | U20 | PB0 | U5 | SYSREF_REQ | DIGITAL |
| JESD_CKP | U5 | CXP0_P | J2 | SIG | HSD |
| JESD_CKN | U5 | CXP0_N | J2 | GND | HSD |
| JESD_D0P | U5 | DXP00_P | J2 | SIG | HSD |
| JESD_D0N | U5 | DXN00_N | J2 | GND | HSD |
| JESD_D1P | U5 | DXP01_P | J2 | SIG | HSD |
| JESD_D1N | U5 | DXN01_N | J2 | GND | HSD |
| SYNC_IN | U20 | PB1 | U5 | SYNC_IN | DIGITAL |
| 12V_SUPPLY | J4 | 1 | F1 | 1 | POWER |
| 12V_FUSED | F1 | 2 | D1 | 1 | POWER |
| 12V_PROTECTED | D1 | 2 | U6 | VIN | POWER |
| 12V_TO_LNA | D1 | 2 | U1 | VDD | POWER |
| 12V_TO_MIXER | D1 | 2 | U2 | VDD | POWER |
| +5V_MAIN | U6 | SW1 | C7 | 1 | POWER |
| +5V_MAIN | C7 | 1 | C8 | 1 | POWER |
| +5V_MAIN | C8 | 1 | U8 | VIN | POWER |
| +5V_MAIN | U8 | VIN | U9 | VIN | POWER |
| +5V_MAIN | U9 | VIN | U4 | VDD | POWER |
| -5V_MAIN | U6 | SW2 | C9 | 1 | POWER |
| -5V_MAIN | C9 | 1 | C10 | 1 | POWER |
| +3V3_ADC | U8 | VOUT | C11 | 1 | POWER |
| +3V3_ADC | C11 | 1 | C12 | 1 | POWER |
| +3V3_ADC | C12 | 1 | U10 | IN | POWER |
| +3V3_MCUX | U9 | VOUT | C13 | 1 | POWER |
| +3V3_MCUX | C13 | 1 | C14 | 1 | POWER |
| +3V3_MCUX | C14 | 1 | U20 | VDD | POWER |
| +3V3_MCUX | U20 | VDD | LED1 | ANODE | POWER |
| +1V8_ADC | U10 | OUT | C15 | 1 | POWER |
| +1V8_ADC | C15 | 1 | C16 | 1 | POWER |
| +1V8_ADC | C16 | 1 | U5 | VDD18 | POWER |
| +1V5_PLL | U7 | SW1 | C27 | 1 | POWER |
| +1V5_PLL | C27 | 1 | C28 | 1 | POWER |
| +1V5_PLL | C28 | 1 | U12 | IN | POWER |
| +1V5_PLL | U12 | OUT | U4 | VDDVCO | POWER |
| +1V2_PLL | U7 | SW2 | C29 | 1 | POWER |
| +1V2_PLL | C29 | 1 | C30 | 1 | POWER |
| +1V2_PLL | C30 | 1 | U11 | IN | POWER |
| +1V0_CORE | U11 | OUT | C31 | 1 | POWER |
| +1V0_CORE | C31 | 1 | C32 | 1 | POWER |
| +1V0_CORE | C32 | 1 | U5 | VDD10 | POWER |
| +5V_IF_AMP | U6 | SW1 | U3 | VCC | POWER |
| GND | J1 | SHIELD1 | J1 | SHIELD2 | GROUND |
| GND | J1 | SHIELD2 | J1 | SHIELD3 | GROUND |
| GND | J1 | SHIELD3 | J1 | SHIELD4 | GROUND |
| GND | J1 | SHIELD4 | J4 | 2 | GROUND |
| GND | J4 | 2 | F1 | 3 | GROUND |
| GND | F1 | 3 | D1 | 3 | GROUND |
| GND | D1 | 3 | U1 | GND | GROUND |
| GND | U1 | GND | U2 | GND | GROUND |
| GND | U2 | GND | U3 | GND | GROUND |
| GND | U3 | GND | U4 | GND | GROUND |
| GND | U4 | GND | U5 | GND | GROUND |
| GND | U5 | GND | U6 | GND | GROUND |
| GND | U6 | GND | U7 | GND | GROUND |
| GND | U7 | GND | U8 | GND | GROUND |
| GND | U8 | GND | U9 | GND | GROUND |
| GND | U9 | GND | U10 | GND | GROUND |
| GND | U10 | GND | U11 | GND | GROUND |
| GND | U11 | GND | U12 | GND | GROUND |
| GND | U12 | GND | U20 | VSS | GROUND |
| GND | U20 | VSS | T1 | GND | GROUND |
| GND | T1 | GND | T2 | GND | GROUND |
| GND | T2 | GND | A1 | GND | GROUND |
| GND | A1 | GND | C1 | 2 | GROUND |
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
| GND | C15 | 2 | C16 | 2 | GROUND |
| GND | C16 | 2 | C17 | 2 | GROUND |
| GND | C17 | 2 | C18 | 2 | GROUND |
| GND | C18 | 2 | C19 | 2 | GROUND |
| GND | C19 | 2 | C20 | 2 | GROUND |
| GND | C20 | 2 | C21 | 2 | GROUND |
| GND | C21 | 2 | C22 | 2 | GROUND |
| GND | C22 | 2 | C23 | 2 | GROUND |
| GND | C23 | 2 | C24 | 2 | GROUND |
| GND | C24 | 2 | C25 | 2 | GROUND |
| GND | C25 | 2 | C26 | 2 | GROUND |
| GND | C26 | 2 | C27 | 2 | GROUND |
| GND | C27 | 2 | C28 | 2 | GROUND |
| GND | C28 | 2 | C29 | 2 | GROUND |
| GND | C29 | 2 | C30 | 2 | GROUND |
| GND | C30 | 2 | C31 | 2 | GROUND |
| GND | C31 | 2 | C32 | 2 | GROUND |
| GND | C32 | 2 | C33 | 2 | GROUND |
| GND | C33 | 2 | C34 | 2 | GROUND |
| GND | C34 | 2 | C35 | 2 | GROUND |
| GND | C35 | 2 | C36 | 2 | GROUND |
| GND | C36 | 2 | C37 | 2 | GROUND |
| GND | C37 | 2 | C38 | 2 | GROUND |
| GND | C38 | 2 | C39 | 2 | GROUND |
| GND | C39 | 2 | C40 | 2 | GROUND |
| GND | C40 | 2 | R6 | 2 | GROUND |
| GND | R6 | 2 | R7 | 2 | GROUND |
| GND | R7 | 2 | R15 | 2 | GROUND |
| GND | R15 | 2 | LED1 | CATHODE | GROUND |
| GND | LED1 | CATHODE | LED2 | CATHODE | GROUND |
| RST_N_PLL | U20 | PC0 | U4 | RESET | DIGITAL |
| RST_N_ADC | U20 | PC1 | U5 | RESET | DIGITAL |
| PLL_LD | U4 | LD | U20 | PA1 | DIGITAL |
| C5 | U1 | VDD | C5 | 1 | POWER |
| C6 | U2 | VDD | C6 | 1 | POWER |
| R5 | U5 | VREF | R5 | 1 | REFERENCE |
| C25 | R5 | 2 | C25 | 1 | REFERENCE |
| C26 | C25 | 2 | C26 | 1 | REFERENCE |

## Net Connection List

| Net Name | Reference Designator - Pin No. |
|----------|-------------------------------|
| +1V0_CORE | U11 - OUT,  C31 - 1,  C32 - 1,  U5 - VDD10 |
| +1V2_PLL | U7 - SW2,  C29 - 1,  C30 - 1,  U11 - IN |
| +1V5_PLL | U7 - SW1,  C27 - 1,  C28 - 1,  U12 - IN,  U12 - OUT,  U4 - VDDVCO |
| +1V8_ADC | U10 - OUT,  C15 - 1,  C16 - 1,  U5 - VDD18 |
| +3V3_ADC | U8 - VOUT,  C11 - 1,  C12 - 1,  U10 - IN |
| +3V3_MCUX | U9 - VOUT,  C13 - 1,  C14 - 1,  U20 - VDD,  LED1 - ANODE |
| +5V_IF_AMP | U6 - SW1,  U3 - VCC |
| +5V_MAIN | U6 - SW1,  C7 - 1,  C8 - 1,  U8 - VIN,  U9 - VIN,  U4 - VDD |
| -5V_MAIN | U6 - SW2,  C9 - 1,  C10 - 1 |
| 12V_FUSED | F1 - 2,  D1 - 1 |
| 12V_PROTECTED | D1 - 2,  U6 - VIN |
| 12V_SUPPLY | J4 - 1,  F1 - 1 |
| 12V_TO_LNA | D1 - 2,  U1 - VDD |
| 12V_TO_MIXER | D1 - 2,  U2 - VDD |
| ADC_REF_MID | R14 - 2,  R15 - 1 |
| ADC_REF_N | U5 - REFIO_N,  R14 - 2 |
| ADC_REF_P | U5 - REFIO_P,  R14 - 1 |
| ADC_SDO | U5 - SDO,  U20 - PA6 |
| C25 | R5 - 2,  C25 - 1 |
| C26 | C25 - 2,  C26 - 1 |
| C5 | U1 - VDD,  C5 - 1 |
| C6 | U2 - VDD,  C6 - 1 |
| GND | J1 - SHIELD1,  J1 - SHIELD2,  J1 - SHIELD3,  J1 - SHIELD4,  J4 - 2,  F1 - 3,  D1 - 3,  U1 - GND,  U2 - GND,  U3 - GND,  U4 - GND,  U5 - GND,  U6 - GND,  U7 - GND,  U8 - GND,  U9 - GND,  U10 - GND,  U11 - GND,  U12 - GND,  U20 - VSS,  T1 - GND,  T2 - GND,  A1 - GND,  C1 - 2,  C2 - 2,  C3 - 2,  C4 - 2,  C5 - 2,  C6 - 2,  C7 - 2,  C8 - 2,  C9 - 2,  C10 - 2,  C11 - 2,  C12 - 2,  C13 - 2,  C14 - 2,  C15 - 2,  C16 - 2,  C17 - 2,  C18 - 2,  C19 - 2,  C20 - 2,  C21 - 2,  C22 - 2,  C23 - 2,  C24 - 2,  C25 - 2,  C26 - 2,  C27 - 2,  C28 - 2,  C29 - 2,  C30 - 2,  C31 - 2,  C32 - 2,  C33 - 2,  C34 - 2,  C35 - 2,  C36 - 2,  C37 - 2,  C38 - 2,  C39 - 2,  C40 - 2,  R6 - 2,  R7 - 2,  R15 - 2,  LED1 - CATHODE,  LED2 - CATHODE |
| IF1_TO_MIXER2 | U2 - IF,  U3 - RF_IN |
| I_OUT_N | U3 - I_N,  U5 - VA_IN_N |
| I_OUT_P | U3 - I_P,  U5 - VA_IN_P |
| JESD_CKN | U5 - CXP0_N,  J2 - GND |
| JESD_CKP | U5 - CXP0_P,  J2 - SIG |
| JESD_D0N | U5 - DXN00_N,  J2 - GND |
| JESD_D0P | U5 - DXP00_P,  J2 - SIG |
| JESD_D1N | U5 - DXN01_N,  J2 - GND |
| JESD_D1P | U5 - DXP01_P,  J2 - SIG |
| LNA_OUT_TO_MIXER_RF | U1 - RF_OUT,  U2 - RF |
| LO_MAIN | U4 - RFOUT_A,  T1 - IN |
| LO_MIXER1_PATH | T1 - OUT1,  U2 - LO |
| LO_MIXER2_PATH | T1 - OUT2,  U3 - LO_IN |
| PLL_LD | U4 - LD,  U20 - PA1 |
| PLL_MUXOUT | U4 - MUXOUT,  U20 - PA0 |
| Q_OUT_N | U3 - Q_N,  U5 - VB_IN_N |
| Q_OUT_P | U3 - Q_P,  U5 - VB_IN_P |
| R5 | U5 - VREF,  R5 - 1 |
| RF_IN_FROM_SMA | J1 - SIG,  A1 - RF1 |
| RF_TO_LNA | A1 - RF2,  U1 - RF_IN |
| RST_N_ADC | U20 - PC1,  U5 - RESET |
| RST_N_PLL | U20 - PC0,  U4 - RESET |
| SPI_CS_ADC | U20 - PA3,  U5 - CS |
| SPI_CS_PLL | U20 - PA4,  U4 - CS |
| SPI_SCLK | U20 - PA5,  U4 - SCLK |
| SPI_SCLK_ADC | U20 - PA5,  U5 - SCLK |
| SPI_SDIO | U20 - PA7,  U4 - SDIO |
| SPI_SDIO_ADC | U20 - PA7,  U5 - SDIO |
| SYNC_IN | U20 - PB1,  U5 - SYNC_IN |
| SYSREF_REQ | U20 - PB0,  U5 - SYSREF_REQ |

## Validation Notes

- CRITICAL: LO frequency range mismatch - ADF5356 (53.125MHz-13.6GHz) cannot directly cover 13.6-18GHz portion of required LO range. Consider LMX2594 (20GHz max) or frequency doubler/multiplier stage for 13.6-18GHz band.
- WARNING: LO drive level - HMC1048LP4BE requires +13 to +17 dBm LO drive, ADF5356 outputs max +5 dBm. Need LO driver amplifier (e.g., HMC365) between synthesizer and mixers.
- WARNING: HMC1119LP4ME specified as integrated receiver (Mixer + IF Amp + IQ Demod) in component list, but used in cascade with HMC1048. This creates dual downconversion architecture. Verify IF band planning to avoid interference.
- REVIEW: ADC clock source not specified - AD9208 requires low-jitter sample clock. Consider ADF5356 auxiliary output or dedicated clock generator (AD9528).
- REVIEW: JESD204B lane mapping - U5 (AD9208) supports multiple lanes. Confirm FPGA backend lane count and subclass (0/1) requirements.
- REVIEW: +5V/-5V generation from +12V single supply using ADP5071. Verify inductor selection for 5V output (L1-L4) and switching frequency compatibility.
- OPTIMIZATION: Gain staging - LNA (+20dB) + Mixer1 loss (-7.5dB) + Mixer2 gain (+8dB) = +20.5dB total. Verify this meets ADC input requirements (-1dBFS to -2dBFS typically). May need VGA or digital gain control.
- REVIEW: ADC VREF divider (R14/R15) sets 1.18V reference. Verify AD9208 datasheet compatibility - standard VREF is typically 1.1V or 1.25V depending on configuration.
- REVIEW: RF switch (A1 PE4259) control net not shown. Add GPIO from MCU for RX enable/disable functionality.
- REVIEW: Decoupling capacitor placement - C1-C40 distributed throughout design. Verify placement rules: 0.1uF close to IC pins, 10uF bulk capacitors on power entry.
- OPTIMIZATION: Temperature sensors not included - Consider adding I2C temp sensor (ADT7410) for -40 to +85C monitoring and calibration.
- REVIEW: ESD protection on RF input - PE4259 has some ESD tolerance, but verify for harsh environments. May need additional TVS or ESD diode.
- REVIEW: LO reference input (J3) - Clarify reference frequency (10MHz, 100MHz) and interface level (LVCMOS, LVPECL, sine).
- OPTIMIZATION: Power sequencing - ADF5356 and AD9208 may have specific power-up requirements. Verify STM32 firmware implements correct sequence.
- REVIEW: Current budget estimated ~5.5A total on +12V rail. Verify connector and supply capability.
- REVIEW: LED current limiting - R6/R7 values (4.7k) result in <1mA current. Verify visibility requirement, may need adjustment to 1-2k for 5-10mA.
- OPTIMIZATION: Signal chain characterization - Recommended test points after LNA (U1_OUT) and after Mixer2 (U3_I/Q_OUT) for factory alignment and troubleshooting.
- REVIEW: PLL loop filter - Component values not shown. Use ADIsimPLL to design loop filter for ADF5356 based on required phase noise (-100dBc/Hz @ 10kHz).