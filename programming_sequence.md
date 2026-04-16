# Programming Sequence (PSQ)
## mnb

> **Total steps:** 20

| # | Phase | Register | Address | Value | Condition | Rationale |
|---|-------|----------|---------|-------|-----------|-----------|
| 1 | Phase 1 - Power-On Reset & Self-Check | `SCRATCHPAD` | `0x0003` | `0xA5A5` | Read back verify = 0xA5A5 | RAM integrity check - write test pattern and read back to verify memory interface functionality |
| 2 | Phase 1 - Power-On Reset & Self-Check | `SCRATCHPAD` | `0x0003` | `0x5A5A` | Read back verify = 0x5A5A | Second pattern check - verifies bit integrity (inverted pattern) |
| 3 | Phase 1 - Power-On Reset & Self-Check | `HEALTH_STATUS` | `0x030F` | `N/A` | Poll until VOLT_OK=1 (bit 1 set), max 100ms | Wait for all power rails to stabilize within acceptable limits before proceeding |
| 4 | Phase 1 - Power-On Reset & Self-Check | `BOARD_ID` | `0x0000` | `N/A` | Verify ID == 0x4D4E ('MN' expected) | Board identification - confirm firmware is running on correct hardware (mnb receiver) |
| 5 | Phase 2 - PLL & Clock Init | `PLL_R_DIV` | `0x0403` | `0x0001` | None | Configure PLL R divider to 1 (reference clock division for ADF5355 synthesizer) |
| 6 | Phase 2 - PLL & Clock Init | `PLL_N_DIV` | `0x0402` | `0x0064` | None | Configure PLL N divider to 100 for initial LO frequency setup (tunable for RF band) |
| 7 | Phase 2 - PLL & Clock Init | `PLL_CTRL` | `0x0400` | `0x01` | Poll PLL_STATUS[0] until LOCKED=1, max 50ms | Enable ADF5355 PLL and wait for lock confirmation - LO must be stable before RF path enable |
| 8 | Phase 2 - PLL & Clock Init | `CLK_ENABLE` | `0x0410` | `0x0F` | None | Enable all clock outputs to FPGA fabric and peripherals |
| 9 | Phase 3 - Peripheral Enable | `TEMP_ALERT_HIGH` | `0x0308` | `0x0190` | None | Set over-temperature threshold to 100°C (0x190 * 0.25°C units) |
| 10 | Phase 3 - Peripheral Enable | `TEMP_ALERT_LOW` | `0x0309` | `0xFF9C` | None | Set under-temperature threshold to -25°C (signed, 2's complement) |
| 11 | Phase 3 - Peripheral Enable | `ADC_HS_CTRL` | `0x0800` | `0x01` | Poll ADC_HS_STATUS[1] until PLL_LOCK=1, max 10ms | Enable high-speed ADC (ADC12DJ3200) and wait for internal PLL lock |
| 12 | Phase 3 - Peripheral Enable | `RF_LNA_GAIN` | `0x0700` | `0x3FFF` | None | Set LNA (HMC698LP4) gain to moderate level - 50% of max range for initial operation |
| 13 | Phase 4 - Communication Init | `UART_BAUD_DIV` | `0x0100` | `0x0034` | None | Configure UART baud divisor for 115200 baud (assuming 100MHz reference clock) |
| 14 | Phase 4 - Communication Init | `UART_CTRL` | `0x0101` | `0x01` | None | Enable UART communication interface for external control and monitoring |
| 15 | Phase 5 - Application Init | `RF_BAND_SELECT` | `0x0703` | `0x0000` | None | Set initial RF band to 5-8 GHz range (band 0) - lower band for power-on state |
| 16 | Phase 5 - Application Init | `RF_MIXER_CTRL` | `0x0701` | `0x03` | None | Enable mixer (HMC1061LP4) and select LO port for down-conversion |
| 17 | Phase 5 - Application Init | `RF_AGC_ENABLE` | `0x0704` | `0x0001` | None | Enable automatic gain control to maintain optimal signal level through RF chain |
| 18 | Phase 5 - Application Init | `EEPROM_ADDR` | `0x0501` | `0x0000` | None | Set EEPROM address to 0x0000 for calibration data read |
| 19 | Phase 5 - Application Init | `EEPROM_CTRL` | `0x0500` | `0x01` | Poll EEPROM_CTRL[7] until BUSY=0 | Initiate EEPROM read operation to retrieve factory calibration data |
| 20 | Phase 5 - Application Init | `HEALTH_STATUS` | `0x030F` | `N/A` | Verify SYSTEM_OK=1 (bit 7 set) | Final system health verification - confirm all subsystems operational |

---

## Detailed Steps

### Step 1 — Phase 1 - Power-On Reset & Self-Check
- **Register:** `SCRATCHPAD` at `0x0003`
- **Write value:** `0xA5A5`
- **Wait/Poll:** Read back verify = 0xA5A5
- **Rationale:** RAM integrity check - write test pattern and read back to verify memory interface functionality

### Step 2 — Phase 1 - Power-On Reset & Self-Check
- **Register:** `SCRATCHPAD` at `0x0003`
- **Write value:** `0x5A5A`
- **Wait/Poll:** Read back verify = 0x5A5A
- **Rationale:** Second pattern check - verifies bit integrity (inverted pattern)

### Step 3 — Phase 1 - Power-On Reset & Self-Check
- **Register:** `HEALTH_STATUS` at `0x030F`
- **Write value:** `N/A`
- **Wait/Poll:** Poll until VOLT_OK=1 (bit 1 set), max 100ms
- **Rationale:** Wait for all power rails to stabilize within acceptable limits before proceeding

### Step 4 — Phase 1 - Power-On Reset & Self-Check
- **Register:** `BOARD_ID` at `0x0000`
- **Write value:** `N/A`
- **Wait/Poll:** Verify ID == 0x4D4E ('MN' expected)
- **Rationale:** Board identification - confirm firmware is running on correct hardware (mnb receiver)

### Step 5 — Phase 2 - PLL & Clock Init
- **Register:** `PLL_R_DIV` at `0x0403`
- **Write value:** `0x0001`
- **Wait/Poll:** None
- **Rationale:** Configure PLL R divider to 1 (reference clock division for ADF5355 synthesizer)

### Step 6 — Phase 2 - PLL & Clock Init
- **Register:** `PLL_N_DIV` at `0x0402`
- **Write value:** `0x0064`
- **Wait/Poll:** None
- **Rationale:** Configure PLL N divider to 100 for initial LO frequency setup (tunable for RF band)

### Step 7 — Phase 2 - PLL & Clock Init
- **Register:** `PLL_CTRL` at `0x0400`
- **Write value:** `0x01`
- **Wait/Poll:** Poll PLL_STATUS[0] until LOCKED=1, max 50ms
- **Rationale:** Enable ADF5355 PLL and wait for lock confirmation - LO must be stable before RF path enable

### Step 8 — Phase 2 - PLL & Clock Init
- **Register:** `CLK_ENABLE` at `0x0410`
- **Write value:** `0x0F`
- **Wait/Poll:** None
- **Rationale:** Enable all clock outputs to FPGA fabric and peripherals

### Step 9 — Phase 3 - Peripheral Enable
- **Register:** `TEMP_ALERT_HIGH` at `0x0308`
- **Write value:** `0x0190`
- **Wait/Poll:** None
- **Rationale:** Set over-temperature threshold to 100°C (0x190 * 0.25°C units)

### Step 10 — Phase 3 - Peripheral Enable
- **Register:** `TEMP_ALERT_LOW` at `0x0309`
- **Write value:** `0xFF9C`
- **Wait/Poll:** None
- **Rationale:** Set under-temperature threshold to -25°C (signed, 2's complement)

### Step 11 — Phase 3 - Peripheral Enable
- **Register:** `ADC_HS_CTRL` at `0x0800`
- **Write value:** `0x01`
- **Wait/Poll:** Poll ADC_HS_STATUS[1] until PLL_LOCK=1, max 10ms
- **Rationale:** Enable high-speed ADC (ADC12DJ3200) and wait for internal PLL lock

### Step 12 — Phase 3 - Peripheral Enable
- **Register:** `RF_LNA_GAIN` at `0x0700`
- **Write value:** `0x3FFF`
- **Wait/Poll:** None
- **Rationale:** Set LNA (HMC698LP4) gain to moderate level - 50% of max range for initial operation

### Step 13 — Phase 4 - Communication Init
- **Register:** `UART_BAUD_DIV` at `0x0100`
- **Write value:** `0x0034`
- **Wait/Poll:** None
- **Rationale:** Configure UART baud divisor for 115200 baud (assuming 100MHz reference clock)

### Step 14 — Phase 4 - Communication Init
- **Register:** `UART_CTRL` at `0x0101`
- **Write value:** `0x01`
- **Wait/Poll:** None
- **Rationale:** Enable UART communication interface for external control and monitoring

### Step 15 — Phase 5 - Application Init
- **Register:** `RF_BAND_SELECT` at `0x0703`
- **Write value:** `0x0000`
- **Wait/Poll:** None
- **Rationale:** Set initial RF band to 5-8 GHz range (band 0) - lower band for power-on state

### Step 16 — Phase 5 - Application Init
- **Register:** `RF_MIXER_CTRL` at `0x0701`
- **Write value:** `0x03`
- **Wait/Poll:** None
- **Rationale:** Enable mixer (HMC1061LP4) and select LO port for down-conversion

### Step 17 — Phase 5 - Application Init
- **Register:** `RF_AGC_ENABLE` at `0x0704`
- **Write value:** `0x0001`
- **Wait/Poll:** None
- **Rationale:** Enable automatic gain control to maintain optimal signal level through RF chain

### Step 18 — Phase 5 - Application Init
- **Register:** `EEPROM_ADDR` at `0x0501`
- **Write value:** `0x0000`
- **Wait/Poll:** None
- **Rationale:** Set EEPROM address to 0x0000 for calibration data read

### Step 19 — Phase 5 - Application Init
- **Register:** `EEPROM_CTRL` at `0x0500`
- **Write value:** `0x01`
- **Wait/Poll:** Poll EEPROM_CTRL[7] until BUSY=0
- **Rationale:** Initiate EEPROM read operation to retrieve factory calibration data

### Step 20 — Phase 5 - Application Init
- **Register:** `HEALTH_STATUS` at `0x030F`
- **Write value:** `N/A`
- **Wait/Poll:** Verify SYSTEM_OK=1 (bit 7 set)
- **Rationale:** Final system health verification - confirm all subsystems operational
