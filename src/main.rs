#![no_std]
#![no_main]
#![allow(clippy::empty_loop)]

use n64::text::Colour;
use n64::vi::vi;

#[no_mangle]
fn main() -> ! {
    let vi = vi();

    vi.init();

    vi.clear_framebuffer();

    vi.print_string(6, 2, Colour::WHITE, "Hello, World!");
    vi.print_string(6, 3, Colour::WHITE, "I'm running from pure     !");
    vi.print_string(28, 3, Colour::RED, "Rust");

    vi.wait_vsync();
    vi.next_framebuffer();

    loop {}
}
