# Programming Sequence (PSQ)
## rf1

> **Total steps:** 22

| # | Phase | Register | Address | Value | Condition | Rationale |
|---|-------|----------|---------|-------|-----------|-----------|
| 1 | Power-On Reset & Identification | `DEVICE_ID` | `0x00` | `0x0000` | Read - verify returns 0xA5C1 | Verify device communication and silicon identification before proceeding with configuration |
| 2 | Power-On Reset & Identification | `REVISION` | `0x01` | `0x0000` | Read - log revision for compatibility | Read silicon revision to support firmware compatibility checks |
| 3 | Power-On Reset & Identification | `FAULT_STATUS` | `0x11` | `0xFFFF` | Write to clear any pre-existing fault bits | Clear any latched fault conditions from previous power cycles before enabling outputs |
| 4 | Protection Configuration | `UVLO_CONFIG` | `0x03` | `0x0E74` | None | Configure UVLO threshold to 35V with 2V hysteresis for 48V nominal input (prevents operation during insufficient input voltage) |
| 5 | Protection Configuration | `RAIL12_OCP_LIMIT` | `0x07` | `0x8FA0` | None | Set 12V rail OCP to 12.0A with latched shutdown (exceeds 10A nominal by 20% for tolerance margin) |
| 6 | Protection Configuration | `RAIL5_OCP_LIMIT` | `0x08` | `0x8BB8` | None | Set 5V rail OCP to 9.0A with latched shutdown (exceeds 8A nominal by 12.5% for margin) |
| 7 | Protection Configuration | `RAIL3V3_OCP_LIMIT` | `0x09` | `0x8E10` | None | Set 3.3V rail OCP to 14.4A with latched shutdown (exceeds 12A nominal by 20% for margin) |
| 8 | Voltage Target Configuration | `RAIL12_TARGET` | `0x04` | `0x0BB8` | None | Set 12V rail target to 12.000V (±1% regulation requirement per HRS) |
| 9 | Voltage Target Configuration | `RAIL5_TARGET` | `0x05` | `0x0320` | None | Set 5V rail target to 5.000V (±2-3% regulation requirement per HRS) |
| 10 | Voltage Target Configuration | `RAIL3V3_TARGET` | `0x06` | `0x0208` | None | Set 3.3V rail target to 3.300V (±2-3% regulation requirement per HRS) |
| 11 | Soft-Start Configuration | `SOFT_START_CONFIG` | `0x0A` | `0x812C` | None | Enable soft-start with 30ms duration (linear ramp) to limit inrush current on all rails simultaneously |
| 12 | Input Voltage Verification | `INPUT_VIN_MON` | `0x12` | `0x0000` | Poll - wait until VIN > 40V and VALID bit set | Verify input voltage is within specified range (40-60V) before enabling any outputs (safety interlock) |
| 13 | Rail Enable Sequence | `GLOBAL_CTRL` | `0x02` | `0x0009` | Wait 1ms | Enable primary 12V rail only first - allows core bias to establish before enabling downstream converters |
| 14 | Rail Enable Sequence | `GLOBAL_CTRL` | `0x02` | `0x000D` | Wait 5ms - poll RAIL12_VOUT_MON for > 11.5V | Enable 5V rail (cascaded from 12V) - verify 12V rail has reached regulation before enabling downstream converters |
| 15 | Rail Enable Sequence | `GLOBAL_CTRL` | `0x02` | `0x000F` | Wait 5ms - poll RAIL5_VOUT_MON for > 4.75V | Enable 3.3V rail (cascaded from 5V) - verify 5V rail regulation before enabling final downstream converter |
| 16 | Startup Verification | `FAULT_STATUS` | `0x11` | `0x0000` | Read - verify no fault bits set | Verify no faults occurred during startup sequence before proceeding to normal operation |
| 17 | Startup Verification | `RAIL12_VOUT_MON` | `0x0B` | `0x0000` | Poll until VALID=1 and VOUT >= 11.88V (within ±1%) | Verify 12V rail has reached regulation within ±1% tolerance per HRS requirements |
| 18 | Startup Verification | `RAIL5_VOUT_MON` | `0x0C` | `0x0000` | Poll until VALID=1 and VOUT >= 4.85V (within ±3%) | Verify 5V rail has reached regulation within ±3% tolerance per HRS requirements |
| 19 | Startup Verification | `RAIL3V3_VOUT_MON` | `0x0D` | `0x0000` | Poll until VALID=1 and VOUT >= 3.20V (within ±3%) | Verify 3.3V rail has reached regulation within ±3% tolerance per HRS requirements |
| 20 | Normal Operation - Monitoring Loop | `RAIL12_IOUT_MON` | `0x0E` | `0x0000` | Continuous monitoring every 100ms | Monitor 12V rail output current for load tracking and thermal management |
| 21 | Normal Operation - Monitoring Loop | `RAIL5_IOUT_MON` | `0x0F` | `0x0000` | Continuous monitoring every 100ms | Monitor 5V rail output current for load tracking and thermal management |
| 22 | Normal Operation - Monitoring Loop | `RAIL3V3_IOUT_MON` | `0x10` | `0x0000` | Continuous monitoring every 100ms | Monitor 3.3V rail output current for load tracking and thermal management |

