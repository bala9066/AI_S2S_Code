# Programming Sequence (PSQ)
## Rf Receiver

> **Total steps:** 20

| # | Phase | Register | Address | Value | Condition | Rationale |
|---|-------|----------|---------|-------|-----------|-----------|
| 1 | Power-On Reset & Self-Check | `SCRATCHPAD` | `0x0003` | `0xAAAA` | Wait 1ms | Write known pattern 0xAAAA to SCRATCHPAD register to verify FPGA RAM integrity and UART communication path is functional |
| 2 | Power-On Reset & Self-Check | `SCRATCHPAD` | `0x0003` | `0x0000` | Read back verify 0x0000 | Clear SCRATCHPAD after verification - confirms read/write path is bidirectional and register not stuck |
| 3 | Power-On Reset & Self-Check | `BOARD_ID` | `0x0000` | `N/A` | Read verify = 0xA505 | Read BOARD_ID register to confirm correct FPGA firmware is loaded and addressing is valid - expect 0xA505 for RF Receiver |
| 4 | Power-On Reset & Self-Check | `HEALTH_STATUS` | `0x030F` | `N/A` | Poll until VOLT_OK=1 (timeout 100ms) | Poll HEALTH_STATUS register until VOLT_OK bit is set - ensures 5V and 8V rails have stabilized within tolerance after power-on |
| 5 | PLL & Clock Init | `PLL_CTRL` | `0x0400` | `0x02` | Wait 100ns | Assert PLL reset (bit[1]=1) to ensure PLL starts from clean state - prevents glitched lock condition |
| 6 | PLL & Clock Init | `PLL_N_DIV` | `0x0402` | `0x0032` | None | Configure PLL N divider to 50 (0x0032) for target frequency synthesis - must be set before enabling PLL |
| 7 | PLL & Clock Init | `PLL_R_DIV` | `0x0403` | `0x0001` | None | Configure PLL R divider to 1 for reference division - completes PLL configuration before enable |
| 8 | PLL & Clock Init | `PLL_CTRL` | `0x0400` | `0x01` | Poll PLL_STATUS[0]=1 (timeout 10ms) | Enable PLL (bit[0]=1) and release reset - poll LOCKED bit to confirm PLL achieves lock before proceeding |
| 9 | PLL & Clock Init | `CLK_ENABLE` | `0x0410` | `0x0F` | None | Enable clock outputs 0-3 (bit[3:0]=1111) to distribute clock to peripherals and RF circuitry |
| 10 | Peripheral Enable | `ADC_CTRL` | `0x0200` | `0x03` | None | Enable ADC continuous conversion mode (bit[1]=1, bit[0]=1) for real-time voltage and current monitoring |
| 11 | Communication Init | `UART_BAUD_DIV` | `0x0100` | `0x0034` | None | Configure UART baud rate divisor to 52 (0x0034) for 115200 baud operation at 50MHz system clock |
| 12 | Communication Init | `UART_CTRL` | `0x0101` | `0x01` | None | Enable UART transmitter and receiver (bit[0]=1) - uses default 8N1 frame format for host communication |
| 13 | Application Init | `TEMP_ALERT_HIGH` | `0x0308` | `0x0190` | None | Arm high temperature alert threshold to 100°C (0x0190 in 0.25°C units) - protects RF components from overheating |
| 14 | Application Init | `TEMP_ALERT_LOW` | `0x0309` | `0xFF9C` | None | Arm low temperature alert threshold to -25°C (0xFF9C signed) - prevents operation below rated temperature range |
| 15 | Application Init | `EEPROM_ADDR` | `0x0501` | `0x0000` | None | Set EEPROM address to 0x0000 for calibration data retrieval - prepare for read of factory calibration |
| 16 | Application Init | `EEPROM_CTRL` | `0x0500` | `0x01` | Poll BUSY=0 (timeout 10ms) | Trigger EEPROM read operation (bit[0]=1) and wait for completion - loads calibration data into EEPROM_DATA register |
| 17 | Application Init | `RF_ENABLE` | `0x0708` | `0x03` | None | Enable RF chain - LNA (bit[0]) and Driver Amp (bit[1]) - only after all monitoring and calibration is complete |
| 18 | Application Init | `RF_STATUS` | `0x070F` | `N/A` | Verify LNA_OK=1 and DRIVER_OK=1 | Verify RF chain status - confirm LNA and driver amplifier bias is OK before declaring system operational |
| 19 | Application Init | `FLASH_CTRL` | `0x0600` | `0x01` | Poll BUSY=0 (timeout 50ms) | Initialize flash interface with read command - verifies flash presence and readiness for field upgrades |
| 20 | Application Init | `HEALTH_STATUS` | `0x030F` | `N/A` | Verify SYSTEM_OK=1 | Final system health check - confirm TEMP_OK, VOLT_OK, PLL_LOCK all pass before entering normal operation |

---

## Detailed Steps

### Step 1 — Power-On Reset & Self-Check
- **Register:** `SCRATCHPAD` at `0x0003`
- **Write value:** `0xAAAA`
- **Wait/Poll:** Wait 1ms
- **Rationale:** Write known pattern 0xAAAA to SCRATCHPAD register to verify FPGA RAM integrity and UART communication path is functional

### Step 2 — Power-On Reset & Self-Check
- **Register:** `SCRATCHPAD` at `0x0003`
- **Write value:** `0x0000`
- **Wait/Poll:** Read back verify 0x0000
- **Rationale:** Clear SCRATCHPAD after verification - confirms read/write path is bidirectional and register not stuck

