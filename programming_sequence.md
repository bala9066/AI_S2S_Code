# Programming Sequence (PSQ)
## hfuf

> **Total steps:** 34

| # | Phase | Register | Address | Value | Condition | Rationale |
|---|-------|----------|---------|-------|-----------|-----------|
| 1 | Power-On Reset & Self-Check | `SCRATCHPAD` | `0x0003` | `0xA5A5` | Read back and verify = 0xA5A5 | Verify register read/write integrity and UART communication path before proceeding with initialization |
| 2 | Power-On Reset & Self-Check | `SCRATCHPAD` | `0x0003` | `0x0000` | Read back and verify = 0x0000 | Second pass verification with different pattern to detect stuck bits |
| 3 | Power-On Reset & Self-Check | `BOARD_ID` | `0x0000` | `0x0000` | Verify returned value = 0x4855 ('HU') | Confirm correct FPGA image is loaded and board identification matches expected HFUF module |
| 4 | Power-On Reset & Self-Check | `HEALTH_STATUS` | `0x030F` | `0x0000` | Poll until VOLT_OK=1 (bit 1 set) | Wait for all power rails to stabilize before enabling any circuitry - prevents brownout conditions |
| 5 | PLL & Clock Init | `PLL_CTRL` | `0x0400` | `0x02` | Wait 1ms | Assert PLL reset to ensure clean startup state |
| 6 | PLL & Clock Init | `PLL_N_DIV` | `0x0402` | `0x0032` | None | Configure N divider = 50 for target frequency output |
| 7 | PLL & Clock Init | `PLL_R_DIV` | `0x0403` | `0x01` | None | Configure R divider = 1 (reference not divided) |
| 8 | PLL & Clock Init | `PLL_CTRL` | `0x0400` | `0x01` | Poll PLL_STATUS[0] until LOCKED=1 | Enable PLL and wait for lock confirmation - clocks must be stable before enabling peripherals |
| 9 | PLL & Clock Init | `CLK_ENABLE` | `0x0410` | `0xFF` | None | Enable all clock outputs to downstream peripherals |
| 10 | Communication Init | `UART_BAUD_DIV` | `0x0100` | `0x0034` | None | Configure UART baud rate divisor for 115200 baud with 6MHz reference clock |
| 11 | Communication Init | `UART_CTRL` | `0x0101` | `0x01` | None | Enable UART interface for command/control communication |
| 12 | Temperature & Health Init | `TEMP_ALERT_HIGH` | `0x0308` | `0x0190` | None | Set over-temperature alert threshold to 100°C |
| 13 | Temperature & Health Init | `TEMP_ALERT_LOW` | `0x0309` | `0xFF9C` | None | Set under-temperature alert threshold to -25°C |
| 14 | Temperature & Health Init | `TEMP_LOCAL` | `0x0300` | `0x0000` | Verify TEMP < 85°C at startup | Confirm safe starting temperature before enabling RF paths |
| 15 | EEPROM Init | `EEPROM_ADDR` | `0x0501` | `0x0000` | None | Set EEPROM address to read calibration data from start of memory |
| 16 | EEPROM Init | `EEPROM_CTRL` | `0x0500` | `0x01` | Poll BUSY bit until cleared | Initiate EEPROM read of calibration data |
| 17 | EEPROM Init | `EEPROM_DATA` | `0x0502` | `0x0000` | Read calibration data and validate CRC | Retrieve factory calibration data for RF gain and bias settings |
| 18 | Flash Init | `FLASH_ADDR_HIGH` | `0x0602` | `0x00` | None | Initialize flash address pointer for configuration verification |
| 19 | Flash Init | `FLASH_ADDR_LOW` | `0x0601` | `0x0000` | None | Set low word of flash address |
| 20 | Flash Init | `FLASH_CTRL` | `0x0600` | `0x01` | Poll BUSY until cleared, check READY=1 | Verify flash interface is functional and ready for operations |
| 21 | ABC Sequencer Init | `ABC_SEQUENCER_CTRL` | `0x0710` | `0x02` | Wait 10ms | Reset ABC sequencer state machine to known initial condition |
| 22 | ABC Sequencer Init | `ABC_SEQUENCER_CTRL` | `0x0710` | `0x04` | None | Configure 10ms delay multiplier for bias ramp timing |
| 23 | ABC Sequencer Init | `ABC_GATE_CTRL_CH1` | `0x0711` | `0x1000` | None | Set initial gate bias voltage for Channel 1 (DAC = mid-scale, disabled) |
| 24 | ABC Sequencer Init | `ABC_GATE_CTRL_CH2` | `0x0712` | `0x1000` | None | Set initial gate bias voltage for Channel 2 |
| 25 | ABC Sequencer Init | `ABC_GATE_CTRL_CH3` | `0x0713` | `0x1000` | None | Set initial gate bias voltage for Channel 3 |
| 26 | ABC Sequencer Init | `ABC_GATE_CTRL_CH4` | `0x0714` | `0x1000` | None | Set initial gate bias voltage for Channel 4 |
| 27 | RF Path Init | `RF_GAIN_CTRL_CH1` | `0x0701` | `0x0000` | None | Initialize Channel 1 gain blocks to minimum setting before enable |
| 28 | RF Path Init | `RF_GAIN_CTRL_CH2` | `0x0702` | `0x0000` | None | Initialize Channel 2 gain blocks to minimum setting |
| 29 | RF Path Init | `RF_GAIN_CTRL_CH3` | `0x0703` | `0x0000` | None | Initialize Channel 3 gain blocks to minimum setting |
| 30 | RF Path Init | `RF_GAIN_CTRL_CH4` | `0x0704` | `0x0000` | None | Initialize Channel 4 gain blocks to minimum setting |
| 31 | Application Init | `ABC_SEQUENCER_CTRL` | `0x0710` | `0x05` | Poll ABC_STATUS[15] until ALL_BIAS_OK=1 | Enable ABC sequencer with auto-ramp and wait for all gate biases to stabilize |
| 32 | Application Init | `RF_PATH_CTRL` | `0x0700` | `0x000F` | None | Enable all 4 RF signal paths after biases are stable - system now operational |
| 33 | Application Init | `ADC_CTRL` | `0x0200` | `0x03` | None | Enable continuous ADC monitoring of all supply rails |
| 34 | Application Init | `HEALTH_STATUS` | `0x030F` | `0x0000` | Verify SYSTEM_OK=1 | Final health check - confirm all subsystems report healthy status |

