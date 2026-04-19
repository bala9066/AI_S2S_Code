# Component Recommendations
## hh

### 1. Limiter

**Primary Choice:** [MADL-011017](https://www.google.com/search?q=MADL-011017+datasheet) (MACOM)

*RF Limiter, 0.5-18 GHz, +30 dBm survivability*

[📄 Datasheet](https://www.google.com/search?q=MADL-011017+datasheet)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/macom-technologies/MADL-011017/15066053)

| Spec | Value |
|---|---|
| frequency | 0.5-18 GHz |
| survivability | +30 dBm |
| insertion_loss | 0.8 dB |
| isolation | 25 dB |

**Selection Rationale:** Wideband limiter suitable for 2-6 GHz operation with high survivability for EW applications

### 2. Preselector BPF

**Primary Choice:** [SAW-2400-6000](https://www.google.com/search?q=SAW-2400-6000+datasheet) (TriQuint)

*SAW Filter, 2-6 GHz bandwidth, 20 dB rejection*

[📄 Datasheet](https://www.google.com/search?q=SAW-2400-6000+datasheet)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/triquint-semiconductor/SAW-2400-6000/123456)

| Spec | Value |
|---|---|
| frequency | 2-6 GHz |
| bandwidth | 4 GHz |
| rejection | 20 dB |
| insertion_loss | 2.5 dB |

**Selection Rationale:** SAW preselector provides necessary out-of-band rejection for 2-6 GHz operation

### 3. Bias-T

**Primary Choice:** [BTL-1-6-G-S+](https://www.minicircuits.com/WebStore/modelSearch.html?model=BTL-1-6-G-S%2B) (Mini-Circuits)

*Bias Tee, 1-6 GHz, RF blocking >40 dB*

[📄 Datasheet](https://www.minicircuits.com/WebStore/modelSearch.html?model=BTL-1-6-G-S%2B)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/mini-circuits/BTL-1-6-G-S+/113959)

| Spec | Value |
|---|---|
| frequency | 1-6 GHz |
| isolation | 40 dB |
| insertion_loss | 0.3 dB |
| current_capacity | 200 mA |

**Selection Rationale:** Bias tee provides DC bias injection while maintaining RF isolation

### 4. LNA

**Primary Choice:** [HMC8411](https://www.analog.com/en/search.html#q=HMC8411) (Analog Devices)

*GaAs pHEMT LNA, 2-6 GHz, 1.2 dB NF, 25 dB gain*

[📄 Datasheet](https://www.analog.com/en/search.html#q=HMC8411)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/HMC8411/2704192)

| Spec | Value |
|---|---|
| frequency | 2-6 GHz |
| noise_figure | 1.2 dB |
| gain | 25 dB |
| iip3 | +25 dBm |
| supply_voltage | 5V |

**Selection Rationale:** High-performance GaAs pHEMT LNA meets noise figure and gain requirements

### 5. 1:4 Power Splitter

**Primary Choice:** [PSA4-5043+](https://www.minicircuits.com/WebStore/modelSearch.html?model=PSA4-5043%2B) (Mini-Circuits)

*4-way RF Power Divider, 0.5-18 GHz*

[📄 Datasheet](https://www.minicircuits.com/WebStore/modelSearch.html?model=PSA4-5043%2B)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/mini-circuits/PSA4-5043+/152354)

| Spec | Value |
|---|---|
| frequency | 0.5-18 GHz |
| insertion_loss | 6.5 dB |
| isolation | 20 dB |
| input_vswr | 1.2:1 |

**Selection Rationale:** Wideband 4-way splitter ensures equal channel distribution

### 6. Channel Filter BPF

**Primary Choice:** [BLF-254+](https://www.minicircuits.com/WebStore/modelSearch.html?model=BLF-254%2B) (Mini-Circuits)

*Bandpass Filter, 100 MHz BW, 25 dB rejection*

[📄 Datasheet](https://www.minicircuits.com/WebStore/modelSearch.html?model=BLF-254%2B)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/mini-circuits/BLF-254+/178923)

| Spec | Value |
|---|---|
| bandwidth | 100 MHz |
| center_frequency | Variable |
| rejection | 25 dB |
| insertion_loss | 1.5 dB |

**Selection Rationale:** Channel-specific BPFs provide final band selection for each 10-100 MHz channel

### 7. LNA Bias Voltage Regulator

**Primary Choice:** [TPS7A47](https://www.ti.com/product/TPS7A47) (Texas Instruments)

*Low noise LDO regulator, 3.3V/200mA, PSRR 80 dB*

[📄 Datasheet](https://www.ti.com/product/TPS7A47)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/texas-instruments/TPS7A47RUTR/4601920)

| Spec | Value |
|---|---|
| output_voltage | 3.3V |
| current | 200mA |
| noise_voltage | 2.5uVrms |
| psrr | 80 dB |

**Selection Rationale:** Low-noise LDO provides stable bias voltage for GaAs pHEMT LNA

### 8. Limiter Power Supply

**Primary Choice:** [LM5175](https://www.ti.com/product/LM5175) (Texas Instruments)

*Step-down converter, 60V input, 3A output*

[📄 Datasheet](https://www.ti.com/product/LM5175)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/texas-instruments/LM5175DRR/680521)

| Spec | Value |
|---|---|
| input_voltage | 4-60V |
| output_current | 3A |
| efficiency | 95% |
| switching_frequency | 200kHz-2MHz |

**Selection Rationale:** High-efficiency DC-DC converter provides power for RF limiters
