@DATA
svar_state      DW 1
svar_displaySwitch DW 0
svar_cs         DW 0
svar_thresholdBlack DW 250
svar_pushStateThreshold DW 5000
svar_motorCntThreshold DW 95
svar_switchOutput DW 0
svar_countsWhite DW 0
svar_timerDelta DW 10
svar_pushStateCnt DW 0
svar_thresholdWhite DW 220
svar_prevValue  DW 0
svar_motorMax   DW 100
svar_countsBlack DW 0
svar_thresholdCounts DW 500
svar_motorCnt   DW 0

@CODE
            BRA  fn_main

fn_displayAdconvsVal:PUSH R5
            LOAD R5 SP
            SUB  SP 2
                LOAD R0 262134
                STOR R0 [R5+-1]
                    LOAD R0 [R5+-1]
                    LOAD R0 [R0]
                AND  R0 65280
                STOR R0 [R5+-2]
                    LOAD R0 [R5+-2]
                AND  R0 %10
                DIV  R0 2
                AND  R0 %011111111111111111
                DIV  R0 128
                LOAD R1 R5
                ADD  R1 -2
                STOR R0 [R1]
                LOAD R0 [GB+svar_displaySwitch]
                CMP  R0 5
                BEQ  case
                CMP  R0 4
                BEQ  case_0
                CMP  R0 3
                BEQ  case_1
                BRA  default
          case: LOAD R0 R0 ; NOOP
                    LOAD R0 [GB+svar_displaySwitch]
                ADD  R0 1
                PUSH R0
                    LOAD R0 [R5+-2]
                DIV  R0 100
                LOAD R0 R0
                PUSH R0
                BRS  fn_enable_digit
                ADD  SP 2
                LOAD R0 R0
                BRA  switchEnd
        case_0: LOAD R0 R0 ; NOOP
                    LOAD R0 [GB+svar_displaySwitch]
                ADD  R0 1
                PUSH R0
                        LOAD R0 [R5+-2]
                    MOD  R0 100
                    LOAD R0 R0
                DIV  R0 10
                LOAD R0 R0
                PUSH R0
                BRS  fn_enable_digit
                ADD  SP 2
                LOAD R0 R0
                BRA  switchEnd
        case_1: LOAD R0 R0 ; NOOP
                    LOAD R0 [GB+svar_displaySwitch]
                ADD  R0 1
                PUSH R0
                    LOAD R0 [R5+-2]
                MOD  R0 10
                LOAD R0 R0
                PUSH R0
                BRS  fn_enable_digit
                ADD  SP 2
                LOAD R0 R0
                BRA  switchEnd
       default: LOAD R0 R0 ; NOOP
                BRA  switchEnd
     switchEnd: LOAD R0 R0 ; NOOP
fne_displayAdconvsVal:LOAD SP R5
            PULL R5
            RTS

