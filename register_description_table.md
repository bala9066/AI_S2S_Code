# Register Description Table (RDT)
## khv

> **Total registers:** 53

Complete register map and initialization sequence for KHV Wideband RF Receiver (5-18 GHz) project. Includes 40+ registers across 10 functional groups covering board identification, UART communication, system ADC monitoring, temperature sensing, PLL/clock synthesis, RF front-end (HMC698LP4ETR LNA/VGA) control, high-speed ADC (EV12AQ600) JESD204B interface management, LMK04828 clock synthesizer SPI control, EEPROM/Flash interfaces, and GPIO. Programming sequence provides 21-step power-up initialization with dependency ordering: RAM sanity check → power rail verification → PLL lock → peripheral enable → RF front-end power-up → ADC calibration and link establishment → final system health verification.

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
| `0x0000` | `BOARD_ID` | — | `0x4B48 0x56` | Board identification code - ASCII 'KHV' signature [15:8]='K', [7:0]='H' |
| `0x0001` | `BOARD_VERSION` | — | `0x01` | Hardware version number - [7:4]=major, [3:0]=minor |
| `0x0002` | `BOARD_TYPE_ID` | — | `0x0001` | Board type identifier - 0x0001 = KHV Wideband RF Receiver |
| `0x0003` | `SCRATCHPAD` | — | `0x0000` | Read/write test register for RAM sanity check |
| `0x0010` | `MCS_VERSION_MAJOR` | — | `0x01` | FPGA firmware major version number |
| `0x0011` | `MCS_VERSION_MINOR` | — | `0x00` | FPGA firmware minor version number |
| `0x0012` | `BUILD_DATE` | — | `0x20260416` | Firmware build date in packed BCD (YYYYMMDD) |
| `0x0100` | `UART_BAUD_DIV` | — | `0x0022` | UART baud rate divisor for 100MHz reference (0x0022 = 115200 baud) |
| `0x0101` | `UART_CTRL` | — | `0x00` | UART control register |
| `0x0102` | `UART_STATUS` | — | `0x00` | UART status flags |
| `0x0103` | `UART_TX_COUNT` | — | `0x00` | TX FIFO fill level |
| `0x0104` | `UART_RX_COUNT` | — | `0x00` | RX FIFO fill level |
| `0x0110` | `ETH_MAC_LOW` | — | `0x0000` | Ethernet MAC address lower 16 bits |
| `0x0111` | `ETH_MAC_HIGH` | — | `0x0000` | Ethernet MAC address upper 16 bits |
| `0x0700` | `RF_FRONT_CTRL` | — | `0x00` | RF Front-End (LNA/VGA) control register for HMC698LP4ETR |
| `0x0701` | `RF_FRONT_STATUS` | — | `0x00` | RF Front-End status monitoring |
| `0x0702` | `ADC_JESD_CTRL` | — | `0x00` | EV12AQ600 ADC JESD204B interface control |
| `0x0703` | `ADC_JESD_STATUS` | — | `0x00` | ADC JESD204B link status monitoring |
| `0x0704` | `SAMPLE_COUNT_LOW` | — | `0x0000` | ADC sample counter lower 16 bits |
| `0x0705` | `SAMPLE_COUNT_HIGH` | — | `0x0000` | ADC sample counter upper 16 bits |
| `0x0706` | `SPI_CLKGEN_CTRL` | — | `0x00` | SPI master control for LMK04828 clock synthesizer |
| `0x0707` | `SPI_CLKGEN_STATUS` | — | `0x00` | Clock synthesizer status monitoring |
| `0x0708` | `ADC_DATA_CAPTURE_CTRL` | — | `0x00` | ADC data capture and buffering control |
| `0x0709` | `ADC_DATA_CAPTURE_STATUS` | — | `0x00` | ADC data capture status |
| `0x0200` | `ADC_CTRL` | — | `0x00` | System ADC control for monitoring |
| `0x0201` | `ADC_STATUS` | — | `0x00` | System ADC status |
| `0x0210` | `VCC_5V_RAW` | — | `0x0000` | 5V rail raw ADC count (multiply by 5.0/4096) |
| `0x0211` | `VCC_3V3_RAW` | — | `0x0000` | 3.3V rail raw ADC count |
| `0x0212` | `VCC_2V5_RAW` | — | `0x0000` | 2.5V rail raw ADC count |
| `0x0213` | `VCC_1V8_RAW` | — | `0x0000` | 1.8V rail raw ADC count |
| `0x0218` | `ICC_5V_RAW` | — | `0x0000` | 5V rail current sense ADC count |
| `0x0219` | `ICC_3V3_RAW` | — | `0x0000` | 3.3V rail current sense ADC count |
| `0x0300` | `TEMP_LOCAL` | — | `0x0190` | FPGA die temperature in 0.25C units (signed, 10-bit) |
| `0x0301` | `TEMP_REMOTE1` | — | `0x0190` | Remote sensor 1 temperature (LNA front-end) |
| `0x0302` | `TEMP_REMOTE2` | — | `0x0190` | Remote sensor 2 temperature (Clock synthesizer) |
| `0x0308` | `TEMP_ALERT_HIGH` | — | `0x0190` | Over-temperature alert threshold (100C default) |
| `0x0309` | `TEMP_ALERT_LOW` | — | `0xFF9C` | Under-temperature alert threshold (-25C default) |
| `0x030F` | `HEALTH_STATUS` | — | `0x00` | System health status summary |
| `0x0400` | `PLL_CTRL` | — | `0x00` | PLL control register |
| `0x0401` | `PLL_STATUS` | — | `0x00` | PLL status register |
| `0x0402` | `PLL_N_DIV` | — | `0x0064` | PLL N divider value (default = 100) |
| `0x0403` | `PLL_R_DIV` | — | `0x000A` | PLL R divider value (default = 10) |
| `0x0410` | `CLK_ENABLE` | — | `0x00` | Clock output enables (one bit per output) |
| `0x0500` | `EEPROM_CTRL` | — | `0x00` | EEPROM control register |
| `0x0501` | `EEPROM_ADDR` | — | `0x0000` | EEPROM byte address [15:0] |
| `0x0502` | `EEPROM_DATA` | — | `0x0000` | EEPROM read/write data [15:0] |
| `0x0600` | `FLASH_CTRL` | — | `0x00` | Configuration Flash control |
| `0x0601` | `FLASH_ADDR_LOW` | — | `0x0000` | Flash address [15:0] |
| `0x0602` | `FLASH_ADDR_HIGH` | — | `0x0000` | Flash address [23:16] |
| `0x0603` | `FLASH_DATA` | — | `0x0000` | Flash read/write data FIFO |
| `0x0604` | `FLASH_STATUS` | — | `0x01` | Flash status register |
| `0x0800` | `GPIO_CTRL` | — | `0x00` | GPIO direction and output control |
| `0x0801` | `GPIO_INPUT` | — | `0x00` | GPIO input status |

