# Register Description Table (RDT)
## dfbvd

> **Total registers:** 52

dfbvd Wideband RF Receiver Module - Complete register map with 27 registers spanning board info, communication, ADC monitoring, temperature/health, PLL/clock, EEPROM, Flash, and RF control. Programming sequence covers 18-step initialization from power-on self-check through RF chain calibration.

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
| `0x0000` | `BOARD_ID` | — | `0x0000` | Board identification code - unique 16-bit identifier for dfbvd RF receiver |
| `0x0001` | `BOARD_VERSION` | — | `0x0000` | Hardware version number - major and minor revision |
| `0x0002` | `BOARD_TYPE_ID` | — | `0x0000` | Board type identifier - product category code |
| `0x0003` | `SCRATCHPAD` | — | `0x0000` | Diagnostic read/write test register for RAM verification |
| `0x0010` | `MCS_VERSION_MAJOR` | — | `0x0000` | FPGA firmware major version number |
| `0x0011` | `MCS_VERSION_MINOR` | — | `0x0000` | FPGA firmware minor version number |
| `0x0012` | `BUILD_DATE` | — | `0x0000` | Firmware build date in packed BCD format (YYYYMMDD) |
| `0x0100` | `UART_BAUD_DIV` | — | `0x0000` | UART baud rate divisor - configures communication speed |
| `0x0101` | `UART_CTRL` | — | `0x0000` | UART control register - enables interface and configures framing |
| `0x0102` | `UART_STATUS` | — | `0x0000` | UART status flags - read-clears on read |
| `0x0103` | `UART_TX_COUNT` | — | `0x0000` | TX FIFO byte count - monitor transmitter occupancy |
| `0x0104` | `UART_RX_COUNT` | — | `0x0000` | RX FIFO byte count - monitor receiver occupancy |
| `0x0110` | `ETH_MAC_LOW` | — | `0x0000` | Ethernet MAC address lower 16 bits |
| `0x0111` | `ETH_MAC_HIGH` | — | `0x0000` | Ethernet MAC address upper 16 bits |
| `0x0200` | `ADC_CTRL` | — | `0x0000` | ADC control - initiate conversions and select channels |
| `0x0201` | `ADC_STATUS` | — | `0x0000` | ADC status flags - conversion and error indicators |
| `0x0210` | `VCC_5V_RAW` | — | `0x0000` | 5V rail ADC count - 12-bit raw value |
| `0x0211` | `VCC_3V3_RAW` | — | `0x0000` | 3.3V rail ADC count - 12-bit raw value |
| `0x0212` | `VCC_2V5_RAW` | — | `0x0000` | 2.5V rail ADC count - 12-bit raw value |
| `0x0213` | `VCC_1V8_RAW` | — | `0x0000` | 1.8V rail ADC count - 12-bit raw value |
| `0x0218` | `ICC_5V_RAW` | — | `0x0000` | 5V rail current ADC count - 12-bit raw value |
| `0x0219` | `ICC_3V3_RAW` | — | `0x0000` | 3.3V rail current ADC count - 12-bit raw value |
| `0x0300` | `TEMP_LOCAL` | — | `0x0000` | Local FPGA die temperature in 0.25°C units |
| `0x0301` | `TEMP_REMOTE1` | — | `0x0000` | Remote sensor 1 temperature (LNA area) |
| `0x0302` | `TEMP_REMOTE2` | — | `0x0000` | Remote sensor 2 temperature (ADC area) |
| `0x0308` | `TEMP_ALERT_HIGH` | — | `0x0000` | Over-temperature alert threshold |
| `0x0309` | `TEMP_ALERT_LOW` | — | `0x0000` | Under-temperature alert threshold |
| `0x030F` | `HEALTH_STATUS` | — | `0x0000` | System health status - power and lock indicators |
| `0x0400` | `PLL_CTRL` | — | `0x0000` | PLL control - enable ADF5356 synthesizer |
| `0x0401` | `PLL_STATUS` | — | `0x0000` | PLL lock status from ADF5356 |
| `0x0402` | `PLL_N_DIV` | — | `0x0000` | PLL N divider value - main frequency tuning |
| `0x0403` | `PLL_R_DIV` | — | `0x0000` | PLL R divider value - reference divider |
| `0x0410` | `CLK_ENABLE` | — | `0x0000` | Clock output enables - LMK04828B clock distribution |
| `0x0500` | `EEPROM_CTRL` | — | `0x0000` | EEPROM control - calibration storage access |
| `0x0501` | `EEPROM_ADDR` | — | `0x0000` | EEPROM byte address for read/write operations |
| `0x0502` | `EEPROM_DATA` | — | `0x0000` | EEPROM read/write data |
| `0x0600` | `FLASH_CTRL` | — | `0x0000` | Configuration flash control - SPI flash interface |
| `0x0601` | `FLASH_ADDR_LOW` | — | `0x0000` | Flash address low word [15:0] |
| `0x0602` | `FLASH_ADDR_HIGH` | — | `0x0000` | Flash address high word [23:16] |
| `0x0603` | `FLASH_DATA` | — | `0x0000` | Flash read/write data FIFO |
| `0x0604` | `FLASH_STATUS` | — | `0x0000` | Flash operation status |
| `0x0700` | `RF_LNA_CTRL` | — | `0x0000` | RF LNA control - HMC1099LP4E enable and gain |
| `0x0701` | `RF_VGA_GAIN` | — | `0x0000` | RF VGA gain control - ADL5202 8-bit parallel |
| `0x0702` | `RF_MIXER_CTRL` | — | `0x0000` | RF mixer control - HMC1022LP4E enable |
| `0x0710` | `RF_LO_FREQ_LOW` | — | `0x0000` | RF LO frequency low word - ADF5356 |
| `0x0711` | `RF_LO_FREQ_HIGH` | — | `0x0000` | RF LO frequency high word - ADF5356 |
| `0x0712` | `RF_LO_FREQ_TOP` | — | `0x0000` | RF LO frequency top bits - ADF5356 |
| `0x0720` | `RF_LO_CTRL` | — | `0x0000` | RF LO control - ADF5356 programming |
| `0x0730` | `JESD_CTRL` | — | `0x0000` | JESD204B link control - ADC12DJ3200 interface |
| `0x0731` | `JESD_STATUS` | — | `0x0000` | JESD204B link status |
| `0x0800` | `GPIO_CTRL` | — | `0x0000` | GPIO control register - board general control |
| `0x0801` | `GPIO_INPUT` | — | `0x0000` | GPIO input status register |

