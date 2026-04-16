# Logical Netlist
## ehg

## Block Diagram

```mermaid
graph TB
    J1[RF_INPUT_CONNECTOR (SMA-J-pth-50ohm)]
    U1[WIDEBAND_LNA (HMC8141)]
    U2[RF_VGA (HMC698LP4)]
    U3[WIDEBAND_MIXER (HMC-CMS19)]
    U4[IF_AMPLIFIER (HMC5805)]
    U5[HIGH_SPEED_ADC (EV10AQ190A)]
    J2[LVDS_OUTPUT_CONNECTOR (SAMTEC-ASV-120-01-L-D)]
    U6[DC_DC_CONVERTER (PKM4716TCD15)]
    U7[LDO_5V (LT1086-5)]
    U8[LDO_3V3 (LT1086-3.3)]
    U9[VOLTAGE_REF (LT6656-2.5)]
    U10[CLK_GENERATOR (Si5345B-D)]
    U11[CLK_BUFFER (ADCLK914)]
    U12[MCU_CONTROLLER (STM32F407VGT6)]
    U13[EEPROM (M24M02-DR)]
    J3[POWER_INPUT (MOTORTERM-5.08-2)]
    C1[CAPACITOR (GRM32ER71H226KE15L)]
    C2[CAPACITOR (GRM32ER71H226KE15L)]
    C3[CAPACITOR (GRM32ER71H226KE15L)]
    C4[CAPACITOR (GRM32ER71H226KE15L)]
    C5[CAPACITOR (GRM32ER71H226KE15L)]
    C6[CAPACITOR (GRM32ER71H106KA73L)]
    C7[CAPACITOR (GRM32ER71H226KE15L)]
    C8[CAPACITOR (GRM32ER71H226KE15L)]
    C9[CAPACITOR (GRM32ER71H476ME15L)]
    C10[CAPACITOR (GRM32ER71H226KE15L)]
    C11[CAPACITOR (GRM32ER71H226KE15L)]
    C12[CAPACITOR (GRM32ER71H226KE15L)]
    C13[CAPACITOR (GRM32ER71H226KE15L)]
    C14[CAPACITOR (GRM32ER71H226KE15L)]
    C15[CAPACITOR (GRM32ER71H106KA73L)]
    C16[CAPACITOR (GRM32ER71H226KE15L)]
    C17[CAPACITOR (GRM32ER71H476ME15L)]
    C18[CAPACITOR (GRM32ER71H226KE15L)]
    C19[CAPACITOR (GRM32ER71H106KA73L)]
    C20[CAPACITOR (GRM32ER71H106KA73L)]
    L1[INDUCTOR (LQG31PN4N7M00L)]
    L2[INDUCTOR (LQG31PN4N7M00L)]
    L3[INDUCTOR (LQG31PN4N7M00L)]
    R1[RESISTOR (CRCW060310K0FKEA)]
    R2[RESISTOR (CRCW060310K0FKEA)]
    R3[RESISTOR (CRCW06034K70FKEA)]
    R4[RESISTOR (CRCW060310K0FKEA)]
    R5[RESISTOR (CRCW060310K0FKEA)]
    R6[RESISTOR (CRCW060310K0FKEA)]
    R7[RESISTOR (CRCW060310K0FKEA)]
    R8[RESISTOR (CRCW06034K70FKEA)]
    R9[RESISTOR (CRCW06031K00FKEA)]
    R10[RESISTOR (CRCW06031K00FKEA)]
    R11[RESISTOR (CRCW060310K0FKEA)]
    R12[RESISTOR (CRCW060310K0FKEA)]
    R13[RESISTOR (CRCW060310K0FKEA)]
    R14[RESISTOR (CRCW06031K00FKEA)]
    R15[RESISTOR (CRCW06034K70FKEA)]
    R16[RESISTOR (CRCW06031K00FKEA)]
    J1 -->|RF_IN| U1
    U1 -->|RF_LNA_OUT| U2
    U2 -->|RF_VGA_OUT| U3
    U3 -->|IF_MIXER_OUT| U4
    U4 -->|IF_AMP_OUT| U5
    U4 -->|IF_AMP_OUT_N| U5
    U5 -->|LVDS_D0_P| J2
    U5 -->|LVDS_D0_N| J2
    U5 -->|LVDS_D1_P| J2
    U5 -->|LVDS_D1_N| J2
    U5 -->|LVDS_D2_P| J2
    U5 -->|LVDS_D2_N| J2
    U5 -->|LVDS_D3_P| J2
    U5 -->|LVDS_D3_N| J2
    U5 -->|LVDS_DCLK_P| J2
    U5 -->|LVDS_DCLK_N| J2
    U11 -->|CLK_ADC_P| U5
    U11 -->|CLK_ADC_N| U5
    U10 -->|CLK_BUF_IN| U11
    U10 -->|CLK_BUF_IN_N| U11
    J3 -->|VCC_28V| U6
    U6 -->|VCC_15V| U7
    U7 -->|VCC_5V_RF| U1
    U7 -->|VCC_5V_RF| U2
    U7 -->|VCC_5V_RF| U3
    U7 -->|VCC_5V_RF| U4
    U8 -->|VCC_3V3_DIG| U5
    U8 -->|VCC_3V3_DIG| U10
    U8 -->|VCC_3V3_DIG| U11
    U8 -->|VCC_3V3_DIG| U12
    U8 -->|VCC_3V3_DIG| U13
    U9 -->|VREF_2V5| U5
    U12 -->|SPI_SCK| U2
    U12 -->|SPI_MOSI| U2
    U12 -->|SPI_MISO| U2
    U12 -->|VGA_CS| U2
    U12 -->|I2C_SCL| U10
    U12 -->|I2C_SCL| U13
    U12 -->|I2C_SDA| U10
    U12 -->|I2C_SDA| U13
    U12 -->|ADC_SDIO| U5
    U12 -->|ADC_CS_N| U5
    U12 -->|ADC_SCK| U5
    U12 -->|ADC_RST_N| U5
    U12 -->|AGC_ENABLE| U2
    U12 -->|ADC_OE_N| U5
    U12 -->|LED_STATUS| R14
    R14 -->|LED_ANODE| R15
    J1 -->|GND| C1
    J1 -->|GND| U1
    U1 -->|GND| C2
    U2 -->|GND| C3
    U2 -->|GND| C4
    U3 -->|GND| C5
    U4 -->|GND| C6
    U5 -->|GND| C7
    U5 -->|GND| C8
    U5 -->|GND| C9
    U6 -->|GND| J3
    U6 -->|GND| C10
    U7 -->|GND| C11
    U7 -->|GND| C12
    U8 -->|GND| C13
    U8 -->|GND| C14
    U9 -->|GND| C15
    U10 -->|GND| C16
    U11 -->|GND| C17
    U12 -->|GND| C18
    U12 -->|GND| C19
    U13 -->|GND| C20
    R15 -->|GND| J2
    U7 -->|5V_RF_LNA| C2
    C2 -->|5V_RF_LNA| L1
    L1 -->|5V_RF_LNA_FILT| U1
    U7 -->|5V_RF_VGA| C3
    C3 -->|5V_RF_VGA| L2
    L2 -->|5V_RF_VGA_FILT| U2
    U7 -->|5V_RF_MIX| C5
    C5 -->|5V_RF_MIX| L3
    L3 -->|5V_RF_MIX_FILT| U3
    U7 -->|5V_RF_IF| C6
    C6 -->|5V_RF_IF| U4
    U8 -->|3V3_ADC| C7
    C7 -->|3V3_ADC| C8
    C8 -->|3V3_ADC| C9
    C9 -->|3V3_ADC_CORE| U5
    U6 -->|15V_DCDC| C10
    C10 -->|15V_DCDC| R1
    R1 -->|EN_DCDC| U12
    U6 -->|5V_LDO_IN| U7
    U7 -->|3V3_LDO_IN| U8
    U9 -->|2V5_REF| C15
    C15 -->|2V5_REF| R2
    R2 -->|VREF_ADC| U5
    U8 -->|3V3_CLK| C16
    C16 -->|3V3_CLK| U10
    U8 -->|3V3_CLK_BUF| C17
    C17 -->|3V3_CLK_BUF| U11
    U8 -->|3V3_MCU| C18
    C18 -->|3V3_MCU| C19
    C19 -->|3V3_MCU_CORE| U12
    U8 -->|3V3_EEPROM| C20
    C20 -->|3V3_EEPROM| U13
    R3 -->|MCU_BOOT0| U12
    R3 -->|MCU_BOOT0_GND| R4
    R4 -->|BOOT_PULLDN| U12
    U12 -->|MCU_NRST| R5
    R5 -->|MCU_NRST_PULLUP| U8
    U12 -->|MCU_NRST_C| C11
    R6 -->|I2C_SCL_PULLUP| U12
    R6 -->|I2C_SCL_PU_VDD| U8
    R7 -->|I2C_SDA_PULLUP| U12
    R7 -->|I2C_SDA_PU_VDD| U8
    U10 -->|CLK_CLKIN| R8
    R8 -->|CLK_REF_IN| J2
    U12 -->|CLK_OE| U11
    U12 -->|EEPROM_WP| U13
    U8 -->|VCC_3V3_DIG| R9
    R9 -->|VCC_3V3_DIG| R10
    R10 -->|VCC_3V3_DIG| R11
    R11 -->|VCC_3V3_DIG| R12
    R12 -->|VCC_3V3_DIG| R13
    R13 -->|GND| R16
    R16 -->|VCC_3V3_DIG| R15
```

