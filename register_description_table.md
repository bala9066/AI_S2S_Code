# Register Description Table (RDT)
## yhh

> **Total registers:** 61

Register Description Table and Programming Sequence for the yhh 4-channel monopulse radar RF front-end system, based on Artix-7 XC7A200T-1FB676I FPGA. The register map spans 10 functional groups (0x000–0x900) covering board information, UART communication, ADC supply monitoring, temperature/health, PLL/clock, EEPROM, flash, RF phase/GPIO, DAC output, and LNA bias control. The programming sequence initializes the FPGA glue logic in correct hardware dependency order: power-on self-check → PLL/clock → peripheral enable → communication → application-specific RF chain configuration.

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
| `0x0000` | `BOARD_ID` | — | `0x5948` | Board identification code. Fixed value read from FPGA configuration bitstream identifying this design as yhh. |
| `0x0001` | `BOARD_VERSION` | — | `0x0001` | Hardware PCB version encoded as BCD major.minor revision. |
| `0x0002` | `BOARD_TYPE_ID` | — | `0x0004` | Board type identifier distinguishing yhh from other board variants in the product family. |
| `0x0003` | `SCRATCHPAD` | — | `0x0000` | General-purpose read/write test register used for UART link verification and FPGA register access confidence test. |
| `0x0010` | `MCS_VERSION_MAJOR` | — | `0x00` | FPGA firmware (MCS bitstream) major version number. |
| `0x0011` | `MCS_VERSION_MINOR` | — | `0x00` | FPGA firmware (MCS bitstream) minor version number. |
| `0x0012` | `BUILD_DATE` | — | `0x2604` | FPGA firmware build date encoded as packed BCD YYYYMMDD. |
| `0x0100` | `UART_BAUD_DIV` | — | `0x0036` | UART baud rate divisor. Baud = SystemClock / (16 × DIV). For 100 MHz clock and 115200 baud, DIV = 54 (0x0036). |
| `0x0101` | `UART_CTRL` | — | `0x0001` | UART operating mode control register. |
| `0x0102` | `UART_STATUS` | — | `0x0000` | UART operational status flags. Read-cleared on read. |
| `0x0103` | `UART_TX_COUNT` | — | `0x0000` | Number of bytes currently in the TX FIFO. |
| `0x0104` | `UART_RX_COUNT` | — | `0x0000` | Number of bytes currently in the RX FIFO. |
| `0x0110` | `ETH_MAC_LOW` | — | `0x0000` | Lower 16 bits of the Ethernet MAC address (OUI + NIC portion). |
| `0x0111` | `ETH_MAC_HIGH` | — | `0x0000` | Upper 16 bits of the Ethernet MAC address. |
| `0x0120` | `SPI_CTRL` | — | `0x0000` | SPI master controller configuration for EEPROM and Flash interface. |
| `0x0121` | `SPI_STATUS` | — | `0x0001` | SPI controller operational status. |
| `0x0130` | `I2C_CTRL` | — | `0x0000` | I2C master controller configuration for temperature sensor and power monitor IC access. |
| `0x0131` | `I2C_STATUS` | — | `0x0000` | I2C controller operational status. |
| `0x0200` | `ADC_CTRL` | — | `0x0000` | ADC control for supply voltage and current monitoring. |
| `0x0201` | `ADC_STATUS` | — | `0x0000` | ADC conversion status flags. |
| `0x0210` | `VCC_5V_RAW` | — | `0x0000` | 5V supply rail ADC conversion result. Voltage = RAW × 5.0 / 4096. |
| `0x0211` | `VCC_3V3_RAW` | — | `0x0000` | 3.3V supply rail ADC conversion result. Voltage = RAW × 3.3 / 4096. |
| `0x0212` | `VCC_1V8_RAW` | — | `0x0000` | 1.8V FPGA I/O supply rail ADC conversion result. Voltage = RAW × 1.8 / 4096. |
| `0x0213` | `VCC_1V0_RAW` | — | `0x0000` | 1.0V FPGA core supply rail ADC conversion result. Voltage = RAW × 1.0 / 4096. |
| `0x0218` | `ICC_5V_RAW` | — | `0x0000` | 5V rail current-sense ADC result. |
| `0x0219` | `ICC_3V3_RAW` | — | `0x0000` | 3.3V rail current-sense ADC result. |
| `0x0300` | `TEMP_LOCAL` | — | `0x0000` | Local FPGA die temperature from internal XADC sensor. Signed value in 0.25°C units. Temp(°C) = VALUE × 0.25. |
| `0x0301` | `TEMP_REMOTE1` | — | `0x0000` | Remote I2C temperature sensor 1 reading (PCB hotspot near LNAs). |
| `0x0302` | `TEMP_REMOTE2` | — | `0x0000` | Remote I2C temperature sensor 2 reading (PCB area near power converter). |
| `0x0308` | `TEMP_ALERT_HIGH` | — | `0x0190` | Over-temperature alert threshold. If TEMP_LOCAL exceeds this, the ALERT flag in HEALTH_STATUS is asserted. |
| `0x0309` | `TEMP_ALERT_LOW` | — | `0xFF9C` | Under-temperature alert threshold for cold-start detection. |
| `0x030F` | `HEALTH_STATUS` | — | `0x0000` | Aggregate system health flags. SYSTEM_OK is the logical AND of all individual OK flags. |
| `0x0400` | `PLL_CTRL` | — | `0x0000` | System PLL control for generating reference clocks to RF chain and FPGA logic. |
| `0x0401` | `PLL_STATUS` | — | `0x0000` | PLL lock and fault status. |
| `0x0402` | `PLL_N_DIV` | — | `0x0010` | PLL N feedback divider value for VCO frequency configuration. |
| `0x0403` | `PLL_R_DIV` | — | `0x0004` | PLL R reference divider value. |
| `0x0410` | `CLK_ENABLE` | — | `0x0000` | Individual clock output enables. Each bit gates one differential clock pair to a destination block. |
| `0x0500` | `EEPROM_CTRL` | — | `0x0000` | EEPROM interface control. Write operations require unlock key in EEPROM_UNLOCK first. |
| `0x0501` | `EEPROM_ADDR` | — | `0x0000` | EEPROM byte address for next read/write/erase operation. |
| `0x0502` | `EEPROM_DATA` | — | `0x0000` | EEPROM read/write data register. Write data before triggering WRITE; read data after READ completes. |
| `0x0503` | `EEPROM_UNLOCK` | — | `0x0000` | Unlock key register for EEPROM write/erase protection. Write 0xA1B2 to enable writes for one operation cycle. |
| `0x0600` | `FLASH_CTRL` | — | `0x0000` | Configuration Flash interface control. Erase requires unlock key. |
| `0x0601` | `FLASH_ADDR_LOW` | — | `0x0000` | Flash address lower 16 bits. |
| `0x0602` | `FLASH_ADDR_HIGH` | — | `0x0000` | Flash address upper 8 bits (for >64KB addressable Flash). |
| `0x0603` | `FLASH_DATA` | — | `0x0000` | Flash read/write data FIFO. Writes push to TX FIFO; reads pop from RX FIFO. |
| `0x0604` | `FLASH_STATUS` | — | `0x0001` | Flash interface status flags. |
| `0x0800` | `GPIO_CTRL` | — | `0x0000` | General-purpose I/O direction and value control for board-level signals. |
| `0x0801` | `GPIO_INPUT` | — | `0x0000` | GPIO pin input readback values. |
| `0x0802` | `TR_SWITCH_CTRL` | — | `0x0000` | T/R (Transmit/Receive) SPDT switch control per channel (QPC2420SR). Controls front-end isolation during TX pulses. |
| `0x0803` | `LNA_BIAS_CTRL` | — | `0x0000` | LNA (PMA4-6263LN+) bias enable and gate control per channel. Active-high enables the drain voltage supply to each LNA pair. |
| `0x0804` | `GAIN_AMP_CTRL` | — | `0x0000` | Gain block / driver amplifier (PMA3-15453+) enable per channel. Controls stages 2 and 3 after the balanced LNA. |
| `0x0805` | `LIMITER_STATUS` | — | `0x0000` | PIN diode limiter (CLA4611-085LF) fault status per channel. Indicates if the front-end limiter has clamped due to overdrive. |
| `0x0806` | `MONOPULSE_CTRL` | — | `0x0000` | Monopulse comparator network (SCA-4-132+) output path selection. Selects which of the 4 comparator outputs (Sum, Delta-AZ, Delta-EL, Delta-DE) is routed to the IF output. |
| `0x0807` | `BPF_TUNING` | — | `0x0008` | Ceramic preselector bandpass filter (BFCN-1840+) center frequency tuning control. |
| `0x0900` | `DAC_CTRL` | — | `0x0000` | DAC control for analog tuning and bias voltage outputs. |
| `0x0901` | `DAC_DATA` | — | `0x0800` | DAC output data register for the channel selected in DAC_CTRL. |
| `0x0902` | `DAC_STATUS` | — | `0x0001` | DAC output status and fault flags. |
| `0x0903` | `RF_POWER_MONITOR` | — | `0x0000` | RF power detector reading for overall output power monitoring. |
| `0x0310` | `INTERRUPT_STATUS` | — | `0x0000` | Active interrupt flags. Each bit represents a pending interrupt source. Read-cleared. |
| `0x0311` | `INTERRUPT_MASK` | — | `0x0000` | Interrupt enable mask. Setting a bit to 1 enables the corresponding interrupt source. |
| `0x001F` | `SYSTEM_CTRL` | — | `0x0000` | Global system control register for FPGA-wide resets and operational mode. |

