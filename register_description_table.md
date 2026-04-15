# Register Description Table (RDT)
## kh

> **Total registers:** 54

**kh Wideband RF Receiver Module Register Map**
- 44 registers mapped across 11 functional groups (0x000-0x0A00)
- UART command interface at 115200 bps with single/bulk read-write protocols
- RF front-end control: HMC1119 LNA, HMC698LP4 VGA (6-bit gain), HMC1051 Mixer
- JESD204B link control for ADC12DJ5200RF (5.2 GSPS)
- Power monitoring via LTC2975 (5V, 3.3V, 1.8V, 1.2V rails)
- Clock generation via LMK04828BKNQ with PLL lock monitoring
- 512 Mb Configuration Flash (S25FL512S) and EEPROM for calibration storage
- 20-step initialization sequence spanning power-on self-test through RF enable

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
| `0x0000` | `BOARD_ID` | — | `0x4B48` | Board identification code - kh Wideband RF Receiver unique identifier |
| `0x0001` | `BOARD_VERSION` | — | `0x01` | Hardware version number |
| `0x0002` | `BOARD_TYPE_ID` | — | `0x5246` | Board type identifier |
| `0x0003` | `SCRATCHPAD` | — | `0x0000` | Scratchpad register for RAM/CPU connectivity test |
| `0x0010` | `MCS_VERSION_MAJOR` | — | `0x01` | FPGA firmware major version number |
| `0x0011` | `MCS_VERSION_MINOR` | — | `0x00` | FPGA firmware minor version number |
| `0x0012` | `BUILD_DATE` | — | `0x2415` | FPGA build date in packed BCD format (YYYYMMDD) |
| `0x0100` | `UART_BAUD_DIV` | — | `0x0036` | UART baud rate divisor (115200 bps default) |
| `0x0101` | `UART_CTRL` | — | `0x03` | UART control register |
| `0x0102` | `UART_STATUS` | — | `0x00` | UART status flags (read-clear) |
| `0x0103` | `UART_TX_COUNT` | — | `0x00` | TX FIFO byte count |
| `0x0104` | `UART_RX_COUNT` | — | `0x00` | RX FIFO byte count |
| `0x0200` | `ADC_CTRL` | — | `0x00` | ADC control for power monitoring |
| `0x0201` | `ADC_STATUS` | — | `0x00` | ADC status flags |
| `0x0210` | `VCC_5V_RAW` | — | `0x0000` | 5V rail ADC raw count |
| `0x0211` | `VCC_3V3_RAW` | — | `0x0000` | 3.3V rail ADC raw count |
| `0x0212` | `VCC_2V5_RAW` | — | `0x0000` | 2.5V rail ADC raw count |
| `0x0213` | `VCC_1V8_RAW` | — | `0x0000` | 1.8V rail ADC raw count |
| `0x0214` | `VCC_1V2_RAW` | — | `0x0000` | 1.2V rail ADC raw count (FPGA Core) |
| `0x0218` | `ICC_5V_RAW` | — | `0x0000` | 5V rail current sense ADC |
| `0x0219` | `ICC_3V3_RAW` | — | `0x0000` | 3.3V rail current sense ADC |
| `0x0300` | `TEMP_LOCAL` | — | `0x0000` | Local FPGA die temperature |
| `0x0301` | `TEMP_REMOTE1` | — | `0x0000` | Remote temperature sensor 1 (via LTC2975) |
| `0x0302` | `TEMP_REMOTE2` | — | `0x0000` | Remote temperature sensor 2 |
| `0x0308` | `TEMP_ALERT_HIGH` | — | `0x0190` | Over-temperature alert threshold |
| `0x0309` | `TEMP_ALERT_LOW` | — | `0x0288` | Under-temperature alert threshold |
| `0x030F` | `HEALTH_STATUS` | — | `0x00` | System health status flags |
| `0x0400` | `PLL_CTRL` | — | `0x00` | PLL/LMK04828 control register |
| `0x0401` | `PLL_STATUS` | — | `0x00` | PLL status flags |
| `0x0402` | `PLL_N_DIV` | — | `0x0064` | PLL N divider value |
| `0x0403` | `PLL_R_DIV` | — | `0x01` | PLL R divider value |
| `0x0410` | `CLK_ENABLE` | — | `0x00` | Clock output enables |
| `0x0420` | `JESD204B_CTRL` | — | `0x00` | JESD204B interface control |
| `0x0421` | `JESD204B_STATUS` | — | `0x00` | JESD204B link status |
| `0x0500` | `EEPROM_CTRL` | — | `0x00` | EEPROM control register |
| `0x0501` | `EEPROM_ADDR` | — | `0x0000` | EEPROM byte address |
| `0x0502` | `EEPROM_DATA` | — | `0x0000` | EEPROM read/write data |
| `0x0600` | `FLASH_CTRL` | — | `0x00` | Configuration Flash control (S25FL512S) |
| `0x0601` | `FLASH_ADDR_LOW` | — | `0x0000` | Flash address low word [15:0] |
| `0x0602` | `FLASH_ADDR_HIGH` | — | `0x00` | Flash address high word [23:16] |
| `0x0603` | `FLASH_DATA` | — | `0x0000` | Flash read/write data |
| `0x0604` | `FLASH_STATUS` | — | `0x01` | Flash operation status |
| `0x0700` | `RF_VGA_GAIN` | — | `0x20` | HMC698LP4 VGA gain control (6-bit SPI) |
| `0x0701` | `RF_CTRL` | — | `0x80` | RF front-end control |
| `0x0702` | `RF_STATUS` | — | `0x00` | RF front-end status |
| `0x0708` | `AGC_CONFIG` | — | `0x80` | Automatic Gain Control configuration |
| `0x0800` | `GPIO_DIR` | — | `0x00` | GPIO direction control |
| `0x0801` | `GPIO_DATA` | — | `0x00` | GPIO data write/read |
| `0x0802` | `GPIO_IN` | — | `0x00` | GPIO input read |
| `0x0803` | `GPIO_IRQ` | — | `0x00` | GPIO interrupt flags |
| `0x0900` | `SYSTEM_RESET` | — | `0x00` | System reset control |
| `0x0A00` | `I2C_CTRL` | — | `0x00` | I2C master control (LTC2975, LMK04828) |
| `0x0A01` | `I2C_STATUS` | — | `0x00` | I2C master status |
| `0x0A02` | `I2C_TXRX` | — | `0x00` | I2C transmit/receive data |