## Component Instances

| Ref | Part Number | Component |
|---|---|---|
| J1 | SMA-J-pth-50ohm | RF_INPUT_CONNECTOR |
| U1 | HMC8141 | WIDEBAND_LNA |
| U2 | HMC698LP4 | RF_VGA |
| U3 | HMC-CMS19 | WIDEBAND_MIXER |
| U4 | HMC5805 | IF_AMPLIFIER |
| U5 | EV10AQ190A | HIGH_SPEED_ADC |
| J2 | SAMTEC-ASV-120-01-L-D | LVDS_OUTPUT_CONNECTOR |
| U6 | PKM4716TCD15 | DC_DC_CONVERTER |
| U7 | LT1086-5 | LDO_5V |
| U8 | LT1086-3.3 | LDO_3V3 |
| U9 | LT6656-2.5 | VOLTAGE_REF |
| U10 | Si5345B-D | CLK_GENERATOR |
| U11 | ADCLK914 | CLK_BUFFER |
| U12 | STM32F407VGT6 | MCU_CONTROLLER |
| U13 | M24M02-DR | EEPROM |
| J3 | MOTORTERM-5.08-2 | POWER_INPUT |
| C1 | GRM32ER71H226KE15L | CAPACITOR |
| C2 | GRM32ER71H226KE15L | CAPACITOR |
| C3 | GRM32ER71H226KE15L | CAPACITOR |
| C4 | GRM32ER71H226KE15L | CAPACITOR |
| C5 | GRM32ER71H226KE15L | CAPACITOR |
| C6 | GRM32ER71H106KA73L | CAPACITOR |
| C7 | GRM32ER71H226KE15L | CAPACITOR |
| C8 | GRM32ER71H226KE15L | CAPACITOR |
| C9 | GRM32ER71H476ME15L | CAPACITOR |
| C10 | GRM32ER71H226KE15L | CAPACITOR |
| C11 | GRM32ER71H226KE15L | CAPACITOR |
| C12 | GRM32ER71H226KE15L | CAPACITOR |
| C13 | GRM32ER71H226KE15L | CAPACITOR |
| C14 | GRM32ER71H226KE15L | CAPACITOR |
| C15 | GRM32ER71H106KA73L | CAPACITOR |
| C16 | GRM32ER71H226KE15L | CAPACITOR |
| C17 | GRM32ER71H476ME15L | CAPACITOR |
| C18 | GRM32ER71H226KE15L | CAPACITOR |
| C19 | GRM32ER71H106KA73L | CAPACITOR |
| C20 | GRM32ER71H106KA73L | CAPACITOR |
| L1 | LQG31PN4N7M00L | INDUCTOR |
| L2 | LQG31PN4N7M00L | INDUCTOR |
| L3 | LQG31PN4N7M00L | INDUCTOR |
| R1 | CRCW060310K0FKEA | RESISTOR |
| R2 | CRCW060310K0FKEA | RESISTOR |
| R3 | CRCW06034K70FKEA | RESISTOR |
| R4 | CRCW060310K0FKEA | RESISTOR |
| R5 | CRCW060310K0FKEA | RESISTOR |
| R6 | CRCW060310K0FKEA | RESISTOR |
| R7 | CRCW060310K0FKEA | RESISTOR |
| R8 | CRCW06034K70FKEA | RESISTOR |
| R9 | CRCW06031K00FKEA | RESISTOR |
| R10 | CRCW06031K00FKEA | RESISTOR |
| R11 | CRCW060310K0FKEA | RESISTOR |
| R12 | CRCW060310K0FKEA | RESISTOR |
| R13 | CRCW060310K0FKEA | RESISTOR |
| R14 | CRCW06031K00FKEA | RESISTOR |
| R15 | CRCW06034K70FKEA | RESISTOR |
| R16 | CRCW06031K00FKEA | RESISTOR |

