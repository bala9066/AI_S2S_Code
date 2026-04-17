# Register Description Table (RDT)
## jhf

> **Total registers:** 53

JHF Wideband RF Receiver (5-18 GHz) FPGA Register Map - Complete register set for Artix-7 FPGA controlling ADF5356 LO synthesizer, HMC698LP4 digital VGA, LTC2992/AD7416 health monitoring, AT25M01 EEPROM, system communication, and RF path configuration. 32 memory-mapped registers across 10 functional groups with 18-step initialization sequence covering power-on self-check, PLL lock, VGA gain ramp, temperature alert setup, and peripheral enable.

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
| `0x0000` | `BOARD_ID` | — | `0x4A48` | Board identification code - ASCII 'JH' (0x4A48) for JHF receiver |
| `0x0001` | `BOARD_VERSION` | — | `0x10` | Hardware version number - major.minor format |
| `0x0002` | `BOARD_TYPE_ID` | — | `0x5246` | Board type identifier - ASCII 'RF' (0x5246) |
| `0x0003` | `SCRATCHPAD` | — | `0x0000` | General-purpose read/write test register for RAM and bus integrity verification |
| `0x0010` | `MCS_VERSION_MAJOR` | — | `0x01` | FPGA firmware major version number |
| `0x0011` | `MCS_VERSION_MINOR` | — | `0x00` | FPGA firmware minor version number |
| `0x0012` | `BUILD_DATE` | — | `0x20260417` | Firmware build date in packed BCD format (YYYYMMDD) |
| `0x0100` | `UART_BAUD_DIV` | — | `0x0022` | UART baud rate divisor - default 115200 baud (100MHz/0x0022/16 ≈ 115200) |
| `0x0101` | `UART_CTRL` | — | `0x01` | UART control register - enable, loopback, frame format |
| `0x0102` | `UART_STATUS` | — | `0x00` | UART status flags - clears on read |
| `0x0103` | `UART_TX_COUNT` | — | `0x00` | TX FIFO byte count |
| `0x0104` | `UART_RX_COUNT` | — | `0x00` | RX FIFO byte count |
| `0x0110` | `ETH_MAC_LOW` | — | `0x0000` | Ethernet MAC address lower 16 bits |
| `0x0111` | `ETH_MAC_HIGH` | — | `0x0000` | Ethernet MAC address upper 16 bits |
| `0x0200` | `ADC_CTRL` | — | `0x00` | ADC control - start conversion, continuous mode, channel select |
| `0x0201` | `ADC_STATUS` | — | `0x00` | ADC status flags |
| `0x0210` | `VCC_5V_RAW` | — | `0x0000` | 5V rail ADC raw count (12-bit) |
| `0x0211` | `VCC_3V3_RAW` | — | `0x0000` | 3.3V rail ADC raw count (LT3042 output) |
| `0x0212` | `VCC_NEG5_RAW` | — | `0x0000` | -5V rail ADC raw count (LM2991 output) |
| `0x0213` | `VCC_12V_RAW` | — | `0x0000` | 12V input rail ADC raw count |
| `0x0218` | `ICC_5V_RAW` | — | `0x0000` | 5V rail current sense ADC raw count |
| `0x0219` | `ICC_3V3_RAW` | — | `0x0000` | 3.3V rail current sense ADC raw count |
| `0x0300` | `TEMP_LOCAL` | — | `0x0190` | Local FPGA die temperature in 0.25°C units (signed) |
| `0x0301` | `TEMP_REMOTE1` | — | `0x0000` | Remote sensor 1 temperature (AD7416 on RF board) |
| `0x0302` | `TEMP_REMOTE2` | — | `0x0000` | Remote sensor 2 temperature (optional external) |
| `0x0308` | `TEMP_ALERT_HIGH` | — | `0x003C` | Over-temperature alert threshold (0x003C = 60°C) |
| `0x0309` | `TEMP_ALERT_LOW` | — | `0xFF9C` | Under-temperature alert threshold (0xFF9C = -25°C) |
| `0x030F` | `HEALTH_STATUS` | — | `0x00` | System health status flags |
| `0x0400` | `PLL_CTRL` | — | `0x00` | PLL control for ADF5356 LO synthesizer |
| `0x0401` | `PLL_STATUS` | — | `0x00` | PLL lock status from ADF5356 |
| `0x0402` | `PLL_N_DIV` | — | `0x0078` | PLL N divider (0x0078 = 120 decimal for ADF5356) |
| `0x0403` | `PLL_R_DIV` | — | `0x0001` | PLL R divider (reference divider) |
| `0x0410` | `CLK_ENABLE` | — | `0x0F` | Clock output enables for system |
| `0x0500` | `EEPROM_CTRL` | — | `0x00` | AT25M01 1Mb SPI EEPROM control |
| `0x0501` | `EEPROM_ADDR` | — | `0x0000` | EEPROM byte address (17-bit address, 128KB) |
| `0x0502` | `EEPROM_DATA` | — | `0x0000` | EEPROM read/write data (16-bit word) |
| `0x0600` | `FLASH_CTRL` | — | `0x00` | Configuration flash control interface |
| `0x0601` | `FLASH_ADDR_LOW` | — | `0x0000` | Flash address lower 16 bits |
| `0x0602` | `FLASH_ADDR_HIGH` | — | `0x0000` | Flash address upper 8 bits |
| `0x0603` | `FLASH_DATA` | — | `0x0000` | Flash data FIFO (16-bit) |
| `0x0604` | `FLASH_STATUS` | — | `0x01` | Flash operation status |
| `0x0700` | `RF_LO_FREQ_HIGH` | — | `0x0C1C` | LO frequency high word - ADF5356 integer divider (default 8 GHz) |
| `0x0701` | `RF_LO_FREQ_LOW` | — | `0x0000` | LO frequency low word - fractional divider |
| `0x0702` | `RF_LO_CTRL` | — | `0x00` | LO synthesizer control (ADF5356 SPI interface) |
| `0x0703` | `RF_LO_PHASE` | — | `0x0000` | LO phase adjust word (ADF5356 phase adjust) |
| `0x0708` | `VGA_GAIN_CTRL` | — | `0x20` | HMC698LP4 VGA gain control (6-bit, 31.5dB range) |
| `0x0709` | `RF_PATH_CTRL` | — | `0x01` | RF path control - LNA enable, mixer bias |
| `0x070A` | `RF_STATUS` | — | `0x00` | RF chain status flags |
| `0x0800` | `GPIO_DIR` | — | `0x00` | GPIO direction control (0=input, 1=output) |
| `0x0801` | `GPIO_DATA` | — | `0x00` | GPIO data read/write |
| `0x0802` | `LED_CTRL` | — | `0x0F` | LED control register |
| `0x0900` | `DAC_CTRL` | — | `0x00` | DAC control (optional DAC for calibration) |
| `0x0901` | `DAC_DATA` | — | `0x8000` | DAC data output (12-16 bit) |

