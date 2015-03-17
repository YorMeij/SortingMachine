#include "detectors.h"

static int thresholdBlack = 250;
static int thresholdWhite = 180;

void sleep(int steps){

    // 1 step per 0.1 ms

    int *tmr = TIMER;
    int tmrVal = *tmr; // Get current timer value

    *tmr = -tmrVal; // *tmr = 0
    *tmr = steps;

    while (*tmr > 0);

    *tmr = -(*tmr); // Makes sure *tmr == 0

    *tmr = tmrVal; // Restore old timer value
}

void displayColorDetectorValue(int val){

    if (val >= 100){

        enable_digit(val / 100, 6);
        sleep(100);
    }
    if (val >= 10){

        enable_digit((val % 100) / 10, 5);
        sleep(100);
    }
    enable_digit(val % 10, 4);
}

int colorDetectorStep(void){

    int* input = ADCONVS;
    int value = *input & 0xff00;
    displayColorDetectorValue(value);

    if (value < thresholdWhite){

        return DISK_WHITE;
    }
    if (value < thresholdBlack){

        return DISK_BLACK;
    }
    return DISK_NONE;
}
