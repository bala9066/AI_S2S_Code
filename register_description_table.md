# Register Description Table (RDT)
## TX Module

> **Total registers:** 53

TX Module FPGA register map (40 registers across 10 functional groups) and 24-step initialization sequence. Groups: Board Info (0x000-0x001), Communication (0x100-0x111), ADC/Telemetry (0x200-0x219), Temperature/Health (0x300-0x30F), PLL/Clock (0x400-0x410), EEPROM (0x500-0x502), Flash (0x600-0x604), RF Control (0x700-0x704), GPIO (0x800-0x803), DAC/Bias (0x900-0x902, 0xA00-0xA02). Key features: HMC698LP4 6-bit attenuator control, LTC2442 24-bit ADC interface, PA power sequencing via LTC7004/MOSFETs, AD8318 RF detector monitoring.

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
| `0x0000` | `BOARD_ID` | — | `0x5458` | Board identification code - unique TX Module identifier |
| `0x0001` | `BOARD_VERSION` | — | `0x10` | Hardware revision number |
| `0x0002` | `BOARD_TYPE_ID` | — | `0x544D` | Board type classification |
| `0x0003` | `SCRATCHPAD` | — | `0x0000` | General-purpose test register for RAM verification |
| `0x0010` | `MCS_VERSION_MAJOR` | — | `0x01` | FPGA firmware major version |
| `0x0011` | `MCS_VERSION_MINOR` | — | `0x00` | FPGA firmware minor version |
| `0x0012` | `BUILD_DATE` | — | `0x2414` | Firmware build date in packed BCD format |
| `0x0100` | `UART_BAUD_DIV` | — | `0x0868` | UART baud rate divisor for 40MHz clock |
| `0x0101` | `UART_CTRL` | — | `0x03` | UART control register |
| `0x0102` | `UART_STATUS` | — | `0x00` | UART status flags (read-clear) |
| `0x0103` | `UART_TX_COUNT` | — | `0x00` | TX FIFO byte count |
| `0x0104` | `UART_RX_COUNT` | — | `0x00` | RX FIFO byte count |
| `0x0110` | `ETH_MAC_LOW` | — | `0x0000` | Ethernet MAC address lower 16 bits |
| `0x0111` | `ETH_MAC_HIGH` | — | `0x0000` | Ethernet MAC address upper 16 bits |
| `0x0200` | `ADC_CTRL` | — | `0x30` | LTC2442 ADC control register |
| `0x0201` | `ADC_STATUS` | — | `0x00` | ADC status flags (read-clear) |
| `0x0210` | `RF_POWER_DET_RAW` | — | `0x000000` | RF Detector (AD8318) 24-bit ADC reading |
| `0x0211` | `I_PA_SENSE_RAW` | — | `0x000000` | PA Current Sense (R14) 24-bit ADC reading |
| `0x0218` | `VCC_5V_RAW` | — | `0x0000` | 5V rail ADC count from LT8631 output |
| `0x0219` | `VCC_28V_RAW` | — | `0x0000` | 28V input rail ADC count |
| `0x0300` | `TEMP_PA_DIE` | — | `0x0190` | PA die temperature in 0.25°C units |
| `0x0301` | `TEMP_LOCAL` | — | `0x0190` | Local FPGA die temperature |
| `0x0308` | `TEMP_ALERT_HIGH` | — | `0x01E0` | Over-temperature alert threshold |
| `0x0309` | `TEMP_ALERT_LOW` | — | `0xFF9C` | Under-temperature alert threshold |
| `0x030F` | `HEALTH_STATUS` | — | `0x8F` | System health status register |
| `0x0400` | `PLL_CTRL` | — | `0x02` | PLL/Clock control register |
| `0x0401` | `PLL_STATUS` | — | `0x00` | PLL status register |
| `0x0402` | `PLL_N_DIV` | — | `0x0032` | PLL N divider value |
| `0x0403` | `PLL_R_DIV` | — | `0x01` | PLL R divider value |
| `0x0410` | `CLK_ENABLE` | — | `0x07` | Clock output enable register |
| `0x0500` | `EEPROM_CTRL` | — | `0x00` | EEPROM control register |
| `0x0501` | `EEPROM_ADDR` | — | `0x0000` | EEPROM address register |
| `0x0502` | `EEPROM_DATA` | — | `0x0000` | EEPROM data register |
| `0x0600` | `FLASH_CTRL` | — | `0x00` | Configuration Flash control register |
| `0x0601` | `FLASH_ADDR_LOW` | — | `0x0000` | Flash address lower 16 bits |
| `0x0602` | `FLASH_ADDR_HIGH` | — | `0x00` | Flash address upper 8 bits |
| `0x0603` | `FLASH_DATA` | — | `0x0000` | Flash data FIFO register |
| `0x0604` | `FLASH_STATUS` | — | `0x01` | Flash status register (read-clear) |
| `0x0700` | `RF_TX_ENABLE` | — | `0x0A50` | RF TX Enable control register |
| `0x0701` | `RF_ATTENUATION` | — | `0x40` | HMC698LP4 6-bit Digital Attenuator control |
| `0x0702` | `RF_PHASE_CTRL` | — | `0x0000` | RF phase control register |
| `0x0703` | `RF_STATUS` | — | `0x00` | RF chain status register (read-clear) |
| `0x0704` | `RF_POWER_SETPOINT` | — | `0x0190` | Target RF output power setpoint |
| `0x0800` | `GPIO_DIR` | — | `0x0F` | GPIO direction control register |
| `0x0801` | `GPIO_DATA_OUT` | — | `0x00` | GPIO output data register |
| `0x0802` | `GPIO_DATA_IN` | — | `0x00` | GPIO input data register |
| `0x0803` | `GPIO_INT_EN` | — | `0x00` | GPIO interrupt enable register |
| `0x0900` | `DAC_CTRL` | — | `0x00` | DAC control register (VGA/PA bias) |
| `0x0901` | `DAC_DATA` | — | `0x800` | DAC data register (12-bit) |
| `0x0902` | `DAC_STATUS` | — | `0x01` | DAC status register |
| `0x0A00` | `PA_BIAS_CTRL` | — | `0x5000` | PA Bias control via LTC7004 gate drive |
| `0x0A01` | `MOSFET_CTRL` | — | `0x00` | Power sequencing MOSFET control register |
| `0x0A02` | `VCC_CTRL` | — | `0x00` | VCC control register (LT8631/LT3080) |

