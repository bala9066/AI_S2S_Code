# Register Description Table (RDT)
## dkfjg

> **Total registers:** 51

dkfjg Wideband RF Receiver - Complete register map for XC7K70T FPGA controlling RF chain (5-18 GHz), JESD204B ADC interface, power monitoring (LTC2992), clock generation (LMK04828), LO synthesizer (ADF4355), VGA gain control, and system health monitoring across 10 functional groups with 35+ registers.

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
| `0x0000` | `BOARD_ID` | — | `0x444B` | Board identification code - ASCII 'DK' + variant code |
| `0x0001` | `BOARD_VERSION` | — | `0x10` | Hardware version number - major and minor revision |
| `0x0002` | `BOARD_TYPE_ID` | — | `0x0001` | Board type identifier for firmware compatibility check |
| `0x0003` | `SCRATCHPAD` | — | `0x0000` | Diagnostic read/write test register for RAM integrity verification |
| `0x0010` | `MCS_VERSION_MAJOR` | — | `0x01` | FPGA firmware major version number |
| `0x0011` | `MCS_VERSION_MINOR` | — | `0x00` | FPGA firmware minor version number |
| `0x0012` | `BUILD_DATE` | — | `0x20261027` | Firmware build date in packed BCD format (YYYYMMDD) |
| `0x0100` | `UART_BAUD_DIV` | — | `0x0027` | UART baud rate divisor - 125MHz clock / (16 * divisor) = baud |
| `0x0101` | `UART_CTRL` | — | `0x00` | UART control and configuration register |
| `0x0102` | `UART_STATUS` | — | `0x00` | UART status flags - read clears error bits |
| `0x0103` | `UART_TX_COUNT` | — | `0x00` | TX FIFO byte count register |
| `0x0104` | `UART_RX_COUNT` | — | `0x00` | RX FIFO byte count register |
| `0x0110` | `ETH_MAC_LOW` | — | `0x0000` | Ethernet MAC address lower 16 bits |
| `0x0111` | `ETH_MAC_HIGH` | — | `0x0000` | Ethernet MAC address upper 16 bits |
| `0x0200` | `ADC_CTRL` | — | `0x00` | LTC2992 power monitor ADC control register |
| `0x0201` | `ADC_STATUS` | — | `0x00` | LTC2992 ADC status flags - read clears |
| `0x0210` | `VCC_5V_RAW` | — | `0x0000` | 5V rail raw ADC count from LTC2992 |
| `0x0211` | `VCC_3V3_RAW` | — | `0x0000` | 3.3V rail raw ADC count from LTC2992 |
| `0x0212` | `VCC_2V5_RAW` | — | `0x0000` | 2.5V rail raw ADC count (if present) |
| `0x0213` | `VCC_1V8_RAW` | — | `0x0000` | 1.8V rail raw ADC count from LTC2992 |
| `0x0218` | `ICC_5V_RAW` | — | `0x0000` | 5V rail current sense ADC count from LTC2992 |
| `0x0219` | `ICC_3V3_RAW` | — | `0x0000` | 3.3V rail current sense ADC count from LTC2992 |
| `0x0300` | `TEMP_LOCAL` | — | `0x0000` | FPGA local die temperature from SYSMON |
| `0x0301` | `TEMP_REMOTE1` | — | `0x0000` | Remote temperature sensor 1 - RF front-end area |
| `0x0302` | `TEMP_REMOTE2` | — | `0x0000` | Remote temperature sensor 2 - Power supply area |
| `0x0308` | `TEMP_ALERT_HIGH` | — | `0x0190` | Over-temperature alert threshold (100°C default) |
| `0x0309` | `TEMP_ALERT_LOW` | — | `0xFF9C` | Under-temperature alert threshold (-25°C default, signed) |
| `0x030F` | `HEALTH_STATUS` | — | `0x00` | System health and safety status flags |
| `0x0400` | `PLL_CTRL` | — | `0x01` | ADF4355 LO synthesizer PLL control register |
| `0x0401` | `PLL_STATUS` | — | `0x00` | ADF4355 PLL status and lock detection |
| `0x0402` | `PLL_N_DIV` | — | `0x0046` | PLL N divider value for LO frequency setting |
| `0x0403` | `PLL_R_DIV` | — | `0x01` | PLL R divider (reference divider) |
| `0x0410` | `CLK_ENABLE` | — | `0x1F` | Clock output enables for LMK04828 clock generator |
| `0x0420` | `JESD_CTRL` | — | `0x00` | JESD204B interface control register |
| `0x0421` | `JESD_STATUS` | — | `0x00` | JESD204B link status and error flags |
| `0x0500` | `EEPROM_CTRL` | — | `0x00` | I2C EEPROM control and status register |
| `0x0501` | `EEPROM_ADDR` | — | `0x0000` | EEPROM byte address for read/write operations |
| `0x0502` | `EEPROM_DATA` | — | `0x0000` | EEPROM data register for read/write |
| `0x0600` | `FLASH_CTRL` | — | `0x00` | SPI Flash configuration memory control register |
| `0x0601` | `FLASH_ADDR_LOW` | — | `0x0000` | Flash address low word [15:0] |
| `0x0602` | `FLASH_ADDR_HIGH` | — | `0x0000` | Flash address high word [23:16] |
| `0x0603` | `FLASH_DATA` | — | `0x0000` | Flash data FIFO register |
| `0x0604` | `FLASH_STATUS` | — | `0x00` | Flash operation status flags - read clears |
| `0x0700` | `VGA_GAIN_CTRL` | — | `0x0F` | HMC698LP4 VGA gain control (0-22 dB, 1 dB steps) |
| `0x0701` | `RF_PATH_CTRL` | — | `0x00` | RF front-end path control and configuration |
| `0x0702` | `RF_STATUS` | — | `0x00` | RF chain status and fault detection |
| `0x0800` | `GPIO_DIR` | — | `0x0000` | GPIO direction control (0=input, 1=output) |
| `0x0801` | `GPIO_DATA` | — | `0x0000` | GPIO data read/write register |
| `0x0802` | `GPIO_INT_EN` | — | `0x0000` | GPIO interrupt enable (1=interrupt enabled) |
| `0x0803` | `GPIO_INT_STATUS` | — | `0x0000` | GPIO interrupt status flags (read-clear) |
| `0x0808` | `LED_CTRL` | — | `0x00` | System LED control register |

