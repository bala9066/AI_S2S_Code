# Logical Netlist
## rf tx

## Block Diagram

```mermaid
graph TB
    U1[HMC1049LP3E (HMC1049LP3E)]
    U2[HMC1052LP4GE (HMC1052LP4GE)]
    U3[HMC830LP6GE (HMC830LP6GE)]
    U4[HMC698LP4 (HMC698LP4)]
    U5[ADC12J4000 (ADC12J4000)]
    U6[XC7A35T-FTG256 (XC7A35T-FTG256)]
    U7[STM32F407VGT6 (STM32F407VGT6)]
    U8[TPS54340 (TPS54340)]
    U9[LT3045-3.3 (LT3045-3.3)]
    J1[SMA-F-EDGE (SMA-F-EDGE-18GHz)]
    J2[UART-HEADER (HDR-4POS-TH)]
    J3[POWER-CONN (TB-2POS-5.08mm)]
    L1[FERRITE_BEAD (BLM18PG471SN1D)]
    L2[FERRITE_BEAD (BLM18PG471SN1D)]
    L3[INDUCTOR_4.7UH (74404047047)]
    L4[INDUCTOR_10UH (74404010047)]
    C1[CAP_100PF (GRM1555C1H101JA01)]
    C2[CAP_1000PF (GRM1555C1H102JA01)]
    C3[CAP_0.1UF (GRM155R71C104KA88)]
    C4[CAP_10UF (GRM21BR61C106KE15)]
    C5[CAP_0.1UF (GRM155R71C104KA88)]
    C6[CAP_10UF (GRM21BR61C106KE15)]
    C7[CAP_0.1UF (GRM155R71C104KA88)]
    C8[CAP_10UF (GRM21BR61C106KE15)]
    C9[CAP_10UF (GRM21BR61C106KE15)]
    C10[CAP_0.1UF (GRM155R71C104KA88)]
    C11[CAP_10UF (GRM21BR61C106KE15)]
    C12[CAP_10UF (GRM21BR61C106KE15)]
    C13[CAP_0.1UF (GRM155R71C104KA88)]
    C14[CAP_22UF (GRM32ER71A226KE15)]
    C15[CAP_0.1UF (GRM155R71C104KA88)]
    C16[CAP_10UF (GRM21BR61C106KE15)]
    C17[CAP_100PF (GRM1555C1H101JA01)]
    C18[CAP_100PF (GRM1555C1H101JA01)]
    C19[CAP_0.01UF (GRM1555C1H103JA01)]
    C20[CAP_10UF (GRM21BR61C106KE15)]
    C21[CAP_47UF (EEEFK1H470AP)]
    R1[RES_49.9OHM (RC0805FR-0749R9L)]
    R2[RES_10K (RC0805FR-0710KL)]
    R3[RES_10K (RC0805FR-0710KL)]
    R4[RES_4.7K (RC0805FR-074K7L)]
    R5[RES_1.5K (RC0805FR-071K5L)]
    R6[RES_1K (RC0805FR-071KL)]
    R7[RES_0OHM (RC0805FR-070Y0)]
    R8[RES_10K (RC0805FR-0710KL)]
    R9[RES_10K (RC0805FR-0710KL)]
    R10[RES_4.7K (RC0805FR-074K7L)]
    R11[RES_200OHM (RC0805FR-07200L)]
    R12[RES_100OHM (RC0805FR-07100L)]
    R13[RES_10K (RC0805FR-0710KL)]
    R14[RES_10K (RC0805FR-0710KL)]
    R15[RES_100K (RC0805FR-07100KL)]
    R16[RES_49.9K (RC0805FR-0749K9L)]
    J1 -->|RF_IN| C1
    C1 -->|RF_IN| U1
    U1 -->|RF_LNA_OUT| C2
    C2 -->|RF_LNA_OUT_C| U2
    U3 -->|LO_OUT| C17
    C17 -->|LO_OUT_C| U2
    U2 -->|IF_OUT| C3
    C3 -->|IF_OUT_C| U4
    U4 -->|IF_VGA_OUT| C5
    C5 -->|IF_VGA_OUT_C| U5
    U4 -->|IF_VGA_OUT_N| C7
    C7 -->|IF_VGA_OUT_N_C| U5
    U5 -->|JESD204B_D_P0| U6
    U5 -->|JESD204B_D_N0| U6
    U5 -->|JESD204B_D_P1| U6
    U5 -->|JESD204B_D_N1| U6
    U5 -->|JESD204B_D_P2| U6
    U5 -->|JESD204B_D_N2| U6
    U5 -->|JESD204B_D_P3| U6
    U5 -->|JESD204B_D_N3| U6
    U5 -->|JESD204B_SYNC_P| U6
    U5 -->|JESD204B_SYNC_N| U6
    U7 -->|VGA_SPI_SCLK| U4
    U7 -->|VGA_SPI_SDI| U4
    U7 -->|VGA_SPI_CS| U4
    U7 -->|VGA_LE| U4
    U7 -->|LO_SPI_SCLK| U3
    U7 -->|LO_SPI_SDI| U3
    U7 -->|LO_SPI_SDO| U3
    U7 -->|LO_SPI_CS| U3
    U7 -->|UART_TX| J2
    U7 -->|UART_RX| J2
    U7 -->|MCU_FPGA_SPI_SCLK| U6
    U7 -->|MCU_FPGA_SPI_MOSI| U6
    U7 -->|MCU_FPGA_SPI_MISO| U6
    U7 -->|MCU_FPGA_SPI_CS| U6
    U7 -->|FPGA_RESET_N| U6
    U7 -->|FPGA_DONE| U6
    U6 -->|ADC_CLK_P| U5
    U6 -->|ADC_CLK_N| U5
    U6 -->|ADC_CS_N| U5
    L1 -->|+5V| C3
    C3 -->|+5V| C4
    C4 -->|+5V| U1
    U1 -->|+5V| U1
    U1 -->|+5V| U1
    U1 -->|+5V| R1
    L1 -->|+5V_RF| C5
    C5 -->|+5V_RF| C6
    C6 -->|+5V_RF| U2
    U2 -->|+5V_RF| R2
    R2 -->|+5V_RF| R3
    L2 -->|+3V3_DIG| C10
    C10 -->|+3V3_DIG| C11
    C11 -->|+3V3_DIG| U3
    U3 -->|+3V3_DIG| U7
    U7 -->|+3V3_DIG| R8
    R8 -->|+3V3_DIG| R9
    R9 -->|+3V3_DIG| R10
    R10 -->|+3V3_DIG| R11
    R11 -->|+3V3_DIG| U7
    U7 -->|+3V3_DIG| U6
    U6 -->|+3V3_DIG| U6
    U6 -->|+3V3_DIG| C15
    C15 -->|+3V3_DIG| C16
    U8 -->|SW_5V| L3
    L3 -->|SW_5V| L1
    U8 -->|SW_3V3| L4
    L4 -->|SW_3V3| U9
    J3 -->|+12V_IN| C21
    C21 -->|+12V_IN| U8
    U9 -->|+3V3_OUT| L2
    J1 -->|GND| U1
    U1 -->|GND| C1
    C1 -->|GND| C2
    C2 -->|GND| C3
    C3 -->|GND| C4
    C4 -->|GND| C5
    C5 -->|GND| C6
    C6 -->|GND| C7
    C7 -->|GND| U2
    U2 -->|GND| U2
    U2 -->|GND| U2
    U2 -->|GND| U2
    U2 -->|GND| C8
    C8 -->|GND| C9
    C9 -->|GND| C10
    C10 -->|GND| C11
    C11 -->|GND| U3
    U3 -->|GND| C12
    C12 -->|GND| U4
    U4 -->|GND| U4
    U4 -->|GND| U4
    U4 -->|GND| C13
    C13 -->|GND| C14
    C14 -->|GND| C15
    C15 -->|GND| C16
    C16 -->|GND| U5
    U5 -->|GND| C17
    C17 -->|GND| C18
    C18 -->|GND| U6
    U6 -->|GND| U7
    U7 -->|GND| C19
    C19 -->|GND| C20
    C20 -->|GND| U8
    U8 -->|GND| U9
    U9 -->|GND| J2
    J2 -->|GND| J3
    U7 -->|LNA_ENABLE| R1
    R1 -->|LNA_ENABLE_N| U1
    R2 -->|MIXER_EN| U2
    U7 -->|MIXER_EN| R2
    R3 -->|VGA_SHDN| U2
    U7 -->|VGA_SHDN| R3
    U3 -->|LO_MUXOUT| R4
    R4 -->|LO_MUXOUT_PULL| R5
    R5 -->|LO_MUXOUT_PULL| U7
    U4 -->|VGA_VREF| C8
    C8 -->|VGA_VREF| C9
    U5 -->|ADC_REF_P| C12
    U5 -->|ADC_REF_N| C12
    U5 -->|ADC_VCM| C13
    C13 -->|ADC_VCM| C14
    U7 -->|LO_SYNC| U3
    U3 -->|LO_LD| R6
    R6 -->|LO_LD_PULL| U7
    U4 -->|VGA_CLK| R7
    R7 -->|VGA_CLK_IN| U7
    R8 -->|MCU_NRST| U7
    R9 -->|MCU_BOOT0| U7
    R10 -->|MCU_BOOT1| U7
    R11 -->|MCU_VREF| U7
    U7 -->|MCU_VREF_CAP| C19
    U7 -->|OSC32_IN| R12
    U7 -->|OSC32_OUT| R12
    U7 -->|OSC_HSE_IN| R13
    U7 -->|OSC_HSE_OUT| R13
    U7 -->|USB_DM| R14
    U7 -->|USB_DP| R14
    U7 -->|SWD_IO| R15
    U7 -->|SWD_CLK| R15
    U6 -->|FPGA_TCK| R16
    U6 -->|FPGA_TDI| R16
    U6 -->|FPGA_TDO| R16
    U6 -->|FPGA_TMS| R16
```

