# Programming Sequence (PSQ)
## khgk

> **Total steps:** 25

| # | Phase | Register | Address | Value | Condition | Rationale |
|---|-------|----------|---------|-------|-----------|-----------|
| 1 | Power-On Reset & Self-Check | `SCRATCHPAD` | `0x0003` | `0xAAAA` | — | Perform RAM integrity check by writing test pattern 0xAAAA to scratchpad register |
| 2 | Power-On Reset & Self-Check | `SCRATCHPAD` | `0x0003` | `0x5555` | Read verify == 0x5555 | Write inverse pattern 0x5555 and verify read-back to confirm data path integrity |
| 3 | Power-On Reset & Self-Check | `HEALTH_STATUS` | `0x030F` | `N/A` | Poll until VOLT_OK=1 (timeout 500ms) | Wait for all power rails (3.3V, 1.8V, 1.2V, -5V, 12V) to stabilize before enabling RF path |
| 4 | Power-On Reset & Self-Check | `BOARD_ID` | `0x0000` | `N/A` | Read verify == 0x4B48 ('KH') | Verify board identification matches expected khgk module |
| 5 | PLL & Clock Init | `PLL_CTRL` | `0x0400` | `0x0002` | — | Assert PLL reset (bit1) to ensure clean startup state before configuration |
| 6 | PLL & Clock Init | `PLL_N_DIV` | `0x0402` | `0x0064` | — | Configure PLL N divider (100) for target frequency (tune via PLL_FREQ_TARGET later) |
| 7 | PLL & Clock Init | `PLL_R_DIV` | `0x0403` | `0x0001` | — | Configure PLL R divider (1) for reference clock division |
| 8 | PLL & Clock Init | `PLL_CTRL` | `0x0400` | `0x0001` | — | Enable PLL (bit0) and release reset to begin lock acquisition |
| 9 | PLL & Clock Init | `PLL_STATUS` | `0x0401` | `N/A` | Poll until LOCKED=1 (timeout 10ms) | Wait for LMX2594 to achieve lock before enabling RF path and JESD link |
| 10 | PLL & Clock Init | `CLK_ENABLE` | `0x0410` | `0x0F` | — | Enable clock outputs to ADC, FPGA, and housekeeping MCU |
| 11 | Peripheral Enable | `RF_PATH_ENABLE` | `0x0700` | `0x000F` | — | Enable RF path (Q1 MOSFET), LNA, Mixer, and DVGA after PLL lock confirmed |
| 12 | Peripheral Enable | `DVGA_GAIN_CTRL` | `0x0701` | `0x8F` | — | Set DVGA to mid-range gain (15 = nominal) with update trigger (bit7=1) |
| 13 | Communication Init | `UART_BAUD_DIV` | `0x0100` | `0x0034` | — | Configure UART baud rate to 115200 (divisor 0x0034 @ 16MHz reference) |
| 14 | Communication Init | `UART_CTRL` | `0x0101` | `0x03` | — | Enable UART (bit0) with 8N1 frame format (bits[7:4]=0x3) |
| 15 | Communication Init | `ADC_JESD_CTRL` | `0x0200` | `0x1D` | — | Enable JESD204B link (bit0) with 4-lane mode (bits[4:2]=4) and Subclass 0 (bits[6:5]=0) |
| 16 | Communication Init | `ADC_JESD_STATUS` | `0x0201` | `N/A` | Poll until LINK_LOCK=1 (timeout 100ms) | Wait for JESD204B code group sync before ADC data is valid |
| 17 | Application Init | `TEMP_ALERT_HIGH` | `0x0308` | `0x0190` | — | Set over-temperature alert threshold to 100°C (0x190) |
| 18 | Application Init | `TEMP_ALERT_LOW` | `0x0309` | `0xFF9C` | — | Set under-temperature alert threshold to -25°C (signed 0xFF9C) |
| 19 | Application Init | `MCU_STATUS` | `0x0505` | `N/A` | Read verify ALIVE=1 and CAL_VALID=1 | Verify ATtiny1606 MCU is responsive and calibration data is valid |
| 20 | Application Init | `EEPROM_ADDR` | `0x0501` | `0x0000` | — | Set EEPROM address to 0x0000 for calibration data read |
| 21 | Application Init | `EEPROM_CTRL` | `0x0500` | `0x01` | Poll until BUSY=0 | Trigger EEPROM read operation and wait for completion |
| 22 | Application Init | `PLL_FREQ_TARGET` | `0x0703` | `0x1388` | — | Set initial LO frequency to 5.0 GHz (0x1388 in 0.01 GHz units) - configure per operational requirement |
| 23 | Application Init | `SPI_CTRL` | `0x0804` | `0x13` | — | Configure SPI master with chip select for PLL (bits[3:2]=00) and enable (bit0=1) |
| 24 | Final Verification | `HEALTH_STATUS` | `0x030F` | `N/A` | Verify TEMP_OK=1, VOLT_OK=1, PLL_LOCK=1, JESD_LINK_OK=1, SYSTEM_OK=1 | Final system health check confirming all subsystems operational |
| 25 | Final Verification | `VCC_12V_MONITOR` | `0x0303` | `N/A` | Read verify within 11.4V - 12.6V range | Verify 12V RF rail voltage is within specification for LNA/Mixer operation |

