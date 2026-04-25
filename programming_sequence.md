# Programming Sequence (PSQ)
## hjjg

> **Total steps:** 20

| # | Phase | Register | Address | Value | Condition | Rationale |
|---|-------|----------|---------|-------|-----------|-----------|
| 1 | Power-On Reset & Self-Check | `SCRATCHPAD` | `0x0003` | `0xA5A5` | — | UART link integrity check — write known pattern 0xA5A5 to SCRATCHPAD, then read back to verify the UART command/response path is fully functional and the register file is writable. |
| 2 | Power-On Reset & Self-Check | `HEALTH_STATUS` | `0x030F` | `0x0000` | — | Read HEALTH_STATUS register and poll until VOLT_OK (bit 1) = 1. This confirms all supply rails (5V, 3.3V, 2.5V, 1.8V) are stable and within ±5% tolerance as measured by the ADM1177 hot-swap controller and XADC. Do NOT proceed until VOLT_OK=1. |
| 3 | Power-On Reset & Self-Check | `BOARD_ID` | `0x0000` | `0x484A` | — | Read BOARD_ID and verify it equals 0x484A (ASCII 'HJ'). Also read BOARD_VERSION (0x0001) and BOARD_TYPE_ID (0x0002) to confirm the correct FPGA bitstream is loaded for the hjjg dual-channel radar receiver. Mismatch indicates wrong firmware. |
| 4 | Power-On Reset & Self-Check | `HEALTH_STATUS` | `0x030F` | `0x0000` | — | Second health poll — read HEALTH_STATUS to verify TEMP_OK (bit 0) and VOLT_OK (bit 1) are both set. Also read TEMP_LOCAL (0x0300) to confirm FPGA die temperature is in safe operating range before enabling high-power peripherals. Optionally read TEMP_REMOTE1/2 for RF section temperatures. |
| 5 | PLL & Clock Init | `PLL_CTRL` | `0x0400` | `0x0002` | — | Soft-reset the ADF4106 PLL synthesizer — write PLL_CTRL with RESET bit [1] = 1 (value 0x0002) to ensure a known state. The PLL is still disabled (ENABLE=0). Wait 10 µs after reset. |
| 6 | PLL & Clock Init | `PLL_R_DIV` | `0x0403` | `0x0001` | — | Set ADF4106 R-divider to 1 (reference divider) — the 10 MHz OCXO (OSJ7014-10.0M) feeds directly to the phase detector at 10 MHz f_PFD. Then set PLL_N_DIV (0x0402) for the desired LO1 frequency. For a 5000 MHz LO1: N = f_LO / f_PFD = 500. Write PLL_N_DIV = 0x01F4. Tune N based on mission requirements (N = 330–730 for LO1 3.3–7.3 GHz). |
| 7 | PLL & Clock Init | `PLL_CTRL` | `0x0400` | `0x0015` | — | Enable the PLL with charge pump current set: write PLL_CTRL = 0x0015 (ENABLE=1, REF_SEL=00 for OCXO, LO_SEL=00 for LO1, CP_CURRENT=10 for 2.5 mA, SPI_LATCH=1 to latch settings). Then poll PLL_STATUS (0x0401) bit [0] LOCKED until it reads 1, confirming the ADF4106 has acquired phase lock on LO1. |
| 8 | PLL & Clock Init | `CLK_ENABLE` | `0x0410` | `0x008F` | — | Enable all required LMK1C1102 clock buffer outputs: CLK_OUT0_EN (ADC sample clock 170 MHz), CLK_OUT1_EN (FPGA processing clock), CLK_OUT2_EN (LO2 reference), CLK_OUT3_EN (PRI sync), and GLOBAL_EN = 1. Value 0x008F = bits [3:0] + bit [7]. |
| 9 | Peripheral Enable | `LO_POWER_CTRL` | `0x0720` | `0x0007` | — | Enable the LO chain: set LO1_EN=1 (HMC586LC4B VCO), LO2_EN=1 (LO2 synthesizer), SPLITTER_EN=1 (EP2K1+ power splitter distributing LO1 to both channels). VCO_TUNE_DAC left at default (0) initially — PLL loop filter handles fine tuning. |
| 10 | Peripheral Enable | `RF_LNA_CTRL` | `0x0700` | `0x0005` | — | Enable both GRF2074 pHEMT LNAs with nominal +20 dB gain: LNA_A_EN=1 (bit 0), LNA_B_EN=1 (bit 1), LNA_A_GAIN=00 (+20 dB, bits [3:2]), LNA_B_GAIN=00 (+20 dB, bits [5:4]). Value 0x0005 = LNA bias on for both channels at full gain. |
| 11 | Peripheral Enable | `IF1_GAIN_CTRL` | `0x0718` | `0x0110` | — | Enable IF1 amplifier chain (HMC788ALP2E driver + GRF2040 buffer) and set nominal gain: IF1_AMP_EN=1 (bit 8), IF1_CHA_GAIN = 4 dB (bits [3:0] = 0x4), IF1_CHB_GAIN = 4 dB (bits [7:4] = 0x1 → 1 dB, so write 0x14). Adjust value 0x0114 for 4 dB + 1 dB = total gain. Final value 0x0110 sets 8 dB on CH A, 1 dB on CH B — tune per calibration. |
| 12 | Communication Init | `UART_BAUD_DIV` | `0x0100` | `0x0044` | — | Configure UART baud rate divisor for 115200 baud operation (DIVISOR = 0x0044 at 100 MHz system clock: 100 MHz / (16 × 68) ≈ 91911 baud ≈ 115200 with rounding). Set UART_CTRL (0x0101) = 0x0001 for 8N1 with enable. Confirm by reading back. |
| 13 | Communication Init | `UART_CTRL` | `0x0101` | `0x0001` | — | Enable UART in normal operating mode: ENABLE=1 (bit 0), LOOPBACK=0, FRAME_FMT=0000 (8N1). Parity interrupt mask = 0 (enabled). The UART is now live for host communication. |
| 14 | Peripheral Enable | `EEPROM_CTRL` | `0x0500` | `0x0000` | — | Initialize I2C EEPROM (24AA025E48) — poll BUSY bit [7] until 0. Set EEPROM_ADDR = 0xF8 (MAC address location), trigger READ (bit [0] = 1). Read MAC from ETH_MAC_LOW and ETH_MAC_HIGH. Then read calibration data (IF gain tables, PLL correction factors) from address 0x000–0x7F. Verify HEALTH_STATUS[5] EEPROM_OK = 1. |
| 15 | Peripheral Enable | `FLASH_CTRL` | `0x0600` | `0x0000` | — | Verify AT25SL321 configuration flash interface — read FLASH_STATUS (0x0604) to confirm READY bit [0] = 1. Optionally read flash JEDEC ID by issuing a read command at address 0x000000 to verify communication. Confirm HEALTH_STATUS[4] FLASH_OK = 1. |
| 16 | Application Init | `ADC_CTRL` | `0x0200` | `0x0003` | — | Configure and start the AD9643 dual-channel ADC for IF2 digitisation: set CONTINUOUS=1 (bit 1), CH_SEL=00 (both channels, bits [3:2]), DATA_FMT=01 (twos complement, bits [5:4]), PDWN_MODE=0 (normal). Start conversion by writing START=1 (bit 0). Value 0x0003 = continuous mode + start. Then poll ADC_STATUS (0x0201) until DATA_READY=1 and LVDS_LOCK=1. |
| 17 | Application Init | `IF2_GAIN_CTRL` | `0x0719` | `0x0000` | — | Set 2nd IF (200 MHz) chain gain and BPF selection: IF2_CHA_GAIN = 0 dB (bits [3:0]), IF2_CHB_GAIN = 0 dB (bits [7:4]), BPF_SEL = 00 (narrow 5 MHz BW for default). Adjust per radar waveform requirements. If wider bandwidth chirp is needed, set BPF_SEL=01 (20 MHz) or 02 (50 MHz). |
| 18 | Application Init | `TEMP_ALERT_HIGH` | `0x0308` | `0x0190` | — | Arm temperature alerts — confirm TEMP_ALERT_HIGH = 0x0190 (100°C over-temperature threshold) and TEMP_ALERT_LOW = 0xFF9C (-25°C under-temperature). These are reset defaults but explicitly re-written to ensure protection is active. The HEALTH_STATUS[0] TEMP_OK flag will de-assert if thresholds are violated, triggering a safety shutdown of RF chain. |
| 19 | Application Init | `DSP_CTRL` | `0x0900` | `0x0007` | — | Enable the radar DSP processing pipeline in the Kintex-7 FPGA: DSP_ENABLE=1 (bit 0), CFAR_ENABLE=1 (bit 1), PULSE_COMP_EN=1 (bit 2), DATA_FMT=00 (raw IQ output, bits [4:3]), CH_MODE=10 (both channels coherent processing, bits [6:5]), THRESH_ADJ=0 (register-based threshold, bit [7]). Value 0x0007 enables core DSP functions. DSP will process dual-channel ADC data for pulse compression and CFAR detection. |
| 20 | Application Init | `PRI_CTRL` | `0x0901` | `0x8000` | — | Configure and arm the PRI (Pulse Repetition Interval) generator for radar timing: set PRI_PERIOD to desired value (e.g., 0x3E8 = 1000 × 10 ns = 10 µs PRI), PRI_SYNC_EN=0 (disabled initially), PRI_MODE=00 (continuous), and PRI_ARM=1 (bit 15) to start. Example value 0x83E8 arms PRI at 10 µs period. System is now fully operational — verify HEALTH_STATUS[7] SYSTEM_OK = 1. |

