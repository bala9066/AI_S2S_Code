# Programming Sequence (PSQ)
## iguyc

> **Total steps:** 37

| # | Phase | Register | Address | Value | Condition | Rationale |
|---|-------|----------|---------|-------|-----------|-----------|
| 1 | Power-On Reset & Self-Check | `SCRATCHPAD` | `0x0003` | `0xA5A5` | Read back verification (poll until 0xA5A5) | RAM integrity check - verify register read/write path functional after power-on reset |
| 2 | Power-On Reset & Self-Check | `SCRATCHPAD` | `0x0003` | `0x5A5A` | Read back verification (poll until 0x5A5A) | Secondary RAM check with complementary pattern to detect stuck bits |
| 3 | Power-On Reset & Self-Check | `BOARD_ID` | `0x0000` | `0x0000` | Verify BOARD_ID == 0x4947 ('IG') | Validate correct FPGA bitstream loaded for iguyc receiver board |
| 4 | Power-On Reset & Self-Check | `HEALTH_STATUS` | `0x030F` | `0x0000` | Poll until VOLT_OK==1 (timeout 500ms) | Wait for power rails to stabilize - all supplies (5V_RF, 1.2V_ADC, 0.85V_INT, 1.8V_AUX) must be within tolerance |
| 5 | PLL & Clock Init | `PLL_LO_CTRL` | `0x0400` | `0x02` | Wait 10ms after write | Assert PLL reset to clear ADF5355 state before configuration |
| 6 | PLL & Clock Init | `PLL_LO_CTRL` | `0x0400` | `0x00` | Wait 1ms after deassert | Release PLL reset - allow ADF5355 to initialize |
| 7 | PLL & Clock Init | `PLL_INT_DIV` | `0x0402` | `0x2710` | None | Set integer N divider = 10000 for LO frequency synthesis (adjusts VCO output) |
| 8 | PLL & Clock Init | `PLL_FRAC_DIV` | `0x0403` | `0x8000` | None | Set fractional divider to 0.5 for fine frequency resolution (ADF5355 24-bit frac) |
| 9 | PLL & Clock Init | `PLL_REF_DIV` | `0x0404` | `0x0001` | None | Set R divider = 1 (10MHz reference input /1 = 10MHz PFD freq) |
| 10 | PLL & Clock Init | `PLL_LO_CTRL` | `0x0400` | `0x01` | Poll PLL_LO_STATUS[LOCKED]==1 (timeout 100ms) | Enable ADF5355 PLL and wait for lock detect - LO frequency must be stable before RF chain enable |
| 11 | PLL & Clock Init | `CLK_ENABLE` | `0x0410` | `0x0F` | None | Enable all clock outputs: ADC sampling clock, FPGA system clock, JESD204B ref clock, RF front-end clock |
| 12 | Peripheral Enable | `SPI_PLL_CTRL` | `0x0108` | `0x13` | None | Enable SPI interface for ADF5355 with CLK_DIV=3 (div16) for reliable 4-wire SPI communication |
| 13 | Peripheral Enable | `I2C_CTRL` | `0x010B` | `0x05` | None | Enable I2C interface at 400kHz fast-mode for ADC12DJ3200 configuration and PMIC monitoring |
| 14 | Peripheral Enable | `ADC_CTRL` | `0x0220` | `0x03` | None | Enable ADC monitoring in continuous mode - start auto-scan of all supply rails |
| 15 | Communication Init | `UART_BAUD_DIV` | `0x0100` | `0x0082` | None | Configure UART baud divisor for 115200 baud @ 100MHz UART_CLK (standard debug rate) |
| 16 | Communication Init | `UART_CTRL` | `0x0101` | `0x01` | None | Enable UART transmitter and receiver for command interface and debug output |
| 17 | RF Chain Init | `JESD_CTRL` | `0x0500` | `0x17` | None | Enable JESD204B link: enable lanes 0&1, subclass 1, prepare for ADC12DJ3200 data |
| 18 | RF Chain Init | `JESD_SCR_L` | `0x0502` | `0xAA` | None | Configure JESD204B scrambling seed low byte (0xAA) for deterministic data pattern |
| 19 | RF Chain Init | `JESD_SCR_H` | `0x0503` | `0x55` | None | Configure JESD204B scrambling seed high byte (0x55) - complements low byte |
| 20 | RF Chain Init | `JESD_CTRL` | `0x0500` | `0x97` | Poll JESD_STATUS[LINK_READY]==1 (timeout 200ms) | Assert SYNC~ to initiate JESD204B code group synchronization with ADC12DJ3200 |
| 21 | RF Chain Init | `VGA_GAIN_CTRL` | `0x0600` | `0x8020` | Poll VGA_STATUS[GAIN_LOADED]==1 | Set HMC698LP4 VGA to mid-gain (32/63) and assert LE to load gain value into parallel interface |
| 22 | RF Chain Init | `LNA_CTRL` | `0x0608` | `0x01` | None | Enable HMC6987LP4E LNA in high-gain mode - first stage of RF chain |
| 23 | RF Chain Init | `MIXER_CTRL` | `0x0609` | `0x07` | None | Enable HMC1194LP4E mixer with all ports enabled (IF, LO, RF) for downconversion |
| 24 | Application Init | `TEMP_ALERT_HIGH` | `0x0308` | `0x8190` | None | Set over-temperature alert threshold to 100°C (0x0190) and enable alert (bit 15) |
| 25 | Application Init | `TEMP_ALERT_LOW` | `0x0309` | `0x8F9C` | None | Set under-temperature alert threshold to -25°C (signed 0xFF9C) and enable alert (bit 15) |
| 26 | Application Init | `RF_FREQ_TARGET_L` | `0x0701` | `0x4B00` | None | Set target RF frequency low word - 19.2GHz lower bits (example LO frequency) |
| 27 | Application Init | `RF_FREQ_TARGET_H` | `0x0702` | `0x0000` | None | Set target RF frequency high word - configure for 5-18GHz receive range |
| 28 | Application Init | `RF_IF_FREQ` | `0x0703` | `0x01F4` | None | Set IF frequency to 500MHz for optimal ADC12DJ3200 performance |
| 29 | Application Init | `RF_RX_CTRL` | `0x0700` | `0x09` | Poll RF_STATUS[RF_LOCKED]==1 and RF_STATUS[AGC_SETTLED]==1 | Enable RF receiver chain with AGC - LNA, Mixer, VGA now active, wait for LO lock and AGC settle |
| 30 | Application Init | `HEALTH_STATUS` | `0x030F` | `0x0000` | Verify SYSTEM_OK==1 (all status bits pass) | Final health check - confirm temperature OK, voltages OK, PLL locked, JESD synced before entering operational mode |
| 31 | EEPROM Init | `I2C_SLAVE_ADDR` | `0x010C` | `0x50` | None | Set I2C slave address to EEPROM (0x50 is standard for CAT24C256) for calibration data read |
| 32 | EEPROM Init | `EEPROM_ADDR` | `0x0801` | `0x0000` | None | Set EEPROM address to 0x0000 - start of calibration data block |
| 33 | EEPROM Init | `EEPROM_CTRL` | `0x0800` | `0x01` | Poll EEPROM_CTRL[BUSY]==0 | Trigger EEPROM read of calibration data - wait for read cycle complete |
| 34 | EEPROM Init | `EEPROM_DATA` | `0x0802` | `0x0000` | Read calibration data word | Retrieve first calibration word - contains LNA gain trim value (store in internal register) |
| 35 | Flash Init | `FLASH_ADDR_L` | `0x0901` | `0x0000` | None | Set Quad-SPI Flash address to 0x000000 for ID read |
| 36 | Flash Init | `FLASH_CTRL` | `0x0900` | `0x01` | Poll FLASH_CTRL[BUSY]==0 then FLASH_STATUS[READY]==1 | Issue flash read command to verify flash ID and bitstream presence |
| 37 | Operational Ready | `UART_STATUS` | `0x0102` | `0x0000` | Check FRAME_ERR==0 and OVERRUN_ERR==0 | Verify UART interface is clean - ready for command processing and telemetry output |

