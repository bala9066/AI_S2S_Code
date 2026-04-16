# Register Description Table (RDT)
## khgk

> **Total registers:** 57

Register Map for khgk Wideband RF Receiver Module (5-18 GHz). Includes Board Info (0x000), UART Comm (0x100), ADC JESD204B Interface (0x200), RF Front-End Control (0x700), DVGA Gain (0x701), LMX2594 PLL Synthesizer (0x702-0x705), Temperature/Health (0x300-0x30F), Power Monitor LTC2945 via I2C (0x308-0x30C), Clock Distribution (0x400), GPIO/RF Path Enable (0x800), SPI Master Control (0x804), ATtiny1606 MCU Interface (0x505), and Configuration Flash (0x600-0x604).

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
| `0x0000` | `BOARD_ID` | — | `0x0000` | Board identification code - uniquely identifies khgk Wideband RF Receiver Module |
| `0x0001` | `BOARD_VERSION` | — | `0x0000` | Hardware revision number - major.minor format |
| `0x0002` | `BOARD_TYPE_ID` | — | `0x0000` | Board type identifier for firmware compatibility check |
| `0x0003` | `SCRATCHPAD` | — | `0x0000` | Diagnostic read/write test register for RAM verification |
| `0x0010` | `MCS_VERSION_MAJOR` | — | `0x0000` | FPGA firmware major version number |
| `0x0011` | `MCS_VERSION_MINOR` | — | `0x0000` | FPGA firmware minor version number |
| `0x0012` | `BUILD_DATE` | — | `0x0000` | FPGA build date in packed BCD format (YYYYMMDD) |
| `0x0100` | `UART_BAUD_DIV` | — | `0x0000` | UART baud rate divisor for host communication |
| `0x0101` | `UART_CTRL` | — | `0x0000` | UART control register for enable and loopback mode |
| `0x0102` | `UART_STATUS` | — | `0x0000` | UART status flags (read-clear) |
| `0x0103` | `UART_TX_COUNT` | — | `0x0000` | TX FIFO byte count |
| `0x0104` | `UART_RX_COUNT` | — | `0x0000` | RX FIFO byte count |
| `0x0110` | `ETH_MAC_LOW` | — | `0x0000` | Ethernet MAC address lower 16 bits (future expansion) |
| `0x0111` | `ETH_MAC_HIGH` | — | `0x0000` | Ethernet MAC address upper 16 bits |
| `0x0200` | `ADC_JESD_CTRL` | — | `0x0000` | ADC12J4000 JESD204B interface control |
| `0x0201` | `ADC_JESD_STATUS` | — | `0x0000` | JESD204B link status monitoring |
| `0x0210` | `VCC_5V_RAW` | — | `0x0000` | 5V rail ADC raw count |
| `0x0211` | `VCC_3V3_RAW` | — | `0x0000` | 3.3V rail ADC raw count |
| `0x0212` | `VCC_2V5_RAW` | — | `0x0000` | 2.5V rail ADC raw count |
| `0x0213` | `VCC_1V8_RAW` | — | `0x0000` | 1.8V rail ADC raw count |
| `0x0218` | `ICC_5V_RAW` | — | `0x0000` | 5V rail current ADC count |
| `0x0219` | `ICC_3V3_RAW` | — | `0x0000` | 3.3V rail current ADC count |
| `0x0300` | `TEMP_LOCAL` | — | `0x0000` | FPGA die temperature in 0.25°C units (signed) |
| `0x0301` | `TEMP_REMOTE1` | — | `0x0000` | Remote sensor 1 temperature (LNA area) |
| `0x0302` | `TEMP_REMOTE2` | — | `0x0000` | Remote sensor 2 temperature (ADC area) |
| `0x0303` | `V_12V_MONITOR` | — | `0x0000` | 12V RF rail voltage via LTC2945 I2C |
| `0x0304` | `I_12V_MONITOR` | — | `0x0000` | 12V RF rail current via LTC2945 I2C |
| `0x0305` | `V_NEG5V_MONITOR` | — | `0x0000` | -5V DVGA bias rail via LTC2945 I2C |
| `0x0308` | `TEMP_ALERT_HIGH` | — | `0x0000` | Over-temperature alert threshold |
| `0x0309` | `TEMP_ALERT_LOW` | — | `0x0000` | Under-temperature alert threshold |
| `0x030F` | `HEALTH_STATUS` | — | `0x0000` | System health summary flags |
| `0x0400` | `PLL_CTRL` | — | `0x0000` | LMX2594 PLL control register |
| `0x0401` | `PLL_STATUS` | — | `0x0000` | LMX2594 PLL status flags |
| `0x0402` | `PLL_N_DIV` | — | `0x0000` | PLL N divider value (LMX2594) |
| `0x0403` | `PLL_R_DIV` | — | `0x0000` | PLL R divider value (LMX2594) |
| `0x0410` | `CLK_ENABLE` | — | `0x0000` | Clock output enables |
| `0x0500` | `EEPROM_CTRL` | — | `0x0000` | ATtiny1606 MCU EEPROM access control |
| `0x0501` | `EEPROM_ADDR` | — | `0x0000` | ATtiny1606 EEPROM address |
| `0x0502` | `EEPROM_DATA` | — | `0x0000` | ATtiny1606 EEPROM data |
| `0x0505` | `MCU_STATUS` | — | `0x0000` | ATtiny1606 MCU status register |
| `0x0600` | `FLASH_CTRL` | — | `0x0000` | Configuration flash control register |
| `0x0601` | `FLASH_ADDR_LOW` | — | `0x0000` | Flash address low word |
| `0x0602` | `FLASH_ADDR_HIGH` | — | `0x0000` | Flash address high word |
| `0x0603` | `FLASH_DATA` | — | `0x0000` | Flash data FIFO |
| `0x0604` | `FLASH_STATUS` | — | `0x0000` | Flash operation status |
| `0x0700` | `RF_PATH_ENABLE` | — | `0x0000` | RF path power enable (Q1 MOSFET control) |
| `0x0701` | `DVGA_GAIN_CTRL` | — | `0x0000` | HMC698LP4 DVGA gain control (5-bit, 1dB steps) |
| `0x0702` | `MIXER_LO_FREQ` | — | `0x0000` | LO frequency for HMC525LC4 mixer |
| `0x0703` | `PLL_FREQ_TARGET` | — | `0x0000` | LMX2594 target frequency command |
| `0x0704` | `RF_BAND_SELECT` | — | `0x0000` | RF band selection for optimized LNA bias |
| `0x0800` | `GPIO_DIR` | — | `0x0000` | GPIO direction control |
| `0x0801` | `GPIO_DATA` | — | `0x0000` | GPIO data read/write |
| `0x0802` | `GPIO_INPUT` | — | `0x0000` | GPIO input status |
| `0x0804` | `SPI_CTRL` | — | `0x0000` | SPI master control for PLL/DVGA/ADC |
| `0x0805` | `SPI_TX_DATA` | — | `0x0000` | SPI transmit data (16-bit) |
| `0x0806` | `SPI_RX_DATA` | — | `0x0000` | SPI receive data (read-only) |
| `0x0807` | `SPI_STATUS` | — | `0x0000` | SPI transaction status |

