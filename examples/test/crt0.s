#include <kern/mips/regdefs.h>
#include <kern/syscall.h>

.section .text
.global __start
.ent __start
__start:
	la $gp, _gp
	
	li $t0, 0xfffffff8
	and $sp, $sp, $t0			/* align the stack */
	addiu $sp, $sp, -16		/* create our frame */

	jal main	/* call main */
	nop		/* delay slot */

	move $s0, $v0
1:

	b 1b
	nop
.end __start
