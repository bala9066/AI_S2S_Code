# Software Requirements Specification (SRS)

## Document Control
| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 19 April 2026 | — | Initial Release |

---

# 1. Introduction

## 1.1 Purpose
This Software Requirements Specification (SRS) defines the software requirements for the dgh radar RF front-end receiver system. The document provides a comprehensive set of requirements, constraints, and guidelines for the design, development, verification, and acceptance of the software components that constitute the dgh system. This specification serves as the authoritative source for software requirements that shall be met throughout the system lifecycle, from initial design through to final acceptance testing and deployment.

The software shall control the FPGA-based digital section of the dgh system, managing power sequencing, monitoring critical parameters, and providing a control interface to the system. It interfaces with an MCP23017 I/O expander for digital control signals, an AD7416 temperature sensor, and an LTC2992 power monitor. The software implements power-on sequencing, protection circuits, and status monitoring, with all status and control available via a UART interface for remote operation.

This document will be used by firmware engineers for implementation, test engineers for verification planning, and system integrators for integration activities. The requirements herein shall be traced to higher-level specifications (HRS, GLR) and decomposed into detailed design specifications during the software design phase.

## 1.2 Scope
This specification covers all software components required for the dgh radar RF front-end receiver system. The software shall execute on the Xilinx XC7Z020-1CLG400C Zynq-7000 SoC FPGA and is responsible for:

- System initialization and boot sequence
- Power sequencing for RF components
- Monitoring of system parameters (temperature, voltage, current)
- Control of RF components via MCP23017 I/O expander
- UART communication protocol for control interface
- Data logging and fault handling
- Built-in self-test (POST) functionality

The scope includes the firmware running on the ARM Cortex-A9 processor within the Zynq SoC, as well as any hardware description language (HDL) code implemented in the FPGA fabric to support the required functionality.

The scope does not include requirements for:
- The downstream superheterodyne receiver software
- RF signal processing algorithms
- Device drivers for any interfaces not explicitly specified in the GLR
- Third-party library requirements beyond those specified

## 1.3 Definitions, Acronyms, and Abbreviations

### 1.3.1 Definitions
| Term | Definition |
|------|------------|
| ARM | Advanced RISC Machines, a family of CPU designs based on the RISC architecture |
| Bitstream | The configuration data that programs the FPGA fabric |
| Boot loader | A small program responsible for loading the main application from non-volatile memory |
| DMA | Direct Memory Access, a feature that allows certain hardware subsystems to access main system memory independently of the CPU |
| Embedded system | A computer system with a dedicated function within a larger mechanical or electrical system |
| FIFO | First-In-First-Out, a method for organizing the manipulation of a data structure |
| Flash memory | A non-volatile computer storage medium that can be electrically erased and rewritten |
| Glue logic | The logic used to connect different components together that were not originally designed to work together |
| GPIO | General-Purpose Input/Output, a generic pin on an integrated circuit whose behavior can be controlled by the software |
| HAL | Hardware Abstraction Layer, a layer of software or firmware that provides a simplified interface to hardware components |
| I2C | Inter-Integrated Circuit, a multi-master, multi-slave, single-ended, serial computer bus |
| IP core | Intellectual Property core, a reusable unit of logic, cell, or integrated circuit layout design |
| ISR | Interrupt Service Routine, a routine executed in response to an interrupt |
| JTAG | Joint Test Action Group, an industry standard for verifying designs and testing printed circuit boards after manufacture |
| LUT | Look-Up Table, a component that can store a set of fixed data and return the stored data when given a certain input |
| MBIST | Memory Built-In Self-Test, a mechanism for testing memory integrated circuits |
| MCU | Microcontroller Unit, a compact microcomputer designed to govern operation of embedded systems |
| NVM | Non-Volatile Memory, a type of memory that retains stored information when power is lost |
| PCB | Printed Circuit Board, a board used to mechanically support and electrically connect electronic components |
| POST | Power-On Self-Test, a sequence of diagnostic tests performed by firmware when a system is first powered on |
| RTOS | Real-Time Operating System, an operating system that guarantees processing within specified time constraints |
| SoC | System on Chip, an integrated circuit that integrates all components of a computer or other electronic systems |
| SPI | Serial Peripheral Interface, a synchronous serial data link standard named by Motorola that operates in full duplex mode |
| UART | Universal Asynchronous Receiver/Transmitter, a piece of computer hardware that converts parallel data from a bus to serial data for transmission |
| Watchdog timer | a timer device that is used to detect and recover from malfunctions |

### 1.3.2 Acronyms and Abbreviations
| Acronym | Full Term |
|---------|-----------|
| ADC | Analog-to-Digital Converter |
| BIST | Built-In Self-Test |
| BSS | Block Started by Symbol |
| CRC | Cyclic Redundancy Check |
| DAC | Digital-to-Analog Converter |
| DMA | Direct Memory Access |
| FIFO | First-In-First-Out |
| FPGA | Field-Programmable Gate Array |
| GLR | Glue Logic Requirements |
| GPIO | General Purpose Input/Output |
| HRS | Hardware Requirements Specification |
| I2C | Inter-Integrated Circuit |
| I/O | Input/Output |
| IP | Intellectual Property |
| IP67 | Ingress Protection rating (dust tight, protected against temporary immersion) |
| ISR | Interrupt Service Routine |
| JTAG | Joint Test Action Group |
| LFM | Linear Frequency Modulation |
| LNA | Low Noise Amplifier |
| LT | Linear Technology |
| MBIST | Memory Built-In Self-Test |
| MISRA | Motor Industry Software Reliability Association |
| MCU | Microcontroller Unit |
| MHz | Megahertz (10^6 Hz) |
| MDS | Minimum Detectable Signal |
| NVM | Non-Volatile Memory |
| PCB | Printed Circuit Board |
| PLL | Phase-Locked Loop |
| POST | Power-On Self-Test |
| RAM | Random Access Memory |
| ROM | Read-Only Memory |
| RTOS | Real-Time Operating System |
| SAW | Surface Acoustic Wave |
| SDD | Software Design Description |
| SPI | Serial Peripheral Interface |
| SRS | Software Requirements Specification |
| SyRS | System Requirements Specification |
| T/R | Transmit/Receive |
| UART | Universal Asynchronous Receiver/Transmitter |
| VSWR | Voltage Standing Wave Ratio |
| WDT | Watchdog Timer |

## 1.4 References
- IEEE 830-1998: Recommended Practice for Software Requirements Specifications
- ISO/IEC/IEEE 29148:2018: Systems and Software Engineering — Life Cycle Processes — Requirements Engineering
- IEEE 1016-2009: Software Design Descriptions
- MISRA C:2012: Guidelines for the Use of the C Language in Critical Systems
- IEC 61508: Functional Safety of E/E/PE Safety-related Systems
- Hardware Requirements Specification (HRS) — dgh Project
- Glue Logic Requirements (GLR) — dgh Project
- Xilinx Zynq-7000 Technical Reference Manual
- Microchip MCP23017 Datasheet
- Analog Devices AD7416 Datasheet
- Linear Technology LTC2992 Datasheet
- TDK SAW-518-HP Datasheet
- Qorvo QPL9057 Datasheet
- Analog Devices ADL5545 Datasheet

## 1.5 Overview
This document provides a comprehensive specification for the software requirements of the dgh radar RF front-end receiver system. The software shall execute on the Xilinx XC7Z020-1CLG400C Zynq-7000 SoC and be responsible for system initialization, power sequencing, monitoring of system parameters, control of RF components, UART communication, data logging, and fault handling.

The document is structured as follows:
- Section 2 provides an overall description of the software product, including its perspective, functions, user characteristics, constraints, assumptions, and dependencies.
- Section 3 presents the specific software requirements, including external interfaces, functional requirements, performance requirements, design constraints, and software system attributes.
- Section 4 details the verification and validation requirements for the software.
- Section 5 provides a requirements traceability matrix linking software requirements to higher-level requirements.
- Appendices include error codes, register map summaries, and diagrams illustrating software architecture and behavior.

