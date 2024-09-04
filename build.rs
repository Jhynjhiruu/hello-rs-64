fn main() {
    println!("cargo:rustc-link-arg=-Ttargets/linker.ld");
    println!("cargo:rustc-link-arg=--Map=target/map");

    println!("cargo:rerun-if-changed=targets/linker.ld");
}
