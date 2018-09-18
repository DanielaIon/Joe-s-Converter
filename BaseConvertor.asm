%include "io.inc"

section .data
    %include "input.inc"
    number db "1111111 1111111 1111111 111111 "

section .text
global CMAIN

;Functia afiseaza un numar stocat sub forma unui sir de caractere 
;Numarul este primit in ordine inversa si afisat in ordinea corecta
print_number:
    push ebp
    mov ebp, esp
    
    ;se muta in registrul eax numarul ce se doreste a fi afisat
    mov eax, dword [ebp+8]
    mov ecx, 0  
    
;Calculeaza lungimea unui sir
find_length:
    mov bl, byte [eax + ecx]
    ;Daca s-a gasit caracterul ce indica finalul sirului se iese 
    ;din bucla de calculare a lungimii si se incepe afisarea
    cmp bl,0
    je print_byte
    ;Daca nu s-a ajuns la final se incrementeaza numarul de
    ;numere gasite si se continua cautarea caracterului final
    inc ecx
    jmp find_length

;Afiseaza fiecare byte ce compune sirul in ordine inversa
print_byte:
    mov bl, byte[eax +(ecx-1)]
    PRINT_CHAR bl
    loop print_byte
       
    NEWLINE
    leave
    ret
     
    
;Converteste un numar dat intr-o baza data
convert_number:
    push ebp
    mov ebp, esp
    
   ;numarul  ce trebuie convertit
    mov eax, dword [ebp+8]
    
   ;baza in care trebuie convertit
    mov ebx, dword [ebp+12]  
    mov ecx,0
    
    ;executa impartiri repetate pentru a efectua conversia
    ; din baza 10 intr-o baza data
divide:   
    mov edx,0  
    div ebx
    
    ;In cazul in care catul este format dintro singura cifra 
    ; se trece la pasul urmator 
    cmp dl,10
    jl next
    ;Daca este format din 2 cifre catul, pe langa 48 care urmeaza 
    ; a fi adaugat pentru a se stoca in sir caracterul corespunzator 
    ; cifrei obtinute in cazul in care numarul este format dintr-o 
    ; singura cifra , se mai adauga 39 pentru a fi stocata litera 
    ; corespunzatoare numerelor din intervalul [10,15]
    add edx,39
    
    ;Se adauga 48 la numarul initial pentru a fi stocat in sir
    ; caracterul corespunzator numarului obtinut 
next:
    add edx,48
    mov byte[number + ecx], dl
    
    ;Se trece la obtinerea urmatoarei cifre
    inc ecx
    ;Se verifica daca mai se pot obtine cifre
    cmp eax,0
    jne divide
    
    ;Se adauga un caracter terminator la sfarsitul sirului pentru
    ; a indica finalul sirului de caractere ce contine numarul 
    ; convertit stocat in ordine inversa
    mov byte[number + ecx],0
    leave
    ret
    
;functia principala a programului   
CMAIN:
    push ebp
    mov ebp, esp

    mov ecx,0
repeat:
    ;Stochez ecx pe stiva ca in cazul modificarii sale in cadrul 
    ;functiei convert_number sa nu existe probleme cu contorul
    push ecx
    
    ;Verific daca baza este valida,adica daca apartine intervalul [2,16]
    ;Daca nu apartine sar direct la mesajul de eroare
    cmp dword [base_array +4*ecx],2
    jl error
    cmp dword [base_array +4*ecx],16
    jg error
    
    ;Aflare numar in baza data
    push dword [base_array +4*ecx]
    push dword [nums_array +4*ecx]
    call convert_number
    add esp,8
    
    ;Afisare numar convertit
    push number
    call print_number
    add esp,4
    
    ;Se sare la instructiunile finale
    jmp final
    
    ;Afisare mesaj in cazul in care baza este incorecta
error:
    PRINT_STRING "Baza incorecta"
    NEWLINE
    
    ;Se scoate ecx de pe stiva , se incrementeaza
    ;Daca nu s-au verificat toate numerele ce se doresc 
    ; a fi convertite, se va repeta pasul efectuat
final:   
    pop ecx
    inc ecx
    cmp ecx,dword [nums]
    jl repeat
       
    leave
    ret
