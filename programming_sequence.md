# Programming Sequence (PSQ)
## rf tx

> **Total steps:** 30

| # | Phase | Register | Address | Value | Condition | Rationale |
|---|-------|----------|---------|-------|-----------|-----------|
| 1 | Power-On Reset & Self-Check | `SCRATCHPAD` | `0x0003` | `0xA5A5` | Read back and verify 0xA5A5 | RAM integrity check - write known pattern and read back to verify memory interface is functional |
| 2 | Power-On Reset & Self-Check | `BOARD_ID` | `0x0000` | `READ` | Verify value equals 0x5246 ('RF') | Board identification verification - ensure correct FPGA firmware is loaded |
| 3 | Power-On Reset & Self-Check | `HEALTH_STATUS` | `0x030F` | `POLL` | Wait until VOLT_OK (bit1) = 1 (max 100ms) | Power rail stability check - ensure 5V and 3.3V supplies are stable before proceeding |
| 4 | Power-On Reset & Self-Check | `TEMP_LOCAL` | `0x0300` | `READ` | Verify temperature within valid range (-40C to +100C) | Initial temperature check - ensure FPGA die temperature is safe before PLL enable |
| 5 | PLL & Clock Init | `PLL_CTRL` | `0x0400` | `0x0002` | None | Assert PLL reset - ensure clean startup state |
| 6 | PLL & Clock Init | `PLL_N_DIV` | `0x0402` | `0x001E` | None | Configure PLL N divider = 30 (50MHz * 30 / R = 1.5GHz intermediate, then divide for 200MHz) |
| 7 | PLL & Clock Init | `PLL_R_DIV` | `0x0403` | `0x0001` | None | Configure PLL R divider = 1 for reference prescaler |
| 8 | PLL & Clock Init | `PLL_CTRL` | `0x0400` | `0x0001` | Wait until PLL_STATUS LOCKED (bit0) = 1 (max 10ms) | Enable PLL and wait for lock - critical for all clocked logic |
| 9 | PLL & Clock Init | `CLK_ENABLE` | `0x0410` | `0x0007` | None | Enable clock outputs: CLK_OUT0 (ADC sample clock), CLK_OUT1 (JESD204B lane), CLK_OUT2 (sys_clk) |
| 10 | Peripheral Enable | `TEMP_ALERT_HIGH` | `0x0308` | `0x0190` | None | Arm over-temperature alert at 100°C (0x0190 * 0.25 = 100°C) |
| 11 | Peripheral Enable | `TEMP_ALERT_LOW` | `0x0309` | `0xFF9C` | None | Arm under-temperature alert at -25°C (0xFF9C * 0.25 = -25°C, signed) |
| 12 | Communication Init | `UART_CTRL` | `0x0101` | `0x00` | None | Disable UART during configuration |
| 13 | Communication Init | `UART_BAUD_DIV` | `0x0100` | `0x0068` | None | Configure UART baud rate divisor for 115200 bps (16MHz / (16 * 104) = 9615, actual divisor adjusted) |
| 14 | Communication Init | `UART_CTRL` | `0x0101` | `0x01` | None | Enable UART for communication with host MCU |
| 15 | Application Init | `EEPROM_ADDR` | `0x0501` | `0x0000` | None | Set EEPROM address to 0x0000 for calibration data read |
| 16 | Application Init | `EEPROM_CTRL` | `0x0500` | `0x01` | Wait until BUSY (bit7) = 0 (max 10ms) | Trigger EEPROM read of calibration data |
| 17 | Application Init | `EEPROM_DATA` | `0x0502` | `READ` | Store calibration data in local MCU memory | Read calibration data (gain offsets, frequency corrections) from EEPROM |
| 18 | Application Init | `VGA_GAIN_COARSE` | `0x0122` | `0x1F` | None | Set VGA (HMC698LP4) coarse gain to mid-range (15 of 31) |
| 19 | Application Init | `VGA_GAIN_FINE` | `0x0123` | `0x3F` | None | Set VGA (HMC698LP4) fine gain to mid-range (31 of 63) |
| 20 | Application Init | `VGA_SPI_CTRL` | `0x0120` | `0x05` | Pulse LE bit, then wait 1us, then clear | Latch VGA gain settings to HMC698LP4 via SPI (CS_N=0, RW=1, LE pulse) |
| 21 | Application Init | `LO_FREQ_CTRL` | `0x0708` | `0x00C80000` | None | Set LO (HMC830LP6GE) to 7.4 GHz (default for 5 GHz RF input + 2.4 GHz IF) |
| 22 | Application Init | `LO_SPI_CTRL` | `0x0130` | `0x01` | Write LO frequency registers via SPI, then wait for lock | Configure HMC830LP6GE synthesizer via SPI (CS_N=0, RW=1) |
| 23 | Application Init | `LO_STATUS` | `0x0709` | `POLL` | Wait until LOCKED (bit0) = 1 (max 50ms) | Verify LO synthesizer phase lock before enabling RF chain |
| 24 | Application Init | `RF_PATH_CTRL` | `0x0700` | `0x07` | None | Enable RF chain: LNA (bit0), Mixer (bit1), VGA (bit2) |
| 25 | Application Init | `ADC_CTRL` | `0x0200` | `0x03` | None | Start ADC12J4000 in continuous mode via JESD204B link (START=1, CONTINUOUS=1) |
| 26 | Application Init | `ADC_STATUS` | `0x0201` | `POLL` | Wait until JESD_LINK (bit2) = 1 (max 100ms) | Verify JESD204B link is established before enabling DSP |
| 27 | Application Init | `DSP_CTRL` | `0x0A00` | `0x07` | None | Enable DSP engines: FFT (bit0), filter (bit1), CW detection (bit2) |
| 28 | Application Init | `CW_DET_THRESHOLD` | `0x0A08` | `0x0800` | None | Set CW detection amplitude threshold to mid-scale (2048 of 4095) |
| 29 | Application Init | `INTERRUPT_EN` | `0x0B00` | `0x3F` | None | Enable all interrupts: temp, voltage, PLL loss, JESD error, CW detect, DSP done |
| 30 | Application Init | `HEALTH_STATUS` | `0x030F` | `POLL` | Verify SYSTEM_OK (bit7) = 1 | Final system health check - ensure all subsystems report OK before entering normal operation |

