# Register Description Table (RDT)
## Rf Receiver

> **Total registers:** 46

RF Receiver (5-18 GHz) Glue Logic Register Map and Initialization Sequence. Provides comprehensive control and monitoring for board identification, communication (UART/Ethernet), power supply monitoring (5V/8V/12V ADC), temperature sensing (FPGA + 2 remote), PLL/clock synthesis, EEPROM/flash storage, GPIO, and RF chain control (LNA/driver enable). Initialization covers POR self-check, PLL lock verification, peripheral enable, communication setup, temperature alert arming, calibration data loading, and RF chain enable with health verification.

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
| `0x0000` | `BOARD_ID` | — | `0xA505` | Board identification code - ASCII 'RF' (0x5246) in upper byte, project code 0x05 in lower byte |
| `0x0001` | `BOARD_VERSION` | — | `0x10` | Hardware version number - major.minor format |
| `0x0002` | `BOARD_TYPE_ID` | — | `0x5246` | Board type identifier - ASCII 'RF' |
| `0x0003` | `SCRATCHPAD` | — | `0x0000` | Test register for RAM verification and loopback testing |
| `0x0010` | `MCS_VERSION_MAJOR` | — | `0x01` | FPGA firmware major version number |
| `0x0011` | `MCS_VERSION_MINOR` | — | `0x00` | FPGA firmware minor version number |
| `0x0012` | `BUILD_DATE` | — | `0x20260417` | Firmware build date in packed BCD format (YYYYMMDD) |
| `0x0100` | `UART_BAUD_DIV` | — | `0x0034` | UART baud rate divisor for 115200 baud (assuming 50MHz clock) |
| `0x0101` | `UART_CTRL` | — | `0x00` | UART control register - enable, loopback, frame format |
| `0x0102` | `UART_STATUS` | — | `0x00` | UART status flags - read to clear |
| `0x0103` | `UART_TX_COUNT` | — | `0x00` | TX FIFO byte count |
| `0x0104` | `UART_RX_COUNT` | — | `0x00` | RX FIFO byte count |
| `0x0110` | `ETH_MAC_LOW` | — | `0x0000` | Ethernet MAC address lower 16 bits [15:0] |
| `0x0111` | `ETH_MAC_HIGH` | — | `0x0000` | Ethernet MAC address upper 16 bits [31:16] |
| `0x0200` | `ADC_CTRL` | — | `0x00` | ADC control for supply voltage monitoring |
| `0x0201` | `ADC_STATUS` | — | `0x00` | ADC status flags - read to clear |
| `0x0210` | `VCC_5V_RAW` | — | `0x0000` | 5V rail ADC count from LM22676-5.0 output |
| `0x0211` | `VCC_8V_RAW` | — | `0x0000` | 8V rail ADC count from LT1964-8 LDO output |
| `0x0212` | `VCC_12V_RAW` | — | `0x0000` | Input 12V raw supply ADC count (pre-filter) |
| `0x0218` | `ICC_5V_RAW` | — | `0x0000` | 5V rail current sense ADC count |
| `0x0219` | `ICC_8V_RAW` | — | `0x0000` | 8V rail current sense ADC count |
| `0x0300` | `TEMP_LOCAL` | — | `0x0000` | FPGA die temperature in 0.25°C units (signed) |
| `0x0301` | `TEMP_REMOTE1` | — | `0x0000` | Remote temperature sensor 1 - near LNA |
| `0x0302` | `TEMP_REMOTE2` | — | `0x0000` | Remote temperature sensor 2 - near Driver Amp |
| `0x0308` | `TEMP_ALERT_HIGH` | — | `0x0190` | Over-temperature alert threshold (100°C = 0x0190) |
| `0x0309` | `TEMP_ALERT_LOW` | — | `0xFF9C` | Under-temperature alert threshold (-25°C = 0xFF9C) |
| `0x030F` | `HEALTH_STATUS` | — | `0x00` | System health status flags |
| `0x0400` | `PLL_CTRL` | — | `0x00` | PLL control for RF clock synthesis |
| `0x0401` | `PLL_STATUS` | — | `0x00` | PLL lock status indicator |
| `0x0402` | `PLL_N_DIV` | — | `0x0032` | PLL N divider value (50 = 0x0032 default) |
| `0x0403` | `PLL_R_DIV` | — | `0x0001` | PLL R divider value (1 = default) |
| `0x0410` | `CLK_ENABLE` | — | `0x00` | Clock output enables - one bit per output |
| `0x0500` | `EEPROM_CTRL` | — | `0x00` | EEPROM interface control for calibration storage |
| `0x0501` | `EEPROM_ADDR` | — | `0x0000` | EEPROM byte address [15:0] |
| `0x0502` | `EEPROM_DATA` | — | `0x0000` | EEPROM read/write data [15:0] |
| `0x0600` | `FLASH_CTRL` | — | `0x00` | Configuration flash interface control |
| `0x0601` | `FLASH_ADDR_LOW` | — | `0x0000` | Flash address low word [15:0] |
| `0x0602` | `FLASH_ADDR_HIGH` | — | `0x0000` | Flash address high word [23:16] |
| `0x0603` | `FLASH_DATA` | — | `0x0000` | Flash read/write data FIFO |
| `0x0604` | `FLASH_STATUS` | — | `0x00` | Flash operation status - read to clear errors |
| `0x0800` | `GPIO_DIR` | — | `0x0000` | GPIO direction control (0=input, 1=output) |
| `0x0801` | `GPIO_DATA` | — | `0x0000` | GPIO data output/input |
| `0x0700` | `LNA_GAIN_CTRL` | — | `0x00` | LNA gain control (future expansion for digital gain adjust) |
| `0x0701` | `RF_PHASE_CTRL` | — | `0x00` | RF phase control (future phase shifter) |
| `0x0708` | `RF_ENABLE` | — | `0x00` | RF chain enable control |
| `0x070F` | `RF_STATUS` | — | `0x00` | RF chain status monitoring |

