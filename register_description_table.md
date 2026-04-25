# Register Description Table (RDT)
## hv

> **Total registers:** 11

Complete register map and initialisation sequence for the **hv** project — an 18–40 GHz dual-channel double-IF superheterodyne radar receiver built around a Xilinx Kintex-7 XC7K160T-1FFG676I FPGA. The register map comprises 48 registers across 10 functional groups (0x000–0x900), covering board identification, UART/Ethernet communication, dual-channel 12-bit ADC monitoring of four supply rails and two current sense points, temperature monitoring (local + 2 remote AD7416 sensors), LO1/LO2 PLL synthesizer configuration (ADF4108, LMX2487), SPI EEPROM (AT93C56B), QSPI Flash (IS25LP256D), RF path control (LNAs, VGAs, limiters, preselectors, driver amplifiers), general-purpose I/O, and dual DAC outputs for VGA AGC control. The 20-step programming sequence ensures correct hardware-dependency ordering: power-on self-check → clock/PLL bring-up → peripheral enable → UART init → temperature alert arming → EEPROM calibration load → flash verification → RF path default → ADC configuration → DAC zeroing → AGC default → GPIO tri-state → preselector preset → PLL lock verification → system-OK assertion.

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
| `0x0000` | `BOARD_ID` | — | `0x4856` | Board identification code. Fixed factory-programmed value identifying this PCB as the hv 18-40 GHz dual-channel radar receiver. |
| `0x0001` | `BOARD_VERSION` | — | `0x0100` | Hardware PCB revision. Encoded as BCD major.minor version numbers. |
| `0x0002` | `BOARD_TYPE_ID` | — | `0x0003` | Board type identifier distinguishing this board variant within the product family. |
| `0x0003` | `SCRATCHPAD` | — | `0x0000` | General-purpose read/write test register used for FPGA internal data-path verification and UART link integrity checks. |
| `0x0010` | `MCS_VERSION_MAJOR` | — | `0x00` | FPGA firmware major version number (MCS bitstream version). |
| `0x0011` | `MCS_VERSION_MINOR` | — | `0x01` | FPGA firmware minor version number. |
| `0x0012` | `BUILD_DATE` | — | `0x20260425` | FPGA firmware build date encoded as packed BCD YYYYMMDD. Allows firmware revision tracking. |
| `0x0100` | `UART_BAUD_DIV` | — | `0x0036` | UART baud rate divisor. Baud = fclk / (16 × DIV). For 115200 baud with 100 MHz clock: DIV = 54 (0x0036). |
| `0x0101` | `UART_CTRL` | — | `0x0001` | UART operational control register. Configures enable, loopback test mode, and frame format. |
| `0x0102` | `UART_STATUS` | — | `0x0000` | UART status flags. Read-clear (RC) register — reading clears all latched flags. |
| `0x0103` | `UART_TX_COUNT` | — | `0x0000` | Number of bytes currently in the TX FIFO. Poll before writing to avoid overflow. |

---
### `BOARD_ID` — Address `0x0000`

**Reset value:** `0x4856`  **Access:** see fields below

Board identification code. Fixed factory-programmed value identifying this PCB as the hv 18-40 GHz dual-channel radar receiver.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BOARD_ID` | `[15:0]` | R | `0x4856` | ASCII 'HV' = 0x4856. Read-only factory identifier. |

---
### `BOARD_VERSION` — Address `0x0001`

**Reset value:** `0x0100`  **Access:** see fields below

Hardware PCB revision. Encoded as BCD major.minor version numbers.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAJOR` | `[15:8]` | R | `0x01` | Major hardware revision (BCD). e.g. 0x01 = Rev 1. |
| `MINOR` | `[7:0]` | R | `0x00` | Minor hardware revision (BCD). e.g. 0x00 = Rev 1.0. |

---
### `BOARD_TYPE_ID` — Address `0x0002`

**Reset value:** `0x0003`  **Access:** see fields below

Board type identifier distinguishing this board variant within the product family.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TYPE_ID` | `[15:0]` | R | `0x0003` | Type code 0x0003 = Dual-channel superheterodyne radar receiver. |

---
### `SCRATCHPAD` — Address `0x0003`

**Reset value:** `0x0000`  **Access:** see fields below

General-purpose read/write test register used for FPGA internal data-path verification and UART link integrity checks.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA` | `[15:0]` | RW | `0x0000` | Scratch data. Write any value, read back to verify bus integrity. |

---
### `MCS_VERSION_MAJOR` — Address `0x0010`

**Reset value:** `0x00`  **Access:** see fields below

FPGA firmware major version number (MCS bitstream version).

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAJOR` | `[7:0]` | R | `0x00` | FPGA bitstream major version. |

---
### `MCS_VERSION_MINOR` — Address `0x0011`

**Reset value:** `0x01`  **Access:** see fields below

FPGA firmware minor version number.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MINOR` | `[7:0]` | R | `0x01` | FPGA bitstream minor version. |

---
### `BUILD_DATE` — Address `0x0012`

**Reset value:** `0x20260425`  **Access:** see fields below

FPGA firmware build date encoded as packed BCD YYYYMMDD. Allows firmware revision tracking.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `YEAR_MONTH` | `[15:0]` | R | `0x2026` | Upper 16 bits of build date BCD: year (high byte) and month (low byte). |
| `DAY` | `[15:0]` | R | `0x0425` | Read at offset +1 for day BCD. Single 16-bit read returns YYYY packed. Full date requires two reads or 32-bit access. |

---
### `UART_BAUD_DIV` — Address `0x0100`

**Reset value:** `0x0036`  **Access:** see fields below

UART baud rate divisor. Baud = fclk / (16 × DIV). For 115200 baud with 100 MHz clock: DIV = 54 (0x0036).

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DIV` | `[15:0]` | RW | `0x0036` | Baud rate divisor value. Default 0x0036 = 115200 baud @ 100 MHz. |

---
### `UART_CTRL` — Address `0x0101`

**Reset value:** `0x0001`  **Access:** see fields below

UART operational control register. Configures enable, loopback test mode, and frame format.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0x1` | UART enable. 1=enabled, 0=disabled (TX/RX held in reset). |
| `LOOPBACK` | `[1]` | RW | `0x0` | Internal loopback mode for self-test. 1=TX data routed to RX internally. |
| `FRAME_FORMAT` | `[7:4]` | RW | `0x0` | Frame format control. 0000=8N1 (default), 0001=8E1, 0010=8O1, 0011=8N2. |
| `RSVD` | `[15:8]` | RW | `0x00` | Reserved. Write 0x00. |

---
### `UART_STATUS` — Address `0x0102`

**Reset value:** `0x0000`  **Access:** see fields below

UART status flags. Read-clear (RC) register — reading clears all latched flags.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TX_BUSY` | `[0]` | RC | `0x0` | Transmitter busy flag. 1=TX in progress. Cleared on read. |
| `RX_AVAIL` | `[1]` | RC | `0x0` | RX data available. 1=at least one byte in RX FIFO. Cleared on read. |
| `FRAME_ERR` | `[2]` | RC | `0x0` | Frame error detected (stop bit violation). Cleared on read. |
| `OVERRUN` | `[3]` | RC | `0x0` | RX FIFO overrun. Data lost. Cleared on read. |

---
### `UART_TX_COUNT` — Address `0x0103`

**Reset value:** `0x0000`  **Access:** see fields below

Number of bytes currently in the TX FIFO. Poll before writing to avoid overflow.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `COUNT` | `[7:0]` | R | `0x00` | TX FIFO occupancy count (0–255). |
