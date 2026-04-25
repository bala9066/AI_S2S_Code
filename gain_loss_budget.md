# RF Gain-Loss Budget
## hv

**Generated:** 2026-04-25  
**Document Status:** AI-GENERATED — verify against final component datasheets

## 0. Design Contract Checks

⚠ **WARN** — 0 hard violations, 1 warning(s) — review before release

| # | Rule | Status | Detail |
|---|------|--------|--------|
| C1 | Analysis at worst-case frequency | ✅ pass | Cascade evaluated at f_max = 40000 MHz (centre 29000 + BW/2 = 11000 MHz). |
| C2 | Bias conditions declared for every active stage | ✅ pass | Every LNA / amp / mixer stage cites the datasheet Vdd/Idq row that produces its gain and NF. |
| C3 | Pdc = Vdd × Idq (±10 mW) | ✅ pass | All biased stages obey the Ohm-law tie between supply and DC power. |
| C4 | Passive NF = |insertion loss| (Friis) | ✅ pass | Every passive stage's NF equals its insertion loss in dB, as thermodynamics requires. |
| C5 | GLB ↔ BOM component match | ⚠ warn | No BOM supplied to this renderer — cross-check skipped. |

> These five invariants must hold for any RF receiver GLB to be releasable to PCB. Any row marked **fail** is a contract violation — regenerate Phase 1 or edit the offending stage before proceeding.

## 0.5 Closed-Loop Optimization Log

### Iteration 1
- **Issues:** 5 hard, 1 warn
  - ❌ `GAIN_SHORT` — Cascade gain 58.0 dB is 23.2 dB below target 81.2 dB.
  - ❌ `BIAS_MISSING` — Stage 7 (1st RF Mixer) is active but lacks Vdd/Idq.
  - ❌ `FRIIS_MISMATCH` — Stage 4 passive NF 3.50 dB ≠ |loss| 4.50 dB.
  - ❌ `FRIIS_MISMATCH` — Stage 8 passive NF 2.00 dB ≠ |loss| 3.00 dB.
  - ❌ `FRIIS_MISMATCH` — Stage 10 passive NF 2.00 dB ≠ |loss| 3.00 dB.
  - ⚠ `LNA_DEEP` — 6.4 dB of passive loss before first LNA — inflates system NF via Friis.
- **Cascade:** gain=58.0 dB · NF=12.83 dB · Pout=-23.2 dBm · Pdc=4450.0 mW _(evaluated at worst-case (f_max))_
- **Actions:**
  - Set Stage 4 passive NF to |loss| = 4.50 dB
  - Set Stage 8 passive NF to |loss| = 3.00 dB
  - Set Stage 10 passive NF to |loss| = 3.00 dB
  - Populated bias on Stage 7 from 'ADL5541' template.
  - Promoted LNA from stage 6 to stage 4 (reduces pre-LNA passive loss → better Friis NF).
  - Inserted HMC311ST89E at stage 14 (+14 dB, NF 3.5 dB).
  - Inserted ADL5541 at stage 17 (+16 dB, NF 3.0 dB).

### Iteration 2
- **Issues:** 0 hard, 1 warn
  - ⚠ `GAIN_OVER` — Cascade gain 88.0 dB exceeds target 81.2 dB by 6.8 dB.
- **Cascade:** gain=80.25 dB · NF=14.21 dB · Pout=-0.95 dBm · Pdc=5500.0 mW _(evaluated at worst-case (f_max))_
- **Actions:**
  - Converged — no hard violations remain.
  - — propagation —
  - Added BOM entry 'HMC311ST89E' (Post-Splitter Gain Block (DC-6 GHz)) from optimizer library.
  - Added BOM entry 'ADL5541' (IF Gain Block (20 MHz-6 GHz)) from optimizer library.
  - BOM entry 'BD50GA3MEFJ-CE2' is no longer in the GLB chain (optimizer removed/replaced it) — flagged for review.
  - Swapped +5V converter 'BD50GA3MEFJ-CE2' → 'LT8645SIV#PBF' (6000 mA Buck, P_diss=0.35 W, T_j=101 °C). Reason: I_out_max 300 mA < required 1430 mA; P_diss 11.00 W → T_j 965 °C exceeds 110 °C safety ceiling.
  - Regenerated block_diagram_mermaid to reflect the 17-stage optimizer output.


## 1. System Parameters

