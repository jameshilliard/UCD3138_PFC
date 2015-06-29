//init_front_ends.c

#include "include.h"  

void init_front_end0(void)//for shunt sening
{
	FeCtrl0Regs.EADCDAC.bit.DAC_VALUE = 0;
//	FeCtrl0Regs.EADCCTRL.bit.AFE_GAIN = 1;
}

void init_front_end1(void)//for CT1 sensing
{
	FeCtrl1Regs.EADCDAC.bit.DAC_VALUE = 0;
//	FeCtrl1Regs.EADCCTRL.bit.AFE_GAIN = 1;
}

void init_front_end2(void)//for CT2 sensing
{
	FeCtrl2Regs.EADCDAC.bit.DAC_VALUE = 0;
//	FeCtrl2Regs.EADCCTRL.bit.AFE_GAIN = 1; 
}

void init_front_ends(void)
{
	init_front_end0();
	init_front_end1();
	init_front_end2();
}

