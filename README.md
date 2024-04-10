# einat-ebpf for openwrt

## What is this

Build scripts for [Openwrt](https://openwrt.org) to create package [einat-ebpf](https://github.com/EHfive/einat-ebpf)

## Requirements

1. Openwrt with `Reduce debugging information` set to N

2. Openwrt kernel module `kmod-sched-bpf`

## Usage:

1. Clone this repo

   ```
   git clone https://github.com/arenekosreal/einat-ebpf \
    /path/to/openwrt/package/openwrt-packages/einat-ebpf
   ```
  Don't forget to replace `/path/to/openwrt` with real path of your openwrt source code.

2. Configuration

   Run `make menuconfig` to open openwrt configuration, do those changes:

   1. `Global build settings -> Kernel build options -> Reduce debugging information` set to N

   2. `Advanced configuration options (for developers) -> BPF toolchain` set to `Use host LLVM toolchain`

      Openwrt use clang 15, which is not new enough. clang 17 on Arch Linux is tested and build successfully.

   3. You can find `einat-ebpf` at `Network -> Routing and Rediretion` after the steps above are done correctly.

      By default the `ipv6` feature is not enabled, you can enable it in the menu.

3. Build

   Run `make package/openwrt-packages/einat-ebpf/compile` to build ipk file. You will find output at `bin/packages/$TARGET_ARCH/packages`

## License

This repository is licenced under `WTFPL` license, you can do whatever you want to this repository.

But Openwrt is licensed under GPL-2.0-only and einat-ebpf is licensed under GPL-2.0-or-later, 
please follow their licences when make contributions to them.
