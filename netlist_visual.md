# Logical Netlist
## sample

## Block Diagram

```mermaid
graph TB
    J1[SMA_RF_Input_Connector (SMA-EDGE-50-POS)]
    U1[Wideband_LNA (HMC1134LP4ETR)]
    U2[RF_SPDT_Switch (HMC1118LP3E)]
    U3[Wideband_Mixer (HMC559LP4)]
    U4[IF_VGA (AD8376ABCZZ)]
    U5[High_Speed_ADC (AD9208-2500EBZ)]
    U6[Clock_Generator (HMC7044LP6F)]
    U7[Power_Controller (LTC2975EUHF#PBF)]
    U8[FPGA_Controller (XCZU2CG-1SFVC784E)]
    L1[RF_Chip_Bead (BKP1005HS300-T)]
    C1[DC_Block_Cap (GRM1555C1H101JA01D)]
    C2[Decoupling_Cap (GRM32ER71H475KA88L)]
    C3[Decoupling_Cap (GRM32ER71H475KA88L)]
    C4[Decoupling_Cap (GRM32ER71H475KA88L)]
    C5[Decoupling_Cap (GRM32ER71H475KA88L)]
    C6[Decoupling_Cap (GRM32ER71H475KA88L)]
    C7[Decoupling_Cap (GRM32ER71H475KA88L)]
    C8[Decoupling_Cap (GRM32ER71H475KA88L)]
    C9[Decoupling_Cap (GRM32ER71H475KA88L)]
    C10[Decoupling_Cap (GRM32ER71H475KA88L)]
    C11[Decoupling_Cap (GRM32ER71H475KA88L)]
    C12[Decoupling_Cap (GRM32ER71H475KA88L)]
    C13[Decoupling_Cap (GRM32ER71H475KA88L)]
    C14[Decoupling_Cap (GRM32ER71H475KA88L)]
    R1[Gate_Resistor (ERJ-2RKF1000X)]
    R2[Termination_Resistor (ERJ-2RKF1001X)]
    R3[Pull_Up_Resistor (ERJ-2RKF1002X)]
    R4[Pull_Up_Resistor (ERJ-2RKF1002X)]
    R5[I2C_Pull_Up (ERJ-2RKF4701X)]
    R6[I2C_Pull_Up (ERJ-2RKF4701X)]
    J1 -->|RF_IN_FROM_J1| U1
    L1 -->|L1_DC_SUPPLY| U1
    U1 -->|C1_RF_COUPLING| C1
    C1 -->|RF_TO_SWITCH| U2
    U2 -->|SWITCH_RF_OUT| U3
    U3 -->|IF_PATH| U4
    U3 -->|IF_PATH_N| U4
    U4 -->|VGA_OUT_P| U5
    U4 -->|VGA_OUT_N| U5
    U4 -->|VGA_OUT_N| R2
    U6 -->|ADC_CLK_P| U5
    U6 -->|ADC_CLK_N| U5
    U6 -->|MIXER_LO| U3
    U5 -->|JESD_TX0_P| U8
    U5 -->|JESD_TX0_N| U8
    U5 -->|JESD_TX1_P| U8
    U5 -->|JESD_TX1_N| U8
    U5 -->|JESD_TX2_P| U8
    U5 -->|JESD_TX2_N| U8
    U5 -->|JESD_TX3_P| U8
    U5 -->|JESD_TX3_N| U8
    U5 -->|JESD_SYNC_P| U8
    U5 -->|JESD_SYNC_N| U8
    U8 -->|SPI_SCLK| U7
    U8 -->|SPI_SCLK| U5
    U8 -->|SPI_SCLK| U6
    U5 -->|SPI_SDO| U8
    U6 -->|SPI_SDO| U8
    U7 -->|SPI_SDO| U8
    U8 -->|SPI_SDI| U5
    U8 -->|SPI_SDI| U6
    U8 -->|SPI_SDI| U7
    U8 -->|SPI_CS_ADC| U5
    U8 -->|SPI_CS_CLK| U6
    U8 -->|SPI_CS_PWR| U7
    U8 -->|VGA_GAIN_CLK| U4
    U8 -->|VGA_GAIN_DATA| U4
    U8 -->|VGA_GAIN_LE| U4
    U8 -->|SWITCH_CTRL_A| U2
    U8 -->|SWITCH_CTRL_B| U2
    U8 -->|FPGA_SYNC_P| U5
    U8 -->|FPGA_SYNC_N| U5
    U6 -->|CLK_REF_IN| U8
    L1 -->|VDD_5V_LNA| U1
    L1 -->|VDD_5V_LNA| U2
    L1 -->|VDD_5V_LNA| U3
    U7 -->|VCC_5V_MAIN| U4
    U7 -->|VCC_5V_MAIN| U6
    U7 -->|VCC_5V_MAIN| U7
    U7 -->|VCC_3V3_IO| U8
    U7 -->|VCC_3V3_IO| U8
    U7 -->|VCC_1V25_ADC| U5
    U7 -->|VCC_1V25_ADC| U6
    U7 -->|VCC_2V5_ADC| U5
    U1 -->|C2_DECAY| C2
    C2 -->|GND| U1
    C2 -->|GND| U1
    U2 -->|C3_DECAY| C3
    C3 -->|GND| U2
    U3 -->|C4_DECAY| C4
    C4 -->|GND| U3
    U4 -->|C5_DECAY| C5
    C5 -->|GND| U4
    U5 -->|C6_DECAY| C6
    C6 -->|GND| U5
    C6 -->|GND| U5
    U5 -->|C7_DECAY| C7
    C7 -->|GND| U5
    U6 -->|C8_DECAY| C8
    C8 -->|GND| U6
    U6 -->|C9_DECAY| C9
    C9 -->|GND| U6
    U7 -->|C10_DECAY| C10
    C10 -->|GND| U7
    J1 -->|GND| U1
    J1 -->|GND| U1
    J1 -->|GND| U1
    J1 -->|GND| U1
    R1 -->|GND| U5
    U8 -->|ADC_SDIO_R1| R1
    R2 -->|GND| U4
    U7 -->|VCC_3V3_IO| R3
    R3 -->|ADC_CS_R3| U5
    U7 -->|VCC_3V3_IO| R4
    R4 -->|CLK_CS_R4| U6
    U7 -->|VCC_3V3_IO| R5
    R5 -->|I2C_SCL_R5| U8
    U7 -->|VCC_3V3_IO| R6
    R6 -->|I2C_SDA_R6| U8
    U7 -->|VCC_1V8_VTT| U5
    U5 -->|C11_DECAY| C11
    C11 -->|GND| U5
    U7 -->|VCC_3V3_IO| U8
    U8 -->|C12_DECAY| C12
    C12 -->|GND| U8
    U8 -->|C13_DECAY| C13
    C13 -->|GND| U8
    U8 -->|C14_DECAY| C14
    C14 -->|GND| U8
```

