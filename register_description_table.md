# Register Description Table (RDT)
## dghb

> **Total registers:** 50

DGHB RF Signal Processing Board - Register map for Kintex-7 FPGA controlling JESD204B ADC interface (ADC12DJ5200RF), dual PLL clock generator (LMK04828), VGA (HMC698LP4), LED driver (TLC6C5712), LDO power sequencing, and system monitoring via UART (115200 bps default). 34 registers defined across 10 functional groups with 18-step initialization sequence.

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
| `0x0000` | `BOARD_ID` | — | `0x4447` | Board identification code - ASCII 'DG' |
| `0x0001` | `BOARD_VERSION` | — | `0x01` | Hardware revision number |
| `0x0002` | `BOARD_TYPE_ID` | — | `0x0001` | Board type identifier |
| `0x0003` | `SCRATCHPAD` | — | `0x0000` | General purpose test register |
| `0x0010` | `MCS_VERSION_MAJOR` | — | `0x01` | FPGA firmware major version |
| `0x0011` | `MCS_VERSION_MINOR` | — | `0x00` | FPGA firmware minor version |
| `0x0012` | `BUILD_DATE` | — | `0x20260416` | Firmware build date in packed BCD format |
| `0x0100` | `UART_BAUD_DIV` | — | `0x0022` | UART baud rate divisor for 115200 bps at 12MHz clock |
| `0x0101` | `UART_CTRL` | — | `0x01` | UART control register |
| `0x0102` | `UART_STATUS` | — | `0x02` | UART status flags (read-clear) |
| `0x0103` | `UART_TX_COUNT` | — | `0x00` | TX FIFO fill level |
| `0x0104` | `UART_RX_COUNT` | — | `0x00` | RX FIFO fill level |
| `0x0108` | `SPI_CLK_CTRL` | — | `0x00` | SPI clock configuration |
| `0x0110` | `ETH_MAC_LOW` | — | `0x0000` | Ethernet MAC address lower 16 bits |
| `0x0111` | `ETH_MAC_HIGH` | — | `0x0000` | Ethernet MAC address upper 16 bits |
| `0x0200` | `ADC_CTRL` | — | `0x01` | ADC configuration and control |
| `0x0201` | `ADC_STATUS` | — | `0x00` | ADC status flags (read-clear) |
| `0x0202` | `ADC_JESD_CFG` | — | `0x0401` | JESD204B interface configuration |
| `0x0210` | `VCC_3V3_RAW` | — | `0x0000` | 3.3V main rail ADC count (12-bit) |
| `0x0211` | `VCC_1V8_RAW` | — | `0x0000` | 1.8V LDO rail ADC count (12-bit) |
| `0x0212` | `VCC_1V0_RAW` | — | `0x0000` | 1.0V ADC core LDO rail ADC count (12-bit) |
| `0x0213` | `VCC_NEG1V8_RAW` | — | `0x0000` | -1.8V negative LDO rail ADC count (12-bit) |
| `0x0218` | `ICC_3V3_RAW` | — | `0x0000` | 3.3V rail current monitor ADC count |
| `0x0300` | `TEMP_FPGA` | — | `0x0190` | FPGA die temperature (0.25°C units, signed) |
| `0x0301` | `TEMP_REMOTE` | — | `0x00C8` | Remote temperature sensor reading (0.25°C units) |
| `0x0308` | `TEMP_ALERT_HIGH` | — | `0x0190` | Over-temperature alert threshold (100°C) |
| `0x0309` | `TEMP_ALERT_LOW` | — | `0xFF9C` | Under-temperature alert threshold (-25°C) |
| `0x030F` | `HEALTH_STATUS` | — | `0x87` | System health status summary |
| `0x0400` | `PLL_CTRL` | — | `0x03` | LMK04828 PLL control register |
| `0x0401` | `PLL_STATUS` | — | `0x00` | PLL status flags (read-clear) |
| `0x0402` | `PLL_N_DIV` | — | `0x0032` | PLL N divider value (default 50) |
| `0x0403` | `PLL_R_DIV` | — | `0x0001` | PLL R divider value (default 1) |
| `0x0410` | `CLK_ENABLE` | — | `0x0F` | Clock output enables for LMK04828 outputs |
| `0x0500` | `EEPROM_CTRL` | — | `0x00` | EEPROM/I2C control register |
| `0x0501` | `EEPROM_ADDR` | — | `0x0000` | EEPROM byte address |
| `0x0502` | `EEPROM_DATA` | — | `0x0000` | EEPROM read/write data |
| `0x0600` | `FLASH_CTRL` | — | `0x00` | Configuration flash control register |
| `0x0601` | `FLASH_ADDR_LOW` | — | `0x0000` | Flash address low word |
| `0x0602` | `FLASH_ADDR_HIGH` | — | `0x0000` | Flash address high word |
| `0x0603` | `FLASH_DATA` | — | `0x0000` | Flash read/write data FIFO |
| `0x0604` | `FLASH_STATUS` | — | `0x01` | Flash status flags (read-clear) |
| `0x0700` | `RF_VGA_GAIN` | — | `0x0C` | HMC698LP4 VGA gain control (dB) |
| `0x0701` | `RF_STATUS` | — | `0x01` | RF chain status flags |
| `0x0800` | `GPIO_DIR` | — | `0x0000` | GPIO direction control (0=input, 1=output) |
| `0x0801` | `GPIO_DATA` | — | `0x0000` | GPIO data read/write |
| `0x0802` | `LED_CTRL` | — | `0x0000` | TLC6C5712 LED driver control |
| `0x0803` | `LED_STATUS` | — | `0x0F` | LED status indicators |
| `0x0900` | `CALIB_CTRL` | — | `0x00` | Calibration control register |
| `0x0901` | `CALIB_DATA` | — | `0x0000` | Calibration data result |
| `0x0A00` | `DAC0_VALUE` | — | `0x0800` | DAC channel 0 output value (12-bit) |

