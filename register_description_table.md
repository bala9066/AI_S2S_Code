# Register Description Table (RDT)
## hfuf

> **Total registers:** 53

HFUF 4-Channel 2-6 GHz Radar RF Front-End Module - Complete UART-controlled FPGA register map and initialization sequence covering board information, RF path control, active bias sequencing, ADC monitoring, PLL/clock configuration, temperature sensing, EEPROM, and Flash interfaces.

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
| `0x0000` | `BOARD_ID` | — | `0x4855` | Board identification code - ASCII 'HU' for HFUF module |
| `0x0001` | `BOARD_VERSION` | — | `0x01` | Hardware version number - major and minor revision |
| `0x0002` | `BOARD_TYPE_ID` | — | `0x0004` | Board type identifier |
| `0x0003` | `SCRATCHPAD` | — | `0x0000` | Read/write test register for RAM verification |
| `0x0010` | `MCS_VERSION_MAJOR` | — | `0x01` | FPGA firmware major version number |
| `0x0011` | `MCS_VERSION_MINOR` | — | `0x00` | FPGA firmware minor version number |
| `0x0012` | `BUILD_DATE` | — | `0x20260422` | Firmware build date in packed BCD format (YYYYMMDD) |
| `0x0100` | `UART_BAUD_DIV` | — | `0x0034` | UART baud rate divisor for FT2232H interface |
| `0x0101` | `UART_CTRL` | — | `0x00` | UART control register |
| `0x0102` | `UART_STATUS` | — | `0x00` | UART status flags |
| `0x0700` | `RF_PATH_CTRL` | — | `0x0000` | RF path enable control for all 4 channels |
| `0x0701` | `RF_GAIN_CTRL_CH1` | — | `0x0000` | RF gain control for Channel 1 (3 gain blocks) |
| `0x0702` | `RF_GAIN_CTRL_CH2` | — | `0x0000` | RF gain control for Channel 2 (3 gain blocks) |
| `0x0703` | `RF_GAIN_CTRL_CH3` | — | `0x0000` | RF gain control for Channel 3 (3 gain blocks) |
| `0x0704` | `RF_GAIN_CTRL_CH4` | — | `0x0000` | RF gain control for Channel 4 (3 gain blocks) |
| `0x0710` | `ABC_SEQUENCER_CTRL` | — | `0x0000` | Active Bias Control sequencer enable and timing |
| `0x0711` | `ABC_GATE_CTRL_CH1` | — | `0x0000` | Gate bias control for Channel 1 GaN HEMT |
| `0x0712` | `ABC_GATE_CTRL_CH2` | — | `0x0000` | Gate bias control for Channel 2 GaN HEMT |
| `0x0713` | `ABC_GATE_CTRL_CH3` | — | `0x0000` | Gate bias control for Channel 3 GaN HEMT |
| `0x0714` | `ABC_GATE_CTRL_CH4` | — | `0x0000` | Gate bias control for Channel 4 GaN HEMT |
| `0x071F` | `ABC_STATUS` | — | `0x0000` | ABC sequencer status monitoring |
| `0x0200` | `ADC_CTRL` | — | `0x00` | ADC controller for supply monitoring |
| `0x0201` | `ADC_STATUS` | — | `0x00` | ADC status flags |
| `0x0210` | `VCC_5V_RAW` | — | `0x0000` | 5V rail ADC raw count (12-bit) |
| `0x0211` | `VCC_3V3_RAW` | — | `0x0000` | 3.3V rail ADC raw count (12-bit) |
| `0x0212` | `VCC_2V5_RAW` | — | `0x0000` | 2.5V rail ADC raw count (12-bit) |
| `0x0213` | `VCC_1V8_RAW` | — | `0x0000` | 1.8V rail ADC raw count (12-bit) |
| `0x0218` | `ICC_5V_RAW` | — | `0x0000` | 5V rail current sense ADC raw count |
| `0x0219` | `ICC_3V3_RAW` | — | `0x0000` | 3.3V rail current sense ADC raw count |
| `0x0300` | `TEMP_LOCAL` | — | `0x0190` | FPGA die temperature in 0.25°C units (signed) |
| `0x0301` | `TEMP_REMOTE1` | — | `0x0140` | Remote sensor 1 temperature (LM75A) |
| `0x0302` | `TEMP_REMOTE2` | — | `0x0140` | Remote sensor 2 temperature (LM75A) |
| `0x0308` | `TEMP_ALERT_HIGH` | — | `0x0190` | Over-temperature alert threshold |
| `0x0309` | `TEMP_ALERT_LOW` | — | `0xFF9C` | Under-temperature alert threshold (signed) |
| `0x030F` | `HEALTH_STATUS` | — | `0x00` | System health status flags |
| `0x0400` | `PLL_CTRL` | — | `0x00` | PLL control register |
| `0x0401` | `PLL_STATUS` | — | `0x00` | PLL status flags |
| `0x0402` | `PLL_N_DIV` | — | `0x0032` | PLL N divider value |
| `0x0403` | `PLL_R_DIV` | — | `0x01` | PLL R divider value |
| `0x0410` | `CLK_ENABLE` | — | `0x00` | Clock output enables |
| `0x0500` | `EEPROM_CTRL` | — | `0x00` | EEPROM control register (AT25040N 4Kbit SPI) |
| `0x0501` | `EEPROM_ADDR` | — | `0x0000` | EEPROM byte address (9-bit address space) |
| `0x0502` | `EEPROM_DATA` | — | `0x0000` | EEPROM read/write data |
| `0x0600` | `FLASH_CTRL` | — | `0x00` | Configuration Flash control (S25FL512S 64MB SPI) |
| `0x0601` | `FLASH_ADDR_LOW` | — | `0x0000` | Flash address low word |
| `0x0602` | `FLASH_ADDR_HIGH` | — | `0x0000` | Flash address high byte |
| `0x0603` | `FLASH_DATA` | — | `0x0000` | Flash data FIFO |
| `0x0604` | `FLASH_STATUS` | — | `0x01` | Flash status flags |
| `0x0800` | `GPIO_CTRL` | — | `0x0000` | GPIO direction and control |
| `0x0801` | `GPIO_DATA` | — | `0x0000` | GPIO data register |
| `0x0802` | `GPIO_OUTPUT_EN` | — | `0x0000` | GPIO output enable (tri-state control) |
| `0x0FF0` | `SYSTEM_RESET` | — | `0x0000` | System reset control register |
| `0x0FFF` | `FPGA_ID_CODE` | — | `0x35314137` | FPGA device identification code |

