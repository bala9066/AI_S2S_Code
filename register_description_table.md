# Register Description Table (RDT)
## sample rf

> **Total registers:** 55

Register map and programming sequence for sample_rf wideband RF receiver module with Si5345 clock generator, ADC12J4000 4 GSPS ADC, HMC698 LNA, HMC1119 mixer, temperature/power monitoring, EEPROM/Flash storage, and HSTC high-speed data interface control.

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
| `0x0000` | `BOARD_ID` | — | `0x5346` | Board identification code - ASCII 'SF' for sample_rf |
| `0x0001` | `BOARD_VERSION` | — | `0x10` | Hardware version number |
| `0x0002` | `BOARD_TYPE_ID` | — | `0x5252` | Board type identifier - RF Receiver |
| `0x0003` | `SCRATCHPAD` | — | `0x0000` | Read/write test register for RAM verification |
| `0x0010` | `MCS_VERSION_MAJOR` | — | `0x01` | FPGA firmware major version |
| `0x0011` | `MCS_VERSION_MINOR` | — | `0x00` | FPGA firmware minor version |
| `0x0012` | `BUILD_DATE` | — | `0x20260416` | Firmware build date in packed BCD (YYYYMMDD) |
| `0x0100` | `UART_BAUD_DIV` | — | `0x0034` | UART baud rate divisor for 115200 baud @ 100MHz clock |
| `0x0101` | `UART_CTRL` | — | `0x00` | UART control register |
| `0x0102` | `UART_STATUS` | — | `0x00` | UART status flags |
| `0x0103` | `UART_TX_COUNT` | — | `0x00` | TX FIFO byte count |
| `0x0104` | `UART_RX_COUNT` | — | `0x00` | RX FIFO byte count |
| `0x0110` | `ETH_MAC_LOW` | — | `0x0000` | Ethernet MAC address lower 16 bits |
| `0x0111` | `ETH_MAC_HIGH` | — | `0x0000` | Ethernet MAC address upper 16 bits |
| `0x0200` | `ADC_CTRL` | — | `0x00` | ADC control register for ADC12J4000 |
| `0x0201` | `ADC_STATUS` | — | `0x00` | ADC status flags |
| `0x0210` | `VCC_5V_RAW` | — | `0x0FFF` | 5V rail ADC count (TPS7A4700 U5 output) |
| `0x0211` | `VCC_3V3_RAW` | — | `0x0FFF` | 3.3V rail ADC count (TPS7A4700 U6 output) |
| `0x0213` | `VCC_1V8_RAW` | — | `0x0FFF` | 1.8V rail ADC count (TPS62130 output) |
| `0x0218` | `ICC_5V_RAW` | — | `0x0000` | 5V rail current ADC count |
| `0x0219` | `ICC_3V3_RAW` | — | `0x0000` | 3.3V rail current ADC count |
| `0x0300` | `TEMP_LOCAL` | — | `0x0190` | FPGA die temperature in 0.25°C units |
| `0x0301` | `TEMP_REMOTE1` | — | `0x0190` | Remote sensor 1 temperature (LNA area) |
| `0x0302` | `TEMP_REMOTE2` | — | `0x0190` | Remote sensor 2 temperature (Mixer area) |
| `0x0308` | `TEMP_ALERT_HIGH` | — | `0x0258` | Over-temperature alert threshold (100°C) |
| `0x0309` | `TEMP_ALERT_LOW` | — | `0xFF9C` | Under-temperature alert threshold (-25°C) |
| `0x030F` | `HEALTH_STATUS` | — | `0x00` | System health status flags |
| `0x0400` | `PLL_CTRL` | — | `0x00` | Si5345 PLL control register |
| `0x0401` | `PLL_STATUS` | — | `0x00` | PLL status flags |
| `0x0402` | `PLL_N_DIV` | — | `0x001E` | PLL N divider value (for Si5345 configuration) |
| `0x0403` | `PLL_R_DIV` | — | `0x000A` | PLL R divider value |
| `0x0410` | `CLK_ENABLE` | — | `0x00` | Clock output enables for Si5345 |
| `0x0500` | `EEPROM_CTRL` | — | `0x00` | EEPROM control register |
| `0x0501` | `EEPROM_ADDR` | — | `0x0000` | EEPROM byte address |
| `0x0502` | `EEPROM_DATA` | — | `0x0000` | EEPROM read/write data |
| `0x0600` | `FLASH_CTRL` | — | `0x00` | Configuration flash control |
| `0x0601` | `FLASH_ADDR_LOW` | — | `0x0000` | Flash address low word |
| `0x0602` | `FLASH_ADDR_HIGH` | — | `0x0000` | Flash address high byte |
| `0x0603` | `FLASH_DATA` | — | `0x0000` | Flash data FIFO |
| `0x0604` | `FLASH_STATUS` | — | `0x01` | Flash status register |
| `0x0700` | `RF_LNA_CTRL` | — | `0x00` | HMC698 LNA control register |
| `0x0701` | `RF_MIXER_CTRL` | — | `0x00` | HMC1119 Mixer control register |
| `0x0702` | `RF_LO_CTRL` | — | `0x00` | LO path control (HMC364 buffer) |
| `0x0703` | `RF_FREQ_BAND` | — | `0x00` | RF frequency band select |
| `0x0800` | `GPIO_CTRL` | — | `0x00` | GPIO direction and control |
| `0x0801` | `GPIO_INPUT` | — | `0x00` | GPIO input status |
| `0x0802` | `LED_CTRL` | — | `0x01` | LED indicator control |
| `0x0900` | `HSTC_CTRL` | — | `0x00` | HSTC high-speed interface control |
| `0x0901` | `HSTC_STATUS` | — | `0x00` | HSTC link status |
| `0x0902` | `DATA_FORMAT_CTRL` | — | `0x00` | IQ data format control |
| `0x0903` | `SAMPLE_RATE_CTRL` | — | `0x0004` | ADC sample rate divider (4 GSPS base) |
| `0x0A00` | `CALIBRATION_CTRL` | — | `0x00` | RF calibration control |
| `0x0B00` | `INTERRUPT_EN` | — | `0x00` | Interrupt enable register |
| `0x0B01` | `INTERRUPT_STATUS` | — | `0x00` | Interrupt status flags |
| `0x0FF0` | `SYSTEM_RESET` | — | `0x00` | System reset control |

