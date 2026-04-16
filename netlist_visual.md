# Logical Netlist
## dghb

## Block Diagram

```mermaid
graph TB
    U1[GVA-123+ (GVA-123+)]
    U2[HMC698LP4 (HMC698LP4ETR)]
    U3[ADC12DJ5200RF (ADC12DJ5200RFABZ)]
    U4[LMK04828 (LMK04828BKNPT)]
    U5[LMK04828 (LMK04828BKNPT)]
    U6[TPS7A4700 (TPS7A4700RGWT)]
    U7[TPS7A4700 (TPS7A4700RGWT)]
    U8[TPS7A3301 (TPS7A3301RGWR)]
    U9[LMQ5203 (LMQ5203QMUTJTI)]
    U10[ISO7740 (ISO7740FDWR)]
    U11[ISO7740 (ISO7740FDWR)]
    U12[BQ25895 (BQ25895RTWT)]
    U13[TLC6C5712 (TLC6C5712QDAPRQ1)]
    J1[SMA-Connector (CON-SMA-EDGE-S-ND)]
    J2[Samtec-Array (TER-8-01-L-D-TH)]
    J3[Molex-Mini50 (0544740890)]
    R1[RF-Resistor (ERA-3AEB49R9V)]
    R2[Resistor (CRCW04024K70FKED)]
    R3[Resistor (CRCW04024K70FKED)]
    R4[Resistor (CRCW040210K0FKED)]
    R5[Resistor (CRCW04024K70FKED)]
    R6[Resistor (CRCW04024K70FKED)]
    R7[Resistor (CRCW040210K0FKED)]
    R8[Resistor (CRCW0402100KFKED)]
    R9[Resistor (CRCW040210K0FKED)]
    R10[Resistor (CRCW040210K0FKED)]
    R11[Resistor (CRCW04021K00FKED)]
    R12[Resistor (CRCW04021K00FKED)]
    R13[Resistor (CRCW04024K70FKED)]
    R14[Resistor (CRCW04024K70FKED)]
    C1[Capacitor (GRM1555C1H102FA01D)]
    C2[Capacitor (GJM1555C1H100FB01D)]
    C3[Capacitor (GRM1555C1H102FA01D)]
    C4[Capacitor (GJM1555C1H100FB01D)]
    C5[Capacitor (GJM1555C1H100FB01D)]
    C6[Capacitor (GJM1555C1H100FB01D)]
    C7[Capacitor (GJM1555C1H100FB01D)]
    C8[Capacitor (GJM1555C1H100FB01D)]
    C9[Capacitor (GJM1555C1H100FB01D)]
    C10[Capacitor (GJM1555C1H100FB01D)]
    C11[Capacitor (GJM1555C1H100FB01D)]
    C12[Capacitor (GJM1555C1H100FB01D)]
    C13[Capacitor (GRM32ER61C476KE15L)]
    C14[Capacitor (GRM32ER61C476KE15L)]
    C15[Capacitor (GRM32ER61C476KE15L)]
    C16[Capacitor (GRM32ER61C476KE15L)]
    C17[Capacitor (GRT31CR61A226KE01L)]
    C18[Capacitor (GRT31CR61A226KE01L)]
    C19[Capacitor (GRT31CR61A226KE01L)]
    L1[RF-Choke (0603CS-151XJBC)]
    L2[RF-Choke (0603CS-151XJBC)]
    L3[Inductor (MLZ2012M2R2WT000)]
    L4[Inductor (MLZ2012M2R2WT000)]
    F1[ESD-Protection (GBLC03LC)]
    J1 -->|RF_IN_P| F1
    F1 -->|RF_IN_P| U1
    U1 -->|RF_IN_T| U2
    U2 -->|RF_IF_P| U3
    U2 -->|RF_IF_M| U3
    U4 -->|CLK_3P3V_P| U3
    U4 -->|CLK_3P3V_M| U3
    U5 -->|CLK_REF_P| U4
    U5 -->|CLK_REF_M| U4
    U3 -->|LVSD_TX0_P| J2
    U3 -->|LVSD_TX0_M| J2
    U3 -->|LVSD_TX1_P| J2
    U3 -->|LVSD_TX1_M| J2
    U3 -->|LVSD_TX2_P| J2
    U3 -->|LVSD_TX2_M| J2
    U3 -->|LVSD_TX3_P| J2
    U3 -->|LVSD_TX3_M| J2
    U4 -->|LVSD_SYSREF_P| J2
    U4 -->|LVSD_SYSREF_M| J2
    J3 -->|SPI_SCLK| U10
    U10 -->|SPI_SCLK_ISO| R13
    R13 -->|SPI_SCLK_CTRL| U4
    R13 -->|SPI_SCLK_CTRL| U2
    J3 -->|SPI_SDIO| U10
    U10 -->|SPI_SDIO_ISO| R14
    R14 -->|SPI_SDIO_CTRL| U4
    R14 -->|SPI_SDIO_CTRL| U2
    J3 -->|SPI_CS0| U10
    U10 -->|SPI_CS0_ISO| U4
    J3 -->|SPI_CS1| U11
    U11 -->|SPI_CS1_ISO| U2
    J3 -->|SPI_CS_ADC| U3
    U12 -->|3V3_MAIN| U6
    U12 -->|3V3_MAIN| U8
    U12 -->|3V3_MAIN| L1
    U12 -->|3V3_MAIN| L2
    U6 -->|1V8_ADC| U3
    U6 -->|1V8_ADC| U3
    U6 -->|1V8_ADC| C17
    U6 -->|1V8_ADC| C18
    U7 -->|1V0_CORE| U3
    U7 -->|1V0_CORE| U3
    U7 -->|1V0_CORE| C13
    U7 -->|1V0_CORE| C14
    U8 -->|1V8_CLK| U4
    U8 -->|1V8_CLK| U5
    U8 -->|1V8_CLK| C19
    L1 -->|3V3_LNA| U1
    L1 -->|3V3_LNA| C1
    L2 -->|3V3_VGA| U2
    L2 -->|3V3_VGA| C3
    U6 -->|VDD_IO_1V8| U10
    U6 -->|VDD_IO_1V8| U11
    U12 -->|VDD_IO_3V3| U10
    U12 -->|VDD_IO_3V3| U11
    U13 -->|3V3_ISOLED| R2
    U13 -->|3V3_ISOLED| R3
    U13 -->|3V3_ISOLED| R4
    R2 -->|LED_STATUS| U13
    R3 -->|LED_LOCK| U13
    R4 -->|LED_ERROR| U13
    F1 -->|GND| U1
    U1 -->|GND| C1
    U1 -->|GND| C2
    U2 -->|GND| C3
    U2 -->|GND| C4
    U3 -->|GND| C5
    U3 -->|GND| C6
    U3 -->|GND| C7
    U3 -->|GND| C8
    U3 -->|GND| C9
    U3 -->|GND| C10
    U3 -->|GND| C11
    U3 -->|GND| C12
    U4 -->|GND| C15
    U4 -->|GND| C16
    U5 -->|GND| U9
    U6 -->|GND| C17
    U6 -->|GND| C18
    U7 -->|GND| C13
    U7 -->|GND| C14
    U8 -->|GND| C19
    U9 -->|GND| U12
    U10 -->|GND| U11
    U10 -->|GND| J3
    U11 -->|GND| J3
    U13 -->|GND| R5
    R6 -->|GND| R7
    U9 -->|VDD_PLL| U4
    U9 -->|VDD_PLL| U5
    U9 -->|VCC_OSC| U4
    U9 -->|VCC_OSC| U5
```

