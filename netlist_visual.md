# Logical Netlist
## rbhjdaz

## Block Diagram

```mermaid
graph TB
    U1[RF Input Limiter (RFLM5012-10)]
    U2[Wideband LNA (TGA4537-SM)]
    U3[Digital VGA 1 (HMC698LP4)]
    U4[Digital VGA 2 (HMC698LP4)]
    U5[RF Mixer Stage 1 (ADL5802)]
    U6[RF Mixer Stage 2 (HMC1174ST50E)]
    U7[Wideband PLL Synthesizer (ADF5355)]
    U8[LO Distribution Amplifier (HMC361)]
    U9[IF VGA and Filter Amp (TCA6424A)]
    U10[Dual 12-bit 3GSPS ADC (AD9208)]
    U11[Clock Jitter Cleaner (LMK04828)]
    U12[Power Management IC (ADP5054)]
    U13[System MCU (ATMEGA328P-AU)]
    U14[LDO 3.3V (MIC9131)]
    U15[LDO 1.8V (MIC9130)]
    U16[LDO 1.2V (TPS74401)]
    U17[Digital Isolator USB (ISOW7842)]
    U18[EEPROM Config (24AA256)]
    J1[RF Input Connector (SMA-50-J-J)]
    J2[Ref Clock Input (SMA-50-J-J)]
    J3[Control/Programming USB (USB-MICRO-B-TH)]
    J4[Primary Power Input 28V (Molex-087839)]
    J5[JESD204B Data Output (Samtec-SEARAY)]
    L1[RF Input ESD Filter (BLM18PG471SN1)]
    L2[RF Choke (100nH)]
    T1[RF Transformer Balun (TC4-1W+)]
    R1[Input Termination (49.9)]
    R2[I2C Pull-up (10.0k)]
    R3[I2C Pull-up (10.0k)]
    R4[SPI CS Pull-up (1.0k)]
    R5[Reset Pull-up (1.0k)]
    R6[LED Current Limit (10.0k)]
    R7[Status Pull-up (10.0k)]
    C1[RF DC Block (10pF)]
    C2[RF DC Block (100pF)]
    C3[LNA Decoupling (10uF)]
    C4[LNA Bypass (0.1uF)]
    C5[RF DC Block (100pF)]
    C6[RF DC Block (100pF)]
    C7[RF DC Block (100pF)]
    C8[RF DC Block (100pF)]
    C9[ADC Decoupling (10uF)]
    C10[ADC Decoupling (10uF)]
    C11[ADC Bypass (0.1uF)]
    C12[ADC Bypass (0.1uF)]
    C13[Bulk Cap 3.3V (47uF)]
    C14[Bulk Cap 1.8V (47uF)]
    C15[Bulk Cap 1.2V (47uF)]
    LED1[Power Status LED (LTST-C150EKT)]
    LED2[Lock Status LED (LTST-C150AKT)]
    LED3[Fault LED (LTST-C150GKT)]
    SW1[Reset Button (PTS645)]
    SW2[Mode Button (PTS645)]
    X1[MCU Crystal 16MHz (ABM8-16.000MHZ-12-D1Y-T)]
    J1 -->|RF_IN| L1
    L1 -->|RF_IN_FILTERED| R1
    R1 -->|RF_IN_TERM| U1
    U1 -->|RF_LIMITED| C1
    C1 -->|RF_LNA_IN| U2
    U2 -->|RF_LNA_OUT| C2
    C2 -->|RF_VGA1_IN| U3
    U3 -->|RF_VGA1_OUT| C5
    C5 -->|RF_VGA2_IN| U4
    U4 -->|RF_VGA2_OUT| C6
    C6 -->|MIX1_RF_IN| U5
    U8 -->|LO1_PATH| U5
    U5 -->|MIX1_IF_OUT| C7
    C7 -->|MIX2_RF_IN| U6
    U8 -->|LO2_PATH| U6
    U6 -->|MIX2_IF_OUT| C8
    C8 -->|IF_AMP_IN| T1
    T1 -->|IF_DIFF_P| U9
    T1 -->|IF_DIFF_N| U9
    U9 -->|IF_OUT_P| U10
    U9 -->|IF_OUT_N| U10
    U7 -->|VCO_OUT| U8
    J2 -->|CLK_REF_IN| U11
    U11 -->|CLK_REF_PLL| U7
    U11 -->|CLK_ADC| U10
    U11 -->|CLK_ADC_N| U10
    U13 -->|SPI_SCLK| U7
    U13 -->|SPI_MOSI| U7
    U13 -->|SPI_MISO| U7
    U13 -->|VGA1_CS| U3
    U13 -->|VGA2_CS| U4
    U13 -->|ADC_SCLK| U10
    U13 -->|ADC_SDIO| U10
    U13 -->|I2C_SDA| U11
    U13 -->|I2C_SCL| U11
    SW1 -->|MCU_RESET_N| U13
    U17 -->|USB_DP| J3
    U17 -->|USB_DN| J3
    U13 -->|MCU_USB_D+| U17
    U13 -->|MCU_USB_D-| U17
    U13 -->|EEPROM_SDA| U18
    U13 -->|EEPROM_SCL| U18
    U10 -->|JESD_C_P| J5
    U10 -->|JESD_C_N| J5
    U10 -->|JESD_D0_P| J5
    U10 -->|JESD_D0_N| J5
    U10 -->|JESD_D1_P| J5
    U10 -->|JESD_D1_N| J5
    U10 -->|JESD_SYNC_P| J5
    U10 -->|JESD_SYNC_N| J5
    J4 -->|28V_INPUT| U12
    J4 -->|28V_RETURN| U12
    U12 -->|PWR_3V3| U14
    U12 -->|PWR_1V8| U15
    U12 -->|PWR_1V2| U16
    U14 -->|+3V3_MCU| U13
    U14 -->|+3V3_ISOLATED| U17
    U17 -->|+3V3_USB| J3
    U15 -->|+1V8_IO| U10
    U16 -->|+1V2_CORE| U10
    U12 -->|+5V_LDO_OUT| U11
    U12 -->|LNA_VDD| L2
    L2 -->|LNA_VDD_RF| U2
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
    U11 -->|GND| U12
    U12 -->|GND| U13
    U13 -->|GND| U14
    U14 -->|GND| U15
    U15 -->|GND| U16
    U16 -->|GND| U17
    U17 -->|GND| J3
    J3 -->|GND| J4
    J4 -->|GND| C3
    C3 -->|GND| C4
    C4 -->|GND| C9
    C9 -->|GND| C10
    C10 -->|GND| C11
    C11 -->|GND| C12
    C12 -->|GND| C13
    C13 -->|GND| C14
    C14 -->|GND| C15
    C15 -->|GND| R6
    R6 -->|GND| LED1
    U13 -->|LED_STATUS| R6
    U7 -->|LOCK_LED| R7
    R7 -->|LOCK_LED_NET| LED2
    U12 -->|FAULT_LED| LED3
    X1 -->|MCU_XTAL1| U13
    X1 -->|MCU_XTAL2| U13
```

