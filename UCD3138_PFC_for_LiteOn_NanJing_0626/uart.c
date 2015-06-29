//uart.c

#include "include.h"  

void init_uart0(void) 
{
	volatile unsigned char rx_byte;

	Uart0Regs.UARTCTRL3.bit.SW_RESET = 0; //software reset while initializing UART

	Uart0Regs.UARTCTRL0.bit.DATA_SIZE = 7; //8 bits
	Uart0Regs.UARTCTRL0.bit.STOP = 1; //2 stop bits
	Uart0Regs.UARTCTRL0.bit.SYNC_MODE = 1; //asynchronous mode

	Uart0Regs.UARTHBAUD.bit.BAUD_DIV_H = 0;
	Uart0Regs.UARTMBAUD.bit.BAUD_DIV_M = 0;
//	Uart0Regs.UARTLBAUD.bit.BAUD_DIV_L = 101;  //for 38400 //47 for control board, 44 for open loop
	Uart0Regs.UARTLBAUD.bit.BAUD_DIV_L = 203;  //for 9600 [Ken Zhang]

	Uart0Regs.UARTRXST.bit.RX_ENA = 1 ;//enable RX

	Uart0Regs.UARTTXST.bit.TX_ENA = 1;//enable TX

	Uart0Regs.UARTINTST.all = 0xff;  //these two statements are supposed to clear the status bits
	Uart0Regs.UARTINTST.all = 0;

	rx_byte = Uart0Regs.UARTRXBUF.bit.RXDAT; //clear RXRDY flag
	
	Uart0Regs.UARTIOCTRLTX.bit.IO_FUNC = 1; //enable transmit pin
	Uart0Regs.UARTIOCTRLRX.bit.IO_FUNC = 1; //enable receive pin

	Uart0Regs.UARTCTRL3.bit.CLOCK = 1; //internal clock select;
	Uart0Regs.UARTCTRL3.bit.SW_RESET = 1; //software reset released UART init done?

	Uart0Regs.UARTIOCTRLSCLK.bit.IO_FUNC = 0; //disable external clock for UART.

	Uart0Regs.UARTTXBUF.all = ' '; //put out a byte to get things started.
}

void init_uart1(void) 
{
	volatile unsigned char rx_byte;

	Uart1Regs.UARTCTRL3.bit.SW_RESET = 0; //software reset while initializing UART

	Uart1Regs.UARTCTRL0.bit.DATA_SIZE = 7; //8 bits
	Uart1Regs.UARTCTRL0.bit.STOP = 1; //2 stop bits
	Uart1Regs.UARTCTRL0.bit.SYNC_MODE = 1; //asynchronous mode

	Uart1Regs.UARTHBAUD.bit.BAUD_DIV_H = 0;
	Uart1Regs.UARTMBAUD.bit.BAUD_DIV_M = 0;
	Uart1Regs.UARTLBAUD.bit.BAUD_DIV_L = 49;  //for 38400 //47 for control board, 44 for open loop

	Uart1Regs.UARTRXST.bit.RX_ENA = 1 ;//enable RX

	Uart1Regs.UARTTXST.bit.TX_ENA = 1;//enable TX

	Uart1Regs.UARTINTST.all = 0xff;  //these two statements are supposed to clear the status bits
	Uart1Regs.UARTINTST.all = 0;

	rx_byte = Uart1Regs.UARTRXBUF.bit.RXDAT; //clear RXRDY flag
	
	Uart1Regs.UARTIOCTRLTX.bit.IO_FUNC = 1; //enable transmit pin
	Uart1Regs.UARTIOCTRLRX.bit.IO_FUNC = 1; //enable receive pin

	Uart1Regs.UARTCTRL3.bit.CLOCK = 1; //internal clock select;
	Uart1Regs.UARTCTRL3.bit.SW_RESET = 1; //software reset released UART init done?

	Uart1Regs.UARTIOCTRLSCLK.bit.IO_FUNC = 0; //disable external clock for UART.

	Uart1Regs.UARTTXBUF.all = ' '; //put out a byte to get things started.
}

void init_uart(void)
{
	init_uart0();
	init_uart1();
}

void char_out_0(char data) 
{
	char rx_byte;

	while(Uart0Regs.UARTTXST.bit.TX_RDY == 0)
	{
		if(Uart0Regs.UARTRXST.bit.RX_RDY == 1)
		{
			rx_byte = Uart0Regs.UARTRXBUF.bit.RXDAT; //clear RXRDY flag
			handle_serial_in(rx_byte);
		}
		pmbus_handler();
	}
	Uart0Regs.UARTTXBUF.all = data; //put out a byte
}

