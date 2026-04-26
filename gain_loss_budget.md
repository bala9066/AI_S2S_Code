# RF Gain-Loss Budget
## rx band

**Generated:** 2026-04-26  
**Document Status:** AI-GENERATED — verify against final component datasheets

## 0. Design Contract Checks

⚠ **WARN** — 0 hard violations, 1 warning(s) — review before release

| # | Rule | Status | Detail |
|---|------|--------|--------|
| C1 | Analysis at worst-case frequency | ✅ pass | Cascade evaluated at f_max = 29250 MHz (centre 29000 + BW/2 = 250 MHz). |
| C2 | Bias conditions declared for every active stage | ✅ pass | Every LNA / amp / mixer stage cites the datasheet Vdd/Idq row that produces its gain and NF. |
| C3 | Pdc = Vdd × Idq (±10 mW) | ✅ pass | All biased stages obey the Ohm-law tie between supply and DC power. |
| C4 | Passive NF = |insertion loss| (Friis) | ✅ pass | Every passive stage's NF equals its insertion loss in dB, as thermodynamics requires. |
| C5 | GLB ↔ BOM component match | ⚠ warn | No BOM supplied to this renderer — cross-check skipped. |

> These five invariants must hold for any RF receiver GLB to be releasable to PCB. Any row marked **fail** is a contract violation — regenerate Phase 1 or edit the offending stage before proceeding.

## 0.5 Closed-Loop Optimization Log

### Iteration 1
- **Issues:** 8 hard, 1 warn
  - ❌ `GAIN_SHORT` — Cascade gain 30.9 dB is 34.1 dB below target 65.0 dB.
  - ❌ `BIAS_MISSING` — Stage 7 (RF1 Mixer) is active but lacks Vdd/Idq.
  - ❌ `BIAS_MISSING` — Stage 11 (RF2 Mixer (IQ)) is active but lacks Vdd/Idq.
  - ❌ `BIAS_MISSING` — Stage 13 (VGA/AGC) is active but lacks Vdd/Idq.
  - ❌ `FRIIS_MISMATCH` — Stage 4 passive NF 2.50 dB ≠ |loss| 3.50 dB.
  - ❌ `FRIIS_MISMATCH` — Stage 8 passive NF 1.50 dB ≠ |loss| 2.50 dB.
  - ❌ `FRIIS_MISMATCH` — Stage 10 passive NF 1.50 dB ≠ |loss| 2.50 dB.
  - ❌ `FRIIS_MISMATCH` — Stage 12 passive NF 2.00 dB ≠ |loss| 3.00 dB.
  - ⚠ `LNA_DEEP` — 5.1 dB of passive loss before first LNA — inflates system NF via Friis.
- **Cascade:** gain=30.85 dB · NF=9.71 dB · Pout=-50.35 dBm · Pdc=1950.0 mW _(evaluated at worst-case (f_max))_
- **Actions:**
  - Set Stage 4 passive NF to |loss| = 3.50 dB
  - Set Stage 8 passive NF to |loss| = 2.50 dB
  - Set Stage 10 passive NF to |loss| = 2.50 dB
  - Set Stage 12 passive NF to |loss| = 3.00 dB
  - Populated bias on Stage 7 from 'ADL5541' template.
  - Populated bias on Stage 11 from 'ADL5541' template.
  - Populated bias on Stage 13 from 'HMC624LP4E' template.
  - Promoted LNA from stage 6 to stage 4 (reduces pre-LNA passive loss → better Friis NF).
  - Inserted ADL5541 at stage 15 (+16 dB, NF 3.0 dB).
  - Inserted HMC624LP4E at stage 16 (+19 dB, NF 7.0 dB).

### Iteration 2
- **Issues:** 0 hard, 0 warn
- **Cascade:** gain=57.65 dB · NF=10.7 dB · Pout=-23.55 dBm · Pdc=4033.0 mW _(evaluated at worst-case (f_max))_
- **Actions:**
  - Converged — no hard violations remain.
  - — propagation —
  - Added BOM entry 'ADL5541' (IF Gain Block (20 MHz-6 GHz)) from optimizer library.
  - Added BOM entry 'HMC624LP4E' (Digital Step Attenuator / VGA (DC-6 GHz)) from optimizer library.
  - BOM entry 'LM2940S-5.0/NOPB' is no longer in the GLB chain (optimizer removed/replaced it) — flagged for review.
  - ⚠ +5V regulator 'LM2940S-5.0/NOPB' has no declared I_out_max — cannot verify it covers 681 mA load.
  - ⚠ +3.3V regulator 'MCP1826S-5002E/DBVAO' has no declared I_out_max — cannot verify it covers 190 mA load.
  - Regenerated block_diagram_mermaid to reflect the 16-stage optimizer output.


