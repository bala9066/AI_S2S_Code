# Programming Sequence (PSQ)
## jhf

> **Total steps:** 18

| # | Phase | Register | Address | Value | Condition | Rationale |
|---|-------|----------|---------|-------|-----------|-----------|
| 1 | PHASE 1: Power-On Reset & Self-Check | `SCRATCHPAD` | `0x0003` | `0xA5A5` | Read back 0xA5A5 | RAM and UART bus integrity test - write known pattern and verify read back to confirm data path functional |
| 2 | PHASE 1: Power-On Reset & Self-Check | `SCRATCHPAD` | `0x0003` | `0x5A5A` | Read back 0x5A5A | Second integrity test with inverted pattern to catch stuck-at faults |
| 3 | PHASE 1: Power-On Reset & Self-Check | `HEALTH_STATUS` | `0x030F` | `N/A (read)` | Poll until VOLT_OK=1 | Wait for all power rails (12V, 5V, 3.3V, -5V) to stabilize within regulation window before enabling peripherals |
| 4 | PHASE 1: Power-On Reset & Self-Check | `BOARD_ID` | `0x0000` | `N/A (read)` | Verify value = 0x4A48 | Confirm correct FPGA firmware loaded and running on JHF receiver hardware |
| 5 | PHASE 2: PLL & Clock Init | `PLL_CTRL` | `0x0400` | `0x00` | Wait 10us | Assert PLL reset to ensure clean startup state before configuration |
| 6 | PHASE 2: PLL & Clock Init | `PLL_N_DIV` | `0x0402` | `0x0078` | None | Configure ADF5356 N divider for target LO frequency (N=120 for 8GHz example) |
| 7 | PHASE 2: PLL & Clock Init | `PLL_R_DIV` | `0x0403` | `0x0001` | None | Configure reference divider R=1 for 10MHz or 100MHz reference input |
| 8 | PHASE 2: PLL & Clock Init | `PLL_CTRL` | `0x0400` | `0x01` | Poll PLL_STATUS[0] until LOCKED=1 | Enable ADF5356 PLL and wait for lock confirmation before using LO |
| 9 | PHASE 2: PLL & Clock Init | `CLK_ENABLE` | `0x0410` | `0x0F` | None | Enable all system clocks (LO, ADC, IF, DSP) for full operation |
| 10 | PHASE 3: Peripheral Enable | `RF_LO_CTRL` | `0x0702` | `0x01` | Wait for LO_FREQ registers to load | Trigger load of frequency configuration to ADF5356 SPI interface |
| 11 | PHASE 3: Peripheral Enable | `RF_PATH_CTRL` | `0x0709` | `0x0F` | None | Enable entire RF signal chain (LNA, mixer, VGA, IF amp) for receive path |
| 12 | PHASE 3: Peripheral Enable | `VGA_GAIN_CTRL` | `0x0708` | `0x20` | None | Set VGA to mid-scale gain (0x20 = 0dB nominal) to avoid saturation at startup |
| 13 | PHASE 4: Communication Init | `UART_BAUD_DIV` | `0x0100` | `0x0022` | None | Configure UART for 115200 baud (100MHz/34/16 ≈ 115200) for host communication |
| 14 | PHASE 4: Communication Init | `UART_CTRL` | `0x0101` | `0x01` | None | Enable UART transmitter and receiver for command interface |
| 15 | PHASE 5: Application Init | `TEMP_ALERT_HIGH` | `0x0308` | `0x003C` | None | Arm over-temperature alert at 60°C for FPGA and RF module protection |
| 16 | PHASE 5: Application Init | `TEMP_ALERT_LOW` | `0x0309` | `0xFF9C` | None | Arm under-temperature alert at -25°C for condensation prevention |
| 17 | PHASE 5: Application Init | `EEPROM_CTRL` | `0x0500` | `0x01` | Wait for BUSY=0, read EEPROM_ADDR=0x0000 | Read calibration data from AT25M01 EEPROM at base address for factory gain/phase offsets |
| 18 | PHASE 5: Application Init | `LED_CTRL` | `0x0802` | `0x09` | None | Set power LED ON and status LED ON to indicate system ready state (error/RF off until locked) |

---

## Detailed Steps

### Step 1 — PHASE 1: Power-On Reset & Self-Check
- **Register:** `SCRATCHPAD` at `0x0003`
- **Write value:** `0xA5A5`
- **Wait/Poll:** Read back 0xA5A5
- **Rationale:** RAM and UART bus integrity test - write known pattern and verify read back to confirm data path functional

### Step 2 — PHASE 1: Power-On Reset & Self-Check
- **Register:** `SCRATCHPAD` at `0x0003`
- **Write value:** `0x5A5A`
- **Wait/Poll:** Read back 0x5A5A
- **Rationale:** Second integrity test with inverted pattern to catch stuck-at faults

