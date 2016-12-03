section .text

extern delay

; void soundOn()
; enciende el speaker
soundOn:
    push eax
    push ebp
    mov ebp, esp
    
    in al, 0x61
    or al, 3
    out 0x61, al
    
    pop ebp
    pop eax
ret

; void soundOff()
; apaga el speaker
soundOff:
    push eax
    push ebp
    mov ebp, esp
    
    in al, 0x61
    and al, 252
    out 0x61, al
    
    pop ebp
    pop eax
ret

; void putSound(dword frecuencia)
; se le pone un sonido al speaker, dada una frecuencia
putSound:
    push ebx
    push eax
    push edx
    push ebp
    mov ebp, esp
    
    mov al, 0xb6
    out 0x43, al
    mov eax, 1193380
    mov ebx, [ebp+20]
    xor edx, edx
    div ebx
    
    out 0x42, al
    mov al, ah
    out 0x42, al
    
    pop ebp
    pop edx
    pop eax
    pop ebx
ret 4

; void sound1()
; esta funcion encapsula un sonido, basicamente, enciende el speaker, pasa una frecuencia, espera un tiempo,
; pasa otra, espera un tiempo y pasa otra frecuencia, de esta forma se crea una especie de musica, con esto, si 
; se tiene tiempo y se es muy detallista se podria hacer hasta la musica de mario
global sound1
sound1:
    push eax
    push dword 0
    push dword 0
    push ebp
    mov ebp, esp
    
    call soundOn
    
    push dword 200
    call putSound
    
    while6:
        push dword 3000
        mov eax, ebp
        add eax, 4
        push eax 
        call delay
        
        cmp eax, 0
    je while6
    
    push dword 100
    call putSound
    
    while7:
        push dword 3000
        mov eax, ebp
        add eax, 4
        push eax 
        call delay
        
        cmp eax, 0
    je while7
    
    push dword 300
    call putSound

    while8:
        push dword 3000
        mov eax, ebp
        add eax, 4
        push eax 
        call delay
        
        cmp eax, 0
    je while8
    
    call soundOff    
    
    pop ebp
    pop eax
    pop eax
    pop eax  
ret

; void sound2()
; similar a sound1 pero con distinta frecuencia y distintos tiempos de espera para cambiarla
global sound2
sound2:
    push eax
    push dword 0
    push dword 0
    push ebp
    mov ebp, esp
    
    call soundOn
    
    push dword 4000
    call putSound
    
    while9:
        push dword 1000
        mov eax, ebp
        add eax, 4
        push eax 
        call delay
        
        cmp eax, 0
    je while9
    
    push dword 10
    call putSound
    
    while10:
        push dword 1000
        mov eax, ebp
        add eax, 4
        push eax 
        call delay
        
        cmp eax, 0
    je while10
    
    push dword 600
    call putSound

    while11:
        push dword 1000
        mov eax, ebp
        add eax, 4
        push eax 
        call delay
        
        cmp eax, 0
    je while11
    
    call soundOff    
    
    pop ebp
    pop eax
    pop eax
    pop eax  
ret

; void sound3()
; similar a sound1 pero con distintas frecuencias y distintos tiempos de espera para cambiarla
global sound3
sound3:
    push eax
    push dword 0
    push dword 0
    push ebp
    mov ebp, esp
    
    call soundOn
    
    push dword 2000
    call putSound
    
    while12:
        push dword 1000
        mov eax, ebp
        add eax, 4
        push eax 
        call delay
        
        cmp eax, 0
    je while12
    
    push dword 400
    call putSound
    
    while13:
        push dword 1000
        mov eax, ebp
        add eax, 4
        push eax 
        call delay
        
        cmp eax, 0
    je while13
    
    push dword 600
    call putSound

    while14:
        push dword 1000
        mov eax, ebp
        add eax, 4
        push eax 
        call delay
        
        cmp eax, 0
    je while14
    
    call soundOff    
    
    pop ebp
    pop eax
    pop eax
    pop eax  
ret