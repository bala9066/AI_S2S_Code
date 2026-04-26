# Register Description Table (RDT)
## rx band

> **Total registers:** 68

Complete Register Description Table and Programming Sequence for the RX Band 4-Channel 18–40 GHz Double-IF Superheterodyne Radar Receiver (XC7K355T-1FFG901I FPGA). Register map covers 10 functional groups: Board Info (0x000), Communication/UART (0x100), ADC/Supply Monitoring (0x200), Temperature/Health (0x300), PLL/Clock (0x400), EEPROM/Calibration (0x500), Flash Configuration (0x600), RF/LO Control (0x700), GPIO (0x800), and DAC/VGA Output (0x900). 48 registers total. 20-step programming sequence covers power-on self-check through full system bring-up including both LO synthesizers, VGA, ADC, and YIG preselector.

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
| `0x0000` | `BOARD_ID` | — | `0xB418` | Board identification code. Fixed value identifying this as the rx-band 4-channel 18-40 GHz receiver. |
| `0x0001` | `BOARD_VERSION` | — | `0x0001` | Hardware version register. Encodes PCB revision. |
| `0x0002` | `BOARD_TYPE_ID` | — | `0x4358` | Board type identifier encoding the product class. |
| `0x0003` | `SCRATCHPAD` | — | `0x0000` | General-purpose read/write register for firmware communication tests and RAM integrity verification. |
| `0x0010` | `MCS_VERSION_MAJOR` | — | `0x0001` | FPGA firmware (MCS bitstream) major version number. |
| `0x0011` | `MCS_VERSION_MINOR` | — | `0x0000` | FPGA firmware (MCS bitstream) minor version number. |
| `0x0012` | `BUILD_DATE` | — | `0x2604` | Firmware build date packed as YYMM in BCD format (April 2026 = 0x2604). |
| `0x0100` | `UART_BAUD_DIV` | — | `0x0036` | UART baud rate divisor. System clock / (16 × divisor) = baud rate. Default 54 → 115200 baud at 100 MHz. |
| `0x0101` | `UART_CTRL` | — | `0x0001` | UART control register. Enables transmitter/receiver and configures frame format. |
| `0x0102` | `UART_STATUS` | — | `0x0000` | UART status flags. Read-cleared for error flags. |
| `0x0103` | `UART_TX_COUNT` | — | `0x0000` | Number of bytes currently in the TX FIFO. |
| `0x0104` | `UART_RX_COUNT` | — | `0x0000` | Number of bytes currently in the RX FIFO. |
| `0x0110` | `ETH_MAC_LOW` | — | `0x0000` | Ethernet MAC address lower 16 bits (if applicable). |
| `0x0111` | `ETH_MAC_HIGH` | — | `0x0000` | Ethernet MAC address upper 16 bits (if applicable). |
| `0x0200` | `ADC_CTRL` | — | `0x0000` | ADC control register for the LTC2107 16-bit 210 Msps ADC. |
| `0x0201` | `ADC_STATUS` | — | `0x0000` | ADC status register indicating conversion state and errors. |
| `0x0202` | `ADC_DATA` | — | `0x0000` | ADC conversion result. Reading this register pops one sample from the ADC data FIFO. |
| `0x0203` | `ADC_SAMPLE_COUNT` | — | `0x0000` | Number of 16-bit samples available in the ADC data FIFO. |
| `0x0210` | `VCC_5V_RAW` | — | `0x0000` | 5V rail voltage ADC count. Voltage = COUNT × 5.0 / 4096. |
| `0x0211` | `VCC_3V3_RAW` | — | `0x0000` | 3.3V rail voltage ADC count. Voltage = COUNT × 5.0 / 4096. |
| `0x0212` | `VCC_1V8_RAW` | — | `0x0000` | 1.8V rail voltage ADC count. Voltage = COUNT × 5.0 / 4096. |
| `0x0213` | `VCC_1V0_RAW` | — | `0x0000` | 1.0V buck regulator rail voltage ADC count. Voltage = COUNT × 5.0 / 4096. |
| `0x0218` | `ICC_5V_RAW` | — | `0x0000` | 5V rail current sense ADC count. Current = COUNT × sense_factor. |
| `0x0219` | `ICC_3V3_RAW` | — | `0x0000` | 3.3V rail current sense ADC count. |
| `0x021A` | `ICC_1V0_RAW` | — | `0x0000` | 1.0V buck regulator current sense ADC count. |
| `0x0300` | `TEMP_LOCAL` | — | `0x0000` | Local FPGA die temperature in 0.25°C units, signed 10-bit value. Range -128°C to +127.75°C. |
| `0x0301` | `TEMP_REMOTE1` | — | `0x0000` | Remote temperature sensor 1 reading (near LNA/buffer amplifiers) in 0.25°C units. |
| `0x0302` | `TEMP_REMOTE2` | — | `0x0000` | Remote temperature sensor 2 reading (near ADC/PLL area) in 0.25°C units. |
| `0x0308` | `TEMP_ALERT_HIGH` | — | `0x0190` | Over-temperature alert threshold in 0.25°C units. Default 100°C (0x190). |
| `0x0309` | `TEMP_ALERT_LOW` | — | `0xFE6C` | Under-temperature alert threshold in 0.25°C units. Default -25°C (0xFE6C in 10-bit signed). |
| `0x030F` | `HEALTH_STATUS` | — | `0x0000` | System health summary register. All flags should be 1 for nominal operation. |
| `0x0400` | `PLL_CTRL` | — | `0x0000` | PLL control register. Controls both LO1 (LMX2820) and LO2 (ADF4383) synthesizers. |
| `0x0401` | `PLL_STATUS` | — | `0x0000` | PLL lock status for both LO synthesizers. |
| `0x0402` | `PLL_N_DIV` | — | `0x0001` | PLL N-divider (feedback divider) value for the currently selected LO. Used for VCO frequency calculation. |
| `0x0403` | `PLL_R_DIV` | — | `0x0001` | PLL R-divider (reference divider) value for the currently selected LO. |
| `0x0404` | `PLL_LO_SELECT` | — | `0x0000` | Selects which LO synthesizer is targeted by PLL_N_DIV, PLL_R_DIV, and PLL_CTRL writes. |
| `0x0405` | `PLL_FRAC_NUM` | — | `0x0000` | Fractional-N numerator for fine frequency tuning of the selected LO. |
| `0x0406` | `PLL_FRAC_DEN` | — | `0x0001` | Fractional-N denominator for the selected LO. |
| `0x0410` | `CLK_ENABLE` | — | `0x0000` | Clock output enables. Each bit controls a buffered clock output distribution path. |
| `0x0500` | `EEPROM_CTRL` | — | `0x0000` | EEPROM control register for on-board calibration / serial number storage. |
| `0x0501` | `EEPROM_ADDR` | — | `0x0000` | EEPROM byte address for the next read/write operation. |
| `0x0502` | `EEPROM_DATA` | — | `0x0000` | EEPROM read/write data. After READ completes, contains the byte from EEPROM_ADDR. Write data here before initiating WRITE. |
| `0x0503` | `EEPROM_KEY` | — | `0x0000` | EEPROM write/erase unlock key. Must write 0xA5A5 before any write or erase operation to prevent accidental data corruption. |
| `0x0600` | `FLASH_CTRL` | — | `0x0000` | Configuration flash control register for FPGA bitstream storage and application data. |
| `0x0601` | `FLASH_ADDR_LOW` | — | `0x0000` | Flash address lower 16 bits for read/write/erase operations. |
| `0x0602` | `FLASH_ADDR_HIGH` | — | `0x0000` | Flash address upper 8 bits [23:16] for read/write/erase operations. |
| `0x0603` | `FLASH_DATA` | — | `0x0000` | Flash read/write data FIFO. Writing pushes data; after READ op, popping retrieves flash contents. |
| `0x0604` | `FLASH_STATUS` | — | `0x0000` | Flash interface status register. |
| `0x0700` | `RF_CTRL` | — | `0x0000` | Master RF signal chain control. Enables bias and signal path for the entire receiver chain. |
| `0x0701` | `YIG_TUNE` | — | `0x0000` | YIG tunable preselector (18–40 GHz) tuning control. DAC output drives YIG filter center frequency. |
| `0x0710` | `LO1_FREQ_LO` | — | `0x0000` | LO1 (LMX2820) frequency control lower 16 bits. Combined with LO1_FREQ_HI to form 32-bit frequency word. |
| `0x0711` | `LO1_FREQ_HI` | — | `0x0000` | LO1 (LMX2820) frequency control upper 16 bits. |
| `0x0712` | `LO2_FREQ_LO` | — | `0x0000` | LO2 (ADF4383) frequency control lower 16 bits. |
| `0x0713` | `LO2_FREQ_HI` | — | `0x0000` | LO2 (ADF4383) frequency control upper 16 bits. |
| `0x0720` | `LO1_SPI_DATA` | — | `0x0000` | LO1 SPI register write data. Write triggers an SPI transaction to the LMX2820. |
| `0x0721` | `LO1_SPI_ADDR` | — | `0x0000` | LO1 SPI register address for the LMX2820. |
| `0x0722` | `LO2_SPI_DATA` | — | `0x0000` | LO2 SPI register write data for the ADF4383. |
| `0x0723` | `LO2_SPI_ADDR` | — | `0x0000` | LO2 SPI register address for the ADF4383. |
| `0x0800` | `GPIO_DIR` | — | `0x0000` | GPIO pin direction register. 0=input, 1=output. Controls direction of general-purpose I/O pins on the data connector. |
| `0x0801` | `GPIO_DATA_OUT` | — | `0x0000` | GPIO output data register. Written values appear on pins configured as outputs. |
| `0x0802` | `GPIO_DATA_IN` | — | `0x0000` | GPIO input data register. Reflects current state of all GPIO pins regardless of direction. |
| `0x0803` | `GPIO_IRQ_MASK` | — | `0x0000` | GPIO interrupt mask. Set bit to 1 to enable interrupt generation on GPIO pin change. |
| `0x0804` | `GPIO_IRQ_STATUS` | — | `0x0000` | GPIO interrupt pending status. Bit set when GPIO pin transitions and IRQ is enabled. Read-clears. |
| `0x0900` | `DAC_CTRL` | — | `0x0000` | DAC control register for VGA gain control (TGL2767) and YIG tuning outputs. |
| `0x0901` | `VGA_GAIN` | — | `0x0800` | VGA (TGL2767-SMEVB) gain control DAC code. 16-bit value sets the variable gain amplifier attenuation. |
| `0x0902` | `VGA_ATTEN_STATUS` | — | `0x0000` | VGA attenuator status feedback. Read-only indication of current VGA state. |
| `0x0808` | `SYSTEM_CTRL` | — | `0x0000` | System-level control register for receiver operating mode. |
| `0x0809` | `SYSTEM_STATUS` | — | `0x0000` | System-level status register reflecting current receiver state. |

