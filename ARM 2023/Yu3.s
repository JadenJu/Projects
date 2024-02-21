@ File:    Yu1.s
@ Author:  Jaden Yu
@ Email: jy0033@uah.edu
@ CS309-01 2023

@  as -o Yu3.o Yu3.s
@  gcc -o Yu3 Yu3.o
@ ./Yu3 ;echo $?
@ gdb --args ./Yu3


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
   beq readerror            @ If there was a read error go handle it. 
   ldr r1, =intInput        @ Have to reload r1 because it gets wiped out. 
   ldr r1, [r1]             @ Read the contents of intInput and store in r1 so that
                            @ it can be printed. 

@check if < 100
@********
compare:
@********

CMP r1, #100
BGE printIG
   b printLG

@**********
printIG:
@**********
   ldr r0, =strOutputGre
   bl  printf
   b promptC

printLG:
   ldr r0, =strOutputLes
   bl  printf
   b promptC



@asking for char

@**********
promptC:
@**********
   ldr r0, =strInputPromptC @ Put the address of my string into the first parameter
   bl  printf              @ Call the C printf to display input prompt.

@**************
get_char:
@**************
   ldr r0, =charInputPattern @ Setup to read in one char.
   ldr r1, =charInput        @ load r1 with the address of where the
                            @ input value will be stored. 
   bl  scanf                @ scan the keyboard.
   cmp r0, #READERROR       @ Check for a read error.
   beq readerror            @ If there was a read error go handle it. 
   ldr r1, =charInput        @ Have to reload r1 because it gets wiped out. 
   ldr r1, [r1]             @ Read the contents of intInput and store in r1 so that
                            @ it can be printed. 

@check
checkLow:
CMP r1, #'a'
BLT checkUpper
    b checkLowZ

checkUpper:
CMP r1, #'A'
BGE checkUpZ
    b printSpecial

checkUpZ:
CMP r1, #'Z'
BLE printUpper
    b printSpecial

checkLowZ:
CMP r1, #'z'
BLE printLow
    b printSpecial

@**********
printLow:
@**********
   ldr r0, =strOutputLow
   bl  printf

   b myexit

  
@**********
printUpper:
@**********
   ldr r0, =strOutputUpper
   bl  printf

   b myexit


@**********
printSpecial:
@**********
   ldr r0, =strOutputSpecial
   bl  printf

   b myexit

@**********
readerror:
@**********

   ldr r0, =strInputPattern
   ldr r1, =strInputError   @ Put address into r1 for read.
   bl scanf                 @ scan the keyboard.

   b prompt

@**********
myexit:
@**********
   mov r7, #0x01 @ SVC call to exit
   svc 0         @ Make the system call.







.data

@ Declare the strings and data needed

.balign 4
strInputPrompt: .asciz "Input the number: \n"

.balign 4
strInputPromptC: .asciz "Input the character: \n"

.balign 4
strOutputLes: .asciz "The number value is less than 100 \n"

.balign 4
strOutputGre: .asciz "The number value is greater or equal to 100 \n"

@ Format pattern for scanf call.

.balign 4
numInputPattern: .asciz "%d"  @ integer format for read. 

.balign 4
strInputPattern: .asciz "%[^\n]" @ Used to clear the input buffer for invalid input. 

.balign 4
strInputError: .skip 100*4  @ User to clear the input buffer for invalid input. 

.balign 4
intInput: .word 0   @ Location used to store the user input. 

.balign 4
strOutputLow: .asciz "Lower case letter entered. \n"

.balign 4
strOutputUpper: .asciz "Upper case letter entered. \n"

.balign 4
strOutputSpecial: .asciz "Special character entered. \n"

.balign 4
charInputPattern: .asciz " %c"  @ integer format for read. 

.balign 4
charInput: .word 0   @ Location used to store the user input.

.global printf

.global scanf

