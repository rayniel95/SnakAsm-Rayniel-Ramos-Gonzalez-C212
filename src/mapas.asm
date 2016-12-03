section .text

extern putValue
extern putHorizontalLine
extern putVerticalLine
extern putRandomValues

; void Antartida(dword (pointer) tablero)
; crea un mapa en memoria, en la matriz apuntada por tablero
global Antartida
Antartida:
    push ebp
    mov ebp, esp
    
    push dword 0
    push dword 0
    push dword 80
    push dword 255
    push dword [ebp+8]
    call putHorizontalLine
    
    push dword 0
    push dword 23
    push dword 80
    push dword 255
    push dword [ebp+8]
    call putHorizontalLine
    
    push dword 0
    push dword 22
    push dword 22
    push dword 255
    push dword [ebp+8]
    call putVerticalLine
    
    push dword 79
    push dword 22
    push dword 22
    push dword 255
    push dword [ebp+8]
    call putVerticalLine
    
    push dword 3
    push dword 2
    push dword 6
    push dword 255
    push dword [ebp+8]
    call putHorizontalLine
    
    push dword 10
    push dword 2
    push dword 7
    push dword 255
    push dword [ebp+8]
    call putHorizontalLine
    
    push dword 3
    push dword 4
    push dword 6
    push dword 255
    push dword [ebp+8]
    call putHorizontalLine
    
    push dword 8
    push dword 8
    push dword 4
    push dword 255
    push dword [ebp+8]
    call putVerticalLine
    
    push dword 12
    push dword 8
    push dword 5
    push dword 255
    push dword [ebp+8]
    call putVerticalLine
    
    push dword 16
    push dword 9
    push dword 7
    push dword 255
    push dword [ebp+8]
    call putVerticalLine
    
    push dword 5
    push dword 9
    push dword 10
    push dword 255
    push dword [ebp+8]
    call putHorizontalLine
    
    push dword 10
    push dword 10
    push dword 255
    push dword [ebp+8]
    call putValue
    
    push dword 24
    push dword 3
    push dword 5
    push dword 255
    push dword [ebp+8]
    call putHorizontalLine
    
    push dword 28
    push dword 2
    push dword 2
    push dword 255
    push dword [ebp+8]
    call putVerticalLine
    
    push dword 31
    push dword 3
    push dword 21
    push dword 255
    push dword [ebp+8]
    call putHorizontalLine
    
    push dword 4
    push dword 13
    push dword 6
    push dword 255
    push dword [ebp+8]
    call putHorizontalLine
    
    push dword 4
    push dword 14
    push dword 255
    push dword [ebp+8]
    call putValue
     
    push dword 12
    push dword 20
    push dword 7
    push dword 255
    push dword [ebp+8]
    call putVerticalLine
    
    push dword 11
    push dword 14
    push dword 255
    push dword [ebp+8]
    call putValue
    
    push dword 11
    push dword 17
    push dword 255
    push dword [ebp+8]
    call putValue
    
    push dword 4
    push dword 20
    push dword 4
    push dword 255
    push dword [ebp+8]
    call putVerticalLine
    
    push dword 5
    push dword 20
    push dword 2
    push dword 255
    push dword [ebp+8]
    call putHorizontalLine
    
    push dword 9
    push dword 20
    push dword 3
    push dword 255
    push dword [ebp+8]
    call putHorizontalLine
    
    push dword 19
    push dword 22
    push dword 7
    push dword 255
    push dword [ebp+8]
    call putVerticalLine
    
    push dword 28
    push dword 20
    push dword 13
    push dword 255
    push dword [ebp+8]
    call putVerticalLine
    
    push dword 25
    push dword 20
    push dword 3
    push dword 255
    push dword [ebp+8]
    call putHorizontalLine
    
    push dword 29
    push dword 20
    push dword 6
    push dword 255
    push dword [ebp+8]
    call putHorizontalLine
    
    push dword 20
    push dword 16
    push dword 8
    push dword 255
    push dword [ebp+8]
    call putHorizontalLine
    
    push dword 29
    push dword 16
    push dword 8
    push dword 255
    push dword [ebp+8]
    call putHorizontalLine
    
    push dword 37
    push dword 19
    push dword 4
    push dword 255
    push dword [ebp+8]
    call putVerticalLine
    
    push dword 42
    push dword 20
    push dword 15
    push dword 255
    push dword [ebp+8]
    call putVerticalLine
    
    push dword 36
    push dword 10
    push dword 6
    push dword 255
    push dword [ebp+8]
    call putHorizontalLine
    
    push dword 43
    push dword 11
    push dword 11
    push dword 255
    push dword [ebp+8]
    call putHorizontalLine
    
    push dword 49
    push dword 22
    push dword 5
    push dword 255
    push dword [ebp+8]
    call putVerticalLine
    
    push dword 54
    push dword 15
    push dword 7
    push dword 255
    push dword [ebp+8]
    call putVerticalLine
    
    push dword 55
    push dword 15
    push dword 3
    push dword 255
    push dword [ebp+8]
    call putHorizontalLine
    
    push dword 58
    push dword 22
    push dword 8
    push dword 255
    push dword [ebp+8]
    call putVerticalLine
    
    push dword 69
    push dword 22
    push dword 5
    push dword 255
    push dword [ebp+8]
    call putVerticalLine
    
    push dword 69
    push dword 14
    push dword 7
    push dword 255
    push dword [ebp+8]
    call putVerticalLine
    
    push dword 60
    push dword 12
    push dword 10
    push dword 255
    push dword [ebp+8]
    call putVerticalLine
    
    push dword 61
    push dword 8
    push dword 8
    push dword 255
    push dword [ebp+8]
    call putHorizontalLine
    
    push dword 61
    push dword 3
    push dword 18
    push dword 255
    push dword [ebp+8]
    call putHorizontalLine
     
    push dword 1
    push dword 1
    push dword [ebp+8]
    call putRandomValues
    
    push dword 254
    push dword 1
    push dword [ebp+8]
    call putRandomValues
    
    pop ebp
