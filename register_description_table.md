# Register Description Table (RDT)
## rx module

> **Total registers:** 49

rx module FPGA register map with 43 memory-mapped registers across 10 functional groups (Board Info, Communication, ADC Monitoring, Temperature/Health, PLL/Clock, EEPROM, Flash, RF Control, GPIO, JESD204B). 20-step initialization sequence covering RAM verification, power rail validation, PLL configuration, JESD204B link establishment, and RF frontend enable for 5-18 GHz wideband receiver operation.

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
| `0x0000` | `BOARD_ID` | — | `0x5258` | Board identification code - unique identifier for rx module |
| `0x0001` | `BOARD_VERSION` | — | `0x10` | Hardware version number |
| `0x0002` | `BOARD_TYPE_ID` | — | `0x5258` | Board type identifier |
| `0x0003` | `SCRATCHPAD` | — | `0x0000` | Test register for RAM verification |
| `0x0010` | `MCS_VERSION_MAJOR` | — | `0x01` | FPGA firmware major version |
| `0x0011` | `MCS_VERSION_MINOR` | — | `0x00` | FPGA firmware minor version |
| `0x0012` | `BUILD_DATE` | — | `0x20260417` | Firmware build date (packed BCD) |
| `0x0100` | `UART_BAUD_DIV` | — | `0x0068` | UART baud rate divisor |
| `0x0101` | `UART_CTRL` | — | `0x30` | UART control register |
| `0x0102` | `UART_STATUS` | — | `0x00` | UART status flags |
| `0x0103` | `UART_TX_COUNT` | — | `0x00` | TX FIFO byte count |
| `0x0104` | `UART_RX_COUNT` | — | `0x00` | RX FIFO byte count |
| `0x0110` | `ETH_MAC_LOW` | — | `0x0000` | Ethernet MAC address low word |
| `0x0111` | `ETH_MAC_HIGH` | — | `0x0000` | Ethernet MAC address high word |
| `0x0200` | `ADC_CTRL` | — | `0x04` | ADC control register (AD9208) |
| `0x0201` | `ADC_STATUS` | — | `0x00` | ADC status register |
| `0x0210` | `VCC_5V_RAW` | — | `0x0000` | 5V rail ADC count |
| `0x0211` | `VCC_3V3_RAW` | — | `0x0000` | 3.3V rail ADC count |
| `0x0212` | `VCC_2V5_RAW` | — | `0x0000` | 2.5V rail ADC count |
| `0x0213` | `VCC_1V8_RAW` | — | `0x0000` | 1.8V rail ADC count |
| `0x0218` | `ICC_5V_RAW` | — | `0x0000` | 5V rail current ADC count |
| `0x0219` | `ICC_3V3_RAW` | — | `0x0000` | 3.3V rail current ADC count |
| `0x0300` | `TEMP_LOCAL` | — | `0x0000` | Local FPGA die temperature |
| `0x0301` | `TEMP_REMOTE1` | — | `0x0000` | Remote sensor 1 temperature (HMC698LP4) |
| `0x0302` | `TEMP_REMOTE2` | — | `0x0000` | Remote sensor 2 temperature (AD9208) |
| `0x0308` | `TEMP_ALERT_HIGH` | — | `0x0190` | Over-temperature alert threshold |
| `0x0309` | `TEMP_ALERT_LOW` | — | `0xFF9C` | Under-temperature alert threshold |
| `0x030F` | `HEALTH_STATUS` | — | `0x00` | System health status |
| `0x0400` | `PLL_CTRL` | — | `0x00` | PLL control register |
| `0x0401` | `PLL_STATUS` | — | `0x00` | PLL status register |
| `0x0402` | `PLL_N_DIV` | — | `0x0020` | PLL N divider value |
| `0x0403` | `PLL_R_DIV` | — | `0x01` | PLL R divider value |
| `0x0410` | `CLK_ENABLE` | — | `0x08` | Clock output enables |
| `0x0500` | `EEPROM_CTRL` | — | `0x00` | EEPROM control register |
| `0x0501` | `EEPROM_ADDR` | — | `0x0000` | EEPROM byte address |
| `0x0502` | `EEPROM_DATA` | — | `0x0000` | EEPROM read/write data |
| `0x0600` | `FLASH_CTRL` | — | `0x00` | Configuration flash control |
| `0x0601` | `FLASH_ADDR_LOW` | — | `0x0000` | Flash address low word |
| `0x0602` | `FLASH_ADDR_HIGH` | — | `0x00` | Flash address high byte |
| `0x0603` | `FLASH_DATA` | — | `0x0000` | Flash data FIFO |
| `0x0604` | `FLASH_STATUS` | — | `0x01` | Flash status register |
| `0x0800` | `GPIO_CTRL` | — | `0x0000` | GPIO direction and control |
| `0x0801` | `GPIO_IN` | — | `0x00` | GPIO input status |
| `0x0700` | `RF_GAIN_CTRL` | — | `0x20` | RF frontend gain control (HMC698LP4) |
| `0x0701` | `RF_STATUS` | — | `0x00` | RF frontend status |
| `0x0A00` | `ADC_RX_DATA_I` | — | `0x0000` | ADC I-channel data snapshot |
| `0x0A01` | `ADC_RX_DATA_Q` | — | `0x0000` | ADC Q-channel data snapshot |
| `0x0A10` | `JESD204B_CTRL` | — | `0x06` | JESD204B interface control |
| `0x0A11` | `JESD204B_STATUS` | — | `0x00` | JESD204B link status |