## Component Instances

| Ref | Part Number | Component |
|---|---|---|
| J1 | SMA-EDGE-50-POS | SMA_RF_Input_Connector |
| U1 | HMC1134LP4ETR | Wideband_LNA |
| U2 | HMC1118LP3E | RF_SPDT_Switch |
| U3 | HMC559LP4 | Wideband_Mixer |
| U4 | AD8376ABCZZ | IF_VGA |
| U5 | AD9208-2500EBZ | High_Speed_ADC |
| U6 | HMC7044LP6F | Clock_Generator |
| U7 | LTC2975EUHF#PBF | Power_Controller |
| U8 | XCZU2CG-1SFVC784E | FPGA_Controller |
| L1 | BKP1005HS300-T | RF_Chip_Bead |
| C1 | GRM1555C1H101JA01D | DC_Block_Cap |
| C2 | GRM32ER71H475KA88L | Decoupling_Cap |
| C3 | GRM32ER71H475KA88L | Decoupling_Cap |
| C4 | GRM32ER71H475KA88L | Decoupling_Cap |
| C5 | GRM32ER71H475KA88L | Decoupling_Cap |
| C6 | GRM32ER71H475KA88L | Decoupling_Cap |
| C7 | GRM32ER71H475KA88L | Decoupling_Cap |
| C8 | GRM32ER71H475KA88L | Decoupling_Cap |
| C9 | GRM32ER71H475KA88L | Decoupling_Cap |
| C10 | GRM32ER71H475KA88L | Decoupling_Cap |
| C11 | GRM32ER71H475KA88L | Decoupling_Cap |
| C12 | GRM32ER71H475KA88L | Decoupling_Cap |
| C13 | GRM32ER71H475KA88L | Decoupling_Cap |
| C14 | GRM32ER71H475KA88L | Decoupling_Cap |
| R1 | ERJ-2RKF1000X | Gate_Resistor |
| R2 | ERJ-2RKF1001X | Termination_Resistor |
| R3 | ERJ-2RKF1002X | Pull_Up_Resistor |
| R4 | ERJ-2RKF1002X | Pull_Up_Resistor |
| R5 | ERJ-2RKF4701X | I2C_Pull_Up |
| R6 | ERJ-2RKF4701X | I2C_Pull_Up |

