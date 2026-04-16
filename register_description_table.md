# Register Description Table (RDT)
## sdfjbks

> **Total registers:** 55

sdfjbks Wideband RF Receiver (5-18 GHz) - Complete register map comprising 28 registers across 10 functional groups (0x000-0x900), covering board ID, communication (UART/ETH), ADC supply monitoring, temperature/health, PLL/clock (ADF5356, LMK04828), RF phase/VGA control (HMC698LP4, HMC6180LP4), JESD204B link monitoring, EEPROM/Flash NV storage, GPIO, and DAC output control.

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
| `0x0000` | `BOARD_ID` | — | `0x5F6A` | Board identification code - uniquely identifies the sdfjbks Wideband RF Receiver module |
| `0x0001` | `BOARD_VERSION` | — | `0x0100` | Hardware version number - major and minor revision |
| `0x0002` | `BOARD_TYPE_ID` | — | `0x5246` | Board type identifier for system compatibility check |
| `0x0003` | `SCRATCHPAD` | — | `0x0000` | Read/write test register for RAM and bus integrity verification |
| `0x0010` | `MCS_VERSION_MAJOR` | — | `0x0001` | FPGA firmware major version number |
| `0x0011` | `MCS_VERSION_MINOR` | — | `0x0000` | FPGA firmware minor version number |
| `0x0012` | `BUILD_DATE` | — | `0x2616` | Firmware build date in packed BCD format (YYYYMMDD) |
| `0x0100` | `UART_BAUD_DIV` | — | `0x0034` | UART baud rate divisor for host communication |
| `0x0101` | `UART_CTRL` | — | `0x0000` | UART control register |
| `0x0102` | `UART_STATUS` | — | `0x0000` | UART status flags (read-clear) |
| `0x0103` | `UART_TX_COUNT` | — | `0x0000` | TX FIFO byte count |
| `0x0104` | `UART_RX_COUNT` | — | `0x0000` | RX FIFO byte count |
| `0x0110` | `ETH_MAC_LOW` | — | `0x0000` | Ethernet MAC address lower 16 bits |
| `0x0111` | `ETH_MAC_HIGH` | — | `0x0000` | Ethernet MAC address upper 16 bits (octets 5-4) |
| `0x0200` | `ADC_CTRL` | — | `0x0000` | ADC control register for supply monitoring |
| `0x0201` | `ADC_STATUS` | — | `0x0000` | ADC status flags |
| `0x0210` | `VCC_5V_RAW` | — | `0x0000` | 5V rail ADC raw count (12-bit) |
| `0x0211` | `VCC_3V3_RAW` | — | `0x0000` | 3.3V rail ADC raw count (12-bit) |
| `0x0212` | `VCC_2V5_RAW` | — | `0x0000` | 2.5V rail ADC raw count (12-bit) |
| `0x0213` | `VCC_1V8_RAW` | — | `0x0000` | 1.8V rail ADC raw count (12-bit) |
| `0x0218` | `ICC_5V_RAW` | — | `0x0000` | 5V rail current sense ADC count |
| `0x0219` | `ICC_3V3_RAW` | — | `0x0000` | 3.3V rail current sense ADC count |
| `0x0300` | `TEMP_LOCAL` | — | `0x0140` | Local FPGA die temperature |
| `0x0301` | `TEMP_REMOTE1` | — | `0x0140` | Remote sensor 1 temperature (LNA region) |
| `0x0302` | `TEMP_REMOTE2` | — | `0x0140` | Remote sensor 2 temperature (PLL region) |
| `0x0308` | `TEMP_ALERT_HIGH` | — | `0x0190` | Over-temperature alert threshold |
| `0x0309` | `TEMP_ALERT_LOW` | — | `0xFF9C` | Under-temperature alert threshold |
| `0x030F` | `HEALTH_STATUS` | — | `0x0003` | System health status register |
| `0x0400` | `PLL_CTRL` | — | `0x0002` | ADF5356 PLL control register |
| `0x0401` | `PLL_STATUS` | — | `0x0000` | ADF5356 PLL status register |
| `0x0402` | `PLL_N_DIV` | — | `0x0064` | ADF5356 N divider value |
| `0x0403` | `PLL_R_DIV` | — | `0x0001` | ADF5356 R divider value |
| `0x0410` | `CLK_ENABLE` | — | `0x0000` | Clock output enable mask |
| `0x0500` | `EEPROM_CTRL` | — | `0x0000` | AT24C64C EEPROM control register |
| `0x0501` | `EEPROM_ADDR` | — | `0x0000` | EEPROM byte address (0-8191 for 64Kb) |
| `0x0502` | `EEPROM_DATA` | — | `0x0000` | EEPROM read/write data register |
| `0x0600` | `FLASH_CTRL` | — | `0x0000` | Configuration Flash control register |
| `0x0601` | `FLASH_ADDR_LOW` | — | `0x0000` | Flash address low word |
| `0x0602` | `FLASH_ADDR_HIGH` | — | `0x0000` | Flash address high byte |
| `0x0603` | `FLASH_DATA` | — | `0x0000` | Flash data FIFO register |
| `0x0604` | `FLASH_STATUS` | — | `0x0001` | Flash operation status |
| `0x0700` | `RF_PHASE_CTRL` | — | `0x8000` | RF phase/IQ imbalance correction control |
| `0x0701` | `VGA_GAIN_CTRL` | — | `0x000F` | HMC698LP4 Digital VGA gain control |
| `0x0702` | `LNA_ENABLE` | — | `0x0000` | HMC6180LP4E LNA enable control |
| `0x0703` | `MIXER_CTRL` | — | `0x0014` | HMC1051LP4E IQ mixer control |
| `0x0708` | `ADC12DJ_CONFIG` | — | `0x0013` | ADC12DJ5200RF JESD204B configuration |
| `0x0709` | `JESD_STATUS` | — | `0x0002` | JESD204B link status monitoring |
| `0x070A` | `LMK_CONFIG` | — | `0x0018` | LMK04828 clock generator configuration |
| `0x0800` | `GPIO_DATA` | — | `0x0000` | GPIO data register |
| `0x0801` | `GPIO_DIR` | — | `0x00FF` | GPIO direction control (0=output, 1=input) |
| `0x0802` | `GPIO_INT_EN` | — | `0x0000` | GPIO interrupt enable |
| `0x0803` | `GPIO_INT_STATUS` | — | `0x0000` | GPIO interrupt status (read-clear) |
| `0x0900` | `DAC_CTRL` | — | `0x0000` | DAC control register |
| `0x0901` | `DAC_DATA_CH0` | — | `0x8000` | DAC channel 0 data |
| `0x0902` | `DAC_DATA_CH1` | — | `0x8000` | DAC channel 1 data |

