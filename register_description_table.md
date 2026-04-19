# Register Description Table (RDT)
## gvng

> **Total registers:** 42

gvng project register map with comprehensive initialization sequence. The design includes 36 memory-mapped registers covering all major functional groups: Board Information, Communication, ADC/Sensing, Temperature Monitoring, PLL/Clock Management, EEPROM Storage, Flash Configuration, GPIO Control, RF Control, and DAC Output. The programming sequence follows a structured 5-phase approach: Power-On Reset & Self-Check, PLL & Clock Initialization, Peripheral Enable, Communication Setup, and Application Initialization. All registers include proper reset values and field descriptions for comprehensive firmware development.

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
| `0x0000` | `BOARD_ID` | — | `0x5756` | Board identification code |
| `0x0001` | `BOARD_VERSION` | — | `0x01` | Hardware version information |
| `0x0002` | `BOARD_TYPE_ID` | — | `0x0001` | Board type identifier |
| `0x0003` | `SCRATCHPAD` | — | `0x0000` | Read/write test register |
| `0x0010` | `MCS_VERSION_MAJOR` | — | `0x01` | FPGA firmware major version |
| `0x0011` | `MCS_VERSION_MINOR` | — | `0x02` | FPGA firmware minor version |
| `0x0012` | `BUILD_DATE` | — | `0x230115` | Build date (YYYYMMDD packed BCD) |
| `0x0100` | `UART_BAUD_DIV` | — | `0x0096` | UART baud rate divisor |
| `0x0101` | `UART_CTRL` | — | `0x00` | UART control register |
| `0x0102` | `UART_STATUS` | — | `0x00` | UART status register |
| `0x0103` | `UART_TX_COUNT` | — | `0x00` | TX FIFO byte count |
| `0x0104` | `UART_RX_COUNT` | — | `0x00` | RX FIFO byte count |
| `0x0110` | `ETH_MAC_LOW` | — | `0x1234` | Ethernet MAC address (low) |
| `0x0111` | `ETH_MAC_HIGH` | — | `0x5678` | Ethernet MAC address (high) |
| `0x0200` | `ADC_CTRL` | — | `0x00` | ADC control register |
| `0x0201` | `ADC_STATUS` | — | `0x00` | ADC status register |
| `0x0210` | `VCC_5V_RAW` | — | `0x0000` | 5V rail ADC count |
| `0x0211` | `VCC_3V3_RAW` | — | `0x0000` | 3.3V rail ADC count |
| `0x0300` | `TEMP_LOCAL` | — | `0x01F4` | Local FPGA die temperature |
| `0x0301` | `TEMP_REMOTE1` | — | `0x01E0` | Remote sensor 1 temperature |
| `0x0302` | `TEMP_REMOTE2` | — | `0x01D8` | Remote sensor 2 temperature |
| `0x0308` | `TEMP_ALERT_HIGH` | — | `0x0190` | Over-temperature alert threshold |
| `0x0309` | `TEMP_ALERT_LOW` | — | `0xFF9C` | Under-temperature alert threshold |
| `0x030F` | `HEALTH_STATUS` | — | `0x00` | System health status |
| `0x0400` | `PLL_CTRL` | — | `0x00` | PLL control register |
| `0x0401` | `PLL_STATUS` | — | `0x00` | PLL status register |
| `0x0402` | `PLL_N_DIV` | — | `0x0200` | PLL N divider |
| `0x0403` | `PLL_R_DIV` | — | `0x02` | PLL R divider |
| `0x0410` | `CLK_ENABLE` | — | `0x00` | Clock output enables |
| `0x0500` | `EEPROM_CTRL` | — | `0x00` | EEPROM control register |
| `0x0501` | `EEPROM_ADDR` | — | `0x0000` | EEPROM address |
| `0x0502` | `EEPROM_DATA` | — | `0x0000` | EEPROM data |
| `0x0600` | `FLASH_CTRL` | — | `0x00` | Flash control register |
| `0x0601` | `FLASH_ADDR_LOW` | — | `0x0000` | Flash address (low) |
| `0x0602` | `FLASH_ADDR_HIGH` | — | `0x00` | Flash address (high) |
| `0x0603` | `FLASH_DATA` | — | `0x0000` | Flash data |
| `0x0604` | `FLASH_STATUS` | — | `0x00` | Flash status register |
| `0x8000` | `GPIO_CTRL` | — | `0x0000` | GPIO control register |
| `0x8001` | `GPIO_DATA` | — | `0x0000` | GPIO data register |
| `0x9000` | `DAC_CTRL` | — | `0x00` | DAC control register |
| `0x9001` | `DAC_DATA` | — | `0x0000` | DAC data register |
| `0x7000` | `RF_CTRL` | — | `0x0000` | RF control register |