---
### `BOARD_ID` — Address `0x0000`

**Reset value:** `0x0000`  **Access:** see fields below

Board identification code - uniquely identifies khgk Wideband RF Receiver Module

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BOARD_ID` | `[15:0]` | RO | `0x4B48` | ASCII 'KH' (0x4B48) - khgk board identifier |

---
### `BOARD_VERSION` — Address `0x0001`

**Reset value:** `0x0000`  **Access:** see fields below

Hardware revision number - major.minor format

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAJOR` | `[7:4]` | RO | `0x1` | Major revision |
| `MINOR` | `[3:0]` | RO | `0x0` | Minor revision |

---
### `BOARD_TYPE_ID` — Address `0x0002`

**Reset value:** `0x0000`  **Access:** see fields below

Board type identifier for firmware compatibility check

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TYPE_ID` | `[15:0]` | RO | `0x5246` | ASCII 'RF' - RF Receiver Module type code |

---
### `SCRATCHPAD` — Address `0x0003`

**Reset value:** `0x0000`  **Access:** see fields below

Diagnostic read/write test register for RAM verification

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEST_PATTERN` | `[15:0]` | RW | `0x0000` | Read/write test value - verify data path integrity |

---
### `MCS_VERSION_MAJOR` — Address `0x0010`

**Reset value:** `0x0000`  **Access:** see fields below

