# Register Description Table (RDT)
## receiver

> **Total registers:** 56

Receiver board GLR-derived register map with 40+ registers across 10 functional groups. Includes RF front-end control (LNA/VGA/Mixer), LO synthesizer (ADF5356), AD9208 IQ ADC interface, temperature/power monitoring, EEPROM/Flash storage, and UART communication. 20-step initialization sequence covering RAM check, board identification, power stabilization, PLL lock, clock distribution, RF chain enable, ADC initialization, and calibration startup for 5-18 GHz wideband receiver operation.

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
| `0x0000` | `BOARD_ID` | — | `0x5245` | Board identification code (ASCII 'RE' for Receiver) |
| `0x0001` | `BOARD_VERSION` | — | `0x10` | Hardware version - major and minor revision |
| `0x0002` | `BOARD_TYPE_ID` | — | `0x52580001` | Board type identifier for RX system |
| `0x0003` | `SCRATCHPAD` | — | `0x0000` | Read/write test register for RAM verification |
| `0x0010` | `MCS_VERSION_MAJOR` | — | `0x01` | FPGA firmware major version number |
| `0x0011` | `MCS_VERSION_MINOR` | — | `0x00` | FPGA firmware minor version number |
| `0x0012` | `BUILD_DATE` | — | `0x20260417` | Firmware build date in packed BCD format (YYYYMMDD) |
| `0x0100` | `UART_BAUD_DIV` | — | `0x0034` | UART baud rate divisor (clock_freq / (16 * baud_rate)) |
| `0x0101` | `UART_CTRL` | — | `0x00` | UART control register |
| `0x0102` | `UART_STATUS` | — | `0x00` | UART status flags |
| `0x0103` | `UART_TX_COUNT` | — | `0x00` | TX FIFO byte count |
| `0x0104` | `UART_RX_COUNT` | — | `0x00` | RX FIFO byte count |
| `0x0110` | `ETH_MAC_LOW` | — | `0x0000` | Ethernet MAC address lower 16 bits |
| `0x0111` | `ETH_MAC_HIGH` | — | `0x0000` | Ethernet MAC address upper 16 bits |
| `0x0200` | `ADC_CTRL` | — | `0x00` | ADC control for supply monitoring |
| `0x0201` | `ADC_STATUS` | — | `0x00` | ADC status flags |
| `0x0210` | `VCC_5V_RAW` | — | `0x0000` | 5V rail ADC count (multiply by 5.0/4096 for Volts) |
| `0x0211` | `VCC_3V3_RAW` | — | `0x0000` | 3.3V rail ADC count |
| `0x0212` | `VCC_2V5_RAW` | — | `0x0000` | 2.5V rail ADC count |
| `0x0213` | `VCC_1V8_RAW` | — | `0x0000` | 1.8V rail ADC count |
| `0x0218` | `ICC_5V_RAW` | — | `0x0000` | 5V rail current sense ADC count |
| `0x0219` | `ICC_3V3_RAW` | — | `0x0000` | 3.3V rail current sense ADC count |
| `0x0300` | `TEMP_LOCAL` | — | `0x0000` | FPGA die temperature in 0.25°C units (signed) |
| `0x0301` | `TEMP_REMOTE1` | — | `0x0000` | Remote sensor 1 temperature (LNA / RF front-end area) |
| `0x0302` | `TEMP_REMOTE2` | — | `0x0000` | Remote sensor 2 temperature (LO synthesizer area) |
| `0x0308` | `TEMP_ALERT_HIGH` | — | `0x0190` | Over-temperature alert threshold (100°C = 400 * 0.25) |
| `0x0309` | `TEMP_ALERT_LOW` | — | `0xFF9C` | Under-temperature alert threshold (-25°C) |
| `0x030F` | `HEALTH_STATUS` | — | `0x87` | System health status flags |
| `0x0400` | `PLL_CTRL` | — | `0x00` | LO synthesizer (ADF5356) PLL control |
| `0x0401` | `PLL_STATUS` | — | `0x00` | PLL lock status flags |
| `0x0402` | `PLL_N_DIV` | — | `0x0040` | PLL N divider value |
| `0x0403` | `PLL_R_DIV` | — | `0x0001` | PLL R divider value |
| `0x0410` | `CLK_ENABLE` | — | `0x00` | Clock output enables for distribution |
| `0x0420` | `LO_FREQ_LSB` | — | `0x0000` | LO frequency LSB (Hz) for ADF5356 programming |
| `0x0421` | `LO_FREQ_MSB` | — | `0x0640` | LO frequency MSB (MHz) for ADF5356 programming (default 10.0GHz) |
| `0x0422` | `LO_CTRL` | — | `0x00` | LO synthesizer control |
| `0x0500` | `EEPROM_CTRL` | — | `0x00` | EEPROM interface control |
| `0x0501` | `EEPROM_ADDR` | — | `0x0000` | EEPROM byte address |
| `0x0502` | `EEPROM_DATA` | — | `0x0000` | EEPROM read/write data |
| `0x0600` | `FLASH_CTRL` | — | `0x00` | Configuration flash control |
| `0x0601` | `FLASH_ADDR_LOW` | — | `0x0000` | Flash address low word |
| `0x0602` | `FLASH_ADDR_HIGH` | — | `0x0000` | Flash address high byte |
| `0x0603` | `FLASH_DATA` | — | `0x0000` | Flash data FIFO |
| `0x0604` | `FLASH_STATUS` | — | `0x01` | Flash operation status |
| `0x0800` | `GPIO_DIR` | — | `0x0000` | GPIO direction control (0=input, 1=output) |
| `0x0801` | `GPIO_OUT` | — | `0x0000` | GPIO output data |
| `0x0802` | `GPIO_IN` | — | `0x0000` | GPIO input data |
| `0x0803` | `RF_CTRL` | — | `0x00` | RF front-end control signals |
| `0x0804` | `VGA_GAIN` | — | `0x00` | VGA gain control (digital attenuation) |
| `0x0805` | `ADC_IF_CTRL` | — | `0x00` | AD9208 ADC interface control |
| `0x0806` | `ADC_STATUS_IF` | — | `0x00` | AD9208 ADC status |
| `0x0900` | `IRQ_MASK` | — | `0x00` | Interrupt mask register |
| `0x0901` | `IRQ_STATUS` | — | `0x00` | Interrupt status flags (read to clear) |
| `0x0902` | `IRQ_VECTOR` | — | `0x00` | Interrupt vector (highest priority pending IRQ) |
| `0x0A00` | `CALIB_CTRL` | — | `0x00` | Calibration control |
| `0x0A01` | `CALIB_STATUS` | — | `0x01` | Calibration status |