---
### `BOARD_ID` — Address `0x0000`

**Reset value:** `0xA505`  **Access:** see fields below

Board identification code - ASCII 'RF' (0x5246) in upper byte, project code 0x05 in lower byte

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BOARD_ASCII` | `[15:0]` | R | `0xA505` | Unique board identifier 0xA505 for RF Receiver |

---
### `BOARD_VERSION` — Address `0x0001`

**Reset value:** `0x10`  **Access:** see fields below

Hardware version number - major.minor format

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAJOR_VER` | `[7:4]` | R | `0x1` | Major version number |
| `MINOR_VER` | `[3:0]` | R | `0x0` | Minor version number |

---
### `BOARD_TYPE_ID` — Address `0x0002`

**Reset value:** `0x5246`  **Access:** see fields below

Board type identifier - ASCII 'RF'

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TYPE_ASCII` | `[15:0]` | R | `0x5246` | Type identifier 0x5246 |

---
### `SCRATCHPAD` — Address `0x0003`

**Reset value:** `0x0000`  **Access:** see fields below

Test register for RAM verification and loopback testing

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEST_DATA` | `[15:0]` | RW | `0x0000` | Read/write test pattern - used for memory integrity check |

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

**Reset value:** `0x20260417`  **Access:** see fields below

Firmware build date in packed BCD format (YYYYMMDD)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BUILD_BCD` | `[31:0]` | R | `0x20260417` | Build date: 2026-04-17 (17.04.2026 from GLR) |

---
### `UART_BAUD_DIV` — Address `0x0100`

**Reset value:** `0x0034`  **Access:** see fields below

UART baud rate divisor for 115200 baud (assuming 50MHz clock)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BAUD_DIV` | `[15:0]` | RW | `0x0034` | Baud rate divisor - 0x0034 = 52 for 115200 baud at 50MHz |

---
### `UART_CTRL` — Address `0x0101`

**Reset value:** `0x00`  **Access:** see fields below

UART control register - enable, loopback, frame format

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0` | UART enable bit (1=enabled) |
| `LOOPBACK` | `[1]` | RW | `0` | Loopback mode for test (1=loopback) |
| `FRAME_FORMAT` | `[7:4]` | RW | `0x0` | Frame format: 0=8N1 standard |

---
### `UART_STATUS` — Address `0x0102`

**Reset value:** `0x00`  **Access:** see fields below

UART status flags - read to clear

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TX_BUSY` | `[0]` | R | `0` | Transmitter busy flag |
| `RX_AVAIL` | `[1]` | RC | `0` | Data available in RX FIFO (read clears) |
| `FRAME_ERR` | `[2]` | RC | `0` | Frame error detected (read clears) |
| `OVERRUN_ERR` | `[3]` | RC | `0` | RX FIFO overrun (read clears) |

