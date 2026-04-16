# Register Description Table (RDT)
## mn

> **Total registers:** 56

Wideband RF Receiver (mn) register map for Zynq UltraScale+ MPSoC with XCZU4EV-SFVC784. Includes board ID, communication (UART/Ethernet), ADC (ADC10D1000 monitoring), temperature sensors, PLL/clock control, EEPROM, configuration flash, RF front-end control (LNA/Mixer/VGA), DAC gain control, and GPIO. All registers use 16-bit UART addressing with R/W# bit.

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
| `0x0000` | `BOARD_ID` | — | `0x4D4E` | Board identification code - ASCII 'MN' |
| `0x0001` | `BOARD_VERSION` | — | `0x10` | Hardware version - major[7:4], minor[3:0] |
| `0x0002` | `BOARD_TYPE_ID` | — | `0x5246` | Board type identifier - ASCII 'RF' |
| `0x0003` | `SCRATCHPAD` | — | `0x0000` | General-purpose test register for RAM verification |
| `0x0010` | `MCS_VERSION_MAJOR` | — | `0x01` | FPGA firmware major version |
| `0x0011` | `MCS_VERSION_MINOR` | — | `0x00` | FPGA firmware minor version |
| `0x0012` | `BUILD_DATE` | — | `0x20260417` | Build date in packed BCD format (YYYYMMDD) |
| `0x0100` | `UART_BAUD_DIV` | — | `0x0034` | UART baud rate divisor for 115200 baud at 50MHz clock |
| `0x0101` | `UART_CTRL` | — | `0x00` | UART control register |
| `0x0102` | `UART_STATUS` | — | `0x00` | UART status flags (read-clear) |
| `0x0103` | `UART_TX_COUNT` | — | `0x00` | TX FIFO byte count |
| `0x0104` | `UART_RX_COUNT` | — | `0x00` | RX FIFO byte count |
| `0x0110` | `ETH_MAC_LOW` | — | `0x0000` | Ethernet MAC address lower 16 bits |
| `0x0111` | `ETH_MAC_HIGH` | — | `0x0000` | Ethernet MAC address upper 16 bits |
| `0x0200` | `ADC_CTRL` | — | `0x00` | ADC control for ADC10D1000 monitoring |
| `0x0201` | `ADC_STATUS` | — | `0x00` | ADC status flags |
| `0x0210` | `VCC_5V_RAW` | — | `0x0000` | 5V rail ADC count (12-bit) |
| `0x0211` | `VCC_3V3_RAW` | — | `0x0000` | 3.3V rail ADC count |
| `0x0212` | `VCC_2V5_RAW` | — | `0x0000` | 2.5V rail ADC count |
| `0x0213` | `VCC_1V8_RAW` | — | `0x0000` | 1.8V rail ADC count |
| `0x0218` | `ICC_5V_RAW` | — | `0x0000` | 5V rail current ADC count |
| `0x0219` | `ICC_3V3_RAW` | — | `0x0000` | 3.3V rail current ADC count |
| `0x0300` | `TEMP_LOCAL` | — | `0x0000` | FPGA die temperature (signed 0.25C units) |
| `0x0301` | `TEMP_REMOTE1` | — | `0x0000` | Remote sensor 1 temperature |
| `0x0302` | `TEMP_REMOTE2` | — | `0x0000` | Remote sensor 2 temperature |
| `0x0308` | `TEMP_ALERT_HIGH` | — | `0x0190` | Over-temperature alert threshold (100°C) |
| `0x0309` | `TEMP_ALERT_LOW` | — | `0xFF9C` | Under-temperature alert threshold (-25°C) |
| `0x030F` | `HEALTH_STATUS` | — | `0x87` | System health summary |
| `0x0400` | `PLL_CTRL` | — | `0x00` | PLL control for system clock generation |
| `0x0401` | `PLL_STATUS` | — | `0x00` | PLL lock status |
| `0x0402` | `PLL_N_DIV` | — | `0x0020` | PLL N divider value |
| `0x0403` | `PLL_R_DIV` | — | `0x0001` | PLL R divider value |
| `0x0410` | `CLK_ENABLE` | — | `0x00` | Clock output enables |
| `0x0500` | `EEPROM_CTRL` | — | `0x00` | EEPROM control register |
| `0x0501` | `EEPROM_ADDR` | — | `0x0000` | EEPROM byte address |
| `0x0502` | `EEPROM_DATA` | — | `0x0000` | EEPROM read/write data |
| `0x0600` | `FLASH_CTRL` | — | `0x00` | Configuration flash control |
| `0x0601` | `FLASH_ADDR_LOW` | — | `0x0000` | Flash address low word |
| `0x0602` | `FLASH_ADDR_HIGH` | — | `0x0000` | Flash address high byte |
| `0x0603` | `FLASH_DATA` | — | `0x0000` | Flash data FIFO |
| `0x0604` | `FLASH_STATUS` | — | `0x01` | Flash operation status |
| `0x0700` | `RF_LNA_CTRL` | — | `0x00` | HMC698LP4 LNA control (5-20 GHz) |
| `0x0701` | `RF_VGA_CTRL` | — | `0x8000` | ADL5330 VGA gain control |
| `0x0702` | `RF_MIXER_CTRL` | — | `0x00` | HMC521LC4 GaAs MMIC mixer control |
| `0x0703` | `RF_FREQ_CTRL` | — | `0x0000` | RF frequency control word |
| `0x0708` | `RF_GAIN_TABLE_LO` | — | `0x0000` | Gain table entry low |
| `0x0709` | `RF_GAIN_TABLE_HI` | — | `0x0000` | Gain table entry high |
| `0x0800` | `GPIO_CTRL` | — | `0x0000` | GPIO direction and output control |
| `0x0801` | `GPIO_INPUT` | — | `0x00` | GPIO input data (read-only) |
| `0x0802` | `GPIO_INT_MASK` | — | `0xFF` | GPIO interrupt mask |
| `0x0803` | `GPIO_INT_STATUS` | — | `0x00` | GPIO interrupt status (read-clear) |
| `0x0900` | `DAC_CH0` | — | `0x0000` | DAC channel 0 output |
| `0x0901` | `DAC_CH1` | — | `0x0000` | DAC channel 1 output |
| `0x0902` | `DAC_CH2` | — | `0x0000` | DAC channel 2 output |
| `0x0903` | `DAC_CH3` | — | `0x0000` | DAC channel 3 output |
| `0x0908` | `DAC_CTRL` | — | `0x0F` | DAC channel enables |

