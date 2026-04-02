# Programming Sequence (PSQ)
## fug

> **Total steps:** 7

| # | Phase | Register | Address | Value | Condition | Rationale |
|---|-------|----------|---------|-------|-----------|-----------|
| 1 | Power-On Reset | `SAFETY_MONITOR_REG` | `0x40000004` | `0x00000303` | Wait for stable VCC | Enable IEC 60730 Class B watchdog and clock monitor immediately after power-up for safety compliance. Ensure WDOG_RESET and CLOCK_FAIL flags are cleared before enabling. |
| 2 | Clock Init | `SAFETY_MONITOR_REG` | `0x40000004` | `0x00000303` | Poll CLOCK_FAIL=0 for 100ms | Verify main PLL is stable and within 5% of target frequency before proceeding with peripheral configuration. |
| 3 | Peripheral Config | `PWM_CONFIG_REG` | `0x40000000` | `0x001C013C` | None | Configure PWM switching frequency (60kHz) and dead-time (400ns) BEFORE enabling outputs. Value: FREQ=0x3C (60kHz), DEAD_TIME=0x190 (400ns). |
| 4 | Peripheral Config | `PHASE_CURRENT_CTRL` | `0x40000008` | `0x00010320` | None | Set overcurrent threshold to 80A (0x320) and enable hardware overcurrent protection. This is a critical safety step before enabling PWM. |
| 5 | Pre-Motor-Start Check | `PHASE_CURRENT_CTRL` | `0x40000008` | `0x00000001` | Poll ADC_DONE=1 | Trigger initial phase current measurement to verify all current sensors are functional and reading near zero before motor start. |
| 6 | Motor Enable | `PWM_CONFIG_REG` | `0x40000000` | `0x001C013D` | Verify ADC readings < 5A | Set PWM_ENABLE bit to enable 3-phase inverter output. Only done after confirming: (1) PWM frequency set, (2) Dead-time configured, (3) Overcurrent protection enabled, (4) Current sensors functional. |
| 7 | Runtime Monitoring | `SAFETY_MONITOR_REG` | `0x40000004` | `0x00000303` | Continuous (every 1ms) | Periodically read safety register to check for WDOG_RESET or CLOCK_FAIL flags. If either set, immediately disable PWM and enter safe state. |

---

## Detailed Steps

### Step 1 — Power-On Reset
- **Register:** `SAFETY_MONITOR_REG` at `0x40000004`
- **Write value:** `0x00000303`
- **Wait/Poll:** Wait for stable VCC
- **Rationale:** Enable IEC 60730 Class B watchdog and clock monitor immediately after power-up for safety compliance. Ensure WDOG_RESET and CLOCK_FAIL flags are cleared before enabling.

### Step 2 — Clock Init
- **Register:** `SAFETY_MONITOR_REG` at `0x40000004`
- **Write value:** `0x00000303`
- **Wait/Poll:** Poll CLOCK_FAIL=0 for 100ms
- **Rationale:** Verify main PLL is stable and within 5% of target frequency before proceeding with peripheral configuration.

### Step 3 — Peripheral Config
- **Register:** `PWM_CONFIG_REG` at `0x40000000`
- **Write value:** `0x001C013C`
- **Wait/Poll:** None
- **Rationale:** Configure PWM switching frequency (60kHz) and dead-time (400ns) BEFORE enabling outputs. Value: FREQ=0x3C (60kHz), DEAD_TIME=0x190 (400ns).

### Step 4 — Peripheral Config
- **Register:** `PHASE_CURRENT_CTRL` at `0x40000008`
- **Write value:** `0x00010320`
- **Wait/Poll:** None
- **Rationale:** Set overcurrent threshold to 80A (0x320) and enable hardware overcurrent protection. This is a critical safety step before enabling PWM.

### Step 5 — Pre-Motor-Start Check
- **Register:** `PHASE_CURRENT_CTRL` at `0x40000008`
- **Write value:** `0x00000001`
- **Wait/Poll:** Poll ADC_DONE=1
- **Rationale:** Trigger initial phase current measurement to verify all current sensors are functional and reading near zero before motor start.

### Step 6 — Motor Enable
- **Register:** `PWM_CONFIG_REG` at `0x40000000`
- **Write value:** `0x001C013D`
- **Wait/Poll:** Verify ADC readings < 5A
- **Rationale:** Set PWM_ENABLE bit to enable 3-phase inverter output. Only done after confirming: (1) PWM frequency set, (2) Dead-time configured, (3) Overcurrent protection enabled, (4) Current sensors functional.

### Step 7 — Runtime Monitoring
- **Register:** `SAFETY_MONITOR_REG` at `0x40000004`
- **Write value:** `0x00000303`
- **Wait/Poll:** Continuous (every 1ms)
- **Rationale:** Periodically read safety register to check for WDOG_RESET or CLOCK_FAIL flags. If either set, immediately disable PWM and enter safe state.
