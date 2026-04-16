# Logical Netlist
## khgk

## Block Diagram

```mermaid
graph TB
    U1[Wideband LNA (TGA4943-SM)]
    U2[Digital Variable Gain Amplifier (HMC698LP4)]
    U3[Wideband I/Q Mixer (HMC525LC4)]
    U4[Wideband Synthesizer/PLL (LMX2594RHAT)]
    U5[Quad-Channel JESD204B ADC (ADC12J4000IRGZT)]
    U6[3.3V Rail Controller (LTC1923EMSE-3.3#PBF)]
    U7[1.8V Rail Controller (LTC1923EMSE-1.8#PBF)]
    U8[1.2V Rail Controller (LT3045EMSE-1.2#PBF)]
    U9[-5V Rail Controller (LT3094EMSE-5#PBF)]
    U10[Power Monitor (LTC2945IDD#PBF)]
    U11[Housekeeping MCU (ATtiny1606-MU)]
    U12[RF Transformer (I) (ADT3-1T+)]
    U13[RF Transformer (Q) (ADT3-1T+)]
    U14[IF Amplifier + Anti-Alias Filter (LTC6404-14)]
    L1[Input Common Mode Choke (DLW43SH101XK2L)]
    J1[SMA RF Input Connector (132377-12)]
    J2[JESD204 High-Speed Samtec (SS-52645-08-12)]
    J3[Control/Power Samtec (SS-52645-02-12)]
    Q1[RF Path MOSFET Switch (FDN340P)]
    R1[Input 50Ω to GND (ERA-3AEB103V)]
    R2[LNA Input Bias (ERA-3AEB103V)]
    R3[LNA Gate Bias (ERA-3AEB103V)]
    R4[Source Degen (CRCW251210K0FKEG)]
    R5[RF Path Gate Pull-down (ERA-3AEB103V)]
    R6[I-channel ADC termination (ERA-3AEB753V)]
    R7[I-channel ADC termination (ERA-3AEB753V)]
    R8[Q-channel ADC termination (ERA-3AEB753V)]
    R9[Q-channel ADC termination (ERA-3AEB753V)]
    R10[ADC VCM filter (ERA-2AEB237V)]
    R11[ADC VCM filter (ERA-2AEB237V)]
    R12[I2C SDA pullup (ERJ-3GEYJ103V)]
    R13[I2C SCL pullup (ERJ-3GEYJ103V)]
    R14[SPI SDI pullup (CRCW251210K0FKEG)]
    R15[SYNC term (CRCW25124K70FKEG)]
    R16[MOSFET gate pulldown (CRCW2512100KFKTA)]
    R17[MOSFET gate resistor (CRCW25124K70FKEG)]
    C1[Input DC block (GCM1555C1H103JA16J)]
    C2[LNA decoupling (UPY-GP2A101MHH1)]
    C3[DVGA VDD decoupling (UPY-GP2A221MHH1)]
    C4[DVGA VEE decoupling (UPY-GP2A221MHH1)]
    C5[Mixer Vdd decoupling (GQM1555C1E470JB12D)]
    C6[Mixer LO decoupling (UPY-GP2A101MHH1)]
    C7[PLL Vdd decoupling (UPY-GP2A101MHH1)]
    C8[PLL CP decoupling (UPY-GP2A101MHH1)]
    C9[ADC AVDD decoupling (GQM2195C2E470JV12D)]
    C10[ADC AVDD decoupling (UPY-GP2A101MHH1)]
    C11[ADC DVDD decoupling (GQM2195C2E470JV12D)]
    C12[ADC DVDD decoupling (UPY-GP2A101MHH1)]
    C13[3.3V bulk cap (GQM2195C2E100KV12D)]
    C14[1.8V bulk cap (GQM2195C2E100KV12D)]
    C15[1.2V bulk cap (GQM2195C2E100KV12D)]
    C16[-5V bulk cap (GQM2195C2E100KV12D)]
    C17[Vdd output filter (UPY-GP2A101MHH1)]
    C18[Ctrl plane decoupling (UPY-GP2A101MHH1)]
    C19[Ctrl plane decoupling (UPY-GP2A101MHH1)]
    C20[Ctrl plane decoupling (UPY-GP2A101MHH1)]
    L2[LNA gate choke (MLG1608SR18JT000)]
    L3[RF path ferrite bead (MLF2016DR56DT000)]
    L4[Digital rail bead (MLF2016DR56DT000)]
    L5[Digital rail bead (MLF2016DR56DT000)]
    J1 -->|RF_IN| C1
    C1 -->|RF_IN_BLK| Q1
    Q1 -->|RF_IN_SW| U1
    U1 -->|LNA_OUT| U2
    U2 -->|DVGA_OUT| U3
    U4 -->|LO_DRV| U3
    U3 -->|MIX_I_P| U12
    U3 -->|MIX_I_N| U12
    U3 -->|MIX_Q_P| U13
    U3 -->|MIX_Q_N| U13
    U12 -->|I_AMP_P| U14
    U12 -->|I_AMP_N| U14
    U13 -->|Q_AMP_P| U14
    U13 -->|Q_AMP_N| U14
    U14 -->|ADC_I_P| U5
    U14 -->|ADC_I_N| U5
    U14 -->|ADC_Q_P| U5
    U14 -->|ADC_Q_N| U5
    U4 -->|SYS_CLK_P| U5
    U4 -->|SYS_CLK_N| U5
    U5 -->|JESD0_P| J2
    U5 -->|JESD0_N| J2
    U5 -->|JESD1_P| J2
    U5 -->|JESD1_N| J2
    U5 -->|JESD2_P| J2
    U5 -->|JESD2_N| J2
    U5 -->|JESD3_P| J2
    U5 -->|JESD3_N| J2
    U5 -->|JESD_SYNC_P| J2
    U5 -->|JESD_SYNC_N| J2
    J3 -->|SPI_SCK| U11
    U11 -->|SPI_SCK_PLL| U4
    U11 -->|SPI_SCK_ADC| U5
    U11 -->|SPI_SCK_DVGA| U2
    J3 -->|SPI_SDI| U11
    U11 -->|SPI_SDO| J3
    U11 -->|SPI_CS_PLL| U4
    U11 -->|SPI_CS_ADC| U5
    U11 -->|SPI_CS_DVGA| U2
    J3 -->|I2C_SDA| U11
    J3 -->|I2C_SCL| U11
    U11 -->|I2C_SDA_MON| U10
    U11 -->|I2C_SCL_MON| U10
    J3 -->|VCC_12V| L1
    L1 -->|VCC_IN| U10
    U10 -->|VCC_IN| U6
    U6 -->|VCC_IN| U7
    U7 -->|VCC_IN| U8
    U6 -->|VCC_3V3| U4
    U6 -->|VCC_3V3| U2
    U6 -->|VCC_3V3| U11
    U7 -->|VCC_1V8| U5
    U7 -->|VCC_1V8| U10
    U8 -->|VCC_1V2| U5
    L1 -->|VCC_12V_RF| L3
    L3 -->|VCC_LNA| U1
    L3 -->|VCC_MIX| U3
    U9 -->|VEE_5V| U2
    U1 -->|GND| U2
    U2 -->|GND| U3
    U3 -->|GND| U4
    U4 -->|GND| U5
    U5 -->|GND| U11
    C1 -->|GND| R1
    C2 -->|GND| U1
    C3 -->|GND| U2
    C4 -->|GND| U2
    C5 -->|GND| U3
    C9 -->|GND| U5
    C11 -->|GND| U5
    R10 -->|GND| U5
    R2 -->|LNA_GATE_BIAS| L2
    L2 -->|LNA_GATE| U1
    U11 -->|RF_SW_GATE| R17
    R17 -->|RF_SW_DRV| Q1
```

