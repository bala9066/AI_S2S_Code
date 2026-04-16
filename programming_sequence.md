# Programming Sequence (PSQ)
## kjk

> **Total steps:** 16

| # | Phase | Register | Address | Value | Condition | Rationale |
|---|-------|----------|---------|-------|-----------|-----------|
| 1 | Power-On Reset & Self-Check | `SCRATCHPAD` | `0x0003` | `0xA5A5` | Read back verify = 0xA5A5 | Write known pattern to SCRATCHPAD to verify RAM and UART communication path |
| 2 | Power-On Reset & Self-Check | `SCRATCHPAD` | `0x0003` | `0x5A5A` | Read back verify = 0x5A5A | Write inverted pattern to verify bit integrity |
| 3 | Power-On Reset & Self-Check | `BOARD_ID` | `0x0000` | `0x0000` | Verify BOARD_ID = 0x4B4A | Read and verify board identification matches expected kjk project code |
| 4 | Power-On Reset & Self-Check | `HEALTH_STATUS` | `0x030F` | `0x0000` | Poll until VOLT_OK=1 (bit 1) | Wait for all power rails to stabilize before proceeding |
| 5 | PLL & Clock Init | `PLL_N_DIV` | `0x0402` | `0x0064` | None | Configure PLL N divider to 100 for target output frequency |
| 6 | PLL & Clock Init | `PLL_R_DIV` | `0x0403` | `0x0001` | None | Configure PLL R divider to 1 (reference divider) |
| 7 | PLL & Clock Init | `PLL_CTRL` | `0x0400` | `0x01` | Poll PLL_STATUS bit 0 LOCKED=1 | Enable PLL and wait for lock confirmation |
| 8 | PLL & Clock Init | `CLK_ENABLE` | `0x0410` | `0x03` | None | Enable clock outputs 0 and 1 (system and ADC clocks) |
| 9 | Peripheral Enable | `TEMP_ALERT_HIGH` | `0x0308` | `0x0190` | None | Arm over-temperature alert at 100°C |
| 10 | Peripheral Enable | `TEMP_ALERT_LOW` | `0x0309` | `0xFF9C` | None | Arm under-temperature alert at -25°C |
| 11 | Peripheral Enable | `ADC_CTRL` | `0x0200` | `0x03` | None | Enable ADC in continuous mode for power monitoring |
| 12 | Communication Init | `UART_BAUD_DIV` | `0x0100` | `0x0034` | None | Configure UART baud rate divisor for 115200 baud at 100MHz |
| 13 | Communication Init | `UART_CTRL` | `0x0101` | `0x01` | None | Enable UART transmitter and receiver |
| 14 | Application Init | `RF_SYNTH_FREQ` | `0x0701` | `0x0BB8` | None | Set synthesizer to 3000 MHz (0x0BB8) for receiver LO |
| 15 | Application Init | `RF_SYNTH_CTRL` | `0x0700` | `0x03` | Poll RF_SYNTH_STATUS LOCKED=1 | Enable RF synthesizer and wait for lock |
| 16 | Application Init | `LNA_CTRL` | `0x0709` | `0x09` | None | Enable LNA with gain step 4 for optimal SNR |

---

## Detailed Steps

### Step 1 — Power-On Reset & Self-Check
- **Register:** `SCRATCHPAD` at `0x0003`
- **Write value:** `0xA5A5`
- **Wait/Poll:** Read back verify = 0xA5A5
- **Rationale:** Write known pattern to SCRATCHPAD to verify RAM and UART communication path

### Step 2 — Power-On Reset & Self-Check
- **Register:** `SCRATCHPAD` at `0x0003`
- **Write value:** `0x5A5A`
- **Wait/Poll:** Read back verify = 0x5A5A
- **Rationale:** Write inverted pattern to verify bit integrity

### Step 3 — Power-On Reset & Self-Check
- **Register:** `BOARD_ID` at `0x0000`
- **Write value:** `0x0000`
- **Wait/Poll:** Verify BOARD_ID = 0x4B4A
- **Rationale:** Read and verify board identification matches expected kjk project code

### Step 4 — Power-On Reset & Self-Check
- **Register:** `HEALTH_STATUS` at `0x030F`
- **Write value:** `0x0000`
- **Wait/Poll:** Poll until VOLT_OK=1 (bit 1)
- **Rationale:** Wait for all power rails to stabilize before proceeding

### Step 5 — PLL & Clock Init
- **Register:** `PLL_N_DIV` at `0x0402`
- **Write value:** `0x0064`
- **Wait/Poll:** None
- **Rationale:** Configure PLL N divider to 100 for target output frequency

### Step 6 — PLL & Clock Init
- **Register:** `PLL_R_DIV` at `0x0403`
- **Write value:** `0x0001`
- **Wait/Poll:** None
- **Rationale:** Configure PLL R divider to 1 (reference divider)

### Step 7 — PLL & Clock Init
- **Register:** `PLL_CTRL` at `0x0400`
- **Write value:** `0x01`
- **Wait/Poll:** Poll PLL_STATUS bit 0 LOCKED=1
- **Rationale:** Enable PLL and wait for lock confirmation

### Step 8 — PLL & Clock Init
- **Register:** `CLK_ENABLE` at `0x0410`
- **Write value:** `0x03`
- **Wait/Poll:** None
- **Rationale:** Enable clock outputs 0 and 1 (system and ADC clocks)

### Step 9 — Peripheral Enable
- **Register:** `TEMP_ALERT_HIGH` at `0x0308`
- **Write value:** `0x0190`
- **Wait/Poll:** None
- **Rationale:** Arm over-temperature alert at 100°C

### Step 10 — Peripheral Enable
- **Register:** `TEMP_ALERT_LOW` at `0x0309`
- **Write value:** `0xFF9C`
- **Wait/Poll:** None
- **Rationale:** Arm under-temperature alert at -25°C

### Step 11 — Peripheral Enable
- **Register:** `ADC_CTRL` at `0x0200`
- **Write value:** `0x03`
- **Wait/Poll:** None
- **Rationale:** Enable ADC in continuous mode for power monitoring

### Step 12 — Communication Init
- **Register:** `UART_BAUD_DIV` at `0x0100`
- **Write value:** `0x0034`
- **Wait/Poll:** None
- **Rationale:** Configure UART baud rate divisor for 115200 baud at 100MHz

### Step 13 — Communication Init
- **Register:** `UART_CTRL` at `0x0101`
- **Write value:** `0x01`
- **Wait/Poll:** None
- **Rationale:** Enable UART transmitter and receiver

### Step 14 — Application Init
- **Register:** `RF_SYNTH_FREQ` at `0x0701`
- **Write value:** `0x0BB8`
- **Wait/Poll:** None
- **Rationale:** Set synthesizer to 3000 MHz (0x0BB8) for receiver LO

### Step 15 — Application Init
- **Register:** `RF_SYNTH_CTRL` at `0x0700`
- **Write value:** `0x03`
- **Wait/Poll:** Poll RF_SYNTH_STATUS LOCKED=1
- **Rationale:** Enable RF synthesizer and wait for lock

### Step 16 — Application Init
- **Register:** `LNA_CTRL` at `0x0709`
- **Write value:** `0x09`
- **Wait/Poll:** None
- **Rationale:** Enable LNA with gain step 4 for optimal SNR