fn___int_tmrIntHandler:PUSH R5
            LOAD R5 SP
            SUB  SP 8
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
                LOAD R0 [GB+svar_timerDelta]
                PUSH R0
                LOAD R0 [R5+-1]
                PULL R1
                STOR R1 [R0]
                BRS  fn_startstopStep
                STOR R0 [R5+-4]
                BRS  fn_abortStep
                STOR R0 [R5+-5]
                BRS  fn_whiteDetectorStep
                STOR R0 [R5+-6]
                BRS  fn_blackDetectorStep
                STOR R0 [R5+-7]
                BRS  fn_colorDetectorStep
                STOR R0 [R5+-8]
                LOAD R0 [GB+svar_state]
                CMP  R0 0
                BEQ  case_2
                CMP  R0 1
                BEQ  case_3
                CMP  R0 2
                BEQ  case_4
                CMP  R0 3
                BEQ  case_5
                CMP  R0 4
                BEQ  case_6
                CMP  R0 5
                BEQ  case_7
                CMP  R0 6
                BEQ  case_8
                CMP  R0 7
                BEQ  case_9
                BRA  default_0
        case_2: LOAD R0 R0 ; NOOP
                    LOAD R0 [R5+-4]
                        BEQ  fi
                        LOAD R0 1
                        LOAD R1 GB
                        ADD  R1 svar_state
                        STOR R0 [R1]
                    fi: LOAD R0 R0 ; NOOP
                BRA  switchEnd_0
        case_3: LOAD R0 R0 ; NOOP
                    LOAD R0 [R5+-4]
                        BEQ  fi_0
                        LOAD R0 2
                        LOAD R1 GB
                        ADD  R1 svar_state
                        STOR R0 [R1]
                  fi_0: LOAD R0 R0 ; NOOP
                BRA  switchEnd_0
        case_4: LOAD R0 R0 ; NOOP
                LOAD R0 1
                LOAD R1 GB
                ADD  R1 svar_pushStateCnt
                PUSH R1
                LOAD R1 [R1]
                ADD  R1 R0
                PULL R0
                STOR R1 [R0]
                        LOAD R0 [GB+svar_pushStateCnt]
                    PUSH R0
                        LOAD R0 [GB+svar_pushStateThreshold]
                        PULL R1
                        CMP  R1 R0
                        BGT  cmpTrue
                        LOAD R1 0
                        BRA  cmpEnd
               cmpTrue: LOAD R1 1
                cmpEnd: LOAD R1 R1 ; NOOP
                        BEQ  fi_1
                        LOAD R0 1
                        LOAD R1 GB
                        ADD  R1 svar_state
                        STOR R0 [R1]
                        LOAD R0 0
                        LOAD R1 GB
                        ADD  R1 svar_pushStateCnt
                        STOR R0 [R1]
                        BRA  switchEnd_0
                  fi_1: LOAD R0 R0 ; NOOP
                    LOAD R0 [R5+-4]
                        BEQ  fi_2
                        LOAD R0 5
                        LOAD R1 GB
                        ADD  R1 svar_state
                        STOR R0 [R1]
                        LOAD R0 0
                        LOAD R1 GB
                        ADD  R1 svar_pushStateCnt
                        STOR R0 [R1]
                        BRA  switchEnd_0
                  fi_2: LOAD R0 R0 ; NOOP
                            LOAD R0 [R5+-6]
                        BNE  lOp_true_0
                            LOAD R0 [R5+-7]
                        BNE  lOp_true_0
           lOp_false_0: LOAD R0 0
                        BRA  lOp_end_0
            lOp_true_0: LOAD R0 1
             lOp_end_0: LOAD R0 R0 ; NOOP
                    BNE  lOp_true
                        LOAD R0 [R5+-5]
                    BNE  lOp_true
         lOp_false: LOAD R0 0
                    BRA  lOp_end
          lOp_true: LOAD R0 1
           lOp_end: LOAD R0 R0 ; NOOP
                        BEQ  fi_3
                        LOAD R0 0
                        LOAD R1 GB
                        ADD  R1 svar_state
                        STOR R0 [R1]
                        LOAD R0 0
                        LOAD R1 GB
                        ADD  R1 svar_pushStateCnt
                        STOR R0 [R1]
                        BRA  switchEnd_0
                  fi_3: LOAD R0 R0 ; NOOP
                        LOAD R0 [R5+-8]
                    CMP  R0 2
                    BEQ  cmpTrue_0
                    LOAD R0 0
                    BRA  cmpEnd_0
         cmpTrue_0: LOAD R0 1
          cmpEnd_0: LOAD R0 R0 ; NOOP
                        BEQ  fi_4
                        LOAD R0 3
                        LOAD R1 GB
                        ADD  R1 svar_state
                        STOR R0 [R1]
                        LOAD R0 0
                        LOAD R1 GB
                        ADD  R1 svar_pushStateCnt
                        STOR R0 [R1]
                        BRA  switchEnd_0
                  fi_4: LOAD R0 R0 ; NOOP
                        LOAD R0 [R5+-8]
                    CMP  R0 1
                    BEQ  cmpTrue_1
                    LOAD R0 0
                    BRA  cmpEnd_1
         cmpTrue_1: LOAD R0 1
          cmpEnd_1: LOAD R0 R0 ; NOOP
                        BEQ  fi_5
                        LOAD R0 4
                        LOAD R1 GB
                        ADD  R1 svar_state
                        STOR R0 [R1]
                        LOAD R0 0
                        LOAD R1 GB
                        ADD  R1 svar_pushStateCnt
                        STOR R0 [R1]
                        BRA  switchEnd_0
                  fi_5: LOAD R0 R0 ; NOOP
                BRA  switchEnd_0
        case_5: LOAD R0 R0 ; NOOP
                    LOAD R0 [R5+-4]
                        BEQ  fi_6
                        LOAD R0 6
                        LOAD R1 GB
                        ADD  R1 svar_state
                        STOR R0 [R1]
                        BRA  switchEnd_0
                  fi_6: LOAD R0 R0 ; NOOP
                    LOAD R0 [R5+-6]
                        BEQ  fi_7
                        LOAD R0 2
                        LOAD R1 GB
                        ADD  R1 svar_state
                        STOR R0 [R1]
                        BRA  switchEnd_0
                  fi_7: LOAD R0 R0 ; NOOP
                    LOAD R0 [R5+-5]
                        BEQ  fi_8
                        LOAD R0 0
                        LOAD R1 GB
                        ADD  R1 svar_state
                        STOR R0 [R1]
                        BRA  switchEnd_0
                  fi_8: LOAD R0 R0 ; NOOP
                BRA  switchEnd_0
        case_6: LOAD R0 R0 ; NOOP
                    LOAD R0 [R5+-4]
                        BEQ  fi_9
                        LOAD R0 7
                        LOAD R1 GB
                        ADD  R1 svar_state
                        STOR R0 [R1]
                        BRA  switchEnd_0
                  fi_9: LOAD R0 R0 ; NOOP
                    LOAD R0 [R5+-7]
                        BEQ  fi_10
                        LOAD R0 2
                        LOAD R1 GB
                        ADD  R1 svar_state
                        STOR R0 [R1]
                        BRA  switchEnd_0
                 fi_10: LOAD R0 R0 ; NOOP
                    LOAD R0 [R5+-5]
                        BEQ  fi_11
                        LOAD R0 0
                        LOAD R1 GB
                        ADD  R1 svar_state
                        STOR R0 [R1]
                        BRA  switchEnd_0
                 fi_11: LOAD R0 R0 ; NOOP
                BRA  switchEnd_0
        case_7: LOAD R0 R0 ; NOOP
                LOAD R0 1
                LOAD R1 GB
                ADD  R1 svar_pushStateCnt
                PUSH R1
                LOAD R1 [R1]
                ADD  R1 R0
                PULL R0
                STOR R1 [R0]
                        LOAD R0 [GB+svar_pushStateCnt]
                    PUSH R0
                        LOAD R0 [GB+svar_pushStateThreshold]
                        PULL R1
                        CMP  R1 R0
                        BGT  cmpTrue_2
                        LOAD R1 0
                        BRA  cmpEnd_2
             cmpTrue_2: LOAD R1 1
              cmpEnd_2: LOAD R1 R1 ; NOOP
                        BEQ  fi_12
                        LOAD R0 1
                        LOAD R1 GB
                        ADD  R1 svar_state
                        STOR R0 [R1]
                        LOAD R0 0
                        LOAD R1 GB
                        ADD  R1 svar_pushStateCnt
                        STOR R0 [R1]
                        BRA  switchEnd_0
                 fi_12: LOAD R0 R0 ; NOOP
                            LOAD R0 [R5+-6]
                        BNE  lOp_true_2
                            LOAD R0 [R5+-7]
                        BNE  lOp_true_2
           lOp_false_2: LOAD R0 0
                        BRA  lOp_end_2
            lOp_true_2: LOAD R0 1
             lOp_end_2: LOAD R0 R0 ; NOOP
                    BNE  lOp_true_1
                        LOAD R0 [R5+-5]
                    BNE  lOp_true_1
       lOp_false_1: LOAD R0 0
                    BRA  lOp_end_1
        lOp_true_1: LOAD R0 1
         lOp_end_1: LOAD R0 R0 ; NOOP
                        BEQ  fi_13
                        LOAD R0 0
                        LOAD R1 GB
                        ADD  R1 svar_state
                        STOR R0 [R1]
                        BRA  switchEnd_0
                 fi_13: LOAD R0 R0 ; NOOP
                        LOAD R0 [R5+-8]
                    CMP  R0 2
                    BEQ  cmpTrue_3
                    LOAD R0 0
                    BRA  cmpEnd_3
         cmpTrue_3: LOAD R0 1
          cmpEnd_3: LOAD R0 R0 ; NOOP
                        BEQ  fi_14
                        LOAD R0 6
                        LOAD R1 GB
                        ADD  R1 svar_state
                        STOR R0 [R1]
                        BRA  switchEnd_0
                 fi_14: LOAD R0 R0 ; NOOP
                        LOAD R0 [R5+-8]
                    CMP  R0 1
                    BEQ  cmpTrue_4
                    LOAD R0 0
                    BRA  cmpEnd_4
         cmpTrue_4: LOAD R0 1
          cmpEnd_4: LOAD R0 R0 ; NOOP
                        BEQ  fi_15
                        LOAD R0 7
                        LOAD R1 GB
                        ADD  R1 svar_state
                        STOR R0 [R1]
                        BRA  switchEnd_0
                 fi_15: LOAD R0 R0 ; NOOP
                BRA  switchEnd_0
        case_8: LOAD R0 R0 ; NOOP
                    LOAD R0 [R5+-6]
                        BEQ  fi_16
                        LOAD R0 1
                        LOAD R1 GB
                        ADD  R1 svar_state
                        STOR R0 [R1]
                        BRA  switchEnd_0
                 fi_16: LOAD R0 R0 ; NOOP
                    LOAD R0 [R5+-5]
                        BEQ  fi_17
                        LOAD R0 0
                        LOAD R1 GB
                        ADD  R1 svar_state
                        STOR R0 [R1]
                        BRA  switchEnd_0
                 fi_17: LOAD R0 R0 ; NOOP
                BRA  switchEnd_0
        case_9: LOAD R0 R0 ; NOOP
                    LOAD R0 [R5+-7]
                        BEQ  fi_18
                        LOAD R0 1
                        LOAD R1 GB
                        ADD  R1 svar_state
                        STOR R0 [R1]
                        BRA  switchEnd_0
                 fi_18: LOAD R0 R0 ; NOOP
                    LOAD R0 [R5+-5]
                        BEQ  fi_19
                        LOAD R0 0
                        LOAD R1 GB
                        ADD  R1 svar_state
                        STOR R0 [R1]
                        BRA  switchEnd_0
                 fi_19: LOAD R0 R0 ; NOOP
                BRA  switchEnd_0
     default_0: LOAD R0 R0 ; NOOP
                BRA  switchEnd_0
   switchEnd_0: LOAD R0 R0 ; NOOP
                        LOAD R0 [GB+svar_displaySwitch]
                    CMP  R0 0
                    BEQ  cmpTrue_5
                    LOAD R0 0
                    BRA  cmpEnd_5
         cmpTrue_5: LOAD R0 1
          cmpEnd_5: LOAD R0 R0 ; NOOP
                    BEQ  fi_20
                        LOAD R0 [GB+svar_displaySwitch]
                    ADD  R0 1
                    PUSH R0
                    LOAD R0 [GB+svar_state]
                    PUSH R0
                    BRS  fn_enable_digit
                    ADD  SP 2
                    LOAD R0 R0
             fi_20: LOAD R0 R0 ; NOOP
                BRS  fn_displayAdconvsVal
                LOAD R0 1
                LOAD R1 GB
                ADD  R1 svar_displaySwitch
                PUSH R1
                LOAD R1 [R1]
                ADD  R1 R0
                PULL R0
                STOR R1 [R0]
                LOAD R0 6
                LOAD R1 GB
                ADD  R1 svar_displaySwitch
                PUSH R1
                LOAD R1 [R1]
                MOD  R1 R0
                PULL R0
                STOR R1 [R0]
                    LOAD R0 [GB+svar_switchOutput]
                    BEQ  not_false
          not_true: LOAD R0 0
                    BRA  not_end
         not_false: LOAD R0 1
           not_end: LOAD R0 R0 ; NOOP
                        BEQ  el
                        LOAD R0 [GB+svar_state]
                        PUSH R0
                        BRS  fn_lightsStep
                        ADD  SP 1
                        LOAD R0 R0
                        LOAD R0 1
                        LOAD R1 GB
                        ADD  R1 svar_switchOutput
                        STOR R0 [R1]
                        BRA  fi_21
                    el: LOAD R0 [GB+svar_state]
                        PUSH R0
                        BRS  fn_motorStep
                        ADD  SP 1
                        LOAD R0 R0
                        LOAD R0 0
                        LOAD R1 GB
                        ADD  R1 svar_switchOutput
                        STOR R0 [R1]
                 fi_21: LOAD R0 R0 ; NOOP
                BRS  fn_updateVal
                SETI 8
            BRA  fne___int_tmrIntHandler