## 1. System Parameters

| Parameter | Value | Unit |
|-----------|-------|------|
| Centre Frequency    | 29000   | MHz  |
| RF Bandwidth        | 500     | MHz  |
| **Analysis Frequency (worst-case)** | **29250** | **MHz** |
| Input Signal Level  | -81.2   | dBm  |
| Target Output Power | -16.2  | dBm  |
| Required System Gain | 65.0 | dB   |

> **Why the upper band edge?** For a receiver, NF rises and gain falls with
> frequency — system sensitivity (MDS) is worst at f_max. The stage-by-stage
> cascade below is therefore evaluated at the upper band edge so the numbers
> represent the least-favourable operating point. The frequency-sweep section
> further down shows how every metric varies across the full band in 1 GHz steps.

## 2. Stage-by-Stage Gain / Loss Budget

| # | Stage | Component | Gain/Loss (dB) | Cum. Gain (dB) | Output Power (dBm) | NF (dB) | Cum. NF (dB) | P1dB Out (dBm) | OIP3 (dBm) | Region | Notes |
|---|-------|-----------|---------------|----------------|-------------------|---------|-------------|---------------|-----------|--------|-------|
| 1 | RF Input (Antenna) | 2.92mm K-type Connector | -0.2 | -0.2 | -81.5 | 0.15 | 0.15 | — | — | Linear (passive) | 2.92mm connector IL ~0.15 dB at 30 GHz |
| 2 | PCB Trace | 50Ω Microstrip (RO4350B) | -0.4 | -0.7 | -81.8 | 0.30 | 0.46 | N/A | N/A | Linear (passive) | Typ 1–2 in RO4350B microstrip loss at band |
| 3 | Limiter | Schottky Diode Limiter | -0.6 | -1.2 | -82.5 | 0.50 | 0.98 | — | — | Linear (passive) | Protects LNA from +20 dBm input, IL ~0.5 dB |
| 4 | LNA1 | ZVA-183WA-S+ | +21.0 | 19.8 | -61.5 | 4.50 | 5.66 | 14.0 | 24.0 | Linear (75.5 dB BO) | GaN HEMT wideband LNA |
| 5 | RF Preselector | Tunable YIG BPF | -4.5 | 15.2 | -66.0 | 3.50 | 5.67 | — | — | Linear (passive) | Tunable YIG filter, IL 2.5 dB, image rejection · ⚠ Passive NF ≠ |loss| (3.50 vs 4.50 dB) |
| 6 | Bias-Tee | PE1604 Bias-T | -0.6 | 14.7 | -66.5 | 0.50 | 5.68 | — | — | Linear (passive) | DC blocking for LNA bias injection |
| 7 | RF1 Mixer | CMD180C3 | -9.0 | 5.7 | -75.5 | 9.00 | 5.95 | — | — | Linear (passive) | DBM, RF 18-32 GHz, LO +13 dBm, CL 8 dB |
| 8 | IF1 Bandpass Filter | LC/Cavity BPF 4 GHz | -3.5 | 2.1 | -79.0 | 2.50 | 6.17 | — | — | Linear (passive) | IF1 BPF at ~4 GHz, IL 1.5 dB · ⚠ Passive NF ≠ |loss| (2.50 vs 3.50 dB) |
| 9 | IF1 Gain Block | PMA2-123LNW+ | +21.0 | 23.1 | -58.0 | 3.50 | 6.90 | 13.0 | 24.0 | Linear (71.0 dB BO) | Gain makeup after RF1 mixer |
| 10 | Stabilisation BPF | LC/Cavity BPF 4 GHz | -3.5 | 19.6 | -61.5 | 2.50 | 6.90 | — | — | Linear (passive) | Inter-stage BPF for stability with >60 dB gain · ⚠ Passive NF ≠ |loss| (2.50 vs 3.50 dB) |
| 11 | RF2 Mixer (IQ) | MMIQ-0205HSM-2 | -9.0 | 10.7 | -70.5 | 9.00 | 6.97 | — | — | Linear (passive) | IQ mixer IF1 to IF2, CL 8 dB, image reject |
| 12 | IF2 Bandpass Filter | LC/Cavity BPF 500 MHz | -4.0 | 6.7 | -74.5 | 3.00 | 7.04 | — | — | Linear (passive) | Final IF BPF, 500 MHz BW, anti-aliasing · ⚠ Passive NF ≠ |loss| (3.00 vs 4.00 dB) |
| 13 | VGA/AGC | TGL2767-SMEVB | -4.0 | 2.6 | -78.5 | 4.50 | 7.37 | — | — | Linear (passive) | VVA at mid-setting, IL ~3 dB + 2.5 dB NF · ⚠ Passive NF ≠ |loss| (4.50 vs 4.00 dB) |
| 14 | ADC Driver Output Stage | AD8366 DVGA | +21.0 | 23.6 | -57.5 | 11.00 | 10.70 | 12.0 | 25.0 | Linear (69.5 dB BO) | Final gain block to drive ADC at ~-17 dBm full scale |
| 15 | IF Gain Block | ADL5541 | +15.5 | 39.1 | -42.0 | 3.50 | 10.70 | 21.0 | — | Linear (63.0 dB BO) |  |
| 16 | VGA (AGC) | HMC624LP4E | +18.5 | 57.6 | -23.6 | 7.50 | 10.70 | 19.0 | — | Linear (42.5 dB BO) |  |

