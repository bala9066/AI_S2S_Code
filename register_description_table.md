# Register Description Table (RDT)
## rx receiver

> **Total registers:** 52

Register Description Table and Programming Sequence for rx receiver (Wideband RF Receiver 5-18 GHz). Document revision 0V01 dated 16.04.2026. Design targets defense electronics applications with Analog Devices HMC6180LP4E LNA, HMC519LC4/MIXIQ-1030 IQ mixers, TI LMX2594 PLL synthesizer, and AD9680-250 dual ADC. System controlled by STM32F407VGT6 MCU via UART with FPGA performing JESD204B capture and DSP. Total of 40 registers mapped across 10 functional groups (0x000-0x900) including board info, communication, ADC monitoring, temperature/health, PLL/clock, RF front-end control, mixer gain/band selection, ADC interface, EEPROM, flash, GPIO, and DAC. Six-phase initialization sequence with 18 steps covering power-on self-check, voltage stabilization, board ID verification, PLL/clock init, RF front-end configuration (LNA bias, mixer enables), ADC calibration, communication init, health monitoring, and application start.

---
## Register Address Decoding

The 16-bit UART register address is decoded as follows:

| Bit(s) | Field | Description |
|--------|-------|-------------|
| [15] | R/W# | 1 = Read operation, 0 = Write operation |
| [14] | Reserved | Must be 0 |
| [13:12] | Reserved | Must be 0 |
| [11:8] | BASE_ADDR[3:0] | Functional group selector |
| [7:0] | OFFSET[7:0] | Register offset within group |

### Base Address Map

| BASE[3:0] | Address Range | Functional Group |
|-----------|--------------|-----------------|
| 0x0 | 0x0000–0x00FF | Board Information |
| 0x1 | 0x0100–0x01FF | Communication & Interface |
| 0x2 | 0x0200–0x02FF | ADC / Supply Monitoring |
| 0x3 | 0x0300–0x03FF | Temperature & Health |
| 0x4 | 0x0400–0x04FF | PLL / Clock Configuration |
| 0x5 | 0x0500–0x05FF | EEPROM / NV Storage |
| 0x6 | 0x0600–0x06FF | Configuration Flash |
| 0x7 | 0x0700–0x07FF | RF / Phase Control |
| 0x8 | 0x0800–0x08FF | GPIO / Control |
| 0x9 | 0x0900–0x09FF | DAC / Output |

---
## UART Frame Formats

### Single Register Write
```
TX: [0x57 'W'] [ADDR_MSB (bit15=0)] [ADDR_LSB] [DATA_MSB] [DATA_LSB]
RX: [ACK=0x06] or [NAK=0x15]
```

### Single Register Read
```
TX: [0x52 'R'] [ADDR_MSB (bit15=1)] [ADDR_LSB]
RX: [DATA_MSB] [DATA_LSB]
```

### Bulk Write (N consecutive registers)
```
TX: [0x42 'B'] [START_ADDR_MSB] [START_ADDR_LSB] [NUM_REGS (1 byte)]
    [D0_MSB] [D0_LSB] ... [DN-1_MSB] [DN-1_LSB]
RX: [ACK=0x06]
```

### Bulk Read (N consecutive registers)
```
TX: [0x62 'b'] [START_ADDR_MSB|0x80] [START_ADDR_LSB] [NUM_REGS]
RX: [D0_MSB] [D0_LSB] ... [DN-1_MSB] [DN-1_LSB]
```

---
## Register Definitions

