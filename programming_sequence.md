# Programming Sequence (PSQ)
## tf

> **Total steps:** 8

| # | Phase | Register | Address | Value | Condition | Rationale |
|---|-------|----------|---------|-------|-----------|-----------|
| 1 | Physical Connection | `J4 Header` | `Hardware` | `Connect GND` | Verify pin 3 grounded | Establish ground reference for ESD clamp and logic levels |
| 2 | Thermal Monitor Setup | `J4 Pin 2` | `Hardware` | `THERM_STATUS to ADC` | Continuity check | Enable thermal monitoring path from R3 thermistor divider |
| 3 | Power Rail Verification | `J3 DC Power` | `Hardware` | `Apply 12V DC` | Measure VDD_PA (U1 pin) = 12V ±5% | Verify power input filtering and ferrite bead (FB1) functionality |
| 4 | Gate Bias Check | `U1 Gate` | `Hardware` | `Measure VGG_GATE` | Verify negative bias present (typical -2.5V to -4V) | Confirm R1 divider provides proper GaN gate bias before enable |
| 5 | Enable Activation | `J4 Pin 1` | `Hardware` | `Apply TTL HIGH (3.3V or 5V)` | Wait 100us for PA enable | Drive Q1 BJT to pull C6 high, enabling PA through U1 enable pin |
| 6 | RF Path Verification | `RF Chain` | `Hardware` | `Apply 2.4 GHz test signal` | Measure J2 output +40 dBm typical | Verify full RF amplification path: J1→C1/L1/L3→U1→L2/L4→C4→J2 |
| 7 | Thermal Check | `Thermal Monitor` | `Hardware` | `Monitor THERM_STATUS voltage` | V_therm < overtemp threshold | Verify R3 thermistor indicates safe operating temperature under load |
| 8 | Shutdown Sequence | `J4 Pin 1` | `Hardware` | `Apply TTL LOW (0V)` | Wait 10us for PA disable | Turn off PA before removing 12V power to prevent damage |

---

## Detailed Steps

### Step 1 — Physical Connection
- **Register:** `J4 Header` at `Hardware`
- **Write value:** `Connect GND`
- **Wait/Poll:** Verify pin 3 grounded
- **Rationale:** Establish ground reference for ESD clamp and logic levels

### Step 2 — Thermal Monitor Setup
- **Register:** `J4 Pin 2` at `Hardware`
- **Write value:** `THERM_STATUS to ADC`
- **Wait/Poll:** Continuity check
- **Rationale:** Enable thermal monitoring path from R3 thermistor divider

### Step 3 — Power Rail Verification
- **Register:** `J3 DC Power` at `Hardware`
- **Write value:** `Apply 12V DC`
- **Wait/Poll:** Measure VDD_PA (U1 pin) = 12V ±5%
- **Rationale:** Verify power input filtering and ferrite bead (FB1) functionality

### Step 4 — Gate Bias Check
- **Register:** `U1 Gate` at `Hardware`
- **Write value:** `Measure VGG_GATE`
- **Wait/Poll:** Verify negative bias present (typical -2.5V to -4V)
- **Rationale:** Confirm R1 divider provides proper GaN gate bias before enable

### Step 5 — Enable Activation
- **Register:** `J4 Pin 1` at `Hardware`
- **Write value:** `Apply TTL HIGH (3.3V or 5V)`
- **Wait/Poll:** Wait 100us for PA enable
- **Rationale:** Drive Q1 BJT to pull C6 high, enabling PA through U1 enable pin

### Step 6 — RF Path Verification
- **Register:** `RF Chain` at `Hardware`
- **Write value:** `Apply 2.4 GHz test signal`
- **Wait/Poll:** Measure J2 output +40 dBm typical
- **Rationale:** Verify full RF amplification path: J1→C1/L1/L3→U1→L2/L4→C4→J2

### Step 7 — Thermal Check
- **Register:** `Thermal Monitor` at `Hardware`
- **Write value:** `Monitor THERM_STATUS voltage`
- **Wait/Poll:** V_therm < overtemp threshold
- **Rationale:** Verify R3 thermistor indicates safe operating temperature under load

### Step 8 — Shutdown Sequence
- **Register:** `J4 Pin 1` at `Hardware`
- **Write value:** `Apply TTL LOW (0V)`
- **Wait/Poll:** Wait 10us for PA disable
- **Rationale:** Turn off PA before removing 12V power to prevent damage
