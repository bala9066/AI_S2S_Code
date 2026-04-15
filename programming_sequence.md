# Programming Sequence (PSQ)
## ajsfdvhjs

> **Total steps:** 23

| # | Phase | Register | Address | Value | Condition | Rationale |
|---|-------|----------|---------|-------|-----------|-----------|
| 1 | Power-On Reset & Self-Check | `SCRATCHPAD` | `0x0003` | `0xA5A5` | Read back verification | RAM self-test - write known pattern (0xA5A5) and read back to verify memory integrity of register interface |
| 2 | Power-On Reset & Self-Check | `SCRATCHPAD` | `0x0003` | `0x5A5A` | Read back verification | RAM self-test - write inverted pattern (0x5A5A) and verify to catch stuck-at faults |
| 3 | Power-On Reset & Self-Check | `BOARD_ID` | `0x0000` | `0x0000` | Verify == 0x4A52 | Verify board identification - confirm correct FPGA image and hardware variant |
| 4 | Power-On Reset & Self-Check | `HEALTH_STATUS` | `0x030F` | `0x0000` | Poll until VOLT_OK=1 | Wait for power rails to stabilize - must have all DC-DC converters within regulation before proceeding |
| 5 | PLL & Clock Init | `PLL_CTRL` | `0x0400` | `0x0002` | Wait 1ms | Assert PLL reset - ensure ADF5356 starts from known state |
| 6 | PLL & Clock Init | `PLL_CTRL` | `0x0400` | `0x0000` | Wait 100us | Release PLL reset - allow synthesizer to begin initialization sequence |
| 7 | PLL & Clock Init | `PLL_N_DIV` | `0x0404` | `0x00C8` | None | Configure N divider (200) - set for 12 GHz output from 60 MHz PFD |
| 8 | PLL & Clock Init | `PLL_R_DIV` | `0x0405` | `0x01` | None | Configure R divider (1) - reference scaler for selected reference clock |
| 9 | PLL & Clock Init | `PLL_FREQ_INT` | `0x0402` | `0x00B71B00` | None | Set target frequency to 12 GHz (0x00B71B00 = 12,000,000 Hz) |
| 10 | PLL & Clock Init | `PLL_CTRL` | `0x0400` | `0x0001` | Poll PLL_STATUS[LOCKED]=1 | Enable PLL and wait for lock - critical for RF chain functionality |
| 11 | PLL & Clock Init | `CLK_ENABLE` | `0x0410` | `0x0007` | None | Enable clock outputs - REF, ADC sampling clock, and FPGA JESD204B clock |
| 12 | Peripheral Enable | `RF_CTRL` | `0x0700` | `0x0001` | Wait 500us | Enable RF input path - assert PE4259 switch control to RF_IN position |
| 13 | Peripheral Enable | `RF_LNA_GAIN` | `0x0701` | `0x0008` | None | Set TGA4943 LNA gain to medium setting (8 of 16) - establish nominal gain |
| 14 | Peripheral Enable | `RF_MIXER_CTRL` | `0x0702` | `0x0001` | None | Enable HMC1119 IQ demodulator - activate downconversion chain |
| 15 | Communication Init | `UART_BAUD_DIV` | `0x0100` | `0x0034` | None | Configure UART baud rate to 115200 (divisor 52 @ 16MHz) - standard debug interface |
| 16 | Communication Init | `UART_CTRL` | `0x0101` | `0x0001` | None | Enable UART interface - activate command/response communication channel |
| 17 | Communication Init | `SPI_PLL_CTRL` | `0x0108` | `0x0011` | None | Enable SPI interface to ADF5356 PLL - allow fine-tuning and reconfiguration |
| 18 | Communication Init | `SPI_ADC_CTRL` | `0x0109` | `0x0011` | None | Enable SPI interface to AD9208 ADC - configure JESD204B link parameters |
| 19 | Application Init | `TEMP_ALERT_HIGH` | `0x0308` | `0x0190` | None | Set over-temperature threshold to 100°C - protect RF components from thermal damage |
| 20 | Application Init | `TEMP_ALERT_LOW` | `0x0309` | `0xFF9C` | None | Set under-temperature threshold to -25°C - prevent operation below minimum rated temperature |
| 21 | Application Init | `JESD_CTRL` | `0x0800` | `0x0001` | Poll JESD_LINK_OK=1 | Initialize JESD204B link - wait for code group sync and lane alignment |
| 22 | Application Init | `ADC_CTRL` | `0x0200` | `0x0001` | Poll DATA_READY=1 | Start internal ADC monitoring - verify supply voltage readings are available |
| 23 | Application Init | `HEALTH_STATUS` | `0x030F` | `0x0000` | Verify SYSTEM_OK=1 | Final health check - confirm all subsystems report nominal before entering normal operation |

---

## Detailed Steps

### Step 1 — Power-On Reset & Self-Check
- **Register:** `SCRATCHPAD` at `0x0003`
- **Write value:** `0xA5A5`
- **Wait/Poll:** Read back verification
- **Rationale:** RAM self-test - write known pattern (0xA5A5) and read back to verify memory integrity of register interface

### Step 2 — Power-On Reset & Self-Check
- **Register:** `SCRATCHPAD` at `0x0003`
- **Write value:** `0x5A5A`
- **Wait/Poll:** Read back verification
- **Rationale:** RAM self-test - write inverted pattern (0x5A5A) and verify to catch stuck-at faults

### Step 3 — Power-On Reset & Self-Check
- **Register:** `BOARD_ID` at `0x0000`
- **Write value:** `0x0000`
- **Wait/Poll:** Verify == 0x4A52
- **Rationale:** Verify board identification - confirm correct FPGA image and hardware variant