## Component Instances

| Ref | Part Number | Component |
|---|---|---|
| U1 | TGA4943-SM | Wideband LNA |
| U2 | HMC698LP4 | Digital Variable Gain Amplifier |
| U3 | HMC525LC4 | Wideband I/Q Mixer |
| U4 | LMX2594RHAT | Wideband Synthesizer/PLL |
| U5 | ADC12J4000IRGZT | Quad-Channel JESD204B ADC |
| U6 | LTC1923EMSE-3.3#PBF | 3.3V Rail Controller |
| U7 | LTC1923EMSE-1.8#PBF | 1.8V Rail Controller |
| U8 | LT3045EMSE-1.2#PBF | 1.2V Rail Controller |
| U9 | LT3094EMSE-5#PBF | -5V Rail Controller |
| U10 | LTC2945IDD#PBF | Power Monitor |
| U11 | ATtiny1606-MU | Housekeeping MCU |
| U12 | ADT3-1T+ | RF Transformer (I) |
| U13 | ADT3-1T+ | RF Transformer (Q) |
| U14 | LTC6404-14 | IF Amplifier + Anti-Alias Filter |
| L1 | DLW43SH101XK2L | Input Common Mode Choke |
| J1 | 132377-12 | SMA RF Input Connector |
| J2 | SS-52645-08-12 | JESD204 High-Speed Samtec |
| J3 | SS-52645-02-12 | Control/Power Samtec |
| Q1 | FDN340P | RF Path MOSFET Switch |
| R1 | ERA-3AEB103V | Input 50Ω to GND |
| R2 | ERA-3AEB103V | LNA Input Bias |
| R3 | ERA-3AEB103V | LNA Gate Bias |
| R4 | CRCW251210K0FKEG | Source Degen |
| R5 | ERA-3AEB103V | RF Path Gate Pull-down |
| R6 | ERA-3AEB753V | I-channel ADC termination |
| R7 | ERA-3AEB753V | I-channel ADC termination |
| R8 | ERA-3AEB753V | Q-channel ADC termination |
| R9 | ERA-3AEB753V | Q-channel ADC termination |
| R10 | ERA-2AEB237V | ADC VCM filter |
| R11 | ERA-2AEB237V | ADC VCM filter |
| R12 | ERJ-3GEYJ103V | I2C SDA pullup |
| R13 | ERJ-3GEYJ103V | I2C SCL pullup |
| R14 | CRCW251210K0FKEG | SPI SDI pullup |
| R15 | CRCW25124K70FKEG | SYNC term |
| R16 | CRCW2512100KFKTA | MOSFET gate pulldown |
| R17 | CRCW25124K70FKEG | MOSFET gate resistor |
| C1 | GCM1555C1H103JA16J | Input DC block |
| C2 | UPY-GP2A101MHH1 | LNA decoupling |
| C3 | UPY-GP2A221MHH1 | DVGA VDD decoupling |
| C4 | UPY-GP2A221MHH1 | DVGA VEE decoupling |
| C5 | GQM1555C1E470JB12D | Mixer Vdd decoupling |
| C6 | UPY-GP2A101MHH1 | Mixer LO decoupling |
| C7 | UPY-GP2A101MHH1 | PLL Vdd decoupling |
| C8 | UPY-GP2A101MHH1 | PLL CP decoupling |
| C9 | GQM2195C2E470JV12D | ADC AVDD decoupling |
| C10 | UPY-GP2A101MHH1 | ADC AVDD decoupling |
| C11 | GQM2195C2E470JV12D | ADC DVDD decoupling |
| C12 | UPY-GP2A101MHH1 | ADC DVDD decoupling |
| C13 | GQM2195C2E100KV12D | 3.3V bulk cap |
| C14 | GQM2195C2E100KV12D | 1.8V bulk cap |
| C15 | GQM2195C2E100KV12D | 1.2V bulk cap |
| C16 | GQM2195C2E100KV12D | -5V bulk cap |
| C17 | UPY-GP2A101MHH1 | Vdd output filter |
| C18 | UPY-GP2A101MHH1 | Ctrl plane decoupling |
| C19 | UPY-GP2A101MHH1 | Ctrl plane decoupling |
| C20 | UPY-GP2A101MHH1 | Ctrl plane decoupling |
| L2 | MLG1608SR18JT000 | LNA gate choke |
| L3 | MLF2016DR56DT000 | RF path ferrite bead |
| L4 | MLF2016DR56DT000 | Digital rail bead |
| L5 | MLF2016DR56DT000 | Digital rail bead |