---
### `BOARD_ID` — Address `0x0000`

**Reset value:** `0x4A48`  **Access:** see fields below

Board identification code - ASCII 'JH' (0x4A48) for JHF receiver

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ID_CODE` | `[15:0]` | R | `0x4A48` | Board ID - 0x4A48 = 'JH' ASCII |

---
### `BOARD_VERSION` — Address `0x0001`

**Reset value:** `0x10`  **Access:** see fields below

Hardware version number - major.minor format

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAJOR` | `[7:4]` | R | `0x1` | Major version (1 = initial production) |
| `MINOR` | `[3:0]` | R | `0x0` | Minor version (0 = baseline) |

---
### `BOARD_TYPE_ID` — Address `0x0002`

**Reset value:** `0x5246`  **Access:** see fields below

Board type identifier - ASCII 'RF' (0x5246)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TYPE_CODE` | `[15:0]` | R | `0x5246` | Type ID - 0x5246 = 'RF' (receiver type) |

---
### `SCRATCHPAD` — Address `0x0003`

**Reset value:** `0x0000`  **Access:** see fields below

General-purpose read/write test register for RAM and bus integrity verification

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEST_DATA` | `[15:0]` | RW | `0x0000` | Scratchpad value - any value can be written and read back |

---
### `MCS_VERSION_MAJOR` — Address `0x0010`

**Reset value:** `0x01`  **Access:** see fields below

FPGA firmware major version number

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `FW_MAJOR` | `[7:0]` | R | `0x01` | Firmware major version |

