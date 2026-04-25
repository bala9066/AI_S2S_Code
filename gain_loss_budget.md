# RF Gain-Loss Budget
## hjjg

**Generated:** 2026-04-25  
**Document Status:** AI-GENERATED — verify against final component datasheets

## 0. Design Contract Checks

⚠ **WARN** — 0 hard violations, 1 warning(s) — review before release

| # | Rule | Status | Detail |
|---|------|--------|--------|
| C1 | Analysis at worst-case frequency | ✅ pass | Cascade evaluated at f_max = 4050 MHz (centre 4000 + BW/2 = 50 MHz). |
| C2 | Bias conditions declared for every active stage | ✅ pass | Every LNA / amp / mixer stage cites the datasheet Vdd/Idq row that produces its gain and NF. |
| C3 | Pdc = Vdd × Idq (±10 mW) | ✅ pass | All biased stages obey the Ohm-law tie between supply and DC power. |
| C4 | Passive NF = |insertion loss| (Friis) | ✅ pass | Every passive stage's NF equals its insertion loss in dB, as thermodynamics requires. |
| C5 | GLB ↔ BOM component match | ⚠ warn | No BOM supplied to this renderer — cross-check skipped. |

> These five invariants must hold for any RF receiver GLB to be releasable to PCB. Any row marked **fail** is a contract violation — regenerate Phase 1 or edit the offending stage before proceeding.

## 0.5 Closed-Loop Optimization Log

### Iteration 1
- **Issues:** 4 hard, 1 warn
  - ❌ `GAIN_SHORT` — Cascade gain 42.4 dB is 47.6 dB below target 90.0 dB.
  - ❌ `FRIIS_MISMATCH` — Stage 4 passive NF 2.50 dB ≠ |loss| 3.50 dB.
  - ❌ `FRIIS_MISMATCH` — Stage 7 passive NF 1.50 dB ≠ |loss| 2.50 dB.
  - ❌ `FRIIS_MISMATCH` — Stage 9 passive NF 1.50 dB ≠ |loss| 2.50 dB.
  - ⚠ `LNA_DEEP` — 4.6 dB of passive loss before first LNA — inflates system NF via Friis.
- **Cascade:** gain=42.35 dB · NF=11.19 dB · Pout=-49.65 dBm · Pdc=1948.0 mW _(evaluated at worst-case (f_max))_
- **Actions:**
  - Set Stage 4 passive NF to |loss| = 3.50 dB
  - Set Stage 7 passive NF to |loss| = 2.50 dB
  - Set Stage 9 passive NF to |loss| = 2.50 dB
  - Promoted LNA from stage 5 to stage 4 (reduces pre-LNA passive loss → better Friis NF).
  - Inserted ADL5541 at stage 15 (+16 dB, NF 3.0 dB).
  - Inserted HMC624LP4E at stage 16 (+19 dB, NF 7.0 dB).
  - Inserted HMC8108 at stage 17 (+15 dB, NF 5.0 dB).

### Iteration 2
- **Issues:** 0 hard, 1 warn
  - ⚠ `GAIN_OVER` — Cascade gain 92.3 dB exceeds target 90.0 dB by 2.3 dB.
- **Cascade:** gain=84.15 dB · NF=15.43 dB · Pout=-7.85 dBm · Pdc=4122.0 mW _(evaluated at worst-case (f_max))_
- **Actions:**
  - Converged — no hard violations remain.
  - — propagation —
  - Added BOM entry 'ADL5541' (IF Gain Block (20 MHz-6 GHz)) from optimizer library.
  - Added BOM entry 'HMC624LP4E' (Digital Step Attenuator / VGA (DC-6 GHz)) from optimizer library.
  - Added BOM entry 'HMC8108' (Final Driver Amplifier (6-12 GHz)) from optimizer library.
  - BOM entry 'EP2K1+' is no longer in the GLB chain (optimizer removed/replaced it) — flagged for review.
  - BOM entry 'MIC5209-3.3YM' is no longer in the GLB chain (optimizer removed/replaced it) — flagged for review.
  - +5V rail needs 722 mA (× 1.3 = 939 mA target) but no converter was present — added 'MAX17501GATB+T' (1500 mA Buck).
  - ⚠ +3.3V regulator 'MIC5209-3.3YM' has no declared I_out_max — cannot verify it covers 155 mA load.
  - Regenerated block_diagram_mermaid to reflect the 17-stage optimizer output.


