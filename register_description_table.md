# Register Description Table (RDT)
## sample

> **Total registers:** 62

Sample Wideband RF Receiver System - Complete register map for XCZU2CG FPGA with RF front-end (HMC1134 LNA, HMC1118 switch, HMC559 mixer, AD8376 VGA), AD9208 ADC (JESD204B/C 8 lanes), HMC7044 clock synthesizer, LTC2975 power controller. 52 memory-mapped registers across 10 functional groups (0x000-0x900) including board info, UART, ADC monitoring, temperature, PLL, EEPROM, Flash, RF control, GPIO, and calibration. 30-step initialization sequence covering POR self-check, PLL lock, peripheral enable, communication init, and RF path activation.

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
| `0x0000` | `BOARD_ID` | — | `0x534D` | Board identification code (ASCII 'SM' for sample) |
| `0x0001` | `BOARD_VERSION` | — | `0x10` | Hardware revision number (major.minor) |
| `0x0002` | `BOARD_TYPE_ID` | — | `0x52520100` | Board type identifier (RF Receiver System) |
| `0x0003` | `SCRATCHPAD` | — | `0x0000` | Read/write test register for RAM verification |
| `0x0010` | `MCS_VERSION_MAJOR` | — | `0x01` | FPGA firmware major version number |
| `0x0011` | `MCS_VERSION_MINOR` | — | `0x00` | FPGA firmware minor version number |
| `0x0012` | `BUILD_DATE` | — | `0x20260416` | Firmware build date (YYYYMMDD packed BCD) |
| `0x0100` | `UART_BAUD_DIV` | — | `0x0068` | UART baud rate divisor for 115200 baud @ 25MHz clock |
| `0x0101` | `UART_CTRL` | — | `0x00` | UART control register |
| `0x0102` | `UART_STATUS` | — | `0x00` | UART status flags |
| `0x0103` | `UART_TX_COUNT` | — | `0x00` | TX FIFO byte count |
| `0x0104` | `UART_RX_COUNT` | — | `0x00` | RX FIFO byte count |
| `0x0110` | `ETH_MAC_LOW` | — | `0x0000` | Ethernet MAC address lower 16 bits |
| `0x0111` | `ETH_MAC_HIGH` | — | `0x0000` | Ethernet MAC address upper 16 bits |
| `0x0200` | `ADC_CTRL` | — | `0x00` | ADC control and channel selection |
| `0x0201` | `ADC_STATUS` | — | `0x00` | ADC status flags |
| `0x0210` | `VCC_5V_RAW` | — | `0x0000` | 5V rail ADC raw count (12-bit) |
| `0x0211` | `VCC_3V3_RAW` | — | `0x0000` | 3.3V rail ADC raw count (12-bit) |
| `0x0212` | `VCC_2V5_RAW` | — | `0x0000` | 2.5V rail ADC raw count (12-bit) |
| `0x0213` | `VCC_1V8_RAW` | — | `0x0000` | 1.8V rail ADC raw count (12-bit) |
| `0x0214` | `VCC_1V25_RAW` | — | `0x0000` | 1.25V ADC core rail ADC raw count (12-bit) |
| `0x0218` | `ICC_5V_RAW` | — | `0x0000` | 5V rail current sense ADC raw count (12-bit) |
| `0x0219` | `ICC_3V3_RAW` | — | `0x0000` | 3.3V rail current sense ADC raw count (12-bit) |
| `0x0300` | `TEMP_LOCAL` | — | `0x0000` | Local FPGA die temperature (0.25°C units, signed) |
| `0x0301` | `TEMP_REMOTE1` | — | `0x0000` | Remote sensor 1 temperature (0.25°C units, signed) |
| `0x0302` | `TEMP_REMOTE2` | — | `0x0000` | Remote sensor 2 temperature (0.25°C units, signed) |
| `0x0308` | `TEMP_ALERT_HIGH` | — | `0x0190` | Over-temperature alert threshold (100°C default) |
| `0x0309` | `TEMP_ALERT_LOW` | — | `0xFF9C` | Under-temperature alert threshold (-25°C default) |
| `0x030F` | `HEALTH_STATUS` | — | `0x00` | System health summary register |
| `0x0400` | `PLL_CTRL` | — | `0x00` | HMC7044 PLL control register |
| `0x0401` | `PLL_STATUS` | — | `0x00` | PLL status flags |
| `0x0402` | `PLL_N_DIV` | — | `0x0040` | PLL N divider value |
| `0x0403` | `PLL_R_DIV` | — | `0x0001` | PLL R divider value |
| `0x0410` | `CLK_ENABLE` | — | `0x00` | Clock output enable mask |
| `0x0500` | `EEPROM_CTRL` | — | `0x00` | EEPROM I2C control register |
| `0x0501` | `EEPROM_ADDR` | — | `0x0000` | EEPROM byte address [15:0] |
| `0x0502` | `EEPROM_DATA` | — | `0x0000` | EEPROM read/write data [15:0] |
| `0x0600` | `FLASH_CTRL` | — | `0x00` | Configuration Flash control register |
| `0x0601` | `FLASH_ADDR_LOW` | — | `0x0000` | Flash address low word [15:0] |
| `0x0602` | `FLASH_ADDR_HIGH` | — | `0x0000` | Flash address high word [23:16] |
| `0x0603` | `FLASH_DATA` | — | `0x0000` | Flash data FIFO [15:0] |
| `0x0604` | `FLASH_STATUS` | — | `0x00` | Flash operation status |
| `0x0700` | `RF_LNA_CTRL` | — | `0x00` | RF LNA (HMC1134) control register |
| `0x0701` | `RF_SWITCH_CTRL` | — | `0x00` | RF SPDT Switch (HMC1118) control register |
| `0x0702` | `RF_MIXER_CTRL` | — | `0x00` | RF Mixer (HMC559) control register |
| `0x0703` | `RF_LO_FREQ` | — | `0x0000` | LO frequency control word for mixer |
| `0x0708` | `VGA_GAIN_CTRL` | — | `0x00` | IF VGA (AD8376) gain control register |
| `0x0709` | `RF_PHASE_CTRL` | — | `0x00` | RF phase offset control register |
| `0x0710` | `JESD_CTRL` | — | `0x00` | JESD204B/C link control register |
| `0x0711` | `JESD_STATUS` | — | `0x00` | JESD204B/C link status register |
| `0x0712` | `ADC_JESD_CFG` | — | `0x0000` | AD9208 JESD configuration register |
| `0x0713` | `ADC_SPI_CTRL` | — | `0x00` | ADC SPI control interface register |
| `0x0800` | `GPIO_DIR` | — | `0x0000` | GPIO direction control (0=input, 1=output) |
| `0x0801` | `GPIO_DATA_OUT` | — | `0x0000` | GPIO output data register |
| `0x0802` | `GPIO_DATA_IN` | — | `0x0000` | GPIO input data register |
| `0x0803` | `GPIO_INT_EN` | — | `0x00` | GPIO interrupt enable mask |
| `0x0804` | `GPIO_INT_STATUS` | — | `0x00` | GPIO interrupt status flags |
| `0x0808` | `POWER_CTRL` | — | `0x00` | Power rail enable control |
| `0x080F` | `SYSTEM_RESET` | — | `0x00` | System reset control register |
| `0x0900` | `AGC_CTRL` | — | `0x00` | Automatic Gain Control (AGC) enable and config |
| `0x0901` | `DAC_OUTPUT` | — | `0x8000` | Auxiliary DAC output control (16-bit) |
| `0x0902` | `CAL_DATA` | — | `0x00` | Calibration data storage register |