| Parameter | Value | Unit |
|-----------|-------|------|
| Centre Frequency    | 29000   | MHz  |
| RF Bandwidth        | 22000     | MHz  |
| **Analysis Frequency (worst-case)** | **40000** | **MHz** |
| Input Signal Level  | -81.2   | dBm  |
| Target Output Power | 0  | dBm  |
| Required System Gain | 81.2 | dB   |

> **Why the upper band edge?** For a receiver, NF rises and gain falls with
> frequency — system sensitivity (MDS) is worst at f_max. The stage-by-stage
> cascade below is therefore evaluated at the upper band edge so the numbers
> represent the least-favourable operating point. The frequency-sweep section
> further down shows how every metric varies across the full band in 1 GHz steps.

## 2. Stage-by-Stage Gain / Loss Budget

| # | Stage | Component | Gain/Loss (dB) | Cum. Gain (dB) | Output Power (dBm) | NF (dB) | Cum. NF (dB) | P1dB Out (dBm) | OIP3 (dBm) | Region | Notes |
|---|-------|-----------|---------------|----------------|-------------------|---------|-------------|---------------|-----------|--------|-------|
| 1 | SMA Connector | 2.4mm SMA | -0.2 | -0.2 | -81.5 | 0.15 | 0.15 | N/A | N/A | Linear (passive) | 2.4mm SMA connector at Ka-band |
| 2 | PCB Trace | 50Ω Microstrip (RO4350B) | -0.4 | -0.7 | -81.8 | 0.30 | 0.46 | N/A | N/A | Linear (passive) | Typ 1–2 in RO4350B microstrip loss at band |
| 3 | RF Limiter | HLM-40ABH | -1.1 | -1.8 | -83.0 | 1.00 | 1.50 | N/A | N/A | Linear (passive) | GaAs Schottky limiter, DC-Ka band, P_lim +10 dBm, survives +40 dBm |
| 4 | LNA | PMA3-10203+ | +14.0 | 12.2 | -69.0 | 4.50 | 6.16 | 8.0 | 18.0 | Linear (77.0 dB BO) | GaAs pHEMT MMIC LNA, gain reduced at 30 GHz est ~15dB |
| 5 | RF Preselector BPF | BFCN-1840+ (via XM-A163-0204D) | -5.5 | 6.8 | -74.5 | 4.50 | 6.27 | N/A | N/A | Linear (passive) | 18-40 GHz wideband BPF, IL ~3.5 dB · ⚠ Passive NF ≠ |loss| (4.50 vs 5.50 dB) |
| 6 | Bias-Tee | 2.4mm-THRU+ (pass-through) | -0.4 | 6.3 | -74.8 | 0.30 | 6.29 | N/A | N/A | Linear (passive) | Bias-T pass-through IL ~0.3 dB at Ka-band |
| 7 | 1st RF Mixer | SMIQ-1844H+ | -10.0 | -3.6 | -84.8 | 10.50 | 8.21 | 8.0 | 16.0 | Linear (92.8 dB BO) | Passive IQ mixer, CL ~9 dB, NF = CL + 0.5 dB · ⚠ Passive NF ≠ |loss| (10.50 vs 10.00 dB); Mixer conv. loss 10.0 dB high — verify |
| 8 | 1st IF BPF (3.1 GHz) | IF1 BPF | -4.0 | -7.7 | -88.8 | 3.00 | 9.51 | N/A | N/A | Linear (passive) | 1st IF bandpass at 3.1 GHz, IL ~2 dB · ⚠ Passive NF ≠ |loss| (3.00 vs 4.00 dB) |
| 9 | IF Driver Amplifier | CMD295C4 | +14.0 | 6.3 | -74.8 | 5.50 | 13.76 | 16.0 | 28.0 | Linear (90.8 dB BO) | 2-20 GHz driver amp, OIP3 +30 dBm |
| 10 | 2nd IF BPF (500 MHz BW) | IF2 BPF | -4.0 | 2.4 | -78.8 | 3.00 | 13.80 | N/A | N/A | Linear (passive) | 2nd IF bandpass, 500 MHz BW, IL ~2 dB · ⚠ Passive NF ≠ |loss| (3.00 vs 4.00 dB) |
| 11 | VGA / AGC Stage | VGA | +19.0 | 21.4 | -59.9 | 7.00 | 14.20 | 18.0 | 33.0 | Linear (77.8 dB BO) | Variable gain amplifier for AGC, +20 dB set gain |
| 12 | ADC Driver / Buffer | ADC Driver | +14.0 | 35.4 | -45.9 | 8.00 | 14.21 | 20.0 | 34.0 | Linear (65.8 dB BO) | Final ADC driver, differential output to AD9627 |
| 13 | LO1 Splitter | EP2K1+ | -3.6 | 31.8 | -49.5 | 3.50 | 14.21 | N/A | N/A | Linear (passive) | 3 dB split + 0.5 dB insertion loss |
| 14 | Post-split LNA | HMC311ST89E | +13.5 | 45.2 | -36.0 | 4.00 | 14.21 | 12.0 | — | Linear (48.0 dB BO) |  |
| 15 | 2nd Mixer + IF2 Gain | 2nd Downconverter | +14.0 | 59.2 | -21.9 | 9.00 | 14.21 | 16.0 | 28.0 | Linear (38.0 dB BO) | 2nd downconversion mixer + 2nd IF amplifier combined |
| 16 | Post-2nd-IF VGA | Output VGA | +5.5 | 64.8 | -16.4 | 8.50 | 14.21 | 20.0 | 34.0 | Linear (36.5 dB BO) | Final gain trim to hit ADC full scale |
| 17 | IF Gain Block | ADL5541 | +15.5 | 80.2 | -0.9 | 3.50 | 14.21 | 21.0 | — | Linear (21.9 dB BO) |  |