---
### `BOARD_ID` — Address `0x0000`

**Reset value:** `0xB418`  **Access:** see fields below

Board identification code. Fixed value identifying this as the rx-band 4-channel 18-40 GHz receiver.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BOARD_ID` | `[15:0]` | R | `0xB418` | Unique board identifier. Expected value 0xB418 for rx-band receiver. |

---
### `BOARD_VERSION` — Address `0x0001`

**Reset value:** `0x0001`  **Access:** see fields below

Hardware version register. Encodes PCB revision.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAJOR` | `[7:4]` | R | `0x0` | Hardware major version number. |
| `MINOR` | `[3:0]` | R | `0x1` | Hardware minor version number. |

---
### `BOARD_TYPE_ID` — Address `0x0002`

**Reset value:** `0x4358`  **Access:** see fields below

Board type identifier encoding the product class.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TYPE_ID` | `[15:0]` | R | `0x4358` | ASCII 'CX' — Coherent Radar Receiver board type. |

---
### `SCRATCHPAD` — Address `0x0003`

**Reset value:** `0x0000`  **Access:** see fields below

General-purpose read/write register for firmware communication tests and RAM integrity verification.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA` | `[15:0]` | RW | `0x0000` | Scratchpad data. Write a pattern, read back to verify register interface integrity. |

