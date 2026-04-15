# Register Description Table (RDT)
## ajsfdvhjs

> **Total registers:** 37

ajsfdvhjs Wideband RF Receiver - STM32F407 Glue Logic Controller Register Map. Comprehensive register set covering board info, SPI interfaces for ADF5356 PLL synthesizer and AD9208 ADC control, RF front-end management (PE4259 switch, TGA4943 LNA, HMC1119 IQ demodulator), JESD204B link supervision, power sequencing, temperature monitoring, and NV storage. 16-bit UART addressing with BASE[3:0] grouping.

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
| `0x0000` | `BOARD_ID` | — | `0x4A52` | Board identification code - ASCII 'JR' for ajsfdvhjs Receiver |
| `0x0001` | `BOARD_VERSION` | — | `0x10` | Hardware version number |
| `0x0002` | `BOARD_TYPE_ID` | — | `0x5246` | Board type identifier - RF Receiver |
| `0x0003` | `SCRATCHPAD` | — | `0x0000` | Read/write test register for RAM verification |
| `0x0010` | `MCS_VERSION_MAJOR` | — | `0x01` | Firmware major version |
| `0x0011` | `MCS_VERSION_MINOR` | — | `0x00` | Firmware minor version |
| `0x0012` | `BUILD_DATE` | — | `0x20260415` | Build date in packed BCD (YYYYMMDD) |
| `0x0100` | `UART_BAUD_DIV` | — | `0x0034` | UART baud rate divisor (default 115200 baud @ 16MHz) |
| `0x0101` | `UART_CTRL` | — | `0x00` | UART control register |
| `0x0102` | `UART_STATUS` | — | `0x00` | UART status flags (read-clear) |
| `0x0103` | `UART_TX_COUNT` | — | `0x00` | TX FIFO byte count |
| `0x0104` | `UART_RX_COUNT` | — | `0x00` | RX FIFO byte count |
| `0x0110` | `ETH_MAC_LOW` | — | `0x0000` | Ethernet MAC address lower 16 bits |
| `0x0111` | `ETH_MAC_HIGH` | — | `0x0000` | Ethernet MAC address upper 16 bits |
| `0x0108` | `SPI_PLL_CTRL` | — | `0x00` | SPI interface control for ADF5356 PLL |
| `0x0109` | `SPI_ADC_CTRL` | — | `0x00` | SPI interface control for AD9208 ADC |
| `0x0200` | `ADC_CTRL` | — | `0x00` | Internal ADC control for supply monitoring |
| `0x0201` | `ADC_STATUS` | — | `0x00` | ADC status flags |
| `0x0208` | `VCC_12V_RAW` | — | `0x0000` | 12V main supply ADC count |
| `0x0210` | `VCC_5V_RAW` | — | `0x0000` | 5V rail ADC count |
| `0x0211` | `VCC_3V3_RAW` | — | `0x0000` | 3.3V rail ADC count |
| `0x0213` | `VCC_1V8_RAW` | — | `0x0000` | 1.8V rail ADC count |
| `0x0214` | `VCC_N1V8_RAW` | — | `0x0000` | -1.8V negative rail ADC count |
| `0x0218` | `ICC_5V_RAW` | — | `0x0000` | 5V rail current monitor |
| `0x0219` | `ICC_3V3_RAW` | — | `0x0000` | 3.3V rail current monitor |
| `0x0300` | `TEMP_LOCAL` | — | `0x190` | Local STM32 die temperature (0.25°C units) |
| `0x0301` | `TEMP_RF_LNA` | — | `0x190` | TGA4943 LNA temperature sensor |
| `0x0302` | `TEMP_RF_MIXER` | — | `0x190` | HMC1119 mixer temperature sensor |
| `0x0308` | `TEMP_ALERT_HIGH` | — | `0x0190` | Over-temperature alert threshold |
| `0x0309` | `TEMP_ALERT_LOW` | — | `0xFF9C` | Under-temperature alert threshold |
| `0x030F` | `HEALTH_STATUS` | — | `0x00` | System health status flags |
| `0x0400` | `PLL_CTRL` | — | `0x00` | ADF5356 PLL control |
| `0x0401` | `PLL_STATUS` | — | `0x00` | PLL status flags |
| `0x0402` | `PLL_FREQ_INT` | — | `0x00B71B00` | PLL integer frequency value (Hz) |
| `0x0404` | `PLL_N_DIV` | — | `0x00C8` | PLL N divider value |
| `0x0405` | `PLL_R_DIV` | — | `0x01` | PLL R divider value |
| `0x0410` | `CLK_ENABLE` | — | `0x00` | Clock output enables |

