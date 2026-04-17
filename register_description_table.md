# Register Description Table (RDT)
## receiver

> **Total registers:** 49

Receiver FPGA register map spanning 8 functional groups (0x000-0x800) with 28 registers for board info, UART/Ethernet communication, ADC supply monitoring, temperature sensing, PLL/clock control, EEPROM/Flash NV storage, and GPIO. 16-step initialization sequence covering power-on reset verification, PLL configuration, peripheral enable, communication setup, and receiver-specific initialization with polling and self-check procedures.

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
| `0x0000` | `BOARD_ID` | — | `0x5245` | Receiver board identification code - ASCII 'RE' |
| `0x0001` | `BOARD_VERSION` | — | `0x11` | Hardware version number - major.minor format |
| `0x0002` | `BOARD_TYPE_ID` | — | `0x0003` | Board type identifier for firmware compatibility check |
| `0x0003` | `SCRATCHPAD` | — | `0x0000` | General-purpose read/write test register for RAM verification |
| `0x0010` | `MCS_VERSION_MAJOR` | — | `0x02` | FPGA firmware major version number |
| `0x0011` | `MCS_VERSION_MINOR` | — | `0x05` | FPGA firmware minor version number |
| `0x0012` | `BUILD_DATE` | — | `0x20250115` | Firmware build date in packed BCD format (YYYYMMDD) |
| `0x0100` | `UART_BAUD_DIV` | — | `0x0068` | UART baud rate divisor for 115200 baud @ 100MHz reference |
| `0x0101` | `UART_CTRL` | — | `0x00` | UART control and configuration register |
| `0x0102` | `UART_STATUS` | — | `0x00` | UART status flags - read clears sticky bits |
| `0x0103` | `UART_TX_COUNT` | — | `0x00` | TX FIFO byte count register |
| `0x0104` | `UART_RX_COUNT` | — | `0x00` | RX FIFO byte count register |
| `0x0110` | `ETH_MAC_LOW` | — | `0x1234` | Ethernet MAC address lower 16 bits |
| `0x0111` | `ETH_MAC_HIGH` | — | `0x5678` | Ethernet MAC address upper 16 bits (of 48-bit MAC) |
| `0x0200` | `ADC_CTRL` | — | `0x00` | ADC control register for supply monitoring |
| `0x0201` | `ADC_STATUS` | — | `0x00` | ADC status flags |
| `0x0210` | `VCC_5V_RAW` | — | `0x0FFF` | 5V supply rail raw ADC count |
| `0x0211` | `VCC_3V3_RAW` | — | `0x0CCC` | 3.3V supply rail raw ADC count |
| `0x0212` | `VCC_2V5_RAW` | — | `0x0BFF` | 2.5V supply rail raw ADC count |
| `0x0213` | `VCC_1V8_RAW` | — | `0x0898` | 1.8V supply rail raw ADC count |
| `0x0218` | `ICC_5V_RAW` | — | `0x0000` | 5V rail current monitor raw ADC count |
| `0x0219` | `ICC_3V3_RAW` | — | `0x0000` | 3.3V rail current monitor raw ADC count |
| `0x0300` | `TEMP_LOCAL` | — | `0x0140` | FPGA die temperature in 0.25°C units (signed) |
| `0x0301` | `TEMP_REMOTE1` | — | `0x0190` | Remote sensor 1 temperature (front panel) |
| `0x0302` | `TEMP_REMOTE2` | — | `0x0168` | Remote sensor 2 temperature (power supply area) |
| `0x0308` | `TEMP_ALERT_HIGH` | — | `0x0190` | Over-temperature alert threshold |
| `0x0309` | `TEMP_ALERT_LOW` | — | `0xFF9C` | Under-temperature alert threshold (signed) |
| `0x030F` | `HEALTH_STATUS` | — | `0x87` | System health status register |
| `0x0400` | `PLL_CTRL` | — | `0x00` | PLL control register for receiver clock generation |
| `0x0401` | `PLL_STATUS` | — | `0x00` | PLL status flags |
| `0x0402` | `PLL_N_DIV` | — | `0x0032` | PLL N feedback divider (50 = 500MHz @ 10MHz ref) |
| `0x0403` | `PLL_R_DIV` | — | `0x01` | PLL R reference divider |
| `0x0410` | `CLK_ENABLE` | — | `0x3F` | Clock output enables for receiver subsystems |
| `0x0500` | `EEPROM_CTRL` | — | `0x00` | EEPROM control register for calibration data |
| `0x0501` | `EEPROM_ADDR` | — | `0x0000` | EEPROM byte address for read/write operations |
| `0x0502` | `EEPROM_DATA` | — | `0x0000` | EEPROM data register for read/write |
| `0x0600` | `FLASH_CTRL` | — | `0x01` | Configuration flash interface control register |
| `0x0601` | `FLASH_ADDR_LOW` | — | `0x0000` | Flash address lower 16 bits |
| `0x0602` | `FLASH_ADDR_HIGH` | — | `0x0000` | Flash address upper bits |
| `0x0603` | `FLASH_DATA` | — | `0x0000` | Flash data FIFO for read/write operations |
| `0x0604` | `FLASH_STATUS` | — | `0x01` | Flash status flags |
| `0x0800` | `GPIO_DIR` | — | `0x0000` | GPIO direction control (0=input, 1=output) |
| `0x0801` | `GPIO_DATA_OUT` | — | `0x0000` | GPIO output data register |
| `0x0802` | `GPIO_DATA_IN` | — | `0x0000` | GPIO input data register |
| `0x0803` | `GPIO_INT_EN` | — | `0x0000` | GPIO interrupt enable (per-pin) |
| `0x0A00` | `RX_CTRL` | — | `0x00` | Receiver front-end control register |
| `0x0A01` | `RX_STATUS` | — | `0x00` | Receiver status monitoring register |
| `0x0A02` | `RX_GAIN` | — | `0x0080` | Receiver gain control register |
| `0x0A03` | `RX_FREQ` | — | `0x0000` | Receiver frequency tuning word (24-bit) |

