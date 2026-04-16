# Logical Netlist
## dfbvd

## Block Diagram

```mermaid
graph TB
    U1[HMC1099LP4E (HMC1099LP4E)]
    U2[HMC1022LP4E (HMC1022LP4E)]
    U3[ADF5356 (ADF5356CCPZ)]
    U4[ADC12DJ3200 (ADC12DJ3200AIRGZ)]
    U5[LMK04828B (LMK04828BISKQ)]
    J1[SMA_CONNECTOR (CON-SMA-EDGE)]
    J2[MC-HIGH-DENSITY (ASMB-12B-0-T-T)]
    J3[MC-HIGH-DENSITY (ASMB-12B-0-T-T)]
    L1[RF_CHOKE_100NH (0402CS-101XJL)]
    L2[RF_CHOKE_27NH (0402CS-270XJL)]
    L3[BEAD_600R (BLM18AG601SN1D)]
    L4[BEAD_220R (BLM18BD221SN1)]
    T1[RF_TRANSFORMER_BALUN (TCM1-63X+)]
    T2[RF_TRANSFORMER_BALUN (BAL-0006SMG)]
    R1[RES_10K_0603 (RC0603FR-0710KL)]
    R2[RES_100K_0603 (RC0603FR-07100KL)]
    R3[RES_4K7_0603 (RC0603FR-074K7L)]
    R4[RES_33_1% (CRCW040233R0FKED)]
    R5[RES_33_1% (CRCW040233R0FKED)]
    R6[RES_10K_0603 (RC0603FR-0710KL)]
    R7[RES_2K2_1% (CRCW04022K20FKED)]
    R8[RES_100K_0603 (RC0603FR-07100KL)]
    R9[RES_200_1% (CRCW0402200RFKED)]
    R10[RES_10K_0603 (RC0603FR-071K)]
    C1[CAP_100P_C0G (GRM1555C1H101JA01)]
    C2[CAP_100P_C0G (GRM1555C1H101JA01)]
    C3[CAP_100P_C0G (GRM1555C1H101JA01)]
    C4[CAP_100P_C0G (GRM1555C1H101JA01)]
    C5[CAP_100P_C0G (GRM1555C1H101JA01)]
    C6[CAP_1000P_C0G (GRM1555C1H102JA01)]
    C7[CAP_100P_C0G (GRM1555C1H101JA01)]
    C8[CAP_470P_C0G (GCM1555C1H471JA16)]
    C9[CAP_47P_C0G (GRM1555C1H470JA01)]
    C10[CAP_100N_X7R (CL21B104KBCNNNC)]
    C11[CAP_10P_C0G (GRM1555C1H100JA01)]
    C12[CAP_100P_C0G (GRM1555C1H101JA01)]
    C13[CAP_10UF_TANT (T491A106K016AT)]
    C14[CAP_1UF_X7R (CL21B105KBCNNNC)]
    C15[CAP_100N_X7R (CL21B104KBCNNNC)]
    C16[CAP_100N_X7R (CL21B104KBCNNNC)]
    C17[CAP_100N_X7R (CL21B104KBCNNNC)]
    C18[CAP_100N_X7R (CL21B104KBCNNNC)]
    C19[CAP_1UF_X7R (CL21B105KBCNNNC)]
    C20[CAP_100N_X7R (CL21B104KBCNNNC)]
    C21[CAP_100N_X7R (CL21B104KBCNNNC)]
    C22[CAP_100N_X7R (CL21B104KBCNNNC)]
    C23[CAP_100N_X7R (CL21B104KBCNNNC)]
    C24[CAP_1UF_X7R (CL21B105KBCNNNC)]
    C25[CAP_100N_X7R (CL21B104KBCNNNC)]
    C26[CAP_100N_X7R (CL21B104KBCNNNC)]
    C27[CAP_100N_X7R (CL21B104KBCNNNC)]
    C28[CAP_100P_C0G (GRM1555C1H101JA01)]
    C29[CAP_10P_C0G (GRM1555C1H100JA01)]
    C30[CAP_100N_X7R (CL21B104KBCNNNC)]
    C31[CAP_100N_X7R (CL21B104KBCNNNC)]
    C32[CAP_1UF_X7R (CL21B105KBCNNNC)]
    C33[CAP_100N_X7R (CL21B104KBCNNNC)]
    U6[MGA-615P (MGA-615P)]
    R11[RES_1K_0603 (RC0603FR-071KL)]
    R12[RES_10K_0603 (RC0603FR-0710KL)]
    C34[CAP_100P_C0G (GRM1555C1H101JA01)]
    C35[CAP_100P_C0G (GRM1555C1H101JA01)]
    C36[CAP_100N_X7R (CL21B104KBCNNNC)]
    J1 -->|RF_IN_P| C1
    C1 -->|RF_IN_P| L1
    L1 -->|LNA_IN| C3
    C3 -->|LNA_IN| U1
    U1 -->|LNA_OUT| C4
    C4 -->|RF_TO_MIXER_RF| U2
    U3 -->|LO_DRV| C7
    C7 -->|LO_DRV_C| L2
    L2 -->|MIXER_LO| U2
    U2 -->|IF_P| C5
    C5 -->|IF_P_C| U6
    U6 -->|VGA_OUT| C35
    C35 -->|VGA_OUT_C| T1
    T1 -->|ADC_IN_P| R4
    R4 -->|ADC_IN_P_TERM| U4
    T1 -->|ADC_IN_M| R5
    R5 -->|ADC_IN_M_TERM| U4
    U5 -->|ADC_CLK_P| U4
    U5 -->|ADC_CLK_M| U4
    U5 -->|SYSREF_P| U4
    U5 -->|SYSREF_M| U4
    U4 -->|LVDS_C_P| J2
    U4 -->|LVDS_C_M| J2
    U4 -->|LVDS_D_P| J2
    U4 -->|LVDS_D_M| J2
    U4 -->|LVDS_F_P| J2
    U4 -->|LVDS_F_M| J2
    U4 -->|LVDS_K_P| J2
    U4 -->|LVDS_K_M| J2
    U4 -->|LVDS_N_P| J3
    U4 -->|LVDS_N_M| J3
    U4 -->|LVDS_E_P| J3
    U4 -->|LVDS_E_M| J3
    U4 -->|SPI_CLK| U3
    U4 -->|SPI_MOSI| U3
    U3 -->|SPI_MISO_PLL| U5
    U4 -->|CS_PLL| U3
    U4 -->|CS_CLK| U5
    U4 -->|PDB_CLK| R8
    R8 -->|PDB_CLK_PU| U5
    U4 -->|RESET_ADC| R1
    R1 -->|RESET_PU| DVDD_1V8
    U4 -->|SDIO_ADC| R2
    R2 -->|SDIO_PU| DVDD_1V8
    U4 -->|SCLK_ADC| R3
    R3 -->|SCLK_PU| DVDD_1V8
    R6 -->|CS_PLL_PU| DVDD_1V8
    R6 -->|CS_PLL_R| U3
    U3 -->|MUXOUT| R7
    R7 -->|MUXOUT_TERM| GND
    J1 -->|EXT_CLK_P| C29
    C29 -->|EXT_CLK_P_C| R10
    R10 -->|EXT_CLK_P_PU| U5
    J1 -->|EXT_CLK_M| U5
    U4 -->|VGA_GAIN| R11
    R11 -->|VGA_GAIN_CTRL| U6
    U4 -->|VGA_EN| R12
    R12 -->|VGA_EN_CTRL| DVDD_1V8
    J1 -->|+12V_IN| C32
    C32 -->|+12V_IN| C33
    C33 -->|+12V_RAIL| U1
    U1 -->|+12V_RAIL| U2
    U2 -->|+12V_RAIL| U6
    U1 -->|LNA_VCC| C30
    C30 -->|LNA_GND| GND
    U2 -->|MIXER_VCC| C31
    C31 -->|MIXER_GND| GND
    U3 -->|PLL_AVDD| C28
    C28 -->|PLL_AVDD| +3V3_PLL
    U3 -->|PLL_DVDD| C27
    C27 -->|PLL_DVDD| +3V3_PLL
    C13 -->|+3V3_PLL| C14
    C14 -->|+3V3_PLL| U3
    U4 -->|ADC_AVDD| C19
    C19 -->|ADC_AVDD| C20
    C20 -->|ADC_AVDD| C21
    C21 -->|ADC_AVDD| C22
    C22 -->|ADC_AVDD| AVDD_1V8
    U4 -->|ADC_DVDD| C23
    C23 -->|ADC_DVDD| C24
    C24 -->|ADC_DVDD| DVDD_1V8
    C15 -->|DVDD_1V8| C16
    C16 -->|DVDD_1V8| C17
    C17 -->|DVDD_1V8| C18
    C18 -->|DVDD_1V8| L4
    L4 -->|DVDD_FILT| U4
    U5 -->|CLK_DVDD| C25
    C25 -->|CLK_DVDD| +3V3_PLL
    U5 -->|CLK_VCO| C26
    C26 -->|CLK_VCO| +3V3_PLL
    U6 -->|VGA_VCC| C36
    C36 -->|VGA_GND| GND
    U1 -->|GND| GND
    U2 -->|GND| GND
    U3 -->|GND| GND
    U4 -->|GND| GND
    U5 -->|GND| GND
    U6 -->|GND| GND
    J1 -->|GND| GND
    J2 -->|GND| J3
    J3 -->|GND| J2
    J2 -->|GND| GND
    J3 -->|GND| GND
    T1 -->|GND| GND
    T1 -->|GND| GND
```