---
### `BOARD_ID` — Address `0x0000`

**Reset value:** `0x4855`  **Access:** see fields below

Board identification code - ASCII 'HU' for HFUF module

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BOARD_ID_VALUE` | `[15:0]` | R | `0x4855` | Unique board identifier (ASCII 'HU') |

---
### `BOARD_VERSION` — Address `0x0001`

**Reset value:** `0x01`  **Access:** see fields below

Hardware version number - major and minor revision

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAJOR_REV` | `[7:4]` | R | `0x0` | Major hardware revision |
| `MINOR_REV` | `[3:0]` | R | `0x1` | Minor hardware revision |

---
### `BOARD_TYPE_ID` — Address `0x0002`

**Reset value:** `0x0004`  **Access:** see fields below

Board type identifier

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BOARD_TYPE` | `[15:0]` | R | `0x0004` | Type ID = 4 for 4-channel RF front-end |

---
### `SCRATCHPAD` — Address `0x0003`

**Reset value:** `0x0000`  **Access:** see fields below

Read/write test register for RAM verification

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEST_VALUE` | `[15:0]` | RW | `0x0000` | General-purpose test register - write/read back for RAM check |

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

**Reset value:** `0x20260422`  **Access:** see fields below

Firmware build date in packed BCD format (YYYYMMDD)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BUILD_YEAR` | `[15:12]` | R | `0x2` | Build year (decade) |
| `BUILD_DATE_BCD` | `[31:0]` | R | `0x20260422` | Full BCD date stamp |

---
### `UART_BAUD_DIV` — Address `0x0100`

**Reset value:** `0x0034`  **Access:** see fields below

UART baud rate divisor for FT2232H interface

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BAUD_DIVISOR` | `[15:0]` | RW | `0x0034` | Baud divisor = 115200 target (52 decimal for 6MHz clock) |

