//pmbus_coefficients.c

#include "include.h"  

#pragma DATA_SECTION(pfc_config_constants_a, ".CONFIG_A");
volatile const PFC_CONFIG_STRUCT pfc_config_constants_a = PFC_CONFIG_DEFAULT;

#pragma DATA_SECTION(pfc_config_checksum_a, ".CONFIG_A");
volatile const Uint32 pfc_config_checksum_a = 0x87654321;

#pragma DATA_SECTION(pfc_config_constants_b, ".CONFIG_B");
volatile const PFC_CONFIG_STRUCT pfc_config_constants_b;

#pragma DATA_SECTION(pfc_config_checksum_b, ".CONFIG_B");
volatile const Uint32 pfc_config_checksum_b;

const PFC_CONFIG_STRUCT pfc_config_hardcoded = PFC_CONFIG_DEFAULT;

Uint8 pmbus_write_pi_coefficients(void)
{                                                                                                                                                          
	int32	byte;	// Byte loop index

	for(byte=0; byte < 19; byte++)
	{
		copy_buffer.byte[byte] = pmbus_buffer[2+byte];
	}

	iv.pis.kp 	 		= copy_buffer.word[0];	// B01 and B11
	iv.pis.ki 	 		= copy_buffer.word[1];	// B21 and COEF_SCALER
	iv.pis.kp_nl 		= copy_buffer.word[2];	// A11 and A21
	iv.pis.ki_nl 		= copy_buffer.word[3];	// B12 and A12
	byte 				= copy_buffer.byte[17] + (copy_buffer.byte[16] << 8);
	iv.pis.nl_threshold = (byte << 12) / VBUS_FULL_RANGE;
	
	return PMBUS_SUCCESS;
}

Uint8 pmbus_read_pi_coefficients(void)
{
	int32 byte;
	pmbus_number_of_bytes = 19;

	copy_buffer.word[0]	 = iv.pis.kp;	
	copy_buffer.word[1]  = iv.pis.ki;
	copy_buffer.word[2]  = iv.pis.kp_nl;
	copy_buffer.word[3]  = iv.pis.ki_nl;
	byte = (((iv.pis.nl_threshold * VBUS_FULL_RANGE) + (1 << 11)) >> 12);//round
	copy_buffer.byte[16] = (byte >> 8)& 0xff;			
	copy_buffer.byte[17] = byte & 0xff;
	
	for(byte=0; byte < 18; byte++)
	{
		pmbus_buffer[byte+1] =	copy_buffer.byte[byte];
	}	
	pmbus_buffer[0] = 18;

	return PMBUS_SUCCESS;
}

