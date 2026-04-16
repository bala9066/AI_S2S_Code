# Register Description Table (RDT)
## Sample Ai Project

> **Total registers:** 54

Complete register map and initialization sequence for Sample Ai Project - a 5-18 GHz wideband RF receiver with 10 GSPS ADC, HMC7044 clock generator, HMC698LP4E DSA, and RT-Kintex-7-RT FPGA. Includes 39 registers across 9 functional groups (Board Info, Communication, ADC/Supply Monitoring, Temperature/Health, PLL/Clock, EEPROM, Flash, RF Control, GPIO) and 21-step programming sequence covering power-on self-check, clock initialization, peripheral configuration, and JESD204B link bring-up.

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
| `0x0000` | `BOARD_ID` | — | `0x0000` | Board identification code - 16-bit unique identifier for Sample Ai Project hardware |
| `0x0001` | `BOARD_VERSION` | — | `0x0000` | Hardware version number - major and minor revision |
| `0x0002` | `BOARD_TYPE_ID` | — | `0x0000` | Board type identifier |
| `0x0003` | `SCRATCHPAD` | — | `0x0000` | Read/write test register for RAM verification |
| `0x0010` | `MCS_VERSION_MAJOR` | — | `0x0000` | FPGA firmware major version number |
| `0x0011` | `MCS_VERSION_MINOR` | — | `0x0000` | FPGA firmware minor version number |
| `0x0012` | `BUILD_DATE` | — | `0x0000` | Firmware build date in packed BCD format (YYYYMMDD) |
| `0x0100` | `UART_BAUD_DIV` | — | `0x0000` | UART baud rate divisor for 100MHz reference clock |
| `0x0101` | `UART_CTRL` | — | `0x0000` | UART control register |
| `0x0102` | `UART_STATUS` | — | `0x0000` | UART status flags - read clears error bits |
| `0x0103` | `UART_TX_COUNT` | — | `0x0000` | TX FIFO byte count |
| `0x0104` | `UART_RX_COUNT` | — | `0x0000` | RX FIFO byte count |
| `0x0110` | `ETH_MAC_LOW` | — | `0x0000` | Ethernet MAC address lower 16 bits |
| `0x0111` | `ETH_MAC_HIGH` | — | `0x0000` | Ethernet MAC address upper 32 bits |
| `0x0200` | `ADC_CTRL` | — | `0x0000` | ADC control for ADC10D1000RF |
| `0x0201` | `ADC_STATUS` | — | `0x0000` | ADC status flags |
| `0x0210` | `VCC_5V_RAW` | — | `0x0000` | 5V rail ADC count (LT3045-5 output monitoring) |
| `0x0211` | `VCC_3V3_RAW` | — | `0x0000` | 3.3V rail ADC count (LT3045-3.3 output monitoring) |
| `0x0212` | `VCC_2V5_RAW` | — | `0x0000` | 2.5V rail ADC count (LT3045-2.5 output monitoring) |
| `0x0213` | `VCC_1V8_RAW` | — | `0x0000` | 1.8V rail ADC count (LT3045-1.8 output monitoring) |
| `0x0214` | `VCC_1V2_RAW` | — | `0x0000` | 1.2V rail ADC count (LT3040-1.2 output monitoring) |
| `0x0215` | `VCC_1V0_RAW` | — | `0x0000` | 1.0V rail ADC count (LT8631-1.0 output monitoring) |
| `0x0218` | `ICC_5V_RAW` | — | `0x0000` | 5V rail current ADC count |
| `0x0219` | `ICC_3V3_RAW` | — | `0x0000` | 3.3V rail current ADC count |
| `0x0300` | `TEMP_LOCAL` | — | `0x0000` | Local FPGA die temperature in 0.25°C units (signed) |
| `0x0301` | `TEMP_REMOTE1` | — | `0x0000` | Remote sensor 1 temperature (RF front-end area) |
| `0x0302` | `TEMP_REMOTE2` | — | `0x0000` | Remote sensor 2 temperature (ADC area) |
| `0x0308` | `TEMP_ALERT_HIGH` | — | `0x0000` | Over-temperature alert threshold |
| `0x0309` | `TEMP_ALERT_LOW` | — | `0x0000` | Under-temperature alert threshold (signed) |
| `0x030F` | `HEALTH_STATUS` | — | `0x0000` | System health status summary |
| `0x0400` | `PLL_CTRL` | — | `0x0000` | HMC7044 clock generator control |
| `0x0401` | `PLL_STATUS` | — | `0x0000` | PLL status flags |
| `0x0402` | `PLL_N_DIV` | — | `0x0000` | PLL N divider value (for HMC7044 configuration) |
| `0x0403` | `PLL_R_DIV` | — | `0x0000` | PLL R divider value |
| `0x0410` | `CLK_ENABLE` | — | `0x0000` | Clock output enables |
| `0x0500` | `EEPROM_CTRL` | — | `0x0000` | EEPROM control register |
| `0x0501` | `EEPROM_ADDR` | — | `0x0000` | EEPROM byte address |
| `0x0502` | `EEPROM_DATA` | — | `0x0000` | EEPROM read/write data |
| `0x0600` | `FLASH_CTRL` | — | `0x0000` | Configuration flash control register |
| `0x0601` | `FLASH_ADDR_LOW` | — | `0x0000` | Flash address low word |
| `0x0602` | `FLASH_ADDR_HIGH` | — | `0x0000` | Flash address high byte |
| `0x0603` | `FLASH_DATA` | — | `0x0000` | Flash data FIFO |
| `0x0604` | `FLASH_STATUS` | — | `0x0000` | Flash status flags |
| `0x0700` | `RF_DSA_GAIN` | — | `0x0000` | HMC698LP4E Digital Step Attenuator gain control (6-bit, 0.25dB steps) |
| `0x0701` | `RF_LNA_ENABLE` | — | `0x0000` | TGA4943-SL LNA enable control |
| `0x0702` | `RF_AGC_CTRL` | — | `0x0000` | Automatic Gain Control parameters |
| `0x0703` | `RF_STATUS` | — | `0x0000` | RF front-end status monitoring |
| `0x0710` | `JESD204B_CTRL` | — | `0x0000` | JESD204B interface control (Subclass 1 for ADC10D1000RF) |
| `0x0711` | `JESD204B_STATUS` | — | `0x0000` | JESD204B link status |
| `0x0800` | `GPIO_DIR` | — | `0x0000` | GPIO direction control (0=input, 1=output) |
| `0x0801` | `GPIO_DATA_OUT` | — | `0x0000` | GPIO output data |
| `0x0802` | `GPIO_DATA_IN` | — | `0x0000` | GPIO input data |
| `0x0803` | `GPIO_INT_EN` | — | `0x0000` | GPIO interrupt enable |
| `0x0804` | `GPIO_INT_STATUS` | — | `0x0000` | GPIO interrupt status (read-clear) |

