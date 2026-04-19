# Programming Sequence (PSQ)
## hh

> **Total steps:** 28

| # | Phase | Register | Address | Value | Condition | Rationale |
|---|-------|----------|---------|-------|-----------|-----------|
| 1 | Power-On Reset & Self-Check | `SCRATCHPAD` | `0x0003` | `0xDEAD` | Read back SCRATCHPAD = 0xDEAD | Test basic memory functionality |
| 2 | Power-On Reset & Self-Check | `HEALTH_STATUS` | `0x030F` | `0x00` | Poll until VOLT_OK = 1 | Wait for power rails to stabilize |
| 3 | Power-On Reset & Self-Check | `BOARD_ID` | `0x0000` | `0x0000` | Read BOARD_ID = 0x55AA | Verify board identity |
| 4 | Power-On Reset & Self-Check | `SCRATCHPAD` | `0x0003` | `0x0000` | Read back = 0x0000 | Verify scratchpad cleanup |
| 5 | PLL & Clock Init | `PLL_CTRL` | `0x0400` | `0x02` | No condition | Reset PLL |
| 6 | PLL & Clock Init | `PLL_N_DIV` | `0x0402` | `0x0050` | No condition | Set N divider |
| 7 | PLL & Clock Init | `PLL_R_DIV` | `0x0403` | `0x0005` | Poll PLL_STATUS until LOCKED = 1 | Set R divider and wait for lock |
| 8 | PLL & Clock Init | `PLL_CTRL` | `0x0400` | `0x01` | No condition | Enable PLL |
| 9 | Peripheral Enable | `CLK_ENABLE` | `0x0410` | `0x07` | No condition | Enable required clock outputs |
| 10 | Peripheral Enable | `WDT_CTRL` | `0x0800` | `0x0003` | No condition | Enable watchdog timer |
| 11 | Communication Init | `UART_BAUD_DIV` | `0x0100` | `0x0068` | No condition | Set UART baud rate to 9600 |
| 12 | Communication Init | `UART_CTRL` | `0x0101` | `0x01` | No condition | Enable UART |
| 13 | Temperature Monitoring Init | `TEMP_ALERT_HIGH` | `0x0308` | `0x0190` | No condition | Set high temperature alert to 100°C |
| 14 | Temperature Monitoring Init | `TEMP_ALERT_LOW` | `0x0309` | `0xFF9C` | No condition | Set low temperature alert to -25°C |
| 15 | Flash Interface Init | `FLASH_CTRL` | `0x0600` | `0x01` | Poll FLASH_STATUS until READY = 1 | Read flash ID |
| 16 | Flash Interface Init | `FLASH_ADDR_LOW` | `0x0601` | `0x0000` | No condition | Set flash address to 0 |
| 17 | Flash Interface Init | `FLASH_CTRL` | `0x0600` | `0x01` | Poll FLASH_STATUS until READY = 1 | Read manufacturer ID |
| 18 | EEPROM Init | `EEPROM_CTRL` | `0x0500` | `0x01` | No condition | Enable EEPROM read |
| 19 | EEPROM Init | `EEPROM_ADDR` | `0x0501` | `0x0000` | No condition | Set EEPROM address to 0 |
| 20 | EEPROM Init | `EEPROM_CTRL` | `0x0500` | `0x00` | No condition | Read calibration data from EEPROM |
| 21 | RF Frontend Init | `RF_MODE` | `0x070F` | `0x00` | No condition | Set RF mode to normal operation |
| 22 | RF Frontend Init | `LIM_CTRL` | `0x0710` | `0x0F` | No condition | Set limiter threshold |
| 23 | RF Frontend Init | `RF_GAIN_ANT1` | `0x0708` | `0x0F0F` | No condition | Set initial gain for antenna 1 channels |
| 24 | RF Frontend Init | `RF_GAIN_ANT2` | `0x0709` | `0x0F0F` | No condition | Set initial gain for antenna 2 channels |
| 25 | RF Frontend Init | `RF_EN_ANT1` | `0x0700` | `0x01` | No condition | Enable antenna 1 channel 1 |
| 26 | RF Frontend Init | `RF_EN_ANT2` | `0x0701` | `0x01` | No condition | Enable antenna 2 channel 1 |
| 27 | GPIO Configuration | `GPIO_DIR` | `0x0808` | `0xFF` | No condition | Configure all GPIO as outputs |
| 28 | GPIO Configuration | `GPIO_OUT` | `0x0809` | `0x00` | No condition | Set all GPIO outputs to 0 |

---

## Detailed Steps

### Step 1 — Power-On Reset & Self-Check
- **Register:** `SCRATCHPAD` at `0x0003`
- **Write value:** `0xDEAD`
- **Wait/Poll:** Read back SCRATCHPAD = 0xDEAD
- **Rationale:** Test basic memory functionality

### Step 2 — Power-On Reset & Self-Check
- **Register:** `HEALTH_STATUS` at `0x030F`
- **Write value:** `0x00`
- **Wait/Poll:** Poll until VOLT_OK = 1
- **Rationale:** Wait for power rails to stabilize

### Step 3 — Power-On Reset & Self-Check
- **Register:** `BOARD_ID` at `0x0000`
- **Write value:** `0x0000`
- **Wait/Poll:** Read BOARD_ID = 0x55AA
- **Rationale:** Verify board identity

### Step 4 — Power-On Reset & Self-Check
- **Register:** `SCRATCHPAD` at `0x0003`
- **Write value:** `0x0000`
- **Wait/Poll:** Read back = 0x0000
- **Rationale:** Verify scratchpad cleanup