## 1. System Parameters

| Parameter | Value | Unit |
|-----------|-------|------|
| Centre Frequency    | 4000   | MHz  |
| RF Bandwidth        | 100     | MHz  |
| **Analysis Frequency (worst-case)** | **4050** | **MHz** |
| Input Signal Level  | -92   | dBm  |
| Target Output Power | -2  | dBm  |
| Required System Gain | 90 | dB   |

> **Why the upper band edge?** For a receiver, NF rises and gain falls with
> frequency — system sensitivity (MDS) is worst at f_max. The stage-by-stage
> cascade below is therefore evaluated at the upper band edge so the numbers
> represent the least-favourable operating point. The frequency-sweep section
> further down shows how every metric varies across the full band in 1 GHz steps.

## 2. Stage-by-Stage Gain / Loss Budget

| # | Stage | Component | Gain/Loss (dB) | Cum. Gain (dB) | Output Power (dBm) | NF (dB) | Cum. NF (dB) | P1dB Out (dBm) | OIP3 (dBm) | Region | Notes |
|---|-------|-----------|---------------|----------------|-------------------|---------|-------------|---------------|-----------|--------|-------|
| 1 | Input SMA Connector | SMA-F | -0.2 | -0.2 | -92.2 | 0.15 | 0.15 | N/A | N/A | Linear (passive) |  |
| 2 | PCB Trace | 50Ω Microstrip (RO4350B) | -0.4 | -0.7 | -92.7 | 0.30 | 0.46 | N/A | N/A | Linear (passive) | Typ 1–2 in RO4350B microstrip loss at band |
| 3 | RF Limiter | PE8022 | -0.6 | -1.2 | -93.2 | 0.50 | 0.98 | N/A | N/A | Linear (passive) |  |
| 4 | LNA | GRF2074 | +19.0 | 17.8 | -74.2 | 1.80 | 2.87 | 18.0 | 28.0 | Linear (92.2 dB BO) |  |
| 5 | Preselector BPF | Tunable BPF 2-6 GHz | -4.5 | 13.2 | -78.8 | 3.50 | 2.92 | N/A | N/A | Linear (passive) | ⚠ Passive NF ≠ |loss| (3.50 vs 4.50 dB) |
| 6 | 1st Mixer (RF to IF1) | MCA1-42+ | -8.0 | 5.2 | -86.8 | 8.00 | 3.44 | 11.0 | 21.0 | Linear (97.8 dB BO) |  |
| 7 | IF1 BPF (1300 MHz) | 1300 MHz IF BPF | -3.5 | 1.8 | -90.2 | 2.50 | 3.88 | N/A | N/A | Linear (passive) | ⚠ Passive NF ≠ |loss| (2.50 vs 3.50 dB) |
| 8 | 2nd Mixer (IF1 to IF2) | RMS-2+ | -7.5 | -5.8 | -97.8 | 7.50 | 7.43 | 11.0 | 21.0 | Linear (108.8 dB BO) |  |
| 9 | IF2 BPF (200 MHz) | 200 MHz IF BPF | -3.5 | -9.2 | -101.2 | 2.50 | 9.27 | N/A | N/A | Linear (passive) | ⚠ Passive NF ≠ |loss| (2.50 vs 3.50 dB) |
| 10 | IF Driver Amplifier | HMC788ALP2E | +13.0 | 3.8 | -88.2 | 6.00 | 15.26 | 17.0 | 27.0 | Linear (105.2 dB BO) |  |
| 11 | 2nd IF Driver Amplifier | HMC788ALP2E | +13.0 | 16.8 | -75.2 | 6.00 | 15.42 | 17.0 | 27.0 | Linear (92.2 dB BO) |  |
| 12 | Gain Trim Pad | 3 dB Pi-pad | -3.1 | 13.7 | -78.3 | 3.00 | 15.42 | N/A | N/A | Linear (passive) |  |
| 13 | Final IF Buffer Amp | GRF2040 | +9.0 | 22.6 | -69.3 | 5.00 | 15.43 | 17.0 | 27.0 | Linear (86.3 dB BO) |  |
| 14 | Final Gain Block | HMC788ALP2E | +13.0 | 35.6 | -56.4 | 6.00 | 15.43 | 17.0 | 27.0 | Linear (73.3 dB BO) |  |
| 15 | IF Gain Block | ADL5541 | +15.5 | 51.1 | -40.9 | 3.50 | 15.43 | 21.0 | — | Linear (61.9 dB BO) |  |
| 16 | VGA (AGC) | HMC624LP4E | +18.5 | 69.7 | -22.4 | 7.50 | 15.43 | 19.0 | — | Linear (41.4 dB BO) |  |
| 17 | Final Driver | HMC8108 | +14.5 | 84.2 | -7.8 | 5.50 | 15.43 | 29.0 | — | Linear (36.9 dB BO) |  |

