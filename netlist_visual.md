# Logical Netlist
## rf9

## Block Diagram

```mermaid
graph TB
    U1[STM32F405VGT6 (STM32F405VGT6)]
    U2[ISO5852S_Isolated_Gate_Driver (ISO5852S)]
    U3[INA282_Current_Sense_Amp_Phase_U (INA282)]
    U4[INA282_Current_Sense_Amp_Phase_V (INA282)]
    U5[INA282_Current_Sense_Amp_Phase_W (INA282)]
    U6[MGJ2D121505SC_Isolated_DCDC (MGJ2D121505SC)]
    U7[AMS1117-3.3_LDO_Regulator (AMS1117-3.3)]
    Q1[IRFS7530_High_Side_Phase_U (IRFS7530TRLPBF)]
    Q2[IRFS7530_Low_Side_Phase_U (IRFS7530TRLPBF)]
    Q3[IRFS7530_High_Side_Phase_V (IRFS7530TRLPBF)]
    Q4[IRFS7530_Low_Side_Phase_V (IRFS7530TRLPBF)]
    Q5[IRFS7530_High_Side_Phase_W (IRFS7530TRLPBF)]
    Q6[IRFS7530_Low_Side_Phase_W (IRFS7530TRLPBF)]
    R1[Shunt_Resistor_250uOhm_Phase_U (WSLF2512L2000FEA)]
    R2[Shunt_Resistor_250uOhm_Phase_V (WSLF2512L2000FEA)]
    R3[Shunt_Resistor_250uOhm_Phase_W (WSLF2512L2000FEA)]
    R4[Bus_Voltage_Divider_Top (CRCW1206100KJNEA)]
    R5[Bus_Voltage_Divider_Bottom (CRCW12063K9JNEA)]
    R6[Throttle_Input_Protection (CRCW120610KJNEA)]
    R7[Throttle_Input_Filter (CRCW120610KJNEA)]
    R8[NTC_Thermistor_Bias (NTCW25103K103T)]
    C1[Decoupling_Cap_10uF_3V3 (CL21A106KQCLRNC)]
    C2[Decoupling_Cap_100nF_3V3 (CL21B104KBCNNNC)]
    C3[Decoupling_Cap_10uF_5V (CL21A106KQCLRNC)]
    C4[Decoupling_Cap_100nF_5V (CL21B104KBCNNNC)]
    C5[Decoupling_Cap_100nF_VDD (CL21B104KBCNNNC)]
    C6[Decoupling_Cap_100nF_Analog (CL21B104KBCNNNC)]
    C7[Bus_Voltage_Filter_Cap (CL21B104KBCNNNC)]
    C8[Throttle_Input_Cap (CL21B104KBCNNNC)]
    C9[Thermistor_Filter_Cap (CL21B104KBCNNNC)]
    J1[3_Phase_Motor_Output (OSTTE060104)]
    J2[Power_Input_Terminal (OSTTE060302)]
    J3[Encoder_Interface_Connector (Molex-503480-0500)]
    J4[UART_Communication_Header (Molex-503480-0400)]
    J5[Throttle_Input_Terminal (OSTTE060202)]
    U1 -->|PWM_UH| U2
    U1 -->|PWM_UL| U2
    U1 -->|PWM_VH| U2
    U1 -->|PWM_VL| U2
    U1 -->|PWM_WH| U2
    U1 -->|PWM_WL| U2
    U2 -->|GATE_UH| Q1
    U2 -->|GATE_UL| Q2
    U2 -->|GATE_VH| Q3
    U2 -->|GATE_VL| Q4
    U2 -->|GATE_WH| Q5
    U2 -->|GATE_WL| Q6
    Q1 -->|PHASE_U_HIGH| J1
    Q2 -->|PHASE_U_LOW| R1
    Q1 -->|PHASE_U_MID| Q2
    Q3 -->|PHASE_V_HIGH| J1
    Q4 -->|PHASE_V_LOW| R2
    Q3 -->|PHASE_V_MID| Q4
    Q5 -->|PHASE_W_HIGH| J1
    Q6 -->|PHASE_W_LOW| R3
    Q5 -->|PHASE_W_MID| Q6
    J2 -->|DC_BUS_48V| Q1
    Q1 -->|DC_BUS_48V| Q3
    Q3 -->|DC_BUS_48V| Q5
    Q5 -->|DC_BUS_48V| R4
    J2 -->|DC_BUS_RETURN| R1
    R1 -->|DC_BUS_RETURN| R2
    R2 -->|DC_BUS_RETURN| R3
    R1 -->|CURRENT_SENSE_U_P| U3
    R1 -->|CURRENT_SENSE_U_M| U3
    U3 -->|CURRENT_SENSE_U_OUT| U1
    R2 -->|CURRENT_SENSE_V_P| U4
    R2 -->|CURRENT_SENSE_V_M| U4
    U4 -->|CURRENT_SENSE_V_OUT| U1
    R3 -->|CURRENT_SENSE_W_P| U5
    R3 -->|CURRENT_SENSE_W_M| U5
    U5 -->|CURRENT_SENSE_W_OUT| U1
    R4 -->|VOLTAGE_SENSE_DIV| R5
    R5 -->|VOLTAGE_SENSE_ADC| U1
    J3 -->|ENCODER_A| U1
    J3 -->|ENCODER_B| U1
    J3 -->|ENCODER_INDEX| U1
    U1 -->|UART_TX| J4
    U1 -->|UART_RX| J4
    J5 -->|THROTTLE_IN| R6
    R6 -->|THROTTLE_FILTERED| R7
    R7 -->|THROTTLE_FILTERED| C8
    R7 -->|THROTTLE_ADC| U1
    R8 -->|THERMISTOR_SENSE| U1
    R8 -->|THERMISTOR_FILTER| C9
    U2 -->|FAULT_n| U1
    U2 -->|READY| U1
    U6 -->|VDD_5V_ISO| U2
    U6 -->|VDD_15V_ISO| U2
    U7 -->|VDD_5V| U1
    U7 -->|VDD_5V| U3
    U3 -->|VDD_5V| U4
    U4 -->|VDD_5V| U5
    U7 -->|VDD_3V3| U1
    U1 -->|VDD_3V3| C1
    C1 -->|VDD_3V3| C2
    U3 -->|AGND| U4
    U4 -->|AGND| U5
    U5 -->|AGND| R5
    R5 -->|AGND| C7
    C7 -->|AGND| C8
    C8 -->|AGND| C9
    C9 -->|AGND| J3
    U1 -->|DGND| C2
    C2 -->|DGND| C4
    C4 -->|DGND| C6
    C6 -->|DGND| J4
    Q2 -->|PGND| Q4
    Q4 -->|PGND| Q6
    Q6 -->|PGND| U2
    U2 -->|ISO_GND| U2
    U2 -->|ISO_GND| U6
```