//==========================================================================================
// pmbus_write_store_default_all()
//	Store all PMBus-configurable variables from RAM to Data Flash.   
//==========================================================================================
Uint8 pmbus_write_store_default_all(void)
{
	Uint8	status;
	Uint32	checksum;

	volatile const PFC_CONFIG_STRUCT*	   		   dest_address_pfc_config;
	volatile const Uint32*						   dest_checksum;

	volatile const PFC_CONFIG_STRUCT*	   		   opposite_bank_start;

	// Number of bytes to erase is the total size of all the blocks, including the checksum.
	// Assumes that the _a and _b structures are the same size.
	volatile const	Uint32	bytes_to_erase = sizeof(pfc_config_constants_a)
									  		 + sizeof(pfc_config_checksum_a);
							 
	// NOTE: This is a SEND BYTE command that requires no additional data validation.
	// ----- EXECUTE COMMAND -----
	// Check for DFlash erase operations in progress
	if (erase_segment_counter > 1)
	{
		// There are multiple segments that still need to be erased.  There is no way to 
		// get them erased in time to avoid a PMBus timeout so we will just report an error
		// and return.
		return PMBUS_OTHER_FAULT;	// CML - Other memory or logic fault has occurred
		
	}
	
	// There are one or zero segments left to erase.
	// Wait for any erase that might be in progress to complete.
	// IMPORTANT!  This must be done before attempting to access any DFlash location, 
	// even if it is not in the segment being erased.
	while(DecRegs.DFLASHCTRL.bit.BUSY != 0)
	{
		; //do nothing while busy erasing DFlash
	}

	copy_configuration_to_ram(&Filter1Regs);
	// Test that the selected bank is completely erased by checking the first and last word.
	// If both are all F's, the bank is completeley erased so use it.
	// (Assumes that all words in between are erased; usually a reasonable assumption.)
	if ((pfc_config_checksum_a == 0xFFFFFFFF)&&(pfc_config_constants_a.FILTERKDCOEF0.bit.KD_COEF_0 == (signed short)0xFFFF))	// Test Dflash A 
	{	
		// DFlash A is blank. 
		//Store new values in DFlash A and erase DFlash B when done.
		dest_address_pfc_config   = &pfc_config_constants_a;
		dest_checksum	          = &pfc_config_checksum_a;
		
		opposite_bank_start		  = &pfc_config_constants_b;
	}
	else if ((pfc_config_checksum_b == 0xFFFFFFFF)&&(pfc_config_constants_b.FILTERKDCOEF0.bit.KD_COEF_0 == (signed short)0xFFFF))	// Test DFlash B 
	{
		// DFlash B is blank.
		// Store new values in DFlash B and erase DFlash A when done.
		dest_address_pfc_config   = &pfc_config_constants_b;
		dest_checksum	          = &pfc_config_checksum_b;
		
		opposite_bank_start		  = &pfc_config_constants_a;
	}
	else
	{
		// Neither bank is blank.  Erase one of them so it will be ready for next time
		// and report a Flash failure.
		if (pfc_config_checksum_b == 0xFFFFFFFF)
		{
			// We got here because DFlash B was only partially erased, probably because
			// of a power failure during the erase process.  Re-erase bank B and leave 
			// bank A intact since it might have valid values.
			dest_address_pfc_config	= &pfc_config_constants_b;
			
		}
		else
		{
			// We got here because DFlash A was partly erased and B was intact,
			// or because both banks were never erased.
			// Either way, we will now erase bank A.
			dest_address_pfc_config	= &pfc_config_constants_a;
		}
		goto flash_write_failed;	// Fail: Destination bank not erased.
	}
    
	// --------------- CLA GAINS  ---------------
	// Call Update Flash to write the necessary segments of Data Flash
	status = update_data_flash((void*)dest_address_pfc_config, &pfc_config_in_ram, sizeof(pfc_config_in_ram));
	if (status != FLASH_SUCCESS)
	{
		goto flash_write_failed;	// Clean up after flash write failure
	}
    
	// --------------- CHECKSUM ---------------
	// Calculate checksum for selected Data Flash segment and write to Data Flash
	checksum = calculate_dflash_checksum((Uint8*)dest_address_pfc_config, (Uint8*)dest_checksum);
	status = update_data_flash((void*)dest_checksum, &checksum, sizeof(checksum));
	if (status != FLASH_SUCCESS)
	{
		goto flash_write_failed;	// Clean up after flash write failure
	}

	{

		// ----- Bank written successfully.  Erase opposite bank. -----
		start_erase_task((void*)opposite_bank_start, bytes_to_erase);	
		// If everything works, return success.
		return PMBUS_SUCCESS;
	}

flash_write_failed:		// <--- Destination for several goto's above.
	{
		// ----- This bank write failed.  Erase present bank and report the failure.
		start_erase_task((void*)dest_address_pfc_config, bytes_to_erase);	
		return (PMBUS_MEMORY_FAULT);		// Flash write failed
	}
} 

