#include "../defines.h"

static int cs = 0;
static int delta = 10;
static int v = 0;

/**
 * Timer interrupt example
 */

void __int_nop(void){

    int *tmr = TIMER;
    int tmrVal = *tmr;

    tmrVal *= -1;
    *tmr = tmrVal; // mem[tmr] = 0;
    *tmr = delta; // mem[tmr] = 10;

    v += 1; // do something

    // while(1){};

    __seti__(8);
    return;
}

void main(void){

    GETCS(cs);
    INITINTERRUPT(__int_nop, cs, 2*8);
    __seti__(8);

    while(1){};
    return 0;
}
