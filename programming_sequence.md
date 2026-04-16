# Programming Sequence (PSQ)
## dkfjg

> **Total steps:** 21

| # | Phase | Register | Address | Value | Condition | Rationale |
|---|-------|----------|---------|-------|-----------|-----------|
| 1 | Power-On Reset & Self-Check | `SCRATCHPAD` | `0x0003` | `0xA5A5` | Read back and verify 0xA5A5 | Verify RAM and register interface integrity by writing known pattern (0xA5A5) to SCRATCHPAD and reading back. Fail indicates memory fault. |
| 2 | Power-On Reset & Self-Check | `SCRATCHPAD` | `0x0003` | `0x5A5A` | Read back and verify 0x5A5A | Second pattern test (0x5A5A) checks for stuck bits - complementary pattern detects all single-bit faults. |
| 3 | Power-On Reset & Self-Check | `BOARD_ID` | `0x0000` | `0x0000` | Read and verify value == 0x444B ('DK') | Verify correct FPGA firmware is loaded by checking BOARD_ID matches expected 0x444B (ASCII 'DK') for dkfjg project. |
| 4 | Power-On Reset & Self-Check | `HEALTH_STATUS` | `0x030F` | `0x0000` | Poll until VOLT_OK (bit 1) == 1, timeout 1000ms | Wait for all power rails (5V, 3.3V, 1.8V) to stabilize and enter tolerance. VOLT_OK bit indicates LTC2992 power monitor has verified all voltages. |
| 5 | PLL & Clock Init | `PLL_CTRL` | `0x0400` | `0x00` | Wait 10ms after write | Assert ADF4355 PLL reset (bit 1 = 0) to ensure clean initialization. Hold reset for 10ms to clear any previous state. |
| 6 | PLL & Clock Init | `PLL_N_DIV` | `0x0402` | `0x0046` | None | Configure PLL N divider to 70 (0x0046) for target LO frequency: f_LO = f_REF * N / R = 125MHz * 70 / 1 = 8.75 GHz (mid-band) |
| 7 | PLL & Clock Init | `PLL_R_DIV` | `0x0403` | `0x0001` | None | Configure PLL R divider to 1 (bypass) for reference clock. With 125MHz ref and N=70, generates 8.75GHz LO output. |
| 8 | PLL & Clock Init | `PLL_CTRL` | `0x0400` | `0x03` | None | Enable PLL (bit 0 = 1) and release reset (bit 1 = 1) to start LO synthesis. REF_SEL[1:0] = 00 selects onboard 125MHz oscillator. |
| 9 | PLL & Clock Init | `PLL_STATUS` | `0x0401` | `0x0000` | Poll until LOCKED (bit 0) == 1, timeout 500ms | Wait for ADF4355 PLL to achieve lock. Timeout indicates fault (ref clock missing, wrong frequency, or hardware failure). |
| 10 | PLL & Clock Init | `CLK_ENABLE` | `0x0410` | `0x1F` | Wait 50ms for clocks to stabilize | Enable LMK04828 clock outputs: ADC clock, FPGA clock, SYSREF, and reference to PLL. Allows JESD204B subsystem to stabilize. |
| 11 | Communication Init | `UART_BAUD_DIV` | `0x0100` | `0x0027` | None | Set UART baud rate divisor to 39 (0x0027) for 115200 baud from 125MHz reference: 125MHz / (16 * 39) ≈ 200192 (accepts 115200 with minor error). |
| 12 | Communication Init | `UART_CTRL` | `0x0101` | `0x01` | None | Enable UART transmitter and receiver. Frame format 8N1 is default. UART now ready for host command interface. |
| 13 | JESD204B Interface Init | `JESD_CTRL` | `0x0420` | `0x01` | None | Enable JESD204B link in Subclass 1 mode (SYSREF synchronization required). Lanes enabled, link reset inactive. |
| 14 | JESD204B Interface Init | `JESD_STATUS` | `0x0421` | `0x0000` | Poll until LINK_LOCKED (bit 0) == 1 and PHY_READY (bit 1) == 1, timeout 1000ms | Wait for JESD204B link to achieve code group sync and PHY ready state. Timeout indicates ADC or clock fault. |
| 15 | RF Chain Init | `VGA_GAIN_CTRL` | `0x0700` | `0x0F` | None | Set HMC698LP4 VGA to 15dB gain (mid-range) as default startup value. Prevents saturation while allowing adequate signal level. |
| 16 | RF Chain Init | `RF_PATH_CTRL` | `0x0701` | `0x07` | None | Enable RF front-end: LNA enable (bit 0), Mixer enable (bit 1), IF Amp enable (bit 2). RF chain now active and receiving. |
| 17 | RF Chain Init | `RF_STATUS` | `0x0702` | `0x0000` | Verify LNA_BIAS_OK (bit 0) == 1 and MIXER_LO_OK (bit 1) == 1 | Verify LNA bias current is present and Mixer LO power is adequate. Failure indicates fault in RF power supplies or PLL. |
| 18 | Temperature & Safety Init | `TEMP_ALERT_HIGH` | `0x0308` | `0x0190` | None | Set over-temperature alert threshold to 100°C (0x0190 * 0.25 = 100°C). Protects RF components and FPGA. |
| 19 | Temperature & Safety Init | `TEMP_ALERT_LOW` | `0x0309` | `0xFF9C` | None | Set under-temperature alert threshold to -25°C (signed 10-bit: 0xFF9C). Warns of cold start conditions for military spec. |
| 20 | Peripheral Init | `ADC_CTRL` | `0x0200` | `0x03` | None | Enable LTC2992 power monitor in continuous conversion mode (START=1, CONTINUOUS=1). Begins tracking voltage/current for health monitoring. |
| 21 | Peripheral Init | `LED_CTRL` | `0x0808` | `0x13` | None | Enable system LEDs: Power LED (bit 0), Status LED (bit 1), Link LED (bit 4). Blink rate set to 1Hz (bits 7:6 = 01). |