## Component Instances

| Ref | Part Number | Component |
|---|---|---|
| U1 | HMC1099LP4E | HMC1099LP4E |
| U2 | HMC1022LP4E | HMC1022LP4E |
| U3 | ADF5356CCPZ | ADF5356 |
| U4 | ADC12DJ3200AIRGZ | ADC12DJ3200 |
| U5 | LMK04828BISKQ | LMK04828B |
| J1 | CON-SMA-EDGE | SMA_CONNECTOR |
| J2 | ASMB-12B-0-T-T | MC-HIGH-DENSITY |
| J3 | ASMB-12B-0-T-T | MC-HIGH-DENSITY |
| L1 | 0402CS-101XJL | RF_CHOKE_100NH |
| L2 | 0402CS-270XJL | RF_CHOKE_27NH |
| L3 | BLM18AG601SN1D | BEAD_600R |
| L4 | BLM18BD221SN1 | BEAD_220R |
| T1 | TCM1-63X+ | RF_TRANSFORMER_BALUN |
| T2 | BAL-0006SMG | RF_TRANSFORMER_BALUN |
| R1 | RC0603FR-0710KL | RES_10K_0603 |
| R2 | RC0603FR-07100KL | RES_100K_0603 |
| R3 | RC0603FR-074K7L | RES_4K7_0603 |
| R4 | CRCW040233R0FKED | RES_33_1% |
| R5 | CRCW040233R0FKED | RES_33_1% |
| R6 | RC0603FR-0710KL | RES_10K_0603 |
| R7 | CRCW04022K20FKED | RES_2K2_1% |
| R8 | RC0603FR-07100KL | RES_100K_0603 |
| R9 | CRCW0402200RFKED | RES_200_1% |
| R10 | RC0603FR-071K | RES_10K_0603 |
| C1 | GRM1555C1H101JA01 | CAP_100P_C0G |
| C2 | GRM1555C1H101JA01 | CAP_100P_C0G |
| C3 | GRM1555C1H101JA01 | CAP_100P_C0G |
| C4 | GRM1555C1H101JA01 | CAP_100P_C0G |
| C5 | GRM1555C1H101JA01 | CAP_100P_C0G |
| C6 | GRM1555C1H102JA01 | CAP_1000P_C0G |
| C7 | GRM1555C1H101JA01 | CAP_100P_C0G |
| C8 | GCM1555C1H471JA16 | CAP_470P_C0G |
| C9 | GRM1555C1H470JA01 | CAP_47P_C0G |
| C10 | CL21B104KBCNNNC | CAP_100N_X7R |
| C11 | GRM1555C1H100JA01 | CAP_10P_C0G |
| C12 | GRM1555C1H101JA01 | CAP_100P_C0G |
| C13 | T491A106K016AT | CAP_10UF_TANT |
| C14 | CL21B105KBCNNNC | CAP_1UF_X7R |
| C15 | CL21B104KBCNNNC | CAP_100N_X7R |
| C16 | CL21B104KBCNNNC | CAP_100N_X7R |
| C17 | CL21B104KBCNNNC | CAP_100N_X7R |
| C18 | CL21B104KBCNNNC | CAP_100N_X7R |
| C19 | CL21B105KBCNNNC | CAP_1UF_X7R |
| C20 | CL21B104KBCNNNC | CAP_100N_X7R |
| C21 | CL21B104KBCNNNC | CAP_100N_X7R |
| C22 | CL21B104KBCNNNC | CAP_100N_X7R |
| C23 | CL21B104KBCNNNC | CAP_100N_X7R |
| C24 | CL21B105KBCNNNC | CAP_1UF_X7R |
| C25 | CL21B104KBCNNNC | CAP_100N_X7R |
| C26 | CL21B104KBCNNNC | CAP_100N_X7R |
| C27 | CL21B104KBCNNNC | CAP_100N_X7R |
| C28 | GRM1555C1H101JA01 | CAP_100P_C0G |
| C29 | GRM1555C1H100JA01 | CAP_10P_C0G |
| C30 | CL21B104KBCNNNC | CAP_100N_X7R |
| C31 | CL21B104KBCNNNC | CAP_100N_X7R |
| C32 | CL21B105KBCNNNC | CAP_1UF_X7R |
| C33 | CL21B104KBCNNNC | CAP_100N_X7R |
| U6 | MGA-615P | MGA-615P |
| R11 | RC0603FR-071KL | RES_1K_0603 |
| R12 | RC0603FR-0710KL | RES_10K_0603 |
| C34 | GRM1555C1H101JA01 | CAP_100P_C0G |
| C35 | GRM1555C1H101JA01 | CAP_100P_C0G |
| C36 | CL21B104KBCNNNC | CAP_100N_X7R |

