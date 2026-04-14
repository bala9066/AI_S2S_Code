# Component Recommendations
## rbhjdaz

### 1. RF Input Limiter

**Primary Choice:** [RFLM5012-10](https://www.qorvo.com/products/d/RAHM5012-10) (Qorvo)

*10W limiter, DC-6GHz, ultra-low leakage, high power handling for radar protection*

[📄 Datasheet](https://www.qorvo.com/products/d/RAHM5012-10)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/qorvo/RFLM5012-10/7853160)

| Spec | Value |
|---|---|
| freq_range | DC-6 GHz |
| peak_power | 10W CW |
| insertion_loss | 0.5 dB |
| leakage | 13 dBm |
| recovery_time | 10 ns |

**Alternatives:**
- **[NLA-5050-1](https://cdn.macom.com/datasheets/nla5050.pdf)** (M/A-COM): Lower power (50W) but lower cost
- **[LIM0609-03](https://www.mitsubishielectric.com/en/products/index.html)** (Mitsubishi): Wider bandwidth, higher leakage

**Selection Rationale:** Chosen for high pulsed power protection (100W 1us typical) and low insertion loss. RFLM5012-10 is a variant with 6GHz bandwidth; may cascade with RFLM5012-18 for 18GHz coverage.

### 2. Wideband Low Noise Amplifier

**Primary Choice:** [TGA4537-SM](https://www.qorvo.com/products/d/TGA4537-SM) (Qorvo)

*DC-20 GHz GaN MMIC amplifier, 20 dB gain, 2.5 dB noise figure*

[📄 Datasheet](https://www.qorvo.com/products/d/TGA4537-SM)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/qorvo/TGA4537-SM/6999665)

| Spec | Value |
|---|---|
| freq_range | DC-20 GHz |
| gain | 20 dB |
| noise_figure | 2.5 dB |
| p1db | 22 dBm |
| psat | 24 dBm |

**Alternatives:**
- **[AMMC-6241](https://www.analog.com/media/en/technical-documentation/data-sheets/ammc-6241.pdf)** (Analog Devices): GaAs, lower P1dB (18 dBm) but 1.8 dB NF
- **[MAAL-011141](https://www.macom.com/datasheets/MAAL-011141.pdf)** (MACOM): Lower gain (15 dB), lower cost

**Selection Rationale:** GaN technology provides high linearity and power handling. 2.5 dB NF keeps system NF budget on target. Wideband coverage eliminates switch complexity.

### 3. Variable Gain Amplifier (RF)

**Primary Choice:** [HMC698LP4](https://www.analog.com/media/en/technical-documentation/data-sheets/hmc698.pdf) (Analog Devices)

*DC-14 GHz digital VGA, 31 dB range, 1 LSB (1 dB) steps, SPI control*

[📄 Datasheet](https://www.analog.com/media/en/technical-documentation/data-sheets/hmc698.pdf)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices/HMC698LP4ETR/1897170)

| Spec | Value |
|---|---|
| freq_range | DC-14 GHz |
| gain_range | 31 dB |
| gain_step | 1 dB |
| noise_figure | 6 dB |
| op1db | 20 dBm |

**Alternatives:**
- **[ADL5240](https://www.analog.com/media/en/technical-documentation/data-sheets/ADL5240.pdf)** (Analog Devices): Analog VGA, 0-500 MHz IF only
- **[HMC794APZ5E](https://www.analog.com/media/en/technical-documentation/data-sheets/hmc794.pdf)** (Analog Devices): 2-18 GHz, but analog control

**Selection Rationale:** Digital SPI control eliminates analog VGA noise. 31 dB range per stage; cascade two for 60 dB total. Operates to 14 GHz; for 14-18 GHz consider HMC794.

### 4. Wideband Mixer

**Primary Choice:** [ADL5802](https://www.analog.com/media/en/technical-documentation/data-sheets/ADL5802.pdf) (Analog Devices)

*10 MHz to 6 GHz active mixer, high linearity, integrated LO amplifier*

[📄 Datasheet](https://www.analog.com/media/en/technical-documentation/data-sheets/ADL5802.pdf)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices/ADL5802ACPZ-R7/606968)

| Spec | Value |
|---|---|
| rf_range | 10 MHz - 6 GHz |
| lo_range | 10 MHz - 6 GHz |
| conv_gain | 7.5 dB |
| ip3 | 28.5 dBm |
| noise_figure | 13.5 dB |

**Alternatives:**
- **[HMC1174ST50E](https://www.analog.com/media/en/technical-documentation/data-sheets/hmc1174.pdf)** (Analog Devices): Passive mixer, 10-20 GHz coverage, 0 dB gain
- **[MAMX-011045](https://www.macom.com/datasheets/MAMX-011045.pdf)** (MACOM): Passive double-balanced, DC-12 GHz

**Selection Rationale:** Active mixer provides gain, reducing IF amp needs. High IP3 supports dynamic range. For 18 GHz direct mix, use HMC1174 or similar.

### 5. LO Synthesizer / PLL

**Primary Choice:** [ADF5355](https://www.analog.com/media/en/technical-documentation/data-sheets/ADF5355.pdf) (Analog Devices)

*Wideband synthesizer with integrated VCO, 53.125 MHz to 13.6 GHz, ultra-low phase noise*

[📄 Datasheet](https://www.analog.com/media/en/technical-documentation/data-sheets/ADF5355.pdf)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices/ADF5355CCPZ/9712256)

| Spec | Value |
|---|---|
| freq_range | 53.125 MHz - 13.6 GHz |
| phase_noise | -125 dBc/Hz @ 1 MHz offset |
| phase_noise_1kHz | -100 dBc/Hz |
| ref_clk | 10-250 MHz |

**Alternatives:**
- **[LMX2594](https://www.ti.com/lit/ds/symlink/lmx2594.pdf)** (Texas Instruments): Lower phase noise, but more complex layout
- **[HMC7044](https://www.analog.com/media/en/technical-documentation/data-sheets/hmc7044.pdf)** (Analog Devices): Lower frequency ceiling (8 GHz), better jitter

**Selection Rationale:** Industry-standard wideband PLL. Integrated VCO simplifies design. Meets -100 dBc/Hz @ 1 kHz requirement.

### 6. Dual ADC 12-bit

**Primary Choice:** [ADC12DJ3200](https://www.ti.com/lit/ds/symlink/adc12dj3200.pdf) (Texas Instruments)

*Dual 12-bit, 6.4 GSPS ADC, JESD204B interface, 2 GHz bandwidth per channel*

[📄 Datasheet](https://www.ti.com/lit/ds/symlink/adc12dj3200.pdf)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/texas-instruments/ADC12DJ3200IRGZT/6271677)

| Spec | Value |
|---|---|
| resolution | 12 bits |
| sample_rate_max | 6.4 GSPS |
| sample_rate_dual | 3.2 GSPS (2 ch) |
| analog_bw | 2.0 GHz |
| interface | JESD204B/C |
| sfdr | 68 dBc |

**Alternatives:**
- **[AD9208](https://www.analog.com/media/en/technical-documentation/data-sheets/ad9208.pdf)** (Analog Devices): Single channel, lower sample rate (3 GSPS)
- **[ATR1250](https://www.teledyne-e2v.com/product/atr1250/)** (Teledyne e2v): Space-qualified, higher cost

**Selection Rationale:** Meets 12-bit @ 3 GSPS requirement for 2 GHz IBW. JESD204B/C interface simplifies FPGA connection. High SFDR (68 dBc) meets dynamic range spec.

### 7. MCU Controller

**Primary Choice:** [STM32H753VI](https://www.st.com/resource/en/datasheet/stm32h753vi.pdf) (STMicroelectronics)

*ARM Cortex-M7 MCU @ 480 MHz, 2 MB Flash, 1 MB RAM, extensive SPI/I2C/UART*

[📄 Datasheet](https://www.st.com/resource/en/datasheet/stm32h753vi.pdf)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/stmicroelectronics/STM32H753VIT6/9527925)

| Spec | Value |
|---|---|
| core | Cortex-M7 @ 480 MHz |
| flash | 2 MB |
| ram | 1 MB |
| spi | 5 |
| i2c | 3 |
| temp_range | -40 to +85 C |
| package | LQFP-100 |

**Alternatives:**
- **[ATSAMV71Q21](https://www.microchip.com/en-us/product/ATSAMV71Q21)** (Microchip): Cortex-M7, lower clock (300 MHz)
- **[MK66FX1M0VMD18](https://www.nxp.com/docs/en/data-sheet/K66P144M180SF5RMV2.pdf)** (NXP): Cortex-M4, sufficient but older

**Selection Rationale:** High-performance MCU with ample peripherals for SPI control of multiple devices. Industrial temp range meets spec. Mature ecosystem.

### 8. DC-DC Converter 28V to 12V

**Primary Choice:** [VPT25-28-28-12-5-P](https://www.vptpower.com/wp-content/uploads/2023/01/25-28-28-12-5.pdf) (VPT)

*MIL-STD-704/A compliant DC-DC, 28V in to 12V out, 50W*

[📄 Datasheet](https://www.vptpower.com/wp-content/uploads/2023/01/25-28-28-12-5.pdf)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/vpt/VPT25-28-28-12-5-P/10991544)

| Spec | Value |
|---|---|
| vin | 28 VDC |
| vout | 12 VDC |
| power | 50 W |
| efficiency | 84 percent |
| compliance | MIL-STD-704/A, MIL-STD-461 |

**Alternatives:**
- **[RPD-1-2812-S](https://www.pcbpower.com/products/rpd-series-dc-dc-converters)** (PCB Power): Lower cost, lower EMI performance
- **[M2K28S12](https://www.megatron.com/en/products/dc-dc-converters/m2k-series)** (Megatron): 28V to 12V, 60W, but not MIL qualified

**Selection Rationale:** Designed for military avionics, meets input voltage spec and EMI requirements. 50W power rating aligns with budget.

### 9. Selectable Bandpass Filters

**Primary Choice:** [BP Series Custom](https://www.minicircuits.com/WebStore/dashboard.html?model=BP6%2B&rid=1517) (Mini-Circuits)

*Bandpass filter bank covering 5-18 GHz in 500-1000 MHz sub-bands, switchable*

[📄 Datasheet](https://www.minicircuits.com/WebStore/dashboard.html?model=BP6%2B&rid=1517)  [🛒 DigiKey](https://www.digikey.com/en/products/filter/bandpass-passive)

| Spec | Value |
|---|---|
| bands | 5-6, 6-8, 8-10, 10-12, 12-15, 15-18 GHz |
| insertion_loss | 2-3 dB |
| rejection | 40 dBc at band edges |

**Alternatives:**
- **[KLAF-18G+](https://www.kratosrf.com/KLAF-18G)** (KRATOS): Fixed 18 GHz low-pass, no sub-banding
- **[RCBF-5180+](https://www.minicircuits.com/WebStore/dashboard.html?model=RCBF-5180%2B)** (Mini-Circuits): Cavity filter, high Q but larger

**Selection Rationale:** Multiples of Mini-Circuits BP+ series filters can be selected. Actual implementation requires RF switch matrix (HMC241AETR).