All requirements in this document are uniquely identified with a REQ-SW-xxx identifier for traceability throughout the development lifecycle. Each requirement includes a source reference to the higher-level requirement it implements, a priority classification, and a verification method.

---

# 2. Overall Description

## 2.1 Product Perspective
The dgh radar RF front-end receiver software operates on the Xilinx XC7Z020-1CLG400C Zynq-7000 SoC, which combines an ARM Cortex-A9 processor with FPGA fabric. The software forms the digital control layer of the RF front-end system, sitting above the hardware abstraction layer and below the application layer.

### System Context
The software system fits within the larger dgh system architecture as follows:

```
+-------------------------+      +------------------------+
|                         |      |                        |
|  Host System (PC/MCU)    |----->|  dgh RF Front-End     |
|                         |      |                        |
+-------------------------+      |                        |
                                | +---------------------+ |
                                | | Software Layer      | |
                                | | - Control Logic     | |
                                | | - Monitoring        | |
                                | | - Communication     | |
                                | +---------------------+ |
                                |                        |
                                | +---------------------+ |
                                | | Hardware Abstraction | |
                                | | Layer (HAL)         | |
                                | +---------------------+ |
                                |                        |
                                | +---------------------+ |
                                | | Physical Hardware    | |
                                | | - FPGA              | |
                                | | - Sensors           | |
                                | | - Memory            | |
                                | +---------------------+ |
                                |                        |
+-------------------------+      +------------------------+
| Downstream Receiver     |<-----|
| (Superheterodyne)       |      |
|                         |      |
+-------------------------+      +------------------------+
```

### Hardware Interfaces
The software interfaces directly with the following hardware components:
- Xilinx Zynq-7000 SoC (processor and FPGA fabric)
- MCP23017 I/O expander (RF component control)
- AD7416 temperature sensor (temperature monitoring)
- LTC2992 power monitor (voltage and current monitoring)
- AT24C256 EEPROM (configuration storage)
- IS25LP256D Flash memory (firmware storage and configuration)
- UART interface (external communication)

### External Systems
The software communicates with the following external systems:
- Host system (PC or external controller) via UART
- Downstream superheterodyne receiver (status information only)

### Software Stack
The software stack consists of the following layers:
1. **Hardware Layer**: Physical components including FPGA, sensors, memory, and communication interfaces
2. **Hardware Abstraction Layer (HAL)**: Drivers for all hardware components
3. **Middleware Layer**: Communication protocols and system services
4. **Application Layer**: High-level control logic, monitoring, and status reporting

## 2.2 Product Functions
The software shall implement the following major functions:

1. **System Initialization and Boot Sequence**
   - Power-on reset handling
   - Clock initialization
   - PLL configuration and lock management
   - Peripheral initialization (UART, SPI, I2C, GPIO)
   - Boot loader functionality for loading main application from Flash

2. **Hardware Abstraction Layer (HAL)**
   - UART driver for external communication
   - SPI driver for Flash memory access
   - I2C driver for sensor communication (AD7416, LTC2992, MCP23017)
   - GPIO driver for general-purpose I/O control
   - Watchdog timer driver for system reliability

3. **Power Sequencing and Management**
   - Power-on sequence control for RF components
   - Power rail monitoring and fault detection
   - Power-down sequence for graceful shutdown
   - Power budget management and optimization

4. **Temperature Monitoring and Control**
   - Temperature reading from AD7416 sensor
   - Temperature threshold monitoring
   - Temperature alert generation
   - Thermal management control

5. **RF Component Control**
   - Control of LNA biasing via MCP23017
   - Configuration of filter parameters (if applicable)
   - RF enable/disable control
   - Gain adjustment control

6. **System Monitoring**
   - Voltage monitoring via LTC2992
   - Current monitoring via LTC2992
   - Status monitoring for all critical components
   - Fault detection and reporting

7. **UART Communication Protocol**
   - Implementation of register read/write protocol
   - Command parsing and validation
   - Response generation
   - Error handling for invalid commands

8. **Data Logging**
   - Event logging to non-volatile memory
   - System parameter logging
   - Fault event logging with timestamps
   - Log retrieval via UART interface

9. **Built-In Self-Test (POST)**
   - Power-on self-test execution
   - Peripheral communication test
   - Memory test (RAM and Flash)
   - Sensor functionality test

10. **Watchdog Timer Management**
    - Watchdog initialization
    - Regular watchdog "petting" (refresh)
    - Watchdog timeout handling
    - Watchdog status reporting

11. **Error Handling and Recovery**
    - Error detection and classification
    - Error logging
    - Recovery procedures for common errors
    - Safe state management during error conditions

12. **Configuration Management**
    - Loading configuration from EEPROM
    - Configuration validation
    - Runtime parameter adjustment
    - Configuration backup to Flash

13. **Firmware Update**
    - Firmware image validation
    - Firmware update via UART
    - Boot image selection and management
    - Update status reporting

14. **System Status Reporting**
    - Health status reporting
    - Temperature status reporting
    - Power status reporting
    - Component status reporting

15. **Debug Interface Support**
    - JTAG debugging support
    - Runtime status reporting via debug interface
    - Memory dump capability
    - Register read/write via debug interface

## 2.3 User Characteristics
The software shall be designed to be used by the following user groups:

### Firmware Engineers (Primary Developers)
- Technical background: Embedded systems programming, C programming, FPGA development
- Skills: Experience with ARM processors, Zynq SoC, embedded Linux (if applicable), hardware drivers
- Usage: Development, testing, and integration of the software
- Requirements: Detailed debugging capabilities, extensive logging, comprehensive APIs

### Test Engineers (System-Level Test)
- Technical background: Test methodologies, automated testing, system integration
- Skills: Experience with test equipment, scripting, validation processes
- Usage: System testing, validation, and verification
- Requirements: Access to all system parameters, programmable test modes, comprehensive status reporting

### Field Engineers (Diagnostics)
- Technical background: Electronics troubleshooting, field repair, diagnostics
- Skills: Experience with diagnostic tools, system debugging, repair procedures
- Usage: Field diagnostics, troubleshooting, maintenance
- Requirements: Remote diagnostic capabilities, fault isolation, detailed error reporting

### System Integrators
- Technical background: System integration, interfaces, interoperability
- Skills: Experience with multiple systems integration, interface protocols, system architecture
- Usage: Integration of the dgh system with other components
- Requirements: Well-defined interfaces, comprehensive documentation, clear status reporting

## 2.4 Constraints
The software development and operation shall be subject to the following constraints:

1. **MISRA-C:2012 Compliance**: All software shall comply with MISRA-C:2012 guidelines for safety-critical embedded systems.

2. **Memory Constraints**: The software shall operate within the memory limits of the target Zynq-7000 SoC:
   - Maximum RAM usage: 256KB
   - Maximum Flash usage: 16MB

3. **Real-Time Requirements**: Critical functions shall meet real-time constraints:
   - UART command response time: <10ms
   - Temperature monitoring interval: 1s
   - Power monitoring interval: 1s
   - Watchdog timeout: 100ms (configurable)

4. **Operating Environment**: The software shall operate reliably in the specified environmental conditions:
   - Operating temperature: -55°C to +125°C
   - Vibration: MIL-STD-810 heavy vibration
   - Power supply: +28V ±10%

5. **Development Tools**: The software shall be developed using the following tools:
   - Compiler: GCC for ARM or ARMCC
   - IDE: Xilinx Vivado or equivalent
   - Debug tools: JTAG debugger
   - Version control: Git or equivalent

6. **Language Requirements**: The software shall be written in C (C99 or C11 standard), with no C++ unless specifically required for a particular component.

7. **No Dynamic Memory Allocation**: Dynamic memory allocation (malloc/free) is forbidden due to real-time requirements and memory fragmentation concerns.

8. **Portability**: The software shall be designed with hardware abstraction to facilitate porting to different hardware platforms while maintaining the same functionality.

## 2.5 Assumptions and Dependencies
The software makes the following assumptions about the system:

