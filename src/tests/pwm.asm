@DATA
svar_cs         DW 0
svar_cnt        DW 0
svar_max        DW 100
svar_cntThreshold DW 50
svar_delta      DW 10

@CODE
            BRA  fn_main

fn___int_handler:PUSH R5
            LOAD R5 SP
            SUB  SP 3
                LOAD R0 262141
                STOR R0 [R5+-1]
                LOAD R0 [R5+-1]
                LOAD R0 [R0]
                STOR R0 [R5+-2]
                LOAD R0 262139
                STOR R0 [R5+-3]
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
                LOAD R0 [GB+svar_max]
                LOAD R1 GB
                ADD  R1 svar_cnt
                PUSH R1
                LOAD R1 [R1]
                MOD  R1 R0
                PULL R0
                STOR R1 [R0]
                LOAD R0 1
                LOAD R1 GB
                ADD  R1 svar_cnt
                PUSH R1
                LOAD R1 [R1]
                ADD  R1 R0
                PULL R0
                STOR R1 [R0]
                        LOAD R0 [GB+svar_cnt]
                    PUSH R0
                        LOAD R0 [GB+svar_cntThreshold]
                        PULL R1
                        CMP  R1 R0
                        BLT  cmpTrue
                        LOAD R1 0
                        BRA  cmpEnd
               cmpTrue: LOAD R1 1
                cmpEnd: LOAD R1 R1 ; NOOP
                        BEQ  el
                        LOAD R0 1
                        PUSH R0
                        LOAD R0 [R5+-3]
                        PULL R1
                        STOR R1 [R0]
                        BRA  fi
                    el: LOAD R0 0
                        PUSH R0
                        LOAD R0 [R5+-3]
                        PULL R1
                        STOR R1 [R0]
                    fi: LOAD R0 R0 ; NOOP
                SETI 8
            BRA  fne___int_handler
fne___int_handler:LOAD SP R5
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
                LOAD R0 fn___int_handler
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
            BRA  fne_main
  fne_main: LOAD R0 R0 ; NOOP
            PULL R5
            RTS


@END
