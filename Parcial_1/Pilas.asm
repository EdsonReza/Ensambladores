data segment
    pkey db 13, 10,"Presione una tecla para continuar...$"
    mensaje_menu db 13,10,'Menú!', 13, 10, '1. Agregar', 13, 10, '2. Eliminar', 13, 10, 'Otro. Salir', 13, 10, 13, 10, 'Elija una opción: $'
    pila db 10 dup(' ')
    agregado db 13, 10,"Escribe$",13, 10
    eliminado db 13, 10,"Escribe$",13, 10
ends

stack segment
    dw 128 dup(0)
ends

; La impresion de texto como un macro
print macro value
    lea dx, value
    mov ah, 9
    int 21h
endm

push_array macro value
    mov ah, 01h
    int 21h
    sub al, 30h
    ; Opera con al
    
endm

code segment
    ; set segment registers:
    mov ax, data
    mov ds, ax
    mov es, ax
    
    ;Inicia el indice para el arreglo
    mov si, offset pila ; Apunta al principio
    mov cx, 0 ;usando cx como el indice
 
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
    mov cx, 0
    imprimir_caracteres:
        mov dl, [si] ; Cargar el carácter en DL
        mov ah, 02h ; Subfunción para imprimir un carácter
        int 21h ; Imprimir el carácter
        mov dl, 0Ah ; Carácter de salto de línea
        mov ah, 02h ; Subfunción para imprimir el salto de línea
        int 21h ; Imprimir el salto de línea
        inc si ; Apuntar al siguiente carácter en la cadena
        inc cx ; Incrementa el contador
        cmp cx, 10
        jne imprimir_caracteres ; Repetir hasta el final de la cadena
    mov si,0
    ret    
print_array endp

pop_array proc
    
pop_array endp