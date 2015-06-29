//init_filters.c

#include "include.h"  

void init_filter0(void)
{

}

void init_filter1(void)
{
	MiscAnalogRegs.CLKTRIM.bit.HFO_LN_FILTER_EN = 0;	// disable HFO calibration

	Filter1Regs.FILTERCTRL.bit.OUTPUT_MULT_SEL = 1;//PID output multiply with period
	Filter1Regs.FILTERCTRL.bit.OUTPUT_SCALE = 0;//no scale

	Filter1Regs.FILTERKICLPHI.bit.KI_CLAMP_HIGH = 0x7FFFF0;
	Filter1Regs.FILTERKICLPLO.bit.KI_CLAMP_LOW = 0x800010;

	Filter1Regs.FILTERYNCLPHI.all = 0x799999;//95%
	Filter1Regs.FILTERYNCLPLO.all = 0;

    Filter1Regs.FILTERCTRL.bit.FILTER_EN = 1;
    //enable OK here, because nothing will happen until DPWM and front end are globally enabled
}	

void init_filter2(void)
{
}

void init_filters(void)
{
	init_filter0();
	init_filter1();
	init_filter2();
}

