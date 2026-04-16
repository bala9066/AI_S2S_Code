# Programming Sequence (PSQ)
## j,fj

> **Total steps:** 25

| # | Phase | Register | Address | Value | Condition | Rationale |
|---|-------|----------|---------|-------|-----------|-----------|
| 1 | Power-On Reset & Self-Check | `SCRATCHPAD` | `0x0003` | `0xA5A5` | Read back to verify | Verify RAM integrity and address decoding - write test pattern and read back to confirm functional memory interface |
| 2 | Power-On Reset & Self-Check | `SCRATCHPAD` | `0x0003` | `0x5A5A` | Read back to verify | Second verification pattern - ensures no stuck bits and full bidirectional data path functionality |
| 3 | Power-On Reset & Self-Check | `BOARD_ID` | `0x0000` | `0x4A46` | Verify ID matches expected 0x4A46 | Confirm FPGA firmware is running on correct hardware - validate BOARD_ID returns 'JF' (0x4A46) |
| 4 | Power-On Reset & Self-Check | `HEALTH_STATUS` | `0x030F` | `0x00` | Poll until VOLT_OK=1 (bit1 set) | Wait for power rails (5V, 3.3V, 1.8V, 1.0V) to stabilize - LTC7138 and TPS7A4700 require startup time |
| 5 | PLL & Clock Init | `PLL_N_DIV` | `0x0402` | `0x0040` | None | Configure PLL N divider for initial LO frequency - set to 64 for mid-band operation around 5-6 GHz |
| 6 | PLL & Clock Init | `PLL_R_DIV` | `0x0403` | `0x01` | None | Configure PLL R divider (reference) - set to 1 for no reference division (max phase noise performance) |
| 7 | PLL & Clock Init | `PLL_CTRL` | `0x0400` | `0x01` | Poll PLL_STATUS bit0 (LOCKED) until 1 | Enable PLL and wait for lock - ADF5356 requires time to achieve phase lock (typically 10ms) |
| 8 | PLL & Clock Init | `CLK_ENABLE` | `0x0410` | `0x0F` | None | Enable all clock outputs - ADC clock, FPGA clock, LO reference, and LVDS clock now available |
| 9 | Peripheral Enable | `TEMP_ALERT_HIGH` | `0x0308` | `0x01F4` | None | Set over-temperature threshold to 125°C (0x01F4 = 125°C in 0.25°C units) - allows margin for RF front end heating |
| 10 | Peripheral Enable | `TEMP_ALERT_LOW` | `0x0309` | `0xFF9C` | None | Set under-temperature threshold to -25°C (0xFF9C signed = -25°C) - prevents operation in freezing conditions |
| 11 | Communication Init | `UART_BAUD_DIV` | `0x0100` | `0x0022` | None | Configure UART baud rate divisor - assumes 50MHz clock with 16x oversampling = 115200 bps |
| 12 | Communication Init | `UART_CTRL` | `0x0101` | `0x01` | None | Enable UART with 8N1 format - console interface now active for debug and configuration |
| 13 | Application Init | `RF_LO_FREQ_HIGH` | `0x0700` | `0x4E20` | None | Set LO frequency to 20 GHz (0x4E20 = 20000 MHz) - center of 4.5-18.5 GHz band |
| 14 | Application Init | `RF_LO_FREQ_LOW` | `0x0701` | `0x0000` | None | Set LO frequency lower bits to zero - complete 20 GHz configuration |
| 15 | Application Init | `RF_LO_CTRL` | `0x0702` | `0x01` | Poll RF_LO_STATUS bit0 (LD) until 1 | Enable ADF5356 LO output and wait for lock detect - LO now drives mixer at 20 GHz |
| 16 | Application Init | `RF_VGA_GAIN` | `0x0708` | `0x20` | None | Set HMC699LP4 VGA to nominal gain (0x20 = ~0dB) - adjust after IF chain characterization |
| 17 | Application Init | `RF_LNA_ENABLE` | `0x0709` | `0x21` | None | Enable HMC1113LP3DE LNA with default bias trim - RF front end now active |
| 18 | Application Init | `RF_MIXER_ENABLE` | `0x070A` | `0x03` | None | Enable HMC1056LP4BE mixer and IF filter - downconversion path now complete |
| 19 | Application Init | `ADC_CTRL` | `0x0200` | `0x05` | Poll ADC_STATUS bit2 (CALIB_DONE) until 1 | Enable ADC12DJ3200 in continuous mode (bit1=1) on channel A (bits[3:2]=0) - wait for internal calibration |
| 20 | Application Init | `LVDS_CTRL` | `0x0A00` | `0x0D` | Poll LVDS_STATUS bit0 (LINK_UP) until 1 | Enable LVDS drivers (bit0=1) with 100 ohm termination (bit1=1) and high drive (bits[3:2]=2) - data link ready |
| 21 | Application Init | `EEPROM_ADDR` | `0x0501` | `0x0000` | None | Set EEPROM address to 0x0000 - prepare to read calibration data and MAC address |
| 22 | Application Init | `EEPROM_CTRL` | `0x0500` | `0x01` | Poll bit7 (BUSY) until 0 | Initiate EEPROM read from AT24CS02 - I2C transaction to retrieve MAC address |
| 23 | Application Init | `GPIO_OUTPUT` | `0x0800` | `0x0001` | None | Turn on status LED (GPIO bit0) - indicates system initialization complete and ready for operation |
| 24 | Final Verification | `HEALTH_STATUS` | `0x030F` | `0x00` | Verify bit7 (SYSTEM_OK) = 1 | Final health check - confirm all systems (TEMP, VOLT, PLL, ADC) are OK before declaring ready state |
| 25 | Final Verification | `ADC_STATUS` | `0x0201` | `0x00` | Verify bit0 (DATA_READY) = 1 | Confirm ADC is producing data - verify bit0 toggles indicating active data stream from IF chain |