void string_out_0(char string[]) 
{
	int i = 0;

	while(string[i] != 0)
	{
		char_out_0(string[i]);
		i++;
	}
}

void nybble_out_0(char nybble)  
{
	if(nybble < 10)
	{
		char_out_0(nybble + 0x30);
	}
	else
	{
		char_out_0(nybble + ('a' - 10)); //make 10 into an A
	}
}

void byte_out_0(char data) 
{
	nybble_out_0(data >> 4);
	nybble_out_0(data & 0xf);
}

void short_out_0(unsigned short data) 
{
	byte_out_0(data >> 8);
	byte_out_0(data & 0xff);
}

void word_out_0(unsigned int data) 
{
	short_out_0(data >> 16);
	short_out_0(data & 0xffff);
}

void byte_out_space_0(char data) 
{
	byte_out_0(data);
	char_out_0(' ');
}

void short_out_space_0(Uint16 data)
{
	short_out_0(data);
	char_out_0(' ');
}

void word_out_space_0(Uint32 data)
{
	word_out_0(data);
	char_out_0(' ');
}

void decimal_out_4_digits_0(int32 data) 
{
	int32 i,o;

	if((data > 9999) || (data < 0))
	{
		for(i = 0; i < 4;i++)
		{
			char_out_0('x');
		}
	}
	else
	{
		for(i = 1000; i > 0;i = i/10)
		{
			o = (data/i);
			nybble_out_0(o);
			data = data - (o*i);
		}
	}
	char_out_0(' ');
}

void decimal_out_4_digits_tenths_0(int32 data) 
{
	int32 i,o;

	if((data > 9999) || (data < 0))
	{
		for(i = 0; i < 5;i++)
		{
			char_out_0('x');
		}
	}
	else
	{
		for(i = 1000; i > 0;i = i/10)
		{
			o = (data/i);
			nybble_out_0(o);
			data = data - (o*i);
			if(i == 10)
			{
				char_out_0('.');
			}
		}
	}
	char_out_0(' ');
}

void decimal_out_5_digits_0(int32 data) 
{
	int32 i,o;

	if((data > 99999) || (data < -99999))
	{
		for(i = 0; i < 6;i++)
		{
			char_out_0('x');
		}
	}
	else
	{
		if(data < 0)
		{
			data = -data;
			char_out_0('-');
		}
		else
		{
			char_out_0(' ');
		}
		for(i = 10000; i > 0;i = i/10)
		{
			o = (data/i);
			nybble_out_0(o);
			data = data - (o*i);
		}
	}
	char_out_0(' ');
}

void decimal_out_6_digits_0(int32 data) 
{
	int32 i,o;

	if((data > 999999) || (data < -999999))
	{
		for(i = 0; i < 7;i++)
		{
			char_out_0('x');
		}
	}
	else
	{
		if(data < 0)
		{
			data = -data;
			char_out_0('-');
		}
		else
		{
			char_out_0(' ');
		}
		for(i = 100000; i > 0;i = i/10)
		{
			o = (data/i);
			nybble_out_0(o);
			data = data - (o*i);
		}
	}
	char_out_0(' ');
}

void decimal_out_8_digits_0(int32 data) 
{
	int32 i,o;

	if((data > 99999999) || (data < -99999999))
	{
		for(i = 0; i < 9;i++)
		{
			char_out_0('x');
		}
	}
	else
	{
		if(data < 0)
		{
			data = -data;
			char_out_0('-');
		}
		else
		{
			char_out_0(' ');
		}
		for(i = 10000000; i > 0;i = i/10)
		{
			o = (data/i);
			nybble_out_0(o);
			data = data - (o*i);
		}
	}
	char_out_0(' ');
}

void decimal_out_3_digits_0(int32 data) 
{
	int32 i,o;

	if((data > 999) || (data < -999))
	{
		for(i = 0; i < 4;i++)
		{
			char_out_0('x');
		}
	}
	else
	{
		if(data < 0)
		{
			data = -data;
			char_out_0('-');
		}
		else
		{
			char_out_0(' ');
		}
		for(i = 100; i > 0;i = i/10)
		{
			o = (data/i);
			nybble_out_0(o);
			data = data - (o*i);
		}
	}
	char_out_0(' ');
}