## Pin-to-Pin Connections

| Net | From | Pin | To | Pin | Type |
|---|---|---|---|---|---|
| RF_IN_P | J1 | SIG | C1 | 1 | RF |
| RF_IN_P | C1 | 2 | L1 | 1 | RF |
| LNA_IN | L1 | 2 | C3 | 1 | RF |
| LNA_IN | C3 | 2 | U1 | 1 | RF |
| LNA_OUT | U1 | 6 | C4 | 1 | RF |
| RF_TO_MIXER_RF | C4 | 2 | U2 | 1 | RF |
| LO_DRV | U3 | 24 | C7 | 1 | RF |
| LO_DRV_C | C7 | 2 | L2 | 1 | RF |
| MIXER_LO | L2 | 2 | U2 | 8 | RF |
| IF_P | U2 | 4 | C5 | 1 | IF |
| IF_P_C | C5 | 2 | U6 | 1 | IF |
| VGA_OUT | U6 | 6 | C35 | 1 | IF |
| VGA_OUT_C | C35 | 2 | T1 | 1 | IF |
| ADC_IN_P | T1 | 4 | R4 | 1 | ANALOG |
| ADC_IN_P_TERM | R4 | 2 | U4 | A11 | ANALOG |
| ADC_IN_M | T1 | 3 | R5 | 1 | ANALOG |
| ADC_IN_M_TERM | R5 | 2 | U4 | B11 | ANALOG |
| ADC_CLK_P | U5 | 45 | U4 | E12 | CLOCK |
| ADC_CLK_M | U5 | 46 | U4 | E13 | CLOCK |
| SYSREF_P | U5 | 47 | U4 | F12 | CLOCK |
| SYSREF_M | U5 | 48 | U4 | F13 | CLOCK |
| LVDS_C_P | U4 | M12 | J2 | 1 | LVDS |
| LVDS_C_M | U4 | M11 | J2 | 2 | LVDS |
| LVDS_D_P | U4 | L12 | J2 | 3 | LVDS |
| LVDS_D_M | U4 | L11 | J2 | 4 | LVDS |
| LVDS_F_P | U4 | K12 | J2 | 5 | LVDS |
| LVDS_F_M | U4 | K11 | J2 | 6 | LVDS |
| LVDS_K_P | U4 | J12 | J2 | 7 | LVDS |
| LVDS_K_M | U4 | J11 | J2 | 8 | LVDS |
| LVDS_N_P | U4 | H12 | J3 | 1 | LVDS |
| LVDS_N_M | U4 | H11 | J3 | 2 | LVDS |
| LVDS_E_P | U4 | G12 | J3 | 3 | LVDS |
| LVDS_E_M | U4 | G11 | J3 | 4 | LVDS |
| SPI_CLK | U4 | M2 | U3 | 13 | DIGITAL |
| SPI_MOSI | U4 | L2 | U3 | 14 | DIGITAL |
| SPI_MISO_PLL | U3 | 15 | U5 | 34 | DIGITAL |
| CS_PLL | U4 | M1 | U3 | 11 | DIGITAL |
| CS_CLK | U4 | L1 | U5 | 32 | DIGITAL |
| PDB_CLK | U4 | K1 | R8 | 1 | DIGITAL |
| PDB_CLK_PU | R8 | 2 | U5 | 30 | DIGITAL |
| RESET_ADC | U4 | N1 | R1 | 2 | DIGITAL |
| RESET_PU | R1 | 1 | DVDD_1V8 | PWR | POWER |
| SDIO_ADC | U4 | N2 | R2 | 2 | DIGITAL |
| SDIO_PU | R2 | 1 | DVDD_1V8 | PWR | POWER |
| SCLK_ADC | U4 | P1 | R3 | 2 | DIGITAL |
| SCLK_PU | R3 | 1 | DVDD_1V8 | PWR | POWER |
| CS_PLL_PU | R6 | 1 | DVDD_1V8 | PWR | POWER |
| CS_PLL_R | R6 | 2 | U3 | 11 | DIGITAL |
| MUXOUT | U3 | 9 | R7 | 1 | DIGITAL |
| MUXOUT_TERM | R7 | 2 | GND | GND | DIGITAL |
| EXT_CLK_P | J1 | CLK_P | C29 | 1 | CLOCK |
| EXT_CLK_P_C | C29 | 2 | R10 | 2 | CLOCK |
| EXT_CLK_P_PU | R10 | 1 | U5 | 50 | CLOCK |
| EXT_CLK_M | J1 | CLK_M | U5 | 51 | CLOCK |
| VGA_GAIN | U4 | J2 | R11 | 2 | DIGITAL |
| VGA_GAIN_CTRL | R11 | 1 | U6 | 8 | DIGITAL |
| VGA_EN | U4 | K2 | R12 | 2 | DIGITAL |
| VGA_EN_CTRL | R12 | 1 | DVDD_1V8 | PWR | POWER |
| +12V_IN | J1 | VCC | C32 | 1 | POWER |
| +12V_IN | C32 | 2 | C33 | 1 | POWER |
| +12V_RAIL | C33 | 2 | U1 | 24 | POWER |
| +12V_RAIL | U1 | 24 | U2 | 24 | POWER |
| +12V_RAIL | U2 | 24 | U6 | 16 | POWER |
| LNA_VCC | U1 | 24 | C30 | 1 | POWER |
| LNA_GND | C30 | 2 | GND | GND | GROUND |
| MIXER_VCC | U2 | 24 | C31 | 1 | POWER |
| MIXER_GND | C31 | 2 | GND | GND | GROUND |
| PLL_AVDD | U3 | 4 | C28 | 1 | POWER |
| PLL_AVDD | C28 | 2 | +3V3_PLL | PWR | POWER |
| PLL_DVDD | U3 | 18 | C27 | 1 | POWER |
| PLL_DVDD | C27 | 2 | +3V3_PLL | PWR | POWER |
| +3V3_PLL | C13 | 1 | C14 | 1 | POWER |
| +3V3_PLL | C14 | 2 | U3 | 4 | POWER |
| ADC_AVDD | U4 | A6 | C19 | 1 | POWER |
| ADC_AVDD | C19 | 2 | C20 | 1 | POWER |
| ADC_AVDD | C20 | 2 | C21 | 1 | POWER |
| ADC_AVDD | C21 | 2 | C22 | 1 | POWER |
| ADC_AVDD | C22 | 2 | AVDD_1V8 | PWR | POWER |
| ADC_DVDD | U4 | K6 | C23 | 1 | POWER |
| ADC_DVDD | C23 | 2 | C24 | 1 | POWER |
| ADC_DVDD | C24 | 2 | DVDD_1V8 | PWR | POWER |
| DVDD_1V8 | C15 | 1 | C16 | 1 | POWER |
| DVDD_1V8 | C16 | 2 | C17 | 1 | POWER |
| DVDD_1V8 | C17 | 2 | C18 | 1 | POWER |
| DVDD_1V8 | C18 | 2 | L4 | 1 | POWER |
| DVDD_FILT | L4 | 2 | U4 | K6 | POWER |
| CLK_DVDD | U5 | 12 | C25 | 1 | POWER |
| CLK_DVDD | C25 | 2 | +3V3_PLL | PWR | POWER |
| CLK_VCO | U5 | 20 | C26 | 1 | POWER |
| CLK_VCO | C26 | 2 | +3V3_PLL | PWR | POWER |
| VGA_VCC | U6 | 16 | C36 | 1 | POWER |
| VGA_GND | C36 | 2 | GND | GND | GROUND |
| GND | U1 | EPAD | GND | GND | GROUND |
| GND | U2 | EPAD | GND | GND | GROUND |
| GND | U3 | EPAD | GND | GND | GROUND |
| GND | U4 | EPAD | GND | GND | GROUND |
| GND | U5 | EPAD | GND | GND | GROUND |
| GND | U6 | EPAD | GND | GND | GROUND |
| GND | J1 | GND | GND | GND | GROUND |
| GND | J2 | 9 | J3 | 9 | GROUND |
| GND | J3 | 9 | J2 | 12 | GROUND |
| GND | J2 | 12 | GND | GND | GROUND |
| GND | J3 | 12 | GND | GND | GROUND |
| GND | T1 | 2 | GND | GND | GROUND |
| GND | T1 | 5 | GND | GND | GROUND |

