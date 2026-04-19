# Programming Sequence (PSQ)
## hm

> **Total steps:** 28

| # | Phase | Register | Address | Value | Condition | Rationale |
|---|-------|----------|---------|-------|-----------|-----------|
| 1 | Power-On Reset & Self-Check | `SCRATCHPAD` | `0x0003` | `0xA5A5` | — | Verify FPGA register interface and UART link integrity by writing known pattern to scratchpad register |
| 2 | Power-On Reset & Self-Check | `SCRATCHPAD` | `0x0003` | `0x0000` | Poll: read SCRATCHPAD until value == 0xA5A5 (verify write was successful) | Read back scratchpad to confirm UART read/write path is functional; then clear it |
| 3 | Power-On Reset & Self-Check | `BOARD_ID` | `0x0000` | `0x0000` | Poll: read BOARD_ID until value == 0x686D | Verify board identity matches expected hm module (0x686D = ASCII 'hm'). Reject if mismatch. |
| 4 | Power-On Reset & Self-Check | `HEALTH_STATUS` | `0x030F` | `0x0000` | Poll: read HEALTH_STATUS until VOLT_OK (bit1)=1, timeout after 500ms | Wait for all power rails (5V, 3.3V, 2.5V, 1.8V) to stabilize within ±5% tolerance before enabling any peripherals |
| 5 | PLL & Clock Init | `RF_CHAIN_POWER` | `0x0708` | `0x0001` | — | Enable DC-DC converter (LTM8074) first — produces +5V rail from +28V input. This is the primary supply for the RF chain. |
| 6 | PLL & Clock Init | `RF_CHAIN_POWER` | `0x0708` | `0x0003` | Poll: HEALTH_STATUS.VOLT_OK=1 and RF_CHAIN_POWER.SEQ_STATE=2 (DCDC ramp complete) | Enable LDO (LT3045) after DC-DC is stable — produces low-noise +3.3V rail for PLL synthesizer and VCO tuning |
| 7 | PLL & Clock Init | `PLL_CTRL` | `0x0400` | `0x0602` | — | Configure PLL: REF_SEL=internal TCXO (bits[3:2]=00), CP_CURRENT=1.2mA (bits[7:6]=01), PD_POL=positive (bit9=1), MUX=DIG_LOCK. Do NOT enable yet. |
| 8 | PLL & Clock Init | `PLL_N_DIV_INT` | `0x0402` | `0x0025` | — | Set PLL integer-N divider to 37 (0x25). For f_ref=10MHz, N_int=37 → LO = 370 MHz → RF = 300 MHz with 70 MHz IF. |
| 9 | PLL & Clock Init | `PLL_R_DIV` | `0x0406` | `0x0001` | — | Set PLL R divider to 1 (10 MHz TCXO reference → 10 MHz PFD rate). Ensures phase detector operates at correct frequency. |
| 10 | PLL & Clock Init | `PLL_CTRL` | `0x0400` | `0x0603` | Poll: PLL_STATUS.LOCKED (bit0)=1, timeout after 50ms | Enable PLL (set ENABLE bit0=1). ADF4153A begins acquisition. Poll until LOCKED confirms phase-lock to reference TCXO. |
| 11 | PLL & Clock Init | `CLK_ENABLE` | `0x0410` | `0x009F` | — | Enable all required clock outputs: CLK0 (system), CLK1 (ADC), CLK2 (SPI), CLK3 (baseband filter), CLK4 (RF switches). CLK_ALL master gate ON (bit7=1). |
| 12 | Peripheral Enable | `RF_CHAIN_POWER` | `0x0708` | `0x0007` | Poll: RF_CHAIN_POWER.SEQ_STATE=4 (READY) | Enable full RF chain (DCDC_EN + LDO_EN + RF_EN). Sequencer reaches READY state — all bias voltages stable for RF components. |
| 13 | Peripheral Enable | `RF_SPDT_CTRL` | `0x0700` | `0x0081` | — | Configure RF SPDT switches: SW_EN=1 (master enable), SW1=0/SW2=1 → select 300-500 MHz sub-band (path A). HMC253LC4 routes signal through appropriate bandpass filter. |
| 14 | Peripheral Enable | `LNA_CTRL` | `0x0706` | `0x0021` | — | Enable LNA (PMA3-83LN+): ENABLE=1, BIAS_TRIM=0 (factory default), PROTECT=1 (overload protection enabled). Sets system noise figure to 2 dB. |
| 15 | Peripheral Enable | `LO_BUF_CTRL` | `0x0707` | `0x0003` | — | Enable LO buffer amplifier (GVA-84+): ENABLE=1, POWER=medium (+7 dBm drive to ADE-25MH+ mixer LO port). |
| 16 | Peripheral Enable | `IF_VGA_CTRL` | `0x0704` | `0x0400` | — | Initialize IF VGA (ADL5330): GAIN=mid-scale (0x200 ≈ 0 dB), AGC_EN=0 (manual mode initially). VGA provides ~40 dB gain range for 70 MHz IF AGC. |
| 17 | Peripheral Enable | `IQ_DEMOD_CTRL` | `0x0703` | `0x0001` | — | Enable IQ demodulator (LTC5596): ENABLE=1, LO_MODE=PLL divider (70 MHz quadrature LO), default gain/bias. Splits IF into I and Q baseband channels. |
| 18 | Peripheral Enable | `BB_LPF_CTRL` | `0x0705` | `0x0083` | — | Configure baseband LPF (LTC1569-7): ENABLE=1, CUTOFF=5 MHz (default for pulse-Doppler), RESPONSE=Butterworth (max flatness). Group delay variation < 1 ns. |
| 19 | Communication Init | `UART_BAUD_DIV` | `0x0100` | `0x0036` | — | Set UART baud rate divisor to 54 (0x36) for 115200 baud at 100 MHz system clock: baud = 100MHz / (16 × 54) ≈ 115741 baud (0.47% error). |
| 20 | Communication Init | `UART_CTRL` | `0x0101` | `0x0001` | — | Enable UART with 8N1 frame format, loopback off, interrupts disabled initially. Communication channel ready for host commands. |
| 21 | Communication Init | `SYSTEM_CTRL` | `0x0803` | `0x0090` | — | Configure system control: LED_CTRL=heartbeat blink (bits[7:5]=100), CAL_MODE=0 (normal operation), INT_EN=1 (global interrupt enable), WATCHDOG_EN=0 (enable after full init). |
| 22 | Application Init | `TEMP_ALERT_HIGH` | `0x0308` | `0x1190` | — | Arm over-temperature alert: threshold=100°C (0x190), ENABLE=1 (bit12=1). Critical for RF chain thermal protection in pulsed radar duty cycle operation. |
| 23 | Application Init | `TEMP_ALERT_LOW` | `0x0309` | `0x19C` | — | Arm under-temperature alert: threshold=-25°C for cold-start protection. Ensures RF components (especially VCO) are within operating range. |
| 24 | Application Init | `PULSE_GATE_CTRL` | `0x0900` | `0x0000` | — | Pulse gate disabled initially as a safe default. Will be configured per operational mode (range gate timing depends on target application). |
| 25 | Application Init | `ADC_CTRL` | `0x0200` | `0x0002` | Poll: ADC_STATUS.DATA_READY=1 | Start first ADC conversion in continuous mode to begin monitoring supply voltages (5V, 3.3V, 2.5V, 1.8V rails) for ongoing health reporting. |
| 26 | Application Init | `EEPROM_CTRL` | `0x0500` | `0x0001` | Poll: EEPROM_CTRL.BUSY=0 | Read first EEPROM calibration data block (contains LNA bias trim, VGA gain offsets, PLL correction factors). Address defaults to 0x0000. |
| 27 | Application Init | `FLASH_CTRL` | `0x0600` | `0x0011` | Poll: FLASH_CTRL.BUSY=0, verify FLASH_ID == 0x9D (ISSI manufacturer) | Initialize QSPI flash (IS25LP016D) in quad mode and read JEDEC ID to verify device presence. Flash stores FPGA configuration fallback and operational parameters. |
| 28 | Application Init | `HEALTH_STATUS` | `0x030F` | `0x0000` | Poll: HEALTH_STATUS.SYSTEM_OK (bit7)=1 | Final system health check — verify all subsystems healthy (TEMP_OK, VOLT_OK, PLL_LOCKED, FLASH_RDY, RF_POWER_OK all set). Module is ready for operational mode command. |

