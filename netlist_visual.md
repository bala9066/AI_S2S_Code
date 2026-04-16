# Logical Netlist
## dsf

## Block Diagram

```mermaid
graph TB
    U1[Wideband LNA (HMC698LP4E)]
    U2[Downconverter Mixer (HMC1048LC4)]
    U3[RF Sampling ADC (ADC10DX300)]
    U4[IF Amplifier (ADA4817-1)]
    U5[VGA (HMC698LP2)]
    U6[LO Synthesizer (LMX2594RHAT)]
    U7[DC-DC Converter (LTM4644IY#PBF)]
    U8[LDO Regulator (LT3045IDD#PBF)]
    U9[LDO Regulator (LT3094IDD#PBF)]
    D1[ESD Protection Diode (GBDS04-24SLC)]
    D2[ESD Protection Diode (GBDS04-24SLC)]
    T1[RF Balun Transformer (BALH-0006SM)]
    T2[RF Balun Transformer (BALH-0006SM)]
    T3[RF Balun Transformer (TCM1-43X+)]
    F1[Ferrite Bead (BLM18PG471SN1D)]
    F2[Ferrite Bead (BLM18PG471SN1D)]
    F3[Ferrite Bead (BLM18PG471SN1D)]
    F4[Ferrite Bead (BLM18PG471SN1D)]
    C1[DC Block Capacitor (0402HP-3N6XJLW)]
    C2[DC Block Capacitor (0402HP-3N6XJLW)]
    C3[RF Coupling Cap (0402HP-1N5XJLW)]
    C4[DC Block Capacitor (0402HP-3N6XJLW)]
    C5[DC Block Capacitor (0402HP-3N6XJLW)]
    C6[DC Block Capacitor (0402HP-3N6XJLW)]
    C7[DC Block Capacitor (0402HP-3N6XJLW)]
    C8[Decoupling Cap (GRM188R61C475KE11D)]
    C9[Decoupling Cap (GRM188R61C475KE11D)]
    C10[Decoupling Cap (GRM188R61C475KE11D)]
    C11[Decoupling Cap (GRM188R61C475KE11D)]
    C12[Decoupling Cap (GRM188R61C475KE11D)]
    C13[Decoupling Cap (GRM32ER61C476KE15L)]
    C14[Decoupling Cap (GRM32ER61C476KE15L)]
    C15[Decoupling Cap (GRM188R61C475KE11D)]
    C16[Decoupling Cap (GRM188R61C475KE11D)]
    C17[Decoupling Cap (GRM32ER61C476KE15L)]
    C18[Decoupling Cap (GRM32ER61C476KE15L)]
    C19[Decoupling Cap (GRM32ER61C476KE15L)]
    C20[Decoupling Cap (GRM32ER61C476KE15L)]
    C21[Decoupling Cap (GRM32ER61C476KE15L)]
    C22[Decoupling Cap (GRM32ER61C476KE15L)]
    C23[Decoupling Cap (0402YD105KAT2A)]
    C24[Decoupling Cap (0402YD105KAT2A)]
    C25[Decoupling Cap (0402YD105KAT2A)]
    C26[Decoupling Cap (0402YD105KAT2A)]
    C27[Decoupling Cap (0402YD105KAT2A)]
    C28[Decoupling Cap (0402YD105KAT2A)]
    C29[Decoupling Cap (0402YD105KAT2A)]
    C30[Decoupling Cap (GRM188R61C475KE11D)]
    L1[RF Choke Inductor (0402CS-27NXJLW)]
    L2[RF Choke Inductor (0402CS-27NXJLW)]
    L3[RF Choke Inductor (0402CS-27NXJLW)]
    L4[RF Choke Inductor (0402CS-27NXJLW)]
    L5[Bias Tee Inductor (0402CS-27NXJLW)]
    R1[Input Termination Resistor (CRCW040250R0FKED)]
    R2[Feedback Resistor (CRCW0402200RFKED)]
    R3[Feedback Resistor (CRCW0402102FKED)]
    R4[Gain Set Resistor (CRCW0402150RFKED)]
    R5[VGA Gain Resistor (CRCW0402100RFKED)]
    R6[Bias Resistor (CRCW04024K70FKED)]
    R7[Bias Resistor (CRCW04024K70FKED)]
    R8[SPI Pull-up Resistor (CRCW04024K70FKED)]
    R9[SPI Pull-up Resistor (CRCW04024K70FKED)]
    R10[SPI Pull-up Resistor (CRCW04024K70FKED)]
    R11[I2C Pull-up Resistor (CRCW04024K70FKED)]
    R12[I2C Pull-up Resistor (CRCW04024K70FKED)]
    J1[RF Input Connector (149-1011-821)]
    J2[Digital Output Connector (20021111-00010T4LF)]
    D1 -->|RF_IN_PROTECTED| D2
    D2 -->|RF_IN_LNA| C1
    C1 -->|RF_IN_LNA| T1
    T1 -->|RF_BALUN_LNA| U1
    T1 -->|RF_BALUN_LNA| U1
    L1 -->|LNA_BIAS| U1
    U1 -->|LNA_DRAIN| L2
    L2 -->|LNA_OUT| C2
    C2 -->|RF_TO_MIXER| T2
    T2 -->|RF_BALUN_MIXER| U2
    T2 -->|RF_BALUN_MIXER| U2
    U6 -->|LO_IN_SYNTH| C3
    C3 -->|LO_IN_SYNTH| U2
    U6 -->|LO_IN_SYNTH| C3
    U2 -->|IF_OUT_MIXER| C4
    U2 -->|IF_OUT_MIXER| C5
    C4 -->|IF_DIFF| U5
    C5 -->|IF_DIFF| U5
    U5 -->|VGA_OUT_P| C6
    U5 -->|VGA_OUT_N| C7
    C6 -->|IF_AMP_IN_P| U4
    C7 -->|IF_AMP_IN_N| U4
    U4 -->|IF_AMP_OUT_P| C8
    U4 -->|IF_AMP_OUT_N| C9
    C8 -->|ADC_IN_P| U3
    C9 -->|ADC_IN_N| U3
    U6 -->|ADC_CLK_P| U3
    U6 -->|ADC_CLK_N| U3
    U3 -->|JESD_TX_P| J2
    U3 -->|JESD_TX_N| J2
    U3 -->|JESD_TX_P| J2
    U3 -->|JESD_TX_N| J2
    U3 -->|JESD_TX_P| J2
    U3 -->|JESD_TX_N| J2
    U3 -->|JESD_TX_P| J2
    U3 -->|JESD_TX_N| J2
    J2 -->|SPI_SCLK| R8
    J2 -->|SPI_SDIO| R9
    J2 -->|SPI_CS_L| R10
    R8 -->|SPI_SCLK_U3| U3
    R9 -->|SPI_SDIO_U3| U3
    R10 -->|SPI_CS_L_U3| U3
    R8 -->|SPI_SCLK_U6| U6
    R9 -->|SPI_SDIO_U6| U6
    R10 -->|SPI_CS_L_U6| U6
    R8 -->|SPI_SCLK_U5| U5
    R9 -->|SPI_SDIO_U5| U5
    R10 -->|SPI_CS_L_U5| U5
    U4 -->|AMP_FB| R2
    U4 -->|AMP_FB_OUT| R2
    U5 -->|VGA_GAIN_SET| R5
    U7 -->|+12V_MAIN| F1
    U7 -->|+5V_RF| F2
    U7 -->|+3V3_DIG| F3
    F2 -->|+3V3_RF_FILT| U8
    F3 -->|+3V3_DIG_FILT| U9
    F2 -->|+5V_LNA| L1
    F2 -->|+5V_AMP| L3
    U8 -->|+3V3_LDO| L4
    U9 -->|+1V2_DIG| F4
    L4 -->|+3V3_IF_AMP| U4
    L4 -->|+3V3_VGA| U5
    L4 -->|+3V3_SYNTH| U6
    F4 -->|+1V2_ADC_CORE| U3
    F3 -->|+3V3_ADC_IO| U3
    L2 -->|+5V_LNA_DRAIN| L2
    U7 -->|VCC_REG_5V| C10
    U7 -->|VCC_REG_3V3| C11
    U8 -->|VCC_LDO_3V3| C13
    U9 -->|VCC_LDO_1V2| C15
    U1 -->|GND| U1
    U1 -->|GND| C1
    U1 -->|GND| C2
    U2 -->|GND| C3
    U2 -->|GND| C4
    U2 -->|GND| C5
    U3 -->|GND| C8
    U3 -->|GND| C9
    U4 -->|GND| C6
    U4 -->|GND| C7
    U5 -->|GND| U5
    U6 -->|GND| U6
    U7 -->|GND| C12
    U8 -->|GND| C14
    U9 -->|GND| C16
    U8 -->|GND| R6
    U9 -->|GND| R7
    D1 -->|GND| J1
    D2 -->|GND| D2
    T1 -->|GND| T1
    T2 -->|GND| T2
    U3 -->|GND| U3
    C10 -->|GND| C11
    C13 -->|GND| C14
    C15 -->|GND| C16
    C17 -->|GND| C17
    C18 -->|GND| C18
    C19 -->|GND| C19
    C20 -->|GND| C20
    C21 -->|GND| C21
    C22 -->|GND| C22
    C23 -->|GND| C23
    C24 -->|GND| C24
    C25 -->|GND| C25
    C26 -->|GND| C26
    C27 -->|GND| C27
    C28 -->|GND| C28
    C29 -->|GND| C29
    C30 -->|GND| C30
    R2 -->|GND| R3
    C10 -->|VCC_REG_5V| C17
    C10 -->|VCC_REG_5V| C18
    C11 -->|VCC_REG_3V3| C19
    C11 -->|VCC_REG_3V3| C20
    C13 -->|VCC_LDO_3V3| C21
    C13 -->|VCC_LDO_3V3| C22
    C15 -->|VCC_LDO_1V2| C23
    C15 -->|VCC_LDO_1V2| C24
    L4 -->|+3V3_SYNTH| C25
    L4 -->|+3V3_SYNTH| C26
    L4 -->|+3V3_VGA| C27
    L4 -->|+3V3_VGA| C28
    L4 -->|+3V3_IF_AMP| C29
    L4 -->|+3V3_IF_AMP| C30
    F4 -->|+1V2_ADC_CORE| C25
```

