# Programming Sequence (PSQ)
## Receiver Module

> **Total steps:** 30

| # | Phase | Register | Address | Value | Condition | Rationale |
|---|-------|----------|---------|-------|-----------|-----------|
| 1 | Power-On Reset & Self-Check | `SCRATCHPAD` | `0x0003` | `0xA5A5` | Read back after write, verify match | RAM self-check - verify register read/write functionality and UART communication path |
| 2 | Power-On Reset & Self-Check | `SCRATCHPAD` | `0x0003` | `0x5A5A` | Read back after write, verify match | Secondary RAM check with inverted pattern to detect stuck bits |
| 3 | Power-On Reset & Self-Check | `BOARD_ID` | `0x0000` | `0x524D` | Verify read value matches expected 0x524D ('RM') | Verify correct FPGA image loaded and board identification |
| 4 | Power-On Reset & Self-Check | `BOARD_VERSION` | `0x0001` | `0x10` | Verify version >= 0x10 | Check board hardware version compatibility |
| 5 | Power-On Reset & Self-Check | `HEALTH_STATUS` | `0x030F` | `Read` | Poll until VOLT_OK=1 (bit 1 set), max 1 second | Wait for power supply rails to stabilize before proceeding |
| 6 | PLL & Clock Init | `PLL_CTRL` | `0x0400` | `0x02` | None | Assert PLL reset to ensure clean startup state |
| 7 | PLL & Clock Init | `PLL_N_DIV` | `0x0402` | `0x0064` | None | Set N divider to 100 for target frequency (f_out = f_ref * N / R) |
| 8 | PLL & Clock Init | `PLL_R_DIV` | `0x0403` | `0x02` | None | Set R divider to 2 for reference clock division |
| 9 | PLL & Clock Init | `PLL_CTRL` | `0x0400` | `0x01` | None | Enable PLL (release reset, set enable bit) |
| 10 | PLL & Clock Init | `PLL_STATUS` | `0x0401` | `Read` | Poll until LOCKED=1 (bit 0 set), max 100ms | Wait for PLL to achieve lock before enabling clock outputs |
| 11 | PLL & Clock Init | `CLK_ENABLE` | `0x0410` | `0xFF` | None | Enable all clock outputs for downstream peripherals |
| 12 | Peripheral Enable | `RF_CTRL` | `0x0708` | `0x0C` | None | Enable LO buffer and IF amplifier (keep LNA/Mixer off for now) |
| 13 | Peripheral Enable | `RF_STATUS` | `0x0709` | `Read` | Verify RF_POWER_GOOD=1 and LO_DETECT based on presence | Check RF power and LO input status before enabling RF chain |
| 14 | Communication Init | `UART_BAUD_DIV` | `0x0100` | `0x0034` | None | Set UART baud rate to 115200 baud (assuming 12MHz FPGA clock) |
| 15 | Communication Init | `UART_CTRL` | `0x0101` | `0x01` | None | Enable UART transmitter and receiver |
| 16 | Communication Init | `UART_STATUS` | `0x0102` | `Read` | Verify no errors (FRAME_ERR=0, PARITY_ERR=0) | Check UART for any startup errors |
| 17 | Application Init | `ADC_CTRL` | `0x0200` | `0x02` | None | Enable continuous ADC sampling for supply monitoring |
| 18 | Application Init | `TEMP_ALERT_HIGH` | `0x0308` | `0x0190` | None | Set over-temperature alert threshold to 100°C (0x190 * 0.25°C) |
| 19 | Application Init | `TEMP_ALERT_LOW` | `0x0309` | `0xFF9C` | None | Set under-temperature alert threshold to -25°C (signed 0xFF9C * 0.25°C) |
| 20 | Application Init | `VGA_GAIN_CTRL` | `0x0700` | `0x20` | Poll VGA_STATUS until SPI_BUSY=0 | Set initial VGA gain to 16dB (code 0x20 = 32 * 0.5dB) - moderate startup gain |
| 21 | Application Init | `RSSI_THRESH_HIGH` | `0x0711` | `0x0F00` | None | Set RSSI high threshold for AGC overload protection |
| 22 | Application Init | `RSSI_THRESH_LOW` | `0x0712` | `0x0100` | None | Set RSSI low threshold for signal detect |
| 23 | Application Init | `EEPROM_ADDR` | `0x0501` | `0x0000` | None | Set EEPROM address to start of calibration data |
| 24 | Application Init | `EEPROM_CTRL` | `0x0500` | `0x01` | Poll EEPROM_CTRL until BUSY=0 | Trigger EEPROM read of factory calibration data |
| 25 | Application Init | `CALIB_DATA` | `0x0900` | `Read` | Verify CALIB_CRC matches calculated CRC | Read and validate factory calibration data (gain offsets) |
| 26 | Application Init | `FLASH_ADDR_LOW` | `0x0601` | `0x0000` | None | Set flash address for configuration read |
| 27 | Application Init | `FLASH_ADDR_HIGH` | `0x0602` | `0x00` | None | Set flash high address byte |
| 28 | Application Init | `FLASH_CTRL` | `0x0600` | `0x01` | Poll FLASH_STATUS until READY=1 | Initiate flash configuration read |
| 29 | RF Chain Enable | `RF_CTRL` | `0x0708` | `0x0F` | None | Enable LNA and Mixer (full RF chain enable) - last step to prevent noise during init |
| 30 | RF Chain Enable | `RF_STATUS` | `0x0709` | `Read` | Verify LNA_BIAS_OK=1 and MIXER_BIAS_OK=1 | Final verification that RF chain is properly biased and operational |