## Component Instances

| Ref | Part Number | Component |
|---|---|---|
| U1 | RFLM5012-10 | RF Input Limiter |
| U2 | TGA4537-SM | Wideband LNA |
| U3 | HMC698LP4 | Digital VGA 1 |
| U4 | HMC698LP4 | Digital VGA 2 |
| U5 | ADL5802 | RF Mixer Stage 1 |
| U6 | HMC1174ST50E | RF Mixer Stage 2 |
| U7 | ADF5355 | Wideband PLL Synthesizer |
| U8 | HMC361 | LO Distribution Amplifier |
| U9 | TCA6424A | IF VGA and Filter Amp |
| U10 | AD9208 | Dual 12-bit 3GSPS ADC |
| U11 | LMK04828 | Clock Jitter Cleaner |
| U12 | ADP5054 | Power Management IC |
| U13 | ATMEGA328P-AU | System MCU |
| U14 | MIC9131 | LDO 3.3V |
| U15 | MIC9130 | LDO 1.8V |
| U16 | TPS74401 | LDO 1.2V |
| U17 | ISOW7842 | Digital Isolator USB |
| U18 | 24AA256 | EEPROM Config |
| J1 | SMA-50-J-J | RF Input Connector |
| J2 | SMA-50-J-J | Ref Clock Input |
| J3 | USB-MICRO-B-TH | Control/Programming USB |
| J4 | Molex-087839 | Primary Power Input 28V |
| J5 | Samtec-SEARAY | JESD204B Data Output |
| L1 | BLM18PG471SN1 | RF Input ESD Filter |
| L2 | 100nH | RF Choke |
| T1 | TC4-1W+ | RF Transformer Balun |
| R1 | 49.9 | Input Termination |
| R2 | 10.0k | I2C Pull-up |
| R3 | 10.0k | I2C Pull-up |
| R4 | 1.0k | SPI CS Pull-up |
| R5 | 1.0k | Reset Pull-up |
| R6 | 10.0k | LED Current Limit |
| R7 | 10.0k | Status Pull-up |
| C1 | 10pF | RF DC Block |
| C2 | 100pF | RF DC Block |
| C3 | 10uF | LNA Decoupling |
| C4 | 0.1uF | LNA Bypass |
| C5 | 100pF | RF DC Block |
| C6 | 100pF | RF DC Block |
| C7 | 100pF | RF DC Block |
| C8 | 100pF | RF DC Block |
| C9 | 10uF | ADC Decoupling |
| C10 | 10uF | ADC Decoupling |
| C11 | 0.1uF | ADC Bypass |
| C12 | 0.1uF | ADC Bypass |
| C13 | 47uF | Bulk Cap 3.3V |
| C14 | 47uF | Bulk Cap 1.8V |
| C15 | 47uF | Bulk Cap 1.2V |
| LED1 | LTST-C150EKT | Power Status LED |
| LED2 | LTST-C150AKT | Lock Status LED |
| LED3 | LTST-C150GKT | Fault LED |
| SW1 | PTS645 | Reset Button |
| SW2 | PTS645 | Mode Button |
| X1 | ABM8-16.000MHZ-12-D1Y-T | MCU Crystal 16MHz |