---
### `BOARD_ID` — Address `0x0000`

**Reset value:** `0x534D`  **Access:** see fields below

Board identification code (ASCII 'SM' for sample)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BOARD_ID` | `[15:0]` | RO | `0x534D` | Unique board identifier for sample project (ASCII 'SM') |

---
### `BOARD_VERSION` — Address `0x0001`

**Reset value:** `0x10`  **Access:** see fields below

Hardware revision number (major.minor)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAJOR_REV` | `[7:4]` | RO | `0x1` | Major revision number |
| `MINOR_REV` | `[3:0]` | RO | `0x0` | Minor revision number |

---
### `BOARD_TYPE_ID` — Address `0x0002`

**Reset value:** `0x52520100`  **Access:** see fields below

Board type identifier (RF Receiver System)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TYPE_CODE` | `[15:0]` | RO | `0x5252` | Type code 'RR' (RF Receiver) |
| `VARIANT` | `[15:0]` | RO | `0x0100` | Variant identifier - Wideband version |

---
### `SCRATCHPAD` — Address `0x0003`

**Reset value:** `0x0000`  **Access:** see fields below

Read/write test register for RAM verification

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEST_PATTERN` | `[15:0]` | RW | `0x0000` | Scratchpad for communication integrity testing |

---
### `MCS_VERSION_MAJOR` — Address `0x0010`

