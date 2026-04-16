# Programming Sequence (PSQ)
## rx receiver

> **Total steps:** 20

| # | Phase | Register | Address | Value | Condition | Rationale |
|---|-------|----------|---------|-------|-----------|-----------|
| 1 | Power-On Reset & Self-Check | `SCRATCHPAD` | `0x0003` | `0xAA55` | Read-back verify = 0xAA55 | Verify UART communication and RAM integrity. Write 0xAA55 pattern and read back to confirm address decode and data path functionality before proceeding with initialization. |
| 2 | Power-On Reset & Self-Check | `SCRATCHPAD` | `0x0003` | `0x55AA` | Read-back verify = 0x55AA | Second RAM integrity check with inverted pattern to detect stuck bits. Ensures reliable communication before configuring critical hardware. |
| 3 | Power-On Reset & Self-Check | `HEALTH_STATUS` | `0x030F` | `0x00 (Read)` | Poll until VOLT_OK=1 (bit[1]=1) | Wait for power supply rails to stabilize. The 5V and 3.3V buck converters (TPS54332, TPS62130) require ~1-2ms to reach regulation. MIC9430-44YM supervisor validates rail levels before asserting VOLT_OK. |
| 4 | Power-On Reset & Self-Check | `BOARD_ID` | `0x0000` | `0x5258 (Read)` | Verify BOARD_ID == 0x5258 ('RX') | Confirm correct FPGA image is loaded for rx receiver hardware. Prevents attempting to operate with incompatible firmware. |
| 5 | PLL & Clock Init | `PLL_CTRL` | `0x0400` | `0x02 (PLL_RESET=1)` | Hold for 10us | Assert PLL reset to ensure clean initialization of LMX2594 synthesizer. Clears any previous state and forces recalibration. |
| 6 | PLL & Clock Init | `PLL_N_DIV` | `0x0402` | `0x0064` | None (immediate write) | Program N divider for initial LO frequency. Default 0x0064 = 100. For 10MHz reference with R=1, output = 1GHz. Adjust based on desired RF downconversion frequency. |
| 7 | PLL & Clock Init | `PLL_R_DIV` | `0x0403` | `0x0001` | None (immediate write) | Configure R divider. Default 0x0001 = no division. f_out = (f_ref * N) / R = 10MHz * 100 / 1 = 1GHz LO output to mixers. |
| 8 | PLL & Clock Init | `PLL_CTRL` | `0x0400` | `0x01 (PLL_ENABLE=1, RESET=0)` | Poll PLL_STATUS[0] until LOCKED=1 (max 100ms) | Enable PLL and wait for lock. LMX2594 requires ~50ms typical to achieve lock and low phase noise. System cannot proceed with RF operation until lock is confirmed. |
| 9 | PLL & Clock Init | `CLK_ENABLE` | `0x0410` | `0x07 (CLK_ADC_EN=1, CLK_FPGA_EN=1, CLK_REF_EN=1)` | None (immediate write) | Enable clock outputs to ADC and FPGA processing logic. Clock distribution must be active before enabling ADC or RF front-end. |
| 10 | RF Front-End Init | `RF_LNA_CTRL` | `0x0700` | `0x01 (LNA_ENABLE=1, GAIN=0)` | Wait 1ms for LNA bias stabilization | Enable HMC6180LP4E LNA at low gain setting. LNA requires ~500us for bias networks to stabilize. Starting at low gain prevents overshoot. |
| 11 | RF Front-End Init | `RF_MIX_CTRL` | `0x0701` | `0x01 (MIX_ENABLE=1, BAND_SEL=0)` | None (immediate write) | Enable lower-band IQ demodulator (HMC519LC4) for 5-12GHz operation. Default to lower band; can switch to upper band (MIXIQ-1030) later by writing BAND_SEL=1. |
| 12 | ADC Interface Init | `ADC_IF_CTRL` | `0x0720` | `0x03 (ADC_ENABLE=1, JESD204B_EN=1)` | Poll ADC_IF_STATUS until JESD204B_LOCK=1 and CODE_GROUP_SYNC=1 | Enable AD9680 ADC and JESD204B interface. Link training requires ~5ms. Must achieve code group sync before valid I/Q data can be captured. |
| 13 | Communication Init | `UART_CTRL` | `0x0101` | `0x01 (UART_ENABLE=1, LOOPBACK=0, 8N1)` | None (immediate write) | Enable UART communication at default 8N1 format. Loopback disabled for normal operation. MCU can now send register read/write commands. |
| 14 | Communication Init | `UART_BAUD_DIV` | `0x0100` | `0x0034` | None (immediate write) | Set baud rate divisor for 115200 baud assuming 100MHz FPGA clock. 100MHz / (16 * 115200) ≈ 52.08 ≈ 0x34 (52 decimal). Adjust if using different reference clock. |
| 15 | Health Monitoring Init | `TEMP_ALERT_HIGH` | `0x0308` | `0x0190` | None (immediate write) | Set over-temperature alert threshold to 100°C (0x0190 * 0.25 = 100°C). Protects RF components (LNA, mixers) and FPGA from thermal damage. |
| 16 | Health Monitoring Init | `TEMP_ALERT_LOW` | `0x0309` | `0xFF9C` | None (immediate write) | Set under-temperature alert threshold to -25°C (0xFF9C signed = -100 * 0.25). Detects operating environment or cooling failures. |
| 17 | EEPROM/Calibration Init | `EEPROM_ADDR` | `0x0501` | `0x0000` | None (immediate write) | Set EEPROM address to start of calibration data region. Calibration data includes LNA gain trim, mixer I/Q balance offsets, and ADC error corrections. |
| 18 | EEPROM/Calibration Init | `EEPROM_CTRL` | `0x0500` | `0x01 (READ=1)` | Poll EEPROM_CTRL[7] until BUSY=0, then read EEPROM_DATA | Read calibration data from EEPROM. Apply calibration values to LNA gain, mixer phase control, and ADC offset correction registers. This optimizes SFDR and noise performance. |
| 19 | Application Start | `ADC_CTRL` | `0x0200` | `0x03 (START=1, CONT_MODE=1)` | None (immediate write) | Enable continuous ADC monitoring of power rails. Allows MCU to track VCC and ICC in real-time for health monitoring. |
| 20 | Application Start | `HEALTH_STATUS` | `0x030F` | `0x00 (Read)` | Verify SYSTEM_OK=1 (all checks passed) | Final system health check before entering normal operation mode. All subsystems (PLL, ADC, power, temperature) must be within limits. If SYSTEM_OK=1, receiver is ready for RF signal capture. |

