//pmbus.c

#include "include.h"  

const Uint8 debug_0_text[] = DEBUG_0_TEXT;
const Uint8 debug_1_text[] = DEBUG_1_TEXT;
const Uint8 debug_2_text[] = DEBUG_2_TEXT;
const Uint8 debug_3_text[] = DEBUG_3_TEXT;
const Uint8 debug_4_text[] = DEBUG_4_TEXT;
const Uint8 debug_5_text[] = DEBUG_5_TEXT;
const Uint8 debug_6_text[] = DEBUG_6_TEXT;
const Uint8 debug_7_text[] = DEBUG_7_TEXT;
const Uint8 vbus_full_range_text[] = VBUS_FULL_RANGE_TEXT;
#define NA_TEXT "N/A"
const Uint8 na_text[] = NA_TEXT;

#define YES_TEXT "Yes"
const Uint8 yes_text[] = YES_TEXT;

// Base address table used by the PARM_INFO command
#if NUM_MEMORY_SEGMENTS == 19
	       const Uint32	parm_mem_start[19] = {	RAM_START_ADDRESS, 
												REG_START_ADDRESS,  
												DFLASH_START_ADDRESS,	
												PFLASH_CONST_START_ADDRESS,
												PFLASH_PROG_START_ADDRESS,
												LOOP_MUX_START_ADDRESS,
												FAULT_MUX_START_ADDRESS,
												ADC_START_ADDRESS,
												DPWM3_START_ADDRESS,
												FILTER2_START_ADDRESS,
												DPWM2_START_ADDRESS,
												FE_CTRL2_START_ADDRESS,
												FILTER1_START_ADDRESS,
												DPWM1_START_ADDRESS,
												FE_CTRL1_START_ADDRESS,
												FILTER0_START_ADDRESS,
												DPWM0_START_ADDRESS,
												FE_CTRL0_START_ADDRESS,
												SYSTEM_REGS_START_ADDRESS	};

	       const Uint16	parm_mem_length[19] = {	RAM_LENGTH, 
												REG_LENGTH,  
												DFLASH_LENGTH,	
												PFLASH_CONST_LENGTH,
												PFLASH_PROG_LENGTH,
												LOOP_MUX_LENGTH,
												FAULT_MUX_LENGTH,
												ADC_LENGTH,
												DPWM3_LENGTH,
												FILTER2_LENGTH,
												DPWM2_LENGTH,
												FE_CTRL2_LENGTH,
												FILTER1_LENGTH,
												DPWM1_LENGTH,
												FE_CTRL1_LENGTH,
												FILTER0_LENGTH,
												DPWM0_LENGTH,
												FE_CTRL0_LENGTH,
												SYSTEM_REGS_LENGTH	};
#elif NUM_MEMORY_SEGMENTS == 5
	       const Uint32	parm_mem_start[5] = {	RAM_START_ADDRESS, 
												REG_START_ADDRESS,  
												DFLASH_START_ADDRESS,	
												PFLASH_CONST_START_ADDRESS,
												PFLASH_PROG_START_ADDRESS	};
	       const Uint16	parm_mem_length[5] = {	RAM_LENGTH, 
												REG_LENGTH,  
												DFLASH_LENGTH,	
												PFLASH_CONST_LENGTH,
												PFLASH_PROG_LENGTH		};
#else // Use only 4 memory segments -- Not Program	
	       const Uint32	parm_mem_start[4] = {	RAM_START_ADDRESS, 
												REG_START_ADDRESS,  
												DFLASH_START_ADDRESS,	
												PFLASH_CONST_START_ADDRESS};
	       const Uint16	parm_mem_length[4] = {	RAM_LENGTH, 
												REG_LENGTH,  
												DFLASH_LENGTH,	
												PFLASH_CONST_LENGTH	};
#endif
 
const Uint8 setup_id[] = SETUP_ID;
const Uint8 cmd_pfc[]  = CMD_PFC;
const Uint8 cmd_dcdc[] = CMD_DCDC;

extern const Uint32 parm_mem_start[NUM_MEMORY_SEGMENTS];
extern const Uint16 parm_mem_length[NUM_MEMORY_SEGMENTS]; 

