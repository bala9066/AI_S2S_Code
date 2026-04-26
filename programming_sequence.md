# Programming Sequence (PSQ)
## rx band

> **Total steps:** 34

| # | Phase | Register | Address | Value | Condition | Rationale |
|---|-------|----------|---------|-------|-----------|-----------|
| 1 | Power-On Reset & Self-Check | `HEALTH_STATUS` | `0x030F` | `0x0000` | Poll until VOLT_OK (bit 1) = 1 | Wait for all power rails (5V LDO, 3.3V LDO, 1.8V LDO, 1.0V Buck) to stabilise within tolerance before accessing any peripherals. Prevents register corruption during power ramp. |
| 2 | Power-On Reset & Self-Check | `BOARD_ID` | `0x0000` | `0x0000` | Verify read value == 0xB418 | Confirm correct FPGA bitstream is loaded by checking the hard-coded board identification value. Mismatch indicates wrong firmware or corrupted bitstream. |
| 3 | Power-On Reset & Self-Check | `SCRATCHPAD` | `0x0003` | `0xA55A` | Read back and verify == 0xA55A | Write-read-verify test to confirm the UART register interface is fully functional. Uses alternating bit pattern 0xA55A to catch address/data bus shorts and opens. |
| 4 | Power-On Reset & Self-Check | `TEMP_ALERT_HIGH` | `0x0308` | `0x0190` | — | Arm the over-temperature alert threshold at 100°C (0x190 in 0.25°C units). Ensures thermal protection is active before powering any RF components. |
| 4 | Power-On Reset & Self-Check | `TEMP_ALERT_LOW` | `0x0309` | `0x01CC` | — | Arm the under-temperature alert threshold at -25°C (0x1CC in signed 10-bit 0.25°C units). Complements the high-temperature alert for full thermal monitoring coverage. |
| 5 | PLL & Clock Init | `PLL_CTRL` | `0x0400` | `0x0002` | Hold for 10 µs | Assert PLL_RESET (bit 1) for both LO1 (LMX2820) and LO2 (ADF4383) synthesizers to establish known initial state in PLL state machines and SPI interfaces. |
| 6 | PLL & Clock Init | `PLL_CTRL` | `0x0400` | `0x0000` | Wait 100 µs for PLL reset release settling | Deassert PLL_RESET. Select OCXO 10 MHz reference (REF_SEL=00). LO output powers set to off (00) for safety during divider configuration. |
| 7 | PLL & Clock Init | `CLK_ENABLE` | `0x0410` | `0x003E` | — | Enable clock buffer outputs: LO1_REF_CLK (bit 1), LO2_REF_CLK (bit 2), SYSTEM_CLK (bit 3), DATA_CLK (bit 4), and SYNC_CLK (bit 5). ADC clock kept off until PLLs are locked. 0x3E = bits [5:1]. |
| 8 | PLL & Clock Init | `PLL_LO_SELECT` | `0x0404` | `0x0000` | — | Select LO1 (LMX2820) as the target for N/R divider register writes. LO_SEL=0 targets LO1. |
| 9 | PLL & Clock Init | `PLL_N_DIV` | `0x0402` | `0x0BB8` | — | Set LO1 N-divider to 3000 (0xBB8). With R=1 and 10 MHz reference, VCO operates at 30 GHz for 18-40 GHz band operation through internal prescaler. |
| 10 | PLL & Clock Init | `PLL_R_DIV` | `0x0403` | `0x0001` | — | Set LO1 R-divider to 1 for 10 MHz reference (OCXO KOVTL10MDBFBCB) fed directly to LMX2820 phase detector. |
| 11 | PLL & Clock Init | `PLL_FRAC_NUM` | `0x0405` | `0x0000` | — | Set LO1 fractional numerator to 0 for integer-N mode operation. Ensures clean spurious-free LO1 output. |
| 12 | PLL & Clock Init | `PLL_FRAC_DEN` | `0x0406` | `0x0001` | — | Set LO1 fractional denominator to 1 (MOD=1). Completes integer-N configuration. |
| 13 | PLL & Clock Init | `PLL_LO_SELECT` | `0x0404` | `0x0003` | — | Latch LO1 divider settings into LMX2820 SPI register set (UPDATE_REGS bit 1 = 1) while LO1 is still selected (LO_SEL bit 0 = 1). Self-clearing bit auto-clears. |
| 14 | PLL & Clock Init | `PLL_LO_SELECT` | `0x0404` | `0x0001` | — | Select LO2 (ADF4383) as target for subsequent divider register writes. LO_SEL=1, UPDATE_REGS=0. |
| 15 | PLL & Clock Init | `PLL_N_DIV` | `0x0402` | `0x00FA` | — | Set LO2 N-divider to 250 (0xFA). With 10 MHz reference and R=1, LO2 outputs 2.5 GHz for the second IF conversion stage. |
| 16 | PLL & Clock Init | `PLL_R_DIV` | `0x0403` | `0x0001` | — | Set LO2 R-divider to 1 for 10 MHz reference direct to ADF4383 phase detector. |
| 17 | PLL & Clock Init | `PLL_LO_SELECT` | `0x0404` | `0x0003` | — | Latch LO2 divider settings into ADF4383 SPI register set. UPDATE_REGS=1, LO_SEL=1. |
| 18 | PLL & Clock Init | `PLL_CTRL` | `0x0400` | `0x00FF` | Poll PLL_STATUS (0x0401) until LO1_LOCKED (bit 0) = 1 AND LO2_LOCKED (bit 1) = 1 | Enable both PLLs (bit 0=1), release reset (bit 1=0), select OCXO reference (bits 3:2=00), set LO1 output power to high (bits 5:4=11=3), set LO2 output power to high (bits 7:6=11=3). Value = 0x00F5 (PLL_EN=1, REF=00, LO1_PWR=11, LO2_PWR=11). NOTE: Adjusted to 0x00F5 since bit1=0. Wait for both PLLs to achieve phase lock before proceeding. |
| 19 | PLL & Clock Init | `CLK_ENABLE` | `0x0410` | `0x003F` | — | Enable ADC sample clock (bit 0) now that PLLs are locked. All clock outputs active: 0x3F = bits [5:0]. |
| 20 | Communication Init | `UART_BAUD_DIV` | `0x0100` | `0x0036` | — | Set UART baud rate divisor to 54 (0x36) for 115200 baud operation with 100 MHz system clock. Formula: baud = sys_clk / (16 × divisor). |
| 21 | Communication Init | `UART_CTRL` | `0x0101` | `0x0001` | — | Enable UART in 8N1 frame format (FRAME_FORMAT=0, ENABLE=1). Loopback off, interrupts disabled initially. |
| 22 | Peripheral Enable | `FLASH_CTRL` | `0x0600` | `0x0000` | Poll FLASH_STATUS (0x0604) until READY (bit 0) = 1 | Wait for flash interface to complete its internal initialisation. Flash stores calibration tables and configuration data needed before RF chain activation. |
| 23 | Peripheral Enable | `EEPROM_ADDR` | `0x0501` | `0x0000` | — | Set EEPROM read address to 0x0000 (start of calibration data block containing RF path gain compensation coefficients). |
| 24 | Peripheral Enable | `EEPROM_CTRL` | `0x0500` | `0x0001` | Poll EEPROM_CTRL BUSY (bit 7) until 0 | Initiate EEPROM read of calibration data. READ=1 (bit 0). Wait for operation to complete before reading EEPROM_DATA. |
| 25 | Peripheral Enable | `ADC_CTRL` | `0x0200` | `0x0012` | — | Configure ADC: two's complement data format (bits [5:4]=01), channel 0 selected (bits [3:2]=00), continuous mode enabled (bit 1=1), single-start off. Continuous conversion provides steady data stream for radar pulse capture. Value: 0x0012 = bits 4 and 1 set. |
| 26 | Peripheral Enable | `DAC_CTRL` | `0x0900` | `0x0003` | — | Enable VGA gain control DAC (bit 0=1) and YIG tuning DAC (bit 1=1). Auxiliary DAC kept off (bit 2=0). |
| 27 | Peripheral Enable | `VGA_GAIN` | `0x0901` | `0x0800` | — | Set VGA (TGL2767) to mid-scale gain (0x0800). Safe starting point — provides moderate gain without risk of saturating downstream ADC or IQ mixer. |
| 28 | Peripheral Enable | `GPIO_DIR` | `0x0800` | `0x000F` | — | Configure GPIO[3:0] as outputs (control signals to 60-pin SAMTEC data connector), GPIO[15:4] as inputs (status monitors and spare). |
| 29 | Application Init | `RF_CTRL` | `0x0700` | `0x00FB` | — | Enable the full RF receive chain: RF_ENABLE (bit 0=1), LNA_ENABLE (bit 1=1), LIMITER in-line (bit 2=0, protected mode), MIX1_ENABLE (bit 3=1), MIX2_ENABLE (bit 4=1), IF1_GAIN_EN (bit 5=1), LO1_BUF_EN (bit 6=1), LO2_BUF_EN (bit 7=1). Value: 0xFB = 11111011. Limiter stays in-line for input protection. |
| 30 | Application Init | `YIG_TUNE` | `0x0701` | `0x0000` | — | Set YIG tunable preselector to minimum frequency (18 GHz, tune code 0x0000). YIG filter must be set to pass the desired RF band before signals will be received. |
| 31 | Application Init | `SYSTEM_CTRL` | `0x0808` | `0x0102` | — | Set operating mode to RECEIVE (bits [2:0]=010), channel 0 selected (bits [5:4]=00), enable data output (bit 8=1). Mute off, no soft reset. Value: bit8=1, bit2=1 → 0x0102. Receiver is now active and digitising. |
| 32 | Application Init | `HEALTH_STATUS` | `0x030F` | `0x0000` | Verify SYSTEM_OK (bit 7) = 1 | Final health check. Read HEALTH_STATUS and confirm all subsystems report nominal: TEMP_OK, VOLT_OK, PLL_LOCK, ADC_OK, RF_OK, OCXO_LOCK, FLASH_OK. SYSTEM_OK is the logical AND of all health bits. |
| 33 | Application Init | `SYSTEM_STATUS` | `0x0809` | `0x0000` | Verify INIT_DONE (bit 15) = 1 and MODE (bits [2:0]) = 2 (RECEIVE) | Confirm FPGA initialisation is fully complete and the receiver is in the expected RECEIVE operating mode. System is now ready for radar pulse capture and data streaming. |