---

## Detailed Steps

### Step 1 — Power-On Reset & Self-Check
- **Register:** `SCRATCHPAD` at `0x0003`
- **Write value:** `0xA5A5`
- **Rationale:** Verify FPGA register interface and UART link integrity by writing known pattern to scratchpad register

### Step 2 — Power-On Reset & Self-Check
- **Register:** `SCRATCHPAD` at `0x0003`
- **Write value:** `0x0000`
- **Wait/Poll:** Poll: read SCRATCHPAD until value == 0xA5A5 (verify write was successful)
- **Rationale:** Read back scratchpad to confirm UART read/write path is functional; then clear it

### Step 3 — Power-On Reset & Self-Check
- **Register:** `BOARD_ID` at `0x0000`
- **Write value:** `0x0000`
- **Wait/Poll:** Poll: read BOARD_ID until value == 0x686D
- **Rationale:** Verify board identity matches expected hm module (0x686D = ASCII 'hm'). Reject if mismatch.

### Step 4 — Power-On Reset & Self-Check
- **Register:** `HEALTH_STATUS` at `0x030F`
- **Write value:** `0x0000`
- **Wait/Poll:** Poll: read HEALTH_STATUS until VOLT_OK (bit1)=1, timeout after 500ms
- **Rationale:** Wait for all power rails (5V, 3.3V, 2.5V, 1.8V) to stabilize within ±5% tolerance before enabling any peripherals

