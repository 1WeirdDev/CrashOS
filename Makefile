CC      = gcc
CFLAGS  = -g
RM      = rm -f
RF      = rd /s /q
MF 		= mkdir -p

default: all

all: build run

build:
	$(MF) bin
	$(MF) bin/boot
	i686-elf-as src/boot.s -o bin/boot.o
	i686-elf-gcc -c src/kernel.c -o bin/kernel.o -std=gnu99 -ffreestanding -O2 -Wall -Wextra
	i686-elf-gcc -T src/linker.ld -o bin/myos.bin -ffreestanding -O2 -nostdlib bin/boot.o bin/kernel.o -lgcc
	grub-file --is-x86-multiboot bin/myos.bin

	cp bin/myos.bin bin/boot/myos.bin
	cp grub.cfg bin/boot/grub.cfg
	grub-mkimage -v -o myos.iso ./bin/boot

clean:
	rm -rf bin

update:
	clean
	Push.bat
run:
