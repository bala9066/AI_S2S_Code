# Programming Sequence (PSQ)
## receiver

> **Total steps:** 20

| # | Phase | Register | Address | Value | Condition | Rationale |
|---|-------|----------|---------|-------|-----------|-----------|
| 1 | Power-On Reset & Self-Check | `SCRATCHPAD` | `0x0003` | `0xA5A5` | Read back and verify value matches | RAM/health check: Write known pattern and read back to verify register interface integrity |
| 2 | Power-On Reset & Self-Check | `BOARD_ID` | `0x0000` | `0x0000` | Verify return value equals 0x5245 ('RE') | Board identification: Confirm correct FPGA image is loaded for receiver board |
| 3 | Power-On Reset & Self-Check | `HEALTH_STATUS` | `0x030F` | `0x0000` | Poll until VOLT_OK (bit1) = 1 and RF_POWER_OK (bit3) = 1 | Power supply stabilization: Wait for all DC-DC converter rails to be within tolerance before enabling RF circuitry |
| 4 | Power-On Reset & Self-Check | `TEMP_LOCAL` | `0x0300` | `0x0000` | Read temperature, verify within -40°C to +85°C range | FPGA temperature check: Ensure die temperature is within operating range before proceeding |
| 5 | PLL & Clock Init | `PLL_CTRL` | `0x0400` | `0x02` | Wait 1us for reset to complete | PLL reset: Assert reset bit to ensure PLL starts from known state |
| 6 | PLL & Clock Init | `PLL_N_DIV` | `0x0402` | `0x0040` | None | Configure PLL N divider: Set to 64 for nominal LO frequency planning |
| 7 | PLL & Clock Init | `PLL_R_DIV` | `0x0403` | `0x0001` | None | Configure PLL R divider: Set to 1 for reference clock division |
| 8 | PLL & Clock Init | `PLL_CTRL` | `0x0400` | `0x01` | Poll PLL_STATUS (0x0401) bit0 (LOCKED) until =1 | Enable PLL and wait for lock: ADF5356 LO synthesizer must lock before RF operation |
| 9 | PLL & Clock Init | `CLK_ENABLE` | `0x0410` | `0x83` | None | Enable clock distribution: ADC clock (bit0), LO interface clock (bit1), FPGA system clock (bit7) |
| 10 | PLL & Clock Init | `LO_CTRL` | `0x0422` | `0x00` | Poll STATUS until LO output stable | Enable LO output: Unmute and enable LO synthesizer output (bit0=enable, bit7=unmute) |
| 11 | Peripheral Enable | `RF_CTRL` | `0x0803` | `0x0F` | Wait 100us for amplifiers to stabilize | Enable RF front-end chain: LNA, VGA, Mixer, and IF Amplifier in signal path order |
| 12 | Peripheral Enable | `ADC_IF_CTRL` | `0x0805` | `0x01` | Poll ADC_STATUS_IF (0x0806) bit0 (ADC_READY) until =1 | Enable AD9208 ADC: Power up and initialize dual-channel IQ ADC |
| 13 | Communication Init | `UART_BAUD_DIV` | `0x0100` | `0x0034` | None | Configure UART baud rate: Set divisor for 115200 baud @ 50MHz system clock |
| 14 | Communication Init | `UART_CTRL` | `0x0101` | `0x01` | None | Enable UART: Set enable bit for control interface communication |
| 15 | Application Init | `TEMP_ALERT_HIGH` | `0x0308` | `0x0190` | None | Arm temperature alerts: Set over-temperature threshold to 100°C |
| 16 | Application Init | `TEMP_ALERT_LOW` | `0x0309` | `0xFF9C` | None | Arm under-temperature alerts: Set threshold to -25°C for cold start detection |
| 17 | Application Init | `IRQ_MASK` | `0x0900` | `0x87` | None | Configure interrupt masks: Enable PLL loss, temp alert, and ADC overflow interrupts |
| 18 | Application Init | `VGA_GAIN` | `0x0804` | `0x7F` | None | Set initial VGA gain: Mid-scale gain code for nominal RF input level handling |
| 19 | Application Init | `EEPROM_CTRL` | `0x0500` | `0x00` | Poll BUSY bit7 until =0 | Verify EEPROM ready: Ensure non-volatile storage is idle before calibration data access |
| 20 | Application Init | `CALIB_CTRL` | `0x0A00` | `0x03` | Poll CALIB_STATUS (0x0A01) bit0 (CALIB_DONE) until =1 | Start auto-calibration: Trigger DC offset, gain, and IQ phase calibration sequence for receive path |

---

## Detailed Steps

### Step 1 — Power-On Reset & Self-Check
- **Register:** `SCRATCHPAD` at `0x0003`
- **Write value:** `0xA5A5`
- **Wait/Poll:** Read back and verify value matches
- **Rationale:** RAM/health check: Write known pattern and read back to verify register interface integrity

### Step 2 — Power-On Reset & Self-Check
- **Register:** `BOARD_ID` at `0x0000`
- **Write value:** `0x0000`
- **Wait/Poll:** Verify return value equals 0x5245 ('RE')
- **Rationale:** Board identification: Confirm correct FPGA image is loaded for receiver board