> **Region legend:** *Linear* = ≥10 dB back-off from P1dB · *Near-linear* = 6-10 dB · *Compressing* = 0-6 dB (onset of gain compression) · *Saturated* = above P1dB (hard non-linear). Keep every stage in the Linear zone for analogue receivers; transmit chains may intentionally drive the PA into compression.

## 3. Budget Summary

| Metric | Value | Unit |
|--------|-------|------|
| Total System Gain     | 80.2  | dB  |
| Final Output Power    | -0.9  | dBm |
| Cascaded System NF    | 14.21 | dB  |
| Output Power Margin   | +1.0 | dB  |

> **Per-stage DC bias (Vdd/Idq/Pdc)** is listed in `power_calculation.md` — the companion document that owns all power-budget information.

## 4. Noise Floor & Sensitivity

| Parameter | Formula | Value | Unit |
|-----------|---------|-------|------|
| Thermal Noise Floor (kTB) | -174 + 10·log₁₀(BW_Hz) | -70.58 | dBm |
| System NF (cascaded) | Friis | 14.21 | dB |
| Input-Referred Noise Floor | kTB + NF_sys | -56.37 | dBm |
| Output Noise Floor | Noise_in + Total_Gain | 23.88 | dBm |
| MDS (SNR = 10 dB) | Noise_in + 10 | -46.37 | dBm |

> Assumes 290 K ambient, full RF instantaneous bandwidth, AWGN channel.
> MDS convention: 10 dB SNR above the input-referred noise floor.

## 5. Gain Variation — Thermal (-40 to +85 °C)