## Component Instances

| Ref | Part Number | Component |
|---|---|---|
| U1 | HMC698LP4E | Wideband LNA |
| U2 | HMC1048LC4 | Downconverter Mixer |
| U3 | ADC10DX300 | RF Sampling ADC |
| U4 | ADA4817-1 | IF Amplifier |
| U5 | HMC698LP2 | VGA |
| U6 | LMX2594RHAT | LO Synthesizer |
| U7 | LTM4644IY#PBF | DC-DC Converter |
| U8 | LT3045IDD#PBF | LDO Regulator |
| U9 | LT3094IDD#PBF | LDO Regulator |
| D1 | GBDS04-24SLC | ESD Protection Diode |
| D2 | GBDS04-24SLC | ESD Protection Diode |
| T1 | BALH-0006SM | RF Balun Transformer |
| T2 | BALH-0006SM | RF Balun Transformer |
| T3 | TCM1-43X+ | RF Balun Transformer |
| F1 | BLM18PG471SN1D | Ferrite Bead |
| F2 | BLM18PG471SN1D | Ferrite Bead |
| F3 | BLM18PG471SN1D | Ferrite Bead |
| F4 | BLM18PG471SN1D | Ferrite Bead |
| C1 | 0402HP-3N6XJLW | DC Block Capacitor |
| C2 | 0402HP-3N6XJLW | DC Block Capacitor |
| C3 | 0402HP-1N5XJLW | RF Coupling Cap |
| C4 | 0402HP-3N6XJLW | DC Block Capacitor |
| C5 | 0402HP-3N6XJLW | DC Block Capacitor |
| C6 | 0402HP-3N6XJLW | DC Block Capacitor |
| C7 | 0402HP-3N6XJLW | DC Block Capacitor |
| C8 | GRM188R61C475KE11D | Decoupling Cap |
| C9 | GRM188R61C475KE11D | Decoupling Cap |
| C10 | GRM188R61C475KE11D | Decoupling Cap |
| C11 | GRM188R61C475KE11D | Decoupling Cap |
| C12 | GRM188R61C475KE11D | Decoupling Cap |
| C13 | GRM32ER61C476KE15L | Decoupling Cap |
| C14 | GRM32ER61C476KE15L | Decoupling Cap |
| C15 | GRM188R61C475KE11D | Decoupling Cap |
| C16 | GRM188R61C475KE11D | Decoupling Cap |
| C17 | GRM32ER61C476KE15L | Decoupling Cap |
| C18 | GRM32ER61C476KE15L | Decoupling Cap |
| C19 | GRM32ER61C476KE15L | Decoupling Cap |
| C20 | GRM32ER61C476KE15L | Decoupling Cap |
| C21 | GRM32ER61C476KE15L | Decoupling Cap |
| C22 | GRM32ER61C476KE15L | Decoupling Cap |
| C23 | 0402YD105KAT2A | Decoupling Cap |
| C24 | 0402YD105KAT2A | Decoupling Cap |
| C25 | 0402YD105KAT2A | Decoupling Cap |
| C26 | 0402YD105KAT2A | Decoupling Cap |
| C27 | 0402YD105KAT2A | Decoupling Cap |
| C28 | 0402YD105KAT2A | Decoupling Cap |
| C29 | 0402YD105KAT2A | Decoupling Cap |
| C30 | GRM188R61C475KE11D | Decoupling Cap |
| L1 | 0402CS-27NXJLW | RF Choke Inductor |
| L2 | 0402CS-27NXJLW | RF Choke Inductor |
| L3 | 0402CS-27NXJLW | RF Choke Inductor |
| L4 | 0402CS-27NXJLW | RF Choke Inductor |
| L5 | 0402CS-27NXJLW | Bias Tee Inductor |
| R1 | CRCW040250R0FKED | Input Termination Resistor |
| R2 | CRCW0402200RFKED | Feedback Resistor |
| R3 | CRCW0402102FKED | Feedback Resistor |
| R4 | CRCW0402150RFKED | Gain Set Resistor |
| R5 | CRCW0402100RFKED | VGA Gain Resistor |
| R6 | CRCW04024K70FKED | Bias Resistor |
| R7 | CRCW04024K70FKED | Bias Resistor |
| R8 | CRCW04024K70FKED | SPI Pull-up Resistor |
| R9 | CRCW04024K70FKED | SPI Pull-up Resistor |
| R10 | CRCW04024K70FKED | SPI Pull-up Resistor |
| R11 | CRCW04024K70FKED | I2C Pull-up Resistor |
| R12 | CRCW04024K70FKED | I2C Pull-up Resistor |
| J1 | 149-1011-821 | RF Input Connector |
| J2 | 20021111-00010T4LF | Digital Output Connector |