---

## Detailed Steps

### Step 1 — Power-On Reset & Self-Check
- **Register:** `SCRATCHPAD` at `0x0003`
- **Write value:** `0xA5A5`
- **Wait/Poll:** Read back after write, verify match
- **Rationale:** RAM self-check - verify register read/write functionality and UART communication path

### Step 2 — Power-On Reset & Self-Check
- **Register:** `SCRATCHPAD` at `0x0003`
- **Write value:** `0x5A5A`
- **Wait/Poll:** Read back after write, verify match
- **Rationale:** Secondary RAM check with inverted pattern to detect stuck bits

### Step 3 — Power-On Reset & Self-Check
- **Register:** `BOARD_ID` at `0x0000`
- **Write value:** `0x524D`
- **Wait/Poll:** Verify read value matches expected 0x524D ('RM')
- **Rationale:** Verify correct FPGA image loaded and board identification

### Step 4 — Power-On Reset & Self-Check
- **Register:** `BOARD_VERSION` at `0x0001`
- **Write value:** `0x10`
- **Wait/Poll:** Verify version >= 0x10
- **Rationale:** Check board hardware version compatibility

### Step 5 — Power-On Reset & Self-Check
- **Register:** `HEALTH_STATUS` at `0x030F`
- **Write value:** `Read`
- **Wait/Poll:** Poll until VOLT_OK=1 (bit 1 set), max 1 second
- **Rationale:** Wait for power supply rails to stabilize before proceeding

### Step 6 — PLL & Clock Init
- **Register:** `PLL_CTRL` at `0x0400`
- **Write value:** `0x02`
- **Wait/Poll:** None
- **Rationale:** Assert PLL reset to ensure clean startup state

### Step 7 — PLL & Clock Init
- **Register:** `PLL_N_DIV` at `0x0402`
- **Write value:** `0x0064`
- **Wait/Poll:** None
- **Rationale:** Set N divider to 100 for target frequency (f_out = f_ref * N / R)

### Step 8 — PLL & Clock Init
- **Register:** `PLL_R_DIV` at `0x0403`
- **Write value:** `0x02`
- **Wait/Poll:** None
- **Rationale:** Set R divider to 2 for reference clock division

### Step 9 — PLL & Clock Init
- **Register:** `PLL_CTRL` at `0x0400`
- **Write value:** `0x01`
- **Wait/Poll:** None
- **Rationale:** Enable PLL (release reset, set enable bit)

### Step 10 — PLL & Clock Init
- **Register:** `PLL_STATUS` at `0x0401`
- **Write value:** `Read`
- **Wait/Poll:** Poll until LOCKED=1 (bit 0 set), max 100ms
- **Rationale:** Wait for PLL to achieve lock before enabling clock outputs

### Step 11 — PLL & Clock Init
- **Register:** `CLK_ENABLE` at `0x0410`
- **Write value:** `0xFF`
- **Wait/Poll:** None
- **Rationale:** Enable all clock outputs for downstream peripherals

### Step 12 — Peripheral Enable
- **Register:** `RF_CTRL` at `0x0708`
- **Write value:** `0x0C`
- **Wait/Poll:** None
- **Rationale:** Enable LO buffer and IF amplifier (keep LNA/Mixer off for now)

### Step 13 — Peripheral Enable
- **Register:** `RF_STATUS` at `0x0709`
- **Write value:** `Read`
- **Wait/Poll:** Verify RF_POWER_GOOD=1 and LO_DETECT based on presence
- **Rationale:** Check RF power and LO input status before enabling RF chain

