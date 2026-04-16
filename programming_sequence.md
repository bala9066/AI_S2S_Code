# Programming Sequence (PSQ)
## ehg

> **Total steps:** 20

| # | Phase | Register | Address | Value | Condition | Rationale |
|---|-------|----------|---------|-------|-----------|-----------|
| 1 | Power-On Reset & Self-Check | `SCRATCHPAD` | `0x0003` | `0xA5A5` | — | Write 0xA5A5 to SCRATCHPAD register to verify MCU RAM and internal bus integrity. This is the first sanity check after power-on reset to ensure the glue logic MCU is functional. |
| 2 | Power-On Reset & Self-Check | `SCRATCHPAD` | `0x0003` | `READ_VERIFY` | Read back and verify == 0xA5A5 | Read back SCRATCHPAD and verify the value matches. If incorrect, indicates RAM or bus fault - halt initialization and set fault indicator. |
| 3 | Power-On Reset & Self-Check | `BOARD_ID` | `0x0000` | `READ_VERIFY` | Verify == 0xE410 (expected EHG board ID) | Read BOARD_ID register and verify against expected value 0xE410. Confirms correct firmware is running on the expected hardware variant. |
| 4 | Power-On Reset & Self-Check | `HEALTH_STATUS` | `0x0711` | `POLL_VOLT_OK` | Poll until VOLT_OK (bit 1) = 1, timeout 500ms | Wait for power supply rails (+5V, +3.3V, +15V) to stabilize and be within tolerance. The DC-DC converter and LDOs need time to settle before enabling peripherals. |
| 5 | PLL & Clock Init | `CLK_GEN_CTRL` | `0x0500` | `0x01` | — | Enable the Si5345B-D clock generator via I2C. This activates the PLL and starts generating output clocks for the ADC and system. |
| 6 | PLL & Clock Init | `CLK_GEN_STATUS` | `0x0501` | `POLL_LOCK` | Poll until PLL_LOCK (bit 0) = 1, timeout 200ms | Wait for the clock generator PLL to achieve lock. The EV10AQ190A ADC requires a stable, phase-locked clock for proper sampling. |
| 7 | PLL & Clock Init | `CLK_BUF_ENABLE` | `0x0502` | `0x0F` | — | Enable all clock buffer outputs (ADCLK914). Bit 0 enables CLK_ADC to the EV10AQ190A, bit 1 enables CLK_SYS to the MCU and other logic. |
| 8 | Peripheral Enable | `ADC_PSU_CTRL` | `0x0700` | `0x03` | — | Enable power supply monitoring ADC in continuous mode. This allows periodic sampling of voltage and current rails for health monitoring. |
| 9 | Peripheral Enable | `TEMP_ALERT_HIGH` | `0x0408` | `0x0190` | — | Configure high temperature alert threshold to 100°C (0x0190). Triggers fault if RF front-end or MCU exceeds safe operating temperature. |
| 10 | Peripheral Enable | `TEMP_ALERT_LOW` | `0x0409` | `0xFF9C` | — | Configure low temperature alert threshold to -25°C (0xFF9C). Ensures system is within operating temperature range before activation. |
| 11 | Communication Init | `UART_BAUD_DIV` | `0x0100` | `0x0016` | — | Set UART baud rate divisor to 22 (0x0016) for 115200 baud operation at 168MHz PCLK. This is the default communication rate for host interface. |
| 12 | Communication Init | `UART_CTRL` | `0x0101` | `0x01` | — | Enable UART interface. Set ENABLE bit to 1 with standard frame format (8N1). Host can now send register read/write commands. |
| 13 | Application Init | `EEPROM_CTRL` | `0x0600` | `0x01` | Poll BUSY bit clear, then read calibration data | Read calibration data from M24M02-DR EEPROM. Calibration includes VGA gain correction factors, ADC offset correction values, and frequency response corrections. |
| 14 | Application Init | `RF_VGA_GAIN` | `0x0201` | `0x0F` | Wait for SPI_BUSY (bit 15) to clear | Set RF VGA (HMC698LP4) to mid-range gain (15 = ~15dB). The gain is set via SPI to the HMC698LP4. Wait for SPI transaction to complete. |
| 15 | Application Init | `RF_LNA_CTRL` | `0x0200` | `0x01` | Wait for POWER_GOOD (bit 4) = 1 | Enable the RF LNA (HMC8141). This is the first active component in the RF chain. Verify POWER_GOOD indicates the LNA is operational. |
| 16 | Application Init | `RF_MIXER_CTRL` | `0x0202` | `0x01` | — | Enable the RF mixer (HMC-CMS19). The mixer downconverts the 5-18 GHz RF signal to IF for digitization. LO input should be present from external source. |
| 17 | Application Init | `RF_IF_AMP_CTRL` | `0x0203` | `0x01` | — | Enable the IF amplifier (HMC5805) in low gain mode. This amplifies the IF signal before it reaches the ADC. |
| 18 | Application Init | `ADC_HS_CTRL` | `0x0300` | `0x09` | Poll ADC_HS_STATUS until READY (bit 0) = 1 | Enable high-speed ADC (EV10AQ190A) in single-channel mode with output clock enabled. Wait for ADC to indicate ready for conversion. |
| 19 | Application Init | `LED_CTRL` | `0x0800` | `0x05` | — | Set status LED to heartbeat mode (LED_MODE = 01). Visual indication that the EHG receiver is initialized and operational. |
| 20 | Ready State | `HEALTH_STATUS` | `0x0711` | `VERIFY_SYSTEM_OK` | Verify SYSTEM_OK (bit 7) = 1, else fault | Final health check - verify all subsystems are OK. SYSTEM_OK bit is the logical AND of TEMP_OK, VOLT_OK, and CLK_LOCK. If 1, system is ready for RF signal capture. |

