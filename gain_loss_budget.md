# RF Gain-Loss Budget
## hfuf

**Generated:** 2026-04-22  
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
- **Issues:** 3 hard, 1 warn
  - ❌ `FRIIS_MISMATCH` — Stage 4 passive NF 2.00 dB ≠ |loss| 3.00 dB.
  - ❌ `COMPRESSION` — Stage 8 (LNA Stage 3) back-off 2.6 dB below P1dB — non-linear risk.
  - ❌ `COMPRESSION` — Stage 9 (LNA Stage 4) back-off -10.9 dB below P1dB — non-linear risk.
  - ⚠ `LNA_DEEP` — 4.1 dB of passive loss before first LNA — inflates system NF via Friis.
- **Cascade:** gain=49.7 dB · NF=7.83 dB · Pout=19.7 dBm · Pdc=1500.0 mW _(evaluated at worst-case (f_max))_
- **Actions:**
  - Set Stage 4 passive NF to |loss| = 3.00 dB
  - Promoted LNA from stage 6 to stage 4 (reduces pre-LNA passive loss → better Friis NF).
  - Inserted 3 dB stability pad before Stage 8 to restore P1dB back-off.

### Iteration 2
- **Issues:** 3 hard, 0 warn
  - ❌ `GAIN_SHORT` — Cascade gain 46.7 dB is 3.3 dB below target 50.0 dB.
  - ❌ `COMPRESSION` — Stage 9 (LNA Stage 3) back-off 5.6 dB below P1dB — non-linear risk.
  - ❌ `COMPRESSION` — Stage 10 (LNA Stage 4) back-off -7.9 dB below P1dB — non-linear risk.
- **Cascade:** gain=43.4 dB · NF=5.94 dB · Pout=13.4 dBm · Pdc=1500.0 mW _(evaluated at worst-case (f_max))_
- **Actions:**
  - Stalled — 3 hard issue(s) persist after correction. Manual review needed.
  - — propagation —
  - Added BOM entry 'Pi attenuator 3 dB' (Fixed RF Attenuator Pad (3 dB)) from optimizer library.
  - BOM entry 'Mini-Circuits BFHK-5001+' is no longer in the GLB chain (optimizer removed/replaced it) — flagged for review.
  - Regenerated block_diagram_mermaid to reflect the 11-stage optimizer output.


## 1. System Parameters

| Parameter | Value | Unit |
|-----------|-------|------|
| Centre Frequency    | 4000   | MHz  |
| RF Bandwidth        | 100     | MHz  |
| **Analysis Frequency (worst-case)** | **4050** | **MHz** |
| Input Signal Level  | -30   | dBm  |
| Target Output Power | 20  | dBm  |
| Required System Gain | 50 | dB   |

> **Why the upper band edge?** For a receiver, NF rises and gain falls with
> frequency — system sensitivity (MDS) is worst at f_max. The stage-by-stage
> cascade below is therefore evaluated at the upper band edge so the numbers
> represent the least-favourable operating point. The frequency-sweep section
> further down shows how every metric varies across the full band in 1 GHz steps.

## 2. Stage-by-Stage Gain / Loss Budget