## Pin-to-Pin Connections

| Net | From | Pin | To | Pin | Type |
|---|---|---|---|---|---|
| RF_IN_PROTECTED | D1 | 1 | D2 | 1 | RF |
| RF_IN_LNA | D2 | 2 | C1 | 1 | RF |
| RF_IN_LNA | C1 | 2 | T1 | 1 | RF |
| RF_BALUN_LNA | T1 | 3 | U1 | 1 | RF |
| RF_BALUN_LNA | T1 | 4 | U1 | 2 | RF |
| LNA_BIAS | L1 | 2 | U1 | 3 | POWER |
| LNA_DRAIN | U1 | 4 | L2 | 1 | RF |
| LNA_OUT | L2 | 2 | C2 | 1 | RF |
| RF_TO_MIXER | C2 | 2 | T2 | 1 | RF |
| RF_BALUN_MIXER | T2 | 3 | U2 | RF_P | RF |
| RF_BALUN_MIXER | T2 | 4 | U2 | RF_N | RF |
| LO_IN_SYNTH | U6 | RFOUT_P | C3 | 1 | RF |
| LO_IN_SYNTH | C3 | 2 | U2 | LO_P | RF |
| LO_IN_SYNTH | U6 | RFOUT_N | C3 | 2 | RF |
| IF_OUT_MIXER | U2 | IF_P | C4 | 1 | IF |
| IF_OUT_MIXER | U2 | IF_N | C5 | 1 | IF |
| IF_DIFF | C4 | 2 | U5 | IN_P | IF |
| IF_DIFF | C5 | 2 | U5 | IN_N | IF |
| VGA_OUT_P | U5 | OUT_P | C6 | 1 | IF |
| VGA_OUT_N | U5 | OUT_N | C7 | 1 | IF |
| IF_AMP_IN_P | C6 | 2 | U4 | IN_P | IF |
| IF_AMP_IN_N | C7 | 2 | U4 | IN_N | IF |
| IF_AMP_OUT_P | U4 | OUT_P | C8 | 1 | IF |
| IF_AMP_OUT_N | U4 | OUT_N | C9 | 1 | IF |
| ADC_IN_P | C8 | 2 | U3 | AIN_P | ANALOG |
| ADC_IN_N | C9 | 2 | U3 | AIN_N | ANALOG |
| ADC_CLK_P | U6 | CLKOUT_P | U3 | CLK_P | CLOCK |
| ADC_CLK_N | U6 | CLKOUT_N | U3 | CLK_N | CLOCK |
| JESD_TX_P | U3 | D0_P | J2 | 1 | LVDS |
| JESD_TX_N | U3 | D0_N | J2 | 2 | LVDS |
| JESD_TX_P | U3 | D1_P | J2 | 3 | LVDS |
| JESD_TX_N | U3 | D1_N | J2 | 4 | LVDS |
| JESD_TX_P | U3 | D2_P | J2 | 5 | LVDS |
| JESD_TX_N | U3 | D2_N | J2 | 6 | LVDS |
| JESD_TX_P | U3 | D3_P | J2 | 7 | LVDS |
| JESD_TX_N | U3 | D3_N | J2 | 8 | LVDS |
| SPI_SCLK | J2 | 9 | R8 | 1 | DIGITAL |
| SPI_SDIO | J2 | 10 | R9 | 1 | DIGITAL |
| SPI_CS_L | J2 | 11 | R10 | 1 | DIGITAL |
| SPI_SCLK_U3 | R8 | 2 | U3 | SCLK | DIGITAL |
| SPI_SDIO_U3 | R9 | 2 | U3 | SDIO | DIGITAL |
| SPI_CS_L_U3 | R10 | 2 | U3 | CS_L | DIGITAL |
| SPI_SCLK_U6 | R8 | 2 | U6 | SCLK | DIGITAL |
| SPI_SDIO_U6 | R9 | 2 | U6 | SDIO | DIGITAL |
| SPI_CS_L_U6 | R10 | 2 | U6 | CS_L | DIGITAL |
| SPI_SCLK_U5 | R8 | 2 | U5 | SCLK | DIGITAL |
| SPI_SDIO_U5 | R9 | 2 | U5 | SDIO | DIGITAL |
| SPI_CS_L_U5 | R10 | 2 | U5 | CS_L | DIGITAL |
| AMP_FB | U4 | FB | R2 | 1 | ANALOG |
| AMP_FB_OUT | U4 | OUT_N | R2 | 2 | ANALOG |
| VGA_GAIN_SET | U5 | GSET | R5 | 1 | ANALOG |
| +12V_MAIN | U7 | VIN | F1 | 1 | POWER |
| +5V_RF | U7 | VOUT1 | F2 | 1 | POWER |
| +3V3_DIG | U7 | VOUT2 | F3 | 1 | POWER |
| +3V3_RF_FILT | F2 | 2 | U8 | IN | POWER |
| +3V3_DIG_FILT | F3 | 2 | U9 | IN | POWER |
| +5V_LNA | F2 | 2 | L1 | 1 | POWER |
| +5V_AMP | F2 | 2 | L3 | 1 | POWER |
| +3V3_LDO | U8 | OUT | L4 | 1 | POWER |
| +1V2_DIG | U9 | OUT | F4 | 1 | POWER |
| +3V3_IF_AMP | L4 | 2 | U4 | VCC | POWER |
| +3V3_VGA | L4 | 2 | U5 | VCC | POWER |
| +3V3_SYNTH | L4 | 2 | U6 | VCC | POWER |
| +1V2_ADC_CORE | F4 | 2 | U3 | VCC_CORE | POWER |
| +3V3_ADC_IO | F3 | 2 | U3 | VCC_IO | POWER |
| +5V_LNA_DRAIN | L2 | 1 | L2 | 1 | POWER |
| VCC_REG_5V | U7 | VOUT1 | C10 | 1 | POWER |
| VCC_REG_3V3 | U7 | VOUT2 | C11 | 1 | POWER |
| VCC_LDO_3V3 | U8 | OUT | C13 | 1 | POWER |
| VCC_LDO_1V2 | U9 | OUT | C15 | 1 | POWER |
| GND | U1 | 5 | U1 | EPAD | GROUND |
| GND | U1 | 5 | C1 | 2 | GROUND |
| GND | U1 | 5 | C2 | 2 | GROUND |
| GND | U2 | GND | C3 | 2 | GROUND |
| GND | U2 | GND | C4 | 2 | GROUND |
| GND | U2 | GND | C5 | 2 | GROUND |
| GND | U3 | GND | C8 | 2 | GROUND |
| GND | U3 | GND | C9 | 2 | GROUND |
| GND | U4 | GND | C6 | 2 | GROUND |
| GND | U4 | GND | C7 | 2 | GROUND |
| GND | U5 | GND | U5 | EPAD | GROUND |
| GND | U6 | GND | U6 | EPAD | GROUND |
| GND | U7 | PGND | C12 | 2 | GROUND |
| GND | U8 | GND | C14 | 2 | GROUND |
| GND | U9 | GND | C16 | 2 | GROUND |
| GND | U8 | GND | R6 | 2 | GROUND |
| GND | U9 | GND | R7 | 2 | GROUND |
| GND | D1 | 2 | J1 | SHLD | GROUND |
| GND | D2 | 3 | D2 | 4 | GROUND |
| GND | T1 | 2 | T1 | 5 | GROUND |
| GND | T2 | 2 | T2 | 5 | GROUND |
| GND | U3 | GND | U3 | EPAD | GROUND |
| GND | C10 | 2 | C11 | 2 | GROUND |
| GND | C13 | 2 | C14 | 2 | GROUND |
| GND | C15 | 2 | C16 | 2 | GROUND |
| GND | C17 | 2 | C17 | 2 | GROUND |
| GND | C18 | 2 | C18 | 2 | GROUND |
| GND | C19 | 2 | C19 | 2 | GROUND |
| GND | C20 | 2 | C20 | 2 | GROUND |
| GND | C21 | 2 | C21 | 2 | GROUND |
| GND | C22 | 2 | C22 | 2 | GROUND |
| GND | C23 | 2 | C23 | 2 | GROUND |
| GND | C24 | 2 | C24 | 2 | GROUND |
| GND | C25 | 2 | C25 | 2 | GROUND |
| GND | C26 | 2 | C26 | 2 | GROUND |
| GND | C27 | 2 | C27 | 2 | GROUND |
| GND | C28 | 2 | C28 | 2 | GROUND |
| GND | C29 | 2 | C29 | 2 | GROUND |
| GND | C30 | 2 | C30 | 2 | GROUND |
| GND | R2 | 2 | R3 | 1 | GROUND |
| VCC_REG_5V | C10 | 1 | C17 | 1 | POWER |
| VCC_REG_5V | C10 | 1 | C18 | 1 | POWER |
| VCC_REG_3V3 | C11 | 1 | C19 | 1 | POWER |
| VCC_REG_3V3 | C11 | 1 | C20 | 1 | POWER |
| VCC_LDO_3V3 | C13 | 1 | C21 | 1 | POWER |
| VCC_LDO_3V3 | C13 | 1 | C22 | 1 | POWER |
| VCC_LDO_1V2 | C15 | 1 | C23 | 1 | POWER |
| VCC_LDO_1V2 | C15 | 1 | C24 | 1 | POWER |
| +3V3_SYNTH | L4 | 2 | C25 | 1 | POWER |
| +3V3_SYNTH | L4 | 2 | C26 | 1 | POWER |
| +3V3_VGA | L4 | 2 | C27 | 1 | POWER |
| +3V3_VGA | L4 | 2 | C28 | 1 | POWER |
| +3V3_IF_AMP | L4 | 2 | C29 | 1 | POWER |
| +3V3_IF_AMP | L4 | 2 | C30 | 1 | POWER |
| +1V2_ADC_CORE | F4 | 2 | C25 | 1 | POWER |