ret 4

; void ArrecifeCoralino(dword (pointer)tablero)
global ArrecifeCoralino
ArrecifeCoralino:
    push ebp
    mov ebp, esp
    
    push dword 0
    push dword 0
    push dword 80
    push dword 255
    push dword [ebp+8]
    call putHorizontalLine
    
    push dword 0
    push dword 23
    push dword 80
    push dword 255
    push dword [ebp+8]
    call putHorizontalLine
    
    push dword 0
    push dword 22
    push dword 22
    push dword 255
    push dword [ebp+8]
    call putVerticalLine
    
    push dword 79
    push dword 22
    push dword 22
    push dword 255
    push dword [ebp+8]
    call putVerticalLine
    
    push dword 12
    push dword 11
    push dword 11
    push dword 255
    push dword [ebp+8]
    call putVerticalLine
    
    push dword 3
    push dword 11
    push dword 9
    push dword 255
    push dword [ebp+8]
    call putHorizontalLine
    
    push dword 3
    push dword 10
    push dword 8
    push dword 255
    push dword [ebp+8]
    call putVerticalLine
    
    push dword 4
    push dword 3
    push dword 6
    push dword 255
    push dword [ebp+8]
    call putHorizontalLine
    
    push dword 9
    push dword 8
    push dword 5
    push dword 255
    push dword [ebp+8]
    call putVerticalLine
    
    push dword 6
    push dword 8
    push dword 3
    push dword 255
    push dword [ebp+8]
    call putHorizontalLine
    
    push dword 6
    push dword 7
    push dword 2
    push dword 255
    push dword [ebp+8]
    call putVerticalLine
    
    push dword 16
    push dword 7
    push dword 6
    push dword 255
    push dword [ebp+8]
    call putHorizontalLine
    
    push dword 22
    push dword 13
    push dword 10
    push dword 255
    push dword [ebp+8]
    call putVerticalLine
    
    push dword 23
    push dword 4
    push dword 22
    push dword 255
    push dword [ebp+8]
    call putHorizontalLine
    
    push dword 29
    push dword 10
    push dword 6
    push dword 255
    push dword [ebp+8]
    call putVerticalLine
    
    push dword 29
    push dword 11
    push dword 24
    push dword 255
    push dword [ebp+8]
    call putHorizontalLine
    
    push dword 38
    push dword 10
    push dword 3
    push dword 255
    push dword [ebp+8]
    call putVerticalLine
    
    push dword 38
    push dword 7
    push dword 12
    push dword 255
    push dword [ebp+8]
    call putHorizontalLine
    
    push dword 49
    push dword 6
    push dword 3
    push dword 255
    push dword [ebp+8]
    call putVerticalLine
    
    push dword 52
    push dword 10
    push dword 6
    push dword 255
    push dword [ebp+8]
    call putVerticalLine
    
    push dword 52
    push dword 4
    push dword 19
    push dword 255
    push dword [ebp+8]
    call putHorizontalLine
    
    push dword 70
    push dword 21
    push dword 17
    push dword 255
    push dword [ebp+8]
    call putVerticalLine
    
    push dword 57
    push dword 21
    push dword 13
    push dword 255
    push dword [ebp+8]
    call putHorizontalLine
    
    push dword 57
    push dword 20
    push dword 14
    push dword 255
    push dword [ebp+8]
    call putVerticalLine
    
    push dword 58
    push dword 7
    push dword 9
    push dword 255
    push dword [ebp+8]
    call putHorizontalLine
    
    push dword 61
    push dword 18
    push dword 9
    push dword 255
    push dword [ebp+8]
    call putVerticalLine
    
    push dword 66
    push dword 18
    push dword 11
    push dword 255
    push dword [ebp+8]
    call putVerticalLine
    
    push dword 61
    push dword 18
    push dword 5
    push dword 255
    push dword [ebp+8]
    call putHorizontalLine
    
    push dword 62
    push dword 10
    push dword 2
    push dword 255
    push dword [ebp+8]
    call putHorizontalLine
    
    push dword 3
    push dword 14
    push dword 26
    push dword 255
    push dword [ebp+8]
    call putHorizontalLine
    
    push dword 3
    push dword 21
    push dword 7
    push dword 255
    push dword [ebp+8]
    call putVerticalLine
    
    push dword 4
    push dword 21
    push dword 3
    push dword 255
    push dword [ebp+8]
    call putHorizontalLine
    
    push dword 6
    push dword 20
    push dword 4
    push dword 255
    push dword [ebp+8]
    call putVerticalLine
    
    push dword 9
    push dword 23
    push dword 9
    push dword 255
    push dword [ebp+8]
    call putVerticalLine
    
    push dword 13
    push dword 21
    push dword 2
    push dword 255
    push dword [ebp+8]
    call putVerticalLine
    
    push dword 13
    push dword 19
    push dword 18
    push dword 255
    push dword [ebp+8]
    call putHorizontalLine
    
    push dword 22
    push dword 18
    push dword 2
    push dword 255
    push dword [ebp+8]
    call putVerticalLine
    
    push dword 17
    push dword 22
    push dword 2
    push dword 255
    push dword [ebp+8]
    call putVerticalLine
    
    push dword 22
    push dword 22
    push dword 2
    push dword 255
    push dword [ebp+8]
    call putVerticalLine
    
    push dword 27
    push dword 22
    push dword 2
    push dword 255
    push dword [ebp+8]
    call putVerticalLine
    
    push dword 31
    push dword 23
    push dword 10
    push dword 255
    push dword [ebp+8]
    call putVerticalLine
    
    push dword 37
    push dword 21
    push dword 7
    push dword 255
    push dword [ebp+8]
    call putVerticalLine
    
    push dword 45
    push dword 23
    push dword 6
    push dword 255
    push dword [ebp+8]
    call putVerticalLine
    
    push dword 52
    push dword 23
    push dword 11
    push dword 255
    push dword [ebp+8]
    call putVerticalLine
    
    push dword 41
    push dword 18
    push dword 4
    push dword 255
    push dword [ebp+8]
    call putHorizontalLine
    
    push dword 38
    push dword 15
    push dword 14
    push dword 255
    push dword [ebp+8]
    call putHorizontalLine  
    
    push dword 1
    push dword 1
    push dword [ebp+8]
    call putRandomValues
    
    push dword 254
    push dword 1
    push dword [ebp+8]
    call putRandomValues
      
    pop ebp
