# Register Description Table (RDT)
## Receiver Module

> **Total registers:** 59

**Receiver Module (1000-REV-A) Register Map & Initialization Sequence**

Comprehensive register definition for Wideband Receiver Module (5-18 GHz) based on GLR specification. Design uses ICE40HX4K FPGA with FT2232H USB-UART bridge for control interface.

**Key Register Groups:**
- **0x000:** Board ID, version, scratchpad (3 registers)
- **0x100:** UART communication with configurable baud (5 registers)
- **0x200:** ADC monitoring for 5V, 3.3V, 2.5V, 1.8V rails (8 registers)
- **0x300:** Temperature sensing (local + 2 remote) with alerts (6 registers)
- **0x400:** PLL/clock configuration (5 registers)
- **0x500:** EEPROM for calibration data (3 registers)
- **0x600:** Configuration flash interface (5 registers)
- **0x700:** RF control - VGA gain, RSSI, LO lock (10 registers)
- **0x800:** GPIO expansion (4 registers)
- **0x900:** Calibration data access (3 registers)

**Hardware Components:**
- HMC6180LP4E LNA (5-20 GHz)
- HMC698LP4 Digital VGA (0.5 dB steps, 31.5 dB range)
- HMC556LC4 Mixer (5-26 GHz)
- LT3045EDD (3.3V LDO), LT3094EDD (5V LDO)

