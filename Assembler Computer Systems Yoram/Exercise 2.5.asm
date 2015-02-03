 
; Exercise 2.5 
;
; 2015.4.1
; author:	Christiaan Dirkx
;			Yoram Meijaard
;
; timer state does not fit in an 18bit word, 20bit minimum

@INCLUDE "lib.std"

@DATA
				DECIMAL		EQU		%010000000	; bitmask for decimal point display element
				
				RUN			DS		1			; state if timer is running
				STATE		DS		1			; input state 
				IDX			DS		1			; display element idx

@CODE
				
	main :		LOAD		R1		0			; 'min'
				LOAD		R2		0			; 'sec'
				LOAD		R3		0			; 'msec'
	
	loop :		; wait for 100 steps
				LOAD 		R4 		100			; arg0 := 100
				PUSH 		R4					;
				BRS			system.wait			; call system.wait(100)
							
				; if timer is not running skip to "input"
				LOAD		R4		[GB+RUN]	; get 'RUN'
				CMP			R4		R0			; compare with false
				BEQ			input
								
				; increment 'msec' and go to "input" if no wrap occurs
				ADD			R3		1			; increment 'msec'
				CMP			R3		100			;
				BNE			input				;
				
				LOAD		R3		R0			; wrap around 'msec'
				
				; increment 'sec' and go to "input" if no wrap occurs
				ADD			R2		1			; increment 'sec'
				CMP			R2		60			;
				BNE			input				;
				
				LOAD		R2		R0			; wrap around 'sec'
				
				; increment 'min' and go to "input" if no wrap occurs
				ADD			R1		1			; increment 'min'
				CMP			R1		60			;
				BNE			input				;
				
				; reset and stop timer
				LOAD		R1		R0			; wrap around 'min'
				STOR		R0		[GB+RUN]	; set 'RUN' to false
	
	input :		; test button 7
				LOAD 		R4		[GB+STATE]	; arg1 := 'state'
				PUSH		R4					; 
				LOAD 		R4		7			; arg0 := 7
				PUSH 		R4							
				BRS			input.pressed		; call input.pressed(7, 'state')
				PULL		R4					; R4 := return value
				
				; reset if button 7 was pressed
				CMP			R4		R0			;
				BEQ			b0				;
				
				LOAD		R1		R0			; min := 0
				LOAD		R2		R0			; sec := 0
				LOAD		R3		R0			; msec := 0
				STOR		R0		[GB+RUN]	; set 'RUN' to false
				BRA			display				
				
				; test button 0
	b0 :		LOAD 		R4		[GB+STATE]	; arg1 := 'state'
				PUSH		R4					; 
				LOAD 		R4		0			; arg0 := 0
				PUSH 		R4					;		
				BRS			input.pressed		; call input.pressed(0, 'state')
				PULL		R4					; R4 := return value
				
				; run if button 0 was pressed
				CMP			R4		R0			;
				BEQ			b1				;	
				
				LOAD		R4		1			; set 'RUN' to true
				STOR		R4		[GB+RUN]	;
				BRA			display	
				
				; test button 1
	b1 :		LOAD 		R4		[GB+STATE]	; arg1 := 'state'
				PUSH		R4					; 
				LOAD 		R4		1			; arg0 := 1
				PUSH 		R4					;	
				BRS			input.pressed		; call input.pressed(1, 'state')
				PULL		R4					; R4 := return value
				
				; stop if button 1 was pressed
				CMP			R4		R0			;
				BEQ			display				;
				
				STOR		R0		[GB+RUN]	; set 'RUN' to false
				
	display :	BRS			switch
				
				; switch
				BRA			d0
				BRA			d1
				BRA			d2
				BRA			d3
				BRA			d4
				BRA			d5
	
		d0 :	LOAD		R4		0			; arg1 := 0
				PUSH		R4					;
				PUSH		R3					; arg0 := 'msec'
				BRS			getNumeral			; call getNumeral('msec', 0)
				BRS			util.convert		; call convert (value)
				PULL		R4					; R4 := return value				
				STOR		R4		[R0+SEGMENT]; store display pattern
				BRA			end
		
		d1 :	LOAD		R4		1			; arg1 := 1
				PUSH		R4					;
				PUSH		R3					; arg0 := 'msec'
				BRS			getNumeral			; call getNumeral('msec', 1)
				BRS			util.convert		; call convert (value)
				PULL		R4					; R4 := return value				
				STOR		R4		[R0+SEGMENT]; store display pattern
				BRA			end
		
		d2 :	LOAD		R4		0			; arg1 := 0
				PUSH		R4					;
				PUSH		R2					; arg0 := 'sec'
				BRS			getNumeral			; call getNumeral('sec', 0)
				BRS			util.convert		; call convert (value)
				PULL		R4					; R4 := return value	
				OR			R4		DECIMAL		; set decimal point
				STOR		R4		[R0+SEGMENT]; store display pattern
				BRA			end
		
		d3 :	LOAD		R4		1			; arg1 := 1
				PUSH		R4					;
				PUSH		R2					; arg0 := 'sec'
				BRS			getNumeral			; call getNumeral('sec', 1)
				BRS			util.convert		; call convert (value)
				PULL		R4					; R4 := return value				
				STOR		R4		[R0+SEGMENT]; store display pattern
				BRA			end
		
		d4 :	LOAD		R4		0			; arg1 := 0
				PUSH		R4					;
				PUSH		R1					; arg0 := 'min'
				BRS			getNumeral			; call getNumeral('min', 0)
				BRS			util.convert		; call convert (value)
				PULL		R4					; R4 := return value		
				OR			R4		DECIMAL		; set decimal point				
				STOR		R4		[R0+SEGMENT]; store display pattern
				BRA			end
		
		d5 :	LOAD		R4		1			; arg1 := 1
				PUSH		R4					;
				PUSH		R1					; arg0 := 'min'
				BRS			getNumeral			; call getNumeral('min', 1)
				BRS			util.convert		; call convert (value)
				PULL		R4					; R4 := return value				
				STOR		R4		[R0+SEGMENT]; store display pattern
				BRA			end

	switch :	PULL		R4	
				ADD			R4		[GB+IDX]
				JMP			R4

				; translate index to Display Element pattern				
	end :		LOAD		R4		[GB+IDX]	; arg1 := 'IDX'
				PUSH		R4
				LOAD 		R4		2			; arg0 := 2	
				PUSH 		R4					;
				BRS			math.power			; call math.power(2, 'IDX')
				PULL		R4					; R4 := return value
				STOR		R4		[R0+DIGIT]	; store display element pattern
				
				; next index
				LOAD		R4		[GB+IDX]
				ADD			R4		1			; increment 'IDX'
				MOD			R4		6			; wrap around 6
				STOR		R4		[GB+IDX]
	
				LOAD		R4		[R0+INPUT]	; set previous input
				STOR		R4		[GB+STATE]	;
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