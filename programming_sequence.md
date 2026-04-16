# Programming Sequence (PSQ)
## dfbvd

> **Total steps:** 18

| # | Phase | Register | Address | Value | Condition | Rationale |
|---|-------|----------|---------|-------|-----------|-----------|
| 1 | Phase 1: Power-On Reset & Self-Check | `SCRATCHPAD` | `0x0003` | `0xA5A5` | — | Perform RAM self-test - write known pattern to SCRATCHPAD register to verify data bus integrity |
| 2 | Phase 1: Power-On Reset & Self-Check | `SCRATCHPAD` | `0x0003` | `0x0000` | Read back 0xA5A5 before clearing | Verify written pattern reads back correctly, then clear to complete memory test |
| 3 | Phase 1: Power-On Reset & Self-Check | `HEALTH_STATUS` | `0x030F` | `0x0000` | Poll until VOLT_OK=1 (bit 1 set) | Wait for power rails to stabilize - all DC-DC converters must reach regulation before proceeding |
| 4 | Phase 1: Power-On Reset & Self-Check | `BOARD_ID` | `0x0000` | `0x0000` | Verify read = 0xDFB0 | Confirm correct FPGA image is loaded - board ID must match expected value for dfbvd |
| 5 | Phase 2: PLL & Clock Init | `PLL_CTRL` | `0x0400` | `0x0002` | — | Assert PLL reset - ensure ADF5356 synthesizer starts from known state |
| 6 | Phase 2: PLL & Clock Init | `PLL_N_DIV` | `0x0402` | `0x0064` | — | Program PLL N divider value - sets main frequency multiplication factor (100 decimal) |
| 7 | Phase 2: PLL & Clock Init | `PLL_R_DIV` | `0x0403` | `0x0001` | — | Program PLL R divider value - reference divider set to 1 (no division) |
| 8 | Phase 2: PLL & Clock Init | `PLL_CTRL` | `0x0400` | `0x0001` | Poll PLL_STATUS bit 0 LOCKED=1 | Release PLL reset and enable - wait for ADF5356 to achieve lock before using LO |
| 9 | Phase 2: PLL & Clock Init | `CLK_ENABLE` | `0x0410` | `0x0007` | — | Enable all clock outputs - ADC clock, FPGA clock, and JESD204B SYSREF |
| 10 | Phase 3: Peripheral Enable | `TEMP_ALERT_HIGH` | `0x0308` | `0x0190` | — | Arm over-temperature alert at 100°C - protect RF components from thermal damage |
| 11 | Phase 3: Peripheral Enable | `TEMP_ALERT_LOW` | `0x0309` | `0xFF9C` | — | Arm under-temperature alert at -25°C - detect cold start conditions |
| 12 | Phase 3: Peripheral Enable | `ADC_CTRL` | `0x0200` | `0x0003` | — | Enable ADC in continuous sampling mode - start monitoring all power rails |
| 13 | Phase 4: Communication Init | `UART_BAUD_DIV` | `0x0100` | `0x0034` | — | Configure UART baud rate divisor - sets 115200 baud for standard host communication |
| 14 | Phase 4: Communication Init | `UART_CTRL` | `0x0101` | `0x0003` | — | Enable UART with 8N1 frame format - ready for command interface |
| 15 | Phase 5: RF Chain Init | `RF_LNA_CTRL` | `0x0700` | `0x0003` | — | Enable HMC1099LP4E LNA in high-gain mode - RF front end now active |
| 16 | Phase 5: RF Chain Init | `RF_VGA_GAIN` | `0x0701` | `0x0040` | — | Set ADL5202 VGA to mid-scale gain - allows AGC to adjust up or down as needed |
| 17 | Phase 5: RF Chain Init | `RF_MIXER_CTRL` | `0x0702` | `0x0003` | — | Enable HMC1022LP4E mixer and IF filter - downconversion path active |
| 18 | Phase 5: RF Chain Init | `RF_LO_FREQ_LOW` | `0x0710` | `0x0000` | Write all 3 LO freq words, then set LO_UPDATE=1 | Program ADF5356 LO frequency - low word of 48-bit frequency value |

---

## Detailed Steps

### Step 1 — Phase 1: Power-On Reset & Self-Check
- **Register:** `SCRATCHPAD` at `0x0003`
- **Write value:** `0xA5A5`
- **Rationale:** Perform RAM self-test - write known pattern to SCRATCHPAD register to verify data bus integrity