---
### `BOARD_ID` — Address `0x0000`

**Reset value:** `0x4B48 0x56`  **Access:** see fields below

Board identification code - ASCII 'KHV' signature [15:8]='K', [7:0]='H'

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BOARD_SIG_HIGH` | `[15:8]` | RO | `0x4B` | Board identifier byte 1 (ASCII 'K') |
| `BOARD_SIG_LOW` | `[7:0]` | RO | `0x48` | Board identifier byte 2 (ASCII 'H') |
| `RSVD` | `[15:0]` | RO | `0x0000` | Reserved - must return 0x0000 |

---
### `BOARD_VERSION` — Address `0x0001`

**Reset value:** `0x01`  **Access:** see fields below

Hardware version number - [7:4]=major, [3:0]=minor

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAJOR_VERSION` | `[7:4]` | RO | `0x0` | Major hardware revision |
| `MINOR_VERSION` | `[3:0]` | RO | `0x1` | Minor hardware revision |

---
### `BOARD_TYPE_ID` — Address `0x0002`

**Reset value:** `0x0001`  **Access:** see fields below

Board type identifier - 0x0001 = KHV Wideband RF Receiver

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BOARD_TYPE` | `[15:0]` | RO | `0x0001` | Unique board type code |

---
### `SCRATCHPAD` — Address `0x0003`

**Reset value:** `0x0000`  **Access:** see fields below

Read/write test register for RAM sanity check

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEST_DATA` | `[15:0]` | RW | `0x0000` | User-writable test pattern for verification |

---
### `MCS_VERSION_MAJOR` — Address `0x0010`

**Reset value:** `0x01`  **Access:** see fields below

