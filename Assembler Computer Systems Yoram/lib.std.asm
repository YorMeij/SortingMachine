; Standard library
;
; Standard functions and device specific constants for using the PP2.

@DATA
					; R0 :	null register
					; R1 :	general purpose
					; R2 : 	general purpose
					; R3 :	general purpose
					; R4 :	temporary register
					; R5 :	base frame pointer
					; R6 :	global base pointer
					; R7 :	stack pointer

					; I/O-register addresses
					MEMSIZE		EQU		-1		; size of available memory
					DISPATCH	EQU		-2		; dispatch flag
					TIMER		EQU		-3		; system timer
					OVL			EQU		-4		; overload flags
					OUTPUT		EQU		-5		; 8 power outputs
					LEDS		EQU		-6		; 3 LEDs
					DIGIT		EQU		-7		; display digit
					SEGMENT		EQU		-8		; display pattern
					INPUT		EQU		-9		; 8 buttons
					ADCONVS		EQU		-10		; 2 AD converters
					RXDATA		EQU		-11		; serial input data
					RXSTATE		EQU		-12		; serial input state
					TXDATA		EQU		-13		; serial output data
					TXSTATE		EQU		-14		; serial output state
					BAUDSEL		EQU		-15		; serial bit rate
					SWITCHES	EQU		-16		; 3 slide switches
					
				INTERRUPT_TIMER EQU		8		; interrupt when timer < 0
					
					CS			DS		1		; code segment
		
@CODE
					; initialize registers and skip to main
					LOAD		R0		0
					STOR		R5		[GB+CS]
					LOAD		R5		SP
					BRA			main
		
; namespace : system
; function 	: wait (n)
; doc		: halts execution for n steps

; OPTIMIZED
system.wait :		; reset timer to avoid timer underflow
					LOAD		R4		0			;
					SUB			R4		[R0+TIMER]	;
					STOR		R4		[R0+TIMER]	;
					
					; set delay
					LOAD		R4		[SP+1]		; delay by n steps	
					STOR		R4		[R0+TIMER]	;			
		
					; loop until n steps have passed
system.wait_l :		LOAD		R4		[R0+TIMER]	;
					CMP			R4		0			;
					BLT			system.wait_l		;

					; return
					PULL		R4					;		
					ADD			SP		1			; pop 1 argument
					JMP			R4					;				
; end				
	
; namespace : system
; function 	: interrupt (n, instruction)
; doc		: enables interrupt n

system.interrupt :	PUSH 		R5 					;
					LOAD 		R5		SP			;
					SUB			SP		1			; allocate 1 local variable (handler)
										
					; calculate handler address
					LOAD		R4		[R5+2]		;
					MULS		R4		2			;
					STOR		R4		[R5+-1]		;
					
					; calculate absolute instruction address
					LOAD		R4		[R5+3]		;
					ADD			R4		[GB+CS]		;
					
					; set handler
					PUSH		R1					; evil
					LOAD		R1		[R5+-1]		;
					STOR		R4		[R1+0]		;	
					STOR		R0		[R1+1]		;
					PULL		R1					;
					
					; enable interrupt
					LOAD		R4		[R5+2]		;
					SETI 		R4					;

					; return
					LOAD 		SP		R5			;
					PULL		R5					;
					PULL		R4					;
					ADD			SP		1			; pop 2 arguments
					JMP			R4					;			
; end		

		
; namespace : input
; function 	: pressed (n, prev) boolean
; doc		: returns true if button n has been pressed, false otherwise
		
; OPTIMIZED	- HAX WITH STAX
input.pressed:		PUSH 		R5 					;
					LOAD 		R5		SP			;
					
					; set bool
					LOAD		R4		0			; false
					PUSH		R4		
					
					; set msk
					LOAD  		R4		[R5+2]		; arg1 := n
					PUSH R4							;
					LOAD		R4		2			; arg0 := 2
					PUSH R4							;
					BRS			math.power			; call math.power			
					
					; check button was not pressed
					LOAD		R4		[R5+3]		; R1 := prev
					AND			R4		[SP]		; apply bitmask	to R1
					CMP			R4		[SP]		; test if button was pressed
					BEQ			input.pressed_r		; return false if button was pressed

					; check button is pressed
					LOAD		R4		[R0+INPUT]	; R2 := arg0
					AND			R4		[SP]		; apply bitmask	to R2
					CMP			R4		[SP]		; test if button is pressed
					BNE			input.pressed_r		; return false if button is not pressed

					; set bool
					ADD			SP		2			; pop 2 local variables
					LOAD		R4		1			; true
					PUSH		R4

					; return
