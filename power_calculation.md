# Power Calculation
## rx band

**Date:** 26-04-2026

> All values in Watts (W). TYP = typical operating power, MAX = worst-case (130% of TYP).
> Rail assignment is based on component operating voltage from BOM.

## Per-Stage DC Bias (from GLB stage datasheet conditions)

| # | Stage | Component | Vdd (V) | Idq (mA) | Pdc (mW) | Datasheet Condition |
|---|-------|-----------|--------:|---------:|---------:|---------------------|
| 1 | RF Input (Antenna) | 2.92mm K-type Connector | — | — | — |  |
| 2 | Limiter | Schottky Diode Limiter | — | — | — |  |
| 3 | RF Preselector | Tunable YIG BPF | — | — | — |  |
| 4 | Bias-Tee | PE1604 Bias-T | — | — | — |  |
| 5 | LNA1 | ZVA-183WA-S+ | 5.00 | 180.0 | 900.0 | Typ @ Vdd=5V, f=12 GHz, T=25C |
| 6 | RF1 Mixer | CMD180C3 | — | — | — |  |
| 7 | IF1 Bandpass Filter | LC/Cavity BPF 4 GHz | — | — | — |  |
| 8 | IF1 Gain Block | PMA2-123LNW+ | 5.00 | 90.0 | 450.0 | Typ @ Vdd=5V, f=4 GHz, T=25C |
| 9 | Stabilisation BPF | LC/Cavity BPF 4 GHz | — | — | — |  |
| 10 | RF2 Mixer (IQ) | MMIQ-0205HSM-2 | — | — | — |  |
| 11 | IF2 Bandpass Filter | LC/Cavity BPF 500 MHz | — | — | — |  |
| 12 | VGA/AGC | TGL2767-SMEVB | — | — | — |  |
| 13 | ADC Driver Output Stage | AD8366 DVGA | 5.00 | 120.0 | 600.0 | Typ @ Vdd=5V, f=500 MHz |
| **TOTAL** | | | | | **1950.0** | Sum of all powered-stage Pdc |

> **Key consistency rule:** the Vdd and Idq above must be the exact bias conditions under which the datasheet specifies the gain, NF, P1dB, and OIP3 values in the GLB stage-by-stage table. Different bias ⇒ different RF performance. The per-stage Pdc (mW) rolls up into the per-rail budget below.

## Power Budget — 5 V & 3.3 V Rails

| SI | Description | Part No | Qty | Current (mA) | 5V TYP (W) | 5V MAX (W) | 3.3V TYP (W) | 3.3V MAX (W) | Total TYP (W) | Total MAX (W) |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | RF LNA — first-stage amplifier at the antenna input for each of the 4 channels (GaN technology preferred) | ZVA-183WA-S+ | 1 | — | — | — | — | — | — | — |
| 2 | RF1 Mixer — first downconverter from RF (18-32 GHz) to IF1 (~4 GHz) for each channel | CMD180C3 | 1 | 50 | 0.25 | 0.325 | — | — | 0.25 | 0.325 |
| 3 | RF2 Mixer — second downconverter from IF1 (~4 GHz) to IF2 (~500 MHz) for each channel | MMIQ-0205HSM-2 | 1 | 50 | 0.25 | 0.325 | — | — | 0.25 | 0.325 |
| 4 | LO1 PLL Synthesizer — generates LO1 for first downconversion (14-36 GHz) | LMX2820RTCT | 1 | 120 | — | — | 0.396 | 0.515 | 0.396 | 0.515 |
| 5 | LO2 PLL Synthesizer — generates LO2 for second downconversion (~3.5 GHz) | ADF4383BCCZ | 1 | 120 | — | — | 0.396 | 0.515 | 0.396 | 0.515 |
| 6 | Reference OCXO — 10 MHz oven-controlled crystal oscillator for LO phase noise floor | KOVTL10MDBFBCB | 1 | — | — | — | — | — | — | — |
| 7 | ADC — 16-bit digitiser for final IF per channel | LTC2107IUK#PBF | 1 | 400 | — | — | — | — | — | — |
| 8 | FPGA — digital signal processing, DDC, pulse compression, coherent integration for all 4 channels | XC7K355T-1FFG901I | 1 | 500 | — | — | — | — | — | — |
| 9 | IF Gain Block — inter-stage amplifier at IF1 (~4 GHz) between the two mixer stages for gain makeup | PMA2-123LNW+ | 1 | 60 | 0.3 | 0.39 | — | — | 0.3 | 0.39 |
| 10 | VGA / AGC — voltage variable attenuator for automatic gain control in the IF chain | TGL2767-SMEVB | 1 | — | — | — | — | — | — | — |
| 11 | 5V LDO Regulator — low-noise 5V supply rail from +15V input for RF amplifiers and mixers | LM2940S-5.0/NOPB | 1 | 50 | 0.25 | 0.325 | — | — | 0.25 | 0.325 |
| 12 | 3.3V LDO Regulator — 3.3V digital supply rail for FPGA bank I/O, PLLs, and ADC digital I/O | MCP1826S-5002E/DBVAO | 1 | 120 | — | — | 0.396 | 0.515 | 0.396 | 0.515 |
| | **TOTALS** | |  | **1.05** | **1.365** | **1.188** | **1.545** | **2.238** | **2.91** |

