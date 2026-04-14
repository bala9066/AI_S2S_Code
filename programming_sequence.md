# Programming Sequence (PSQ)
## TX Module

> **Total steps:** 24

| # | Phase | Register | Address | Value | Condition | Rationale |
|---|-------|----------|---------|-------|-----------|-----------|
| 1 | PHASE 1 - Power-On Reset & Self-Check | `SCRATCHPAD` | `0x0003` | `0xA5A5` | Read back verify = 0xA5A5 | Write known pattern (0xA5A5) to SCRATCHPAD register and read back to verify FPGA internal RAM and bus functionality. Essential first step to confirm register access is working. |
| 2 | PHASE 1 - Power-On Reset & Self-Check | `SCRATCHPAD` | `0x0003` | `0x5A5A` | Read back verify = 0x5A5A | Write inverse pattern (0x5A5A) to verify full bus width and detect stuck bits. Complementary test to ensure data integrity. |
| 3 | PHASE 1 - Power-On Reset & Self-Check | `BOARD_ID` | `0x0000` | `READ` | Verify = 0x5458 ('TX') | Read BOARD_ID register and verify it contains expected TX Module identifier (0x5458 = 'TX'). Confirms correct FPGA firmware is loaded. |
| 4 | PHASE 1 - Power-On Reset & Self-Check | `HEALTH_STATUS` | `0x030F` | `READ` | Poll until VOLT_OK=1 (bit 1) | Poll HEALTH_STATUS register until VOLT_OK bit is set. Ensures all power rails (28V, 5V, analog) have stabilized before proceeding. |
| 5 | PHASE 2 - PLL & Clock Init | `PLL_CTRL` | `0x0400` | `0x03` | Wait 10us for PLL reset | Set PLL RESET and ENABLE bits simultaneously to ensure clean PLL initialization. Reset takes 10us minimum. |
| 6 | PHASE 2 - PLL & Clock Init | `PLL_CTRL` | `0x0400` | `0x01` | Poll PLL_STATUS bit 0 until LOCKED=1 | Release PLL reset (bit 1 cleared) while keeping PLL enabled (bit 0 set). Poll LOCKED bit to confirm PLL has achieved lock before proceeding. |
| 7 | PHASE 2 - PLL & Clock Init | `CLK_ENABLE` | `0x0410` | `0x07` | Immediate | Enable ADC, RF control, and UART clocks. All clock domains must be active before peripheral initialization. |
| 8 | PHASE 3 - Peripheral Enable | `VCC_CTRL` | `0x0A02` | `0x03` | Wait for POWER_GOOD=1 (bit 7) | Enable LT8631 5V buck and LT3080 LDO for analog bias supplies. Wait for POWER_GOOD confirmation. |
| 9 | PHASE 3 - Peripheral Enable | `MOSFET_CTRL` | `0x0A01` | `0x03` | Wait 5ms for Q1 P-Channel turn-on | Enable Q1 (IRF9540) 28V high-side and Q2 (IRF540) load switches. Q1 P-Channel requires 5ms turn-on time for 28V rail. |
| 10 | PHASE 3 - Peripheral Enable | `ADC_CTRL` | `0x0200` | `0x33` | Wait 500us for ADC initialization | Configure ADC for continuous mode at 3.5kHz, starting with channel 0 (RF_DET). ADC requires ~500us to settle after enable. |
| 11 | PHASE 4 - Communication Init | `UART_BAUD_DIV` | `0x0100` | `0x0868` | Immediate | Set baud rate divisor for 115200 baud from 40MHz clock. Divisor = 40MHz / (16 * 115200) = 21.7 ≈ 0x0868. |
| 12 | PHASE 4 - Communication Init | `UART_CTRL` | `0x0101` | `0x13` | Verify TX_BUSY=0 | Enable UART (bit 0) and set 8N1 frame format (bits 7:4 = 0x3). Verify transmitter is not busy before use. |
| 13 | PHASE 5 - Application Init | `TEMP_ALERT_HIGH` | `0x0308` | `0x01E0` | Immediate | Set over-temperature threshold to 120°C (0x1E0 = 120 * 4 = 480 decimal). Alerts when PA exceeds safe operating temperature. |
| 14 | PHASE 5 - Application Init | `TEMP_ALERT_LOW` | `0x0309` | `0xFF9C` | Immediate | Set under-temperature threshold to -25°C (0xFF9C signed = -100 * 0.25 = -25°C). Prevents operation in cold conditions. |
| 15 | PHASE 5 - Application Init | `FLASH_CTRL` | `0x0600` | `0x01` | Wait for FLASH_STATUS READY=1 | Initialize flash interface by setting READ enable bit and waiting for READY confirmation. Verifies flash is accessible. |
| 16 | PHASE 5 - Application Init | `EEPROM_CTRL` | `0x0500` | `0x01` | Read calibration data from addr 0x0000-0x00FF | Initialize EEPROM and read factory calibration data (attenuator calibration, PA gain tables). Stored at base address 0x0000. |
| 17 | PHASE 5 - Application Init | `DAC_CTRL` | `0x0900` | `0x01` | Immediate | Enable DAC and select channel 0 (VGA_VREF). Analog bias reference must be active before PA enable. |
| 18 | PHASE 5 - Application Init | `DAC_DATA` | `0x0901` | `0x800` | Wait for DAC_READY=1 | Set VGA_VREF to midscale (1.65V for 3.3V DAC). Provides nominal bias reference for HMC698LP4 attenuator. |
| 19 | PHASE 5 - Application Init | `RF_ATTENUATION` | `0x0701` | `0x40` | Immediate | Set attenuator to minimum attenuation (code = 0) and enable attenuator (bit 6 = 1). Ensures maximum gain at TX enable. |
| 20 | PHASE 5 - Application Init | `RF_POWER_SETPOINT` | `0x0704` | `0x0190` | Immediate | Set target output power to 40dBm (100 * 0.25dB = 25 = 0x0190). AGC loop will adjust attenuator to maintain this level. |
| 21 | PHASE 5 - Application Init | `PA_BIAS_CTRL` | `0x0A00` | `0x5000` | Wait VGS_DELAY (5ms) | Configure PA bias with 5ms gate-source delay. Ensures proper PA bias sequencing for GaN MMIC reliability. |
| 22 | PHASE 5 - Application Init | `RF_TX_ENABLE` | `0x0700` | `0x01` | Wait TX_EN_DELAY (1ms), verify RF_ON=1 | Enable RF TX chain. FPGA sequences PA bias, waits 1ms ramp delay, then sets RF_ON flag. Confirms TX chain is active. |
| 23 | PHASE 5 - Application Init | `RF_STATUS` | `0x0703` | `READ` | Verify PA_ENABLED=1, PA_FAULT=0, VSWR_HIGH=0 | Final health check - verify PA enabled successfully with no faults. Confirm no high VSWR condition at output. |
| 24 | PHASE 5 - Application Init | `GPIO_DIR` | `0x0800` | `0x0F` | Immediate | Configure GPIO[3:0] as outputs (for external indicators), GPIO[7:4] as inputs (for external fault signals). |