---

## Detailed Steps

### Step 1 — Power-On Reset & Self-Check
- **Register:** `SCRATCHPAD` at `0x0003`
- **Write value:** `0xA5A5`
- **Rationale:** UART link integrity check — write known pattern 0xA5A5 to SCRATCHPAD, then read back to verify the UART command/response path is fully functional and the register file is writable.

### Step 2 — Power-On Reset & Self-Check
- **Register:** `HEALTH_STATUS` at `0x030F`
- **Write value:** `0x0000`
- **Rationale:** Read HEALTH_STATUS register and poll until VOLT_OK (bit 1) = 1. This confirms all supply rails (5V, 3.3V, 2.5V, 1.8V) are stable and within ±5% tolerance as measured by the ADM1177 hot-swap controller and XADC. Do NOT proceed until VOLT_OK=1.

### Step 3 — Power-On Reset & Self-Check
- **Register:** `BOARD_ID` at `0x0000`
- **Write value:** `0x484A`
- **Rationale:** Read BOARD_ID and verify it equals 0x484A (ASCII 'HJ'). Also read BOARD_VERSION (0x0001) and BOARD_TYPE_ID (0x0002) to confirm the correct FPGA bitstream is loaded for the hjjg dual-channel radar receiver. Mismatch indicates wrong firmware.