---

## Detailed Steps

### Step 1 — Power-On Reset & Identification
- **Register:** `DEVICE_ID` at `0x00`
- **Write value:** `0x0000`
- **Wait/Poll:** Read - verify returns 0xA5C1
- **Rationale:** Verify device communication and silicon identification before proceeding with configuration

### Step 2 — Power-On Reset & Identification
- **Register:** `REVISION` at `0x01`
- **Write value:** `0x0000`
- **Wait/Poll:** Read - log revision for compatibility
- **Rationale:** Read silicon revision to support firmware compatibility checks

### Step 3 — Power-On Reset & Identification
- **Register:** `FAULT_STATUS` at `0x11`
- **Write value:** `0xFFFF`
- **Wait/Poll:** Write to clear any pre-existing fault bits
- **Rationale:** Clear any latched fault conditions from previous power cycles before enabling outputs

### Step 4 — Protection Configuration
- **Register:** `UVLO_CONFIG` at `0x03`
- **Write value:** `0x0E74`
- **Wait/Poll:** None
- **Rationale:** Configure UVLO threshold to 35V with 2V hysteresis for 48V nominal input (prevents operation during insufficient input voltage)

### Step 5 — Protection Configuration
- **Register:** `RAIL12_OCP_LIMIT` at `0x07`
- **Write value:** `0x8FA0`
- **Wait/Poll:** None
- **Rationale:** Set 12V rail OCP to 12.0A with latched shutdown (exceeds 10A nominal by 20% for tolerance margin)

### Step 6 — Protection Configuration
- **Register:** `RAIL5_OCP_LIMIT` at `0x08`
- **Write value:** `0x8BB8`
- **Wait/Poll:** None
- **Rationale:** Set 5V rail OCP to 9.0A with latched shutdown (exceeds 8A nominal by 12.5% for margin)

### Step 7 — Protection Configuration
- **Register:** `RAIL3V3_OCP_LIMIT` at `0x09`
- **Write value:** `0x8E10`
- **Wait/Poll:** None
- **Rationale:** Set 3.3V rail OCP to 14.4A with latched shutdown (exceeds 12A nominal by 20% for margin)

### Step 8 — Voltage Target Configuration
- **Register:** `RAIL12_TARGET` at `0x04`
- **Write value:** `0x0BB8`
- **Wait/Poll:** None
- **Rationale:** Set 12V rail target to 12.000V (±1% regulation requirement per HRS)

### Step 9 — Voltage Target Configuration
- **Register:** `RAIL5_TARGET` at `0x05`
- **Write value:** `0x0320`
- **Wait/Poll:** None
- **Rationale:** Set 5V rail target to 5.000V (±2-3% regulation requirement per HRS)

### Step 10 — Voltage Target Configuration
- **Register:** `RAIL3V3_TARGET` at `0x06`
- **Write value:** `0x0208`
- **Wait/Poll:** None
- **Rationale:** Set 3.3V rail target to 3.300V (±2-3% regulation requirement per HRS)

