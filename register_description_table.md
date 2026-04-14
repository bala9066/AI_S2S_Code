# Register Description Table (RDT)
## rx module

> **Total registers:** 51

RX Module (rx_module) Register Map - STM32L433CBT6 Glue Logic for RF Receiver Chain with HMC1119 DSA, HMC384 Amplifier, AD8318 Power Detector, and TMP102 Temperature Sensor. UART-based register interface with SPI control to RF attenuator, I2C temperature monitoring, ADC power detection readback, and GPIO control for PA Enable and VGG bias.

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
| `0x0000` | `BOARD_ID` | — | `0x5258` | RX Module board identification - ASCII 'RX' |
| `0x0001` | `BOARD_VERSION` | — | `0x10` | Hardware version number |
| `0x0002` | `BOARD_TYPE_ID` | — | `0x0001` | Board type identifier |
| `0x0003` | `SCRATCHPAD` | — | `0x0000` | Read/write test register for memory and communication verification |
| `0x0010` | `MCS_VERSION_MAJOR` | — | `0x01` | Firmware major version number |
| `0x0011` | `MCS_VERSION_MINOR` | — | `0x00` | Firmware minor version number |
| `0x0012` | `BUILD_DATE` | — | `0x20260414` | Firmware build date in packed BCD format (YYYYMMDD) |
| `0x0100` | `UART_BAUD_DIV` | — | `0x0006` | UART baud rate divisor for 80MHz system clock (default 3.0Mbps) |
| `0x0101` | `UART_CTRL` | — | `0x03` | UART control and configuration register |
| `0x0102` | `UART_STATUS` | — | `0x00` | UART status flags (read-clear) |
| `0x0103` | `UART_TX_COUNT` | — | `0x00` | TX FIFO byte count |
| `0x0104` | `UART_RX_COUNT` | — | `0x00` | RX FIFO byte count |
| `0x0110` | `ETH_MAC_LOW` | — | `0x0000` | System interface MAC address lower 16 bits (reserved for future Ethernet) |
| `0x0111` | `ETH_MAC_HIGH` | — | `0x0000` | System interface MAC address upper 16 bits |
| `0x0200` | `ADC_CTRL` | — | `0x01` | ADC control for RF power detector monitoring |
| `0x0201` | `ADC_STATUS` | — | `0x00` | ADC status flags |
| `0x0210` | `RF_POWER_RAW` | — | `0x0000` | RF power detector ADC count (AD8318 VDET output) |
| `0x0211` | `VCC_5V_RAW` | — | `0x0CCC` | 5V rail voltage ADC count |
| `0x0212` | `VCC_3V3_RAW` | — | `0x0800` | 3.3V rail voltage ADC count |
| `0x0213` | `VGG_MONITOR` | — | `0x0000` | VGG bias voltage monitor ADC count |
| `0x0218` | `ICC_5V_RAW` | — | `0x0000` | 5V rail current ADC count (if current sense present) |
| `0x0219` | `ICC_3V3_RAW` | — | `0x0000` | 3.3V rail current ADC count |
| `0x0300` | `TEMP_LOCAL` | — | `0x01F4` | Local MCU internal temperature sensor |
| `0x0301` | `TEMP_REMOTE1` | — | `0x00C8` | Remote temperature sensor (TMP102 board temp) |
| `0x0302` | `TEMP_REMOTE2` | — | `0x0000` | Reserved for second remote temperature sensor |
| `0x0308` | `TEMP_ALERT_HIGH` | — | `0x0190` | Over-temperature alert threshold (100°C = 400 * 0.25°C) |
| `0x0309` | `TEMP_ALERT_LOW` | — | `0xFF9C` | Under-temperature alert threshold (-25°C) |
| `0x030F` | `HEALTH_STATUS` | — | `0x07` | System health summary status |
| `0x0400` | `PLL_CTRL` | — | `0x01` | PLL/MCU clock control (internal RC oscillator) |
| `0x0401` | `PLL_STATUS` | — | `0x01` | PLL status flags |
| `0x0402` | `PLL_N_DIV` | — | `0x000A` | PLL N divider (16MHz * 10 / 2 = 80MHz system clock) |
| `0x0403` | `PLL_R_DIV` | — | `0x0002` | PLL R divider |
| `0x0410` | `CLK_ENABLE` | — | `0x1F` | Clock output enables for peripheral blocks |
| `0x0500` | `EEPROM_CTRL` | — | `0x00` | EEPROM emulation in internal flash control |
| `0x0501` | `EEPROM_ADDR` | — | `0x0000` | EEPROM byte address |
| `0x0502` | `EEPROM_DATA` | — | `0x0000` | EEPROM read/write data |
| `0x0600` | `FLASH_CTRL` | — | `0x00` | Internal flash control for calibration storage |
| `0x0601` | `FLASH_ADDR_LOW` | — | `0x0000` | Flash address low word |
| `0x0602` | `FLASH_ADDR_HIGH` | — | `0x0000` | Flash address high byte |
| `0x0603` | `FLASH_DATA` | — | `0x0000` | Flash read/write data FIFO |
| `0x0604` | `FLASH_STATUS` | — | `0x01` | Flash status flags |
| `0x0700` | `RF_DSA_CTRL` | — | `0x3F` | RF Digital Step Attenuator control (HMC1119 7-bit) |
| `0x0701` | `RF_DSA_STATUS` | — | `0x00` | RF DSA status register |
| `0x0702` | `RF_GAIN_TARGET` | — | `0x0000` | Target RF gain setting (for automatic gain control) |
| `0x0703` | `RF_GAIN_ACTUAL` | — | `0x0000` | Actual RF gain based on DSA and measured values |
| `0x0800` | `GPIO_CTRL` | — | `0x00` | GPIO control outputs |
| `0x0801` | `GPIO_INPUT` | — | `0x0F` | GPIO input status |
| `0x0900` | `VGG_DAC_CTRL` | — | `0x0000` | VGG bias DAC control (internal MCU DAC) |
| `0x0901` | `VGG_DAC_STATUS` | — | `0x00` | VGG DAC status |
| `0x0902` | `PROTECTION_CTRL` | — | `0x0F` | Protection circuit control and configuration |
| `0x0903` | `PROTECTION_STATUS` | — | `0x00` | Protection status flags |