## Net Connection List

| Net Name | Reference Designator - Pin No. |
|----------|-------------------------------|
| +12V_IN | J1 - VCC,  C32 - 1,  C32 - 2,  C33 - 1 |
| +12V_RAIL | C33 - 2,  U1 - 24,  U2 - 24,  U6 - 16 |
| +3V3_PLL | C13 - 1,  C14 - 1,  C14 - 2,  U3 - 4 |
| ADC_AVDD | U4 - A6,  C19 - 1,  C19 - 2,  C20 - 1,  C20 - 2,  C21 - 1,  C21 - 2,  C22 - 1,  C22 - 2,  AVDD_1V8 - PWR |
| ADC_CLK_M | U5 - 46,  U4 - E13 |
| ADC_CLK_P | U5 - 45,  U4 - E12 |
| ADC_DVDD | U4 - K6,  C23 - 1,  C23 - 2,  C24 - 1,  C24 - 2,  DVDD_1V8 - PWR |
| ADC_IN_M | T1 - 3,  R5 - 1 |
| ADC_IN_M_TERM | R5 - 2,  U4 - B11 |
| ADC_IN_P | T1 - 4,  R4 - 1 |
| ADC_IN_P_TERM | R4 - 2,  U4 - A11 |
| CLK_DVDD | U5 - 12,  C25 - 1,  C25 - 2,  +3V3_PLL - PWR |
| CLK_VCO | U5 - 20,  C26 - 1,  C26 - 2,  +3V3_PLL - PWR |
| CS_CLK | U4 - L1,  U5 - 32 |
| CS_PLL | U4 - M1,  U3 - 11 |
| CS_PLL_PU | R6 - 1,  DVDD_1V8 - PWR |
| CS_PLL_R | R6 - 2,  U3 - 11 |
| DVDD_1V8 | C15 - 1,  C16 - 1,  C16 - 2,  C17 - 1,  C17 - 2,  C18 - 1,  C18 - 2,  L4 - 1 |
| DVDD_FILT | L4 - 2,  U4 - K6 |
| EXT_CLK_M | J1 - CLK_M,  U5 - 51 |
| EXT_CLK_P | J1 - CLK_P,  C29 - 1 |
| EXT_CLK_P_C | C29 - 2,  R10 - 2 |
| EXT_CLK_P_PU | R10 - 1,  U5 - 50 |
| GND | U1 - EPAD,  GND - GND,  U2 - EPAD,  U3 - EPAD,  U4 - EPAD,  U5 - EPAD,  U6 - EPAD,  J1 - GND,  J2 - 9,  J3 - 9,  J2 - 12,  J3 - 12,  T1 - 2,  T1 - 5 |
| IF_P | U2 - 4,  C5 - 1 |
| IF_P_C | C5 - 2,  U6 - 1 |
| LNA_GND | C30 - 2,  GND - GND |
| LNA_IN | L1 - 2,  C3 - 1,  C3 - 2,  U1 - 1 |
| LNA_OUT | U1 - 6,  C4 - 1 |
| LNA_VCC | U1 - 24,  C30 - 1 |
| LO_DRV | U3 - 24,  C7 - 1 |
| LO_DRV_C | C7 - 2,  L2 - 1 |
| LVDS_C_M | U4 - M11,  J2 - 2 |
| LVDS_C_P | U4 - M12,  J2 - 1 |
| LVDS_D_M | U4 - L11,  J2 - 4 |
| LVDS_D_P | U4 - L12,  J2 - 3 |
| LVDS_E_M | U4 - G11,  J3 - 4 |
| LVDS_E_P | U4 - G12,  J3 - 3 |
| LVDS_F_M | U4 - K11,  J2 - 6 |
| LVDS_F_P | U4 - K12,  J2 - 5 |
| LVDS_K_M | U4 - J11,  J2 - 8 |
| LVDS_K_P | U4 - J12,  J2 - 7 |
| LVDS_N_M | U4 - H11,  J3 - 2 |
| LVDS_N_P | U4 - H12,  J3 - 1 |
| MIXER_GND | C31 - 2,  GND - GND |
| MIXER_LO | L2 - 2,  U2 - 8 |
| MIXER_VCC | U2 - 24,  C31 - 1 |
| MUXOUT | U3 - 9,  R7 - 1 |
| MUXOUT_TERM | R7 - 2,  GND - GND |
| PDB_CLK | U4 - K1,  R8 - 1 |
| PDB_CLK_PU | R8 - 2,  U5 - 30 |
| PLL_AVDD | U3 - 4,  C28 - 1,  C28 - 2,  +3V3_PLL - PWR |
| PLL_DVDD | U3 - 18,  C27 - 1,  C27 - 2,  +3V3_PLL - PWR |
| RESET_ADC | U4 - N1,  R1 - 2 |
| RESET_PU | R1 - 1,  DVDD_1V8 - PWR |
| RF_IN_P | J1 - SIG,  C1 - 1,  C1 - 2,  L1 - 1 |
| RF_TO_MIXER_RF | C4 - 2,  U2 - 1 |
| SCLK_ADC | U4 - P1,  R3 - 2 |
| SCLK_PU | R3 - 1,  DVDD_1V8 - PWR |
| SDIO_ADC | U4 - N2,  R2 - 2 |
| SDIO_PU | R2 - 1,  DVDD_1V8 - PWR |
| SPI_CLK | U4 - M2,  U3 - 13 |
| SPI_MISO_PLL | U3 - 15,  U5 - 34 |
| SPI_MOSI | U4 - L2,  U3 - 14 |
| SYSREF_M | U5 - 48,  U4 - F13 |
| SYSREF_P | U5 - 47,  U4 - F12 |
| VGA_EN | U4 - K2,  R12 - 2 |
| VGA_EN_CTRL | R12 - 1,  DVDD_1V8 - PWR |
| VGA_GAIN | U4 - J2,  R11 - 2 |
| VGA_GAIN_CTRL | R11 - 1,  U6 - 8 |
| VGA_GND | C36 - 2,  GND - GND |
| VGA_OUT | U6 - 6,  C35 - 1 |
| VGA_OUT_C | C35 - 2,  T1 - 1 |
| VGA_VCC | U6 - 16,  C36 - 1 |

