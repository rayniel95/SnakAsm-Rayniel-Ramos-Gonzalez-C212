%include "video.mac"
%include "keyboard.mac"

; Frame buffer location
%define FBUFFER 0xB8000

; FBOFFSET(byte row, byte column)
%macro FBOFFSET 2.nolist
    xor eax, eax
    mov al, COLS
    mul byte %1
    add al, %2
    adc ah, 0
    shl ax, 1
%endmacro

extern putHorizontalLine
extern putVerticalLine
extern putValue
extern delay
extern movUp
extern movRight
extern movLeft
extern movDown
extern gameOver
extern putRandomValues

section .text

; clear(byte char, byte attrs)
; Clear the screen by filling it with char and attributes.
global clear
clear:
  mov ax, [esp + 4] ; char, attrs
  mov edi, FBUFFER
  mov ecx, COLS * ROWS
  cld
  rep stosw
  ret


; putc(char chr, byte color, byte r, byte c)
;      4         5           6       7
global putc
putc:
    ; calc famebuffer offset 2 * (r * COLS + c)
    FBOFFSET [esp + 6], [esp + 7]

    mov bx, [esp + 4]
    mov [FBUFFER + eax], bx

; putChar(dword character, dword fila, dword columna, dword foreground, dword background)
; dibuja en la pantalla en la fila, columna seleccionadas el caracter con el foreground y background 
; correspondinetes
global putChar
putChar: 
    push esi; se salvan los registros a utilizar
    push edx
    push ebx
    push eax
    push ecx
    push ebp
    
    mov ebp, esp
    
    mov ah, [ebp+44]
    mov bh, [ebp+40]
    shl bh, 4
    or bh, ah
    mov bl, [ebp+28]
    
    mov eax, 80; se calcula la posicion de la matrix
    mov ecx, [ebp+32]
    mul ecx
    add eax, [ebp+36]
    mov edx, 2
    mul edx
    
    mov esi, 0xb8000; se mueve a memoria
    add esi, eax
    mov [esi], bx
    
    pop ebp
    pop ecx
    pop eax
    pop ebx
    pop edx
    pop esi
ret 20

; drawHorizontalLine(dword caracter, dword fila, dword columna, dword caracteres, dword foreground, 
; dword background)
; dibuja en pantalla una linea vertical hacia arriba a partir de la fila, columna seleccionadas, con 
; con longitud igual a la cantidad de caracteres
global drawHorizontalLine
drawHorizontalLine:
    push ecx
    push eax
    push ebp
    mov ebp, esp
    
    xor ecx, ecx
    mov ecx, [ebp+28]; se pasa a ecx la cantidad de caracteres a pintar
    xor eax, eax
    Ciclo1:
        mov eax, [ebp+24]; se mueve a eax la columna
        add eax, ecx; se le agrega la cantidad de caracteres disminuida en uno
        dec eax; se decrementa en uno
        
        push dword [ebp+36]; se pasan los parametros a putChar
        push dword [ebp+32]
        push eax
        push dword [ebp+20]
        push dword [ebp+16]
        call putChar
        
        dec ecx; aca se puede hacer un loop con ecx pero usare while
        cmp ecx, 0
        je EndCiclo1
    jmp Ciclo1
    EndCiclo1:
    pop ebp; se sacan los valores de la pila
    pop eax 
    pop ecx
ret 24; se retorna y limpia la pila
; drawHorizontalLine(dword caracter, dword fila, dword columna, dword caracteres, dword foreground, 
; dword background)
; dibuja en pantalla una linea vertical hacia arriba a partir de la fila, columna seleccionadas, con 
; con longitud igual a la cantidad de caracteres
global drawVerticalLine
drawVerticalLine:
    push ecx
    push eax
    push ebp
    
    mov ebp, esp
    
    xor eax, eax
    xor ecx, ecx
    
    mov ecx, [ebp+28]
    Ciclo2:
        mov eax, [ebp+20]
        sub eax, ecx
        inc eax
        
        push dword [ebp+36]
        push dword [ebp+32]
        push dword [ebp+24]
        push eax
        push dword [ebp+16]
        call putChar

    loop Ciclo2
 
    pop ebp
    pop eax
    pop ecx