---

## Detailed Steps

### Step 1 — Power-On Reset & Self-Check
- **Register:** `SCRATCHPAD` at `0x0003`
- **Write value:** `0xA5A5`
- **Rationale:** Write 0xA5A5 to SCRATCHPAD register to verify MCU RAM and internal bus integrity. This is the first sanity check after power-on reset to ensure the glue logic MCU is functional.

### Step 2 — Power-On Reset & Self-Check
- **Register:** `SCRATCHPAD` at `0x0003`
- **Write value:** `READ_VERIFY`
- **Wait/Poll:** Read back and verify == 0xA5A5
- **Rationale:** Read back SCRATCHPAD and verify the value matches. If incorrect, indicates RAM or bus fault - halt initialization and set fault indicator.

### Step 3 — Power-On Reset & Self-Check
- **Register:** `BOARD_ID` at `0x0000`
- **Write value:** `READ_VERIFY`
- **Wait/Poll:** Verify == 0xE410 (expected EHG board ID)
- **Rationale:** Read BOARD_ID register and verify against expected value 0xE410. Confirms correct firmware is running on the expected hardware variant.

### Step 4 — Power-On Reset & Self-Check
- **Register:** `HEALTH_STATUS` at `0x0711`
- **Write value:** `POLL_VOLT_OK`
- **Wait/Poll:** Poll until VOLT_OK (bit 1) = 1, timeout 500ms
- **Rationale:** Wait for power supply rails (+5V, +3.3V, +15V) to stabilize and be within tolerance. The DC-DC converter and LDOs need time to settle before enabling peripherals.

### Step 5 — PLL & Clock Init
- **Register:** `CLK_GEN_CTRL` at `0x0500`
- **Write value:** `0x01`
- **Rationale:** Enable the Si5345B-D clock generator via I2C. This activates the PLL and starts generating output clocks for the ADC and system.

### Step 6 — PLL & Clock Init
- **Register:** `CLK_GEN_STATUS` at `0x0501`
- **Write value:** `POLL_LOCK`
- **Wait/Poll:** Poll until PLL_LOCK (bit 0) = 1, timeout 200ms
- **Rationale:** Wait for the clock generator PLL to achieve lock. The EV10AQ190A ADC requires a stable, phase-locked clock for proper sampling.

### Step 7 — PLL & Clock Init
- **Register:** `CLK_BUF_ENABLE` at `0x0502`
- **Write value:** `0x0F`
- **Rationale:** Enable all clock buffer outputs (ADCLK914). Bit 0 enables CLK_ADC to the EV10AQ190A, bit 1 enables CLK_SYS to the MCU and other logic.

