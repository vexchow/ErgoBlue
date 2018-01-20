# Let's try this, because Arduino is kind of a PITA
# I basically just copied the crap out of the build output and dumped it here

# Some simple details
OUT=out

# AdaFruit library installation location/version malarkey
VER=0.8.1
ADAFRUIT=${HOME}/Library/Arduino15/packages/adafruit
TOOLS=${ADAFRUIT}/tools/gcc-arm-none-eabi/5_2-2015q4
HWROOT=${ADAFRUIT}/hardware/nrf52/${VER}

# Tools (probably don't need to change these at all)
CC=${TOOLS}/bin/arm-none-eabi-gcc
CPP=${TOOLS}/bin/arm-none-eabi-g++
OBJCOPY=${TOOLS}/bin/arm-none-eabi-objcopy
AR=${TOOLS}/bin/arm-none-eabi-ar
NRFUTIL=/usr/local/bin/nrfutil

# Flags for compilation
DEFINES=-DF_CPU=64000000 -DARDUINO=10613 -DARDUINO_NRF52_FEATHER \
-DARDUINO_ARCH_NRF52 -DARDUINO_BSP_VERSION=\"${VER}\" \
-DARDUINO_FEATHER52 -DARDUINO_NRF52_ADAFRUIT -DNRF5 -DNRF52 -DNRF52832_XXAA \
-DUSE_LFXO -DS132 -DSD_VER=201 -DCFG_DEBUG=0
TARGET=-mcpu=cortex-m4 -mthumb -mfloat-abi=hard -mfpu=fpv4-sp-d16
CODEGEN=-nostdlib --param max-inline-insns-single=500 -ffunction-sections -fdata-sections
FLAGS=-g -Wall -u _printf_float -MMD
CPPLANG=-std=gnu++11 -w -x c++ -fno-rtti -fno-exceptions -fno-threadsafe-statics
CLANG=-std=gnu11 -DSOFTDEVICE_PRESENT
SLANG=-x assembler-with-cpp
OPT=-Os

INCLUDES=\
	"-I${HWROOT}/cores/nRF5/SDK/components/toolchain/"\
	"-I${HWROOT}/cores/nRF5/SDK/components/toolchain/cmsis/include"\
	"-I${HWROOT}/cores/nRF5/SDK/components/toolchain/gcc/"\
	"-I${HWROOT}/cores/nRF5/SDK/components/device/"\
	"-I${HWROOT}/cores/nRF5/SDK/components/drivers_nrf/delay/"\
	"-I${HWROOT}/cores/nRF5/SDK/components/drivers_nrf/hal/"\
	"-I${HWROOT}/cores/nRF5/SDK/components/libraries/util/"\
	"-I${HWROOT}/cores/nRF5/softdevice/s132/2.0.1/headers/"\
	"-I${HWROOT}/cores/nRF5/freertos/source/include"\
	"-I${HWROOT}/cores/nRF5/freertos/config"\
	"-I${HWROOT}/cores/nRF5/freertos/portable/GCC/nrf52"\
	"-I${HWROOT}/cores/nRF5/freertos/portable/CMSIS/nrf52"\
	"-I${HWROOT}/cores/nRF5/sysview/SEGGER"\
	"-I${HWROOT}/cores/nRF5/sysview/Config"\
	"-I${HWROOT}/libraries/nffs/src/fs/nffs/include"\
	"-I${HWROOT}/libraries/nffs/src/fs/fs/include"\
	"-I${HWROOT}/libraries/nffs/src/fs/disk/include"\
	"-I${HWROOT}/libraries/nffs/src/util/crc/include"\
	"-I${HWROOT}/libraries/nffs/src/kernel/os/include"\
	"-I${HWROOT}/libraries/nffs/src/kernel/os/include/os/arch/cortex_m4"\
	"-I${HWROOT}/libraries/nffs/src/hw/hal/include"\
	"-I${HWROOT}/libraries/nffs/src/sys/flash_map/include"\
	"-I${HWROOT}/libraries/nffs/src/sys/defs/include"\
	"-I${HWROOT}/cores/nRF5"\
	"-I${HWROOT}/variants/feather52"\
	"-I${HWROOT}/libraries/Bluefruit52Lib/src"\
	"-I${HWROOT}/libraries/nffs/src"