---
### `BOARD_ID` — Address `0x0000`

**Reset value:** `0x444B`  **Access:** see fields below

Board identification code - ASCII 'DK' + variant code

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BOARD_ID_HIGH` | `[15:8]` | R | `0x44` | Board ID high byte (ASCII 'D') |
| `BOARD_ID_LOW` | `[7:0]` | R | `0x4B` | Board ID low byte (ASCII 'K') |

---
### `BOARD_VERSION` — Address `0x0001`

**Reset value:** `0x10`  **Access:** see fields below

Hardware version number - major and minor revision

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAJOR_REV` | `[7:4]` | R | `0x1` | Major revision number |
| `MINOR_REV` | `[3:0]` | R | `0x0` | Minor revision number |

---
### `BOARD_TYPE_ID` — Address `0x0002`

**Reset value:** `0x0001`  **Access:** see fields below

Board type identifier for firmware compatibility check

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TYPE_CODE` | `[15:0]` | R | `0x0001` | Type: 0x0001 = Wideband RF Receiver |

---
### `SCRATCHPAD` — Address `0x0003`

**Reset value:** `0x0000`  **Access:** see fields below

Diagnostic read/write test register for RAM integrity verification

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEST_PATTERN` | `[15:0]` | RW | `0x0000` | Read/write test pattern - verify RAM functionality |

---
### `MCS_VERSION_MAJOR` — Address `0x0010`

**Reset value:** `0x01`  **Access:** see fields below

FPGA firmware major version number

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `FW_MAJOR` | `[7:0]` | R | `0x01` | Firmware major version |

---
### `MCS_VERSION_MINOR` — Address `0x0011`

**Reset value:** `0x00`  **Access:** see fields below

FPGA firmware minor version number

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `FW_MINOR` | `[7:0]` | R | `0x00` | Firmware minor version |

---
### `BUILD_DATE` — Address `0x0012`

**Reset value:** `0x20261027`  **Access:** see fields below

Firmware build date in packed BCD format (YYYYMMDD)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BUILD_YEAR` | `[15:0]` | R | `0x2026` | Build year in BCD (2026) |
| `BUILD_MONTH_DAY` | `[15:0]` | R | `0x1027` | Build month/day in BCD |

---
### `UART_BAUD_DIV` — Address `0x0100`

**Reset value:** `0x0027`  **Access:** see fields below

UART baud rate divisor - 125MHz clock / (16 * divisor) = baud

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DIVISOR` | `[15:0]` | RW | `0x0027` | Baud divisor: 0x0027 = 115200 @ 125MHz ref |

