boot.bin: src/boot/boot.asm
	nasm -f bin src/boot/boot.asm -o bin/boot.bin

clean:
	rm -rf build/*
	rm -rf bin/*