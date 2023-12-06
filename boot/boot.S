.code16
#assumption is made that the 0x500-x0x7BFF is not being used by the BIOS
#Documented use of memory locations:
#memory 0x500-0x503 used by _error
#memory 0x504-0x509 used by print_num

#############
#main routine
############

_init:
	jmp $0x0, $_actual_init #make sure CS is zero

_actual_init:
	xor %ax, %ax
	movw %ax, %ds  #making sure DS is zero
	movw %ax, %ss
	movw $0x7c00, %bp
	clc
	int $0x12
	jnc _mem_check_done
	movw $0, %ax
	call _err_halt

_mem_check_done:
	push %ax
	movw $ram_avail_str, %ax
	movw $(ram_avail_str_end - ram_avail_str), %bx
	movw $0,%dx
	call print_str
	pop %ax
	movw $0, %dx
	call print_num
	movb $0x41, %ah
	movw $0x55AA, %bx
	movb $0x80, %dl
	clc
	int $0x13
	jc _halt
	movw $1, %ax

_err_halt:
	call _error
_halt:
	jmp _halt


######################
#end of main routine
######################


################
#error output %ax = error code (0 for not being able to get free RAM)
################
_error:
	push %dx
	movw $4, %bx
	mul %bx
	movw %ax, %bx
	add $error_str_table, %bx
	movw (%bx), %ax
	add $2, %bx
	movw (%bx), %bx
	pop %dx
	jmp print_str


##############
#print string, %ax = pointer to string, %bx = counts of characters
#dx = 0 implies no newline should be printed after string
##############

print_str:
	movw %ax, 0x500  #address of the string
	movw %bx, 0x502  #size of string
	movb $0, %bh
	movb $0x03, %ah
	test %dx, %dx
	jnz _newline
	int $0x10
	jmp _print_now
_newline:
	int $0x10
	movb $0, %dl
	add $1, %dh
_print_now:
	movb $0x1, %al
	movb $0x13, %ah
	movb $0, %bh
	movb $7, %bl
	movw 0x502(,1), %cx
	movw 0x500(,1), %bp
	int $0x10
	ret


################
#print number %ax = the number to print %dx = 0 , don't prepend newline
################
print_num:
	push %dx
	movw $0x509, %di
	movb $10, %dl
_print_num:
	div %dl
	movb %ah,(%di)
	add $0x30, (%di)
	sub $1, %di
	movb $0,%ah
	and %al, %al
	jnz _print_num
	movw $0x509, %bx
	sub %di, %bx
	add $1, %di
	movw %di, %ax
	pop %dx
	jmp print_str

error_str_table:
	.word ram_avail_err
	.word ram_avail_err_end - ram_avail_err
	.word ext_mode_err
	.word ext_mode_err_end - ext_mode_err
ram_avail_str: .ascii "RAM available is (in KBs) " 
ram_avail_str_end:
ram_avail_err: .ascii "Could not get available RAM"
ram_avail_err_end:
ext_mode_err: .ascii "Extension not available"
ext_mode_err_end:

.fill (510 - (. - _init)),1,0
.word 0xaa55
