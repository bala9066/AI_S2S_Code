# Register Description Table (RDT)
## mnb

> **Total registers:** 59

mnb Wideband RF Receiver FPGA register map for XCZU4EG-SFVC784, featuring board identification, UART/Ethernet communication, ADC supply monitoring, temperature sensing, ADF5355 PLL synthesis, RF front-end control (LNA/Mixer AGC), high-speed ADC interface, EEPROM, and Flash configuration. UART address scheme uses bit15 as R/W#, bits[11:8] as BASE group selector, and bits[7:0] as offset.

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
| `0x0000` | `BOARD_ID` | — | `0x4D4E` | Board identification code - unique mnb receiver identifier |
| `0x0001` | `BOARD_VERSION` | — | `0x10` | Hardware version number |
| `0x0002` | `BOARD_TYPE_ID` | — | `0x5246` | Board type identifier |
| `0x0003` | `SCRATCHPAD` | — | `0x0000` | Read/write test register for RAM verification and diagnostics |
| `0x0010` | `MCS_VERSION_MAJOR` | — | `0x01` | FPGA firmware major version number |
| `0x0011` | `MCS_VERSION_MINOR` | — | `0x00` | FPGA firmware minor version number |
| `0x0012` | `BUILD_DATE` | — | `0x20261027` | Firmware build date in packed BCD format (YYYYMMDD) |
| `0x0100` | `UART_BAUD_DIV` | — | `0x0034` | UART baud rate divisor for system communication |
| `0x0101` | `UART_CTRL` | — | `0x00` | UART control register |
| `0x0102` | `UART_STATUS` | — | `0x00` | UART status flags (read-clear) |
| `0x0103` | `UART_TX_COUNT` | — | `0x00` | TX FIFO byte count |
| `0x0104` | `UART_RX_COUNT` | — | `0x00` | RX FIFO byte count |
| `0x0110` | `ETH_MAC_LOW` | — | `0x0000` | Ethernet MAC address lower 16 bits |
| `0x0111` | `ETH_MAC_HIGH` | — | `0x0000` | Ethernet MAC address upper 16 bits |
| `0x0200` | `ADC_CTRL` | — | `0x00` | ADC monitoring control for supply rails |
| `0x0201` | `ADC_STATUS` | — | `0x00` | ADC status flags (read-clear) |
| `0x0210` | `VCC_5V_RAW` | — | `0x0CCC` | 5V rail ADC count (multiply by 5.0/4096 for Volts) |
| `0x0211` | `VCC_3V3_RAW` | — | `0x0A00` | 3.3V rail ADC count |
| `0x0212` | `VCC_2V5_RAW` | — | `0x0800` | 2.5V rail ADC count |
| `0x0213` | `VCC_1V8_RAW` | — | `0x05C0` | 1.8V rail ADC count |
| `0x0218` | `ICC_5V_RAW` | — | `0x0000` | 5V rail current sense ADC count |
| `0x0219` | `ICC_3V3_RAW` | — | `0x0000` | 3.3V rail current sense ADC count |
| `0x0300` | `TEMP_LOCAL` | — | `0x0140` | Local FPGA die temperature in 0.25°C units (signed) |
| `0x0301` | `TEMP_REMOTE1` | — | `0x00C8` | Remote sensor 1 temperature (RF front-end area) |
| `0x0302` | `TEMP_REMOTE2` | — | `0x00C8` | Remote sensor 2 temperature (ADC area) |
| `0x0308` | `TEMP_ALERT_HIGH` | — | `0x0190` | Over-temperature alert threshold |
| `0x0309` | `TEMP_ALERT_LOW` | — | `0xFF9C` | Under-temperature alert threshold |
| `0x030F` | `HEALTH_STATUS` | — | `0x87` | System health status register |
| `0x0400` | `PLL_CTRL` | — | `0x00` | ADF5355 PLL synthesizer control |
| `0x0401` | `PLL_STATUS` | — | `0x00` | PLL status flags (read-clear) |
| `0x0402` | `PLL_N_DIV` | — | `0x0064` | PLL N divider value (ADF5355 INT value) |
| `0x0403` | `PLL_R_DIV` | — | `0x0001` | PLL R divider value |
| `0x0404` | `PLL_FRAC_DIV` | — | `0x0000` | PLL fractional divider (ADF5355 FRAC1) |
| `0x0405` | `PLL_OUTPUT_FREQ` | — | `0x0BB8` | Target output frequency in MHz (6.8-13.6 GHz range) |
| `0x0410` | `CLK_ENABLE` | — | `0x0F` | Clock output enables |
| `0x0500` | `EEPROM_CTRL` | — | `0x00` | AT25M01 EEPROM control register |
| `0x0501` | `EEPROM_ADDR` | — | `0x0000` | EEPROM byte address |
| `0x0502` | `EEPROM_DATA` | — | `0x0000` | EEPROM read/write data |
| `0x0600` | `FLASH_CTRL` | — | `0x00` | Configuration flash control register |
| `0x0601` | `FLASH_ADDR_LOW` | — | `0x0000` | Flash address lower 16 bits |
| `0x0602` | `FLASH_ADDR_HIGH` | — | `0x00` | Flash address upper 8 bits |
| `0x0603` | `FLASH_DATA` | — | `0x0000` | Flash read/write data FIFO |
| `0x0604` | `FLASH_STATUS` | — | `0x00` | Flash operation status (read-clear) |
| `0x0700` | `RF_LNA_GAIN` | — | `0x7FFF` | LNA gain control (HMC698LP4 DVGA) |
| `0x0701` | `RF_MIXER_CTRL` | — | `0x03` | Mixer control (HMC1061LP4) |
| `0x0702` | `RF_IF_FREQ` | — | `0x00C8` | Target IF frequency setting |
| `0x0703` | `RF_BAND_SELECT` | — | `0x00` | RF band select for 5-18 GHz range |
| `0x0704` | `RF_AGC_ENABLE` | — | `0x00` | Automatic gain control enable |
| `0x0800` | `ADC_HS_CTRL` | — | `0x00` | High-speed ADC control (ADC12DJ3200) |
| `0x0801` | `ADC_HS_STATUS` | — | `0x00` | High-speed ADC status |
| `0x0802` | `ADC_HS_DECIMATION` | — | `0x0001` | ADC decimation factor |
| `0x0803` | `ADC_HS_TEST_PATTERN` | — | `0x00` | ADC test pattern generation |
| `0x0800` | `GPIO_DIR` | — | `0x0000` | GPIO direction control (0=input, 1=output) |
| `0x0801` | `GPIO_DATA` | — | `0x0000` | GPIO data register |
| `0x0802` | `GPIO_SET` | — | `0x0000` | GPIO set bits (write-1 to set) |
| `0x0803` | `GPIO_CLEAR` | — | `0x0000` | GPIO clear bits (write-1 to clear) |
| `0x0FF0` | `SYSTEM_RESET` | — | `0x00` | System reset control |
| `0x0FF1` | `FPGA_IDCODE` | — | `0x04847093` | FPGA IDCODE register |
| `0x0FFE` | `REVISION_REG` | — | `0x0001` | Register map revision |