---
### `MCS_VERSION_MAJOR` — Address `0x0010`

**Reset value:** `0x0001`  **Access:** see fields below

FPGA firmware (MCS bitstream) major version number.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `VERSION` | `[7:0]` | R | `0x01` | Firmware major version. |

---
### `MCS_VERSION_MINOR` — Address `0x0011`

**Reset value:** `0x0000`  **Access:** see fields below

FPGA firmware (MCS bitstream) minor version number.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `VERSION` | `[7:0]` | R | `0x00` | Firmware minor version. |

---
### `BUILD_DATE` — Address `0x0012`

**Reset value:** `0x2604`  **Access:** see fields below

Firmware build date packed as YYMM in BCD format (April 2026 = 0x2604).

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `YEAR` | `[15:8]` | R | `0x26` | Year (BCD, 2026=0x26). |
| `MONTH` | `[7:0]` | R | `0x04` | Month (BCD, April=0x04). |

---
### `UART_BAUD_DIV` — Address `0x0100`

**Reset value:** `0x0036`  **Access:** see fields below

UART baud rate divisor. System clock / (16 × divisor) = baud rate. Default 54 → 115200 baud at 100 MHz.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DIVISOR` | `[15:0]` | RW | `0x0036` | Baud rate divisor value. |

---
### `UART_CTRL` — Address `0x0101`

**Reset value:** `0x0001`  **Access:** see fields below

UART control register. Enables transmitter/receiver and configures frame format.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0x1` | UART enable. 1=enabled, 0=disabled. |
| `LOOPBACK` | `[1]` | RW | `0x0` | Internal loopback mode for self-test. |
| `FRAME_FORMAT` | `[7:4]` | RW | `0x0` | Frame format selection: 0=8N1, 1=8E1, 2=8O1, 3=8N2. |
| `TX_IRQ_EN` | `[8]` | RW | `0x0` | TX interrupt enable. |
| `RX_IRQ_EN` | `[9]` | RW | `0x0` | RX interrupt enable. |

---
### `UART_STATUS` — Address `0x0102`

**Reset value:** `0x0000`  **Access:** see fields below

UART status flags. Read-cleared for error flags.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TX_BUSY` | `[0]` | R | `0x0` | Transmitter is actively sending data. |
| `RX_AVAIL` | `[1]` | R | `0x0` | At least one byte available in RX FIFO. |
| `FRAME_ERR` | `[2]` | RC | `0x0` | Framing error detected (read clears). |
| `OVERRUN` | `[3]` | RC | `0x0` | RX FIFO overrun (read clears). |
| `PARITY_ERR` | `[4]` | RC | `0x0` | Parity error detected (read clears). |

---
### `UART_TX_COUNT` — Address `0x0103`

**Reset value:** `0x0000`  **Access:** see fields below

Number of bytes currently in the TX FIFO.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `COUNT` | `[7:0]` | R | `0x00` | TX FIFO occupancy count (0-255). |

---
### `UART_RX_COUNT` — Address `0x0104`

**Reset value:** `0x0000`  **Access:** see fields below

Number of bytes currently in the RX FIFO.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `COUNT` | `[7:0]` | R | `0x00` | RX FIFO occupancy count (0-255). |

---
### `ETH_MAC_LOW` — Address `0x0110`

**Reset value:** `0x0000`  **Access:** see fields below

Ethernet MAC address lower 16 bits (if applicable).

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAC_LOW` | `[15:0]` | R | `0x0000` | Lower 16 bits of MAC address. |

