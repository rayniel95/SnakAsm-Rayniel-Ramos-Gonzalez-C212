%include "keyboard.mac" 
%include "logica.mac"
%include "video.mac"

section .text

extern gameOver
extern drawHorizontalLine
extern fruta 
extern puntuacion
extern drawNumber
extern delay
extern arrayMin
extern drawText

; void putValue(dword(pointer) tablero, dword value, dword fila, dword columna)
; pone el valor correspondiente en la fila, columna de la matriz apuntada por tablero, hay que tener presente que
; aunque el valor se pase como dword para mayor seguridad y comodidad en el trabajo con la pila, lo que se usa
; es un byte, puesto que mis tableros son de bytes
global putValue
putValue:
    push eax
    push esi
    push edx
    push ebp
    
    mov ebp, esp
    
    mov esi,[ebp+20]
    mov eax, [ebp+28]; calculo la posicion fila, columna en la matriz vista como array
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
; void putHorizontalLine(dword(pointer) tablero, dword valor, dword cantidad, dword fila, dword columna)
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
; void putVerticalLine(dword(pointer) tablero, dword valor, dword cantidad, dword fila, dword columna)
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
; y len columnas = maxColumna, 0 en caso contrario, o se si 0<=fila<maxFila && 0<=columna<maxColumna, si se esta
; dentro de la matriz
global inRange
inRange:
    push ebx
    pushfd
    push ebp
    mov ebp, esp
    
    mov ebx, [ebp+16]; lo unico que hago es una comparacion
    cmp ebx, 0
    jl false2
    cmp ebx, [ebp+24]
    jae false2
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
; bool isValidPosition(dword(pointer) tablero, dword fila, dword columna, dword maxFila, dword maxColumna)
; verifica si en una matriz apuntada por tablero, en la posicion fila, columna existe o no un elemento
; distinto de 0, devuelve 0 si hay un elemento distinto de 0, 1 en caso de que sea 0 el valor, util para 
; ver si la celda es libre o no, no tiene en cuenta las manzanas que yo asumo como 254, por eso se verifica antes 
; en las demas funciones
global isValidPosition
isValidPosition:
    push esi
    push edx
    pushfd
    push ebp
    mov ebp, esp
    
    push dword [ebp+36]; se le pregunta si estamos en la matriz
    push dword [ebp+32]
    push dword [ebp+28]
    push dword [ebp+24]
    call inRange
    
    cmp eax, 0
    je false3
    mov esi, [ebp+20]; luego simplemente se pregunta por el valor en esa fila columna comparandolo con 0
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
; void putRandomApple(dword(pointer) tablero, dword valor, dword maxFila, dword maxColumna)
; pone en la matriz apuntada por tablero el valor que se pase de manera random, maxFila  y maxColumna son las
; dimensiones de la matriz, el problemilla con esta funcion es que en el caso de tener un tablero muy cargado
; se tendria que parar el juego puesto que se pide random cada vez que la posicion es no valida, por eso
; desarrolle otra funcion similar pero que no usa un ciclo, sino una variable 'booleana' para comunicarse con
; otras funciones, para saber si tiene que poner el valor o no, en ambas verisones utilizo el rdtsc para generar
; lo mas random posible, limpio el edx despues de utilizarlo puesto que el numero por el que voy a dividir para
; conseguir el resto es bastante pequeno y el cocinete no me cabe en 32 bits, por ello solo uso la parte baja,
; el eax, de esta forma sigo garantizando que sea aleatorio y que me permita dividir, si se divide entre edx:eax
; por un numero como 80, da error de coma flotante o algo parecido, es un sigfpe
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
        rdtsc; se pide rdtsc le limpia el edx y se divide se guarda el resto como la nueva posicion fila, columna
        xor edx, edx; a poner el valor y se verifica que sea una posicion valida, en caso de no serlo se repite
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
    
    push ecx; si es un posicion valida se pone el valor y se retorna
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
; void reduction(dword (pointer)tablero)
; esta funcion simplemente reduce en uno todos los valores en la matriz (que asumo que es de 24 fila y 80 
; columnas, cosa que hago para dejar la fila de arriba reservada para el score y cualquier otra cosa necesaria)
; con 0<valor<254, util para mover la serpiente una vez que se halla puesto en la nueva posicion a moverse la 
; cabeza
global reduction
reduction:
    push eax
    pushfd
    push esi
    push ecx
    push ebp
    
    mov ebp, esp
    
    mov ecx, 1920
    
    Ciclo8:; hago un ciclo por toda la matriz, viendola como un array, pregunto y disminuyo
        mov eax, ecx
        dec eax
        mov esi, [ebp+24]
        add esi, eax
        cmp byte [esi], FREE
        je continueCiclo8
        cmp byte [esi], APPLE
        je continueCiclo8
        cmp byte [esi], WALL
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