---
### `BOARD_ID` — Address `0x0000`

**Reset value:** `0x5258`  **Access:** see fields below

Board identification code - unique identifier for rx module

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BOARD_ID` | `[15:0]` | RO | `0x5258` | Unique board ID (0x5258 = ascii 'RX') |

---
### `BOARD_VERSION` — Address `0x0001`

**Reset value:** `0x10`  **Access:** see fields below

Hardware version number

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAJOR_VERSION` | `[7:4]` | RO | `0x1` | Major hardware version |
| `MINOR_VERSION` | `[3:0]` | RO | `0x0` | Minor hardware version |

---
### `BOARD_TYPE_ID` — Address `0x0002`

**Reset value:** `0x5258`  **Access:** see fields below

Board type identifier

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BOARD_TYPE` | `[15:0]` | RO | `0x5258` | Board type (0x52580101 = RX Module Rev1) |

---
### `SCRATCHPAD` — Address `0x0003`

**Reset value:** `0x0000`  **Access:** see fields below

Test register for RAM verification

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEST_DATA` | `[15:0]` | RW | `0x0000` | Read/write test pattern for memory check |

---
### `MCS_VERSION_MAJOR` — Address `0x0010`

**Reset value:** `0x01`  **Access:** see fields below

FPGA firmware major version

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAJOR` | `[7:0]` | RO | `0x01` | Firmware major version number |

---
### `MCS_VERSION_MINOR` — Address `0x0011`

**Reset value:** `0x00`  **Access:** see fields below

FPGA firmware minor version

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MINOR` | `[7:0]` | RO | `0x00` | Firmware minor version number |

---
### `BUILD_DATE` — Address `0x0012`

**Reset value:** `0x20260417`  **Access:** see fields below

Firmware build date (packed BCD)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATE_BCD` | `[15:0]` | RO | `0x20260417` | Build date in YYYYMMDD format |

---
### `UART_BAUD_DIV` — Address `0x0100`

**Reset value:** `0x0068`  **Access:** see fields below

UART baud rate divisor

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BAUD_DIV` | `[15:0]` | RW | `0x0068` | Baud divisor = clk_freq / (16 * baud_rate) |

---
### `UART_CTRL` — Address `0x0101`

**Reset value:** `0x30`  **Access:** see fields below

UART control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0x0` | UART enable (1=enabled) |
| `LOOPBACK` | `[1]` | RW | `0x0` | Loopback mode for test |
| `FRAME_FORMAT` | `[7:4]` | RW | `0x3` | Frame format (bits, parity, stop bits) |

---
### `UART_STATUS` — Address `0x0102`

**Reset value:** `0x00`  **Access:** see fields below

UART status flags

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TX_BUSY` | `[0]` | RO | `0x0` | Transmitter busy flag |
| `RX_AVAIL` | `[1]` | RO | `0x0` | Data available in RX FIFO |
| `FRAME_ERR` | `[2]` | RC | `0x0` | Frame error flag (clear on read) |

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
### `ETH_MAC_LOW` — Address `0x0110`

