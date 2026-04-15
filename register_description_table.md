# Register Description Table (RDT)
## uyj

> **Total registers:** 56

uyj Wideband RF Receiver Register Map - XCZU9EG-FFVB1156 FPGA with JESD204B/C ADC interface, RF gain control, clock generation, power monitoring, and UART communication. 33 registers across 10 functional groups (0x000-0x900) covering board info, communications, ADC/sensors, temperature/health, PLL/clocking, EEPROM/Flash, RF/VGA control, GPIO, DAC, and application-specific JESD204B link status.

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
| `0x0000` | `BOARD_ID` | — | `0x5559` | Board identification code - 'UY' in ASCII (0x5559) |
| `0x0001` | `BOARD_VERSION` | — | `0x01` | Hardware revision number |
| `0x0002` | `BOARD_TYPE_ID` | — | `0x5252` | Board type identifier - 'RR' for RF Receiver |
| `0x0003` | `SCRATCHPAD` | — | `0x0000` | Read/write test register for RAM verification |
| `0x0010` | `MCS_VERSION_MAJOR` | — | `0x01` | FPGA firmware major version number |
| `0x0011` | `MCS_VERSION_MINOR` | — | `0x00` | FPGA firmware minor version number |
| `0x0012` | `BUILD_DATE` | — | `0x20260415` | Firmware build date in packed BCD format (YYYYMMDD) |
| `0x0100` | `UART_BAUD_DIV` | — | `0x0068` | UART baud rate divisor for 115200 baud @ 100MHz UART_CLK |
| `0x0101` | `UART_CTRL` | — | `0x01` | UART control register |
| `0x0102` | `UART_STATUS` | — | `0x02` | UART status flags - read clears pending conditions |
| `0x0103` | `UART_TX_COUNT` | — | `0x00` | TX FIFO fill level indicator |
| `0x0104` | `UART_RX_COUNT` | — | `0x00` | RX FIFO fill level indicator |
| `0x0110` | `ETH_MAC_LOW` | — | `0x0000` | Lower 16 bits of Ethernet MAC address |
| `0x0111` | `ETH_MAC_HIGH` | — | `0x0000` | Upper 16 bits of Ethernet MAC address |
| `0x0200` | `ADC_CTRL` | — | `0x00` | ADC control for XADC/internal ADC monitoring |
| `0x0201` | `ADC_STATUS` | — | `0x00` | ADC status flags |
| `0x0210` | `VCC_5V_RAW` | — | `0x0000` | 5V rail ADC count (12-bit XADC) |
| `0x0211` | `VCC_3V3_RAW` | — | `0x0000` | 3.3V rail (TPS62913) ADC count |
| `0x0212` | `VCC_1V5_RAW` | — | `0x0000` | 1.5V FPGA rail (LT3045-15) ADC count |
| `0x0213` | `VCC_1V2_RAW` | — | `0x0000` | 1.2V FPGA MGT/AVCC rail (LT3045-12) ADC count |
| `0x0214` | `VCC_1V0_RAW` | — | `0x0000` | 1.0V ADC core rail (LT3045-10) ADC count |
| `0x0300` | `TEMP_LOCAL` | — | `0x0000` | FPGA die temperature in 0.25°C units (signed) |
| `0x0301` | `TEMP_REMOTE1` | — | `0x0000` | Remote temperature sensor 1 (HMC1099 LP5DE area) |
| `0x0302` | `TEMP_REMOTE2` | — | `0x0000` | Remote temperature sensor 2 (ADC12DJ5200RF area) |
| `0x0308` | `TEMP_ALERT_HIGH` | — | `0x0190` | Over-temperature alert threshold (100°C default) |
| `0x0309` | `TEMP_ALERT_LOW` | — | `0xFF9C` | Under-temperature alert threshold (-25°C default) |
| `0x030F` | `HEALTH_STATUS` | — | `0x87` | System health status aggregate |
| `0x0400` | `PLL_CTRL` | — | `0x00` | PLL/LMK04828B control register |
| `0x0401` | `PLL_STATUS` | — | `0x00` | PLL/LMK04828B status flags |
| `0x0402` | `PLL_N_DIV` | — | `0x0064` | PLL N divider value (100 default for 5.2 GHz) |
| `0x0403` | `PLL_R_DIV` | — | `0x0001` | PLL R divider (reference divider) |
| `0x0410` | `CLK_ENABLE` | — | `0x0F` | Clock output enables for LMK04828B outputs |
| `0x0500` | `EEPROM_CTRL` | — | `0x00` | EEPROM interface control register |
| `0x0501` | `EEPROM_ADDR` | — | `0x0000` | EEPROM byte address for read/write operations |
| `0x0502` | `EEPROM_DATA` | — | `0x0000` | EEPROM read/write data port |
| `0x0600` | `FLASH_CTRL` | — | `0x00` | Configuration flash interface control |
| `0x0601` | `FLASH_ADDR_LOW` | — | `0x0000` | Flash address low word [15:0] |
| `0x0602` | `FLASH_ADDR_HIGH` | — | `0x0000` | Flash address high word [23:16] |
| `0x0603` | `FLASH_DATA` | — | `0x0000` | Flash data FIFO for read/write |
| `0x0604` | `FLASH_STATUS` | — | `0x01` | Flash operation status flags |
| `0x0700` | `RF_VGA_GAIN` | — | `0x7F80` | HMC698LP4 VGA gain control (SPI mapped) |
| `0x0701` | `RF_LNA_ENABLE` | — | `0x00` | RF front-end LNA and limiter enable |
| `0x0702` | `RF_PHASE_CTRL` | — | `0x0000` | RF phase/control interface (future expansion) |
| `0x0703` | `RF_STATUS` | — | `0x00` | RF front-end status monitoring |
| `0x0800` | `GPIO_CTRL` | — | `0x00` | General-purpose I/O control register |
| `0x0801` | `GPIO_DATA` | — | `0x00` | GPIO data read/write |
| `0x0900` | `DAC_OUTPUT_0` | — | `0x0000` | DAC output channel 0 (future expansion) |
| `0x0901` | `DAC_OUTPUT_1` | — | `0x0000` | DAC output channel 1 (future expansion) |
| `0x0A00` | `JESD_CTRL` | — | `0x00` | JESD204B/C ADC interface control |
| `0x0A01` | `JESD_STATUS` | — | `0x00` | JESD204B/C link status monitoring |
| `0x0A02` | `JESD_SCRATCH` | — | `0x0000` | JESD204B/C test pattern generator control |
| `0x0B00` | `DDC_CTRL` | — | `0x00` | Digital Down Converter (DDC) control |
| `0x0B01` | `DDC_NCO_FREQ` | — | `0x0000` | DDC NCO frequency tuning word (32-bit phase accumulator) |
| `0x0B02` | `DDC_NCO_FREQ_HIGH` | — | `0x0000` | DDC NCO frequency tuning word high |
| `0x0F00` | `APP_CTRL` | — | `0x00` | Application-specific control register |
| `0x0F01` | `APP_STATUS` | — | `0x00` | Application status register |

