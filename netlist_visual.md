# Logical Netlist
## rx module

## Block Diagram

```mermaid
graph TB
    U1[STM32L433CBT6 (STM32L433CBT6)]
    U2[RF Amplifier HMC384 (HMC384LP4)]
    U3[Digital Step Attenuator (HMC1119LP4E)]
    U4[Power Detector (AD8318ACPZ)]
    U5[Temp Sensor (TMP102AIDRLR)]
    U6[3.3V LDO Regulator (AMS1117-3.3)]
    U7[5V LDO Regulator (AMS1117-5.0)]
    Q1[N-Channel MOSFET (DMG3406L-7)]
    Q2[N-Channel MOSFET (DMG3406L-7)]
    D1[Schottky Diode (BAT54C)]
    J1[SMA Connector RF (SMA-PCB-EDGE)]
    J2[SMA Connector RF (SMA-PCB-EDGE)]
    J3[System Interface Header (HDR-12PIN-2.54MM)]
    R1[Resistor (RC0805FR-0710KL)]
    R2[Resistor (RC0805FR-0710KL)]
    R3[Resistor (RC0805FR-0710KL)]
    R4[Resistor (RC0805FR-072K4L)]
    R5[Resistor (RC0805FR-072K4L)]
    R6[Resistor (RC0805FR-07100KL)]
    R7[Resistor (RC0805FR-0710KL)]
    R8[Resistor (RC0805FR-074K7L)]
    R9[Resistor (RC0805FR-07100KL)]
    R10[Resistor (RC0805FR-0710KL)]
    R11[Resistor (RC0805FR-072K2L)]
    R12[Resistor (RC0805FR-074K7L)]
    R13[Resistor (RC0805FR-07100KL)]
    R14[Resistor (RC0805FR-0747KL)]
    R15[Resistor (RC0805FR-072K2L)]
    C1[Capacitor (CL21B104KBCNNNC)]
    C2[Capacitor (CL21B104KBCNNNC)]
    C3[Capacitor (CL21B104KBCNNNC)]
    C4[Capacitor (GRM188R61E106KA73D)]
    C5[Capacitor (GRM188R61E106KA73D)]
    C6[Capacitor (GRM188R61E106KA73D)]
    C7[Capacitor (GRM188R61E106KA73D)]
    C8[Capacitor (GRM188R61E106KA73D)]
    C9[Capacitor (GRM188R61E106KA73D)]
    C10[Capacitor (GRM188R61E106KA73D)]
    C11[Capacitor (CL21B104KBCNNNC)]
    C12[Capacitor (CL21B104KBCNNNC)]
    C13[Capacitor (CL21B104KBCNNNC)]
    C14[Capacitor (GRM188R61E106KA73D)]
    C15[Capacitor (CL21B104KBCNNNC)]
    C16[Capacitor (GRM188R61E106KA73D)]
    C17[Capacitor (GRM188R61E106KA73D)]
    L1[Inductor (LQG31PN2N2B02D)]
    L2[Inductor (LQG31PN2N2B02D)]
    LED1[LED Green (LTST-C191KGKT)]
    J1 -->|RF_IN| U3
    U3 -->|RF_DSA_OUT| U2
    U2 -->|RF_OUT| J2
    U2 -->|RF_COUPLE| U4
    U4 -->|VDET_OUT| U1
    U1 -->|VGG_CTRL| Q1
    Q1 -->|VGG| U2
    U1 -->|PA_ENABLE| Q2
    Q2 -->|DRV_ENABLE| U2
    U1 -->|SPI_SCK| U3
    U1 -->|SPI_MOSI| U3
    U1 -->|SPI_CS| U3
    U1 -->|I2C_SCL| U5
    U1 -->|I2C_SDA| U5
    U1 -->|I2C_SCL_SYS| J3
    U1 -->|I2C_SDA_SYS| J3
    J3 -->|SYS_RXD| U1
    U1 -->|SYS_TXD| J3
    J3 -->|MCU_RESET| U1
    U5 -->|TEMP_ALERT| U1
    U4 -->|OVP_TRIG| U1
    U1 -->|STAT_LED| LED1
    U7 -->|5V0| U6
    U7 -->|5V0| U4
    U7 -->|5V0| Q2
    U7 -->|5V0| C14
    U6 -->|3V3| U1
    U6 -->|3V3| U3
    U6 -->|3V3| U5
    U6 -->|3V3| J3
    U6 -->|3V3| C15
    J3 -->|VIN| U7
    J3 -->|VIN| C11
    U1 -->|GND| GND
    U2 -->|GND| GND
    U3 -->|GND| GND
    U4 -->|GND| GND
    U5 -->|GND| GND
    U6 -->|GND| GND
    U7 -->|GND| GND
    Q1 -->|GND| GND
    LED1 -->|GND| GND
    J3 -->|GND| GND
    C1 -->|GND| GND
    C2 -->|GND| GND
    C3 -->|GND| GND
    C4 -->|GND| GND
    C5 -->|GND| GND
    C6 -->|GND| GND
    C7 -->|GND| GND
    C8 -->|GND| GND
    C9 -->|GND| GND
    C10 -->|GND| GND
    C11 -->|GND| GND
    C12 -->|GND| GND
    C13 -->|GND| GND
    C14 -->|GND| GND
    C15 -->|GND| GND
    C16 -->|GND| GND
    C17 -->|GND| GND
    Q1 -->|VGG_FILT| C4
    C4 -->|VGG_FILT| L1
    Q1 -->|VGG_PULLDN| R5
    Q2 -->|PA_EN_PULLUP| R7
    R7 -->|PA_EN_PULLUP| Q2
    LED1 -->|STAT_LED_CUR| R12
    R12 -->|STAT_LED_CUR| U1
    U1 -->|ADC_FILT1| R1
    R1 -->|ADC_FILT1| C1
    C1 -->|ADC_FILT1| U4
    U1 -->|ADC_FILT2| R2
    R2 -->|ADC_FILT2| C2
    U1 -->|I2C_SCL_PU| R8
    R8 -->|I2C_SCL_PU| U6
    U1 -->|I2C_SDA_PU| R9
    R9 -->|I2C_SDA_PU| U6
    U1 -->|SPI_SCK_PU| R10
    R10 -->|SPI_SCK_PU| U6
    U1 -->|SPI_MOSI_PU| R11
    R11 -->|SPI_MOSI_PU| U6
    U1 -->|CS_PU| R13
    R13 -->|CS_PU| U6
    J3 -->|RST_PU| R14
    R14 -->|RST_PU| U6
    U1 -->|VGG_GATE_R| R6
    R6 -->|VGG_GATE_R| Q1
    U1 -->|PA_EN_GATE_R| R15
    R15 -->|PA_EN_GATE_R| Q2
    U6 -->|3V3_BYP| C16
    C16 -->|3V3_BYP| GND
    U7 -->|5V0_BYP| C17
    C17 -->|5V0_BYP| GND
    U1 -->|BOOT0| R3
    R3 -->|BOOT0| GND
    U1 -->|NRST_FILT| C3
    C3 -->|NRST_FILT| J3
    U1 -->|VDD_DEC1| C5
    U1 -->|VDD_DEC2| C6
    U1 -->|VDD_DEC3| C7
    U1 -->|VDD_DEC4| C8
    U3 -->|DSA_VDD_DEC| C9
    U3 -->|RF_GND1| C10
    C10 -->|RF_GND1| L2
    L2 -->|RF_GND1| GND
    U5 -->|TEMP_SDA_PU| R4
    R4 -->|TEMP_SDA_PU| U6
    U2 -->|DRV_VDD_DEC| C12
    U2 -->|DRV_VGG_DEC| C13
```

