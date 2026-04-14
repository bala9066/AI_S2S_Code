# Programming Sequence (PSQ)
## rx module

> **Total steps:** 25

| # | Phase | Register | Address | Value | Condition | Rationale |
|---|-------|----------|---------|-------|-----------|-----------|
| 1 | Power-On Reset & Self-Check | `SCRATCHPAD` | `0x0003` | `0xA5A5` | Read back 0xA5A5 to verify communication | Basic communication test - write known pattern and read back to verify UART link and register access are functional |
| 2 | Power-On Reset & Self-Check | `BOARD_ID` | `0x0000` | `READ` | Verify 0x5258 (ASCII 'RX') | Confirm correct board type - RX module identification check |
| 3 | Power-On Reset & Self-Check | `BOARD_VERSION` | `0x0001` | `READ` | Log version for compatibility | Read hardware version for driver compatibility verification |
| 4 | Power-On Reset & Self-Check | `HEALTH_STATUS` | `0x030F` | `READ` | Poll until VOLT_OK=1 | Wait for power supplies to stabilize - AMS1117 regulators must settle before proceeding |
| 5 | PLL & Clock Init | `PLL_CTRL` | `0x0400` | `0x01` | Poll PLL_STATUS[0]=1 (LOCKED) | Enable MCU PLL to achieve 80MHz system clock from 16MHz HSI oscillator |
| 6 | PLL & Clock Init | `PLL_N_DIV` | `0x0402` | `0x000A` | None | Configure PLL multiplier for 80MHz operation (16MHz * 10 / 2 = 80MHz) |
| 7 | PLL & Clock Init | `CLK_ENABLE` | `0x0410` | `0x1F` | None | Enable all peripheral clocks - SPI (DSA), I2C (temp), ADC (power), UART (comm), Timer (monitoring) |
| 8 | Peripheral Enable | `GPIO_CTRL` | `0x0800` | `0x04` | None | Enable status LED only initially - keep PA and VGG disabled until fully configured |
| 9 | Peripheral Enable | `PROTECTION_CTRL` | `0x0902` | `0x0F` | None | Enable all protection circuits (OTP, OVP, auto-shutdown, fault latching) before enabling RF chain |
| 10 | Peripheral Enable | `ADC_CTRL` | `0x0200` | `0x01` | None | Enable ADC for RF power detector monitoring - continuous mode not needed yet |
| 11 | Communication Init | `UART_BAUD_DIV` | `0x0100` | `0x0006` | None | Set UART baud rate to 3.0Mbps (80MHz / (16 * 6) ≈ 833333, adjust for 3Mbps) |
| 12 | Communication Init | `UART_CTRL` | `0x0101` | `0x01` | Verify UART_STATUS[3]=0 (no errors) | Enable UART in normal mode (disable loopback), clear any initialization errors |
| 13 | Application Init | `TEMP_ALERT_HIGH` | `0x0308` | `0x0190` | None | Set over-temperature threshold to 100°C for TMP102 monitoring |
| 14 | Application Init | `TEMP_ALERT_LOW` | `0x0309` | `0xFF9C` | None | Set under-temperature threshold to -25°C |
| 15 | Application Init | `TEMP_REMOTE1` | `0x0301` | `READ` | Verify temperature < TEMP_ALERT_HIGH | Read TMP102 board temperature and confirm within safe operating range before RF enable |
| 16 | Application Init | `RF_DSA_CTRL` | `0x0700` | `0x3F` | Poll RF_DSA_STATUS[0]=1 (loaded) | Initialize DSA to mid-scale attenuation (15.75dB) for safe startup - load via SPI |
| 17 | Application Init | `VGG_DAC_CTRL` | `0x0900` | `0x8000` | Poll VGG_DAC_STATUS[0]=1 (ready) | Set VGG bias DAC to mid-range (1.25V equivalent) for PA gate bias - enable DAC output |
| 18 | Application Init | `VGG_MONITOR` | `0x0213` | `READ` | Verify VGG within expected range | Read back VGG bias voltage to confirm correct bias before enabling PA |
| 19 | Application Init | `GPIO_CTRL` | `0x0800` | `0x03` | Read PROTECTION_STATUS to confirm no faults | Enable VGG bias (bit 1) - PA_ENABLE (bit 0) still OFF, check protection status before proceeding |
| 20 | Application Init | `GPIO_CTRL` | `0x0800` | `0x05` | Monitor RF_POWER_RAW for expected levels | Enable PA (bit 0) with VGG already stable - now monitoring RF output power via AD8318 |
| 21 | Calibration & Storage | `EEPROM_ADDR` | `0x0501` | `0x0000` | None | Set EEPROM address to read calibration data (offset 0x0000) |
| 22 | Calibration & Storage | `EEPROM_CTRL` | `0x0500` | `0x01` | Poll EEPROM_CTRL[7]=0 (BUSY cleared) | Trigger EEPROM read to fetch DSA calibration coefficients |
| 23 | Calibration & Storage | `EEPROM_DATA` | `0x0502` | `READ` | None | Read calibration data for RF gain adjustment - store in internal registers |
| 24 | Runtime Monitoring | `RF_POWER_RAW` | `0x0210` | `READ` | Continuous monitoring loop | Read RF power detector ADC value for AGC and OVP monitoring - convert to dBm using calibration |
| 25 | Runtime Monitoring | `ADC_STATUS` | `0x0201` | `READ` | Check OVERRANGE bit for OVP | Check ADC status for overpower condition - trigger protection if overrange detected |