---
### `UART_TX_COUNT` — Address `0x0103`

**Reset value:** `0x00`  **Access:** see fields below

TX FIFO byte count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TX_FIFO_CNT` | `[7:0]` | R | `0x00` | Number of bytes in TX FIFO |

---
### `UART_RX_COUNT` — Address `0x0104`

**Reset value:** `0x00`  **Access:** see fields below

RX FIFO byte count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `RX_FIFO_CNT` | `[7:0]` | R | `0x00` | Number of bytes in RX FIFO |

---
### `ETH_MAC_LOW` — Address `0x0110`

**Reset value:** `0x0000`  **Access:** see fields below

Ethernet MAC address lower 16 bits [15:0]

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAC_LOW` | `[15:0]` | R | `0x0000` | MAC address bits [15:0] - factory programmed |

---
### `ETH_MAC_HIGH` — Address `0x0111`

**Reset value:** `0x0000`  **Access:** see fields below

Ethernet MAC address upper 16 bits [31:16]

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAC_HIGH` | `[15:0]` | R | `0x0000` | MAC address bits [31:16] - factory programmed |

---
### `ADC_CTRL` — Address `0x0200`

**Reset value:** `0x00`  **Access:** see fields below

ADC control for supply voltage monitoring

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `START` | `[0]` | RW | `0` | Start single conversion (self-clearing) |
| `CONTINUOUS` | `[1]` | RW | `0` | Continuous conversion mode (1=enabled) |
| `CHANNEL_SEL` | `[3:2]` | RW | `0x0` | Channel select: 0=auto-scan, 1=5V, 2=8V |

---
### `ADC_STATUS` — Address `0x0201`

**Reset value:** `0x00`  **Access:** see fields below

ADC status flags - read to clear

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA_READY` | `[0]` | RC | `0` | New data available (read clears) |
| `OVERRANGE` | `[1]` | RC | `0` | Input overrange detected (read clears) |

---
### `VCC_5V_RAW` — Address `0x0210`

**Reset value:** `0x0000`  **Access:** see fields below

5V rail ADC count from LM22676-5.0 output

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_5V` | `[11:0]` | R | `0x000` | 12-bit ADC count - multiply by 5.0/4096 for Volts |

---
### `VCC_8V_RAW` — Address `0x0211`

**Reset value:** `0x0000`  **Access:** see fields below

8V rail ADC count from LT1964-8 LDO output

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_8V` | `[11:0]` | R | `0x000` | 12-bit ADC count - multiply by 8.0/4096 for Volts |

---
### `VCC_12V_RAW` — Address `0x0212`

**Reset value:** `0x0000`  **Access:** see fields below

Input 12V raw supply ADC count (pre-filter)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_12V` | `[11:0]` | R | `0x000` | 12-bit ADC count - input supply monitoring |

---
### `ICC_5V_RAW` — Address `0x0218`

**Reset value:** `0x0000`  **Access:** see fields below

5V rail current sense ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `I_SENSE_5V` | `[11:0]` | R | `0x000` | Current sense ADC - 5V rail current |

---
### `ICC_8V_RAW` — Address `0x0219`

**Reset value:** `0x0000`  **Access:** see fields below

8V rail current sense ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `I_SENSE_8V` | `[11:0]` | R | `0x000` | Current sense ADC - 8V rail current |

---
### `TEMP_LOCAL` — Address `0x0300`

**Reset value:** `0x0000`  **Access:** see fields below

FPGA die temperature in 0.25°C units (signed)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `FPGA_TEMP` | `[9:0]` | R | `0x000` | Temperature in 0.25°C steps (signed 10-bit) |

---
### `TEMP_REMOTE1` — Address `0x0301`

**Reset value:** `0x0000`  **Access:** see fields below

Remote temperature sensor 1 - near LNA

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `REMOTE1_TEMP` | `[9:0]` | R | `0x000` | Remote sensor 1 temperature (signed 10-bit) |

---
### `TEMP_REMOTE2` — Address `0x0302`

**Reset value:** `0x0000`  **Access:** see fields below

Remote temperature sensor 2 - near Driver Amp

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `REMOTE2_TEMP` | `[9:0]` | R | `0x000` | Remote sensor 2 temperature (signed 10-bit) |

---
### `TEMP_ALERT_HIGH` — Address `0x0308`

**Reset value:** `0x0190`  **Access:** see fields below

Over-temperature alert threshold (100°C = 0x0190)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `HIGH_THRESH` | `[9:0]` | RW | `0x190` | High temp threshold in 0.25°C units (100°C default) |

---
### `TEMP_ALERT_LOW` — Address `0x0309`

**Reset value:** `0xFF9C`  **Access:** see fields below

Under-temperature alert threshold (-25°C = 0xFF9C)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LOW_THRESH` | `[9:0]` | RW | `0xFF9C` | Low temp threshold in 0.25°C units (-25°C default) |