---
### `BOARD_ID` — Address `0x0000`

**Reset value:** `0x4447`  **Access:** see fields below

Board identification code - ASCII 'DG'

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BOARD_ID` | `[15:0]` | RO | `0x4447` | Board identifier 0x4447='DG' |

---
### `BOARD_VERSION` — Address `0x0001`

**Reset value:** `0x01`  **Access:** see fields below

Hardware revision number

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAJOR_REV` | `[7:4]` | RO | `0x0` | Major revision (0-15) |
| `MINOR_REV` | `[3:0]` | RO | `0x1` | Minor revision (0-15) |

---
### `BOARD_TYPE_ID` — Address `0x0002`

**Reset value:** `0x0001`  **Access:** see fields below

Board type identifier

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TYPE_ID` | `[15:0]` | RO | `0x0001` | Board type: 0x0001 = DGHB RF Processing Board |

---
### `SCRATCHPAD` — Address `0x0003`

**Reset value:** `0x0000`  **Access:** see fields below

General purpose test register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEST_DATA` | `[15:0]` | RW | `0x0000` | Read/write test pattern for memory verification |

---
### `MCS_VERSION_MAJOR` — Address `0x0010`

**Reset value:** `0x01`  **Access:** see fields below

FPGA firmware major version

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAJOR_VER` | `[7:0]` | RO | `0x01` | Major firmware version number |

---
### `MCS_VERSION_MINOR` — Address `0x0011`

**Reset value:** `0x00`  **Access:** see fields below

FPGA firmware minor version

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MINOR_VER` | `[7:0]` | RO | `0x00` | Minor firmware version number |

---
### `BUILD_DATE` — Address `0x0012`

**Reset value:** `0x20260416`  **Access:** see fields below

Firmware build date in packed BCD format

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `YEAR_BCD` | `[15:8]` | RO | `0x20` | Year in BCD (0x20 = 2026) |
| `MONTH_DAY_BCD` | `[7:0]` | RO | `0x16` | Month and day in BCD |

---
### `UART_BAUD_DIV` — Address `0x0100`

**Reset value:** `0x0022`  **Access:** see fields below

