@ File:    Yu1.s
@ Author:  Jaden Yu
@ Email: jy0033@uah.edu
@ CS309-01 2024

@  as -o Yu1.o Yu1.s
@  gcc -o Yu1 Yu1.o
@ ./Yu1 ;echo $?
@ gdb --args ./Yu1


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

   ldr r0, =numInputPattern @ Setup to read in one number.
   ldr r1, =intInput        @ load r1 with the address of where the
                            @ input value will be stored. 
   bl  scanf                @ scan the keyboard.
   cmp r0, #READERROR       @ Check for a read error.
   beq readerror               @ If there was a read error it goes to readerror

   ldr r1, =intInput        @ Have to reload r1 because it gets wiped out. 
   ldr r1, [r1]             @ Read the contents of intInput and store in r1 so that
                            @ it can be printed.
   cmp r1, #10		    @ checks if what is enetered is greater than less than the given range
   bgt readerror
   cmp r1, #0
   blt readerror

   mov r4, r1		    @ moves the data to another register to avoid the registers changing by printf
   mov r5, #0		    @ loads in counter
   
@*********start of loop   
loop:
   cmp r4, r5
   beq myexit
   ldr r0, = strHelloWorld  @ loads "Hello World" to printf later in the loop
   bl printf
   add r5, #1
   b loop
   
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


.data

@ Declare the strings and data needed

.balign 4
strTitle: .asciz "Hello, enter any number 0-10 and Hello World will be printed that many times\n"

.balign 4
strInputPrompt: .asciz "Enter a number 0-10: \n"

.balign 4
numInputPattern: .asciz "%d"  @ integer format for read. 

.balign 4
intInput: .word 0   @ Location used to store the user input. 

.balign 4
strHelloWorld: .asciz "Hello World!\n"

.balign 4
strInputError: .skip 100*4  @ User to clear the input buffer for invalid input.

.balign 4
strInvalidPrompt: .asciz "Invalid Input, try again. \n"

.balign 4
strInputPattern: .asciz "%[^\n]" @ Used to clear the input buffer for invalid input. 
