# Register Description Table (RDT)
## Test

> **Total registers:** 22

Built-in register map for Test — 22 registers across 8 functional groups with 15-step initialisation sequence.

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
| `0x0000` | `BOARD_ID` | — | `0x0001` | Board identification code |
| `0x0001` | `BOARD_VERSION` | — | `0x0010` | Hardware version (major.minor) |
| `0x0003` | `SCRATCHPAD` | — | `0x0000` | Read/write test register |
| `0x0010` | `MCS_VERSION` | — | `0x0100` | Firmware version |
| `0x0100` | `UART_BAUD_DIV` | — | `0x001A` | UART baud rate divisor (115200 @ 48MHz) |
| `0x0101` | `UART_CTRL` | — | `0x0000` | UART control register |
| `0x0102` | `UART_STATUS` | — | `0x0000` | UART status register |
| `0x0200` | `ADC_CTRL` | — | `0x0000` | ADC control register |
| `0x0201` | `ADC_STATUS` | — | `0x0000` | ADC status |
| `0x0210` | `VCC_5V_RAW` | — | `0x0000` | 5V rail ADC count |
| `0x0211` | `VCC_3V3_RAW` | — | `0x0000` | 3.3V rail ADC count |
| `0x0300` | `TEMP_LOCAL` | — | `0x0000` | FPGA die temperature (0.25C/LSB signed) |
| `0x0308` | `TEMP_ALERT_HIGH` | — | `0x0190` | Over-temperature threshold (100C default) |
| `0x030F` | `HEALTH_STATUS` | — | `0x0000` | System health summary |
| `0x0400` | `PLL_CTRL` | — | `0x0000` | PLL control |
| `0x0401` | `PLL_STATUS` | — | `0x0000` | PLL status |
| `0x0402` | `PLL_N_DIV` | — | `0x0008` | PLL N divider |
| `0x0410` | `CLK_ENABLE` | — | `0x0000` | Clock output enables |
| `0x0500` | `EEPROM_CTRL` | — | `0x0000` | EEPROM control |
| `0x0800` | `GPIO_DIR` | — | `0x0000` | GPIO direction (1=output) |
| `0x0801` | `GPIO_OUT` | — | `0x0000` | GPIO output data |
| `0x0802` | `GPIO_IN` | — | `0x0000` | GPIO input data (read-only) |

---
### `BOARD_ID` — Address `0x0000`

**Reset value:** `0x0001`  **Access:** see fields below

Board identification code

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ID` | `[15:0]` | R | `0x0001` | Hardware board ID |

---
### `BOARD_VERSION` — Address `0x0001`

**Reset value:** `0x0010`  **Access:** see fields below

Hardware version (major.minor)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAJOR` | `[7:4]` | R | `0x1` | Major version |
| `MINOR` | `[3:0]` | R | `0x0` | Minor version |

---
### `SCRATCHPAD` — Address `0x0003`

**Reset value:** `0x0000`  **Access:** see fields below

Read/write test register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA` | `[15:0]` | RW | `0x0000` | Scratch data |

---
### `MCS_VERSION` — Address `0x0010`

**Reset value:** `0x0100`  **Access:** see fields below

Firmware version

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAJOR` | `[15:8]` | R | `0x01` | FW major |
| `MINOR` | `[7:0]` | R | `0x00` | FW minor |

---
### `UART_BAUD_DIV` — Address `0x0100`

**Reset value:** `0x001A`  **Access:** see fields below

UART baud rate divisor (115200 @ 48MHz)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DIV` | `[15:0]` | RW | `0x001A` | Divisor value |

---
### `UART_CTRL` — Address `0x0101`

**Reset value:** `0x0000`  **Access:** see fields below

UART control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `EN` | `[0]` | RW | `0x0` | UART enable |
| `LOOPBACK` | `[1]` | RW | `0x0` | Loopback mode |

---
### `UART_STATUS` — Address `0x0102`

**Reset value:** `0x0000`  **Access:** see fields below

UART status register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TX_BUSY` | `[0]` | R | `0x0` | TX in progress |
| `RX_AVAIL` | `[1]` | RC | `0x0` | RX data available |

