%include "video.mac"
%include "keyboard.mac"
section .data
    tablero times 1920 db 0
    page dd 1
    direccion dd 0
    timer dq 0
    global fruta
    fruta dd 1
    puntuaciones times 4 dd 0
    velocidad dd 0
    tiempo dd 0
    timerPuntuacion dq 0
    global puntuacion
    puntuacion dd 0
 

section .text

extern clear, putc
extern scan
extern calibrate
extern drawTablero
extern Aleatorio
extern showWelcome
extern updateMap2
extern showMenuDiff
extern showMenuMap
extern ArrecifeCoralino
extern Antartida
extern Amazonas
extern LaLuna
extern drawHorizontalLine
extern sound1
extern sound2
extern sound3
extern lastMessagge
extern instruction
extern decreasingPuntuation
extern putRandomApple2
extern scoreBoard
extern movUp, movRight, movDown, movLeft
extern addNumberToArray
extern menuMap
extern menuDiff


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
      
    call instruction
    
    call showWelcome

    call sound1

  ; Snakasm main loop
  game.loop:
    .input:
      call get_input

    ; Main loop
    
    cmp dword [page], 1
    jne noMenuMap
    
    call menuMap
    
    noMenuMap:
    
    cmp dword [page], 2
    jne noMenuDiff
    
    call menuDiff
    
    noMenuDiff:
  
    cmp dword [page], 3; en dependencia de la pagina se ejecuta o no algunas partes del ciclo, en la pagina 3 
    jne noJuego; correspondiente al juego se le pasa el tiempo en el que se desea disminuir la puntuacion, un    
    ; timer y el valor a puntuacion, una vez dentro del ciclo en esta parte la fucion se va a encargar de reducir
    
    ; cmp dword [fruta], 1
    ; jne continueDecreasingPuntuation
    ; mov dword [timerPuntuacion], 0
    ; mov dword [timerPuntuacion+4], 0
    
    ;continueDecreasingPuntuation
    
    push dword [tiempo]; la puntuacion en el tiempo pasado dentro de la pagina 3 
    push dword puntuacion
    push dword timerPuntuacion
    call decreasingPuntuation

    push dword fruta; ponemos una fruta si no hay
    push dword 80
    push dword 24
    push dword 254
    push dword tablero
    call putRandomApple2

    push dword [velocidad]; movemos la serpiente si no se ha movido con las teclas para la ultima direccion 
    push dword direccion; en la que se movio, con la velocidad que se nos pida y el timer propio para ella
    push dword timer
    push dword tablero  
    call updateMap2
    
    cmp dword [page], 4; verifico si updateMap2 llamo a gameOver de ser asi borro la pantalla y salgo de la pagina
    jne continueJuego
    
    FILL_SCREEN BG.BLACK
    jmp noJuego
    
    continueJuego:; si no se dio gameover se pinta el tablero en pantalla
    push dword tablero
    call drawTablero
    noJuego:
    
    cmp dword [page], 4; de otra manera si estamos en la pagina del game over se llama al scoreboard que informa
    jne noGameOver; de las puntuaciones mas altas hasta el momento
    
    push dword 4
    push dword puntuaciones
    call scoreBoard
    
    call lastMessagge
    
    noGameOver:
    
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
; se encarga del binding de todas las teclas en dependencia de la pagina en la que se encuentre el juego, se 
; entiende por pagina a 'un estado', o sea, el primer menu para seleccionar el mapa, el segundo para la dificultad
; el tercero que es el juego como tal, y el ultimo que es el gameover donde se muestra el scoreboard y se pregunta
; por volver a iniciar. pregunta por la pagina en la que nos encontramos y en dependecia pasa los bindings, ademas
; de la seleccion del mapa hace los llamados a las funciones que lo construyen y en dependencia del nivel de 
; dificultad escogido actualiza las variables globales que se utilizan en el juego como la velocidad de la 
; serpiente y el tiempo en el que disminuye la puntuacion, ademas de actualizar las paginas en la parte de los 
; menus, ya que el menu una vez dado enter deja en el eax el numero de la opcion seleccionada, entonces la funcion
; llama a los contructores del mapa acorde a la opcion o inicializa las varibles.
get_input:
    call scan
    push ax
    ; The value of the input is on 'word [esp]'

    ; Your bindings here
    cmp dword [page], 1; aca se pregunta si estamos en la primera pagina y se bindea al menu de los mapas
    jne page2
    mov eax, 0
    bind KEY.DOWN, showMenuMap
    bind KEY.DOWN.UP, showMenuMap
    bind KEY.UP.UP, showMenuMap
    bind KEY.UP, showMenuMap
    bind KEY.ENTER, showMenuMap
    cmp eax, 0
    je final14
    ; aca se actualiza la pagina y se hacen otros llamados en dependencia del valor de retorno del menu
    endingPage1:; luego del retorno del menu de los mapas se crea el mapa que se selecciono
        cmp eax, 1
        jne verArrecifeCoralino
        push dword tablero
        call Antartida
        mov eax, 2
        mov [page], eax
        mov eax, 1
        FILL_SCREEN BG.BLACK
        verArrecifeCoralino:
        cmp eax, 2
        jne verAmazonas
        push dword tablero
        call ArrecifeCoralino
        mov eax, 2
        mov [page], eax 
        FILL_SCREEN BG.BLACK
        verAmazonas:
        cmp eax, 3
        jne verLaLuna
        push dword tablero
        call Amazonas
        mov eax, 2
        mov [page], eax
        FILL_SCREEN BG.BLACK
        verLaLuna:
        cmp eax, 4
        jne verAleatorio
        push dword tablero
        call LaLuna
        mov eax, 2
        mov [page], eax
        FILL_SCREEN BG.BLACK
        verAleatorio:
        cmp eax, 5
        jne endPage1
        push dword 200; hay una alta posibilidad de que se demore un poco haciendo el tablero
        push dword tablero
        call Aleatorio
        mov eax, 2
        mov [page], eax
        FILL_SCREEN BG.BLACK
        endPage1:
    page2:; aca se pregunta si estamos en la pagina dos, la dificultad y se bindea al menu de dificultad
    cmp dword [page], 2
    jne page3
    mov eax, 0
    bind KEY.DOWN, showMenuDiff
    bind KEY.DOWN.UP, showMenuDiff
    bind KEY.UP.UP, showMenuDiff
    bind KEY.UP, showMenuDiff
    bind KEY.SPACE, showMenuDiff
    cmp eax, 0
    je final14
    endingPage2:; en dependencia de la opcion seleccionada se inicializan las variables globales que se les pasan
        cmp eax, 1; a las funciones que updatean el mapa si no se ha movido la serpiente y a la disminucion del
        jne verLombriz; score
        mov eax, 1500
        mov [velocidad], eax
        mov eax, 10000
        mov [tiempo], eax
        mov eax, 3
        mov [page], eax
        mov eax, 1
        call sound3
        verLombriz:
        cmp eax, 2
        jne verSerpiente
        mov eax, 1000
        mov [velocidad], eax 
        mov eax, 7000
        mov [tiempo], eax
        mov eax, 3
        mov [page], eax
        mov eax, 2
        call sound3
        verSerpiente:
        cmp eax, 3
        jne verSerpienteConCohetes
        mov eax, 500
        mov [velocidad], eax
        mov eax, 5000
        mov [tiempo], eax
        mov eax, 3
        mov [page], eax
        call sound3
        verSerpienteConCohetes:
        cmp eax, 4
        jne verFlashSnake
        mov eax, 90
        mov [velocidad], eax
        mov eax, 2000
        mov [tiempo], eax
        mov eax, 3
        mov [page], eax
        call sound3
        verFlashSnake:
        cmp eax, 5
        jne endPage2
        mov eax, 50
        mov [velocidad], eax
        mov eax, 1000
        mov [tiempo], eax
        mov eax, 3
        mov [page], eax
        call sound3
        endPage2:
    page3:; aca se pregunta si estamos en la pagina tres y se bindea a los movimientos del snake
    cmp dword [page], 3
    jne page4
    bind KEY.UP, wrapMovUp
    bind KEY.DOWN, wrapMovDown
    bind KEY.LEFT, wrapMovLeft
    bind KEY.RIGHT, wrapMovRight
    page4:; aca se pregunta si estamos en la pagina 4 y se bindea a la funcion para volver a empezar, en donde se 
    cmp dword [page], 4; reinicializan las varibles globales
    jne final14
    bind KEY.ENTER, startAgain
    
    final14:
    add esp, 2 ; free the stack
    ret