---
### `BOARD_ID` — Address `0x0000`

**Reset value:** `0x4D4E`  **Access:** see fields below

Board identification code - unique mnb receiver identifier

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ID_CODE` | `[15:0]` | R | `0x4D4E` | Board ID = 'MN' in ASCII (0x4D4E) |

---
### `BOARD_VERSION` — Address `0x0001`

**Reset value:** `0x10`  **Access:** see fields below

Hardware version number

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAJOR` | `[7:4]` | R | `0x1` | Major version number |
| `MINOR` | `[3:0]` | R | `0x0` | Minor version number |

---
### `BOARD_TYPE_ID` — Address `0x0002`

**Reset value:** `0x5246`  **Access:** see fields below

Board type identifier

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TYPE_CODE` | `[15:0]` | R | `0x5246` | Type code = 'RF' in ASCII (0x5246) - Wideband RF Receiver |

---
### `SCRATCHPAD` — Address `0x0003`

**Reset value:** `0x0000`  **Access:** see fields below

Read/write test register for RAM verification and diagnostics

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEST_DATA` | `[15:0]` | RW | `0x0000` | General-purpose test pattern register |

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

**Reset value:** `0x20261027`  **Access:** see fields below

Firmware build date in packed BCD format (YYYYMMDD)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BCD_DATE` | `[31:0]` | R | `0x20261027` | Build date: 2026-10-27 default |

---
### `UART_BAUD_DIV` — Address `0x0100`

**Reset value:** `0x0034`  **Access:** see fields below

UART baud rate divisor for system communication

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DIVISOR` | `[15:0]` | RW | `0x0034` | Baud divisor (default 115200 baud @ 100MHz ref) |