---

## Detailed Steps

### Step 1 — Power-On Reset & Self-Check
- **Register:** `HEALTH_STATUS` at `0x030F`
- **Write value:** `0x0000`
- **Wait/Poll:** Poll until VOLT_OK (bit 1) = 1
- **Rationale:** Wait for all power rails (5V LDO, 3.3V LDO, 1.8V LDO, 1.0V Buck) to stabilise within tolerance before accessing any peripherals. Prevents register corruption during power ramp.

### Step 2 — Power-On Reset & Self-Check
- **Register:** `BOARD_ID` at `0x0000`
- **Write value:** `0x0000`
- **Wait/Poll:** Verify read value == 0xB418
- **Rationale:** Confirm correct FPGA bitstream is loaded by checking the hard-coded board identification value. Mismatch indicates wrong firmware or corrupted bitstream.

### Step 3 — Power-On Reset & Self-Check
- **Register:** `SCRATCHPAD` at `0x0003`
- **Write value:** `0xA55A`
- **Wait/Poll:** Read back and verify == 0xA55A
- **Rationale:** Write-read-verify test to confirm the UART register interface is fully functional. Uses alternating bit pattern 0xA55A to catch address/data bus shorts and opens.

### Step 4 — Power-On Reset & Self-Check
- **Register:** `TEMP_ALERT_HIGH` at `0x0308`
- **Write value:** `0x0190`
- **Rationale:** Arm the over-temperature alert threshold at 100°C (0x190 in 0.25°C units). Ensures thermal protection is active before powering any RF components.