UART baud rate divisor for 115200 bps at 12MHz clock

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BAUD_DIV` | `[15:0]` | RW | `0x0022` | Baud divisor = f_clk/(16*baud_rate). 0x0022 = 34 for 115200bps |

---
### `UART_CTRL` — Address `0x0101`

**Reset value:** `0x01`  **Access:** see fields below

UART control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0x1` | UART enable (1=enabled) |
| `LOOPBACK` | `[1]` | RW | `0x0` | Internal loopback mode |
| `PARITY_EN` | `[2]` | RW | `0x0` | Parity enable |
| `PARITY_EVEN` | `[3]` | RW | `0x0` | 0=odd, 1=even parity |
| `FRAME_FORMAT` | `[7:4]` | RW | `0x0` | Frame format selection |

---
### `UART_STATUS` — Address `0x0102`

**Reset value:** `0x02`  **Access:** see fields below

UART status flags (read-clear)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TX_BUSY` | `[0]` | R | `0x0` | Transmitter busy flag |
| `RX_AVAIL` | `[1]` | RC | `0x1` | Data available in RX FIFO (clears on read) |
| `FRAME_ERR` | `[2]` | RC | `0x0` | Frame error detected |
| `PARITY_ERR` | `[3]` | RC | `0x0` | Parity error detected |

---
### `UART_TX_COUNT` — Address `0x0103`

**Reset value:** `0x00`  **Access:** see fields below

TX FIFO fill level

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TX_COUNT` | `[7:0]` | RO | `0x00` | Number of bytes in TX FIFO |

---
### `UART_RX_COUNT` — Address `0x0104`

**Reset value:** `0x00`  **Access:** see fields below

RX FIFO fill level

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `RX_COUNT` | `[7:0]` | RO | `0x00` | Number of bytes in RX FIFO |

---
### `SPI_CLK_CTRL` — Address `0x0108`

**Reset value:** `0x00`  **Access:** see fields below

SPI clock configuration

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `CLK_DIV` | `[7:0]` | RW | `0x00` | SPI clock divisor (0=f_clk/4, 1=f_clk/8, etc.) |
| `CPOL` | `[8]` | RW | `0x0` | Clock polarity |
| `CPHA` | `[9]` | RW | `0x0` | Clock phase |

---
### `ETH_MAC_LOW` — Address `0x0110`

**Reset value:** `0x0000`  **Access:** see fields below

Ethernet MAC address lower 16 bits

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAC_LSB` | `[15:0]` | RO | `0x0000` | MAC address bits [15:0] |

---
### `ETH_MAC_HIGH` — Address `0x0111`

**Reset value:** `0x0000`  **Access:** see fields below

Ethernet MAC address upper 16 bits

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAC_MSB` | `[15:0]` | RO | `0x0000` | MAC address bits [31:16] |

---
### `ADC_CTRL` — Address `0x0200`

**Reset value:** `0x01`  **Access:** see fields below

ADC configuration and control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `SOFT_RESET` | `[0]` | RW | `0x1` | ADC soft reset (1=reset, 0=normal) |
| `ENABLE` | `[1]` | RW | `0x0` | ADC enable (1=enabled) |
| `CLK_SEL` | `[3:2]` | RW | `0x0` | Clock source select |
| `DECIMATION` | `[6:4]` | RW | `0x0` | Decimation factor |
| `JESD_EN` | `[7]` | RW | `0x0` | JESD204B link enable |

---
### `ADC_STATUS` — Address `0x0201`

**Reset value:** `0x00`  **Access:** see fields below

