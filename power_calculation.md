# Power Calculation
## yhh

**Date:** 24-04-2026

> All values in Watts (W). TYP = typical operating power, MAX = worst-case (130% of TYP).
> Rail assignment is based on component operating voltage from BOM.

## Per-Stage DC Bias (from GLB stage datasheet conditions)

| # | Stage | Component | Vdd (V) | Idq (mA) | Pdc (mW) | Datasheet Condition |
|---|-------|-----------|--------:|---------:|---------:|---------------------|
| 1 | N-type Connector + Cable | N-type IP67 | — | — | — |  |
| 2 | T/R Switch (QPC2420SR) | QPC2420SR | — | — | — |  |
| 3 | PIN Diode Limiter (CLA4611-085LF) | CLA4611-085LF | — | — | — |  |
| 4 | Preselector BPF (BFCN-1840+) | BFCN-1840+ | — | — | — |  |
| 5 | Input 3dB/90 Hybrid (PCB Wilkinson) | PCB Lange Coupler | — | — | — |  |
| 6 | Balanced LNA Pair (2x PMA4-6263LN+) | PMA4-6263LN+ | 5.00 | 100.0 | 500.0 | Table typ @ Vdd=5V, Id=100 mA, f=18 GHz, T=25 C |
| 7 | Output 3dB/90 Hybrid (PCB Wilkinson) | PCB Lange Coupler | — | — | — |  |
| 8 | Gain Block 1 (PMA3-15453+) | PMA3-15453+ | 5.00 | 80.0 | 400.0 | Table typ @ Vdd=5V, f=29 GHz, T=25 C |
| 9 | Interstage BPF (BFCN-1840+) | BFCN-1840+ | — | — | — |  |
| 10 | Driver / Gain Block 2 (PMA3-15453+) | PMA3-15453+ | 5.00 | 80.0 | 400.0 | Table typ @ Vdd=5V, f=29 GHz, T=25 C |
| 11 | Monopulse Combiner (SCA-4-132+) | SCA-4-132+ | — | — | — |  |
| **TOTAL** | | | | | **1300.0** | Sum of all powered-stage Pdc |

> **Key consistency rule:** the Vdd and Idq above must be the exact bias conditions under which the datasheet specifies the gain, NF, P1dB, and OIP3 values in the GLB stage-by-stage table. Different bias ⇒ different RF performance. The per-stage Pdc (mW) rolls up into the per-rail budget below.

## Power Budget — 5 V & 3.3 V Rails

| SI | Description | Part No | Qty | Current (mA) | 5V TYP (W) | 5V MAX (W) | 3.3V TYP (W) | 3.3V MAX (W) | Total TYP (W) | Total MAX (W) |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | Low-noise amplifier per balanced pair arm (2 per channel, 8 total) covering 6-26.5 GHz with high gain and low noise figure | PMA4-6263LN+ | 1 | 20 | 0.1 | 0.13 | — | — | 0.1 | 0.13 |
| 2 | Ka-band gain block / driver amplifier per channel (15-45 GHz), used for stages 2 and 3 after the balanced LNA | PMA3-15453+ | 1 | 20 | 0.1 | 0.13 | — | — | 0.1 | 0.13 |
| 3 | PIN diode limiter for front-end protection (1 per channel, 4 total). Survives +30 dBm, limits output to +15 dBm | CLA4611-085LF | 1 | — | — | — | — | — | — | — |
| 4 | Ceramic preselector bandpass filter between limiter and LNA (1 per channel, 4 total). Also used as interstage BPF for high-gain stability (4 additional) | BFCN-1840+ | 1 | — | — | — | — | — | — | — |
| 5 | T/R protection SPDT switch (1 per channel, 4 total). Isolates front-end during TX pulses, < 10 us switching | QPC2420SR | 1 | — | — | — | — | — | — | — |
| 6 | 4-way power splitter/combiner for monopulse comparator network. Combines 4 channel outputs into Sum and 3 Delta outputs | SCA-4-132+ | 1 | — | — | — | — | — | — | — |
| 7 | DC-DC buck converter from +28V MIL bus to +5V rail for LNA and gain block bias supplies | TPS54531DDA | 1 | 20 | 0.1 | 0.13 | — | — | 0.1 | 0.13 |
| | **TOTALS** | |  | **0.3** | **0.39** | **0.0** | **0.0** | **0.3** | **0.39** |

---

## Power Summary

| Rail | Typical Power (W) | Max Power (W) |
|------|-------------------|---------------|
| 5V | 0.3 | 0.39 |
| 3.3V | 0.0 | 0.0 |
| 2.5V | 0.0 | 0.0 |
| 1.8V | 0.0 | 0.0 |
| **TOTAL** | **0.3** | **0.39** |

> Note: Power values are estimated from component datasheets and design parameters.
> Actual measurements should be taken during hardware bring-up and updated in this table.

## Power Converters & LDOs — Dissipation and Thermal Analysis

> Each regulator's dissipation is P_diss = (V_in − V_out) × I_out for linear LDOs (no switching efficiency applies), or P_out × (1 − η)/η for switching converters. Junction-temperature rise uses the datasheet θ_jc (junction-to-case) and θ_ja (junction-to-ambient) at T_ambient = 85 °C (worst-case avionics chamber). Thermal verdict: **Pass** if T_j < 125 °C, **Thermally Failed** otherwise.

| SI | Part No | Topology | V_in (V) | V_out (V) | I_out (A) | η | P_diss (W) | θ_jc (°C/W) | θ_ja (°C/W) | T_j @ 85°C amb (°C) | Heatsink? | Verdict |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | TPS54531DDA | Buck | 28 | 5 | 0.060 | 90% | 0.033 | 10 | 50 | 86.7 | no | **Pass** |

**Overall thermal verdict:** ✅ **Pass** — every regulator junction stays below 125 °C at 85 °C ambient.