**Initialization Sequence:** 30-step ordered sequence covering power-on self-check, PLL lock, peripheral enable, communication init, calibration load, and RF chain power-up.

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
| `0x0000` | `BOARD_ID` | — | `0x524D` | Board identification code |
| `0x0001` | `BOARD_VERSION` | — | `0x10` | Hardware version number |
| `0x0002` | `BOARD_TYPE_ID` | — | `0x524D5245` | Board type identifier |
| `0x0003` | `SCRATCHPAD` | — | `0x0000` | Read/write test register for RAM verification |
| `0x0010` | `MCS_VERSION_MAJOR` | — | `0x01` | FPGA firmware major version |
| `0x0011` | `MCS_VERSION_MINOR` | — | `0x00` | FPGA firmware minor version |
| `0x0012` | `BUILD_DATE` | — | `0x20260417` | Firmware build date (packed BCD) |
| `0x0100` | `UART_BAUD_DIV` | — | `0x0034` | UART baud rate divisor (default 115200 @ 12MHz) |
| `0x0101` | `UART_CTRL` | — | `0x00` | UART control register |
| `0x0102` | `UART_STATUS` | — | `0x00` | UART status register |
| `0x0103` | `UART_TX_COUNT` | — | `0x00` | TX FIFO byte count |
| `0x0104` | `UART_RX_COUNT` | — | `0x00` | RX FIFO byte count |
| `0x0110` | `ETH_MAC_LOW` | — | `0x0000` | Ethernet MAC address lower 16 bits |
| `0x0111` | `ETH_MAC_HIGH` | — | `0x0000` | Ethernet MAC address upper 16 bits |
| `0x0200` | `ADC_CTRL` | — | `0x00` | ADC control register |
| `0x0201` | `ADC_STATUS` | — | `0x00` | ADC status register |
| `0x0210` | `VCC_5V_RAW` | — | `0x0000` | 5V rail ADC count (multiply by 5.0/4096 for Volts) |
| `0x0211` | `VCC_3V3_RAW` | — | `0x0000` | 3.3V rail ADC count |
| `0x0212` | `VCC_2V5_RAW` | — | `0x0000` | 2.5V rail ADC count |
| `0x0213` | `VCC_1V8_RAW` | — | `0x0000` | 1.8V rail ADC count |
| `0x0218` | `ICC_5V_RAW` | — | `0x0000` | 5V rail current ADC count |
| `0x0219` | `ICC_3V3_RAW` | — | `0x0000` | 3.3V rail current ADC count |
| `0x0300` | `TEMP_LOCAL` | — | `0x0000` | Local FPGA die temperature in 0.25°C units (signed) |
| `0x0301` | `TEMP_REMOTE1` | — | `0x0000` | Remote sensor 1 temperature (LNA area) |
| `0x0302` | `TEMP_REMOTE2` | — | `0x0000` | Remote sensor 2 temperature (Mixer area) |
| `0x0308` | `TEMP_ALERT_HIGH` | — | `0x0190` | Over-temperature alert threshold (100°C) |
| `0x0309` | `TEMP_ALERT_LOW` | — | `0xFF9C` | Under-temperature alert threshold (-25°C) |
| `0x030F` | `HEALTH_STATUS` | — | `0x87` | System health status register |
| `0x0400` | `PLL_CTRL` | — | `0x00` | PLL control register |
| `0x0401` | `PLL_STATUS` | — | `0x00` | PLL status register |
| `0x0402` | `PLL_N_DIV` | — | `0x0064` | PLL N divider (default 100) |
| `0x0403` | `PLL_R_DIV` | — | `0x02` | PLL R divider (default 2) |
| `0x0410` | `CLK_ENABLE` | — | `0x00` | Clock output enables (one bit per output) |
| `0x0700` | `VGA_GAIN_CTRL` | — | `0x3F` | HMC698LP4 VGA gain control (6-bit, 0.5dB steps) |
| `0x0701` | `VGA_STATUS` | — | `0x01` | VGA status register |
| `0x0702` | `VGA_GAIN_TARGET` | — | `0x20` | Target gain for AGC ramp (default 16dB) |
| `0x0703` | `VGA_GAIN_STEP` | — | `0x01` | Gain step size for AGC ramp |
| `0x0708` | `RF_CTRL` | — | `0x0C` | RF chain control (LNA/Mixer enables) |
| `0x0709` | `RF_STATUS` | — | `0x00` | RF chain status register |
| `0x0710` | `RSSI_ADC` | — | `0x0000` | RSSI ADC reading (12-bit) |
| `0x0711` | `RSSI_THRESH_HIGH` | — | `0x0F00` | RSSI high threshold |
| `0x0712` | `RSSI_THRESH_LOW` | — | `0x0100` | RSSI low threshold |
| `0x0718` | `IF_FREQ_SEL` | — | `0x0064` | IF frequency select (MHz) |
| `0x0719` | `LO_LOCK_WINDOW` | — | `0x000A` | LO lock window (MHz) |
| `0x0500` | `EEPROM_CTRL` | — | `0x00` | EEPROM control register |
| `0x0501` | `EEPROM_ADDR` | — | `0x0000` | EEPROM byte address |
| `0x0502` | `EEPROM_DATA` | — | `0x0000` | EEPROM read/write data |
| `0x0600` | `FLASH_CTRL` | — | `0x00` | Configuration Flash control |
| `0x0601` | `FLASH_ADDR_LOW` | — | `0x0000` | Flash address low word |
| `0x0602` | `FLASH_ADDR_HIGH` | — | `0x0000` | Flash address high byte |
| `0x0603` | `FLASH_DATA` | — | `0x0000` | Flash read/write data FIFO |
| `0x0604` | `FLASH_STATUS` | — | `0x00` | Flash status register |
| `0x0800` | `GPIO_DIR` | — | `0x0000` | GPIO direction control (0=input, 1=output) |
| `0x0801` | `GPIO_DATA` | — | `0x0000` | GPIO data register |
| `0x0802` | `GPIO_INT_EN` | — | `0x00` | GPIO interrupt enable |
| `0x0803` | `GPIO_INT_STATUS` | — | `0x00` | GPIO interrupt status (clear on read) |
| `0x0900` | `CALIB_DATA` | — | `0x0000` | Factory calibration data (gain offset) |
| `0x0901` | `CALIB_DATE` | — | `0x00000000` | Factory calibration date |
| `0x0902` | `CALIB_CRC` | — | `0x0000` | Calibration data CRC16 |

---
### `BOARD_ID` — Address `0x0000`

**Reset value:** `0x524D`  **Access:** see fields below

Board identification code

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BOARD_ID` | `[15:0]` | RO | `0x524M` | ASCII 'RM' (Receiver Module) identifier |

---
### `BOARD_VERSION` — Address `0x0001`

**Reset value:** `0x10`  **Access:** see fields below

Hardware version number

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAJOR` | `[7:4]` | RO | `0x1` | Major version number |
| `MINOR` | `[3:0]` | RO | `0x0` | Minor version number |

