# Programming Sequence (PSQ)
## yhh

> **Total steps:** 26

| # | Phase | Register | Address | Value | Condition | Rationale |
|---|-------|----------|---------|-------|-----------|-----------|
| 1 | Power-On Reset & Self-Check | `SCRATCHPAD` | `0x0003` | `0xA55A` | Readback must equal 0xA55A | Write known pattern 0xA55A to scratchpad and read back to verify UART link integrity and FPGA internal register write path is functional. This is the fundamental link confidence test. |
| 2 | Power-On Reset & Self-Check | `HEALTH_STATUS` | `0x030F` | `0x0000` | Poll until VOLT_OK (bit 1) = 1, timeout 500 ms | Wait for all supply rails (5V, 3.3V, 1.8V, 1.0V) to be within tolerance as reported by ADC monitoring. Do not proceed with PLL or RF configuration until power is stable. |
| 3 | Power-On Reset & Self-Check | `BOARD_ID` | `0x0000` | `0x0000` | Read must return 0x5948 ('YH') | Verify the correct FPGA bitstream is loaded by reading the board identification code. Mismatch indicates wrong firmware image or configuration error. |
| 4 | Power-On Reset & Self-Check | `ADC_CTRL` | `0x0200` | `0x0002` | Poll ADC_STATUS.DATA_READY until 1 | Enable continuous ADC conversion mode to begin monitoring all supply voltage and current rails. This provides ongoing health data during initialization. |
| 5 | PLL & Clock Init | `PLL_CTRL` | `0x0400` | `0x0002` | None | Assert PLL reset to ensure a clean starting state. This clears any residual lock state from power-on transients. |
| 6 | PLL & Clock Init | `PLL_N_DIV` | `0x0402` | `0x0010` | — | Set PLL N feedback divider to 16 for target VCO frequency. This is the primary frequency multiplication ratio. |
| 7 | PLL & Clock Init | `PLL_R_DIV` | `0x0403` | `0x0004` | — | Set PLL R reference divider to 4. Combined with N=16, this sets the output frequency relative to the reference oscillator. |
| 8 | PLL & Clock Init | `PLL_CTRL` | `0x0400` | `0x0001` | Poll PLL_STATUS.LOCKED (bit 0) = 1, timeout 100 ms | De-assert reset and enable PLL. Poll until LOCKED bit is set, indicating stable clock output. Cannot proceed to peripheral enable until PLL is locked. |
| 9 | PLL & Clock Init | `CLK_ENABLE` | `0x0410` | `0x0007` | None | Enable clock outputs 0, 1, and 2 (FPGA logic, ADC sample clock, SPI reference). Output 3 is reserved and left disabled. |
| 10 | Peripheral Enable | `UART_BAUD_DIV` | `0x0100` | `0x0036` | None | Set UART baud rate divisor to 0x0036 (54) for 115200 baud at 100 MHz system clock. Standard rate for USB-UART bridge communication. |
| 11 | Peripheral Enable | `UART_CTRL` | `0x0101` | `0x0001` | None | Enable UART in 8N1 frame format with loopback off. The UART is the primary host communication channel for all register access. |
| 12 | Peripheral Enable | `SPI_CTRL` | `0x0120` | `0x0014` | None | Configure SPI controller: CPOL=0, CPHA=0, CS active-low, clock divider = /16. This configures the master SPI for both EEPROM and Flash access. |
| 13 | Peripheral Enable | `I2C_CTRL` | `0x0130` | `0x0003` | None | Enable I2C master controller at 400 kHz (fast mode) for temperature sensor and power monitor IC access on the I2C bus. |
| 14 | Communication Init | `FLASH_CTRL` | `0x0600` | `0x0001` | Poll FLASH_STATUS.READY (bit 0) = 1 and ID_VALID (bit 3) = 1 | Read Flash ID to verify the configuration Flash (SPI-attached) is present and responding correctly. Confirms flash interface is operational before proceeding. |
| 15 | Communication Init | `EEPROM_CTRL` | `0x0500` | `0x0000` | Poll EEPROM_CTRL.BUSY (bit 7) = 0, then read EEPROM_DATA | Verify EEPROM interface is ready by reading a test location (address 0x0000). This confirms the SPI EEPROM used for calibration data storage is accessible. |
| 16 | Temperature & Health Config | `TEMP_ALERT_HIGH` | `0x0308` | `0x0190` | None | Set over-temperature alert threshold to 100°C (0x190 × 0.25°C). This protects the LNA and gain block MMICs from thermal damage. |
| 17 | Temperature & Health Config | `TEMP_ALERT_LOW` | `0x0309` | `0xFF9C` | None | Set under-temperature alert to -25°C for cold-start detection. Alerts the system that components may be below minimum operating temperature. |
| 18 | Temperature & Health Config | `INTERRUPT_MASK` | `0x0311` | `0x000F` | None | Enable interrupt sources for temperature alert, voltage alert, PLL unlock, and limiter fault. These are the critical safety interrupts for the RF front-end. |
| 19 | Application Init | `SYSTEM_CTRL` | `0x001F` | `0x0001` | None | Set system to STANDBY mode (OPERATIONAL_MODE=1). This activates the control plane without enabling any RF chain components, providing a safe intermediate state. |
| 20 | Application Init | `TR_SWITCH_CTRL` | `0x0802` | `0x0000` | None | Set all T/R SPDT switches to RX path (QPC2420SR). This ensures the front-end is configured for signal reception and the LNAs are protected from any residual TX energy. |
| 21 | Application Init | `DAC_CTRL` | `0x0900` | `0x0001` | None | Enable global DAC output. DACs provide analog bias voltages, BPF tuning codes, and voltage references to the RF chain. Must be enabled before individual channel configuration. |
| 22 | Application Init | `LNA_BIAS_CTRL` | `0x0803` | `0x001F` | None | Enable all 4 balanced LNA channels (PMA4-6263LN+) via broadcast bit. Power-on sequencing ensures PLL and clocks are stable before applying bias to sensitive RF components. |
| 23 | Application Init | `GAIN_AMP_CTRL` | `0x0804` | `0x001F` | None | Enable all 4 gain block/driver amplifier stages (PMA3-15453+) via broadcast bit. These stages 2 and 3 are enabled after LNAs to prevent downstream noise from propagating. |
| 24 | Application Init | `BPF_TUNING` | `0x0807` | `0x0080` | None | Set ceramic preselector BPF (BFCN-1840+) tuning code to mid-scale (0x80) for nominal center frequency alignment. |
| 25 | Application Init | `MONOPULSE_CTRL` | `0x0806` | `0x0000` | None | Select Sum (Σ) output from monopulse comparator (SCA-4-132+) as the default output path. The system can be switched to Delta-AZ, Delta-EL, or Delta-DE during tracking operation. |
| 26 | Application Init | `SYSTEM_CTRL` | `0x001F` | `0x0003` | Read HEALTH_STATUS, confirm SYSTEM_OK (bit 7) = 1 | Transition system to RX_ACTIVE mode (OPERATIONAL_MODE=2). Final verification that all health flags pass (TEMP_OK, VOLT_OK, PLL_LOCK, RF_OK). System is now fully operational for monopulse radar signal reception. |

