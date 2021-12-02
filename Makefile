TOOLDIR=../wm-sdk-w806/toolchain/bin

WM_TOOL = ./wm_tool
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
	$(RM) blink.fls blink.img blink.bin blink.elf blink.o

$(WM_TOOL):	wm_tool.c
	gcc -o $@ $< -lpthread

./img/W800_secboot.img:	./bin/W800_secboot.bin
	$(WM_TOOL) -b $< -fc 0 -it 0 -ih 8002000 -ra 8002400 -ua 8010000 -nh 8010000 -un 0 -o $@

.SUFFIXES:	.img .fls .bin .asm .elf

.bin.img:
	$(WM_TOOL) -b $< -fc 0 -it 1 -ih 8010000 -ra 8010400 -ua 8010000 -nh 0 -un 0 -vs -o $@

.img.fls:
	cat ./img/W806_secboot.img $< > $@

.asm.o:
	$(AS) -o $@ $<

#.c.o:
#	$(CC) -o $@ $<

.o.elf:
	$(LD) -T csky.ld -e reset -o $@ $<

.elf.bin:
	$(OBJCOPY) -j .text -Obinary $< $@