---

## Detailed Steps

### Step 1 — Power-On Reset & Self-Check
- **Register:** `SCRATCHPAD` at `0x0003`
- **Write value:** `0xA5A5`
- **Wait/Poll:** Read back and verify 0xA5A5
- **Rationale:** RAM integrity check - write known pattern and read back to verify memory interface is functional

### Step 2 — Power-On Reset & Self-Check
- **Register:** `BOARD_ID` at `0x0000`
- **Write value:** `READ`
- **Wait/Poll:** Verify value equals 0x5246 ('RF')
- **Rationale:** Board identification verification - ensure correct FPGA firmware is loaded

### Step 3 — Power-On Reset & Self-Check
- **Register:** `HEALTH_STATUS` at `0x030F`
- **Write value:** `POLL`
- **Wait/Poll:** Wait until VOLT_OK (bit1) = 1 (max 100ms)
- **Rationale:** Power rail stability check - ensure 5V and 3.3V supplies are stable before proceeding

### Step 4 — Power-On Reset & Self-Check
- **Register:** `TEMP_LOCAL` at `0x0300`
- **Write value:** `READ`
- **Wait/Poll:** Verify temperature within valid range (-40C to +100C)
- **Rationale:** Initial temperature check - ensure FPGA die temperature is safe before PLL enable

### Step 5 — PLL & Clock Init
- **Register:** `PLL_CTRL` at `0x0400`
- **Write value:** `0x0002`
- **Wait/Poll:** None
- **Rationale:** Assert PLL reset - ensure clean startup state

### Step 6 — PLL & Clock Init
- **Register:** `PLL_N_DIV` at `0x0402`
- **Write value:** `0x001E`
- **Wait/Poll:** None
- **Rationale:** Configure PLL N divider = 30 (50MHz * 30 / R = 1.5GHz intermediate, then divide for 200MHz)

### Step 7 — PLL & Clock Init
- **Register:** `PLL_R_DIV` at `0x0403`
- **Write value:** `0x0001`
- **Wait/Poll:** None
- **Rationale:** Configure PLL R divider = 1 for reference prescaler

### Step 8 — PLL & Clock Init
- **Register:** `PLL_CTRL` at `0x0400`
- **Write value:** `0x0001`
- **Wait/Poll:** Wait until PLL_STATUS LOCKED (bit0) = 1 (max 10ms)
- **Rationale:** Enable PLL and wait for lock - critical for all clocked logic

### Step 9 — PLL & Clock Init
- **Register:** `CLK_ENABLE` at `0x0410`
- **Write value:** `0x0007`
- **Wait/Poll:** None
- **Rationale:** Enable clock outputs: CLK_OUT0 (ADC sample clock), CLK_OUT1 (JESD204B lane), CLK_OUT2 (sys_clk)

### Step 10 — Peripheral Enable
- **Register:** `TEMP_ALERT_HIGH` at `0x0308`
- **Write value:** `0x0190`
- **Wait/Poll:** None
- **Rationale:** Arm over-temperature alert at 100°C (0x0190 * 0.25 = 100°C)

### Step 11 — Peripheral Enable
- **Register:** `TEMP_ALERT_LOW` at `0x0309`
- **Write value:** `0xFF9C`
- **Wait/Poll:** None
- **Rationale:** Arm under-temperature alert at -25°C (0xFF9C * 0.25 = -25°C, signed)

### Step 12 — Communication Init
- **Register:** `UART_CTRL` at `0x0101`
- **Write value:** `0x00`
- **Wait/Poll:** None
- **Rationale:** Disable UART during configuration

