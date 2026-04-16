# Programming Sequence (PSQ)
## sample

> **Total steps:** 30

| # | Phase | Register | Address | Value | Condition | Rationale |
|---|-------|----------|---------|-------|-----------|-----------|
| 1 | Power-On Reset & Self-Check | `SCRATCHPAD` | `0x0003` | `0xA5A5` | — | Perform memory integrity check by writing known pattern (0xA5A5) to scratchpad register and verifying readback validates UART and register interface functionality. |
| 2 | Power-On Reset & Self-Check | `SCRATCHPAD` | `0x0003` | `0x0000` | Read verify = 0xA5A5 before writing 0x0000 | Verify write by reading back 0xA5A5, then write alternating pattern (0x0000) to complete RAM integrity test before clearing register. |
| 3 | Power-On Reset & Self-Check | `BOARD_ID` | `0x0000` | `N/A (read)` | Verify read = 0x534D | Read board ID register and verify value 0x534D (ASCII 'SM') confirms correct FPGA bitstream loaded for sample project. |
| 4 | Power-On Reset & Self-Check | `HEALTH_STATUS` | `0x030F` | `N/A (poll)` | Poll until VOLT_OK=1 (bit 1 set), timeout 5 sec | Wait for power rails to stabilize within specified tolerance before enabling peripherals; ensures safe operation and prevents brownout conditions. |
| 5 | PLL & Clock Init | `PLL_CTRL` | `0x0400` | `0x0002` | — | Assert PLL reset (bit 1) to clear any previous state before configuration; ensures clean startup of HMC7044 clock synthesizer. |
| 6 | PLL & Clock Init | `PLL_N_DIV` | `0x0402` | `0x0040` | — | Configure PLL N divider to 64 for target LO frequency synthesis (determined by application frequency requirements). |
| 7 | PLL & Clock Init | `PLL_R_DIV` | `0x0403` | `0x0001` | — | Configure PLL R divider to 1 for reference clock division; completes PLL frequency planning. |
| 8 | PLL & Clock Init | `PLL_CTRL` | `0x0400` | `0x0001` | — | Release PLL reset (bit 1 = 0) and enable PLL (bit 0 = 1) to start lock acquisition process. |
| 9 | PLL & Clock Init | `PLL_STATUS` | `0x0401` | `N/A (poll)` | Poll until LOCKED=1 (bit 0 set), timeout 100 ms | Wait for PLL lock confirmation before enabling clock outputs; ensures stable clock distribution to ADC, FPGA, and RF mixer. |
| 10 | PLL & Clock Init | `CLK_ENABLE` | `0x0410` | `0x000F` | — | Enable all critical clock outputs: ADC sampling clock, mixer LO, FPGA reference, and SYNC output for JESD204 link. |
| 11 | Peripheral Enable | `TEMP_ALERT_HIGH` | `0x0308` | `0x8190` | — | Set over-temperature alert threshold to 100°C (0x190) and enable alert function (bit 15) for thermal protection. |
| 12 | Peripheral Enable | `TEMP_ALERT_LOW` | `0x0309` | `0x8F9C` | — | Set under-temperature alert threshold to -25°C (signed 0xFF9C) and enable alert function for cold protection. |
| 13 | Communication Init | `UART_BAUD_DIV` | `0x0100` | `0x0068` | — | Configure UART baud rate divisor for 115200 baud operation assuming 25MHz reference (0x0068 = 104 decimal). |
| 14 | Communication Init | `UART_CTRL` | `0x0101` | `0x13` | — | Enable UART (bit 0), set 8N1 frame format (bits 7:4 = 0x3), and prepare for host communication. |
| 15 | Communication Init | `UART_STATUS` | `0x0102` | `N/A (read)` | Verify TX_BUSY=0, no errors | Check UART status for error-free operation before declaring communication interface ready. |
| 16 | Application Init | `RF_LNA_CTRL` | `0x0700` | `0x01` | — | Enable RF LNA (HMC1134) power with high gain mode; activates RF signal path from input connector. |
| 17 | Application Init | `RF_SWITCH_CTRL` | `0x0701` | `0x05` | — | Configure RF SPDT switch (HMC1118) to path A and enable switch; routes LNA output through selected filter path. |
| 18 | Application Init | `RF_MIXER_CTRL` | `0x0702` | `0x01` | — | Enable RF mixer (HMC559) power; mixer will be driven by PLL-generated LO for downconversion. |
| 19 | Application Init | `RF_LO_FREQ` | `0x0703` | `0x1000` | — | Set LO frequency control word for desired downconversion frequency (value depends on target IF; example provided). |
| 20 | Application Init | `VGA_GAIN_CTRL` | `0x0708` | `0x0200` | — | Set IF VGA (AD8376) to mid-range gain with slew limiting enabled; provides appropriate IF signal level to ADC. |
| 21 | Application Init | `ADC_JESD_CFG` | `0x0712` | `0x001C` | — | Configure AD9208 for 12-bit resolution (bits 6:4 = 2), 2.5 GSPS sample rate (bits 3:0 = 3), no decimation. |
| 22 | Application Init | `JESD_CTRL` | `0x0710` | `0x83` | — | Enable JESD204 link (bit 0) and all 8 lanes (bits 7:1), set Subclass 1 for deterministic latency. |
| 23 | Application Init | `JESD_STATUS` | `0x0711` | `N/A (poll)` | Poll until LINK_READY=1 and ALIGNMENT_DONE=1, timeout 1 sec | Wait for JESD204B link synchronization and lane alignment before data capture can begin. |
| 24 | Application Init | `ADC_CTRL` | `0x0200` | `0x03` | — | Enable continuous ADC monitoring (bit 1) for voltage and current rails via internal ADC channels. |
| 25 | Application Init | `AGC_CTRL` | `0x0900` | `0x11` | — | Enable automatic gain control loop (bit 0) with default target level and attack rate for optimal ADC headroom. |
| 26 | Application Init | `EEPROM_CTRL` | `0x0500` | `0x01` | Poll BUSY=0 after operation | Initiate EEPROM read of calibration data; calibration constants are stored in non-volatile memory. |
| 27 | Application Init | `EEPROM_ADDR` | `0x0501` | `0x0000` | Set before EEPROM read | Set EEPROM start address to 0x0000 for calibration data base location. |
| 28 | Application Init | `CAL_DATA` | `0x0902` | `0x11` | Write after EEPROM read completes | Mark calibration data as valid (bit 0) and set version after successful load from EEPROM. |
| 29 | Final Verification | `HEALTH_STATUS` | `0x030F` | `N/A (read)` | Verify SYSTEM_OK=1 (all bits 0-6 set) | Final health check confirming temperature OK, voltages OK, PLL locked, JESD link established before entering operational mode. |
| 30 | Final Verification | `GPIO_DIR` | `0x0800` | `0xFFFF` | — | Configure all GPIO pins as outputs for status LED control (application-specific final configuration). |