### Hardware Assumptions
1. The power supply shall be stable at +28V ±10% before software initialization begins.
2. The clock oscillator (125MHz) shall be stable and accurate within ±50ppm.
3. All hardware components shall be properly connected and functional as specified in the GLR.
4. The FPGA fabric shall be properly configured before software execution begins.
5. Memory devices (Flash, EEPROM) shall be accessible at their specified addresses.

### Environmental Assumptions
1. The operating temperature shall remain within the specified range of -55°C to +125°C.
2. The system shall not be exposed to electromagnetic fields exceeding the specified EMI limits.
3. The system shall be protected against physical damage and contamination as specified by the IP67 rating.
4. Power sequencing shall follow the specified sequence to prevent damage to RF components.

### System Assumptions
1. The downstream receiver shall be properly connected and ready to receive signals.
2. No simultaneous access to shared resources by multiple systems.
3. The UART interface shall be available for communication during operation.
4. The watchdog timer shall be properly initialized and regularly serviced.

### Dependencies
1. The software depends on the hardware being manufactured according to the HRS and GLR specifications.
2. The software depends on the presence of the boot loader for proper system startup.
3. The software depends on the FPGA configuration being properly loaded before execution.
4. The software depends on the system being properly integrated with the host system and downstream receiver.

---

# 3. Specific Requirements

## 3.1 External Interface Requirements

### 3.1.1 Hardware Interfaces
The software shall interface with the following hardware components through appropriate drivers and APIs.

#### 3.1.1.1 UART Interface
The UART interface shall provide communication with external systems for control, monitoring, and firmware updates.

```c
/**
 * @brief UART Register Map
 */
typedef struct {
    volatile uint16_t BAUD_DIV;    // 0x0100: Baud rate divisor
    volatile uint16_t CTRL;        // 0x0101: Control register
    volatile uint16_t STATUS;      // 0x0102: Status register
    volatile uint16_t TX_COUNT;    // 0x0103: TX FIFO count
    volatile uint16_t RX_COUNT;    // 0x0104: RX FIFO count
    volatile uint16_t TX_DATA;     // 0x0105: TX data register
    volatile uint16_t RX_DATA;     // 0x0106: RX data register
} UART_RegMap_t;

/**
 * @brief Initialize UART interface
 * @param baud_rate Desired baud rate (e.g., 115200)
 * @return int32_t 0 on success, error code on failure
 */
int32_t UART_Init(uint32_t baud_rate);

/**
 * @brief Write a register value
 * @param addr Register address (0x0100-0x0106)
 * @param data Data to write
 * @return int32_t 0 on success, error code on failure
 */
int32_t UART_WriteReg(uint16_t addr, uint16_t data);

/**
 * @brief Read a register value
 * @param addr Register address (0x0100-0x0106)
 * @param data Pointer to store read data
 * @return int32_t 0 on success, error code on failure
 */
int32_t UART_ReadReg(uint16_t addr, uint16_t *data);

/**
 * @brief Write multiple register values consecutively
 * @param start_addr Starting register address
 * @param data Pointer to data array
 * @param count Number of registers to write
 * @return int32_t 0 on success, error code on failure
 */
int32_t UART_BulkWrite(uint16_t start_addr, const uint16_t *data, uint8_t count);

/**
 * @brief Read multiple register values consecutively
 * @param start_addr Starting register address
 * @param buf Buffer to store read data
 * @param count Number of registers to read
 * @return int32_t 0 on success, error code on failure
 */
int32_t UART_BulkRead(uint16_t start_addr, uint16_t *buf, uint8_t count);

/**
 * @brief Check if UART is ready for transmission
 * @return int32_t 1 if ready, 0 if not ready
 */
int32_t UART_IsTxReady(void);

/**
 * @brief Check if UART has received data
 * @return int32_t 1 if data available, 0 if no data
 */
int32_t UART_IsRxReady(void);

/**
 * @brief Write a byte to UART
 * @param data Byte to write
 * @return int32_t 0 on success, error code on failure
 */
int32_t UART_WriteByte(uint8_t data);

/**
 * @brief Read a byte from UART
 * @param data Pointer to store read byte
 * @return int32_t 0 on success, error code on failure
 */
int32_t UART_ReadByte(uint8_t *data);
```

Error handling procedure for UART interface:
1. On write timeout (if supported by hardware), return ERR_TIMEOUT
2. On read timeout (if supported by hardware), return ERR_TIMEOUT
3. On framing error (detected by hardware), clear error flag and return ERR_COMM
4. On FIFO overflow, reset FIFO and return ERR_OVERFLOW
5. On invalid register address, return ERR_PARAM

#### 3.1.1.2 SPI Interface (Flash Memory)
The SPI interface shall provide access to the IS25LP256D Flash memory for firmware storage and configuration.

```c
/**
 * @brief SPI Register Map
 */
typedef struct {
    volatile uint16_t CTRL;        // 0x0200: Control register
    volatile uint16_t STATUS;      // 0x0201: Status register
    volatile uint16_t CLK_DIV;     // 0x0202: Clock divider
    volatile uint16_t TX_DATA;     // 0x0203: TX data register
    volatile uint16_t RX_DATA;     // 0x0204: RX data register
    volatile uint16_t ADDR_HI;     // 0x0205: Address high byte
    volatile uint16_t ADDR_LO;     // 0x0206: Address low byte
    volatile uint16_t LEN;        // 0x0207: Transfer length
} SPI_RegMap_t;

/**
 * @brief Initialize SPI interface
 * @param clock_hz Clock frequency in Hz
 * @param mode SPI mode (0-3)
 * @return int32_t 0 on success, error code on failure
 */
int32_t SPI_Init(uint32_t clock_hz, uint8_t mode);

/**
 * @brief Perform SPI transfer
 * @param tx_data Pointer to transmit data (NULL if only receiving)
 * @param rx_data Pointer to receive data (NULL if only transmitting)
 * @param length Number of bytes to transfer
 * @return int32_t 0 on success, error code on failure
 */
int32_t SPI_Transfer(const uint8_t *tx_data, uint8_t *rx_data, uint16_t length);

/**
 * @brief Read a byte from Flash memory
 * @param addr Address to read from
 * @param data Pointer to store read byte
 * @return int32_t 0 on success, error code on failure
 */
int32_t Flash_ReadByte(uint32_t addr, uint8_t *data);

/**
 * @brief Write a byte to Flash memory
 * @param addr Address to write to
 * @param data Byte to write
 * @return int32_t 0 on success, error code on failure
 */
int32_t Flash_WriteByte(uint32_t addr, uint8_t data);

/**
 * @brief Read a sector from Flash memory
 * @param addr Starting address of sector
 * @param buf Buffer to store read data
 * @param len Number of bytes to read
 * @return int32_t 0 on success, error code on failure
 */
int32_t Flash_ReadSector(uint32_t addr, uint8_t *buf, uint32_t len);

/**
 * @brief Write a sector to Flash memory
 * @param addr Starting address of sector
 * @param buf Buffer containing data to write
 * @param len Number of bytes to write
 * @return int32_t 0 on success, error code on failure
 */
int32_t Flash_WriteSector(uint32_t addr, const uint8_t *buf, uint32_t len);

/**
 * @brief Erase a sector in Flash memory
 * @param addr Address within sector to erase
 * @return int32_t 0 on success, error code on failure
 */
int32_t Flash_EraseSector(uint32_t addr);

/**
 * @brief Erase entire Flash memory
 * @return int32_t 0 on success, error code on failure
 */
int32_t Flash_EraseChip(void);
```

Error handling procedure for SPI interface:
1. On SPI timeout, return ERR_TIMEOUT
2. On SPI bus error (collision, mode fault), reset interface and return ERR_COMM
3. On Flash write/verify failure, return ERR_FLASH_WRITE
4. On Flash erase failure, return ERR_FLASH_ERASE
5. On invalid address range, return ERR_PARAM

#### 3.1.1.3 I2C Interface (Temperature and Power Monitoring)
The I2C interface shall provide communication with the AD7416 temperature sensor and LTC2992 power monitor.