CPPFLAGS=${TARGET} ${FLAGS} ${CODEGEN} ${CPPLANG} ${DEFINES} ${OPT} ${INCLUDES}
CFLAGS=${TARGET} ${FLAGS} ${CODEGEN} ${CLANG} ${DEFINES} ${OPT} ${INCLUDES}
SFLAGS=${TARGET} ${FLAGS} ${CODEGEN} ${SLANG} ${DEFINES} ${OPT} ${INCLUDES}

BFLIB_SRCS =\
	${HWROOT}/libraries/Bluefruit52Lib/src/BLEAdvertising.cpp\
	${HWROOT}/libraries/Bluefruit52Lib/src/BLECentral.cpp\
	${HWROOT}/libraries/Bluefruit52Lib/src/BLECharacteristic.cpp\
	${HWROOT}/libraries/Bluefruit52Lib/src/BLEClientCharacteristic.cpp\
	${HWROOT}/libraries/Bluefruit52Lib/src/BLEClientService.cpp\
	${HWROOT}/libraries/Bluefruit52Lib/src/BLEDiscovery.cpp\
	${HWROOT}/libraries/Bluefruit52Lib/src/BLEGap.cpp\
	${HWROOT}/libraries/Bluefruit52Lib/src/BLEGatt.cpp\
	${HWROOT}/libraries/Bluefruit52Lib/src/BLEScanner.cpp\
	${HWROOT}/libraries/Bluefruit52Lib/src/BLEService.cpp\
	${HWROOT}/libraries/Bluefruit52Lib/src/BLEUuid.cpp\
	${HWROOT}/libraries/Bluefruit52Lib/src/bluefruit.cpp\
	${HWROOT}/libraries/Bluefruit52Lib/src/clients/BLEAncs.cpp\
	${HWROOT}/libraries/Bluefruit52Lib/src/clients/BLEClientCts.cpp\
	${HWROOT}/libraries/Bluefruit52Lib/src/clients/BLEClientDis.cpp\
	${HWROOT}/libraries/Bluefruit52Lib/src/clients/BLEClientUart.cpp\
	${HWROOT}/libraries/Bluefruit52Lib/src/services/BLEBas.cpp\
	${HWROOT}/libraries/Bluefruit52Lib/src/services/BLEBeacon.cpp\
	${HWROOT}/libraries/Bluefruit52Lib/src/services/BLEDfu.cpp\
	${HWROOT}/libraries/Bluefruit52Lib/src/services/BLEDis.cpp\
	${HWROOT}/libraries/Bluefruit52Lib/src/services/BLEHidAdafruit.cpp\
	${HWROOT}/libraries/Bluefruit52Lib/src/services/BLEHidGeneric.cpp\
	${HWROOT}/libraries/Bluefruit52Lib/src/services/BLEMidi.cpp\
	${HWROOT}/libraries/Bluefruit52Lib/src/services/BLEUart.cpp\
	${HWROOT}/libraries/Bluefruit52Lib/src/services/EddyStone.cpp\
	${HWROOT}/libraries/Bluefruit52Lib/src/utility/bootloader_util.c\
	${HWROOT}/libraries/Bluefruit52Lib/src/utility/AdaMsg.cpp

BFLIB_DIR = ${HWROOT}/libraries/Bluefruit52Lib/src
BFLIB_DIRCLIENTS = ${BFLIB_DIR}/clients
BFLIB_DIRSERVICES = ${BFLIB_DIR}/services
BFLIB_DIRUTILITY = ${BFLIB_DIR}/utility