---
### `BOARD_ID` — Address `0x0000`

**Reset value:** `0x4D4E`  **Access:** see fields below

Board identification code - ASCII 'MN'

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BOARD_ID` | `[15:0]` | RO | `0x4D4E` | Unique board identifier |

---
### `BOARD_VERSION` — Address `0x0001`

**Reset value:** `0x10`  **Access:** see fields below

Hardware version - major[7:4], minor[3:0]

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAJOR_VERSION` | `[7:4]` | RO | `0x1` | Major hardware revision |
| `MINOR_VERSION` | `[3:0]` | RO | `0x0` | Minor hardware revision |

---
### `BOARD_TYPE_ID` — Address `0x0002`

**Reset value:** `0x5246`  **Access:** see fields below

Board type identifier - ASCII 'RF'

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BOARD_TYPE` | `[15:0]` | RO | `0x5246` | RF receiver board type code |

---
### `SCRATCHPAD` — Address `0x0003`

**Reset value:** `0x0000`  **Access:** see fields below

General-purpose test register for RAM verification

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEST_VALUE` | `[15:0]` | RW | `0x0000` | Read/write test pattern |

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

**Reset value:** `0x20260417`  **Access:** see fields below

Build date in packed BCD format (YYYYMMDD)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BUILD_BCD` | `[31:0]` | RO | `0x20260417` | Build date: 2026-04-17 |

---
### `UART_BAUD_DIV` — Address `0x0100`

**Reset value:** `0x0034`  **Access:** see fields below

UART baud rate divisor for 115200 baud at 50MHz clock

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DIVISOR` | `[15:0]` | RW | `0x0034` | Baud = clk_freq / (16 * divisor) |

---
### `UART_CTRL` — Address `0x0101`

**Reset value:** `0x00`  **Access:** see fields below

UART control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0` | UART enable (1=enabled) |
| `LOOPBACK` | `[1]` | RW | `0` | Internal loopback mode |
| `FRAME_FORMAT` | `[7:4]` | RW | `0x0` | UART frame format (bits, parity, stop) |

---
### `UART_STATUS` — Address `0x0102`

**Reset value:** `0x00`  **Access:** see fields below

UART status flags (read-clear)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TX_BUSY` | `[0]` | R | `0` | Transmitter busy flag |
| `RX_AVAIL` | `[1]` | R | `0` | Data available in RX FIFO |
| `FRAME_ERR` | `[2]` | RC | `0` | Frame error detected (read-clear) |