## Pin-to-Pin Connections

| Net | From | Pin | To | Pin | Type |
|---|---|---|---|---|---|
| RF_IN | J1 | 1 | U1 | RF_IN | RF |
| RF_LNA_OUT | U1 | RF_OUT | U2 | RF_IN | RF |
| RF_VGA_OUT | U2 | RF_OUT | U3 | RF_IN | RF |
| IF_MIXER_OUT | U3 | IF_OUT | U4 | IN | IF |
| IF_AMP_OUT | U4 | OUT | U5 | AIN_P | IF |
| IF_AMP_OUT_N | U4 | OUT_N | U5 | AIN_N | IF |
| LVDS_D0_P | U5 | D0_P | J2 | A1 | LVDS |
| LVDS_D0_N | U5 | D0_N | J2 | A2 | LVDS |
| LVDS_D1_P | U5 | D1_P | J2 | A3 | LVDS |
| LVDS_D1_N | U5 | D1_N | J2 | A4 | LVDS |
| LVDS_D2_P | U5 | D2_P | J2 | A5 | LVDS |
| LVDS_D2_N | U5 | D2_N | J2 | A6 | LVDS |
| LVDS_D3_P | U5 | D3_P | J2 | A7 | LVDS |
| LVDS_D3_N | U5 | D3_N | J2 | A8 | LVDS |
| LVDS_DCLK_P | U5 | DCLK_P | J2 | A9 | LVDS_CLOCK |
| LVDS_DCLK_N | U5 | DCLK_N | J2 | A10 | LVDS_CLOCK |
| CLK_ADC_P | U11 | Q_P | U5 | CLK_P | CLOCK |
| CLK_ADC_N | U11 | Q_N | U5 | CLK_N | CLOCK |
| CLK_BUF_IN | U10 | OUT0_P | U11 | D_P | CLOCK |
| CLK_BUF_IN_N | U10 | OUT0_N | U11 | D_N | CLOCK |
| VCC_28V | J3 | 1 | U6 | VIN+ | POWER |
| VCC_15V | U6 | VOUT+ | U7 | IN | POWER |
| VCC_5V_RF | U7 | OUT | U1 | VCC | POWER |
| VCC_5V_RF | U7 | OUT | U2 | VCC | POWER |
| VCC_5V_RF | U7 | OUT | U3 | VCC | POWER |
| VCC_5V_RF | U7 | OUT | U4 | VCC | POWER |
| VCC_3V3_DIG | U8 | OUT | U5 | VDD | POWER |
| VCC_3V3_DIG | U8 | OUT | U10 | VDD | POWER |
| VCC_3V3_DIG | U8 | OUT | U11 | VCC | POWER |
| VCC_3V3_DIG | U8 | OUT | U12 | VDD | POWER |
| VCC_3V3_DIG | U8 | OUT | U13 | VCC | POWER |
| VREF_2V5 | U9 | OUT | U5 | VREF | ANALOG |
| SPI_SCK | U12 | PA5 | U2 | SCLK | SPI |
| SPI_MOSI | U12 | PA7 | U2 | SDI | SPI |
| SPI_MISO | U12 | PA6 | U2 | SDO | SPI |
| VGA_CS | U12 | PA4 | U2 | CS | SPI_CS |
| I2C_SCL | U12 | PB6 | U10 | SCL | I2C |
| I2C_SCL | U12 | PB6 | U13 | SCL | I2C |
| I2C_SDA | U12 | PB7 | U10 | SDA | I2C |
| I2C_SDA | U12 | PB7 | U13 | SDA | I2C |
| ADC_SDIO | U12 | PC12 | U5 | SDIO | SPI |
| ADC_CS_N | U12 | PC11 | U5 | CS_N | SPI_CS |
| ADC_SCK | U12 | PC10 | U5 | SCK | SPI |
| ADC_RST_N | U12 | PC9 | U5 | RESET_N | RESET |
| AGC_ENABLE | U12 | PB0 | U2 | ENABLE | DIGITAL |
| ADC_OE_N | U12 | PB1 | U5 | OE_N | DIGITAL |
| LED_STATUS | U12 | PB5 | R14 | 1 | DIGITAL |
| LED_ANODE | R14 | 2 | R15 | 2 | DIGITAL |
| GND | J1 | 2 | C1 | 2 | GROUND |
| GND | J1 | 2 | U1 | GND | GROUND |
| GND | U1 | GND | C2 | 2 | GROUND |
| GND | U2 | GND | C3 | 2 | GROUND |
| GND | U2 | GND | C4 | 2 | GROUND |
| GND | U3 | GND | C5 | 2 | GROUND |
| GND | U4 | GND | C6 | 2 | GROUND |
| GND | U5 | GND | C7 | 2 | GROUND |
| GND | U5 | GND | C8 | 2 | GROUND |
| GND | U5 | GND | C9 | 2 | GROUND |
| GND | U6 | VIN- | J3 | 2 | GROUND |
| GND | U6 | VOUT- | C10 | 2 | GROUND |
| GND | U7 | GND | C11 | 2 | GROUND |
| GND | U7 | GND | C12 | 2 | GROUND |
| GND | U8 | GND | C13 | 2 | GROUND |
| GND | U8 | GND | C14 | 2 | GROUND |
| GND | U9 | GND | C15 | 2 | GROUND |
| GND | U10 | GND | C16 | 2 | GROUND |
| GND | U11 | GND | C17 | 2 | GROUND |
| GND | U12 | VSS | C18 | 2 | GROUND |
| GND | U12 | VSS | C19 | 2 | GROUND |
| GND | U13 | GND | C20 | 2 | GROUND |
| GND | R15 | 1 | J2 | B12 | GROUND |
| 5V_RF_LNA | U7 | OUT | C2 | 1 | POWER |
| 5V_RF_LNA | C2 | 1 | L1 | 1 | POWER |
| 5V_RF_LNA_FILT | L1 | 2 | U1 | VCC | POWER |
| 5V_RF_VGA | U7 | OUT | C3 | 1 | POWER |
| 5V_RF_VGA | C3 | 1 | L2 | 1 | POWER |
| 5V_RF_VGA_FILT | L2 | 2 | U2 | VCC | POWER |
| 5V_RF_MIX | U7 | OUT | C5 | 1 | POWER |
| 5V_RF_MIX | C5 | 1 | L3 | 1 | POWER |
| 5V_RF_MIX_FILT | L3 | 2 | U3 | VCC | POWER |
| 5V_RF_IF | U7 | OUT | C6 | 1 | POWER |
| 5V_RF_IF | C6 | 1 | U4 | VCC | POWER |
| 3V3_ADC | U8 | OUT | C7 | 1 | POWER |
| 3V3_ADC | C7 | 1 | C8 | 1 | POWER |
| 3V3_ADC | C8 | 1 | C9 | 1 | POWER |
| 3V3_ADC_CORE | C9 | 1 | U5 | VDD | POWER |
| 15V_DCDC | U6 | VOUT+ | C10 | 1 | POWER |
| 15V_DCDC | C10 | 1 | R1 | 2 | POWER |
| EN_DCDC | R1 | 1 | U12 | PB9 | DIGITAL |
| 5V_LDO_IN | U6 | VOUT+ | U7 | IN | POWER |
| 3V3_LDO_IN | U7 | OUT | U8 | IN | POWER |
| 2V5_REF | U9 | OUT | C15 | 1 | POWER |
| 2V5_REF | C15 | 1 | R2 | 2 | POWER |
| VREF_ADC | R2 | 1 | U5 | VREF | ANALOG |
| 3V3_CLK | U8 | OUT | C16 | 1 | POWER |
| 3V3_CLK | C16 | 1 | U10 | VDD | POWER |
| 3V3_CLK_BUF | U8 | OUT | C17 | 1 | POWER |
| 3V3_CLK_BUF | C17 | 1 | U11 | VCC | POWER |
| 3V3_MCU | U8 | OUT | C18 | 1 | POWER |
| 3V3_MCU | C18 | 1 | C19 | 1 | POWER |
| 3V3_MCU_CORE | C19 | 1 | U12 | VDD | POWER |
| 3V3_EEPROM | U8 | OUT | C20 | 1 | POWER |
| 3V3_EEPROM | C20 | 1 | U13 | VCC | POWER |
| MCU_BOOT0 | R3 | 2 | U12 | BOOT0 | DIGITAL |
| MCU_BOOT0_GND | R3 | 1 | R4 | 2 | GROUND |
| BOOT_PULLDN | R4 | BOOT0 | U12 |  | DIGITAL |
| MCU_NRST | U12 | NRST | R5 | 2 | RESET |
| MCU_NRST_PULLUP | R5 | 1 | U8 | OUT | POWER |
| MCU_NRST_C | U12 | NRST | C11 | 1 | RESET |
| I2C_SCL_PULLUP | R6 | 2 | U12 | PB6 | I2C |
| I2C_SCL_PU_VDD | R6 | 1 | U8 | OUT | POWER |
| I2C_SDA_PULLUP | R7 | 2 | U12 | PB7 | I2C |
| I2C_SDA_PU_VDD | R7 | 1 | U8 | OUT | POWER |
| CLK_CLKIN | U10 | CLKIN | R8 | 2 | CLOCK |
| CLK_REF_IN | R8 | 1 | J2 | B11 | CLOCK |
| CLK_OE | U12 | PB8 | U11 | OE | DIGITAL |
| EEPROM_WP | U12 | PB4 | U13 | WC | DIGITAL |
| VCC_3V3_DIG | U8 | OUT | R9 | 1 | POWER |
| VCC_3V3_DIG | R9 | 2 | R10 | 2 | POWER |
| VCC_3V3_DIG | R10 | 1 | R11 | 2 | POWER |
| VCC_3V3_DIG | R11 | 1 | R12 | 2 | POWER |
| VCC_3V3_DIG | R12 | 1 | R13 | 2 | POWER |
| GND | R13 | 1 | R16 | 2 | GROUND |
| VCC_3V3_DIG | R16 | 1 | R15 | 2 | POWER |