### Step 13 — Communication Init
- **Register:** `UART_BAUD_DIV` at `0x0100`
- **Write value:** `0x0068`
- **Wait/Poll:** None
- **Rationale:** Configure UART baud rate divisor for 115200 bps (16MHz / (16 * 104) = 9615, actual divisor adjusted)

### Step 14 — Communication Init
- **Register:** `UART_CTRL` at `0x0101`
- **Write value:** `0x01`
- **Wait/Poll:** None
- **Rationale:** Enable UART for communication with host MCU

### Step 15 — Application Init
- **Register:** `EEPROM_ADDR` at `0x0501`
- **Write value:** `0x0000`
- **Wait/Poll:** None
- **Rationale:** Set EEPROM address to 0x0000 for calibration data read

### Step 16 — Application Init
- **Register:** `EEPROM_CTRL` at `0x0500`
- **Write value:** `0x01`
- **Wait/Poll:** Wait until BUSY (bit7) = 0 (max 10ms)
- **Rationale:** Trigger EEPROM read of calibration data

### Step 17 — Application Init
- **Register:** `EEPROM_DATA` at `0x0502`
- **Write value:** `READ`
- **Wait/Poll:** Store calibration data in local MCU memory
- **Rationale:** Read calibration data (gain offsets, frequency corrections) from EEPROM

### Step 18 — Application Init
- **Register:** `VGA_GAIN_COARSE` at `0x0122`
- **Write value:** `0x1F`
- **Wait/Poll:** None
- **Rationale:** Set VGA (HMC698LP4) coarse gain to mid-range (15 of 31)

### Step 19 — Application Init
- **Register:** `VGA_GAIN_FINE` at `0x0123`
- **Write value:** `0x3F`
- **Wait/Poll:** None
- **Rationale:** Set VGA (HMC698LP4) fine gain to mid-range (31 of 63)

### Step 20 — Application Init
- **Register:** `VGA_SPI_CTRL` at `0x0120`
- **Write value:** `0x05`
- **Wait/Poll:** Pulse LE bit, then wait 1us, then clear
- **Rationale:** Latch VGA gain settings to HMC698LP4 via SPI (CS_N=0, RW=1, LE pulse)

### Step 21 — Application Init
- **Register:** `LO_FREQ_CTRL` at `0x0708`
- **Write value:** `0x00C80000`
- **Wait/Poll:** None
- **Rationale:** Set LO (HMC830LP6GE) to 7.4 GHz (default for 5 GHz RF input + 2.4 GHz IF)

### Step 22 — Application Init
- **Register:** `LO_SPI_CTRL` at `0x0130`
- **Write value:** `0x01`
- **Wait/Poll:** Write LO frequency registers via SPI, then wait for lock
- **Rationale:** Configure HMC830LP6GE synthesizer via SPI (CS_N=0, RW=1)

### Step 23 — Application Init
- **Register:** `LO_STATUS` at `0x0709`
- **Write value:** `POLL`
- **Wait/Poll:** Wait until LOCKED (bit0) = 1 (max 50ms)
- **Rationale:** Verify LO synthesizer phase lock before enabling RF chain

### Step 24 — Application Init
- **Register:** `RF_PATH_CTRL` at `0x0700`
- **Write value:** `0x07`
- **Wait/Poll:** None
- **Rationale:** Enable RF chain: LNA (bit0), Mixer (bit1), VGA (bit2)

### Step 25 — Application Init
- **Register:** `ADC_CTRL` at `0x0200`
- **Write value:** `0x03`
- **Wait/Poll:** None
- **Rationale:** Start ADC12J4000 in continuous mode via JESD204B link (START=1, CONTINUOUS=1)

### Step 26 — Application Init
- **Register:** `ADC_STATUS` at `0x0201`
- **Write value:** `POLL`
- **Wait/Poll:** Wait until JESD_LINK (bit2) = 1 (max 100ms)
- **Rationale:** Verify JESD204B link is established before enabling DSP

### Step 27 — Application Init
- **Register:** `DSP_CTRL` at `0x0A00`
- **Write value:** `0x07`
- **Wait/Poll:** None
- **Rationale:** Enable DSP engines: FFT (bit0), filter (bit1), CW detection (bit2)

### Step 28 — Application Init
- **Register:** `CW_DET_THRESHOLD` at `0x0A08`
- **Write value:** `0x0800`
- **Wait/Poll:** None
- **Rationale:** Set CW detection amplitude threshold to mid-scale (2048 of 4095)

### Step 29 — Application Init
- **Register:** `INTERRUPT_EN` at `0x0B00`
- **Write value:** `0x3F`
- **Wait/Poll:** None
- **Rationale:** Enable all interrupts: temp, voltage, PLL loss, JESD error, CW detect, DSP done

### Step 30 — Application Init
- **Register:** `HEALTH_STATUS` at `0x030F`
- **Write value:** `POLL`
- **Wait/Poll:** Verify SYSTEM_OK (bit7) = 1
- **Rationale:** Final system health check - ensure all subsystems report OK before entering normal operation
