# Programming Sequence (PSQ)
## kh

> **Total steps:** 20

| # | Phase | Register | Address | Value | Condition | Rationale |
|---|-------|----------|---------|-------|-----------|-----------|
| 1 | PHASE 1 - Power-On Reset & Self-Check | `SCRATCHPAD` | `0x0003` | `0xA5A5` | Read back verify = 0xA5A5 | Verify RAM/CPU connectivity by writing test pattern and reading back. Critical early self-test. |
| 2 | PHASE 1 - Power-On Reset & Self-Check | `SCRATCHPAD` | `0x0003` | `0x5A5A` | Read back verify = 0x5A5A | Second pattern verification to rule out stuck bits. Confirms bidirectional data path integrity. |
| 3 | PHASE 1 - Power-On Reset & Self-Check | `BOARD_ID` | `0x0000` | `0x0000` | Verify reading returns 0x4B48 | Confirm correct FPGA image loaded (KH board identifier). Read-only verification. |
| 4 | PHASE 1 - Power-On Reset & Self-Check | `HEALTH_STATUS` | `0x030F` | `0x0000` | Poll until bit[1] (VOLT_OK) = 1 | Wait for all power rails (5V, 3.3V, 1.8V, 1.2V) to stabilize via LTC2975 monitoring. |
| 5 | PHASE 2 - PLL & Clock Init | `PLL_CTRL` | `0x0400` | `0x0002` | Wait 10 us | Assert PLL reset to ensure clean startup state. LMK04828 requires reset for proper init. |
| 6 | PHASE 2 - PLL & Clock Init | `PLL_CTRL` | `0x0400` | `0x0001` | Poll PLL_STATUS[0] (LOCKED) = 1 | Enable PLL and wait for lock. LMK04828 generates clean clocks for JESD204B ADC and FPGA. |
| 7 | PHASE 2 - PLL & Clock Init | `CLK_ENABLE` | `0x0410` | `0x0007` | None | Enable ADC sample clock, FPGA fabric clock, and JESD204B lane clocks. All clocks required for operation. |
| 8 | PHASE 3 - Peripheral Enable | `RF_CTRL` | `0x0701` | `0x0007` | Poll RF_STATUS until bits[2:0] = 0x111 | Enable LNA (HMC1119), VGA (HMC698), and Mixer (HMC1051). RF chain must be on before signal path. |
| 9 | PHASE 3 - Peripheral Enable | `UART_CTRL` | `0x0101` | `0x0001` | None | Enable UART for command interface. Baud rate (115200) already configured by default. |
| 10 | PHASE 3 - Peripheral Enable | `TEMP_ALERT_HIGH` | `0x0308` | `0x0190` | None | Set over-temperature alert threshold to 100°C. Protects RF components and FPGA. |
| 11 | PHASE 4 - Communication Init | `JESD204B_CTRL` | `0x0420` | `0x0003` | Poll JESD204B_STATUS[0] (SYNC) = 1 | Enable and reset JESD204B link. ADC12DJ5200RF requires sync before data transfer. |
| 12 | PHASE 4 - Communication Init | `I2C_CTRL` | `0x0A00` | `0x0001` | None | Enable I2C master for communication with LTC2975 (power manager) and LMK04828 (clock generator). |
| 13 | PHASE 5 - Application Init | `RF_VGA_GAIN` | `0x0700` | `0x0020` | None | Set VGA to mid-scale gain (32 = ~15.5dB). Starting point for AGC optimization. |
| 14 | PHASE 5 - Application Init | `EEPROM_ADDR` | `0x0501` | `0x0000` | None | Set EEPROM address to read calibration data from start of memory. |
| 15 | PHASE 5 - Application Init | `EEPROM_CTRL` | `0x0500` | `0x0001` | Poll until EEPROM_CTRL[7] (BUSY) = 0 | Trigger EEPROM read to load factory calibration data for RF gain and offset correction. |
| 16 | PHASE 5 - Application Init | `FLASH_ADDR_LOW` | `0x0601` | `0x0000` | None | Prepare flash interface for configuration read. Verify flash ID (S25FL512S). |
| 17 | PHASE 5 - Application Init | `FLASH_ADDR_HIGH` | `0x0602` | `0x0000` | None | Set high byte of flash address for full 24-bit addressing. |
| 18 | PHASE 5 - Application Init | `FLASH_CTRL` | `0x0600` | `0x0001` | Poll until FLASH_CTRL[7] (BUSY) = 0 | Initiate flash read operation to verify configuration memory integrity. |
| 19 | PHASE 5 - Application Init | `AGC_CONFIG` | `0x0708` | `0x0088` | None | Enable AGC with target ADC level of 8 (mid-scale). AGC optimizes dynamic range. |
| 20 | PHASE 5 - Application Init | `HEALTH_STATUS` | `0x030F` | `0x0000` | Verify bit[7] (SYSTEM_OK) = 1 | Final health check. System must report overall OK after all initialization steps. |

---

## Detailed Steps

### Step 1 — PHASE 1 - Power-On Reset & Self-Check
- **Register:** `SCRATCHPAD` at `0x0003`
- **Write value:** `0xA5A5`
- **Wait/Poll:** Read back verify = 0xA5A5
- **Rationale:** Verify RAM/CPU connectivity by writing test pattern and reading back. Critical early self-test.

### Step 2 — PHASE 1 - Power-On Reset & Self-Check
- **Register:** `SCRATCHPAD` at `0x0003`
- **Write value:** `0x5A5A`
- **Wait/Poll:** Read back verify = 0x5A5A
- **Rationale:** Second pattern verification to rule out stuck bits. Confirms bidirectional data path integrity.