---

## Detailed Steps

### Step 1 — Power-On Reset & Self-Check
- **Register:** `SCRATCHPAD` at `0x0003`
- **Write value:** `0xA55A`
- **Wait/Poll:** Readback must equal 0xA55A
- **Rationale:** Write known pattern 0xA55A to scratchpad and read back to verify UART link integrity and FPGA internal register write path is functional. This is the fundamental link confidence test.

### Step 2 — Power-On Reset & Self-Check
- **Register:** `HEALTH_STATUS` at `0x030F`
- **Write value:** `0x0000`
- **Wait/Poll:** Poll until VOLT_OK (bit 1) = 1, timeout 500 ms
- **Rationale:** Wait for all supply rails (5V, 3.3V, 1.8V, 1.0V) to be within tolerance as reported by ADC monitoring. Do not proceed with PLL or RF configuration until power is stable.

### Step 3 — Power-On Reset & Self-Check
- **Register:** `BOARD_ID` at `0x0000`
- **Write value:** `0x0000`
- **Wait/Poll:** Read must return 0x5948 ('YH')
- **Rationale:** Verify the correct FPGA bitstream is loaded by reading the board identification code. Mismatch indicates wrong firmware image or configuration error.

### Step 4 — Power-On Reset & Self-Check
- **Register:** `ADC_CTRL` at `0x0200`
- **Write value:** `0x0002`
- **Wait/Poll:** Poll ADC_STATUS.DATA_READY until 1
- **Rationale:** Enable continuous ADC conversion mode to begin monitoring all supply voltage and current rails. This provides ongoing health data during initialization.

