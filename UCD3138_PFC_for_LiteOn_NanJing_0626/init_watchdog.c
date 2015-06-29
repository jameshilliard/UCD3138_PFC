#include "Cyclone_Device.h"     // UCD30xx Headers Include File
#include "software_interrupts.h"
#include "system_defines.h"

void init_watchdog(void)
{
	TimerRegs.WDCTRL.bit.PERIOD = 0;  //set period fast for test purposes
	TimerRegs.WDCTRL.bit.PROTECT = 0;
}
