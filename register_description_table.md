# Register Description Table (RDT)
## j,fj

> **Total registers:** 59

j,fj Wideband RF Receiver Module - Complete FPGA register map and initialization sequence for XCZU9EG-based RF receiver with ADF5356 LO synthesizer, HMC699LP4 VGA, ADC12DJ3200 ADC, LVDS data interface, and power monitoring

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
| `0x0000` | `BOARD_ID` | — | `0x4A46` | Board identification code - ASCII 'JF' for j,fj project |
| `0x0001` | `BOARD_VERSION` | — | `0x10` | Hardware version number |
| `0x0002` | `BOARD_TYPE_ID` | — | `0x5252` | Board type identifier - RF Receiver Module |
| `0x0003` | `SCRATCHPAD` | — | `0x0000` | General-purpose read/write test register for RAM verification |
| `0x0010` | `MCS_VERSION_MAJOR` | — | `0x01` | FPGA firmware major version number |
| `0x0011` | `MCS_VERSION_MINOR` | — | `0x00` | FPGA firmware minor version number |
| `0x0012` | `BUILD_DATE` | — | `0x20260416` | Firmware build date in packed BCD format (YYYYMMDD) |
| `0x0100` | `UART_BAUD_DIV` | — | `0x0022` | UART baud rate divisor (115200 bps default assuming 16x oversampling) |
| `0x0101` | `UART_CTRL` | — | `0x00` | UART control register |
| `0x0102` | `UART_STATUS` | — | `0x00` | UART status flags (read-clear) |
| `0x0103` | `UART_TX_COUNT` | — | `0x00` | TX FIFO byte count |
| `0x0104` | `UART_RX_COUNT` | — | `0x00` | RX FIFO byte count |
| `0x0110` | `ETH_MAC_LOW` | — | `0x0000` | Ethernet MAC address lower 16 bits (stored in EEPROM) |
| `0x0111` | `ETH_MAC_HIGH` | — | `0x0000` | Ethernet MAC address upper 16 bits (stored in EEPROM) |
| `0x0200` | `ADC_CTRL` | — | `0x00` | ADC12DJ3200 ADC control register |
| `0x0201` | `ADC_STATUS` | — | `0x00` | ADC status flags |
| `0x0210` | `VCC_5V_RAW` | — | `0x0000` | 5V rail ADC raw count (12-bit) |
| `0x0211` | `VCC_3V3_RAW` | — | `0x0000` | 3.3V rail ADC raw count (LTC7138 buck output) |
| `0x0212` | `VCC_2V5_RAW` | — | `0x0000` | 2.5V rail ADC raw count (not used - reserved) |
| `0x0213` | `VCC_1V8_RAW` | — | `0x0000` | 1.8V rail ADC raw count (TPS7A4700 LDO output) |
| `0x0214` | `VCC_1V0_RAW` | — | `0x0000` | 1.0V rail ADC raw count (TPS7A4700 LDO for ADC core) |
| `0x0218` | `ICC_5V_RAW` | — | `0x0000` | 5V rail current monitor ADC count |
| `0x0219` | `ICC_3V3_RAW` | — | `0x0000` | 3.3V rail current monitor ADC count |
| `0x0300` | `TEMP_LOCAL` | — | `0x190` | Local FPGA die temperature (0.25°C units, signed) |
| `0x0301` | `TEMP_REMOTE1` | — | `0x0C8` | Remote sensor 1 - RF front-end temperature |
| `0x0302` | `TEMP_REMOTE2` | — | `0x0C8` | Remote sensor 2 - ADC temperature |
| `0x0308` | `TEMP_ALERT_HIGH` | — | `0x0190` | Over-temperature alert threshold (0.25°C units) |
| `0x0309` | `TEMP_ALERT_LOW` | — | `0xFF9C` | Under-temperature alert threshold (0.25°C units, signed) |
| `0x030F` | `HEALTH_STATUS` | — | `0x80` | System health status flags |
| `0x0400` | `PLL_CTRL` | — | `0x00` | System PLL control (derived from ADF5356 LO) |
| `0x0401` | `PLL_STATUS` | — | `0x00` | PLL/LO status flags |
| `0x0402` | `PLL_N_DIV` | — | `0x0040` | PLL N divider value (ADF5356 INT register mapping) |
| `0x0403` | `PLL_R_DIV` | — | `0x01` | PLL R divider (reference divider) |
| `0x0410` | `CLK_ENABLE` | — | `0x00` | Clock output enable masks |
| `0x0500` | `EEPROM_CTRL` | — | `0x00` | AT24CS02 EEPROM control register |
| `0x0501` | `EEPROM_ADDR` | — | `0x0000` | EEPROM byte address (0x0000-0x007F for 256-byte AT24CS02) |
| `0x0502` | `EEPROM_DATA` | — | `0x0000` | EEPROM read/write data register |
| `0x0600` | `FLASH_CTRL` | — | `0x00` | Configuration Flash control register |
| `0x0601` | `FLASH_ADDR_LOW` | — | `0x0000` | Flash address lower 16 bits |
| `0x0602` | `FLASH_ADDR_HIGH` | — | `0x0000` | Flash address upper 8 bits |
| `0x0603` | `FLASH_DATA` | — | `0x0000` | Flash read/write data FIFO |
| `0x0604` | `FLASH_STATUS` | — | `0x01` | Flash operation status |
| `0x0700` | `RF_LO_FREQ_HIGH` | — | `0x1388` | ADF5356 LO frequency high 16 bits (MHz units) |
| `0x0701` | `RF_LO_FREQ_LOW` | — | `0x0000` | ADF5356 LO frequency low 16 bits (100kHz units) |
| `0x0702` | `RF_LO_CTRL` | — | `0x00` | ADF5356 LO synthesizer control |
| `0x0703` | `RF_LO_STATUS` | — | `0x00` | LO synthesizer status |
| `0x0708` | `RF_VGA_GAIN` | — | `0x0F` | HMC699LP4 VGA gain control (digital) |
| `0x0709` | `RF_LNA_ENABLE` | — | `0x00` | HMC1113LP3DE LNA enable control |
| `0x070A` | `RF_MIXER_ENABLE` | — | `0x00` | HMC1056LP4BE Mixer enable |
| `0x0710` | `ADC_IF_GAIN` | — | `0x00` | ADC input IF gain control |
| `0x0800` | `GPIO_OUTPUT` | — | `0x00` | GPIO output data register |
| `0x0801` | `GPIO_DIR` | — | `0xFFFF` | GPIO direction control (1=output, 0=input) |
| `0x0802` | `GPIO_INPUT` | — | `0x00` | GPIO input data register (read-only) |
| `0x0803` | `GPIO_INT_EN` | — | `0x00` | GPIO interrupt enable |
| `0x0900` | `DAC_CTRL` | — | `0x00` | General DAC control (for analog trim) |
| `0x0901` | `DAC_DATA` | — | `0x8000` | DAC output value (16-bit) |
| `0x0A00` | `LVDS_CTRL` | — | `0x00` | LVDS output interface control (SN65LVDS16) |
| `0x0A01` | `LVDS_STATUS` | — | `0x00` | LVDS link status |
| `0x0A02` | `LVDS_RATE` | — | `0x0190` | LVDS data rate divisor |