### Step 5 — PLL & Clock Init
- **Register:** `PLL_CTRL` at `0x0400`
- **Write value:** `0x0002`
- **Wait/Poll:** None
- **Rationale:** Assert PLL reset to ensure a clean starting state. This clears any residual lock state from power-on transients.

### Step 6 — PLL & Clock Init
- **Register:** `PLL_N_DIV` at `0x0402`
- **Write value:** `0x0010`
- **Rationale:** Set PLL N feedback divider to 16 for target VCO frequency. This is the primary frequency multiplication ratio.

### Step 7 — PLL & Clock Init
- **Register:** `PLL_R_DIV` at `0x0403`
- **Write value:** `0x0004`
- **Rationale:** Set PLL R reference divider to 4. Combined with N=16, this sets the output frequency relative to the reference oscillator.

### Step 8 — PLL & Clock Init
- **Register:** `PLL_CTRL` at `0x0400`
- **Write value:** `0x0001`
- **Wait/Poll:** Poll PLL_STATUS.LOCKED (bit 0) = 1, timeout 100 ms
- **Rationale:** De-assert reset and enable PLL. Poll until LOCKED bit is set, indicating stable clock output. Cannot proceed to peripheral enable until PLL is locked.

### Step 9 — PLL & Clock Init
- **Register:** `CLK_ENABLE` at `0x0410`
- **Write value:** `0x0007`
- **Wait/Poll:** None
- **Rationale:** Enable clock outputs 0, 1, and 2 (FPGA logic, ADC sample clock, SPI reference). Output 3 is reserved and left disabled.

### Step 10 — Peripheral Enable
- **Register:** `UART_BAUD_DIV` at `0x0100`
- **Write value:** `0x0036`
- **Wait/Poll:** None
- **Rationale:** Set UART baud rate divisor to 0x0036 (54) for 115200 baud at 100 MHz system clock. Standard rate for USB-UART bridge communication.

### Step 11 — Peripheral Enable
- **Register:** `UART_CTRL` at `0x0101`
- **Write value:** `0x0001`
- **Wait/Poll:** None
- **Rationale:** Enable UART in 8N1 frame format with loopback off. The UART is the primary host communication channel for all register access.

### Step 12 — Peripheral Enable
- **Register:** `SPI_CTRL` at `0x0120`
- **Write value:** `0x0014`
- **Wait/Poll:** None
- **Rationale:** Configure SPI controller: CPOL=0, CPHA=0, CS active-low, clock divider = /16. This configures the master SPI for both EEPROM and Flash access.

### Step 13 — Peripheral Enable
- **Register:** `I2C_CTRL` at `0x0130`
- **Write value:** `0x0003`
- **Wait/Poll:** None
- **Rationale:** Enable I2C master controller at 400 kHz (fast mode) for temperature sensor and power monitor IC access on the I2C bus.

### Step 14 — Communication Init
- **Register:** `FLASH_CTRL` at `0x0600`
- **Write value:** `0x0001`
- **Wait/Poll:** Poll FLASH_STATUS.READY (bit 0) = 1 and ID_VALID (bit 3) = 1
- **Rationale:** Read Flash ID to verify the configuration Flash (SPI-attached) is present and responding correctly. Confirms flash interface is operational before proceeding.

### Step 15 — Communication Init
- **Register:** `EEPROM_CTRL` at `0x0500`
- **Write value:** `0x0000`
- **Wait/Poll:** Poll EEPROM_CTRL.BUSY (bit 7) = 0, then read EEPROM_DATA
- **Rationale:** Verify EEPROM interface is ready by reading a test location (address 0x0000). This confirms the SPI EEPROM used for calibration data storage is accessible.

