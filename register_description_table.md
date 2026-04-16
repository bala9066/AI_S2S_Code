# Register Description Table (RDT)
## ehg

> **Total registers:** 41

**ehg Wideband RF Receiver - MCU Glue Logic Register Map**

This register map abstracts the STM32F407VGT6 microcontroller's peripheral interfaces for controlling the RF front-end chain. The design features:

- **RF Chain Control:** HMC8141 LNA enable, HMC698LP4 VGA gain control (30dB range, 5-bit SPI), HMC-CMS19 mixer enable, HMC5805 IF amplifier control
- **High-Speed ADC Interface:** EV10AQ190A (5 GSps, 10-bit) configuration via 3-wire serial, mode control, and status monitoring
- **Clock Management:** Si5345B-D quad clock generator control via I2C, ADCLK914 buffer enable
- **Power Management:** +28V DC-DC converter (PKM4716TCD15) enable, +5V and +3.3V rail monitoring via ADC channels
- **Non-Volatile Storage:** M24M02-DR 2Mbit EEPROM for calibration data storage
- **Communication:** UART host interface at configurable baud rates for register access
- **Temperature Monitoring:** Internal MCU temperature sensor and external thermal monitoring
- **Status Indication:** LED_STATUS heartbeat and fault indication

Total: 38 registers spanning 10 functional address groups (0x000-0x900).

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
| `0x0000` | `BOARD_ID` | — | `0xE410` | Board identification code - uniquely identifies the EHG Wideband RF Receiver hardware |
| `0x0001` | `BOARD_VERSION` | — | `0x10` | Hardware version number - major and minor revision |
| `0x0002` | `BOARD_TYPE_ID` | — | `0x0001` | Board type identifier - specifies product variant |
| `0x0003` | `SCRATCHPAD` | — | `0x0000` | Read/write test register for RAM and bus integrity verification |
| `0x0010` | `MCS_VERSION_MAJOR` | — | `0x01` | MCU firmware major version number |
| `0x0011` | `MCS_VERSION_MINOR` | — | `0x00` | MCU firmware minor version number |
| `0x0012` | `BUILD_DATE` | — | `0x20260416` | Firmware build date in packed BCD format (YYYYMMDD) |
| `0x0100` | `UART_BAUD_DIV` | — | `0x0016` | UART baud rate divisor for host communication interface |
| `0x0101` | `UART_CTRL` | — | `0x01` | UART control register - enables and configures interface |
| `0x0102` | `UART_STATUS` | — | `0x00` | UART status flags - clears on read |
| `0x0103` | `UART_TX_COUNT` | — | `0x00` | TX FIFO byte count |
| `0x0104` | `UART_RX_COUNT` | — | `0x00` | RX FIFO byte count |
| `0x0200` | `RF_LNA_CTRL` | — | `0x00` | RF LNA (HMC8141) control - enable and power state |
| `0x0201` | `RF_VGA_GAIN` | — | `0x0F` | RF VGA (HMC698LP4) gain control - 30dB range in 1dB steps |
| `0x0202` | `RF_MIXER_CTRL` | — | `0x00` | RF Mixer (HMC-CMS19) enable control |
| `0x0203` | `RF_IF_AMP_CTRL` | — | `0x00` | IF Amplifier (HMC5805) control |
| `0x0300` | `ADC_HS_CTRL` | — | `0x00` | High-speed ADC (EV10AQ190A) control register |
| `0x0301` | `ADC_HS_STATUS` | — | `0x00` | High-speed ADC status flags |
| `0x0302` | `ADC_HS_CONFIG` | — | `0x0110` | High-speed ADC configuration parameters |
| `0x0303` | `ADC_FIFO_LEVEL` | — | `0x00` | ADC data FIFO level monitoring |
| `0x0400` | `TEMP_LOCAL` | — | `0x0000` | Local MCU die temperature (0.25C units, signed) |
| `0x0401` | `TEMP_REMOTE1` | — | `0x0000` | External temperature sensor 1 (RF front-end area) |
| `0x0408` | `TEMP_ALERT_HIGH` | — | `0x0190` | Over-temperature alert threshold |
| `0x0409` | `TEMP_ALERT_LOW` | — | `0xFF9C` | Under-temperature alert threshold |
| `0x0500` | `CLK_GEN_CTRL` | — | `0x00` | Clock generator (Si5345B-D) control via I2C |
| `0x0501` | `CLK_GEN_STATUS` | — | `0x00` | Clock generator status monitoring |
| `0x0502` | `CLK_BUF_ENABLE` | — | `0x0F` | Clock buffer (ADCLK914) output enables |
| `0x0600` | `EEPROM_CTRL` | — | `0x00` | EEPROM (M24M02-DR) control via I2C |
| `0x0601` | `EEPROM_ADDR` | — | `0x0000` | EEPROM byte address (18-bit address space) |
| `0x0602` | `EEPROM_DATA` | — | `0x00` | EEPROM read/write data |
| `0x0700` | `ADC_PSU_CTRL` | — | `0x01` | Power supply monitoring ADC control |
| `0x0701` | `VCC_5V_RAW` | — | `0x0000` | +5V rail ADC count (12-bit) |
| `0x0702` | `VCC_3V3_RAW` | — | `0x0000` | +3.3V rail ADC count (12-bit) |
| `0x0703` | `VCC_15V_RAW` | — | `0x0000` | +15V rail ADC count (12-bit) |
| `0x0708` | `ICC_5V_RAW` | — | `0x0000` | +5V rail current ADC count |
| `0x0709` | `ICC_3V3_RAW` | — | `0x0000` | +3.3V rail current ADC count |
| `0x0710` | `DCDC_ENABLE` | — | `0x01` | DC-DC converter (PKM4716TCD15) enable control |
| `0x0711` | `HEALTH_STATUS` | — | `0x00` | System health summary status |
| `0x0800` | `LED_CTRL` | — | `0x01` | Status LED control |
| `0x0801` | `GPIO_DIR` | — | `0x0000` | GPIO direction control |
| `0x0802` | `GPIO_DATA` | — | `0x0000` | GPIO data read/write |