ret 24
; void drawDiagonalAscending(dword caracter, dword fila, dword columna, dword cantidad, dword foreground
; dword background)
; dibuja en la pantalla una diagonal ascendente a partir de la fila, columna pasadas, con la cantidad de 
; caracteres establecida
global drawDiagonalAscending
drawDiagonalAscending:
    push ecx 
    push eax
    push ebx
    push ebp
    
    mov ebp, esp
    
    mov ecx, [ebp+32]
    mov eax, [ebp+24]
    mov ebx, [ebp+28]
    
    Ciclo3:
        push dword [ebp+40]
        push dword [ebp+36]
        push ebx
        push eax
        push dword [ebp+20]
        
        call putChar
        
        dec eax
        inc ebx
    loop Ciclo3
    
    pop ebp
    pop ebx
    pop eax
    pop ecx
ret 24
; void drawDiagonalDescending(dword caracter, dword fila, dword columna, dword cantidad, dword foreground
; dword background)
; dibuja en la pantalla una diagonal descendente a partir de la fila, columna pasadas, con la cantidad de 
; caracteres establecida
global drawDiagonalDescending
drawDiagonalDescending:
    push ecx 
    push eax
    push ebx
    push ebp
    
    mov ebp, esp
    
    mov ecx, [ebp+32]
    mov eax, [ebp+24]
    mov ebx, [ebp+28]
    
    Ciclo4:
        push dword [ebp+40]
        push dword [ebp+36]
        push ebx
        push eax
        push dword [ebp+20]
        
        call putChar
        
        inc eax
        inc ebx
    loop Ciclo4
    
    pop ebp
    pop ebx
    pop eax
    pop ecx
ret 24
; void showWelcome()
; dibuja en ascii art la pantalla de bienvenida
global showWelcome
showWelcome:
    push ebp
    mov ebp, esp
; \\ 
    push dword 15
    push dword 0
    push dword 7
    push dword 6
    push dword 6
    push dword '_'
    call drawHorizontalLine
    
    push dword 15
    push dword 0
    push dword 6
    push dword 7
    push dword 7
    push dword '_'
    call drawHorizontalLine
    
    push dword 15
    push dword 0
    push dword 13
    push dword 7
    push dword '|'
    call putChar
    
    push dword 15
    push dword 0
    push dword 5
    push dword 7
    push dword '/'
    call putChar

    push dword 15
    push dword 0
    push dword 3
    push dword 5
    push dword 8
    push dword '\'
    call drawDiagonalDescending
    
    push dword 15
    push dword 0
    push dword 7
    push dword 8
    push dword '\'
    call putChar
    
    push dword 15
    push dword 0
    push dword 8
    push dword 9
    push dword '\'
    call putChar
    
    push dword 15
    push dword 0
    push dword 4
    push dword 9
    push dword 9
    push dword '_'
    call drawHorizontalLine
    
    push dword 15
    push dword 0
    push dword 4
    push dword 8
    push dword 10
    push dword '_'
    call drawHorizontalLine
    
    push dword 15
    push dword 0
    push dword 2
    push dword 10
    push dword 12
    push dword '/'
    call drawDiagonalAscending
    
    push dword 15
    push dword 0
    push dword 3
    push dword 11
    push dword 13
    push dword '/'
    call drawDiagonalAscending
    
    push dword 15
    push dword 0
    push dword 13
    push dword 10
    push dword '\'
    call putChar
    
    push dword 15
    push dword 0
    push dword 4
    push dword 6
    push dword 12
    push dword '_'
    call drawHorizontalLine
    
    push dword 15
    push dword 0
    push dword 5
    push dword 6
    push dword 13
    push dword '_'
    call drawHorizontalLine
    
    push dword 15
    push dword 0
    push dword 5
    push dword 13
    push dword '|'
    call putChar
; S//
; \\ 
    push dword 15
    push dword 0
    push dword 7
    push dword 16
    push dword 13
    push dword 'N'
    call drawVerticalLine

    push dword 15
    push dword 0
    push dword 9
    push dword 16
    push dword 5
    push dword 'N'
    call drawDiagonalDescending
    
    push dword 15
    push dword 0
    push dword 8
    push dword 16
    push dword 6
    push dword 'N'
    call drawDiagonalDescending
    
    push dword 15
    push dword 0
    push dword 8
    push dword 24
    push dword 12
    push dword 'N'
    call drawVerticalLine