ret 4

; void Amazonas(dword(pointer) tablero)
global Amazonas
Amazonas:
    push ebp
    mov ebp, esp
    
    push dword 0
    push dword 0
    push dword 80
    push dword 255
    push dword [ebp+8]
    call putHorizontalLine
    
    push dword 0
    push dword 23
    push dword 80
    push dword 255
    push dword [ebp+8]
    call putHorizontalLine
    
    push dword 0
    push dword 22
    push dword 22
    push dword 255
    push dword [ebp+8]
    call putVerticalLine
    
    push dword 79
    push dword 22
    push dword 22
    push dword 255
    push dword [ebp+8]
    call putVerticalLine
    
    push dword 4
    push dword 3
    push dword 25
    push dword 255
    push dword [ebp+8]
    call putHorizontalLine
    
    push dword 4
    push dword 4
    push dword 255
    push dword [ebp+8]
    call putValue
    
    push dword 1
    push dword 7
    push dword 27
    push dword 255
    push dword [ebp+8]
    call putHorizontalLine
    
    push dword 3
    push dword 10
    push dword 7
    push dword 255
    push dword [ebp+8]
    call putHorizontalLine
    
    push dword 14
    push dword 11
    push dword 7
    push dword 255
    push dword [ebp+8]
    call putHorizontalLine
    
    push dword 28
    push dword 11
    push dword 8
    push dword 255
    push dword [ebp+8]
    call putVerticalLine
    
    push dword 20
    push dword 10
    push dword 3
    push dword 255
    push dword [ebp+8]
    call putVerticalLine
    
    push dword 9
    push dword 13
    push dword 3
    push dword 255
    push dword [ebp+8]
    call putVerticalLine
    
    push dword 1
    push dword 14
    push dword 56
    push dword 255
    push dword [ebp+8]
    call putHorizontalLine
    
    push dword 33
    push dword 13
    push dword 11
    push dword 255
    push dword [ebp+8]
    call putVerticalLine
    
    push dword 45
    push dword 13
    push dword 8
    push dword 255
    push dword [ebp+8]
    call putVerticalLine
    
    push dword 38
    push dword 11
    push dword 7
    push dword 255
    push dword [ebp+8]
    call putHorizontalLine
    
    push dword 38
    push dword 6
    push dword 7
    push dword 255
    push dword [ebp+8]
    call putHorizontalLine
    
    push dword 36
    push dword 3
    push dword 33
    push dword 255
    push dword [ebp+8]
    call putHorizontalLine
    
    push dword 56
    push dword 10
    push dword 7
    push dword 255
    push dword [ebp+8]
    call putVerticalLine
    
    push dword 64
    push dword 17
    push dword 12
    push dword 255
    push dword [ebp+8]
    call putVerticalLine
    
    push dword 50
    push dword 11
    push dword 14
    push dword 255
    push dword [ebp+8]
    call putHorizontalLine
    
    push dword 68
    push dword 19
    push dword 16
    push dword 255
    push dword [ebp+8]
    call putVerticalLine
    
    push dword 3
    push dword 17
    push dword 54
    push dword 255
    push dword [ebp+8]
    call putHorizontalLine
    
    push dword 3
    push dword 20
    push dword 3
    push dword 255
    push dword [ebp+8]
    call putVerticalLine
    
    push dword 12
    push dword 20
    push dword 3
    push dword 255
    push dword [ebp+8]
    call putVerticalLine
    
    push dword 18
    push dword 22
    push dword 3
    push dword 255
    push dword [ebp+8]
    call putVerticalLine
    
    push dword 24
    push dword 20
    push dword 3
    push dword 255
    push dword [ebp+8]
    call putVerticalLine
    
    push dword 25
    push dword 20
    push dword 29
    push dword 255
    push dword [ebp+8]
    call putHorizontalLine
    
    push dword 53
    push dword 19
    push dword 255
    push dword [ebp+8]
    call putValue
    
    push dword 56
    push dword 20
    push dword 3
    push dword 255
    push dword [ebp+8]
    call putVerticalLine
    
    push dword 57
    push dword 20
    push dword 22
    push dword 255
    push dword [ebp+8]
    call putHorizontalLine 
    
    push dword 1
    push dword 1
    push dword [ebp+8]
    call putRandomValues
    
    push dword 254
    push dword 1
    push dword [ebp+8]
    call putRandomValues
      
    pop ebp