void on_off_out_0(int value) //Cyclone OK
{
	if(value == 0)
	{
		string_out_0("Off");
	}
	else
	{
		string_out_0("On ");
	}
}

void char_out_1(char data) 
{
	volatile char rx_byte;

	while(Uart1Regs.UARTTXST.bit.TX_RDY == 0)
	{
		if(Uart1Regs.UARTRXST.bit.RX_RDY == 1)
		{
			rx_byte = Uart1Regs.UARTRXBUF.bit.RXDAT; //clear RXRDY flag
		}
	}
	Uart1Regs.UARTTXBUF.all = data; //put out a byte
}

void string_out_1(char string[]) 
{
	int i = 0;

	while(string[i] != 0)
	{
		char_out_1(string[i]);
		i++;
	}
}

void nybble_out_1(char nybble)  
{
	if(nybble < 10)
	{
		char_out_1(nybble + 0x30);
	}
	else
	{
		char_out_1(nybble + ('a' - 10)); //make 10 into an A
	}
}

void byte_out_1(char data) 
{
	nybble_out_1(data >> 4);
	nybble_out_1(data & 0xf);
}

void short_out_1(unsigned short data) 
{
	byte_out_1(data >> 8);
	byte_out_1(data & 0xff);
}

void word_out_1(unsigned int data) 
{
	short_out_1(data >> 16);
	short_out_1(data & 0xffff);
}

void byte_out_space_1(char data) 
{
	byte_out_1(data);
	char_out_1(' ');
}

void short_out_space_1(Uint16 data)
{
	short_out_1(data);
	char_out_1(' ');
}

void word_out_space_1(Uint32 data)
{
	word_out_1(data);
	char_out_1(' ');
}

void decimal_out_4_digits_1(int32 data) 
{
	int32 i,o;

	if((data > 9999) || (data < 0))
	{
		for(i = 0; i < 4;i++)
		{
			char_out_1('x');
		}
	}
	else
	{
		for(i = 1000; i > 0;i = i/10)
		{
			o = (data/i);
			nybble_out_1(o);
			data = data - (o*i);
		}
	}
	char_out_1(' ');
}

void decimal_out_4_digits_tenths_1(int32 data) 
{
	int32 i,o;

	if((data > 9999) || (data < 0))
	{
		for(i = 0; i < 5;i++)
		{
			char_out_1('x');
		}
	}
	else
	{
		for(i = 1000; i > 0;i = i/10)
		{
			o = (data/i);
			nybble_out_1(o);
			data = data - (o*i);
			if(i == 10)
			{
				char_out_1('.');
			}
		}
	}
	char_out_1(' ');
}

void decimal_out_5_digits_1(int32 data) 
{
	int32 i,o;

	if((data > 99999) || (data < -99999))
	{
		for(i = 0; i < 6;i++)
		{
			char_out_1('x');
		}
	}
	else
	{
		if(data < 0)
		{
			data = -data;
			char_out_1('-');
		}
		else
		{
			char_out_1(' ');
		}
		for(i = 10000; i > 0;i = i/10)
		{
			o = (data/i);
			nybble_out_1(o);
			data = data - (o*i);
		}
	}
	char_out_0(' ');
}

void decimal_out_6_digits_1(int32 data) 
{
	int32 i,o;

	if((data > 999999) || (data < -999999))
	{
		for(i = 0; i < 7;i++)
		{
			char_out_1('x');
		}
	}
	else
	{
		if(data < 0)
		{
			data = -data;
			char_out_1('-');
		}
		else
		{
			char_out_1(' ');
		}
		for(i = 100000; i > 0;i = i/10)
		{
			o = (data/i);
			nybble_out_1(o);
			data = data - (o*i);
		}
	}
	char_out_1(' ');
}

void decimal_out_3_digits_1(int32 data) 
{
	int32 i,o;

	if((data > 999) || (data < -999))
	{
		for(i = 0; i < 4;i++)
		{
			char_out_1('x');
		}
	}
	else
	{
		if(data < 0)
		{
			data = -data;
			char_out_1('-');
		}
		else
		{
			char_out_1(' ');
		}
		for(i = 100; i > 0;i = i/10)
		{
			o = (data/i);
			nybble_out_1(o);
			data = data - (o*i);
		}
	}
	char_out_1(' ');
}

void on_off_out_1(int value) //Cyclone OK
{
	if(value == 0)
	{
		string_out_1("Off");
	}
	else
	{
		string_out_1("On ");
	}
}
