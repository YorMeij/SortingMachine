
void initInterrupt(void){

    __asm__("PUSH R2");
    __asm__("LOAD R0 fn___int_nop"); // Interrupt handler label
    __asm__("LOAD R2 svar_cs");
    __asm__("ADD R0 [R2]"); // label_addr += CS
    __asm__("LOAD R1 16");
    __asm__("STOR R0 [R1]"); // Write label_addr to mem[16]
    __asm__("PULL R2");

    __seti__(8);
}