---
### `HEALTH_STATUS` — Address `0x030F`

**Reset value:** `0x00`  **Access:** see fields below

System health status flags

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_OK` | `[0]` | R | `0` | Temperature within limits (1=OK) |
| `VOLT_OK` | `[1]` | R | `0` | All voltages within tolerance (1=OK) |
| `PLL_LOCK` | `[2]` | R | `0` | PLL locked indicator (1=locked) |
| `SYSTEM_OK` | `[7]` | R | `0` | Overall system health (all checks pass) |

---
### `PLL_CTRL` — Address `0x0400`

**Reset value:** `0x00`  **Access:** see fields below

PLL control for RF clock synthesis

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0` | PLL enable (1=enabled) |
| `RESET` | `[1]` | RW | `0` | PLL reset (1=reset) |
| `REF_SEL` | `[3:2]` | RW | `0x0` | Reference clock select: 0=internal, 1=external |

---
### `PLL_STATUS` — Address `0x0401`

**Reset value:** `0x00`  **Access:** see fields below

PLL lock status indicator

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LOCKED` | `[0]` | R | `0` | PLL locked (1=locked) |
| `LOSS_OF_LOCK` | `[1]` | RC | `0` | Loss of lock event (read clears) |
| `REF_PRESENT` | `[2]` | R | `0` | Reference clock present (1=present) |

---
### `PLL_N_DIV` — Address `0x0402`

**Reset value:** `0x0032`  **Access:** see fields below

PLL N divider value (50 = 0x0032 default)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `N_DIVIDER` | `[15:0]` | RW | `0x32` | N divider value for PLL feedback |

---
### `PLL_R_DIV` — Address `0x0403`

**Reset value:** `0x0001`  **Access:** see fields below

PLL R divider value (1 = default)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `R_DIVIDER` | `[7:0]` | RW | `0x01` | R divider value for reference |

---
### `CLK_ENABLE` — Address `0x0410`

**Reset value:** `0x00`  **Access:** see fields below

Clock output enables - one bit per output

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `CLK0_EN` | `[0]` | RW | `0` | Clock output 0 enable |
| `CLK1_EN` | `[1]` | RW | `0` | Clock output 1 enable |
| `CLK2_EN` | `[2]` | RW | `0` | Clock output 2 enable |
| `CLK3_EN` | `[3]` | RW | `0` | Clock output 3 enable |

---
### `EEPROM_CTRL` — Address `0x0500`

**Reset value:** `0x00`  **Access:** see fields below

EEPROM interface control for calibration storage

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READ` | `[0]` | RW | `0` | Start read operation |
| `WRITE` | `[1]` | RW | `0` | Start write operation |
| `ERASE` | `[2]` | RW | `0` | Erase byte operation |
| `BUSY` | `[7]` | R | `0` | EEPROM operation in progress (1=busy) |

---
### `EEPROM_ADDR` — Address `0x0501`

**Reset value:** `0x0000`  **Access:** see fields below

EEPROM byte address [15:0]

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `EEP_ADDR` | `[15:0]` | RW | `0x0000` | 16-bit EEPROM address |

---
### `EEPROM_DATA` — Address `0x0502`

**Reset value:** `0x0000`  **Access:** see fields below