---
### `UART_CTRL` — Address `0x0101`

**Reset value:** `0x00`  **Access:** see fields below

UART control and configuration register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0x0` | UART enable (1=enabled) |
| `LOOPBACK` | `[1]` | RW | `0x0` | Loopback mode for test |
| `PARITY_EN` | `[2]` | RW | `0x0` | Parity enable |
| `FRAME_FORMAT` | `[7:4]` | RW | `0x0` | Frame format: 0x0=8N1 |

---
### `UART_STATUS` — Address `0x0102`

**Reset value:** `0x00`  **Access:** see fields below

UART status flags - read clears error bits

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TX_BUSY` | `[0]` | R | `0x0` | Transmitter busy flag |
| `RX_AVAIL` | `[1]` | R | `0x0` | Data available in RX FIFO |
| `FRAME_ERR` | `[2]` | RC | `0x0` | Frame error flag (read-clear) |
| `PARITY_ERR` | `[3]` | RC | `0x0` | Parity error flag (read-clear) |
| `RX_OVERRUN` | `[4]` | RC | `0x0` | RX FIFO overrun (read-clear) |

---
### `UART_TX_COUNT` — Address `0x0103`

**Reset value:** `0x00`  **Access:** see fields below

TX FIFO byte count register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TX_FIFO_LEVEL` | `[7:0]` | R | `0x00` | Number of bytes in TX FIFO |

---
### `UART_RX_COUNT` — Address `0x0104`

**Reset value:** `0x00`  **Access:** see fields below

RX FIFO byte count register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `RX_FIFO_LEVEL` | `[7:0]` | R | `0x00` | Number of bytes in RX FIFO |

---
### `ETH_MAC_LOW` — Address `0x0110`

**Reset value:** `0x0000`  **Access:** see fields below

Ethernet MAC address lower 16 bits

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAC_LOW` | `[15:0]` | R | `0x0000` | MAC address bits [15:0] - configured from EEPROM |

---
### `ETH_MAC_HIGH` — Address `0x0111`

**Reset value:** `0x0000`  **Access:** see fields below

Ethernet MAC address upper 16 bits

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAC_HIGH` | `[31:16]` | R | `0x0000` | MAC address bits [31:16] - configured from EEPROM |

---
### `ADC_CTRL` — Address `0x0200`

**Reset value:** `0x00`  **Access:** see fields below

LTC2992 power monitor ADC control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `START` | `[0]` | RW | `0x0` | Start ADC conversion (1=start) |
| `CONTINUOUS` | `[1]` | RW | `0x0` | Continuous conversion mode |
| `CHANNEL_SELECT` | `[3:2]` | RW | `0x0` | Channel select: 0=V1/V2, 1=V3/V4, 2=Current |

---
### `ADC_STATUS` — Address `0x0201`

**Reset value:** `0x00`  **Access:** see fields below

LTC2992 ADC status flags - read clears

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA_READY` | `[0]` | R | `0x0` | New data available flag |
| `OVERRANGE` | `[1]` | RC | `0x0` | ADC overrange flag (read-clear) |

---
### `VCC_5V_RAW` — Address `0x0210`

**Reset value:** `0x0000`  **Access:** see fields below

5V rail raw ADC count from LTC2992

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | R | `0x000` | Raw ADC count: multiply by 5.0/4096 for Volts |
| `RESERVED` | `[15:12]` | R | `0x0` | Reserved bits |

---
### `VCC_3V3_RAW` — Address `0x0211`

**Reset value:** `0x0000`  **Access:** see fields below

3.3V rail raw ADC count from LTC2992

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | R | `0x000` | Raw ADC count: multiply by 3.3/4096 for Volts |
| `RESERVED` | `[15:12]` | R | `0x0` | Reserved bits |

---
### `VCC_2V5_RAW` — Address `0x0212`

**Reset value:** `0x0000`  **Access:** see fields below

2.5V rail raw ADC count (if present)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | R | `0x000` | Raw ADC count: multiply by 2.5/4096 for Volts |
| `RESERVED` | `[15:12]` | R | `0x0` | Reserved bits |

---
### `VCC_1V8_RAW` — Address `0x0213`

**Reset value:** `0x0000`  **Access:** see fields below