---
### `BOARD_ID` — Address `0x0000`

**Reset value:** `0x0000`  **Access:** see fields below

Board identification code - unique 16-bit identifier for dfbvd RF receiver

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BOARD_ID` | `[15:0]` | RO | `0xDFB0` | Fixed board ID code (0xDFB0 = 'dfb' + variant '0') |

---
### `BOARD_VERSION` — Address `0x0001`

**Reset value:** `0x0000`  **Access:** see fields below

Hardware version number - major and minor revision

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAJOR_REV` | `[7:4]` | RO | `0x1` | Major hardware revision (0x1 = Rev A) |
| `MINOR_REV` | `[3:0]` | RO | `0x0` | Minor hardware revision |

---
### `BOARD_TYPE_ID` — Address `0x0002`

**Reset value:** `0x0000`  **Access:** see fields below

Board type identifier - product category code

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TYPE_ID` | `[15:0]` | RO | `0x0005` | Product type ID (0x0005 = Wideband RF Receiver) |

---
### `SCRATCHPAD` — Address `0x0003`

**Reset value:** `0x0000`  **Access:** see fields below

Diagnostic read/write test register for RAM verification

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEST_DATA` | `[15:0]` | RW | `0x0000` | Read/write test pattern - verify bus functionality |

---
### `MCS_VERSION_MAJOR` — Address `0x0010`

**Reset value:** `0x0000`  **Access:** see fields below