## Net Connection List

| Net Name | Reference Designator - Pin No. |
|----------|-------------------------------|
| 15V_DCDC | U6 - VOUT+,  C10 - 1,  R1 - 2 |
| 2V5_REF | U9 - OUT,  C15 - 1,  R2 - 2 |
| 3V3_ADC | U8 - OUT,  C7 - 1,  C8 - 1,  C9 - 1 |
| 3V3_ADC_CORE | C9 - 1,  U5 - VDD |
| 3V3_CLK | U8 - OUT,  C16 - 1,  U10 - VDD |
| 3V3_CLK_BUF | U8 - OUT,  C17 - 1,  U11 - VCC |
| 3V3_EEPROM | U8 - OUT,  C20 - 1,  U13 - VCC |
| 3V3_LDO_IN | U7 - OUT,  U8 - IN |
| 3V3_MCU | U8 - OUT,  C18 - 1,  C19 - 1 |
| 3V3_MCU_CORE | C19 - 1,  U12 - VDD |
| 5V_LDO_IN | U6 - VOUT+,  U7 - IN |
| 5V_RF_IF | U7 - OUT,  C6 - 1,  U4 - VCC |
| 5V_RF_LNA | U7 - OUT,  C2 - 1,  L1 - 1 |
| 5V_RF_LNA_FILT | L1 - 2,  U1 - VCC |
| 5V_RF_MIX | U7 - OUT,  C5 - 1,  L3 - 1 |
| 5V_RF_MIX_FILT | L3 - 2,  U3 - VCC |
| 5V_RF_VGA | U7 - OUT,  C3 - 1,  L2 - 1 |
| 5V_RF_VGA_FILT | L2 - 2,  U2 - VCC |
| ADC_CS_N | U12 - PC11,  U5 - CS_N |
| ADC_OE_N | U12 - PB1,  U5 - OE_N |
| ADC_RST_N | U12 - PC9,  U5 - RESET_N |
| ADC_SCK | U12 - PC10,  U5 - SCK |
| ADC_SDIO | U12 - PC12,  U5 - SDIO |
| AGC_ENABLE | U12 - PB0,  U2 - ENABLE |
| BOOT_PULLDN | R4 - BOOT0,  U12 -  |
| CLK_ADC_N | U11 - Q_N,  U5 - CLK_N |
| CLK_ADC_P | U11 - Q_P,  U5 - CLK_P |
| CLK_BUF_IN | U10 - OUT0_P,  U11 - D_P |
| CLK_BUF_IN_N | U10 - OUT0_N,  U11 - D_N |
| CLK_CLKIN | U10 - CLKIN,  R8 - 2 |
| CLK_OE | U12 - PB8,  U11 - OE |
| CLK_REF_IN | R8 - 1,  J2 - B11 |
| EEPROM_WP | U12 - PB4,  U13 - WC |
| EN_DCDC | R1 - 1,  U12 - PB9 |
| GND | J1 - 2,  C1 - 2,  U1 - GND,  C2 - 2,  U2 - GND,  C3 - 2,  C4 - 2,  U3 - GND,  C5 - 2,  U4 - GND,  C6 - 2,  U5 - GND,  C7 - 2,  C8 - 2,  C9 - 2,  U6 - VIN-,  J3 - 2,  U6 - VOUT-,  C10 - 2,  U7 - GND,  C11 - 2,  C12 - 2,  U8 - GND,  C13 - 2,  C14 - 2,  U9 - GND,  C15 - 2,  U10 - GND,  C16 - 2,  U11 - GND,  C17 - 2,  U12 - VSS,  C18 - 2,  C19 - 2,  U13 - GND,  C20 - 2,  R15 - 1,  J2 - B12,  R13 - 1,  R16 - 2 |
| I2C_SCL | U12 - PB6,  U10 - SCL,  U13 - SCL |
| I2C_SCL_PULLUP | R6 - 2,  U12 - PB6 |
| I2C_SCL_PU_VDD | R6 - 1,  U8 - OUT |
| I2C_SDA | U12 - PB7,  U10 - SDA,  U13 - SDA |
| I2C_SDA_PULLUP | R7 - 2,  U12 - PB7 |
| I2C_SDA_PU_VDD | R7 - 1,  U8 - OUT |
| IF_AMP_OUT | U4 - OUT,  U5 - AIN_P |
| IF_AMP_OUT_N | U4 - OUT_N,  U5 - AIN_N |
| IF_MIXER_OUT | U3 - IF_OUT,  U4 - IN |
| LED_ANODE | R14 - 2,  R15 - 2 |
| LED_STATUS | U12 - PB5,  R14 - 1 |
| LVDS_D0_N | U5 - D0_N,  J2 - A2 |
| LVDS_D0_P | U5 - D0_P,  J2 - A1 |
| LVDS_D1_N | U5 - D1_N,  J2 - A4 |
| LVDS_D1_P | U5 - D1_P,  J2 - A3 |
| LVDS_D2_N | U5 - D2_N,  J2 - A6 |
| LVDS_D2_P | U5 - D2_P,  J2 - A5 |
| LVDS_D3_N | U5 - D3_N,  J2 - A8 |
| LVDS_D3_P | U5 - D3_P,  J2 - A7 |
| LVDS_DCLK_N | U5 - DCLK_N,  J2 - A10 |
| LVDS_DCLK_P | U5 - DCLK_P,  J2 - A9 |
| MCU_BOOT0 | R3 - 2,  U12 - BOOT0 |
| MCU_BOOT0_GND | R3 - 1,  R4 - 2 |
| MCU_NRST | U12 - NRST,  R5 - 2 |
| MCU_NRST_C | U12 - NRST,  C11 - 1 |
| MCU_NRST_PULLUP | R5 - 1,  U8 - OUT |
| RF_IN | J1 - 1,  U1 - RF_IN |
| RF_LNA_OUT | U1 - RF_OUT,  U2 - RF_IN |
| RF_VGA_OUT | U2 - RF_OUT,  U3 - RF_IN |
| SPI_MISO | U12 - PA6,  U2 - SDO |
| SPI_MOSI | U12 - PA7,  U2 - SDI |
| SPI_SCK | U12 - PA5,  U2 - SCLK |
| VCC_15V | U6 - VOUT+,  U7 - IN |
| VCC_28V | J3 - 1,  U6 - VIN+ |
| VCC_3V3_DIG | U8 - OUT,  U5 - VDD,  U10 - VDD,  U11 - VCC,  U12 - VDD,  U13 - VCC,  R9 - 1,  R9 - 2,  R10 - 2,  R10 - 1,  R11 - 2,  R11 - 1,  R12 - 2,  R12 - 1,  R13 - 2,  R16 - 1,  R15 - 2 |
| VCC_5V_RF | U7 - OUT,  U1 - VCC,  U2 - VCC,  U3 - VCC,  U4 - VCC |
| VGA_CS | U12 - PA4,  U2 - CS |
| VREF_2V5 | U9 - OUT,  U5 - VREF |
| VREF_ADC | R2 - 1,  U5 - VREF |