---

## Detailed Steps

### Step 1 — Power-On Reset & Self-Check
- **Register:** `SCRATCHPAD` at `0x0003`
- **Write value:** `0xA5A5`
- **Rationale:** Perform memory integrity check by writing known pattern (0xA5A5) to scratchpad register and verifying readback validates UART and register interface functionality.

### Step 2 — Power-On Reset & Self-Check
- **Register:** `SCRATCHPAD` at `0x0003`
- **Write value:** `0x0000`
- **Wait/Poll:** Read verify = 0xA5A5 before writing 0x0000
- **Rationale:** Verify write by reading back 0xA5A5, then write alternating pattern (0x0000) to complete RAM integrity test before clearing register.

### Step 3 — Power-On Reset & Self-Check
- **Register:** `BOARD_ID` at `0x0000`
- **Write value:** `N/A (read)`
- **Wait/Poll:** Verify read = 0x534D
- **Rationale:** Read board ID register and verify value 0x534D (ASCII 'SM') confirms correct FPGA bitstream loaded for sample project.

### Step 4 — Power-On Reset & Self-Check
- **Register:** `HEALTH_STATUS` at `0x030F`
- **Write value:** `N/A (poll)`
- **Wait/Poll:** Poll until VOLT_OK=1 (bit 1 set), timeout 5 sec
- **Rationale:** Wait for power rails to stabilize within specified tolerance before enabling peripherals; ensures safe operation and prevents brownout conditions.