BFLIB_OBJS = \
	$(addprefix ${OUT}/, \
		$(patsubst %.c, %.c.o, $(patsubst %.cpp, %.cpp.o, $(notdir ${BFLIB_SRCS}))))

NFFS_SRCS =\
	${HWROOT}/libraries/nffs/src/Nffs.cpp\
	${HWROOT}/libraries/nffs/src/NffsDir.cpp\
	${HWROOT}/libraries/nffs/src/NffsDirEntry.cpp\
	${HWROOT}/libraries/nffs/src/NffsFile.cpp\
	${HWROOT}/libraries/nffs/src/fs/disk/src/disk.c\
	${HWROOT}/libraries/nffs/src/fs/fs/src/fs_cli.c\
	${HWROOT}/libraries/nffs/src/fs/fs/src/fs_dirent.c\
	${HWROOT}/libraries/nffs/src/fs/fs/src/fs_file.c\
	${HWROOT}/libraries/nffs/src/fs/fs/src/fs_mkdir.c\
	${HWROOT}/libraries/nffs/src/fs/fs/src/fs_mount.c\
	${HWROOT}/libraries/nffs/src/fs/fs/src/fsutil.c\
	${HWROOT}/libraries/nffs/src/fs/nffs/src/nffs.c\
	${HWROOT}/libraries/nffs/src/fs/nffs/src/nffs_area.c\
	${HWROOT}/libraries/nffs/src/fs/nffs/src/nffs_block.c\
	${HWROOT}/libraries/nffs/src/fs/nffs/src/nffs_cache.c\
	${HWROOT}/libraries/nffs/src/fs/nffs/src/nffs_config.c\
	${HWROOT}/libraries/nffs/src/fs/nffs/src/nffs_crc.c\
	${HWROOT}/libraries/nffs/src/fs/nffs/src/nffs_dir.c\
	${HWROOT}/libraries/nffs/src/fs/nffs/src/nffs_file.c\
	${HWROOT}/libraries/nffs/src/fs/nffs/src/nffs_flash.c\
	${HWROOT}/libraries/nffs/src/fs/nffs/src/nffs_format.c\
	${HWROOT}/libraries/nffs/src/fs/nffs/src/nffs_gc.c\
	${HWROOT}/libraries/nffs/src/fs/nffs/src/nffs_hash.c\
	${HWROOT}/libraries/nffs/src/fs/nffs/src/nffs_inode.c\
	${HWROOT}/libraries/nffs/src/fs/nffs/src/nffs_misc.c\
	${HWROOT}/libraries/nffs/src/fs/nffs/src/nffs_path.c\
	${HWROOT}/libraries/nffs/src/fs/nffs/src/nffs_restore.c\
	${HWROOT}/libraries/nffs/src/fs/nffs/src/nffs_write.c\
	${HWROOT}/libraries/nffs/src/hw/hal/src/hal_flash.c\
	${HWROOT}/libraries/nffs/src/kernel/os/src/os_mempool.c\
	${HWROOT}/libraries/nffs/src/sys/flash_map/src/flash_map.c\
	${HWROOT}/libraries/nffs/src/util/crc/src/crc16.c\
	${HWROOT}/libraries/nffs/src/util/crc/src/crc8.c

NFFS_DIR = ${HWROOT}/libraries/nffs/src
NFFS_DIR_DISK = ${NFFS_DIR}/fs/disk/src
NFFS_DIR_FS = ${NFFS_DIR}/fs/fs/src
NFFS_DIR_NFFS = ${NFFS_DIR}/fs/nffs/src
NFFS_DIR_HAL = ${NFFS_DIR}/hw/hal/src
NFFS_DIR_KRNL = ${NFFS_DIR}/kernel/os/src
NFFS_DIR_FLASH = ${NFFS_DIR}/sys/flash_map/src
NFFS_DIR_CRC = ${NFFS_DIR}/util/crc/src

