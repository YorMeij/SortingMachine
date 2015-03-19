
/*
 * Source: PP2cc project
 * Author: Peter Wu
 */


/**
 * Determines the bitmask necessary for enabling LED segments on a LED
 * @param number The number to be displayed
 * @return The segment bits to be enabled
 */
static int segment_mask(int number) {
    switch (number) {
        case 0:
            return 0x7e;// 01111110
        case 1:
            return 0x30;// 00110000
        case 2:
            return 0x6d;// 01101101
        case 3:
            return 0x79;// 01111001
        case 4:
            return 0x33;// 00110011
        case 5:
            return 0x5b;// 01011011
        case 6:
            return 0x5f;// 01011111
        case 7:
            return 0x70;// 01110000
        case 8:
            return 0x7f;// 01111111
        case 9:
            return 0x7b;// 01111011
    }
    // in case you do not pass the right arguments, turn everything on
    return 0xff;
}

/**
 * Displays a digit at a certain index
 * @param digit The digit to be displayed (between 0 and 9 inclusive)
 * @param index The number of the LED segment to be enabled, counting from the
 * right side. index 0 means that all LEDS are disabled. The n-th LED can be
 * selected with index n with 1 <= n <= 6
 */
void enable_digit(int digit, int index) {
    int *digitp = (int*)-7;
    int *segmentp = (int*)-8;

    // first set the segments to be enabled
    *segmentp = segment_mask(digit);
    // enable bit "index" if index > 0
    *digitp = index ? 1 << (index - 1) : 0;
}