; (fila(al), columna(ah)) maxUValue(dword(pointer)tablero)
; esta funcion basicamente devuelve la cabeza de la serpiente, o sea su posicion, como la idea para mover la 
; serpiente es tener, 0 para las celdas libres, 255 para las paredes, y 254 para las frutas, luego la serpiente
; estara hecha de valores entre 0 y 254, la cabeza sera el mayor valor y asi susecivamente en dependecia del 
; largo hasta llegar a la punta de la cola que sera un uno, luego para mover la serpiente lo unico que se tiene
; que hacer es buscar la posicion de ese mayor valor aumentarla en uno y moverla para la nueva casilla, luego
; si esa casilla era una fruta no se hace mas nada, si esa casilla era una libre entonces se disminuye en uno
; todos los valores en (0, 254)
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
        mov esi, [ebp+36]; se hace un ciclo, comparando con el resultado que esta en el bl, inicialmente en 0
        add esi, ecx; de esta forma garantizo que el mayor valor este en el bl y la fila, columna que le 
        cmp byte [esi], 0; corresponde las dejo en unas variables temporales en la pila, para despues pasarlas 
        je continueWhile4; a al, ah, me desplazo por el array que conforma mi matriz, aumnetando en fila, columna
        cmp byte [esi], 254; en dependencia
        jae continueWhile4
        cmp byte [esi], bl
        jbe continueWhile4
        mov bl,[esi]
        mov dword [ebp+8], edx
        mov dword [ebp+4], eax
        continueWhile4:; hago un while con ecx desde 0 y conforme aumneta el ecx aumneta el edx que seria mi
            inc ecx; cotador para las columnas, si el edx es 80 entonces incremento eax, que es mi contador para
            cmp ecx, 1920; las filas y paso 0 al edx, si ecx llega al tope o eax llega a 24 rompo, cada vez 
            je endWhile4; que encuentro un valor en el rango mayor que lo que tengo en el bl meto su posicion
            inc edx; en las variables temporales que despues paso para al, ah
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
    
; bool movSnake(dword (pointer)tablero, dword valor, dword fila, dword columna)
; basicamente mueve la cabeza del snake, y compara si es manzana no reduce, si es celda libre reduce, si se
; comio una manzana se pone en false la varible global que informa a putRandomApple2 que tiene que poner una 
; manzana y se incrementa la puntuacion, en caso de que no sea ni manzana ni libre se retorna 0
global movSnake
movSnake:
    push esi
    push edx
    pushfd
    push ebp
    mov ebp, esp
    
    mov esi, [ebp+20]; dado el valor (cabeza) y la fila, columna donde quedara la nueva cabeza, se incrementa
    mov eax, [ebp+28]; la cabeza de la serpiente en uno y se pone en la fila, columna y como ya explique
    mov edx, 80; se reduce o no todo el tablero
    mul edx
    mov edx, [ebp+32]
    add eax, edx
    xor edx, edx
    add esi, eax
    
    cmp byte [esi], APPLE; se verifica que sea fruta, si lo es no se reduce, else se reduce
    jne verCeldaLibre1
    mov dl, [ebp+24]
    inc dl
    mov byte [esi], dl
    
    mov dword [fruta], 0; se comio una fruta, entonces se actualiza la variable fruta con false
    
    push dword puntuacion; se incrementa la puntuacion
    call increasingPuntuation
    
    jmp true3
    verCeldaLibre1:
    cmp byte [esi], FREE; si la celda fuera libre entonces se reduce todo el tablero
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
; bool movUp(dword (pointer)tablero)
; mueve hacia arriba la serpiente, estrictamente hablando lo que hace es dado el puntero a tablero, busca la
; fila, columna de la cabeza, busca la cabeza, como hay que mover arriba decrementa la fila, y le pasa la nueva
; fila, columna de la cabeza con el valor de la cabeza a movSnake que ya vimos que se encarga de aumentar en uno
; la cabeza y si en donde se va a poner, fila, columna pasados en parametros es una manzana se pone el nuevo
; valor de la cabeza, se aumenta la puntuacion y se pone en false la fruta, si es una celda libre pone el nuevo
; valor de la cabeza y llama a reduction, retorna lo mismo que retorna movSnake para informar si se pudo o no 
; mover
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
    call maxUValue; busca la fila, columna de la cabeza
    
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
    mov al, [esi]; pone en eax el valor de la cabeza
    dec ebx; decrementa la fila
    
    push ecx; pasa la nueva fila, columna con el valor al movSnake y retorna lo mismo que este
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
; bool movDown(dword (pointer)tablero)
; idem al anterior pero incrementando la fila
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