---
### `BOARD_ID` — Address `0x0000`

**Reset value:** `0xE410`  **Access:** see fields below

Board identification code - uniquely identifies the EHG Wideband RF Receiver hardware

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BOARD_ID` | `[15:0]` | RO | `0xE410` | Unique board identifier (0xE410 = 'EH') |

---
### `BOARD_VERSION` — Address `0x0001`

**Reset value:** `0x10`  **Access:** see fields below

Hardware version number - major and minor revision

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAJOR` | `[7:4]` | RO | `0x1` | Major hardware revision |
| `MINOR` | `[3:0]` | RO | `0x0` | Minor hardware revision |

---
### `BOARD_TYPE_ID` — Address `0x0002`

**Reset value:** `0x0001`  **Access:** see fields below

Board type identifier - specifies product variant

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TYPE` | `[15:0]` | RO | `0x0001` | 0x0001 = Wideband RF Receiver (5-18 GHz) |

---
### `SCRATCHPAD` — Address `0x0003`

**Reset value:** `0x0000`  **Access:** see fields below

Read/write test register for RAM and bus integrity verification

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEST_DATA` | `[15:0]` | RW | `0x0000` | General-purpose test pattern register |

---
### `MCS_VERSION_MAJOR` — Address `0x0010`

**Reset value:** `0x01`  **Access:** see fields below

MCU firmware major version number

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `FIRMWARE_MAJOR` | `[7:0]` | RO | `0x01` | Major firmware version |

---
### `MCS_VERSION_MINOR` — Address `0x0011`

**Reset value:** `0x00`  **Access:** see fields below

MCU firmware minor version number

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `FIRMWARE_MINOR` | `[7:0]` | RO | `0x00` | Minor firmware version |

---
### `BUILD_DATE` — Address `0x0012`

**Reset value:** `0x20260416`  **Access:** see fields below

Firmware build date in packed BCD format (YYYYMMDD)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATE_BCD` | `[31:0]` | RO | `0x20260416` | Build date: 2026-04-16 (BCD encoded) |

---
### `UART_BAUD_DIV` — Address `0x0100`

**Reset value:** `0x0016`  **Access:** see fields below

UART baud rate divisor for host communication interface

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BAUD_DIV` | `[15:0]` | RW | `0x0016` | Baud divisor (default 22 = 115200 baud @ 168MHz PCLK) |

---
### `UART_CTRL` — Address `0x0101`

**Reset value:** `0x01`  **Access:** see fields below

UART control register - enables and configures interface

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0x1` | UART enable (1=enabled) |
| `LOOPBACK` | `[1]` | RW | `0x0` | Loopback mode for test (1=loopback) |
| `FRAME_FORMAT` | `[7:4]` | RW | `0x0` | Frame format (0=8N1 standard) |

---
### `UART_STATUS` — Address `0x0102`

**Reset value:** `0x00`  **Access:** see fields below

UART status flags - clears on read

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TX_BUSY` | `[0]` | RO | `0x0` | Transmitter busy flag |
| `RX_AVAIL` | `[1]` | RO | `0x0` | Data available in RX FIFO |
| `FRAME_ERR` | `[2]` | RC | `0x0` | Frame error detected (read-clear) |

---
### `UART_TX_COUNT` — Address `0x0103`

**Reset value:** `0x00`  **Access:** see fields below

