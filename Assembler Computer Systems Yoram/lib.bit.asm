; Binary library
;
; Standard functions for interacting with binary numbers.
				
@CODE

; namespace : bit
; function	: NOT (value) binary
; doc		: NOT value 

; OPTIMIZED
bit.NOT :			LOAD		R4		0			;
					SUB			R4		[SP+1]		;
					SUB			R4		1			;
										
					; return
					STOR		R4		[SP+1]		; return value
					PULL		R4					;
					JMP			R4					;
; end
	
	
	
; namespace : bit
; function	: AND (value0, value1) binary
; doc		: value0 AND value1 

; OPTIMIZED
bit.AND :			PUSH 		R5 					;
					LOAD 		R5		SP			;
					SUB			SP		1			; allocate 1 local variable	(value0)

					LOAD		R4		[R5+2]		;
					STOR		R4		[R5+-1]		;
					LOAD		R4		[R5+3]		;
					AND			R4		[R5+-1]		;
										
					; return
					STOR		R4		[R5+3]		; return value
					LOAD 		SP		R5			;
					PULL		R5					;
					PULL		R4					;
					ADD			SP		1			; pop 1 argument (save return)
					JMP			R4					;
; end



; namespace : bit
; function	: NAND (value0, value1) binary
; doc		: value0 NAND value1 

; OPTIMIZED
bit.NAND :			PUSH 		R5 					;
					LOAD 		R5		SP			;
					SUB			SP		1			; allocate 1 local variable	(value0)

					; AND
					LOAD		R4		[R5+2]		;
					STOR		R4		[R5+-1]		;
					LOAD		R4		[R5+3]		;
					AND			R4		[R5+-1]		;
					
					; NOT
					PUSH		R4					; arg0 := value
					BRS			bit.NOT				; call NOT (value)
					PULL		R4
										
					; return
					STOR		R4		[R5+3]		; return value
					LOAD 		SP		R5			;
					PULL		R5					;
					PULL		R4					;
					ADD			SP		1			; pop 1 argument (save return)
					JMP			R4					;
; end



; namespace : bit
; function	: OR (value0, value1) binary
; doc		: value0 OR value1 

; OPTIMIZED
bit.OR :			PUSH 		R5 					;
					LOAD 		R5		SP			;
					SUB			SP		1			; allocate 1 local variable	(value0)

					LOAD		R4		[R5+2]		;
					STOR		R4		[R5+-1]		;
					LOAD		R4		[R5+3]		;
					OR			R4		[R5+-1]		;
										
					; return
					STOR		R4		[R5+3]		; return value
					LOAD 		SP		R5			;
					PULL		R5					;
					PULL		R4					;
					ADD			SP		1			; pop 1 argument (save return)
					JMP			R4					;
; end



; namespace : bit
; function	: NOR (value0, value1) binary
; doc		: value0 NOR value1 

; OPTIMIZED
bit.NOR :			PUSH 		R5 					;
					LOAD 		R5		SP			;
					SUB			SP		1			; allocate 1 local variable	(value0)

					; OR
					LOAD		R4		[R5+2]		;
					STOR		R4		[R5+-1]		;
					LOAD		R4		[R5+3]		;
					OR			R4		[R5+-1]		;
					
					; NOT
					PUSH		R4					; arg0 := value
					BRS			bit.NOT				; call not (value)
					PULL		R4
										
					; return
					STOR		R4		[R5+3]		; return value
					LOAD 		SP		R5			;
					PULL		R5					;
					PULL		R4					;
					ADD			SP		1			; pop 1 argument (save return)
					JMP			R4					;
; end



; namespace : bit
; function	: XOR (value0, value1) binary
; doc		: value0 XOR value1 

; OPTIMIZED
bit.XOR :			PUSH 		R5 					;
					LOAD 		R5		SP			;
					SUB			SP		1			; allocate 1 local variable	(value0)

					LOAD		R4		[R5+2]		;
					STOR		R4		[R5+-1]		;
					LOAD		R4		[R5+3]		;
					XOR			R4		[R5+-1]		;
										
					; return
					STOR		R4		[R5+3]		; return value
					LOAD 		SP		R5			;
					PULL		R5					;
					PULL		R4					;
					ADD			SP		1			; pop 1 argument (save return)
					JMP			R4					;
; end
	
	
	
; namespace : bit
; function	: get (word, n, i) binary
; doc		: get word[i : i+n] 

; OPTIMIZED
bit.get :			PUSH 		R5 					;
					LOAD 		R5		SP			;
					SUB			SP		2			; allocate 2 local variables (mask, shift)

					; get mask
					LOAD		R4		[R5+3]		; arg1 := n
					PUSH		R4					;
					LOAD		R4		2			; arg0 := 2
					PUSH		R4					;
					BRS			math.power			; call power(2, n)
					PULL		R4					;
					SUB			R4		1			; finalize mask
					STOR		R4		[R5+-1]		;
					
					; get shift
					LOAD		R4		[R5+4]		; arg1 := i
					PUSH		R4					;
					LOAD		R4		2			; arg0 := 2
					PUSH		R4					;
					BRS			math.power			; call power(2, i)
					PULL		R4					;
					STOR		R4		[R5+-2]		;
					
					; shift word
					LOAD		R4		[R5+2]		; R4 := word
					DIV			R4		[R5+-2]		;
					
					; mask word
					AND			R4		[R5+-1]		; apply mask	
					
					; return
					STOR		R4		[R5+4]		; return value
					LOAD 		SP		R5			;
					PULL		R5					;
					PULL		R4					;
					ADD			SP		2			; pop 2 arguments (save return)
					JMP			R4					;
; end
	
	
	
	
; namespace : bit
; function	: set (word, value, n, i) binary
; doc		: set word[i : i+n] to value[0 : n]

; OPTIMIZED
bit.set :			PUSH 		R5 					;
					LOAD 		R5		SP			;
					SUB			SP		2			; allocate 2 local variables (mask, shift)

					; get mask
					LOAD		R4		[R5+4]		; arg1 := n
					PUSH		R4					;
					LOAD		R4		2			; arg0 := 2
					PUSH		R4					;
					BRS			math.power			; call power(2, n)
					PULL		R4					;
					SUB			R4		1			; finalize mask
					STOR		R4		[R5+-1]		;
										
					; get shift
					LOAD		R4		[R5+5]		; arg1 := i
					PUSH		R4					;
					LOAD		R4		2			; arg0 := 2
					PUSH		R4					;
					BRS			math.power			; call power(2, i)
					PULL		R4					;
					STOR		R4		[R5+-2]		;
					
					; shift mask
					LOAD		R4		[R5+-1]		;
					MULS		R4		[R5+-2]		;
					STOR		R4		[R5+-1]		;
					
					; shift value
					LOAD		R4		[R5+3]		;
					MULS		R4		[R5+-2]		;

					; mask value
					AND			R4		[R5+-1]
					STOR		R4		[R5+3]		;
					
					; purge word
					LOAD		R4		[R5+-1]		; arg0 := mask
					PUSH		R4					;
					BRS			bit.NOT				; call not(mask)
					PULL		R4					;
					STOR		R4		[R5+-1]		;
					LOAD		R4		[R5+2]		; 
					AND			R4		[R5+-1]		;
					
					; join word and value
					OR			R4		[R5+3]		;	
					
					; return
					STOR		R4		[R5+5]		; return value
					LOAD 		SP		R5			;
					PULL		R5					;
					PULL		R4					;
					ADD			SP		3			; pop 3 arguments (save return)
					JMP			R4					;
; end

@END
