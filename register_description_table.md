# Register Description Table (RDT)
## hjgjf

> **Total registers:** 49

Complete register map for hjgjf Wideband RF Receiver featuring 5-18GHz RF front-end with EV10AQ190A quad ADC, HMC1099LP5E LNA, HMC7044 clock generator, LVDS interfaces, and comprehensive monitoring/health status. Includes 47 registers across 10 functional groups with detailed bit-field definitions and 18-step firmware initialization sequence.

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
| `0x0000` | `BOARD_ID` | — | `0x484A` | Board identification code - ASCII 'HJ' for hjgjf project |
| `0x0001` | `BOARD_VERSION` | — | `0x10` | Hardware version number |
| `0x0002` | `BOARD_TYPE_ID` | — | `0x5752` | Board type identifier - Wideband RF Receiver |
| `0x0003` | `SCRATCHPAD` | — | `0x0000` | Read/write test register for RAM verification |
| `0x0010` | `MCS_VERSION_MAJOR` | — | `0x01` | FPGA firmware major version |
| `0x0011` | `MCS_VERSION_MINOR` | — | `0x00` | FPGA firmware minor version |
| `0x0012` | `BUILD_DATE` | — | `0x20260416` | Firmware build date in packed BCD |
| `0x0100` | `UART_BAUD_DIV` | — | `0x0034` | UART baud rate divisor (default 115200 @ 100MHz) |
| `0x0101` | `UART_CTRL` | — | `0x00` | UART control register |
| `0x0102` | `UART_STATUS` | — | `0x00` | UART status flags (read-clear) |
| `0x0103` | `UART_TX_COUNT` | — | `0x00` | TX FIFO byte count |
| `0x0104` | `UART_RX_COUNT` | — | `0x00` | RX FIFO byte count |
| `0x0110` | `ETH_MAC_LOW` | — | `0x0000` | Ethernet MAC address lower 16 bits |
| `0x0111` | `ETH_MAC_HIGH` | — | `0x0000` | Ethernet MAC address upper 16 bits |
| `0x0200` | `ADC_CTRL` | — | `0x00` | EV10AQ190A ADC control |
| `0x0201` | `ADC_STATUS` | — | `0x00` | ADC status flags |
| `0x0210` | `VCC_5V_RAW` | — | `0x0000` | 5V rail ADC count (12-bit) |
| `0x0211` | `VCC_3V3_RAW` | — | `0x0000` | 3.3V rail ADC count (12-bit) |
| `0x0212` | `VCC_2V5_RAW` | — | `0x0000` | 2.5V rail ADC count (12-bit) |
| `0x0213` | `VCC_1V8_RAW` | — | `0x0000` | 1.8V rail ADC count (12-bit) |
| `0x0218` | `ICC_5V_RAW` | — | `0x0000` | 5V rail current ADC count |
| `0x0219` | `ICC_3V3_RAW` | — | `0x0000` | 3.3V rail current ADC count |
| `0x0300` | `TEMP_LOCAL` | — | `0x0000` | FPGA die temperature (signed, 0.25°C units) |
| `0x0301` | `TEMP_REMOTE1` | — | `0x0000` | Remote sensor 1 (LNA area) temperature |
| `0x0302` | `TEMP_REMOTE2` | — | `0x0000` | Remote sensor 2 (ADC area) temperature |
| `0x0308` | `TEMP_ALERT_HIGH` | — | `0x0190` | Over-temperature alert threshold (100°C default) |
| `0x0309` | `TEMP_ALERT_LOW` | — | `0xFF9C` | Under-temperature alert threshold (-25°C default) |
| `0x030F` | `HEALTH_STATUS` | — | `0x87` | System health status |
| `0x0400` | `PLL_CTRL` | — | `0x00` | HMC7044 clock generator PLL control |
| `0x0401` | `PLL_STATUS` | — | `0x00` | PLL status flags |
| `0x0402` | `PLL_N_DIV` | — | `0x0064` | PLL N divider (default 100 for 5GHz from 50MHz) |
| `0x0403` | `PLL_R_DIV` | — | `0x0001` | PLL R divider (reference divider) |
| `0x0410` | `CLK_ENABLE` | — | `0x00` | Clock output enables |
| `0x0700` | `RF_LNA_CTRL` | — | `0x01` | HMC1099LP5E LNA control |
| `0x0701` | `RF_GAIN_CTRL` | — | `0x16` | RF gain control (fine) |
| `0x0702` | `RF_STATUS` | — | `0x00` | RF front-end status |
| `0x0900` | `DAC_OUTPUT` | — | `0x0000` | DAC output control (VGA or external) |
| `0x0901` | `DAC_CTRL` | — | `0x00` | DAC control |
| `0x0800` | `GPIO_DIR` | — | `0x0000` | GPIO direction control |
| `0x0801` | `GPIO_DATA_OUT` | — | `0x0000` | GPIO output data |
| `0x0802` | `GPIO_DATA_IN` | — | `0x0000` | GPIO input data |
| `0x0500` | `EEPROM_CTRL` | — | `0x00` | EEPROM control |
| `0x0501` | `EEPROM_ADDR` | — | `0x0000` | EEPROM address |
| `0x0502` | `EEPROM_DATA` | — | `0x0000` | EEPROM data |
| `0x0600` | `FLASH_CTRL` | — | `0x00` | Configuration flash control |
| `0x0601` | `FLASH_ADDR_LOW` | — | `0x0000` | Flash address low word |
| `0x0602` | `FLASH_ADDR_HIGH` | — | `0x0000` | Flash address high byte |
| `0x0603` | `FLASH_DATA` | — | `0x0000` | Flash data FIFO |
| `0x0604` | `FLASH_STATUS` | — | `0x01` | Flash status |