---
### `BOARD_ID` — Address `0x0000`

**Reset value:** `0x5245`  **Access:** see fields below

Receiver board identification code - ASCII 'RE'

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ID_CODE` | `[15:0]` | R | `0x5245` | Unique board identifier (read-only) |
| `RESERVED` | `[31:16]` | R | `0x0000` | Reserved for future expansion |

---
### `BOARD_VERSION` — Address `0x0001`

**Reset value:** `0x11`  **Access:** see fields below

Hardware version number - major.minor format

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAJOR` | `[7:4]` | R | `0x1` | Major version number |
| `MINOR` | `[3:0]` | R | `0x1` | Minor version number |
| `RESERVED` | `[15:8]` | R | `0x00` | Reserved |

---
### `BOARD_TYPE_ID` — Address `0x0002`

**Reset value:** `0x0003`  **Access:** see fields below

Board type identifier for firmware compatibility check

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TYPE_CODE` | `[15:0]` | R | `0x0003` | Type 3 = Receiver Main Board |
| `RESERVED` | `[31:16]` | R | `0x0000` | Reserved |

---
### `SCRATCHPAD` — Address `0x0003`

**Reset value:** `0x0000`  **Access:** see fields below

General-purpose read/write test register for RAM verification

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEST_DATA` | `[15:0]` | RW | `0x0000` | R/W test pattern for diagnostic use |
| `RESERVED` | `[31:16]` | RW | `0x0000` | Reserved |

---
### `MCS_VERSION_MAJOR` — Address `0x0010`

**Reset value:** `0x02`  **Access:** see fields below