---
### `BOARD_ID` — Address `0x0000`

**Reset value:** `0x4B48`  **Access:** see fields below

Board identification code - kh Wideband RF Receiver unique identifier

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BOARD_ID` | `[15:0]` | RO | `0x4B48` | Unique board identifier 0x4B48 (ASCII 'KH') |

---
### `BOARD_VERSION` — Address `0x0001`

**Reset value:** `0x01`  **Access:** see fields below

Hardware version number

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAJOR_VERSION` | `[7:4]` | RO | `0x0` | Major revision number |
| `MINOR_VERSION` | `[3:0]` | RO | `0x1` | Minor revision number |

---
### `BOARD_TYPE_ID` — Address `0x0002`

**Reset value:** `0x5246`  **Access:** see fields below

Board type identifier

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TYPE_ID` | `[15:0]` | RO | `0x5246` | Board type: 0x5246 (ASCII 'RF') for RF Receiver |

---
### `SCRATCHPAD` — Address `0x0003`

**Reset value:** `0x0000`  **Access:** see fields below

Scratchpad register for RAM/CPU connectivity test

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEST_VALUE` | `[15:0]` | RW | `0x0000` | Read/write test pattern for RAM verification |

---
### `MCS_VERSION_MAJOR` — Address `0x0010`

**Reset value:** `0x01`  **Access:** see fields below

FPGA firmware major version number

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAJOR` | `[7:0]` | RO | `0x01` | Major firmware version |

---
### `MCS_VERSION_MINOR` — Address `0x0011`

**Reset value:** `0x00`  **Access:** see fields below

FPGA firmware minor version number

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MINOR` | `[7:0]` | RO | `0x00` | Minor firmware version |