| Address | Register Name | Access | Reset | Description |
|---------|--------------|--------|-------|-------------|
| `0x0000` | `BOARD_ID` | — | `0x5258` | Board identification code - ASCII 'RX' for receiver module |
| `0x0001` | `BOARD_VERSION` | — | `0x10` | Hardware revision number - major.minor format |
| `0x0002` | `BOARD_TYPE_ID` | — | `0x52584D52` | Extended board type identifier - 32-bit type code |
| `0x0003` | `SCRATCHPAD` | — | `0x0000` | General-purpose read/write test register for RAM integrity verification |
| `0x0010` | `MCS_VERSION_MAJOR` | — | `0x01` | FPGA firmware major version number |
| `0x0011` | `MCS_VERSION_MINOR` | — | `0x00` | FPGA firmware minor version number |
| `0x0012` | `BUILD_DATE` | — | `0x20260416` | Firmware build date in packed BCD format (YYYYMMDD) |
| `0x0100` | `UART_BAUD_DIV` | — | `0x0034` | UART baud rate divisor for MCU communication |
| `0x0101` | `UART_CTRL` | — | `0x00` | UART control and configuration register |
| `0x0102` | `UART_STATUS` | — | `0x00` | UART status flags - read to clear sticky bits |
| `0x0103` | `UART_TX_COUNT` | — | `0x00` | TX FIFO fill level - number of bytes pending transmission |
| `0x0104` | `UART_RX_COUNT` | — | `0x00` | RX FIFO fill level - number of bytes available to read |
| `0x0110` | `ETH_MAC_LOW` | — | `0x0000` | Ethernet MAC address lower 16 bits (optional - for future expansion) |
| `0x0111` | `ETH_MAC_HIGH` | — | `0x0000` | Ethernet MAC address upper 16 bits (optional - for future expansion) |
| `0x0200` | `ADC_CTRL` | — | `0x00` | Internal ADC control for supply monitoring (12-bit SAR ADC) |
| `0x0201` | `ADC_STATUS` | — | `0x00` | Internal ADC status flags |
| `0x0210` | `VCC_5V_RAW` | — | `0x0FFF` | 5V rail ADC raw count (12-bit) |
| `0x0211` | `VCC_3V3_RAW` | — | `0x0AAA` | 3.3V rail ADC raw count (12-bit) |
| `0x0212` | `VCC_2V5_RAW` | — | `0x07D0` | 2.5V rail ADC raw count (12-bit) |
| `0x0213` | `VCC_1V8_RAW` | — | `0x05DC` | 1.8V rail ADC raw count (12-bit) |
| `0x0218` | `ICC_5V_RAW` | — | `0x0000` | 5V rail current sense ADC count |
| `0x0219` | `ICC_3V3_RAW` | — | `0x0000` | 3.3V rail current sense ADC count |
| `0x0300` | `TEMP_LOCAL` | — | `0x0190` | Local FPGA die temperature sensor (0.25°C units, signed) |
| `0x0301` | `TEMP_REMOTE1` | — | `0x0140` | Remote temperature sensor 1 (RF front-end area) |
| `0x0302` | `TEMP_REMOTE2` | — | `0x00C8` | Remote temperature sensor 2 (ADC area) |
| `0x0308` | `TEMP_ALERT_HIGH` | — | `0x0190` | Over-temperature alert threshold |
| `0x0309` | `TEMP_ALERT_LOW` | — | `0xFF9C` | Under-temperature alert threshold |
| `0x030F` | `HEALTH_STATUS` | — | `0x00` | System health summary flags |
| `0x0400` | `PLL_CTRL` | — | `0x00` | LMX2594 PLL synthesizer control register |
| `0x0401` | `PLL_STATUS` | — | `0x00` | PLL status monitoring register |
| `0x0402` | `PLL_N_DIV` | — | `0x0064` | PLL N divider value (determines output frequency) |
| `0x0403` | `PLL_R_DIV` | — | `0x0001` | PLL R divider value (reference divider) |
| `0x0410` | `CLK_ENABLE` | — | `0x00` | Clock output enable controls for ADC and FPGA clocks |
| `0x0700` | `RF_LNA_CTRL` | — | `0x00` | HMC6180LP4E LNA control register |
| `0x0701` | `RF_MIX_CTRL` | — | `0x00` | IQ mixer control (HMC519LC4 / MIXIQ-1030) |
| `0x0702` | `RF_LO_FREQ_HIGH` | — | `0x0000` | LO frequency high word (bits 31:16) |
| `0x0703` | `RF_LO_FREQ_LOW` | — | `0x0000` | LO frequency low word (bits 15:0) |
| `0x0704` | `RF_PHASE_CTRL` | — | `0x00` | RF phase control (I/Q balance adjustment) |
| `0x0720` | `ADC_IF_CTRL` | — | `0x00` | AD9680 ADC interface control register |
| `0x0721` | `ADC_IF_STATUS` | — | `0x00` | ADC interface status register |
| `0x0800` | `GPIO_CTRL` | — | `0x00` | GPIO control register |
| `0x0801` | `GPIO_INPUT` | — | `0x00` | GPIO input status register |
| `0x0900` | `DAC_OUTPUT0` | — | `0x0000` | DAC output channel 0 (optional - for future VGA control) |
| `0x0901` | `DAC_OUTPUT1` | — | `0x0000` | DAC output channel 1 (optional - for future VGA control) |
| `0x0500` | `EEPROM_CTRL` | — | `0x00` | EEPROM control register (calibration data storage) |
| `0x0501` | `EEPROM_ADDR` | — | `0x0000` | EEPROM address register |
| `0x0502` | `EEPROM_DATA` | — | `0x0000` | EEPROM data register (16-bit word) |
| `0x0600` | `FLASH_CTRL` | — | `0x00` | Configuration flash control register |
| `0x0601` | `FLASH_ADDR_LOW` | — | `0x0000` | Flash address low word |
| `0x0602` | `FLASH_ADDR_HIGH` | — | `0x0000` | Flash address high word |
| `0x0603` | `FLASH_DATA` | — | `0x0000` | Flash data FIFO register |
| `0x0604` | `FLASH_STATUS` | — | `0x01` | Flash status register |

