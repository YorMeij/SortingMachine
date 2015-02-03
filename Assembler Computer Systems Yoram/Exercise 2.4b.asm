 
; Exercise 2.4 
;
; 2011.10.11
; author:	Christiaan Dirkx
;			Yoram Meijaard
;
; description

@DATA

				IOAREA	EQU		-16			; address of the I/O-Area, modulo 2^18
				INPUT	EQU		7			; position of the input buttons (relative to IOAREA)
				OUTPUT	EQU		11			; relative position of the power outputs
				TIMER	EQU		13			; relative position of the Timer
				DSPDIG	EQU		9			; relative position of the 7-segment display's digit selector
				DSPSEG	EQU		8			; relative position of the 7-segment display's segments

				data	DS		6			; data to be displayed on	(int[6])
				idx		DS		1			; data index				(int)
				state	DS		1			; input state				(int)

@CODE
				
	main:		LOAD	R5		IOAREA		; R5 := address of the area with the I/O-registers
				LOAD	R4		GB			; R4 := address of the area with the 'data' array
				ADD		R4		data		;				
				
				; reset timer to avoid timer underflow
				LOAD	R0		0
				SUB		R0		[R5+TIMER]
				ADD		R0		[R5+TIMER]			
	
	loop:		LOAD	R0		[R5+TIMER]		; R0 := stored timer step
				CMP		R0		0			; compare difference with 10 (0.001s)
				BLT		loop				; loop until 0.001s have passed

				LOAD	R0		10
				STOR	R0		[R5+TIMER]
				
				; translate R2 to display pattern
				LOAD	R0		[GB+idx]	; R0 := 'idx'
				LOAD	R0		[R4+R0]		; R0 := 'data[idx]'
				BRS		Hex7Seg				;
				STOR	R1		[R5+DSPSEG] ;

				; translate R1 to Display Element
				LOAD	R0		[GB+idx]	; R0 := 'idx'
				BRS		Shift				;
				STOR	R1		[R5+DSPDIG]	;

				; next index
				ADD		R0		1			; increment R0
				MOD		R0		6			; wrap around 6
				STOR	R0		[GB+idx]	; 'idx' := R0
			
				LOAD	R0		[R5+INPUT]	; R3 := input state
				PUSH	R0					; save input state
				LOAD	R0		0			; R0 := button idx

	input:		CMP		R0		6			; loop through 0-5	
				BEQ		input_end			;

				BRS		Shift				; R1 := bitmask for button[idx]

				LOAD	R2		[GB+state]	; load previous input state
				AND		R2		R1			; apply bitmask
				CMP		R2		R1			; test if button[idx] was pressed
				BEQ		next				;

				PULL	R2					; load input state
				PUSH	R2
				AND		R2		R1			; apply bitmask
				CMP		R2		R1			; test if button[idx] was pressed
				BNE		next				;

				LOAD	R1		[R4+R0]		; R1 := 'data[idx]'
				ADD		R1		1			; increment R1
				MOD		R1		16			; wrap around 16
				STOR	R1		[R4+R0]		; 'data[idx]' := R1

	next:		ADD		R0		1			;
				BRA		input				;

input_end:		PULL	R0					; load input state
				STOR	R0		[GB+state]	; store input state
				BRA		loop				;

; Shift
; Calculates a power of two.
; R0 : n
; R1 : 2^n

	Shift:		PUSH	R0					; save R0
				LOAD	R1		1			; base case is 1 (2^0)

				; loop for n times
Shift_loop:		CMP		R0		0			;
				BEQ		Shift_end			;

				SUB		R0		1			;
				MULS	R1		2			; multiply by 2 to shift bit right
				BRA		Shift_loop			;

Shift_end:		PULL	R0					; restore R0
				RTS							; return

; Hex7Seg
; Maps a number in the range [0..15] to its hexadecimal
; representation pattern for the 7-segment display.
; R0 : upon entry, contains the number
; R1 : upon exit,  contains the resulting pattern

Hex7Seg:		BRS		Hex7Seg_bgn			; push address(tbl) onto stack and proceed at "bgn"

Hex7Seg_tbl:	CONS	%01111110			; 7-segment pattern for '0'
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

Hex7Seg_bgn:	MOD		R0		16			; wrap around 16
				LOAD	R1		[SP++]		; R1 := address(tbl) (retrieve from stack)
				LOAD	R1		[R1+R0]		; R1 := tbl[R0]
				RTS							; return
				
@END