---
### `BUILD_DATE` — Address `0x0012`

**Reset value:** `0x2415`  **Access:** see fields below

FPGA build date in packed BCD format (YYYYMMDD)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `YEAR` | `[15:12]` | RO | `0x2` | Build year (BCD) |
| `MONTH` | `[11:8]` | RO | `0x04` | Build month (BCD) |
| `DAY` | `[7:0]` | RO | `0x15` | Build day (BCD) |

---
### `UART_BAUD_DIV` — Address `0x0100`

**Reset value:** `0x0036`  **Access:** see fields below

UART baud rate divisor (115200 bps default)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DIVISOR` | `[15:0]` | RW | `0x0036` | Baud = CLK_FREQ / (16 * DIV), 54 = 115200@100MHz |

---
### `UART_CTRL` — Address `0x0101`

**Reset value:** `0x03`  **Access:** see fields below

UART control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0x0` | UART enable (1=enabled) |
| `LOOPBACK` | `[1]` | RW | `0x0` | Internal loopback for test |
| `PARITY_EN` | `[2]` | RW | `0x0` | Parity enable |
| `PARITY_EVEN` | `[3]` | RW | `0x0` | Parity type (1=even, 0=odd) |
| `FRAME_FORMAT` | `[7:4]` | RW | `0x3` | Frame format (bits, stop bits) |

---
### `UART_STATUS` — Address `0x0102`

**Reset value:** `0x00`  **Access:** see fields below

UART status flags (read-clear)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TX_BUSY` | `[0]` | RC | `0x0` | Transmitter busy flag |
| `RX_AVAIL` | `[1]` | RC | `0x0` | Data available in RX FIFO |
| `FRAME_ERR` | `[2]` | RC | `0x0` | Frame error detected |
| `PARITY_ERR` | `[3]` | RC | `0x0` | Parity error detected |

---
### `UART_TX_COUNT` — Address `0x0103`

**Reset value:** `0x00`  **Access:** see fields below

TX FIFO byte count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TX_COUNT` | `[7:0]` | RO | `0x00` | Number of bytes in TX FIFO |

---
### `UART_RX_COUNT` — Address `0x0104`

**Reset value:** `0x00`  **Access:** see fields below

RX FIFO byte count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `RX_COUNT` | `[7:0]` | RO | `0x00` | Number of bytes in RX FIFO |

---
### `ADC_CTRL` — Address `0x0200`

**Reset value:** `0x00`  **Access:** see fields below

ADC control for power monitoring

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `START` | `[0]` | RW | `0x0` | Start ADC conversion |
| `CONTINUOUS` | `[1]` | RW | `0x0` | Continuous conversion mode |
| `CHANNEL_SEL` | `[3:2]` | RW | `0x0` | Input channel select |

---
### `ADC_STATUS` — Address `0x0201`

**Reset value:** `0x00`  **Access:** see fields below