---
### `BOARD_TYPE_ID` — Address `0x0002`

**Reset value:** `0x524D5245`  **Access:** see fields below

Board type identifier

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TYPE_ID` | `[15:0]` | RO | `0x524D5245` | Unique type identifier for Receiver Module |

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

FPGA firmware major version

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAJOR_VER` | `[7:0]` | RO | `0x01` | Major firmware version number |

---
### `MCS_VERSION_MINOR` — Address `0x0011`

**Reset value:** `0x00`  **Access:** see fields below

FPGA firmware minor version

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MINOR_VER` | `[7:0]` | RO | `0x00` | Minor firmware version number |

---
### `BUILD_DATE` — Address `0x0012`

**Reset value:** `0x20260417`  **Access:** see fields below

Firmware build date (packed BCD)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `YYYYMMDD` | `[31:0]` | RO | `0x20260417` | Build date in BCD format |

---
### `UART_BAUD_DIV` — Address `0x0100`

**Reset value:** `0x0034`  **Access:** see fields below

UART baud rate divisor (default 115200 @ 12MHz)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DIVISOR` | `[15:0]` | RW | `0x0034` | Baud rate divisor = f_clk / (16 * baud) |

---
### `UART_CTRL` — Address `0x0101`

**Reset value:** `0x00`  **Access:** see fields below

UART control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0x0` | UART enable |
| `LOOPBACK` | `[1]` | RW | `0x0` | Loopback mode for test |
| `FRAME_FORMAT` | `[7:4]` | RW | `0x0` | Frame format configuration |
| `RESERVED` | `[15:8]` | R | `0x00` | Reserved |

---
### `UART_STATUS` — Address `0x0102`

**Reset value:** `0x00`  **Access:** see fields below

UART status register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TX_BUSY` | `[0]` | R | `0x0` | Transmitter busy flag |
| `RX_AVAIL` | `[1]` | R | `0x0` | Data available in RX FIFO |
| `FRAME_ERR` | `[2]` | RC | `0x0` | Frame error (clear on read) |
| `PARITY_ERR` | `[3]` | RC | `0x0` | Parity error (clear on read) |

---
### `UART_TX_COUNT` — Address `0x0103`

**Reset value:** `0x00`  **Access:** see fields below

TX FIFO byte count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `COUNT` | `[7:0]` | RO | `0x00` | Number of bytes in TX FIFO |

---
### `UART_RX_COUNT` — Address `0x0104`

**Reset value:** `0x00`  **Access:** see fields below

RX FIFO byte count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `COUNT` | `[7:0]` | RO | `0x00` | Number of bytes in RX FIFO |

---
### `ETH_MAC_LOW` — Address `0x0110`

**Reset value:** `0x0000`  **Access:** see fields below

Ethernet MAC address lower 16 bits

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAC_LSB` | `[15:0]` | RO | `0x0000` | MAC address bits [15:0] |

---
### `ETH_MAC_HIGH` — Address `0x0111`

**Reset value:** `0x0000`  **Access:** see fields below

Ethernet MAC address upper 16 bits

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAC_MSB` | `[15:0]` | RO | `0x0000` | MAC address bits [31:16] |

---
### `ADC_CTRL` — Address `0x0200`

**Reset value:** `0x00`  **Access:** see fields below

ADC control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `START` | `[0]` | RW | `0x0` | Start single conversion |
| `CONTINUOUS` | `[1]` | RW | `0x0` | Continuous conversion mode |
| `CHANNEL_SEL` | `[3:2]` | RW | `0x0` | ADC channel select |

---
### `ADC_STATUS` — Address `0x0201`

**Reset value:** `0x00`  **Access:** see fields below