---
### `UART_TX_COUNT` — Address `0x0103`

**Reset value:** `0x00`  **Access:** see fields below

TX FIFO byte count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TX_FIFO_COUNT` | `[7:0]` | RO | `0x00` | Number of bytes in TX FIFO |

---
### `UART_RX_COUNT` — Address `0x0104`

**Reset value:** `0x00`  **Access:** see fields below

RX FIFO byte count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `RX_FIFO_COUNT` | `[7:0]` | RO | `0x00` | Number of bytes in RX FIFO |

---
### `ETH_MAC_LOW` — Address `0x0110`

**Reset value:** `0x0000`  **Access:** see fields below

Ethernet MAC address lower 16 bits

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAC_LOW` | `[15:0]` | RO | `0x0000` | MAC address bytes 4-5 |

---
### `ETH_MAC_HIGH` — Address `0x0111`

**Reset value:** `0x0000`  **Access:** see fields below

Ethernet MAC address upper 16 bits

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAC_HIGH` | `[15:0]` | RO | `0x0000` | MAC address bytes 0-1 |

---
### `ADC_CTRL` — Address `0x0200`

**Reset value:** `0x00`  **Access:** see fields below

ADC control for ADC10D1000 monitoring

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `START` | `[0]` | RW | `0` | Start single conversion (1=trigger) |
| `CONTINUOUS` | `[1]` | RW | `0` | Continuous conversion mode |
| `CHANNEL_SEL` | `[3:2]` | RW | `0x0` | Channel select (0-3) |

---
### `ADC_STATUS` — Address `0x0201`

**Reset value:** `0x00`  **Access:** see fields below

ADC status flags

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA_READY` | `[0]` | R | `0` | New data available (read-clear) |
| `OVERRANGE` | `[1]` | RC | `0` | ADC overrange error |

---
### `VCC_5V_RAW` — Address `0x0210`

**Reset value:** `0x0000`  **Access:** see fields below

5V rail ADC count (12-bit)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_5V` | `[11:0]` | RO | `0x000` | 5V rail raw ADC; Volts = value * 5.0/4096 |

---
### `VCC_3V3_RAW` — Address `0x0211`

**Reset value:** `0x0000`  **Access:** see fields below

3.3V rail ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_3V3` | `[11:0]` | RO | `0x000` | 3.3V rail raw ADC; Volts = value * 3.3/4096 |

---
### `VCC_2V5_RAW` — Address `0x0212`

**Reset value:** `0x0000`  **Access:** see fields below

2.5V rail ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_2V5` | `[11:0]` | RO | `0x000` | 2.5V rail raw ADC; Volts = value * 2.5/4096 |

---
### `VCC_1V8_RAW` — Address `0x0213`

**Reset value:** `0x0000`  **Access:** see fields below

1.8V rail ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_1V8` | `[11:0]` | RO | `0x000` | 1.8V rail raw ADC; Volts = value * 1.8/4096 |

---
### `ICC_5V_RAW` — Address `0x0218`

**Reset value:** `0x0000`  **Access:** see fields below

5V rail current ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `I_SENSE_5V` | `[11:0]` | RO | `0x000` | 5V current sense raw ADC |

---
### `ICC_3V3_RAW` — Address `0x0219`

**Reset value:** `0x0000`  **Access:** see fields below

3.3V rail current ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `I_SENSE_3V3` | `[11:0]` | RO | `0x000` | 3.3V current sense raw ADC |

---
### `TEMP_LOCAL` — Address `0x0300`

**Reset value:** `0x0000`  **Access:** see fields below