### Step 3 — PHASE 1 - Power-On Reset & Self-Check
- **Register:** `BOARD_ID` at `0x0000`
- **Write value:** `0x0000`
- **Wait/Poll:** Verify reading returns 0x4B48
- **Rationale:** Confirm correct FPGA image loaded (KH board identifier). Read-only verification.

### Step 4 — PHASE 1 - Power-On Reset & Self-Check
- **Register:** `HEALTH_STATUS` at `0x030F`
- **Write value:** `0x0000`
- **Wait/Poll:** Poll until bit[1] (VOLT_OK) = 1
- **Rationale:** Wait for all power rails (5V, 3.3V, 1.8V, 1.2V) to stabilize via LTC2975 monitoring.

### Step 5 — PHASE 2 - PLL & Clock Init
- **Register:** `PLL_CTRL` at `0x0400`
- **Write value:** `0x0002`
- **Wait/Poll:** Wait 10 us
- **Rationale:** Assert PLL reset to ensure clean startup state. LMK04828 requires reset for proper init.

### Step 6 — PHASE 2 - PLL & Clock Init
- **Register:** `PLL_CTRL` at `0x0400`
- **Write value:** `0x0001`
- **Wait/Poll:** Poll PLL_STATUS[0] (LOCKED) = 1
- **Rationale:** Enable PLL and wait for lock. LMK04828 generates clean clocks for JESD204B ADC and FPGA.

### Step 7 — PHASE 2 - PLL & Clock Init
- **Register:** `CLK_ENABLE` at `0x0410`
- **Write value:** `0x0007`
- **Wait/Poll:** None
- **Rationale:** Enable ADC sample clock, FPGA fabric clock, and JESD204B lane clocks. All clocks required for operation.

### Step 8 — PHASE 3 - Peripheral Enable
- **Register:** `RF_CTRL` at `0x0701`
- **Write value:** `0x0007`
- **Wait/Poll:** Poll RF_STATUS until bits[2:0] = 0x111
- **Rationale:** Enable LNA (HMC1119), VGA (HMC698), and Mixer (HMC1051). RF chain must be on before signal path.

### Step 9 — PHASE 3 - Peripheral Enable
- **Register:** `UART_CTRL` at `0x0101`
- **Write value:** `0x0001`
- **Wait/Poll:** None
- **Rationale:** Enable UART for command interface. Baud rate (115200) already configured by default.

### Step 10 — PHASE 3 - Peripheral Enable
- **Register:** `TEMP_ALERT_HIGH` at `0x0308`
- **Write value:** `0x0190`
- **Wait/Poll:** None
- **Rationale:** Set over-temperature alert threshold to 100°C. Protects RF components and FPGA.

### Step 11 — PHASE 4 - Communication Init
- **Register:** `JESD204B_CTRL` at `0x0420`
- **Write value:** `0x0003`
- **Wait/Poll:** Poll JESD204B_STATUS[0] (SYNC) = 1
- **Rationale:** Enable and reset JESD204B link. ADC12DJ5200RF requires sync before data transfer.

### Step 12 — PHASE 4 - Communication Init
- **Register:** `I2C_CTRL` at `0x0A00`
- **Write value:** `0x0001`
- **Wait/Poll:** None
- **Rationale:** Enable I2C master for communication with LTC2975 (power manager) and LMK04828 (clock generator).

### Step 13 — PHASE 5 - Application Init
- **Register:** `RF_VGA_GAIN` at `0x0700`
- **Write value:** `0x0020`
- **Wait/Poll:** None
- **Rationale:** Set VGA to mid-scale gain (32 = ~15.5dB). Starting point for AGC optimization.

### Step 14 — PHASE 5 - Application Init
- **Register:** `EEPROM_ADDR` at `0x0501`
- **Write value:** `0x0000`
- **Wait/Poll:** None
- **Rationale:** Set EEPROM address to read calibration data from start of memory.

### Step 15 — PHASE 5 - Application Init
- **Register:** `EEPROM_CTRL` at `0x0500`
- **Write value:** `0x0001`
- **Wait/Poll:** Poll until EEPROM_CTRL[7] (BUSY) = 0
- **Rationale:** Trigger EEPROM read to load factory calibration data for RF gain and offset correction.

### Step 16 — PHASE 5 - Application Init
- **Register:** `FLASH_ADDR_LOW` at `0x0601`
- **Write value:** `0x0000`
- **Wait/Poll:** None
- **Rationale:** Prepare flash interface for configuration read. Verify flash ID (S25FL512S).

### Step 17 — PHASE 5 - Application Init
- **Register:** `FLASH_ADDR_HIGH` at `0x0602`
- **Write value:** `0x0000`
- **Wait/Poll:** None
- **Rationale:** Set high byte of flash address for full 24-bit addressing.

### Step 18 — PHASE 5 - Application Init
- **Register:** `FLASH_CTRL` at `0x0600`
- **Write value:** `0x0001`
- **Wait/Poll:** Poll until FLASH_CTRL[7] (BUSY) = 0
- **Rationale:** Initiate flash read operation to verify configuration memory integrity.

### Step 19 — PHASE 5 - Application Init
- **Register:** `AGC_CONFIG` at `0x0708`
- **Write value:** `0x0088`
- **Wait/Poll:** None
- **Rationale:** Enable AGC with target ADC level of 8 (mid-scale). AGC optimizes dynamic range.

### Step 20 — PHASE 5 - Application Init
- **Register:** `HEALTH_STATUS` at `0x030F`
- **Write value:** `0x0000`
- **Wait/Poll:** Verify bit[7] (SYSTEM_OK) = 1
- **Rationale:** Final health check. System must report overall OK after all initialization steps.
