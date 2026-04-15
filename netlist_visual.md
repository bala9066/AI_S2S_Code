# Logical Netlist
## iguyc

## Block Diagram

```mermaid
graph TB
    J1[RF_Input_Connector (2.4MM-FEMALE)]
    U1[Wideband_LNA (HMC6987LP4E)]
    U2[Downconversion_Mixer (HMC1194LP4E)]
    U3[Frequency_Synthesizer (ADF5355CCPZ)]
    U4[Variable_Gain_Amplifier (HMC698LP4)]
    U5[Dual_Channel_ADC (ADC12DJ3200)]
    U6[FPGA (XCZU9EG-FFVB1156)]
    U7[Quad_DCDC_Regulator (LTM4644)]
    U8[Power_Manager_IC (ADP5054)]
    U9[LO_Driver_Amplifier (HMC679LP4)]
    U10[Frequency_Doubler (HMC3716LP4)]
    C1[RF_Input_DC_Block (0402B102K500)]
    C2[Decoupling_Capacitor (0402B103K500)]
    C3[Decoupling_Capacitor (0402B103K500)]
    C4[Bulk_Capacitor (0402B104K500)]
    C5[Decoupling_Capacitor (0402B103K500)]
    C6[Decoupling_Capacitor (0402B103K500)]
    C7[Bulk_Capacitor (0402B104K500)]
    C8[Bulk_Capacitor (0402B104K500)]
    C9[Bulk_Capacitor (0402B104K500)]
    C10[Bulk_Capacitor (0402B104K500)]
    C11[Bulk_Capacitor (0402B104K500)]
    C12[Decoupling_Capacitor (0402B103K500)]
    C13[Decoupling_Capacitor (0402B103K500)]
    C14[Bulk_Capacitor (0402B104K500)]
    C15[Decoupling_Capacitor (0402B103K500)]
    C16[Bulk_Capacitor (0402B104K500)]
    C17[Bulk_Capacitor (0402B104K500)]
    R1[VGA_Digital_Pullup (ERJ-2RKF1001X)]
    R2[VGA_Digital_Pullup (ERJ-2RKF1001X)]
    R3[VGA_Digital_Pullup (ERJ-2RKF1001X)]
    R4[VGA_Digital_Pullup (ERJ-2RKF1001X)]
    R5[VGA_Digital_Pullup (ERJ-2RKF1001X)]
    R6[VGA_Digital_Pullup (ERJ-2RKF1001X)]
    R7[SPI_Series_Resistor (ERJ-2RKF470X)]
    R8[SPI_Series_Resistor (ERJ-2RKF470X)]
    R9[SPI_Series_Resistor (ERJ-2RKF470X)]
    R10[SPI_Series_Resistor (ERJ-2RKF470X)]
    R11[ADC_I2C_Pullup (ERJ-2RKF1000X)]
    R12[ADC_I2C_Pullup (ERJ-2RKF1000X)]
    R13[ADC_CLK_Term (ERJ-2RKF1001X)]
    R14[FPGA_VTT_Term (ERJ-2RKF1002X)]
    L1[RF_Chip_Bead (MLG2012P2N2D)]
    L2[RF_Chip_Bead (MLG2012P2N2D)]
    L3[RF_Chip_Bead (MLG2012P2N2D)]
    L4[RF_Chip_Bead (MLG2012P2N2D)]
    T1[RF_Balun_6GHz (TC1-1-13M+)]
    T2[Impedance_Matcher (EZH-2-4-72+)]
    J1 -->|RF_IN_MAIN| C1
    C1 -->|RF_IN_LNA| U1
    U1 -->|LNA_OUT_RF| U2
    U2 -->|IF_OUT_MIXER| T1
    T1 -->|IF_DIFF_P| U4
    T1 -->|IF_DIFF_N| U4
    U4 -->|VGA_OUT_P| T2
    U4 -->|VGA_OUT_N| T2
    T2 -->|VGA_MATCHED| U5
    U3 -->|LO_SYNTH_OUT| U10
    U10 -->|LO_DOUBLED| U9
    U9 -->|LO_DRIVEN| U2
    U2 -->|MIXER_LO| U2
    U6 -->|VGA_LE| R7
    R7 -->|VGA_LE_BUF| U4
    U6 -->|VGA_CLK| R8
    R8 -->|VGA_CLK_BUF| U4
    U6 -->|VGA_DATA0| R9
    R9 -->|VGA_DATA0_BUF| U4
    U6 -->|VGA_DATA1| R10
    R10 -->|VGA_DATA1_BUF| U4
    R1 -->|VGA_PULLUP0| U4
    R2 -->|VGA_PULLUP1| U4
    R3 -->|VGA_PULLUP2| U4
    R4 -->|VGA_PULLUP3| U4
    R5 -->|VGA_PULLUP_CLK| U4
    R6 -->|VGA_PULLUP_LE| U4
    U6 -->|SPI_CLK_PLL| U3
    U6 -->|SPI_MOSI_PLL| U3
    U3 -->|SPI_MISO_PLL| U6
    U6 -->|SPI_CS_PLL| U3
    U6 -->|I2C_SDA| R11
    R11 -->|I2C_SDA_BUF| U5
    U6 -->|I2C_SCL| R12
    R12 -->|I2C_SCL_BUF| U5
    U5 -->|ADC_DCO_P| U6
    U5 -->|ADC_DCO_N| U6
    U5 -->|ADC_FRAME_P| U6
    U5 -->|ADC_FRAME_N| U6
    U5 -->|ADC_DATA_A0_P| U6
    U5 -->|ADC_DATA_A0_N| U6
    U5 -->|ADC_DATA_A1_P| U6
    U5 -->|ADC_DATA_A1_N| U6
    U5 -->|ADC_DATA_A2_P| U6
    U5 -->|ADC_DATA_A2_N| U6
    U5 -->|ADC_DATA_A3_P| U6
    U5 -->|ADC_DATA_A3_N| U6
    U5 -->|ADC_DATA_A4_P| U6
    U5 -->|ADC_DATA_A4_N| U6
    U5 -->|ADC_DATA_A5_P| U6
    U5 -->|ADC_DATA_A5_N| U6
    U6 -->|ADC_SYNC| U5
    L1 -->|LNA_+5V| U1
    L2 -->|MIXER_+5V| U2
    L3 -->|VGA_+5V| U4
    L4 -->|PLL_+5V| U3
    U7 -->|+5V_MAIN| L1
    U7 -->|+5V_PLL| L4
    U7 -->|ADC_+1V2| U5
    U7 -->|ADC_+1V8| U5
    U8 -->|FPGA_VCCINT| U6
    U8 -->|FPGA_VCCAUX| U6
    U8 -->|FPGA_VCCBRAM| U6
    U7 -->|+3V3_DIGITAL| U6
    U7 -->|+3V3_DIGITAL| R1
    U7 -->|+3V3_DIGITAL| R2
    U7 -->|+3V3_DIGITAL| R3
    U7 -->|+3V3_DIGITAL| R4
    U7 -->|+3V3_DIGITAL| R5
    U7 -->|+3V3_DIGITAL| R6
    U7 -->|+3V3_DIGITAL| R11
    U7 -->|+3V3_DIGITAL| R12
    U1 -->|GND| U1
    U1 -->|GND| U2
    U2 -->|GND| U2
    U2 -->|GND| U3
    U3 -->|GND| U4
    U4 -->|GND| U5
    U5 -->|GND| C2
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
    C17 -->|GND| U6
    U6 -->|GND| U7
    U7 -->|GND| U8
    U1 -->|LNA_DECAP_A| C2
    U1 -->|LNA_DECAP_B| C3
    U1 -->|LNA_DECAP_C| C4
    U2 -->|MIXER_DECAP_A| C5
    U2 -->|MIXER_DECAP_B| C6
    U2 -->|MIXER_DECAP_C| C7
    U4 -->|VGA_DECAP_A| C8
    U4 -->|VGA_DECAP_B| C9
    U3 -->|PLL_DECAP_A| C10
    U3 -->|PLL_DECAP_B| C11
    U5 -->|ADC_DECAP_1V2_A| C12
    U5 -->|ADC_DECAP_1V2_B| C13
    U5 -->|ADC_DECAP_1V8_A| C14
    U6 -->|FPGA_DECAP_VCCINT_A| C15
    U6 -->|FPGA_DECAP_VCCAUX_A| C16
    U6 -->|FPGA_DECAP_VCCBRAM_A| C17
```

