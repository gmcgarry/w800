TOPDIR ?= ../..
TOOLDIR ?= $(TOPDIR)/toolchain/bin
WM_TOOL ?= $(TOPDIR)/tools/wm_tool

AS = $(TOOLDIR)/csky-abiv2-elf-as
CC = $(TOOLDIR)/csky-abiv2-elf-gcc
LD = $(TOOLDIR)/csky-abiv2-elf-ld
OBJCOPY = $(TOOLDIR)/csky-abiv2-elf-objcopy
OBJDUMP = $(TOOLDIR)/csky-abiv2-elf-objdump

all:	$(WM_TOOL) blink.fls

load:	blink.fls
	$(WM_TOOL) -c ttyUSB0 -dl $<

list:	blink.bin
	$(OBJDUMP) -D -bbinary -mcsky --adjust-vma 0x08010400 $<

clean:
	$(RM) blink.fls blink.img blink.bin blink.elf blink.o W806_secboot.img

W806_secboot.img:	$(TOPDIR)/bin/W806_secboot.bin
	$(WM_TOOL) -b $< -fc 0 -it 0 -ih 8002000 -ra 8002400 -ua 8010000 -nh 8010000 -un 0 -o W806_secboot

blink.fls:	W806_secboot.img

.SUFFIXES:	.img .fls .bin .asm .elf

.bin.img:
	$(WM_TOOL) -b $< -fc 0 -it 1 -ih 8010000 -ra 8010400 -ua 8010000 -nh 0 -un 0

.img.fls:
	cat W806_secboot.img $< > $@

.asm.o:
	$(AS) -o $@ $<

.o.elf:
	$(LD) -T csky.ld -e reset -o $@ $<

.elf.bin:
	$(OBJCOPY) -j .text -Obinary $< $@
