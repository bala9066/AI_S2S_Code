# Register Description Table (RDT)
## hh

> **Total registers:** 57

Complete RDT and PSQ for hh dual-channel RF front-end receiver system with 44 registers covering board information, communication interfaces, ADC monitoring, temperature control, PLL/clock management, EEPROM/Flash storage, RF control, and GPIO/DAC functionality. Programming sequence includes 28 steps across power-on reset, PLL initialization, peripheral configuration, communication setup, and RF frontend initialization.

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
| `0x0000` | `BOARD_ID` | — | `0x55AA` | Board identification code |
| `0x0001` | `BOARD_VERSION` | — | `0x01` | Hardware version |
| `0x0002` | `BOARD_TYPE_ID` | — | `0x2026` | Board type identifier |
| `0x0003` | `SCRATCHPAD` | — | `0x0000` | Read/write test register |
| `0x0010` | `MCS_VERSION_MAJOR` | — | `0x01` | FPGA firmware major version |
| `0x0011` | `MCS_VERSION_MINOR` | — | `0x04` | FPGA firmware minor version |
| `0x0012` | `BUILD_DATE` | — | `0x260419` | Build date (YYYYMMDD packed BCD) |
| `0x0100` | `UART_BAUD_DIV` | — | `0x0068` | UART baud rate divisor |
| `0x0101` | `UART_CTRL` | — | `0x00` | UART control |
| `0x0102` | `UART_STATUS` | — | `0x00` | UART status |
| `0x0103` | `UART_TX_COUNT` | — | `0x00` | TX FIFO byte count |
| `0x0104` | `UART_RX_COUNT` | — | `0x00` | RX FIFO byte count |
| `0x0110` | `ETH_MAC_LOW` | — | `0x1234` | Ethernet MAC address low |
| `0x0111` | `ETH_MAC_HIGH` | — | `0x5678` | Ethernet MAC address high |
| `0x0200` | `ADC_CTRL` | — | `0x00` | ADC control |
| `0x0201` | `ADC_STATUS` | — | `0x00` | ADC status |
| `0x0210` | `VCC_5V_RAW` | — | `0x0000` | 5V rail ADC count |
| `0x0211` | `VCC_3V3_RAW` | — | `0x0000` | 3.3V rail ADC count |
| `0x0212` | `VCC_2V5_RAW` | — | `0x0000` | 2.5V rail ADC count |
| `0x0213` | `VCC_1V8_RAW` | — | `0x0000` | 1.8V rail ADC count |
| `0x0218` | `ICC_5V_RAW` | — | `0x0000` | 5V rail current ADC count |
| `0x0219` | `ICC_3V3_RAW` | — | `0x0000` | 3.3V rail current ADC count |
| `0x0300` | `TEMP_LOCAL` | — | `0x0000` | Local FPGA die temperature |
| `0x0301` | `TEMP_REMOTE1` | — | `0x0000` | Remote sensor 1 temperature |
| `0x0302` | `TEMP_REMOTE2` | — | `0x0000` | Remote sensor 2 temperature |
| `0x0308` | `TEMP_ALERT_HIGH` | — | `0x0190` | Over-temperature alert threshold |
| `0x0309` | `TEMP_ALERT_LOW` | — | `0xFF9C` | Under-temperature alert threshold |
| `0x030F` | `HEALTH_STATUS` | — | `0x00` | System health status |
| `0x0400` | `PLL_CTRL` | — | `0x00` | PLL control |
| `0x0401` | `PLL_STATUS` | — | `0x00` | PLL status |
| `0x0402` | `PLL_N_DIV` | — | `0x0050` | N divider |
| `0x0403` | `PLL_R_DIV` | — | `0x0005` | R divider |
| `0x0410` | `CLK_ENABLE` | — | `0x00` | Clock output enables |
| `0x0500` | `EEPROM_CTRL` | — | `0x00` | EEPROM control |
| `0x0501` | `EEPROM_ADDR` | — | `0x0000` | EEPROM byte address |
| `0x0502` | `EEPROM_DATA` | — | `0x0000` | EEPROM read/write data |
| `0x0600` | `FLASH_CTRL` | — | `0x00` | Flash control |
| `0x0601` | `FLASH_ADDR_LOW` | — | `0x0000` | Flash address low |
| `0x0602` | `FLASH_ADDR_HIGH` | — | `0x0000` | Flash address high |
| `0x0603` | `FLASH_DATA` | — | `0x0000` | Flash read/write data |
| `0x0604` | `FLASH_STATUS` | — | `0x00` | Flash status |
| `0x0700` | `RF_EN_ANT1` | — | `0x00` | RF channel enables for antenna 1 |
| `0x0701` | `RF_EN_ANT2` | — | `0x00` | RF channel enables for antenna 2 |
| `0x0708` | `RF_GAIN_ANT1` | — | `0x00` | RF gain control for antenna 1 |
| `0x0709` | `RF_GAIN_ANT2` | — | `0x00` | RF gain control for antenna 2 |
| `0x070F` | `RF_MODE` | — | `0x00` | RF operating mode |
| `0x0710` | `LIM_CTRL` | — | `0x00` | Limiter control |
| `0x0718` | `BPF_CTRL` | — | `0x00` | Band-pass filter control |
| `0x0800` | `WDT_CTRL` | — | `0x00` | Watchdog timer control |
| `0x0801` | `WDT_STATUS` | — | `0x00` | Watchdog timer status |
| `0x0808` | `GPIO_DIR` | — | `0x00` | GPIO direction control |
| `0x0809` | `GPIO_OUT` | — | `0x00` | GPIO output values |
| `0x080A` | `GPIO_IN` | — | `0x00` | GPIO input values |
| `0x0900` | `DAC_CTRL` | — | `0x00` | DAC control |
| `0x0901` | `DAC_DATA` | — | `0x0000` | DAC output data |
| `0x0908` | `GPOUT_EN` | — | `0x00` | General purpose output enables |
| `0x0909` | `GPOUT_VAL` | — | `0x00` | General purpose output values |