---
### `BOARD_ID` — Address `0x0000`

**Reset value:** `0x5F6A`  **Access:** see fields below

Board identification code - uniquely identifies the sdfjbks Wideband RF Receiver module

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BOARD_ID` | `[15:0]` | R | `0x5F6A` | Board identification code (0x5F6A = 'sdfjbks' signature) |

---
### `BOARD_VERSION` — Address `0x0001`

**Reset value:** `0x0100`  **Access:** see fields below

Hardware version number - major and minor revision

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAJOR` | `[7:4]` | R | `0x01` | Major hardware version (BCD) |
| `MINOR` | `[3:0]` | R | `0x00` | Minor hardware version (BCD) |
| `RSVD` | `[15:8]` | R | `0x00` | Reserved, read as 0x00 |

---
### `BOARD_TYPE_ID` — Address `0x0002`

**Reset value:** `0x5246`  **Access:** see fields below

Board type identifier for system compatibility check

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TYPE_ID` | `[15:0]` | R | `0x5246` | Board type: 0x5246 = 'RF' wideband receiver type |

---
### `SCRATCHPAD` — Address `0x0003`

**Reset value:** `0x0000`  **Access:** see fields below

Read/write test register for RAM and bus integrity verification

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEST_DATA` | `[15:0]` | RW | `0x0000` | Test pattern - write/read verification |

