#ifndef _ASM_SYSTEM_H_
#define _ASM_SYSTEM_H_

/* Control Register (CR1) bits of CP15 co processor in ARMv7.
 * This is written keeping Cortex-A8 TRM as reference. 
 * Section 3.2.25 c1, Control Register
 */


#define CR_MMU		(1 << 0)	/* MMU enabled */
#define CR_ALGN		(1 << 1)	/* Strict alignment fault checking*/
#define CR_DCACHE	(1 << 2)	/* Enable data cache */
#define CR_VECTORS	(1 << 13)	/* Vectors relocated to 0xffff0000 */

#endif
