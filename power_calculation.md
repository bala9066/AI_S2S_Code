# Power Calculation
## hfuf

**Date:** 22-04-2026

> All values in Watts (W). TYP = typical operating power, MAX = worst-case (130% of TYP).
> Rail assignment is based on component operating voltage from BOM.

## Per-Stage DC Bias (from GLB stage datasheet conditions)

| # | Stage | Component | Vdd (V) | Idq (mA) | Pdc (mW) | Datasheet Condition |
|---|-------|-----------|--------:|---------:|---------:|---------------------|
| 1 | Input Connector (2.92mm) | 2.92mm SMA-K connector | — | — | — |  |
| 2 | Input Limiter | SKY16602-632LF | — | — | — |  |
| 3 | Preselector BPF | BFHK-5001+ (custom LC 2-6 GHz) | — | — | — |  |
| 4 | Bias-T | PE1604 | — | — | — |  |
| 5 | LNA Stage 1 | LVA-273PN+ | 5.00 | 75.0 | 375.0 | Vdd=5V, Id=75 mA, f=4 GHz, T=25C |
| 6 | LNA Stage 2 | LVA-273PN+ | 5.00 | 75.0 | 375.0 | Vdd=5V, Id=75 mA, f=4 GHz, T=25C |
| 7 | LNA Stage 3 | LVA-273PN+ | 5.00 | 75.0 | 375.0 | Vdd=5V, Id=75 mA, f=4 GHz, T=25C |
| 8 | LNA Stage 4 | LVA-273PN+ | 5.00 | 75.0 | 375.0 | Vdd=5V, Id=75 mA, f=4 GHz, T=25C |
| 9 | Output Connector | 2.92mm SMA-K connector | — | — | — |  |
| **TOTAL** | | | | | **1500.0** | Sum of all powered-stage Pdc |

> **Key consistency rule:** the Vdd and Idq above must be the exact bias conditions under which the datasheet specifies the gain, NF, P1dB, and OIP3 values in the GLB stage-by-stage table. Different bias ⇒ different RF performance. The per-stage Pdc (mW) rolls up into the per-rail budget below.

## Power Budget — 5 V & 3.3 V Rails

| SI | Description | Part No | Qty | Current (mA) | 5V TYP (W) | 5V MAX (W) | 3.3V TYP (W) | 3.3V MAX (W) | Total TYP (W) | Total MAX (W) |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | Input Limiter Protection (per channel) | SKY16602-632LF | 1 | — | — | — | — | — | — | — |
| 2 | LC Preselector Bandpass Filter (per channel) | Mini-Circuits BFHK-5001+ | 1 | — | — | — | — | — | — | — |
| 3 | RF Bias Tee (per LNA) | PE1604 | 1 | 20 | 0.1 | 0.13 | — | — | 0.1 | 0.13 |
| 4 | GaN/GaAs LNA Stage (per channel, 3 cascaded) | LVA-273PN+ | 1 | 80 | 0.4 | 0.52 | — | — | 0.4 | 0.52 |
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
| 1 | TPS62136RGXR | Buck | 12 | 5 | 0.100 | 90% | 0.056 | 6 | 30 | 86.7 | no | **Pass** |
| 2 | MIC5209-3.3YM | LDO | 12 | 3.3 | 0.500 | N/A (linear) | 4.350 | 15 | 80 | 193.8 | required (→193.8 °C with HS) | **Thermally Failed** |

**Overall thermal verdict:** ❌ **Thermally Failed** — at least one regulator exceeds the 125 °C junction limit. Add a heatsink / copper pour, or move to a lower-dropout switcher or a higher-power package.