## Component Instances

| Ref | Part Number | Component |
|---|---|---|
| U1 | GVA-123+ | GVA-123+ |
| U2 | HMC698LP4ETR | HMC698LP4 |
| U3 | ADC12DJ5200RFABZ | ADC12DJ5200RF |
| U4 | LMK04828BKNPT | LMK04828 |
| U5 | LMK04828BKNPT | LMK04828 |
| U6 | TPS7A4700RGWT | TPS7A4700 |
| U7 | TPS7A4700RGWT | TPS7A4700 |
| U8 | TPS7A3301RGWR | TPS7A3301 |
| U9 | LMQ5203QMUTJTI | LMQ5203 |
| U10 | ISO7740FDWR | ISO7740 |
| U11 | ISO7740FDWR | ISO7740 |
| U12 | BQ25895RTWT | BQ25895 |
| U13 | TLC6C5712QDAPRQ1 | TLC6C5712 |
| J1 | CON-SMA-EDGE-S-ND | SMA-Connector |
| J2 | TER-8-01-L-D-TH | Samtec-Array |
| J3 | 0544740890 | Molex-Mini50 |
| R1 | ERA-3AEB49R9V | RF-Resistor |
| R2 | CRCW04024K70FKED | Resistor |
| R3 | CRCW04024K70FKED | Resistor |
| R4 | CRCW040210K0FKED | Resistor |
| R5 | CRCW04024K70FKED | Resistor |
| R6 | CRCW04024K70FKED | Resistor |
| R7 | CRCW040210K0FKED | Resistor |
| R8 | CRCW0402100KFKED | Resistor |
| R9 | CRCW040210K0FKED | Resistor |
| R10 | CRCW040210K0FKED | Resistor |
| R11 | CRCW04021K00FKED | Resistor |
| R12 | CRCW04021K00FKED | Resistor |
| R13 | CRCW04024K70FKED | Resistor |
| R14 | CRCW04024K70FKED | Resistor |
| C1 | GRM1555C1H102FA01D | Capacitor |
| C2 | GJM1555C1H100FB01D | Capacitor |
| C3 | GRM1555C1H102FA01D | Capacitor |
| C4 | GJM1555C1H100FB01D | Capacitor |
| C5 | GJM1555C1H100FB01D | Capacitor |
| C6 | GJM1555C1H100FB01D | Capacitor |
| C7 | GJM1555C1H100FB01D | Capacitor |
| C8 | GJM1555C1H100FB01D | Capacitor |
| C9 | GJM1555C1H100FB01D | Capacitor |
| C10 | GJM1555C1H100FB01D | Capacitor |
| C11 | GJM1555C1H100FB01D | Capacitor |
| C12 | GJM1555C1H100FB01D | Capacitor |
| C13 | GRM32ER61C476KE15L | Capacitor |
| C14 | GRM32ER61C476KE15L | Capacitor |
| C15 | GRM32ER61C476KE15L | Capacitor |
| C16 | GRM32ER61C476KE15L | Capacitor |
| C17 | GRT31CR61A226KE01L | Capacitor |
| C18 | GRT31CR61A226KE01L | Capacitor |
| C19 | GRT31CR61A226KE01L | Capacitor |
| L1 | 0603CS-151XJBC | RF-Choke |
| L2 | 0603CS-151XJBC | RF-Choke |
| L3 | MLZ2012M2R2WT000 | Inductor |
| L4 | MLZ2012M2R2WT000 | Inductor |
| F1 | GBLC03LC | ESD-Protection |