FPGA firmware major version number

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAJOR_VER` | `[7:0]` | R | `0x02` | Firmware major version |
| `RESERVED` | `[15:8]` | R | `0x00` | Reserved |

---
### `MCS_VERSION_MINOR` — Address `0x0011`

**Reset value:** `0x05`  **Access:** see fields below

FPGA firmware minor version number

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MINOR_VER` | `[7:0]` | R | `0x05` | Firmware minor version |
| `RESERVED` | `[15:8]` | R | `0x00` | Reserved |

---
### `BUILD_DATE` — Address `0x0012`

**Reset value:** `0x20250115`  **Access:** see fields below

Firmware build date in packed BCD format (YYYYMMDD)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATE_BCD` | `[31:0]` | R | `0x20250115` | Build date: 2025-01-15 |

---
### `UART_BAUD_DIV` — Address `0x0100`

**Reset value:** `0x0068`  **Access:** see fields below

UART baud rate divisor for 115200 baud @ 100MHz reference

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DIVISOR` | `[15:0]` | RW | `0x0068` | Baud = clk_ref / (16 * divisor) |
| `RESERVED` | `[31:16]` | RW | `0x0000` | Reserved |

---
### `UART_CTRL` — Address `0x0101`

**Reset value:** `0x00`  **Access:** see fields below

UART control and configuration register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0x0` | UART enable: 1=enabled, 0=disabled |
| `LOOPBACK` | `[1]` | RW | `0x0` | Internal loopback mode for test |
| `FRAME_FORMAT` | `[7:4]` | RW | `0x3` | Frame format: 3=8N1 standard |
| `RESERVED` | `[15:8]` | RW | `0x00` | Reserved |

---
### `UART_STATUS` — Address `0x0102`

**Reset value:** `0x00`  **Access:** see fields below

UART status flags - read clears sticky bits

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TX_BUSY` | `[0]` | R | `0x0` | Transmitter busy flag |
| `RX_AVAIL` | `[1]` | R | `0x0` | Data available in RX FIFO |
| `FRAME_ERR` | `[2]` | RC | `0x0` | Frame error detected (read-clear) |
| `OVERRUN_ERR` | `[3]` | RC | `0x0` | RX FIFO overrun (read-clear) |
| `RESERVED` | `[15:4]` | R | `0x00` | Reserved |

---
### `UART_TX_COUNT` — Address `0x0103`

**Reset value:** `0x00`  **Access:** see fields below

TX FIFO byte count register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TX_COUNT` | `[7:0]` | R | `0x0` | Number of bytes in TX FIFO (0-16) |
| `RESERVED` | `[15:8]` | R | `0x00` | Reserved |

---
### `UART_RX_COUNT` — Address `0x0104`

**Reset value:** `0x00`  **Access:** see fields below

RX FIFO byte count register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `RX_COUNT` | `[7:0]` | R | `0x0` | Number of bytes in RX FIFO (0-16) |
| `RESERVED` | `[15:8]` | R | `0x00` | Reserved |

---
### `ETH_MAC_LOW` — Address `0x0110`

**Reset value:** `0x1234`  **Access:** see fields below

Ethernet MAC address lower 16 bits

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAC_LSB` | `[15:0]` | R | `0x1234` | MAC address bits [15:0] |
| `RESERVED` | `[31:16]` | R | `0x0000` | Reserved |

---
### `ETH_MAC_HIGH` — Address `0x0111`

**Reset value:** `0x5678`  **Access:** see fields below

