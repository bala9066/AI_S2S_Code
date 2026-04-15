# Register Description Table (RDT)
## hgyu

> **Total registers:** 58

Complete register map for hgyu Ultra-Wideband RF Receiver System (5-18 GHz). 40 registers across 10 functional groups: Board Info (0x000), Communication (0x100), ADC/Supply Monitor (0x200), Temperature/Health (0x300), PLL/Clock (0x400), EEPROM (0x500), Flash (0x600), RF/Phase/JESD204B (0x700), GPIO (0x800), Power Sequencing (0x900). 30-step programming sequence covers POR diagnostics, power sequencing, LMK04828 PLL init, UART/SPI communication, temperature alert setup, EEPROM calibration load, HMC698LP4 attenuator configuration, and JESD204B Subclass 1 link bringup. Optimized for JESD204B 8-lane 10-GSPS ADC10DX100 RF sampling application.

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
| `0x0000` | `BOARD_ID` | — | `0x4847` | Board identification code (ASCII 'HG') |
| `0x0001` | `BOARD_VERSION` | — | `0x10` | Hardware revision - major/minor |
| `0x0002` | `BOARD_TYPE_ID` | — | `0x5552` | Board type identifier (ASCII 'UR' = UWB Receiver) |
| `0x0003` | `SCRATCHPAD` | — | `0x0000` | Diagnostic read/write test register |
| `0x0010` | `MCS_VERSION_MAJOR` | — | `0x01` | FPGA firmware major version |
| `0x0011` | `MCS_VERSION_MINOR` | — | `0x00` | FPGA firmware minor version |
| `0x0012` | `BUILD_DATE` | — | `0x20260415` | Firmware build date (packed BCD YYYYMMDD) |
| `0x0100` | `UART_BAUD_DIV` | — | `0x0034` | UART baud rate divisor (default 115200 @ 100MHz) |
| `0x0101` | `UART_CTRL` | — | `0x00` | UART control and configuration |
| `0x0102` | `UART_STATUS` | — | `0x00` | UART status flags (read-clear) |
| `0x0103` | `UART_TX_COUNT` | — | `0x00` | TX FIFO byte count |
| `0x0104` | `UART_RX_COUNT` | — | `0x00` | RX FIFO byte count |
| `0x0108` | `SPI_CTRL` | — | `0x80` | SPI master control for ADC/Clock/Attenuator configuration |
| `0x0109` | `SPI_STATUS` | — | `0x00` | SPI transaction status |
| `0x0200` | `ADC_CTRL` | — | `0x00` | ADC monitoring control |
| `0x0201` | `ADC_STATUS` | — | `0x00` | ADC monitoring status |
| `0x0210` | `VCC_5V_RAW` | — | `0x0000` | 5V rail ADC raw count |
| `0x0211` | `VCC_3V3_RAW` | — | `0x0000` | 3.3V rail ADC raw count |
| `0x0212` | `VCC_2V5_RAW` | — | `0x0000` | 2.5V rail ADC raw count |
| `0x0213` | `VCC_1V8_RAW` | — | `0x0000` | 1.8V rail ADC raw count |
| `0x0218` | `ICC_5V_RAW` | — | `0x0000` | 5V rail current monitor |
| `0x0219` | `ICC_3V3_RAW` | — | `0x0000` | 3.3V rail current monitor |
| `0x0300` | `TEMP_LOCAL` | — | `0x0190` | FPGA die temperature (signed 0.25°C units) |
| `0x0301` | `TEMP_REMOTE1` | — | `0x0190` | Remote sensor 1 temperature (RF Front-End area) |
| `0x0302` | `TEMP_REMOTE2` | — | `0x0190` | Remote sensor 2 temperature (ADC area) |
| `0x0308` | `TEMP_ALERT_HIGH` | — | `0x0190` | Over-temperature alert threshold (100°C) |
| `0x0309` | `TEMP_ALERT_LOW` | — | `0xFF9C` | Under-temperature alert threshold (-25°C) |
| `0x030F` | `HEALTH_STATUS` | — | `0x00` | System health status flags |
| `0x0400` | `PLL_CTRL` | — | `0x00` | PLL (LMK04828) control register |
| `0x0401` | `PLL_STATUS` | — | `0x00` | PLL status flags |
| `0x0402` | `PLL_N_DIV` | — | `0x0064` | PLL N divider value |
| `0x0403` | `PLL_R_DIV` | — | `0x0001` | PLL R divider value |
| `0x0410` | `CLK_ENABLE` | — | `0x00` | Clock output enables (one bit per output) |
| `0x0700` | `RF_GAIN_CTRL` | — | `0x0000` | RF front-end gain control register |
| `0x0701` | `RF_ATTENUATOR1` | — | `0x00` | RF Attenuator 1 parallel data (HMC698LP4 #1) |
| `0x0702` | `RF_ATTENUATOR2` | — | `0x00` | RF Attenuator 2 parallel data (HMC698LP4 #2) |
| `0x0703` | `RF_STATUS` | — | `0x00` | RF front-end status flags |
| `0x0708` | `JESD_CTRL` | — | `0x00` | JESD204B interface control (ADC10DX100) |
| `0x0709` | `JESD_STATUS` | — | `0x00` | JESD204B link status |
| `0x070A` | `JESD_SCR_L` | — | `0x00` | JESD204B Scrubber value low byte |
| `0x070B` | `JESD_SCR_H` | — | `0x00` | JESD204B Scrubber value high byte |
| `0x070C` | `JESD_ILAS_CONFIG` | — | `0x04` | JESD204B ILAS configuration |
| `0x0800` | `GPIO_DIR` | — | `0x0000` | GPIO direction control (0=input, 1=output) |
| `0x0801` | `GPIO_OUT` | — | `0x0000` | GPIO output data register |
| `0x0802` | `GPIO_IN` | — | `0x0000` | GPIO input data register |
| `0x0500` | `EEPROM_CTRL` | — | `0x00` | EEPROM control register |
| `0x0501` | `EEPROM_ADDR` | — | `0x0000` | EEPROM byte address |
| `0x0502` | `EEPROM_DATA` | — | `0x0000` | EEPROM read/write data |
| `0x0600` | `FLASH_CTRL` | — | `0x00` | Configuration Flash control |
| `0x0601` | `FLASH_ADDR_LOW` | — | `0x0000` | Flash address low word [15:0] |
| `0x0602` | `FLASH_ADDR_HIGH` | — | `0x0000` | Flash address high word [23:16] |
| `0x0603` | `FLASH_DATA` | — | `0x0000` | Flash data FIFO |
| `0x0604` | `FLASH_STATUS` | — | `0x00` | Flash operation status |
| `0x0900` | `POWER_SEQ_CTRL` | — | `0x00` | Power sequencing control (TPS7A4700 LDOs) |
| `0x0901` | `POWER_SEQ_STATUS` | — | `0x00` | Power sequencing status |
| `0x0908` | `SYSTEM_RESET` | — | `0x00` | System reset control |
| `0x0909` | `SYSTEM_IRQ` | — | `0x00` | System interrupt flags |
| `0x090A` | `IRQ_MASK` | — | `0xFF` | Interrupt mask (1=disabled) |

---
### `BOARD_ID` — Address `0x0000`

**Reset value:** `0x4847`  **Access:** see fields below

Board identification code (ASCII 'HG')

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BOARD_ID` | `[15:0]` | RO | `0x4847` | Fixed board identifier (0x4847 = 'HG') |

---
### `BOARD_VERSION` — Address `0x0001`

**Reset value:** `0x10`  **Access:** see fields below

Hardware revision - major/minor

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAJOR` | `[7:4]` | RO | `0x1` | Major version number |
| `MINOR` | `[3:0]` | RO | `0x0` | Minor version number |

---
### `BOARD_TYPE_ID` — Address `0x0002`

**Reset value:** `0x5552`  **Access:** see fields below

Board type identifier (ASCII 'UR' = UWB Receiver)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TYPE_ID` | `[15:0]` | RO | `0x5552` | Fixed type identifier |

---
### `SCRATCHPAD` — Address `0x0003`

**Reset value:** `0x0000`  **Access:** see fields below

Diagnostic read/write test register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEST_VALUE` | `[15:0]` | RW | `0x0000` | Read/write test pattern for RAM verification |

---
### `MCS_VERSION_MAJOR` — Address `0x0010`

**Reset value:** `0x01`  **Access:** see fields below

FPGA firmware major version

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAJOR_VER` | `[7:0]` | RO | `0x01` | Firmware major version number |

---
### `MCS_VERSION_MINOR` — Address `0x0011`

**Reset value:** `0x00`  **Access:** see fields below

FPGA firmware minor version

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MINOR_VER` | `[7:0]` | RO | `0x00` | Firmware minor version number |

---
### `BUILD_DATE` — Address `0x0012`

**Reset value:** `0x20260415`  **Access:** see fields below

Firmware build date (packed BCD YYYYMMDD)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `YEAR` | `[15:12]` | RO | `0x2` | Build year (BCD) |
| `MONTH` | `[11:8]` | RO | `0x4` | Build month (BCD) |
| `DAY` | `[7:0]` | RO | `0x15` | Build day (BCD) |

---
### `UART_BAUD_DIV` — Address `0x0100`

**Reset value:** `0x0034`  **Access:** see fields below

UART baud rate divisor (default 115200 @ 100MHz)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DIVISOR` | `[15:0]` | RW | `0x0034` | Baud = clk_freq / (16 * divisor) |

---
### `UART_CTRL` — Address `0x0101`

**Reset value:** `0x00`  **Access:** see fields below

UART control and configuration

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0` | UART enable (1=enabled) |
| `LOOPBACK` | `[1]` | RW | `0` | Internal loopback mode |
| `FRAME_FORMAT` | `[7:4]` | RW | `0x3` | Frame format (0x3=8N1) |

---
### `UART_STATUS` — Address `0x0102`

**Reset value:** `0x00`  **Access:** see fields below

UART status flags (read-clear)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TX_BUSY` | `[0]` | RC | `0` | Transmitter busy (clears on read) |
| `RX_AVAIL` | `[1]` | RC | `0` | Data available in RX FIFO |
| `FRAME_ERR` | `[2]` | RC | `0` | Framing error detected |

---
### `UART_TX_COUNT` — Address `0x0103`

**Reset value:** `0x00`  **Access:** see fields below

TX FIFO byte count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `COUNT` | `[7:0]` | RO | `0` | Number of bytes in TX FIFO |

---
### `UART_RX_COUNT` — Address `0x0104`

**Reset value:** `0x00`  **Access:** see fields below

RX FIFO byte count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `COUNT` | `[7:0]` | RO | `0` | Number of bytes in RX FIFO |

---
### `SPI_CTRL` — Address `0x0108`

**Reset value:** `0x80`  **Access:** see fields below

SPI master control for ADC/Clock/Attenuator configuration

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `SPI_EN` | `[0]` | RW | `1` | SPI master enable |
| `AUTO_CS` | `[1]` | RW | `0` | Automatic CS management |
| `CLK_DIV` | `[7:4]` | RW | `0x8` | SPI clock divisor (prescaler) |

---
### `SPI_STATUS` — Address `0x0109`

**Reset value:** `0x00`  **Access:** see fields below

SPI transaction status

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BUSY` | `[0]` | RO | `0` | SPI transaction in progress |
| `DONE` | `[1]` | RC | `0` | Transaction complete (clears on read) |
| `ERROR` | `[2]` | RC | `0` | Transaction error |

---
### `ADC_CTRL` — Address `0x0200`

**Reset value:** `0x00`  **Access:** see fields below

ADC monitoring control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `START` | `[0]` | RW | `0` | Start ADC conversion |
| `CONTINUOUS` | `[1]` | RW | `0` | Continuous conversion mode |
| `CHANNEL_SEL` | `[3:2]` | RW | `0` | Channel select (0-3) |

---
### `ADC_STATUS` — Address `0x0201`

**Reset value:** `0x00`  **Access:** see fields below

ADC monitoring status

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA_READY` | `[0]` | RC | `0` | Conversion data ready (clears on read) |
| `OVERRANGE` | `[1]` | RC | `0` | Input overrange detected |

---
### `VCC_5V_RAW` — Address `0x0210`

**Reset value:** `0x0000`  **Access:** see fields below

5V rail ADC raw count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | RO | `0` | Raw ADC count (multiply by 5.0/4096 for Volts) |

---
### `VCC_3V3_RAW` — Address `0x0211`

**Reset value:** `0x0000`  **Access:** see fields below

3.3V rail ADC raw count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | RO | `0` | Raw ADC count (multiply by 3.3/4096 for Volts) |

---
### `VCC_2V5_RAW` — Address `0x0212`

**Reset value:** `0x0000`  **Access:** see fields below

2.5V rail ADC raw count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | RO | `0` | Raw ADC count (multiply by 2.5/4096 for Volts) |

---
### `VCC_1V8_RAW` — Address `0x0213`

**Reset value:** `0x0000`  **Access:** see fields below

1.8V rail ADC raw count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | RO | `0` | Raw ADC count (multiply by 1.8/4096 for Volts) |

---
### `ICC_5V_RAW` — Address `0x0218`

**Reset value:** `0x0000`  **Access:** see fields below

5V rail current monitor

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | RO | `0` | Raw current sense ADC count |

---
### `ICC_3V3_RAW` — Address `0x0219`

**Reset value:** `0x0000`  **Access:** see fields below

3.3V rail current monitor

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | RO | `0` | Raw current sense ADC count |

---
### `TEMP_LOCAL` — Address `0x0300`

**Reset value:** `0x0190`  **Access:** see fields below

FPGA die temperature (signed 0.25°C units)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP` | `[9:0]` | RO | `0x190` | Temperature in 0.25°C units (signed, 0x190=100°C) |

---
### `TEMP_REMOTE1` — Address `0x0301`

**Reset value:** `0x0190`  **Access:** see fields below

Remote sensor 1 temperature (RF Front-End area)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP` | `[9:0]` | RO | `0x190` | Remote temperature sensor 1 (signed 0.25°C units) |

---
### `TEMP_REMOTE2` — Address `0x0302`

**Reset value:** `0x0190`  **Access:** see fields below

Remote sensor 2 temperature (ADC area)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP` | `[9:0]` | RO | `0x190` | Remote temperature sensor 2 (signed 0.25°C units) |

---
### `TEMP_ALERT_HIGH` — Address `0x0308`

**Reset value:** `0x0190`  **Access:** see fields below

Over-temperature alert threshold (100°C)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `THRESHOLD` | `[9:0]` | RW | `0x190` | High temperature threshold (0.25°C units, signed) |

---
### `TEMP_ALERT_LOW` — Address `0x0309`

**Reset value:** `0xFF9C`  **Access:** see fields below

Under-temperature alert threshold (-25°C)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `THRESHOLD` | `[9:0]` | RW | `0xFF9C` | Low temperature threshold (0.25°C units, signed) |

---
### `HEALTH_STATUS` — Address `0x030F`

**Reset value:** `0x00`  **Access:** see fields below

System health status flags

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_OK` | `[0]` | RO | `0` | Temperature within limits (1=OK) |
| `VOLT_OK` | `[1]` | RO | `0` | All voltages within tolerance (1=OK) |
| `PLL_LOCK` | `[2]` | RO | `0` | PLL locked (1=LOCKED) |
| `JESD_LINK` | `[3]` | RO | `0` | JESD204B link up (1=LINKED) |
| `SYSTEM_OK` | `[7]` | RO | `0` | Overall system health (all checks pass) |

---
### `PLL_CTRL` — Address `0x0400`

**Reset value:** `0x00`  **Access:** see fields below

PLL (LMK04828) control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0` | PLL enable (1=enabled) |
| `RESET` | `[1]` | RW | `0` | PLL reset (1=reset, self-clearing) |
| `REF_SEL` | `[3:2]` | RW | `0` | Reference clock select (0=external SMA, 1=FMC) |

---
### `PLL_STATUS` — Address `0x0401`

**Reset value:** `0x00`  **Access:** see fields below

PLL status flags

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LOCKED` | `[0]` | RO | `0` | PLL lock detect (1=LOCKED) |
| `LOSS_OF_LOCK` | `[1]` | RC | `0` | Loss of lock event (clears on read) |
| `HOLDOVER` | `[2]` | RO | `0` | Holdover mode active |

---
### `PLL_N_DIV` — Address `0x0402`

**Reset value:** `0x0064`  **Access:** see fields below

PLL N divider value

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `N_DIV` | `[15:0]` | RW | `0x0064` | N divider value (default 100) |

---
### `PLL_R_DIV` — Address `0x0403`

**Reset value:** `0x0001`  **Access:** see fields below

PLL R divider value

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `R_DIV` | `[7:0]` | RW | `0x01` | R divider value (default 1) |

---
### `CLK_ENABLE` — Address `0x0410`

**Reset value:** `0x00`  **Access:** see fields below

Clock output enables (one bit per output)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `CLK_ADC_EN` | `[0]` | RW | `0` | Enable ADC sample clock |
| `CLK_SYSREF_EN` | `[1]` | RW | `0` | Enable JESD204B SYSREF |
| `CLK_FPGA_EN` | `[2]` | RW | `0` | Enable FPGA reference clock |
| `CLK_DAC_EN` | `[3]` | RW | `0` | Enable DAC clock (if present) |
| `CLK_AUX_EN` | `[7:4]` | RW | `0` | Auxiliary clock enables |

---
### `RF_GAIN_CTRL` — Address `0x0700`

**Reset value:** `0x0000`  **Access:** see fields below

RF front-end gain control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ATT1_LE` | `[0]` | RW | `0` | Attenuator 1 Latch Enable (pulse to load) |
| `ATT2_LE` | `[1]` | RW | `0` | Attenuator 2 Latch Enable (pulse to load) |
| `ATTENUATION` | `[10:2]` | RW | `0` | Attenuation value (0-63, 0.5dB steps, max 31.5dB per attenuator) |
| `BYPASS_LNA` | `[15]` | RW | `0` | Bypass LNA (1=bypass, 0=normal) |

---
### `RF_ATTENUATOR1` — Address `0x0701`

**Reset value:** `0x00`  **Access:** see fields below

RF Attenuator 1 parallel data (HMC698LP4 #1)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ATT_DATA` | `[5:0]` | RW | `0` | 6-bit parallel attenuation code (0=0dB, 63=31.5dB) |
| `LOAD` | `[7]` | RW | `0` | Load strobe (1=pulse to load) |

---
### `RF_ATTENUATOR2` — Address `0x0702`

**Reset value:** `0x00`  **Access:** see fields below

RF Attenuator 2 parallel data (HMC698LP4 #2)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ATT_DATA` | `[5:0]` | RW | `0` | 6-bit parallel attenuation code (0=0dB, 63=31.5dB) |
| `LOAD` | `[7]` | RW | `0` | Load strobe (1=pulse to load) |

---
### `RF_STATUS` — Address `0x0703`

**Reset value:** `0x00`  **Access:** see fields below

RF front-end status flags

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LNA_OK` | `[0]` | RO | `0` | LNA bias OK flag |
| `RF_POWER_DET` | `[1]` | RO | `0` | RF power detect threshold exceeded |
| `ATT1_LOCKED` | `[2]` | RO | `0` | Attenuator 1 load complete |
| `ATT2_LOCKED` | `[3]` | RO | `0` | Attenuator 2 load complete |

---
### `JESD_CTRL` — Address `0x0708`

**Reset value:** `0x00`  **Access:** see fields below

JESD204B interface control (ADC10DX100)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0` | JESD204B link enable (1=enabled) |
| `RESET` | `[1]` | RW | `0` | JESD204B link reset (1=reset) |
| `SUBCLASS` | `[3:2]` | RW | `0x1` | JESD subclass (0=0, 1=Subclass1) |
| `LANES_EN` | `[11:4]` | RW | `0xFF` | Lane enable bitmap (8 lanes) |

---
### `JESD_STATUS` — Address `0x0709`

**Reset value:** `0x00`  **Access:** see fields below

JESD204B link status

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LINK_UP` | `[0]` | RO | `0` | Link established (1=UP) |
| `ALIGN_DONE` | `[1]` | RO | `0` | Lane alignment complete |
| `CODE_GRP_SYNC` | `[2]` | RO | `0` | Code group sync complete |
| `ERR_DISPARITY` | `[8]` | RC | `0` | Disparity error (clears on read) |
| `ERR_NOTABLE` | `[9]` | RC | `0` | Character not in table (clears on read) |

---
### `JESD_SCR_L` — Address `0x070A`

**Reset value:** `0x00`  **Access:** see fields below

JESD204B Scrubber value low byte

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `SCR_L` | `[7:0]` | RW | `0x00` | Scrubber value LSB |

---
### `JESD_SCR_H` — Address `0x070B`

**Reset value:** `0x00`  **Access:** see fields below

JESD204B Scrubber value high byte

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `SCR_H` | `[7:0]` | RW | `0x00` | Scrubber value MSB |

---
### `JESD_ILAS_CONFIG` — Address `0x070C`

**Reset value:** `0x04`  **Access:** see fields below

JESD204B ILAS configuration

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ILAS_MODE` | `[1:0]` | RW | `0x1` | ILAS mode (0=off, 1=once, 2=continuous) |
| `CHECKSUM_EN` | `[2]` | RW | `1` | Enable ILAS checksum |

---
### `GPIO_DIR` — Address `0x0800`

**Reset value:** `0x0000`  **Access:** see fields below

GPIO direction control (0=input, 1=output)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GPIO_DIR` | `[15:0]` | RW | `0x0000` | Direction bitmap for GPIO[15:0] (1=output, 0=input) |

---
### `GPIO_OUT` — Address `0x0801`

**Reset value:** `0x0000`  **Access:** see fields below

GPIO output data register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GPIO_DATA` | `[15:0]` | RW | `0x0000` | Output data for GPIO pins configured as outputs |

---
### `GPIO_IN` — Address `0x0802`

**Reset value:** `0x0000`  **Access:** see fields below

GPIO input data register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GPIO_DATA` | `[15:0]` | RO | `0x0000` | Read input data from GPIO pins |

---
### `EEPROM_CTRL` — Address `0x0500`

**Reset value:** `0x00`  **Access:** see fields below

EEPROM control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READ` | `[0]` | RW | `0` | Initiate read (1=start) |
| `WRITE` | `[1]` | RW | `0` | Initiate write (1=start) |
| `ERASE` | `[2]` | RW | `0` | Initiate erase (1=start) |
| `BUSY` | `[7]` | RO | `0` | Operation in progress |

---
### `EEPROM_ADDR` — Address `0x0501`

**Reset value:** `0x0000`  **Access:** see fields below

EEPROM byte address

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADDR` | `[15:0]` | RW | `0x0000` | Byte address for read/write operation |

---
### `EEPROM_DATA` — Address `0x0502`

**Reset value:** `0x0000`  **Access:** see fields below

EEPROM read/write data

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA` | `[15:0]` | RW | `0x0000` | Data for read/write operations |

---
### `FLASH_CTRL` — Address `0x0600`

**Reset value:** `0x00`  **Access:** see fields below

Configuration Flash control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READ` | `[0]` | RW | `0` | Initiate flash read |
| `WRITE` | `[1]` | RW | `0` | Initiate flash write |
| `ERASE_SECTOR` | `[2]` | RW | `0` | Erase flash sector |
| `ERASE_CHIP` | `[3]` | RW | `0` | Erase entire flash chip |
| `BUSY` | `[7]` | RO | `0` | Flash operation busy |

---
### `FLASH_ADDR_LOW` — Address `0x0601`

**Reset value:** `0x0000`  **Access:** see fields below

Flash address low word [15:0]

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADDR_LOW` | `[15:0]` | RW | `0x0000` | Flash address bits [15:0] |

---
### `FLASH_ADDR_HIGH` — Address `0x0602`

**Reset value:** `0x0000`  **Access:** see fields below

Flash address high word [23:16]

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADDR_HIGH` | `[7:0]` | RW | `0x00` | Flash address bits [23:16] |

---
### `FLASH_DATA` — Address `0x0603`

**Reset value:** `0x0000`  **Access:** see fields below

Flash data FIFO

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA` | `[15:0]` | RW | `0x0000` | Data for read/write operations |

---
### `FLASH_STATUS` — Address `0x0604`

**Reset value:** `0x00`  **Access:** see fields below

Flash operation status

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READY` | `[0]` | RO | `0` | Flash ready for operation |
| `WRITE_ERR` | `[1]` | RC | `0` | Write operation failed |
| `ERASE_ERR` | `[2]` | RC | `0` | Erase operation failed |

---
### `POWER_SEQ_CTRL` — Address `0x0900`

**Reset value:** `0x00`  **Access:** see fields below

Power sequencing control (TPS7A4700 LDOs)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `EN_5V` | `[0]` | RW | `0` | Enable 5V LDO (LNA rail) |
| `EN_3V3` | `[1]` | RW | `0` | Enable 3.3V LDO (Digital rail) |
| `EN_1V8` | `[2]` | RW | `0` | Enable 1.8V rail (ADC digital) |
| `EN_1V0` | `[3]` | RW | `0` | Enable 1.0V rail (ADC core) |
| `SEQ_DELAY_MS` | `[15:8]` | RW | `0x0A` | Power-up sequencer delay in ms (default 10ms) |

---
### `POWER_SEQ_STATUS` — Address `0x0901`

**Reset value:** `0x00`  **Access:** see fields below

Power sequencing status

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `PG_5V` | `[0]` | RO | `0` | 5V power good (1=OK) |
| `PG_3V3` | `[1]` | RO | `0` | 3.3V power good (1=OK) |
| `PG_1V8` | `[2]` | RO | `0` | 1.8V power good (1=OK) |
| `PG_1V0` | `[3]` | RO | `0` | 1.0V power good (1=OK) |

---
### `SYSTEM_RESET` — Address `0x0908`

**Reset value:** `0x00`  **Access:** see fields below

System reset control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `SOFT_RESET` | `[0]` | RW | `0` | Soft reset (1=assert) |
| `RF_RESET` | `[1]` | RW | `0` | RF chain reset (1=assert) |
| `ADC_RESET` | `[2]` | RW | `0` | ADC interface reset (1=assert) |

---
### `SYSTEM_IRQ` — Address `0x0909`

**Reset value:** `0x00`  **Access:** see fields below

System interrupt flags

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_IRQ` | `[0]` | RC | `0` | Temperature alert interrupt |
| `VOLT_IRQ` | `[1]` | RC | `0` | Voltage fault interrupt |
| `PLL_IRQ` | `[2]` | RC | `0` | PLL loss-of-lock interrupt |
| `JESD_IRQ` | `[3]` | RC | `0` | JESD204B link error interrupt |

---
### `IRQ_MASK` — Address `0x090A`

**Reset value:** `0xFF`  **Access:** see fields below

Interrupt mask (1=disabled)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MASK_TEMP` | `[0]` | RW | `1` | Mask temperature alerts (1=masked) |
| `MASK_VOLT` | `[1]` | RW | `1` | Mask voltage alerts (1=masked) |
| `MASK_PLL` | `[2]` | RW | `1` | Mask PLL alerts (1=masked) |
| `MASK_JESD` | `[3]` | RW | `1` | Mask JESD alerts (1=masked) |