---
### `UART_CTRL` — Address `0x0101`

**Reset value:** `0x00`  **Access:** see fields below

UART control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0x0` | UART enable (1=enabled) |
| `LOOPBACK` | `[1]` | RW | `0x0` | Loopback mode for testing |
| `FRAME_FORMAT` | `[7:4]` | RW | `0x0` | Frame format selection |

---
### `UART_STATUS` — Address `0x0102`

**Reset value:** `0x00`  **Access:** see fields below

UART status flags (read-clear)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TX_BUSY` | `[0]` | R | `0x0` | Transmitter busy flag |
| `RX_AVAIL` | `[1]` | R | `0x0` | Data available in RX FIFO |
| `FRAME_ERR` | `[2]` | RC | `0x0` | Frame error (clear on read) |

---
### `UART_TX_COUNT` — Address `0x0103`

**Reset value:** `0x00`  **Access:** see fields below

TX FIFO byte count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TX_FIFO_LEVEL` | `[7:0]` | R | `0x00` | Number of bytes in TX FIFO |

---
### `UART_RX_COUNT` — Address `0x0104`

**Reset value:** `0x00`  **Access:** see fields below

RX FIFO byte count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `RX_FIFO_LEVEL` | `[7:0]` | R | `0x00` | Number of bytes in RX FIFO |

---
### `ETH_MAC_LOW` — Address `0x0110`

**Reset value:** `0x0000`  **Access:** see fields below

Ethernet MAC address lower 16 bits

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAC_LOW` | `[15:0]` | R | `0x0000` | MAC address [15:0] |

---
### `ETH_MAC_HIGH` — Address `0x0111`

**Reset value:** `0x0000`  **Access:** see fields below

Ethernet MAC address upper 16 bits

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAC_HIGH` | `[15:0]` | R | `0x0000` | MAC address [31:16] |

---
### `ADC_CTRL` — Address `0x0200`

**Reset value:** `0x00`  **Access:** see fields below

ADC monitoring control for supply rails

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `START` | `[0]` | RW | `0x0` | Start single conversion |
| `CONTINUOUS` | `[1]` | RW | `0x0` | Continuous conversion mode |
| `CHANNEL_SEL` | `[3:2]` | RW | `0x0` | ADC channel select |

---
### `ADC_STATUS` — Address `0x0201`

**Reset value:** `0x00`  **Access:** see fields below

ADC status flags (read-clear)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA_READY` | `[0]` | R | `0x0` | New conversion data ready |
| `OVERRANGE` | `[1]` | RC | `0x0` | ADC input overrange (clear on read) |

---
### `VCC_5V_RAW` — Address `0x0210`

**Reset value:** `0x0CCC`  **Access:** see fields below

5V rail ADC count (multiply by 5.0/4096 for Volts)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | R | `0x0CCC` | 12-bit ADC count for 5V rail |

---
### `VCC_3V3_RAW` — Address `0x0211`

**Reset value:** `0x0A00`  **Access:** see fields below

3.3V rail ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | R | `0x0A00` | 12-bit ADC count for 3.3V rail |

---
### `VCC_2V5_RAW` — Address `0x0212`

