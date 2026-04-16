# Logical Netlist
## j,fj

## Block Diagram

```mermaid
graph TB
    U1[HMC1113LP3DE Wideband LNA (HMC1113LP3DE)]
    U2[HMC1056LP4BE Wideband Mixer (HMC1056LP4BE)]
    U3[HMC699LP4 Wideband IF VGA (HMC699LP4)]
    U4[ADF5356 Wideband LO Synthesizer (ADF5356CCPZ)]
    U5[ADC12DJ3200 14-bit 4 GSPS ADC (ADC12DJ3200AB)]
    U6[LTC7138 5V to 3.3V Buck Converter (LTC7138EUDC#PBF)]
    U7[TPS7A4700 3.3V to 1.8V LDO (TPS7A4700RGWR)]
    U8[TPS7A4700 1.8V to 1.0V LDO (TPS7A4700RGWR)]
    U9[SN65LVDS16 LVDS Line Driver (SN65LVDS16DGKR)]
    U10[AT24CS02 I2C EEPROM (AT24CS02-SH-T)]
    J1[RF Input Connector 2.4mm (149-1021-1)]
    J2[LVDS Digital Output Connector (SAMTEC-CLT-122-01-X-D)]
    J3[Control/Power Input Connector (Molex-503480-1200)]
    T1[Broadband RF Transformer 1:1 (TCM1-63+; Mini-Circuits)]
    T2[Wideband IF Transformer 1:2 (ADT1-1WT+)]
    L1[RF Choke 10uH (1812CMS-103XJLC)]
    C1[RF Input DC Block 100pF (GQM2195C2E101JB12D)]
    C2[LNA Decoupling 10pF (GJM1555C1H100JB01)]
    C3[LNA Decoupling 1000pF (GJM1555C1H101JB01)]
    C4[RF Bypass 0.01uF (GQM21P5C0E100JB12D)]
    R1[LNA Gate Bias Resistor (CRCW08051K00FKEA)]
    R2[LNA Drain Bias Resistor (ERJ-6ENF1001V)]
    R3[LNA Source Degeneration (CRCW080510R0FKEA)]
    R4[RF Input 50Ω to Ground (ERJ-6ENF4991V)]
    C5[Mixer RF Port DC Block (GQM2195C2E101JB12D)]
    C6[Mixer LO Port DC Block (GQM2195C2E101JB12D)]
    C7[Mixer IF Port DC Block (GQM2195C2E101JB12D)]
    R5[Mixer IF Termination 50Ω (ERJ-6ENF4991V)]
    C8[Mixer Bypass 10pF (GJM1555C1H100JB01)]
    R6[VGA Gain Set Resistor (ERJ-6ENF1002V)]
    C9[VGA Input AC Couple 100pF (GQM2195C2E101JB12D)]
    C10[VGA Output AC Couple 100pF (GQM2195C2E101JB12D)]
    C11[VGA Decoupling 100pF (GJM1555C1H101JB01)]
    C12[VGA Decoupling 0.001uF (GQM21P5C1H102JB12D)]
    R7[VGA Reference Resistor (ERJ-6ENF5101V)]
    R8[LO Output Level Resistor (ERJ-6ENF6802V)]
    C13[LO Output DC Block (GQM2195C2E101JB12D)]
    C14[Synth Decoupling 10pF (GJM1555C1H100JB01)]
    C15[Synth Decoupling 0.001uF (GQM21P5C1H102JB12D)]
    C16[Synth Decoupling 0.1uF (GJM1555C1H104JB01)]
    C17[Synth Loop Filter (GQM2195C2E101JB12D)]
    R9[Synth Loop Filter Resistor (ERJ-6ENF2202V)]
    R10[Synth SPI Pull-up (ERJ-6ENF4701V)]
    R11[Synth SPI Pull-up (ERJ-6ENF4701V)]
    R12[Synth SPI Pull-up (ERJ-6ENF4701V)]
    C18[ADC Input DC Block (GQM2195C2E101JB12D)]
    C19[ADC Decoupling Bank 0.1uF (GJM1555C1H104JB01)]
    C20[ADC Decoupling Bank 0.01uF (GQM21P5C1H103JB12D)]
    C21[ADC Decoupling Bank 0.001uF (GQM21P5C1H102JB12D)]
    C22[ADC Decoupling 1.0V Bulk 47uF (GRM32ER60J476ME20L)]
    C23[ADC Decoupling 1.8V 4.7uF (GRM32ER60J475ME20L)]
    R13[ADC Vref Resistor (ERJ-6ENF1001V)]
    R14[ADC Termination Resistor (ERJ-6ENF1000V)]
    R15[ADC SPI Pull-up SCLK (ERJ-6ENF4701V)]
    R16[ADC SPI Pull-up SDIO (ERJ-6ENF4701V)]
    R17[ADC SPI Pull-up CSB (ERJ-6ENF4701V)]
    C24[ADC Vref Decoupling 10uF (GRM219R60J106ME44L)]
    C25[Buck Input Capacitor (GRM32ER60J476ME20L)]
    C26[Buck Output Capacitor (GRM32ER60J476ME20L)]
    C27[Buck Bootstrap Capacitor (GJM1555C1H224JB01)]
    C28[LDO1 Input Capacitor (GRM32ER60J476ME20L)]
    C29[LDO1 Output Capacitor (GRM32ER60J476ME20L)]
    C30[LDO2 Input Capacitor (GRM32ER60J475ME20L)]
    C31[LDO2 Output Capacitor (GRM32ER60J226ME20L)]
    L2[Buck Inductor 2.2uH (LQH32PN2N2M03L)]
    R18[Buck FB Resistor Top (ERJ-6ENF3901V)]
    R19[Buck FB Resistor Bottom (ERJ-6ENF2201V)]
    R20[LDO1 FB Resistor Top (ERJ-6ENF1001V)]
    R21[LDO1 FB Resistor Bottom (ERJ-6ENF1000V)]
    R22[LDO2 FB Resistor Top (ERJ-6ENF1001V)]
    R23[LDO2 FB Resistor Bottom (ERJ-6ENF1000V)]
    C32[EEPROM Decoupling 0.1uF (GJM1555C1H104JB01)]
    R24[EEPROM Pull-up SDA (ERJ-6ENF4701V)]
    R25[EEPROM Pull-up SCL (ERJ-6ENF4701V)]
    R26[LVDS Termination 100Ω (ERJ-2GEJ103X)]
    R27[LVDS Termination 100Ω (ERJ-2GEJ103X)]
    R28[LVDS Termination 100Ω (ERJ-2GEJ103X)]
    R29[LVDS Termination 100Ω (ERJ-2GEJ103X)]
    R30[LVDS Termination 100Ω (ERJ-2GEJ103X)]
    R31[LVDS Termination 100Ω (ERJ-2GEJ103X)]
    R32[LVDS Termination 100Ω (ERJ-2GEJ103X)]
    R33[LVDS Termination 100Ω (ERJ-2GEJ103X)]
    C33[Power Input Decoupling (GRM32ER60J476ME20L)]
    F1[PTC Fuse 500mA (0ZCG0150FF2G)]
    D1[ESD Protection TVS (TPD4E1U06DBVR)]
    J1 -->|RF_IN| C1
    C1 -->|RF_IN_BLOCKED| R4
    C1 -->|RF_IN_BLOCKED| U1
    R4 -->|RF_IN_TERM| U1
    U1 -->|LNA_OUT| T1
    T1 -->|LNA_BAL_OUT_P| C5
    T1 -->|LNA_BAL_OUT_N| C5
    C5 -->|MIX_RF_P| U2
    C5 -->|MIX_RF_N| U2
    U4 -->|MIX_LO_IN| R8
    U4 -->|MIX_LO_IN| C13
    R8 -->|LO_LEVEL_ADJ| C13
    C13 -->|MIX_LO_DRV| U2
    C13 -->|MIX_LO_DRV| U2
    U2 -->|MIX_IF_OUT| C7
    U2 -->|MIX_IF_OUT_N| C7
    C7 -->|MIX_IF_AC_P| T2
    C7 -->|MIX_IF_AC_N| T2
    T2 -->|IF_SINGLE| R5
    T2 -->|IF_SINGLE| C9
    R5 -->|IF_TERM| GND
    C9 -->|VGA_IN| U3
    U3 -->|VGA_OUT| C10
    C10 -->|VGA_OUT_AC| T2
    T2 -->|ADC_IF_IN_P| C18
    T2 -->|ADC_IF_IN_N| C18
    C18 -->|ADC_IN_P| U5
    C18 -->|ADC_IN_N| U5
    U5 -->|ADC_DO0_P| U9
    U5 -->|ADC_DO0_N| U9
    U5 -->|ADC_DO1_P| U9
    U5 -->|ADC_DO1_N| U9
    U5 -->|ADC_DO2_P| U9
    U5 -->|ADC_DO2_N| U9
    U5 -->|ADC_DO3_P| U9
    U5 -->|ADC_DO3_N| U9
    U5 -->|ADC_DO4_P| U9
    U5 -->|ADC_DO4_N| U9
    U5 -->|ADC_DO5_P| U9
    U5 -->|ADC_DO5_N| U9
    U5 -->|ADC_DO6_P| U9
    U5 -->|ADC_DO6_N| U9
    U5 -->|ADC_DO7_P| U9
    U5 -->|ADC_DO7_N| U9
    U9 -->|LVDS_OUT0_P| R26
    U9 -->|LVDS_OUT0_N| R26
    U9 -->|LVDS_OUT1_P| R27
    U9 -->|LVDS_OUT1_N| R27
    U9 -->|LVDS_OUT2_P| R28
    U9 -->|LVDS_OUT2_N| R28
    U9 -->|LVDS_OUT3_P| R29
    U9 -->|LVDS_OUT3_N| R29
    U9 -->|LVDS_OUT4_P| R30
    U9 -->|LVDS_OUT4_N| R30
    U9 -->|LVDS_OUT5_P| R31
    U9 -->|LVDS_OUT5_N| R31
    U9 -->|LVDS_OUT6_P| R32
    U9 -->|LVDS_OUT6_N| R32
    U9 -->|LVDS_OUT7_P| R33
    U9 -->|LVDS_OUT7_N| R33
    R26 -->|LVDS_TERM0_P| J2
    R26 -->|LVDS_TERM0_N| J2
    R27 -->|LVDS_TERM1_P| J2
    R27 -->|LVDS_TERM1_N| J2
    R28 -->|LVDS_TERM2_P| J2
    R28 -->|LVDS_TERM2_N| J2
    R29 -->|LVDS_TERM3_P| J2
    R29 -->|LVDS_TERM3_N| J2
    R30 -->|LVDS_TERM4_P| J2
    R30 -->|LVDS_TERM4_N| J2
    R31 -->|LVDS_TERM5_P| J2
    R31 -->|LVDS_TERM5_N| J2
    R32 -->|LVDS_TERM6_P| J2
    R32 -->|LVDS_TERM6_N| J2
    R33 -->|LVDS_TERM7_P| J2
    R33 -->|LVDS_TERM7_N| J2
    J3 -->|5V_IN| F1
    F1 -->|5V_FUSED| U6
    F1 -->|5V_FUSED| C25
    F1 -->|5V_FUSED| C33
    F1 -->|5V_FUSED| U4
    F1 -->|5V_FUSED| C14
    F1 -->|5V_FUSED| U1
    F1 -->|5V_FUSED| C2
    F1 -->|5V_FUSED| L1
    U6 -->|3V3_SW| L2
    L2 -->|3V3_REG| C26
    L2 -->|3V3_REG| U6
    L2 -->|3V3_REG| U7
    L2 -->|3V3_REG| C28
    L2 -->|3V3_REG| U2
    L2 -->|3V3_REG| C8
    L2 -->|3V3_REG| U3
    L2 -->|3V3_REG| C11
    U7 -->|1V8_REG| C29
    U7 -->|1V8_REG| U8
    U7 -->|1V8_REG| C30
    U7 -->|1V8_REG| U5
    U7 -->|1V8_REG| C23
    U8 -->|1V0_REG| C31
    U8 -->|1V0_REG| U5
    U8 -->|1V0_REG| C22
    J3 -->|SPI_SCLK| U5
    J3 -->|SPI_SCLK| R15
    J3 -->|SPI_SCLK| U4
    R15 -->|SPI_SCLK_PLL| U4
    J3 -->|SPI_SDIO| U5
    J3 -->|SPI_SDIO| R16
    R16 -->|SPI_SDIO_PLL| U4
    J3 -->|SPI_CSB_ADC| R17
    R17 -->|SPI_CSB_ADC| U5
    J3 -->|SPI_CSB_PLL| R12
    R12 -->|SPI_CSB_PLL| U4
    J3 -->|I2C_SDA| U10
    J3 -->|I2C_SDA| R24
    R24 -->|I2C_SDA_PU| U10
    J3 -->|I2C_SCL| U10
    J3 -->|I2C_SCL| R25
    R25 -->|I2C_SCL_PU| U10
    J1 -->|GND| GND
    U1 -->|GND| C2
    U1 -->|GND| C3
    U1 -->|GND| R3
    U2 -->|GND| C8
    U3 -->|GND| C11
    U3 -->|GND| C12
    U3 -->|GND| R7
    U4 -->|GND| C14
    U4 -->|GND| C15
    U4 -->|GND| C16
    U4 -->|GND| R9
    U5 -->|GND| C19
    U5 -->|GND| C20
    U5 -->|GND| C21
    U5 -->|GND| C22
    U5 -->|GND| C23
    U5 -->|GND| R14
    U5 -->|GND| C24
    U6 -->|GND| C25
    U6 -->|GND| C26
    U6 -->|GND| C27
    U6 -->|GND| R19
    U7 -->|GND| C28
    U7 -->|GND| C29
    U7 -->|GND| R21
    U8 -->|GND| C30
    U8 -->|GND| C31
    U8 -->|GND| R23
    U10 -->|GND| C32
    U10 -->|GND| C33
    J2 -->|GND| GND
    J3 -->|GND| GND
    R5 -->|GND| GND
    R2 -->|LNA_BIAS| U1
    R2 -->|LNA_DRAIN| L1
    R1 -->|LNA_GATE_CTRL| U1
    R6 -->|VGA_GAIN_CTRL| U3
    R7 -->|VGA_REF| U3
    U4 -->|PLL_CP_OUT| C17
    U4 -->|PLL_CP_OUT| R9
    C17 -->|PLL_CP_FILT| R9
    R9 -->|PLL_CP_FILT| U4
    R13 -->|ADC_VREF| U5
    R13 -->|ADC_VREF| C24
    R14 -->|ADC_TERM| U5
    U6 -->|BUCK_FB| R18
    U6 -->|BUCK_FB| R19
    R18 -->|BUCK_FB_DIV| R19
    U7 -->|LDO1_FB| R20
    U7 -->|LDO1_FB| R21
    R20 -->|LDO1_FB_DIV| R21
    U8 -->|LDO2_FB| R22
    U8 -->|LDO2_FB| R23
    R22 -->|LDO2_FB_DIV| R23
    J3 -->|GPIO0| U3
    J3 -->|GPIO1| U5
    J3 -->|GPIO2| U9
    J3 -->|SYNC| U5
```