---

## Detailed Steps

### Step 1 — Power-On Reset & Self-Check
- **Register:** `SCRATCHPAD` at `0x0003`
- **Write value:** `0xA5A5`
- **Wait/Poll:** Read back 0xA5A5 to verify communication
- **Rationale:** Basic communication test - write known pattern and read back to verify UART link and register access are functional

### Step 2 — Power-On Reset & Self-Check
- **Register:** `BOARD_ID` at `0x0000`
- **Write value:** `READ`
- **Wait/Poll:** Verify 0x5258 (ASCII 'RX')
- **Rationale:** Confirm correct board type - RX module identification check

### Step 3 — Power-On Reset & Self-Check
- **Register:** `BOARD_VERSION` at `0x0001`
- **Write value:** `READ`
- **Wait/Poll:** Log version for compatibility
- **Rationale:** Read hardware version for driver compatibility verification

### Step 4 — Power-On Reset & Self-Check
- **Register:** `HEALTH_STATUS` at `0x030F`
- **Write value:** `READ`
- **Wait/Poll:** Poll until VOLT_OK=1
- **Rationale:** Wait for power supplies to stabilize - AMS1117 regulators must settle before proceeding

### Step 5 — PLL & Clock Init
- **Register:** `PLL_CTRL` at `0x0400`
- **Write value:** `0x01`
- **Wait/Poll:** Poll PLL_STATUS[0]=1 (LOCKED)
- **Rationale:** Enable MCU PLL to achieve 80MHz system clock from 16MHz HSI oscillator

### Step 6 — PLL & Clock Init
- **Register:** `PLL_N_DIV` at `0x0402`
- **Write value:** `0x000A`
- **Wait/Poll:** None
- **Rationale:** Configure PLL multiplier for 80MHz operation (16MHz * 10 / 2 = 80MHz)

### Step 7 — PLL & Clock Init
- **Register:** `CLK_ENABLE` at `0x0410`
- **Write value:** `0x1F`
- **Wait/Poll:** None
- **Rationale:** Enable all peripheral clocks - SPI (DSA), I2C (temp), ADC (power), UART (comm), Timer (monitoring)

### Step 8 — Peripheral Enable
- **Register:** `GPIO_CTRL` at `0x0800`
- **Write value:** `0x04`
- **Wait/Poll:** None
- **Rationale:** Enable status LED only initially - keep PA and VGG disabled until fully configured

### Step 9 — Peripheral Enable
- **Register:** `PROTECTION_CTRL` at `0x0902`
- **Write value:** `0x0F`
- **Wait/Poll:** None
- **Rationale:** Enable all protection circuits (OTP, OVP, auto-shutdown, fault latching) before enabling RF chain

### Step 10 — Peripheral Enable
- **Register:** `ADC_CTRL` at `0x0200`
- **Write value:** `0x01`
- **Wait/Poll:** None
- **Rationale:** Enable ADC for RF power detector monitoring - continuous mode not needed yet

