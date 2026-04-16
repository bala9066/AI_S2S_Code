# System Architecture
## rbfgf

```mermaid
flowchart TD
    subgraph RF_FRONT_END["RF Front End -55C to 125C"]
        RFIN["RF Input SMA"] --> LIM["Limiter >20dBm"]
        LIM --> LNA["LNA Gain 20dB NF 2dB"]
        LNA --> FILT["Bandpass Filter"]
    end
    
    subgraph DOWNCONVERT["Downconversion Stage"]
        FILT --> MIX["Mixer -7dB Conversion"]
        MIX <-- LO["PLL Synthesizer"]
        MIX --> IFAMP["IF Amp 15dB"]
    end
    
    subgraph IF_CHAIN["IF Chain 2-5GHz BW"]
        IFAMP --> VGA["VGA 30dB Range"]
        VGA --> IF2["IF Filter"]
        IF2 --> DRV["ADC Driver"]
    end
    
    subgraph DIGITAL["Digital Section"]
        DRV --> ADC["14-bit ADC"]
        ADC --> FPGA["FPGA DSP"]
        FPGA --> LVDS["LVDS Output 80 Pairs"]
    end
    
    subgraph POWER["Power Domain"]
        MAIN["+28V Input"] --> DC["DC-DC"]
        DC --> P3V3["+3.3V Logic"]
        DC --> P5["+5V Analog"]
        DC --> P12["+12V RF"]
    end
    
    P3V3 --> FPGA
    P3V3 --> ADC
    P5 --> IFAMP
    P12 --> LNA
    P12 --> MIX
    P12 --> LO
```