void copy_configuration_to_ram(volatile struct FILTER_REGS *source)
{
	//copy PFC configuration
    pfc_config_in_ram.PFC_SETPOINT.VOUT_COMMAND 	= iv.vbus_voltage - pfc_config_in_ram.PFC_CAL.VOUT_CAL_OFFSET;

    pfc_config_in_ram.PFC_SETPOINT.VOUT_OV_LIMIT 	= ((Uint32)FaultMuxRegs.ACOMPCTRL0.bit.ACOMP_B_THRESH * VBUS_FULL_RANGE)/127;
	pfc_config_in_ram.PFC_SETPOINT.FREQUENCY 		= switching_frequency;

	//copy voltage loop gains
	pfc_config_in_ram.PI_GAINS.KP 		  		= iv.pis.kp ;
	pfc_config_in_ram.PI_GAINS.KI 		  		= iv.pis.ki ;
	pfc_config_in_ram.PI_GAINS.KP_NL 		  	= iv.pis.kp_nl;
	pfc_config_in_ram.PI_GAINS.KI_NL 		  	= iv.pis.ki_nl ;
	pfc_config_in_ram.PI_GAINS.NL_THRESHOLD 	= ((iv.pis.nl_threshold * VBUS_FULL_RANGE) + (1 << 11)) >> 12;

	//copy current loop gains
	pfc_config_in_ram.COEFCONFIG.all	  		= source->COEFCONFIG.all;
	pfc_config_in_ram.FILTERKPCOEF0.all 		= source->FILTERKPCOEF0.all;
	pfc_config_in_ram.FILTERKPCOEF1.all 		= source->FILTERKPCOEF1.all;
	pfc_config_in_ram.FILTERKICOEF0.all 		= source->FILTERKICOEF0.all;
	pfc_config_in_ram.FILTERKICOEF1.all 		= source->FILTERKICOEF1.all;
	pfc_config_in_ram.FILTERKDCOEF0.all 		= source->FILTERKDCOEF0.all;
	pfc_config_in_ram.FILTERKDCOEF1.all 		= source->FILTERKDCOEF1.all;
	pfc_config_in_ram.FILTERKDALPHA.all 		= source->FILTERKDALPHA.all;
	pfc_config_in_ram.FILTERNL0.all 	  		= source->FILTERNL0.all;
	pfc_config_in_ram.FILTERNL1.all     		= source->FILTERNL1.all;
	pfc_config_in_ram.FILTERNL2.all     		= source->FILTERNL2.all;

	pfc_config_in_ram.FILTERMISC.bit.NL_MODE 					= source->FILTERCTRL.bit.NL_MODE;
	pfc_config_in_ram.FILTERMISC.bit.SAMPLE_TRIG1_OVERSAMPLE 	= Dpwm1Regs.DPWMCTRL2.bit.SAMPLE_TRIG1_OVERSAMPLE;
	pfc_config_in_ram.FILTERMISC.bit.AFE_GAIN 				= FeCtrl0Regs.EADCCTRL.bit.AFE_GAIN;
}

Uint8 pmbus_write_restore_default_all(void)//load configuration from data flash to registers
{
	Uint32 	checksum;

	// Pointers to structures in Data Flash 
	volatile const  PFC_CONFIG_STRUCT*  	pfc_config_ptr;

	// ----- Look for a copy of default values in Data FLASH that looks valid. -----
	// If none found, use the hard-coded values from Program FLASH.

	// Wait for any erase that might be in progress to complete.
	// IMPORTANT!  This must be done before attempting to access any DFlash location, 
	// even if it is not in the segment being erased.
	while(DecRegs.DFLASHCTRL.bit.BUSY != 0)
	{
		; //do nothing while busy erasing DFlash
	}	

	// Look in Data Flash A for valid values.
	checksum = calculate_dflash_checksum((Uint8*)&pfc_config_constants_a, (Uint8*)&pfc_config_checksum_a);
	// A zero checksum only occurs when the segment is all zeroes, which is not valid.
	// If the calculated checksum is nonzero and matches the checksum in the DFlash,  
	// that segment is good, so use it.
	if(   (pfc_config_checksum_a == 0x87654321)	// Hardcoded exception for parms written directly to data flash
		// (GUI download tool does not calculate checksum)
		||((checksum != 0) && (checksum == pfc_config_checksum_a)) )	// Checksum is valid and matches.
	{
		// Checksum A Good: Use default values from DFlash A
		pfc_config_ptr = &pfc_config_constants_a;
	}
	else
	{
		// Look in Data Flash B for valid values
		checksum = calculate_dflash_checksum((Uint8*)&pfc_config_constants_b, (Uint8*)&pfc_config_checksum_b);
		// A zero checksum only occurs when the segment is all zeroes, which is not valid.
		// If the calculated checksum is nonzero and matches the checksum in the DFlash,  
		// that segment is good, so use it.
		if ((checksum != 0) && (checksum == pfc_config_checksum_b))
		{
			// Checksum B Good: Use default values from DFlash B
			pfc_config_ptr = &pfc_config_constants_b;
		}
		else// No valid values found in Data Flash.  Use hardcoded values from PFlash instead.
		{
			// Use hardcoded values from Program Flash
			pfc_config_ptr = &pfc_config_hardcoded;
		}	
	}

	// ----- Copy default variables from Flash to RAM -----
	memcpy((void *)&pfc_config_in_ram, (void *)pfc_config_ptr, sizeof(pfc_config_constants_a));	

	copy_configuration_to_registers(&Filter1Regs);

	return PMBUS_SUCCESS; 
}

