# Git Commit Summary — receiver

**Status:** ✅ Committed
**Commit SHA:** `4ad7341b6d`
**Branch:** `ai/pipeline/receiver-20260417-0209`
**Pull Request:** Not created (no GitHub remote configured)

All generated artefacts have been committed to the local repository.

## CI/CD Pipeline

Workflow: `.github/workflows/hardware_pipeline_ci.yml`  
Runs automatically on every push and PR:

- **Build Qt5 GUI** — QMake + make, ubuntu-22.04 (Qt 5.14.2, C++14)
- **Build ARM Firmware** — arm-none-eabi-gcc cross-compile, binary size check
- **Unit Tests + Coverage** — GCC + Google Test, lcov HTML report, 60% gate
- **Static Analysis** — Cppcheck (MISRA-C C11 + C++14) + Clang-Tidy (bugprone, cert, perf)
- **Quality Gate** — all jobs must pass before merge
- **Artifacts** — binaries, coverage HTML, Cppcheck report (30-day retention)

See `ci_validation_report.md` for local pre-push validation results.
