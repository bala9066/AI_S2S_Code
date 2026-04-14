# Programming Sequence (PSQ)
## rbhjdaz

> **Total steps:** 23

| # | Phase | Register | Address | Value | Condition | Rationale |
|---|-------|----------|---------|-------|-----------|-----------|
| 1 | Power-On Reset & Self-Check | `SCRATCHPAD` | `0x0003` | `0xA5A5` | — | RAM integrity check - write known pattern and verify on readback (later step) |
| 2 | Power-On Reset & Self-Check | `SCRATCHPAD` | `0x0003` | `0x0000` | Wait for readback of 0xA5A5 before write | Verify scratchpad readback matches pattern 0xA5A5, then clear to 0x0000 to confirm R/W integrity |
| 3 | Power-On Reset & Self-Check | `HEALTH_STATUS` | `0x0703` | `0x0000` | Poll until VOLT_OK=1 | Poll HEALTH_STATUS register until VOLT_OK bit[1]=1, confirming all DC rails (5V/3.3V/1.8V/1.2V) are within tolerance |
| 4 | Power-On Reset & Self-Check | `BOARD_ID` | `0x0000` | `0x5242` | — | Verify BOARD_ID reads 0x5242 ('RB') - confirms correct FPGA/MCU firmware is loaded and UART interface functional |
| 5 | Clock Init | `CLKGEN_PLL1_N` | `0x0403` | `0x0020` | — | Configure LMK04828 PLL1 N divider to 32 for external 10MHz reference multiplication |
| 6 | Clock Init | `CLKGEN_CTRL` | `0x0400` | `0x01` | Poll CLKGEN_STATUS[PLL1_LOCK]=1 | Enable LMK04828 clock generator, wait for PLL1 lock confirmation before enabling outputs |
| 7 | Clock Init | `CLK_OUT_ENABLE` | `0x0402` | `0x0F` | — | Enable all 4 clock outputs (CLKout0-3) for ADF5355 reference and ADC clocks/SYSREF |
| 8 | PLL Frequency Synthesis | `PLL_INT` | `0x0300` | `0x00C8` | — | Set ADF5355 integer divider - value depends on target frequency (example: 200 for ~6.8GHz LO) |
| 9 | PLL Frequency Synthesis | `PLL_FRAC` | `0x0301` | `0x0000` | — | Set fractional divider to 0 for integer mode (or program for fine frequency resolution) |
| 10 | PLL Frequency Synthesis | `PLL_MOD` | `0x0302` | `0x0080` | — | Set fractional modulus to 128 (2^7) for fractional synthesis resolution |
| 11 | PLL Frequency Synthesis | `PLL_CTRL` | `0x0303` | `0x01` | Poll PLL_STATUS[LOCKED]=1 | Enable ADF5355 PLL, wait for lock detect before enabling RF front-end |
| 12 | RF Front-End Init | `RF_FRONT_END_CTRL` | `0x0202` | `0x0F` | — | Enable RF chain: LNA, both mixers, and IF amplifier for signal path activation |
| 13 | RF Front-End Init | `VGA1_GAIN` | `0x0200` | `0x9F` | — | Set VGA1 to mid-gain (0x1F) with enable (bit7=1) - 31dB gain position |
| 14 | RF Front-End Init | `VGA2_GAIN` | `0x0201` | `0x9F` | — | Set VGA2 to mid-gain (0x1F) with enable (bit7=1) - 31dB gain position |
| 15 | ADC JESD Init | `ADC_JESD_CTRL` | `0x0500` | `0x03` | — | Enable JESD204B interface with Subclass 1 (SYSREF synchronized) for deterministic latency |
| 16 | ADC JESD Init | `ADC_JESD_STATUS` | `0x0501` | `0x0000` | Poll until LINK_LOCKED=1 and CODE_GROUP_SYNC=1 | Wait for JESD204B link to lock and code group sync to complete before enabling data capture |
| 17 | Communication Init | `UART_BAUD_DIV` | `0x0100` | `0x0034` | — | Configure UART for 115200 baud (divisor 0x34 = 52 @ 16MHz base clock) |
| 18 | Communication Init | `UART_CTRL` | `0x0101` | `0x01` | — | Enable UART for control interface communication (disable loopback) |
| 19 | Application Init | `EEPROM_ADDR` | `0x0801` | `0x0000` | — | Set EEPROM address to 0x0000 to read factory calibration data |
| 20 | Application Init | `EEPROM_CTRL` | `0x0800` | `0x01` | Wait until BUSY=0, then read EEPROM_DATA | Initiate EEPROM read of calibration data, wait for completion, retrieve data from EEPROM_DATA register |
| 21 | Application Init | `TEMP_ALERT_HIGH` | `0x0701` | `0x0190` | — | Arm over-temperature alert threshold at 100°C (0x190 in 0.25°C units) |
| 22 | Application Init | `TEMP_ALERT_LOW` | `0x0702` | `0xFF9C` | — | Arm under-temperature alert threshold at -25°C (0xFF9C as signed 10-bit) |
| 23 | Application Init | `HEALTH_STATUS` | `0x0703` | `0x0000` | Verify SYSTEM_OK=1 | Final health check - verify SYSTEM_OK bit[7]=1 indicating all subsystems operational |

