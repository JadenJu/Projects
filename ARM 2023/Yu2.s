@ Filename: Yu2.s
@ Author:   Jaden Yu
@ Purpose:  Show CS309 and CS413 students how to read user inputs from
@           the keyboard. Students are expected to learn ARM assembly in
@           these courses not obscure details about C printf and scanf.
@           In most cases it should be assumed the user provided a valid
@           input. 
@ Email: jy0033@uah.edu
@ CS309-01 2023 
@
@ History: 
@    Date       Purpose of change
@    ----       ----------------- 
@   4-Jul-2019  Changed this code from using the stack pointer to a 
@               locally declared variable. 
@  15-Sep-2019  Moved some code around to make it clearer on how to 
@               get the input value into a register. 
@   1-Oct-2019  Added code to check for user input errors from the 
@               scanf call.   
@  21-Feb-2019  Added comments about "%c" vs " %c" related to scanf.
@
@ Use these commands to assemble, link, run and debug this program:
@    as -o Yu2.o Yu2.s
@    gcc -o Yu2 Yu2.o
@    ./Yu2 ;echo $?
@    gdb --args ./Yu2

@ ***********************************************************************
@ The = (equal sign) is used in the ARM Assembler to get the address of a
@ label declared in the .data section. This takes the place of the ADR
@ instruction used in the textbook. 
@ ***********************************************************************

.equ READERROR, 0 @Used to check for scanf read error. 

.global main @ Have to use main because of C library uses. 

main:

@*******************
prompt:
@*******************

@ Ask the user to enter a number.
 
   ldr r0, =strInputPrompt @ Put the address of my string into the first parameter
   bl  printf              @ Call the C printf to display input prompt. 

@*******************
get_input:
@*******************

@ Set up r0 with the address of input pattern.
@ scanf puts the input value at the address stored in r1. We are going
@ to use the address for our declared variable in the data section - intInput. 
@ After the call to scanf the input is at the address pointed to by r1 which 
@ in this case will be intInput. 

   ldr r0, =numInputPattern @ Setup to read in one number.
   ldr r1, =intInput        @ load r1 with the address of where the
                            @ input value will be stored. 
   bl  scanf                @ scan the keyboard.
   cmp r0, #READERROR       @ Check for a read error.
   beq readerror            @ If there was a read error go handle it. 
   ldr r1, =intInput        @ Have to reload r1 because it gets wiped out. 
   ldr r1, [r1]             @ Read the contents of intInput and store in r1 so that
                            @ it can be printed. 

@ Print the input out as a number.
@ r1 contains the value input to keyboard. 

   ldr r0, =strOutputNum
   bl  printf


@start of student code
@asking for input
   ldr r0, =strInputPromptC @ Put the address of my string into the first parameter
   bl  printf              @ Call the C printf to display input prompt.

 
   ldr r0, =charInputPattern @ Setup to read in one char.
   ldr r1, =charInput        @ load r1 with the address of where the
                            @ input value will be stored. 
   bl  scanf                @ scan the keyboard.
   cmp r0, #READERROR       @ Check for a read error.
   beq readerror            @ If there was a read error go handle it. 
   ldr r1, =charInput        @ Have to reload r1 because it gets wiped out. 
   ldr r1, [r1]             @ Read the contents of intInput and store in r1 so that
                            @ it can be printed. 

   ldr r0, =strOutputChar
   bl  printf


   b   myexit @ leave the code. 

@***********
readerror:
@***********
@ Got a read error from the scanf routine. Clear out the input buffer then
@ branch back for the user to enter a value. 
@ Since an invalid entry was made we now have to clear out the input buffer by
@ reading with this format %[^\n] which will read the buffer until the user 
@ presses the CR. 

   ldr r0, =strInputPattern
   ldr r1, =strInputError   @ Put address into r1 for read.
   bl scanf                 @ scan the keyboard.
@  Not going to do anything with the input. This just cleans up the input buffer.  
@  The input buffer should now be clear so get another input.

   b prompt

@*******************
myexit:
@*******************
@ End of my code. Force the exit and return control to OS

   mov r7, #0x01 @ SVC call to exit
   svc 0         @ Make the system call. 

.data

@ Declare the strings and data needed

.balign 4
strInputPrompt: .asciz "Input the number: \n"

.balign 4
strInputPromptC: .asciz "Input the character: \n"

.balign 4
strOutputNum: .asciz "The number value is: %d \n"

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
strOutputChar: .asciz "The character is: %c \n"

.balign 4
charInputPattern: .asciz " %c"  @ integer format for read. 

.balign 4
charInput: .word 0   @ Location used to store the user input. 


@ Let the assembler know these are the C library functions. 

.global printf
@  To use printf:
@     r0 - Contains the starting address of the string to be printed. The string
@          must conform to the C coding standards.
@     r1 - If the string contains an output parameter i.e., %d, %c, etc. register
@          r1 must contain the value to be printed. 
@ When the call returns registers: r0, r1, r2, r3 and r12 are changed. 

.global scanf
@  To use scanf:
@      r0 - Contains the address of the input format string used to read the user
@           input value. In this example it is numInputPattern.  
@      r1 - Must contain the address where the input value is going to be stored.
@           In this example memory location intInput declared in the .data section
@           is being used.  
@ When the call returns registers: r0, r1, r2, r3 and r12 are changed.
@ Important Notes about scanf:
@   If the user entered an input that does NOT conform to the input pattern, 
@   then register r0 will contain a 0. If it is a valid format
@   then r0 will contain a 1. The input buffer will NOT be cleared of the invalid
@   input so that needs to be cleared out before attempting anything else.
@
@ Additional notes about scanf and the input patterns:
@    1. If the pattern is %s or %c it is not possible for the user input to generate
@       and error code. Anything that can be typed by the user on the keyboard
@       will be accepted by these two input patterns. 
@    2. If the pattern is %d and the user input 12.123 scanf will accept the 12 as
@       valid input and leave the .123 in the input buffer. 
@    3. If the pattern is "%c" any white space characters are left in the input
@       buffer. In most cases user entered carrage return remains in the input buffer
@       and if you do another scanf with "%c" the carrage return will be returned. 
@       To ignore these "white" characters use " $c" as the input pattern. This will
@       ignore any of these non-printing characters the user may have entered.
@

@ End of code and end of file. Leave a blank line after this.