---
### `BOARD_ID` — Address `0x0000`

**Reset value:** `0x0000`  **Access:** see fields below

Board identification code - 16-bit unique identifier for Sample Ai Project hardware

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BOARD_ID` | `[15:0]` | RO | `0xA10C` | Board identification value 0xA10C |

---
### `BOARD_VERSION` — Address `0x0001`

**Reset value:** `0x0000`  **Access:** see fields below

Hardware version number - major and minor revision

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAJOR_REV` | `[7:4]` | RO | `0x0` | Major hardware revision (0-15) |
| `MINOR_REV` | `[3:0]` | RO | `0x1` | Minor hardware revision (0-15) |

---
### `BOARD_TYPE_ID` — Address `0x0002`

**Reset value:** `0x0000`  **Access:** see fields below

Board type identifier

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TYPE_ID` | `[15:0]` | RO | `0x5246` | Board type ID 0x5246 (RF Receiver) |

---
### `SCRATCHPAD` — Address `0x0003`

**Reset value:** `0x0000`  **Access:** see fields below

Read/write test register for RAM verification

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEST_PATTERN` | `[15:0]` | RW | `0x0000` | Test pattern for memory verification |

---
### `MCS_VERSION_MAJOR` — Address `0x0010`

**Reset value:** `0x0000`  **Access:** see fields below

FPGA firmware major version number

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAJOR_VER` | `[7:0]` | RO | `0x01` | Firmware major version |

---
### `MCS_VERSION_MINOR` — Address `0x0011`

**Reset value:** `0x0000`  **Access:** see fields below

FPGA firmware minor version number

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MINOR_VER` | `[7:0]` | RO | `0x05` | Firmware minor version |

---
### `BUILD_DATE` — Address `0x0012`

**Reset value:** `0x0000`  **Access:** see fields below