---
### `BOARD_ID` — Address `0x0000`

**Reset value:** `0x5948`  **Access:** see fields below

Board identification code. Fixed value read from FPGA configuration bitstream identifying this design as yhh.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ID` | `[15:0]` | R | `0x5948` | ASCII 'YH' = 0x5948 board identifier |

---
### `BOARD_VERSION` — Address `0x0001`

**Reset value:** `0x0001`  **Access:** see fields below

Hardware PCB version encoded as BCD major.minor revision.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAJOR` | `[7:4]` | R | `0x0` | Hardware major revision (BCD) |
| `MINOR` | `[3:0]` | R | `0x1` | Hardware minor revision (BCD) |

---
### `BOARD_TYPE_ID` — Address `0x0002`

**Reset value:** `0x0004`  **Access:** see fields below

Board type identifier distinguishing yhh from other board variants in the product family.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TYPE` | `[15:0]` | R | `0x0004` | Type ID: 0x0004 = 4-channel monopulse RF front-end |

---
### `SCRATCHPAD` — Address `0x0003`

**Reset value:** `0x0000`  **Access:** see fields below

General-purpose read/write test register used for UART link verification and FPGA register access confidence test.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA` | `[15:0]` | RW | `0x0000` | User-accessible scratch data for link integrity test |

