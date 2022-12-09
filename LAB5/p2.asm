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

    mov si, 0
    mov cx, 2000
    mov al, ' '
    mov ah, 01100000b

    mov dx, 0x0B800
    mov es, dx

cycle:
    test cx, cx
    jz ask_name
    mov [es:si], al
    inc si
    mov [es:si], ah
    inc si
    dec cx
    jmp cycle

ask_name:
    mov bx, 0
    mov dl, 0
    mov dh, 0
    mov ah, 0x02
    int 0x10

    mov si, what_name
    call print_str

    call get_input

    mov si, hello
    call print_str

    mov si, name
    call print_str

    mov si, end
    call print_str
jmp $

;ВЫВОД
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


;ВВОД
get_input:
    mov bx, 0
input:
    mov ah, 0x0
    int 0x16

    cmp al, 0x0d              ;enter
    je check        

    cmp al, 0x8               ;backspace
    je backspace

    cmp al, 0x3               ;ctrl+c
    je stop

    mov ah, 0x0e
    int 0x10

    mov [name+bx], al
    inc bx

    cmp bx, 64
    je check

    jmp input

stop:
    mov si, end2
    call print_str

    jmp $ 

backspace:
    cmp bx, 0
    je input

    mov ah, 0x0e
    int 0x10

    mov al, ' '
    int 0x10

    mov al, 0x8
    int 0x10

    dec bx
    mov byte [name+bx], 0

    jmp input

check:
    inc bx
    mov byte [name+bx], 0

    mov bx, 0

    mov si, new_line
    call print_str

    ret

what_name: db "- Whats ur name?", 0xa, 0x0d, 0
hello: db "- Hello, ", 0
name: times 64 db 0  
end: db 0xa, 0x0d, "This is the end of pt2.", 0
end2: db 0xa, 0x0d, "This is the optional end :)", 0
new_line: db 0x0d, 0xa, 0
times 510 - ($-$$) db 0
dw 0xaa55