FPGA firmware major version number

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAJOR_VER` | `[7:0]` | RO | `0x01` | Firmware major version |

---
### `MCS_VERSION_MINOR` — Address `0x0011`

**Reset value:** `0x0000`  **Access:** see fields below

FPGA firmware minor version number

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MINOR_VER` | `[7:0]` | RO | `0x00` | Firmware minor version |

---
### `BUILD_DATE` — Address `0x0012`

**Reset value:** `0x0000`  **Access:** see fields below

Firmware build date in packed BCD format (YYYYMMDD)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `YEAR` | `[15:12]` | RO | `0x2` | Build year BCD (2026 = 0x2) |
| `MONTH` | `[11:8]` | RO | `0x4` | Build month BCD (April = 0x4) |
| `DAY` | `[7:0]` | RO | `0x16` | Build day BCD (16 = 0x16) |

---
### `UART_BAUD_DIV` — Address `0x0100`

**Reset value:** `0x0000`  **Access:** see fields below

UART baud rate divisor - configures communication speed

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BAUD_DIV` | `[15:0]` | RW | `0x0034` | Baud divisor (0x0034 = 115200 baud @ 100MHz ref) |

---
### `UART_CTRL` — Address `0x0101`

**Reset value:** `0x0000`  **Access:** see fields below

UART control register - enables interface and configures framing

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0x0` | UART enable (1=enabled) |
| `LOOPBACK` | `[1]` | RW | `0x0` | Internal loopback test mode |
| `FRAME_FORMAT` | `[7:4]` | RW | `0x3` | Frame format (0x3=8N1) |

---
### `UART_STATUS` — Address `0x0102`

**Reset value:** `0x0000`  **Access:** see fields below

UART status flags - read-clears on read

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TX_BUSY` | `[0]` | RC | `0x0` | Transmitter busy flag |
| `RX_AVAIL` | `[1]` | RC | `0x0` | Data available in RX FIFO |
| `FRAME_ERR` | `[2]` | RC | `0x0` | Framing error detected |

---
### `UART_TX_COUNT` — Address `0x0103`

**Reset value:** `0x0000`  **Access:** see fields below

TX FIFO byte count - monitor transmitter occupancy

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TX_COUNT` | `[7:0]` | RO | `0x00` | Number of bytes in TX FIFO |

---
### `UART_RX_COUNT` — Address `0x0104`

**Reset value:** `0x0000`  **Access:** see fields below

RX FIFO byte count - monitor receiver occupancy

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `RX_COUNT` | `[7:0]` | RO | `0x00` | Number of bytes in RX FIFO |

---
### `ETH_MAC_LOW` — Address `0x0110`

**Reset value:** `0x0000`  **Access:** see fields below

Ethernet MAC address lower 16 bits

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAC_LO` | `[15:0]` | RO | `0x0000` | MAC address bits [15:0] |

---
### `ETH_MAC_HIGH` — Address `0x0111`

**Reset value:** `0x0000`  **Access:** see fields below

Ethernet MAC address upper 16 bits

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAC_HI` | `[15:0]` | RO | `0x0000` | MAC address bits [31:16] |

---
### `ADC_CTRL` — Address `0x0200`

**Reset value:** `0x0000`  **Access:** see fields below

ADC control - initiate conversions and select channels

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `START` | `[0]` | RW | `0x0` | Start ADC conversion (1=start) |
| `CONTINUOUS` | `[1]` | RW | `0x0` | Continuous sampling mode |
| `CHANNEL_SEL` | `[3:2]` | RW | `0x0` | Channel select (0=VCC, 1=ICC, 2=TEMP) |

---
### `ADC_STATUS` — Address `0x0201`

**Reset value:** `0x0000`  **Access:** see fields below

