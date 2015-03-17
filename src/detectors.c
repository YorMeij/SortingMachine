#include "detectors.h"

static int thresholdBlack = 250;
static int thresholdWhite = 180;

void sleep(void){

    int i = 0;
    while (i < 2000){
        i |= i; // sort of nop
        i += 1;
    }
}

void displayColorDetectorValue(int val){

    if (val >= 100){

        enable_digit(val / 100, 6);
        sleep();
    }
    if (val >= 10){

        enable_digit((val % 100) / 10, 5);
        sleep();
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