---
### `MCS_VERSION_MAJOR` — Address `0x0010`

**Reset value:** `0x00`  **Access:** see fields below

FPGA firmware (MCS bitstream) major version number.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAJOR` | `[7:0]` | R | `0x01` | Firmware major version |

---
### `MCS_VERSION_MINOR` — Address `0x0011`

**Reset value:** `0x00`  **Access:** see fields below

FPGA firmware (MCS bitstream) minor version number.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MINOR` | `[7:0]` | R | `0x00` | Firmware minor version |

---
### `BUILD_DATE` — Address `0x0012`

**Reset value:** `0x2604`  **Access:** see fields below

FPGA firmware build date encoded as packed BCD YYYYMMDD.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `YEAR` | `[15:12]` | R | `0x2` | Year upper digit (2026) |
| `MONTH` | `[11:8]` | R | `0x6` | Month (06) |
| `DAY_HI` | `[7:4]` | R | `0x0` | Day upper digit |
| `DAY_LO` | `[3:0]` | R | `0x4` | Day lower digit (04) |

---
### `UART_BAUD_DIV` — Address `0x0100`

**Reset value:** `0x0036`  **Access:** see fields below

UART baud rate divisor. Baud = SystemClock / (16 × DIV). For 100 MHz clock and 115200 baud, DIV = 54 (0x0036).

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DIV` | `[15:0]` | RW | `0x0036` | Baud rate divisor (default 115200 @ 100 MHz) |

---
### `UART_CTRL` — Address `0x0101`

**Reset value:** `0x0001`  **Access:** see fields below

UART operating mode control register.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0x1` | UART enable (1=active) |
| `LOOPBACK` | `[1]` | RW | `0x0` | Internal loopback for self-test |
| `FRAME_FORMAT` | `[7:4]` | RW | `0x3` | Frame format: 0x3=8N1 |

---
### `UART_STATUS` — Address `0x0102`

**Reset value:** `0x0000`  **Access:** see fields below

UART operational status flags. Read-cleared on read.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TX_BUSY` | `[0]` | RC | `0x0` | Transmitter busy |
| `RX_AVAIL` | `[1]` | RC | `0x0` | RX FIFO has data available |
| `FRAME_ERR` | `[2]` | RC | `0x0` | Framing error detected |
| `OVERRUN` | `[3]` | RC | `0x0` | RX FIFO overrun |

---
### `UART_TX_COUNT` — Address `0x0103`

**Reset value:** `0x0000`  **Access:** see fields below

Number of bytes currently in the TX FIFO.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `COUNT` | `[7:0]` | R | `0x00` | TX FIFO occupancy count |

---
### `UART_RX_COUNT` — Address `0x0104`

**Reset value:** `0x0000`  **Access:** see fields below

Number of bytes currently in the RX FIFO.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `COUNT` | `[7:0]` | R | `0x00` | RX FIFO occupancy count |

---
### `ETH_MAC_LOW` — Address `0x0110`

**Reset value:** `0x0000`  **Access:** see fields below

Lower 16 bits of the Ethernet MAC address (OUI + NIC portion).

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAC[15:0]` | `[15:0]` | R | `0x0000` | MAC address lower 16 bits |

