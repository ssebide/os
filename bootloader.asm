; A simple bootloader

org 0x7c00
bits 16

start:
    jmp boot                ; Jump to the boot label

; Initialize cursor position to (5, 5)
mov bh, 5                  ; Y coordinate (row)
mov bl, 5                  ; X coordinate (column)
call MovCursor             ; Move cursor to (5, 5)

; Print a welcome message
mov si, msg                ; Point to the string
call Print                 ; Print the string

hlt                         ; Halt the system

; constant and variable definitions
msg db "Welcome to my Operating system", 0ah, 0dh, 0h

boot:
    cli                     ; Disable interrupts
    cld                     ; Clear direction flag
    hlt                     ; Halt the system

; MovCursor procedure - Moves the cursor to the position (bh, bl)
MovCursor:
    ; Inputs: bh = row (Y coordinate), bl = column (X coordinate)
    mov ah, 0x02            ; Function code for setting cursor position
    int 0x10                ; BIOS interrupt to set the cursor position
    ret

; Print procedure - Prints a string at the current cursor position
Print:
    ; Inputs: ds:si = Zero-terminated string
    .print_loop:
        lodsb                ; Load next byte from string (AL = current character)
        or al, al            ; Check if it's the null terminator (0)
        jz .done             ; If it's null, we're done
        mov ah, 0x0e         ; BIOS teletype output function
        int 0x10             ; BIOS interrupt to print the character
        jmp .print_loop      ; Continue printing next character

    .done:
        ret

; We have to be 512 bytes. Clear the rest of the bytes with 0
times 510 - ($-$$) db 0
dw 0xAA55                   ; Boot signature

; Compile and load
; nasm -f bin bootloader.asm -o bootloader.bin

; Then we create a 1.4mb floppy disk
; dd if=/dev/zero of=disk.img bs=512 count=2880

; Then we write the bootloader to the first sector
; dd conv=notrunc if=bootloader of=disk.img bs=512 count=1 seek=0

; Create a machine emulator
; qemu-system-i386 -machine q35 -fda disk.img -gdb tcp::26000 -S

;start gdb
;gdb

; Set the architecture
; set architecture i8086

; Then, connect gdb to the waiting virtual machine with this command
; target remote localhost:26000

; Then, place a breakpoint at 0x7c00
; b *0x7c00

; Then, for convenience, we use a split layout for viewing the assembly code and registers together:
; layout asm, layout reg, c
