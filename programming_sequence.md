# Programming Sequence (PSQ)
## dgh

> **Total steps:** 23

| # | Phase | Register | Address | Value | Condition | Rationale |
|---|-------|----------|---------|-------|-----------|-----------|
| 1 | Power-On Reset & Self-Check | `SCRATCHPAD` | `0x0003` | `0xAAAA` | — | Write test pattern to scratchpad register to verify basic RAM functionality |
| 2 | Power-On Reset & Self-Check | `SCRATCHPAD` | `0x0003` | `0x0000` | Wait 100ms | Clear scratchpad register after test |
| 3 | Power-On Reset & Self-Check | `BOARD_ID` | `0x0000` | `0x0000` | — | Read board ID to verify correct hardware identification |
| 4 | Power-On Reset & Self-Check | `HEALTH_STATUS` | `0x030F` | `0x0000` | Poll until VOLT_OK=1 (timeout 1000ms) | Wait until power rails are stable before proceeding |
| 5 | PLL & Clock Init | `PLL_N_DIV` | `0x0402` | `0x0064` | — | Set N divider to default value for target frequency |
| 6 | PLL & Clock Init | `PLL_R_DIV` | `0x0403` | `0x0004` | — | Set R divider to reference clock division |
| 7 | PLL & Clock Init | `PLL_CTRL` | `0x0400` | `0x0001` | Wait 10ms, then write 0x0003 | Reset and enable PLL, wait for lock |
| 8 | PLL & Clock Init | `PLL_CTRL` | `0x0400` | `0x0001` | Poll PLL_STATUS[0] until LOCKED=1 (timeout 500ms) | Wait for PLL to lock before enabling clocks |
| 9 | PLL & Clock Init | `CLK_ENABLE` | `0x0410` | `0x0F` | — | Enable required clock outputs (4 channels) |
| 10 | Peripheral Enable | `RF_BIAS_CTRL` | `0x0015` | `0x001F` | — | Enable RF bias for all components (limiter, filter, LNA, driver, buffer) |
| 11 | Peripheral Enable | `UART_CTRL` | `0x0101` | `0x0001` | — | Enable UART communication interface |
| 12 | Communication Init | `UART_BAUD_DIV` | `0x0100` | `0x003C` | — | Set UART baud rate divisor for 115200 baud |
| 13 | Application Init | `RF_SELECT` | `0x0013` | `0x0001` | — | Enable default RF channel (channel 1) |
| 14 | Application Init | `RF_LNA_GAIN` | `0x0014` | `0x0A` | — | Set default LNA gain to medium setting |
| 15 | Application Init | `TEMP_ALERT_HIGH` | `0x0308` | `0x0190` | — | Set over-temperature alert threshold to 100°C |
| 16 | Application Init | `TEMP_ALERT_LOW` | `0x0309` | `0xFF9C` | — | Set under-temperature alert threshold to -25°C |
| 17 | Application Init | `FLASH_ADDR_LOW` | `0x0601` | `0x0000` | — | Initialize flash interface with base address |
| 18 | Application Init | `EEPROM_ADDR` | `0x0501` | `0x0000` | — | Initialize EEPROM interface with base address |
| 19 | Application Init | `DAC_CH1` | `0x0900` | `0x0800` | — | Set default bias for RF channel 1 |
| 20 | Application Init | `DAC_CH2` | `0x0901` | `0x0800` | — | Set default bias for RF channel 2 |
| 21 | Application Init | `DAC_CH3` | `0x0902` | `0x0800` | — | Set default bias for RF channel 3 |
| 22 | Application Init | `DAC_CH4` | `0x0903` | `0x0800` | — | Set default bias for RF channel 4 |
| 23 | Application Init | `RF_FILTER_SELECT` | `0x0904` | `0x0000` | — | Initialize RF filter to default band selection |

---

## Detailed Steps

### Step 1 — Power-On Reset & Self-Check
- **Register:** `SCRATCHPAD` at `0x0003`
- **Write value:** `0xAAAA`
- **Rationale:** Write test pattern to scratchpad register to verify basic RAM functionality

### Step 2 — Power-On Reset & Self-Check
- **Register:** `SCRATCHPAD` at `0x0003`
- **Write value:** `0x0000`
- **Wait/Poll:** Wait 100ms
- **Rationale:** Clear scratchpad register after test