void copy_configuration_to_registers(volatile struct FILTER_REGS *dest)
{
	//copy PFC configuration
    iv.vbus_voltage 	= pfc_config_in_ram.PFC_SETPOINT.VOUT_COMMAND + pfc_config_in_ram.PFC_CAL.VOUT_CAL_OFFSET;
  	iv.vbus_setpoint 	= ((Uint32)((iv.vbus_voltage * 4095)/VBUS_FULL_RANGE));
  	if(iv.supply_state >= STATE_PFC_ON)
  	{
  		iv.vbus_target 	= ((int32)((iv.vbus_voltage * 4095)/VBUS_FULL_RANGE));
	}

  	FaultMuxRegs.ACOMPCTRL0.bit.ACOMP_B_THRESH = ((Uint32)(pfc_config_in_ram.PFC_SETPOINT.VOUT_OV_LIMIT * 127) / VBUS_FULL_RANGE);
	switching_frequency = pfc_config_in_ram.PFC_SETPOINT.FREQUENCY;
//	set_new_switching_frequency();

	//copy voltage loop gains
	iv.pis.kp 			= pfc_config_in_ram.PI_GAINS.KP;
	iv.pis.ki 			= pfc_config_in_ram.PI_GAINS.KI;
	iv.pis.kp_nl 		= pfc_config_in_ram.PI_GAINS.KP_NL;
	iv.pis.ki_nl 		= pfc_config_in_ram.PI_GAINS.KI_NL;
	iv.pis.nl_threshold = (pfc_config_in_ram.PI_GAINS.NL_THRESHOLD << 12) / VBUS_FULL_RANGE;

	//copy current loop gains
	dest->COEFCONFIG.all 			= pfc_config_in_ram.COEFCONFIG.all;
	dest->FILTERKPCOEF0.all 		= pfc_config_in_ram.FILTERKPCOEF0.all;
	dest->FILTERKPCOEF1.all 		= pfc_config_in_ram.FILTERKPCOEF1.all;
	dest->FILTERKICOEF0.all 		= pfc_config_in_ram.FILTERKICOEF0.all;
	dest->FILTERKICOEF1.all 		= pfc_config_in_ram.FILTERKICOEF1.all;
	dest->FILTERKDCOEF0.all 		= pfc_config_in_ram.FILTERKDCOEF0.all;
	dest->FILTERKDCOEF1.all 		= pfc_config_in_ram.FILTERKDCOEF1.all;
	dest->FILTERKDALPHA.all 		= pfc_config_in_ram.FILTERKDALPHA.all;
	dest->FILTERNL0.all 			= pfc_config_in_ram.FILTERNL0.all;
	dest->FILTERNL1.all 			= pfc_config_in_ram.FILTERNL1.all;
	dest->FILTERNL2.all 			= pfc_config_in_ram.FILTERNL2.all;
	dest->FILTERCTRL.bit.NL_MODE 	= pfc_config_in_ram.FILTERMISC.bit.NL_MODE;

	FeCtrl0Regs.EADCCTRL.bit.AFE_GAIN 				= pfc_config_in_ram.FILTERMISC.bit.AFE_GAIN;
	Dpwm1Regs.DPWMCTRL2.bit.SAMPLE_TRIG1_OVERSAMPLE = pfc_config_in_ram.FILTERMISC.bit.SAMPLE_TRIG1_OVERSAMPLE;
}
	

	