---

## Detailed Steps

### Step 1 — Power-On Reset & Self-Check
- **Register:** `SCRATCHPAD` at `0x0003`
- **Write value:** `0xA5A5`
- **Wait/Poll:** Read back to verify
- **Rationale:** Verify RAM integrity and address decoding - write test pattern and read back to confirm functional memory interface

### Step 2 — Power-On Reset & Self-Check
- **Register:** `SCRATCHPAD` at `0x0003`
- **Write value:** `0x5A5A`
- **Wait/Poll:** Read back to verify
- **Rationale:** Second verification pattern - ensures no stuck bits and full bidirectional data path functionality

### Step 3 — Power-On Reset & Self-Check
- **Register:** `BOARD_ID` at `0x0000`
- **Write value:** `0x4A46`
- **Wait/Poll:** Verify ID matches expected 0x4A46
- **Rationale:** Confirm FPGA firmware is running on correct hardware - validate BOARD_ID returns 'JF' (0x4A46)

### Step 4 — Power-On Reset & Self-Check
- **Register:** `HEALTH_STATUS` at `0x030F`
- **Write value:** `0x00`
- **Wait/Poll:** Poll until VOLT_OK=1 (bit1 set)
- **Rationale:** Wait for power rails (5V, 3.3V, 1.8V, 1.0V) to stabilize - LTC7138 and TPS7A4700 require startup time

### Step 5 — PLL & Clock Init
- **Register:** `PLL_N_DIV` at `0x0402`
- **Write value:** `0x0040`
- **Wait/Poll:** None
- **Rationale:** Configure PLL N divider for initial LO frequency - set to 64 for mid-band operation around 5-6 GHz

### Step 6 — PLL & Clock Init
- **Register:** `PLL_R_DIV` at `0x0403`
- **Write value:** `0x01`
- **Wait/Poll:** None
- **Rationale:** Configure PLL R divider (reference) - set to 1 for no reference division (max phase noise performance)

### Step 7 — PLL & Clock Init
- **Register:** `PLL_CTRL` at `0x0400`
- **Write value:** `0x01`
- **Wait/Poll:** Poll PLL_STATUS bit0 (LOCKED) until 1
- **Rationale:** Enable PLL and wait for lock - ADF5356 requires time to achieve phase lock (typically 10ms)

### Step 8 — PLL & Clock Init
- **Register:** `CLK_ENABLE` at `0x0410`
- **Write value:** `0x0F`
- **Wait/Poll:** None
- **Rationale:** Enable all clock outputs - ADC clock, FPGA clock, LO reference, and LVDS clock now available

### Step 9 — Peripheral Enable
- **Register:** `TEMP_ALERT_HIGH` at `0x0308`
- **Write value:** `0x01F4`
- **Wait/Poll:** None
- **Rationale:** Set over-temperature threshold to 125°C (0x01F4 = 125°C in 0.25°C units) - allows margin for RF front end heating

### Step 10 — Peripheral Enable
- **Register:** `TEMP_ALERT_LOW` at `0x0309`
- **Write value:** `0xFF9C`
- **Wait/Poll:** None
- **Rationale:** Set under-temperature threshold to -25°C (0xFF9C signed = -25°C) - prevents operation in freezing conditions

