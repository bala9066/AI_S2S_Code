# Logical Netlist
## sdfjbks

## Block Diagram

```mermaid
graph TB
    U1[HMC6180LP4E (HMC6180LP4E)]
    U2[HMC1051LP4E (HMC1051LP4E)]
    U3[ADF5356 (ADF5356CCPZ)]
    U4[ADC12DJ5200RF (ADC12DJ5200RFAB)]
    U5[HMC698LP4 (HMC698LP4)]
    U6[TPS7A4700 (TPS7A4700RGWT)]
    U7[TPS62913 (TPS62913DRLR)]
    U8[LMK04828 (LMK04828BKNTE)]
    U9[SN74LVC1G07 (SN74LVC1G07DBVR)]
    U10[AT24C64C (AT24C64C-SSHM-T)]
    J1[2.4mm_Female_Connector (149-101A-5)]
    J2[JESD204B_FMC_Header (SAMTEC_FMC-HPC-DE4-1)]
    J3[Header_5x2 (M20-9982045)]
    T1[BALUN_6-18GHZ (BALH-0006SMG)]
    T2[BALUN_IF_3GHZ (TCM1-63AX+)]
    L1[Ferrite_Bead (BLM18PG471SN1D)]
    L2[Ferrite_Bead (BLM18PG471SN1D)]
    L3[Ferrite_Bead (BLM18PG471SN1D)]
    C1[Capacitor_100pF (GJM1555C1H101FB01)]
    C2[Capacitor_0.1uF (CL05B104KO5NNNC)]
    C3[Capacitor_100pF (GJM1555C1H101FB01)]
    C4[Capacitor_0.1uF (CL05B104KO5NNNC)]
    C5[Capacitor_100pF (GJM1555C1H101FB01)]
    C6[Capacitor_0.1uF (CL05B104KO5NNNC)]
    C7[Capacitor_10uF (GRM32ER71A106KE15)]
    C8[Capacitor_0.1uF (CL05B104KO5NNNC)]
    C9[Capacitor_0.01uF (CL05B103KO5NNNC)]
    C10[Capacitor_10uF (GRM32ER71A106KE15)]
    C11[Capacitor_0.1uF (CL05B104KO5NNNC)]
    C12[Capacitor_0.01uF (CL05B103KO5NNNC)]
    C13[Capacitor_0.1uF (CL05B104KO5NNNC)]
    C14[Capacitor_10uF (GRM32ER71A106KE15)]
    C15[Capacitor_0.1uF (CL05B104KO5NNNC)]
    C16[Capacitor_0.01uF (CL05B103KO5NNNC)]
    C17[Capacitor_0.1uF (CL05B104KO5NNNC)]
    C18[Capacitor_100pF (GJM1555C1H101FB01)]
    C19[Capacitor_100pF (GJM1555C1H101FB01)]
    C20[Capacitor_0.01uF (CL05B103KO5NNNC)]
    C21[Capacitor_0.01uF (CL05B103KO5NNNC)]
    C22[Capacitor_0.1uF (CL05B104KO5NNNC)]
    R1[Resistor_1K (RC0805FR-071KL)]
    R2[Resistor_10K (RC0805FR-0710KL)]
    R3[Resistor_4.7K (RC0805FR-074K7L)]
    R4[Resistor_100 (RC0805FR-07100RL)]
    R5[Resistor_10K (RC0805FR-0710KL)]
    R6[Resistor_4.7K (RC0805FR-074K7L)]
    R7[Resistor_10K (RC0805FR-0710KL)]
    J1 -->|RF_IN| C1
    C1 -->|RF_IN_C1| U1
    U1 -->|LNA_OUT| C3
    C3 -->|LNA_OUT_C3| T1
    T1 -->|VGA_IN_P| U5
    T1 -->|VGA_IN_N| U5
    U5 -->|VGA_OUT_P| U2
    U5 -->|VGA_OUT_N| U2
    U2 -->|IF_I_P| T2
    U2 -->|IF_I_N| T2
    U2 -->|IF_Q_P| T2
    U2 -->|IF_Q_N| T2
    T2 -->|ADC_IN_P| U4
    T2 -->|ADC_IN_N| U4
    U3 -->|LO_RF_OUT| U2
    U3 -->|LO_RF_OUT_N| U2
    U8 -->|CLK_ADC_IN| U4
    U8 -->|CLK_REF_IN| J2
    U8 -->|SYSREF| U4
    U8 -->|CLK_REF_PLL| U3
    U4 -->|JESD_TX0_P| J2
    U4 -->|JESD_TX0_N| J2
    U4 -->|JESD_TX1_P| J2
    U4 -->|JESD_TX1_N| J2
    U4 -->|JESD_SYNC_P| J2
    U4 -->|JESD_SYNC_N| J2
    J3 -->|SPI_CLK| U4
    J3 -->|SPI_CLK_PLL| U3
    J3 -->|SPI_MOSI| U4
    J3 -->|SPI_MOSI_PLL| U3
    U4 -->|SPI_MISO| J3
    J3 -->|SPI_CS_ADC| U4
    J3 -->|SPI_CS_PLL| U3
    J3 -->|SPI_CS_VGA| U5
    J3 -->|I2C_SCL| U10
    J3 -->|I2C_SDA| U10
    J3 -->|VCC_5V| L1
    J3 -->|VCC_5V| U6
    L1 -->|VCC_5V_FILTERED| C7
    C7 -->|VCC_5V_FILTERED| U1
    U1 -->|VCC_5V_FILTERED| U2
    U6 -->|VCC_3V3| L2
    U6 -->|VCC_3V3| C8
    L2 -->|VCC_3V3_FILTERED| C9
    C9 -->|VCC_3V3_FILTERED| U3
    U3 -->|VCC_3V3_FILTERED| U5
    U5 -->|VCC_3V3_FILTERED| U8
    U8 -->|VCC_3V3_FILTERED| U9
    U9 -->|VCC_3V3_FILTERED| R2
    U7 -->|VCC_1V8| L3
    U7 -->|VCC_1V8| C11
    L3 -->|VCC_1V8_FILTERED| C12
    C12 -->|VCC_1V8_FILTERED| U4
    U4 -->|VCC_1V8_FILTERED| U8
    U7 -->|VCC_1V2| C13
    C13 -->|VCC_1V2| U4
    L1 -->|VCC_5V_PLL| C10
    C10 -->|VCC_5V_PLL| U3
    U1 -->|GND| J1
    U1 -->|GND| C1
    C1 -->|GND| C2
    C2 -->|GND| C3
    C3 -->|GND| C4
    C4 -->|GND| C5
    C5 -->|GND| C6
    C6 -->|GND| U2
    U2 -->|GND| U3
    U3 -->|GND| U4
    U4 -->|GND| U5
    U5 -->|GND| U6
    U6 -->|GND| U7
    U7 -->|GND| U8
    U8 -->|GND| U9
    U9 -->|GND| U10
    U10 -->|GND| C7
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
    C22 -->|GND| J3
    U9 -->|RESET_N| R4
    R4 -->|RESET_N| U4
    U4 -->|RESET_N| U8
    R2 -->|RESET_PULLUP| U9
    U10 -->|EEPROM_WP| R7
    R7 -->|EEPROM_WP| VCC_3V3_FILTERED
```