; void wrapMovRight()
; wrapea la funcion movRight pasandole los parametros globales, actualiza la direccion y verifica si se pudo mover
; o no, en dependencia llama a gameOver, y borra el mapa de la pantalla, despues gameover se encarga de dar sonido
; y de pasar el control a la pagina 4 en donde se gestiona si reiniciar el juego
wrapMovRight:
    push eax
    push ebp
    mov ebp, esp
    
    cmp dword [direccion], KEY.LEFT
    je finalWrapMoveRight
    
    
    push dword tablero
    call movRight
    
    mov dword [direccion], KEY.RIGHT
    
    cmp eax, 0
    jne continueWrapMovRight
    call gameOver
    FILL_SCREEN BG.BLACK
    continueWrapMovRight:
    
    mov dword [timer], 0
    mov dword [timer+4], 0
    
    finalWrapMoveRight:
    
    pop ebp
    pop eax
ret
; void wrapMovLeft()
; wrapea la funcion movLeft pasandole los parametros globales, actualiza la direccion y verifica si se pudo mover
; o no, en dependencia llama a gameOver, y borra el mapa de la pantalla, despues gameover se encarga de dar sonido
; y de pasar el control a la pagina 4 en donde se gestiona si reiniciar el juego
wrapMovLeft:
    push eax
    push ebp
    mov ebp, esp
    
    cmp dword [direccion], KEY.RIGHT
    je finalWrapMovLeft
    
    push dword tablero
    call movLeft
    
    mov dword [direccion], KEY.LEFT
    
    cmp eax, 0
    jne continueWrapMovLeft
    call gameOver
    FILL_SCREEN BG.BLACK
    continueWrapMovLeft:
    
    mov dword [timer], 0
    mov dword [timer+4], 0
    
    finalWrapMovLeft:
    
    pop ebp
    pop eax