### Step 5 — PLL & Clock Init
- **Register:** `RF_CHAIN_POWER` at `0x0708`
- **Write value:** `0x0001`
- **Rationale:** Enable DC-DC converter (LTM8074) first — produces +5V rail from +28V input. This is the primary supply for the RF chain.

### Step 6 — PLL & Clock Init
- **Register:** `RF_CHAIN_POWER` at `0x0708`
- **Write value:** `0x0003`
- **Wait/Poll:** Poll: HEALTH_STATUS.VOLT_OK=1 and RF_CHAIN_POWER.SEQ_STATE=2 (DCDC ramp complete)
- **Rationale:** Enable LDO (LT3045) after DC-DC is stable — produces low-noise +3.3V rail for PLL synthesizer and VCO tuning

### Step 7 — PLL & Clock Init
- **Register:** `PLL_CTRL` at `0x0400`
- **Write value:** `0x0602`
- **Rationale:** Configure PLL: REF_SEL=internal TCXO (bits[3:2]=00), CP_CURRENT=1.2mA (bits[7:6]=01), PD_POL=positive (bit9=1), MUX=DIG_LOCK. Do NOT enable yet.

### Step 8 — PLL & Clock Init
- **Register:** `PLL_N_DIV_INT` at `0x0402`
- **Write value:** `0x0025`
- **Rationale:** Set PLL integer-N divider to 37 (0x25). For f_ref=10MHz, N_int=37 → LO = 370 MHz → RF = 300 MHz with 70 MHz IF.

### Step 9 — PLL & Clock Init
- **Register:** `PLL_R_DIV` at `0x0406`
- **Write value:** `0x0001`
- **Rationale:** Set PLL R divider to 1 (10 MHz TCXO reference → 10 MHz PFD rate). Ensures phase detector operates at correct frequency.

### Step 10 — PLL & Clock Init
- **Register:** `PLL_CTRL` at `0x0400`
- **Write value:** `0x0603`
- **Wait/Poll:** Poll: PLL_STATUS.LOCKED (bit0)=1, timeout after 50ms
- **Rationale:** Enable PLL (set ENABLE bit0=1). ADF4153A begins acquisition. Poll until LOCKED confirms phase-lock to reference TCXO.

### Step 11 — PLL & Clock Init
- **Register:** `CLK_ENABLE` at `0x0410`
- **Write value:** `0x009F`
- **Rationale:** Enable all required clock outputs: CLK0 (system), CLK1 (ADC), CLK2 (SPI), CLK3 (baseband filter), CLK4 (RF switches). CLK_ALL master gate ON (bit7=1).

### Step 12 — Peripheral Enable
- **Register:** `RF_CHAIN_POWER` at `0x0708`
- **Write value:** `0x0007`
- **Wait/Poll:** Poll: RF_CHAIN_POWER.SEQ_STATE=4 (READY)
- **Rationale:** Enable full RF chain (DCDC_EN + LDO_EN + RF_EN). Sequencer reaches READY state — all bias voltages stable for RF components.

### Step 13 — Peripheral Enable
- **Register:** `RF_SPDT_CTRL` at `0x0700`
- **Write value:** `0x0081`
- **Rationale:** Configure RF SPDT switches: SW_EN=1 (master enable), SW1=0/SW2=1 → select 300-500 MHz sub-band (path A). HMC253LC4 routes signal through appropriate bandpass filter.

### Step 14 — Peripheral Enable
- **Register:** `LNA_CTRL` at `0x0706`
- **Write value:** `0x0021`
- **Rationale:** Enable LNA (PMA3-83LN+): ENABLE=1, BIAS_TRIM=0 (factory default), PROTECT=1 (overload protection enabled). Sets system noise figure to 2 dB.

### Step 15 — Peripheral Enable
- **Register:** `LO_BUF_CTRL` at `0x0707`
- **Write value:** `0x0003`
- **Rationale:** Enable LO buffer amplifier (GVA-84+): ENABLE=1, POWER=medium (+7 dBm drive to ADE-25MH+ mixer LO port).