## Pin-to-Pin Connections

| Net | From | Pin | To | Pin | Type |
|---|---|---|---|---|---|
| RF_IN | J1 | SIG | C1 | 1 | RF |
| RF_IN_BLK | C1 | 2 | Q1 | D | RF |
| RF_IN_SW | Q1 | S | U1 | RF_IN | RF |
| LNA_OUT | U1 | RF_OUT | U2 | RF_IN | RF |
| DVGA_OUT | U2 | RF_OUT | U3 | RF_IN | RF |
| LO_DRV | U4 | RF_OUT_A | U3 | LO_IN | LO |
| MIX_I_P | U3 | I_P | U12 | 1 | IF |
| MIX_I_N | U3 | I_N | U12 | 3 | IF |
| MIX_Q_P | U3 | Q_P | U13 | 1 | IF |
| MIX_Q_N | U3 | Q_N | U13 | 3 | IF |
| I_AMP_P | U12 | 2 | U14 | IN_P | IF |
| I_AMP_N | U12 | 4 | U14 | IN_N | IF |
| Q_AMP_P | U13 | 2 | U14 | IN_P2 | IF |
| Q_AMP_N | U13 | 4 | U14 | IN_N2 | IF |
| ADC_I_P | U14 | OUT_P | U5 | D0P | analog |
| ADC_I_N | U14 | OUT_N | U5 | D0N | analog |
| ADC_Q_P | U14 | OUT_P2 | U5 | D1P | analog |
| ADC_Q_N | U14 | OUT_N2 | U5 | D1N | analog |
| SYS_CLK_P | U4 | CLK_OUT | U5 | CLKIN_P | clock |
| SYS_CLK_N | U4 | CLK_OUT_N | U5 | CLKIN_N | clock |
| JESD0_P | U5 | LANE0_P | J2 | 1 | digital |
| JESD0_N | U5 | LANE0_N | J2 | 2 | digital |
| JESD1_P | U5 | LANE1_P | J2 | 3 | digital |
| JESD1_N | U5 | LANE1_N | J2 | 4 | digital |
| JESD2_P | U5 | LANE2_P | J2 | 5 | digital |
| JESD2_N | U5 | LANE2_N | J2 | 6 | digital |
| JESD3_P | U5 | LANE3_P | J2 | 7 | digital |
| JESD3_N | U5 | LANE3_N | J2 | 8 | digital |
| JESD_SYNC_P | U5 | SYNC_P | J2 | 9 | digital |
| JESD_SYNC_N | U5 | SYNC_N | J2 | 10 | digital |
| SPI_SCK | J3 | 3 | U11 | 4 | digital |
| SPI_SCK_PLL | U11 | 5 | U4 | SCLK | digital |
| SPI_SCK_ADC | U11 | 5 | U5 | SCLK | digital |
| SPI_SCK_DVGA | U11 | 5 | U2 | SCLK | digital |
| SPI_SDI | J3 | 4 | U11 | 6 | digital |
| SPI_SDO | U11 | 7 | J3 | 5 | digital |
| SPI_CS_PLL | U11 | 8 | U4 | CS_N | digital |
| SPI_CS_ADC | U11 | 9 | U5 | CS_N | digital |
| SPI_CS_DVGA | U11 | 10 | U2 | CS_N | digital |
| I2C_SDA | J3 | 6 | U11 | 14 | digital |
| I2C_SCL | J3 | 7 | U11 | 15 | digital |
| I2C_SDA_MON | U11 | 14 | U10 | SDA | digital |
| I2C_SCL_MON | U11 | 15 | U10 | SCL | digital |
| VCC_12V | J3 | 1 | L1 | 1 | power |
| VCC_IN | L1 | 2 | U10 | VDD | power |
| VCC_IN | U10 | VDD | U6 | VIN | power |
| VCC_IN | U6 | VIN | U7 | VIN | power |
| VCC_IN | U7 | VIN | U8 | VIN | power |
| VCC_3V3 | U6 | VOUT | U4 | VDD | power |
| VCC_3V3 | U6 | VOUT | U2 | VDD | power |
| VCC_3V3 | U6 | VOUT | U11 | 1 | power |
| VCC_1V8 | U7 | VOUT | U5 | DVDD | power |
| VCC_1V8 | U7 | VOUT | U10 | VDD_IO | power |
| VCC_1V2 | U8 | VOUT | U5 | AVDD | power |
| VCC_12V_RF | L1 | 2 | L3 | 1 | power |
| VCC_LNA | L3 | 2 | U1 | VDD | power |
| VCC_MIX | L3 | 2 | U3 | VDD | power |
| VEE_5V | U9 | VOUT | U2 | VEE | power |
| GND | U1 | GND | U2 | GND | ground |
| GND | U2 | GND | U3 | GND | ground |
| GND | U3 | GND | U4 | GND | ground |
| GND | U4 | GND | U5 | GND | ground |
| GND | U5 | GND | U11 | GND | ground |
| GND | C1 | 2 | R1 | 2 | ground |
| GND | C2 | 2 | U1 | GND | ground |
| GND | C3 | 2 | U2 | GND | ground |
| GND | C4 | 2 | U2 | GND | ground |
| GND | C5 | 2 | U3 | GND | ground |
| GND | C9 | 2 | U5 | GND | ground |
| GND | C11 | 2 | U5 | GND | ground |
| GND | R10 | 2 | U5 | VCM | ground |
| LNA_GATE_BIAS | R2 | 1 | L2 | 1 | analog |
| LNA_GATE | L2 | 2 | U1 | GATE | analog |
| RF_SW_GATE | U11 | 12 | R17 | 1 | digital |
| RF_SW_DRV | R17 | 2 | Q1 | G | digital |