---
### `BOARD_ID` — Address `0x0000`

**Reset value:** `0x5756`  **Access:** see fields below

Board identification code

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BOARD_ID` | `[15:0]` | R | `0x5756` | Board identifier - fixed value |

---
### `BOARD_VERSION` — Address `0x0001`

**Reset value:** `0x01`  **Access:** see fields below

Hardware version information

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAJOR` | `[7:4]` | R | `0x0` | Major version number |
| `MINOR` | `[3:0]` | R | `0x1` | Minor version number |

---
### `BOARD_TYPE_ID` — Address `0x0002`

**Reset value:** `0x0001`  **Access:** see fields below

Board type identifier

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TYPE_ID` | `[15:0]` | R | `0x0001` | Board type identifier |

---
### `SCRATCHPAD` — Address `0x0003`

**Reset value:** `0x0000`  **Access:** see fields below

Read/write test register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA` | `[15:0]` | RW | `0x0000` | Test data |

---
### `MCS_VERSION_MAJOR` — Address `0x0010`

**Reset value:** `0x01`  **Access:** see fields below

FPGA firmware major version

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAJOR` | `[7:0]` | R | `0x01` | Firmware major version |

---
### `MCS_VERSION_MINOR` — Address `0x0011`

**Reset value:** `0x02`  **Access:** see fields below

FPGA firmware minor version

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MINOR` | `[7:0]` | R | `0x02` | Firmware minor version |

---
### `BUILD_DATE` — Address `0x0012`

**Reset value:** `0x230115`  **Access:** see fields below

Build date (YYYYMMDD packed BCD)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATE` | `[15:0]` | R | `0x230115` | Build date as packed BCD |

---
### `UART_BAUD_DIV` — Address `0x0100`

**Reset value:** `0x0096`  **Access:** see fields below

UART baud rate divisor

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DIVISOR` | `[15:0]` | RW | `0x0096` | Baud rate divisor (50MHz clock) |

---
### `UART_CTRL` — Address `0x0101`

**Reset value:** `0x00`  **Access:** see fields below

UART control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0x0` | UART enable |
| `LOOPBACK` | `[1]` | RW | `0x0` | Internal loopback |
| `FRAME_FMT` | `[7:4]` | RW | `0x0` | Frame format (0=8N1) |

---
### `UART_STATUS` — Address `0x0102`

**Reset value:** `0x00`  **Access:** see fields below

UART status register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TX_BUSY` | `[0]` | RC | `0x0` | TX busy flag |
| `RX_AVAIL` | `[1]` | RC | `0x0` | RX data available |
| `FRAME_ERR` | `[2]` | RC | `0x0` | Frame error flag |

---
### `UART_TX_COUNT` — Address `0x0103`

**Reset value:** `0x00`  **Access:** see fields below

TX FIFO byte count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `COUNT` | `[7:0]` | R | `0x00` | Number of bytes in TX FIFO |

---
### `UART_RX_COUNT` — Address `0x0104`

**Reset value:** `0x00`  **Access:** see fields below

RX FIFO byte count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `COUNT` | `[7:0]` | R | `0x00` | Number of bytes in RX FIFO |

---
### `ETH_MAC_LOW` — Address `0x0110`

**Reset value:** `0x1234`  **Access:** see fields below

