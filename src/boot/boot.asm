ORG 0x7c00
BITS 16

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

; bios parameter block 
_start:
    jmp short step1
    nop
times 33 db 0

step1:
    jmp 0x00:step2

step2:
    cli                                 ; clear interrupts
    mov ax, 0x00                       
    mov ds, ax                          ; set data segment register to 0x7C0
    mov es, ax                          ; set extra segment register to 0x7C0
    mov ss, ax                          ; set stack segment register to 0x00 
    mov sp, 0x7c00
    sti                                 ; enble interrupts

.load_protected:
    cli
    lgdt[gdt_descriptor]
    mov eax, cr0
    or eax, 0x1
    mov cr0, eax
    jmp CODE_SEG:load32

; global descriptor table
gdt_start:
gdt_null:
    times 2 dd 0x00

; offset 0x8
gdt_code:
    dw 0xffff                           ; segment limit first 0-15 bits
    dw 0                                ; base first 0-15 bits
    db 0                                ; base 0-23 bits
    db 0x9a                             ; access byte  
    db 11001111b                        ; high 4 bits and low 4 bits flag
    db 0                                ; base 24-31 bits
; offset 0x10
gdt_data:
    dw 0xffff                           ; segment limit first 0-15 bits
    dw 0                                ; base first 0-15 bits
    db 0                                ; base 0-23 bits
    db 0x92                             ; access byte  
    db 11001111b                        ; high 4 bits and low 4 bits flag
    db 0                                ; base 24-31 bits                          

gdt_end:
gdt_descriptor:
    dw gdt_end - gdt_start-1
    dd gdt_start

; PROTECTED MODE
[BITS 32]
load32:
    mov ax, DATA_SEG
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov ebp, 0x00200000
    mov esp, ebp

    jmp $

times 510-($ - $$) db 0
dw 0xaa55