## Component Instances

| Ref | Part Number | Component |
|---|---|---|
| U1 | STM32L433CBT6 | STM32L433CBT6 |
| U2 | HMC384LP4 | RF Amplifier HMC384 |
| U3 | HMC1119LP4E | Digital Step Attenuator |
| U4 | AD8318ACPZ | Power Detector |
| U5 | TMP102AIDRLR | Temp Sensor |
| U6 | AMS1117-3.3 | 3.3V LDO Regulator |
| U7 | AMS1117-5.0 | 5V LDO Regulator |
| Q1 | DMG3406L-7 | N-Channel MOSFET |
| Q2 | DMG3406L-7 | N-Channel MOSFET |
| D1 | BAT54C | Schottky Diode |
| J1 | SMA-PCB-EDGE | SMA Connector RF |
| J2 | SMA-PCB-EDGE | SMA Connector RF |
| J3 | HDR-12PIN-2.54MM | System Interface Header |
| R1 | RC0805FR-0710KL | Resistor |
| R2 | RC0805FR-0710KL | Resistor |
| R3 | RC0805FR-0710KL | Resistor |
| R4 | RC0805FR-072K4L | Resistor |
| R5 | RC0805FR-072K4L | Resistor |
| R6 | RC0805FR-07100KL | Resistor |
| R7 | RC0805FR-0710KL | Resistor |
| R8 | RC0805FR-074K7L | Resistor |
| R9 | RC0805FR-07100KL | Resistor |
| R10 | RC0805FR-0710KL | Resistor |
| R11 | RC0805FR-072K2L | Resistor |
| R12 | RC0805FR-074K7L | Resistor |
| R13 | RC0805FR-07100KL | Resistor |
| R14 | RC0805FR-0747KL | Resistor |
| R15 | RC0805FR-072K2L | Resistor |
| C1 | CL21B104KBCNNNC | Capacitor |
| C2 | CL21B104KBCNNNC | Capacitor |
| C3 | CL21B104KBCNNNC | Capacitor |
| C4 | GRM188R61E106KA73D | Capacitor |
| C5 | GRM188R61E106KA73D | Capacitor |
| C6 | GRM188R61E106KA73D | Capacitor |
| C7 | GRM188R61E106KA73D | Capacitor |
| C8 | GRM188R61E106KA73D | Capacitor |
| C9 | GRM188R61E106KA73D | Capacitor |
| C10 | GRM188R61E106KA73D | Capacitor |
| C11 | CL21B104KBCNNNC | Capacitor |
| C12 | CL21B104KBCNNNC | Capacitor |
| C13 | CL21B104KBCNNNC | Capacitor |
| C14 | GRM188R61E106KA73D | Capacitor |
| C15 | CL21B104KBCNNNC | Capacitor |
| C16 | GRM188R61E106KA73D | Capacitor |
| C17 | GRM188R61E106KA73D | Capacitor |
| L1 | LQG31PN2N2B02D | Inductor |
| L2 | LQG31PN2N2B02D | Inductor |
| LED1 | LTST-C191KGKT | LED Green |