ADC status flags (read-clear)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA_READY` | `[0]` | RC | `0x0` | New sample data ready flag |
| `OVERRANGE` | `[1]` | RC | `0x0` | ADC input overrange detected |
| `JESD_LOCKED` | `[2]` | R | `0x0` | JESD204B link locked status |
| `CODE_GRP_ERR` | `[3]` | RC | `0x0` | JESD204B code group error |

---
### `ADC_JESD_CFG` — Address `0x0202`

**Reset value:** `0x0401`  **Access:** see fields below

JESD204B interface configuration

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `Lanes` | `[3:0]` | RW | `0x1` | Number of lanes (1=4 lanes) |
| `SCR` | `[7:4]` | RW | `0x0` | Subclass (0/1) |
| `K_VAL` | `[15:8]` | RW | `0x04` | Framer K value (32) |

---
### `VCC_3V3_RAW` — Address `0x0210`

**Reset value:** `0x0000`  **Access:** see fields below

3.3V main rail ADC count (12-bit)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | RO | `0x000` | Raw ADC count (multiply by 3.3/4096 for Volts) |
| `RESERVED` | `[15:12]` | RO | `0x0` | Reserved bits |

---
### `VCC_1V8_RAW` — Address `0x0211`

**Reset value:** `0x0000`  **Access:** see fields below

1.8V LDO rail ADC count (12-bit)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | RO | `0x000` | LDO U6 output voltage (1.8V rail) |
| `RESERVED` | `[15:12]` | RO | `0x0` | Reserved bits |

---
### `VCC_1V0_RAW` — Address `0x0212`

**Reset value:** `0x0000`  **Access:** see fields below

1.0V ADC core LDO rail ADC count (12-bit)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | RO | `0x000` | LDO U7 output voltage (1.0V rail) |
| `RESERVED` | `[15:12]` | RO | `0x0` | Reserved bits |

---
### `VCC_NEG1V8_RAW` — Address `0x0213`

**Reset value:** `0x0000`  **Access:** see fields below

-1.8V negative LDO rail ADC count (12-bit)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | RO | `0x000` | LDO U8 output voltage (-1.8V rail) |
| `RESERVED` | `[15:12]` | RO | `0x0` | Reserved bits |

---
### `ICC_3V3_RAW` — Address `0x0218`

**Reset value:** `0x0000`  **Access:** see fields below

3.3V rail current monitor ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | RO | `0x000` | Main 3.3V rail current (scaled via sense amp) |
| `RESERVED` | `[15:12]` | RO | `0x0` | Reserved bits |

---
### `TEMP_FPGA` — Address `0x0300`

**Reset value:** `0x0190`  **Access:** see fields below

FPGA die temperature (0.25°C units, signed)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_10BIT` | `[9:0]` | RO | `0x190` | Temperature in 0.25°C steps (0x190 = 100°C) |
| `TEMP_SIGN` | `[15:10]` | RO | `0x0` | Sign extension (0=positive, 0x3F=negative) |

---
### `TEMP_REMOTE` — Address `0x0301`

**Reset value:** `0x00C8`  **Access:** see fields below

Remote temperature sensor reading (0.25°C units)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_10BIT` | `[9:0]` | RO | `0x0C8` | Remote temperature sensor (0x0C8 = 50°C default) |
| `RESERVED` | `[15:10]` | RO | `0x0` | Reserved bits |

---
### `TEMP_ALERT_HIGH` — Address `0x0308`

**Reset value:** `0x0190`  **Access:** see fields below

Over-temperature alert threshold (100°C)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `THRESHOLD` | `[9:0]` | RW | `0x190` | Alert threshold in 0.25°C steps |
| `ENABLE` | `[15]` | RW | `0x1` | Enable high-temperature alert |

---
### `TEMP_ALERT_LOW` — Address `0x0309`

**Reset value:** `0xFF9C`  **Access:** see fields below

Under-temperature alert threshold (-25°C)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `THRESHOLD` | `[9:0]` | RW | `0x39C` | Alert threshold in 0.25°C steps (0x39C = -25°C) |
| `ENABLE` | `[15]` | RW | `0x1` | Enable low-temperature alert |

---
### `HEALTH_STATUS` — Address `0x030F`

**Reset value:** `0x87`  **Access:** see fields below

System health status summary

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_OK` | `[0]` | RO | `0x1` | Temperature within limits (1=OK) |
| `VOLT_OK` | `[1]` | RO | `0x1` | All rails within tolerance (1=OK) |
| `PLL_LOCK` | `[2]` | RO | `0x0` | PLL lock status (1=locked) |
| `JESD_OK` | `[3]` | RO | `0x0` | JESD204B link OK |
| `PWR_GOOD` | `[7]` | RO | `0x1` | System power good summary |

---
### `PLL_CTRL` — Address `0x0400`