**Reset value:** `0x0000`  **Access:** see fields below

Ethernet MAC address low word

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAC_LOW` | `[15:0]` | RO | `0x0000` | MAC address [15:0] |

---
### `ETH_MAC_HIGH` — Address `0x0111`

**Reset value:** `0x0000`  **Access:** see fields below

Ethernet MAC address high word

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAC_HIGH` | `[15:0]` | RO | `0x0000` | MAC address [31:16] |

---
### `ADC_CTRL` — Address `0x0200`

**Reset value:** `0x04`  **Access:** see fields below

ADC control register (AD9208)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `START` | `[0]` | RW | `0x0` | Start ADC conversion |
| `CONTINUOUS` | `[1]` | RW | `0x0` | Continuous mode enable |
| `CHANNEL_SEL` | `[3:2]` | RW | `0x2` | Channel selection (00=chI, 01=chQ, 10=both) |
| `JESD204B_EN` | `[4]` | RW | `0x0` | JESD204B link enable |

---
### `ADC_STATUS` — Address `0x0201`

**Reset value:** `0x00`  **Access:** see fields below

ADC status register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA_READY` | `[0]` | RO | `0x0` | New data available |
| `OVERRANGE` | `[1]` | RC | `0x0` | ADC input overrange (clear on read) |
| `JESD204B_LANE0_ALIGNED` | `[8]` | RO | `0x0` | Lane 0 aligned flag |
| `JESD204B_LANE1_ALIGNED` | `[9]` | RO | `0x0` | Lane 1 aligned flag |

---
### `VCC_5V_RAW` — Address `0x0210`

**Reset value:** `0x0000`  **Access:** see fields below

5V rail ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | RO | `0x0000` | 5V rail ADC value (multiply by 5.0/4096) |

---
### `VCC_3V3_RAW` — Address `0x0211`

**Reset value:** `0x0000`  **Access:** see fields below

3.3V rail ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | RO | `0x0000` | 3.3V rail ADC value (multiply by 3.3/4096) |

---
### `VCC_2V5_RAW` — Address `0x0212`

**Reset value:** `0x0000`  **Access:** see fields below

2.5V rail ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | RO | `0x0000` | 2.5V rail ADC value (multiply by 2.5/4096) |

---
### `VCC_1V8_RAW` — Address `0x0213`

**Reset value:** `0x0000`  **Access:** see fields below

1.8V rail ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | RO | `0x0000` | 1.8V rail ADC value (multiply by 1.8/4096) |

---
### `ICC_5V_RAW` — Address `0x0218`

**Reset value:** `0x0000`  **Access:** see fields below

5V rail current ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | RO | `0x0000` | 5V rail current ADC value |

---
### `ICC_3V3_RAW` — Address `0x0219`

**Reset value:** `0x0000`  **Access:** see fields below

3.3V rail current ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | RO | `0x0000` | 3.3V rail current ADC value |

---
### `TEMP_LOCAL` — Address `0x0300`

**Reset value:** `0x0000`  **Access:** see fields below

Local FPGA die temperature

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_VALUE` | `[9:0]` | RO | `0x0000` | Temperature in 0.25°C units (signed) |

---
### `TEMP_REMOTE1` — Address `0x0301`

**Reset value:** `0x0000`  **Access:** see fields below

Remote sensor 1 temperature (HMC698LP4)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_VALUE` | `[9:0]` | RO | `0x0000` | Remote temperature in 0.25°C units (signed) |

---
### `TEMP_REMOTE2` — Address `0x0302`

**Reset value:** `0x0000`  **Access:** see fields below

Remote sensor 2 temperature (AD9208)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_VALUE` | `[9:0]` | RO | `0x0000` | Remote temperature in 0.25°C units (signed) |

---
### `TEMP_ALERT_HIGH` — Address `0x0308`

