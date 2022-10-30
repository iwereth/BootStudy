.code16
#assumption is made that the 0x500-x0x7BFF is not being used by the BIOS
#Documented use of memory locations:
#memory 0x500-0x503 used by _error
#memory 0x504-0x510 used by print_num

_init:
	jmp $0x0, $_actual_init #make sure CS is zero
_actual_init:
	xor %ax, %ax
	movw %ax, %ds  #making sure DS is zero
	clc
	int $0x12
	jnc _mem_check_done
	movw $0, %ax
	call _err_halt
_mem_check_done:
	call print_num
	call _halt
_err_halt:
	call _error
_halt:
	jmp _halt
_error:
	movw $4, %bx
	mul %bx
	movw %ax, %bx
	add $error_str_table, %bx
	movw (%bx), %ax
	add $2, %bx
	movw (%bx), %bx
	jmp print_str

print_str:
	movw %ax, 0x500  #address of the string
	movw %bx, 0x502  #size of string
	movb $0, %bh
	movb $0x03, %ah
	int $0x10
	movb $0, %dl
	add $1, %dh
	movb $0x1, %al
	movb $0x13, %ah
	movb $0, %bh
	movb $1, %bl
	movw 0x502(,1), %cx
	movw 0x500(,1), %bp
	int $0x10
	ret
print_num:
	movw $0x510, %di
	movb $10, %dl
_print_num:
	div %dl
	movb %ah,(%di)
	add $0x30, (%di)
	sub $1, %di
	movb $0,%ah
	and %al, %al
	jnz _print_num
	movw $0x510, %bx
	sub %di, %bx
	add $1, %di
	movw %di, %ax
	jmp print_str

error_str_table:
	.word ram_avail_err
	.word ram_avail_err_end - ram_avail_err

ram_avail_err : .ascii "Could not get available RAM"
ram_avail_err_end :

.fill (510 - (. - _init)),1,0
.word 0xaa55