---
### `BOARD_ID` — Address `0x0000`

**Reset value:** `0x4A46`  **Access:** see fields below

Board identification code - ASCII 'JF' for j,fj project

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BOARD_ID` | `[15:0]` | R | `0x4A46` | Unique board identifier (0x4A46 = 'JF') |

---
### `BOARD_VERSION` — Address `0x0001`

**Reset value:** `0x10`  **Access:** see fields below

Hardware version number

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAJOR_VERSION` | `[7:4]` | R | `0x1` | Major hardware version |
| `MINOR_VERSION` | `[3:0]` | R | `0x0` | Minor hardware version |

---
### `BOARD_TYPE_ID` — Address `0x0002`

**Reset value:** `0x5252`  **Access:** see fields below

Board type identifier - RF Receiver Module

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BOARD_TYPE` | `[15:0]` | R | `0x5252` | Board type code (0x5252 = 'RR' = RF Receiver) |

---
### `SCRATCHPAD` — Address `0x0003`

**Reset value:** `0x0000`  **Access:** see fields below

General-purpose read/write test register for RAM verification

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEST_DATA` | `[15:0]` | RW | `0x0000` | Read/write test pattern |

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

**Reset value:** `0x20260416`  **Access:** see fields below

Firmware build date in packed BCD format (YYYYMMDD)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BUILD_BCD` | `[31:0]` | R | `0x20260416` | Build date: 2026-04-16 |

---
### `UART_BAUD_DIV` — Address `0x0100`

**Reset value:** `0x0022`  **Access:** see fields below

UART baud rate divisor (115200 bps default assuming 16x oversampling)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BAUD_DIV` | `[15:0]` | RW | `0x0022` | Baud rate divisor = f_clk / (16 * baud_rate) |

