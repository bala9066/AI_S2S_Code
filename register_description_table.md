# Register Description Table (RDT)
## iguyc

> **Total registers:** 59

iguyc Wideband RF Receiver - Complete register map for XCZU9EG-FFVB1156 FPGA controlling RF front-end (LNA/Mixer/VGA), ADF5355 LO synthesizer, ADC12DJ3200 JESD204B interface, ADP5054/LTM4644 power management, and system health monitoring. 30 registers across 10 functional groups (0x000-0x900).

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
| `0x0000` | `BOARD_ID` | — | `0x4947` | Board identification code (ASCII 'IG') - unique identifier for iguyc receiver board |
| `0x0001` | `BOARD_VERSION` | — | `0x10` | Hardware version number - major.minor format |
| `0x0002` | `BOARD_TYPE_ID` | — | `0x5752` | Board type identifier - indicates RF receiver configuration |
| `0x0003` | `SCRATCHPAD` | — | `0x0000` | General-purpose read/write test register for RAM verification |
| `0x0010` | `MCS_VERSION_MAJOR` | — | `0x01` | FPGA firmware major version number |
| `0x0011` | `MCS_VERSION_MINOR` | — | `0x00` | FPGA firmware minor version number |
| `0x0012` | `BUILD_DATE` | — | `0x20260415` | FPGA bitstream build date in packed BCD format (YYYYMMDD) |
| `0x0100` | `UART_BAUD_DIV` | — | `0x0082` | UART baud rate divisor for 115200 baud @ 100MHz UART_CLK (100MHz/115200 = 868 = 0x364, divisor/2 = 0x182) |
| `0x0101` | `UART_CTRL` | — | `0x00` | UART control register for configuration and loopback mode |
| `0x0102` | `UART_STATUS` | — | `0x00` | UART status flags - read clears sticky bits |
| `0x0103` | `UART_TX_COUNT` | — | `0x00` | TX FIFO fill level indicator |
| `0x0104` | `UART_RX_COUNT` | — | `0x00` | RX FIFO fill level indicator |
| `0x0108` | `SPI_PLL_CTRL` | — | `0x00` | SPI interface control for ADF5355 LO synthesizer |
| `0x0109` | `SPI_PLL_TX_DATA` | — | `0x0000` | 32-bit data to transmit to ADF5355 (written in two 16-bit transfers) |
| `0x010A` | `SPI_PLL_RX_DATA` | — | `0x0000` | 32-bit data received from ADF5355 MISO pin |
| `0x010B` | `I2C_CTRL` | — | `0x00` | I2C interface control for ADC12DJ3200 and ADP5054 PMIC |
| `0x010C` | `I2C_SLAVE_ADDR` | — | `0x48` | I2C slave address for current transaction (7-bit address) |
| `0x010D` | `I2C_TX_DATA` | — | `0x00` | I2C transmit data byte |
| `0x010E` | `I2C_RX_DATA` | — | `0x00` | I2C received data byte from slave |
| `0x0210` | `VCC_5V_RF_RAW` | — | `0x0800` | +5V_RF rail ADC raw count from LTM4644 monitor |
| `0x0211` | `VCC_1V2_ADC_RAW` | — | `0x0660` | +1.2V_ADC rail ADC raw count - ADC12DJ3200 supply |
| `0x0212` | `VCC_0V85_INT_RAW` | — | `0x04B0` | +0.85V VCCINT rail ADC raw count - FPGA core supply |
| `0x0213` | `VCC_1V8_AUX_RAW` | — | `0x0900` | +1.8V VCCAUX rail ADC raw count - FPGA auxiliary supply |
| `0x0218` | `ICC_5V_RF_RAW` | — | `0x0200` | +5V_RF rail current sense ADC raw count |
| `0x0220` | `ADC_CTRL` | — | `0x00` | ADC monitoring control - multiplexer channel select and start |
| `0x0221` | `ADC_STATUS` | — | `0x00` | ADC monitoring status flags |
| `0x0300` | `TEMP_LOCAL` | — | `0x0140` | FPGA die temperature in 0.25°C units (signed) |
| `0x0301` | `TEMP_RF_FRONTEND` | — | `0x00C8` | RF front-end temperature sensor reading |
| `0x0302` | `TEMP_LO_SYNTH` | — | `0x0096` | ADF5355 LO synthesizer temperature sensor reading |
| `0x0308` | `TEMP_ALERT_HIGH` | — | `0x0190` | Over-temperature alert threshold (100°C default) |
| `0x0309` | `TEMP_ALERT_LOW` | — | `0xFF9C` | Under-temperature alert threshold (-25°C default) |
| `0x030F` | `HEALTH_STATUS` | — | `0x07` | System health status flags |
| `0x0400` | `PLL_LO_CTRL` | — | `0x00` | ADF5355 LO synthesizer control register |
| `0x0401` | `PLL_LO_STATUS` | — | `0x00` | ADF5355 LO synthesizer status flags |
| `0x0402` | `PLL_INT_DIV` | — | `0x0064` | PLL integer N divider value (default 100) |
| `0x0403` | `PLL_FRAC_DIV` | — | `0x0000` | PLL fractional divider value |
| `0x0404` | `PLL_REF_DIV` | — | `0x0001` | PLL reference R divider |
| `0x0410` | `CLK_ENABLE` | — | `0x0F` | Clock output enable mask |
| `0x0500` | `JESD_CTRL` | — | `0x00` | JESD204B interface control for ADC12DJ3200 |
| `0x0501` | `JESD_STATUS` | — | `0x00` | JESD204B link status flags |
| `0x0502` | `JESD_SCR_L` | — | `0x00` | JESD204B scrambling register low byte |
| `0x0503` | `JESD_SCR_H` | — | `0x01` | JESD204B scrambling register high byte |
| `0x0600` | `VGA_GAIN_CTRL` | — | `0x8000` | HMC698LP4 VGA gain control (parallel 6-bit interface) |
| `0x0601` | `VGA_STATUS` | — | `0x01` | VGA status and AGC state |
| `0x0608` | `LNA_CTRL` | — | `0x01` | HMC6987LP4E LNA control |
| `0x0609` | `MIXER_CTRL` | — | `0x01` | HMC1194LP4E mixer control |
| `0x0700` | `RF_RX_CTRL` | — | `0x00` | RF receiver chain master control |
| `0x0701` | `RF_FREQ_TARGET_L` | — | `0x0000` | Target RF frequency low word (Hz) |
| `0x0702` | `RF_FREQ_TARGET_H` | — | `0x0001` | Target RF frequency high word (Hz * 65536) |
| `0x0703` | `RF_IF_FREQ` | — | `0x01F4` | IF frequency setting (default 500MHz = 0x01F4) |
| `0x0704` | `RF_STATUS` | — | `0x00` | RF receiver status flags |
| `0x0800` | `EEPROM_CTRL` | — | `0x00` | Configuration EEPROM control |
| `0x0801` | `EEPROM_ADDR` | — | `0x0000` | EEPROM byte address |
| `0x0802` | `EEPROM_DATA` | — | `0x0000` | EEPROM read/write data |
| `0x0900` | `FLASH_CTRL` | — | `0x00` | Quad-SPI Flash control for FPGA bitstream |
| `0x0901` | `FLASH_ADDR_L` | — | `0x0000` | Flash address low word |
| `0x0902` | `FLASH_ADDR_H` | — | `0x0000` | Flash address high byte |
| `0x0903` | `FLASH_DATA` | — | `0x0000` | Flash data FIFO |
| `0x0904` | `FLASH_STATUS` | — | `0x01` | Flash interface status |