---
### `ETH_MAC_HIGH` — Address `0x0111`

**Reset value:** `0x0000`  **Access:** see fields below

Upper 16 bits of the Ethernet MAC address.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAC[31:16]` | `[15:0]` | R | `0x0000` | MAC address upper 16 bits |

---
### `SPI_CTRL` — Address `0x0120`

**Reset value:** `0x0000`  **Access:** see fields below

SPI master controller configuration for EEPROM and Flash interface.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `CPOL` | `[0]` | RW | `0x0` | Clock polarity (0=idle low) |
| `CPHA` | `[1]` | RW | `0x0` | Clock phase (0=leading edge sample) |
| `CS_POL` | `[2]` | RW | `0x1` | Chip select polarity (1=active low) |
| `CLK_DIV` | `[7:4]` | RW | `0x4` | SPI clock divider ratio (default /16) |

---
### `SPI_STATUS` — Address `0x0121`

**Reset value:** `0x0001`  **Access:** see fields below

SPI controller operational status.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READY` | `[0]` | R | `0x1` | SPI controller ready |
| `BUSY` | `[1]` | R | `0x0` | Transfer in progress |
| `FAULT` | `[2]` | RC | `0x0` | SPI bus fault detected |

---
### `I2C_CTRL` — Address `0x0130`

**Reset value:** `0x0000`  **Access:** see fields below

I2C master controller configuration for temperature sensor and power monitor IC access.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0x0` | I2C master enable |
| `SPEED` | `[2:1]` | RW | `0x0` | Speed: 0=100kHz, 1=400kHz, 2=1MHz |
| `START` | `[3]` | RW | `0x0` | Generate START condition (auto-clear) |
| `STOP` | `[4]` | RW | `0x0` | Generate STOP condition (auto-clear) |

---
### `I2C_STATUS` — Address `0x0131`

**Reset value:** `0x0000`  **Access:** see fields below

I2C controller operational status.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BUSY` | `[0]` | R | `0x0` | I2C bus busy |
| `ACK` | `[1]` | R | `0x0` | Last byte ACKed by slave |
| `ARB_LOST` | `[2]` | RC | `0x0` | Arbitration lost |

---
### `ADC_CTRL` — Address `0x0200`

**Reset value:** `0x0000`  **Access:** see fields below

ADC control for supply voltage and current monitoring.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `START` | `[0]` | RW | `0x0` | Start single conversion (auto-clears) |
| `CONTINUOUS` | `[1]` | RW | `0x0` | Continuous conversion mode enable |
| `CH_SEL` | `[3:2]` | RW | `0x0` | Channel select: 0=VCC_5V, 1=VCC_3V3, 2=VCC_1V8, 3=VCC_1V0 |

---
### `ADC_STATUS` — Address `0x0201`

**Reset value:** `0x0000`  **Access:** see fields below

ADC conversion status flags.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA_READY` | `[0]` | RC | `0x0` | New conversion data available |
| `OVERRANGE` | `[1]` | RC | `0x0` | ADC input exceeded full-scale range |

---
### `VCC_5V_RAW` — Address `0x0210`

**Reset value:** `0x0000`  **Access:** see fields below

5V supply rail ADC conversion result. Voltage = RAW × 5.0 / 4096.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `RAW` | `[11:0]` | R | `0x000` | 12-bit ADC count for 5V rail |

---
### `VCC_3V3_RAW` — Address `0x0211`

**Reset value:** `0x0000`  **Access:** see fields below

3.3V supply rail ADC conversion result. Voltage = RAW × 3.3 / 4096.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `RAW` | `[11:0]` | R | `0x000` | 12-bit ADC count for 3.3V rail |

---
### `VCC_1V8_RAW` — Address `0x0212`

**Reset value:** `0x0000`  **Access:** see fields below

1.8V FPGA I/O supply rail ADC conversion result. Voltage = RAW × 1.8 / 4096.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `RAW` | `[11:0]` | R | `0x000` | 12-bit ADC count for 1.8V rail |

---
### `VCC_1V0_RAW` — Address `0x0213`

**Reset value:** `0x0000`  **Access:** see fields below

1.0V FPGA core supply rail ADC conversion result. Voltage = RAW × 1.0 / 4096.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `RAW` | `[11:0]` | R | `0x000` | 12-bit ADC count for 1.0V core rail |

---
### `ICC_5V_RAW` — Address `0x0218`

**Reset value:** `0x0000`  **Access:** see fields below

5V rail current-sense ADC result.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `RAW` | `[11:0]` | R | `0x000` | 12-bit ADC count for 5V current |

---
### `ICC_3V3_RAW` — Address `0x0219`

**Reset value:** `0x0000`  **Access:** see fields below

3.3V rail current-sense ADC result.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `RAW` | `[11:0]` | R | `0x000` | 12-bit ADC count for 3.3V current |

---
### `TEMP_LOCAL` — Address `0x0300`

**Reset value:** `0x0000`  **Access:** see fields below

Local FPGA die temperature from internal XADC sensor. Signed value in 0.25°C units. Temp(°C) = VALUE × 0.25.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP` | `[9:0]` | R | `0x000` | Signed 10-bit die temperature (0.25°C/LSB) |

