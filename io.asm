; io.asm - I/O related routines

section .data
    cursor_y db 0  ; Variable to store Y position of the cursor
    cursor_x db 0  ; Variable to store X position of the cursor

section .text
    global MovCursor, PutChar, Print

; MovCursor
; Purpose: Move cursor to the specific (X, Y) position and save it
; Parameters:
;     bh = Y coordinate (row)
;     bl = X coordinate (column)
; Return: None
MovCursor:
    ; Move the cursor to the specified position using BIOS interrupt 0x10
    mov ah, 0x02       ; BIOS function to move cursor
    mov dl, bl         ; Set X coordinate (DL = X)
    mov dh, bh         ; Set Y coordinate (DH = Y)
    int 0x10           ; Call BIOS interrupt 0x10 to move the cursor

    ; Save the cursor position for future reference
    mov [cursor_x], bl ; Save X coordinate to cursor_x
    mov [cursor_y], bh ; Save Y coordinate to cursor_y

    ret                 ; Return to caller


; PutChar
; Purpose: Print a character on screen at the cursor position
; Parameters:
;     al = Character to print
;     bl = Text color
;     cx = Number of times the character is repeated
; Return: None
PutChar:
    ; Set the color for the text
    mov ah, 0x09       ; BIOS function for printing a character
    mov bh, 0x00       ; Page number (0 = primary page)
    mov dl, bl         ; Text color (passed in bl)
    mov al, al         ; Character to print (passed in al)
    mov cx, cx         ; Repeat count (passed in cx)
    int 0x10           ; Call BIOS interrupt 0x10 to print character

    ret                 ; Return to caller


; Print
; Purpose: Print a null-terminated string
; Parameters:
;     ds:si = Pointer to the string (null-terminated)
; Return: None
Print:
    ; Loop through the string until a null terminator is found
    .print_loop:
        mov al, [si]      ; Load the current character into al
        cmp al, 0         ; Check if it's the null terminator
        je .done          ; If it's null, we've reached the end of the string
        call PutChar      ; Call PutChar to print the character
        inc si            ; Move to the next character in the string
        jmp .print_loop   ; Repeat the loop

    .done:
        ret                ; Return to caller
