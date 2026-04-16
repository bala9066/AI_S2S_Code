# Logical Netlist
## rx receiver

## Block Diagram

```mermaid
graph TB
    U1[Wideband LNA (HMC6180LP4E)]
    U2[IQ Demodulator Mixer (HMC519LC4)]
    U3[Wideband IQ Mixer (MIXIQ-1030)]
    U4[PLL Synthesizer with VCO (LMX2594RHAR)]
    U5[Dual ADC 250 MSPS (AD9680BCPZ-250)]
    U6[MCU Controller (STM32F407VGT6)]
    J1[RF Input SMA Connector (SMA-50-0-0-13)]
    U7[12V LDO Regulator (LM2941-12)]
    U8[5V Buck Converter (TPS54332)]
    U9[3.3V Buck Converter (TPS62130)]
    U10[3.3V Voltage Supervisor (MIC9430-44YM)]
    L1[RF Choke Inductor 15nH (ELJ-FA1N5KF2)]
    L2[RF Choke Inductor 15nH (ELJ-FA1N5KF2)]
    L3[Power Inductor 4.7uH (74404014470)]
    L4[Power Inductor 4.7uH (74404014470)]
    T1[RF Transformer 1:1 Balun (TC1-1-13M+)]
    T2[RF Transformer 1:1 Balun (TC1-1-13M+)]
    R1[Resistor 100k 1% (CRCW0402100KFKED)]
    R2[Resistor 100k 1% (CRCW0402100KFKED)]
    R3[Resistor 4.7k 1% (CRCW04024K70FKED)]
    R4[Resistor 4.7k 1% (CRCW04024K70FKED)]
    R5[Resistor 4.7k 1% (CRCW04024K70FKED)]
    R6[Resistor 4.99k 0.1% (ERA-2AEB499X)]
    R7[Resistor 4.99k 0.1% (ERA-2AEB499X)]
    R8[Resistor 100k 1% (CRCW0402100KFKED)]
    R9[Resistor 100k 1% (CRCW0402100KFKED)]
    R10[Resistor 4.7k 1% (CRCW04024K70FKED)]
    R11[Resistor 100k 1% (CRCW0402100KFKED)]
    R12[Resistor 100k 1% (CRCW0402100KFKED)]
    C1[Capacitor 0.1uF 50V (0402B104K500CT)]
    C2[Capacitor 0.1uF 50V (0402B104K500CT)]
    C3[Capacitor 0.1uF 50V (0402B104K500CT)]
    C4[Capacitor 0.1uF 50V (0402B104K500CT)]
    C5[Capacitor 0.1uF 50V (0402B104K500CT)]
    C6[Capacitor 0.1uF 50V (0402B104K500CT)]
    C7[Capacitor 4.7uF 6.3V (GRT155R61H475ME13D)]
    C8[Capacitor 0.1uF 50V (0402B104K500CT)]
    C9[Capacitor 0.1uF 50V (0402B104K500CT)]
    C10[Capacitor 0.1uF 50V (0402B104K500CT)]
    C11[Capacitor 4.7uF 6.3V (GRT155R61H475ME13D)]
    C12[Capacitor 0.1uF 50V (0402B104K500CT)]
    C13[Capacitor 0.1uF 50V (0402B104K500CT)]
    C14[Capacitor 1.0uF 10V (GRT155R61H105KE13D)]
    C15[Capacitor 0.1uF 50V (0402B104K500CT)]
    C16[Capacitor 0.1uF 50V (0402B104K500CT)]
    C17[Capacitor 0.1uF 50V (0402B104K500CT)]
    C18[Capacitor 4.7uF 16V (CL21A475KOCNNNE)]
    C19[Capacitor 0.1uF 50V (0402B104K500CT)]
    C20[Capacitor 0.1uF 50V (0402B104K500CT)]
    C21[Capacitor 22uF 50V (GRM32ER71H226KE15L)]
    C22[Capacitor 4.7uF 16V (CL21A475KOCNNNE)]
    C23[Capacitor 4.7uF 16V (CL21A475KOCNNNE)]
    C24[Capacitor 0.1uF 50V (0402B104K500CT)]
    C25[Capacitor 4.7uF 16V (CL21A475KOCNNNE)]
    J1 -->|RF_IN_5_18GHZ| U1
    U1 -->|RF_PATH_LNA_TO_MIXER1| U2
    U1 -->|RF_PATH_LNA_TO_MIXER2| U3
    U4 -->|LO_OUT_PLL_TO_MIX1| U2
    U4 -->|LO_OUT_PLL_TO_MIX2| U3
    U2 -->|I_OUT_M1_P| T1
    U2 -->|I_OUT_M1_N| T1
    U2 -->|Q_OUT_M1_P| T2
    U2 -->|Q_OUT_M1_N| T2
    U5 -->|ADC_DCO_P| U6
    U5 -->|ADC_DCO_N| U6
    U5 -->|ADC_FR_P| U6
    U5 -->|ADC_FR_N| U6
    U6 -->|SPI_SCLK| U4
    U6 -->|SPI_SCLK| U5
    U6 -->|SPI_SDIO| U4
    U6 -->|SPI_SDIO| U5
    U6 -->|PLL_CS_N| U4
    U6 -->|ADC_CS_N| U5
    U6 -->|PLL_CE| U4
    J1 -->|12V_IN| U7
    U7 -->|12V_REG_OUT| U8
    U8 -->|5V_REG_OUT| U9
    U8 -->|5V_REG_OUT| U1
    U8 -->|5V_REG_OUT| U2
    U9 -->|3.3V_REG_OUT| U4
    U9 -->|3.3V_REG_OUT| U5
    U9 -->|3.3V_REG_OUT| U6
    U9 -->|3.3V_REG_OUT| U10
    U9 -->|3.3V_REG_OUT| R6
    U9 -->|3.3V_REG_OUT| R7
    U1 -->|GND| U1
    U2 -->|GND| U2
    U3 -->|GND| U3
    U4 -->|GND| U5
    U5 -->|GND| U6
    U6 -->|GND| U7
    U7 -->|GND| U8
    U8 -->|GND| U9
    U9 -->|GND| U10
    U10 -->|3.3V_REF_OUT| U4
    U10 -->|3.3V_REF_OUT| U5
    U10 -->|3.3V_REF_OUT| U6
    U4 -->|VDD_PLL_FILTER| C7
    U4 -->|VDD_PLL_FILTER| C8
    U4 -->|VDD_PLL_FILTER| C9
    U4 -->|VDD_PLL_FILTER| L3
    U4 -->|VDD_PLL_FILTER| C10
    U4 -->|VDD_PLL_FILTER| C11
    U5 -->|VDD_ADC| C12
    U5 -->|VDD_ADC| C13
    U5 -->|VDD_ADC| C14
    U5 -->|VDD_ADC| L4
    U6 -->|VDD_MCU| C15
    U6 -->|VDD_MCU| C16
    U6 -->|VDD_MCU| C17
    U8 -->|VDD_5V_REG| C19
    U8 -->|VDD_5V_REG| C20
    U7 -->|VDD_12V_REG| C18
    U9 -->|VDD_3.3V_REG| C22
    U9 -->|VDD_3.3V_REG| C23
    U9 -->|VDD_3.3V_REG| C24
    J1 -->|VDD_INPUT| C21
    J1 -->|VDD_INPUT| C25
```