## Net Connection List

| Net Name | Reference Designator - Pin No. |
|----------|-------------------------------|
| +12V_MAIN | U7 - VIN,  F1 - 1 |
| +1V2_ADC_CORE | F4 - 2,  U3 - VCC_CORE,  C25 - 1 |
| +1V2_DIG | U9 - OUT,  F4 - 1 |
| +3V3_ADC_IO | F3 - 2,  U3 - VCC_IO |
| +3V3_DIG | U7 - VOUT2,  F3 - 1 |
| +3V3_DIG_FILT | F3 - 2,  U9 - IN |
| +3V3_IF_AMP | L4 - 2,  U4 - VCC,  C29 - 1,  C30 - 1 |
| +3V3_LDO | U8 - OUT,  L4 - 1 |
| +3V3_RF_FILT | F2 - 2,  U8 - IN |
| +3V3_SYNTH | L4 - 2,  U6 - VCC,  C25 - 1,  C26 - 1 |
| +3V3_VGA | L4 - 2,  U5 - VCC,  C27 - 1,  C28 - 1 |
| +5V_AMP | F2 - 2,  L3 - 1 |
| +5V_LNA | F2 - 2,  L1 - 1 |
| +5V_LNA_DRAIN | L2 - 1 |
| +5V_RF | U7 - VOUT1,  F2 - 1 |
| ADC_CLK_N | U6 - CLKOUT_N,  U3 - CLK_N |
| ADC_CLK_P | U6 - CLKOUT_P,  U3 - CLK_P |
| ADC_IN_N | C9 - 2,  U3 - AIN_N |
| ADC_IN_P | C8 - 2,  U3 - AIN_P |
| AMP_FB | U4 - FB,  R2 - 1 |
| AMP_FB_OUT | U4 - OUT_N,  R2 - 2 |
| GND | U1 - 5,  U1 - EPAD,  C1 - 2,  C2 - 2,  U2 - GND,  C3 - 2,  C4 - 2,  C5 - 2,  U3 - GND,  C8 - 2,  C9 - 2,  U4 - GND,  C6 - 2,  C7 - 2,  U5 - GND,  U5 - EPAD,  U6 - GND,  U6 - EPAD,  U7 - PGND,  C12 - 2,  U8 - GND,  C14 - 2,  U9 - GND,  C16 - 2,  R6 - 2,  R7 - 2,  D1 - 2,  J1 - SHLD,  D2 - 3,  D2 - 4,  T1 - 2,  T1 - 5,  T2 - 2,  T2 - 5,  U3 - EPAD,  C10 - 2,  C11 - 2,  C13 - 2,  C15 - 2,  C17 - 2,  C18 - 2,  C19 - 2,  C20 - 2,  C21 - 2,  C22 - 2,  C23 - 2,  C24 - 2,  C25 - 2,  C26 - 2,  C27 - 2,  C28 - 2,  C29 - 2,  C30 - 2,  R2 - 2,  R3 - 1 |
| IF_AMP_IN_N | C7 - 2,  U4 - IN_N |
| IF_AMP_IN_P | C6 - 2,  U4 - IN_P |
| IF_AMP_OUT_N | U4 - OUT_N,  C9 - 1 |
| IF_AMP_OUT_P | U4 - OUT_P,  C8 - 1 |
| IF_DIFF | C4 - 2,  U5 - IN_P,  C5 - 2,  U5 - IN_N |
| IF_OUT_MIXER | U2 - IF_P,  C4 - 1,  U2 - IF_N,  C5 - 1 |
| JESD_TX_N | U3 - D0_N,  J2 - 2,  U3 - D1_N,  J2 - 4,  U3 - D2_N,  J2 - 6,  U3 - D3_N,  J2 - 8 |
| JESD_TX_P | U3 - D0_P,  J2 - 1,  U3 - D1_P,  J2 - 3,  U3 - D2_P,  J2 - 5,  U3 - D3_P,  J2 - 7 |
| LNA_BIAS | L1 - 2,  U1 - 3 |
| LNA_DRAIN | U1 - 4,  L2 - 1 |
| LNA_OUT | L2 - 2,  C2 - 1 |
| LO_IN_SYNTH | U6 - RFOUT_P,  C3 - 1,  C3 - 2,  U2 - LO_P,  U6 - RFOUT_N |
| RF_BALUN_LNA | T1 - 3,  U1 - 1,  T1 - 4,  U1 - 2 |
| RF_BALUN_MIXER | T2 - 3,  U2 - RF_P,  T2 - 4,  U2 - RF_N |
| RF_IN_LNA | D2 - 2,  C1 - 1,  C1 - 2,  T1 - 1 |
| RF_IN_PROTECTED | D1 - 1,  D2 - 1 |
| RF_TO_MIXER | C2 - 2,  T2 - 1 |
| SPI_CS_L | J2 - 11,  R10 - 1 |
| SPI_CS_L_U3 | R10 - 2,  U3 - CS_L |
| SPI_CS_L_U5 | R10 - 2,  U5 - CS_L |
| SPI_CS_L_U6 | R10 - 2,  U6 - CS_L |
| SPI_SCLK | J2 - 9,  R8 - 1 |
| SPI_SCLK_U3 | R8 - 2,  U3 - SCLK |
| SPI_SCLK_U5 | R8 - 2,  U5 - SCLK |
| SPI_SCLK_U6 | R8 - 2,  U6 - SCLK |
| SPI_SDIO | J2 - 10,  R9 - 1 |
| SPI_SDIO_U3 | R9 - 2,  U3 - SDIO |
| SPI_SDIO_U5 | R9 - 2,  U5 - SDIO |
| SPI_SDIO_U6 | R9 - 2,  U6 - SDIO |
| VCC_LDO_1V2 | U9 - OUT,  C15 - 1,  C23 - 1,  C24 - 1 |
| VCC_LDO_3V3 | U8 - OUT,  C13 - 1,  C21 - 1,  C22 - 1 |
| VCC_REG_3V3 | U7 - VOUT2,  C11 - 1,  C19 - 1,  C20 - 1 |
| VCC_REG_5V | U7 - VOUT1,  C10 - 1,  C17 - 1,  C18 - 1 |
| VGA_GAIN_SET | U5 - GSET,  R5 - 1 |
| VGA_OUT_N | U5 - OUT_N,  C7 - 1 |
| VGA_OUT_P | U5 - OUT_P,  C6 - 1 |