**Reset value:** `0x0800`  **Access:** see fields below

2.5V rail ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | R | `0x0800` | 12-bit ADC count for 2.5V rail |

---
### `VCC_1V8_RAW` — Address `0x0213`

**Reset value:** `0x05C0`  **Access:** see fields below

1.8V rail ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | R | `0x05C0` | 12-bit ADC count for 1.8V rail |

---
### `ICC_5V_RAW` — Address `0x0218`

**Reset value:** `0x0000`  **Access:** see fields below

5V rail current sense ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | R | `0x0000` | 12-bit ADC count for 5V current |

---
### `ICC_3V3_RAW` — Address `0x0219`

**Reset value:** `0x0000`  **Access:** see fields below

3.3V rail current sense ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | R | `0x0000` | 12-bit ADC count for 3.3V current |

---
### `TEMP_LOCAL` — Address `0x0300`

**Reset value:** `0x0140`  **Access:** see fields below

Local FPGA die temperature in 0.25°C units (signed)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_DATA` | `[9:0]` | R | `0x0140` | Die temperature (default 80°C = 0x140 * 0.25) |

---
### `TEMP_REMOTE1` — Address `0x0301`

**Reset value:** `0x00C8`  **Access:** see fields below

Remote sensor 1 temperature (RF front-end area)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_DATA` | `[9:0]` | R | `0x00C8` | Remote temperature (default 50°C) |

---
### `TEMP_REMOTE2` — Address `0x0302`

**Reset value:** `0x00C8`  **Access:** see fields below

Remote sensor 2 temperature (ADC area)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_DATA` | `[9:0]` | R | `0x00C8` | Remote temperature (default 50°C) |

---
### `TEMP_ALERT_HIGH` — Address `0x0308`

**Reset value:** `0x0190`  **Access:** see fields below

Over-temperature alert threshold

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ALERT_THRESH` | `[9:0]` | RW | `0x0190` | High threshold (default 100°C) |

---
### `TEMP_ALERT_LOW` — Address `0x0309`

**Reset value:** `0xFF9C`  **Access:** see fields below

Under-temperature alert threshold

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ALERT_THRESH` | `[9:0]` | RW | `0xFF9C` | Low threshold (default -25°C, signed) |

---
### `HEALTH_STATUS` — Address `0x030F`

**Reset value:** `0x87`  **Access:** see fields below

System health status register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_OK` | `[0]` | R | `0x1` | Temperature within limits |
| `VOLT_OK` | `[1]` | R | `0x1` | All voltages within limits |
| `PLL_LOCK` | `[2]` | R | `0x0` | PLL lock status |
| `SYSTEM_OK` | `[7]` | R | `0x1` | Overall system health |

---
### `PLL_CTRL` — Address `0x0400`

**Reset value:** `0x00`  **Access:** see fields below

ADF5355 PLL synthesizer control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0x0` | PLL enable (1=enabled) |
| `RESET` | `[1]` | RW | `0x0` | PLL reset (self-clearing) |
| `REF_SEL` | `[3:2]` | RW | `0x0` | Reference clock select |

---
### `PLL_STATUS` — Address `0x0401`

**Reset value:** `0x00`  **Access:** see fields below

PLL status flags (read-clear)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LOCKED` | `[0]` | R | `0x0` | PLL locked indicator |
| `LOSS_OF_LOCK` | `[1]` | RC | `0x0` | Loss of lock event (clear on read) |

---
### `PLL_N_DIV` — Address `0x0402`

**Reset value:** `0x0064`  **Access:** see fields below

PLL N divider value (ADF5355 INT value)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `N_DIVIDER` | `[15:0]` | RW | `0x0064` | N divider (default 100) |

---
### `PLL_R_DIV` — Address `0x0403`

**Reset value:** `0x0001`  **Access:** see fields below

PLL R divider value

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `R_DIVIDER` | `[7:0]` | RW | `0x01` | R divider (default 1) |

---
### `PLL_FRAC_DIV` — Address `0x0404`

**Reset value:** `0x0000`  **Access:** see fields below

