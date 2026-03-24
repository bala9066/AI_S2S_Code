# Programming Sequence (PSQ)
## rf4

> **Total steps:** 19

| # | Phase | Register | Address | Value | Condition | Rationale |
|---|-------|----------|---------|-------|-----------|-----------|
| 1 | Power-On Reset | `DEVICE_ID` | `0x00` | `READ` | Verify 0x52463400 | Confirm device communication and read silicon revision before any configuration |
| 2 | Power-On Reset | `STATUS_REG` | `0x02` | `READ` | Check bit[0]=1 | Verify DEVICE_READY bit is set - internal power supplies stable |
| 3 | Register Unlock | `LOCK_REG` | `0x0E` | `0xA5` | Immediate write | Unlock write protection for bias and control registers (key=0xA5) |
| 4 | Protection Config | `PROTECT_MASK_REG` | `0x09` | `0x07` | None | Enable thermal, overcurrent, and VSWR protection before enabling RF path |
| 5 | Protection Config | `THERM_LIMIT_REG` | `0x06` | `0x78` | None | Set thermal thresholds: shutdown at 120°C, warning at 100°C (safe for GaN PA) |
| 6 | Bias Init - Driver | `BIAS_DRV_REG` | `0x03` | `0x40` | None | Set driver MMIC bias to mid-range (safe default for class-AB operation) |
| 7 | Bias Init - PA | `VGG_GATE_REG` | `0x05` | `0x80` | Wait 10ms | Set negative gate bias to -1V (device-specific safe bias point for GaN FET pinch-off) |
| 8 | Bias Init - PA | `BIAS_PA_REG` | `0x04` | `0x00` | None | Ensure PA drain bias starts at 0V before ramp (prevents surge current) |
| 9 | Ramp Config | `RAMP_RATE_REG` | `0x0A` | `0x25` | None | Configure slow bias ramp: 100us per step, 5 LSB increments for controlled soft-start |
| 10 | Bias Ramp - PA | `BIAS_PA_REG` | `0x04` | `0x48` | Wait 50ms | Ramp PA drain bias to operating point (72/255 of 28V = ~7.9V) - monitor current during ramp |
| 11 | Status Verification | `STATUS_REG` | `0x02` | `READ` | Poll until bit[3]=1 (BIAS_STABLE) | Wait for bias regulation loop to settle before enabling RF path |
| 12 | Supply Verification | `VCC_MONITOR_REG` | `0x08` | `READ` | Verify bit[7:5]=111 (all supplies OK) | Confirm all supplies (12V, 5V, VGG) are within tolerance before RF enable |
| 13 | Thermal Check | `THERM_READ_REG` | `0x07` | `READ` | Verify die temp < 80°C | Confirm safe starting temperature before applying RF drive |
| 14 | RF Path Enable | `CTRL_REG` | `0x01` | `0x40` | Wait 5ms | Set TX_RX_SELECT=1 (TX mode), RF_ENABLE=0, STANDBY=0 - prepare RF path |
| 15 | RF Output Enable | `CTRL_REG` | `0x01` | `0xC0` | Poll STATUS_REG bit[4]=1 (RF_READY) | Set RF_ENABLE=1 - device now at +40 dBm output. Verify RF_OUTPUT_READY asserts |
| 16 | Fault Monitor | `STATUS_REG` | `0x02` | `READ` | Continuous - check bits[7:5]=0 | Monitor thermal shutdown, overcurrent, and VSWR flags during operation |
| 17 | Shutdown Sequence | `CTRL_REG` | `0x01` | `0x10` | Wait 5ms | For controlled shutdown: set STANDBY=1, RF_ENABLE=0 - ramp down bias gracefully |
| 18 | Bias Shutdown | `BIAS_PA_REG` | `0x04` | `0x00` | Wait 10ms | Ramp PA drain bias to 0V after RF disabled |
| 19 | Register Lock | `LOCK_REG` | `0x0E` | `0x00` | Immediate | Re-lock protected registers after configuration complete |

---

## Detailed Steps

### Step 1 — Power-On Reset
- **Register:** `DEVICE_ID` at `0x00`
- **Write value:** `READ`
- **Wait/Poll:** Verify 0x52463400
- **Rationale:** Confirm device communication and read silicon revision before any configuration

### Step 2 — Power-On Reset
- **Register:** `STATUS_REG` at `0x02`
- **Write value:** `READ`
- **Wait/Poll:** Check bit[0]=1
- **Rationale:** Verify DEVICE_READY bit is set - internal power supplies stable

### Step 3 — Register Unlock
- **Register:** `LOCK_REG` at `0x0E`
- **Write value:** `0xA5`
- **Wait/Poll:** Immediate write
- **Rationale:** Unlock write protection for bias and control registers (key=0xA5)