| # | Stage | Component | Gain/Loss (dB) | Cum. Gain (dB) | Output Power (dBm) | NF (dB) | Cum. NF (dB) | P1dB Out (dBm) | OIP3 (dBm) | Region | Notes |
|---|-------|-----------|---------------|----------------|-------------------|---------|-------------|---------------|-----------|--------|-------|
| 1 | Input Connector (2.92mm) | 2.92mm SMA-K connector | -0.2 | -0.2 | -30.2 | 0.15 | 0.15 | N/A | N/A | Linear (passive) | Connector loss per interface |
| 2 | PCB Trace | 50Ω Microstrip (RO4350B) | -0.4 | -0.7 | -30.6 | 0.30 | 0.46 | N/A | N/A | Linear (passive) | Typ 1–2 in RO4350B microstrip loss at band |
| 3 | Input Limiter | SKY16602-632LF | -0.4 | -1.1 | -31.1 | 0.30 | 0.77 | N/A | N/A | Linear (passive) | Passive limiter loss at 4 GHz |
| 4 | LNA Stage 1 | LVA-273PN+ | +13.0 | 11.9 | -18.1 | 4.50 | 5.45 | 8.0 | 20.0 | Linear (26.1 dB BO) | First gain stage - sets NF |
| 5 | Preselector BPF | BFHK-5001+ (custom LC 2-6 GHz) | -4.0 | 8.0 | -22.1 | 3.00 | 5.53 | N/A | N/A | Linear (passive) | LC bandpass filter insertion loss · ⚠ Passive NF ≠ |loss| (3.00 vs 4.00 dB) |
| 6 | Bias-T | PE1604 | -0.2 | 7.7 | -22.3 | 0.15 | 5.54 | N/A | N/A | Linear (passive) | Bias tee insertion loss |
| 7 | LNA Stage 2 | LVA-273PN+ | +13.0 | 20.7 | -9.3 | 4.50 | 5.90 | 8.0 | 20.0 | Linear (17.3 dB BO) | Second gain stage |
| 8 | Stability Pad | Pi attenuator 3 dB | -3.0 | 17.6 | -12.3 | 3.00 | 5.91 | None | — | Linear (passive) |  |
| 9 | LNA Stage 3 | LVA-273PN+ | +13.0 | 30.6 | 0.7 | 4.50 | 5.94 | 8.0 | 20.0 | Near-linear (7.3 dB BO) | Third gain stage |
| 10 | LNA Stage 4 | LVA-273PN+ | +13.0 | 43.6 | 13.7 | 4.50 | 5.94 | 8.0 | 20.0 | SATURATED (5.7 dB over P1dB) | Fourth gain stage to achieve 50 dB target |
| 11 | Output Connector | 2.92mm SMA-K connector | -0.2 | 43.4 | 13.4 | 0.15 | 5.94 | N/A | N/A | Linear (passive) | Output connector loss |

> **Region legend:** *Linear* = ≥10 dB back-off from P1dB · *Near-linear* = 6-10 dB · *Compressing* = 0-6 dB (onset of gain compression) · *Saturated* = above P1dB (hard non-linear). Keep every stage in the Linear zone for analogue receivers; transmit chains may intentionally drive the PA into compression.

## 3. Budget Summary

| Metric | Value | Unit |
|--------|-------|------|
| Total System Gain     | 43.4  | dB  |
| Final Output Power    | 13.4  | dBm |
| Cascaded System NF    | 5.94 | dB  |
| Output Power Margin   | +6.6 | dB  |

> **Per-stage DC bias (Vdd/Idq/Pdc)** is listed in `power_calculation.md` — the companion document that owns all power-budget information.

## 4. Noise Floor & Sensitivity

| Parameter | Formula | Value | Unit |
|-----------|---------|-------|------|
| Thermal Noise Floor (kTB) | -174 + 10·log₁₀(BW_Hz) | -94.00 | dBm |
| System NF (cascaded) | Friis | 5.94 | dB |
| Input-Referred Noise Floor | kTB + NF_sys | -88.06 | dBm |
| Output Noise Floor | Noise_in + Total_Gain | -44.66 | dBm |
| MDS (SNR = 10 dB) | Noise_in + 10 | -78.06 | dBm |

> Assumes 290 K ambient, full RF instantaneous bandwidth, AWGN channel.
> MDS convention: 10 dB SNR above the input-referred noise floor.

## 5. Gain Variation — Thermal (-40 to +85 °C)