//==========================================================================================
// pmbus_write_parm_info() checks for a valid input then assigns value to
//	parm_index, parm_offset and parm_length.  These values are needed to uniquely identify
//	a variable or register location in the system that will be queried or modified by the
//	parm_value command. 
//
// Global Inputs: 
//	pmbus_buffer[2]		parm_index. 0=RAM, 1=Registers, 2=DFlash, 3=PFlash Consts, {4=PFlash Program}
//	pmbus_buffer[3:4]	signed offset added to base address pointed to by parm_index
//	pmbus_buffer[5]		number of elements to transfer
//  pmbus_buffer[6]		size, in bytes, of the elements to tranfer (1, 2 or 4 bytes)
//
// modified globals
//	parm_index		Index to a memory section base address
//	parm_offset		Offset added to memory section base address, in multiples of parm_size bytes.
//  parm_count		Number of values to be transferred
//	parm_size		Number of bytes for each value (1, 2, or 4)
//==========================================================================================
Uint8 pmbus_write_parm_info(void)
{
	Uint8	temp_index;
	int16	temp_offset;	
	Uint8	temp_count;		
	Uint8	temp_size;	
	Uint8	temp_length;	

	temp_index  = pmbus_buffer[2];
	temp_offset = pmbus_buffer[3] + (pmbus_buffer[4]<<8);
	temp_count	= pmbus_buffer[5];
	temp_size   = pmbus_buffer[6];
	temp_length = temp_count * temp_size; 


	// ----- Validate the incoming arguments -----

	// ----- VALIDATE DATA -----
	// Verify that the specified base is valid
	// 0 (RAM)  and 1 (REGS) are valid for reading or writing.
	// 2 (DFLASH), 3 (PFLASH_CONST), and 4 (PFLASH_PROG) are read-only.
	// They will be flagged in pmbus_write_parm_value() if a write to them is attempted.
  	if(temp_index > NUM_MEMORY_SEGMENTS)  // Unsigned.    
		{
			return PMBUS_INVALID_DATA;	// Error: Invalid Index
		}

		// Verify that the message is short enough to fit
	if(temp_length > 32)
		{
			return PMBUS_INVALID_DATA;	// Error: Length greater than SAA capabilities.
		}

		// Verify that the size is 1, 2, or 4 bytes 
	if ((temp_size != 1) && (temp_size != 2) && (temp_size != 4))
		{
			return PMBUS_INVALID_DATA;	// Error: Invalid size
		}
		

	// ----- EXECUTE COMMAND -----
	// Arguments valid, assign values.
	parm_index	= temp_index;
	parm_offset	= temp_offset;
	parm_count	= temp_count;
	parm_size   = temp_size;

	return PMBUS_SUCCESS;
}

//==========================================================================================
// pmbus_read_parm_info() returns the value of the parm_index variable.
//==========================================================================================
Uint8 pmbus_read_parm_info(void)		                                                               
{                                                                                                                                                          
	// return a block of data with parm_index, parm_offset and parm_length   
	Uint8	num_bytes = 5;                                                                                                
	pmbus_buffer[0] = num_bytes;
	pmbus_buffer[1] = (Uint8)(parm_index);	
	pmbus_buffer[2] = (Uint8)(parm_offset & 0xff); 		//low byte of value
	pmbus_buffer[3] = (Uint8)(parm_offset >> 8); 		//high byte of value    
	pmbus_buffer[4] = (Uint8)(parm_count);
	pmbus_buffer[5] = (Uint8)(parm_size);    
	pmbus_number_of_bytes = num_bytes+1;                                                            
	return PMBUS_SUCCESS;                                                               
}                                                                                                                                                          
 