FPGA firmware major version number

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAJOR_VER` | `[7:0]` | RO | `0x01` | Major firmware version |

---
### `MCS_VERSION_MINOR` — Address `0x0011`

**Reset value:** `0x0000`  **Access:** see fields below

FPGA firmware minor version number

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MINOR_VER` | `[7:0]` | RO | `0x00` | Minor firmware version |

---
### `BUILD_DATE` — Address `0x0012`

**Reset value:** `0x0000`  **Access:** see fields below

FPGA build date in packed BCD format (YYYYMMDD)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `YEAR_BCD` | `[15:12]` | RO | `0x2` | Year (decades) |
| `MONTH_BCD` | `[11:8]` | RO | `0x6` | Month (BCD) |
| `DAY_BCD` | `[7:0]` | RO | `0x16` | Day (BCD) |

---
### `UART_BAUD_DIV` — Address `0x0100`

**Reset value:** `0x0000`  **Access:** see fields below

UART baud rate divisor for host communication

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DIVISOR` | `[15:0]` | RW | `0x0034` | Baud divisor (0x0034 = 115200 @ 16MHz ref) |

---
### `UART_CTRL` — Address `0x0101`

**Reset value:** `0x0000`  **Access:** see fields below

UART control register for enable and loopback mode

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0x0` | UART enable (1=enabled) |
| `LOOPBACK` | `[1]` | RW | `0x0` | Loopback mode for test (1=loopback) |
| `FRAME_FORMAT` | `[7:4]` | RW | `0x3` | Frame format (0x3=8N1) |

---
### `UART_STATUS` — Address `0x0102`

**Reset value:** `0x0000`  **Access:** see fields below

UART status flags (read-clear)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TX_BUSY` | `[0]` | R | `0x0` | TX FIFO busy |
| `RX_AVAIL` | `[1]` | RC | `0x0` | RX data available (clear on read) |
| `FRAME_ERR` | `[2]` | RC | `0x0` | Frame error detected |

---
### `UART_TX_COUNT` — Address `0x0103`

**Reset value:** `0x0000`  **Access:** see fields below

TX FIFO byte count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TX_COUNT` | `[7:0]` | RO | `0x00` | Number of bytes in TX FIFO |

---
### `UART_RX_COUNT` — Address `0x0104`

**Reset value:** `0x0000`  **Access:** see fields below

RX FIFO byte count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `RX_COUNT` | `[7:0]` | RO | `0x00` | Number of bytes in RX FIFO |

---
### `ETH_MAC_LOW` — Address `0x0110`

**Reset value:** `0x0000`  **Access:** see fields below

Ethernet MAC address lower 16 bits (future expansion)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAC_LOW` | `[15:0]` | RO | `0x0000` | MAC address bits [15:0] |

---
### `ETH_MAC_HIGH` — Address `0x0111`

**Reset value:** `0x0000`  **Access:** see fields below

Ethernet MAC address upper 16 bits

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAC_HIGH` | `[15:0]` | RO | `0x0000` | MAC address bits [31:16] |

---
### `ADC_JESD_CTRL` — Address `0x0200`

**Reset value:** `0x0000`  **Access:** see fields below

ADC12J4000 JESD204B interface control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LINK_EN` | `[0]` | RW | `0x0` | JESD204B link enable |
| `SOFT_RESET` | `[1]` | RW | `0x0` | ADC soft reset |
| `LANE_SEL` | `[4:2]` | RW | `0x4` | Number of lanes (4=4-lane mode) |
| `SUBCLASS` | `[6:5]` | RW | `0x0` | JESD subclass (0=0, 1=1) |

---
### `ADC_JESD_STATUS` — Address `0x0201`

**Reset value:** `0x0000`  **Access:** see fields below

JESD204B link status monitoring

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LINK_LOCK` | `[0]` | RO | `0x0` | Code group sync achieved (1=locked) |
| `SYNC_ERR` | `[1]` | RC | `0x0` | Sync error (clear on read) |
| `DISP_ERR` | `[2]` | RC | `0x0` | Disparity error |