**Reset value:** `0x01`  **Access:** see fields below

FPGA firmware major version number

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAJOR_VERSION` | `[7:0]` | RO | `0x01` | Major firmware version |

---
### `MCS_VERSION_MINOR` — Address `0x0011`

**Reset value:** `0x00`  **Access:** see fields below

FPGA firmware minor version number

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MINOR_VERSION` | `[7:0]` | RO | `0x00` | Minor firmware version |

---
### `BUILD_DATE` — Address `0x0012`

**Reset value:** `0x20260416`  **Access:** see fields below

Firmware build date (YYYYMMDD packed BCD)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `YEAR` | `[15:12]` | RO | `0x2` | Build year (BCD encoded) |
| `MONTH` | `[11:8]` | RO | `0x4` | Build month (BCD encoded) |
| `DAY` | `[7:0]` | RO | `0x16` | Build day (BCD encoded) |

---
### `UART_BAUD_DIV` — Address `0x0100`

**Reset value:** `0x0068`  **Access:** see fields below

UART baud rate divisor for 115200 baud @ 25MHz clock

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DIVISOR` | `[15:0]` | RW | `0x0068` | Baud rate divisor = CLK_FREQ / (16 * BAUD_RATE) |

---
### `UART_CTRL` — Address `0x0101`

**Reset value:** `0x00`  **Access:** see fields below

UART control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0` | UART enable bit |
| `LOOPBACK` | `[1]` | RW | `0` | Loopback mode for test |
| `FRAME_FORMAT` | `[7:4]` | RW | `0x0` | Frame format (bits, parity, stop) |
| `RSVD` | `[15:8]` | RW | `0x00` | Reserved bits |

---
### `UART_STATUS` — Address `0x0102`

**Reset value:** `0x00`  **Access:** see fields below

UART status flags

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TX_BUSY` | `[0]` | R | `0` | Transmitter busy flag |
| `RX_AVAIL` | `[1]` | R | `0` | Data available in RX FIFO |
| `FRAME_ERR` | `[2]` | RC | `0` | Frame error (clear on read) |
| `OVERRUN_ERR` | `[3]` | RC | `0` | RX FIFO overrun (clear on read) |
| `RSVD` | `[15:4]` | R | `0x00` | Reserved bits |

---
### `UART_TX_COUNT` — Address `0x0103`

**Reset value:** `0x00`  **Access:** see fields below

TX FIFO byte count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TX_COUNT` | `[7:0]` | RO | `0` | Number of bytes in TX FIFO |
| `TX_FULL` | `[8]` | RO | `0` | TX FIFO full flag |

---
### `UART_RX_COUNT` — Address `0x0104`

**Reset value:** `0x00`  **Access:** see fields below

RX FIFO byte count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `RX_COUNT` | `[7:0]` | RO | `0` | Number of bytes in RX FIFO |
| `RX_EMPTY` | `[8]` | RO | `1` | RX FIFO empty flag |

---
### `ETH_MAC_LOW` — Address `0x0110`

**Reset value:** `0x0000`  **Access:** see fields below

Ethernet MAC address lower 16 bits

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAC_LOW` | `[15:0]` | RO | `0x0000` | MAC address bytes [4:5] |

---
### `ETH_MAC_HIGH` — Address `0x0111`

**Reset value:** `0x0000`  **Access:** see fields below

Ethernet MAC address upper 16 bits

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAC_HIGH` | `[15:0]` | RO | `0x0000` | MAC address bytes [0:1] (remaining bytes in extension registers) |

---
### `ADC_CTRL` — Address `0x0200`

**Reset value:** `0x00`  **Access:** see fields below

ADC control and channel selection

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `START` | `[0]` | RW | `0` | Start ADC conversion |
| `CONTINUOUS` | `[1]` | RW | `0` | Continuous sampling mode |
| `CHANNEL_SEL` | `[3:2]` | RW | `0x0` | ADC channel select (0=5V, 1=3.3V, 2=2.5V, 3=1.8V) |
| `RSVD` | `[15:4]` | RW | `0x00` | Reserved bits |

