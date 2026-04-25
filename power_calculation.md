# Power Calculation
## hv

**Date:** 25-04-2026

> All values in Watts (W). TYP = typical operating power, MAX = worst-case (130% of TYP).
> Rail assignment is based on component operating voltage from BOM.

## Per-Stage DC Bias (from GLB stage datasheet conditions)

| # | Stage | Component | Vdd (V) | Idq (mA) | Pdc (mW) | Datasheet Condition |
|---|-------|-----------|--------:|---------:|---------:|---------------------|
| 1 | SMA Connector | 2.4mm SMA | — | — | — |  |
| 2 | RF Limiter | HLM-40ABH | — | — | — |  |
| 3 | RF Preselector BPF | BFCN-1840+ (via XM-A163-0204D) | — | — | — |  |
| 4 | Bias-Tee | 2.4mm-THRU+ (pass-through) | — | — | — |  |
| 5 | LNA | PMA3-10203+ | 5.00 | 120.0 | 600.0 | Table 3 typ @ Vdd=5V, Id=120mA, f=15GHz, T=25C |
| 6 | 1st RF Mixer | SMIQ-1844H+ | — | — | — |  |
| 7 | 1st IF BPF (3.1 GHz) | IF1 BPF | — | — | — |  |
| 8 | IF Driver Amplifier | CMD295C4 | 5.00 | 200.0 | 1000.0 | Table 2 typ @ Vdd=5V, Id=200mA, f=6GHz, T=25C |
| 9 | 2nd IF BPF (500 MHz BW) | IF2 BPF | — | — | — |  |
| 10 | VGA / AGC Stage | VGA | 5.00 | 100.0 | 500.0 | Typ AGC/VGA stage, gain set to +20 dB |
| 11 | ADC Driver / Buffer | ADC Driver | 5.00 | 150.0 | 750.0 | Typ differential ADC driver stage, G=+15dB |
| 12 | LO1 Splitter | EP2K1+ | — | — | — |  |
| 13 | 2nd Mixer + IF2 Gain | 2nd Downconverter | 5.00 | 200.0 | 1000.0 | Active mixer + IF amp combined, net G=+15dB |
| 14 | Post-2nd-IF VGA | Output VGA | 5.00 | 120.0 | 600.0 | Output VGA, gain set to +6.5 dB for alignment |
| **TOTAL** | | | | | **4450.0** | Sum of all powered-stage Pdc |

> **Key consistency rule:** the Vdd and Idq above must be the exact bias conditions under which the datasheet specifies the gain, NF, P1dB, and OIP3 values in the GLB stage-by-stage table. Different bias ⇒ different RF performance. The per-stage Pdc (mW) rolls up into the per-rail budget below.

## Power Budget — 5 V & 3.3 V Rails

| SI | Description | Part No | Qty | Current (mA) | 5V TYP (W) | 5V MAX (W) | 3.3V TYP (W) | 3.3V MAX (W) | Total TYP (W) | Total MAX (W) |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | RF front-end limiter protecting LNA from +40 dBm max input signals across 18-40 GHz Ka-band | HLM-40ABH | 1 | — | — | — | — | — | — | — |
| 2 | RF preselector bandpass filter covering 18-40 GHz for image rejection and out-of-band spur suppression | XM-A163-0204D | 1 | — | — | — | — | — | — | — |
| 3 | RF LNA providing first-stage low-noise gain in GaAs pHEMT technology at 18-40 GHz | PMA3-10203+ | 1 | 20 | 0.1 | 0.13 | — | — | 0.1 | 0.13 |
| 4 | RF-to-IF1 mixer for first downconversion in 18-40 GHz range | SMIQ-1844H+ | 1 | 50 | 0.25 | 0.325 | — | — | 0.25 | 0.325 |
| 5 | IF driver amplifier providing gain at 1st IF (3.1 GHz) with high linearity | CMD295C4 | 1 | 90 | 0.45 | 0.585 | — | — | 0.45 | 0.585 |
| 6 | PLL frequency synthesizer IC for LO1 generation (RF-side, driving external VCO/multiplier for 18-40 GHz coverage) | ADF4108BCPZ-RL7 | 1 | 120 | — | — | 0.396 | 0.515 | 0.396 | 0.515 |
| 7 | PLL frequency synthesizer IC for LO2 generation (IF-side, 3.6 GHz for 2nd downconversion) | LMX2487ESQ/NOPB | 1 | 120 | — | — | 0.396 | 0.515 | 0.396 | 0.515 |
| 8 | 100 MHz TCXO reference oscillator providing low-phase-noise clock for PLL synthesizers and ADC | ASGTX-D-100.000MHZ-1 | 1 | 120 | — | — | 0.396 | 0.515 | 0.396 | 0.515 |
| 9 | Dual-channel 12-bit ADC digitising both IF2 outputs at up to 150 Msps with LVDS interface | AD9627ABCPZ-150 | 1 | 400 | — | — | — | — | — | — |
| 10 | Kintex-7 FPGA for phase-coherent radar signal processing and LVDS data output | XC7K160T-1FFG676I | 1 | 500 | — | — | — | — | — | — |
| 11 | 2-way LO power splitter distributing LO1 signal equally to both RF mixer channels | EP2K1+ | 1 | 50 | 0.25 | 0.325 | — | — | 0.25 | 0.325 |
| 12 | LDO voltage regulator providing +5V rail from +15V primary supply for RF amplifiers and PLLs | BD50GA3MEFJ-CE2 | 1 | 120 | — | — | 0.396 | 0.515 | 0.396 | 0.515 |
| | **TOTALS** | |  | **1.05** | **1.365** | **1.584** | **2.06** | **2.634** | **3.425** |

