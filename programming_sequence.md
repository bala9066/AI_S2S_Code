# Programming Sequence (PSQ)
## khv

> **Total steps:** 21

| # | Phase | Register | Address | Value | Condition | Rationale |
|---|-------|----------|---------|-------|-----------|-----------|
| 1 | Power-On Reset & Self-Check | `SCRATCHPAD` | `0x0003` | `0xA5A5` | Read back and verify = 0xA5A5 | RAM sanity check - verify register read/write path is functional before proceeding |
| 2 | Power-On Reset & Self-Check | `SCRATCHPAD` | `0x0003` | `0x5A5A` | Read back and verify = 0x5A5A | Second pattern test to detect stuck bits |
| 3 | Power-On Reset & Self-Check | `BOARD_ID` | `0x0000` | `0x0000` | Verify = 0x4B48 (ASCII 'KH') | Confirm correct FPGA image is loaded and board identification matches expected value |
| 4 | Power-On Reset & Self-Check | `HEALTH_STATUS` | `0x030F` | `0x0000` | Poll until VOLT_OK=1 | Wait for all power rails (5V, 3.3V, 2.5V, 1.8V, 1.0V) to stabilize within tolerance before enabling peripherals |
| 5 | PLL & Clock Init | `PLL_CTRL` | `0x0400` | `0x0002` | Wait 10us | Assert PLL reset to ensure clean startup state |
| 6 | PLL & Clock Init | `PLL_N_DIV` | `0x0402` | `0x0064` | None | Configure PLL N divider = 100 for desired output frequency |
| 7 | PLL & Clock Init | `PLL_R_DIV` | `0x0403` | `0x000A` | None | Configure PLL R divider = 10 for reference clock scaling |
| 8 | PLL & Clock Init | `PLL_CTRL` | `0x0400` | `0x0001` | Poll PLL_STATUS.LOCKED=1 | Enable PLL and wait for lock confirmation before using clock outputs |
| 9 | PLL & Clock Init | `CLK_ENABLE` | `0x0410` | `0x0F` | None | Enable clock outputs 0-3 for ADC, FPGA, and peripherals |
| 10 | Peripheral Enable | `TEMP_ALERT_HIGH` | `0x0308` | `0x0190` | None | Set over-temperature alert threshold to 100°C for military-range operation |
| 11 | Peripheral Enable | `TEMP_ALERT_LOW` | `0x0309` | `0xFF9C` | None | Set under-temperature alert threshold to -25°C for cold-start protection |
| 12 | Communication Init | `UART_BAUD_DIV` | `0x0100` | `0x0022` | None | Configure UART baud rate divisor for 115200 bps (assuming 100MHz reference clock) |
| 13 | Communication Init | `UART_CTRL` | `0x0101` | `0x03` | None | Enable UART with 8N1 frame format (ENABLE=1, FRAME_FORMAT=0x3) |
| 14 | Application Init - Clock Synthesizer | `SPI_CLKGEN_CTRL` | `0x0706` | `0x01` | Poll SPI_CLKGEN_STATUS.PLL1_LOCK=1 | Enable SPI interface to LMK04828 and verify PLL1 lock status |
| 15 | Application Init - Clock Synthesizer | `SPI_CLKGEN_CTRL` | `0x0706` | `0x11` | None | Enable SYNC output to ADC for deterministic JESD204B lane alignment |
| 16 | Application Init - RF Front-End | `RF_FRONT_CTRL` | `0x0700` | `0x03` | Poll RF_FRONT_STATUS.LNA_OK=1 and VGA_OK=1 | Enable LNA and VGA power rails; verify power-good indications before proceeding |
| 17 | Application Init - RF Front-End | `RF_FRONT_CTRL` | `0x0700` | `0x33` | None | Set initial VGA gain code to 3 (mid-range gain) for startup |
| 18 | Application Init - ADC Interface | `ADC_JESD_CTRL` | `0x0702` | `0x01` | Wait 100ms for ADC power-up | Enable ADC core power supply; allow sufficient time for internal bias stabilization |
| 19 | Application Init - ADC Interface | `ADC_JESD_CTRL` | `0x0702` | `0x15` | Poll ADC_JESD_STATUS.LINK_LOCKED=1 | Enable JESD204B link (LANES_ENABLE=0x5 for 2 lanes) and wait for code group sync and link lock |
| 20 | Application Init - Data Capture | `ADC_DATA_CAPTURE_CTRL` | `0x0708` | `0x09` | None | Configure data capture in circular buffer mode with software trigger (CAPTURE_EN=1, BUFFER_MODE=0b00) |
| 21 | Final Verification | `HEALTH_STATUS` | `0x030F` | `0x0000` | Verify SYSTEM_OK=1 | Final health check - confirm all subsystems (TEMP_OK, VOLT_OK, PLL_LOCK, RF_FRONT_OK, ADC_LINK_OK) are operational |

---

## Detailed Steps

### Step 1 — Power-On Reset & Self-Check
- **Register:** `SCRATCHPAD` at `0x0003`
- **Write value:** `0xA5A5`
- **Wait/Poll:** Read back and verify = 0xA5A5
- **Rationale:** RAM sanity check - verify register read/write path is functional before proceeding

### Step 2 — Power-On Reset & Self-Check
- **Register:** `SCRATCHPAD` at `0x0003`
- **Write value:** `0x5A5A`
- **Wait/Poll:** Read back and verify = 0x5A5A
- **Rationale:** Second pattern test to detect stuck bits

