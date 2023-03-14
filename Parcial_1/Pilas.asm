data segment
    pkey db 13, 10,"Presione una tecla para continuar...$"
    mensaje_menu db 'Bienvenido al menú!', 13, 10, '1. Opción 1', 13, 10, '2. Opción 2', 13, 10, '3. Salir', 13, 10, 13, 10, 'Elija una opción: $'
    pila db 10 dup('$')
    agregado db 13, 10,"Agregando$",13, 10
    eliminado db 13, 10,"Eliminado$",13, 10,
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

    ; add your code here
    Menu:
        call clear
        print mensaje_menu
        mov ah, 01h
        int 21h
        sub al, 30h
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

presskey proc
    print pkey
    mov ah, 0    ; Selecciona el subcódigo 00h de la función 16h del BIOS
    int 16h      ; Espera a que se presione una tecla
    ret 
presskey endp