### Step 5 — PLL & Clock Init
- **Register:** `PLL_CTRL` at `0x0400`
- **Write value:** `0x0002`
- **Rationale:** Assert PLL reset (bit 1) to clear any previous state before configuration; ensures clean startup of HMC7044 clock synthesizer.

### Step 6 — PLL & Clock Init
- **Register:** `PLL_N_DIV` at `0x0402`
- **Write value:** `0x0040`
- **Rationale:** Configure PLL N divider to 64 for target LO frequency synthesis (determined by application frequency requirements).

### Step 7 — PLL & Clock Init
- **Register:** `PLL_R_DIV` at `0x0403`
- **Write value:** `0x0001`
- **Rationale:** Configure PLL R divider to 1 for reference clock division; completes PLL frequency planning.

### Step 8 — PLL & Clock Init
- **Register:** `PLL_CTRL` at `0x0400`
- **Write value:** `0x0001`
- **Rationale:** Release PLL reset (bit 1 = 0) and enable PLL (bit 0 = 1) to start lock acquisition process.

### Step 9 — PLL & Clock Init
- **Register:** `PLL_STATUS` at `0x0401`
- **Write value:** `N/A (poll)`
- **Wait/Poll:** Poll until LOCKED=1 (bit 0 set), timeout 100 ms
- **Rationale:** Wait for PLL lock confirmation before enabling clock outputs; ensures stable clock distribution to ADC, FPGA, and RF mixer.

### Step 10 — PLL & Clock Init
- **Register:** `CLK_ENABLE` at `0x0410`
- **Write value:** `0x000F`
- **Rationale:** Enable all critical clock outputs: ADC sampling clock, mixer LO, FPGA reference, and SYNC output for JESD204 link.

### Step 11 — Peripheral Enable
- **Register:** `TEMP_ALERT_HIGH` at `0x0308`
- **Write value:** `0x8190`
- **Rationale:** Set over-temperature alert threshold to 100°C (0x190) and enable alert function (bit 15) for thermal protection.

### Step 12 — Peripheral Enable
- **Register:** `TEMP_ALERT_LOW` at `0x0309`
- **Write value:** `0x8F9C`
- **Rationale:** Set under-temperature alert threshold to -25°C (signed 0xFF9C) and enable alert function for cold protection.

### Step 13 — Communication Init
- **Register:** `UART_BAUD_DIV` at `0x0100`
- **Write value:** `0x0068`
- **Rationale:** Configure UART baud rate divisor for 115200 baud operation assuming 25MHz reference (0x0068 = 104 decimal).

### Step 14 — Communication Init
- **Register:** `UART_CTRL` at `0x0101`
- **Write value:** `0x13`
- **Rationale:** Enable UART (bit 0), set 8N1 frame format (bits 7:4 = 0x3), and prepare for host communication.

### Step 15 — Communication Init
- **Register:** `UART_STATUS` at `0x0102`
- **Write value:** `N/A (read)`
- **Wait/Poll:** Verify TX_BUSY=0, no errors
- **Rationale:** Check UART status for error-free operation before declaring communication interface ready.

### Step 16 — Application Init
- **Register:** `RF_LNA_CTRL` at `0x0700`
- **Write value:** `0x01`
- **Rationale:** Enable RF LNA (HMC1134) power with high gain mode; activates RF signal path from input connector.