---

## Detailed Steps

### Step 1 — Power-On Reset & Self-Check
- **Register:** `SCRATCHPAD` at `0x0003`
- **Write value:** `0xAA55`
- **Wait/Poll:** Read-back verify = 0xAA55
- **Rationale:** Verify UART communication and RAM integrity. Write 0xAA55 pattern and read back to confirm address decode and data path functionality before proceeding with initialization.

### Step 2 — Power-On Reset & Self-Check
- **Register:** `SCRATCHPAD` at `0x0003`
- **Write value:** `0x55AA`
- **Wait/Poll:** Read-back verify = 0x55AA
- **Rationale:** Second RAM integrity check with inverted pattern to detect stuck bits. Ensures reliable communication before configuring critical hardware.

### Step 3 — Power-On Reset & Self-Check
- **Register:** `HEALTH_STATUS` at `0x030F`
- **Write value:** `0x00 (Read)`
- **Wait/Poll:** Poll until VOLT_OK=1 (bit[1]=1)
- **Rationale:** Wait for power supply rails to stabilize. The 5V and 3.3V buck converters (TPS54332, TPS62130) require ~1-2ms to reach regulation. MIC9430-44YM supervisor validates rail levels before asserting VOLT_OK.

### Step 4 — Power-On Reset & Self-Check
- **Register:** `BOARD_ID` at `0x0000`
- **Write value:** `0x5258 (Read)`
- **Wait/Poll:** Verify BOARD_ID == 0x5258 ('RX')
- **Rationale:** Confirm correct FPGA image is loaded for rx receiver hardware. Prevents attempting to operate with incompatible firmware.

### Step 5 — PLL & Clock Init
- **Register:** `PLL_CTRL` at `0x0400`
- **Write value:** `0x02 (PLL_RESET=1)`
- **Wait/Poll:** Hold for 10us
- **Rationale:** Assert PLL reset to ensure clean initialization of LMX2594 synthesizer. Clears any previous state and forces recalibration.

### Step 6 — PLL & Clock Init
- **Register:** `PLL_N_DIV` at `0x0402`
- **Write value:** `0x0064`
- **Wait/Poll:** None (immediate write)
- **Rationale:** Program N divider for initial LO frequency. Default 0x0064 = 100. For 10MHz reference with R=1, output = 1GHz. Adjust based on desired RF downconversion frequency.

### Step 7 — PLL & Clock Init
- **Register:** `PLL_R_DIV` at `0x0403`
- **Write value:** `0x0001`
- **Wait/Poll:** None (immediate write)
- **Rationale:** Configure R divider. Default 0x0001 = no division. f_out = (f_ref * N) / R = 10MHz * 100 / 1 = 1GHz LO output to mixers.

### Step 8 — PLL & Clock Init
- **Register:** `PLL_CTRL` at `0x0400`
- **Write value:** `0x01 (PLL_ENABLE=1, RESET=0)`
- **Wait/Poll:** Poll PLL_STATUS[0] until LOCKED=1 (max 100ms)
- **Rationale:** Enable PLL and wait for lock. LMX2594 requires ~50ms typical to achieve lock and low phase noise. System cannot proceed with RF operation until lock is confirmed.