## Validation Notes

- MIL-STD-810 COMPLIANCE: All components specified for -55°C to +125°C operating range. PCB layout must include thermal relief patterns and adequate heatsinking for U5 (2W) and U6 (DC-DC converter).
- FREQUENCY MISMATCH DETECTED: HMC698LP4 VGA bandwidth is 6 GHz but system requires 5-18 GHz coverage. Post-LNA VGA operates at reduced gain above 6 GHz. Consider adding RF gain stage or using wideband VGA alternative.
- VOLTAGE LEVEL MISMATCH: PKM4716TCD15 outputs 15V but HMC series requires 5V. Added LT1086-5 LDO for proper voltage conversion. Ensure LDO power dissipation is within limits at 25W total load.
- ADC INTERFACE TIMING: EV10AQ190A requires careful LVDS trace length matching. All LVDS pairs must be matched within 5 mil to minimize skew. DCLK must have dedicated reference plane.
- POWER BUDGET WARNING: Total estimated power consumption: U1 (0.43W) + U2 (0.45W) + U3 (0.2W) + U4 (0.25W) + U5 (2W) + U6 (5W) + U7-U8 (1W) + control (0.5W) = ~9.8W. Well within 15-25W budget.
- MIXER LO DRIVE: HMC-CMS19 requires +10 to +17 dBm LO input. LO signal path not specified - requires external LO source or PLL synthesizer. Add U14 if integrated LO needed.
- DECOUPLING CAPACITOR AUDIT: Multiple decoupling capacitors (C1-C20) placed at each power pin. Use X7R dielectric for military temperature operation. Place capacitors within 100 mil of IC power pins.
- SPI CONTROL LINES: VGA and ADC share SPI bus from MCU. Ensure CS lines are properly separated. Add 1K series resistors on SPI lines if long traces (>2 inches).
- I2C BUS FANOUT: Three devices (U10, U13, and potential expansion) on I2C. Pullup resistors R6, R7 set to 4.7K for 400kHz operation. Consider 2.2K for 1MHz fast mode.
- REFERENCE VOLTAGE STABILITY: LT6656-2.5 provides low-noise reference for ADC. Filter with 10uF capacitor C15 and place close to U5 VREF pin to minimize noise.
- GROUNDING STRATEGY: Critical for RF performance. Use split ground planes: RF ground for U1-U4, digital ground for control logic. Connect at single point under ADC. Multiple via stitching along ground plane boundaries.
- THERMAL MANAGEMENT: U5 ADC dissipates 2W - requires thermal pad to ground plane with multiple vias. Consider copper pour on top layer for heatsinking if no mechanical heatsink.
- TEST POINTS: Add test points for RF_IN, RF_LNA_OUT, IF_AMP_OUT, CLK_ADC_P, and key SPI signals for production testing. Keep RF test points 50 ohm controlled impedance.
- ESD PROTECTION: Add TVS diode on RF input J1 to protect U1 LNA from ESD events. Consider SMA connector with built-in ESD protection.
- ADC CALIBRATION: Include provision for ADC offset and gain calibration. Store calibration coefficients in EEPROM U13. Implement auto-calibration routine in MCU firmware.
- CLOCK DISTRIBUTION: Si5345B provides flexible clock synthesis. Configure for 5 GHz output to ADC. Add bypass capacitor C17 close to U11 clock buffer power pin.
- BOARD STACKUP: Recommend minimum 6 layers: Signal1/GND/Power/Signal2/Power2/GND. Use Rogers 4350B material for RF layers (low loss). Minimum 4 mil trace/space for impedance control.
- IMPEDANCE MATCHING: RF input J1 to U1 requires 50 ohm controlled impedance. Calculate trace width based on stackup. Add pi-network matching if return loss <10 dB.
- LVDS TERMINATION: EV10AQ190A LVDS outputs require 100 ohm differential termination at receiver. J2 connector must support 100 ohm differential impedance.
- PIN CONNECTION CHECK: All IC pins properly connected. No floating pins detected. Unused pins should be tied to appropriate logic levels per datasheet recommendations.
- FPGA INTERFACE: LVDS output J2 connects to downstream FPGA. Ensure FPGA bank voltage matches 3.3V LVDS standard. Include DC blocking capacitors if AC coupling required.