---
### `BOARD_ID` — Address `0x0000`

**Reset value:** `0x5559`  **Access:** see fields below

Board identification code - 'UY' in ASCII (0x5559)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BOARD_ID` | `[15:0]` | R | `0x5559` | Unique board identifier for uyj project - ASCII 'UY' |

---
### `BOARD_VERSION` — Address `0x0001`

**Reset value:** `0x01`  **Access:** see fields below

Hardware revision number

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAJOR` | `[7:4]` | R | `0x0` | Major version - incremented on PCB respin |
| `MINOR` | `[3:0]` | R | `0x1` | Minor version - incremented on assembly change |

---
### `BOARD_TYPE_ID` — Address `0x0002`

**Reset value:** `0x5252`  **Access:** see fields below

Board type identifier - 'RR' for RF Receiver

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BOARD_TYPE` | `[15:0]` | R | `0x5252` | Product type code |

---
### `SCRATCHPAD` — Address `0x0003`

**Reset value:** `0x0000`  **Access:** see fields below

Read/write test register for RAM verification

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEST_DATA` | `[15:0]` | RW | `0x0000` | General-purpose test register for diagnostics |

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

**Reset value:** `0x20260415`  **Access:** see fields below

Firmware build date in packed BCD format (YYYYMMDD)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BUILD_DATE` | `[31:0]` | R | `0x20260415` | Build date stamp for firmware traceability |

---
### `UART_BAUD_DIV` — Address `0x0100`

**Reset value:** `0x0068`  **Access:** see fields below

UART baud rate divisor for 115200 baud @ 100MHz UART_CLK

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DIVISOR` | `[15:0]` | RW | `0x0068` | Baud divisor = UART_CLK / (16 * baud_rate); 0x0068 = 104 for 115200 baud |