FPGA die temperature (signed 0.25C units)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DIE_TEMP` | `[9:0]` | RO | `0x000` | Local temp in 0.25°C units (signed 10-bit) |

---
### `TEMP_REMOTE1` — Address `0x0301`

**Reset value:** `0x0000`  **Access:** see fields below

Remote sensor 1 temperature

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `REMOTE1_TEMP` | `[9:0]` | RO | `0x000` | Remote sensor 1 temp in 0.25°C units |

---
### `TEMP_REMOTE2` — Address `0x0302`

**Reset value:** `0x0000`  **Access:** see fields below

Remote sensor 2 temperature

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `REMOTE2_TEMP` | `[9:0]` | RO | `0x000` | Remote sensor 2 temp in 0.25°C units |

---
### `TEMP_ALERT_HIGH` — Address `0x0308`

**Reset value:** `0x0190`  **Access:** see fields below

Over-temperature alert threshold (100°C)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `OT_THRESH` | `[9:0]` | RW | `0x190` | Over-temp threshold (0x190 = 100°C) |

---
### `TEMP_ALERT_LOW` — Address `0x0309`

**Reset value:** `0xFF9C`  **Access:** see fields below

Under-temperature alert threshold (-25°C)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `UT_THRESH` | `[9:0]` | RW | `0xFF9C` | Under-temp threshold (signed, 0xFF9C = -25°C) |

---
### `HEALTH_STATUS` — Address `0x030F`

**Reset value:** `0x87`  **Access:** see fields below

System health summary

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_OK` | `[0]` | RO | `1` | Temperature within limits (1=OK) |
| `VOLT_OK` | `[1]` | RO | `1` | Power rails valid (1=OK) |
| `PLL_LOCK` | `[2]` | RO | `0` | PLL locked indicator (1=locked) |
| `RF_FRONT_OK` | `[3]` | RO | `1` | RF front-end status (1=OK) |
| `SYSTEM_OK` | `[7]` | RO | `1` | Overall system health (1=OK) |

---
### `PLL_CTRL` — Address `0x0400`

**Reset value:** `0x00`  **Access:** see fields below

PLL control for system clock generation

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0` | PLL enable (1=enabled) |
| `RESET` | `[1]` | RW | `0` | PLL reset (1=assert reset) |
| `REF_SEL` | `[3:2]` | RW | `0x0` | Reference clock source select |

---
### `PLL_STATUS` — Address `0x0401`

**Reset value:** `0x00`  **Access:** see fields below

PLL lock status

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LOCKED` | `[0]` | R | `0` | PLL locked (1=locked) |
| `LOSS_OF_LOCK` | `[1]` | RC | `0` | Loss of lock event (read-clear) |

---
### `PLL_N_DIV` — Address `0x0402`

**Reset value:** `0x0020`  **Access:** see fields below

PLL N divider value

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `N_DIVIDER` | `[15:0]` | RW | `0x0020` | Feedback divider (N=32 default) |

---
### `PLL_R_DIV` — Address `0x0403`

**Reset value:** `0x0001`  **Access:** see fields below

PLL R divider value

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `R_DIVIDER` | `[7:0]` | RW | `0x01` | Reference divider (R=1 default) |

---
### `CLK_ENABLE` — Address `0x0410`

**Reset value:** `0x00`  **Access:** see fields below

Clock output enables

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `CLK_OUT_EN` | `[7:0]` | RW | `0x00` | Bit per clock output (1=enabled) |

---
### `EEPROM_CTRL` — Address `0x0500`

**Reset value:** `0x00`  **Access:** see fields below

EEPROM control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READ` | `[0]` | RW | `0` | Start read operation (1=trigger) |
| `WRITE` | `[1]` | RW | `0` | Start write operation (1=trigger) |
| `ERASE` | `[2]` | RW | `0` | Erase operation (1=trigger) |
| `BUSY` | `[7]` | RO | `0` | EEPROM busy flag (1=busy) |

---
### `EEPROM_ADDR` — Address `0x0501`

**Reset value:** `0x0000`  **Access:** see fields below

EEPROM byte address

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADDR` | `[15:0]` | RW | `0x0000` | 16-bit EEPROM byte address |

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
| `READ` | `[0]` | RW | `0` | Flash read operation |
| `WRITE` | `[1]` | RW | `0` | Flash write operation |
| `ERASE_SECTOR` | `[2]` | RW | `0` | Erase sector (requires unlock) |
| `ERASE_CHIP` | `[3]` | RW | `0` | Erase entire chip (requires unlock) |
| `BUSY` | `[7]` | RO | `0` | Flash busy flag |

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
| `DATA_FIFO` | `[15:0]` | RW | `0x0000` | Read/write data word |

---
### `FLASH_STATUS` — Address `0x0604`

**Reset value:** `0x01`  **Access:** see fields below