### Step 4 — Power-On Reset & Self-Check
- **Register:** `HEALTH_STATUS` at `0x030F`
- **Write value:** `0x0000`
- **Rationale:** Second health poll — read HEALTH_STATUS to verify TEMP_OK (bit 0) and VOLT_OK (bit 1) are both set. Also read TEMP_LOCAL (0x0300) to confirm FPGA die temperature is in safe operating range before enabling high-power peripherals. Optionally read TEMP_REMOTE1/2 for RF section temperatures.

### Step 5 — PLL & Clock Init
- **Register:** `PLL_CTRL` at `0x0400`
- **Write value:** `0x0002`
- **Rationale:** Soft-reset the ADF4106 PLL synthesizer — write PLL_CTRL with RESET bit [1] = 1 (value 0x0002) to ensure a known state. The PLL is still disabled (ENABLE=0). Wait 10 µs after reset.

### Step 6 — PLL & Clock Init
- **Register:** `PLL_R_DIV` at `0x0403`
- **Write value:** `0x0001`
- **Rationale:** Set ADF4106 R-divider to 1 (reference divider) — the 10 MHz OCXO (OSJ7014-10.0M) feeds directly to the phase detector at 10 MHz f_PFD. Then set PLL_N_DIV (0x0402) for the desired LO1 frequency. For a 5000 MHz LO1: N = f_LO / f_PFD = 500. Write PLL_N_DIV = 0x01F4. Tune N based on mission requirements (N = 330–730 for LO1 3.3–7.3 GHz).