Ethernet MAC address upper 16 bits (of 48-bit MAC)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAC_MSB` | `[31:16]` | R | `0x5678` | MAC address bits [47:32] |
| `RESERVED` | `[15:0]` | R | `0x0000` | Reserved |

---
### `ADC_CTRL` — Address `0x0200`

**Reset value:** `0x00`  **Access:** see fields below

ADC control register for supply monitoring

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `START` | `[0]` | RW | `0x0` | Start single conversion (self-clearing) |
| `CONTINUOUS` | `[1]` | RW | `0x0` | Continuous conversion mode |
| `CHANNEL_SEL` | `[3:2]` | RW | `0x0` | Channel select for manual mode |
| `AUTO_SCAN_EN` | `[4]` | RW | `0x1` | Enable auto-scan all channels |
| `RESERVED` | `[15:5]` | RW | `0x00` | Reserved |

---
### `ADC_STATUS` — Address `0x0201`

**Reset value:** `0x00`  **Access:** see fields below

ADC status flags

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA_READY` | `[0]` | R | `0x0` | New conversion data available |
| `OVERRANGE` | `[1]` | RC | `0x0` | ADC input overrange detected |
| `SCAN_COMPLETE` | `[2]` | RC | `0x0` | Auto-scan sequence complete |
| `RESERVED` | `[15:3]` | R | `0x00` | Reserved |

---
### `VCC_5V_RAW` — Address `0x0210`

**Reset value:** `0x0FFF`  **Access:** see fields below

5V supply rail raw ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | R | `0xFFF` | 12-bit ADC count; Voltage = count * 5.0/4096 |
| `RESERVED` | `[15:12]` | R | `0x0` | Reserved |

---
### `VCC_3V3_RAW` — Address `0x0211`

**Reset value:** `0x0CCC`  **Access:** see fields below

3.3V supply rail raw ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | R | `0xCCC` | 12-bit ADC count; Voltage = count * 3.3/4096 |
| `RESERVED` | `[15:12]` | R | `0x0` | Reserved |

---
### `VCC_2V5_RAW` — Address `0x0212`

**Reset value:** `0x0BFF`  **Access:** see fields below

2.5V supply rail raw ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | R | `0xBFF` | 12-bit ADC count; Voltage = count * 2.5/4096 |
| `RESERVED` | `[15:12]` | R | `0x0` | Reserved |

---
### `VCC_1V8_RAW` — Address `0x0213`

**Reset value:** `0x0898`  **Access:** see fields below

1.8V supply rail raw ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | R | `0x898` | 12-bit ADC count; Voltage = count * 1.8/4096 |
| `RESERVED` | `[15:12]` | R | `0x0` | Reserved |

---
### `ICC_5V_RAW` — Address `0x0218`

**Reset value:** `0x0000`  **Access:** see fields below

5V rail current monitor raw ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | R | `0x000` | 12-bit ADC count via current sense amp |
| `RESERVED` | `[15:12]` | R | `0x0` | Reserved |

---
### `ICC_3V3_RAW` — Address `0x0219`

**Reset value:** `0x0000`  **Access:** see fields below

3.3V rail current monitor raw ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | R | `0x000` | 12-bit ADC count via current sense amp |
| `RESERVED` | `[15:12]` | R | `0x0` | Reserved |

---
### `TEMP_LOCAL` — Address `0x0300`

**Reset value:** `0x0140`  **Access:** see fields below

FPGA die temperature in 0.25°C units (signed)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_VALUE` | `[9:0]` | R | `0x140` | Temperature = 80 * 0.25 = 20°C (signed) |
| `RESERVED` | `[15:10]` | R | `0x00` | Reserved |

---
### `TEMP_REMOTE1` — Address `0x0301`

**Reset value:** `0x0190`  **Access:** see fields below

Remote sensor 1 temperature (front panel)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_VALUE` | `[9:0]` | R | `0x190` | Temperature in 0.25°C units (signed) |
| `RESERVED` | `[15:10]` | R | `0x00` | Reserved |

---
### `TEMP_REMOTE2` — Address `0x0302`

**Reset value:** `0x0168`  **Access:** see fields below