---
### `BOARD_ID` — Address `0x0000`

**Reset value:** `0x484A`  **Access:** see fields below

Board identification code - ASCII 'HJ' for hjgjf project

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ID_CODE` | `[15:0]` | R | `0x484A` | Unique board identifier (ASCII 'HJ' = 0x484A) |

---
### `BOARD_VERSION` — Address `0x0001`

**Reset value:** `0x10`  **Access:** see fields below

Hardware version number

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAJOR_VERSION` | `[7:4]` | R | `0x1` | Major revision (1.0 = 0x10) |
| `MINOR_VERSION` | `[3:0]` | R | `0x0` | Minor revision |

---
### `BOARD_TYPE_ID` — Address `0x0002`

**Reset value:** `0x5752`  **Access:** see fields below

Board type identifier - Wideband RF Receiver

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TYPE_CODE` | `[15:0]` | R | `0x5752` | Type ID (ASCII 'WR' = Wideband Receiver) |

---
### `SCRATCHPAD` — Address `0x0003`

**Reset value:** `0x0000`  **Access:** see fields below

Read/write test register for RAM verification

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEST_PATTERN` | `[15:0]` | RW | `0x0000` | General-purpose test register |

---
### `MCS_VERSION_MAJOR` — Address `0x0010`

**Reset value:** `0x01`  **Access:** see fields below

FPGA firmware major version

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAJOR` | `[7:0]` | R | `0x01` | Firmware major version number |

---
### `MCS_VERSION_MINOR` — Address `0x0011`

**Reset value:** `0x00`  **Access:** see fields below

FPGA firmware minor version

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MINOR` | `[7:0]` | R | `0x00` | Firmware minor version number |

---
### `BUILD_DATE` — Address `0x0012`

**Reset value:** `0x20260416`  **Access:** see fields below

Firmware build date in packed BCD

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `YEAR` | `[15:12]` | R | `0x2` | Build year (0x2 = 2026) |
| `MONTH` | `[11:8]` | R | `0x4` | Build month (April = 0x4) |
| `DAY` | `[7:0]` | R | `0x16` | Build day (16 = 0x16) |

---
### `UART_BAUD_DIV` — Address `0x0100`

**Reset value:** `0x0034`  **Access:** see fields below

UART baud rate divisor (default 115200 @ 100MHz)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DIVISOR` | `[15:0]` | RW | `0x0034` | Baud = CLK_FREQ / (16 * DIVISOR) |

---
### `UART_CTRL` — Address `0x0101`

**Reset value:** `0x00`  **Access:** see fields below

UART control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0` | UART enable (1=enabled) |
| `LOOPBACK` | `[1]` | RW | `0` | Internal loopback mode |
| `FRAME_FORMAT` | `[7:4]` | RW | `0x0` | Frame format (0=8N1) |

---
### `UART_STATUS` — Address `0x0102`

**Reset value:** `0x00`  **Access:** see fields below

