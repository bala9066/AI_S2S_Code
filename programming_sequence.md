# Programming Sequence (PSQ)
## hgyu

> **Total steps:** 30

| # | Phase | Register | Address | Value | Condition | Rationale |
|---|-------|----------|---------|-------|-----------|-----------|
| 1 | Power-On Reset & Self-Check | `SCRATCHPAD` | `0x0003` | `0xA5A5` | Read back and verify 0xA5A5 | Perform RAM diagnostic by writing known pattern to SCRATCHPAD and reading back to verify register access functionality |
| 2 | Power-On Reset & Self-Check | `SCRATCHPAD` | `0x0003` | `0x5A5A` | Read back and verify 0x5A5A | Second RAM check with inverted pattern to fully validate memory integrity before proceeding |
| 3 | Power-On Reset & Self-Check | `BOARD_ID` | `0x0000` | `READ` | Verify return value == 0x4847 ('HG') | Verify correct FPGA image is loaded by reading fixed board identifier code |
| 4 | Power-On Reset & Self-Check | `HEALTH_STATUS` | `0x030F` | `READ` | Poll until VOLT_OK (bit 1) == 1 | Wait for all power rails to stabilize before enabling any peripherals |
| 5 | Power Sequencing | `POWER_SEQ_CTRL` | `0x0900` | `0x01` | Wait for PG_5V (bit 0 of 0x0901) == 1 | Enable 5V LDO rail for LNA bias circuit - first in power-up sequence |
| 6 | Power Sequencing | `POWER_SEQ_CTRL` | `0x0900` | `0x03` | Wait for PG_3V3 (bit 1 of 0x0901) == 1 | Enable 3.3V LDO rail for digital I/O - second in sequence |
| 7 | Power Sequencing | `POWER_SEQ_CTRL` | `0x0900` | `0x0F` | Wait for PG_1V8 (bit 2) && PG_1V0 (bit 3) == 1 | Enable ADC rails (1.8V digital, 1.0V core) - final power-up sequence step |
| 8 | PLL & Clock Init | `PLL_CTRL` | `0x0400` | `0x02` | Wait 10 us after write | Assert PLL reset to ensure clean startup of LMK04828 jitter cleaner |
| 9 | PLL & Clock Init | `PLL_N_DIV` | `0x0402` | `0x0064` | None | Configure PLL N divider = 100 for target output frequency (adjust for required sample rate) |
| 10 | PLL & Clock Init | `PLL_R_DIV` | `0x0403` | `0x0001` | None | Configure PLL R divider = 1 (reference clock prescaler) |
| 11 | PLL & Clock Init | `PLL_CTRL` | `0x0400` | `0x01` | Poll PLL_STATUS (0x0401) until LOCKED (bit 0) == 1 | Enable PLL and poll for lock confirmation before distributing clocks |
| 12 | PLL & Clock Init | `CLK_ENABLE` | `0x0410` | `0x07` | None | Enable ADC clock, SYSREF, and FPGA reference clock outputs (bits 0,1,2) |
| 13 | Communication Init | `UART_BAUD_DIV` | `0x0100` | `0x0034` | None | Set UART baud divisor for 115200 baud at 100MHz system clock |
| 14 | Communication Init | `UART_CTRL` | `0x0101` | `0x13` | None | Enable UART (bit 0), set 8N1 frame format (bits 7:4 = 0x3) |
| 15 | Communication Init | `SPI_CTRL` | `0x0108` | `0x91` | None | Enable SPI master (bit 0) and automatic CS management (bit 1), set prescaler for 6MHz SPI clock |
| 16 | Temperature Alert Init | `TEMP_ALERT_HIGH` | `0x0308` | `0x0190` | None | Set over-temperature threshold to 100°C (0x190 * 0.25°C) |
| 17 | Temperature Alert Init | `TEMP_ALERT_LOW` | `0x0309` | `0xFF9C` | None | Set under-temperature threshold to -25°C for cold start detection |
| 18 | Temperature Alert Init | `IRQ_MASK` | `0x090A` | `0xFE` | None | Unmask temperature alerts (bit 0 = 0) while keeping other interrupts masked |
| 19 | Flash Interface Init | `FLASH_CTRL` | `0x0600` | `0x80` | Poll until BUSY (bit 7) == 0 | Issue read command to verify flash interface is ready and operational |
| 20 | EEPROM Init - Calibration | `EEPROM_ADDR` | `0x0501` | `0x0000` | None | Set EEPROM address to start of calibration data region |
| 21 | EEPROM Init - Calibration | `EEPROM_CTRL` | `0x0500` | `0x01` | Poll until BUSY (bit 7) == 0, then read EEPROM_DATA | Initiate EEPROM read of calibration data |
| 22 | RF Front-End Init | `RF_ATTENUATOR1` | `0x0701` | `0x00` | Write 1 then 0 to LOAD bit (pulse) | Set Attenuator 1 to 0dB (maximum gain) and pulse load to latch value |
| 23 | RF Front-End Init | `RF_ATTENUATOR2` | `0x0702` | `0x00` | Write 1 then 0 to LOAD bit (pulse) | Set Attenuator 2 to 0dB (maximum gain) and pulse load to latch value |
| 24 | RF Front-End Init | `RF_GAIN_CTRL` | `0x0700` | `0x0000` | Verify LNA_OK (bit 0 of RF_STATUS) == 1 | Configure RF front-end for maximum gain and verify LNA bias is active |
| 25 | JESD204B Link Init | `JESD_CTRL` | `0x0708` | `0x02` | Wait 100 us | Assert JESD204B link reset to initialize ADC10DX100 interface state |
| 26 | JESD204B Link Init | `JESD_CTRL` | `0x0708` | `0x01` | None | De-assert reset and enable JESD204B link (Subclass 1 mode) |
| 27 | JESD204B Link Init | `JESD_ILAS_CONFIG` | `0x070C` | `0x04` | None | Enable single ILAS transmission with checksum for link verification |
| 28 | JESD204B Link Init | `JESD_STATUS` | `0x0709` | `READ` | Poll until LINK_UP (bit 0) == 1 and ALIGN_DONE (bit 1) == 1 | Wait for JESD204B link to achieve code group synchronization and lane alignment |
| 29 | Final System Check | `HEALTH_STATUS` | `0x030F` | `READ` | Verify TEMP_OK (bit 0) && VOLT_OK (bit 1) && PLL_LOCK (bit 2) && JESD_LINK (bit 3) == 1 | Final system health verification - all monitors must pass before entering operational mode |
| 30 | Final System Check | `SYSTEM_IRQ` | `0x0909` | `READ` | Verify no pending interrupts (read should return 0x00) | Verify no fault conditions occurred during initialization sequence |