## Component Instances

| Ref | Part Number | Component |
|---|---|---|
| U1 | HMC6180LP4E | HMC6180LP4E |
| U2 | HMC1051LP4E | HMC1051LP4E |
| U3 | ADF5356CCPZ | ADF5356 |
| U4 | ADC12DJ5200RFAB | ADC12DJ5200RF |
| U5 | HMC698LP4 | HMC698LP4 |
| U6 | TPS7A4700RGWT | TPS7A4700 |
| U7 | TPS62913DRLR | TPS62913 |
| U8 | LMK04828BKNTE | LMK04828 |
| U9 | SN74LVC1G07DBVR | SN74LVC1G07 |
| U10 | AT24C64C-SSHM-T | AT24C64C |
| J1 | 149-101A-5 | 2.4mm_Female_Connector |
| J2 | SAMTEC_FMC-HPC-DE4-1 | JESD204B_FMC_Header |
| J3 | M20-9982045 | Header_5x2 |
| T1 | BALH-0006SMG | BALUN_6-18GHZ |
| T2 | TCM1-63AX+ | BALUN_IF_3GHZ |
| L1 | BLM18PG471SN1D | Ferrite_Bead |
| L2 | BLM18PG471SN1D | Ferrite_Bead |
| L3 | BLM18PG471SN1D | Ferrite_Bead |
| C1 | GJM1555C1H101FB01 | Capacitor_100pF |
| C2 | CL05B104KO5NNNC | Capacitor_0.1uF |
| C3 | GJM1555C1H101FB01 | Capacitor_100pF |
| C4 | CL05B104KO5NNNC | Capacitor_0.1uF |
| C5 | GJM1555C1H101FB01 | Capacitor_100pF |
| C6 | CL05B104KO5NNNC | Capacitor_0.1uF |
| C7 | GRM32ER71A106KE15 | Capacitor_10uF |
| C8 | CL05B104KO5NNNC | Capacitor_0.1uF |
| C9 | CL05B103KO5NNNC | Capacitor_0.01uF |
| C10 | GRM32ER71A106KE15 | Capacitor_10uF |
| C11 | CL05B104KO5NNNC | Capacitor_0.1uF |
| C12 | CL05B103KO5NNNC | Capacitor_0.01uF |
| C13 | CL05B104KO5NNNC | Capacitor_0.1uF |
| C14 | GRM32ER71A106KE15 | Capacitor_10uF |
| C15 | CL05B104KO5NNNC | Capacitor_0.1uF |
| C16 | CL05B103KO5NNNC | Capacitor_0.01uF |
| C17 | CL05B104KO5NNNC | Capacitor_0.1uF |
| C18 | GJM1555C1H101FB01 | Capacitor_100pF |
| C19 | GJM1555C1H101FB01 | Capacitor_100pF |
| C20 | CL05B103KO5NNNC | Capacitor_0.01uF |
| C21 | CL05B103KO5NNNC | Capacitor_0.01uF |
| C22 | CL05B104KO5NNNC | Capacitor_0.1uF |
| R1 | RC0805FR-071KL | Resistor_1K |
| R2 | RC0805FR-0710KL | Resistor_10K |
| R3 | RC0805FR-074K7L | Resistor_4.7K |
| R4 | RC0805FR-07100RL | Resistor_100 |
| R5 | RC0805FR-0710KL | Resistor_10K |
| R6 | RC0805FR-074K7L | Resistor_4.7K |
| R7 | RC0805FR-0710KL | Resistor_10K |

