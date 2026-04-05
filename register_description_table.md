# Register Description Table (RDT)
## hkgg

> **Total registers:** 33

hkgg RF Power Amplifier Controller - Complete register map (31 registers) for FPGA-based PA bias control, I2C DAC interface, power sequencing, temperature monitoring, and UART communication. Operating voltage: +12V main rail with +3.3V logic. Key features: MAX1167 DAC bias control, RF enable interlock, temperature monitoring, automatic power-down protection, and host communication interface.

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
| `0x0000` | `BOARD_ID` | — | `0x484B` | Board identification code for hkgg RF PA module |
| `0x0001` | `BOARD_VERSION` | — | `0x10` | Hardware version number |
| `0x0002` | `BOARD_TYPE_ID` | — | `0x5041` | Board type identifier |
| `0x0003` | `SCRATCHPAD` | — | `0x0000` | General-purpose read/write test register for RAM verification |
| `0x0010` | `MCS_VERSION_MAJOR` | — | `0x01` | FPGA firmware major version number |
| `0x0011` | `MCS_VERSION_MINOR` | — | `0x00` | FPGA firmware minor version number |
| `0x0012` | `BUILD_DATE` | — | `0x2604` | Firmware build date in packed BCD format (YYYYMMDD) |
| `0x0100` | `UART_BAUD_DIV` | — | `0x001B` | UART baud rate divisor for 50MHz system clock (DIV = CLK/(16*BAUD)) |
| `0x0101` | `UART_CTRL` | — | `0x03` | UART control register for enable and loopback mode |
| `0x0102` | `UART_STATUS` | — | `0x00` | UART status flags - read clears error flags |
| `0x0103` | `UART_TX_COUNT` | — | `0x00` | Number of bytes currently in TX FIFO |
| `0x0104` | `UART_RX_COUNT` | — | `0x00` | Number of bytes available in RX FIFO |
| `0x0800` | `RF_ENABLE_CMD` | — | `0x00` | RF amplifier enable command control |
| `0x0801` | `RF_STATUS` | — | `0x04` | RF power amplifier status flags |
| `0x0802` | `RF_PWR_CTRL` | — | `0x0A00` | RF power sequencing control register |
| `0x0803` | `PA_BIAS_DAC` | — | `0x0800` | MAX1167 DAC output value for PA gate bias (12-bit) |
| `0x0804` | `PA_BIAS_CONFIG` | — | `0x0FFF` | PA bias configuration limits |
| `0x0210` | `VCC_12V_RAW` | — | `0x0000` | 12V main supply rail ADC count |
| `0x0211` | `VCC_3V3_RAW` | — | `0x0000` | 3.3V logic supply rail ADC count |
| `0x0212` | `VCC_DRAIN_RAW` | — | `0x0000` | PA drain supply monitoring (12V_DRAIN rail) |
| `0x0213` | `VCC_GATE_RAW` | — | `0x0000` | Gate bias voltage monitoring |
| `0x0218` | `ICC_12V_RAW` | — | `0x0000` | 12V main supply current monitoring |
| `0x0219` | `ICC_DRAIN_RAW` | — | `0x0000` | PA drain current monitoring |
| `0x0200` | `ADC_CTRL` | — | `0x03` | ADC control register for supply monitoring |
| `0x0201` | `ADC_STATUS` | — | `0x00` | ADC status and ready flag |
| `0x0300` | `TEMP_LOCAL` | — | `0x0190` | FPGA die temperature (from LM75A via I2C) |
| `0x0301` | `TEMP_PA_MRF1511G` | — | `0x0190` | PA transistor temperature (remote sensor) |
| `0x0302` | `TEMP_DRIVER_GVA` | — | `0x0190` | Driver amplifier temperature (GVA-123+) |
| `0x0308` | `TEMP_ALERT_HIGH` | — | `0x0320` | Over-temperature shutdown threshold |
| `0x0309` | `TEMP_ALERT_LOW` | — | `0xFFCC` | Under-temperature warning threshold |
| `0x030F` | `HEALTH_STATUS` | — | `0x83` | Overall system health status flags |
| `0x0805` | `FAULT_FLAGS` | — | `0x0000` | Fault detection and shutdown flags |
| `0x0806` | `SYSTEM_RESET` | — | `0x00` | System reset control register |