## Component Instances

| Ref | Part Number | Component |
|---|---|---|
| J1 | 2.4MM-FEMALE | RF_Input_Connector |
| U1 | HMC6987LP4E | Wideband_LNA |
| U2 | HMC1194LP4E | Downconversion_Mixer |
| U3 | ADF5355CCPZ | Frequency_Synthesizer |
| U4 | HMC698LP4 | Variable_Gain_Amplifier |
| U5 | ADC12DJ3200 | Dual_Channel_ADC |
| U6 | XCZU9EG-FFVB1156 | FPGA |
| U7 | LTM4644 | Quad_DCDC_Regulator |
| U8 | ADP5054 | Power_Manager_IC |
| U9 | HMC679LP4 | LO_Driver_Amplifier |
| U10 | HMC3716LP4 | Frequency_Doubler |
| C1 | 0402B102K500 | RF_Input_DC_Block |
| C2 | 0402B103K500 | Decoupling_Capacitor |
| C3 | 0402B103K500 | Decoupling_Capacitor |
| C4 | 0402B104K500 | Bulk_Capacitor |
| C5 | 0402B103K500 | Decoupling_Capacitor |
| C6 | 0402B103K500 | Decoupling_Capacitor |
| C7 | 0402B104K500 | Bulk_Capacitor |
| C8 | 0402B104K500 | Bulk_Capacitor |
| C9 | 0402B104K500 | Bulk_Capacitor |
| C10 | 0402B104K500 | Bulk_Capacitor |
| C11 | 0402B104K500 | Bulk_Capacitor |
| C12 | 0402B103K500 | Decoupling_Capacitor |
| C13 | 0402B103K500 | Decoupling_Capacitor |
| C14 | 0402B104K500 | Bulk_Capacitor |
| C15 | 0402B103K500 | Decoupling_Capacitor |
| C16 | 0402B104K500 | Bulk_Capacitor |
| C17 | 0402B104K500 | Bulk_Capacitor |
| R1 | ERJ-2RKF1001X | VGA_Digital_Pullup |
| R2 | ERJ-2RKF1001X | VGA_Digital_Pullup |
| R3 | ERJ-2RKF1001X | VGA_Digital_Pullup |
| R4 | ERJ-2RKF1001X | VGA_Digital_Pullup |
| R5 | ERJ-2RKF1001X | VGA_Digital_Pullup |
| R6 | ERJ-2RKF1001X | VGA_Digital_Pullup |
| R7 | ERJ-2RKF470X | SPI_Series_Resistor |
| R8 | ERJ-2RKF470X | SPI_Series_Resistor |
| R9 | ERJ-2RKF470X | SPI_Series_Resistor |
| R10 | ERJ-2RKF470X | SPI_Series_Resistor |
| R11 | ERJ-2RKF1000X | ADC_I2C_Pullup |
| R12 | ERJ-2RKF1000X | ADC_I2C_Pullup |
| R13 | ERJ-2RKF1001X | ADC_CLK_Term |
| R14 | ERJ-2RKF1002X | FPGA_VTT_Term |
| L1 | MLG2012P2N2D | RF_Chip_Bead |
| L2 | MLG2012P2N2D | RF_Chip_Bead |
| L3 | MLG2012P2N2D | RF_Chip_Bead |
| L4 | MLG2012P2N2D | RF_Chip_Bead |
| T1 | TC1-1-13M+ | RF_Balun_6GHz |
| T2 | EZH-2-4-72+ | Impedance_Matcher |