---
### `BOARD_ID` — Address `0x0000`

**Reset value:** `0x5245`  **Access:** see fields below

Board identification code (ASCII 'RE' for Receiver)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BOARD_ID` | `[15:0]` | R | `0x5245` | Board identification - ASCII 'RE' = 0x5245 |

---
### `BOARD_VERSION` — Address `0x0001`

**Reset value:** `0x10`  **Access:** see fields below

Hardware version - major and minor revision

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAJOR_REV` | `[7:4]` | R | `0x1` | Major hardware revision |
| `MINOR_REV` | `[3:0]` | R | `0x0` | Minor hardware revision |

---
### `BOARD_TYPE_ID` — Address `0x0002`

**Reset value:** `0x52580001`  **Access:** see fields below

Board type identifier for RX system

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TYPE_ID` | `[15:0]` | R | `0x5258` | Board type code |

---
### `SCRATCHPAD` — Address `0x0003`

**Reset value:** `0x0000`  **Access:** see fields below

Read/write test register for RAM verification

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEST_PATTERN` | `[15:0]` | RW | `0x0000` | Test pattern for register access verification |

---
### `MCS_VERSION_MAJOR` — Address `0x0010`

**Reset value:** `0x01`  **Access:** see fields below

FPGA firmware major version number

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAJOR_VER` | `[7:0]` | R | `0x01` | Major firmware version |

---
### `MCS_VERSION_MINOR` — Address `0x0011`

**Reset value:** `0x00`  **Access:** see fields below

FPGA firmware minor version number

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MINOR_VER` | `[7:0]` | R | `0x00` | Minor firmware version |