ADC status register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA_READY` | `[0]` | R | `0x0` | New data available |
| `OVERRANGE` | `[1]` | RC | `0x0` | ADC overrange flag (clear on read) |

---
### `VCC_5V_RAW` — Address `0x0210`

**Reset value:** `0x0000`  **Access:** see fields below

5V rail ADC count (multiply by 5.0/4096 for Volts)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | RO | `0x000` | 12-bit ADC count for 5V rail |

---
### `VCC_3V3_RAW` — Address `0x0211`

**Reset value:** `0x0000`  **Access:** see fields below

3.3V rail ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | RO | `0x000` | 12-bit ADC count for 3.3V rail |

---
### `VCC_2V5_RAW` — Address `0x0212`

**Reset value:** `0x0000`  **Access:** see fields below

2.5V rail ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | RO | `0x000` | 12-bit ADC count for 2.5V rail |

---
### `VCC_1V8_RAW` — Address `0x0213`

**Reset value:** `0x0000`  **Access:** see fields below

1.8V rail ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | RO | `0x000` | 12-bit ADC count for 1.8V rail |

---
### `ICC_5V_RAW` — Address `0x0218`

**Reset value:** `0x0000`  **Access:** see fields below

5V rail current ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | RO | `0x000` | 12-bit ADC count for 5V current |

---
### `ICC_3V3_RAW` — Address `0x0219`

**Reset value:** `0x0000`  **Access:** see fields below

3.3V rail current ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | RO | `0x000` | 12-bit ADC count for 3.3V current |

---
### `TEMP_LOCAL` — Address `0x0300`

**Reset value:** `0x0000`  **Access:** see fields below

Local FPGA die temperature in 0.25°C units (signed)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP` | `[9:0]` | RO | `0x000` | Die temperature (signed, 0.25°C LSB) |

---
### `TEMP_REMOTE1` — Address `0x0301`

**Reset value:** `0x0000`  **Access:** see fields below

Remote sensor 1 temperature (LNA area)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP` | `[9:0]` | RO | `0x000` | Remote temperature (signed, 0.25°C LSB) |

---
### `TEMP_REMOTE2` — Address `0x0302`

**Reset value:** `0x0000`  **Access:** see fields below

Remote sensor 2 temperature (Mixer area)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP` | `[9:0]` | RO | `0x000` | Remote temperature (signed, 0.25°C LSB) |

---
### `TEMP_ALERT_HIGH` — Address `0x0308`

**Reset value:** `0x0190`  **Access:** see fields below

Over-temperature alert threshold (100°C)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `THRESHOLD` | `[9:0]` | RW | `0x190` | High temperature alert threshold (0.25°C LSB) |

---
### `TEMP_ALERT_LOW` — Address `0x0309`

**Reset value:** `0xFF9C`  **Access:** see fields below

Under-temperature alert threshold (-25°C)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `THRESHOLD` | `[9:0]` | RW | `0xFF9C` | Low temperature alert threshold (signed, 0.25°C LSB) |

---
### `HEALTH_STATUS` — Address `0x030F`

**Reset value:** `0x87`  **Access:** see fields below

System health status register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_OK` | `[0]` | RO | `0x1` | Temperature within limits |
| `VOLT_OK` | `[1]` | RO | `0x1` | Supply voltages OK |
| `PLL_LOCK` | `[2]` | RO | `0x0` | PLL lock status |
| `VGA_OK` | `[3]` | RO | `0x1` | VGA responds to SPI |
| `LNA_BIAS_OK` | `[4]` | RO | `0x1` | LNA bias current OK |
| `MIXER_BIAS_OK` | `[5]` | RO | `0x1` | Mixer bias current OK |
| `CALIB_DONE` | `[6]` | RO | `0x0` | Factory calibration completed |
| `SYSTEM_OK` | `[7]` | RO | `0x1` | Overall system health |

---
### `PLL_CTRL` — Address `0x0400`

**Reset value:** `0x00`  **Access:** see fields below

PLL control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0x0` | PLL enable |
| `RESET` | `[1]` | RW | `0x0` | PLL reset (active high) |
| `REF_SEL` | `[3:2]` | RW | `0x0` | Reference clock select |

---
### `PLL_STATUS` — Address `0x0401`

**Reset value:** `0x00`  **Access:** see fields below