---
### `BOARD_ID` — Address `0x0000`

**Reset value:** `0x5258`  **Access:** see fields below

RX Module board identification - ASCII 'RX'

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BOARD_ID` | `[15:0]` | RO | `0x5258` | Board identifier - 'RX' (0x5258) for receiver module |

---
### `BOARD_VERSION` — Address `0x0001`

**Reset value:** `0x10`  **Access:** see fields below

Hardware version number

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAJOR_VERSION` | `[7:4]` | RO | `0x1` | Major version - board revision level |
| `MINOR_VERSION` | `[3:0]` | RO | `0x0` | Minor version - PCB spin |

---
### `BOARD_TYPE_ID` — Address `0x0002`

**Reset value:** `0x0001`  **Access:** see fields below

Board type identifier

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TYPE_ID` | `[15:0]` | RO | `0x0001` | RX Module Type ID = 0x0001 |

---
### `SCRATCHPAD` — Address `0x0003`

**Reset value:** `0x0000`  **Access:** see fields below

Read/write test register for memory and communication verification

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEST_PATTERN` | `[15:0]` | RW | `0x0000` | General-purpose test register - any value can be written and read back |

---
### `MCS_VERSION_MAJOR` — Address `0x0010`

**Reset value:** `0x01`  **Access:** see fields below

Firmware major version number

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `FIRMWARE_MAJOR` | `[7:0]` | RO | `0x01` | Major version of MCU firmware |

---
### `MCS_VERSION_MINOR` — Address `0x0011`

**Reset value:** `0x00`  **Access:** see fields below

Firmware minor version number

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `FIRMWARE_MINOR` | `[7:0]` | RO | `0x00` | Minor version of MCU firmware |

---
### `BUILD_DATE` — Address `0x0012`

**Reset value:** `0x20260414`  **Access:** see fields below

Firmware build date in packed BCD format (YYYYMMDD)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `YEAR` | `[15:12]` | RO | `0x2` | Build year (decades) |
| `MONTH` | `[11:8]` | RO | `0x6` | Build month (04 = April) |
| `DAY` | `[7:0]` | RO | `0x14` | Build day (14 = 14th) |

---
### `UART_BAUD_DIV` — Address `0x0100`

**Reset value:** `0x0006`  **Access:** see fields below