```c
/**
 * @brief I2C Register Map
 */
typedef struct {
    volatile uint16_t CTRL;        // 0x0300: Control register
    volatile uint16_t STATUS;      // 0x0301: Status register
    volatile uint16_t CLK_DIV;     // 0x0302: Clock divider
    volatile uint16_t DEV_ADDR;    // 0x0303: Device address
    volatile uint16_t DATA;        // 0x0304: Data register
} I2C_RegMap_t;

/**
 * @brief Initialize I2C interface
 * @param clock_hz Clock frequency in Hz
 * @return int32_t 0 on success, error code on failure
 */
int32_t I2C_Init(uint32_t clock_hz);

/**
 * @brief Read an 8-bit register
 * @param dev_addr I2C device address
 * @param reg_addr Register address
 * @param data Pointer to store read data
 * @return int32_t 0 on success, error code on failure
 */
int32_t I2C_ReadReg8(uint8_t dev_addr, uint8_t reg_addr, uint8_t *data);

/**
 * @brief Write an 8-bit register
 * @param dev_addr I2C device address
 * @param reg_addr Register address
 * @param data Data to write
 * @return int32_t 0 on success, error code on failure
 */
int32_t I2C_WriteReg8(uint8_t dev_addr, uint8_t reg_addr, uint8_t data);

/**
 * @brief Read a 16-bit register
 * @param dev_addr I2C device address
 * @param reg_addr Register address
 * @param data Pointer to store read data
 * @return int32_t 0 on success, error code on failure
 */
int32_t I2C_ReadReg16(uint8_t dev_addr, uint8_t reg_addr, uint16_t *data);

/**
 * @brief Write a 16-bit register
 * @param dev_addr I2C device address
 * @param reg_addr Register address
 * @param data Data to write
 * @return int32_t 0 on success, error code on failure
 */
int32_t I2C_WriteReg16(uint8_t dev_addr, uint8_t reg_addr, uint16_t data);

/**
 * @brief Read temperature from AD7416 sensor
 * @param temp_degC Pointer to store temperature in degrees Celsius
 * @return int32_t 0 on success, error code on failure
 */
int32_t TempSensor_ReadTemp(float *temp_degC);

/**
 * @brief Read voltage from LTC2992 monitor
 * @param channel Channel number (0-7)
 * @param voltage_V Pointer to store voltage in volts
 * @return int32_t 0 on success, error code on failure
 */
int32_t PowerMon_ReadVoltage(uint8_t channel, float *voltage_V);

/**
 * @brief Read current from LTC2992 monitor
 * @param channel Channel number (0-7)
 * @param current_A Pointer to store current in amperes
 * @return int32_t 0 on success, error code on failure
 */
int32_t PowerMon_ReadCurrent(uint8_t channel, float *current_A);

/**
 * @brief Read all power parameters from LTC2992
 * @param voltages Pointer to array of 8 voltage values
 * @param currents Pointer to array of 8 current values
 * @return int32_t 0 on success, error code on failure
 */
int32_t PowerMon_ReadAll(float *voltages, float *currents);
```

Error handling procedure for I2C interface:
1. On I2C timeout, return ERR_TIMEOUT
2. On I2C bus error (arbitration lost, bus error), reset interface and return ERR_COMM
3. On invalid device address, return ERR_PARAM
4. On invalid register address, return ERR_PARAM
5. On sensor communication failure, return ERR_HARDWARE

### 3.1.2 Software Interfaces
The software shall implement the following internal software interfaces:

#### 3.1.2.1 Hardware Abstraction Layer (HAL)
The HAL shall provide a standardized interface to hardware components, abstracting the details of specific hardware implementations.

```c
/**
 * @brief HAL initialization function
 * @return int32_t 0 on success, error code on failure
 */
int32_t HAL_Init(void);

/**
 * @brief HAL deinitialization function
 * @return int32_t 0 on success, error code on failure
 */
int32_tHAL_Deinit(void);

/**
 * @brief HAL status query function
 * @return HAL_Status_t Current HAL status
 */
HAL_Status_t HAL_GetStatus(void);
```

#### 3.1.2.2 Logging Framework
The logging framework shall provide a standardized interface for system messages, events, and errors.

```c
/**
 * @brief Log level enumeration
 */
typedef enum {
    LOG_ERROR,
    LOG_WARNING,
    LOG_INFO,
    LOG_DEBUG,
    LOG_VERBOSE
} LogLevel_t;

/**
 * @brief Log a message
 * @param level Log level
 * @param module Module name
 * @param format Format string
 * @param ... Variable arguments
 */
void Log_Message(LogLevel_t level, const char *module, const char *format, ...);

/**
 * @brief Log an error with error code
 * @param module Module name
 * @param format Format string
 * @param err Error code
 * @param ... Variable arguments
 */
void Log_Error(const char *module, const char *format, ErrorCode_t err, ...);

/**
 * @brief Initialize the logging system
 * @param log_output Output destination (UART, file, etc.)
 * @return int32_t 0 on success, error code on failure
 */
int32_t Logging_Init(uint8_t log_output);
```

### 3.1.3 Communication Interfaces
The software shall implement a UART-based register access protocol for external control and monitoring.

#### UART Register Command Protocol
The UART interface shall support the following command protocol for register access:

| Command | CMD byte | Frame Structure | Response |
|---------|----------|-----------------|----------|
| Single Write | 0x57 ('W') | [0x57][ADDR_H][ADDR_L][DATA_H][DATA_L] | [0x06] ACK |
| Single Read  | 0x52 ('R') | [0x52][ADDR_H\|0x80][ADDR_L] | [DATA_H][DATA_L] |
| Bulk Write   | 0x42 ('B') | [0x42][ADDR_H][ADDR_L][N][D0_H][D0_L]...[Dn_H][Dn_L] | [0x06] ACK |
| Bulk Read    | 0x62 ('b') | [0x62][ADDR_H\|0x80][ADDR_L][N] | [D0_H][D0_L]...[Dn_H][Dn_L] |
| Error NAK    | 0x15 | Sent by FPGA on invalid command/address | — |

Protocol specifications:
- Address space: 16-bit (0x0000–0xFFFF); read addresses have bit15 set (OR 0x8000)
- Maximum bulk count N: 64 registers per transaction
- Timeout: host must respond within 10ms; software resets parser after 50ms inter-byte gap
- ACK byte: 0x06; NAK byte: 0x15
- Optional CRC-16 CCITT (feature flag in config flash)

## 3.2 Functional Requirements

### 3.2.1 System Initialization (REQ-SW-001 to REQ-SW-010)

REQ-SW-001: The software shall complete power-on self-test within 500ms of reset de-assertion.  
**Source**: GLR §4  
**Priority**: [M]andatory  
**Verification**: [T]est

REQ-SW-002: The software shall verify BOARD_ID register matches expected value 0x0201 on startup; fault if mismatch.  
**Source**: GLR §5.1  
**Priority**: [M]andatory  
**Verification**: [T]est

REQ-SW-003: The software shall configure PLL to target frequency 125 MHz within 100ms of initialization.  
**Source**: GLR §4.1  
**Priority**: [M]andatory  
**Verification**: [T]est

REQ-SW-004: The software shall poll PLL_STATUS.LOCKED bit with 100ms timeout; assert ERROR if timeout.  
**Source**: GLR §4.1  
**Priority**: [M]andatory  
**Verification**: [T]est

REQ-SW-005: The software shall initialize all SPI, I2C, and UART peripherals within 50ms of PLL lock.  
**Source**: GLR §4.2  
**Priority**: [M]andatory  
**Verification**: [T]est

REQ-SW-006: The software shall load calibration data from EEPROM at address 0x0100 into RAM on startup.  
**Source**: HRS §3.2  
**Priority**: [M]andatory  
**Verification**: [T]est

REQ-SW-007: The software shall initialize watchdog timer with 100ms timeout before entering main loop.  
**Source**: GLR §5.4  
**Priority**: [M]andatory  
**Verification**: [T]est

REQ-SW-008: The software shall log firmware version "dgh_v1.0" to UART on startup.  
**Source**: GLR §5  
**Priority**: [D]esirable  
**Verification**: [T]est

REQ-SW-009: The software shall perform RAM BIST on 256KB of SRAM with a pattern coverage of 100%.  
**Source**: GLR §4.3  
**Priority**: [D]esirable  
**Verification**: [T]est