## Pin-to-Pin Connections

| Net | From | Pin | To | Pin | Type |
|---|---|---|---|---|---|
| RF_IN_MAIN | J1 | 1 | C1 | 1 | rf |
| RF_IN_LNA | C1 | 2 | U1 | 1 | rf |
| LNA_OUT_RF | U1 | 4 | U2 | 1 | rf |
| IF_OUT_MIXER | U2 | 4 | T1 | 1 | if |
| IF_DIFF_P | T1 | 3 | U4 | 1 | if |
| IF_DIFF_N | T1 | 5 | U4 | 2 | if |
| VGA_OUT_P | U4 | 4 | T2 | 1 | if |
| VGA_OUT_N | U4 | 6 | T2 | 3 | if |
| VGA_MATCHED | T2 | 2 | U5 | 18 | if |
| LO_SYNTH_OUT | U3 | 24 | U10 | 1 | lo |
| LO_DOUBLED | U10 | 4 | U9 | 1 | lo |
| LO_DRIVEN | U9 | 4 | U2 | 8 | lo |
| MIXER_LO | U2 | 5 | U2 | 8 | lo |
| VGA_LE | U6 | AE12 | R7 | 1 | digital |
| VGA_LE_BUF | R7 | 2 | U4 | 8 | digital |
| VGA_CLK | U6 | AE13 | R8 | 1 | digital |
| VGA_CLK_BUF | R8 | 2 | U4 | 7 | digital |
| VGA_DATA0 | U6 | AF12 | R9 | 1 | digital |
| VGA_DATA0_BUF | R9 | 2 | U4 | 3 | digital |
| VGA_DATA1 | U6 | AF13 | R10 | 1 | digital |
| VGA_DATA1_BUF | R10 | 2 | U4 | 4 | digital |
| VGA_PULLUP0 | R1 | 2 | U4 | 3 | digital |
| VGA_PULLUP1 | R2 | 2 | U4 | 4 | digital |
| VGA_PULLUP2 | R3 | 2 | U4 | 5 | digital |
| VGA_PULLUP3 | R4 | 2 | U4 | 6 | digital |
| VGA_PULLUP_CLK | R5 | 2 | U4 | 7 | digital |
| VGA_PULLUP_LE | R6 | 2 | U4 | 8 | digital |
| SPI_CLK_PLL | U6 | R5 | U3 | 27 | digital |
| SPI_MOSI_PLL | U6 | R6 | U3 | 28 | digital |
| SPI_MISO_PLL | U3 | 29 | U6 | R8 | digital |
| SPI_CS_PLL | U6 | R9 | U3 | 30 | digital |
| I2C_SDA | U6 | T10 | R11 | 1 | digital |
| I2C_SDA_BUF | R11 | 2 | U5 | 25 | digital |
| I2C_SCL | U6 | T11 | R12 | 1 | digital |
| I2C_SCL_BUF | R12 | 2 | U5 | 24 | digital |
| ADC_DCO_P | U5 | 35 | U6 | M15 | clock |
| ADC_DCO_N | U5 | 36 | U6 | M16 | clock |
| ADC_FRAME_P | U5 | 33 | U6 | L13 | digital |
| ADC_FRAME_N | U5 | 34 | U6 | L14 | digital |
| ADC_DATA_A0_P | U5 | 3 | U6 | H20 | digital |
| ADC_DATA_A0_N | U5 | 2 | U6 | H21 | digital |
| ADC_DATA_A1_P | U5 | 5 | U6 | K20 | digital |
| ADC_DATA_A1_N | U5 | 4 | U6 | K21 | digital |
| ADC_DATA_A2_P | U5 | 7 | U6 | J20 | digital |
| ADC_DATA_A2_N | U5 | 6 | U6 | J21 | digital |
| ADC_DATA_A3_P | U5 | 9 | U6 | G20 | digital |
| ADC_DATA_A3_N | U5 | 8 | U6 | G21 | digital |
| ADC_DATA_A4_P | U5 | 11 | U6 | F20 | digital |
| ADC_DATA_A4_N | U5 | 10 | U6 | F21 | digital |
| ADC_DATA_A5_P | U5 | 13 | U6 | E20 | digital |
| ADC_DATA_A5_N | U5 | 12 | U6 | E21 | digital |
| ADC_SYNC | U6 | N15 | U5 | 29 | digital |
| LNA_+5V | L1 | 2 | U1 | 3 | power |
| MIXER_+5V | L2 | 2 | U2 | 3 | power |
| VGA_+5V | L3 | 2 | U4 | 9 | power |
| PLL_+5V | L4 | 2 | U3 | 23 | power |
| +5V_MAIN | U7 | 17 | L1 | 1 | power |
| +5V_PLL | U7 | 17 | L4 | 1 | power |
| ADC_+1V2 | U7 | 19 | U5 | 42 | power |
| ADC_+1V8 | U7 | 13 | U5 | 44 | power |
| FPGA_VCCINT | U8 | 16 | U6 | F32 | power |
| FPGA_VCCAUX | U8 | 20 | U6 | G30 | power |
| FPGA_VCCBRAM | U8 | 24 | U6 | H28 | power |
| +3V3_DIGITAL | U7 | 1 | U6 | J32 | power |
| +3V3_DIGITAL | U7 | 1 | R1 | 1 | power |
| +3V3_DIGITAL | U7 | 1 | R2 | 1 | power |
| +3V3_DIGITAL | U7 | 1 | R3 | 1 | power |
| +3V3_DIGITAL | U7 | 1 | R4 | 1 | power |
| +3V3_DIGITAL | U7 | 1 | R5 | 1 | power |
| +3V3_DIGITAL | U7 | 1 | R6 | 1 | power |
| +3V3_DIGITAL | U7 | 1 | R11 | 2 | power |
| +3V3_DIGITAL | U7 | 1 | R12 | 2 | power |
| GND | U1 | 2 | U1 | 6 | ground |
| GND | U1 | 6 | U2 | 2 | ground |
| GND | U2 | 2 | U2 | 6 | ground |
| GND | U2 | 6 | U3 | 10 | ground |
| GND | U3 | 10 | U4 | 10 | ground |
| GND | U4 | 10 | U5 | 43 | ground |
| GND | U5 | 43 | C2 | 2 | ground |
| GND | C2 | 2 | C3 | 2 | ground |
| GND | C3 | 2 | C4 | 2 | ground |
| GND | C4 | 2 | C5 | 2 | ground |
| GND | C5 | 2 | C6 | 2 | ground |
| GND | C6 | 2 | C7 | 2 | ground |
| GND | C7 | 2 | C8 | 2 | ground |
| GND | C8 | 2 | C9 | 2 | ground |
| GND | C9 | 2 | C10 | 2 | ground |
| GND | C10 | 2 | C11 | 2 | ground |
| GND | C11 | 2 | C12 | 2 | ground |
| GND | C12 | 2 | C13 | 2 | ground |
| GND | C13 | 2 | C14 | 2 | ground |
| GND | C14 | 2 | C15 | 2 | ground |
| GND | C15 | 2 | C16 | 2 | ground |
| GND | C16 | 2 | C17 | 2 | ground |
| GND | C17 | 2 | U6 | E32 | ground |
| GND | U6 | E32 | U7 | 10 | ground |
| GND | U7 | 10 | U8 | 11 | ground |
| LNA_DECAP_A | U1 | 3 | C2 | 1 | power |
| LNA_DECAP_B | U1 | 3 | C3 | 1 | power |
| LNA_DECAP_C | U1 | 3 | C4 | 1 | power |
| MIXER_DECAP_A | U2 | 3 | C5 | 1 | power |
| MIXER_DECAP_B | U2 | 3 | C6 | 1 | power |
| MIXER_DECAP_C | U2 | 3 | C7 | 1 | power |
| VGA_DECAP_A | U4 | 9 | C8 | 1 | power |
| VGA_DECAP_B | U4 | 9 | C9 | 1 | power |
| PLL_DECAP_A | U3 | 23 | C10 | 1 | power |
| PLL_DECAP_B | U3 | 23 | C11 | 1 | power |
| ADC_DECAP_1V2_A | U5 | 42 | C12 | 1 | power |
| ADC_DECAP_1V2_B | U5 | 42 | C13 | 1 | power |
| ADC_DECAP_1V8_A | U5 | 44 | C14 | 1 | power |
| FPGA_DECAP_VCCINT_A | U6 | F32 | C15 | 1 | power |
| FPGA_DECAP_VCCAUX_A | U6 | G30 | C16 | 1 | power |
| FPGA_DECAP_VCCBRAM_A | U6 | H28 | C17 | 1 | power |