UART baud rate divisor for 80MHz system clock (default 3.0Mbps)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BAUD_DIV` | `[15:0]` | RW | `0x0006` | Baud divisor = f_SYS / (16 * baud_rate); 0x0006 = 3.0Mbps at 80MHz |

---
### `UART_CTRL` — Address `0x0101`

**Reset value:** `0x03`  **Access:** see fields below

UART control and configuration register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `UART_ENABLE` | `[0]` | RW | `1` | 1 = Enable UART, 0 = Disable |
| `LOOPBACK` | `[1]` | RW | `1` | 1 = Loopback mode (test), 0 = Normal |
| `FRAME_FORMAT` | `[7:4]` | RW | `0x0` | Frame format (0=8N1 standard) |

---
### `UART_STATUS` — Address `0x0102`

**Reset value:** `0x00`  **Access:** see fields below

UART status flags (read-clear)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TX_BUSY` | `[0]` | RC | `0` | Transmitter busy flag |
| `RX_AVAIL` | `[1]` | RC | `0` | Data available in RX FIFO |
| `FRAME_ERR` | `[2]` | RC | `0` | Frame error detected |
| `OVERRUN_ERR` | `[3]` | RC | `0` | RX overrun error |

---
### `UART_TX_COUNT` — Address `0x0103`

**Reset value:** `0x00`  **Access:** see fields below

TX FIFO byte count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TX_COUNT` | `[7:0]` | RO | `0` | Number of bytes in TX FIFO |

---
### `UART_RX_COUNT` — Address `0x0104`

**Reset value:** `0x00`  **Access:** see fields below

RX FIFO byte count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `RX_COUNT` | `[7:0]` | RO | `0` | Number of bytes in RX FIFO |

---
### `ETH_MAC_LOW` — Address `0x0110`

**Reset value:** `0x0000`  **Access:** see fields below

System interface MAC address lower 16 bits (reserved for future Ethernet)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAC_LOW` | `[15:0]` | RO | `0x0000` | MAC address [15:0] - reserved |

---
### `ETH_MAC_HIGH` — Address `0x0111`

**Reset value:** `0x0000`  **Access:** see fields below

System interface MAC address upper 16 bits

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAC_HIGH` | `[15:0]` | RO | `0x0000` | MAC address [31:16] - reserved |

---
### `ADC_CTRL` — Address `0x0200`

**Reset value:** `0x01`  **Access:** see fields below

ADC control for RF power detector monitoring

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_START` | `[0]` | RW | `1` | Start ADC conversion |
| `ADC_CONTINUOUS` | `[1]` | RW | `0` | Continuous conversion mode |
| `ADC_CHANNEL` | `[3:2]` | RW | `0x0` | Channel select: 0=VDET, 1=VGG_MON, 2=VIN_MON |

---
### `ADC_STATUS` — Address `0x0201`

**Reset value:** `0x00`  **Access:** see fields below

ADC status flags

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA_READY` | `[0]` | RC | `0` | New ADC data available (read-clear) |
| `OVERRANGE` | `[1]` | RC | `0` | ADC input exceeds full scale (OVP trigger) |

---
### `RF_POWER_RAW` — Address `0x0210`

**Reset value:** `0x0000`  **Access:** see fields below

RF power detector ADC count (AD8318 VDET output)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `POWER_ADC` | `[11:0]` | RO | `0` | 12-bit ADC count from AD8318 VDET output (approx 2.5V range) |
| `RESERVED` | `[15:12]` | RO | `0` | Reserved - read as 0 |

---
### `VCC_5V_RAW` — Address `0x0211`

**Reset value:** `0x0CCC`  **Access:** see fields below

5V rail voltage ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `V5V_ADC` | `[11:0]` | RO | `0x0CCC` | 5V rail ADC count (expected ~3277 for 5.0V at 2.5V ref with divider) |
| `RESERVED` | `[15:12]` | RO | `0` | Reserved |

---
### `VCC_3V3_RAW` — Address `0x0212`

**Reset value:** `0x0800`  **Access:** see fields below

3.3V rail voltage ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `V3V3_ADC` | `[11:0]` | RO | `0x0800` | 3.3V rail ADC count (expected ~2048 for 3.3V) |
| `RESERVED` | `[15:12]` | RO | `0` | Reserved |

---
### `VGG_MONITOR` — Address `0x0213`

**Reset value:** `0x0000`  **Access:** see fields below

VGG bias voltage monitor ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `VGG_ADC` | `[11:0]` | RO | `0` | VGG bias voltage ADC count (negative rail via level shifter) |
| `RESERVED` | `[15:12]` | RO | `0` | Reserved |

---
### `ICC_5V_RAW` — Address `0x0218`

**Reset value:** `0x0000`  **Access:** see fields below

5V rail current ADC count (if current sense present)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `I5V_ADC` | `[11:0]` | RO | `0` | 5V rail current via sense amplifier |
| `RESERVED` | `[15:12]` | RO | `0` | Reserved |

---
### `ICC_3V3_RAW` — Address `0x0219`

**Reset value:** `0x0000`  **Access:** see fields below

3.3V rail current ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `I3V3_ADC` | `[11:0]` | RO | `0` | 3.3V rail current via sense resistor |
| `RESERVED` | `[15:12]` | RO | `0` | Reserved |

---
### `TEMP_LOCAL` — Address `0x0300`

**Reset value:** `0x01F4`  **Access:** see fields below

Local MCU internal temperature sensor

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MCU_TEMP` | `[9:0]` | RO | `0x01F4` | MCU die temperature in 0.25°C units (default 500 = 125°C for init) |
| `SIGN_BIT` | `[9]` | RO | `0` | Sign bit for temperature |