---

## Detailed Steps

### Step 1 — Power-On Reset & Self-Check
- **Register:** `SCRATCHPAD` at `0x0003`
- **Write value:** `0xA5A5`
- **Wait/Poll:** Read back and verify = 0xA5A5
- **Rationale:** Verify register read/write integrity and UART communication path before proceeding with initialization

### Step 2 — Power-On Reset & Self-Check
- **Register:** `SCRATCHPAD` at `0x0003`
- **Write value:** `0x0000`
- **Wait/Poll:** Read back and verify = 0x0000
- **Rationale:** Second pass verification with different pattern to detect stuck bits

### Step 3 — Power-On Reset & Self-Check
- **Register:** `BOARD_ID` at `0x0000`
- **Write value:** `0x0000`
- **Wait/Poll:** Verify returned value = 0x4855 ('HU')
- **Rationale:** Confirm correct FPGA image is loaded and board identification matches expected HFUF module

### Step 4 — Power-On Reset & Self-Check
- **Register:** `HEALTH_STATUS` at `0x030F`
- **Write value:** `0x0000`
- **Wait/Poll:** Poll until VOLT_OK=1 (bit 1 set)
- **Rationale:** Wait for all power rails to stabilize before enabling any circuitry - prevents brownout conditions

### Step 5 — PLL & Clock Init
- **Register:** `PLL_CTRL` at `0x0400`
- **Write value:** `0x02`
- **Wait/Poll:** Wait 1ms
- **Rationale:** Assert PLL reset to ensure clean startup state