---
### `BOARD_ID` — Address `0x0000`

**Reset value:** `0x4947`  **Access:** see fields below

Board identification code (ASCII 'IG') - unique identifier for iguyc receiver board

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BOARD_ID` | `[15:0]` | R | `0x4947` | Fixed board identifier 0x4947 = 'IG' |

---
### `BOARD_VERSION` — Address `0x0001`

**Reset value:** `0x10`  **Access:** see fields below

Hardware version number - major.minor format

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAJOR_VERSION` | `[7:4]` | R | `0x1` | Major version number (0-15) |
| `MINOR_VERSION` | `[3:0]` | R | `0x0` | Minor version number (0-15) |

---
### `BOARD_TYPE_ID` — Address `0x0002`

**Reset value:** `0x5752`  **Access:** see fields below

Board type identifier - indicates RF receiver configuration

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BOARD_TYPE` | `[15:0]` | R | `0x5752` | Type identifier 0x5752 = 'WR' (Wideband Receiver) |

---
### `SCRATCHPAD` — Address `0x0003`

**Reset value:** `0x0000`  **Access:** see fields below

General-purpose read/write test register for RAM verification

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEST_DATA` | `[15:0]` | RW | `0x0000` | Test pattern storage - write/read-back verification |

---
### `MCS_VERSION_MAJOR` — Address `0x0010`