### Step 3 — PHASE 1: Power-On Reset & Self-Check
- **Register:** `HEALTH_STATUS` at `0x030F`
- **Write value:** `N/A (read)`
- **Wait/Poll:** Poll until VOLT_OK=1
- **Rationale:** Wait for all power rails (12V, 5V, 3.3V, -5V) to stabilize within regulation window before enabling peripherals

### Step 4 — PHASE 1: Power-On Reset & Self-Check
- **Register:** `BOARD_ID` at `0x0000`
- **Write value:** `N/A (read)`
- **Wait/Poll:** Verify value = 0x4A48
- **Rationale:** Confirm correct FPGA firmware loaded and running on JHF receiver hardware

### Step 5 — PHASE 2: PLL & Clock Init
- **Register:** `PLL_CTRL` at `0x0400`
- **Write value:** `0x00`
- **Wait/Poll:** Wait 10us
- **Rationale:** Assert PLL reset to ensure clean startup state before configuration

### Step 6 — PHASE 2: PLL & Clock Init
- **Register:** `PLL_N_DIV` at `0x0402`
- **Write value:** `0x0078`
- **Wait/Poll:** None
- **Rationale:** Configure ADF5356 N divider for target LO frequency (N=120 for 8GHz example)

### Step 7 — PHASE 2: PLL & Clock Init
- **Register:** `PLL_R_DIV` at `0x0403`
- **Write value:** `0x0001`
- **Wait/Poll:** None
- **Rationale:** Configure reference divider R=1 for 10MHz or 100MHz reference input

### Step 8 — PHASE 2: PLL & Clock Init
- **Register:** `PLL_CTRL` at `0x0400`
- **Write value:** `0x01`
- **Wait/Poll:** Poll PLL_STATUS[0] until LOCKED=1
- **Rationale:** Enable ADF5356 PLL and wait for lock confirmation before using LO

### Step 9 — PHASE 2: PLL & Clock Init
- **Register:** `CLK_ENABLE` at `0x0410`
- **Write value:** `0x0F`
- **Wait/Poll:** None
- **Rationale:** Enable all system clocks (LO, ADC, IF, DSP) for full operation

### Step 10 — PHASE 3: Peripheral Enable
- **Register:** `RF_LO_CTRL` at `0x0702`
- **Write value:** `0x01`
- **Wait/Poll:** Wait for LO_FREQ registers to load
- **Rationale:** Trigger load of frequency configuration to ADF5356 SPI interface

### Step 11 — PHASE 3: Peripheral Enable
- **Register:** `RF_PATH_CTRL` at `0x0709`
- **Write value:** `0x0F`
- **Wait/Poll:** None
- **Rationale:** Enable entire RF signal chain (LNA, mixer, VGA, IF amp) for receive path

### Step 12 — PHASE 3: Peripheral Enable
- **Register:** `VGA_GAIN_CTRL` at `0x0708`
- **Write value:** `0x20`
- **Wait/Poll:** None
- **Rationale:** Set VGA to mid-scale gain (0x20 = 0dB nominal) to avoid saturation at startup

### Step 13 — PHASE 4: Communication Init
- **Register:** `UART_BAUD_DIV` at `0x0100`
- **Write value:** `0x0022`
- **Wait/Poll:** None
- **Rationale:** Configure UART for 115200 baud (100MHz/34/16 ≈ 115200) for host communication

### Step 14 — PHASE 4: Communication Init
- **Register:** `UART_CTRL` at `0x0101`
- **Write value:** `0x01`
- **Wait/Poll:** None
- **Rationale:** Enable UART transmitter and receiver for command interface

### Step 15 — PHASE 5: Application Init
- **Register:** `TEMP_ALERT_HIGH` at `0x0308`
- **Write value:** `0x003C`
- **Wait/Poll:** None
- **Rationale:** Arm over-temperature alert at 60°C for FPGA and RF module protection

### Step 16 — PHASE 5: Application Init
- **Register:** `TEMP_ALERT_LOW` at `0x0309`
- **Write value:** `0xFF9C`
- **Wait/Poll:** None
- **Rationale:** Arm under-temperature alert at -25°C for condensation prevention

### Step 17 — PHASE 5: Application Init
- **Register:** `EEPROM_CTRL` at `0x0500`
- **Write value:** `0x01`
- **Wait/Poll:** Wait for BUSY=0, read EEPROM_ADDR=0x0000
- **Rationale:** Read calibration data from AT25M01 EEPROM at base address for factory gain/phase offsets

### Step 18 — PHASE 5: Application Init
- **Register:** `LED_CTRL` at `0x0802`
- **Write value:** `0x09`
- **Wait/Poll:** None
- **Rationale:** Set power LED ON and status LED ON to indicate system ready state (error/RF off until locked)