---
### `UART_CTRL` — Address `0x0101`

**Reset value:** `0x01`  **Access:** see fields below

UART control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0x1` | UART enable (1=enabled) |
| `LOOPBACK` | `[1]` | RW | `0x0` | Internal loopback mode for test |
| `FRAME_FORMAT` | `[7:4]` | RW | `0x3` | Frame format: 0x3=8N1 (8 data, no parity, 1 stop) |
| `RESERVED` | `[15:8]` | R | `0x00` | Reserved bits |

---
### `UART_STATUS` — Address `0x0102`

**Reset value:** `0x02`  **Access:** see fields below

UART status flags - read clears pending conditions

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TX_BUSY` | `[0]` | R | `0x0` | Transmitter busy flag |
| `RX_AVAIL` | `[1]` | R | `0x0` | Data available in RX FIFO |
| `FRAME_ERR` | `[2]` | RC | `0x0` | Framing error detected (read-clear) |
| `PARITY_ERR` | `[3]` | RC | `0x0` | Parity error detected (read-clear) |
| `RX_EMPTY` | `[4]` | R | `0x1` | RX FIFO empty |

---
### `UART_TX_COUNT` — Address `0x0103`

**Reset value:** `0x00`  **Access:** see fields below

TX FIFO fill level indicator

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TX_COUNT` | `[7:0]` | R | `0x00` | Number of bytes in TX FIFO |

---
### `UART_RX_COUNT` — Address `0x0104`

**Reset value:** `0x00`  **Access:** see fields below

RX FIFO fill level indicator

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `RX_COUNT` | `[7:0]` | R | `0x00` | Number of bytes in RX FIFO |

---
### `ETH_MAC_LOW` — Address `0x0110`

**Reset value:** `0x0000`  **Access:** see fields below

Lower 16 bits of Ethernet MAC address

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAC_LOW` | `[15:0]` | R | `0x0000` | MAC address [15:0] |

---
### `ETH_MAC_HIGH` — Address `0x0111`

**Reset value:** `0x0000`  **Access:** see fields below

Upper 16 bits of Ethernet MAC address

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAC_HIGH` | `[31:16]` | R | `0x0000` | MAC address [31:16] |

---
### `ADC_CTRL` — Address `0x0200`

**Reset value:** `0x00`  **Access:** see fields below

ADC control for XADC/internal ADC monitoring

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `START` | `[0]` | RW | `0x0` | Start ADC conversion single-shot |
| `CONTINUOUS` | `[1]` | RW | `0x0` | Enable continuous conversion mode |
| `CHANNEL_SEL` | `[3:2]` | RW | `0x0` | Channel select: 0=auto-sequence, 1-3=specific channel |

---
### `ADC_STATUS` — Address `0x0201`

**Reset value:** `0x00`  **Access:** see fields below

ADC status flags

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA_READY` | `[0]` | R | `0x0` | New conversion data available |
| `OVERRANGE` | `[1]` | RC | `0x0` | Input overrange detected (read-clear) |
| `BUSY` | `[2]` | R | `0x0` | ADC conversion in progress |

---
### `VCC_5V_RAW` — Address `0x0210`

**Reset value:** `0x0000`  **Access:** see fields below

5V rail ADC count (12-bit XADC)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | R | `0x000` | Raw ADC count for 5V rail (multiply by 5.0/4096 for Volts) |
| `RESERVED` | `[15:12]` | R | `0x0` | Reserved |

---
### `VCC_3V3_RAW` — Address `0x0211`

**Reset value:** `0x0000`  **Access:** see fields below

3.3V rail (TPS62913) ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | R | `0x000` | Raw ADC count for 3.3V rail (multiply by 3.3/4096 for Volts) |
| `RESERVED` | `[15:12]` | R | `0x0` | Reserved |