REQ-SW-010: The software shall set STATUS_LED to BLINKING at 1Hz during initialization.  
**Source**: GLR §5.3  
**Priority**: [O]ptional  
**Verification**: [T]est

### 3.2.2 UART Communication Driver (REQ-SW-011 to REQ-SW-020)

REQ-SW-011: The UART driver shall support baud rates of 9600, 19200, 38400, 57600, and 115200.  
**Source**: GLR §5.1  
**Priority**: [M]andatory  
**Verification**: [T]est

REQ-SW-012: The driver shall implement the Single Write command (0x57) as defined in the GLR frame format.  
**Source**: GLR §6.3  
**Priority**: [M]andatory  
**Verification**: [T]est

REQ-SW-013: The driver shall implement the Single Read command (0x52) with ADDR bit15=1.  
**Source**: GLR §6.3  
**Priority**: [M]andatory  
**Verification**: [T]est

REQ-SW-014: The driver shall implement the Bulk Write command (0x42) for up to 64 consecutive registers.  
**Source**: GLR §6.3  
**Priority**: [M]andatory  
**Verification**: [T]est

REQ-SW-015: The driver shall implement the Bulk Read command (0x62) for up to 64 consecutive registers.  
**Source**: GLR §6.3  
**Priority**: [M]andatory  
**Verification**: [T]est

REQ-SW-016: The driver shall respond to an invalid command byte with NAK (0x15) within 100µs.  
**Source**: GLR §6.3  
**Priority**: [M]andatory  
**Verification**: [T]est

REQ-SW-017: The driver shall support a TX FIFO of at least 256 bytes with no blocking for small writes.  
**Source**: GLR §5.1  
**Priority**: [M]andatory  
**Verification**: [T]est

REQ-SW-018: The driver shall support an RX FIFO of at least 256 bytes with overflow protection.  
**Source**: GLR §5.1  
**Priority**: [M]andatory  
**Verification**: [T]est

REQ-SW-019: The driver shall clear UART_STATUS.FRAME_ERR flag on read and log the error.  
**Source**: GLR §5.1  
**Priority**: [D]esirable  
**Verification**: [T]est

REQ-SW-020: The driver shall recover from framing errors without hardware reset by reinitializing the UART.  
**Source**: GLR §5.1  
**Priority**: [D]esirable  
**Verification**: [T]est

### 3.2.3 Temperature Monitoring (REQ-SW-021 to REQ-SW-030)

REQ-SW-021: The software shall read temperature from the AD7416 sensor every 2 seconds.  
**Source**: GLR §4.2  
**Priority**: [M]andatory  
**Verification**: [T]est

REQ-SW-022: The software shall generate a TEMP_ALERT interrupt when temperature exceeds 85°C.  
**Source**: HRS §3.5  
**Priority**: [M]andatory  
**Verification**: [T]est

REQ-SW-023: The software shall log temperature values to STATUS_REGISTER every 10 seconds.  
**Source**: GLR §5.2  
**Priority**: [D]esirable  
**Verification**: [T]est

REQ-SW-024: The software shall disable RF output (RF_ENABLE=0) when temperature exceeds 100°C.  
**Source**: HRS §3.5  
**Priority**: [M]andatory  
**Verification**: [T]est

REQ-SW-025: The software shall re-enable RF output when temperature drops below 95°C (hysteresis).  
**Source**: HRS §3.5  
**Priority**: [M]andatory  
**Verification**: [T]est

REQ-SW-026: The software shall implement a temperature monitoring state machine with NORMAL, ALERT, and SHUTDOWN states.  
**Source**: GLR §4.2  
**Priority**: [M]andatory  
**Verification**: [T]est

REQ-SW-027: The software shall record temperature events exceeding thresholds with timestamps to the fault log.  
**Source**: GLR §5.4  
**Priority**: [D]esirable  
**Verification**: [T]est

REQ-SW-028: The software shall support querying the current temperature via the UART register protocol.  
**Source**: GLR §6.3  
**Priority**: [M]andatory  
**Verification**: [T]est

REQ-SW-029: The software shall verify AD7416 sensor communication integrity on startup.  
**Source**: GLR §4.3  
**Priority**: [M]andatory  
**Verification**: [T]est

REQ-SW-030: The software shall implement a software temperature filter to reduce noise in temperature readings.  
**Source**: GLR §4.2  
**Priority**: [O]ptional  
**Verification**: [T]est

### 3.2.4 Power Monitoring (REQ-SW-031 to REQ-SW-040)

REQ-SW-031: The software shall read all voltage channels from the LTC2992 every 2 seconds.  
**Source**: GLR §4.2  
**Priority**: [M]andatory  
**Verification**: [T]est

REQ-SW-032: The software shall read all current channels from the LTC2992 every 2 seconds.  
**Source**: GLR §4.2  
**Priority**: [M]andatory  
**Verification**: [T]est

REQ-SW-033: The software shall assert a fault condition if any rail deviates >5% from nominal voltage.  
**Source**: HRS §3.4  
**Priority**: [M]andatory  
**Verification**: [T]est

REQ-SW-034: The software shall log power rail status to STATUS_REGISTER every 10 seconds.  
**Source**: GLR §5.2  
**Priority**: [D]esirable  
**Verification**: [T]est

REQ-SW-035: The software shall implement a power-on sequence for +5V, +3.3V, +1.8V, and +1.0V rails.  
**Source**: GLR §4.1  
**Priority**: [M]andatory  
**Verification**: [T]est

REQ-SW-036: The software shall verify each power rail is within tolerance before enabling dependent components.  
**Source**: HRS §3.4  
**Priority**: [M]andatory  
**Verification**: [T]est

REQ-SW-037: The software shall support querying the current power rail status via the UART register protocol.  
**Source**: GLR §6.3  
**Priority**: [M]andatory  
**Verification**: [T]est

REQ-SW-038: The software shall implement a power-down sequence when commanded via UART or on critical fault.  
**Source**: GLR §4.1  
**Priority**: [M]andatory  
**Verification**: [T]est

REQ-SW-039: The software shall record power rail events exceeding thresholds with timestamps to the fault log.  
**Source**: GLR §5.4  
**Priority**: [D]esirable  
**Verification**: [T]est

REQ-SW-040: The software shall verify LTC2992 sensor communication integrity on startup.  
**Source**: GLR §4.3  
**Priority**: [M]andatory  
**Verification**: [T]est

### 3.2.5 RF Component Control (REQ-SW-041 to REQ-SW-050)

REQ-SW-041: The software shall control RF components via the MCP23017 I/O expander.  
**Source**: GLR §4.2  
**Priority**: [M]andatory  
**Verification**: [T]est

REQ-SW-042: The software shall provide independent control for each of the 4 RF channels.  
**Source**: HRS §3.1  
**Priority**: [M]andatory  
**Verification**: [T]est

REQ-SW-043: The software shall enable/disable LNA biasing through the MCP23017 GPIO pins.  
**Source**: GLR §4.2  
**Priority**: [M]andatory  
**Verification**: [T]est

REQ-SW-044: The software shall set RF output power through digital gain control bits.  
**Source**: GLR §4.2  
**Priority**: [M]andatory  
**Verification**: [T]est

REQ-SW-045: The software shall implement RF_ENABLE signal control for each channel.  
**Source**: HRS §3.1  
**Priority**: [M]andatory  
**Verification**: [T]est

REQ-SW-046: The software shall support querying the RF channel status via the UART register protocol.  
**Source**: GLR §6.3  
**Priority**: [M]andatory  
**Verification**: [T]est

REQ-SW-047: The software shall verify MCP23017 communication integrity on startup.  
**Source**: GLR §4.3  
**Priority**: [M]andatory  
**Verification**: [T]est

REQ-SW-048: The software shall implement RF calibration data loading from Flash memory.  
**Source**: GLR §4.4  
**Priority**: [D]esirable  
**Verification**: [T]est

REQ-SW-049: The software shall support RF gain adjustment in 1dB steps from 0 to 60dB.  
**Source**: HRS §3.2  
**Priority**: [M]andatory  
**Verification**: [T]est

