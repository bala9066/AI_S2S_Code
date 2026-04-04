# Programming Sequence (PSQ)
## fjxm

> **Total steps:** 5

| # | Phase | Register | Address | Value | Condition | Rationale |
|---|-------|----------|---------|-------|-----------|-----------|
| 1 | Hardware Configuration | `N/A - Analog Component Selection` | `N/A` | `See Datasheet` | Fixed at design time | All control parameters are set by passive component values (RSET, RT, CSS, etc.) selected during schematic design. No runtime configuration possible. |
| 2 | Power-Up Sequence | `N/A - Self-Starting` | `N/A` | `Automatic` | VIN > UVLO threshold (~38V) | The UCC28951A has built-in UVLO with hysteresis. When input voltage exceeds threshold (set by R1/R2 divider: 100k/15k), the controller automatically begins its soft-start sequence. |
| 3 | Soft-Start | `N/A - CSS Pin` | `N/A` | `C9 = 100nF capacitor` | Wait ~5ms for SS to complete | Soft-start timing determined by external capacitor on SS pin (100nF). Internal 10µA source charges CSS. Output voltage ramps up gradually, limiting inrush current. |
| 4 | Normal Operation | `N/A - Analog Feedback Loop` | `N/A` | `Self-regulating` | Continuous | Output voltage regulation is achieved through analog feedback from secondary-side sensing (R6/R7 dividers) coupled through opto-isolator to COMP pin. No firmware intervention required. |
| 5 | Protection Monitoring | `N/A - OCP/SCP/OLP` | `N/A` | `Hardware Auto-Protection` | Always active | UCC28951A provides built-in Over-Current Protection (via ISNS pin), Short-Circuit Protection, and Over-Load Protection. Fault conditions cause automatic shutdown without firmware intervention. |

---

## Detailed Steps

### Step 1 — Hardware Configuration
- **Register:** `N/A - Analog Component Selection` at `N/A`
- **Write value:** `See Datasheet`
- **Wait/Poll:** Fixed at design time
- **Rationale:** All control parameters are set by passive component values (RSET, RT, CSS, etc.) selected during schematic design. No runtime configuration possible.

### Step 2 — Power-Up Sequence
- **Register:** `N/A - Self-Starting` at `N/A`
- **Write value:** `Automatic`
- **Wait/Poll:** VIN > UVLO threshold (~38V)
- **Rationale:** The UCC28951A has built-in UVLO with hysteresis. When input voltage exceeds threshold (set by R1/R2 divider: 100k/15k), the controller automatically begins its soft-start sequence.

### Step 3 — Soft-Start
- **Register:** `N/A - CSS Pin` at `N/A`
- **Write value:** `C9 = 100nF capacitor`
- **Wait/Poll:** Wait ~5ms for SS to complete
- **Rationale:** Soft-start timing determined by external capacitor on SS pin (100nF). Internal 10µA source charges CSS. Output voltage ramps up gradually, limiting inrush current.

### Step 4 — Normal Operation
- **Register:** `N/A - Analog Feedback Loop` at `N/A`
- **Write value:** `Self-regulating`
- **Wait/Poll:** Continuous
- **Rationale:** Output voltage regulation is achieved through analog feedback from secondary-side sensing (R6/R7 dividers) coupled through opto-isolator to COMP pin. No firmware intervention required.

### Step 5 — Protection Monitoring
- **Register:** `N/A - OCP/SCP/OLP` at `N/A`
- **Write value:** `Hardware Auto-Protection`
- **Wait/Poll:** Always active
- **Rationale:** UCC28951A provides built-in Over-Current Protection (via ISNS pin), Short-Circuit Protection, and Over-Load Protection. Fault conditions cause automatic shutdown without firmware intervention.