//==========================================================================================
// pmbus_write_parm_value()  This command gives the host a way to write virtually any
//	memory address in the system.
//	The host issues a parm_info command to set-up the parm_index, parm_offset
//	and parm_length parameters that determine how this command will	handle the incoming 
//	data. 
//
// modified globals
//	The memory pointed to by the combination of parm_index, parm_offset, and parm_size
//==========================================================================================
Uint8 pmbus_write_parm_value(void)
{
	Uint8	buffer_index;	// index into pmbus_buffer
	Uint16	start_offset;	// Byte Offset into selected memory segment
	Uint8	length;			// Total number of bytes to transfer
	Uint32	start_address;	// Starting byte address in selected memory segment
	Uint32	i;				// generic loop counter

	length = parm_count * parm_size;	// Total number of bytes to transfer
	start_offset = parm_offset * parm_size;

	// ----- VALIDATE DATA -----
		// Verify that the message is short enough to fit and that 
		// the number of bytes sent in this PARM_VALUE command matches the number
		// of bytes requested in the previous PARM_INFO command.
	if( (length > 32) || (length != pmbus_buffer[1]) )
	{
		return	PMBUS_INVALID_DATA;		// Error: Length greater than SAA capabilities
										//     or Lengths don't match
	}

	// ----- Validate the parm arguments -----
	// These should have already been checked by the PARM_INFO command, 
	// but because writing to invalid locations could cause so much havoc,
	// we will check them again here.

	// Verify that the index is valid for writing
	if ((parm_index == 2) || (parm_index == 3) || (parm_index == 4) || parm_index == 18)
			// don't allow writes to any flash or to system registers.
	{
		return PMBUS_INVALID_DATA;	// Error: Invalid Index
	}

	// Verify that the starting and ending offsets are both within the valid memory range
	if (  ( start_offset		 > parm_mem_length[parm_index])	
		||((start_offset+length) > parm_mem_length[parm_index])  )
	{
		return PMBUS_INVALID_DATA;	// Error: Starting or ending addr out of range
	}
		
 

	// ----- EXECUTE COMMAND -----
	// Else it is a valid address.
	start_address = parm_mem_start[parm_index] + start_offset; 


	buffer_index = 2;	// Data starts in 3rd byte of buffer (for C the third byte is index=2)

	// Verification that the size is 1, 2, or 4 bytes is handled by the 'default' case in
	// the switch statement below.

	// Fill the transmit buffer with the requested data in 1, 2, or 4 byte chunks.
	switch (parm_size)
	{
	case 1:			// Transfer 1 byte at a time
		{	
			Uint8*	dest_ptr = (Uint8*)start_address;	

			for (i=0; i<parm_count; i++)
			{
				// Copy from the pmbus_buffer to the destination 1 byte at a time
				Uint8 val= pmbus_buffer[buffer_index];	
				*dest_ptr++ = val;
				buffer_index += parm_size;
			}
			break;
		}

	case 2:		// Transfer 2 bytes at a time
		{
			Uint16*	dest_ptr = (Uint16*)start_address;	

			for (i=0; i<parm_count; i++)
			{
				// Copy from the pmbus_buffer to the destination 2 bytes at a time
				Uint16 val=   (pmbus_buffer[buffer_index+0] << 0)
				        + (pmbus_buffer[buffer_index+1] << 8);		    
				*dest_ptr++ = val;
				buffer_index += parm_size;
			}
			break;
		}

	case 4:		// Transfer 4 bytes at a time
		{
			Uint32*	dest_ptr = (Uint32*)start_address;	

			for (i=0; i<parm_count; i++)
			{
				// Copy from the pmbus_buffer to the destination 4 bytes at a time
				Uint32 val=  (pmbus_buffer[buffer_index+0] << 0 )
				           + (pmbus_buffer[buffer_index+1] << 8 )		    
				           + (pmbus_buffer[buffer_index+2] << 16)
				           + (pmbus_buffer[buffer_index+3] << 24);
				*dest_ptr++ = val;
				buffer_index += parm_size;
			}
			break;
		}
	default:
		{
			// Should never get here since size should have been checked by parm_info cmd
			return	PMBUS_INVALID_DATA;		// Error: Invalid size
		}
	}	// end switch (parm_size)

	return PMBUS_SUCCESS;
}

//------------------------------------------------------------------------------------------
// send_string() puts a string into pmbus_buffer for transmitting.
//
// Modified Globals:
//  pmbus_buffer[PMBUS_BUFFER_LENGTH]   buffer holding read data for PMBus hardware
//  pmbus_buffer_bytes                  number of bytes to return
//------------------------------------------------------------------------------------------
Uint8 send_string_memcpy(const char *string, Uint32 length)    // DO NOT INLINE THIS FUNCTION.
{
    // Test length to prevent accidentally writing beyond end of buffer and corrupting
    // other memory.
    pmbus_buffer[0] = length;

    memcpy(&pmbus_buffer[1], string, length);

    pmbus_number_of_bytes = length + 1;

    return PMBUS_SUCCESS;
}
                                                                                                                                    
//==========================================================================================
// pmbus_read_parm_value() returns the value of the parm_index variable.
//
//	Assumptions: This function assumes that write_parm_info has ensured these conditions. 
//		* parm_index is pointing to a valid memory segment
//		* transfer length (==parm_count*parm_size) is <= 32 bytes
//==========================================================================================
Uint8 pmbus_read_parm_value(void)		                                                               
{   
	Uint16	start_offset;	// Byte Offset into selected memory segment
	Uint8 	length;			// Total number of bytes to transfer
	Uint8*	start_address; 	// Starting byte address in selected memory segment

	// Verify that the starting and ending offsets are both within the valid memory range
	start_offset = parm_offset * parm_size;
	length       = parm_count  * parm_size;
	if (  ( start_offset 		 > parm_mem_length[parm_index])	
	  	||((start_offset+length) > parm_mem_length[parm_index])  )
	{
		return PMBUS_INVALID_DATA;	// Error: Starting or ending addr out of range
	}

	// Else it is a valid address.
	start_address = (Uint8*)parm_mem_start[parm_index] + start_offset; 
	
	return send_string_memcpy((char*)start_address, length);
}                                                                                                                                                          