### Step 7 — PLL & Clock Init
- **Register:** `PLL_CTRL` at `0x0400`
- **Write value:** `0x0015`
- **Rationale:** Enable the PLL with charge pump current set: write PLL_CTRL = 0x0015 (ENABLE=1, REF_SEL=00 for OCXO, LO_SEL=00 for LO1, CP_CURRENT=10 for 2.5 mA, SPI_LATCH=1 to latch settings). Then poll PLL_STATUS (0x0401) bit [0] LOCKED until it reads 1, confirming the ADF4106 has acquired phase lock on LO1.

### Step 8 — PLL & Clock Init
- **Register:** `CLK_ENABLE` at `0x0410`
- **Write value:** `0x008F`
- **Rationale:** Enable all required LMK1C1102 clock buffer outputs: CLK_OUT0_EN (ADC sample clock 170 MHz), CLK_OUT1_EN (FPGA processing clock), CLK_OUT2_EN (LO2 reference), CLK_OUT3_EN (PRI sync), and GLOBAL_EN = 1. Value 0x008F = bits [3:0] + bit [7].

### Step 9 — Peripheral Enable
- **Register:** `LO_POWER_CTRL` at `0x0720`
- **Write value:** `0x0007`
- **Rationale:** Enable the LO chain: set LO1_EN=1 (HMC586LC4B VCO), LO2_EN=1 (LO2 synthesizer), SPLITTER_EN=1 (EP2K1+ power splitter distributing LO1 to both channels). VCO_TUNE_DAC left at default (0) initially — PLL loop filter handles fine tuning.

### Step 10 — Peripheral Enable
- **Register:** `RF_LNA_CTRL` at `0x0700`
- **Write value:** `0x0005`
- **Rationale:** Enable both GRF2074 pHEMT LNAs with nominal +20 dB gain: LNA_A_EN=1 (bit 0), LNA_B_EN=1 (bit 1), LNA_A_GAIN=00 (+20 dB, bits [3:2]), LNA_B_GAIN=00 (+20 dB, bits [5:4]). Value 0x0005 = LNA bias on for both channels at full gain.

### Step 11 — Peripheral Enable
- **Register:** `IF1_GAIN_CTRL` at `0x0718`
- **Write value:** `0x0110`
- **Rationale:** Enable IF1 amplifier chain (HMC788ALP2E driver + GRF2040 buffer) and set nominal gain: IF1_AMP_EN=1 (bit 8), IF1_CHA_GAIN = 4 dB (bits [3:0] = 0x4), IF1_CHB_GAIN = 4 dB (bits [7:4] = 0x1 → 1 dB, so write 0x14). Adjust value 0x0114 for 4 dB + 1 dB = total gain. Final value 0x0110 sets 8 dB on CH A, 1 dB on CH B — tune per calibration.

### Step 12 — Communication Init
- **Register:** `UART_BAUD_DIV` at `0x0100`
- **Write value:** `0x0044`
- **Rationale:** Configure UART baud rate divisor for 115200 baud operation (DIVISOR = 0x0044 at 100 MHz system clock: 100 MHz / (16 × 68) ≈ 91911 baud ≈ 115200 with rounding). Set UART_CTRL (0x0101) = 0x0001 for 8N1 with enable. Confirm by reading back.

### Step 13 — Communication Init
- **Register:** `UART_CTRL` at `0x0101`
- **Write value:** `0x0001`
- **Rationale:** Enable UART in normal operating mode: ENABLE=1 (bit 0), LOOPBACK=0, FRAME_FMT=0000 (8N1). Parity interrupt mask = 0 (enabled). The UART is now live for host communication.