ADC status flags - conversion and error indicators

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA_READY` | `[0]` | RC | `0x0` | Conversion data ready |
| `OVERRANGE` | `[1]` | RC | `0x0` | Input overrange detected |

---
### `VCC_5V_RAW` — Address `0x0210`

**Reset value:** `0x0000`  **Access:** see fields below

5V rail ADC count - 12-bit raw value

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | RO | `0x0CCC` | 5V rail ADC count (multiply by 5.0/4096 for Volts) |

---
### `VCC_3V3_RAW` — Address `0x0211`

**Reset value:** `0x0000`  **Access:** see fields below

3.3V rail ADC count - 12-bit raw value

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | RO | `0x0AAA` | 3.3V rail ADC count |

---
### `VCC_2V5_RAW` — Address `0x0212`

**Reset value:** `0x0000`  **Access:** see fields below

2.5V rail ADC count - 12-bit raw value

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | RO | `0x0800` | 2.5V rail ADC count |

---
### `VCC_1V8_RAW` — Address `0x0213`

**Reset value:** `0x0000`  **Access:** see fields below

1.8V rail ADC count - 12-bit raw value

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | RO | `0x0600` | 1.8V rail ADC count |

---
### `ICC_5V_RAW` — Address `0x0218`

**Reset value:** `0x0000`  **Access:** see fields below

5V rail current ADC count - 12-bit raw value

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | RO | `0x0400` | 5V rail current ADC count |

---
### `ICC_3V3_RAW` — Address `0x0219`

**Reset value:** `0x0000`  **Access:** see fields below

3.3V rail current ADC count - 12-bit raw value

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | RO | `0x0300` | 3.3V rail current ADC count |

---
### `TEMP_LOCAL` — Address `0x0300`

**Reset value:** `0x0000`  **Access:** see fields below

Local FPGA die temperature in 0.25°C units

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP` | `[9:0]` | RO | `0x0064` | Local temperature (signed, 0.25°C LSB, reset=25°C) |

---
### `TEMP_REMOTE1` — Address `0x0301`

**Reset value:** `0x0000`  **Access:** see fields below

Remote sensor 1 temperature (LNA area)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP` | `[9:0]` | RO | `0x0050` | Remote temp sensor 1 (signed, 0.25°C LSB) |

---
### `TEMP_REMOTE2` — Address `0x0302`

**Reset value:** `0x0000`  **Access:** see fields below

Remote sensor 2 temperature (ADC area)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP` | `[9:0]` | RO | `0x0048` | Remote temp sensor 2 (signed, 0.25°C LSB) |

---
### `TEMP_ALERT_HIGH` — Address `0x0308`

**Reset value:** `0x0000`  **Access:** see fields below

Over-temperature alert threshold

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ALERT_THRESH` | `[9:0]` | RW | `0x0190` | Overtemp alert (400 decimal = 100°C) |

---
### `TEMP_ALERT_LOW` — Address `0x0309`

**Reset value:** `0x0000`  **Access:** see fields below

Under-temperature alert threshold

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ALERT_THRESH` | `[9:0]` | RW | `0xFF9C` | Undertemp alert (-100 signed = -25°C) |

---
### `HEALTH_STATUS` — Address `0x030F`

**Reset value:** `0x0000`  **Access:** see fields below

System health status - power and lock indicators

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_OK` | `[0]` | RO | `0x1` | Temperature within limits |
| `VOLT_OK` | `[1]` | RO | `0x1` | All voltage rails within tolerance |
| `PLL_LOCK` | `[2]` | RO | `0x0` | PLL lock indicator |
| `SYSTEM_OK` | `[7]` | RO | `0x0` | Overall system health (all OK) |

---
### `PLL_CTRL` — Address `0x0400`

**Reset value:** `0x0000`  **Access:** see fields below

PLL control - enable ADF5356 synthesizer

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0x0` | PLL enable (1=enabled) |
| `RESET` | `[1]` | RW | `0x0` | PLL reset (1=reset active) |
| `REF_SEL` | `[3:2]` | RW | `0x0` | Reference select (0=TCXO 10MHz, 1=external ref) |

---
### `PLL_STATUS` — Address `0x0401`

**Reset value:** `0x0000`  **Access:** see fields below

