; Exercise 4b

@INCLUDE "lib.std"

@DATA			
				DATA		DS		8			; data to be displayed on	(int[6])
				STATE		DS		1			; input state				(binary)
				OUT			DS		1			; output state				(binary)
				SUBTRACT	DS		1			; determine sub/add			(boolean)
	
	@CODE 
	main : 		LOAD 		R1 		0 			; data
				LOAD 		R2 		0			; buf
				LOAD 		R3		0			; idx
			
	loop :		; loop at 1000 hz
				LOAD 		R4		1			; 
				PUSH 		R4					;
				BRS 		system.wait;		;
						
				; run for idx 0...7
display_idx :	ADD			R3		1			;
				CMP			R3		8			;
				BNE			display				;
				LOAD		R3		-1			;
				
input_idx :		ADD			R3		1			;
				CMP			R3		8			;
				BNE			input				;
				LOAD		R3		-1			;
				
				; loop end
				LOAD		R4		[R0+INPUT]	; save input state 
				STOR		R4		[GB+STATE]	;
				ADD			R2		1			;
				MOD			R2		100			;
				BRA			loop				;
			
display :		; calculate data address
				LOAD		R1		DATA		;
				ADD			R1		R3			;
			
				CMP 		R2 		[GB+R1];	;
				
				; load R1 with 1 if R2 < n else load R1 with 0
				BGE 		off					;
				LOAD		R1		1			;
				BRA			set					;
	off :		LOAD		R1		0			;
	
				; set output bit
	set :		PUSH		R3					;
				LOAD		R4		1			;
				PUSH		R4
				PUSH		R1					;
				LOAD		R4		[GB+OUT]	;
				PUSH		R4					;
				BRS			bit.set				;
				PULL		R4					;
				STOR		R4		[R0+OUTPUT]	;
				STOR		R4		[GB+OUT]	;
				
				; wrap around 100 and return to "display_idx"
				BRA 		display_idx;		;			
			
input :			CMP			R3		0			; display 0 is controlled by the potential meter
				BEQ			pot					;

				STOR		R0		[GB+SUBTRACT]
				LOAD		R1		%01
				LOAD		R4		[R0+INPUT]
				AND			R4		R1
				CMP			R4		R1
				BNE			check
				LOAD		R4		1	
				STOR		R4		[GB+SUBTRACT]				
				
	check :		LOAD 		R4		[GB+STATE]	; arg1 := 'state'
				PUSH		R4					; 
				PUSH 		R3					; arg0 := 'idx'	
				BRS			input.pressed		; call input.pressed('idx', 'state')
				PULL		R4					; R4 := return value
				
				; reset if button 'idx was pressed
				CMP			R4		R0			;
				BEQ			input_idx			;
				
				; increase data['idx'] by 10 mod 100
				LOAD		R1		DATA		;
				ADD			R1		R3			;
				
				LOAD		R4		[GB+SUBTRACT];
				CMP			R4		R0			;
				BEQ			add					;
				
	sub :		LOAD		R4		[GB+R1]		;
				SUB			R4		10			;
				MOD			R4 		100			;			
				BRA			stor
				
	add :		LOAD		R4		[GB+R1]	;
				ADD			R4		10			;
				MOD			R4 		100			;
				BRA			stor

	pot :		PUSH		R0					; arg2 := 0
				LOAD		R4		8			; arg1 := 8
				PUSH		R4
				LOAD		R4		[R0+ADCONVS]; arg0 := 'ADCONVS'
				PUSH		R4
				BRS			bit.get				; call get('ADCONVS', 8, 0)
				PULL		R4
								
				; scale to 100
				MULS		R4		100			
				DIV			R4		255
				
	stor :		; store R4 in data[idx]
				LOAD		R1		DATA		;
				ADD			R1		R3			;
				STOR		R4		[GB+R1]		;
				BRA			input_idx			
@END