Flash operation status

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READY` | `[0]` | R | `1` | Flash ready (1=ready) |
| `WRITE_ERR` | `[1]` | RC | `0` | Write protect error (read-clear) |
| `ERASE_ERR` | `[2]` | RC | `0` | Erase error (read-clear) |

---
### `RF_LNA_CTRL` — Address `0x0700`

**Reset value:** `0x00`  **Access:** see fields below

HMC698LP4 LNA control (5-20 GHz)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LNA_ENABLE` | `[0]` | RW | `0` | LNA enable (1=ON) |
| `LNA_GAIN` | `[3:1]` | RW | `0x0` | LNA gain setting (3 bits) |
| `LNA_STANDBY` | `[4]` | RW | `1` | LNA standby mode (1=standby) |

---
### `RF_VGA_CTRL` — Address `0x0701`

**Reset value:** `0x8000`  **Access:** see fields below

ADL5330 VGA gain control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `VGA_GAIN_MSB` | `[15:8]` | RW | `0x80` | VGA gain high byte |
| `VGA_GAIN_LSB` | `[7:0]` | RW | `0x00` | VGA gain low byte |

---
### `RF_MIXER_CTRL` — Address `0x0702`

**Reset value:** `0x00`  **Access:** see fields below

HMC521LC4 GaAs MMIC mixer control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MIXER_ENABLE` | `[0]` | RW | `0` | Mixer enable (1=ON) |
| `LO_BIAS` | `[3:1]` | RW | `0x4` | LO bias control |
| `IF_BIAS` | `[6:4]` | RW | `0x4` | IF bias control |

---
### `RF_FREQ_CTRL` — Address `0x0703`

**Reset value:** `0x0000`  **Access:** see fields below

RF frequency control word

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `FREQ_WORD` | `[15:0]` | RW | `0x0000` | Frequency tuning word for PLL |

---
### `RF_GAIN_TABLE_LO` — Address `0x0708`

**Reset value:** `0x0000`  **Access:** see fields below

Gain table entry low

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GAIN_TBL_LOW` | `[15:0]` | RW | `0x0000` | Gain compensation table low word |

---
### `RF_GAIN_TABLE_HI` — Address `0x0709`

**Reset value:** `0x0000`  **Access:** see fields below

Gain table entry high

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GAIN_TBL_HIGH` | `[15:0]` | RW | `0x0000` | Gain compensation table high word |

---
### `GPIO_CTRL` — Address `0x0800`

**Reset value:** `0x0000`  **Access:** see fields below

GPIO direction and output control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GPIO_OUT` | `[7:0]` | RW | `0x00` | GPIO output data |
| `GPIO_DIR` | `[15:8]` | RW | `0x00` | GPIO direction (0=input, 1=output) |

---
### `GPIO_INPUT` — Address `0x0801`

**Reset value:** `0x00`  **Access:** see fields below

GPIO input data (read-only)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GPIO_IN` | `[7:0]` | RO | `0x00` | GPIO input pin states |

---
### `GPIO_INT_MASK` — Address `0x0802`

**Reset value:** `0xFF`  **Access:** see fields below

GPIO interrupt mask

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `INT_MASK` | `[7:0]` | RW | `0xFF` | Interrupt enable (0=enabled) |

---
### `GPIO_INT_STATUS` — Address `0x0803`

**Reset value:** `0x00`  **Access:** see fields below

GPIO interrupt status (read-clear)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `INT_FLAG` | `[7:0]` | RC | `0x00` | Interrupt pending flags (read-clear) |

---
### `DAC_CH0` — Address `0x0900`

**Reset value:** `0x0000`  **Access:** see fields below

DAC channel 0 output

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DAC0_DATA` | `[15:0]` | RW | `0x0000` | DAC channel 0 output code |

---
### `DAC_CH1` — Address `0x0901`

**Reset value:** `0x0000`  **Access:** see fields below

DAC channel 1 output

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DAC1_DATA` | `[15:0]` | RW | `0x0000` | DAC channel 1 output code |

---
### `DAC_CH2` — Address `0x0902`

**Reset value:** `0x0000`  **Access:** see fields below

DAC channel 2 output

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DAC2_DATA` | `[15:0]` | RW | `0x0000` | DAC channel 2 output code |

---
### `DAC_CH3` — Address `0x0903`

**Reset value:** `0x0000`  **Access:** see fields below

DAC channel 3 output

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DAC3_DATA` | `[15:0]` | RW | `0x0000` | DAC channel 3 output code |

---
### `DAC_CTRL` — Address `0x0908`

**Reset value:** `0x0F`  **Access:** see fields below

DAC channel enables

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DAC_EN` | `[3:0]` | RW | `0xF` | Per-channel enable (1=enabled) |