### Step 9 — PLL & Clock Init
- **Register:** `CLK_ENABLE` at `0x0410`
- **Write value:** `0x07 (CLK_ADC_EN=1, CLK_FPGA_EN=1, CLK_REF_EN=1)`
- **Wait/Poll:** None (immediate write)
- **Rationale:** Enable clock outputs to ADC and FPGA processing logic. Clock distribution must be active before enabling ADC or RF front-end.

### Step 10 — RF Front-End Init
- **Register:** `RF_LNA_CTRL` at `0x0700`
- **Write value:** `0x01 (LNA_ENABLE=1, GAIN=0)`
- **Wait/Poll:** Wait 1ms for LNA bias stabilization
- **Rationale:** Enable HMC6180LP4E LNA at low gain setting. LNA requires ~500us for bias networks to stabilize. Starting at low gain prevents overshoot.

### Step 11 — RF Front-End Init
- **Register:** `RF_MIX_CTRL` at `0x0701`
- **Write value:** `0x01 (MIX_ENABLE=1, BAND_SEL=0)`
- **Wait/Poll:** None (immediate write)
- **Rationale:** Enable lower-band IQ demodulator (HMC519LC4) for 5-12GHz operation. Default to lower band; can switch to upper band (MIXIQ-1030) later by writing BAND_SEL=1.

### Step 12 — ADC Interface Init
- **Register:** `ADC_IF_CTRL` at `0x0720`
- **Write value:** `0x03 (ADC_ENABLE=1, JESD204B_EN=1)`
- **Wait/Poll:** Poll ADC_IF_STATUS until JESD204B_LOCK=1 and CODE_GROUP_SYNC=1
- **Rationale:** Enable AD9680 ADC and JESD204B interface. Link training requires ~5ms. Must achieve code group sync before valid I/Q data can be captured.

### Step 13 — Communication Init
- **Register:** `UART_CTRL` at `0x0101`
- **Write value:** `0x01 (UART_ENABLE=1, LOOPBACK=0, 8N1)`
- **Wait/Poll:** None (immediate write)
- **Rationale:** Enable UART communication at default 8N1 format. Loopback disabled for normal operation. MCU can now send register read/write commands.

### Step 14 — Communication Init
- **Register:** `UART_BAUD_DIV` at `0x0100`
- **Write value:** `0x0034`
- **Wait/Poll:** None (immediate write)
- **Rationale:** Set baud rate divisor for 115200 baud assuming 100MHz FPGA clock. 100MHz / (16 * 115200) ≈ 52.08 ≈ 0x34 (52 decimal). Adjust if using different reference clock.

### Step 15 — Health Monitoring Init
- **Register:** `TEMP_ALERT_HIGH` at `0x0308`
- **Write value:** `0x0190`
- **Wait/Poll:** None (immediate write)
- **Rationale:** Set over-temperature alert threshold to 100°C (0x0190 * 0.25 = 100°C). Protects RF components (LNA, mixers) and FPGA from thermal damage.

### Step 16 — Health Monitoring Init
- **Register:** `TEMP_ALERT_LOW` at `0x0309`
- **Write value:** `0xFF9C`
- **Wait/Poll:** None (immediate write)
- **Rationale:** Set under-temperature alert threshold to -25°C (0xFF9C signed = -100 * 0.25). Detects operating environment or cooling failures.

### Step 17 — EEPROM/Calibration Init
- **Register:** `EEPROM_ADDR` at `0x0501`
- **Write value:** `0x0000`
- **Wait/Poll:** None (immediate write)
- **Rationale:** Set EEPROM address to start of calibration data region. Calibration data includes LNA gain trim, mixer I/Q balance offsets, and ADC error corrections.

### Step 18 — EEPROM/Calibration Init
- **Register:** `EEPROM_CTRL` at `0x0500`
- **Write value:** `0x01 (READ=1)`
- **Wait/Poll:** Poll EEPROM_CTRL[7] until BUSY=0, then read EEPROM_DATA
- **Rationale:** Read calibration data from EEPROM. Apply calibration values to LNA gain, mixer phase control, and ADC offset correction registers. This optimizes SFDR and noise performance.

### Step 19 — Application Start
- **Register:** `ADC_CTRL` at `0x0200`
- **Write value:** `0x03 (START=1, CONT_MODE=1)`
- **Wait/Poll:** None (immediate write)
- **Rationale:** Enable continuous ADC monitoring of power rails. Allows MCU to track VCC and ICC in real-time for health monitoring.

### Step 20 — Application Start
- **Register:** `HEALTH_STATUS` at `0x030F`
- **Write value:** `0x00 (Read)`
- **Wait/Poll:** Verify SYSTEM_OK=1 (all checks passed)
- **Rationale:** Final system health check before entering normal operation mode. All subsystems (PLL, ADC, power, temperature) must be within limits. If SYSTEM_OK=1, receiver is ready for RF signal capture.
