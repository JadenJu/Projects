@ File:    Lab5.s
@ Author:  Jaden Yu
@ Email: jy0033@uah.edu
@ CS309-01 2023

@  as -o Lab5.o Lab5.s
@  gcc -o Lab5 Lab5.o
@ ./Lab5 ;echo $?
@ gdb --args ./Lab5


.equ READERROR, 0 @Used to check for scanf read error. 

.global main @ Have to use main because of C library uses. 

main:

   ldr r0, =strTitle
   bl printf

   

@*************
initialize_data:
@*************
   
   mov r5, #144		@board 1
   mov r10, #144	@board 2
   mov r11, #144	@board 3
   mov r7, #0		@boards cut
   mov r9, #0   	@lin length
   mov r6, #0		@waste tracker
   b print_info


@*************
prompt:
@*************

   cmp r5, #6		   @ checks if all boards are less than 6 and sends to
   cmple r10, #6	   @ ending if all of them comply
   cmple r11, #6
   ble ending

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
   beq readerror               @ If there was a read error it goes to readerror

   ldr r1, =intInput        @ Have to reload r1 because it gets wiped out. 
   ldr r1, [r1]             @ Read the contents of intInput and store in r1 so that
                            @ it can be printed.
   cmp r1, #6		    @ Check errors for numbers greater than 144 and smaller than 6	
   blt readerror 
   cmp r1, #144
   bgt readerror   

   cmp r5, r1		    @ Checks boards to see if any of them are big enough
   bge cut_boards1
   cmp r10, r1
   bge cut_boards2
   cmp r11, r1
   bge cut_boards3
   
   

   b small_prompt

@***********
cut_boards1:
@***********
   add r7, #1		@ adds to # of boards cut
   sub r5, r1		@ sub value from board
   add r9, r1		@ adds the length cut
   b print_info


@***********
cut_boards2:
@***********
   add r7, #1
   sub r10, r1		@subs value from board 2
   add r9, r1
   b print_info


@***********
cut_boards3:
@***********
   add r7, #1
   sub r11, r1		@subs value from board 3
   add r9, r1
   b print_info
   


@***********
ending:
@***********
   add r6, r5, r10		@adds leftover to waste register
   add r6, r6, r11
   ldr r0, =strTermination
   bl printf
   ldr r0, =strWaste
   mov r1, r6
   bl printf

@**********
myexit:
@**********
   mov r7, #0x01 @ SVC call to exit
   svc 0         @ Make the system call.


@**********
readerror:
@**********

   ldr r0, =strInvalidPrompt @gets address for invalid message
   bl printf
   ldr r0, =strInputPattern
   ldr r1, =strInputError   @ Put address into r1 for read.
   bl scanf                 @ scan the keyboard.

   b prompt

@*********
small_prompt:
@*********
@ message that the input is too big for the current board sizes

   ldr r0, =strTooSmall @gets address for invalid message
   bl printf
   ldr r0, =strInputPattern
   ldr r1, =strInputError   @ Put address into r1 for read.
   bl scanf                 @ scan the keyboard.

   b prompt

@*************
print_info:
@*************

@ prints out the information in the loop
   ldr r0, =strBoardCuts
   mov r1, r7
   bl printf
   ldr r0, =strLinerLength
   mov r1, r9
   bl printf
   ldr r0, =strCurrentBoards
   bl printf
   ldr r0, =strBoardOne
   mov r1, r5
   bl printf
   ldr r0, =strBoardTwo
   mov r1, r10
   bl printf
   ldr r0, =strBoardThree
   mov r1, r11
   bl printf

   b prompt
   
 


.data

@ Declare the strings and data needed

.balign 4
strTitle: .asciz "Cut-It-Up Saw \n"

.balign 4
strBoardCuts: .asciz "Boards cut so far: %d\n"

.balign 4
strLinerLength: .asciz "Liner length of boards cut so far: %d inches\n"

.balign 4
strCurrentBoards: .asciz "Current Board Lengths: \n"

.balign 4
strBoardOne: .asciz "One:    %d \n"

.balign 4
strBoardTwo: .asciz "Two:    %d \n"

.balign 4
strBoardThree: .asciz "Three:  %d \n"

.balign 4
strInputPrompt: .asciz "Enter the length of board to cut in inches (at least 6 and no more than 144): \n"

.balign 4
numInputPattern: .asciz "%d"  @ integer format for read. 

.balign 4
strInputPattern: .asciz "%[^\n]" @ Used to clear the input buffer for invalid input. 

.balign 4
strInputError: .skip 100*4  @ User to clear the input buffer for invalid input.

.balign 4
strTooSmall: .asciz "There are no boards that can cut this board. \n"

.balign 4
intInput: .word 0   @ Location used to store the user input. 

.balign 4
strInvalidPrompt: .asciz "Invalid Input, try again. \n"

.balign 4
strTermination: .asciz "Inventory levels have dropped below minimum levels and will now terminate. \n"

.balign 4
strWaste: .asciz "Waste is %d inches. \n"