### Step 6 — PLL & Clock Init
- **Register:** `PLL_N_DIV` at `0x0402`
- **Write value:** `0x0032`
- **Wait/Poll:** None
- **Rationale:** Configure N divider = 50 for target frequency output

### Step 7 — PLL & Clock Init
- **Register:** `PLL_R_DIV` at `0x0403`
- **Write value:** `0x01`
- **Wait/Poll:** None
- **Rationale:** Configure R divider = 1 (reference not divided)

### Step 8 — PLL & Clock Init
- **Register:** `PLL_CTRL` at `0x0400`
- **Write value:** `0x01`
- **Wait/Poll:** Poll PLL_STATUS[0] until LOCKED=1
- **Rationale:** Enable PLL and wait for lock confirmation - clocks must be stable before enabling peripherals

### Step 9 — PLL & Clock Init
- **Register:** `CLK_ENABLE` at `0x0410`
- **Write value:** `0xFF`
- **Wait/Poll:** None
- **Rationale:** Enable all clock outputs to downstream peripherals

### Step 10 — Communication Init
- **Register:** `UART_BAUD_DIV` at `0x0100`
- **Write value:** `0x0034`
- **Wait/Poll:** None
- **Rationale:** Configure UART baud rate divisor for 115200 baud with 6MHz reference clock

### Step 11 — Communication Init
- **Register:** `UART_CTRL` at `0x0101`
- **Write value:** `0x01`
- **Wait/Poll:** None
- **Rationale:** Enable UART interface for command/control communication

### Step 12 — Temperature & Health Init
- **Register:** `TEMP_ALERT_HIGH` at `0x0308`
- **Write value:** `0x0190`
- **Wait/Poll:** None
- **Rationale:** Set over-temperature alert threshold to 100°C

### Step 13 — Temperature & Health Init
- **Register:** `TEMP_ALERT_LOW` at `0x0309`
- **Write value:** `0xFF9C`
- **Wait/Poll:** None
- **Rationale:** Set under-temperature alert threshold to -25°C

### Step 14 — Temperature & Health Init
- **Register:** `TEMP_LOCAL` at `0x0300`
- **Write value:** `0x0000`
- **Wait/Poll:** Verify TEMP < 85°C at startup
- **Rationale:** Confirm safe starting temperature before enabling RF paths

### Step 15 — EEPROM Init
- **Register:** `EEPROM_ADDR` at `0x0501`
- **Write value:** `0x0000`
- **Wait/Poll:** None
- **Rationale:** Set EEPROM address to read calibration data from start of memory

### Step 16 — EEPROM Init
- **Register:** `EEPROM_CTRL` at `0x0500`
- **Write value:** `0x01`
- **Wait/Poll:** Poll BUSY bit until cleared
- **Rationale:** Initiate EEPROM read of calibration data

### Step 17 — EEPROM Init
- **Register:** `EEPROM_DATA` at `0x0502`
- **Write value:** `0x0000`
- **Wait/Poll:** Read calibration data and validate CRC
- **Rationale:** Retrieve factory calibration data for RF gain and bias settings

### Step 18 — Flash Init
- **Register:** `FLASH_ADDR_HIGH` at `0x0602`
- **Write value:** `0x00`
- **Wait/Poll:** None
- **Rationale:** Initialize flash address pointer for configuration verification

### Step 19 — Flash Init
- **Register:** `FLASH_ADDR_LOW` at `0x0601`
- **Write value:** `0x0000`
- **Wait/Poll:** None
- **Rationale:** Set low word of flash address

