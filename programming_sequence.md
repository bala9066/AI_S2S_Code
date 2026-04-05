# Programming Sequence (PSQ)
## hkgg

> **Total steps:** 22

| # | Phase | Register | Address | Value | Condition | Rationale |
|---|-------|----------|---------|-------|-----------|-----------|
| 1 | Phase 1 - Power-On Reset & Self-Check | `SCRATCHPAD` | `0x0003` | `0xA5A5` | Read back after write, verify 0xA5A5 | RAM integrity check - verify memory-mapped register read/write functionality |
| 2 | Phase 1 - Power-On Reset & Self-Check | `SCRATCHPAD` | `0x0003` | `0x5A5A` | Read back after write, verify 0x5A5A | Second RAM check pattern - ensures bit integrity (alternating pattern) |
| 3 | Phase 1 - Power-On Reset & Self-Check | `BOARD_ID` | `0x0000` | `READ` | Verify value == 0x484B ('HK') | Board identification - confirm FPGA is running on hkgg hardware |
| 4 | Phase 1 - Power-On Reset & Self-Check | `HEALTH_STATUS` | `0x030F` | `READ` | Poll until VOLT_OK (bit1) == 1 | Wait for power supplies to stabilize - 12V, 3.3V must be within ±10% |
| 5 | Phase 2 - Communication Init | `UART_BAUD_DIV` | `0x0100` | `0x001B` | None (immediate) | Set UART baud rate divisor for 115200 baud (50MHz / (16*27) = 115740, ~0.2% error) |
| 6 | Phase 2 - Communication Init | `UART_CTRL` | `0x0101` | `0x03` | None (immediate) | Enable UART with 8N1 frame format - prepare for host communication |
| 7 | Phase 2 - Communication Init | `UART_STATUS` | `0x0102` | `READ` | Verify TX_BUSY == 0 and no errors | Confirm UART is ready and not in error state |
| 8 | Phase 3 - Temperature & Fault Init | `TEMP_ALERT_HIGH` | `0x0308` | `0x0320` | None (immediate) | Set over-temperature shutdown threshold at 80°C (0x320 * 0.25°C) - protects PA from thermal damage |
| 9 | Phase 3 - Temperature & Fault Init | `TEMP_ALERT_LOW` | `0x0309` | `0xFFCC` | None (immediate) | Set under-temperature warning at -20°C for condensation protection |
| 10 | Phase 3 - Temperature & Fault Init | `TEMP_LOCAL` | `0x0300` | `READ` | Verify TEMP_VALUE < 0x320 (80°C) | Check FPGA die temperature before enabling RF power - prevent thermal damage |
| 11 | Phase 4 - Power Sequencing | `RF_PWR_CTRL` | `0x0802` | `0x0A04` | Wait 10ms for sequencing | Enable +12V_LOGIC rail via IRLML6402 - powers DAC and bias circuitry (SEQ_DELAY_MS = 10ms) |
| 12 | Phase 4 - Power Sequencing | `RF_PWR_CTRL` | `0x0802` | `0x0A06` | Wait 10ms for sequencing | Enable +12V_DRIVER rail - powers GVA-123+ driver stage (controlled sequencing) |
| 13 | Phase 4 - Power Sequencing | `RF_PWR_CTRL` | `0x0802` | `0x0A07` | Wait 10ms for sequencing | Enable +12V_DRAIN rail - powers MRF1511G final stage (last in sequence) |
| 14 | Phase 5 - PA Bias Configuration | `PA_BIAS_DAC` | `0x0803` | `0x0800` | None (triggers I2C write to MAX1167) |  |
| 15 | Phase 5 - PA Bias Configuration | `PA_BIAS_CONFIG` | `0x0804` | `0x0FFF` | None (immediate) | Set bias limits - allow full range (0-4095) but could restrict for safety |
| 16 | Phase 5 - PA Bias Configuration | `VCC_GATE_RAW` | `0x0213` | `READ` | Verify ADC reading corresponds to ~2.5V gate bias | Confirm gate bias voltage is correct before enabling RF output |
| 17 | Phase 6 - RF Enable | `RF_STATUS` | `0x0801` | `READ` | Verify INTERLOCK_OK (bit2) == 1 | Check safety interlock is closed before enabling RF power output |
| 18 | Phase 6 - RF Enable | `RF_ENABLE_CMD` | `0x0800` | `0x0001` | Poll RF_STATUS until RF_ENABLED (bit0) == 1 | Enable RF amplifier output - activates PA chain for operation |
| 19 | Phase 6 - RF Enable | `RF_STATUS` | `0x0801` | `READ` | Verify BIAS_ACTIVE (bit1) == 1 and RF_ENABLED (bit0) == 1 | Confirm RF PA is fully operational with bias applied and output enabled |
| 20 | Phase 6 - RF Enable | `HEALTH_STATUS` | `0x030F` | `READ` | Verify SYSTEM_OK (bit7) == 1, no faults | Final health check - confirm system is healthy and ready for RF operation |
| 21 | Phase 7 - Monitoring Loop | `ICC_DRAIN_RAW` | `0x0219` | `READ` | Continuous monitoring during operation | Monitor PA drain current - proportional to RF output power, detects overcurrent |
| 22 | Phase 7 - Monitoring Loop | `TEMP_PA_MRF1511G` | `0x0301` | `READ` | Continuous monitoring during operation | Monitor PA transistor temperature - critical for thermal management and protection |