---
### `MCS_VERSION_MINOR` — Address `0x0011`

**Reset value:** `0x00`  **Access:** see fields below

FPGA firmware minor version number

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `FW_MINOR` | `[7:0]` | R | `0x00` | Firmware minor version |

---
### `BUILD_DATE` — Address `0x0012`

**Reset value:** `0x20260417`  **Access:** see fields below

Firmware build date in packed BCD format (YYYYMMDD)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BUILD_BCD` | `[31:0]` | R | `0x20260417` | Build date - 2026.04.17 (17 Apr 2026) |

---
### `UART_BAUD_DIV` — Address `0x0100`

**Reset value:** `0x0022`  **Access:** see fields below

UART baud rate divisor - default 115200 baud (100MHz/0x0022/16 ≈ 115200)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BAUD_DIV` | `[15:0]` | RW | `0x0022` | Baud divisor = f_clk/(16*baud_rate) |

---
### `UART_CTRL` — Address `0x0101`

**Reset value:** `0x01`  **Access:** see fields below

UART control register - enable, loopback, frame format

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0x1` | UART enable (1=enabled) |
| `LOOPBACK` | `[1]` | RW | `0x0` | Loopback mode for test (1=loopback) |
| `FRAME_FORMAT` | `[7:4]` | RW | `0x0` | Frame format (0x0=8N1 standard) |

---
### `UART_STATUS` — Address `0x0102`

**Reset value:** `0x00`  **Access:** see fields below

UART status flags - clears on read

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TX_BUSY` | `[0]` | R | `0x0` | Transmitter busy flag |
| `RX_AVAIL` | `[1]` | R | `0x0` | Data available in RX FIFO |
| `FRAME_ERR` | `[2]` | RC | `0x0` | Frame error detected (clears on read) |

---
### `UART_TX_COUNT` — Address `0x0103`

**Reset value:** `0x00`  **Access:** see fields below

TX FIFO byte count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TX_FIFO_CNT` | `[7:0]` | R | `0x00` | Number of bytes in TX FIFO |

---
### `UART_RX_COUNT` — Address `0x0104`

**Reset value:** `0x00`  **Access:** see fields below

RX FIFO byte count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `RX_FIFO_CNT` | `[7:0]` | R | `0x00` | Number of bytes in RX FIFO |

---
### `ETH_MAC_LOW` — Address `0x0110`

**Reset value:** `0x0000`  **Access:** see fields below

Ethernet MAC address lower 16 bits

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAC_LOW` | `[15:0]` | R | `0x0000` | MAC address bytes [1:0] (LSW) |

---
### `ETH_MAC_HIGH` — Address `0x0111`

**Reset value:** `0x0000`  **Access:** see fields below

Ethernet MAC address upper 16 bits

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAC_HIGH` | `[15:0]` | R | `0x0000` | MAC address bytes [5:4] (MSW) |

---
### `ADC_CTRL` — Address `0x0200`

**Reset value:** `0x00`  **Access:** see fields below

ADC control - start conversion, continuous mode, channel select

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `START` | `[0]` | RW | `0x0` | Start single conversion (1=start, auto-clears) |
| `CONTINUOUS` | `[1]` | RW | `0x0` | Continuous conversion mode (1=continuous) |
| `CHANNEL_SEL` | `[3:2]` | RW | `0x0` | Channel select (0=VCC_5V, 1=VCC_3V3, 2=VCC_NEG5, 3=VCC_12V) |

---
### `ADC_STATUS` — Address `0x0201`

**Reset value:** `0x00`  **Access:** see fields below

ADC status flags

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA_READY` | `[0]` | R | `0x0` | New data available flag |
| `OVERRANGE` | `[1]` | RC | `0x0` | Overrange detected (clears on read) |

---
### `VCC_5V_RAW` — Address `0x0210`

**Reset value:** `0x0000`  **Access:** see fields below

5V rail ADC raw count (12-bit)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_5V` | `[11:0]` | R | `0x0000` | 5V ADC count (LSB = 5.0V/4096 ≈ 1.22mV) |

---
### `VCC_3V3_RAW` — Address `0x0211`

**Reset value:** `0x0000`  **Access:** see fields below

3.3V rail ADC raw count (LT3042 output)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_3V3` | `[11:0]` | R | `0x0000` | 3.3V ADC count (LSB = 3.3V/4096 ≈ 0.81mV) |

