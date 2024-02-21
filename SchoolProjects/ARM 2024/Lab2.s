@ File:    Lab2.s
@ Author:  Jaden Yu
@ Email: jy0033@uah.edu
@ CS309-01 2024
@ Purpose: 4 function calculator that calculates based on 2 integers

@  as -o Lab2.o Lab2.s
@  gcc -o Lab2 Lab2.o
@ ./Lab2 ;echo $?
@ gdb --args ./Lab1


.equ READERROR, 0 @Used to check for scanf read error. 

.global main @ Have to use main because of C library uses. 

main:
@Intro
   ldr r0, =strTitle	@intro to the prompt, tells valid inputs
   bl printf
   
@**********
promptC:
   @ Prompting the user for a operation
   ldr r0, =strInstructionsSign		@prompts for user's desired operation
   bl printf
   

@***********
inputSign:

   ldr r0, =charInputPattern @ Setup to read in one number.
   ldr r1, =charInput        @ load r1 with the address of where the

   bl  scanf                @ scan the keyboard. 
                            @ input value will be stored.

   ldr r1, =charInput        @ Have to reload r1 because it gets wiped out.
   ldr r5, [r1]


   cmp r5, #'*'      	   @error checking for chars other than the four operations
   blt readerrorC 
   cmp r5, #'/'      	    @first two check the range
   bgt readerrorC
   cmp r5, #'.'      	    
   beq readerrorC
   cmp r5, #','      	  @last two check for symbols in the range
   beq readerrorC       

   mov r4, #2		 @ loop counter for 2 inputs      

@**********
promptI:
   @ Prompting the user for a number
   ldr r0, =strInstructionNum
   bl printf

inputInt:

   ldr r0, =numInputPattern @ Setup to read in one number.
   ldr r1, =intInput        @ load r1 with the address of where the
                            @ input value will be stored. 
   bl  scanf                @ scan the keyboard.
   cmp r0, #READERROR       @ Check for a read error.
   beq readerrorI               @ If there was a read error it goes to readerror

   ldr r1, =intInput        @ Have to reload r1 because it gets wiped out.
   ldr r1, [r1]

   cmp r1, #0			@checks if numbers are positive zero
   blt readerrorI
   

   push {r1}			@ push input into the stack
   
   subs r4, #1			@ counter decrement
   bgt promptI			@ return to loop

   ldr r0, =strResult		@ sets up for print and also is used to check for overflow

@subroutines
   cmp r5, #'+'      	   
   bleq addition  
   cmp r5, #'-'      	    
   bleq subtraction
   cmp r5, #'*'      	    
   bleq multiplication
   cmp r5, #'/'      	  
   bleq division
   cmp r5, #'/'  
   beq printD       

@**********
print:
   bl printf
   ldr r0, =strOutput
   pop {r1}			@pops result
   bl printf
   
   b loopPrompt

@**********
printD:
   ldr r0, =strOutputD
   pop {r6}			@pops remainder
   pop {r1}			@pops quotient
   bl printf
   mov r1, r6
   ldr r0, =strOutputDq
   bl printf
    
@*********
loopPrompt:

   ldr r0, =strInstructionsLoop
   bl printf

   ldr r0, =charInputPattern @ Setup to read in one number.
   ldr r1, =charInput        @ load r1 with the address of where the
                            @ input value will be stored. 
   bl  scanf                @ scan the keyboard.

   ldr r1, =charInput        @ Have to reload r1 because it gets wiped out.
   ldr r1, [r1]

   cmp r1, #'y'
   beq promptC

@*********
myexit:
   mov r7, #0x01 @ SVC call to exit
   svc 0         @ Make the system call.    
    
@**********
readerrorC:

   ldr r0, =strInvalidPrompt @gets address for invalid message
   bl printf
   ldr r0, =strInputPattern
   ldr r1, =strInputError   @ Put address into r1 for read.
   bl scanf                 @ scan the keyboard.

   b promptC

@**********
readerrorI:

   ldr r0, =strInvalidPrompt @gets address for invalid message
   bl printf
   ldr r0, =strInputPattern
   ldr r1, =strInputError   @ Put address into r1 for read.
   bl scanf                 @ scan the keyboard.

   b promptI       
    
@ SUBROUTINES
@***********
addition:
   pop {r7,r8}			@pops out operands from the stack
   adds r9, r7, r8
   movvs r9, #0			@changes result if overflow flag is set
   pushvs {r9}			@pushes 0
   ldrvs r0, =strOverflow	@gets overload message
   pushvc {r9}
   mov pc, lr			@return
@***********
@***********
subtraction:
   pop {r7,r8}			@pops operands
   subs r9, r8, r7
   push {r9}			@pushes result
   mov pc, lr
@***********
@***********
multiplication:
   pop {r7,r8}			@pops operadnds
   umulls r9, r10, r8, r7	@r9 gets result and r10 gets overflow
   cmp r10, #0			@checks for overflow
   movne r9, #0			@sets r9 to 0
   pushne {r9}			@pushes 0
   ldrne r0, =strOverflow	@gets overflow message
   pusheq {r9}			@pushes result if no overflow
   mov pc, lr			@return
@***********
@***********
division:
   pop {r7}			@pops divisor
   cmp r7, #0			@checks if divisor is 0
   ble readerrorI		@goes to readerror and gets new divisor
   pop {r8}			@after divisor is good pops out dividend
   mov r9, #0			@sets up counter for quotient

loopD:
   cmp r8, r7			@checks if division is possible
   subge r8, r8, r7		@division takes place
   addge r9, #1
   bge loopD			@loops back if needed
   push {r8, r9}		@ pushes the quotient then the remainder.
   mov pc, lr			@return
@***********
   



.data

.balign 4
strTitle: .asciz "Hello, this program is a 4 function calculator where the user chooses the operation and 2 positive (including 0) integers.\n"

.balign 4
strInstructionsSign: .asciz "Please Enter an operation (+, -, *, /): \n"

.balign 4
strInstructionNum: .asciz "Please Enter a number (when dividing start with the dividend and end with the divisor): \n"

.balign 4
charInputPattern: .asciz " %c"  @ integer format for read. 

.balign 4
charInput: .word 0 

.balign 4
numInputPattern: .asciz "%d"  @ integer format for read. 

.balign 4
intInput: .word 0   @ Location used to store the user input. 

.balign 4
strInputError: .skip 100*4  @ User to clear the input buffer for invalid input.

.balign 4
strInvalidPrompt: .asciz "Invalid Input, try again. \n"

.balign 4
strInputPattern: .asciz "%[^\n]" @ Used to clear the input buffer for invalid input. 
    
.balign 4
strOutput: .asciz "Your output was %d. \n"
    
.balign 4
strOutputD: .asciz "Your quotient was %d "

.balign 4
strOutputDq: .asciz "with a remainder %d. \n"
    
.balign 4
strInstructionsLoop: .asciz "Would you like to continue (y: yes or any key to quit): \n"

.balign 4
strOverflow: .asciz "Overflow reported. \n"

.balign 4
strResult: .asciz "Result: \n"
