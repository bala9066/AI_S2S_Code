# Programming Sequence (PSQ)
## rx module

> **Total steps:** 20

| # | Phase | Register | Address | Value | Condition | Rationale |
|---|-------|----------|---------|-------|-----------|-----------|
| 1 | Power-On Reset & Self-Check | `SCRATCHPAD` | `0x0003` | `0xAAAA` | — | Write test pattern 0xAAAA to SCRATCHPAD for RAM verification |
| 2 | Power-On Reset & Self-Check | `SCRATCHPAD` | `0x0003` | `0x5555` | Read back and verify = 0x5555 | Write inverted pattern 0x5555, toggle all bits for comprehensive memory test |
| 3 | Power-On Reset & Self-Check | `BOARD_ID` | `0x0000` | `0x5258` | Read back and verify = 0x5258 | Verify board identity matches expected value (ASCII 'RX') |
| 4 | Power-On Reset & Self-Check | `HEALTH_STATUS` | `0x030F` | `N/A` | Poll until VOLT_OK (bit1) = 1, timeout 500ms | Poll until all power rails are within tolerance |
| 5 | PLL & Clock Init | `PLL_CTRL` | `0x0400` | `0x02` | — | Assert PLL reset to clear any previous state |
| 6 | PLL & Clock Init | `PLL_N_DIV` | `0x0402` | `0x0020` | — | Configure N divider for desired output frequency (x32 multiplier) |
| 7 | PLL & Clock Init | `PLL_R_DIV` | `0x0403` | `0x01` | — | Configure R divider (reference divider = 1) |
| 8 | PLL & Clock Init | `PLL_CTRL` | `0x0400` | `0x01` | — | Release reset and enable PLL |
| 9 | PLL & Clock Init | `PLL_STATUS` | `0x0401` | `N/A` | Poll until LOCKED (bit0) = 1, timeout 100ms | Wait for PLL to achieve lock before enabling clocks |
| 10 | PLL & Clock Init | `CLK_ENABLE` | `0x0410` | `0x0F` | — | Enable all clock outputs (ADC, RF, JESD204B, system) |
| 11 | Peripheral Enable | `TEMP_ALERT_HIGH` | `0x0308` | `0x0190` | — | Arm over-temperature alert at 100°C |
| 12 | Peripheral Enable | `TEMP_ALERT_LOW` | `0x0309` | `0xFF9C` | — | Arm under-temperature alert at -25°C |
| 13 | Communication Init | `UART_BAUD_DIV` | `0x0100` | `0x0068` | — | Set baud rate divisor for 115200 baud @ 100MHz clk |
| 14 | Communication Init | `UART_CTRL` | `0x0101` | `0x31` | — | Enable UART with 8N1 frame format (bits 0 and 7:4) |
| 15 | Application Init | `JESD204B_CTRL` | `0x0A10` | `0x06` | — | Initialize JESD204B link in 2-lane, subclass 1 mode |
| 16 | Application Init | `JESD204B_STATUS` | `0x0A11` | `N/A` | Poll until LINK_READY (bit0) = 1, timeout 500ms | Wait for JESD204B link to achieve alignment |
| 17 | Application Init | `RF_GAIN_CTRL` | `0x0700` | `0xA0` | — | Enable RF frontend and set default VGA gain to ~32dB |
| 18 | Application Init | `RF_STATUS` | `0x0701` | `N/A` | Read and verify LNA_OK, MIXER_OK, IQ_DEMOD_OK = 1 | Verify all RF frontend components powered |
| 19 | Application Init | `ADC_CTRL` | `0x0200` | `0x14` | — | Enable ADC in continuous mode, capture both I and Q channels, enable JESD204B |
| 20 | Application Init | `HEALTH_STATUS` | `0x030F` | `N/A` | Verify SYSTEM_OK (bit7) = 1, otherwise raise alarm | Final system health check - all flags should be asserted |

---

## Detailed Steps

### Step 1 — Power-On Reset & Self-Check
- **Register:** `SCRATCHPAD` at `0x0003`
- **Write value:** `0xAAAA`
- **Rationale:** Write test pattern 0xAAAA to SCRATCHPAD for RAM verification

### Step 2 — Power-On Reset & Self-Check
- **Register:** `SCRATCHPAD` at `0x0003`
- **Write value:** `0x5555`
- **Wait/Poll:** Read back and verify = 0x5555
- **Rationale:** Write inverted pattern 0x5555, toggle all bits for comprehensive memory test