---

## Detailed Steps

### Step 1 — Power-On Reset & Self-Check
- **Register:** `SCRATCHPAD` at `0x0003`
- **Write value:** `0xA5A5`
- **Wait/Poll:** Read back and verify 0xA5A5
- **Rationale:** Perform RAM diagnostic by writing known pattern to SCRATCHPAD and reading back to verify register access functionality

### Step 2 — Power-On Reset & Self-Check
- **Register:** `SCRATCHPAD` at `0x0003`
- **Write value:** `0x5A5A`
- **Wait/Poll:** Read back and verify 0x5A5A
- **Rationale:** Second RAM check with inverted pattern to fully validate memory integrity before proceeding

### Step 3 — Power-On Reset & Self-Check
- **Register:** `BOARD_ID` at `0x0000`
- **Write value:** `READ`
- **Wait/Poll:** Verify return value == 0x4847 ('HG')
- **Rationale:** Verify correct FPGA image is loaded by reading fixed board identifier code

### Step 4 — Power-On Reset & Self-Check
- **Register:** `HEALTH_STATUS` at `0x030F`
- **Write value:** `READ`
- **Wait/Poll:** Poll until VOLT_OK (bit 1) == 1
- **Rationale:** Wait for all power rails to stabilize before enabling any peripherals

