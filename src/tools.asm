section .text

extern delay

; void addNumberToArray(dword (pointer) array, dword number, dword length)
global addNumberToArray
addNumberToArray:
    push esi
    push ecx
    push ebp
    mov ebp, esp
    
    mov esi, [ebp+16]
    xor ecx, ecx
    
    while16:
        add esi, ecx
        cmp byte [esi], 0
        jne continueWhile16
        mov cl, [ebp+20]
        mov [esi], cl
        jmp endWhile16
        continueWhile16:
        inc ecx
        mov esi, [ebp+16]
        cmp ecx, [ebp+24]
        je endWhile16
    jmp while16
    endWhile16:
    
    pop esi
    pop ecx
    pop ebp
ret 12

; pointer arrayMin(dword (pointer) array, dword length)
global arrayMin
arrayMin:
    pushfd
    push ebx
    push edi
    push esi
    push ecx
    push ebp
    mov ebp, esp
    
    mov edi, [ebp+28]
    mov esi, [ebp+28]
    
    xor ecx, ecx
    
    while17:
        add esi, ecx
        mov ebx, [esi]
        cmp ebx, [edi]
        jae continueWhile17
        mov edi, esi
        continueWhile17:
        mov esi, [ebp+28]
        add ecx, 4
        cmp ecx, [ebp+32]
        je endWhile17
    jmp while17
    endWhile17:
    mov eax, edi
    pop ebp
    pop ecx
    pop esi
    pop edi
    pop ebx
    popfd
ret 8

; void sleep(dword ms)
sleep:
    push eax
    push dword 0
    push dword 0
    push ebp
    mov ebp, esp
    
    xor eax, eax
    
    while15:
        mov eax, ebp
        add eax, 4
        
        push dword [ebp+20]
        push eax
        call delay
        
        cmp eax, 0
    je while15
    
    pop ebp
    pop eax
    pop eax
    pop eax
ret 4