---
### `VCC_5V_RAW` — Address `0x0210`

**Reset value:** `0x0000`  **Access:** see fields below

5V rail ADC raw count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | RO | `0x0800` | 5V ADC count (multiply by 5.0/4096) |

---
### `VCC_3V3_RAW` — Address `0x0211`

**Reset value:** `0x0000`  **Access:** see fields below

3.3V rail ADC raw count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | RO | `0x0CCC` | 3.3V ADC count |

---
### `VCC_2V5_RAW` — Address `0x0212`

**Reset value:** `0x0000`  **Access:** see fields below

2.5V rail ADC raw count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | RO | `0x0800` | 2.5V ADC count |

---
### `VCC_1V8_RAW` — Address `0x0213`

**Reset value:** `0x0000`  **Access:** see fields below

1.8V rail ADC raw count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | RO | `0x0733` | 1.8V ADC count |

---
### `ICC_5V_RAW` — Address `0x0218`

**Reset value:** `0x0000`  **Access:** see fields below

5V rail current ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | RO | `0x0000` | 5V current ADC count |

---
### `ICC_3V3_RAW` — Address `0x0219`

**Reset value:** `0x0000`  **Access:** see fields below

3.3V rail current ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | RO | `0x0000` | 3.3V current ADC count |

---
### `TEMP_LOCAL` — Address `0x0300`

**Reset value:** `0x0000`  **Access:** see fields below

FPGA die temperature in 0.25°C units (signed)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_VALUE` | `[9:0]` | RO | `0x0064` | Temperature (0x64 = 25.0°C) |

---
### `TEMP_REMOTE1` — Address `0x0301`

**Reset value:** `0x0000`  **Access:** see fields below

Remote sensor 1 temperature (LNA area)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_VALUE` | `[9:0]` | RO | `0x0064` | Remote temp 1 |

---
### `TEMP_REMOTE2` — Address `0x0302`

**Reset value:** `0x0000`  **Access:** see fields below

Remote sensor 2 temperature (ADC area)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_VALUE` | `[9:0]` | RO | `0x0064` | Remote temp 2 |

---
### `V_12V_MONITOR` — Address `0x0303`

**Reset value:** `0x0000`  **Access:** see fields below

12V RF rail voltage via LTC2945 I2C

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `VOLTAGE` | `[15:0]` | RO | `0x0000` | 12V scaled voltage reading (mV units) |

---
### `I_12V_MONITOR` — Address `0x0304`

**Reset value:** `0x0000`  **Access:** see fields below

12V RF rail current via LTC2945 I2C

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `CURRENT` | `[15:0]` | RO | `0x0000` | 12V current reading (mA units) |

---
### `V_NEG5V_MONITOR` — Address `0x0305`

**Reset value:** `0x0000`  **Access:** see fields below

-5V DVGA bias rail via LTC2945 I2C

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `VOLTAGE` | `[15:0]` | RO | `0x0000` | -5V rail voltage (mV units, signed) |

---
### `TEMP_ALERT_HIGH` — Address `0x0308`

**Reset value:** `0x0000`  **Access:** see fields below

Over-temperature alert threshold

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `THRESHOLD` | `[9:0]` | RW | `0x0190` | High temp alert (0x190 = 100°C) |

---
### `TEMP_ALERT_LOW` — Address `0x0309`

**Reset value:** `0x0000`  **Access:** see fields below

Under-temperature alert threshold

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `THRESHOLD` | `[9:0]` | RW | `0xFF9C` | Low temp alert (0xFF9C = -25°C signed) |

---
### `HEALTH_STATUS` — Address `0x030F`

**Reset value:** `0x0000`  **Access:** see fields below

System health summary flags

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_OK` | `[0]` | RO | `0x1` | Temperature within range (1=OK) |
| `VOLT_OK` | `[1]` | RO | `0x1` | Power rails valid (1=OK) |
| `PLL_LOCK` | `[2]` | RO | `0x0` | PLL locked (1=LOCKED) |
| `JESD_LINK_OK` | `[3]` | RO | `0x0` | JESD link locked (1=OK) |
| `SYSTEM_OK` | `[7]` | RO | `0x0` | Overall system health (1=ALL OK) |