---
### `UART_CTRL` — Address `0x0101`

**Reset value:** `0x00`  **Access:** see fields below

UART control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0` | UART enable: 1=enabled, 0=disabled |
| `LOOPBACK` | `[1]` | RW | `0` | Internal loopback mode |
| `PARITY_EN` | `[2]` | RW | `0` | Parity enable |
| `FRAME_FORMAT` | `[7:4]` | RW | `0x0` | Frame format: 0x0=8N1, 0x1=8E1, 0x2=8O1 |

---
### `UART_STATUS` — Address `0x0102`

**Reset value:** `0x00`  **Access:** see fields below

UART status flags (read-clear)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TX_BUSY` | `[0]` | R | `0` | TX FIFO busy transmitting |
| `RX_AVAIL` | `[1]` | R | `0` | Data available in RX FIFO |
| `FRAME_ERR` | `[2]` | RC | `0` | Frame error detected (read clears) |
| `PARITY_ERR` | `[3]` | RC | `0` | Parity error detected (read clears) |

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

Ethernet MAC address lower 16 bits (stored in EEPROM)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAC_ADDR_15_0` | `[15:0]` | R | `0x0000` | MAC address bits [15:0] |

---
### `ETH_MAC_HIGH` — Address `0x0111`

**Reset value:** `0x0000`  **Access:** see fields below

Ethernet MAC address upper 16 bits (stored in EEPROM)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAC_ADDR_31_16` | `[15:0]` | R | `0x0000` | MAC address bits [31:16] |

---
### `ADC_CTRL` — Address `0x0200`

**Reset value:** `0x00`  **Access:** see fields below

ADC12DJ3200 ADC control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `START_CONV` | `[0]` | RW | `0` | Start ADC conversion: 1=start |
| `CONTINUOUS` | `[1]` | RW | `0` | Continuous mode: 1=continuous, 0=single-shot |
| `CHANNEL_SEL` | `[3:2]` | RW | `0x0` | Channel select: 0=CH_A, 1=CH_B, 2=dual |
| `DECIMATION` | `[6:4]` | RW | `0x0` | Decimation factor: 0=bypass, 1=2x, 2=4x, 3=8x |

---
### `ADC_STATUS` — Address `0x0201`

**Reset value:** `0x00`  **Access:** see fields below

ADC status flags

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA_READY` | `[0]` | R | `0` | New ADC data available |
| `OVERRANGE` | `[1]` | RC | `0` | ADC input overrange detected (read clears) |
| `CALIB_DONE` | `[2]` | R | `0` | Internal calibration complete |
| `PLL_LOCKED` | `[3]` | R | `0` | ADC clock PLL locked |

---
### `VCC_5V_RAW` — Address `0x0210`

**Reset value:** `0x0000`  **Access:** see fields below

5V rail ADC raw count (12-bit)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_5V` | `[11:0]` | R | `0x000` | 5V rail ADC count (V = count * 5.0 / 4096) |

---
### `VCC_3V3_RAW` — Address `0x0211`

**Reset value:** `0x0000`  **Access:** see fields below

3.3V rail ADC raw count (LTC7138 buck output)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_3V3` | `[11:0]` | R | `0x000` | 3.3V rail ADC count (V = count * 3.3 / 4096) |

---
### `VCC_2V5_RAW` — Address `0x0212`

**Reset value:** `0x0000`  **Access:** see fields below

2.5V rail ADC raw count (not used - reserved)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_2V5` | `[11:0]` | R | `0x000` | Reserved for future 2.5V rail |

---
### `VCC_1V8_RAW` — Address `0x0213`

**Reset value:** `0x0000`  **Access:** see fields below

1.8V rail ADC raw count (TPS7A4700 LDO output)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_1V8` | `[11:0]` | R | `0x000` | 1.8V rail ADC count (V = count * 1.8 / 4096) |

---
### `VCC_1V0_RAW` — Address `0x0214`

**Reset value:** `0x0000`  **Access:** see fields below

1.0V rail ADC raw count (TPS7A4700 LDO for ADC core)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_1V0` | `[11:0]` | R | `0x000` | 1.0V rail ADC count (V = count * 1.0 / 4096) |

---
### `ICC_5V_RAW` — Address `0x0218`

**Reset value:** `0x0000`  **Access:** see fields below

