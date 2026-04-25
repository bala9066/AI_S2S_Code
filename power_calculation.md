# Power Calculation
## hjjg

**Date:** 25-04-2026

> All values in Watts (W). TYP = typical operating power, MAX = worst-case (130% of TYP).
> Rail assignment is based on component operating voltage from BOM.

## Per-Stage DC Bias (from GLB stage datasheet conditions)

| # | Stage | Component | Vdd (V) | Idq (mA) | Pdc (mW) | Datasheet Condition |
|---|-------|-----------|--------:|---------:|---------:|---------------------|
| 1 | Input SMA Connector | SMA-F | — | — | — |  |
| 2 | RF Limiter | PE8022 | — | — | — |  |
| 3 | Preselector BPF | Tunable BPF 2-6 GHz | — | — | — |  |
| 4 | LNA | GRF2074 | 3.30 | 60.0 | 198.0 | Vdd=3.3V, Id=60mA, f=4GHz, T=25C |
| 5 | 1st Mixer (RF to IF1) | MCA1-42+ | 0.00 | 0.0 | 0.0 | Passive mixer - no DC bias |
| 6 | IF1 BPF (1300 MHz) | 1300 MHz IF BPF | — | — | — |  |
| 7 | 2nd Mixer (IF1 to IF2) | RMS-2+ | 0.00 | 0.0 | 0.0 | Passive mixer - no DC bias |
| 8 | IF2 BPF (200 MHz) | 200 MHz IF BPF | — | — | — |  |
| 9 | IF Driver Amplifier | HMC788ALP2E | 5.00 | 90.0 | 450.0 | Vdd=5V, Id=90mA, f=200MHz, T=25C |
| 10 | 2nd IF Driver Amplifier | HMC788ALP2E | 5.00 | 90.0 | 450.0 | Vdd=5V, Id=90mA, f=200MHz, T=25C |
| 11 | Gain Trim Pad | 3 dB Pi-pad | — | — | — |  |
| 12 | Final IF Buffer Amp | GRF2040 | 5.00 | 80.0 | 400.0 | Vdd=5V, Id=80mA, f=200MHz, T=25C |
| 13 | Final Gain Block | HMC788ALP2E | 5.00 | 90.0 | 450.0 | Vdd=5V, Id=90mA, f=200MHz, T=25C |
| **TOTAL** | | | | | **1948.0** | Sum of all powered-stage Pdc |

> **Key consistency rule:** the Vdd and Idq above must be the exact bias conditions under which the datasheet specifies the gain, NF, P1dB, and OIP3 values in the GLB stage-by-stage table. Different bias ⇒ different RF performance. The per-stage Pdc (mW) rolls up into the per-rail budget below.

## Power Budget — 5 V & 3.3 V Rails

| SI | Description | Part No | Qty | Current (mA) | 5V TYP (W) | 5V MAX (W) | 3.3V TYP (W) | 3.3V MAX (W) | Total TYP (W) | Total MAX (W) |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | Front-end protection limiter — protects LNA from high-power RF pulses up to +40 dBm | PE8022 | 1 | — | — | — | — | — | — | — |
| 2 | Low-noise amplifier — first active stage after preselector, sets system noise figure | GRF2074 | 1 | 20 | 0.1 | 0.13 | — | — | 0.1 | 0.13 |
| 3 | 1st downconverter mixer — converts 2-6 GHz RF to 1300 MHz IF1 | MCA1-42+ | 1 | 50 | 0.25 | 0.325 | — | — | 0.25 | 0.325 |
| 4 | 2nd downconverter mixer — converts 1300 MHz IF1 to 200 MHz IF2 | RMS-2+ | 1 | 50 | 0.25 | 0.325 | — | — | 0.25 | 0.325 |
| 5 | IF driver amplifier — provides gain and output drive to ADC in the 2nd IF chain | HMC788ALP2E | 1 | 60 | 0.3 | 0.39 | — | — | 0.3 | 0.39 |
| 6 | Linear gain block / buffer amp — moderate gain stage for IF chain signal conditioning | GRF2040 | 1 | 60 | 0.3 | 0.39 | — | — | 0.3 | 0.39 |
| 7 | Wideband RF power splitter — 2-way LO distribution to both receiver channels | EP2K1+ | 1 | — | — | — | — | — | — | — |
| 8 | PLL frequency synthesizer — generates tunable LO1 (3.3-7.3 GHz) and LO2 (1.1 GHz) from 10 MHz reference | ADF4106BRUZ-RL | 1 | 120 | — | — | 0.396 | 0.515 | 0.396 | 0.515 |
| 9 | VCO for LO1 — generates 4-8 GHz local oscillator signal for 1st downconversion | HMC586LC4BTR | 1 | 120 | — | — | 0.396 | 0.515 | 0.396 | 0.515 |
| 10 | OCXO reference oscillator — provides ultra-stable 10 MHz frequency reference for PLL and system timing | OSJ7014-10.0M | 1 | — | — | — | — | — | — | — |
| 11 | 14-bit dual-channel ADC — digitises both IF2 channels simultaneously with LVDS output | AD9643BCPZ-170 | 1 | 400 | — | — | — | — | — | — |
| 12 | Digital processing FPGA — performs radar DSP, pulse compression, CFAR detection, and LVDS data output | PFP-KX7_PLUS-310LC | 1 | 500 | — | — | — | — | — | — |
| 13 | Low-noise LDO regulator — provides clean supply rails for LNAs, mixers, PLLs, and ADCs | MIC5209-3.3YM | 1 | 20 | 0.1 | 0.13 | — | — | 0.1 | 0.13 |
| | **TOTALS** | |  | **1.3** | **1.69** | **0.792** | **1.03** | **2.092** | **2.72** |

