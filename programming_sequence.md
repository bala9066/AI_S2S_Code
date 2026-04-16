# Programming Sequence (PSQ)
## mn

> **Total steps:** 20

| # | Phase | Register | Address | Value | Condition | Rationale |
|---|-------|----------|---------|-------|-----------|-----------|
| 1 | Power-On Reset & Self-Check | `SCRATCHPAD` | `0x0003` | `0xA5A5` | Read back and verify =0xA5A5 | RAM integrity check - write pattern to scratchpad and verify read-back |
| 2 | Power-On Reset & Self-Check | `SCRATCHPAD` | `0x0003` | `0x5A5A` | Read back and verify =0x5A5A | RAM integrity check - inverted pattern to catch stuck-at faults |
| 3 | Power-On Reset & Self-Check | `BOARD_ID` | `0x0000` | `READ` | Verify =0x4D4E ('MN') | Verify correct FPGA bitstream is loaded and responding |
| 4 | Power-On Reset & Self-Check | `HEALTH_STATUS` | `0x030F` | `READ` | Poll until bit[1]=VOLT_OK=1 | Wait for power rails to stabilize before proceeding with init |
| 5 | PLL & Clock Init | `PLL_CTRL` | `0x0400` | `0x02` | Wait 10us | Assert PLL reset to ensure clean startup state |
| 6 | PLL & Clock Init | `PLL_N_DIV` | `0x0402` | `0x0020` | None | Configure PLL feedback divider (N=32 for desired output freq) |
| 7 | PLL & Clock Init | `PLL_R_DIV` | `0x0403` | `0x0001` | None | Configure PLL reference divider (R=1) before enabling |
| 8 | PLL & Clock Init | `PLL_CTRL` | `0x0400` | `0x01` | Poll PLL_STATUS bit[0]=LOCKED=1 | Enable PLL and wait for lock indication before enabling clocks |
| 9 | PLL & Clock Init | `CLK_ENABLE` | `0x0410` | `0xFF` | None | Enable all clock outputs to peripherals after PLL locked |
| 10 | Peripheral Enable | `ADC_CTRL` | `0x0200` | `0x03` | None | Enable ADC in continuous mode for supply monitoring |
| 11 | Communication Init | `UART_BAUD_DIV` | `0x0100` | `0x0034` | None | Set UART baud rate to 115200 (50MHz / (16 * 52)) |
| 12 | Communication Init | `UART_CTRL` | `0x0101` | `0x01` | None | Enable UART transmitter and receiver for host communication |
| 13 | Application Init | `TEMP_ALERT_HIGH` | `0x0308` | `0x0190` | None | Arm over-temperature alert at 100°C threshold |
| 14 | Application Init | `TEMP_ALERT_LOW` | `0x0309` | `0xFF9C` | None | Arm under-temperature alert at -25°C threshold (signed value) |
| 15 | Application Init | `EEPROM_ADDR` | `0x0501` | `0x0000` | None | Set EEPROM address to read calibration data from start |
| 16 | Application Init | `EEPROM_CTRL` | `0x0500` | `0x01` | Poll EEPROM_CTRL bit[7]=BUSY=0, then read EEPROM_DATA | Trigger EEPROM read of factory calibration data |
| 17 | Application Init | `RF_LNA_CTRL` | `0x0700` | `0x01` | None | Enable HMC698LP4 LNA for RF path (exit standby) |
| 18 | Application Init | `RF_MIXER_CTRL` | `0x0702` | `0x49` | None | Enable mixer and set LO/IF bias levels for 5-18GHz operation |
| 19 | Application Init | `RF_VGA_CTRL` | `0x0701` | `0x8000` | None | Set VGA to mid-scale gain for initial operation |
| 20 | Application Init | `DAC_CTRL` | `0x0908` | `0x0F` | None | Enable all DAC output channels for application use |

---

## Detailed Steps

### Step 1 — Power-On Reset & Self-Check
- **Register:** `SCRATCHPAD` at `0x0003`
- **Write value:** `0xA5A5`
- **Wait/Poll:** Read back and verify =0xA5A5
- **Rationale:** RAM integrity check - write pattern to scratchpad and verify read-back

### Step 2 — Power-On Reset & Self-Check
- **Register:** `SCRATCHPAD` at `0x0003`
- **Write value:** `0x5A5A`
- **Wait/Poll:** Read back and verify =0x5A5A
- **Rationale:** RAM integrity check - inverted pattern to catch stuck-at faults