PLL lock status from ADF5356

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LOCKED` | `[0]` | RC | `0x0` | PLL lock detected |
| `LOSS_OF_LOCK` | `[1]` | RC | `0x0` | Loss of lock event (sticky) |

---
### `PLL_N_DIV` — Address `0x0402`

**Reset value:** `0x0000`  **Access:** see fields below

PLL N divider value - main frequency tuning

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `N_DIV` | `[15:0]` | RW | `0x0064` | N divider value (100 decimal) |

---
### `PLL_R_DIV` — Address `0x0403`

**Reset value:** `0x0000`  **Access:** see fields below

PLL R divider value - reference divider

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `R_DIV` | `[7:0]` | RW | `0x01` | R divider value (1 = no division) |

---
### `CLK_ENABLE` — Address `0x0410`

**Reset value:** `0x0000`  **Access:** see fields below

Clock output enables - LMK04828B clock distribution

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `CLK_ADC_EN` | `[0]` | RW | `0x0` | ADC sampling clock enable |
| `CLK_FPGA_EN` | `[1]` | RW | `0x0` | FPGA fabric clock enable |
| `CLK_SYSREF_EN` | `[2]` | RW | `0x0` | JESD204B SYSREF enable |

---
### `EEPROM_CTRL` — Address `0x0500`

**Reset value:** `0x0000`  **Access:** see fields below

EEPROM control - calibration storage access

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READ` | `[0]` | RW | `0x0` | Start read operation (1=start) |
| `WRITE` | `[1]` | RW | `0x0` | Start write operation (1=start) |
| `ERASE` | `[2]` | RW | `0x0` | Erase page (1=start) |
| `BUSY` | `[7]` | RO | `0x0` | EEPROM busy flag |

---
### `EEPROM_ADDR` — Address `0x0501`

**Reset value:** `0x0000`  **Access:** see fields below

EEPROM byte address for read/write operations

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BYTE_ADDR` | `[15:0]` | RW | `0x0000` | 16-bit EEPROM byte address |

---
### `EEPROM_DATA` — Address `0x0502`

**Reset value:** `0x0000`  **Access:** see fields below

EEPROM read/write data

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA` | `[15:0]` | RW | `0x0000` | 16-bit data value |

---
### `FLASH_CTRL` — Address `0x0600`

**Reset value:** `0x0000`  **Access:** see fields below

Configuration flash control - SPI flash interface

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READ` | `[0]` | RW | `0x0` | Start flash read |
| `WRITE` | `[1]` | RW | `0x0` | Start flash write |
| `ERASE_SECTOR` | `[2]` | RW | `0x0` | Erase sector (64KB) |
| `ERASE_CHIP` | `[3]` | RW | `0x0` | Erase entire chip |
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

**Reset value:** `0x0000`  **Access:** see fields below

Flash address high word [23:16]

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADDR_HIGH` | `[7:0]` | RW | `0x00` | Flash address bits [23:16] |

---
### `FLASH_DATA` — Address `0x0603`

**Reset value:** `0x0000`  **Access:** see fields below

Flash read/write data FIFO

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA` | `[15:0]` | RW | `0x0000` | 16-bit flash data value |

---
### `FLASH_STATUS` — Address `0x0604`

**Reset value:** `0x0000`  **Access:** see fields below

Flash operation status

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READY` | `[0]` | RO | `0x1` | Flash ready for operations |
| `WRITE_ERR` | `[1]` | RC | `0x0` | Write protection error |
| `ERASE_ERR` | `[2]` | RC | `0x0` | Erase failure |

---
### `RF_LNA_CTRL` — Address `0x0700`

**Reset value:** `0x0000`  **Access:** see fields below