---
### `PLL_CTRL` — Address `0x0400`

**Reset value:** `0x0000`  **Access:** see fields below

LMX2594 PLL control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0x0` | PLL enable (1=enabled) |
| `RESET` | `[1]` | RW | `0x0` | PLL soft reset (active high) |
| `REF_SEL` | `[3:2]` | RW | `0x0` | Reference clock select (00=10MHz, 01=100MHz) |

---
### `PLL_STATUS` — Address `0x0401`

**Reset value:** `0x0000`  **Access:** see fields below

LMX2594 PLL status flags

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LOCKED` | `[0]` | RO | `0x0` | PLL lock detect (1=locked) |
| `LOSS_OF_LOCK` | `[1]` | RC | `0x0` | PLL loss of lock flag (clear on read) |

---
### `PLL_N_DIV` — Address `0x0402`

**Reset value:** `0x0000`  **Access:** see fields below

PLL N divider value (LMX2594)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `N_DIVIDER` | `[15:0]` | RW | `0x0064` | N divider (16-bit, range per datasheet) |

---
### `PLL_R_DIV` — Address `0x0403`

**Reset value:** `0x0000`  **Access:** see fields below

PLL R divider value (LMX2594)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `R_DIVIDER` | `[7:0]` | RW | `0x0001` | R divider (1-255) |

---
### `CLK_ENABLE` — Address `0x0410`

**Reset value:** `0x0000`  **Access:** see fields below

Clock output enables

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `CLK_OUT_EN` | `[7:0]` | RW | `0x0F` | Clock output enables [7:0] - one per output |

---
### `EEPROM_CTRL` — Address `0x0500`

**Reset value:** `0x0000`  **Access:** see fields below

ATtiny1606 MCU EEPROM access control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READ` | `[0]` | RW | `0x0` | Start EEPROM read (1=trigger) |
| `WRITE` | `[1]` | RW | `0x0` | Start EEPROM write (1=trigger) |
| `BUSY` | `[7]` | RO | `0x0` | MCU busy flag (1=operation in progress) |

---
### `EEPROM_ADDR` — Address `0x0501`

**Reset value:** `0x0000`  **Access:** see fields below

ATtiny1606 EEPROM address

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADDR` | `[15:0]` | RW | `0x0000` | 16-bit EEPROM address |

---
### `EEPROM_DATA` — Address `0x0502`

**Reset value:** `0x0000`  **Access:** see fields below

ATtiny1606 EEPROM data

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA` | `[15:0]` | RW | `0x0000` | 16-bit EEPROM data word |

---
### `MCU_STATUS` — Address `0x0505`

**Reset value:** `0x0000`  **Access:** see fields below

ATtiny1606 MCU status register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ALIVE` | `[0]` | RO | `0x1` | MCU heartbeat (1=alive) |
| `EEPROM_READY` | `[1]` | RO | `0x1` | EEPROM ready (1=ready) |
| `CAL_VALID` | `[2]` | RO | `0x0` | Calibration data valid (1=valid) |

---
### `FLASH_CTRL` — Address `0x0600`

**Reset value:** `0x0000`  **Access:** see fields below

Configuration flash control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READ` | `[0]` | RW | `0x0` | Flash read enable |
| `WRITE` | `[1]` | RW | `0x0` | Flash write enable |
| `ERASE_SECTOR` | `[2]` | RW | `0x0` | Sector erase command |
| `ERASE_CHIP` | `[3]` | RW | `0x0` | Chip erase command |
| `BUSY` | `[7]` | RO | `0x0` | Flash busy flag |

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

Flash address high word

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADDR_HIGH` | `[7:0]` | RW | `0x00` | Flash address [23:16] |

---
### `FLASH_DATA` — Address `0x0603`

**Reset value:** `0x0000`  **Access:** see fields below

Flash data FIFO

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA` | `[15:0]` | RW | `0x0000` | Flash read/write data |

---
### `FLASH_STATUS` — Address `0x0604`

**Reset value:** `0x0000`  **Access:** see fields below

Flash operation status

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READY` | `[0]` | RO | `0x1` | Flash ready (1=ready) |
| `WRITE_ERR` | `[1]` | RC | `0x0` | Write error flag |
| `ERASE_ERR` | `[2]` | RC | `0x0` | Erase error flag |