---
### `TEMP_REMOTE1` — Address `0x0301`

**Reset value:** `0x00C8`  **Access:** see fields below

Remote temperature sensor (TMP102 board temp)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BOARD_TEMP` | `[9:0]` | RO | `0x00C8` | TMP102 board temperature in 0.0625°C units (default 200 = 50°C for init) |
| `RESERVED` | `[15:10]` | RO | `0` | Reserved |

---
### `TEMP_REMOTE2` — Address `0x0302`

**Reset value:** `0x0000`  **Access:** see fields below

Reserved for second remote temperature sensor

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `REMOTE2_TEMP` | `[9:0]` | RO | `0` | Reserved for future temp sensor |
| `RESERVED` | `[15:10]` | RO | `0` | Reserved |

---
### `TEMP_ALERT_HIGH` — Address `0x0308`

**Reset value:** `0x0190`  **Access:** see fields below

Over-temperature alert threshold (100°C = 400 * 0.25°C)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `OT_THRESH` | `[9:0]` | RW | `0x0190` | High temp threshold in 0.25°C units (default 100°C) |
| `RESERVED` | `[15:10]` | RW | `0` | Reserved |

---
### `TEMP_ALERT_LOW` — Address `0x0309`

**Reset value:** `0xFF9C`  **Access:** see fields below

Under-temperature alert threshold (-25°C)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `UT_THRESH` | `[9:0]` | RW | `0xFF9C` | Low temp threshold in 0.25°C units (default -25°C) |
| `RESERVED` | `[15:10]` | RW | `0` | Reserved |

---
### `HEALTH_STATUS` — Address `0x030F`

**Reset value:** `0x07`  **Access:** see fields below

System health summary status

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_OK` | `[0]` | RO | `1` | Temperature within limits (1=OK) |
| `VOLT_OK` | `[1]` | RO | `1` | Supply voltages within limits (1=OK) |
| `PLL_LOCK` | `[2]` | RO | `1` | MCU clock stable (1=OK) |
| `PA_FAULT` | `[3]` | RO | `0` | PA fault detected (0=OK, 1=FAULT) |
| `RF_OK` | `[4]` | RO | `1` | RF chain status OK |
| `SYSTEM_OK` | `[7]` | RO | `1` | Overall system OK (all faults clear) |
| `RESERVED` | `[15:8]` | RO | `0` | Reserved |

---
### `PLL_CTRL` — Address `0x0400`

**Reset value:** `0x01`  **Access:** see fields below

PLL/MCU clock control (internal RC oscillator)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `PLL_ENABLE` | `[0]` | RW | `1` | Enable MCU PLL (16MHz HSI to 80MHz) |
| `PLL_RESET` | `[1]` | RW | `0` | Reset PLL (self-clearing) |
| `REF_SEL` | `[3:2]` | RW | `0x0` | Clock source: 0=HSI, 1=HSE (optional) |
| `RESERVED` | `[15:4]` | RW | `0` | Reserved |

---
### `PLL_STATUS` — Address `0x0401`

**Reset value:** `0x01`  **Access:** see fields below