Firmware build date in packed BCD format (YYYYMMDD)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `YEAR_BCD` | `[15:12]` | RO | `0x2` | Year tens digit (20xx) |
| `DATE_BCD` | `[11:0]` | RO | `0x626` | Month/Day in BCD |

---
### `UART_BAUD_DIV` — Address `0x0100`

**Reset value:** `0x0000`  **Access:** see fields below

UART baud rate divisor for 100MHz reference clock

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DIVISOR` | `[15:0]` | RW | `0x002D` | Baud divisor (45 for 115200 baud @ 100MHz) |

---
### `UART_CTRL` — Address `0x0101`

**Reset value:** `0x0000`  **Access:** see fields below

UART control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0x0` | UART enable (1=enabled) |
| `LOOPBACK` | `[1]` | RW | `0x0` | Loopback mode for testing |
| `FRAME_FORMAT` | `[7:4]` | RW | `0x3` | Frame format (3=8N1) |

---
### `UART_STATUS` — Address `0x0102`

**Reset value:** `0x0000`  **Access:** see fields below

UART status flags - read clears error bits

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TX_BUSY` | `[0]` | R | `0x0` | Transmitter busy flag |
| `RX_AVAIL` | `[1]` | R | `0x0` | Data available in RX FIFO |
| `FRAME_ERR` | `[2]` | RC | `0x0` | Frame error flag (read-clear) |
| `OVERRUN_ERR` | `[3]` | RC | `0x0` | Overrun error flag (read-clear) |

---
### `UART_TX_COUNT` — Address `0x0103`

**Reset value:** `0x0000`  **Access:** see fields below

TX FIFO byte count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TX_COUNT` | `[7:0]` | RO | `0x00` | Number of bytes in TX FIFO |

---
### `UART_RX_COUNT` — Address `0x0104`

**Reset value:** `0x0000`  **Access:** see fields below

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
| `MAC_LOW` | `[15:0]` | RO | `0x0A10` | MAC address bytes 4-5 |

---
### `ETH_MAC_HIGH` — Address `0x0111`

**Reset value:** `0x0000`  **Access:** see fields below

Ethernet MAC address upper 32 bits

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAC_HIGH` | `[15:0]` | RO | `0x0000` | MAC address bytes 0-3 (partial) |

---
### `ADC_CTRL` — Address `0x0200`

**Reset value:** `0x0000`  **Access:** see fields below

ADC control for ADC10D1000RF

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `START` | `[0]` | RW | `0x0` | Start ADC conversion |
| `CONTINUOUS` | `[1]` | RW | `0x0` | Continuous sampling mode |
| `CHANNEL_SEL` | `[3:2]` | RW | `0x0` | Channel select (00=CH-I, 01=CH-Q) |
| `JESD204B_EN` | `[4]` | RW | `0x0` | Enable JESD204B interface |

---
### `ADC_STATUS` — Address `0x0201`

**Reset value:** `0x0000`  **Access:** see fields below

ADC status flags

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA_READY` | `[0]` | R | `0x0` | ADC data ready flag |
| `OVERRANGE` | `[1]` | RC | `0x0` | ADC input overrange flag |
| `JESD204B_ALIGN` | `[2]` | R | `0x0` | JESD204B lane aligned |

---
### `VCC_5V_RAW` — Address `0x0210`

**Reset value:** `0x0000`  **Access:** see fields below

5V rail ADC count (LT3045-5 output monitoring)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | RO | `0x0CCD` | 12-bit ADC count (multiply by 5.0/4096 for Volts) |
| `RESERVED` | `[15:12]` | RO | `0x0` | Reserved bits |

---
### `VCC_3V3_RAW` — Address `0x0211`

**Reset value:** `0x0000`  **Access:** see fields below

3.3V rail ADC count (LT3045-3.3 output monitoring)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | RO | `0x089B` | 12-bit ADC count (multiply by 3.3/4096 for Volts) |
| `RESERVED` | `[15:12]` | RO | `0x0` | Reserved bits |

---
### `VCC_2V5_RAW` — Address `0x0212`

**Reset value:** `0x0000`  **Access:** see fields below

2.5V rail ADC count (LT3045-2.5 output monitoring)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | RO | `0x0666` | 12-bit ADC count (multiply by 2.5/4096 for Volts) |
| `RESERVED` | `[15:12]` | RO | `0x0` | Reserved bits |

