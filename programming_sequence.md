# Programming Sequence (PSQ)
## dsf

> **Total steps:** 20

| # | Phase | Register | Address | Value | Condition | Rationale |
|---|-------|----------|---------|-------|-----------|-----------|
| 1 | Power-On Reset & Self-Check | `SCRATCHPAD` | `0x0003` | `0xA5A5` | Read back verify = 0xA5A5 | RAM integrity check - verify register read/write path functional |
| 2 | Power-On Reset & Self-Check | `BOARD_ID` | `0x0000` | `0x0000` | Verify return = 0x4453 ('DS') | Confirm correct FPGA image loaded for dsf project |
| 3 | Power-On Reset & Self-Check | `HEALTH_STATUS` | `0x030F` | `0x0000` | Poll until VOLT_OK=1 (bit 1 set) | Wait for all power rails (+12V, +5V, +3.3V, +1.8V, +1.2V) to stabilize |
| 4 | Power-On Reset & Self-Check | `TEMP_LOCAL` | `0x0300` | `0x0000` | Verify TEMP < 85°C | Check FPGA die temperature within safe operating range |
| 5 | PLL & Clock Init | `PLL_N_DIV` | `0x0402` | `0x0014` | None | Set LMX2594 N divider = 20 for 10GHz LO from 500MHz reference |
| 6 | PLL & Clock Init | `PLL_R_DIV` | `0x0403` | `0x01` | None | Set LMX2594 R divider = 1 (no prescaler) |
| 7 | PLL & Clock Init | `PLL_CTRL` | `0x0400` | `0x01` | Poll PLL_STATUS[0]=1 until LOCKED=1 | Enable LMX2594 synthesizer and verify lock - critical for RF downconversion |
| 8 | PLL & Clock Init | `CLK_ENABLE` | `0x0410` | `0x05` | None | Enable ADC clock (bit 0) and JESD204B clock (bit 2) - FPGA clock already on |
| 9 | Peripheral Enable | `TEMP_ALERT_HIGH` | `0x0308` | `0x0190` | None | Set over-temperature alert to 100°C for ADC/VGA protection |
| 10 | Peripheral Enable | `TEMP_ALERT_LOW` | `0x0309` | `0xFF9C` | None | Set under-temperature alert to -25°C for cold start detection |
| 11 | Communication Init | `UART_BAUD_DIV` | `0x0100` | `0x00B2` | None | Configure UART for 115200 baud (100MHz/16/115200 = 54.25 ≈ 0xB2) |
| 12 | Communication Init | `UART_CTRL` | `0x0101` | `0x03` | None | Enable UART with 8N1 frame format (bits [7:4]=0x3, ENABLE=1) |
| 13 | Application Init - RF Front-End | `RF_LO_FREQ_HIGH` | `0x0700` | `0x09C4` | None | Set LO frequency high word for ~10GHz downconversion center frequency |
| 14 | Application Init - RF Front-End | `RF_LO_FREQ_LOW` | `0x0701` | `0x0000` | None | Set LO frequency low word for fine frequency control |
| 15 | Application Init - RF Front-End | `VGA_GAIN_CTRL` | `0x0702` | `0x40` | None | Initialize HMC698LP2 VGA to mid-scale gain (0dB) for nominal signal level |
| 16 | Application Init - JESD204B Link | `JESD204B_CTRL` | `0x0704` | `0x14` | None | Configure JESD204B: LINK_EN=1, 2 lanes (bits[3:2]=1), Subclass 1 (bits[6:4]=1) |
| 17 | Application Init - JESD204B Link | `ADC_CTRL` | `0x0200` | `0x13` | Poll ADC_STATUS[2]=1 until JESD_LOCKED=1 | Enable ADC10DX300 with continuous mode and verify JESD204B link lock |
| 18 | Application Init - Calibration Load | `EEPROM_ADDR` | `0x0501` | `0x0000` | None | Set EEPROM address to start of calibration data region |
| 19 | Application Init - Calibration Load | `EEPROM_CTRL` | `0x0500` | `0x01` | Poll until BUSY=0, then read EEPROM_DATA | Read factory calibration data from EEPROM for VGA gain lookup table |
| 20 | Final Verification | `HEALTH_STATUS` | `0x030F` | `0x0000` | Verify SYSTEM_OK=1 (all flags pass) | Final system health check - all subsystems operational before ready state |

---

## Detailed Steps

### Step 1 — Power-On Reset & Self-Check
- **Register:** `SCRATCHPAD` at `0x0003`
- **Write value:** `0xA5A5`
- **Wait/Poll:** Read back verify = 0xA5A5
- **Rationale:** RAM integrity check - verify register read/write path functional

### Step 2 — Power-On Reset & Self-Check
- **Register:** `BOARD_ID` at `0x0000`
- **Write value:** `0x0000`
- **Wait/Poll:** Verify return = 0x4453 ('DS')
- **Rationale:** Confirm correct FPGA image loaded for dsf project