### Step 11 — Communication Init
- **Register:** `UART_BAUD_DIV` at `0x0100`
- **Write value:** `0x0022`
- **Wait/Poll:** None
- **Rationale:** Configure UART baud rate divisor - assumes 50MHz clock with 16x oversampling = 115200 bps

### Step 12 — Communication Init
- **Register:** `UART_CTRL` at `0x0101`
- **Write value:** `0x01`
- **Wait/Poll:** None
- **Rationale:** Enable UART with 8N1 format - console interface now active for debug and configuration

### Step 13 — Application Init
- **Register:** `RF_LO_FREQ_HIGH` at `0x0700`
- **Write value:** `0x4E20`
- **Wait/Poll:** None
- **Rationale:** Set LO frequency to 20 GHz (0x4E20 = 20000 MHz) - center of 4.5-18.5 GHz band

### Step 14 — Application Init
- **Register:** `RF_LO_FREQ_LOW` at `0x0701`
- **Write value:** `0x0000`
- **Wait/Poll:** None
- **Rationale:** Set LO frequency lower bits to zero - complete 20 GHz configuration

### Step 15 — Application Init
- **Register:** `RF_LO_CTRL` at `0x0702`
- **Write value:** `0x01`
- **Wait/Poll:** Poll RF_LO_STATUS bit0 (LD) until 1
- **Rationale:** Enable ADF5356 LO output and wait for lock detect - LO now drives mixer at 20 GHz

### Step 16 — Application Init
- **Register:** `RF_VGA_GAIN` at `0x0708`
- **Write value:** `0x20`
- **Wait/Poll:** None
- **Rationale:** Set HMC699LP4 VGA to nominal gain (0x20 = ~0dB) - adjust after IF chain characterization

### Step 17 — Application Init
- **Register:** `RF_LNA_ENABLE` at `0x0709`
- **Write value:** `0x21`
- **Wait/Poll:** None
- **Rationale:** Enable HMC1113LP3DE LNA with default bias trim - RF front end now active

### Step 18 — Application Init
- **Register:** `RF_MIXER_ENABLE` at `0x070A`
- **Write value:** `0x03`
- **Wait/Poll:** None
- **Rationale:** Enable HMC1056LP4BE mixer and IF filter - downconversion path now complete

### Step 19 — Application Init
- **Register:** `ADC_CTRL` at `0x0200`
- **Write value:** `0x05`
- **Wait/Poll:** Poll ADC_STATUS bit2 (CALIB_DONE) until 1
- **Rationale:** Enable ADC12DJ3200 in continuous mode (bit1=1) on channel A (bits[3:2]=0) - wait for internal calibration

### Step 20 — Application Init
- **Register:** `LVDS_CTRL` at `0x0A00`
- **Write value:** `0x0D`
- **Wait/Poll:** Poll LVDS_STATUS bit0 (LINK_UP) until 1
- **Rationale:** Enable LVDS drivers (bit0=1) with 100 ohm termination (bit1=1) and high drive (bits[3:2]=2) - data link ready

### Step 21 — Application Init
- **Register:** `EEPROM_ADDR` at `0x0501`
- **Write value:** `0x0000`
- **Wait/Poll:** None
- **Rationale:** Set EEPROM address to 0x0000 - prepare to read calibration data and MAC address

### Step 22 — Application Init
- **Register:** `EEPROM_CTRL` at `0x0500`
- **Write value:** `0x01`
- **Wait/Poll:** Poll bit7 (BUSY) until 0
- **Rationale:** Initiate EEPROM read from AT24CS02 - I2C transaction to retrieve MAC address

### Step 23 — Application Init
- **Register:** `GPIO_OUTPUT` at `0x0800`
- **Write value:** `0x0001`
- **Wait/Poll:** None
- **Rationale:** Turn on status LED (GPIO bit0) - indicates system initialization complete and ready for operation

### Step 24 — Final Verification
- **Register:** `HEALTH_STATUS` at `0x030F`
- **Write value:** `0x00`
- **Wait/Poll:** Verify bit7 (SYSTEM_OK) = 1
- **Rationale:** Final health check - confirm all systems (TEMP, VOLT, PLL, ADC) are OK before declaring ready state

### Step 25 — Final Verification
- **Register:** `ADC_STATUS` at `0x0201`
- **Write value:** `0x00`
- **Wait/Poll:** Verify bit0 (DATA_READY) = 1
- **Rationale:** Confirm ADC is producing data - verify bit0 toggles indicating active data stream from IF chain