REQ-SW-050: The software shall implement RF band selection through filter control bits.  
**Source**: GLR §4.2  
**Priority**: [D]esirable  
**Verification**: [T]est

### 3.2.6 Data Logging and Fault Handling (REQ-SW-051 to REQ-SW-060)

REQ-SW-051: The software shall maintain a circular fault log buffer in EEPROM with minimum 64 entries.  
**Source**: GLR §5.4  
**Priority**: [M]andatory  
**Verification**: [T]est

REQ-SW-052: The software shall log all detected faults with timestamp, error code, and parameter values.  
**Source**: GLR §5.4  
**Priority**: [M]andatory  
**Verification**: [T]est

REQ-SW-053: The software shall implement a UART diagnostic command (0xD0) that dumps the fault log.  
**Source**: GLR §6.3  
**Priority**: [M]andatory  
**Verification**: [T]est

REQ-SW-054: The software shall maintain a software execution counter (uptime seconds) readable via UART.  
**Source**: GLR §5.2  
**Priority**: [D]esirable  
**Verification**: [T]est

REQ-SW-055: The software shall implement a graceful shutdown procedure on critical fault detection.  
**Source**: GLR §4.1  
**Priority**: [M]andatory  
**Verification**: [T]est

REQ-SW-056: The software shall implement error recovery procedures for common errors.  
**Source**: GLR §5.4  
**Priority**: [M]andatory  
**Verification**: [T]est

REQ-SW-057: The software shall implement a safe state for all components during error conditions.  
**Source**: HRS §3.5  
**Priority**: [M]andatory  
**Verification**: [T]est

REQ-SW-058: The software shall support clearing the fault log via UART command.  
**Source**: GLR §6.3  
**Priority**: [D]esirable  
**Verification**: [T]est

REQ-SW-059: The software shall implement non-volatile storage for critical configuration parameters.  
**Source**: GLR §5.4  
**Priority**: [M]andatory  
**Verification**: [T]est

REQ-SW-060: The software shall record system configuration changes with timestamps.  
**Source**: GLR §5.4  
**Priority**: [O]ptional  
**Verification**: [T]est

### 3.2.7 Built-In Self-Test (POST) (REQ-SW-061 to REQ-SW-070)

REQ-SW-061: The software shall implement a Power-On Self-Test covering RAM BIST, peripheral communication check, and PLL lock verification.  
**Source**: GLR §4.3  
**Priority**: [M]andatory  
**Verification**: [T]est

REQ-SW-062: The software shall perform a RAM BIST with a pattern coverage of 100% within 100ms.  
**Source**: GLR §4.3  
**Priority**: [M]andatory  
**Verification**: [T]est

REQ-SW-063: The software shall verify all peripheral communications (UART, SPI, I2C) during POST.  
**Source**: GLR §4.3  
**Priority**: [M]andatory  
**Verification**: [T]est

REQ-SW-064: The software shall implement a PLL lock verification test.  
**Source**: GLR §4.1  
**Priority**: [M]andatory  
**Verification**: [T]est

REQ-SW-065: The software shall perform a sensor functionality test during POST.  
**Source**: GLR §4.3  
**Priority**: [M]andatory  
**Verification**: [T]est

REQ-SW-066: The software shall perform a Flash memory test during POST.  
**Source**: GLR §4.3  
**Priority**: [M]andatory  
**Verification**: [T]est

REQ-SW-067: The software shall report POST results through the STATUS_REGISTER.  
**Source**: GLR §5.2  
**Priority**: [M]andatory  
**Verification**: [T]est

REQ-SW-068: The software shall implement a quick test mode for runtime POST verification.  
**Source**: GLR §4.3  
**Priority**: [D]esirable  
**Verification**: [T]est

REQ-SW-069: The software shall implement a comprehensive test mode for maintenance diagnostics.  
**Source**: GLR §4.3  
**Priority**: [D]esirable  
**Verification**: [T]est

REQ-SW-070: The software shall support triggering POST via UART command.  
**Source**: GLR §6.3  
**Priority**: [D]esirable  
**Verification**: [T]est

### 3.2.8 Firmware Update (REQ-SW-071 to REQ-SW-075)

REQ-SW-071: The software shall implement firmware update functionality via UART interface.  
**Source**: GLR §5.5  
**Priority**: [M]andatory  
**Verification**: [T]est

REQ-SW-072: The software shall validate firmware images with CRC-32 check before applying.  
**Source**: GLR §5.5  
**Priority**: [M]andatory  
**Verification**: [T]est

REQ-SW-073: The software shall implement a boot image selection mechanism for redundancy.  
**Source**: GLR §5.5  
**Priority**: [D]esirable  
**Verification**: [T]est

REQ-SW-074: The software shall report update status and errors through the STATUS_REGISTER.  
**Source**: GLR §5.2  
**Priority**: [M]andatory  
**Verification**: [T]est

REQ-SW-075: The software shall implement a fallback mechanism to previous firmware on update failure.  
**Source**: GLR §5.5  
**Priority**: [M]andatory  
**Verification**: [T]est

## 3.3 Performance Requirements
REQ-PERF-001: Main loop execution cycle shall complete within 10ms.  
**Source**: GLR §4.1  
**Priority**: [M]andatory  
**Verification**: [T]est

REQ-PERF-002: UART register write shall complete within 1ms end-to-end.  
**Source**: GLR §6.3  
**Priority**: [M]andatory  
**Verification**: [T]est

REQ-PERF-003: Temperature read cycle shall complete within 5ms.  
**Source**: GLR §4.2  
**Priority**: [M]andatory  
**Verification**: [T]est

REQ-PERF-004: SPI Flash page write shall complete within 100ms for 256-byte page.  
**Source**: GLR §5.5  
**Priority**: [M]andatory  
**Verification**: [T]est

REQ-PERF-005: PLL lock acquisition shall complete within 50ms.  
**Source**: GLR §4.1  
**Priority**: [M]andatory  
**Verification**: [T]est

REQ-PERF-006: System startup shall complete within 2 seconds from power-on.  
**Source**: GLR §4  
**Priority**: [M]andatory  
**Verification**: [T]est

REQ-PERF-007: ISR latency shall not exceed 20µs for critical interrupts.  
**Source**: GLR §4.1  
**Priority**: [M]andatory  
**Verification**: [T]est

REQ-PERF-008: Watchdog pet interval shall be 80ms maximum.  
**Source**: GLR §5.4  
**Priority**: [M]andatory  
**Verification**: [T]est

REQ-PERF-009: RAM usage shall not exceed 70% of available 256KB RAM.  
**Source**: GLR §4  
**Priority**: [M]andatory  
**Verification**: [A]nalysis

REQ-PERF-010: Flash usage shall not exceed 80% of available 16MB Flash.  
**Source**: GLR §5  
**Priority**: [M]andatory  
**Verification**: [A]nalysis

REQ-PERF-011: Temperature sampling rate shall be at least 0.5Hz.  
**Source**: GLR §4.2  
**Priority**: [M]andatory  
**Verification**: [T]est

REQ-PERF-012: Power monitoring refresh rate shall be at least 0.5Hz.  
**Source**: GLR §4.2  
**Priority**: [M]andatory  
**Verification**: [T]est

## 3.4 Design Constraints
REQ-DES-001: All code shall comply with MISRA-C:2012 guidelines.  
**Source**: HRS §3.4  
**Priority**: [M]andatory  
**Verification**: [I]nspection

REQ-DES-002: All code shall be written in C (C99 standard).  
**Source**: GLR §1  
**Priority**: [M]andatory  
**Verification**: [I]nspection

REQ-DES-003: No dynamic memory allocation (malloc/free) is allowed.  
**Source**: GLR §1  
**Priority**: [M]andatory  
**Verification**: [I]nspection

REQ-DES-004: All interrupt service routines shall complete within 100µs.  
**Source**: GLR §4.1  
**Priority**: [M]andatory  
**Verification**: [T]est

REQ-DES-005: All global variables accessed from interrupts shall be declared volatile.  
**Source**: GLR §4.1  
**Priority**: [M]andatory  
**Verification**: [I]nspection