ADC status flags

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA_READY` | `[0]` | RC | `0x0` | New conversion data ready |
| `OVERRANGE` | `[1]` | RC | `0x0` | Input overrange detected |

---
### `VCC_5V_RAW` — Address `0x0210`

**Reset value:** `0x0000`  **Access:** see fields below

5V rail ADC raw count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | RO | `0x000` | 12-bit ADC count, Volts = COUNT * 5.0/4096 |

---
### `VCC_3V3_RAW` — Address `0x0211`

**Reset value:** `0x0000`  **Access:** see fields below

3.3V rail ADC raw count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | RO | `0x000` | 12-bit ADC count, Volts = COUNT * 3.3/4096 |

---
### `VCC_2V5_RAW` — Address `0x0212`

**Reset value:** `0x0000`  **Access:** see fields below

2.5V rail ADC raw count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | RO | `0x000` | 12-bit ADC count (if present) |

---
### `VCC_1V8_RAW` — Address `0x0213`

**Reset value:** `0x0000`  **Access:** see fields below

1.8V rail ADC raw count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | RO | `0x000` | 12-bit ADC count, Volts = COUNT * 1.8/4096 |

---
### `VCC_1V2_RAW` — Address `0x0214`

**Reset value:** `0x0000`  **Access:** see fields below

1.2V rail ADC raw count (FPGA Core)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | RO | `0x000` | 12-bit ADC count, Volts = COUNT * 1.2/4096 |

---
### `ICC_5V_RAW` — Address `0x0218`

**Reset value:** `0x0000`  **Access:** see fields below

5V rail current sense ADC

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | RO | `0x000` | 12-bit ADC count for current |

---
### `ICC_3V3_RAW` — Address `0x0219`

**Reset value:** `0x0000`  **Access:** see fields below

3.3V rail current sense ADC

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | RO | `0x000` | 12-bit ADC count for current |

---
### `TEMP_LOCAL` — Address `0x0300`

**Reset value:** `0x0000`  **Access:** see fields below

Local FPGA die temperature

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP` | `[9:0]` | RO | `0x000` | Temperature in 0.25°C units (signed) |

---
### `TEMP_REMOTE1` — Address `0x0301`

**Reset value:** `0x0000`  **Access:** see fields below

Remote temperature sensor 1 (via LTC2975)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP` | `[9:0]` | RO | `0x000` | Remote temperature in 0.25°C units (signed) |

---
### `TEMP_REMOTE2` — Address `0x0302`

**Reset value:** `0x0000`  **Access:** see fields below

Remote temperature sensor 2

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP` | `[9:0]` | RO | `0x000` | Remote temperature in 0.25°C units (signed) |

---
### `TEMP_ALERT_HIGH` — Address `0x0308`

**Reset value:** `0x0190`  **Access:** see fields below

Over-temperature alert threshold

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `THRESHOLD` | `[9:0]` | RW | `0x190` | Alert threshold in 0.25°C units |

---
### `TEMP_ALERT_LOW` — Address `0x0309`

**Reset value:** `0x0288`  **Access:** see fields below

Under-temperature alert threshold

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `THRESHOLD` | `[9:0]` | RW | `0x288` | Alert threshold (signed, 0x288 = -100°C) |

---
### `HEALTH_STATUS` — Address `0x030F`

**Reset value:** `0x00`  **Access:** see fields below

System health status flags

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_OK` | `[0]` | RO | `0x0` | Temperature within limits (1=OK) |
| `VOLT_OK` | `[1]` | RO | `0x0` | All voltages within limits (1=OK) |
| `PLL_LOCK` | `[2]` | RO | `0x0` | PLL locked (1=LOCKED) |
| `JESD204B_SYNC` | `[3]` | RO | `0x0` | JESD204B link synchronized |
| `SYSTEM_OK` | `[7]` | RO | `0x0` | Overall system health (1=OK) |

---
### `PLL_CTRL` — Address `0x0400`

**Reset value:** `0x00`  **Access:** see fields below

PLL/LMK04828 control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0x0` | PLL enable (1=enabled) |
| `RESET` | `[1]` | RW | `0x0` | PLL reset (active high, self-clearing) |
| `REF_SEL` | `[3:2]` | RW | `0x0` | Reference clock select (00=10MHz osc) |

---
### `PLL_STATUS` — Address `0x0401`

**Reset value:** `0x00`  **Access:** see fields below