1.8V rail raw ADC count from LTC2992

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | R | `0x000` | Raw ADC count: multiply by 1.8/4096 for Volts |
| `RESERVED` | `[15:12]` | R | `0x0` | Reserved bits |

---
### `ICC_5V_RAW` — Address `0x0218`

**Reset value:** `0x0000`  **Access:** see fields below

5V rail current sense ADC count from LTC2992

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | R | `0x000` | Raw ADC count: multiply by scale factor for Amps |
| `RESERVED` | `[15:12]` | R | `0x0` | Reserved bits |

---
### `ICC_3V3_RAW` — Address `0x0219`

**Reset value:** `0x0000`  **Access:** see fields below

3.3V rail current sense ADC count from LTC2992

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | R | `0x000` | Raw ADC count: multiply by scale factor for Amps |
| `RESERVED` | `[15:12]` | R | `0x0` | Reserved bits |

---
### `TEMP_LOCAL` — Address `0x0300`

**Reset value:** `0x0000`  **Access:** see fields below

FPGA local die temperature from SYSMON

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_VALUE` | `[9:0]` | R | `0x000` | Temperature in 0.25°C units (signed, 10-bit) |
| `RESERVED` | `[15:10]` | R | `0x0` | Reserved bits |

---
### `TEMP_REMOTE1` — Address `0x0301`

**Reset value:** `0x0000`  **Access:** see fields below

Remote temperature sensor 1 - RF front-end area

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_VALUE` | `[9:0]` | R | `0x000` | Remote temperature in 0.25°C units (signed) |
| `RESERVED` | `[15:10]` | R | `0x0` | Reserved bits |

---
### `TEMP_REMOTE2` — Address `0x0302`

**Reset value:** `0x0000`  **Access:** see fields below

Remote temperature sensor 2 - Power supply area

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_VALUE` | `[9:0]` | R | `0x000` | Remote temperature in 0.25°C units (signed) |
| `RESERVED` | `[15:10]` | R | `0x0` | Reserved bits |

---
### `TEMP_ALERT_HIGH` — Address `0x0308`

**Reset value:** `0x0190`  **Access:** see fields below

Over-temperature alert threshold (100°C default)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ALERT_THRESH` | `[9:0]` | RW | `0x190` | High temp threshold in 0.25°C units (0x190 = 100°C) |
| `RESERVED` | `[15:10]` | RW | `0x0` | Reserved bits |

---
### `TEMP_ALERT_LOW` — Address `0x0309`

**Reset value:** `0xFF9C`  **Access:** see fields below

Under-temperature alert threshold (-25°C default, signed)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ALERT_THRESH` | `[9:0]` | RW | `0x39C` | Low temp threshold in 0.25°C units (-25°C) |
| `RESERVED` | `[15:10]` | RW | `0x3F` | Reserved bits |

---
### `HEALTH_STATUS` — Address `0x030F`

**Reset value:** `0x00`  **Access:** see fields below

System health and safety status flags

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_OK` | `[0]` | R | `0x0` | Temperature within limits (1=OK) |
| `VOLT_OK` | `[1]` | R | `0x0` | All voltages within tolerance (1=OK) |
| `PLL_LOCK` | `[2]` | R | `0x0` | PLL lock status (1=locked) |
| `RF_ENABLE_OK` | `[3]` | R | `0x0` | RF chain enable status (1=enabled) |
| `ADC_LINK_OK` | `[4]` | R | `0x0` | JESD204B link status (1=locked) |
| `SYSTEM_OK` | `[7]` | R | `0x0` | Overall system health (1=all OK) |

---
### `PLL_CTRL` — Address `0x0400`

**Reset value:** `0x01`  **Access:** see fields below

ADF4355 LO synthesizer PLL control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0x1` | PLL enable (1=enabled, reset=enabled) |
| `RESET_N` | `[1]` | RW | `0x0` | PLL reset (0=reset, 1=normal) |
| `REF_SEL` | `[3:2]` | RW | `0x0` | Reference clock select: 0=125MHz onboard, 1=external |

---
### `PLL_STATUS` — Address `0x0401`

**Reset value:** `0x00`  **Access:** see fields below

ADF4355 PLL status and lock detection

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LOCKED` | `[0]` | R | `0x0` | PLL lock detected (1=locked) |
| `LOSS_OF_LOCK` | `[1]` | RC | `0x0` | Loss of lock event (read-clear) |
| `MUXOUT` | `[4:2]` | R | `0x0` | MUXOUT status from ADF4355 |