5V rail current monitor ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_I5V` | `[11:0]` | R | `0x000` | 5V current sense ADC count |

---
### `ICC_3V3_RAW` — Address `0x0219`

**Reset value:** `0x0000`  **Access:** see fields below

3.3V rail current monitor ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_I3V3` | `[11:0]` | R | `0x000` | 3.3V current sense ADC count |

---
### `TEMP_LOCAL` — Address `0x0300`

**Reset value:** `0x190`  **Access:** see fields below

Local FPGA die temperature (0.25°C units, signed)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DIE_TEMP` | `[9:0]` | R | `0x190` | FPGA die temperature (0x190 = 100°C = safe default) |
| `SIGN_BIT` | `[9]` | R | `0` | Temperature sign (1=negative) |

---
### `TEMP_REMOTE1` — Address `0x0301`

**Reset value:** `0x0C8`  **Access:** see fields below

Remote sensor 1 - RF front-end temperature

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `RF_TEMP` | `[9:0]` | R | `0x0C8` | RF front-end temperature (0x0C8 = 50°C ambient) |

---
### `TEMP_REMOTE2` — Address `0x0302`

**Reset value:** `0x0C8`  **Access:** see fields below

Remote sensor 2 - ADC temperature

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_TEMP` | `[9:0]` | R | `0x0C8` | ADC die temperature |

---
### `TEMP_ALERT_HIGH` — Address `0x0308`

**Reset value:** `0x0190`  **Access:** see fields below

Over-temperature alert threshold (0.25°C units)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `OT_THRESHOLD` | `[9:0]` | RW | `0x0190` | Over-temperature threshold (0x0190 = 100°C) |

---
### `TEMP_ALERT_LOW` — Address `0x0309`

**Reset value:** `0xFF9C`  **Access:** see fields below

Under-temperature alert threshold (0.25°C units, signed)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `UT_THRESHOLD` | `[9:0]` | RW | `0xFF9C` | Under-temperature threshold (0xFF9C = -25°C) |

---
### `HEALTH_STATUS` — Address `0x030F`

**Reset value:** `0x80`  **Access:** see fields below

System health status flags

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_OK` | `[0]` | R | `1` | Temperature within limits: 1=OK, 0=ALERT |
| `VOLT_OK` | `[1]` | R | `0` | Power rails within limits: 1=OK, 0=BAD |
| `PLL_LOCK` | `[2]` | R | `0` | System PLL locked: 1=LOCKED, 0=UNLOCKED |
| `ADC_CAL_OK` | `[3]` | R | `0` | ADC calibrated: 1=DONE, 0=PENDING |
| `SYSTEM_OK` | `[7]` | R | `0` | Overall system health: 1=ALL GOOD, 0=FAULT |

---
### `PLL_CTRL` — Address `0x0400`

**Reset value:** `0x00`  **Access:** see fields below

System PLL control (derived from ADF5356 LO)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0` | PLL enable: 1=enabled, 0=disabled |
| `RESET` | `[1]` | RW | `0` | PLL reset: 1=assert reset |
| `REF_SEL` | `[3:2]` | RW | `0x0` | Reference clock select: 0=internal, 1=external, 2=LO_out |
| `LOCK_MODE` | `[5:4]` | RW | `0x0` | Lock mode: 0=normal, 1=fast lock, 2=low noise |

---
### `PLL_STATUS` — Address `0x0401`

**Reset value:** `0x00`  **Access:** see fields below

