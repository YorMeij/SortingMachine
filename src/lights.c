#include "lights.h"

void lightsStep(int state){

    int* out = OUTPUT;

    if (state != TERMINATION_STATE){

        *out |= 0x70;
    }
    else{

        *out &= 0x8f;
    }

    return;
}