EEPROM read/write data [15:0]

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `EEP_DATA` | `[15:0]` | RW | `0x0000` | 16-bit data value |

---
### `FLASH_CTRL` — Address `0x0600`

**Reset value:** `0x00`  **Access:** see fields below

Configuration flash interface control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READ` | `[0]` | RW | `0` | Flash read operation |
| `WRITE` | `[1]` | RW | `0` | Flash write operation |
| `ERASE_SECTOR` | `[2]` | RW | `0` | Erase flash sector |
| `ERASE_CHIP` | `[3]` | RW | `0` | Erase entire chip |
| `BUSY` | `[7]` | R | `0` | Flash busy flag |

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
| `FLASH_FIFO` | `[15:0]` | RW | `0x0000` | 16-bit flash data word |

---
### `FLASH_STATUS` — Address `0x0604`

**Reset value:** `0x00`  **Access:** see fields below

Flash operation status - read to clear errors

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READY` | `[0]` | R | `0` | Flash ready for operation |
| `WRITE_ERR` | `[1]` | RC | `0` | Write error (read clears) |
| `ERASE_ERR` | `[2]` | RC | `0` | Erase error (read clears) |

---
### `GPIO_DIR` — Address `0x0800`

**Reset value:** `0x0000`  **Access:** see fields below

GPIO direction control (0=input, 1=output)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GPIO0_DIR` | `[0]` | RW | `0` | GPIO0 direction |
| `GPIO1_DIR` | `[1]` | RW | `0` | GPIO1 direction |
| `GPIO2_DIR` | `[2]` | RW | `0` | GPIO2 direction |
| `GPIO3_DIR` | `[3]` | RW | `0` | GPIO3 direction |
| `GPIO4_DIR` | `[4]` | RW | `0` | GPIO4 direction |
| `GPIO5_DIR` | `[5]` | RW | `0` | GPIO5 direction |
| `GPIO6_DIR` | `[6]` | RW | `0` | GPIO6 direction |
| `GPIO7_DIR` | `[7]` | RW | `0` | GPIO7 direction |

---
### `GPIO_DATA` — Address `0x0801`

**Reset value:** `0x0000`  **Access:** see fields below

GPIO data output/input

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GPIO0_DATA` | `[0]` | RW | `0` | GPIO0 data |
| `GPIO1_DATA` | `[1]` | RW | `0` | GPIO1 data |
| `GPIO2_DATA` | `[2]` | RW | `0` | GPIO2 data |
| `GPIO3_DATA` | `[3]` | RW | `0` | GPIO3 data |
| `GPIO4_DATA` | `[4]` | RW | `0` | GPIO4 data |
| `GPIO5_DATA` | `[5]` | RW | `0` | GPIO5 data |
| `GPIO6_DATA` | `[6]` | RW | `0` | GPIO6 data |
| `GPIO7_DATA` | `[7]` | RW | `0` | GPIO7 data |

---
### `LNA_GAIN_CTRL` — Address `0x0700`

**Reset value:** `0x00`  **Access:** see fields below

LNA gain control (future expansion for digital gain adjust)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LNA_GAIN` | `[7:0]` | RW | `0x00` | LNA gain setting - reserved for future VGA control |

---
### `RF_PHASE_CTRL` — Address `0x0701`

**Reset value:** `0x00`  **Access:** see fields below

RF phase control (future phase shifter)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `PHASE` | `[15:0]` | RW | `0x00` | Phase control word - reserved for future phase shifter |

---
### `RF_ENABLE` — Address `0x0708`

**Reset value:** `0x00`  **Access:** see fields below

RF chain enable control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LNA_EN` | `[0]` | RW | `0` | LNA enable (power control) |
| `DRIVER_EN` | `[1]` | RW | `0` | Driver amplifier enable |

---
### `RF_STATUS` — Address `0x070F`

**Reset value:** `0x00`  **Access:** see fields below

RF chain status monitoring

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `RF_PRESENT` | `[0]` | R | `0` | RF input detected (1=present) |
| `LNA_OK` | `[1]` | R | `0` | LNA bias OK (1=OK) |
| `DRIVER_OK` | `[2]` | R | `0` | Driver amp bias OK (1=OK) |
