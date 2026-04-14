# Component Recommendations
## rf txrxxp

### 1. Input Limiter Protection

**Primary Choice:** [Limiter SPDT GVA-123+](https://www.minicircuits.com/pdfs/GVA-123+.pdf) (Mini-Circuits)

*Wideband limiter 0.5-20 GHz, handles 10W peak, 0.5dB insertion loss.*

[📄 Datasheet](https://www.minicircuits.com/pdfs/GVA-123+.pdf)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/mini-circuits/GVA-123/6922017)

| Spec | Value |
|---|---|
| frequency_range | 0.5-20 GHz |
| max_power | 10W peak |
| insertion_loss | 0.5 dB |
| threshold | 15 dBm |

**Selection Rationale:** Protects LNA from high-power radar pulses with minimal impact on noise figure.

### 2. Wideband LNA

**Primary Choice:** [MMIC Amplifier TQP3M9036](https://www.qorvo.com/products/d/qa002374) (Qorvo)

*GaAs pHEMT MMIC amplifier, DC-20 GHz, 20dB gain, 2.5dB noise figure.*

[📄 Datasheet](https://www.qorvo.com/products/d/qa002374)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/qorvo/TQP3M9036/7896292)

| Spec | Value |
|---|---|
| frequency_range | DC-20 GHz |
| gain | 20 dB |
| noise_figure | 2.5 dB |
| p1db_out | 19 dBm |
| oip3 | 29 dBm |
| supply | 5V 120mA |

**Alternatives:**
- **[HMC499](https://www.analog.com/media/en/technical-documentation/data-sheets/hmc499.pdf)** (Analog Devices): Similar gain, slightly higher NF (3dB), higher OIP3 (35dBm)

**Selection Rationale:** Excellent NF and gain across full band. Meets IIP3 requirement and provides most of receiver gain in first stage.

### 3. Variable Gain Amplifier

**Primary Choice:** [HMC698LP4](https://www.analog.com/media/en/technical-documentation/data-sheets/hmc698.pdf) (Analog Devices)

*Digital VGA, 6-18 GHz, 30dB gain range, 4-bit parallel control.*

[📄 Datasheet](https://www.analog.com/media/en/technical-documentation/data-sheets/hmc698.pdf)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/HMC698LP4ETR/11681944)

| Spec | Value |
|---|---|
| frequency_range | 6-18 GHz |
| gain_range | 30 dB |
| gain_step | 2 dB |
| noise_figure | 6 dB |
| p1db | 15 dBm |
| oip3 | 27 dBm |

**Alternatives:**
- **[ADL5240](https://www.analog.com/media/en/technical-documentation/data-sheets/ADL5240.pdf)** (Analog Devices): Lower frequency (DC-6GHz), 31.5dB range, analog control

**Selection Rationale:** Wideband coverage, 30dB digital gain range for AGC, good linearity (27dBm OIP3).

### 4. Mixer / Downconverter

**Primary Choice:** [HMC1050](https://www.analog.com/media/en/technical-documentation/data-sheets/hmc1050.pdf) (Analog Devices)

*Wideband mixer, 6-26 GHz RF/LO, IF to 6 GHz, +17 dBm LO drive.*

[📄 Datasheet](https://www.analog.com/media/en/technical-documentation/data-sheets/hmc1050.pdf)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/HMC1050LP4E/1970502)

| Spec | Value |
|---|---|
| rf_range | 6-26 GHz |
| lo_range | 6-26 GHz |
| if_range | DC-6 GHz |
| conversion_loss | 7.5 dB |
| lo_drive | +17 dBm |
| iip3 | 24 dBm |

**Alternatives:**
- **[MAMX-011027](https://www.macom.com/products/detail/mamx-011027)** (MACOM): Similar performance, slightly higher conversion loss (9dB)

**Selection Rationale:** Covers entire 5-18 GHz band, good linearity (24dBm IIP3), moderate LO drive requirement.

### 5. LO Synthesizer

**Primary Choice:** [ADF5356](https://www.analog.com/media/en/technical-documentation/data-sheets/adf5356.pdf) (Analog Devices)

*Wideband PLL synthesizer with integrated VCO, 53.125 MHz to 13.6 GHz.*

[📄 Datasheet](https://www.analog.com/media/en/technical-documentation/data-sheets/adf5356.pdf)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/ADF5356CCPZ/11483277)

| Spec | Value |
|---|---|
| frequency_range | 53 MHz-13.6 GHz |
| phase_noise | -125 dBc/Hz at 1MHz offset |
| output_power | -5 to +5 dBm |
| supply | 3.3V |

**Alternatives:**
- **[LMX2594](https://www.ti.com/lit/ds/symlink/lmx2594.pdf)** (Texas Instruments): Higher freq (10-20GHz), similar phase noise, dual output

**Selection Rationale:** Covers lower half of band, can be doubled for upper frequencies. Excellent phase noise for radar.

### 6. IF Amplifier

**Primary Choice:** [ADL8000](https://www.analog.com/media/en/technical-documentation/data-sheets/adl8000.pdf) (Analog Devices)

*Variable gain amp, DC to 8 GHz, 24dB gain, analog control.*

[📄 Datasheet](https://www.analog.com/media/en/technical-documentation/data-sheets/adl8000.pdf)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/ADL8000ACPZ-R7/16008518)

| Spec | Value |
|---|---|
| frequency_range | DC-8 GHz |
| max_gain | 24 dB |
| gain_control | 35 dB linear |
| oip3 | 35 dBm |
| noise_figure | 3.5 dB |

**Alternatives:**
- **[HMC698](https://www.analog.com/media/en/technical-documentation/data-sheets/hmc698.pdf)** (Analog Devices): Lower freq range, digital gain control

**Selection Rationale:** Provides IF gain and fine gain control, excellent linearity.

### 7. High-Speed ADC

**Primary Choice:** [ADC12DJ3200](https://www.ti.com/lit/ds/symlink/adc12dj3200.pdf) (Texas Instruments)

*Dual 12-bit 3.2 GSPS or single 6.4 GSPS ADC, JESD204B output.*

[📄 Datasheet](https://www.ti.com/lit/ds/symlink/adc12dj3200.pdf)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/texas-instruments/ADC12DJ3200IRGZT/5893397)

| Spec | Value |
|---|---|
| resolution | 12-bit |
| sampling_rate | 6.4 GSPS (1-ch), 3.2 GSPS (2-ch) |
| sfdr | 65 dBc @ 1 GHz |
| snr | 56 dBFS |
| interface | JESD204B (8 lanes) |

**Alternatives:**
- **[AD9208](https://www.analog.com/media/en/technical-documentation/data-sheets/ad9208.pdf)** (Analog Devices): Single 3.0 GSPS 14-bit, higher resolution, lower sample rate
- **[RM10-2950-2GA689](https://www.teledyne-e2v.com/shared/content/resources/File/documents/radio-frequency-and-broadband-data-conversion/broadband-data-conversion/adc/ev10aq190.pdf)** (Teledyne e2v): 10-bit 2.5 GSPS, industrial temp range

**Selection Rationale:** Well above 1 GSPS requirement (6.4 GSPS in single-channel mode), 12-bit resolution, JESD204B interface.

### 8. Clock Generator / Jitter Cleaner

**Primary Choice:** [LMK04828](https://www.ti.com/lit/ds/symlink/lmk04828.pdf) (Texas Instruments)

*Ultra-low noise clock generator, 8 outputs, dual PLL, JESD204B support.*

[📄 Datasheet](https://www.ti.com/lit/ds/symlink/lmk04828.pdf)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/texas-instruments/LMK04828B-NOPB/5902740)

| Spec | Value |
|---|---|
| phase_noise | -130 dBc/Hz at 1kHz |
| output_freq | Up to 3.125 GHz |
| outputs | 8 differential |
| jitter | 100 fs RMS |

**Alternatives:**
- **[AD9528](https://www.analog.com/media/en/technical-documentation/data-sheets/ad9528.pdf)** (Analog Devices): Similar jitter performance, 14 outputs

**Selection Rationale:** Low jitter critical for ADC SNR at high sample rates. Supports JESD204B subclass 1 SYSREF.

### 9. Power Management

**Primary Choice:** [LTM4644](https://www.analog.com/media/en/technical-documentation/data-sheets/ltm4644.pdf) (Linear Technology/Analog Devices)

*Quad 4A DC/DC buck regulator module, 4-14V input, configurable outputs.*

[📄 Datasheet](https://www.analog.com/media/en/technical-documentation/data-sheets/ltm4644.pdf)  [🛒 DigiKey](https://www.digikey.com/en/products/detail/analog-devices-inc/LTM4644IY-PBF/7013773)

| Spec | Value |
|---|---|
| input_range | 4-14V |
| outputs | 4x 0.8V-3.3V at 4A |
| switching_freq | 1 MHz |
| efficiency | 92% |

**Selection Rationale:** Compact power solution providing multiple rails (+3.3V for digital, +5V for RF, +1V for ADC core) from single +12V input.

### 10. RF Input Connector

**Primary Choice:** [SMA Connector 2.4mm](https://www.te.com/commerce/DocumentDelivery/DDEController?Action=showdoc&DocId=Customer+Drawing%7F2271534%7FE7%7Fpdf%7FEnglish%7FENG_CD_2271534_E7.pdf%7F1-2271534-0) (TE Connectivity / Rosenberger)

*2.4mm SMA jack, 50 ohm, rated to 18 GHz.*

[📄 Datasheet](https://www.te.com/commerce/DocumentDelivery/DDEController?Action=showdoc&DocId=Customer+Drawing%7F2271534%7FE7%7Fpdf%7FEnglish%7FENG_CD_2271534_E7.pdf%7F1-2271534-0)

| Spec | Value |
|---|---|
| frequency | DC-18 GHz |
| vswr | 1.3:1 max |
| impedance | 50 ohm |
| mounting | PCB edge launch |

**Selection Rationale:** Industry standard for microwave applications, meets 18 GHz requirement with low VSWR.