ret
; void wrapMovDown()
; wrapea la funcion movDown pasandole los parametros globales, actualiza la direccion y verifica si se pudo mover
; o no, en dependencia llama a gameOver, y borra el mapa de la pantalla, despues gameover se encarga de dar sonido
; y de pasar el control a la pagina 4 en donde se gestiona si reiniciar el juego
wrapMovDown:
    push eax
    push ebp
    mov ebp, esp
    
    cmp dword [direccion], KEY.UP
    je finalWrapMovDown
    
    push dword tablero
    call movDown
    
    mov dword [direccion], KEY.DOWN
    
    cmp eax, 0
    jne continueWrapMovDown
    call gameOver
    FILL_SCREEN BG.BLACK
    continueWrapMovDown:
    
    mov dword [timer], 0; pongo el timer de actualizar el snake en 0 para que se empiece a contar justo cuando 
    mov dword [timer+4], 0; se movio la serpiente por las teclas, de otra forma si vas a mover con las teclas 
    ; tienes que saber cuando es que ella va a mover sola, y hace el juego mas complicado, demasiado desde mi
    finalWrapMovDown:
    
    pop ebp; punto de vista
    pop eax
ret
; void wrapMovUp()
; wrapea la funcion movUp pasandole los parametros globales, actualiza la direccion y verifica si se pudo mover
; o no, en dependencia llama a gameOver, y borra el mapa de la pantalla, despues gameover se encarga de dar sonido
; y de pasar el control a la pagina 4 en donde se gestiona si reiniciar el juego
wrapMovUp:
    push eax
    push ebp
    mov ebp, esp
    
    cmp dword [direccion], KEY.DOWN
    je finalWrapMovUp
    
    push dword tablero
    call movUp
    
    mov dword [direccion], KEY.UP
    
    cmp eax, 0
    jne continueWrapMovUp
    call gameOver
    FILL_SCREEN BG.BLACK
    continueWrapMovUp:
    
    mov dword [timer], 0
    mov dword [timer+4], 0
    
    finalWrapMovUp:
    
    pop ebp
    pop eax
ret 
; void gameOver()
; esta funcion se encarga de dar el gameover del juego, dispara un sonido, indicando que se ha perdido
; pasa la pagina, cambiando en 'estado' del juego, y agrega al array de puntuaciones la puntuacion del juego, el
; gameover se llama desde updateMap2 como de las funciones del movimiento, porque se sabe si es gameover si el
; movimiento retorno false, o sea para la casilla que te vas a mover, no es libre o fruta, el hecho esta en que,
; si el gameover fuera llamado por uno de los dos tipos de funciones, cabria de esperar un pequeno error a la hora
; de updatear el mapa o a la hora de mover la serpiente, no se daria gameover
global gameOver
gameOver:
    push ebp
    mov ebp, esp
    
    mov dword [page], 4
    call sound2
    
    push dword 16
    push dword [puntuacion]
    push dword puntuaciones 
    call addNumberToArray
       
    pop ebp
ret

; void startAgain()
; permite 'volver a iniciar juego', se reinicializan todas las variables, con excepcion del array de las 
; puntuaciones, que se mantiene para tener las mayores puntuaciones entre juego y juego. Nuevamente, se limpia
; la pantalla, se pone la bienvenida, se llama al sonido, se sigue dentro del gameloop por eso se hace estas tres
; ultimas cosas, y basta reinicializar las variables y cambiar la pagina para que dentro del gameloop el juego
; 'vuelva a empezar'.
startAgain:
    push esi
    push ecx
    push ebp
    mov ebp, esp
    
    mov ecx, 1920
    
    Ciclo12:
        dec ecx
        mov esi, tablero
        add esi, ecx
        mov byte [esi], 0
        inc ecx
    loop Ciclo12
    
    mov dword [page], 1
    mov dword [direccion], 1
    
    mov dword [timer], 0
    mov dword [timer+4], 0
    
    mov dword [fruta], 1
    
    mov dword [velocidad], 0
    mov dword [tiempo], 0
    
    mov dword [timerPuntuacion], 0
    mov dword [timerPuntuacion+4], 0
    
    mov dword [puntuacion], 0
    
    mov dword [page], 1
    
    FILL_SCREEN BG.BLACK
    
    call showWelcome
    call sound1
    
    pop ebp
    pop ecx
    pop esi
ret