---
### `BOARD_ID` — Address `0x0000`

**Reset value:** `0x5458`  **Access:** see fields below

Board identification code - unique TX Module identifier

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ID_CODE` | `[15:0]` | RO | `0x5458` | ASCII 'TX' identifier (0x54='T', 0x58='X') for TX Module |

---
### `BOARD_VERSION` — Address `0x0001`

**Reset value:** `0x10`  **Access:** see fields below

Hardware revision number

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAJOR` | `[7:4]` | RO | `0x1` | Major version number |
| `MINOR` | `[3:0]` | RO | `0x0` | Minor version number |

---
### `BOARD_TYPE_ID` — Address `0x0002`

**Reset value:** `0x544D`  **Access:** see fields below

Board type classification

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TYPE_CODE` | `[15:0]` | RO | `0x544D` | Type identifier for TX Module (0x544D = 'TM') |

---
### `SCRATCHPAD` — Address `0x0003`

**Reset value:** `0x0000`  **Access:** see fields below

General-purpose test register for RAM verification

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEST_DATA` | `[15:0]` | RW | `0x0000` | Read/write test pattern - no functional effect |

---
### `MCS_VERSION_MAJOR` — Address `0x0010`

**Reset value:** `0x01`  **Access:** see fields below

FPGA firmware major version

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAJOR_VER` | `[7:0]` | RO | `0x01` | Firmware major version number |

---
### `MCS_VERSION_MINOR` — Address `0x0011`

**Reset value:** `0x00`  **Access:** see fields below

FPGA firmware minor version

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MINOR_VER` | `[7:0]` | RO | `0x00` | Firmware minor version number |

