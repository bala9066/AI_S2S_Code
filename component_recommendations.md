# Component Recommendations
## gvng

### 1. 8:1 RF Switch

**Primary Choice:** [PE8135](https://www.pasternack.com/product/pe8135.aspx) (Pasternack)

*8:1 GaAs SPDT RF Switch, 2-6 GHz, 0.5 dB insertion loss, 20 dB isolation*

[📄 Datasheet](https://www.pasternack.com/product/pe8135.aspx)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/pasternack/pe8135/5627758)

| Spec | Value |
|---|---|
| Frequency | 2-6 GHz |
| Insertion Loss | <0.5 dB |
| Isolation | >20 dB |
| Power Handling | +30 dBm |
| Technology | GaAs |

**Alternatives:**
- **[HMC806A-TR1E](https://www.analog.com/en/search.html#q=HMC806A-TR1E)** (Analog Devices): Higher power consumption, better performance

**Selection Rationale:** 8:1 GaAs switch provides reliable channel switching with low insertion loss and high isolation for EW applications

### 2. GaN HEMT LNA

**Primary Choice:** [CGH40010F](https://www.google.com/search?q=CGH40010F+datasheet) (Qorvo)

*GaN HEMT LNA, 2-18 GHz, 22 dB gain, 2.5 dB NF, +40 dBm OIP3*

[📄 Datasheet](https://www.google.com/search?q=CGH40010F+datasheet)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/qorvo/cgh40010f/7352681)

| Spec | Value |
|---|---|
| Frequency | 2-18 GHz |
| Gain | 22 dB |
| Noise Figure | 2.5 dB |
| OIP3 | +40 dBm |
| Gain Control | Manual |
| Technology | GaN |

**Alternatives:**
- **[CLM-2-8](https://www.google.com/search?q=CLM-2-8+datasheet)** (Crystek): Lower frequency range, lower power

**Selection Rationale:** High-performance GaN HEMT LNA provides excellent gain, low noise figure, and high linearity required for EW front-ends

### 3. Ceramic Pre-select Filter

**Primary Choice:** [BPFB-0600-5100+](https://www.minicircuits.com/WebStore/modelSearch.html?model=BPFB-0600-5100%2B) (Mini-Circuits)

*Bandpass Filter, 5.1 GHz center, 600 MHz bandwidth, 0.3 dB insertion loss*

[📄 Datasheet](https://www.minicircuits.com/WebStore/modelSearch.html?model=BPFB-0600-5100%2B)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/mini-circuits/BPFB-0600-5100+/2128868)

| Spec | Value |
|---|---|
| Center Frequency | 5.1 GHz |
| Bandwidth | 600 MHz |
| Insertion Loss | 0.3 dB |
| Rejection | >40 dB |
| Technology | Ceramic |

**Alternatives:**
- **[BPF-0520-5600+](https://www.minicircuits.com/WebStore/modelSearch.html?model=BPF-0520-5600%2B)** (Mini-Circuits): Different frequency response, similar performance

**Selection Rationale:** Ceramic bandpass filter provides excellent selectivity with low insertion loss for the target frequency band

### 4. RF Limiter

**Primary Choice:** [MADL-011019](https://www.google.com/search?q=MADL-011019+datasheet) (MACOM)

*GaAs Limiter, 2-18 GHz, +40 dBm peak power handling*

[📄 Datasheet](https://www.google.com/search?q=MADL-011019+datasheet)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/macom/MADL-011019/5837770)

| Spec | Value |
|---|---|
| Frequency | 2-18 GHz |
| Peak Power | +40 dBm |
| Insertion Loss | 0.5 dB |
| Leakage | <-40 dBm |
| Technology | GaAs |

**Alternatives:**
- **[SKY16406-321LF](https://www.google.com/search?q=SKY16406-321LF+datasheet)** (Skyworks): Lower frequency range, similar performance

**Selection Rationale:** High-power GaAs limiter provides excellent protection for high-power jamming environments

### 5. Input Matching Network

**Primary Choice:** [LC Matching Network](https://www.google.com/search?q=LC%20Matching%20Network+datasheet) (Custom)

*50Ω input matching network optimized for 2-6 GHz*

[📄 Datasheet](https://www.google.com/search?q=LC%20Matching%20Network+datasheet)

| Spec | Value |
|---|---|
| Frequency | 2-6 GHz |
| Impedance | 50Ω |
| Insertion Loss | <0.2 dB |
| VSWR | <1.2:1 |

**Alternatives:**
- **[AT-AT1100](https://www.google.com/search?q=AT-AT1100+datasheet)** (Anaren): Fixed matching range, commercial grade

**Selection Rationale:** Custom LC matching network provides optimal input matching for wideband operation

### 6. Output Matching Network

**Primary Choice:** [LC Matching Network](https://www.google.com/search?q=LC%20Matching%20Network+datasheet) (Custom)

*50Ω output matching network optimized for 2-6 GHz*

[📄 Datasheet](https://www.google.com/search?q=LC%20Matching%20Network+datasheet)

| Spec | Value |
|---|---|
| Frequency | 2-6 GHz |
| Impedance | 50Ω |
| Insertion Loss | <0.2 dB |
| VSWR | <1.2:1 |

**Alternatives:**
- **[AT-AT1100](https://www.google.com/search?q=AT-AT1100+datasheet)** (Anaren): Fixed matching range, commercial grade

**Selection Rationale:** Custom LC matching network provides optimal output matching for the superheterodyne receiver interface

### 7. SMP Connector

**Primary Choice:** [141-0711-801](https://www.amphenol.com/search?q=141-0711-801) (Amphenol)

*SMP Jack Connector, 50Ω, panel mount*

[📄 Datasheet](https://www.amphenol.com/search?q=141-0711-801)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/amphenol/141-0711-801/2751966)

| Spec | Value |
|---|---|
| Interface | SMP |
| Impedance | 50Ω |
| Frequency | DC-18 GHz |
| Power | 100 W |
| Mount | Panel |

**Alternatives:**
- **[141-0711-802](https://www.amphenol.com/search?q=141-0711-802)** (Amphenol): SMP plug instead of jack

**Selection Rationale:** SMP jack connector provides reliable RF interface with excellent performance up to 18 GHz

### 8. Active Bias Circuit

**Primary Choice:** [LMH6401](https://www.ti.com/product/LMH6401) (Texas Instruments)

*High-speed Op-Amp, 1.2 GHz bandwidth, low noise*

[📄 Datasheet](https://www.ti.com/product/LMH6401)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/texas-instruments/LMH6401/NOPB/1767941)

| Spec | Value |
|---|---|
| Bandwidth | 1.2 GHz |
| Supply Voltage | ±5V |
| Noise | 4.7 nV/√Hz |
| Current | 5 mA |
| Package | VSSOP-8 |

**Alternatives:**
- **[ADA4858-1](https://www.analog.com/en/search.html#q=ADA4858-1)** (Analog Devices): Lower bandwidth, better precision

**Selection Rationale:** High-speed op-amp provides precise active bias control for GaN HEMT LNA

### 9. Power Supply Regulator

**Primary Choice:** [LMR36506](https://www.ti.com/product/LMR36506) (Texas Instruments)

*6A, 36V, Simple Switcher Buck Converter*

[📄 Datasheet](https://www.ti.com/product/LMR36506)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/texas-instruments/LMR36506/NOPB/1864546)

| Spec | Value |
|---|---|
| Input Voltage | 4.5-36V |
| Output Current | 6A |
| Output Voltage | Adjustable |
| Efficiency | 96% |
| Frequency | 2.2 MHz |

**Alternatives:**
- **[LM5143](https://www.ti.com/product/LM5143)** (Texas Instruments): Lower current, similar efficiency

**Selection Rationale:** High-efficiency buck converter provides stable +12V to lower voltage rails for bias circuits
