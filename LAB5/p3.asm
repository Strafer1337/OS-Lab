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

main:
    mov si, begin
    call print_str

number_loop:
    call get_input
    
    mov si, sercet
    mov bx, guess
    call compare

    cmp cx, 0
    je number_wrong

    mov si, right
    call print_str

    jmp $

number_wrong:
    mov si, wrong
    call print_str
    jmp number_loop


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

    cmp al, 0x0d
    je check        

    mov ah, 0x0e
    int 0x10

    mov [guess+bx], al
    inc bx

    cmp bx, 8
    je check

    jmp input

check:
    inc bx
    mov byte [guess+bx], 0

    mov bx, 0

    mov si, new_line
    call print_str

    ret

;сравнение
compare:
    mov ah, [bx]
    cmp [si], ah
    jne compare_wrong

    cmp byte [si], 0
    je last_symbol

    inc si
    inc bx

    jmp compare

last_symbol:
    cmp byte [bx], 0
    jne compare_wrong

    mov cx, 1
    ret

compare_wrong:
    mov cx, 0
    ret     

begin: db "Guess the number between 1 and 100. (Only 2 digits!)", 0xa, 0x0d, 0
wrong: db "Incorrect!", 0xa, 0x0d, 0
right: db "You're right! This is the end of pt3. Goodbye!", 0xa, 0x0d, 0
new_line: db 0x0d, 0xa, 0
sercet: db "24", 0
guess: times 8 db 0 

times 510 - ($-$$) db 0
dw 0xaa55