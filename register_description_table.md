# Register Description Table (RDT)
## rf tx

> **Total registers:** 66

RDT/PSQ for rf tx Wideband Microwave Receiver (XC7A35T-FTG256). Map organized by BASE address groups with 16-bit UART addressing (bit15=R/W#, bits11:8=BASE, bits7:0=OFFSET). Includes board info, UART, SPI passthrough to HMC698LP4 (VGA) and HMC830LP6GE (LO synthesizer), ADC/JESD204B link status, supply monitoring, temperature, PLL/MMCM health, EEPROM, Flash, GPIO, and application-specific RF path control. PSQ spans POR, clock init, peripheral enable, communication, and RF chain bring-up.

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
| `0x0000` | `BOARD_ID` | — | `0x5246` | Board identification code - ASCII 'RF' for rf tx project |
| `0x0001` | `BOARD_VERSION` | — | `0x01` | Hardware version number |
| `0x0002` | `BOARD_TYPE_ID` | — | `0x5254` | Board type identifier - ASCII 'RT' for rf tx |
| `0x0003` | `SCRATCHPAD` | — | `0x0000` | Read/write test register for RAM verification |
| `0x0010` | `MCS_VERSION_MAJOR` | — | `0x01` | FPGA firmware major version |
| `0x0011` | `MCS_VERSION_MINOR` | — | `0x00` | FPGA firmware minor version |
| `0x0012` | `BUILD_DATE` | — | `0x20260414` | Build date in packed BCD format (YYYYMMDD) |
| `0x0100` | `UART_BAUD_DIV` | — | `0x0068` | UART baud rate divisor for 115200bps (ref_clk=16MHz) |
| `0x0101` | `UART_CTRL` | — | `0x00` | UART control register |
| `0x0102` | `UART_STATUS` | — | `0x00` | UART status flags |
| `0x0103` | `UART_TX_COUNT` | — | `0x00` | TX FIFO byte count |
| `0x0104` | `UART_RX_COUNT` | — | `0x00` | RX FIFO byte count |
| `0x0110` | `ETH_MAC_LOW` | — | `0x0000` | Ethernet MAC address lower 16 bits (if present) |
| `0x0111` | `ETH_MAC_HIGH` | — | `0x0000` | Ethernet MAC address upper 16 bits |
| `0x0120` | `VGA_SPI_CTRL` | — | `0x00` | HMC698LP4 VGA SPI control (pass-through) |
| `0x0121` | `VGA_SPI_DATA` | — | `0x0000` | HMC698LP4 VGA SPI data (16-bit word) |
| `0x0122` | `VGA_GAIN_COARSE` | — | `0x1F` | VGA coarse gain setting (HMC698LP4 5-bit) |
| `0x0123` | `VGA_GAIN_FINE` | — | `0x3F` | VGA fine gain setting (HMC698LP4 6-bit) |
| `0x0130` | `LO_SPI_CTRL` | — | `0x00` | HMC830LP6GE LO synthesizer SPI control |
| `0x0131` | `LO_SPI_DATA` | — | `0x0000` | HMC830LP6GE LO SPI data (32-bit register) |
| `0x0132` | `LO_SPI_ADDR` | — | `0x00` | HMC830LP6GE LO register address |
| `0x0200` | `ADC_CTRL` | — | `0x00` | ADC12J4000 control via JESD204B link |
| `0x0201` | `ADC_STATUS` | — | `0x00` | ADC/JESD204B link status |
| `0x0210` | `VCC_5V_RAW` | — | `0x0000` | 5V rail ADC raw count [11:0] |
| `0x0211` | `VCC_3V3_RAW` | — | `0x0000` | 3.3V rail ADC raw count [11:0] |
| `0x0218` | `ICC_5V_RAW` | — | `0x0000` | 5V rail current ADC raw count [11:0] |
| `0x0219` | `ICC_3V3_RAW` | — | `0x0000` | 3.3V rail current ADC raw count [11:0] |
| `0x0300` | `TEMP_LOCAL` | — | `0x0190` | FPGA die temperature in 0.25°C units |
| `0x0301` | `TEMP_REMOTE1` | — | `0x0190` | Remote sensor 1 temperature (0.25°C units) |
| `0x0302` | `TEMP_REMOTE2` | — | `0x0190` | Remote sensor 2 temperature (0.25°C units) |
| `0x0308` | `TEMP_ALERT_HIGH` | — | `0x0190` | Over-temperature alert threshold (0.25°C units) |
| `0x0309` | `TEMP_ALERT_LOW` | — | `0xFF9C` | Under-temperature alert threshold (0.25°C units) |
| `0x030F` | `HEALTH_STATUS` | — | `0x00` | System health summary |
| `0x0400` | `PLL_CTRL` | — | `0x00` | PLL/MMCM control |
| `0x0401` | `PLL_STATUS` | — | `0x00` | PLL/MMCM status |
| `0x0402` | `PLL_N_DIV` | — | `0x001E` | PLL N divider (for 200MHz from 50MHz) |
| `0x0403` | `PLL_R_DIV` | — | `0x01` | PLL R divider (reference prescaler) |
| `0x0410` | `CLK_ENABLE` | — | `0x00` | Clock output enables (one bit per output) |
| `0x0500` | `EEPROM_CTRL` | — | `0x00` | EEPROM control register |
| `0x0501` | `EEPROM_ADDR` | — | `0x0000` | EEPROM byte address [15:0] |
| `0x0502` | `EEPROM_DATA` | — | `0x0000` | EEPROM read/write data [15:0] |
| `0x0600` | `FLASH_CTRL` | — | `0x00` | Configuration flash control |
| `0x0601` | `FLASH_ADDR_LOW` | — | `0x0000` | Flash address [15:0] |
| `0x0602` | `FLASH_ADDR_HIGH` | — | `0x00` | Flash address [23:16] |
| `0x0603` | `FLASH_DATA` | — | `0x0000` | Flash read/write data FIFO [15:0] |
| `0x0604` | `FLASH_STATUS` | — | `0x00` | Flash operation status |
| `0x0700` | `RF_PATH_CTRL` | — | `0x01` | RF path control for LNA, Mixer, VGA |
| `0x0701` | `RF_GAIN_SET` | — | `0x1F3F` | RF gain coarse/fine combined register |
| `0x0702` | `RF_STATUS` | — | `0x00` | RF chain status flags |
| `0x0708` | `LO_FREQ_CTRL` | — | `0x00C80000` | LO frequency control (HMC830LP6GE) |
| `0x0709` | `LO_STATUS` | — | `0x00` | LO synthesizer status (HMC830LP6GE) |
| `0x0800` | `GPIO_DIR` | — | `0x0000` | GPIO direction (0=input, 1=output) |
| `0x0801` | `GPIO_OUT` | — | `0x0000` | GPIO output data |
| `0x0802` | `GPIO_IN` | — | `0x0000` | GPIO input data |
| `0x0900` | `DAC0_DATA` | — | `0x0000` | DAC channel 0 data (12-bit) |
| `0x0901` | `DAC0_CTRL` | — | `0x01` | DAC channel 0 control |
| `0x0902` | `DAC1_DATA` | — | `0x0000` | DAC channel 1 data (12-bit) |
| `0x0903` | `DAC1_CTRL` | — | `0x00` | DAC channel 1 control |
| `0x0A00` | `DSP_CTRL` | — | `0x00` | DSP engine control (FFT, filtering) |
| `0x0A01` | `DSP_STATUS` | — | `0x00` | DSP engine status |
| `0x0A02` | `FFT_ADDR` | — | `0x0000` | FFT result address pointer |
| `0x0A03` | `FFT_DATA` | — | `0x0000` | FFT result data (magnitude) |
| `0x0A08` | `CW_DET_THRESHOLD` | — | `0x0800` | CW detection threshold (12-bit) |
| `0x0A09` | `CW_DET_FREQ` | — | `0x0000` | CW detected frequency (Hz) |
| `0x0B00` | `INTERRUPT_EN` | — | `0x00` | Interrupt enable mask |
| `0x0B01` | `INTERRUPT_STATUS` | — | `0x00` | Interrupt status flags (clear on write) |

---
### `BOARD_ID` — Address `0x0000`

**Reset value:** `0x5246`  **Access:** see fields below

Board identification code - ASCII 'RF' for rf tx project

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BOARD_ID` | `[15:0]` | R | `0x5246` | Fixed board ID (0x5246 = 'RF') |

---
### `BOARD_VERSION` — Address `0x0001`

**Reset value:** `0x01`  **Access:** see fields below

Hardware version number

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAJOR` | `[7:4]` | R | `0x0` | Major version |
| `MINOR` | `[3:0]` | R | `0x1` | Minor version |

---
### `BOARD_TYPE_ID` — Address `0x0002`

**Reset value:** `0x5254`  **Access:** see fields below

Board type identifier - ASCII 'RT' for rf tx

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TYPE_ID` | `[15:0]` | R | `0x5254` | Board type (0x5254 = 'RT') |

---
### `SCRATCHPAD` — Address `0x0003`

**Reset value:** `0x0000`  **Access:** see fields below

Read/write test register for RAM verification

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEST_DATA` | `[15:0]` | RW | `0x0000` | Test pattern data |

---
### `MCS_VERSION_MAJOR` — Address `0x0010`

**Reset value:** `0x01`  **Access:** see fields below

FPGA firmware major version

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAJOR_VER` | `[7:0]` | R | `0x01` | Major firmware version |

---
### `MCS_VERSION_MINOR` — Address `0x0011`

**Reset value:** `0x00`  **Access:** see fields below

FPGA firmware minor version

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MINOR_VER` | `[7:0]` | R | `0x00` | Minor firmware version |

---
### `BUILD_DATE` — Address `0x0012`

**Reset value:** `0x20260414`  **Access:** see fields below

Build date in packed BCD format (YYYYMMDD)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BUILD_BCD` | `[31:0]` | R | `0x20260414` | Build date (2026-04-14) |

---
### `UART_BAUD_DIV` — Address `0x0100`

**Reset value:** `0x0068`  **Access:** see fields below

UART baud rate divisor for 115200bps (ref_clk=16MHz)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DIVISOR` | `[15:0]` | RW | `0x0068` | Baud rate divisor = fclk/(16*baudrate) |

---
### `UART_CTRL` — Address `0x0101`

**Reset value:** `0x00`  **Access:** see fields below

UART control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0` | UART enable (1=enabled) |
| `LOOPBACK` | `[1]` | RW | `0` | Internal loopback mode |
| `FRAME_FORMAT` | `[7:4]` | RW | `0x0` | Frame format (0=8N1) |
| `RSVD` | `[15:8]` | R | `0x00` | Reserved |

---
### `UART_STATUS` — Address `0x0102`

**Reset value:** `0x00`  **Access:** see fields below

UART status flags

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TX_BUSY` | `[0]` | R | `0` | TX FIFO in use |
| `RX_AVAIL` | `[1]` | R | `0` | RX data available |
| `FRAME_ERR` | `[2]` | RC | `0` | Frame error (clear on read) |
| `RSVD` | `[15:3]` | R | `0x00` | Reserved |

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

Ethernet MAC address lower 16 bits (if present)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAC_LSB` | `[15:0]` | R | `0x0000` | MAC address [15:0] |

---
### `ETH_MAC_HIGH` — Address `0x0111`

**Reset value:** `0x0000`  **Access:** see fields below

Ethernet MAC address upper 16 bits

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAC_MSB` | `[15:0]` | R | `0x0000` | MAC address [31:16] |

---
### `VGA_SPI_CTRL` — Address `0x0120`

**Reset value:** `0x00`  **Access:** see fields below

HMC698LP4 VGA SPI control (pass-through)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `CS_N` | `[0]` | RW | `1` | VGA SPI chip select (active low) |
| `LE` | `[1]` | RW | `0` | VGA latch enable pulse |
| `RW_FLAG` | `[2]` | RW | `0` | VGA read/write flag (1=write) |
| `RSVD` | `[15:3]` | R | `0x00` | Reserved |

---
### `VGA_SPI_DATA` — Address `0x0121`

**Reset value:** `0x0000`  **Access:** see fields below

HMC698LP4 VGA SPI data (16-bit word)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `VGA_DATA` | `[15:0]` | RW | `0x0000` | VGA SPI 16-bit data word |

---
### `VGA_GAIN_COARSE` — Address `0x0122`

**Reset value:** `0x1F`  **Access:** see fields below

VGA coarse gain setting (HMC698LP4 5-bit)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `COARSE_GAIN` | `[4:0]` | RW | `0x1F` | Coarse gain (0-31) |
| `RSVD` | `[15:5]` | R | `0x00` | Reserved |

---
### `VGA_GAIN_FINE` — Address `0x0123`

**Reset value:** `0x3F`  **Access:** see fields below

VGA fine gain setting (HMC698LP4 6-bit)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `FINE_GAIN` | `[5:0]` | RW | `0x3F` | Fine gain (0-63) |
| `RSVD` | `[15:6]` | R | `0x00` | Reserved |

---
### `LO_SPI_CTRL` — Address `0x0130`

**Reset value:** `0x00`  **Access:** see fields below

HMC830LP6GE LO synthesizer SPI control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `CS_N` | `[0]` | RW | `1` | LO SPI chip select (active low) |
| `RW_FLAG` | `[1]` | RW | `0` | LO read/write flag (1=write) |
| `ADDR_LEN` | `[2]` | RW | `0` | Address length (0=8-bit, 1=16-bit) |
| `RSVD` | `[15:3]` | R | `0x00` | Reserved |

---
### `LO_SPI_DATA` — Address `0x0131`

**Reset value:** `0x0000`  **Access:** see fields below

HMC830LP6GE LO SPI data (32-bit register)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LO_DATA` | `[15:0]` | RW | `0x0000` | LO SPI data [15:0] (LSW) |

---
### `LO_SPI_ADDR` — Address `0x0132`

**Reset value:** `0x00`  **Access:** see fields below

HMC830LP6GE LO register address

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LO_ADDR` | `[7:0]` | RW | `0x00` | LO SPI register address |

---
### `ADC_CTRL` — Address `0x0200`

**Reset value:** `0x00`  **Access:** see fields below

ADC12J4000 control via JESD204B link

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `START` | `[0]` | RW | `0` | Start ADC acquisition |
| `CONTINUOUS` | `[1]` | RW | `0` | Continuous mode |
| `CH_SELECT` | `[3:2]` | RW | `0x0` | Channel select (virtual) |
| `RSVD` | `[15:4]` | R | `0x00` | Reserved |

---
### `ADC_STATUS` — Address `0x0201`

**Reset value:** `0x00`  **Access:** see fields below

ADC/JESD204B link status

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA_READY` | `[0]` | R | `0` | ADC data ready flag |
| `OVERRANGE` | `[1]` | RC | `0` | ADC overrange flag |
| `JESD_LINK` | `[2]` | R | `0` | JESD204B link up (1=locked) |
| `RSVD` | `[15:3]` | R | `0x00` | Reserved |

---
### `VCC_5V_RAW` — Address `0x0210`

**Reset value:** `0x0000`  **Access:** see fields below

5V rail ADC raw count [11:0]

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_5V` | `[11:0]` | R | `0x000` | 5V rail ADC count (x5.0/4096 = Volts) |
| `RSVD` | `[15:12]` | R | `0x0` | Reserved |

---
### `VCC_3V3_RAW` — Address `0x0211`

**Reset value:** `0x0000`  **Access:** see fields below

3.3V rail ADC raw count [11:0]

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_3V3` | `[11:0]` | R | `0x000` | 3.3V rail ADC count (x3.3/4096 = Volts) |
| `RSVD` | `[15:12]` | R | `0x0` | Reserved |

---
### `ICC_5V_RAW` — Address `0x0218`

**Reset value:** `0x0000`  **Access:** see fields below

5V rail current ADC raw count [11:0]

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_I5V` | `[11:0]` | R | `0x000` | 5V rail current ADC count |
| `RSVD` | `[15:12]` | R | `0x0` | Reserved |

---
### `ICC_3V3_RAW` — Address `0x0219`

**Reset value:** `0x0000`  **Access:** see fields below

3.3V rail current ADC raw count [11:0]

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_I3V3` | `[11:0]` | R | `0x000` | 3.3V rail current ADC count |
| `RSVD` | `[15:12]` | R | `0x0` | Reserved |

---
### `TEMP_LOCAL` — Address `0x0300`

**Reset value:** `0x0190`  **Access:** see fields below

FPGA die temperature in 0.25°C units

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP` | `[9:0]` | R | `0x0190` | Temperature x4 (signed) [9:0] |
| `RSVD` | `[15:10]` | R | `0x00` | Reserved |

---
### `TEMP_REMOTE1` — Address `0x0301`

**Reset value:** `0x0190`  **Access:** see fields below

Remote sensor 1 temperature (0.25°C units)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_R1` | `[9:0]` | R | `0x0190` | Remote temp x4 (signed) [9:0] |
| `RSVD` | `[15:10]` | R | `0x00` | Reserved |

---
### `TEMP_REMOTE2` — Address `0x0302`

**Reset value:** `0x0190`  **Access:** see fields below

Remote sensor 2 temperature (0.25°C units)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_R2` | `[9:0]` | R | `0x0190` | Remote temp x4 (signed) [9:0] |
| `RSVD` | `[15:10]` | R | `0x00` | Reserved |

---
### `TEMP_ALERT_HIGH` — Address `0x0308`

**Reset value:** `0x0190`  **Access:** see fields below

Over-temperature alert threshold (0.25°C units)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ALERT_HI` | `[9:0]` | RW | `0x0190` | Alert threshold x4 (100°C = 0x0190) |
| `RSVD` | `[15:10]` | R | `0x00` | Reserved |

---
### `TEMP_ALERT_LOW` — Address `0x0309`

**Reset value:** `0xFF9C`  **Access:** see fields below

Under-temperature alert threshold (0.25°C units)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ALERT_LO` | `[9:0]` | RW | `0xFF9C` | Alert threshold x4 (-25°C = 0xFF9C) |
| `RSVD` | `[15:10]` | R | `0x00` | Reserved |

---
### `HEALTH_STATUS` — Address `0x030F`

**Reset value:** `0x00`  **Access:** see fields below

System health summary

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_OK` | `[0]` | R | `0` | Temperature within limits |
| `VOLT_OK` | `[1]` | R | `0` | Power rails OK |
| `PLL_LOCK` | `[2]` | R | `0` | PLL/MMCM locked |
| `JESD_OK` | `[3]` | R | `0` | JESD204B link healthy |
| `SYSTEM_OK` | `[7]` | R | `0` | Overall system health |
| `RSVD` | `[15:8]` | R | `0x00` | Reserved |

---
### `PLL_CTRL` — Address `0x0400`

**Reset value:** `0x00`  **Access:** see fields below

PLL/MMCM control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0` | PLL enable (1=on) |
| `RESET` | `[1]` | RW | `0` | PLL reset (active high) |
| `REF_SEL` | `[3:2]` | RW | `0x0` | Reference clock select |
| `RSVD` | `[15:4]` | R | `0x00` | Reserved |

---
### `PLL_STATUS` — Address `0x0401`

**Reset value:** `0x00`  **Access:** see fields below

PLL/MMCM status

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LOCKED` | `[0]` | R | `0` | PLL locked (1=locked) |
| `LOSS_OF_LOCK` | `[1]` | RC | `0` | Loss of lock flag (clear on read) |
| `RSVD` | `[15:2]` | R | `0x00` | Reserved |

---
### `PLL_N_DIV` — Address `0x0402`

**Reset value:** `0x001E`  **Access:** see fields below

PLL N divider (for 200MHz from 50MHz)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `N_DIV` | `[15:0]` | RW | `0x001E` | N divider value (30) |

---
### `PLL_R_DIV` — Address `0x0403`

**Reset value:** `0x01`  **Access:** see fields below

PLL R divider (reference prescaler)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `R_DIV` | `[7:0]` | RW | `0x01` | R divider value |
| `RSVD` | `[15:8]` | R | `0x00` | Reserved |

---
### `CLK_ENABLE` — Address `0x0410`

**Reset value:** `0x00`  **Access:** see fields below

Clock output enables (one bit per output)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `CLK_OUT0` | `[0]` | RW | `0` | Clock output 0 (ADC sample clock) |
| `CLK_OUT1` | `[1]` | RW | `0` | Clock output 1 (JESD204B lane) |
| `CLK_OUT2` | `[2]` | RW | `0` | Clock output 2 (sys_clk) |
| `CLK_OUT3` | `[3]` | RW | `0` | Clock output 3 (reserved) |
| `RSVD` | `[15:4]` | R | `0x00` | Reserved |

---
### `EEPROM_CTRL` — Address `0x0500`

**Reset value:** `0x00`  **Access:** see fields below

EEPROM control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READ` | `[0]` | RW | `0` | Start read (self-clearing) |
| `WRITE` | `[1]` | RW | `0` | Start write (self-clearing) |
| `ERASE` | `[2]` | RW | `0` | Erase command (self-clearing) |
| `BUSY` | `[7]` | R | `0` | EEPROM busy flag |
| `RSVD` | `[15:8]` | R | `0x00` | Reserved |

---
### `EEPROM_ADDR` — Address `0x0501`

**Reset value:** `0x0000`  **Access:** see fields below

EEPROM byte address [15:0]

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADDR` | `[15:0]` | RW | `0x0000` | EEPROM byte address |

---
### `EEPROM_DATA` — Address `0x0502`

**Reset value:** `0x0000`  **Access:** see fields below

EEPROM read/write data [15:0]

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA` | `[15:0]` | RW | `0x0000` | EEPROM data word |

---
### `FLASH_CTRL` — Address `0x0600`

**Reset value:** `0x00`  **Access:** see fields below

Configuration flash control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READ` | `[0]` | RW | `0` | Start read (self-clearing) |
| `WRITE` | `[1]` | RW | `0` | Start write (self-clearing) |
| `ERASE_SECTOR` | `[2]` | RW | `0` | Erase sector (self-clearing) |
| `ERASE_CHIP` | `[3]` | RW | `0` | Erase chip (self-clearing) |
| `BUSY` | `[7]` | R | `0` | Flash busy flag |
| `RSVD` | `[15:8]` | R | `0x00` | Reserved |

---
### `FLASH_ADDR_LOW` — Address `0x0601`

**Reset value:** `0x0000`  **Access:** see fields below

Flash address [15:0]

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADDR_L` | `[15:0]` | RW | `0x0000` | Flash address low word |

---
### `FLASH_ADDR_HIGH` — Address `0x0602`

**Reset value:** `0x00`  **Access:** see fields below

Flash address [23:16]

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADDR_H` | `[7:0]` | RW | `0x00` | Flash address high byte |
| `RSVD` | `[15:8]` | R | `0x00` | Reserved |

---
### `FLASH_DATA` — Address `0x0603`

**Reset value:** `0x0000`  **Access:** see fields below

Flash read/write data FIFO [15:0]

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA` | `[15:0]` | RW | `0x0000` | Flash data word |

---
### `FLASH_STATUS` — Address `0x0604`

**Reset value:** `0x00`  **Access:** see fields below

Flash operation status

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READY` | `[0]` | R | `1` | Flash ready (1=ready) |
| `WRITE_ERR` | `[1]` | RC | `0` | Write error (clear on read) |
| `ERASE_ERR` | `[2]` | RC | `0` | Erase error (clear on read) |
| `RSVD` | `[15:3]` | R | `0x00` | Reserved |

---
### `RF_PATH_CTRL` — Address `0x0700`

**Reset value:** `0x01`  **Access:** see fields below

RF path control for LNA, Mixer, VGA

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LNA_ENABLE` | `[0]` | RW | `0` | LNA enable (HMC1049LP3E) |
| `MIXER_ENABLE` | `[1]` | RW | `0` | Mixer enable (HMC1052LP4GE) |
| `VGA_ENABLE` | `[2]` | RW | `0` | VGA enable (HMC698LP4) |
| `RF_MUX_SEL` | `[4:3]` | RW | `0x0` | RF path multiplexer select |
| `RSVD` | `[15:5]` | R | `0x00` | Reserved |

---
### `RF_GAIN_SET` — Address `0x0701`

**Reset value:** `0x1F3F`  **Access:** see fields below

RF gain coarse/fine combined register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GAIN_COARSE` | `[12:8]` | RW | `0x1F` | Coarse gain (5-bit) [12:8] |
| `GAIN_FINE` | `[7:2]` | RW | `0x3F` | Fine gain (6-bit) [7:2] |
| `UPDATE` | `[0]` | RW | `0` | Trigger gain update (self-clearing) |
| `RSVD` | `[15:13]` | R | `0x00` | Reserved |

---
### `RF_STATUS` — Address `0x0702`

**Reset value:** `0x00`  **Access:** see fields below

RF chain status flags

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LNA_OK` | `[0]` | R | `0` | LNA status OK flag |
| `MIXER_OK` | `[1]` | R | `0` | Mixer status OK flag |
| `VGA_OK` | `[2]` | R | `0` | VGA status OK flag |
| `RF_OVERDRIVE` | `[3]` | R | `0` | RF overdrive flag |
| `RSVD` | `[15:4]` | R | `0x00` | Reserved |

---
### `LO_FREQ_CTRL` — Address `0x0708`

**Reset value:** `0x00C80000`  **Access:** see fields below

LO frequency control (HMC830LP6GE)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `FREQ_LSB` | `[15:0]` | RW | `0x0000` | LO frequency LSB (Hz) [15:0] |
| `FREQ_MSB` | `[31:16]` | RW | `0x000C` | LO frequency MSB (Hz) [31:16] (default 7.4GHz) |

---
### `LO_STATUS` — Address `0x0709`

**Reset value:** `0x00`  **Access:** see fields below

LO synthesizer status (HMC830LP6GE)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LOCKED` | `[0]` | R | `0` | LO PLL locked |
| `LOSS_OF_LOCK` | `[1]` | RC | `0` | LO loss of lock (clear on read) |
| `LD_PIN` | `[2]` | R | `0` | LO lock detect pin |
| `RSVD` | `[15:3]` | R | `0x00` | Reserved |

---
### `GPIO_DIR` — Address `0x0800`

**Reset value:** `0x0000`  **Access:** see fields below

GPIO direction (0=input, 1=output)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GPIO_DIR` | `[15:0]` | RW | `0x0000` | GPIO direction mask |

---
### `GPIO_OUT` — Address `0x0801`

**Reset value:** `0x0000`  **Access:** see fields below

GPIO output data

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GPIO_OUT` | `[15:0]` | RW | `0x0000` | GPIO output level (1=high) |

---
### `GPIO_IN` — Address `0x0802`

**Reset value:** `0x0000`  **Access:** see fields below

GPIO input data

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GPIO_IN` | `[15:0]` | R | `0x0000` | GPIO input level (1=high) |

---
### `DAC0_DATA` — Address `0x0900`

**Reset value:** `0x0000`  **Access:** see fields below

DAC channel 0 data (12-bit)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DAC_DATA` | `[11:0]` | RW | `0x000` | DAC channel 0 value (12-bit) |
| `RSVD` | `[15:12]` | R | `0x0` | Reserved |

---
### `DAC0_CTRL` — Address `0x0901`

**Reset value:** `0x01`  **Access:** see fields below

DAC channel 0 control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0` | DAC channel 0 enable |
| `UPDATE` | `[1]` | RW | `0` | Trigger DAC update (self-clearing) |
| `RSVD` | `[15:2]` | R | `0x00` | Reserved |

---
### `DAC1_DATA` — Address `0x0902`

**Reset value:** `0x0000`  **Access:** see fields below

DAC channel 1 data (12-bit)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DAC_DATA` | `[11:0]` | RW | `0x000` | DAC channel 1 value (12-bit) |
| `RSVD` | `[15:12]` | R | `0x0` | Reserved |

---
### `DAC1_CTRL` — Address `0x0903`

**Reset value:** `0x00`  **Access:** see fields below

DAC channel 1 control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0` | DAC channel 1 enable |
| `UPDATE` | `[1]` | RW | `0` | Trigger DAC update (self-clearing) |
| `RSVD` | `[15:2]` | R | `0x00` | Reserved |

---
### `DSP_CTRL` — Address `0x0A00`

**Reset value:** `0x00`  **Access:** see fields below

DSP engine control (FFT, filtering)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `FFT_EN` | `[0]` | RW | `0` | FFT engine enable |
| `FILTER_EN` | `[1]` | RW | `0` | Digital filter enable |
| `CW_DET_EN` | `[2]` | RW | `0` | CW detection enable |
| `DSP_RESET` | `[7]` | RW | `0` | DSP engine reset (active high) |
| `RSVD` | `[15:8]` | R | `0x00` | Reserved |

---
### `DSP_STATUS` — Address `0x0A01`

**Reset value:** `0x00`  **Access:** see fields below

DSP engine status

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `FFT_DONE` | `[0]` | R | `0` | FFT computation done flag |
| `CW_DET` | `[1]` | R | `0` | CW signal detected flag |
| `OVERRUN` | `[2]` | RC | `0` | DSP overrun (clear on read) |
| `RSVD` | `[15:3]` | R | `0x00` | Reserved |

---
### `FFT_ADDR` — Address `0x0A02`

**Reset value:** `0x0000`  **Access:** see fields below

FFT result address pointer

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADDR` | `[11:0]` | RW | `0x000` | FFT result bin address |
| `RSVD` | `[15:12]` | R | `0x0` | Reserved |

---
### `FFT_DATA` — Address `0x0A03`

**Reset value:** `0x0000`  **Access:** see fields below

FFT result data (magnitude)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAG` | `[15:0]` | R | `0x0000` | FFT magnitude output (16-bit) |

---
### `CW_DET_THRESHOLD` — Address `0x0A08`

**Reset value:** `0x0800`  **Access:** see fields below

CW detection threshold (12-bit)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `THRESHOLD` | `[11:0]` | RW | `0x800` | CW detection amplitude threshold |
| `RSVD` | `[15:12]` | R | `0x0` | Reserved |

---
### `CW_DET_FREQ` — Address `0x0A09`

**Reset value:** `0x0000`  **Access:** see fields below

CW detected frequency (Hz)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `FREQ_LSB` | `[15:0]` | R | `0x0000` | Detected frequency LSB [15:0] |
| `FREQ_MSB` | `[31:16]` | R | `0x0000` | Detected frequency MSB [31:16] |

---
### `INTERRUPT_EN` — Address `0x0B00`

**Reset value:** `0x00`  **Access:** see fields below

Interrupt enable mask

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_INT_EN` | `[0]` | RW | `0` | Temperature alert interrupt enable |
| `VOLT_INT_EN` | `[1]` | RW | `0` | Voltage fault interrupt enable |
| `PLL_LOSS_EN` | `[2]` | RW | `0` | PLL loss-of-lock interrupt enable |
| `JESD_ERR_EN` | `[3]` | RW | `0` | JESD204B error interrupt enable |
| `CW_DET_INT_EN` | `[4]` | RW | `0` | CW detection interrupt enable |
| `DSP_DONE_EN` | `[5]` | RW | `0` | DSP done interrupt enable |
| `RSVD` | `[15:6]` | R | `0x00` | Reserved |

---
### `INTERRUPT_STATUS` — Address `0x0B01`

**Reset value:** `0x00`  **Access:** see fields below

Interrupt status flags (clear on write)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_FLAG` | `[0]` | RC_W1C | `0` | Temperature alert flag (read-clear) |
| `VOLT_FLAG` | `[1]` | RC_W1C | `0` | Voltage fault flag (read-clear) |
| `PLL_LOSS_FLAG` | `[2]` | RC_W1C | `0` | PLL loss-of-lock flag (read-clear) |
| `JESD_ERR_FLAG` | `[3]` | RC_W1C | `0` | JESD204B error flag (read-clear) |
| `CW_DET_FLAG` | `[4]` | RC_W1C | `0` | CW detection flag (read-clear) |
| `DSP_DONE_FLAG` | `[5]` | RC_W1C | `0` | DSP done flag (read-clear) |
| `RSVD` | `[15:6]` | R | `0x00` | Reserved |