fne___int_tmrIntHandler:LOAD SP R5
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
                LOAD R0 fn___int_tmrIntHandler
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
  fne_main: LOAD R0 R0 ; NOOP
            PULL R5
            RTS

fn_updateVal:PUSH R5
            LOAD R5 SP
            SUB  SP 1
                LOAD R0 262135
                STOR R0 [R5+-1]
                LOAD R0 [R5+-1]
                LOAD R0 [R0]
                LOAD R1 GB
                ADD  R1 svar_prevValue
                STOR R0 [R1]
fne_updateVal:LOAD SP R5
            PULL R5
            RTS

fn_startstopStep:PUSH R5
            LOAD R5 SP
            SUB  SP 4
                LOAD R0 262135
                STOR R0 [R5+-1]
                LOAD R0 [R5+-1]
                LOAD R0 [R0]
                STOR R0 [R5+-2]
                    LOAD R0 [R5+-2]
                AND  R0 1
                STOR R0 [R5+-3]
                    LOAD R0 [GB+svar_prevValue]
                AND  R0 1
                STOR R0 [R5+-4]
                        LOAD R0 [R5+-4]
                    PUSH R0
                        LOAD R0 [R5+-3]
                        XOR  R0 %1
                        PULL R1
                        AND  R1 R0
                    BEQ  fi_22
                        LOAD R0 1
                    BRA  fne_startstopStep
             fi_22: LOAD R0 R0 ; NOOP
                LOAD R0 0
            BRA  fne_startstopStep
