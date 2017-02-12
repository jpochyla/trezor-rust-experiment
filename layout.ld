MEMORY
{
    FLASH  : ORIGIN = 0x08000000, LENGTH = 0x100000 /* entire flash, 1 MiB */
    CCMRAM : ORIGIN = 0x10000000, LENGTH = 0x010000 /* 64 KiB */
    RAM    : ORIGIN = 0x20000000, LENGTH = 0x020000 /* 128 KiB */
}

SECTIONS
{
    .vector_table ORIGIN(FLASH) :
    {
        LONG(ORIGIN(RAM) + LENGTH(RAM))
        KEEP(*(.reset))
        KEEP(*(.exceptions))
        KEEP(*(.interrupts))
    } > FLASH

    .text :
    {
        _stext = .;
        *(.text*)
        _etext = .;
    } > FLASH

    .bss : ALIGN(4)
    {
        _sbss = .;
        *(.bss.*)
        _ebss = ALIGN(4);
    } > RAM

    .data : ALIGN(4)
    {
        _sdata = .;
        *(.data.*)
        _edata = ALIGN(4);
    } > RAM AT > FLASH

    /DISCARD/ :
    {
        *(.ARM.exidx*)
        *(.note.gnu.build-id*)
    }
}

_sidata = LOADADDR(.data);