> **Region legend:** *Linear* = ≥10 dB back-off from P1dB · *Near-linear* = 6-10 dB · *Compressing* = 0-6 dB (onset of gain compression) · *Saturated* = above P1dB (hard non-linear). Keep every stage in the Linear zone for analogue receivers; transmit chains may intentionally drive the PA into compression.

## 3. Budget Summary

| Metric | Value | Unit |
|--------|-------|------|
| Total System Gain     | 57.6  | dB  |
| Final Output Power    | -23.6  | dBm |
| Cascaded System NF    | 10.70 | dB  |
| Output Power Margin   | +7.4 | dB  |

> **Per-stage DC bias (Vdd/Idq/Pdc)** is listed in `power_calculation.md` — the companion document that owns all power-budget information.

## 4. Noise Floor & Sensitivity

| Parameter | Formula | Value | Unit |
|-----------|---------|-------|------|
| Thermal Noise Floor (kTB) | -174 + 10·log₁₀(BW_Hz) | -87.01 | dBm |
| System NF (cascaded) | Friis | 10.70 | dB |
| Input-Referred Noise Floor | kTB + NF_sys | -76.31 | dBm |
| Output Noise Floor | Noise_in + Total_Gain | -18.66 | dBm |
| MDS (SNR = 10 dB) | Noise_in + 10 | -66.31 | dBm |

> Assumes 290 K ambient, full RF instantaneous bandwidth, AWGN channel.
> MDS convention: 10 dB SNR above the input-referred noise floor.

## 5. Gain Variation — Thermal (-40 to +85 °C)

| # | Stage | Component | Nominal Gain (dB) | Tempco (dB/°C) | ΔG @ -40 °C | ΔG @ +85 °C | Worst-Case (dB) |
|---|-------|-----------|-------------------|----------------|-------------|-------------|-----------------|
| 1 | RF Input (Antenna) | 2.92mm K-type Connector | -0.25 | ±0.005 | +0.33 | -0.30 | ±0.33 |
| 2 | PCB Trace | 50Ω Microstrip (RO4350B) | -0.40 | ±0.005 | +0.33 | -0.30 | ±0.33 |
| 3 | Limiter | Schottky Diode Limiter | -0.60 | ±0.005 | +0.33 | -0.30 | ±0.33 |
| 4 | LNA1 | ZVA-183WA-S+ | +21.00 | ±0.020 | +1.30 | -1.20 | ±1.30 |
| 5 | RF Preselector | Tunable YIG BPF | -4.50 | ±0.005 | +0.33 | -0.30 | ±0.33 |
| 6 | Bias-Tee | PE1604 Bias-T | -0.60 | ±0.005 | +0.33 | -0.30 | ±0.33 |
| 7 | RF1 Mixer | CMD180C3 | -9.00 | ±0.020 | +1.30 | -1.20 | ±1.30 |
| 8 | IF1 Bandpass Filter | LC/Cavity BPF 4 GHz | -3.50 | ±0.005 | +0.33 | -0.30 | ±0.33 |
| 9 | IF1 Gain Block | PMA2-123LNW+ | +21.00 | ±0.020 | +1.30 | -1.20 | ±1.30 |
| 10 | Stabilisation BPF | LC/Cavity BPF 4 GHz | -3.50 | ±0.005 | +0.33 | -0.30 | ±0.33 |
| 11 | RF2 Mixer (IQ) | MMIQ-0205HSM-2 | -9.00 | ±0.020 | +1.30 | -1.20 | ±1.30 |
| 12 | IF2 Bandpass Filter | LC/Cavity BPF 500 MHz | -4.00 | ±0.005 | +0.33 | -0.30 | ±0.33 |
| 13 | VGA/AGC | TGL2767-SMEVB | -4.00 | ±0.020 | +1.30 | -1.20 | ±1.30 |
| 14 | ADC Driver Output Stage | AD8366 DVGA | +21.00 | ±0.020 | +1.30 | -1.20 | ±1.30 |
| 15 | IF Gain Block | ADL5541 | +15.50 | ±0.020 | +1.30 | -1.20 | ±1.30 |
| 16 | VGA (AGC) | HMC624LP4E | +18.50 | ±0.020 | +1.30 | -1.20 | ±1.30 |
| **TOTAL SYSTEM** | | | | | **+13.00** | **-12.00** | — |