---
### `BUILD_DATE` — Address `0x0012`

**Reset value:** `0x2414`  **Access:** see fields below

Firmware build date in packed BCD format

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `YYYY` | `[15:12]` | RO | `0x2` | Year (decades, e.g. 2=2020s) |
| `MM` | `[11:8]` | RO | `0x4` | Month (BCD) |
| `DD` | `[7:0]` | RO | `0x14` | Day (BCD) |

---
### `UART_BAUD_DIV` — Address `0x0100`

**Reset value:** `0x0868`  **Access:** see fields below

UART baud rate divisor for 40MHz clock

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DIVISOR` | `[15:0]` | RW | `0x0868` | Baud divisor = 40MHz / (16 * baud_rate). Default 115200 baud = 0x0868 |

---
### `UART_CTRL` — Address `0x0101`

**Reset value:** `0x03`  **Access:** see fields below

UART control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0x0` | UART enable - 1=enabled |
| `LOOPBACK` | `[1]` | RW | `0x0` | Internal loopback mode for test |
| `PARITY_EN` | `[2]` | RW | `0x0` | Parity enable |
| `FRAME_FORMAT` | `[7:4]` | RW | `0x3` | Frame format: 0x3=8N1 |

---
### `UART_STATUS` — Address `0x0102`

**Reset value:** `0x00`  **Access:** see fields below

UART status flags (read-clear)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TX_BUSY` | `[0]` | R | `0x0` | Transmitter busy flag |
| `RX_AVAIL` | `[1]` | R | `0x0` | Data available in RX FIFO |
| `FRAME_ERR` | `[2]` | RC | `0x0` | Frame error detected - clears on read |
| `OVERRUN_ERR` | `[3]` | RC | `0x0` | RX FIFO overrun - clears on read |

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
| `MAC_LOW` | `[15:0]` | RO | `0x0000` | MAC address bits [15:0] |

---
### `ETH_MAC_HIGH` — Address `0x0111`

**Reset value:** `0x0000`  **Access:** see fields below

Ethernet MAC address upper 16 bits

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAC_HIGH` | `[15:0]` | RO | `0x0000` | MAC address bits [31:16] |

---
### `ADC_CTRL` — Address `0x0200`

**Reset value:** `0x30`  **Access:** see fields below

LTC2442 ADC control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `START` | `[0]` | RW | `0x0` | Start ADC conversion - self-clearing |
| `CONTINUOUS` | `[1]` | RW | `0x0` | Continuous conversion mode |
| `CHANNEL_SEL` | `[3:2]` | RW | `0x0` | Channel select: 0=RF_DET, 1=I_SENSE, 2=TEMP, 3=5V_MONITOR |
| `ADC_SPEED` | `[6:4]` | RW | `0x3` | Speed/osr select: 3=3.5kHz/1x, 7=7kHz |

---
### `ADC_STATUS` — Address `0x0201`

**Reset value:** `0x00`  **Access:** see fields below

ADC status flags (read-clear)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA_READY` | `[0]` | RC | `0x0` | New data available - clears on read |
| `OVERRANGE` | `[1]` | RC | `0x0` | Input overrange detected |
| `BUSY` | `[2]` | R | `0x0` | ADC conversion in progress |

---
### `RF_POWER_DET_RAW` — Address `0x0210`

**Reset value:** `0x000000`  **Access:** see fields below

RF Detector (AD8318) 24-bit ADC reading

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `RF_DET_CODE` | `[23:0]` | RO | `0x000000` | 24-bit signed ADC code from RF power detector |

---
### `I_PA_SENSE_RAW` — Address `0x0211`

**Reset value:** `0x000000`  **Access:** see fields below

PA Current Sense (R14) 24-bit ADC reading

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `I_SENSE_CODE` | `[23:0]` | RO | `0x000000` | 24-bit ADC code from 100mΩ current sense resistor |

---
### `VCC_5V_RAW` — Address `0x0218`

**Reset value:** `0x0000`  **Access:** see fields below

5V rail ADC count from LT8631 output

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `V5_COUNT` | `[11:0]` | RO | `0x0000` | 5V rail ADC count - multiply by 5.0/4096 for Volts |

---
### `VCC_28V_RAW` — Address `0x0219`

**Reset value:** `0x0000`  **Access:** see fields below

28V input rail ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `V28_COUNT` | `[11:0]` | RO | `0x0000` | 28V rail ADC count - scaled via divider |

---
### `TEMP_PA_DIE` — Address `0x0300`

**Reset value:** `0x0190`  **Access:** see fields below

PA die temperature in 0.25°C units

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_CODE` | `[9:0]` | RO | `0x190` | Temperature in 0.25°C units (signed) - 0x190=100°C |