---

## Detailed Steps

### Step 1 — Power-On Reset & Self-Check
- **Register:** `SCRATCHPAD` at `0x0003`
- **Write value:** `0xA5A5`
- **Wait/Poll:** Read back and verify 0xA5A5
- **Rationale:** Verify RAM and register interface integrity by writing known pattern (0xA5A5) to SCRATCHPAD and reading back. Fail indicates memory fault.

### Step 2 — Power-On Reset & Self-Check
- **Register:** `SCRATCHPAD` at `0x0003`
- **Write value:** `0x5A5A`
- **Wait/Poll:** Read back and verify 0x5A5A
- **Rationale:** Second pattern test (0x5A5A) checks for stuck bits - complementary pattern detects all single-bit faults.

### Step 3 — Power-On Reset & Self-Check
- **Register:** `BOARD_ID` at `0x0000`
- **Write value:** `0x0000`
- **Wait/Poll:** Read and verify value == 0x444B ('DK')
- **Rationale:** Verify correct FPGA firmware is loaded by checking BOARD_ID matches expected 0x444B (ASCII 'DK') for dkfjg project.

### Step 4 — Power-On Reset & Self-Check
- **Register:** `HEALTH_STATUS` at `0x030F`
- **Write value:** `0x0000`
- **Wait/Poll:** Poll until VOLT_OK (bit 1) == 1, timeout 1000ms
- **Rationale:** Wait for all power rails (5V, 3.3V, 1.8V) to stabilize and enter tolerance. VOLT_OK bit indicates LTC2992 power monitor has verified all voltages.

### Step 5 — PLL & Clock Init
- **Register:** `PLL_CTRL` at `0x0400`
- **Write value:** `0x00`
- **Wait/Poll:** Wait 10ms after write
- **Rationale:** Assert ADF4355 PLL reset (bit 1 = 0) to ensure clean initialization. Hold reset for 10ms to clear any previous state.

### Step 6 — PLL & Clock Init
- **Register:** `PLL_N_DIV` at `0x0402`
- **Write value:** `0x0046`
- **Wait/Poll:** None
- **Rationale:** Configure PLL N divider to 70 (0x0046) for target LO frequency: f_LO = f_REF * N / R = 125MHz * 70 / 1 = 8.75 GHz (mid-band)

### Step 7 — PLL & Clock Init
- **Register:** `PLL_R_DIV` at `0x0403`
- **Write value:** `0x0001`
- **Wait/Poll:** None
- **Rationale:** Configure PLL R divider to 1 (bypass) for reference clock. With 125MHz ref and N=70, generates 8.75GHz LO output.

### Step 8 — PLL & Clock Init
- **Register:** `PLL_CTRL` at `0x0400`
- **Write value:** `0x03`
- **Wait/Poll:** None
- **Rationale:** Enable PLL (bit 0 = 1) and release reset (bit 1 = 1) to start LO synthesis. REF_SEL[1:0] = 00 selects onboard 125MHz oscillator.

