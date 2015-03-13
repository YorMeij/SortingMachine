#include "../defines.h"

static int val = 0;
void main(void){

    int* adconvs = ADCONVS;

    while(1){

        val = *adconvs & 0xff00;
    }
}