## Component Instances

| Ref | Part Number | Component |
|---|---|---|
| U1 | HMC1113LP3DE | HMC1113LP3DE Wideband LNA |
| U2 | HMC1056LP4BE | HMC1056LP4BE Wideband Mixer |
| U3 | HMC699LP4 | HMC699LP4 Wideband IF VGA |
| U4 | ADF5356CCPZ | ADF5356 Wideband LO Synthesizer |
| U5 | ADC12DJ3200AB | ADC12DJ3200 14-bit 4 GSPS ADC |
| U6 | LTC7138EUDC#PBF | LTC7138 5V to 3.3V Buck Converter |
| U7 | TPS7A4700RGWR | TPS7A4700 3.3V to 1.8V LDO |
| U8 | TPS7A4700RGWR | TPS7A4700 1.8V to 1.0V LDO |
| U9 | SN65LVDS16DGKR | SN65LVDS16 LVDS Line Driver |
| U10 | AT24CS02-SH-T | AT24CS02 I2C EEPROM |
| J1 | 149-1021-1 | RF Input Connector 2.4mm |
| J2 | SAMTEC-CLT-122-01-X-D | LVDS Digital Output Connector |
| J3 | Molex-503480-1200 | Control/Power Input Connector |
| T1 | TCM1-63+; Mini-Circuits | Broadband RF Transformer 1:1 |
| T2 | ADT1-1WT+ | Wideband IF Transformer 1:2 |
| L1 | 1812CMS-103XJLC | RF Choke 10uH |
| C1 | GQM2195C2E101JB12D | RF Input DC Block 100pF |
| C2 | GJM1555C1H100JB01 | LNA Decoupling 10pF |
| C3 | GJM1555C1H101JB01 | LNA Decoupling 1000pF |
| C4 | GQM21P5C0E100JB12D | RF Bypass 0.01uF |
| R1 | CRCW08051K00FKEA | LNA Gate Bias Resistor |
| R2 | ERJ-6ENF1001V | LNA Drain Bias Resistor |
| R3 | CRCW080510R0FKEA | LNA Source Degeneration |
| R4 | ERJ-6ENF4991V | RF Input 50Ω to Ground |
| C5 | GQM2195C2E101JB12D | Mixer RF Port DC Block |
| C6 | GQM2195C2E101JB12D | Mixer LO Port DC Block |
| C7 | GQM2195C2E101JB12D | Mixer IF Port DC Block |
| R5 | ERJ-6ENF4991V | Mixer IF Termination 50Ω |
| C8 | GJM1555C1H100JB01 | Mixer Bypass 10pF |
| R6 | ERJ-6ENF1002V | VGA Gain Set Resistor |
| C9 | GQM2195C2E101JB12D | VGA Input AC Couple 100pF |
| C10 | GQM2195C2E101JB12D | VGA Output AC Couple 100pF |
| C11 | GJM1555C1H101JB01 | VGA Decoupling 100pF |
| C12 | GQM21P5C1H102JB12D | VGA Decoupling 0.001uF |
| R7 | ERJ-6ENF5101V | VGA Reference Resistor |
| R8 | ERJ-6ENF6802V | LO Output Level Resistor |
| C13 | GQM2195C2E101JB12D | LO Output DC Block |
| C14 | GJM1555C1H100JB01 | Synth Decoupling 10pF |
| C15 | GQM21P5C1H102JB12D | Synth Decoupling 0.001uF |
| C16 | GJM1555C1H104JB01 | Synth Decoupling 0.1uF |
| C17 | GQM2195C2E101JB12D | Synth Loop Filter |
| R9 | ERJ-6ENF2202V | Synth Loop Filter Resistor |
| R10 | ERJ-6ENF4701V | Synth SPI Pull-up |
| R11 | ERJ-6ENF4701V | Synth SPI Pull-up |
| R12 | ERJ-6ENF4701V | Synth SPI Pull-up |
| C18 | GQM2195C2E101JB12D | ADC Input DC Block |
| C19 | GJM1555C1H104JB01 | ADC Decoupling Bank 0.1uF |
| C20 | GQM21P5C1H103JB12D | ADC Decoupling Bank 0.01uF |
| C21 | GQM21P5C1H102JB12D | ADC Decoupling Bank 0.001uF |
| C22 | GRM32ER60J476ME20L | ADC Decoupling 1.0V Bulk 47uF |
| C23 | GRM32ER60J475ME20L | ADC Decoupling 1.8V 4.7uF |
| R13 | ERJ-6ENF1001V | ADC Vref Resistor |
| R14 | ERJ-6ENF1000V | ADC Termination Resistor |
| R15 | ERJ-6ENF4701V | ADC SPI Pull-up SCLK |
| R16 | ERJ-6ENF4701V | ADC SPI Pull-up SDIO |
| R17 | ERJ-6ENF4701V | ADC SPI Pull-up CSB |
| C24 | GRM219R60J106ME44L | ADC Vref Decoupling 10uF |
| C25 | GRM32ER60J476ME20L | Buck Input Capacitor |
| C26 | GRM32ER60J476ME20L | Buck Output Capacitor |
| C27 | GJM1555C1H224JB01 | Buck Bootstrap Capacitor |
| C28 | GRM32ER60J476ME20L | LDO1 Input Capacitor |
| C29 | GRM32ER60J476ME20L | LDO1 Output Capacitor |
| C30 | GRM32ER60J475ME20L | LDO2 Input Capacitor |
| C31 | GRM32ER60J226ME20L | LDO2 Output Capacitor |
| L2 | LQH32PN2N2M03L | Buck Inductor 2.2uH |
| R18 | ERJ-6ENF3901V | Buck FB Resistor Top |
| R19 | ERJ-6ENF2201V | Buck FB Resistor Bottom |
| R20 | ERJ-6ENF1001V | LDO1 FB Resistor Top |
| R21 | ERJ-6ENF1000V | LDO1 FB Resistor Bottom |
| R22 | ERJ-6ENF1001V | LDO2 FB Resistor Top |
| R23 | ERJ-6ENF1000V | LDO2 FB Resistor Bottom |
| C32 | GJM1555C1H104JB01 | EEPROM Decoupling 0.1uF |
| R24 | ERJ-6ENF4701V | EEPROM Pull-up SDA |
| R25 | ERJ-6ENF4701V | EEPROM Pull-up SCL |
| R26 | ERJ-2GEJ103X | LVDS Termination 100Ω |
| R27 | ERJ-2GEJ103X | LVDS Termination 100Ω |
| R28 | ERJ-2GEJ103X | LVDS Termination 100Ω |
| R29 | ERJ-2GEJ103X | LVDS Termination 100Ω |
| R30 | ERJ-2GEJ103X | LVDS Termination 100Ω |
| R31 | ERJ-2GEJ103X | LVDS Termination 100Ω |
| R32 | ERJ-2GEJ103X | LVDS Termination 100Ω |
| R33 | ERJ-2GEJ103X | LVDS Termination 100Ω |
| C33 | GRM32ER60J476ME20L | Power Input Decoupling |
| F1 | 0ZCG0150FF2G | PTC Fuse 500mA |
| D1 | TPD4E1U06DBVR | ESD Protection TVS |