## Pin-to-Pin Connections

| Net | From | Pin | To | Pin | Type |
|---|---|---|---|---|---|
| RF_IN_FROM_J1 | J1 | SIG | U1 | RF_IN | analog |
| L1_DC_SUPPLY | L1 | 2 | U1 | VGG | power |
| C1_RF_COUPLING | U1 | RF_OUT | C1 | 1 | analog |
| RF_TO_SWITCH | C1 | 2 | U2 | RFC | analog |
| SWITCH_RF_OUT | U2 | RF1 | U3 | RF_IN | analog |
| IF_PATH | U3 | IF | U4 | VIN_P | analog |
| IF_PATH_N | U3 | IFB | U4 | VIN_N | analog |
| VGA_OUT_P | U4 | VOUTP | U5 | AIN_P | analog |
| VGA_OUT_N | U4 | VOUTN | U5 | AIN_N | analog |
| VGA_OUT_N | U4 | VOUTN | R2 | 1 | analog |
| ADC_CLK_P | U6 | OUT0_P | U5 | CLK_P | clock |
| ADC_CLK_N | U6 | OUT0_N | U5 | CLK_N | clock |
| MIXER_LO | U6 | OUT1_P | U3 | LO | clock |
| JESD_TX0_P | U5 | D0_P | U8 | JESD_RX0_P | digital |
| JESD_TX0_N | U5 | D0_N | U8 | JESD_RX0_N | digital |
| JESD_TX1_P | U5 | D1_P | U8 | JESD_RX1_P | digital |
| JESD_TX1_N | U5 | D1_N | U8 | JESD_RX1_N | digital |
| JESD_TX2_P | U5 | D2_P | U8 | JESD_RX2_P | digital |
| JESD_TX2_N | U5 | D2_N | U8 | JESD_RX2_N | digital |
| JESD_TX3_P | U5 | D3_P | U8 | JESD_RX3_P | digital |
| JESD_TX3_N | U5 | D3_N | U8 | JESD_RX3_N | digital |
| JESD_SYNC_P | U5 | SYNC_P | U8 | SYNC_OUT_P | digital |
| JESD_SYNC_N | U5 | SYNC_N | U8 | SYNC_OUT_N | digital |
| SPI_SCLK | U8 | SPI_SCLK | U7 | SCLK | digital |
| SPI_SCLK | U8 | SPI_SCLK | U5 | SCLK | digital |
| SPI_SCLK | U8 | SPI_SCLK | U6 | SCLK | digital |
| SPI_SDO | U5 | SDO | U8 | SPI_MISO | digital |
| SPI_SDO | U6 | SDO | U8 | SPI_MISO | digital |
| SPI_SDO | U7 | SDO | U8 | SPI_MISO | digital |
| SPI_SDI | U8 | SPI_MOSI | U5 | SDIO | digital |
| SPI_SDI | U8 | SPI_MOSI | U6 | SDIO | digital |
| SPI_SDI | U8 | SPI_MOSI | U7 | SDI | digital |
| SPI_CS_ADC | U8 | CS_ADC_N | U5 | CS_N | digital |
| SPI_CS_CLK | U8 | CS_CLK_N | U6 | CS_N | digital |
| SPI_CS_PWR | U8 | CS_PWR_N | U7 | CS_N | digital |
| VGA_GAIN_CLK | U8 | GPIO_0 | U4 | CLK | digital |
| VGA_GAIN_DATA | U8 | GPIO_1 | U4 | DATA | digital |
| VGA_GAIN_LE | U8 | GPIO_2 | U4 | LE | digital |
| SWITCH_CTRL_A | U8 | GPIO_3 | U2 | A | digital |
| SWITCH_CTRL_B | U8 | GPIO_4 | U2 | B | digital |
| FPGA_SYNC_P | U8 | SYNC_IN_P | U5 | SYNC_IN_P | digital |
| FPGA_SYNC_N | U8 | SYNC_IN_N | U5 | SYNC_IN_N | digital |
| CLK_REF_IN | U6 | REF_IN | U8 | CLK_OUT1_P | clock |
| VDD_5V_LNA | L1 | 1 | U1 | VDD | power |
| VDD_5V_LNA | L1 | 1 | U2 | VDD | power |
| VDD_5V_LNA | L1 | 1 | U3 | VCC | power |
| VCC_5V_MAIN | U7 | VOUT1 | U4 | VPOS | power |
| VCC_5V_MAIN | U7 | VOUT1 | U6 | VCC | power |
| VCC_5V_MAIN | U7 | VOUT1 | U7 | VDD | power |
| VCC_3V3_IO | U7 | VOUT2 | U8 | VCCINT | power |
| VCC_3V3_IO | U7 | VOUT2 | U8 | VCCAUX | power |
| VCC_1V25_ADC | U7 | VOUT3 | U5 | VDD_1V25 | power |
| VCC_1V25_ADC | U7 | VOUT3 | U6 | VDD_1V25 | power |
| VCC_2V5_ADC | U7 | VOUT4 | U5 | VDD_2V5 | power |
| C2_DECAY | U1 | VDD | C2 | 1 | power |
| GND | C2 | 2 | U1 | GND | ground |
| GND | C2 | 2 | U1 | GND_PAD | ground |
| C3_DECAY | U2 | VDD | C3 | 1 | power |
| GND | C3 | 2 | U2 | GND | ground |
| C4_DECAY | U3 | VCC | C4 | 1 | power |
| GND | C4 | 2 | U3 | GND | ground |
| C5_DECAY | U4 | VPOS | C5 | 1 | power |
| GND | C5 | 2 | U4 | VNEG | ground |
| C6_DECAY | U5 | VDD_1V25 | C6 | 1 | power |
| GND | C6 | 2 | U5 | GND | ground |
| GND | C6 | 2 | U5 | EPAD | ground |
| C7_DECAY | U5 | VDD_2V5 | C7 | 1 | power |
| GND | C7 | 2 | U5 | AVSS | ground |
| C8_DECAY | U6 | VCC | C8 | 1 | power |
| GND | C8 | 2 | U6 | GND | ground |
| C9_DECAY | U6 | VDD_1V25 | C9 | 1 | power |
| GND | C9 | 2 | U6 | GND | ground |
| C10_DECAY | U7 | VDD | C10 | 1 | power |
| GND | C10 | 2 | U7 | GND | ground |
| GND | J1 | SHLD1 | U1 | GND | ground |
| GND | J1 | SHLD2 | U1 | GND | ground |
| GND | J1 | SHLD3 | U1 | GND | ground |
| GND | J1 | SHLD4 | U1 | GND | ground |
| GND | R1 | 2 | U5 | GND | ground |
| ADC_SDIO_R1 | U8 | SPI_MOSI | R1 | 1 | digital |
| GND | R2 | 2 | U4 | VNEG | ground |
| VCC_3V3_IO | U7 | VOUT2 | R3 | 1 | power |
| ADC_CS_R3 | R3 | 2 | U5 | CS_N | digital |
| VCC_3V3_IO | U7 | VOUT2 | R4 | 1 | power |
| CLK_CS_R4 | R4 | 2 | U6 | CS_N | digital |
| VCC_3V3_IO | U7 | VOUT2 | R5 | 1 | power |
| I2C_SCL_R5 | R5 | 2 | U8 | I2C_SCL | digital |
| VCC_3V3_IO | U7 | VOUT2 | R6 | 1 | power |
| I2C_SDA_R6 | R6 | 2 | U8 | I2C_SDA | digital |
| VCC_1V8_VTT | U7 | VOUT5 | U5 | VTT | power |
| C11_DECAY | U5 | VTT | C11 | 1 | power |
| GND | C11 | 2 | U5 | GND | ground |
| VCC_3V3_IO | U7 | VOUT2 | U8 | VCCO_33 | power |
| C12_DECAY | U8 | VCCINT | C12 | 1 | power |
| GND | C12 | 2 | U8 | GND | ground |
| C13_DECAY | U8 | VCCAUX | C13 | 1 | power |
| GND | C13 | 2 | U8 | GND | ground |
| C14_DECAY | U8 | VCCO_33 | C14 | 1 | power |
| GND | C14 | 2 | U8 | GND | ground |