**Reset value:** `0x01`  **Access:** see fields below

FPGA firmware major version number

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `FW_MAJOR` | `[7:0]` | R | `0x01` | Firmware major version (current: 1) |

---
### `MCS_VERSION_MINOR` — Address `0x0011`

**Reset value:** `0x00`  **Access:** see fields below

FPGA firmware minor version number

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `FW_MINOR` | `[7:0]` | R | `0x00` | Firmware minor version (current: 0) |

---
### `BUILD_DATE` — Address `0x0012`

**Reset value:** `0x20260415`  **Access:** see fields below

FPGA bitstream build date in packed BCD format (YYYYMMDD)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `YEAR` | `[15:12]` | R | `0x2` | Build year (BCD encoded) |
| `MONTH` | `[11:8]` | R | `0x4` | Build month (BCD encoded) |
| `DAY` | `[7:0]` | R | `0x15` | Build day (BCD encoded) |

---
### `UART_BAUD_DIV` — Address `0x0100`

**Reset value:** `0x0082`  **Access:** see fields below

UART baud rate divisor for 115200 baud @ 100MHz UART_CLK (100MHz/115200 = 868 = 0x364, divisor/2 = 0x182)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BAUD_DIVISOR` | `[15:0]` | RW | `0x0082` | Baud rate divisor (UART_CLK / (16 * baud_rate)) |

---
### `UART_CTRL` — Address `0x0101`

**Reset value:** `0x00`  **Access:** see fields below

UART control register for configuration and loopback mode

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0x0` | UART enable (1=enabled, 0=disabled) |
| `LOOPBACK` | `[1]` | RW | `0x0` | Loopback mode for testing (1=loop TX to RX) |
| `FRAME_FORMAT` | `[7:4]` | RW | `0x0` | Frame format settings (parity, stop bits) |

---
### `UART_STATUS` — Address `0x0102`

**Reset value:** `0x00`  **Access:** see fields below

UART status flags - read clears sticky bits

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TX_BUSY` | `[0]` | R | `0x0` | Transmitter busy flag (1=transmitting) |
| `RX_AVAIL` | `[1]` | R | `0x0` | Data available in RX FIFO (1=available) |
| `FRAME_ERR` | `[2]` | RC | `0x0` | Frame error detected (clear on read) |
| `OVERRUN_ERR` | `[3]` | RC | `0x0` | RX FIFO overrun (clear on read) |

---
### `UART_TX_COUNT` — Address `0x0103`

**Reset value:** `0x00`  **Access:** see fields below

TX FIFO fill level indicator

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TX_FIFO_LEVEL` | `[7:0]` | R | `0x00` | Number of bytes in TX FIFO (0-16) |

---
### `UART_RX_COUNT` — Address `0x0104`