input.pressed_r :	LOAD		R4		[R5+-1]		; 
					STOR		R4		[R5+3]		; return bool	
					LOAD 		SP		R5			;
					PULL		R5					;
					PULL		R4					;
					ADD			SP		1			; pop 1 argument (save return)
					JMP			R4					;				
; end
						

	
; namespace	: math
; function	: power (base, n) int
; doc		: computes base^n
	
; OPTIMIZED		
math.power :		PUSH 		R5 					;
					LOAD 		R5		SP			;
					SUB			SP		2			; allocate 2 local variables (i, result)
				
					; set i := n
					LOAD		R4		[R5+3]		;
					STOR		R4		[R5+-1]		;
					
					; set result := 1
					LOAD		R4		1			; (n^0)
					STOR		R4		[R5+-2]		; 
						
					; loop for n times
math.power_l :		LOAD		R4		[R5+-1]		; i
					CMP			R4		0			;
					BEQ			math.power_r		;		
					SUB			R4		1			; decrement i
					STOR		R4		[R5+-1]		;
					LOAD		R4		[R5+-2]		;
					MULS		R4		[R5+2]		; multiply result by base
					STOR		R4		[R5+-2]		;
					BRA			math.power_l		;
				
					; return
math.power_r :		LOAD		R4		[R5+-2]		;
					STOR		R4		[R5+3]		;
					LOAD 		SP		R5			;
					PULL		R5					;
					PULL		R4					;
					ADD			SP		1			; pop 1 argument (save return)
					JMP			R4					;
; end

	
	
; namespace : util
; function	: convert (number) binary
; doc		:

; OPTIMIZED
util.convert :		BRS		util.convert_m		; push address(switch) onto stack

					; constants
util.convert_s :	CONS	%01111110			; 7-segment pattern for '0'
					CONS	%00110000			; 7-segment pattern for '1'
					CONS	%01101101			; 7-segments pattern for '2'
					CONS	%01111001			; 7-segment pattern for '3'
					CONS	%00110011			; 7-segment pattern for '4'
					CONS	%01011011			; 7-segment pattern for '5'
					CONS	%01011111			; 7-segment pattern for '6'
					CONS	%01110000			; 7-segment pattern for '7'
					CONS	%01111111			; 7-segment pattern for '8'
					CONS	%01111011			; 7-segment pattern for '9'
					CONS	%01110111			; 7-segment pattern for 'A'
					CONS	%00011111			; 7-segment pattern for 'b'
					CONS	%01001110			; 7-segment pattern for 'C'
					CONS	%00111101			; 7-segment pattern for 'd'
					CONS	%01001111			; 7-segment pattern for 'E'
					CONS	%01000111			; 7-segment pattern for 'F'

					; switch (number)
util.convert_m :	PULL	R4					; R4 := address(switch) (retrieve from stack)
					ADD		R4		[SP+1]		; R4 += number
					LOAD	R4		[R4]		; R4 := switch(number)
				
					; return
					STOR	R4		[SP+1]		; return switch(number)
					PULL	R4					;
					JMP		R4					;
; end

; namespace : util
; function	: numeral (number, n) int
; doc		: get nth numeral of number
				
; OPTIMIZED - HaX w1Th StaX
util.numeral :	; call function power
				LOAD		R4		[SP+2]		; arg1 := n	
				PUSH		R4					; 
				LOAD		R4		10			; arg0 := 10
				PUSH		R4					; 		
				BRS			math.power			; call math.power(10, n)
				
				; get nth numeral of number
				LOAD		R4		[SP+2]		; number
				DIV			R4		[SP]		; 10^n
				MOD			R4		10			; wrap around 10

				; return
				STOR		R4		[SP+3]		; return numeral
				LOAD		R4		[SP+1]		;
				ADD 		SP		3			; pop garbage
				JMP			R4					;
	
@INCLUDE "lib.bit"
	
@END