## Pin-to-Pin Connections

| Net | From | Pin | To | Pin | Type |
|---|---|---|---|---|---|
| RF_IN | J1 | SIG | U3 | RF_IN | analog |
| RF_DSA_OUT | U3 | RF_OUT | U2 | RF_IN | analog |
| RF_OUT | U2 | RF_OUT | J2 | SIG | analog |
| RF_COUPLE | U2 | RF_OUT | U4 | IN | analog |
| VDET_OUT | U4 | VOUT | U1 | PA5 | analog |
| VGG_CTRL | U1 | PA8 | Q1 | GATE | digital |
| VGG | Q1 | DRAIN | U2 | VGG | power |
| PA_ENABLE | U1 | PB0 | Q2 | GATE | digital |
| DRV_ENABLE | Q2 | DRAIN | U2 | ENABLE | power |
| SPI_SCK | U1 | PA5 | U3 | SCLK | digital |
| SPI_MOSI | U1 | PA7 | U3 | SDI | digital |
| SPI_CS | U1 | PA4 | U3 | LE | digital |
| I2C_SCL | U1 | PB6 | U5 | SCL | digital |
| I2C_SDA | U1 | PB7 | U5 | SDA | digital |
| I2C_SCL_SYS | U1 | PB6 | J3 | 3 | digital |
| I2C_SDA_SYS | U1 | PB7 | J3 | 2 | digital |
| SYS_RXD | J3 | 5 | U1 | PA10 | digital |
| SYS_TXD | U1 | PA9 | J3 | 6 | digital |
| MCU_RESET | J3 | 4 | U1 | NRST | digital |
| TEMP_ALERT | U5 | ALERT | U1 | PB1 | digital |
| OVP_TRIG | U4 | VOUT | U1 | PA6 | analog |
| STAT_LED | U1 | PC13 | LED1 | ANODE | digital |
| 5V0 | U7 | OUT | U6 | IN | power |
| 5V0 | U7 | OUT | U4 | VPOS | power |
| 5V0 | U7 | OUT | Q2 | SOURCE | power |
| 5V0 | U7 | OUT | C14 | 1 | power |
| 3V3 | U6 | OUT | U1 | VDD | power |
| 3V3 | U6 | OUT | U3 | VDD | power |
| 3V3 | U6 | OUT | U5 | VDD | power |
| 3V3 | U6 | OUT | J3 | 1 | power |
| 3V3 | U6 | OUT | C15 | 1 | power |
| VIN | J3 | 12 | U7 | IN | power |
| VIN | J3 | 12 | C11 | 1 | power |
| GND | U1 | VSS | GND | 0 | ground |
| GND | U2 | GND | GND | 0 | ground |
| GND | U3 | GND | GND | 0 | ground |
| GND | U4 | COMM | GND | 0 | ground |
| GND | U5 | GND | GND | 0 | ground |
| GND | U6 | GND | GND | 0 | ground |
| GND | U7 | GND | GND | 0 | ground |
| GND | Q1 | SOURCE | GND | 0 | ground |
| GND | LED1 | CATHODE | GND | 0 | ground |
| GND | J3 | 11 | GND | 0 | ground |
| GND | C1 | 2 | GND | 0 | ground |
| GND | C2 | 2 | GND | 0 | ground |
| GND | C3 | 2 | GND | 0 | ground |
| GND | C4 | 2 | GND | 0 | ground |
| GND | C5 | 2 | GND | 0 | ground |
| GND | C6 | 2 | GND | 0 | ground |
| GND | C7 | 2 | GND | 0 | ground |
| GND | C8 | 2 | GND | 0 | ground |
| GND | C9 | 2 | GND | 0 | ground |
| GND | C10 | 2 | GND | 0 | ground |
| GND | C11 | 2 | GND | 0 | ground |
| GND | C12 | 2 | GND | 0 | ground |
| GND | C13 | 2 | GND | 0 | ground |
| GND | C14 | 2 | GND | 0 | ground |
| GND | C15 | 2 | GND | 0 | ground |
| GND | C16 | 2 | GND | 0 | ground |
| GND | C17 | 2 | GND | 0 | ground |
| VGG_FILT | Q1 | DRAIN | C4 | 1 | power |
| VGG_FILT | C4 | 1 | L1 | 2 | power |
| VGG_PULLDN | Q1 | GATE | R5 | 1 | power |
| PA_EN_PULLUP | Q2 | GATE | R7 | 1 | power |
| PA_EN_PULLUP | R7 | 2 | Q2 | SOURCE | power |
| STAT_LED_CUR | LED1 | ANODE | R12 | 1 | power |
| STAT_LED_CUR | R12 | 2 | U1 | PC13 | power |
| ADC_FILT1 | U1 | PA5 | R1 | 2 | analog |
| ADC_FILT1 | R1 | 1 | C1 | 1 | analog |
| ADC_FILT1 | C1 | 1 | U4 | VOUT | analog |
| ADC_FILT2 | U1 | PA6 | R2 | 2 | analog |
| ADC_FILT2 | R2 | 1 | C2 | 1 | analog |
| I2C_SCL_PU | U1 | PB6 | R8 | 1 | digital |
| I2C_SCL_PU | R8 | 2 | U6 | OUT | power |
| I2C_SDA_PU | U1 | PB7 | R9 | 1 | digital |
| I2C_SDA_PU | R9 | 2 | U6 | OUT | power |
| SPI_SCK_PU | U1 | PA5 | R10 | 1 | digital |
| SPI_SCK_PU | R10 | 2 | U6 | OUT | power |
| SPI_MOSI_PU | U1 | PA7 | R11 | 1 | digital |
| SPI_MOSI_PU | R11 | 2 | U6 | OUT | power |
| CS_PU | U1 | PA4 | R13 | 1 | digital |
| CS_PU | R13 | 2 | U6 | OUT | power |
| RST_PU | J3 | 4 | R14 | 1 | power |
| RST_PU | R14 | 2 | U6 | OUT | power |
| VGG_GATE_R | U1 | PA8 | R6 | 2 | power |
| VGG_GATE_R | R6 | 1 | Q1 | GATE | power |
| PA_EN_GATE_R | U1 | PB0 | R15 | 2 | power |
| PA_EN_GATE_R | R15 | 1 | Q2 | GATE | power |
| 3V3_BYP | U6 | BP | C16 | 1 | power |
| 3V3_BYP | C16 | 2 | GND | 0 | ground |
| 5V0_BYP | U7 | BP | C17 | 1 | power |
| 5V0_BYP | C17 | 2 | GND | 0 | ground |
| BOOT0 | U1 | BOOT0 | R3 | 1 | digital |
| BOOT0 | R3 | 2 | GND | 0 | ground |
| NRST_FILT | U1 | NRST | C3 | 1 | power |
| NRST_FILT | C3 | 1 | J3 | 4 | power |
| VDD_DEC1 | U1 | VDD | C5 | 1 | power |
| VDD_DEC2 | U1 | VDD | C6 | 1 | power |
| VDD_DEC3 | U1 | VDD | C7 | 1 | power |
| VDD_DEC4 | U1 | VDD | C8 | 1 | power |
| DSA_VDD_DEC | U3 | VDD | C9 | 1 | power |
| RF_GND1 | U3 | GND | C10 | 2 | ground |
| RF_GND1 | C10 | 1 | L2 | 2 | ground |
| RF_GND1 | L2 | 1 | GND | 0 | ground |
| TEMP_SDA_PU | U5 | SDA | R4 | 2 | digital |
| TEMP_SDA_PU | R4 | 1 | U6 | OUT | power |
| DRV_VDD_DEC | U2 | VCC | C12 | 1 | power |
| DRV_VGG_DEC | U2 | VGG | C13 | 1 | power |