---
### `TEMP_REMOTE1` — Address `0x0301`

**Reset value:** `0x0000`  **Access:** see fields below

Remote I2C temperature sensor 1 reading (PCB hotspot near LNAs).

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP` | `[9:0]` | R | `0x000` | Signed 10-bit remote temperature (0.25°C/LSB) |

---
### `TEMP_REMOTE2` — Address `0x0302`

**Reset value:** `0x0000`  **Access:** see fields below

Remote I2C temperature sensor 2 reading (PCB area near power converter).

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP` | `[9:0]` | R | `0x000` | Signed 10-bit remote temperature (0.25°C/LSB) |

---
### `TEMP_ALERT_HIGH` — Address `0x0308`

**Reset value:** `0x0190`  **Access:** see fields below

Over-temperature alert threshold. If TEMP_LOCAL exceeds this, the ALERT flag in HEALTH_STATUS is asserted.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `THRESH` | `[9:0]` | RW | `0x190` | High threshold = 100°C (400 × 0.25) |

---
### `TEMP_ALERT_LOW` — Address `0x0309`

**Reset value:** `0xFF9C`  **Access:** see fields below

Under-temperature alert threshold for cold-start detection.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `THRESH` | `[9:0]` | RW | `0x19C` | Low threshold = -25°C (signed, 2s complement) |

---
### `HEALTH_STATUS` — Address `0x030F`

**Reset value:** `0x0000`  **Access:** see fields below

Aggregate system health flags. SYSTEM_OK is the logical AND of all individual OK flags.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_OK` | `[0]` | R | `0x0` | All temperatures within limits |
| `VOLT_OK` | `[1]` | R | `0x0` | All supply voltages within tolerance |
| `PLL_LOCK` | `[2]` | R | `0x0` | System PLL locked |
| `RF_OK` | `[3]` | R | `0x0` | RF chain bias currents nominal |
| `FLASH_OK` | `[4]` | R | `0x0` | Flash interface ready |
| `EEPROM_OK` | `[5]` | R | `0x0` | EEPROM interface ready |
| `CAL_VALID` | `[6]` | R | `0x0` | Calibration data CRC valid |
| `SYSTEM_OK` | `[7]` | R | `0x0` | All health flags pass |

---
### `PLL_CTRL` — Address `0x0400`

**Reset value:** `0x0000`  **Access:** see fields below

System PLL control for generating reference clocks to RF chain and FPGA logic.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0x0` | PLL enable (1=active) |
| `RESET` | `[1]` | RW | `0x0` | PLL reset (active-high, self-clearing) |
| `REF_SEL` | `[3:2]` | RW | `0x0` | Reference clock source: 0=internal XO, 1=ext ref, 2=backup |

---
### `PLL_STATUS` — Address `0x0401`

**Reset value:** `0x0000`  **Access:** see fields below