---
### `UART_CTRL` — Address `0x0101`

**Reset value:** `0x00`  **Access:** see fields below

UART control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0x0` | UART enable (1=enabled) |
| `LOOPBACK` | `[1]` | RW | `0x0` | Loopback mode for test (1=loopback) |
| `FRAME_FORMAT` | `[7:4]` | RW | `0x0` | UART frame format selection |

---
### `UART_STATUS` — Address `0x0102`

**Reset value:** `0x00`  **Access:** see fields below

UART status flags

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TX_BUSY` | `[0]` | R | `0x0` | Transmitter busy flag |
| `RX_AVAIL` | `[1]` | R | `0x0` | Data available in RX FIFO |
| `FRAME_ERR` | `[2]` | RC | `0x0` | Frame error flag (read-clear) |
| `PARITY_ERR` | `[3]` | RC | `0x0` | Parity error flag (read-clear) |

---
### `RF_PATH_CTRL` — Address `0x0700`

**Reset value:** `0x0000`  **Access:** see fields below

RF path enable control for all 4 channels

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `CH1_EN` | `[0]` | RW | `0x0` | Channel 1 RF path enable |
| `CH2_EN` | `[1]` | RW | `0x0` | Channel 2 RF path enable |
| `CH3_EN` | `[2]` | RW | `0x0` | Channel 3 RF path enable |
| `CH4_EN` | `[3]` | RW | `0x0` | Channel 4 RF path enable |
| `ALL_PATH_EN` | `[15:4]` | RW | `0x0` | Reserved for future expansion |

---
### `RF_GAIN_CTRL_CH1` — Address `0x0701`

**Reset value:** `0x0000`  **Access:** see fields below

RF gain control for Channel 1 (3 gain blocks)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GAIN1` | `[4:0]` | RW | `0x00` | Gain block 1 setting (0-31) |
| `GAIN2` | `[9:5]` | RW | `0x00` | Gain block 2 setting (0-31) |
| `GAIN3` | `[14:10]` | RW | `0x00` | Gain block 3 setting (0-31) |

---
### `RF_GAIN_CTRL_CH2` — Address `0x0702`

**Reset value:** `0x0000`  **Access:** see fields below

RF gain control for Channel 2 (3 gain blocks)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GAIN1` | `[4:0]` | RW | `0x00` | Gain block 1 setting (0-31) |
| `GAIN2` | `[9:5]` | RW | `0x00` | Gain block 2 setting (0-31) |
| `GAIN3` | `[14:10]` | RW | `0x00` | Gain block 3 setting (0-31) |

---
### `RF_GAIN_CTRL_CH3` — Address `0x0703`

**Reset value:** `0x0000`  **Access:** see fields below

RF gain control for Channel 3 (3 gain blocks)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GAIN1` | `[4:0]` | RW | `0x00` | Gain block 1 setting (0-31) |
| `GAIN2` | `[9:5]` | RW | `0x00` | Gain block 2 setting (0-31) |
| `GAIN3` | `[14:10]` | RW | `0x00` | Gain block 3 setting (0-31) |

---
### `RF_GAIN_CTRL_CH4` — Address `0x0704`

**Reset value:** `0x0000`  **Access:** see fields below

RF gain control for Channel 4 (3 gain blocks)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GAIN1` | `[4:0]` | RW | `0x00` | Gain block 1 setting (0-31) |
| `GAIN2` | `[9:5]` | RW | `0x00` | Gain block 2 setting (0-31) |
| `GAIN3` | `[14:10]` | RW | `0x00` | Gain block 3 setting (0-31) |