### Step 8 — Peripheral Enable
- **Register:** `ADC_PSU_CTRL` at `0x0700`
- **Write value:** `0x03`
- **Rationale:** Enable power supply monitoring ADC in continuous mode. This allows periodic sampling of voltage and current rails for health monitoring.

### Step 9 — Peripheral Enable
- **Register:** `TEMP_ALERT_HIGH` at `0x0408`
- **Write value:** `0x0190`
- **Rationale:** Configure high temperature alert threshold to 100°C (0x0190). Triggers fault if RF front-end or MCU exceeds safe operating temperature.

### Step 10 — Peripheral Enable
- **Register:** `TEMP_ALERT_LOW` at `0x0409`
- **Write value:** `0xFF9C`
- **Rationale:** Configure low temperature alert threshold to -25°C (0xFF9C). Ensures system is within operating temperature range before activation.

### Step 11 — Communication Init
- **Register:** `UART_BAUD_DIV` at `0x0100`
- **Write value:** `0x0016`
- **Rationale:** Set UART baud rate divisor to 22 (0x0016) for 115200 baud operation at 168MHz PCLK. This is the default communication rate for host interface.

### Step 12 — Communication Init
- **Register:** `UART_CTRL` at `0x0101`
- **Write value:** `0x01`
- **Rationale:** Enable UART interface. Set ENABLE bit to 1 with standard frame format (8N1). Host can now send register read/write commands.

### Step 13 — Application Init
- **Register:** `EEPROM_CTRL` at `0x0600`
- **Write value:** `0x01`
- **Wait/Poll:** Poll BUSY bit clear, then read calibration data
- **Rationale:** Read calibration data from M24M02-DR EEPROM. Calibration includes VGA gain correction factors, ADC offset correction values, and frequency response corrections.

### Step 14 — Application Init
- **Register:** `RF_VGA_GAIN` at `0x0201`
- **Write value:** `0x0F`
- **Wait/Poll:** Wait for SPI_BUSY (bit 15) to clear
- **Rationale:** Set RF VGA (HMC698LP4) to mid-range gain (15 = ~15dB). The gain is set via SPI to the HMC698LP4. Wait for SPI transaction to complete.

### Step 15 — Application Init
- **Register:** `RF_LNA_CTRL` at `0x0200`
- **Write value:** `0x01`
- **Wait/Poll:** Wait for POWER_GOOD (bit 4) = 1
- **Rationale:** Enable the RF LNA (HMC8141). This is the first active component in the RF chain. Verify POWER_GOOD indicates the LNA is operational.

### Step 16 — Application Init
- **Register:** `RF_MIXER_CTRL` at `0x0202`
- **Write value:** `0x01`
- **Rationale:** Enable the RF mixer (HMC-CMS19). The mixer downconverts the 5-18 GHz RF signal to IF for digitization. LO input should be present from external source.

### Step 17 — Application Init
- **Register:** `RF_IF_AMP_CTRL` at `0x0203`
- **Write value:** `0x01`
- **Rationale:** Enable the IF amplifier (HMC5805) in low gain mode. This amplifies the IF signal before it reaches the ADC.

### Step 18 — Application Init
- **Register:** `ADC_HS_CTRL` at `0x0300`
- **Write value:** `0x09`
- **Wait/Poll:** Poll ADC_HS_STATUS until READY (bit 0) = 1
- **Rationale:** Enable high-speed ADC (EV10AQ190A) in single-channel mode with output clock enabled. Wait for ADC to indicate ready for conversion.

### Step 19 — Application Init
- **Register:** `LED_CTRL` at `0x0800`
- **Write value:** `0x05`
- **Rationale:** Set status LED to heartbeat mode (LED_MODE = 01). Visual indication that the EHG receiver is initialized and operational.

### Step 20 — Ready State
- **Register:** `HEALTH_STATUS` at `0x0711`
- **Write value:** `VERIFY_SYSTEM_OK`
- **Wait/Poll:** Verify SYSTEM_OK (bit 7) = 1, else fault
- **Rationale:** Final health check - verify all subsystems are OK. SYSTEM_OK bit is the logical AND of TEMP_OK, VOLT_OK, and CLK_LOCK. If 1, system is ready for RF signal capture.
