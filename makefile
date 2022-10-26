ASFLAGS = -mx86-used-note=no
LDFLAGS = --oformat binary -Ttext=0x7c00
SRCPATH = boot/
BINPATH = bin/
OBJPATH = out/

${BINPATH}boot.bin : ${OBJPATH}boot.out
	mkdir -p ${BINPATH}
	ld $(LDFLAGS) -o ${BINPATH}boot.bin ${OBJPATH}boot.out
${OBJPATH}boot.out : ${SRCPATH}boot.S
	mkdir -p ${OBJPATH}
	as $(ASFLAGS) -o ${OBJPATH}boot.out ${SRCPATH}boot.S

clean : ${BINPATH}boot.bin 
	rm -r ${OBJPATH}
