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

[BITS 32]
load32:
    mov eax, 1
    mov ecx, 100
    mov edi, 0x0100000
    call ata_lba_read
    jmp CODE_SEG:0x0100000

ata_lba_read:
    mov ebx, eax
    ; send highest byte of lba to hdd controller
    shr eax, 24
    or eax, 0xe0                        ; select master drive
    mov dx, 0x1f6
    out dx, al
    
    ; send total sectors to read
    mov eax, ecx
    mov dx, 0x1f2
    out dx, al

    ; send more bits of lba
    mov eax, ebx
    mov dx, 0x1f3
    out dx, al

    mov eax, ebx
    mov dx, 0x1f4
    shr eax, 8
    out dx, al

    ; send upper 16 bits of lba
    mov eax, ebx
    mov dx, 0x1f5
    shr eax, 16
    out dx, al

    mov dx, 0x1f7
    mov al, 0x20
    out dx, al

    ; read all sectors into memory
.next_sector:
    push ecx

    ; check if need to read
.try_again:
    mov dx, 0x1f7
    in al, dx
    test al, 8
    jz .try_again

    mov ecx, 256
    mov dx, 0x1f0
    rep insw
    pop ecx
    loop .next_sector

    ret    

times 510-($ - $$) db 0
dw 0xaa55