---
### `BOARD_ID` — Address `0x0000`

**Reset value:** `0x5346`  **Access:** see fields below

Board identification code - ASCII 'SF' for sample_rf

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ID_CODE` | `[15:0]` | R | `0x5346` | Unique board identifier (ASCII 'SF' = 0x5346) |

---
### `BOARD_VERSION` — Address `0x0001`

**Reset value:** `0x10`  **Access:** see fields below

Hardware version number

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAJOR_VERSION` | `[7:4]` | R | `0x1` | Major hardware revision |
| `MINOR_VERSION` | `[3:0]` | R | `0x0` | Minor hardware revision |

---
### `BOARD_TYPE_ID` — Address `0x0002`

**Reset value:** `0x5252`  **Access:** see fields below

Board type identifier - RF Receiver

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TYPE_CODE` | `[15:0]` | R | `0x5252` | Board type code (0x5252 = RF Receiver) |

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
| `MAJOR_VER` | `[7:0]` | R | `0x01` | Major firmware version number |

---
### `MCS_VERSION_MINOR` — Address `0x0011`

**Reset value:** `0x00`  **Access:** see fields below

FPGA firmware minor version

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MINOR_VER` | `[7:0]` | R | `0x00` | Minor firmware version number |

---
### `BUILD_DATE` — Address `0x0012`

**Reset value:** `0x20260416`  **Access:** see fields below

Firmware build date in packed BCD (YYYYMMDD)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `YEAR` | `[15:12]` | R | `0x2` | Build year (BCD thousands) |
| `YEAR_LOW` | `[11:8]` | R | `0x0` | Build year (BCD hundreds) |
| `MONTH` | `[7:4]` | R | `0x4` | Build month (BCD) |
| `DAY` | `[3:0]` | R | `0x1` | Build day (BCD tens) |