---
### `BOARD_ID` — Address `0x0000`

**Reset value:** `0x55AA`  **Access:** see fields below

Board identification code

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BOARD_ID` | `[15:0]` | RO | `0x55AA` | Board ID (0x55AA for hh) |

---
### `BOARD_VERSION` — Address `0x0001`

**Reset value:** `0x01`  **Access:** see fields below

Hardware version

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAJOR` | `[7:4]` | RO | `0x1` | Major version number |
| `MINOR` | `[3:0]` | RO | `0x0` | Minor version number |

---
### `BOARD_TYPE_ID` — Address `0x0002`

**Reset value:** `0x2026`  **Access:** see fields below

Board type identifier

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TYPE_ID` | `[15:0]` | RO | `0x2026` | Board type (0x2026 = hh dual-channel) |

---
### `SCRATCHPAD` — Address `0x0003`

**Reset value:** `0x0000`  **Access:** see fields below

Read/write test register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEST_DATA` | `[15:0]` | RW | `0x0000` | Test data for memory verification |

---
### `MCS_VERSION_MAJOR` — Address `0x0010`

**Reset value:** `0x01`  **Access:** see fields below

FPGA firmware major version

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `VER_MAJOR` | `[7:0]` | RO | `0x01` | Firmware major version |

---
### `MCS_VERSION_MINOR` — Address `0x0011`

**Reset value:** `0x04`  **Access:** see fields below

FPGA firmware minor version

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `VER_MINOR` | `[7:0]` | RO | `0x04` | Firmware minor version |

---
### `BUILD_DATE` — Address `0x0012`

**Reset value:** `0x260419`  **Access:** see fields below

Build date (YYYYMMDD packed BCD)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BUILD_DATE` | `[15:0]` | RO | `0x260419` | Build date (19.04.2026) |

---
### `UART_BAUD_DIV` — Address `0x0100`

**Reset value:** `0x0068`  **Access:** see fields below

UART baud rate divisor

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BAUD_DIV` | `[15:0]` | RW | `0x0068` | Baud rate divisor (0x0068 = 9600 baud @ 100MHz) |

---
### `UART_CTRL` — Address `0x0101`

**Reset value:** `0x00`  **Access:** see fields below

UART control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `UART_EN` | `[0]` | RW | `0x0` | UART enable |
| `LOOPBACK` | `[1]` | RW | `0x0` | Loopback mode |
| `FRAME_FORMAT` | `[7:4]` | RW | `0x0` | Frame format (0=8N1) |

---
### `UART_STATUS` — Address `0x0102`

**Reset value:** `0x00`  **Access:** see fields below

UART status

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TX_BUSY` | `[0]` | RC | `0x0` | Transmitter busy |
| `RX_AVAIL` | `[1]` | RC | `0x0` | Data available |
| `FRAME_ERR` | `[2]` | RC | `0x0` | Frame error |

---
### `UART_TX_COUNT` — Address `0x0103`

**Reset value:** `0x00`  **Access:** see fields below

TX FIFO byte count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TX_COUNT` | `[7:0]` | RO | `0x00` | TX FIFO depth |

---
### `UART_RX_COUNT` — Address `0x0104`

