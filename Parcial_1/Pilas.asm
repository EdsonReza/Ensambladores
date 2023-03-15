data segment
    pkey db 13,10,"Presione una tecla para continuar...$"
    mensaje_menu db 13,10,'Menú', 13, 10, '1. Agregar un elemento', 13, 10, '2. Remover el ultimo elemento', 13, 10, 'Otro. Salir', 13, 10, 13, 10, 'Elija una opción: $'
    pila db (10) dup(' ') ;Se llena de espacios
    agregado db 13, 10,"Escribe el caracter: $"
    eliminado db 13, 10,"Escribe$",13, 10
    lleno db 13,10,"La pila esta llena$",13,10
    salto db 13,10,"$"
ends

stack segment
    dw 256 dup(0)
ends

; La impresion de texto como un macro
print macro value
    lea dx, value
    mov ah, 9
    int 21h
endm

code segment
    ; set segment registers:
    mov ax, data
    mov ds, ax
    mov es, ax
    
    ;Inicia el indice para el arreglo
    mov ch, 0 ;usando ch como el indice donde se encuentra el ultimo elemento
 
    Menu:
        call clear
        call print_array
        print mensaje_menu
        ;Lee el caracter
        mov ah, 01h
        int 21h
        sub al, 30h
        ;Compara y salta a la opcion seleccionada
        cmp al, 1
        je Agregar
        cmp al, 2
        je Remover
    
    Salir:        
        call presskey
        mov ax, 4c00h ; exit to operating system.
        int 21h         
   
    Agregar:
        print agregado
        call push_array
        call presskey
        jmp Menu
    
    Remover:
        print eliminado
        call presskey
        jmp Menu
 
        
ends

; Proceso para limpiar la pantalla             
clear proc
    mov ah, 0Fh
    int 10h
    mov ah, 0
    int 10h
    ret
clear endp

; Espera a que se presione una tecla
presskey proc
    print pkey
    mov ah, 0
    int 16h     
    ret 
presskey endp

print_array proc
    mov cl, 0
    mov si, offset pila ; Apunta al principio de la pila
    imprimir_caracteres:
        mov dl, [si] ; Cargar el carácter en DL
        mov ah, 02h ; Subfunción para imprimir un carácter
        int 21h ; Imprimir el carácter
        print salto
        inc si ; Apuntar al siguiente carácter en la cadena
        inc cl ; Incrementa el contador
        cmp cl, 10
        jne imprimir_caracteres ; Repetir hasta el final de la cadena
    mov si,offset pila
    ret    
print_array endp


pop_array proc
    
pop_array endp  


push_array proc
    cmp ch, 10
    je Fin_Push
    
    mov ah, 01h
    int 21h
    ; Opera con al
    mov si, offset pila ; Apunta al principio
    mov cl, 0
    Recorrer:
        cmp cl, ch
        je Continuar_Push
        inc si
        inc cl
        jmp Recorrer 
    
    Continuar_Push:
        mov [si], al
        inc ch
        ret
    
    Fin_Push:
        print lleno    
    ret
push_array endp