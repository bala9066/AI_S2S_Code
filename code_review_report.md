# Code Review Report — mn

## Executive Summary

| Metric | Value |
|--------|-------|
| Quality Score | **100/100** |
| Tools Used | Lizard |
| Total Issues | 0 |
| Critical | 0 |
| High | 0 |
| Medium | 0 |
| Low | 0 |
| MISRA-C Violations | 0 |
| Complexity Violations (CC>10) | 0 |

## Cppcheck Findings

_No issues found._

## Function Complexity Overview

| Function | File | CC | LOC | Parameters | Status |
|----------|------|----|-----|-----------|--------|
| `hal_reg_write` | `hal.c` | 2 | 12 | 2 | ✅ OK |
| `hal_reg_read` | `hal.c` | 5 | 18 | 2 | ✅ OK |
| `hal_init` | `hal.c` | 6 | 16 | 1 | ✅ OK |
| `hal_deinit` | `hal.c` | 1 | 6 | 0 | ✅ OK |
| `hal_is_ready` | `hal.c` | 1 | 4 | 0 | ✅ OK |
| `hal_read__0000` | `hal.c` | 1 | 4 | 1 | ✅ OK |
| `hal_write__0000` | `hal.c` | 1 | 4 | 1 | ✅ OK |
| `hal_read__0000` | `hal.c` | 1 | 4 | 1 | ✅ OK |
| `hal_write__0000` | `hal.c` | 1 | 4 | 1 | ✅ OK |
| `hal_read__0000` | `hal.c` | 1 | 4 | 1 | ✅ OK |
| `hal_write__0000` | `hal.c` | 1 | 4 | 1 | ✅ OK |
| `hal_read__0000` | `hal.c` | 1 | 4 | 1 | ✅ OK |
| `hal_write__0000` | `hal.c` | 1 | 4 | 1 | ✅ OK |
| `hal_read__0000` | `hal.c` | 1 | 4 | 1 | ✅ OK |
| `hal_write__0000` | `hal.c` | 1 | 4 | 1 | ✅ OK |
| `hal_read__0000` | `hal.c` | 1 | 4 | 1 | ✅ OK |
| `hal_write__0000` | `hal.c` | 1 | 4 | 1 | ✅ OK |
| `hal_read__0000` | `hal.c` | 1 | 4 | 1 | ✅ OK |
| `hal_write__0000` | `hal.c` | 1 | 4 | 1 | ✅ OK |
| `hal_read_reg_0x00` | `hal.c` | 1 | 4 | 1 | ✅ OK |
| `hal_write_reg_0x00` | `hal.c` | 1 | 4 | 1 | ✅ OK |
| `hal_read__5631` | `hal.c` | 1 | 4 | 1 | ✅ OK |
| `hal_write__5631` | `hal.c` | 1 | 4 | 1 | ✅ OK |
| `hal_read_reg_0x04` | `hal.c` | 1 | 4 | 1 | ✅ OK |
| `hal_write_reg_0x04` | `hal.c` | 1 | 4 | 1 | ✅ OK |
| `hal_read__0000` | `hal.c` | 1 | 4 | 1 | ✅ OK |
| `hal_write__0000` | `hal.c` | 1 | 4 | 1 | ✅ OK |
| `hal_read_reg_0x10` | `hal.c` | 1 | 4 | 1 | ✅ OK |
| `hal_write_reg_0x10` | `hal.c` | 1 | 4 | 1 | ✅ OK |
| `hal_read__0000` | `hal.c` | 1 | 4 | 1 | ✅ OK |
| `hal_write__0000` | `hal.c` | 1 | 4 | 1 | ✅ OK |
| `hal_read_reg_0x14` | `hal.c` | 1 | 4 | 1 | ✅ OK |
| `hal_write_reg_0x14` | `hal.c` | 1 | 4 | 1 | ✅ OK |
| `hal_read_reg_0x08` | `hal.c` | 1 | 4 | 1 | ✅ OK |
| `hal_write_reg_0x08` | `hal.c` | 1 | 4 | 1 | ✅ OK |
| `hal_read_reg_0x0c` | `hal.c` | 1 | 4 | 1 | ✅ OK |
| `hal_write_reg_0x0c` | `hal.c` | 1 | 4 | 1 | ✅ OK |
| `hal_read__ffff` | `hal.c` | 1 | 4 | 1 | ✅ OK |
| `hal_write__ffff` | `hal.c` | 1 | 4 | 1 | ✅ OK |
| `hal_read_reg_0x0c` | `hal.c` | 1 | 4 | 1 | ✅ OK |
| `hal_write_reg_0x0c` | `hal.c` | 1 | 4 | 1 | ✅ OK |
| `hal_read__ffff` | `hal.c` | 1 | 4 | 1 | ✅ OK |
| `hal_write__ffff` | `hal.c` | 1 | 4 | 1 | ✅ OK |
| `hal_read_reg_0xffffffff` | `hal.c` | 1 | 4 | 1 | ✅ OK |
| `hal_write_reg_0xffffffff` | `hal.c` | 1 | 4 | 1 | ✅ OK |
| `_uart_write_bytes` | `hal.c` | 1 | 6 | 2 | ✅ OK |
| `_uart_read_bytes` | `hal.c` | 1 | 6 | 3 | ✅ OK |

## Recommendations

- ✅ **Code quality score acceptable** — suitable for firmware integration review

---
_Analysis performed by Hardware Pipeline v2 using Lizard_

_Note: LLM deep-dive unavailable — 'Settings' object has no attribute 'model'_