**Reset value:** `0x00`  **Access:** see fields below

RX FIFO byte count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `RX_COUNT` | `[7:0]` | RO | `0x00` | RX FIFO depth |

---
### `ETH_MAC_LOW` — Address `0x0110`

**Reset value:** `0x1234`  **Access:** see fields below

Ethernet MAC address low

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAC_LOW` | `[15:0]` | RO | `0x1234` | MAC address bits 15:0 |

---
### `ETH_MAC_HIGH` — Address `0x0111`

**Reset value:** `0x5678`  **Access:** see fields below

Ethernet MAC address high

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAC_HIGH` | `[15:0]` | RO | `0x5678` | MAC address bits 31:16 |

---
### `ADC_CTRL` — Address `0x0200`

**Reset value:** `0x00`  **Access:** see fields below

ADC control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `START` | `[0]` | RW | `0x0` | Start conversion |
| `CONTINUOUS` | `[1]` | RW | `0x0` | Continuous mode |
| `CHANNEL` | `[3:2]` | RW | `0x0` | Channel select |

---
### `ADC_STATUS` — Address `0x0201`

**Reset value:** `0x00`  **Access:** see fields below

ADC status

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA_READY` | `[0]` | RC | `0x0` | Data ready flag |
| `OVERRANGE` | `[1]` | RC | `0x0` | Over range flag |

---
### `VCC_5V_RAW` — Address `0x0210`

**Reset value:** `0x0000`  **Access:** see fields below

5V rail ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_DATA` | `[11:0]` | RO | `0x0000` | 5V ADC value (Volts = Data * 5.0/4096) |

---
### `VCC_3V3_RAW` — Address `0x0211`

**Reset value:** `0x0000`  **Access:** see fields below

3.3V rail ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_DATA` | `[11:0]` | RO | `0x0000` | 3.3V ADC value |

---
### `VCC_2V5_RAW` — Address `0x0212`

**Reset value:** `0x0000`  **Access:** see fields below

2.5V rail ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_DATA` | `[11:0]` | RO | `0x0000` | 2.5V ADC value |

---
### `VCC_1V8_RAW` — Address `0x0213`

**Reset value:** `0x0000`  **Access:** see fields below

1.8V rail ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_DATA` | `[11:0]` | RO | `0x0000` | 1.8V ADC value |

---
### `ICC_5V_RAW` — Address `0x0218`

**Reset value:** `0x0000`  **Access:** see fields below

5V rail current ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_DATA` | `[11:0]` | RO | `0x0000` | 5V current ADC value |

---
### `ICC_3V3_RAW` — Address `0x0219`

**Reset value:** `0x0000`  **Access:** see fields below

3.3V rail current ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_DATA` | `[11:0]` | RO | `0x0000` | 3.3V current ADC value |

---
### `TEMP_LOCAL` — Address `0x0300`

**Reset value:** `0x0000`  **Access:** see fields below

Local FPGA die temperature

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_DATA` | `[9:0]` | RO | `0x0000` | Temperature in 0.25°C units (signed) |

---
### `TEMP_REMOTE1` — Address `0x0301`

**Reset value:** `0x0000`  **Access:** see fields below

Remote sensor 1 temperature

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_DATA` | `[9:0]` | RO | `0x0000` | Remote sensor 1 temperature |

---
### `TEMP_REMOTE2` — Address `0x0302`

**Reset value:** `0x0000`  **Access:** see fields below

Remote sensor 2 temperature

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_DATA` | `[9:0]` | RO | `0x0000` | Remote sensor 2 temperature |

---
### `TEMP_ALERT_HIGH` — Address `0x0308`

**Reset value:** `0x0190`  **Access:** see fields below

Over-temperature alert threshold

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `HIGH_TEMP` | `[9:0]` | RW | `0x0190` | High temp threshold (0x0190 = 100°C) |

---
### `TEMP_ALERT_LOW` — Address `0x0309`

**Reset value:** `0xFF9C`  **Access:** see fields below

Under-temperature alert threshold

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LOW_TEMP` | `[9:0]` | RW | `0xFF9C` | Low temp threshold (0xFF9C = -25°C) |

---
### `HEALTH_STATUS` — Address `0x030F`

**Reset value:** `0x00`  **Access:** see fields below

System health status

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_OK` | `[0]` | RO | `0x0` | Temperature OK status |
| `VOLT_OK` | `[1]` | RO | `0x0` | Voltage OK status |
| `PLL_LOCK` | `[2]` | RO | `0x0` | PLL lock status |
| `SYSTEM_OK` | `[7]` | RO | `0x0` | System overall status |