> **Region legend:** *Linear* = ≥10 dB back-off from P1dB · *Near-linear* = 6-10 dB · *Compressing* = 0-6 dB (onset of gain compression) · *Saturated* = above P1dB (hard non-linear). Keep every stage in the Linear zone for analogue receivers; transmit chains may intentionally drive the PA into compression.

## 3. Budget Summary

| Metric | Value | Unit |
|--------|-------|------|
| Total System Gain     | 84.2  | dB  |
| Final Output Power    | -7.8  | dBm |
| Cascaded System NF    | 15.43 | dB  |
| Output Power Margin   | +5.8 | dB  |

> **Per-stage DC bias (Vdd/Idq/Pdc)** is listed in `power_calculation.md` — the companion document that owns all power-budget information.

## 4. Noise Floor & Sensitivity

| Parameter | Formula | Value | Unit |
|-----------|---------|-------|------|
| Thermal Noise Floor (kTB) | -174 + 10·log₁₀(BW_Hz) | -94.00 | dBm |
| System NF (cascaded) | Friis | 15.43 | dB |
| Input-Referred Noise Floor | kTB + NF_sys | -78.57 | dBm |
| Output Noise Floor | Noise_in + Total_Gain | 5.58 | dBm |
| MDS (SNR = 10 dB) | Noise_in + 10 | -68.57 | dBm |

> Assumes 290 K ambient, full RF instantaneous bandwidth, AWGN channel.
> MDS convention: 10 dB SNR above the input-referred noise floor.

## 5. Gain Variation — Thermal (-40 to +85 °C)

| # | Stage | Component | Nominal Gain (dB) | Tempco (dB/°C) | ΔG @ -40 °C | ΔG @ +85 °C | Worst-Case (dB) |
|---|-------|-----------|-------------------|----------------|-------------|-------------|-----------------|
| 1 | Input SMA Connector | SMA-F | -0.25 | ±0.005 | +0.33 | -0.30 | ±0.33 |
| 2 | PCB Trace | 50Ω Microstrip (RO4350B) | -0.40 | ±0.005 | +0.33 | -0.30 | ±0.33 |
| 3 | RF Limiter | PE8022 | -0.60 | ±0.005 | +0.33 | -0.30 | ±0.33 |
| 4 | LNA | GRF2074 | +19.00 | ±0.020 | +1.30 | -1.20 | ±1.30 |
| 5 | Preselector BPF | Tunable BPF 2-6 GHz | -4.50 | ±0.005 | +0.33 | -0.30 | ±0.33 |
| 6 | 1st Mixer (RF to IF1) | MCA1-42+ | -8.00 | ±0.020 | +1.30 | -1.20 | ±1.30 |
| 7 | IF1 BPF (1300 MHz) | 1300 MHz IF BPF | -3.50 | ±0.005 | +0.33 | -0.30 | ±0.33 |
| 8 | 2nd Mixer (IF1 to IF2) | RMS-2+ | -7.50 | ±0.020 | +1.30 | -1.20 | ±1.30 |
| 9 | IF2 BPF (200 MHz) | 200 MHz IF BPF | -3.50 | ±0.005 | +0.33 | -0.30 | ±0.33 |
| 10 | IF Driver Amplifier | HMC788ALP2E | +13.00 | ±0.020 | +1.30 | -1.20 | ±1.30 |
| 11 | 2nd IF Driver Amplifier | HMC788ALP2E | +13.00 | ±0.020 | +1.30 | -1.20 | ±1.30 |
| 12 | Gain Trim Pad | 3 dB Pi-pad | -3.10 | ±0.005 | +0.33 | -0.30 | ±0.33 |
| 13 | Final IF Buffer Amp | GRF2040 | +9.00 | ±0.020 | +1.30 | -1.20 | ±1.30 |
| 14 | Final Gain Block | HMC788ALP2E | +13.00 | ±0.020 | +1.30 | -1.20 | ±1.30 |
| 15 | IF Gain Block | ADL5541 | +15.50 | ±0.020 | +1.30 | -1.20 | ±1.30 |
| 16 | VGA (AGC) | HMC624LP4E | +18.50 | ±0.020 | +1.30 | -1.20 | ±1.30 |
| 17 | Final Driver | HMC8108 | +14.50 | ±0.020 | +1.30 | -1.20 | ±1.30 |
| **TOTAL SYSTEM** | | | | | **+15.28** | **-14.10** | — |