---
### `VCC_1V5_RAW` — Address `0x0212`

**Reset value:** `0x0000`  **Access:** see fields below

1.5V FPGA rail (LT3045-15) ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | R | `0x000` | Raw ADC count for 1.5V rail (multiply by 1.5/4096 for Volts) |
| `RESERVED` | `[15:12]` | R | `0x0` | Reserved |

---
### `VCC_1V2_RAW` — Address `0x0213`

**Reset value:** `0x0000`  **Access:** see fields below

1.2V FPGA MGT/AVCC rail (LT3045-12) ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | R | `0x000` | Raw ADC count for 1.2V rail (multiply by 1.2/4096 for Volts) |
| `RESERVED` | `[15:12]` | R | `0x0` | Reserved |

---
### `VCC_1V0_RAW` — Address `0x0214`

**Reset value:** `0x0000`  **Access:** see fields below

1.0V ADC core rail (LT3045-10) ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | R | `0x000` | Raw ADC count for 1.0V rail (multiply by 1.0/4096 for Volts) |
| `RESERVED` | `[15:12]` | R | `0x0` | Reserved |

---
### `TEMP_LOCAL` — Address `0x0300`

**Reset value:** `0x0000`  **Access:** see fields below

FPGA die temperature in 0.25°C units (signed)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_C` | `[9:0]` | R | `0x000` | Die temperature in 0.25°C steps (signed 10-bit) |
| `RESERVED` | `[15:10]` | R | `0x0` | Reserved |

---
### `TEMP_REMOTE1` — Address `0x0301`

**Reset value:** `0x0000`  **Access:** see fields below

Remote temperature sensor 1 (HMC1099 LP5DE area)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_C` | `[9:0]` | R | `0x000` | Remote temp sensor 1 reading (signed 10-bit) |
| `RESERVED` | `[15:10]` | R | `0x0` | Reserved |

---
### `TEMP_REMOTE2` — Address `0x0302`

**Reset value:** `0x0000`  **Access:** see fields below

Remote temperature sensor 2 (ADC12DJ5200RF area)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_C` | `[9:0]` | R | `0x000` | Remote temp sensor 2 reading (signed 10-bit) |
| `RESERVED` | `[15:10]` | R | `0x0` | Reserved |

---
### `TEMP_ALERT_HIGH` — Address `0x0308`

**Reset value:** `0x0190`  **Access:** see fields below

Over-temperature alert threshold (100°C default)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `THRESHOLD` | `[9:0]` | RW | `0x190` | High temperature threshold in 0.25°C units (0x190 = 100°C) |
| `RESERVED` | `[15:10]` | R | `0x0` | Reserved |

---
### `TEMP_ALERT_LOW` — Address `0x0309`

**Reset value:** `0xFF9C`  **Access:** see fields below

Under-temperature alert threshold (-25°C default)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `THRESHOLD` | `[9:0]` | RW | `0x39C` | Low temperature threshold in 0.25°C units (0x39C = -25°C signed) |
| `RESERVED` | `[15:10]` | R | `0x0` | Reserved |

---
### `HEALTH_STATUS` — Address `0x030F`

**Reset value:** `0x87`  **Access:** see fields below

System health status aggregate

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_OK` | `[0]` | R | `0x1` | Temperature within limits (1=OK) |
| `VOLT_OK` | `[1]` | R | `0x1` | All supply rails within tolerance (1=OK) |
| `PLL_LOCK` | `[2]` | R | `0x0` | PLL lock indicator (1=locked) |
| `JESD_LINK_OK` | `[3]` | R | `0x0` | JESD204B link aligned (1=OK) |
| `RF_FRONTEND_OK` | `[4]` | R | `0x1` | RF front-end detected (1=OK) |
| `SYSTEM_OK` | `[7]` | R | `0x0` | Overall system health (1=OK - all checks pass) |
| `RESERVED` | `[15:8]` | R | `0x0` | Reserved |

---
### `PLL_CTRL` — Address `0x0400`

**Reset value:** `0x00`  **Access:** see fields below

