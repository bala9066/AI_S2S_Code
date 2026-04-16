# Register Description Table (RDT)
## dsf

> **Total registers:** 48

Register map for dsf 5-18 GHz Wideband RF Receiver. Groups: 0x000-Board Info, 0x100-Comm, 0x200-ADC, 0x300-Temp/Health, 0x400-PLL, 0x500-EEPROM, 0x600-Flash, 0x700-RF/VGA, 0x800-GPIO, 0x900-DAC. Total 35 registers covering ADC10DX300, LMX2594, HMC698LP2 VGA, power monitoring, JESD204B control, and system health.

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
| `0x0000` | `BOARD_ID` | — | `0x4453` | Board identification code - unique 16-bit ID for dsf receiver |
| `0x0001` | `BOARD_VERSION` | — | `0x01` | Hardware version number with major and minor revision |
| `0x0002` | `BOARD_TYPE_ID` | — | `0x5246` | Board type identifier |
| `0x0003` | `SCRATCHPAD` | — | `0x0000` | General purpose test register for RAM verification |
| `0x0010` | `MCS_VERSION_MAJOR` | — | `0x01` | FPGA firmware major version number |
| `0x0011` | `MCS_VERSION_MINOR` | — | `0x00` | FPGA firmware minor version number |
| `0x0012` | `BUILD_DATE` | — | `0x2641` | Firmware build date in packed BCD format (YYYYMMDD) |
| `0x0100` | `UART_BAUD_DIV` | — | `0x00B2` | UART baud rate divisor for 100MHz clock (100MHz/16/baud) |
| `0x0101` | `UART_CTRL` | — | `0x03` | UART control register |
| `0x0102` | `UART_STATUS` | — | `0x00` | UART status register (read-clear) |
| `0x0103` | `UART_TX_COUNT` | — | `0x00` | TX FIFO byte count |
| `0x0104` | `UART_RX_COUNT` | — | `0x00` | RX FIFO byte count |
| `0x0110` | `ETH_MAC_LOW` | — | `0x0000` | Ethernet MAC address low 16 bits |
| `0x0111` | `ETH_MAC_HIGH` | — | `0x0000` | Ethernet MAC address high 16 bits |
| `0x0200` | `ADC_CTRL` | — | `0x00` | ADC10DX300 control register |
| `0x0201` | `ADC_STATUS` | — | `0x00` | ADC status register |
| `0x0210` | `VCC_5V_RAW` | — | `0x0CCC` | 5V rail ADC count (12-bit) |
| `0x0211` | `VCC_3V3_RAW` | — | `0x0AAA` | 3.3V rail ADC count (12-bit) |
| `0x0213` | `VCC_1V8_RAW` | — | `0x0666` | 1.8V rail ADC count (12-bit) |
| `0x0218` | `ICC_5V_RAW` | — | `0x0000` | 5V rail current ADC count |
| `0x0219` | `ICC_3V3_RAW` | — | `0x0000` | 3.3V rail current ADC count |
| `0x0300` | `TEMP_LOCAL` | — | `0x0096` | Local FPGA die temperature in 0.25°C units (signed) |
| `0x0301` | `TEMP_REMOTE1` | — | `0x0082` | Remote sensor 1 temperature (ADC10DX300) |
| `0x0302` | `TEMP_REMOTE2` | — | `0x0078` | Remote sensor 2 temperature (LMX2594) |
| `0x0308` | `TEMP_ALERT_HIGH` | — | `0x0190` | Over-temperature alert threshold |
| `0x0309` | `TEMP_ALERT_LOW` | — | `0xFF9C` | Under-temperature alert threshold |
| `0x030F` | `HEALTH_STATUS` | — | `0x01` | System health status register |
| `0x0400` | `PLL_CTRL` | — | `0x00` | LMX2594 PLL control register |
| `0x0401` | `PLL_STATUS` | — | `0x00` | LMX2594 PLL status register |
| `0x0402` | `PLL_N_DIV` | — | `0x0064` | PLL N divider value |
| `0x0403` | `PLL_R_DIV` | — | `0x01` | PLL R divider value |
| `0x0410` | `CLK_ENABLE` | — | `0x02` | Clock output enables |
| `0x0500` | `EEPROM_CTRL` | — | `0x00` | EEPROM control register |
| `0x0501` | `EEPROM_ADDR` | — | `0x0000` | EEPROM byte address |
| `0x0502` | `EEPROM_DATA` | — | `0x0000` | EEPROM read/write data |
| `0x0600` | `FLASH_CTRL` | — | `0x00` | Configuration flash control |
| `0x0601` | `FLASH_ADDR_LOW` | — | `0x0000` | Flash address low word |
| `0x0602` | `FLASH_ADDR_HIGH` | — | `0x00` | Flash address high byte |
| `0x0603` | `FLASH_DATA` | — | `0x0000` | Flash read/write data FIFO |
| `0x0604` | `FLASH_STATUS` | — | `0x01` | Flash status register |
| `0x0700` | `RF_LO_FREQ_HIGH` | — | `0x09C4` | RF LO frequency high word (LMX2594) |
| `0x0701` | `RF_LO_FREQ_LOW` | — | `0x0000` | RF LO frequency low word |
| `0x0702` | `VGA_GAIN_CTRL` | — | `0x40` | HMC698LP2 VGA gain control |
| `0x0703` | `RF_STATUS` | — | `0x02` | RF front-end status |
| `0x0704` | `JESD204B_CTRL` | — | `0x04` | JESD204B interface control |
| `0x0705` | `JESD204B_STATUS` | — | `0x00` | JESD204B link status |
| `0x0800` | `GPIO_CTRL` | — | `0x00` | GPIO control register |
| `0x0801` | `GPIO_INPUT` | — | `0x00` | GPIO input read register |

