; Exercise 4.1a

;dimming lights

;R1 := n

@INCLUDE "lib.std"

@DATA			
			DATA	DS		8			; data to be displayed on	(int[6])
			STATE	DS		1			; input state				(int)
	
	@CODE 
	main: 	;define R1 as the amount of light there should be in a light
			LOAD 	R1 		0 		; data
			LOAD 	R2 		0		; buf
			LOAD 	R3		0		; idx
			
	loop:	LOAD 	R4		1; implement 10000 hz
			PUSH 	R4;
			BRS 	system.wait;
			
			BRA		idx
		
	inc :	ADD		R3		1
	idx :	CMP		R3		8
			BNE		run
			
			LOAD	R3		0
			LOAD	R4		[R0+INPUT]
			STOR	R4		[GB+STATE]
			BRA		loop
			
	run:	CMP		R3		0;
			BEQ		pot
	
			LOAD	R1		DATA
			ADD		R1		R3
			
			CMP 	R2 		[GB+R1];
			BLT 	on
			
			;R2 > n
			STOR 	R0 		[R0+OUTPUT]; LIGHT OFF
			
			CMP 	R2 		100
			BNE 	input;
			LOAD 	R2 		0;
			BRA 	input;
			
	on:		PUSH	R3
			LOAD	R4		2
			PUSH	R4
			BRS		math.power
			PULL	R4
			STOR 	R4 		[R0+OUTPUT]; LIGHTS ON
			BRA 	input;
	
	pot :
	
			BRA		inc
			
input :		LOAD 		R4		[GB+STATE]	; arg1 := 'state'
			PUSH		R4					; 
			PUSH 		R3					; arg0 := 'idx'	
			BRS			input.pressed		; call input.pressed('idx', 'state')
			PULL		R4					; R4 := return value
				
			; reset if button 'idx was pressed
			CMP			R4		R0			;
			BEQ			inc					;
			
			; increase data['idx'] by 10 mod 100
			LOAD		R1		DATA
			ADD			R1		R3
			
			LOAD		R4		[GB+R1]	;
			ADD			R4		10			;
			MOD			R4 		100			;
			STOR		R4		[GB+R1]		;
			
			BRA			inc

@END