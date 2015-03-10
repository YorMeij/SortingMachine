; Exercise 5

@INCLUDE "lib.std"

@DATA			
				BUF			DS		1			; input buffer
				STATE		DS		1			; LED state
				NLEDS		DS 		7			; N the amount of light the led should give.
				N			DS		1 			; current N
				
@CODE 
	main : 		LOAD		R1		0			; 
				LOAD 		R2 		0			;
				LOAD 		R3		0			;

				; enable timer interrupt
				LOAD		R4		timer		;
				PUSH		R4		
				LOAD		R4		INTERRUPT_TIMER	;
				PUSH		R4
				BRS			system.interrupt
				
				; reset timer
				LOAD		R4		0			;
				SUB			R4		[R0+TIMER]	;
				STOR		R4		[R0+TIMER]	;
				
	loop:		; store input buffer
				LOAD		R4		[R0+INPUT]	;
				STOR		R4		[GB+BUF]	;
				
				
				
				BRA			loop				;
				
	; timer :		; toggle state
				; LOAD		R4		[GB+STATE]	;
				; XOR			R4		%0111		;
				; STOR		R4		[GB+STATE]	;
				
				;set LEDs
				; STOR		R4		[R0+LEDS]	;
	
				;copy input buffer to output
				; LOAD		R4		[GB+BUF]	;
				; STOR		R4		[R0+OUTPUT]	;
				
				ADD			[GB+N] 		1; add one to N
				
				;get the buffer
				LOAD 		R4 		[GB + BUF]
				;increment only those N that have been clicked
				
				
				; set timer delta
				LOAD		R4		10		; delta
				STOR		R4		[R0+TIMER]	;
				SETI		INTERRUPT_TIMER		; enable timer interrupt again
				RTE
				
@END
