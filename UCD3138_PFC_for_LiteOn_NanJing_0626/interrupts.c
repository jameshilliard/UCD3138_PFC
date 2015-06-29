//interrupt.c

#include "include.h"

extern void zoiw_end(void); //used to find end of zoiw code.
extern void zero_integrity_word(void); //start of zoiw code.

typedef void (*FUNC_PTR)(); //used for zeroing instruction word.

#pragma INTERRUPT(undefined_instruction_exception,UDEF)
void undefined_instruction_exception(void)
{
}
#define	PCTRL_CLK_DIV_1		(0)		// ICLK = SYSCLK/1	
#define PCTRL_FASTEST	((PCTRL_CLK_DIV_1 << 1) | (1<<0))

Uint32 pctrl_original;
#pragma INTERRUPT(software_interrupt,SWI)
void software_interrupt(Uint32 arg1, Uint32 arg2, Uint32 arg3, Uint8 swi_number)
{
	//make sure interrupts are disabled
    asm(" MRS     r4, cpsr "); 		// get psr
    asm(" ORR     r4, r4, #0xc0 "); // set interrupt disables
    asm(" MSR     cpsr_cf, r4"); 		// restore psr

	switch (swi_number) //handle flash write/erase and ROM backdoor first
	{
		case 0: // Erase one segment of Data Flash
		{
			return;
		} 
		case 1: 	
	//--------------------------------------------------------------------------------------
	// SWI ALIAS: erase_dflash_segment_no_delay()
	// 	Erase one segment of Data Flash and return without waiting for completion.
	//--------------------------------------------------------------------------------------
		{
	        union DFLASHCTRL_REG dflashctrl_shadow;	// Shadow copy of control register
			
			if (arg1 >= DATA_FLASH_NUM_SEGMENTS)	
			{
				return;		// Invalid segment number
			}
			DecRegs.FLASHILOCK.all = 0x42DC157E; //unlock flash write;
  			// Set the bits in the Data Flash Control Register to erase the indicated segment
			dflashctrl_shadow.all = DecRegs.DFLASHCTRL.all;	// Read the hardware register
			dflashctrl_shadow.bit.PAGE_ERASE = 1; 			// Erase one segment
			dflashctrl_shadow.bit.PAGE_SEL = arg1;		// Segment number
			DecRegs.DFLASHCTRL.all = dflashctrl_shadow.all;	// Write the hardware register
			if (swi_number == 1)	// 0= Wait for erase to complete, 1= return immediately
		    {
			  return;
		    }
			while(DecRegs.DFLASHCTRL.bit.BUSY != 0)
			{
				; //do nothing while it programs
			}
			return;
		
		}
		case 3: //write word to data flash

			if(((arg1) < DATA_FLASH_START_ADDRESS) ||
		   ((arg1) > DATA_FLASH_END_ADDRESS))
				{//if out of data flash range
				return;
				}

			//this clears read only bit to permit writes to data flash.
			DecRegs.FLASHILOCK.all = 0x42DC157E; //unlock flash write

			DecRegs.MFBALR2.bit.BLOCK_SIZE =2;
			DecRegs.MFBALR2.bit.ADDRESS = 0x22;
			DecRegs.MFBALR2.bit.RONLY = 0;
			 	
			//put data in word.
			*(Uint32 *)(arg1 & 0xfffffffc) = arg2 ;

 		    DecRegs.MFBALR2.bit.RONLY = 1;

			while(DecRegs.DFLASHCTRL.bit.BUSY != 0)
			{
				; //do nothing while it programs
			}
			return;

			 //handle interrupt enables/disables next
		case 4: //enable fiq
	        asm(" MRS     r0, spsr "); //get saved psr
	        asm(" BIC     r0, r0, #0x40 "); // clear fiq disable
	        asm(" MSR     spsr_cf, r0"); //restore saved psr
			return;
		case 5: //disable fiq
	        asm(" MRS     r0, spsr "); //get saved psr
	        asm(" ORR     r0, r0, #0x40 "); // set fiq disable
	        asm(" MSR     spsr_cf, r0"); //restore saved psr
			return;
		case 6: //enable irq
	        asm(" MRS     r0, spsr "); //get saved psr
	        asm(" BIC     r0, r0, #0x80 "); // clear irq disable
	        asm(" MSR     spsr_cf, r0"); //restore saved psr
			return;
		case 7: //disable irq
	        asm(" MRS     r0, spsr "); //get saved psr
	        asm(" ORR     r0, r0, #0x80 "); // set irq disable
	        asm(" MSR     spsr_cf, r0"); //restore saved psr
			return;
		case 8: //write to fiq/irq program_control_register
			CimRegs.FIRQPR.all = arg1;
			return;
		case 9: //write to fiq/irq program_control_register
			CimRegs.REQMASK.all = arg1;
			return;
 		case 12: // clear integrity word.
			DecRegs.FLASHILOCK.all = 0x42DC157E;// Write key to Flash Interlock Register

			// Execute the function in Data Flash that will erase the integrity word in PFlash.
			//zero_integrity_word();

			{
				register Uint32 * program_index = (Uint32 *) 0x19000;	//store destination address for erase checksum program
				register Uint32 * source_index = (Uint32 *)zero_integrity_word; //Set source address of PFLASH;

				register Uint32 zoiw_size = (Uint32 *)zoiw_end - (Uint32 *)zero_integrity_word;//Calculate lenght
				register Uint32 counter;

				for(counter=0; counter < zoiw_size; counter++)	//Copy program from PFLASH to RAM
				{
					*(program_index++)=*(source_index++);
				}
			}
			{
				register FUNC_PTR func_ptr;
				func_ptr=(FUNC_PTR)0x19000;		//Set func_ptr to point to function copied to RAM
				func_ptr();
				func_ptr=(FUNC_PTR)0x70000;
				func_ptr();	
                func_ptr=(FUNC_PTR)0x10000;     //Set function to invalid location to cause reset of part.
                func_ptr();
                func_ptr=(FUNC_PTR)0x70000;
                func_ptr(); 
			}								//execute erase checksum


			// Execute the function in Data Flash that will erase the integrity word in PFlash.
//			zero_integrity_word();
		
			return;
	    case 13: //write block to data flash
			//--------------------------------------------------------------------------------------
		// SWI ALIAS: write_data_flash_block()
		// 	Copies a block of data from a source (typically RAM) to a destination in Data Flash.
		// Handles locking and unlocking the read-only bit.
		// Includes necessary delays while writing.
		// Assumptions:  
		//	Destination address is in Data Flash.
		//	Destination addresses start and end on word boundary.
		//	Source addresses start and end on word boundaries.
		//--------------------------------------------------------------------------------------
		{
			volatile Uint32* dest_ptr = (volatile Uint32*)(arg1 & 0xfffffffc);
			Uint32*	src_ptr =  (Uint32*)(arg2);
			int32	byte_counter = (int32)arg3;	// Use int instead of Uint in case count is not a multiple of 4

			// Validate that destination address is in Data Flash
			if(  ((arg1) < DATA_FLASH_START_ADDRESS)
	 	       ||((arg1) > DATA_FLASH_END_ADDRESS)  )
			{//if out of data flash range
				flash_write_status = FLASH_INVALID_ADDRESS;
				return;	// Return without writing to DFlash
			}

			// Clear read-only bit to allow writes to Data Flash.
			DecRegs.MFBALR2.bit.RONLY = 0;	
			
			// Copy a block of RAM to DFlash						     
			while (byte_counter > 0)
			{
				Uint32	temp_word = *src_ptr++;
				DecRegs.FLASHILOCK.all = 0x42DC157E; //unlock flash write
				// Write the temp word to DFlash.
				*dest_ptr = temp_word;

				// *** Should add value to checksum.
				// checksum += temp.word;

				// Wait for any previous writes to complete.
				while(DecRegs.DFLASHCTRL.bit.BUSY != 0)
				{
					; //do nothing while it programs
				}

				// Read back value from DFlash. Abort if it does not match intended value.
				if (*dest_ptr != temp_word)
				{
					// Set an error flag to indicate write failure.
					flash_write_status = FLASH_MISCOMPARE;
					return;	
				}

				dest_ptr++;
				byte_counter -= 4;
			}

			// Set read-only bit to protect Data Flash
			DecRegs.MFBALR2.bit.RONLY = 1;
			flash_write_status = FLASH_SUCCESS;
			return;
		}
		case 20: // set tfa mode - speed up iclk
			// Speed up the peripheral interface clock (ICLK) so that peripheral reads and 
			// writes have fewer wait states.  Changing the ICLK divider does not affect
			// the EADC and DPWM peripherals; it only affects the MMC that inserts wait 
			// states between the CPU and the peripherals.
			// Changing the ICLK divider does affect some other peripherals (e.g. PMBus
			// and periodic timer), but they are not used during TFA.
			pctrl_original = MmcRegs.PCTRL.all;			// Grab a snapshot of original setting
			MmcRegs.PCTRL.all =   PCTRL_FASTEST;
 			return;
 		case 21: // clear tfa mode - return to original iclk
			MmcRegs.PCTRL.all = pctrl_original;			
 			return;

		default:
			break;
	}
}

#pragma INTERRUPT(abort_prefetch_exception,PABT)
void abort_prefetch_exception(void)
{
}

#pragma INTERRUPT(abort_data_fetch_exception,DABT)
void abort_data_fetch_exception(void)
{
}

#pragma INTERRUPT(fast_interrupt,FIQ)
void fast_interrupt(void)
{
	volatile int32 temp;

	turn_off_pfc();

	iv.supply_state = STATE_PFC_SHUT_DOWN;

	temp = FaultMuxRegs.FAULTMUXINTSTAT.all;//read to clear the interrupt flag
}