### Step 11 — Soft-Start Configuration
- **Register:** `SOFT_START_CONFIG` at `0x0A`
- **Write value:** `0x812C`
- **Wait/Poll:** None
- **Rationale:** Enable soft-start with 30ms duration (linear ramp) to limit inrush current on all rails simultaneously

### Step 12 — Input Voltage Verification
- **Register:** `INPUT_VIN_MON` at `0x12`
- **Write value:** `0x0000`
- **Wait/Poll:** Poll - wait until VIN > 40V and VALID bit set
- **Rationale:** Verify input voltage is within specified range (40-60V) before enabling any outputs (safety interlock)

### Step 13 — Rail Enable Sequence
- **Register:** `GLOBAL_CTRL` at `0x02`
- **Write value:** `0x0009`
- **Wait/Poll:** Wait 1ms
- **Rationale:** Enable primary 12V rail only first - allows core bias to establish before enabling downstream converters

### Step 14 — Rail Enable Sequence
- **Register:** `GLOBAL_CTRL` at `0x02`
- **Write value:** `0x000D`
- **Wait/Poll:** Wait 5ms - poll RAIL12_VOUT_MON for > 11.5V
- **Rationale:** Enable 5V rail (cascaded from 12V) - verify 12V rail has reached regulation before enabling downstream converters

### Step 15 — Rail Enable Sequence
- **Register:** `GLOBAL_CTRL` at `0x02`
- **Write value:** `0x000F`
- **Wait/Poll:** Wait 5ms - poll RAIL5_VOUT_MON for > 4.75V
- **Rationale:** Enable 3.3V rail (cascaded from 5V) - verify 5V rail regulation before enabling final downstream converter

### Step 16 — Startup Verification
- **Register:** `FAULT_STATUS` at `0x11`
- **Write value:** `0x0000`
- **Wait/Poll:** Read - verify no fault bits set
- **Rationale:** Verify no faults occurred during startup sequence before proceeding to normal operation

### Step 17 — Startup Verification
- **Register:** `RAIL12_VOUT_MON` at `0x0B`
- **Write value:** `0x0000`
- **Wait/Poll:** Poll until VALID=1 and VOUT >= 11.88V (within ±1%)
- **Rationale:** Verify 12V rail has reached regulation within ±1% tolerance per HRS requirements

### Step 18 — Startup Verification
- **Register:** `RAIL5_VOUT_MON` at `0x0C`
- **Write value:** `0x0000`
- **Wait/Poll:** Poll until VALID=1 and VOUT >= 4.85V (within ±3%)
- **Rationale:** Verify 5V rail has reached regulation within ±3% tolerance per HRS requirements

### Step 19 — Startup Verification
- **Register:** `RAIL3V3_VOUT_MON` at `0x0D`
- **Write value:** `0x0000`
- **Wait/Poll:** Poll until VALID=1 and VOUT >= 3.20V (within ±3%)
- **Rationale:** Verify 3.3V rail has reached regulation within ±3% tolerance per HRS requirements

### Step 20 — Normal Operation - Monitoring Loop
- **Register:** `RAIL12_IOUT_MON` at `0x0E`
- **Write value:** `0x0000`
- **Wait/Poll:** Continuous monitoring every 100ms
- **Rationale:** Monitor 12V rail output current for load tracking and thermal management

### Step 21 — Normal Operation - Monitoring Loop
- **Register:** `RAIL5_IOUT_MON` at `0x0F`
- **Write value:** `0x0000`
- **Wait/Poll:** Continuous monitoring every 100ms
- **Rationale:** Monitor 5V rail output current for load tracking and thermal management

### Step 22 — Normal Operation - Monitoring Loop
- **Register:** `RAIL3V3_IOUT_MON` at `0x10`
- **Write value:** `0x0000`
- **Wait/Poll:** Continuous monitoring every 100ms
- **Rationale:** Monitor 3.3V rail output current for load tracking and thermal management