## Pin-to-Pin Connections

| Net | From | Pin | To | Pin | Type |
|---|---|---|---|---|---|
| RF_IN | J1 | SIG | C1 | 1 | RF |
| RF_IN_C1 | C1 | 2 | U1 | RFIN | RF |
| LNA_OUT | U1 | RFOUT | C3 | 1 | RF |
| LNA_OUT_C3 | C3 | 2 | T1 | UNBAL | RF |
| VGA_IN_P | T1 | BAL_P | U5 | IN_P | RF |
| VGA_IN_N | T1 | BAL_N | U5 | IN_N | RF |
| VGA_OUT_P | U5 | OUT_P | U2 | RF_P | RF |
| VGA_OUT_N | U5 | OUT_N | U2 | RF_N | RF |
| IF_I_P | U2 | IF_I_P | T2 | IN_P1 | IF |
| IF_I_N | U2 | IF_I_N | T2 | IN_N1 | IF |
| IF_Q_P | U2 | IF_Q_P | T2 | IN_P2 | IF |
| IF_Q_N | U2 | IF_Q_N | T2 | IN_N2 | IF |
| ADC_IN_P | T2 | OUT_P | U4 | VIN_P | ANALOG |
| ADC_IN_N | T2 | OUT_N | U4 | VIN_N | ANALOG |
| LO_RF_OUT | U3 | RF_OUT_A | U2 | LO_P | RF |
| LO_RF_OUT_N | U3 | RF_OUT_B | U2 | LO_N | RF |
| CLK_ADC_IN | U8 | OUT0 | U4 | CLK_IN | CLOCK |
| CLK_REF_IN | U8 | CLK_IN | J2 | CLK_REF | CLOCK |
| SYSREF | U8 | SYSREF_OUT | U4 | SYSREF | CLOCK |
| CLK_REF_PLL | U8 | OUT1 | U3 | REF_IN | CLOCK |
| JESD_TX0_P | U4 | JESD_TX0_P | J2 | DP0_P | DIGITAL |
| JESD_TX0_N | U4 | JESD_TX0_N | J2 | DP0_N | DIGITAL |
| JESD_TX1_P | U4 | JESD_TX1_P | J2 | DP1_P | DIGITAL |
| JESD_TX1_N | U4 | JESD_TX1_N | J2 | DP1_N | DIGITAL |
| JESD_SYNC_P | U4 | SYNC_P | J2 | SYNC_P | DIGITAL |
| JESD_SYNC_N | U4 | SYNC_N | J2 | SYNC_N | DIGITAL |
| SPI_CLK | J3 | 3 | U4 | SCLK | DIGITAL |
| SPI_CLK_PLL | J3 | 3 | U3 | CLK | DIGITAL |
| SPI_MOSI | J3 | 5 | U4 | SDIO | DIGITAL |
| SPI_MOSI_PLL | J3 | 5 | U3 | DATA | DIGITAL |
| SPI_MISO | U4 | SDO | J3 | 7 | DIGITAL |
| SPI_CS_ADC | J3 | 9 | U4 | CS_N | DIGITAL |
| SPI_CS_PLL | J3 | 1 | U3 | LE | DIGITAL |
| SPI_CS_VGA | J3 | 2 | U5 | CS_N | DIGITAL |
| I2C_SCL | J3 | 4 | U10 | SCL | DIGITAL |
| I2C_SDA | J3 | 6 | U10 | SDA | DIGITAL |
| VCC_5V | J3 | 10 | L1 | 1 | POWER |
| VCC_5V | J3 | 10 | U6 | IN | POWER |
| VCC_5V_FILTERED | L1 | 2 | C7 | 1 | POWER |
| VCC_5V_FILTERED | C7 | 1 | U1 | VCC | POWER |
| VCC_5V_FILTERED | U1 | VCC | U2 | VCC | POWER |
| VCC_3V3 | U6 | OUT | L2 | 1 | POWER |
| VCC_3V3 | U6 | OUT | C8 | 1 | POWER |
| VCC_3V3_FILTERED | L2 | 2 | C9 | 1 | POWER |
| VCC_3V3_FILTERED | C9 | 1 | U3 | VDD | POWER |
| VCC_3V3_FILTERED | U3 | VDD | U5 | VDD | POWER |
| VCC_3V3_FILTERED | U5 | VDD | U8 | VDD_3V3 | POWER |
| VCC_3V3_FILTERED | U8 | VDD_3V3 | U9 | VCC | POWER |
| VCC_3V3_FILTERED | U9 | VCC | R2 | 2 | POWER |
| VCC_1V8 | U7 | OUT | L3 | 1 | POWER |
| VCC_1V8 | U7 | OUT | C11 | 1 | POWER |
| VCC_1V8_FILTERED | L3 | 2 | C12 | 1 | POWER |
| VCC_1V8_FILTERED | C12 | 1 | U4 | VDD_1V8 | POWER |
| VCC_1V8_FILTERED | U4 | VDD_1V8 | U8 | VDD_1V8 | POWER |
| VCC_1V2 | U7 | VRF | C13 | 1 | POWER |
| VCC_1V2 | C13 | 1 | U4 | VDD_1V2 | POWER |
| VCC_5V_PLL | L1 | 2 | C10 | 1 | POWER |
| VCC_5V_PLL | C10 | 1 | U3 | VCC_VCO | POWER |
| GND | U1 | GND | J1 | GND | GROUND |
| GND | U1 | GND | C1 | 2 | GROUND |
| GND | C1 | 2 | C2 | 2 | GROUND |
| GND | C2 | 2 | C3 | 2 | GROUND |
| GND | C3 | 2 | C4 | 2 | GROUND |
| GND | C4 | 2 | C5 | 2 | GROUND |
| GND | C5 | 2 | C6 | 2 | GROUND |
| GND | C6 | 2 | U2 | GND | GROUND |
| GND | U2 | GND | U3 | GND | GROUND |
| GND | U3 | GND | U4 | GND | GROUND |
| GND | U4 | GND | U5 | GND | GROUND |
| GND | U5 | GND | U6 | GND | GROUND |
| GND | U6 | GND | U7 | GND | GROUND |
| GND | U7 | GND | U8 | GND | GROUND |
| GND | U8 | GND | U9 | GND | GROUND |
| GND | U9 | GND | U10 | GND | GROUND |
| GND | U10 | GND | C7 | 2 | GROUND |
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
| GND | C22 | 2 | J3 | 8 | GROUND |
| RESET_N | U9 | Y | R4 | 2 | DIGITAL |
| RESET_N | R4 | 1 | U4 | RESET_N | DIGITAL |
| RESET_N | U4 | RESET_N | U8 | RESET_N | DIGITAL |
| RESET_PULLUP | R2 | 1 | U9 | A | DIGITAL |
| EEPROM_WP | U10 | WP | R7 | 1 | DIGITAL |
| EEPROM_WP | R7 | 2 | VCC_3V3_FILTERED | VCC_3V3_FILTERED | POWER |