---
### `ADC_CTRL` — Address `0x0200`

**Reset value:** `0x0000`  **Access:** see fields below

ADC control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `START` | `[0]` | RW | `0x0` | Start conversion |
| `CONT` | `[1]` | RW | `0x0` | Continuous mode |
| `CH_SEL` | `[3:2]` | RW | `0x0` | Channel select |

---
### `ADC_STATUS` — Address `0x0201`

**Reset value:** `0x0000`  **Access:** see fields below

ADC status

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA_RDY` | `[0]` | RC | `0x0` | Conversion complete |

---
### `VCC_5V_RAW` — Address `0x0210`

**Reset value:** `0x0000`  **Access:** see fields below

5V rail ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `COUNT` | `[11:0]` | R | `0x000` | ADC count (5.0/4096 V/LSB) |

---
### `VCC_3V3_RAW` — Address `0x0211`

**Reset value:** `0x0000`  **Access:** see fields below

3.3V rail ADC count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `COUNT` | `[11:0]` | R | `0x000` | ADC count |

---
### `TEMP_LOCAL` — Address `0x0300`

**Reset value:** `0x0000`  **Access:** see fields below

FPGA die temperature (0.25C/LSB signed)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP` | `[9:0]` | R | `0x000` | Temperature |

---
### `TEMP_ALERT_HIGH` — Address `0x0308`

**Reset value:** `0x0190`  **Access:** see fields below

Over-temperature threshold (100C default)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `THRESH` | `[9:0]` | RW | `0x190` | Alert threshold |

---
### `HEALTH_STATUS` — Address `0x030F`

**Reset value:** `0x0000`  **Access:** see fields below

System health summary

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_OK` | `[0]` | R | `0x0` | Temperature in range |
| `VOLT_OK` | `[1]` | R | `0x0` | Voltages in range |
| `PLL_LOCK` | `[2]` | R | `0x0` | PLL locked |
| `SYS_OK` | `[7]` | R | `0x0` | Overall system OK |

---
### `PLL_CTRL` — Address `0x0400`

**Reset value:** `0x0000`  **Access:** see fields below

PLL control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `EN` | `[0]` | RW | `0x0` | PLL enable |
| `RESET` | `[1]` | RW | `0x0` | PLL reset |
| `REF_SEL` | `[3:2]` | RW | `0x0` | Ref clock select |

---
### `PLL_STATUS` — Address `0x0401`

**Reset value:** `0x0000`  **Access:** see fields below

PLL status

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LOCKED` | `[0]` | R | `0x0` | PLL locked |

---
### `PLL_N_DIV` — Address `0x0402`

**Reset value:** `0x0008`  **Access:** see fields below

PLL N divider

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `N` | `[15:0]` | RW | `0x0008` | N divider value |

---
### `CLK_ENABLE` — Address `0x0410`

**Reset value:** `0x0000`  **Access:** see fields below

Clock output enables

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `CLK_EN` | `[7:0]` | RW | `0x00` | One bit per output |

---
### `EEPROM_CTRL` — Address `0x0500`

**Reset value:** `0x0000`  **Access:** see fields below

EEPROM control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READ` | `[0]` | RW | `0x0` | Start read |
| `WRITE` | `[1]` | RW | `0x0` | Start write |
| `BUSY` | `[7]` | R | `0x0` | Operation in progress |

---
### `GPIO_DIR` — Address `0x0800`

**Reset value:** `0x0000`  **Access:** see fields below

GPIO direction (1=output)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DIR` | `[15:0]` | RW | `0x0000` | Direction bits |

---
### `GPIO_OUT` — Address `0x0801`

**Reset value:** `0x0000`  **Access:** see fields below

GPIO output data

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA` | `[15:0]` | RW | `0x0000` | Output data |

---
### `GPIO_IN` — Address `0x0802`

**Reset value:** `0x0000`  **Access:** see fields below

GPIO input data (read-only)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA` | `[15:0]` | R | `0x0000` | Pin state |