PLL lock and fault status.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LOCKED` | `[0]` | R | `0x0` | PLL is locked to reference |
| `LOSS_OF_LOCK` | `[1]` | RC | `0x0` | Lock has been lost since last read |
| `CAL_DONE` | `[2]` | R | `0x0` | PLL calibration complete |

---
### `PLL_N_DIV` — Address `0x0402`

**Reset value:** `0x0010`  **Access:** see fields below

PLL N feedback divider value for VCO frequency configuration.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `N_DIV` | `[15:0]` | RW | `0x0010` | N divider (default 16) |

---
### `PLL_R_DIV` — Address `0x0403`

**Reset value:** `0x0004`  **Access:** see fields below

PLL R reference divider value.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `R_DIV` | `[7:0]` | RW | `0x04` | R divider (default 4) |

---
### `CLK_ENABLE` — Address `0x0410`

**Reset value:** `0x0000`  **Access:** see fields below

Individual clock output enables. Each bit gates one differential clock pair to a destination block.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `CLK_OUT0_EN` | `[0]` | RW | `0x0` | Enable clock output 0 (FPGA logic) |
| `CLK_OUT1_EN` | `[1]` | RW | `0x0` | Enable clock output 1 (ADC sample) |
| `CLK_OUT2_EN` | `[2]` | RW | `0x0` | Enable clock output 2 (SPI reference) |
| `CLK_OUT3_EN` | `[3]` | RW | `0x0` | Enable clock output 3 (reserved) |

---
### `EEPROM_CTRL` — Address `0x0500`

**Reset value:** `0x0000`  **Access:** see fields below

EEPROM interface control. Write operations require unlock key in EEPROM_UNLOCK first.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READ` | `[0]` | RW | `0x0` | Trigger read (auto-clears) |
| `WRITE` | `[1]` | RW | `0x0` | Trigger write (auto-clears, requires unlock) |
| `ERASE` | `[2]` | RW | `0x0` | Trigger sector erase (requires unlock) |
| `BUSY` | `[7]` | R | `0x0` | EEPROM operation in progress |

---
### `EEPROM_ADDR` — Address `0x0501`

**Reset value:** `0x0000`  **Access:** see fields below

EEPROM byte address for next read/write/erase operation.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADDR` | `[15:0]` | RW | `0x0000` | 16-bit EEPROM address pointer |

---
### `EEPROM_DATA` — Address `0x0502`

**Reset value:** `0x0000`  **Access:** see fields below

EEPROM read/write data register. Write data before triggering WRITE; read data after READ completes.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA` | `[15:0]` | RW | `0x0000` | EEPROM data word |

---
### `EEPROM_UNLOCK` — Address `0x0503`

**Reset value:** `0x0000`  **Access:** see fields below

Unlock key register for EEPROM write/erase protection. Write 0xA1B2 to enable writes for one operation cycle.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `KEY` | `[15:0]` | W | `0x0000` | Write 0xA1B2 to unlock; reads return 0x0000 |

---
### `FLASH_CTRL` — Address `0x0600`

**Reset value:** `0x0000`  **Access:** see fields below

Configuration Flash interface control. Erase requires unlock key.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READ` | `[0]` | RW | `0x0` | Trigger read (auto-clears) |
| `WRITE` | `[1]` | RW | `0x0` | Trigger page write (requires unlock) |
| `ERASE_SECTOR` | `[2]` | RW | `0x0` | Erase current sector (requires unlock) |
| `ERASE_CHIP` | `[3]` | RW | `0x0` | Full chip erase (requires unlock + confirmation) |
| `BUSY` | `[7]` | R | `0x0` | Flash operation in progress |

---
### `FLASH_ADDR_LOW` — Address `0x0601`

**Reset value:** `0x0000`  **Access:** see fields below

Flash address lower 16 bits.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADDR[15:0]` | `[15:0]` | RW | `0x0000` | Flash address lower word |

---
### `FLASH_ADDR_HIGH` — Address `0x0602`

**Reset value:** `0x0000`  **Access:** see fields below

Flash address upper 8 bits (for >64KB addressable Flash).

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADDR[23:16]` | `[7:0]` | RW | `0x00` | Flash address upper byte |

---
### `FLASH_DATA` — Address `0x0603`

**Reset value:** `0x0000`  **Access:** see fields below

Flash read/write data FIFO. Writes push to TX FIFO; reads pop from RX FIFO.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA` | `[15:0]` | RW | `0x0000` | Flash data word |

---
### `FLASH_STATUS` — Address `0x0604`

**Reset value:** `0x0001`  **Access:** see fields below

Flash interface status flags.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READY` | `[0]` | R | `0x1` | Flash controller idle and ready |
| `WRITE_ERR` | `[1]` | RC | `0x0` | Page write error |
| `ERASE_ERR` | `[2]` | RC | `0x0` | Erase error |
| `ID_VALID` | `[3]` | R | `0x0` | Flash ID read and verified |

---
### `GPIO_CTRL` — Address `0x0800`

**Reset value:** `0x0000`  **Access:** see fields below

General-purpose I/O direction and value control for board-level signals.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GPIO0_OUT` | `[0]` | RW | `0x0` | GPIO pin 0 output value |
| `GPIO1_OUT` | `[1]` | RW | `0x0` | GPIO pin 1 output value |
| `GPIO2_OUT` | `[2]` | RW | `0x0` | GPIO pin 2 output value |
| `GPIO3_OUT` | `[3]` | RW | `0x0` | GPIO pin 3 output value |
| `GPIO0_OE` | `[4]` | RW | `0x0` | GPIO0 output enable (1=output) |
| `GPIO1_OE` | `[5]` | RW | `0x0` | GPIO1 output enable |
| `GPIO2_OE` | `[6]` | RW | `0x0` | GPIO2 output enable |
| `GPIO3_OE` | `[7]` | RW | `0x0` | GPIO3 output enable |

