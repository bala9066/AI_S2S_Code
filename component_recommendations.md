# Component Recommendations
## rf9

### 1. Motor Control MCU with FOC and PWM

**Primary Choice:** STM32F405VGT6 (STMicroelectronics)

*ARM Cortex-M4, 168MHz, 1MB Flash, 192KB RAM, advanced timers for motor control, 12-bit ADC, 3x FOC engines, quadrature encoder interface, -40 to 85°C*

| Spec | Value |
|---|---|
| Cores | 1x Cortex-M4 @ 168MHz |
| Flash | 1024 KB |
| RAM | 192 KB |
| Timers | Advanced motor control timers (TIM1, TIM8) |
| ADC | 3x 12-bit ADCs, 2.4 MSPS |
| QEI | 2x quadrature encoder interfaces |
| Operating Temp | -40°C to +85°C |
| Package | LQFP-100 |

**Alternatives:**
- **TMS320F280049C** (Texas Instruments): Dedicated DSP for motor control, excellent math performance, smaller ecosystem
- **TM4C1294NCPDT** (Texas Instruments): Cortex-M4F, higher clock speed, more peripherals but larger package

**Selection Rationale:** STM32F4 series is widely used in industrial motor control with mature ecosystem, hardware FOC support, and excellent toolchain. 168MHz provides ample margin for 10kHz FOC loop.

### 2. 3-Phase Inverter MOSFETs (48V, 208A continuous)

**Primary Choice:** IRFS7530TRLPBF (Infineon)

*100V N-channel MOSFET, 300A pulsed, 2.0mOhm Rds(on), DirectFET package for superior thermal performance, automotive qualified*

| Spec | Value |
|---|---|
| Vds | 100V |
| Id | 300A pulsed |
| Rds(on) | 2.0 mOhm @ 10V |
| Qg | 195 nC |
| Package | DirectFET can |
| Operating Temp | -55°C to +175°C junction |
| Qualification | Automotive (AEC-Q101) |

**Alternatives:**
- **BSC072N10NS3G** (Infineon): 100V, 2.8mOhm, SuperSO8 package, easier assembly but higher thermal resistance
- **CSD18540Q5B** (Texas Instruments): 60V, 0.8mOhm, excellent Rds(on) but only 60V rating limits transient margin

**Selection Rationale:** 100V rating provides headroom for 48V bus transients. Ultra-low Rds(on) minimizes conduction losses at 208A. DirectFET package offers best-in-class thermal performance for industrial applications.

### 3. Isolated Gate Driver (3-phase bridge, 6 channels)

**Primary Choice:** ISO5852S (Texas Instruments)

*5.7kVRMS reinforced isolated gate driver, 5A peak source/sink, 4A output, programmable dead time, UVLO, fault reporting, 100ns propagation delay*

| Spec | Value |
|---|---|
| Isolation | 5.7kVRMS reinforced |
| Peak Current | 5A source, 5A sink |
| Supply Voltage | 15V to 30V |
| Propagation Delay | 100ns max |
| UVLO Threshold | Configurable |
| Package | SOIC-16 |
| Operating Temp | -40°C to +125°C |

**Alternatives:**
- **ADuM4223** (Analog Devices): 5kVRMS, 4A peak, dual driver in one package (need 3x)
- **SI8235BB-IS1** (Skyworks): 5kVRMS, 4A peak, dual driver with spread spectrum EMI reduction

**Selection Rationale:** Single 6-channel driver simplifies design, reinforced isolation exceeds industrial safety requirements, programmable dead time and fault reporting integrate well with FOC control loop.

### 4. 3-Shunt Current Sense Amplifier (bidirectional)

**Primary Choice:** INA282 (Texas Instruments)

*Bidirectional current shunt monitor, -14V to +80V common mode, 3.2V/V gain, analog output, -40 to +125°C*

| Spec | Value |
|---|---|
| Common Mode Voltage | -14V to +80V |
| Gain | 3.2 V/V |
| Bandwidth | 50 kHz |
| Offset | 50uV max |
| Package | SOIC-8 |
| Operating Temp | -40°C to +125°C |