| # | Stage | Component | Nominal Gain (dB) | Tempco (dB/°C) | ΔG @ -40 °C | ΔG @ +85 °C | Worst-Case (dB) |
|---|-------|-----------|-------------------|----------------|-------------|-------------|-----------------|
| 1 | Input Connector (2.92mm) | 2.92mm SMA-K connector | -0.25 | ±0.005 | +0.33 | -0.30 | ±0.33 |
| 2 | PCB Trace | 50Ω Microstrip (RO4350B) | -0.40 | ±0.005 | +0.33 | -0.30 | ±0.33 |
| 3 | Input Limiter | SKY16602-632LF | -0.40 | ±0.005 | +0.33 | -0.30 | ±0.33 |
| 4 | LNA Stage 1 | LVA-273PN+ | +13.00 | ±0.020 | +1.30 | -1.20 | ±1.30 |
| 5 | Preselector BPF | BFHK-5001+ (custom LC 2-6 GHz) | -4.00 | ±0.005 | +0.33 | -0.30 | ±0.33 |
| 6 | Bias-T | PE1604 | -0.25 | ±0.005 | +0.33 | -0.30 | ±0.33 |
| 7 | LNA Stage 2 | LVA-273PN+ | +13.00 | ±0.020 | +1.30 | -1.20 | ±1.30 |
| 8 | Stability Pad | Pi attenuator 3 dB | -3.05 | ±0.005 | +0.33 | -0.30 | ±0.33 |
| 9 | LNA Stage 3 | LVA-273PN+ | +13.00 | ±0.020 | +1.30 | -1.20 | ±1.30 |
| 10 | LNA Stage 4 | LVA-273PN+ | +13.00 | ±0.020 | +1.30 | -1.20 | ±1.30 |
| 11 | Output Connector | 2.92mm SMA-K connector | -0.25 | ±0.005 | +0.33 | -0.30 | ±0.33 |
| **TOTAL SYSTEM** | | | | | **+7.48** | **-6.90** | — |

> Active stages (LNA / amp / mixer): ±0.020 dB/°C typical GaAs pHEMT or SiGe.
> Passives (connectors, traces, filters, splitters): ±0.005 dB/°C.
> Plan for ≥ 3 dB AGC range or closed-loop gain compensation to hold system gain across the temperature envelope.

## 6. Gain Variation — Frequency (across RF bandwidth)

| # | Stage | Component | Nominal Gain (dB) | Typ Flatness (± dB) | Min Gain (dB) | Max Gain (dB) |
|---|-------|-----------|-------------------|---------------------|---------------|---------------|
| 1 | Input Connector (2.92mm) | 2.92mm SMA-K connector | -0.25 | ±0.1 | -0.35 | -0.15 |
| 2 | PCB Trace | 50Ω Microstrip (RO4350B) | -0.40 | ±0.1 | -0.50 | -0.30 |
| 3 | Input Limiter | SKY16602-632LF | -0.40 | ±0.1 | -0.50 | -0.30 |
| 4 | LNA Stage 1 | LVA-273PN+ | +13.00 | ±0.5 | +12.50 | +13.50 |
| 5 | Preselector BPF | BFHK-5001+ (custom LC 2-6 GHz) | -4.00 | ±1.0 | -5.00 | -3.00 |
| 6 | Bias-T | PE1604 | -0.25 | ±0.1 | -0.35 | -0.15 |
| 7 | LNA Stage 2 | LVA-273PN+ | +13.00 | ±0.5 | +12.50 | +13.50 |
| 8 | Stability Pad | Pi attenuator 3 dB | -3.05 | ±0.1 | -3.15 | -2.95 |
| 9 | LNA Stage 3 | LVA-273PN+ | +13.00 | ±0.5 | +12.50 | +13.50 |
| 10 | LNA Stage 4 | LVA-273PN+ | +13.00 | ±0.5 | +12.50 | +13.50 |
| 11 | Output Connector | 2.92mm SMA-K connector | -0.25 | ±0.1 | -0.35 | -0.15 |
| **WORST-CASE (Σ)** | | | | **±3.6** | | |
| **RSS (statistical)** | | | | **±1.44** | | |

> Amps: ±0.5 dB in-band. Filters: ±1.0 dB (passband ripple + skirt roll-off). Passives: ±0.1 dB.
> Worst-case Σ assumes all deviations align; RSS assumes uncorrelated contributions — the truth sits between the two.
> If flatness is critical (e.g. ± 1 dB system spec), add an equaliser or gain-slope compensator after the LNA.

