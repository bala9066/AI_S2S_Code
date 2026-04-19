# Register Description Table (RDT)
## dgh

> **Total registers:** 50

Complete register map and programming sequence for dgh radar RF front-end receiver board featuring 4-channel RF operation in 5-18 GHz band. Includes board information, communication interfaces (UART, Ethernet), ADC monitoring for power rails, temperature sensors, PLL clock generation, EEPROM and Flash storage, GPIO control, and 4-channel DACs. Programming sequence follows proper hardware dependency order with 23 initialization steps covering power-on verification, PLL configuration, peripheral enable, communication setup, and RF initialization.

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
| `0x0000` | `BOARD_ID` | — | `0xDEAD` | Board identification code |
| `0x0001` | `BOARD_VERSION` | — | `0x01` | Hardware version |
| `0x0002` | `BOARD_TYPE_ID` | — | `0x0001` | Board type identifier |
| `0x0003` | `SCRATCHPAD` | — | `0x0000` | Read/write test register |
| `0x0010` | `MCS_VERSION_MAJOR` | — | `0x02` | FPGA firmware major version |
| `0x0011` | `MCS_VERSION_MINOR` | — | `0x01` | FPGA firmware minor version |
| `0x0012` | `BUILD_DATE` | — | `0x260419` | Build date (YYYYMMDD packed BCD) |
| `0x0013` | `RF_SELECT` | — | `0x0000` | RF channel selection |
| `0x0014` | `RF_LNA_GAIN` | — | `0x0A` | LNA gain control |
| `0x0015` | `RF_BIAS_CTRL` | — | `0x0000` | RF bias control |
| `0x0100` | `UART_BAUD_DIV` | — | `0x003C` | Baud rate divisor |
| `0x0101` | `UART_CTRL` | — | `0x00` | UART control |
| `0x0102` | `UART_STATUS` | — | `0x00` | UART status |
| `0x0103` | `UART_TX_COUNT` | — | `0x00` | TX FIFO byte count |
| `0x0104` | `UART_RX_COUNT` | — | `0x00` | RX FIFO byte count |
| `0x0110` | `ETH_MAC_LOW` | — | `0x0000` | Ethernet MAC address low |
| `0x0111` | `ETH_MAC_HIGH` | — | `0x0000` | Ethernet MAC address high |
| `0x0200` | `ADC_CTRL` | — | `0x0000` | ADC control |
| `0x0201` | `ADC_STATUS` | — | `0x00` | ADC status |
| `0x0210` | `VCC_5V_RAW` | — | `0x0000` | 5V rail ADC count |
| `0x0211` | `VCC_3V3_RAW` | — | `0x0000` | 3.3V rail ADC count |
| `0x0212` | `VCC_2V5_RAW` | — | `0x0000` | 2.5V rail ADC count |
| `0x0213` | `VCC_1V8_RAW` | — | `0x0000` | 1.8V rail ADC count |
| `0x0218` | `ICC_5V_RAW` | — | `0x0000` | 5V rail current ADC count |
| `0x0219` | `ICC_3V3_RAW` | — | `0x0000` | 3.3V rail current ADC count |
| `0x0300` | `TEMP_LOCAL` | — | `0x0000` | Local FPGA die temperature |
| `0x0301` | `TEMP_REMOTE1` | — | `0x0000` | Remote sensor 1 temperature |
| `0x0302` | `TEMP_REMOTE2` | — | `0x0000` | Remote sensor 2 temperature |
| `0x0308` | `TEMP_ALERT_HIGH` | — | `0x0190` | Over-temperature alert threshold |
| `0x0309` | `TEMP_ALERT_LOW` | — | `0xFF9C` | Under-temperature alert threshold |
| `0x030F` | `HEALTH_STATUS` | — | `0x00` | System health |
| `0x0400` | `PLL_CTRL` | — | `x0000` | PLL control |
| `0x0401` | `PLL_STATUS` | — | `0x00` | PLL status |
| `0x0402` | `PLL_N_DIV` | — | `0x0064` | N divider |
| `0x0403` | `PLL_R_DIV` | — | `0x0004` | R divider |
| `0x0410` | `CLK_ENABLE` | — | `0x00` | Clock output enables |
| `0x0500` | `EEPROM_CTRL` | — | `0x00` | EEPROM control |
| `0x0501` | `EEPROM_ADDR` | — | `0x0000` | EEPROM byte address |
| `0x0502` | `EEPROM_DATA` | — | `0x0000` | EEPROM read/write data |
| `0x0600` | `FLASH_CTRL` | — | `0x00` | Flash control |
| `0x0601` | `FLASH_ADDR_LOW` | — | `0x0000` | Flash address low |
| `0x0602` | `FLASH_ADDR_HIGH` | — | `0x00` | Flash address high |
| `0x0603` | `FLASH_DATA` | — | `0x0000` | Flash read/write data FIFO |
| `0x0604` | `FLASH_STATUS` | — | `0x00` | Flash status |
| `0x0800` | `GPIO_CTRL` | — | `0x0000` | GPIO control |
| `0x0900` | `DAC_CH1` | — | `0x0000` | Channel 1 DAC value |
| `0x0901` | `DAC_CH2` | — | `0x0000` | Channel 2 DAC value |
| `0x0902` | `DAC_CH3` | — | `0x0000` | Channel 3 DAC value |
| `0x0903` | `DAC_CH4` | — | `0x0000` | Channel 4 DAC value |
| `0x0904` | `RF_FILTER_SELECT` | — | `0x0000` | RF filter band selection |