---

## Detailed Steps

### Step 1 — Power-On Reset & Self-Check
- **Register:** `SCRATCHPAD` at `0x0003`
- **Write value:** `0xAAAA`
- **Rationale:** Perform RAM integrity check by writing test pattern 0xAAAA to scratchpad register

### Step 2 — Power-On Reset & Self-Check
- **Register:** `SCRATCHPAD` at `0x0003`
- **Write value:** `0x5555`
- **Wait/Poll:** Read verify == 0x5555
- **Rationale:** Write inverse pattern 0x5555 and verify read-back to confirm data path integrity

### Step 3 — Power-On Reset & Self-Check
- **Register:** `HEALTH_STATUS` at `0x030F`
- **Write value:** `N/A`
- **Wait/Poll:** Poll until VOLT_OK=1 (timeout 500ms)
- **Rationale:** Wait for all power rails (3.3V, 1.8V, 1.2V, -5V, 12V) to stabilize before enabling RF path

### Step 4 — Power-On Reset & Self-Check
- **Register:** `BOARD_ID` at `0x0000`
- **Write value:** `N/A`
- **Wait/Poll:** Read verify == 0x4B48 ('KH')
- **Rationale:** Verify board identification matches expected khgk module

### Step 5 — PLL & Clock Init
- **Register:** `PLL_CTRL` at `0x0400`
- **Write value:** `0x0002`
- **Rationale:** Assert PLL reset (bit1) to ensure clean startup state before configuration

### Step 6 — PLL & Clock Init
- **Register:** `PLL_N_DIV` at `0x0402`
- **Write value:** `0x0064`
- **Rationale:** Configure PLL N divider (100) for target frequency (tune via PLL_FREQ_TARGET later)

### Step 7 — PLL & Clock Init
- **Register:** `PLL_R_DIV` at `0x0403`
- **Write value:** `0x0001`
- **Rationale:** Configure PLL R divider (1) for reference clock division

### Step 8 — PLL & Clock Init
- **Register:** `PLL_CTRL` at `0x0400`
- **Write value:** `0x0001`
- **Rationale:** Enable PLL (bit0) and release reset to begin lock acquisition

### Step 9 — PLL & Clock Init
- **Register:** `PLL_STATUS` at `0x0401`
- **Write value:** `N/A`
- **Wait/Poll:** Poll until LOCKED=1 (timeout 10ms)
- **Rationale:** Wait for LMX2594 to achieve lock before enabling RF path and JESD link

### Step 10 — PLL & Clock Init
- **Register:** `CLK_ENABLE` at `0x0410`
- **Write value:** `0x0F`
- **Rationale:** Enable clock outputs to ADC, FPGA, and housekeeping MCU