PLL/LO status flags

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LOCKED` | `[0]` | R | `0` | PLL/LO locked: 1=LOCKED, 0=UNLOCKED |
| `LOSS_OF_LOCK` | `[1]` | RC | `0` | Loss of lock detected (read clears) |
| `REF_VALID` | `[2]` | R | `0` | Reference clock valid: 1=OK, 0=BAD |

---
### `PLL_N_DIV` — Address `0x0402`

**Reset value:** `0x0040`  **Access:** see fields below

PLL N divider value (ADF5356 INT register mapping)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `N_DIVIDER` | `[15:0]` | RW | `0x0040` | N divider value (default = 64 for mid-band LO) |

---
### `PLL_R_DIV` — Address `0x0403`

**Reset value:** `0x01`  **Access:** see fields below

PLL R divider (reference divider)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `R_DIVIDER` | `[7:0]` | RW | `0x01` | R divider value (default = 1) |

---
### `CLK_ENABLE` — Address `0x0410`

**Reset value:** `0x00`  **Access:** see fields below

Clock output enable masks

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `CLK_ADC_EN` | `[0]` | RW | `0` | ADC sample clock enable |
| `CLK_FPGA_EN` | `[1]` | RW | `0` | FPGA system clock enable |
| `CLK_LOREF_EN` | `[2]` | RW | `0` | LO reference clock enable |
| `CLK_LVDS_EN` | `[3]` | RW | `0` | LVDS output clock enable |

---
### `EEPROM_CTRL` — Address `0x0500`

**Reset value:** `0x00`  **Access:** see fields below

AT24CS02 EEPROM control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READ` | `[0]` | RW | `0` | Start read: 1=read from EEPROM_ADDR |
| `WRITE` | `[1]` | RW | `0` | Start write: 1=write EEPROM_DATA to EEPROM_ADDR |
| `ERASE` | `[2]` | RW | `0` | Erase page: 1=erase page at EEPROM_ADDR |
| `BUSY` | `[7]` | R | `0` | EEPROM operation in progress: 1=BUSY, 0=READY |

---
### `EEPROM_ADDR` — Address `0x0501`

**Reset value:** `0x0000`  **Access:** see fields below

EEPROM byte address (0x0000-0x007F for 256-byte AT24CS02)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BYTE_ADDR` | `[15:0]` | RW | `0x0000` | EEPROM byte address (lower 8 bits used) |

---
### `EEPROM_DATA` — Address `0x0502`

**Reset value:** `0x0000`  **Access:** see fields below

EEPROM read/write data register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA_16BIT` | `[15:0]` | RW | `0x0000` | 16-bit data (lower 8 bits written to EEPROM) |

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
| `BUSY` | `[7]` | R | `0` | Flash operation in progress: 1=BUSY, 0=READY |

---
### `FLASH_ADDR_LOW` — Address `0x0601`

**Reset value:** `0x0000`  **Access:** see fields below

Flash address lower 16 bits

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADDR_15_0` | `[15:0]` | RW | `0x0000` | Flash address bits [15:0] |

---
### `FLASH_ADDR_HIGH` — Address `0x0602`

**Reset value:** `0x0000`  **Access:** see fields below

Flash address upper 8 bits

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADDR_23_16` | `[7:0]` | RW | `0x00` | Flash address bits [23:16] |

---
### `FLASH_DATA` — Address `0x0603`

**Reset value:** `0x0000`  **Access:** see fields below

Flash read/write data FIFO

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA_FIFO` | `[15:0]` | RW | `0x0000` | 16-bit flash data word |

---
### `FLASH_STATUS` — Address `0x0604`

**Reset value:** `0x01`  **Access:** see fields below

Flash operation status

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READY` | `[0]` | R | `1` | Flash ready: 1=READY, 0=BUSY |
| `WRITE_ERR` | `[1]` | RC | `0` | Write error (read clears) |
| `ERASE_ERR` | `[2]` | RC | `0` | Erase error (read clears) |

---
### `RF_LO_FREQ_HIGH` — Address `0x0700`

**Reset value:** `0x1388`  **Access:** see fields below

ADF5356 LO frequency high 16 bits (MHz units)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `FREQ_MHZ_MSB` | `[15:0]` | RW | `0x1388` | LO frequency MSW (default 5000 MHz = 5 GHz) |

---
### `RF_LO_FREQ_LOW` — Address `0x0701`

**Reset value:** `0x0000`  **Access:** see fields below

ADF5356 LO frequency low 16 bits (100kHz units)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `FREQ_100KHZ_LSB` | `[15:0]` | RW | `0x0000` | LO frequency LSW in 100kHz units |

---
### `RF_LO_CTRL` — Address `0x0702`

**Reset value:** `0x00`  **Access:** see fields below

ADF5356 LO synthesizer control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LO_ENABLE` | `[0]` | RW | `0` | LO output enable: 1=ON, 0=OFF |
| `MUXOUT_SEL` | `[3:1]` | RW | `0x0` | MUXOUT select: 0=tristate, 1=lock detect, 2=NDIV, 3=RDIV |
| `LD_PIN_MODE` | `[5:4]` | RW | `0x0` | Lock detect pin mode |

---
### `RF_LO_STATUS` — Address `0x0703`

**Reset value:** `0x00`  **Access:** see fields below

LO synthesizer status

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LD` | `[0]` | R | `0` | Lock detect: 1=LOCKED, 0=UNLOCKED |
| `MUXOUT` | `[4:1]` | R | `0x0` | MUXOUT sampled value |