## Component Instances

| Ref | Part Number | Component |
|---|---|---|
| U1 | STM32F405VGT6 | STM32F405VGT6 |
| U2 | ISO5852S | ISO5852S_Isolated_Gate_Driver |
| U3 | INA282 | INA282_Current_Sense_Amp_Phase_U |
| U4 | INA282 | INA282_Current_Sense_Amp_Phase_V |
| U5 | INA282 | INA282_Current_Sense_Amp_Phase_W |
| U6 | MGJ2D121505SC | MGJ2D121505SC_Isolated_DCDC |
| U7 | AMS1117-3.3 | AMS1117-3.3_LDO_Regulator |
| Q1 | IRFS7530TRLPBF | IRFS7530_High_Side_Phase_U |
| Q2 | IRFS7530TRLPBF | IRFS7530_Low_Side_Phase_U |
| Q3 | IRFS7530TRLPBF | IRFS7530_High_Side_Phase_V |
| Q4 | IRFS7530TRLPBF | IRFS7530_Low_Side_Phase_V |
| Q5 | IRFS7530TRLPBF | IRFS7530_High_Side_Phase_W |
| Q6 | IRFS7530TRLPBF | IRFS7530_Low_Side_Phase_W |
| R1 | WSLF2512L2000FEA | Shunt_Resistor_250uOhm_Phase_U |
| R2 | WSLF2512L2000FEA | Shunt_Resistor_250uOhm_Phase_V |
| R3 | WSLF2512L2000FEA | Shunt_Resistor_250uOhm_Phase_W |
| R4 | CRCW1206100KJNEA | Bus_Voltage_Divider_Top |
| R5 | CRCW12063K9JNEA | Bus_Voltage_Divider_Bottom |
| R6 | CRCW120610KJNEA | Throttle_Input_Protection |
| R7 | CRCW120610KJNEA | Throttle_Input_Filter |
| R8 | NTCW25103K103T | NTC_Thermistor_Bias |
| C1 | CL21A106KQCLRNC | Decoupling_Cap_10uF_3V3 |
| C2 | CL21B104KBCNNNC | Decoupling_Cap_100nF_3V3 |
| C3 | CL21A106KQCLRNC | Decoupling_Cap_10uF_5V |
| C4 | CL21B104KBCNNNC | Decoupling_Cap_100nF_5V |
| C5 | CL21B104KBCNNNC | Decoupling_Cap_100nF_VDD |
| C6 | CL21B104KBCNNNC | Decoupling_Cap_100nF_Analog |
| C7 | CL21B104KBCNNNC | Bus_Voltage_Filter_Cap |
| C8 | CL21B104KBCNNNC | Throttle_Input_Cap |
| C9 | CL21B104KBCNNNC | Thermistor_Filter_Cap |
| J1 | OSTTE060104 | 3_Phase_Motor_Output |
| J2 | OSTTE060302 | Power_Input_Terminal |
| J3 | Molex-503480-0500 | Encoder_Interface_Connector |
| J4 | Molex-503480-0400 | UART_Communication_Header |
| J5 | OSTTE060202 | Throttle_Input_Terminal |