---

## Detailed Steps

### Step 1 — PHASE 1 - Power-On Reset & Self-Check
- **Register:** `SCRATCHPAD` at `0x0003`
- **Write value:** `0xA5A5`
- **Wait/Poll:** Read back verify = 0xA5A5
- **Rationale:** Write known pattern (0xA5A5) to SCRATCHPAD register and read back to verify FPGA internal RAM and bus functionality. Essential first step to confirm register access is working.

### Step 2 — PHASE 1 - Power-On Reset & Self-Check
- **Register:** `SCRATCHPAD` at `0x0003`
- **Write value:** `0x5A5A`
- **Wait/Poll:** Read back verify = 0x5A5A
- **Rationale:** Write inverse pattern (0x5A5A) to verify full bus width and detect stuck bits. Complementary test to ensure data integrity.

### Step 3 — PHASE 1 - Power-On Reset & Self-Check
- **Register:** `BOARD_ID` at `0x0000`
- **Write value:** `READ`
- **Wait/Poll:** Verify = 0x5458 ('TX')
- **Rationale:** Read BOARD_ID register and verify it contains expected TX Module identifier (0x5458 = 'TX'). Confirms correct FPGA firmware is loaded.

### Step 4 — PHASE 1 - Power-On Reset & Self-Check
- **Register:** `HEALTH_STATUS` at `0x030F`
- **Write value:** `READ`
- **Wait/Poll:** Poll until VOLT_OK=1 (bit 1)
- **Rationale:** Poll HEALTH_STATUS register until VOLT_OK bit is set. Ensures all power rails (28V, 5V, analog) have stabilized before proceeding.

