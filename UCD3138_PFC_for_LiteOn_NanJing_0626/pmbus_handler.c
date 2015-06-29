//pmbus_handler.c

#include "include.h"  

void pmbus_idle_handler(void)
{
	int32 i; //loop counter

	union
	{
		Uint32 pmbus_transmit_load;
		Uint8 pmbus_transmit_bytes[4];
	}
	 u;


	pmbus_status_half_word_0_value = PMBusRegs.PMBST.half.HALF0 ; //assign to temporary value
	pmbus_status_half_word_0_value_ored = pmbus_status_half_word_0_value_ored | pmbus_status_half_word_0_value;	

	if((pmbus_status_half_word_0_value & (PMBST_HALF0_CHECK_BITS + PMBST_BYTE0_RD_BYTE_COUNT)) == 0)
	{//if no activity on PMBus, do nothing
		return ;
	}
	
	if((pmbus_status_half_word_0_value & (PMBST_HALF0_CHECK_BITS + PMBST_BYTE0_RD_BYTE_COUNT)) == 
				PMBST_BYTE0_EOM)
	//if there is an end of message, no data ready, no data request, and no bytes recieved
	//it must be a quick command, which we do not support, so nack, go get the next one
	{
		PMBusRegs.PMBACK.byte.BYTE0 = 1;  //nack them
		return ;
	}
	else if((pmbus_status_half_word_0_value & (PMBST_HALF0_CHECK_BITS )) ==
			(PMBST_BYTE0_EOM + PMBST_BYTE0_DATA_READY + PMBST_BYTE0_PEC_VALID))
			//end of message, good data ready, pec valid, must be 2 to 4 bytes
	{
		//copy all 4 over just to make sure
		pmbus_buffer[0] = PMBusRegs.PMBRXBUF.byte.BYTE0;
		pmbus_buffer[1] = PMBusRegs.PMBRXBUF.byte.BYTE1;
		pmbus_buffer[2] = PMBusRegs.PMBRXBUF.byte.BYTE2;
		pmbus_buffer[3] = PMBusRegs.PMBRXBUF.byte.BYTE3;
		pmbus_number_of_bytes = pmbus_status_half_word_0_value & PMBST_BYTE0_RD_BYTE_COUNT;
		pmbus_write_message();
		PMBusRegs.PMBACK.byte.BYTE0 = 1;  //ack them
		return;
	}
	else if((pmbus_status_half_word_0_value & (PMBST_HALF0_CHECK_BITS + PMBST_BYTE0_RD_BYTE_COUNT)) ==
			(4 //4 is read byte count
			 + PMBST_BYTE0_DATA_READY))
			//no end of message, good data ready, 4 bytes of data - must be a send block 
	{
		//copy data into buffer, set up to recieve more.
		pmbus_buffer[0] = PMBusRegs.PMBRXBUF.byte.BYTE0;
		pmbus_buffer[1] = PMBusRegs.PMBRXBUF.byte.BYTE1;
		pmbus_buffer[2] = PMBusRegs.PMBRXBUF.byte.BYTE2;
		pmbus_buffer[3] = PMBusRegs.PMBRXBUF.byte.BYTE3;
		pmbus_number_of_bytes = 4 ; //start counting bytes.
		
		PMBusRegs.PMBACK.byte.BYTE0 = 1;  //ack first 4 bytes;

		
		pmbus_state = PMBUS_STATE_WRITE_BLOCK;
	}
	else if((pmbus_status_half_word_0_value & (PMBST_HALF0_CHECK_BITS + PMBST_BYTE0_RD_BYTE_COUNT)) ==
 			(1 + PMBST_BYTE0_DATA_READY ))
			//one byte, data ready, not EOM and/or PEC_VALID, for some reason, don't use data request
			//all this means a read request.
	{
		pmbus_buffer[0] = PMBusRegs.PMBRXBUF.byte.BYTE0;

		pmbus_read_message();

		if(pmbus_number_of_bytes == 0) //0 shows its not a valid command, so
		{
			PMBusRegs.PMBACK.byte.BYTE0 = 1;  //nack them
			return;
		}

		else if(pmbus_number_of_bytes < 5) //here if it all fits in one rxbuf
		{
//			PMBusRegs.PMBACK.byte.BYTE0 = 1;  //ack command;

			PMBusRegs.PMBCTRL2.byte.BYTE2 = PMBCTRL2_BYTE2_TX_PEC + pmbus_number_of_bytes
											+ PMBCTRL2_BYTE2_RX_BYTE_ACK_CNT;
			//transmit with pec, desired number of bytes.

			for(i = 0;i < pmbus_number_of_bytes;i++)
			{
				u.pmbus_transmit_bytes[3-i] = pmbus_buffer[i]; //big endian stuff - great fun
			}

			PMBusRegs.PMBTXBUF.all = u.pmbus_transmit_load; //this sends message

			PMBusRegs.PMBACK.byte.BYTE0 = 1;  //ack command;

			pmbus_state = PMBUS_STATE_READ_WAIT_FOR_EOM;

			return ;
		}
		else //here if we have to do multiple rxbuf loads - do first one, set up for more
		{
//			PMBusRegs.PMBACK.byte.BYTE0 = 1;  //ack command;

			PMBusRegs.PMBCTRL2.byte.BYTE2 =  4 + PMBCTRL2_BYTE2_RX_BYTE_ACK_CNT; //4 is number of bytes
			//transmit with desired number of bytes.

			for(i = 0;i < 4;i++)
			{
				u.pmbus_transmit_bytes[3-i] = pmbus_buffer[i]; //big endian stuff - great fun
			}

			PMBusRegs.PMBTXBUF.all = u.pmbus_transmit_load; //this sends message

			PMBusRegs.PMBACK.byte.BYTE0 = 1;  //ack command;

			pmbus_buffer_position = 4;

			pmbus_state = PMBUS_STATE_READ_BLOCK;
	
			return ;
		}
	}
	else //here if something has happened on bus, not covered by anything above
	{
		PMBusRegs.PMBACK.byte.BYTE0 = 1;  //ack them
		pmbus_state = PMBUS_STATE_IDLE;
		return;
	}
}

