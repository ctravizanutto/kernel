ASM_FILES = $(wildcard src/*.asm) $(wildcard src/**/*.asm)
ASM_OBJ = $(patsubst src/%.asm, build/%.asm.o, $(filter-out src/boot/boot.asm, $(ASM_FILES)))

C_FILES = $(wildcard src/*.c) $(wildcard src/**/*.c)
C_OBJ = $(patsubst src/%.c, build/%.o, $(C_FILES))

OBJ_FILES = $(ASM_OBJ) $(C_OBJ)
BIN_FILES = bin/boot.bin bin/kernel.bin

INCLUDES = -I./src -I./src/memory -I./src/io
FLAGS = -g -ffreestanding -falign-jumps -falign-functions -falign-labels -falign-loops -fstrength-reduce -fomit-frame-pointer -finline-functions -Wno-unused-function -fno-builtin -Werror -Wno-unused-label -Wno-cpp -Wno-unused-parameter -nostdlib -nostartfiles -nodefaultlibs -Wall -O0 -Iinc

all: $(BIN_FILES)
	dd if=bin/boot.bin >> bin/os.bin
	dd if=bin/kernel.bin >> bin/os.bin
	dd if=/dev/zero bs=512 count=100 >> bin/os.bin

build/%.asm.o: src/%.asm
	nasm -f elf -g $< -o $@

build/%.o: src/%.c
	i686-elf-gcc $(INCLUDES) $(FLAGS) -std=gnu99 -c $< -o $@

bin/kernel.bin: $(OBJ_FILES)
	i686-elf-ld -g -relocatable $(OBJ_FILES) -o build/kernelfull.o
	i686-elf-gcc -T src/linker.ld -o $@ $(FLAGS) build/kernelfull.o

bin/boot.bin: src/boot/boot.asm
	nasm -f bin $< -o $@

clean:
	find build -type f -delete
	find bin -type f -delete