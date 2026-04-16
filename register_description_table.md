# Register Description Table (RDT)
## kjk

> **Total registers:** 55

kjk Wideband RF Receiver — Complete Register Map (26 registers) covering Board ID, Communication (UART/Ethernet), ADC/Power Monitoring (8 rails), Temperature (3 sensors), PLL/Clock (3 outputs), RF Control (Synth/Mixer/AGC), DAC (2 ch), EEPROM, Configuration/User Flash, and GPIO. Includes 16-step Power-On Self-Test and Initialisation Sequence.

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
| `0x0000` | `BOARD_ID` | — | `0x4B4A` | Board identification code (ASCII 'KJ') |
| `0x0001` | `BOARD_VERSION` | — | `0x10` | Hardware revision number |
| `0x0002` | `BOARD_TYPE_ID` | — | `0x5246` | Board type identifier (ASCII 'RF' for Receiver) |
| `0x0003` | `SCRATCHPAD` | — | `0x0000` | Read/write test register for RAM diagnostics |
| `0x0010` | `MCS_VERSION_MAJOR` | — | `0x01` | FPGA firmware major version |
| `0x0011` | `MCS_VERSION_MINOR` | — | `0x00` | FPGA firmware minor version |
| `0x0012` | `BUILD_DATE` | — | `0x20260417` | Firmware build date (packed BCD: YYYYMMDD) |
| `0x0100` | `UART_BAUD_DIV` | — | `0x0034` | UART baud rate divisor (default 115200 @ 100MHz) |
| `0x0101` | `UART_CTRL` | — | `0x00` | UART control register |
| `0x0102` | `UART_STATUS` | — | `0x00` | UART status flags |
| `0x0103` | `UART_TX_COUNT` | — | `0x00` | TX FIFO byte count |
| `0x0104` | `UART_RX_COUNT` | — | `0x00` | RX FIFO byte count |
| `0x0110` | `ETH_MAC_LOW` | — | `0x0000` | Ethernet MAC address lower 16 bits |
| `0x0111` | `ETH_MAC_HIGH` | — | `0x0000` | Ethernet MAC address upper 16 bits |
| `0x0200` | `ADC_CTRL` | — | `0x00` | ADC control for power monitoring |
| `0x0201` | `ADC_STATUS` | — | `0x00` | ADC status flags |
| `0x0210` | `VCC_5V_RAW` | — | `0x0000` | 5V rail ADC count (multiply by 5.0/4096 for Volts) |
| `0x0211` | `VCC_3V3_RAW` | — | `0x0000` | 3.3V rail ADC count |
| `0x0212` | `VCC_2V5_RAW` | — | `0x0000` | 2.5V rail ADC count |
| `0x0213` | `VCC_1V8_RAW` | — | `0x0000` | 1.8V rail ADC count |
| `0x0218` | `ICC_5V_RAW` | — | `0x0000` | 5V rail current ADC count |
| `0x0219` | `ICC_3V3_RAW` | — | `0x0000` | 3.3V rail current ADC count |
| `0x0300` | `TEMP_LOCAL` | — | `0x0000` | FPGA die temperature (0.25°C units, signed) |
| `0x0301` | `TEMP_REMOTE1` | — | `0x0000` | Remote sensor 1 (ADT7420) temperature |
| `0x0302` | `TEMP_REMOTE2` | — | `0x0000` | Remote sensor 2 temperature |
| `0x0308` | `TEMP_ALERT_HIGH` | — | `0x0190` | Over-temperature alert threshold (default 100°C) |
| `0x0309` | `TEMP_ALERT_LOW` | — | `0xFF9C` | Under-temperature alert threshold (default -25°C) |
| `0x030F` | `HEALTH_STATUS` | — | `0x80` | System health status summary |
| `0x0400` | `PLL_CTRL` | — | `0x00` | PLL control register |
| `0x0401` | `PLL_STATUS` | — | `0x00` | PLL status flags |
| `0x0402` | `PLL_N_DIV` | — | `0x0064` | PLL N divider (default 100) |
| `0x0403` | `PLL_R_DIV` | — | `0x0001` | PLL R divider (default 1) |
| `0x0410` | `CLK_ENABLE` | — | `0x00` | Clock output enables (one bit per output) |
| `0x0700` | `RF_SYNTH_CTRL` | — | `0x00` | RF Synthesizer control (ADF5356) |
| `0x0701` | `RF_SYNTH_FREQ` | — | `0x09C4` | Synthesizer frequency control (MHz, default 2500) |
| `0x0702` | `RF_SYNTH_STATUS` | — | `0x00` | RF Synthesizer status |
| `0x0708` | `MIXER_CTRL` | — | `0x00` | Mixer control (HMC1049LC4) |
| `0x0709` | `LNA_CTRL` | — | `0x00` | LNA control (HMC698LP4) |
| `0x070A` | `RF_AGC_CTRL` | — | `0x00` | Automatic Gain Control register |
| `0x0900` | `DAC0_CTRL` | — | `0x00` | DAC Channel 0 control |
| `0x0901` | `DAC0_DATA` | — | `0x0000` | DAC Channel 0 output value |
| `0x0902` | `DAC1_CTRL` | — | `0x00` | DAC Channel 1 control |
| `0x0903` | `DAC1_DATA` | — | `0x0000` | DAC Channel 1 output value |
| `0x0800` | `GPIO_DIR` | — | `0x0000` | GPIO direction control (0=input, 1=output) |
| `0x0801` | `GPIO_DATA` | — | `0x0000` | GPIO data register |
| `0x0802` | `GPIO_SET` | — | `0x0000` | GPIO set bits (write 1 to set output) |
| `0x0803` | `GPIO_CLR` | — | `0x0000` | GPIO clear bits (write 1 to clear output) |
| `0x0500` | `EEPROM_CTRL` | — | `0x00` | EEPROM control register |
| `0x0501` | `EEPROM_ADDR` | — | `0x0000` | EEPROM byte address |
| `0x0502` | `EEPROM_DATA` | — | `0x0000` | EEPROM read/write data |
| `0x0600` | `FLASH_CTRL` | — | `0x00` | Configuration Flash control (IS25LP256D) |
| `0x0601` | `FLASH_ADDR_LOW` | — | `0x0000` | Flash address low word |
| `0x0602` | `FLASH_ADDR_HIGH` | — | `0x0000` | Flash address high byte |
| `0x0603` | `FLASH_DATA` | — | `0x0000` | Flash data FIFO |
| `0x0604` | `FLASH_STATUS` | — | `0x01` | Flash status register |

