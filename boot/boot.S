.code16
_fix : 
	jmp $0x7C0,$(_init - _fix)
_init:
	xor %bp,%bp
	movw %bp, %ds #zero the data segment
	movw $0,%ax
	call _error
	hlt
_error:
	xor %bp,%bp
	movw %bp,%es #zero the extended segment, just in case
	movw $4, %bp
	mul %bp
	add error_str_table, %ax
	movw %ax, %bp
	add $2, %ax
	movw %ax, %cx
	movb $0x1, %al
	movb $0x13, %ah
	movb $0x34, %bl
	movb $0, %bh
	movw $0x0707, %dx
	int $0x10 
	ret

error_str_table:
	.word ram_avail_err
	.word ram_avail_err_end - ram_avail_err

ram_avail_err : .asciz "Could not get available RAM"
ram_avail_err_end :

.fill (510 - (. - _fix)),1,0
.word 0xaa55