### Step 5 — PHASE 2 - PLL & Clock Init
- **Register:** `PLL_CTRL` at `0x0400`
- **Write value:** `0x03`
- **Wait/Poll:** Wait 10us for PLL reset
- **Rationale:** Set PLL RESET and ENABLE bits simultaneously to ensure clean PLL initialization. Reset takes 10us minimum.

### Step 6 — PHASE 2 - PLL & Clock Init
- **Register:** `PLL_CTRL` at `0x0400`
- **Write value:** `0x01`
- **Wait/Poll:** Poll PLL_STATUS bit 0 until LOCKED=1
- **Rationale:** Release PLL reset (bit 1 cleared) while keeping PLL enabled (bit 0 set). Poll LOCKED bit to confirm PLL has achieved lock before proceeding.

### Step 7 — PHASE 2 - PLL & Clock Init
- **Register:** `CLK_ENABLE` at `0x0410`
- **Write value:** `0x07`
- **Wait/Poll:** Immediate
- **Rationale:** Enable ADC, RF control, and UART clocks. All clock domains must be active before peripheral initialization.

### Step 8 — PHASE 3 - Peripheral Enable
- **Register:** `VCC_CTRL` at `0x0A02`
- **Write value:** `0x03`
- **Wait/Poll:** Wait for POWER_GOOD=1 (bit 7)
- **Rationale:** Enable LT8631 5V buck and LT3080 LDO for analog bias supplies. Wait for POWER_GOOD confirmation.

### Step 9 — PHASE 3 - Peripheral Enable
- **Register:** `MOSFET_CTRL` at `0x0A01`
- **Write value:** `0x03`
- **Wait/Poll:** Wait 5ms for Q1 P-Channel turn-on
- **Rationale:** Enable Q1 (IRF9540) 28V high-side and Q2 (IRF540) load switches. Q1 P-Channel requires 5ms turn-on time for 28V rail.

### Step 10 — PHASE 3 - Peripheral Enable
- **Register:** `ADC_CTRL` at `0x0200`
- **Write value:** `0x33`
- **Wait/Poll:** Wait 500us for ADC initialization
- **Rationale:** Configure ADC for continuous mode at 3.5kHz, starting with channel 0 (RF_DET). ADC requires ~500us to settle after enable.

### Step 11 — PHASE 4 - Communication Init
- **Register:** `UART_BAUD_DIV` at `0x0100`
- **Write value:** `0x0868`
- **Wait/Poll:** Immediate
- **Rationale:** Set baud rate divisor for 115200 baud from 40MHz clock. Divisor = 40MHz / (16 * 115200) = 21.7 ≈ 0x0868.

### Step 12 — PHASE 4 - Communication Init
- **Register:** `UART_CTRL` at `0x0101`
- **Write value:** `0x13`
- **Wait/Poll:** Verify TX_BUSY=0
- **Rationale:** Enable UART (bit 0) and set 8N1 frame format (bits 7:4 = 0x3). Verify transmitter is not busy before use.

### Step 13 — PHASE 5 - Application Init
- **Register:** `TEMP_ALERT_HIGH` at `0x0308`
- **Write value:** `0x01E0`
- **Wait/Poll:** Immediate
- **Rationale:** Set over-temperature threshold to 120°C (0x1E0 = 120 * 4 = 480 decimal). Alerts when PA exceeds safe operating temperature.

