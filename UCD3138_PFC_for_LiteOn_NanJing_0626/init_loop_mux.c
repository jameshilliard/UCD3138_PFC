//init_loop_mux.c

#include "include.h"  

void init_loop_mux(void)
{
	LoopMuxRegs.SAMPTRIGCTRL.bit.FE0_TRIG_DPWM1_EN = 1;	//Use DPWM1 sample trigger for FE0

	LoopMuxRegs.FILTERMUX.bit.FILTER1_FE_SEL = 0; //use FE0 (shunt) to drive CLA1
	LoopMuxRegs.FILTERMUX.bit.FILTER1_PER_SEL = 1;//CLA1 switching period select from DPWM1

	LoopMuxRegs.DPWMMUX.bit.DPWM1_FILTER_SEL =1; //CLA1 is providing input to DPWM1
	LoopMuxRegs.DPWMMUX.bit.DPWM3_SYNC_SEL = 1;  //DPWM1 is the master for DPWM3
}