---
### `BOARD_ID` — Address `0x0000`

**Reset value:** `0xDEAD`  **Access:** see fields below

Board identification code

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BOARD_ID` | `[15:0]` | R | `0xDEAD` | Board ID (0xDEAD for dgh radar board) |

---
### `BOARD_VERSION` — Address `0x0001`

**Reset value:** `0x01`  **Access:** see fields below

Hardware version

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAJOR` | `[7:4]` | R | `0x1` | Major version number |
| `MINOR` | `[3:0]` | R | `0x0` | Minor version number |

---
### `BOARD_TYPE_ID` — Address `0x0002`

**Reset value:** `0x0001`  **Access:** see fields below

Board type identifier

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TYPE_ID` | `[15:0]` | R | `0x0001` | 0x0001 = RF Front-end Receiver |

---
### `SCRATCHPAD` — Address `0x0003`

**Reset value:** `0x0000`  **Access:** see fields below

Read/write test register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA` | `[15:0]` | RW | `0x0000` | Test data for RAM verification |

---
### `MCS_VERSION_MAJOR` — Address `0x0010`

**Reset value:** `0x02`  **Access:** see fields below

FPGA firmware major version

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `VERSION` | `[7:0]` | R | `0x02` | Major version of FPGA firmware |

---
### `MCS_VERSION_MINOR` — Address `0x0011`

**Reset value:** `0x01`  **Access:** see fields below

FPGA firmware minor version

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `VERSION` | `[7:0]` | R | `0x01` | Minor version of FPGA firmware |

---
### `BUILD_DATE` — Address `0x0012`

**Reset value:** `0x260419`  **Access:** see fields below

Build date (YYYYMMDD packed BCD)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATE` | `[15:0]` | R | `0x260419` | Build date in BCD format |

---
### `RF_SELECT` — Address `0x0013`

**Reset value:** `0x0000`  **Access:** see fields below

RF channel selection

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `CHAN_SEL` | `[1:0]` | RW | `0x0` | Channel select: 00=Chan1, 01=Chan2, 10=Chan3, 11=Chan4 |
| `EN_1` | `[2]` | RW | `0x0` | Enable channel 1 |
| `EN_2` | `[3]` | RW | `0x0` | Enable channel 2 |
| `EN_3` | `[4]` | RW | `0x0` | Enable channel 3 |
| `EN_4` | `[5]` | RW | `0x0` | Enable channel 4 |

---
### `RF_LNA_GAIN` — Address `0x0014`

**Reset value:** `0x0A`  **Access:** see fields below

LNA gain control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GAIN` | `[4:0]` | RW | `0x0A` | LNA gain setting (0-31) |

