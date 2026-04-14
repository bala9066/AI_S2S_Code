# System Block Diagram
## rbhjdaz

```mermaid
graph TD
    RF_IN[RF Input 5-18GHz] --> LIMITER[Input Limiter]
    LIMITER --> BPF[Bandpass Filter]
    BPF --> LNA[Wideband LNA]
    LNA --> VGA1[Variable Gain Amp 1]
    VGA1 --> FILTER_BANK[Selectable Band Filters]
    FILTER_BANK --> MIXER[Mixer Downconverter]
    LO_SYNTH[LO Synthesizer 5-18GHz] --> MIXER
    MIXER --> IF_AMP[IF Amplifier]
    IF_AMP --> VGA2[Variable Gain Amp 2]
    VGA2 --> IF_FILTER[IF Filter]
    IF_FILTER --> ADC[12-bit ADC 3GSPS]
    ADC --> FPGA_IF[FPGA Interface LVDS/JESD204]
    CTRL[MCU Controller] --> SPI_CFG[SPI Config Bus]
    CTRL --> LO_SYNTH
    CTRL --> VGA1
    CTRL --> VGA2
    CTRL --> ADC
    CTRL --> BIST[BIST Monitor]
    PSU [+28V Input] --> DC_DC[DC-DC Converter]
    DC_DC --> RAIL_12V[+12V Rail]
    DC_DC --> RAIL_5V[+5V Rail]
    DC_DC --> RAIL_3V3[+3.3V Rail]
    DC_DC --> RAIL_1V8[+1.8V Rail]
    REF_CLK[10MHz Ref In] --> LO_SYNTH
```