fne_startstopStep:LOAD SP R5
            PULL R5
            RTS

fn_abortStep:PUSH R5
            LOAD R5 SP
            SUB  SP 4
                LOAD R0 262135
                STOR R0 [R5+-1]
                LOAD R0 [R5+-1]
                LOAD R0 [R0]
                STOR R0 [R5+-2]
                    LOAD R0 [R5+-2]
                AND  R0 2
                STOR R0 [R5+-3]
                    LOAD R0 [GB+svar_prevValue]
                AND  R0 2
                STOR R0 [R5+-4]
                        LOAD R0 [R5+-4]
                    PUSH R0
                        LOAD R0 [R5+-3]
                        XOR  R0 %1
                        PULL R1
                        AND  R1 R0
                    BEQ  fi_23
                        LOAD R0 1
                    BRA  fne_abortStep
             fi_23: LOAD R0 R0 ; NOOP
                LOAD R0 0
            BRA  fne_abortStep
fne_abortStep:LOAD SP R5
            PULL R5
            RTS

fn_whiteDetectorStep:PUSH R5
            LOAD R5 SP
            SUB  SP 4
                LOAD R0 262135
                STOR R0 [R5+-1]
                LOAD R0 [R5+-1]
                LOAD R0 [R0]
                STOR R0 [R5+-2]
                    LOAD R0 [R5+-2]
                AND  R0 4
                STOR R0 [R5+-3]
                    LOAD R0 [GB+svar_prevValue]
                AND  R0 4
                STOR R0 [R5+-4]
                        LOAD R0 [R5+-4]
                        XOR  R0 %1
                    PUSH R0
                        LOAD R0 [R5+-3]
                        PULL R1
                        AND  R1 R0
                    BEQ  fi_24
                        LOAD R0 1
                    BRA  fne_whiteDetectorStep
             fi_24: LOAD R0 R0 ; NOOP
                LOAD R0 0
            BRA  fne_whiteDetectorStep