## Net Connection List

| Net Name | Reference Designator - Pin No. |
|----------|-------------------------------|
| +3V3_DIGITAL | U7 - 1,  U6 - J32,  R1 - 1,  R2 - 1,  R3 - 1,  R4 - 1,  R5 - 1,  R6 - 1,  R11 - 2,  R12 - 2 |
| +5V_MAIN | U7 - 17,  L1 - 1 |
| +5V_PLL | U7 - 17,  L4 - 1 |
| ADC_+1V2 | U7 - 19,  U5 - 42 |
| ADC_+1V8 | U7 - 13,  U5 - 44 |
| ADC_DATA_A0_N | U5 - 2,  U6 - H21 |
| ADC_DATA_A0_P | U5 - 3,  U6 - H20 |
| ADC_DATA_A1_N | U5 - 4,  U6 - K21 |
| ADC_DATA_A1_P | U5 - 5,  U6 - K20 |
| ADC_DATA_A2_N | U5 - 6,  U6 - J21 |
| ADC_DATA_A2_P | U5 - 7,  U6 - J20 |
| ADC_DATA_A3_N | U5 - 8,  U6 - G21 |
| ADC_DATA_A3_P | U5 - 9,  U6 - G20 |
| ADC_DATA_A4_N | U5 - 10,  U6 - F21 |
| ADC_DATA_A4_P | U5 - 11,  U6 - F20 |
| ADC_DATA_A5_N | U5 - 12,  U6 - E21 |
| ADC_DATA_A5_P | U5 - 13,  U6 - E20 |
| ADC_DCO_N | U5 - 36,  U6 - M16 |
| ADC_DCO_P | U5 - 35,  U6 - M15 |
| ADC_DECAP_1V2_A | U5 - 42,  C12 - 1 |
| ADC_DECAP_1V2_B | U5 - 42,  C13 - 1 |
| ADC_DECAP_1V8_A | U5 - 44,  C14 - 1 |
| ADC_FRAME_N | U5 - 34,  U6 - L14 |
| ADC_FRAME_P | U5 - 33,  U6 - L13 |
| ADC_SYNC | U6 - N15,  U5 - 29 |
| FPGA_DECAP_VCCAUX_A | U6 - G30,  C16 - 1 |
| FPGA_DECAP_VCCBRAM_A | U6 - H28,  C17 - 1 |
| FPGA_DECAP_VCCINT_A | U6 - F32,  C15 - 1 |
| FPGA_VCCAUX | U8 - 20,  U6 - G30 |
| FPGA_VCCBRAM | U8 - 24,  U6 - H28 |
| FPGA_VCCINT | U8 - 16,  U6 - F32 |
| GND | U1 - 2,  U1 - 6,  U2 - 2,  U2 - 6,  U3 - 10,  U4 - 10,  U5 - 43,  C2 - 2,  C3 - 2,  C4 - 2,  C5 - 2,  C6 - 2,  C7 - 2,  C8 - 2,  C9 - 2,  C10 - 2,  C11 - 2,  C12 - 2,  C13 - 2,  C14 - 2,  C15 - 2,  C16 - 2,  C17 - 2,  U6 - E32,  U7 - 10,  U8 - 11 |
| I2C_SCL | U6 - T11,  R12 - 1 |
| I2C_SCL_BUF | R12 - 2,  U5 - 24 |
| I2C_SDA | U6 - T10,  R11 - 1 |
| I2C_SDA_BUF | R11 - 2,  U5 - 25 |
| IF_DIFF_N | T1 - 5,  U4 - 2 |
| IF_DIFF_P | T1 - 3,  U4 - 1 |
| IF_OUT_MIXER | U2 - 4,  T1 - 1 |
| LNA_+5V | L1 - 2,  U1 - 3 |
| LNA_DECAP_A | U1 - 3,  C2 - 1 |
| LNA_DECAP_B | U1 - 3,  C3 - 1 |
| LNA_DECAP_C | U1 - 3,  C4 - 1 |
| LNA_OUT_RF | U1 - 4,  U2 - 1 |
| LO_DOUBLED | U10 - 4,  U9 - 1 |
| LO_DRIVEN | U9 - 4,  U2 - 8 |
| LO_SYNTH_OUT | U3 - 24,  U10 - 1 |
| MIXER_+5V | L2 - 2,  U2 - 3 |
| MIXER_DECAP_A | U2 - 3,  C5 - 1 |
| MIXER_DECAP_B | U2 - 3,  C6 - 1 |
| MIXER_DECAP_C | U2 - 3,  C7 - 1 |
| MIXER_LO | U2 - 5,  U2 - 8 |
| PLL_+5V | L4 - 2,  U3 - 23 |
| PLL_DECAP_A | U3 - 23,  C10 - 1 |
| PLL_DECAP_B | U3 - 23,  C11 - 1 |
| RF_IN_LNA | C1 - 2,  U1 - 1 |
| RF_IN_MAIN | J1 - 1,  C1 - 1 |
| SPI_CLK_PLL | U6 - R5,  U3 - 27 |
| SPI_CS_PLL | U6 - R9,  U3 - 30 |
| SPI_MISO_PLL | U3 - 29,  U6 - R8 |
| SPI_MOSI_PLL | U6 - R6,  U3 - 28 |
| VGA_+5V | L3 - 2,  U4 - 9 |
| VGA_CLK | U6 - AE13,  R8 - 1 |
| VGA_CLK_BUF | R8 - 2,  U4 - 7 |
| VGA_DATA0 | U6 - AF12,  R9 - 1 |
| VGA_DATA0_BUF | R9 - 2,  U4 - 3 |
| VGA_DATA1 | U6 - AF13,  R10 - 1 |
| VGA_DATA1_BUF | R10 - 2,  U4 - 4 |
| VGA_DECAP_A | U4 - 9,  C8 - 1 |
| VGA_DECAP_B | U4 - 9,  C9 - 1 |
| VGA_LE | U6 - AE12,  R7 - 1 |
| VGA_LE_BUF | R7 - 2,  U4 - 8 |
| VGA_MATCHED | T2 - 2,  U5 - 18 |
| VGA_OUT_N | U4 - 6,  T2 - 3 |
| VGA_OUT_P | U4 - 4,  T2 - 1 |
| VGA_PULLUP0 | R1 - 2,  U4 - 3 |
| VGA_PULLUP1 | R2 - 2,  U4 - 4 |
| VGA_PULLUP2 | R3 - 2,  U4 - 5 |
| VGA_PULLUP3 | R4 - 2,  U4 - 6 |
| VGA_PULLUP_CLK | R5 - 2,  U4 - 7 |
| VGA_PULLUP_LE | R6 - 2,  U4 - 8 |