## Pin-to-Pin Connections

| Net | From | Pin | To | Pin | Type |
|---|---|---|---|---|---|
| RF_IN | J1 | SIG | L1 | 1 | RF |
| RF_IN_FILTERED | L1 | 2 | R1 | 1 | RF |
| RF_IN_TERM | R1 | 2 | U1 | RF_IN | RF |
| RF_LIMITED | U1 | RF_OUT | C1 | 1 | RF |
| RF_LNA_IN | C1 | 2 | U2 | RF_IN | RF |
| RF_LNA_OUT | U2 | RF_OUT | C2 | 1 | RF |
| RF_VGA1_IN | C2 | 2 | U3 | RF_IN | RF |
| RF_VGA1_OUT | U3 | RF_OUT | C5 | 1 | RF |
| RF_VGA2_IN | C5 | 2 | U4 | RF_IN | RF |
| RF_VGA2_OUT | U4 | RF_OUT | C6 | 1 | RF |
| MIX1_RF_IN | C6 | 2 | U5 | RF_IN | RF |
| LO1_PATH | U8 | OUT1 | U5 | LO_IN | RF |
| MIX1_IF_OUT | U5 | IF_OUT | C7 | 1 | IF |
| MIX2_RF_IN | C7 | 2 | U6 | RF_IN | IF |
| LO2_PATH | U8 | OUT2 | U6 | LO_IN | RF |
| MIX2_IF_OUT | U6 | IF_OUT | C8 | 1 | IF |
| IF_AMP_IN | C8 | 2 | T1 | PRI | IF |
| IF_DIFF_P | T1 | SEC+ | U9 | IN_P | analog |
| IF_DIFF_N | T1 | SEC- | U9 | IN_N | analog |
| IF_OUT_P | U9 | OUT_P | U10 | VIN_A_P | analog |
| IF_OUT_N | U9 | OUT_N | U10 | VIN_A_N | analog |
| VCO_OUT | U7 | RF_OUT | U8 | IN | RF |
| CLK_REF_IN | J2 | SIG | U11 | CLK_IN0 | clock |
| CLK_REF_PLL | U11 | CLK_OUT0 | U7 | REF_IN | clock |
| CLK_ADC | U11 | CLK_OUT1 | U10 | CLK_P | clock |
| CLK_ADC_N | U11 | CLK_OUT1_N | U10 | CLK_N | clock |
| SPI_SCLK | U13 | PB5 | U7 | SCLK | digital |
| SPI_MOSI | U13 | PB3 | U7 | MOSI | digital |
| SPI_MISO | U13 | PB4 | U7 | MISO | digital |
| VGA1_CS | U13 | PD4 | U3 | CS | digital |
| VGA2_CS | U13 | PD5 | U4 | CS | digital |
| ADC_SCLK | U13 | PB5 | U10 | SCLK | digital |
| ADC_SDIO | U13 | PB3 | U10 | SDIO | digital |
| I2C_SDA | U13 | PC4 | U11 | SDA | digital |
| I2C_SCL | U13 | PC5 | U11 | SCL | digital |
| MCU_RESET_N | SW1 | 1 | U13 | RESET_N | digital |
| USB_DP | U17 | USB_DP | J3 | D+ | digital |
| USB_DN | U17 | USB_DN | J3 | D- | digital |
| MCU_USB_D+ | U13 | PD0 | U17 | D+ | digital |
| MCU_USB_D- | U13 | PD1 | U17 | D- | digital |
| EEPROM_SDA | U13 | PC4 | U18 | SDA | digital |
| EEPROM_SCL | U13 | PC5 | U18 | SCL | digital |
| JESD_C_P | U10 | C_P | J5 | C0_P | digital |
| JESD_C_N | U10 | C_N | J5 | C0_N | digital |
| JESD_D0_P | U10 | D0_P | J5 | D0_P | digital |
| JESD_D0_N | U10 | D0_N | J5 | D0_N | digital |
| JESD_D1_P | U10 | D1_P | J5 | D1_P | digital |
| JESD_D1_N | U10 | D1_N | J5 | D1_N | digital |
| JESD_SYNC_P | U10 | SYNC_P | J5 | SYNC_P | digital |
| JESD_SYNC_N | U10 | SYNC_N | J5 | SYNC_N | digital |
| 28V_INPUT | J4 | VCC | U12 | VIN | power |
| 28V_RETURN | J4 | GND | U12 | GND | ground |
| PWR_3V3 | U12 | OUT1 | U14 | IN | power |
| PWR_1V8 | U12 | OUT2 | U15 | IN | power |
| PWR_1V2 | U12 | OUT3 | U16 | IN | power |
| +3V3_MCU | U14 | OUT | U13 | VCC | power |
| +3V3_ISOLATED | U14 | OUT | U17 | VCC1 | power |
| +3V3_USB | U17 | VCC2 | J3 | VBUS | power |
| +1V8_IO | U15 | OUT | U10 | VDD_1V8 | power |
| +1V2_CORE | U16 | OUT | U10 | VDD_1V2 | power |
| +5V_LDO_OUT | U12 | OUT4 | U11 | VCC | power |
| LNA_VDD | U12 | OUT4 | L2 | 1 | power |
| LNA_VDD_RF | L2 | 2 | U2 | VDD | power |
| GND | U1 | GND | U2 | GND | ground |
| GND | U2 | GND | U3 | GND | ground |
| GND | U3 | GND | U4 | GND | ground |
| GND | U4 | GND | U5 | GND | ground |
| GND | U5 | GND | U6 | GND | ground |
| GND | U6 | GND | U7 | GND | ground |
| GND | U7 | GND | U8 | GND | ground |
| GND | U8 | GND | U9 | GND | ground |
| GND | U9 | GND | U10 | GND | ground |
| GND | U10 | GND | U11 | GND | ground |
| GND | U11 | GND | U12 | GND | ground |
| GND | U12 | GND | U13 | GND | ground |
| GND | U13 | GND | U14 | GND | ground |
| GND | U14 | GND | U15 | GND | ground |
| GND | U15 | GND | U16 | GND | ground |
| GND | U16 | GND | U17 | GND1 | ground |
| GND | U17 | GND2 | J3 | GND | ground |
| GND | J3 | GND | J4 | GND | ground |
| GND | J4 | GND | C3 | 2 | ground |
| GND | C3 | 2 | C4 | 2 | ground |
| GND | C4 | 2 | C9 | 2 | ground |
| GND | C9 | 2 | C10 | 2 | ground |
| GND | C10 | 2 | C11 | 2 | ground |
| GND | C11 | 2 | C12 | 2 | ground |
| GND | C12 | 2 | C13 | 2 | ground |
| GND | C13 | 2 | C14 | 2 | ground |
| GND | C14 | 2 | C15 | 2 | ground |
| GND | C15 | 2 | R6 | 2 | ground |
| GND | R6 | 2 | LED1 | CATHODE | ground |
| LED_STATUS | U13 | PD6 | R6 | 1 | digital |
| LOCK_LED | U7 | MUXOUT | R7 | 1 | digital |
| LOCK_LED_NET | R7 | 2 | LED2 | ANODE | digital |
| FAULT_LED | U12 | FAULT | LED3 | ANODE | digital |
| MCU_XTAL1 | X1 | 1 | U13 | XTAL1 | clock |
| MCU_XTAL2 | X1 | 2 | U13 | XTAL2 | clock |