**Reset value:** `0x03`  **Access:** see fields below

LMK04828 PLL control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `PLL_RESET` | `[0]` | RW | `0x1` | PLL reset (1=hold in reset) |
| `PLL_ENABLE` | `[1]` | RW | `0x1` | PLL enable (1=enabled) |
| `REF_SEL` | `[3:2]` | RW | `0x0` | Reference clock select (00=OSC0, 01=OSC1) |
| `SYSREF_EN` | `[4]` | RW | `0x0` | SYSREF output enable |

---
### `PLL_STATUS` — Address `0x0401`

**Reset value:** `0x00`  **Access:** see fields below

PLL status flags (read-clear)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LOCKED` | `[0]` | RO | `0x0` | PLL lock detected (1=locked) |
| `LOSS_OF_LOCK` | `[1]` | RC | `0x0` | Loss of lock event (clears on read) |
| `HOLDOVER` | `[2]` | RO | `0x0` | PLL in holdover mode |

---
### `PLL_N_DIV` — Address `0x0402`

**Reset value:** `0x0032`  **Access:** see fields below

PLL N divider value (default 50)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `N_DIVIDER` | `[15:0]` | RW | `0x0032` | PLL N divider (1-65535, default 50) |

---
### `PLL_R_DIV` — Address `0x0403`

**Reset value:** `0x0001`  **Access:** see fields below

PLL R divider value (default 1)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `R_DIVIDER` | `[7:0]` | RW | `0x01` | PLL R divider (1-255, default 1) |
| `RESERVED` | `[15:8]` | RO | `0x0` | Reserved bits |

---
### `CLK_ENABLE` — Address `0x0410`

**Reset value:** `0x0F`  **Access:** see fields below

Clock output enables for LMK04828 outputs

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `CLKOUT0_EN` | `[0]` | RW | `0x1` | CLKOUT0 enable (ADC clock) |
| `CLKOUT1_EN` | `[1]` | RW | `0x1` | CLKOUT1 enable (FPGA clock) |
| `CLKOUT2_EN` | `[2]` | RW | `0x1` | CLKOUT2 enable |
| `CLKOUT3_EN` | `[3]` | RW | `0x1` | CLKOUT3 enable |
| `SYSREF_EN` | `[4]` | RW | `0x0` | SYSREF output enable (JESD204B) |
| `RESERVED` | `[15:5]` | RO | `0x0` | Reserved bits |

---
### `EEPROM_CTRL` — Address `0x0500`

**Reset value:** `0x00`  **Access:** see fields below

EEPROM/I2C control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READ_CMD` | `[0]` | RW | `0x0` | Trigger EEPROM read (self-clearing) |
| `WRITE_CMD` | `[1]` | RW | `0x0` | Trigger EEPROM write (self-clearing) |
| `ERASE_CMD` | `[2]` | RW | `0x0` | Trigger EEPROM erase (self-clearing) |
| `BUSY` | `[7]` | RO | `0x0` | EEPROM operation in progress |

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
| `DATA` | `[15:0]` | RW | `0x0000` | 16-bit data word |

---
### `FLASH_CTRL` — Address `0x0600`

**Reset value:** `0x00`  **Access:** see fields below

Configuration flash control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READ_CMD` | `[0]` | RW | `0x0` | Trigger flash read (self-clearing) |
| `WRITE_CMD` | `[1]` | RW | `0x0` | Trigger flash write (self-clearing) |
| `ERASE_SECTOR` | `[2]` | RW | `0x0` | Trigger sector erase (self-clearing) |
| `ERASE_CHIP` | `[3]` | RW | `0x0` | Trigger chip erase (self-clearing) |
| `BUSY` | `[7]` | RO | `0x0` | Flash operation in progress |

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

Flash address high word

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADDR_HIGH` | `[7:0]` | RW | `0x00` | Flash address bits [23:16] |
| `RESERVED` | `[15:8]` | RO | `0x0` | Reserved bits |

---
### `FLASH_DATA` — Address `0x0603`

**Reset value:** `0x0000`  **Access:** see fields below