### Step 4 — Power-On Reset & Self-Check
- **Register:** `TEMP_ALERT_LOW` at `0x0309`
- **Write value:** `0x01CC`
- **Rationale:** Arm the under-temperature alert threshold at -25°C (0x1CC in signed 10-bit 0.25°C units). Complements the high-temperature alert for full thermal monitoring coverage.

### Step 5 — PLL & Clock Init
- **Register:** `PLL_CTRL` at `0x0400`
- **Write value:** `0x0002`
- **Wait/Poll:** Hold for 10 µs
- **Rationale:** Assert PLL_RESET (bit 1) for both LO1 (LMX2820) and LO2 (ADF4383) synthesizers to establish known initial state in PLL state machines and SPI interfaces.

### Step 6 — PLL & Clock Init
- **Register:** `PLL_CTRL` at `0x0400`
- **Write value:** `0x0000`
- **Wait/Poll:** Wait 100 µs for PLL reset release settling
- **Rationale:** Deassert PLL_RESET. Select OCXO 10 MHz reference (REF_SEL=00). LO output powers set to off (00) for safety during divider configuration.

### Step 7 — PLL & Clock Init
- **Register:** `CLK_ENABLE` at `0x0410`
- **Write value:** `0x003E`
- **Rationale:** Enable clock buffer outputs: LO1_REF_CLK (bit 1), LO2_REF_CLK (bit 2), SYSTEM_CLK (bit 3), DATA_CLK (bit 4), and SYNC_CLK (bit 5). ADC clock kept off until PLLs are locked. 0x3E = bits [5:1].