---
### `BOARD_ID` — Address `0x0000`

**Reset value:** `0x4B4A`  **Access:** see fields below

Board identification code (ASCII 'KJ')

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BOARD_ID` | `[15:0]` | R | `0x4B4A` | Board ID for kjk project (0x4B4A = 'KJ') |

---
### `BOARD_VERSION` — Address `0x0001`

**Reset value:** `0x10`  **Access:** see fields below

Hardware revision number

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAJOR` | `[7:4]` | R | `0x1` | Major revision (1 = v1.0) |
| `MINOR` | `[3:0]` | R | `0x0` | Minor revision (0 = v1.0) |

---
### `BOARD_TYPE_ID` — Address `0x0002`

**Reset value:** `0x5246`  **Access:** see fields below

Board type identifier (ASCII 'RF' for Receiver)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TYPE_ID` | `[15:0]` | R | `0x5246` | Board type code (0x5246 = 'RF') |

---
### `SCRATCHPAD` — Address `0x0003`

**Reset value:** `0x0000`  **Access:** see fields below

Read/write test register for RAM diagnostics

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEST_DATA` | `[15:0]` | RW | `0x0000` | General-purpose test register |

---
### `MCS_VERSION_MAJOR` — Address `0x0010`

**Reset value:** `0x01`  **Access:** see fields below

FPGA firmware major version

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAJOR_VER` | `[7:0]` | R | `0x01` | Major firmware version number |

---
### `MCS_VERSION_MINOR` — Address `0x0011`

**Reset value:** `0x00`  **Access:** see fields below

FPGA firmware minor version

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MINOR_VER` | `[7:0]` | R | `0x00` | Minor firmware version number |

---
### `BUILD_DATE` — Address `0x0012`

**Reset value:** `0x20260417`  **Access:** see fields below

Firmware build date (packed BCD: YYYYMMDD)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `YYYY` | `[15:12]` | R | `0x2` | Year decade |
| `YY` | `[11:8]` | R | `0x0` | Year (26) |
| `MM` | `[7:4]` | R | `0x4` | Month (04) |
| `DD` | `[3:0]` | R | `0x1` | Day low nibble (17) |