; N//
; \\ 
    push dword 15
    push dword 0
    push dword 7
    push dword 27
    push dword 12
    push dword '|'
    call drawVerticalLine
    
    push dword 15
    push dword 0
    push dword 7
    push dword 29
    push dword 12
    push dword '|'
    call drawVerticalLine
    
    push dword 15
    push dword 0
    push dword 3
    push dword 27
    push dword 13
    push dword '_'
    call drawHorizontalLine
    
    push dword 15
    push dword 0
    push dword 7
    push dword 28
    push dword 12
    push dword '*'
    call drawVerticalLine
    
    push dword 15
    push dword 0
    push dword 6
    push dword 30
    push dword 5
    push dword '_'
    call drawHorizontalLine
    
    push dword 15
    push dword 0
    push dword 28
    push dword 5
    push dword '_'
    call putChar
    
    push dword 15
    push dword 0
    push dword 6
    push dword 30
    push dword 6
    push dword '*'
    call drawHorizontalLine
    
    push dword 15
    push dword 0
    push dword 6
    push dword 30
    push dword 8
    push dword '_'
    call drawHorizontalLine
    
    push dword 15
    push dword 0
    push dword 6
    push dword 30
    push dword 9
    push dword '*'
    call drawHorizontalLine
    
    push dword 15
    push dword 0
    push dword 3
    push dword 36
    push dword 13
    push dword '_'
    call drawHorizontalLine
    
    push dword 15
    push dword 0
    push dword 7
    push dword 36
    push dword 12
    push dword '|'
    call drawVerticalLine
    
    push dword 15
    push dword 0
    push dword 7
    push dword 37
    push dword 12
    push dword '*'
    call drawVerticalLine
    
    push dword 15
    push dword 0
    push dword 7
    push dword 38
    push dword 12
    push dword '|'
    call drawVerticalLine
    
    push dword 15
    push dword 0
    push dword 37
    push dword 5
    push dword '_'
    call putChar
; A//
; \\ 
    push dword 15
    push dword 0
    push dword 9
    push dword 41
    push dword 13
    push dword 'q'
    call drawVerticalLine
    
    push dword 15
    push dword 0
    push dword 9
    push dword 42
    push dword 13
    push dword 'q'
    call drawVerticalLine
    
    push dword 15
    push dword 0
    push dword 5
    push dword 43
    push dword 9
    push dword 'q'
    call drawDiagonalAscending
    
    push dword 15
    push dword 0
    push dword 4
    push dword 44
    push dword 9
    push dword 'q'
    call drawDiagonalAscending
    
    push dword 15
    push dword 0
    push dword 4
    push dword 44
    push dword 10
    push dword 'q'
    call drawDiagonalDescending
    
    push dword 15
    push dword 0
    push dword 4
    push dword 45
    push dword 10
    push dword 'q'
    call drawDiagonalDescending
; K//
; \\ 
    push dword 15
    push dword 0
    push dword 4
    push dword 50
    push dword 9
    push dword '('
    call drawDiagonalAscending

    push dword 15
    push dword 0
    push dword 3
    push dword 51
    push dword 9
    push dword ')'
    call drawDiagonalAscending
    
    push dword 15
    push dword 0
    push dword 4
    push dword 51
    push dword 10
    push dword '('
    call drawDiagonalDescending
    
    push dword 15
    push dword 0
    push dword 3
    push dword 52
    push dword 10
    push dword ')'
    call drawDiagonalDescending
    
    push dword 15
    push dword 0
    push dword 7
    push dword 55
    push dword 12
    push dword '_'
    call drawHorizontalLine
    
    push dword 15
    push dword 0
    push dword 6
    push dword 56
    push dword 13
    push dword '_'
    call drawHorizontalLine
    
    push dword 15
    push dword 0
    push dword 55
    push dword 13
    push dword '('
    call putChar 
    
    push dword 15
    push dword 0
    push dword 62
    push dword 13
    push dword '|'
    call putChar
    
    push dword 15
    push dword 0
    push dword 10
    push dword 52
    push dword 9
    push dword '_'
    call drawHorizontalLine
    
    push dword 15
    push dword 0
    push dword 62
    push dword 9
    push dword ')'
    call putChar
    
    push dword 15
    push dword 0
    push dword 63
    push dword 9
    push dword ')'
    call putChar
    
    push dword 15
    push dword 0
    push dword 10
    push dword 53
    push dword 8
    push dword '_'
    call drawHorizontalLine
    
    push dword 15
    push dword 0
    push dword 10
    push dword 54
    push dword 6
    push dword '_'
    call drawHorizontalLine
    
    push dword 15
    push dword 0
    push dword 10
    push dword 54
    push dword 5
    push dword '_'
    call drawHorizontalLine
    
    push dword 15
    push dword 0
    push dword 64
    push dword 6
    push dword '|'
    call putChar
    
    pop ebp
