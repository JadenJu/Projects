@ File:    Lab1.s
@ Author:  Jaden Yu
@ Email: jy0033@uah.edu
@ CS309-01 2024

@  as -o Lab1.o Lab1.s
@  gcc -o Lab1 Lab1.o
@ ./Lab1 ;echo $?
@ gdb --args ./Lab1


.equ READERROR, 0 @Used to check for scanf read error. 

.global main @ Have to use main because of C library uses. 

main:
@ Intro
   ldr r0, =strTitle
   bl printf

@ Read in number
@**********
prompt:
   @ Prompting the user for a number
   ldr r0, =strInputPrompt
   bl printf
   
   mov r4, #10		    @ counter for loop
   ldr r5, =array2	    @ address for the array

@***********
inputLoop:

   ldr r0, =numInputPattern @ Setup to read in one number.
   ldr r1, =intInput        @ load r1 with the address of where the
                            @ input value will be stored. 
   bl  scanf                @ scan the keyboard.
   cmp r0, #READERROR       @ Check for a read error.
   beq readerror               @ If there was a read error it goes to readerror

   ldr r1, =intInput        @ Have to reload r1 because it gets wiped out.
   ldr r1, [r1]
 
   str r1, [r5], #4             @ writes the contents of r1 into array
   subs r4, r4, #1               @ decrements loop counter
   bne inputLoop

   mov r4, #10		    @ loop counter
	
   
   ldr r5, =array1	    @ address for the arrays   
   ldr r9, [r5]
   ldr r6, =array2	
   ldr r10, [r6]    
   ldr r7, =array3   

@**********
multiplyArray:
   mul r8, r9, r10	    @ multiplies both array1 and array two to a blank register
   str r8, [r7], #4		    @ stores the product into array3
   add r5, r5, #4	    @ increments array1 and 2
   ldr r9, [r5]
   add r6, r6, #4
   ldr r10, [r6]   
   subs r4, #1		    @ decrements counter and set flags
   bne multiplyArray
   
@**********
printing:

   ldr r7, =array1	    @ loads array address to register
   bl printArray	    @ goes to subroutine
   ldr r7, =array2
   push {lr}
   bl printArray
   ldr r7, =array3
   push {lr}
   bl printArray


@*********
myexit:
   mov r7, #0x01 @ SVC call to exit
   svc 0         @ Make the system call.

@**********
readerror:

   ldr r0, =strInvalidPrompt @gets address for invalid message
   bl printf
   ldr r0, =strInputPattern
   ldr r1, =strInputError   @ Put address into r1 for read.
   bl scanf                 @ scan the keyboard.

   b prompt

@**********
printArray:

   mov r9, #10
   push {lr}		    @ stores lr to main memory to return back
   ldr r0, =strArrayPrompt	@ loads prompt to print
   bl printf

@**********
printLoop:
   
   ldr r0, =strArrayOutput 	@ loads address to print integers
   ldr r1, [r7], #4		@ increments to the next number
   bl printf
   subs r9, #1			@ decrements counter
   bne printLoop
   pop {pc}			@ returns to main program	
   

.data

.balign 4
strTitle: .asciz "Hello, this program contains two arrays that are multiplied at the end with the results in a new array.\n"

.balign 4
strInputPrompt: .asciz "Enter 10 integers: \n"

.balign 4
strInputError: .skip 100*4  @ User to clear the input buffer for invalid input.

.balign 4
strInvalidPrompt: .asciz "Invalid Input, try again. \n"

.balign 4
strInputPattern: .asciz "%[^\n]" @ Used to clear the input buffer for invalid input. 

.balign 4
strArrayOutput: .asciz "%d \n"

.balign 4
strArrayPrompt: .asciz "Printing the array... \n"

.balign 4
numInputPattern: .asciz "%d"  @ integer format for read. 

.balign 4
intInput: .word 0   @ Location used to store the user input. 

.balign 4
array1: .word 10, 9, 8, 7, 6, 5, 4, 3, 2, -1

.balign 4
array2: .skip 4*10

.balign 4
array3: .skip 4*10

