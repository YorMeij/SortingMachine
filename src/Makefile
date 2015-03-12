CC = ../../pp2cc/pp2cc.py
CPPPATH = clang
ASM = ../../2IC30/Assembler9.jar

all: CompileC Assemble

CompileC:
	python $(CC) --cpp-path=$(CPPPATH) mainLoop.c input.c lights.c motor_pwm.c detectors.c

Assemble:
	java -jar $(ASM) mainLoop.asm

.PHONY: clean
clean:
	rm -rf *.asm *.hex
