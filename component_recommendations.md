# Component Recommendations
## j,fj

### 1. Wideband Low Noise Amplifier

**Primary Choice:** [HMC1113LP3DE](https://www.analog.com/en/search.html#q=HMC1113LP3DE) (Analog Devices)

*GaAs MMIC PHEMT LNA, 2-20 GHz, 20 dB gain, 2.5 dB noise figure, +20 dBm P1dB*

[📄 Datasheet](https://www.analog.com/en/search.html#q=HMC1113LP3DE)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/hmc1113lp3de/5977250)

| Spec | Value |
|---|---|
| freq_range | 2-20 GHz |
| gain | 20 dB |
| noise_figure | 2.5 dB |
| p1db | +20 dBm |
| supply | 5V @ 90 mA |

**Alternatives:**
- **[GVA-123+](https://www.minicircuits.com/pdfs/GVA-123+.pdf)** (Mini-Circuits): Slightly higher NF (3.5 dB), lower power, lower cost

**Selection Rationale:** Excellent noise figure and gain across 4.5-18.5 GHz range, 5V supply compatible, industrial temp rated

### 2. Wideband Mixer

**Primary Choice:** [HMC1056LP4BE](https://www.analog.com/en/search.html#q=HMC1056LP4BE) (Analog Devices)

*GaAs MMIC mixer, 6-26 GHz, +17 dBm LO drive, 10 dB conversion loss*

[📄 Datasheet](https://www.analog.com/en/search.html#q=HMC1056LP4BE)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/hmc1056lp4be/5968259)

| Spec | Value |
|---|---|
| rf_range | 6-26 GHz |
| lo_range | 6-26 GHz |
| if_range | DC-8 GHz |
| conv_loss | 10 dB |
| lo_drive | +17 dBm |

**Alternatives:**
- **[MM1-0726HSM](https://www.google.com/search?q=MM1-0726HSM+datasheet)** (Marki Microwave): Lower conversion loss (8 dB), higher LO power required, higher cost

**Selection Rationale:** Wideband coverage, moderate LO drive, good linearity, 5V compatible bias

### 3. Wideband IF Amplifier

**Primary Choice:** [HMC699LP4](https://www.analog.com/en/search.html#q=HMC699LP4) (Analog Devices)

*DC-6 GHz VGA, 24 dB gain range, low noise figure*

[📄 Datasheet](https://www.analog.com/en/search.html#q=HMC699LP4)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/hmc699lp4/5969011)

| Spec | Value |
|---|---|
| freq_range | DC-6 GHz |
| gain_range | -3 to +24 dB |
| noise_figure | 4 dB |
| p1db | +18 dBm |

**Alternatives:**
- **[GVA-64+](https://www.google.com/search?q=GVA-64%2B+datasheet)** (Mini-Circuits): Fixed gain, lower cost, requires external VGA

**Selection Rationale:** Variable gain for dynamic range control, covers required IF bandwidth

### 4. Wideband LO Synthesizer

**Primary Choice:** [ADF5356](https://www.analog.com/en/search.html#q=ADF5356) (Analog Devices)

*Microwave wideband synthesizer with integrated VCO, 53.125 MHz to 13.6 GHz*

[📄 Datasheet](https://www.analog.com/en/search.html#q=ADF5356)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/adf5356ccpz/6129810)

| Spec | Value |
|---|---|
| freq_range | 53.125 MHz to 13.6 GHz |
| phase_noise | -125 dBc/Hz @ 1 MHz |
| output_power | -5 to +5 dBm |
| supply | 3.3-5.25V |

**Alternatives:**
- **[LMX2594](https://www.ti.com/lit/ds/symlink/lmx2594.pdf)** (Texas Instruments): Higher frequency range up to 15 GHz, similar performance

**Selection Rationale:** Industry-standard wideband synthesizer, excellent phase noise, SPI programmable, 5V compatible

### 5. 14-bit 4 GSPS ADC

**Primary Choice:** [ADC12DJ3200](https://www.ti.com/lit/ds/symlink/adc12dj3200.pdf) (Texas Instruments)

*12-bit dual-channel 6.4 GSPS ADC (single channel 14-bit mode up to 4 GSPS), JESD204B output*

[📄 Datasheet](https://www.ti.com/lit/ds/symlink/adc12dj3200.pdf)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/texas-instruments/ADC12DJ3200AB/9829027)

| Spec | Value |
|---|---|
| resolution | 14-bit (single channel mode) |
| sample_rate | 4 GSPS |
| input_bw | 8 GHz |
| interface | JESD204B/LVDS |
| supply | 1.0V, 1.8V, 3.3V |

**Alternatives:**
- **[AD9208](https://www.analog.com/en/search.html#q=AD9208)** (Analog Devices): 14-bit 3 GSPS, higher power, JESD204C

**Selection Rationale:** High-speed ADC with sufficient bandwidth, supports LVDS/JESD204B output, industrial temperature range

### 6. Power Management

**Primary Choice:** [TPS62913](https://www.ti.com/lit/ds/symlink/tps62913.pdf) (Texas Instruments)

*5V input, 3.3V/5A output step-down DC/DC converter with low noise*

[📄 Datasheet](https://www.ti.com/lit/ds/symlink/tps62913.pdf)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/texas-instruments/TPS62913DRCR/10299404)

| Spec | Value |
|---|---|
| vin | 4.5-18V |
| vout | 3.3V adjustable |
| iout | 5A |
| noise | 10 uVRMS |
| efficiency | 95% |

**Alternatives:**
- **[LT8610](https://www.analog.com/en/search.html#q=LT8610)** (Analog Devices): Similar specs, higher cost, lower noise

**Selection Rationale:** Low-noise switching regulator suitable for RF applications, 5V input compatible, industrial temp

### 7. ESD Protection Limiter

**Primary Choice:** [HMC1061LP3DE](https://www.analog.com/en/search.html#q=HMC1061LP3DE) (Analog Devices)

*GaAs MMIC limiter, DC to 20 GHz, +20 dBm threshold*

[📄 Datasheet](https://www.analog.com/en/search.html#q=HMC1061LP3DE)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/hmc1061lp3de/5977159)

| Spec | Value |
|---|---|
| freq_range | DC-20 GHz |
| insertion_loss | 0.5 dB |
| threshold | +20 dBm |
| esd_protection | 2 kV |

**Alternatives:**
- **[LMRPFL-184+](https://www.google.com/search?q=LMRPFL-184%2B+datasheet)** (Mini-Circuits): Higher threshold, higher insertion loss

**Selection Rationale:** Protects front-end from over-voltage up to +10 dBm spec, low insertion loss