PLL status flags

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LOCKED` | `[0]` | RO | `1` | PLL locked (stable clock) |
| `LOSS_OF_LOCK` | `[1]` | RC | `0` | PLL loss of lock detected |
| `RESERVED` | `[15:2]` | RO | `0` | Reserved |

---
### `PLL_N_DIV` — Address `0x0402`

**Reset value:** `0x000A`  **Access:** see fields below

PLL N divider (16MHz * 10 / 2 = 80MHz system clock)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `N_DIVISOR` | `[15:0]` | RW | `0x000A` | PLL multiplier N (default 10 for 80MHz) |

---
### `PLL_R_DIV` — Address `0x0403`

**Reset value:** `0x0002`  **Access:** see fields below

PLL R divider

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `R_DIVISOR` | `[7:0]` | RW | `0x02` | PLL input divider R (default 2) |
| `RESERVED` | `[15:8]` | RW | `0` | Reserved |

---
### `CLK_ENABLE` — Address `0x0410`

**Reset value:** `0x1F`  **Access:** see fields below

Clock output enables for peripheral blocks

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `CLK_SPI` | `[0]` | RW | `1` | Enable SPI clock for DSA |
| `CLK_I2C` | `[1]` | RW | `1` | Enable I2C clock for temp sensor |
| `CLK_ADC` | `[2]` | RW | `1` | Enable ADC clock |
| `CLK_UART` | `[3]` | RW | `1` | Enable UART clock |
| `CLK_TIMER` | `[4]` | RW | `1` | Enable timer clock for monitoring |
| `RESERVED` | `[15:5]` | RW | `0` | Reserved |

---
### `EEPROM_CTRL` — Address `0x0500`

**Reset value:** `0x00`  **Access:** see fields below

EEPROM emulation in internal flash control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `EEPROM_READ` | `[0]` | RW | `0` | Trigger EEPROM read |
| `EEPROM_WRITE` | `[1]` | RW | `0` | Trigger EEPROM write |
| `EEPROM_ERASE` | `[2]` | RW | `0` | Trigger EEPROM erase |
| `EEPROM_BUSY` | `[7]` | RO | `0` | EEPROM operation in progress |
| `RESERVED` | `[15:8]` | RW | `0` | Reserved |

---
### `EEPROM_ADDR` — Address `0x0501`

**Reset value:** `0x0000`  **Access:** see fields below

EEPROM byte address

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `EEP_ADDR` | `[15:0]` | RW | `0x0000` | 16-bit EEPROM address |

---
### `EEPROM_DATA` — Address `0x0502`

**Reset value:** `0x0000`  **Access:** see fields below

EEPROM read/write data

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `EEP_DATA` | `[15:0]` | RW | `0x0000` | 16-bit EEPROM data |

---
### `FLASH_CTRL` — Address `0x0600`

**Reset value:** `0x00`  **Access:** see fields below

Internal flash control for calibration storage

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `FLASH_READ` | `[0]` | RW | `0` | Trigger flash read |
| `FLASH_WRITE` | `[1]` | RW | `0` | Trigger flash write |
| `FLASH_ERASE_SECTOR` | `[2]` | RW | `0` | Erase flash sector |
| `FLASH_ERASE_CHIP` | `[3]` | RW | `0` | Erase entire flash chip (restricted) |
| `FLASH_BUSY` | `[7]` | RO | `0` | Flash operation in progress |
| `RESERVED` | `[15:8]` | RW | `0` | Reserved |

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

Flash address high byte

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADDR_HIGH` | `[7:0]` | RW | `0x00` | Flash address [23:16] |
| `RESERVED` | `[15:8]` | RW | `0` | Reserved |

---
### `FLASH_DATA` — Address `0x0603`

**Reset value:** `0x0000`  **Access:** see fields below

Flash read/write data FIFO

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `FLASH_D` | `[15:0]` | RW | `0x0000` | Flash data word |

---
### `FLASH_STATUS` — Address `0x0604`

**Reset value:** `0x01`  **Access:** see fields below

Flash status flags

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `FLASH_READY` | `[0]` | RO | `1` | Flash ready for operations |
| `WRITE_ERR` | `[1]` | RC | `0` | Flash write error |
| `ERASE_ERR` | `[2]` | RC | `0` | Flash erase error |
| `RESERVED` | `[15:3]` | RO | `0` | Reserved |

---
### `RF_DSA_CTRL` — Address `0x0700`

**Reset value:** `0x3F`  **Access:** see fields below