TX FIFO byte count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TX_COUNT` | `[7:0]` | RO | `0x00` | Number of bytes in TX FIFO |

---
### `UART_RX_COUNT` — Address `0x0104`

**Reset value:** `0x00`  **Access:** see fields below

RX FIFO byte count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `RX_COUNT` | `[7:0]` | RO | `0x00` | Number of bytes in RX FIFO |

---
### `RF_LNA_CTRL` — Address `0x0200`

**Reset value:** `0x00`  **Access:** see fields below

RF LNA (HMC8141) control - enable and power state

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0x0` | LNA enable (1=powered, 0=shutdown) |
| `POWER_GOOD` | `[4]` | RO | `0x0` | LNA power good status |

---
### `RF_VGA_GAIN` — Address `0x0201`

**Reset value:** `0x0F`  **Access:** see fields below

RF VGA (HMC698LP4) gain control - 30dB range in 1dB steps

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GAIN_CODE` | `[4:0]` | RW | `0x0F` | 5-bit gain code (0-31, default 15 = mid-range) |
| `SPI_BUSY` | `[15]` | RO | `0x0` | SPI transfer in progress |

---
### `RF_MIXER_CTRL` — Address `0x0202`

**Reset value:** `0x00`  **Access:** see fields below

RF Mixer (HMC-CMS19) enable control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0x0` | Mixer enable (1=powered, 0=shutdown) |
| `LO_PRESENT` | `[4]` | RO | `0x0` | LO input detected status |

---
### `RF_IF_AMP_CTRL` — Address `0x0203`

**Reset value:** `0x00`  **Access:** see fields below

IF Amplifier (HMC5805) control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0x0` | IF amplifier enable |
| `GAIN_SEL` | `[2:1]` | RW | `0x0` | Gain select (0=low, 1=med, 2=high) |

---
### `ADC_HS_CTRL` — Address `0x0300`

**Reset value:** `0x00`  **Access:** see fields below

High-speed ADC (EV10AQ190A) control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0x0` | ADC enable (1=enabled) |
| `MODE` | `[2:1]` | RW | `0x0` | ADC mode (00=1-ch, 01=2-ch, 10=4-ch) |
| `DCLK_EN` | `[3]` | RW | `0x0` | Output data clock enable |

---
### `ADC_HS_STATUS` — Address `0x0301`

**Reset value:** `0x00`  **Access:** see fields below

High-speed ADC status flags

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READY` | `[0]` | RO | `0x0` | ADC ready for conversion |
| `OVERRANGE` | `[1]` | RC | `0x0` | Input overrange detected (read-clear) |
| `CAL_DONE` | `[2]` | RO | `0x0` | Internal calibration complete |

---
### `ADC_HS_CONFIG` — Address `0x0302`

**Reset value:** `0x0110`  **Access:** see fields below

High-speed ADC configuration parameters

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `SAMPLE_RATE` | `[7:0]` | RW | `0x10` | Sample rate divisor (default = 5 Gsps) |
| `OFFSET_EN` | `[8]` | RW | `0x1` | Offset correction enable |

---
### `ADC_FIFO_LEVEL` — Address `0x0303`

**Reset value:** `0x00`  **Access:** see fields below

ADC data FIFO level monitoring

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `FIFO_COUNT` | `[11:0]` | RO | `0x00` | Number of samples in data FIFO |

---
### `TEMP_LOCAL` — Address `0x0400`

**Reset value:** `0x0000`  **Access:** see fields below

Local MCU die temperature (0.25C units, signed)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP` | `[9:0]` | RO | `0x0000` | Temperature in 0.25C units (signed) |

---
### `TEMP_REMOTE1` — Address `0x0401`

**Reset value:** `0x0000`  **Access:** see fields below

External temperature sensor 1 (RF front-end area)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP` | `[9:0]` | RO | `0x0000` | Remote temperature value (signed) |

---
### `TEMP_ALERT_HIGH` — Address `0x0408`

**Reset value:** `0x0190`  **Access:** see fields below

Over-temperature alert threshold

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `THRESHOLD` | `[9:0]` | RW | `0x0190` | High threshold (default 100C = 0x0190) |

---
### `TEMP_ALERT_LOW` — Address `0x0409`

**Reset value:** `0xFF9C`  **Access:** see fields below

Under-temperature alert threshold

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `THRESHOLD` | `[9:0]` | RW | `0xFF9C` | Low threshold (default -25C = 0xFF9C) |

---
### `CLK_GEN_CTRL` — Address `0x0500`

**Reset value:** `0x00`  **Access:** see fields below

Clock generator (Si5345B-D) control via I2C

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0x0` | Clock generator enable (via I2C) |
| `I2C_BUSY` | `[7]` | RO | `0x0` | I2C transaction in progress |