---
### `ADC_STATUS` — Address `0x0201`

**Reset value:** `0x00`  **Access:** see fields below

ADC status flags

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA_READY` | `[0]` | R | `0` | New data available |
| `OVERRANGE` | `[1]` | RC | `0` | Input exceeded range (clear on read) |
| `CONV_ACTIVE` | `[2]` | R | `0` | Conversion in progress |

---
### `VCC_5V_RAW` — Address `0x0210`

**Reset value:** `0x0000`  **Access:** see fields below

5V rail ADC raw count (12-bit)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | RO | `0` | Raw ADC count; Volts = COUNT * 5.0 / 4096 |
| `RSVD` | `[15:12]` | RO | `0` | Reserved |

---
### `VCC_3V3_RAW` — Address `0x0211`

**Reset value:** `0x0000`  **Access:** see fields below

3.3V rail ADC raw count (12-bit)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | RO | `0` | Raw ADC count; Volts = COUNT * 3.3 / 4096 |

---
### `VCC_2V5_RAW` — Address `0x0212`

**Reset value:** `0x0000`  **Access:** see fields below

2.5V rail ADC raw count (12-bit)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | RO | `0` | Raw ADC count; Volts = COUNT * 2.5 / 4096 |

---
### `VCC_1V8_RAW` — Address `0x0213`

**Reset value:** `0x0000`  **Access:** see fields below

1.8V rail ADC raw count (12-bit)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | RO | `0` | Raw ADC count; Volts = COUNT * 1.8 / 4096 |

---
### `VCC_1V25_RAW` — Address `0x0214`

**Reset value:** `0x0000`  **Access:** see fields below

1.25V ADC core rail ADC raw count (12-bit)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | RO | `0` | Raw ADC count; Volts = COUNT * 1.25 / 4096 |

---
### `ICC_5V_RAW` — Address `0x0218`

**Reset value:** `0x0000`  **Access:** see fields below

5V rail current sense ADC raw count (12-bit)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | RO | `0` | Raw current ADC count; Amps = COUNT * SCALE |

---
### `ICC_3V3_RAW` — Address `0x0219`

**Reset value:** `0x0000`  **Access:** see fields below

3.3V rail current sense ADC raw count (12-bit)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | RO | `0` | Raw current ADC count; Amps = COUNT * SCALE |

---
### `TEMP_LOCAL` — Address `0x0300`

**Reset value:** `0x0000`  **Access:** see fields below

Local FPGA die temperature (0.25°C units, signed)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP` | `[9:0]` | RO | `0` | Temperature in 0.25°C units (signed 10-bit) |
| `RSVD` | `[15:10]` | RO | `0` | Reserved |

---
### `TEMP_REMOTE1` — Address `0x0301`

**Reset value:** `0x0000`  **Access:** see fields below

Remote sensor 1 temperature (0.25°C units, signed)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP` | `[9:0]` | RO | `0` | Remote temp sensor 1 reading (ADC location) |

---
### `TEMP_REMOTE2` — Address `0x0302`

**Reset value:** `0x0000`  **Access:** see fields below

Remote sensor 2 temperature (0.25°C units, signed)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP` | `[9:0]` | RO | `0` | Remote temp sensor 2 reading (Power Controller) |

---
### `TEMP_ALERT_HIGH` — Address `0x0308`

**Reset value:** `0x0190`  **Access:** see fields below

Over-temperature alert threshold (100°C default)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `THRESHOLD` | `[9:0]` | RW | `0x0190` | Alert threshold in 0.25°C units (0x190 = 100°C) |
| `ENABLE` | `[15]` | RW | `0x1` | Enable high temp alert |

---
### `TEMP_ALERT_LOW` — Address `0x0309`

**Reset value:** `0xFF9C`  **Access:** see fields below

Under-temperature alert threshold (-25°C default)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `THRESHOLD` | `[9:0]` | RW | `0xFF9C` | Alert threshold in 0.25°C units (signed, -25°C) |
| `ENABLE` | `[15]` | RW | `0x1` | Enable low temp alert |

---
### `HEALTH_STATUS` — Address `0x030F`

**Reset value:** `0x00`  **Access:** see fields below

