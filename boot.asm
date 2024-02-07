ORG 0
BITS 16

; bios parameter block 
_start:
    jmp short step1
    nop
times 33 db 0

step1:
    jmp 0x7c0:step2

step2:
    cli                                 ; clear interrupts
    mov ax, 0x7C0                       
    mov ds, ax                          ; set data segment register to 0x7C0
    mov es, ax                          ; set extra segment register to 0x7C0
    mov ax, 0x0                         
    mov ss, ax                          ; set stack segment register to 0x0 
    mov sp, 0x7c00
    sti                                 ; enble interrupts

    mov si, message
    call print
    jmp $

print:
    mov bx, 0
.loop:
    lodsb
    cmp al, 0
    je .done
    call print_char
    jmp .loop
.done:
    ret

print_char:
    mov ah, 0eh
    int 0x10
    ret

message: db 'hello world', 0

times 510-($ - $$) db 0
dw 0xAA55