#include "mainLoop.h"
#include "detectors.h"
#include "lights.h"
#include "motor_pwm.h"
#include "input.h"

static int cs = 0;
static int timerDelta = 10;
static int state = REST_STATE;

void __int_tmrIntHandler(void){

    int *tmr = TIMER;
    int tmrVal = *tmr;

    int *out = OUTPUT;

    tmrVal *= -1;
    *tmr = tmrVal; // mem[tmr] = 0;
    *tmr = timerDelta; // mem[tmr] = 10;

    //
    int startStopReleased = startstopStep();
    int abortReleased = abortStep();
    int whiteDiskDetected = whiteDetectorStep();
    int blackDiskDetected = blackDetectorStep();

    int color = colorDetectorStep();

    switch (state){

        case TERMINATION_STATE:
            if (startStopReleased){
                state = REST_STATE;
            }
            break;

        case REST_STATE:
            if (startStopReleased){
                state = PUSH_STATE;
                // fixme: going back to rest state after some time
            }
            break;

        case PUSH_STATE:
            if (startStopReleased){
                state = PUSH_STOP_STATE;
                break;
            }
            if (whiteDiskDetected || blackDiskDetected || abortReleased){
                state = TERMINATION_STATE;
                break;
            }

            if (color == DISK_WHITE){
                state = CONVEY_WHITE_STATE;
                break;
            }
            if (color == DISK_BLACK){
                state = CONVEY_BLACK_STATE;
                break;
            }
            break;

        case CONVEY_WHITE_STATE:
            if (startStopReleased){
                state = CONVEY_WHITE_STOP_STATE;
                break;
            }
            if (whiteDiskDetected){
                state = PUSH_STATE;
                break;
            }
            if (abortReleased){
                state = TERMINATION_STATE;
                break;
            }
            break;

        case CONVEY_BLACK_STATE:
            if (startStopReleased){
                state = CONVEY_BLACK_STOP_STATE;
                break;
            }
            if (whiteDiskDetected){
                state = PUSH_STATE;
                break;
            }
            if (abortReleased){
                state = TERMINATION_STATE;
                break;
            }
            break;

        case PUSH_STOP_STATE:

            if (whiteDiskDetected || blackDiskDetected || abortReleased){
                state = TERMINATION_STATE;
                break;
            }

            if (color == DISK_WHITE){
                state = CONVEY_WHITE_STOP_STATE;
                break;
            }

            if (color == DISK_BLACK){
                state = CONVEY_BLACK_STOP_STATE;
                break;
            }
            break;

        case CONVEY_WHITE_STOP_STATE:

            if (whiteDiskDetected){
                state = REST_STATE;
                break;
            }
            if (abortReleased){
                state = TERMINATION_STATE;
                break;
            }
            break;

        case CONVEY_BLACK_STOP_STATE:

            if (blackDiskDetected){
                state = REST_STATE;
                break;
            }
            if (abortReleased){
                state = TERMINATION_STATE;
                break;
            }
            break;

        default:
            break;
    }

    motorStep(state);
    lightsStep(state);
    updateVal();

    __seti__(8);
    return;
}

void main(void){

    cs = GETCS(cs);
    INITINTERRUPT(__int_tmrIntHandler, cs, 16);
    __seti__(8);

    while(1){};
}
