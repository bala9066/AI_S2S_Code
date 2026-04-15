# Programming Sequence (PSQ)
## uyj

> **Total steps:** 19

| # | Phase | Register | Address | Value | Condition | Rationale |
|---|-------|----------|---------|-------|-----------|-----------|
| 1 | Power-On Reset & Self-Check | `SCRATCHPAD` | `0x0003` | `0xA5A5` | Read back and verify | Verify UART interface integrity and register access by writing known pattern to SCRATCHPAD and reading back for confirmation. Detects communication failures before proceeding. |
| 2 | Power-On Reset & Self-Check | `BOARD_ID` | `0x0000` | `0x5559` | Verify against expected value | Confirm FPGA has loaded correct firmware for uyj project. BOARD_ID = 0x5559 ('UY' ASCII) validates correct bitstream. |
| 3 | Power-On Reset & Self-Check | `HEALTH_STATUS` | `0x030F` | `0x00` | Poll until VOLT_OK=1, timeout 1000ms | Wait for all power rails (12V→5V→3.3V→1.5V→1.2V→1.0V) to stabilize. VOLT_OK bit indicates LTC7891/TPS62913/LT3045 regulators are in regulation. |
| 4 | Power-On Reset & Self-Check | `TEMP_LOCAL` | `0x0300` | `0x0000` | Verify within operating range (-40 to +100°C) | Read FPGA die temperature before enabling RF front-end. Ensures thermal environment is safe for GaN LNA operation. |
| 5 | PLL & Clock Init | `PLL_CTRL` | `0x0400` | `0x02` | Hold for 1ms then clear to 0x00 | Assert PLL reset to clear any previous state. LMK04828B requires clean reset for deterministic lock after power cycle. |
| 6 | PLL & Clock Init | `PLL_N_DIV` | `0x0402` | `0x0064` | Write N=100 for 5.2GHz output | Configure N divider for 5.2 GHz JESD204B ADC clock (100 × 52 MHz reference). ADC12DJ5200RF requires deterministic sample clock. |
| 7 | PLL & Clock Init | `PLL_CTRL` | `0x0400` | `0x01` | Poll PLL_STATUS[LOCKED]=1, timeout 50ms | Enable PLL and wait for lock. LMK04828B lock time typically <10ms. Lock ensures ultra-low jitter for 12-bit ADC performance. |
| 8 | Peripheral Enable | `CLK_ENABLE` | `0x0410` | `0x0F` | Clock outputs now active | Enable all 4 clock outputs: CLK0→ADC_CLK, CLK1→FPGA_REFCLK, CLK2→SYSCLK, CLK3→JESD_REFCLK. JESD204B requires REFCLK before lane initialization. |
| 9 | Peripheral Enable | `RF_LNA_ENABLE` | `0x0701` | `0x07` | Verify RF_STATUS[RF_POWER_GOOD]=1 | Enable RF chain: LNA, limiter, and bias. Sequence enables protection first (limiter) then LNA bias before full LNA enable to prevent damage during transient. |
| 10 | Peripheral Enable | `ADC_CTRL` | `0x0200` | `0x03` | ADC_STATUS[DATA_READY] pulses | Enable ADC continuous monitoring mode. Initiates XADC/PMBus polling of all power rails for health status aggregation. |
| 11 | Communication Init | `UART_BAUD_DIV` | `0x0100` | `0x0068` | UART ready for commands | Configure UART for 115200 baud (divisor 104 at 100MHz UART_CLK). Default debug interface setting for host communication. |
| 12 | Communication Init | `TEMP_ALERT_HIGH` | `0x0308` | `0x0190` | Temperature armed | Arm over-temperature alert at 100°C. Protects GaN LNA and FPGA from thermal damage. 0x0190 = 100°C in 0.25°C units. |
| 13 | Application Init | `RF_VGA_GAIN` | `0x0700` | `0x8000` | Unlock gain register | Write unlock sequence (bit15=1) to enable HMC698LP4 VGA gain register writes. Prevents accidental gain changes from glitches. |
| 14 | Application Init | `RF_VGA_GAIN` | `0x0700` | `0x0040` | VGA gain set to mid-scale (default) | Set VGA gain code to 0x40 (mid-range, ~-15dB). Safe default gain level for initial operation. HMC698LP4 has 31.5dB range in 0.25dB steps. |
| 15 | Application Init | `JESD_CTRL` | `0x0A00` | `0x103` | Poll JESD_STATUS[LINK_ALIGN]=1, timeout 500ms | Enable JESD204B Subclass 1 link (deterministic latency) on all 8 lanes. Align lanes for coherent ADC data capture. Wait for code group sync and ILAS completion. |
| 16 | Application Init | `DDC_NCO_FREQ` | `0x0B01` | `0x0000` | Frequency tuning word loaded | Set DDC NCO frequency to 0 Hz (DC). Initializes frequency translator for digital down-conversion. FTW = f_out × 2^32 / f_sample. |
| 17 | Application Init | `DDC_NCO_FREQ_HIGH` | `0x0B02` | `0x0000` | Complete 32-bit FTW load | Load upper 16 bits of 32-bit NCO frequency tuning word. For DC (0 Hz), entire FTW = 0x00000000. |
| 18 | Application Init | `DDC_CTRL` | `0x0B00` | `0x11` | DDC enabled with 32× decimation | Enable DDC with decimation factor 32 (log2(32)=4 in bits[4:1]). Reduces 5.2 GSPS to 162.5 MSPS for downstream processing. |
| 19 | Application Init | `APP_CTRL` | `0x0F00` | `0x03` | System running, streaming data | Enable acquisition (bit0) and streaming (bit1). System now captures RF data and streams via DMA to host. Trigger mode set to free-run (default). |