RF Digital Step Attenuator control (HMC1119 7-bit)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DSA_ATTEN` | `[6:0]` | RW | `0x3F` | Attenuation value 0-127 (0.25dB LSB, 0-31.75dB range) |
| `DSA_LOAD` | `[7]` | RW | `0` | 1 = Load attenuation to DSA via SPI |
| `RESERVED` | `[15:8]` | RW | `0` | Reserved |

---
### `RF_DSA_STATUS` — Address `0x0701`

**Reset value:** `0x00`  **Access:** see fields below

RF DSA status register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DSA_LOADED` | `[0]` | RO | `0` | Attenuation value loaded to hardware |
| `DSA_SPI_BUSY` | `[1]` | RO | `0` | SPI transaction to DSA in progress |
| `RESERVED` | `[15:2]` | RO | `0` | Reserved |

---
### `RF_GAIN_TARGET` — Address `0x0702`

**Reset value:** `0x0000`  **Access:** see fields below

Target RF gain setting (for automatic gain control)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TARGET_GAIN` | `[15:0]` | RW | `0x0000` | Target gain in 0.01dB units (signed) |

---
### `RF_GAIN_ACTUAL` — Address `0x0703`

**Reset value:** `0x0000`  **Access:** see fields below

Actual RF gain based on DSA and measured values

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ACTUAL_GAIN` | `[15:0]` | RO | `0x0000` | Actual gain in 0.01dB units (signed) |

---
### `GPIO_CTRL` — Address `0x0800`

**Reset value:** `0x00`  **Access:** see fields below

GPIO control outputs

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `PA_ENABLE` | `[0]` | RW | `0` | PA Enable output to HMC384 amplifier (0=OFF, 1=ON) |
| `VGG_ENABLE` | `[1]` | RW | `0` | VGG bias enable for PA gate |
| `STAT_LED` | `[2]` | RW | `0` | Status LED control (0=OFF, 1=ON) |
| `RF_RELAY` | `[3]` | RW | `0` | RF relay control (if present) |
| `RESERVED` | `[15:4]` | RW | `0` | Reserved |

---
### `GPIO_INPUT` — Address `0x0801`

**Reset value:** `0x0F`  **Access:** see fields below

GPIO input status

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_ALERT_PIN` | `[0]` | RO | `1` | TMP102 ALERT pin input (0=ALERT active) |
| `OVP_TRIG_PIN` | `[1]` | RO | `1` | AD8318 OVP trigger input (0=TRIGGERED) |
| `EXT_RESET_PIN` | `[2]` | RO | `1` | External reset input (active low) |
| `RESERVED` | `[15:3]` | RO | `0` | Reserved |

---
### `VGG_DAC_CTRL` — Address `0x0900`

**Reset value:** `0x0000`  **Access:** see fields below

VGG bias DAC control (internal MCU DAC)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `VGG_DAC` | `[11:0]` | RW | `0` | 12-bit DAC value for VGG bias output (0-2.5V range) |
| `VGG_ENABLE_DAC` | `[15]` | RW | `0` | Enable VGG DAC output |

---
### `VGG_DAC_STATUS` — Address `0x0901`

**Reset value:** `0x00`  **Access:** see fields below

VGG DAC status

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `VGG_READY` | `[0]` | RO | `0` | VGG DAC output ready |
| `VGG_RANGE` | `[1]` | RO | `0` | VGG output in range |
| `RESERVED` | `[15:2]` | RO | `0` | Reserved |

---
### `PROTECTION_CTRL` — Address `0x0902`

**Reset value:** `0x0F`  **Access:** see fields below

Protection circuit control and configuration

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `OTP_ENABLE` | `[0]` | RW | `1` | Enable over-temperature protection |
| `OVP_ENABLE` | `[1]` | RW | `1` | Enable overpower protection |
| `AUTO_SHUTDOWN` | `[2]` | RW | `1` | Automatic shutdown on fault |
| `FAULT_LATCH` | `[3]` | RW | `1` | Latch faults until cleared |
| `RESERVED` | `[15:4]` | RW | `0` | Reserved |

---
### `PROTECTION_STATUS` — Address `0x0903`

**Reset value:** `0x00`  **Access:** see fields below

Protection status flags

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `OTP_TRIPPED` | `[0]` | RC | `0` | Over-temperature protection tripped |
| `OVP_TRIPPED` | `[1]` | RC | `0` | Overpower protection tripped |
| `VGG_FAULT` | `[2]` | RC | `0` | VGG bias fault detected |
| `PA_FAULT_FLAG` | `[3]` | RC | `0` | PA fault detected |
| `RESERVED` | `[15:4]` | RO | `0` | Reserved |