## Component Instances

| Ref | Part Number | Component |
|---|---|---|
| U1 | HMC1049LP3E | HMC1049LP3E |
| U2 | HMC1052LP4GE | HMC1052LP4GE |
| U3 | HMC830LP6GE | HMC830LP6GE |
| U4 | HMC698LP4 | HMC698LP4 |
| U5 | ADC12J4000 | ADC12J4000 |
| U6 | XC7A35T-FTG256 | XC7A35T-FTG256 |
| U7 | STM32F407VGT6 | STM32F407VGT6 |
| U8 | TPS54340 | TPS54340 |
| U9 | LT3045-3.3 | LT3045-3.3 |
| J1 | SMA-F-EDGE-18GHz | SMA-F-EDGE |
| J2 | HDR-4POS-TH | UART-HEADER |
| J3 | TB-2POS-5.08mm | POWER-CONN |
| L1 | BLM18PG471SN1D | FERRITE_BEAD |
| L2 | BLM18PG471SN1D | FERRITE_BEAD |
| L3 | 74404047047 | INDUCTOR_4.7UH |
| L4 | 74404010047 | INDUCTOR_10UH |
| C1 | GRM1555C1H101JA01 | CAP_100PF |
| C2 | GRM1555C1H102JA01 | CAP_1000PF |
| C3 | GRM155R71C104KA88 | CAP_0.1UF |
| C4 | GRM21BR61C106KE15 | CAP_10UF |
| C5 | GRM155R71C104KA88 | CAP_0.1UF |
| C6 | GRM21BR61C106KE15 | CAP_10UF |
| C7 | GRM155R71C104KA88 | CAP_0.1UF |
| C8 | GRM21BR61C106KE15 | CAP_10UF |
| C9 | GRM21BR61C106KE15 | CAP_10UF |
| C10 | GRM155R71C104KA88 | CAP_0.1UF |
| C11 | GRM21BR61C106KE15 | CAP_10UF |
| C12 | GRM21BR61C106KE15 | CAP_10UF |
| C13 | GRM155R71C104KA88 | CAP_0.1UF |
| C14 | GRM32ER71A226KE15 | CAP_22UF |
| C15 | GRM155R71C104KA88 | CAP_0.1UF |
| C16 | GRM21BR61C106KE15 | CAP_10UF |
| C17 | GRM1555C1H101JA01 | CAP_100PF |
| C18 | GRM1555C1H101JA01 | CAP_100PF |
| C19 | GRM1555C1H103JA01 | CAP_0.01UF |
| C20 | GRM21BR61C106KE15 | CAP_10UF |
| C21 | EEEFK1H470AP | CAP_47UF |
| R1 | RC0805FR-0749R9L | RES_49.9OHM |
| R2 | RC0805FR-0710KL | RES_10K |
| R3 | RC0805FR-0710KL | RES_10K |
| R4 | RC0805FR-074K7L | RES_4.7K |
| R5 | RC0805FR-071K5L | RES_1.5K |
| R6 | RC0805FR-071KL | RES_1K |
| R7 | RC0805FR-070Y0 | RES_0OHM |
| R8 | RC0805FR-0710KL | RES_10K |
| R9 | RC0805FR-0710KL | RES_10K |
| R10 | RC0805FR-074K7L | RES_4.7K |
| R11 | RC0805FR-07200L | RES_200OHM |
| R12 | RC0805FR-07100L | RES_100OHM |
| R13 | RC0805FR-0710KL | RES_10K |
| R14 | RC0805FR-0710KL | RES_10K |
| R15 | RC0805FR-07100KL | RES_100K |
| R16 | RC0805FR-0749K9L | RES_49.9K |