### Step 17 — Application Init
- **Register:** `RF_SWITCH_CTRL` at `0x0701`
- **Write value:** `0x05`
- **Rationale:** Configure RF SPDT switch (HMC1118) to path A and enable switch; routes LNA output through selected filter path.

### Step 18 — Application Init
- **Register:** `RF_MIXER_CTRL` at `0x0702`
- **Write value:** `0x01`
- **Rationale:** Enable RF mixer (HMC559) power; mixer will be driven by PLL-generated LO for downconversion.

### Step 19 — Application Init
- **Register:** `RF_LO_FREQ` at `0x0703`
- **Write value:** `0x1000`
- **Rationale:** Set LO frequency control word for desired downconversion frequency (value depends on target IF; example provided).

### Step 20 — Application Init
- **Register:** `VGA_GAIN_CTRL` at `0x0708`
- **Write value:** `0x0200`
- **Rationale:** Set IF VGA (AD8376) to mid-range gain with slew limiting enabled; provides appropriate IF signal level to ADC.

### Step 21 — Application Init
- **Register:** `ADC_JESD_CFG` at `0x0712`
- **Write value:** `0x001C`
- **Rationale:** Configure AD9208 for 12-bit resolution (bits 6:4 = 2), 2.5 GSPS sample rate (bits 3:0 = 3), no decimation.

### Step 22 — Application Init
- **Register:** `JESD_CTRL` at `0x0710`
- **Write value:** `0x83`
- **Rationale:** Enable JESD204 link (bit 0) and all 8 lanes (bits 7:1), set Subclass 1 for deterministic latency.

### Step 23 — Application Init
- **Register:** `JESD_STATUS` at `0x0711`
- **Write value:** `N/A (poll)`
- **Wait/Poll:** Poll until LINK_READY=1 and ALIGNMENT_DONE=1, timeout 1 sec
- **Rationale:** Wait for JESD204B link synchronization and lane alignment before data capture can begin.

### Step 24 — Application Init
- **Register:** `ADC_CTRL` at `0x0200`
- **Write value:** `0x03`
- **Rationale:** Enable continuous ADC monitoring (bit 1) for voltage and current rails via internal ADC channels.

### Step 25 — Application Init
- **Register:** `AGC_CTRL` at `0x0900`
- **Write value:** `0x11`
- **Rationale:** Enable automatic gain control loop (bit 0) with default target level and attack rate for optimal ADC headroom.

### Step 26 — Application Init
- **Register:** `EEPROM_CTRL` at `0x0500`
- **Write value:** `0x01`
- **Wait/Poll:** Poll BUSY=0 after operation
- **Rationale:** Initiate EEPROM read of calibration data; calibration constants are stored in non-volatile memory.

### Step 27 — Application Init
- **Register:** `EEPROM_ADDR` at `0x0501`
- **Write value:** `0x0000`
- **Wait/Poll:** Set before EEPROM read
- **Rationale:** Set EEPROM start address to 0x0000 for calibration data base location.

### Step 28 — Application Init
- **Register:** `CAL_DATA` at `0x0902`
- **Write value:** `0x11`
- **Wait/Poll:** Write after EEPROM read completes
- **Rationale:** Mark calibration data as valid (bit 0) and set version after successful load from EEPROM.

### Step 29 — Final Verification
- **Register:** `HEALTH_STATUS` at `0x030F`
- **Write value:** `N/A (read)`
- **Wait/Poll:** Verify SYSTEM_OK=1 (all bits 0-6 set)
- **Rationale:** Final health check confirming temperature OK, voltages OK, PLL locked, JESD link established before entering operational mode.

### Step 30 — Final Verification
- **Register:** `GPIO_DIR` at `0x0800`
- **Write value:** `0xFFFF`
- **Rationale:** Configure all GPIO pins as outputs for status LED control (application-specific final configuration).