**Reset value:** `0x00`  **Access:** see fields below

RX FIFO fill level indicator

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `RX_FIFO_LEVEL` | `[7:0]` | R | `0x00` | Number of bytes in RX FIFO (0-16) |

---
### `SPI_PLL_CTRL` — Address `0x0108`

**Reset value:** `0x00`  **Access:** see fields below

SPI interface control for ADF5355 LO synthesizer

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `SPI_EN` | `[0]` | RW | `0x0` | SPI interface enable (1=enabled) |
| `CS_ASSERT` | `[1]` | RW | `0x0` | Chip select assert state (1=asserted low) |
| `CLK_DIV` | `[7:4]` | RW | `0x3` | SPI clock divider (0=div2, 1=div4, 2=div8, 3=div16) |

---
### `SPI_PLL_TX_DATA` — Address `0x0109`

**Reset value:** `0x0000`  **Access:** see fields below

32-bit data to transmit to ADF5355 (written in two 16-bit transfers)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA_LOW` | `[15:0]` | W | `0x0000` | Lower 16 bits of 32-bit SPI word |
| `DATA_HIGH` | `[31:16]` | W | `0x0000` | Upper 16 bits of 32-bit SPI word (next write) |

---
### `SPI_PLL_RX_DATA` — Address `0x010A`

**Reset value:** `0x0000`  **Access:** see fields below

32-bit data received from ADF5355 MISO pin

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA_LOW` | `[15:0]` | R | `0x0000` | Lower 16 bits of received SPI word |
| `DATA_HIGH` | `[31:16]` | R | `0x0000` | Upper 16 bits of received SPI word |

---
### `I2C_CTRL` — Address `0x010B`

**Reset value:** `0x00`  **Access:** see fields below

I2C interface control for ADC12DJ3200 and ADP5054 PMIC

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `I2C_EN` | `[0]` | RW | `0x0` | I2C interface enable (1=enabled) |
| `CLK_400KHZ` | `[1]` | RW | `0x1` | Speed select (0=100kHz, 1=400kHz) |
| `ARB_EN` | `[2]` | RW | `0x1` | Arbitration enable for multi-master |

---
### `I2C_SLAVE_ADDR` — Address `0x010C`

**Reset value:** `0x48`  **Access:** see fields below

I2C slave address for current transaction (7-bit address)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `SLAVE_ADDR` | `[6:0]` | RW | `0x48` | 7-bit I2C slave address (default: ADC12DJ3200) |

---
### `I2C_TX_DATA` — Address `0x010D`

**Reset value:** `0x00`  **Access:** see fields below

