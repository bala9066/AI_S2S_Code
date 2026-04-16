# Software Design Description (SDD)

**Project:** sample rf
**Document:** IEEE 1016-2009 Compliant
**Date:** 2026-04-16

---


## 1. Context Viewpoint

```mermaid
graph LR
    User[User] --> SW[Software]
    HW[Hardware] <--> SW
    EXT[External] <--> SW

    style SW fill:#e1f5ff
```

---


## 2. Composition Viewpoint

| Module | Description | File |
|--------|-------------|------|
| Main | Main application loop | main.c |
| HAL | Hardware abstraction | hal.c |
| Drivers | Device drivers | drivers/ |
| Comms | Communication | comms.c |

---


## 3. Logical Viewpoint

```mermaid
graph TD
    S1[Sensors] --> FIFO[Data FIFO]
    FIFO --> PROC[Processor]
    PROC --> CTRL[Control]
    CTRL --> ACT[Actuators]
```

---


## 4. Interface Viewpoint

| Interface | Type | Functions |
|-----------|------|-----------|
| HAL | Internal | hal_init(), hal_read(), hal_write() |
| UART | Hardware | uart_init(), uart_send(), uart_recv() |
| SPI | Hardware | spi_transfer() |

---


## 5. Interaction Viewpoint

```mermaid
sequenceDiagram
    participant P as Power
    participant I as Init
    participant A as App
    
    P->>I: Power On
    I->>A: Start App
    A->>A: Main Loop
```

---


## 6. State Viewpoint

```mermaid
stateDiagram-v2
    [*] --> Init
    Init --> Idle
    Idle --> Running: Start
    Running --> Idle: Stop
    Running --> Error: Fault
    Error --> Idle: Clear
    Idle --> [*]: Shutdown
```

---


## 7. Resource Viewpoint

| Resource | Total | Used | Available |
|----------|-------|------|-----------|
| Flash | 256 KB | 64 KB | 192 KB |
| RAM | 64 KB | 32 KB | 32 KB |
| CPU | 100% | 60% | 40% |

---


## 8. Data Viewpoint

| Structure | Purpose |
|-----------|---------|
| sensor_data_t | Sensor readings |
| config_t | System config |
| error_log_t | Error logging |

---
