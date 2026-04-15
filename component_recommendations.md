# Component Recommendations
## uyj

### 1. RF Limiter/Protector

**Primary Choice:** [HMC1061LP4E](https://www.analog.com/media/en/technical-documentation/data-sheets/hmc1061.pdf) (Analog Devices)

*0.1 to 6 GHz GaAs MMIC Limiter, 70W peak power handling, 0.7dB insertion loss. For 5-18GHz, will use two-stage protection.*

[📄 Datasheet](https://www.analog.com/media/en/technical-documentation/data-sheets/hmc1061.pdf)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/2172-HMC1061LP4E/5853634)

| Spec | Value |
|---|---|
| freq_range | DC to 6 GHz |
| peak_power | 70W |
| insertion_loss | 0.7 dB |
| threshold | 16 dBm |

**Alternatives:**
- **[LMPA2011](https://www.qorvo.com/products/d/eda/p/lmpa2011)** (Qorvo): Higher frequency range up to 20GHz, lower peak power 10W

**Selection Rationale:** HMC1061 provides robust input protection for high-power signals. For full 5-18GHz coverage, would cascade with wideband limiter like Skyworks SMP1345-079LF.

### 2. Wideband LNA

**Primary Choice:** [HMC1099LP5DE](https://www.analog.com/media/en/technical-documentation/data-sheets/hmc1099.pdf) (Analog Devices)

*2-20 GHz GaN MMIC Power Amplifier/LNA, 20 dB small signal gain, 2.5 dB noise figure, 1W P1dB*

[📄 Datasheet](https://www.analog.com/media/en/technical-documentation/data-sheets/hmc1099.pdf)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/2172-HMC1099LP5DE/5853635)

| Spec | Value |
|---|---|
| freq_range | 2-20 GHz |
| gain | 20 dB |
| noise_figure | 2.5 dB |
| p1db | 30 dBm |
| oip3 | 45 dBm |

**Alternatives:**
- **[TGA2622-SM](https://www.qorvo.com/products/d/eda/p/tga2622-sm)** (Qorvo): Wider bandwidth 2-22GHz, similar performance, higher cost

**Selection Rationale:** GaN-based LNA provides excellent noise figure (2.5 dB) and high linearity (OIP3 45 dBm) across entire 5-18GHz band with margin.

### 3. Variable Gain Amplifier

**Primary Choice:** [ADL5240](https://www.analog.com/media/en/technical-documentation/data-sheets/ADL5240.pdf) (Analog Devices)

*Digital/Analog VGA, 100 MHz to 6 GHz, 31.5 dB gain range, 1 dB step size, SPI controlled*

[📄 Datasheet](https://www.analog.com/media/en/technical-documentation/data-sheets/ADL5240.pdf)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/ADL5240ACPZ/4556019)

| Spec | Value |
|---|---|
| freq_range | 100 MHz to 6 GHz |
| gain_range | -11.5 to +20 dB |
| noise_figure | 6.5 dB |
| oip3 | 40 dBm |

**Alternatives:**
- **[HMC698LP4](https://www.analog.com/media/en/technical-documentation/data-sheets/hmc698.pdf)** (Analog Devices): Higher frequency 6-18GHz, 24dB gain range, analog control

**Selection Rationale:** ADL5240 covers IF band after downconversion. For direct sampling architecture, HMC698LP4 (6-18GHz digital VGA) is better suited.

### 4. Direct RF Sampling ADC

**Primary Choice:** [ADC12DJ5200RF](https://www.ti.com/product/ADC12DJ5200RF) (Texas Instruments)

*12-bit, 5.2 GSPS dual-channel ADC with JESD204B/C interface, direct RF sampling to 6 GHz*

[📄 Datasheet](https://www.ti.com/product/ADC12DJ5200RF)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/texas-instruments/ADC12DJ5200RFSPB/5809902)

| Spec | Value |
|---|---|
| resolution | 12-bit |
| sample_rate | 5.2 GSPS |
| input_bw | 6 GHz |
| noise_figure | -156 dBFS/Hz |
| sfdr | 58 dBc |
| interface | JESD204B/C |

**Alternatives:**
- **[AD9213](https://www.analog.com/en/products/ad9213.html)** (Analog Devices): 10-bit, 10.25 GSPS, similar bandwidth, lower resolution

**Selection Rationale:** ADC12DJ5200RF exceeds 10-bit requirement with 12-bit resolution, operates up to 5.2 GSps, and supports direct RF sampling beyond 5 GHz with excellent noise performance.

### 5. FPGA for Signal Processing

**Primary Choice:** [XCZU9EG-FFVB1156](https://www.amd.com/en/products/support/programmable/zynq-ultrascale-plus-mpsocs/xczu9eg) (AMD/Xilinx)

*Zynq UltraScale+ MPSoC with 253K logic cells, 960 DSP slices, JESD204B IP, PCIe Gen3 x4*

[📄 Datasheet](https://www.amd.com/en/products/support/programmable/zynq-ultrascale-plus-mpsocs/xczu9eg)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/amd/XCZU9EG-FFVB1156-I/6242229)

| Spec | Value |
|---|---|
| logic_cells | 253K |
| dsp_slices | 960 |
| transceivers | 32x 16.3 Gbps |
| memory | 4 GB DDR4 |
| jesd204b | Hard IP block |

**Alternatives:**
- **[10AX115N2F45I1SG](https://www.intel.com/content/www/us/en/docs/programmable/683698/current/overview.html)** (Intel/Altera): Stratix 10 GX, similar resources, different toolchain

**Selection Rationale:** Zynq UltraScale+ provides integrated ARM cores for control, massive DSP resources for DDC/filtering at 5 GSps, and hardened JESD204B IP for ADC interface.

### 6. Clock Synthesizer/Jitter Cleaner

**Primary Choice:** [LMK04828](https://www.ti.com/product/LMK04828) (Texas Instruments)

*Ultra-low jitter clock generator with dual-loop PLL, 12 outputs, <100 fs rms jitter*

[📄 Datasheet](https://www.ti.com/product/LMK04828)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/texas-instruments/LMK04828BQNKRRQ1/6204498)

| Spec | Value |
|---|---|
| output_freq | Up to 3.2 GHz |
| jitter | <100 fs rms |
| outputs | 12 programmable |
| skew | <15 ps |

**Alternatives:**
- **[AD9528-1](https://www.analog.com/en/products/ad9528-1.html)** (Analog Devices): Similar performance, dual PLL, 14 outputs

**Selection Rationale:** LMK04828 provides ultra-low jitter clocking essential for 5 GSps ADC SNR performance with multiple outputs for system clock distribution.

### 7. DC-DC Converter 12V to Intermediate Rails

**Primary Choice:** [LTM4644](https://www.analog.com/media/en/technical-documentation/data-sheets/ltm4644.pdf) (Analog Devices)

*Quad 4A DC-DC regulator module, 4.5-14V input, 0.6-5.5V output, high efficiency*

[📄 Datasheet](https://www.analog.com/media/en/technical-documentation/data-sheets/ltm4644.pdf)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/LTM4644IY-EPBFC-PBF/12145695)

| Spec | Value |
|---|---|
| input_v | 4.5-14V |
| output_i | 4x4A |
| efficiency | >90% |
| switching_freq | 1 MHz |

**Alternatives:**
- **[TPS6521805](https://www.ti.com/product/TPS6521805)** (Texas Instruments): 5-rail PMIC, integrated sequencing, lower current

**Selection Rationale:** LTM4644 provides efficient power conversion from 12V to FPGA core, ADC, and LNA rails with good thermal performance in compact package.

### 8. Ultra-Low Noise LDO for Analog Supplies

**Primary Choice:** [LT3045](https://www.analog.com/media/en/technical-documentation/data-sheets/3045fd.pdf) (Analog Devices)

*Ultra-low noise 500mA LDO, 0.8μV RMS noise, 500mA output*

[📄 Datasheet](https://www.analog.com/media/en/technical-documentation/data-sheets/3045fd.pdf)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/LT3045EDD-PBF/5650092)

| Spec | Value |
|---|---|
| input_v | 20V max |
| output_i | 500mA |
| noise | 0.8μV RMS |
| psrr | 79dB at 10kHz |

**Alternatives:**
- **[TPS7A47](https://www.ti.com/product/TPS7A47)** (Texas Instruments): 1A output, similar noise performance

**Selection Rationale:** LT3045 provides exceptional noise performance critical for ADC and LNA analog supply rails to meet system noise figure requirements.
