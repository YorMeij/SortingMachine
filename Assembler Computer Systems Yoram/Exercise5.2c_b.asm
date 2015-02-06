@DATA
    LEDON      DW   0, 0, 0, 0, 0, 0, 0, 0 ;  delta of the LEDs
    CURLEDS    DW   0, 0, 0, 0, 0, 0, 0, 0 ;  current delta of the leds
    BUTTONS    DS   1
    CNT        DW   0

@CODE
   IOAREA      EQU  -16                 ;  address of the I/O-Area, modulo 2^18
   INPUT       EQU    7                 ;  position of the input buttons (relative to IOAREA)
   OUTPUT      EQU   11                 ;  relative position of the power outputs
   DIGIT       EQU    9                 ;  relative position of the 7-segment display's digit selector
   SEGMENT     EQU    8                 ;  relative position of the 7-segment display's segments
   TIMER       EQU   13                 ;  relative position of timer
   ADCONVS     EQU    6                 ;  adconvs thing
   DELTA       EQU   10                 ;  delay in timer steps  --  step for the leds

  begin:      BRA  start                ;  We start at start
;
;      The body of the main program
;
   start:
              ; Interrupt init
              LOAD  R0 work ; R0 <= "the relative position of routine work"
              ADD   R0  R5 ; R0 <= "the memory address of routine work"
              LOAD  R1  16 ; R1 <= "address of the Exception Descriptor for TIMER"
              STOR  R0  [R1] ; install TMR ISR

              LOAD  R5  IOAREA          ;  R5 := "address of the area with the I/O-registers"
              BRS   cpCurLED

              SETI  8

   loop:
              BRA loop            ;  Wait until interrupt occurs

   work:
              LOAD R0 0
              SUB  R0 [R5+TIMER] ; R0 := −TIMER
              STOR R0 [R5+TIMER] ; TIMER := TIMER+R0

              LOAD R0 DELTA
              STOR R0 [R5+TIMER]

              PUSH  R0
              PUSH  R1
              PUSH  R4
              LOAD  R1  [R5+ADCONVS]  ;  Read adconvs
              AND   R1  %011111111    ;  Mask 8 MSBs out
              MULS  R1  100
              DIV   R1  255
              STOR  R1  [GB+LEDON]
              LOAD  R0  [R5+INPUT]
              SUB   R0  [GB+BUTTONS]
              BLE   lightUp             ;  ensure that btn state changed
              LOAD  R0  [R5+INPUT]
              LOAD  R4  R0
              AND   R4  %01             ;  do we need to decrease instead of increasing?
              BNE   decrLED
              XOR   R0  [GB+BUTTONS]
              DIV   R0  2
              BRS   incrCntrs
              BRA   lightUp
   decrLED:   XOR   R0  [GB+BUTTONS]
              DIV   R0  2
              BRS   decrCntrs
   lightUp:   BRS   decCurLED
              BRS   ledOn
              LOAD  R4  [GB+CNT]
              ADD   R4  1
              STOR  R4  [GB+CNT]
              CMP   R4  9
              BLE   skipReset
              LOAD  R4  0
              STOR  R4  [GB+CNT]
              BRS   cpCurLED
   skipReset: LOAD  R4  [R5+INPUT]
              STOR  R4  [GB+BUTTONS]
              POP   R4
              POP   R1
              POP   R0

              ; Reenable interrupt bit
              SETI 8
              RTE

; Increments all the cntrs if necessary
; Input: btn state in R0 - except for btn0
   incrCntrs: PUSH  R0
              PUSH  R1
              PUSH  R2
              LOAD  R2  1
   incrCntLp: DVMD  R0  2
              CMP   R1  0
              BEQ   skipIncr
              ADD   R2  GB
              LOAD  R1  [R2+LEDON]
              ADD   R1  10
              STOR  R1  [R2+LEDON]
              SUB   R2  GB
   skipIncr:  ADD   R2  1
              CMP   R0  0
              BNE   incrCntLp
              POP   R2
              POP   R1
              POP   R0
              RTS

; Decrements all the cntrs if necessary
; Input: btn state in R0 - except for btn0
   decrCntrs: PUSH  R0
              PUSH  R1
              PUSH  R2
              LOAD  R2  1
   decrCntLp: DVMD  R0  2
              CMP   R1  0
              BEQ   skipDecr
              ADD   R2  GB
              LOAD  R1  [R2+LEDON]
              SUB   R1  10
              STOR  R1  [R2+LEDON]
              SUB   R2  GB
   skipDecr:  ADD   R2  1
              CMP   R0  0
              BNE   decrCntLp
              POP   R2
              POP   R1
              POP   R0
              RTS

;  Decrements the cur. led status by step
   decCurLED: PUSH  R0
              PUSH  R1
              LOAD  R0  7
              ADD   R0  GB
   decCurLp:  LOAD  R1  [R0+CURLEDS]
              BLE   skipDecLED
              SUB   R1  DELTA
              STOR  R1  [R0+CURLEDS]
  skipDecLED: SUB   R0  1
              LOAD  R1  GB
              SUB   R1  1
              CMP   R0  R1
              BNE   decCurLp
              POP   R1
              POP   R0
              RTS

;  Lights up the leds if needed
   ledOn:     PUSH  R0
              PUSH  R1
              PUSH  R2
              PUSH  R3
              PUSH  R4
              LOAD  R0  7
              LOAD  R2  %010000000
              LOAD  R3  0
              ADD   R0  GB
   turnLEDLp: LOAD  R1  [R0+CURLEDS]

              BLE   skipOnLED
              OR    R3  R2
  skipOnLED:  SUB   R0  1
              DIV   R2  2
              LOAD  R4  GB
              SUB   R4  1
              CMP   R0  R4
              BNE   turnLEDLp
              STOR  R3  [R5+OUTPUT]
              POP   R4
              POP   R3
              POP   R2
              POP   R1
              POP   R0
              RTS

;  Copy LEDON to CURLEDS
   cpCurLED:  PUSH  R0
              PUSH  R4
              LOAD  R4  7
              ADD   R4  GB
   cpLEDLp:   LOAD  R0  [R4+LEDON]
              STOR  R0  [R4+CURLEDS]
              SUB   R4  1
              LOAD  R0  GB
              SUB   R0  1
              CMP   R4  R0
              BNE   cpLEDLp
              POP   R4
              POP   R0
              RTS

@END