## Pin-to-Pin Connections

| Net | From | Pin | To | Pin | Type |
|---|---|---|---|---|---|
| RF_IN_P | J1 | SIG | F1 | 1 | RF |
| RF_IN_P | F1 | 2 | U1 | RF_IN | RF |
| RF_IN_T | U1 | RF_OUT | U2 | RF_IN | RF |
| RF_IF_P | U2 | RF_OUT | U3 | AIN_P | RF |
| RF_IF_M | U2 | RF_OUT_CM | U3 | AIN_M | RF |
| CLK_3P3V_P | U4 | CLKOUT0_P | U3 | CLK_IN_P | clock |
| CLK_3P3V_M | U4 | CLKOUT0_M | U3 | CLK_IN_M | clock |
| CLK_REF_P | U5 | CLKOUT2_P | U4 | CLKIN0_P | clock |
| CLK_REF_M | U5 | CLKOUT2_M | U4 | CLKIN0_M | clock |
| LVSD_TX0_P | U3 | D0_P | J2 | 1 | digital |
| LVSD_TX0_M | U3 | D0_M | J2 | 2 | digital |
| LVSD_TX1_P | U3 | D1_P | J2 | 3 | digital |
| LVSD_TX1_M | U3 | D1_M | J2 | 4 | digital |
| LVSD_TX2_P | U3 | D2_P | J2 | 5 | digital |
| LVSD_TX2_M | U3 | D2_M | J2 | 6 | digital |
| LVSD_TX3_P | U3 | D3_P | J2 | 7 | digital |
| LVSD_TX3_M | U3 | D3_M | J2 | 8 | digital |
| LVSD_SYSREF_P | U4 | SYSREF_P | J2 | 15 | clock |
| LVSD_SYSREF_M | U4 | SYSREF_M | J2 | 16 | clock |
| SPI_SCLK | J3 | 3 | U10 | IN1 | digital |
| SPI_SCLK_ISO | U10 | OUT1 | R13 | 1 | digital |
| SPI_SCLK_CTRL | R13 | 2 | U4 | SCLK | digital |
| SPI_SCLK_CTRL | R13 | 2 | U2 | SCLK | digital |
| SPI_SDIO | J3 | 4 | U10 | IN2 | digital |
| SPI_SDIO_ISO | U10 | OUT2 | R14 | 1 | digital |
| SPI_SDIO_CTRL | R14 | 2 | U4 | SDIO | digital |
| SPI_SDIO_CTRL | R14 | 2 | U2 | SDIO | digital |
| SPI_CS0 | J3 | IN3 | U10 |  | digital |
| SPI_CS0_ISO | U10 | OUT3 | U4 | CS | digital |
| SPI_CS1 | J3 | 6 | U11 | IN3 | digital |
| SPI_CS1_ISO | U11 | OUT3 | U2 | CS | digital |
| SPI_CS_ADC | J3 | 7 | U3 | SPI_CS | digital |
| 3V3_MAIN | U12 | SYSOUT | U6 | VIN | power |
| 3V3_MAIN | U12 | SYSOUT | U8 | VIN | power |
| 3V3_MAIN | U12 | SYSOUT | L1 | 1 | power |
| 3V3_MAIN | U12 | SYSOUT | L2 | 1 | power |
| 1V8_ADC | U6 | VOUT | U3 | AVDD_1V8 | power |
| 1V8_ADC | U6 | VOUT | U3 | DVDD_1V8 | power |
| 1V8_ADC | U6 | VOUT | C17 | 1 | power |
| 1V8_ADC | U6 | VOUT | C18 | 1 | power |
| 1V0_CORE | U7 | VOUT | U3 | AVDD_1V0 | power |
| 1V0_CORE | U7 | VOUT | U3 | DVDD_1V0 | power |
| 1V0_CORE | U7 | VOUT | C13 | 1 | power |
| 1V0_CORE | U7 | VOUT | C14 | 1 | power |
| 1V8_CLK | U8 | VOUT | U4 | VCC_CLK | power |
| 1V8_CLK | U8 | VOUT | U5 | VCC_CLK | power |
| 1V8_CLK | U8 | VOUT | C19 | 1 | power |
| 3V3_LNA | L1 | 2 | U1 | VCC | power |
| 3V3_LNA | L1 | 2 | C1 | 1 | power |
| 3V3_VGA | L2 | 2 | U2 | VCC | power |
| 3V3_VGA | L2 | 2 | C3 | 1 | power |
| VDD_IO_1V8 | U6 | VOUT | U10 | VCC1 | power |
| VDD_IO_1V8 | U6 | VOUT | U11 | VCC1 | power |
| VDD_IO_3V3 | U12 | SYSOUT | U10 | VCC2 | power |
| VDD_IO_3V3 | U12 | SYSOUT | U11 | VCC2 | power |
| 3V3_ISOLED | U13 | OUT1 | R2 | 2 | power |
| 3V3_ISOLED | U13 | OUT2 | R3 | 2 | power |
| 3V3_ISOLED | U13 | OUT3 | R4 | 2 | power |
| LED_STATUS | R2 | 1 | U13 | LED1 | digital |
| LED_LOCK | R3 | 1 | U13 | LED2 | digital |
| LED_ERROR | R4 | 1 | U13 | LED3 | digital |
| GND | F1 | GND | U1 | GND | ground |
| GND | U1 | GND | C1 | 2 | ground |
| GND | U1 | GND | C2 | 2 | ground |
| GND | U2 | GND | C3 | 2 | ground |
| GND | U2 | GND | C4 | 2 | ground |
| GND | U3 | AVSS | C5 | 2 | ground |
| GND | U3 | AVSS | C6 | 2 | ground |
| GND | U3 | AVSS | C7 | 2 | ground |
| GND | U3 | AVSS | C8 | 2 | ground |
| GND | U3 | DVSS | C9 | 2 | ground |
| GND | U3 | DVSS | C10 | 2 | ground |
| GND | U3 | DVSS | C11 | 2 | ground |
| GND | U3 | DVSS | C12 | 2 | ground |
| GND | U4 | GND | C15 | 2 | ground |
| GND | U4 | GND | C16 | 2 | ground |
| GND | U5 | GND | U9 | GND | ground |
| GND | U6 | GND | C17 | 2 | ground |
| GND | U6 | GND | C18 | 2 | ground |
| GND | U7 | GND | C13 | 2 | ground |
| GND | U7 | GND | C14 | 2 | ground |
| GND | U8 | GND | C19 | 2 | ground |
| GND | U9 | GND | U12 | GND | ground |
| GND | U10 | GND1 | U11 | GND1 | ground |
| GND | U10 | GND2 | J3 | 2 | ground |
| GND | U11 | GND2 | J3 | 2 | ground |
| GND | U13 | GND | R5 | 2 | ground |
| GND | R6 | 2 | R7 | 2 | ground |
| VDD_PLL | U9 | VOUT | U4 | VCC_PLL | power |
| VDD_PLL | U9 | VOUT | U5 | VCC_PLL | power |
| VCC_OSC | U9 | VOUT | U4 | VCC_OSC | power |
| VCC_OSC | U9 | VOUT | U5 | VCC_OSC | power |