### Step 11 — Communication Init
- **Register:** `UART_BAUD_DIV` at `0x0100`
- **Write value:** `0x0006`
- **Wait/Poll:** None
- **Rationale:** Set UART baud rate to 3.0Mbps (80MHz / (16 * 6) ≈ 833333, adjust for 3Mbps)

### Step 12 — Communication Init
- **Register:** `UART_CTRL` at `0x0101`
- **Write value:** `0x01`
- **Wait/Poll:** Verify UART_STATUS[3]=0 (no errors)
- **Rationale:** Enable UART in normal mode (disable loopback), clear any initialization errors

### Step 13 — Application Init
- **Register:** `TEMP_ALERT_HIGH` at `0x0308`
- **Write value:** `0x0190`
- **Wait/Poll:** None
- **Rationale:** Set over-temperature threshold to 100°C for TMP102 monitoring

### Step 14 — Application Init
- **Register:** `TEMP_ALERT_LOW` at `0x0309`
- **Write value:** `0xFF9C`
- **Wait/Poll:** None
- **Rationale:** Set under-temperature threshold to -25°C

### Step 15 — Application Init
- **Register:** `TEMP_REMOTE1` at `0x0301`
- **Write value:** `READ`
- **Wait/Poll:** Verify temperature < TEMP_ALERT_HIGH
- **Rationale:** Read TMP102 board temperature and confirm within safe operating range before RF enable

### Step 16 — Application Init
- **Register:** `RF_DSA_CTRL` at `0x0700`
- **Write value:** `0x3F`
- **Wait/Poll:** Poll RF_DSA_STATUS[0]=1 (loaded)
- **Rationale:** Initialize DSA to mid-scale attenuation (15.75dB) for safe startup - load via SPI

### Step 17 — Application Init
- **Register:** `VGG_DAC_CTRL` at `0x0900`
- **Write value:** `0x8000`
- **Wait/Poll:** Poll VGG_DAC_STATUS[0]=1 (ready)
- **Rationale:** Set VGG bias DAC to mid-range (1.25V equivalent) for PA gate bias - enable DAC output

### Step 18 — Application Init
- **Register:** `VGG_MONITOR` at `0x0213`
- **Write value:** `READ`
- **Wait/Poll:** Verify VGG within expected range
- **Rationale:** Read back VGG bias voltage to confirm correct bias before enabling PA

### Step 19 — Application Init
- **Register:** `GPIO_CTRL` at `0x0800`
- **Write value:** `0x03`
- **Wait/Poll:** Read PROTECTION_STATUS to confirm no faults
- **Rationale:** Enable VGG bias (bit 1) - PA_ENABLE (bit 0) still OFF, check protection status before proceeding

### Step 20 — Application Init
- **Register:** `GPIO_CTRL` at `0x0800`
- **Write value:** `0x05`
- **Wait/Poll:** Monitor RF_POWER_RAW for expected levels
- **Rationale:** Enable PA (bit 0) with VGG already stable - now monitoring RF output power via AD8318

### Step 21 — Calibration & Storage
- **Register:** `EEPROM_ADDR` at `0x0501`
- **Write value:** `0x0000`
- **Wait/Poll:** None
- **Rationale:** Set EEPROM address to read calibration data (offset 0x0000)

### Step 22 — Calibration & Storage
- **Register:** `EEPROM_CTRL` at `0x0500`
- **Write value:** `0x01`
- **Wait/Poll:** Poll EEPROM_CTRL[7]=0 (BUSY cleared)
- **Rationale:** Trigger EEPROM read to fetch DSA calibration coefficients

### Step 23 — Calibration & Storage
- **Register:** `EEPROM_DATA` at `0x0502`
- **Write value:** `READ`
- **Wait/Poll:** None
- **Rationale:** Read calibration data for RF gain adjustment - store in internal registers

### Step 24 — Runtime Monitoring
- **Register:** `RF_POWER_RAW` at `0x0210`
- **Write value:** `READ`
- **Wait/Poll:** Continuous monitoring loop
- **Rationale:** Read RF power detector ADC value for AGC and OVP monitoring - convert to dBm using calibration

### Step 25 — Runtime Monitoring
- **Register:** `ADC_STATUS` at `0x0201`
- **Write value:** `READ`
- **Wait/Poll:** Check OVERRANGE bit for OVP
- **Rationale:** Check ADC status for overpower condition - trigger protection if overrange detected
