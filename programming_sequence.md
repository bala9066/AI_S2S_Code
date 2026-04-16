# Programming Sequence (PSQ)
## dghb

> **Total steps:** 18

| # | Phase | Register | Address | Value | Condition | Rationale |
|---|-------|----------|---------|-------|-----------|-----------|
| 1 | Power-On Reset & Self-Check | `SCRATCHPAD` | `0x0003` | `0xA5A5` | Read back and verify 0xA5A5 | Memory integrity test - verify register read/write functionality after power-on reset |
| 2 | Power-On Reset & Self-Check | `SCRATCHPAD` | `0x0003` | `0x5A5A` | Read back and verify 0x5A5A | Second pattern test - catch stuck-at faults and verify full bus width |
| 3 | Power-On Reset & Self-Check | `BOARD_ID` | `0x0000` | `N/A` | Read and verify 0x4447 | Verify correct FPGA image loaded - board ID must match expected value 0x4447 ('DG') |
| 4 | Power-On Reset & Self-Check | `HEALTH_STATUS` | `0x030F` | `N/A` | Poll until VOLT_OK=1 (bit1=1) and PWR_GOOD=1 (bit7=1) | Wait for power rails to stabilize - LDO sequencing must complete before enabling peripherals |
| 5 | PLL & Clock Init | `PLL_CTRL` | `0x0400` | `0x01` | Wait 100us | Hold PLL in reset during configuration - ensure clean startup |
| 6 | PLL & Clock Init | `PLL_N_DIV` | `0x0402` | `0x0032` | None | Configure PLL N divider to 50 for target frequency (f_out = f_ref * N / R) |
| 7 | PLL & Clock Init | `PLL_R_DIV` | `0x0403` | `0x0001` | None | Configure PLL R divider to 1 - sets reference divider for PLL feedback loop |
| 8 | PLL & Clock Init | `PLL_CTRL` | `0x0400` | `0x03` | None | Enable PLL - release from reset (PLL_RESET=1, PLL_ENABLE=1 per GLR active-high logic) |
| 9 | PLL & Clock Init | `PLL_STATUS` | `0x0401` | `N/A` | Poll until LOCKED=1 (bit0=1) - timeout 100ms | Wait for PLL to achieve lock - critical timing for JESD204B SYSREF generation |
| 10 | PLL & Clock Init | `CLK_ENABLE` | `0x0410` | `0x1F` | None | Enable clock outputs: CLKOUT0-3 for ADC/FPGA, SYSREF for JESD204B synchronization |
| 11 | Peripheral Enable | `RF_VGA_GAIN` | `0x0700` | `0x0C00` | None | Initialize HMC698LP4 VGA to 0dB gain (0x0C) with output enabled - safe startup gain level |
| 12 | Peripheral Enable | `LED_STATUS` | `0x0803` | `0x09` | None | Initialize LED indicators: STATUS_LED and CLOCK_LOCK_LED ON, ERROR_LED OFF |
| 13 | Communication Init | `UART_BAUD_DIV` | `0x0100` | `0x0022` | None | Configure UART baud rate to 115200 bps (div=34 for 12MHz UART clock) |
| 14 | Communication Init | `SPI_CLK_CTRL` | `0x0108` | `0x001` | None | Configure SPI clock: f_clk/8 with CPOL=0, CPHA=0 for LMK04828 and HMC698LP4 compatibility |
| 15 | Application Init | `ADC_CTRL` | `0x0200` | `0x81` | None | Release ADC from soft reset and enable - SOFT_RESET=1 (inactive per GLR), ENABLE=1 |
| 16 | Application Init | `ADC_JESD_CFG` | `0x0202` | `0x0401` | None | Configure JESD204B: 4 lanes, Subclass 1, K=32 for SYSREF synchronization |
| 17 | Application Init | `ADC_CTRL` | `0x0200` | `0x83` | Poll ADC_STATUS until JESD_LOCKED=1 (bit2=1) | Enable JESD204B link and wait for code group sync - critical for data capture |
| 18 | Application Init | `TEMP_ALERT_HIGH` | `0x0308` | `0x8190` | None | Enable over-temperature alert at 100°C (0x190 * 0.25°C) - thermal protection |

---

## Detailed Steps

### Step 1 — Power-On Reset & Self-Check
- **Register:** `SCRATCHPAD` at `0x0003`
- **Write value:** `0xA5A5`
- **Wait/Poll:** Read back and verify 0xA5A5
- **Rationale:** Memory integrity test - verify register read/write functionality after power-on reset

### Step 2 — Power-On Reset & Self-Check
- **Register:** `SCRATCHPAD` at `0x0003`
- **Write value:** `0x5A5A`
- **Wait/Poll:** Read back and verify 0x5A5A
- **Rationale:** Second pattern test - catch stuck-at faults and verify full bus width

