# Programming Sequence (PSQ)
## sample rf

> **Total steps:** 31

| # | Phase | Register | Address | Value | Condition | Rationale |
|---|-------|----------|---------|-------|-----------|-----------|
| 1 | Power-On Reset & Self-Check | `SCRATCHPAD` | `0x0003` | `0xA5A5` | Read back and verify = 0xA5A5 | RAM integrity check - verify register read/write functionality |
| 2 | Power-On Reset & Self-Check | `BOARD_ID` | `0x0000` | `0x0000` | Verify BOARD_ID == 0x5346 ('SF') | Confirm correct FPGA image loaded for sample_rf board |
| 3 | Power-On Reset & Self-Check | `HEALTH_STATUS` | `0x030F` | `0x0000` | Poll until VOLT_OK (bit1) = 1 | Wait for power supplies to stabilize - 5V, 3.3V, 1.8V rails must be within tolerance |
| 4 | Power-On Reset & Self-Check | `TEMP_LOCAL` | `0x0300` | `0x0000` | Read temperature, verify within -40 to +85°C range | Confirm die temperature within industrial operating range before enabling RF chain |
| 5 | PLL & Clock Init | `PLL_CTRL` | `0x0400` | `0x02` | Wait 100us | Assert Si5345 PLL reset - ensure clean startup |
| 6 | PLL & Clock Init | `PLL_N_DIV` | `0x0402` | `0x001E` | None | Configure Si5345 N-divider for desired output frequency (value depends on reference) |
| 7 | PLL & Clock Init | `PLL_R_DIV` | `0x0403` | `0x000A` | None | Configure Si5345 R-divider to match reference clock frequency |
| 8 | PLL & Clock Init | `PLL_CTRL` | `0x0400` | `0x01` | None | Enable Si5345 PLL with internal reference selected |
| 9 | PLL & Clock Init | `PLL_STATUS` | `0x0401` | `0x0000` | Poll until LOCKED (bit0) = 1, timeout 500ms | Wait for Si5345 PLL to achieve lock - critical for ADC clock quality |
| 10 | PLL & Clock Init | `CLK_ENABLE` | `0x0410` | `0x03` | None | Enable ADC clock (CLK0) and FPGA system clock (CLK1) outputs from Si5345 |
| 11 | Peripheral Enable | `TEMP_ALERT_HIGH` | `0x0308` | `0x0258` | None | Set over-temperature alert threshold to 100°C (0x258 * 0.25 = 90°C, adjusted for margin) |
| 12 | Peripheral Enable | `TEMP_ALERT_LOW` | `0x0309` | `0xFF9C` | None | Set under-temperature alert threshold to -25°C (signed 0xFF9C * 0.25) |
| 13 | Peripheral Enable | `INTERRUPT_EN` | `0x0B00` | `0x1F` | None | Enable all system interrupts (temp, voltage, ADC, PLL, HSTC error alerts) |
| 14 | Communication Init | `UART_BAUD_DIV` | `0x0100` | `0x0034` | None | Set UART baud rate divisor for 115200 baud at 100MHz system clock (100MHz / (16 * 115200) ≈ 54 = 0x36) |
| 15 | Communication Init | `UART_CTRL` | `0x0101` | `0x01` | None | Enable UART with 8N1 frame format for host communication |
| 16 | ADC Init | `ADC_CTRL` | `0x0200` | `0x10` | Wait 50ms | Exit ADC power-down mode, allow time for internal bias stabilization |
| 17 | ADC Init | `ADC_CTRL` | `0x0200` | `0x13` | None | Enable ADC, continuous mode, DDC enabled, both I and Q channels active |
| 18 | ADC Init | `ADC_STATUS` | `0x0201` | `0x0000` | Poll until CAL_COMPLETE (bit2) = 1 | Wait for ADC12J4000 internal calibration to complete |
| 19 | RF Chain Init | `RF_LO_CTRL` | `0x0702` | `0x01` | None | Enable HMC364 LO buffer amplifier to condition LO input signal |
| 20 | RF Chain Init | `RF_LNA_CTRL` | `0x0700` | `0x01` | None | Enable HMC698 LNA with low gain setting - apply RF input signal after this step |
| 21 | RF Chain Init | `RF_MIXER_CTRL` | `0x0701` | `0x01` | None | Enable HMC1119 mixer with default IF gain - I/Q outputs now active |
| 22 | Application Init | `DATA_FORMAT_CTRL` | `0x0902` | `0x04` | None | Set 12-bit word size, 2's complement format, MSB-first for ADC12J4000 IQ data |
| 23 | Application Init | `SAMPLE_RATE_CTRL` | `0x0903` | `0x0004` | None | Set decimation factor to 4 for effective 1 GSPS output rate (4 GSPS / 4 = 1 GSPS) |
| 24 | Application Init | `HSTC_CTRL` | `0x0900` | `0x09` | None | Enable HSTC link with 4-lane mode and on-board termination enabled |
| 25 | Application Init | `HSTC_STATUS` | `0x0901` | `0x0000` | Poll until LINK_UP (bit0) = 1, all LANE_SYNC bits = 1 | Verify HSTC high-speed data link established before streaming IQ data |
| 26 | Application Init | `CALIBRATION_CTRL` | `0x0A00` | `0x07` | Poll until CAL_BUSY (bit7) = 0 | Run RF calibration sequence including DC offset and IQ imbalance correction |
| 27 | Application Init | `LED_CTRL` | `0x0802` | `0x0B` | None | Enable Power, Activity, and RF LEDs to indicate system fully operational |
| 28 | Final Verification | `HEALTH_STATUS` | `0x030F` | `0x0000` | Verify SYSTEM_OK (bit7) = 1, all OK bits = 1 | Final health check - confirm temperature, voltage, PLL lock, ADC ready all good |
| 29 | NV Config Load | `EEPROM_ADDR` | `0x0501` | `0x0000` | None | Set EEPROM start address for calibration data read |
| 30 | NV Config Load | `EEPROM_CTRL` | `0x0500` | `0x01` | Poll until BUSY (bit7) = 0 | Read factory calibration data from EEPROM - contains RF gain correction coefficients |
| 31 | NV Config Load | `EEPROM_DATA` | `0x0502` | `0x0000` | Read and apply calibration values | Retrieve calibration constants and apply to RF gain/phase correction registers |