I2C transmit data byte

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TX_BYTE` | `[7:0]` | W | `0x00` | Byte to transmit over I2C |
| `RW_BIT` | `[8]` | W | `0x0` | R/W# bit (0=write, 1=read) |

---
### `I2C_RX_DATA` — Address `0x010E`

**Reset value:** `0x00`  **Access:** see fields below

I2C received data byte from slave

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `RX_BYTE` | `[7:0]` | R | `0x00` | Byte received from I2C slave |
| `ACK_RECEIVED` | `[8]` | R | `0x0` | ACK from slave (1=ACK, 0=NACK) |

---
### `VCC_5V_RF_RAW` — Address `0x0210`

**Reset value:** `0x0800`  **Access:** see fields below

+5V_RF rail ADC raw count from LTM4644 monitor

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | R | `0x0800` | 12-bit ADC count (multiply by 5.0/4096 for Volts) |
| `VALID` | `[15]` | R | `0x1` | Data valid flag (1=valid reading) |

---
### `VCC_1V2_ADC_RAW` — Address `0x0211`

**Reset value:** `0x0660`  **Access:** see fields below

+1.2V_ADC rail ADC raw count - ADC12DJ3200 supply

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | R | `0x0660` | 12-bit ADC count (multiply by 1.2/4096 for Volts) |

---
### `VCC_0V85_INT_RAW` — Address `0x0212`

**Reset value:** `0x04B0`  **Access:** see fields below

+0.85V VCCINT rail ADC raw count - FPGA core supply

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | R | `0x04B0` | 12-bit ADC count (multiply by 0.85/4096 for Volts) |

---
### `VCC_1V8_AUX_RAW` — Address `0x0213`

**Reset value:** `0x0900`  **Access:** see fields below

+1.8V VCCAUX rail ADC raw count - FPGA auxiliary supply

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | R | `0x0900` | 12-bit ADC count (multiply by 1.8/4096 for Volts) |

---
### `ICC_5V_RF_RAW` — Address `0x0218`

**Reset value:** `0x0200`  **Access:** see fields below

+5V_RF rail current sense ADC raw count

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | R | `0x0200` | Current sense ADC count (scale factor per sense resistor) |

---
### `ADC_CTRL` — Address `0x0220`

**Reset value:** `0x00`  **Access:** see fields below

ADC monitoring control - multiplexer channel select and start

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_START` | `[0]` | RW | `0x0` | Start ADC conversion (self-clearing) |
| `ADC_CONTINUOUS` | `[1]` | RW | `0x0` | Continuous mode enable (1=auto-scan) |
| `CHANNEL_SELECT` | `[5:2]` | RW | `0x0` | Channel select (0=5V_RF, 1=1V2_ADC, 2=0V85_INT, 3=1V8_AUX) |

---
### `ADC_STATUS` — Address `0x0221`

**Reset value:** `0x00`  **Access:** see fields below

ADC monitoring status flags

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA_READY` | `[0]` | R | `0x0` | New data available flag (1=ready) |
| `OVERRANGE` | `[1]` | RC | `0x0` | Overrange detected (clear on read) |
| `CONVERTING` | `[2]` | R | `0x0` | Conversion in progress (1=busy) |

---
### `TEMP_LOCAL` — Address `0x0300`

**Reset value:** `0x0140`  **Access:** see fields below

FPGA die temperature in 0.25°C units (signed)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_VALUE` | `[9:0]` | R | `0x0140` | Temperature in 0.25°C steps (0x0140 = 80°C = 320 * 0.25) |
| `SIGN_BIT` | `[9]` | R | `0x0` | Sign bit (1=negative temperature) |

---
### `TEMP_RF_FRONTEND` — Address `0x0301`

**Reset value:** `0x00C8`  **Access:** see fields below

RF front-end temperature sensor reading

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_VALUE` | `[9:0]` | R | `0x00C8` | Temperature in 0.25°C steps (0x00C8 = 50°C) |
| `VALID` | `[15]` | R | `0x1` | Sensor valid flag |

---
### `TEMP_LO_SYNTH` — Address `0x0302`

**Reset value:** `0x0096`  **Access:** see fields below

ADF5355 LO synthesizer temperature sensor reading

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_VALUE` | `[9:0]` | R | `0x0096` | Temperature in 0.25°C steps (0x0096 = 30°C) |
| `VALID` | `[15]` | R | `0x1` | Sensor valid flag |

---
### `TEMP_ALERT_HIGH` — Address `0x0308`

**Reset value:** `0x0190`  **Access:** see fields below

Over-temperature alert threshold (100°C default)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ALERT_THRESH` | `[9:0]` | RW | `0x0190` | High temperature threshold (0x0190 = 100°C = 400 * 0.25) |
| `ENABLE` | `[15]` | RW | `0x1` | Alert enable (1=enabled) |

---
### `TEMP_ALERT_LOW` — Address `0x0309`

**Reset value:** `0xFF9C`  **Access:** see fields below

Under-temperature alert threshold (-25°C default)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ALERT_THRESH` | `[9:0]` | RW | `0xFF9C` | Low temperature threshold (signed: -25°C) |
| `ENABLE` | `[15]` | RW | `0x1` | Alert enable (1=enabled) |