---
### `BUILD_DATE` — Address `0x0012`

**Reset value:** `0x20260417`  **Access:** see fields below

Firmware build date in packed BCD format (YYYYMMDD)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BUILD_DATE_BCD` | `[31:0]` | R | `0x20260417` | Build date: 2026-04-17 |

---
### `UART_BAUD_DIV` — Address `0x0100`

**Reset value:** `0x0034`  **Access:** see fields below

UART baud rate divisor (clock_freq / (16 * baud_rate))

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DIVISOR` | `[15:0]` | RW | `0x0034` | Baud rate divisor - default for 115200 baud @ 50MHz |

---
### `UART_CTRL` — Address `0x0101`

**Reset value:** `0x00`  **Access:** see fields below

UART control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0` | UART enable (1=enabled) |
| `LOOPBACK` | `[1]` | RW | `0` | Loopback mode for test |
| `FRAME_FORMAT` | `[7:4]` | RW | `0x0` | Frame format (0000=8N1) |

---
### `UART_STATUS` — Address `0x0102`

**Reset value:** `0x00`  **Access:** see fields below

UART status flags

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TX_BUSY` | `[0]` | R | `0` | Transmitter busy flag |
| `RX_AVAIL` | `[1]` | R | `0` | Data available in RX FIFO |
| `FRAME_ERR` | `[2]` | RC | `0` | Frame error detected (read to clear) |

---
### `UART_TX_COUNT` — Address `0x0103`

**Reset value:** `0x00`  **Access:** see fields below

TX FIFO byte count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TX_FIFO_LEVEL` | `[7:0]` | R | `0x00` | Number of bytes in TX FIFO |

---
### `UART_RX_COUNT` — Address `0x0104`

**Reset value:** `0x00`  **Access:** see fields below

RX FIFO byte count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `RX_FIFO_LEVEL` | `[7:0]` | R | `0x00` | Number of bytes in RX FIFO |

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

Ethernet MAC address upper 16 bits

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAC_HIGH` | `[31:16]` | R | `0x0000` | MAC address [31:16] |

---
### `ADC_CTRL` — Address `0x0200`

**Reset value:** `0x00`  **Access:** see fields below

ADC control for supply monitoring

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `START` | `[0]` | RW | `0` | Start single conversion |
| `CONTINUOUS` | `[1]` | RW | `0` | Continuous conversion mode |
| `CHANNEL_SEL` | `[3:2]` | RW | `0x0` | ADC channel select (00=CH0, 01=CH1, 10=CH2, 11=CH3) |

---
### `ADC_STATUS` — Address `0x0201`

**Reset value:** `0x00`  **Access:** see fields below

ADC status flags

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA_READY` | `[0]` | R | `0` | New data available |
| `OVERRANGE` | `[1]` | RC | `0` | ADC overrange detected (read to clear) |

---
### `VCC_5V_RAW` — Address `0x0210`

**Reset value:** `0x0000`  **Access:** see fields below

5V rail ADC count (multiply by 5.0/4096 for Volts)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_5V` | `[11:0]` | R | `0x000` | 12-bit ADC count for 5V rail |

---
### `VCC_3V3_RAW` — Address `0x0211`

**Reset value:** `0x0000`  **Access:** see fields below

3.3V rail ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_3V3` | `[11:0]` | R | `0x000` | 12-bit ADC count for 3.3V rail |

---
### `VCC_2V5_RAW` — Address `0x0212`

**Reset value:** `0x0000`  **Access:** see fields below

2.5V rail ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_2V5` | `[11:0]` | R | `0x000` | 12-bit ADC count for 2.5V rail |

---
### `VCC_1V8_RAW` — Address `0x0213`

**Reset value:** `0x0000`  **Access:** see fields below

