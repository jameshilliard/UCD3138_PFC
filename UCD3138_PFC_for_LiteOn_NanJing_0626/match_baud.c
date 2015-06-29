/*
 * match_baud.c
 *
 *      Equations used to find bit times:
 *      baud_rate = ICLK / bit_time
 *      baud_div_value = ICLK/(8*baud_rate) - 1
 *      baud_div_value = bit_time/8 - 1
*      baud_div_value = (bit_time >> 3) - 1
 */
//#include "system_defines.h"
//#include "cyclone_device.h"
//#include "pmbus_commands.h"
//#include "pmbus.h"
//#include "variables.h"
//#include "function_definitions.h"
//#include "software_interrupts.h"
//#include "cyclone_defines.h"

#include "include.h"

#define ICLK	(15625000)
void match_baud(Uint32 bit_time)
{

	if ((bit_time >= 730) && (bit_time <= 900))
//calculated correct pulse width (+/- 10% from 19200 baud)
	{
		baud_div_value = (bit_time >> 3)-1;
		Uart0Regs.UARTMBAUD.bit.BAUD_DIV_M = (baud_div_value >> 8);
		Uart0Regs.UARTLBAUD.bit.BAUD_DIV_L = (baud_div_value & 0xff);
		Uart1Regs.UARTMBAUD.bit.BAUD_DIV_M = (baud_div_value >> 8);
		Uart1Regs.UARTLBAUD.bit.BAUD_DIV_L = (baud_div_value & 0xff);

	}
	else if ((bit_time >= 	1460) && (bit_time <= 1800))		//calculated 2x pulse width
	{
		baud_div_value = ((bit_time >> 4) & 0xffff)-1;
		Uart0Regs.UARTMBAUD.bit.BAUD_DIV_M = (baud_div_value >> 8);
		Uart0Regs.UARTLBAUD.bit.BAUD_DIV_L = (baud_div_value & 0xff);
		Uart1Regs.UARTMBAUD.bit.BAUD_DIV_M = (baud_div_value >> 8);
		Uart1Regs.UARTLBAUD.bit.BAUD_DIV_L = (baud_div_value & 0xff);

	}
	else if ((bit_time >= 2190) && (bit_time <= 2700))		//calculated 3x pulse width
	{
		baud_div_value = (((bit_time >> 4) & 0xffff)*2/3)-1;
		Uart0Regs.UARTMBAUD.bit.BAUD_DIV_M = (baud_div_value >> 8);
		Uart0Regs.UARTLBAUD.bit.BAUD_DIV_L = (baud_div_value & 0xff);
		Uart1Regs.UARTMBAUD.bit.BAUD_DIV_M = (baud_div_value >> 8);
		Uart1Regs.UARTLBAUD.bit.BAUD_DIV_L = (baud_div_value & 0xff);

	}
	else if ((bit_time >= 2920)&&(bit_time <= 3600))		//calculated 4x pulse width
	{
		baud_div_value = ((bit_time >> 5) - 1);
		Uart0Regs.UARTMBAUD.bit.BAUD_DIV_M = (baud_div_value >> 8);
		Uart0Regs.UARTLBAUD.bit.BAUD_DIV_L = (baud_div_value & 0xff);
		Uart1Regs.UARTMBAUD.bit.BAUD_DIV_M = (baud_div_value >> 8);
		Uart1Regs.UARTLBAUD.bit.BAUD_DIV_L = (baud_div_value & 0xff);
	}
	else
	{
		//don't calculate baud rate


	}

}