PLL status register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LOCKED` | `[0]` | R | `0x0` | PLL locked indicator |
| `LOSS_OF_LOCK` | `[1]` | RC | `0x0` | Loss of lock flag (clear on read) |

---
### `PLL_N_DIV` — Address `0x0402`

**Reset value:** `0x0064`  **Access:** see fields below

PLL N divider (default 100)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `N_DIV` | `[15:0]` | RW | `0x64` | N divider value (10-255) |

---
### `PLL_R_DIV` — Address `0x0403`

**Reset value:** `0x02`  **Access:** see fields below

PLL R divider (default 2)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `R_DIV` | `[7:0]` | RW | `0x2` | R divider value (1-8) |

---
### `CLK_ENABLE` — Address `0x0410`

**Reset value:** `0x00`  **Access:** see fields below

Clock output enables (one bit per output)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `CLK_OUT_EN` | `[7:0]` | RW | `0x00` | Clock output enable bits [7:0] |

---
### `VGA_GAIN_CTRL` — Address `0x0700`

**Reset value:** `0x3F`  **Access:** see fields below

HMC698LP4 VGA gain control (6-bit, 0.5dB steps)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GAIN_CODE` | `[5:0]` | RW | `0x3F` | Gain code 0-63 (0 to 31.5 dB in 0.5 dB steps) |
| `RESERVED` | `[15:6]` | R | `0x00` | Reserved |

---
### `VGA_STATUS` — Address `0x0701`

**Reset value:** `0x01`  **Access:** see fields below

VGA status register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `SPI_BUSY` | `[0]` | RO | `0x1` | VGA SPI transaction busy |
| `GAIN_RAMP_DONE` | `[1]` | R | `0x0` | Gain ramp sequence complete |

---
### `VGA_GAIN_TARGET` — Address `0x0702`

**Reset value:** `0x20`  **Access:** see fields below

Target gain for AGC ramp (default 16dB)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TARGET_GAIN` | `[5:0]` | RW | `0x20` | Target gain code for automatic gain ramp |

---
### `VGA_GAIN_STEP` — Address `0x0703`

**Reset value:** `0x01`  **Access:** see fields below

Gain step size for AGC ramp

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `STEP_SIZE` | `[3:0]` | RW | `0x1` | Step size (0=1dB, 1=0.5dB steps) |
| `STEP_DELAY` | `[11:8]` | RW | `0x1` | Delay between steps (x100us) |

---
### `RF_CTRL` — Address `0x0708`

**Reset value:** `0x0C`  **Access:** see fields below

RF chain control (LNA/Mixer enables)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LNA_ENABLE` | `[0]` | RW | `0x0` | LNA enable (HMC6180LP4E) |
| `MIXER_ENABLE` | `[1]` | RW | `0x0` | Mixer enable (HMC556LC4) |
| `LO_BUFFER_EN` | `[2]` | RW | `0x1` | LO input buffer enable |
| `IF_AMP_EN` | `[3]` | RW | `0x1` | IF amplifier enable |
| `RF_BIAS_EN` | `[4]` | RW | `0x1` | RF bias network enable |
| `SEQUENCE_EN` | `[7]` | RW | `0x0` | Enable power-up sequencer |

---
### `RF_STATUS` — Address `0x0709`

**Reset value:** `0x00`  **Access:** see fields below

RF chain status register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LNA_BIAS_OK` | `[0]` | RO | `0x0` | LNA bias current OK flag |
| `MIXER_BIAS_OK` | `[1]` | RO | `0x0` | Mixer bias current OK flag |
| `RF_POWER_GOOD` | `[2]` | RO | `0x0` | RF power supply good |
| `LO_DETECT` | `[3]` | RO | `0x0` | LO input detected |

---
### `RSSI_ADC` — Address `0x0710`

**Reset value:** `0x0000`  **Access:** see fields below

RSSI ADC reading (12-bit)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `RSSI_VALUE` | `[11:0]` | RO | `0x000` | RSSI ADC count (convert to dBm via lookup) |

---
### `RSSI_THRESH_HIGH` — Address `0x0711`

**Reset value:** `0x0F00`  **Access:** see fields below

RSSI high threshold

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `THRESHOLD` | `[11:0]` | RW | `0xF00` | RSSI high alert threshold |

---
### `RSSI_THRESH_LOW` — Address `0x0712`

**Reset value:** `0x0100`  **Access:** see fields below

RSSI low threshold

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `THRESHOLD` | `[11:0]` | RW | `0x100` | RSSI low alert threshold |

---
### `IF_FREQ_SEL` — Address `0x0718`

**Reset value:** `0x0064`  **Access:** see fields below

IF frequency select (MHz)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `IF_FREQ` | `[15:0]` | RW | `0x64` | IF frequency in MHz (default 100MHz) |

---
### `LO_LOCK_WINDOW` — Address `0x0719`

**Reset value:** `0x000A`  **Access:** see fields below

LO lock window (MHz)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `WINDOW` | `[7:0]` | RW | `0x0A` | LO lock tolerance window |

---
### `EEPROM_CTRL` — Address `0x0500`

**Reset value:** `0x00`  **Access:** see fields below

EEPROM control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READ` | `[0]` | RW | `0x0` | Start read operation |
| `WRITE` | `[1]` | RW | `0x0` | Start write operation |
| `ERASE` | `[2]` | RW | `0x0` | Erase page |
| `BUSY` | `[7]` | RO | `0x0` | EEPROM busy flag |