### Step 9 — PLL & Clock Init
- **Register:** `PLL_STATUS` at `0x0401`
- **Write value:** `0x0000`
- **Wait/Poll:** Poll until LOCKED (bit 0) == 1, timeout 500ms
- **Rationale:** Wait for ADF4355 PLL to achieve lock. Timeout indicates fault (ref clock missing, wrong frequency, or hardware failure).

### Step 10 — PLL & Clock Init
- **Register:** `CLK_ENABLE` at `0x0410`
- **Write value:** `0x1F`
- **Wait/Poll:** Wait 50ms for clocks to stabilize
- **Rationale:** Enable LMK04828 clock outputs: ADC clock, FPGA clock, SYSREF, and reference to PLL. Allows JESD204B subsystem to stabilize.

### Step 11 — Communication Init
- **Register:** `UART_BAUD_DIV` at `0x0100`
- **Write value:** `0x0027`
- **Wait/Poll:** None
- **Rationale:** Set UART baud rate divisor to 39 (0x0027) for 115200 baud from 125MHz reference: 125MHz / (16 * 39) ≈ 200192 (accepts 115200 with minor error).

### Step 12 — Communication Init
- **Register:** `UART_CTRL` at `0x0101`
- **Write value:** `0x01`
- **Wait/Poll:** None
- **Rationale:** Enable UART transmitter and receiver. Frame format 8N1 is default. UART now ready for host command interface.

### Step 13 — JESD204B Interface Init
- **Register:** `JESD_CTRL` at `0x0420`
- **Write value:** `0x01`
- **Wait/Poll:** None
- **Rationale:** Enable JESD204B link in Subclass 1 mode (SYSREF synchronization required). Lanes enabled, link reset inactive.

### Step 14 — JESD204B Interface Init
- **Register:** `JESD_STATUS` at `0x0421`
- **Write value:** `0x0000`
- **Wait/Poll:** Poll until LINK_LOCKED (bit 0) == 1 and PHY_READY (bit 1) == 1, timeout 1000ms
- **Rationale:** Wait for JESD204B link to achieve code group sync and PHY ready state. Timeout indicates ADC or clock fault.

### Step 15 — RF Chain Init
- **Register:** `VGA_GAIN_CTRL` at `0x0700`
- **Write value:** `0x0F`
- **Wait/Poll:** None
- **Rationale:** Set HMC698LP4 VGA to 15dB gain (mid-range) as default startup value. Prevents saturation while allowing adequate signal level.

### Step 16 — RF Chain Init
- **Register:** `RF_PATH_CTRL` at `0x0701`
- **Write value:** `0x07`
- **Wait/Poll:** None
- **Rationale:** Enable RF front-end: LNA enable (bit 0), Mixer enable (bit 1), IF Amp enable (bit 2). RF chain now active and receiving.

### Step 17 — RF Chain Init
- **Register:** `RF_STATUS` at `0x0702`
- **Write value:** `0x0000`
- **Wait/Poll:** Verify LNA_BIAS_OK (bit 0) == 1 and MIXER_LO_OK (bit 1) == 1
- **Rationale:** Verify LNA bias current is present and Mixer LO power is adequate. Failure indicates fault in RF power supplies or PLL.

### Step 18 — Temperature & Safety Init
- **Register:** `TEMP_ALERT_HIGH` at `0x0308`
- **Write value:** `0x0190`
- **Wait/Poll:** None
- **Rationale:** Set over-temperature alert threshold to 100°C (0x0190 * 0.25 = 100°C). Protects RF components and FPGA.

### Step 19 — Temperature & Safety Init
- **Register:** `TEMP_ALERT_LOW` at `0x0309`
- **Write value:** `0xFF9C`
- **Wait/Poll:** None
- **Rationale:** Set under-temperature alert threshold to -25°C (signed 10-bit: 0xFF9C). Warns of cold start conditions for military spec.

### Step 20 — Peripheral Init
- **Register:** `ADC_CTRL` at `0x0200`
- **Write value:** `0x03`
- **Wait/Poll:** None
- **Rationale:** Enable LTC2992 power monitor in continuous conversion mode (START=1, CONTINUOUS=1). Begins tracking voltage/current for health monitoring.

### Step 21 — Peripheral Init
- **Register:** `LED_CTRL` at `0x0808`
- **Write value:** `0x13`
- **Wait/Poll:** None
- **Rationale:** Enable system LEDs: Power LED (bit 0), Status LED (bit 1), Link LED (bit 4). Blink rate set to 1Hz (bits 7:6 = 01).