---
### `BOARD_ID` — Address `0x0000`

**Reset value:** `0x4453`  **Access:** see fields below

Board identification code - unique 16-bit ID for dsf receiver

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BOARD_ID` | `[15:0]` | R | `0x4453` | ASCII 'DS' identifier for dsf project |

---
### `BOARD_VERSION` — Address `0x0001`

**Reset value:** `0x01`  **Access:** see fields below

Hardware version number with major and minor revision

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAJOR_REV` | `[7:4]` | R | `0x0` | Major hardware revision |
| `MINOR_REV` | `[3:0]` | R | `0x1` | Minor hardware revision |

---
### `BOARD_TYPE_ID` — Address `0x0002`

**Reset value:** `0x5246`  **Access:** see fields below

Board type identifier

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TYPE_ID` | `[15:0]` | R | `0x5246` | ASCII 'RF' receiver type code |

---
### `SCRATCHPAD` — Address `0x0003`

**Reset value:** `0x0000`  **Access:** see fields below

General purpose test register for RAM verification

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEST_DATA` | `[15:0]` | RW | `0x0000` | Read/write test pattern |

---
### `MCS_VERSION_MAJOR` — Address `0x0010`

**Reset value:** `0x01`  **Access:** see fields below

FPGA firmware major version number

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAJOR_VER` | `[7:0]` | R | `0x01` | Major firmware version |

---
### `MCS_VERSION_MINOR` — Address `0x0011`

**Reset value:** `0x00`  **Access:** see fields below

FPGA firmware minor version number

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MINOR_VER` | `[7:0]` | R | `0x00` | Minor firmware version |

---
### `BUILD_DATE` — Address `0x0012`

**Reset value:** `0x2641`  **Access:** see fields below

Firmware build date in packed BCD format (YYYYMMDD)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `YEAR` | `[15:12]` | R | `0x2` | Year digit 1 (BCD) |
| `YEAR` | `[11:8]` | R | `0x6` | Year digit 0 (BCD) |
| `MONTH` | `[7:4]` | R | `0x4` | Month (BCD) |
| `DAY` | `[3:0]` | R | `0x1` | Day (BCD) |

---
### `UART_BAUD_DIV` — Address `0x0100`

**Reset value:** `0x00B2`  **Access:** see fields below

UART baud rate divisor for 100MHz clock (100MHz/16/baud)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BAUD_DIV` | `[15:0]` | RW | `0x00B2` | Divisor for 115200 baud (100MHz/16/115200 = 54.25) |

---
### `UART_CTRL` — Address `0x0101`

**Reset value:** `0x03`  **Access:** see fields below

UART control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0x0` | UART enable: 1=enabled |
| `LOOPBACK` | `[1]` | RW | `0x0` | Loopback mode for test |
| `FRAME_FORMAT` | `[7:4]` | RW | `0x3` | Frame format: 0x3=8N1 |