### Step 8 — PLL & Clock Init
- **Register:** `PLL_LO_SELECT` at `0x0404`
- **Write value:** `0x0000`
- **Rationale:** Select LO1 (LMX2820) as the target for N/R divider register writes. LO_SEL=0 targets LO1.

### Step 9 — PLL & Clock Init
- **Register:** `PLL_N_DIV` at `0x0402`
- **Write value:** `0x0BB8`
- **Rationale:** Set LO1 N-divider to 3000 (0xBB8). With R=1 and 10 MHz reference, VCO operates at 30 GHz for 18-40 GHz band operation through internal prescaler.

### Step 10 — PLL & Clock Init
- **Register:** `PLL_R_DIV` at `0x0403`
- **Write value:** `0x0001`
- **Rationale:** Set LO1 R-divider to 1 for 10 MHz reference (OCXO KOVTL10MDBFBCB) fed directly to LMX2820 phase detector.

### Step 11 — PLL & Clock Init
- **Register:** `PLL_FRAC_NUM` at `0x0405`
- **Write value:** `0x0000`
- **Rationale:** Set LO1 fractional numerator to 0 for integer-N mode operation. Ensures clean spurious-free LO1 output.

### Step 12 — PLL & Clock Init
- **Register:** `PLL_FRAC_DEN` at `0x0406`
- **Write value:** `0x0001`
- **Rationale:** Set LO1 fractional denominator to 1 (MOD=1). Completes integer-N configuration.

### Step 13 — PLL & Clock Init
- **Register:** `PLL_LO_SELECT` at `0x0404`
- **Write value:** `0x0003`
- **Rationale:** Latch LO1 divider settings into LMX2820 SPI register set (UPDATE_REGS bit 1 = 1) while LO1 is still selected (LO_SEL bit 0 = 1). Self-clearing bit auto-clears.

### Step 14 — PLL & Clock Init
- **Register:** `PLL_LO_SELECT` at `0x0404`
- **Write value:** `0x0001`
- **Rationale:** Select LO2 (ADF4383) as target for subsequent divider register writes. LO_SEL=1, UPDATE_REGS=0.

### Step 15 — PLL & Clock Init
- **Register:** `PLL_N_DIV` at `0x0402`
- **Write value:** `0x00FA`
- **Rationale:** Set LO2 N-divider to 250 (0xFA). With 10 MHz reference and R=1, LO2 outputs 2.5 GHz for the second IF conversion stage.

### Step 16 — PLL & Clock Init
- **Register:** `PLL_R_DIV` at `0x0403`
- **Write value:** `0x0001`
- **Rationale:** Set LO2 R-divider to 1 for 10 MHz reference direct to ADF4383 phase detector.

### Step 17 — PLL & Clock Init
- **Register:** `PLL_LO_SELECT` at `0x0404`
- **Write value:** `0x0003`
- **Rationale:** Latch LO2 divider settings into ADF4383 SPI register set. UPDATE_REGS=1, LO_SEL=1.

### Step 18 — PLL & Clock Init
- **Register:** `PLL_CTRL` at `0x0400`
- **Write value:** `0x00FF`
- **Wait/Poll:** Poll PLL_STATUS (0x0401) until LO1_LOCKED (bit 0) = 1 AND LO2_LOCKED (bit 1) = 1
- **Rationale:** Enable both PLLs (bit 0=1), release reset (bit 1=0), select OCXO reference (bits 3:2=00), set LO1 output power to high (bits 5:4=11=3), set LO2 output power to high (bits 7:6=11=3). Value = 0x00F5 (PLL_EN=1, REF=00, LO1_PWR=11, LO2_PWR=11). NOTE: Adjusted to 0x00F5 since bit1=0. Wait for both PLLs to achieve phase lock before proceeding.

### Step 19 — PLL & Clock Init
- **Register:** `CLK_ENABLE` at `0x0410`
- **Write value:** `0x003F`
- **Rationale:** Enable ADC sample clock (bit 0) now that PLLs are locked. All clock outputs active: 0x3F = bits [5:0].

### Step 20 — Communication Init
- **Register:** `UART_BAUD_DIV` at `0x0100`
- **Write value:** `0x0036`
- **Rationale:** Set UART baud rate divisor to 54 (0x36) for 115200 baud operation with 100 MHz system clock. Formula: baud = sys_clk / (16 × divisor).

### Step 21 — Communication Init
- **Register:** `UART_CTRL` at `0x0101`
- **Write value:** `0x0001`
- **Rationale:** Enable UART in 8N1 frame format (FRAME_FORMAT=0, ENABLE=1). Loopback off, interrupts disabled initially.