## Pin-to-Pin Connections

| Net | From | Pin | To | Pin | Type |
|---|---|---|---|---|---|
| RF_IN | J1 | SIG | C1 | 1 | RF |
| RF_IN_BLOCKED | C1 | 2 | R4 | 1 | RF |
| RF_IN_BLOCKED | C1 | 2 | U1 | RF_IN | RF |
| RF_IN_TERM | R4 | 2 | U1 | GND | RF |
| LNA_OUT | U1 | RF_OUT | T1 | PRI | RF |
| LNA_BAL_OUT_P | T1 | SEC+ | C5 | 1 | RF |
| LNA_BAL_OUT_N | T1 | SEC- | C5 | 2 | RF |
| MIX_RF_P | C5 | 1 | U2 | RF+ | RF |
| MIX_RF_N | C5 | 2 | U2 | RF- | RF |
| MIX_LO_IN | U4 | RFOUT | R8 | 1 | RF |
| MIX_LO_IN | U4 | RFOUT | C13 | 1 | RF |
| LO_LEVEL_ADJ | R8 | 2 | C13 | 2 | RF |
| MIX_LO_DRV | C13 | 2 | U2 | LO+ | RF |
| MIX_LO_DRV | C13 | 2 | U2 | LO- | RF |
| MIX_IF_OUT | U2 | IF+ | C7 | 1 | RF |
| MIX_IF_OUT_N | U2 | IF- | C7 | 2 | RF |
| MIX_IF_AC_P | C7 | 1 | T2 | PRI+ | IF |
| MIX_IF_AC_N | C7 | 2 | T2 | PRI- | IF |
| IF_SINGLE | T2 | SEC | R5 | 1 | IF |
| IF_SINGLE | T2 | SEC | C9 | 1 | IF |
| IF_TERM | R5 | 2 | GND | GND | IF |
| VGA_IN | C9 | 2 | U3 | VIN | IF |
| VGA_OUT | U3 | VOUT | C10 | 1 | IF |
| VGA_OUT_AC | C10 | 2 | T2 | P2 | IF |
| ADC_IF_IN_P | T2 | S2+ | C18 | 1 | IF |
| ADC_IF_IN_N | T2 | S2- | C18 | 2 | IF |
| ADC_IN_P | C18 | 1 | U5 | VIN_P | IF |
| ADC_IN_N | C18 | 2 | U5 | VIN_N | IF |
| ADC_DO0_P | U5 | D0_P | U9 | DIN0 | LVDS |
| ADC_DO0_N | U5 | D0_N | U9 | DIN0B | LVDS |
| ADC_DO1_P | U5 | D1_P | U9 | DIN1 | LVDS |
| ADC_DO1_N | U5 | D1_N | U9 | DIN1B | LVDS |
| ADC_DO2_P | U5 | D2_P | U9 | DIN2 | LVDS |
| ADC_DO2_N | U5 | D2_N | U9 | DIN2B | LVDS |
| ADC_DO3_P | U5 | D3_P | U9 | DIN3 | LVDS |
| ADC_DO3_N | U5 | D3_N | U9 | DIN3B | LVDS |
| ADC_DO4_P | U5 | D4_P | U9 | DIN4 | LVDS |
| ADC_DO4_N | U5 | D4_N | U9 | DIN4B | LVDS |
| ADC_DO5_P | U5 | D5_P | U9 | DIN5 | LVDS |
| ADC_DO5_N | U5 | D5_N | U9 | DIN5B | LVDS |
| ADC_DO6_P | U5 | D6_P | U9 | DIN6 | LVDS |
| ADC_DO6_N | U5 | D6_N | U9 | DIN6B | LVDS |
| ADC_DO7_P | U5 | D7_P | U9 | DIN7 | LVDS |
| ADC_DO7_N | U5 | D7_N | U9 | DIN7B | LVDS |
| LVDS_OUT0_P | U9 | DOUT0 | R26 | 1 | LVDS |
| LVDS_OUT0_N | U9 | DOUT0B | R26 | 2 | LVDS |
| LVDS_OUT1_P | U9 | DOUT1 | R27 | 1 | LVDS |
| LVDS_OUT1_N | U9 | DOUT1B | R27 | 2 | LVDS |
| LVDS_OUT2_P | U9 | DOUT2 | R28 | 1 | LVDS |
| LVDS_OUT2_N | U9 | DOUT2B | R28 | 2 | LVDS |
| LVDS_OUT3_P | U9 | DOUT3 | R29 | 1 | LVDS |
| LVDS_OUT3_N | U9 | DOUT3B | R29 | 2 | LVDS |
| LVDS_OUT4_P | U9 | DOUT4 | R30 | 1 | LVDS |
| LVDS_OUT4_N | U9 | DOUT4B | R30 | 2 | LVDS |
| LVDS_OUT5_P | U9 | DOUT5 | R31 | 1 | LVDS |
| LVDS_OUT5_N | U9 | DOUT5B | R31 | 2 | LVDS |
| LVDS_OUT6_P | U9 | DOUT6 | R32 | 1 | LVDS |
| LVDS_OUT6_N | U9 | DOUT6B | R32 | 2 | LVDS |
| LVDS_OUT7_P | U9 | DOUT7 | R33 | 1 | LVDS |
| LVDS_OUT7_N | U9 | DOUT7B | R33 | 2 | LVDS |
| LVDS_TERM0_P | R26 | 1 | J2 | 1 | LVDS |
| LVDS_TERM0_N | R26 | 2 | J2 | 2 | LVDS |
| LVDS_TERM1_P | R27 | 1 | J2 | 3 | LVDS |
| LVDS_TERM1_N | R27 | 2 | J2 | 4 | LVDS |
| LVDS_TERM2_P | R28 | 1 | J2 | 5 | LVDS |
| LVDS_TERM2_N | R28 | 2 | J2 | 6 | LVDS |
| LVDS_TERM3_P | R29 | 1 | J2 | 7 | LVDS |
| LVDS_TERM3_N | R29 | 2 | J2 | 8 | LVDS |
| LVDS_TERM4_P | R30 | 1 | J2 | 9 | LVDS |
| LVDS_TERM4_N | R30 | 2 | J2 | 10 | LVDS |
| LVDS_TERM5_P | R31 | 1 | J2 | 11 | LVDS |
| LVDS_TERM5_N | R31 | 2 | J2 | 12 | LVDS |
| LVDS_TERM6_P | R32 | 1 | J2 | 13 | LVDS |
| LVDS_TERM6_N | R32 | 2 | J2 | 14 | LVDS |
| LVDS_TERM7_P | R33 | 1 | J2 | 15 | LVDS |
| LVDS_TERM7_N | R33 | 2 | J2 | 16 | LVDS |
| 5V_IN | J3 | VCC | F1 | 1 | power |
| 5V_FUSED | F1 | 2 | U6 | VIN | power |
| 5V_FUSED | F1 | 2 | C25 | 1 | power |
| 5V_FUSED | F1 | 2 | C33 | 1 | power |
| 5V_FUSED | F1 | 2 | U4 | VDD | power |
| 5V_FUSED | F1 | 2 | C14 | 1 | power |
| 5V_FUSED | F1 | 2 | U1 | VDD | power |
| 5V_FUSED | F1 | 2 | C2 | 1 | power |
| 5V_FUSED | F1 | 2 | L1 | 1 | power |
| 3V3_SW | U6 | SW | L2 | 1 | power |
| 3V3_REG | L2 | 2 | C26 | 1 | power |
| 3V3_REG | L2 | 2 | U6 | FB | power |
| 3V3_REG | L2 | 2 | U7 | IN | power |
| 3V3_REG | L2 | 2 | C28 | 1 | power |
| 3V3_REG | L2 | 2 | U2 | VDD | power |
| 3V3_REG | L2 | 2 | C8 | 1 | power |
| 3V3_REG | L2 | 2 | U3 | VDD | power |
| 3V3_REG | L2 | 2 | C11 | 1 | power |
| 1V8_REG | U7 | OUT | C29 | 1 | power |
| 1V8_REG | U7 | OUT | U8 | IN | power |
| 1V8_REG | U7 | OUT | C30 | 1 | power |
| 1V8_REG | U7 | OUT | U5 | VDD_1V8 | power |
| 1V8_REG | U7 | OUT | C23 | 1 | power |
| 1V0_REG | U8 | OUT | C31 | 1 | power |
| 1V0_REG | U8 | OUT | U5 | VDD_1V0 | power |
| 1V0_REG | U8 | OUT | C22 | 1 | power |
| SPI_SCLK | J3 | SCLK | U5 | SCLK | digital |
| SPI_SCLK | J3 | SCLK | R15 | 1 | digital |
| SPI_SCLK | J3 | SCLK | U4 | CLK | digital |
| SPI_SCLK_PLL | R15 | 2 | U4 | SCLK | digital |
| SPI_SDIO | J3 | SDIO | U5 | SDIO | digital |
| SPI_SDIO | J3 | SDIO | R16 | 1 | digital |
| SPI_SDIO_PLL | R16 | 2 | U4 | SDIO | digital |
| SPI_CSB_ADC | J3 | CSB0 | R17 | 1 | digital |
| SPI_CSB_ADC | R17 | 2 | U5 | CSB | digital |
| SPI_CSB_PLL | J3 | CSB1 | R12 | 1 | digital |
| SPI_CSB_PLL | R12 | 2 | U4 | LE | digital |
| I2C_SDA | J3 | SDA | U10 | SDA | digital |
| I2C_SDA | J3 | SDA | R24 | 1 | digital |
| I2C_SDA_PU | R24 | 2 | U10 | VCC | digital |
| I2C_SCL | J3 | SCL | U10 | SCL | digital |
| I2C_SCL | J3 | SCL | R25 | 1 | digital |
| I2C_SCL_PU | R25 | 2 | U10 | VCC | digital |
| GND | J1 | SHLD | GND | GND | ground |
| GND | U1 | GND | C2 | 2 | ground |
| GND | U1 | GND | C3 | 2 | ground |
| GND | U1 | GND | R3 | 2 | ground |
| GND | U2 | GND | C8 | 2 | ground |
| GND | U3 | GND | C11 | 2 | ground |
| GND | U3 | GND | C12 | 2 | ground |
| GND | U3 | GND | R7 | 2 | ground |
| GND | U4 | GND | C14 | 2 | ground |
| GND | U4 | GND | C15 | 2 | ground |
| GND | U4 | GND | C16 | 2 | ground |
| GND | U4 | GND | R9 | 2 | ground |
| GND | U5 | GND | C19 | 2 | ground |
| GND | U5 | GND | C20 | 2 | ground |
| GND | U5 | GND | C21 | 2 | ground |
| GND | U5 | GND | C22 | 2 | ground |
| GND | U5 | GND | C23 | 2 | ground |
| GND | U5 | GND | R14 | 2 | ground |
| GND | U5 | GND | C24 | 2 | ground |
| GND | U6 | GND | C25 | 2 | ground |
| GND | U6 | GND | C26 | 2 | ground |
| GND | U6 | GND | C27 | 2 | ground |
| GND | U6 | GND | R19 | 2 | ground |
| GND | U7 | GND | C28 | 2 | ground |
| GND | U7 | GND | C29 | 2 | ground |
| GND | U7 | GND | R21 | 2 | ground |
| GND | U8 | GND | C30 | 2 | ground |
| GND | U8 | GND | C31 | 2 | ground |
| GND | U8 | GND | R23 | 2 | ground |
| GND | U10 | GND | C32 | 2 | ground |
| GND | U10 | GND | C33 | 2 | ground |
| GND | J2 | GND | GND | GND | ground |
| GND | J3 | GND | GND | GND | ground |
| GND | R5 | 2 | GND | GND | ground |
| LNA_BIAS | R2 | 1 | U1 | VGG | power |
| LNA_DRAIN | R2 | 2 | L1 | 2 | power |
| LNA_GATE_CTRL | R1 | 1 | U1 | VGS | power |
| VGA_GAIN_CTRL | R6 | 1 | U3 | GAIN | analog |
| VGA_REF | R7 | 1 | U3 | VREF | analog |
| PLL_CP_OUT | U4 | CP | C17 | 1 | analog |
| PLL_CP_OUT | U4 | CP | R9 | 1 | analog |
| PLL_CP_FILT | C17 | 2 | R9 | 2 | analog |
| PLL_CP_FILT | R9 | 2 | U4 | VTUNE | analog |
| ADC_VREF | R13 | 1 | U5 | VREF | analog |
| ADC_VREF | R13 | 1 | C24 | 1 | analog |
| ADC_TERM | R14 | 1 | U5 | TERM | analog |
| BUCK_FB | U6 | FB | R18 | 1 | analog |
| BUCK_FB | U6 | FB | R19 | 1 | analog |
| BUCK_FB_DIV | R18 | 2 | R19 | 1 | analog |
| LDO1_FB | U7 | FB | R20 | 1 | analog |
| LDO1_FB | U7 | FB | R21 | 1 | analog |
| LDO1_FB_DIV | R20 | 2 | R21 | 1 | analog |
| LDO2_FB | U8 | FB | R22 | 1 | analog |
| LDO2_FB | U8 | FB | R23 | 1 | analog |
| LDO2_FB_DIV | R22 | 2 | R23 | 1 | analog |
| GPIO0 | J3 | GPIO0 | U3 | SD | digital |
| GPIO1 | J3 | GPIO1 | U5 | PDN | digital |
| GPIO2 | J3 | GPIO2 | U9 | EN | digital |
| SYNC | J3 | SYNC | U5 | SYNC | clock |

