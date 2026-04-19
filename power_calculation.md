# Power Calculation
## gvng

**Date:** 19-04-2026

> All values in Watts (W). TYP = typical operating power, MAX = worst-case (130% of TYP).
> Rail assignment is based on component operating voltage from BOM.

## Power Budget — 5 V & 3.3 V Rails

| SI | Description | Part No | Qty | Current (mA) | 5V TYP (W) | 5V MAX (W) | 3.3V TYP (W) | 3.3V MAX (W) | Total TYP (W) | Total MAX (W) |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | 8:1 RF Switch | PE8135 | 1 | — | — | — | — | — | — | — |
| 2 | GaN HEMT LNA | CGH40010F | 1 | 80 | 0.4 | 0.52 | — | — | 0.4 | 0.52 |
| 3 | Ceramic Pre-select Filter | BPFB-0600-5100+ | 1 | — | — | — | — | — | — | — |
| 4 | RF Limiter | MADL-011019 | 1 | — | — | — | — | — | — | — |
| 5 | Input Matching Network | LC Matching Network | 1 | — | — | — | — | — | — | — |
| 6 | Output Matching Network | LC Matching Network | 1 | — | — | — | — | — | — | — |
| 7 | SMP Connector | 141-0711-801 | 1 | — | — | — | — | — | — | — |
| 8 | Active Bias Circuit | LMH6401 | 1 | — | — | — | — | — | — | — |
| | **TOTALS** | |  | **0.4** | **0.52** | **0.0** | **0.0** | **0.4** | **0.52** |

---

## Power Summary

| Rail | Typical Power (W) | Max Power (W) |
|------|-------------------|---------------|
| 5V | 0.4 | 0.52 |
| 3.3V | 0.0 | 0.0 |
| 2.5V | 0.0 | 0.0 |
| 1.8V | 0.0 | 0.0 |
| **TOTAL** | **0.4** | **0.52** |

> Note: Power values are estimated from component datasheets and design parameters.
> Actual measurements should be taken during hardware bring-up and updated in this table.

## Power Converters & LDOs — Dissipation and Thermal Analysis

> Each regulator's dissipation is P_diss = (V_in − V_out) × I_out for linear LDOs (no switching efficiency applies), or P_out × (1 − η)/η for switching converters. Junction-temperature rise uses the datasheet θ_jc (junction-to-case) and θ_ja (junction-to-ambient) at T_ambient = 85 °C (worst-case avionics chamber). Thermal verdict: **Pass** if T_j < 125 °C, **Thermally Failed** otherwise.

| SI | Part No | Topology | V_in (V) | V_out (V) | I_out (A) | η | P_diss (W) | θ_jc (°C/W) | θ_ja (°C/W) | T_j @ 85°C amb (°C) | Heatsink? | Verdict |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | LMR36506 | Regulator | 12 | 36 | 0.080 | 90% | 0.320 | 10 | 50 | 101.0 | no | **Pass** |

**Overall thermal verdict:** ✅ **Pass** — every regulator junction stays below 125 °C at 85 °C ambient.