---
### `BOARD_ID` — Address `0x0000`

**Reset value:** `0x484B`  **Access:** see fields below

Board identification code for hkgg RF PA module

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BOARD_ID_CODE` | `[15:0]` | R | `0x484B` | ASCII 'HK' identifier code |

---
### `BOARD_VERSION` — Address `0x0001`

**Reset value:** `0x10`  **Access:** see fields below

Hardware version number

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAJOR_VERSION` | `[7:4]` | R | `0x1` | Major version (0-15) |
| `MINOR_VERSION` | `[3:0]` | R | `0x0` | Minor version (0-15) |

---
### `BOARD_TYPE_ID` — Address `0x0002`

**Reset value:** `0x5041`  **Access:** see fields below

Board type identifier

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BOARD_TYPE` | `[15:0]` | R | `0x5041` | ASCII 'PA' for Power Amplifier |

---
### `SCRATCHPAD` — Address `0x0003`

**Reset value:** `0x0000`  **Access:** see fields below

General-purpose read/write test register for RAM verification

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEST_PATTERN` | `[15:0]` | RW | `0x0000` | Read/write test value - use 0xA5A5/0x5A5A pattern |

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

**Reset value:** `0x2604`  **Access:** see fields below

Firmware build date in packed BCD format (YYYYMMDD)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `YEAR` | `[15:12]` | R | `0x2` | Year tens digit |
| `BUILD_BCD` | `[11:0]` | R | `0x060` | YYMMDD in BCD |

---
### `UART_BAUD_DIV` — Address `0x0100`

**Reset value:** `0x001B`  **Access:** see fields below

UART baud rate divisor for 50MHz system clock (DIV = CLK/(16*BAUD))

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BAUD_DIVISOR` | `[15:0]` | RW | `0x001B` | Divisor for 115200 baud (50MHz/(16*115200) = 27) |

---
### `UART_CTRL` — Address `0x0101`

**Reset value:** `0x03`  **Access:** see fields below

UART control register for enable and loopback mode

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `UART_ENABLE` | `[0]` | RW | `0x0` | 1=Enable UART transmitter and receiver |
| `LOOPBACK_EN` | `[1]` | RW | `0x0` | 1=Enable internal loopback test mode |
| `FRAME_FORMAT` | `[7:4]` | RW | `0x3` | UART frame format (0x3=8N1 standard) |

---
### `UART_STATUS` — Address `0x0102`

**Reset value:** `0x00`  **Access:** see fields below

UART status flags - read clears error flags

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TX_BUSY` | `[0]` | R | `0x0` | Transmitter busy flag |
| `RX_AVAIL` | `[1]` | R | `0x0` | Data available in RX FIFO |
| `FRAME_ERR` | `[2]` | RC | `0x0` | Frame error flag (cleared on read) |
| `OVERRUN_ERR` | `[3]` | RC | `0x0` | RX FIFO overrun error |

---
### `UART_TX_COUNT` — Address `0x0103`

**Reset value:** `0x00`  **Access:** see fields below