UART status flags (read-clear)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TX_BUSY` | `[0]` | R | `0` | Transmitter busy flag |
| `RX_AVAIL` | `[1]` | RC | `0` | RX data available |
| `FRAME_ERR` | `[2]` | RC | `0` | Frame error detected |

---
### `UART_TX_COUNT` — Address `0x0103`

**Reset value:** `0x00`  **Access:** see fields below

TX FIFO byte count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TX_FIFO_COUNT` | `[7:0]` | R | `0x00` | Number of bytes in TX FIFO |

---
### `UART_RX_COUNT` — Address `0x0104`

**Reset value:** `0x00`  **Access:** see fields below

RX FIFO byte count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `RX_FIFO_COUNT` | `[7:0]` | R | `0x00` | Number of bytes in RX FIFO |

---
### `ETH_MAC_LOW` — Address `0x0110`

**Reset value:** `0x0000`  **Access:** see fields below

Ethernet MAC address lower 16 bits

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAC_LSB` | `[15:0]` | R | `0x0000` | MAC address [15:0] |

---
### `ETH_MAC_HIGH` — Address `0x0111`

**Reset value:** `0x0000`  **Access:** see fields below

Ethernet MAC address upper 16 bits

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAC_MSB` | `[15:0]` | R | `0x0000` | MAC address [31:16] |

---
### `ADC_CTRL` — Address `0x0200`

**Reset value:** `0x00`  **Access:** see fields below

EV10AQ190A ADC control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `START` | `[0]` | RW | `0` | Start ADC conversion (1=start) |
| `CONTINUOUS` | `[1]` | RW | `0` | Continuous mode (1=continuous) |
| `CHANNEL_SEL` | `[3:2]` | RW | `0x0` | Channel select (0=CH1, 1=CH2, 2=CH3, 3=CH4) |
| `POWER_DOWN` | `[4]` | RW | `0` | ADC power-down (1=PD) |
| `LVDS_ENABLE` | `[5]` | RW | `0` | LVDS output enable |

---
### `ADC_STATUS` — Address `0x0201`

**Reset value:** `0x00`  **Access:** see fields below

ADC status flags

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA_READY` | `[0]` | RC | `0` | New sample data ready |
| `OVERRANGE` | `[1]` | RC | `0` | Input overrange detected |
| `FIFO_FULL` | `[2]` | R | `0` | ADC FIFO full |

---
### `VCC_5V_RAW` — Address `0x0210`

**Reset value:** `0x0000`  **Access:** see fields below

5V rail ADC count (12-bit)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | R | `0x000` | Raw ADC count; V = COUNT * 5.0 / 4096 |

---
### `VCC_3V3_RAW` — Address `0x0211`

**Reset value:** `0x0000`  **Access:** see fields below

3.3V rail ADC count (12-bit)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | R | `0x000` | Raw ADC count; V = COUNT * 3.3 / 4096 |

---
### `VCC_2V5_RAW` — Address `0x0212`

**Reset value:** `0x0000`  **Access:** see fields below

2.5V rail ADC count (12-bit)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | R | `0x000` | Raw ADC count; V = COUNT * 2.5 / 4096 |

---
### `VCC_1V8_RAW` — Address `0x0213`

**Reset value:** `0x0000`  **Access:** see fields below

1.8V rail ADC count (12-bit)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | R | `0x000` | Raw ADC count; V = COUNT * 1.8 / 4096 |

---
### `ICC_5V_RAW` — Address `0x0218`

**Reset value:** `0x0000`  **Access:** see fields below

5V rail current ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | R | `0x000` | Raw current ADC count |

---
### `ICC_3V3_RAW` — Address `0x0219`

**Reset value:** `0x0000`  **Access:** see fields below

3.3V rail current ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | R | `0x000` | Raw current ADC count |

---
### `TEMP_LOCAL` — Address `0x0300`

**Reset value:** `0x0000`  **Access:** see fields below

FPGA die temperature (signed, 0.25°C units)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_VALUE` | `[9:0]` | R | `0x000` | Temperature in 0.25°C steps (signed 10-bit) |
| `SIGN` | `[9]` | R | `0` | Sign bit (1=negative) |

---
### `TEMP_REMOTE1` — Address `0x0301`

**Reset value:** `0x0000`  **Access:** see fields below