---
### `PLL_CTRL` — Address `0x0400`

**Reset value:** `0x00`  **Access:** see fields below

PLL control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0x0` | PLL enable |
| `RESET` | `[1]` | RW | `0x0` | PLL reset |
| `REF_SEL` | `[3:2]` | RW | `0x0` | Reference clock select |

---
### `PLL_STATUS` — Address `0x0401`

**Reset value:** `0x00`  **Access:** see fields below

PLL status

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LOCKED` | `[0]` | RC | `0x0` | PLL locked status |
| `LOSS_OF_LOCK` | `[1]` | RC | `0x0` | Loss of lock flag |

---
### `PLL_N_DIV` — Address `0x0402`

**Reset value:** `0x0050`  **Access:** see fields below

N divider

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `N_DIV` | `[15:0]` | RW | `0x0050` | PLL N divider value |

---
### `PLL_R_DIV` — Address `0x0403`

**Reset value:** `0x0005`  **Access:** see fields below

R divider

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `R_DIV` | `[7:0]` | RW | `0x0005` | PLL R divider value |

---
### `CLK_ENABLE` — Address `0x0410`

**Reset value:** `0x00`  **Access:** see fields below

Clock output enables

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `CLK_EN` | `[7:0]` | RW | `0x00` | Clock enable mask (bit0=ref, bit1=sys, bit2=rf) |

---
### `EEPROM_CTRL` — Address `0x0500`

**Reset value:** `0x00`  **Access:** see fields below

EEPROM control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READ` | `[0]` | RW | `0x0` | Read command |
| `WRITE` | `[1]` | RW | `0x0` | Write command |
| `ERASE` | `[2]` | RW | `0x0` | Erase command |
| `BUSY` | `[7]` | RO | `0x0` | Operation busy flag |

---
### `EEPROM_ADDR` — Address `0x0501`

**Reset value:** `0x0000`  **Access:** see fields below

EEPROM byte address

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `EEP_ADDR` | `[15:0]` | RW | `0x0000` | EEPROM address |

---
### `EEPROM_DATA` — Address `0x0502`

**Reset value:** `0x0000`  **Access:** see fields below

EEPROM read/write data

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `EEP_DATA` | `[15:0]` | RW | `0x0000` | EEPROM data |

---
### `FLASH_CTRL` — Address `0x0600`

**Reset value:** `0x00`  **Access:** see fields below

Flash control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READ` | `[0]` | RW | `0x0` | Read command |
| `WRITE` | `[1]` | RW | `0x0` | Write command |
| `ERASE_SECTOR` | `[2]` | RW | `0x0` | Erase sector command |
| `ERASE_CHIP` | `[3]` | RW | `0x0` | Erase chip command |
| `BUSY` | `[7]` | RO | `0x0` | Operation busy flag |

---
### `FLASH_ADDR_LOW` — Address `0x0601`

**Reset value:** `0x0000`  **Access:** see fields below

Flash address low

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `FLASH_ADDR_LO` | `[15:0]` | RW | `0x0000` | Flash address bits 15:0 |

---
### `FLASH_ADDR_HIGH` — Address `0x0602`

**Reset value:** `0x0000`  **Access:** see fields below

Flash address high

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `FLASH_ADDR_HI` | `[15:0]` | RW | `0x0000` | Flash address bits 23:16 |

---
### `FLASH_DATA` — Address `0x0603`

**Reset value:** `0x0000`  **Access:** see fields below

Flash read/write data

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `FLASH_DATA` | `[15:0]` | RW | `0x0000` | Flash data |

---
### `FLASH_STATUS` — Address `0x0604`

**Reset value:** `0x00`  **Access:** see fields below

