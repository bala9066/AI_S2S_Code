# Register Description Table
## fug

> **Total registers:** 3

PROJECT: fug - 10kW 3-Phase BLDC Motor Controller

STATUS: ⚠️ PLACEHOLDER - GLR NOT PROVIDED

The provided materials contain NO custom register definitions. The netlist shows only generic MCU (STM32F407VGT6) and PWR blocks with auto-synthesized stubs. The HRS describes system requirements but contains no memory-mapped register specifications.

To generate a complete RDT and PSQ, provide:
1. GLR document with custom logic registers
2. Register map for any FPGA/CPLD glue logic
3. Custom peripheral registers (PWM config, safety monitors, etc.)
4. Or specify STM32F407 peripherals to configure

Below is a TEMPLATE structure showing what the output should look like once register data is available.

---
### `[EXAMPLE] PWM_CONFIG_REG` — Address: `0x40000000`
**Reset value:** `0x00000000`

PWM Configuration Register - Defines switching frequency, dead-time, and output enable for 3-phase inverter

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `PWM_ENABLE` | `[0]` | RW | `0` | Master enable for all 3-phase PWM outputs. Must be set after all configuration is complete. |
| `SWITCHING_FREQ` | `[15:8]` | RW | `0x3C` | PWM switching frequency in kHz. Reset = 60kHz. Range: 20-100kHz valid for MOSFET gate drivers. |
| `DEAD_TIME_NS` | `[27:16]` | RW | `0x190` | Dead-time in nanoseconds to prevent shoot-through. Reset = 400ns. Min 200ns, Max 1000ns. |
| `RESERVED` | `[31:28]` | R | `0x0` | Reserved - Read as 0, writes ignored |

---
### `[EXAMPLE] SAFETY_MONITOR_REG` — Address: `0x40000004`
**Reset value:** `0x00000003`

IEC 60730 Class B Safety Monitoring - Watchdog, Clock Monitor, and Memory Test status

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `WDOG_RESET` | `[0]` | RC | `0` | Watchdog reset flag. Read-clears. Set when watchdog timeout occurs. |
| `CLOCK_FAIL` | `[1]` | RC | `0` | Clock monitor fail flag. Read-clears. Set when main PLL deviates >5%. |
| `WDOG_ENABLE` | `[8]` | RW | `1` | Enable IEC 60730 Class B watchdog. Must remain set for safe operation. |
| `CLOCK_MON_EN` | `[9]` | RW | `1` | Enable clock monitoring against LSE reference. |
| `RESERVED` | `[31:10]` | R | `0x0` | Reserved - Read as 0 |

---
### `[EXAMPLE] PHASE_CURRENT_CTRL` — Address: `0x40000008`
**Reset value:** `0x00000000`

Phase Current ADC Control - Configures shunt measurement and overcurrent thresholds

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_START` | `[0]` | W | `0` | Write 1 to start phase current conversion sequence. Self-clearing. |
| `OVERCURR_THRESHOLD` | `[11:0]` | RW | `0x320` | 12-bit overcurrent trip threshold. LSB = 0.1A. Reset = 80A. Max = 250A. |
| `OVERCURR_EN` | `[16]` | RW | `1` | Enable hardware overcurrent shutdown (opens all PWM outputs immediately when exceeded) |
| `ADC_DONE` | `[31]` | R | `0` | Conversion complete flag. Set when all 3 phases sampled. |