void pmbus_write_block_handler(void)
{
	Uint16 pmbus_status_half_word_0_value; //save pmbus status, since cleared on read.

	pmbus_status_half_word_0_value = PMBusRegs.PMBST.half.HALF0 ; //assign to temporary value
	pmbus_status_half_word_0_value_ored = pmbus_status_half_word_0_value_ored | pmbus_status_half_word_0_value;	

	if((pmbus_status_half_word_0_value & (PMBST_HALF0_CHECK_BITS + PMBST_BYTE0_RD_BYTE_COUNT)) == 0) 
	{
		return; //if nothing has happened, just return;
	}
	else if((pmbus_status_half_word_0_value & (PMBST_HALF0_CHECK_BITS )) ==
			(PMBST_BYTE0_EOM + PMBST_BYTE0_DATA_READY + PMBST_BYTE0_PEC_VALID))
			//end of message, good data ready, pec valid, must be 2 to 4 bytes
	{
		//copy all 4 over just to make sure
		pmbus_buffer[pmbus_number_of_bytes] = PMBusRegs.PMBRXBUF.byte.BYTE0;
		pmbus_buffer[pmbus_number_of_bytes + 1] = PMBusRegs.PMBRXBUF.byte.BYTE1;
		pmbus_buffer[pmbus_number_of_bytes + 2] = PMBusRegs.PMBRXBUF.byte.BYTE2;
		pmbus_buffer[pmbus_number_of_bytes + 3] = PMBusRegs.PMBRXBUF.byte.BYTE3;
		pmbus_number_of_bytes = pmbus_number_of_bytes +
								(pmbus_status_half_word_0_value & PMBST_BYTE0_RD_BYTE_COUNT);
		pmbus_write_message();
		PMBusRegs.PMBACK.byte.BYTE0 = 1;  //ack these 4 bytes;
		pmbus_state = PMBUS_STATE_IDLE;
		return;
	}
	else if((pmbus_status_half_word_0_value & (PMBST_HALF0_CHECK_BITS + PMBST_BYTE0_RD_BYTE_COUNT)) ==
			(4 //4 is read byte count
			 + PMBST_BYTE0_DATA_READY))
			//no end of message, good data ready, 4 bytes of data - must be a send block 
	{
		//copy data into buffer, set up to recieve more.
		pmbus_buffer[pmbus_number_of_bytes++] = PMBusRegs.PMBRXBUF.byte.BYTE0;
		pmbus_buffer[pmbus_number_of_bytes++] = PMBusRegs.PMBRXBUF.byte.BYTE1;
		pmbus_buffer[pmbus_number_of_bytes++] = PMBusRegs.PMBRXBUF.byte.BYTE2;
		pmbus_buffer[pmbus_number_of_bytes++] = PMBusRegs.PMBRXBUF.byte.BYTE3;

		if(pmbus_number_of_bytes >= PMBUS_BUFFER_SIZE) //if it's too big 
		//assumes pmbus buffer size is multiple of 4
		{
			PMBusRegs.PMBACK.byte.BYTE0 = 1;  //NACK it;
			pmbus_state = PMBUS_STATE_IDLE;
			return;
		}
			
		PMBusRegs.PMBACK.byte.BYTE0 = 1;  //ack these 4 bytes;
		return;
	}
	else if((pmbus_status_half_word_0_value & (PMBST_HALF0_CHECK_BITS )) ==
		(PMBST_BYTE0_EOM + PMBST_BYTE0_PEC_VALID))
		//end of message, no new data ready, pec valid; was exact multiple of 4 bytes, already acked last time
	{
		pmbus_write_message();

		PMBusRegs.PMBACK.byte.BYTE0 = 1;  //ack the message;
		pmbus_state = PMBUS_STATE_IDLE;
		return;
	}
	else //here if something has happened on bus, not covered by anything above
	{
		PMBusRegs.PMBACK.byte.BYTE0 = 1;  //nack them
		pmbus_state = PMBUS_STATE_IDLE;
		return;
	}
}

