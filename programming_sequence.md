# Programming Sequence (PSQ)
## receiver

> **Total steps:** 20

| # | Phase | Register | Address | Value | Condition | Rationale |
|---|-------|----------|---------|-------|-----------|-----------|
| 1 | Power-On Reset & Self-Check | `SCRATCHPAD` | `0x0003` | `0x55AA` | Read back 0x55AA within 10ms | RAM integrity check - write known pattern and verify readback to confirm UART/mem interface functional |
| 2 | Power-On Reset & Self-Check | `BOARD_ID` | `0x0000` | `READ` | Value == 0x5245 (expected 'RE') | Verify correct FPGA image loaded and hardware identification matches receiver board type |
| 3 | Power-On Reset & Self-Check | `HEALTH_STATUS` | `0x030F` | `READ` | VOLT_OK=1, poll up to 100ms | Wait for all power supply rails to stabilize within tolerance before proceeding with initialization |
| 4 | Power-On Reset & Self-Check | `SCRATCHPAD` | `0x0003` | `0x0000` | Read back 0x0000 | Clear test pattern and verify register resets correctly, completing basic self-check sequence |
| 5 | PLL & Clock Init | `PLL_CTRL` | `0x0400` | `0x02` | Wait 1us after write | Assert PLL reset to ensure clean startup - set RESET=1, ENABLE=0 |
| 6 | PLL & Clock Init | `PLL_N_DIV` | `0x0402` | `0x0032` | None | Configure N=50 divider for 500MHz VCO (10MHz reference x 50) |
| 7 | PLL & Clock Init | `PLL_R_DIV` | `0x0403` | `0x0001` | None | Configure R=1 reference divider for direct 10MHz input |
| 8 | PLL & Clock Init | `PLL_CTRL` | `0x0400` | `0x01` | Poll PLL_STATUS[0]=1 up to 50ms | Enable PLL and wait for LOCKED indication before using generated clocks |
| 9 | PLL & Clock Init | `CLK_ENABLE` | `0x0410` | `0x3F` | None | Enable all clock outputs (ADC, DSP, IF, RF, AUX, REF) to power up receiver subsystems |
| 10 | Communication Init | `UART_BAUD_DIV` | `0x0100` | `0x0068` | None | Configure UART for 115200 baud (100MHz / (16 * 104) = 115200 baud) |
| 11 | Communication Init | `UART_CTRL` | `0x0101` | `0x03` | None | Enable UART with standard 8N1 frame format (ENABLE=1, FRAME_FORMAT=0x3) |
| 12 | Peripheral Enable | `ADC_CTRL` | `0x0200` | `0x11` | None | Enable ADC auto-scan mode for continuous supply monitoring (CONTINUOUS=1, AUTO_SCAN_EN=1) |
| 13 | Application Init | `TEMP_ALERT_HIGH` | `0x0308` | `0x0190` | None | Set over-temperature alert threshold to 100°C (400 * 0.25°C) for thermal protection |
| 14 | Application Init | `TEMP_ALERT_LOW` | `0x0309` | `0xFF9C` | None | Set under-temperature alert threshold to -25°C (-100 * 0.25°C) for cold-start protection |
| 15 | Application Init | `EEPROM_CTRL` | `0x0500` | `0x08` | Poll BUSY=0 | Write unlock sequence (UNLOCK=0x8) to enable EEPROM access for calibration data read |
| 16 | Application Init | `RX_CTRL` | `0x0A00` | `0x0F` | Wait 5ms for LNA/Mixer startup | Enable receiver front-end (RX_ENABLE, LNA, MIXER) with medium gain mode for signal acquisition |
| 17 | Application Init | `RX_GAIN` | `0x0A02` | `0x8080` | None | Set RF and IF gain to mid-scale (128) for initial signal detection |
| 18 | Application Init | `RX_STATUS` | `0x0A01` | `READ` | Check AGC_LOCKED=1, FREQ_LOCKED=1 | Verify receiver has stabilized - AGC converged and frequency synthesizer locked before normal operation |
| 19 | Configuration Load | `FLASH_CTRL` | `0x0600` | `0x01` | Poll READY=1 | Ensure flash interface is ready and read-enabled for configuration data access |
| 20 | GPIO Init | `GPIO_DIR` | `0x0800` | `0x000F` | None | Configure GPIO[3:0] as outputs (LEDs, enable signals) and GPIO[15:4] as inputs |

---

## Detailed Steps

### Step 1 — Power-On Reset & Self-Check
- **Register:** `SCRATCHPAD` at `0x0003`
- **Write value:** `0x55AA`
- **Wait/Poll:** Read back 0x55AA within 10ms
- **Rationale:** RAM integrity check - write known pattern and verify readback to confirm UART/mem interface functional

### Step 2 — Power-On Reset & Self-Check
- **Register:** `BOARD_ID` at `0x0000`
- **Write value:** `READ`
- **Wait/Poll:** Value == 0x5245 (expected 'RE')
- **Rationale:** Verify correct FPGA image loaded and hardware identification matches receiver board type