---

## Detailed Steps

### Step 1 — Power-On Reset & Self-Check
- **Register:** `SCRATCHPAD` at `0x0003`
- **Write value:** `0xA5A5`
- **Wait/Poll:** Read back verification (poll until 0xA5A5)
- **Rationale:** RAM integrity check - verify register read/write path functional after power-on reset

### Step 2 — Power-On Reset & Self-Check
- **Register:** `SCRATCHPAD` at `0x0003`
- **Write value:** `0x5A5A`
- **Wait/Poll:** Read back verification (poll until 0x5A5A)
- **Rationale:** Secondary RAM check with complementary pattern to detect stuck bits

### Step 3 — Power-On Reset & Self-Check
- **Register:** `BOARD_ID` at `0x0000`
- **Write value:** `0x0000`
- **Wait/Poll:** Verify BOARD_ID == 0x4947 ('IG')
- **Rationale:** Validate correct FPGA bitstream loaded for iguyc receiver board

### Step 4 — Power-On Reset & Self-Check
- **Register:** `HEALTH_STATUS` at `0x030F`
- **Write value:** `0x0000`
- **Wait/Poll:** Poll until VOLT_OK==1 (timeout 500ms)
- **Rationale:** Wait for power rails to stabilize - all supplies (5V_RF, 1.2V_ADC, 0.85V_INT, 1.8V_AUX) must be within tolerance