void watchdog_reset(void)
{
	Dpwm1Regs.DPWMCTRL1.bit.GPIO_B_VAL = 0;//drive low
	Dpwm2Regs.DPWMCTRL1.bit.GPIO_B_VAL = 0;//drive low
	Dpwm1Regs.DPWMCTRL1.bit.GPIO_B_EN = 1;//turn off phase 1
	Dpwm2Regs.DPWMCTRL1.bit.GPIO_B_EN = 1;//turn off phase 2

	MiscAnalogRegs.GLBIOVAL.all = 0;//make the output(s) all zeroes,to turn off relay
		
	TimerRegs.WDCTRL.bit.CPU_RESET_EN = 1;  // Make sure the watchdog is enabled.
	TimerRegs.WDCTRL.bit.WD_PERIOD = 1;		// Set WD period to timeout faster.

	// This will never test true, but it prevents a compiler warning about unreachable code.
	while(1);						// Wait for the watchdog.
}

//==========================================================================================
// pmbus_write_rom_mode() 
//	Erases the program integrity word in FLASH, then waits for watchdog timer to reset the 
// CPU.  There is no return code or return from this function.  
//==========================================================================================
int32 pmbus_write_rom_mode(void)
{
	clear_integrity_word();			// Call a SWI to clear the integrity word.

	watchdog_reset();				// Wait for watchdog to expire and force CPU reset.
							
	return PMBUS_SUCCESS;			// Note: This line is never reached.  
}

int32 pmbus_read_one_byte_handler(Uint8 value) 
{
	pmbus_number_of_bytes = 1;
	pmbus_buffer[0] = value;  
	return PMBUS_SUCCESS;
}

int32 pmbus_read_two_byte_handler(Uint16 value) 
{
	pmbus_number_of_bytes = 2;
	pmbus_buffer[1] = value >> 8;
	pmbus_buffer[0] = value & 0xff;
	return PMBUS_SUCCESS;
}

Uint8 pmbus_write_vout_cmd(void)
{
	int32 temp = pmbus_buffer[1] + (pmbus_buffer[2] << 8); //vout mode is zero, so it's an integer.
	if(temp < 300) //if it's too small
	{
		iv.vbus_voltage = 300;
	}
	else if (temp > 400 )	//if it's too big
	{
		iv.vbus_voltage = 400;
	}
	else //if it's just right
	{
	    iv.vbus_voltage = temp + pfc_config_in_ram.PFC_CAL.VOUT_CAL_OFFSET;
	}
  	iv.vbus_target = ((int32)((iv.vbus_voltage * 4095)/VBUS_FULL_RANGE));

  	return PMBUS_SUCCESS;
}

Uint8 pmbus_read_vout_cmd(void)
{
	pmbus_read_two_byte_handler(iv.vbus_voltage);

	return PMBUS_SUCCESS;
}

int32 pmbus_read_vout_handler(void) 
{
	Uint32 temp;
#if !Temperature_sense_share_vbus
	temp = (iv.adc_avg[VBUS_CHANNEL] * VBUS_FULL_RANGE) >> 12;
#else
	temp = (iv.vbus_avg * VBUS_FULL_RANGE) >> 12;
#endif

	return pmbus_read_two_byte_handler(temp);
}

int32 pmbus_read_iin(void) 
{
	Uint16 temp;

	if(iin_rms < 2000)//2A
	{
		temp = 0xB800 + ((iin_rms << 9) / 1000);//exponent -9
	}
	else
	{
		temp = 0xC000 + ((iin_rms << 8) / 1000);//exponent -8
	}

	return pmbus_read_two_byte_handler(temp);
}

int32 pmbus_read_pin(void) 
{
	Uint16 temp;

	if(pin < 150) //15W
	{
		temp = 0xD000 + ((pin << 6) / 10);//exponent -6
	}
	else if(pin < 310) //31W
	{
		temp = 0xD800 + ((pin << 5) / 10);//exponent -5
	}
	else if(pin < 630) //63W
	{
		temp = 0xE000 + ((pin << 4) / 10);//exponent -4
	}
	else if(pin < 1270) //127W
	{
		temp = 0xE800 + ((pin << 3) / 10);//exponent -3
	}
	else if(pin < 2550) //255W
	{
		temp = 0xF000 + ((pin << 2) / 10);//exponent -2
	}
	else 
	{
		temp = 0xF800 + ((pin << 1) / 10);//exponent -1
	}

	return pmbus_read_two_byte_handler(temp);
}

Uint8 pmbus_write_vout_ov_fault_limit(void)
{
	Uint32 temp = pmbus_buffer[1] + (pmbus_buffer[2] << 8); //vout mode is zero, so it's an integer.
	if(temp < 300) //if it's too small
	{
		temp = 300;
	}
	else if (temp > 450 )	//if it's too big
	{
		temp = 450;
	}

	FaultMuxRegs.ACOMPCTRL0.bit.ACOMP_B_THRESH = ((int32)((temp * 127) / VBUS_FULL_RANGE));

	return PMBUS_SUCCESS;
}

