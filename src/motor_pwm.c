#include "motor_pwm.h"

static int motorCnt = 0;
static int motorCntThreshold = 75;
static int motorMax = 100;

void motorStep(int state){

    motorCnt += 1;
    motorCnt %= motorMax;

    int *out = OUTPUT;
    *out &= 0xf8; // Null out three rightmost bits

    if (motorCnt < motorCntThreshold){

        switch (state){

            case PUSH_STATE:
                *out |= 0x4; // Set motor signal to high
                break;
            case CONVEY_WHITE_STATE:
                *out |= 0x1; // H-bridge white high
                break;
            case CONVEY_BLACK_STATE:
                *out |= 0x2; // H-bridge black high
                break;
            case PUSH_STOP_STATE:
                *out |= 0x4; // Set motor signal to high
                break;
            case CONVEY_WHITE_STOP_STATE:
                *out |= 0x1; // H-bridge white high
                break;
            case CONVEY_BLACK_STOP_STATE:
                *out |= 0x2; // H-bridge black high
                break;
            default:
                break;
        }
    }
    return;
}