---
### `BOARD_ID` — Address `0x0000`

**Reset value:** `0x5258`  **Access:** see fields below

Board identification code - ASCII 'RX' for receiver module

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ID_CODE` | `[15:0]` | R | `0x5258` | Fixed board identifier 'RX' (0x5258) - read-only verification of hardware type |

---
### `BOARD_VERSION` — Address `0x0001`

**Reset value:** `0x10`  **Access:** see fields below

Hardware revision number - major.minor format

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAJOR_REV` | `[7:4]` | R | `0x1` | Major revision number |
| `MINOR_REV` | `[3:0]` | R | `0x0` | Minor revision number |

---
### `BOARD_TYPE_ID` — Address `0x0002`

**Reset value:** `0x52584D52`  **Access:** see fields below

Extended board type identifier - 32-bit type code

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TYPE_CODE` | `[15:0]` | R | `0x5258` | Board family identifier 'RXMR' (Receiver Module) - stored in upper 16 bits of 32-bit EEPROM value |

---
### `SCRATCHPAD` — Address `0x0003`

**Reset value:** `0x0000`  **Access:** see fields below

General-purpose read/write test register for RAM integrity verification

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEST_PATTERN` | `[15:0]` | RW | `0x0000` | Read/write test pattern - write 0xAA55/0x55AA to verify UART and memory functionality |

---
### `MCS_VERSION_MAJOR` — Address `0x0010`

**Reset value:** `0x01`  **Access:** see fields below

FPGA firmware major version number

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `FW_MAJOR` | `[7:0]` | R | `0x01` | Major firmware version - increments on breaking changes |

---
### `MCS_VERSION_MINOR` — Address `0x0011`

**Reset value:** `0x00`  **Access:** see fields below

FPGA firmware minor version number

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `FW_MINOR` | `[7:0]` | R | `0x00` | Minor firmware version - increments on bug fixes/features |

---
### `BUILD_DATE` — Address `0x0012`

**Reset value:** `0x20260416`  **Access:** see fields below

Firmware build date in packed BCD format (YYYYMMDD)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BUILD_YEAR` | `[15:12]` | R | `0x2` | Build year (0-9, e.g., 0x2 = 2020s, 0x3 = 2030s) |
| `BUILD_MONTH` | `[11:8]` | R | `0x4` | Build month (1-12, BCD encoded) |
| `BUILD_DAY` | `[7:0]` | R | `0x16` | Build day (1-31, BCD encoded) |

---
### `UART_BAUD_DIV` — Address `0x0100`

**Reset value:** `0x0034`  **Access:** see fields below

UART baud rate divisor for MCU communication

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BAUD_DIV` | `[15:0]` | RW | `0x0034` | Baud divisor = f_clk / (16 * baud_rate). Default 0x0034 = 115200 baud @ 100MHz |

