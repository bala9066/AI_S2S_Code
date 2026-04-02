/**
 * @file hal.c
 * @brief Hardware Abstraction Layer implementation for fug
 */

#include "hal.h"

static hal_config_t g_config = {0};
static bool g_initialized = false;

hal_status_t hal_init(void) {
    if (g_initialized) return HAL_OK;
    g_config.clock_rate = 48000000;
    g_config.timeout_ms = 100;
    g_initialized = true;
    return HAL_OK;
}

hal_status_t hal_deinit(void) {
    g_initialized = false;
    return HAL_OK;
}
