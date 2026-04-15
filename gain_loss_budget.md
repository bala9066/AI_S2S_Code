# RF Gain-Loss Budget
## uyj

**Generated:** 2026-04-15  
**Document Status:** AI-GENERATED — verify against final component datasheets

## 1. System Parameters

| Parameter | Value | Unit |
|-----------|-------|------|
| Centre Frequency    | 11500   | MHz  |
| RF Bandwidth        | 3000     | MHz  |
| Input Signal Level  | -30   | dBm  |
| Target Output Power | 0  | dBm  |
| Required System Gain | 30 | dB   |

## 2. Stage-by-Stage Gain / Loss Budget

| # | Stage | Component | Gain/Loss (dB) | Cum. Gain (dB) | Output Power (dBm) | NF (dB) | Cum. NF (dB) | P1dB Out (dBm) | OIP3 (dBm) | Notes |
|---|-------|-----------|---------------|----------------|-------------------|---------|-------------|---------------|-----------|-------|
| 1 | RF Input Protection | HMC1061LP4E + limiters | -1.0 | -1.0 | -31.0 | 1.00 | 1.00 | 30.0 | 50.0 | Limiter protection, insertion loss |
| 2 | Wideband LNA | HMC1099LP5DE | +20.0 | 19.0 | -11.0 | 2.50 | 2.58 | 30.0 | 45.0 | GaN LNA, high OIP3 for linearity |
| 3 | Digital VGA | HMC698LP4 (digital VGA) | +0.0 | 19.0 | -11.0 | 6.00 | 2.59 | 25.0 | 40.0 | 0dB nominal, ±15dB range available |
| 4 | Input Matching Network | LC matching + transmission lines | -0.5 | 18.5 | -11.5 | 0.50 | 2.62 | N/A | N/A | ADC input matching network |
| 5 | ADC Input Driver | ADC12DJ5200RF internal | +0.0 | 18.5 | -11.5 | 30.00 | 5.59 | 4.0 | N/A | ADC full scale -1.5dBFS = -11.5dBm input, 30dB NF |

## 3. Budget Summary

| Metric | Value | Unit |
|--------|-------|------|
| Total System Gain     | 18.5  | dB  |
| Final Output Power    | -11.5  | dBm |
| Cascaded System NF    | 5.59 | dB  |
| Output Power Margin   | +11.5 | dB  |

## 4. Return Loss — Per Stage

| # | Stage | Component | S11 — Input RL (dB) | S22 — Output RL (dB) | Notes |
|---|-------|-----------|---------------------|----------------------|-------|
| 1 | RF Input Protection | HMC1061LP4E + limiters | 20.0 | 20.0 | Limiter protection, insertion loss |
| 2 | Wideband LNA | HMC1099LP5DE | 15.0 | 12.0 | GaN LNA, high OIP3 for linearity |
| 3 | Digital VGA | HMC698LP4 (digital VGA) | 15.0 | 15.0 | 0dB nominal, ±15dB range available |
| 4 | Input Matching Network | LC matching + transmission lines | 20.0 | 20.0 | ADC input matching network |
| 5 | ADC Input Driver | ADC12DJ5200RF internal | 15.0 | 99.0 | ADC full scale -1.5dBFS = -11.5dBm input, 30dB NF |

> Return loss values are referenced to 50 Ω. Higher value = better match.

## 5. Harmonic Rejection

| Harmonic Order | Frequency (MHz) | Expected Rejection (dBc) | Required Spec (dBc) | Pass/Fail |
|----------------|-----------------|--------------------------|---------------------|-----------|
| 2H | 23000 | 60.0 | 40.0 | ✓ PASS |

> Higher rejection (more negative dBc) is better. Filter may be required if spec is not met.

## 6. Output Power vs Frequency

| Frequency (MHz) | Output Power (dBm) | Gain (dB) | Flatness (dB) |
|-----------------|--------------------|-----------|---------------|
| 5000 | -11.5 | 18.5 | -0.8 |
| 11500 | -11.5 | 18.5 | +0.0 |
| 18000 | -11.5 | 18.5 | +1.2 |

> Flatness measured relative to midband output power.

## 7. Output Power vs Input Drive Level (AM-AM)

| Input (dBm) | Output (dBm) | Gain (dB) | Compression (dB) |
|-------------|--------------|-----------|------------------|
| -50.0 | -31.5 | 18.5 | 0.0 |
| -30.0 | -11.5 | 18.5 | 0.0 |
| -10.0 | 8.5 | 18.5 | -0.1 |
| 0.0 | 17.0 | 17.0 | -1.5 |
| 10.0 | 23.5 | 13.5 | -5.0 |

> Compression > 0 dB indicates onset of saturation.

## 8. Cable & Connector Loss Budget

| Segment | Cable/Connector Type | Length (m) | Loss/m (dB/m) | Total Loss (dB) | Frequency (MHz) |
|---------|----------------------|------------|---------------|-----------------|-----------------|
| RF Input to PCB | SMA edge connector | — | 0.000 | 0.30 | 11500 |
| PCB transmission lines | Rogers RO4003C microstrip | 0.1 | 5.000 | 0.50 | 11500 |
| **TOTAL** | | | | **0.8** | |

> Cable loss must be compensated by additional gain or accepted as part of system link budget.

## 9. Cascade Noise Figure — Friis Formula

$$F_{{sys}} = F_1 + \frac{{F_2 - 1}}{{G_1}} + \frac{{F_3 - 1}}{{G_1 G_2}} + \cdots$$

Where *F* = linear noise factor (not dB), *G* = linear gain.
The first stage NF dominates — minimise LNA/driver NF for best system sensitivity.

---
> **Note:** All values are estimated from component datasheets at 25 °C nominal.
> Verify with bench measurements (spectrum analyser + noise source) during hardware bring-up.