---
### `CLK_GEN_STATUS` — Address `0x0501`

**Reset value:** `0x00`  **Access:** see fields below

Clock generator status monitoring

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `PLL_LOCK` | `[0]` | RO | `0x0` | PLL locked indicator |
| `LOSS_OF_LOCK` | `[1]` | RC | `0x0` | Loss of lock flag (read-clear) |

---
### `CLK_BUF_ENABLE` — Address `0x0502`

**Reset value:** `0x0F`  **Access:** see fields below

Clock buffer (ADCLK914) output enables

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `OUT_EN` | `[3:0]` | RW | `0xF` | Output enables (bit 0 = CLK_ADC, bit 1 = CLK_SYS) |

---
### `EEPROM_CTRL` — Address `0x0600`

**Reset value:** `0x00`  **Access:** see fields below

EEPROM (M24M02-DR) control via I2C

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READ` | `[0]` | RW | `0x0` | Initiate read (write 1 to start) |
| `WRITE` | `[1]` | RW | `0x0` | Initiate write (write 1 to start) |
| `BUSY` | `[7]` | RO | `0x0` | I2C transaction busy |

---
### `EEPROM_ADDR` — Address `0x0601`

**Reset value:** `0x0000`  **Access:** see fields below

EEPROM byte address (18-bit address space)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADDR` | `[17:0]` | RW | `0x00000` | Byte address within EEPROM (256KB) |

---
### `EEPROM_DATA` — Address `0x0602`

**Reset value:** `0x00`  **Access:** see fields below

EEPROM read/write data

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA` | `[7:0]` | RW | `0x00` | Data byte for read/write operations |

---
### `ADC_PSU_CTRL` — Address `0x0700`

**Reset value:** `0x01`  **Access:** see fields below

Power supply monitoring ADC control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0x1` | PSU monitoring ADC enable |
| `CONTINUOUS` | `[1]` | RW | `0x0` | Continuous conversion mode |

---
### `VCC_5V_RAW` — Address `0x0701`

**Reset value:** `0x0000`  **Access:** see fields below

+5V rail ADC count (12-bit)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | RO | `0x000` | ADC count (multiply by 5.0/4096 for Volts) |

---
### `VCC_3V3_RAW` — Address `0x0702`

**Reset value:** `0x0000`  **Access:** see fields below

+3.3V rail ADC count (12-bit)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | RO | `0x000` | ADC count (multiply by 3.3/4096 for Volts) |

---
### `VCC_15V_RAW` — Address `0x0703`

**Reset value:** `0x0000`  **Access:** see fields below

+15V rail ADC count (12-bit)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | RO | `0x000` | ADC count (multiply by 15.0/4096 for Volts) |

---
### `ICC_5V_RAW` — Address `0x0708`

**Reset value:** `0x0000`  **Access:** see fields below

+5V rail current ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | RO | `0x000` | Current monitor ADC count |

---
### `ICC_3V3_RAW` — Address `0x0709`

**Reset value:** `0x0000`  **Access:** see fields below

+3.3V rail current ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | RO | `0x000` | Current monitor ADC count |

---
### `DCDC_ENABLE` — Address `0x0710`

**Reset value:** `0x01`  **Access:** see fields below

DC-DC converter (PKM4716TCD15) enable control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0x1` | DC-DC converter enable signal |

---
### `HEALTH_STATUS` — Address `0x0711`

**Reset value:** `0x00`  **Access:** see fields below

System health summary status

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_OK` | `[0]` | RO | `0x0` | Temperature within limits (1=OK) |
| `VOLT_OK` | `[1]` | RO | `0x0` | All voltages within tolerance (1=OK) |
| `CLK_LOCK` | `[2]` | RO | `0x0` | Clock generator locked (1=OK) |
| `SYSTEM_OK` | `[7]` | RO | `0x0` | Overall system health (1=OK) |

---
### `LED_CTRL` — Address `0x0800`

**Reset value:** `0x01`  **Access:** see fields below

Status LED control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LED_STATUS` | `[0]` | RW | `0x1` | Status LED state (1=on) |
| `LED_MODE` | `[2:1]` | RW | `0x0` | LED mode (0=manual, 1=heartbeat, 2=fault blink) |

---
### `GPIO_DIR` — Address `0x0801`

**Reset value:** `0x0000`  **Access:** see fields below

GPIO direction control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DIR` | `[15:0]` | RW | `0x0000` | Direction per bit (0=input, 1=output) |

---
### `GPIO_DATA` — Address `0x0802`

**Reset value:** `0x0000`  **Access:** see fields below

GPIO data read/write

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA` | `[15:0]` | RW | `0x0000` | GPIO pin data values |