---
### `ABC_SEQUENCER_CTRL` — Address `0x0710`

**Reset value:** `0x0000`  **Access:** see fields below

Active Bias Control sequencer enable and timing

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ABC_ENABLE` | `[0]` | RW | `0x0` | Enable ABC bias sequencer |
| `ABC_RESET` | `[1]` | RW | `0x0` | Reset ABC sequencer state machine |
| `DELAY_10MS` | `[7:2]` | RW | `0x01` | Delay multiplier (x10ms per step) |
| `AUTO_RAMP` | `[8]` | RW | `0x0` | Automatic ramp-up on enable |

---
### `ABC_GATE_CTRL_CH1` — Address `0x0711`

**Reset value:** `0x0000`  **Access:** see fields below

Gate bias control for Channel 1 GaN HEMT

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GATE_VOLTAGE` | `[11:0]` | RW | `0x000` | 12-bit DAC value for gate bias (0-3.3V) |
| `GATE_ENABLE` | `[15]` | RW | `0x0` | Enable gate bias output |

---
### `ABC_GATE_CTRL_CH2` — Address `0x0712`

**Reset value:** `0x0000`  **Access:** see fields below

Gate bias control for Channel 2 GaN HEMT

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GATE_VOLTAGE` | `[11:0]` | RW | `0x000` | 12-bit DAC value for gate bias (0-3.3V) |
| `GATE_ENABLE` | `[15]` | RW | `0x0` | Enable gate bias output |

---
### `ABC_GATE_CTRL_CH3` — Address `0x0713`

**Reset value:** `0x0000`  **Access:** see fields below

Gate bias control for Channel 3 GaN HEMT

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GATE_VOLTAGE` | `[11:0]` | RW | `0x000` | 12-bit DAC value for gate bias (0-3.3V) |
| `GATE_ENABLE` | `[15]` | RW | `0x0` | Enable gate bias output |

---
### `ABC_GATE_CTRL_CH4` — Address `0x0714`

**Reset value:** `0x0000`  **Access:** see fields below

Gate bias control for Channel 4 GaN HEMT

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GATE_VOLTAGE` | `[11:0]` | RW | `0x000` | 12-bit DAC value for gate bias (0-3.3V) |
| `GATE_ENABLE` | `[15]` | RW | `0x0` | Enable gate bias output |

---
### `ABC_STATUS` — Address `0x071F`

**Reset value:** `0x0000`  **Access:** see fields below

ABC sequencer status monitoring

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `SEQ_BUSY` | `[0]` | R | `0x0` | Sequencer busy flag |
| `CH1_BIAS_OK` | `[4]` | R | `0x0` | Channel 1 bias stable flag |
| `CH2_BIAS_OK` | `[5]` | R | `0x0` | Channel 2 bias stable flag |
| `CH3_BIAS_OK` | `[6]` | R | `0x0` | Channel 3 bias stable flag |
| `CH4_BIAS_OK` | `[7]` | R | `0x0` | Channel 4 bias stable flag |
| `ALL_BIAS_OK` | `[15]` | R | `0x0` | All channels bias ready |

---
### `ADC_CTRL` — Address `0x0200`

**Reset value:** `0x00`  **Access:** see fields below

ADC controller for supply monitoring

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `START` | `[0]` | RW | `0x0` | Start ADC conversion |
| `CONTINUOUS` | `[1]` | RW | `0x0` | Continuous conversion mode |
| `CHANNEL_SEL` | `[3:2]` | RW | `0x0` | ADC channel select |

---
### `ADC_STATUS` — Address `0x0201`

**Reset value:** `0x00`  **Access:** see fields below

ADC status flags

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA_READY` | `[0]` | R | `0x0` | New data available flag |
| `OVERRANGE` | `[1]` | RC | `0x0` | Overrange alarm (read-clear) |

---
### `VCC_5V_RAW` — Address `0x0210`

**Reset value:** `0x0000`  **Access:** see fields below

5V rail ADC raw count (12-bit)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | R | `0x000` | Raw ADC count, multiply by 5.0/4096 for Volts |