---
### `UART_BAUD_DIV` — Address `0x0100`

**Reset value:** `0x0034`  **Access:** see fields below

UART baud rate divisor for 115200 baud @ 100MHz clock

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DIVISOR` | `[15:0]` | RW | `0x0034` | Baud rate divisor = CLK/(16*BAUD) |

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

UART status flags

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TX_BUSY` | `[0]` | R | `0` | Transmitter busy flag |
| `RX_AVAIL` | `[1]` | R | `0` | RX data available |
| `FRAME_ERR` | `[2]` | RC | `0` | Frame error (read-clear) |
| `OVERRUN_ERR` | `[3]` | RC | `0` | Overrun error (read-clear) |

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

Ethernet MAC address lower 16 bits

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAC_BYTE_1_0` | `[15:0]` | R | `0x0000` | MAC address bytes [1:0] |

---
### `ETH_MAC_HIGH` — Address `0x0111`

**Reset value:** `0x0000`  **Access:** see fields below

Ethernet MAC address upper 16 bits

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAC_BYTE_5_4` | `[15:0]` | R | `0x0000` | MAC address bytes [5:4] |

---
### `ADC_CTRL` — Address `0x0200`

**Reset value:** `0x00`  **Access:** see fields below

ADC control register for ADC12J4000

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `START` | `[0]` | RW | `0` | Start ADC conversion |
| `CONTINUOUS` | `[1]` | RW | `0` | Continuous sampling mode |
| `CHANNEL_SELECT` | `[3:2]` | RW | `0x0` | ADC channel select (0=I, 1=Q, 2=both) |
| `DDC_ENABLE` | `[4]` | RW | `0` | Enable digital down-converter |
| `POWER_DOWN` | `[7]` | RW | `0` | ADC power-down (1=PD) |

---
### `ADC_STATUS` — Address `0x0201`

**Reset value:** `0x00`  **Access:** see fields below

ADC status flags

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA_READY` | `[0]` | R | `0` | New IQ data available |
| `OVERRANGE` | `[1]` | RC | `0` | ADC overrange detected |
| `CAL_COMPLETE` | `[2]` | R | `0` | ADC calibration complete |
| `FIFO_FULL` | `[3]` | R | `0` | Sample FIFO full |

---
### `VCC_5V_RAW` — Address `0x0210`

**Reset value:** `0x0FFF`  **Access:** see fields below

5V rail ADC count (TPS7A4700 U5 output)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | R | `0x0FFF` | 12-bit ADC count, multiply by 5.0/4096 for Volts |

---
### `VCC_3V3_RAW` — Address `0x0211`

**Reset value:** `0x0FFF`  **Access:** see fields below

3.3V rail ADC count (TPS7A4700 U6 output)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | R | `0x0FFF` | 12-bit ADC count, multiply by 3.3/4096 for Volts |

---
### `VCC_1V8_RAW` — Address `0x0213`

**Reset value:** `0x0FFF`  **Access:** see fields below

1.8V rail ADC count (TPS62130 output)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | R | `0x0FFF` | 12-bit ADC count, multiply by 1.8/4096 for Volts |

---
### `ICC_5V_RAW` — Address `0x0218`

**Reset value:** `0x0000`  **Access:** see fields below

5V rail current ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | R | `0x0000` | 12-bit current sense ADC count |

---
### `ICC_3V3_RAW` — Address `0x0219`

**Reset value:** `0x0000`  **Access:** see fields below

3.3V rail current ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | R | `0x0000` | 12-bit current sense ADC count |

---
### `TEMP_LOCAL` — Address `0x0300`

**Reset value:** `0x0190`  **Access:** see fields below

FPGA die temperature in 0.25°C units

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_VALUE` | `[9:0]` | R | `0x0190` | Temperature = value * 0.25°C (signed) |

---
### `TEMP_REMOTE1` — Address `0x0301`

**Reset value:** `0x0190`  **Access:** see fields below