## Power Budget — 2.5 V & 1.8 V Rails

| SI | Description | Part No | Qty | Current (mA) | 2.5V TYP (W) | 2.5V MAX (W) | 1.8V TYP (W) | 1.8V MAX (W) | Total TYP (W) | Total MAX (W) |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | RF LNA — first-stage amplifier at the antenna input for each of the 4 channels (GaN technology preferred) | ZVA-183WA-S+ | 1 | — | — | — | — | — | — | — |
| 2 | RF1 Mixer — first downconverter from RF (18-32 GHz) to IF1 (~4 GHz) for each channel | CMD180C3 | 1 | 50 | — | — | — | — | — | — |
| 3 | RF2 Mixer — second downconverter from IF1 (~4 GHz) to IF2 (~500 MHz) for each channel | MMIQ-0205HSM-2 | 1 | 50 | — | — | — | — | — | — |
| 4 | LO1 PLL Synthesizer — generates LO1 for first downconversion (14-36 GHz) | LMX2820RTCT | 1 | 120 | — | — | — | — | — | — |
| 5 | LO2 PLL Synthesizer — generates LO2 for second downconversion (~3.5 GHz) | ADF4383BCCZ | 1 | 120 | — | — | — | — | — | — |
| 6 | Reference OCXO — 10 MHz oven-controlled crystal oscillator for LO phase noise floor | KOVTL10MDBFBCB | 1 | — | — | — | — | — | — | — |
| 7 | ADC — 16-bit digitiser for final IF per channel | LTC2107IUK#PBF | 1 | 400 | — | — | 0.72 | 0.936 | 0.72 | 0.936 |
| 8 | FPGA — digital signal processing, DDC, pulse compression, coherent integration for all 4 channels | XC7K355T-1FFG901I | 1 | 500 | — | — | 0.9 | 1.17 | 0.9 | 1.17 |
| 9 | IF Gain Block — inter-stage amplifier at IF1 (~4 GHz) between the two mixer stages for gain makeup | PMA2-123LNW+ | 1 | 60 | — | — | — | — | — | — |
| 10 | VGA / AGC — voltage variable attenuator for automatic gain control in the IF chain | TGL2767-SMEVB | 1 | — | — | — | — | — | — | — |
| 11 | 5V LDO Regulator — low-noise 5V supply rail from +15V input for RF amplifiers and mixers | LM2940S-5.0/NOPB | 1 | 50 | — | — | — | — | — | — |
| 12 | 3.3V LDO Regulator — 3.3V digital supply rail for FPGA bank I/O, PLLs, and ADC digital I/O | MCP1826S-5002E/DBVAO | 1 | 120 | — | — | — | — | — | — |
| | **TOTALS** | |  | **0.0** | **0.0** | **1.62** | **2.106** | **1.62** | **2.106** |

---

## Power Summary

| Rail | Typical Power (W) | Max Power (W) |
|------|-------------------|---------------|
| 5V | 1.05 | 1.365 |
| 3.3V | 1.188 | 1.545 |
| 2.5V | 0.0 | 0.0 |
| 1.8V | 1.62 | 2.106 |
| **TOTAL** | **3.858** | **5.016** |

> Note: Power values are estimated from component datasheets and design parameters.
> Actual measurements should be taken during hardware bring-up and updated in this table.

## Power Converters & LDOs — Dissipation and Thermal Analysis

> Each regulator's dissipation is P_diss = (V_in − V_out) × I_out for linear LDOs (no switching efficiency applies), or P_out × (1 − η)/η for switching converters. Junction-temperature rise uses the datasheet θ_jc (junction-to-case) and θ_ja (junction-to-ambient) at T_ambient = 85 °C (worst-case avionics chamber). Thermal verdict: **Pass** if T_j < 125 °C, **Thermally Failed** otherwise.

| SI | Part No | Topology | V_in (V) | V_out (V) | I_out (A) | η | P_diss (W) | θ_jc (°C/W) | θ_ja (°C/W) | T_j @ 85°C amb (°C) | Heatsink? | Verdict |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | LM2940S-5.0/NOPB | LDO | 15 | 5 | 0.210 | N/A (linear) | 2.100 | 10 | 50 | 127.0 | required (→127.0 °C with HS) | **Thermally Failed** |
| 2 | MCP1826S-5002E/DBVAO | LDO | 15 | 3.3 | 0.360 | N/A (linear) | 4.212 | 10 | 50 | 169.2 | required (→169.2 °C with HS) | **Thermally Failed** |

**Overall thermal verdict:** ❌ **Thermally Failed** — at least one regulator exceeds the 125 °C junction limit. Add a heatsink / copper pour, or move to a lower-dropout switcher or a higher-power package.