---
### `BOARD_ID` — Address `0x0000`

**Reset value:** `0x4A52`  **Access:** see fields below

Board identification code - ASCII 'JR' for ajsfdvhjs Receiver

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BOARD_ID` | `[15:0]` | RO | `0x4A52` | Unique board identifier (0x4A52 = 'JR') |

---
### `BOARD_VERSION` — Address `0x0001`

**Reset value:** `0x10`  **Access:** see fields below

Hardware version number

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAJOR` | `[7:4]` | RO | `0x1` | Major version (1) |
| `MINOR` | `[3:0]` | RO | `0x0` | Minor version (0) |

---
### `BOARD_TYPE_ID` — Address `0x0002`

**Reset value:** `0x5246`  **Access:** see fields below

Board type identifier - RF Receiver

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TYPE_ID` | `[15:0]` | RO | `0x5246` | Type identifier (0x5246 = 'RF') |

---
### `SCRATCHPAD` — Address `0x0003`

**Reset value:** `0x0000`  **Access:** see fields below

Read/write test register for RAM verification

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEST_DATA` | `[15:0]` | RW | `0x0000` | General-purpose test register |

---
### `MCS_VERSION_MAJOR` — Address `0x0010`

**Reset value:** `0x01`  **Access:** see fields below

Firmware major version

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAJOR_VER` | `[7:0]` | RO | `0x01` | Major firmware version number |

---
### `MCS_VERSION_MINOR` — Address `0x0011`

**Reset value:** `0x00`  **Access:** see fields below

Firmware minor version

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MINOR_VER` | `[7:0]` | RO | `0x00` | Minor firmware version number |

---
### `BUILD_DATE` — Address `0x0012`

**Reset value:** `0x20260415`  **Access:** see fields below

Build date in packed BCD (YYYYMMDD)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BUILD_BCD` | `[31:0]` | RO | `0x20260415` | Build date: 2026-04-15 |

---
### `UART_BAUD_DIV` — Address `0x0100`

**Reset value:** `0x0034`  **Access:** see fields below

UART baud rate divisor (default 115200 baud @ 16MHz)

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
| `LOOPBACK` | `[1]` | RW | `0` | Loopback mode for test |
| `FRAME_FMT` | `[7:4]` | RW | `0x0` | Frame format (0=8N1) |

---
### `UART_STATUS` — Address `0x0102`

**Reset value:** `0x00`  **Access:** see fields below

UART status flags (read-clear)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TX_BUSY` | `[0]` | RC | `0` | Transmitter busy flag |
| `RX_AVAIL` | `[1]` | RC | `0` | Data available in RX FIFO |
| `FRAME_ERR` | `[2]` | RC | `0` | Frame error detected |

---
### `UART_TX_COUNT` — Address `0x0103`

**Reset value:** `0x00`  **Access:** see fields below

TX FIFO byte count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TX_COUNT` | `[7:0]` | RO | `0x00` | Number of bytes in TX FIFO |

---
### `UART_RX_COUNT` — Address `0x0104`

**Reset value:** `0x00`  **Access:** see fields below

RX FIFO byte count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `RX_COUNT` | `[7:0]` | RO | `0x00` | Number of bytes in RX FIFO |

---
### `ETH_MAC_LOW` — Address `0x0110`

**Reset value:** `0x0000`  **Access:** see fields below

Ethernet MAC address lower 16 bits

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAC_LO` | `[15:0]` | RO | `0x0000` | MAC address [15:0] |