PLL fractional divider (ADF5355 FRAC1)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `FRAC` | `[23:0]` | RW | `0x000000` | 24-bit fractional divider |

---
### `PLL_OUTPUT_FREQ` — Address `0x0405`

**Reset value:** `0x0BB8`  **Access:** see fields below

Target output frequency in MHz (6.8-13.6 GHz range)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `FREQ_MHZ` | `[15:0]` | RW | `0x0BB8` | Output frequency (default 3000 MHz) |

---
### `CLK_ENABLE` — Address `0x0410`

**Reset value:** `0x0F`  **Access:** see fields below

Clock output enables

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `CLK_EN` | `[7:0]` | RW | `0x0F` | Per-output clock enables |

---
### `EEPROM_CTRL` — Address `0x0500`

**Reset value:** `0x00`  **Access:** see fields below

AT25M01 EEPROM control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READ` | `[0]` | RW | `0x0` | Initiate read operation |
| `WRITE` | `[1]` | RW | `0x0` | Initiate write operation |
| `ERASE` | `[2]` | RW | `0x0` | Initiate erase/write enable latch |
| `BUSY` | `[7]` | R | `0x0` | EEPROM busy flag |

---
### `EEPROM_ADDR` — Address `0x0501`

**Reset value:** `0x0000`  **Access:** see fields below

EEPROM byte address

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADDRESS` | `[15:0]` | RW | `0x0000` | Byte address (17-bit address space) |

---
### `EEPROM_DATA` — Address `0x0502`

**Reset value:** `0x0000`  **Access:** see fields below

EEPROM read/write data

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA` | `[15:0]` | RW | `0x0000` | Data word |

---
### `FLASH_CTRL` — Address `0x0600`

**Reset value:** `0x00`  **Access:** see fields below

Configuration flash control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READ` | `[0]` | RW | `0x0` | Initiate flash read |
| `WRITE` | `[1]` | RW | `0x0` | Initiate flash write |
| `ERASE_SECTOR` | `[2]` | RW | `0x0` | Erase sector (unlock required) |
| `ERASE_CHIP` | `[3]` | RW | `0x0` | Erase entire chip (unlock required) |
| `BUSY` | `[7]` | R | `0x0` | Flash operation busy flag |

---
### `FLASH_ADDR_LOW` — Address `0x0601`

**Reset value:** `0x0000`  **Access:** see fields below

Flash address lower 16 bits

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADDR_LOW` | `[15:0]` | RW | `0x0000` | Flash address [15:0] |

---
### `FLASH_ADDR_HIGH` — Address `0x0602`

**Reset value:** `0x00`  **Access:** see fields below

Flash address upper 8 bits

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADDR_HIGH` | `[7:0]` | RW | `0x00` | Flash address [23:16] |

---
### `FLASH_DATA` — Address `0x0603`

**Reset value:** `0x0000`  **Access:** see fields below

Flash read/write data FIFO

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA` | `[15:0]` | RW | `0x0000` | Data word |

---
### `FLASH_STATUS` — Address `0x0604`

**Reset value:** `0x00`  **Access:** see fields below

Flash operation status (read-clear)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READY` | `[0]` | R | `0x1` | Flash ready for operations |
| `WRITE_ERR` | `[1]` | RC | `0x0` | Write error flag |
| `ERASE_ERR` | `[2]` | RC | `0x0` | Erase error flag |

---
### `RF_LNA_GAIN` — Address `0x0700`

**Reset value:** `0x7FFF`  **Access:** see fields below

LNA gain control (HMC698LP4 DVGA)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GAIN_CODE` | `[14:0]` | RW | `0x7FFF` | 15-bit gain control code (max gain default) |

---
### `RF_MIXER_CTRL` — Address `0x0701`

**Reset value:** `0x03`  **Access:** see fields below

Mixer control (HMC1061LP4)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0x1` | Mixer enable |
| `LO_SELECT` | `[1]` | RW | `0x1` | LO port select |