---
### `VCC_3V3_RAW` — Address `0x0211`

**Reset value:** `0x0000`  **Access:** see fields below

3.3V rail ADC raw count (12-bit)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | R | `0x000` | Raw ADC count, multiply by 3.3/4096 for Volts |

---
### `VCC_2V5_RAW` — Address `0x0212`

**Reset value:** `0x0000`  **Access:** see fields below

2.5V rail ADC raw count (12-bit)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | R | `0x000` | Raw ADC count, multiply by 2.5/4096 for Volts |

---
### `VCC_1V8_RAW` — Address `0x0213`

**Reset value:** `0x0000`  **Access:** see fields below

1.8V rail ADC raw count (12-bit)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | R | `0x000` | Raw ADC count, multiply by 1.8/4096 for Volts |

---
### `ICC_5V_RAW` — Address `0x0218`

**Reset value:** `0x0000`  **Access:** see fields below

5V rail current sense ADC raw count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | R | `0x000` | Current sense raw count |

---
### `ICC_3V3_RAW` — Address `0x0219`

**Reset value:** `0x0000`  **Access:** see fields below

3.3V rail current sense ADC raw count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | R | `0x000` | Current sense raw count |

---
### `TEMP_LOCAL` — Address `0x0300`

**Reset value:** `0x0190`  **Access:** see fields below

FPGA die temperature in 0.25°C units (signed)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_VALUE` | `[9:0]` | R | `0x190` | Temperature in 0.25°C units (0x190 = 100°C) |

---
### `TEMP_REMOTE1` — Address `0x0301`

**Reset value:** `0x0140`  **Access:** see fields below

Remote sensor 1 temperature (LM75A)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_VALUE` | `[9:0]` | R | `0x140` | Temperature in 0.25°C units (0x140 = 80°C) |

---
### `TEMP_REMOTE2` — Address `0x0302`

**Reset value:** `0x0140`  **Access:** see fields below

Remote sensor 2 temperature (LM75A)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_VALUE` | `[9:0]` | R | `0x140` | Temperature in 0.25°C units (0x140 = 80°C) |

---
### `TEMP_ALERT_HIGH` — Address `0x0308`

**Reset value:** `0x0190`  **Access:** see fields below

Over-temperature alert threshold

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ALERT_THRESH` | `[9:0]` | RW | `0x190` | High temperature threshold (100°C default) |

---
### `TEMP_ALERT_LOW` — Address `0x0309`

**Reset value:** `0xFF9C`  **Access:** see fields below

Under-temperature alert threshold (signed)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ALERT_THRESH` | `[9:0]` | RW | `0xFF9C` | Low temperature threshold (-25°C default) |

---
### `HEALTH_STATUS` — Address `0x030F`

**Reset value:** `0x00`  **Access:** see fields below

System health status flags

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_OK` | `[0]` | R | `0x0` | Temperature within limits flag |
| `VOLT_OK` | `[1]` | R | `0x0` | All voltages within limits flag |
| `PLL_LOCK` | `[2]` | R | `0x0` | PLL lock status flag |
| `ABC_OK` | `[3]` | R | `0x0` | Active Bias Control OK flag |
| `SYSTEM_OK` | `[7]` | R | `0x0` | Overall system healthy flag |

---
### `PLL_CTRL` — Address `0x0400`

**Reset value:** `0x00`  **Access:** see fields below

PLL control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0x0` | Enable PLL (1=enabled) |
| `RESET` | `[1]` | RW | `0x0` | PLL reset (assert to reset) |
| `REF_SEL` | `[3:2]` | RW | `0x0` | Reference clock select |

---
### `PLL_STATUS` — Address `0x0401`

**Reset value:** `0x00`  **Access:** see fields below

PLL status flags

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LOCKED` | `[0]` | R | `0x0` | PLL lock acquired flag |
| `LOSS_OF_LOCK` | `[1]` | RC | `0x0` | Loss of lock flag (read-clear) |

---
### `PLL_N_DIV` — Address `0x0402`