Remote sensor 2 temperature (power supply area)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_VALUE` | `[9:0]` | R | `0x168` | Temperature in 0.25°C units (signed) |
| `RESERVED` | `[15:10]` | R | `0x00` | Reserved |

---
### `TEMP_ALERT_HIGH` — Address `0x0308`

**Reset value:** `0x0190`  **Access:** see fields below

Over-temperature alert threshold

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `THRESHOLD` | `[9:0]` | RW | `0x190` | Alert threshold: 400 * 0.25 = 100°C |
| `RESERVED` | `[15:10]` | RW | `0x00` | Reserved |

---
### `TEMP_ALERT_LOW` — Address `0x0309`

**Reset value:** `0xFF9C`  **Access:** see fields below

Under-temperature alert threshold (signed)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `THRESHOLD` | `[9:0]` | RW | `0xFF9C` | Alert threshold: -100 * 0.25 = -25°C (signed) |
| `RESERVED` | `[15:10]` | RW | `0x00` | Reserved |

---
### `HEALTH_STATUS` — Address `0x030F`

**Reset value:** `0x87`  **Access:** see fields below

System health status register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_OK` | `[0]` | R | `0x1` | Temperature within acceptable range |
| `VOLT_OK` | `[1]` | R | `0x1` | All supply voltages within tolerance |
| `PLL_LOCK` | `[2]` | R | `0x0` | PLL lock indicator |
| `FLASH_OK` | `[3]` | R | `0x1` | Flash memory accessible |
| `EEPROM_OK` | `[4]` | R | `0x1` | EEPROM accessible |
| `SYSTEM_OK` | `[7]` | R | `0x1` | Overall system healthy (all OK bits = 1) |
| `RESERVED` | `[15:8]` | R | `0x00` | Reserved |

---
### `PLL_CTRL` — Address `0x0400`

**Reset value:** `0x00`  **Access:** see fields below

PLL control register for receiver clock generation

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0x0` | PLL enable: 1=enabled, 0=power-down |
| `RESET` | `[1]` | RW | `0x1` | PLL reset (active high, self-clearing) |
| `REF_SEL` | `[3:2]` | RW | `0x0` | Reference clock select: 0=10MHz, 1=25MHz, 2=100MHz |
| `BYPASS` | `[4]` | RW | `0x0` | PLL bypass mode |
| `RESERVED` | `[15:5]` | RW | `0x00` | Reserved |

---
### `PLL_STATUS` — Address `0x0401`

**Reset value:** `0x00`  **Access:** see fields below

PLL status flags

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LOCKED` | `[0]` | R | `0x0` | PLL lock detected |
| `LOSS_OF_LOCK` | `[1]` | RC | `0x0` | Loss of lock event (read-clear) |
| `REF_VALID` | `[2]` | R | `0x0` | Reference clock present |
| `RESERVED` | `[15:3]` | R | `0x00` | Reserved |

---
### `PLL_N_DIV` — Address `0x0402`

**Reset value:** `0x0032`  **Access:** see fields below

PLL N feedback divider (50 = 500MHz @ 10MHz ref)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `N_DIV` | `[15:0]` | RW | `0x0032` | N divider value (16-bit) |
| `RESERVED` | `[31:16]` | RW | `0x0000` | Reserved |

---
### `PLL_R_DIV` — Address `0x0403`

**Reset value:** `0x01`  **Access:** see fields below

PLL R reference divider

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `R_DIV` | `[7:0]` | RW | `0x01` | R divider value (8-bit) |
| `RESERVED` | `[15:8]` | RW | `0x00` | Reserved |

---
### `CLK_ENABLE` — Address `0x0410`

**Reset value:** `0x3F`  **Access:** see fields below

Clock output enables for receiver subsystems

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `CLK_ADC_EN` | `[0]` | RW | `0x1` | ADC sampling clock enable |
| `CLK_DSP_EN` | `[1]` | RW | `0x1` | DSP processing clock enable |
| `CLK_IF_EN` | `[2]` | RW | `0x1` | Intermediate frequency clock enable |
| `CLK_RF_EN` | `[3]` | RW | `0x1` | RF front-end clock enable |
| `CLK_AUX_EN` | `[4]` | RW | `0x0` | Auxiliary clock output enable |
| `CLK_REF_OUT_EN` | `[5]` | RW | `0x0` | Reference clock output enable |
| `RESERVED` | `[15:6]` | RW | `0x00` | Reserved |

