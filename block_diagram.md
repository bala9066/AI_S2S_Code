# System Block Diagram
## rx module

```mermaid
flowchart TD
    RF_IN["RF Input 5-18 GHz"] -->|50 Ohm SMA| BPF1[Bandpass Filter 5-18 GHz]
    BPF1 --> LNA[LNA Wideband 5-18 GHz]
    LNA --> VGA[Variable Gain Amplifier]
    VGA --> MIXER[Mixer Downconverter]
    LO["LO Input"] -->|Local Oscillator| MIXER
    MIXER --> IF_AMP[IF Amplifier]
    IF_AMP --> IQ_DEMOD[IQ Demodulator]
    IQ_DEMOD --> ADC[Dual ADC]
    ADC --> FPGA[FPGA Signal Processing]
    FPGA -->|I/Q Data| LVDS_OUT[LVDS Output Driver]
    LVDS_OUT -->["LVDS I/Q Outputs"]
    PWR["12V DC Input"] --> DC_DC[DC-DC Converters]
    DC_DC -->|Regulated Rails| LNA
    DC_DC --> VGA
    DC_DC --> MIXER
    DC_DC --> IQ_DEMOD
    DC_DC --> ADC
    DC_DC --> FPGA
```