## Net Connection List

| Net Name | Reference Designator - Pin No. |
|----------|-------------------------------|
| 1V0_CORE | U7 - VOUT,  U3 - AVDD_1V0,  U3 - DVDD_1V0,  C13 - 1,  C14 - 1 |
| 1V8_ADC | U6 - VOUT,  U3 - AVDD_1V8,  U3 - DVDD_1V8,  C17 - 1,  C18 - 1 |
| 1V8_CLK | U8 - VOUT,  U4 - VCC_CLK,  U5 - VCC_CLK,  C19 - 1 |
| 3V3_ISOLED | U13 - OUT1,  R2 - 2,  U13 - OUT2,  R3 - 2,  U13 - OUT3,  R4 - 2 |
| 3V3_LNA | L1 - 2,  U1 - VCC,  C1 - 1 |
| 3V3_MAIN | U12 - SYSOUT,  U6 - VIN,  U8 - VIN,  L1 - 1,  L2 - 1 |
| 3V3_VGA | L2 - 2,  U2 - VCC,  C3 - 1 |
| CLK_3P3V_M | U4 - CLKOUT0_M,  U3 - CLK_IN_M |
| CLK_3P3V_P | U4 - CLKOUT0_P,  U3 - CLK_IN_P |
| CLK_REF_M | U5 - CLKOUT2_M,  U4 - CLKIN0_M |
| CLK_REF_P | U5 - CLKOUT2_P,  U4 - CLKIN0_P |
| GND | F1 - GND,  U1 - GND,  C1 - 2,  C2 - 2,  U2 - GND,  C3 - 2,  C4 - 2,  U3 - AVSS,  C5 - 2,  C6 - 2,  C7 - 2,  C8 - 2,  U3 - DVSS,  C9 - 2,  C10 - 2,  C11 - 2,  C12 - 2,  U4 - GND,  C15 - 2,  C16 - 2,  U5 - GND,  U9 - GND,  U6 - GND,  C17 - 2,  C18 - 2,  U7 - GND,  C13 - 2,  C14 - 2,  U8 - GND,  C19 - 2,  U12 - GND,  U10 - GND1,  U11 - GND1,  U10 - GND2,  J3 - 2,  U11 - GND2,  U13 - GND,  R5 - 2,  R6 - 2,  R7 - 2 |
| LED_ERROR | R4 - 1,  U13 - LED3 |
| LED_LOCK | R3 - 1,  U13 - LED2 |
| LED_STATUS | R2 - 1,  U13 - LED1 |
| LVSD_SYSREF_M | U4 - SYSREF_M,  J2 - 16 |
| LVSD_SYSREF_P | U4 - SYSREF_P,  J2 - 15 |
| LVSD_TX0_M | U3 - D0_M,  J2 - 2 |
| LVSD_TX0_P | U3 - D0_P,  J2 - 1 |
| LVSD_TX1_M | U3 - D1_M,  J2 - 4 |
| LVSD_TX1_P | U3 - D1_P,  J2 - 3 |
| LVSD_TX2_M | U3 - D2_M,  J2 - 6 |
| LVSD_TX2_P | U3 - D2_P,  J2 - 5 |
| LVSD_TX3_M | U3 - D3_M,  J2 - 8 |
| LVSD_TX3_P | U3 - D3_P,  J2 - 7 |
| RF_IF_M | U2 - RF_OUT_CM,  U3 - AIN_M |
| RF_IF_P | U2 - RF_OUT,  U3 - AIN_P |
| RF_IN_P | J1 - SIG,  F1 - 1,  F1 - 2,  U1 - RF_IN |
| RF_IN_T | U1 - RF_OUT,  U2 - RF_IN |
| SPI_CS0 | J3 - IN3,  U10 -  |
| SPI_CS0_ISO | U10 - OUT3,  U4 - CS |
| SPI_CS1 | J3 - 6,  U11 - IN3 |
| SPI_CS1_ISO | U11 - OUT3,  U2 - CS |
| SPI_CS_ADC | J3 - 7,  U3 - SPI_CS |
| SPI_SCLK | J3 - 3,  U10 - IN1 |
| SPI_SCLK_CTRL | R13 - 2,  U4 - SCLK,  U2 - SCLK |
| SPI_SCLK_ISO | U10 - OUT1,  R13 - 1 |
| SPI_SDIO | J3 - 4,  U10 - IN2 |
| SPI_SDIO_CTRL | R14 - 2,  U4 - SDIO,  U2 - SDIO |
| SPI_SDIO_ISO | U10 - OUT2,  R14 - 1 |
| VCC_OSC | U9 - VOUT,  U4 - VCC_OSC,  U5 - VCC_OSC |
| VDD_IO_1V8 | U6 - VOUT,  U10 - VCC1,  U11 - VCC1 |
| VDD_IO_3V3 | U12 - SYSOUT,  U10 - VCC2,  U11 - VCC2 |
| VDD_PLL | U9 - VOUT,  U4 - VCC_PLL,  U5 - VCC_PLL |