Remote sensor 1 (LNA area) temperature

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_VALUE` | `[9:0]` | R | `0x000` | Remote sensor 1 temperature |

---
### `TEMP_REMOTE2` — Address `0x0302`

**Reset value:** `0x0000`  **Access:** see fields below

Remote sensor 2 (ADC area) temperature

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_VALUE` | `[9:0]` | R | `0x000` | Remote sensor 2 temperature |

---
### `TEMP_ALERT_HIGH` — Address `0x0308`

**Reset value:** `0x0190`  **Access:** see fields below

Over-temperature alert threshold (100°C default)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `THRESHOLD` | `[9:0]` | RW | `0x190` | Alert threshold (0x190 = 100°C) |

---
### `TEMP_ALERT_LOW` — Address `0x0309`

**Reset value:** `0xFF9C`  **Access:** see fields below

Under-temperature alert threshold (-25°C default)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `THRESHOLD` | `[9:0]` | RW | `0xFF9C` | Alert threshold (0xFF9C = -25°C) |

---
### `HEALTH_STATUS` — Address `0x030F`

**Reset value:** `0x87`  **Access:** see fields below

System health status

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_OK` | `[0]` | R | `1` | Temperature within limits |
| `VOLT_OK` | `[1]` | R | `1` | All voltages within tolerance |
| `PLL_LOCK` | `[2]` | R | `0` | HMC7044 PLL locked (0=unlocked at reset) |
| `ADC_OK` | `[3]` | R | `0` | ADC functional |
| `LNA_OK` | `[4]` | R | `1` | LNA supply OK |
| `SYSTEM_OK` | `[7]` | R | `1` | Overall system health |

---
### `PLL_CTRL` — Address `0x0400`

**Reset value:** `0x00`  **Access:** see fields below

HMC7044 clock generator PLL control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0` | PLL enable (1=enable) |
| `RESET` | `[1]` | RW | `0` | PLL reset (1=hold in reset) |
| `REF_SEL` | `[3:2]` | RW | `0x0` | Reference clock select (0=10MHz, 1=100MHz, 2=external) |
| `DIV_SYNC` | `[4]` | RW | `0` | Sync divider outputs (pulse high) |

---
### `PLL_STATUS` — Address `0x0401`

**Reset value:** `0x00`  **Access:** see fields below

PLL status flags

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LOCKED` | `[0]` | R | `0` | PLL locked indicator |
| `LOSS_OF_LOCK` | `[1]` | RC | `0` | Loss of lock event (read-clear) |

---
### `PLL_N_DIV` — Address `0x0402`

**Reset value:** `0x0064`  **Access:** see fields below

PLL N divider (default 100 for 5GHz from 50MHz)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `N_DIVIDER` | `[15:0]` | RW | `0x0064` | N divider value (1-16383) |

---
### `PLL_R_DIV` — Address `0x0403`

**Reset value:** `0x0001`  **Access:** see fields below

PLL R divider (reference divider)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `R_DIVIDER` | `[7:0]` | RW | `0x01` | R divider value (1-255) |

---
### `CLK_ENABLE` — Address `0x0410`

**Reset value:** `0x00`  **Access:** see fields below

Clock output enables

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `CLK_ADC_EN` | `[0]` | RW | `0` | ADC sample clock (5GHz) |
| `CLK_FPGA_EN` | `[1]` | RW | `0` | FPGA system clock (100MHz) |
| `CLK_LVDS_EN` | `[2]` | RW | `0` | LVDS interface clock |
| `CLK_DAC_EN` | `[3]` | RW | `0` | DAC clock output |

---
### `RF_LNA_CTRL` — Address `0x0700`

**Reset value:** `0x01`  **Access:** see fields below

HMC1099LP5E LNA control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LNA_ENABLE` | `[0]` | RW | `1` | LNA enable (1=enabled) |
| `GAIN_MODE` | `[1]` | RW | `0` | Gain mode (0=fixed, 1=AGC) |
| `GAIN_SET` | `[4:2]` | RW | `0x6` | Fixed gain setting (0-7, default 6=22dB) |
| `BYPASS` | `[5]` | RW | `0` | LNA bypass (1=bypass) |

---
### `RF_GAIN_CTRL` — Address `0x0701`

**Reset value:** `0x16`  **Access:** see fields below

RF gain control (fine)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `FINE_GAIN` | `[7:0]` | RW | `0x16` | Fine gain adjust (0-31, default 22 decimal) |