---
### `EEPROM_CTRL` — Address `0x0500`

**Reset value:** `0x00`  **Access:** see fields below

EEPROM control register for calibration data

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READ` | `[0]` | RW | `0x0` | Initiate read operation (self-clearing) |
| `WRITE` | `[1]` | RW | `0x0` | Initiate write operation (self-clearing) |
| `ERASE` | `[2]` | RW | `0x0` | Erase page (requires unlock) |
| `UNLOCK` | `[3]` | RW | `0x0` | Write unlock: must set 0xA before write/erase |
| `BUSY` | `[7]` | R | `0x0` | EEPROM operation in progress |
| `RESERVED` | `[15:8]` | RW | `0x00` | Reserved |

---
### `EEPROM_ADDR` — Address `0x0501`

**Reset value:** `0x0000`  **Access:** see fields below

EEPROM byte address for read/write operations

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BYTE_ADDR` | `[15:0]` | RW | `0x0000` | 16-bit byte address into EEPROM |
| `RESERVED` | `[31:16]` | RW | `0x0000` | Reserved |

---
### `EEPROM_DATA` — Address `0x0502`

**Reset value:** `0x0000`  **Access:** see fields below

EEPROM data register for read/write

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA` | `[15:0]` | RW | `0x0000` | 16-bit data (two 8-bit bytes) |
| `RESERVED` | `[31:16]` | RW | `0x0000` | Reserved |

---
### `FLASH_CTRL` — Address `0x0600`

**Reset value:** `0x01`  **Access:** see fields below

Configuration flash interface control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READ` | `[0]` | RW | `0x1` | Flash read enable (default on) |
| `WRITE` | `[1]` | RW | `0x0` | Flash write/program enable |
| `ERASE_SECTOR` | `[2]` | RW | `0x0` | Sector erase operation |
| `ERASE_CHIP` | `[3]` | RW | `0x0` | Chip erase operation (requires unlock) |
| `UNLOCK` | `[4]` | W | `0x0` | Write unlock: must write 0x5A before write/erase |
| `BUSY` | `[7]` | R | `0x0` | Flash operation busy flag |
| `RESERVED` | `[15:8]` | RW | `0x00` | Reserved |

---
### `FLASH_ADDR_LOW` — Address `0x0601`

**Reset value:** `0x0000`  **Access:** see fields below

Flash address lower 16 bits

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADDR_LOW` | `[15:0]` | RW | `0x0000` | Address bits [15:0] |
| `RESERVED` | `[31:16]` | RW | `0x0000` | Reserved |

---
### `FLASH_ADDR_HIGH` — Address `0x0602`

**Reset value:** `0x0000`  **Access:** see fields below

Flash address upper bits

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADDR_HIGH` | `[7:0]` | RW | `0x00` | Address bits [23:16] |
| `RESERVED` | `[15:8]` | RW | `0x00` | Reserved |

---
### `FLASH_DATA` — Address `0x0603`

**Reset value:** `0x0000`  **Access:** see fields below

Flash data FIFO for read/write operations

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA_FIFO` | `[15:0]` | RW | `0x0000` | Data word for write/read operations |
| `RESERVED` | `[31:16]` | RW | `0x0000` | Reserved |

---
### `FLASH_STATUS` — Address `0x0604`

**Reset value:** `0x01`  **Access:** see fields below

Flash status flags

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READY` | `[0]` | R | `0x1` | Flash ready for operations |
| `WRITE_ERR` | `[1]` | RC | `0x0` | Write/program error flag (read-clear) |
| `ERASE_ERR` | `[2]` | RC | `0x0` | Erase error flag (read-clear) |
| `PROTECT_ERR` | `[3]` | RC | `0x0` | Protection violation error |
| `RESERVED` | `[15:4]` | R | `0x00` | Reserved |

