.section .vectors
    .align  10
    .globl  __Vectors
    .type   __Vectors, @object
__Vectors:
    .long   Reset_Handler
    .size   __Vectors, . - __Vectors

    .text
    .align  2
_start:
    .text
    .align  2
    .globl  Reset_Handler
    .type   Reset_Handler, %function
Reset_Handler:
    lrw     r0, 0xe0000200
    mtcr    r0, psr

    lrw     r0, 0x20048000
    mov     sp, r0

    lrw    r0, main
    jsr    r0
    .size   Reset_Handler, . - Reset_Handler