---
### `RF_BIAS_CTRL` — Address `0x0015`

**Reset value:** `0x0000`  **Access:** see fields below

RF bias control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `U1_BIAS` | `[0]` | RW | `0x0` | Limiter bias control |
| `U2_BIAS` | `[1]` | RW | `0x0` | SAW filter bias |
| `U3_BIAS` | `[2]` | RW | `0x0` | GaN HEMT bias |
| `U4_BIAS` | `[3]` | RW | `0x0` | LNA driver bias |
| `U5_BIAS` | `[4]` | RW | `0x0` | Output buffer bias |

---
### `UART_BAUD_DIV` — Address `0x0100`

**Reset value:** `0x003C`  **Access:** see fields below

Baud rate divisor

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DIVISOR` | `[15:0]` | RW | `0x003C` | UART baud rate divisor |

---
### `UART_CTRL` — Address `0x0101`

**Reset value:** `0x00`  **Access:** see fields below

UART control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0x0` | UART enable |
| `LOOPBACK` | `[1]` | RW | `0x0` | Loopback mode |
| `FRAME_FORMAT` | `[7:4]` | RW | `0x8` | Frame format: 1000=8N1, 1001=8O1, etc |

---
### `UART_STATUS` — Address `0x0102`

**Reset value:** `0x00`  **Access:** see fields below

UART status

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TX_BUSY` | `[0]` | RC | `0x0` | Transmitter busy |
| `RX_AVAIL` | `[1]` | RC | `0x0` | Data available |
| `FRAME_ERR` | `[2]` | RC | `0x0` | Frame error |

---
### `UART_TX_COUNT` — Address `0x0103`

**Reset value:** `0x00`  **Access:** see fields below

TX FIFO byte count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `COUNT` | `[7:0]` | R | `0x00` | Bytes in TX FIFO |

---
### `UART_RX_COUNT` — Address `0x0104`

**Reset value:** `0x00`  **Access:** see fields below

RX FIFO byte count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `COUNT` | `[7:0]` | R | `0x00` | Bytes in RX FIFO |

---
### `ETH_MAC_LOW` — Address `0x0110`

**Reset value:** `0x0000`  **Access:** see fields below

Ethernet MAC address low

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAC_LO` | `[15:0]` | R | `0x0000` | Lower 16 bits of MAC |

---
### `ETH_MAC_HIGH` — Address `0x0111`

**Reset value:** `0x0000`  **Access:** see fields below

Ethernet MAC address high

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAC_HI` | `[15:0]` | R | `0x0000` | Upper 16 bits of MAC |

---
### `ADC_CTRL` — Address `0x0200`

**Reset value:** `0x0000`  **Access:** see fields below

ADC control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `START` | `[0]` | RW | `0x0` | Start conversion |
| `CONTINUOUS` | `[1]` | RW | `0x0` | Continuous mode |
| `CHANNEL` | `[3:2]` | RW | `0x0` | Channel select |

---
### `ADC_STATUS` — Address `0x0201`

**Reset value:** `0x00`  **Access:** see fields below

ADC status

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
| `ADC_COUNT` | `[11:0]` | R | `0x0000` | Raw ADC count (V * 4096 / 5.0) |

---
### `VCC_3V3_RAW` — Address `0x0211`

**Reset value:** `0x0000`  **Access:** see fields below

3.3V rail ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | R | `0x0000` | Raw ADC count (V * 4096 / 3.3) |

---
### `VCC_2V5_RAW` — Address `0x0212`

**Reset value:** `0x0000`  **Access:** see fields below

2.5V rail ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | R | `0x0000` | Raw ADC count (V * 4096 / 2.5) |

---
### `VCC_1V8_RAW` — Address `0x0213`

**Reset value:** `0x0000`  **Access:** see fields below

1.8V rail ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | R | `0x0000` | Raw ADC count (V * 4096 / 1.8) |

---
### `ICC_5V_RAW` — Address `0x0218`

**Reset value:** `0x0000`  **Access:** see fields below

5V rail current ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | R | `0x0000` | Current measurement (mA * 4096 / 5.0) |

---
### `ICC_3V3_RAW` — Address `0x0219`

**Reset value:** `0x0000`  **Access:** see fields below

3.3V rail current ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | R | `0x0000` | Current measurement (mA * 4096 / 3.3) |

---
### `TEMP_LOCAL` — Address `0x0300`

**Reset value:** `0x0000`  **Access:** see fields below

Local FPGA die temperature

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP` | `[9:0]` | R | `0x0000` | Temperature in 0.25°C units (signed) |