Uint8 pmbus_read_vout_ov_fault_limit(void)
{
	Uint32 temp;

	temp = ((Uint32)FaultMuxRegs.ACOMPCTRL0.bit.ACOMP_B_THRESH * VBUS_FULL_RANGE) / 127;

	pmbus_read_two_byte_handler(temp);

	return PMBUS_SUCCESS;
}

int pmbus_read_setup_id(void) 
{
	Uint8 byte;
	pmbus_number_of_bytes = SETUP_ID_LENGTH + 1;

	if (pmbus_number_of_bytes <= 40)
	{
		for (byte = 0; byte < SETUP_ID_LENGTH; byte++)
		{
			pmbus_buffer[byte+1] = (Uint8)setup_id[byte];
		} 
	}	   
	pmbus_buffer[0] = SETUP_ID_LENGTH;
	return PMBUS_SUCCESS;
}

Uint8 pmbus_read_cmd_dcdc_paged(void)
{
  	Uint8 byte;
 	pmbus_number_of_bytes = 32 + 1;
   
    for(byte = 0; byte < 32; byte ++)
	{
	    pmbus_buffer[byte+1] = (Uint8) cmd_dcdc[byte];
	}	
    pmbus_buffer[0] = 32;
	return PMBUS_SUCCESS;
}

Uint8 pmbus_read_cmd_dcdc_nonpaged(void)
{
  	Uint8 byte;
 	pmbus_number_of_bytes = 32 + 1;
   
    for(byte = 0; byte < 32; byte ++)
	{
	    pmbus_buffer[byte+1] = (Uint8) cmd_dcdc[byte];
	}	
    pmbus_buffer[0] = 32;
	return PMBUS_SUCCESS;
}

Uint8 pmbus_read_cmd_pfc(void)
{
  	Uint8 byte;
 	pmbus_number_of_bytes = 32 + 1;
   
    for(byte = 0; byte < 32; byte ++)
	{
	    pmbus_buffer[byte+1] = (Uint8) cmd_pfc[byte];
	}	
    pmbus_buffer[0] = 32;
	return PMBUS_SUCCESS;
}

int32 pmbus_mfr_id_handler(void) 
{
	pmbus_number_of_bytes = 3;
	pmbus_buffer[0] = 2; 
	pmbus_buffer[1] = 'T';
	pmbus_buffer[2] = 'I'; 
	return PMBUS_SUCCESS ;
}

int32 pmbus_mfr_model_handler(void) 
{
	pmbus_number_of_bytes = 7;
	pmbus_buffer[0] = 6; 
	pmbus_buffer[1] = 'P';
	pmbus_buffer[2] = 'F'; 
	pmbus_buffer[3] = 'C';
	pmbus_buffer[4] = '0'; 
	pmbus_buffer[5] = '0'; 
	pmbus_buffer[6] = '0'; 
	return PMBUS_SUCCESS ;
}

int32 pmbus_mfr_revision_handler(void) 
{
	pmbus_number_of_bytes = 6;
	pmbus_buffer[0] = 5; 
#if 1
	pmbus_buffer[1] = fw_revision[0];
	pmbus_buffer[2] = fw_revision[1];
	pmbus_buffer[3] = fw_revision[2];
	pmbus_buffer[4] = fw_revision[3];
//	pmbus_buffer[5] = 5;
#else
	pmbus_buffer[1] = '0';
	pmbus_buffer[2] = '.'; 
	pmbus_buffer[3] = '0';
	pmbus_buffer[4] = '.'; 
	pmbus_buffer[5] = '1';
#endif
	return PMBUS_SUCCESS ;
}

Uint8 pmbus_read_debug_buffer(void)
{
 	Uint8 byte;
 	pmbus_number_of_bytes = 8 + 1;
    for(byte = 0; byte < 8; byte ++)
	{
	    pmbus_buffer[byte+1] = 0;
	}
    pmbus_buffer[0] = 8;
 	return PMBUS_SUCCESS;
}

