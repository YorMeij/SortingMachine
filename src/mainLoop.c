#include "mainLoop.h"
#include "detectors.h"
#include "lights.h"
#include "motor_pwm.h"
#include "input.h"
#include "enableLEDs.h"

static int cs = 0; // CS addr
static int timerDelta = 10; // Timer delta
static int state = REST_STATE; // Default state
static int switchOutput = 0; // Determines what current output is
static int displaySwitch = 0; // Determines what digit to display. 0 is leftmost, 5 is rightmost LED
static int pushStateCnt = 0; // Count how many cycles we spent in push state
static int pushStateThreshold = 5000; // Push state cycles threshold value

void displayAdconvsVal(void){

    /**
     * Displays adconvs value on 3 leftmost LEDs.
     */

    int *adconvs = ADCONVS;
    int val = *adconvs & 0xff00;
    val = val >> 8;

    switch (displaySwitch){

        case 5:
            enable_digit(val / 100, displaySwitch + 1); // Leftmost digit
            break;
        case 4:
            enable_digit((val % 100) / 10, displaySwitch + 1); // Midddle digit
            break;
        case 3:
            enable_digit(val % 10, displaySwitch + 1); // Rightmost digit
            break;
        default: // The time has not come
            break;
    }
}

void __int_tmrIntHandler(void){

    /**
     * Implements state machine. Gets called every time interrupt occurs.
     */

    // Timer stuff
    int *tmr = TIMER;
    int tmrVal = *tmr;

    int *out = OUTPUT;

    tmrVal *= -1;
    *tmr = tmrVal; // *tmr = 0
    *tmr = timerDelta; // *tmr = timerDelta;

    // Read inputs

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
            }
            break;

        case PUSH_STATE:
            pushStateCnt += 1;

            if (pushStateCnt > pushStateThreshold){
                state = REST_STATE;
                pushStateCnt = 0;
                break;
            }
            if (startStopReleased){
                state = PUSH_STOP_STATE;
                pushStateCnt = 0;
                break;
            }
            if (whiteDiskDetected || blackDiskDetected || abortReleased){
                state = TERMINATION_STATE;
                pushStateCnt = 0;
                break;
            }

            if (color == DISK_WHITE){
                state = CONVEY_WHITE_STATE;
                pushStateCnt = 0;
                break;
            }
            if (color == DISK_BLACK){
                state = CONVEY_BLACK_STATE;
                pushStateCnt = 0;
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
            if (blackDiskDetected){
                state = PUSH_STATE;
                break;
            }
            if (abortReleased){
                state = TERMINATION_STATE;
                break;
            }
            break;

        case PUSH_STOP_STATE:

            pushStateCnt += 1;

            if (pushStateCnt > pushStateThreshold){
                state = REST_STATE;
                pushStateCnt = 0;
                break;
            }

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

    if (displaySwitch == 0) // Display state if possible
        enable_digit(state, displaySwitch + 1);

    displayAdconvsVal(); // Display adconvs val

    displaySwitch += 1;
    displaySwitch %= 6;

    if (!switchOutput){ // Make sure we do not set outputs high too quickly
        lightsStep(state);
        switchOutput = 1;
    }
    else{
        motorStep(state);
        switchOutput = 0;
    }

    updateVal(); // Re-read input

    __seti__(8); // Re-enble interrupts
    return;
}

void main(void){

    GETCS(cs); // Get CS addr
    INITINTERRUPT(__int_tmrIntHandler, cs, 16); // Initialise interrupt
    __seti__(8); // Enable it

    while(1){}; // Bye-bye
}