Remote sensor 1 temperature (LNA area)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_VALUE` | `[9:0]` | R | `0x0190` | Remote temperature sensor 1 reading |

---
### `TEMP_REMOTE2` — Address `0x0302`

**Reset value:** `0x0190`  **Access:** see fields below

Remote sensor 2 temperature (Mixer area)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_VALUE` | `[9:0]` | R | `0x0190` | Remote temperature sensor 2 reading |

---
### `TEMP_ALERT_HIGH` — Address `0x0308`

**Reset value:** `0x0258`  **Access:** see fields below

Over-temperature alert threshold (100°C)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ALERT_THRESH` | `[9:0]` | RW | `0x0258` | High temperature threshold (600 = 150°C max, default 100°C) |

---
### `TEMP_ALERT_LOW` — Address `0x0309`

**Reset value:** `0xFF9C`  **Access:** see fields below

Under-temperature alert threshold (-25°C)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ALERT_THRESH` | `[9:0]` | RW | `0xFF9C` | Low temperature threshold (signed, -25°C) |

---
### `HEALTH_STATUS` — Address `0x030F`

**Reset value:** `0x00`  **Access:** see fields below

System health status flags

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_OK` | `[0]` | R | `0` | Temperature within limits |
| `VOLT_OK` | `[1]` | R | `0` | Power rails within tolerance |
| `PLL_LOCK` | `[2]` | R | `0` | Si5345 PLL locked |
| `ADC_READY` | `[3]` | R | `0` | ADC ready flag |
| `SYSTEM_OK` | `[7]` | R | `0` | Overall system healthy |

---
### `PLL_CTRL` — Address `0x0400`

**Reset value:** `0x00`  **Access:** see fields below

Si5345 PLL control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0` | Enable Si5345 PLL |
| `RESET` | `[1]` | RW | `0` | Assert PLL reset |
| `REF_SEL` | `[3:2]` | RW | `0x0` | Reference clock select (0=external, 1=crystal) |
| `LOW_NOISE_MODE` | `[4]` | RW | `0` | Low noise mode enable |

---
### `PLL_STATUS` — Address `0x0401`

**Reset value:** `0x00`  **Access:** see fields below

PLL status flags

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LOCKED` | `[0]` | R | `0` | PLL lock acquired |
| `LOSS_OF_LOCK` | `[1]` | RC | `0` | PLL loss of lock (read-clear) |
| `HOLDOVER` | `[2]` | R | `0` | PLL in holdover mode |

---
### `PLL_N_DIV` — Address `0x0402`

**Reset value:** `0x001E`  **Access:** see fields below

PLL N divider value (for Si5345 configuration)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `N_DIVIDER` | `[15:0]` | RW | `0x001E` | N feedback divider value |

---
### `PLL_R_DIV` — Address `0x0403`

**Reset value:** `0x000A`  **Access:** see fields below

PLL R divider value

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `R_DIVIDER` | `[7:0]` | RW | `0x0A` | R reference divider value |

---
### `CLK_ENABLE` — Address `0x0410`

**Reset value:** `0x00`  **Access:** see fields below

Clock output enables for Si5345

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `CLK_ADC_EN` | `[0]` | RW | `0` | Enable ADC clock output |
| `CLK_FPGA_EN` | `[1]` | RW | `0` | Enable FPGA clock output |
| `CLK_REF_EN` | `[2]` | RW | `0` | Enable reference clock output |
| `CLK_DAC_EN` | `[3]` | RW | `0` | Enable DAC clock output |

---
### `EEPROM_CTRL` — Address `0x0500`

**Reset value:** `0x00`  **Access:** see fields below

EEPROM control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READ` | `[0]` | RW | `0` | Start EEPROM read |
| `WRITE` | `[1]` | RW | `0` | Start EEPROM write |
| `ERASE` | `[2]` | RW | `0` | Erase EEPROM page |
| `BUSY` | `[7]` | R | `0` | EEPROM operation in progress |

---
### `EEPROM_ADDR` — Address `0x0501`

**Reset value:** `0x0000`  **Access:** see fields below

