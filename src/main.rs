#![no_std]
#![no_main]
#![allow(clippy::empty_loop)]

use n64::boot::interrupts::im;
use n64::si::si;
use n64::text::Colour;
use n64::vi::vi;

#[no_mangle]
fn main() -> ! {
    let im = im();
    im.set_btn(true);

    let vi = vi();

    //vi.pll_init();
    //vi.init_calibrate();
    vi.init();

    vi.clear_framebuffer();

    vi.print_string(6, 2, Colour::WHITE, "Hello, World!");
    vi.print_string(6, 3, Colour::WHITE, "I'm running from pure     !");
    vi.print_string(28, 3, Colour::RED, "Rust");

    vi.wait_vsync();
    vi.next_framebuffer();

    let si = si();
    si.init_hw();
    si.txrx(b"Hello, World!\n", None);

    loop {}
}
