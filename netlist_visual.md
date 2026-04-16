# Logical Netlist
## rbfgf

## Block Diagram

```mermaid
graph TB
    U1[LMC6048 (LMC6048)]
    U2[TGA4538 (TGA4538-SM)]
    U3[HMC698LP4 (HMC698LP4E)]
    U4[ADF5356 (ADF5356CCPZ)]
    U5[ADRF5720 (ADRF5720BCPZ)]
    U6[ADC12J4000 (ADC12J4000EVM)]
    U7[XCZU9EG (XCZU9EG-FFVB1156)]
    U8[LTM4644 (LTM4644-IV#PBF)]
    U9[LTM8063 (LTM8063IV#PBF)]
    U10[LTM8063 (LTM8063IV#PBF)]
    U11[ADP5054 (ADP5054ACPZ)]
    J1[SMA_CONNECTOR (CON-SMA-EDGE-S)]
    J2[MCIO_EDGE (MCIO-120-EDGE)]
    T1[BALUN_1to4 (EQL4320)]
    T2[BALUN_1to2 (TCM1-43X+)]
    L1[RF_CHOKE (1008HQ-15NXJLB)]
    L2[RF_CHOKE (1008HQ-15NXJLB)]
    L3[RF_CHOKE (1008HQ-15NXJLB)]
    L4[RF_CHOKE (1008HQ-15NXJLB)]
    C1[CAP_CERAMIC (GQM2195C2E1R5BB12D)]
    C2[CAP_CERAMIC (GQM2195C2E1R5BB12D)]
    C3[CAP_CERAMIC (GQM2195C2E1R5BB12D)]
    C4[CAP_CERAMIC (GQM2195C2E1R5BB12D)]
    C5[CAP_CERAMIC (0402YD105KAT2A)]
    C6[CAP_CERAMIC (GQM2195C2E4R7BB12D)]
    C7[CAP_CERAMIC (0402YD105KAT2A)]
    C8[CAP_CERAMIC (GQM2195C2E4R7BB12D)]
    C9[CAP_CERAMIC (0402YD105KAT2A)]
    C10[CAP_CERAMIC (GQM2195C2E4R7BB12D)]
    C11[CAP_CERAMIC (0402YD105KAT2A)]
    C12[CAP_CERAMIC (GQM2195C2E4R7BB12D)]
    C13[CAP_CERAMIC (0402YD105KAT2A)]
    C14[CAP_CERAMIC (0402YD105KAT2A)]
    C15[CAP_CERAMIC (0402YD105KAT2A)]
    C16[CAP_CERAMIC (0402YD105KAT2A)]
    C17[CAP_CERAMIC (0402YD105KAT2A)]
    C18[CAP_CERAMIC (0402YD105KAT2A)]
    C19[CAP_CERAMIC (0402YD105KAT2A)]
    C20[CAP_CERAMIC (0402YD105KAT2A)]
    R1[RESISTOR (ERJ-2RKF1001X)]
    R2[RESISTOR (ERA-6AEB103V)]
    R3[RESISTOR (ERA-6AEB103V)]
    R4[RESISTOR (ERJ-2RKF1001X)]
    R5[RESISTOR (ERJ-2RKF1001X)]
    R6[RESISTOR (ERJ-2RKF1001X)]
    R7[RESISTOR (ERJ-2RKF1001X)]
    R8[RESISTOR (ERJ-2RKF1001X)]
    R9[RESISTOR (ERJ-2RKF1001X)]
    R10[RESISTOR (ERJ-2RKF1001X)]
    R11[RESISTOR (ERJ-2RKF1001X)]
    R12[RESISTOR (ERJ-2RKF1001X)]
    R13[RESISTOR (ERJ-2RKF1001X)]
    R14[RESISTOR (ERJ-2RKF1001X)]
    R15[RESISTOR (ERJ-2RKF1001X)]
    R16[RESISTOR (ERJ-2RKF1001X)]
    R17[RESISTOR (ERJ-2RKF1001X)]
    R18[RESISTOR (ERJ-2RKF1001X)]
    R19[RESISTOR (ERJ-2RKF1001X)]
    R20[RESISTOR (ERJ-2RKF1001X)]
    R21[RESISTOR (ERJ-2RKF1001X)]
    R22[RESISTOR (ERJ-2RKF1001X)]
    J1 -->|RF_IN_5_18GHZ| U1
    U1 -->|RF_LIM_OUT| C1
    C1 -->|RF_LIM_OUT_C| U2
    U2 -->|L2_VCC| L2
    L2 -->|+5V_RF| C5
    C5 -->|+5V_RF_DEC| U2
    U2 -->|RF_LNA_OUT| C2
    C2 -->|RF_TO_MIXER_RF| U3
    C3 -->|RF_TO_MIXER_RF_N| U3
    U4 -->|LO_OUT_5_18GHZ| C6
    U4 -->|LO_OUT_5_18GHZ_N| C7
    C6 -->|LO_TO_MIXER_LO+| U3
    C7 -->|LO_TO_MIXER_LO-| U3
    U3 -->|IF_I_P| U5
    U3 -->|IF_I_N| U5
    U3 -->|IF_Q_P| C8
    U3 -->|IF_Q_N| C9
    C8 -->|IF_Q_P_C| T2
    C9 -->|IF_Q_N_C| T2
    T2 -->|IF_Q_COMB| U5
    U5 -->|IF_VGA_OUT_P| C10
    U5 -->|IF_VGA_OUT_N| C11
    C10 -->|IF_TO_ADC_P| U6
    C11 -->|IF_TO_ADC_N| U6
    U6 -->|ADC_CLK_P| U7
    U6 -->|ADC_CLK_N| U7
    U6 -->|ADC_D0_P| U7
    U6 -->|ADC_D0_N| U7
    U6 -->|ADC_D1_P| U7
    U6 -->|ADC_D1_N| U7
    U6 -->|ADC_D2_P| U7
    U6 -->|ADC_D2_N| U7
    U6 -->|ADC_D3_P| U7
    U6 -->|ADC_D3_N| U7
    U6 -->|ADC_D4_P| U7
    U6 -->|ADC_D4_N| U7
    U6 -->|ADC_D5_P| U7
    U6 -->|ADC_D5_N| U7
    U6 -->|ADC_D6_P| U7
    U6 -->|ADC_D6_N| U7
    U6 -->|ADC_D7_P| U7
    U6 -->|ADC_D7_N| U7
    U7 -->|SPI_PLL_SCLK| U4
    U7 -->|SPI_PLL_SDIO| U4
    U7 -->|SPI_PLL_CS_N| U4
    U7 -->|SPI_VGA_SCLK| U5
    U7 -->|SPI_VGA_SDIO| U5
    U7 -->|SPI_VGA_CS_N| U5
    U7 -->|SPI_ADC_SCLK| U6
    U7 -->|SPI_ADC_SDIO| U6
    U7 -->|SPI_ADC_CS_N| U6
    U6 -->|GPIO_LE_P| U7
    U6 -->|GPIO_LE_N| U7
    U6 -->|GPIO_CLK_P| U7
    U6 -->|GPIO_CLK_N| U7
    J2 -->|+28V_INPUT| U8
    J2 -->|+28V_INPUT| U9
    J2 -->|+28V_INPUT| U10
    U8 -->|+5V_RF_OUT| U2
    U8 -->|+5V_RF_OUT| U1
    U8 -->|+5V_RF_OUT| U3
    U8 -->|+5V_LOGIC| U11
    U11 -->|+3V3_FPGA| U7
    U11 -->|+1V8_FPGA| U7
    U11 -->|+1V0_FPGA| U7
    U9 -->|+1V8_ADC| U6
    U9 -->|+1V0_ADC_CORE| U6
    U10 -->|+3V3_PLL| U4
    U8 -->|+5V_VGA| U5
    U8 -->|+5V_VGA| U11
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
    U11 -->|GND| C12
    C12 -->|GND| C13
    C13 -->|GND| C14
    C14 -->|GND| C15
    C15 -->|GND| C16
    C16 -->|GND| C17
    C17 -->|GND| C18
    C18 -->|GND| C19
    C19 -->|GND| C20
    C20 -->|GND| J1
    J1 -->|GND| J2
    U8 -->|DEC_+5V_RF| C12
    C12 -->|DEC_+5V_RF| C13
    U8 -->|DEC_+5V_LOGIC| C14
    C14 -->|DEC_+5V_LOGIC| C15
    U8 -->|DEC_+5V_VGA| C16
    C16 -->|DEC_+5V_VGA| C17
    U11 -->|DEC_+3V3_FPGA| C18
    U11 -->|DEC_+1V8_FPGA| C19
    U11 -->|DEC_+1V0_FPGA| C20
    U7 -->|SPI_MUX_S0| R1
    U7 -->|SPI_MUX_S1| R2
    R1 -->|SPI_MUX_S0_CTRL| U11
    R2 -->|SPI_MUX_S1_CTRL| U11
    U4 -->|PLL_LOCK| R3
    R3 -->|PLL_LOCK_FB| U7
    U7 -->|VGA_GAIN_CTRL0| R4
    U7 -->|VGA_GAIN_CTRL1| R5
    R4 -->|VGA_GAIN_CTRL0_SIG| U5
    R5 -->|VGA_GAIN_CTRL1_SIG| U5
    U7 -->|ADC_PDWN| R6
    R6 -->|ADC_PDWN_CTRL| U6
    U7 -->|FPGA_DONE| R7
    U7 -->|FPGA_INIT| R8
    U7 -->|FPGA_PROG| R9
    R7 -->|FPGA_DONE_LED| R10
    R10 -->|FPGA_DONE_LED_OUT| J2
    U4 -->|TP_PLL_RFOUT| R11
    R11 -->|TP_PLL_RFOUT_TP| J2
    U2 -->|TP_LNA_OUT| R12
    R12 -->|TP_LNA_OUT_TP| J2
    U3 -->|TP_MIXER_I_OUT| R13
    R13 -->|TP_MIXER_I_OUT_TP| J2
    U5 -->|TP_VGA_OUT| R14
    R14 -->|TP_VGA_OUT_TP| J2
    U6 -->|TP_ADC_CLK| R15
    R15 -->|TP_ADC_CLK_TP| J2
    U7 -->|USB_UART_TX| R16
    U7 -->|USB_UART_RX| R17
    R16 -->|USB_UART_TX_OUT| J2
    R17 -->|USB_UART_RX_IN| J2
    U7 -->|TEMP_ALERT_FPGA| R18
    R18 -->|TEMP_ALERT_LED| R19
    R19 -->|TEMP_ALERT_LED_OUT| J2
    U11 -->|VCCINT_PG| R20
    U11 -->|VCCAUX_PG| R21
    U11 -->|VCCBRAM_PG| R22
    R20 -->|PWR_GOOD_COMBO| R21
    R21 -->|PWR_GOOD_FPGA| U7
    U7 -->|MIXER_EN| L3
    L3 -->|MIXER_VDD_EN| U3
    U7 -->|LNA_EN| L4
    L4 -->|LNA_VDD_EN| U2
```