---

## Detailed Steps

### Step 1 — Power-On Reset & Self-Check
- **Register:** `SCRATCHPAD` at `0x0003`
- **Write value:** `0xA5A5`
- **Rationale:** RAM integrity check - write known pattern and verify on readback (later step)

### Step 2 — Power-On Reset & Self-Check
- **Register:** `SCRATCHPAD` at `0x0003`
- **Write value:** `0x0000`
- **Wait/Poll:** Wait for readback of 0xA5A5 before write
- **Rationale:** Verify scratchpad readback matches pattern 0xA5A5, then clear to 0x0000 to confirm R/W integrity

### Step 3 — Power-On Reset & Self-Check
- **Register:** `HEALTH_STATUS` at `0x0703`
- **Write value:** `0x0000`
- **Wait/Poll:** Poll until VOLT_OK=1
- **Rationale:** Poll HEALTH_STATUS register until VOLT_OK bit[1]=1, confirming all DC rails (5V/3.3V/1.8V/1.2V) are within tolerance

### Step 4 — Power-On Reset & Self-Check
- **Register:** `BOARD_ID` at `0x0000`
- **Write value:** `0x5242`
- **Rationale:** Verify BOARD_ID reads 0x5242 ('RB') - confirms correct FPGA/MCU firmware is loaded and UART interface functional

### Step 5 — Clock Init
- **Register:** `CLKGEN_PLL1_N` at `0x0403`
- **Write value:** `0x0020`
- **Rationale:** Configure LMK04828 PLL1 N divider to 32 for external 10MHz reference multiplication

### Step 6 — Clock Init
- **Register:** `CLKGEN_CTRL` at `0x0400`
- **Write value:** `0x01`
- **Wait/Poll:** Poll CLKGEN_STATUS[PLL1_LOCK]=1
- **Rationale:** Enable LMK04828 clock generator, wait for PLL1 lock confirmation before enabling outputs

### Step 7 — Clock Init
- **Register:** `CLK_OUT_ENABLE` at `0x0402`
- **Write value:** `0x0F`
- **Rationale:** Enable all 4 clock outputs (CLKout0-3) for ADF5355 reference and ADC clocks/SYSREF

### Step 8 — PLL Frequency Synthesis
- **Register:** `PLL_INT` at `0x0300`
- **Write value:** `0x00C8`
- **Rationale:** Set ADF5355 integer divider - value depends on target frequency (example: 200 for ~6.8GHz LO)

