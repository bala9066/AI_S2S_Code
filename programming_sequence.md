# Programming Sequence (PSQ)
## rf78

> **Total steps:** 14

| # | Phase | Register | Address | Value | Condition | Rationale |
|---|-------|----------|---------|-------|-----------|-----------|
| 1 | Device Identification | `DEVICE_ID` | `0x000F` | `READ` | Verify returned value == 0x78 | Confirm correct RF PA module is present before proceeding with initialization. Prevents misconfiguration if wrong module installed. |
| 2 | Default Configuration Load | `CFG_TIMING_SEQ` | `0x0003` | `0x32` | None | Load default 50ms bias sequencer delay. This ensures driver bias stabilizes before PA 28V is applied, preventing GaN PA damage from insufficient gate drive. |
| 3 | Fault Threshold Configuration | `CFG_COMP_THRESHOLDS` | `0x0002` | `0x84` | None | Set default fault thresholds: FWD_PWR=2.0V (~+35dBm), REV_PWR=1.2V (~+10dBm), THERM=+85°C. These values provide safe operating margins for 10W PA output. |
| 4 | Fault Flag Clear | `STATUS_FAULT_FLAGS` | `0x0001` | `READ` | Read and note any latched faults; clear if needed | Clear any residual fault flags from previous power cycle. Fault flags are RC (read-clear) type; read to reset latch state. |
| 5 | Bias Override Safety Check | `CFG_BIAS_CONTROL` | `0x0007` | `0x00` | Verify OVERRIDE_EN=0 | Ensure bias sequencer override is disabled. Direct control mode bypasses safe sequencing and should only be used for factory calibration with extreme caution. |
| 6 | Temperature Pre-Check | `READ_TEMP_SENSOR` | `0x0006` | `READ` | Verify temperature < +60°C before enable | Pre-enable thermal check. If PA is already hot (e.g., from recent operation), allow cooldown before enabling. Prevents thermal stress on GaN device. |
| 7 | TX Enable (Bias Sequence Start) | `CTRL_TX_ENABLE` | `0x0000` | `0x01` | None | Initiate TX enable. LM555 timer automatically sequences: DRV_ENABLE goes active immediately, then after SEQ_DELAY_MS (50ms), PA_ENABLE_5V activates enabling 28V rail via Q3. |
| 8 | Bias Sequencing Delay | `STATUS_FAULT_FLAGS` | `0x0001` | `POLL` | Wait minimum 50ms + 10ms margin; monitor for faults during sequence | Allow LM555 monostable timer to complete bias sequencing. The 50ms delay ensures driver amplifier (MGA-43016) bias is stable before final PA (CGRM2812) 28V rail is applied. |
| 9 | Fault Monitoring Active | `STATUS_FAULT_FLAGS` | `0x0001` | `READ` | Continuous polling every 100us during TX operation | Active fault monitoring during transmission. Any fault (FWD_PWR, REV_PWR, THERMAL) will set corresponding bit. Fault pending in bit[7] provides single-bit check for fast response. |
| 10 | Power Monitoring (Optional) | `READ_PWR_DETECTOR_FWD` | `0x0004` | `READ` | Poll at 1kHz rate during TX for closed-loop power control | Monitor forward power output using AD8318 detector. ADC value can be used for closed-loop power adjustment, calibration verification, or EVM optimization. |
| 11 | VSWR Monitoring (Optional) | `READ_PWR_DETECTOR_REV` | `0x0005` | `READ` | Poll at 100Hz rate; compute VSWR from FWD/REV ratio | Monitor reflected power for antenna health. High VSWR can cause PA damage; take action if REV_PWR_FAULT triggers. Compute VSWR = (1+sqrt(REV/FWD))/(1-sqrt(REV/FWD)). |
| 12 | Thermal Monitoring (Continuous) | `READ_TEMP_SENSOR` | `0x0006` | `READ` | Poll at 10Hz rate; warn if approaching +80°C | Continuous thermal monitoring. GaN PA efficiency decreases with temperature and excessive heat causes permanent damage. Proactive thermal management before +85°C fault threshold. |
| 13 | Safe TX Shutdown | `CTRL_TX_ENABLE` | `0x0000` | `0x00` | None | Disable TX. LM555 initiates safe shutdown: PA 28V rail disabled immediately via Q3, then DRV_ENABLE deactivated after timeout. This reverse sequencing protects PA during power-down. |
| 14 | Post-Operation Status Check | `STATUS_FAULT_FLAGS` | `0x0001` | `READ` | Log any fault flags for diagnostics | After shutdown, read fault status to log any events that occurred during operation (overdrive, VSWR events, thermal excursions). Useful for field diagnostics and predictive maintenance. |

---

## Detailed Steps

### Step 1 — Device Identification
- **Register:** `DEVICE_ID` at `0x000F`
- **Write value:** `READ`
- **Wait/Poll:** Verify returned value == 0x78
- **Rationale:** Confirm correct RF PA module is present before proceeding with initialization. Prevents misconfiguration if wrong module installed.