**Reset value:** `0x0190`  **Access:** see fields below

Over-temperature alert threshold

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ALERT_THRESHOLD` | `[9:0]` | RW | `0x0190` | Alert when temp exceeds this value (0x0190 = 100°C) |

---
### `TEMP_ALERT_LOW` — Address `0x0309`

**Reset value:** `0xFF9C`  **Access:** see fields below

Under-temperature alert threshold

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ALERT_THRESHOLD` | `[9:0]` | RW | `0xFF9C` | Alert when temp below this value (0xFF9C = -25°C) |

---
### `HEALTH_STATUS` — Address `0x030F`

**Reset value:** `0x00`  **Access:** see fields below

System health status

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_OK` | `[0]` | RO | `0x0` | Temperature within limits |
| `VOLT_OK` | `[1]` | RO | `0x0` | Voltage rails within limits |
| `PLL_LOCK` | `[2]` | RO | `0x0` | PLL locked |
| `JESD204B_LINK_OK` | `[3]` | RO | `0x0` | JESD204B link established |
| `SYSTEM_OK` | `[7]` | RO | `0x0` | Overall system healthy |

---
### `PLL_CTRL` — Address `0x0400`

**Reset value:** `0x00`  **Access:** see fields below

PLL control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0x0` | Enable PLL |
| `RESET` | `[1]` | RW | `0x0` | Reset PLL (active high) |
| `REF_SEL` | `[3:2]` | RW | `0x0` | Reference clock select (00=int OSC, 01=ext ref) |

---
### `PLL_STATUS` — Address `0x0401`

**Reset value:** `0x00`  **Access:** see fields below

PLL status register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LOCKED` | `[0]` | RO | `0x0` | PLL locked indicator |
| `LOSS_OF_LOCK` | `[1]` | RC | `0x0` | Loss of lock event (clear on read) |

---
### `PLL_N_DIV` — Address `0x0402`

**Reset value:** `0x0020`  **Access:** see fields below

PLL N divider value

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `N_DIVIDER` | `[15:0]` | RW | `0x0020` | N divider for PLL (multiplier) |

---
### `PLL_R_DIV` — Address `0x0403`

**Reset value:** `0x01`  **Access:** see fields below

PLL R divider value

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `R_DIVIDER` | `[7:0]` | RW | `0x01` | R divider for PLL (reference divider) |

---
### `CLK_ENABLE` — Address `0x0410`

**Reset value:** `0x08`  **Access:** see fields below

Clock output enables

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `CLK_ADC_EN` | `[0]` | RW | `0x0` | Enable ADC sampling clock |
| `CLK_RF_EN` | `[1]` | RW | `0x0` | Enable RF frontend clock |
| `CLK_JESD204B_EN` | `[2]` | RW | `0x0` | Enable JESD204B link clock |
| `CLK_SYS_EN` | `[3]` | RW | `0x1` | Enable system clock |

---
### `EEPROM_CTRL` — Address `0x0500`

**Reset value:** `0x00`  **Access:** see fields below

EEPROM control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READ` | `[0]` | RW | `0x0` | Start EEPROM read |
| `WRITE` | `[1]` | RW | `0x0` | Start EEPROM write |
| `ERASE` | `[2]` | RW | `0x0` | Start EEPROM erase |
| `BUSY` | `[7]` | RO | `0x0` | EEPROM operation in progress |

---
### `EEPROM_ADDR` — Address `0x0501`

**Reset value:** `0x0000`  **Access:** see fields below

EEPROM byte address

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADDRESS` | `[15:0]` | RW | `0x0000` | Byte address in EEPROM |

---
### `EEPROM_DATA` — Address `0x0502`

**Reset value:** `0x0000`  **Access:** see fields below

EEPROM read/write data

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA` | `[15:0]` | RW | `0x0000` | Data to write or read result |

---
### `FLASH_CTRL` — Address `0x0600`

**Reset value:** `0x00`  **Access:** see fields below