### Step 2 — Phase 1: Power-On Reset & Self-Check
- **Register:** `SCRATCHPAD` at `0x0003`
- **Write value:** `0x0000`
- **Wait/Poll:** Read back 0xA5A5 before clearing
- **Rationale:** Verify written pattern reads back correctly, then clear to complete memory test

### Step 3 — Phase 1: Power-On Reset & Self-Check
- **Register:** `HEALTH_STATUS` at `0x030F`
- **Write value:** `0x0000`
- **Wait/Poll:** Poll until VOLT_OK=1 (bit 1 set)
- **Rationale:** Wait for power rails to stabilize - all DC-DC converters must reach regulation before proceeding

### Step 4 — Phase 1: Power-On Reset & Self-Check
- **Register:** `BOARD_ID` at `0x0000`
- **Write value:** `0x0000`
- **Wait/Poll:** Verify read = 0xDFB0
- **Rationale:** Confirm correct FPGA image is loaded - board ID must match expected value for dfbvd

### Step 5 — Phase 2: PLL & Clock Init
- **Register:** `PLL_CTRL` at `0x0400`
- **Write value:** `0x0002`
- **Rationale:** Assert PLL reset - ensure ADF5356 synthesizer starts from known state

### Step 6 — Phase 2: PLL & Clock Init
- **Register:** `PLL_N_DIV` at `0x0402`
- **Write value:** `0x0064`
- **Rationale:** Program PLL N divider value - sets main frequency multiplication factor (100 decimal)

### Step 7 — Phase 2: PLL & Clock Init
- **Register:** `PLL_R_DIV` at `0x0403`
- **Write value:** `0x0001`
- **Rationale:** Program PLL R divider value - reference divider set to 1 (no division)

### Step 8 — Phase 2: PLL & Clock Init
- **Register:** `PLL_CTRL` at `0x0400`
- **Write value:** `0x0001`
- **Wait/Poll:** Poll PLL_STATUS bit 0 LOCKED=1
- **Rationale:** Release PLL reset and enable - wait for ADF5356 to achieve lock before using LO

### Step 9 — Phase 2: PLL & Clock Init
- **Register:** `CLK_ENABLE` at `0x0410`
- **Write value:** `0x0007`
- **Rationale:** Enable all clock outputs - ADC clock, FPGA clock, and JESD204B SYSREF

### Step 10 — Phase 3: Peripheral Enable
- **Register:** `TEMP_ALERT_HIGH` at `0x0308`
- **Write value:** `0x0190`
- **Rationale:** Arm over-temperature alert at 100°C - protect RF components from thermal damage

### Step 11 — Phase 3: Peripheral Enable
- **Register:** `TEMP_ALERT_LOW` at `0x0309`
- **Write value:** `0xFF9C`
- **Rationale:** Arm under-temperature alert at -25°C - detect cold start conditions

### Step 12 — Phase 3: Peripheral Enable
- **Register:** `ADC_CTRL` at `0x0200`
- **Write value:** `0x0003`
- **Rationale:** Enable ADC in continuous sampling mode - start monitoring all power rails

### Step 13 — Phase 4: Communication Init
- **Register:** `UART_BAUD_DIV` at `0x0100`
- **Write value:** `0x0034`
- **Rationale:** Configure UART baud rate divisor - sets 115200 baud for standard host communication

### Step 14 — Phase 4: Communication Init
- **Register:** `UART_CTRL` at `0x0101`
- **Write value:** `0x0003`
- **Rationale:** Enable UART with 8N1 frame format - ready for command interface

### Step 15 — Phase 5: RF Chain Init
- **Register:** `RF_LNA_CTRL` at `0x0700`
- **Write value:** `0x0003`
- **Rationale:** Enable HMC1099LP4E LNA in high-gain mode - RF front end now active

### Step 16 — Phase 5: RF Chain Init
- **Register:** `RF_VGA_GAIN` at `0x0701`
- **Write value:** `0x0040`
- **Rationale:** Set ADL5202 VGA to mid-scale gain - allows AGC to adjust up or down as needed

### Step 17 — Phase 5: RF Chain Init
- **Register:** `RF_MIXER_CTRL` at `0x0702`
- **Write value:** `0x0003`
- **Rationale:** Enable HMC1022LP4E mixer and IF filter - downconversion path active

### Step 18 — Phase 5: RF Chain Init
- **Register:** `RF_LO_FREQ_LOW` at `0x0710`
- **Write value:** `0x0000`
- **Wait/Poll:** Write all 3 LO freq words, then set LO_UPDATE=1
- **Rationale:** Program ADF5356 LO frequency - low word of 48-bit frequency value