void pmbus_read_block_handler(void)
{
	union
	{
		Uint32 pmbus_transmit_load;
		Uint8 pmbus_transmit_bytes[4];
	}
	 u;

	pmbus_status_half_word_0_value = PMBusRegs.PMBST.half.HALF0 ; //assign to temporary value
	pmbus_status_half_word_0_value_ored = pmbus_status_half_word_0_value_ored | pmbus_status_half_word_0_value;	

	if((pmbus_status_half_word_0_value & (PMBST_HALF0_CHECK_BITS + PMBST_BYTE0_RD_BYTE_COUNT)) == 0) 
	{//if no activity on PMBus, do nothing
		return ; 
	}
	else if((pmbus_status_half_word_0_value & (PMBST_HALF0_CHECK_BITS + PMBST_BYTE0_RD_BYTE_COUNT)) ==
				PMBST_BYTE0_DATA_REQUEST)

	{
		u.pmbus_transmit_bytes[3] = pmbus_buffer[pmbus_buffer_position++] ; //put out byte 0
		if(pmbus_buffer_position >= pmbus_number_of_bytes) //if last byte
		{
			PMBusRegs.PMBCTRL2.byte.BYTE2 = 1 + PMBCTRL2_BYTE2_TX_PEC
											+ PMBCTRL2_BYTE2_RX_BYTE_ACK_CNT;  //send byte and PEC;
			PMBusRegs.PMBTXBUF.all = u.pmbus_transmit_load; //
			pmbus_state = PMBUS_STATE_READ_WAIT_FOR_EOM;
			return  ;
		}
		u.pmbus_transmit_bytes[2] = pmbus_buffer[pmbus_buffer_position++] ; //put out byte 1
		if(pmbus_buffer_position >= pmbus_number_of_bytes) //if last byte
		{
			PMBusRegs.PMBCTRL2.byte.BYTE2 = 2 + PMBCTRL2_BYTE2_TX_PEC
											+ PMBCTRL2_BYTE2_RX_BYTE_ACK_CNT;  //send bytes and PEC;
			PMBusRegs.PMBTXBUF.all = u.pmbus_transmit_load; //
			pmbus_state = PMBUS_STATE_READ_WAIT_FOR_EOM;
			return  ;
		}
		u.pmbus_transmit_bytes[1] = pmbus_buffer[pmbus_buffer_position++] ; //put out byte 2
		if(pmbus_buffer_position >= pmbus_number_of_bytes) //if last byte
		{
			PMBusRegs.PMBCTRL2.byte.BYTE2 = 3 + PMBCTRL2_BYTE2_TX_PEC
											+ PMBCTRL2_BYTE2_RX_BYTE_ACK_CNT;  //send bytes and PEC;
			PMBusRegs.PMBTXBUF.all = u.pmbus_transmit_load; //
			pmbus_state = PMBUS_STATE_READ_WAIT_FOR_EOM;
			return  ;
		}
		u.pmbus_transmit_bytes[0] = pmbus_buffer[pmbus_buffer_position++] ; //put out byte 3
		if(pmbus_buffer_position >= pmbus_number_of_bytes) //if last byte
		{
			PMBusRegs.PMBCTRL2.byte.BYTE2 = 4 + PMBCTRL2_BYTE2_TX_PEC
											+ PMBCTRL2_BYTE2_RX_BYTE_ACK_CNT;  //send bytes and PEC;
			PMBusRegs.PMBTXBUF.all = u.pmbus_transmit_load; //
			pmbus_state = PMBUS_STATE_READ_WAIT_FOR_EOM;
			return  ;
		}
		PMBusRegs.PMBCTRL2.byte.BYTE2 = 4 + PMBCTRL2_BYTE2_RX_BYTE_ACK_CNT ;  //send bytes, no PEC;
		PMBusRegs.PMBTXBUF.all = u.pmbus_transmit_load; //
		return; //don't change status, we're not done yet.
	}
	else  //if we get something other than a data request
	{
		PMBusRegs.PMBACK.byte.BYTE0 = 1;  //nack them
		return  ; //and return
	}
	
}