## Net Connection List

| Net Name | Reference Designator - Pin No. |
|----------|-------------------------------|
| ADC_I_N | U14 - OUT_N,  U5 - D0N |
| ADC_I_P | U14 - OUT_P,  U5 - D0P |
| ADC_Q_N | U14 - OUT_N2,  U5 - D1N |
| ADC_Q_P | U14 - OUT_P2,  U5 - D1P |
| DVGA_OUT | U2 - RF_OUT,  U3 - RF_IN |
| GND | U1 - GND,  U2 - GND,  U3 - GND,  U4 - GND,  U5 - GND,  U11 - GND,  C1 - 2,  R1 - 2,  C2 - 2,  C3 - 2,  C4 - 2,  C5 - 2,  C9 - 2,  C11 - 2,  R10 - 2,  U5 - VCM |
| I2C_SCL | J3 - 7,  U11 - 15 |
| I2C_SCL_MON | U11 - 15,  U10 - SCL |
| I2C_SDA | J3 - 6,  U11 - 14 |
| I2C_SDA_MON | U11 - 14,  U10 - SDA |
| I_AMP_N | U12 - 4,  U14 - IN_N |
| I_AMP_P | U12 - 2,  U14 - IN_P |
| JESD0_N | U5 - LANE0_N,  J2 - 2 |
| JESD0_P | U5 - LANE0_P,  J2 - 1 |
| JESD1_N | U5 - LANE1_N,  J2 - 4 |
| JESD1_P | U5 - LANE1_P,  J2 - 3 |
| JESD2_N | U5 - LANE2_N,  J2 - 6 |
| JESD2_P | U5 - LANE2_P,  J2 - 5 |
| JESD3_N | U5 - LANE3_N,  J2 - 8 |
| JESD3_P | U5 - LANE3_P,  J2 - 7 |
| JESD_SYNC_N | U5 - SYNC_N,  J2 - 10 |
| JESD_SYNC_P | U5 - SYNC_P,  J2 - 9 |
| LNA_GATE | L2 - 2,  U1 - GATE |
| LNA_GATE_BIAS | R2 - 1,  L2 - 1 |
| LNA_OUT | U1 - RF_OUT,  U2 - RF_IN |
| LO_DRV | U4 - RF_OUT_A,  U3 - LO_IN |
| MIX_I_N | U3 - I_N,  U12 - 3 |
| MIX_I_P | U3 - I_P,  U12 - 1 |
| MIX_Q_N | U3 - Q_N,  U13 - 3 |
| MIX_Q_P | U3 - Q_P,  U13 - 1 |
| Q_AMP_N | U13 - 4,  U14 - IN_N2 |
| Q_AMP_P | U13 - 2,  U14 - IN_P2 |
| RF_IN | J1 - SIG,  C1 - 1 |
| RF_IN_BLK | C1 - 2,  Q1 - D |
| RF_IN_SW | Q1 - S,  U1 - RF_IN |
| RF_SW_DRV | R17 - 2,  Q1 - G |
| RF_SW_GATE | U11 - 12,  R17 - 1 |
| SPI_CS_ADC | U11 - 9,  U5 - CS_N |
| SPI_CS_DVGA | U11 - 10,  U2 - CS_N |
| SPI_CS_PLL | U11 - 8,  U4 - CS_N |
| SPI_SCK | J3 - 3,  U11 - 4 |
| SPI_SCK_ADC | U11 - 5,  U5 - SCLK |
| SPI_SCK_DVGA | U11 - 5,  U2 - SCLK |
| SPI_SCK_PLL | U11 - 5,  U4 - SCLK |
| SPI_SDI | J3 - 4,  U11 - 6 |
| SPI_SDO | U11 - 7,  J3 - 5 |
| SYS_CLK_N | U4 - CLK_OUT_N,  U5 - CLKIN_N |
| SYS_CLK_P | U4 - CLK_OUT,  U5 - CLKIN_P |
| VCC_12V | J3 - 1,  L1 - 1 |
| VCC_12V_RF | L1 - 2,  L3 - 1 |
| VCC_1V2 | U8 - VOUT,  U5 - AVDD |
| VCC_1V8 | U7 - VOUT,  U5 - DVDD,  U10 - VDD_IO |
| VCC_3V3 | U6 - VOUT,  U4 - VDD,  U2 - VDD,  U11 - 1 |
| VCC_IN | L1 - 2,  U10 - VDD,  U6 - VIN,  U7 - VIN,  U8 - VIN |
| VCC_LNA | L3 - 2,  U1 - VDD |
| VCC_MIX | L3 - 2,  U3 - VDD |
| VEE_5V | U9 - VOUT,  U2 - VEE |

