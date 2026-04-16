# Programming Sequence (PSQ)
## khg

> **Total steps:** 32

| # | Phase | Register | Address | Value | Condition | Rationale |
|---|-------|----------|---------|-------|-----------|-----------|
| 1 | Power-On Reset & Self-Check | `SCRATCHPAD` | `0x0003` | `0xA5A5` | Read back and verify value equals 0xA5A5 | Verify basic register access and internal RAM integrity by writing known pattern and reading back. First step after power-on ensures communication interface functional. |
| 2 | Power-On Reset & Self-Check | `SCRATCHPAD` | `0x0003` | `0x0000` | Read back and verify value equals 0x0000 | Second pattern verification confirms read/write path integrity and clears test register before further initialization. |
| 3 | Power-On Reset & Self-Check | `BOARD_ID` | `0x0000` | `N/A` | Read and verify value equals 0x4B48 (ASCII 'KH') | Confirm correct FPGA image loaded and hardware type identification matches expected khg Wideband RF Receiver. |
| 4 | Power-On Reset & Self-Check | `HEALTH_STATUS` | `0x030F` | `N/A` | Poll until VOLT_OK (bit 1) = 1, timeout 500ms | Wait for all power rails (5V, 3.3V, 2.5V, 1.8V, 1.0V) to stabilize within tolerance before enabling peripherals. |
| 5 | PLL & Clock Init | `PLL_CTRL` | `0x0400` | `0x0002` | Wait 1ms | Assert PLL reset to ensure LMX2594 starts from known state. REF_SEL=0 selects internal crystal reference. |
| 6 | PLL & Clock Init | `PLL_N_DIV` | `0x0402` | `0x0064` | Immediate write | Program N divider = 100 for initial frequency (adjust based on desired LO frequency: f_LO = f_REF * N/R). |
| 7 | PLL & Clock Init | `PLL_R_DIV` | `0x0403` | `0x0001` | Immediate write | Program R divider = 1 (no reference division) for minimum phase noise. |
| 8 | PLL & Clock Init | `PLL_FRAC_MSB` | `0x0404` | `0x0000` | Immediate write | Set fractional divider to 0 for integer mode (simpler startup, can be set to fine-tune LO frequency later). |
| 9 | PLL & Clock Init | `PLL_FRAC_LSB` | `0x0405` | `0x0000` | Immediate write | Complete fractional divider programming with LSB = 0 for integer mode operation. |
| 10 | PLL & Clock Init | `PLL_CTRL` | `0x0400` | `0x0031` | Poll PLL_STATUS (0x0401) until LOCKED (bit 0) = 1, timeout 100ms | Enable PLL (bit 0), clear reset (bit 1=0), enable RF output (bit 4), unmute output (bit 5=0). Wait for lock confirmation before enabling downstream clocks. |
| 11 | PLL & Clock Init | `CLK_ENABLE` | `0x0410` | `0x0F` | Wait 100us for clocks to stabilize | Enable ADC sample clock, FPGA system clock, SYSREF, and LO distribution. All clocks now available for JESD204B/C link and RF chain. |
| 12 | PLL & Clock Init | `JESD_CTRL` | `0x0420` | `0x05` | Wait 10us | Enable JESD204B/C link (bit 0) and set Subclass 1 (bits 2:1 = 01) for deterministic latency using SYSREF signal. |
| 13 | Communication Init | `UART_BAUD_DIV` | `0x0100` | `0x0036` | Immediate write | Set baud rate divisor for 115200 baud @ 100MHz clock (100e6 / (16 * 115200) = 54.25 ≈ 54 = 0x36). |
| 14 | Communication Init | `UART_CTRL` | `0x0101` | `0x01` | Immediate write | Enable UART transmitter/receiver. Frame format bits [7:4]=0 configures 8N1 (8 data bits, no parity, 1 stop bit). |
| 15 | Temperature & Health Init | `TEMP_ALERT_HIGH` | `0x0308` | `0x0168` | Immediate write | Set over-temperature alert threshold to 90°C (0x168 = 360 * 0.25°C) for system protection. |
| 16 | Temperature & Health Init | `TEMP_ALERT_LOW` | `0x0309` | `0xFF9C` | Immediate write | Set under-temperature alert threshold to -25°C (0xFF9C = -100 * 0.25°C) for cold start protection. |
| 17 | RF Front-End Init | `RFE_CTRL` | `0x0700` | `0x09` | Wait 1ms for LNA bias to settle | Enable LNA (bit 0), enable RF input (bit 3) for RF path active. Keep RFE power down cleared and LNA bypass cleared for normal operation. |
| 18 | RF Front-End Init | `ATTENUATOR_CTRL` | `0x0701` | `0x2030` | Wait 10us for attenuator to settle | Set initial attenuation to 24dB (code 0x30 = 48 * 0.5dB) and load value (bit 6=1) into HMC698LP4 latch. |
| 19 | RF Front-End Init | `GAIN_CTRL` | `0x0702` | `0x100` | Immediate write | Set initial gain code to mid-range (0x10 = 16 decimal). Keep AGC frozen (bit 8=0) for manual control initially. |
| 20 | RF Front-End Init | `IQ_MIXER_CTRL` | `0x0703` | `0x05` | Wait 500us for mixer bias | Enable mixer (bit 0) and LO buffer (bit 2). Set DC offset trim to mid-range (bits 6:4=4). I/Q swap cleared. |
| 21 | RF Front-End Init | `IF_AMP_CTRL` | `0x0704` | `0x05` | Immediate write | Enable both IF amplifiers (bits 0,1) for I and Q channels. Set gain to mid-range (bits 4:2=1). |
| 22 | ADC & JESD Init | `ADC_CTRL` | `0x0200` | `0x13` | Wait 5ms for ADC to initialize | Enable ADC (bit 0), enable JESD link (bit 1), set dual-channel mode (bits 3:2=10), set Subclass 1 (bits 6:5=01), and configure SYNC polarity as active low (bit 4=0). |
| 23 | ADC & JESD Init | `JESD_STATUS` | `0x0421` | `N/A` | Poll until LINK_READY (bit 0) = 1 and ILAS_COMPLETE (bit 1) = 1, timeout 100ms | Wait for JESD204B/C link to achieve code group synchronization and complete Initial Lane Alignment Sequence. ADC data is now valid. |
| 24 | Storage Init | `FLASH_CTRL` | `0x0600` | `0x10` | Wait 100us | Prepare flash interface for read operations (bit 0=READ). Unlock sequence not required for read. Verify flash is accessible. |
| 25 | Storage Init | `FLASH_STATUS` | `0x0604` | `N/A` | Verify READY (bit 0) = 1 and no errors | Confirm flash interface is ready and no write/erase protection errors are present before attempting configuration load. |
| 26 | Storage Init | `EEPROM_CTRL` | `0x0500` | `0x01` | Poll BUSY (bit 7) = 0, timeout 10ms | Initiate EEPROM read operation to retrieve factory calibration data. No unlock required for read. |
| 27 | Application Init | `CALIBRATION_CTRL` | `0x0B00` | `0x11` | Poll until CAL_BUSY (bit 7) = 0, timeout 1s | Start automatic IQ calibration (bits 3:1=000 for IQ, bit 4=1 for auto-cal). Ensures proper I/Q balance for direct conversion receiver. |
| 28 | Application Init | `CALIBRATION_STATUS` | `0x0B01` | `N/A` | Verify CAL_PASS (bit 1) = 1, fail if CAL_FAIL (bit 2) = 1 | Confirm calibration completed successfully before proceeding to normal operation. IQ imbalance error code should be minimal. |
| 29 | Application Init | `AGC_CONFIG` | `0x0A00` | `0x1821` | Immediate write | Enable AGC (bit 0=1), set fast mode (bits 2:1=00), target ADC level -12dBFS (bits 7:4=8), hysteresis 3dB (bits 11:8=2). |
| 30 | Application Init | `DAC_CTRL` | `0x0902` | `0x03` | Immediate write | Enable both DAC channels (bits 0,1) for auxiliary bias controls. Output format set to straight binary (bits 3:2=00). |
| 31 | Application Init | `EVENT_LOG_CTRL` | `0x0C00` | `0x0B` | Immediate write | Enable event logging (bit 0), set log level to INFO (bits 2:1=10), enable wrap (bit 3=1). System now logging diagnostic events. |
| 32 | Final Verification | `HEALTH_STATUS` | `0x030F` | `N/A` | Verify TEMP_OK=1, VOLT_OK=1, PLL_LOCK=1, JESD_LINK_OK=1, SYSTEM_OK=1 | Final system health check confirms all subsystems operational. SYSTEM_OK bit indicates receiver ready for signal acquisition. |