FPGA firmware major version number

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `FW_MAJOR` | `[7:0]` | RO | `0x01` | Firmware major version |

---
### `MCS_VERSION_MINOR` — Address `0x0011`

**Reset value:** `0x00`  **Access:** see fields below

FPGA firmware minor version number

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `FW_MINOR` | `[7:0]` | RO | `0x00` | Firmware minor version |

---
### `BUILD_DATE` — Address `0x0012`

**Reset value:** `0x20260416`  **Access:** see fields below

Firmware build date in packed BCD (YYYYMMDD)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `YEAR` | `[15:12]` | RO | `0x2` | Build year (decade nibble) |
| `MONTH` | `[11:8]` | RO | `0x4` | Build month (04 = April) |
| `DAY` | `[7:0]` | RO | `0x16` | Build day (16) |

---
### `UART_BAUD_DIV` — Address `0x0100`

**Reset value:** `0x0022`  **Access:** see fields below

UART baud rate divisor for 100MHz reference (0x0022 = 115200 baud)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BAUD_DIVISOR` | `[15:0]` | RW | `0x0022` | Baud rate divisor = f_clk / (16 * baud_rate) |

---
### `UART_CTRL` — Address `0x0101`

**Reset value:** `0x00`  **Access:** see fields below

UART control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0x0` | UART enable - 1=enabled |
| `LOOPBACK` | `[1]` | RW | `0x0` | Internal loopback mode |
| `FRAME_FORMAT` | `[7:4]` | RW | `0x3` | Frame format: 0x3=8N1 |
| `RSVD` | `[15:8]` | RW | `0x0` | Reserved |

---
### `UART_STATUS` — Address `0x0102`

**Reset value:** `0x00`  **Access:** see fields below

UART status flags

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TX_BUSY` | `[0]` | RO | `0x0` | Transmitter busy flag |
| `RX_AVAIL` | `[1]` | RO | `0x0` | Data available in RX FIFO |
| `FRAME_ERR` | `[2]` | RC | `0x0` | Frame error - cleared on read |
| `PARITY_ERR` | `[3]` | RC | `0x0` | Parity error - cleared on read |

---
### `UART_TX_COUNT` — Address `0x0103`

**Reset value:** `0x00`  **Access:** see fields below

TX FIFO fill level

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TX_FILL` | `[7:0]` | RO | `0x0` | Number of bytes in TX FIFO |

---
### `UART_RX_COUNT` — Address `0x0104`

**Reset value:** `0x00`  **Access:** see fields below

RX FIFO fill level

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `RX_FILL` | `[7:0]` | RO | `0x0` | Number of bytes in RX FIFO |

---
### `ETH_MAC_LOW` — Address `0x0110`

**Reset value:** `0x0000`  **Access:** see fields below

Ethernet MAC address lower 16 bits

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAC_LOW` | `[15:0]` | RO | `0x0` | MAC bytes [15:0] |

---
### `ETH_MAC_HIGH` — Address `0x0111`

**Reset value:** `0x0000`  **Access:** see fields below

Ethernet MAC address upper 16 bits

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAC_HIGH` | `[15:0]` | RO | `0x0` | MAC bytes [31:16] |

---
### `RF_FRONT_CTRL` — Address `0x0700`

**Reset value:** `0x00`  **Access:** see fields below

RF Front-End (LNA/VGA) control register for HMC698LP4ETR

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LNA_ENABLE` | `[0]` | RW | `0x0` | LNA power enable - 1=ON |
| `VGA_ENABLE` | `[1]` | RW | `0x0` | VGA power enable - 1=ON |
| `RF_PATH_SEL` | `[2]` | RW | `0x0` | RF input path: 0=J1, 1=J2 |
| `GAIN_CODE` | `[7:4]` | RW | `0x0` | 4-bit VGA gain setting (0-15) |
| `RSVD` | `[15:8]` | RW | `0x0` | Reserved |

---
### `RF_FRONT_STATUS` — Address `0x0701`

**Reset value:** `0x00`  **Access:** see fields below

RF Front-End status monitoring

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LNA_OK` | `[0]` | RO | `0x0` | LNA power good indication |
| `VGA_OK` | `[1]` | RO | `0x0` | VGA power good indication |
| `RF_PRESENT` | `[2]` | RO | `0x0` | RF input detected |
| `TEMP_WARNING` | `[3]` | RO | `0x0` | RF front-end over-temperature warning |
| `RSVD` | `[15:4]` | RO | `0x0` | Reserved |

