# hello-rs-64
This is a demo program to show off basic usage of [my iQue Player/N64 hardware library](https://github.com/Jhynjhiruu/n64-rs). It has more features beyond what's shown off here, but this is about as simple an application as you can write, which clarifies what's necessary for the build to work.

## Compiling
Ensure you have a Rust toolchain set up, plus binutils (GNU is preferred if available, though you'll also need `llvm-objcopy`), and then just run `make`. You might need to add `rust-src` via Rustup before it'll build.

Optionally, use `make DEBUG=1` to build without optimisations (this may or may not produce a working ROM).

Use `make IPL3=0` to build without using libdragon's IPL3 (use this if you don't have libdragon installed).

To build an iQue Player .app file, run `make app`. You can override the path to the iQueCrypt executable with `make app IQUECRYPT=path/to/iquecrypt`,
and override the CID, key and IV with `make app CID=00123456 KEY=000102030405060708090A0B0C0D0E0F IV=FFFEFDFCFBFAF9F8F7F6F5F4F3F2F1F0`.

Run `make asm` to run the output ROM through spimdisasm. Configuration of this can be done via more Make variables.

Using `rust-objcopy` instead of `llvm-objcopy` will work just fine, though you'll need to install that manually for the toolchain version required for this project. Specify it with `make OBJCOPY=rust-objcopy`.

## Screenshots
![image](https://github.com/user-attachments/assets/ba370d77-b43f-4c74-ae39-77356fef4a21)
![image](https://github.com/user-attachments/assets/f972b13e-5c92-45c5-8503-e49e1cd1b264)