## Pin-to-Pin Connections

| Net | From | Pin | To | Pin | Type |
|---|---|---|---|---|---|
| RF_IN | J1 | SIG | C1 | 1 | RF |
| RF_IN | C1 | 2 | U1 | 1 | RF |
| RF_LNA_OUT | U1 | 4 | C2 | 1 | RF |
| RF_LNA_OUT_C | C2 | 2 | U2 | 1 | RF |
| LO_OUT | U3 | RFOUT | C17 | 1 | RF |
| LO_OUT_C | C17 | 2 | U2 | 8 | RF |
| IF_OUT | U2 | 5 | C3 | 1 | IF |
| IF_OUT_C | C3 | 2 | U4 | 1 | IF |
| IF_VGA_OUT | U4 | 8 | C5 | 1 | IF |
| IF_VGA_OUT_C | C5 | 2 | U5 | A_IN_P | ANALOG |
| IF_VGA_OUT_N | U4 | 7 | C7 | 1 | ANALOG |
| IF_VGA_OUT_N_C | C7 | 2 | U5 | A_IN_N | ANALOG |
| JESD204B_D_P0 | U5 | D0_P | U6 | C_P | HIGH_SPEED_DIGITAL |
| JESD204B_D_N0 | U5 | D0_N | U6 | C_N | HIGH_SPEED_DIGITAL |
| JESD204B_D_P1 | U5 | D1_P | U6 | D_P | HIGH_SPEED_DIGITAL |
| JESD204B_D_N1 | U5 | D1_N | U6 | D_N | HIGH_SPEED_DIGITAL |
| JESD204B_D_P2 | U5 | D2_P | U6 | E_P | HIGH_SPEED_DIGITAL |
| JESD204B_D_N2 | U5 | D2_N | U6 | E_N | HIGH_SPEED_DIGITAL |
| JESD204B_D_P3 | U5 | D3_P | U6 | F_P | HIGH_SPEED_DIGITAL |
| JESD204B_D_N3 | U5 | D3_N | U6 | F_N | HIGH_SPEED_DIGITAL |
| JESD204B_SYNC_P | U5 | SYNC_P | U6 | G_P | DIGITAL |
| JESD204B_SYNC_N | U5 | SYNC_N | U6 | G_N | DIGITAL |
| VGA_SPI_SCLK | U7 | PA5 | U4 | SCLK | SPI |
| VGA_SPI_SDI | U7 | PA7 | U4 | SDI | SPI |
| VGA_SPI_CS | U7 | PA4 | U4 | CS | SPI |
| VGA_LE | U7 | PA6 | U4 | LE | DIGITAL |
| LO_SPI_SCLK | U7 | PB13 | U3 | SCLK | SPI |
| LO_SPI_SDI | U7 | PB15 | U3 | SDI | SPI |
| LO_SPI_SDO | U7 | PB14 | U3 | SDO | SPI |
| LO_SPI_CS | U7 | PB12 | U3 | CS | SPI |
| UART_TX | U7 | PA9 | J2 | 3 | UART |
| UART_RX | U7 | PA10 | J2 | 2 | UART |
| MCU_FPGA_SPI_SCLK | U7 | PB3 | U6 | H_P | SPI |
| MCU_FPGA_SPI_MOSI | U7 | PB5 | U6 | K_P | SPI |
| MCU_FPGA_SPI_MISO | U7 | PB4 | U6 | J_P | SPI |
| MCU_FPGA_SPI_CS | U7 | PA15 | U6 | L_P | SPI |
| FPGA_RESET_N | U7 | PC4 | U6 | PROG_B | RESET |
| FPGA_DONE | U7 | PC5 | U6 | DONE | STATUS |
| ADC_CLK_P | U6 | M_P | U5 | CLK_P | CLOCK |
| ADC_CLK_N | U6 | M_N | U5 | CLK_N | CLOCK |
| ADC_CS_N | U6 | N_P | U5 | CS_N | SPI |
| +5V | L1 | 2 | C3 | 1 | POWER |
| +5V | C3 | 1 | C4 | 1 | POWER |
| +5V | C4 | 1 | U1 | VCC | POWER |
| +5V | U1 | VCC | U1 | 2 | POWER |
| +5V | U1 | 3 | U1 |  | POWER |
| +5V | U1 | 3 | R1 | 1 | POWER |
| +5V_RF | L1 | 2 | C5 | 1 | POWER |
| +5V_RF | C5 | 1 | C6 | 1 | POWER |
| +5V_RF | C6 | 1 | U2 | VCC | POWER |
| +5V_RF | U2 | VCC | R2 | 1 | POWER |
| +5V_RF | R2 | 1 | R3 | 1 | POWER |
| +3V3_DIG | L2 | 2 | C10 | 1 | POWER |
| +3V3_DIG | C10 | 1 | C11 | 1 | POWER |
| +3V3_DIG | C11 | 1 | U3 | VCC | POWER |
| +3V3_DIG | U3 | VCC | U7 | VDD | POWER |
| +3V3_DIG | U7 | VDD | R8 | 1 | POWER |
| +3V3_DIG | R8 | 1 | R9 | 1 | POWER |
| +3V3_DIG | R9 | 1 | R10 | 1 | POWER |
| +3V3_DIG | R10 | 1 | R11 | 1 | POWER |
| +3V3_DIG | R11 | 1 | U7 | BOOT0 | POWER |
| +3V3_DIG | U7 | BOOT0 | U6 | VCCINT | POWER |
| +3V3_DIG | U6 | VCCINT | U6 | VCCAUX | POWER |
| +3V3_DIG | U6 | VCCAUX | C15 | 1 | POWER |
| +3V3_DIG | C15 | 1 | C16 | 1 | POWER |
| SW_5V | U8 | SW | L3 | 1 | POWER |
| SW_5V | L3 | 2 | L1 | 1 | POWER |
| SW_3V3 | U8 | FB | L4 | 1 | POWER |
| SW_3V3 | L4 | 2 | U9 | IN | POWER |
| +12V_IN | J3 | 1 | C21 | 1 | POWER |
| +12V_IN | C21 | 1 | U8 | VIN | POWER |
| +3V3_OUT | U9 | OUT | L2 | 1 | POWER |
| GND | J1 | GND | U1 | 5 | GROUND |
| GND | U1 | 5 | C1 | 1 | GROUND |
| GND | C1 | 1 | C2 | 1 | GROUND |
| GND | C2 | 1 | C3 | 2 | GROUND |
| GND | C3 | 2 | C4 | 2 | GROUND |
| GND | C4 | 2 | C5 | 2 | GROUND |
| GND | C5 | 2 | C6 | 2 | GROUND |
| GND | C6 | 2 | C7 | 2 | GROUND |
| GND | C7 | 2 | U2 | 3 | GROUND |
| GND | U2 | 3 | U2 | 4 | GROUND |
| GND | U2 | 4 | U2 | 6 | GROUND |
| GND | U2 | 6 | U2 | EPAD | GROUND |
| GND | U2 | EPAD | C8 | 2 | GROUND |
| GND | C8 | 2 | C9 | 2 | GROUND |
| GND | C9 | 2 | C10 | 2 | GROUND |
| GND | C10 | 2 | C11 | 2 | GROUND |
| GND | C11 | 2 | U3 | GND | GROUND |
| GND | U3 | GND | C12 | 2 | GROUND |
| GND | C12 | 2 | U4 | 6 | GROUND |
| GND | U4 | 6 | U4 | 9 | GROUND |
| GND | U4 | 9 | U4 | 10 | GROUND |
| GND | U4 | 10 | C13 | 2 | GROUND |
| GND | C13 | 2 | C14 | 2 | GROUND |
| GND | C14 | 2 | C15 | 2 | GROUND |
| GND | C15 | 2 | C16 | 2 | GROUND |
| GND | C16 | 2 | U5 | GND | GROUND |
| GND | U5 | GND | C17 | 2 | GROUND |
| GND | C17 | 2 | C18 | 2 | GROUND |
| GND | C18 | GND | U6 |  | GROUND |
| GND | U6 | VSS | U7 |  | GROUND |
| GND | U7 | VSS | C19 | 2 | GROUND |
| GND | C19 | 2 | C20 | 2 | GROUND |
| GND | C20 | GND | U8 |  | GROUND |
| GND | U8 | GND | U9 |  | GROUND |
| GND | U9 | GND | J2 | 1 | GROUND |
| GND | J2 | 2 | J3 |  | GROUND |
| LNA_ENABLE | U7 | PC0 | R1 | 2 | DIGITAL |
| LNA_ENABLE_N | R1 | 2 | U1 | 6 | DIGITAL |
| MIXER_EN | R2 | 2 | U2 | 7 | DIGITAL |
| MIXER_EN | U7 | PC1 | R2 | 2 | DIGITAL |
| VGA_SHDN | R3 | 2 | U2 | 2 | DIGITAL |
| VGA_SHDN | U7 | PC2 | R3 | 2 | DIGITAL |
| LO_MUXOUT | U3 | MUXOUT | R4 | 1 | DIGITAL |
| LO_MUXOUT_PULL | R4 | 2 | R5 | 1 | DIGITAL |
| LO_MUXOUT_PULL | R5 | 2 | U7 | PC3 | DIGITAL |
| VGA_VREF | U4 | 5 | C8 | 1 | ANALOG |
| VGA_VREF | C8 | 1 | C9 | 1 | ANALOG |
| ADC_REF_P | U5 | REF_P | C12 | 1 | ANALOG |
| ADC_REF_N | U5 | REF_N | C12 | 1 | ANALOG |
| ADC_VCM | U5 | VCM | C13 | 1 | ANALOG |
| ADC_VCM | C13 | 1 | C14 | 1 | ANALOG |
| LO_SYNC | U7 | PC6 | U3 | SYNC_IN | DIGITAL |
| LO_LD | U3 | LD | R6 | 1 | STATUS |
| LO_LD_PULL | R6 | 2 | U7 | PC7 | STATUS |
| VGA_CLK | U4 | CLK | R7 | 1 | CLOCK |
| VGA_CLK_IN | R7 | PB1 | U7 |  | CLOCK |
| MCU_NRST | R8 | 2 | U7 | NRST | RESET |
| MCU_BOOT0 | R9 | 2 | U7 | BOOT0 | DIGITAL |
| MCU_BOOT1 | R10 | 2 | U7 | BOOT1 | DIGITAL |
| MCU_VREF | R11 | 2 | U7 | VREF+ | ANALOG |
| MCU_VREF_CAP | U7 | VREF+ | C19 | 1 | ANALOG |
| OSC32_IN | U7 | PC14 | R12 | 1 | CLOCK |
| OSC32_OUT | U7 | 1 | R12 |  | CLOCK |
| OSC_HSE_IN | U7 | PH0 | R13 | 1 | CLOCK |
| OSC_HSE_OUT | U7 | 1 | R13 |  | CLOCK |
| USB_DM | U7 | PA11 | R14 | 1 | USB |
| USB_DP | U7 | 1 | R14 |  | USB |
| SWD_IO | U7 | PA13 | R15 | 1 | DEBUG |
| SWD_CLK | U7 | 1 | R15 |  | DEBUG |
| FPGA_TCK | U6 | TCK | R16 | 1 | JTAG |
| FPGA_TDI | U6 | 1 | R16 |  | JTAG |
| FPGA_TDO | U6 | 1 | R16 |  | JTAG |
| FPGA_TMS | U6 | 1 | R16 |  | JTAG |