## Net Connection List

| Net Name | Reference Designator - Pin No. |
|----------|-------------------------------|
| 3V3 | U6 - OUT,  U1 - VDD,  U3 - VDD,  U5 - VDD,  J3 - 1,  C15 - 1 |
| 3V3_BYP | U6 - BP,  C16 - 1,  C16 - 2,  GND - 0 |
| 5V0 | U7 - OUT,  U6 - IN,  U4 - VPOS,  Q2 - SOURCE,  C14 - 1 |
| 5V0_BYP | U7 - BP,  C17 - 1,  C17 - 2,  GND - 0 |
| ADC_FILT1 | U1 - PA5,  R1 - 2,  R1 - 1,  C1 - 1,  U4 - VOUT |
| ADC_FILT2 | U1 - PA6,  R2 - 2,  R2 - 1,  C2 - 1 |
| BOOT0 | U1 - BOOT0,  R3 - 1,  R3 - 2,  GND - 0 |
| CS_PU | U1 - PA4,  R13 - 1,  R13 - 2,  U6 - OUT |
| DRV_ENABLE | Q2 - DRAIN,  U2 - ENABLE |
| DRV_VDD_DEC | U2 - VCC,  C12 - 1 |
| DRV_VGG_DEC | U2 - VGG,  C13 - 1 |
| DSA_VDD_DEC | U3 - VDD,  C9 - 1 |
| GND | U1 - VSS,  GND - 0,  U2 - GND,  U3 - GND,  U4 - COMM,  U5 - GND,  U6 - GND,  U7 - GND,  Q1 - SOURCE,  LED1 - CATHODE,  J3 - 11,  C1 - 2,  C2 - 2,  C3 - 2,  C4 - 2,  C5 - 2,  C6 - 2,  C7 - 2,  C8 - 2,  C9 - 2,  C10 - 2,  C11 - 2,  C12 - 2,  C13 - 2,  C14 - 2,  C15 - 2,  C16 - 2,  C17 - 2 |
| I2C_SCL | U1 - PB6,  U5 - SCL |
| I2C_SCL_PU | U1 - PB6,  R8 - 1,  R8 - 2,  U6 - OUT |
| I2C_SCL_SYS | U1 - PB6,  J3 - 3 |
| I2C_SDA | U1 - PB7,  U5 - SDA |
| I2C_SDA_PU | U1 - PB7,  R9 - 1,  R9 - 2,  U6 - OUT |
| I2C_SDA_SYS | U1 - PB7,  J3 - 2 |
| MCU_RESET | J3 - 4,  U1 - NRST |
| NRST_FILT | U1 - NRST,  C3 - 1,  J3 - 4 |
| OVP_TRIG | U4 - VOUT,  U1 - PA6 |
| PA_ENABLE | U1 - PB0,  Q2 - GATE |
| PA_EN_GATE_R | U1 - PB0,  R15 - 2,  R15 - 1,  Q2 - GATE |
| PA_EN_PULLUP | Q2 - GATE,  R7 - 1,  R7 - 2,  Q2 - SOURCE |
| RF_COUPLE | U2 - RF_OUT,  U4 - IN |
| RF_DSA_OUT | U3 - RF_OUT,  U2 - RF_IN |
| RF_GND1 | U3 - GND,  C10 - 2,  C10 - 1,  L2 - 2,  L2 - 1,  GND - 0 |
| RF_IN | J1 - SIG,  U3 - RF_IN |
| RF_OUT | U2 - RF_OUT,  J2 - SIG |
| RST_PU | J3 - 4,  R14 - 1,  R14 - 2,  U6 - OUT |
| SPI_CS | U1 - PA4,  U3 - LE |
| SPI_MOSI | U1 - PA7,  U3 - SDI |
| SPI_MOSI_PU | U1 - PA7,  R11 - 1,  R11 - 2,  U6 - OUT |
| SPI_SCK | U1 - PA5,  U3 - SCLK |
| SPI_SCK_PU | U1 - PA5,  R10 - 1,  R10 - 2,  U6 - OUT |
| STAT_LED | U1 - PC13,  LED1 - ANODE |
| STAT_LED_CUR | LED1 - ANODE,  R12 - 1,  R12 - 2,  U1 - PC13 |
| SYS_RXD | J3 - 5,  U1 - PA10 |
| SYS_TXD | U1 - PA9,  J3 - 6 |
| TEMP_ALERT | U5 - ALERT,  U1 - PB1 |
| TEMP_SDA_PU | U5 - SDA,  R4 - 2,  R4 - 1,  U6 - OUT |
| VDD_DEC1 | U1 - VDD,  C5 - 1 |
| VDD_DEC2 | U1 - VDD,  C6 - 1 |
| VDD_DEC3 | U1 - VDD,  C7 - 1 |
| VDD_DEC4 | U1 - VDD,  C8 - 1 |
| VDET_OUT | U4 - VOUT,  U1 - PA5 |
| VGG | Q1 - DRAIN,  U2 - VGG |
| VGG_CTRL | U1 - PA8,  Q1 - GATE |
| VGG_FILT | Q1 - DRAIN,  C4 - 1,  L1 - 2 |
| VGG_GATE_R | U1 - PA8,  R6 - 2,  R6 - 1,  Q1 - GATE |
| VGG_PULLDN | Q1 - GATE,  R5 - 1 |
| VIN | J3 - 12,  U7 - IN,  C11 - 1 |

