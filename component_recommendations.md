# Component Recommendations
## kgo

### 1. Wideband LNA (5-18 GHz)

**Primary Choice:** [HMC1099LP4DE](https://www.analog.com/en/search.html#q=HMC1099LP4DE) (Analog Devices)

*GaAs MMIC 5-20 GHz Darlington amplifier, 20 dB gain, 3.5 dB noise figure, +19 dBm P1dB. Military temperature (-55C to +125C) compliant.*

[📄 Datasheet](https://www.analog.com/en/search.html#q=HMC1099LP4DE)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices/hmc1099lp4de/5596526)

| Spec | Value |
|---|---|
| Frequency Range | 5-20 GHz |
| Gain | 20 dB |
| Noise Figure | 3.5 dB |
| P1dB | +19 dBm |
| Package | 4x4 mm QFN |
| Temp Range | -55 to +125°C |

**Alternatives:**
- **[GVA-123+](https://www.minicircuits.com/pdfs/GVA-123+.pdf)** (Mini-Circuits): Similar gain, slightly higher NF (4 dB), lower cost
- **[AMMC-6241](https://www.google.com/search?q=AMMC-6241+datasheet)** (Macom (Qorvo)): Higher gain (24 dB) but limited to 18 GHz max

**Selection Rationale:** Selected for wide bandwidth coverage, excellent noise figure, and military temperature rating. Low power consumption fits budget.

### 2. Digital VGA / Variable Gain Amplifier

**Primary Choice:** [HMC698LP4](https://www.analog.com/en/search.html#q=HMC698LP4) (Analog Devices)

*0.05-6 GHz digital VGA, -11.5 to +20 dB gain range, 1 dB steps, 1.5 dB noise figure. For IF/RF gain control.*

[📄 Datasheet](https://www.analog.com/en/search.html#q=HMC698LP4)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices/hmc698lp4e/1866062)

| Spec | Value |
|---|---|
| Frequency | 50 MHz - 6 GHz |
| Gain Range | -11.5 to +20 dB |
| Gain Step | 1 dB |
| Noise Figure | 3.5 dB |
| Control | Serial/Parallel |
| Package | LP4 (24-lead) |
| Temp Range | -40 to +85°C |

**Alternatives:**
- **[HMC695LP4](https://www.analog.com/en/search.html#q=HMC695LP4)** (Analog Devices): Wider bandwidth (DC-7 GHz), slightly higher noise figure

**Selection Rationale:** Digital gain control required for AGC loop. Serial interface enables automated gain adjustment.

### 3. High-Frequency Mixer

**Primary Choice:** [HMC1052LP4E](https://www.analog.com/en/search.html#q=HMC1052LP4E) (Analog Devices)

*Double-balanced mixer, 6-20 GHz RF/LO, DC-8 GHz IF, +17 dBm P1dB, +27 dBm IP3. High linearity for wideband operation.*

[📄 Datasheet](https://www.analog.com/en/search.html#q=HMC1052LP4E)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices/hmc1052lp4e/1866056)

| Spec | Value |
|---|---|
| RF/LO Range | 6-20 GHz |
| IF Range | DC-8 GHz |
| Conversion Loss | 7.5 dB |
| P1dB | +17 dBm |
| IP3 | +27 dBm |
| LO Drive | +13 to +17 dBm |
| Package | QFN 4x4 mm |
| Temp Range | -55 to +125°C |

**Alternatives:**
- **[MCA-28](https://www.google.com/search?q=MCA-28+datasheet)** (Macom): Similar specs, slightly lower IP3 (+24 dBm)

**Selection Rationale:** Military temperature rated, covers entire 5-18 GHz band with margin. High IP3 preserves linearity.

### 4. LO Synthesizer / PLL

**Primary Choice:** [ADF5356](https://www.analog.com/en/search.html#q=ADF5356) (Analog Devices)

*Microwave wideband synthesizer with integrated VCO, 53.125 MHz to 13.6 GHz, -136 dBc/Hz phase noise at 10 kHz offset.*

[📄 Datasheet](https://www.analog.com/en/search.html#q=ADF5356)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices/adf5355bccpz/5596546)

| Spec | Value |
|---|---|
| Frequency Range | 53.125 MHz - 13.6 GHz |
| Phase Noise | -136 dBc/Hz @ 10 kHz |
| Output Power | -5 to +5 dBm |
| Supply | 3.15-3.45V |
| Package | 32-lead LFCSP |
| Temp Range | -40 to +85°C |

**Alternatives:**
- **[LMX2595](https://www.ti.com/product/LMX2595)** (Texas Instruments): Higher frequency (up to 20 GHz), similar phase noise

**Selection Rationale:** Wideband coverage of LO frequencies needed for downconversion. Excellent phase noise for SFDR.

### 5. 12-bit ADC (1-10 GSPS)

**Primary Choice:** [RFADC-12X1000](https://www.google.com/search?q=RFADC-12X1000+datasheet) (Teledyne e2v (recommended placeholder))

*12-bit, 1 GSPS ADC with LVDS outputs. For higher sampling rates, consider interleaved architecture. Note: Actual part selection [specify] based on detailed performance trade-offs.*

[📄 Datasheet](https://www.google.com/search?q=RFADC-12X1000+datasheet)

| Spec | Value |
|---|---|
| Resolution | 12-bit |
| Max Sampling Rate | 1 GSPS |
| SFDR | 55 dBc |
| SNR | 58 dBFS |
| Output | LVDS |
| Power | 3.5W |
| Package | Custom |
| Temp Range | Industrial/Military options |

**Alternatives:**
- **[ADC12J4000](https://www.ti.com/product/ADC12J4000)** (Texas Instruments): 12-bit, 4 GSPS, JESD204B output (not LVDS)
- **[AD9208](https://www.analog.com/en/search.html#q=AD9208)** (Analog Devices): 14-bit, 3 GSPS, JESD204C, not LVDS

**Selection Rationale:** 12-bit resolution meets requirement. 10 GSPS may require interleaved multi-ADC architecture or time-interleaved converter. Major suppliers: TI (ADC12J4000), Analog Devices, Teledyne e2v. Requires detailed evaluation for power, performance, and availability.

### 6. Clock Generator / Jitter Cleaner

**Primary Choice:** [LMK04828](https://www.ti.com/product/LMK04828) (Texas Instruments)

*Low-jitter clock generator/jitter cleaner with dual-loop PLL, 95 fs RMS jitter (12 kHz - 20 MHz), up to 3.1 GHz output.*

[📄 Datasheet](https://www.ti.com/product/LMK04828)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/texas-instruments/LMK04828B-NOPB/5977366)

| Spec | Value |
|---|---|
| Output Frequency | Up to 3.1 GHz |
| RMS Jitter | 95 fs |
| Outputs | 14 differential |
| Supply | 3.15-3.45V |
| Package | 64-pin VQFN |
| Temp Range | -40 to +85°C |

**Alternatives:**
- **[ADCLK948](https://www.analog.com/en/search.html#q=ADCLK948)** (Analog Devices): Clock divider/distributor, lower jitter but not full synthesizer

**Selection Rationale:** Ultra-low jitter critical for high-speed ADC SNR/SFDR at 10 GSPS. Multiple outputs for system clock distribution.

### 7. LVDS Buffer

**Primary Choice:** [DS90LV047A](https://www.ti.com/product/DS90LV047A) (Texas Instruments)

*Quad LVDS line driver, 3.185 Gbps max data rate, 1.8V or 3.3V supply, 3.5 mW/channel typical.*

[📄 Datasheet](https://www.ti.com/product/DS90LV047A)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/texas-instruments/DS90LV047ATPW/301841)

| Spec | Value |
|---|---|
| Data Rate | Up to 3.185 Gbps |
| Outputs | 4 drivers |
| Supply | 3.3V or 1.8V |
| Package | TSSOP-16 or VFBGA-48 |
| Temp Range | -40 to +85°C |

**Alternatives:**
- **[MC100EP16](https://www.onsemi.com/pdf/datasheet/mc100ep16-d.pdf)** (ON Semiconductor): Higher speed (6+ Gbps) but higher power

**Selection Rationale:** Standard LVDS driver for ADC digital outputs. Low power, high speed, widely available.

### 8. DC-DC Converter (Power)

**Primary Choice:** [PTH08T240W](https://www.ti.com/product/PTH08T240W) (Texas Instruments)

*Non-isolated adjustable DC-DC converter module, 6-14V input, 0.6-5V output, 240W, 95% efficiency.*

[📄 Datasheet](https://www.ti.com/product/PTH08T240W)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/texas-instruments/PTH08T240WAD/1870047)

| Spec | Value |
|---|---|
| Input | 6-14V |
| Output | 0.6-5V adjustable |
| Max Power | 240W |
| Efficiency | 95% typ |
| Current | 40A max |
| Package | Module 20.3x25.4 mm |

**Alternatives:**
- **[MGC1/MGC2 Series](https://www.google.com/search?q=MGC1%2FMGC2%20Series+datasheet)** (Murata Power Solutions): Similar power module, different footprint

**Selection Rationale:** High power capacity with excellent efficiency keeps thermal load manageable. Wide input range accepts standard CompactPCI voltages.

### 9. LDO Regulator (Low Noise)

**Primary Choice:** [LT3045](https://www.google.com/search?q=LT3045+datasheet) (Analog Devices (Linear Technology))

*Ultra-low noise LDO, 0.8 μV RMS noise, 500mA output, high PSRR, 20V max input.*

[📄 Datasheet](https://www.google.com/search?q=LT3045+datasheet)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices/LT3045EDD%23PBF/5097968)

| Spec | Value |
|---|---|
| Output Current | 500 mA |
| Output Noise | 0.8 μV RMS |
| PSRR | 79 dB @ 10 kHz |
| Input | Up to 20V |
| Package | 12-lead MSOP or 3x3 mm DFN |

**Alternatives:**
- **[LT1763](https://www.analog.com/en/search.html#q=LT1763)** (Analog Devices): Lower current (500 mA), similar noise performance
- **[TPS7A47](https://www.ti.com/product/TPS7A47)** (Texas Instruments): 4 μV RMS noise, 1A output

**Selection Rationale:** Ultra-low noise critical for high-speed ADC clock and analog supply. High PSRR reduces power supply noise.

### 10. Control Logic (FPGA)

**Primary Choice:** [iCE40-HK](https://www.latticesemi.com/products#iCE40-HK) (Lattice Semiconductor)

*Small, low-power FPGA for control logic, SPI interfaces, and simple data buffering. Ultra-low power operation.*

[📄 Datasheet](https://www.latticesemi.com/products#iCE40-HK)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/lattice-semiconductor/ICE40-HK-01-QMN48R/6126146)

| Spec | Value |
|---|---|
| LUTs | 7680 |
| Memory | 128 KB |
| I/Os | Up to 256 |
| Power | < 1W active |
| Package | Various |
| Temp Range | -40 to +100°C (industrial) |

**Alternatives:**
- **[ECP5](https://www.latticesemi.com/products#ECP5)** (Lattice Semiconductor): Higher capacity, more power

**Selection Rationale:** Sufficient for AGC control, PLL configuration, and register management. Low power fits budget.

### 11. RF Input Connector

**Primary Choice:** [142-0701-851](https://www.google.com/search?q=142-0701-851+datasheet) (Cinch Connectivity Solutions (Johnson))

*SMA jack, 50 ohm, through-hole, 18 GHz rated, stainless steel, gold-plated contacts.*

[📄 Datasheet](https://www.google.com/search?q=142-0701-851+datasheet)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/cinch-connectivity-solutions-johnson/142-0701-851/2779068)

| Spec | Value |
|---|---|
| Frequency | DC-18 GHz |
| Impedance | 50 ohm |
| VSWR | 1.3:1 max @ 18 GHz |
| Mounting | Through-hole |
| Contact Plating | Gold |

**Alternatives:**
- **[3213202451](https://www.google.com/search?q=3213202451+datasheet)** (Molex): Similar SMA connector, different footprint

**Selection Rationale:** Standard SMA connector supports required frequency range. Through-hole provides mechanical robustness.
