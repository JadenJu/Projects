@ File:    helloworld.s
@ Author:  Jaden Yu
@ Purpose: Provide enough assembly to allow students to complete an assignment. 
@ History: 
@    04-Mar-2019 Added comments to help with printf and svc calls.
@    15-Sep-2019 Added comments on which registers are changed
@           when there is a call to printf or SVC.
@
@ Use these commands to assemble, link, run and debug the program
@
@  as -o helloworld.o helloworld.s
@  gcc -o helloworld helloworld.o
@ ./helloworld ;echo $?
@ gdb --args ./helloworld
@
@ If you get an error from the as (assembler) command AND it does not call out a line
@ number, check to make sure the current default directory contains the file.
@
@ If your codes executes with no errors but your string is not printing then
@ you have forgotten the end your string with \n. 
@

@ ************
@ The = (equal sign) is used in the ARM Assembler to get the address of a
@ label declared in the .data section. This takes the place of the ADR
@ instruction used in the textbook. 
@ ************

.global main 
main:        @Must use this label where to start executing the code. 

@ Part 1 - Print hello world message using the system call.
@
@ Use system call to write string to the STDIO
@   r0 - Must contain 1 to output to the standard output device (screen).
@   r1 - Must contain the starting address of the string to be printed. The string
@        has to comply with C coding standards. The string must be declared as a
@        .asciz so that it termimates with a \0 (null) character. 
@   r2 - Length of the string to be printed.
@   r7 - Must contain a 4 to write. 

    MOV   r7, #0x04    @ A 4 is a write command and has to be in r7.
    MOV   r0, #0x01    @ 01 is the STD (standard) output device. 
    MOV   r2, #0x0C    @ Length of string to print (in Hex).
    LDR   r1, =string1 @ Put address of the start of the string in r1
    SVC   0            @ Do the system call

@ When using this method to print to the screen none of the registers
@ (r0 - r15) are changed. 

@ Part 2 - Print hello world message using the C function printf
@
@ Use the C library call printf to print the second string. Details on 
@ how to use this function is given in the .data section. 
@
@   r0 - Must contain the starting address of the string to be printed. 
@
    LDR  r0, =string2 @ Put address of string in r0
    BL   printf       @ Make the call to printf

@ Force the exit of this program and return command to OS.

    MOV  r7, #0X01
    SVC  0

@ Declare the stings

.data       @ Lets the OS know it is OK to write to this area of memory. 
.balign 4   @ Force a word boundry.
string1: .asciz "Hello World\n"  @Length 0x0C

.balign 4   @ Force a word boundry
string2: .asciz "Hello World.\n" @Length 0x0E

.global printf
@  To use printf:
@     r0 - Contains the starting address of the string to be printed. The string
@          must conform to the C coding standards.
@     r1 - If the string contains an output parameter i.e., %d, %c, etc. register
@          r1 must contain the value to be printed. 
@ When the call returns registers: r0, r1, r2, r3 and r12 are changed. 

@end of code and end of file. Leave a blank line after this. 