## Net Connection List

| Net Name | Reference Designator - Pin No. |
|----------|-------------------------------|
| ADC_CLK_N | U6 - OUT0_N,  U5 - CLK_N |
| ADC_CLK_P | U6 - OUT0_P,  U5 - CLK_P |
| ADC_CS_R3 | R3 - 2,  U5 - CS_N |
| ADC_SDIO_R1 | U8 - SPI_MOSI,  R1 - 1 |
| C10_DECAY | U7 - VDD,  C10 - 1 |
| C11_DECAY | U5 - VTT,  C11 - 1 |
| C12_DECAY | U8 - VCCINT,  C12 - 1 |
| C13_DECAY | U8 - VCCAUX,  C13 - 1 |
| C14_DECAY | U8 - VCCO_33,  C14 - 1 |
| C1_RF_COUPLING | U1 - RF_OUT,  C1 - 1 |
| C2_DECAY | U1 - VDD,  C2 - 1 |
| C3_DECAY | U2 - VDD,  C3 - 1 |
| C4_DECAY | U3 - VCC,  C4 - 1 |
| C5_DECAY | U4 - VPOS,  C5 - 1 |
| C6_DECAY | U5 - VDD_1V25,  C6 - 1 |
| C7_DECAY | U5 - VDD_2V5,  C7 - 1 |
| C8_DECAY | U6 - VCC,  C8 - 1 |
| C9_DECAY | U6 - VDD_1V25,  C9 - 1 |
| CLK_CS_R4 | R4 - 2,  U6 - CS_N |
| CLK_REF_IN | U6 - REF_IN,  U8 - CLK_OUT1_P |
| FPGA_SYNC_N | U8 - SYNC_IN_N,  U5 - SYNC_IN_N |
| FPGA_SYNC_P | U8 - SYNC_IN_P,  U5 - SYNC_IN_P |
| GND | C2 - 2,  U1 - GND,  U1 - GND_PAD,  C3 - 2,  U2 - GND,  C4 - 2,  U3 - GND,  C5 - 2,  U4 - VNEG,  C6 - 2,  U5 - GND,  U5 - EPAD,  C7 - 2,  U5 - AVSS,  C8 - 2,  U6 - GND,  C9 - 2,  C10 - 2,  U7 - GND,  J1 - SHLD1,  J1 - SHLD2,  J1 - SHLD3,  J1 - SHLD4,  R1 - 2,  R2 - 2,  C11 - 2,  C12 - 2,  U8 - GND,  C13 - 2,  C14 - 2 |
| I2C_SCL_R5 | R5 - 2,  U8 - I2C_SCL |
| I2C_SDA_R6 | R6 - 2,  U8 - I2C_SDA |
| IF_PATH | U3 - IF,  U4 - VIN_P |
| IF_PATH_N | U3 - IFB,  U4 - VIN_N |
| JESD_SYNC_N | U5 - SYNC_N,  U8 - SYNC_OUT_N |
| JESD_SYNC_P | U5 - SYNC_P,  U8 - SYNC_OUT_P |
| JESD_TX0_N | U5 - D0_N,  U8 - JESD_RX0_N |
| JESD_TX0_P | U5 - D0_P,  U8 - JESD_RX0_P |
| JESD_TX1_N | U5 - D1_N,  U8 - JESD_RX1_N |
| JESD_TX1_P | U5 - D1_P,  U8 - JESD_RX1_P |
| JESD_TX2_N | U5 - D2_N,  U8 - JESD_RX2_N |
| JESD_TX2_P | U5 - D2_P,  U8 - JESD_RX2_P |
| JESD_TX3_N | U5 - D3_N,  U8 - JESD_RX3_N |
| JESD_TX3_P | U5 - D3_P,  U8 - JESD_RX3_P |
| L1_DC_SUPPLY | L1 - 2,  U1 - VGG |
| MIXER_LO | U6 - OUT1_P,  U3 - LO |
| RF_IN_FROM_J1 | J1 - SIG,  U1 - RF_IN |
| RF_TO_SWITCH | C1 - 2,  U2 - RFC |
| SPI_CS_ADC | U8 - CS_ADC_N,  U5 - CS_N |
| SPI_CS_CLK | U8 - CS_CLK_N,  U6 - CS_N |
| SPI_CS_PWR | U8 - CS_PWR_N,  U7 - CS_N |
| SPI_SCLK | U8 - SPI_SCLK,  U7 - SCLK,  U5 - SCLK,  U6 - SCLK |
| SPI_SDI | U8 - SPI_MOSI,  U5 - SDIO,  U6 - SDIO,  U7 - SDI |
| SPI_SDO | U5 - SDO,  U8 - SPI_MISO,  U6 - SDO,  U7 - SDO |
| SWITCH_CTRL_A | U8 - GPIO_3,  U2 - A |
| SWITCH_CTRL_B | U8 - GPIO_4,  U2 - B |
| SWITCH_RF_OUT | U2 - RF1,  U3 - RF_IN |
| VCC_1V25_ADC | U7 - VOUT3,  U5 - VDD_1V25,  U6 - VDD_1V25 |
| VCC_1V8_VTT | U7 - VOUT5,  U5 - VTT |
| VCC_2V5_ADC | U7 - VOUT4,  U5 - VDD_2V5 |
| VCC_3V3_IO | U7 - VOUT2,  U8 - VCCINT,  U8 - VCCAUX,  R3 - 1,  R4 - 1,  R5 - 1,  R6 - 1,  U8 - VCCO_33 |
| VCC_5V_MAIN | U7 - VOUT1,  U4 - VPOS,  U6 - VCC,  U7 - VDD |
| VDD_5V_LNA | L1 - 1,  U1 - VDD,  U2 - VDD,  U3 - VCC |
| VGA_GAIN_CLK | U8 - GPIO_0,  U4 - CLK |
| VGA_GAIN_DATA | U8 - GPIO_1,  U4 - DATA |
| VGA_GAIN_LE | U8 - GPIO_2,  U4 - LE |
| VGA_OUT_N | U4 - VOUTN,  U5 - AIN_N,  R2 - 1 |
| VGA_OUT_P | U4 - VOUTP,  U5 - AIN_P |