---
### `TEMP_LOCAL` — Address `0x0301`

**Reset value:** `0x0190`  **Access:** see fields below

Local FPGA die temperature

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_LOCAL_CODE` | `[9:0]` | RO | `0x190` | FPGA die temp in 0.25°C units (signed) |

---
### `TEMP_ALERT_HIGH` — Address `0x0308`

**Reset value:** `0x01E0`  **Access:** see fields below

Over-temperature alert threshold

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `OT_THRESH` | `[9:0]` | RW | `0x1E0` | OT threshold in 0.25°C - default 120°C (0x1E0) |

---
### `TEMP_ALERT_LOW` — Address `0x0309`

**Reset value:** `0xFF9C`  **Access:** see fields below

Under-temperature alert threshold

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `UT_THRESH` | `[9:0]` | RW | `0xFF9C` | UT threshold in 0.25°C - default -25°C (0xFF9C) |

---
### `HEALTH_STATUS` — Address `0x030F`

**Reset value:** `0x8F`  **Access:** see fields below

System health status register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_OK` | `[0]` | RO | `0x1` | Temperature within limits |
| `VOLT_OK` | `[1]` | RO | `0x1` | All voltage rails within tolerance |
| `I_SENSE_OK` | `[2]` | RO | `0x1` | PA current within limits |
| `RF_DET_OK` | `[3]` | RO | `0x1` | RF detector output valid |
| `SYSTEM_OK` | `[7]` | RO | `0x1` | Overall system health - all checks pass |

---
### `PLL_CTRL` — Address `0x0400`

**Reset value:** `0x02`  **Access:** see fields below

PLL/Clock control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0x0` | PLL enable - 1=enabled |
| `RESET` | `[1]` | RW | `0x1` | PLL reset - active high, clears after release |
| `REF_SEL` | `[3:2]` | RW | `0x0` | Reference clock select: 0=internal 40MHz osc, 1=external |

---
### `PLL_STATUS` — Address `0x0401`

**Reset value:** `0x00`  **Access:** see fields below

PLL status register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LOCKED` | `[0]` | RO | `0x0` | PLL lock indicator - 1=locked |
| `LOSS_OF_LOCK` | `[1]` | RC | `0x0` | Loss of lock detected - clears on read |

---
### `PLL_N_DIV` — Address `0x0402`

**Reset value:** `0x0032`  **Access:** see fields below

PLL N divider value

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `N_DIVIDER` | `[15:0]` | RW | `0x0032` | N divider value - default 50 for 2GHz from 40MHz ref |

---
### `PLL_R_DIV` — Address `0x0403`

**Reset value:** `0x01`  **Access:** see fields below

PLL R divider value

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `R_DIVIDER` | `[7:0]` | RW | `0x01` | R divider value - default 1 |

---
### `CLK_ENABLE` — Address `0x0410`

**Reset value:** `0x07`  **Access:** see fields below

Clock output enable register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `CLK_ADC_EN` | `[0]` | RW | `0x1` | ADC clock enable |
| `CLK_RF_EN` | `[1]` | RW | `0x1` | RF control clock enable |
| `CLK_UART_EN` | `[2]` | RW | `0x1` | UART clock enable |

---
### `EEPROM_CTRL` — Address `0x0500`

**Reset value:** `0x00`  **Access:** see fields below