---
### `MCS_VERSION_MAJOR` — Address `0x0010`

**Reset value:** `0x0001`  **Access:** see fields below

FPGA firmware major version number

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAJOR_VER` | `[7:0]` | R | `0x01` | Major version (0x01 = v1.x) |
| `RSVD` | `[15:8]` | R | `0x00` | Reserved |

---
### `MCS_VERSION_MINOR` — Address `0x0011`

**Reset value:** `0x0000`  **Access:** see fields below

FPGA firmware minor version number

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MINOR_VER` | `[7:0]` | R | `0x00` | Minor version (0x00 = v1.0) |
| `RSVD` | `[15:8]` | R | `0x00` | Reserved |

---
### `BUILD_DATE` — Address `0x0012`

**Reset value:** `0x2616`  **Access:** see fields below

Firmware build date in packed BCD format (YYYYMMDD)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `YEAR` | `[15:12]` | R | `0x0026` | Build year (BCD, e.g., 0x2 = 2026) |
| `MONTH` | `[11:8]` | R | `0x0004` | Build month (BCD) |
| `DAY` | `[7:0]` | R | `0x0016` | Build day (BCD) |

---
### `UART_BAUD_DIV` — Address `0x0100`

**Reset value:** `0x0034`  **Access:** see fields below

UART baud rate divisor for host communication

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DIVISOR` | `[15:0]` | RW | `0x0034` | Baud divisor = CLK_FREQ/(16*BAUD). Default: 0x0034 for 115200 @ 100MHz |

---
### `UART_CTRL` — Address `0x0101`

**Reset value:** `0x0000`  **Access:** see fields below

UART control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0x0` | UART enable (1=enabled) |
| `LOOPBACK` | `[1]` | RW | `0x0` | Loopback mode for test |
| `FRAME_FMT` | `[7:4]` | RW | `0x0` | Frame format (0=8N1) |
| `RSVD` | `[15:8]` | R | `0x00` | Reserved |

---
### `UART_STATUS` — Address `0x0102`

**Reset value:** `0x0000`  **Access:** see fields below

UART status flags (read-clear)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TX_BUSY` | `[0]` | R | `0x0` | Transmitter busy flag |
| `RX_AVAIL` | `[1]` | RC | `0x0` | Data available in RX FIFO |
| `FRAME_ERR` | `[2]` | RC | `0x0` | Frame error detected |
| `RSVD` | `[15:3]` | R | `0x00` | Reserved |

---
### `UART_TX_COUNT` — Address `0x0103`

**Reset value:** `0x0000`  **Access:** see fields below

TX FIFO byte count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `COUNT` | `[7:0]` | R | `0x00` | Number of bytes in TX FIFO |
| `RSVD` | `[15:8]` | R | `0x00` | Reserved |

---
### `UART_RX_COUNT` — Address `0x0104`

**Reset value:** `0x0000`  **Access:** see fields below

RX FIFO byte count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `COUNT` | `[7:0]` | R | `0x00` | Number of bytes in RX FIFO |
| `RSVD` | `[15:8]` | R | `0x00` | Reserved |

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

Ethernet MAC address upper 16 bits (octets 5-4)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAC_HIGH` | `[15:0]` | R | `0x0000` | MAC address [31:16] |

---
### `ADC_CTRL` — Address `0x0200`

**Reset value:** `0x0000`  **Access:** see fields below

ADC control register for supply monitoring

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `START` | `[0]` | RW | `0x0` | Start ADC conversion (self-clearing) |
| `CONTINUOUS` | `[1]` | RW | `0x0` | Continuous mode enable |
| `CH_SEL` | `[3:2]` | RW | `0x0` | Channel select: 00=5V, 01=3.3V, 10=2.5V, 11=1.8V |
| `RSVD` | `[15:4]` | R | `0x00` | Reserved |

---
### `ADC_STATUS` — Address `0x0201`