; bool movLeft(dword(pointer) tablero)
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

; bool movRight(dword(pointer) tablero)
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

; void putRandomApple2(dword(pointer) tablero, dword valor, dword maxFila, dword maxColumna, dword(pointer) fruta)
; hace lo mismo que putRandomApple pero solo pone la fruta si fruta es 0, si la pudo poner pone fruta en 1
; de otra manera a deja en 0, ideal para trabajar dentro del gameloop de esta forma no se detiene el juego, se
; puede seguir jugando, sin fruta, hasta que aparezca una esto hace un poco mas dificil el juego, puesto que
; tienes que moverte sin un objetivo dentro del mapa, garantizando no perder y luego moverte hacia la fruta 
; una vez que esta aparezca, lo cual puede depender de cuan cargado este el tablero
global putRandomApple2
putRandomApple2:
    push eax
    push edx
    pushfd
    push esi
    push ebx
    push ecx
    push ebp
    mov ebp, esp
    
    mov esi, [ebp+48]
    cmp dword [esi], 0
    jne final12
    
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
    
    je final12
        
    
    push ecx
    push ebx
    push dword [ebp+36]
    push dword [ebp+32]
    call putValue
    
    mov dword [esi], 1
    
    final12:
    
    pop ebp
    pop ecx
    pop ebx
    pop esi
    popfd
    pop edx
    pop eax
ret 20

; bool isSpaceous(dword(pointer) tablero, dword fila, dword columna)
; retorna 0 si la posicion fila, columna en la matriz es distinta de 0 o las ocho posiciones adyacentes lo son,
; 1 en caso contrario
global isSpaceous
isSpaceous:
    pushfd
    push edx
    push ebp
    mov ebp, esp
    
    push dword 80
    push dword 24
    push dword [ebp+24]
    push dword [ebp+20]
    push dword [ebp+16]
    call isValidPosition
    
    cmp eax, 0
    je final13
    
    ; abajo
    mov edx, [ebp+20]
    inc edx
    
    push dword 80
    push dword 24
    push dword [ebp+24]
    push edx
    push dword [ebp+16]
    call isValidPosition
    
    cmp eax, 0
    je final13
    
    ; arriba
    mov edx, [ebp+20]
    dec edx
    
    push dword 80
    push dword 24
    push dword [ebp+24]
    push edx
    push dword [ebp+16]
    call isValidPosition
    
    cmp eax, 0
    je final13
    
    ;izquierda
    mov edx, [ebp+24]
    dec edx
    
    push dword 80
    push dword 24
    push edx
    push dword [ebp+20]
    push dword [ebp+16]
    call isValidPosition
    
    cmp eax, 0
    je final13
    
    ; derecha
    mov edx, [ebp+24]
    inc edx
    
    push dword 80
    push dword 24
    push edx
    push dword [ebp+20]
    push dword [ebp+16]
    call isValidPosition
    
    cmp eax, 0
    je final13
    
    ; izquierda arriba
    mov eax, [ebp+20]
    mov edx, [ebp+24]
    dec edx
    dec eax
    
    push dword 80
    push dword 24
    push edx
    push eax
    push dword [ebp+16]
    call isValidPosition
    
    cmp eax, 0 
    je final13
    
    ; izquierda abajo
    mov eax, [ebp+20]
    mov edx, [ebp+24]
    dec edx
    inc eax
    
    push dword 80
    push dword 24
    push edx
    push eax
    push dword [ebp+16]
    call isValidPosition
    
    cmp eax, 0
    je final13
    
    ; derecha abajo
    mov eax, [ebp+20]
    mov edx, [ebp+24]
    inc edx
    inc eax
    
    push dword 80
    push dword 24
    push edx
    push eax
    push dword [ebp+16]
    call isValidPosition
    
    cmp eax, 0
    je final13
    
    ; derecha arriba
    mov eax, [ebp+20]
    mov edx, [ebp+24]
    inc edx
    dec eax
    
    push dword 80
    push dword 24
    push edx
    push eax
    push dword [ebp+16]
    call isValidPosition
    
    cmp eax, 0
    je final13
    
    mov eax, 1
    
    final13:
    pop ebp
    pop edx
    popfd
  
ret 12