---

## Detailed Steps

### Step 1 — Power-On Reset & Self-Check
- **Register:** `SCRATCHPAD` at `0x0003`
- **Write value:** `0xA5A5`
- **Wait/Poll:** Read back and verify
- **Rationale:** Verify UART interface integrity and register access by writing known pattern to SCRATCHPAD and reading back for confirmation. Detects communication failures before proceeding.

### Step 2 — Power-On Reset & Self-Check
- **Register:** `BOARD_ID` at `0x0000`
- **Write value:** `0x5559`
- **Wait/Poll:** Verify against expected value
- **Rationale:** Confirm FPGA has loaded correct firmware for uyj project. BOARD_ID = 0x5559 ('UY' ASCII) validates correct bitstream.

### Step 3 — Power-On Reset & Self-Check
- **Register:** `HEALTH_STATUS` at `0x030F`
- **Write value:** `0x00`
- **Wait/Poll:** Poll until VOLT_OK=1, timeout 1000ms
- **Rationale:** Wait for all power rails (12V→5V→3.3V→1.5V→1.2V→1.0V) to stabilize. VOLT_OK bit indicates LTC7891/TPS62913/LT3045 regulators are in regulation.

### Step 4 — Power-On Reset & Self-Check
- **Register:** `TEMP_LOCAL` at `0x0300`
- **Write value:** `0x0000`
- **Wait/Poll:** Verify within operating range (-40 to +100°C)
- **Rationale:** Read FPGA die temperature before enabling RF front-end. Ensures thermal environment is safe for GaN LNA operation.

### Step 5 — PLL & Clock Init
- **Register:** `PLL_CTRL` at `0x0400`
- **Write value:** `0x02`
- **Wait/Poll:** Hold for 1ms then clear to 0x00
- **Rationale:** Assert PLL reset to clear any previous state. LMK04828B requires clean reset for deterministic lock after power cycle.

### Step 6 — PLL & Clock Init
- **Register:** `PLL_N_DIV` at `0x0402`
- **Write value:** `0x0064`
- **Wait/Poll:** Write N=100 for 5.2GHz output
- **Rationale:** Configure N divider for 5.2 GHz JESD204B ADC clock (100 × 52 MHz reference). ADC12DJ5200RF requires deterministic sample clock.

### Step 7 — PLL & Clock Init
- **Register:** `PLL_CTRL` at `0x0400`
- **Write value:** `0x01`
- **Wait/Poll:** Poll PLL_STATUS[LOCKED]=1, timeout 50ms
- **Rationale:** Enable PLL and wait for lock. LMK04828B lock time typically <10ms. Lock ensures ultra-low jitter for 12-bit ADC performance.