---

## Detailed Steps

### Step 1 — Phase 1 - Power-On Reset & Self-Check
- **Register:** `SCRATCHPAD` at `0x0003`
- **Write value:** `0xA5A5`
- **Wait/Poll:** Read back after write, verify 0xA5A5
- **Rationale:** RAM integrity check - verify memory-mapped register read/write functionality

### Step 2 — Phase 1 - Power-On Reset & Self-Check
- **Register:** `SCRATCHPAD` at `0x0003`
- **Write value:** `0x5A5A`
- **Wait/Poll:** Read back after write, verify 0x5A5A
- **Rationale:** Second RAM check pattern - ensures bit integrity (alternating pattern)

### Step 3 — Phase 1 - Power-On Reset & Self-Check
- **Register:** `BOARD_ID` at `0x0000`
- **Write value:** `READ`
- **Wait/Poll:** Verify value == 0x484B ('HK')
- **Rationale:** Board identification - confirm FPGA is running on hkgg hardware

### Step 4 — Phase 1 - Power-On Reset & Self-Check
- **Register:** `HEALTH_STATUS` at `0x030F`
- **Write value:** `READ`
- **Wait/Poll:** Poll until VOLT_OK (bit1) == 1
- **Rationale:** Wait for power supplies to stabilize - 12V, 3.3V must be within ±10%

### Step 5 — Phase 2 - Communication Init
- **Register:** `UART_BAUD_DIV` at `0x0100`
- **Write value:** `0x001B`
- **Wait/Poll:** None (immediate)
- **Rationale:** Set UART baud rate divisor for 115200 baud (50MHz / (16*27) = 115740, ~0.2% error)

### Step 6 — Phase 2 - Communication Init
- **Register:** `UART_CTRL` at `0x0101`
- **Write value:** `0x03`
- **Wait/Poll:** None (immediate)
- **Rationale:** Enable UART with 8N1 frame format - prepare for host communication

### Step 7 — Phase 2 - Communication Init
- **Register:** `UART_STATUS` at `0x0102`
- **Write value:** `READ`
- **Wait/Poll:** Verify TX_BUSY == 0 and no errors
- **Rationale:** Confirm UART is ready and not in error state

### Step 8 — Phase 3 - Temperature & Fault Init
- **Register:** `TEMP_ALERT_HIGH` at `0x0308`
- **Write value:** `0x0320`
- **Wait/Poll:** None (immediate)
- **Rationale:** Set over-temperature shutdown threshold at 80°C (0x320 * 0.25°C) - protects PA from thermal damage

### Step 9 — Phase 3 - Temperature & Fault Init
- **Register:** `TEMP_ALERT_LOW` at `0x0309`
- **Write value:** `0xFFCC`
- **Wait/Poll:** None (immediate)
- **Rationale:** Set under-temperature warning at -20°C for condensation protection