## Power Budget — 2.5 V & 1.8 V Rails

| SI | Description | Part No | Qty | Current (mA) | 2.5V TYP (W) | 2.5V MAX (W) | 1.8V TYP (W) | 1.8V MAX (W) | Total TYP (W) | Total MAX (W) |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | Front-end protection limiter — protects LNA from high-power RF pulses up to +40 dBm | PE8022 | 1 | — | — | — | — | — | — | — |
| 2 | Low-noise amplifier — first active stage after preselector, sets system noise figure | GRF2074 | 1 | 20 | — | — | — | — | — | — |
| 3 | 1st downconverter mixer — converts 2-6 GHz RF to 1300 MHz IF1 | MCA1-42+ | 1 | 50 | — | — | — | — | — | — |
| 4 | 2nd downconverter mixer — converts 1300 MHz IF1 to 200 MHz IF2 | RMS-2+ | 1 | 50 | — | — | — | — | — | — |
| 5 | IF driver amplifier — provides gain and output drive to ADC in the 2nd IF chain | HMC788ALP2E | 1 | 60 | — | — | — | — | — | — |
| 6 | Linear gain block / buffer amp — moderate gain stage for IF chain signal conditioning | GRF2040 | 1 | 60 | — | — | — | — | — | — |
| 7 | Wideband RF power splitter — 2-way LO distribution to both receiver channels | EP2K1+ | 1 | — | — | — | — | — | — | — |
| 8 | PLL frequency synthesizer — generates tunable LO1 (3.3-7.3 GHz) and LO2 (1.1 GHz) from 10 MHz reference | ADF4106BRUZ-RL | 1 | 120 | — | — | — | — | — | — |
| 9 | VCO for LO1 — generates 4-8 GHz local oscillator signal for 1st downconversion | HMC586LC4BTR | 1 | 120 | — | — | — | — | — | — |
| 10 | OCXO reference oscillator — provides ultra-stable 10 MHz frequency reference for PLL and system timing | OSJ7014-10.0M | 1 | — | — | — | — | — | — | — |
| 11 | 14-bit dual-channel ADC — digitises both IF2 channels simultaneously with LVDS output | AD9643BCPZ-170 | 1 | 400 | — | — | 0.72 | 0.936 | 0.72 | 0.936 |
| 12 | Digital processing FPGA — performs radar DSP, pulse compression, CFAR detection, and LVDS data output | PFP-KX7_PLUS-310LC | 1 | 500 | — | — | 0.9 | 1.17 | 0.9 | 1.17 |
| 13 | Low-noise LDO regulator — provides clean supply rails for LNAs, mixers, PLLs, and ADCs | MIC5209-3.3YM | 1 | 20 | — | — | — | — | — | — |
| | **TOTALS** | |  | **0.0** | **0.0** | **1.62** | **2.106** | **1.62** | **2.106** |

---

## Power Summary

| Rail | Typical Power (W) | Max Power (W) |
|------|-------------------|---------------|
| 5V | 1.3 | 1.69 |
| 3.3V | 0.792 | 1.03 |
| 2.5V | 0.0 | 0.0 |
| 1.8V | 1.62 | 2.106 |
| **TOTAL** | **3.712** | **4.826** |

> Note: Power values are estimated from component datasheets and design parameters.
> Actual measurements should be taken during hardware bring-up and updated in this table.

## Power Converters & LDOs — Dissipation and Thermal Analysis

> Each regulator's dissipation is P_diss = (V_in − V_out) × I_out for linear LDOs (no switching efficiency applies), or P_out × (1 − η)/η for switching converters. Junction-temperature rise uses the datasheet θ_jc (junction-to-case) and θ_ja (junction-to-ambient) at T_ambient = 85 °C (worst-case avionics chamber). Thermal verdict: **Pass** if T_j < 125 °C, **Thermally Failed** otherwise.

| SI | Part No | Topology | V_in (V) | V_out (V) | I_out (A) | η | P_diss (W) | θ_jc (°C/W) | θ_ja (°C/W) | T_j @ 85°C amb (°C) | Heatsink? | Verdict |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | MIC5209-3.3YM | LDO | 12 | 3.3 | 0.240 | N/A (linear) | 2.088 | 10 | 50 | 126.8 | required (→126.8 °C with HS) | **Thermally Failed** |

**Overall thermal verdict:** ❌ **Thermally Failed** — at least one regulator exceeds the 125 °C junction limit. Add a heatsink / copper pour, or move to a lower-dropout switcher or a higher-power package.