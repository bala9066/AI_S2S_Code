# Programming Sequence (PSQ)
## sdfjbks

> **Total steps:** 28

| # | Phase | Register | Address | Value | Condition | Rationale |
|---|-------|----------|---------|-------|-----------|-----------|
| 1 | Power-On Reset & Self-Check | `SCRATCHPAD` | `0x0003` | `0xA5A5` | Read back and verify value matches | Perform RAM/Bus integrity check - write known pattern and read back to verify memory and UART interface are functional |
| 2 | Power-On Reset & Self-Check | `BOARD_ID` | `0x0000` | `0x0000` | Verify read returns 0x5F6A (expected board ID) | Confirm FPGA is communicating with correct sdfjbks hardware - validate board identity before proceeding |
| 3 | Power-On Reset & Self-Check | `HEALTH_STATUS` | `0x030F` | `0x0000` | Poll until VOLT_OK=1 (bit[1]) | Wait for all power rails (5V, 3.3V, 1.8V, 1.2V) to stabilize within tolerance before enabling RF components |
| 4 | Power-On Reset & Self-Check | `TEMP_LOCAL` | `0x0300` | `0x0000` | Read and verify TEMP < 85°C | Check die temperature is within safe operating range before enabling PLL and RF chain |
| 5 | PLL & Clock Init | `PLL_CTRL` | `0x0400` | `0x0002` | None | Take ADF5356 PLL out of reset (RESET_N=1) while keeping disabled - prepare for configuration |
| 6 | PLL & Clock Init | `PLL_N_DIV` | `0x0402` | `0x0064` | None | Set N=100 for LO frequency (example: REF=100MHz, N=100 yields LO ~10GHz range) |
| 7 | PLL & Clock Init | `PLL_R_DIV` | `0x0403` | `0x0001` | None | Set R=1 for reference divider - configure PFD frequency |
| 8 | PLL & Clock Init | `PLL_CTRL` | `0x0400` | `0x0003` | Poll PLL_STATUS[0]=LOCKED | Enable PLL (ENABLE=1, RESET_N=1) and wait for LOCK indication - LO must be stable before RF enable |
| 9 | PLL & Clock Init | `CLK_ENABLE` | `0x0410` | `0x000F` | None | Enable all clock outputs: ADC clock, FPGA reference, SYSREF, and PLL reference clock |
| 10 | PLL & Clock Init | `LMK_CONFIG` | `0x070A` | `0x001B` | None | Configure LMK04828: enable SYSREF and clock outputs, set SYSREF repetition rate for JESD204B Subclass 1 |
| 11 | Peripheral Enable | `UART_BAUD_DIV` | `0x0100` | `0x0034` | None | Configure UART baud rate divisor for 115200 bps (assuming 100MHz input clock) |
| 12 | Peripheral Enable | `UART_CTRL` | `0x0101` | `0x0001` | None | Enable UART communication for host control interface |
| 13 | Communication Init | `ADC_CTRL` | `0x0200` | `0x0005` | Wait for ADC_STATUS[0]=DATA_READY | Enable continuous ADC monitoring on channel 1 (3.3V rail) - begin power rail monitoring |
| 14 | Communication Init | `EEPROM_ADDR` | `0x0501` | `0x0000` | None | Set EEPROM address to 0x0000 for calibration data read |
| 15 | Communication Init | `EEPROM_CTRL` | `0x0500` | `0x0001` | Wait for EEPROM_CTRL[7]=BUSY=0, then read EEPROM_DATA | Initiate EEPROM read of factory calibration data for RF gain/phase correction |
| 16 | Application Init | `LNA_ENABLE` | `0x0702` | `0x0001` | None | Enable HMC6180LP4E LNA for RF input path - active receive mode |
| 17 | Application Init | `VGA_GAIN_CTRL` | `0x0701` | `0x000F` | None | Set HMC698LP4 VGA to mid-range gain (15dB) - allow AGC headroom |
| 18 | Application Init | `MIXER_CTRL` | `0x0703` | `0x0015` | None | Enable HMC1051LP4E mixer with 3dBm LO drive, 2.8GHz IF bandwidth |
| 19 | Application Init | `RF_PHASE_CTRL` | `0x0700` | `0x8000` | None | Apply EEPROM calibration data to phase correction register (default mid-range if EEPROM unavailable) |
| 20 | Application Init | `ADC12DJ_CONFIG` | `0x0708` | `0x0013` | None | Configure ADC12DJ5200RF: 5.2GSPS, JESD204B Subclass 1, 2 lanes enabled |
| 21 | Application Init | `JESD_STATUS` | `0x0709` | `0x0000` | Poll until LINK_READY=1 and SYSREF_DET=1 | Wait for JESD204B link alignment and SYSREF synchronization before data capture |
| 22 | Application Init | `TEMP_ALERT_HIGH` | `0x0308` | `0x0190` | None | Arm over-temperature alert at 100°C (0x190 in 0.25°C units) |
| 23 | Application Init | `TEMP_ALERT_LOW` | `0x0309` | `0xFF9C` | None | Arm under-temperature alert at -25°C for cold start detection |
| 24 | Application Init | `HEALTH_STATUS` | `0x030F` | `0x0000` | Verify SYSTEM_OK=1 (all health checks pass) | Final system health check - confirm temperature, voltage, PLL lock, and JESD link are all OK |
| 25 | Application Init | `DAC_CTRL` | `0x0900` | `0x0001` | None | Enable DAC channel 0 for analog monitoring or calibration output |
| 26 | Application Init | `DAC_DATA_CH0` | `0x0901` | `0x8000` | None | Set DAC channel 0 to mid-scale output (reference level) |
| 27 | Application Init | `GPIO_DIR` | `0x0801` | `0x00FF` | None | Configure all GPIO pins as inputs (0xFF) for status monitoring - can be reconfigured as outputs for control |
| 28 | Application Init | `FLASH_STATUS` | `0x0604` | `0x0000` | Verify READY=1, no errors | Check flash interface is ready for configuration storage or firmware update |