NFFS_OBJS = $(addprefix ${OUT}/, \
	$(patsubst %.c, %.c.o, $(patsubst %.cpp, %.cpp.o, $(notdir ${NFFS_SRCS}))))

CORE_SRCS = \
	${HWROOT}/variants/feather52/variant.cpp\
	${HWROOT}/cores/nRF5/gcc_startup_nrf52.S\
	${HWROOT}/cores/nRF5/pulse_asm.S\
	${HWROOT}/cores/nRF5/WInterrupts.c\
	${HWROOT}/cores/nRF5/delay.c\
	${HWROOT}/cores/nRF5/hooks.c\
	${HWROOT}/cores/nRF5/itoa.c\
	${HWROOT}/cores/nRF5/nrf52_flash.c\
	${HWROOT}/cores/nRF5/pulse.c\
	${HWROOT}/cores/nRF5/syscall_newlib.c\
	${HWROOT}/cores/nRF5/wiring.c\
	${HWROOT}/cores/nRF5/wiring_analog_nRF52.c\
	${HWROOT}/cores/nRF5/wiring_digital.c\
	${HWROOT}/cores/nRF5/wiring_private.c\
	${HWROOT}/cores/nRF5/wiring_shift.c\
	${HWROOT}/cores/nRF5/SDK/components/libraries/util/app_util_platform.c\
	${HWROOT}/cores/nRF5/SDK/components/toolchain/system_nrf52.c\
	${HWROOT}/cores/nRF5/avr/dtostrf.c\
	${HWROOT}/cores/nRF5/freertos/portable/CMSIS/nrf52/port_cmsis.c\
	${HWROOT}/cores/nRF5/freertos/portable/CMSIS/nrf52/port_cmsis_systick.c\
	${HWROOT}/cores/nRF5/freertos/portable/GCC/nrf52/port.c\
	${HWROOT}/cores/nRF5/freertos/source/croutine.c\
	${HWROOT}/cores/nRF5/freertos/source/event_groups.c\
	${HWROOT}/cores/nRF5/freertos/source/list.c\
	${HWROOT}/cores/nRF5/freertos/source/queue.c\
	${HWROOT}/cores/nRF5/freertos/source/tasks.c\
	${HWROOT}/cores/nRF5/freertos/source/timers.c\
	${HWROOT}/cores/nRF5/freertos/source/portable/MemMang/heap_3.c\
	${HWROOT}/cores/nRF5/sysview/SEGGER_SYSVIEW_Config_FreeRTOS.c\
	${HWROOT}/cores/nRF5/sysview/SEGGER_SYSVIEW_FreeRTOS.c\
	${HWROOT}/cores/nRF5/sysview/SEGGER/SEGGER_RTT.c\
	${HWROOT}/cores/nRF5/sysview/SEGGER/SEGGER_SYSVIEW.c\
	${HWROOT}/cores/nRF5/utility/AdaCallback.c\
	${HWROOT}/cores/nRF5/utility/utilities.c\
	${HWROOT}/cores/nRF5/HardwarePWM.cpp\
	${HWROOT}/cores/nRF5/IPAddress.cpp\
	${HWROOT}/cores/nRF5/Print.cpp\
	${HWROOT}/cores/nRF5/RingBuffer.cpp\
	${HWROOT}/cores/nRF5/Stream.cpp\
	${HWROOT}/cores/nRF5/Uart.cpp\
	${HWROOT}/cores/nRF5/WMath.cpp\
	${HWROOT}/cores/nRF5/WString.cpp\
	${HWROOT}/cores/nRF5/abi.cpp\
	${HWROOT}/cores/nRF5/debug.cpp\
	${HWROOT}/cores/nRF5/main.cpp\
	${HWROOT}/cores/nRF5/new.cpp\
	${HWROOT}/cores/nRF5/rtos.cpp\
	${HWROOT}/cores/nRF5/wiring_analog.cpp\
	${HWROOT}/cores/nRF5/utility/adafruit_fifo.cpp