### Step 10 — Phase 3 - Temperature & Fault Init
- **Register:** `TEMP_LOCAL` at `0x0300`
- **Write value:** `READ`
- **Wait/Poll:** Verify TEMP_VALUE < 0x320 (80°C)
- **Rationale:** Check FPGA die temperature before enabling RF power - prevent thermal damage

### Step 11 — Phase 4 - Power Sequencing
- **Register:** `RF_PWR_CTRL` at `0x0802`
- **Write value:** `0x0A04`
- **Wait/Poll:** Wait 10ms for sequencing
- **Rationale:** Enable +12V_LOGIC rail via IRLML6402 - powers DAC and bias circuitry (SEQ_DELAY_MS = 10ms)

### Step 12 — Phase 4 - Power Sequencing
- **Register:** `RF_PWR_CTRL` at `0x0802`
- **Write value:** `0x0A06`
- **Wait/Poll:** Wait 10ms for sequencing
- **Rationale:** Enable +12V_DRIVER rail - powers GVA-123+ driver stage (controlled sequencing)

### Step 13 — Phase 4 - Power Sequencing
- **Register:** `RF_PWR_CTRL` at `0x0802`
- **Write value:** `0x0A07`
- **Wait/Poll:** Wait 10ms for sequencing
- **Rationale:** Enable +12V_DRAIN rail - powers MRF1511G final stage (last in sequence)

### Step 14 — Phase 5 - PA Bias Configuration
- **Register:** `PA_BIAS_DAC` at `0x0803`
- **Write value:** `0x0800`
- **Wait/Poll:** None (triggers I2C write to MAX1167)
- **Rationale:** 

### Step 15 — Phase 5 - PA Bias Configuration
- **Register:** `PA_BIAS_CONFIG` at `0x0804`
- **Write value:** `0x0FFF`
- **Wait/Poll:** None (immediate)
- **Rationale:** Set bias limits - allow full range (0-4095) but could restrict for safety

### Step 16 — Phase 5 - PA Bias Configuration
- **Register:** `VCC_GATE_RAW` at `0x0213`
- **Write value:** `READ`
- **Wait/Poll:** Verify ADC reading corresponds to ~2.5V gate bias
- **Rationale:** Confirm gate bias voltage is correct before enabling RF output

### Step 17 — Phase 6 - RF Enable
- **Register:** `RF_STATUS` at `0x0801`
- **Write value:** `READ`
- **Wait/Poll:** Verify INTERLOCK_OK (bit2) == 1
- **Rationale:** Check safety interlock is closed before enabling RF power output

### Step 18 — Phase 6 - RF Enable
- **Register:** `RF_ENABLE_CMD` at `0x0800`
- **Write value:** `0x0001`
- **Wait/Poll:** Poll RF_STATUS until RF_ENABLED (bit0) == 1
- **Rationale:** Enable RF amplifier output - activates PA chain for operation

### Step 19 — Phase 6 - RF Enable
- **Register:** `RF_STATUS` at `0x0801`
- **Write value:** `READ`
- **Wait/Poll:** Verify BIAS_ACTIVE (bit1) == 1 and RF_ENABLED (bit0) == 1
- **Rationale:** Confirm RF PA is fully operational with bias applied and output enabled

### Step 20 — Phase 6 - RF Enable
- **Register:** `HEALTH_STATUS` at `0x030F`
- **Write value:** `READ`
- **Wait/Poll:** Verify SYSTEM_OK (bit7) == 1, no faults
- **Rationale:** Final health check - confirm system is healthy and ready for RF operation

### Step 21 — Phase 7 - Monitoring Loop
- **Register:** `ICC_DRAIN_RAW` at `0x0219`
- **Write value:** `READ`
- **Wait/Poll:** Continuous monitoring during operation
- **Rationale:** Monitor PA drain current - proportional to RF output power, detects overcurrent

### Step 22 — Phase 7 - Monitoring Loop
- **Register:** `TEMP_PA_MRF1511G` at `0x0301`
- **Write value:** `READ`
- **Wait/Poll:** Continuous monitoring during operation
- **Rationale:** Monitor PA transistor temperature - critical for thermal management and protection