## Component Instances

| Ref | Part Number | Component |
|---|---|---|
| U1 | LMC6048 | LMC6048 |
| U2 | TGA4538-SM | TGA4538 |
| U3 | HMC698LP4E | HMC698LP4 |
| U4 | ADF5356CCPZ | ADF5356 |
| U5 | ADRF5720BCPZ | ADRF5720 |
| U6 | ADC12J4000EVM | ADC12J4000 |
| U7 | XCZU9EG-FFVB1156 | XCZU9EG |
| U8 | LTM4644-IV#PBF | LTM4644 |
| U9 | LTM8063IV#PBF | LTM8063 |
| U10 | LTM8063IV#PBF | LTM8063 |
| U11 | ADP5054ACPZ | ADP5054 |
| J1 | CON-SMA-EDGE-S | SMA_CONNECTOR |
| J2 | MCIO-120-EDGE | MCIO_EDGE |
| T1 | EQL4320 | BALUN_1to4 |
| T2 | TCM1-43X+ | BALUN_1to2 |
| L1 | 1008HQ-15NXJLB | RF_CHOKE |
| L2 | 1008HQ-15NXJLB | RF_CHOKE |
| L3 | 1008HQ-15NXJLB | RF_CHOKE |
| L4 | 1008HQ-15NXJLB | RF_CHOKE |
| C1 | GQM2195C2E1R5BB12D | CAP_CERAMIC |
| C2 | GQM2195C2E1R5BB12D | CAP_CERAMIC |
| C3 | GQM2195C2E1R5BB12D | CAP_CERAMIC |
| C4 | GQM2195C2E1R5BB12D | CAP_CERAMIC |
| C5 | 0402YD105KAT2A | CAP_CERAMIC |
| C6 | GQM2195C2E4R7BB12D | CAP_CERAMIC |
| C7 | 0402YD105KAT2A | CAP_CERAMIC |
| C8 | GQM2195C2E4R7BB12D | CAP_CERAMIC |
| C9 | 0402YD105KAT2A | CAP_CERAMIC |
| C10 | GQM2195C2E4R7BB12D | CAP_CERAMIC |
| C11 | 0402YD105KAT2A | CAP_CERAMIC |
| C12 | GQM2195C2E4R7BB12D | CAP_CERAMIC |
| C13 | 0402YD105KAT2A | CAP_CERAMIC |
| C14 | 0402YD105KAT2A | CAP_CERAMIC |
| C15 | 0402YD105KAT2A | CAP_CERAMIC |
| C16 | 0402YD105KAT2A | CAP_CERAMIC |
| C17 | 0402YD105KAT2A | CAP_CERAMIC |
| C18 | 0402YD105KAT2A | CAP_CERAMIC |
| C19 | 0402YD105KAT2A | CAP_CERAMIC |
| C20 | 0402YD105KAT2A | CAP_CERAMIC |
| R1 | ERJ-2RKF1001X | RESISTOR |
| R2 | ERA-6AEB103V | RESISTOR |
| R3 | ERA-6AEB103V | RESISTOR |
| R4 | ERJ-2RKF1001X | RESISTOR |
| R5 | ERJ-2RKF1001X | RESISTOR |
| R6 | ERJ-2RKF1001X | RESISTOR |
| R7 | ERJ-2RKF1001X | RESISTOR |
| R8 | ERJ-2RKF1001X | RESISTOR |
| R9 | ERJ-2RKF1001X | RESISTOR |
| R10 | ERJ-2RKF1001X | RESISTOR |
| R11 | ERJ-2RKF1001X | RESISTOR |
| R12 | ERJ-2RKF1001X | RESISTOR |
| R13 | ERJ-2RKF1001X | RESISTOR |
| R14 | ERJ-2RKF1001X | RESISTOR |
| R15 | ERJ-2RKF1001X | RESISTOR |
| R16 | ERJ-2RKF1001X | RESISTOR |
| R17 | ERJ-2RKF1001X | RESISTOR |
| R18 | ERJ-2RKF1001X | RESISTOR |
| R19 | ERJ-2RKF1001X | RESISTOR |
| R20 | ERJ-2RKF1001X | RESISTOR |
| R21 | ERJ-2RKF1001X | RESISTOR |
| R22 | ERJ-2RKF1001X | RESISTOR |