fne_whiteDetectorStep:LOAD SP R5
            PULL R5
            RTS

fn_blackDetectorStep:PUSH R5
            LOAD R5 SP
            SUB  SP 4
                LOAD R0 262135
                STOR R0 [R5+-1]
                LOAD R0 [R5+-1]
                LOAD R0 [R0]
                STOR R0 [R5+-2]
                    LOAD R0 [R5+-2]
                AND  R0 8
                STOR R0 [R5+-3]
                    LOAD R0 [GB+svar_prevValue]
                AND  R0 8
                STOR R0 [R5+-4]
                        LOAD R0 [R5+-4]
                        XOR  R0 %1
                    PUSH R0
                        LOAD R0 [R5+-3]
                        PULL R1
                        AND  R1 R0
                    BEQ  fi_25
                        LOAD R0 1
                    BRA  fne_blackDetectorStep
             fi_25: LOAD R0 R0 ; NOOP
                LOAD R0 0
            BRA  fne_blackDetectorStep
fne_blackDetectorStep:LOAD SP R5
            PULL R5
            RTS

fn_lightsStep:PUSH R5
            LOAD R5 SP
            SUB  SP 1
                LOAD R0 262139
                STOR R0 [R5+-1]
                        LOAD R0 [R5+2]
                    CMP  R0 0
                    BNE  cmpTrue_6
                    LOAD R0 0
                    BRA  cmpEnd_6
         cmpTrue_6: LOAD R0 1
          cmpEnd_6: LOAD R0 R0 ; NOOP
                        BEQ  el_0
                        LOAD R0 112
                        PUSH R0
                        LOAD R0 [R5+-1]
                        PULL R1
                        PUSH R0
                        LOAD R0 [R0]
                        OR   R0 R1
                        PULL R1
                        STOR R0 [R1]
                        BRA  fi_26
                  el_0: LOAD R0 143
                        PUSH R0
                        LOAD R0 [R5+-1]
                        PULL R1
                        PUSH R0
                        LOAD R0 [R0]
                        AND  R0 R1
                        PULL R1
                        STOR R0 [R1]
                 fi_26: LOAD R0 R0 ; NOOP
            BRA  fne_lightsStep