### Step 3 — Power-On Reset & Self-Check
- **Register:** `HEALTH_STATUS` at `0x030F`
- **Write value:** `0x0000`
- **Wait/Poll:** Poll until VOLT_OK (bit1) = 1 and RF_POWER_OK (bit3) = 1
- **Rationale:** Power supply stabilization: Wait for all DC-DC converter rails to be within tolerance before enabling RF circuitry

### Step 4 — Power-On Reset & Self-Check
- **Register:** `TEMP_LOCAL` at `0x0300`
- **Write value:** `0x0000`
- **Wait/Poll:** Read temperature, verify within -40°C to +85°C range
- **Rationale:** FPGA temperature check: Ensure die temperature is within operating range before proceeding

### Step 5 — PLL & Clock Init
- **Register:** `PLL_CTRL` at `0x0400`
- **Write value:** `0x02`
- **Wait/Poll:** Wait 1us for reset to complete
- **Rationale:** PLL reset: Assert reset bit to ensure PLL starts from known state

### Step 6 — PLL & Clock Init
- **Register:** `PLL_N_DIV` at `0x0402`
- **Write value:** `0x0040`
- **Wait/Poll:** None
- **Rationale:** Configure PLL N divider: Set to 64 for nominal LO frequency planning

### Step 7 — PLL & Clock Init
- **Register:** `PLL_R_DIV` at `0x0403`
- **Write value:** `0x0001`
- **Wait/Poll:** None
- **Rationale:** Configure PLL R divider: Set to 1 for reference clock division

### Step 8 — PLL & Clock Init
- **Register:** `PLL_CTRL` at `0x0400`
- **Write value:** `0x01`
- **Wait/Poll:** Poll PLL_STATUS (0x0401) bit0 (LOCKED) until =1
- **Rationale:** Enable PLL and wait for lock: ADF5356 LO synthesizer must lock before RF operation

### Step 9 — PLL & Clock Init
- **Register:** `CLK_ENABLE` at `0x0410`
- **Write value:** `0x83`
- **Wait/Poll:** None
- **Rationale:** Enable clock distribution: ADC clock (bit0), LO interface clock (bit1), FPGA system clock (bit7)

### Step 10 — PLL & Clock Init
- **Register:** `LO_CTRL` at `0x0422`
- **Write value:** `0x00`
- **Wait/Poll:** Poll STATUS until LO output stable
- **Rationale:** Enable LO output: Unmute and enable LO synthesizer output (bit0=enable, bit7=unmute)

### Step 11 — Peripheral Enable
- **Register:** `RF_CTRL` at `0x0803`
- **Write value:** `0x0F`
- **Wait/Poll:** Wait 100us for amplifiers to stabilize
- **Rationale:** Enable RF front-end chain: LNA, VGA, Mixer, and IF Amplifier in signal path order

### Step 12 — Peripheral Enable
- **Register:** `ADC_IF_CTRL` at `0x0805`
- **Write value:** `0x01`
- **Wait/Poll:** Poll ADC_STATUS_IF (0x0806) bit0 (ADC_READY) until =1
- **Rationale:** Enable AD9208 ADC: Power up and initialize dual-channel IQ ADC

### Step 13 — Communication Init
- **Register:** `UART_BAUD_DIV` at `0x0100`
- **Write value:** `0x0034`
- **Wait/Poll:** None
- **Rationale:** Configure UART baud rate: Set divisor for 115200 baud @ 50MHz system clock

### Step 14 — Communication Init
- **Register:** `UART_CTRL` at `0x0101`
- **Write value:** `0x01`
- **Wait/Poll:** None
- **Rationale:** Enable UART: Set enable bit for control interface communication

### Step 15 — Application Init
- **Register:** `TEMP_ALERT_HIGH` at `0x0308`
- **Write value:** `0x0190`
- **Wait/Poll:** None
- **Rationale:** Arm temperature alerts: Set over-temperature threshold to 100°C

### Step 16 — Application Init
- **Register:** `TEMP_ALERT_LOW` at `0x0309`
- **Write value:** `0xFF9C`
- **Wait/Poll:** None
- **Rationale:** Arm under-temperature alerts: Set threshold to -25°C for cold start detection

### Step 17 — Application Init
- **Register:** `IRQ_MASK` at `0x0900`
- **Write value:** `0x87`
- **Wait/Poll:** None
- **Rationale:** Configure interrupt masks: Enable PLL loss, temp alert, and ADC overflow interrupts

### Step 18 — Application Init
- **Register:** `VGA_GAIN` at `0x0804`
- **Write value:** `0x7F`
- **Wait/Poll:** None
- **Rationale:** Set initial VGA gain: Mid-scale gain code for nominal RF input level handling

### Step 19 — Application Init
- **Register:** `EEPROM_CTRL` at `0x0500`
- **Write value:** `0x00`
- **Wait/Poll:** Poll BUSY bit7 until =0
- **Rationale:** Verify EEPROM ready: Ensure non-volatile storage is idle before calibration data access

### Step 20 — Application Init
- **Register:** `CALIB_CTRL` at `0x0A00`
- **Write value:** `0x03`
- **Wait/Poll:** Poll CALIB_STATUS (0x0A01) bit0 (CALIB_DONE) until =1
- **Rationale:** Start auto-calibration: Trigger DC offset, gain, and IQ phase calibration sequence for receive path
