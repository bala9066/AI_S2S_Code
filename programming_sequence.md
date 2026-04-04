# Programming Sequence (PSQ)
## rfgg

> **Total steps:** 11

| # | Phase | Register | Address | Value | Condition | Rationale |
|---|-------|----------|---------|-------|-----------|-----------|
| 1 | Power-On Reset | `CONFIG_REG` | `0x0007` | `0x0A` | — | Set default bias sequencer delay (10 x 10us = 100us between PA1 and PA2 enable) |
| 2 | Power-On Reset | `BOOST_CTRL_REG` | `0x0002` | `0x0D` | — | Configure boost converter: Enable=0 (off), Soft-start=10ms (2), OV threshold=default (5), Current limit=7A (1) |
| 3 | Rail Initialization | `BOOST_CTRL_REG` | `0x0002` | `0x0E` | Wait for STATUS_REG.BOOST_PG = 1 | Enable boost converter (bit[0]=1); wait for 28V power-good before proceeding |
| 4 | Bias Initialization | `PA_BIAS_REG` | `0x0001` | `0x2020` | — | Set both PA bias DACs to midcode (0x20) for safe startup; ensure bias override disabled |
| 5 | RF Detector Config | `CONFIG_REG` | `0x0007` | `0x4A` | — | Set AD8318 detector range to 55dB (typical for this PA output); preserve SEQ_DELAY from step 1 |
| 6 | RF Detector Config | `PA_CTRL_REG` | `0x0000` | `0x10` | — | Enable RF detector output buffer (RF_DET_EN=1) while keeping PAs disabled |
| 7 | Mode Select | `PA_CTRL_REG` | `0x0000` | `0x90` | — | Enable digital control mode (DIG_MODE_EN=1) if digital control desired; otherwise keep 0 for discrete pin control |
| 8 | PA Enable (TX Start) | `PA_CTRL_REG` | `0x0000` | `0x92` | Wait SEQ_DELAY (100us) | Enable driver stage PA1 (bit[1]=1); hardware sequencer delays PA2 enable automatically |
| 9 | PA Enable (TX Start) | `PA_CTRL_REG` | `0x0000` | `0x96` | — | Enable final stage PA2 (bit[2]=1); TX_ENABLE (bit[0]) also asserted for full operation |
| 10 | TX Active (Optional Trim) | `PA_BIAS_REG` | `0x0001` | `0x2018` | Monitor RF_DET_ADC for target power | Fine-tune PA2 bias for optimal linearity/efficiency at operating power (example: reduce from 0x20 to 0x18) |
| 11 | TX Shutdown | `PA_CTRL_REG` | `0x0000` | `0x00` | Wait >10us after RF input removed | Clear all enable bits; ensure RF drive removed before disabling PAs to prevent hot-switching |

---

## Detailed Steps

### Step 1 — Power-On Reset
- **Register:** `CONFIG_REG` at `0x0007`
- **Write value:** `0x0A`
- **Rationale:** Set default bias sequencer delay (10 x 10us = 100us between PA1 and PA2 enable)

### Step 2 — Power-On Reset
- **Register:** `BOOST_CTRL_REG` at `0x0002`
- **Write value:** `0x0D`
- **Rationale:** Configure boost converter: Enable=0 (off), Soft-start=10ms (2), OV threshold=default (5), Current limit=7A (1)

### Step 3 — Rail Initialization
- **Register:** `BOOST_CTRL_REG` at `0x0002`
- **Write value:** `0x0E`
- **Wait/Poll:** Wait for STATUS_REG.BOOST_PG = 1
- **Rationale:** Enable boost converter (bit[0]=1); wait for 28V power-good before proceeding

### Step 4 — Bias Initialization
- **Register:** `PA_BIAS_REG` at `0x0001`
- **Write value:** `0x2020`
- **Rationale:** Set both PA bias DACs to midcode (0x20) for safe startup; ensure bias override disabled

### Step 5 — RF Detector Config
- **Register:** `CONFIG_REG` at `0x0007`
- **Write value:** `0x4A`
- **Rationale:** Set AD8318 detector range to 55dB (typical for this PA output); preserve SEQ_DELAY from step 1

### Step 6 — RF Detector Config
- **Register:** `PA_CTRL_REG` at `0x0000`
- **Write value:** `0x10`
- **Rationale:** Enable RF detector output buffer (RF_DET_EN=1) while keeping PAs disabled

### Step 7 — Mode Select
- **Register:** `PA_CTRL_REG` at `0x0000`
- **Write value:** `0x90`
- **Rationale:** Enable digital control mode (DIG_MODE_EN=1) if digital control desired; otherwise keep 0 for discrete pin control

### Step 8 — PA Enable (TX Start)
- **Register:** `PA_CTRL_REG` at `0x0000`
- **Write value:** `0x92`
- **Wait/Poll:** Wait SEQ_DELAY (100us)
- **Rationale:** Enable driver stage PA1 (bit[1]=1); hardware sequencer delays PA2 enable automatically

### Step 9 — PA Enable (TX Start)
- **Register:** `PA_CTRL_REG` at `0x0000`
- **Write value:** `0x96`
- **Rationale:** Enable final stage PA2 (bit[2]=1); TX_ENABLE (bit[0]) also asserted for full operation

### Step 10 — TX Active (Optional Trim)
- **Register:** `PA_BIAS_REG` at `0x0001`
- **Write value:** `0x2018`
- **Wait/Poll:** Monitor RF_DET_ADC for target power
- **Rationale:** Fine-tune PA2 bias for optimal linearity/efficiency at operating power (example: reduce from 0x20 to 0x18)

### Step 11 — TX Shutdown
- **Register:** `PA_CTRL_REG` at `0x0000`
- **Write value:** `0x00`
- **Wait/Poll:** Wait >10us after RF input removed
- **Rationale:** Clear all enable bits; ensure RF drive removed before disabling PAs to prevent hot-switching
