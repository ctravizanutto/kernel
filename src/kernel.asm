; PROTECTED MODE
[BITS 32]
global _start
CODE_SEG equ 0x08
DATA_SEG equ 0x10

extern kernel_main

_start:
    mov ax, DATA_SEG
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov ebp, 0x00200000
    mov esp, ebp

    ; enable A20 line
    in al, 0x92
    or al, 2
    out 0x92, al
    

    ; remap master PIC
    mov al, 00010001b                   ; tell master PIC
    out 0x20, al

    mov al, 0x20                        ; interrupt 0x20 is where ISR should start
    out 0x21, al

    mov al, 000000001b                        
    out 0x21, al

    call kernel_main
    jmp $

times 512-($ - $$) db 0