---
### `UART_CTRL` — Address `0x0101`

**Reset value:** `0x00`  **Access:** see fields below

UART control and configuration register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `UART_ENABLE` | `[0]` | RW | `0x0` | Enable UART module (1=enabled, 0=disabled) |
| `LOOPBACK_EN` | `[1]` | RW | `0x0` | Internal loopback mode for self-test (1=loopback) |
| `FRAME_FORMAT` | `[7:4]` | RW | `0x0` | Frame format: 0x0=8N1, 0x1=8E1, 0x2=8O1, 0x3=9N1 |

---
### `UART_STATUS` — Address `0x0102`

**Reset value:** `0x00`  **Access:** see fields below

UART status flags - read to clear sticky bits

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TX_BUSY` | `[0]` | R | `0x0` | Transmitter busy flag (1=transmitting) |
| `RX_AVAIL` | `[1]` | R | `0x0` | Data available in RX FIFO (1=data pending) |
| `FRAME_ERR` | `[2]` | RC | `0x0` | Frame error detected - read to clear |
| `RX_OVERRUN` | `[3]` | RC | `0x0` | RX FIFO overrun - read to clear |

---
### `UART_TX_COUNT` — Address `0x0103`

**Reset value:** `0x00`  **Access:** see fields below

TX FIFO fill level - number of bytes pending transmission

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TX_COUNT` | `[7:0]` | R | `0x00` | TX FIFO byte count (0-16 bytes) |

---
### `UART_RX_COUNT` — Address `0x0104`

**Reset value:** `0x00`  **Access:** see fields below

RX FIFO fill level - number of bytes available to read

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `RX_COUNT` | `[7:0]` | R | `0x00` | RX FIFO byte count (0-16 bytes) |

---
### `ETH_MAC_LOW` — Address `0x0110`

**Reset value:** `0x0000`  **Access:** see fields below

Ethernet MAC address lower 16 bits (optional - for future expansion)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAC_LOW` | `[15:0]` | R | `0x0000` | MAC address bits [15:0] - configured via EEPROM |

---
### `ETH_MAC_HIGH` — Address `0x0111`

**Reset value:** `0x0000`  **Access:** see fields below

Ethernet MAC address upper 16 bits (optional - for future expansion)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAC_HIGH` | `[15:0]` | R | `0x0000` | MAC address bits [31:16] - configured via EEPROM |

---
### `ADC_CTRL` — Address `0x0200`

**Reset value:** `0x00`  **Access:** see fields below

Internal ADC control for supply monitoring (12-bit SAR ADC)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_START` | `[0]` | RW | `0x0` | Start ADC conversion (self-clearing) |
| `ADC_CONT_MODE` | `[1]` | RW | `0x0` | Continuous conversion mode (1=continuous) |
| `CHANNEL_SEL` | `[3:2]` | RW | `0x0` | Channel select: 0=5V, 1=3.3V, 2=2.5V, 3=1.8V |

---
### `ADC_STATUS` — Address `0x0201`

**Reset value:** `0x00`  **Access:** see fields below

Internal ADC status flags

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA_READY` | `[0]` | R | `0x0` | New data available (1=ready) |
| `OVERRANGE` | `[1]` | RC | `0x0` | Input exceeded ADC range - read to clear |

---
### `VCC_5V_RAW` — Address `0x0210`

**Reset value:** `0x0FFF`  **Access:** see fields below

5V rail ADC raw count (12-bit)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | R | `0x0FFF` | Raw ADC count. Voltage = (count * 5.0) / 4096 |

---
### `VCC_3V3_RAW` — Address `0x0211`

**Reset value:** `0x0AAA`  **Access:** see fields below

3.3V rail ADC raw count (12-bit)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | R | `0x0AAA` | Raw ADC count. Voltage = (count * 3.3) / 4096 |

---
### `VCC_2V5_RAW` — Address `0x0212`

**Reset value:** `0x07D0`  **Access:** see fields below

2.5V rail ADC raw count (12-bit)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | R | `0x07D0` | Raw ADC count. Voltage = (count * 2.5) / 4096 |

---
### `VCC_1V8_RAW` — Address `0x0213`