## Pin-to-Pin Connections

| Net | From | Pin | To | Pin | Type |
|---|---|---|---|---|---|
| RF_IN_5_18GHZ | J1 | 1 | U1 | RF_IN | analog |
| RF_LIM_OUT | U1 | RF_OUT | C1 | 1 | analog |
| RF_LIM_OUT_C | C1 | 2 | U2 | RF_IN | analog |
| L2_VCC | U2 | VCC | L2 | 1 | power |
| +5V_RF | L2 | 2 | C5 | 1 | power |
| +5V_RF_DEC | C5 | 2 | U2 | VCC | power |
| RF_LNA_OUT | U2 | RF_OUT | C2 | 1 | analog |
| RF_TO_MIXER_RF | C2 | 2 | U3 | RF+ | analog |
| RF_TO_MIXER_RF_N | C3 | 2 | U3 | RF- | analog |
| LO_OUT_5_18GHZ | U4 | RF_OUT_A+ | C6 | 1 | analog |
| LO_OUT_5_18GHZ_N | U4 | RF_OUT_A- | C7 | 1 | analog |
| LO_TO_MIXER_LO+ | C6 | 2 | U3 | LO+ | analog |
| LO_TO_MIXER_LO- | C7 | 2 | U3 | LO- | analog |
| IF_I_P | U3 | I+ | U5 | RF_IN+ | analog |
| IF_I_N | U3 | I- | U5 | RF_IN- | analog |
| IF_Q_P | U3 | Q+ | C8 | 1 | analog |
| IF_Q_N | U3 | Q- | C9 | 1 | analog |
| IF_Q_P_C | C8 | 2 | T2 | P1 | analog |
| IF_Q_N_C | C9 | 2 | T2 | P2 | analog |
| IF_Q_COMB | T2 | S1 | U5 | RF_IN+ | analog |
| IF_VGA_OUT_P | U5 | RF_OUT+ | C10 | 1 | analog |
| IF_VGA_OUT_N | U5 | RF_OUT- | C11 | 1 | analog |
| IF_TO_ADC_P | C10 | 2 | U6 | VIN_P | analog |
| IF_TO_ADC_N | C11 | 2 | U6 | VIN_N | analog |
| ADC_CLK_P | U6 | CLK_P | U7 | MRCC_0 | clock |
| ADC_CLK_N | U6 | CLK_N | U7 | MRCC_N0 | clock |
| ADC_D0_P | U6 | D0_P | U7 | HP_IO_0 | digital |
| ADC_D0_N | U6 | D0_N | U7 | HP_IO_N0 | digital |
| ADC_D1_P | U6 | D1_P | U7 | HP_IO_2 | digital |
| ADC_D1_N | U6 | D1_N | U7 | HP_IO_N2 | digital |
| ADC_D2_P | U6 | D2_P | U7 | HP_IO_4 | digital |
| ADC_D2_N | U6 | D2_N | U7 | HP_IO_N4 | digital |
| ADC_D3_P | U6 | D3_P | U7 | HP_IO_6 | digital |
| ADC_D3_N | U6 | D3_N | U7 | HP_IO_N6 | digital |
| ADC_D4_P | U6 | D4_P | U7 | HP_IO_8 | digital |
| ADC_D4_N | U6 | D4_N | U7 | HP_IO_N8 | digital |
| ADC_D5_P | U6 | D5_P | U7 | HP_IO_10 | digital |
| ADC_D5_N | U6 | D5_N | U7 | HP_IO_N10 | digital |
| ADC_D6_P | U6 | D6_P | U7 | HP_IO_12 | digital |
| ADC_D6_N | U6 | D6_N | U7 | HP_IO_N12 | digital |
| ADC_D7_P | U6 | D7_P | U7 | HP_IO_14 | digital |
| ADC_D7_N | U6 | D7_N | U7 | HP_IO_N14 | digital |
| SPI_PLL_SCLK | U7 | SPI_SCLK | U4 | SCLK | digital |
| SPI_PLL_SDIO | U7 | SPI_SDIO | U4 | SDIO | digital |
| SPI_PLL_CS_N | U7 | SPI_CS_N | U4 | CS_N | digital |
| SPI_VGA_SCLK | U7 | SPI_SCLK | U5 | SCLK | digital |
| SPI_VGA_SDIO | U7 | SPI_SDIO_2 | U5 | SDIO | digital |
| SPI_VGA_CS_N | U7 | SPI_CS_N_2 | U5 | CS_N | digital |
| SPI_ADC_SCLK | U7 | SPI_SCLK | U6 | SCLK | digital |
| SPI_ADC_SDIO | U7 | SPI_SDIO_3 | U6 | SDIO | digital |
| SPI_ADC_CS_N | U7 | SPI_CS_N_3 | U6 | CS_N | digital |
| GPIO_LE_P | U6 | D0_P | U7 | HP_IO_0 | digital |
| GPIO_LE_N | U6 | D0_N | U7 | HP_IO_N0 | digital |
| GPIO_CLK_P | U6 | DCLK_P | U7 | MRCC_1 | clock |
| GPIO_CLK_N | U6 | DCLK_N | U7 | MRCC_N1 | clock |
| +28V_INPUT | J2 | A1 | U8 | VIN | power |
| +28V_INPUT | J2 | A1 | U9 | VIN | power |
| +28V_INPUT | J2 | A1 | U10 | VIN | power |
| +5V_RF_OUT | U8 | VOUT1 | U2 | VCC | power |
| +5V_RF_OUT | U8 | VOUT1 | U1 | VDD | power |
| +5V_RF_OUT | U8 | VOUT1 | U3 | VDD | power |
| +5V_LOGIC | U8 | VOUT2 | U11 | VIN2 | power |
| +3V3_FPGA | U11 | VOUT1 | U7 | VCCINT | power |
| +1V8_FPGA | U11 | VOUT2 | U7 | VCCAUX | power |
| +1V0_FPGA | U11 | VOUT3 | U7 | VCCBRAM | power |
| +1V8_ADC | U9 | VOUT | U6 | VDD18 | power |
| +1V0_ADC_CORE | U9 | VOUT_AUX | U6 | VDD10 | power |
| +3V3_PLL | U10 | VOUT | U4 | VDD | power |
| +5V_VGA | U8 | VOUT3 | U5 | VDD | power |
| +5V_VGA | U8 | VOUT3 | U11 | VIN1 | power |
| GND | U1 | GND | U2 | GND | ground |
| GND | U2 | GND | U3 | GND | ground |
| GND | U3 | GND | U4 | GND | ground |
| GND | U4 | GND | U5 | GND | ground |
| GND | U5 | GND | U6 | GND | ground |
| GND | U6 | GND | U7 | GND | ground |
| GND | U7 | GND | U8 | PGND | ground |
| GND | U8 | PGND | U9 | GND | ground |
| GND | U9 | GND | U10 | GND | ground |
| GND | U10 | GND | U11 | GND | ground |
| GND | U11 | GND | C12 | 2 | ground |
| GND | C12 | 2 | C13 | 2 | ground |
| GND | C13 | 2 | C14 | 2 | ground |
| GND | C14 | 2 | C15 | 2 | ground |
| GND | C15 | 2 | C16 | 2 | ground |
| GND | C16 | 2 | C17 | 2 | ground |
| GND | C17 | 2 | C18 | 2 | ground |
| GND | C18 | 2 | C19 | 2 | ground |
| GND | C19 | 2 | C20 | 2 | ground |
| GND | C20 | 2 | J1 | 2 | ground |
| GND | J1 | 2 | J2 | B1 | ground |
| DEC_+5V_RF | U8 | VOUT1 | C12 | 1 | power |
| DEC_+5V_RF | C12 | 1 | C13 | 1 | power |
| DEC_+5V_LOGIC | U8 | VOUT2 | C14 | 1 | power |
| DEC_+5V_LOGIC | C14 | 1 | C15 | 1 | power |
| DEC_+5V_VGA | U8 | VOUT3 | C16 | 1 | power |
| DEC_+5V_VGA | C16 | 1 | C17 | 1 | power |
| DEC_+3V3_FPGA | U11 | VOUT1 | C18 | 1 | power |
| DEC_+1V8_FPGA | U11 | VOUT2 | C19 | 1 | power |
| DEC_+1V0_FPGA | U11 | VOUT3 | C20 | 1 | power |
| SPI_MUX_S0 | U7 | GPIO_0 | R1 | 1 | digital |
| SPI_MUX_S1 | U7 | GPIO_1 | R2 | 1 | digital |
| SPI_MUX_S0_CTRL | R1 | 2 | U11 | SYNC | digital |
| SPI_MUX_S1_CTRL | R2 | 2 | U11 | CLK | digital |
| PLL_LOCK | U4 | MUXOUT | R3 | 1 | digital |
| PLL_LOCK_FB | R3 | 2 | U7 | GPIO_2 | digital |
| VGA_GAIN_CTRL0 | U7 | GPIO_3 | R4 | 1 | digital |
| VGA_GAIN_CTRL1 | U7 | GPIO_4 | R5 | 1 | digital |
| VGA_GAIN_CTRL0_SIG | R4 | 2 | U5 | LE0 | digital |
| VGA_GAIN_CTRL1_SIG | R5 | 2 | U5 | LE1 | digital |
| ADC_PDWN | U7 | GPIO_5 | R6 | 1 | digital |
| ADC_PDWN_CTRL | R6 | 2 | U6 | PDWN | digital |
| FPGA_DONE | U7 | DONE | R7 | 1 | digital |
| FPGA_INIT | U7 | INIT_B | R8 | 1 | digital |
| FPGA_PROG | U7 | PROG_B | R9 | 1 | digital |
| FPGA_DONE_LED | R7 | 2 | R10 | 1 | digital |
| FPGA_DONE_LED_OUT | R10 | 2 | J2 | A2 | digital |
| TP_PLL_RFOUT | U4 | RF_OUT_A+ | R11 | 1 | analog |
| TP_PLL_RFOUT_TP | R11 | 2 | J2 | A3 | analog |
| TP_LNA_OUT | U2 | RF_OUT | R12 | 1 | analog |
| TP_LNA_OUT_TP | R12 | 2 | J2 | A4 | analog |
| TP_MIXER_I_OUT | U3 | I+ | R13 | 1 | analog |
| TP_MIXER_I_OUT_TP | R13 | 2 | J2 | A5 | analog |
| TP_VGA_OUT | U5 | RF_OUT+ | R14 | 1 | analog |
| TP_VGA_OUT_TP | R14 | 2 | J2 | A6 | analog |
| TP_ADC_CLK | U6 | CLK_P | R15 | 1 | clock |
| TP_ADC_CLK_TP | R15 | 2 | J2 | A7 | clock |
| USB_UART_TX | U7 | UART_TX | R16 | 1 | digital |
| USB_UART_RX | U7 | UART_RX | R17 | 1 | digital |
| USB_UART_TX_OUT | R16 | 2 | J2 | B2 | digital |
| USB_UART_RX_IN | R17 | 2 | J2 | B3 | digital |
| TEMP_ALERT_FPGA | U7 | TEMP_ALARM | R18 | 1 | digital |
| TEMP_ALERT_LED | R18 | 2 | R19 | 1 | digital |
| TEMP_ALERT_LED_OUT | R19 | 2 | J2 | B4 | digital |
| VCCINT_PG | U11 | PG1 | R20 | 1 | digital |
| VCCAUX_PG | U11 | PG2 | R21 | 1 | digital |
| VCCBRAM_PG | U11 | PG3 | R22 | 1 | digital |
| PWR_GOOD_COMBO | R20 | 2 | R21 | 2 | digital |
| PWR_GOOD_FPGA | R21 | 2 | U7 | PWR_GOOD | digital |
| MIXER_EN | U7 | GPIO_6 | L3 | 1 | digital |
| MIXER_VDD_EN | L3 | 2 | U3 | VDD | power |
| LNA_EN | U7 | GPIO_7 | L4 | 1 | digital |
| LNA_VDD_EN | L4 | 2 | U2 | VCC | power |