int pmbus_read_gui_constant(void) 
{ 
	Uint8 byte;
	pmbus_number_of_bytes = sizeof(DEBUG_0_TEXT) + 1;

	switch (gui_constant_pointer) 			// look at command byte from a write perspective
	{
		case 10: 
			pmbus_number_of_bytes = sizeof(DEBUG_0_TEXT) + 1;
			for (byte = 0; byte < sizeof(DEBUG_0_TEXT); byte++)
			{
				pmbus_buffer[byte+1] = (Uint8)debug_0_text[byte];
			} 
			pmbus_buffer[0] = sizeof(DEBUG_0_TEXT);
			break;
		case 11: 
			pmbus_number_of_bytes = sizeof(DEBUG_1_TEXT) + 1;
			for (byte = 0; byte < sizeof(DEBUG_1_TEXT); byte++)
			{
				pmbus_buffer[byte+1] = (Uint8)debug_1_text[byte];
			} 
			pmbus_buffer[0] = sizeof(DEBUG_1_TEXT);
			break;
		case 12: 
			pmbus_number_of_bytes = sizeof(DEBUG_2_TEXT) + 1;
			for (byte = 0; byte < sizeof(DEBUG_2_TEXT); byte++)
			{
				pmbus_buffer[byte+1] = (Uint8)debug_2_text[byte];
			} 
			pmbus_buffer[0] = sizeof(DEBUG_2_TEXT);
			break;
		case 13: 
			pmbus_number_of_bytes = sizeof(DEBUG_3_TEXT) + 1;
			for (byte = 0; byte < sizeof(DEBUG_3_TEXT); byte++)
			{
				pmbus_buffer[byte+1] = (Uint8)debug_3_text[byte];
			} 
			pmbus_buffer[0] = sizeof(DEBUG_3_TEXT);
			break;
		case 14: 
			pmbus_number_of_bytes = sizeof(DEBUG_4_TEXT) + 1;
			for (byte = 0; byte < sizeof(DEBUG_4_TEXT); byte++)
			{
				pmbus_buffer[byte+1] = (Uint8)debug_4_text[byte];
			} 
			pmbus_buffer[0] = sizeof(DEBUG_4_TEXT);
			break;
		case 15: 
			pmbus_number_of_bytes = sizeof(DEBUG_5_TEXT) + 1;
			for (byte = 0; byte < sizeof(DEBUG_5_TEXT); byte++)
			{
				pmbus_buffer[byte+1] = (Uint8)debug_5_text[byte];
			} 
			pmbus_buffer[0] = sizeof(DEBUG_5_TEXT);
			break;
		case 16: 
			pmbus_number_of_bytes = sizeof(DEBUG_6_TEXT) + 1;
			for (byte = 0; byte < sizeof(DEBUG_6_TEXT); byte++)
			{
				pmbus_buffer[byte+1] = (Uint8)debug_6_text[byte];
			} 
			pmbus_buffer[0] = sizeof(DEBUG_6_TEXT);
			break;
		case 17: 
			pmbus_number_of_bytes = sizeof(DEBUG_7_TEXT) + 1;
			for (byte = 0; byte < sizeof(DEBUG_7_TEXT); byte++)
			{
				pmbus_buffer[byte+1] = (Uint8)debug_7_text[byte];
			} 
			pmbus_buffer[0] = sizeof(DEBUG_7_TEXT);
			break;
			
		case 110: 
			pmbus_number_of_bytes = sizeof(VBUS_FULL_RANGE_TEXT) + 1;
			for (byte = 0; byte < sizeof(VBUS_FULL_RANGE_TEXT); byte++)
			{
				pmbus_buffer[byte+1] = (Uint8)vbus_full_range_text[byte];
			} 
			pmbus_buffer[0] = sizeof(VBUS_FULL_RANGE_TEXT);
			break;
		case 111: //send "yes" if TFA is enabled
			pmbus_number_of_bytes = sizeof(NA_TEXT) + 1;
			for (byte = 0; byte < sizeof(NA_TEXT); byte++)
			{
				pmbus_buffer[byte+1] = (Uint8)na_text[byte];
			} 
			pmbus_buffer[0] = sizeof(NA_TEXT);
			break;
		case 112: 
			pmbus_number_of_bytes = 2;
			pmbus_buffer[1] = 1; //this signifies it's a 31xx
			pmbus_buffer[0] = 1; //block mode, block length of 1
			break;
		default:
			pmbus_number_of_bytes = sizeof(NA_TEXT) + 1;
			for (byte = 0; byte < sizeof(NA_TEXT); byte++)
			{
				pmbus_buffer[byte+1] = (Uint8)na_text[byte];
			} 
			pmbus_buffer[0] = sizeof(NA_TEXT);
			break;
	}
	return PMBUS_SUCCESS ;
}

Uint8 pmbus_write_gui_constant(void)
{
	gui_constant_pointer = pmbus_buffer[2];
	return PMBUS_SUCCESS;
}

Uint8 pmbus_write_user_ram_00(void)
{
	user_ram_00 = pmbus_buffer[1];
	return PMBUS_SUCCESS;
}
	
