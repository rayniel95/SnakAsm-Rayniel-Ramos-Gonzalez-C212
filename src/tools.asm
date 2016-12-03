section .text

extern delay

; void addNumberToArray(dword (pointer) array, dword number, dword length)
global addNumberToArray
addNumberToArray:
    push ebx
    push eax
    push ebp
    mov ebp, esp
    
    push dword [ebp+24]
    push dword [ebp+16]
    call arrayMin
    
    mov ebx, [ebp+20]
    
    cmp [eax], ebx
    jae final16
    
    mov [eax], ebx
    
    final16:
    pop ebp
    pop eax
    pop ebx
ret 12

; pointer arrayMin(dword (pointer) array, dword length)
; dado un puntero a array, y la longitud se encarga de darte un puntero en el eax al menor elemento del array,
; asumo que el array es de dword
global arrayMin
arrayMin:
    pushfd
    push ebx
    push edi
    push esi
    push ecx
    push ebp
    mov ebp, esp
    
    mov edi, [ebp+28]; se copia el puntero para esi, edi
    mov esi, [ebp+28]
    
    xor ecx, ecx
    
    while17:
        add esi, ecx
        mov ebx, [esi]; se aumenta el esi, y se compara con lo del edi, si lo del esi es mayor se pasa para el edi
        cmp ebx, [edi]; asi hasta terminar el array, luego paso para el eax lo del edi
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
; para probar algunas cosas
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