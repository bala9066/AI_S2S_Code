# System Block Diagram
## rbfgf

```mermaid
flowchart TD
    RF_IN["RF Input 5-18GHz"] --> LIMITER["Input Limiter"]
    LIMITER --> LNA["Wideband LNA"]
    LNA --> BPF1["Bandpass Filter"]
    BPF1 --> MIXER["Mixer Downconverter"]
    MIXER <-- LO_SYNTH["LO Synthesizer 5-18GHz"]
    MIXER --> IF_AMP["IF Amplifier"]
    IF_AMP --> VGA["Variable Gain Amp"]
    VGA --> BPF2["IF Bandpass Filter"]
    BPF2 --> ADC["Dual ADC"]
    ADC --> FPGA["FPGA Digital Processing"]
    FPGA --> LVDS_OUT["LVDS Data Output"]
    LVDS_OUT --> DSP["External DSP"]
    
    FPGA <-- CTRL["Control Interface SPI I2C"]
    PWR["Power Supply +28V"] --> DC_DC["DC-DC Converters"]
    DC_DC --> REG["LDO Regulators"]
    REG --> LNA
    REG --> MIXER
    REG --> LO_SYNTH
    REG --> ADC
    REG --> FPGA
```
