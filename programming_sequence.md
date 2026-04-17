# Programming Sequence (PSQ)
## Test

> **Total steps:** 15

| # | Phase | Register | Address | Value | Condition | Rationale |
|---|-------|----------|---------|-------|-----------|-----------|
| 1 | Power-On Reset | `SCRATCHPAD` | `0x0003` | `0xA5A5` | Read back == 0xA5A5 | RAM/bus self-test — verifies register read-write path |
| 2 | Power-On Reset | `HEALTH_STATUS` | `0x830F` | `poll` | VOLT_OK=1 | Wait for power rails to stabilise |
| 3 | Power-On Reset | `BOARD_ID` | `0x8000` | `read` | Match expected | Verify correct board hardware |
| 4 | Power-On Reset | `TEMP_LOCAL` | `0x8300` | `read` | < 85C | Initial temperature sanity check |
| 5 | Clock Init | `PLL_CTRL` | `0x0400` | `0x0002` | — | Assert PLL reset |
| 6 | Clock Init | `PLL_N_DIV` | `0x0402` | `0x0008` | — | Set N divider for target frequency |
| 7 | Clock Init | `PLL_CTRL` | `0x0400` | `0x0001` | PLL_STATUS.LOCKED=1 within 10ms | Enable PLL, wait for lock |
| 8 | Clock Init | `CLK_ENABLE` | `0x0410` | `0x00FF` | — | Enable all clock outputs |
| 9 | Peripheral Init | `ADC_CTRL` | `0x0200` | `0x0003` | — | Enable ADC in continuous mode |
| 10 | Peripheral Init | `TEMP_ALERT_HIGH` | `0x0308` | `0x0190` | — | Set over-temp alert to 100C |
| 11 | Communication Init | `UART_BAUD_DIV` | `0x0100` | `0x001A` | — | Configure 115200 baud (48MHz / 26) |
| 12 | Communication Init | `UART_CTRL` | `0x0101` | `0x0001` | — | Enable UART |
| 13 | Storage Init | `EEPROM_CTRL` | `0x0500` | `0x0001` | BUSY=0 | Read calibration data from EEPROM |
| 14 | Application Init | `GPIO_DIR` | `0x0800` | `0x00FF` | — | Configure lower 8 GPIO as outputs |
| 15 | Application Init | `GPIO_OUT` | `0x0801` | `0x0001` | — | Assert LED/status indicator — system ready |

---

## Detailed Steps

### Step 1 — Power-On Reset
- **Register:** `SCRATCHPAD` at `0x0003`
- **Write value:** `0xA5A5`
- **Wait/Poll:** Read back == 0xA5A5
- **Rationale:** RAM/bus self-test — verifies register read-write path

### Step 2 — Power-On Reset
- **Register:** `HEALTH_STATUS` at `0x830F`
- **Write value:** `poll`
- **Wait/Poll:** VOLT_OK=1
- **Rationale:** Wait for power rails to stabilise

### Step 3 — Power-On Reset
- **Register:** `BOARD_ID` at `0x8000`
- **Write value:** `read`
- **Wait/Poll:** Match expected
- **Rationale:** Verify correct board hardware

### Step 4 — Power-On Reset
- **Register:** `TEMP_LOCAL` at `0x8300`
- **Write value:** `read`
- **Wait/Poll:** < 85C
- **Rationale:** Initial temperature sanity check

### Step 5 — Clock Init
- **Register:** `PLL_CTRL` at `0x0400`
- **Write value:** `0x0002`
- **Rationale:** Assert PLL reset

### Step 6 — Clock Init
- **Register:** `PLL_N_DIV` at `0x0402`
- **Write value:** `0x0008`
- **Rationale:** Set N divider for target frequency

### Step 7 — Clock Init
- **Register:** `PLL_CTRL` at `0x0400`
- **Write value:** `0x0001`
- **Wait/Poll:** PLL_STATUS.LOCKED=1 within 10ms
- **Rationale:** Enable PLL, wait for lock

### Step 8 — Clock Init
- **Register:** `CLK_ENABLE` at `0x0410`
- **Write value:** `0x00FF`
- **Rationale:** Enable all clock outputs

### Step 9 — Peripheral Init
- **Register:** `ADC_CTRL` at `0x0200`
- **Write value:** `0x0003`
- **Rationale:** Enable ADC in continuous mode

### Step 10 — Peripheral Init
- **Register:** `TEMP_ALERT_HIGH` at `0x0308`
- **Write value:** `0x0190`
- **Rationale:** Set over-temp alert to 100C

### Step 11 — Communication Init
- **Register:** `UART_BAUD_DIV` at `0x0100`
- **Write value:** `0x001A`
- **Rationale:** Configure 115200 baud (48MHz / 26)

### Step 12 — Communication Init
- **Register:** `UART_CTRL` at `0x0101`
- **Write value:** `0x0001`
- **Rationale:** Enable UART

### Step 13 — Storage Init
- **Register:** `EEPROM_CTRL` at `0x0500`
- **Write value:** `0x0001`
- **Wait/Poll:** BUSY=0
- **Rationale:** Read calibration data from EEPROM

### Step 14 — Application Init
- **Register:** `GPIO_DIR` at `0x0800`
- **Write value:** `0x00FF`
- **Rationale:** Configure lower 8 GPIO as outputs

### Step 15 — Application Init
- **Register:** `GPIO_OUT` at `0x0801`
- **Write value:** `0x0001`
- **Rationale:** Assert LED/status indicator — system ready
