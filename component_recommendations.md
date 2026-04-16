# Component Recommendations
## dkfjg

### 1. Wideband Low Noise Amplifier (5-18 GHz)

**Primary Choice:** [HMC1042LP4BE](https://www.google.com/search?q=HMC1042LP4BE+datasheet) (Analog Devices (Hittite))

*GaAs MMIC LNA, 6-20 GHz, 24 dB gain, 2.5 dB noise figure, OIP3 24 dBm. Operates from +5V. Available in 4x4 mm QFN package.*

[📄 Datasheet](https://www.google.com/search?q=HMC1042LP4BE+datasheet)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-hittite/HMC1042LP4BE/3028666)

| Spec | Value |
|---|---|
| frequency_range | 6-20 GHz |
| gain | 24 dB |
| noise_figure | 2.5 dB |
| oip3 | 24 dBm |
| supply_voltage | +5V |
| power | 180 mW |
| package | 4x4mm QFN-24 |
| operating_temp | -55 to +125°C |

**Alternatives:**
- **[TQP3M9036](https://www.qorvo.com/products/d/da007296)** (Qorvo): Slightly lower NF (2.2 dB) but narrower band (6-16 GHz)
- **[MAAL-011141](https://www.macom.com/products/product-detail/MAAL-011141)** (MACOM): 6-18 GHz, NF 2.0 dB, gain 20 dB, lower power

**Selection Rationale:** Selected for wide frequency coverage (exceeds 18 GHz spec), excellent NF (<3 dB requirement), high linearity (OIP3 24 dBm >20 dBm requirement), military temperature range, and +5V operation compatible with power architecture.

### 2. Variable Gain Amplifier (5-18 GHz)

**Primary Choice:** [HMC698LP4](https://www.analog.com/en/search.html#q=HMC698LP4) (Analog Devices)

*Digital VGA, 5-20 GHz, 0-22 dB gain range in 1 dB steps, 3.5 dB noise figure, +5V supply. Serial interface control.*

[📄 Datasheet](https://www.analog.com/en/search.html#q=HMC698LP4)

| Spec | Value |
|---|---|
| frequency_range | 5-20 GHz |
| gain_range | 0-22 dB |
| gain_steps | 1 dB |
| noise_figure | 3.5 dB |
| oip3 | 27 dBm |
| p1db | 15 dBm |
| supply_voltage | +5V |
| package | 4x4mm QFN-24 |
| operating_temp | -40 to +85°C (extended available) |

**Alternatives:**
- **[ADL5202](https://www.analog.com/en/search.html#q=ADL5202)** (Analog Devices): Wider bandwidth but higher power, analog control

**Selection Rationale:** Provides precise digital gain control to achieve 30-40 dB total system gain specification. Wide bandwidth covers entire 5-18 GHz range.

### 3. Bandpass Filter (5-18 GHz)

**Primary Choice:** [CBP-1810-LF](https://www.google.com/search?q=CBP-1810-LF+datasheet) (Crystek)

*LTCC bandpass filter, 5-18 GHz, 3.5 dB insertion loss, >30 dB rejection at band edges. 50-ohm matched.*

[📄 Datasheet](https://www.google.com/search?q=CBP-1810-LF+datasheet)

| Spec | Value |
|---|---|
| frequency_range | 5-18 GHz |
| insertion_loss | 3.5 dB |
| rejection | >30 dB |
| return_loss | >15 dB |
| package | 3.2x1.6mm LTCC |
| operating_temp | -55 to +125°C |

**Alternatives:**
- **[RBP-1810+](https://www.google.com/search?q=RBP-1810%2B+datasheet)** (Mini-Circuits): Similar performance, slightly larger footprint

**Selection Rationale:** Compact LTCC filter provides out-of-band rejection and limits noise bandwidth. Military temperature rated.

### 4. Mixer for Downconversion

**Primary Choice:** [HMC774A](https://www.analog.com/en/search.html#q=HMC774A) (Analog Devices)

*Double-balanced mixer, 6-20 GHz RF/LO, DC-4 GHz IF, 7.5 dB conversion loss, +25 dBm OIP3. +5V operation.*

[📄 Datasheet](https://www.analog.com/en/search.html#q=HMC774A)

| Spec | Value |
|---|---|
| rf_lo_range | 6-20 GHz |
| if_range | DC-4 GHz |
| conversion_loss | 7.5 dB |
| oip3 | 25 dBm |
| lo_drive | 10-15 dBm |
| supply_voltage | +5V |
| package | QFN-16 |
| operating_temp | -40 to +85°C (extended available) |

**Alternatives:**
- **[MIX-0018](https://www.google.com/search?q=MIX-0018+datasheet)** (Marki Microwave): Lower conversion loss (6.5 dB) but higher cost

**Selection Rationale:** High linearity mixer supports wideband operation and meets >20 dBm IP3 requirement. +5V compatible.

### 5. High-Speed ADC with LVDS Output

**Primary Choice:** [ADC12J4000](https://www.ti.com/lit/ds/symlink/adc12j4000.pdf) (Texas Instruments)

*12-bit, 4 GSPS ADC with JESD204B output. Integrated DDC, programmable gain. 1.6 GHz input bandwidth.*

[📄 Datasheet](https://www.ti.com/lit/ds/symlink/adc12j4000.pdf)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/texas-instruments/ADC12J4000IRGZT/4660755)

| Spec | Value |
|---|---|
| resolution | 12 bit |
| max_sample_rate | 4 GSPS |
| input_bandwidth | 1.6 GHz |
| snr | 58 dBFS |
| sfdr | 68 dBc |
| interface | JESD204B (8 lanes) |
| supply_voltage | +3.3V analog, +1V digital |
| package | 648-pin BGA |
| operating_temp | -40 to +85°C |

**Alternatives:**
- **[AD9208](https://www.analog.com/en/search.html#q=AD9208)** (Analog Devices): 14-bit resolution, 3 GSPS, higher power

**Selection Rationale:** High sampling rate supports direct sampling or IF sampling architectures. JESD204B LVDS interface meets output requirement.

### 6. Power Management - 12V to 5V/3.3V

**Primary Choice:** [LTM4644](https://www.google.com/search?q=LTM4644+datasheet) (Analog Devices (Linear Technology))

*Quad-output step-down regulator module. 4A per channel, 4-14V input. Regulates 12V to 5V and 3.3V rails with high efficiency.*

[📄 Datasheet](https://www.google.com/search?q=LTM4644+datasheet)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-linear-technology/LTM4644IYPF-PBF/6069874)

| Spec | Value |
|---|---|
| input_range | 4-14V |
| output1 | 5V @ 4A |
| output2 | 3.3V @ 4A |
| efficiency | >90% |
| switching_freq | 1 MHz |
| package | 15x15x5.1mm BGA |
| operating_temp | -40 to +125°C |

**Alternatives:**
- **[TPS62913](https://www.ti.com/lit/ds/symlink/tps62913.pdf)** (Texas Instruments): Single output, use multiple units

**Selection Rationale:** Military-grade buck module provides efficient 12V conversion to required 5V and 3.3V rails. Low output noise suitable for RF applications.

### 7. Low-Noise LDO for Analog Front-End

**Primary Choice:** [LT3045](https://www.analog.com/en/search.html#q=LT3045) (Analog Devices)

*Ultra-low noise LDO regulator, 500 mA output, 0.8 µV RMS noise. Adjustable output, high PSRR. -55 to +125°C temp grade available.*

[📄 Datasheet](https://www.analog.com/en/search.html#q=LT3045)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-linear-technology/LT3045IMPSE-PBF/5992612)

| Spec | Value |
|---|---|
| input_range | 2.0-20V |
| output | Adjustable to 5V |
| output_current | 500 mA |
| noise | 0.8 µV RMS |
| psrr | 79 dB @ 1 MHz |
| package | 12-lead MSOP |
| operating_temp | -55 to +125°C (MP grade) |

**Alternatives:**
- **[LT3042](https://www.analog.com/en/search.html#q=LT3042)** (Analog Devices): 200 mA output, lower noise (0.8 µV RMS)

**Selection Rationale:** Ultra-low noise LDO provides clean +5V supply to LNA and VGA stages, minimizing phase noise degradation. Military temperature grade available.

### 8. RF Input Connector (18 GHz)

**Primary Choice:** [142-0701-801](https://www.cinchsolutions.com/products/johnson/142-0701-801) (Cinch Connectivity Solutions (Johnson))

*SMA PCB jack, 2.92mm (K) interface rated for DC-40 GHz. 50-ohm impedance, low VSWR. Gold-plated contacts.*

[📄 Datasheet](https://www.cinchsolutions.com/products/johnson/142-0701-801)

| Spec | Value |
|---|---|
| frequency_range | DC-40 GHz |
| impedance | 50 ohms |
| vswr | <1.3:1 @ 18 GHz |
| mounting | PCB edge launch |
| contact_finish | Gold over nickel |
| operating_temp | -65 to +165°C |

**Alternatives:**
- **[0734126010](https://www.google.com/search?q=0734126010+datasheet)** (Molex): SMA 2.4mm compatible, DC-27 GHz

**Selection Rationale:** 2.92mm (K) connector exceeds 18 GHz requirement with margin. SMA-compatible simplifies system integration. Gold plating ensures reliability in harsh environments.

### 9. DC Block Capacitor Array

**Primary Choice:** [1111-300K1-102](https://www.google.com/search?q=1111-300K1-102+datasheet) (AVX)

*DC blocking capacitor, 100 pF, 0402 size, C0G (NP0) dielectric. Low loss at RF frequencies. 50V rating.*

[📄 Datasheet](https://www.google.com/search?q=1111-300K1-102+datasheet)

| Spec | Value |
|---|---|
| capacitance | 100 pF |
| dielectric | C0G (NP0) |
| voltage_rating | 50V DC |
| esr | Low |
| package | 0402 |
| operating_temp | -55 to +125°C |

**Alternatives:**
- **[GQM1555C1H101JB01](https://www.murata.com/en-us/products/productdetail?partno=GQM1555C1H101JB01)** (Murata): Similar specs, 100 pF C0G

**Selection Rationale:** C0G dielectric provides stable capacitance and low loss across wide temperature and frequency ranges. Protects LNA from DC faults.