---
### `VCC_NEG5_RAW` — Address `0x0212`

**Reset value:** `0x0000`  **Access:** see fields below

-5V rail ADC raw count (LM2991 output)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_NEG5` | `[11:0]` | R | `0x0000` | -5V ADC count (measured as absolute, signed in SW) |

---
### `VCC_12V_RAW` — Address `0x0213`

**Reset value:** `0x0000`  **Access:** see fields below

12V input rail ADC raw count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_12V` | `[11:0]` | R | `0x0000` | 12V ADC count (LSB = 12.0V/4096 ≈ 2.93mV) |

---
### `ICC_5V_RAW` — Address `0x0218`

**Reset value:** `0x0000`  **Access:** see fields below

5V rail current sense ADC raw count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ICC_5V` | `[11:0]` | R | `0x0000` | 5V current ADC (scale per sense resistor) |

---
### `ICC_3V3_RAW` — Address `0x0219`

**Reset value:** `0x0000`  **Access:** see fields below

3.3V rail current sense ADC raw count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ICC_3V3` | `[11:0]` | R | `0x0000` | 3.3V current ADC (scale per sense resistor) |

---
### `TEMP_LOCAL` — Address `0x0300`

**Reset value:** `0x0190`  **Access:** see fields below

Local FPGA die temperature in 0.25°C units (signed)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DIE_TEMP` | `[9:0]` | R | `0x0190` | FPGA temperature (0x0190 = 100°C, signed 10-bit) |

---
### `TEMP_REMOTE1` — Address `0x0301`

**Reset value:** `0x0000`  **Access:** see fields below

Remote sensor 1 temperature (AD7416 on RF board)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `REMOTE1_TEMP` | `[9:0]` | R | `0x0000` | Remote temperature sensor 1 (signed 10-bit) |

---
### `TEMP_REMOTE2` — Address `0x0302`

**Reset value:** `0x0000`  **Access:** see fields below

Remote sensor 2 temperature (optional external)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `REMOTE2_TEMP` | `[9:0]` | R | `0x0000` | Remote temperature sensor 2 (signed 10-bit) |

---
### `TEMP_ALERT_HIGH` — Address `0x0308`

**Reset value:** `0x003C`  **Access:** see fields below

Over-temperature alert threshold (0x003C = 60°C)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ALERT_HI` | `[9:0]` | RW | `0x003C` | High temp threshold in 0.25°C units (60°C default) |

---
### `TEMP_ALERT_LOW` — Address `0x0309`

**Reset value:** `0xFF9C`  **Access:** see fields below

Under-temperature alert threshold (0xFF9C = -25°C)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ALERT_LO` | `[9:0]` | RW | `0xFF9C` | Low temp threshold in 0.25°C units (-25°C default) |

---
### `HEALTH_STATUS` — Address `0x030F`

**Reset value:** `0x00`  **Access:** see fields below

System health status flags

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_OK` | `[0]` | R | `0x0` | Temperature within limits (1=OK) |
| `VOLT_OK` | `[1]` | R | `0x0` | All voltages within limits (1=OK) |
| `PLL_LOCK` | `[2]` | R | `0x0` | PLL lock detected (1=locked) |
| `SYSTEM_OK` | `[7]` | R | `0x0` | Overall system OK (all checks passed) |

---
### `PLL_CTRL` — Address `0x0400`

**Reset value:** `0x00`  **Access:** see fields below

PLL control for ADF5356 LO synthesizer

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0x0` | PLL enable (1=enabled) |
| `RESET_N` | `[1]` | RW | `0x0` | PLL reset (0=reset, 1=normal) |
| `REF_SEL` | `[3:2]` | RW | `0x0` | Reference clock select (0=10MHz, 1=100MHz, 2=external) |

---
### `PLL_STATUS` — Address `0x0401`

**Reset value:** `0x00`  **Access:** see fields below

PLL lock status from ADF5356

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LOCKED` | `[0]` | R | `0x0` | PLL locked (1=locked) |
| `LOSS_OF_LOCK` | `[1]` | RC | `0x0` | Loss of lock detected (clears on read) |

