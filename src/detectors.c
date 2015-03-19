#include "detectors.h"

static int thresholdBlack = 250;
static int thresholdWhite = 220;
static int thresholdCounts = 1000;
static int countsBlack = 0;
static int countsWhite = 0;

int colorDetectorStep(void){

    int* input = ADCONVS;
    int value = *input & 0xff00;
    value = value >> 8;


    if (value < thresholdWhite){

        countsBlack = 0;
        countsWhite += 1;

        if (countsWhite < thresholdCounts)
            return DISK_NONE;

        countsWhite = 0;
        return DISK_WHITE;
    }
    if (value < thresholdBlack){

        countsWhite = 0;
        countsBlack += 1;

        if (countsBlack < thresholdCounts)
            return DISK_NONE;

        countsBlack = 0;
        return DISK_BLACK;
    }

    countsWhite = 0;
    countsBlack = 0;
    return DISK_NONE;
}