1.8V rail ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_1V8` | `[11:0]` | R | `0x000` | 12-bit ADC count for 1.8V rail |

---
### `ICC_5V_RAW` — Address `0x0218`

**Reset value:** `0x0000`  **Access:** see fields below

5V rail current sense ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `CURR_5V` | `[11:0]` | R | `0x000` | 12-bit ADC count for 5V current |

---
### `ICC_3V3_RAW` — Address `0x0219`

**Reset value:** `0x0000`  **Access:** see fields below

3.3V rail current sense ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `CURR_3V3` | `[11:0]` | R | `0x000` | 12-bit ADC count for 3.3V current |

---
### `TEMP_LOCAL` — Address `0x0300`

**Reset value:** `0x0000`  **Access:** see fields below

FPGA die temperature in 0.25°C units (signed)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP` | `[9:0]` | R | `0x000` | Temperature in 0.25°C units (signed 10-bit) |

---
### `TEMP_REMOTE1` — Address `0x0301`

**Reset value:** `0x0000`  **Access:** see fields below

Remote sensor 1 temperature (LNA / RF front-end area)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_R1` | `[9:0]` | R | `0x000` | Remote temp sensor 1 in 0.25°C units |

---
### `TEMP_REMOTE2` — Address `0x0302`

**Reset value:** `0x0000`  **Access:** see fields below

Remote sensor 2 temperature (LO synthesizer area)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_R2` | `[9:0]` | R | `0x000` | Remote temp sensor 2 in 0.25°C units |

---
### `TEMP_ALERT_HIGH` — Address `0x0308`

**Reset value:** `0x0190`  **Access:** see fields below

Over-temperature alert threshold (100°C = 400 * 0.25)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ALERT_HI` | `[9:0]` | RW | `0x190` | High temp threshold (0x190 = 100°C) |

---
### `TEMP_ALERT_LOW` — Address `0x0309`

**Reset value:** `0xFF9C`  **Access:** see fields below

Under-temperature alert threshold (-25°C)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ALERT_LO` | `[9:0]` | RW | `0xFF9C` | Low temp threshold (signed -100 units = -25°C) |

---
### `HEALTH_STATUS` — Address `0x030F`

**Reset value:** `0x87`  **Access:** see fields below

System health status flags

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_OK` | `[0]` | R | `1` | Temperature within limits |
| `VOLT_OK` | `[1]` | R | `1` | Supply voltages OK |
| `PLL_LOCK` | `[2]` | R | `0` | PLL locked indication |
| `RF_POWER_OK` | `[3]` | R | `1` | RF power rails OK |
| `SYSTEM_OK` | `[7]` | R | `1` | Overall system health (1=OK) |

---
### `PLL_CTRL` — Address `0x0400`

**Reset value:** `0x00`  **Access:** see fields below

LO synthesizer (ADF5356) PLL control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0` | PLL enable (1=enabled) |
| `RESET` | `[1]` | RW | `0` | PLL reset (1=reset, self-clearing) |
| `REF_SEL` | `[3:2]` | RW | `0x0` | Reference clock select (00=10MHz, 01=25MHz, 10=100MHz) |

---
### `PLL_STATUS` — Address `0x0401`

**Reset value:** `0x00`  **Access:** see fields below