**Reset value:** `0x0000`  **Access:** see fields below

ADC status flags

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA_READY` | `[0]` | R | `0x0` | New data available |
| `OVERRANGE` | `[1]` | RC | `0x0` | ADC overrange error |
| `RSVD` | `[15:2]` | R | `0x00` | Reserved |

---
### `VCC_5V_RAW` — Address `0x0210`

**Reset value:** `0x0000`  **Access:** see fields below

5V rail ADC raw count (12-bit)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_5V` | `[11:0]` | R | `0x0000` | 5V rail ADC count (multiply by 5.0/4096 for Volts) |
| `RSVD` | `[15:12]` | R | `0x0` | Reserved |

---
### `VCC_3V3_RAW` — Address `0x0211`

**Reset value:** `0x0000`  **Access:** see fields below

3.3V rail ADC raw count (12-bit)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_3V3` | `[11:0]` | R | `0x0000` | 3.3V rail ADC count (multiply by 3.3/4096) |
| `RSVD` | `[15:12]` | R | `0x0` | Reserved |

---
### `VCC_2V5_RAW` — Address `0x0212`

**Reset value:** `0x0000`  **Access:** see fields below

2.5V rail ADC raw count (12-bit)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_2V5` | `[11:0]` | R | `0x0000` | 2.5V rail ADC count (multiply by 2.5/4096) |
| `RSVD` | `[15:12]` | R | `0x0` | Reserved |

---
### `VCC_1V8_RAW` — Address `0x0213`

**Reset value:** `0x0000`  **Access:** see fields below

1.8V rail ADC raw count (12-bit)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_1V8` | `[11:0]` | R | `0x0000` | 1.8V rail ADC count (multiply by 1.8/4096) |
| `RSVD` | `[15:12]` | R | `0x0` | Reserved |

---
### `ICC_5V_RAW` — Address `0x0218`

**Reset value:** `0x0000`  **Access:** see fields below

5V rail current sense ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ICC_5V` | `[11:0]` | R | `0x0000` | 5V rail current ADC count |
| `RSVD` | `[15:12]` | R | `0x0` | Reserved |

---
### `ICC_3V3_RAW` — Address `0x0219`

**Reset value:** `0x0000`  **Access:** see fields below