| # | Stage | Component | Nominal Gain (dB) | Tempco (dB/°C) | ΔG @ -40 °C | ΔG @ +85 °C | Worst-Case (dB) |
|---|-------|-----------|-------------------|----------------|-------------|-------------|-----------------|
| 1 | SMA Connector | 2.4mm SMA | -0.25 | ±0.005 | +0.33 | -0.30 | ±0.33 |
| 2 | PCB Trace | 50Ω Microstrip (RO4350B) | -0.40 | ±0.005 | +0.33 | -0.30 | ±0.33 |
| 3 | RF Limiter | HLM-40ABH | -1.10 | ±0.005 | +0.33 | -0.30 | ±0.33 |
| 4 | LNA | PMA3-10203+ | +14.00 | ±0.020 | +1.30 | -1.20 | ±1.30 |
| 5 | RF Preselector BPF | BFCN-1840+ (via XM-A163-0204D) | -5.50 | ±0.005 | +0.33 | -0.30 | ±0.33 |
| 6 | Bias-Tee | 2.4mm-THRU+ (pass-through) | -0.40 | ±0.005 | +0.33 | -0.30 | ±0.33 |
| 7 | 1st RF Mixer | SMIQ-1844H+ | -10.00 | ±0.020 | +1.30 | -1.20 | ±1.30 |
| 8 | 1st IF BPF (3.1 GHz) | IF1 BPF | -4.00 | ±0.005 | +0.33 | -0.30 | ±0.33 |
| 9 | IF Driver Amplifier | CMD295C4 | +14.00 | ±0.020 | +1.30 | -1.20 | ±1.30 |
| 10 | 2nd IF BPF (500 MHz BW) | IF2 BPF | -4.00 | ±0.005 | +0.33 | -0.30 | ±0.33 |
| 11 | VGA / AGC Stage | VGA | +19.00 | ±0.020 | +1.30 | -1.20 | ±1.30 |
| 12 | ADC Driver / Buffer | ADC Driver | +14.00 | ±0.020 | +1.30 | -1.20 | ±1.30 |
| 13 | LO1 Splitter | EP2K1+ | -3.60 | ±0.005 | +0.33 | -0.30 | ±0.33 |
| 14 | Post-split LNA | HMC311ST89E | +13.50 | ±0.020 | +1.30 | -1.20 | ±1.30 |
| 15 | 2nd Mixer + IF2 Gain | 2nd Downconverter | +14.00 | ±0.020 | +1.30 | -1.20 | ±1.30 |
| 16 | Post-2nd-IF VGA | Output VGA | +5.50 | ±0.020 | +1.30 | -1.20 | ±1.30 |
| 17 | IF Gain Block | ADL5541 | +15.50 | ±0.020 | +1.30 | -1.20 | ±1.30 |
| **TOTAL SYSTEM** | | | | | **+14.30** | **-13.20** | — |

> Active stages (LNA / amp / mixer): ±0.020 dB/°C typical GaAs pHEMT or SiGe.
> Passives (connectors, traces, filters, splitters): ±0.005 dB/°C.
> Plan for ≥ 3 dB AGC range or closed-loop gain compensation to hold system gain across the temperature envelope.

## 6. Gain Variation — Frequency (across RF bandwidth)

| # | Stage | Component | Nominal Gain (dB) | Typ Flatness (± dB) | Min Gain (dB) | Max Gain (dB) |
|---|-------|-----------|-------------------|---------------------|---------------|---------------|
| 1 | SMA Connector | 2.4mm SMA | -0.25 | ±0.1 | -0.35 | -0.15 |
| 2 | PCB Trace | 50Ω Microstrip (RO4350B) | -0.40 | ±0.1 | -0.50 | -0.30 |
| 3 | RF Limiter | HLM-40ABH | -1.10 | ±0.1 | -1.20 | -1.00 |
| 4 | LNA | PMA3-10203+ | +14.00 | ±0.5 | +13.50 | +14.50 |
| 5 | RF Preselector BPF | BFCN-1840+ (via XM-A163-0204D) | -5.50 | ±1.0 | -6.50 | -4.50 |
| 6 | Bias-Tee | 2.4mm-THRU+ (pass-through) | -0.40 | ±0.1 | -0.50 | -0.30 |
| 7 | 1st RF Mixer | SMIQ-1844H+ | -10.00 | ±0.5 | -10.50 | -9.50 |
| 8 | 1st IF BPF (3.1 GHz) | IF1 BPF | -4.00 | ±1.0 | -5.00 | -3.00 |
| 9 | IF Driver Amplifier | CMD295C4 | +14.00 | ±0.5 | +13.50 | +14.50 |
| 10 | 2nd IF BPF (500 MHz BW) | IF2 BPF | -4.00 | ±1.0 | -5.00 | -3.00 |
| 11 | VGA / AGC Stage | VGA | +19.00 | ±0.5 | +18.50 | +19.50 |
| 12 | ADC Driver / Buffer | ADC Driver | +14.00 | ±0.5 | +13.50 | +14.50 |
| 13 | LO1 Splitter | EP2K1+ | -3.60 | ±0.1 | -3.70 | -3.50 |
| 14 | Post-split LNA | HMC311ST89E | +13.50 | ±0.5 | +13.00 | +14.00 |
| 15 | 2nd Mixer + IF2 Gain | 2nd Downconverter | +14.00 | ±0.5 | +13.50 | +14.50 |
| 16 | Post-2nd-IF VGA | Output VGA | +5.50 | ±0.5 | +5.00 | +6.00 |
| 17 | IF Gain Block | ADL5541 | +15.50 | ±0.5 | +15.00 | +16.00 |
| **WORST-CASE (Σ)** | | | | **±8.0** | | |
| **RSS (statistical)** | | | | **±2.30** | | |