PLL status flags

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LOCKED` | `[0]` | RO | `0x0` | PLL locked indicator |
| `LOSS_OF_LOCK` | `[1]` | RC | `0x0` | PLL loss of lock event |

---
### `PLL_N_DIV` — Address `0x0402`

**Reset value:** `0x0064`  **Access:** see fields below

PLL N divider value

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `N_DIVIDER` | `[15:0]` | RW | `0x0064` | Integer N divider value |

---
### `PLL_R_DIV` — Address `0x0403`

**Reset value:** `0x01`  **Access:** see fields below

PLL R divider value

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `R_DIVIDER` | `[7:0]` | RW | `0x01` | R divider value |

---
### `CLK_ENABLE` — Address `0x0410`

**Reset value:** `0x00`  **Access:** see fields below

Clock output enables

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `CLK_ADC_EN` | `[0]` | RW | `0x0` | ADC sample clock enable |
| `CLK_FPGA_EN` | `[1]` | RW | `0x0` | FPGA fabric clock enable |
| `CLK_JESD_EN` | `[2]` | RW | `0x0` | JESD204B lane clock enable |

---
### `JESD204B_CTRL` — Address `0x0420`

**Reset value:** `0x00`  **Access:** see fields below

JESD204B interface control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0x0` | JESD204B link enable |
| `RESET` | `[1]` | RW | `0x0` | JESD204B reset (self-clearing) |
| `LANE_MODE` | `[3:2]` | RW | `0x0` | Lane mode (00=dual, 01=interleaved) |

---
### `JESD204B_STATUS` — Address `0x0421`

**Reset value:** `0x00`  **Access:** see fields below

JESD204B link status

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `SYNC` | `[0]` | RO | `0x0` | Link synchronized (SYNC~ asserted) |
| `ALIGN_DONE` | `[1]` | RO | `0x0` | Lane alignment complete |

---
### `EEPROM_CTRL` — Address `0x0500`

**Reset value:** `0x00`  **Access:** see fields below

EEPROM control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READ` | `[0]` | RW | `0x0` | Initiate read (self-clearing) |
| `WRITE` | `[1]` | RW | `0x0` | Initiate write (self-clearing) |
| `ERASE` | `[2]` | RW | `0x0` | Initiate erase (self-clearing) |
| `BUSY` | `[7]` | RO | `0x0` | EEPROM busy flag |

---
### `EEPROM_ADDR` — Address `0x0501`

**Reset value:** `0x0000`  **Access:** see fields below

EEPROM byte address

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADDRESS` | `[15:0]` | RW | `0x0000` | 16-bit byte address |

---
### `EEPROM_DATA` — Address `0x0502`

**Reset value:** `0x0000`  **Access:** see fields below

EEPROM read/write data

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA` | `[15:0]` | RW | `0x0000` | 16-bit data word |

---
### `FLASH_CTRL` — Address `0x0600`

**Reset value:** `0x00`  **Access:** see fields below

Configuration Flash control (S25FL512S)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READ` | `[0]` | RW | `0x0` | Initiate read (self-clearing) |
| `WRITE` | `[1]` | RW | `0x0` | Initiate program (self-clearing) |
| `ERASE_SECTOR` | `[2]` | RW | `0x0` | Erase sector (self-clearing) |
| `ERASE_CHIP` | `[3]` | RW | `0x0` | Erase entire chip (self-clearing) |
| `BUSY` | `[7]` | RO | `0x0` | Flash busy flag |

---
### `FLASH_ADDR_LOW` — Address `0x0601`

**Reset value:** `0x0000`  **Access:** see fields below

Flash address low word [15:0]

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADDR_LOW` | `[15:0]` | RW | `0x0000` | Flash address bits [15:0] |

---
### `FLASH_ADDR_HIGH` — Address `0x0602`

**Reset value:** `0x00`  **Access:** see fields below

Flash address high word [23:16]

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADDR_HIGH` | `[7:0]` | RW | `0x00` | Flash address bits [23:16] |

---
### `FLASH_DATA` — Address `0x0603`

**Reset value:** `0x0000`  **Access:** see fields below

Flash read/write data

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA` | `[15:0]` | RW | `0x0000` | 16-bit data word |

---
### `FLASH_STATUS` — Address `0x0604`

**Reset value:** `0x01`  **Access:** see fields below

Flash operation status

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READY` | `[0]` | RO | `0x1` | Flash ready for operations |
| `WRITE_ERR` | `[1]` | RC | `0x0` | Write/program error |
| `ERASE_ERR` | `[2]` | RC | `0x0` | Erase error |

---
### `RF_VGA_GAIN` — Address `0x0700`

**Reset value:** `0x20`  **Access:** see fields below

