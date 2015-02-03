 
; Exercise 5.2 
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
				BUF			DS		1			; buffer
				
				MIN			DS		1
				SEC			DS		1
				MSEC		DS		1

@CODE
				
	main :		; enable timer interrupt
				LOAD		R4		timer		;
				PUSH		R4		
				LOAD		R4		INTERRUPT_TIMER	;
				PUSH		R4
				BRS			system.interrupt
		
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
				
				STOR		R0		[GB+MIN]
				STOR		R0		[GB+SEC]
				STOR		R0		[GB+MSEC]
				STOR		R0		[GB+RUN]	; set 'RUN' to false
				BRA			input_end				
				
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
				BRA			input_end	
				
				; test button 1
	b1 :		LOAD 		R4		[GB+STATE]	; arg1 := 'state'
				PUSH		R4					; 
				LOAD 		R4		1			; arg0 := 1
				PUSH 		R4					;	
				BRS			input.pressed		; call input.pressed(1, 'state')
				PULL		R4					; R4 := return value
				
				; stop if button 1 was pressed
				CMP			R4		R0			;
				BEQ			input_end				;
				
				STOR		R0		[GB+RUN]	; set 'RUN' to false
				
input_end :		LOAD		R4		[R0+INPUT]	; set previous input
				STOR		R4		[GB+STATE]	;
				BRA			input				;
				
				
				
	timer :		LOAD		R4		[GB+BUF]
				CMP			R4		10
				BNE			display
	
				LOAD		R4		[GB+BUF]
				MOD			R4		10
				STOR		R4		[GB+BUF]
	
				; if timer is not running skip to "display"
				LOAD		R4		[GB+RUN]	; get 'RUN'
				CMP			R4		R0			; compare with false
				BEQ			display
								
				; increment 'msec' and go to "display" if no wrap occurs
				LOAD		R4		[GB+MSEC]
				ADD			R4		1			; increment 'msec'
				STOR		R4		[GB+MSEC]
				CMP			R4		100			;
				BNE			display				;
				
				STOR		R0		[GB+MSEC]	; wrap around 'msec'
				
				; increment 'sec' and go to "display" if no wrap occurs
				LOAD		R4		[GB+SEC]
				ADD			R4		1			; increment 'sec'
				STOR		R4		[GB+SEC]
				CMP			R4		60			;
				BNE			display				;
				
				LOAD		R0		[GB+SEC]	; wrap around 'sec'
				
				; increment 'min' and go to "display" if no wrap occurs
				LOAD		R4		[GB+MIN]
				ADD			R4		1			; increment 'min'
				STOR		R4		[GB+MIN]
				CMP			R4		60			;
				BNE			display				;
				
				; reset and stop timer
				LOAD		R0		[GB+MIN]	; wrap around 'min'
				STOR		R0		[GB+RUN]	; set 'RUN' to false
		
	display :	LOAD		R4		[GB+BUF]
				ADD			R4		1
				STOR		R4		[GB+BUF]
				
				BRS			switch
				
				; switch
				BRA			d0
				BRA			d1
				BRA			d2
				BRA			d3
				BRA			d4
				BRA			d5
	
		d0 :	LOAD		R4		0			; arg1 := 0
				PUSH		R4					;
				LOAD		R4		[GB+MSEC]
				PUSH		R4					; arg0 := 'msec'
				BRS			getNumeral			; call getNumeral('msec', 0)
				BRS			util.convert		; call convert (value)
				PULL		R4					; R4 := return value				
				STOR		R4		[R0+SEGMENT]; store display pattern
				BRA			end
		
		d1 :	LOAD		R4		1			; arg1 := 1
				PUSH		R4					;
				LOAD		R4		[GB+MSEC]
				PUSH		R4					; arg0 := 'msec'
				BRS			getNumeral			; call getNumeral('msec', 1)
				BRS			util.convert		; call convert (value)
				PULL		R4					; R4 := return value				
				STOR		R4		[R0+SEGMENT]; store display pattern
				BRA			end
		
		d2 :	LOAD		R4		0			; arg1 := 0
				PUSH		R4					;
				LOAD		R4		[GB+SEC]
				PUSH		R4					; arg0 := 'sec'
				BRS			getNumeral			; call getNumeral('sec', 0)
				BRS			util.convert		; call convert (value)
				PULL		R4					; R4 := return value	
				OR			R4		DECIMAL		; set decimal point
				STOR		R4		[R0+SEGMENT]; store display pattern
				BRA			end
		
		d3 :	LOAD		R4		1			; arg1 := 1
				PUSH		R4					;
				LOAD		R4		[GB+SEC]
				PUSH		R4					; arg0 := 'sec'
				BRS			getNumeral			; call getNumeral('sec', 1)
				BRS			util.convert		; call convert (value)
				PULL		R4					; R4 := return value				
				STOR		R4		[R0+SEGMENT]; store display pattern
				BRA			end
		
		d4 :	LOAD		R4		0			; arg1 := 0
				PUSH		R4					;
				LOAD		R4		[GB+MIN]
				PUSH		R4					; arg0 := 'min'
				BRS			getNumeral			; call getNumeral('min', 0)
				BRS			util.convert		; call convert (value)
				PULL		R4					; R4 := return value		
				OR			R4		DECIMAL		; set decimal point				
				STOR		R4		[R0+SEGMENT]; store display pattern
				BRA			end
		
		d5 :	LOAD		R4		1			; arg1 := 1
				PUSH		R4					;
				LOAD		R4		[GB+MIN]
				PUSH		R4					; arg0 := 'min'
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
	
				LOAD		R4		10		; delta
				STOR		R4		[R0+TIMER]	;
				SETI		INTERRUPT_TIMER		; enable timer interrupt again
				RTE
				
				
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