---

## Detailed Steps

### Step 1 — Power-On Reset & Self-Check
- **Register:** `SCRATCHPAD` at `0x0003`
- **Write value:** `0xA5A5`
- **Wait/Poll:** Read back and verify value equals 0xA5A5
- **Rationale:** Verify basic register access and internal RAM integrity by writing known pattern and reading back. First step after power-on ensures communication interface functional.

### Step 2 — Power-On Reset & Self-Check
- **Register:** `SCRATCHPAD` at `0x0003`
- **Write value:** `0x0000`
- **Wait/Poll:** Read back and verify value equals 0x0000
- **Rationale:** Second pattern verification confirms read/write path integrity and clears test register before further initialization.

### Step 3 — Power-On Reset & Self-Check
- **Register:** `BOARD_ID` at `0x0000`
- **Write value:** `N/A`
- **Wait/Poll:** Read and verify value equals 0x4B48 (ASCII 'KH')
- **Rationale:** Confirm correct FPGA image loaded and hardware type identification matches expected khg Wideband RF Receiver.

### Step 4 — Power-On Reset & Self-Check
- **Register:** `HEALTH_STATUS` at `0x030F`
- **Write value:** `N/A`
- **Wait/Poll:** Poll until VOLT_OK (bit 1) = 1, timeout 500ms
- **Rationale:** Wait for all power rails (5V, 3.3V, 2.5V, 1.8V, 1.0V) to stabilize within tolerance before enabling peripherals.