fne_lightsStep:LOAD SP R5
            PULL R5
            RTS

fn_motorStep:PUSH R5
            LOAD R5 SP
            SUB  SP 1
                LOAD R0 10
                LOAD R1 GB
                ADD  R1 svar_motorCnt
                PUSH R1
                LOAD R1 [R1]
                ADD  R1 R0
                PULL R0
                STOR R1 [R0]
                LOAD R0 [GB+svar_motorMax]
                LOAD R1 GB
                ADD  R1 svar_motorCnt
                PUSH R1
                LOAD R1 [R1]
                MOD  R1 R0
                PULL R0
                STOR R1 [R0]
                LOAD R0 262139
                STOR R0 [R5+-1]
                        LOAD R0 [GB+svar_motorCnt]
                    PUSH R0
                        LOAD R0 [GB+svar_motorCntThreshold]
                        PULL R1
                        CMP  R1 R0
                        BLT  cmpTrue_7
                        LOAD R1 0
                        BRA  cmpEnd_7
             cmpTrue_7: LOAD R1 1
              cmpEnd_7: LOAD R1 R1 ; NOOP
                        BEQ  fi_27
                        LOAD R0 [R5+2]
                        CMP  R0 2
                        BEQ  case_10
                        CMP  R0 3
                        BEQ  case_11
                        CMP  R0 4
                        BEQ  case_12
                        CMP  R0 5
                        BEQ  case_13
                        CMP  R0 6
                        BEQ  case_14
                        CMP  R0 7
                        BEQ  case_15
                        BRA  default_1
               case_10: LOAD R0 R0 ; NOOP
                        LOAD R0 252
                        PUSH R0
                        LOAD R0 [R5+-1]
                        PULL R1
                        PUSH R0
                        LOAD R0 [R0]
                        AND  R0 R1
                        PULL R1
                        STOR R0 [R1]
                        LOAD R0 4
                        PUSH R0
                        LOAD R0 [R5+-1]
                        PULL R1
                        PUSH R0
                        LOAD R0 [R0]
                        OR   R0 R1
                        PULL R1
                        STOR R0 [R1]
                        BRA  switchEnd_1
               case_11: LOAD R0 R0 ; NOOP
                        LOAD R0 249
                        PUSH R0
                        LOAD R0 [R5+-1]
                        PULL R1
                        PUSH R0
                        LOAD R0 [R0]
                        AND  R0 R1
                        PULL R1
                        STOR R0 [R1]
                        LOAD R0 1
                        PUSH R0
                        LOAD R0 [R5+-1]
                        PULL R1
                        PUSH R0
                        LOAD R0 [R0]
                        OR   R0 R1
                        PULL R1
                        STOR R0 [R1]
                        BRA  switchEnd_1
               case_12: LOAD R0 R0 ; NOOP
                        LOAD R0 250
                        PUSH R0
                        LOAD R0 [R5+-1]
                        PULL R1
                        PUSH R0
                        LOAD R0 [R0]
                        AND  R0 R1
                        PULL R1
                        STOR R0 [R1]
                        LOAD R0 2
                        PUSH R0
                        LOAD R0 [R5+-1]
                        PULL R1
                        PUSH R0
                        LOAD R0 [R0]
                        OR   R0 R1
                        PULL R1
                        STOR R0 [R1]
                        BRA  switchEnd_1
               case_13: LOAD R0 R0 ; NOOP
                        LOAD R0 252
                        PUSH R0
                        LOAD R0 [R5+-1]
                        PULL R1
                        PUSH R0
                        LOAD R0 [R0]
                        AND  R0 R1
                        PULL R1
                        STOR R0 [R1]
                        LOAD R0 4
                        PUSH R0
                        LOAD R0 [R5+-1]
                        PULL R1
                        PUSH R0
                        LOAD R0 [R0]
                        OR   R0 R1
                        PULL R1
                        STOR R0 [R1]
                        BRA  switchEnd_1
               case_14: LOAD R0 R0 ; NOOP
                        LOAD R0 249
                        PUSH R0
                        LOAD R0 [R5+-1]
                        PULL R1
                        PUSH R0
                        LOAD R0 [R0]
                        AND  R0 R1
                        PULL R1
                        STOR R0 [R1]
                        LOAD R0 1
                        PUSH R0
                        LOAD R0 [R5+-1]
                        PULL R1
                        PUSH R0
                        LOAD R0 [R0]
                        OR   R0 R1
                        PULL R1
                        STOR R0 [R1]
                        BRA  switchEnd_1
               case_15: LOAD R0 R0 ; NOOP
                        LOAD R0 250
                        PUSH R0
                        LOAD R0 [R5+-1]
                        PULL R1
                        PUSH R0
                        LOAD R0 [R0]
                        AND  R0 R1
                        PULL R1
                        STOR R0 [R1]
                        LOAD R0 2
                        PUSH R0
                        LOAD R0 [R5+-1]
                        PULL R1
                        PUSH R0
                        LOAD R0 [R0]
                        OR   R0 R1
                        PULL R1
                        STOR R0 [R1]
                        BRA  switchEnd_1
             default_1: LOAD R0 R0 ; NOOP
                        BRA  switchEnd_1
           switchEnd_1: LOAD R0 R0 ; NOOP
                 fi_27: LOAD R0 R0 ; NOOP
            BRA  fne_motorStep