### Step 3 — Power-On Reset & Self-Check
- **Register:** `BOARD_ID` at `0x0000`
- **Write value:** `N/A`
- **Wait/Poll:** Read and verify 0x4447
- **Rationale:** Verify correct FPGA image loaded - board ID must match expected value 0x4447 ('DG')

### Step 4 — Power-On Reset & Self-Check
- **Register:** `HEALTH_STATUS` at `0x030F`
- **Write value:** `N/A`
- **Wait/Poll:** Poll until VOLT_OK=1 (bit1=1) and PWR_GOOD=1 (bit7=1)
- **Rationale:** Wait for power rails to stabilize - LDO sequencing must complete before enabling peripherals

### Step 5 — PLL & Clock Init
- **Register:** `PLL_CTRL` at `0x0400`
- **Write value:** `0x01`
- **Wait/Poll:** Wait 100us
- **Rationale:** Hold PLL in reset during configuration - ensure clean startup

### Step 6 — PLL & Clock Init
- **Register:** `PLL_N_DIV` at `0x0402`
- **Write value:** `0x0032`
- **Wait/Poll:** None
- **Rationale:** Configure PLL N divider to 50 for target frequency (f_out = f_ref * N / R)

### Step 7 — PLL & Clock Init
- **Register:** `PLL_R_DIV` at `0x0403`
- **Write value:** `0x0001`
- **Wait/Poll:** None
- **Rationale:** Configure PLL R divider to 1 - sets reference divider for PLL feedback loop

### Step 8 — PLL & Clock Init
- **Register:** `PLL_CTRL` at `0x0400`
- **Write value:** `0x03`
- **Wait/Poll:** None
- **Rationale:** Enable PLL - release from reset (PLL_RESET=1, PLL_ENABLE=1 per GLR active-high logic)

### Step 9 — PLL & Clock Init
- **Register:** `PLL_STATUS` at `0x0401`
- **Write value:** `N/A`
- **Wait/Poll:** Poll until LOCKED=1 (bit0=1) - timeout 100ms
- **Rationale:** Wait for PLL to achieve lock - critical timing for JESD204B SYSREF generation

### Step 10 — PLL & Clock Init
- **Register:** `CLK_ENABLE` at `0x0410`
- **Write value:** `0x1F`
- **Wait/Poll:** None
- **Rationale:** Enable clock outputs: CLKOUT0-3 for ADC/FPGA, SYSREF for JESD204B synchronization

### Step 11 — Peripheral Enable
- **Register:** `RF_VGA_GAIN` at `0x0700`
- **Write value:** `0x0C00`
- **Wait/Poll:** None
- **Rationale:** Initialize HMC698LP4 VGA to 0dB gain (0x0C) with output enabled - safe startup gain level

### Step 12 — Peripheral Enable
- **Register:** `LED_STATUS` at `0x0803`
- **Write value:** `0x09`
- **Wait/Poll:** None
- **Rationale:** Initialize LED indicators: STATUS_LED and CLOCK_LOCK_LED ON, ERROR_LED OFF

### Step 13 — Communication Init
- **Register:** `UART_BAUD_DIV` at `0x0100`
- **Write value:** `0x0022`
- **Wait/Poll:** None
- **Rationale:** Configure UART baud rate to 115200 bps (div=34 for 12MHz UART clock)

### Step 14 — Communication Init
- **Register:** `SPI_CLK_CTRL` at `0x0108`
- **Write value:** `0x001`
- **Wait/Poll:** None
- **Rationale:** Configure SPI clock: f_clk/8 with CPOL=0, CPHA=0 for LMK04828 and HMC698LP4 compatibility

### Step 15 — Application Init
- **Register:** `ADC_CTRL` at `0x0200`
- **Write value:** `0x81`
- **Wait/Poll:** None
- **Rationale:** Release ADC from soft reset and enable - SOFT_RESET=1 (inactive per GLR), ENABLE=1

### Step 16 — Application Init
- **Register:** `ADC_JESD_CFG` at `0x0202`
- **Write value:** `0x0401`
- **Wait/Poll:** None
- **Rationale:** Configure JESD204B: 4 lanes, Subclass 1, K=32 for SYSREF synchronization

### Step 17 — Application Init
- **Register:** `ADC_CTRL` at `0x0200`
- **Write value:** `0x83`
- **Wait/Poll:** Poll ADC_STATUS until JESD_LOCKED=1 (bit2=1)
- **Rationale:** Enable JESD204B link and wait for code group sync - critical for data capture

### Step 18 — Application Init
- **Register:** `TEMP_ALERT_HIGH` at `0x0308`
- **Write value:** `0x8190`
- **Wait/Poll:** None
- **Rationale:** Enable over-temperature alert at 100°C (0x190 * 0.25°C) - thermal protection