---
### `ETH_MAC_HIGH` — Address `0x0111`

**Reset value:** `0x0000`  **Access:** see fields below

Ethernet MAC address upper 16 bits (if applicable).

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAC_HIGH` | `[15:0]` | R | `0x0000` | Upper 16 bits of MAC address. |

---
### `ADC_CTRL` — Address `0x0200`

**Reset value:** `0x0000`  **Access:** see fields below

ADC control register for the LTC2107 16-bit 210 Msps ADC.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `START` | `[0]` | RW | `0x0` | Start single conversion. Self-clearing. |
| `CONTINUOUS` | `[1]` | RW | `0x0` | Enable continuous conversion mode. |
| `CH_SELECT` | `[3:2]` | RW | `0x0` | ADC channel select: 0=ch0, 1=ch1, 2=ch2, 3=ch3. |
| `DATA_FORMAT` | `[5:4]` | RW | `0x0` | Output data format: 0=offset binary, 1=two's complement. |
| `POWER_DOWN` | `[6]` | RW | `0x0` | ADC power down (sleep) control. 1=powered down. |
| `CLK_EDGE` | `[7]` | RW | `0x0` | LVDS clock edge select for ADC data capture. |

---
### `ADC_STATUS` — Address `0x0201`

**Reset value:** `0x0000`  **Access:** see fields below

ADC status register indicating conversion state and errors.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA_READY` | `[0]` | RC | `0x0` | New ADC sample available (read clears). |
| `OVERRANGE` | `[1]` | RC | `0x0` | ADC input exceeded full-scale range (read clears). |
| `CLK_DETECT` | `[2]` | R | `0x0` | ADC clock signal detected. |
| `FIFO_FULL` | `[3]` | R | `0x0` | ADC data FIFO is full (overflow risk). |
| `FIFO_EMPTY` | `[4]` | R | `0x0` | ADC data FIFO is empty. |

---
### `ADC_DATA` — Address `0x0202`

**Reset value:** `0x0000`  **Access:** see fields below

