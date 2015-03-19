#include "input.h"

static int prevValue = 0;

void updateVal(void){

    /**
     * Re-read inputs
     */

    int *input = INPUT;

    prevValue = *input;
}

// The rest of the functions return 1 if corresponding button was pressed and released

int startstopStep(void){

    int *input = INPUT;

    int val = *input;

    int startStopB = val & 0x1;
    int startStopBPrev = prevValue & 0x1;

    if (startStopBPrev & ~startStopB){

        return 1;
    }
    return 0;
}

int abortStep(void){

    int *input = INPUT;

    int val = *input;

    int abortB = val & 0x2;
    int abortBPrev = prevValue & 0x2;

    if (abortBPrev & ~abortB){

        return 1;
    }
    return 0;
}

int whiteDetectorStep(void){

    int *input = INPUT;

    int val = *input;

    int whiteDetector = val & 0x4;
    int whiteDetectorPrev = prevValue & 0x4;

    if (~whiteDetectorPrev & whiteDetector){

        return 1;
    }
    return 0;
}

int blackDetectorStep(void){

    int *input = INPUT;

    int val = *input;

    int blackDetector = val & 0x8;
    int blackDetectorPrev = prevValue & 0x8;

    if (~blackDetectorPrev & blackDetector){

        return 1;
    }
    return 0;
}