### Step 2 — Default Configuration Load
- **Register:** `CFG_TIMING_SEQ` at `0x0003`
- **Write value:** `0x32`
- **Wait/Poll:** None
- **Rationale:** Load default 50ms bias sequencer delay. This ensures driver bias stabilizes before PA 28V is applied, preventing GaN PA damage from insufficient gate drive.

### Step 3 — Fault Threshold Configuration
- **Register:** `CFG_COMP_THRESHOLDS` at `0x0002`
- **Write value:** `0x84`
- **Wait/Poll:** None
- **Rationale:** Set default fault thresholds: FWD_PWR=2.0V (~+35dBm), REV_PWR=1.2V (~+10dBm), THERM=+85°C. These values provide safe operating margins for 10W PA output.

### Step 4 — Fault Flag Clear
- **Register:** `STATUS_FAULT_FLAGS` at `0x0001`
- **Write value:** `READ`
- **Wait/Poll:** Read and note any latched faults; clear if needed
- **Rationale:** Clear any residual fault flags from previous power cycle. Fault flags are RC (read-clear) type; read to reset latch state.

### Step 5 — Bias Override Safety Check
- **Register:** `CFG_BIAS_CONTROL` at `0x0007`
- **Write value:** `0x00`
- **Wait/Poll:** Verify OVERRIDE_EN=0
- **Rationale:** Ensure bias sequencer override is disabled. Direct control mode bypasses safe sequencing and should only be used for factory calibration with extreme caution.

### Step 6 — Temperature Pre-Check
- **Register:** `READ_TEMP_SENSOR` at `0x0006`
- **Write value:** `READ`
- **Wait/Poll:** Verify temperature < +60°C before enable
- **Rationale:** Pre-enable thermal check. If PA is already hot (e.g., from recent operation), allow cooldown before enabling. Prevents thermal stress on GaN device.

### Step 7 — TX Enable (Bias Sequence Start)
- **Register:** `CTRL_TX_ENABLE` at `0x0000`
- **Write value:** `0x01`
- **Wait/Poll:** None
- **Rationale:** Initiate TX enable. LM555 timer automatically sequences: DRV_ENABLE goes active immediately, then after SEQ_DELAY_MS (50ms), PA_ENABLE_5V activates enabling 28V rail via Q3.

### Step 8 — Bias Sequencing Delay
- **Register:** `STATUS_FAULT_FLAGS` at `0x0001`
- **Write value:** `POLL`
- **Wait/Poll:** Wait minimum 50ms + 10ms margin; monitor for faults during sequence
- **Rationale:** Allow LM555 monostable timer to complete bias sequencing. The 50ms delay ensures driver amplifier (MGA-43016) bias is stable before final PA (CGRM2812) 28V rail is applied.

### Step 9 — Fault Monitoring Active
- **Register:** `STATUS_FAULT_FLAGS` at `0x0001`
- **Write value:** `READ`
- **Wait/Poll:** Continuous polling every 100us during TX operation
- **Rationale:** Active fault monitoring during transmission. Any fault (FWD_PWR, REV_PWR, THERMAL) will set corresponding bit. Fault pending in bit[7] provides single-bit check for fast response.

### Step 10 — Power Monitoring (Optional)
- **Register:** `READ_PWR_DETECTOR_FWD` at `0x0004`
- **Write value:** `READ`
- **Wait/Poll:** Poll at 1kHz rate during TX for closed-loop power control
- **Rationale:** Monitor forward power output using AD8318 detector. ADC value can be used for closed-loop power adjustment, calibration verification, or EVM optimization.

### Step 11 — VSWR Monitoring (Optional)
- **Register:** `READ_PWR_DETECTOR_REV` at `0x0005`
- **Write value:** `READ`
- **Wait/Poll:** Poll at 100Hz rate; compute VSWR from FWD/REV ratio
- **Rationale:** Monitor reflected power for antenna health. High VSWR can cause PA damage; take action if REV_PWR_FAULT triggers. Compute VSWR = (1+sqrt(REV/FWD))/(1-sqrt(REV/FWD)).

### Step 12 — Thermal Monitoring (Continuous)
- **Register:** `READ_TEMP_SENSOR` at `0x0006`
- **Write value:** `READ`
- **Wait/Poll:** Poll at 10Hz rate; warn if approaching +80°C
- **Rationale:** Continuous thermal monitoring. GaN PA efficiency decreases with temperature and excessive heat causes permanent damage. Proactive thermal management before +85°C fault threshold.

### Step 13 — Safe TX Shutdown
- **Register:** `CTRL_TX_ENABLE` at `0x0000`
- **Write value:** `0x00`
- **Wait/Poll:** None
- **Rationale:** Disable TX. LM555 initiates safe shutdown: PA 28V rail disabled immediately via Q3, then DRV_ENABLE deactivated after timeout. This reverse sequencing protects PA during power-down.

### Step 14 — Post-Operation Status Check
- **Register:** `STATUS_FAULT_FLAGS` at `0x0001`
- **Write value:** `READ`
- **Wait/Poll:** Log any fault flags for diagnostics
- **Rationale:** After shutdown, read fault status to log any events that occurred during operation (overdrive, VSWR events, thermal excursions). Useful for field diagnostics and predictive maintenance.