## Validation Notes

- [CRITICAL] Multiple power domains detected: +5V (RF), +5V (Digital), +3.3V, +2.5V, +1.25V, +1.8V, -5V. Requires careful power sequencing per AD9208 datasheet Section 9.3.
- [WARNING] RF GaAs devices (U1, U2, U3) require +5V at 85mA each. Total ~255mA on RF rail. Verify L1 current rating and trace width.
- [WARNING] JESD204B/C lanes require impedance-controlled differential pairs (100Ω). Critical timing: ensure lane length matching within 5 mil.
- [INFO] HMC1134 LNA datasheet specifies -40°C to +85°C operating range - meets requirement REQ-HW-007.
- [WARNING] AD8376 VGA requires dual supply: +5V and -5V. -5V rail not shown in netlist - requires negative voltage inverter or dual-output PMIC.
- [WARNING] HMC559 mixer LO drive requires +15 dBm. Verify HMC7044 output power or add LO amplifier (e.g., HMC361).
- [WARNING] Switching power supply noise may couple into RF chain. Recommend LC filtering on U1-U3 supplies.
- [INFO] Decoupling capacitor values based on standard PCB design rules. Final values should be validated per component datasheet recommendations.
- [WARNING] RF switch U2 control lines (A, B) from FPGA GPIO - verify voltage levels match (HMC1118: 0/+3V or 0/-3V logic). May need level translator if FPGA is 2.5V IO.
- [WARNING] Total power budget estimated at ~18W (U1:0.43W, U2:0.5W, U3:1W, U4:2W, U5:4W, U6:2W, U7:0.5W, U8:8W). Within 30W requirement but thermal analysis required.
- [INFO] Band selection via U2 (HMC1118) provides discrete band switching as required by REQ-HW-011. Switching time 3ns meets fast switching requirement.
- [WARNING] ADC VTT (+1.8V) termination voltage required for JESD204B/C inputs. C11 provides decoupling.
- [WARNING] Input return loss depends on PCB matching network and U1 input impedance (50Ω typical). Smith chart matching recommended per HMC1134 datasheet.
- [INFO] HMC7044 clock gen provides <100fs jitter - suitable for 12-bit ADC SFDR >60dB requirement at Nyquist.
- [WARNING] Cascaded noise figure: U1 (2.5dB) + U2 (1.2dB) + U3 (7dB) + U4 (11dB) ≈ 9.5dB - meets <10dB requirement REQ-HW-002 marginally. Consider lower NF VGA option.
- [INFO] All RF components rated to at least 18GHz - covers full 5-18GHz requirement REQ-HW-001.
- [WARNING] SPI daisy-chain configuration (U5, U6, U7 on same bus) requires individual CS_N lines for independent addressing - provided as SPI_CS_ADC/N, SPI_CS_CLK/N, SPI_CS_PWR/N.
- [WARNING] AD9208 requires precise power-up sequence: 1.25V core → 2.5V IO → 1.8V VTT → 3.3V CLK. PMIC U7 should implement sequencer per LTC2975 datasheet.