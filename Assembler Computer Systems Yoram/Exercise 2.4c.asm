 
; Exercise 2.4 
;
; 2011.10.11
; author:	Christiaan Dirkx
;			Yoram Meijaard
;
; description

@INCLUDE "lib.std"

@CODE
				
	main :		LOAD		R1		0			; 'data'
				LOAD		R2		0			; 'idx'
				LOAD		R3		0			; 'state'
				
	loop :		; wait for 10 steps
				LOAD 		R4 		10 			; arg0 := 10
				PUSH 		R4					;
				BRS			system.wait			; call system.wait(10)
				
				; translate R2 to display pattern				
				PUSH 		R2					; arg1 := 'idx'
				PUSH 		R1					; arg0 := 'data'
				BRS			getNumeral			; call getNumeral('data', 'idx')	
				BRS			util.convert		; call util.convert(numeral)	
				PULL		R4					; R4 := return value				
				STOR		R4		[R0+SEGMENT]; store display pattern

				; translate index to Display Element pattern				
				PUSH		R2					; arg1 := 'idx'
				LOAD 		R4		2			; arg0 := 2	
				PUSH 		R4					;
				BRS			math.power			; call math.power(2, 'idx')
				PULL		R4					; R4 := return value
				STOR		R4		[R0+DIGIT]	; store display element pattern

				; next index
				ADD			R2		1			; increment 'idx'
				MOD			R2		6			; wrap around 6
			
				; test button 7
				PUSH		R3					; arg1 := 'state'
				LOAD 		R4		7			; arg0 := 7
				PUSH 		R4							
				BRS			input.pressed		; call input.pressed(7, 'state')
				PULL		R4					; R4 := return value
				
				; reset if button 7 was pressed
				CMP			R4		1			;
				BNE			reset_end			;
				LOAD		R1		0			; set data to 0
				
reset_end:		; test button 0
				PUSH		R3					; arg1 := 'state'
				LOAD 		R4		0			; arg0 := 0
				PUSH 		R4							
				BRS			input.pressed		; call input.pressed(0, 'state')
				PULL		R4					; R4 := return value
				
				; increment if button 0 was pressed
				CMP			R4		1
				BNE			inc_end
				ADD			R1		1			; increment 'data'
				MOD			R1		10000		; wrap around 10000
				
	inc_end :	; test button 1
				PUSH		R3					; arg1 := 'state'
				LOAD 		R4		1			; arg0 := 1
				PUSH 		R4							
				BRS			input.pressed		; call input.pressed(1, 'state')
				PULL		R4					; R4 := return value
				
				; decrement if button 1 was pressed
				CMP			R4		1
				BNE			dec_end
				SUB			R1		1			; decrement 'data'
				BPL			dec_end		
				LOAD		R1		9999		; wrap around underflow

	dec_end :	; store previous input state
				LOAD		R3		[R0+INPUT]	; 
				BRA			loop				;
				
				
				
; function	: numeral (number, n) int
; doc		: get nth numeral of number
				
; OPTIMIZED - HaX w1Th StaX
getNumeral :	; call function power
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
				
@END