## Net Connection List

| Net Name | Reference Designator - Pin No. |
|----------|-------------------------------|
| ADC_IN_N | T2 - OUT_N,  U4 - VIN_N |
| ADC_IN_P | T2 - OUT_P,  U4 - VIN_P |
| CLK_ADC_IN | U8 - OUT0,  U4 - CLK_IN |
| CLK_REF_IN | U8 - CLK_IN,  J2 - CLK_REF |
| CLK_REF_PLL | U8 - OUT1,  U3 - REF_IN |
| EEPROM_WP | U10 - WP,  R7 - 1,  R7 - 2,  VCC_3V3_FILTERED - VCC_3V3_FILTERED |
| GND | U1 - GND,  J1 - GND,  C1 - 2,  C2 - 2,  C3 - 2,  C4 - 2,  C5 - 2,  C6 - 2,  U2 - GND,  U3 - GND,  U4 - GND,  U5 - GND,  U6 - GND,  U7 - GND,  U8 - GND,  U9 - GND,  U10 - GND,  C7 - 2,  C8 - 2,  C9 - 2,  C10 - 2,  C11 - 2,  C12 - 2,  C13 - 2,  C14 - 2,  C15 - 2,  C16 - 2,  C17 - 2,  C18 - 2,  C19 - 2,  C20 - 2,  C21 - 2,  C22 - 2,  J3 - 8 |
| I2C_SCL | J3 - 4,  U10 - SCL |
| I2C_SDA | J3 - 6,  U10 - SDA |
| IF_I_N | U2 - IF_I_N,  T2 - IN_N1 |
| IF_I_P | U2 - IF_I_P,  T2 - IN_P1 |
| IF_Q_N | U2 - IF_Q_N,  T2 - IN_N2 |
| IF_Q_P | U2 - IF_Q_P,  T2 - IN_P2 |
| JESD_SYNC_N | U4 - SYNC_N,  J2 - SYNC_N |
| JESD_SYNC_P | U4 - SYNC_P,  J2 - SYNC_P |
| JESD_TX0_N | U4 - JESD_TX0_N,  J2 - DP0_N |
| JESD_TX0_P | U4 - JESD_TX0_P,  J2 - DP0_P |
| JESD_TX1_N | U4 - JESD_TX1_N,  J2 - DP1_N |
| JESD_TX1_P | U4 - JESD_TX1_P,  J2 - DP1_P |
| LNA_OUT | U1 - RFOUT,  C3 - 1 |
| LNA_OUT_C3 | C3 - 2,  T1 - UNBAL |
| LO_RF_OUT | U3 - RF_OUT_A,  U2 - LO_P |
| LO_RF_OUT_N | U3 - RF_OUT_B,  U2 - LO_N |
| RESET_N | U9 - Y,  R4 - 2,  R4 - 1,  U4 - RESET_N,  U8 - RESET_N |
| RESET_PULLUP | R2 - 1,  U9 - A |
| RF_IN | J1 - SIG,  C1 - 1 |
| RF_IN_C1 | C1 - 2,  U1 - RFIN |
| SPI_CLK | J3 - 3,  U4 - SCLK |
| SPI_CLK_PLL | J3 - 3,  U3 - CLK |
| SPI_CS_ADC | J3 - 9,  U4 - CS_N |
| SPI_CS_PLL | J3 - 1,  U3 - LE |
| SPI_CS_VGA | J3 - 2,  U5 - CS_N |
| SPI_MISO | U4 - SDO,  J3 - 7 |
| SPI_MOSI | J3 - 5,  U4 - SDIO |
| SPI_MOSI_PLL | J3 - 5,  U3 - DATA |
| SYSREF | U8 - SYSREF_OUT,  U4 - SYSREF |
| VCC_1V2 | U7 - VRF,  C13 - 1,  U4 - VDD_1V2 |
| VCC_1V8 | U7 - OUT,  L3 - 1,  C11 - 1 |
| VCC_1V8_FILTERED | L3 - 2,  C12 - 1,  U4 - VDD_1V8,  U8 - VDD_1V8 |
| VCC_3V3 | U6 - OUT,  L2 - 1,  C8 - 1 |
| VCC_3V3_FILTERED | L2 - 2,  C9 - 1,  U3 - VDD,  U5 - VDD,  U8 - VDD_3V3,  U9 - VCC,  R2 - 2 |
| VCC_5V | J3 - 10,  L1 - 1,  U6 - IN |
| VCC_5V_FILTERED | L1 - 2,  C7 - 1,  U1 - VCC,  U2 - VCC |
| VCC_5V_PLL | L1 - 2,  C10 - 1,  U3 - VCC_VCO |
| VGA_IN_N | T1 - BAL_N,  U5 - IN_N |
| VGA_IN_P | T1 - BAL_P,  U5 - IN_P |
| VGA_OUT_N | U5 - OUT_N,  U2 - RF_N |
| VGA_OUT_P | U5 - OUT_P,  U2 - RF_P |