## Net Connection List

| Net Name | Reference Designator - Pin No. |
|----------|-------------------------------|
| +1V0_ADC_CORE | U9 - VOUT_AUX,  U6 - VDD10 |
| +1V0_FPGA | U11 - VOUT3,  U7 - VCCBRAM |
| +1V8_ADC | U9 - VOUT,  U6 - VDD18 |
| +1V8_FPGA | U11 - VOUT2,  U7 - VCCAUX |
| +28V_INPUT | J2 - A1,  U8 - VIN,  U9 - VIN,  U10 - VIN |
| +3V3_FPGA | U11 - VOUT1,  U7 - VCCINT |
| +3V3_PLL | U10 - VOUT,  U4 - VDD |
| +5V_LOGIC | U8 - VOUT2,  U11 - VIN2 |
| +5V_RF | L2 - 2,  C5 - 1 |
| +5V_RF_DEC | C5 - 2,  U2 - VCC |
| +5V_RF_OUT | U8 - VOUT1,  U2 - VCC,  U1 - VDD,  U3 - VDD |
| +5V_VGA | U8 - VOUT3,  U5 - VDD,  U11 - VIN1 |
| ADC_CLK_N | U6 - CLK_N,  U7 - MRCC_N0 |
| ADC_CLK_P | U6 - CLK_P,  U7 - MRCC_0 |
| ADC_D0_N | U6 - D0_N,  U7 - HP_IO_N0 |
| ADC_D0_P | U6 - D0_P,  U7 - HP_IO_0 |
| ADC_D1_N | U6 - D1_N,  U7 - HP_IO_N2 |
| ADC_D1_P | U6 - D1_P,  U7 - HP_IO_2 |
| ADC_D2_N | U6 - D2_N,  U7 - HP_IO_N4 |
| ADC_D2_P | U6 - D2_P,  U7 - HP_IO_4 |
| ADC_D3_N | U6 - D3_N,  U7 - HP_IO_N6 |
| ADC_D3_P | U6 - D3_P,  U7 - HP_IO_6 |
| ADC_D4_N | U6 - D4_N,  U7 - HP_IO_N8 |
| ADC_D4_P | U6 - D4_P,  U7 - HP_IO_8 |
| ADC_D5_N | U6 - D5_N,  U7 - HP_IO_N10 |
| ADC_D5_P | U6 - D5_P,  U7 - HP_IO_10 |
| ADC_D6_N | U6 - D6_N,  U7 - HP_IO_N12 |
| ADC_D6_P | U6 - D6_P,  U7 - HP_IO_12 |
| ADC_D7_N | U6 - D7_N,  U7 - HP_IO_N14 |
| ADC_D7_P | U6 - D7_P,  U7 - HP_IO_14 |
| ADC_PDWN | U7 - GPIO_5,  R6 - 1 |
| ADC_PDWN_CTRL | R6 - 2,  U6 - PDWN |
| DEC_+1V0_FPGA | U11 - VOUT3,  C20 - 1 |
| DEC_+1V8_FPGA | U11 - VOUT2,  C19 - 1 |
| DEC_+3V3_FPGA | U11 - VOUT1,  C18 - 1 |
| DEC_+5V_LOGIC | U8 - VOUT2,  C14 - 1,  C15 - 1 |
| DEC_+5V_RF | U8 - VOUT1,  C12 - 1,  C13 - 1 |
| DEC_+5V_VGA | U8 - VOUT3,  C16 - 1,  C17 - 1 |
| FPGA_DONE | U7 - DONE,  R7 - 1 |
| FPGA_DONE_LED | R7 - 2,  R10 - 1 |
| FPGA_DONE_LED_OUT | R10 - 2,  J2 - A2 |
| FPGA_INIT | U7 - INIT_B,  R8 - 1 |
| FPGA_PROG | U7 - PROG_B,  R9 - 1 |
| GND | U1 - GND,  U2 - GND,  U3 - GND,  U4 - GND,  U5 - GND,  U6 - GND,  U7 - GND,  U8 - PGND,  U9 - GND,  U10 - GND,  U11 - GND,  C12 - 2,  C13 - 2,  C14 - 2,  C15 - 2,  C16 - 2,  C17 - 2,  C18 - 2,  C19 - 2,  C20 - 2,  J1 - 2,  J2 - B1 |
| GPIO_CLK_N | U6 - DCLK_N,  U7 - MRCC_N1 |
| GPIO_CLK_P | U6 - DCLK_P,  U7 - MRCC_1 |
| GPIO_LE_N | U6 - D0_N,  U7 - HP_IO_N0 |
| GPIO_LE_P | U6 - D0_P,  U7 - HP_IO_0 |
| IF_I_N | U3 - I-,  U5 - RF_IN- |
| IF_I_P | U3 - I+,  U5 - RF_IN+ |
| IF_Q_COMB | T2 - S1,  U5 - RF_IN+ |
| IF_Q_N | U3 - Q-,  C9 - 1 |
| IF_Q_N_C | C9 - 2,  T2 - P2 |
| IF_Q_P | U3 - Q+,  C8 - 1 |
| IF_Q_P_C | C8 - 2,  T2 - P1 |
| IF_TO_ADC_N | C11 - 2,  U6 - VIN_N |
| IF_TO_ADC_P | C10 - 2,  U6 - VIN_P |
| IF_VGA_OUT_N | U5 - RF_OUT-,  C11 - 1 |
| IF_VGA_OUT_P | U5 - RF_OUT+,  C10 - 1 |
| L2_VCC | U2 - VCC,  L2 - 1 |
| LNA_EN | U7 - GPIO_7,  L4 - 1 |
| LNA_VDD_EN | L4 - 2,  U2 - VCC |
| LO_OUT_5_18GHZ | U4 - RF_OUT_A+,  C6 - 1 |
| LO_OUT_5_18GHZ_N | U4 - RF_OUT_A-,  C7 - 1 |
| LO_TO_MIXER_LO+ | C6 - 2,  U3 - LO+ |
| LO_TO_MIXER_LO- | C7 - 2,  U3 - LO- |
| MIXER_EN | U7 - GPIO_6,  L3 - 1 |
| MIXER_VDD_EN | L3 - 2,  U3 - VDD |
| PLL_LOCK | U4 - MUXOUT,  R3 - 1 |
| PLL_LOCK_FB | R3 - 2,  U7 - GPIO_2 |
| PWR_GOOD_COMBO | R20 - 2,  R21 - 2 |
| PWR_GOOD_FPGA | R21 - 2,  U7 - PWR_GOOD |
| RF_IN_5_18GHZ | J1 - 1,  U1 - RF_IN |
| RF_LIM_OUT | U1 - RF_OUT,  C1 - 1 |
| RF_LIM_OUT_C | C1 - 2,  U2 - RF_IN |
| RF_LNA_OUT | U2 - RF_OUT,  C2 - 1 |
| RF_TO_MIXER_RF | C2 - 2,  U3 - RF+ |
| RF_TO_MIXER_RF_N | C3 - 2,  U3 - RF- |
| SPI_ADC_CS_N | U7 - SPI_CS_N_3,  U6 - CS_N |
| SPI_ADC_SCLK | U7 - SPI_SCLK,  U6 - SCLK |
| SPI_ADC_SDIO | U7 - SPI_SDIO_3,  U6 - SDIO |
| SPI_MUX_S0 | U7 - GPIO_0,  R1 - 1 |
| SPI_MUX_S0_CTRL | R1 - 2,  U11 - SYNC |
| SPI_MUX_S1 | U7 - GPIO_1,  R2 - 1 |
| SPI_MUX_S1_CTRL | R2 - 2,  U11 - CLK |
| SPI_PLL_CS_N | U7 - SPI_CS_N,  U4 - CS_N |
| SPI_PLL_SCLK | U7 - SPI_SCLK,  U4 - SCLK |
| SPI_PLL_SDIO | U7 - SPI_SDIO,  U4 - SDIO |
| SPI_VGA_CS_N | U7 - SPI_CS_N_2,  U5 - CS_N |
| SPI_VGA_SCLK | U7 - SPI_SCLK,  U5 - SCLK |
| SPI_VGA_SDIO | U7 - SPI_SDIO_2,  U5 - SDIO |
| TEMP_ALERT_FPGA | U7 - TEMP_ALARM,  R18 - 1 |
| TEMP_ALERT_LED | R18 - 2,  R19 - 1 |
| TEMP_ALERT_LED_OUT | R19 - 2,  J2 - B4 |
| TP_ADC_CLK | U6 - CLK_P,  R15 - 1 |
| TP_ADC_CLK_TP | R15 - 2,  J2 - A7 |
| TP_LNA_OUT | U2 - RF_OUT,  R12 - 1 |
| TP_LNA_OUT_TP | R12 - 2,  J2 - A4 |
| TP_MIXER_I_OUT | U3 - I+,  R13 - 1 |
| TP_MIXER_I_OUT_TP | R13 - 2,  J2 - A5 |
| TP_PLL_RFOUT | U4 - RF_OUT_A+,  R11 - 1 |
| TP_PLL_RFOUT_TP | R11 - 2,  J2 - A3 |
| TP_VGA_OUT | U5 - RF_OUT+,  R14 - 1 |
| TP_VGA_OUT_TP | R14 - 2,  J2 - A6 |
| USB_UART_RX | U7 - UART_RX,  R17 - 1 |
| USB_UART_RX_IN | R17 - 2,  J2 - B3 |
| USB_UART_TX | U7 - UART_TX,  R16 - 1 |
| USB_UART_TX_OUT | R16 - 2,  J2 - B2 |
| VCCAUX_PG | U11 - PG2,  R21 - 1 |
| VCCBRAM_PG | U11 - PG3,  R22 - 1 |
| VCCINT_PG | U11 - PG1,  R20 - 1 |
| VGA_GAIN_CTRL0 | U7 - GPIO_3,  R4 - 1 |
| VGA_GAIN_CTRL0_SIG | R4 - 2,  U5 - LE0 |
| VGA_GAIN_CTRL1 | U7 - GPIO_4,  R5 - 1 |
| VGA_GAIN_CTRL1_SIG | R5 - 2,  U5 - LE1 |

