%include "keyboard.mac"

extern drawText
extern putChar
extern calibrate
extern menuMap
extern menuDiff

section .data
    lastKey db 0
    cursor dd 17
; Previous scancode.

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

; int showMenuMap()
; dibuja el menu principal en la pantalla y deja en el eax el numero de la opcion seleccionada
global showMenuMap
showMenuMap:
    push ecx
    push ebx
    push ebp
    mov ebp, esp
    
    call menuMap
        
    cmp byte [key], KEY.ENTER
    je true1
    cmp [key], byte KEY.DOWN.UP
    jne Continue1
    cmp [lastKey], byte KEY.DOWN
    jne continueWhile3
    
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
    jmp continueWhile3
    Continue1:
    cmp [key], byte KEY.UP.UP
    jne continueWhile3
    cmp [lastKey], byte KEY.UP
    jne continueWhile3
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
    continueWhile3:
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

; int showMenuDiff()
; dibuja el menu de dificultad en la pantalla y deja en el eax el numero de la opcion seleccionada
global showMenuDiff
showMenuDiff:
    push ecx
    push ebx
    push ebp
    mov ebp, esp
    
    call menuDiff
        
    cmp byte [key], KEY.SPACE
    je true4
    cmp [key], byte KEY.DOWN.UP
    jne Continue15
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
    jne Continue16
    mov ebx, 17
    Continue16:
    mov [cursor], ebx
    push dword 15
    push dword 0
    push dword 29
    push dword [cursor]
    push dword '*'
    call putChar
    jmp continueWhile1
    Continue15:
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
    jne Continue17
    mov ebx, 21
    Continue17:
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
    jmp false5
    
    true4:
    mov eax, [cursor]
    sub eax, 16
    jmp end2
    false5:
    mov eax, 0
    end2:
    pop ebp
    pop ebx
    pop ecx
ret