---
### `ADC_JESD_CTRL` — Address `0x0702`

**Reset value:** `0x00`  **Access:** see fields below

EV12AQ600 ADC JESD204B interface control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_ENABLE` | `[0]` | RW | `0x0` | ADC core enable - 1=powered on |
| `JESD_LINK_EN` | `[1]` | RW | `0x0` | JESD204B link enable |
| `LANES_ENABLE` | `[5:2]` | RW | `0x0` | LVDS lane enables (4 lanes) |
| `SAMPLE_RATE` | `[9:8]` | RW | `0x2` | Sample rate: 0=5GSPS, 1=6.4GSPS, 2=10GSPS, 3=reserved |
| `DECIMATION` | `[11:10]` | RW | `0x0` | Decimation factor: 00=bypass, 01=2x, 10=4x, 11=8x |
| `RSVD` | `[15:12]` | RW | `0x0` | Reserved |

---
### `ADC_JESD_STATUS` — Address `0x0703`

**Reset value:** `0x00`  **Access:** see fields below

ADC JESD204B link status monitoring

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LINK_LOCKED` | `[0]` | RO | `0x0` | JESD204B link locked |
| `CODE_GROUP_SYNC` | `[1]` | RO | `0x0` | Code group sync achieved |
| `LANE0_ALIGN` | `[4]` | RO | `0x0` | Lane 0 aligned |
| `LANE1_ALIGN` | `[5]` | RO | `0x0` | Lane 1 aligned |
| `LANE2_ALIGN` | `[6]` | RO | `0x0` | Lane 2 aligned |
| `LANE3_ALIGN` | `[7]` | RO | `0x0` | Lane 3 aligned |
| `DISPERR` | `[8]` | RC | `0x0` | Disparity error detected |
| `RSVD` | `[15:9]` | RO | `0x0` | Reserved |

---
### `SAMPLE_COUNT_LOW` — Address `0x0704`

**Reset value:** `0x0000`  **Access:** see fields below

ADC sample counter lower 16 bits

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `COUNT_LOW` | `[15:0]` | RO | `0x0` | Lower 16 bits of 48-bit sample counter |

---
### `SAMPLE_COUNT_HIGH` — Address `0x0705`

**Reset value:** `0x0000`  **Access:** see fields below

ADC sample counter upper 16 bits

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `COUNT_HIGH` | `[15:0]` | RO | `0x0` | Upper 16 bits of 48-bit sample counter (bits [31:16]) |

---
### `SPI_CLKGEN_CTRL` — Address `0x0706`

**Reset value:** `0x00`  **Access:** see fields below

SPI master control for LMK04828 clock synthesizer

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `SPI_CLKGEN_EN` | `[0]` | RW | `0x0` | Enable SPI to clock synthesizer |
| `CLKGEN_RESET` | `[1]` | RW | `0x0` | Assert clock synthesizer reset |
| `CLK_SEL` | `[3:2]` | RW | `0x0` | Clock source select: 00=PLL1, 01=PLL2, 10=OSC_IN |
| `SYNC_EN` | `[4]` | RW | `0x0` | Enable SYNC output to ADC |
| `RSVD` | `[15:5]` | RW | `0x0` | Reserved |

---
### `SPI_CLKGEN_STATUS` — Address `0x0707`

**Reset value:** `0x00`  **Access:** see fields below

Clock synthesizer status monitoring

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `PLL1_LOCK` | `[0]` | RO | `0x0` | PLL1 locked indicator |
| `PLL2_LOCK` | `[1]` | RO | `0x0` | PLL2 locked indicator |
| `HOLDOVER` | `[2]` | RO | `0x0` | Holdover mode active |
| `CLK_VALID` | `[3]` | RO | `0x0` | Clock output valid |
| `RSVD` | `[15:4]` | RO | `0x0` | Reserved |

---
### `ADC_DATA_CAPTURE_CTRL` — Address `0x0708`

**Reset value:** `0x00`  **Access:** see fields below

