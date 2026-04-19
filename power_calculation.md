# Power Calculation
## hh

**Date:** 19-04-2026

> All values in Watts (W). TYP = typical operating power, MAX = worst-case (130% of TYP).
> Rail assignment is based on component operating voltage from BOM.

## Power Budget — 5 V & 3.3 V Rails

| SI | Description | Part No | Qty | Current (mA) | 5V TYP (W) | 5V MAX (W) | 3.3V TYP (W) | 3.3V MAX (W) | Total TYP (W) | Total MAX (W) |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | Limiter | MADL-011017 | 1 | — | — | — | — | — | — | — |
| 2 | Preselector BPF | SAW-2400-6000 | 1 | — | — | — | — | — | — | — |
| 3 | Bias-T | BTL-1-6-G-S+ | 1 | — | — | — | — | — | — | — |
| 4 | LNA | HMC8411 | 1 | 80 | 0.4 | 0.52 | — | — | 0.4 | 0.52 |
| 5 | 1:4 Power Splitter | PSA4-5043+ | 1 | — | — | — | — | — | — | — |
| 6 | Channel Filter BPF | BLF-254+ | 1 | — | — | — | — | — | — | — |
| 7 | LNA Bias Voltage Regulator | TPS7A47 | 1 | 20 | 0.1 | 0.13 | — | — | 0.1 | 0.13 |
| 8 | Limiter Power Supply | LM5175 | 1 | — | — | — | — | — | — | — |
| | **TOTALS** | |  | **0.5** | **0.65** | **0.0** | **0.0** | **0.5** | **0.65** |

---

## Power Summary

| Rail | Typical Power (W) | Max Power (W) |
|------|-------------------|---------------|
| 5V | 0.5 | 0.65 |
| 3.3V | 0.0 | 0.0 |
| 2.5V | 0.0 | 0.0 |
| 1.8V | 0.0 | 0.0 |
| **TOTAL** | **0.5** | **0.65** |

> Note: Power values are estimated from component datasheets and design parameters.
> Actual measurements should be taken during hardware bring-up and updated in this table.

## Power Converters & LDOs — Dissipation and Thermal Analysis

> Each regulator's dissipation is P_diss = (V_in − V_out) × I_out for linear LDOs (no switching efficiency applies), or P_out × (1 − η)/η for switching converters. Junction-temperature rise uses the datasheet θ_jc (junction-to-case) and θ_ja (junction-to-ambient) at T_ambient = 85 °C (worst-case avionics chamber). Thermal verdict: **Pass** if T_j < 125 °C, **Thermally Failed** otherwise.

| SI | Part No | Topology | V_in (V) | V_out (V) | I_out (A) | η | P_diss (W) | θ_jc (°C/W) | θ_ja (°C/W) | T_j @ 85°C amb (°C) | Heatsink? | Verdict |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | TPS7A47 | Regulator | 12 | 3.3 | 0.100 | 90% | 0.037 | 10 | 50 | 86.8 | no | **Pass** |

**Overall thermal verdict:** ✅ **Pass** — every regulator junction stays below 125 °C at 85 °C ambient.