## Validation Notes

- CRITICAL: ADC JESD204B lane impedance requires 100 Ω differential; ensure PCB stackup and trace width achieve Zdiff=100Ω ±10% on J2 connections
- CRITICAL: VCC_3V3 rail estimated at 600 mA (PLL:150mA + DVGA:200mA + MCU+misc:250mA) - verify U6 (500mA max) has adequate margin; consider parallel device or higher-current LDO
- WARNING: VCC_12V_RF load may exceed 2 A (LNA startup surge + mixer) - L3 ferrite bead must support >2A saturation current (selected MLF2016 600mA underrated!) - replace with 3A-rated bead
- WARNING: U5 ADC AVDD (1.2V) requires ultra-low noise (≤10µVrms) for 12-bit ENOB; U8 LT3045 excellent choice but requires bulk capacitor (≥10µF) close to IN pin
- WARNING: VCC_1V8 rail supplies U5 DVDD (digital core) and U10 I/O; verify U7 (500mA max) supports U5 DVDD transient currents during JESD204B bursts (up to 300mA)
- INFO: SPI daisy-chain (SCK shared among U4/U5/U2) has acceptable fanout; ensure SCK trace length matching <100ps to avoid clock skew
- INFO: I2C pullups R12/R13 (4.7k) appropriate for 100kHz; upgrade to 2.2k if 400kHz fast-mode required
- INFO: ADC VCM reference (U5 pin 6) routed through R10/R11 (0.23Ω) filter - good practice for isolating reference noise
- RECOMMEND: Add 0.1µF X7R decoupling capacitors at U14 (IF amp) supply pins (currently only bulk C13-C16 shown)
- RECOMMEND: RF input return loss network (R1=50Ω to GND) provides nominal match; may need π-network with series L/shunt C for RL≤-10dB across 5-18GHz per REQ-HW-013
- RECOMMEND: L1 common mode choke on 12V input - ensure rated for 12V military temp; DigiKey DLW43SH101XK2L is 6.3V max - replace with 16V+ rated choke
- RECOMMEND: DVGA U2 (HMC698) datasheet specifies -5V VEE; verify U9 (-5V LDO) output accuracy ±2% for gain linearity
- RECOMMEND: LO path from U4 to U3 requires 50Ω controlled impedance; ensure LO_DRV net length <0.5" to maintain phase noise
- CRITICAL: RF path MOSFET Q1 (FDN340P) rated -20V Vds, but FDN340P is P-channel logic-level FET - verify intended part number; may need RF-rated SPDT switch like HMC190
- INFO: JESD204B SYSCLK from U4 PLL - verify phase noise meets REQ-HW-007 (-80dBc/Hz @1kHz offset) with LMX2594 in low-noise mode
- INFO: ADC clock inputs (CLKIN_P/N) require LVDS; confirm U4 CLK_OUT is configured for LVDS (not CMOS) per datasheet
- RECOMMEND: Add ESD protection on J3 control pins (I2C/SPI) if module hot-pluggable; consider TVS diode array