Number of bytes currently in TX FIFO

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TX_FIFO_LEVEL` | `[7:0]` | R | `0x00` | TX FIFO byte count (0-16) |

---
### `UART_RX_COUNT` — Address `0x0104`

**Reset value:** `0x00`  **Access:** see fields below

Number of bytes available in RX FIFO

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `RX_FIFO_LEVEL` | `[7:0]` | R | `0x00` | RX FIFO byte count (0-16) |

---
### `RF_ENABLE_CMD` — Address `0x0800`

**Reset value:** `0x00`  **Access:** see fields below

RF amplifier enable command control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `RF_ENABLE` | `[0]` | RW | `0x0` | 1=Enable RF PA output (opens interlock) |
| `ENABLE_REQ` | `[1]` | R | `0x0` | External enable request status (TP1 input) |
| `ENABLE_OVERRIDE` | `[2]` | RW | `0x0` | 1=Override safety interlock (test only) |

---
### `RF_STATUS` — Address `0x0801`

**Reset value:** `0x04`  **Access:** see fields below

RF power amplifier status flags

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `RF_ENABLED` | `[0]` | R | `0x0` | RF output currently enabled |
| `BIAS_ACTIVE` | `[1]` | R | `0x0` | Gate bias voltage active |
| `INTERLOCK_OK` | `[2]` | R | `0x1` | Safety interlock closed (normal) |
| `OUTPUT_FAULT` | `[3]` | R | `0x0` | Output fault detected |

---
### `RF_PWR_CTRL` — Address `0x0802`

**Reset value:** `0x0A00`  **Access:** see fields below

RF power sequencing control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BATT_ENABLE` | `[0]` | RW | `0x0` | Control +12V_DRAIN via main FET |
| `DRIVER_ENABLE` | `[1]` | RW | `0x0` | Control +12V_DRIVER to GVA-123+ |
| `LOGIC_ENABLE` | `[2]` | RW | `0x0` | Control +12V_LOGIC via IRLML6402 |
| `SEQ_DELAY_MS` | `[15:8]` | RW | `0x0A` | Power sequencing delay in milliseconds |

---
### `PA_BIAS_DAC` — Address `0x0803`

**Reset value:** `0x0800`  **Access:** see fields below

MAX1167 DAC output value for PA gate bias (12-bit)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GATE_BIAS` | `[11:0]` | RW | `0x800` | Gate bias DAC value (2048 = mid-scale, ~2.5V) |
| `DAC_UPDATE` | `[15]` | W | `0x0` | Write 1 to trigger I2C update to MAX1167 |

---
### `PA_BIAS_CONFIG` — Address `0x0804`

**Reset value:** `0x0FFF`  **Access:** see fields below

PA bias configuration limits

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAX_BIAS` | `[11:0]` | RW | `0xFFF` | Maximum allowed gate bias setting |
| `MIN_BIAS` | `[15:12]` | RW | `0x0` | Minimum bias nibble (protects full cutoff) |

---
### `VCC_12V_RAW` — Address `0x0210`

**Reset value:** `0x0000`  **Access:** see fields below

12V main supply rail ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_12V` | `[11:0]` | R | `0x000` | 12V rail ADC value (multiply by 12.0/4096 for Volts) |

---
### `VCC_3V3_RAW` — Address `0x0211`

**Reset value:** `0x0000`  **Access:** see fields below

3.3V logic supply rail ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_3V3` | `[11:0]` | R | `0x000` | 3.3V rail ADC value (from DAC reference) |

---
### `VCC_DRAIN_RAW` — Address `0x0212`

**Reset value:** `0x0000`  **Access:** see fields below

PA drain supply monitoring (12V_DRAIN rail)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_DRAIN` | `[11:0]` | R | `0x000` | Drain supply ADC count |

---
### `VCC_GATE_RAW` — Address `0x0213`

**Reset value:** `0x0000`  **Access:** see fields below

Gate bias voltage monitoring

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_GATE` | `[11:0]` | R | `0x000` | Gate bias voltage ADC count |

---
### `ICC_12V_RAW` — Address `0x0218`

**Reset value:** `0x0000`  **Access:** see fields below

12V main supply current monitoring

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_ICC_12V` | `[11:0]` | R | `0x000` | 12V rail current ADC count |

---
### `ICC_DRAIN_RAW` — Address `0x0219`

**Reset value:** `0x0000`  **Access:** see fields below

PA drain current monitoring

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_ICC_DRAIN` | `[11:0]` | R | `0x000` | PA drain current ADC (proportional to output power) |