---
### `RF_VGA_GAIN` — Address `0x0708`

**Reset value:** `0x0F`  **Access:** see fields below

HMC699LP4 VGA gain control (digital)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GAIN_CODE` | `[7:0]` | RW | `0x0F` | VGA gain code (0x00=-11dB, 0x3F=+19dB, default mid-range) |

---
### `RF_LNA_ENABLE` — Address `0x0709`

**Reset value:** `0x00`  **Access:** see fields below

HMC1113LP3DE LNA enable control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LNA_EN` | `[0]` | RW | `0` | LNA enable: 1=ON, 0=OFF (power save) |
| `LNA_BIAS_TRIM` | `[5:1]` | RW | `0x10` | LNA gate bias trim |

---
### `RF_MIXER_ENABLE` — Address `0x070A`

**Reset value:** `0x00`  **Access:** see fields below

HMC1056LP4BE Mixer enable

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MIXER_EN` | `[0]` | RW | `0` | Mixer enable: 1=ON, 0=OFF |
| `IF_FILTER_EN` | `[1]` | RW | `1` | IF filter enable: 1=enabled |

---
### `ADC_IF_GAIN` — Address `0x0710`

**Reset value:** `0x00`  **Access:** see fields below

ADC input IF gain control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `IF_GAIN` | `[3:0]` | RW | `0x0` | IF gain trim: 0x0=0dB, 0xF=+15dB |

---
### `GPIO_OUTPUT` — Address `0x0800`

**Reset value:** `0x00`  **Access:** see fields below

GPIO output data register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GPIO_OUT` | `[15:0]` | RW | `0x00` | GPIO output states (bit 0 = LED, bit 1 = RF_EN, etc.) |

---
### `GPIO_DIR` — Address `0x0801`

**Reset value:** `0xFFFF`  **Access:** see fields below

GPIO direction control (1=output, 0=input)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GPIO_DIR_BITS` | `[15:0]` | RW | `0xFFFF` | GPIO direction: 1=output, 0=input (default all outputs) |

---
### `GPIO_INPUT` — Address `0x0802`

**Reset value:** `0x00`  **Access:** see fields below

GPIO input data register (read-only)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GPIO_IN` | `[15:0]` | R | `0x00` | GPIO input states |

---
### `GPIO_INT_EN` — Address `0x0803`

**Reset value:** `0x00`  **Access:** see fields below

GPIO interrupt enable

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `INT_EN` | `[15:0]` | RW | `0x00` | GPIO interrupt enable per pin |

---
### `DAC_CTRL` — Address `0x0900`

**Reset value:** `0x00`  **Access:** see fields below

General DAC control (for analog trim)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DAC_EN` | `[0]` | RW | `0` | DAC enable: 1=enabled |
| `DAC_CHANNEL` | `[3:1]` | RW | `0x0` | DAC channel select |

---
### `DAC_DATA` — Address `0x0901`

**Reset value:** `0x8000`  **Access:** see fields below

DAC output value (16-bit)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DAC_VALUE` | `[15:0]` | RW | `0x8000` | DAC output code (0x8000 = midscale) |

---
### `LVDS_CTRL` — Address `0x0A00`

**Reset value:** `0x00`  **Access:** see fields below

LVDS output interface control (SN65LVDS16)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LVDS_EN` | `[0]` | RW | `0` | LVDS driver enable: 1=enabled |
| `TERMINATION` | `[1]` | RW | `1` | Internal termination: 1=100 ohm, 0=off |
| `DRIVE_STRENGTH` | `[3:2]` | RW | `0x2` | Drive strength: 0=low, 1=med, 2=high, 3=max |

---
### `LVDS_STATUS` — Address `0x0A01`

**Reset value:** `0x00`  **Access:** see fields below

LVDS link status

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LINK_UP` | `[0]` | R | `0` | LVDS link up: 1=connected |
| `FIFO_OVERFLOW` | `[1]` | RC | `0` | Data FIFO overflow (read clears) |
| `FIFO_UNDERFLOW` | `[2]` | RC | `0` | Data FIFO underflow (read clears) |

---
### `LVDS_RATE` — Address `0x0A02`

**Reset value:** `0x0190`  **Access:** see fields below

LVDS data rate divisor

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `RATE_DIV` | `[15:0]` | RW | `0x0190` | Data rate divisor (default 400 = 400 MHz DDR = 800 Mbps) |