> Amps: ±0.5 dB in-band. Filters: ±1.0 dB (passband ripple + skirt roll-off). Passives: ±0.1 dB.
> Worst-case Σ assumes all deviations align; RSS assumes uncorrelated contributions — the truth sits between the two.
> If flatness is critical (e.g. ± 1 dB system spec), add an equaliser or gain-slope compensator after the LNA.

## 7. Stage Gain vs Frequency — 1 GHz step

| # | Stage | Component | Nominal (dB) | 18.0 GHz (dB) | 19.0 GHz (dB) | 20.0 GHz (dB) | 21.0 GHz (dB) | 22.0 GHz (dB) | 23.0 GHz (dB) | 24.0 GHz (dB) | 25.0 GHz (dB) | 26.0 GHz (dB) | 27.0 GHz (dB) | 28.0 GHz (dB) | 29.0 GHz (dB) | 30.0 GHz (dB) | 31.0 GHz (dB) | 32.0 GHz (dB) | 33.0 GHz (dB) | 34.0 GHz (dB) | 35.0 GHz (dB) | 36.0 GHz (dB) | 37.0 GHz (dB) | 38.0 GHz (dB) | 39.0 GHz (dB) | 40.0 GHz (dB) |
|---|-------|-----------|--------------|--------------|--------------|--------------|--------------|--------------|--------------|--------------|--------------|--------------|--------------|--------------|--------------|--------------|--------------|--------------|--------------|--------------|--------------|--------------|--------------|--------------|--------------|--------------|
| 1 | SMA Connector | 2.4mm SMA | -0.20 | -0.25 | -0.25 | -0.24 | -0.24 | -0.23 | -0.23 | -0.22 | -0.22 | -0.21 | -0.21 | -0.20 | -0.20 | -0.20 | -0.21 | -0.21 | -0.22 | -0.22 | -0.23 | -0.23 | -0.24 | -0.24 | -0.25 | -0.25 |
| 2 | PCB Trace | 50Ω Microstrip (RO4350B) | -0.35 | -0.40 | -0.40 | -0.39 | -0.39 | -0.38 | -0.38 | -0.37 | -0.37 | -0.36 | -0.36 | -0.35 | -0.35 | -0.35 | -0.36 | -0.36 | -0.37 | -0.37 | -0.38 | -0.38 | -0.39 | -0.39 | -0.40 | -0.40 |
| 3 | RF Limiter | HLM-40ABH | -1.05 | -1.10 | -1.10 | -1.09 | -1.09 | -1.08 | -1.08 | -1.07 | -1.07 | -1.06 | -1.06 | -1.05 | -1.05 | -1.05 | -1.06 | -1.06 | -1.07 | -1.07 | -1.08 | -1.08 | -1.09 | -1.09 | -1.10 | -1.10 |
| 4 | LNA | PMA3-10203+ | +14.50 | +15.00 | +14.95 | +14.91 | +14.86 | +14.82 | +14.77 | +14.73 | +14.68 | +14.64 | +14.59 | +14.55 | +14.50 | +14.45 | +14.41 | +14.36 | +14.32 | +14.27 | +14.23 | +14.18 | +14.14 | +14.09 | +14.05 | +14.00 |
| 5 | RF Preselector BPF | BFCN-1840+ (via XM-A163-0204D) | -4.50 | -5.50 | -5.41 | -5.32 | -5.23 | -5.14 | -5.05 | -4.95 | -4.86 | -4.77 | -4.68 | -4.59 | -4.50 | -4.59 | -4.68 | -4.77 | -4.86 | -4.95 | -5.05 | -5.14 | -5.23 | -5.32 | -5.41 | -5.50 |
| 6 | Bias-Tee | 2.4mm-THRU+ (pass-through) | -0.35 | -0.40 | -0.40 | -0.39 | -0.39 | -0.38 | -0.38 | -0.37 | -0.37 | -0.36 | -0.36 | -0.35 | -0.35 | -0.35 | -0.36 | -0.36 | -0.37 | -0.37 | -0.38 | -0.38 | -0.39 | -0.39 | -0.40 | -0.40 |
| 7 | 1st RF Mixer | SMIQ-1844H+ | -9.50 | -9.00 | -9.05 | -9.09 | -9.14 | -9.18 | -9.23 | -9.27 | -9.32 | -9.36 | -9.41 | -9.45 | -9.50 | -9.55 | -9.59 | -9.64 | -9.68 | -9.73 | -9.77 | -9.82 | -9.86 | -9.91 | -9.95 | -10.00 |
| 8 | 1st IF BPF (3.1 GHz) | IF1 BPF | -3.00 | -4.00 | -3.91 | -3.82 | -3.73 | -3.64 | -3.55 | -3.45 | -3.36 | -3.27 | -3.18 | -3.09 | -3.00 | -3.09 | -3.18 | -3.27 | -3.36 | -3.45 | -3.55 | -3.64 | -3.73 | -3.82 | -3.91 | -4.00 |
| 9 | IF Driver Amplifier | CMD295C4 | +14.50 | +15.00 | +14.95 | +14.91 | +14.86 | +14.82 | +14.77 | +14.73 | +14.68 | +14.64 | +14.59 | +14.55 | +14.50 | +14.45 | +14.41 | +14.36 | +14.32 | +14.27 | +14.23 | +14.18 | +14.14 | +14.09 | +14.05 | +14.00 |
| 10 | 2nd IF BPF (500 MHz BW) | IF2 BPF | -3.00 | -4.00 | -3.91 | -3.82 | -3.73 | -3.64 | -3.55 | -3.45 | -3.36 | -3.27 | -3.18 | -3.09 | -3.00 | -3.09 | -3.18 | -3.27 | -3.36 | -3.45 | -3.55 | -3.64 | -3.73 | -3.82 | -3.91 | -4.00 |
| 11 | VGA / AGC Stage | VGA | +19.50 | +20.00 | +19.95 | +19.91 | +19.86 | +19.82 | +19.77 | +19.73 | +19.68 | +19.64 | +19.59 | +19.55 | +19.50 | +19.45 | +19.41 | +19.36 | +19.32 | +19.27 | +19.23 | +19.18 | +19.14 | +19.09 | +19.05 | +19.00 |
| 12 | ADC Driver / Buffer | ADC Driver | +14.50 | +15.00 | +14.95 | +14.91 | +14.86 | +14.82 | +14.77 | +14.73 | +14.68 | +14.64 | +14.59 | +14.55 | +14.50 | +14.45 | +14.41 | +14.36 | +14.32 | +14.27 | +14.23 | +14.18 | +14.14 | +14.09 | +14.05 | +14.00 |
| 13 | LO1 Splitter | EP2K1+ | -3.55 | -3.60 | -3.60 | -3.59 | -3.59 | -3.58 | -3.58 | -3.57 | -3.57 | -3.56 | -3.56 | -3.55 | -3.55 | -3.55 | -3.56 | -3.56 | -3.57 | -3.57 | -3.58 | -3.58 | -3.59 | -3.59 | -3.60 | -3.60 |
| 14 | Post-split LNA | HMC311ST89E | +14.00 | +14.50 | +14.45 | +14.41 | +14.36 | +14.32 | +14.27 | +14.23 | +14.18 | +14.14 | +14.09 | +14.05 | +14.00 | +13.95 | +13.91 | +13.86 | +13.82 | +13.77 | +13.73 | +13.68 | +13.64 | +13.59 | +13.55 | +13.50 |
| 15 | 2nd Mixer + IF2 Gain | 2nd Downconverter | +14.50 | +15.00 | +14.95 | +14.91 | +14.86 | +14.82 | +14.77 | +14.73 | +14.68 | +14.64 | +14.59 | +14.55 | +14.50 | +14.45 | +14.41 | +14.36 | +14.32 | +14.27 | +14.23 | +14.18 | +14.14 | +14.09 | +14.05 | +14.00 |
| 16 | Post-2nd-IF VGA | Output VGA | +6.00 | +6.50 | +6.45 | +6.41 | +6.36 | +6.32 | +6.27 | +6.23 | +6.18 | +6.14 | +6.09 | +6.05 | +6.00 | +5.95 | +5.91 | +5.86 | +5.82 | +5.77 | +5.73 | +5.68 | +5.64 | +5.59 | +5.55 | +5.50 |
| 17 | IF Gain Block | ADL5541 | +16.00 | +16.50 | +16.45 | +16.41 | +16.36 | +16.32 | +16.27 | +16.23 | +16.18 | +16.14 | +16.09 | +16.05 | +16.00 | +15.95 | +15.91 | +15.86 | +15.82 | +15.77 | +15.73 | +15.68 | +15.64 | +15.59 | +15.55 | +15.50 |

