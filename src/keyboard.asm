%include "keyboard.mac"
%include "video.mac"

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
; se encarga de mover el cursor por el menu, verifica la tecla que hay en key, se verifica que sea la de arriba 
; o abajo pero no presionadas, puesto que si se verificasen que estan presionadas esto se haria miles de veces
; en un segundo y si movemos el cursor cada vez que se presiona la tecla el cursor se moveria miles de veces
; en un segundo, lo cual evidentemente no nos interesa para nuestro objetivo de crear un menu, por eso tenemos una
; variable llamada lastKey que se encarga de almacenar el valor anterior de key si este fue la tecla de abajo
; o arriba presionada, de esta manera si la tecla actual es abajo o arriba no presionada y la anterior fue la 
; presionada entonces se mueve el cursor, de otra manera no, es por este problema de verificar la tecla presionada
; miles de veces por lo que tuve que cambiar la tecla de seleccion en el menu de la dificultad y poner espacio
; en vez del logico enter, porque si tocabas enter en el primer menu, cuando salia el segundo, en ese intervalo
; de milesimas la tecla enter seguia presionada y entonces se seleccionaba sin querer la otra opcion por eso 
; cambie a otra tecla, la otra idea que se me ocurrio para esto era usar un sleep entre menu y menu, pero eso 
; venia con el inconveniente del tiempo que tenia que esperar para que la tecla se soltara, hubiera tenido que 
; parar el pograma, etc y quizas me encontrace con otros problemas por esa rama, otra posible idea era tener
; una varible 'booleana' que me dijera si se solto el enter para permitir que se presione en el menu de dificultad
; pero eso me parecio un parche, entonce decidi cambiar la tecla de seleccion, que era una opcion mas rapida,
; sencilla, eficaz y simple de manera general
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
    
    push dword WHITE; esta parte es importante, puesto que se usa para borrar el cursor donde estaba anteriormente,
    push dword BLACK; para despues ponerlo en su nueva posicion
    push dword 29
    push dword [cursor]
    push dword ' '
    call putChar
    
    mov ebx, [cursor]; se calcula la nueva posicion del curso y se pinta en esa parte, luego de haber borrado
    inc ebx; donde estaba antes
    cmp ebx, 22
    jne Continue2
    mov ebx, 17
    Continue2:
    mov [cursor], ebx
    push dword WHITE
    push dword BLACK
    push dword 29
    push dword [cursor]
    push dword '*'
    call putChar
    jmp continueWhile3
    Continue1:
    cmp [key], byte KEY.UP.UP; lo mismo para la tecla de arriba
    jne continueWhile3
    cmp [lastKey], byte KEY.UP
    jne continueWhile3
    push dword WHITE
    push dword BLACK
    push dword 29
    push dword [cursor]
    push dword ' '
    call putChar; he intentado reutilizar el codigo lo mas posible, utilizando un gran numero de funciones 'bases'
    mov ebx, [cursor]; para sobre esas montar el programa y las funciones mas grandes, algo asi como programacion
    dec ebx; orientada a objetos pero con funciones
    cmp ebx, 16
    jne Continue3
    mov ebx, 21
    Continue3:
    mov [cursor], ebx
    push dword WHITE
    push dword BLACK
    push dword 29
    push dword [cursor]
    push dword '*'
    call putChar
    continueWhile3:
    mov cl, [key]; aca se actualiza la lastKey
    mov [lastKey], cl
    jmp false1
    
    true1:
    mov eax, [cursor]; aca se mueve el cursor a eax y se le resta 16, puesto que las opciones estan a partir de 
    sub eax, 16; la fila 17, eso dejara 1 para la primera opcion, 2 para la segunda, etc
    jmp end1
    false1:; en el caso de que no se halla dado enter se retorna 0, indicando que no se ha seleccionado nada
    mov eax, 0
    end1:
    pop ebp
    pop ebx
    pop ecx
ret

; int showMenuDiff()
; dibuja el menu de dificultad en la pantalla y deja en el eax el numero de la opcion seleccionada
; lo mismo que la anterior pero con space
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
    
    push dword WHITE
    push dword BLACK
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
    push dword WHITE
    push dword BLACK
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
    push dword WHITE
    push dword BLACK
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
    push dword WHITE
    push dword BLACK
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