### Step 16 — Peripheral Enable
- **Register:** `IF_VGA_CTRL` at `0x0704`
- **Write value:** `0x0400`
- **Rationale:** Initialize IF VGA (ADL5330): GAIN=mid-scale (0x200 ≈ 0 dB), AGC_EN=0 (manual mode initially). VGA provides ~40 dB gain range for 70 MHz IF AGC.

### Step 17 — Peripheral Enable
- **Register:** `IQ_DEMOD_CTRL` at `0x0703`
- **Write value:** `0x0001`
- **Rationale:** Enable IQ demodulator (LTC5596): ENABLE=1, LO_MODE=PLL divider (70 MHz quadrature LO), default gain/bias. Splits IF into I and Q baseband channels.

### Step 18 — Peripheral Enable
- **Register:** `BB_LPF_CTRL` at `0x0705`
- **Write value:** `0x0083`
- **Rationale:** Configure baseband LPF (LTC1569-7): ENABLE=1, CUTOFF=5 MHz (default for pulse-Doppler), RESPONSE=Butterworth (max flatness). Group delay variation < 1 ns.

### Step 19 — Communication Init
- **Register:** `UART_BAUD_DIV` at `0x0100`
- **Write value:** `0x0036`
- **Rationale:** Set UART baud rate divisor to 54 (0x36) for 115200 baud at 100 MHz system clock: baud = 100MHz / (16 × 54) ≈ 115741 baud (0.47% error).

### Step 20 — Communication Init
- **Register:** `UART_CTRL` at `0x0101`
- **Write value:** `0x0001`
- **Rationale:** Enable UART with 8N1 frame format, loopback off, interrupts disabled initially. Communication channel ready for host commands.

### Step 21 — Communication Init
- **Register:** `SYSTEM_CTRL` at `0x0803`
- **Write value:** `0x0090`
- **Rationale:** Configure system control: LED_CTRL=heartbeat blink (bits[7:5]=100), CAL_MODE=0 (normal operation), INT_EN=1 (global interrupt enable), WATCHDOG_EN=0 (enable after full init).

### Step 22 — Application Init
- **Register:** `TEMP_ALERT_HIGH` at `0x0308`
- **Write value:** `0x1190`
- **Rationale:** Arm over-temperature alert: threshold=100°C (0x190), ENABLE=1 (bit12=1). Critical for RF chain thermal protection in pulsed radar duty cycle operation.

### Step 23 — Application Init
- **Register:** `TEMP_ALERT_LOW` at `0x0309`
- **Write value:** `0x19C`
- **Rationale:** Arm under-temperature alert: threshold=-25°C for cold-start protection. Ensures RF components (especially VCO) are within operating range.

### Step 24 — Application Init
- **Register:** `PULSE_GATE_CTRL` at `0x0900`
- **Write value:** `0x0000`
- **Rationale:** Pulse gate disabled initially as a safe default. Will be configured per operational mode (range gate timing depends on target application).

### Step 25 — Application Init
- **Register:** `ADC_CTRL` at `0x0200`
- **Write value:** `0x0002`
- **Wait/Poll:** Poll: ADC_STATUS.DATA_READY=1
- **Rationale:** Start first ADC conversion in continuous mode to begin monitoring supply voltages (5V, 3.3V, 2.5V, 1.8V rails) for ongoing health reporting.

### Step 26 — Application Init
- **Register:** `EEPROM_CTRL` at `0x0500`
- **Write value:** `0x0001`
- **Wait/Poll:** Poll: EEPROM_CTRL.BUSY=0
- **Rationale:** Read first EEPROM calibration data block (contains LNA bias trim, VGA gain offsets, PLL correction factors). Address defaults to 0x0000.

### Step 27 — Application Init
- **Register:** `FLASH_CTRL` at `0x0600`
- **Write value:** `0x0011`
- **Wait/Poll:** Poll: FLASH_CTRL.BUSY=0, verify FLASH_ID == 0x9D (ISSI manufacturer)
- **Rationale:** Initialize QSPI flash (IS25LP016D) in quad mode and read JEDEC ID to verify device presence. Flash stores FPGA configuration fallback and operational parameters.

### Step 28 — Application Init
- **Register:** `HEALTH_STATUS` at `0x030F`
- **Write value:** `0x0000`
- **Wait/Poll:** Poll: HEALTH_STATUS.SYSTEM_OK (bit7)=1
- **Rationale:** Final system health check — verify all subsystems healthy (TEMP_OK, VOLT_OK, PLL_LOCKED, FLASH_RDY, RF_POWER_OK all set). Module is ready for operational mode command.
