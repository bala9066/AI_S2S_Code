/**
 * @file hal.h
 * @brief Hardware Abstraction Layer for khv
 */

#ifndef khv_HAL_H
#define khv_HAL_H

#include <stdint.h>
#include <stdbool.h>

typedef enum {
    HAL_OK = 0,
    HAL_ERROR = -1,
    HAL_BUSY = -2,
} hal_status_t;

typedef struct {
    uint32_t clock_rate;
    uint32_t timeout_ms;
} hal_config_t;

hal_status_t hal_init(void);
hal_status_t hal_deinit(void);

#endif /* khv_HAL_H */
