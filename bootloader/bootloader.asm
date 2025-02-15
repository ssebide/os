; A simple bootloader
bits 16

start:
    jmp boot                ; Jump to the boot label

; constant and variable definitions
msg db "Welcome to my Operating system", 0ah, 0dh, 0h

boot:
    cli                     ; Disable interrupts
    cld                     ; Clear direction flag

    mov ax, 50h

    ;; set the buffer
    mov es, ax
    xor bx, bx

    mov al, 2 ; read 2 sector
    mov ch, 0 ; we are reading the second sector past us,  

    mov cl, 2 ; sector to read (The second sector)
    mov dh, 0 ; head number
    mov dl, 0 ; drive number. Remember Drive 0 is floppy drive 

    mov ah, 0x02 ; read floppy sector function
    int 0x13 ; call BIOS - Read the sector
    jmp [500h + 18h] ; jump and execute the sector!

    htl ;halt the system

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