**Reset value:** `0x05DC`  **Access:** see fields below

1.8V rail ADC raw count (12-bit)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | R | `0x05DC` | Raw ADC count. Voltage = (count * 1.8) / 4096 |

---
### `ICC_5V_RAW` — Address `0x0218`

**Reset value:** `0x0000`  **Access:** see fields below

5V rail current sense ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `CURRENT_ADC` | `[11:0]` | R | `0x0000` | Current sense count. I = (count * Vref) / (4096 * R_sense * G_amp) |

---
### `ICC_3V3_RAW` — Address `0x0219`

**Reset value:** `0x0000`  **Access:** see fields below

3.3V rail current sense ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `CURRENT_ADC` | `[11:0]` | R | `0x0000` | Current sense count. I = (count * Vref) / (4096 * R_sense * G_amp) |

---
### `TEMP_LOCAL` — Address `0x0300`

**Reset value:** `0x0190`  **Access:** see fields below

Local FPGA die temperature sensor (0.25°C units, signed)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_VALUE` | `[9:0]` | R | `0x0190` | Temperature * 4. 0x0190 = 100°C (signed format, MSB is sign) |

---
### `TEMP_REMOTE1` — Address `0x0301`

**Reset value:** `0x0140`  **Access:** see fields below

Remote temperature sensor 1 (RF front-end area)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_VALUE` | `[9:0]` | R | `0x0140` | Temperature * 4. 0x0140 = 80°C (signed format) |

---
### `TEMP_REMOTE2` — Address `0x0302`

**Reset value:** `0x00C8`  **Access:** see fields below

Remote temperature sensor 2 (ADC area)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_VALUE` | `[9:0]` | R | `0x00C8` | Temperature * 4. 0x00C8 = 50°C (signed format) |

---
### `TEMP_ALERT_HIGH` — Address `0x0308`

**Reset value:** `0x0190`  **Access:** see fields below

Over-temperature alert threshold

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `THRESH_HIGH` | `[9:0]` | RW | `0x0190` | High threshold * 4. Default 100°C |

---
### `TEMP_ALERT_LOW` — Address `0x0309`

**Reset value:** `0xFF9C`  **Access:** see fields below

Under-temperature alert threshold

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `THRESH_LOW` | `[9:0]` | RW | `0xFF9C` | Low threshold * 4 (signed). 0xFF9C = -25°C |

---
### `HEALTH_STATUS` — Address `0x030F`

**Reset value:** `0x00`  **Access:** see fields below

System health summary flags

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_OK` | `[0]` | R | `0x0` | Temperature within limits (1=OK) |
| `VOLT_OK` | `[1]` | R | `0x0` | All voltages within tolerance (1=OK) |
| `PLL_LOCK` | `[2]` | R | `0x0` | PLL lock indicator (1=locked) |
| `ADC_SYNC` | `[3]` | R | `0x0` | ADC JESD204B link synchronized (1=locked) |
| `SYSTEM_OK` | `[7]` | R | `0x0` | Overall system health (1=all checks passed) |

---
### `PLL_CTRL` — Address `0x0400`

**Reset value:** `0x00`  **Access:** see fields below

LMX2594 PLL synthesizer control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `PLL_ENABLE` | `[0]` | RW | `0x0` | Enable PLL output (1=enabled, 0=shutdown) |
| `PLL_RESET` | `[1]` | RW | `0x0` | PLL reset (1=hold in reset, self-clearing) |
| `REF_CLK_SEL` | `[3:2]` | RW | `0x0` | Reference clock source: 0=10MHz XTAL, 1=external 10MHz, 2=100MHz MCU clock |

---
### `PLL_STATUS` — Address `0x0401`

**Reset value:** `0x00`  **Access:** see fields below