### Step 4 — Power-On Reset & Self-Check
- **Register:** `HEALTH_STATUS` at `0x030F`
- **Write value:** `0x0000`
- **Wait/Poll:** Poll until VOLT_OK=1
- **Rationale:** Wait for power rails to stabilize - must have all DC-DC converters within regulation before proceeding

### Step 5 — PLL & Clock Init
- **Register:** `PLL_CTRL` at `0x0400`
- **Write value:** `0x0002`
- **Wait/Poll:** Wait 1ms
- **Rationale:** Assert PLL reset - ensure ADF5356 starts from known state

### Step 6 — PLL & Clock Init
- **Register:** `PLL_CTRL` at `0x0400`
- **Write value:** `0x0000`
- **Wait/Poll:** Wait 100us
- **Rationale:** Release PLL reset - allow synthesizer to begin initialization sequence

### Step 7 — PLL & Clock Init
- **Register:** `PLL_N_DIV` at `0x0404`
- **Write value:** `0x00C8`
- **Wait/Poll:** None
- **Rationale:** Configure N divider (200) - set for 12 GHz output from 60 MHz PFD

### Step 8 — PLL & Clock Init
- **Register:** `PLL_R_DIV` at `0x0405`
- **Write value:** `0x01`
- **Wait/Poll:** None
- **Rationale:** Configure R divider (1) - reference scaler for selected reference clock

### Step 9 — PLL & Clock Init
- **Register:** `PLL_FREQ_INT` at `0x0402`
- **Write value:** `0x00B71B00`
- **Wait/Poll:** None
- **Rationale:** Set target frequency to 12 GHz (0x00B71B00 = 12,000,000 Hz)

### Step 10 — PLL & Clock Init
- **Register:** `PLL_CTRL` at `0x0400`
- **Write value:** `0x0001`
- **Wait/Poll:** Poll PLL_STATUS[LOCKED]=1
- **Rationale:** Enable PLL and wait for lock - critical for RF chain functionality

### Step 11 — PLL & Clock Init
- **Register:** `CLK_ENABLE` at `0x0410`
- **Write value:** `0x0007`
- **Wait/Poll:** None
- **Rationale:** Enable clock outputs - REF, ADC sampling clock, and FPGA JESD204B clock

### Step 12 — Peripheral Enable
- **Register:** `RF_CTRL` at `0x0700`
- **Write value:** `0x0001`
- **Wait/Poll:** Wait 500us
- **Rationale:** Enable RF input path - assert PE4259 switch control to RF_IN position

### Step 13 — Peripheral Enable
- **Register:** `RF_LNA_GAIN` at `0x0701`
- **Write value:** `0x0008`
- **Wait/Poll:** None
- **Rationale:** Set TGA4943 LNA gain to medium setting (8 of 16) - establish nominal gain

### Step 14 — Peripheral Enable
- **Register:** `RF_MIXER_CTRL` at `0x0702`
- **Write value:** `0x0001`
- **Wait/Poll:** None
- **Rationale:** Enable HMC1119 IQ demodulator - activate downconversion chain

### Step 15 — Communication Init
- **Register:** `UART_BAUD_DIV` at `0x0100`
- **Write value:** `0x0034`
- **Wait/Poll:** None
- **Rationale:** Configure UART baud rate to 115200 (divisor 52 @ 16MHz) - standard debug interface

### Step 16 — Communication Init
- **Register:** `UART_CTRL` at `0x0101`
- **Write value:** `0x0001`
- **Wait/Poll:** None
- **Rationale:** Enable UART interface - activate command/response communication channel

### Step 17 — Communication Init
- **Register:** `SPI_PLL_CTRL` at `0x0108`
- **Write value:** `0x0011`
- **Wait/Poll:** None
- **Rationale:** Enable SPI interface to ADF5356 PLL - allow fine-tuning and reconfiguration

### Step 18 — Communication Init
- **Register:** `SPI_ADC_CTRL` at `0x0109`
- **Write value:** `0x0011`
- **Wait/Poll:** None
- **Rationale:** Enable SPI interface to AD9208 ADC - configure JESD204B link parameters

### Step 19 — Application Init
- **Register:** `TEMP_ALERT_HIGH` at `0x0308`
- **Write value:** `0x0190`
- **Wait/Poll:** None
- **Rationale:** Set over-temperature threshold to 100°C - protect RF components from thermal damage

### Step 20 — Application Init
- **Register:** `TEMP_ALERT_LOW` at `0x0309`
- **Write value:** `0xFF9C`
- **Wait/Poll:** None
- **Rationale:** Set under-temperature threshold to -25°C - prevent operation below minimum rated temperature

### Step 21 — Application Init
- **Register:** `JESD_CTRL` at `0x0800`
- **Write value:** `0x0001`
- **Wait/Poll:** Poll JESD_LINK_OK=1
- **Rationale:** Initialize JESD204B link - wait for code group sync and lane alignment

### Step 22 — Application Init
- **Register:** `ADC_CTRL` at `0x0200`
- **Write value:** `0x0001`
- **Wait/Poll:** Poll DATA_READY=1
- **Rationale:** Start internal ADC monitoring - verify supply voltage readings are available

### Step 23 — Application Init
- **Register:** `HEALTH_STATUS` at `0x030F`
- **Write value:** `0x0000`
- **Wait/Poll:** Verify SYSTEM_OK=1
- **Rationale:** Final health check - confirm all subsystems report nominal before entering normal operation