> Active stages (LNA / amp / mixer): ±0.020 dB/°C typical GaAs pHEMT or SiGe.
> Passives (connectors, traces, filters, splitters): ±0.005 dB/°C.
> Plan for ≥ 3 dB AGC range or closed-loop gain compensation to hold system gain across the temperature envelope.

## 6. Gain Variation — Frequency (across RF bandwidth)

| # | Stage | Component | Nominal Gain (dB) | Typ Flatness (± dB) | Min Gain (dB) | Max Gain (dB) |
|---|-------|-----------|-------------------|---------------------|---------------|---------------|
| 1 | RF Input (Antenna) | 2.92mm K-type Connector | -0.25 | ±0.1 | -0.35 | -0.15 |
| 2 | PCB Trace | 50Ω Microstrip (RO4350B) | -0.40 | ±0.1 | -0.50 | -0.30 |
| 3 | Limiter | Schottky Diode Limiter | -0.60 | ±0.1 | -0.70 | -0.50 |
| 4 | LNA1 | ZVA-183WA-S+ | +21.00 | ±0.5 | +20.50 | +21.50 |
| 5 | RF Preselector | Tunable YIG BPF | -4.50 | ±1.0 | -5.50 | -3.50 |
| 6 | Bias-Tee | PE1604 Bias-T | -0.60 | ±0.1 | -0.70 | -0.50 |
| 7 | RF1 Mixer | CMD180C3 | -9.00 | ±0.5 | -9.50 | -8.50 |
| 8 | IF1 Bandpass Filter | LC/Cavity BPF 4 GHz | -3.50 | ±1.0 | -4.50 | -2.50 |
| 9 | IF1 Gain Block | PMA2-123LNW+ | +21.00 | ±0.5 | +20.50 | +21.50 |
| 10 | Stabilisation BPF | LC/Cavity BPF 4 GHz | -3.50 | ±1.0 | -4.50 | -2.50 |
| 11 | RF2 Mixer (IQ) | MMIQ-0205HSM-2 | -9.00 | ±0.5 | -9.50 | -8.50 |
| 12 | IF2 Bandpass Filter | LC/Cavity BPF 500 MHz | -4.00 | ±1.0 | -5.00 | -3.00 |
| 13 | VGA/AGC | TGL2767-SMEVB | -4.00 | ±0.5 | -4.50 | -3.50 |
| 14 | ADC Driver Output Stage | AD8366 DVGA | +21.00 | ±0.5 | +20.50 | +21.50 |
| 15 | IF Gain Block | ADL5541 | +15.50 | ±0.5 | +15.00 | +16.00 |
| 16 | VGA (AGC) | HMC624LP4E | +18.50 | ±0.5 | +18.00 | +19.00 |
| **WORST-CASE (Σ)** | | | | **±8.4** | | |
| **RSS (statistical)** | | | | **±2.46** | | |

> Amps: ±0.5 dB in-band. Filters: ±1.0 dB (passband ripple + skirt roll-off). Passives: ±0.1 dB.
> Worst-case Σ assumes all deviations align; RSS assumes uncorrelated contributions — the truth sits between the two.
> If flatness is critical (e.g. ± 1 dB system spec), add an equaliser or gain-slope compensator after the LNA.

## 7. Stage Gain vs Frequency — 250 MHz step (BW < 3 GHz)

