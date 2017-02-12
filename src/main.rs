#![feature(lang_items)]

#![no_main]
#![no_std]

extern crate compiler_builtins_snapshot;
extern crate r0;

#[no_mangle]
pub extern "C" fn reset() -> ! {
    unsafe {
        init();
    }
    main();
}

unsafe fn init() {
    extern "C" {
        static mut _sbss: u32;
        static mut _ebss: u32;
        static mut _sdata: u32;
        static mut _edata: u32;
        static _sidata: u32;
    }

    r0::zero_bss(&mut _sbss, &mut _ebss);
    r0::init_data(&mut _sdata, &mut _edata, &_sidata);
}

fn main() -> ! {
    loop {}
}

type ResetHandler = unsafe extern "C" fn() -> !;
type ExcHandler = unsafe extern "C" fn();

#[link_section = ".reset"]
#[no_mangle]
pub static __RESET: ResetHandler = reset;

#[link_section = ".exceptions"]
#[no_mangle]
pub static __EXCEPTIONS: [Option<ExcHandler>; 14] = [
    None, // NMI
    None, // Hard fault
    None, // Memory management fault
    None, // Bus fault
    None, // Usage fault
    None, // Reserved
    None, // Reserved
    None, // Reserved
    None, // Reserved
    None, // SVCall
    None, // Debug
    None, // Reserved
    None, // PendSV
    None, // Systick
];

#[lang = "panic_fmt"]
#[no_mangle]
pub fn panic_fmt(_fmt: core::fmt::Arguments, _file: &'static str, _line: u32) {
    loop {}
}