---

## Detailed Steps

### Step 1 — Power-On Reset & Self-Check
- **Register:** `SCRATCHPAD` at `0x0003`
- **Write value:** `0xA5A5`
- **Wait/Poll:** Read back and verify = 0xA5A5
- **Rationale:** RAM integrity check - verify register read/write functionality

### Step 2 — Power-On Reset & Self-Check
- **Register:** `BOARD_ID` at `0x0000`
- **Write value:** `0x0000`
- **Wait/Poll:** Verify BOARD_ID == 0x5346 ('SF')
- **Rationale:** Confirm correct FPGA image loaded for sample_rf board

### Step 3 — Power-On Reset & Self-Check
- **Register:** `HEALTH_STATUS` at `0x030F`
- **Write value:** `0x0000`
- **Wait/Poll:** Poll until VOLT_OK (bit1) = 1
- **Rationale:** Wait for power supplies to stabilize - 5V, 3.3V, 1.8V rails must be within tolerance

### Step 4 — Power-On Reset & Self-Check
- **Register:** `TEMP_LOCAL` at `0x0300`
- **Write value:** `0x0000`
- **Wait/Poll:** Read temperature, verify within -40 to +85°C range
- **Rationale:** Confirm die temperature within industrial operating range before enabling RF chain

### Step 5 — PLL & Clock Init
- **Register:** `PLL_CTRL` at `0x0400`
- **Write value:** `0x02`
- **Wait/Poll:** Wait 100us
- **Rationale:** Assert Si5345 PLL reset - ensure clean startup

### Step 6 — PLL & Clock Init
- **Register:** `PLL_N_DIV` at `0x0402`
- **Write value:** `0x001E`
- **Wait/Poll:** None
- **Rationale:** Configure Si5345 N-divider for desired output frequency (value depends on reference)

### Step 7 — PLL & Clock Init
- **Register:** `PLL_R_DIV` at `0x0403`
- **Write value:** `0x000A`
- **Wait/Poll:** None
- **Rationale:** Configure Si5345 R-divider to match reference clock frequency

### Step 8 — PLL & Clock Init
- **Register:** `PLL_CTRL` at `0x0400`
- **Write value:** `0x01`
- **Wait/Poll:** None
- **Rationale:** Enable Si5345 PLL with internal reference selected

### Step 9 — PLL & Clock Init
- **Register:** `PLL_STATUS` at `0x0401`
- **Write value:** `0x0000`
- **Wait/Poll:** Poll until LOCKED (bit0) = 1, timeout 500ms
- **Rationale:** Wait for Si5345 PLL to achieve lock - critical for ADC clock quality

### Step 10 — PLL & Clock Init
- **Register:** `CLK_ENABLE` at `0x0410`
- **Write value:** `0x03`
- **Wait/Poll:** None
- **Rationale:** Enable ADC clock (CLK0) and FPGA system clock (CLK1) outputs from Si5345

### Step 11 — Peripheral Enable
- **Register:** `TEMP_ALERT_HIGH` at `0x0308`
- **Write value:** `0x0258`
- **Wait/Poll:** None
- **Rationale:** Set over-temperature alert threshold to 100°C (0x258 * 0.25 = 90°C, adjusted for margin)

### Step 12 — Peripheral Enable
- **Register:** `TEMP_ALERT_LOW` at `0x0309`
- **Write value:** `0xFF9C`
- **Wait/Poll:** None
- **Rationale:** Set under-temperature alert threshold to -25°C (signed 0xFF9C * 0.25)

### Step 13 — Peripheral Enable
- **Register:** `INTERRUPT_EN` at `0x0B00`
- **Write value:** `0x1F`
- **Wait/Poll:** None
- **Rationale:** Enable all system interrupts (temp, voltage, ADC, PLL, HSTC error alerts)

