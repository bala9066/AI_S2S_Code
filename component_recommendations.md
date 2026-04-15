# Component Recommendations
## ajsfdvhjs

### 1. Wideband RF Mixer for downconversion

**Primary Choice:** [HMC1048LP4BE](https://www.analog.com/media/en/technical-documentation/data-sheets/hmc1048.pdf) (Analog Devices)

*Double balanced mixer covering 5-20 GHz RF/LO range with excellent IP3 and conversion loss. GaAs Schottky diode mixer.*

[📄 Datasheet](https://www.analog.com/media/en/technical-documentation/data-sheets/hmc1048.pdf)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/hmc1048lp4be/4929667)

| Spec | Value |
|---|---|
| rf_frequency | 5-20 GHz |
| lo_frequency | 5-20 GHz |
| if_frequency | DC-6 GHz |
| conversion_loss | 7.5 dB typ |
| ip3 | 23 dBm typ |
| lo_drive | +13 to +17 dBm |

**Alternatives:**
- **[MAMX-011037-DIE](https://www.macom.com/products/MAMX-011037)** (MACOM): Similar performance, die format

**Selection Rationale:** Excellent wideband performance with low conversion loss and high linearity across 5-18 GHz range.

### 2. Wideband LNA - Initial gain stage

**Primary Choice:** [TGA4943-SL](https://www.qorvo.com/products/d/da001977) (Qorvo)

*GaN MMIC power amplifier usable as driver amplifier. 2-20 GHz bandwidth with high P1dB.*

[📄 Datasheet](https://www.qorvo.com/products/d/da001977)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/qorvo/TGA4943-SL/6138850)

| Spec | Value |
|---|---|
| frequency | 2-20 GHz |
| gain | 20 dB typ |
| p1db | 33 dBm |
| psat | 36 dBm |
| noise_figure | 3 dB typ |

**Alternatives:**
- **[HMC1119LP4ME](https://www.analog.com/media/en/technical-documentation/data-sheets/hmc1119.pdf)** (Analog Devices): GaAs pHEMT, lower power, similar gain

**Selection Rationale:** High gain and P1dB suitable as initial gain stage meeting dynamic range requirements.

### 3. Wideband Integrated Receiver (Mixer + IF Amp + IQ Demod)

**Primary Choice:** [HMC1119LP4ME](https://www.analog.com/media/en/technical-documentation/data-sheets/hmc1119.pdf) (Analog Devices)

*Wideband receiver with mixer, IF amplifier, and IQ demodulator integrated. Covers 5-18 GHz.*

[📄 Datasheet](https://www.analog.com/media/en/technical-documentation/data-sheets/hmc1119.pdf)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/HMC1119LP4ME/4992432)

| Spec | Value |
|---|---|
| rf_frequency | 5-18 GHz |
| conversion_gain | 8 dB |
| noise_figure | 9 dB |
| oip3 | 19 dBm |
| iq_imbalance | 1.5 deg |

**Alternatives:**
- **[TRF37B75](https://www.ti.com/lit/ds/symlink/trf37b75.pdf)** (Texas Instruments): Integrated wideband receiver with built-in ADC interface

**Selection Rationale:** Integrated solution reduces component count while meeting noise figure and bandwidth requirements.

### 4. Wideband Frequency Synthesizer (LO Generation)

**Primary Choice:** [ADF5356](https://www.analog.com/media/en/technical-documentation/data-sheets/ADF5356.pdf) (Analog Devices)

*Microwave wideband synthesizer with integrated VCO covering 53.125 MHz to 13.6 GHz, divisible to cover required range.*

[📄 Datasheet](https://www.analog.com/media/en/technical-documentation/data-sheets/ADF5356.pdf)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/ADF5356CCPZ/5832905)

| Spec | Value |
|---|---|
| frequency | 53.125 MHz - 13.6 GHz |
| phase_noise | -110 dBc/Hz @ 10 kHz |
| output_power | -5 to +5 dBm |
| spurious | -80 dBc |

**Alternatives:**
- **[LMX2594](https://www.ti.com/lit/ds/symlink/lmx2594.pdf)** (Texas Instruments): Higher frequency, lower phase noise

**Selection Rationale:** Industry-standard wideband synthesizer with excellent phase noise performance for high dynamic range.

### 5. Dual/Quad Channel ADC for I/Q digitization

**Primary Choice:** [AD9208](https://www.analog.com/media/en/technical-documentation/data-sheets/AD9208.pdf) (Analog Devices)

*Dual, 14-bit, 3 GSPS ADC with JESD204B interface. Suitable for wideband I/Q digitization.*

[📄 Datasheet](https://www.analog.com/media/en/technical-documentation/data-sheets/AD9208.pdf)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/AD9208-3000EBZ/6043841)

| Spec | Value |
|---|---|
| resolution | 14-bit |
| sample_rate | 3 GSPS |
| input_bandwidth | 9 GHz |
| snr | 58.5 dBFS |
| interface | JESD204B (8 lanes) |

**Alternatives:**
- **[ADC12J4000](https://www.ti.com/lit/ds/symlink/adc12j4000.pdf)** (Texas Instruments): 12-bit, 4 GSPS, similar interface

**Selection Rationale:** High sample rate and bandwidth support required instantaneous bandwidth with JESD204B interface.

### 6. Power Management - Buck Converter

**Primary Choice:** [LT8645S](https://www.analog.com/media/en/technical-documentation/data-sheets/lt8645s.pdf) (Analog Devices)

*Silent Switcher 2 synchronous step-down regulator. Low noise, high efficiency suitable for RF applications.*

[📄 Datasheet](https://www.analog.com/media/en/technical-documentation/data-sheets/lt8645s.pdf)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/LT8645S-1/6024422)

| Spec | Value |
|---|---|
| input_voltage | 3.4-42V |
| output_current | 8A |
| switching_frequency | 2 MHz |
| efficiency | 95% typ |

**Alternatives:**
- **[TPS62913](https://www.ti.com/lit/ds/symlink/tps62913.pdf)** (Texas Instruments): Lower current, very low noise

**Selection Rationale:** Low EMI/EMC emission and high efficiency, suitable for powering sensitive RF circuitry.

### 7. Control MCU

**Primary Choice:** [STM32H743](https://www.st.com/resource/en/datasheet/stm32h743bi.pdf) (STMicroelectronics)

*High-performance ARM Cortex-M7 MCU with ample peripherals for SPI control of RF components.*

[📄 Datasheet](https://www.st.com/resource/en/datasheet/stm32h743bi.pdf)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/stmicroelectronics/STM32H743VIT6/10352570)

| Spec | Value |
|---|---|
| core | Cortex-M7 @ 480MHz |
| flash | 2 MB |
| ram | 1 MB |
| spi | 6 interfaces |
| timers | 22 |

**Alternatives:**
- **[ATSAMV71Q21](https://www.microchip.com/en-us/product/ATSAMV71Q21)** (Microchip): Cortex-M7, similar performance

**Selection Rationale:** Ample processing power and SPI interfaces to control multiple RF components.

### 8. RF Input Connector

**Primary Choice:** [142-0701-851](https://www.cinchconnectivity.com/wp-content/uploads/datasheets/SMA-Connectors.pdf) (Cinch Connectivity Solutions)

*SMA end launch PCB jack for 0.062" board. 50 Ohm impedance.*

[📄 Datasheet](https://www.cinchconnectivity.com/wp-content/uploads/datasheets/SMA-Connectors.pdf)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/cinch-connectivity-solutions/142-0701-851/2486852)

| Spec | Value |
|---|---|
| frequency | DC-18 GHz |
| vswr | 1.3:1 max |
| impedance | 50 Ohm |
| mounting | End launch PCB |

**Alternatives:**
- **[086-1-4-4-4-0](https://www.molex.com/pdm_docs/sd/086114440_sd.pdf)** (Molex): Similar performance

**Selection Rationale:** Industry-standard connector supporting full 5-18 GHz range with low VSWR.