---
### `UART_STATUS` — Address `0x0102`

**Reset value:** `0x00`  **Access:** see fields below

UART status register (read-clear)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TX_BUSY` | `[0]` | RC | `0x0` | Transmitter busy flag |
| `RX_AVAIL` | `[1]` | RC | `0x0` | RX data available |
| `FRAME_ERR` | `[2]` | RC | `0x0` | Frame error detected |

---
### `UART_TX_COUNT` — Address `0x0103`

**Reset value:** `0x00`  **Access:** see fields below

TX FIFO byte count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TX_COUNT` | `[7:0]` | R | `0x00` | Number of bytes in TX FIFO |

---
### `UART_RX_COUNT` — Address `0x0104`

**Reset value:** `0x00`  **Access:** see fields below

RX FIFO byte count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `RX_COUNT` | `[7:0]` | R | `0x00` | Number of bytes in RX FIFO |

---
### `ETH_MAC_LOW` — Address `0x0110`

**Reset value:** `0x0000`  **Access:** see fields below

Ethernet MAC address low 16 bits

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAC_LOW` | `[15:0]` | R | `0x0000` | MAC address bits [15:0] |

---
### `ETH_MAC_HIGH` — Address `0x0111`

**Reset value:** `0x0000`  **Access:** see fields below

Ethernet MAC address high 16 bits

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAC_HIGH` | `[15:0]` | R | `0x0000` | MAC address bits [31:16] |

---
### `ADC_CTRL` — Address `0x0200`

**Reset value:** `0x00`  **Access:** see fields below

ADC10DX300 control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `START` | `[0]` | RW | `0x0` | Start ADC conversion |
| `CONTINUOUS` | `[1]` | RW | `0x0` | Continuous mode enable |
| `CHANNEL_SEL` | `[3:2]` | RW | `0x0` | Channel select (I/Q monitoring) |
| `JESD_ENABLE` | `[4]` | RW | `0x0` | JESD204B link enable |

---
### `ADC_STATUS` — Address `0x0201`

**Reset value:** `0x00`  **Access:** see fields below

ADC status register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA_READY` | `[0]` | RC | `0x0` | New data ready flag |
| `OVERRANGE` | `[1]` | RC | `0x0` | ADC input overrange detected |
| `JESD_LOCKED` | `[2]` | RC | `0x0` | JESD204B link locked |

---
### `VCC_5V_RAW` — Address `0x0210`

**Reset value:** `0x0CCC`  **Access:** see fields below

5V rail ADC count (12-bit)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_5V` | `[11:0]` | R | `0x0CCC` | 5V ADC count (multiply by 5.0/4096 for Volts) |

---
### `VCC_3V3_RAW` — Address `0x0211`

**Reset value:** `0x0AAA`  **Access:** see fields below

3.3V rail ADC count (12-bit)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_3V3` | `[11:0]` | R | `0x0AAA` | 3.3V ADC count |

---
### `VCC_1V8_RAW` — Address `0x0213`

**Reset value:** `0x0666`  **Access:** see fields below

1.8V rail ADC count (12-bit)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_1V8` | `[11:0]` | R | `0x0666` | 1.8V ADC count |

---
### `ICC_5V_RAW` — Address `0x0218`

**Reset value:** `0x0000`  **Access:** see fields below

5V rail current ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `CURRENT_5V` | `[11:0]` | R | `0x0000` | 5V current sense ADC count |

---
### `ICC_3V3_RAW` — Address `0x0219`

**Reset value:** `0x0000`  **Access:** see fields below

3.3V rail current ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `CURRENT_3V3` | `[11:0]` | R | `0x0000` | 3.3V current sense ADC count |

---
### `TEMP_LOCAL` — Address `0x0300`

**Reset value:** `0x0096`  **Access:** see fields below

