# System Architecture
## kgo

```mermaid
flowchart TD
    subgraph RF_Front_End["RF Front-End (5-18 GHz)"]
        SMA_IN["SMA Connector<br/>Input: 5-18 GHz<br/>-60 to -10 dBm"] -->|RF Signal| PROT["Input Protection<br/>Limiter/ESD"]
        PROT --> LNA1["LNA Stage 1<br/>+20 dB Gain<br/>NF 3.5 dB"]
        LNA1 --> VGA1["Digital VGA<br/>-10 to +20 dB<br/>Step 1 dB"]
        VGA1 --> BPF1["Bandpass Filter<br/>5-18 GHz<br/>2-3 dB Insertion Loss"]
    end
    
    subgraph Downconvert["Downconversion Stage"]
        BPF1 -->|RF| MIX1["Mixer<br/>High IP3"]
        LO_GEN["LO Synthesizer<br/>PLL/VCO"] -->|LO| MIX1
        MIX1 -->|IF| IF_AMP["IF Amp/Filter<br/>Match to ADC"]
    end
    
    subgraph Digitization["Digitization Stage"]
        IF_AMP -->|Analog| ADC1["ADC 12-bit<br/>1-10 GSPS<br/>LVDS Output"]
        CLK_GEN["Clock Gen<br/>Low Jitter"] -->|Sample Clock| ADC1
    end
    
    subgraph Digital_IO["Digital Output"]
        ADC1 -->|LVDS Pairs| BUF["LVDS Buffers<br/>Align/Retiming"]
        BUF -->|Data| CPCI_J1["CompactPCI J1<br/>Bus Interface"]
    end
    
    subgraph Power["Power Distribution"]
        PWR_IN["+5V, +3.3V, +12V<br/>from Backplane"] --> DCDC["DC-DC Converters<br/>Isolated/Regulated"]
        DCDC -->|Rails| PWR_DIST["Power Distribution<br/>Filtering/Protection"]
        PWR_DIST -->|+5V, +3.3V<br/>+1.2V, +2.5V| RF_Front_End
        PWR_DIST -->|+1.0V Core<br/>+1.8V IO| Digitization
    end
    
    subgraph Control["Control & Monitor"]
        MCU_CTRL["Control Logic<br/>FPGA/CPLD"] -->|SPI| VGA1
        MCU_CTRL -->|SPI| LO_GEN
        MCU_CTRL -->|SPI| ADC1
        CPCI_J1 -->|Config Cmds| MCU_CTRL
        MCU_CTRL -->|Status| CPCI_J1
    end
    
    class Domains RF_Front_End Downconvert Digitization
```