REQ-DES-006: No recursion is allowed in any function.  
**Source**: GLR §1  
**Priority**: [M]andatory  
**Verification**: [I]nspection

REQ-DES-007: All functions shall have cyclomatic complexity less than 15.  
**Source**: GLR §1  
**Priority**: [D]esirable  
**Verification**: [A]nalysis

REQ-DES-008: All critical functions shall have unit test coverage of at least 80%.  
**Source**: GLR §1  
**Priority**: [D]esirable  
**Verification**: [T]est

## 3.5 Software System Attributes

### 3.5.1 Reliability
REQ-SYS-001: The system shall achieve a mean time between failures (MTBF) of 50,000 hours.  
**Source**: HRS §3.5  
**Priority**: [M]andatory  
**Verification**: [A]nalysis

REQ-SYS-002: Error detection and recovery shall be implemented for all peripheral interfaces.  
**Source**: GLR §4.2  
**Priority**: [M]andatory  
**Verification**: [T]est

REQ-SYS-003: Watchdog recovery mechanism shall reset the system if the main loop hangs.  
**Source**: GLR §5.4  
**Priority**: [M]andatory  
**Verification**: [T]est

REQ-SYS-004: The system shall continue in degraded mode if a non-critical peripheral fails.  
**Source**: HRS §3.5  
**Priority**: [D]esirable  
**Verification**: [D]emonstration

### 3.5.2 Availability
REQ-SYS-005: System availability target shall be 99.9%.  
**Source**: HRS §3.5  
**Priority**: [M]andatory  
**Verification**: [A]nalysis

REQ-SYS-006: Maximum unplanned downtime shall not exceed 8.76 hours per year.  
**Source**: HRS §3.5  
**Priority**: [M]andatory  
**Verification**: [A]nalysis

REQ-SYS-007: Startup time after power cycle shall be less than 2 seconds.  
**Source**: GLR §4  
**Priority**: [M]andatory  
**Verification**: [T]est

### 3.5.3 Security
REQ-SYS-008: No remote code execution paths shall be implemented through the UART interface.  
**Source**: GLR §6.3  
**Priority**: [M]andatory  
**Verification**: [I]nspection

REQ-SYS-009: UART register writes shall be validated against allowed address ranges.  
**Source**: GLR §6.3  
**Priority**: [M]andatory  
**Verification**: [T]est

REQ-SYS-010: Firmware update authentication shall include CRC-32 check before applying bitstream.  
**Source**: GLR §5.5  
**Priority**: [M]andatory  
**Verification**: [T]est

### 3.5.4 Maintainability
REQ-SYS-011: Cyclomatic complexity per function shall be less than 15.  
**Source**: GLR §1  
**Priority**: [D]esirable  
**Verification**: [A]nalysis

REQ-SYS-012: All functions shall be documented with Doxygen headers.  
**Source**: GLR §1  
**Priority**: [D]esirable  
**Verification**: [I]nspection

REQ-SYS-013: Unit test coverage shall be at least 80% line coverage for all HAL drivers.  
**Source**: GLR §1  
**Priority**: [D]esirable  
**Verification**: [T]est

### 3.5.5 Portability
REQ-SYS-014: Hardware abstraction layer shall isolate all hardware dependencies.  
**Source**: GLR §1  
**Priority**: [M]andatory  
**Verification**: [I]nspection

REQ-SYS-015: Platform configuration shall be contained in single header file (board_config.h).  
**Source**: GLR §1  
**Priority**: [D]esirable  
**Verification**: [I]nspection

---

# 4. Verification and Validation

## 4.1 Unit Test Requirements
The software shall be subjected to unit testing for each driver module with the following test cases:

### UART Driver
- Normal operation: Verify basic send/receive functionality
- Boundary conditions: Test minimum and maximum baud rates
- Fault injection: Test framing error recovery

### SPI Driver
- Normal operation: Verify basic SPI communication
- Boundary conditions: Test maximum transfer size
- Fault injection: Test SPI bus error recovery

### I2C Driver
- Normal operation: Verify basic I2C communication
- Boundary conditions: Test clock stretching limits
- Fault injection: Test I2C arbitration loss recovery

### GPIO Driver
- Normal operation: Verify basic GPIO input/output
- Boundary conditions: Test all GPIO pins
- Fault injection: Test concurrent access scenarios

### Temperature Monitoring
- Normal operation: Verify temperature reading accuracy
- Boundary conditions: Test temperature limits (-55°C to +125°C)
- Fault injection: Test sensor communication failure

### Power Monitoring
- Normal operation: Verify voltage/current reading accuracy
- Boundary conditions: Test all input ranges
- Fault injection: Test sensor communication failure

## 4.2 Integration Test Requirements
The software shall be subjected to integration testing with the following test cases:

- UART loopback self-test (REQ-SW-075 verification)
- SPI EEPROM write–read–verify (REQ-SW-006 verification)
- Temperature sensor alert trigger test (REQ-SW-022 verification)
- Power monitoring threshold test (REQ-SW-033 verification)
- PLL lock acquisition test (REQ-SW-004 verification)
- Power sequencing test (REQ-SW-035 verification)
- RF enable/disable test (REQ-SW-045 verification)
- Fault logging and retrieval test (REQ-SW-051, REQ-SW-053 verification)

## 4.3 System Test Requirements
The software shall be subjected to system testing with the following test cases:

- Full power-on sequence test with timing measurements (REQ-SW-001, REQ-SW-006 verification)
- Endurance test: 72 hours continuous operation at nominal temperature (REQ-SYS-005 verification)
- Temperature stress test across rated operating range (-55°C to +125°C) (REQ-SW-024 verification)
- UART protocol conformance test: all four command types with error injection (REQ-SW-012-015 verification)
- Power consumption validation across all operating modes (REQ-HW-009 verification)
- EMI pre-compliance test (conducted emissions, radiated emissions) (HRS §3.5 verification)
- Vibration test per MIL-STD-810 (HRS §3.5 verification)
- IP67 environmental test (HRS §3.5 verification)

## 4.4 Formal Verification
For safety-critical components, the following formal verification activities shall be performed:
- Static analysis tool coverage report (Polyspace, PC-lint)
- Stack usage analysis (all call paths worst-case bounded)
- Data flow analysis for all state machine transitions
- Formal verification of critical timing requirements

---

# 5. Requirements Traceability Matrix