ADC data capture and buffering control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `CAPTURE_EN` | `[0]` | RW | `0x0` | Enable data capture to memory |
| `TRIGGER_MODE` | `[2:1]` | RW | `0x0` | Trigger: 00=immediate, 01=external, 10=software, 11=pattern |
| `BUFFER_MODE` | `[4:3]` | RW | `0x0` | Buffer: 00=circular, 01=stop-full, 10=overwrite, 11=reserved |
| `PRE_TRIGGER` | `[11:8]` | RW | `0x0` | Pre-trigger samples (x256) |
| `RSVD` | `[15:12]` | RW | `0x0` | Reserved |

---
### `ADC_DATA_CAPTURE_STATUS` — Address `0x0709`

**Reset value:** `0x00`  **Access:** see fields below

ADC data capture status

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `CAPTURE_ACTIVE` | `[0]` | RO | `0x0` | Capture currently active |
| `BUFFER_FULL` | `[1]` | RO | `0x0` | Capture buffer full |
| `TRIGGERED` | `[2]` | RO | `0x0` | Trigger event occurred |
| `OVERRUN` | `[3]` | RC | `0x0` | Buffer overrun occurred - clears on read |
| `RSVD` | `[15:4]` | RO | `0x0` | Reserved |

---
### `ADC_CTRL` — Address `0x0200`

**Reset value:** `0x00`  **Access:** see fields below

System ADC control for monitoring

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `START` | `[0]` | RW | `0x0` | Start ADC conversion |
| `CONTINUOUS` | `[1]` | RW | `0x0` | Continuous conversion mode |
| `CHANNEL_SEL` | `[3:2]` | RW | `0x0` | Channel select |
| `RSVD` | `[15:4]` | RW | `0x0` | Reserved |

---
### `ADC_STATUS` — Address `0x0201`

**Reset value:** `0x00`  **Access:** see fields below

System ADC status

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA_READY` | `[0]` | RO | `0x0` | Conversion data ready |
| `OVERRANGE` | `[1]` | RC | `0x0` | ADC overrange - clears on read |
| `RSVD` | `[15:2]` | RO | `0x0` | Reserved |

---
### `VCC_5V_RAW` — Address `0x0210`

**Reset value:** `0x0000`  **Access:** see fields below

5V rail raw ADC count (multiply by 5.0/4096)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | RO | `0x0` | 12-bit ADC count |
| `RSVD` | `[15:12]` | RO | `0x0` | Reserved |

---
### `VCC_3V3_RAW` — Address `0x0211`

**Reset value:** `0x0000`  **Access:** see fields below

3.3V rail raw ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | RO | `0x0` | 12-bit ADC count |
| `RSVD` | `[15:12]` | RO | `0x0` | Reserved |

---
### `VCC_2V5_RAW` — Address `0x0212`

**Reset value:** `0x0000`  **Access:** see fields below

2.5V rail raw ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | RO | `0x0` | 12-bit ADC count |
| `RSVD` | `[15:12]` | RO | `0x0` | Reserved |

---
### `VCC_1V8_RAW` — Address `0x0213`

**Reset value:** `0x0000`  **Access:** see fields below

1.8V rail raw ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | RO | `0x0` | 12-bit ADC count |
| `RSVD` | `[15:12]` | RO | `0x0` | Reserved |

---
### `ICC_5V_RAW` — Address `0x0218`

**Reset value:** `0x0000`  **Access:** see fields below

5V rail current sense ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | RO | `0x0` | 12-bit ADC count |
| `RSVD` | `[15:12]` | RO | `0x0` | Reserved |

---
### `ICC_3V3_RAW` — Address `0x0219`

**Reset value:** `0x0000`  **Access:** see fields below

3.3V rail current sense ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | RO | `0x0` | 12-bit ADC count |
| `RSVD` | `[15:12]` | RO | `0x0` | Reserved |

---
### `TEMP_LOCAL` — Address `0x0300`

**Reset value:** `0x0190`  **Access:** see fields below

FPGA die temperature in 0.25C units (signed, 10-bit)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP` | `[9:0]` | RO | `0x190` | Temperature x4 (e.g., 0x190 = 100C) |
| `RSVD` | `[15:10]` | RO | `0x0` | Reserved |

---
### `TEMP_REMOTE1` — Address `0x0301`

**Reset value:** `0x0190`  **Access:** see fields below