### Step 3 — Power-On Reset & Self-Check
- **Register:** `HEALTH_STATUS` at `0x030F`
- **Write value:** `0x0000`
- **Wait/Poll:** Poll until VOLT_OK=1 (bit 1 set)
- **Rationale:** Wait for all power rails (+12V, +5V, +3.3V, +1.8V, +1.2V) to stabilize

### Step 4 — Power-On Reset & Self-Check
- **Register:** `TEMP_LOCAL` at `0x0300`
- **Write value:** `0x0000`
- **Wait/Poll:** Verify TEMP < 85°C
- **Rationale:** Check FPGA die temperature within safe operating range

### Step 5 — PLL & Clock Init
- **Register:** `PLL_N_DIV` at `0x0402`
- **Write value:** `0x0014`
- **Wait/Poll:** None
- **Rationale:** Set LMX2594 N divider = 20 for 10GHz LO from 500MHz reference

### Step 6 — PLL & Clock Init
- **Register:** `PLL_R_DIV` at `0x0403`
- **Write value:** `0x01`
- **Wait/Poll:** None
- **Rationale:** Set LMX2594 R divider = 1 (no prescaler)

### Step 7 — PLL & Clock Init
- **Register:** `PLL_CTRL` at `0x0400`
- **Write value:** `0x01`
- **Wait/Poll:** Poll PLL_STATUS[0]=1 until LOCKED=1
- **Rationale:** Enable LMX2594 synthesizer and verify lock - critical for RF downconversion

### Step 8 — PLL & Clock Init
- **Register:** `CLK_ENABLE` at `0x0410`
- **Write value:** `0x05`
- **Wait/Poll:** None
- **Rationale:** Enable ADC clock (bit 0) and JESD204B clock (bit 2) - FPGA clock already on

### Step 9 — Peripheral Enable
- **Register:** `TEMP_ALERT_HIGH` at `0x0308`
- **Write value:** `0x0190`
- **Wait/Poll:** None
- **Rationale:** Set over-temperature alert to 100°C for ADC/VGA protection

### Step 10 — Peripheral Enable
- **Register:** `TEMP_ALERT_LOW` at `0x0309`
- **Write value:** `0xFF9C`
- **Wait/Poll:** None
- **Rationale:** Set under-temperature alert to -25°C for cold start detection

### Step 11 — Communication Init
- **Register:** `UART_BAUD_DIV` at `0x0100`
- **Write value:** `0x00B2`
- **Wait/Poll:** None
- **Rationale:** Configure UART for 115200 baud (100MHz/16/115200 = 54.25 ≈ 0xB2)

### Step 12 — Communication Init
- **Register:** `UART_CTRL` at `0x0101`
- **Write value:** `0x03`
- **Wait/Poll:** None
- **Rationale:** Enable UART with 8N1 frame format (bits [7:4]=0x3, ENABLE=1)

### Step 13 — Application Init - RF Front-End
- **Register:** `RF_LO_FREQ_HIGH` at `0x0700`
- **Write value:** `0x09C4`
- **Wait/Poll:** None
- **Rationale:** Set LO frequency high word for ~10GHz downconversion center frequency

### Step 14 — Application Init - RF Front-End
- **Register:** `RF_LO_FREQ_LOW` at `0x0701`
- **Write value:** `0x0000`
- **Wait/Poll:** None
- **Rationale:** Set LO frequency low word for fine frequency control

### Step 15 — Application Init - RF Front-End
- **Register:** `VGA_GAIN_CTRL` at `0x0702`
- **Write value:** `0x40`
- **Wait/Poll:** None
- **Rationale:** Initialize HMC698LP2 VGA to mid-scale gain (0dB) for nominal signal level

### Step 16 — Application Init - JESD204B Link
- **Register:** `JESD204B_CTRL` at `0x0704`
- **Write value:** `0x14`
- **Wait/Poll:** None
- **Rationale:** Configure JESD204B: LINK_EN=1, 2 lanes (bits[3:2]=1), Subclass 1 (bits[6:4]=1)

### Step 17 — Application Init - JESD204B Link
- **Register:** `ADC_CTRL` at `0x0200`
- **Write value:** `0x13`
- **Wait/Poll:** Poll ADC_STATUS[2]=1 until JESD_LOCKED=1
- **Rationale:** Enable ADC10DX300 with continuous mode and verify JESD204B link lock

### Step 18 — Application Init - Calibration Load
- **Register:** `EEPROM_ADDR` at `0x0501`
- **Write value:** `0x0000`
- **Wait/Poll:** None
- **Rationale:** Set EEPROM address to start of calibration data region

### Step 19 — Application Init - Calibration Load
- **Register:** `EEPROM_CTRL` at `0x0500`
- **Write value:** `0x01`
- **Wait/Poll:** Poll until BUSY=0, then read EEPROM_DATA
- **Rationale:** Read factory calibration data from EEPROM for VGA gain lookup table

### Step 20 — Final Verification
- **Register:** `HEALTH_STATUS` at `0x030F`
- **Write value:** `0x0000`
- **Wait/Poll:** Verify SYSTEM_OK=1 (all flags pass)
- **Rationale:** Final system health check - all subsystems operational before ready state