Configuration flash control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READ` | `[0]` | RW | `0x0` | Start flash read |
| `WRITE` | `[1]` | RW | `0x0` | Start flash write |
| `ERASE_SECTOR` | `[2]` | RW | `0x0` | Erase flash sector |
| `ERASE_CHIP` | `[3]` | RW | `0x0` | Erase entire chip |
| `BUSY` | `[7]` | RO | `0x0` | Flash operation in progress |

---
### `FLASH_ADDR_LOW` — Address `0x0601`

**Reset value:** `0x0000`  **Access:** see fields below

Flash address low word

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADDR_LOW` | `[15:0]` | RW | `0x0000` | Flash address [15:0] |

---
### `FLASH_ADDR_HIGH` — Address `0x0602`

**Reset value:** `0x00`  **Access:** see fields below

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
| `DATA` | `[15:0]` | RW | `0x0000` | Data to write or read result |

---
### `FLASH_STATUS` — Address `0x0604`

**Reset value:** `0x01`  **Access:** see fields below

Flash status register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READY` | `[0]` | RO | `0x1` | Flash ready for operation |
| `WRITE_ERR` | `[1]` | RC | `0x0` | Write error flag (clear on read) |
| `ERASE_ERR` | `[2]` | RC | `0x0` | Erase error flag (clear on read) |

---
### `GPIO_CTRL` — Address `0x0800`

**Reset value:** `0x0000`  **Access:** see fields below

GPIO direction and control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GPIO_DIR` | `[7:0]` | RW | `0x00` | GPIO direction (0=input, 1=output) |
| `GPIO_OUT` | `[15:8]` | RW | `0x00` | GPIO output values |

---
### `GPIO_IN` — Address `0x0801`

**Reset value:** `0x00`  **Access:** see fields below

GPIO input status

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GPIO_IN` | `[7:0]` | RO | `0x00` | GPIO input values |

---
### `RF_GAIN_CTRL` — Address `0x0700`

**Reset value:** `0x20`  **Access:** see fields below

RF frontend gain control (HMC698LP4)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `VGA_GAIN` | `[5:0]` | RW | `0x20` | VGA gain setting (0-63 maps to 0-50dB) |
| `LNA_BYPASS` | `[6]` | RW | `0x0` | LNA bypass enable |
| `RF_ENABLE` | `[7]` | RW | `0x0` | Enable RF frontend |

---
### `RF_STATUS` — Address `0x0701`

**Reset value:** `0x00`  **Access:** see fields below

RF frontend status

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LNA_OK` | `[0]` | RO | `0x0` | LNA power good |
| `MIXER_OK` | `[1]` | RO | `0x0` | Mixer power good |
| `IQ_DEMOD_OK` | `[2]` | RO | `0x0` | IQ demodulator power good |

---
### `ADC_RX_DATA_I` — Address `0x0A00`

**Reset value:** `0x0000`  **Access:** see fields below

ADC I-channel data snapshot

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA_I` | `[13:0]` | RO | `0x0000` | Latest I-channel sample (14-bit) |

---
### `ADC_RX_DATA_Q` — Address `0x0A01`

**Reset value:** `0x0000`  **Access:** see fields below

ADC Q-channel data snapshot

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA_Q` | `[13:0]` | RO | `0x0000` | Latest Q-channel sample (14-bit) |

---
### `JESD204B_CTRL` — Address `0x0A10`

**Reset value:** `0x06`  **Access:** see fields below

JESD204B interface control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LINK_ENABLE` | `[0]` | RW | `0x0` | Enable JESD204B link |
| `LANE_MODE` | `[2:1]` | RW | `0x1` | Lane mode (00=1 lane, 01=2 lanes) |
| `SUBCLASS` | `[4:3]` | RW | `0x1` | JESD204B subclass (00=0, 01=1) |

---
### `JESD204B_STATUS` — Address `0x0A11`

**Reset value:** `0x00`  **Access:** see fields below

JESD204B link status

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LINK_READY` | `[0]` | RO | `0x0` | Link ready flag |
| `LANE0_ALIGN` | `[1]` | RO | `0x0` | Lane 0 aligned |
| `LANE1_ALIGN` | `[2]` | RO | `0x0` | Lane 1 aligned |
| `CODE_SYNC` | `[3]` | RO | `0x0` | Code group sync |
