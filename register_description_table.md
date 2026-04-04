# Register Description Table
## fjxm

> **Total registers:** 1

The fjxm project is a 200W multi-output DC-DC power supply using an analog Active Clamp Forward Converter topology. No memory-mapped registers or firmware programming sequence exists. The UCC28951A PWM controller operates through analog hardware configuration via passive components (resistors, capacitors). See Hardware Configuration Guide for component selection calculations.

---
### `N/A - Analog Design` — Address: `N/A`
**Reset value:** `N/A`

This is a pure analog power supply design with no digital control interface. The UCC28951A PWM controller is configured entirely through external passive component selection.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `None` | `N/A` | N/A | `N/A` | No memory-mapped registers exist in this design. All control parameters are set via hardware component selection during PCB design. |