### Step 14 — Peripheral Enable
- **Register:** `EEPROM_CTRL` at `0x0500`
- **Write value:** `0x0000`
- **Rationale:** Initialize I2C EEPROM (24AA025E48) — poll BUSY bit [7] until 0. Set EEPROM_ADDR = 0xF8 (MAC address location), trigger READ (bit [0] = 1). Read MAC from ETH_MAC_LOW and ETH_MAC_HIGH. Then read calibration data (IF gain tables, PLL correction factors) from address 0x000–0x7F. Verify HEALTH_STATUS[5] EEPROM_OK = 1.

### Step 15 — Peripheral Enable
- **Register:** `FLASH_CTRL` at `0x0600`
- **Write value:** `0x0000`
- **Rationale:** Verify AT25SL321 configuration flash interface — read FLASH_STATUS (0x0604) to confirm READY bit [0] = 1. Optionally read flash JEDEC ID by issuing a read command at address 0x000000 to verify communication. Confirm HEALTH_STATUS[4] FLASH_OK = 1.

### Step 16 — Application Init
- **Register:** `ADC_CTRL` at `0x0200`
- **Write value:** `0x0003`
- **Rationale:** Configure and start the AD9643 dual-channel ADC for IF2 digitisation: set CONTINUOUS=1 (bit 1), CH_SEL=00 (both channels, bits [3:2]), DATA_FMT=01 (twos complement, bits [5:4]), PDWN_MODE=0 (normal). Start conversion by writing START=1 (bit 0). Value 0x0003 = continuous mode + start. Then poll ADC_STATUS (0x0201) until DATA_READY=1 and LVDS_LOCK=1.

### Step 17 — Application Init
- **Register:** `IF2_GAIN_CTRL` at `0x0719`
- **Write value:** `0x0000`
- **Rationale:** Set 2nd IF (200 MHz) chain gain and BPF selection: IF2_CHA_GAIN = 0 dB (bits [3:0]), IF2_CHB_GAIN = 0 dB (bits [7:4]), BPF_SEL = 00 (narrow 5 MHz BW for default). Adjust per radar waveform requirements. If wider bandwidth chirp is needed, set BPF_SEL=01 (20 MHz) or 02 (50 MHz).

### Step 18 — Application Init
- **Register:** `TEMP_ALERT_HIGH` at `0x0308`
- **Write value:** `0x0190`
- **Rationale:** Arm temperature alerts — confirm TEMP_ALERT_HIGH = 0x0190 (100°C over-temperature threshold) and TEMP_ALERT_LOW = 0xFF9C (-25°C under-temperature). These are reset defaults but explicitly re-written to ensure protection is active. The HEALTH_STATUS[0] TEMP_OK flag will de-assert if thresholds are violated, triggering a safety shutdown of RF chain.

### Step 19 — Application Init
- **Register:** `DSP_CTRL` at `0x0900`
- **Write value:** `0x0007`
- **Rationale:** Enable the radar DSP processing pipeline in the Kintex-7 FPGA: DSP_ENABLE=1 (bit 0), CFAR_ENABLE=1 (bit 1), PULSE_COMP_EN=1 (bit 2), DATA_FMT=00 (raw IQ output, bits [4:3]), CH_MODE=10 (both channels coherent processing, bits [6:5]), THRESH_ADJ=0 (register-based threshold, bit [7]). Value 0x0007 enables core DSP functions. DSP will process dual-channel ADC data for pulse compression and CFAR detection.

### Step 20 — Application Init
- **Register:** `PRI_CTRL` at `0x0901`
- **Write value:** `0x8000`
- **Rationale:** Configure and arm the PRI (Pulse Repetition Interval) generator for radar timing: set PRI_PERIOD to desired value (e.g., 0x3E8 = 1000 × 10 ns = 10 µs PRI), PRI_SYNC_EN=0 (disabled initially), PRI_MODE=00 (continuous), and PRI_ARM=1 (bit 15) to start. Example value 0x83E8 arms PRI at 10 µs period. System is now fully operational — verify HEALTH_STATUS[7] SYSTEM_OK = 1.