### Step 22 — Peripheral Enable
- **Register:** `FLASH_CTRL` at `0x0600`
- **Write value:** `0x0000`
- **Wait/Poll:** Poll FLASH_STATUS (0x0604) until READY (bit 0) = 1
- **Rationale:** Wait for flash interface to complete its internal initialisation. Flash stores calibration tables and configuration data needed before RF chain activation.

### Step 23 — Peripheral Enable
- **Register:** `EEPROM_ADDR` at `0x0501`
- **Write value:** `0x0000`
- **Rationale:** Set EEPROM read address to 0x0000 (start of calibration data block containing RF path gain compensation coefficients).

### Step 24 — Peripheral Enable
- **Register:** `EEPROM_CTRL` at `0x0500`
- **Write value:** `0x0001`
- **Wait/Poll:** Poll EEPROM_CTRL BUSY (bit 7) until 0
- **Rationale:** Initiate EEPROM read of calibration data. READ=1 (bit 0). Wait for operation to complete before reading EEPROM_DATA.

### Step 25 — Peripheral Enable
- **Register:** `ADC_CTRL` at `0x0200`
- **Write value:** `0x0012`
- **Rationale:** Configure ADC: two's complement data format (bits [5:4]=01), channel 0 selected (bits [3:2]=00), continuous mode enabled (bit 1=1), single-start off. Continuous conversion provides steady data stream for radar pulse capture. Value: 0x0012 = bits 4 and 1 set.

### Step 26 — Peripheral Enable
- **Register:** `DAC_CTRL` at `0x0900`
- **Write value:** `0x0003`
- **Rationale:** Enable VGA gain control DAC (bit 0=1) and YIG tuning DAC (bit 1=1). Auxiliary DAC kept off (bit 2=0).

### Step 27 — Peripheral Enable
- **Register:** `VGA_GAIN` at `0x0901`
- **Write value:** `0x0800`
- **Rationale:** Set VGA (TGL2767) to mid-scale gain (0x0800). Safe starting point — provides moderate gain without risk of saturating downstream ADC or IQ mixer.

### Step 28 — Peripheral Enable
- **Register:** `GPIO_DIR` at `0x0800`
- **Write value:** `0x000F`
- **Rationale:** Configure GPIO[3:0] as outputs (control signals to 60-pin SAMTEC data connector), GPIO[15:4] as inputs (status monitors and spare).

### Step 29 — Application Init
- **Register:** `RF_CTRL` at `0x0700`
- **Write value:** `0x00FB`
- **Rationale:** Enable the full RF receive chain: RF_ENABLE (bit 0=1), LNA_ENABLE (bit 1=1), LIMITER in-line (bit 2=0, protected mode), MIX1_ENABLE (bit 3=1), MIX2_ENABLE (bit 4=1), IF1_GAIN_EN (bit 5=1), LO1_BUF_EN (bit 6=1), LO2_BUF_EN (bit 7=1). Value: 0xFB = 11111011. Limiter stays in-line for input protection.

### Step 30 — Application Init
- **Register:** `YIG_TUNE` at `0x0701`
- **Write value:** `0x0000`
- **Rationale:** Set YIG tunable preselector to minimum frequency (18 GHz, tune code 0x0000). YIG filter must be set to pass the desired RF band before signals will be received.

### Step 31 — Application Init
- **Register:** `SYSTEM_CTRL` at `0x0808`
- **Write value:** `0x0102`
- **Rationale:** Set operating mode to RECEIVE (bits [2:0]=010), channel 0 selected (bits [5:4]=00), enable data output (bit 8=1). Mute off, no soft reset. Value: bit8=1, bit2=1 → 0x0102. Receiver is now active and digitising.

### Step 32 — Application Init
- **Register:** `HEALTH_STATUS` at `0x030F`
- **Write value:** `0x0000`
- **Wait/Poll:** Verify SYSTEM_OK (bit 7) = 1
- **Rationale:** Final health check. Read HEALTH_STATUS and confirm all subsystems report nominal: TEMP_OK, VOLT_OK, PLL_LOCK, ADC_OK, RF_OK, OCXO_LOCK, FLASH_OK. SYSTEM_OK is the logical AND of all health bits.

### Step 33 — Application Init
- **Register:** `SYSTEM_STATUS` at `0x0809`
- **Write value:** `0x0000`
- **Wait/Poll:** Verify INIT_DONE (bit 15) = 1 and MODE (bits [2:0]) = 2 (RECEIVE)
- **Rationale:** Confirm FPGA initialisation is fully complete and the receiver is in the expected RECEIVE operating mode. System is now ready for radar pulse capture and data streaming.