EEPROM byte address

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BYTE_ADDR` | `[15:0]` | RW | `0x0000` | 16-bit EEPROM byte address |

---
### `EEPROM_DATA` — Address `0x0502`

**Reset value:** `0x0000`  **Access:** see fields below

EEPROM read/write data

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA_WORD` | `[15:0]` | RW | `0x0000` | 16-bit data word |

---
### `FLASH_CTRL` — Address `0x0600`

**Reset value:** `0x00`  **Access:** see fields below

Configuration flash control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READ` | `[0]` | RW | `0` | Start flash read |
| `WRITE` | `[1]` | RW | `0` | Start flash write |
| `ERASE_SECTOR` | `[2]` | RW | `0` | Erase flash sector |
| `ERASE_CHIP` | `[3]` | RW | `0` | Erase entire chip |
| `BUSY` | `[7]` | R | `0` | Flash operation busy |

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

Flash address high byte

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADDR_HIGH` | `[7:0]` | RW | `0x00` | Flash address bits [23:16] |

---
### `FLASH_DATA` — Address `0x0603`

**Reset value:** `0x0000`  **Access:** see fields below

Flash data FIFO

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA_FIFO` | `[15:0]` | RW | `0x0000` | Flash read/write data |

---
### `FLASH_STATUS` — Address `0x0604`

**Reset value:** `0x01`  **Access:** see fields below

Flash status register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READY` | `[0]` | R | `1` | Flash ready for commands |
| `WRITE_ERR` | `[1]` | RC | `0` | Write error (read-clear) |
| `ERASE_ERR` | `[2]` | RC | `0` | Erase error (read-clear) |

---
### `RF_LNA_CTRL` — Address `0x0700`

**Reset value:** `0x00`  **Access:** see fields below

HMC698 LNA control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LNA_ENABLE` | `[0]` | RW | `0` | Enable HMC698 LNA |
| `GAIN_SELECT` | `[2:1]` | RW | `0x0` | LNA gain setting (0=low, 1=med, 2=high) |
| `BYPASS` | `[3]` | RW | `0` | LNA bypass mode |

---
### `RF_MIXER_CTRL` — Address `0x0701`

**Reset value:** `0x00`  **Access:** see fields below

HMC1119 Mixer control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MIXER_ENABLE` | `[0]` | RW | `0` | Enable HMC1119 mixer |
| `IF_GAIN` | `[3:1]` | RW | `0x0` | IF gain control (0-7) |
| `IQ_SWAP` | `[4]` | RW | `0` | Swap I/Q outputs |

---
### `RF_LO_CTRL` — Address `0x0702`

**Reset value:** `0x00`  **Access:** see fields below

LO path control (HMC364 buffer)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LO_BUFFER_EN` | `[0]` | RW | `0` | Enable HMC364 LO buffer |
| `LO_PWR_DN` | `[1]` | RW | `0` | LO power down |

---
### `RF_FREQ_BAND` — Address `0x0703`

**Reset value:** `0x00`  **Access:** see fields below

RF frequency band select

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BAND_SELECT` | `[3:0]` | RW | `0x0` | Frequency band (0=5-6GHz, 1=6-8GHz, 2=8-12GHz, 3=12-18GHz) |

---
### `GPIO_CTRL` — Address `0x0800`

**Reset value:** `0x00`  **Access:** see fields below

GPIO direction and control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GPIO_OE` | `[7:0]` | RW | `0x00` | GPIO output enable (1=output) |
| `GPIO_DATA` | `[15:8]` | RW | `0x00` | GPIO output data |

---
### `GPIO_INPUT` — Address `0x0801`

**Reset value:** `0x00`  **Access:** see fields below

GPIO input status

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GPIO_IN` | `[7:0]` | R | `0x00` | GPIO input pin states |

---
### `LED_CTRL` — Address `0x0802`

**Reset value:** `0x01`  **Access:** see fields below