PLL lock status flags

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LOCKED` | `[0]` | R | `0` | PLL locked (1=locked) |
| `LOSS_OF_LOCK` | `[1]` | RC | `0` | Loss of lock detected (read to clear) |

---
### `PLL_N_DIV` — Address `0x0402`

**Reset value:** `0x0040`  **Access:** see fields below

PLL N divider value

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `N_DIVIDER` | `[15:0]` | RW | `0x0040` | N divider (default 64) |

---
### `PLL_R_DIV` — Address `0x0403`

**Reset value:** `0x0001`  **Access:** see fields below

PLL R divider value

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `R_DIVIDER` | `[7:0]` | RW | `0x01` | R divider (default 1) |

---
### `CLK_ENABLE` — Address `0x0410`

**Reset value:** `0x00`  **Access:** see fields below

Clock output enables for distribution

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `CLK_ADC_EN` | `[0]` | RW | `0` | ADC sampling clock enable |
| `CLK_LO_EN` | `[1]` | RW | `0` | LO synthesizer interface clock enable |
| `CLK_FPGA_EN` | `[7]` | RW | `0` | FPGA system clock enable |

---
### `LO_FREQ_LSB` — Address `0x0420`

**Reset value:** `0x0000`  **Access:** see fields below

LO frequency LSB (Hz) for ADF5356 programming

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `FREQ_LSB` | `[15:0]` | RW | `0x0000` | LO frequency lower 16 bits |

---
### `LO_FREQ_MSB` — Address `0x0421`

**Reset value:** `0x0640`  **Access:** see fields below

LO frequency MSB (MHz) for ADF5356 programming (default 10.0GHz)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `FREQ_MHZ` | `[15:0]` | RW | `0x0640` | LO frequency in MHz (0x0640 = 1600 MHz for tuning) |

---
### `LO_CTRL` — Address `0x0422`

**Reset value:** `0x00`  **Access:** see fields below

LO synthesizer control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LO_ENABLE` | `[0]` | RW | `0` | LO output enable |
| `FREQ_UPDATE` | `[1]` | RW | `0` | Trigger frequency update (self-clearing) |
| `MUTE` | `[7]` | RW | `1` | LO mute enable (default muted) |

---
### `EEPROM_CTRL` — Address `0x0500`

**Reset value:** `0x00`  **Access:** see fields below

EEPROM interface control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READ` | `[0]` | RW | `0` | Start read operation |
| `WRITE` | `[1]` | RW | `0` | Start write operation |
| `ERASE` | `[2]` | RW | `0` | Start erase operation |
| `BUSY` | `[7]` | R | `0` | EEPROM busy flag |

---
### `EEPROM_ADDR` — Address `0x0501`

**Reset value:** `0x0000`  **Access:** see fields below

EEPROM byte address

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADDR` | `[15:0]` | RW | `0x0000` | 16-bit EEPROM address |

---
### `EEPROM_DATA` — Address `0x0502`

**Reset value:** `0x0000`  **Access:** see fields below

EEPROM read/write data

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA` | `[15:0]` | RW | `0x0000` | 16-bit EEPROM data |

---
### `FLASH_CTRL` — Address `0x0600`

**Reset value:** `0x00`  **Access:** see fields below

Configuration flash control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READ` | `[0]` | RW | `0` | Start flash read |
| `WRITE` | `[1]` | RW | `0` | Start flash write |
| `ERASE_SECTOR` | `[2]` | RW | `0` | Erase flash sector |
| `ERASE_CHIP` | `[3]` | RW | `0` | Erase entire chip |
| `BUSY` | `[7]` | R | `0` | Flash busy flag |

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

---
### `FLASH_DATA` — Address `0x0603`

**Reset value:** `0x0000`  **Access:** see fields below

Flash data FIFO

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA` | `[15:0]` | RW | `0x0000` | Flash read/write data |

---
### `FLASH_STATUS` — Address `0x0604`

**Reset value:** `0x01`  **Access:** see fields below

Flash operation status

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READY` | `[0]` | R | `1` | Flash ready for operations |
| `WRITE_ERR` | `[1]` | RC | `0` | Write error (read to clear) |
| `ERASE_ERR` | `[2]` | RC | `0` | Erase error (read to clear) |

---
### `GPIO_DIR` — Address `0x0800`

**Reset value:** `0x0000`  **Access:** see fields below

GPIO direction control (0=input, 1=output)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GPIO_DIR` | `[15:0]` | RW | `0x0000` | GPIO direction bits |

---
### `GPIO_OUT` — Address `0x0801`

**Reset value:** `0x0000`  **Access:** see fields below

GPIO output data

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GPIO_OUT` | `[15:0]` | RW | `0x0000` | GPIO output levels |

---
### `GPIO_IN` — Address `0x0802`

**Reset value:** `0x0000`  **Access:** see fields below