PLL/LMK04828B control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0x0` | PLL enable (1=enabled) |
| `RESET` | `[1]` | RW | `0x0` | PLL reset (1=reset active) |
| `REF_SEL` | `[3:2]` | RW | `0x0` | Reference clock select: 0=internal OSC, 1=external ref, 2=backup |

---
### `PLL_STATUS` — Address `0x0401`

**Reset value:** `0x00`  **Access:** see fields below

PLL/LMK04828B status flags

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LOCKED` | `[0]` | R | `0x0` | PLL lock indicator (1=locked) |
| `LOSS_OF_LOCK` | `[1]` | RC | `0x0` | Loss of lock event (read-clear) |
| `CLK_VALID` | `[2]` | R | `0x0` | Reference clock valid (1=OK) |

---
### `PLL_N_DIV` — Address `0x0402`

**Reset value:** `0x0064`  **Access:** see fields below

PLL N divider value (100 default for 5.2 GHz)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `N_DIVIDER` | `[15:0]` | RW | `0x64` | N divider ratio for PLL feedback |

---
### `PLL_R_DIV` — Address `0x0403`

**Reset value:** `0x0001`  **Access:** see fields below

PLL R divider (reference divider)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `R_DIVIDER` | `[7:0]` | RW | `0x01` | R divider ratio for reference path |
| `RESERVED` | `[15:8]` | R | `0x0` | Reserved |

---
### `CLK_ENABLE` — Address `0x0410`

**Reset value:** `0x0F`  **Access:** see fields below

Clock output enables for LMK04828B outputs

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `CLK0_EN` | `[0]` | RW | `0x1` | Clock output 0 enable (ADC_CLK) |
| `CLK1_EN` | `[1]` | RW | `0x1` | Clock output 1 enable (FPGA_REFCLK) |
| `CLK2_EN` | `[2]` | RW | `0x1` | Clock output 2 enable (SYSCLK) |
| `CLK3_EN` | `[3]` | RW | `0x1` | Clock output 3 enable (JESD_REFCLK) |
| `RESERVED` | `[15:4]` | R | `0x0` | Reserved |

---
### `EEPROM_CTRL` — Address `0x0500`

**Reset value:** `0x00`  **Access:** see fields below

EEPROM interface control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READ` | `[0]` | RW | `0x0` | Initiate read operation (1=start) |
| `WRITE` | `[1]` | RW | `0x0` | Initiate write operation (1=start) |
| `ERASE` | `[2]` | RW | `0x0` | Initiate erase operation (1=start) |
| `BUSY` | `[7]` | R | `0x0` | EEPROM operation in progress (1=busy) |
| `RESERVED` | `[15:8]` | R | `0x0` | Reserved |

---
### `EEPROM_ADDR` — Address `0x0501`

**Reset value:** `0x0000`  **Access:** see fields below

EEPROM byte address for read/write operations

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BYTE_ADDR` | `[15:0]` | RW | `0x0000` | 16-bit EEPROM byte address |

---
### `EEPROM_DATA` — Address `0x0502`

**Reset value:** `0x0000`  **Access:** see fields below

EEPROM read/write data port

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA` | `[15:0]` | RW | `0x0000` | 16-bit data for EEPROM operations |

---
### `FLASH_CTRL` — Address `0x0600`

**Reset value:** `0x00`  **Access:** see fields below

Configuration flash interface control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READ` | `[0]` | RW | `0x0` | Initiate flash read (1=start) |
| `WRITE` | `[1]` | RW | `0x0` | Initiate flash write (1=start) |
| `ERASE_SECTOR` | `[2]` | RW | `0x0` | Erase flash sector (1=start) |
| `ERASE_CHIP` | `[3]` | RW | `0x0` | Erase entire chip (requires unlock sequence) |
| `BUSY` | `[7]` | R | `0x0` | Flash operation busy flag |

---
### `FLASH_ADDR_LOW` — Address `0x0601`

**Reset value:** `0x0000`  **Access:** see fields below

Flash address low word [15:0]

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADDR_LOW` | `[15:0]` | RW | `0x0000` | Flash address lower 16 bits |

---
### `FLASH_ADDR_HIGH` — Address `0x0602`

**Reset value:** `0x0000`  **Access:** see fields below

Flash address high word [23:16]

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADDR_HIGH` | `[7:0]` | RW | `0x00` | Flash address upper 8 bits |
| `RESERVED` | `[15:8]` | R | `0x0` | Reserved |