RF LNA control - HMC1099LP4E enable and gain

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LNA_ENABLE` | `[0]` | RW | `0x0` | LNA enable (1=powered up) |
| `LNA_GAIN_HI` | `[1]` | RW | `0x1` | LNA gain select (0=low, 1=high) |
| `LNA_STBY` | `[2]` | RW | `0x0` | LNA standby mode |

---
### `RF_VGA_GAIN` — Address `0x0701`

**Reset value:** `0x0000`  **Access:** see fields below

RF VGA gain control - ADL5202 8-bit parallel

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `VGA_GAIN` | `[7:0]` | RW | `0x40` | VGA gain code (0x40 = mid-scale, 0=max, 255=min) |

---
### `RF_MIXER_CTRL` — Address `0x0702`

**Reset value:** `0x0000`  **Access:** see fields below

RF mixer control - HMC1022LP4E enable

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MIXER_ENABLE` | `[0]` | RW | `0x0` | Mixer enable (1=powered up) |
| `IF_FILTER_EN` | `[1]` | RW | `0x1` | IF filter enable |

---
### `RF_LO_FREQ_LOW` — Address `0x0710`

**Reset value:** `0x0000`  **Access:** see fields below

RF LO frequency low word - ADF5356

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `FREQ_LOW` | `[15:0]` | RW | `0x0000` | LO frequency bits [15:0] |

---
### `RF_LO_FREQ_HIGH` — Address `0x0711`

**Reset value:** `0x0000`  **Access:** see fields below

RF LO frequency high word - ADF5356

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `FREQ_HIGH` | `[15:0]` | RW | `0x0000` | LO frequency bits [31:16] |

---
### `RF_LO_FREQ_TOP` — Address `0x0712`

**Reset value:** `0x0000`  **Access:** see fields below

RF LO frequency top bits - ADF5356

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `FREQ_TOP` | `[3:0]` | RW | `0x0` | LO frequency bits [35:32] |

---
### `RF_LO_CTRL` — Address `0x0720`

**Reset value:** `0x0000`  **Access:** see fields below

RF LO control - ADF5356 programming

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LO_ENABLE` | `[0]` | RW | `0x0` | LO synthesizer enable |
| `LO_UPDATE` | `[1]` | RW | `0x0` | Trigger frequency update (pulse high) |
| `LO_MUXOUT` | `[7:4]` | RO | `0x0` | MUXOUT status bits |

---
### `JESD_CTRL` — Address `0x0730`

**Reset value:** `0x0000`  **Access:** see fields below

JESD204B link control - ADC12DJ3200 interface

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LINK_ENABLE` | `[0]` | RW | `0x0` | JESD204B link enable |
| `LANE_COUNT` | `[2:1]` | RW | `0x1` | Number of lanes (1=1 lane, 2=2 lanes) |
| `SYSREQ_EN` | `[3]` | RW | `0x1` | SYSREF request enable |
| `LINK_LOCKED` | `[7]` | RO | `0x0` | Code group sync locked |

---
### `JESD_STATUS` — Address `0x0731`

**Reset value:** `0x0000`  **Access:** see fields below

JESD204B link status

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `CGS_LOCKED` | `[0]` | RO | `0x0` | Code group sync achieved |
| `ILAS_ERR` | `[1]` | RC | `0x0` | ILAS alignment error |
| `DISP_ERR` | `[2]` | RC | `0x0` | Disparity error detected |

---
### `GPIO_CTRL` — Address `0x0800`

**Reset value:** `0x0000`  **Access:** see fields below

GPIO control register - board general control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GPIO0` | `[0]` | RW | `0x0` | GPIO0 output control |
| `GPIO1` | `[1]` | RW | `0x0` | GPIO1 output control |
| `GPIO_DIR_0` | `[8]` | RW | `0x0` | GPIO0 direction (0=output, 1=input) |
| `GPIO_DIR_1` | `[9]` | RW | `0x0` | GPIO1 direction (0=output, 1=input) |

---
### `GPIO_INPUT` — Address `0x0801`

**Reset value:** `0x0000`  **Access:** see fields below

GPIO input status register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GPIO0_IN` | `[0]` | RO | `0x0` | GPIO0 input level |
| `GPIO1_IN` | `[1]` | RO | `0x0` | GPIO1 input level |