### Step 4 — Protection Config
- **Register:** `PROTECT_MASK_REG` at `0x09`
- **Write value:** `0x07`
- **Wait/Poll:** None
- **Rationale:** Enable thermal, overcurrent, and VSWR protection before enabling RF path

### Step 5 — Protection Config
- **Register:** `THERM_LIMIT_REG` at `0x06`
- **Write value:** `0x78`
- **Wait/Poll:** None
- **Rationale:** Set thermal thresholds: shutdown at 120°C, warning at 100°C (safe for GaN PA)

### Step 6 — Bias Init - Driver
- **Register:** `BIAS_DRV_REG` at `0x03`
- **Write value:** `0x40`
- **Wait/Poll:** None
- **Rationale:** Set driver MMIC bias to mid-range (safe default for class-AB operation)

### Step 7 — Bias Init - PA
- **Register:** `VGG_GATE_REG` at `0x05`
- **Write value:** `0x80`
- **Wait/Poll:** Wait 10ms
- **Rationale:** Set negative gate bias to -1V (device-specific safe bias point for GaN FET pinch-off)

### Step 8 — Bias Init - PA
- **Register:** `BIAS_PA_REG` at `0x04`
- **Write value:** `0x00`
- **Wait/Poll:** None
- **Rationale:** Ensure PA drain bias starts at 0V before ramp (prevents surge current)

### Step 9 — Ramp Config
- **Register:** `RAMP_RATE_REG` at `0x0A`
- **Write value:** `0x25`
- **Wait/Poll:** None
- **Rationale:** Configure slow bias ramp: 100us per step, 5 LSB increments for controlled soft-start

### Step 10 — Bias Ramp - PA
- **Register:** `BIAS_PA_REG` at `0x04`
- **Write value:** `0x48`
- **Wait/Poll:** Wait 50ms
- **Rationale:** Ramp PA drain bias to operating point (72/255 of 28V = ~7.9V) - monitor current during ramp

### Step 11 — Status Verification
- **Register:** `STATUS_REG` at `0x02`
- **Write value:** `READ`
- **Wait/Poll:** Poll until bit[3]=1 (BIAS_STABLE)
- **Rationale:** Wait for bias regulation loop to settle before enabling RF path

### Step 12 — Supply Verification
- **Register:** `VCC_MONITOR_REG` at `0x08`
- **Write value:** `READ`
- **Wait/Poll:** Verify bit[7:5]=111 (all supplies OK)
- **Rationale:** Confirm all supplies (12V, 5V, VGG) are within tolerance before RF enable

### Step 13 — Thermal Check
- **Register:** `THERM_READ_REG` at `0x07`
- **Write value:** `READ`
- **Wait/Poll:** Verify die temp < 80°C
- **Rationale:** Confirm safe starting temperature before applying RF drive

### Step 14 — RF Path Enable
- **Register:** `CTRL_REG` at `0x01`
- **Write value:** `0x40`
- **Wait/Poll:** Wait 5ms
- **Rationale:** Set TX_RX_SELECT=1 (TX mode), RF_ENABLE=0, STANDBY=0 - prepare RF path

### Step 15 — RF Output Enable
- **Register:** `CTRL_REG` at `0x01`
- **Write value:** `0xC0`
- **Wait/Poll:** Poll STATUS_REG bit[4]=1 (RF_READY)
- **Rationale:** Set RF_ENABLE=1 - device now at +40 dBm output. Verify RF_OUTPUT_READY asserts

### Step 16 — Fault Monitor
- **Register:** `STATUS_REG` at `0x02`
- **Write value:** `READ`
- **Wait/Poll:** Continuous - check bits[7:5]=0
- **Rationale:** Monitor thermal shutdown, overcurrent, and VSWR flags during operation

### Step 17 — Shutdown Sequence
- **Register:** `CTRL_REG` at `0x01`
- **Write value:** `0x10`
- **Wait/Poll:** Wait 5ms
- **Rationale:** For controlled shutdown: set STANDBY=1, RF_ENABLE=0 - ramp down bias gracefully

### Step 18 — Bias Shutdown
- **Register:** `BIAS_PA_REG` at `0x04`
- **Write value:** `0x00`
- **Wait/Poll:** Wait 10ms
- **Rationale:** Ramp PA drain bias to 0V after RF disabled

### Step 19 — Register Lock
- **Register:** `LOCK_REG` at `0x0E`
- **Write value:** `0x00`
- **Wait/Poll:** Immediate
- **Rationale:** Re-lock protected registers after configuration complete