## Validation Notes

- CRITICAL: LNA operates at 12V but HMC1099LP4E datasheet specifies 5V operation. 12V will damage device. Need 5V regulator or component change.
- CRITICAL: Mixer operates at 12V but HMC1022LP4E datasheet specifies 5V. 12V will damage device. Need 5V regulator or component change.
- CRITICAL: VGA (MGA-615P) operates at 12V but datasheet specifies 5V. 12V will damage device.
- CRITICAL: No 5V power rail defined. Need 5V LDO regulator (e.g., TPS7A47) for RF chain components.
- CRITICAL: No power management ICs included. Need DC-DC converters for 3.3V and 1.8V rails from 12V input.
- WARNING: PLL output 13.6 GHz max may not cover entire 5-18 GHz RF downconversion range. May need x2 multiplier for high-band LO.
- WARNING: HMC1022 mixer LO range 6-18 GHz but PLL max is 13.6 GHz. Top 4.4 GHz of RF band cannot be downconverted.
- WARNING: No ESD protection on RF input (REQ-HW-015). Need limiter diode (e.g., HMC1061LP5E) before LNA.
- WARNING: Balun T1 (TCM1-63X+) frequency range 5-3000 MHz only. For IF up to 8 GHz, need wideband balun (e.g., BAL-0006SMG).
- RECOMMENDATION: Add anti-aliasing filter between VGA and ADC, especially if IF frequency exceeds Nyquist at 500 MSPS.
- RECOMMENDATION: Add 10nH-22nH inductors on ADC AVDD pins for additional supply filtering.
- RECOMMENDATION: Separate analog and digital ground planes with controlled return paths for LVDS signals.
- RECOMMENDATION: Add ferrite beads (BLM18PG series) on ADC clock inputs for EMI suppression.
- NOTE: 20dB LNA gain + 9dB mixer loss + 10dB VGA gain = 21dB total gain. May be insufficient for -100dBm sensitivity. Consider adding VGA after LNA.
- NOTE: Cascaded NF: 3.5dB (LNA) + 0.5dB = ~4dB. Meets 6-10dB requirement with margin.
- NOTE: JESD204B lane rate at 500 MSPS x12 bits = 6 Gbps per lane. Ensure Samtec connectors support this data rate.