### Step 5 — PLL & Clock Init
- **Register:** `PLL_CTRL` at `0x0400`
- **Write value:** `0x0002`
- **Wait/Poll:** Wait 1ms
- **Rationale:** Assert PLL reset to ensure LMX2594 starts from known state. REF_SEL=0 selects internal crystal reference.

### Step 6 — PLL & Clock Init
- **Register:** `PLL_N_DIV` at `0x0402`
- **Write value:** `0x0064`
- **Wait/Poll:** Immediate write
- **Rationale:** Program N divider = 100 for initial frequency (adjust based on desired LO frequency: f_LO = f_REF * N/R).

### Step 7 — PLL & Clock Init
- **Register:** `PLL_R_DIV` at `0x0403`
- **Write value:** `0x0001`
- **Wait/Poll:** Immediate write
- **Rationale:** Program R divider = 1 (no reference division) for minimum phase noise.

### Step 8 — PLL & Clock Init
- **Register:** `PLL_FRAC_MSB` at `0x0404`
- **Write value:** `0x0000`
- **Wait/Poll:** Immediate write
- **Rationale:** Set fractional divider to 0 for integer mode (simpler startup, can be set to fine-tune LO frequency later).

### Step 9 — PLL & Clock Init
- **Register:** `PLL_FRAC_LSB` at `0x0405`
- **Write value:** `0x0000`
- **Wait/Poll:** Immediate write
- **Rationale:** Complete fractional divider programming with LSB = 0 for integer mode operation.

### Step 10 — PLL & Clock Init
- **Register:** `PLL_CTRL` at `0x0400`
- **Write value:** `0x0031`
- **Wait/Poll:** Poll PLL_STATUS (0x0401) until LOCKED (bit 0) = 1, timeout 100ms
- **Rationale:** Enable PLL (bit 0), clear reset (bit 1=0), enable RF output (bit 4), unmute output (bit 5=0). Wait for lock confirmation before enabling downstream clocks.