---
### `VCC_1V8_RAW` — Address `0x0213`

**Reset value:** `0x0000`  **Access:** see fields below

1.8V rail ADC count (LT3045-1.8 output monitoring)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | RO | `0x0480` | 12-bit ADC count (multiply by 1.8/4096 for Volts) |
| `RESERVED` | `[15:12]` | RO | `0x0` | Reserved bits |

---
### `VCC_1V2_RAW` — Address `0x0214`

**Reset value:** `0x0000`  **Access:** see fields below

1.2V rail ADC count (LT3040-1.2 output monitoring)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | RO | `0x0300` | 12-bit ADC count (multiply by 1.2/4096 for Volts) |
| `RESERVED` | `[15:12]` | RO | `0x0` | Reserved bits |

---
### `VCC_1V0_RAW` — Address `0x0215`

**Reset value:** `0x0000`  **Access:** see fields below

1.0V rail ADC count (LT8631-1.0 output monitoring)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | RO | `0x0280` | 12-bit ADC count (multiply by 1.0/4096 for Volts) |
| `RESERVED` | `[15:12]` | RO | `0x0` | Reserved bits |

---
### `ICC_5V_RAW` — Address `0x0218`

**Reset value:** `0x0000`  **Access:** see fields below

5V rail current ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | RO | `0x0000` | 12-bit ADC current count |
| `RESERVED` | `[15:12]` | RO | `0x0` | Reserved bits |

---
### `ICC_3V3_RAW` — Address `0x0219`

**Reset value:** `0x0000`  **Access:** see fields below

3.3V rail current ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | RO | `0x0000` | 12-bit ADC current count |
| `RESERVED` | `[15:12]` | RO | `0x0` | Reserved bits |

---
### `TEMP_LOCAL` — Address `0x0300`

**Reset value:** `0x0000`  **Access:** see fields below

Local FPGA die temperature in 0.25°C units (signed)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_VALUE` | `[9:0]` | RO | `0x140` | Temperature in 0.25°C units (0x140 = +80°C) |
| `SIGN_BIT` | `[9]` | RO | `0x0` | Sign bit (0=positive, 1=negative) |
| `RESERVED` | `[15:10]` | RO | `0x0` | Reserved bits |

---
### `TEMP_REMOTE1` — Address `0x0301`

**Reset value:** `0x0000`  **Access:** see fields below

Remote sensor 1 temperature (RF front-end area)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_VALUE` | `[9:0]` | RO | `0x10C` | Temperature in 0.25°C units (0x10C = +67°C) |
| `RESERVED` | `[15:10]` | RO | `0x0` | Reserved bits |

---
### `TEMP_REMOTE2` — Address `0x0302`

**Reset value:** `0x0000`  **Access:** see fields below

Remote sensor 2 temperature (ADC area)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_VALUE` | `[9:0]` | RO | `0x118` | Temperature in 0.25°C units (0x118 = +70°C) |
| `RESERVED` | `[15:10]` | RO | `0x0` | Reserved bits |

---
### `TEMP_ALERT_HIGH` — Address `0x0308`

**Reset value:** `0x0000`  **Access:** see fields below

Over-temperature alert threshold

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ALERT_THRESH` | `[9:0]` | RW | `0x0190` | Alert threshold in 0.25°C units (0x0190 = 100°C) |
| `RESERVED` | `[15:10]` | RO | `0x0` | Reserved bits |

---
### `TEMP_ALERT_LOW` — Address `0x0309`

**Reset value:** `0x0000`  **Access:** see fields below

Under-temperature alert threshold (signed)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ALERT_THRESH` | `[9:0]` | RW | `0xFF9C` | Alert threshold (0xFF9C = -25°C in two's complement) |
| `RESERVED` | `[15:10]` | RO | `0x0` | Reserved bits |

---
### `HEALTH_STATUS` — Address `0x030F`

**Reset value:** `0x0000`  **Access:** see fields below

System health status summary

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_OK` | `[0]` | RO | `0x0` | Temperature OK flag |
| `VOLT_OK` | `[1]` | RO | `0x0` | Power rails OK flag |
| `PLL_LOCK` | `[2]` | RO | `0x0` | PLL lock status flag |
| `JESD204B_OK` | `[3]` | RO | `0x0` | JESD204B link OK flag |
| `SYSTEM_OK` | `[7]` | RO | `0x0` | Overall system OK flag |