### Step 3 — Power-On Reset & Self-Check
- **Register:** `BOARD_ID` at `0x0000`
- **Write value:** `0x0000`
- **Wait/Poll:** Verify = 0x4B48 (ASCII 'KH')
- **Rationale:** Confirm correct FPGA image is loaded and board identification matches expected value

### Step 4 — Power-On Reset & Self-Check
- **Register:** `HEALTH_STATUS` at `0x030F`
- **Write value:** `0x0000`
- **Wait/Poll:** Poll until VOLT_OK=1
- **Rationale:** Wait for all power rails (5V, 3.3V, 2.5V, 1.8V, 1.0V) to stabilize within tolerance before enabling peripherals

### Step 5 — PLL & Clock Init
- **Register:** `PLL_CTRL` at `0x0400`
- **Write value:** `0x0002`
- **Wait/Poll:** Wait 10us
- **Rationale:** Assert PLL reset to ensure clean startup state

### Step 6 — PLL & Clock Init
- **Register:** `PLL_N_DIV` at `0x0402`
- **Write value:** `0x0064`
- **Wait/Poll:** None
- **Rationale:** Configure PLL N divider = 100 for desired output frequency

### Step 7 — PLL & Clock Init
- **Register:** `PLL_R_DIV` at `0x0403`
- **Write value:** `0x000A`
- **Wait/Poll:** None
- **Rationale:** Configure PLL R divider = 10 for reference clock scaling

### Step 8 — PLL & Clock Init
- **Register:** `PLL_CTRL` at `0x0400`
- **Write value:** `0x0001`
- **Wait/Poll:** Poll PLL_STATUS.LOCKED=1
- **Rationale:** Enable PLL and wait for lock confirmation before using clock outputs

### Step 9 — PLL & Clock Init
- **Register:** `CLK_ENABLE` at `0x0410`
- **Write value:** `0x0F`
- **Wait/Poll:** None
- **Rationale:** Enable clock outputs 0-3 for ADC, FPGA, and peripherals

### Step 10 — Peripheral Enable
- **Register:** `TEMP_ALERT_HIGH` at `0x0308`
- **Write value:** `0x0190`
- **Wait/Poll:** None
- **Rationale:** Set over-temperature alert threshold to 100°C for military-range operation

### Step 11 — Peripheral Enable
- **Register:** `TEMP_ALERT_LOW` at `0x0309`
- **Write value:** `0xFF9C`
- **Wait/Poll:** None
- **Rationale:** Set under-temperature alert threshold to -25°C for cold-start protection

### Step 12 — Communication Init
- **Register:** `UART_BAUD_DIV` at `0x0100`
- **Write value:** `0x0022`
- **Wait/Poll:** None
- **Rationale:** Configure UART baud rate divisor for 115200 bps (assuming 100MHz reference clock)

### Step 13 — Communication Init
- **Register:** `UART_CTRL` at `0x0101`
- **Write value:** `0x03`
- **Wait/Poll:** None
- **Rationale:** Enable UART with 8N1 frame format (ENABLE=1, FRAME_FORMAT=0x3)

### Step 14 — Application Init - Clock Synthesizer
- **Register:** `SPI_CLKGEN_CTRL` at `0x0706`
- **Write value:** `0x01`
- **Wait/Poll:** Poll SPI_CLKGEN_STATUS.PLL1_LOCK=1
- **Rationale:** Enable SPI interface to LMK04828 and verify PLL1 lock status

### Step 15 — Application Init - Clock Synthesizer
- **Register:** `SPI_CLKGEN_CTRL` at `0x0706`
- **Write value:** `0x11`
- **Wait/Poll:** None
- **Rationale:** Enable SYNC output to ADC for deterministic JESD204B lane alignment

### Step 16 — Application Init - RF Front-End
- **Register:** `RF_FRONT_CTRL` at `0x0700`
- **Write value:** `0x03`
- **Wait/Poll:** Poll RF_FRONT_STATUS.LNA_OK=1 and VGA_OK=1
- **Rationale:** Enable LNA and VGA power rails; verify power-good indications before proceeding

### Step 17 — Application Init - RF Front-End
- **Register:** `RF_FRONT_CTRL` at `0x0700`
- **Write value:** `0x33`
- **Wait/Poll:** None
- **Rationale:** Set initial VGA gain code to 3 (mid-range gain) for startup

### Step 18 — Application Init - ADC Interface
- **Register:** `ADC_JESD_CTRL` at `0x0702`
- **Write value:** `0x01`
- **Wait/Poll:** Wait 100ms for ADC power-up
- **Rationale:** Enable ADC core power supply; allow sufficient time for internal bias stabilization

### Step 19 — Application Init - ADC Interface
- **Register:** `ADC_JESD_CTRL` at `0x0702`
- **Write value:** `0x15`
- **Wait/Poll:** Poll ADC_JESD_STATUS.LINK_LOCKED=1
- **Rationale:** Enable JESD204B link (LANES_ENABLE=0x5 for 2 lanes) and wait for code group sync and link lock

### Step 20 — Application Init - Data Capture
- **Register:** `ADC_DATA_CAPTURE_CTRL` at `0x0708`
- **Write value:** `0x09`
- **Wait/Poll:** None
- **Rationale:** Configure data capture in circular buffer mode with software trigger (CAPTURE_EN=1, BUFFER_MODE=0b00)

### Step 21 — Final Verification
- **Register:** `HEALTH_STATUS` at `0x030F`
- **Write value:** `0x0000`
- **Wait/Poll:** Verify SYSTEM_OK=1
- **Rationale:** Final health check - confirm all subsystems (TEMP_OK, VOLT_OK, PLL_LOCK, RF_FRONT_OK, ADC_LINK_OK) are operational