; void putRandomValues(dword(pointer) tablero, dword numberOfValues, dword value)
; pone un valor un numero de veces en el tablero de manera aleatoria, ideal para construir tableros aleatorios
global putRandomValues
putRandomValues:
    push eax
    push edx
    push ecx
    pushfd
    push ebx
    push dword 0
    push dword 0
    push ebp
    mov ebp, esp
    mov ecx, [ebp+40]
    
    Ciclo9:
        rdtsc; hace un ciclo pidiendo el rdtsc y verificando si la posicion y las ocho adyacentes son validas
        xor edx, edx; de serlo pone el valor sino busca otro
        mov ebx, 80
        div ebx
        mov dword [ebp+8], edx
        
        rdtsc
        xor edx, edx
        mov ebx, 24
        div ebx
        mov dword [ebp+4], edx
        
        push dword [ebp+8]
        push dword [ebp+4]
        push dword [ebp+36]
        call isSpaceous
        
        cmp eax, 0
        je Ciclo9
        
        push dword [ebp+8]
        push dword [ebp+4]
        push dword [ebp+44]
        push dword [ebp+36]
        call putValue
        
    loop Ciclo9
    
    pop ebp
    pop ebx
    pop ebx
    pop ebx
    popfd
    pop ecx
    pop edx
    pop eax

ret 12

; void increasingPuntuation(dword puntuacion (pointer))
; incrementa lo que apunta puntuacion y llama a drawNumber para que lo pinte en pantalla
global increasingPuntuation
increasingPuntuation:
    push esi
    push eax
    push ebp
    mov ebp, esp
    
    mov esi, [ebp+16]
    mov eax, [esi]
    inc eax
    mov [esi], eax
    
    push dword 79
    push dword 0
    push eax
    call drawNumber
    
    pop ebp
    pop eax
    pop esi
ret 4

; void decreasingPuntuation(dword(pointer) timer, dword(pointer) puntuacion, dword ms)
; dado un puntero a un timer, uno a puntuacion y un tiempo, si el tiempo ya paso entonces se decrementa lo que 
; apunta puntuacion, de otra manera no se hace nada, se aparta el caso 0 en el que no hay que disminuir nada
global decreasingPuntuation
decreasingPuntuation:
    push eax
    push esi
    push ebp
    mov ebp, esp
    
    push dword [ebp+24]; se le pregunta a delay si el tiempo paso, de no serlo se retorna
    push dword [ebp+16]
    call delay
    cmp eax, 0
    je final15
    
    mov esi, [ebp+20]; se pregunta si lo que hay es un 0, en ese caso se pinta y se retorna porque no es idea
    cmp dword [esi], 0; tabajar con numero negativos
    je ponCero
    mov eax, [esi]
    dec eax
    mov [esi], eax
    
    push dword WHITE; de otra manera se borra lo que esta en la parte del score, se disminuye lo que apunta
    push dword BLACK; puntuacion y se pinta en la parte del score
    push dword 5
    push dword 75
    push dword 0
    push dword ' '
    call drawHorizontalLine
 
    push dword 79
    push dword 0
    push eax
    call drawNumber
    jmp final15
    
    ponCero:
    push dword 79
    push dword 0
    push dword 0
    call drawNumber

    final15:
    
    pop ebp
    pop esi
    pop eax    
ret 12

; void scoreBoard(dword (pointer) puntuaciones, dword lenght)

global scoreBoard
scoreBoard:
    push eax
    push ebx
    push ecx
    push esi
    pushfd
    push dword 0
    push dword 0
    push dword 0
    push dword 0
    push ebp
    mov ebp, esp
    
    push dword DARKBLUE
    push dword BLACK
    push dword 30
    push dword 0
    push dword ':'
    push dword 'd'
    push dword 'r'
    push dword 'a'
    push dword 'o'
    push dword 'B'
    push dword ' '
    push dword 'e'
    push dword 'r'
    push dword 'o'
    push dword 'c'
    push dword 'S'
    push dword 12
    call drawText
    add esp, 68
    
    mov esi, [ebp+44]
    mov ecx, 4
    mov eax, 1
    
    Ciclo11:
        push dword 42
        push dword eax
        push dword [esi]
        call drawNumber
        
        inc eax
        add esi, 4
    loop Ciclo11
    
    pop ebp
    pop eax
    pop eax
    pop eax
    pop eax
    popfd
    pop esi
    pop ecx
    pop ebx
    pop eax
ret 8

; void updateMap2(dword (pointer)tablero, dword (pointer)timer, dword direccion, dword ms)
; en dependencia de la direccion muevo la serpiente en la matriz apuntada por tablero, en la direccion que se me 
; pida y una vez pasado el timepo que se me pida, usando el reloj apuntado por timer, la direccion es una tecla
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
    
    cmp eax, 0; pregunto si ya paso el tiempo si no retorno, si paso pregunto por la direccion y llamao a las 
    je final10; funciones que mueven la snake, si se pudo mover retorno de no moverse llamo a gameOver para 
    ; cambiar la pagina
    mov esi, [ebp+32]
    
    cmp byte [esi], KEY.UP
    jne continue18
    
    push dword [ebp+24]
    call movUp
    
    cmp eax, 0
    jne final10
    
    call gameOver
    jmp final10
    
    continue18:
    
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