### Step 8 — Peripheral Enable
- **Register:** `CLK_ENABLE` at `0x0410`
- **Write value:** `0x0F`
- **Wait/Poll:** Clock outputs now active
- **Rationale:** Enable all 4 clock outputs: CLK0→ADC_CLK, CLK1→FPGA_REFCLK, CLK2→SYSCLK, CLK3→JESD_REFCLK. JESD204B requires REFCLK before lane initialization.

### Step 9 — Peripheral Enable
- **Register:** `RF_LNA_ENABLE` at `0x0701`
- **Write value:** `0x07`
- **Wait/Poll:** Verify RF_STATUS[RF_POWER_GOOD]=1
- **Rationale:** Enable RF chain: LNA, limiter, and bias. Sequence enables protection first (limiter) then LNA bias before full LNA enable to prevent damage during transient.

### Step 10 — Peripheral Enable
- **Register:** `ADC_CTRL` at `0x0200`
- **Write value:** `0x03`
- **Wait/Poll:** ADC_STATUS[DATA_READY] pulses
- **Rationale:** Enable ADC continuous monitoring mode. Initiates XADC/PMBus polling of all power rails for health status aggregation.

### Step 11 — Communication Init
- **Register:** `UART_BAUD_DIV` at `0x0100`
- **Write value:** `0x0068`
- **Wait/Poll:** UART ready for commands
- **Rationale:** Configure UART for 115200 baud (divisor 104 at 100MHz UART_CLK). Default debug interface setting for host communication.

### Step 12 — Communication Init
- **Register:** `TEMP_ALERT_HIGH` at `0x0308`
- **Write value:** `0x0190`
- **Wait/Poll:** Temperature armed
- **Rationale:** Arm over-temperature alert at 100°C. Protects GaN LNA and FPGA from thermal damage. 0x0190 = 100°C in 0.25°C units.

### Step 13 — Application Init
- **Register:** `RF_VGA_GAIN` at `0x0700`
- **Write value:** `0x8000`
- **Wait/Poll:** Unlock gain register
- **Rationale:** Write unlock sequence (bit15=1) to enable HMC698LP4 VGA gain register writes. Prevents accidental gain changes from glitches.

### Step 14 — Application Init
- **Register:** `RF_VGA_GAIN` at `0x0700`
- **Write value:** `0x0040`
- **Wait/Poll:** VGA gain set to mid-scale (default)
- **Rationale:** Set VGA gain code to 0x40 (mid-range, ~-15dB). Safe default gain level for initial operation. HMC698LP4 has 31.5dB range in 0.25dB steps.

### Step 15 — Application Init
- **Register:** `JESD_CTRL` at `0x0A00`
- **Write value:** `0x103`
- **Wait/Poll:** Poll JESD_STATUS[LINK_ALIGN]=1, timeout 500ms
- **Rationale:** Enable JESD204B Subclass 1 link (deterministic latency) on all 8 lanes. Align lanes for coherent ADC data capture. Wait for code group sync and ILAS completion.

### Step 16 — Application Init
- **Register:** `DDC_NCO_FREQ` at `0x0B01`
- **Write value:** `0x0000`
- **Wait/Poll:** Frequency tuning word loaded
- **Rationale:** Set DDC NCO frequency to 0 Hz (DC). Initializes frequency translator for digital down-conversion. FTW = f_out × 2^32 / f_sample.

### Step 17 — Application Init
- **Register:** `DDC_NCO_FREQ_HIGH` at `0x0B02`
- **Write value:** `0x0000`
- **Wait/Poll:** Complete 32-bit FTW load
- **Rationale:** Load upper 16 bits of 32-bit NCO frequency tuning word. For DC (0 Hz), entire FTW = 0x00000000.

### Step 18 — Application Init
- **Register:** `DDC_CTRL` at `0x0B00`
- **Write value:** `0x11`
- **Wait/Poll:** DDC enabled with 32× decimation
- **Rationale:** Enable DDC with decimation factor 32 (log2(32)=4 in bits[4:1]). Reduces 5.2 GSPS to 162.5 MSPS for downstream processing.

### Step 19 — Application Init
- **Register:** `APP_CTRL` at `0x0F00`
- **Write value:** `0x03`
- **Wait/Poll:** System running, streaming data
- **Rationale:** Enable acquisition (bit0) and streaming (bit1). System now captures RF data and streams via DMA to host. Trigger mode set to free-run (default).