### Step 5 — Power Sequencing
- **Register:** `POWER_SEQ_CTRL` at `0x0900`
- **Write value:** `0x01`
- **Wait/Poll:** Wait for PG_5V (bit 0 of 0x0901) == 1
- **Rationale:** Enable 5V LDO rail for LNA bias circuit - first in power-up sequence

### Step 6 — Power Sequencing
- **Register:** `POWER_SEQ_CTRL` at `0x0900`
- **Write value:** `0x03`
- **Wait/Poll:** Wait for PG_3V3 (bit 1 of 0x0901) == 1
- **Rationale:** Enable 3.3V LDO rail for digital I/O - second in sequence

### Step 7 — Power Sequencing
- **Register:** `POWER_SEQ_CTRL` at `0x0900`
- **Write value:** `0x0F`
- **Wait/Poll:** Wait for PG_1V8 (bit 2) && PG_1V0 (bit 3) == 1
- **Rationale:** Enable ADC rails (1.8V digital, 1.0V core) - final power-up sequence step

### Step 8 — PLL & Clock Init
- **Register:** `PLL_CTRL` at `0x0400`
- **Write value:** `0x02`
- **Wait/Poll:** Wait 10 us after write
- **Rationale:** Assert PLL reset to ensure clean startup of LMK04828 jitter cleaner

### Step 9 — PLL & Clock Init
- **Register:** `PLL_N_DIV` at `0x0402`
- **Write value:** `0x0064`
- **Wait/Poll:** None
- **Rationale:** Configure PLL N divider = 100 for target output frequency (adjust for required sample rate)

### Step 10 — PLL & Clock Init
- **Register:** `PLL_R_DIV` at `0x0403`
- **Write value:** `0x0001`
- **Wait/Poll:** None
- **Rationale:** Configure PLL R divider = 1 (reference clock prescaler)

### Step 11 — PLL & Clock Init
- **Register:** `PLL_CTRL` at `0x0400`
- **Write value:** `0x01`
- **Wait/Poll:** Poll PLL_STATUS (0x0401) until LOCKED (bit 0) == 1
- **Rationale:** Enable PLL and poll for lock confirmation before distributing clocks

### Step 12 — PLL & Clock Init
- **Register:** `CLK_ENABLE` at `0x0410`
- **Write value:** `0x07`
- **Wait/Poll:** None
- **Rationale:** Enable ADC clock, SYSREF, and FPGA reference clock outputs (bits 0,1,2)

### Step 13 — Communication Init
- **Register:** `UART_BAUD_DIV` at `0x0100`
- **Write value:** `0x0034`
- **Wait/Poll:** None
- **Rationale:** Set UART baud divisor for 115200 baud at 100MHz system clock

### Step 14 — Communication Init
- **Register:** `UART_CTRL` at `0x0101`
- **Write value:** `0x13`
- **Wait/Poll:** None
- **Rationale:** Enable UART (bit 0), set 8N1 frame format (bits 7:4 = 0x3)

### Step 15 — Communication Init
- **Register:** `SPI_CTRL` at `0x0108`
- **Write value:** `0x91`
- **Wait/Poll:** None
- **Rationale:** Enable SPI master (bit 0) and automatic CS management (bit 1), set prescaler for 6MHz SPI clock

### Step 16 — Temperature Alert Init
- **Register:** `TEMP_ALERT_HIGH` at `0x0308`
- **Write value:** `0x0190`
- **Wait/Poll:** None
- **Rationale:** Set over-temperature threshold to 100°C (0x190 * 0.25°C)

### Step 17 — Temperature Alert Init
- **Register:** `TEMP_ALERT_LOW` at `0x0309`
- **Write value:** `0xFF9C`
- **Wait/Poll:** None
- **Rationale:** Set under-temperature threshold to -25°C for cold start detection