## Validation Notes

- WARNING: ADF5356 LO frequency range (53.125 MHz - 13.6 GHz) may not cover full 18 GHz RF input range. Consider adding x2 frequency multiplier or selecting LMX2594 (15 GHz) for full coverage.
- WARNING: HMC1051LP4E LO drive requirement is +16 dBm. ADF5356 output power may be insufficient - consider adding LO amplifier (e.g., HMC361) after PLL.
- INFO: Direct RF sampling at 5-18 GHz requires ADC input bandwidth verification. ADC12DJ5200RF has 6.5 GHz bandwidth - downconversion to IF is required for 5-18 GHz coverage.
- CHECK: Verify LO frequency planning for IQ downconversion. For 5-18 GHz RF down to DC-500 MHz IF, LO range of 4.5-17.5 GHz required.
- RECOMMENDATION: Add IF bandpass filter (300-800 MHz) between T2 and U4 ADC input to limit noise and aliasing.
- RECOMMENDATION: Add RF attenuator (0-10 dB, programmable) before LNA for input signal protection above -10 dBm.
- INFO: Power budget within limit. Estimated: LNA(400mW) + Mixer(500mW) + PLL(900mW) + VGA(400mW) + ADC(2.5W) + Clock(1W) = ~5.7W (slightly over 5W budget).
- WARNING: Total power consumption may exceed 5W budget. Consider using ADC12DJ3200 (lower power variant) or optimizing power management.
- CHECK: JESD204B lane rate validation required. ADC12DJ5200RF supports up to 12.5 Gbps - verify FPGA/Capability.
- INFO: Reset tree topology verified. Single open-drain buffer with pullup distributes reset to ADC and Clock Cleaner.
- RECOMMENDATION: Add ESD protection on RF input (J1) for enhanced system robustness.
- RECOMMENDATION: Add RF power detector after LNA for AGC feedback implementation.
- CHECK: Verify balun T1 frequency coverage (6-18 GHz) matches RF path. May need wider band balun for 5 GHz operation.
- INFO: Decoupling capacitor strategy follows 10:1 rule (10uF, 0.1uF, 0.01uF) for all power rails.
- RECOMMENDATION: Add thermal relief vias under U4 ADC for heat dissipation (2.5W typical).
- CHECK: PCB stackup requires controlled impedance for JESD204B lanes (100 ohm differential) and RF traces (50 ohm single-ended).
- INFO: All components rated for -40°C to +85°C industrial temperature range.