---
### `PLL_CTRL` — Address `0x0400`

**Reset value:** `0x0000`  **Access:** see fields below

HMC7044 clock generator control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0x0` | Enable HMC7044 PLL |
| `RESET` | `[1]` | RW | `0x0` | PLL reset (active high) |
| `REF_SEL` | `[3:2]` | RW | `0x0` | Reference clock select |
| `SYNC_EN` | `[4]` | RW | `0x0` | Enable sync output |

---
### `PLL_STATUS` — Address `0x0401`

**Reset value:** `0x0000`  **Access:** see fields below

PLL status flags

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LOCKED` | `[0]` | R | `0x0` | PLL locked indicator |
| `LOSS_OF_LOCK` | `[1]` | RC | `0x0` | Loss of lock flag (read-clear) |
| `HMC7044_OK` | `[2]` | R | `0x0` | HMC7044 device present |

---
### `PLL_N_DIV` — Address `0x0402`

**Reset value:** `0x0000`  **Access:** see fields below

PLL N divider value (for HMC7044 configuration)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `N_DIVIDER` | `[15:0]` | RW | `0x0064` | N divider value (100 decimal) |

---
### `PLL_R_DIV` — Address `0x0403`

**Reset value:** `0x0000`  **Access:** see fields below

PLL R divider value

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `R_DIVIDER` | `[7:0]` | RW | `0x0A` | R divider value (10 decimal) |

---
### `CLK_ENABLE` — Address `0x0410`

**Reset value:** `0x0000`  **Access:** see fields below

Clock output enables

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `CLK_ADC_EN` | `[0]` | RW | `0x0` | ADC clock output enable |
| `CLK_FPGA_EN` | `[1]` | RW | `0x0` | FPGA reference clock enable |
| `CLK_SYNC_EN` | `[2]` | RW | `0x0` | Sync clock output enable |
| `RESERVED` | `[15:3]` | RO | `0x0` | Reserved clock enables |

---
### `EEPROM_CTRL` — Address `0x0500`

**Reset value:** `0x0000`  **Access:** see fields below

EEPROM control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READ` | `[0]` | RW | `0x0` | Start EEPROM read operation |
| `WRITE` | `[1]` | RW | `0x0` | Start EEPROM write operation |
| `ERASE` | `[2]` | RW | `0x0` | Start EEPROM erase operation |
| `BUSY` | `[7]` | RO | `0x0` | EEPROM busy flag |

---
### `EEPROM_ADDR` — Address `0x0501`

**Reset value:** `0x0000`  **Access:** see fields below

EEPROM byte address

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BYTE_ADDR` | `[15:0]` | RW | `0x0000` | 16-bit EEPROM byte address |

---
### `EEPROM_DATA` — Address `0x0502`

**Reset value:** `0x0000`  **Access:** see fields below

EEPROM read/write data

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA_WORD` | `[15:0]` | RW | `0x0000` | 16-bit data word |

---
### `FLASH_CTRL` — Address `0x0600`

**Reset value:** `0x0000`  **Access:** see fields below

Configuration flash control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READ` | `[0]` | RW | `0x0` | Start flash read operation |
| `WRITE` | `[1]` | RW | `0x0` | Start flash write operation |
| `ERASE_SECTOR` | `[2]` | RW | `0x0` | Start flash sector erase |
| `ERASE_CHIP` | `[3]` | RW | `0x0` | Start flash chip erase |
| `BUSY` | `[7]` | RO | `0x0` | Flash busy flag |

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
| `RESERVED` | `[15:8]` | RO | `0x0` | Reserved |

---
### `FLASH_DATA` — Address `0x0603`

**Reset value:** `0x0000`  **Access:** see fields below

Flash data FIFO

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA_WORD` | `[15:0]` | RW | `0x0000` | 16-bit data word for flash operations |

---
### `FLASH_STATUS` — Address `0x0604`

**Reset value:** `0x0000`  **Access:** see fields below

Flash status flags

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READY` | `[0]` | R | `0x1` | Flash ready flag |
| `WRITE_ERR` | `[1]` | RC | `0x0` | Write error flag (read-clear) |
| `ERASE_ERR` | `[2]` | RC | `0x0` | Erase error flag (read-clear) |

---
### `RF_DSA_GAIN` — Address `0x0700`

**Reset value:** `0x0000`  **Access:** see fields below