### Step 3 — Power-On Reset & Self-Check
- **Register:** `BOARD_ID` at `0x0000`
- **Write value:** `0x5258`
- **Wait/Poll:** Read back and verify = 0x5258
- **Rationale:** Verify board identity matches expected value (ASCII 'RX')

### Step 4 — Power-On Reset & Self-Check
- **Register:** `HEALTH_STATUS` at `0x030F`
- **Write value:** `N/A`
- **Wait/Poll:** Poll until VOLT_OK (bit1) = 1, timeout 500ms
- **Rationale:** Poll until all power rails are within tolerance

### Step 5 — PLL & Clock Init
- **Register:** `PLL_CTRL` at `0x0400`
- **Write value:** `0x02`
- **Rationale:** Assert PLL reset to clear any previous state

### Step 6 — PLL & Clock Init
- **Register:** `PLL_N_DIV` at `0x0402`
- **Write value:** `0x0020`
- **Rationale:** Configure N divider for desired output frequency (x32 multiplier)

### Step 7 — PLL & Clock Init
- **Register:** `PLL_R_DIV` at `0x0403`
- **Write value:** `0x01`
- **Rationale:** Configure R divider (reference divider = 1)

### Step 8 — PLL & Clock Init
- **Register:** `PLL_CTRL` at `0x0400`
- **Write value:** `0x01`
- **Rationale:** Release reset and enable PLL

### Step 9 — PLL & Clock Init
- **Register:** `PLL_STATUS` at `0x0401`
- **Write value:** `N/A`
- **Wait/Poll:** Poll until LOCKED (bit0) = 1, timeout 100ms
- **Rationale:** Wait for PLL to achieve lock before enabling clocks

### Step 10 — PLL & Clock Init
- **Register:** `CLK_ENABLE` at `0x0410`
- **Write value:** `0x0F`
- **Rationale:** Enable all clock outputs (ADC, RF, JESD204B, system)

### Step 11 — Peripheral Enable
- **Register:** `TEMP_ALERT_HIGH` at `0x0308`
- **Write value:** `0x0190`
- **Rationale:** Arm over-temperature alert at 100°C

### Step 12 — Peripheral Enable
- **Register:** `TEMP_ALERT_LOW` at `0x0309`
- **Write value:** `0xFF9C`
- **Rationale:** Arm under-temperature alert at -25°C

### Step 13 — Communication Init
- **Register:** `UART_BAUD_DIV` at `0x0100`
- **Write value:** `0x0068`
- **Rationale:** Set baud rate divisor for 115200 baud @ 100MHz clk

### Step 14 — Communication Init
- **Register:** `UART_CTRL` at `0x0101`
- **Write value:** `0x31`
- **Rationale:** Enable UART with 8N1 frame format (bits 0 and 7:4)

### Step 15 — Application Init
- **Register:** `JESD204B_CTRL` at `0x0A10`
- **Write value:** `0x06`
- **Rationale:** Initialize JESD204B link in 2-lane, subclass 1 mode

### Step 16 — Application Init
- **Register:** `JESD204B_STATUS` at `0x0A11`
- **Write value:** `N/A`
- **Wait/Poll:** Poll until LINK_READY (bit0) = 1, timeout 500ms
- **Rationale:** Wait for JESD204B link to achieve alignment

### Step 17 — Application Init
- **Register:** `RF_GAIN_CTRL` at `0x0700`
- **Write value:** `0xA0`
- **Rationale:** Enable RF frontend and set default VGA gain to ~32dB

### Step 18 — Application Init
- **Register:** `RF_STATUS` at `0x0701`
- **Write value:** `N/A`
- **Wait/Poll:** Read and verify LNA_OK, MIXER_OK, IQ_DEMOD_OK = 1
- **Rationale:** Verify all RF frontend components powered

### Step 19 — Application Init
- **Register:** `ADC_CTRL` at `0x0200`
- **Write value:** `0x14`
- **Rationale:** Enable ADC in continuous mode, capture both I and Q channels, enable JESD204B

### Step 20 — Application Init
- **Register:** `HEALTH_STATUS` at `0x030F`
- **Write value:** `N/A`
- **Wait/Poll:** Verify SYSTEM_OK (bit7) = 1, otherwise raise alarm
- **Rationale:** Final system health check - all flags should be asserted
