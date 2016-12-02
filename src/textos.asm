section .text

extern drawText

; void lastMessagge()
global lastMessagge
lastMessagge:
    push ebp
    mov ebp, esp
    
    push dword 15
    push dword 0
    push dword 27
    push dword 15
    push dword 'r'
    push dword 'e'
    push dword 'v'
    push dword 'O'
    push dword ' '
    push dword 'e'
    push dword 'm'
    push dword 'a'
    push dword 'G'
    push dword 9
    call drawText
    add esp, 56
    
    push dword 15
    push dword 0
    push dword 20
    push dword 20
    push dword 'r'
    push dword 'a'
    push dword 'z'
    push dword 'e'
    push dword 'p'
    push dword 'm'
    push dword 'e'
    push dword ' '
    push dword 'a'
    push dword ' '
    push dword 'r'
    push dword 'e'
    push dword 'v'
    push dword 'l'
    push dword 'o'
    push dword 'v'
    push dword ' '
    push dword 'a'
    push dword 'r'
    push dword 'a'
    push dword 'p'
    push dword ' '
    push dword 'r'
    push dword 'e'
    push dword 't'
    push dword 'n'
    push dword 'E'
    push dword 27
    call drawText
    add esp, 128
    
    pop ebp
ret

; void instruction()
global instruction
instruction:
    push ebp
    mov ebp, esp
    
    push dword 15
    push dword 0
    push dword 3
    push dword 0
    push dword 'o'
    push dword 'j'
    push dword 'a'
    push dword 'b'
    push dword 'a'
    push dword ' '
    push dword 'y'
    push dword ' '
    push dword 'a'
    push dword 'b'
    push dword 'i'
    push dword 'r'
    push dword 'r'
    push dword 'a'
    push dword ' '
    push dword 's'
    push dword 'a'
    push dword 'l'
    push dword 'c'
    push dword 'e'
    push dword 't'
    push dword ' '
    push dword 's'
    push dword 'a'
    push dword 'l'
    push dword ' '
    push dword 'e'
    push dword 's'
    push dword 'U'
    push dword 29
    call drawText
    add esp, 136
    
    pop ebp
ret

global menuDiff  
menuDiff:
    push ebp
    mov ebp, esp
    
    push dword 15
    push dword 0
    push dword 27
    push dword 15
    push dword ':'
    push dword ')'
    push dword 'o'
    push dword 'i'
    push dword 'c'
    push dword 'a'
    push dword 'p'
    push dword 's'
    push dword 'e'
    push dword ' '
    push dword 'e'
    push dword 's'
    push dword 'u'
    push dword '('
    push dword ' '
    push dword 'd'
    push dword 'a'
    push dword 't'
    push dword 'l'
    push dword 'u'
    push dword 'c'
    push dword 'i'
    push dword 'f'
    push dword 'i'
    push dword 'd'
    push dword ' '
    push dword 'e'
    push dword 'n'
    push dword 'o'
    push dword 'i'
    push dword 'c'
    push dword 'c'
    push dword 'e'
    push dword 'l'
    push dword 'e'
    push dword 'S'
    push dword 36
    call drawText
    mov esp, ebp
    
    push dword 15
    push dword 0
    push dword 30
    push dword 17
    push dword 'o'
    push dword 'n'
    push dword 'a'
    push dword 's'
    push dword 'u'
    push dword 'G'
    push dword 6
    call drawText
    mov esp, ebp
    
    push dword 15
    push dword 0
    push dword 30
    push dword 18
    push dword 'z'
    push dword 'i'
    push dword 'r'
    push dword 'b'
    push dword 'm'
    push dword 'o'
    push dword 'L'
    push dword 7
    call drawText
    mov esp, ebp
    
    push dword 15
    push dword 0
    push dword 30
    push dword 19
    push dword 'e'
    push dword 't'
    push dword 'n'
    push dword 'e'
    push dword 'i'
    push dword 'p'
    push dword 'r'
    push dword 'e'
    push dword 'S'
    push dword 9
    call drawText
    mov esp, ebp
        
    push dword 15
    push dword 0
    push dword 30
    push dword 20
    push dword 's'
    push dword 'e'
    push dword 't'
    push dword 'e'
    push dword 'h'
    push dword 'o'
    push dword 'c'
    push dword ' '
    push dword 'n'
    push dword 'o'
    push dword 'c'
    push dword ' '
    push dword 'e'
    push dword 't'
    push dword 'n'
    push dword 'e'
    push dword 'i'
    push dword 'p'
    push dword 'r'
    push dword 'e'
    push dword 'S'
    push dword 21
    call drawText
    mov esp, ebp
        
    push dword 15
    push dword 0
    push dword 30
    push dword 21
    push dword 'e'
    push dword 'k'
    push dword 'a'
    push dword 'n'
    push dword 'S'
    push dword 'h'
    push dword 's'
    push dword 'a'
    push dword 'l'
    push dword 'F'
    push dword 10
    call drawText
    mov esp, ebp  
    
    pop ebp 
ret 

global menuMap   
menuMap:
    push ebp
    mov ebp, esp
    
    push dword 15
    push dword 0
    push dword 27
    push dword 15
    push dword ':'
    push dword ')'
    push dword 'r'
    push dword 'e'
    push dword 't'
    push dword 'n'
    push dword 'e'
    push dword ' '
    push dword 'e'
    push dword 's'
    push dword 'u'
    push dword '('
    push dword ' '
    push dword 'a'
    push dword 'p'
    push dword 'a'
    push dword 'm'
    push dword ' '
    push dword 'e'
    push dword 'n'
    push dword 'o'
    push dword 'i'
    push dword 'c'
    push dword 'c'
    push dword 'e'
    push dword 'l'
    push dword 'e'
    push dword 'S'
    push dword 28
    call drawText
    mov esp, ebp
    
    push dword 15
    push dword 0
    push dword 30
    push dword 17
    push dword 'a'
    push dword 'd'
    push dword 'i'
    push dword 't'
    push dword 'r'
    push dword 'a'
    push dword 't'
    push dword 'n'
    push dword 'A'
    push dword 9
    call drawText
    mov esp, ebp
    
    push dword 15
    push dword 0
    push dword 30
    push dword 18
    push dword 'o'
    push dword 'n'
    push dword 'i'
    push dword 'l'
    push dword 'a'
    push dword 'r'
    push dword 'o'
    push dword 'C'
    push dword ' '
    push dword 'e'
    push dword 'f'
    push dword 'i'
    push dword 'c'
    push dword 'e'
    push dword 'r'
    push dword 'r'
    push dword 'A'
    push dword 17
    call drawText
    mov esp, ebp
    
    push dword 15
    push dword 0
    push dword 30
    push dword 19
    push dword 's'
    push dword 'a'
    push dword 'n'
    push dword 'o'
    push dword 'z'
    push dword 'a'
    push dword 'm'
    push dword 'A'
    push dword 8
    call drawText
    mov esp, ebp
        
    push dword 15
    push dword 0
    push dword 30
    push dword 20
    push dword 'a'
    push dword 'n'
    push dword 'u'
    push dword 'l'
    push dword ' '
    push dword 'a'
    push dword 'L'
    push dword 7
    call drawText
    mov esp, ebp
        
    push dword 15
    push dword 0
    push dword 30
    push dword 21
    push dword 'o'
    push dword 'i'
    push dword 'r'
    push dword 'o'
    push dword 't'
    push dword 'a'
    push dword 'e'
    push dword 'l'
    push dword 'A'
    push dword 9
    call drawText
    mov esp, ebp  
    
    pop ebp 
ret 