## Component Instances

| Ref | Part Number | Component |
|---|---|---|
| U1 | HMC6180LP4E | Wideband LNA |
| U2 | HMC519LC4 | IQ Demodulator Mixer |
| U3 | MIXIQ-1030 | Wideband IQ Mixer |
| U4 | LMX2594RHAR | PLL Synthesizer with VCO |
| U5 | AD9680BCPZ-250 | Dual ADC 250 MSPS |
| U6 | STM32F407VGT6 | MCU Controller |
| J1 | SMA-50-0-0-13 | RF Input SMA Connector |
| U7 | LM2941-12 | 12V LDO Regulator |
| U8 | TPS54332 | 5V Buck Converter |
| U9 | TPS62130 | 3.3V Buck Converter |
| U10 | MIC9430-44YM | 3.3V Voltage Supervisor |
| L1 | ELJ-FA1N5KF2 | RF Choke Inductor 15nH |
| L2 | ELJ-FA1N5KF2 | RF Choke Inductor 15nH |
| L3 | 74404014470 | Power Inductor 4.7uH |
| L4 | 74404014470 | Power Inductor 4.7uH |
| T1 | TC1-1-13M+ | RF Transformer 1:1 Balun |
| T2 | TC1-1-13M+ | RF Transformer 1:1 Balun |
| R1 | CRCW0402100KFKED | Resistor 100k 1% |
| R2 | CRCW0402100KFKED | Resistor 100k 1% |
| R3 | CRCW04024K70FKED | Resistor 4.7k 1% |
| R4 | CRCW04024K70FKED | Resistor 4.7k 1% |
| R5 | CRCW04024K70FKED | Resistor 4.7k 1% |
| R6 | ERA-2AEB499X | Resistor 4.99k 0.1% |
| R7 | ERA-2AEB499X | Resistor 4.99k 0.1% |
| R8 | CRCW0402100KFKED | Resistor 100k 1% |
| R9 | CRCW0402100KFKED | Resistor 100k 1% |
| R10 | CRCW04024K70FKED | Resistor 4.7k 1% |
| R11 | CRCW0402100KFKED | Resistor 100k 1% |
| R12 | CRCW0402100KFKED | Resistor 100k 1% |
| C1 | 0402B104K500CT | Capacitor 0.1uF 50V |
| C2 | 0402B104K500CT | Capacitor 0.1uF 50V |
| C3 | 0402B104K500CT | Capacitor 0.1uF 50V |
| C4 | 0402B104K500CT | Capacitor 0.1uF 50V |
| C5 | 0402B104K500CT | Capacitor 0.1uF 50V |
| C6 | 0402B104K500CT | Capacitor 0.1uF 50V |
| C7 | GRT155R61H475ME13D | Capacitor 4.7uF 6.3V |
| C8 | 0402B104K500CT | Capacitor 0.1uF 50V |
| C9 | 0402B104K500CT | Capacitor 0.1uF 50V |
| C10 | 0402B104K500CT | Capacitor 0.1uF 50V |
| C11 | GRT155R61H475ME13D | Capacitor 4.7uF 6.3V |
| C12 | 0402B104K500CT | Capacitor 0.1uF 50V |
| C13 | 0402B104K500CT | Capacitor 0.1uF 50V |
| C14 | GRT155R61H105KE13D | Capacitor 1.0uF 10V |
| C15 | 0402B104K500CT | Capacitor 0.1uF 50V |
| C16 | 0402B104K500CT | Capacitor 0.1uF 50V |
| C17 | 0402B104K500CT | Capacitor 0.1uF 50V |
| C18 | CL21A475KOCNNNE | Capacitor 4.7uF 16V |
| C19 | 0402B104K500CT | Capacitor 0.1uF 50V |
| C20 | 0402B104K500CT | Capacitor 0.1uF 50V |
| C21 | GRM32ER71H226KE15L | Capacitor 22uF 50V |
| C22 | CL21A475KOCNNNE | Capacitor 4.7uF 16V |
| C23 | CL21A475KOCNNNE | Capacitor 4.7uF 16V |
| C24 | 0402B104K500CT | Capacitor 0.1uF 50V |
| C25 | CL21A475KOCNNNE | Capacitor 4.7uF 16V |

