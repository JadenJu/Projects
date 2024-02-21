@ File:    Lab4.s
@ Author:  Jaden Yu
@ Email: jy0033@uah.edu
@ CS309-01 2023

@  as -o Lab4.o Lab4.s
@  gcc -o Lab4 Lab4.o
@ ./Lab4 ;echo $?
@ gdb --args ./Lab4


.equ READERROR, 0 @Used to check for scanf read error. 

.global main @ Have to use main because of C library uses. 

main:

@*************
prompt:
@*************

@ Prompting the user for a number
   ldr r0, =strInputPrompt @ Put the address of my string into the first parameter
   bl  printf              @ Call the C printf to display input prompt. 

@**************
get_int:
@**************
@ Read in number
   ldr r0, =numInputPattern @ Setup to read in one number.
   ldr r1, =intInput        @ load r1 with the address of where the
                            @ input value will be stored. 
   bl  scanf                @ scan the keyboard.
   cmp r0, #READERROR       @ Check for a read error.
   beq myexit               @ If there was a read error exit

   ldr r1, =intInput        @ Have to reload r1 because it gets wiped out. 
   ldr r1, [r1]             @ Read the contents of intInput and store in r1 so that
                            @ it can be printed.  
   ldr r5, =intInput
   ldr r5, [r5]

   cmp r1, #1		    @ Checks for a range between 1-100
   blt myexit		    @ Exits if the input is out of range
   cmp r1, #100
   bgt myexit



@*************
prompt_output:
@*************
   ldr r0, =strUserOutput       @ outputs out the user's number
   bl printf

@*************
even_loop_start:
@*************
   mov r6, #0               @ sum for the even number
   mov r4, #0               @ counter
   cmp r5, #1		    @ checks to see if the input is 1
   bgt check_one            @ takes to checkone to add 2 to r4 and goes back to even_loop

@*************
even_loop:
@*************
@ Start of the loop for the even numbers
   
   mov r1, r4		 @ copies r4 to r1 in order to print out with printf
   ldr r0, =numberOutput  @ gets the address for what is to be output
   bl printf
   ADD r6, r6, r4        @ adds to the sum
   ADD r4, r4, #2	 @ adds to the counter 2
   cmp r4, r5		 @ checks to get out of the loop
   ble even_loop	 @ loops back if the counter is not greater than given number

@************
outputEven:
@************
@prints out the sum
   mov r1, r6            @ moves sum to r1 to print
   ldr r0, =evenSumOutput
   bl printf

@*************
odd_loop_start:
@*************
   mov r6, #0               @ sum for the even number
   mov r4, #1               @ counter

@*************
odd_loop:
@*************
@ Start of the loop for the even numbers
   mov r1, r4		 @ copies r4 to r1 in order to print out with printf
   ldr r0, =numberOutput  @ outputs the number that is being added
   bl printf
   ADD r6, r6, r4        @ adds to the sum
   ADD r4, r4, #2	 @ adds to the counter 2
   cmp r4, r5		 @ checks to get out of the loop
   blt odd_loop	 @ loops back if the counter is not greater than given number

@************
outputOdd:
@************
@prints out the sum

   ldr r0, =oddSumOutput
   mov r1, r6		 @ moves sum to r1 to print
   bl printf


@**********
myexit:
@**********
   mov r7, #0x01 @ SVC call to exit
   svc 0         @ Make the system call.

@**********
check_one:
@**********
   add r4, r4, #2
   b even_loop


.data

@ Declare the strings and data needed

.balign 4
strInputPrompt: .asciz "Input a number between 1-100 number: \n"

.balign 4
numInputPattern: .asciz "%d"  @ integer format for read. 

.balign 4
strInputPattern: .asciz "%[^\n]" @ Used to clear the input buffer for invalid input. 

.balign 4
strInputError: .skip 100*4  @ User to clear the input buffer for invalid input.

.balign 4
intInput: .word 0   @ Location used to store the user input. 

.balign 4
strUserOutput: .asciz "Your number is %d. \n"  @ for printing out user input

.balign 4
numberOutput: .asciz "%d \n"   @for the incrementing number

.balign 4
evenSumOutput: .asciz "The even sum is: %d \n"   @for the sum even

.balign 4
oddSumOutput: .asciz "The even sum is: %d \n"   @for the sum odd

.global printf

.global scanf