LED indicator control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LED_PWR` | `[0]` | RW | `1` | Power LED (1=on) |
| `LED_ACT` | `[1]` | RW | `0` | Activity LED |
| `LED_ERR` | `[2]` | RW | `0` | Error LED |
| `LED_RF_EN` | `[3]` | RW | `0` | RF enabled indicator |

---
### `HSTC_CTRL` — Address `0x0900`

**Reset value:** `0x00`  **Access:** see fields below

HSTC high-speed interface control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LINK_ENABLE` | `[0]` | RW | `0` | Enable HSTC link |
| `LANE_MODE` | `[2:1]` | RW | `0x0` | Lane mode (0=1x, 1=2x, 2=4x) |
| `TERM_EN` | `[3]` | RW | `0` | Enable on-board termination |

---
### `HSTC_STATUS` — Address `0x0901`

**Reset value:** `0x00`  **Access:** see fields below

HSTC link status

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LINK_UP` | `[0]` | R | `0` | HSTC link established |
| `LANE_SYNC` | `[4:1]` | R | `0x0` | Per-lane sync status |
| `PARITY_ERR` | `[7]` | RC | `0` | Parity error detected |

---
### `DATA_FORMAT_CTRL` — Address `0x0902`

**Reset value:** `0x00`  **Access:** see fields below

IQ data format control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BIT_ORDER` | `[0]` | RW | `0` | Bit order (0=MSB first, 1=LSB first) |
| `INTERLEAVE` | `[1]` | RW | `0` | I/Q interleaving (0=I then Q, 1=interleaved) |
| `WORD_SIZE` | `[4:2]` | RW | `0x2` | Word size (0=8b, 1=10b, 2=12b, 3=16b) |
| `OFFSET_BINARY` | `[5]` | RW | `0` | Offset binary (1) vs 2's complement (0) |

---
### `SAMPLE_RATE_CTRL` — Address `0x0903`

**Reset value:** `0x0004`  **Access:** see fields below

ADC sample rate divider (4 GSPS base)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DECIMATION` | `[15:0]` | RW | `0x0004` | Decimation factor (1-4096) |

---
### `CALIBRATION_CTRL` — Address `0x0A00`

**Reset value:** `0x00`  **Access:** see fields below

RF calibration control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `START_CAL` | `[0]` | RW | `0` | Start calibration sequence |
| `DC_OFFSET_CORR` | `[1]` | RW | `0` | Enable DC offset correction |
| `IQ_IMBALANCE_CORR` | `[2]` | RW | `0` | Enable IQ imbalance correction |
| `CAL_BUSY` | `[7]` | R | `0` | Calibration in progress |

---
### `INTERRUPT_EN` — Address `0x0B00`

**Reset value:** `0x00`  **Access:** see fields below

Interrupt enable register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_ALERT_EN` | `[0]` | RW | `0` | Temperature alert interrupt |
| `VOLT_ALERT_EN` | `[1]` | RW | `0` | Voltage alert interrupt |
| `ADC_READY_EN` | `[2]` | RW | `0` | ADC ready interrupt |
| `PLL_LOSS_EN` | `[3]` | RW | `0` | PLL loss-of-lock interrupt |
| `HSTC_ERR_EN` | `[4]` | RW | `0` | HSTC error interrupt |

---
### `INTERRUPT_STATUS` — Address `0x0B01`

**Reset value:** `0x00`  **Access:** see fields below

Interrupt status flags

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_ALERT` | `[0]` | RC | `0` | Temperature alert pending |
| `VOLT_ALERT` | `[1]` | RC | `0` | Voltage alert pending |
| `ADC_READY` | `[2]` | RC | `0` | ADC ready pending |
| `PLL_LOSS` | `[3]` | RC | `0` | PLL loss-of-lock pending |
| `HSTC_ERR` | `[4]` | RC | `0` | HSTC error pending |

---
### `SYSTEM_RESET` — Address `0x0FF0`

**Reset value:** `0x00`  **Access:** see fields below

System reset control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `RESET_FPGA` | `[0]` | RW | `0` | Reset FPGA core |
| `RESET_ADC` | `[1]` | RW | `0` | Reset ADC interface |
| `RESET_RF` | `[2]` | RW | `0` | Reset RF chain |
| `GLOBAL_RESET` | `[7]` | RW | `0` | Global system reset |