EEPROM control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READ` | `[0]` | RW | `0x0` | Start read - self-clearing |
| `WRITE` | `[1]` | RW | `0x0` | Start write - self-clearing |
| `ERASE` | `[2]` | RW | `0x0` | Start erase - self-clearing |
| `BUSY` | `[7]` | RO | `0x0` | EEPROM operation in progress |

---
### `EEPROM_ADDR` — Address `0x0501`

**Reset value:** `0x0000`  **Access:** see fields below

EEPROM address register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADDR` | `[15:0]` | RW | `0x0000` | 16-bit EEPROM byte address |

---
### `EEPROM_DATA` — Address `0x0502`

**Reset value:** `0x0000`  **Access:** see fields below

EEPROM data register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA` | `[15:0]` | RW | `0x0000` | 16-bit read/write data |

---
### `FLASH_CTRL` — Address `0x0600`

**Reset value:** `0x00`  **Access:** see fields below

Configuration Flash control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READ` | `[0]` | RW | `0x0` | Flash read enable |
| `WRITE` | `[1]` | RW | `0x0` | Flash write enable |
| `ERASE_SECTOR` | `[2]` | RW | `0x0` | Erase flash sector |
| `ERASE_CHIP` | `[3]` | RW | `0x0` | Erase entire chip |
| `BUSY` | `[7]` | RO | `0x0` | Flash operation busy |

---
### `FLASH_ADDR_LOW` — Address `0x0601`

**Reset value:** `0x0000`  **Access:** see fields below

Flash address lower 16 bits

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADDR_LOW` | `[15:0]` | RW | `0x0000` | Flash address [15:0] |

---
### `FLASH_ADDR_HIGH` — Address `0x0602`

**Reset value:** `0x00`  **Access:** see fields below

Flash address upper 8 bits

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADDR_HIGH` | `[7:0]` | RW | `0x00` | Flash address [23:16] |

---
### `FLASH_DATA` — Address `0x0603`

**Reset value:** `0x0000`  **Access:** see fields below

Flash data FIFO register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA` | `[15:0]` | RW | `0x0000` | Read/write data |

---
### `FLASH_STATUS` — Address `0x0604`

**Reset value:** `0x01`  **Access:** see fields below

Flash status register (read-clear)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READY` | `[0]` | RO | `0x1` | Flash ready for operations |
| `WRITE_ERR` | `[1]` | RC | `0x0` | Write error flag - clears on read |
| `ERASE_ERR` | `[2]` | RC | `0x0` | Erase error flag - clears on read |

---
### `RF_TX_ENABLE` — Address `0x0700`

**Reset value:** `0x0A50`  **Access:** see fields below

RF TX Enable control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TX_EN` | `[0]` | RW | `0x0` | TX enable - controls PA bias sequencing |
| `TX_EN_DELAY` | `[7:4]` | RW | `0xA` | TX enable ramp delay (100us increments) |
| `TX_DISABLE_DELAY` | `[11:8]` | RW | `0x5` | TX disable ramp delay (100us increments) |

---
### `RF_ATTENUATION` — Address `0x0701`

**Reset value:** `0x40`  **Access:** see fields below

HMC698LP4 6-bit Digital Attenuator control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ATTEN_CODE` | `[5:0]` | RW | `0x00` | 6-bit attenuation code - 0=min attenuation (0dB), 63=max attenuation (31.5dB) |
| `ATTEN_EN` | `[6]` | RW | `0x1` | Attenuator enable - 1=enabled, 0=bypass |

---
### `RF_PHASE_CTRL` — Address `0x0702`

**Reset value:** `0x0000`  **Access:** see fields below

RF phase control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `PHASE_CODE` | `[7:0]` | RW | `0x00` | Phase control word (LSB) |
| `PHASE_CODE_MSB` | `[15:8]` | RW | `0x00` | Phase control word (MSB) |

---
### `RF_STATUS` — Address `0x0703`

**Reset value:** `0x00`  **Access:** see fields below

RF chain status register (read-clear)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `PA_ENABLED` | `[0]` | RO | `0x0` | PA bias enable status |
| `PA_FAULT` | `[1]` | RC | `0x0` | PA fault detected - OC/OT - clears on read |
| `VSWR_HIGH` | `[2]` | RC | `0x0` | High VSWR detected - clears on read |
| `RF_ON` | `[7]` | RO | `0x0` | RF output enabled flag |