## Pin-to-Pin Connections

| Net | From | Pin | To | Pin | Type |
|---|---|---|---|---|---|
| RF_IN_5_18GHZ | J1 | 1 | U1 | 1 | rf |
| RF_PATH_LNA_TO_MIXER1 | U1 | 2 | U2 | 1 | rf |
| RF_PATH_LNA_TO_MIXER2 | U1 | 2 | U3 | 1 | rf |
| LO_OUT_PLL_TO_MIX1 | U4 | RFOUT_A | U2 | 5 | rf |
| LO_OUT_PLL_TO_MIX2 | U4 | RFOUT_B | U3 | 5 | rf |
| I_OUT_M1_P | U2 | 2 | T1 | 1 | analog |
| I_OUT_M1_N | U2 | 3 | T1 | 2 | analog |
| Q_OUT_M1_P | U2 | 4 | T2 | 1 | analog |
| Q_OUT_M1_N | U2 | 6 | T2 | 2 | analog |
| ADC_DCO_P | U5 | DCO+ | U6 | PA8 | clock |
| ADC_DCO_N | U5 | DCO- | U6 | PA9 | clock |
| ADC_FR_P | U5 | FR+ | U6 | PA10 | clock |
| ADC_FR_N | U5 | FR- | U6 | PA11 | clock |
| SPI_SCLK | U6 | PB13 | U4 | SCLK | digital |
| SPI_SCLK | U6 | PB13 | U5 | SCLK | digital |
| SPI_SDIO | U6 | PB15 | U4 | SDIO | digital |
| SPI_SDIO | U6 | PB15 | U5 | SDIO | digital |
| PLL_CS_N | U6 | PB12 | U4 | CS_N | digital |
| ADC_CS_N | U6 | PD7 | U5 | CS_N | digital |
| PLL_CE | U6 | PE0 | U4 | CE | digital |
| 12V_IN | J1 | 2 | U7 | IN | power |
| 12V_REG_OUT | U7 | OUT | U8 | VIN | power |
| 5V_REG_OUT | U8 | VOUT | U9 | VIN | power |
| 5V_REG_OUT | U8 | VOUT | U1 | 3 | power |
| 5V_REG_OUT | U8 | VOUT | U2 | 7 | power |
| 3.3V_REG_OUT | U9 | VOUT | U4 | VCC | power |
| 3.3V_REG_OUT | U9 | VOUT | U5 | VDD | power |
| 3.3V_REG_OUT | U9 | VOUT | U6 | VDD | power |
| 3.3V_REG_OUT | U9 | VOUT | U10 | VDD | power |
| 3.3V_REG_OUT | U9 | VOUT | R6 | 1 | power |
| 3.3V_REG_OUT | U9 | VOUT | R7 | 1 | power |
| GND | U1 | 4 | U1 | GND | ground |
| GND | U2 | 8 | U2 | GND | ground |
| GND | U3 | GND | U3 | 2 | ground |
| GND | U4 | GND | U5 | VSS | ground |
| GND | U5 | VSS | U6 | VSS | ground |
| GND | U6 | VSS | U7 | GND | ground |
| GND | U7 | GND | U8 | GND | ground |
| GND | U8 | GND | U9 | GND | ground |
| GND | U9 | GND | U10 | GND | ground |
| 3.3V_REF_OUT | U10 | RST | U4 | RESET | digital |
| 3.3V_REF_OUT | U10 | RST | U5 | RESET | digital |
| 3.3V_REF_OUT | U10 | RST | U6 | NRST | digital |
| VDD_PLL_FILTER | U4 | VCC_CORE | C7 | 1 | power |
| VDD_PLL_FILTER | U4 | VCC_CORE | C8 | 1 | power |
| VDD_PLL_FILTER | U4 | VCC_CORE | C9 | 1 | power |
| VDD_PLL_FILTER | U4 | VCC_CORE | L3 | 1 | power |
| VDD_PLL_FILTER | U4 | VCC_CORE | C10 | 1 | power |
| VDD_PLL_FILTER | U4 | VCC_CORE | C11 | 1 | power |
| VDD_ADC | U5 | VDD | C12 | 1 | power |
| VDD_ADC | U5 | VDD | C13 | 1 | power |
| VDD_ADC | U5 | VDD | C14 | 1 | power |
| VDD_ADC | U5 | VDD | L4 | 1 | power |
| VDD_MCU | U6 | VDD | C15 | 1 | power |
| VDD_MCU | U6 | VDD | C16 | 1 | power |
| VDD_MCU | U6 | VDD | C17 | 1 | power |
| VDD_5V_REG | U8 | VOUT | C19 | 1 | power |
| VDD_5V_REG | U8 | VOUT | C20 | 1 | power |
| VDD_12V_REG | U7 | OUT | C18 | 1 | power |
| VDD_3.3V_REG | U9 | VOUT | C22 | 1 | power |
| VDD_3.3V_REG | U9 | VOUT | C23 | 1 | power |
| VDD_3.3V_REG | U9 | VOUT | C24 | 1 | power |
| VDD_INPUT | J1 | 2 | C21 | 1 | power |
| VDD_INPUT | J1 | 2 | C25 | 1 | power |