---
### `PLL_N_DIV` — Address `0x0402`

**Reset value:** `0x0078`  **Access:** see fields below

PLL N divider (0x0078 = 120 decimal for ADF5356)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `N_DIVIDER` | `[15:0]` | RW | `0x0078` | N divider value (16-bit) |

---
### `PLL_R_DIV` — Address `0x0403`

**Reset value:** `0x0001`  **Access:** see fields below

PLL R divider (reference divider)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `R_DIVIDER` | `[7:0]` | RW | `0x0001` | R divider value (8-bit) |

---
### `CLK_ENABLE` — Address `0x0410`

**Reset value:** `0x0F`  **Access:** see fields below

Clock output enables for system

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `CLK_LO_EN` | `[0]` | RW | `0x1` | LO synthesizer clock enable |
| `CLK_ADC_EN` | `[1]` | RW | `0x1` | ADC sampling clock enable |
| `CLK_IF_EN` | `[2]` | RW | `0x1` | IF processing clock enable |
| `CLK_DSP_EN` | `[3]` | RW | `0x1` | DSP clock enable |
| `CLK_EXT_EN` | `[7]` | RW | `0x0` | External clock output enable |

---
### `EEPROM_CTRL` — Address `0x0500`

**Reset value:** `0x00`  **Access:** see fields below

AT25M01 1Mb SPI EEPROM control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READ` | `[0]` | RW | `0x0` | Start read operation (1=start) |
| `WRITE` | `[1]` | RW | `0x0` | Start write operation (1=start) |
| `ERASE` | `[2]` | RW | `0x0` | Start erase operation (1=start) |
| `BUSY` | `[7]` | R | `0x0` | EEPROM busy flag (1=busy) |

---
### `EEPROM_ADDR` — Address `0x0501`

**Reset value:** `0x0000`  **Access:** see fields below

EEPROM byte address (17-bit address, 128KB)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADDR_BYTE` | `[16:0]` | RW | `0x0000` | Byte address within EEPROM (0-131071) |

---
### `EEPROM_DATA` — Address `0x0502`

**Reset value:** `0x0000`  **Access:** see fields below

EEPROM read/write data (16-bit word)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA_WORD` | `[15:0]` | RW | `0x0000` | Data word (2 bytes) |

---
### `FLASH_CTRL` — Address `0x0600`

**Reset value:** `0x00`  **Access:** see fields below

Configuration flash control interface

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READ` | `[0]` | RW | `0x0` | Start read operation |
| `WRITE` | `[1]` | RW | `0x0` | Start write operation |
| `ERASE_SECTOR` | `[2]` | RW | `0x0` | Erase sector (requires unlock) |
| `ERASE_CHIP` | `[3]` | RW | `0x0` | Erase entire chip (requires unlock) |
| `BUSY` | `[7]` | R | `0x0` | Flash busy flag |

---
### `FLASH_ADDR_LOW` — Address `0x0601`

**Reset value:** `0x0000`  **Access:** see fields below

Flash address lower 16 bits

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADDR_LOW` | `[15:0]` | RW | `0x0000` | Address bits [15:0] |

---
### `FLASH_ADDR_HIGH` — Address `0x0602`

**Reset value:** `0x0000`  **Access:** see fields below

Flash address upper 8 bits

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADDR_HIGH` | `[7:0]` | RW | `0x00` | Address bits [23:16] |

---
### `FLASH_DATA` — Address `0x0603`

**Reset value:** `0x0000`  **Access:** see fields below

Flash data FIFO (16-bit)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA_FIFO` | `[15:0]` | RW | `0x0000` | Data word for read/write |

---
### `FLASH_STATUS` — Address `0x0604`

**Reset value:** `0x01`  **Access:** see fields below

Flash operation status

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READY` | `[0]` | R | `0x1` | Flash ready (1=ready) |
| `WRITE_ERR` | `[1]` | RC | `0x0` | Write error (clears on read) |
| `ERASE_ERR` | `[2]` | RC | `0x0` | Erase error (clears on read) |

---
### `RF_LO_FREQ_HIGH` — Address `0x0700`

**Reset value:** `0x0C1C`  **Access:** see fields below

