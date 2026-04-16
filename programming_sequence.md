# Programming Sequence (PSQ)
## hjgjf

> **Total steps:** 18

| # | Phase | Register | Address | Value | Condition | Rationale |
|---|-------|----------|---------|-------|-----------|-----------|
| 1 | Power-On Reset & Self-Check | `SCRATCHPAD` | `0x0003` | `0x55AA` | Read back verify == 0x55AA | RAM integrity check - write known pattern to SCRATCHPAD and read back to verify FPGA memory interface is functional |
| 2 | Power-On Reset & Self-Check | `SCRATCHPAD` | `0x0003` | `0xAA55` | Read back verify == 0xAA55 | Second RAM check with inverted pattern to detect stuck-at faults |
| 3 | Power-On Reset & Self-Check | `BOARD_ID` | `0x0000` | `READ` | Verify BOARD_ID == 0x484A | Verify correct FPGA bitstream loaded - confirm board ID matches expected value for hjgjf project |
| 4 | Power-On Reset & Self-Check | `HEALTH_STATUS` | `0x030F` | `READ` | Poll until VOLT_OK==1 and TEMP_OK==1 | Wait for all power rails to stabilize within tolerance and temperature within operating range before proceeding |
| 5 | PLL & Clock Init | `PLL_CTRL` | `0x0400` | `0x02` | Hold for 10us | Assert PLL reset to ensure clean startup - set RESET=1 before configuration |
| 6 | PLL & Clock Init | `PLL_N_DIV` | `0x0402` | `0x0064` | Immediate | Configure N=100 for 5GHz ADC clock from 50MHz reference (HMC7044 configuration) |
| 7 | PLL & Clock Init | `PLL_R_DIV` | `0x0403` | `0x0001` | Immediate | Configure R=1 reference divider - reference clock applied directly |
| 8 | PLL & Clock Init | `PLL_CTRL` | `0x0400` | `0x01` | Poll PLL_STATUS[0] until LOCKED==1 (max 100ms) | Enable PLL and wait for lock - critical for ADC sampling clock stability before enabling RF chain |
| 9 | PLL & Clock Init | `CLK_ENABLE` | `0x0410` | `0x0F` | Immediate | Enable all clock outputs (ADC, FPGA, LVDS, DAC) - system clock distribution active |
| 10 | Communication Init | `UART_BAUD_DIV` | `0x0100` | `0x0034` | Immediate | Set baud rate divisor for 115200 baud at 100MHz UART clock (100M / (16 * 52) = 115200) |
| 11 | Communication Init | `UART_CTRL` | `0x0101` | `0x01` | Immediate | Enable UART with default 8N1 frame format for command interface |
| 12 | RF Front-End Init | `RF_LNA_CTRL` | `0x0700` | `0x01` | Immediate | Enable HMC1099LP5E LNA with default gain setting (22dB) - RF front-end powered on |
| 13 | ADC Init | `ADC_CTRL` | `0x0200` | `0x21` | Wait 1ms | Enable EV10AQ190A ADC in continuous mode with LVDS outputs active (START=1, CONT=1, LVDS=1) |
| 14 | Temperature Monitor Init | `TEMP_ALERT_HIGH` | `0x0308` | `0x0190` | Immediate | Set over-temperature alert to 100°C (0x190 = 100 * 4) |
| 15 | Temperature Monitor Init | `TEMP_ALERT_LOW` | `0x0309` | `0xFF9C` | Immediate | Set under-temperature alert to -25°C (two's complement) for cold-start protection |
| 16 | Storage Init | `EEPROM_ADDR` | `0x0501` | `0x0000` | Immediate | Set EEPROM address to 0x0000 to read calibration data from start of user memory |
| 17 | Storage Init | `EEPROM_CTRL` | `0x0500` | `0x01` | Poll until BUSY==0 then read EEPROM_DATA | Initiate EEPROM read to load factory calibration data (gain offsets, frequency corrections) |
| 18 | System Ready | `HEALTH_STATUS` | `0x030F` | `READ` | Verify SYSTEM_OK==1, PLL_LOCK==1, ADC_OK==1 | Final health check - all subsystems operational before entering mission mode |

---

## Detailed Steps

### Step 1 — Power-On Reset & Self-Check
- **Register:** `SCRATCHPAD` at `0x0003`
- **Write value:** `0x55AA`
- **Wait/Poll:** Read back verify == 0x55AA
- **Rationale:** RAM integrity check - write known pattern to SCRATCHPAD and read back to verify FPGA memory interface is functional

### Step 2 — Power-On Reset & Self-Check
- **Register:** `SCRATCHPAD` at `0x0003`
- **Write value:** `0xAA55`
- **Wait/Poll:** Read back verify == 0xAA55
- **Rationale:** Second RAM check with inverted pattern to detect stuck-at faults

### Step 3 — Power-On Reset & Self-Check
- **Register:** `BOARD_ID` at `0x0000`
- **Write value:** `READ`
- **Wait/Poll:** Verify BOARD_ID == 0x484A
- **Rationale:** Verify correct FPGA bitstream loaded - confirm board ID matches expected value for hjgjf project

### Step 4 — Power-On Reset & Self-Check
- **Register:** `HEALTH_STATUS` at `0x030F`
- **Write value:** `READ`
- **Wait/Poll:** Poll until VOLT_OK==1 and TEMP_OK==1
- **Rationale:** Wait for all power rails to stabilize within tolerance and temperature within operating range before proceeding

### Step 5 — PLL & Clock Init
- **Register:** `PLL_CTRL` at `0x0400`
- **Write value:** `0x02`
- **Wait/Poll:** Hold for 10us
- **Rationale:** Assert PLL reset to ensure clean startup - set RESET=1 before configuration

### Step 6 — PLL & Clock Init
- **Register:** `PLL_N_DIV` at `0x0402`
- **Write value:** `0x0064`
- **Wait/Poll:** Immediate
- **Rationale:** Configure N=100 for 5GHz ADC clock from 50MHz reference (HMC7044 configuration)

### Step 7 — PLL & Clock Init
- **Register:** `PLL_R_DIV` at `0x0403`
- **Write value:** `0x0001`
- **Wait/Poll:** Immediate
- **Rationale:** Configure R=1 reference divider - reference clock applied directly

### Step 8 — PLL & Clock Init
- **Register:** `PLL_CTRL` at `0x0400`
- **Write value:** `0x01`
- **Wait/Poll:** Poll PLL_STATUS[0] until LOCKED==1 (max 100ms)
- **Rationale:** Enable PLL and wait for lock - critical for ADC sampling clock stability before enabling RF chain

### Step 9 — PLL & Clock Init
- **Register:** `CLK_ENABLE` at `0x0410`
- **Write value:** `0x0F`
- **Wait/Poll:** Immediate
- **Rationale:** Enable all clock outputs (ADC, FPGA, LVDS, DAC) - system clock distribution active

### Step 10 — Communication Init
- **Register:** `UART_BAUD_DIV` at `0x0100`
- **Write value:** `0x0034`
- **Wait/Poll:** Immediate
- **Rationale:** Set baud rate divisor for 115200 baud at 100MHz UART clock (100M / (16 * 52) = 115200)

### Step 11 — Communication Init
- **Register:** `UART_CTRL` at `0x0101`
- **Write value:** `0x01`
- **Wait/Poll:** Immediate
- **Rationale:** Enable UART with default 8N1 frame format for command interface

### Step 12 — RF Front-End Init
- **Register:** `RF_LNA_CTRL` at `0x0700`
- **Write value:** `0x01`
- **Wait/Poll:** Immediate
- **Rationale:** Enable HMC1099LP5E LNA with default gain setting (22dB) - RF front-end powered on

### Step 13 — ADC Init
- **Register:** `ADC_CTRL` at `0x0200`
- **Write value:** `0x21`
- **Wait/Poll:** Wait 1ms
- **Rationale:** Enable EV10AQ190A ADC in continuous mode with LVDS outputs active (START=1, CONT=1, LVDS=1)

### Step 14 — Temperature Monitor Init
- **Register:** `TEMP_ALERT_HIGH` at `0x0308`
- **Write value:** `0x0190`
- **Wait/Poll:** Immediate
- **Rationale:** Set over-temperature alert to 100°C (0x190 = 100 * 4)

### Step 15 — Temperature Monitor Init
- **Register:** `TEMP_ALERT_LOW` at `0x0309`
- **Write value:** `0xFF9C`
- **Wait/Poll:** Immediate
- **Rationale:** Set under-temperature alert to -25°C (two's complement) for cold-start protection

### Step 16 — Storage Init
- **Register:** `EEPROM_ADDR` at `0x0501`
- **Write value:** `0x0000`
- **Wait/Poll:** Immediate
- **Rationale:** Set EEPROM address to 0x0000 to read calibration data from start of user memory

### Step 17 — Storage Init
- **Register:** `EEPROM_CTRL` at `0x0500`
- **Write value:** `0x01`
- **Wait/Poll:** Poll until BUSY==0 then read EEPROM_DATA
- **Rationale:** Initiate EEPROM read to load factory calibration data (gain offsets, frequency corrections)

### Step 18 — System Ready
- **Register:** `HEALTH_STATUS` at `0x030F`
- **Write value:** `READ`
- **Wait/Poll:** Verify SYSTEM_OK==1, PLL_LOCK==1, ADC_OK==1
- **Rationale:** Final health check - all subsystems operational before entering mission mode