ret
; void drawText(dword longitudCadena, dword caracter1, dword caracter2, ..., dword caracterlen(cadena),
; dword fila, dword columna, dword foreground, dword background)
; dibuja el texto en la pantalla a partir de la fila, columna correspondiente, el texto debe tener una longitud
; n que se correspondra con la cantidad de caracteres del mismo los cuales se pasan como argumentos individuales, 
; el usuario debe liberar los parametros de la pila que se pasaron porque el rpocedimiento no calcula para 
; liberarla
global drawText
drawText:
    push ebx
    push edx
    push ecx
    push eax
    push ebp
    
    xor eax, eax
    mov ebp, esp
    
    mov ecx, [ebp+24]
    mov eax, ecx
    mov edx, 4
    mul edx
    mov edx, 0
    mov ebx, dword [ebp+32+eax]
    
    Ciclo5:
        push dword [ebp+40+eax]
        push dword [ebp+36+eax]
        push ebx; columna
        push dword [ebp+28+eax]
        push dword [ebp+28+edx]
        call putChar
        inc ebx
        add edx, 4
    loop Ciclo5
    
    pop ebp
    pop ecx
    pop eax
    pop edx
    pop ebx
ret 
; void drawTablero(dword tablero)
; dibuja en pantalla a partir de la fila 1 (incluyendola) la matriz apuntada por tablero(de 24x80), 
; teniendo en cuenta lo siguiente, se asume que la matriz es de bytes, si el valor en la fila, columna 
; es 0 no se pinta, si es 255 se pinta un *, si es 254 se pinta un + y si es cualquier otro numero 
; del intervalo se pinta $
global drawTablero
drawTablero:
    push edx
    push ecx
    pushfd
    push eax
    push esi
    
    push ebp
    mov ebp, esp
    
    mov ebx, 0
    mov ecx, 0
    
    while2:
        mov esi, [ebp+28]
        
        mov eax, ebx
        mov edx, 80
        mul edx
        add eax, ecx
        add esi, eax
        cmp byte [esi], 255
        jne Continue5
        push dword 15
        push dword 0
        push ecx
        
        mov edx, ebx
        inc edx
        
        push edx
        push dword '*'
        call putChar
        jmp continueWhile2
        Continue5:
        cmp byte [esi], 254
        jne Continue6
        push dword 15
        push dword 0
        push ecx
        
        mov edx, ebx
        inc edx
        
        push edx
        push dword '+'
        call putChar
        jmp continueWhile2
        Continue6:
        cmp byte [esi], 0
        jne continue7
        push dword 15
        push dword 0
        push ecx        
        
        mov edx, ebx
        inc edx
        
        push edx 
        push dword ' '
        call putChar
        jmp continueWhile2
        continue7:
        push dword 15
        push dword 0
        push ecx        
        
        mov edx, ebx
        inc edx
        
        push edx 
        push dword '$'
        call putChar
        continueWhile2:
        inc ecx
        cmp ecx, 80
        jne Continue8
        inc ebx
        cmp ebx, 24
        je endWhile2
        mov ecx, 0
        Continue8:
    jmp while2
    endWhile2:
    
    pop ebp
    pop esi
    pop eax
    popfd
    pop ecx
    pop edx
ret 4

; void drawNumber(dword numero, dword fila, dword columna)
global drawNumber
drawNumber:
    pushfd
    push eax
    push edx
    push ebx
    push ecx
    push dword 0
    push ebp 
    mov ebp, esp
    
    mov ebx, [ebp+40]
    mov eax, [ebp+32]
    mov [ebp+4], eax
    mov ecx, 10
    cmp dword [ebp+32], 0
    jne while5
    push dword 15
    push dword 0
    push ebx
    push dword [ebp+36]
    push dword 48
    call putChar
    jmp endWhile5
    while5:
        xor edx, edx
        div ecx
        mov eax, dword [ebp+4]
        sub eax, edx
        add edx, 48
        push dword 15
        push dword 0
        push dword ebx
        push dword [ebp+36]
        push edx
        call putChar
        
        cmp eax, 0
        je endWhile5
        xor edx, edx
        div ecx
        mov dword [ebp+4], eax
        dec ebx
    jmp while5
    endWhile5:
    
    pop ebp
    pop ecx
    pop ecx
    pop ebx
    pop edx
    pop eax
    popfd