Remote sensor 1 temperature (LNA front-end)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP` | `[9:0]` | RO | `0x190` | Temperature x4 |
| `RSVD` | `[15:10]` | RO | `0x0` | Reserved |

---
### `TEMP_REMOTE2` — Address `0x0302`

**Reset value:** `0x0190`  **Access:** see fields below

Remote sensor 2 temperature (Clock synthesizer)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP` | `[9:0]` | RO | `0x190` | Temperature x4 |
| `RSVD` | `[15:10]` | RO | `0x0` | Reserved |

---
### `TEMP_ALERT_HIGH` — Address `0x0308`

**Reset value:** `0x0190`  **Access:** see fields below

Over-temperature alert threshold (100C default)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `THRESH` | `[9:0]` | RW | `0x190` | Temperature threshold x4 |
| `RSVD` | `[15:10]` | RW | `0x0` | Reserved |

---
### `TEMP_ALERT_LOW` — Address `0x0309`

**Reset value:** `0xFF9C`  **Access:** see fields below

Under-temperature alert threshold (-25C default)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `THRESH` | `[9:0]` | RW | `0xFF9C` | Temperature threshold x4 (signed) |
| `RSVD` | `[15:10]` | RW | `0x0` | Reserved |

---
### `HEALTH_STATUS` — Address `0x030F`

**Reset value:** `0x00`  **Access:** see fields below

System health status summary

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_OK` | `[0]` | RO | `0x0` | Temperature within limits |
| `VOLT_OK` | `[1]` | RO | `0x0` | Power rails within limits |
| `PLL_LOCK` | `[2]` | RO | `0x0` | PLL locked indication |
| `RF_FRONT_OK` | `[3]` | RO | `0x0` | RF front-end OK |
| `ADC_LINK_OK` | `[4]` | RO | `0x0` | ADC JESD link OK |
| `SYSTEM_OK` | `[7]` | RO | `0x0` | Overall system health (all checks pass) |
| `RSVD` | `[15:8]` | RO | `0x0` | Reserved |

---
### `PLL_CTRL` — Address `0x0400`

**Reset value:** `0x00`  **Access:** see fields below

PLL control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0x0` | PLL enable |
| `RESET` | `[1]` | RW | `0x0` | PLL reset (active high) |
| `REF_SEL` | `[3:2]` | RW | `0x0` | Reference clock select |
| `RSVD` | `[15:4]` | RW | `0x0` | Reserved |

---
### `PLL_STATUS` — Address `0x0401`

**Reset value:** `0x00`  **Access:** see fields below

PLL status register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LOCKED` | `[0]` | RO | `0x0` | PLL locked |
| `LOSS_OF_LOCK` | `[1]` | RC | `0x0` | PLL loss of lock event - clears on read |
| `RSVD` | `[15:2]` | RO | `0x0` | Reserved |

---
### `PLL_N_DIV` — Address `0x0402`

**Reset value:** `0x0064`  **Access:** see fields below

PLL N divider value (default = 100)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `N_DIV` | `[15:0]` | RW | `0x64` | N divider value |

---
### `PLL_R_DIV` — Address `0x0403`

**Reset value:** `0x000A`  **Access:** see fields below

PLL R divider value (default = 10)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `R_DIV` | `[7:0]` | RW | `0xA` | R divider value |
| `RSVD` | `[15:8]` | RW | `0x0` | Reserved |

---
### `CLK_ENABLE` — Address `0x0410`

**Reset value:** `0x00`  **Access:** see fields below

Clock output enables (one bit per output)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `CLK0_EN` | `[0]` | RW | `0x0` | Clock output 0 enable |
| `CLK1_EN` | `[1]` | RW | `0x0` | Clock output 1 enable |
| `CLK2_EN` | `[2]` | RW | `0x0` | Clock output 2 enable |
| `CLK3_EN` | `[3]` | RW | `0x0` | Clock output 3 enable |
| `CLK4_EN` | `[4]` | RW | `0x0` | Clock output 4 enable |
| `CLK5_EN` | `[5]` | RW | `0x0` | Clock output 5 enable |
| `CLK6_EN` | `[6]` | RW | `0x0` | Clock output 6 enable |
| `CLK7_EN` | `[7]` | RW | `0x0` | Clock output 7 enable |
| `RSVD` | `[15:8]` | RW | `0x0` | Reserved |

---
### `EEPROM_CTRL` — Address `0x0500`

**Reset value:** `0x00`  **Access:** see fields below

EEPROM control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READ` | `[0]` | RW | `0x0` | Start EEPROM read |
| `WRITE` | `[1]` | RW | `0x0` | Start EEPROM write |
| `ERASE` | `[2]` | RW | `0x0` | Start EEPROM erase |
| `BUSY` | `[7]` | RO | `0x0` | EEPROM operation in progress |
| `RSVD` | `[15:8]` | RW | `0x0` | Reserved |