Uint8 pmbus_read_user_ram_00(void)
{
	pmbus_buffer[0] = user_ram_00;
	pmbus_number_of_bytes = 1;
	return PMBUS_SUCCESS;
}

int32 sign_extend(int value, int number_of_bits) //sign extends value in lsbits to an int
{
	int32 temp = (int)(value << (32 - number_of_bits)); //shift it up to put sign bit in place
	return temp >> (32 - number_of_bits);
}

int32 simple_translate() //translate from linear to an integer, no scaling - 
{
	int32 exponent = sign_extend(pmbus_buffer[2] >> 3,5);
	int32 mantissa = sign_extend((pmbus_buffer[1] + (pmbus_buffer[2] << 8)) & 0x7ff,11);
	if(exponent < 0) //negative exponent
	{
		return mantissa >> (- exponent);
	}
	else
	{
		return mantissa << exponent;
	}
}

Uint8 pmbus_write_frequency(void)
{
	int32 temp = simple_translate(); //take from linear mode.
	if(temp != switching_frequency) //if new switching frequency
	{
		if((temp >= MIN_SWITCH_FREQ) &&
		  (temp <= MAX_SWITCH_FREQ))
		{
			switching_frequency = temp;
			set_new_switching_frequency();
		}
	}
	return PMBUS_SUCCESS;
}  

Uint8 pmbus_write_calibration_data(void)
{
	CMD_GEN_CAL_W_Handler();
	return PMBUS_SUCCESS;
}

Uint8 pmbus_read_calibration_info(void)		                                                               
{
	Uint8 num_bytes = 32;

	pmbus_buffer[0] = num_bytes;

	pmbus_buffer[1] = (Uint8)(iin_slope >> 24);
	pmbus_buffer[2] = (Uint8)(iin_slope >> 16);
	pmbus_buffer[3] = (Uint8)(iin_slope >> 8);
	pmbus_buffer[4] = (Uint8)(iin_slope & 0xff);

	pmbus_buffer[5] = (Uint8)(iin_slope_shift >> 24);
	pmbus_buffer[6] = (Uint8)(iin_slope_shift >> 16);
	pmbus_buffer[7] = (Uint8)(iin_slope_shift >> 8);
	pmbus_buffer[8] = (Uint8)(iin_slope_shift & 0xff);

	pmbus_buffer[9] = (Uint8)(iin_offset >> 24);
	pmbus_buffer[10] = (Uint8)(iin_offset >> 16);
	pmbus_buffer[11] = (Uint8)(iin_offset >> 8);
	pmbus_buffer[12] = (Uint8)(iin_offset & 0xff);

	pmbus_buffer[13] = (Uint8)(iin_offset_shift >> 24);
	pmbus_buffer[14] = (Uint8)(iin_offset_shift >> 16);
	pmbus_buffer[15] = (Uint8)(iin_offset_shift >> 8);
	pmbus_buffer[16] = (Uint8)(iin_offset_shift & 0xff);

	pmbus_buffer[17] = (Uint8)(vin_slope >> 14);
	pmbus_buffer[18] = (Uint8)(vin_slope >> 16);
	pmbus_buffer[19] = (Uint8)(vin_slope >> 8);
	pmbus_buffer[20] = (Uint8)(vin_slope & 0xff);

	pmbus_buffer[21] = (Uint8)(vin_slope_shift >> 24);
	pmbus_buffer[22] = (Uint8)(vin_slope_shift >> 16);
	pmbus_buffer[23] = (Uint8)(vin_slope_shift >> 8);
	pmbus_buffer[24] = (Uint8)(vin_slope_shift & 0xff);

	pmbus_buffer[25] = (Uint8)(vin_offset >> 24);
	pmbus_buffer[26] = (Uint8)(vin_offset >> 16);
	pmbus_buffer[27] = (Uint8)(vin_offset >> 8);
	pmbus_buffer[28] = (Uint8)(vin_offset & 0xff);

	pmbus_buffer[29] = (Uint8)(vin_offset_shift >> 24);
	pmbus_buffer[30] = (Uint8)(vin_offset_shift >> 16);
	pmbus_buffer[31] = (Uint8)(vin_offset_shift >> 8);
	pmbus_buffer[32] = (Uint8)(vin_offset_shift & 0xff);

	pmbus_number_of_bytes = num_bytes+1;
	return PMBUS_SUCCESS;
}