Ethernet MAC address (low)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAC_L` | `[15:0]` | R | `0x1234` | Low 16 bits of MAC address |

---
### `ETH_MAC_HIGH` — Address `0x0111`

**Reset value:** `0x5678`  **Access:** see fields below

Ethernet MAC address (high)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAC_H` | `[15:0]` | R | `0x5678` | High 16 bits of MAC address |

---
### `ADC_CTRL` — Address `0x0200`

**Reset value:** `0x00`  **Access:** see fields below

ADC control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `START` | `[0]` | RW | `0x0` | Start ADC conversion |
| `CONTINUOUS` | `[1]` | RW | `0x0` | Continuous conversion mode |
| `CHANNEL` | `[3:2]` | RW | `0x0` | Channel select |

---
### `ADC_STATUS` — Address `0x0201`

**Reset value:** `0x00`  **Access:** see fields below

ADC status register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA_READY` | `[0]` | RC | `0x0` | Data ready flag |
| `OVERRANGE` | `[1]` | RC | `0x0` | Over-range error |

---
### `VCC_5V_RAW` — Address `0x0210`

**Reset value:** `0x0000`  **Access:** see fields below

5V rail ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `RAW` | `[11:0]` | R | `0x000` | ADC raw count (5V rail) |

---
### `VCC_3V3_RAW` — Address `0x0211`

**Reset value:** `0x0000`  **Access:** see fields below

3.3V rail ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `RAW` | `[11:0]` | R | `0x000` | ADC raw count (3.3V rail) |

---
### `TEMP_LOCAL` — Address `0x0300`

**Reset value:** `0x01F4`  **Access:** see fields below

Local FPGA die temperature

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP` | `[9:0]` | R | `0x1F4` | Temperature in 0.25°C units |

---
### `TEMP_REMOTE1` — Address `0x0301`

**Reset value:** `0x01E0`  **Access:** see fields below

Remote sensor 1 temperature

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP` | `[9:0]` | R | `0x1E0` | Remote 1 temperature in 0.25°C units |

---
### `TEMP_REMOTE2` — Address `0x0302`

**Reset value:** `0x01D8`  **Access:** see fields below

Remote sensor 2 temperature

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP` | `[9:0]` | R | `0x1D8` | Remote 2 temperature in 0.25°C units |

---
### `TEMP_ALERT_HIGH` — Address `0x0308`

**Reset value:** `0x0190`  **Access:** see fields below

Over-temperature alert threshold

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `THRESHOLD` | `[9:0]` | RW | `0x190` | High temperature threshold in 0.25°C units |

---
### `TEMP_ALERT_LOW` — Address `0x0309`

**Reset value:** `0xFF9C`  **Access:** see fields below

Under-temperature alert threshold

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `THRESHOLD` | `[9:0]` | RW | `0xFF9C` | Low temperature threshold in 0.25°C units |

---
### `HEALTH_STATUS` — Address `0x030F`

**Reset value:** `0x00`  **Access:** see fields below

System health status

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_OK` | `[0]` | R | `0x0` | Temperature status (0=alert, 1=OK) |
| `VOLT_OK` | `[1]` | R | `0x0` | Voltage status (0=alert, 1=OK) |
| `PLL_LOCK` | `[2]` | R | `0x0` | PLL lock status (0=unlocked, 1=locked) |
| `SYSTEM_OK` | `[7]` | R | `0x0` | Overall system status (0=fail, 1=OK) |

---
### `PLL_CTRL` — Address `0x0400`

**Reset value:** `0x00`  **Access:** see fields below

PLL control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0x0` | PLL enable |
| `RESET` | `[1]` | RW | `0x0` | PLL reset |
| `REF_SEL` | `[3:2]` | RW | `0x0` | Reference clock select |

---
### `PLL_STATUS` — Address `0x0401`

**Reset value:** `0x00`  **Access:** see fields below

PLL status register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LOCKED` | `[0]` | RC | `0x0` | PLL lock status |
| `LOSS_OF_LOCK` | `[1]` | RC | `0x0` | Loss of lock flag |

---
### `PLL_N_DIV` — Address `0x0402`

**Reset value:** `0x0200`  **Access:** see fields below

PLL N divider

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DIV_N` | `[15:0]` | RW | `0x200` | N divider value |