## Net Connection List

| Net Name | Reference Designator - Pin No. |
|----------|-------------------------------|
| +1V2_CORE | U16 - OUT,  U10 - VDD_1V2 |
| +1V8_IO | U15 - OUT,  U10 - VDD_1V8 |
| +3V3_ISOLATED | U14 - OUT,  U17 - VCC1 |
| +3V3_MCU | U14 - OUT,  U13 - VCC |
| +3V3_USB | U17 - VCC2,  J3 - VBUS |
| +5V_LDO_OUT | U12 - OUT4,  U11 - VCC |
| 28V_INPUT | J4 - VCC,  U12 - VIN |
| 28V_RETURN | J4 - GND,  U12 - GND |
| ADC_SCLK | U13 - PB5,  U10 - SCLK |
| ADC_SDIO | U13 - PB3,  U10 - SDIO |
| CLK_ADC | U11 - CLK_OUT1,  U10 - CLK_P |
| CLK_ADC_N | U11 - CLK_OUT1_N,  U10 - CLK_N |
| CLK_REF_IN | J2 - SIG,  U11 - CLK_IN0 |
| CLK_REF_PLL | U11 - CLK_OUT0,  U7 - REF_IN |
| EEPROM_SCL | U13 - PC5,  U18 - SCL |
| EEPROM_SDA | U13 - PC4,  U18 - SDA |
| FAULT_LED | U12 - FAULT,  LED3 - ANODE |
| GND | U1 - GND,  U2 - GND,  U3 - GND,  U4 - GND,  U5 - GND,  U6 - GND,  U7 - GND,  U8 - GND,  U9 - GND,  U10 - GND,  U11 - GND,  U12 - GND,  U13 - GND,  U14 - GND,  U15 - GND,  U16 - GND,  U17 - GND1,  U17 - GND2,  J3 - GND,  J4 - GND,  C3 - 2,  C4 - 2,  C9 - 2,  C10 - 2,  C11 - 2,  C12 - 2,  C13 - 2,  C14 - 2,  C15 - 2,  R6 - 2,  LED1 - CATHODE |
| I2C_SCL | U13 - PC5,  U11 - SCL |
| I2C_SDA | U13 - PC4,  U11 - SDA |
| IF_AMP_IN | C8 - 2,  T1 - PRI |
| IF_DIFF_N | T1 - SEC-,  U9 - IN_N |
| IF_DIFF_P | T1 - SEC+,  U9 - IN_P |
| IF_OUT_N | U9 - OUT_N,  U10 - VIN_A_N |
| IF_OUT_P | U9 - OUT_P,  U10 - VIN_A_P |
| JESD_C_N | U10 - C_N,  J5 - C0_N |
| JESD_C_P | U10 - C_P,  J5 - C0_P |
| JESD_D0_N | U10 - D0_N,  J5 - D0_N |
| JESD_D0_P | U10 - D0_P,  J5 - D0_P |
| JESD_D1_N | U10 - D1_N,  J5 - D1_N |
| JESD_D1_P | U10 - D1_P,  J5 - D1_P |
| JESD_SYNC_N | U10 - SYNC_N,  J5 - SYNC_N |
| JESD_SYNC_P | U10 - SYNC_P,  J5 - SYNC_P |
| LED_STATUS | U13 - PD6,  R6 - 1 |
| LNA_VDD | U12 - OUT4,  L2 - 1 |
| LNA_VDD_RF | L2 - 2,  U2 - VDD |
| LO1_PATH | U8 - OUT1,  U5 - LO_IN |
| LO2_PATH | U8 - OUT2,  U6 - LO_IN |
| LOCK_LED | U7 - MUXOUT,  R7 - 1 |
| LOCK_LED_NET | R7 - 2,  LED2 - ANODE |
| MCU_RESET_N | SW1 - 1,  U13 - RESET_N |
| MCU_USB_D+ | U13 - PD0,  U17 - D+ |
| MCU_USB_D- | U13 - PD1,  U17 - D- |
| MCU_XTAL1 | X1 - 1,  U13 - XTAL1 |
| MCU_XTAL2 | X1 - 2,  U13 - XTAL2 |
| MIX1_IF_OUT | U5 - IF_OUT,  C7 - 1 |
| MIX1_RF_IN | C6 - 2,  U5 - RF_IN |
| MIX2_IF_OUT | U6 - IF_OUT,  C8 - 1 |
| MIX2_RF_IN | C7 - 2,  U6 - RF_IN |
| PWR_1V2 | U12 - OUT3,  U16 - IN |
| PWR_1V8 | U12 - OUT2,  U15 - IN |
| PWR_3V3 | U12 - OUT1,  U14 - IN |
| RF_IN | J1 - SIG,  L1 - 1 |
| RF_IN_FILTERED | L1 - 2,  R1 - 1 |
| RF_IN_TERM | R1 - 2,  U1 - RF_IN |
| RF_LIMITED | U1 - RF_OUT,  C1 - 1 |
| RF_LNA_IN | C1 - 2,  U2 - RF_IN |
| RF_LNA_OUT | U2 - RF_OUT,  C2 - 1 |
| RF_VGA1_IN | C2 - 2,  U3 - RF_IN |
| RF_VGA1_OUT | U3 - RF_OUT,  C5 - 1 |
| RF_VGA2_IN | C5 - 2,  U4 - RF_IN |
| RF_VGA2_OUT | U4 - RF_OUT,  C6 - 1 |
| SPI_MISO | U13 - PB4,  U7 - MISO |
| SPI_MOSI | U13 - PB3,  U7 - MOSI |
| SPI_SCLK | U13 - PB5,  U7 - SCLK |
| USB_DN | U17 - USB_DN,  J3 - D- |
| USB_DP | U17 - USB_DP,  J3 - D+ |
| VCO_OUT | U7 - RF_OUT,  U8 - IN |
| VGA1_CS | U13 - PD4,  U3 - CS |
| VGA2_CS | U13 - PD5,  U4 - CS |