---
### `ADC_CTRL` — Address `0x0200`

**Reset value:** `0x03`  **Access:** see fields below

ADC control register for supply monitoring

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_START` | `[0]` | RW | `0x1` | 1=Start continuous ADC conversion |
| `ADC_CHANNEL` | `[3:2]` | RW | `0x0` | Channel select for single conversion |
| `ADC_CONT_EN` | `[1]` | RW | `0x1` | 1=Continuous mode, 0=Single shot |

---
### `ADC_STATUS` — Address `0x0201`

**Reset value:** `0x00`  **Access:** see fields below

ADC status and ready flag

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA_READY` | `[0]` | R | `0x0` | New conversion data available |
| `OVERRANGE` | `[1]` | RC | `0x0` | ADC input overrange detected |

---
### `TEMP_LOCAL` — Address `0x0300`

**Reset value:** `0x0190`  **Access:** see fields below

FPGA die temperature (from LM75A via I2C)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_VALUE` | `[9:0]` | R | `0x190` | Temperature in 0.25°C units (signed, 0x190=25°C) |

---
### `TEMP_PA_MRF1511G` — Address `0x0301`

**Reset value:** `0x0190`  **Access:** see fields below

PA transistor temperature (remote sensor)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `PA_TEMP` | `[9:0]` | R | `0x190` | MRF1511G case temperature in 0.25°C units |

---
### `TEMP_DRIVER_GVA` — Address `0x0302`

**Reset value:** `0x0190`  **Access:** see fields below

Driver amplifier temperature (GVA-123+)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DRV_TEMP` | `[9:0]` | R | `0x190` | GVA-123+ temperature in 0.25°C units |

---
### `TEMP_ALERT_HIGH` — Address `0x0308`

**Reset value:** `0x0320`  **Access:** see fields below

Over-temperature shutdown threshold

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `OT_THRESHOLD` | `[9:0]` | RW | `0x320` | OT shutdown at 100°C (0x320 * 0.25 = 80°C) |

---
### `TEMP_ALERT_LOW` — Address `0x0309`

**Reset value:** `0xFFCC`  **Access:** see fields below

Under-temperature warning threshold

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `UT_THRESHOLD` | `[9:0]` | RW | `0xFFCC` | UT warning at -20°C (signed) |

---
### `HEALTH_STATUS` — Address `0x030F`

**Reset value:** `0x83`  **Access:** see fields below

Overall system health status flags

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_OK` | `[0]` | R | `0x1` | All temperature sensors within limits |
| `VOLT_OK` | `[1]` | R | `0x1` | All supply voltages within ±10% |
| `OVERCURRENT` | `[2]` | R | `0x0` | Overcurrent fault detected |
| `SYSTEM_OK` | `[7]` | R | `0x1` | Overall system healthy (all checks pass) |

---
### `FAULT_FLAGS` — Address `0x0805`

**Reset value:** `0x0000`  **Access:** see fields below

Fault detection and shutdown flags

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `OT_SHUTDOWN` | `[0]` | RC | `0x0` | Over-temperature shutdown occurred |
| `UV_FAULT` | `[1]` | RC | `0x0` | Undervoltage fault detected |
| `OC_FAULT` | `[2]` | RC | `0x0` | Overcurrent fault detected |
| `INTERLOCK_OPEN` | `[3]` | RC | `0x0` | Safety interlock opened |
| `FAULT_LATCHED` | `[15]` | RW | `0x0` | 1=Fault latched, write 0 to clear |

---
### `SYSTEM_RESET` — Address `0x0806`

**Reset value:** `0x00`  **Access:** see fields below

System reset control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `RESET_RF` | `[0]` | RW | `0x0` | 1=Reset RF power section |
| `RESET_DAC` | `[1]` | RW | `0x0` | 1=Reset DAC to default bias |
| `GLOBAL_RESET` | `[7]` | RW | `0x0` | 1=Trigger full system reset |