System health summary register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_OK` | `[0]` | RO | `0` | Temperature within limits |
| `VOLT_OK` | `[1]` | RO | `0` | All voltages within tolerance |
| `PLL_LOCK` | `[2]` | RO | `0` | Clock PLL locked |
| `JESD_LINK_OK` | `[3]` | RO | `0` | JESD204 link established |
| `SYSTEM_OK` | `[7]` | RO | `0` | Overall system healthy (all bits 0-6 set) |

---
### `PLL_CTRL` — Address `0x0400`

**Reset value:** `0x00`  **Access:** see fields below

HMC7044 PLL control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0` | Enable PLL output |
| `RESET` | `[1]` | RW | `1` | PLL reset (1=reset, 0=normal) |
| `REF_SEL` | `[3:2]` | RW | `0x0` | Reference clock source select |
| `SYNC_MODE` | `[4]` | RW | `0` | Enable synchronous mode |

---
### `PLL_STATUS` — Address `0x0401`

**Reset value:** `0x00`  **Access:** see fields below

PLL status flags

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LOCKED` | `[0]` | RO | `0` | PLL lock detected |
| `LOSS_OF_LOCK` | `[1]` | RC | `0` | Lock lost event (clear on read) |
| `REF_VALID` | `[2]` | RO | `0` | Reference clock present |

---
### `PLL_N_DIV` — Address `0x0402`

**Reset value:** `0x0040`  **Access:** see fields below

PLL N divider value

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `N_DIV` | `[15:0]` | RW | `0x0040` | N divider ratio (default 64) |

---
### `PLL_R_DIV` — Address `0x0403`

**Reset value:** `0x0001`  **Access:** see fields below

PLL R divider value

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `R_DIV` | `[7:0]` | RW | `0x01` | R divider ratio (default 1) |

---
### `CLK_ENABLE` — Address `0x0410`

**Reset value:** `0x00`  **Access:** see fields below

Clock output enable mask

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `CLK_ADC_EN` | `[0]` | RW | `0` | Enable ADC sampling clock |
| `CLK_MIXER_LO_EN` | `[1]` | RW | `0` | Enable mixer LO clock |
| `CLK_FPGA_REF_EN` | `[2]` | RW | `0` | Enable FPGA reference clock |
| `CLK_SYNC_EN` | `[3]` | RW | `0` | Enable SYNC output clock |
| `RSVD` | `[15:4]` | RW | `0x0` | Reserved clock outputs |

---
### `EEPROM_CTRL` — Address `0x0500`

**Reset value:** `0x00`  **Access:** see fields below

EEPROM I2C control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READ` | `[0]` | RW | `0` | Start read operation |
| `WRITE` | `[1]` | RW | `0` | Start write operation |
| `ERASE` | `[2]` | RW | `0` | Erase page (if supported) |
| `BUSY` | `[7]` | RO | `0` | Operation in progress |

---
### `EEPROM_ADDR` — Address `0x0501`

**Reset value:** `0x0000`  **Access:** see fields below

EEPROM byte address [15:0]

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADDR` | `[15:0]` | RW | `0x0000` | 16-bit EEPROM byte address |

---
### `EEPROM_DATA` — Address `0x0502`

**Reset value:** `0x0000`  **Access:** see fields below

EEPROM read/write data [15:0]

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA` | `[15:0]` | RW | `0x0000` | Data word for read/write |

---
### `FLASH_CTRL` — Address `0x0600`

**Reset value:** `0x00`  **Access:** see fields below

Configuration Flash control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READ` | `[0]` | RW | `0` | Start flash read |
| `WRITE` | `[1]` | RW | `0` | Start flash write |
| `ERASE_SECTOR` | `[2]` | RW | `0` | Erase sector at FLASH_ADDR |
| `ERASE_CHIP` | `[3]` | RW | `0` | Erase entire chip (requires unlock) |
| `BUSY` | `[7]` | RO | `0` | Flash operation in progress |

---
### `FLASH_ADDR_LOW` — Address `0x0601`

**Reset value:** `0x0000`  **Access:** see fields below

Flash address low word [15:0]

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADDR_LOW` | `[15:0]` | RW | `0x0000` | Lower 16 bits of flash address |

---
### `FLASH_ADDR_HIGH` — Address `0x0602`

**Reset value:** `0x0000`  **Access:** see fields below

