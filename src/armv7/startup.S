/*
 * YaBL startup code for AM33XX ARMv7 Cortex-A8 CPU core
 * 
 * Author: Sarbojit Ganguly (unixman.linuxboy@gmail.com)
 * FIXME: Include GPL licence declaration here
 */

#include <asm/system.h>

/* Tell the assembler to assemble the following statements
   at the end of the text subsection. */
.text

/* select the 32 bit ARM instruction set (16 selects THUMB). The 
   ARM core starts execution in ARM mode. */
.code 32

/* Tell the linker that we want this to be visible across */
.global _start

/* Vector Table: used only very briefly till memory relocation */
.func

_start:
	b	reset
	ldr	pc, _undefined_instruction
	ldr	pc, _software_interrupt
	ldr	pc, _prefetch_abort
	ldr	pc, _data_abort
	ldr	pc, _not_used
	ldr	pc, _irq
	ldr	pc, _fiq

_undefined_instruction:	.word _undefined_instruction
_software_interrupt:	.word _software_interrupt
_prefetch_abort:	.word _prefetch_abort
_data_abort:		.word _data_abort
_not_used:		.word _not_used
_irq:			.word _irq
_fiq:			.word _fiq

/* byte align: this code will tell the location counter to pad n bytes 
 * and the fill pattern */
/* FIXME: MORE INFORMATION IS NEEDED */
.balignl 16,0xdeadbeef

/* The text base */
.global _TEXT_BASE 
_TEXT_BASE:	.word 0x80800000


/************************************************
 *              The Reset Vector		*
 ************************************************/
reset:
	
	/* set the CPU to SVC32 mode; for SVC32 CPSR = 10011 [M0-M4 bits]
	 * mrs and msr are used to copy CPSR/SPSR to general purpose
	 * registers and back again.
	 */
	
	mrs	r0, cpsr	/* move cpsr to a general purpose register */	
	bic	r0, r0 #0x1f	/* bit clear for first 5 bits */
	orr	r0, r0 #0xd3	/* SVC32 mode with IRQ/FIQ disabled */
	msr	cpsr, r0	/* write back the cpsr */

	/* set up the vector table
	 * this has to be done by clearing the bits of control register
         * c1 of CP15 co processor and set the vector address in 
	 * c12 of CP15.
	 */

	/* mrc is used to move co-processor registers to ARM and
   	 * mcr is used to ARM registers to co-processor.
	 */	 

	mrc	p15, 0, r0, c1, c0, 0	/* read CP15 CTRL register */
	bic	r0, #CR_VECTORS		/* vector table bit cleared */
	mcr	p15, 0, r0, c1, c0, 0	/* write CP15 CTRL register */
	
	/*
	 *	mrc p15, 0, r0, c1, c0, 0
	 *
	 *	p15 = coproc
	 *	0   = opcode_1
	 *	r0  = destination ARM register
	 *	c1  = CRn
	 *	c0  = CRm
	 *	0   = optional coproc specific opcode
 	 *
	 *	the instruction means:
	 *	in cp15 co processor, read c1 register with optional register c0
	 *	with opcode_1=0 and opcode_2=0 and
	 *	send its content to r0 of ARM
	 */

	/* Now that V bit = 0 for Control register, normal exeception vectors
	 * are selected. V=1 means high value exeption vections ranging from
	 * 0xFFFF0000 to 0xFFFF001C
	 * We need to write our vector table (_start) address in co processor's
	 * Vector Base Address Register (VBAR) so that for now core will branch
	 * there in case of any exception
	 */
	ldr r0, =_start
	mcr p15, 0, r0, c12, c0, 0

