TARGET = test

DEBUG = 1
AUTOFLASH = 1
# optimization
OPT = -Og

BUILD_DIR = build

C_SOURCES =  \
Src/main.c \
Src/stm32f4xx_it.c \
Src/system_stm32f4xx.c \
Drivers/STM32F4xx_StdPeriph_Driver/src/misc.c \
Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_can.c\
Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_adc.c\
Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_crc.c\
Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_cryp.c\
Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_cryp_aes.c\
Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_cryp_des.c\
Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_cryp_tdes.c\
Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_dac.c\
Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_dbgmcu.c\
Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_dcmi.c\
Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_dma.c\
Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_exti.c\
Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_flash.c\
Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_fsmc.c\
Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_gpio.c\
Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_hash.c\
Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_hash_md5.c\
Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_hash_sha1.c\
Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_i2c.c\
Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_iwdg.c\
Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_pwr.c\
Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_rcc.c\
Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_rng.c\
Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_rtc.c\
Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_sdio.c\
Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_spi.c\
Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_syscfg.c\
Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_tim.c\
Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_usart.c\
Drivers/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_wwdg.c
# ASM sources

ASM_SOURCES =  \
startup_stm32f405xx.s


#######################################
# binaries
#######################################
PREFIX = arm-none-eabi-
# The gcc compiler bin path can be either defined in make command via GCC_PATH variable (> make GCC_PATH=xxx)
# either it can be added to the PATH environment variable.
ifdef GCC_PATH
CC = $(GCC_PATH)/$(PREFIX)gcc
AS = $(GCC_PATH)/$(PREFIX)gcc -x assembler-with-cpp
CP = $(GCC_PATH)/$(PREFIX)objcopy
SZ = $(GCC_PATH)/$(PREFIX)size
else
CC = $(PREFIX)gcc
AS = $(PREFIX)gcc -x assembler-with-cpp
CP = $(PREFIX)objcopy
SZ = $(PREFIX)size
endif
HEX = $(CP) -O ihex
BIN = $(CP) -O binary -S
 
#######################################
# CFLAGS
#######################################
# cpu
CPU = -mcpu=cortex-m4

# fpu
FPU = -mfpu=fpv4-sp-d16

# float-abi
FLOAT-ABI = -mfloat-abi=hard

# mcu
MCU = $(CPU) -mthumb $(FPU) $(FLOAT-ABI)

# macros for gcc
# AS defines
AS_DEFS = 

# C defines
C_DEFS =  \
-DUSE_STDPERIPH_DRIVER \
-DSTM32F405xx \
-DSTM32F40X_HD


# AS includes
AS_INCLUDES = 

# C includes
C_INCLUDES =  \
-IInc \
-IDrivers/STM32F4xx_StdPeriph_Driver/inc \
-IDrivers/CMSIS/Core/Include
# compile gcc flags
ASFLAGS = $(MCU) $(AS_DEFS) $(AS_INCLUDES) $(OPT) -Wall -fdata-sections -ffunction-sections

CFLAGS = $(MCU) $(C_DEFS) $(C_INCLUDES) $(OPT) -Wall -fdata-sections -ffunction-sections

ifeq ($(DEBUG), 1)
CFLAGS += -g -gdwarf-2
endif

ifeq ($(AUTOFLASH), 1)
	FLASH = flash
endif

# Generate dependency information
CFLAGS += -MMD -MP -MF"$(@:%.o=%.d)"

#######################################
# LDFLAGS
#######################################
# link script
LDSCRIPT = STM32F405RGTx_FLASH.ld

# libraries
LIBS = -lc -lm -lnosys 
LIBDIR = 
LDFLAGS = $(MCU) -specs=nano.specs -T$(LDSCRIPT) $(LIBDIR) $(LIBS) -Wl,-Map=$(BUILD_DIR)/$(TARGET).map,--cref -Wl,--gc-sections

# default action: build all
all: $(BUILD_DIR)/$(TARGET).elf $(BUILD_DIR)/$(TARGET).hex $(BUILD_DIR)/$(TARGET).bin $(FLASH)

#######################################
# build the application
#######################################
# list of objects
OBJECTS = $(addprefix $(BUILD_DIR)/,$(notdir $(C_SOURCES:.c=.o)))
vpath %.c $(sort $(dir $(C_SOURCES)))
# list of ASM program objects
OBJECTS += $(addprefix $(BUILD_DIR)/,$(notdir $(ASM_SOURCES:.s=.o)))
vpath %.s $(sort $(dir $(ASM_SOURCES)))

$(BUILD_DIR)/%.o: %.c Makefile | $(BUILD_DIR) 
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/$(notdir $(<:.c=.lst)) $< -o $@

$(BUILD_DIR)/%.o: %.s Makefile | $(BUILD_DIR)
	$(AS) -c $(CFLAGS) $< -o $@

$(BUILD_DIR)/$(TARGET).elf: $(OBJECTS) Makefile
	$(CC) $(OBJECTS) $(LDFLAGS) -o $@
	$(SZ) $@

$(BUILD_DIR)/%.hex: $(BUILD_DIR)/%.elf | $(BUILD_DIR)
	$(HEX) $< $@
	
$(BUILD_DIR)/%.bin: $(BUILD_DIR)/%.elf | $(BUILD_DIR)
	$(BIN) $< $@	
	
$(BUILD_DIR):
	mkdir $@			

#######################################
# clean up
#######################################
.PHONY:clean

clean:
	-rm -fR $(BUILD_DIR)
flash:
	openocd -f interface/jlink.cfg -c 'transport select swd' -f target/stm32f4x.cfg \
	-c 'program $(BUILD_DIR)/$(TARGET).elf' -c 'reset' -c 'exit'
#######################################
# dependencies
#######################################
-include $(wildcard $(BUILD_DIR)/*.d)

# *** EOF ***