---
### `TEMP_REMOTE1` — Address `0x0301`

**Reset value:** `0x0000`  **Access:** see fields below

Remote sensor 1 temperature

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP` | `[9:0]` | R | `0x0000` | Temperature in 0.25°C units (signed) |

---
### `TEMP_REMOTE2` — Address `0x0302`

**Reset value:** `0x0000`  **Access:** see fields below

Remote sensor 2 temperature

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP` | `[9:0]` | R | `0x0000` | Temperature in 0.25°C units (signed) |

---
### `TEMP_ALERT_HIGH` — Address `0x0308`

**Reset value:** `0x0190`  **Access:** see fields below

Over-temperature alert threshold

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `THRESHOLD` | `[9:0]` | RW | `0x0190` | Over-temperature threshold (100°C default) |

---
### `TEMP_ALERT_LOW` — Address `0x0309`

**Reset value:** `0xFF9C`  **Access:** see fields below

Under-temperature alert threshold

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `THRESHOLD` | `[9:0]` | RW | `0xFF9C` | Under-temperature threshold (-25°C default) |

---
### `HEALTH_STATUS` — Address `0x030F`

**Reset value:** `0x00`  **Access:** see fields below

System health

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_OK` | `[0]` | R | `0x0` | Temperature status |
| `VOLT_OK` | `[1]` | R | `0x0` | Voltage status |
| `PLL_LOCK` | `[2]` | R | `0x0` | PLL lock status |
| `SYSTEM_OK` | `[7]` | R | `0x0` | System OK status |

---
### `PLL_CTRL` — Address `0x0400`

**Reset value:** `x0000`  **Access:** see fields below

PLL control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0x0` | PLL enable |
| `RESET` | `[1]` | RW | `0x0` | PLL reset |
| `REF_SEL` | `[3:2]` | RW | `0x0` | Reference clock select |

---
### `PLL_STATUS` — Address `0x0401`

**Reset value:** `0x00`  **Access:** see fields below

PLL status

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LOCKED` | `[0]` | RC | `0x0` | PLL locked |
| `LOSS_OF_LOCK` | `[1]` | RC | `0x0` | Loss of lock |

---
### `PLL_N_DIV` — Address `0x0402`

**Reset value:** `0x0064`  **Access:** see fields below

N divider

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `N_DIV` | `[15:0]` | RW | `0x0064` | N divider value |

---
### `PLL_R_DIV` — Address `0x0403`

**Reset value:** `0x0004`  **Access:** see fields below

R divider

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `R_DIV` | `[7:0]` | RW | `0x0004` | R divider value |

---
### `CLK_ENABLE` — Address `0x0410`

**Reset value:** `0x00`  **Access:** see fields below

Clock output enables

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `CLK_EN` | `[7:0]` | RW | `0x00` | Enable clock outputs |

---
### `EEPROM_CTRL` — Address `0x0500`

**Reset value:** `0x00`  **Access:** see fields below

EEPROM control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READ` | `[0]` | RW | `0x0` | Read command |
| `WRITE` | `[1]` | RW | `0x0` | Write command |
| `ERASE` | `[2]` | RW | `0x0` | Erase command |
| `BUSY` | `[7]` | R | `0x0` | Busy flag |

