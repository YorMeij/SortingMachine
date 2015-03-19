#include "detectors.h"

// Disk color thresholds

static int thresholdBlack = 250;
static int thresholdWhite = 220;

static int thresholdCounts = 500; // Time period we need to make sure that the disk was indeed detected
static int countsBlack = 0;
static int countsWhite = 0;

int colorDetectorStep(void){

    /**
     * Detects disk color and returns it
     */

    int* input = ADCONVS;
    int value = *input & 0xff00;
    value = value >> 8;

    if (value < thresholdWhite){

        countsBlack = 0;
        countsWhite += 1;

        if (countsWhite < thresholdCounts) // We have not waited enough
            return DISK_NONE;

        countsWhite = 0; // Reset the counter, return disk color
        return DISK_WHITE;
    }
    if (value < thresholdBlack){

        countsWhite = 0;
        countsBlack += 1;

        if (countsBlack < thresholdCounts) // We have not waited enough
            return DISK_NONE;

        countsBlack = 0;
        return DISK_BLACK; // Reset the counter, return disk color
    }

    // No disk detected at all

    countsWhite = 0;
    countsBlack = 0;
    return DISK_NONE;
}
