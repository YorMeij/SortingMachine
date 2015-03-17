#include "motor_pwm.h"

static int motorCnt = 0;
static int motorCntThreshold = 90;
static int motorMax = 100;

void motorStep(int state){

    motorCnt += 10;
    motorCnt %= motorMax;

    int *out = OUTPUT;

    if (motorCnt < motorCntThreshold){

        switch (state){

            case PUSH_STATE:
                *out &= 0xfc;
                *out |= 0x4; // Set motor signal to high
                break;
            case CONVEY_WHITE_STATE:
                *out &= 0xf9;
                *out |= 0x1; // H-bridge white high
                break;
            case CONVEY_BLACK_STATE:
                *out &= 0xfa;
                *out |= 0x2; // H-bridge black high
                break;
            case PUSH_STOP_STATE:
                *out &= 0xfc;
                *out |= 0x4; // Set motor signal to high
                break;
            case CONVEY_WHITE_STOP_STATE:
                *out &= 0xf9;
                *out |= 0x1; // H-bridge white high
                break;
            case CONVEY_BLACK_STOP_STATE:
                *out &= 0xfa;
                *out |= 0x2; // H-bridge black high
                break;
            default:
                break;
        }
    }
    return;
}