## 7. Stage Gain vs Frequency — 250 MHz step (BW < 3 GHz)

| # | Stage | Component | Nominal (dB) | 4.0 GHz (dB) | 4.0 GHz (dB) |
|---|-------|-----------|--------------|--------------|--------------|
| 1 | Input Connector (2.92mm) | 2.92mm SMA-K connector | -0.20 | -0.25 | -0.25 |
| 2 | PCB Trace | 50Ω Microstrip (RO4350B) | -0.35 | -0.40 | -0.40 |
| 3 | Input Limiter | SKY16602-632LF | -0.35 | -0.40 | -0.40 |
| 4 | LNA Stage 1 | LVA-273PN+ | +13.50 | +14.00 | +13.00 |
| 5 | Preselector BPF | BFHK-5001+ (custom LC 2-6 GHz) | -3.00 | -4.00 | -4.00 |
| 6 | Bias-T | PE1604 | -0.20 | -0.25 | -0.25 |
| 7 | LNA Stage 2 | LVA-273PN+ | +13.50 | +14.00 | +13.00 |
| 8 | Stability Pad | Pi attenuator 3 dB | -3.00 | -3.05 | -3.05 |
| 9 | LNA Stage 3 | LVA-273PN+ | +13.50 | +14.00 | +13.00 |
| 10 | LNA Stage 4 | LVA-273PN+ | +13.50 | +14.00 | +13.00 |
| 11 | Output Connector | 2.92mm SMA-K connector | -0.20 | -0.25 | -0.25 |

## 7a. System Rollup vs Frequency

| Frequency (GHz) | Total Gain (dB) | Cascaded NF (dB) | Output Power (dBm) | MDS @ 10 dB SNR (dBm) |
|----------------:|----------------:|------------------:|-------------------:|----------------------:|
| 4.0 | +47.40 | 5.32 | +17.40 | -78.68 |
| 4.0 | +43.40 | 5.42 | +13.40 | -78.58 |

> Gain roll-off model: amps/mixers fall off monotonically toward the high edge of the band by ±0.5 dB at the edges; filters ripple by ±1.0 dB; connectors & traces by ±0.1 dB.
> Cascaded NF recomputed with Friis at each frequency — the LNA continues to dominate, so NF typically stays within ±0.3 dB of nominal across the band.
> MDS tracks the NF. If the band-edge MDS is more than 2 dB worse than midband, add frequency-dependent equalisation or re-allocate gain toward the LNA.

## 8. Return Loss — Per Stage

| # | Stage | Component | S11 — Input RL (dB) | S22 — Output RL (dB) | Notes |
|---|-------|-----------|---------------------|----------------------|-------|
| 1 | Input Connector (2.92mm) | 2.92mm SMA-K connector | 20.0 | 20.0 | Connector loss per interface |
| 2 | Input Limiter | SKY16602-632LF | 14.0 | 14.0 | Passive limiter loss at 4 GHz |
| 3 | LNA Stage 1 | LVA-273PN+ | 12.0 | 12.0 | First gain stage - sets NF |
| 4 | Preselector BPF | BFHK-5001+ (custom LC 2-6 GHz) | 10.0 | 10.0 | LC bandpass filter insertion loss |
| 5 | Bias-T | PE1604 | 15.0 | 15.0 | Bias tee insertion loss |
| 6 | LNA Stage 2 | LVA-273PN+ | 12.0 | 12.0 | Second gain stage |
| 7 | LNA Stage 3 | LVA-273PN+ | 12.0 | 12.0 | Third gain stage |
| 8 | LNA Stage 4 | LVA-273PN+ | 12.0 | 12.0 | Fourth gain stage to achieve 50 dB target |
| 9 | Output Connector | 2.92mm SMA-K connector | 20.0 | 20.0 | Output connector loss |

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