---
### `UART_BAUD_DIV` — Address `0x0100`

**Reset value:** `0x0034`  **Access:** see fields below

UART baud rate divisor (default 115200 @ 100MHz)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DIVISOR` | `[15:0]` | RW | `0x0034` | Baud = CLK / (16 * DIV) |

---
### `UART_CTRL` — Address `0x0101`

**Reset value:** `0x00`  **Access:** see fields below

UART control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0` | UART enable (1=enabled) |
| `LOOPBACK` | `[1]` | RW | `0` | Loopback mode for test |
| `FRAME_FORMAT` | `[7:4]` | RW | `0x3` | Frame format (0x3=8N1) |

---
### `UART_STATUS` — Address `0x0102`

**Reset value:** `0x00`  **Access:** see fields below

UART status flags

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TX_BUSY` | `[0]` | R | `0` | Transmitter busy |
| `RX_AVAIL` | `[1]` | R | `0` | RX data available |
| `FRAME_ERR` | `[2]` | RC | `0` | Frame error (clear on read) |

---
### `UART_TX_COUNT` — Address `0x0103`

**Reset value:** `0x00`  **Access:** see fields below

TX FIFO byte count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TX_COUNT` | `[7:0]` | R | `0x00` | Number of bytes in TX FIFO |

---
### `UART_RX_COUNT` — Address `0x0104`

**Reset value:** `0x00`  **Access:** see fields below

RX FIFO byte count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `RX_COUNT` | `[7:0]` | R | `0x00` | Number of bytes in RX FIFO |

---
### `ETH_MAC_LOW` — Address `0x0110`

**Reset value:** `0x0000`  **Access:** see fields below

Ethernet MAC address lower 16 bits

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAC_LOW` | `[15:0]` | R | `0x0000` | MAC[15:0] |

---
### `ETH_MAC_HIGH` — Address `0x0111`

**Reset value:** `0x0000`  **Access:** see fields below

Ethernet MAC address upper 16 bits

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAC_HIGH` | `[15:0]` | R | `0x0000` | MAC[31:16] |

---
### `ADC_CTRL` — Address `0x0200`

**Reset value:** `0x00`  **Access:** see fields below

ADC control for power monitoring

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `START` | `[0]` | RW | `0` | Start ADC conversion |
| `CONTINUOUS` | `[1]` | RW | `0` | Continuous mode (1=enabled) |
| `CHANNEL_SEL` | `[3:2]` | RW | `0x0` | Channel select (0-3) |

---
### `ADC_STATUS` — Address `0x0201`

**Reset value:** `0x00`  **Access:** see fields below

ADC status flags

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA_READY` | `[0]` | R | `0` | Conversion data ready |
| `OVERRANGE` | `[1]` | RC | `0` | ADC overrange detected |

---
### `VCC_5V_RAW` — Address `0x0210`

**Reset value:** `0x0000`  **Access:** see fields below

5V rail ADC count (multiply by 5.0/4096 for Volts)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | R | `0x000` | 12-bit ADC count |

---
### `VCC_3V3_RAW` — Address `0x0211`

**Reset value:** `0x0000`  **Access:** see fields below

3.3V rail ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | R | `0x000` | 12-bit ADC count |

---
### `VCC_2V5_RAW` — Address `0x0212`

**Reset value:** `0x0000`  **Access:** see fields below

2.5V rail ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | R | `0x000` | 12-bit ADC count |

---
### `VCC_1V8_RAW` — Address `0x0213`

**Reset value:** `0x0000`  **Access:** see fields below

1.8V rail ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | R | `0x000` | 12-bit ADC count |

---
### `ICC_5V_RAW` — Address `0x0218`

**Reset value:** `0x0000`  **Access:** see fields below

5V rail current ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | R | `0x000` | 12-bit ADC count |

---
### `ICC_3V3_RAW` — Address `0x0219`

**Reset value:** `0x0000`  **Access:** see fields below

3.3V rail current ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | R | `0x000` | 12-bit ADC count |

---
### `TEMP_LOCAL` — Address `0x0300`

**Reset value:** `0x0000`  **Access:** see fields below

FPGA die temperature (0.25°C units, signed)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP` | `[9:0]` | R | `0x000` | Temperature in 0.25°C units (signed 10-bit) |

---
### `TEMP_REMOTE1` — Address `0x0301`