**Reset value:** `0x0032`  **Access:** see fields below

PLL N divider value

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `N_DIVIDER` | `[15:0]` | RW | `0x32` | N divider value (50 decimal for typical config) |

---
### `PLL_R_DIV` — Address `0x0403`

**Reset value:** `0x01`  **Access:** see fields below

PLL R divider value

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `R_DIVIDER` | `[7:0]` | RW | `0x1` | R divider value (1 = reference not divided) |

---
### `CLK_ENABLE` — Address `0x0410`

**Reset value:** `0x00`  **Access:** see fields below

Clock output enables

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `CLK_OUT0_EN` | `[0]` | RW | `0x0` | Clock output 0 enable |
| `CLK_OUT1_EN` | `[1]` | RW | `0x0` | Clock output 1 enable |
| `CLK_OUT2_EN` | `[2]` | RW | `0x0` | Clock output 2 enable |
| `CLK_OUT3_EN` | `[3]` | RW | `0x0` | Clock output 3 enable |
| `CLK_OUT4_EN` | `[4]` | RW | `0x0` | Clock output 4 enable |
| `CLK_OUT5_EN` | `[5]` | RW | `0x0` | Clock output 5 enable |
| `CLK_OUT6_EN` | `[6]` | RW | `0x0` | Clock output 6 enable |
| `CLK_OUT7_EN` | `[7]` | RW | `0x0` | Clock output 7 enable |

---
### `EEPROM_CTRL` — Address `0x0500`

**Reset value:** `0x00`  **Access:** see fields below

EEPROM control register (AT25040N 4Kbit SPI)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READ` | `[0]` | RW | `0x0` | Initiate read (self-clearing) |
| `WRITE` | `[1]` | RW | `0x0` | Initiate write (self-clearing) |
| `ERASE` | `[2]` | RW | `0x0` | Initiate erase (self-clearing) |
| `BUSY` | `[7]` | R | `0x0` | EEPROM operation busy flag |

---
### `EEPROM_ADDR` — Address `0x0501`

**Reset value:** `0x0000`  **Access:** see fields below

EEPROM byte address (9-bit address space)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BYTE_ADDR` | `[8:0]` | RW | `0x000` | Byte address within EEPROM (0-511) |

---
### `EEPROM_DATA` — Address `0x0502`

**Reset value:** `0x0000`  **Access:** see fields below

EEPROM read/write data

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA_WORD` | `[15:0]` | RW | `0x0000` | 16-bit data word for read/write |

---
### `FLASH_CTRL` — Address `0x0600`

**Reset value:** `0x00`  **Access:** see fields below

Configuration Flash control (S25FL512S 64MB SPI)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READ` | `[0]` | RW | `0x0` | Initiate flash read |
| `WRITE` | `[1]` | RW | `0x0` | Initiate flash program |
| `ERASE_SECTOR` | `[2]` | RW | `0x0` | Erase sector (256KB) |
| `ERASE_CHIP` | `[3]` | RW | `0x0` | Erase entire chip |
| `BUSY` | `[7]` | R | `0x0` | Flash operation busy flag |

---
### `FLASH_ADDR_LOW` — Address `0x0601`

**Reset value:** `0x0000`  **Access:** see fields below

Flash address low word

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADDR_LOW` | `[15:0]` | RW | `0x0000` | Lower 16 bits of flash address |

---
### `FLASH_ADDR_HIGH` — Address `0x0602`

**Reset value:** `0x0000`  **Access:** see fields below

Flash address high byte

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADDR_HIGH` | `[7:0]` | RW | `0x00` | Upper 8 bits of flash address |

---
### `FLASH_DATA` — Address `0x0603`

**Reset value:** `0x0000`  **Access:** see fields below

Flash data FIFO

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA_WORD` | `[15:0]` | RW | `0x0000` | 16-bit data word for flash I/O |

---
### `FLASH_STATUS` — Address `0x0604`

**Reset value:** `0x01`  **Access:** see fields below

Flash status flags

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READY` | `[0]` | R | `0x1` | Flash ready flag |
| `WRITE_ERR` | `[1]` | RC | `0x0` | Write error flag (read-clear) |
| `ERASE_ERR` | `[2]` | RC | `0x0` | Erase error flag (read-clear) |