Flash read/write data FIFO

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA_FIFO` | `[15:0]` | RW | `0x0000` | 16-bit data word for flash operations |

---
### `FLASH_STATUS` — Address `0x0604`

**Reset value:** `0x01`  **Access:** see fields below

Flash status flags (read-clear)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READY` | `[0]` | RO | `0x1` | Flash ready for commands |
| `WRITE_ERR` | `[1]` | RC | `0x0` | Write operation error |
| `ERASE_ERR` | `[2]` | RC | `0x0` | Erase operation error |
| `PROTECT_ERR` | `[3]` | RC | `0x0` | Protection error |

---
### `RF_VGA_GAIN` — Address `0x0700`

**Reset value:** `0x0C`  **Access:** see fields below

HMC698LP4 VGA gain control (dB)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GAIN_CODE` | `[7:0]` | RW | `0x0C` | Gain code (0x00=-10dB to 0x20=+22dB, 0x0C=0dB nominal) |
| `GAIN_STEP` | `[9:8]` | RW | `0x0` | Fine gain step (0.5dB increments) |
| `VGA_ENABLE` | `[15]` | RW | `0x1` | VGA output enable (1=enabled) |

---
### `RF_STATUS` — Address `0x0701`

**Reset value:** `0x01`  **Access:** see fields below

RF chain status flags

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `VGA_OK` | `[0]` | RO | `0x1` | VGA detected and responding |
| `ADC_PWRGD` | `[1]` | RO | `0x0` | ADC power good signal |
| `RF_OVERRANGE` | `[2]` | RC | `0x0` | RF input overrange detected |

---
### `GPIO_DIR` — Address `0x0800`

**Reset value:** `0x0000`  **Access:** see fields below

GPIO direction control (0=input, 1=output)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GPIO_DIR` | `[15:0]` | RW | `0x0000` | GPIO direction bitmask (1=output, 0=input) |

---
### `GPIO_DATA` — Address `0x0801`

**Reset value:** `0x0000`  **Access:** see fields below

GPIO data read/write

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GPIO_OUT` | `[7:0]` | RW | `0x00` | GPIO output data (for pins configured as outputs) |
| `GPIO_IN` | `[15:8]` | RO | `0x00` | GPIO input data (read-only) |

---
### `LED_CTRL` — Address `0x0802`

**Reset value:** `0x0000`  **Access:** see fields below

TLC6C5712 LED driver control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LED0_BRT` | `[7:0]` | RW | `0x80` | LED0 brightness (PWM 0-255, 0x80=50%) |
| `LED1_BRT` | `[15:8]` | RW | `0x00` | LED1 brightness (0-255) |

---
### `LED_STATUS` — Address `0x0803`

**Reset value:** `0x0F`  **Access:** see fields below

LED status indicators

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `STATUS_LED` | `[0]` | RW | `0x1` | Main status LED (1=ON) |
| `CLOCK_LOCK_LED` | `[1]` | RW | `0x1` | Clock lock LED indicator |
| `ERROR_LED` | `[2]` | RW | `0x0` | Error LED indicator |
| `RF_ACTIVE_LED` | `[3]` | RW | `0x1` | RF chain active indicator |

---
### `CALIB_CTRL` — Address `0x0900`

**Reset value:** `0x00`  **Access:** see fields below

Calibration control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `START_CAL` | `[0]` | RW | `0x0` | Start calibration sequence (self-clearing) |
| `CAL_MODE` | `[3:2]` | RW | `0x0` | Calibration mode select |
| `CAL_BUSY` | `[7]` | RO | `0x0` | Calibration in progress |

---
### `CALIB_DATA` — Address `0x0901`

**Reset value:** `0x0000`  **Access:** see fields below

Calibration data result

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `CAL_RESULT` | `[15:0]` | RO | `0x0000` | Last calibration result word |

---
### `DAC0_VALUE` — Address `0x0A00`

**Reset value:** `0x0800`  **Access:** see fields below

DAC channel 0 output value (12-bit)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DAC_DATA` | `[11:0]` | RW | `0x800` | 12-bit DAC value (0x800=midscale) |
| `DAC_EN` | `[15]` | RW | `0x1` | DAC output enable |