## Net Connection List

| Net Name | Reference Designator - Pin No. |
|----------|-------------------------------|
| +12V_IN | J3 - 1,  C21 - 1,  U8 - VIN |
| +3V3_DIG | L2 - 2,  C10 - 1,  C11 - 1,  U3 - VCC,  U7 - VDD,  R8 - 1,  R9 - 1,  R10 - 1,  R11 - 1,  U7 - BOOT0,  U6 - VCCINT,  U6 - VCCAUX,  C15 - 1,  C16 - 1 |
| +3V3_OUT | U9 - OUT,  L2 - 1 |
| +5V | L1 - 2,  C3 - 1,  C4 - 1,  U1 - VCC,  U1 - 2,  U1 - 3,  U1 - ,  R1 - 1 |
| +5V_RF | L1 - 2,  C5 - 1,  C6 - 1,  U2 - VCC,  R2 - 1,  R3 - 1 |
| ADC_CLK_N | U6 - M_N,  U5 - CLK_N |
| ADC_CLK_P | U6 - M_P,  U5 - CLK_P |
| ADC_CS_N | U6 - N_P,  U5 - CS_N |
| ADC_REF_N | U5 - REF_N,  C12 - 1 |
| ADC_REF_P | U5 - REF_P,  C12 - 1 |
| ADC_VCM | U5 - VCM,  C13 - 1,  C14 - 1 |
| FPGA_DONE | U7 - PC5,  U6 - DONE |
| FPGA_RESET_N | U7 - PC4,  U6 - PROG_B |
| FPGA_TCK | U6 - TCK,  R16 - 1 |
| FPGA_TDI | U6 - 1,  R16 -  |
| FPGA_TDO | U6 - 1,  R16 -  |
| FPGA_TMS | U6 - 1,  R16 -  |
| GND | J1 - GND,  U1 - 5,  C1 - 1,  C2 - 1,  C3 - 2,  C4 - 2,  C5 - 2,  C6 - 2,  C7 - 2,  U2 - 3,  U2 - 4,  U2 - 6,  U2 - EPAD,  C8 - 2,  C9 - 2,  C10 - 2,  C11 - 2,  U3 - GND,  C12 - 2,  U4 - 6,  U4 - 9,  U4 - 10,  C13 - 2,  C14 - 2,  C15 - 2,  C16 - 2,  U5 - GND,  C17 - 2,  C18 - 2,  C18 - GND,  U6 - ,  U6 - VSS,  U7 - ,  U7 - VSS,  C19 - 2,  C20 - 2,  C20 - GND,  U8 - ,  U8 - GND,  U9 - ,  U9 - GND,  J2 - 1,  J2 - 2,  J3 -  |
| IF_OUT | U2 - 5,  C3 - 1 |
| IF_OUT_C | C3 - 2,  U4 - 1 |
| IF_VGA_OUT | U4 - 8,  C5 - 1 |
| IF_VGA_OUT_C | C5 - 2,  U5 - A_IN_P |
| IF_VGA_OUT_N | U4 - 7,  C7 - 1 |
| IF_VGA_OUT_N_C | C7 - 2,  U5 - A_IN_N |
| JESD204B_D_N0 | U5 - D0_N,  U6 - C_N |
| JESD204B_D_N1 | U5 - D1_N,  U6 - D_N |
| JESD204B_D_N2 | U5 - D2_N,  U6 - E_N |
| JESD204B_D_N3 | U5 - D3_N,  U6 - F_N |
| JESD204B_D_P0 | U5 - D0_P,  U6 - C_P |
| JESD204B_D_P1 | U5 - D1_P,  U6 - D_P |
| JESD204B_D_P2 | U5 - D2_P,  U6 - E_P |
| JESD204B_D_P3 | U5 - D3_P,  U6 - F_P |
| JESD204B_SYNC_N | U5 - SYNC_N,  U6 - G_N |
| JESD204B_SYNC_P | U5 - SYNC_P,  U6 - G_P |
| LNA_ENABLE | U7 - PC0,  R1 - 2 |
| LNA_ENABLE_N | R1 - 2,  U1 - 6 |
| LO_LD | U3 - LD,  R6 - 1 |
| LO_LD_PULL | R6 - 2,  U7 - PC7 |
| LO_MUXOUT | U3 - MUXOUT,  R4 - 1 |
| LO_MUXOUT_PULL | R4 - 2,  R5 - 1,  R5 - 2,  U7 - PC3 |
| LO_OUT | U3 - RFOUT,  C17 - 1 |
| LO_OUT_C | C17 - 2,  U2 - 8 |
| LO_SPI_CS | U7 - PB12,  U3 - CS |
| LO_SPI_SCLK | U7 - PB13,  U3 - SCLK |
| LO_SPI_SDI | U7 - PB15,  U3 - SDI |
| LO_SPI_SDO | U7 - PB14,  U3 - SDO |
| LO_SYNC | U7 - PC6,  U3 - SYNC_IN |
| MCU_BOOT0 | R9 - 2,  U7 - BOOT0 |
| MCU_BOOT1 | R10 - 2,  U7 - BOOT1 |
| MCU_FPGA_SPI_CS | U7 - PA15,  U6 - L_P |
| MCU_FPGA_SPI_MISO | U7 - PB4,  U6 - J_P |
| MCU_FPGA_SPI_MOSI | U7 - PB5,  U6 - K_P |
| MCU_FPGA_SPI_SCLK | U7 - PB3,  U6 - H_P |
| MCU_NRST | R8 - 2,  U7 - NRST |
| MCU_VREF | R11 - 2,  U7 - VREF+ |
| MCU_VREF_CAP | U7 - VREF+,  C19 - 1 |
| MIXER_EN | R2 - 2,  U2 - 7,  U7 - PC1 |
| OSC32_IN | U7 - PC14,  R12 - 1 |
| OSC32_OUT | U7 - 1,  R12 -  |
| OSC_HSE_IN | U7 - PH0,  R13 - 1 |
| OSC_HSE_OUT | U7 - 1,  R13 -  |
| RF_IN | J1 - SIG,  C1 - 1,  C1 - 2,  U1 - 1 |
| RF_LNA_OUT | U1 - 4,  C2 - 1 |
| RF_LNA_OUT_C | C2 - 2,  U2 - 1 |
| SWD_CLK | U7 - 1,  R15 -  |
| SWD_IO | U7 - PA13,  R15 - 1 |
| SW_3V3 | U8 - FB,  L4 - 1,  L4 - 2,  U9 - IN |
| SW_5V | U8 - SW,  L3 - 1,  L3 - 2,  L1 - 1 |
| UART_RX | U7 - PA10,  J2 - 2 |
| UART_TX | U7 - PA9,  J2 - 3 |
| USB_DM | U7 - PA11,  R14 - 1 |
| USB_DP | U7 - 1,  R14 -  |
| VGA_CLK | U4 - CLK,  R7 - 1 |
| VGA_CLK_IN | R7 - PB1,  U7 -  |
| VGA_LE | U7 - PA6,  U4 - LE |
| VGA_SHDN | R3 - 2,  U2 - 2,  U7 - PC2 |
| VGA_SPI_CS | U7 - PA4,  U4 - CS |
| VGA_SPI_SCLK | U7 - PA5,  U4 - SCLK |
| VGA_SPI_SDI | U7 - PA7,  U4 - SDI |
| VGA_VREF | U4 - 5,  C8 - 1,  C9 - 1 |