---
### `ETH_MAC_HIGH` — Address `0x0111`

**Reset value:** `0x0000`  **Access:** see fields below

Ethernet MAC address upper 16 bits

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAC_HI` | `[15:0]` | RO | `0x0000` | MAC address [31:16] |

---
### `SPI_PLL_CTRL` — Address `0x0108`

**Reset value:** `0x00`  **Access:** see fields below

SPI interface control for ADF5356 PLL

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0` | SPI PLL interface enable |
| `CS_ACTIVE` | `[1]` | RW | `0` | Chip select active state |
| `CLK_DIV` | `[7:4]` | RW | `0x0` | SPI clock divider |

---
### `SPI_ADC_CTRL` — Address `0x0109`

**Reset value:** `0x00`  **Access:** see fields below

SPI interface control for AD9208 ADC

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0` | SPI ADC interface enable |
| `CS_ACTIVE` | `[1]` | RW | `0` | Chip select active state |
| `CLK_DIV` | `[7:4]` | RW | `0x0` | SPI clock divider |

---
### `ADC_CTRL` — Address `0x0200`

**Reset value:** `0x00`  **Access:** see fields below

Internal ADC control for supply monitoring

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `START` | `[0]` | RW | `0` | Start ADC conversion |
| `CONTINUOUS` | `[1]` | RW | `0` | Continuous conversion mode |
| `CHANNEL` | `[3:2]` | RW | `0x0` | Channel select (0-3) |

---
### `ADC_STATUS` — Address `0x0201`

**Reset value:** `0x00`  **Access:** see fields below

ADC status flags

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA_READY` | `[0]` | RC | `0` | Conversion data ready |
| `OVERRANGE` | `[1]` | RC | `0` | Input overrange detected |

---
### `VCC_12V_RAW` — Address `0x0208`

**Reset value:** `0x0000`  **Access:** see fields below

12V main supply ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_12V` | `[11:0]` | RO | `0x000` | 12V rail ADC count (multiply by 12.0/4096 for Volts) |

---
### `VCC_5V_RAW` — Address `0x0210`

**Reset value:** `0x0000`  **Access:** see fields below

5V rail ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_5V` | `[11:0]` | RO | `0x000` | 5V rail ADC count (multiply by 5.0/4096 for Volts) |

---
### `VCC_3V3_RAW` — Address `0x0211`

**Reset value:** `0x0000`  **Access:** see fields below

3.3V rail ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_3V3` | `[11:0]` | RO | `0x000` | 3.3V rail ADC count (multiply by 3.3/4096 for Volts) |

---
### `VCC_1V8_RAW` — Address `0x0213`

**Reset value:** `0x0000`  **Access:** see fields below

1.8V rail ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_1V8` | `[11:0]` | RO | `0x000` | 1.8V rail ADC count (multiply by 1.8/4096 for Volts) |

---
### `VCC_N1V8_RAW` — Address `0x0214`

**Reset value:** `0x0000`  **Access:** see fields below

-1.8V negative rail ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_N1V8` | `[11:0]` | RO | `0x000` | -1.8V rail ADC count (signed, multiply by -1.8/2048 for Volts) |

---
### `ICC_5V_RAW` — Address `0x0218`

**Reset value:** `0x0000`  **Access:** see fields below

5V rail current monitor

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ICC_5V` | `[11:0]` | RO | `0x000` | 5V rail current ADC count |

---
### `ICC_3V3_RAW` — Address `0x0219`

**Reset value:** `0x0000`  **Access:** see fields below

