# Glue Logic Requirements (GLR)
## For: yhh

| Document Title | Glue Logic Requirements |
|---|---|
| Version Date | 24.04.2026 |
| Version Number | 0V01 |

## 1. Scope
This document specifies the I/O details and functional requirements of the FPGA for yhh.

## 2. References
### 2.1 External
| Doc. Type | Part No. | Description |
|---|---|---|
| Datasheet | FPGA | Artix-7 FPGA Family |

### 2.2 Internal
| Reference | Document |
|---|---|
| [HRS] | Hardware Requirements Specification |

## 3. Acronyms
| Acronym | Expansion |
|---|---|
| FPGA | Field Programmable Gate Array |
| UART | Universal Asynchronous Receiver-Transmitter |
| SPI | Serial Peripheral Interface |
| I2C | Inter-Integrated Circuit |
| GPIO | General Purpose Input/Output |
| JTAG | Joint Test Action Group |

## 4. Module Overview

**DIGITAL SECTION:**
FPGA-based control module providing command and control signal distribution.

**POWER SUPPLY SECTION:**
Multi-rail power supply: +3.3V (I/O), +1.8V (FPGA I/O), +1.0V (FPGA core).

## 5. Features
- Artix-7 FPGA for control and signal processing
- UART communication interface
- SPI interface for EEPROM and Flash memory
- I2C interface for temperature and power monitoring
- JTAG debug port

## 6. FPGA Description
| S.NO | PARAMETERS | SPECIFICATION |
|---|---|---|
| 1 | Part Number | XC7A200T-1FB676I |
| 2 | Logic Cells | 215,360 |
| 3 | CLB Flip-Flops | 33,650 |
| 4 | Number of Gates | 1,000,000 |
| 5 | Maximum Distributed RAM (Kb) | 2,888 |
| 6 | Total Block RAM (Kb) | 13,140 |
| 7 | Maximum Single-Ended I/Os | 400 |
| 8 | Maximum DSP Slices | 740 |
| 9 | No of IO Bank | 10 |

## 8. Pinout Details
| S.No | Signal Name | Pin No | Voltage Level | Direction wrt FPGA | Source | Destination | Default | Standard |
|---|---|---|---|---|---|---|---|---|
| 1 | UART_TX | - | 3.3V | OUTPUT | FPGA | USB-UART | High-Z | LVTTL |
| 2 | UART_RX | - | 3.3V | INPUT | USB-UART | FPGA | High-Z | LVTTL |
| 3 | SPI_CLK | - | 3.3V | OUTPUT | FPGA | EEPROM | Low | LVTTL |
| 4 | SPI_MOSI | - | 3.3V | OUTPUT | FPGA | EEPROM | Low | LVTTL |
| 5 | SPI_MISO | - | 3.3V | INPUT | EEPROM | FPGA | High-Z | LVTTL |
| 6 | SPI_CS_N | - | 3.3V | OUTPUT | FPGA | EEPROM | High | LVTTL |
| 7 | I2C_SCL | - | 3.3V | OUTPUT | FPGA | Temp Sensor | High | LVTTL |
| 8 | I2C_SDA | - | 3.3V | BIDIR | FPGA | Temp Sensor | High | LVTTL |
| 9 | TCK | - | 3.3V | INPUT | JTAG | FPGA | Low | LVTTL |
| 10 | TDI | - | 3.3V | INPUT | JTAG | FPGA | Low | LVTTL |
| 11 | TDO | - | 3.3V | OUTPUT | FPGA | JTAG | Low | LVTTL |
| 12 | TMS | - | 3.3V | INPUT | JTAG | FPGA | High | LVTTL |

## 9. Functional Specifications
| S.No. | Function Name | Description |
|---|---|---|
| 1 | Serial Communication | UART between PC & FPGA via USB-UART |
| 2 | Flash Interfaces | Configuration and storage flash via SPI |
| 3 | Temperature Monitoring | I2C-based temperature monitoring |
| 4 | FPGA Remote Programming | Configuration loading via UART |

### 9.1 Serial Communication Interface
UART interface between host PC and FPGA via USB-UART converter.
- Baud Rate: 115200 bps (default) or 12 Mbps (high speed)
- Frame: 1 start + 8 data + 1 stop, no parity

## Annexure A — RTM
| S.No. | Requirement ID | Description | GLR Section |
|---|---|---|---|
| 1 | HRS-001 | Serial Communication | 9.1 |

_Note: Re-run Phase 6 for complete LLM-generated GLR._