ret 4

; void LaLuna(dword(pointer) tablero)
global LaLuna
LaLuna:
    push ebp
    mov ebp, esp
    
    push dword 0
    push dword 0
    push dword 80
    push dword 255
    push dword [ebp+8]
    call putHorizontalLine
    
    push dword 0
    push dword 23
    push dword 80
    push dword 255
    push dword [ebp+8]
    call putHorizontalLine
    
    push dword 0
    push dword 22
    push dword 22
    push dword 255
    push dword [ebp+8]
    call putVerticalLine
    
    push dword 79
    push dword 22
    push dword 22
    push dword 255
    push dword [ebp+8]
    call putVerticalLine
    
    push dword 4
    push dword 5
    push dword 24
    push dword 255
    push dword [ebp+8]
    call putHorizontalLine
    
    push dword 4
    push dword 4
    push dword 2
    push dword 255
    push dword [ebp+8]
    call putVerticalLine
    
    push dword 12
    push dword 4
    push dword 2
    push dword 255
    push dword [ebp+8]
    call putVerticalLine
    
    push dword 19
    push dword 4
    push dword 2
    push dword 255
    push dword [ebp+8]
    call putVerticalLine
    
    push dword 23
    push dword 2
    push dword 2
    push dword 255
    push dword [ebp+8]
    call putVerticalLine
    
    push dword 27
    push dword 4
    push dword 4
    push dword 255
    push dword [ebp+8]
    call putVerticalLine
    
    push dword 30
    push dword 2
    push dword 2
    push dword 255
    push dword [ebp+8]
    call putVerticalLine
    
    push dword 12
    push dword 8
    push dword 3
    push dword 255
    push dword [ebp+8]
    call putVerticalLine
    
    push dword 19
    push dword 8
    push dword 3
    push dword 255
    push dword [ebp+8]
    call putVerticalLine
    
    push dword 4
    push dword 12
    push dword 5
    push dword 255
    push dword [ebp+8]
    call putVerticalLine
    
    push dword 5
    push dword 12
    push dword 20
    push dword 255
    push dword [ebp+8]
    call putHorizontalLine
    
    push dword 24
    push dword 11
    push dword 6
    push dword 255
    push dword [ebp+8]
    call putVerticalLine
    
    push dword 1
    push dword 15
    push dword 24
    push dword 255
    push dword [ebp+8]
    call putHorizontalLine
    
    push dword 5
    push dword 20
    push dword 8
    push dword 255
    push dword [ebp+8]
    call putHorizontalLine
    
    push dword 12
    push dword 19
    push dword 4
    push dword 255
    push dword [ebp+8]
    call putVerticalLine
    
    push dword 19
    push dword 19
    push dword 4
    push dword 255
    push dword [ebp+8]
    call putVerticalLine
    
    push dword 24
    push dword 20
    push dword 2
    push dword 255
    push dword [ebp+8]
    call putVerticalLine
    
    push dword 24
    push dword 18
    push dword 14
    push dword 255
    push dword [ebp+8]
    call putHorizontalLine
    
    push dword 37
    push dword 22
    push dword 4
    push dword 255
    push dword [ebp+8]
    call putVerticalLine
    
    push dword 48
    push dword 22
    push dword 5
    push dword 255
    push dword [ebp+8]
    call putVerticalLine
    
    push dword 58
    push dword 22
    push dword 5
    push dword 255
    push dword [ebp+8]
    call putVerticalLine
    
    push dword 68
    push dword 22
    push dword 5
    push dword 255
    push dword [ebp+8]
    call putVerticalLine
    
    push dword 42
    push dword 20
    push dword 5
    push dword 255
    push dword [ebp+8]
    call putVerticalLine
    
    push dword 28
    push dword 15
    push dword 8
    push dword 255
    push dword [ebp+8]
    call putVerticalLine
    
    push dword 29
    push dword 15
    push dword 45
    push dword 255
    push dword [ebp+8]
    call putHorizontalLine
    
    push dword 73
    push dword 14
    push dword 12
    push dword 255
    push dword [ebp+8]
    call putVerticalLine
    
    push dword 37
    push dword 14
    push dword 14
    push dword 255
    push dword [ebp+8]
    call putVerticalLine
    
    push dword 31
    push dword 5
    push dword 6
    push dword 255
    push dword [ebp+8]
    call putHorizontalLine
    
    push dword 31
    push dword 9
    push dword 6
    push dword 255
    push dword [ebp+8]
    call putHorizontalLine
    
    push dword 41
    push dword 3
    push dword 32
    push dword 255
    push dword [ebp+8]
    call putHorizontalLine
    
    push dword 41
    push dword 12
    push dword 23
    push dword 255
    push dword [ebp+8]
    call putHorizontalLine
    
    push dword 41
    push dword 11
    push dword 8
    push dword 255
    push dword [ebp+8]
    call putVerticalLine
    
    push dword 47
    push dword 9
    push dword 6
    push dword 255
    push dword [ebp+8]
    call putVerticalLine
    
    push dword 52
    push dword 11
    push dword 6
    push dword 255
    push dword [ebp+8]
    call putVerticalLine
    
    push dword 58
    push dword 11
    push dword 6
    push dword 255
    push dword [ebp+8]
    call putVerticalLine
    
    push dword 63
    push dword 11
    push dword 6
    push dword 255
    push dword [ebp+8]
    call putVerticalLine
    
    push dword 1
    push dword 1
    push dword [ebp+8]
    call putRandomValues
    
    push dword 254
    push dword 1
    push dword [ebp+8]
    call putRandomValues
      
    pop ebp
ret 4

; void Aleatorio(dword(pointer) tablero, dword numberOfWalls)
global Aleatorio
Aleatorio:
    push ebp
    mov ebp, esp
    
    
    push dword 0
    push dword 0
    push dword 80
    push dword 255
    push dword [ebp+8]
    call putHorizontalLine
    
    push dword 0
    push dword 23
    push dword 80
    push dword 255
    push dword [ebp+8]
    call putHorizontalLine
    
    push dword 0
    push dword 22
    push dword 22
    push dword 255
    push dword [ebp+8]
    call putVerticalLine
    
    push dword 79
    push dword 22
    push dword 22
    push dword 255
    push dword [ebp+8]
    call putVerticalLine
   
    push dword 255
    push dword [ebp+12]
    push dword [ebp+8]
    call putRandomValues
    
    push dword 254
    push dword 1
    push dword [ebp+8]
    call putRandomValues
    
    push dword 1
    push dword 1
    push dword [ebp+8]
    call putRandomValues
     
    pop ebp
ret 8