ADC conversion result. Reading this register pops one sample from the ADC data FIFO.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `SAMPLE` | `[15:0]` | R | `0x0000` | 16-bit ADC sample value (two's complement or offset binary per ADC_CTRL). |

---
### `ADC_SAMPLE_COUNT` — Address `0x0203`

**Reset value:** `0x0000`  **Access:** see fields below

Number of 16-bit samples available in the ADC data FIFO.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `COUNT` | `[15:0]` | R | `0x0000` | FIFO sample count. |

---
### `VCC_5V_RAW` — Address `0x0210`

**Reset value:** `0x0000`  **Access:** see fields below

5V rail voltage ADC count. Voltage = COUNT × 5.0 / 4096.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | R | `0x000` | 12-bit ADC count for +5V rail voltage. |

---
### `VCC_3V3_RAW` — Address `0x0211`

**Reset value:** `0x0000`  **Access:** see fields below

3.3V rail voltage ADC count. Voltage = COUNT × 5.0 / 4096.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | R | `0x000` | 12-bit ADC count for +3.3V rail voltage. |

---
### `VCC_1V8_RAW` — Address `0x0212`

**Reset value:** `0x0000`  **Access:** see fields below

1.8V rail voltage ADC count. Voltage = COUNT × 5.0 / 4096.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | R | `0x000` | 12-bit ADC count for +1.8V rail voltage. |

---
### `VCC_1V0_RAW` — Address `0x0213`

**Reset value:** `0x0000`  **Access:** see fields below

1.0V buck regulator rail voltage ADC count. Voltage = COUNT × 5.0 / 4096.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | R | `0x000` | 12-bit ADC count for +1.0V buck rail voltage. |

---
### `ICC_5V_RAW` — Address `0x0218`

**Reset value:** `0x0000`  **Access:** see fields below

5V rail current sense ADC count. Current = COUNT × sense_factor.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | R | `0x000` | 12-bit ADC count for +5V rail current. |

---
### `ICC_3V3_RAW` — Address `0x0219`

**Reset value:** `0x0000`  **Access:** see fields below

3.3V rail current sense ADC count.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | R | `0x000` | 12-bit ADC count for +3.3V rail current. |

---
### `ICC_1V0_RAW` — Address `0x021A`

**Reset value:** `0x0000`  **Access:** see fields below

1.0V buck regulator current sense ADC count.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | R | `0x000` | 12-bit ADC count for +1.0V buck rail current. |

---
### `TEMP_LOCAL` — Address `0x0300`

**Reset value:** `0x0000`  **Access:** see fields below

Local FPGA die temperature in 0.25°C units, signed 10-bit value. Range -128°C to +127.75°C.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP` | `[9:0]` | R | `0x000` | Signed temperature value in 0.25°C steps. |

---
### `TEMP_REMOTE1` — Address `0x0301`

**Reset value:** `0x0000`  **Access:** see fields below

Remote temperature sensor 1 reading (near LNA/buffer amplifiers) in 0.25°C units.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP` | `[9:0]` | R | `0x000` | Signed temperature from remote sensor 1. |

---
### `TEMP_REMOTE2` — Address `0x0302`

**Reset value:** `0x0000`  **Access:** see fields below

Remote temperature sensor 2 reading (near ADC/PLL area) in 0.25°C units.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP` | `[9:0]` | R | `0x000` | Signed temperature from remote sensor 2. |

---
### `TEMP_ALERT_HIGH` — Address `0x0308`

**Reset value:** `0x0190`  **Access:** see fields below

Over-temperature alert threshold in 0.25°C units. Default 100°C (0x190).

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `THRESHOLD` | `[9:0]` | RW | `0x190` | High temperature alert threshold. |

---
### `TEMP_ALERT_LOW` — Address `0x0309`

**Reset value:** `0xFE6C`  **Access:** see fields below

Under-temperature alert threshold in 0.25°C units. Default -25°C (0xFE6C in 10-bit signed).

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `THRESHOLD` | `[9:0]` | RW | `0x1CC` | Low temperature alert threshold (signed 10-bit). |

---
### `HEALTH_STATUS` — Address `0x030F`

**Reset value:** `0x0000`  **Access:** see fields below

System health summary register. All flags should be 1 for nominal operation.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_OK` | `[0]` | R | `0x0` | All temperature readings within limits. |
| `VOLT_OK` | `[1]` | R | `0x0` | All voltage rails within tolerance. |
| `PLL_LOCK` | `[2]` | R | `0x0` | Both LO PLLs locked. |
| `ADC_OK` | `[3]` | R | `0x0` | ADC operational and not in overrange. |
| `RF_OK` | `[4]` | R | `0x0` | RF chain bias and signal path healthy. |
| `OCXO_LOCK` | `[5]` | R | `0x0` | 10 MHz OCXO reference is locked and stable. |
| `FLASH_OK` | `[6]` | R | `0x0` | Configuration flash interface ready. |
| `SYSTEM_OK` | `[7]` | R | `0x0` | Overall system health (logical AND of bits [6:0]). |

---
### `PLL_CTRL` — Address `0x0400`

**Reset value:** `0x0000`  **Access:** see fields below

PLL control register. Controls both LO1 (LMX2820) and LO2 (ADF4383) synthesizers.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `PLL_ENABLE` | `[0]` | RW | `0x0` | Global PLL enable (both LO1 and LO2). |
| `PLL_RESET` | `[1]` | RW | `0x0` | Active-high PLL reset. Hold high for ≥10 µs then deassert. |
| `REF_SEL` | `[3:2]` | RW | `0x0` | Reference clock source: 0=OCXO 10 MHz, 1=external ref, 2=internal backup, 3=reserved. |
| `LO1_POWER` | `[5:4]` | RW | `0x0` | LO1 output power level: 0=off, 1=low, 2=mid, 3=high. |
| `LO2_POWER` | `[7:6]` | RW | `0x0` | LO2 output power level: 0=off, 1=low, 2=mid, 3=high. |

---
### `PLL_STATUS` — Address `0x0401`

**Reset value:** `0x0000`  **Access:** see fields below

PLL lock status for both LO synthesizers.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LO1_LOCKED` | `[0]` | R | `0x0` | LO1 (LMX2820) is phase-locked. |
| `LO2_LOCKED` | `[1]` | R | `0x0` | LO2 (ADF4383) is phase-locked. |
| `LO1_LOSS_OF_LOCK` | `[2]` | RC | `0x0` | LO1 lost lock since last read (read clears). |
| `LO2_LOSS_OF_LOCK` | `[3]` | RC | `0x0` | LO2 lost lock since last read (read clears). |
| `LO1_LD_PIN` | `[4]` | R | `0x0` | Raw LO1 lock-detect pin state. |
| `LO2_LD_PIN` | `[5]` | R | `0x0` | Raw LO2 lock-detect pin state. |
| `REF_PRESENT` | `[6]` | R | `0x0` | 10 MHz reference clock signal is present at OCXO buffer. |

---
### `PLL_N_DIV` — Address `0x0402`

**Reset value:** `0x0001`  **Access:** see fields below

PLL N-divider (feedback divider) value for the currently selected LO. Used for VCO frequency calculation.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `N_DIV` | `[15:0]` | RW | `0x0001` | N-divider value (1–65535). |

---
### `PLL_R_DIV` — Address `0x0403`

**Reset value:** `0x0001`  **Access:** see fields below

PLL R-divider (reference divider) value for the currently selected LO.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `R_DIV` | `[7:0]` | RW | `0x01` | R-divider value (1–255). |

---
### `PLL_LO_SELECT` — Address `0x0404`

**Reset value:** `0x0000`  **Access:** see fields below

Selects which LO synthesizer is targeted by PLL_N_DIV, PLL_R_DIV, and PLL_CTRL writes.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LO_SEL` | `[0]` | RW | `0x0` | 0=LO1 (LMX2820), 1=LO2 (ADF4383). |
| `UPDATE_REGS` | `[1]` | RW | `0x0` | Self-clearing bit. Write 1 to latch divider values into the selected PLL SPI register set. |

---
### `PLL_FRAC_NUM` — Address `0x0405`

**Reset value:** `0x0000`  **Access:** see fields below

Fractional-N numerator for fine frequency tuning of the selected LO.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `FRAC_NUM` | `[15:0]` | RW | `0x0000` | Fractional numerator (24-bit value, lower 16 bits). |

---
### `PLL_FRAC_DEN` — Address `0x0406`

**Reset value:** `0x0001`  **Access:** see fields below

Fractional-N denominator for the selected LO.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `FRAC_DEN` | `[15:0]` | RW | `0x0001` | Fractional denominator (MOD value). |

---
### `CLK_ENABLE` — Address `0x0410`

**Reset value:** `0x0000`  **Access:** see fields below

Clock output enables. Each bit controls a buffered clock output distribution path.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_CLK_EN` | `[0]` | RW | `0x0` | Enable ADC sample clock output (210 MHz LVDS). |
| `LO1_REF_CLK_EN` | `[1]` | RW | `0x0` | Enable LO1 reference clock buffer output. |
| `LO2_REF_CLK_EN` | `[2]` | RW | `0x0` | Enable LO2 reference clock buffer output. |
| `SYSTEM_CLK_EN` | `[3]` | RW | `0x0` | Enable system clock output. |
| `DATA_CLK_EN` | `[4]` | RW | `0x0` | Enable data output interface clock. |
| `SYNC_CLK_EN` | `[5]` | RW | `0x0` | Enable synchronisation clock for multi-channel alignment. |

---
### `EEPROM_CTRL` — Address `0x0500`

**Reset value:** `0x0000`  **Access:** see fields below

EEPROM control register for on-board calibration / serial number storage.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READ` | `[0]` | RW | `0x0` | Initiate EEPROM read (self-clearing). |
| `WRITE` | `[1]` | RW | `0x0` | Initiate EEPROM write (self-clearing). Requires unlock key in EEPROM_KEY first. |
| `ERASE` | `[2]` | RW | `0x0` | Initiate EEPROM sector erase (self-clearing). Requires unlock key. |
| `BUSY` | `[7]` | R | `0x0` | EEPROM operation in progress. Poll until 0. |
| `ERR` | `[6]` | RC | `0x0` | EEPROM error flag (read clears). |

---
### `EEPROM_ADDR` — Address `0x0501`

**Reset value:** `0x0000`  **Access:** see fields below

EEPROM byte address for the next read/write operation.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADDR` | `[15:0]` | RW | `0x0000` | 16-bit EEPROM address. |

---
### `EEPROM_DATA` — Address `0x0502`

**Reset value:** `0x0000`  **Access:** see fields below

EEPROM read/write data. After READ completes, contains the byte from EEPROM_ADDR. Write data here before initiating WRITE.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA` | `[15:0]` | RW | `0x0000` | Data word for EEPROM operations. |

---
### `EEPROM_KEY` — Address `0x0503`

**Reset value:** `0x0000`  **Access:** see fields below

EEPROM write/erase unlock key. Must write 0xA5A5 before any write or erase operation to prevent accidental data corruption.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `KEY` | `[15:0]` | W | `0x0000` | Unlock key value. Write 0xA5A5 to enable writes. Reads return 0x0000. |

---
### `FLASH_CTRL` — Address `0x0600`

**Reset value:** `0x0000`  **Access:** see fields below

Configuration flash control register for FPGA bitstream storage and application data.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READ` | `[0]` | RW | `0x0` | Initiate flash read (self-clearing). |
| `WRITE` | `[1]` | RW | `0x0` | Initiate flash page write (self-clearing). Requires unlock key. |
| `ERASE_SECTOR` | `[2]` | RW | `0x0` | Erase one 64 KB sector (self-clearing). Requires unlock key. |
| `ERASE_CHIP` | `[3]` | RW | `0x0` | Full chip erase (self-clearing). Requires unlock key. |
| `ERASE_ERR` | `[5]` | RC | `0x0` | Erase error flag (read clears). |
| `WRITE_ERR` | `[6]` | RC | `0x0` | Write error flag (read clears). |
| `BUSY` | `[7]` | R | `0x0` | Flash operation in progress. Poll until 0. |
| `READY` | `[8]` | R | `0x0` | Flash interface initialized and ready. |

---
### `FLASH_ADDR_LOW` — Address `0x0601`

**Reset value:** `0x0000`  **Access:** see fields below

Flash address lower 16 bits for read/write/erase operations.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADDR_LOW` | `[15:0]` | RW | `0x0000` | Lower 16 bits of 24-bit flash address. |

---
### `FLASH_ADDR_HIGH` — Address `0x0602`

**Reset value:** `0x0000`  **Access:** see fields below

Flash address upper 8 bits [23:16] for read/write/erase operations.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADDR_HIGH` | `[7:0]` | RW | `0x00` | Upper 8 bits of flash address. |

---
### `FLASH_DATA` — Address `0x0603`

**Reset value:** `0x0000`  **Access:** see fields below

Flash read/write data FIFO. Writing pushes data; after READ op, popping retrieves flash contents.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA` | `[15:0]` | RW | `0x0000` | Data word for flash operations. |

---
### `FLASH_STATUS` — Address `0x0604`

**Reset value:** `0x0000`  **Access:** see fields below

Flash interface status register.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READY` | `[0]` | R | `0x0` | Flash interface ready. |
| `WRITE_ERR` | `[1]` | RC | `0x0` | Write error (read clears). |
| `ERASE_ERR` | `[2]` | RC | `0x0` | Erase error (read clears). |
| `FIFO_COUNT` | `[10:8]` | R | `0x0` | Number of words in flash data FIFO. |
| `DEVICE_ID` | `[15:12]` | R | `0x0` | Flash device ID read from JEDEC ID query. |

---
### `RF_CTRL` — Address `0x0700`

**Reset value:** `0x0000`  **Access:** see fields below

Master RF signal chain control. Enables bias and signal path for the entire receiver chain.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `RF_ENABLE` | `[0]` | RW | `0x0` | Master RF chain enable. Must be 1 for any RF path to be active. |
| `LNA_ENABLE` | `[1]` | RW | `0x0` | LNA (ZVA-183WA-S+) bias enable. |
| `LIMITER_BYPASS` | `[2]` | RW | `0x0` | Bypass RF limiter (VLM-63A-S+). 0=in-line (protected), 1=bypass. |
| `MIX1_ENABLE` | `[3]` | RW | `0x0` | First mixer (CMD180C3) LO1 switch/enable. |
| `MIX2_ENABLE` | `[4]` | RW | `0x0` | Second IQ mixer (MMIQ-0205HSM-2) LO2 switch/enable. |
| `IF1_GAIN_EN` | `[5]` | RW | `0x0` | IF1 gain block (PMA2-123LNW+) enable. |
| `LO1_BUF_EN` | `[6]` | RW | `0x0` | LO1 buffer amplifier (GVA-63+) enable. |
| `LO2_BUF_EN` | `[7]` | RW | `0x0` | LO2 buffer amplifier (GVA-63+) enable. |

---
### `YIG_TUNE` — Address `0x0701`

**Reset value:** `0x0000`  **Access:** see fields below

YIG tunable preselector (18–40 GHz) tuning control. DAC output drives YIG filter center frequency.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TUNE_CODE` | `[15:0]` | RW | `0x0000` | 16-bit YIG tuning DAC code. Maps linearly to 18–40 GHz filter passband center. |

---
### `LO1_FREQ_LO` — Address `0x0710`

**Reset value:** `0x0000`  **Access:** see fields below

LO1 (LMX2820) frequency control lower 16 bits. Combined with LO1_FREQ_HI to form 32-bit frequency word.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `FREQ_LO` | `[15:0]` | RW | `0x0000` | Lower 16 bits of LO1 frequency word. |

---
### `LO1_FREQ_HI` — Address `0x0711`

**Reset value:** `0x0000`  **Access:** see fields below

LO1 (LMX2820) frequency control upper 16 bits.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `FREQ_HI` | `[15:0]` | RW | `0x0000` | Upper 16 bits of LO1 frequency word. |

---
### `LO2_FREQ_LO` — Address `0x0712`

**Reset value:** `0x0000`  **Access:** see fields below

LO2 (ADF4383) frequency control lower 16 bits.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `FREQ_LO` | `[15:0]` | RW | `0x0000` | Lower 16 bits of LO2 frequency word. |

---
### `LO2_FREQ_HI` — Address `0x0713`

**Reset value:** `0x0000`  **Access:** see fields below

LO2 (ADF4383) frequency control upper 16 bits.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `FREQ_HI` | `[15:0]` | RW | `0x0000` | Upper 16 bits of LO2 frequency word. |

---
### `LO1_SPI_DATA` — Address `0x0720`

**Reset value:** `0x0000`  **Access:** see fields below

LO1 SPI register write data. Write triggers an SPI transaction to the LMX2820.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `SPI_DATA` | `[15:0]` | RW | `0x0000` | 16-bit SPI data payload for LO1 synthesizer. |

---
### `LO1_SPI_ADDR` — Address `0x0721`

**Reset value:** `0x0000`  **Access:** see fields below

LO1 SPI register address for the LMX2820.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `SPI_ADDR` | `[6:0]` | RW | `0x00` | 7-bit SPI register address for LO1. |

---
### `LO2_SPI_DATA` — Address `0x0722`

**Reset value:** `0x0000`  **Access:** see fields below

LO2 SPI register write data for the ADF4383.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `SPI_DATA` | `[15:0]` | RW | `0x0000` | 16-bit SPI data payload for LO2 synthesizer. |

---
### `LO2_SPI_ADDR` — Address `0x0723`

**Reset value:** `0x0000`  **Access:** see fields below

LO2 SPI register address for the ADF4383.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `SPI_ADDR` | `[6:0]` | RW | `0x00` | 7-bit SPI register address for LO2. |

---
### `GPIO_DIR` — Address `0x0800`

**Reset value:** `0x0000`  **Access:** see fields below

GPIO pin direction register. 0=input, 1=output. Controls direction of general-purpose I/O pins on the data connector.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DIR` | `[15:0]` | RW | `0x0000` | Per-pin direction. Bit[n]=1 sets GPIO[n] as output. |

---
### `GPIO_DATA_OUT` — Address `0x0801`

**Reset value:** `0x0000`  **Access:** see fields below

GPIO output data register. Written values appear on pins configured as outputs.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA_OUT` | `[15:0]` | RW | `0x0000` | GPIO output data. |

---
### `GPIO_DATA_IN` — Address `0x0802`

**Reset value:** `0x0000`  **Access:** see fields below

GPIO input data register. Reflects current state of all GPIO pins regardless of direction.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA_IN` | `[15:0]` | R | `0x0000` | GPIO input data (synchronized to system clock). |

---
### `GPIO_IRQ_MASK` — Address `0x0803`

**Reset value:** `0x0000`  **Access:** see fields below

GPIO interrupt mask. Set bit to 1 to enable interrupt generation on GPIO pin change.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MASK` | `[15:0]` | RW | `0x0000` | Per-pin interrupt enable mask. |

---
### `GPIO_IRQ_STATUS` — Address `0x0804`

**Reset value:** `0x0000`  **Access:** see fields below

GPIO interrupt pending status. Bit set when GPIO pin transitions and IRQ is enabled. Read-clears.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `PENDING` | `[15:0]` | RC | `0x0000` | Per-pin interrupt pending flags. |

---
### `DAC_CTRL` — Address `0x0900`

**Reset value:** `0x0000`  **Access:** see fields below

DAC control register for VGA gain control (TGL2767) and YIG tuning outputs.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `VGA_DAC_EN` | `[0]` | RW | `0x0` | Enable VGA gain control DAC output. |
| `YIG_DAC_EN` | `[1]` | RW | `0x0` | Enable YIG tuning DAC output. |
| `MISC_DAC_EN` | `[2]` | RW | `0x0` | Enable miscellaneous auxiliary DAC output. |
| `DAC_UPDATE` | `[7]` | RW | `0x0` | Simultaneous update strobe for all DACs (self-clearing). |

---
### `VGA_GAIN` — Address `0x0901`

**Reset value:** `0x0800`  **Access:** see fields below

VGA (TGL2767-SMEVB) gain control DAC code. 16-bit value sets the variable gain amplifier attenuation.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GAIN_CODE` | `[15:0]` | RW | `0x0800` | VGA gain control DAC code. Mid-scale default (0x0800). |

---
### `VGA_ATTEN_STATUS` — Address `0x0902`

**Reset value:** `0x0000`  **Access:** see fields below

VGA attenuator status feedback. Read-only indication of current VGA state.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ATTEN_CODE` | `[11:0]` | R | `0x000` | Current VGA attenuation setting as read back from DAC. |
| `IN_RANGE` | `[12]` | R | `0x0` | VGA output signal is within linear operating range. |

---
### `SYSTEM_CTRL` — Address `0x0808`

**Reset value:** `0x0000`  **Access:** see fields below

System-level control register for receiver operating mode.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `OPERATING_MODE` | `[2:0]` | RW | `0x0` | Receiver operating mode: 0=standby, 1=calibrate, 2=receive, 3=test-loopback, 4=diagnostics. |
| `CH_SELECT` | `[5:4]` | RW | `0x0` | Active channel select: 0=ch0, 1=ch1, 2=ch2, 3=ch3. |
| `MUTE` | `[6]` | RW | `0x0` | RF mute (all amplifiers disabled, preserves settings). |
| `SOFT_RESET` | `[7]` | RW | `0x0` | Software reset pulse (self-clearing). Resets all peripherals but retains PLL lock. |
| `DATA_OUTPUT_EN` | `[8]` | RW | `0x0` | Enable data output through 60-pin SAMTEC connector. |

---
### `SYSTEM_STATUS` — Address `0x0809`

**Reset value:** `0x0000`  **Access:** see fields below

System-level status register reflecting current receiver state.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MODE` | `[2:0]` | R | `0x0` | Current operating mode readback. |
| `ACTIVE_CH` | `[5:4]` | R | `0x0` | Currently active channel. |
| `DATA_OVERFLOW` | `[6]` | RC | `0x0` | Output data buffer overflow detected (read clears). |
| `SYNC_LOST` | `[7]` | RC | `0x0` | Multi-channel synchronization lost (read clears). |
| `CAL_IN_PROGRESS` | `[8]` | R | `0x0` | Calibration sequence is in progress. |
| `INIT_DONE` | `[15]` | R | `0x0` | FPGA initialisation complete flag. |