## Validation Notes

- CRITICAL: HMC698LP4 mixer operating temperature (-40 to +85°C) does NOT meet military temperature requirement (-55 to +125°C). Alternative: HMC555LC3B (-55 to +125°C) recommended
- CRITICAL: ADF5356 PLL operating temperature (-40 to +85°C) does NOT meet military temperature requirement (-55 to +125°C). Consider ADF4159 (-55 to +125°C) or ceramic package variant
- CRITICAL: LTM4644 DC-DC converter max junction 125°C is marginal for 125°C ambient. Derating required or select military-grade regulator
- WARNING: ADRF5720 VGA 30dB gain range is digital SPI controlled - ensure proper gain calibration logic in FPGA
- WARNING: ADC12J4000 power dissipation ~3.5W at 4 GSPS - requires thermal vias and heatsink for military temperature operation
- INFO: IF chain composite noise figure: LNA 2.5dB + Mixer 7dB + VGA 4dB - 10log(3) cascade = ~9.5dB. May need IF amplifier after VGA to meet 3dB system NF requirement
- INFO: ADC12J4000 requires 1:1 balun (EQL4320) for single-ended to differential conversion
- INFO: Dual IF paths (I and Q) combined via balun T2 for single ADC channel - verify Q-phase balun phase matching
- CHECK: Verify LVDS trace impedance matching (100 ohm differential) between ADC and FPGA for 1.6 Gbps data rates
- CHECK: FPGA HP I/O banks require VCCO = 1.2V for 1.6 Gbps LVDS - confirm U11 provides this rail
- CHECK: SPI bus loading - 3 devices (PLL, VGA, ADC) on shared bus. Verify total capacitance < 50pF
- RECOMMEND: Add EMI filters on +28V input per MIL-STD-461
- RECOMMEND: Add TVS diodes on SPI lines for ESD protection
- RECOMMEND: Consider adding external LDOs for ultra-low noise PLL/VCO supplies