Local FPGA die temperature in 0.25°C units (signed)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP` | `[9:0]` | R | `0x096` | Temperature = value * 0.25°C (0x096 = 60°C) |

---
### `TEMP_REMOTE1` — Address `0x0301`

**Reset value:** `0x0082`  **Access:** see fields below

Remote sensor 1 temperature (ADC10DX300)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_ADC` | `[9:0]` | R | `0x082` | ADC die temperature (0x082 = 52°C) |

---
### `TEMP_REMOTE2` — Address `0x0302`

**Reset value:** `0x0078`  **Access:** see fields below

Remote sensor 2 temperature (LMX2594)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_PLL` | `[9:0]` | R | `0x078` | PLL die temperature (0x078 = 48°C) |

---
### `TEMP_ALERT_HIGH` — Address `0x0308`

**Reset value:** `0x0190`  **Access:** see fields below

Over-temperature alert threshold

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ALERT_HI` | `[9:0]` | RW | `0x190` | Overtemp threshold (0x190 = 100°C) |

---
### `TEMP_ALERT_LOW` — Address `0x0309`

**Reset value:** `0xFF9C`  **Access:** see fields below

Under-temperature alert threshold

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ALERT_LO` | `[9:0]` | RW | `0xFF9C` | Undertemp threshold (0xFF9C = -25°C signed) |

---
### `HEALTH_STATUS` — Address `0x030F`

**Reset value:** `0x01`  **Access:** see fields below

System health status register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_OK` | `[0]` | R | `0x1` | Temperature OK flag |
| `VOLT_OK` | `[1]` | R | `0x0` | All voltage rails OK |
| `PLL_LOCK` | `[2]` | R | `0x0` | PLL lock status |
| `JESD204B_OK` | `[3]` | R | `0x0` | JESD204B link OK |
| `SYSTEM_OK` | `[7]` | R | `0x0` | Overall system health |

---
### `PLL_CTRL` — Address `0x0400`

**Reset value:** `0x00`  **Access:** see fields below

LMX2594 PLL control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0x0` | PLL enable |
| `RESET` | `[1]` | RW | `0x0` | PLL reset (active high) |
| `REF_SEL` | `[3:2]` | RW | `0x0` | Reference clock select |

---
### `PLL_STATUS` — Address `0x0401`

**Reset value:** `0x00`  **Access:** see fields below

LMX2594 PLL status register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LOCKED` | `[0]` | RC | `0x0` | PLL lock detected |
| `LOSS_OF_LOCK` | `[1]` | RC | `0x0` | Loss of lock flag |

---
### `PLL_N_DIV` — Address `0x0402`

**Reset value:** `0x0064`  **Access:** see fields below

PLL N divider value

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `N_DIV` | `[15:0]` | RW | `0x0064` | N divider (default = 100) |

---
### `PLL_R_DIV` — Address `0x0403`

**Reset value:** `0x01`  **Access:** see fields below

PLL R divider value

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `R_DIV` | `[7:0]` | RW | `0x01` | R divider (default = 1) |

---
### `CLK_ENABLE` — Address `0x0410`

**Reset value:** `0x02`  **Access:** see fields below

Clock output enables

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `CLK_ADC_EN` | `[0]` | RW | `0x0` | ADC sampling clock enable |
| `CLK_FPGA_EN` | `[1]` | RW | `0x1` | FPGA system clock enable |
| `CLK_JESD_EN` | `[2]` | RW | `0x0` | JESD204B clock enable |

---
### `EEPROM_CTRL` — Address `0x0500`

**Reset value:** `0x00`  **Access:** see fields below

EEPROM control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READ` | `[0]` | RW | `0x0` | Initiate read |
| `WRITE` | `[1]` | RW | `0x0` | Initiate write |
| `ERASE` | `[2]` | RW | `0x0` | Initiate erase |
| `BUSY` | `[7]` | R | `0x0` | EEPROM busy flag |

---
### `EEPROM_ADDR` — Address `0x0501`

**Reset value:** `0x0000`  **Access:** see fields below

EEPROM byte address

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADDR` | `[15:0]` | RW | `0x0000` | 16-bit byte address |

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