Flash status

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READY` | `[0]` | RC | `0x0` | Operation complete |
| `WRITE_ERR` | `[1]` | RC | `0x0` | Write error |
| `ERASE_ERR` | `[2]` | RC | `0x0` | Erase error |

---
### `RF_EN_ANT1` — Address `0x0700`

**Reset value:** `0x00`  **Access:** see fields below

RF channel enables for antenna 1

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `CH1_EN` | `[0]` | RW | `0x0` | Channel 1 enable |
| `CH2_EN` | `[1]` | RW | `0x0` | Channel 2 enable |
| `CH3_EN` | `[2]` | RW | `0x0` | Channel 3 enable |
| `CH4_EN` | `[3]` | RW | `0x0` | Channel 4 enable |

---
### `RF_EN_ANT2` — Address `0x0701`

**Reset value:** `0x00`  **Access:** see fields below

RF channel enables for antenna 2

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `CH1_EN` | `[0]` | RW | `0x0` | Channel 1 enable |
| `CH2_EN` | `[1]` | RW | `0x0` | Channel 2 enable |
| `CH3_EN` | `[2]` | RW | `0x0` | Channel 3 enable |
| `CH4_EN` | `[3]` | RW | `0x0` | Channel 4 enable |

---
### `RF_GAIN_ANT1` — Address `0x0708`

**Reset value:** `0x00`  **Access:** see fields below

RF gain control for antenna 1

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `CH1_GAIN` | `[7:0]` | RW | `0x00` | Channel 1 gain (0-31) |
| `CH2_GAIN` | `[15:8]` | RW | `0x00` | Channel 2 gain (0-31) |

---
### `RF_GAIN_ANT2` — Address `0x0709`

**Reset value:** `0x00`  **Access:** see fields below

RF gain control for antenna 2

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `CH1_GAIN` | `[7:0]` | RW | `0x00` | Channel 1 gain (0-31) |
| `CH2_GAIN` | `[15:8]` | RW | `0x00` | Channel 2 gain (0-31) |

---
### `RF_MODE` — Address `0x070F`

**Reset value:** `0x00`  **Access:** see fields below

RF operating mode

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MODE` | `[1:0]` | RW | `0x0` | RF mode (0=normal, 1=test, 2=bypass) |
| `AGC_EN` | `[2]` | RW | `0x0` | AGC enable |
| `LN_EN` | `[3]` | RW | `0x0` | Limiter enable |

---
### `LIM_CTRL` — Address `0x0710`

**Reset value:** `0x00`  **Access:** see fields below

Limiter control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LIM_EN` | `[0]` | RW | `0x0` | Limiter enable |
| `LIM_THRESH` | `[7:1]` | RW | `0x0F` | Limiter threshold |

---
### `BPF_CTRL` — Address `0x0718`

**Reset value:** `0x00`  **Access:** see fields below

Band-pass filter control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BPF_EN` | `[0]` | RW | `0x0` | BPF enable |
| `CENTER_FREQ` | `[11:1]` | RW | `0x04C2` | Center frequency (Hz) |

---
### `WDT_CTRL` — Address `0x0800`

**Reset value:** `0x00`  **Access:** see fields below

Watchdog timer control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `WDT_EN` | `[0]` | RW | `0x0` | Watchdog enable |
| `WDT_RST` | `[1]` | RW | `0x0` | Watchdog reset |
| `WDT_TIMEOUT` | `[15:2]` | RW | `0x1F40` | Timeout period |

---
### `WDT_STATUS` — Address `0x0801`

**Reset value:** `0x00`  **Access:** see fields below

Watchdog timer status

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `WDT_EXPIRED` | `[0]` | RC | `0x0` | Watchdog expired |
| `WDT_COUNT` | `[15:1]` | RO | `0x0000` | Remaining count |

---
### `GPIO_DIR` — Address `0x0808`

**Reset value:** `0x00`  **Access:** see fields below

GPIO direction control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GPIO_DIR` | `[7:0]` | RW | `0x00` | GPIO direction (0=input, 1=output) |

---
### `GPIO_OUT` — Address `0x0809`

**Reset value:** `0x00`  **Access:** see fields below

GPIO output values

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GPIO_OUT` | `[7:0]` | RW | `0x00` | GPIO output values |

---
### `GPIO_IN` — Address `0x080A`

**Reset value:** `0x00`  **Access:** see fields below

GPIO input values

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GPIO_IN` | `[7:0]` | RO | `0x00` | GPIO input values |

---
### `DAC_CTRL` — Address `0x0900`

**Reset value:** `0x00`  **Access:** see fields below

DAC control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DAC_EN` | `[0]` | RW | `0x0` | DAC enable |
| `DAC_SEL` | `[1]` | RW | `0x0` | DAC output select |
| `DAC_RANGE` | `[7:2]` | RW | `0x10` | DAC range select |

---
### `DAC_DATA` — Address `0x0901`

**Reset value:** `0x0000`  **Access:** see fields below

DAC output data

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DAC_DATA` | `[15:0]` | RW | `0x0000` | DAC output data |

---
### `GPOUT_EN` — Address `0x0908`

**Reset value:** `0x00`  **Access:** see fields below

General purpose output enables

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GPO_EN` | `[7:0]` | RW | `0x00` | General purpose output enable |

---
### `GPOUT_VAL` — Address `0x0909`

**Reset value:** `0x00`  **Access:** see fields below

General purpose output values

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GPO_VAL` | `[7:0]` | RW | `0x00` | General purpose output values |