LO frequency high word - ADF5356 integer divider (default 8 GHz)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `FREQ_HIGH` | `[15:0]` | RW | `0x0C1C` | Integer divider for LO frequency (MSW) |

---
### `RF_LO_FREQ_LOW` — Address `0x0701`

**Reset value:** `0x0000`  **Access:** see fields below

LO frequency low word - fractional divider

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `FREQ_LOW` | `[15:0]` | RW | `0x0000` | Fractional divider for LO frequency (LSW) |

---
### `RF_LO_CTRL` — Address `0x0702`

**Reset value:** `0x00`  **Access:** see fields below

LO synthesizer control (ADF5356 SPI interface)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LOAD_FREQ` | `[0]` | RW | `0x0` | Load frequency registers to ADF5356 (1=trigger) |
| `MUXOUT_SEL` | `[3:1]` | RW | `0x0` | MUXOUT select (0=TRI-STATE, 1=DVdd, 2=DGND, 3=R_DIV_OUT, 4=N_DIV_OUT, 7=LD) |

---
### `RF_LO_PHASE` — Address `0x0703`

**Reset value:** `0x0000`  **Access:** see fields below

LO phase adjust word (ADF5356 phase adjust)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `PHASE_ADJ` | `[15:0]` | RW | `0x0000` | Phase adjustment value |

---
### `VGA_GAIN_CTRL` — Address `0x0708`

**Reset value:** `0x20`  **Access:** see fields below

HMC698LP4 VGA gain control (6-bit, 31.5dB range)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GAIN_CODE` | `[5:0]` | RW | `0x20` | 6-bit gain code (0x20 = mid-scale, 0-63 mapped to -31.5 to +0dB) |

---
### `RF_PATH_CTRL` — Address `0x0709`

**Reset value:** `0x01`  **Access:** see fields below

RF path control - LNA enable, mixer bias

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LNA_ENABLE` | `[0]` | RW | `0x1` | LNA enable (1=enabled) |
| `MIXER_ENABLE` | `[1]` | RW | `0x1` | Mixer enable (1=enabled) |
| `VGA_ENABLE` | `[2]` | RW | `0x1` | VGA enable (1=enabled) |
| `IF_AMP_ENABLE` | `[3]` | RW | `0x1` | IF amplifier enable |

---
### `RF_STATUS` — Address `0x070A`

**Reset value:** `0x00`  **Access:** see fields below

RF chain status flags

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `RF_PRESENT` | `[0]` | R | `0x0` | RF input detected (1=present) |
| `LOCKED` | `[1]` | R | `0x0` | LO locked (same as PLL_STATUS[0]) |

---
### `GPIO_DIR` — Address `0x0800`

**Reset value:** `0x00`  **Access:** see fields below

GPIO direction control (0=input, 1=output)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GPIO7_0` | `[7:0]` | RW | `0x00` | GPIO[7:0] direction |

---
### `GPIO_DATA` — Address `0x0801`

**Reset value:** `0x00`  **Access:** see fields below

GPIO data read/write

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GPIO7_0` | `[7:0]` | RW | `0x00` | GPIO[7:0] data value |

---
### `LED_CTRL` — Address `0x0802`

**Reset value:** `0x0F`  **Access:** see fields below

LED control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LED_PWR` | `[0]` | RW | `0x1` | Power LED (green, 1=on) |
| `LED_STATUS` | `[1]` | RW | `0x1` | Status LED (yellow, 1=on) |
| `LED_ERROR` | `[2]` | RW | `0x1` | Error LED (red, 1=on) |
| `LED_RF` | `[3]` | RW | `0x1` | RF lock LED (green, 1=on) |

---
### `DAC_CTRL` — Address `0x0900`

**Reset value:** `0x00`  **Access:** see fields below

DAC control (optional DAC for calibration)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DAC_ENABLE` | `[0]` | RW | `0x0` | DAC enable (1=enabled) |
| `DAC_CH_SEL` | `[3:1]` | RW | `0x0` | DAC channel select (0-7) |

---
### `DAC_DATA` — Address `0x0901`

**Reset value:** `0x8000`  **Access:** see fields below

DAC data output (12-16 bit)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DAC_VALUE` | `[15:0]` | RW | `0x8000` | DAC output value (mid-scale default) |