### Step 11 — PLL & Clock Init
- **Register:** `CLK_ENABLE` at `0x0410`
- **Write value:** `0x0F`
- **Wait/Poll:** Wait 100us for clocks to stabilize
- **Rationale:** Enable ADC sample clock, FPGA system clock, SYSREF, and LO distribution. All clocks now available for JESD204B/C link and RF chain.

### Step 12 — PLL & Clock Init
- **Register:** `JESD_CTRL` at `0x0420`
- **Write value:** `0x05`
- **Wait/Poll:** Wait 10us
- **Rationale:** Enable JESD204B/C link (bit 0) and set Subclass 1 (bits 2:1 = 01) for deterministic latency using SYSREF signal.

### Step 13 — Communication Init
- **Register:** `UART_BAUD_DIV` at `0x0100`
- **Write value:** `0x0036`
- **Wait/Poll:** Immediate write
- **Rationale:** Set baud rate divisor for 115200 baud @ 100MHz clock (100e6 / (16 * 115200) = 54.25 ≈ 54 = 0x36).

### Step 14 — Communication Init
- **Register:** `UART_CTRL` at `0x0101`
- **Write value:** `0x01`
- **Wait/Poll:** Immediate write
- **Rationale:** Enable UART transmitter/receiver. Frame format bits [7:4]=0 configures 8N1 (8 data bits, no parity, 1 stop bit).

### Step 15 — Temperature & Health Init
- **Register:** `TEMP_ALERT_HIGH` at `0x0308`
- **Write value:** `0x0168`
- **Wait/Poll:** Immediate write
- **Rationale:** Set over-temperature alert threshold to 90°C (0x168 = 360 * 0.25°C) for system protection.

### Step 16 — Temperature & Health Init
- **Register:** `TEMP_ALERT_LOW` at `0x0309`
- **Write value:** `0xFF9C`
- **Wait/Poll:** Immediate write
- **Rationale:** Set under-temperature alert threshold to -25°C (0xFF9C = -100 * 0.25°C) for cold start protection.

### Step 17 — RF Front-End Init
- **Register:** `RFE_CTRL` at `0x0700`
- **Write value:** `0x09`
- **Wait/Poll:** Wait 1ms for LNA bias to settle
- **Rationale:** Enable LNA (bit 0), enable RF input (bit 3) for RF path active. Keep RFE power down cleared and LNA bypass cleared for normal operation.

### Step 18 — RF Front-End Init
- **Register:** `ATTENUATOR_CTRL` at `0x0701`
- **Write value:** `0x2030`
- **Wait/Poll:** Wait 10us for attenuator to settle
- **Rationale:** Set initial attenuation to 24dB (code 0x30 = 48 * 0.5dB) and load value (bit 6=1) into HMC698LP4 latch.

### Step 19 — RF Front-End Init
- **Register:** `GAIN_CTRL` at `0x0702`
- **Write value:** `0x100`
- **Wait/Poll:** Immediate write
- **Rationale:** Set initial gain code to mid-range (0x10 = 16 decimal). Keep AGC frozen (bit 8=0) for manual control initially.

### Step 20 — RF Front-End Init
- **Register:** `IQ_MIXER_CTRL` at `0x0703`
- **Write value:** `0x05`
- **Wait/Poll:** Wait 500us for mixer bias
- **Rationale:** Enable mixer (bit 0) and LO buffer (bit 2). Set DC offset trim to mid-range (bits 6:4=4). I/Q swap cleared.

### Step 21 — RF Front-End Init
- **Register:** `IF_AMP_CTRL` at `0x0704`
- **Write value:** `0x05`
- **Wait/Poll:** Immediate write
- **Rationale:** Enable both IF amplifiers (bits 0,1) for I and Q channels. Set gain to mid-range (bits 4:2=1).