---
### `RF_PATH_ENABLE` — Address `0x0700`

**Reset value:** `0x0000`  **Access:** see fields below

RF path power enable (Q1 MOSFET control)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `RF_EN` | `[0]` | RW | `0x0` | RF path enable (1=ON) |
| `LNA_EN` | `[1]` | RW | `0x0` | LNA enable (1=ON) |
| `MIXER_EN` | `[2]` | RW | `0x0` | Mixer enable (1=ON) |
| `DVGA_EN` | `[3]` | RW | `0x0` | DVGA enable (1=ON) |

---
### `DVGA_GAIN_CTRL` — Address `0x0701`

**Reset value:** `0x0000`  **Access:** see fields below

HMC698LP4 DVGA gain control (5-bit, 1dB steps)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GAIN_CODE` | `[4:0]` | RW | `0x0F` | Gain code (0-31 = -10dB to +21dB, 1dB steps) |
| `GAIN_UPDATE` | `[7]` | RW | `0x0` | Trigger gain update (1=update, self-clearing) |

---
### `MIXER_LO_FREQ` — Address `0x0702`

**Reset value:** `0x0000`  **Access:** see fields below

LO frequency for HMC525LC4 mixer

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `FREQ_MHZ` | `[15:0]` | RW | `0x1388` | LO frequency in MHz (default 5000 MHz) |

---
### `PLL_FREQ_TARGET` — Address `0x0703`

**Reset value:** `0x0000`  **Access:** see fields below

LMX2594 target frequency command

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `FREQ_GHZ` | `[15:0]` | RW | `0x09C4` | Target frequency in 0.01 GHz units (default 10.0 GHz = 0x09C4) |

---
### `RF_BAND_SELECT` — Address `0x0704`

**Reset value:** `0x0000`  **Access:** see fields below

RF band selection for optimized LNA bias

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BAND_SEL` | `[3:0]` | RW | `0x0` | Band select (0=5-8GHz, 1=8-12GHz, 2=12-18GHz) |

---
### `GPIO_DIR` — Address `0x0800`

**Reset value:** `0x0000`  **Access:** see fields below

GPIO direction control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GPIO_DIR` | `[15:0]` | RW | `0x0000` | GPIO direction (0=input, 1=output) |

---
### `GPIO_DATA` — Address `0x0801`

**Reset value:** `0x0000`  **Access:** see fields below

GPIO data read/write

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GPIO_OUT` | `[15:0]` | RW | `0x0000` | GPIO output data |

---
### `GPIO_INPUT` — Address `0x0802`

**Reset value:** `0x0000`  **Access:** see fields below

GPIO input status

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GPIO_IN` | `[15:0]` | RO | `0x0000` | GPIO input data |

---
### `SPI_CTRL` — Address `0x0804`

**Reset value:** `0x0000`  **Access:** see fields below

SPI master control for PLL/DVGA/ADC

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `SPI_EN` | `[0]` | RW | `0x1` | SPI master enable |
| `CS_SEL` | `[3:2]` | RW | `0x0` | Chip select (00=PLL, 01=DVGA, 10=ADC) |
| `CLK_DIV` | `[7:4]` | RW | `0x3` | SPI clock divisor |

---
### `SPI_TX_DATA` — Address `0x0805`

**Reset value:** `0x0000`  **Access:** see fields below

SPI transmit data (16-bit)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TX_DATA` | `[15:0]` | RW | `0x0000` | 16-bit SPI transmit data |

---
### `SPI_RX_DATA` — Address `0x0806`

**Reset value:** `0x0000`  **Access:** see fields below

SPI receive data (read-only)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `RX_DATA` | `[15:0]` | RO | `0x0000` | 16-bit SPI receive data |

---
### `SPI_STATUS` — Address `0x0807`

**Reset value:** `0x0000`  **Access:** see fields below

SPI transaction status

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TX_DONE` | `[0]` | RO | `0x1` | Transmit complete (1=done) |
| `RX_AVAIL` | `[1]` | RO | `0x0` | Receive data available |
| `BUSY` | `[7]` | RO | `0x0` | SPI transaction busy |