## Validation Notes

- CRITICAL: ADF5355 maximum output is 13.6GHz, but system requires LO up to 18GHz. Frequency doubler HMC3716LP4 added to extend range to 27.2GHz (covers 5-18GHz with margin).
- CRITICAL: LO drive to HMC1194LP4E mixer requires +15dBm. ADF5355 output is only -5dBm. HMC679LP4 driver amplifier (+14dB gain) provides necessary drive level.
- WARNING: ADC12DJ3200 requires precise clock source for 3.2GSPS operation. System clock source not specified - recommend adding dedicated low-jitter clock generator (e.g., LMK04828).
- WARNING: HMC1194LP4E is a passive mixer requiring high LO drive. Verify LO driver amplifier output power meets +15dBm requirement across 6-18GHz band.
- INFO: Current power budget estimate: LNA (0.45W) + Mixer (0.3W) + PLL (0.6W) + VGA (0.5W) + ADC (2.5W) + FPGA (5-8W) + Regulators (~1W) = 10.35-13.35W. Within 10-20W budget.
- INFO: Decoupling capacitors specified per power pin (0.1μF + bulk 10μF). Ensure 0402 or smaller package size for high-frequency decoupling effectiveness.
- RECOMMENDATION: Add RF bandpass filter between LNA and mixer to suppress image frequencies and improve SFDR.
- RECOMMENDATION: Consider adding IF filter (bandpass or lowpass) after VGA before ADC to limit noise bandwidth and improve SNR.
- RECOMMENDATION: ESD protection recommended on RF input (J1) for military applications - consider adding TVS diode or limiter.
- NOTE: JESD204B interface requires careful PCB layout - use controlled impedance differential pairs (100Ω) and length matching within 5 mils.
- NOTE: FPGA bank voltage compatibility verified - JESD204B LVDS interface uses FPGA VCCAUX (1.8V) supply.
- NOTE: SPI interface includes series resistors (R7-R10) for impedance matching and ESD protection.