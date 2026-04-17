# Component Recommendations
## receiver

### 1. RF Limiter / Input Protection

**Primary Choice:** [HMC1061LP4E](https://www.analog.com/en/search.html#q=HMC1061LP4E) (Analog Devices)

*Wideband DC-18 GHz RF limiter with 20 dBm threshold, 50 ns response time, 1.8 dB insertion loss.*

[📄 Datasheet](https://www.analog.com/en/search.html#q=HMC1061LP4E)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/hmc1061lp4e/5605663)

| Spec | Value |
|---|---|
| frequency_range | DC-18 GHz |
| threshold_power | 20 dBm |
| insertion_loss | 1.8 dB |
| response_time | 50 ns |
| package | 4x4 mm QFN |
| supply_voltage | +5V |

**Alternatives:**
- **[LMR236](https://www.google.com/search?q=LMR236+datasheet)** (Skyworks Solutions): Higher threshold (23 dBm) but slightly higher insertion loss (2.5 dB)

**Selection Rationale:** Provides fast over-power protection across full 5-18 GHz band with low insertion loss. Robust against high input powers up to 10W peak.

### 2. Wideband Low Noise Amplifier

**Primary Choice:** [TGA4506-SM](https://www.qorvo.com/products/p/TGA4506-SM) (Qorvo)

*GaAs MMIC LNA covering 2-20 GHz with 2.5 dB noise figure, 21 dB gain, +30 dBm OIP3.*

[📄 Datasheet](https://www.qorvo.com/products/p/TGA4506-SM)

| Spec | Value |
|---|---|
| frequency_range | 2-20 GHz |
| gain | 21 dB |
| noise_figure | 2.5 dB |
| output_p1db | +18 dBm |
| oip3 | +30 dBm |
| supply_voltage | +6V @ 90 mA |
| package | 4x4 mm QFN |

**Alternatives:**
- **[AMM-1207+](https://www.minicircuits.com/WebStore/modelSearch.html?model=AMM-1207%2B)** (Mini-Circuits): Slightly higher NF (3.0 dB) but lower power consumption (60 mA)

**Selection Rationale:** Excellent noise figure and gain across entire 5-18 GHz band. GaAs process provides robust performance and linearity.

### 3. Variable Gain Amplifier

**Primary Choice:** [HMC698LP4](https://www.analog.com/en/search.html#q=HMC698LP4) (Analog Devices)

*Digital variable gain amplifier with 31 dB gain range in 1 dB steps, DC-14 GHz, SPI control.*

[📄 Datasheet](https://www.analog.com/en/search.html#q=HMC698LP4)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/hmc698lp4/6120799)

| Spec | Value |
|---|---|
| frequency_range | DC-14 GHz |
| gain_range | 31 dB |
| gain_step | 1 dB |
| noise_figure | 5 dB |
| p1db | +17 dBm |
| control | SPI 3-wire |
| package | 4x4 mm 24-lead LFCSP |
| supply_voltage | +5V @ 130 mA |

**Alternatives:**
- **[HMC695LP4](https://www.analog.com/en/search.html#q=HMC695LP4)** (Analog Devices): Higher frequency (DC-20 GHz) but smaller 24 dB gain range

**Selection Rationale:** Wideband operation covers most of our band with precise 1 dB digital gain control via SPI interface.

### 4. IQ Mixer / Downconverter

**Primary Choice:** [HMC1052LP4E](https://www.analog.com/en/search.html#q=HMC1052LP4E) (Analog Devices)

*Wideband IQ mixer covering 5-26 GHz RF, 2-8 GHz LO, DC-6 GHz IF with 10 dB conversion gain.*

[📄 Datasheet](https://www.analog.com/en/search.html#q=HMC1052LP4E)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/hmc1052lp4e/6060681)

| Spec | Value |
|---|---|
| rf_frequency | 5-26 GHz |
| lo_frequency | 2-8 GHz |
| if_frequency | DC-6 GHz |
| conversion_gain | 10 dB |
| lo_drive | 0 to +5 dBm |
| iip3 | +23 dBm |
| noise_figure | 11 dB |
| package | 24-terminal LFCSP 4x4 mm |
| supply_voltage | +5V @ 180 mA |

**Alternatives:**
- **[MM1-0313HSS](https://www.google.com/search?q=MM1-0313HSS+datasheet)** (Marki Microwave): Passive mixer with no conversion loss but higher LO drive requirement (+10 to +17 dBm)

**Selection Rationale:** Integrated image-reject architecture eliminates need for external hybrid. Direct 5-18 GHz RF input coverage with excellent linearity.

### 5. LO Frequency Synthesizer

**Primary Choice:** [ADF5356](https://www.analog.com/en/search.html#q=ADF5356) (Analog Devices)

*Wideband PLL synthesizer with integrated VCO, 53.125 MHz to 13.6 GHz, -136 dBc/Hz phase noise.*

[📄 Datasheet](https://www.analog.com/en/search.html#q=ADF5356)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/ADF5356CCPZ/11034032)

| Spec | Value |
|---|---|
| frequency_range | 53.125 MHz - 13.6 GHz |
| phase_noise | -136 dBc/Hz @ 1MHz offset |
| frequency_resolution | 4 parts-per-trillion |
| vco_frequency | 3.4 - 13.6 GHz |
| lock_time | < 100 us |
| supply_voltage | 3.15-3.45 V |
| package | 32-lead LFCSP 5x5 mm |

**Alternatives:**
- **[LMX2594](https://www.ti.com/product/LMX2594)** (Texas Instruments): Higher frequency (10-20 GHz) but slightly worse phase noise performance

**Selection Rationale:** Integrated VCO eliminates external resonator. Low phase noise ensures good receiver sensitivity. Direct 5-18 GHz coverage possible with frequency doublers if needed.

### 6. IF Amplifier (Baseband IQ)

**Primary Choice:** [ADA4817](https://www.analog.com/en/search.html#q=ADA4817) (Analog Devices)

*Low noise, low distortion op-amp with 1 GHz unity-gain bandwidth, 4 nV/sqrt(Hz) noise density.*

[📄 Datasheet](https://www.analog.com/en/search.html#q=ADA4817)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/ADA4817-2ACPZ-R7/1277075)

| Spec | Value |
|---|---|
| bandwidth | 1 GHz |
| voltage_noise | 4 nV/sqrt(Hz) |
| slew_rate | 920 V/us |
| distortion | -90 dBc @ 20 MHz |
| supply_voltage | +5 to +12V |
| quiescent_current | 19.5 mA per channel |
| package | 16-lead LFCSP 3x3 mm |

**Alternatives:**
- **[THS4509](https://www.ti.com/product/THS4509)** (Texas Instruments): Similar bandwidth but higher voltage noise (6 nV/sqrt(Hz))

**Selection Rationale:** Ultra-low noise and excellent bandwidth for baseband I/Q amplification. Dual-channel package matches perfectly with I/Q signals.

### 7. Anti-Alias Filter (Baseband)

**Primary Choice:** [LPF-1000+](https://www.minicircuits.com/WebStore/modelSearch.html?model=LPF-1000%2B) (Mini-Circuits)

*LC low-pass filter with 1 GHz cutoff, 0.5 dB ripple, 50 dB rejection at 1.5x cutoff.*

[📄 Datasheet](https://www.minicircuits.com/WebStore/modelSearch.html?model=LPF-1000%2B)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/mini-circuits/LPF-1000%2B/3894741)

| Spec | Value |
|---|---|
| cutoff_frequency | 1.0 GHz |
| insertion_loss | 2.0 dB |
| passband_ripple | ±0.5 dB |
| rejection | 50 dB @ 1.5 GHz |
| impedance | 50 ohms |
| package | SMA connector module or PCB footprint |
| power_handling | +20 dBm |

**Alternatives:**
- **[NBFN-5500+](https://www.minicircuits.com/WebStore/modelSearch.html?model=NBFN-5500%2B)** (Mini-Circuits): Wider bandwidth (5.5 GHz) if higher IF output frequency needed

**Selection Rationale:** Provides excellent anti-aliasing for high-speed ADC while maintaining flat group delay in passband.

### 8. Dual Channel IQ ADC

**Primary Choice:** [AD9208](https://www.analog.com/en/search.html#q=AD9208) (Analog Devices)

*Dual, 14-bit, 3 GSPS ADC with JESD204B interface, -156 dBFS/Hz noise density.*

[📄 Datasheet](https://www.analog.com/en/search.html#q=AD9208)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/AD9208-3000EBZ/10994536)

| Spec | Value |
|---|---|
| resolution | 14 bits |
| sample_rate | 3 GSPS maximum |
| channels | 2 (I and Q) |
| snr | 58.5 dBFS @ 2 GHz |
| noise_density | -156 dBFS/Hz |
| interface | JESD204B (8 lanes) |
| supply_voltage | 1.0V and 1.8V |
| power_consumption | 1.5W typical |
| package | 16x16 mm 196-ball BGA |

**Alternatives:**
- **[ADC12DJ3200](https://www.ti.com/product/ADC12DJ3200)** (Texas Instruments): Dual 12-bit at 3.2 GSPS with lower power (1.1W) but slightly less resolution

**Selection Rationale:** High sampling rate and excellent SNR provide oversampling benefits for our application. JESD204B interface simplifies digital board routing.

### 9. Control MCU

**Primary Choice:** [STM32F407VGT6](https://www.st.com/en/search.html#q=STM32F407VGT6) (STMicroelectronics)

*ARM Cortex-M4 MCU at 168 MHz, 1MB flash, 192KB RAM, extensive SPI/I2C/UART peripherals.*

[📄 Datasheet](https://www.st.com/en/search.html#q=STM32F407VGT6)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/stmicroelectronics/STM32F407VGT6/1918600)

| Spec | Value |
|---|---|
| core | ARM Cortex-M4F |
| clock_speed | 168 MHz |
| flash | 1024 KB |
| ram | 192 KB |
| spi | 3 interfaces |
| timers | 14 |
| supply_voltage | 1.8V to 3.6V |
| package | LQFP-100 |
| power_consumption | 100 mA typical @ 168MHz |

**Alternatives:**
- **[ATSAMV71Q21](https://www.microchip.com/search/searchresults/ATSAMV71Q21)** (Microchip): ARM Cortex-M7 at 300 MHz with 2MB flash but higher cost

**Selection Rationale:** Robust industry-standard MCU with plenty of processing headroom for control algorithms and future feature expansion. Low power consumption.

### 10. DC-DC Power Supply Module

**Primary Choice:** [LTM4644](https://www.google.com/search?q=LTM4644+datasheet) (Analog Devices (Linear Technology))

*Quad 4A DC-DC regulator with 4V to 14V input, 0.6V to 5.5V programmable outputs.*

[📄 Datasheet](https://www.google.com/search?q=LTM4644+datasheet)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc-linear-technology/LTM4644IYP4PBF/5642293)

| Spec | Value |
|---|---|
| input_voltage | 4 to 14 V |
| output_channels | 4 independent |
| max_current | 4A per channel |
| output_voltage_range | 0.6 to 5.5 V |
| switching_frequency | 1 MHz |
| efficiency | 90% typical |
| package | 16x16 mm BGA LGA |
| operating_temp | -40 to +125C |

**Alternatives:**
- **[TPS65262](https://www.ti.com/product/TPS65262)** (Texas Instruments): Triple output (2 buck + 1 LDO) but lower total current capacity

**Selection Rationale:** Quad-output design provides all required rails (+5V, +3.3V, +1.8V) from single +12V input. High efficiency keeps thermal design manageable.