### Step 11 — Peripheral Enable
- **Register:** `RF_PATH_ENABLE` at `0x0700`
- **Write value:** `0x000F`
- **Rationale:** Enable RF path (Q1 MOSFET), LNA, Mixer, and DVGA after PLL lock confirmed

### Step 12 — Peripheral Enable
- **Register:** `DVGA_GAIN_CTRL` at `0x0701`
- **Write value:** `0x8F`
- **Rationale:** Set DVGA to mid-range gain (15 = nominal) with update trigger (bit7=1)

### Step 13 — Communication Init
- **Register:** `UART_BAUD_DIV` at `0x0100`
- **Write value:** `0x0034`
- **Rationale:** Configure UART baud rate to 115200 (divisor 0x0034 @ 16MHz reference)

### Step 14 — Communication Init
- **Register:** `UART_CTRL` at `0x0101`
- **Write value:** `0x03`
- **Rationale:** Enable UART (bit0) with 8N1 frame format (bits[7:4]=0x3)

### Step 15 — Communication Init
- **Register:** `ADC_JESD_CTRL` at `0x0200`
- **Write value:** `0x1D`
- **Rationale:** Enable JESD204B link (bit0) with 4-lane mode (bits[4:2]=4) and Subclass 0 (bits[6:5]=0)

### Step 16 — Communication Init
- **Register:** `ADC_JESD_STATUS` at `0x0201`
- **Write value:** `N/A`
- **Wait/Poll:** Poll until LINK_LOCK=1 (timeout 100ms)
- **Rationale:** Wait for JESD204B code group sync before ADC data is valid

### Step 17 — Application Init
- **Register:** `TEMP_ALERT_HIGH` at `0x0308`
- **Write value:** `0x0190`
- **Rationale:** Set over-temperature alert threshold to 100°C (0x190)

### Step 18 — Application Init
- **Register:** `TEMP_ALERT_LOW` at `0x0309`
- **Write value:** `0xFF9C`
- **Rationale:** Set under-temperature alert threshold to -25°C (signed 0xFF9C)

### Step 19 — Application Init
- **Register:** `MCU_STATUS` at `0x0505`
- **Write value:** `N/A`
- **Wait/Poll:** Read verify ALIVE=1 and CAL_VALID=1
- **Rationale:** Verify ATtiny1606 MCU is responsive and calibration data is valid

### Step 20 — Application Init
- **Register:** `EEPROM_ADDR` at `0x0501`
- **Write value:** `0x0000`
- **Rationale:** Set EEPROM address to 0x0000 for calibration data read

### Step 21 — Application Init
- **Register:** `EEPROM_CTRL` at `0x0500`
- **Write value:** `0x01`
- **Wait/Poll:** Poll until BUSY=0
- **Rationale:** Trigger EEPROM read operation and wait for completion

### Step 22 — Application Init
- **Register:** `PLL_FREQ_TARGET` at `0x0703`
- **Write value:** `0x1388`
- **Rationale:** Set initial LO frequency to 5.0 GHz (0x1388 in 0.01 GHz units) - configure per operational requirement

### Step 23 — Application Init
- **Register:** `SPI_CTRL` at `0x0804`
- **Write value:** `0x13`
- **Rationale:** Configure SPI master with chip select for PLL (bits[3:2]=00) and enable (bit0=1)

### Step 24 — Final Verification
- **Register:** `HEALTH_STATUS` at `0x030F`
- **Write value:** `N/A`
- **Wait/Poll:** Verify TEMP_OK=1, VOLT_OK=1, PLL_LOCK=1, JESD_LINK_OK=1, SYSTEM_OK=1
- **Rationale:** Final system health check confirming all subsystems operational

### Step 25 — Final Verification
- **Register:** `VCC_12V_MONITOR` at `0x0303`
- **Write value:** `N/A`
- **Wait/Poll:** Read verify within 11.4V - 12.6V range
- **Rationale:** Verify 12V RF rail voltage is within specification for LNA/Mixer operation