---
### `GPIO_INPUT` — Address `0x0801`

**Reset value:** `0x0000`  **Access:** see fields below

GPIO pin input readback values.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GPIO0_IN` | `[0]` | R | `0x0` | GPIO pin 0 input value |
| `GPIO1_IN` | `[1]` | R | `0x0` | GPIO pin 1 input value |
| `GPIO2_IN` | `[2]` | R | `0x0` | GPIO pin 2 input value |
| `GPIO3_IN` | `[3]` | R | `0x0` | GPIO pin 3 input value |

---
### `TR_SWITCH_CTRL` — Address `0x0802`

**Reset value:** `0x0000`  **Access:** see fields below

T/R (Transmit/Receive) SPDT switch control per channel (QPC2420SR). Controls front-end isolation during TX pulses.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `CH1_TR` | `[0]` | RW | `0x0` | Channel 1 T/R switch: 0=RX path, 1=TX protect |
| `CH2_TR` | `[1]` | RW | `0x0` | Channel 2 T/R switch |
| `CH3_TR` | `[2]` | RW | `0x0` | Channel 3 T/R switch |
| `CH4_TR` | `[3]` | RW | `0x0` | Channel 4 T/R switch |
| `ALL_TR` | `[4]` | RW | `0x0` | Broadcast: set all 4 channels simultaneously (overrides individual) |

---
### `LNA_BIAS_CTRL` — Address `0x0803`

**Reset value:** `0x0000`  **Access:** see fields below

LNA (PMA4-6263LN+) bias enable and gate control per channel. Active-high enables the drain voltage supply to each LNA pair.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `CH1_LNA_EN` | `[0]` | RW | `0x0` | Channel 1 balanced LNA bias enable |
| `CH2_LNA_EN` | `[1]` | RW | `0x0` | Channel 2 balanced LNA bias enable |
| `CH3_LNA_EN` | `[2]` | RW | `0x0` | Channel 3 balanced LNA bias enable |
| `CH4_LNA_EN` | `[3]` | RW | `0x0` | Channel 4 balanced LNA bias enable |
| `ALL_LNA_EN` | `[4]` | RW | `0x0` | Broadcast: enable all 4 LNAs simultaneously |

---
### `GAIN_AMP_CTRL` — Address `0x0804`

**Reset value:** `0x0000`  **Access:** see fields below

Gain block / driver amplifier (PMA3-15453+) enable per channel. Controls stages 2 and 3 after the balanced LNA.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `CH1_AMP_EN` | `[0]` | RW | `0x0` | Channel 1 gain block enable |
| `CH2_AMP_EN` | `[1]` | RW | `0x0` | Channel 2 gain block enable |
| `CH3_AMP_EN` | `[2]` | RW | `0x0` | Channel 3 gain block enable |
| `CH4_AMP_EN` | `[3]` | RW | `0x0` | Channel 4 gain block enable |
| `ALL_AMP_EN` | `[4]` | RW | `0x0` | Broadcast: enable all 4 gain blocks simultaneously |

---
### `LIMITER_STATUS` — Address `0x0805`

**Reset value:** `0x0000`  **Access:** see fields below

PIN diode limiter (CLA4611-085LF) fault status per channel. Indicates if the front-end limiter has clamped due to overdrive.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `CH1_LIM_FAULT` | `[0]` | RC | `0x0` | Channel 1 limiter activated/fault |
| `CH2_LIM_FAULT` | `[1]` | RC | `0x0` | Channel 2 limiter fault |
| `CH3_LIM_FAULT` | `[2]` | RC | `0x0` | Channel 3 limiter fault |
| `CH4_LIM_FAULT` | `[3]` | RC | `0x0` | Channel 4 limiter fault |
| `ANY_FAULT` | `[7]` | R | `0x0` | OR of all channel limiter faults |

---
### `MONOPULSE_CTRL` — Address `0x0806`

**Reset value:** `0x0000`  **Access:** see fields below

Monopulse comparator network (SCA-4-132+) output path selection. Selects which of the 4 comparator outputs (Sum, Delta-AZ, Delta-EL, Delta-DE) is routed to the IF output.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `PATH_SEL` | `[1:0]` | RW | `0x0` | Output path: 0=Sum(Σ), 1=Δ-Az, 2=Δ-El, 3=Δ-DE |
| `ALL_ENABLE` | `[2]` | RW | `0x0` | Enable all 4 comparator outputs simultaneously |
| `SWITCH_SPEED` | `[4:3]` | RW | `0x0` | Monopulse switch transition speed: 0=standard, 1=fast |

---
### `BPF_TUNING` — Address `0x0807`

**Reset value:** `0x0008`  **Access:** see fields below

Ceramic preselector bandpass filter (BFCN-1840+) center frequency tuning control.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TUNE_CODE` | `[7:0]` | RW | `0x08` | BPF tuning DAC code (0x00–0xFF, center = 0x80) |
| `BYPASS` | `[8]` | RW | `0x0` | Bypass preselector BPF (for test/debug) |