### Step 3 — Power-On Reset & Self-Check
- **Register:** `BOARD_ID` at `0x0000`
- **Write value:** `0x0000`
- **Rationale:** Read board ID to verify correct hardware identification

### Step 4 — Power-On Reset & Self-Check
- **Register:** `HEALTH_STATUS` at `0x030F`
- **Write value:** `0x0000`
- **Wait/Poll:** Poll until VOLT_OK=1 (timeout 1000ms)
- **Rationale:** Wait until power rails are stable before proceeding

### Step 5 — PLL & Clock Init
- **Register:** `PLL_N_DIV` at `0x0402`
- **Write value:** `0x0064`
- **Rationale:** Set N divider to default value for target frequency

### Step 6 — PLL & Clock Init
- **Register:** `PLL_R_DIV` at `0x0403`
- **Write value:** `0x0004`
- **Rationale:** Set R divider to reference clock division

### Step 7 — PLL & Clock Init
- **Register:** `PLL_CTRL` at `0x0400`
- **Write value:** `0x0001`
- **Wait/Poll:** Wait 10ms, then write 0x0003
- **Rationale:** Reset and enable PLL, wait for lock

### Step 8 — PLL & Clock Init
- **Register:** `PLL_CTRL` at `0x0400`
- **Write value:** `0x0001`
- **Wait/Poll:** Poll PLL_STATUS[0] until LOCKED=1 (timeout 500ms)
- **Rationale:** Wait for PLL to lock before enabling clocks

### Step 9 — PLL & Clock Init
- **Register:** `CLK_ENABLE` at `0x0410`
- **Write value:** `0x0F`
- **Rationale:** Enable required clock outputs (4 channels)

### Step 10 — Peripheral Enable
- **Register:** `RF_BIAS_CTRL` at `0x0015`
- **Write value:** `0x001F`
- **Rationale:** Enable RF bias for all components (limiter, filter, LNA, driver, buffer)

### Step 11 — Peripheral Enable
- **Register:** `UART_CTRL` at `0x0101`
- **Write value:** `0x0001`
- **Rationale:** Enable UART communication interface

### Step 12 — Communication Init
- **Register:** `UART_BAUD_DIV` at `0x0100`
- **Write value:** `0x003C`
- **Rationale:** Set UART baud rate divisor for 115200 baud

### Step 13 — Application Init
- **Register:** `RF_SELECT` at `0x0013`
- **Write value:** `0x0001`
- **Rationale:** Enable default RF channel (channel 1)

### Step 14 — Application Init
- **Register:** `RF_LNA_GAIN` at `0x0014`
- **Write value:** `0x0A`
- **Rationale:** Set default LNA gain to medium setting

### Step 15 — Application Init
- **Register:** `TEMP_ALERT_HIGH` at `0x0308`
- **Write value:** `0x0190`
- **Rationale:** Set over-temperature alert threshold to 100°C

### Step 16 — Application Init
- **Register:** `TEMP_ALERT_LOW` at `0x0309`
- **Write value:** `0xFF9C`
- **Rationale:** Set under-temperature alert threshold to -25°C

### Step 17 — Application Init
- **Register:** `FLASH_ADDR_LOW` at `0x0601`
- **Write value:** `0x0000`
- **Rationale:** Initialize flash interface with base address

### Step 18 — Application Init
- **Register:** `EEPROM_ADDR` at `0x0501`
- **Write value:** `0x0000`
- **Rationale:** Initialize EEPROM interface with base address

### Step 19 — Application Init
- **Register:** `DAC_CH1` at `0x0900`
- **Write value:** `0x0800`
- **Rationale:** Set default bias for RF channel 1

### Step 20 — Application Init
- **Register:** `DAC_CH2` at `0x0901`
- **Write value:** `0x0800`
- **Rationale:** Set default bias for RF channel 2

### Step 21 — Application Init
- **Register:** `DAC_CH3` at `0x0902`
- **Write value:** `0x0800`
- **Rationale:** Set default bias for RF channel 3

### Step 22 — Application Init
- **Register:** `DAC_CH4` at `0x0903`
- **Write value:** `0x0800`
- **Rationale:** Set default bias for RF channel 4

### Step 23 — Application Init
- **Register:** `RF_FILTER_SELECT` at `0x0904`
- **Write value:** `0x0000`
- **Rationale:** Initialize RF filter to default band selection
