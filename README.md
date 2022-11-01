# Just another bootloader


A bootloader project I started working on to experiement with and learn about boot protocols, their design and the stuff. Very elementary, with probably the worst x86 assembly you will ever see in your life

## Build dependencies
- binutils
- make

## How to test it out?
Well there's nothing spectacular about it so far, but if you insist, in the root directory of repo
```sh
make #or `make clean`
qemu-systtem-i386 -drive format=raw,file=bin/boot.bin
```

## TODO
I have not even started out yet