---
### `RF_IF_FREQ` — Address `0x0702`

**Reset value:** `0x00C8`  **Access:** see fields below

Target IF frequency setting

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `IF_FREQ_MHZ` | `[15:0]` | RW | `0x00C8` | IF frequency in MHz (default 200 MHz) |

---
### `RF_BAND_SELECT` — Address `0x0703`

**Reset value:** `0x00`  **Access:** see fields below

RF band select for 5-18 GHz range

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BAND` | `[3:0]` | RW | `0x0` | Band select (0=5-8GHz, 1=8-12GHz, 2=12-18GHz) |

---
### `RF_AGC_ENABLE` — Address `0x0704`

**Reset value:** `0x00`  **Access:** see fields below

Automatic gain control enable

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0x0` | AGC enable |
| `TARGET_LEVEL` | `[10:0]` | RW | `0x200` | Target power level (FSB units) |

---
### `ADC_HS_CTRL` — Address `0x0800`

**Reset value:** `0x00`  **Access:** see fields below

High-speed ADC control (ADC12DJ3200)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0x0` | ADC enable |
| `MODE` | `[2:1]` | RW | `0x0` | ADC mode (0=1:1, 1=1:2, 2=1:4 decimation) |
| `CLK_EDGE` | `[3]` | RW | `0x0` | Clock edge select |

---
### `ADC_HS_STATUS` — Address `0x0801`

**Reset value:** `0x00`  **Access:** see fields below

High-speed ADC status

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `CAL_DONE` | `[0]` | R | `0x0` | Calibration complete |
| `PLL_LOCK` | `[1]` | R | `0x0` | ADC internal PLL lock |
| `OVERRANGE` | `[2]` | R | `0x0` | ADC input overrange |

---
### `ADC_HS_DECIMATION` — Address `0x0802`

**Reset value:** `0x0001`  **Access:** see fields below

ADC decimation factor

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DEC_FACTOR` | `[15:0]` | RW | `0x0001` | Decimation factor (1, 2, or 4) |

---
### `ADC_HS_TEST_PATTERN` — Address `0x0803`

**Reset value:** `0x00`  **Access:** see fields below

ADC test pattern generation

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0x0` | Test pattern enable |
| `PATTERN_SEL` | `[3:1]` | RW | `0x0` | Pattern select (0=ramp, 1=toggle, 2=custom) |

---
### `GPIO_DIR` — Address `0x0800`

**Reset value:** `0x0000`  **Access:** see fields below

GPIO direction control (0=input, 1=output)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DIR` | `[15:0]` | RW | `0x0000` | GPIO direction bits |

---
### `GPIO_DATA` — Address `0x0801`

**Reset value:** `0x0000`  **Access:** see fields below

GPIO data register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA` | `[15:0]` | RW | `0x0000` | GPIO data values |

---
### `GPIO_SET` — Address `0x0802`

**Reset value:** `0x0000`  **Access:** see fields below

GPIO set bits (write-1 to set)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `SET` | `[15:0]` | W | `0x0000` | Write-1-set operation |

---
### `GPIO_CLEAR` — Address `0x0803`

**Reset value:** `0x0000`  **Access:** see fields below

GPIO clear bits (write-1 to clear)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `CLEAR` | `[15:0]` | W | `0x0000` | Write-1-clear operation |

---
### `SYSTEM_RESET` — Address `0x0FF0`

**Reset value:** `0x00`  **Access:** see fields below

System reset control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `RESET_KEY` | `[7:0]` | RW | `0x00` | Write 0xAA to trigger system reset |

---
### `FPGA_IDCODE` — Address `0x0FF1`

**Reset value:** `0x04847093`  **Access:** see fields below

FPGA IDCODE register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `IDCODE` | `[31:0]` | R | `0x04847093` | Xilinx Zynq UltraScale+ IDCODE |

---
### `REVISION_REG` — Address `0x0FFE`

**Reset value:** `0x0001`  **Access:** see fields below

Register map revision

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `REVISION` | `[15:0]` | R | `0x0001` | Register map version |