## Connections

| Net | From | Pin | To | Pin | Type |
|---|---|---|---|---|---|
| PWM_UH | U1 | PA8 | U2 | IN_A | digital |
| PWM_UL | U1 | PA7 | U2 | IN_B | digital |
| PWM_VH | U1 | PB14 | U2 | IN_C | digital |
| PWM_VL | U1 | PB15 | U2 | IN_D | digital |
| PWM_WH | U1 | PA9 | U2 | IN_E | digital |
| PWM_WL | U1 | PA10 | U2 | IN_F | digital |
| GATE_UH | U2 | OUT_A | Q1 | GATE | power |
| GATE_UL | U2 | OUT_B | Q2 | GATE | power |
| GATE_VH | U2 | OUT_C | Q3 | GATE | power |
| GATE_VL | U2 | OUT_D | Q4 | GATE | power |
| GATE_WH | U2 | OUT_E | Q5 | GATE | power |
| GATE_WL | U2 | OUT_F | Q6 | GATE | power |
| PHASE_U_HIGH | Q1 | DRAIN | J1 | 1 | power |
| PHASE_U_LOW | Q2 | SOURCE | R1 | 1 | power |
| PHASE_U_MID | Q1 | SOURCE | Q2 | DRAIN | power |
| PHASE_V_HIGH | Q3 | DRAIN | J1 | 2 | power |
| PHASE_V_LOW | Q4 | SOURCE | R2 | 1 | power |
| PHASE_V_MID | Q3 | SOURCE | Q4 | DRAIN | power |
| PHASE_W_HIGH | Q5 | DRAIN | J1 | 3 | power |
| PHASE_W_LOW | Q6 | SOURCE | R3 | 1 | power |
| PHASE_W_MID | Q5 | SOURCE | Q6 | DRAIN | power |
| DC_BUS_48V | J2 | 1 | Q1 | DRAIN | power |
| DC_BUS_48V | Q1 | DRAIN | Q3 | DRAIN | power |
| DC_BUS_48V | Q3 | DRAIN | Q5 | DRAIN | power |
| DC_BUS_48V | Q5 | DRAIN | R4 | 1 | power |
| DC_BUS_RETURN | J2 | 2 | R1 | 2 | power |
| DC_BUS_RETURN | R1 | 2 | R2 | 2 | power |
| DC_BUS_RETURN | R2 | 2 | R3 | 2 | power |
| CURRENT_SENSE_U_P | R1 | 1 | U3 | IN+ | analog |
| CURRENT_SENSE_U_M | R1 | 2 | U3 | IN- | analog |
| CURRENT_SENSE_U_OUT | U3 | OUT | U1 | PC0 | analog |
| CURRENT_SENSE_V_P | R2 | 1 | U4 | IN+ | analog |
| CURRENT_SENSE_V_M | R2 | 2 | U4 | IN- | analog |
| CURRENT_SENSE_V_OUT | U4 | OUT | U1 | PC1 | analog |
| CURRENT_SENSE_W_P | R3 | 1 | U5 | IN+ | analog |
| CURRENT_SENSE_W_M | R3 | 2 | U5 | IN- | analog |
| CURRENT_SENSE_W_OUT | U5 | OUT | U1 | PC2 | analog |
| VOLTAGE_SENSE_DIV | R4 | 2 | R5 | 1 | analog |
| VOLTAGE_SENSE_ADC | R5 | 1 | U1 | PC3 | analog |
| ENCODER_A | J3 | 2 | U1 | PA0 | digital |
| ENCODER_B | J3 | 3 | U1 | PA1 | digital |
| ENCODER_INDEX | J3 | 4 | U1 | PB0 | digital |
| UART_TX | U1 | PA9 | J4 | 1 | digital |
| UART_RX | U1 | PA10 | J4 | 2 | digital |
| THROTTLE_IN | J5 | 1 | R6 | 1 | analog |
| THROTTLE_FILTERED | R6 | 2 | R7 | 1 | analog |
| THROTTLE_FILTERED | R7 | 1 | C8 | 1 | analog |
| THROTTLE_ADC | R7 | 2 | U1 | PA2 | analog |
| THERMISTOR_SENSE | R8 | 2 | U1 | PC4 | analog |
| THERMISTOR_FILTER | R8 | 2 | C9 | 1 | analog |
| FAULT_n | U2 | FLT | U1 | PE5 | digital |
| READY | U2 | RDY | U1 | PE6 | digital |
| VDD_5V_ISO | U6 | VOUT1 | U2 | VDD | power |
| VDD_15V_ISO | U6 | VOUT2 | U2 | VDD2 | power |
| VDD_5V | U7 | VOUT | U1 | VDD | power |
| VDD_5V | U7 | VOUT | U3 | V+ | power |
| VDD_5V | U3 | V+ | U4 | V+ | power |
| VDD_5V | U4 | V+ | U5 | V+ | power |
| VDD_3V3 | U7 | ADJ | U1 | VDDA | power |
| VDD_3V3 | U1 | VDDA | C1 | 1 | power |
| VDD_3V3 | C1 | 1 | C2 | 1 | power |
| AGND | U3 | GND | U4 | GND | ground |
| AGND | U4 | GND | U5 | GND | ground |
| AGND | U5 | GND | R5 | 2 | ground |
| AGND | R5 | 2 | C7 | 2 | ground |
| AGND | C7 | 2 | C8 | 2 | ground |
| AGND | C8 | 2 | C9 | 2 | ground |
| AGND | C9 | 2 | J3 | 5 | ground |
| DGND | U1 | VSS | C2 | 2 | ground |
| DGND | C2 | 2 | C4 | 2 | ground |
| DGND | C4 | 2 | C6 | 2 | ground |
| DGND | C6 | 2 | J4 | 4 | ground |
| PGND | Q2 | SOURCE | Q4 | SOURCE | ground |
| PGND | Q4 | SOURCE | Q6 | SOURCE | ground |
| PGND | Q6 | SOURCE | U2 | GND2 | ground |
| ISO_GND | U2 | GND1 | U2 | GND | ground |
| ISO_GND | U2 | GND | U6 | GND | ground |

