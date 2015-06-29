//init_dpwms.c

#include "include.h"   

void init_dpwm0(void) // DPWM0 is used for debugging
{
	Dpwm0Regs.DPWMCTRL0.bit.PWM_EN = 0;  //disable everything

	Dpwm0Regs.DPWMCTRL0.bit.CLA_EN = 0;	//open loop

	Dpwm0Regs.DPWMPRD.all = 0x420;// + 320; //10 bits plus time for update at end.
	Dpwm0Regs.DPWMEV1.all = 0; 
	Dpwm0Regs.DPWMEV2.all = 100; 

	Dpwm0Regs.DPWMCTRL1.bit.GPIO_A_EN = 0; //turn off DPWM0A

	Dpwm0Regs.DPWMCTRL0.bit.PWM_EN = 1; //enable OK here, because nothing will happen until DPWM and front end are globally enabled
}

void init_dpwm1(void) // DPWM1B is used to drive 1st phase 
{
	Dpwm1Regs.DPWMCTRL0.bit.PWM_EN = 0;  //disable everything

	Dpwm1Regs.DPWMCTRL1.bit.GPIO_A_EN = 1; //turn off DPWM1A for now
	Dpwm1Regs.DPWMCTRL1.bit.GPIO_B_EN = 1; //turn off DPWM1B for now

    // Enable Current Limit and Set min duty cycle to verify.
    Dpwm1Regs.DPWMCTRL0.bit.CBC_PWM_AB_EN = 1; // Enable cycle by cycle current limit.
    Dpwm1Regs.DPWMCTRL0.bit.BLANK_B_EN = 1;      // Enable blanking so we can see a min pulse for curr lim
    Dpwm1Regs.DPWMBLKBBEG.all = 0x0000;
    Dpwm1Regs.DPWMBLKBEND.all = 0x0500;

	Dpwm1Regs.DPWMFLTCTRL.bit.B_MAX_COUNT = 2;
	Dpwm1Regs.DPWMFLTCTRL.bit.ALL_FAULT_EN = 1; //enable this for OVP

	Dpwm1Regs.DPWMCTRL2.bit.SAMPLE_TRIG_1_EN = 1; //enable sample trigger1

	Dpwm1Regs.DPWMEV1.all = 290;
	Dpwm1Regs.DPWMEV3.all = 290;//aviod 72ns events update window
	Dpwm1Regs.DPWMCTRL0.bit.PWM_MODE = 2; //multi mode
//	Dpwm1Regs.DPWMCTRL2.bit.SAMPLE_TRIG1_OVERSAMPLE = 3; //massive oversampling.
	Dpwm1Regs.DPWMCTRL1.bit.EVENT_UP_SEL = 1; //update at end of period

	Dpwm1Regs.DPWMCTRL0.bit.CLA_EN = 1;
	Dpwm1Regs.DPWMCTRL0.bit.PWM_EN = 1; //enable OK here, because nothing will happen until DPWM and front end are globally enabled 
}

void set_new_switching_frequency(void)
{
	iv.switching_period = (SWITCH_FREQ_NUMERATOR/switching_frequency) << 4;
	iv.period_times_2_14 = iv.switching_period << 14;
	iv.dither_max_period = (SWITCH_FREQ_NUMERATOR/(switching_frequency - 4)) << 4; 
    iv.dither_min_period = (SWITCH_FREQ_NUMERATOR/(switching_frequency + 4)) << 4; 
    iv.dither_step = ((iv.dither_max_period - iv.dither_min_period) << 14)/DITHER_PERIOD; //step for dither value

	Dpwm1Regs.DPWMPRD.all = iv.switching_period; //new period for new frequency

	Dpwm3Regs.DPWMPRD.all = iv.switching_period; //new period for new frequency
	Dpwm1Regs.DPWMSAMPTRIG1.all = iv.switching_period - (iv.sample_trigger_offset * 4); // sample at the end of period
	Dpwm1Regs.DPWMPHASETRIG.all = 0; //0 delay for next phase
}

void init_dpwms(void)
{
	init_dpwm0();
	init_dpwm1();
	set_new_switching_frequency();
}