## Net Connection List

| Net Name | Reference Designator - Pin No. |
|----------|-------------------------------|
| 12V_IN | J1 - 2,  U7 - IN |
| 12V_REG_OUT | U7 - OUT,  U8 - VIN |
| 3.3V_REF_OUT | U10 - RST,  U4 - RESET,  U5 - RESET,  U6 - NRST |
| 3.3V_REG_OUT | U9 - VOUT,  U4 - VCC,  U5 - VDD,  U6 - VDD,  U10 - VDD,  R6 - 1,  R7 - 1 |
| 5V_REG_OUT | U8 - VOUT,  U9 - VIN,  U1 - 3,  U2 - 7 |
| ADC_CS_N | U6 - PD7,  U5 - CS_N |
| ADC_DCO_N | U5 - DCO-,  U6 - PA9 |
| ADC_DCO_P | U5 - DCO+,  U6 - PA8 |
| ADC_FR_N | U5 - FR-,  U6 - PA11 |
| ADC_FR_P | U5 - FR+,  U6 - PA10 |
| GND | U1 - 4,  U1 - GND,  U2 - 8,  U2 - GND,  U3 - GND,  U3 - 2,  U4 - GND,  U5 - VSS,  U6 - VSS,  U7 - GND,  U8 - GND,  U9 - GND,  U10 - GND |
| I_OUT_M1_N | U2 - 3,  T1 - 2 |
| I_OUT_M1_P | U2 - 2,  T1 - 1 |
| LO_OUT_PLL_TO_MIX1 | U4 - RFOUT_A,  U2 - 5 |
| LO_OUT_PLL_TO_MIX2 | U4 - RFOUT_B,  U3 - 5 |
| PLL_CE | U6 - PE0,  U4 - CE |
| PLL_CS_N | U6 - PB12,  U4 - CS_N |
| Q_OUT_M1_N | U2 - 6,  T2 - 2 |
| Q_OUT_M1_P | U2 - 4,  T2 - 1 |
| RF_IN_5_18GHZ | J1 - 1,  U1 - 1 |
| RF_PATH_LNA_TO_MIXER1 | U1 - 2,  U2 - 1 |
| RF_PATH_LNA_TO_MIXER2 | U1 - 2,  U3 - 1 |
| SPI_SCLK | U6 - PB13,  U4 - SCLK,  U5 - SCLK |
| SPI_SDIO | U6 - PB15,  U4 - SDIO,  U5 - SDIO |
| VDD_12V_REG | U7 - OUT,  C18 - 1 |
| VDD_3.3V_REG | U9 - VOUT,  C22 - 1,  C23 - 1,  C24 - 1 |
| VDD_5V_REG | U8 - VOUT,  C19 - 1,  C20 - 1 |
| VDD_ADC | U5 - VDD,  C12 - 1,  C13 - 1,  C14 - 1,  L4 - 1 |
| VDD_INPUT | J1 - 2,  C21 - 1,  C25 - 1 |
| VDD_MCU | U6 - VDD,  C15 - 1,  C16 - 1,  C17 - 1 |
| VDD_PLL_FILTER | U4 - VCC_CORE,  C7 - 1,  C8 - 1,  C9 - 1,  L3 - 1,  C10 - 1,  C11 - 1 |