### Step 18 — Temperature Alert Init
- **Register:** `IRQ_MASK` at `0x090A`
- **Write value:** `0xFE`
- **Wait/Poll:** None
- **Rationale:** Unmask temperature alerts (bit 0 = 0) while keeping other interrupts masked

### Step 19 — Flash Interface Init
- **Register:** `FLASH_CTRL` at `0x0600`
- **Write value:** `0x80`
- **Wait/Poll:** Poll until BUSY (bit 7) == 0
- **Rationale:** Issue read command to verify flash interface is ready and operational

### Step 20 — EEPROM Init - Calibration
- **Register:** `EEPROM_ADDR` at `0x0501`
- **Write value:** `0x0000`
- **Wait/Poll:** None
- **Rationale:** Set EEPROM address to start of calibration data region

### Step 21 — EEPROM Init - Calibration
- **Register:** `EEPROM_CTRL` at `0x0500`
- **Write value:** `0x01`
- **Wait/Poll:** Poll until BUSY (bit 7) == 0, then read EEPROM_DATA
- **Rationale:** Initiate EEPROM read of calibration data

### Step 22 — RF Front-End Init
- **Register:** `RF_ATTENUATOR1` at `0x0701`
- **Write value:** `0x00`
- **Wait/Poll:** Write 1 then 0 to LOAD bit (pulse)
- **Rationale:** Set Attenuator 1 to 0dB (maximum gain) and pulse load to latch value

### Step 23 — RF Front-End Init
- **Register:** `RF_ATTENUATOR2` at `0x0702`
- **Write value:** `0x00`
- **Wait/Poll:** Write 1 then 0 to LOAD bit (pulse)
- **Rationale:** Set Attenuator 2 to 0dB (maximum gain) and pulse load to latch value

### Step 24 — RF Front-End Init
- **Register:** `RF_GAIN_CTRL` at `0x0700`
- **Write value:** `0x0000`
- **Wait/Poll:** Verify LNA_OK (bit 0 of RF_STATUS) == 1
- **Rationale:** Configure RF front-end for maximum gain and verify LNA bias is active

### Step 25 — JESD204B Link Init
- **Register:** `JESD_CTRL` at `0x0708`
- **Write value:** `0x02`
- **Wait/Poll:** Wait 100 us
- **Rationale:** Assert JESD204B link reset to initialize ADC10DX100 interface state

### Step 26 — JESD204B Link Init
- **Register:** `JESD_CTRL` at `0x0708`
- **Write value:** `0x01`
- **Wait/Poll:** None
- **Rationale:** De-assert reset and enable JESD204B link (Subclass 1 mode)

### Step 27 — JESD204B Link Init
- **Register:** `JESD_ILAS_CONFIG` at `0x070C`
- **Write value:** `0x04`
- **Wait/Poll:** None
- **Rationale:** Enable single ILAS transmission with checksum for link verification

### Step 28 — JESD204B Link Init
- **Register:** `JESD_STATUS` at `0x0709`
- **Write value:** `READ`
- **Wait/Poll:** Poll until LINK_UP (bit 0) == 1 and ALIGN_DONE (bit 1) == 1
- **Rationale:** Wait for JESD204B link to achieve code group synchronization and lane alignment

### Step 29 — Final System Check
- **Register:** `HEALTH_STATUS` at `0x030F`
- **Write value:** `READ`
- **Wait/Poll:** Verify TEMP_OK (bit 0) && VOLT_OK (bit 1) && PLL_LOCK (bit 2) && JESD_LINK (bit 3) == 1
- **Rationale:** Final system health verification - all monitors must pass before entering operational mode

### Step 30 — Final System Check
- **Register:** `SYSTEM_IRQ` at `0x0909`
- **Write value:** `READ`
- **Wait/Poll:** Verify no pending interrupts (read should return 0x00)
- **Rationale:** Verify no fault conditions occurred during initialization sequence