3.3V rail current sense ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ICC_3V3` | `[11:0]` | R | `0x0000` | 3.3V rail current ADC count |
| `RSVD` | `[15:12]` | R | `0x0` | Reserved |

---
### `TEMP_LOCAL` — Address `0x0300`

**Reset value:** `0x0140`  **Access:** see fields below

Local FPGA die temperature

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP` | `[9:0]` | R | `0x0140` | Temperature in 0.25°C units (signed, 10-bit two's complement) |
| `RSVD` | `[15:10]` | R | `0x00` | Reserved |

---
### `TEMP_REMOTE1` — Address `0x0301`

**Reset value:** `0x0140`  **Access:** see fields below

Remote sensor 1 temperature (LNA region)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP1` | `[9:0]` | R | `0x0140` | Remote sensor 1 temperature (signed, 0.25°C units) |
| `RSVD` | `[15:10]` | R | `0x00` | Reserved |

---
### `TEMP_REMOTE2` — Address `0x0302`

**Reset value:** `0x0140`  **Access:** see fields below

Remote sensor 2 temperature (PLL region)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP2` | `[9:0]` | R | `0x0140` | Remote sensor 2 temperature (signed, 0.25°C units) |
| `RSVD` | `[15:10]` | R | `0x00` | Reserved |

---
### `TEMP_ALERT_HIGH` — Address `0x0308`

**Reset value:** `0x0190`  **Access:** see fields below

Over-temperature alert threshold

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `HIGH_THRESH` | `[9:0]` | RW | `0x0190` | Alert threshold in 0.25°C units (0x190 = 100°C) |
| `RSVD` | `[15:10]` | R | `0x00` | Reserved |

---
### `TEMP_ALERT_LOW` — Address `0x0309`

**Reset value:** `0xFF9C`  **Access:** see fields below

Under-temperature alert threshold

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LOW_THRESH` | `[9:0]` | RW | `0xFF9C` | Low threshold in 0.25°C units (0xFF9C = -25°C) |
| `RSVD` | `[15:10]` | R | `0x00` | Reserved |

---
### `HEALTH_STATUS` — Address `0x030F`

**Reset value:** `0x0003`  **Access:** see fields below

System health status register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_OK` | `[0]` | R | `0x1` | Temperature within limits (1=OK) |
| `VOLT_OK` | `[1]` | R | `0x1` | All power rails within tolerance (1=OK) |
| `PLL_LOCK` | `[2]` | R | `0x0` | PLL lock status (1=locked) |
| `JESD_LINK` | `[3]` | R | `0x0` | JESD204B link status (1=aligned) |
| `SYSTEM_OK` | `[7]` | R | `0x0` | Overall system health (all checks pass) |
| `RSVD` | `[15:8]` | R | `0x00` | Reserved |

---
### `PLL_CTRL` — Address `0x0400`

**Reset value:** `0x0002`  **Access:** see fields below

ADF5356 PLL control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0x0` | Enable PLL output (1=enabled) |
| `RESET_N` | `[1]` | RW | `0x0` | PLL reset (active low, 0=reset) |
| `REF_SEL` | `[3:2]` | RW | `0x0` | Reference clock select: 00=10MHz XTAL, 01=EXT CLK, 10=LMK out |
| `RSVD` | `[15:4]` | R | `0x00` | Reserved |

---
### `PLL_STATUS` — Address `0x0401`

**Reset value:** `0x0000`  **Access:** see fields below

ADF5356 PLL status register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LOCKED` | `[0]` | R | `0x0` | PLL locked (1=lock detected) |
| `LOSS_OF_LOCK` | `[1]` | RC | `0x0` | Lock loss event (read-clear) |
| `MUXOUT` | `[3:2]` | R | `0x0` | PLL MUXOUT status (NDIV, RDIV, etc.) |
| `RSVD` | `[15:4]` | R | `0x00` | Reserved |

---
### `PLL_N_DIV` — Address `0x0402`

**Reset value:** `0x0064`  **Access:** see fields below

ADF5356 N divider value

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `N_DIV` | `[15:0]` | RW | `0x0064` | Integer N divider value (determines LO frequency) |

---
### `PLL_R_DIV` — Address `0x0403`

**Reset value:** `0x0001`  **Access:** see fields below

ADF5356 R divider value

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `R_DIV` | `[7:0]` | RW | `0x0001` | R reference divider value |
| `RSVD` | `[15:8]` | R | `0x00` | Reserved |

---
### `CLK_ENABLE` — Address `0x0410`

**Reset value:** `0x0000`  **Access:** see fields below

Clock output enable mask

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `CLK_ADC_EN` | `[0]` | RW | `0x0` | Enable ADC sampling clock |
| `CLK_FPGA_EN` | `[1]` | RW | `0x0` | Enable FPGA reference clock |
| `CLK_SYSREF_EN` | `[2]` | RW | `0x0` | Enable SYSREF for JESD204B Subclass 1 |
| `CLK_PLL_EN` | `[3]` | RW | `0x0` | Enable PLL reference clock output |
| `RSVD` | `[15:4]` | R | `0x00` | Reserved |

---
### `EEPROM_CTRL` — Address `0x0500`

**Reset value:** `0x0000`  **Access:** see fields below

AT24C64C EEPROM control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READ` | `[0]` | RW | `0x0` | Initiate read (self-clearing) |
| `WRITE` | `[1]` | RW | `0x0` | Initiate write (self-clearing) |
| `ERASE` | `[2]` | RW | `0x0` | Initiate page erase (self-clearing) |
| `BUSY` | `[7]` | R | `0x0` | EEPROM operation in progress |
| `RSVD` | `[15:8]` | R | `0x00` | Reserved |

---
### `EEPROM_ADDR` — Address `0x0501`

**Reset value:** `0x0000`  **Access:** see fields below

EEPROM byte address (0-8191 for 64Kb)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADDR` | `[15:0]` | RW | `0x0000` | Byte address within EEPROM |

---
### `EEPROM_DATA` — Address `0x0502`

**Reset value:** `0x0000`  **Access:** see fields below

EEPROM read/write data register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA` | `[15:0]` | RW | `0x0000` | 16-bit data word (stored as two bytes) |

---
### `FLASH_CTRL` — Address `0x0600`

**Reset value:** `0x0000`  **Access:** see fields below

Configuration Flash control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READ` | `[0]` | RW | `0x0` | Flash read command |
| `WRITE` | `[1]` | RW | `0x0` | Flash write command |
| `ERASE_SECTOR` | `[2]` | RW | `0x0` | Erase flash sector |
| `ERASE_CHIP` | `[3]` | RW | `0x0` | Erase entire chip (requires unlock) |
| `BUSY` | `[7]` | R | `0x0` | Flash operation busy flag |
| `RSVD` | `[15:8]` | R | `0x00` | Reserved |

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
| `RSVD` | `[15:8]` | R | `0x00` | Reserved |

---
### `FLASH_DATA` — Address `0x0603`

**Reset value:** `0x0000`  **Access:** see fields below

Flash data FIFO register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA` | `[15:0]` | RW | `0x0000` | 16-bit data word for flash R/W |

---
### `FLASH_STATUS` — Address `0x0604`

**Reset value:** `0x0001`  **Access:** see fields below

Flash operation status

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READY` | `[0]` | R | `0x1` | Flash ready for commands |
| `WRITE_ERR` | `[1]` | RC | `0x0` | Write protection/error |
| `ERASE_ERR` | `[2]` | RC | `0x0` | Erase error |
| `RSVD` | `[15:3]` | R | `0x00` | Reserved |

---
### `RF_PHASE_CTRL` — Address `0x0700`

**Reset value:** `0x8000`  **Access:** see fields below

RF phase/IQ imbalance correction control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `PHASE_ADJ` | `[11:0]` | RW | `0x0000` | Phase adjustment value (0-4095) |
| `IQ_GAIN` | `[15:12]` | RW | `0x8` | IQ gain balance (4-bit) |

---
### `VGA_GAIN_CTRL` — Address `0x0701`

**Reset value:** `0x000F`  **Access:** see fields below

HMC698LP4 Digital VGA gain control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GAIN_CODE` | `[4:0]` | RW | `0x0F` | 5-bit gain code (0-31 = 0 to 31dB in 1dB steps) |
| `BYPASS` | `[5]` | RW | `0x0` | Bypass VGA (1=bypass, 0=normal) |
| `RSVD` | `[15:6]` | R | `0x00` | Reserved |

---
### `LNA_ENABLE` — Address `0x0702`

**Reset value:** `0x0000`  **Access:** see fields below

HMC6180LP4E LNA enable control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LNA_EN` | `[0]` | RW | `0x0` | Enable LNA (1=powered, 0=shutdown) |
| `BYPASS` | `[1]` | RW | `0x0` | LNA bypass mode |
| `RSVD` | `[15:2]` | R | `0x00` | Reserved |

---
### `MIXER_CTRL` — Address `0x0703`

**Reset value:** `0x0014`  **Access:** see fields below

HMC1051LP4E IQ mixer control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MIXER_EN` | `[0]` | RW | `0x0` | Enable mixer (1=powered) |
| `LO_DRIVE` | `[3:2]` | RW | `0x1` | LO drive level: 00=0dBm, 01=3dBm, 10=6dBm |
| `IF_BW` | `[6:4]` | RW | `0x4` | IF bandwidth select |
| `RSVD` | `[15:7]` | R | `0x00` | Reserved |

---
### `ADC12DJ_CONFIG` — Address `0x0708`

**Reset value:** `0x0013`  **Access:** see fields below

ADC12DJ5200RF JESD204B configuration

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `JESD_EN` | `[0]` | RW | `0x0` | Enable JESD204B link |
| `SUBCLASS` | `[2:1]` | RW | `0x1` | Subclass: 00=0, 01=1, 10=2 |
| `LANES` | `[5:3]` | RW | `0x1` | Number of lanes: 000=1, 001=2 |
| `SAMPLE_RATE` | `[9:8]` | RW | `0x1` | Sample rate: 00=3.2GSPS, 01=5.2GSPS |
| `RSVD` | `[15:10]` | R | `0x00` | Reserved |

---
### `JESD_STATUS` — Address `0x0709`

**Reset value:** `0x0002`  **Access:** see fields below

JESD204B link status monitoring

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LINK_READY` | `[0]` | R | `0x0` | JESD link ready (1=aligned) |
| `SYNC_N` | `[1]` | R | `0x1` | SYNC_N input state (0=sync asserted) |
| `SYSREF_DET` | `[2]` | R | `0x0` | SYSREF detected (Subclass 1) |
| `DISPERR` | `[3]` | RC | `0x0` | Disparity error detected |
| `RSVD` | `[15:4]` | R | `0x00` | Reserved |

---
### `LMK_CONFIG` — Address `0x070A`

**Reset value:** `0x0018`  **Access:** see fields below

LMK04828 clock generator configuration

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `SYSREF_EN` | `[0]` | RW | `0x0` | Enable SYSREF output |
| `CLKOUT_EN` | `[1]` | RW | `0x0` | Enable clock output to ADC |
| `SYSREP_RATE` | `[4:2]` | RW | `0x2` | SYSREF repetition rate (K divider) |
| `CLK_FREQ` | `[7:5]` | RW | `0x3` | Output clock frequency select |
| `RSVD` | `[15:8]` | R | `0x00` | Reserved |

---
### `GPIO_DATA` — Address `0x0800`

**Reset value:** `0x0000`  **Access:** see fields below

GPIO data register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GPIO_OUT` | `[7:0]` | RW | `0x00` | GPIO output data |
| `GPIO_IN` | `[15:8]` | R | `0x00` | GPIO input data (read-only) |

---
### `GPIO_DIR` — Address `0x0801`

**Reset value:** `0x00FF`  **Access:** see fields below

GPIO direction control (0=output, 1=input)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DIR` | `[7:0]` | RW | `0xFF` | Direction for each GPIO pin |
| `RSVD` | `[15:8]` | R | `0x00` | Reserved |

---
### `GPIO_INT_EN` — Address `0x0802`

**Reset value:** `0x0000`  **Access:** see fields below

GPIO interrupt enable

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `INT_EN` | `[7:0]` | RW | `0x00` | Enable interrupt per GPIO pin |
| `INT_TYPE` | `[15:8]` | RW | `0x00` | 0=level, 1=edge |

---
### `GPIO_INT_STATUS` — Address `0x0803`

**Reset value:** `0x0000`  **Access:** see fields below

GPIO interrupt status (read-clear)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `INT_PENDING` | `[7:0]` | RC | `0x00` | Interrupt pending flags |
| `RSVD` | `[15:8]` | R | `0x00` | Reserved |

---
### `DAC_CTRL` — Address `0x0900`

**Reset value:** `0x0000`  **Access:** see fields below

DAC control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DAC_EN` | `[0]` | RW | `0x0` | Enable DAC output |
| `DAC_SEL` | `[2:1]` | RW | `0x0` | DAC channel select |
| `RSVD` | `[15:3]` | R | `0x00` | Reserved |

---
### `DAC_DATA_CH0` — Address `0x0901`

**Reset value:** `0x8000`  **Access:** see fields below

DAC channel 0 data

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA` | `[15:0]` | RW | `0x8000` | 16-bit DAC output value |

---
### `DAC_DATA_CH1` — Address `0x0902`

**Reset value:** `0x8000`  **Access:** see fields below

DAC channel 1 data

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA` | `[15:0]` | RW | `0x8000` | 16-bit DAC output value |