## Validation Notes

- RF POWER SEQUENCING: LNA (U1) and Mixer (U2) require proper power sequencing. MCU controls enable pins PC0, PC1, PC2. Ensure firmware initializes GPIOs to LOW before enabling +5V_RF rail.
- IMPEDANCE MATCHING: RF trace widths must be calculated for 50Ω microstrip on chosen PCB stackup (5-18 GHz). Consider adding π-networks at U1 input and U2 RF input for fine tuning.
- MIXER LO DRIVE: HMC1052LP4GE requires +10 dBm LO drive. HMC830LP6GE RFOUT is +3 dBm typical. MISSING: Amplifier between U3 and U2 (add HMC361 or similar).
- HIGH-SPEED ADC INTERFACE: JESD204B lane routing requires controlled impedance (100Ω differential) and length matching (±5 mil). Use 4-lane subclass 1 deterministic latency mode.
- VGA SPI TIMING: HMC698LP4 requires 20 ns minimum CS-to-SCLK delay. Ensure STM32F407 SPI clock ≤ 10 MHz with appropriate delays.
- DECOUPLING REQUIREMENTS: Each RF device needs local 0.1 µF and 10 µF capacitors within 100 mils of supply pins. Additional 0.01 µF recommended for HMC1049 at 20 GHz.
- FPGA CONFIGURATION: XC7A35T requires 1.0V VCCINT (not shown). Add 1.0V LDO (TPS62290 or similar) with 200 mA capacity.
- ADC CLOCKING: ADC12J4000 requires low-jitter clock source. Consider adding dedicated clock jitter cleaner (LMK04828) or programmable VCO.
- THERMAL CONSIDERATIONS: U1 (120 mA @ 5V) and U5 (1.2W typical) dissipate significant heat. Add thermal relief vias under QFN EPADs and consider heatsinks.
- UART ISOLATION: For noisy RF environments, consider adding ADUM1201 digital isolator on UART lines to prevent ground loops with host system.
- PIN MAPPING: Several FPGA pins are tentative (C_P, D_P, etc.). Verify XC7A35T pinout and select HP I/O banks for JESD204B lanes (requires 1.8V VCCO).
- MISSING COMPONENTS: (1) 100 MHz reference oscillator for HMC830, (2) LO buffer amplifier for HMC1052, (3) 1.0V FPGA supply rail
- NO FIGURE OF MERIT: System NF = LNA NF (3 dB) + Mixer NF (8 dB) - LNA Gain (20 dB) = -9 dB (theoretical). This exceeds requirements significantly but needs verification.
- IIP3 CHAIN CALCULATION: IIP3 = P1dB_LNA + 10 dB = +25 dBm at input. Meets +10 dBm requirement with margin.
- POWER BUDGET: 5V rail: ~0.6A (LNA + Mixer), 3.3V rail: ~0.5A (MCU + FPGA + LO). Total ~5.7W + conversion losses = ~7W from 12V input. Within 15W limit.