---
### `RF_POWER_SETPOINT` — Address `0x0704`

**Reset value:** `0x0190`  **Access:** see fields below

Target RF output power setpoint

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `POWER_SET` | `[9:0]` | RW | `0x190` | Power setpoint in 0.25dB units - default 40dBm (100*0.25=100) |
| `AUTO_GAIN_EN` | `[15]` | RW | `0x0` | Automatic gain control enable - 1=enable AGC loop |

---
### `GPIO_DIR` — Address `0x0800`

**Reset value:** `0x0F`  **Access:** see fields below

GPIO direction control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GPIO_DIR` | `[7:0]` | RW | `0x0F` | 1=output, 0=input. Default: GPIO[3:0]=out, GPIO[7:4]=in |

---
### `GPIO_DATA_OUT` — Address `0x0801`

**Reset value:** `0x00`  **Access:** see fields below

GPIO output data register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GPIO_OUT` | `[7:0]` | RW | `0x00` | GPIO output data (bits configured as outputs) |

---
### `GPIO_DATA_IN` — Address `0x0802`

**Reset value:** `0x00`  **Access:** see fields below

GPIO input data register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GPIO_IN` | `[7:0]` | RO | `0x00` | GPIO input data (read from pins) |

---
### `GPIO_INT_EN` — Address `0x0803`

**Reset value:** `0x00`  **Access:** see fields below

GPIO interrupt enable register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `INT_EN` | `[7:0]` | RW | `0x00` | Interrupt enable per GPIO bit - 1=enable interrupt on change |

---
### `DAC_CTRL` — Address `0x0900`

**Reset value:** `0x00`  **Access:** see fields below

DAC control register (VGA/PA bias)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DAC_EN` | `[0]` | RW | `0x0` | DAC output enable |
| `DAC_CHANNEL` | `[3:2]` | RW | `0x0` | Channel select: 0=VGA_VREF, 1=PA_VG |

---
### `DAC_DATA` — Address `0x0901`

**Reset value:** `0x800`  **Access:** see fields below

DAC data register (12-bit)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DAC_CODE` | `[11:0]` | RW | `0x800` | 12-bit DAC code - midscale (2048) default |

---
### `DAC_STATUS` — Address `0x0902`

**Reset value:** `0x01`  **Access:** see fields below

DAC status register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DAC_READY` | `[0]` | RO | `0x1` | DAC ready flag |

---
### `PA_BIAS_CTRL` — Address `0x0A00`

**Reset value:** `0x5000`  **Access:** see fields below

PA Bias control via LTC7004 gate drive

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `PA_BIAS_EN` | `[0]` | RW | `0x0` | PA bias enable - must be sequenced after VCC |
| `PA_GATE_DRIVE` | `[8]` | RW | `0x0` | PA gate drive override (test mode) |
| `VGS_DELAY` | `[15:12]` | RW | `0x5` | Gate-Source delay (ms) - default 5ms |

---
### `MOSFET_CTRL` — Address `0x0A01`

**Reset value:** `0x00`  **Access:** see fields below

Power sequencing MOSFET control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `Q1_PCH_EN` | `[0]` | RW | `0x0` | Q1 (IRF9540) P-Channel enable - 28V high-side switch |
| `Q2_NCH_EN` | `[1]` | RW | `0x0` | Q2 (IRF540) N-Channel enable - load switch |
| `SEQ_COMPLETE` | `[7]` | RO | `0x0` | Power sequencing complete flag |

---
### `VCC_CTRL` — Address `0x0A02`

**Reset value:** `0x00`  **Access:** see fields below

VCC control register (LT8631/LT3080)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LT8631_EN` | `[0]` | RW | `0x0` | LT8631 5V buck enable |
| `LT3080_EN` | `[1]` | RW | `0x0` | LT3080 LDO enable for analog bias |
| `POWER_GOOD` | `[7]` | RO | `0x0` | Power good flag |
