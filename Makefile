default: build

.PHONY: clean

multiboot_header.o: multiboot_header.asm
		nasm -f elf64 multiboot_header.asm

boot.o: boot.asm
		nasm -f elf64 boot.asm

kernel.bin: multiboot_header.o boot.o linker.ld
		ld --nmagic --output=kernel.bin --script=linker.ld multiboot_header.o boot.o

os.iso: kernel.bin grub.cfg
		mkdir -p isofiles/boot/grub
		cp grub.cfg isofiles/boot/grub
		cp kernel.bin isofiles/boot/
		grub-mkrescue -o os.iso isofiles

build: os.iso

run: os.iso
		qemu-system-x86_64 -cdrom os.iso

clean:
		rm -f multiboot_header.o
		rm -f boot.o
		rm -f kernel.bin
		rm -rf isofiles
		rm -f os.iso