### Step 5 — PLL & Clock Init
- **Register:** `PLL_LO_CTRL` at `0x0400`
- **Write value:** `0x02`
- **Wait/Poll:** Wait 10ms after write
- **Rationale:** Assert PLL reset to clear ADF5355 state before configuration

### Step 6 — PLL & Clock Init
- **Register:** `PLL_LO_CTRL` at `0x0400`
- **Write value:** `0x00`
- **Wait/Poll:** Wait 1ms after deassert
- **Rationale:** Release PLL reset - allow ADF5355 to initialize

### Step 7 — PLL & Clock Init
- **Register:** `PLL_INT_DIV` at `0x0402`
- **Write value:** `0x2710`
- **Wait/Poll:** None
- **Rationale:** Set integer N divider = 10000 for LO frequency synthesis (adjusts VCO output)

### Step 8 — PLL & Clock Init
- **Register:** `PLL_FRAC_DIV` at `0x0403`
- **Write value:** `0x8000`
- **Wait/Poll:** None
- **Rationale:** Set fractional divider to 0.5 for fine frequency resolution (ADF5355 24-bit frac)

### Step 9 — PLL & Clock Init
- **Register:** `PLL_REF_DIV` at `0x0404`
- **Write value:** `0x0001`
- **Wait/Poll:** None
- **Rationale:** Set R divider = 1 (10MHz reference input /1 = 10MHz PFD freq)

### Step 10 — PLL & Clock Init
- **Register:** `PLL_LO_CTRL` at `0x0400`
- **Write value:** `0x01`
- **Wait/Poll:** Poll PLL_LO_STATUS[LOCKED]==1 (timeout 100ms)
- **Rationale:** Enable ADF5355 PLL and wait for lock detect - LO frequency must be stable before RF chain enable

### Step 11 — PLL & Clock Init
- **Register:** `CLK_ENABLE` at `0x0410`
- **Write value:** `0x0F`
- **Wait/Poll:** None
- **Rationale:** Enable all clock outputs: ADC sampling clock, FPGA system clock, JESD204B ref clock, RF front-end clock

### Step 12 — Peripheral Enable
- **Register:** `SPI_PLL_CTRL` at `0x0108`
- **Write value:** `0x13`
- **Wait/Poll:** None
- **Rationale:** Enable SPI interface for ADF5355 with CLK_DIV=3 (div16) for reliable 4-wire SPI communication

### Step 13 — Peripheral Enable
- **Register:** `I2C_CTRL` at `0x010B`
- **Write value:** `0x05`
- **Wait/Poll:** None
- **Rationale:** Enable I2C interface at 400kHz fast-mode for ADC12DJ3200 configuration and PMIC monitoring

### Step 14 — Peripheral Enable
- **Register:** `ADC_CTRL` at `0x0220`
- **Write value:** `0x03`
- **Wait/Poll:** None
- **Rationale:** Enable ADC monitoring in continuous mode - start auto-scan of all supply rails

### Step 15 — Communication Init
- **Register:** `UART_BAUD_DIV` at `0x0100`
- **Write value:** `0x0082`
- **Wait/Poll:** None
- **Rationale:** Configure UART baud divisor for 115200 baud @ 100MHz UART_CLK (standard debug rate)

### Step 16 — Communication Init
- **Register:** `UART_CTRL` at `0x0101`
- **Write value:** `0x01`
- **Wait/Poll:** None
- **Rationale:** Enable UART transmitter and receiver for command interface and debug output

### Step 17 — RF Chain Init
- **Register:** `JESD_CTRL` at `0x0500`
- **Write value:** `0x17`
- **Wait/Poll:** None
- **Rationale:** Enable JESD204B link: enable lanes 0&1, subclass 1, prepare for ADC12DJ3200 data

### Step 18 — RF Chain Init
- **Register:** `JESD_SCR_L` at `0x0502`
- **Write value:** `0xAA`
- **Wait/Poll:** None
- **Rationale:** Configure JESD204B scrambling seed low byte (0xAA) for deterministic data pattern

### Step 19 — RF Chain Init
- **Register:** `JESD_SCR_H` at `0x0503`
- **Write value:** `0x55`
- **Wait/Poll:** None
- **Rationale:** Configure JESD204B scrambling seed high byte (0x55) - complements low byte

### Step 20 — RF Chain Init
- **Register:** `JESD_CTRL` at `0x0500`
- **Write value:** `0x97`
- **Wait/Poll:** Poll JESD_STATUS[LINK_READY]==1 (timeout 200ms)
- **Rationale:** Assert SYNC~ to initiate JESD204B code group synchronization with ADC12DJ3200

### Step 21 — RF Chain Init
- **Register:** `VGA_GAIN_CTRL` at `0x0600`
- **Write value:** `0x8020`
- **Wait/Poll:** Poll VGA_STATUS[GAIN_LOADED]==1
- **Rationale:** Set HMC698LP4 VGA to mid-gain (32/63) and assert LE to load gain value into parallel interface

### Step 22 — RF Chain Init
- **Register:** `LNA_CTRL` at `0x0608`
- **Write value:** `0x01`
- **Wait/Poll:** None
- **Rationale:** Enable HMC6987LP4E LNA in high-gain mode - first stage of RF chain

### Step 23 — RF Chain Init
- **Register:** `MIXER_CTRL` at `0x0609`
- **Write value:** `0x07`
- **Wait/Poll:** None
- **Rationale:** Enable HMC1194LP4E mixer with all ports enabled (IF, LO, RF) for downconversion

### Step 24 — Application Init
- **Register:** `TEMP_ALERT_HIGH` at `0x0308`
- **Write value:** `0x8190`
- **Wait/Poll:** None
- **Rationale:** Set over-temperature alert threshold to 100°C (0x0190) and enable alert (bit 15)

### Step 25 — Application Init
- **Register:** `TEMP_ALERT_LOW` at `0x0309`
- **Write value:** `0x8F9C`
- **Wait/Poll:** None
- **Rationale:** Set under-temperature alert threshold to -25°C (signed 0xFF9C) and enable alert (bit 15)

### Step 26 — Application Init
- **Register:** `RF_FREQ_TARGET_L` at `0x0701`
- **Write value:** `0x4B00`
- **Wait/Poll:** None
- **Rationale:** Set target RF frequency low word - 19.2GHz lower bits (example LO frequency)

### Step 27 — Application Init
- **Register:** `RF_FREQ_TARGET_H` at `0x0702`
- **Write value:** `0x0000`
- **Wait/Poll:** None
- **Rationale:** Set target RF frequency high word - configure for 5-18GHz receive range

### Step 28 — Application Init
- **Register:** `RF_IF_FREQ` at `0x0703`
- **Write value:** `0x01F4`
- **Wait/Poll:** None
- **Rationale:** Set IF frequency to 500MHz for optimal ADC12DJ3200 performance

### Step 29 — Application Init
- **Register:** `RF_RX_CTRL` at `0x0700`
- **Write value:** `0x09`
- **Wait/Poll:** Poll RF_STATUS[RF_LOCKED]==1 and RF_STATUS[AGC_SETTLED]==1
- **Rationale:** Enable RF receiver chain with AGC - LNA, Mixer, VGA now active, wait for LO lock and AGC settle

### Step 30 — Application Init
- **Register:** `HEALTH_STATUS` at `0x030F`
- **Write value:** `0x0000`
- **Wait/Poll:** Verify SYSTEM_OK==1 (all status bits pass)
- **Rationale:** Final health check - confirm temperature OK, voltages OK, PLL locked, JESD synced before entering operational mode

### Step 31 — EEPROM Init
- **Register:** `I2C_SLAVE_ADDR` at `0x010C`
- **Write value:** `0x50`
- **Wait/Poll:** None
- **Rationale:** Set I2C slave address to EEPROM (0x50 is standard for CAT24C256) for calibration data read

### Step 32 — EEPROM Init
- **Register:** `EEPROM_ADDR` at `0x0801`
- **Write value:** `0x0000`
- **Wait/Poll:** None
- **Rationale:** Set EEPROM address to 0x0000 - start of calibration data block

### Step 33 — EEPROM Init
- **Register:** `EEPROM_CTRL` at `0x0800`
- **Write value:** `0x01`
- **Wait/Poll:** Poll EEPROM_CTRL[BUSY]==0
- **Rationale:** Trigger EEPROM read of calibration data - wait for read cycle complete

### Step 34 — EEPROM Init
- **Register:** `EEPROM_DATA` at `0x0802`
- **Write value:** `0x0000`
- **Wait/Poll:** Read calibration data word
- **Rationale:** Retrieve first calibration word - contains LNA gain trim value (store in internal register)

### Step 35 — Flash Init
- **Register:** `FLASH_ADDR_L` at `0x0901`
- **Write value:** `0x0000`
- **Wait/Poll:** None
- **Rationale:** Set Quad-SPI Flash address to 0x000000 for ID read

### Step 36 — Flash Init
- **Register:** `FLASH_CTRL` at `0x0900`
- **Write value:** `0x01`
- **Wait/Poll:** Poll FLASH_CTRL[BUSY]==0 then FLASH_STATUS[READY]==1
- **Rationale:** Issue flash read command to verify flash ID and bitstream presence

### Step 37 — Operational Ready
- **Register:** `UART_STATUS` at `0x0102`
- **Write value:** `0x0000`
- **Wait/Poll:** Check FRAME_ERR==0 and OVERRUN_ERR==0
- **Rationale:** Verify UART interface is clean - ready for command processing and telemetry output