**Reset value:** `0x0000`  **Access:** see fields below

Remote sensor 1 (ADT7420) temperature

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP` | `[9:0]` | R | `0x000` | Temperature in 0.25°C units (signed 10-bit) |

---
### `TEMP_REMOTE2` — Address `0x0302`

**Reset value:** `0x0000`  **Access:** see fields below

Remote sensor 2 temperature

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP` | `[9:0]` | R | `0x000` | Temperature in 0.25°C units (signed 10-bit) |

---
### `TEMP_ALERT_HIGH` — Address `0x0308`

**Reset value:** `0x0190`  **Access:** see fields below

Over-temperature alert threshold (default 100°C)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `THRESHOLD` | `[9:0]` | RW | `0x0190` | Alert threshold (0x0190 = 100°C) |

---
### `TEMP_ALERT_LOW` — Address `0x0309`

**Reset value:** `0xFF9C`  **Access:** see fields below

Under-temperature alert threshold (default -25°C)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `THRESHOLD` | `[9:0]` | RW | `0xFF9C` | Alert threshold (0xFF9C = -25°C) |

---
### `HEALTH_STATUS` — Address `0x030F`

**Reset value:** `0x80`  **Access:** see fields below

System health status summary

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_OK` | `[0]` | R | `0` | Temperature within limits |
| `VOLT_OK` | `[1]` | R | `0` | All voltages within limits |
| `PLL_LOCK` | `[2]` | R | `0` | PLL locked |
| `SYSTEM_OK` | `[7]` | R | `1` | System overall OK |

---
### `PLL_CTRL` — Address `0x0400`

**Reset value:** `0x00`  **Access:** see fields below

PLL control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0` | PLL enable (1=enabled) |
| `RESET` | `[1]` | RW | `0` | PLL reset (active high) |
| `REF_SEL` | `[3:2]` | RW | `0x0` | Reference clock select (0-3) |

---
### `PLL_STATUS` — Address `0x0401`

**Reset value:** `0x00`  **Access:** see fields below

PLL status flags

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LOCKED` | `[0]` | R | `0` | PLL locked indicator |
| `LOSS_OF_LOCK` | `[1]` | RC | `0` | Loss of lock detected (clear on read) |

---
### `PLL_N_DIV` — Address `0x0402`

**Reset value:** `0x0064`  **Access:** see fields below

PLL N divider (default 100)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `N_DIV` | `[15:0]` | RW | `0x0064` | N divider value (PLL frequency multiplier) |

---
### `PLL_R_DIV` — Address `0x0403`

**Reset value:** `0x0001`  **Access:** see fields below

PLL R divider (default 1)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `R_DIV` | `[7:0]` | RW | `0x01` | R divider value (reference divider) |

---
### `CLK_ENABLE` — Address `0x0410`

**Reset value:** `0x00`  **Access:** see fields below

Clock output enables (one bit per output)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `CLK0_EN` | `[0]` | RW | `0` | Clock output 0 enable |
| `CLK1_EN` | `[1]` | RW | `0` | Clock output 1 enable (ADC) |

---
### `RF_SYNTH_CTRL` — Address `0x0700`

**Reset value:** `0x00`  **Access:** see fields below

RF Synthesizer control (ADF5356)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0` | Synth enable (1=enabled) |
| `MUXOUT_EN` | `[1]` | RW | `0` | MUXOUT enable for lock detect |

---
### `RF_SYNTH_FREQ` — Address `0x0701`

**Reset value:** `0x09C4`  **Access:** see fields below

Synthesizer frequency control (MHz, default 2500)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `FREQ_MHZ` | `[15:0]` | RW | `0x09C4` | Frequency in MHz (0x09C4 = 2500 MHz) |

---
### `RF_SYNTH_STATUS` — Address `0x0702`

**Reset value:** `0x00`  **Access:** see fields below

RF Synthesizer status

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LOCKED` | `[0]` | R | `0` | Synth locked indicator |

---
### `MIXER_CTRL` — Address `0x0708`

**Reset value:** `0x00`  **Access:** see fields below

Mixer control (HMC1049LC4)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0` | Mixer enable (1=enabled) |
| `LO_BYPASS` | `[1]` | RW | `0` | LO bypass mode |

---
### `LNA_CTRL` — Address `0x0709`

**Reset value:** `0x00`  **Access:** see fields below

