OBJDUMP=arm-none-eabi-objdump
GDB=arm-none-eabi-gdb
QEMU=qemu-system-gnuarmeclipse
LLDB=lldb
OPENOCD=openocd

TARGET=thumbv7m-none-eabi
KERNEL=target/${TARGET}/debug/trezor-rust

build:
	xargo build --target ${TARGET}

clean:
	xargo clean

check:
	xargo check --target ${TARGET}

objdump:
	${OBJDUMP} -d ${KERNEL}

qemu:
	"`which ${QEMU}`" \
		-machine STM32F4-Discovery \
		-gdb tcp::3333 \
		-S \
		-nographic -monitor null \
		-serial null \
		-kernel ${KERNEL}

openocd:
	${OPENOCD} -f interface/stlink-v2.cfg -f target/stm32f4x.cfg

gdb:
	${GDB} -q ${KERNEL} --eval-command="target remote :3333"

lldb:
	${LLDB} ${KERNEL}