CORE_DIR = ${HWROOT}/cores/nRF5
CORE_DIR_VAR = ${HWROOT}/variants/feather52
CORE_DIR_UTIL = ${CORE_DIR}/utility
CORE_DIR_SDKUTIL = ${CORE_DIR}/SDK/components/libraries/util
CORE_DIR_TOOLCHAIN = ${CORE_DIR}/SDK/components/toolchain
CORE_DIR_AVR = ${CORE_DIR}/avr
CORE_DIR_RTOS_CMSIS = ${CORE_DIR}/freertos/portable/CMSIS/nrf52
CORE_DIR_RTOS_GCC = ${CORE_DIR}/freertos/portable/GCC/nrf52
CORE_DIR_RTOS = ${CORE_DIR}/freertos/source
CORE_DIR_RTOS_MEM = ${CORE_DIR}/freertos/source/portable/MemMang
CORE_DIR_SYSVIEW = ${CORE_DIR}/sysview
CORE_DIR_SV_SEG = ${CORE_DIR}/sysview/SEGGER

CORE_OBJS = \
	$(addprefix ${OUT}/, \
		$(patsubst %.c, %.c.o, \
			$(patsubst %.cpp, %.cpp.o, \
				$(patsubst %.S, %.S.o, $(notdir ${CORE_SRCS})))))

.PHONY: clean left right flashl flashr

all: ${OUT} left right

flashl: left
#TODO: flash this thing!

flashr: right
	#TODO: flash this thing!

left: ${OUT}/left-slave.zip

right: ${OUT}/right-master.zip

bflib: ${OUT} ${BFLIB_OBJS}

nffs: ${OUT} ${NFFS_OBJS}

${OUT}/%.zip : ${OUT}/%.hex
	${NRFUTIL} dfu genpkg --dev-type 0x0052 --sd-req 0x0088 --application $< $@

${OUT}/%.hex : ${OUT}/%.elf
	${OBJCOPY} -O ihex $< $@

${OUT}/left-slave.elf : ${OUT}/core.a ${NFFS_OBJS} ${BFLIB_OBJS}

${OUT}/right-master.elf : ${OUT}/core.a ${NFFS_OBJS} ${BFLIB_OBJS}

${OUT}/%.elf : ${OUT}/%.o
	${CC}  "-L${OUT}" -Os -Wl,--gc-sections -save-temps \
	"-L${HWROOT}/variants/feather52" "-L${HWROOT}/cores/nRF5/linker" \
	"-Tbluefruit52_s132_2.0.1.ld" \
	"-Wl,-Map,$@.map" \
	${TARGET} -u _printf_float \
	-Wl,--cref -Wl,--check-sections -Wl,--gc-sections \
	-Wl,--unresolved-symbols=report-all -Wl,--warn-common \
	-Wl,--warn-section-align --specs=nano.specs --specs=nosys.specs -o $@ \
	$< ${NFFS_OBJS} ${BFLIB_OBJS} \
	-Wl,--start-group -lm "${OUT}/core.a" -Wl,--end-group


${OUT}/core.a: ${CORE_OBJS}
	-rm $@
	${AR} rcs $@ ${CORE_OBJS}

${OUT}:
	@-mkdir ${OUT}

${OUT}/left-slave.o: left-slave.cpp shared.h

${OUT}/right-master.o: right-master.cpp keyhelpers.h keymap.h keystate.h shared.h

${OUT}/%.S.o : ${CORE_DIR}/%.S
	${CC} -c ${SFLAGS} -o $@ $<

${OUT}/%.cpp.o : ${CORE_DIR}/%.cpp
	${CPP} -c ${CPPFLAGS} -o $@ $<

${OUT}/%.c.o : ${CORE_DIR}/%.c
	${CC} -c ${CFLAGS} -o $@ $<

${OUT}/%.cpp.o : ${CORE_DIR_VAR}/%.cpp
	${CPP} -c ${CPPFLAGS} -o $@ $<