---
### `FLASH_DATA` — Address `0x0603`

**Reset value:** `0x0000`  **Access:** see fields below

Flash data FIFO for read/write

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA` | `[15:0]` | RW | `0x0000` | 16-bit data for flash operations |

---
### `FLASH_STATUS` — Address `0x0604`

**Reset value:** `0x01`  **Access:** see fields below

Flash operation status flags

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READY` | `[0]` | R | `0x1` | Flash ready for new operation (1=ready) |
| `WRITE_ERR` | `[1]` | RC | `0x0` | Write operation failed (read-clear) |
| `ERASE_ERR` | `[2]` | RC | `0x0` | Erase operation failed (read-clear) |

---
### `RF_VGA_GAIN` — Address `0x0700`

**Reset value:** `0x7F80`  **Access:** see fields below

HMC698LP4 VGA gain control (SPI mapped)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GAIN_CODE` | `[6:0]` | RW | `0x40` | 7-bit gain code for HMC698LP4 (0=max gain, 127=min gain) |
| `GAIN_UNLOCK` | `[15]` | W | `0x0` | Write 1 to unlock gain register writes |
| `RESERVED` | `[14:7]` | R | `0x0` | Reserved |

---
### `RF_LNA_ENABLE` — Address `0x0701`

**Reset value:** `0x00`  **Access:** see fields below

RF front-end LNA and limiter enable

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LNA_EN` | `[0]` | RW | `0x0` | HMC1099LP5DE LNA enable (1=ON) |
| `LIMITER_EN` | `[1]` | RW | `0x0` | HMC1061LP4E limiter enable (1=ON) |
| `BIAS_EN` | `[2]` | RW | `0x0` | LNA bias enable (1=ON) |

---
### `RF_PHASE_CTRL` — Address `0x0702`

**Reset value:** `0x0000`  **Access:** see fields below

RF phase/control interface (future expansion)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `PHASE_CODE` | `[9:0]` | RW | `0x000` | Phase control word |
| `RESERVED` | `[15:10]` | R | `0x0` | Reserved |

---
### `RF_STATUS` — Address `0x0703`

**Reset value:** `0x00`  **Access:** see fields below

RF front-end status monitoring

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LNA_PRESENT` | `[0]` | R | `0x1` | LNA detected (1=present) |
| `VGA_PRESENT` | `[1]` | R | `0x1` | VGA detected (1=present) |
| `RF_POWER_GOOD` | `[2]` | R | `0x1` | 5V LNA power good (1=OK) |
| `TEMP_WARN` | `[3]` | R | `0x0` | RF front-end temperature warning |

---
### `GPIO_CTRL` — Address `0x0800`

**Reset value:** `0x00`  **Access:** see fields below

General-purpose I/O control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GPIO0_OE` | `[0]` | RW | `0x0` | GPIO0 output enable (1=output) |
| `GPIO1_OE` | `[1]` | RW | `0x0` | GPIO1 output enable (1=output) |
| `GPIO2_OE` | `[2]` | RW | `0x0` | GPIO2 output enable (1=output) |
| `GPIO3_OE` | `[3]` | RW | `0x0` | GPIO3 output enable (1=output) |
| `RESERVED` | `[15:4]` | R | `0x0` | Reserved |

---
### `GPIO_DATA` — Address `0x0801`

**Reset value:** `0x00`  **Access:** see fields below

GPIO data read/write

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GPIO0` | `[0]` | RW | `0x0` | GPIO0 data bit |
| `GPIO1` | `[1]` | RW | `0x0` | GPIO1 data bit |
| `GPIO2` | `[2]` | RW | `0x0` | GPIO2 data bit |
| `GPIO3` | `[3]` | RW | `0x0` | GPIO3 data bit |
| `RESERVED` | `[15:4]` | R | `0x0` | Reserved |

---
### `DAC_OUTPUT_0` — Address `0x0900`

**Reset value:** `0x0000`  **Access:** see fields below

DAC output channel 0 (future expansion)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DAC_DATA` | `[15:0]` | RW | `0x0000` | 16-bit DAC output code |

---
### `DAC_OUTPUT_1` — Address `0x0901`

