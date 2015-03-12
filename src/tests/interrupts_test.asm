@DATA
svar_cs         DW 0
svar_v          DW 0
svar_delta      DW 10

@CODE
            BRA  fn_main

fn___int_nop:PUSH R5
            LOAD R5 SP
            SUB  SP 2
                LOAD R0 262141
                STOR R0 [R5+-1]
                LOAD R0 [R5+-1]
                LOAD R0 [R0]
                STOR R0 [R5+-2]
                LOAD R0 1
                MULS R0 -1
                LOAD R1 R5
                ADD  R1 -2
                PUSH R1
                LOAD R1 [R1]
                MULS R1 R0
                PULL R0
                STOR R1 [R0]
                LOAD R0 [R5+-2]
                PUSH R0
                LOAD R0 [R5+-1]
                PULL R1
                STOR R1 [R0]
                LOAD R0 [GB+svar_delta]
                PUSH R0
                LOAD R0 [R5+-1]
                PULL R1
                STOR R1 [R0]
                LOAD R0 1
                LOAD R1 GB
                ADD  R1 svar_v
                PUSH R1
                LOAD R1 [R1]
                ADD  R1 R0
                PULL R0
                STOR R1 [R0]
                SETI 8
            BRA  fne___int_nop
fne___int_nop:LOAD SP R5
            PULL R5
            RTE

   fn_main: PUSH R5
            LOAD R5 SP
                PULL R2
                PUSH R1
                LOAD R1 svar_cs
                STOR R2 [R1]
                PULL R1
                PUSH R5
                PUSH R2
                LOAD R0 fn___int_nop
                LOAD R2 svar_cs
                ADD R0 [R2]
                LOAD R1 16
                STOR R0 [R1]
                PULL R2
                SETI 8
         while: LOAD R0 R0 ; NOOP
                LOAD R0 1
                BEQ  whileEnd
                BRA  while
      whileEnd: LOAD R0 R0 ; NOOP
                LOAD R0 0
            BRA  fne_main
  fne_main: LOAD R0 R0 ; NOOP
            PULL R5
            RTS


@END
