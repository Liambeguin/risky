#include "Vsoc_top.h"
#include "verilated.h"
#include <iostream>

int main(int argc, char** argv, char** env) {
	Vsoc_top top;
	top.CLK = 0;

	while(!Verilated::gotFinish()) {
		top.CLK = !top.CLK;
		top.eval();
	}

	return 0;
}
