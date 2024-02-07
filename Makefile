FILES = build/kernel.asm.o bin/boot.bin bin/kernel.bin 

all: $(FILES)
	rm -rf bin/os.bin
	dd if=bin/boot.bin >> bin/os.bin
	dd if=bin/kernel.bin >> bin/os.bin
	dd if=/dev/zero bs=512 count=100 >> bin/os.bin

build/kernel.asm.o: src/kernel.asm
	nasm -f elf  -g src/kernel.asm -o build/kernel.asm.o

bin/kernel.bin: build/kernel.asm.o
	i686-elf-ld -g -relocatable $< -o build/kernelfull.o
	i686-elf-gcc -T src/linker.ld -o $@ -ffreestanding -O0 -nostdlib build/kernelfull.o

bin/boot.bin: src/boot/boot.asm
	nasm -f bin src/boot/boot.asm -o bin/boot.bin

clean:
	rm -rf build/*
	rm -rf bin/*