fne_motorStep:LOAD SP R5
            PULL R5
            RTS

fn_colorDetectorStep:PUSH R5
            LOAD R5 SP
            SUB  SP 2
                LOAD R0 262134
                STOR R0 [R5+-1]
                    LOAD R0 [R5+-1]
                    LOAD R0 [R0]
                AND  R0 65280
                STOR R0 [R5+-2]
                    LOAD R0 [R5+-2]
                AND  R0 %10
                DIV  R0 2
                AND  R0 %011111111111111111
                DIV  R0 128
                LOAD R1 R5
                ADD  R1 -2
                STOR R0 [R1]
                        LOAD R0 [R5+-2]
                    PUSH R0
                        LOAD R0 [GB+svar_thresholdWhite]
                        PULL R1
                        CMP  R1 R0
                        BLT  cmpTrue_8
                        LOAD R1 0
                        BRA  cmpEnd_8
             cmpTrue_8: LOAD R1 1
              cmpEnd_8: LOAD R1 R1 ; NOOP
                    BEQ  fi_29
                        LOAD R0 0
                        LOAD R1 GB
                        ADD  R1 svar_countsBlack
                        STOR R0 [R1]
                        LOAD R0 1
                        LOAD R1 GB
                        ADD  R1 svar_countsWhite
                        PUSH R1
                        LOAD R1 [R1]
                        ADD  R1 R0
                        PULL R0
                        STOR R1 [R0]
                                LOAD R0 [GB+svar_countsWhite]
                            PUSH R0
                                LOAD R0 [GB+svar_thresholdCounts]
                                PULL R1
                                CMP  R1 R0
                                BLT  cmpTrue_9
                                LOAD R1 0
                                BRA  cmpEnd_9
                     cmpTrue_9: LOAD R1 1
                      cmpEnd_9: LOAD R1 R1 ; NOOP
                        BEQ  fi_28
                            LOAD R0 0
                        BRA  fne_colorDetectorStep
                 fi_28: LOAD R0 R0 ; NOOP
                        LOAD R0 0
                        LOAD R1 GB
                        ADD  R1 svar_countsWhite
                        STOR R0 [R1]
                        LOAD R0 2
                    BRA  fne_colorDetectorStep
             fi_29: LOAD R0 R0 ; NOOP
                        LOAD R0 [R5+-2]
                    PUSH R0
                        LOAD R0 [GB+svar_thresholdBlack]
                        PULL R1
                        CMP  R1 R0
                        BLT  cmpTrue_10
                        LOAD R1 0
                        BRA  cmpEnd_10
            cmpTrue_10: LOAD R1 1
             cmpEnd_10: LOAD R1 R1 ; NOOP
                    BEQ  fi_31
                        LOAD R0 0
                        LOAD R1 GB
                        ADD  R1 svar_countsWhite
                        STOR R0 [R1]
                        LOAD R0 1
                        LOAD R1 GB
                        ADD  R1 svar_countsBlack
                        PUSH R1
                        LOAD R1 [R1]
                        ADD  R1 R0
                        PULL R0
                        STOR R1 [R0]
                                LOAD R0 [GB+svar_countsBlack]
                            PUSH R0
                                LOAD R0 [GB+svar_thresholdCounts]
                                PULL R1
                                CMP  R1 R0
                                BLT  cmpTrue_11
                                LOAD R1 0
                                BRA  cmpEnd_11
                    cmpTrue_11: LOAD R1 1
                     cmpEnd_11: LOAD R1 R1 ; NOOP
                        BEQ  fi_30
                            LOAD R0 0
                        BRA  fne_colorDetectorStep
                 fi_30: LOAD R0 R0 ; NOOP
                        LOAD R0 0
                        LOAD R1 GB
                        ADD  R1 svar_countsBlack
                        STOR R0 [R1]
                        LOAD R0 1
                    BRA  fne_colorDetectorStep
             fi_31: LOAD R0 R0 ; NOOP
                LOAD R0 0
                LOAD R1 GB
                ADD  R1 svar_countsWhite
                STOR R0 [R1]
                LOAD R0 0
                LOAD R1 GB
                ADD  R1 svar_countsBlack
                STOR R0 [R1]
                LOAD R0 0
            BRA  fne_colorDetectorStep