## Validation Notes

- VOLTAGE_LEVEL_MISMATCH: HMC6180LP4E (U1) requires 5V supply - confirmed from U8 buck converter
- VOLTAGE_LEVEL_MISMATCH: HMC519LC4 (U2) requires 5V supply - confirmed from U8 buck converter
- DECOUPLING_WARNING: U4 (LMX2594) requires additional 0.1uF and 4.7uF decoupling capacitors - C7, C8, C9, C10, C11 provided
- DECOUPLING_WARNING: U5 (AD9680) requires 0.1uF and 1.0uF decoupling capacitors - C12, C13, C14 provided
- DECOUPLING_WARNING: U6 (STM32F407) requires multiple 0.1uF decoupling capacitors - C15, C16, C17 provided
- FREQ_RANGE_GAP: U2 (HMC519LC4) covers 5-12 GHz; U3 (MIXIQ-1030) covers 10-30 GHz; 10-12 GHz overlap provides seamless coverage but requires band selection switch
- CLOCK_MISSING: JESD204B ADC requires sysref and frame clock - consider adding clock generator or using LMx2594-derived reference
- RF_PATH_MATCHING: U1 output to mixer inputs requires 50-ohm controlled impedance PCB traces; length matching required for I/Q paths
- LO_DRIVE_LEVEL: HMC519LC4 requires 0 to +5 dBm LO drive; MIXIQ-1030 requires +10 to +15 dBm LO drive - LO buffer amplifier may be needed for U3 path
- POWER_BUDGET: Estimated power consumption: U1=450mW, U2=~500mW, U3=~400mW, U4=~900mW, U5=~1.5W, U6=~500mW, regulators=~1W; total ~5.25W typical within 10-20W budget
- THERMAL_WARNING: AD9680 (U5) dissipates ~1.5W - requires thermal pad and/or heatsink
- RESET_SEQUENCING: MIC9430 (U10) provides reset but may need additional sequencing for power rail dependencies (3.3V before 5V recommended)
- FCC_COMPLIANCE: All selected components are RoHS compliant; shielded enclosures and proper filtering required for FCC Part 15 compliance
- INPUT_PROTECTION_MISSING: RF input J1 requires ESD protection and DC blocking capacitor
- GPIO_PULLUPS: SPI chip select lines require pullup resistors to 3.3V - R1, R2 provided for CS_N lines
- VARIABLE_GAIN: HMC519LC4 has limited gain control; consider adding VGA (e.g., HMC698LP4) in IF path for programmable gain
- FREQ_SYNTH_CALIBRATION: LMX2594 requires external loop filter components - add 0.1uF capacitors and 470 ohm resistor to Loop Filter pins