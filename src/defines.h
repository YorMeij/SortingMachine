#ifndef H_DEFINES

    // Addresses
    #define CS           1      // code segment. We should get it in runtime, tho
    #define MEMSIZE     -1      // size of available memory
    #define DISPATCH    -2      // dispatch flag
    #define TIMER       -3      // system timer
    #define OVL         -4      // overload flags
    #define OUTPUT      -5      // 8 power outputs. ith bit corresponds to OUT_i
    #define LEDS        -6      // 3 LEDs
    #define DIGIT       -7      // display digit
    #define SEGMENT     -8      // display pattern
    #define INPUT       -9      // 8 buttons
    #define ADCONVS     -10     // 2 AD converters
    #define RXDATA      -11     // serial input data
    #define RXSTATE     -12     // serial input state
    #define TXDATA      -13     // serial output data
    #define TXSTATE     -14     // serial output state
    #define BAUDSEL     -15     // serial bit rate
    #define SWITCHES    -16     // 3 slide switches

    // Exception descriptor addresses
    #define RESET 0
    #define INTERRUPT1 1
    #define INTERRUPT2 2
    #define INTERRUPT3 3
    #define INTERRUPT4 4
    #define INTERRUPT5 5
    #define INTERRUPT6 6
    #define INTERRUPT7 7
    #define INTERRUPT8 8
    #define INTERRUPT9 9
    #define INTERRUPT10 10
    #define INTERRUPT11 11
    #define INTERRUPT12 12
    #define INTERRUPT13 13
    #define INTERRUPT14 14
    #define INTERRUPT15 15
    #define TRA0 16
    #define TRA1 17
    #define TREQ 18
    #define TRNE 19
    #define TRCS 20
    #define TRCC 21
    #define TRLS 22
    #define TRHI 23
    #define TRVC 24
    #define TRVS 25
    #define TRPL 26
    #define TRMI 27
    #define TRLT 28
    #define TRGE 29
    #define TRLE 30
    #define TRGT 31
    #define SINGLESTEP 32
    #define STACKOVERFLOW 33
    #define INDEXOUTOFBOUNDS 34
    #define ADDRESSERROR 35
    #define PSEM 36
    #define VSEM 37

    // Macros

    /**
     * Get CS value into static int v. Has to be executed in the beginning of main
     */

    #define GETCS(v) __asm__("PULL R2"); \
                     __asm__("PUSH R1"); \
                     __asm__("LOAD R1 svar_"#v); \
                     __asm__("STOR R2 [R1]"); \
                     __asm__("PULL R1"); \
                     __asm__("PUSH R5");

    /**
     * Initialize interrupt.
     * fn is interrup handler function name
     * cs is a static int containing cs addr
     * i is 2*(interrupt number)
     */

    #define INITINTERRUPT(fn, csvar, i) __asm__("PUSH R2"); \
                                        __asm__("LOAD R0 fn_"#fn); \
                                        __asm__("LOAD R2 svar_"#csvar); \
                                        __asm__("ADD R0 [R2]"); \
                                        __asm__("LOAD R1 "#i); \
                                        __asm__("STOR R0 [R1]"); \
                                        __asm__("PULL R2");

#endif
