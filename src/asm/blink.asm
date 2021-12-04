	.equ LED_PIN,		7

	.equ RAM,		0x20000100
	.equ STACK,		(RAM + 0x47f00)

	.equ PERIPHERAL_BASE,	0x40000000
	.equ APB_BASE,		(PERIPHERAL_BASE + 0x10000)

	.equ RCC_BASE,		(PERIPHERAL_BASE + 0xE00)

	.equ CLK_EN,		0x00
	.equ CLK_MASK,		0x04
	.equ BBP_CLK,		0x08
	.equ RST,		0x0C
	.equ CLK_DIV,		0x10
	.equ CLK_SEL,		0x14
	.equ I2S_CLK,		0x18
	.equ RST_STATUS,	0x1C

	.equ CLK_EN_GPIO,	11

	.equ GPIOA_BASE,	(APB_BASE + 0x1200)
	.equ GPIOB_BASE,	(APB_BASE + 0x1400)

	.equ DATA,		0x00
	.equ DATA_EN,		0x04
	.equ DIR,		0x08
	.equ PULLUP_EN,		0x0C
	.equ AFSEL,		0x10
	.equ AFS1,		0x14
	.equ AFS0,		0x18
	.equ PULLDOWN_EN,	0x1C
	.equ IS,		0x20
	.equ IBE,		0x24
	.equ IEV,		0x28
	.equ IE,		0x2C
	.equ RIS,		0x30
	.equ MIS,		0x34
	.equ IC,		0x38

	.section .text
#	.org 0x08010400
vtable:
	.word reset

	.globl	reset
#	.org 0x08010500
reset:
	lrw	r0, 0xe0000200
	mtcr	r0, psr
	lrw	r0, STACK
	mov	r14, r0
	lrw	r0, __start
	jsr	r0
	br	.

	.globl __start
__start:
	br	main

	.globl	main
main:
	lrw	r0, RCC_BASE
	ld.w	r1, (r0, CLK_EN)
	bseti   r1, CLK_EN_GPIO
	st.w	r1, (r0, CLK_EN)

	movi	r3, LED_PIN

	lrw	r2, GPIOB_BASE

	st.w	r3, (r2, DATA_EN)
	st.w	r3, (r2, DIR)
	st.w	r3, (r2, PULLUP_EN)

	ld.w	r1, (r2, PULLDOWN_EN)
	andn	r1, r3
	st.w	r1, (r2, PULLDOWN_EN)

	ld.w	r1, (r2, DATA)
	or	r1, r3
	st.w	r1, (r2, DATA)

loop:
	lrw	r1, 12000000
1:
	nop
	subi	r1, 1
	cmplti	r1, 1
	bf	1b

	ld.w	r1, (r2, DATA)
	xor	r1, r3
	st.w	r1, (r2, DATA)

	br	loop

	rts

	.literals

	.end