**Alternatives:**
- **INA240** (Texas Instruments): 80V, 20 V/V gain, wider bandwidth but higher gain may not suit ADC range
- **ACS724LLCTR-20AB** (Allegro): Hall-effect sensor eliminates shunt but lower bandwidth (80kHz) and less accurate at low currents

**Selection Rationale:** Wide common mode range handles motor phase swings, bidirectional measurement required for FOC, proven industrial part with good offset and drift performance. Three channels needed (one per phase).

### 5. Isolated DC-DC Converter (Gate drive supply)

**Primary Choice:** MGJ2D121505SC (Murata)

*Dual output isolated DC-DC converter, 12V and 15V outputs, 1W, 5.2kVRMS isolation, SIP package*

| Spec | Value |
|---|---|
| Input Voltage | 12V nominal |
| Output 1 | 12V @ 42mA |
| Output 2 | 15V @ 42mA |
| Isolation | 5.2kVRMS |
| Package | SIP-7 |
| Operating Temp | -40°C to +85°C |

**Alternatives:**
- **B0505S-1W** (Murata): Single 5V output, would need additional LDOs to generate 15V
- **ADuM5000** (Analog Devices): Isolated power with data, lower output current (500mW)

**Selection Rationale:** Dual 12V/15V outputs match MOSFET gate drive requirements (12V for low-side, 15V for high-side bootstrap). Reinforced isolation matches gate driver isolation rating.

### 6. DC Bus Voltage Sensing (Isolated)

**Primary Choice:** ACPL-C87A (Broadcom/Avago)

*Isolated voltage sensor, 100kV/us transient immunity, 0-5V output, 15V input supply, DIP-8 package*

| Spec | Value |
|---|---|
| Input Range | 0-5V from divider |
| Isolation | 5kVRMS |
| Linearity | 0.5% max |
| Bandwidth | 100 kHz |
| Package | DIP-8 or SO-8 |
| Operating Temp | -40°C to +85°C |

**Alternatives:**
- **HCPL-7840** (Broadcom): Isolated sigma-delta modulator, higher accuracy (14-bit) but requires MCU digital filter interface
- **AMC1200** (Texas Instruments): Isolated amplifier, 2560Vrms isolation, lower cost than optocoupler solution

**Selection Rationale:** Simple analog isolation for bus voltage monitoring, fast enough for overvoltage protection loop, proven industrial part with good transient immunity.

### 7. Temperature Sensor (Heatsink/MOSFET monitoring)

**Primary Choice:** NTCLE100E3103GB0 (Vishay)

*NTC thermistor, 10K at 25°C, Beta 3950, radial leads, -55 to +125°C range*

| Spec | Value |
|---|---|
| Resistance | 10k at 25°C |
| Beta Value | 3950K |
| Operating Temp | -55°C to +125°C |
| Dissipation Constant | 3mW/°C |
| Package | Radial lead |

**Alternatives:**
- **TMP235A2DCKR** (Texas Instruments): Analog output temperature sensor IC, +/-2°C accuracy, linear output simplifies firmware
- **MAX6627** (Maxim Integrated): Digital sensor with SPI interface, remote diode monitoring, more expensive

**Selection Rationale:** NTC thermistors are simple, reliable, and cost-effective for heatsink monitoring. Widely used in industrial motor controllers with proven performance.

### 8. Current Shunt Resistors (3x low-side sensing)

**Primary Choice:** WSLP2726L5000FEA (Vishay Dale)

*Metal element current shunt, 0.0005 ohms (500uOhm), 1%, 5W, surface mount, low inductance*

| Spec | Value |
|---|---|
| Resistance | 0.0005 ohms |
| Tolerance | 1% |
| Power Rating | 5W |
| TCR | 75 ppm/C |
| Package | 2726 case |
| Operating Temp | -65°C to +170°C |

**Alternatives:**
- **BVS-R001** (Isabellenhuette): Four-terminal shunt, 0.001 ohm, 8W, higher power rating but more expensive
- **WSL2512R0010FEA** (Vishay): Larger package (2512) for better thermal performance, 0.001 ohm resistance

**Selection Rationale:** 500uOhm provides good signal level (104mV at 208A) while keeping power dissipation manageable (21.6W per shunt at full current requires proper heatsinking).
