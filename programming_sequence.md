# Programming Sequence (PSQ)
## gvng

> **Total steps:** 18

| # | Phase | Register | Address | Value | Condition | Rationale |
|---|-------|----------|---------|-------|-----------|-----------|
| 1 | Power-On Reset & Self-Check | `SCRATCHPAD` | `0x0003` | `0xA5A5` | — | Write test pattern to SCRATCHPAD to verify RAM functionality and basic communication |
| 2 | Power-On Reset & Self-Check | `SCRATCHPAD` | `0x0003` | `0x0000` | Wait for value to be 0xA5A5 | Read back written value to verify proper operation |
| 3 | Power-On Reset & Self-Check | `SCRATCHPAD` | `0x0003` | `0x0000` | — | Clear SCRATCHPAD after verification |
| 4 | Power-On Reset & Self-Check | `HEALTH_STATUS` | `0x030F` | `0x00` | Poll until VOLT_OK=1 | Wait for power rails to stabilize before proceeding with initialization |
| 5 | PLL & Clock Init | `BOARD_ID` | `0x0000` | `0x00` | — | Read BOARD_ID to verify board identification matches expected value (0x5756) |
| 6 | PLL & Clock Init | `PLL_N_DIV` | `0x0402` | `0x0200` | — | Configure PLL N divider for 100MHz output (50MHz ref * 2) |
| 7 | PLL & Clock Init | `PLL_CTRL` | `0x0400` | `0x01` | Poll PLL_STATUS[0] until LOCKED=1 | Enable PLL and wait for lock before enabling clock outputs |
| 8 | Peripheral Enable | `CLK_ENABLE` | `0x0410` | `0x0F` | — | Enable required clock outputs (bits 0-3) |
| 9 | Peripheral Enable | `GPIO_CTRL` | `0x8000` | `0x00FF` | — | Configure GPIO pins 0-7 as outputs for LED indicators |
| 10 | Peripheral Enable | `ADC_CTRL` | `0x0200` | `0x05` | — | Enable continuous ADC conversion on channel 1 (3.3V monitoring) |
| 11 | Communication Init | `UART_BAUD_DIV` | `0x0100` | `0x0096` | — | Configure UART for 115200 baud rate (50MHz / 96 = 520833Hz / 45.45 ≈ 115200) |
| 12 | Communication Init | `UART_CTRL` | `0x0101` | `0x01` | — | Enable UART with 8N1 frame format |
| 13 | Application Init | `TEMP_ALERT_HIGH` | `0x0308` | `0x0190` | — | Set high temperature alert threshold to 100°C (0x190 * 0.25°C = 100°C) |
| 14 | Application Init | `TEMP_ALERT_LOW` | `0x0309` | `0xFF9C` | — | Set low temperature alert threshold to -25°C (0xFF9C * 0.25°C = -25°C) |
| 15 | Application Init | `FLASH_CTRL` | `0x0600` | `0x00` | — | Initialize flash interface to ready state |
| 16 | Application Init | `EEPROM_CTRL` | `0x0500` | `0x00` | — | Initialize EEPROM interface to ready state |
| 17 | Application Init | `RF_CTRL` | `0x7000` | `0x01` | — | Enable RF module for operation |
| 18 | Application Init | `DAC_CTRL` | `0x9000` | `0x01` | — | Enable DAC module with 0-2.5V range |

---

## Detailed Steps

### Step 1 — Power-On Reset & Self-Check
- **Register:** `SCRATCHPAD` at `0x0003`
- **Write value:** `0xA5A5`
- **Rationale:** Write test pattern to SCRATCHPAD to verify RAM functionality and basic communication

### Step 2 — Power-On Reset & Self-Check
- **Register:** `SCRATCHPAD` at `0x0003`
- **Write value:** `0x0000`
- **Wait/Poll:** Wait for value to be 0xA5A5
- **Rationale:** Read back written value to verify proper operation

### Step 3 — Power-On Reset & Self-Check
- **Register:** `SCRATCHPAD` at `0x0003`
- **Write value:** `0x0000`
- **Rationale:** Clear SCRATCHPAD after verification

### Step 4 — Power-On Reset & Self-Check
- **Register:** `HEALTH_STATUS` at `0x030F`
- **Write value:** `0x00`
- **Wait/Poll:** Poll until VOLT_OK=1
- **Rationale:** Wait for power rails to stabilize before proceeding with initialization

### Step 5 — PLL & Clock Init
- **Register:** `BOARD_ID` at `0x0000`
- **Write value:** `0x00`
- **Rationale:** Read BOARD_ID to verify board identification matches expected value (0x5756)

### Step 6 — PLL & Clock Init
- **Register:** `PLL_N_DIV` at `0x0402`
- **Write value:** `0x0200`
- **Rationale:** Configure PLL N divider for 100MHz output (50MHz ref * 2)

### Step 7 — PLL & Clock Init
- **Register:** `PLL_CTRL` at `0x0400`
- **Write value:** `0x01`
- **Wait/Poll:** Poll PLL_STATUS[0] until LOCKED=1
- **Rationale:** Enable PLL and wait for lock before enabling clock outputs

### Step 8 — Peripheral Enable
- **Register:** `CLK_ENABLE` at `0x0410`
- **Write value:** `0x0F`
- **Rationale:** Enable required clock outputs (bits 0-3)

### Step 9 — Peripheral Enable
- **Register:** `GPIO_CTRL` at `0x8000`
- **Write value:** `0x00FF`
- **Rationale:** Configure GPIO pins 0-7 as outputs for LED indicators

### Step 10 — Peripheral Enable
- **Register:** `ADC_CTRL` at `0x0200`
- **Write value:** `0x05`
- **Rationale:** Enable continuous ADC conversion on channel 1 (3.3V monitoring)

### Step 11 — Communication Init
- **Register:** `UART_BAUD_DIV` at `0x0100`
- **Write value:** `0x0096`
- **Rationale:** Configure UART for 115200 baud rate (50MHz / 96 = 520833Hz / 45.45 ≈ 115200)

### Step 12 — Communication Init
- **Register:** `UART_CTRL` at `0x0101`
- **Write value:** `0x01`
- **Rationale:** Enable UART with 8N1 frame format

### Step 13 — Application Init
- **Register:** `TEMP_ALERT_HIGH` at `0x0308`
- **Write value:** `0x0190`
- **Rationale:** Set high temperature alert threshold to 100°C (0x190 * 0.25°C = 100°C)

### Step 14 — Application Init
- **Register:** `TEMP_ALERT_LOW` at `0x0309`
- **Write value:** `0xFF9C`
- **Rationale:** Set low temperature alert threshold to -25°C (0xFF9C * 0.25°C = -25°C)

### Step 15 — Application Init
- **Register:** `FLASH_CTRL` at `0x0600`
- **Write value:** `0x00`
- **Rationale:** Initialize flash interface to ready state

### Step 16 — Application Init
- **Register:** `EEPROM_CTRL` at `0x0500`
- **Write value:** `0x00`
- **Rationale:** Initialize EEPROM interface to ready state

### Step 17 — Application Init
- **Register:** `RF_CTRL` at `0x7000`
- **Write value:** `0x01`
- **Rationale:** Enable RF module for operation

### Step 18 — Application Init
- **Register:** `DAC_CTRL` at `0x9000`
- **Write value:** `0x01`
- **Rationale:** Enable DAC module with 0-2.5V range