### Step 3 — Power-On Reset & Self-Check
- **Register:** `BOARD_ID` at `0x0000`
- **Write value:** `N/A`
- **Wait/Poll:** Read verify = 0xA505
- **Rationale:** Read BOARD_ID register to confirm correct FPGA firmware is loaded and addressing is valid - expect 0xA505 for RF Receiver

### Step 4 — Power-On Reset & Self-Check
- **Register:** `HEALTH_STATUS` at `0x030F`
- **Write value:** `N/A`
- **Wait/Poll:** Poll until VOLT_OK=1 (timeout 100ms)
- **Rationale:** Poll HEALTH_STATUS register until VOLT_OK bit is set - ensures 5V and 8V rails have stabilized within tolerance after power-on

### Step 5 — PLL & Clock Init
- **Register:** `PLL_CTRL` at `0x0400`
- **Write value:** `0x02`
- **Wait/Poll:** Wait 100ns
- **Rationale:** Assert PLL reset (bit[1]=1) to ensure PLL starts from clean state - prevents glitched lock condition

### Step 6 — PLL & Clock Init
- **Register:** `PLL_N_DIV` at `0x0402`
- **Write value:** `0x0032`
- **Wait/Poll:** None
- **Rationale:** Configure PLL N divider to 50 (0x0032) for target frequency synthesis - must be set before enabling PLL

### Step 7 — PLL & Clock Init
- **Register:** `PLL_R_DIV` at `0x0403`
- **Write value:** `0x0001`
- **Wait/Poll:** None
- **Rationale:** Configure PLL R divider to 1 for reference division - completes PLL configuration before enable

### Step 8 — PLL & Clock Init
- **Register:** `PLL_CTRL` at `0x0400`
- **Write value:** `0x01`
- **Wait/Poll:** Poll PLL_STATUS[0]=1 (timeout 10ms)
- **Rationale:** Enable PLL (bit[0]=1) and release reset - poll LOCKED bit to confirm PLL achieves lock before proceeding

### Step 9 — PLL & Clock Init
- **Register:** `CLK_ENABLE` at `0x0410`
- **Write value:** `0x0F`
- **Wait/Poll:** None
- **Rationale:** Enable clock outputs 0-3 (bit[3:0]=1111) to distribute clock to peripherals and RF circuitry

### Step 10 — Peripheral Enable
- **Register:** `ADC_CTRL` at `0x0200`
- **Write value:** `0x03`
- **Wait/Poll:** None
- **Rationale:** Enable ADC continuous conversion mode (bit[1]=1, bit[0]=1) for real-time voltage and current monitoring

### Step 11 — Communication Init
- **Register:** `UART_BAUD_DIV` at `0x0100`
- **Write value:** `0x0034`
- **Wait/Poll:** None
- **Rationale:** Configure UART baud rate divisor to 52 (0x0034) for 115200 baud operation at 50MHz system clock

### Step 12 — Communication Init
- **Register:** `UART_CTRL` at `0x0101`
- **Write value:** `0x01`
- **Wait/Poll:** None
- **Rationale:** Enable UART transmitter and receiver (bit[0]=1) - uses default 8N1 frame format for host communication

### Step 13 — Application Init
- **Register:** `TEMP_ALERT_HIGH` at `0x0308`
- **Write value:** `0x0190`
- **Wait/Poll:** None
- **Rationale:** Arm high temperature alert threshold to 100°C (0x0190 in 0.25°C units) - protects RF components from overheating

### Step 14 — Application Init
- **Register:** `TEMP_ALERT_LOW` at `0x0309`
- **Write value:** `0xFF9C`
- **Wait/Poll:** None
- **Rationale:** Arm low temperature alert threshold to -25°C (0xFF9C signed) - prevents operation below rated temperature range

### Step 15 — Application Init
- **Register:** `EEPROM_ADDR` at `0x0501`
- **Write value:** `0x0000`
- **Wait/Poll:** None
- **Rationale:** Set EEPROM address to 0x0000 for calibration data retrieval - prepare for read of factory calibration

### Step 16 — Application Init
- **Register:** `EEPROM_CTRL` at `0x0500`
- **Write value:** `0x01`
- **Wait/Poll:** Poll BUSY=0 (timeout 10ms)
- **Rationale:** Trigger EEPROM read operation (bit[0]=1) and wait for completion - loads calibration data into EEPROM_DATA register

### Step 17 — Application Init
- **Register:** `RF_ENABLE` at `0x0708`
- **Write value:** `0x03`
- **Wait/Poll:** None
- **Rationale:** Enable RF chain - LNA (bit[0]) and Driver Amp (bit[1]) - only after all monitoring and calibration is complete

### Step 18 — Application Init
- **Register:** `RF_STATUS` at `0x070F`
- **Write value:** `N/A`
- **Wait/Poll:** Verify LNA_OK=1 and DRIVER_OK=1
- **Rationale:** Verify RF chain status - confirm LNA and driver amplifier bias is OK before declaring system operational

### Step 19 — Application Init
- **Register:** `FLASH_CTRL` at `0x0600`
- **Write value:** `0x01`
- **Wait/Poll:** Poll BUSY=0 (timeout 50ms)
- **Rationale:** Initialize flash interface with read command - verifies flash presence and readiness for field upgrades

### Step 20 — Application Init
- **Register:** `HEALTH_STATUS` at `0x030F`
- **Write value:** `N/A`
- **Wait/Poll:** Verify SYSTEM_OK=1
- **Rationale:** Final system health check - confirm TEMP_OK, VOLT_OK, PLL_LOCK all pass before entering normal operation