int32 pmbus_write_message(void)
{
	switch (pmbus_buffer[0]) 			// look at command byte from a write perspective
	{
		case PMBUS_CMD_ROM_MODE: 			return pmbus_write_rom_mode();
		case PMBUS_CMD_STORE_DEFAULT_ALL: 	return pmbus_write_store_default_all();
		case PMBUS_CMD_RESTORE_DEFAULT_ALL: return pmbus_write_restore_default_all();
		case PMBUS_CMD_VOUT_COMMAND: 		return pmbus_write_vout_cmd();
		case PMBUS_CMD_MFR_PI_COEFFICIENTS: return pmbus_write_pi_coefficients();
		case PMBUS_CMD_VOUT_OV_FAULT_LIMIT: return pmbus_write_vout_ov_fault_limit();
		case PMBUS_CMD_FREQUENCY_SWITCH: 	return pmbus_write_frequency();
		case PMBUS_CMD_USER_RAM_00: 		return pmbus_write_user_ram_00();
		case PMBUS_CMD_MFR_GUI_CONSTANTS: 	return pmbus_write_gui_constant();
        case PMBUS_CMD_MFR_PARM_INFO: 		return pmbus_write_parm_info();
		case PMBUS_CMD_MFR_PARM_VALUE: 		return pmbus_write_parm_value();
		case PMBUS_CMD_USER_DATA_13:		return pmbus_write_calibration_data();
		default:
			break;
	}
	return 0; 
}

int32 pmbus_read_message(void)
{
	switch (pmbus_buffer[0]) 			// look at command byte from a read perspective
	{
		case PMBUS_CMD_VOUT_MODE: 				return pmbus_read_one_byte_handler(0x0); //linear, 0 exponent
		case PMBUS_CMD_READ_VOUT: 				return pmbus_read_vout_handler();
		case PMBUS_CMD_PMBUS_REVISION: 			return pmbus_read_one_byte_handler(0x11); //version 1.1 for both
		case PMBUS_CMD_MFR_ID: 					return pmbus_mfr_id_handler(); 
		case PMBUS_CMD_MFR_MODEL: 				return pmbus_mfr_model_handler(); 
		case PMBUS_CMD_MFR_REVISION: 			return pmbus_mfr_revision_handler(); 
        case PMBUS_CMD_MFR_CMDS_DCDC_PAGED: 	return pmbus_read_cmd_dcdc_paged();
        case PMBUS_CMD_MFR_CMDS_DCDC_NONPAGED: 	return pmbus_read_cmd_dcdc_nonpaged();
        case PMBUS_CMD_MFR_CMDS_PFC: 			return pmbus_read_cmd_pfc();		
		case PMBUS_CMD_MFR_SETUP_ID: 			return pmbus_read_setup_id();
		case PMBUS_CMD_MFR_DEVICE_ID: 			return pmbus_read_device_id() ;
		case PMBUS_CMD_FREQUENCY_SWITCH: 		return pmbus_read_two_byte_handler(switching_frequency);					
		case PMBUS_CMD_READ_FREQUENCY:			return pmbus_read_two_byte_handler(switching_frequency);
		case PMBUS_CMD_MFR_DEBUG_BUFFER: 		return pmbus_read_debug_buffer();
		case PMBUS_CMD_VOUT_COMMAND:        	return pmbus_read_vout_cmd();
		case PMBUS_CMD_MFR_GUI_CONSTANTS: 		return pmbus_read_gui_constant();
		case PMBUS_CMD_MFR_PI_COEFFICIENTS: 	return pmbus_read_pi_coefficients();
		case PMBUS_CMD_USER_RAM_00: 			return pmbus_read_user_ram_00();
		case PMBUS_CMD_VOUT_OV_FAULT_LIMIT: 	return pmbus_read_vout_ov_fault_limit();
		case PMBUS_CMD_MFR_PARM_INFO: 			return pmbus_read_parm_info();
		case PMBUS_CMD_MFR_PARM_VALUE: 			return pmbus_read_parm_value();
		case PMBUS_CMD_READ_IIN:				return pmbus_read_iin();
		case PMBUS_CMD_READ_PIN:				return pmbus_read_pin();
		case PMBUS_CMD_USER_DATA_14: 			return pmbus_read_calibration_info();
		default:
			pmbus_number_of_bytes = 16;
			pmbus_buffer[0] = 0x0f;
			pmbus_buffer[1] = 0x22;
			pmbus_buffer[2] = 0x33;
			pmbus_buffer[3] = 0x44;
			pmbus_buffer[4] = 0x55;
			pmbus_buffer[5] = 0x66;
			pmbus_buffer[6] = 0x77;
			pmbus_buffer[7] = 0x88;
			pmbus_buffer[8] = 0x99;
			pmbus_buffer[9] = 0xaa;
			pmbus_buffer[10] = 0xbb;
			pmbus_buffer[11] = 0xcc;
			pmbus_buffer[12] = 0xdd;
			pmbus_buffer[13] = 0xee;
			pmbus_buffer[14] = 0xff;
			pmbus_buffer[15] = 0x01;
			return 0 ;
	}
}

		