---
### `HEALTH_STATUS` — Address `0x030F`

**Reset value:** `0x07`  **Access:** see fields below

System health status flags

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_OK` | `[0]` | R | `0x1` | Temperature OK flag (1=within limits) |
| `VOLT_OK` | `[1]` | R | `0x1` | All voltages OK flag (1=within limits) |
| `PLL_LOCK` | `[2]` | R | `0x1` | LO synthesizer lock detect (1=locked) |
| `JESD_LANE0_SYNC` | `[3]` | R | `0x0` | JESD204B lane 0 sync status (1=synced) |
| `JESD_LANE1_SYNC` | `[4]` | R | `0x0` | JESD204B lane 1 sync status (1=synced) |
| `SYSTEM_OK` | `[7]` | R | `0x0` | Overall system OK (all checks pass) |

---
### `PLL_LO_CTRL` — Address `0x0400`

**Reset value:** `0x00`  **Access:** see fields below

ADF5355 LO synthesizer control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `PLL_ENABLE` | `[0]` | RW | `0x0` | PLL enable (1=powered on) |
| `PLL_RESET` | `[1]` | RW | `0x0` | PLL reset (self-clearing) |
| `REF_SEL` | `[3:2]` | RW | `0x0` | Reference clock select (00=10MHz XTAL, 01=external) |

---
### `PLL_LO_STATUS` — Address `0x0401`

**Reset value:** `0x00`  **Access:** see fields below

ADF5355 LO synthesizer status flags

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LOCKED` | `[0]` | R | `0x0` | PLL lock detect (1=locked) |
| `LOSS_OF_LOCK` | `[1]` | RC | `0x0` | Loss of lock event (clear on read) |
| `MUXOUT` | `[4:2]` | R | `0x0` | MUXOUT status bits |

---
### `PLL_INT_DIV` — Address `0x0402`

**Reset value:** `0x0064`  **Access:** see fields below

PLL integer N divider value (default 100)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `INT_VALUE` | `[15:0]` | RW | `0x0064` | Integer N divider (16-4194303) |

---
### `PLL_FRAC_DIV` — Address `0x0403`

**Reset value:** `0x0000`  **Access:** see fields below

PLL fractional divider value

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `FRAC_VALUE` | `[23:0]` | RW | `0x000000` | 24-bit fractional value (0-16777215) |

---
### `PLL_REF_DIV` — Address `0x0404`

**Reset value:** `0x0001`  **Access:** see fields below

PLL reference R divider

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `R_VALUE` | `[7:0]` | RW | `0x01` | R divider (1-1023) |

---
### `CLK_ENABLE` — Address `0x0410`

**Reset value:** `0x0F`  **Access:** see fields below

Clock output enable mask

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `CLK_ADC_EN` | `[0]` | RW | `0x1` | ADC sampling clock enable |
| `CLK_FPGA_EN` | `[1]` | RW | `0x1` | FPGA system clock enable |
| `CLK_JESD_EN` | `[2]` | RW | `0x1` | JESD204B ref clock enable |
| `CLK_RF_EN` | `[3]` | RW | `0x1` | RF front-end clock enable |

---
### `JESD_CTRL` — Address `0x0500`

**Reset value:** `0x00`  **Access:** see fields below

JESD204B interface control for ADC12DJ3200

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `JESD_ENABLE` | `[0]` | RW | `0x0` | JESD204B interface enable (1=enabled) |
| `LANE0_EN` | `[1]` | RW | `0x1` | Lane 0 enable |
| `LANE1_EN` | `[2]` | RW | `0x1` | Lane 1 enable |
| `SUBCLASS` | `[4]` | RW | `0x1` | JESD204B subclass (0=0, 1=1) |
| `SYNC_ASSERT` | `[8]` | RW | `0x0` | Manual SYNC~ assertion (1=assert) |

---
### `JESD_STATUS` — Address `0x0501`

**Reset value:** `0x00`  **Access:** see fields below

