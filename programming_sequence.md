# Programming Sequence (PSQ)
## Sample Ai Project

> **Total steps:** 21

| # | Phase | Register | Address | Value | Condition | Rationale |
|---|-------|----------|---------|-------|-----------|-----------|
| 1 | Power-On Reset & Self-Check | `SCRATCHPAD` | `0x0003` | `0xA5A5` | Write 0xA5A5, read back and verify value matches | Basic RAM integrity check - verifies register read/write functionality and UART communication before proceeding with initialization |
| 2 | Power-On Reset & Self-Check | `BOARD_ID` | `0x0000` | `0xA10C` | Read and verify value equals 0xA10C | Confirm correct FPGA image is loaded by verifying board ID matches expected value for Sample Ai Project |
| 3 | Power-On Reset & Self-Check | `HEALTH_STATUS` | `0x030F` | `0x0000` | Poll until VOLT_OK (bit[1]) = 1 and TEMP_OK (bit[0]) = 1, max timeout 500ms | Wait for LTC2937 power sequencer to complete rail power-up - all LDOs (LT3045/40 family) must be stable before proceeding |
| 4 | Power-On Reset & Self-Check | `MCS_VERSION_MAJOR/MINOR` | `0x0010-0x0011` | `0x0105` | Read firmware version and log for diagnostics | Record FPGA firmware version for system diagnostics and compatibility verification |
| 5 | PLL & Clock Init | `PLL_N_DIV` | `0x0402` | `0x0064` | Write N=100 (for 500MHz VCO with 10MHz reference) | Configure HMC7044 N divider to achieve desired output frequency for ADC clock (10GSPS system) |
| 6 | PLL & Clock Init | `PLL_R_DIV` | `0x0403` | `0x000A` | Write R=10 | Configure HMC7044 R divider for reference clock division (100MHz FPGA reference) |
| 7 | PLL & Clock Init | `PLL_CTRL` | `0x0400` | `0x01` | Set ENABLE=1, RESET=0; poll PLL_STATUS.LOCKED (bit[0]) = 1, max timeout 100ms | Enable HMC7044 clock generator and verify PLL lock before enabling clock outputs to ADC and FPGA |
| 8 | PLL & Clock Init | `CLK_ENABLE` | `0x0410` | `0x07` | Enable CLK_ADC_EN[0], CLK_FPGA_EN[1], CLK_SYNC_EN[2] | Enable clock outputs to ADC10D1000RF, FPGA logic, and sync distribution after PLL is locked |
| 9 | Peripheral Enable | `TEMP_ALERT_HIGH` | `0x0308` | `0x0190` | Write threshold 100°C (0x0190 in 0.25°C units) | Arm over-temperature protection alert for RF front-end and FPGA die monitoring |
| 10 | Peripheral Enable | `TEMP_ALERT_LOW` | `0x0309` | `0xFF9C` | Write threshold -25°C (signed two's complement) | Arm under-temperature protection alert for cold start monitoring |
| 11 | Communication Init | `UART_BAUD_DIV` | `0x0100` | `0x002D` | Write divisor 45 for 115200 baud @ 100MHz reference | Configure UART baud rate for control interface communication via DF40 connector |
| 12 | Communication Init | `UART_CTRL` | `0x0101` | `0x13` | Set ENABLE=1, FRAME_FORMAT[7:4]=3 (8N1), LOOPBACK=0 | Enable UART with standard 8-bit, no parity, 1 stop-bit format for host communication |
| 13 | Application Init | `RF_LNA_ENABLE` | `0x0701` | `0x01` | Set LNA_EN=1, BYPASS=0 | Enable TGA4943-SL wideband LNA for RF signal path (5-18 GHz coverage) |
| 14 | Application Init | `RF_DSA_GAIN` | `0x0700` | `0x1E` | Set attenuation to 30 (7.5 dB) for nominal gain | Configure HMC698LP4E DSA to moderate attenuation level - calibrates system gain for optimal ADC input level |
| 15 | Application Init | `RF_AGC_CTRL` | `0x0702` | `0x82` | Set AGC_ENABLE=1, TARGET_LEVEL=8 (-10dBFS) |  |
| 16 | Application Init | `JESD204B_CTRL` | `0x0710` | `0x05` | Set LINK_ENABLE=1, SUBCLASS1_EN=1, LANE_COUNT=2 | Enable JESD204B Subclass 1 interface to ADC10D1000RF with deterministic latency for dual-lane DDR LVDS data |
| 17 | Application Init | `JESD204B_STATUS` | `0x0711` | `0x0F` | Poll until LINK_READY=1, LANE0_ALIGN=1, LANE1_ALIGN=1, CODE_GRP_SYNC=1, max timeout 200ms | Verify JESD204B link is fully aligned and synchronized before enabling ADC data capture |
| 18 | Application Init | `ADC_CTRL` | `0x0200` | `0x13` | Set START=1, CONTINUOUS=1, JESD204B_EN=1, CHANNEL_SEL=0 (I-channel) | Start ADC10D1000RF continuous sampling mode with JESD204B output enabled for 5-10 GSPS operation |
| 19 | Application Init | `EEPROM_ADDR` | `0x0501` | `0x0000` | Set EEPROM address to 0x0000 for calibration data | Prepare to read factory calibration data from EEPROM for RF gain correction |
| 20 | Application Init | `EEPROM_CTRL` | `0x0500` | `0x01` | Set READ=1; poll BUSY=0; read EEPROM_DATA at 0x0502 | Read factory calibration data to correct DSA attenuation and frequency response across 5-18GHz band |
| 21 | Application Init | `HEALTH_STATUS` | `0x030F` | `0x8F` | Final verification - poll until SYSTEM_OK=1, TEMP_OK=1, VOLT_OK=1, PLL_LOCK=1, JESD204B_OK=1 | Complete system initialization verification - all health flags should indicate normal operation before entering data acquisition mode |

---

## Detailed Steps

### Step 1 — Power-On Reset & Self-Check
- **Register:** `SCRATCHPAD` at `0x0003`
- **Write value:** `0xA5A5`
- **Wait/Poll:** Write 0xA5A5, read back and verify value matches
- **Rationale:** Basic RAM integrity check - verifies register read/write functionality and UART communication before proceeding with initialization

### Step 2 — Power-On Reset & Self-Check
- **Register:** `BOARD_ID` at `0x0000`
- **Write value:** `0xA10C`
- **Wait/Poll:** Read and verify value equals 0xA10C
- **Rationale:** Confirm correct FPGA image is loaded by verifying board ID matches expected value for Sample Ai Project

### Step 3 — Power-On Reset & Self-Check
- **Register:** `HEALTH_STATUS` at `0x030F`
- **Write value:** `0x0000`
- **Wait/Poll:** Poll until VOLT_OK (bit[1]) = 1 and TEMP_OK (bit[0]) = 1, max timeout 500ms
- **Rationale:** Wait for LTC2937 power sequencer to complete rail power-up - all LDOs (LT3045/40 family) must be stable before proceeding

### Step 4 — Power-On Reset & Self-Check
- **Register:** `MCS_VERSION_MAJOR/MINOR` at `0x0010-0x0011`
- **Write value:** `0x0105`
- **Wait/Poll:** Read firmware version and log for diagnostics
- **Rationale:** Record FPGA firmware version for system diagnostics and compatibility verification

### Step 5 — PLL & Clock Init
- **Register:** `PLL_N_DIV` at `0x0402`
- **Write value:** `0x0064`
- **Wait/Poll:** Write N=100 (for 500MHz VCO with 10MHz reference)
- **Rationale:** Configure HMC7044 N divider to achieve desired output frequency for ADC clock (10GSPS system)

### Step 6 — PLL & Clock Init
- **Register:** `PLL_R_DIV` at `0x0403`
- **Write value:** `0x000A`
- **Wait/Poll:** Write R=10
- **Rationale:** Configure HMC7044 R divider for reference clock division (100MHz FPGA reference)

### Step 7 — PLL & Clock Init
- **Register:** `PLL_CTRL` at `0x0400`
- **Write value:** `0x01`
- **Wait/Poll:** Set ENABLE=1, RESET=0; poll PLL_STATUS.LOCKED (bit[0]) = 1, max timeout 100ms
- **Rationale:** Enable HMC7044 clock generator and verify PLL lock before enabling clock outputs to ADC and FPGA

### Step 8 — PLL & Clock Init
- **Register:** `CLK_ENABLE` at `0x0410`
- **Write value:** `0x07`
- **Wait/Poll:** Enable CLK_ADC_EN[0], CLK_FPGA_EN[1], CLK_SYNC_EN[2]
- **Rationale:** Enable clock outputs to ADC10D1000RF, FPGA logic, and sync distribution after PLL is locked

### Step 9 — Peripheral Enable
- **Register:** `TEMP_ALERT_HIGH` at `0x0308`
- **Write value:** `0x0190`
- **Wait/Poll:** Write threshold 100°C (0x0190 in 0.25°C units)
- **Rationale:** Arm over-temperature protection alert for RF front-end and FPGA die monitoring

### Step 10 — Peripheral Enable
- **Register:** `TEMP_ALERT_LOW` at `0x0309`
- **Write value:** `0xFF9C`
- **Wait/Poll:** Write threshold -25°C (signed two's complement)
- **Rationale:** Arm under-temperature protection alert for cold start monitoring

### Step 11 — Communication Init
- **Register:** `UART_BAUD_DIV` at `0x0100`
- **Write value:** `0x002D`
- **Wait/Poll:** Write divisor 45 for 115200 baud @ 100MHz reference
- **Rationale:** Configure UART baud rate for control interface communication via DF40 connector

### Step 12 — Communication Init
- **Register:** `UART_CTRL` at `0x0101`
- **Write value:** `0x13`
- **Wait/Poll:** Set ENABLE=1, FRAME_FORMAT[7:4]=3 (8N1), LOOPBACK=0
- **Rationale:** Enable UART with standard 8-bit, no parity, 1 stop-bit format for host communication

### Step 13 — Application Init
- **Register:** `RF_LNA_ENABLE` at `0x0701`
- **Write value:** `0x01`
- **Wait/Poll:** Set LNA_EN=1, BYPASS=0
- **Rationale:** Enable TGA4943-SL wideband LNA for RF signal path (5-18 GHz coverage)

### Step 14 — Application Init
- **Register:** `RF_DSA_GAIN` at `0x0700`
- **Write value:** `0x1E`
- **Wait/Poll:** Set attenuation to 30 (7.5 dB) for nominal gain
- **Rationale:** Configure HMC698LP4E DSA to moderate attenuation level - calibrates system gain for optimal ADC input level

### Step 15 — Application Init
- **Register:** `RF_AGC_CTRL` at `0x0702`
- **Write value:** `0x82`
- **Wait/Poll:** Set AGC_ENABLE=1, TARGET_LEVEL=8 (-10dBFS)
- **Rationale:** 

### Step 16 — Application Init
- **Register:** `JESD204B_CTRL` at `0x0710`
- **Write value:** `0x05`
- **Wait/Poll:** Set LINK_ENABLE=1, SUBCLASS1_EN=1, LANE_COUNT=2
- **Rationale:** Enable JESD204B Subclass 1 interface to ADC10D1000RF with deterministic latency for dual-lane DDR LVDS data

### Step 17 — Application Init
- **Register:** `JESD204B_STATUS` at `0x0711`
- **Write value:** `0x0F`
- **Wait/Poll:** Poll until LINK_READY=1, LANE0_ALIGN=1, LANE1_ALIGN=1, CODE_GRP_SYNC=1, max timeout 200ms
- **Rationale:** Verify JESD204B link is fully aligned and synchronized before enabling ADC data capture

### Step 18 — Application Init
- **Register:** `ADC_CTRL` at `0x0200`
- **Write value:** `0x13`
- **Wait/Poll:** Set START=1, CONTINUOUS=1, JESD204B_EN=1, CHANNEL_SEL=0 (I-channel)
- **Rationale:** Start ADC10D1000RF continuous sampling mode with JESD204B output enabled for 5-10 GSPS operation

### Step 19 — Application Init
- **Register:** `EEPROM_ADDR` at `0x0501`
- **Write value:** `0x0000`
- **Wait/Poll:** Set EEPROM address to 0x0000 for calibration data
- **Rationale:** Prepare to read factory calibration data from EEPROM for RF gain correction

### Step 20 — Application Init
- **Register:** `EEPROM_CTRL` at `0x0500`
- **Write value:** `0x01`
- **Wait/Poll:** Set READ=1; poll BUSY=0; read EEPROM_DATA at 0x0502
- **Rationale:** Read factory calibration data to correct DSA attenuation and frequency response across 5-18GHz band

### Step 21 — Application Init
- **Register:** `HEALTH_STATUS` at `0x030F`
- **Write value:** `0x8F`
- **Wait/Poll:** Final verification - poll until SYSTEM_OK=1, TEMP_OK=1, VOLT_OK=1, PLL_LOCK=1, JESD204B_OK=1
- **Rationale:** Complete system initialization verification - all health flags should indicate normal operation before entering data acquisition mode