---
### `PLL_N_DIV` — Address `0x0402`

**Reset value:** `0x0046`  **Access:** see fields below

PLL N divider value for LO frequency setting

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `N_VALUE` | `[15:0]` | RW | `0x0046` | N divider: f_LO = f_REF * N / R (0x46=70 for 8.75GHz LO) |

---
### `PLL_R_DIV` — Address `0x0403`

**Reset value:** `0x01`  **Access:** see fields below

PLL R divider (reference divider)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `R_VALUE` | `[7:0]` | RW | `0x1` | R divider: f_LO = f_REF * N / R (1=divide by 1) |
| `RESERVED` | `[15:8]` | RW | `0x0` | Reserved bits |

---
### `CLK_ENABLE` — Address `0x0410`

**Reset value:** `0x1F`  **Access:** see fields below

Clock output enables for LMK04828 clock generator

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `CLK_ADC_EN` | `[0]` | RW | `0x1` | ADC sampling clock enable |
| `CLK_FPGA_EN` | `[1]` | RW | `0x1` | FPGA system clock enable |
| `CLK_SYNC_EN` | `[2]` | RW | `0x1` | SYSREF sync clock enable |
| `CLK_REF_EN` | `[3]` | RW | `0x1` | Reference clock to PLL enable |
| `CLK spare_EN` | `[7:4]` | RW | `0x1` | Spare clock outputs enable |

---
### `JESD_CTRL` — Address `0x0420`

**Reset value:** `0x00`  **Access:** see fields below

JESD204B interface control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LINK_ENABLE` | `[0]` | RW | `0x0` | JESD204B link enable (1=enabled) |
| `RESET` | `[1]` | RW | `0x0` | JESD204B link reset (1=assert reset) |
| `LANE_ENABLE` | `[9:2]` | RW | `0xFF` | Lane enable bitmap (8 lanes) |
| `SUBCLASS` | `[11:10]` | RW | `0x1` | Subclass: 0=none, 1=SYSREF sync |

---
### `JESD_STATUS` — Address `0x0421`

**Reset value:** `0x00`  **Access:** see fields below

JESD204B link status and error flags

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LINK_LOCKED` | `[0]` | R | `0x0` | Code group sync achieved (1=locked) |
| `PHY_READY` | `[1]` | R | `0x0` | PHY layer ready |
| `DISP_ERROR` | `[8]` | RC | `0x0` | Disparity error (read-clear) |
| `CRC_ERROR` | `[9]` | RC | `0x0` | CRC error (read-clear) |

---
### `EEPROM_CTRL` — Address `0x0500`

**Reset value:** `0x00`  **Access:** see fields below

I2C EEPROM control and status register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READ` | `[0]` | RW | `0x0` | Start read operation (1=start) |
| `WRITE` | `[1]` | RW | `0x0` | Start write operation (1=start) |
| `ERASE` | `[2]` | RW | `0x0` | Erase operation (for EEPROM with erase) |
| `BUSY` | `[7]` | R | `0x0` | EEPROM busy flag (1=busy) |

---
### `EEPROM_ADDR` — Address `0x0501`

**Reset value:** `0x0000`  **Access:** see fields below

EEPROM byte address for read/write operations

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADDRESS` | `[15:0]` | RW | `0x0000` | 16-bit EEPROM byte address |

---
### `EEPROM_DATA` — Address `0x0502`

**Reset value:** `0x0000`  **Access:** see fields below

EEPROM data register for read/write

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA` | `[15:0]` | RW | `0x0000` | 16-bit data (2 bytes) |

---
### `FLASH_CTRL` — Address `0x0600`

**Reset value:** `0x00`  **Access:** see fields below

SPI Flash configuration memory control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READ` | `[0]` | RW | `0x0` | Flash read operation enable |
| `WRITE` | `[1]` | RW | `0x0` | Flash program/write operation |
| `ERASE_SECTOR` | `[2]` | RW | `0x0` | Sector erase operation |
| `ERASE_CHIP` | `[3]` | RW | `0x0` | Chip erase operation |
| `BUSY` | `[7]` | R | `0x0` | Flash busy flag (1=busy) |

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
| `RESERVED` | `[15:8]` | RW | `0x0` | Reserved bits |

---
### `FLASH_DATA` — Address `0x0603`

**Reset value:** `0x0000`  **Access:** see fields below