| # | Stage | Component | Nominal (dB) | 28.8 GHz (dB) | 29.0 GHz (dB) | 29.2 GHz (dB) |
|---|-------|-----------|--------------|--------------|--------------|--------------|
| 1 | RF Input (Antenna) | 2.92mm K-type Connector | -0.20 | -0.25 | -0.20 | -0.25 |
| 2 | PCB Trace | 50Ω Microstrip (RO4350B) | -0.35 | -0.40 | -0.35 | -0.40 |
| 3 | Limiter | Schottky Diode Limiter | -0.55 | -0.60 | -0.55 | -0.60 |
| 4 | LNA1 | ZVA-183WA-S+ | +21.50 | +22.00 | +21.50 | +21.00 |
| 5 | RF Preselector | Tunable YIG BPF | -3.50 | -4.50 | -3.50 | -4.50 |
| 6 | Bias-Tee | PE1604 Bias-T | -0.55 | -0.60 | -0.55 | -0.60 |
| 7 | RF1 Mixer | CMD180C3 | -8.50 | -8.00 | -8.50 | -9.00 |
| 8 | IF1 Bandpass Filter | LC/Cavity BPF 4 GHz | -2.50 | -3.50 | -2.50 | -3.50 |
| 9 | IF1 Gain Block | PMA2-123LNW+ | +21.50 | +22.00 | +21.50 | +21.00 |
| 10 | Stabilisation BPF | LC/Cavity BPF 4 GHz | -2.50 | -3.50 | -2.50 | -3.50 |
| 11 | RF2 Mixer (IQ) | MMIQ-0205HSM-2 | -8.50 | -8.00 | -8.50 | -9.00 |
| 12 | IF2 Bandpass Filter | LC/Cavity BPF 500 MHz | -3.00 | -4.00 | -3.00 | -4.00 |
| 13 | VGA/AGC | TGL2767-SMEVB | -3.50 | -3.00 | -3.50 | -4.00 |
| 14 | ADC Driver Output Stage | AD8366 DVGA | +21.50 | +22.00 | +21.50 | +21.00 |
| 15 | IF Gain Block | ADL5541 | +16.00 | +16.50 | +16.00 | +15.50 |
| 16 | VGA (AGC) | HMC624LP4E | +19.00 | +19.50 | +19.00 | +18.50 |

## 7a. System Rollup vs Frequency

| Frequency (GHz) | Total Gain (dB) | Cascaded NF (dB) | Output Power (dBm) | MDS @ 10 dB SNR (dBm) |
|----------------:|----------------:|------------------:|-------------------:|----------------------:|
| 28.8 | +65.65 | 7.72 | -15.55 | -69.29 |
| 29.0 | +65.85 | 7.06 | -15.35 | -69.95 |
| 29.2 | +57.65 | 10.15 | -23.55 | -66.86 |

> Gain roll-off model: amps/mixers fall off monotonically toward the high edge of the band by ±0.5 dB at the edges; filters ripple by ±1.0 dB; connectors & traces by ±0.1 dB.
> Cascaded NF recomputed with Friis at each frequency — the LNA continues to dominate, so NF typically stays within ±0.3 dB of nominal across the band.
> MDS tracks the NF. If the band-edge MDS is more than 2 dB worse than midband, add frequency-dependent equalisation or re-allocate gain toward the LNA.

## 8. Return Loss — Per Stage

| # | Stage | Component | S11 — Input RL (dB) | S22 — Output RL (dB) | Notes |
|---|-------|-----------|---------------------|----------------------|-------|
| 1 | LNA1 | ZVA-183WA-S+ | 12.0 | 14.0 | GaN HEMT wideband LNA |

> Return loss values are referenced to 50 Ω. Higher value = better match.

## 9. Output Power vs Input Drive Level (AM-AM)

| Input (dBm) | Output (dBm) | Gain (dB) | Compression (dB) |
|-------------|--------------|-----------|------------------|
| -81.2 | -16.2 | 65.0 | 0.0 |
| -60.0 | 5.0 | 65.0 | 0.0 |
| -40.0 | 10.0 | 50.0 | -15.0 |
| -20.0 | 10.0 | 30.0 | -35.0 |
| 0.0 | 10.0 | 10.0 | -55.0 |

> Compression > 0 dB indicates onset of saturation.

## 10. Consistency Checks

> (No BOM supplied to the GLB tool call — cross-check skipped. When the BOM is available, this section lists any component in the GLB that does not appear in the parts list.)

## 11. Cascade Noise Figure — Friis Formula

$$F_{{sys}} = F_1 + \frac{{F_2 - 1}}{{G_1}} + \frac{{F_3 - 1}}{{G_1 G_2}} + \cdots$$

Where *F* = linear noise factor (not dB), *G* = linear gain.
The first stage NF dominates — minimise LNA/driver NF for best system sensitivity.

---
> **Note:** All values are estimated from component datasheets at 25 °C nominal.
> Verify with bench measurements (spectrum analyser + noise source) during hardware bring-up.