### Step 16 — Temperature & Health Config
- **Register:** `TEMP_ALERT_HIGH` at `0x0308`
- **Write value:** `0x0190`
- **Wait/Poll:** None
- **Rationale:** Set over-temperature alert threshold to 100°C (0x190 × 0.25°C). This protects the LNA and gain block MMICs from thermal damage.

### Step 17 — Temperature & Health Config
- **Register:** `TEMP_ALERT_LOW` at `0x0309`
- **Write value:** `0xFF9C`
- **Wait/Poll:** None
- **Rationale:** Set under-temperature alert to -25°C for cold-start detection. Alerts the system that components may be below minimum operating temperature.

### Step 18 — Temperature & Health Config
- **Register:** `INTERRUPT_MASK` at `0x0311`
- **Write value:** `0x000F`
- **Wait/Poll:** None
- **Rationale:** Enable interrupt sources for temperature alert, voltage alert, PLL unlock, and limiter fault. These are the critical safety interrupts for the RF front-end.

### Step 19 — Application Init
- **Register:** `SYSTEM_CTRL` at `0x001F`
- **Write value:** `0x0001`
- **Wait/Poll:** None
- **Rationale:** Set system to STANDBY mode (OPERATIONAL_MODE=1). This activates the control plane without enabling any RF chain components, providing a safe intermediate state.

### Step 20 — Application Init
- **Register:** `TR_SWITCH_CTRL` at `0x0802`
- **Write value:** `0x0000`
- **Wait/Poll:** None
- **Rationale:** Set all T/R SPDT switches to RX path (QPC2420SR). This ensures the front-end is configured for signal reception and the LNAs are protected from any residual TX energy.

### Step 21 — Application Init
- **Register:** `DAC_CTRL` at `0x0900`
- **Write value:** `0x0001`
- **Wait/Poll:** None
- **Rationale:** Enable global DAC output. DACs provide analog bias voltages, BPF tuning codes, and voltage references to the RF chain. Must be enabled before individual channel configuration.

### Step 22 — Application Init
- **Register:** `LNA_BIAS_CTRL` at `0x0803`
- **Write value:** `0x001F`
- **Wait/Poll:** None
- **Rationale:** Enable all 4 balanced LNA channels (PMA4-6263LN+) via broadcast bit. Power-on sequencing ensures PLL and clocks are stable before applying bias to sensitive RF components.

### Step 23 — Application Init
- **Register:** `GAIN_AMP_CTRL` at `0x0804`
- **Write value:** `0x001F`
- **Wait/Poll:** None
- **Rationale:** Enable all 4 gain block/driver amplifier stages (PMA3-15453+) via broadcast bit. These stages 2 and 3 are enabled after LNAs to prevent downstream noise from propagating.

### Step 24 — Application Init
- **Register:** `BPF_TUNING` at `0x0807`
- **Write value:** `0x0080`
- **Wait/Poll:** None
- **Rationale:** Set ceramic preselector BPF (BFCN-1840+) tuning code to mid-scale (0x80) for nominal center frequency alignment.

### Step 25 — Application Init
- **Register:** `MONOPULSE_CTRL` at `0x0806`
- **Write value:** `0x0000`
- **Wait/Poll:** None
- **Rationale:** Select Sum (Σ) output from monopulse comparator (SCA-4-132+) as the default output path. The system can be switched to Delta-AZ, Delta-EL, or Delta-DE during tracking operation.

### Step 26 — Application Init
- **Register:** `SYSTEM_CTRL` at `0x001F`
- **Write value:** `0x0003`
- **Wait/Poll:** Read HEALTH_STATUS, confirm SYSTEM_OK (bit 7) = 1
- **Rationale:** Transition system to RX_ACTIVE mode (OPERATIONAL_MODE=2). Final verification that all health flags pass (TEMP_OK, VOLT_OK, PLL_LOCK, RF_OK). System is now fully operational for monopulse radar signal reception.
