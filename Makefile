OBJ_FILES = build/kernel.asm.o build/kernel.o
BIN_FILES = bin/boot.bin bin/kernel.bin
INCLUDES = -I./src
FLAGS = -g -ffreestanding -falign-jumps -falign-functions -falign-labels -falign-loops -fstrength-reduce -fomit-frame-pointer -finline-functions -Wno-unused-function -fno-builtin -Werror -Wno-unused-label -Wno-cpp -Wno-unused-parameter -nostdlib -nostartfiles -nodefaultlibs -Wall -O0 -Iinc

all: $(BIN_FILES)
	rm -rf bin/os.bin
	dd if=bin/boot.bin >> bin/os.bin
	dd if=bin/kernel.bin >> bin/os.bin
	dd if=/dev/zero bs=512 count=100 >> bin/os.bin

build/kernel.asm.o: src/kernel.asm
	nasm -f elf -g src/kernel.asm -o build/kernel.asm.o

build/kernel.o: src/kernel.c
	i686-elf-gcc $(INCLUDES) $(FLAGS) -std=gnu99 -c $< -o $@

bin/kernel.bin: $(OBJ_FILES)
	i686-elf-ld -g -relocatable $(OBJ_FILES) -o build/kernelfull.o
	i686-elf-gcc -T src/linker.ld -o $@ $(FLAGS) build/kernelfull.o

bin/boot.bin: src/boot/boot.asm
	nasm -f bin src/boot/boot.asm -o bin/boot.bin

clean:
	rm -rf build/*
	rm -rf bin/*