### Step 14 — PHASE 5 - Application Init
- **Register:** `TEMP_ALERT_LOW` at `0x0309`
- **Write value:** `0xFF9C`
- **Wait/Poll:** Immediate
- **Rationale:** Set under-temperature threshold to -25°C (0xFF9C signed = -100 * 0.25 = -25°C). Prevents operation in cold conditions.

### Step 15 — PHASE 5 - Application Init
- **Register:** `FLASH_CTRL` at `0x0600`
- **Write value:** `0x01`
- **Wait/Poll:** Wait for FLASH_STATUS READY=1
- **Rationale:** Initialize flash interface by setting READ enable bit and waiting for READY confirmation. Verifies flash is accessible.

### Step 16 — PHASE 5 - Application Init
- **Register:** `EEPROM_CTRL` at `0x0500`
- **Write value:** `0x01`
- **Wait/Poll:** Read calibration data from addr 0x0000-0x00FF
- **Rationale:** Initialize EEPROM and read factory calibration data (attenuator calibration, PA gain tables). Stored at base address 0x0000.

### Step 17 — PHASE 5 - Application Init
- **Register:** `DAC_CTRL` at `0x0900`
- **Write value:** `0x01`
- **Wait/Poll:** Immediate
- **Rationale:** Enable DAC and select channel 0 (VGA_VREF). Analog bias reference must be active before PA enable.

### Step 18 — PHASE 5 - Application Init
- **Register:** `DAC_DATA` at `0x0901`
- **Write value:** `0x800`
- **Wait/Poll:** Wait for DAC_READY=1
- **Rationale:** Set VGA_VREF to midscale (1.65V for 3.3V DAC). Provides nominal bias reference for HMC698LP4 attenuator.

### Step 19 — PHASE 5 - Application Init
- **Register:** `RF_ATTENUATION` at `0x0701`
- **Write value:** `0x40`
- **Wait/Poll:** Immediate
- **Rationale:** Set attenuator to minimum attenuation (code = 0) and enable attenuator (bit 6 = 1). Ensures maximum gain at TX enable.

### Step 20 — PHASE 5 - Application Init
- **Register:** `RF_POWER_SETPOINT` at `0x0704`
- **Write value:** `0x0190`
- **Wait/Poll:** Immediate
- **Rationale:** Set target output power to 40dBm (100 * 0.25dB = 25 = 0x0190). AGC loop will adjust attenuator to maintain this level.

### Step 21 — PHASE 5 - Application Init
- **Register:** `PA_BIAS_CTRL` at `0x0A00`
- **Write value:** `0x5000`
- **Wait/Poll:** Wait VGS_DELAY (5ms)
- **Rationale:** Configure PA bias with 5ms gate-source delay. Ensures proper PA bias sequencing for GaN MMIC reliability.

### Step 22 — PHASE 5 - Application Init
- **Register:** `RF_TX_ENABLE` at `0x0700`
- **Write value:** `0x01`
- **Wait/Poll:** Wait TX_EN_DELAY (1ms), verify RF_ON=1
- **Rationale:** Enable RF TX chain. FPGA sequences PA bias, waits 1ms ramp delay, then sets RF_ON flag. Confirms TX chain is active.

### Step 23 — PHASE 5 - Application Init
- **Register:** `RF_STATUS` at `0x0703`
- **Write value:** `READ`
- **Wait/Poll:** Verify PA_ENABLED=1, PA_FAULT=0, VSWR_HIGH=0
- **Rationale:** Final health check - verify PA enabled successfully with no faults. Confirm no high VSWR condition at output.

### Step 24 — PHASE 5 - Application Init
- **Register:** `GPIO_DIR` at `0x0800`
- **Write value:** `0x0F`
- **Wait/Poll:** Immediate
- **Rationale:** Configure GPIO[3:0] as outputs (for external indicators), GPIO[7:4] as inputs (for external fault signals).
