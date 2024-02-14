#/bin/bash

export PREFIX="$HOME/opt/i686-elf-tools-linux"
export TARGET=i686-elf
export PATH="$PREFIX/bin:$PATH"

mkdir -p bin
mkdir -p build
mkdir -p build/memory
mkdir -p build/idt
mkdir -p build/io

make all