GPIO input data

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GPIO_IN` | `[15:0]` | R | `0x0000` | GPIO input levels |

---
### `RF_CTRL` — Address `0x0803`

**Reset value:** `0x00`  **Access:** see fields below

RF front-end control signals

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LNA_ENABLE` | `[0]` | RW | `0` | LNA (TGA4506-SM) enable |
| `VGA_ENABLE` | `[1]` | RW | `0` | VGA (HMC698LP4) enable |
| `MIXER_ENABLE` | `[2]` | RW | `0` | Mixer (HMC1052LP4E) enable |
| `IF_AMP_ENABLE` | `[3]` | RW | `0` | IF Amplifier (ADA4817) enable |

---
### `VGA_GAIN` — Address `0x0804`

**Reset value:** `0x00`  **Access:** see fields below

VGA gain control (digital attenuation)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GAIN_CODE` | `[7:0]` | RW | `0x00` | VGA gain code (0=max gain, 255=max attenuation) |

---
### `ADC_IF_CTRL` — Address `0x0805`

**Reset value:** `0x00`  **Access:** see fields below

AD9208 ADC interface control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_ENABLE` | `[0]` | RW | `0` | ADC enable |
| `TEST_PATTERN` | `[1]` | RW | `0` | Enable ADC test pattern |
| `DECIMATION` | `[4:2]` | RW | `0x0` | Decimation factor (000=bypass, 001=2, 010=4, 011=8) |
| `DDC_ENABLE` | `[7]` | RW | `0` | Digital down-converter enable |

---
### `ADC_STATUS_IF` — Address `0x0806`

**Reset value:** `0x00`  **Access:** see fields below

AD9208 ADC status

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_READY` | `[0]` | R | `0` | ADC ready flag |
| `OVERFLOW_I` | `[1]` | RC | `0` | I-channel overflow (read to clear) |
| `OVERFLOW_Q` | `[2]` | RC | `0` | Q-channel overflow (read to clear) |
| `DATA_VALID` | `[7]` | R | `0` | Valid IQ data available |

---
### `IRQ_MASK` — Address `0x0900`

**Reset value:** `0x00`  **Access:** see fields below

Interrupt mask register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MASK_PLL_LOSS` | `[0]` | RW | `0` | Mask PLL loss-of-lock interrupt |
| `MASK_TEMP_ALERT` | `[1]` | RW | `0` | Mask temperature alert interrupt |
| `MASK_ADC_OVF` | `[2]` | RW | `0` | Mask ADC overflow interrupt |
| `MASK_UART_RX` | `[7]` | RW | `0` | Mask UART RX data available interrupt |

---
### `IRQ_STATUS` — Address `0x0901`

**Reset value:** `0x00`  **Access:** see fields below

Interrupt status flags (read to clear)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `IRQ_PLL_LOSS` | `[0]` | RC | `0` | PLL loss-of-lock interrupt pending |
| `IRQ_TEMP_ALERT` | `[1]` | RC | `0` | Temperature alert interrupt pending |
| `IRQ_ADC_OVF` | `[2]` | RC | `0` | ADC overflow interrupt pending |
| `IRQ_UART_RX` | `[7]` | RC | `0` | UART RX interrupt pending |

---
### `IRQ_VECTOR` — Address `0x0902`

**Reset value:** `0x00`  **Access:** see fields below

Interrupt vector (highest priority pending IRQ)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `VECTOR` | `[7:0]` | R | `0x00` | IRQ number (0x00 = none) |

---
### `CALIB_CTRL` — Address `0x0A00`

**Reset value:** `0x00`  **Access:** see fields below

Calibration control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `CALIB_START` | `[0]` | RW | `0` | Start calibration sequence |
| `CALIB_AUTO` | `[1]` | RW | `0` | Enable auto-calibration on power-up |
| `CALIB_BUSY` | `[7]` | R | `0` | Calibration in progress |

---
### `CALIB_STATUS` — Address `0x0A01`

**Reset value:** `0x01`  **Access:** see fields below

Calibration status

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `CALIB_DONE` | `[0]` | R | `1` | Calibration complete flag |
| `DC_OFFSET_DONE` | `[1]` | R | `0` | DC offset calibration done |
| `GAIN_CALIB_DONE` | `[2]` | R | `0` | Gain calibration done |
| `PHASE_CALIB_DONE` | `[3]` | R | `0` | IQ phase calibration done |