## Validation Notes

- WARNING: PA5 pin conflict - SPI_SCK and ADC input share MCU pin PA5. Requires careful GPIO mode configuration or pin remapping.
- WARNING: RF coupling path from U2 to U4 not terminated - may need 50-ohm termination or coupler validation
- INFO: DSA control interface uses 3-wire SPI (SCLK, SDI, LE) - verify HMC1119 compatibility with STM32L4 SPI peripheral
- INFO: VGG control via MOSFET Q1 - ensure gate drive voltage (3.3V MCU) sufficient for VGG regulation range
- WARNING: No TVS/ESD protection on RF input J1 - consider adding ESD protection diode for RF port protection
- INFO: I2C pullups (R8, R9) set at 4.7k to 3.3V - verify I2C bus capacitance for system header cable length
- WARNING: OVP detection uses MCU ADC - threshold comparison in software may be too slow for fast overvoltage events
- INFO: TEMP_ALERT from TMP102 is active-low - ensure MCU interrupt configured for falling edge
- WARNING: Decoupling capacitor C10 (RF ground) connected via ferrite bead L2 - verify resonance frequency not in RF band
- INFO: Boot0 tied to GND via R3 - MCU will boot from main flash memory
- INFO: Multiple VDD pins on MCU (C5-C8) - ensure all power pins properly decoupled per datasheet
- WARNING: No external crystal specified - MCU using internal HSI oscillator; verify clock accuracy for UART timing
- INFO: Status LED current limiting via R12 (4.7k) at 3.3V results in ~0.7mA - LED may be dim in high ambient light
- WARNING: Power budget estimate: MCU ~8mA, DSA ~5mA, Amp ~200mA (when enabled), Detector ~4mA, Temp sensor ~0.5mA. Total ~220mA worst case. Verify 5V LDO and VIN supply capacity.
- INFO: RESET line pulled up via R14 (470k) to 3.3V - weak pullup may need stronger value for long cable to system header
- WARNING: No reverse polarity protection on VIN input - consider adding diode or ideal diode circuit