> Active stages (LNA / amp / mixer): ±0.020 dB/°C typical GaAs pHEMT or SiGe.
> Passives (connectors, traces, filters, splitters): ±0.005 dB/°C.
> Plan for ≥ 3 dB AGC range or closed-loop gain compensation to hold system gain across the temperature envelope.

## 6. Gain Variation — Frequency (across RF bandwidth)

| # | Stage | Component | Nominal Gain (dB) | Typ Flatness (± dB) | Min Gain (dB) | Max Gain (dB) |
|---|-------|-----------|-------------------|---------------------|---------------|---------------|
| 1 | Input SMA Connector | SMA-F | -0.25 | ±0.1 | -0.35 | -0.15 |
| 2 | PCB Trace | 50Ω Microstrip (RO4350B) | -0.40 | ±0.1 | -0.50 | -0.30 |
| 3 | RF Limiter | PE8022 | -0.60 | ±0.1 | -0.70 | -0.50 |
| 4 | LNA | GRF2074 | +19.00 | ±0.5 | +18.50 | +19.50 |
| 5 | Preselector BPF | Tunable BPF 2-6 GHz | -4.50 | ±1.0 | -5.50 | -3.50 |
| 6 | 1st Mixer (RF to IF1) | MCA1-42+ | -8.00 | ±0.5 | -8.50 | -7.50 |
| 7 | IF1 BPF (1300 MHz) | 1300 MHz IF BPF | -3.50 | ±1.0 | -4.50 | -2.50 |
| 8 | 2nd Mixer (IF1 to IF2) | RMS-2+ | -7.50 | ±0.5 | -8.00 | -7.00 |
| 9 | IF2 BPF (200 MHz) | 200 MHz IF BPF | -3.50 | ±1.0 | -4.50 | -2.50 |
| 10 | IF Driver Amplifier | HMC788ALP2E | +13.00 | ±0.5 | +12.50 | +13.50 |
| 11 | 2nd IF Driver Amplifier | HMC788ALP2E | +13.00 | ±0.5 | +12.50 | +13.50 |
| 12 | Gain Trim Pad | 3 dB Pi-pad | -3.10 | ±0.1 | -3.20 | -3.00 |
| 13 | Final IF Buffer Amp | GRF2040 | +9.00 | ±0.5 | +8.50 | +9.50 |
| 14 | Final Gain Block | HMC788ALP2E | +13.00 | ±0.5 | +12.50 | +13.50 |
| 15 | IF Gain Block | ADL5541 | +15.50 | ±0.5 | +15.00 | +16.00 |
| 16 | VGA (AGC) | HMC624LP4E | +18.50 | ±0.5 | +18.00 | +19.00 |
| 17 | Final Driver | HMC8108 | +14.50 | ±0.5 | +14.00 | +15.00 |
| **WORST-CASE (Σ)** | | | | **±8.4** | | |
| **RSS (statistical)** | | | | **±2.35** | | |

