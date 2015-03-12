#include "detectors.h"

// fixme
static int thresholdBlack;
static int thresholdWhite;

int colorDetectorStep(void){

    int* input = ADCONVS;
    int value = *input & 0xff00;

    if (value < thresholdBlack){

        return DISK_NONE;
    }
    if (value < thresholdWhite){

        return DISK_BLACK;
    }
    return DISK_WHITE;
}