---
### `GPIO_CTRL` — Address `0x0800`

**Reset value:** `0x0000`  **Access:** see fields below

GPIO direction and control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GPIO0_DIR` | `[0]` | RW | `0x0` | GPIO0 direction (1=output) |
| `GPIO1_DIR` | `[1]` | RW | `0x0` | GPIO1 direction (1=output) |
| `GPIO2_DIR` | `[2]` | RW | `0x0` | GPIO2 direction (1=output) |
| `GPIO3_DIR` | `[3]` | RW | `0x0` | GPIO3 direction (1=output) |
| `GPIO4_DIR` | `[4]` | RW | `0x0` | GPIO4 direction (1=output) |
| `GPIO5_DIR` | `[5]` | RW | `0x0` | GPIO5 direction (1=output) |
| `GPIO6_DIR` | `[6]` | RW | `0x0` | GPIO6 direction (1=output) |
| `GPIO7_DIR` | `[7]` | RW | `0x0` | GPIO7 direction (1=output) |

---
### `GPIO_DATA` — Address `0x0801`

**Reset value:** `0x0000`  **Access:** see fields below

GPIO data register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GPIO0` | `[0]` | RW | `0x0` | GPIO0 data bit |
| `GPIO1` | `[1]` | RW | `0x0` | GPIO1 data bit |
| `GPIO2` | `[2]` | RW | `0x0` | GPIO2 data bit |
| `GPIO3` | `[3]` | RW | `0x0` | GPIO3 data bit |
| `GPIO4` | `[4]` | RW | `0x0` | GPIO4 data bit |
| `GPIO5` | `[5]` | RW | `0x0` | GPIO5 data bit |
| `GPIO6` | `[6]` | RW | `0x0` | GPIO6 data bit |
| `GPIO7` | `[7]` | RW | `0x0` | GPIO7 data bit |

---
### `GPIO_OUTPUT_EN` — Address `0x0802`

**Reset value:** `0x0000`  **Access:** see fields below

GPIO output enable (tri-state control)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GPIO0_OE` | `[0]` | RW | `0x0` | GPIO0 output enable (1=enabled) |
| `GPIO1_OE` | `[1]` | RW | `0x0` | GPIO1 output enable (1=enabled) |
| `GPIO2_OE` | `[2]` | RW | `0x0` | GPIO2 output enable (1=enabled) |
| `GPIO3_OE` | `[3]` | RW | `0x0` | GPIO3 output enable (1=enabled) |
| `GPIO4_OE` | `[4]` | RW | `0x0` | GPIO4 output enable (1=enabled) |
| `GPIO5_OE` | `[5]` | RW | `0x0` | GPIO5 output enable (1=enabled) |
| `GPIO6_OE` | `[6]` | RW | `0x0` | GPIO6 output enable (1=enabled) |
| `GPIO7_OE` | `[7]` | RW | `0x0` | GPIO7 output enable (1=enabled) |

---
### `SYSTEM_RESET` — Address `0x0FF0`

**Reset value:** `0x0000`  **Access:** see fields below

System reset control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `SOFT_RESET` | `[0]` | RW | `0x0` | Trigger soft reset (self-clearing) |
| `RESET_RF_PATHS` | `[1]` | RW | `0x0` | Reset all RF path controls |
| `RESET_ABC` | `[2]` | RW | `0x0` | Reset ABC sequencer |
| `RESET_MAGIC` | `[15:8]` | RW | `0x00` | Must write 0xA5 to enable reset operations |

---
### `FPGA_ID_CODE` — Address `0x0FFF`

**Reset value:** `0x35314137`  **Access:** see fields below

FPGA device identification code

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DEVICE_ID` | `[31:0]` | R | `0x35314137` | XC7A35T device ID (ASCII '7A35') |