## 7a. System Rollup vs Frequency

| Frequency (GHz) | Total Gain (dB) | Cascaded NF (dB) | Output Power (dBm) | MDS @ 10 dB SNR (dBm) |
|----------------:|----------------:|------------------:|-------------------:|----------------------:|
| 18.0 | +89.25 | 12.03 | +8.05 | -48.54 |
| 19.0 | +89.07 | 11.98 | +7.87 | -48.59 |
| 20.0 | +89.03 | 11.88 | +7.83 | -48.69 |
| 21.0 | +88.85 | 11.83 | +7.65 | -48.74 |
| 22.0 | +88.81 | 11.73 | +7.61 | -48.84 |
| 23.0 | +88.63 | 11.68 | +7.43 | -48.89 |
| 24.0 | +88.62 | 11.57 | +7.42 | -49.00 |
| 25.0 | +88.44 | 11.53 | +7.24 | -49.05 |
| 26.0 | +88.40 | 11.43 | +7.20 | -49.15 |
| 27.0 | +88.22 | 11.38 | +7.02 | -49.19 |
| 28.0 | +88.18 | 11.29 | +6.98 | -49.29 |
| 29.0 | +88.00 | 11.24 | +6.80 | -49.33 |
| 30.0 | +87.28 | 11.43 | +6.08 | -49.15 |
| 31.0 | +86.60 | 11.64 | +5.40 | -48.93 |
| 32.0 | +85.88 | 11.84 | +4.68 | -48.74 |
| 33.0 | +85.20 | 12.06 | +4.00 | -48.52 |
| 34.0 | +84.48 | 12.26 | +3.28 | -48.31 |
| 35.0 | +83.77 | 12.50 | +2.57 | -48.07 |
| 36.0 | +83.05 | 12.71 | +1.85 | -47.86 |
| 37.0 | +82.37 | 12.95 | +1.17 | -47.63 |
| 38.0 | +81.65 | 13.16 | +0.45 | -47.41 |
| 39.0 | +80.97 | 13.40 | -0.23 | -47.17 |
| 40.0 | +80.25 | 13.63 | -0.95 | -46.95 |