---
### `GPIO_DIR` — Address `0x0800`

**Reset value:** `0x0000`  **Access:** see fields below

GPIO direction control (0=input, 1=output)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GPIO_DIR` | `[15:0]` | RW | `0x0000` | Direction for GPIO[15:0] |
| `RESERVED` | `[31:16]` | RW | `0x0000` | Reserved |

---
### `GPIO_DATA_OUT` — Address `0x0801`

**Reset value:** `0x0000`  **Access:** see fields below

GPIO output data register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GPIO_OUT` | `[15:0]` | RW | `0x0000` | Output data for GPIO[15:0] |
| `RESERVED` | `[31:16]` | RW | `0x0000` | Reserved |

---
### `GPIO_DATA_IN` — Address `0x0802`

**Reset value:** `0x0000`  **Access:** see fields below

GPIO input data register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GPIO_IN` | `[15:0]` | R | `0x0000` | Input data from GPIO[15:0] |
| `RESERVED` | `[31:16]` | R | `0x0000` | Reserved |

---
### `GPIO_INT_EN` — Address `0x0803`

**Reset value:** `0x0000`  **Access:** see fields below

GPIO interrupt enable (per-pin)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `INT_EN` | `[15:0]` | RW | `0x0000` | Interrupt enable for each GPIO pin |
| `RESERVED` | `[31:16]` | RW | `0x0000` | Reserved |

---
### `RX_CTRL` — Address `0x0A00`

**Reset value:** `0x00`  **Access:** see fields below

Receiver front-end control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `RX_ENABLE` | `[0]` | RW | `0x0` | Main receiver enable |
| `LNA_ENABLE` | `[1]` | RW | `0x0` | LNA power enable |
| `MIXER_ENABLE` | `[2]` | RW | `0x0` | Mixer enable |
| `GAIN_MODE` | `[4:3]` | RW | `0x0` | Gain mode: 0=low, 1=medium, 2=high, 3=auto |
| `FILTER_BW` | `[6:5]` | RW | `0x1` | IF filter bandwidth select |
| `RESERVED` | `[15:7]` | RW | `0x00` | Reserved |

---
### `RX_STATUS` — Address `0x0A01`

**Reset value:** `0x00`  **Access:** see fields below

Receiver status monitoring register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `SIGNAL_DETECT` | `[0]` | R | `0x0` | RF signal detected above threshold |
| `AGC_LOCKED` | `[1]` | R | `0x0` | AGC settled and locked |
| `OVERLOAD` | `[2]` | RC | `0x0` | ADC overload detected (read-clear) |
| `FREQ_LOCKED` | `[3]` | R | `0x0` | Frequency synthesizer locked |
| `RESERVED` | `[15:4]` | R | `0x00` | Reserved |

---
### `RX_GAIN` — Address `0x0A02`

**Reset value:** `0x0080`  **Access:** see fields below

Receiver gain control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `RF_GAIN` | `[7:0]` | RW | `0x80` | RF front-end gain (0-255, 128=mid-scale) |
| `IF_GAIN` | `[15:8]` | RW | `0x80` | IF gain (0-255, 128=mid-scale) |
| `RESERVED` | `[31:16]` | RW | `0x0000` | Reserved |

---
### `RX_FREQ` — Address `0x0A03`

**Reset value:** `0x0000`  **Access:** see fields below

Receiver frequency tuning word (24-bit)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `FREQ_TUNE` | `[23:0]` | RW | `0x000000` | Frequency tuning word for NCO/synthesizer |
| `RESERVED` | `[31:24]` | RW | `0x00` | Reserved |