---
### `DAC_CTRL` — Address `0x0900`

**Reset value:** `0x0000`  **Access:** see fields below

DAC control for analog tuning and bias voltage outputs.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DAC_EN` | `[0]` | RW | `0x0` | Global DAC enable |
| `LOAD` | `[1]` | RW | `0x0` | Trigger DAC update (auto-clears) |
| `CHANNEL` | `[4:2]` | RW | `0x0` | DAC channel select (0–5) |

---
### `DAC_DATA` — Address `0x0901`

**Reset value:** `0x0800`  **Access:** see fields below

DAC output data register for the channel selected in DAC_CTRL.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA` | `[11:0]` | RW | `0x800` | 12-bit DAC code (mid-scale default) |

---
### `DAC_STATUS` — Address `0x0902`

**Reset value:** `0x0001`  **Access:** see fields below

DAC output status and fault flags.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READY` | `[0]` | R | `0x1` | DAC ready for new data |
| `OVERRANGE` | `[1]` | RC | `0x0` | DAC output exceeded compliance range |

---
### `RF_POWER_MONITOR` — Address `0x0903`

**Reset value:** `0x0000`  **Access:** see fields below

RF power detector reading for overall output power monitoring.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `POWER_RAW` | `[11:0]` | R | `0x000` | 12-bit RF power detector ADC count |

---
### `INTERRUPT_STATUS` — Address `0x0310`

**Reset value:** `0x0000`  **Access:** see fields below

Active interrupt flags. Each bit represents a pending interrupt source. Read-cleared.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_ALERT` | `[0]` | RC | `0x0` | Temperature alert interrupt |
| `VOLT_ALERT` | `[1]` | RC | `0x0` | Voltage out-of-tolerance interrupt |
| `PLL_UNLOCK` | `[2]` | RC | `0x0` | PLL loss-of-lock interrupt |
| `LIM_FAULT` | `[3]` | RC | `0x0` | Limiter fault interrupt |
| `UART_ERR` | `[4]` | RC | `0x0` | UART error interrupt |
| `FLASH_ERR` | `[5]` | RC | `0x0` | Flash operation error interrupt |

---
### `INTERRUPT_MASK` — Address `0x0311`

**Reset value:** `0x0000`  **Access:** see fields below

Interrupt enable mask. Setting a bit to 1 enables the corresponding interrupt source.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_ALERT_EN` | `[0]` | RW | `0x0` | Enable temperature alert interrupt |
| `VOLT_ALERT_EN` | `[1]` | RW | `0x0` | Enable voltage alert interrupt |
| `PLL_UNLOCK_EN` | `[2]` | RW | `0x0` | Enable PLL unlock interrupt |
| `LIM_FAULT_EN` | `[3]` | RW | `0x0` | Enable limiter fault interrupt |
| `UART_ERR_EN` | `[4]` | RW | `0x0` | Enable UART error interrupt |
| `FLASH_ERR_EN` | `[5]` | RW | `0x0` | Enable Flash error interrupt |

---
### `SYSTEM_CTRL` — Address `0x001F`

**Reset value:** `0x0000`  **Access:** see fields below

Global system control register for FPGA-wide resets and operational mode.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `SOFT_RESET` | `[0]` | RW | `0x0` | Soft reset pulse (auto-clears after 1 cycle) |
| `OPERATIONAL_MODE` | `[3:1]` | RW | `0x0` | Mode: 0=INIT, 1=STANDBY, 2=RX_ACTIVE, 3=TEST, 4=CALIBRATION |
| `WATCHDOG_EN` | `[4]` | RW | `0x0` | Enable watchdog timer (requires periodic kick) |
| `SAFE_STATE` | `[7]` | RW | `0x0` | Force all RF chains to safe/protected state |