**Reset value:** `0x0000`  **Access:** see fields below

DAC output channel 1 (future expansion)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DAC_DATA` | `[15:0]` | RW | `0x0000` | 16-bit DAC output code |

---
### `JESD_CTRL` — Address `0x0A00`

**Reset value:** `0x00`  **Access:** see fields below

JESD204B/C ADC interface control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LINK_ENABLE` | `[0]` | RW | `0x0` | Enable JESD204B link (1=enabled) |
| `RESET` | `[1]` | RW | `0x0` | JESD204B link reset (1=reset) |
| `LANE_MASK` | `[9:2]` | RW | `0xFF` | Lane enable mask (8 lanes) |
| `SUBCLASS` | `[11:10]` | RW | `0x1` | JESD subclass: 0=0, 1=1 (deterministic latency) |

---
### `JESD_STATUS` — Address `0x0A01`

**Reset value:** `0x00`  **Access:** see fields below

JESD204B/C link status monitoring

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LINK_ALIGN` | `[0]` | R | `0x0` | Lane alignment achieved (1=aligned) |
| `CODE_GRP_SYNC` | `[1]` | R | `0x0` | Code group sync (1=synced) |
| `ILAS_ERR` | `[2]` | RC | `0x0` | ILAS error detected (read-clear) |
| `DISP_ERR` | `[3]` | RC | `0x0` | Disparity error (read-clear) |
| `LANE_OK` | `[11:4]` | R | `0x00` | Per-lane status (1=OK) |
| `RESERVED` | `[15:12]` | R | `0x0` | Reserved |

---
### `JESD_SCRATCH` — Address `0x0A02`

**Reset value:** `0x0000`  **Access:** see fields below

JESD204B/C test pattern generator control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEST_EN` | `[0]` | RW | `0x0` | Enable test pattern mode |
| `TEST_MODE` | `[2:1]` | RW | `0x0` | Test pattern: 00=PRBS7, 01=PRBS15, 10=Alt 0x1F, 11=Fixed |

---
### `DDC_CTRL` — Address `0x0B00`

**Reset value:** `0x00`  **Access:** see fields below

Digital Down Converter (DDC) control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0x0` | Enable DDC (1=enabled) |
| `DECIMATION` | `[4:1]` | RW | `0x4` | Decimation factor (log2): 0=2, 1=4, 2=8, 3=16, 4=32 |
| `NCO_RESET` | `[8]` | RW | `0x0` | Reset NCO accumulator (1=reset) |

---
### `DDC_NCO_FREQ` — Address `0x0B01`

**Reset value:** `0x0000`  **Access:** see fields below

DDC NCO frequency tuning word (32-bit phase accumulator)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `FTW_LOW` | `[15:0]` | RW | `0x0000` | Frequency tuning word [15:0] (lower 16 bits) |
| `RESERVED` | `[15:0]` | R | `0x0` | Reserved |

---
### `DDC_NCO_FREQ_HIGH` — Address `0x0B02`

**Reset value:** `0x0000`  **Access:** see fields below

DDC NCO frequency tuning word high

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `FTW_HIGH` | `[15:0]` | RW | `0x0000` | Frequency tuning word [31:16] (upper 16 bits) |

---
### `APP_CTRL` — Address `0x0F00`

**Reset value:** `0x00`  **Access:** see fields below

Application-specific control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ACQUISITION_EN` | `[0]` | RW | `0x0` | Enable data acquisition (1=running) |
| `STREAM_EN` | `[1]` | RW | `0x0` | Enable data streaming (1=streaming) |
| `TRIGGER_MODE` | `[4:2]` | RW | `0x0` | Trigger mode: 0=free-run, 1=external, 2=software, 3=pattern |

---
### `APP_STATUS` — Address `0x0F01`

**Reset value:** `0x00`  **Access:** see fields below

Application status register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ACQ_RUNNING` | `[0]` | R | `0x0` | Acquisition active (1=running) |
| `STREAM_ACTIVE` | `[1]` | R | `0x0` | Stream active (1=streaming) |
| `TRIGGERED` | `[2]` | RC | `0x0` | Trigger detected (read-clear) |
| `BUFFER_OVERRUN` | `[3]` | RC | `0x0` | Capture buffer overrun (read-clear) |