PLL status monitoring register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LOCKED` | `[0]` | R | `0x0` | PLL locked indicator (1=locked, 0=unlocked) |
| `LOSS_OF_LOCK` | `[1]` | RC | `0x0` | Loss of lock event detected - read to clear |
| `PLL_BUSY` | `[2]` | R | `0x0` | PLL calibration in progress (1=busy) |

---
### `PLL_N_DIV` — Address `0x0402`

**Reset value:** `0x0064`  **Access:** see fields below

PLL N divider value (determines output frequency)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `N_DIVIDER` | `[15:0]` | RW | `0x0064` | N divider. f_out = (f_ref * N) / R. Default 100 |

---
### `PLL_R_DIV` — Address `0x0403`

**Reset value:** `0x0001`  **Access:** see fields below

PLL R divider value (reference divider)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `R_DIVIDER` | `[7:0]` | RW | `0x01` | R divider. Default 1 (no division) |

---
### `CLK_ENABLE` — Address `0x0410`

**Reset value:** `0x00`  **Access:** see fields below

Clock output enable controls for ADC and FPGA clocks

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `CLK_ADC_EN` | `[0]` | RW | `0x0` | Enable ADC sample clock (1=enabled) |
| `CLK_FPGA_EN` | `[1]` | RW | `0x0` | Enable FPGA processing clock (1=enabled) |
| `CLK_REF_EN` | `[2]` | RW | `0x0` | Enable reference clock output (1=enabled) |

---
### `RF_LNA_CTRL` — Address `0x0700`

**Reset value:** `0x00`  **Access:** see fields below

HMC6180LP4E LNA control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LNA_ENABLE` | `[0]` | RW | `0x0` | Enable LNA (1=enabled, 0=shutdown) |
| `LNA_GAIN` | `[2:1]` | RW | `0x0` | Gain setting: 0=low, 1=medium, 2=high, 3=max |

---
### `RF_MIX_CTRL` — Address `0x0701`

**Reset value:** `0x00`  **Access:** see fields below

IQ mixer control (HMC519LC4 / MIXIQ-1030)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MIX_ENABLE` | `[0]` | RW | `0x0` | Enable mixer (1=enabled) |
| `BAND_SEL` | `[2:1]` | RW | `0x0` | Band select: 0=lower (5-12GHz, HMC519LC4), 1=upper (10-30GHz, MIXIQ-1030) |

---
### `RF_LO_FREQ_HIGH` — Address `0x0702`

**Reset value:** `0x0000`  **Access:** see fields below

LO frequency high word (bits 31:16)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `FREQ_HIGH` | `[15:0]` | RW | `0x0000` | LO frequency upper 16 bits (Hz units) |

---
### `RF_LO_FREQ_LOW` — Address `0x0703`

**Reset value:** `0x0000`  **Access:** see fields below

LO frequency low word (bits 15:0)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `FREQ_LOW` | `[15:0]` | RW | `0x0000` | LO frequency lower 16 bits (Hz units) |

---
### `RF_PHASE_CTRL` — Address `0x0704`

**Reset value:** `0x00`  **Access:** see fields below

RF phase control (I/Q balance adjustment)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `PHASE_ADJ` | `[7:0]` | RW | `0x00` | Phase adjustment in 1.4-degree steps (0-255) |

---
### `ADC_IF_CTRL` — Address `0x0720`

**Reset value:** `0x00`  **Access:** see fields below

AD9680 ADC interface control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_ENABLE` | `[0]` | RW | `0x0` | Enable ADC (1=powered on) |
| `JESD204B_EN` | `[1]` | RW | `0x0` | Enable JESD204B interface (1=enabled) |
| `TEST_PATTERN` | `[3:2]` | RW | `0x0` | Test pattern: 0=normal, 1=midscale, 2=ramp, 3=custom |

---
### `ADC_IF_STATUS` — Address `0x0721`

**Reset value:** `0x00`  **Access:** see fields below

ADC interface status register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `JESD204B_LOCK` | `[0]` | R | `0x0` | JESD204B link locked (1=locked) |
| `CODE_GROUP_SYNC` | `[1]` | R | `0x0` | Code group sync achieved (1=synced) |
| `ADC_READY` | `[2]` | R | `0x0` | ADC ready for data capture (1=ready) |

---
### `GPIO_CTRL` — Address `0x0800`

**Reset value:** `0x00`  **Access:** see fields below