### Step 9 — PLL Frequency Synthesis
- **Register:** `PLL_FRAC` at `0x0301`
- **Write value:** `0x0000`
- **Rationale:** Set fractional divider to 0 for integer mode (or program for fine frequency resolution)

### Step 10 — PLL Frequency Synthesis
- **Register:** `PLL_MOD` at `0x0302`
- **Write value:** `0x0080`
- **Rationale:** Set fractional modulus to 128 (2^7) for fractional synthesis resolution

### Step 11 — PLL Frequency Synthesis
- **Register:** `PLL_CTRL` at `0x0303`
- **Write value:** `0x01`
- **Wait/Poll:** Poll PLL_STATUS[LOCKED]=1
- **Rationale:** Enable ADF5355 PLL, wait for lock detect before enabling RF front-end

### Step 12 — RF Front-End Init
- **Register:** `RF_FRONT_END_CTRL` at `0x0202`
- **Write value:** `0x0F`
- **Rationale:** Enable RF chain: LNA, both mixers, and IF amplifier for signal path activation

### Step 13 — RF Front-End Init
- **Register:** `VGA1_GAIN` at `0x0200`
- **Write value:** `0x9F`
- **Rationale:** Set VGA1 to mid-gain (0x1F) with enable (bit7=1) - 31dB gain position

### Step 14 — RF Front-End Init
- **Register:** `VGA2_GAIN` at `0x0201`
- **Write value:** `0x9F`
- **Rationale:** Set VGA2 to mid-gain (0x1F) with enable (bit7=1) - 31dB gain position

### Step 15 — ADC JESD Init
- **Register:** `ADC_JESD_CTRL` at `0x0500`
- **Write value:** `0x03`
- **Rationale:** Enable JESD204B interface with Subclass 1 (SYSREF synchronized) for deterministic latency

### Step 16 — ADC JESD Init
- **Register:** `ADC_JESD_STATUS` at `0x0501`
- **Write value:** `0x0000`
- **Wait/Poll:** Poll until LINK_LOCKED=1 and CODE_GROUP_SYNC=1
- **Rationale:** Wait for JESD204B link to lock and code group sync to complete before enabling data capture

### Step 17 — Communication Init
- **Register:** `UART_BAUD_DIV` at `0x0100`
- **Write value:** `0x0034`
- **Rationale:** Configure UART for 115200 baud (divisor 0x34 = 52 @ 16MHz base clock)

### Step 18 — Communication Init
- **Register:** `UART_CTRL` at `0x0101`
- **Write value:** `0x01`
- **Rationale:** Enable UART for control interface communication (disable loopback)

### Step 19 — Application Init
- **Register:** `EEPROM_ADDR` at `0x0801`
- **Write value:** `0x0000`
- **Rationale:** Set EEPROM address to 0x0000 to read factory calibration data

### Step 20 — Application Init
- **Register:** `EEPROM_CTRL` at `0x0800`
- **Write value:** `0x01`
- **Wait/Poll:** Wait until BUSY=0, then read EEPROM_DATA
- **Rationale:** Initiate EEPROM read of calibration data, wait for completion, retrieve data from EEPROM_DATA register

### Step 21 — Application Init
- **Register:** `TEMP_ALERT_HIGH` at `0x0701`
- **Write value:** `0x0190`
- **Rationale:** Arm over-temperature alert threshold at 100°C (0x190 in 0.25°C units)

### Step 22 — Application Init
- **Register:** `TEMP_ALERT_LOW` at `0x0702`
- **Write value:** `0xFF9C`
- **Rationale:** Arm under-temperature alert threshold at -25°C (0xFF9C as signed 10-bit)

### Step 23 — Application Init
- **Register:** `HEALTH_STATUS` at `0x0703`
- **Write value:** `0x0000`
- **Wait/Poll:** Verify SYSTEM_OK=1
- **Rationale:** Final health check - verify SYSTEM_OK bit[7]=1 indicating all subsystems operational