fne_colorDetectorStep:LOAD SP R5
            PULL R5
            RTS

sfn_segment_mask_1:PUSH R5
            LOAD R5 SP
                LOAD R0 [R5+2]
                CMP  R0 0
                BEQ  case_16
            CMP  R0 1
            BEQ  case_17
            CMP  R0 2
            BEQ  case_18
            CMP  R0 3
            BEQ  case_19
            CMP  R0 4
            BEQ  case_20
            CMP  R0 5
            BEQ  case_21
            CMP  R0 6
            BEQ  case_22
            CMP  R0 7
            BEQ  case_23
            CMP  R0 8
            BEQ  case_24
            CMP  R0 9
            BEQ  case_25
            BRA  switchEnd_2
       case_16: LOAD R0 R0 ; NOOP
                LOAD R0 126
            BRA  sfne_segment_mask_1
   case_17: LOAD R0 R0 ; NOOP
                LOAD R0 48
            BRA  sfne_segment_mask_1
   case_18: LOAD R0 R0 ; NOOP
                LOAD R0 109
            BRA  sfne_segment_mask_1
   case_19: LOAD R0 R0 ; NOOP
                LOAD R0 121
            BRA  sfne_segment_mask_1
   case_20: LOAD R0 R0 ; NOOP
                LOAD R0 51
            BRA  sfne_segment_mask_1
   case_21: LOAD R0 R0 ; NOOP
                LOAD R0 91
            BRA  sfne_segment_mask_1
   case_22: LOAD R0 R0 ; NOOP
                LOAD R0 95
            BRA  sfne_segment_mask_1
   case_23: LOAD R0 R0 ; NOOP
                LOAD R0 112
            BRA  sfne_segment_mask_1
   case_24: LOAD R0 R0 ; NOOP
                LOAD R0 127
            BRA  sfne_segment_mask_1
   case_25: LOAD R0 R0 ; NOOP
                LOAD R0 123
            BRA  sfne_segment_mask_1
switchEnd_2:LOAD R0 R0 ; NOOP
                LOAD R0 255
            BRA  sfne_segment_mask_1
sfne_segment_mask_1:LOAD R0 R0 ; NOOP
            PULL R5
            RTS

fn_enable_digit:PUSH R5
            LOAD R5 SP
            SUB  SP 2
                LOAD R0 262137
                STOR R0 [R5+-1]
                LOAD R0 262136
                STOR R0 [R5+-2]
                LOAD R0 [R5+2]
                PUSH R0
                BRS  sfn_segment_mask_1
                ADD  SP 1
                LOAD R0 R0
                PUSH R0
                LOAD R0 [R5+-2]
                PULL R1
                STOR R1 [R0]
                    LOAD R0 [R5+3]
                    BEQ  el_1
                        LOAD R0 1
                    PUSH R0
                            LOAD R0 [R5+3]
                        SUB  R0 1
                        PULL R1
                        CMP  R0 0
                        BLE  shift_done
            shift_loop: MULS R1 2
                        SUB  R0 1
            shift_done: BGT  shift_loop
                        LOAD R1 R1
                        BRA  fi_32
              el_1: LOAD R0 0
                    LOAD R1 R0
             fi_32: LOAD R1 R1 ; NOOP
                LOAD R0 [R5+-1]
                STOR R1 [R0]
fne_enable_digit:LOAD SP R5
            PULL R5
            RTS


@END