LNA control (HMC698LP4)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0` | LNA enable (1=enabled) |
| `GAIN_STEP` | `[3:1]` | RW | `0x0` | Gain step select (0-7) |

---
### `RF_AGC_CTRL` — Address `0x070A`

**Reset value:** `0x00`  **Access:** see fields below

Automatic Gain Control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0` | AGC enable (1=enabled) |
| `TARGET_LEVEL` | `[7:4]` | RW | `0x8` | Target level (0-15) |

---
### `DAC0_CTRL` — Address `0x0900`

**Reset value:** `0x00`  **Access:** see fields below

DAC Channel 0 control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0` | DAC channel 0 enable |
| `OUTPUT_EN` | `[1]` | RW | `0` | Output buffer enable |

---
### `DAC0_DATA` — Address `0x0901`

**Reset value:** `0x0000`  **Access:** see fields below

DAC Channel 0 output value

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DAC_VALUE` | `[15:0]` | RW | `0x0000` | 16-bit DAC output code |

---
### `DAC1_CTRL` — Address `0x0902`

**Reset value:** `0x00`  **Access:** see fields below

DAC Channel 1 control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0` | DAC channel 1 enable |
| `OUTPUT_EN` | `[1]` | RW | `0` | Output buffer enable |

---
### `DAC1_DATA` — Address `0x0903`

**Reset value:** `0x0000`  **Access:** see fields below

DAC Channel 1 output value

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DAC_VALUE` | `[15:0]` | RW | `0x0000` | 16-bit DAC output code |

---
### `GPIO_DIR` — Address `0x0800`

**Reset value:** `0x0000`  **Access:** see fields below

GPIO direction control (0=input, 1=output)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GPIO_DIR` | `[15:0]` | RW | `0x0000` | GPIO direction bits |

---
### `GPIO_DATA` — Address `0x0801`

**Reset value:** `0x0000`  **Access:** see fields below

GPIO data register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GPIO_DATA` | `[15:0]` | RW | `0x0000` | GPIO data (read/write) |

---
### `GPIO_SET` — Address `0x0802`

**Reset value:** `0x0000`  **Access:** see fields below

GPIO set bits (write 1 to set output)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GPIO_SET` | `[15:0]` | W | `0x0000` | Write 1 to set corresponding output bit |

---
### `GPIO_CLR` — Address `0x0803`

**Reset value:** `0x0000`  **Access:** see fields below

GPIO clear bits (write 1 to clear output)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GPIO_CLR` | `[15:0]` | W | `0x0000` | Write 1 to clear corresponding output bit |

---
### `EEPROM_CTRL` — Address `0x0500`

**Reset value:** `0x00`  **Access:** see fields below

EEPROM control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READ` | `[0]` | RW | `0` | Initiate read (1=start) |
| `WRITE` | `[1]` | RW | `0` | Initiate write (1=start) |
| `ERASE` | `[2]` | RW | `0` | Initiate erase (1=start) |
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
| `DATA` | `[15:0]` | RW | `0x0000` | 16-bit data value |

---
### `FLASH_CTRL` — Address `0x0600`

**Reset value:** `0x00`  **Access:** see fields below

Configuration Flash control (IS25LP256D)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READ` | `[0]` | RW | `0` | Flash read enable |
| `WRITE` | `[1]` | RW | `0` | Flash write enable |
| `ERASE_SECTOR` | `[2]` | RW | `0` | Erase sector (1=start) |
| `ERASE_CHIP` | `[3]` | RW | `0` | Erase chip (1=start) |
| `BUSY` | `[7]` | R | `0` | Flash busy flag |

---
### `FLASH_ADDR_LOW` — Address `0x0601`

**Reset value:** `0x0000`  **Access:** see fields below

Flash address low word

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADDR_LOW` | `[15:0]` | RW | `0x0000` | Flash address[15:0] |

---
### `FLASH_ADDR_HIGH` — Address `0x0602`

**Reset value:** `0x0000`  **Access:** see fields below

Flash address high byte

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADDR_HIGH` | `[7:0]` | RW | `0x00` | Flash address[23:16] |

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

Flash status register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READY` | `[0]` | R | `1` | Flash ready |
| `WRITE_ERR` | `[1]` | RC | `0` | Write error flag (clear on read) |
| `ERASE_ERR` | `[2]` | RC | `0` | Erase error flag (clear on read) |