Flash address high word [23:16]

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADDR_HIGH` | `[7:0]` | RW | `0x00` | Upper 8 bits of flash address (24-bit total) |

---
### `FLASH_DATA` — Address `0x0603`

**Reset value:** `0x0000`  **Access:** see fields below

Flash data FIFO [15:0]

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA` | `[15:0]` | RW | `0x0000` | Data word for flash read/write |

---
### `FLASH_STATUS` — Address `0x0604`

**Reset value:** `0x00`  **Access:** see fields below

Flash operation status

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READY` | `[0]` | RO | `1` | Flash ready for operation |
| `WRITE_ERR` | `[1]` | RC | `0` | Write failed (clear on read) |
| `ERASE_ERR` | `[2]` | RC | `0` | Erase failed (clear on read) |
| `PROTECT_ERR` | `[3]` | RC | `0` | Protection violation (clear on read) |

---
### `RF_LNA_CTRL` — Address `0x0700`

**Reset value:** `0x00`  **Access:** see fields below

RF LNA (HMC1134) control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LNA_ENABLE` | `[0]` | RW | `0` | Enable LNA power |
| `GAIN_MODE` | `[2:1]` | RW | `0x0` | LNA gain mode (0=high gain, 1=mid, 2=low) |
| `BYPASS` | `[3]` | RW | `0` | LNA bypass mode |

---
### `RF_SWITCH_CTRL` — Address `0x0701`

**Reset value:** `0x00`  **Access:** see fields below

RF SPDT Switch (HMC1118) control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `SW_A` | `[0]` | RW | `0` | Switch control A (to RFC1) |
| `SW_B` | `[1]` | RW | `0` | Switch control B (to RFC2) |
| `SWITCH_EN` | `[2]` | RW | `0` | Switch enable |

---
### `RF_MIXER_CTRL` — Address `0x0702`

**Reset value:** `0x00`  **Access:** see fields below

RF Mixer (HMC559) control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MIXER_EN` | `[0]` | RW | `0` | Enable mixer power |
| `IF_BW_SEL` | `[3:2]` | RW | `0x0` | IF bandwidth selection |

---
### `RF_LO_FREQ` — Address `0x0703`

**Reset value:** `0x0000`  **Access:** see fields below

LO frequency control word for mixer

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `FREQ_WORD` | `[15:0]` | RW | `0x0000` | LO frequency tuning word |

---
### `VGA_GAIN_CTRL` — Address `0x0708`

**Reset value:** `0x00`  **Access:** see fields below

IF VGA (AD8376) gain control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GAIN_CODE` | `[7:0]` | RW | `0x00` | 8-bit parallel gain code (0=max gain, 255=min gain) |
| `GAIN_EN` | `[8]` | RW | `0` | Enable VGA gain changes |
| `SLEW_EN` | `[9]` | RW | `1` | Enable slew rate limiting for gain transitions |

---
### `RF_PHASE_CTRL` — Address `0x0709`

**Reset value:** `0x00`  **Access:** see fields below

RF phase offset control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `PHASE_ADJ` | `[9:0]` | RW | `0x000` | Phase adjustment in LSB steps |
| `PHASE_EN` | `[15]` | RW | `0` | Enable phase adjustment |

---
### `JESD_CTRL` — Address `0x0710`

**Reset value:** `0x00`  **Access:** see fields below

JESD204B/C link control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LINK_EN` | `[0]` | RW | `0` | Enable JESD204 link |
| `LANE_EN` | `[7:1]` | RW | `0xFF` | Per-lane enable mask (bits 1-7 for lanes 0-6) |
| `SUBCLASS` | `[9:8]` | RW | `0x1` | JESD subclass (0=single, 1=multi-frame) |

---
### `JESD_STATUS` — Address `0x0711`

**Reset value:** `0x00`  **Access:** see fields below

JESD204B/C link status register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LINK_READY` | `[0]` | RO | `0` | Link synchronization complete |
| `ALIGNMENT_DONE` | `[1]` | RO | `0` | Lane alignment complete |
| `DETECT_ERR` | `[2]` | RC | `0` | Code group sync error (clear on read) |
| `LANE_STATUS` | `[15:8]` | RO | `0x00` | Per-lane status flags |

---
### `ADC_JESD_CFG` — Address `0x0712`

**Reset value:** `0x0000`  **Access:** see fields below