### Step 3 — Power-On Reset & Self-Check
- **Register:** `HEALTH_STATUS` at `0x030F`
- **Write value:** `READ`
- **Wait/Poll:** VOLT_OK=1, poll up to 100ms
- **Rationale:** Wait for all power supply rails to stabilize within tolerance before proceeding with initialization

### Step 4 — Power-On Reset & Self-Check
- **Register:** `SCRATCHPAD` at `0x0003`
- **Write value:** `0x0000`
- **Wait/Poll:** Read back 0x0000
- **Rationale:** Clear test pattern and verify register resets correctly, completing basic self-check sequence

### Step 5 — PLL & Clock Init
- **Register:** `PLL_CTRL` at `0x0400`
- **Write value:** `0x02`
- **Wait/Poll:** Wait 1us after write
- **Rationale:** Assert PLL reset to ensure clean startup - set RESET=1, ENABLE=0

### Step 6 — PLL & Clock Init
- **Register:** `PLL_N_DIV` at `0x0402`
- **Write value:** `0x0032`
- **Wait/Poll:** None
- **Rationale:** Configure N=50 divider for 500MHz VCO (10MHz reference x 50)

### Step 7 — PLL & Clock Init
- **Register:** `PLL_R_DIV` at `0x0403`
- **Write value:** `0x0001`
- **Wait/Poll:** None
- **Rationale:** Configure R=1 reference divider for direct 10MHz input

### Step 8 — PLL & Clock Init
- **Register:** `PLL_CTRL` at `0x0400`
- **Write value:** `0x01`
- **Wait/Poll:** Poll PLL_STATUS[0]=1 up to 50ms
- **Rationale:** Enable PLL and wait for LOCKED indication before using generated clocks

### Step 9 — PLL & Clock Init
- **Register:** `CLK_ENABLE` at `0x0410`
- **Write value:** `0x3F`
- **Wait/Poll:** None
- **Rationale:** Enable all clock outputs (ADC, DSP, IF, RF, AUX, REF) to power up receiver subsystems

### Step 10 — Communication Init
- **Register:** `UART_BAUD_DIV` at `0x0100`
- **Write value:** `0x0068`
- **Wait/Poll:** None
- **Rationale:** Configure UART for 115200 baud (100MHz / (16 * 104) = 115200 baud)

### Step 11 — Communication Init
- **Register:** `UART_CTRL` at `0x0101`
- **Write value:** `0x03`
- **Wait/Poll:** None
- **Rationale:** Enable UART with standard 8N1 frame format (ENABLE=1, FRAME_FORMAT=0x3)

### Step 12 — Peripheral Enable
- **Register:** `ADC_CTRL` at `0x0200`
- **Write value:** `0x11`
- **Wait/Poll:** None
- **Rationale:** Enable ADC auto-scan mode for continuous supply monitoring (CONTINUOUS=1, AUTO_SCAN_EN=1)

### Step 13 — Application Init
- **Register:** `TEMP_ALERT_HIGH` at `0x0308`
- **Write value:** `0x0190`
- **Wait/Poll:** None
- **Rationale:** Set over-temperature alert threshold to 100°C (400 * 0.25°C) for thermal protection

### Step 14 — Application Init
- **Register:** `TEMP_ALERT_LOW` at `0x0309`
- **Write value:** `0xFF9C`
- **Wait/Poll:** None
- **Rationale:** Set under-temperature alert threshold to -25°C (-100 * 0.25°C) for cold-start protection

### Step 15 — Application Init
- **Register:** `EEPROM_CTRL` at `0x0500`
- **Write value:** `0x08`
- **Wait/Poll:** Poll BUSY=0
- **Rationale:** Write unlock sequence (UNLOCK=0x8) to enable EEPROM access for calibration data read

### Step 16 — Application Init
- **Register:** `RX_CTRL` at `0x0A00`
- **Write value:** `0x0F`
- **Wait/Poll:** Wait 5ms for LNA/Mixer startup
- **Rationale:** Enable receiver front-end (RX_ENABLE, LNA, MIXER) with medium gain mode for signal acquisition

### Step 17 — Application Init
- **Register:** `RX_GAIN` at `0x0A02`
- **Write value:** `0x8080`
- **Wait/Poll:** None
- **Rationale:** Set RF and IF gain to mid-scale (128) for initial signal detection

### Step 18 — Application Init
- **Register:** `RX_STATUS` at `0x0A01`
- **Write value:** `READ`
- **Wait/Poll:** Check AGC_LOCKED=1, FREQ_LOCKED=1
- **Rationale:** Verify receiver has stabilized - AGC converged and frequency synthesizer locked before normal operation

### Step 19 — Configuration Load
- **Register:** `FLASH_CTRL` at `0x0600`
- **Write value:** `0x01`
- **Wait/Poll:** Poll READY=1
- **Rationale:** Ensure flash interface is ready and read-enabled for configuration data access

### Step 20 — GPIO Init
- **Register:** `GPIO_DIR` at `0x0800`
- **Write value:** `0x000F`
- **Wait/Poll:** None
- **Rationale:** Configure GPIO[3:0] as outputs (LEDs, enable signals) and GPIO[15:4] as inputs
