# ARM Cortex-M/A cross-compilation toolchain for CMake
# Usage: cmake -DCMAKE_TOOLCHAIN_FILE=cmake/arm-none-eabi.cmake ..
# Requires: arm-none-eabi-gcc installed on PATH

cmake_minimum_required(VERSION 3.20)

set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR arm)

# Toolchain executables
set(CMAKE_C_COMPILER    arm-none-eabi-gcc)
set(CMAKE_CXX_COMPILER  arm-none-eabi-g++)
set(CMAKE_ASM_COMPILER  arm-none-eabi-gcc)
set(CMAKE_OBJCOPY       arm-none-eabi-objcopy)
set(CMAKE_SIZE          arm-none-eabi-size)

# Don't try to link test executables against target libs during configuration
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

# Target CPU — override at project level if needed
# e.g. for Cortex-M4F: -mcpu=cortex-m4 -mfpu=fpv4-sp-d16 -mfloat-abi=hard
set(CPU_FLAGS "-mcpu=cortex-m3 -mthumb" CACHE STRING "CPU architecture flags")
set(FPU_FLAGS "" CACHE STRING "FPU flags (empty = soft-float)")

# Common compiler flags
set(COMMON_FLAGS "${CPU_FLAGS} ${FPU_FLAGS} -ffunction-sections -fdata-sections -Wall -Wextra")
set(CMAKE_C_FLAGS   "${COMMON_FLAGS} -std=c11"   CACHE STRING "" FORCE)
set(CMAKE_CXX_FLAGS "${COMMON_FLAGS} -std=c++17 -fno-exceptions -fno-rtti" CACHE STRING "" FORCE)

# Linker flags
set(CMAKE_EXE_LINKER_FLAGS
    "${CPU_FLAGS} -specs=nosys.specs -specs=nano.specs -Wl,--gc-sections -Wl,-Map=firmware.map"
    CACHE STRING "" FORCE)

# Sysroot (host compiler headers — for includes only)
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

# Post-build: generate .bin and .hex from .elf
function(add_firmware_outputs TARGET)
    add_custom_command(TARGET ${TARGET} POST_BUILD
        COMMAND ${CMAKE_OBJCOPY} -O binary $<TARGET_FILE:${TARGET}> ${TARGET}.bin
        COMMAND ${CMAKE_OBJCOPY} -O ihex   $<TARGET_FILE:${TARGET}> ${TARGET}.hex
        COMMAND ${CMAKE_SIZE}    $<TARGET_FILE:${TARGET}>
        COMMENT "Generating binary outputs for ${TARGET}"
    )
endfunction()