HMC698LP4 VGA gain control (6-bit SPI)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GAIN_CODE` | `[5:0]` | RW | `0x20` | 6-bit gain code (0-63, 31.5dB range, 0.5dB/step) |

---
### `RF_CTRL` — Address `0x0701`

**Reset value:** `0x80`  **Access:** see fields below

RF front-end control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LNA_ENABLE` | `[0]` | RW | `0x0` | LNA enable (HMC1119LP4DE) |
| `VGA_ENABLE` | `[1]` | RW | `0x0` | VGA enable (HMC698LP4) |
| `MIXER_ENABLE` | `[2]` | RW | `0x0` | Mixer enable (HMC1051LP4BE) |
| `RF_POWER_DOWN` | `[7]` | RW | `0x1` | RF chain power-down (1=PD) |

---
### `RF_STATUS` — Address `0x0702`

**Reset value:** `0x00`  **Access:** see fields below

RF front-end status

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LNA_OK` | `[0]` | RO | `0x0` | LNA powered/operational |
| `VGA_OK` | `[1]` | RO | `0x0` | VGA powered/operational |
| `MIXER_OK` | `[2]` | RO | `0x0` | Mixer powered/operational |

---
### `AGC_CONFIG` — Address `0x0708`

**Reset value:** `0x80`  **Access:** see fields below

Automatic Gain Control configuration

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0x0` | AGC enable |
| `TARGET_LEVEL` | `[7:4]` | RW | `0x8` | Target ADC level (4-bit) |

---
### `GPIO_DIR` — Address `0x0800`

**Reset value:** `0x00`  **Access:** see fields below

GPIO direction control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GPIO_DIR` | `[7:0]` | RW | `0x00` | 0=input, 1=output |

---
### `GPIO_DATA` — Address `0x0801`

**Reset value:** `0x00`  **Access:** see fields below

GPIO data write/read

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GPIO_OUT` | `[7:0]` | RW | `0x00` | GPIO output data |

---
### `GPIO_IN` — Address `0x0802`

**Reset value:** `0x00`  **Access:** see fields below

GPIO input read

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GPIO_IN` | `[7:0]` | RO | `0x00` | GPIO input data |

---
### `GPIO_IRQ` — Address `0x0803`

**Reset value:** `0x00`  **Access:** see fields below

GPIO interrupt flags

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `IRQ_FLAGS` | `[7:0]` | RC | `0x00` | Interrupt flags (1=pending) |

---
### `SYSTEM_RESET` — Address `0x0900`

**Reset value:** `0x00`  **Access:** see fields below

System reset control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `RESET_FPGA` | `[0]` | RW | `0x0` | FPGA logic reset (self-clearing) |
| `RESET_RF` | `[1]` | RW | `0x0` | RF chain reset |
| `RESET_ADC` | `[2]` | RW | `0x0` | ADC interface reset |
| `GLOBAL_RESET` | `[7]` | RW | `0x0` | Global system reset (self-clearing) |

---
### `I2C_CTRL` — Address `0x0A00`

**Reset value:** `0x00`  **Access:** see fields below

I2C master control (LTC2975, LMK04828)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0x0` | I2C master enable |
| `START` | `[1]` | RW | `0x0` | Generate START condition |
| `STOP` | `[2]` | RW | `0x0` | Generate STOP condition |
| `RW_BIT` | `[3]` | RW | `0x0` | R/W bit (0=write, 1=read) |

---
### `I2C_STATUS` — Address `0x0A01`

**Reset value:** `0x00`  **Access:** see fields below

I2C master status

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BUSY` | `[0]` | RO | `0x0` | I2C bus busy |
| `ACK` | `[1]` | RO | `0x0` | Received ACK (1=ACK) |
| `ARB_LOST` | `[2]` | RC | `0x0` | Arbitration lost |

---
### `I2C_TXRX` — Address `0x0A02`

**Reset value:** `0x00`  **Access:** see fields below

I2C transmit/receive data

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA` | `[7:0]` | RW | `0x00` | Transmit or received byte |