### Step 5 — PLL & Clock Init
- **Register:** `PLL_CTRL` at `0x0400`
- **Write value:** `0x02`
- **Wait/Poll:** No condition
- **Rationale:** Reset PLL

### Step 6 — PLL & Clock Init
- **Register:** `PLL_N_DIV` at `0x0402`
- **Write value:** `0x0050`
- **Wait/Poll:** No condition
- **Rationale:** Set N divider

### Step 7 — PLL & Clock Init
- **Register:** `PLL_R_DIV` at `0x0403`
- **Write value:** `0x0005`
- **Wait/Poll:** Poll PLL_STATUS until LOCKED = 1
- **Rationale:** Set R divider and wait for lock

### Step 8 — PLL & Clock Init
- **Register:** `PLL_CTRL` at `0x0400`
- **Write value:** `0x01`
- **Wait/Poll:** No condition
- **Rationale:** Enable PLL

### Step 9 — Peripheral Enable
- **Register:** `CLK_ENABLE` at `0x0410`
- **Write value:** `0x07`
- **Wait/Poll:** No condition
- **Rationale:** Enable required clock outputs

### Step 10 — Peripheral Enable
- **Register:** `WDT_CTRL` at `0x0800`
- **Write value:** `0x0003`
- **Wait/Poll:** No condition
- **Rationale:** Enable watchdog timer

### Step 11 — Communication Init
- **Register:** `UART_BAUD_DIV` at `0x0100`
- **Write value:** `0x0068`
- **Wait/Poll:** No condition
- **Rationale:** Set UART baud rate to 9600

### Step 12 — Communication Init
- **Register:** `UART_CTRL` at `0x0101`
- **Write value:** `0x01`
- **Wait/Poll:** No condition
- **Rationale:** Enable UART

### Step 13 — Temperature Monitoring Init
- **Register:** `TEMP_ALERT_HIGH` at `0x0308`
- **Write value:** `0x0190`
- **Wait/Poll:** No condition
- **Rationale:** Set high temperature alert to 100°C

### Step 14 — Temperature Monitoring Init
- **Register:** `TEMP_ALERT_LOW` at `0x0309`
- **Write value:** `0xFF9C`
- **Wait/Poll:** No condition
- **Rationale:** Set low temperature alert to -25°C

### Step 15 — Flash Interface Init
- **Register:** `FLASH_CTRL` at `0x0600`
- **Write value:** `0x01`
- **Wait/Poll:** Poll FLASH_STATUS until READY = 1
- **Rationale:** Read flash ID

### Step 16 — Flash Interface Init
- **Register:** `FLASH_ADDR_LOW` at `0x0601`
- **Write value:** `0x0000`
- **Wait/Poll:** No condition
- **Rationale:** Set flash address to 0

### Step 17 — Flash Interface Init
- **Register:** `FLASH_CTRL` at `0x0600`
- **Write value:** `0x01`
- **Wait/Poll:** Poll FLASH_STATUS until READY = 1
- **Rationale:** Read manufacturer ID

### Step 18 — EEPROM Init
- **Register:** `EEPROM_CTRL` at `0x0500`
- **Write value:** `0x01`
- **Wait/Poll:** No condition
- **Rationale:** Enable EEPROM read

### Step 19 — EEPROM Init
- **Register:** `EEPROM_ADDR` at `0x0501`
- **Write value:** `0x0000`
- **Wait/Poll:** No condition
- **Rationale:** Set EEPROM address to 0

### Step 20 — EEPROM Init
- **Register:** `EEPROM_CTRL` at `0x0500`
- **Write value:** `0x00`
- **Wait/Poll:** No condition
- **Rationale:** Read calibration data from EEPROM

### Step 21 — RF Frontend Init
- **Register:** `RF_MODE` at `0x070F`
- **Write value:** `0x00`
- **Wait/Poll:** No condition
- **Rationale:** Set RF mode to normal operation

### Step 22 — RF Frontend Init
- **Register:** `LIM_CTRL` at `0x0710`
- **Write value:** `0x0F`
- **Wait/Poll:** No condition
- **Rationale:** Set limiter threshold

### Step 23 — RF Frontend Init
- **Register:** `RF_GAIN_ANT1` at `0x0708`
- **Write value:** `0x0F0F`
- **Wait/Poll:** No condition
- **Rationale:** Set initial gain for antenna 1 channels

### Step 24 — RF Frontend Init
- **Register:** `RF_GAIN_ANT2` at `0x0709`
- **Write value:** `0x0F0F`
- **Wait/Poll:** No condition
- **Rationale:** Set initial gain for antenna 2 channels

### Step 25 — RF Frontend Init
- **Register:** `RF_EN_ANT1` at `0x0700`
- **Write value:** `0x01`
- **Wait/Poll:** No condition
- **Rationale:** Enable antenna 1 channel 1

### Step 26 — RF Frontend Init
- **Register:** `RF_EN_ANT2` at `0x0701`
- **Write value:** `0x01`
- **Wait/Poll:** No condition
- **Rationale:** Enable antenna 2 channel 1

### Step 27 — GPIO Configuration
- **Register:** `GPIO_DIR` at `0x0808`
- **Write value:** `0xFF`
- **Wait/Poll:** No condition
- **Rationale:** Configure all GPIO as outputs

### Step 28 — GPIO Configuration
- **Register:** `GPIO_OUT` at `0x0809`
- **Write value:** `0x00`
- **Wait/Poll:** No condition
- **Rationale:** Set all GPIO outputs to 0