---

## Detailed Steps

### Step 1 — Power-On Reset & Self-Check
- **Register:** `SCRATCHPAD` at `0x0003`
- **Write value:** `0xA5A5`
- **Wait/Poll:** Read back and verify value matches
- **Rationale:** Perform RAM/Bus integrity check - write known pattern and read back to verify memory and UART interface are functional

### Step 2 — Power-On Reset & Self-Check
- **Register:** `BOARD_ID` at `0x0000`
- **Write value:** `0x0000`
- **Wait/Poll:** Verify read returns 0x5F6A (expected board ID)
- **Rationale:** Confirm FPGA is communicating with correct sdfjbks hardware - validate board identity before proceeding

### Step 3 — Power-On Reset & Self-Check
- **Register:** `HEALTH_STATUS` at `0x030F`
- **Write value:** `0x0000`
- **Wait/Poll:** Poll until VOLT_OK=1 (bit[1])
- **Rationale:** Wait for all power rails (5V, 3.3V, 1.8V, 1.2V) to stabilize within tolerance before enabling RF components

### Step 4 — Power-On Reset & Self-Check
- **Register:** `TEMP_LOCAL` at `0x0300`
- **Write value:** `0x0000`
- **Wait/Poll:** Read and verify TEMP < 85°C
- **Rationale:** Check die temperature is within safe operating range before enabling PLL and RF chain

### Step 5 — PLL & Clock Init
- **Register:** `PLL_CTRL` at `0x0400`
- **Write value:** `0x0002`
- **Wait/Poll:** None
- **Rationale:** Take ADF5356 PLL out of reset (RESET_N=1) while keeping disabled - prepare for configuration

### Step 6 — PLL & Clock Init
- **Register:** `PLL_N_DIV` at `0x0402`
- **Write value:** `0x0064`
- **Wait/Poll:** None
- **Rationale:** Set N=100 for LO frequency (example: REF=100MHz, N=100 yields LO ~10GHz range)

### Step 7 — PLL & Clock Init
- **Register:** `PLL_R_DIV` at `0x0403`
- **Write value:** `0x0001`
- **Wait/Poll:** None
- **Rationale:** Set R=1 for reference divider - configure PFD frequency

### Step 8 — PLL & Clock Init
- **Register:** `PLL_CTRL` at `0x0400`
- **Write value:** `0x0003`
- **Wait/Poll:** Poll PLL_STATUS[0]=LOCKED
- **Rationale:** Enable PLL (ENABLE=1, RESET_N=1) and wait for LOCK indication - LO must be stable before RF enable

### Step 9 — PLL & Clock Init
- **Register:** `CLK_ENABLE` at `0x0410`
- **Write value:** `0x000F`
- **Wait/Poll:** None
- **Rationale:** Enable all clock outputs: ADC clock, FPGA reference, SYSREF, and PLL reference clock

### Step 10 — PLL & Clock Init
- **Register:** `LMK_CONFIG` at `0x070A`
- **Write value:** `0x001B`
- **Wait/Poll:** None
- **Rationale:** Configure LMK04828: enable SYSREF and clock outputs, set SYSREF repetition rate for JESD204B Subclass 1

### Step 11 — Peripheral Enable
- **Register:** `UART_BAUD_DIV` at `0x0100`
- **Write value:** `0x0034`
- **Wait/Poll:** None
- **Rationale:** Configure UART baud rate divisor for 115200 bps (assuming 100MHz input clock)