---
### `PLL_R_DIV` — Address `0x0403`

**Reset value:** `0x02`  **Access:** see fields below

PLL R divider

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DIV_R` | `[7:0]` | RW | `0x02` | R divider value |

---
### `CLK_ENABLE` — Address `0x0410`

**Reset value:** `0x00`  **Access:** see fields below

Clock output enables

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `CLK_EN` | `[7:0]` | RW | `0x00` | Clock output enables (1 bit per output) |

---
### `EEPROM_CTRL` — Address `0x0500`

**Reset value:** `0x00`  **Access:** see fields below

EEPROM control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READ` | `[0]` | RW | `0x0` | Read operation |
| `WRITE` | `[1]` | RW | `0x0` | Write operation |
| `ERASE` | `[2]` | RW | `0x0` | Erase operation |
| `BUSY` | `[7]` | RO | `0x0` | Busy flag |

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
| `DATA` | `[15:0]` | RW | `0x0000` | EEPROM data |

---
### `FLASH_CTRL` — Address `0x0600`

**Reset value:** `0x00`  **Access:** see fields below

Flash control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READ` | `[0]` | RW | `0x0` | Read operation |
| `WRITE` | `[1]` | RW | `0x0` | Write operation |
| `ERASE_SECTOR` | `[2]` | RW | `0x0` | Erase sector operation |
| `ERASE_CHIP` | `[3]` | RW | `0x0` | Erase chip operation |
| `BUSY` | `[7]` | RO | `0x0` | Busy flag |

---
### `FLASH_ADDR_LOW` — Address `0x0601`

**Reset value:** `0x0000`  **Access:** see fields below

Flash address (low)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADDR_LOW` | `[15:0]` | RW | `0x0000` | Flash address [15:0] |

---
### `FLASH_ADDR_HIGH` — Address `0x0602`

**Reset value:** `0x00`  **Access:** see fields below

Flash address (high)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADDR_HIGH` | `[7:0]` | RW | `0x00` | Flash address [23:16] |

---
### `FLASH_DATA` — Address `0x0603`

**Reset value:** `0x0000`  **Access:** see fields below

Flash data

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA` | `[15:0]` | RW | `0x0000` | Flash read/write data |

---
### `FLASH_STATUS` — Address `0x0604`

**Reset value:** `0x00`  **Access:** see fields below

Flash status register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READY` | `[0]` | RC | `0x0` | Ready flag |
| `WRITE_ERR` | `[1]` | RC | `0x0` | Write error flag |
| `ERASE_ERR` | `[2]` | RC | `0x0` | Erase error flag |

---
### `GPIO_CTRL` — Address `0x8000`

**Reset value:** `0x0000`  **Access:** see fields below

GPIO control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DIR` | `[15:0]` | RW | `0x0000` | GPIO direction (1=out, 0=in) |

---
### `GPIO_DATA` — Address `0x8001`

**Reset value:** `0x0000`  **Access:** see fields below

GPIO data register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA` | `[15:0]` | RW | `0x0000` | GPIO data (1=high, 0=low) |

---
### `DAC_CTRL` — Address `0x9000`

**Reset value:** `0x00`  **Access:** see fields below

DAC control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DAC_EN` | `[0]` | RW | `0x0` | DAC enable |
| `RANGE` | `[1]` | RW | `0x0` | DAC range (0=0-2.5V, 1=0-5V) |
| `CHANNEL` | `[3:2]` | RW | `0x0` | DAC channel select |

---
### `DAC_DATA` — Address `0x9001`

**Reset value:** `0x0000`  **Access:** see fields below

DAC data register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA` | `[11:0]` | RW | `0x000` | 12-bit DAC data |

---
### `RF_CTRL` — Address `0x7000`

**Reset value:** `0x0000`  **Access:** see fields below

RF control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `RF_EN` | `[0]` | RW | `0x0` | RF enable |
| `TX_EN` | `[1]` | RW | `0x0` | TX enable |
| `RX_EN` | `[2]` | RW | `0x0` | RX enable |
| `FREQ_SEL` | `[7:4]` | RW | `0x0` | Frequency band select |