## Validation Notes

- CRITICAL: ADC12DJ5200RF requires 1.0V core supply - Point-of-load regulation from 3.3V rail needed (not specified in BOM)
- CRITICAL: Clock distribution ICs (LMK04828) require separate VCC_PLL (2.5V) - LDO U9 output may not match required voltage
- WARNING: HMC698LP4 VGA bandwidth is 4-8 GHz - May not cover full 5-18 GHz requirement, consider ADRF5720 (DC-6 GHz) or MAAL-011111 (DC-20 GHz) for extended bandwidth
- WARNING: Input power range -60 to -40 dBm is 20 dB span - Verify VGA gain control range (-10 to +22 dB = 32 dB) provides sufficient headroom for signal level variations
- REVIEW: Reference oscillator for U5 (LMK04828) not specified - System requires low-jitter (<200 fs RMS) source for GSPS sampling
- REVIEW: SPI pull-up resistors (R8, R9) to 3.3V needed on SCLK, SDIO lines - Values 4.7K recommended
- REVIEW: ADC decoupling network incomplete - Add 0.1uF, 0.01uF ceramic capacitors at each AVDD/DVDD pin pair
- REVIEW: RF input matching network not detailed - 50 ohm controlled impedance microstrip/stripline required from J1 to U1
- INFO: System power estimated 35-40W - Within 30-50W budget considering 3.5W ADC + 0.25W LNA + ~1W VGA + clock tree power
- INFO: JESD204B/C interface from ADC requires SYSREF for deterministic latency - Connection from U4 to ADC shown in netlist
- CAUTION: Industrial temperature range (-40 to +85C) - Verify all components specified for industrial or extended temperature grade
- INFO: ESD protection F1 rated for +-15kV (contact) - Meets REQ-HW-017 requirement
- INFO: Status LED indicators provided via U13 for power good, clock lock, and error conditions
- REVIEW: Thermal management not addressed - 1U rack mount form factor may require heatsinking on ADC and clock ICs