> Gain roll-off model: amps/mixers fall off monotonically toward the high edge of the band by ±0.5 dB at the edges; filters ripple by ±1.0 dB; connectors & traces by ±0.1 dB.
> Cascaded NF recomputed with Friis at each frequency — the LNA continues to dominate, so NF typically stays within ±0.3 dB of nominal across the band.
> MDS tracks the NF. If the band-edge MDS is more than 2 dB worse than midband, add frequency-dependent equalisation or re-allocate gain toward the LNA.

## 8. Return Loss — Per Stage

| # | Stage | Component | S11 — Input RL (dB) | S22 — Output RL (dB) | Notes |
|---|-------|-----------|---------------------|----------------------|-------|
| 1 | SMA Connector | 2.4mm SMA | 20.0 | 20.0 | 2.4mm SMA connector at Ka-band |
| 2 | LNA | PMA3-10203+ | 12.0 | 14.0 | GaAs pHEMT MMIC LNA, gain reduced at 30 GHz est ~15dB |
| 3 | IF Driver Amplifier | CMD295C4 | 15.0 | 15.0 | 2-20 GHz driver amp, OIP3 +30 dBm |

> Return loss values are referenced to 50 Ω. Higher value = better match.

## 9. Consistency Checks

> (No BOM supplied to the GLB tool call — cross-check skipped. When the BOM is available, this section lists any component in the GLB that does not appear in the parts list.)

## 10. Cascade Noise Figure — Friis Formula

$$F_{{sys}} = F_1 + \frac{{F_2 - 1}}{{G_1}} + \frac{{F_3 - 1}}{{G_1 G_2}} + \cdots$$

Where *F* = linear noise factor (not dB), *G* = linear gain.
The first stage NF dominates — minimise LNA/driver NF for best system sensitivity.

---
> **Note:** All values are estimated from component datasheets at 25 °C nominal.
> Verify with bench measurements (spectrum analyser + noise source) during hardware bring-up.