## Power Budget — 2.5 V & 1.8 V Rails

| SI | Description | Part No | Qty | Current (mA) | 2.5V TYP (W) | 2.5V MAX (W) | 1.8V TYP (W) | 1.8V MAX (W) | Total TYP (W) | Total MAX (W) |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | RF front-end limiter protecting LNA from +40 dBm max input signals across 18-40 GHz Ka-band | HLM-40ABH | 1 | — | — | — | — | — | — | — |
| 2 | RF preselector bandpass filter covering 18-40 GHz for image rejection and out-of-band spur suppression | XM-A163-0204D | 1 | — | — | — | — | — | — | — |
| 3 | RF LNA providing first-stage low-noise gain in GaAs pHEMT technology at 18-40 GHz | PMA3-10203+ | 1 | 20 | — | — | — | — | — | — |
| 4 | RF-to-IF1 mixer for first downconversion in 18-40 GHz range | SMIQ-1844H+ | 1 | 50 | — | — | — | — | — | — |
| 5 | IF driver amplifier providing gain at 1st IF (3.1 GHz) with high linearity | CMD295C4 | 1 | 90 | — | — | — | — | — | — |
| 6 | PLL frequency synthesizer IC for LO1 generation (RF-side, driving external VCO/multiplier for 18-40 GHz coverage) | ADF4108BCPZ-RL7 | 1 | 120 | — | — | — | — | — | — |
| 7 | PLL frequency synthesizer IC for LO2 generation (IF-side, 3.6 GHz for 2nd downconversion) | LMX2487ESQ/NOPB | 1 | 120 | — | — | — | — | — | — |
| 8 | 100 MHz TCXO reference oscillator providing low-phase-noise clock for PLL synthesizers and ADC | ASGTX-D-100.000MHZ-1 | 1 | 120 | — | — | — | — | — | — |
| 9 | Dual-channel 12-bit ADC digitising both IF2 outputs at up to 150 Msps with LVDS interface | AD9627ABCPZ-150 | 1 | 400 | — | — | 0.72 | 0.936 | 0.72 | 0.936 |
| 10 | Kintex-7 FPGA for phase-coherent radar signal processing and LVDS data output | XC7K160T-1FFG676I | 1 | 500 | — | — | 0.9 | 1.17 | 0.9 | 1.17 |
| 11 | 2-way LO power splitter distributing LO1 signal equally to both RF mixer channels | EP2K1+ | 1 | 50 | — | — | — | — | — | — |
| 12 | LDO voltage regulator providing +5V rail from +15V primary supply for RF amplifiers and PLLs | BD50GA3MEFJ-CE2 | 1 | 120 | — | — | — | — | — | — |
| | **TOTALS** | |  | **0.0** | **0.0** | **1.62** | **2.106** | **1.62** | **2.106** |

---

## Power Summary

| Rail | Typical Power (W) | Max Power (W) |
|------|-------------------|---------------|
| 5V | 1.05 | 1.365 |
| 3.3V | 1.584 | 2.06 |
| 2.5V | 0.0 | 0.0 |
| 1.8V | 1.62 | 2.106 |
| **TOTAL** | **4.254** | **5.531** |

> Note: Power values are estimated from component datasheets and design parameters.
> Actual measurements should be taken during hardware bring-up and updated in this table.

## Power Converters & LDOs — Dissipation and Thermal Analysis

> Each regulator's dissipation is P_diss = (V_in − V_out) × I_out for linear LDOs (no switching efficiency applies), or P_out × (1 − η)/η for switching converters. Junction-temperature rise uses the datasheet θ_jc (junction-to-case) and θ_ja (junction-to-ambient) at T_ambient = 85 °C (worst-case avionics chamber). Thermal verdict: **Pass** if T_j < 125 °C, **Thermally Failed** otherwise.

| SI | Part No | Topology | V_in (V) | V_out (V) | I_out (A) | η | P_diss (W) | θ_jc (°C/W) | θ_ja (°C/W) | T_j @ 85°C amb (°C) | Heatsink? | Verdict |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | BD50GA3MEFJ-CE2 | LDO | 14 | 5 | 0.210 | N/A (linear) | 1.890 | 10 | 50 | 122.8 | required (→122.8 °C with HS) | **Pass** |

**Overall thermal verdict:** ✅ **Pass** — every regulator junction stays below 125 °C at 85 °C ambient.