ret 12
; void updateMap(dword tablero, dword (pointer) timer, dword (pointer) key, dword (pointer) direccion)
global updateMap
updateMap:; revisar, borrar
    pushfd
    push eax
    push ebx
    push esi
    push ebp
    mov ebp, esp
    
    push dword 1000
    push dword [ebp+28]
    call delay
    
    cmp eax, 0
    je final11
    
    mov esi, [ebp+32]
    cmp byte [esi], KEY.UP.UP
    jne verDireccionUp
    mov bl, [esi]
    mov eax, [ebp+36]
    mov [eax], bl
    
    verDireccionUp:
    mov esi, [ebp+36]
    cmp byte [esi], KEY.UP.UP
    jne continue9
    push dword [ebp+24]
    call movUp
    cmp eax, 0
    jne final11
    call gameOver
    jmp final11
    
    continue9:
    mov esi, [ebp+32]
    cmp byte [esi], KEY.DOWN.UP
    jne verDireccionDown
    mov bl, [esi]
    mov eax, [ebp+36]
    mov [eax], bl
    verDireccionDown:
    mov esi, [ebp+36]
    cmp byte [esi], KEY.DOWN.UP
    jne continue10
    
    push dword [ebp+24]
    call movDown
    
    cmp eax, 0
    jne final11
    call gameOver
    jmp final11
    
    continue10:
    mov esi, [ebp+32]
    cmp byte [esi], KEY.LEFT.UP
    jne verDireccionLeft
    mov bl, [esi]
    mov eax, [ebp+36]
    mov [eax], bl
    verDireccionLeft:
    mov esi, [ebp+36]
    cmp byte [esi], KEY.LEFT.UP
    jne continue11
    
    push dword [ebp+24]
    call movLeft
    
    cmp eax, 0
    jne final11
    call gameOver
    jmp final11
    
    continue11:
    mov esi, [ebp+32]
    cmp byte [esi], KEY.RIGHT.UP
    jne verDireccionRight
    mov bl, [esi]
    mov eax, [ebp+36]
    mov [eax], bl
    verDireccionRight:
    mov esi, [ebp+36]
    cmp byte [esi], KEY.RIGHT.UP
    jne final11
    
    push dword [ebp+24]
    call movRight
    
    cmp eax, 0
    jne final11
    
    call gameOver
    
    final11:
    
    pop ebp
    pop esi
    pop ebx
    pop eax
    popfd
    
ret 16 
; void updateMap2(dword tablero, dword timer, dword direccion, dword ms)
global updateMap2
updateMap2:
    pushfd
    push eax
    push ebx
    push esi
    push ebp
    mov ebp, esp
    
    push dword [ebp+36]
    push dword [ebp+28]
    call delay
    
    cmp eax, 0
    je final10
    
    mov esi, [ebp+32]
    
    cmp byte [esi], KEY.UP
    jne continue12
    
    push dword [ebp+24]
    call movUp
    
    cmp eax, 0
    jne final10
    
    call gameOver
    jmp final10
    
    continue12:
    
    cmp byte [esi], KEY.DOWN
    jne continue13
    
    push dword [ebp+24]
    call movDown
    
    cmp eax, 0
    jne final10
    
    call gameOver
    jmp final10
    
    continue13:
    
    cmp byte [esi], KEY.LEFT
    jne continue14
    
    push dword [ebp+24]
    call movLeft
    
    cmp eax, 0
    jne final10
    
    call gameOver
    jmp final10
    
    continue14:
    
    cmp byte [esi], KEY.RIGHT
    jne final10
    
    push dword [ebp+24]
    call movRight
    
    cmp eax, 0
    jne final10
    
    call gameOver
    
    final10:
    pop ebp
    pop esi
    pop ebx
    pop eax
    popfd

ret 16