GPIO control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GPIO0_OUT` | `[0]` | RW | `0x0` | GPIO0 output state |
| `GPIO1_OUT` | `[1]` | RW | `0x0` | GPIO1 output state |
| `GPIO2_OUT` | `[2]` | RW | `0x0` | GPIO2 output state |
| `GPIO_DIR` | `[7:4]` | RW | `0x0` | GPIO direction control (0=input, 1=output) |

---
### `GPIO_INPUT` — Address `0x0801`

**Reset value:** `0x00`  **Access:** see fields below

GPIO input status register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GPIO0_IN` | `[0]` | R | `0x0` | GPIO0 input state |
| `GPIO1_IN` | `[1]` | R | `0x0` | GPIO1 input state |
| `GPIO2_IN` | `[2]` | R | `0x0` | GPIO2 input state |

---
### `DAC_OUTPUT0` — Address `0x0900`

**Reset value:** `0x0000`  **Access:** see fields below

DAC output channel 0 (optional - for future VGA control)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DAC_DATA` | `[11:0]` | RW | `0x0000` | 12-bit DAC output value (0-4095) |

---
### `DAC_OUTPUT1` — Address `0x0901`

**Reset value:** `0x0000`  **Access:** see fields below

DAC output channel 1 (optional - for future VGA control)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DAC_DATA` | `[11:0]` | RW | `0x0000` | 12-bit DAC output value (0-4095) |

---
### `EEPROM_CTRL` — Address `0x0500`

**Reset value:** `0x00`  **Access:** see fields below

EEPROM control register (calibration data storage)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `EEPROM_READ` | `[0]` | RW | `0x0` | Start read operation (1=start, self-clearing) |
| `EEPROM_WRITE` | `[1]` | RW | `0x0` | Start write operation (1=start, self-clearing) |
| `EEPROM_ERASE` | `[2]` | RW | `0x0` | Erase operation (1=erase, self-clearing) |
| `EEPROM_BUSY` | `[7]` | R | `0x0` | EEPROM busy flag (1=operation in progress) |

---
### `EEPROM_ADDR` — Address `0x0501`

**Reset value:** `0x0000`  **Access:** see fields below

EEPROM address register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADDR` | `[15:0]` | RW | `0x0000` | 16-bit EEPROM byte address |

---
### `EEPROM_DATA` — Address `0x0502`

**Reset value:** `0x0000`  **Access:** see fields below

EEPROM data register (16-bit word)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA` | `[15:0]` | RW | `0x0000` | 16-bit data word for read/write operations |

---
### `FLASH_CTRL` — Address `0x0600`

**Reset value:** `0x00`  **Access:** see fields below

Configuration flash control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `FLASH_READ` | `[0]` | RW | `0x0` | Flash read operation (1=start) |
| `FLASH_WRITE` | `[1]` | RW | `0x0` | Flash write operation (1=start) |
| `FLASH_ERASE_SEC` | `[2]` | RW | `0x0` | Erase sector (1=start) |
| `FLASH_ERASE_CHIP` | `[3]` | RW | `0x0` | Erase entire chip (1=start) |
| `FLASH_BUSY` | `[7]` | R | `0x0` | Flash busy flag (1=operation in progress) |

---
### `FLASH_ADDR_LOW` — Address `0x0601`

**Reset value:** `0x0000`  **Access:** see fields below

Flash address low word

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADDR_LOW` | `[15:0]` | RW | `0x0000` | Flash address bits [15:0] |

---
### `FLASH_ADDR_HIGH` — Address `0x0602`

**Reset value:** `0x0000`  **Access:** see fields below

Flash address high word

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADDR_HIGH` | `[7:0]` | RW | `0x0000` | Flash address bits [23:16] |

---
### `FLASH_DATA` — Address `0x0603`

**Reset value:** `0x0000`  **Access:** see fields below

Flash data FIFO register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA` | `[15:0]` | RW | `0x0000` | 16-bit data word for read/write |

---
### `FLASH_STATUS` — Address `0x0604`

**Reset value:** `0x01`  **Access:** see fields below

Flash status register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READY` | `[0]` | R | `0x1` | Flash ready (1=ready) |
| `WRITE_ERR` | `[1]` | RC | `0x0` | Write error detected - read to clear |
| `ERASE_ERR` | `[2]` | RC | `0x0` | Erase error detected - read to clear |
