/*
 * taylor.s
 *
 *  Created on: Nov 23, 2020
 *      Author: Sanjana Madhu
 */

 .text
 .global main
 .extern printf

main:
 	add x6, xzr, xzr
 	add x6, x6, #1
 	scvtf d0, x6 //initializes register that will hold the answer in register d0 to 1
	ldr x4, =n //x4 holds the address of the data in n
	ldr x1, [x4] //x1 now holds the value of n
	ldr x4, =x //x4 holds the address of the data in x
	ldr d2, [x4] //d2 now holds the value of x
	sub sp, sp, #48 //subtract space on stack
	str d2, [sp, #40] //store x
	str x1, [sp, #32] //store n
	str d0, [sp, #24] //store answer
  	str x30, [sp, #16] //store return address

loop:
	cbz x1, end //checks if the value of n is 0; if so, branch to end label
	str x30, [sp, #8] //if not, store the link register
	bl calc

loop_call:
	ldr x30, [sp, #8] //loads the link register
	b loop //calls func

calc:
	add x19, xzr, xzr
	add x19, x19, #1 //x19 initialized to 1, used for factorial calculation
	scvtf d20, x6 //d20 initialized to 1, used to hold value for x^n
	mov x2, x1 //moves value of n into x2, dummy value

fact:
	mul x19, x19, x2 //x19 will hold n!
	fmul d20, d20, d2 ///d20 will hold value of x^n
	sub x2, x2, #1 // decrements n
	subs x5, x2, #0 //checks if n = 0
	b.ne fact //if n != 0, then proceed to calculating the polynomial term

calc_term:
	add x7, xzr, xzr
 	add x7, x7, #1 //x7 initialized to 1
 	scvtf d7, x7
 	scvtf d10, x19 //d10 hold n!
	fdiv d9, d7, d10 //divides factorial value by 1
	fmul d9, d9, d20 //multiplies by x value
	fadd d0, d0, d9 //adds back to the final answer
	sub x1, x1, #1 //decrements true value of n
	br x30

end:
	ldr x0, =ptr_str //loads ascii representation of string
	sub sp, sp, #48  //subtract space on stack
	str d2, [sp, 40] //store x
	str x1, [sp, 32] //store n
	str d0, [sp, 24] //store answer
	str x30, [sp, 16]
	bl printf //prints out string
	ldr d2, [sp, 40] //load x
	ldr x1, [sp, 32] //load n
	ldr d0, [sp, 24] //load answer
	ldr x30, [sp, 64]
 	add sp, sp, #48 //add space back onto stack
	br x30


 .data
 n:
 .quad 2
 x:
 .double 6.3
 ptr_str:
 .ascii "The approximation is %f\n"

 .end