---
### `RF_STATUS` — Address `0x0702`

**Reset value:** `0x00`  **Access:** see fields below

RF front-end status

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LNA_OK` | `[0]` | R | `0` | LNA power OK |
| `LIMIT_ACTIVE` | `[1]` | RC | `0` | Limiter triggered (read-clear) |
| `OVERPOWER` | `[2]` | RC | `0` | Overpower detected |

---
### `DAC_OUTPUT` — Address `0x0900`

**Reset value:** `0x0000`  **Access:** see fields below

DAC output control (VGA or external)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DAC_VALUE` | `[15:0]` | RW | `0x0000` | 16-bit DAC output code |

---
### `DAC_CTRL` — Address `0x0901`

**Reset value:** `0x00`  **Access:** see fields below

DAC control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DAC_ENABLE` | `[0]` | RW | `0` | DAC enable |
| `DAC_UPDATE` | `[1]` | W | `0` | Update DAC output (pulse) |
| `DAC_PWR_MODE` | `[2]` | RW | `0` | Power mode (0=normal, 1=low-power) |

---
### `GPIO_DIR` — Address `0x0800`

**Reset value:** `0x0000`  **Access:** see fields below

GPIO direction control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GPIO_DIR` | `[15:0]` | RW | `0x0000` | 1=output, 0=input (bit per GPIO) |

---
### `GPIO_DATA_OUT` — Address `0x0801`

**Reset value:** `0x0000`  **Access:** see fields below

GPIO output data

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GPIO_OUT` | `[15:0]` | RW | `0x0000` | Output value for GPIO pins configured as outputs |

---
### `GPIO_DATA_IN` — Address `0x0802`

**Reset value:** `0x0000`  **Access:** see fields below

GPIO input data

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GPIO_IN` | `[15:0]` | R | `0x0000` | Input value from all GPIO pins |

---
### `EEPROM_CTRL` — Address `0x0500`

**Reset value:** `0x00`  **Access:** see fields below

EEPROM control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READ` | `[0]` | RW | `0` | Read command (1=start read) |
| `WRITE` | `[1]` | RW | `0` | Write command (1=start write) |
| `ERASE` | `[2]` | RW | `0` | Erase command |
| `BUSY` | `[7]` | R | `0` | EEPROM busy flag |

---
### `EEPROM_ADDR` — Address `0x0501`

**Reset value:** `0x0000`  **Access:** see fields below

EEPROM address

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADDR` | `[15:0]` | RW | `0x0000` | EEPROM byte address |

---
### `EEPROM_DATA` — Address `0x0502`

**Reset value:** `0x0000`  **Access:** see fields below

EEPROM data

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA` | `[15:0]` | RW | `0x0000` | Read/write data |

---
### `FLASH_CTRL` — Address `0x0600`

**Reset value:** `0x00`  **Access:** see fields below

Configuration flash control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READ` | `[0]` | RW | `0` | Flash read command |
| `WRITE` | `[1]` | RW | `0` | Flash write command |
| `ERASE_SECTOR` | `[2]` | RW | `0` | Erase sector command |
| `ERASE_CHIP` | `[3]` | RW | `0` | Erase chip command |
| `BUSY` | `[7]` | R | `0` | Flash busy flag |

---
### `FLASH_ADDR_LOW` — Address `0x0601`

**Reset value:** `0x0000`  **Access:** see fields below

Flash address low word

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADDR_LOW` | `[15:0]` | RW | `0x0000` | Flash address [15:0] |

---
### `FLASH_ADDR_HIGH` — Address `0x0602`

**Reset value:** `0x0000`  **Access:** see fields below

Flash address high byte

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADDR_HIGH` | `[7:0]` | RW | `0x00` | Flash address [23:16] |

---
### `FLASH_DATA` — Address `0x0603`

**Reset value:** `0x0000`  **Access:** see fields below

Flash data FIFO

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA` | `[15:0]` | RW | `0x0000` | Read/write data |

---
### `FLASH_STATUS` — Address `0x0604`

**Reset value:** `0x01`  **Access:** see fields below

Flash status

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READY` | `[0]` | R | `1` | Flash ready flag |
| `WRITE_ERR` | `[1]` | RC | `0` | Write error flag |
| `ERASE_ERR` | `[2]` | RC | `0` | Erase error flag |