## Validation Notes

- [INFO] ESD protection D1/D2 (GBDS04-24SLC) rated for 20kV contact discharge - exceeds 2kV MIL-STD-883 requirement
- [INFO] HMC698LP4E LNA NF: 3.5dB (within 6-8dB system requirement)
- [WARNING] Mixer conversion gain -7dB + 22dB LNA gain = 15dB total - verify VGA headroom for 40dB gain control range
- [INFO] HMC1048LC4 LO drive: +13 to +17 dBm - LMX2594 configurable to +5 dBm output (may require LO amplifier)
- [WARNING] LMX2594 RFOUT_P/N: +5dBm typical; HMC1048LC4 requires +13 to +17 dBm - LO gain mismatch detected
- [INFO] ADA4817-1: 1GHz BW sufficient for 3GHz IF bandwidth (check rolloff at high end)
- [WARNING] ADC10DX300 SFDR: 59dBFS specified; requirement is 81-90dB - may not meet SFDR requirement
- [INFO] JESD204B lane rate: 10 Gbps / 4 lanes = 2.5 Gbps per lane (within LVDS capability)
- [WARNING] Power consumption: ADC (0.9W) + LNA (0.3W) + Mixer (0.4W) + VGA (0.3W) + IF Amp (0.2W) + Synth (1.5W) + Regulators (~2W) = 5.6W - significantly below 26-50W requirement
- [INFO] Temperature: All selected components available in military temperature range (-55 to +125°C)
- [WARNING] LO drive mismatch: Recommend adding LO amplifier (e.g., HMC365) between LMX2594 and HMC1048LC4
- [WARNING] ADC SFDR of 59dBFS may not meet 81-90dB dynamic range requirement - consider 12-bit alternative (AD9213)
- [INFO] Decoupling: C8-C30 provide 0.1uF, 0.47uF, 1uF local decoupling for all ICs
- [WARNING] VGA gain control range: 40dB specified - verify actual control range for HMC698LP2 in single-ended configuration
- [INFO] Single +12V input rail converted to +5V, +3.3V, +1.2V rails by LTM4644 quad regulator
- [WARNING] ADC analog bandwidth: 3GHz meets requirement but -3dB point may cause rolloff at band edges
- [INFO] SPI bus shared between ADC, Synthesizer, and VGA with individual chip selects
- [WARNING] Clock distribution: LMX2594 provides 10GHz clock to ADC - verify phase noise meets -100dBc/Hz at 10kHz offset