.code16
_fix : 
	jmp $0x7C0,$(_init - _fix)
_init:
	movw $0, %ax
	movw %ax , %ds
	movb $0x1, %al
	movb $0x13, %ah
	movb $0x34, %bl
	movb $0, %bh
	movw $(str_end - str_begin), %cx
	movw $0x0707, %dx
	movw $0, %bp
	movw %bp, %es
	movw $str_begin, %bp
	int $0x10 
	hlt

str_begin : .asciz "Hello World!"
str_end : .byte 0x0

.fill (510 - (. - _fix)),1,0
.word 0xaa55
