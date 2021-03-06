ORIGFUNC= ${.PREFIX:S/^compat//}
RENAMEDFUNC=${.PREFIX:S/^compat__//:C/([0-9]{2})$//}
.if (${MACHINE_ARCH} == "i386")
FUNCTYPE= @function
PICJMP= jmpl *PIC_PLT(${ORIGFUNC})
JMP= jmp ${ORIGFUNC}
.elif (${MACHINE_ARCH} == "arm")
FUNCTYPE= %%function
PICJMP= bl PIC_SYM(${ORIGFUNC}, PLT)
JMP= b ${ORIGFUNC}
.endif

${ASM}:
	${_MKTARGET_CREATE}
	printf '/* MINIX3 */							\n\
/* 										\n\
* Compatibility jump table for renamed symbols. 				\n\
*										\n\
* DO NOT EDIT: this file is automatically generated.				\n\
*/										\n\
#include <machine/asm.h>							\n\
.global ${RENAMEDFUNC};								\n\
.global ${ORIGFUNC};								\n\
.type ${RENAMEDFUNC},${FUNCTYPE}						\n\
${RENAMEDFUNC}:									\n\
#ifdef PIC									\n\
${PICJMP}									\n\
#else										\n\
${JMP}										\n\
#endif										\n\
\n ' >${.TARGET}