void pmbus_read_wait_for_eom_handler(void)
{
	Uint8 pmbus_status_half_word_0_value; //save pmbus status, since cleared on read.

	pmbus_status_half_word_0_value = PMBusRegs.PMBST.half.HALF0 ; //assign to temporary value
	pmbus_status_half_word_0_value_ored = pmbus_status_half_word_0_value_ored | pmbus_status_half_word_0_value;	

	if((pmbus_status_half_word_0_value & (PMBST_HALF0_CHECK_BITS + PMBST_BYTE0_RD_BYTE_COUNT)) == 0)
	{//if no activity on PMBus, do nothing
		return ;
	}

	else if((pmbus_status_half_word_0_value & (PMBST_HALF0_CHECK_BITS + PMBST_BYTE0_RD_BYTE_COUNT)) == PMBST_BYTE0_EOM)
	{//if eom, done
		pmbus_state = PMBUS_STATE_IDLE;
		PMBusRegs.PMBACK.byte.BYTE0 = 1;  //ack them
		return ;
	}
	else //some other error, still go back to idle.
	{
		pmbus_state = PMBUS_STATE_IDLE;
		return;
	}
}

void pmbus_handler(void)
{
	if(pmbus_state == PMBUS_STATE_IDLE)
	{
		pmbus_idle_handler();
		return;
	}
	else if(pmbus_state == PMBUS_STATE_WRITE_BLOCK)
	{
		pmbus_write_block_handler();
		return;
	}
	else if(pmbus_state == PMBUS_STATE_READ_BLOCK)
	{
		pmbus_read_block_handler();
		return;
	}
	else if(pmbus_state == PMBUS_STATE_READ_WAIT_FOR_EOM)
	{
		pmbus_read_wait_for_eom_handler();
		return;
	}
	else
	{
		pmbus_state = PMBUS_STATE_IDLE;
		pmbus_idle_handler();
		return ;
	}
}
