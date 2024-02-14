ASM_FILES = $(wildcard $(shell find src -type f -name '*.asm'))
ASM_OBJ = $(patsubst src/%.asm, build/%.asm.o, $(filter-out %boot.asm, $(ASM_FILES)))

C_FILES = $(wildcard $(shell find src -type f -name '*.c'))
C_OBJ = $(patsubst src/%.c, build/%.o, $(C_FILES))

OBJ_FILES = $(ASM_OBJ) $(C_OBJ)
BIN_FILES = bin/boot.bin bin/kernel.bin

INCLUDES = $(addprefix -I, $(wildcard $(shell find src -type d)))
FLAGS = -g -ffreestanding -falign-jumps -falign-functions -falign-labels -falign-loops -fstrength-reduce -fomit-frame-pointer -finline-functions -Wno-unused-function -fno-builtin -Werror -Wno-unused-label -Wno-cpp -Wno-unused-parameter -nostdlib -nostartfiles -nodefaultlibs -Wall -O0 -Iinc

.PHONY: all create_build_dirs

all: create_build_dirs $(BIN_FILES)
	@dd status=none if=bin/boot.bin > bin/os.bin 
	@dd status=none if=bin/kernel.bin >> bin/os.bin
	@dd status=none if=/dev/zero bs=512 count=100 >> bin/os.bin
	@printf '\nCOMPILATION FINISHED\n'

build/%.asm.o: src/%.asm
	nasm -f elf -g -F dwarf $< -o $@

build/%.o: src/%.c
	i686-elf-gcc $(INCLUDES) $(FLAGS) -std=gnu99 -c $< -o $@

bin/kernel.bin: $(OBJ_FILES)
	i686-elf-ld -g -relocatable $(OBJ_FILES) -o build/kernelfull.o
	i686-elf-gcc -T src/linker.ld -o $@ $(FLAGS) build/kernelfull.o

bin/boot.bin: src/boot/boot.asm
	nasm -f bin $< -o $@

create_build_dirs:
	@mkdir -p $(patsubst src/%, build/%, $(filter-out src/boot, $(shell find src/ -type d)))
	@mkdir -p bin

clean:
	find build -type f -delete
	find bin -type f -delete