## Validation Notes

- WARNING: UART TX/RX pins (PA9/PA10) conflict with PWM_WH/WL signals - requires alternate pin mapping or timer remapping
- WARNING: Missing bootstrap capacitors for high-side gate drive - required for proper bootstrap operation
- WARNING: DC bus voltage divider (100k/3.9k) gives ~1.8V at 48V - within ADC range but verify margin for transients
- ERROR: No overcurrent protection circuit - requires fast comparator and hardware shutdown for fault detection
- WARNING: Missing decoupling capacitors near MOSFET gates - add 100nF ceramics close to each gate
- WARNING: No TVS or transient protection on 48V DC input - required for industrial environment
- WARNING: Throttle input needs clamping diodes for overvoltage protection beyond 5V
- WARNING: Encoder inputs lack RC filtering - may be susceptible to noise in industrial environment
- WARNING: No watchdog timer configuration specified - critical for safety in motor control applications
- WARNING: AGND/DGND separation not maintained properly - use single-point ground at power supply
- INFO: Consider adding precharge circuit for DC bus capacitor charging to limit inrush current
- INFO: Dead time programming range (500ns-2us) requires validation - shoot-through protection critical
- WARNING: Temperature sensing only covers MCU die and heatsink - consider MOSFET junction temperature estimation
- INFO: FOC current reconstruction requires precise synchronization between ADC sampling and PWM
- WARNING: Isolated DC-DC (MGJ2D121505SC) only 1W output - verify gate drive power budget for 10kHz switching
- ERROR: Missing external reset circuit for MCU - recommended for industrial reliability
- WARNING: No EMI filtering on motor phase outputs - consider adding common-mode chokes
- INFO: STM32F405 advanced timers (TIM1/TIM8) recommended for complementary PWM with dead time insertion
- WARNING: Crystal oscillator not specified - required for stable UART and PWM timing
- ERROR: Unconnected encoder index pin (PB0) - verify pull-up requirements and input configuration