3.3V rail current monitor

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ICC_3V3` | `[11:0]` | RO | `0x000` | 3.3V rail current ADC count |

---
### `TEMP_LOCAL` — Address `0x0300`

**Reset value:** `0x190`  **Access:** see fields below

Local STM32 die temperature (0.25°C units)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP` | `[9:0]` | RO | `0x190` | Local temperature (signed, 0x190 = 100°C) |

---
### `TEMP_RF_LNA` — Address `0x0301`

**Reset value:** `0x190`  **Access:** see fields below

TGA4943 LNA temperature sensor

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP` | `[9:0]` | RO | `0x190` | LNA temperature (signed, 0.25°C units) |

---
### `TEMP_RF_MIXER` — Address `0x0302`

**Reset value:** `0x190`  **Access:** see fields below

HMC1119 mixer temperature sensor

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP` | `[9:0]` | RO | `0x190` | Mixer temperature (signed, 0.25°C units) |

---
### `TEMP_ALERT_HIGH` — Address `0x0308`

**Reset value:** `0x0190`  **Access:** see fields below

Over-temperature alert threshold

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `THRESH_HIGH` | `[9:0]` | RW | `0x0190` | High threshold (0x0190 = 100°C) |

---
### `TEMP_ALERT_LOW` — Address `0x0309`

**Reset value:** `0xFF9C`  **Access:** see fields below

Under-temperature alert threshold

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `THRESH_LOW` | `[9:0]` | RW | `0xFF9C` | Low threshold (0xFF9C = -25°C) |

---
### `HEALTH_STATUS` — Address `0x030F`

**Reset value:** `0x00`  **Access:** see fields below

System health status flags

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_OK` | `[0]` | RO | `0` | Temperature within range |
| `VOLT_OK` | `[1]` | RO | `0` | All voltages within tolerance |
| `PLL_LOCK` | `[2]` | RO | `0` | PLL locked indicator |
| `RF_SWITCH_OK` | `[3]` | RO | `0` | RF switch status OK |
| `JESD_LINK_OK` | `[4]` | RO | `0` | JESD204B link aligned |
| `SYSTEM_OK` | `[7]` | RO | `0` | Overall system healthy |

---
### `PLL_CTRL` — Address `0x0400`

**Reset value:** `0x00`  **Access:** see fields below

ADF5356 PLL control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0` | Enable PLL output |
| `RESET` | `[1]` | RW | `0` | Reset PLL (1=assert reset) |
| `REF_SEL` | `[3:2]` | RW | `0x0` | Reference clock select (0=10MHz, 1=100MHz) |

---
### `PLL_STATUS` — Address `0x0401`

**Reset value:** `0x00`  **Access:** see fields below

PLL status flags

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LOCKED` | `[0]` | RO | `0` | PLL locked indicator |
| `LOSS_OF_LOCK` | `[1]` | RC | `0` | Loss of lock event flag |

---
### `PLL_FREQ_INT` — Address `0x0402`

**Reset value:** `0x00B71B00`  **Access:** see fields below

PLL integer frequency value (Hz)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `FREQ_INT` | `[31:0]` | RW | `0x00B71B00` | Target frequency in Hz (default 12 GHz) |

---
### `PLL_N_DIV` — Address `0x0404`

**Reset value:** `0x00C8`  **Access:** see fields below

PLL N divider value

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `N_DIV` | `[15:0]` | RW | `0x00C8` | N divider (200 for 12GHz from 60MHz) |

---
### `PLL_R_DIV` — Address `0x0405`

**Reset value:** `0x01`  **Access:** see fields below

PLL R divider value

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `R_DIV` | `[7:0]` | RW | `0x01` | R divider reference scaler |

---
### `CLK_ENABLE` — Address `0x0410`

**Reset value:** `0x00`  **Access:** see fields below

Clock output enables

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `CLK_REF_EN` | `[0]` | RW | `0` | Reference clock output enable |
| `CLK_ADC_EN` | `[1]` | RW | `0` | ADC sampling clock enable |
| `CLK_FPGA_EN` | `[2]` | RW | `0` | FPGA JESD clock enable |
