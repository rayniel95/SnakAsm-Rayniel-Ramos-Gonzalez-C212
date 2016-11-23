%include "video.mac"
%include "keyboard.mac"
section .data
    tablero times 1920 db 0
    page db 1

section .text

extern clear, putc
extern scan
extern calibrate
extern showMenu
extern drawTablero
extern drawText
extern putChar

; Bind a key to a procedure
%macro bind 2
  cmp byte [esp], %1
  jne %%next
  call %2
  %%next:
%endmacro

; Fill the screen with the given background color
%macro FILL_SCREEN 1
  push word %1
  call clear
  add esp, 2
%endmacro

global game
game:
  ; Initialize game

  FILL_SCREEN BG.BLACK

  ; Calibrate the timing
  call calibrate

  ; Snakasm main loop
  game.loop:
    .input:; ten presente guardar las flags en las subrutinas
      call get_input

    ; Main loop.
     
    push dword 3
    push dword 2
    push dword 255
    push dword tablero
    call putValue
     
    push dword tablero
    call drawTablero
     
    push dword 80
    push dword 24
    push dword 0
    push dword 0
    push dword tablero
    call isValidPosition
    
    cmp eax, 0
    jne cosa
    push dword 15
    push dword 0
    push dword 3
    push dword 4
    push dword 'd'
    call putChar
    cosa:
   
    ; Here is where you will place your game logic.
    ; Develop procedures like paint_map and update_content,
    ; declare it extern and use here.

    jmp game.loop


draw.red:
  FILL_SCREEN BG.RED
  ret


draw.green:
  FILL_SCREEN BG.GREEN

  push word (80 / 2) << 8 | (25 / 2)
  push word 'a' | BG.GREEN | FG.BLUE
  call putc
  add esp, 4

  ret

get_input:
    call scan
    push ax
    ; The value of the input is on 'word [esp]'

    ; Your bindings here
;    cmp dword [page], 1
;    jne page2
;    mov eax, 0
;    bind KEY.DOWN, showMenu
;    bind KEY.DOWN.UP, showMenu
;    bind KEY.UP.UP, showMenu
;    bind KEY.UP, showMenu
;    bind KEY.ENTER, showMenu
;    cmp eax, 0
;    je continuePage1
    ; aca se actualiza la pagina y se hacen otros llamados en dependencia del valor de retorno del menu
    continuePage1:
    page2:
    add esp, 2 ; free the stack
    ret

; void putValue(dword tablero, dword value, dword fila, dword columna)
; pone el valor correspondiente en la fila, columna de la matriz apuntada por tablero
putValue:
    push eax
    push esi
    push edx
    push ebp
    
    mov ebp, esp
    
    mov esi,[ebp+20]
    mov eax, [ebp+28]
    mov edx, 80
    mul edx
    add eax, [ebp+32]
    add esi, eax
    mov al, [ebp+24]
    mov [esi], al
    
    pop ebp
    pop edx
    pop esi
    pop eax
ret 16 
; void putHorizontalLine(dword tablero, dword valor, dword cantidad, dword fila, dword columna)
; realiza una fila horizontal en la matriz apuntada por tablero, poniendo el valor el la fila, columna 
; correspondiente y la cantidad de veces indicadas hacia la derecha
putHorizontalLine:
    push ebx
    push ecx
    push ebp
    
    mov ebp, esp
    
    mov ecx, [ebp+24]
    
    Ciclo6:
        mov ebx, [ebp+32]
        add ebx, ecx
        dec ebx
        
        push ebx
        push dword [ebp+28]
        push dword [ebp+20]
        push dword [ebp+16]
        call putValue
    loop Ciclo6
    
    pop ebp
    pop ecx
    pop ebx
ret 20
; void putVerticalLine(dword tablero, dword valor, dword cantidad, dword fila, dword columna)
; realiza una fila vartical en la matriz apuntada por tablero, poniendo el valor el la fila, columna 
; correspondiente y la cantidad de veces indicadas hacia arriba
putVerticalLine:
    push ebx
    push ecx
    push ebp
    
    mov ebp, esp
    
    mov ecx, [ebp+24]

    
    Ciclo7:
        mov ebx, [ebp+28]
        sub ebx, ecx
        inc ebx
        push dword [ebp+32]
        push ebx
        push dword [ebp+20]
        push dword [ebp+16]
        call putValue
    loop Ciclo7
    
    pop ebp
    pop ecx
    pop ebx
ret 20
; bool inRange(dword fila, dword columna, dword maxFila, dword maxColumna)
; devuelve en eax 1, si fila y columna estan en el rango de la matriz con len filas = maxFila y 
; y len columnas = maxColumna, 0 en caso contrario
global inRange
inRange:
    push ebx
    pushfd
    push ebp
    mov ebp, esp
    
    mov ebx, [ebp+16]
    cmp ebx, 0
    jl false2
    cmp ebx, [ebp+24]
    jge false2
    mov ebx, [ebp+20]
    cmp ebx, 0
    jl false2
    cmp ebx, [ebp+28]
    jge false2
    
    true2:
        mov eax, 1
        jmp final3
    false2:
        xor eax, eax
    final3:
    pop ebp
    popfd
    pop ebx
    
ret 16
; bool isValidPosition(dword tablero, dword fila, dword columna, dword maxFila, dword maxColumna)
; verifica si en una matriz apuntada por tablero, en la posicion fila, columna existe o no un elemento
; distinto de 0, devuelve 0 si hay un elemento distinto de 0, 1 en caso de que sea 0 el valor
global isValidPosition
isValidPosition:
    push esi
    push edx
    pushfd
    push ebp
    mov ebp, esp
    
    push dword [ebp+36]
    push dword [ebp+32]
    push dword [ebp+28]
    push dword [ebp+24]
    call inRange
    
    cmp eax, 0
    je false3
    mov esi, [ebp+20]
    mov eax, [ebp+36]
    mov edx, [ebp+24]
    mul edx
    mov edx, [ebp+28]
    add eax, edx
    add esi, eax
    cmp byte [esi], 0
    jne false3
    
    mov eax, 1
    jmp final4
    false3:
        xor eax, eax
    final4:
        pop ebp
        popfd
        pop edx
        pop esi
ret 20
    
    
    
    
    
    
    
    
    
    
    
    
    
        