JESD204B link status flags

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LINK_READY` | `[0]` | R | `0x0` | Link ready flag (1=code group sync complete) |
| `LANE0_SYNC` | `[1]` | R | `0x0` | Lane 0 aligned (1=synced) |
| `LANE1_SYNC` | `[2]` | R | `0x0` | Lane 1 aligned (1=synced) |
| `CRC_ERR_CNT` | `[7:4]` | R | `0x0` | CRC error counter (0-15) |

---
### `JESD_SCR_L` — Address `0x0502`

**Reset value:** `0x00`  **Access:** see fields below

JESD204B scrambling register low byte

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `SCR_L` | `[7:0]` | RW | `0x00` | Scrambling seed low byte |

---
### `JESD_SCR_H` — Address `0x0503`

**Reset value:** `0x01`  **Access:** see fields below

JESD204B scrambling register high byte

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `SCR_H` | `[7:0]` | RW | `0x01` | Scrambling seed high byte |

---
### `VGA_GAIN_CTRL` — Address `0x0600`

**Reset value:** `0x8000`  **Access:** see fields below

HMC698LP4 VGA gain control (parallel 6-bit interface)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GAIN_CODE` | `[5:0]` | RW | `0x20` | 6-bit gain code (0-63, default 32 = mid gain) |
| `LE_STROBE` | `[8]` | RW | `0x0` | Load Enable strobe (pulse to load gain) |
| `GAIN_ENABLE` | `[15]` | RW | `0x1` | VGA output enable (1=enabled) |
| `RAMP_MODE` | `[14]` | RW | `0x0` | AGC ramp mode enable |

---
### `VGA_STATUS` — Address `0x0601`

**Reset value:** `0x01`  **Access:** see fields below

VGA status and AGC state

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GAIN_LOADED` | `[0]` | R | `0x1` | Gain value loaded successfully (1=done) |
| `AGC_ACTIVE` | `[1]` | R | `0x0` | AGC algorithm active flag |
| `MAX_GAIN` | `[2]` | R | `0x0` | At maximum gain flag |
| `MIN_GAIN` | `[3]` | R | `0x0` | At minimum gain flag |

---
### `LNA_CTRL` — Address `0x0608`

**Reset value:** `0x01`  **Access:** see fields below

HMC6987LP4E LNA control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LNA_ENABLE` | `[0]` | RW | `0x1` | LNA enable (1=powered on) |
| `GAIN_MODE` | `[2:1]` | RW | `0x0` | Gain mode (00=high gain, 01=medium, 10=low) |
| `BYPASS` | `[3]` | RW | `0x0` | LNA bypass mode (1=bypassed) |

---
### `MIXER_CTRL` — Address `0x0609`

**Reset value:** `0x01`  **Access:** see fields below

