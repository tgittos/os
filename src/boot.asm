; A 512-byte boot sector

	BITS 16

start:
	mov ax, 07C0h		; Set up a 4096kb stack space after this bootloader
	add ax, 288		; (4096 + 512) / 16 bytes per paragraph
	mov ss, ax		; SS is stack segment?
	mov sp, 4096		; SP is stack pointer

	mov ax, 07C0h		; Set data segment to where we're loaded
	mov ds, ax		; DS is data segment

	mov si, text_string	; Put string location in SI
	call print_string	; Call our string printing routine
	
	jmp $			; Jump here - infinite loop

	text_string db 'Hello world!', 0

; Print string routine
print_string:
	mov ah, 0Eh		; int 10h, 'print char' function
.repeat:
	lodsb			; Load string byte - retrieves a byte from the location pointed to by SI
	cmp al, 0		; Compare char to 0
	je .done		; If it's 0, skip to done (end of string)
	int 10h			; Else, print it
	jmp .repeat
.done:
	ret

; Finish up
	times 510-($-$$) db 0	; Pad remainder of sector with 0s
	dw 0xAA55		; PC boot signature
