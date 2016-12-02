%include "video.mac"
%include "keyboard.mac"
section .data
    tablero times 1920 db 0
    page dd 1
    direccion dd 0
    timer dq 0
    global fruta
    fruta dd 1
    puntuaciones times 5000 db 0
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
  
    cmp dword [page], 3
    jne noJuego   
   
    push dword [tiempo]
    push dword puntuacion
    push dword timerPuntuacion
    call decreasingPuntuation

    push dword fruta
    push dword 80
    push dword 24
    push dword 254
    push dword tablero
    call putRandomApple2

    push dword [velocidad]
    push dword direccion
    push dword timer
    push dword tablero
    
    call updateMap2
    cmp dword [page], 4
    jne continueJuego
    
    FILL_SCREEN BG.BLACK
    jmp noJuego
    
    continueJuego:
    push dword tablero
    call drawTablero
    noJuego:
    
    cmp dword [page], 4
    jne noGameOver
    
    push dword 5000
    push dword puntuaciones
    call scoreBoard
    
    call lastMessagge
    
    ; tanto para reiniciar
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

get_input:
    call scan
    push ax
    ; The value of the input is on 'word [esp]'

    ; Your bindings here
    cmp dword [page], 1
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
    endingPage1:
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
    page2:
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
    endingPage2:
        cmp eax, 1
        jne verLombriz
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
    page3:
    cmp dword [page], 3
    jne page4
    bind KEY.UP, wrapMovUp
    bind KEY.DOWN, wrapMovDown
    bind KEY.LEFT, wrapMovLeft
    bind KEY.RIGHT, wrapMovRight
    page4:
    cmp dword [page], 4
    jne final14
    bind KEY.ENTER, startAgain
    
    final14:
    add esp, 2 ; free the stack
    ret

wrapMovRight:
    push eax
    push ebp
    mov ebp, esp
    
    push dword tablero
    call movRight
    
    mov dword [direccion], KEY.RIGHT
    
    cmp eax, 0
    jne continueWrapMovRight
    call gameOver
    FILL_SCREEN BG.BLACK
    continueWrapMovRight:
    
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
    
    cmp eax, 0
    jne continueWrapMovLeft
    call gameOver
    FILL_SCREEN BG.BLACK
    continueWrapMovLeft:
    
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
    
    cmp eax, 0
    jne continueWrapMovDown
    call gameOver
    FILL_SCREEN BG.BLACK
    continueWrapMovDown:
    
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
    
    cmp eax, 0
    jne continueWrapMovUp
    call gameOver
    FILL_SCREEN BG.BLACK
    continueWrapMovUp:
    
    pop ebp
    pop eax
ret 

global gameOver
gameOver:
    push ebp
    mov ebp, esp
    
    mov dword [page], 4
    call sound2
    
    push dword 5000
    push dword [puntuacion]
    push dword puntuaciones 
    call addNumberToArray
       
    pop ebp
ret

; void startAgain()
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