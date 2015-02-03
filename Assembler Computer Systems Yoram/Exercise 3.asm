
; Exercise 3.1 
;
; 2011.10.11
; author:	Christiaan Dirkx
;			Yoram Meijaard
;

@INCLUDE "lib.std"

@DATA			

				DECIMAL		EQU		%010000000	; bitmask for decimal point display element

@CODE
				
	main :		LOAD		R1		0			; value
				LOAD		R2		0			; display index
	
	loop :		; wait for 10 steps
				LOAD 		R4 		10			; arg0 := 10
				PUSH 		R4					;
				BRS			system.wait			; call system.wait(100)
	
				PUSH		R0					; arg2 := 0
				LOAD		R4		8			; arg1 := 8
				PUSH		R4
				LOAD		R4		[R0+ADCONVS]; arg0 := 'ADCONVS'
				PUSH		R4
				BRS			bit.get				; call get('ADCONVS', 8, 0)
				PULL		R1
								
				; scale to 5.00
				MULS		R1		500			
				DIV			R1		255
				
				PUSH		R2					; arg1 := 'index'
				PUSH		R1					; arg0 := 'value'
				BRS			util.numeral		; call numeral('value', 0)
				BRS			util.convert		; call convert(value)
				PULL		R4					; R4 := return value	

				CMP			R2		2		
				BNE			set
				
				OR			R4		DECIMAL
				
	set :		STOR		R4		[R0+SEGMENT]; store display pattern
				
				PUSH		R2					; arg1 := 'index'
				LOAD 		R4		2			; arg0 := 2	
				PUSH 		R4					;
				BRS			math.power			; call math.power(2, 'IDX')
				PULL		R4					; R4 := return value
				STOR		R4		[R0+DIGIT]	; store display element pattern
				
				; next index
				ADD			R2		1			; increment 'index'
				MOD			R2		3			; wrap around 3
				
				BRA			loop
				
@END