### Step 14 — Communication Init
- **Register:** `UART_BAUD_DIV` at `0x0100`
- **Write value:** `0x0034`
- **Wait/Poll:** None
- **Rationale:** Set UART baud rate divisor for 115200 baud at 100MHz system clock (100MHz / (16 * 115200) ≈ 54 = 0x36)

### Step 15 — Communication Init
- **Register:** `UART_CTRL` at `0x0101`
- **Write value:** `0x01`
- **Wait/Poll:** None
- **Rationale:** Enable UART with 8N1 frame format for host communication

### Step 16 — ADC Init
- **Register:** `ADC_CTRL` at `0x0200`
- **Write value:** `0x10`
- **Wait/Poll:** Wait 50ms
- **Rationale:** Exit ADC power-down mode, allow time for internal bias stabilization

### Step 17 — ADC Init
- **Register:** `ADC_CTRL` at `0x0200`
- **Write value:** `0x13`
- **Wait/Poll:** None
- **Rationale:** Enable ADC, continuous mode, DDC enabled, both I and Q channels active

### Step 18 — ADC Init
- **Register:** `ADC_STATUS` at `0x0201`
- **Write value:** `0x0000`
- **Wait/Poll:** Poll until CAL_COMPLETE (bit2) = 1
- **Rationale:** Wait for ADC12J4000 internal calibration to complete

### Step 19 — RF Chain Init
- **Register:** `RF_LO_CTRL` at `0x0702`
- **Write value:** `0x01`
- **Wait/Poll:** None
- **Rationale:** Enable HMC364 LO buffer amplifier to condition LO input signal

### Step 20 — RF Chain Init
- **Register:** `RF_LNA_CTRL` at `0x0700`
- **Write value:** `0x01`
- **Wait/Poll:** None
- **Rationale:** Enable HMC698 LNA with low gain setting - apply RF input signal after this step

### Step 21 — RF Chain Init
- **Register:** `RF_MIXER_CTRL` at `0x0701`
- **Write value:** `0x01`
- **Wait/Poll:** None
- **Rationale:** Enable HMC1119 mixer with default IF gain - I/Q outputs now active

### Step 22 — Application Init
- **Register:** `DATA_FORMAT_CTRL` at `0x0902`
- **Write value:** `0x04`
- **Wait/Poll:** None
- **Rationale:** Set 12-bit word size, 2's complement format, MSB-first for ADC12J4000 IQ data

### Step 23 — Application Init
- **Register:** `SAMPLE_RATE_CTRL` at `0x0903`
- **Write value:** `0x0004`
- **Wait/Poll:** None
- **Rationale:** Set decimation factor to 4 for effective 1 GSPS output rate (4 GSPS / 4 = 1 GSPS)

### Step 24 — Application Init
- **Register:** `HSTC_CTRL` at `0x0900`
- **Write value:** `0x09`
- **Wait/Poll:** None
- **Rationale:** Enable HSTC link with 4-lane mode and on-board termination enabled

### Step 25 — Application Init
- **Register:** `HSTC_STATUS` at `0x0901`
- **Write value:** `0x0000`
- **Wait/Poll:** Poll until LINK_UP (bit0) = 1, all LANE_SYNC bits = 1
- **Rationale:** Verify HSTC high-speed data link established before streaming IQ data

### Step 26 — Application Init
- **Register:** `CALIBRATION_CTRL` at `0x0A00`
- **Write value:** `0x07`
- **Wait/Poll:** Poll until CAL_BUSY (bit7) = 0
- **Rationale:** Run RF calibration sequence including DC offset and IQ imbalance correction

### Step 27 — Application Init
- **Register:** `LED_CTRL` at `0x0802`
- **Write value:** `0x0B`
- **Wait/Poll:** None
- **Rationale:** Enable Power, Activity, and RF LEDs to indicate system fully operational

### Step 28 — Final Verification
- **Register:** `HEALTH_STATUS` at `0x030F`
- **Write value:** `0x0000`
- **Wait/Poll:** Verify SYSTEM_OK (bit7) = 1, all OK bits = 1
- **Rationale:** Final health check - confirm temperature, voltage, PLL lock, ADC ready all good

### Step 29 — NV Config Load
- **Register:** `EEPROM_ADDR` at `0x0501`
- **Write value:** `0x0000`
- **Wait/Poll:** None
- **Rationale:** Set EEPROM start address for calibration data read

### Step 30 — NV Config Load
- **Register:** `EEPROM_CTRL` at `0x0500`
- **Write value:** `0x01`
- **Wait/Poll:** Poll until BUSY (bit7) = 0
- **Rationale:** Read factory calibration data from EEPROM - contains RF gain correction coefficients

### Step 31 — NV Config Load
- **Register:** `EEPROM_DATA` at `0x0502`
- **Write value:** `0x0000`
- **Wait/Poll:** Read and apply calibration values
- **Rationale:** Retrieve calibration constants and apply to RF gain/phase correction registers