## Net Connection List

| Net Name | Reference Designator - Pin No. |
|----------|-------------------------------|
| 1V0_REG | U8 - OUT,  C31 - 1,  U5 - VDD_1V0,  C22 - 1 |
| 1V8_REG | U7 - OUT,  C29 - 1,  U8 - IN,  C30 - 1,  U5 - VDD_1V8,  C23 - 1 |
| 3V3_REG | L2 - 2,  C26 - 1,  U6 - FB,  U7 - IN,  C28 - 1,  U2 - VDD,  C8 - 1,  U3 - VDD,  C11 - 1 |
| 3V3_SW | U6 - SW,  L2 - 1 |
| 5V_FUSED | F1 - 2,  U6 - VIN,  C25 - 1,  C33 - 1,  U4 - VDD,  C14 - 1,  U1 - VDD,  C2 - 1,  L1 - 1 |
| 5V_IN | J3 - VCC,  F1 - 1 |
| ADC_DO0_N | U5 - D0_N,  U9 - DIN0B |
| ADC_DO0_P | U5 - D0_P,  U9 - DIN0 |
| ADC_DO1_N | U5 - D1_N,  U9 - DIN1B |
| ADC_DO1_P | U5 - D1_P,  U9 - DIN1 |
| ADC_DO2_N | U5 - D2_N,  U9 - DIN2B |
| ADC_DO2_P | U5 - D2_P,  U9 - DIN2 |
| ADC_DO3_N | U5 - D3_N,  U9 - DIN3B |
| ADC_DO3_P | U5 - D3_P,  U9 - DIN3 |
| ADC_DO4_N | U5 - D4_N,  U9 - DIN4B |
| ADC_DO4_P | U5 - D4_P,  U9 - DIN4 |
| ADC_DO5_N | U5 - D5_N,  U9 - DIN5B |
| ADC_DO5_P | U5 - D5_P,  U9 - DIN5 |
| ADC_DO6_N | U5 - D6_N,  U9 - DIN6B |
| ADC_DO6_P | U5 - D6_P,  U9 - DIN6 |
| ADC_DO7_N | U5 - D7_N,  U9 - DIN7B |
| ADC_DO7_P | U5 - D7_P,  U9 - DIN7 |
| ADC_IF_IN_N | T2 - S2-,  C18 - 2 |
| ADC_IF_IN_P | T2 - S2+,  C18 - 1 |
| ADC_IN_N | C18 - 2,  U5 - VIN_N |
| ADC_IN_P | C18 - 1,  U5 - VIN_P |
| ADC_TERM | R14 - 1,  U5 - TERM |
| ADC_VREF | R13 - 1,  U5 - VREF,  C24 - 1 |
| BUCK_FB | U6 - FB,  R18 - 1,  R19 - 1 |
| BUCK_FB_DIV | R18 - 2,  R19 - 1 |
| GND | J1 - SHLD,  GND - GND,  U1 - GND,  C2 - 2,  C3 - 2,  R3 - 2,  U2 - GND,  C8 - 2,  U3 - GND,  C11 - 2,  C12 - 2,  R7 - 2,  U4 - GND,  C14 - 2,  C15 - 2,  C16 - 2,  R9 - 2,  U5 - GND,  C19 - 2,  C20 - 2,  C21 - 2,  C22 - 2,  C23 - 2,  R14 - 2,  C24 - 2,  U6 - GND,  C25 - 2,  C26 - 2,  C27 - 2,  R19 - 2,  U7 - GND,  C28 - 2,  C29 - 2,  R21 - 2,  U8 - GND,  C30 - 2,  C31 - 2,  R23 - 2,  U10 - GND,  C32 - 2,  C33 - 2,  J2 - GND,  J3 - GND,  R5 - 2 |
| GPIO0 | J3 - GPIO0,  U3 - SD |
| GPIO1 | J3 - GPIO1,  U5 - PDN |
| GPIO2 | J3 - GPIO2,  U9 - EN |
| I2C_SCL | J3 - SCL,  U10 - SCL,  R25 - 1 |
| I2C_SCL_PU | R25 - 2,  U10 - VCC |
| I2C_SDA | J3 - SDA,  U10 - SDA,  R24 - 1 |
| I2C_SDA_PU | R24 - 2,  U10 - VCC |
| IF_SINGLE | T2 - SEC,  R5 - 1,  C9 - 1 |
| IF_TERM | R5 - 2,  GND - GND |
| LDO1_FB | U7 - FB,  R20 - 1,  R21 - 1 |
| LDO1_FB_DIV | R20 - 2,  R21 - 1 |
| LDO2_FB | U8 - FB,  R22 - 1,  R23 - 1 |
| LDO2_FB_DIV | R22 - 2,  R23 - 1 |
| LNA_BAL_OUT_N | T1 - SEC-,  C5 - 2 |
| LNA_BAL_OUT_P | T1 - SEC+,  C5 - 1 |
| LNA_BIAS | R2 - 1,  U1 - VGG |
| LNA_DRAIN | R2 - 2,  L1 - 2 |
| LNA_GATE_CTRL | R1 - 1,  U1 - VGS |
| LNA_OUT | U1 - RF_OUT,  T1 - PRI |
| LO_LEVEL_ADJ | R8 - 2,  C13 - 2 |
| LVDS_OUT0_N | U9 - DOUT0B,  R26 - 2 |
| LVDS_OUT0_P | U9 - DOUT0,  R26 - 1 |
| LVDS_OUT1_N | U9 - DOUT1B,  R27 - 2 |
| LVDS_OUT1_P | U9 - DOUT1,  R27 - 1 |
| LVDS_OUT2_N | U9 - DOUT2B,  R28 - 2 |
| LVDS_OUT2_P | U9 - DOUT2,  R28 - 1 |
| LVDS_OUT3_N | U9 - DOUT3B,  R29 - 2 |
| LVDS_OUT3_P | U9 - DOUT3,  R29 - 1 |
| LVDS_OUT4_N | U9 - DOUT4B,  R30 - 2 |
| LVDS_OUT4_P | U9 - DOUT4,  R30 - 1 |
| LVDS_OUT5_N | U9 - DOUT5B,  R31 - 2 |
| LVDS_OUT5_P | U9 - DOUT5,  R31 - 1 |
| LVDS_OUT6_N | U9 - DOUT6B,  R32 - 2 |
| LVDS_OUT6_P | U9 - DOUT6,  R32 - 1 |
| LVDS_OUT7_N | U9 - DOUT7B,  R33 - 2 |
| LVDS_OUT7_P | U9 - DOUT7,  R33 - 1 |
| LVDS_TERM0_N | R26 - 2,  J2 - 2 |
| LVDS_TERM0_P | R26 - 1,  J2 - 1 |
| LVDS_TERM1_N | R27 - 2,  J2 - 4 |
| LVDS_TERM1_P | R27 - 1,  J2 - 3 |
| LVDS_TERM2_N | R28 - 2,  J2 - 6 |
| LVDS_TERM2_P | R28 - 1,  J2 - 5 |
| LVDS_TERM3_N | R29 - 2,  J2 - 8 |
| LVDS_TERM3_P | R29 - 1,  J2 - 7 |
| LVDS_TERM4_N | R30 - 2,  J2 - 10 |
| LVDS_TERM4_P | R30 - 1,  J2 - 9 |
| LVDS_TERM5_N | R31 - 2,  J2 - 12 |
| LVDS_TERM5_P | R31 - 1,  J2 - 11 |
| LVDS_TERM6_N | R32 - 2,  J2 - 14 |
| LVDS_TERM6_P | R32 - 1,  J2 - 13 |
| LVDS_TERM7_N | R33 - 2,  J2 - 16 |
| LVDS_TERM7_P | R33 - 1,  J2 - 15 |
| MIX_IF_AC_N | C7 - 2,  T2 - PRI- |
| MIX_IF_AC_P | C7 - 1,  T2 - PRI+ |
| MIX_IF_OUT | U2 - IF+,  C7 - 1 |
| MIX_IF_OUT_N | U2 - IF-,  C7 - 2 |
| MIX_LO_DRV | C13 - 2,  U2 - LO+,  U2 - LO- |
| MIX_LO_IN | U4 - RFOUT,  R8 - 1,  C13 - 1 |
| MIX_RF_N | C5 - 2,  U2 - RF- |
| MIX_RF_P | C5 - 1,  U2 - RF+ |
| PLL_CP_FILT | C17 - 2,  R9 - 2,  U4 - VTUNE |
| PLL_CP_OUT | U4 - CP,  C17 - 1,  R9 - 1 |
| RF_IN | J1 - SIG,  C1 - 1 |
| RF_IN_BLOCKED | C1 - 2,  R4 - 1,  U1 - RF_IN |
| RF_IN_TERM | R4 - 2,  U1 - GND |
| SPI_CSB_ADC | J3 - CSB0,  R17 - 1,  R17 - 2,  U5 - CSB |
| SPI_CSB_PLL | J3 - CSB1,  R12 - 1,  R12 - 2,  U4 - LE |
| SPI_SCLK | J3 - SCLK,  U5 - SCLK,  R15 - 1,  U4 - CLK |
| SPI_SCLK_PLL | R15 - 2,  U4 - SCLK |
| SPI_SDIO | J3 - SDIO,  U5 - SDIO,  R16 - 1 |
| SPI_SDIO_PLL | R16 - 2,  U4 - SDIO |
| SYNC | J3 - SYNC,  U5 - SYNC |
| VGA_GAIN_CTRL | R6 - 1,  U3 - GAIN |
| VGA_IN | C9 - 2,  U3 - VIN |
| VGA_OUT | U3 - VOUT,  C10 - 1 |
| VGA_OUT_AC | C10 - 2,  T2 - P2 |
| VGA_REF | R7 - 1,  U3 - VREF |