AD9208 JESD configuration register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `SAMPLE_RATE` | `[3:0]` | RW | `0x3` | Sample rate index (0=1G, 1=1.5G, 2=2G, 3=2.5G, 4=3G) |
| `RESOLUTION` | `[6:4]` | RW | `0x2` | Resolution (0=8, 1=10, 2=12-bit) |
| `DECIMATION` | `[8:7]` | RW | `0x0` | Decimation factor (0=none, 1=2, 2=4, 3=8) |

---
### `ADC_SPI_CTRL` — Address `0x0713`

**Reset value:** `0x00`  **Access:** see fields below

ADC SPI control interface register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `CS_N` | `[0]` | RW | `1` | ADC SPI chip select (active low) |
| `START_XFER` | `[1]` | RW | `0` | Start SPI transfer |
| `WORD_LEN` | `[4:2]` | RW | `0x3` | Transfer word length (0=8, 1=16, 2=24, 3=32-bit) |

---
### `GPIO_DIR` — Address `0x0800`

**Reset value:** `0x0000`  **Access:** see fields below

GPIO direction control (0=input, 1=output)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GPIO_DIR` | `[15:0]` | RW | `0x0000` | Bit direction mask (1=output, 0=input) |

---
### `GPIO_DATA_OUT` — Address `0x0801`

**Reset value:** `0x0000`  **Access:** see fields below

GPIO output data register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GPIO_OUT` | `[15:0]` | RW | `0x0000` | Output data for pins configured as outputs |

---
### `GPIO_DATA_IN` — Address `0x0802`

**Reset value:** `0x0000`  **Access:** see fields below

GPIO input data register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GPIO_IN` | `[15:0]` | RO | `0x0000` | Read input data from pins configured as inputs |

---
### `GPIO_INT_EN` — Address `0x0803`

**Reset value:** `0x00`  **Access:** see fields below

GPIO interrupt enable mask

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `INT_EN` | `[15:0]` | RW | `0x0000` | Per-pin interrupt enable (edge-triggered) |

---
### `GPIO_INT_STATUS` — Address `0x0804`

**Reset value:** `0x00`  **Access:** see fields below

GPIO interrupt status flags

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `INT_FLAG` | `[15:0]` | RC | `0x0000` | Interrupt pending flags (clear on read) |

---
### `POWER_CTRL` — Address `0x0808`

**Reset value:** `0x00`  **Access:** see fields below

Power rail enable control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `EN_5V_RF` | `[0]` | RW | `0` | Enable 5V RF rail |
| `EN_3V3_IO` | `[1]` | RW | `0` | Enable 3.3V IO rail |
| `EN_1V25_ADC` | `[2]` | RW | `0` | Enable 1.25V ADC core rail |
| `EN_2V5_ADC` | `[3]` | RW | `0` | Enable 2.5V ADC IO rail |

---
### `SYSTEM_RESET` — Address `0x080F`

**Reset value:** `0x00`  **Access:** see fields below

System reset control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `SOFT_RESET` | `[0]` | RW | `0` | Trigger soft reset (self-clearing) |
| `RF_RST` | `[1]` | RW | `0` | Reset RF front end |
| `ADC_RST` | `[2]` | RW | `0` | Reset ADC interface |
| `CLK_RST` | `[3]` | RW | `0` | Reset clock generation |

---
### `AGC_CTRL` — Address `0x0900`

**Reset value:** `0x00`  **Access:** see fields below

Automatic Gain Control (AGC) enable and config

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `AGC_EN` | `[0]` | RW | `0` | Enable automatic gain control loop |
| `TARGET_LEVEL` | `[7:4]` | RW | `0x8` | Target signal level (0-15 scale) |
| `ATTACK_RATE` | `[11:8]` | RW | `0x5` | Attack rate for gain increase |

---
### `DAC_OUTPUT` — Address `0x0901`

**Reset value:** `0x8000`  **Access:** see fields below

Auxiliary DAC output control (16-bit)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DAC_VALUE` | `[15:0]` | RW | `0x8000` | 16-bit DAC output word (mid-scale = 0x8000) |

---
### `CAL_DATA` — Address `0x0902`

**Reset value:** `0x00`  **Access:** see fields below

Calibration data storage register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `CAL_VALID` | `[0]` | RW | `0` | Calibration data valid flag |
| `CAL_VERSION` | `[7:4]` | RW | `0x1` | Calibration version number |
| `RSERVED` | `[15:8]` | RW | `0x00` | Reserved for future use |
