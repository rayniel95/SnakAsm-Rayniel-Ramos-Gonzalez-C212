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
extern Antartida
extern showWelcome

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
    .input:
      call get_input

    ; Main loop

       
    
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
global putValue
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
global putHorizontalLine
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
global putVerticalLine
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
    jae false2; aca pudiera dar algun error al trabajar con el complemento a dos, verificar
    mov ebx, [ebp+20]
    cmp ebx, 0
    jl false2
    cmp ebx, [ebp+28]
    jae false2
    
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
; void putRandomValue(dword tablero, dword valor, dword maxFila, dword maxColumna)
global putRandomApple; hay un error en esta funcion que hace que la pantalla se 
; borre despues de un tiempo aborta la ejecucion sin decir nada, el error es un arithmetic exception, lo
; probe con el sasm y es el problema pero no entiendo porque 
putRandomApple:
    push eax
    push edx
    pushfd
    push esi
    push ebx
    push ecx
    push ebp
    mov ebp, esp
    
    while3:
        xor ebx, ebx
        rdtsc
        mov ebx, [ebp+40]
        div ebx
        mov ebx, edx
        xor ecx, ecx
        rdtsc
        mov ecx, [ebp+44]
        div ecx
        mov ecx, edx
        
        push dword [ebp+44]
        push dword [ebp+40]
        push ecx
        push ebx
        push dword [ebp+32]
        call isValidPosition
        cmp eax, 0
    je while3
    
    push ecx
    push ebx
    push dword [ebp+36]
    push dword [ebp+32]
    call putValue
    
    pop ebp
    pop ecx
    pop ebx
    pop esi
    popfd
    pop edx
    pop eax
ret 16
; void reduction(dword tablero)
global reduction
reduction:
    push eax
    pushfd
    push esi
    push ecx
    push ebp
    
    mov ebp, esp
    
    mov ecx, 1920
    
    Ciclo8:
        mov eax, ecx
        dec eax
        mov esi, [ebp+24]
        add esi, eax
        cmp byte [esi], 0
        je continueCiclo8
        cmp byte [esi], 254
        je continueCiclo8
        cmp byte [esi], 255
        je continueCiclo8
        mov al, byte [esi]
        dec al
        mov byte [esi], al
        continueCiclo8:
    loop Ciclo8

    pop ebp
    pop ecx
    pop esi
    popfd
    pop eax
    
ret 4

; (fila(al), columna(ah)) maxUValue(dword tablero, dword maxFila, dword maxColumna)
global maxUValue
maxUValue:
    push ecx
    push ebx
    push esi
    push edx
    pushfd
    push dword 0
    push dword 0
    push dword 0
    push ebp
    mov ebp, esp
    
    mov eax, [ebp+48]
    mov edx, [ebp+44]
    mul edx
    mov dword [ebp+4], eax
    xor eax, eax
    xor edx, edx
    xor ecx, ecx
    
    mov esi, [ebp+40]
    mov bl, 0
    
    while4:
        mov esi, [ebp+40]
        add esi, ecx
        cmp byte [esi], 0
        je continueWhile4
        cmp byte [esi], 254
        jae continueWhile4
        cmp byte [esi], bl
        jbe continueWhile4
        mov bl,[esi]
        mov dword [ebp+12], edx
        mov dword [ebp+8], eax
        continueWhile4:
            inc ecx
            cmp ecx, [ebp+4]
            je endWhile4
            inc edx
            cmp edx, [ebp+48]
            jne continue12
            xor edx, edx
            inc eax
            cmp eax, [ebp+44]
            je endWhile4
            continue12:
            jmp while4
    endWhile4:
        mov al, [ebp+8]
        mov ah, [ebp+12]
    pop ebp
    pop ecx
    pop ecx
    pop ecx
    popfd
    pop edx
    pop esi
    pop ebx
    pop ecx
        
ret 12
    

    
    
    
    
    
    
    
        