## Validation Notes

- CRITICAL: RFLM5012-10 limiter frequency range (DC-6 GHz) does not meet requirement REQ-HW-001 (5-18 GHz). Recommendation: Replace with RFLM5012-18 variant or cascade limiters.
- CRITICAL: HMC698LP4 VGA frequency range (DC-14 GHz) does not meet full band coverage. Upper frequency (14-18 GHz) will have limited/no gain control. Recommendation: Use HMC794APZ5E (2-18 GHz) for VGA2.
- CRITICAL: ADL5802 mixer RF/LO range (10 MHz - 6 GHz) does not cover 5-18 GHz input. Cannot directly mix RF >6 GHz. Must use HMC1174ST50E (10-20 GHz) as first mixer or revise architecture.
- CRITICAL: LNA decoupling insufficient for high-frequency operation. C4 (0.1uF) has poor ESL at 18 GHz. Add 1-10 pF ceramic capacitors adjacent to drain pins.
- WARNING: No input DC blocking capacitor shown before limiter U1. RF source may inject DC and damage limiter. Add series DC block (100 pF) at J1 output.
- WARNING: No band-selectable filters shown between VGA stages. Image rejection >60 dB (REQ-HW-009) will be difficult without pre-Mixer bandpass filtering.
- WARNING: Gain control chain cascaded (31 dB + 31 dB = 62 dB) but only documented two VGAs. Consider adding third VGA stage or verify 62 dB meets 60 dB requirement (REQ-HW-006).
- WARNING: LO distribution (U8) drives both mixers but no isolation shown. LO-to-LO feedthrough could cause spurs. Add LO attenuators or power splitter with isolation.
- INFO: TCA6424A is a GPIO expander, not an IF VGA. Verify correct part. Recommend replace with TRF37A75 or LMH6521 for IF VGA.
- INFO: JESD204B lanes shown but ADC lane rate at 3 GSPS x 12 bits = 36 Gbps per lane. Verify FPGA can support. May need lane bonding.
- INFO: No VCO/PLL loop filter components shown. Add passive loop filter network (R, C values) for ADF5355.
- INFO: No ADC input termination shown. AD9208 requires 200-ohm differential termination to VCM.
- INFO: ESD protection (L1) on RF input is good for military spec. Ferrite bead BLM18PG471SN1 rated for 6 GHz - verify S21 at 18 GHz.
- INFO: Power sequencing not shown. AD9208 requires 1.2V core before 1.8V IO. Add sequencing control or verify PMIC U12 supports.
- INFO: Thermal management not addressed. TGA4537-SM GaN LNA dissipates ~2W. Requires thermal vias to ground plane or heatsink for -40 to +85C operation.
- INFO: No test points shown for BIST (REQ-HW-024). Add RF coupling after limiter and after LNA for power monitoring.
- INFO: SPI CS pins shown but three SPI devices (U7, U3, U4) share bus. Verify no address conflicts or add separate CS lines from MCU.
- INFO: Crystal X1 (16MHz) for MCU shown but load capacitors missing. Add 18-22pF load caps to ground on each crystal pin.