## Validation Notes

- CRITICAL: ADF5356 LO synthesizer only covers 53.125 MHz to 13.6 GHz, but required LO range is 4.5-18.5 GHz. Consider LO multiplication or alternative synthesizer (e.g., LMX2594: 10-15 GHz + multipliers) for full coverage.
- WARNING: HMC1056LP4BE mixer RF/LO range is 6-26 GHz, leaving a gap at 4.5-6 GHz RF input. Either select lower-frequency mixer or add downconversion stage.
- WARNING: LO drive level is +17 dBm minimum for HMC1056LP4BE. ADF5356 output is -5 to +5 dBm - requires external LO amplifier (e.g., HMC6180) to meet mixer requirements.
- CRITICAL: ADC12DJ3200 resolution is 12-bit in dual-channel mode, 14-bit in single-channel mode at reduced sample rate. Verify 14-bit mode supports 4 GSPS or accept 12-bit mode.
- RECOMMENDATION: Add dedicated LO amplifier (HMC6180 or similar) after synthesizer output to guarantee +17 dBm mixer drive across all frequencies.
- RECOMMENDATION: Add anti-aliasing filter (LTC6601-14 or similar) between VGA output and ADC input to limit noise bandwidth and improve SNR.
- WARNING: Power budget check: LNA (90mA @5V = 0.45W), Mixer (~50mA @3.3V = 0.17W), VGA (~80mA @3.3V = 0.26W), Synth (~150mA @5V = 0.75W), ADC (~2.5W @1.0V + 1.8V), Total ~4.1W. Verify connector and thermal design.
- RECOMMENDATION: Add ferrite beads on power rails (FB1-5) for EMI suppression on 5V, 3.3V, 1.8V, and 1.0V supplies to sensitive RF/ADC circuits.
- RECOMMENDATION: Add temperature sensor (e.g., TMP235) near LNA and ADC for gain compensation and performance monitoring across -40 to +85°C range.
- NOTE: All 5V components (LNA, LO Synth) are directly on 5V_FUSED rail - add local ferrite beads and additional decoupling for better isolation.
- NOTE: LVDS termination resistors (R26-33, 100Ω) are required at the receiver end. Verify host FPGA LVDS input termination.
- WARNING: Single transformer T2 is shown for both IF VGA input and ADC output coupling - use separate transformers T2 and T3 to prevent loading effects.
- NOTE: SPI signals for ADC and PLL share SCLK/SDIO lines but have separate CSB (Chip Select) lines - ensure correct addressing in firmware.
- RECOMMENDATION: Add reset IC (e.g., TPS3828) to provide controlled power-on sequencing for ADC (1.0V before 1.8V before 3.3V) to prevent latch-up.
- NOTE: ADC VREF requires precision reference - add external 1.2V reference (e.g., REF5012) with 0.1% tolerance for optimal SFDR performance.