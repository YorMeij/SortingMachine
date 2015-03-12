#include "../defines.h"

static int cs;
static int delta = 10;
static int max = 100;
static int cnt = 0;
static int cntThreshold = 50;

void __int_handler(void){

    int *tmr = TIMER;
    int tmrVal = *tmr;

    int *out = OUTPUT;

    tmrVal *= -1;
    *tmr = tmrVal; // mem[tmr] = 0;
    *tmr = delta; // mem[tmr] = 10;

    cnt %= max;
    cnt += 1;

    if (cnt < cntThreshold){

        *out = 1;
    }
    else{

        *out = 0;
    }

    __seti__(8);

    return;
}

void main(void){

    GETCS(cs);
    INITINTERRUPT(__int_handler, cs, 16);
    __seti__(8);

    while (1){};

    return;
}
