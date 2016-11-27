%include "keyboard.mac"

extern drawText
extern putChar
extern calibrate

section .data
    lastKey db 0
    cursor dd 17
; Previous scancode.
global key
key db 0

section .text

; scan()
; Scan for new keypress. Returns new scancode if changed since last call, zero
; otherwise.
global scan
scan:
  ; Scan.
  in al, 0x60

  ; If scancode has changed, update key and return it.
  cmp al, [key]
  je .zero      
  mov [key], al
  jmp .ret

  ; Otherwise, return zero.
  .zero:
    xor eax, eax

  .ret:
    ret
global menu    
menu:
    push ebp
    mov ebp, esp
    
    push dword 15
    push dword 0
    push dword 27
    push dword 15
    push dword ':'
    push dword 'a'
    push dword 'p'
    push dword 'a'
    push dword 'm'
    push dword ' '
    push dword 'e'
    push dword 'n'
    push dword 'o'
    push dword 'i'
    push dword 'c'
    push dword 'c'
    push dword 'e'
    push dword 'l'
    push dword 'e'
    push dword 'S'
    push dword 16
    call drawText
    mov esp, ebp
    
    push dword 15
    push dword 0
    push dword 30
    push dword 17
    push dword 'a'
    push dword 'd'
    push dword 'i'
    push dword 't'
    push dword 'r'
    push dword 'a'
    push dword 't'
    push dword 'n'
    push dword 'A'
    push dword 9
    call drawText
    mov esp, ebp
    
    push dword 15
    push dword 0
    push dword 30
    push dword 18
    push dword 'o'
    push dword 'n'
    push dword 'i'
    push dword 'l'
    push dword 'a'
    push dword 'r'
    push dword 'o'
    push dword 'C'
    push dword ' '
    push dword 'e'
    push dword 'f'
    push dword 'i'
    push dword 'c'
    push dword 'e'
    push dword 'r'
    push dword 'r'
    push dword 'A'
    push dword 17
    call drawText
    mov esp, ebp
    
    push dword 15
    push dword 0
    push dword 30
    push dword 19
    push dword 's'
    push dword 'a'
    push dword 'n'
    push dword 'o'
    push dword 'z'
    push dword 'a'
    push dword 'm'
    push dword 'A'
    push dword 8
    call drawText
    mov esp, ebp
        
    push dword 15
    push dword 0
    push dword 30
    push dword 20
    push dword 'a'
    push dword 'n'
    push dword 'u'
    push dword 'l'
    push dword ' '
    push dword 'a'
    push dword 'L'
    push dword 7
    call drawText
    mov esp, ebp
        
    push dword 15
    push dword 0
    push dword 30
    push dword 21
    push dword 'o'
    push dword 'i'
    push dword 'r'
    push dword 'o'
    push dword 't'
    push dword 'a'
    push dword 'e'
    push dword 'l'
    push dword 'A'
    push dword 9
    call drawText
    mov esp, ebp  
    
    pop ebp 
ret 

; int menu()
; dibuja el menu principal en la pantalla y deja en el eax el numero de la opcion seleccionada
global showMenu
showMenu:
    push ecx
    push ebx
    push ebp
    mov ebp, esp
    
    call menu
        
    cmp byte [key], KEY.ENTER
    je true1
    cmp [key], byte KEY.DOWN.UP
    jne Continue1
    cmp [lastKey], byte KEY.DOWN
    jne continueWhile1
    
    push dword 15
    push dword 0
    push dword 29
    push dword [cursor]
    push dword ' '
    call putChar
    
    mov ebx, [cursor]
    inc ebx
    cmp ebx, 22
    jne Continue2
    mov ebx, 17
    Continue2:
    mov [cursor], ebx
    push dword 15
    push dword 0
    push dword 29
    push dword [cursor]
    push dword '*'
    call putChar
    jmp continueWhile1
    Continue1:
    cmp [key], byte KEY.UP.UP
    jne continueWhile1
    cmp [lastKey], byte KEY.UP
    jne continueWhile1
    push dword 15
    push dword 0
    push dword 29
    push dword [cursor]
    push dword ' '
    call putChar
    mov ebx, [cursor]
    dec ebx
    cmp ebx, 16
    jne Continue3
    mov ebx, 21
    Continue3:
    mov [cursor], ebx
    push dword 15
    push dword 0
    push dword 29
    push dword [cursor]
    push dword '*'
    call putChar
    continueWhile1:
    mov cl, [key]
    mov [lastKey], cl
    jmp false1
    
    true1:
    mov eax, [cursor]
    sub eax, 16
    jmp end1
    false1:
    mov eax, 0
    end1:
    pop ebp
    pop ebx
    pop ecx
ret