| REQ-SW-xxx | Description | Source (REQ-HW/GLR §) | Priority | Verification |
|-----------|-------------|----------------------|----------|-------------|
| REQ-SW-001 | Complete power-on self-test within 500ms of reset | GLR §4 | M | T |
| REQ-SW-002 | Verify BOARD_ID register matches expected value | GLR §5.1 | M | T |
| REQ-SW-003 | Configure PLL to 125 MHz within 100ms | GLR §4.1 | M | T |
| REQ-SW-004 | Poll PLL_STATUS.LOCKED bit with 100ms timeout | GLR §4.1 | M | T |
| REQ-SW-005 | Initialize all peripherals within 50ms of PLL lock | GLR §4.2 | M | T |
| REQ-SW-006 | Load calibration data from EEPROM into RAM | HRS §3.2 | M | T |
| REQ-SW-007 | Initialize watchdog timer with 100ms timeout | GLR §5.4 | M | T |
| REQ-SW-008 | Log firmware version to UART on startup | GLR §5 | D | T |
| REQ-SW-009 | Perform RAM BIST on 256KB of SRAM | GLR §4.3 | D | T |
| REQ-SW-010 | Set STATUS_LED to BLINKING at 1Hz during init | GLR §5.3 | O | T |
| REQ-SW-011 | Support baud rates of 9600, 19200, 38400, 57600, 115200 | GLR §5.1 | M | T |
| REQ-SW-012 | Implement Single Write command (0x57) | GLR §6.3 | M | T |
| REQ-SW-013 | Implement Single Read command (0x52) with bit15=1 | GLR §6.3 | M | T |
| REQ-SW-014 | Implement Bulk Write command (0x42) for 64 registers | GLR §6.3 | M | T |
| REQ-SW-015 | Implement Bulk Read command (0x62) for 64 registers | GLR §6.3 | M | T |
| REQ-SW-016 | Respond to invalid command with NAK (0x15) within 100µs | GLR §6.3 | M | T |
| REQ-SW-017 | Support TX FIFO of at least 256 bytes | GLR §5.1 | M | T |
| REQ-SW-018 | Support RX FIFO of at least 256 bytes | GLR §5.1 | M | T |
| REQ-SW-019 | Clear UART_STATUS.FRAME_ERR flag on read | GLR §5.1 | D | T |
| REQ-SW-020 | Recover from framing errors without hardware reset | GLR §5.1 | D | T |
| REQ-SW-021 | Read temperature from AD7416 every 2 seconds | GLR §4.2 | M | T |
| REQ-SW-022 | Generate TEMP_ALERT interrupt when temp >85°C | HRS §3.5 | M | T |
| REQ-SW-023 | Log temperature to STATUS_REGISTER every 10s | GLR §5.2 | D | T |
| REQ-SW-024 | Disable RF output when temp >100°C | HRS §3.5 | M | T |
| REQ-SW-025 | Re-enable RF output when temp <95°C (hysteresis) | HRS §3.5 | M | T |
| REQ-SW-026 | Implement temperature monitoring state machine | GLR §4.2 | M | T |
| REQ-SW-027 | Record temperature events with timestamps | GLR §5.4 | D | T |
| REQ-SW-028 | Support querying temperature via UART | GLR §6.3 | M | T |
| REQ-SW-029 | Verify AD7416 sensor communication integrity | GLR §4.3 | M | T |
| REQ-SW-030 | Implement software temperature filter | GLR §4.2 | O | T |
| REQ-SW-031 | Read all voltage channels from LTC2992 every 2s | GLR §4.2 | M | T |
| REQ-SW-032 | Read all current channels from LTC2992 every 2s | GLR §4.2 | M | T |
| REQ-SW-033 | Assert fault if rail deviates >5% from nominal | HRS §3.4 | M | T |
| REQ-SW-034 | Log power rail status to STATUS_REGISTER every 10s | GLR §5.2 | D | T |
| REQ-SW-035 | Implement power-on sequence for all rails | GLR §4.1 | M | T |
| REQ-SW-036 | Verify each rail is within tolerance before enabling | HRS §3.4 | M | T |
| REQ-SW-037 | Support querying power status via UART | GLR §6.3 | M | T |
| REQ-SW-038 | Implement power-down sequence on command or fault | GLR §4.1 | M | T |
| REQ-SW-039 | Record power rail events with timestamps | GLR §5.4 | D | T |
| REQ-SW-040 | Verify LTC2992 communication integrity | GLR §4.3 | M | T |
| REQ-SW-041 | Control RF components via MCP23017 | GLR §4.2 | M | T |
| REQ-SW-042 | Provide independent control for each RF channel | HRS §3.1 | M | T |
| REQ-SW-043 | Enable/disable LNA biasing through MCP23017 | GLR §4.2 | M | T |
| REQ-SW-044 | Set RF output power through digital gain control | GLR §4.2 | M | T |
| REQ-SW-045 | Implement RF_ENABLE signal control | HRS §3.1 | M | T |
| REQ-SW-046 | Support querying RF status via UART | GLR §6.3 | M | T |
| REQ-SW-047 | Verify MCP23017 communication integrity | GLR §4.3 | M | T |
| REQ-SW-048 | Implement RF calibration data loading | GLR §4.4 | D | T |
| REQ-SW-049 | Support RF gain adjustment in 1dB steps | HRS §3.2 | M | T |
| REQ-SW-050 | Implement RF band selection through filter control | GLR §4.2 | D | T |
| REQ-SW-051 | Maintain circular fault log buffer with 64 entries | GLR §5.4 | M | T |
| REQ-SW-052 | Log all faults with timestamp, code, parameters | GLR §5.4 | M | T |
| REQ-SW-053 | Implement UART command 0xD0 to dump fault log | GLR §6.3 | M | T |
| REQ-SW-054 | Maintain software execution counter readable via UART | GLR §5.2 | D | T |
| REQ-SW-055 | Implement graceful shutdown on critical fault | GLR §4.1 | M | T |
| REQ-SW-056 | Implement error recovery procedures | GLR §5.4 | M | T |
| REQ-SW-057 | Implement safe state for components during errors | HRS §3.5 | M | T |
| REQ-SW-058 | Support clearing fault log via UART | GLR §6.3 | D | T |
| REQ-SW-059 | Implement non-volatile storage for critical parameters | GLR §5.4 | M | T |
| REQ-SW-060 | Record configuration changes with timestamps | GLR §5.4 | O | T |
| REQ-SW-061 | Implement POST covering RAM BIST, peripheral checks, PLL | GLR §4.3 | M | T |
| REQ-SW-062 | Perform RAM BIST with 100% pattern coverage | GLR §4.3 | M | T |
| REQ-SW-063 | Verify all peripheral communications during POST | GLR §4.3 | M | T |
| REQ-SW-064 | Implement PLL lock verification test | GLR §4.1 | M | T |
| REQ-SW-065 | Perform sensor functionality test during POST | GLR §4.3 | M | T |
| REQ-SW-066 | Perform Flash memory test during POST | GLR §4.3 | M | T |
| REQ-SW-067 | Report POST results through STATUS_REGISTER | GLR §5.2 | M | T |
| REQ-SW-068 | Implement quick test mode for runtime POST | GLR §4.3 | D | T |
| REQ-SW-069 | Implement comprehensive test mode for maintenance | GLR §4.3 | D | T |
| REQ-SW-070 | Support triggering POST via UART command | GLR §6.3 | D | T |
| REQ-SW-071 | Implement firmware update via UART | GLR §5.5 | M | T |
| REQ-SW-072 | Validate firmware images with CRC-32 check | GLR §5.5 | M | T |
| REQ-SW-073 | Implement boot image selection for redundancy | GLR §5.5 | D | T |
| REQ-SW-074 | Report update status through STATUS_REGISTER | GLR §5.2 | M | T |
| REQ-SW-075 | Implement fallback to previous firmware on failure | GLR §5.5 | M | T |

---

# 6. Appendices

## Appendix A — Error Codes
```c
/**
 * @brief Error code enumeration
 */
typedef enum {
    ERR_OK           = 0x00,
    ERR_TIMEOUT      = 0x01,
    ERR_COMM         = 0x02,
    ERR_CHECKSUM     = 0x03,
    ERR_PARAM        = 0x04,
    ERR_NOT_INIT     = 0x05,
    ERR_RESOURCE     = 0x06,
    ERR_HARDWARE     = 0x07,
    ERR_OVERFLOW     = 0x08,
    ERR_UNDERFLOW    = 0x09,
    ERR_FLASH_WRITE  = 0x0A,
    ERR_FLASH_ERASE  = 0x0B,
    ERR_EEPROM       = 0x0C,
    ERR_PLL          = 0x0D,
    ERR_TEMP_ALERT   = 0x0E,
    ERR_VOLT_FAULT   = 0x0F,
    ERR_LOOPBACK     = 0x10,
    ERR_POST_FAIL    = 0x11,
    ERR_WATCHDOG     = 0x12,
    ERR_ADDR_RANGE   = 0x13,
    ERR_STATE        = 0x14,
    ERR_BUSY         = 0x15,
    ERR_CONFIG       = 0x16,
    ERR_CALIB        = 0x17,
    ERR_RF_ENABLE    = 0x18,
    ERR_RF_POWER     = 0x19,
    ERR_RF_GAIN      = 0x1A,
    ERR_RF_BAND      = 0x1B,
    ERR_SENSOR       = 0x1C,
    ERR_PWR_SEQ      = 0x1D,
    ERR_I2C          = 0x1E,
    ERR_SPI          = 0x1F,
    ERR_GPIO         = 0x20,
    ERR_UART         = 0x21,
    ERR_TIMER        = 0x22,
    ERR_ISR          = 0x23,
    ERR_STACK       