---
### `EEPROM_ADDR` — Address `0x0501`

**Reset value:** `0x0000`  **Access:** see fields below

EEPROM byte address

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADDRESS` | `[15:0]` | RW | `0x0000` | 16-bit EEPROM address |

---
### `EEPROM_DATA` — Address `0x0502`

**Reset value:** `0x0000`  **Access:** see fields below

EEPROM read/write data

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA` | `[15:0]` | RW | `0x0000` | 16-bit data word |

---
### `FLASH_CTRL` — Address `0x0600`

**Reset value:** `0x00`  **Access:** see fields below

Configuration Flash control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READ` | `[0]` | RW | `0x0` | Start read operation |
| `WRITE` | `[1]` | RW | `0x0` | Start write operation |
| `ERASE_SECTOR` | `[2]` | RW | `0x0` | Erase sector |
| `ERASE_CHIP` | `[3]` | RW | `0x0` | Erase entire chip |
| `BUSY` | `[7]` | RO | `0x0` | Flash busy flag |

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

Flash read/write data FIFO

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA` | `[15:0]` | RW | `0x0000` | 16-bit data word |

---
### `FLASH_STATUS` — Address `0x0604`

**Reset value:** `0x00`  **Access:** see fields below

Flash status register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READY` | `[0]` | RO | `0x1` | Flash ready flag |
| `WRITE_ERR` | `[1]` | RC | `0x0` | Write error (clear on read) |
| `ERASE_ERR` | `[2]` | RC | `0x0` | Erase error (clear on read) |

---
### `GPIO_DIR` — Address `0x0800`

**Reset value:** `0x0000`  **Access:** see fields below

GPIO direction control (0=input, 1=output)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DIR` | `[15:0]` | RW | `0x0000` | GPIO direction bits |

---
### `GPIO_DATA` — Address `0x0801`

**Reset value:** `0x0000`  **Access:** see fields below

GPIO data register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA` | `[15:0]` | RW | `0x0000` | GPIO data bits |

---
### `GPIO_INT_EN` — Address `0x0802`

**Reset value:** `0x00`  **Access:** see fields below

GPIO interrupt enable

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `INT_EN` | `[7:0]` | RW | `0x00` | Interrupt enable per GPIO |

---
### `GPIO_INT_STATUS` — Address `0x0803`

**Reset value:** `0x00`  **Access:** see fields below

GPIO interrupt status (clear on read)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `INT_FLAG` | `[7:0]` | RC | `0x00` | Interrupt flags |

---
### `CALIB_DATA` — Address `0x0900`

**Reset value:** `0x0000`  **Access:** see fields below

Factory calibration data (gain offset)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GAIN_OFFSET` | `[15:0]` | RO | `0x0000` | Gain correction offset (signed) |

---
### `CALIB_DATE` — Address `0x0901`

**Reset value:** `0x00000000`  **Access:** see fields below

Factory calibration date

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `CAL_DATE` | `[31:0]` | RO | `0x00000000` | Calibration date (YYYYMMDD) |

---
### `CALIB_CRC` — Address `0x0902`

**Reset value:** `0x0000`  **Access:** see fields below

Calibration data CRC16

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `CRC` | `[15:0]` | RO | `0x0000` | CRC-16 of calibration data |