Flash data FIFO register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA` | `[15:0]` | RW | `0x0000` | 16-bit data word (2 bytes) |

---
### `FLASH_STATUS` — Address `0x0604`

**Reset value:** `0x00`  **Access:** see fields below

Flash operation status flags - read clears

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READY` | `[0]` | R | `0x1` | Flash ready for operation (1=ready) |
| `WRITE_ERR` | `[1]` | RC | `0x0` | Write/program error flag (read-clear) |
| `ERASE_ERR` | `[2]` | RC | `0x0` | Erase error flag (read-clear) |

---
### `VGA_GAIN_CTRL` — Address `0x0700`

**Reset value:** `0x0F`  **Access:** see fields below

HMC698LP4 VGA gain control (0-22 dB, 1 dB steps)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GAIN_CODE` | `[4:0]` | RW | `0x0F` | Gain code: 0=0dB, 22=22dB (default 15dB) |
| `GAIN_ENABLE` | `[7]` | RW | `0x0` | VGA gain enable (1=enabled) |
| `RESERVED` | `[15:8]` | RW | `0x0` | Reserved bits |

---
### `RF_PATH_CTRL` — Address `0x0701`

**Reset value:** `0x00`  **Access:** see fields below

RF front-end path control and configuration

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LNA_ENABLE` | `[0]` | RW | `0x0` | LNA enable (1=enabled) |
| `MIXER_ENABLE` | `[1]` | RW | `0x0` | Mixer enable (1=enabled) |
| `IF_AMP_ENABLE` | `[2]` | RW | `0x0` | IF amplifier enable (1=enabled) |
| `RF_PATH_BYPASS` | `[3]` | RW | `0x0` | Bypass mode (1=bypass LNA/VGA) |
| `ATTENUATOR_EN` | `[4]` | RW | `0x0` | Input attenuator enable |

---
### `RF_STATUS` — Address `0x0702`

**Reset value:** `0x00`  **Access:** see fields below

RF chain status and fault detection

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LNA_BIAS_OK` | `[0]` | R | `0x0` | LNA bias current OK flag |
| `MIXER_LO_OK` | `[1]` | R | `0x0` | Mixer LO power OK flag |
| `IF_OVERLOAD` | `[2]` | RC | `0x0` | IF overload detected (read-clear) |
| `RF_POWER_HIGH` | `[3]` | R | `0x0` | RF input power too high warning |

---
### `GPIO_DIR` — Address `0x0800`

**Reset value:** `0x0000`  **Access:** see fields below

GPIO direction control (0=input, 1=output)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GPIO_DIR` | `[15:0]` | RW | `0x0000` | Direction: 0=input, 1=output (default all inputs) |

---
### `GPIO_DATA` — Address `0x0801`

**Reset value:** `0x0000`  **Access:** see fields below

GPIO data read/write register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GPIO_OUT` | `[7:0]` | RW | `0x00` | GPIO output data (writes affect outputs) |
| `GPIO_IN` | `[15:8]` | R | `0x00` | GPIO input data (read-only) |

---
### `GPIO_INT_EN` — Address `0x0802`

**Reset value:** `0x0000`  **Access:** see fields below

GPIO interrupt enable (1=interrupt enabled)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `INT_EN` | `[15:0]` | RW | `0x0000` | Interrupt enable per GPIO pin |

---
### `GPIO_INT_STATUS` — Address `0x0803`

**Reset value:** `0x0000`  **Access:** see fields below

GPIO interrupt status flags (read-clear)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `INT_FLAG` | `[15:0]` | RC | `0x0000` | Interrupt flag per pin (read to clear) |

---
### `LED_CTRL` — Address `0x0808`

**Reset value:** `0x00`  **Access:** see fields below

System LED control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LED_POWER` | `[0]` | RW | `0x1` | Power LED (green, 1=on) |
| `LED_STATUS` | `[1]` | RW | `0x1` | Status LED (amber, 1=on) |
| `LED_ERROR` | `[2]` | RW | `0x0` | Error LED (red, 1=on) |
| `LED_RF_ACTIVITY` | `[3]` | RW | `0x0` | RF activity indicator |
| `LED_LINK` | `[4]` | RW | `0x0` | JESD204B link indicator |
| `BLINK_RATE` | `[7:6]` | RW | `0x0` | Blink rate: 0=off, 1=1Hz, 2=2Hz, 3=4Hz |
