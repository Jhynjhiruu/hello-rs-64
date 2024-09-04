OUTPUT_FORMAT ("elf32-ntradbigmips")
OUTPUT_ARCH (mips)

MEMORY {
    KERN : ORIGIN = 0xA0000000, LENGTH = 0x00400000
    CACHED : ORIGIN = 0x80000000, LENGTH = 0x00400000
    DUMMY : ORIGIN = 0x00000000, LENGTH = 0xFFFFFFFF
}

__int_handler = 0x80000180;
__entry = 0x80000400;

SECTIONS {
    __romPos = 0;

    header_ROM_START = __romPos;
    .hdr : AT(header_ROM_START) {
        LONG(0x80371240)
        
        . = 8;
        LONG(__entry)

        . = 0x10;
        LONG(__load_size)

        . = 0x40;
        KEEP(*(.ipl3*));
        . = ALIGN(16);
    } > DUMMY
    __romPos += SIZEOF(.hdr);
    __romPos = ALIGN(__romPos, 16);
    header_ROM_END = __romPos;

    __load_start = __romPos;

    __romPos = boot_ROM_END;
    int_handler_ROM_START = __romPos;
    .int_handler __int_handler : AT(int_handler_ROM_START) {
        __int_handler_start = .;
        KEEP(*(.int_handler*));
        . = ALIGN(16);
        __int_handler_end = .;
    } > CACHED
    __romPos += SIZEOF(.int_handler);
    __romPos = ALIGN(__romPos, 16);
    int_handler_ROM_END = __romPos;

    __romPos = header_ROM_END;
    boot_ROM_START = __romPos;
    .boot __entry : AT(boot_ROM_START) {
        __boot_start = .;
        KEEP(*(.entry*));
        KEEP(*(.boot*));
        //*compiler_builtins*(.text*);
        . = ALIGN(16);
        __boot_end = .;
    } > CACHED
    __romPos += SIZEOF(.boot);
    __romPos = ALIGN(__romPos, 16);
    boot_ROM_END = __romPos;

    ASSERT(SIZEOF(.boot) < (1024 * 1024), ".boot section is too large")

    __romPos = int_handler_ROM_END;
    text_ROM_START = __romPos;
    .text __boot_end + int_handler_ROM_END - int_handler_ROM_START: AT(text_ROM_START) {
        __text_start = .;
        *(.text*);
        . = ALIGN(16);
        __text_end = .;
    } > CACHED
    __romPos += SIZEOF(.text);
    __romPos = ALIGN(__romPos, 16);
    text_ROM_END = __romPos;

    data_ROM_START = __romPos;
    .data ALIGN(16) : AT(data_ROM_START) {
        *(.data*);
        . = ALIGN(16);
    } > CACHED
    __romPos += SIZEOF(.data);
    __romPos = ALIGN(__romPos, 16);
    data_ROM_END = __romPos;

    rodata_ROM_START = __romPos;
    .rodata ALIGN(16) : AT(rodata_ROM_START) SUBALIGN(16) {
        TEST_IMAGE_ROM_START = .;
        KEEP(*(.rodata.TEST_IMAGE));
        *(.rodata*);
        . = ALIGN(16);
    } > CACHED
    __romPos += SIZEOF(.rodata);
    __romPos = ALIGN(__romPos, 16);
    rodata_ROM_END = __romPos;

    __load_end = __romPos;
    __load_size = __load_end - __load_start;

    . = ALIGN(16);
    .bss (NOLOAD) : {
        __bss_start = .;
        *(.bss)
        *(.bss*)
        *(.gnu.linkonce.b.*)
        *(COMMON)
        . = ALIGN(16);
         __bss_end = .;
         __bss_size = (__bss_end - __bss_start);
    } > CACHED

    _heap_start = __bss_end;
    _heap_len = (ORIGIN(CACHED) + LENGTH(CACHED)) - __bss_end - SIZEOF(.stack);

    .stack _heap_start + _heap_len (NOLOAD) : {
        __stack_start = .;
        KEEP(*(.stack));
        KEEP(*(.stack*));
        . = ALIGN(16);
        __stack_end = .;
        __stack_size = (__stack_end - __stack_start);
    } > CACHED

    osTvType            = 0x80000300;
    osRomType           = 0x80000304;
    osRomBase           = 0x80000308;
    osResetType         = 0x8000030C;
    osCicId             = 0x80000310;
    osVersion           = 0x80000314;
    osMemSize           = 0x80000318;
    osAppNMIBuffer      = 0x8000031C;

    __osBbEepromAddress = 0x8000035C;
    __osBbEepromSize    = 0x80000360;
    __osBbFlashAddress  = 0x80000364;
    __osBbFlashSize     = 0x80000368;
    __osBbSramAddress   = 0x8000036C;
    __osBbSramSize      = 0x80000370;
    __osBbPakAddress    = 0x80000374;
    __osBbPakSize       = 0x80000384;
    __osBbIsBb          = 0x80000388;
    __osBbHackFlags     = 0x8000038C;
    __osBbStashMagic    = 0x80000390;
    __osBbPakBindings   = 0x80000394;
    __osBbPakStateName  = 0x800003A4;
    __osBbStateDirty    = 0x800003B4;
    __osBbAuxDataLimit  = 0x800003B8;


    /DISCARD/ : {
        *(.MIPS.*)
        *(.comment)
        *(.mdebug.*)
        *(.pdr)
        *(.reginfo)
        *(.eh_frame)

        /*
         * We may need the global offset table some day.
         * Our target is currently set with a static relocation-model, so this
         * might not be needed after all.
         */
        *(.got)
    }
}