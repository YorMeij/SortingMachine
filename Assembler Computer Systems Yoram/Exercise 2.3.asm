 
; Exercise 2.3 
;
; 2011.10.11
; author:	Christiaan Dirkx
;			Yoram Meijaard
;
; Pressing and then releasing Button 7 will toggle the blinking of Output 7.
; When it is activated Output 7 will blink at 2Hz until again deactivated.

@DATA

				IOAREA	EQU		-16			; address of the I/O-Area, modulo 2^18
				INPUT	EQU		7			; position of the input buttons (relative to IOAREA)
				OUTPUT	EQU		11			; relative position of the power outputs
				TIMER	EQU		13			; relative position of the Timer

				buf		DS		1			; step buffer						(int)
				state	DS		1			; input state						(int)
				light	DS		1			; state if the light is on			(boolean)
				blink	DS		1			; state if the ligth should blink	(boolean)

@CODE

	main :		LOAD	R5		IOAREA		; R5 := "address of the area with the I/O-registers"
				
				; reset timer to avoid timer underflow
				LOAD	R0		0
				SUB		R0		[R5+TIMER]
				ADD		R0		[R5+TIMER]	
	
	loop :		LOAD	R0		[R5+TIMER]	; R0 := stored timer step
				CMP		R0		0			; compare difference with 50 (0.001s)
				BLT		loop				; loop until 0.005s have passed

				LOAD	R0		50
				STOR	R0		[R5+TIMER]

				; load input and output states
				LOAD	R0		[R5+INPUT]	; R0 := input state

				; check Button 7 was pressed
				LOAD	R1		[GB+state]	; R2 := previous input state
				LOAD	R2		%010000000	; R2 := bitmask for Button 7 (corrected for two-complement)
				AND		R1		R2			; apply bitmask	to R2
				CMP		R1		R2			; test if Button 7 was pressed
				BEQ		blink				; goto "blink" if Button 7 was pressed

				; check Button 7 is pressed
				LOAD	R1		R0			; R2 := copy of input state
				LOAD	R2		%010000000	; R2 := bitmask for Button 7 (corrected for two-complement)
				AND		R1		R2			; apply bitmask	to R2
				CMP		R1		R2			; test if Button 7 is pressed
				BNE		blink				; goto "blink" if Button 7 is not pressed

				; toggle "blink"
				LOAD	R1		[GB+blink]	; R2 := 'blink'
				XOR		R1		1			; toggle 'blink'
				STOR	R1		[GB+blink]

	blink :		LOAD	R1		[GB+light]	; R1 := 
	
				; increment the step buffer
				LOAD	R2		[GB+buf]	;
				ADD		R2		1			;
				STOR	R2		[GB+buf]	;

				; only execute blinking every 2 per second
				CMP		R2		100			
				BNE		loop_end			
	
				; reset 'buf'
				LOAD	R2		0	;
				STOR	R2		[GB+buf]	;

				; if 'blink' then light remains off	
				LOAD	R2		[GB+blink]	; R2 := 'blink'
				CMP		R2		0			; compare with false
				BEQ		loop_end			; goto "loop_end" if 'blink' is false

				; toggle "light"
				LOAD	R1		[GB+light]	; R1 := 'blink'
				XOR		R1		1			; toggle 'light'
				STOR	R1		[GB+light]

	loop_end :	CMP		R1		1			; if R1
				BNE		else				
				LOAD	R1		%10000000	; R1 := on pattern
				BRA		end	
	else :		LOAD	R1		%00000000	; R1:= off pattern

	end :		STOR	R1		[R5+OUTPUT]	; set output
				STOR	R0		[GB+state]	; store input state
				LOAD	R0		[R5+TIMER]	; R0 := timer step
				STOR	R0		[GB+t]		; store timer step
				BRA		loop



