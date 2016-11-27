%include "video.mac"
%include "keyboard.mac"
section .data
    tablero times 1920 db 0
    page db 1
    direccion dd 0
    timer dq 0

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
extern drawNumber
extern delay
extern updateMap2

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
    push dword tablero
    call Antartida
  ; Snakasm main loop
  game.loop:
    .input:
      call get_input

    ; Main loop

    push dword direccion
    push dword timer
    push dword tablero
    call updateMap2
    
    push dword tablero
    call drawTablero
    
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
    bind KEY.UP, wrapMovUp
    bind KEY.DOWN, wrapMovDown
    bind KEY.LEFT, wrapMovLeft
    bind KEY.RIGHT, wrapMovRight
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
global putRandomApple
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
        xor edx, edx
        mov ebx, [ebp+40]
        div ebx
        mov ebx, edx
        xor ecx, ecx
        rdtsc
        xor edx, edx
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

; (fila(al), columna(ah)) maxUValue(dword tablero)
global maxUValue
maxUValue:
    push ecx
    push ebx
    push esi
    push edx
    pushfd
    push dword 0
    push dword 0
    push ebp
    mov ebp, esp
    
    xor eax, eax
    xor edx, edx
    xor ecx, ecx
    
    mov esi, [ebp+36]
    mov bl, 0
    
    while4:
        mov esi, [ebp+36]
        add esi, ecx
        cmp byte [esi], 0
        je continueWhile4
        cmp byte [esi], 254
        jae continueWhile4
        cmp byte [esi], bl
        jbe continueWhile4
        mov bl,[esi]
        mov dword [ebp+8], edx
        mov dword [ebp+4], eax
        continueWhile4:
            inc ecx
            cmp ecx, 1920
            je endWhile4
            inc edx
            cmp edx, 80
            jne continue12
            xor edx, edx
            inc eax
            cmp eax, 24
            je endWhile4
            continue12:
            jmp while4
    endWhile4:
        mov al, [ebp+4]
        mov ah, [ebp+8]
    pop ebp
    pop ecx
    pop ecx
    popfd
    pop edx
    pop esi
    pop ebx
    pop ecx
        
ret 4
    
; bool movSnake(dword tablero, dword valor, dword fila, dword columna)
global movSnake
movSnake:
    push esi
    push edx
    pushfd
    push ebp
    mov ebp, esp
    
    mov esi, [ebp+20]
    mov eax, [ebp+28]
    mov edx, 80
    mul edx
    mov edx, [ebp+32]
    add eax, edx
    xor edx, edx
    add esi, eax
    
    cmp byte [esi], 254
    jne verCeldaLibre1
    mov dl, [ebp+24]
    inc dl
    mov byte [esi], dl
    ; esto pudiera traer un pequeno error, si el tablero esta muy cargado quedara en un bucle que parara el 
    ; programa, una solucion es no utilizar un ciclo en putRandomApple, sino hacerlo lineal, dentro del bucle del
    ; gameloop, y utilizar una variable global 'boobleana' de forma tal que cuando se coma la manzana esta 
    ; quedara en false, al pasar por el ciclo en el gameloop el putRandomApple pregunta por la varible,
    ; si consigue poner una manzana la pone en true y si no la deja en false, el juego sigue sin manzana, hasta
    ; que se pueda poner una
    push dword 80
    push dword 24
    push dword 254
    push dword [ebp+20]
    call putRandomApple
    
    jmp true3
    verCeldaLibre1:
    cmp byte [esi], 0
    jne false4
    mov dl, [ebp+24]
    inc dl
    mov [esi], dl
    
    push dword [ebp+20]
    call reduction
    true3:
    mov eax, 1
    jmp final9
    false4:
    xor eax, eax
    final9:
    pop ebp
    popfd
    pop edx
    pop esi
    