### Step 14 — Communication Init
- **Register:** `UART_BAUD_DIV` at `0x0100`
- **Write value:** `0x0034`
- **Wait/Poll:** None
- **Rationale:** Set UART baud rate to 115200 baud (assuming 12MHz FPGA clock)

### Step 15 — Communication Init
- **Register:** `UART_CTRL` at `0x0101`
- **Write value:** `0x01`
- **Wait/Poll:** None
- **Rationale:** Enable UART transmitter and receiver

### Step 16 — Communication Init
- **Register:** `UART_STATUS` at `0x0102`
- **Write value:** `Read`
- **Wait/Poll:** Verify no errors (FRAME_ERR=0, PARITY_ERR=0)
- **Rationale:** Check UART for any startup errors

### Step 17 — Application Init
- **Register:** `ADC_CTRL` at `0x0200`
- **Write value:** `0x02`
- **Wait/Poll:** None
- **Rationale:** Enable continuous ADC sampling for supply monitoring

### Step 18 — Application Init
- **Register:** `TEMP_ALERT_HIGH` at `0x0308`
- **Write value:** `0x0190`
- **Wait/Poll:** None
- **Rationale:** Set over-temperature alert threshold to 100°C (0x190 * 0.25°C)

### Step 19 — Application Init
- **Register:** `TEMP_ALERT_LOW` at `0x0309`
- **Write value:** `0xFF9C`
- **Wait/Poll:** None
- **Rationale:** Set under-temperature alert threshold to -25°C (signed 0xFF9C * 0.25°C)

### Step 20 — Application Init
- **Register:** `VGA_GAIN_CTRL` at `0x0700`
- **Write value:** `0x20`
- **Wait/Poll:** Poll VGA_STATUS until SPI_BUSY=0
- **Rationale:** Set initial VGA gain to 16dB (code 0x20 = 32 * 0.5dB) - moderate startup gain

### Step 21 — Application Init
- **Register:** `RSSI_THRESH_HIGH` at `0x0711`
- **Write value:** `0x0F00`
- **Wait/Poll:** None
- **Rationale:** Set RSSI high threshold for AGC overload protection

### Step 22 — Application Init
- **Register:** `RSSI_THRESH_LOW` at `0x0712`
- **Write value:** `0x0100`
- **Wait/Poll:** None
- **Rationale:** Set RSSI low threshold for signal detect

### Step 23 — Application Init
- **Register:** `EEPROM_ADDR` at `0x0501`
- **Write value:** `0x0000`
- **Wait/Poll:** None
- **Rationale:** Set EEPROM address to start of calibration data

### Step 24 — Application Init
- **Register:** `EEPROM_CTRL` at `0x0500`
- **Write value:** `0x01`
- **Wait/Poll:** Poll EEPROM_CTRL until BUSY=0
- **Rationale:** Trigger EEPROM read of factory calibration data

### Step 25 — Application Init
- **Register:** `CALIB_DATA` at `0x0900`
- **Write value:** `Read`
- **Wait/Poll:** Verify CALIB_CRC matches calculated CRC
- **Rationale:** Read and validate factory calibration data (gain offsets)

### Step 26 — Application Init
- **Register:** `FLASH_ADDR_LOW` at `0x0601`
- **Write value:** `0x0000`
- **Wait/Poll:** None
- **Rationale:** Set flash address for configuration read

### Step 27 — Application Init
- **Register:** `FLASH_ADDR_HIGH` at `0x0602`
- **Write value:** `0x00`
- **Wait/Poll:** None
- **Rationale:** Set flash high address byte

### Step 28 — Application Init
- **Register:** `FLASH_CTRL` at `0x0600`
- **Write value:** `0x01`
- **Wait/Poll:** Poll FLASH_STATUS until READY=1
- **Rationale:** Initiate flash configuration read

### Step 29 — RF Chain Enable
- **Register:** `RF_CTRL` at `0x0708`
- **Write value:** `0x0F`
- **Wait/Poll:** None
- **Rationale:** Enable LNA and Mixer (full RF chain enable) - last step to prevent noise during init

### Step 30 — RF Chain Enable
- **Register:** `RF_STATUS` at `0x0709`
- **Write value:** `Read`
- **Wait/Poll:** Verify LNA_BIAS_OK=1 and MIXER_BIAS_OK=1
- **Rationale:** Final verification that RF chain is properly biased and operational