### Step 3 — Power-On Reset & Self-Check
- **Register:** `BOARD_ID` at `0x0000`
- **Write value:** `READ`
- **Wait/Poll:** Verify =0x4D4E ('MN')
- **Rationale:** Verify correct FPGA bitstream is loaded and responding

### Step 4 — Power-On Reset & Self-Check
- **Register:** `HEALTH_STATUS` at `0x030F`
- **Write value:** `READ`
- **Wait/Poll:** Poll until bit[1]=VOLT_OK=1
- **Rationale:** Wait for power rails to stabilize before proceeding with init

### Step 5 — PLL & Clock Init
- **Register:** `PLL_CTRL` at `0x0400`
- **Write value:** `0x02`
- **Wait/Poll:** Wait 10us
- **Rationale:** Assert PLL reset to ensure clean startup state

### Step 6 — PLL & Clock Init
- **Register:** `PLL_N_DIV` at `0x0402`
- **Write value:** `0x0020`
- **Wait/Poll:** None
- **Rationale:** Configure PLL feedback divider (N=32 for desired output freq)

### Step 7 — PLL & Clock Init
- **Register:** `PLL_R_DIV` at `0x0403`
- **Write value:** `0x0001`
- **Wait/Poll:** None
- **Rationale:** Configure PLL reference divider (R=1) before enabling

### Step 8 — PLL & Clock Init
- **Register:** `PLL_CTRL` at `0x0400`
- **Write value:** `0x01`
- **Wait/Poll:** Poll PLL_STATUS bit[0]=LOCKED=1
- **Rationale:** Enable PLL and wait for lock indication before enabling clocks

### Step 9 — PLL & Clock Init
- **Register:** `CLK_ENABLE` at `0x0410`
- **Write value:** `0xFF`
- **Wait/Poll:** None
- **Rationale:** Enable all clock outputs to peripherals after PLL locked

### Step 10 — Peripheral Enable
- **Register:** `ADC_CTRL` at `0x0200`
- **Write value:** `0x03`
- **Wait/Poll:** None
- **Rationale:** Enable ADC in continuous mode for supply monitoring

### Step 11 — Communication Init
- **Register:** `UART_BAUD_DIV` at `0x0100`
- **Write value:** `0x0034`
- **Wait/Poll:** None
- **Rationale:** Set UART baud rate to 115200 (50MHz / (16 * 52))

### Step 12 — Communication Init
- **Register:** `UART_CTRL` at `0x0101`
- **Write value:** `0x01`
- **Wait/Poll:** None
- **Rationale:** Enable UART transmitter and receiver for host communication

### Step 13 — Application Init
- **Register:** `TEMP_ALERT_HIGH` at `0x0308`
- **Write value:** `0x0190`
- **Wait/Poll:** None
- **Rationale:** Arm over-temperature alert at 100°C threshold

### Step 14 — Application Init
- **Register:** `TEMP_ALERT_LOW` at `0x0309`
- **Write value:** `0xFF9C`
- **Wait/Poll:** None
- **Rationale:** Arm under-temperature alert at -25°C threshold (signed value)

### Step 15 — Application Init
- **Register:** `EEPROM_ADDR` at `0x0501`
- **Write value:** `0x0000`
- **Wait/Poll:** None
- **Rationale:** Set EEPROM address to read calibration data from start

### Step 16 — Application Init
- **Register:** `EEPROM_CTRL` at `0x0500`
- **Write value:** `0x01`
- **Wait/Poll:** Poll EEPROM_CTRL bit[7]=BUSY=0, then read EEPROM_DATA
- **Rationale:** Trigger EEPROM read of factory calibration data

### Step 17 — Application Init
- **Register:** `RF_LNA_CTRL` at `0x0700`
- **Write value:** `0x01`
- **Wait/Poll:** None
- **Rationale:** Enable HMC698LP4 LNA for RF path (exit standby)

### Step 18 — Application Init
- **Register:** `RF_MIXER_CTRL` at `0x0702`
- **Write value:** `0x49`
- **Wait/Poll:** None
- **Rationale:** Enable mixer and set LO/IF bias levels for 5-18GHz operation

### Step 19 — Application Init
- **Register:** `RF_VGA_CTRL` at `0x0701`
- **Write value:** `0x8000`
- **Wait/Poll:** None
- **Rationale:** Set VGA to mid-scale gain for initial operation

### Step 20 — Application Init
- **Register:** `DAC_CTRL` at `0x0908`
- **Write value:** `0x0F`
- **Wait/Poll:** None
- **Rationale:** Enable all DAC output channels for application use