---
### `EEPROM_ADDR` — Address `0x0501`

**Reset value:** `0x0000`  **Access:** see fields below

EEPROM byte address

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADDR` | `[15:0]` | RW | `0x0000` | EEPROM address |

---
### `EEPROM_DATA` — Address `0x0502`

**Reset value:** `0x0000`  **Access:** see fields below

EEPROM read/write data

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA` | `[15:0]` | RW | `0x0000` | EEPROM data |

---
### `FLASH_CTRL` — Address `0x0600`

**Reset value:** `0x00`  **Access:** see fields below

Flash control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READ` | `[0]` | RW | `0x0` | Read command |
| `WRITE` | `[1]` | RW | `0x0` | Write command |
| `ERASE_SECTOR` | `[2]` | RW | `0x0` | Erase sector command |
| `ERASE_CHIP` | `[3]` | RW | `0x0` | Erase chip command |
| `BUSY` | `[7]` | R | `0x0` | Busy flag |

---
### `FLASH_ADDR_LOW` — Address `0x0601`

**Reset value:** `0x0000`  **Access:** see fields below

Flash address low

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADDR` | `[15:0]` | RW | `0x0000` | Lower 16 bits of flash address |

---
### `FLASH_ADDR_HIGH` — Address `0x0602`

**Reset value:** `0x00`  **Access:** see fields below

Flash address high

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADDR` | `[7:0]` | RW | `0x00` | Upper 8 bits of flash address |

---
### `FLASH_DATA` — Address `0x0603`

**Reset value:** `0x0000`  **Access:** see fields below

Flash read/write data FIFO

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA` | `[15:0]` | RW | `0x0000` | Flash data FIFO |

---
### `FLASH_STATUS` — Address `0x0604`

**Reset value:** `0x00`  **Access:** see fields below

Flash status

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READY` | `[0]` | RC | `0x0` | Flash ready |
| `WRITE_ERR` | `[1]` | RC | `0x0` | Write error |
| `ERASE_ERR` | `[2]` | RC | `0x0` | Erase error |

---
### `GPIO_CTRL` — Address `0x0800`

**Reset value:** `0x0000`  **Access:** see fields below

GPIO control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DIR` | `[15:8]` | RW | `0x00` | Direction (1=output, 0=input) |
| `DATA` | `[7:0]` | RW | `0x00` | GPIO data |

---
### `DAC_CH1` — Address `0x0900`

**Reset value:** `0x0000`  **Access:** see fields below

Channel 1 DAC value

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `VALUE` | `[11:0]` | W | `0x0000` | Channel 1 DAC value (0-4095) |

---
### `DAC_CH2` — Address `0x0901`

**Reset value:** `0x0000`  **Access:** see fields below

Channel 2 DAC value

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `VALUE` | `[11:0]` | W | `0x0000` | Channel 2 DAC value (0-4095) |

---
### `DAC_CH3` — Address `0x0902`

**Reset value:** `0x0000`  **Access:** see fields below

Channel 3 DAC value

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `VALUE` | `[11:0]` | W | `0x0000` | Channel 3 DAC value (0-4095) |

---
### `DAC_CH4` — Address `0x0903`

**Reset value:** `0x0000`  **Access:** see fields below

Channel 4 DAC value

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `VALUE` | `[11:0]` | W | `0x0000` | Channel 4 DAC value (0-4095) |

---
### `RF_FILTER_SELECT` — Address `0x0904`

**Reset value:** `0x0000`  **Access:** see fields below

RF filter band selection

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BAND` | `[3:0]` | RW | `0x0` | Band selection (0-15 for 5-18 GHz) |
| `FILTER_EN` | `[4]` | RW | `0x0` | Filter enable |