HMC698LP4E Digital Step Attenuator gain control (6-bit, 0.25dB steps)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ATTENUATION` | `[5:0]` | RW | `0x00` | 6-bit attenuation value (0-63 = 0-15.75 dB) |
| `RESERVED` | `[15:6]` | RO | `0x0` | Reserved bits |

---
### `RF_LNA_ENABLE` — Address `0x0701`

**Reset value:** `0x0000`  **Access:** see fields below

TGA4943-SL LNA enable control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LNA_EN` | `[0]` | RW | `0x0` | Enable LNA (1=enabled, 0=disabled) |
| `BYPASS` | `[1]` | RW | `0x0` | LNA bypass mode |
| `RESERVED` | `[15:2]` | RO | `0x0` | Reserved bits |

---
### `RF_AGC_CTRL` — Address `0x0702`

**Reset value:** `0x0000`  **Access:** see fields below

Automatic Gain Control parameters

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `AGC_ENABLE` | `[0]` | RW | `0x0` | Enable AGC mode |
| `TARGET_LEVEL` | `[7:4]` | RW | `0x8` | Target ADC level (-10dBFS) |
| `HYSTERESIS` | `[11:8]` | RW | `0x2` | AGC hysteresis (2 dB) |
| `RESERVED` | `[15:12]` | RO | `0x0` | Reserved bits |

---
### `RF_STATUS` — Address `0x0703`

**Reset value:** `0x0000`  **Access:** see fields below

RF front-end status monitoring

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LNA_OK` | `[0]` | RO | `0x0` | LNA power OK flag |
| `DSA_OK` | `[1]` | RO | `0x0` | DSA power OK flag |
| `RF_DETECT` | `[2]` | RO | `0x0` | RF power detect flag |
| `RESERVED` | `[15:3]` | RO | `0x0` | Reserved bits |

---
### `JESD204B_CTRL` — Address `0x0710`

**Reset value:** `0x0000`  **Access:** see fields below

JESD204B interface control (Subclass 1 for ADC10D1000RF)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LINK_ENABLE` | `[0]` | RW | `0x0` | Enable JESD204B link |
| `SUBCLASS1_EN` | `[1]` | RW | `0x1` | Enable Subclass 1 deterministic latency |
| `LANE_COUNT` | `[4:2]` | RW | `0x2` | Number of active lanes (2 lanes) |
| `RESERVED` | `[15:5]` | RO | `0x0` | Reserved bits |

---
### `JESD204B_STATUS` — Address `0x0711`

**Reset value:** `0x0000`  **Access:** see fields below

JESD204B link status

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LINK_READY` | `[0]` | RO | `0x0` | Link ready flag |
| `LANE0_ALIGN` | `[1]` | RO | `0x0` | Lane 0 character aligned |
| `LANE1_ALIGN` | `[2]` | RO | `0x0` | Lane 1 character aligned |
| `CODE_GRP_SYNC` | `[3]` | RO | `0x0` | Code group synchronization |
| `RESERVED` | `[15:4]` | RO | `0x0` | Reserved bits |

---
### `GPIO_DIR` — Address `0x0800`

**Reset value:** `0x0000`  **Access:** see fields below

GPIO direction control (0=input, 1=output)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GPIO_DIR` | `[15:0]` | RW | `0x0000` | GPIO direction bits (all inputs at reset) |

---
### `GPIO_DATA_OUT` — Address `0x0801`

**Reset value:** `0x0000`  **Access:** see fields below

GPIO output data

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GPIO_OUT` | `[15:0]` | RW | `0x0000` | GPIO output data bits |

---
### `GPIO_DATA_IN` — Address `0x0802`

**Reset value:** `0x0000`  **Access:** see fields below

GPIO input data

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GPIO_IN` | `[15:0]` | RO | `0x0000` | GPIO input data bits |

---
### `GPIO_INT_EN` — Address `0x0803`

**Reset value:** `0x0000`  **Access:** see fields below

GPIO interrupt enable

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `INT_EN` | `[15:0]` | RW | `0x0000` | GPIO interrupt enable bits |

---
### `GPIO_INT_STATUS` — Address `0x0804`

**Reset value:** `0x0000`  **Access:** see fields below

GPIO interrupt status (read-clear)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `INT_FLAGS` | `[15:0]` | RC | `0x0000` | GPIO interrupt flags (read-clear) |