---
### `EEPROM_ADDR` — Address `0x0501`

**Reset value:** `0x0000`  **Access:** see fields below

EEPROM byte address [15:0]

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADDR` | `[15:0]` | RW | `0x0` | Byte address |

---
### `EEPROM_DATA` — Address `0x0502`

**Reset value:** `0x0000`  **Access:** see fields below

EEPROM read/write data [15:0]

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA` | `[15:0]` | RW | `0x0` | Data word |

---
### `FLASH_CTRL` — Address `0x0600`

**Reset value:** `0x00`  **Access:** see fields below

Configuration Flash control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READ` | `[0]` | RW | `0x0` | Start Flash read |
| `WRITE` | `[1]` | RW | `0x0` | Start Flash write |
| `ERASE_SECTOR` | `[2]` | RW | `0x0` | Erase Flash sector |
| `ERASE_CHIP` | `[3]` | RW | `0x0` | Erase entire Flash chip |
| `BUSY` | `[7]` | RO | `0x0` | Flash operation in progress |
| `RSVD` | `[15:8]` | RW | `0x0` | Reserved |

---
### `FLASH_ADDR_LOW` — Address `0x0601`

**Reset value:** `0x0000`  **Access:** see fields below

Flash address [15:0]

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADDR_LOW` | `[15:0]` | RW | `0x0` | Low word of address |

---
### `FLASH_ADDR_HIGH` — Address `0x0602`

**Reset value:** `0x0000`  **Access:** see fields below

Flash address [23:16]

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADDR_HIGH` | `[7:0]` | RW | `0x0` | High byte of address |
| `RSVD` | `[15:8]` | RW | `0x0` | Reserved |

---
### `FLASH_DATA` — Address `0x0603`

**Reset value:** `0x0000`  **Access:** see fields below

Flash read/write data FIFO

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA` | `[15:0]` | RW | `0x0` | Data word |

---
### `FLASH_STATUS` — Address `0x0604`

**Reset value:** `0x01`  **Access:** see fields below

Flash status register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READY` | `[0]` | RO | `0x1` | Flash ready |
| `WRITE_ERR` | `[1]` | RC | `0x0` | Write error - clears on read |
| `ERASE_ERR` | `[2]` | RC | `0x0` | Erase error - clears on read |
| `RSVD` | `[15:3]` | RO | `0x0` | Reserved |

---
### `GPIO_CTRL` — Address `0x0800`

**Reset value:** `0x00`  **Access:** see fields below

GPIO direction and output control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GPIO0_OE` | `[0]` | RW | `0x0` | GPIO0 output enable |
| `GPIO1_OE` | `[1]` | RW | `0x0` | GPIO1 output enable |
| `GPIO2_OE` | `[2]` | RW | `0x0` | GPIO2 output enable |
| `GPIO3_OE` | `[3]` | RW | `0x0` | GPIO3 output enable |
| `GPIO0_OUT` | `[8]` | RW | `0x0` | GPIO0 output value |
| `GPIO1_OUT` | `[9]` | RW | `0x0` | GPIO1 output value |
| `GPIO2_OUT` | `[10]` | RW | `0x0` | GPIO2 output value |
| `GPIO3_OUT` | `[11]` | RW | `0x0` | GPIO3 output value |
| `RSVD` | `[15:12]` | RW | `0x0` | Reserved |

---
### `GPIO_INPUT` — Address `0x0801`

**Reset value:** `0x00`  **Access:** see fields below

GPIO input status

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GPIO0_IN` | `[0]` | RO | `0x0` | GPIO0 input value |
| `GPIO1_IN` | `[1]` | RO | `0x0` | GPIO1 input value |
| `GPIO2_IN` | `[2]` | RO | `0x0` | GPIO2 input value |
| `GPIO3_IN` | `[3]` | RO | `0x0` | GPIO3 input value |
| `RSVD` | `[15:4]` | RO | `0x0` | Reserved |