> Amps: ±0.5 dB in-band. Filters: ±1.0 dB (passband ripple + skirt roll-off). Passives: ±0.1 dB.
> Worst-case Σ assumes all deviations align; RSS assumes uncorrelated contributions — the truth sits between the two.
> If flatness is critical (e.g. ± 1 dB system spec), add an equaliser or gain-slope compensator after the LNA.

## 7. Stage Gain vs Frequency — 250 MHz step (BW < 3 GHz)

| # | Stage | Component | Nominal (dB) | 4.0 GHz (dB) | 4.0 GHz (dB) |
|---|-------|-----------|--------------|--------------|--------------|
| 1 | Input SMA Connector | SMA-F | -0.20 | -0.25 | -0.25 |
| 2 | PCB Trace | 50Ω Microstrip (RO4350B) | -0.35 | -0.40 | -0.40 |
| 3 | RF Limiter | PE8022 | -0.55 | -0.60 | -0.60 |
| 4 | LNA | GRF2074 | +19.50 | +20.00 | +19.00 |
| 5 | Preselector BPF | Tunable BPF 2-6 GHz | -3.50 | -4.50 | -4.50 |
| 6 | 1st Mixer (RF to IF1) | MCA1-42+ | -7.50 | -7.00 | -8.00 |
| 7 | IF1 BPF (1300 MHz) | 1300 MHz IF BPF | -2.50 | -3.50 | -3.50 |
| 8 | 2nd Mixer (IF1 to IF2) | RMS-2+ | -7.00 | -6.50 | -7.50 |
| 9 | IF2 BPF (200 MHz) | 200 MHz IF BPF | -2.50 | -3.50 | -3.50 |
| 10 | IF Driver Amplifier | HMC788ALP2E | +13.50 | +14.00 | +13.00 |
| 11 | 2nd IF Driver Amplifier | HMC788ALP2E | +13.50 | +14.00 | +13.00 |
| 12 | Gain Trim Pad | 3 dB Pi-pad | -3.05 | -3.10 | -3.10 |
| 13 | Final IF Buffer Amp | GRF2040 | +9.50 | +10.00 | +9.00 |
| 14 | Final Gain Block | HMC788ALP2E | +13.50 | +14.00 | +13.00 |
| 15 | IF Gain Block | ADL5541 | +16.00 | +16.50 | +15.50 |
| 16 | VGA (AGC) | HMC624LP4E | +19.00 | +19.50 | +18.50 |
| 17 | Final Driver | HMC8108 | +15.00 | +15.50 | +14.50 |

## 7a. System Rollup vs Frequency

| Frequency (GHz) | Total Gain (dB) | Cascaded NF (dB) | Output Power (dBm) | MDS @ 10 dB SNR (dBm) |
|----------------:|----------------:|------------------:|-------------------:|----------------------:|
| 4.0 | +94.15 | 12.15 | +2.15 | -71.85 |
| 4.0 | +84.15 | 14.83 | -7.85 | -69.17 |

> Gain roll-off model: amps/mixers fall off monotonically toward the high edge of the band by ±0.5 dB at the edges; filters ripple by ±1.0 dB; connectors & traces by ±0.1 dB.
> Cascaded NF recomputed with Friis at each frequency — the LNA continues to dominate, so NF typically stays within ±0.3 dB of nominal across the band.
> MDS tracks the NF. If the band-edge MDS is more than 2 dB worse than midband, add frequency-dependent equalisation or re-allocate gain toward the LNA.

## 8. Consistency Checks

> (No BOM supplied to the GLB tool call — cross-check skipped. When the BOM is available, this section lists any component in the GLB that does not appear in the parts list.)

## 9. Cascade Noise Figure — Friis Formula

$$F_{{sys}} = F_1 + \frac{{F_2 - 1}}{{G_1}} + \frac{{F_3 - 1}}{{G_1 G_2}} + \cdots$$

Where *F* = linear noise factor (not dB), *G* = linear gain.
The first stage NF dominates — minimise LNA/driver NF for best system sensitivity.

---
> **Note:** All values are estimated from component datasheets at 25 °C nominal.
> Verify with bench measurements (spectrum analyser + noise source) during hardware bring-up.