Configuration flash control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READ` | `[0]` | RW | `0x0` | Flash read enable |
| `WRITE` | `[1]` | RW | `0x0` | Flash write enable |
| `ERASE_SECTOR` | `[2]` | RW | `0x0` | Sector erase |
| `ERASE_CHIP` | `[3]` | RW | `0x0` | Chip erase |
| `BUSY` | `[7]` | R | `0x0` | Flash busy flag |

---
### `FLASH_ADDR_LOW` — Address `0x0601`

**Reset value:** `0x0000`  **Access:** see fields below

Flash address low word

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADDR_LOW` | `[15:0]` | RW | `0x0000` | Address bits [15:0] |

---
### `FLASH_ADDR_HIGH` — Address `0x0602`

**Reset value:** `0x00`  **Access:** see fields below

Flash address high byte

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADDR_HIGH` | `[7:0]` | RW | `0x00` | Address bits [23:16] |

---
### `FLASH_DATA` — Address `0x0603`

**Reset value:** `0x0000`  **Access:** see fields below

Flash read/write data FIFO

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA` | `[15:0]` | RW | `0x0000` | 16-bit data word |

---
### `FLASH_STATUS` — Address `0x0604`

**Reset value:** `0x01`  **Access:** see fields below

Flash status register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READY` | `[0]` | RC | `0x1` | Flash ready flag |
| `WRITE_ERR` | `[1]` | RC | `0x0` | Write error flag |
| `ERASE_ERR` | `[2]` | RC | `0x0` | Erase error flag |

---
### `RF_LO_FREQ_HIGH` — Address `0x0700`

**Reset value:** `0x09C4`  **Access:** see fields below

RF LO frequency high word (LMX2594)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `FREQ_HI` | `[15:0]` | RW | `0x09C4` | Frequency high word (default ~10GHz) |

---
### `RF_LO_FREQ_LOW` — Address `0x0701`

**Reset value:** `0x0000`  **Access:** see fields below

RF LO frequency low word

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `FREQ_LO` | `[15:0]` | RW | `0x0000` | Frequency low word |

---
### `VGA_GAIN_CTRL` — Address `0x0702`

**Reset value:** `0x40`  **Access:** see fields below

HMC698LP2 VGA gain control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GAIN_CODE` | `[7:0]` | RW | `0x40` | VGA gain code (0x40 = mid-scale, 0dB) |

---
### `RF_STATUS` — Address `0x0703`

**Reset value:** `0x02`  **Access:** see fields below

RF front-end status

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LO_LOCK` | `[0]` | R | `0x0` | LO synthesizer locked |
| `VGA_OK` | `[1]` | R | `0x1` | VGA operational |

---
### `JESD204B_CTRL` — Address `0x0704`

**Reset value:** `0x04`  **Access:** see fields below

JESD204B interface control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LINK_ENABLE` | `[0]` | RW | `0x0` | Enable JESD204B link |
| `LANE_MODE` | `[3:2]` | RW | `0x1` | Lane mode: 0x1=2 lanes |
| `SCR` | `[6:4]` | RW | `0x1` | Subclass: 0x1=Subclass 1 (SYSREF) |

---
### `JESD204B_STATUS` — Address `0x0705`

**Reset value:** `0x00`  **Access:** see fields below

JESD204B link status

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LINK_LOCKED` | `[0]` | RC | `0x0` | Link locked to ADC |
| `ALIGN_DONE` | `[1]` | RC | `0x0` | Lane alignment complete |
| `DISP_ERR` | `[2]` | RC | `0x0` | Disparity error |

---
### `GPIO_CTRL` — Address `0x0800`

**Reset value:** `0x00`  **Access:** see fields below

GPIO control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GPIO0_DIR` | `[0]` | RW | `0x0` | GPIO0 direction: 0=input, 1=output |
| `GPIO0_OUT` | `[1]` | RW | `0x0` | GPIO0 output value |
| `GPIO1_DIR` | `[2]` | RW | `0x0` | GPIO1 direction |
| `GPIO1_OUT` | `[3]` | RW | `0x0` | GPIO1 output value |

---
### `GPIO_INPUT` — Address `0x0801`

**Reset value:** `0x00`  **Access:** see fields below

GPIO input read register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GPIO0_IN` | `[0]` | R | `0x0` | GPIO0 input value |
| `GPIO1_IN` | `[1]` | R | `0x0` | GPIO1 input value |