### Step 22 — ADC & JESD Init
- **Register:** `ADC_CTRL` at `0x0200`
- **Write value:** `0x13`
- **Wait/Poll:** Wait 5ms for ADC to initialize
- **Rationale:** Enable ADC (bit 0), enable JESD link (bit 1), set dual-channel mode (bits 3:2=10), set Subclass 1 (bits 6:5=01), and configure SYNC polarity as active low (bit 4=0).

### Step 23 — ADC & JESD Init
- **Register:** `JESD_STATUS` at `0x0421`
- **Write value:** `N/A`
- **Wait/Poll:** Poll until LINK_READY (bit 0) = 1 and ILAS_COMPLETE (bit 1) = 1, timeout 100ms
- **Rationale:** Wait for JESD204B/C link to achieve code group synchronization and complete Initial Lane Alignment Sequence. ADC data is now valid.

### Step 24 — Storage Init
- **Register:** `FLASH_CTRL` at `0x0600`
- **Write value:** `0x10`
- **Wait/Poll:** Wait 100us
- **Rationale:** Prepare flash interface for read operations (bit 0=READ). Unlock sequence not required for read. Verify flash is accessible.

### Step 25 — Storage Init
- **Register:** `FLASH_STATUS` at `0x0604`
- **Write value:** `N/A`
- **Wait/Poll:** Verify READY (bit 0) = 1 and no errors
- **Rationale:** Confirm flash interface is ready and no write/erase protection errors are present before attempting configuration load.

### Step 26 — Storage Init
- **Register:** `EEPROM_CTRL` at `0x0500`
- **Write value:** `0x01`
- **Wait/Poll:** Poll BUSY (bit 7) = 0, timeout 10ms
- **Rationale:** Initiate EEPROM read operation to retrieve factory calibration data. No unlock required for read.

### Step 27 — Application Init
- **Register:** `CALIBRATION_CTRL` at `0x0B00`
- **Write value:** `0x11`
- **Wait/Poll:** Poll until CAL_BUSY (bit 7) = 0, timeout 1s
- **Rationale:** Start automatic IQ calibration (bits 3:1=000 for IQ, bit 4=1 for auto-cal). Ensures proper I/Q balance for direct conversion receiver.

### Step 28 — Application Init
- **Register:** `CALIBRATION_STATUS` at `0x0B01`
- **Write value:** `N/A`
- **Wait/Poll:** Verify CAL_PASS (bit 1) = 1, fail if CAL_FAIL (bit 2) = 1
- **Rationale:** Confirm calibration completed successfully before proceeding to normal operation. IQ imbalance error code should be minimal.

### Step 29 — Application Init
- **Register:** `AGC_CONFIG` at `0x0A00`
- **Write value:** `0x1821`
- **Wait/Poll:** Immediate write
- **Rationale:** Enable AGC (bit 0=1), set fast mode (bits 2:1=00), target ADC level -12dBFS (bits 7:4=8), hysteresis 3dB (bits 11:8=2).

### Step 30 — Application Init
- **Register:** `DAC_CTRL` at `0x0902`
- **Write value:** `0x03`
- **Wait/Poll:** Immediate write
- **Rationale:** Enable both DAC channels (bits 0,1) for auxiliary bias controls. Output format set to straight binary (bits 3:2=00).

### Step 31 — Application Init
- **Register:** `EVENT_LOG_CTRL` at `0x0C00`
- **Write value:** `0x0B`
- **Wait/Poll:** Immediate write
- **Rationale:** Enable event logging (bit 0), set log level to INFO (bits 2:1=10), enable wrap (bit 3=1). System now logging diagnostic events.

### Step 32 — Final Verification
- **Register:** `HEALTH_STATUS` at `0x030F`
- **Write value:** `N/A`
- **Wait/Poll:** Verify TEMP_OK=1, VOLT_OK=1, PLL_LOCK=1, JESD_LINK_OK=1, SYSTEM_OK=1
- **Rationale:** Final system health check confirms all subsystems operational. SYSTEM_OK bit indicates receiver ready for signal acquisition.