### Step 20 — Flash Init
- **Register:** `FLASH_CTRL` at `0x0600`
- **Write value:** `0x01`
- **Wait/Poll:** Poll BUSY until cleared, check READY=1
- **Rationale:** Verify flash interface is functional and ready for operations

### Step 21 — ABC Sequencer Init
- **Register:** `ABC_SEQUENCER_CTRL` at `0x0710`
- **Write value:** `0x02`
- **Wait/Poll:** Wait 10ms
- **Rationale:** Reset ABC sequencer state machine to known initial condition

### Step 22 — ABC Sequencer Init
- **Register:** `ABC_SEQUENCER_CTRL` at `0x0710`
- **Write value:** `0x04`
- **Wait/Poll:** None
- **Rationale:** Configure 10ms delay multiplier for bias ramp timing

### Step 23 — ABC Sequencer Init
- **Register:** `ABC_GATE_CTRL_CH1` at `0x0711`
- **Write value:** `0x1000`
- **Wait/Poll:** None
- **Rationale:** Set initial gate bias voltage for Channel 1 (DAC = mid-scale, disabled)

### Step 24 — ABC Sequencer Init
- **Register:** `ABC_GATE_CTRL_CH2` at `0x0712`
- **Write value:** `0x1000`
- **Wait/Poll:** None
- **Rationale:** Set initial gate bias voltage for Channel 2

### Step 25 — ABC Sequencer Init
- **Register:** `ABC_GATE_CTRL_CH3` at `0x0713`
- **Write value:** `0x1000`
- **Wait/Poll:** None
- **Rationale:** Set initial gate bias voltage for Channel 3

### Step 26 — ABC Sequencer Init
- **Register:** `ABC_GATE_CTRL_CH4` at `0x0714`
- **Write value:** `0x1000`
- **Wait/Poll:** None
- **Rationale:** Set initial gate bias voltage for Channel 4

### Step 27 — RF Path Init
- **Register:** `RF_GAIN_CTRL_CH1` at `0x0701`
- **Write value:** `0x0000`
- **Wait/Poll:** None
- **Rationale:** Initialize Channel 1 gain blocks to minimum setting before enable

### Step 28 — RF Path Init
- **Register:** `RF_GAIN_CTRL_CH2` at `0x0702`
- **Write value:** `0x0000`
- **Wait/Poll:** None
- **Rationale:** Initialize Channel 2 gain blocks to minimum setting

### Step 29 — RF Path Init
- **Register:** `RF_GAIN_CTRL_CH3` at `0x0703`
- **Write value:** `0x0000`
- **Wait/Poll:** None
- **Rationale:** Initialize Channel 3 gain blocks to minimum setting

### Step 30 — RF Path Init
- **Register:** `RF_GAIN_CTRL_CH4` at `0x0704`
- **Write value:** `0x0000`
- **Wait/Poll:** None
- **Rationale:** Initialize Channel 4 gain blocks to minimum setting

### Step 31 — Application Init
- **Register:** `ABC_SEQUENCER_CTRL` at `0x0710`
- **Write value:** `0x05`
- **Wait/Poll:** Poll ABC_STATUS[15] until ALL_BIAS_OK=1
- **Rationale:** Enable ABC sequencer with auto-ramp and wait for all gate biases to stabilize

### Step 32 — Application Init
- **Register:** `RF_PATH_CTRL` at `0x0700`
- **Write value:** `0x000F`
- **Wait/Poll:** None
- **Rationale:** Enable all 4 RF signal paths after biases are stable - system now operational

### Step 33 — Application Init
- **Register:** `ADC_CTRL` at `0x0200`
- **Write value:** `0x03`
- **Wait/Poll:** None
- **Rationale:** Enable continuous ADC monitoring of all supply rails

### Step 34 — Application Init
- **Register:** `HEALTH_STATUS` at `0x030F`
- **Write value:** `0x0000`
- **Wait/Poll:** Verify SYSTEM_OK=1
- **Rationale:** Final health check - confirm all subsystems report healthy status
