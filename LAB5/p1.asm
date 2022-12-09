org 0x7c00
bits 16

jmp start

start:
    mov ah, 0x0e
    mov al, 13
    int 0x10
    int 0x21

init_scr:
    cli
    mov ah, 0x00              
    mov al, 0x03
    int 0x10

    mov sp, 0x7c00            

    mov al, 0
    mov ah, 0x05
    int 0x10

    mov bx, 0
    mov dl, 0
    mov dh, 25
    mov ah, 0x02
    int 0x10

    mov si, 0
    mov cx, 2000
    mov al, ' '
    mov ah, 01110001b

    mov dx, 0x0B800
    mov es, dx

cycle:
    test cx, cx
    jz cycle_end
    mov [es:si], al
    inc si
    mov [es:si], ah
    inc si
    dec cx
    jmp cycle
cycle_end:
    ;popad    

print_hello:
    mov bx, 0
    mov dl, 18 ;32
    mov dh, 6
    mov ah, 0x02
    int 0x10
    mov si, name1
    call print_str      
        
    mov bx, 0
    mov dl, 18 ;32
    mov dh, 7
    mov ah, 0x02
    int 0x10
    mov si, name2       
    call print_str      
        
    mov bx, 0
    mov dl, 18 ;32
    mov dh, 8
    mov ah, 0x02
    int 0x10
    mov si, name3
    call print_str

    mov bx, 0
    mov dl, 32
    mov dh, 22
    mov ah, 0x02
    int 0x10
    mov si, press
    call print_str

    mov bx, 0
    mov dl, 0
    mov dh, 25
    mov ah, 0x02
    int 0x10

new_page:
    mov ax, 3
    int 0x16

    mov ah, 0x00              
    mov al, 0x03
    int 0x10

    mov si, end
    call print_str

jmp $

print_str:
    push ax                   
    mov ah, 0x0e              
    call print_char
    pop ax                    
    ret                       

print_char:
    mov al, [si]              
    cmp al, 0   
    jz if_zero
    int 0x10                  
    inc si 
    jmp print_char       

if_zero:
    ret


name1: db " __    _         __   ___  __       __   __  ", 0
name2: db "|__)  /_\  |    |__) |__  /__`     /  \ /__` ", 0
name3: db "|__) /   \ |___ |__) |___ .__/     \__/ .__/ ", 0
press: db "Press any key...", 0
end: db "This is the end of pt1.", 0

times 510 - ($-$$) db 0
dw 0xaa55