${OUT}/%.c.o : ${CORE_DIR_UTIL}/%.c
	${CC} -c ${CFLAGS} -o $@ $<

${OUT}/%.cpp.o : ${CORE_DIR_UTIL}/%.cpp
	${CPP} -c ${CPPFLAGS} -o $@ $<

${OUT}/%.c.o : ${CORE_DIR_SDKUTIL}/%.c
	${CC} -c ${CFLAGS} -o $@ $<

${OUT}/%.c.o : ${CORE_DIR_TOOLCHAIN}/%.c
	${CC} -c ${CFLAGS} -o $@ $<

${OUT}/%.c.o : ${CORE_DIR_AVR}/%.c
	${CC} -c ${CFLAGS} -o $@ $<

${OUT}/%.c.o : ${CORE_DIR_RTOS_CMSIS}/%.c
	${CC} -c ${CFLAGS} -o $@ $<

${OUT}/%.c.o : ${CORE_DIR_RTOS_GCC}/%.c
	${CC} -c ${CFLAGS} -o $@ $<

${OUT}/%.c.o : ${CORE_DIR_RTOS}/%.c
	${CC} -c ${CFLAGS} -o $@ $<

${OUT}/%.c.o : ${CORE_DIR_RTOS_MEM}/%.c
	${CC} -c ${CFLAGS} -o $@ $<

${OUT}/%.c.o : ${CORE_DIR_SYSVIEW}/%.c
	${CC} -c ${CFLAGS} -o $@ $<

${OUT}/%.c.o : ${CORE_DIR_SV_SEG}/%.c
	${CC} -c ${CFLAGS} -o $@ $<

${OUT}/%.o: %.cpp
	${CPP} -c ${CPPFLAGS} -o $@ $<

${OUT}/%.cpp.o: ${NFFS_DIR}/%.cpp
	${CPP} -c ${CPPFLAGS} -o $@ $<

${OUT}/%.c.o: ${NFFS_DIR_DISK}/%.c
	${CC} -c ${CFLAGS} -o $@ $<

${OUT}/%.c.o: ${NFFS_DIR_FS}/%.c
	${CC} -c ${CFLAGS} -o $@ $<

${OUT}/%.c.o: ${NFFS_DIR_NFFS}/%.c
	${CC} -c ${CFLAGS} -o $@ $<

${OUT}/%.c.o: ${NFFS_DIR_HAL}/%.c
	${CC} -c ${CFLAGS} -o $@ $<

${OUT}/%.c.o: ${NFFS_DIR_KRNL}/%.c
	${CC} -c ${CFLAGS} -o $@ $<

${OUT}/%.c.o: ${NFFS_DIR_FLASH}/%.c
	${CC} -c ${CFLAGS} -o $@ $<

${OUT}/%.c.o: ${NFFS_DIR_CRC}/%.c
	${CC} -c ${CFLAGS} -o $@ $<

${OUT}/%.cpp.o: ${BFLIB_DIR}/%.cpp
	${CPP} -c ${CPPFLAGS} -o $@ $<

${OUT}/%.cpp.o: ${BFLIB_DIRSERVICES}/%.cpp
	${CPP} -c ${CPPFLAGS} -o $@ $<

${OUT}/%.cpp.o: ${BFLIB_DIRCLIENTS}/%.cpp
	${CPP} -c ${CPPFLAGS} -o $@ $<

${OUT}/%.cpp.o: ${BFLIB_DIRUTILITY}/%.cpp
	${CPP} -c ${CPPFLAGS} -o $@ $<

${OUT}/%.c.o: ${BFLIB_DIRUTILITY}/%.c
	${CC} -c ${CFLAGS} -o $@ $<

clean:
	@-rm -rf ${OUT}

# /usr/local/bin/nrfutil --verbose dfu serial -pkg ${OUTPUT}/RightHand_master.ino.zip -p /dev/cu.SLAB_USBtoUART -b 115200