### Step 12 — Peripheral Enable
- **Register:** `UART_CTRL` at `0x0101`
- **Write value:** `0x0001`
- **Wait/Poll:** None
- **Rationale:** Enable UART communication for host control interface

### Step 13 — Communication Init
- **Register:** `ADC_CTRL` at `0x0200`
- **Write value:** `0x0005`
- **Wait/Poll:** Wait for ADC_STATUS[0]=DATA_READY
- **Rationale:** Enable continuous ADC monitoring on channel 1 (3.3V rail) - begin power rail monitoring

### Step 14 — Communication Init
- **Register:** `EEPROM_ADDR` at `0x0501`
- **Write value:** `0x0000`
- **Wait/Poll:** None
- **Rationale:** Set EEPROM address to 0x0000 for calibration data read

### Step 15 — Communication Init
- **Register:** `EEPROM_CTRL` at `0x0500`
- **Write value:** `0x0001`
- **Wait/Poll:** Wait for EEPROM_CTRL[7]=BUSY=0, then read EEPROM_DATA
- **Rationale:** Initiate EEPROM read of factory calibration data for RF gain/phase correction

### Step 16 — Application Init
- **Register:** `LNA_ENABLE` at `0x0702`
- **Write value:** `0x0001`
- **Wait/Poll:** None
- **Rationale:** Enable HMC6180LP4E LNA for RF input path - active receive mode

### Step 17 — Application Init
- **Register:** `VGA_GAIN_CTRL` at `0x0701`
- **Write value:** `0x000F`
- **Wait/Poll:** None
- **Rationale:** Set HMC698LP4 VGA to mid-range gain (15dB) - allow AGC headroom

### Step 18 — Application Init
- **Register:** `MIXER_CTRL` at `0x0703`
- **Write value:** `0x0015`
- **Wait/Poll:** None
- **Rationale:** Enable HMC1051LP4E mixer with 3dBm LO drive, 2.8GHz IF bandwidth

### Step 19 — Application Init
- **Register:** `RF_PHASE_CTRL` at `0x0700`
- **Write value:** `0x8000`
- **Wait/Poll:** None
- **Rationale:** Apply EEPROM calibration data to phase correction register (default mid-range if EEPROM unavailable)

### Step 20 — Application Init
- **Register:** `ADC12DJ_CONFIG` at `0x0708`
- **Write value:** `0x0013`
- **Wait/Poll:** None
- **Rationale:** Configure ADC12DJ5200RF: 5.2GSPS, JESD204B Subclass 1, 2 lanes enabled

### Step 21 — Application Init
- **Register:** `JESD_STATUS` at `0x0709`
- **Write value:** `0x0000`
- **Wait/Poll:** Poll until LINK_READY=1 and SYSREF_DET=1
- **Rationale:** Wait for JESD204B link alignment and SYSREF synchronization before data capture

### Step 22 — Application Init
- **Register:** `TEMP_ALERT_HIGH` at `0x0308`
- **Write value:** `0x0190`
- **Wait/Poll:** None
- **Rationale:** Arm over-temperature alert at 100°C (0x190 in 0.25°C units)

### Step 23 — Application Init
- **Register:** `TEMP_ALERT_LOW` at `0x0309`
- **Write value:** `0xFF9C`
- **Wait/Poll:** None
- **Rationale:** Arm under-temperature alert at -25°C for cold start detection

### Step 24 — Application Init
- **Register:** `HEALTH_STATUS` at `0x030F`
- **Write value:** `0x0000`
- **Wait/Poll:** Verify SYSTEM_OK=1 (all health checks pass)
- **Rationale:** Final system health check - confirm temperature, voltage, PLL lock, and JESD link are all OK

### Step 25 — Application Init
- **Register:** `DAC_CTRL` at `0x0900`
- **Write value:** `0x0001`
- **Wait/Poll:** None
- **Rationale:** Enable DAC channel 0 for analog monitoring or calibration output

### Step 26 — Application Init
- **Register:** `DAC_DATA_CH0` at `0x0901`
- **Write value:** `0x8000`
- **Wait/Poll:** None
- **Rationale:** Set DAC channel 0 to mid-scale output (reference level)

### Step 27 — Application Init
- **Register:** `GPIO_DIR` at `0x0801`
- **Write value:** `0x00FF`
- **Wait/Poll:** None
- **Rationale:** Configure all GPIO pins as inputs (0xFF) for status monitoring - can be reconfigured as outputs for control

### Step 28 — Application Init
- **Register:** `FLASH_STATUS` at `0x0604`
- **Write value:** `0x0000`
- **Wait/Poll:** Verify READY=1, no errors
- **Rationale:** Check flash interface is ready for configuration storage or firmware update