ret 16
; bool movUp(dword tablero)
global movUp
movUp:
    pushfd
    push ecx
    push ebx
    push edx
    push esi
    push ebp
    mov ebp, esp
    
    push dword [ebp+28]
    call maxUValue
    
    cmp eax, 0
    je final5
    
    xor ebx, ebx
    xor ecx, ecx
    
    mov bl, al
    mov cl, ah
    mov esi, [ebp+28]
    mov eax, 80
    mul ebx
    add eax, ecx
    add esi, eax
    xor eax, eax
    mov al, [esi]
    dec ebx
    
    push ecx
    push ebx
    push eax
    push dword [ebp+28]
    call movSnake
    cmp eax, 0
    je final5
    
    mov eax, 1
    final5:
    pop ebp
    pop esi
    pop edx
    pop ebx
    pop ecx
    popfd
    
ret 4
; bool movDown(dword tablero)
global movDown
movDown:
    pushfd
    push ecx
    push ebx
    push edx
    push esi
    push ebp
    mov ebp, esp
    
    push dword [ebp+28]
    call maxUValue
    
    cmp eax, 0
    je final6
    
    xor ebx, ebx
    xor ecx, ecx
    
    mov bl, al
    mov cl, ah
    mov esi, [ebp+28]
    mov eax, 80
    mul ebx
    add eax, ecx
    add esi, eax
    xor eax, eax
    mov al, [esi]
    
    inc ebx
    
    push ecx
    push ebx
    push eax
    push dword [ebp+28]
    call movSnake
    cmp eax, 0
    je final6
    
    mov eax, 1
    final6:
    pop ebp
    pop esi
    pop edx
    pop ebx
    pop ecx
    popfd
    
ret 4

; bool movLeft(dword tablero)
global movLeft
movLeft:
    pushfd
    push ecx
    push ebx
    push edx
    push esi
    push ebp
    mov ebp, esp
    
    push dword [ebp+28]
    call maxUValue
    
    cmp eax, 0
    je final7
    
    xor ebx, ebx
    xor ecx, ecx
    
    mov bl, al
    mov cl, ah
    mov esi, [ebp+28]
    mov eax, 80
    mul ebx
    add eax, ecx
    add esi, eax
    xor eax, eax
    mov al, [esi]
    
    dec ecx
    
    push ecx
    push ebx
    push eax
    push dword [ebp+28]
    call movSnake
    cmp eax, 0
    je final7
    
    mov eax, 1
    final7:
    pop ebp
    pop esi
    pop edx
    pop ebx
    pop ecx
    popfd
    
ret 4

; bool movRight(dword tablero)
global movRight
movRight:
    pushfd
    push ecx
    push ebx
    push edx
    push esi
    push ebp
    mov ebp, esp
    
    push dword [ebp+28]
    call maxUValue
    
    cmp eax, 0
    je final8
    
    xor ebx, ebx
    xor ecx, ecx
    
    mov bl, al
    mov cl, ah
    mov esi, [ebp+28]
    mov eax, 80
    mul ebx
    add eax, ecx
    add esi, eax
    xor eax, eax
    mov al, [esi]
    
    inc ecx
    
    push ecx
    push ebx
    push eax
    push dword [ebp+28]
    call movSnake
    cmp eax, 0
    je final8
    
    mov eax, 1
    final8:
    pop ebp
    pop esi
    pop edx
    pop ebx
    pop ecx
    popfd
    
ret 4

wrapMovRight:
    push eax
    push ebp
    mov ebp, esp
    
    push dword tablero
    call movRight
    
    mov dword [direccion], KEY.RIGHT
    
    pop ebp
    pop eax
ret

wrapMovLeft:
    push eax
    push ebp
    mov ebp, esp
    
    push dword tablero
    call movLeft
    
    mov dword [direccion], KEY.LEFT
    
    pop ebp
    pop eax
ret

wrapMovDown:
    push eax
    push ebp
    mov ebp, esp
    
    push dword tablero
    call movDown
    
    mov dword [direccion], KEY.DOWN
    
    pop ebp
    pop eax
ret

wrapMovUp:
    push eax
    push ebp
    mov ebp, esp
    
    push dword tablero
    call movUp
    
    mov dword [direccion], KEY.UP
    
    pop ebp
    pop eax
ret 

global gameOver
gameOver:
    push ebp
    mov ebp, esp
    
    pop ebp
ret