HMC1194LP4E mixer control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MIXER_ENABLE` | `[0]` | RW | `0x1` | Mixer enable (1=powered on) |
| `IF_PORT_EN` | `[1]` | RW | `0x1` | IF output port enable |
| `LO_PORT_EN` | `[2]` | RW | `0x1` | LO port enable |

---
### `RF_RX_CTRL` — Address `0x0700`

**Reset value:** `0x00`  **Access:** see fields below

RF receiver chain master control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `RF_ENABLE` | `[0]` | RW | `0x0` | RF chain enable (enables LNA, Mixer, VGA) |
| `RX_MODE` | `[2:1]` | RW | `0x0` | Receiver mode (00=normal, 01=bypass, 10=calibration) |
| `AGC_ENABLE` | `[3]` | RW | `0x1` | AGC enable (1=automatic gain control) |

---
### `RF_FREQ_TARGET_L` — Address `0x0701`

**Reset value:** `0x0000`  **Access:** see fields below

Target RF frequency low word (Hz)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `FREQ_HZ_L` | `[15:0]` | RW | `0x0000` | Lower 16 bits of frequency in Hz |

---
### `RF_FREQ_TARGET_H` — Address `0x0702`

**Reset value:** `0x0001`  **Access:** see fields below

Target RF frequency high word (Hz * 65536)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `FREQ_HZ_H` | `[15:0]` | RW | `0x0001` | Upper 16 bits of frequency (default ~6.55MHz) |

---
### `RF_IF_FREQ` — Address `0x0703`

**Reset value:** `0x01F4`  **Access:** see fields below

IF frequency setting (default 500MHz = 0x01F4)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `IF_FREQ_MHZ` | `[15:0]` | RW | `0x01F4` | IF frequency in MHz (0x01F4 = 500) |

---
### `RF_STATUS` — Address `0x0704`

**Reset value:** `0x00`  **Access:** see fields below

RF receiver status flags

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `RF_LOCKED` | `[0]` | R | `0x0` | RF frequency locked (1=LO stable) |
| `AGC_SETTLED` | `[1]` | R | `0x0` | AGC settled flag (1=gain stable) |
| `CAL_DONE` | `[2]` | R | `0x0` | Calibration complete flag |

---
### `EEPROM_CTRL` — Address `0x0800`

**Reset value:** `0x00`  **Access:** see fields below

Configuration EEPROM control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READ_CMD` | `[0]` | RW | `0x0` | Read command (self-clearing) |
| `WRITE_CMD` | `[1]` | RW | `0x0` | Write command (self-clearing) |
| `ERASE_CMD` | `[2]` | RW | `0x0` | Erase command (self-clearing) |
| `BUSY` | `[7]` | R | `0x0` | EEPROM busy flag (1=operation in progress) |

---
### `EEPROM_ADDR` — Address `0x0801`

**Reset value:** `0x0000`  **Access:** see fields below

EEPROM byte address

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BYTE_ADDR` | `[15:0]` | RW | `0x0000` | 16-bit byte address (0-65535) |

---
### `EEPROM_DATA` — Address `0x0802`

**Reset value:** `0x0000`  **Access:** see fields below

EEPROM read/write data

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA_WORD` | `[15:0]` | RW | `0x0000` | 16-bit data word |

---
### `FLASH_CTRL` — Address `0x0900`

**Reset value:** `0x00`  **Access:** see fields below

Quad-SPI Flash control for FPGA bitstream

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READ_CMD` | `[0]` | RW | `0x0` | Flash read command |
| `WRITE_CMD` | `[1]` | RW | `0x0` | Flash write command |
| `ERASE_SECTOR` | `[2]` | RW | `0x0` | Sector erase command (64KB) |
| `ERASE_CHIP` | `[3]` | RW | `0x0` | Chip erase command |
| `BUSY` | `[7]` | R | `0x0` | Flash busy flag |

---
### `FLASH_ADDR_L` — Address `0x0901`

**Reset value:** `0x0000`  **Access:** see fields below

Flash address low word

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADDR_LOW` | `[15:0]` | RW | `0x0000` | Lower 16 bits of flash address |

---
### `FLASH_ADDR_H` — Address `0x0902`

**Reset value:** `0x0000`  **Access:** see fields below

Flash address high byte

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADDR_HIGH` | `[7:0]` | RW | `0x00` | Upper 8 bits of flash address (24-bit total) |

---
### `FLASH_DATA` — Address `0x0903`

**Reset value:** `0x0000`  **Access:** see fields below

Flash data FIFO

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA_FIFO` | `[15:0]` | RW | `0x0000` | Data word for read/write operations |

---
### `FLASH_STATUS` — Address `0x0904`

**Reset value:** `0x01`  **Access:** see fields below

Flash interface status

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READY` | `[0]` | R | `0x1` | Flash ready flag (1=idle) |
| `WRITE_ERR` | `[1]` | RC | `0x0` | Write protect error (clear on read) |
| `ERASE_ERR` | `[2]` | RC | `0x0` | Erase error (clear on read) |
